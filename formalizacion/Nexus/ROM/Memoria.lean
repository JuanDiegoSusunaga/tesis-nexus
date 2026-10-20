module

public import Mathlib.Data.List.Nodup
import Mathlib.Tactic

/-!
# Registro funcional de un oráculo con respuestas memorizadas

Las consultas repetidas reciben el valor guardado. Solo una entrada ausente
se añade a la tabla; su respuesta candidata se recibe antes de actualizarla.
-/

public section
namespace Nexus.ROM

variable {E D : Type*} [DecidableEq E]

abbrev Tabla (E D : Type*) := List (E × D)

@[expose] def buscar : Tabla E D → E → Option D
  | [], _ => none
  | (x, d) :: resto, e => if x = e then some d else buscar resto e

@[expose] def SinRepetidos (t : Tabla E D) : Prop := (t.map Prod.fst).Nodup

@[expose] def responder (t : Tabla E D) (e : E) (nuevo : D) : D × Tabla E D :=
  match buscar t e with
  | some d => (d, t)
  | none => (nuevo, t ++ [(e, nuevo)])

theorem buscar_some_mem (t : Tabla E D) (e : E) (d : D) (h : buscar t e = some d) : (e, d) ∈ t := by
  induction t with
  | nil => simp only [buscar, reduceCtorEq] at h
  | cons a resto ih =>
    rcases a with ⟨x, y⟩
    simp only [buscar] at h
    split_ifs at h with he
    · have hd := Option.some.inj h
      subst x
      subst y
      exact List.mem_cons_self
    · exact List.mem_cons_of_mem _ (ih h)

theorem buscar_none_iff (t : Tabla E D) (e : E) : buscar t e = none ↔ e ∉ t.map Prod.fst := by
  induction t with
  | nil => simp [buscar]
  | cons a resto ih =>
    rcases a with ⟨x, d⟩
    by_cases he : x = e
    · subst x
      simp only [buscar, ite_true, List.map_cons, List.mem_cons_self, not_true_eq_false, reduceCtorEq]
    · simp only [buscar, he, ite_false, ih, List.map_cons, List.mem_cons]
      tauto

theorem buscar_de_mem (t : Tabla E D) (ht : SinRepetidos t) (e : E) (d : D) (hm : (e, d) ∈ t) :
    buscar t e = some d := by
  induction t with
  | nil => simp only [List.not_mem_nil] at hm
  | cons a resto ih =>
    rcases a with ⟨x, y⟩
    have ht' : x ∉ resto.map Prod.fst ∧ (resto.map Prod.fst).Nodup := List.nodup_cons.mp ht
    rcases List.mem_cons.mp hm with he | hmem
    · cases he
      simp only [buscar, ite_true]
    · have hem : e ∈ resto.map Prod.fst := List.mem_map.mpr ⟨(e, d), hmem, rfl⟩
      have hne : x ≠ e := by
        intro he
        subst x
        exact ht'.1 hem
      simp only [buscar, hne, ite_false]
      exact ih ht'.2 hmem

theorem buscar_append (t u : Tabla E D) (e : E) :
    buscar (t ++ u) e = match buscar t e with | some d => some d | none => buscar u e := by
  induction t with
  | nil => rfl
  | cons a resto ih =>
    rcases a with ⟨x, d⟩
    by_cases he : x = e <;> simp only [List.cons_append, buscar, he, reduceIte, ih]

theorem buscar_conservado (t u : Tabla E D) (e : E) (d : D) (h : buscar t e = some d) :
    buscar (t ++ u) e = some d := by
  rw [buscar_append, h]

theorem buscar_anexado (t : Tabla E D) (e : E) (d : D) (h : buscar t e = none) :
    buscar (t ++ [(e, d)]) e = some d := by
  simp only [buscar_append, h, buscar, ite_true]

theorem sin_repetidos_anexar (t : Tabla E D) (e : E) (d : D) (ht : SinRepetidos t)
    (hn : buscar t e = none) : SinRepetidos (t ++ [(e, d)]) := by
  have he := (buscar_none_iff t e).mp hn
  simp only [SinRepetidos, List.map_append, List.map_cons, List.map_nil]
  refine List.nodup_append.mpr ⟨ht, by simp, ?_⟩
  intro x hx y hy hxy
  have hye : y = e := List.mem_singleton.mp hy
  exact he ((hxy.trans hye) ▸ hx)

theorem respuesta_repetida (t : Tabla E D) (e : E) (guardado nuevo : D) (h : buscar t e = some guardado) :
    responder t e nuevo = (guardado, t) := by simp only [responder, h]

theorem respuesta_nueva (t : Tabla E D) (e : E) (nuevo : D) (h : buscar t e = none) :
    responder t e nuevo = (nuevo, t ++ [(e, nuevo)]) := by simp only [responder, h]

end Nexus.ROM
