module

public import Nexus.FRI.Torre
import Mathlib.Tactic

/-!
# Conteo de los conjuntos excepcionales de una fase FRI

Estas igualdades son deterministas. No suponen retos uniformes ni constituyen
una cota probabilística adaptativa del protocolo conjunto.
-/

public section
namespace Nexus.FRI

open scoped BigOperators
variable {K : Type*} [Field K] {m : ℕ}

theorem grados_por_capa (t : Torre K m) (j : ℕ) (hj : j ≤ m) :
    t.grado j = 2 ^ (m - j) := by
  apply Nat.decreasingInduction (motive := fun j _ => t.grado j = 2 ^ (m - j)) _ _ hj
  · intro i hi hnext
    have hexp : m - i = m - (i + 1) + 1 := by omega
    rw [t.grados i hi, hnext, hexp, pow_succ, Nat.mul_comm]
  · simp only [t.grado_final, Nat.sub_self, pow_zero]

/-- Cada paso divide por dos el dominio; se conserva la cardinalidad exacta. -/
theorem cardinal_por_capa (t : Torre K m) (h2 : (2 : K) ≠ 0)
    (j : ℕ) (hj : j ≤ m) :
    (t.dominio 0).card = 2 ^ j * (t.dominio j).card := by
  induction j with
  | zero => simp
  | succ j ih =>
    have hprev := ih (by omega)
    rw [t.enlace j (by omega),
      cardinal_elevar _ _ (t.cuadrado j (by omega)) (t.noCero j (by omega)) h2] at hprev
    rw [hprev, pow_succ]
    ring

/-- La suma de tamaños de los dominios de reto telescopa exactamente. -/
theorem suma_capas (t : Torre K m) (h2 : (2 : K) ≠ 0) :
    ∑ j : Fin m, (t.dominio (j + 1)).card = (t.dominio 0).card - (t.dominio m).card := by
  have htel : ∀ j (hj : j ≤ m),
      (∑ i ∈ Finset.range j, (t.dominio (i + 1)).card) + (t.dominio j).card =
        (t.dominio 0).card := by
    intro j hj
    induction j with
    | zero => simp
    | succ j ih =>
      have hprev := ih (by omega)
      rw [t.enlace j (by omega),
        cardinal_elevar _ _ (t.cuadrado j (by omega)) (t.noCero j (by omega)) h2] at hprev
      rw [Finset.sum_range_succ]
      omega
  rw [Fin.sum_univ_eq_sum_range (fun i => (t.dominio (i + 1)).card)]
  have h := htel m (Nat.le_refl _)
  omega

/-- Un código final de constantes conserva el cociente |L|/d del dominio inicial. -/
theorem cardinal_final (t : Torre K m) (h2 : (2 : K) ≠ 0) (R : ℕ)
    (hsize : (t.dominio 0).card = R * t.grado 0) : (t.dominio m).card = R := by
  have hc := cardinal_por_capa t h2 m (Nat.le_refl _)
  have hd := grados_por_capa t 0 (Nat.zero_le _)
  simp only [Nat.sub_zero] at hd
  rw [hsize, hd, Nat.mul_comm R] at hc
  exact (Nat.mul_left_cancel (by positivity : 0 < 2 ^ m) hc).symm

theorem suma_excepciones (t : Torre K m) (h2 : (2 : K) ≠ 0)
    (E : Fin m → Finset K) (hE : ∀ j, (E j).card ≤ (t.dominio (j + 1)).card) :
    ∑ j : Fin m, (E j).card ≤ (t.dominio 0).card - (t.dominio m).card := by
  calc
    _ ≤ ∑ j : Fin m, (t.dominio (j + 1)).card := Finset.sum_le_sum (fun j _ => hE j)
    _ = _ := suma_capas t h2

end Nexus.FRI
