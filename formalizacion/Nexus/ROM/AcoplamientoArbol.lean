module

public import Nexus.ROM.LeyArbol
import Mathlib.Tactic

/-!
# Comparación con respuestas independientes hasta la primera repetición

La primera consulta repetida paga un error de uno. Antes de ese punto,
las ramas se promedian con respuestas frescas. La cota es incondicional y
no exige que todas las ramas del árbol sean libres de repeticiones.
-/

public section
namespace Nexus.ROM.AcoplamientoArbol

open Nexus.N06 LeyArbol

variable {Q A R T : Type} [DecidableEq Q] [Fintype A] [Nonempty A]

@[expose] noncomputable def media (f : R → ℚ) : Arbol Q A R → ℚ
  | .terminar r => f r
  | .consultar _ k => promedio (fun a => media f (k a))

@[expose] noncomputable def repeticion : Arbol Q A R → Finset Q → ℚ
  | .terminar _, _ => 0
  | .consultar q k, S =>
      if q ∈ S then 1 else promedio (fun a => repeticion (k a) (insert q S))

omit [DecidableEq Q] in
theorem media_no_negativa (f : R → ℚ) (p : Arbol Q A R)
    (hf : ∀ r, 0 ≤ f r) : 0 ≤ media f p := by
  induction p with
  | terminar r => exact hf r
  | consultar q k ih =>
    change 0 ≤ promedio (fun a => media f (k a))
    rw [← promedio_constante (K := A) 0]
    exact promedio_monotono _ _ ih

theorem valor_acotado (f : R → ℚ) (p : Arbol Q A R)
    (S : Finset Q) (v : Q → A) (hf : ∀ r, f r ≤ 1) :
    LeyArbol.valor f p S v ≤ 1 := by
  induction p generalizing S v with
  | terminar r => exact hf r
  | consultar q k ih =>
    rw [LeyArbol.valor]
    split_ifs
    · exact ih _ _ _
    · rw [← promedio_constante (K := A) 1]
      exact promedio_monotono _ _ (fun a => ih a _ _)

theorem repeticion_no_negativa (p : Arbol Q A R) (S : Finset Q) :
    0 ≤ repeticion p S := by
  induction p generalizing S with
  | terminar => rfl
  | consultar q k ih =>
    rw [repeticion]
    split_ifs
    · norm_num
    · rw [← promedio_constante (K := A) 0]
      exact promedio_monotono _ _ (fun a => ih a _)

omit [Nonempty A] in
theorem repeticion_transformar (g : R → T) (p : Arbol Q A R) (S : Finset Q) :
    repeticion (transformar g p) S = repeticion p S := by
  induction p generalizing S with
  | terminar => rfl
  | consultar q k ih =>
    simp only [transformar, repeticion]
    split_ifs
    · rfl
    · apply congrArg promedio
      funext a
      exact ih a _

theorem valor_le_media_mas_repeticion (f : R → ℚ) (p : Arbol Q A R)
    (S : Finset Q) (v : Q → A) (h0 : ∀ r, 0 ≤ f r) (h1 : ∀ r, f r ≤ 1) :
    LeyArbol.valor f p S v ≤ media f p + repeticion p S := by
  induction p generalizing S v with
  | terminar r => simp only [LeyArbol.valor, media, repeticion, add_zero, le_refl]
  | consultar q k ih =>
    by_cases hq : q ∈ S
    · simp only [LeyArbol.valor, repeticion, hq, ite_true]
      have hv := valor_acotado f (k (v q)) S v h1
      have hm := media_no_negativa f (.consultar q k) h0
      linarith
    · simp only [LeyArbol.valor, media, repeticion, hq, ite_false]
      rw [← promedio_suma]
      exact promedio_monotono _ _ (fun a => ih a _ _)

theorem repeticion_acotada_uno (p : Arbol Q A R) (S : Finset Q) :
    repeticion p S ≤ 1 := by
  induction p generalizing S with
  | terminar => norm_num [repeticion]
  | consultar q k ih =>
    rw [repeticion]
    split_ifs
    · rfl
    · rw [← promedio_constante (K := A) 1]
      exact promedio_monotono _ _ (fun a => ih a _)

theorem transferencia_evento [Fintype Q] (p : Arbol Q A R) (v : Q → A)
    (E : R → Prop) [DecidablePred E] :
    promedio (fun H : Q → A => if E (evaluar H p) then (1 : ℚ) else 0) ≤
      media (fun r => if E r then 1 else 0) p + repeticion p ∅ := by
  rw [ley_desde_vacio p v (fun r => if E r then (1 : ℚ) else 0)]
  exact valor_le_media_mas_repeticion _ p ∅ v
    (fun r => by split_ifs <;> norm_num)
    (fun r => by split_ifs <;> norm_num)

end Nexus.ROM.AcoplamientoArbol
