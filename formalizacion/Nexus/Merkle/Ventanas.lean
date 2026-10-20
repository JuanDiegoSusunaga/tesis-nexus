module

public import Nexus.Merkle.Codificacion
import Mathlib.Tactic

/-!
# Ventanas de 32 octetos de entradas de hasta 79 octetos

Se incluyen todas las posiciones contiguas y también las entradas ajenas al
formato Merkle. Las entradas largas no aportan ventanas. Los hijos de todo
nodo canónico están cubiertos en las posiciones 1 y 33.
-/

public section
namespace Nexus.Merkle

open Nexus.Bytes Nexus.Goldilocks

@[expose] def ventanasList (bs : List Octeto) : Finset (List Octeto) :=
  if bs.length ≤ 79 then
    (Finset.range (bs.length + 1 - 32)).image (fun i => (bs.drop i).take 32)
  else ∅

@[expose] def ventanas (bs : List Octeto) : Finset Digest :=
  (ventanasList bs).subtype (fun ds : List Octeto => ds.length = 32)

/-- Entrada de absorción de una raíz: estado, etiqueta, longitud u64 LE y digest. -/
@[expose] def absorberRaiz (estado : Digest) (tag : Octeto) (raiz : Digest) : List Octeto :=
  estado.val ++ (tag :: (codificarLE 8 32 ++ raiz.val))

theorem absorcion_raiz_longitud (estado : Digest) (tag : Octeto) (raiz : Digest) :
    (absorberRaiz estado tag raiz).length = 73 := by
  simp only [absorberRaiz, List.length_append, List.length_cons, codificar_le_longitud,
    estado.property, raiz.property]

theorem ventanas_largas (bs : List Octeto) (hl : 79 < bs.length) : ventanas bs = ∅ := by
  simp [ventanas, ventanasList, Nat.not_le.mpr hl, Finset.subtype]

theorem ventanas_card (bs : List Octeto) : (ventanas bs).card ≤ 48 := by
  have hf : (ventanas bs).card ≤ (ventanasList bs).card := by
    simp only [ventanas, Finset.subtype, Finset.card_map, Finset.card_attach]
    exact Finset.card_filter_le _ _
  apply hf.trans
  unfold ventanasList
  split_ifs with h
  · have hi := Finset.card_image_le (s := Finset.range (bs.length + 1 - 32))
      (f := fun i => (bs.drop i).take 32)
    rw [Finset.card_range] at hi
    omega
  · simp only [Finset.card_empty]; omega

theorem ventana_por_posicion (bs : List Octeto) (i : ℕ) (hi : i + 32 ≤ bs.length)
    (hs : bs.length ≤ 79) (d : Digest) (hd : (bs.drop i).take 32 = d.val) : d ∈ ventanas bs := by
  rw [ventanas, Finset.mem_subtype]
  simp only [ventanasList, hs, ite_true]
  exact Finset.mem_image.mpr ⟨i, Finset.mem_range.mpr (by omega), hd⟩

theorem hijos_nodo_en_ventanas (l r : Digest) :
    l ∈ ventanas (codificarNodo l r) ∧ r ∈ ventanas (codificarNodo l r) := by
  have hs : (codificarNodo l r).length ≤ 79 := by rw [nodo_codificado_longitud]; omega
  constructor
  · apply ventana_por_posicion (codificarNodo l r) 1 (by rw [nodo_codificado_longitud]; omega) hs l
    change (l.val ++ r.val).take 32 = l.val
    exact List.take_left' l.property
  · apply ventana_por_posicion (codificarNodo l r) 33 (by rw [nodo_codificado_longitud]) hs r
    change ((l.val ++ r.val).drop 32).take 32 = r.val
    rw [List.drop_left' l.property]
    have ht : r.val.take r.val.length = r.val := List.take_length
    simpa only [r.property] using ht

theorem hijos_decodificados_en_ventanas (bs : List Octeto) (l r : Digest)
    (h : decodificarMerkle bs = some (.nodo l r)) : l ∈ ventanas bs ∧ r ∈ ventanas bs := by
  rw [nodo_decodificado_canonico bs l r h]
  exact hijos_nodo_en_ventanas l r

theorem raiz_absorbida_en_ventanas (estado : Digest) (tag : Octeto) (raiz : Digest) :
    raiz ∈ ventanas (absorberRaiz estado tag raiz) := by
  apply ventana_por_posicion (absorberRaiz estado tag raiz) 41
    (by rw [absorcion_raiz_longitud]) (by rw [absorcion_raiz_longitud]; omega) raiz
  let prefijo := estado.val ++ (tag :: codificarLE 8 32)
  have hp : prefijo.length = 41 := by
    simp only [prefijo, List.length_append, List.length_cons, codificar_le_longitud, estado.property]
  have he : absorberRaiz estado tag raiz = prefijo ++ raiz.val := by
    simp only [absorberRaiz, prefijo, List.append_assoc, List.cons_append]
  rw [he, List.drop_left' hp]
  have ht : raiz.val.take raiz.val.length = raiz.val := List.take_length
  simpa only [raiz.property] using ht

end Nexus.Merkle
