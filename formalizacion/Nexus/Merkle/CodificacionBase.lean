module

public import Nexus.Merkle.Codificacion
public import Nexus.Merkle.Etiquetas
import Mathlib.Tactic

/-!
# Hojas canónicas del campo base y nodos compartidos

Una hoja Fp tiene un prefijo cero y ocho octetos LE. Una hoja Fp2 tiene
diecisiete octetos y no se acepta como hoja base. Ambos formatos comparten
los nodos y las etiquetas que protegen la extracción. No se identifican
los hashes de dos serializaciones distintas de un mismo valor algebraico.
-/

public section
namespace Nexus.Merkle

open Nexus.Bytes Nexus.Goldilocks

@[expose] def bytesFp (v : Fp) : List Octeto := codificarLE 8 v.val

@[expose] def leerFp (bs : List Octeto) : Option Fp :=
  if bs.length = 8 then if leerLE bs < p then some (leerLE bs : Fp) else none else none

theorem bytes_fp_longitud (v : Fp) : (bytesFp v).length = 8 := codificar_le_longitud 8 v.val

theorem leer_bytes_fp (v : Fp) : leerFp (bytesFp v) = some v := by
  have hb : p < 256 ^ 8 := by norm_num [p]
  have hr : leerLE (bytesFp v) = v.val := by
    simpa only [bytesFp] using leer_le_codificar 8 v.val (v.val_lt.trans hb)
  simp only [leerFp, bytes_fp_longitud, ite_true, hr, v.val_lt, ZMod.natCast_zmod_val]

theorem bytes_de_fp_leido (bs : List Octeto) (v : Fp) (h : leerFp bs = some v) : bytesFp v = bs := by
  unfold leerFp at h
  split_ifs at h with hl hc
  · have he := Option.some.inj h
    subst v
    simp only [bytesFp, ZMod.val_natCast_of_lt hc]
    simpa only [hl] using codificar_le_leer bs

theorem bytes_fp_inyectivos : Function.Injective bytesFp := by
  intro v w h
  have he := congrArg leerFp h
  exact Option.some.inj (by simpa only [leer_bytes_fp] using he)

@[expose] def codificarHojaBase (v : Fp) : List Octeto := 0 :: bytesFp v

@[expose] def decodificarBase : List Octeto → Option (Contenido Fp Digest)
  | [] => none
  | tag :: bs =>
      if tag = 0 then (leerFp bs).map Contenido.hoja
      else if tag = 1 then
        if hl : bs.length = 64 then
          some (.nodo ⟨bs.take 32, by simp only [List.length_take, hl]; decide⟩
            ⟨bs.drop 32, by simp only [List.length_drop, hl]⟩)
        else none
      else none

theorem hoja_base_longitud (v : Fp) : (codificarHojaBase v).length = 9 := by
  simp only [codificarHojaBase, List.length_cons, bytes_fp_longitud]

theorem decodificar_hoja_base (v : Fp) : decodificarBase (codificarHojaBase v) = some (.hoja v) := by
  simp only [codificarHojaBase, decodificarBase, ite_true, leer_bytes_fp, Option.map_some]

theorem decodificar_nodo_base (l r : Digest) : decodificarBase (codificarNodo l r) = some (.nodo l r) := by
  have ht : (l.val ++ r.val).take 32 = l.val := List.take_left' l.property
  have hd : (l.val ++ r.val).drop 32 = r.val := List.drop_left' l.property
  simp only [codificarNodo, decodificarBase, show (1 : Octeto) ≠ 0 by decide, ite_false,
    ite_true, List.length_append, l.property, r.property, ht, hd]
  simp only [dite_eq_left True.intro]

@[expose] def formatoBase : Formato Fp Digest (List Octeto) where
  hoja := codificarHojaBase
  nodo := codificarNodo
  leer := decodificarBase
  leer_hoja := decodificar_hoja_base
  leer_nodo := decodificar_nodo_base

theorem nodo_base_decodificado_canonico (bs : List Octeto) (l r : Digest)
    (h : decodificarBase bs = some (.nodo l r)) : bs = codificarNodo l r := by
  cases bs with
  | nil => simp only [decodificarBase, reduceCtorEq] at h
  | cons tag bs =>
    simp only [decodificarBase] at h
    split_ifs at h with h0 h1 hl
    · cases hf : leerFp bs <;>
        simp only [hf, Option.map_none, Option.map_some, Option.some.injEq, reduceCtorEq] at h
    · have he := Option.some.inj h
      cases he
      simp only [codificarNodo, List.take_append_drop, h1]

theorem hoja_base_decodificada_canonica (bs : List Octeto) (v : Fp)
    (h : decodificarBase bs = some (.hoja v)) : bs = codificarHojaBase v := by
  cases bs with
  | nil => simp only [decodificarBase, reduceCtorEq] at h
  | cons tag bs =>
    simp only [decodificarBase] at h
    split_ifs at h with h0 h1 hl
    · cases hf : leerFp bs with
      | none => simp only [hf, Option.map_none, reduceCtorEq] at h
      | some w =>
        simp only [hf, Option.map_some, Option.some.injEq, Contenido.hoja.injEq] at h
        subst w
        rw [← bytes_de_fp_leido bs v hf]
        exact congrArg (· :: bytesFp v) h0
    all_goals simp only [Option.some.injEq, reduceCtorEq] at h

theorem hojas_base_extension_distintas (v : Fp) (w : Fp2) : codificarHojaBase v ≠ codificarHoja w := by
  intro h
  have he := congrArg List.length h
  rw [hoja_base_longitud, hoja_codificada_longitud] at he
  omega

theorem formatos_hoja_se_rechazan (v : Fp) (w : Fp2) :
    decodificarBase (codificarHoja w) = none ∧ decodificarMerkle (codificarHojaBase v) = none := by
  have hb : leerFp (bytesFp2 w) = none := by
    simp only [leerFp, bytes_fp2_longitud, show (16 : ℕ) ≠ 8 by decide, ite_false]
  have he : leerFp2 (bytesFp v) = none := by
    simp only [leerFp2, bytes_fp_longitud, show (8 : ℕ) ≠ 16 by decide, ite_false]
  constructor
  · simp only [codificarHoja, decodificarBase, ite_true, hb, Option.map_none]
  · simp only [codificarHojaBase, decodificarMerkle, ite_true, he, Option.map_none]

theorem etiquetas_base_entrada_coinciden (H : List Octeto → Digest) (bs : List Octeto) :
    etiquetasEntrada formatoBase H bs = etiquetasEntrada formatoBytes H bs := by
  cases bs with
  | nil => rfl
  | cons tag bs =>
    by_cases h0 : tag = 0
    · simp only [etiquetasEntrada, formatoBase, formatoBytes, decodificarBase, decodificarMerkle, h0, ite_true]
      cases hb : leerFp bs <;> cases he : leerFp2 bs <;> rfl
    · by_cases h1 : tag = 1
      · subst tag
        by_cases hl : bs.length = 64 <;>
          simp only [etiquetasEntrada, formatoBase, formatoBytes, decodificarBase, decodificarMerkle,
            show (1 : Octeto) ≠ 0 by decide, ite_false, ite_true, hl, reduceDIte]
      · simp only [etiquetasEntrada, formatoBase, formatoBytes, decodificarBase, decodificarMerkle,
          h0, h1, ite_false]

theorem etiquetas_base_coinciden (H : List Octeto → Digest) (raiz : Digest) (registro : List (List Octeto)) :
    etiquetas formatoBase H raiz registro = etiquetas formatoBytes H raiz registro := by
  induction registro with
  | nil => rfl
  | cons e resto ih => simp only [etiquetas, etiquetas_base_entrada_coinciden, ih]

end Nexus.Merkle
