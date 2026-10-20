module

public import Nexus.ROM.Memoria
public import Nexus.Merkle.MarcasGlobales
import Mathlib.Tactic

/-!
# Juego finito de consultas adaptativas con memoria

La solicitud y sus marcas adicionales se eligen antes de la respuesta.
Las ramas repetidas solo reciben el digest guardado y no gastan presupuesto
de respuestas frescas. Cada rama nueva recibe un digest uniforme.
-/

public section
namespace Nexus.ROM

open Nexus.Bytes Nexus.Merkle

abbrev Entrada := List Octeto

@[expose] def marcasPar (ed : Entrada × Digest) : Finset Digest :=
  insert ed.2 (ventanas ed.1)

@[expose] def marcasTabla : Tabla Entrada Digest → Finset Digest
  | [] => ∅
  | ed :: resto => marcasPar ed ∪ marcasTabla resto

theorem marcas_par_card (ed : Entrada × Digest) : (marcasPar ed).card ≤ 49 :=
  (Finset.card_insert_le _ _).trans (by have h := ventanas_card ed.1; omega)

theorem marcas_tabla_card (t : Tabla Entrada Digest) : (marcasTabla t).card ≤ 49 * t.length := by
  induction t with
  | nil => simp only [marcasTabla, Finset.card_empty, List.length_nil, Nat.mul_zero, le_refl]
  | cons ed resto ih =>
    have hu := Finset.card_union_le (marcasPar ed) (marcasTabla resto)
    have he := marcas_par_card ed
    change (marcasPar ed ∪ marcasTabla resto).card ≤ _
    simp only [List.length_cons]
    omega

theorem marcas_par_incluidas (t : Tabla Entrada Digest) (ed : Entrada × Digest) (he : ed ∈ t) :
    marcasPar ed ⊆ marcasTabla t := by
  induction t with
  | nil => simp only [List.not_mem_nil] at he
  | cons a resto ih =>
    rcases List.mem_cons.mp he with rfl | he
    · exact Finset.subset_union_left
    · exact (ih he).trans Finset.subset_union_right

theorem marcas_tabla_append (t u : Tabla Entrada Digest) :
    marcasTabla (t ++ u) = marcasTabla t ∪ marcasTabla u := by
  induction t with
  | nil => simp only [List.nil_append, marcasTabla, Finset.empty_union]
  | cons ed resto ih => simp only [List.cons_append, marcasTabla, ih, Finset.union_assoc]

structure Estado (B : ℕ) where
  tabla : Tabla Entrada Digest
  sinRepetidos : SinRepetidos tabla
  adicionales : Finset Digest
  cotaAdicionales : adicionales.card ≤ B

structure Solicitud {B : ℕ} (s : Estado B) where
  entrada : Entrada
  nuevas : Finset Digest
  cota : (s.adicionales ∪ nuevas).card ≤ B

@[expose] def inicial (B : ℕ) : Estado B :=
  ⟨[], by simp [SinRepetidos], ∅, by simp⟩

@[expose] def estadoRepetido {B : ℕ} (s : Estado B) (q : Solicitud s) : Estado B :=
  ⟨s.tabla, s.sinRepetidos, s.adicionales ∪ q.nuevas, q.cota⟩

@[expose] def estadoNuevo {B : ℕ} (s : Estado B) (q : Solicitud s) (d : Digest)
    (hn : buscar s.tabla q.entrada = none) : Estado B :=
  ⟨s.tabla ++ [(q.entrada, d)], sin_repetidos_anexar _ _ _ s.sinRepetidos hn,
    s.adicionales ∪ q.nuevas, q.cota⟩

@[expose] def marcasEstado {B : ℕ} (s : Estado B) : Finset Digest :=
  s.adicionales ∪ marcasTabla s.tabla

@[expose] def antesRespuesta {B : ℕ} (s : Estado B) (q : Solicitud s) : Finset Digest :=
  (s.adicionales ∪ q.nuevas) ∪ marcasTabla s.tabla ∪ ventanas q.entrada

theorem marcas_estado_card {B : ℕ} (s : Estado B) :
    (marcasEstado s).card ≤ 49 * s.tabla.length + B := by
  have hu := Finset.card_union_le s.adicionales (marcasTabla s.tabla)
  have ht := marcas_tabla_card s.tabla
  have ha := s.cotaAdicionales
  exact hu.trans (by omega)

theorem antes_respuesta_card {B : ℕ} (s : Estado B) (q : Solicitud s) (S : ℕ)
    (hs : s.tabla.length < S) : (antesRespuesta s q).card ≤ 49 * S + B := by
  have h1 := Finset.card_union_le (s.adicionales ∪ q.nuevas) (marcasTabla s.tabla)
  have h2 := Finset.card_union_le ((s.adicionales ∪ q.nuevas) ∪ marcasTabla s.tabla)
    (ventanas q.entrada)
  have ht := marcas_tabla_card s.tabla
  have hv := ventanas_card q.entrada
  have ha := q.cota
  exact h2.trans (by omega)

theorem marcas_repeticion_mono {B : ℕ} (s : Estado B) (q : Solicitud s) :
    marcasEstado s ⊆ marcasEstado (estadoRepetido s q) := by
  intro d hd
  simp only [marcasEstado, estadoRepetido, Finset.mem_union] at hd ⊢
  tauto

theorem marcas_nueva_mono {B : ℕ} (s : Estado B) (q : Solicitud s) (d : Digest)
    (hn : buscar s.tabla q.entrada = none) : marcasEstado s ⊆ marcasEstado (estadoNuevo s q d hn) := by
  intro x hx
  simp only [marcasEstado, estadoNuevo, marcas_tabla_append, Finset.mem_union] at hx ⊢
  tauto

/-- El índice cuenta solo las respuestas nuevas que quedan disponibles. -/
inductive Plan (B : ℕ) : Estado B → ℕ → Type
  | terminar (s : Estado B) (n : ℕ) : Plan B s n
  | repetir {s : Estado B} {n : ℕ} (q : Solicitud s) (d : Digest)
      (hd : buscar s.tabla q.entrada = some d)
      (resto : Plan B (estadoRepetido s q) n) : Plan B s n
  | nuevo {s : Estado B} {n : ℕ} (q : Solicitud s)
      (hn : buscar s.tabla q.entrada = none)
      (resto : ∀ d : Digest, Plan B (estadoNuevo s q d hn) n) : Plan B s (n + 1)

end Nexus.ROM
