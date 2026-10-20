module

public import Nexus.Bytes.Lectura
import Mathlib.Tactic

/-!
# Codecs compuestos con dominio de codificación explícito

Cada codec prueba la lectura de su codificación seguida de cualquier sufijo.
El dominio expresa los límites de ancho, sin confundirlos con la validez
criptográfica del certificado. Los vectores incluyen cabecera u64 y todos
sus elementos. La corrección no presupone equivalencia con serde/bincode.
-/

public section
namespace Nexus.Bytes.Codecs

open Lectura Nexus.Goldilocks Nexus.Merkle

structure Codec (A : Type*) where
  codificar : A → List Octeto
  leer : Lector A
  dominio : A → Prop
  ida_vuelta : ∀ a, dominio a → ∀ resto, leer (codificar a ++ resto) = some (a, resto)

@[expose] def entero (n : ℕ) : Codec ℕ where
  codificar := codificarLE n
  leer := Lectura.entero n
  dominio := fun x => x < 256 ^ n
  ida_vuelta := fun _ h _ => entero_codificado _ _ h _

@[expose] def campo : Codec Fp where
  codificar := fun a => codificarLE 8 a.val
  leer := Lectura.campo
  dominio := fun _ => True
  ida_vuelta := fun _ _ _ => campo_codificado _ _

@[expose] def extension : Codec Fp2 where
  codificar := bytesFp2
  leer := Lectura.extension
  dominio := fun _ => True
  ida_vuelta := fun _ _ _ => extension_codificada _ _

@[expose] def digest : Codec Digest where
  codificar := Subtype.val
  leer := Lectura.digest
  dominio := fun _ => True
  ida_vuelta := fun _ _ _ => digest_codificado _ _

@[expose] def par {A B : Type*} (c : Codec A) (d : Codec B) : Codec (A × B) where
  codificar := fun x => c.codificar x.1 ++ d.codificar x.2
  leer := unir c.leer (fun a => unir d.leer (fun b => puro (a, b)))
  dominio := fun x => c.dominio x.1 ∧ d.dominio x.2
  ida_vuelta := by
    intro x hx resto
    simp only [List.append_assoc]
    rw [unir_lectura _ _ _ _ _ (c.ida_vuelta x.1 hx.1 _),
      unir_lectura _ _ _ _ _ (d.ida_vuelta x.2 hx.2 _)]
    rfl

theorem repetir_en_dominio {A : Type*} (c : Codec A) (xs : List A)
    (hx : ∀ a ∈ xs, c.dominio a) (resto : List Octeto) :
    repetir c.leer xs.length (xs.flatMap c.codificar ++ resto) = some (xs, resto) := by
  induction xs generalizing resto with
  | nil => rfl
  | cons a xs ih =>
    simp only [List.length_cons, repetir, List.flatMap_cons, List.append_assoc]
    rw [unir_lectura _ _ _ _ _ (c.ida_vuelta a (hx a List.mem_cons_self) _),
      unir_lectura _ _ _ _ _ (ih (fun a ha => hx a (List.mem_cons_of_mem _ ha)) resto)]
    rfl

@[expose] def lista {A : Type*} (c : Codec A) : Codec (List A) where
  codificar := Nexus.Complejidad.Serializacion.vector c.codificar
  leer := vectorLibre c.leer
  dominio := fun xs => xs.length < 256 ^ 8 ∧ ∀ a ∈ xs, c.dominio a
  ida_vuelta := by
    intro xs hx resto
    simp only [Nexus.Complejidad.Serializacion.vector, List.append_assoc, vectorLibre]
    rw [unir_lectura _ _ _ _ _ (entero_codificado _ _ hx.1 _)]
    exact repetir_en_dominio c xs hx.2 resto

@[expose] def transportar {A B : Type*} (c : Codec A) (aB : A → B) (bA : B → A)
    (hab : ∀ b, aB (bA b) = b) : Codec B where
  codificar := fun b => c.codificar (bA b)
  leer := unir c.leer (fun a => puro (aB a))
  dominio := fun b => c.dominio (bA b)
  ida_vuelta := by
    intro b hb resto
    rw [unir_lectura _ _ _ _ _ (c.ida_vuelta (bA b) hb resto)]
    simp only [puro, hab]

theorem codificacion_inyectiva {A : Type*} (c : Codec A) (a b : A)
    (ha : c.dominio a) (hb : c.dominio b) (h : c.codificar a = c.codificar b) : a = b := by
  have ea := c.ida_vuelta a ha []
  have eb := c.ida_vuelta b hb []
  rw [h, eb] at ea
  exact (congrArg Prod.fst (Option.some.inj ea)).symm

theorem lectura_completa {A : Type*} (c : Codec A) (a : A) (ha : c.dominio a) :
    exacto c.leer (c.codificar a) = some a := by
  apply lectura_exacta
  simpa only [List.append_nil] using c.ida_vuelta a ha []

theorem sufijo_exacto_rechazado {A : Type*} (c : Codec A) (a : A) (ha : c.dominio a)
    (resto : List Octeto) (hr : resto ≠ []) : exacto c.leer (c.codificar a ++ resto) = none :=
  resto_no_vacio_rechazado _ _ _ a (c.ida_vuelta a ha resto) hr

end Nexus.Bytes.Codecs
