module

public import Nexus.Modelos.ResidenciaIntegral
public import Mathlib.Probability.Distributions.Uniform
import Mathlib.Tactic

/-!
# Coincidencia temporal de una captura uniforme

Modelo ideal de §5.6.2: calendario fijo e instante uniforme. No demuestra
custodia de la semilla, ausencia de residuos ni probabilidad de compromiso.
-/

public section
namespace Nexus.Modelos.Temporal

open Set MeasureTheory ProbabilityTheory
open scoped BigOperators

@[expose] noncomputable def instanteUniforme (T : ℝ) : Measure ℝ := ProbabilityTheory.cond volume (Ioc 0 T)

theorem captura_distribucion (T : ℝ) (hT : 0 < T) : IsProbabilityMeasure (instanteUniforme T) := by
  apply cond_isProbabilityMeasure_of_finite
  · rw [Real.volume_Ioc]
    exact ne_of_gt (ENNReal.ofReal_pos.mpr (by linarith))
  · rw [Real.volume_Ioc]
    exact ENNReal.ofReal_ne_top

theorem probabilidad_recortada (T : ℝ) (hT : 0 < T) (E : Set ℝ) :
    (instanteUniforme T).real E = volume.real (E ∩ Ioc 0 T) / T := by
  unfold instanteUniforme ProbabilityTheory.cond
  rw [measureReal_ennreal_smul_apply, measureReal_restrict_apply' measurableSet_Ioc,
    Real.volume_Ioc, sub_zero, ENNReal.toReal_inv, ENNReal.toReal_ofReal (le_of_lt hT)]
  ring

theorem probabilidad_coincidencia (T : ℝ) (hT : 0 < T) (E : Set ℝ) (hsub : E ⊆ Ioc 0 T) :
    (instanteUniforme T).real E = volume.real E / T := by
  rw [probabilidad_recortada T hT E, inter_eq_left.mpr hsub]

theorem probabilidad_cotas (T : ℝ) (hT : 0 < T) (E : Set ℝ) :
    0 ≤ (instanteUniforme T).real E ∧ (instanteUniforme T).real E ≤ 1 := by
  let := captura_distribucion T hT
  exact ⟨measureReal_nonneg, measureReal_le_one⟩

theorem captura_horizonte (T : ℝ) (hT : 0 < T) : (instanteUniforme T).real (Ioc 0 T) = 1 := by
  rw [probabilidad_coincidencia T hT _ (Subset.refl _), Real.volume_real_Ioc_of_le (le_of_lt hT), sub_zero]
  exact div_self (ne_of_gt hT)

theorem captura_fuera_horizonte (T : ℝ) (hT : 0 < T) (E : Set ℝ) (hd : Disjoint E (Ioc 0 T)) :
    (instanteUniforme T).real E = 0 := by
  rw [probabilidad_recortada T hT E, disjoint_iff_inter_eq_empty.mp hd, measureReal_empty, zero_div]

theorem captura_union {n : ℕ} (T : ℝ) (hT0 : 0 < T) (a b : Fin n → ℝ)
    (h0 : ∀ i, 0 ≤ a i) (hT : ∀ i, b i ≤ T) :
    (instanteUniforme T).real (exposicion a b) = volume.real (exposicion a b) / T :=
  probabilidad_coincidencia T hT0 _ (exposicion_contenida T a b h0 hT)

theorem captura_union_cota {n : ℕ} (T : ℝ) (hT0 : 0 < T) (a b : Fin n → ℝ)
    (h0 : ∀ i, 0 ≤ a i) (hT : ∀ i, b i ≤ T) (hab : ∀ i, a i ≤ b i) :
    (instanteUniforme T).real (exposicion a b) ≤ (∑ i, (b i - a i)) / T := by
  rw [captura_union T hT0 a b h0 hT]
  exact div_le_div_of_nonneg_right (longitud_union_cota a b hab) (le_of_lt hT0)

theorem captura_secuencial {n : ℕ} (T tau : ℝ) (hT0 : 0 < T) (a b : Fin n → ℝ)
    (h0 : ∀ i, 0 ≤ a i) (hT : ∀ i, b i ≤ T) (hab : ∀ i, a i ≤ b i)
    (ht : ∀ i, b i - a i = tau)
    (hd : Pairwise (fun i j => Disjoint (Ioc (a i) (b i)) (Ioc (a j) (b j)))) :
    (instanteUniforme T).real (exposicion a b) = (n : ℝ) / T * tau := by
  rw [captura_union T hT0 a b h0 hT, duracion_fija a b tau hab ht hd]
  ring

theorem captura_complemento (T : ℝ) (hT : 0 < T) (E : Set ℝ) (hE : MeasurableSet E) :
    (instanteUniforme T).real Eᶜ = 1 - (instanteUniforme T).real E := by
  let := captura_distribucion T hT
  have h := probReal_add_probReal_compl (μ := instanteUniforme T) hE
  linarith

theorem captura_variable_uniforme {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) (X : Omega → ℝ) (T : ℝ) (hT : 0 < T)
    (hu : MeasureTheory.pdf.IsUniform X (Ioc 0 T) P volume)
    (E : Set ℝ) (hE : MeasurableSet E) (hsub : E ⊆ Ioc 0 T) :
    P.real (X ⁻¹' E) = volume.real E / T := by
  have h := congrArg ENNReal.toReal (hu.measure_preimage hE)
  rw [inter_eq_right.mpr hsub, ENNReal.toReal_div, Real.volume_Ioc,
    sub_zero, ENNReal.toReal_ofReal (le_of_lt hT)] at h
  exact h

theorem capturas_solapadas_no_suman :
    (instanteUniforme 1).real (exposicion (fun _ : Fin 2 => 0) (fun _ => 1)) = 1 := by
  rw [captura_union 1 (by norm_num) _ _ (by intro i; norm_num) (by intro i; norm_num),
    solapamiento_no_duplica_union.1]
  norm_num

theorem captura_tabla5_2 (i : Fin 5) :
    |100 * (instanteUniforme 1).real (intervaloTabla i) -
      (Nexus.Modelos.Residencia.porcentajes_tabla i : ℝ)| < 1 / 2000 := by
  rw [probabilidad_coincidencia 1 (by norm_num) _ (intervalo_tabla_contenido i), ocupacion_tabla i]
  have h := (Rat.cast_lt (K := ℝ)).mpr (Nexus.Modelos.Residencia.tabla5_2 i).1
  push_cast at h
  simpa only [Rat.cast_mul, mul_assoc] using h

end Nexus.Modelos.Temporal
