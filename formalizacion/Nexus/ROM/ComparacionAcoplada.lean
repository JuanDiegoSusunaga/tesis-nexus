module

public import Nexus.N06.Experimento
public import Mathlib.Algebra.Order.Group.Unbundled.Abs
public import Mathlib.Data.Rat.Cast.Order
import Mathlib.Tactic

/-!
# Comparación de eventos mediante un acoplamiento explícito

Si dos salidas coinciden fuera de un evento excepcional, cualquier evento
de sus salidas difiere a lo sumo en la probabilidad de esa excepción. Las
medias permanecen incondicionales: no se reemplazan por una ley condicionada
a ausencia de errores.
-/

public section
namespace Nexus.ROM.ComparacionAcoplada

open Nexus.N06
open scoped BigOperators

variable {W X : Type} [Fintype W]

theorem promedio_evento (E : W → Prop) [DecidablePred E] :
    promedio (fun w => if E w then (1 : ℚ) else 0) =
      (Fintype.card {w : W // E w} : ℚ) / Fintype.card W := by
  simp only [promedio, Finset.sum_boole, Fintype.card_subtype]

theorem indicador_union (P Q : Prop) [Decidable P] [Decidable Q] :
    (if P ∨ Q then (1 : ℚ) else 0) ≤ (if P then 1 else 0) + (if Q then 1 else 0) := by
  by_cases hp : P <;> by_cases hq : Q <;> norm_num [hp, hq]

theorem union_eventos (P Q : W → Prop) [DecidablePred P] [DecidablePred Q] :
    promedio (fun w => if P w ∨ Q w then (1 : ℚ) else 0) ≤
      promedio (fun w => if P w then 1 else 0) + promedio (fun w => if Q w then 1 else 0) := by
  rw [← promedio_suma]
  exact promedio_monotono _ _ (fun w => indicador_union (P w) (Q w))

theorem cota_desde_condicional (E F : W → Prop) [DecidablePred E] [DecidablePred F]
    (hEF : ∀ w, E w → F w) (rho : ℚ) (h0 : 0 ≤ rho)
    (hcond : (Fintype.card {w : W // E w} : ℚ) / Fintype.card {w : W // F w} = rho) :
    promedio (fun w => if E w then (1 : ℚ) else 0) ≤ rho := by
  have hab : Fintype.card {w : W // E w} ≤ Fintype.card {w : W // F w} :=
    Fintype.card_le_of_injective (fun w => (⟨w.val, hEF w.val w.property⟩ : {w : W // F w}))
      (fun _ _ h => Subtype.ext (congrArg (fun z : {w : W // F w} => z.val) h))
  have hbN := Fintype.card_subtype_le (p := F)
  rw [promedio_evento]
  by_cases hb : Fintype.card {w : W // F w} = 0
  · have ha : Fintype.card {w : W // E w} = 0 := by omega
    simpa only [ha, Nat.cast_zero, zero_div] using h0
  · apply le_trans _ (le_of_eq hcond)
    exact div_le_div_of_nonneg_left (by positivity) (by exact_mod_cast Nat.pos_of_ne_zero hb)
      (by exact_mod_cast hbN)

theorem promedio_resta (f g : W → ℚ) :
    promedio (fun w => f w - g w) = promedio f - promedio g := by
  simp only [promedio, Finset.sum_sub_distrib, sub_div]

theorem absoluto_promedio (f : W → ℚ) : |promedio f| ≤ promedio (fun w => |f w|) := by
  rw [promedio, abs_div, abs_of_nonneg (show (0 : ℚ) ≤ Fintype.card W by positivity)]
  exact div_le_div_of_nonneg_right (Finset.abs_sum_le_sum_abs _ _) (by positivity)

theorem indicador_cota (x y : X) (E : X → Prop) [DecidablePred E]
    (B : Prop) [Decidable B] (h : ¬ B → x = y) :
    |(if E x then (1 : ℚ) else 0) - (if E y then 1 else 0)| ≤ if B then 1 else 0 := by
  by_cases hb : B
  · simp only [hb, ite_true]
    split_ifs <;> norm_num
  · simp only [hb, ite_false, h hb, sub_self, abs_zero, le_refl]

theorem diferencia_evento (f g : W → X) (B : W → Prop) [DecidablePred B]
    (h : ∀ w, ¬ B w → f w = g w) (E : X → Prop) [DecidablePred E] :
    |promedio (fun w => if E (f w) then (1 : ℚ) else 0) -
        promedio (fun w => if E (g w) then 1 else 0)| ≤
      promedio (fun w => if B w then 1 else 0) := by
  rw [← promedio_resta]
  exact (absoluto_promedio _).trans
    (promedio_monotono _ _ (fun w => indicador_cota (f w) (g w) E (B w) (h w)))

theorem transferencia_evento (f g : W → X) (B : W → Prop) [DecidablePred B]
    (h : ∀ w, ¬ B w → f w = g w) (E : X → Prop) [DecidablePred E] (delta : ℚ)
    (hd : promedio (fun w => if B w then (1 : ℚ) else 0) ≤ delta) :
    promedio (fun w => if E (f w) then (1 : ℚ) else 0) ≤
      promedio (fun w => if E (g w) then 1 else 0) + delta := by
  have he := (diferencia_evento f g B h E).trans hd
  linarith [(abs_le.mp he).2]

end Nexus.ROM.ComparacionAcoplada
