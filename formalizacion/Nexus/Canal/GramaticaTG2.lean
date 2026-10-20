module

public import Nexus.Canal.Entradas
import Mathlib.Tactic

/-!
# Gramática conjunta de las entradas hash de TG2 v1

Se incluyen el canal, trabajo y Merkle en un único alfabeto de bytes.
Las formas coinciden con begin, absorb_fri y el verificador experimental.
La gramática no supone tablas independientes por rol. La absorción de
enunciado y un nodo pueden coincidir: sus entradas miden 65 octetos.
Falta probar el refinamiento completo del control de flujo Rust.
-/

public section
namespace Nexus.Canal.GramaticaTG2

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks

abbrev Datos (n : ℕ) := {bs : List Octeto // bs.length = n}

theorem longitud_datos {n : ℕ} (bs : Datos n) : bs.val.length = n := bs.property

inductive Absorcion where
  | perfil (datos : Datos 38)
  | enunciado (datos : Datos 24)
  | raizTraza (raiz : Digest)
  | raizFRI (raiz : Digest)
  | faseTraza
  | faseComposicion
  | final (valor : Fp2)
  | nonce (valor : Nonce)

@[expose] def etiqueta : Absorcion → Octeto
  | .perfil _ => 16
  | .enunciado _ => 4
  | .raizTraza _ => 1
  | .raizFRI _ => 2
  | .faseTraza | .faseComposicion => 17
  | .final _ => 3
  | .nonce _ => 5

@[expose] def datos : Absorcion → List Octeto
  | .perfil bs | .enunciado bs => bs.val
  | .raizTraza r | .raizFRI r => r.val
  | .faseTraza => [116, 114, 97, 99, 101]
  | .faseComposicion => [99, 111, 109, 112, 111, 115, 105, 116, 105, 111, 110]
  | .final v => bytesFp2 v
  | .nonce v => codificarLE 8 v.val

@[expose] def entrada (s : Digest) (a : Absorcion) : List Octeto :=
  entradaAbsorcion s (etiqueta a) (datos a)

@[expose] def dominio : List Octeto :=
  [78, 69, 88, 85, 83, 45, 84, 71, 50, 45, 76, 73, 78, 75, 69, 68, 45, 70, 82, 73, 45, 118, 49]

inductive Peticion where
  | inicio
  | absorber (estado : Digest) (a : Absorcion)
  | extension (estado : Digest)
  | indice (estado : Digest)
  | trabajo (estado : Digest) (nonce : Nonce)
  | hoja (valor : Fp2)
  | nodo (izquierda derecha : Digest)

@[expose] def codificar : Peticion → List Octeto
  | .inicio => dominio
  | .absorber s a => entrada s a
  | .extension s => entradaReto s .extension
  | .indice s => entradaReto s .indice
  | .trabajo s n => entradaTrabajo s n
  | .hoja v => codificarHoja v
  | .nodo l r => codificarNodo l r

theorem longitudes_absorcion (s : Digest) (a : Absorcion) :
    (entrada s a).length ∈ ([46, 49, 52, 57, 65, 73, 79] : List ℕ) := by
  cases a <;> simp [entrada, absorcion_longitud, datos, bytes_fp2_longitud,
    codificar_le_longitud, longitud_datos]

theorem longitudes_gramatica (p : Peticion) :
    (codificar p).length ∈ ([17, 23, 33, 41, 46, 49, 52, 57, 65, 73, 79] : List ℕ) := by
  cases p with
  | absorber s a =>
    have h := longitudes_absorcion s a
    simp only [List.mem_cons] at h ⊢
    simpa only [codificar] using (Or.inr (Or.inr (Or.inr (Or.inr h))))
  | inicio => decide
  | extension s => simp [codificar, reto_longitud]
  | indice s => simp [codificar, reto_longitud]
  | trabajo s n => simp [codificar, trabajo_longitud]
  | hoja v => simp [codificar, hoja_codificada_longitud]
  | nodo l r => simp [codificar, nodo_codificado_longitud]

theorem longitud_enunciado (s : Digest) (bs : Datos 24) :
    (entrada s (.enunciado bs)).length = 65 := by
  simp [entrada, datos, absorcion_longitud, bs.property]

theorem longitud_perfil (s : Digest) (bs : Datos 38) :
    (entrada s (.perfil bs)).length = 79 := by
  simp [entrada, datos, absorcion_longitud, bs.property]

theorem longitud_nonce_absorbido (s : Digest) (n : Nonce) :
    (entrada s (.nonce n)).length = 49 := by
  simp [entrada, datos, absorcion_longitud, codificar_le_longitud]

/-- Dentro del canal, las formas de absorción determinan el rol y sus datos. -/
theorem absorcion_determina_datos {s t : Digest} {a b : Absorcion}
    (h : entrada s a = entrada t b) : s = t ∧ etiqueta a = etiqueta b ∧ datos a = datos b :=
  absorcion_inyectiva h

theorem reto_excluye_absorcion (s t : Digest) (r : TipoReto) (a : Absorcion) :
    entradaReto s r ≠ entrada t a := reto_no_absorcion s t r _ _

theorem trabajo_excluye_absorcion (s t : Digest) (n : Nonce) (a : Absorcion) :
    entradaTrabajo s n ≠ entrada t a := by
  intro h
  have hl := congrArg List.length h
  rw [trabajo_longitud] at hl
  have ha := longitudes_absorcion t a
  rw [← hl] at ha
  norm_num at ha

/-- El único rol de absorción que puede confundirse con un nodo es el enunciado. -/
theorem nodo_solo_solapa_enunciado (s : Digest) (a : Absorcion) (l r : Digest)
    (h : entrada s a = codificarNodo l r) : ∃ bs, a = .enunciado bs := by
  have hl := congrArg List.length h
  rw [nodo_codificado_longitud] at hl
  cases a with
  | enunciado bs => exact ⟨bs, rfl⟩
  | _ => simp [entrada, datos, absorcion_longitud, bytes_fp2_longitud,
      codificar_le_longitud, longitud_datos] at hl

/-- La gramática conjunta conserva el solapamiento real, en vez de asumir disjunción. -/
theorem solapamiento_conjunto : ∃ s l r : Digest, ∃ bs : Datos 24,
    codificar (.absorber s (.enunciado bs)) = codificar (.nodo l r) := by
  obtain ⟨s, l, r, h⟩ := absorcion_nodo_solapados
  exact ⟨s, l, r, ⟨List.replicate 24 0, by simp⟩, h⟩

theorem extension_indice_distintos (s t : Digest) :
    codificar (.extension s) ≠ codificar (.indice t) := by
  intro h
  have hf := (reto_inyectivo h).2
  cases hf

end Nexus.Canal.GramaticaTG2
