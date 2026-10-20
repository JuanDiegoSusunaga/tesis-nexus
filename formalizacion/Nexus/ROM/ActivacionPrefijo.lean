module

public import Nexus.ROM.ObservacionesPrefijo
import Mathlib.Tactic

/-!
# Candidatos activados antes de observar una respuesta

La decisión de activar depende solo del prefijo. La cota local se paga
únicamente en esas fibras y se conserva el número esperado de activaciones.
-/

public section
namespace Nexus.ROM.ActivacionPrefijo

open Nexus.N06 LeyArbol PrefijosGlobales ObservacionesPrefijo
open scoped BigOperators

variable {Q A X : Type} [DecidableEq Q] [DecidableEq A] [Fintype Q] [Fintype A]
attribute [local instance] Classical.propDecidable

omit [DecidableEq Q] [DecidableEq A] in
theorem media_activada (p : Arbol Q A X) (n : ℕ) (H : Q → A)
    (activa : List (Q × A) → Prop) [DecidablePred activa] (E : (Q → A) → Prop) [DecidablePred E] :
    promedio (fun G : Tablas H p n => if activa (prefijo p n G.val) ∧ E G.val then (1 : ℚ) else 0) =
      if activa (prefijo p n H) then
        promedio (fun G : Tablas H p n => if E G.val then (1 : ℚ) else 0) else 0 := by
  have hp (G : Tablas H p n) : prefijo p n G.val = prefijo p n H := G.property
  simp_rw [hp]
  by_cases ha : activa (prefijo p n H)
  · simp only [ha, true_and, ite_true]
  · simp only [ha, false_and, ite_false]
    simp only [promedio, Finset.sum_const_zero, zero_div]

theorem cota_activada (p : Arbol Q A X) (n : ℕ)
    (activa : List (Q × A) → Prop) [DecidablePred activa] (E : (Q → A) → Prop) [DecidablePred E]
    (rho : List (Q × A) → ℚ)
    (h : ∀ H, activa (prefijo p n H) →
      promedio (fun G : Tablas H p n => if E G.val then (1 : ℚ) else 0) ≤ rho (prefijo p n H)) :
    promedio (fun H : Q → A => if activa (prefijo p n H) ∧ E H then (1 : ℚ) else 0) ≤
      promedio (fun H => if activa (prefijo p n H) then rho (prefijo p n H) else 0) := by
  apply cota_por_prefijos p n _ (fun t => if activa t then rho t else 0)
  intro H
  rw [media_activada]
  by_cases ha : activa (prefijo p n H)
  · simpa only [ha, ite_true] using h H ha
  · simp only [ha, ite_false, le_refl]

omit [DecidableEq Q] [DecidableEq A] [Fintype Q] [Fintype A] in
theorem media_factor {W : Type} [Fintype W] (c : ℚ) (f : W → ℚ) :
    promedio (fun w => c * f w) = c * promedio f := by
  simp only [promedio, ← Finset.mul_sum]
  ring

theorem cota_activada_constante (p : Arbol Q A X) (n : ℕ)
    (activa : List (Q × A) → Prop) [DecidablePred activa] (E : (Q → A) → Prop) [DecidablePred E] (rho : ℚ)
    (h : ∀ H, activa (prefijo p n H) →
      promedio (fun G : Tablas H p n => if E G.val then (1 : ℚ) else 0) ≤ rho) :
    promedio (fun H : Q → A => if activa (prefijo p n H) ∧ E H then (1 : ℚ) else 0) ≤
      rho * promedio (fun H => if activa (prefijo p n H) then (1 : ℚ) else 0) := by
  have he : (fun H : Q → A => if activa (prefijo p n H) then rho else 0) =
      (fun H => rho * if activa (prefijo p n H) then (1 : ℚ) else 0) := by
    funext H
    split_ifs <;> ring
  simpa only [he, media_factor] using cota_activada p n activa E (fun _ => rho) h

end Nexus.ROM.ActivacionPrefijo
