module

public import Nexus.ROM.ContinuacionPrefijo
import Mathlib.Tactic

/-!
# Primera consulta de una dirección en una transcripción real

El programa residual se reconstruye usando únicamente las respuestas ya
observadas. Una activación exige que la próxima consulta sea la dirección
del candidato y que esa dirección no figure en el pasado.
-/

public section
namespace Nexus.ROM.PrimeraExposicion

open LeyArbol ContinuacionPrefijo

variable {Q A X : Type}

@[expose] def reanudar (p : Arbol Q A X) : List (Q × A) → Arbol Q A X
  | [] => p
  | (_, a) :: t => match p with
      | .terminar r => .terminar r
      | .consultar _ k => reanudar (k a) t

@[expose] def proxima : Arbol Q A X → Option Q
  | .terminar _ => none
  | .consultar q _ => some q

theorem reanudar_prefijo (H : Q → A) (p : Arbol Q A X) (n : ℕ) :
    reanudar p ((traza H p).take n) = despues H p n := by
  induction n generalizing p with
  | zero => cases p <;> rfl
  | succ n ih => cases p with
    | terminar => rfl
    | consultar q k => simpa only [traza, List.take_succ_cons, reanudar, despues] using ih (k (H q))

theorem proxima_traza (H : Q → A) (p : Arbol Q A X) :
    proxima p = (traza H p).head?.map Prod.fst := by cases p <;> rfl

theorem proxima_prefijo (H : Q → A) (p : Arbol Q A X) (n : ℕ) :
    proxima (reanudar p ((traza H p).take n)) = ((traza H p).map Prod.fst)[n]? := by
  rw [reanudar_prefijo, proxima_traza H, traza_despues]
  simp only [List.head?_drop, List.getElem?_map]

variable [DecidableEq Q]
attribute [local instance] Classical.propDecidable

abbrev Activa (p : Arbol Q A X) (direccion : List (Q × A) → Q) (t : List (Q × A)) : Prop :=
  proxima (reanudar p t) = some (direccion t) ∧ direccion t ∉ (t.map Prod.fst).toFinset

theorem activa_iff (H : Q → A) (p : Arbol Q A X) (n : ℕ) (direccion : List (Q × A) → Q) :
    Activa p direccion ((traza H p).take n) ↔
      ((traza H p).map Prod.fst)[n]? = some (direccion ((traza H p).take n)) ∧
        direccion ((traza H p).take n) ∉ (((traza H p).map Prod.fst).take n) := by
  simp only [Activa, proxima_prefijo, List.mem_toFinset, List.map_take]

theorem indice_primero (l : List Q) (n : ℕ) (e : Q)
    (hn : l[n]? = some e) (hf : e ∉ l.take n) : l.idxOf e = n := by
  have he : e ∈ l := List.mem_of_getElem? hn
  have hle : l.idxOf e ≤ n := by
    have ht : e ∈ l.take (n + 1) := by
      apply List.mem_of_getElem? (i := n)
      simpa only [List.getElem?_take, show n < n + 1 by omega, ite_true] using hn
    have := (List.mem_take_iff_idxOf_lt he).mp ht
    omega
  have hge : n ≤ l.idxOf e := by
    have := (List.mem_take_iff_idxOf_lt he).not.mp hf
    omega
  omega

theorem activa_indice (H : Q → A) (p : Arbol Q A X) (n : ℕ) (direccion : List (Q × A) → Q)
    (h : Activa p direccion ((traza H p).take n)) :
    ((traza H p).map Prod.fst).idxOf (direccion ((traza H p).take n)) = n := by
  obtain ⟨hn, hf⟩ := (activa_iff H p n direccion).mp h
  exact indice_primero _ _ _ hn hf

theorem activa_registrada (H : Q → A) (p : Arbol Q A X) (n : ℕ) (direccion : List (Q × A) → Q)
    (h : Activa p direccion ((traza H p).take n)) :
    direccion ((traza H p).take n) ∈ ((traza H p).map Prod.fst).toFinset := by
  exact List.mem_toFinset.mpr (List.mem_of_getElem? ((activa_iff H p n direccion).mp h).1)

theorem sin_doble_carga (H : Q → A) (p : Arbol Q A X) (n m : ℕ)
    (direccion : List (Q × A) → Q)
    (hn : Activa p direccion ((traza H p).take n)) (hm : Activa p direccion ((traza H p).take m))
    (he : direccion ((traza H p).take n) = direccion ((traza H p).take m)) : n = m := by
  have h1 := activa_indice H p n direccion hn
  have h2 := activa_indice H p m direccion hm
  rw [he] at h1
  exact h1.symm.trans h2

theorem existe_primera (H : Q → A) (p : Arbol Q A X) (e : Q)
    (he : e ∈ ((traza H p).map Prod.fst)) :
    ∃ n, n < (traza H p).length ∧
      Activa p (fun _ => e) ((traza H p).take n) := by
  refine ⟨((traza H p).map Prod.fst).idxOf e, ?_, ?_⟩
  · simpa only [List.length_map] using List.idxOf_lt_length_of_mem he
  · rw [activa_iff]
    exact ⟨List.getElem?_idxOf he, by simp only [List.mem_take_iff_idxOf_lt he, lt_self_iff_false, not_false_eq_true]⟩

end Nexus.ROM.PrimeraExposicion
