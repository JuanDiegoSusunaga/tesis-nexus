module

public import Nexus.Canal.GramaticaTG2
public import Nexus.Bytes.Codec
import Mathlib.Tactic

/-!
# Lectura de las absorciones del canal observado

El lector comprueba etiqueta, datos canónicos y recodificación completa.
No identifica una entrada Merkle con un rol del canal fuera de una cadena.
-/

public section
namespace Nexus.Canal.LecturaAbsorcion

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks GramaticaTG2

@[expose] def bloque (n : ℕ) (bs : List Octeto) : Option (Datos n) :=
  if h : bs.length = n then some ⟨bs, h⟩ else none

theorem bloque_correcto {n : ℕ} (bs : Datos n) : bloque n bs.val = some bs := by
  simp only [bloque, bs.property, dite_true]

@[expose] def interpretar (tag : Octeto) (bs : List Octeto) : Option Absorcion :=
  if tag = 16 then (bloque 38 bs).map Absorcion.perfil else
  if tag = 4 then (bloque 24 bs).map Absorcion.enunciado else
  if tag = 1 then (bloque 32 bs).map Absorcion.raizTraza else
  if tag = 2 then (bloque 32 bs).map Absorcion.raizFRI else
  if tag = 17 then
    if bs = datos .faseTraza then some .faseTraza else
    if bs = datos .faseComposicion then some .faseComposicion else none
  else if tag = 3 then (leerFp2 bs).map Absorcion.final else
  if tag = 5 then
    (Lectura.exacto (Codecs.entero 8).leer bs).map
      (fun n => Absorcion.nonce ⟨n % 2 ^ 64, Nat.mod_lt _ (by positivity)⟩)
  else none

theorem interpretar_datos (a : Absorcion) : interpretar (etiqueta a) (datos a) = some a := by
  cases a with
  | nonce n =>
    have hn : n.val < 256 ^ 8 := by have h := n.isLt; norm_num at h ⊢; exact h
    simp only [etiqueta, datos, interpretar]
    norm_num only [Fin.isValue, show (5 : Octeto) ≠ 16 by decide,
      show (5 : Octeto) ≠ 4 by decide, show (5 : Octeto) ≠ 1 by decide,
      show (5 : Octeto) ≠ 2 by decide, show (5 : Octeto) ≠ 17 by decide,
      show (5 : Octeto) ≠ 3 by decide, ite_false, ite_true]
    have hr : Lectura.exacto (Codecs.entero 8).leer (codificarLE 8 n.val) = some n.val :=
      Codecs.lectura_completa (Codecs.entero 8) n.val hn
    rw [hr]
    exact congrArg some (congrArg Absorcion.nonce (Fin.ext (Nat.mod_eq_of_lt n.isLt)))
  | perfil bs | enunciado bs | raizTraza bs | raizFRI bs =>
    simp [etiqueta, datos, interpretar, bloque_correcto, Fin.ext_iff]
  | faseTraza | faseComposicion => simp [etiqueta, interpretar, datos, Fin.ext_iff]
  | final v => simp [etiqueta, datos, interpretar, leer_bytes_fp2, Fin.ext_iff]

@[expose] def leer (e : List Octeto) : Option Absorcion :=
  if h : 41 ≤ e.length then
    let s : Digest := ⟨e.take 32, by simp only [List.length_take]; omega⟩
    match (e.drop 32).head? with
    | none => none
    | some tag => (interpretar tag (e.drop 41)).bind
        (fun a => if entrada s a = e then some a else none)
  else none

theorem estado_absorcion (s : Digest) (a : Absorcion) : (entrada s a).take 32 = s.val := by
  simp only [entrada, entradaAbsorcion, cabecera, List.append_assoc]
  exact List.take_left' s.property

theorem etiqueta_absorcion (s : Digest) (a : Absorcion) :
    ((entrada s a).drop 32).head? = some (etiqueta a) := by
  simp only [entrada, entradaAbsorcion, cabecera, List.append_assoc]
  rw [List.drop_left' s.property]
  rfl

theorem leer_entrada (s : Digest) (a : Absorcion) : leer (entrada s a) = some a := by
  have hl : 41 ≤ (entrada s a).length := by rw [entrada, absorcion_longitud]; omega
  unfold leer
  rw [dite_eq_left hl]
  dsimp only
  rw [etiqueta_absorcion]
  rw [show (entrada s a).drop 41 = datos a from absorcion_datos s (etiqueta a) (datos a)]
  dsimp only
  rw [interpretar_datos]
  simp only [Option.bind_some]
  have hs : (⟨(entrada s a).take 32,
      by simp only [List.length_take]; omega⟩ : Digest) = s :=
    Subtype.ext (estado_absorcion s a)
  rw [hs]
  exact ite_eq_left rfl

theorem leer_canonico (e : List Octeto) (a : Absorcion) (h : leer e = some a) :
    ∃ s, entrada s a = e := by
  unfold leer at h
  split at h
  · rename_i hl
    cases ht : (e.drop 32).head? with
    | none => simp only [ht, reduceCtorEq] at h
    | some tag =>
      simp only [ht] at h
      cases hp : interpretar tag (e.drop 41) with
      | none => simp only [hp, Option.bind_none, reduceCtorEq] at h
      | some b =>
        simp only [hp, Option.bind_some] at h
        split_ifs at h with he
        · exact ⟨_, (Option.some.inj h) ▸ he⟩
  · contradiction

theorem leer_corto (e : List Octeto) (h : e.length < 41) : leer e = none := by
  simp only [leer, show ¬41 ≤ e.length by omega, dite_false]

theorem leer_reto (s : Digest) (tipo : TipoReto) : leer (entradaReto s tipo) = none :=
  leer_corto _ (by rw [reto_longitud]; omega)

theorem leer_inicio : leer (codificar .inicio) = none := leer_corto _ (by decide)

end Nexus.Canal.LecturaAbsorcion
