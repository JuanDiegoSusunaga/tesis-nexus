module

public import Nexus.Campos.Goldilocks
public import Nexus.AIR.Solucion
public import Nexus.AIR.Grados
public import Nexus.N02.Solucion
import Mathlib.Tactic

public section
namespace Nexus.Goldilocks

open Polynomial

/-- Inmersión de la raíz de filas en el campo de los retos. -/
@[expose] noncomputable def raizExtension (k : ℕ) : Fp2 := algebraMap Fp Fp2 (raiz k)

theorem raiz_extension_primitiva (k : ℕ) (hk : k ≤ 32) :
    IsPrimitiveRoot (raizExtension k) (2 ^ k) :=
  (raiz_primitiva k hk).map_of_injective (algebraMap Fp Fp2).injective

/-- Equivalencia AIR sin una hipótesis adicional de primalidad ni de orden. -/
theorem air_concreto (k : ℕ) (hk0 : 2 ≤ k) (hk : k ≤ 32)
    (f : Polynomial Fp2) (s o : Fp2) :
    Nexus.AIR.Valida (raizExtension k) (2 ^ k) f s o ↔
    Nexus.AIR.ResiduosNulos (raizExtension k) (2 ^ k) f s o := by
  apply Nexus.AIR.validez_iff_residuos _ _ f s o _ (raiz_extension_primitiva k hk)
  have h : 2 ^ 2 ≤ 2 ^ k := Nat.pow_le_pow_right (by decide) hk0
  omega

/-- Cota 1/p² instanciada en la extensión construida y la traza AIR fija. -/
theorem cancelacion_concreta (k : ℕ) (hk0 : 2 ≤ k) (hk : k ≤ 32)
    (f : Polynomial Fp2) (s o : Fp2)
    (hf : ¬ Nexus.AIR.Valida (raizExtension k) (2 ^ k) f s o) :
    Nexus.N01.probabilidad
      (Nexus.AIR.frontera (Nexus.AIR.denominador (2 ^ k)) f s 1 %
        Nexus.AIR.denominador (2 ^ k))
      (Nexus.AIR.frontera (Nexus.AIR.denominador (2 ^ k)) f o
        (raizExtension k ^ (2 ^ k - 1)) % Nexus.AIR.denominador (2 ^ k))
      (Nexus.AIR.numeradorTransicion (raizExtension k) f
        (raizExtension k ^ (2 ^ k - 1)) (raizExtension k ^ (2 ^ k - 2)) %
        Nexus.AIR.denominador (2 ^ k)) ≤ 1 / (p : ℚ) ^ 2 := by
  have hT : 3 ≤ 2 ^ k := by
    have h : 2 ^ 2 ≤ 2 ^ k := Nat.pow_le_pow_right (by decide) hk0
    omega
  simpa [cardinal_extension] using Nexus.AIR.cancelacion_traza_invalida
    (2 ^ k) (raizExtension k) f s o hT (raiz_extension_primitiva k hk) hf

/-- Ningún punto del coset multiplicativo es cero del denominador de filas. -/
theorem coset_sin_polos (N T : ℕ) (hN0 : 0 < N) (hNT : T ∣ N)
    (hN : N < p - 1) (w : Fp) (hw : w ^ N = 1) (i : ℕ) :
    (7 * w ^ i) ^ T ≠ 1 := by
  intro hx
  have hz : (7 * w ^ i) ^ N = 1 := by
    obtain ⟨m, hm⟩ := hNT
    rw [hm, pow_mul, hx, one_pow]
  have hw' : (w ^ i) ^ N = 1 := by
    rw [← pow_mul, Nat.mul_comm, pow_mul, hw, one_pow]
  have h7 : (7 : Fp) ^ N = 1 := by simpa [mul_pow, hw'] using hz
  exact generador_primitivo.pow_ne_one_of_pos_of_lt hN0.ne' hN h7

/-- Dominio L de NTT/LDE, con el desplazamiento 7 del código. -/
@[expose] noncomputable def coset (k : ℕ) : Finset Fp :=
  (Finset.range (2 ^ k)).image (fun i => 7 * raiz k ^ i)

theorem cardinal_coset (k : ℕ) (hk : k ≤ 32) : (coset k).card = 2 ^ k := by
  classical
  rw [coset, Finset.card_image_of_injOn]
  · exact Finset.card_range _
  · simpa only [mul_comm] using
      (raiz_primitiva k hk).injOn_pow_mul (α := (7 : Fp)) (by decide)

/-- T=2^k y N=8T: cubre el perfil TG2 y todo k entre 4 y 29. -/
theorem denominador_no_nulo (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (x : Fp) (hx : x ∈ coset (k + 3)) :
    (Nexus.AIR.denominador (2 ^ k) : Polynomial Fp).eval x ≠ 0 := by
  obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hx
  have hk32 : k + 3 ≤ 32 := by omega
  have hN : 2 ^ (k + 3) < p - 1 := by
    have h : 2 ^ (k + 3) ≤ 2 ^ 32 := Nat.pow_le_pow_right (by decide) (by omega)
    have hp : 2 ^ 32 < p - 1 := by norm_num [p]
    omega
  have hdiv : 2 ^ k ∣ 2 ^ (k + 3) := ⟨2 ^ 3, by rw [pow_add]⟩
  have h := coset_sin_polos (2 ^ (k + 3)) (2 ^ k) (by positivity) hdiv hN
    (raiz (k + 3)) (raiz_primitiva (k + 3) hk32).pow_eq_one i
  simpa [Nexus.AIR.denominador, sub_eq_zero] using h

@[expose] noncomputable def cosetExtension (k : ℕ) : Finset Fp2 :=
  (coset k).image (algebraMap Fp Fp2)

theorem cardinal_coset_extension (k : ℕ) (hk : k ≤ 32) :
    (cosetExtension k).card = 2 ^ k := by
  classical
  rw [cosetExtension, Finset.card_image_of_injective _ (algebraMap Fp Fp2).injective,
    cardinal_coset k hk]

theorem denominador_extension_no_nulo (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (x : Fp2) (hx : x ∈ cosetExtension (k + 3)) :
    (Nexus.AIR.denominador (2 ^ k) : Polynomial Fp2).eval x ≠ 0 := by
  obtain ⟨y, hy, rfl⟩ := Finset.mem_image.mp hx
  intro hz
  apply denominador_no_nulo k hk0 hk y hy
  apply (algebraMap Fp Fp2).injective
  simpa [Nexus.AIR.denominador, map_sub, map_pow] using hz

/-- N02 para el numerador y coset concretos del perfil admitido por TG2.
Solo se exige aparte que el reto no haya cancelado el residuo. -/
theorem distancia_composicion_concreta (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (f : Polynomial Fp2) (s o : Fp2) (a : Nexus.N01.Coeficientes Fp2)
    (hf : f.natDegree < 2 ^ k) (h : Polynomial Fp2) (hh : h.natDegree < 2 * 2 ^ k)
    (hr : Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f s o a %
      Nexus.AIR.denominador (2 ^ k) ≠ 0) :
    (5 * (2 ^ k : ℕ) + 1 : ℚ) / (8 * (2 ^ k : ℕ) : ℚ) ≤
      Nexus.distancia (cosetExtension (k + 3))
        (fun x => (Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f s o a).eval x /
          (Nexus.AIR.denominador (2 ^ k) : Polynomial Fp2).eval x) h.eval := by
  apply Nexus.N02.cota (2 ^ k) (cosetExtension (k + 3))
    (Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f s o a)
    (Nexus.AIR.denominador (2 ^ k)) h (by positivity)
  · rw [cardinal_coset_extension _ (by omega), pow_add]
    norm_num [Nat.mul_comm]
  · exact denominador_extension_no_nulo k hk0 hk
  · exact hr
  · exact Nexus.AIR.grado_numerador_combinado _ _ f s o a (by positivity) hf
  · exact (Nexus.AIR.grado_denominador _).le
  · exact hh

end Nexus.Goldilocks
