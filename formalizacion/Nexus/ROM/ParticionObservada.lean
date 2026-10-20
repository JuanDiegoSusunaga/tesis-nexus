module

public import Nexus.ROM.ComparacionAcoplada
import Mathlib.Tactic

/-!
# Esperanza total respecto de una observación finita

Las fibras incluyen todos los resultados compatibles con el dato observado.
Sus pesos son los cardinales exactos. No se supone equiprobabilidad entre
observaciones, ni se descartan fibras desfavorables.
-/

public section
namespace Nexus.ROM.ParticionObservada

open Nexus.N06
open scoped BigOperators

variable {W T : Type} [Fintype W] [Fintype T] [DecidableEq T]

abbrev Fibra (observar : W → T) (t : T) := {w : W // observar w = t}

@[expose] noncomputable def masa (observar : W → T) (t : T) : ℚ :=
  (Fintype.card (Fibra observar t) : ℚ) / Fintype.card W

omit [Fintype T] in
theorem masa_no_negativa (observar : W → T) (t : T) : 0 ≤ masa observar t := by
  unfold masa
  positivity

omit [Fintype T] in
theorem masa_por_media (observar : W → T) (t : T) (f : W → ℚ) :
    masa observar t * promedio (fun w : Fibra observar t => f w.val) =
      (∑ w : Fibra observar t, f w.val) / Fintype.card W := by
  unfold masa promedio
  by_cases hc : Fintype.card (Fibra observar t) = 0
  · let _ : IsEmpty (Fibra observar t) := Fintype.card_eq_zero_iff.mp hc
    simp
  · have hn : (Fintype.card (Fibra observar t) : ℚ) ≠ 0 := by exact_mod_cast hc
    field_simp

theorem esperanza_total (observar : W → T) (f : W → ℚ) :
    promedio f = ∑ t : T, masa observar t * promedio (fun w : Fibra observar t => f w.val) := by
  simp_rw [masa_por_media]
  rw [← Finset.sum_div, Fintype.sum_fiberwise observar f]
  rfl

theorem media_observada (observar : W → T) (f : T → ℚ) :
    promedio (fun w => f (observar w)) = ∑ t : T, masa observar t * f t := by
  rw [esperanza_total observar]
  apply Finset.sum_congr rfl
  intro t _
  by_cases hc : Fintype.card (Fibra observar t) = 0
  · simp only [masa, hc, Nat.cast_zero, zero_div, zero_mul]
  · let _ : Nonempty (Fibra observar t) := Fintype.card_pos_iff.mp (Nat.pos_of_ne_zero hc)
    have he : (fun w : Fibra observar t => f (observar w.val)) = (fun _ => f t) := by
      funext w
      rw [w.property]
    rw [he, promedio_constante]

theorem cota_por_fibras (observar : W → T) (f : W → ℚ) (cota : T → ℚ)
    (h : ∀ t, 0 < Fintype.card (Fibra observar t) →
      promedio (fun w : Fibra observar t => f w.val) ≤ cota t) :
    promedio f ≤ promedio (fun w => cota (observar w)) := by
  rw [esperanza_total observar, media_observada]
  apply Finset.sum_le_sum
  intro t _
  by_cases hc : Fintype.card (Fibra observar t) = 0
  · simp only [masa, hc, Nat.cast_zero, zero_div, zero_mul, le_refl]
  · exact mul_le_mul_of_nonneg_left (h t (Nat.pos_of_ne_zero hc)) (masa_no_negativa observar t)

theorem cota_constante [Nonempty W] (observar : W → T) (f : W → ℚ) (c : ℚ)
    (h : ∀ t, 0 < Fintype.card (Fibra observar t) →
      promedio (fun w : Fibra observar t => f w.val) ≤ c) : promedio f ≤ c := by
  simpa only [promedio_constante] using cota_por_fibras observar f (fun _ => c) h

theorem cota_con_excepcion (observar : W → T) (E : W → Prop) [DecidablePred E]
    (B : T → Prop) [DecidablePred B] (rho : T → ℚ) (h0 : ∀ t, 0 ≤ rho t)
    (h : ∀ t, 0 < Fintype.card (Fibra observar t) → ¬ B t →
      promedio (fun w : Fibra observar t => if E w.val then (1 : ℚ) else 0) ≤ rho t) :
    promedio (fun w => if E w then (1 : ℚ) else 0) ≤
      promedio (fun w => rho (observar w)) + promedio (fun w => if B (observar w) then 1 else 0) := by
  rw [← promedio_suma]
  apply cota_por_fibras observar (fun w => if E w then (1 : ℚ) else 0)
    (fun t => rho t + if B t then 1 else 0)
  intro t ht
  by_cases hb : B t
  · have hu : promedio (fun w : Fibra observar t => if E w.val then (1 : ℚ) else 0) ≤ 1 := by
      let _ : Nonempty (Fibra observar t) := Fintype.card_pos_iff.mp ht
      calc
        _ ≤ promedio (fun _ : Fibra observar t => (1 : ℚ)) :=
          promedio_monotono _ _ (fun _ => by split_ifs <;> norm_num)
        _ = 1 := promedio_constante 1
    simp only [hb, ite_true]
    linarith [h0 t]
  · simpa only [hb, ite_false, add_zero] using h t ht hb

end Nexus.ROM.ParticionObservada
