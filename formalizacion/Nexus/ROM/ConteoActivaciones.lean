module

public import Nexus.ROM.ActivacionPrefijo
import Mathlib.Tactic

/-!
# Unión de candidatos con coste esperado

Los sucesos de distintos candidatos pueden solaparse y reutilizar el mismo
oráculo. Solo se usan cotas individuales ponderadas por su activación.
-/

public section
namespace Nexus.ROM.ConteoActivaciones

open Nexus.N06 ActivacionPrefijo
open scoped BigOperators

variable {W I : Type} [Fintype W] [Fintype I]
attribute [local instance] Classical.propDecidable
set_option maxHeartbeats 400000

theorem media_suma (f : I → W → ℚ) :
    promedio (fun w => ∑ i, f i w) = ∑ i, promedio (f i) := by
  simp only [promedio, ← Finset.sum_div]
  rw [Finset.sum_comm]

omit [Fintype W] in
theorem indicador_existe (E : I → W → Prop) [∀ i, DecidablePred (E i)] (w : W)
    [Decidable (∃ i, E i w)] :
    (if ∃ i, E i w then (1 : ℚ) else 0) ≤ ∑ i, if E i w then 1 else 0 := by
  by_cases he : ∃ i, E i w
  · obtain ⟨i, hi⟩ := he
    rw [ite_eq_left ⟨i, hi⟩]
    exact (by simp only [hi, ite_true, le_refl] : (1 : ℚ) ≤ if E i w then 1 else 0).trans
      (Finset.single_le_sum (f := fun j => if E j w then (1 : ℚ) else 0)
        (fun j _ => by split_ifs <;> norm_num) (Finset.mem_univ i))
  · rw [ite_eq_right he]
    exact Finset.sum_nonneg (fun j _ => by split_ifs <;> norm_num)

theorem union_finita (E : I → W → Prop) [∀ i, DecidablePred (E i)]
    [DecidablePred (fun w => ∃ i, E i w)] :
    promedio (fun w => if ∃ i, E i w then (1 : ℚ) else 0) ≤
      ∑ i, promedio (fun w => if E i w then (1 : ℚ) else 0) := by
  rw [← media_suma]
  exact promedio_monotono _ _ (fun w => indicador_existe E w)

@[expose] noncomputable def numero (activa : I → W → Prop) [∀ i, DecidablePred (activa i)] (w : W) : ℕ :=
  (Finset.univ.filter (fun i => activa i w)).card

omit [Fintype W] in
theorem numero_por_indicadores (activa : I → W → Prop) [∀ i, DecidablePred (activa i)] (w : W) :
    (numero activa w : ℚ) = ∑ i, if activa i w then (1 : ℚ) else 0 := by
  simp only [numero, Finset.sum_boole]

theorem suma_probabilidades (activa : I → W → Prop) [∀ i, DecidablePred (activa i)] :
    (∑ i, promedio (fun w => if activa i w then (1 : ℚ) else 0)) =
      promedio (fun w => (numero activa w : ℚ)) := by
  simp_rw [numero_por_indicadores, media_suma]

theorem cota_por_activaciones (activa E : I → W → Prop)
    [∀ i, DecidablePred (activa i)] [∀ i, DecidablePred (E i)]
    [DecidablePred (fun w => ∃ i, activa i w ∧ E i w)] (rho : ℚ)
    (h : ∀ i, promedio (fun w => if activa i w ∧ E i w then (1 : ℚ) else 0) ≤
      rho * promedio (fun w => if activa i w then (1 : ℚ) else 0)) :
    promedio (fun w => if ∃ i, activa i w ∧ E i w then (1 : ℚ) else 0) ≤
      rho * promedio (fun w => (numero activa w : ℚ)) := by
  calc
    _ ≤ ∑ i, promedio (fun w => if activa i w ∧ E i w then (1 : ℚ) else 0) :=
      union_finita (fun i w => activa i w ∧ E i w)
    _ ≤ ∑ i, rho * promedio (fun w => if activa i w then (1 : ℚ) else 0) := Finset.sum_le_sum (fun i _ => h i)
    _ = _ := by rw [← Finset.mul_sum, suma_probabilidades]

theorem cota_por_presupuesto [Nonempty W] (activa E : I → W → Prop)
    [∀ i, DecidablePred (activa i)] [∀ i, DecidablePred (E i)]
    [DecidablePred (fun w => ∃ i, activa i w ∧ E i w)] (rho : ℚ) (B : ℕ)
    (hr : 0 ≤ rho) (hb : ∀ w, numero activa w ≤ B)
    (h : ∀ i, promedio (fun w => if activa i w ∧ E i w then (1 : ℚ) else 0) ≤
      rho * promedio (fun w => if activa i w then (1 : ℚ) else 0)) :
    promedio (fun w => if ∃ i, activa i w ∧ E i w then (1 : ℚ) else 0) ≤ rho * B := by
  have hn : promedio (fun w => (numero activa w : ℚ)) ≤ (B : ℚ) := by
    calc
      _ ≤ promedio (fun _ : W => (B : ℚ)) := promedio_monotono _ _ (fun w => by exact_mod_cast hb w)
      _ = _ := promedio_constante _
  exact (cota_por_activaciones activa E rho h).trans (mul_le_mul_of_nonneg_left hn hr)

omit [Fintype I] in
theorem transferir_evento (F : W → Prop) [DecidablePred F] (activa E : I → W → Prop)
    [∀ i, DecidablePred (activa i)] [∀ i, DecidablePred (E i)]
    [DecidablePred (fun w => ∃ i, activa i w ∧ E i w)]
    (hc : ∀ w, F w → ∃ i, activa i w ∧ E i w) :
    promedio (fun w => if F w then (1 : ℚ) else 0) ≤
      promedio (fun w => if ∃ i, activa i w ∧ E i w then (1 : ℚ) else 0) := by
  apply promedio_monotono
  intro w
  by_cases hf : F w
  · simp only [hf, hc w hf, ite_true, le_refl]
  · simp only [hf, ite_false]
    split_ifs <;> norm_num

end Nexus.ROM.ConteoActivaciones
