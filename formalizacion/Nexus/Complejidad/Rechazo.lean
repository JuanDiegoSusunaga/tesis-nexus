module

public import Mathlib.Probability.Distributions.Geometric
public import Mathlib.Analysis.Asymptotics.Basic
public import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Tactic

/-!
# Intentos geométricos y costo esperado de firma

Modelo ideal IID con probabilidad fija de superar todos los rechazos.
La medida cuenta fallos antes del primer éxito; los intentos son n+1.
No demuestra que las máscaras del ejecutable sean IID ni su conducta al
agotarse el contador de máquina.
-/

public section
namespace Nexus.Complejidad.Rechazo

open MeasureTheory ProbabilityTheory Filter Topology Asymptotics Set
open scoped BigOperators

@[expose] noncomputable def peso (p : unitInterval) (n : ℕ) : ℝ := (1 - (p : ℝ)) ^ n * p
@[expose] noncomputable def esperanza (p : unitInterval) : ℝ :=
  ∫ n : ℕ, ((n + 1 : ℕ) : ℝ) ∂geometricMeasure p
@[expose] noncomputable def aceptacionAcotada (p : unitInterval) (M : ℕ) : ℝ := ∑ n ∈ Finset.range M, peso p n
@[expose] noncomputable def costoEsperado (p : unitInterval) (c : ℝ) : ℝ :=
  ∫ n : ℕ, c * ((n + 1 : ℕ) : ℝ) ∂geometricMeasure p

private theorem parametro_no_cero (p : unitInterval) (hp : 0 < (p : ℝ)) : p ≠ 0 := by
  intro h
  subst p
  norm_num at hp

theorem peso_no_negativo (p : unitInterval) (n : ℕ) : 0 ≤ peso p n := geometricMeasure_nonneg p n

theorem peso_ley (p : unitInterval) (hp : 0 < (p : ℝ)) (n : ℕ) :
    (geometricMeasure p).real {n} = peso p n := geometricMeasure_real_singleton (parametro_no_cero p hp) n

theorem pesos_suman_uno (p : unitInterval) (hp : 0 < (p : ℝ)) : HasSum (peso p) 1 :=
  hasSum_one_geometricMeasure (parametro_no_cero p hp)

theorem probabilidad_primer_intento (p : unitInterval) : peso p 0 = p := by simp [peso]

theorem pesos_recurrencia (p : unitInterval) (n : ℕ) : peso p (n + 1) = (1 - (p : ℝ)) * peso p n := by
  simp only [peso, pow_succ]
  ring

theorem serie_esperanza (p : unitInterval) (hp : 0 < (p : ℝ)) :
    HasSum (fun n : ℕ => peso p n * ((n + 1 : ℕ) : ℝ)) (1 / (p : ℝ)) := by
  have hr : ‖1 - (p : ℝ)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_nonneg (sub_nonneg.mpr p.2.2)]
    linarith
  have hm := (hasSum_coe_mul_geometric_of_norm_lt_one hr).mul_right (p : ℝ)
  have hg := hasSum_one_geometricMeasure (parametro_no_cero p hp)
  have h := hm.add hg
  convert h using 1
  · ext n
    simp only [peso, Nat.cast_add, Nat.cast_one]
    ring
  · rw [sub_sub_cancel]
    field_simp
    ring

theorem intentos_integrables (p : unitInterval) (hp : 0 < (p : ℝ)) :
    Integrable (fun n : ℕ => ((n + 1 : ℕ) : ℝ)) (geometricMeasure p) := by
  apply (integrable_geometricMeasure_iff (parametro_no_cero p hp)).mpr
  have hn : ∀ n : ℕ, ‖((n + 1 : ℕ) : ℝ)‖ = ((n + 1 : ℕ) : ℝ) :=
    fun n => Real.norm_of_nonneg (Nat.cast_nonneg (n + 1))
  simp_rw [hn]
  exact (serie_esperanza p hp).summable

theorem esperanza_intentos (p : unitInterval) (hp : 0 < (p : ℝ)) : esperanza p = 1 / (p : ℝ) := by
  unfold esperanza
  rw [integral_geometricMeasure (parametro_no_cero p hp)]
  simpa only [peso, smul_eq_mul] using (serie_esperanza p hp).tsum_eq

theorem esperanza_positiva (p : unitInterval) (hp : 0 < (p : ℝ)) : 0 < esperanza p := by
  rw [esperanza_intentos p hp]
  positivity

theorem esperanza_al_menos_uno (p : unitInterval) (hp : 0 < (p : ℝ)) : 1 ≤ esperanza p := by
  rw [esperanza_intentos p hp]
  exact (le_div_iff₀ hp).mpr (by simpa using p.2.2)

theorem aceptacion_finita (p : unitInterval) (M : ℕ) : aceptacionAcotada p M = 1 - (1 - (p : ℝ)) ^ M := by
  induction M with
  | zero => simp [aceptacionAcotada]
  | succ M ih =>
    rw [aceptacionAcotada, Finset.sum_range_succ, ← aceptacionAcotada, ih]
    unfold peso
    rw [pow_succ]
    ring

theorem aceptacion_ley_finita (p : unitInterval) (hp : 0 < (p : ℝ)) (M : ℕ) :
    (geometricMeasure p).real (Finset.range M) = aceptacionAcotada p M := by
  rw [← sum_measureReal_singleton]
  exact Finset.sum_congr rfl (fun n _ => peso_ley p hp n)

theorem probabilidad_agotamiento (p : unitInterval) (hp : 0 < (p : ℝ)) (M : ℕ) :
    (geometricMeasure p).real (Ici M) = (1 - (p : ℝ)) ^ M := by
  have h := probReal_add_probReal_compl (μ := geometricMeasure p) (Finset.measurableSet (Finset.range M))
  have he : ((Finset.range M : Finset ℕ) : Set ℕ)ᶜ = Ici M := by ext n; simp
  rw [he, aceptacion_ley_finita p hp M, aceptacion_finita] at h
  linarith

theorem agotamiento_positivo (p : unitInterval) (hp : 0 < (p : ℝ)) (hp1 : (p : ℝ) < 1) (M : ℕ) :
    0 < (geometricMeasure p).real (Ici M) := by
  rw [probabilidad_agotamiento p hp]
  exact pow_pos (sub_pos.mpr hp1) M

theorem agotamiento_tiende_cero (p : unitInterval) (hp : 0 < (p : ℝ)) :
    Tendsto (fun M : ℕ => (geometricMeasure p).real (Ici M)) atTop (𝓝 0) := by
  simp_rw [probabilidad_agotamiento p hp]
  exact tendsto_pow_atTop_nhds_zero_of_lt_one (sub_nonneg.mpr p.2.2) (by linarith)

theorem costo_esperado (p : unitInterval) (hp : 0 < (p : ℝ)) (c : ℝ) : costoEsperado p c = c / (p : ℝ) := by
  unfold costoEsperado
  rw [integral_const_mul, ← esperanza, esperanza_intentos p hp]
  ring

theorem cota_uniforme (p : unitInterval) (p0 : ℝ) (hp0 : 0 < p0) (hp : p0 ≤ p) :
    esperanza p ≤ 1 / p0 := by
  rw [esperanza_intentos p (hp0.trans_le hp)]
  exact one_div_le_one_div_of_le hp0 hp

theorem intentos_esperados_O_uno (p : ℕ → unitInterval) (p0 : ℝ) (hp0 : 0 < p0)
    (hp : ∀ i, p0 ≤ p i) :
    (fun i : ℕ => esperanza (p i)) =O[atTop] (fun _ => (1 : ℝ)) := by
  apply IsBigO.of_bound (1 / p0)
  apply Eventually.of_forall
  intro i
  simpa only [Real.norm_eq_abs, abs_of_pos (esperanza_positiva (p i) (hp0.trans_le (hp i))),
    abs_one, mul_one] using cota_uniforme (p i) p0 hp0 (hp i)

theorem costo_esperado_preserva_O (p : ℕ → unitInterval) (p0 : ℝ) (hp0 : 0 < p0)
    (hp : ∀ i, p0 ≤ p i) (c g : ℕ → ℝ) (hcg : c =O[atTop] g) :
    (fun i : ℕ => costoEsperado (p i) (c i)) =O[atTop] g := by
  obtain ⟨C, hC, hbound⟩ := isBigO_iff'.mp hcg
  apply IsBigO.of_bound (C / p0)
  filter_upwards [hbound] with i hi
  have hpi : 0 < (p i : ℝ) := hp0.trans_le (hp i)
  rw [costo_esperado (p i) hpi, norm_div, Real.norm_of_nonneg (le_of_lt hpi)]
  calc
    ‖c i‖ / (p i : ℝ) = ‖c i‖ * (1 / (p i : ℝ)) := by ring
    _ ≤ (C * ‖g i‖) * (1 / p0) := mul_le_mul hi (one_div_le_one_div_of_le hp0 (hp i))
      (by positivity) (mul_nonneg (le_of_lt hC) (norm_nonneg _))
    _ = (C / p0) * ‖g i‖ := by ring

end Nexus.Complejidad.Rechazo
