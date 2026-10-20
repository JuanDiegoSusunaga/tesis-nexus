module

public import Nexus.N03.CampoBase
public import Nexus.N03.Solucion
public import Nexus.AIR.Goldilocks
import Mathlib.Tactic

public section
namespace Nexus.Goldilocks

open Polynomial

theorem fraccion_no_base_perfil (k : ℕ) (hk : k ≤ 29) (u : Fp2 → Fp2)
    (f : Polynomial Fp2) (hf : f.natDegree < 2 ^ k)
    (hno : ¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f)
    (δ : ℚ) (hu : Nexus.distancia (cosetExtension (k + 3)) u f.eval ≤ δ) :
    1 - (2 ^ k - 1 : ℕ) / (8 * (2 ^ k : ℕ) : ℚ) - δ ≤
      fraccionFueraBase (cosetExtension (k + 3)) u := by
  have hcard : (coset (k + 3)).card = 8 * 2 ^ k := by
    rw [cardinal_coset _ (by omega), pow_add]
    norm_num [Nat.mul_comm]
  have h := fraccion_oraculo_no_base (coset (k + 3)) (by rw [hcard]; positivity)
    u f (2 ^ k) hf hno δ (by simpa only [cosetExtension] using hu)
  simpa only [cosetExtension, hcard, Nat.cast_mul, Nat.cast_ofNat] using h

theorem fraccion_no_base_perfil_real (k : ℕ) (hk : k ≤ 29) (u : Fp2 → Fp2)
    (f : Polynomial Fp2) (hf : f.natDegree < 2 ^ k)
    (hno : ¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f)
    (δ : ℝ) (hu : (Nexus.distancia (cosetExtension (k + 3)) u f.eval : ℝ) ≤ δ) :
    1 - (2 ^ k - 1 : ℕ) / (8 * (2 ^ k : ℕ) : ℝ) - δ ≤
      (fraccionFueraBase (cosetExtension (k + 3)) u : ℝ) := by
  have hcard : (coset (k + 3)).card = 8 * 2 ^ k := by
    rw [cardinal_coset _ (by omega), pow_add]
    norm_num [Nat.mul_comm]
  have h := fraccion_oraculo_no_base_real (coset (k + 3)) (by rw [hcard]; positivity)
    u f (2 ^ k) hf hno δ (by simpa only [cosetExtension] using hu)
  simpa only [cosetExtension, hcard, Nat.cast_mul, Nat.cast_ofNat] using h

theorem margen_no_base (T : ℕ) (hT : 0 < T) (δ : ℚ) (hδ : δ ≤ 1 / 8) :
    (3 : ℚ) / 4 < 1 - (T - 1 : ℕ) / (8 * T : ℚ) - δ := by
  have hTq : (0 : ℚ) < T := by exact_mod_cast hT
  have hsub : ((T - 1 : ℕ) : ℚ) = T - 1 := by
    rw [Nat.cast_sub (by omega)]
    norm_num
  have heq : 1 - (T - 1 : ℕ) / (8 * T : ℚ) - (1 / 8 : ℚ) =
      3 / 4 + 1 / (8 * T : ℚ) := by
    rw [hsub]
    field_simp
    ring
  calc
    (3 : ℚ) / 4 < 3 / 4 + 1 / (8 * T : ℚ) := lt_add_of_pos_right _ (by positivity)
    _ = _ := heq.symm
    _ ≤ _ := by linarith

theorem fraccion_no_base_mayor_tres_cuartos (k : ℕ) (hk : k ≤ 29) (u : Fp2 → Fp2)
    (f : Polynomial Fp2) (hf : f.natDegree < 2 ^ k)
    (hno : ¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f)
    (δ : ℚ) (hδ : δ ≤ 1 / 8)
    (hu : Nexus.distancia (cosetExtension (k + 3)) u f.eval ≤ δ) :
    (3 : ℚ) / 4 < fraccionFueraBase (cosetExtension (k + 3)) u :=
  (margen_no_base (2 ^ k) (by positivity) δ hδ).trans_le
    (fraccion_no_base_perfil k hk u f hf hno δ hu)

theorem comparacion_ramas (T : ℕ) (hT : 0 < T) (δt δc : ℚ)
    (ht : 0 ≤ δt) (hc : 0 ≤ δc) :
    (5 * T + 1 : ℚ) / (8 * T : ℚ) - 3 * δt - δc + 1 / 4 ≤
      1 - (T - 1 : ℕ) / (8 * T : ℚ) - δt := by
  have hTq : (0 : ℚ) < T := by exact_mod_cast hT
  have hsub : ((T - 1 : ℕ) : ℚ) = T - 1 := by
    rw [Nat.cast_sub (by omega)]
    norm_num
  have heq : 1 - (T - 1 : ℕ) / (8 * T : ℚ) - δt =
      (5 * T + 1 : ℚ) / (8 * T : ℚ) - 3 * δt - δc + 1 / 4 + 2 * δt + δc := by
    rw [hsub]
    field_simp
    ring
  rw [heq]
  linarith

/-- La rama no base supera por al menos 1/4 la cota d de la rama de composición. -/
theorem deteccion_no_base_perfil (k : ℕ) (hk : k ≤ 29) (u : Fp2 → Fp2)
    (f : Polynomial Fp2) (hf : f.natDegree < 2 ^ k)
    (hno : ¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f)
    (δt δc : ℚ) (ht : 0 ≤ δt) (hc : 0 ≤ δc)
    (hu : Nexus.distancia (cosetExtension (k + 3)) u f.eval ≤ δt) :
    (5 * (2 ^ k : ℕ) + 1 : ℚ) / (8 * (2 ^ k : ℕ) : ℚ) - 3 * δt - δc + 1 / 4 ≤
      fraccionFueraBase (cosetExtension (k + 3)) u :=
  (comparacion_ramas (2 ^ k) (by positivity) δt δc ht hc).trans
    (fraccion_no_base_perfil k hk u f hf hno δt hu)

/-- Para δ≤1/8, el perfil concreto admite a lo sumo un candidato de grado<T. -/
theorem unicidad_perfil (k : ℕ) (hk : k ≤ 29) (u : Fp2 → Fp2)
    (f g : Polynomial Fp2) (hf : f.natDegree < 2 ^ k) (hg : g.natDegree < 2 ^ k)
    (δ : ℚ) (hδ : δ ≤ 1 / 8)
    (huf : Nexus.distancia (cosetExtension (k + 3)) u f.eval ≤ δ)
    (hug : Nexus.distancia (cosetExtension (k + 3)) u g.eval ≤ δ) : f = g := by
  have hcard : (cosetExtension (k + 3)).card = 8 * 2 ^ k := by
    rw [cardinal_coset_extension _ (by omega), pow_add]
    norm_num [Nat.mul_comm]
  have hT : 0 < 2 ^ k := by positivity
  have hTq : (0 : ℚ) < 2 ^ k := by positivity
  apply Nexus.N03.unicidad _ u f g (2 ^ k) δ
  · rw [hcard]
    positivity
  · rw [hcard]
    omega
  · exact hf
  · exact hg
  · rw [hcard, Nat.cast_add, Nat.cast_sub (show 2 ^ k ≤ 8 * 2 ^ k by omega)]
    push_cast
    apply (lt_div_iff₀ (show (0 : ℚ) < 8 * 2 ^ k by positivity)).mpr
    have hd := mul_le_mul_of_nonneg_right hδ (show (0 : ℚ) ≤ 8 * 2 ^ k by positivity)
    nlinarith
  · exact huf
  · exact hug

end Nexus.Goldilocks
