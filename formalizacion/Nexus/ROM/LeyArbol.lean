module

public import Nexus.ROM.PromediosCompletaciones
import Mathlib.Tactic

/-!
# Ley conjunta de un árbol adaptativo finito

Las consultas se eligen con todas las respuestas anteriores. La media de
funciones uniformes coincide exactamente con el muestreo con memoria. La
identidad vale para cualquier observable, incluida la transcripción completa,
y no requiere ausencia de colisiones ni excepciones.
-/

public section
namespace Nexus.ROM.LeyArbol

open Nexus.N06 FrescuraFinita PromediosCompletaciones

inductive Arbol (Q A R : Type) where
  | terminar (r : R)
  | consultar (q : Q) (k : A → Arbol Q A R)

variable {Q A R T : Type}

@[expose] def evaluar (H : Q → A) : Arbol Q A R → R
  | .terminar r => r
  | .consultar q k => evaluar H (k (H q))

@[expose] def traza (H : Q → A) : Arbol Q A R → List (Q × A)
  | .terminar _ => []
  | .consultar q k => (q, H q) :: traza H (k (H q))

@[expose] def transformar (g : R → T) : Arbol Q A R → Arbol Q A T
  | .terminar r => .terminar (g r)
  | .consultar q k => .consultar q (fun a => transformar g (k a))

theorem evaluar_transformar (H : Q → A) (g : R → T) (p : Arbol Q A R) :
    evaluar H (transformar g p) = g (evaluar H p) := by
  induction p with
  | terminar => rfl
  | consultar q k ih => exact ih _

theorem traza_transformar (H : Q → A) (g : R → T) (p : Arbol Q A R) :
    traza H (transformar g p) = traza H p := by
  induction p with
  | terminar => rfl
  | consultar q k ih => exact congrArg (List.cons _) (ih _)

@[expose] def registrar : Arbol Q A R → Arbol Q A (R × List (Q × A))
  | .terminar r => .terminar (r, [])
  | .consultar q k => .consultar q (fun a =>
      transformar (fun rt => (rt.1, (q, a) :: rt.2)) (registrar (k a)))

theorem evaluar_registrar (H : Q → A) (p : Arbol Q A R) :
    evaluar H (registrar p) = (evaluar H p, traza H p) := by
  induction p with
  | terminar => rfl
  | consultar q k ih =>
    simp only [registrar, evaluar, evaluar_transformar, ih, traza]

variable [DecidableEq Q] [Fintype A]

@[expose] noncomputable def valor (f : R → ℚ) : Arbol Q A R → Finset Q → (Q → A) → ℚ
  | .terminar r, _, _ => f r
  | .consultar q k, S, v =>
      if q ∈ S then valor f (k (v q)) S v
      else promedio (fun a => valor f (k a) (insert q S) (Function.update v q a))

variable [Fintype Q]

theorem ley_condicionada (p : Arbol Q A R) (S : Finset Q) (v : Q → A) (f : R → ℚ) :
    promedio (fun H : Completaciones S v => f (evaluar H.val p)) = valor f p S v := by
  induction p generalizing S v with
  | terminar r =>
    let _ : Nonempty (Completaciones S v) := ⟨⟨v, by intros; rfl⟩⟩
    exact promedio_constante (f r)
  | consultar q k ih =>
    change promedio (fun H : Completaciones S v => f (evaluar H.val (k (H.val q)))) =
      if q ∈ S then valor f (k (v q)) S v
      else promedio (fun a => valor f (k a) (insert q S) (Function.update v q a))
    by_cases hq : q ∈ S
    · rw [ite_eq_left hq]
      have he : (fun H : Completaciones S v => f (evaluar H.val (k (H.val q)))) =
          (fun H : Completaciones S v => f (evaluar H.val (k (v q)))) := by
        funext H
        rw [H.property q hq]
      rw [he]
      exact ih (v q) S v
    · rw [ite_eq_right hq,
        media_revelar S v q hq (fun H : Q → A => f (evaluar H (k (H q))))]
      congr 1
      funext a
      have he : (fun H : Completaciones (insert q S) (Function.update v q a) =>
          f (evaluar H.val (k (H.val q)))) =
          (fun H : Completaciones (insert q S) (Function.update v q a) =>
          f (evaluar H.val (k a))) := by
        funext H
        have ha := H.property q (Finset.mem_insert_self _ _)
        simpa only [Function.update_self] using congrArg (fun x => f (evaluar H.val (k x))) ha
      rw [he]
      exact ih a _ _

theorem ley_desde_vacio (p : Arbol Q A R) (v : Q → A) (f : R → ℚ) :
    promedio (fun H : Q → A => f (evaluar H p)) = valor f p ∅ v := by
  rw [← media_vacia v]
  exact ley_condicionada p ∅ v f

theorem ley_transcripcion (p : Arbol Q A R) (v : Q → A) (f : R × List (Q × A) → ℚ) :
    promedio (fun H : Q → A => f (evaluar H p, traza H p)) = valor f (registrar p) ∅ v := by
  have h := ley_desde_vacio (registrar p) v f
  simpa only [evaluar_registrar] using h

theorem defecto_inmaterial (p : Arbol Q A R) (v w : Q → A) (f : R → ℚ) :
    valor f p ∅ v = valor f p ∅ w := by
  rw [← ley_desde_vacio p v f, ← ley_desde_vacio p w f]

theorem ley_evento (p : Arbol Q A R) (v : Q → A) (E : R → Prop) [DecidablePred E] :
    promedio (fun H : Q → A => if E (evaluar H p) then 1 else 0) =
      valor (fun r => if E r then 1 else 0) p ∅ v :=
  ley_desde_vacio p v (fun r => if E r then (1 : ℚ) else 0)

end Nexus.ROM.LeyArbol
