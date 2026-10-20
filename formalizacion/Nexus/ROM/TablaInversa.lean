module

public import Nexus.ROM.RegistroFinal
import Mathlib.Tactic

/-!
# Búsqueda de preimágenes usando solo respuestas almacenadas

La búsqueda recorre pares de la tabla; no consulta un oráculo total ni sus
valores fuera del pasado. La unicidad se exige solo en las entradas conocidas.
-/

public section
namespace Nexus.ROM.TablaInversa

open Nexus.Bytes Nexus.Merkle

@[expose] def buscarSalida : Tabla Entrada Digest → Digest → Option Entrada
  | [], _ => none
  | (e, d) :: t, s => if d = s then some e else buscarSalida t s

theorem salida_correcta (t : Tabla Entrada Digest) (s : Digest) (e : Entrada)
    (h : buscarSalida t s = some e) : (e, s) ∈ t := by
  induction t with
  | nil => contradiction
  | cons ed t ih =>
    obtain ⟨a, d⟩ := ed
    simp only [buscarSalida] at h
    split_ifs at h with hd
    · subst d
      have he := Option.some.inj h
      subst a
      exact List.mem_cons_self
    · exact List.mem_cons_of_mem _ (ih h)

theorem salida_ausente (t : Tabla Entrada Digest) (s : Digest) :
    buscarSalida t s = none ↔ ∀ e, (e, s) ∉ t := by
  induction t with
  | nil => simp only [buscarSalida, List.not_mem_nil, not_false_eq_true, forall_const]
  | cons ed t ih =>
    obtain ⟨a, d⟩ := ed
    by_cases hd : d = s
    · subst d
      simp only [buscarSalida, ite_true, reduceCtorEq, false_iff]
      intro h
      exact h a List.mem_cons_self
    · simp only [buscarSalida, hd, ite_false, ih]
      constructor
      · intro h e he
        rcases List.mem_cons.mp he with he | he
        · exact hd (Prod.mk.inj he).2.symm
        · exact h e he
      · intro h e he
        exact h e (List.mem_cons_of_mem _ he)

theorem preimagen_de_tabla (H : Entrada → Digest) (t : Tabla Entrada Digest)
    (hc : Compatibles H t) (hs : SinColisiones H (t.map Prod.fst)) (e : Entrada)
    (he : (e, H e) ∈ t) : buscarSalida t (H e) = some e := by
  have hn : buscarSalida t (H e) ≠ none := by
    intro h
    exact (salida_ausente t (H e)).mp h e he
  cases hp : buscarSalida t (H e) with
  | none => exact False.elim (hn hp)
  | some a =>
    have ha := salida_correcta t (H e) a hp
    have heq : a = e := hs a (List.mem_map.mpr ⟨(a, H e), ha, rfl⟩)
      e (List.mem_map.mpr ⟨(e, H e), he, rfl⟩) (hc a (H e) ha)
    rw [heq]

theorem salida_no_inventa (H : Entrada → Digest) (t : Tabla Entrada Digest) (hc : Compatibles H t)
    (s : Digest) (e : Entrada) (h : buscarSalida t s = some e) :
    e ∈ t.map Prod.fst ∧ H e = s := by
  have he := salida_correcta t s e h
  exact ⟨List.mem_map.mpr ⟨(e, s), he, rfl⟩, hc e s he⟩

end Nexus.ROM.TablaInversa
