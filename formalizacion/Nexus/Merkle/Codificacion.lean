module

public import Nexus.Bytes.LittleEndian
public import Nexus.Campos.Goldilocks
public import Nexus.Merkle.Registro
public import Mathlib.Data.Fintype.Vector
import Mathlib.Tactic

/-!
# Formato de bytes canónicos de hojas Fp2 y nodos Merkle

Una hoja tiene prefijo 00 y dos coordenadas canónicas de ocho octetos LE.
Un nodo tiene prefijo 01 y dos digests de 32 octetos. La decodificación
rechaza longitudes, prefijos y coordenadas no canónicos.
-/

public section
namespace Nexus.Merkle

open Nexus.Bytes Nexus.Goldilocks

abbrev Digest := {ds : List Octeto // ds.length = 32}

instance : Fintype Digest := inferInstanceAs (Fintype (List.Vector Octeto 32))

@[expose] def bytesFp2 (v : Fp2) : List Octeto :=
  codificarLE 8 v.re.val ++ codificarLE 8 v.im.val

@[expose] def leerFp2 (bs : List Octeto) : Option Fp2 :=
  if bs.length = 16 then
    if leerLE (bs.take 8) < p ∧ leerLE (bs.drop 8) < p then
      some ⟨(leerLE (bs.take 8) : Fp), (leerLE (bs.drop 8) : Fp)⟩
    else none
  else none

theorem bytes_fp2_longitud (v : Fp2) : (bytesFp2 v).length = 16 := by
  simp only [bytesFp2, List.length_append, codificar_le_longitud]

theorem leer_bytes_fp2 (v : Fp2) : leerFp2 (bytesFp2 v) = some v := by
  have hb : p < 256 ^ 8 := by norm_num [p]
  have hr := leer_le_codificar 8 v.re.val (v.re.val_lt.trans hb)
  have hi := leer_le_codificar 8 v.im.val (v.im.val_lt.trans hb)
  have ht : (bytesFp2 v).take 8 = codificarLE 8 v.re.val :=
    List.take_left' (codificar_le_longitud 8 v.re.val)
  have hd : (bytesFp2 v).drop 8 = codificarLE 8 v.im.val :=
    List.drop_left' (codificar_le_longitud 8 v.re.val)
  simp only [leerFp2, bytes_fp2_longitud, ht, hd, hr, hi, v.re.val_lt, v.im.val_lt,
    and_self, ite_true, ZMod.natCast_zmod_val]

theorem bytes_de_fp2_leido (bs : List Octeto) (v : Fp2) (h : leerFp2 bs = some v) : bytesFp2 v = bs := by
  unfold leerFp2 at h
  split_ifs at h with hl hc
  · have he := Option.some.inj h
    subst v
    have ht : (bs.take 8).length = 8 := by simp only [List.length_take, hl]; decide
    have hd : (bs.drop 8).length = 8 := by simp only [List.length_drop, hl]
    have hct : codificarLE 8 (leerLE (bs.take 8)) = bs.take 8 := by
      simpa only [ht] using codificar_le_leer (bs.take 8)
    have hcd : codificarLE 8 (leerLE (bs.drop 8)) = bs.drop 8 := by
      simpa only [hd] using codificar_le_leer (bs.drop 8)
    simp only [bytesFp2, ZMod.val_natCast_of_lt hc.1, ZMod.val_natCast_of_lt hc.2]
    rw [hct, hcd, List.take_append_drop]

@[expose] def codificarHoja (v : Fp2) : List Octeto := 0 :: bytesFp2 v

@[expose] def codificarNodo (l r : Digest) : List Octeto := 1 :: (l.val ++ r.val)

@[expose] def decodificarMerkle : List Octeto → Option (Contenido Fp2 Digest)
  | [] => none
  | tag :: bs =>
      if tag = 0 then (leerFp2 bs).map Contenido.hoja
      else if tag = 1 then
        if hl : bs.length = 64 then
          some (.nodo ⟨bs.take 32, by simp only [List.length_take, hl]; decide⟩
            ⟨bs.drop 32, by simp only [List.length_drop, hl]⟩)
        else none
      else none

theorem hoja_codificada_longitud (v : Fp2) : (codificarHoja v).length = 17 := by
  simp only [codificarHoja, List.length_cons, bytes_fp2_longitud]

theorem nodo_codificado_longitud (l r : Digest) : (codificarNodo l r).length = 65 := by
  simp only [codificarNodo, List.length_cons, List.length_append, l.property, r.property]

theorem decodificar_hoja (v : Fp2) : decodificarMerkle (codificarHoja v) = some (.hoja v) := by
  simp only [codificarHoja, decodificarMerkle, ite_true, leer_bytes_fp2, Option.map_some]

theorem decodificar_nodo (l r : Digest) : decodificarMerkle (codificarNodo l r) = some (.nodo l r) := by
  have ht : (l.val ++ r.val).take 32 = l.val := List.take_left' l.property
  have hd : (l.val ++ r.val).drop 32 = r.val := List.drop_left' l.property
  simp only [codificarNodo, decodificarMerkle, show (1 : Octeto) ≠ 0 by decide, ite_false,
    ite_true, List.length_append, l.property, r.property, ht, hd]
  simp only [dite_eq_left True.intro]

@[expose] def formatoBytes : Formato Fp2 Digest (List Octeto) where
  hoja := codificarHoja
  nodo := codificarNodo
  leer := decodificarMerkle
  leer_hoja := decodificar_hoja
  leer_nodo := decodificar_nodo

theorem nodo_decodificado_canonico (bs : List Octeto) (l r : Digest)
    (h : decodificarMerkle bs = some (.nodo l r)) : bs = codificarNodo l r := by
  cases bs with
  | nil => simp only [decodificarMerkle, reduceCtorEq] at h
  | cons tag bs =>
    simp only [decodificarMerkle] at h
    split_ifs at h with h0 h1 hl
    · cases hf : leerFp2 bs <;>
        simp only [hf, Option.map_none, Option.map_some, Option.some.injEq, reduceCtorEq] at h
    · have he := Option.some.inj h
      cases he
      simp only [codificarNodo, List.take_append_drop, h1]

theorem hoja_decodificada_canonica (bs : List Octeto) (v : Fp2)
    (h : decodificarMerkle bs = some (.hoja v)) : bs = codificarHoja v := by
  cases bs with
  | nil => simp only [decodificarMerkle, reduceCtorEq] at h
  | cons tag bs =>
    simp only [decodificarMerkle] at h
    split_ifs at h with h0 h1 hl
    · cases hf : leerFp2 bs with
      | none => simp only [hf, Option.map_none, reduceCtorEq] at h
      | some w =>
        simp only [hf, Option.map_some, Option.some.injEq, Contenido.hoja.injEq] at h
        subst w
        rw [← bytes_de_fp2_leido bs v hf]
        exact congrArg (· :: bytesFp2 v) h0
    all_goals simp only [Option.some.injEq, reduceCtorEq] at h

theorem digest_cardinal : Fintype.card Digest = 2 ^ 256 := by
  let e : Digest ≃ (Fin 32 → Octeto) := Equiv.vectorEquivFin Octeto 32
  rw [Fintype.card_congr e]
  norm_num [Octeto, Fintype.card_fun]

end Nexus.Merkle
