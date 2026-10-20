module

public import Nexus.Merkle.Ventanas
import Mathlib.Tactic

/-!
# Entradas del canal: absorción, retos y trabajo

Se modelan las fórmulas de listas de octetos de channel.rs. Las etiquetas
de reto son F, E e I. El nonce tiene rango u64; leer la longitud de una
absorción exige el rango u64 correspondiente. No se supone disjunción global
con Merkle: se construye un solapamiento de 65 octetos explícito.
-/

public section
namespace Nexus.Canal

open Nexus.Bytes Nexus.Merkle

inductive TipoReto where
  | base
  | extension
  | indice
  deriving DecidableEq

@[expose] def etiquetaReto : TipoReto → Octeto
  | .base => 70
  | .extension => 69
  | .indice => 73

abbrev Nonce := Fin (2 ^ 64)

@[expose] def cabecera (estado : Digest) (tag : Octeto) : List Octeto := estado.val ++ [tag]

@[expose] def entradaAbsorcion (estado : Digest) (tag : Octeto) (datos : List Octeto) : List Octeto :=
  (cabecera estado tag ++ codificarLE 8 datos.length) ++ datos

@[expose] def entradaReto (estado : Digest) (tipo : TipoReto) : List Octeto :=
  cabecera estado (etiquetaReto tipo)

@[expose] def entradaTrabajo (estado : Digest) (nonce : Nonce) : List Octeto :=
  cabecera estado 5 ++ codificarLE 8 nonce.val

theorem cabecera_longitud (estado : Digest) (tag : Octeto) : (cabecera estado tag).length = 33 := by
  simp only [cabecera, List.length_append, estado.property, List.length_cons, List.length_nil]

theorem cabecera_inyectiva {s t : Digest} {a b : Octeto} (h : cabecera s a = cabecera t b) :
    s = t ∧ a = b := by
  have hs : s.val = t.val := by
    have he := congrArg (fun bs => bs.take 32) h
    simpa only [cabecera, List.take_left' s.property, List.take_left' t.property] using he
  have hst : s = t := Subtype.ext hs
  subst t
  have he : [a] = [b] := List.append_cancel_left h
  exact ⟨rfl, (List.cons.inj he).1⟩

theorem absorcion_longitud (estado : Digest) (tag : Octeto) (datos : List Octeto) :
    (entradaAbsorcion estado tag datos).length = 41 + datos.length := by
  simp only [entradaAbsorcion, List.length_append, cabecera_longitud, codificar_le_longitud]

theorem absorcion_cabecera (estado : Digest) (tag : Octeto) (datos : List Octeto) :
    (entradaAbsorcion estado tag datos).take 33 = cabecera estado tag := by
  simp only [entradaAbsorcion, List.append_assoc]
  exact List.take_left' (cabecera_longitud estado tag)

theorem absorcion_datos (estado : Digest) (tag : Octeto) (datos : List Octeto) :
    (entradaAbsorcion estado tag datos).drop 41 = datos := by
  apply List.drop_left'
  simp only [List.length_append, cabecera_longitud, codificar_le_longitud]

theorem absorcion_longitud_codificada (estado : Digest) (tag : Octeto) (datos : List Octeto) :
    ((entradaAbsorcion estado tag datos).drop 33).take 8 = codificarLE 8 datos.length := by
  have hd : (entradaAbsorcion estado tag datos).drop 33 = codificarLE 8 datos.length ++ datos := by
    simp only [entradaAbsorcion, List.append_assoc]
    exact List.drop_left' (cabecera_longitud estado tag)
  rw [hd]
  exact List.take_left' (codificar_le_longitud 8 datos.length)

theorem absorcion_longitud_leida (estado : Digest) (tag : Octeto) (datos : List Octeto)
    (hd : datos.length < 2 ^ 64) :
    leerLE (((entradaAbsorcion estado tag datos).drop 33).take 8) = datos.length := by
  rw [absorcion_longitud_codificada]
  exact leer_le_codificar 8 datos.length (by norm_num at hd ⊢; exact hd)

theorem absorcion_inyectiva {s t : Digest} {a b : Octeto} {x y : List Octeto}
    (h : entradaAbsorcion s a x = entradaAbsorcion t b y) : s = t ∧ a = b ∧ x = y := by
  have hc := congrArg (fun bs => bs.take 33) h
  simp only [absorcion_cabecera] at hc
  have hdatos := congrArg (fun bs => bs.drop 41) h
  simp only [absorcion_datos] at hdatos
  exact ⟨(cabecera_inyectiva hc).1, (cabecera_inyectiva hc).2, hdatos⟩

theorem absorcion_raiz_coincide (estado : Digest) (tag : Octeto) (raiz : Digest) :
    entradaAbsorcion estado tag raiz.val = absorberRaiz estado tag raiz := by
  simp only [entradaAbsorcion, cabecera, raiz.property, absorberRaiz, List.append_assoc,
    List.cons_append, List.nil_append]

theorem etiqueta_reto_inyectiva {a b : TipoReto} (h : etiquetaReto a = etiquetaReto b) : a = b := by
  cases a <;> cases b <;> simp_all [etiquetaReto, Fin.ext_iff]

theorem reto_longitud (estado : Digest) (tipo : TipoReto) : (entradaReto estado tipo).length = 33 :=
  cabecera_longitud estado (etiquetaReto tipo)

theorem reto_inyectivo {s t : Digest} {a b : TipoReto} (h : entradaReto s a = entradaReto t b) :
    s = t ∧ a = b := by
  have he := cabecera_inyectiva h
  exact ⟨he.1, etiqueta_reto_inyectiva he.2⟩

theorem trabajo_longitud (estado : Digest) (nonce : Nonce) : (entradaTrabajo estado nonce).length = 41 := by
  simp only [entradaTrabajo, List.length_append, cabecera_longitud, codificar_le_longitud]

theorem trabajo_inyectivo {s t : Digest} {a b : Nonce} (h : entradaTrabajo s a = entradaTrabajo t b) :
    s = t ∧ a = b := by
  have hc := congrArg (fun bs => bs.take 33) h
  have hd := congrArg (fun bs => bs.drop 33) h
  simp only [entradaTrabajo, List.take_left' (cabecera_longitud s 5),
    List.take_left' (cabecera_longitud t 5)] at hc
  simp only [entradaTrabajo, List.drop_left' (cabecera_longitud s 5),
    List.drop_left' (cabecera_longitud t 5)] at hd
  have ha : a.val < 256 ^ 8 := by have he := a.isLt; norm_num at he ⊢; exact he
  have hb : b.val < 256 ^ 8 := by have he := b.isLt; norm_num at he ⊢; exact he
  exact ⟨(cabecera_inyectiva hc).1, Fin.ext (codificar_le_inyectiva 8 ha hb hd)⟩

theorem reto_no_absorcion (s t : Digest) (tipo : TipoReto) (tag : Octeto) (datos : List Octeto) :
    entradaReto s tipo ≠ entradaAbsorcion t tag datos := by
  intro he
  have hl := congrArg List.length he
  rw [reto_longitud, absorcion_longitud] at hl
  omega

theorem trabajo_no_reto (s t : Digest) (nonce : Nonce) (tipo : TipoReto) :
    entradaTrabajo s nonce ≠ entradaReto t tipo := by
  intro he
  have hl := congrArg List.length he
  rw [trabajo_longitud, reto_longitud] at hl
  omega

theorem absorcion_nodo_solapados : ∃ s l r : Digest,
    entradaAbsorcion s 4 (List.replicate 24 0) = codificarNodo l r := by
  let s : Digest := ⟨1 :: List.replicate 31 0, by simp⟩
  let l : Digest := ⟨List.replicate 31 0 ++ [4], by simp⟩
  let r : Digest := ⟨codificarLE 8 24 ++ List.replicate 24 0, by simp [codificar_le_longitud]⟩
  refine ⟨s, l, r, ?_⟩
  simp only [entradaAbsorcion, cabecera, codificarNodo, s, l, r, List.length_replicate,
    List.cons_append, List.append_assoc]

end Nexus.Canal
