module

public import Nexus.Merkle.Codificacion
public import Nexus.Complejidad.SerializacionPrueba
import Mathlib.Tactic

/-!
# Lectores de octetos con resto explícito

Los prefijos fijos, enteros LE y coordenadas canónicas rechazan truncamientos.
Los vectores comprueban su longitud esperada antes de recorrer elementos.
Es un lector del esquema admitido, con cuotas explícitas; no reproduce las
asignaciones de memoria ni todas las opciones de serde/bincode.
-/

public section
namespace Nexus.Bytes.Lectura

open Nexus.Goldilocks Nexus.Merkle

abbrev Lector (A : Type*) := List Octeto → Option (A × List Octeto)

@[expose] def puro {A : Type*} (a : A) : Lector A := fun bs => some (a, bs)

@[expose] def unir {A B : Type*} (p : Lector A) (f : A → Lector B) : Lector B := fun bs =>
  (p bs).bind (fun par => f par.1 par.2)

@[expose] def tomar (n : ℕ) : Lector (List Octeto) := fun bs =>
  if n ≤ bs.length then some (bs.take n, bs.drop n) else none

@[expose] def entero (n : ℕ) : Lector ℕ := unir (tomar n) (fun bs => puro (leerLE bs))

@[expose] def digest : Lector Digest := fun bs =>
  if h : 32 ≤ bs.length then some (⟨bs.take 32, by simp only [List.length_take, Nat.min_eq_left h]⟩, bs.drop 32)
  else none

@[expose] def campo : Lector Fp := unir (entero 8) (fun x =>
  if x < p then puro (x : Fp) else fun _ => none)

@[expose] def extension : Lector Fp2 := unir campo (fun a => unir campo (fun b => puro ⟨a, b⟩))

@[expose] def repetir {A : Type*} (p : Lector A) : ℕ → Lector (List A)
  | 0 => puro []
  | n + 1 => unir p (fun a => unir (repetir p n) (fun xs => puro (a :: xs)))

@[expose] def vector {A : Type*} (n : ℕ) (p : Lector A) : Lector (List A) :=
  unir (entero 8) (fun m => if m = n then repetir p n else fun _ => none)

@[expose] def vectorLibre {A : Type*} (p : Lector A) : Lector (List A) :=
  unir (entero 8) (fun n => repetir p n)

@[expose] def exacto {A : Type*} (p : Lector A) (bs : List Octeto) : Option A :=
  (p bs).bind (fun par => if par.2 = [] then some par.1 else none)

theorem unir_lectura {A B : Type*} (p : Lector A) (f : A → Lector B)
    (bs resto : List Octeto) (a : A) (h : p bs = some (a, resto)) :
    unir p f bs = f a resto := by simp only [unir, h, Option.bind_some]

theorem unir_rechazo {A B : Type*} (p : Lector A) (f : A → Lector B)
    (bs : List Octeto) (h : p bs = none) : unir p f bs = none := by
  simp only [unir, h, Option.bind_none]

theorem tomar_codificado (n : ℕ) (bs resto : List Octeto) (h : bs.length = n) :
    tomar n (bs ++ resto) = some (bs, resto) := by
  have hn : n ≤ (bs ++ resto).length := by simp only [List.length_append, h]; omega
  simp only [tomar, hn, ite_true, List.take_left' h, List.drop_left' h]

theorem truncamiento_rechazado (n : ℕ) (bs : List Octeto) (h : bs.length < n) : tomar n bs = none := by
  simp only [tomar, show ¬n ≤ bs.length by omega, ite_false]

theorem entero_codificado (n x : ℕ) (hx : x < 256 ^ n) (resto : List Octeto) :
    entero n (codificarLE n x ++ resto) = some (x, resto) := by
  rw [entero, unir_lectura _ _ _ _ _ (tomar_codificado _ _ _ (codificar_le_longitud _ _))]
  simp only [puro, leer_le_codificar n x hx]

theorem digest_codificado (d : Digest) (resto : List Octeto) : digest (d.val ++ resto) = some (d, resto) := by
  have h : 32 ≤ (d.val ++ resto).length := by simp only [List.length_append, d.property]; omega
  simp only [digest, h, dite_true, List.take_left' d.property, List.drop_left' d.property]

theorem campo_codificado (a : Fp) (resto : List Octeto) :
    campo (codificarLE 8 a.val ++ resto) = some (a, resto) := by
  rw [campo, unir_lectura _ _ _ _ _ (entero_codificado _ _ (a.val_lt.trans (by norm_num [p])) _)]
  simp only [a.val_lt, ite_true, puro, ZMod.natCast_zmod_val]

theorem campo_no_canonico (x : ℕ) (hx : x < 256 ^ 8) (hp : p ≤ x) (resto : List Octeto) :
    campo (codificarLE 8 x ++ resto) = none := by
  rw [campo, unir_lectura _ _ _ _ _ (entero_codificado _ _ hx _)]
  simp only [show ¬x < p by omega, ite_false]

theorem extension_codificada (v : Fp2) (resto : List Octeto) :
    extension (bytesFp2 v ++ resto) = some (v, resto) := by
  simp only [bytesFp2, List.append_assoc, extension]
  rw [unir_lectura _ _ _ _ _ (campo_codificado _ _), unir_lectura _ _ _ _ _ (campo_codificado _ _)]
  rfl

theorem repetir_codificado {A : Type*} (p : Lector A) (codifica : A → List Octeto)
    (hc : ∀ a resto, p (codifica a ++ resto) = some (a, resto)) (xs : List A) (resto : List Octeto) :
    repetir p xs.length (xs.flatMap codifica ++ resto) = some (xs, resto) := by
  induction xs generalizing resto with
  | nil => rfl
  | cons a xs ih =>
    simp only [List.length_cons, repetir, List.flatMap_cons, List.append_assoc]
    rw [unir_lectura _ _ _ _ _ (hc a _), unir_lectura _ _ _ _ _ (ih resto)]
    rfl

theorem vector_codificado {A : Type*} (p : Lector A) (codifica : A → List Octeto)
    (hc : ∀ a resto, p (codifica a ++ resto) = some (a, resto)) (xs : List A)
    (hx : xs.length < 256 ^ 8) (resto : List Octeto) :
    vector xs.length p (Nexus.Complejidad.Serializacion.vector codifica xs ++ resto) = some (xs, resto) := by
  simp only [Nexus.Complejidad.Serializacion.vector, List.append_assoc, vector]
  rw [unir_lectura _ _ _ _ _ (entero_codificado _ _ hx _)]
  simp only [ite_true]
  exact repetir_codificado p codifica hc xs resto

theorem vector_longitud_incorrecta {A : Type*} (n m : ℕ) (p : Lector A)
    (hm : m < 256 ^ 8) (hne : m ≠ n) (resto : List Octeto) :
    vector n p (codificarLE 8 m ++ resto) = none := by
  rw [vector, unir_lectura _ _ _ _ _ (entero_codificado _ _ hm _)]
  simp only [hne, ite_false]

theorem vector_libre_codificado {A : Type*} (p : Lector A) (codifica : A → List Octeto)
    (hc : ∀ a resto, p (codifica a ++ resto) = some (a, resto)) (xs : List A)
    (hx : xs.length < 256 ^ 8) (resto : List Octeto) :
    vectorLibre p (Nexus.Complejidad.Serializacion.vector codifica xs ++ resto) = some (xs, resto) := by
  simp only [Nexus.Complejidad.Serializacion.vector, List.append_assoc, vectorLibre]
  rw [unir_lectura _ _ _ _ _ (entero_codificado _ _ hx _)]
  exact repetir_codificado p codifica hc xs resto

theorem lectura_exacta {A : Type*} (p : Lector A) (bs : List Octeto) (a : A)
    (h : p bs = some (a, [])) : exacto p bs = some a := by simp only [exacto, h, Option.bind_some, ite_true]

theorem resto_no_vacio_rechazado {A : Type*} (p : Lector A) (bs resto : List Octeto) (a : A)
    (h : p bs = some (a, resto)) (hr : resto ≠ []) : exacto p bs = none := by
  simp only [exacto, h, Option.bind_some, hr, ite_false]

end Nexus.Bytes.Lectura
