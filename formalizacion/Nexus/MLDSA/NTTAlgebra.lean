module

public import Nexus.MLDSA.Parametros
public import Mathlib.LinearAlgebra.Lagrange
import Mathlib.Tactic

/-!
# Corrección algebraica de una transformada radix dos

Los coeficientes se almacenan en el árbol par/impar. El algoritmo combina
dos transformadas de mitad de tamaño mediante mariposas y devuelve las
evaluaciones en orden natural. El orden del backend, Montgomery y enteros
de máquina todavía necesitan un refinamiento separado.
-/

public section
namespace Nexus.MLDSA.NTTAlgebra

open Polynomial
universe u
variable {K : Type*} [Field K]

@[expose] def Datos (K : Type u) : ℕ → Type u
  | 0 => K
  | r + 1 => Datos K r × Datos K r

@[expose] noncomputable def polinomio : (r : ℕ) → Datos K r → Polynomial K
  | 0, c => C c
  | r + 1, v => (polinomio r v.1).comp (X ^ 2) + X * (polinomio r v.2).comp (X ^ 2)

@[expose] noncomputable def transformar : (r : ℕ) → Datos K r → K → K → ℕ → K
  | 0, c, _, _, _ => c
  | r + 1, v, omega, offset, i =>
      let a := i % 2 ^ r
      let even := transformar r v.1 (omega ^ 2) (offset ^ 2) a
      let odd := transformar r v.2 (omega ^ 2) (offset ^ 2) a
      if i < 2 ^ r then even + offset * omega ^ a * odd
      else even - offset * omega ^ a * odd

theorem evaluacion_nodo (r : ℕ) (v : Datos K (r + 1)) (x : K) :
    (polinomio (r + 1) v).eval x =
      (polinomio r v.1).eval (x ^ 2) + x * (polinomio r v.2).eval (x ^ 2) := by
  simp [polinomio, Polynomial.eval_comp]

theorem grado_polinomio (r : ℕ) (v : Datos K r) : (polinomio r v).natDegree < 2 ^ r := by
  induction r with
  | zero => exact (Polynomial.natDegree_C (R := K) v).trans_lt (by norm_num)
  | succ r ih =>
    have he := Polynomial.natDegree_comp_le (p := polinomio r v.1) (q := (X : Polynomial K) ^ 2)
    have ho := Polynomial.natDegree_comp_le (p := polinomio r v.2) (q := (X : Polynomial K) ^ 2)
    have hm := Polynomial.natDegree_mul_le (p := (X : Polynomial K))
      (q := (polinomio r v.2).comp (X ^ 2))
    simp only [Polynomial.natDegree_X_pow, Polynomial.natDegree_X] at he ho hm
    have hev := ih v.1
    have hov := ih v.2
    unfold polinomio
    apply lt_of_le_of_lt (Polynomial.natDegree_add_le _ _)
    have hexp : 2 ^ (r + 1) = 2 * 2 ^ r := by rw [pow_succ]; omega
    rw [max_lt_iff, hexp]
    constructor <;> omega

theorem raiz_mitad (r : ℕ) (omega : K) (h : IsPrimitiveRoot omega (2 ^ (r + 1))) :
    omega ^ (2 ^ r) = -1 := by
  apply IsPrimitiveRoot.eq_neg_one_of_two_right
  exact h.pow (by positivity) (by rw [pow_succ])

theorem raiz_siguiente (r : ℕ) (omega : K) (h : IsPrimitiveRoot omega (2 ^ (r + 1))) :
    IsPrimitiveRoot (omega ^ 2) (2 ^ r) := by
  exact h.pow (by positivity) (by rw [pow_succ]; omega)

theorem transformada_correcta (r : ℕ) (v : Datos K r) (omega offset : K)
    (h : IsPrimitiveRoot omega (2 ^ r)) (i : ℕ) (hi : i < 2 ^ r) :
    transformar r v omega offset i = (polinomio r v).eval (offset * omega ^ i) := by
  induction r generalizing omega offset i with
  | zero => exact Polynomial.eval_C.symm
  | succ r ih =>
    have ha : i % 2 ^ r < 2 ^ r := Nat.mod_lt _ (by positivity)
    have hw := raiz_siguiente r omega h
    have hs : offset ^ 2 * (omega ^ 2) ^ (i % 2 ^ r) = (offset * omega ^ (i % 2 ^ r)) ^ 2 := by
      rw [mul_pow, ← pow_mul, Nat.mul_comm 2, pow_mul]
    rw [transformar, ih v.1 (omega ^ 2) (offset ^ 2) hw _ ha,
      ih v.2 (omega ^ 2) (offset ^ 2) hw _ ha, hs, evaluacion_nodo]
    by_cases hil : i < 2 ^ r
    · simp only [hil, ite_true, Nat.mod_eq_of_lt hil]
    · have hsize : 2 ^ (r + 1) = 2 * 2 ^ r := by rw [pow_succ]; omega
      have hq : i / 2 ^ r = 1 := Nat.div_eq_of_lt_le (by omega) (by omega)
      have he := Nat.mod_add_div i (2 ^ r)
      rw [hq, Nat.mul_one] at he
      have hpoint : offset * omega ^ i = -(offset * omega ^ (i % 2 ^ r)) := by
        calc
          _ = offset * omega ^ (i % 2 ^ r + 2 ^ r) := congrArg (fun a => offset * omega ^ a) he.symm
          _ = _ := by rw [pow_add, raiz_mitad r omega h]; ring
      rw [ite_eq_right hil, hpoint, neg_sq]
      ring

theorem evaluaciones_determinan (r : ℕ) (omega offset : K)
    (h : IsPrimitiveRoot omega (2 ^ r)) (hoff : offset ≠ 0)
    (f g : Polynomial K) (hf : f.degree < (2 ^ r : ℕ)) (hg : g.degree < (2 ^ r : ℕ))
    (he : ∀ i < 2 ^ r, f.eval (offset * omega ^ i) = g.eval (offset * omega ^ i)) : f = g := by
  apply Polynomial.eq_of_degrees_lt_of_eval_index_eq (Finset.range (2 ^ r))
    (by simpa only [mul_comm] using h.injOn_pow_mul (α := offset) hoff)
  · simpa only [Finset.card_range] using hf
  · simpa only [Finset.card_range] using hg
  · intro i hi
    exact he i (Finset.mem_range.mp hi)

theorem mldsa_256 (v : Datos Fq 8) (i : ℕ) (hi : i < 256) :
    transformar 8 v (zeta ^ 2) zeta i = (polinomio 8 v).eval (zeta * (zeta ^ 2) ^ i) := by
  exact transformada_correcta 8 v (zeta ^ 2) zeta raiz_ciclica i hi

end Nexus.MLDSA.NTTAlgebra
