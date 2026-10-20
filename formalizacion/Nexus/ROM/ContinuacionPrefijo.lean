module

public import Nexus.ROM.PrefijosGlobales
import Mathlib.Tactic

/-!
# Ley de la continuación después de un prefijo efectivo

Se reanuda el mismo árbol adaptativo, conservando la tabla observada. La
condición es la igualdad del pasado ejecutado; no depende de aceptación
ni de una condición futura de ausencia de excepciones.
-/

public section
namespace Nexus.ROM.ContinuacionPrefijo

open Nexus.N06 LeyArbol PrefijosGlobales FrescuraFinita

variable {Q A R : Type}

@[expose] def despues (H : Q → A) (p : Arbol Q A R) : ℕ → Arbol Q A R
  | 0 => p
  | n + 1 => match p with
      | .terminar r => .terminar r
      | .consultar q k => despues H (k (H q)) n

theorem resultado_despues (H : Q → A) (p : Arbol Q A R) (n : ℕ) :
    evaluar H (despues H p n) = evaluar H p := by
  induction n generalizing p with
  | zero => cases p <;> rfl
  | succ n ih => cases p with
    | terminar => rfl
    | consultar q k => exact ih (k (H q))

theorem traza_despues (H : Q → A) (p : Arbol Q A R) (n : ℕ) :
    traza H (despues H p n) = (traza H p).drop n := by
  induction n generalizing p with
  | zero => cases p <;> rfl
  | succ n ih => cases p with
    | terminar => simp only [despues, traza, List.drop_nil]
    | consultar q k => simpa only [despues, traza, List.drop_succ_cons] using ih (k (H q))

theorem reconstruir_traza (H : Q → A) (p : Arbol Q A R) (n : ℕ) :
    (traza H p).take n ++ traza H (despues H p n) = traza H p := by
  rw [traza_despues, List.take_append_drop]

theorem despues_por_prefijo (H G : Q → A) (p : Arbol Q A R) (n : ℕ)
    (he : (traza G p).take n = (traza H p).take n) :
    despues G p n = despues H p n := by
  induction n generalizing p with
  | zero => cases p <;> rfl
  | succ n ih => cases p with
    | terminar => rfl
    | consultar q k =>
      simp only [traza, List.take_succ_cons] at he
      have hq : G q = H q := congrArg Prod.snd (List.cons.inj he).1
      simp only [despues, hq]
      apply ih
      simpa only [hq] using (List.cons.inj he).2

variable [DecidableEq Q] [Fintype Q] [Fintype A]

theorem ley_tabla_y_pasado (H : Q → A) (p : Arbol Q A R) (n : ℕ)
    (f : List (Q × A) → (Q → A) → ℚ) :
    promedio (fun G : Tablas H p n => f ((traza G.val p).take n) G.val) =
      promedio (fun G : Completaciones (vistas H p n) H => f ((traza H p).take n) G.val) := by
  calc
    _ = promedio (fun G : Tablas H p n => f ((traza H p).take n) G.val) := by
      congr 1
      funext G
      rw [G.property]
    _ = _ := PromediosCompletaciones.media_equivalencia (equivalencia H p n)
      (fun G => f ((traza H p).take n) G.val)

theorem ley_continuacion (H : Q → A) (p : Arbol Q A R) (n : ℕ)
    (f : R × List (Q × A) → ℚ) :
    promedio (fun G : Tablas H p n =>
      f (evaluar G.val (despues G.val p n), traza G.val (despues G.val p n))) =
      LeyArbol.valor f (registrar (despues H p n)) (vistas H p n) H := by
  calc
    _ = promedio (fun G : Tablas H p n =>
        f (evaluar G.val (despues H p n), traza G.val (despues H p n))) := by
      congr 1
      funext G
      rw [despues_por_prefijo H G.val p n G.property]
    _ = promedio (fun G : Completaciones (vistas H p n) H =>
        f (evaluar G.val (despues H p n), traza G.val (despues H p n))) :=
      PromediosCompletaciones.media_equivalencia (equivalencia H p n)
        (fun G => f (evaluar G.val (despues H p n), traza G.val (despues H p n)))
    _ = _ := by
      simpa only [evaluar_registrar] using
        LeyArbol.ley_condicionada (registrar (despues H p n)) (vistas H p n) H f

theorem ley_cola (H : Q → A) (p : Arbol Q A R) (n : ℕ)
    (f : R × List (Q × A) → ℚ) :
    promedio (fun G : Tablas H p n => f (evaluar G.val p, (traza G.val p).drop n)) =
      LeyArbol.valor f (registrar (despues H p n)) (vistas H p n) H := by
  have h := ley_continuacion H p n f
  simpa only [resultado_despues, traza_despues] using h

end Nexus.ROM.ContinuacionPrefijo
