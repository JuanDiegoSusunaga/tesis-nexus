module

public import Mathlib.NumberTheory.LucasPrimality
public import Mathlib.Algebra.Field.ZMod
public import Mathlib.Algebra.QuadraticAlgebra.Basic
public import Mathlib.FieldTheory.Finite.Basic
public import Mathlib.RingTheory.RootsOfUnity.PrimitiveRoots
public import Mathlib.Algebra.Polynomial.SpecificDegree
import Mathlib.Tactic

public section

namespace Nexus.Goldilocks

/-- Módulo de `field.rs`, escrito como entero exacto. -/
@[expose] def p : ℕ := 18446744069414584321

/-- Fórmula del primo en el manuscrito. -/
theorem modulo : p = 2 ^ 64 - 2 ^ 32 + 1 := by norm_num [p]

theorem factorizacion : p - 1 = 2 ^ 32 * 3 * 5 * 17 * 257 * 65537 := by
  norm_num [p]

theorem potencia_generador : (7 : ZMod p) ^ (p - 1) = 1 := by
  unfold p
  norm_num only [Nat.reduceSub]
  reduce_mod_char

theorem criterio_euler_siete : (7 : ZMod p) ^ ((p - 1) / 2) = -1 := by
  unfold p
  norm_num only [Nat.reduceSub, Nat.reduceDiv]
  reduce_mod_char

theorem factores_primos (q : ℕ) (hq : q.Prime) (hd : q ∣ p - 1) :
    q = 2 ∨ q = 3 ∨ q = 5 ∨ q = 17 ∨ q = 257 ∨ q = 65537 := by
  rw [factorizacion] at hd
  have h2 : q ∣ 2 ^ 32 ↔ q = 2 := by
    constructor
    · intro h
      exact (Nat.prime_dvd_prime_iff_eq hq Nat.prime_two).mp (hq.dvd_of_dvd_pow h)
    · rintro rfl
      norm_num
  have h3 : Nat.Prime 3 := by norm_num
  have h5 : Nat.Prime 5 := by norm_num
  have h17 : Nat.Prime 17 := by norm_num
  have h257 : Nat.Prime 257 := by norm_num
  have h65537 : Nat.Prime 65537 := by norm_num
  simpa only [hq.dvd_mul, h2, Nat.prime_dvd_prime_iff_eq hq h3,
    Nat.prime_dvd_prime_iff_eq hq h5, Nat.prime_dvd_prime_iff_eq hq h17,
    Nat.prime_dvd_prime_iff_eq hq h257, Nat.prime_dvd_prime_iff_eq hq h65537,
    or_assoc] using hd

/-- Certificado de Lucas: cada factor primo de p-1 descarta un orden menor. -/
theorem certificado_lucas (q : ℕ) (hq : q.Prime) (hd : q ∣ p - 1) :
    (7 : ZMod p) ^ ((p - 1) / q) ≠ 1 := by
  rcases factores_primos q hq hd with rfl | rfl | rfl | rfl | rfl | rfl
  all_goals
    unfold p
    norm_num only [Nat.reduceSub, Nat.reduceDiv]
    reduce_mod_char
    decide

/-- La primalidad se prueba; no se toma como hipótesis del campo. -/
theorem primo : Nat.Prime p :=
  lucas_primality p 7 potencia_generador certificado_lucas

instance : Fact p.Prime := ⟨primo⟩

abbrev Fp := ZMod p

theorem generador_primitivo : IsPrimitiveRoot (7 : Fp) (p - 1) := by
  apply IsPrimitiveRoot.iff_orderOf.mpr
  exact orderOf_eq_of_pow_and_pow_div_prime (by norm_num [p])
    potencia_generador certificado_lucas

/-- La expresión matemática de `root_of_unity(k)`; se exige k≤32 en el teorema. -/
@[expose] def raiz (k : ℕ) : Fp := 7 ^ ((p - 1) / 2 ^ k)

theorem exponente_desplazamiento (k : ℕ) : (p - 1) >>> k = (p - 1) / 2 ^ k :=
  Nat.shiftRight_eq_div_pow _ _

theorem raiz_maxima_valor : raiz 32 = 1753635133440165772 := by
  unfold raiz Fp p
  norm_num only [Nat.reduceSub, Nat.reducePow, Nat.reduceDiv]
  reduce_mod_char

theorem raiz_primitiva (k : ℕ) (hk : k ≤ 32) : IsPrimitiveRoot (raiz k) (2 ^ k) := by
  have hd : 2 ^ k ∣ p - 1 := by
    apply dvd_trans (show 2 ^ k ∣ 2 ^ 32 from ?_) (by norm_num [p])
    exact ⟨2 ^ (32 - k), by rw [← pow_add, Nat.add_sub_of_le hk]⟩
  exact generador_primitivo.pow (by norm_num [p])
    (by simpa only [Nat.mul_comm] using (Nat.mul_div_cancel' hd).symm)

/-- g=omega^8 para T=2^k y N=8T, como exige el dominio AIR/LDE. -/
theorem coherencia_raices (k : ℕ) (hk : k + 3 ≤ 32) : raiz (k + 3) ^ 8 = raiz k := by
  have hd : 2 ^ (k + 3) ∣ p - 1 := by
    apply dvd_trans (show 2 ^ (k + 3) ∣ 2 ^ 32 from ?_) (by norm_num [p])
    exact ⟨2 ^ (32 - (k + 3)), by rw [← pow_add, Nat.add_sub_of_le hk]⟩
  obtain ⟨m, hm⟩ := hd
  unfold raiz
  rw [← pow_mul]
  congr 1
  rw [hm]
  have hpos : 0 < 2 ^ k := by positivity
  rw [Nat.mul_div_cancel_left m (by positivity)]
  rw [pow_add]
  norm_num only [Nat.reducePow]
  rw [Nat.mul_assoc, Nat.mul_div_cancel_left _ hpos, Nat.mul_comm]

theorem siete_no_cuadrado : ¬ IsSquare (7 : Fp) := by
  rintro ⟨x, hx⟩
  have hx0 : x ≠ 0 := by
    intro h
    subst x
    have h7 : (7 : Fp) ≠ 0 := by decide
    exact h7 (by simpa using hx)
  have hfermat := ZMod.pow_card_sub_one_eq_one hx0
  have hexp : 2 * ((p - 1) / 2) = p - 1 := by norm_num [p]
  have hcontra : (-1 : Fp) = 1 := calc
    -1 = (7 : Fp) ^ ((p - 1) / 2) := criterio_euler_siete.symm
    _ = x ^ (p - 1) := by rw [hx, ← sq, ← pow_mul, hexp]
    _ = 1 := hfermat
  have hne : (-1 : Fp) ≠ 1 := by decide
  exact hne hcontra

instance : Fact (¬ IsSquare (7 : Fp)) := ⟨siete_no_cuadrado⟩

/-- Pares (c0,c1) con X²=7, la misma presentación algebraica de `Fp2`. -/
abbrev Fp2 := QuadraticAlgebra Fp 7 0

instance : Fintype Fp2 :=
  Fintype.ofEquiv (Fp × Fp) (QuadraticAlgebra.equivProd (7 : Fp) 0).symm

theorem cardinal_base : Fintype.card Fp = p := ZMod.card p

theorem cardinal_extension : Fintype.card Fp2 = p ^ 2 := by
  rw [Fintype.card_congr (QuadraticAlgebra.equivProd (7 : Fp) 0), Fintype.card_prod,
    cardinal_base, pow_two]

/-- X²-7 es irreducible en el campo base, por ausencia de raíces. -/
theorem irreducible_extension : Irreducible (Polynomial.X ^ 2 - Polynomial.C (7 : Fp)) := by
  apply Polynomial.irreducible_of_degree_le_three_of_not_isRoot
  · norm_num [Polynomial.natDegree_X_pow_sub_C]
  · intro x hx
    apply siete_no_cuadrado
    refine ⟨x, ?_⟩
    simpa [Polynomial.IsRoot, sq] using (sub_eq_zero.mp
      (by simpa using hx : x ^ 2 - 7 = 0)).symm

/-- Las dos coordenadas de la multiplicación escrita en `Fp2::mul`. -/
theorem multiplicacion_extension (a b : Fp2) :
    (a * b).re = a.re * b.re + 7 * a.im * b.im ∧
    (a * b).im = a.re * b.im + a.im * b.re := by
  constructor <;> simp

theorem norma_extension (a : Fp2) :
    QuadraticAlgebra.norm a = a.re ^ 2 - 7 * a.im ^ 2 := by
  simp only [QuadraticAlgebra.norm_def, zero_mul, add_zero]
  ring

theorem norma_no_nula (a : Fp2) (ha : a ≠ 0) :
    a.re ^ 2 - 7 * a.im ^ 2 ≠ 0 := by
  rw [← norma_extension]
  exact mt QuadraticAlgebra.norm_eq_zero_iff_eq_zero.mp ha

/-- Fórmula del inverso escrito en `Fp2::inv`, también válida en cero en Lean. -/
theorem inverso_extension (a : Fp2) :
    (a⁻¹).re = a.re / (a.re ^ 2 - 7 * a.im ^ 2) ∧
    (a⁻¹).im = -a.im / (a.re ^ 2 - 7 * a.im ^ 2) := by
  simp [QuadraticAlgebra.inv_def, norma_extension, div_eq_mul_inv, mul_comm]

example : Field Fp2 := inferInstance

end Nexus.Goldilocks
