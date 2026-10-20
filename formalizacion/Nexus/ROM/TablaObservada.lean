module

public import Nexus.ROM.Memoria
public import Mathlib.Data.Finset.Dedup
public import Mathlib.Data.Finset.Card
import Mathlib.Tactic

/-!
# Tabla obtenida únicamente del pasado observado

Las respuestas repetidas conservan el primer par almacenado. La función
consume una transcripción, sin consultar un oráculo ni leer su continuación.
-/

public section
namespace Nexus.ROM.TablaObservada

variable {E D : Type} [DecidableEq E]

@[expose] def agregar (t : Tabla E D) (ed : E × D) : Tabla E D :=
  (responder t ed.1 ed.2).2

@[expose] def recorrer (t : Tabla E D) (historia : List (E × D)) : Tabla E D :=
  historia.foldl agregar t

@[expose] def tabla (historia : List (E × D)) : Tabla E D := recorrer [] historia

theorem claves_agregar (t : Tabla E D) (ed : E × D) (e : E) :
    e ∈ (agregar t ed).map Prod.fst ↔ e = ed.1 ∨ e ∈ t.map Prod.fst := by
  unfold agregar responder
  cases hh : buscar t ed.1 with
  | none => simp only [List.map_append, List.map_cons, List.map_nil, List.mem_append,
      List.mem_cons, List.not_mem_nil, or_false]; tauto
  | some d =>
    have hm : ed.1 ∈ t.map Prod.fst := List.mem_map.mpr
      ⟨(ed.1, d), buscar_some_mem _ _ _ hh, rfl⟩
    dsimp only
    constructor
    · exact Or.inr
    · rintro (rfl | he)
      · exact hm
      · exact he

theorem claves_recorrer (t : Tabla E D) (historia : List (E × D)) (e : E) :
    e ∈ (recorrer t historia).map Prod.fst ↔
      e ∈ t.map Prod.fst ∨ e ∈ historia.map Prod.fst := by
  induction historia generalizing t with
  | nil => simp only [recorrer, List.foldl_nil, List.map_nil, List.not_mem_nil, or_false]
  | cons ed historia ih =>
    simp only [recorrer, List.foldl_cons] at *
    rw [ih, claves_agregar]
    simp only [List.map_cons, List.mem_cons]
    tauto

theorem claves_tabla (historia : List (E × D)) (e : E) :
    e ∈ (tabla historia).map Prod.fst ↔ e ∈ historia.map Prod.fst := by
  simpa only [tabla, List.map_nil, List.not_mem_nil, false_or] using
    claves_recorrer [] historia e

theorem sin_repetidos_agregar (t : Tabla E D) (ed : E × D) (ht : SinRepetidos t) :
    SinRepetidos (agregar t ed) := by
  unfold agregar responder
  cases hh : buscar t ed.1 with
  | none => exact sin_repetidos_anexar t ed.1 ed.2 ht hh
  | some d => exact ht

theorem sin_repetidos_recorrer (t : Tabla E D) (historia : List (E × D)) (ht : SinRepetidos t) :
    SinRepetidos (recorrer t historia) := by
  induction historia generalizing t with
  | nil => exact ht
  | cons ed historia ih => exact ih _ (sin_repetidos_agregar t ed ht)

theorem sin_repetidos_tabla (historia : List (E × D)) : SinRepetidos (tabla historia) :=
  sin_repetidos_recorrer [] historia (by simp [SinRepetidos])

theorem cardinal_tabla (historia : List (E × D)) :
    (tabla historia).length = (historia.map Prod.fst).toFinset.card := by
  have he : ((tabla historia).map Prod.fst).toFinset = (historia.map Prod.fst).toFinset := by
    ext e
    simp only [List.mem_toFinset, claves_tabla]
  rw [← he, List.toFinset_card_of_nodup (sin_repetidos_tabla historia), List.length_map]

end Nexus.ROM.TablaObservada
