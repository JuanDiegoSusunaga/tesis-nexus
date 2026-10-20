module

public import Nexus.ROM.EjecucionBytes
public import Nexus.ROM.TablaObservada
import Mathlib.Tactic

/-!
# Estados y continuación en un prefijo de llamadas

El número de llamadas cuenta también las repeticiones. El estado conserva
solo las entradas nuevas y se reconstruye su tabla desde los pares del pasado.
-/

public section
namespace Nexus.ROM.PrefijoPrograma

open Nexus.Bytes Nexus.Merkle ProgramaBytes EjecucionBytes

variable {A : Type}

@[expose] def resto (H : Entrada → Digest) (p : Programa A) : ℕ → Programa A
  | 0 => p
  | n + 1 => match p with
      | .terminar a => .terminar a
      | .consultar e f => resto H (f (H e)) n

@[expose] def estado (H : Entrada → Digest) {B : ℕ} (s : Estado B) (p : Programa A) : ℕ → Estado B
  | 0 => s
  | n + 1 => match p with
      | .terminar _ => s
      | .consultar e f => estado H (avanzar H s e) (f (H e)) n

@[expose] def reanudar (p : Programa A) : List (Entrada × Digest) → Programa A
  | [] => p
  | (_, d) :: t => match p with
      | .terminar a => .terminar a
      | .consultar _ f => reanudar (f d) t

@[expose] def proxima : Programa A → Option Entrada
  | .terminar _ => none
  | .consultar e _ => some e

theorem reanudar_prefijo (H : Entrada → Digest) (p : Programa A) (n : ℕ) :
    reanudar p ((traza H p).take n) = resto H p n := by
  induction n generalizing p with
  | zero => cases p <;> rfl
  | succ n ih => cases p with
    | terminar a => rfl
    | consultar e f => simpa only [traza, List.take_succ_cons, reanudar, resto] using ih (f (H e))

theorem traza_resto (H : Entrada → Digest) (p : Programa A) (n : ℕ) :
    traza H (resto H p n) = (traza H p).drop n := by
  induction n generalizing p with
  | zero => cases p <;> rfl
  | succ n ih => cases p with
    | terminar a => simp only [resto, traza, List.drop_nil]
    | consultar e f => simpa only [resto, traza, List.drop_succ_cons] using ih (f (H e))

theorem proxima_traza (H : Entrada → Digest) (p : Programa A) :
    proxima p = (traza H p).head?.map Prod.fst := by cases p <;> rfl

theorem proxima_prefijo (H : Entrada → Digest) (p : Programa A) (n : ℕ) :
    proxima (reanudar p ((traza H p).take n)) = (entradas H p)[n]? := by
  rw [reanudar_prefijo, proxima_traza H, traza_resto]
  simp only [entradas, List.head?_drop, List.getElem?_map]

theorem avanzar_tabla (H : Entrada → Digest) {B : ℕ} (s : Estado B) (e : Entrada) :
    (avanzar H s e).tabla = TablaObservada.agregar s.tabla (e, H e) := by
  by_cases hh : buscar s.tabla e = none
  · rw [avanzar, dite_eq_left hh]
    simp only [estadoNuevo, solicitar, TablaObservada.agregar, responder, hh]
  · rw [avanzar, dite_eq_right hh]
    unfold TablaObservada.agregar responder
    cases hv : buscar s.tabla e with
    | none => contradiction
    | some d => rfl

theorem tabla_estado (H : Entrada → Digest) {B : ℕ} (s : Estado B) (p : Programa A) (n : ℕ) :
    (estado H s p n).tabla = TablaObservada.recorrer s.tabla ((traza H p).take n) := by
  induction n generalizing s p with
  | zero => cases p <;> rfl
  | succ n ih => cases p with
    | terminar a => rfl
    | consultar e f =>
      simp only [estado, traza, List.take_succ_cons, TablaObservada.recorrer, List.foldl_cons]
      simpa only [TablaObservada.recorrer, avanzar_tabla] using ih (avanzar H s e) (f (H e))

theorem tabla_desde_vacio (H : Entrada → Digest) (B : ℕ) (p : Programa A) (n : ℕ) :
    (estado H (inicial B) p n).tabla = TablaObservada.tabla ((traza H p).take n) :=
  tabla_estado H (inicial B) p n

theorem estado_al_final (H : Entrada → Digest) {B : ℕ} (s : Estado B) (p : Programa A) :
    estado H s p (traza H p).length = final H s p := by
  induction p generalizing s with
  | terminar a => rfl
  | consultar e f ih => exact ih (H e) (avanzar H s e)

theorem tabla_final (H : Entrada → Digest) (B : ℕ) (p : Programa A) :
    (final H (inicial B) p).tabla = TablaObservada.tabla (traza H p) := by
  have h := tabla_desde_vacio H B p (traza H p).length
  simpa only [estado_al_final, List.take_length] using h

theorem final_resto (H : Entrada → Digest) {B : ℕ} (s : Estado B) (p : Programa A) (n : ℕ) :
    final H (estado H s p n) (resto H p n) = final H s p := by
  induction n generalizing s p with
  | zero => cases p <;> rfl
  | succ n ih => cases p with
    | terminar a => rfl
    | consultar e f => exact ih (avanzar H s e) (f (H e))

theorem sinbad_resto (H : Entrada → Digest) {B : ℕ} (s : Estado B) (p : Programa A) (n : ℕ)
    (hs : SinBad H s p) : SinBad H (estado H s p n) (resto H p n) := by
  induction n generalizing s p with
  | zero => cases p <;> exact hs
  | succ n ih => cases p with
    | terminar a => trivial
    | consultar e f => exact ih (avanzar H s e) (f (H e)) hs.2

theorem compatible_estado (H : Entrada → Digest) {B : ℕ} (s : Estado B) (p : Programa A) (n : ℕ)
    (hc : Compatibles H s.tabla) : Compatibles H (estado H s p n).tabla := by
  induction n generalizing s p with
  | zero => cases p <;> exact hc
  | succ n ih => cases p with
    | terminar a => exact hc
    | consultar e f => exact ih (avanzar H s e) (f (H e)) (avanzar_compatible H s e hc)

theorem recorrido_prefijo (H : Entrada → Digest) {B : ℕ} (s : Estado B) (p : Programa A) (n : ℕ)
    (hc : Compatibles H s.tabla) (hs : SinBad H s p) :
    RecorridoSinAcierto B s (estado H s p n) := by
  induction n generalizing s p with
  | zero => cases p <;> exact .refl _
  | succ n ih => cases p with
    | terminar a => exact .refl _
    | consultar e f =>
      have paso : RecorridoSinAcierto B s (avanzar H s e) := by
        unfold avanzar
        split
        · exact .nueva (.refl _) _ _ ‹_› (hs.1 ‹_›)
        · cases hh : buscar s.tabla e with
          | none => contradiction
          | some d => exact .repetida (.refl _) _ d hh
      exact recorrido_trans paso (ih (avanzar H s e) (f (H e)) (avanzar_compatible H s e hc) hs.2)

end Nexus.ROM.PrefijoPrograma
