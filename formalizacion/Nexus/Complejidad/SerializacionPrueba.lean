module

public import Nexus.FRI.Recorrido
public import Nexus.Complejidad.Comunicacion
import Mathlib.Tactic

/-!
# Cuenta de bytes desde las listas de campos del formato declarado

Se usa una cabecera u64 por vector y ancho fijo por entero. El certificado
incluye el enunciado de 24 bytes; la prueba sola tiene 102 bytes fijos.
No se da por probada una equivalencia automática de serde/bincode.
-/

public section
namespace Nexus.Complejidad.Serializacion

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.Goldilocks.Recorrido
open scoped BigOperators

@[expose] def vector {A : Type*} (codifica : A → List Octeto) (xs : List A) : List Octeto :=
  codificarLE 8 xs.length ++ xs.flatMap codifica

theorem longitud_vector {A : Type*} (f : A → List Octeto) (xs : List A) :
    (vector f xs).length = 8 + (xs.map (fun x => (f x).length)).sum := by
  simp only [vector, List.length_append, codificar_le_longitud, List.length_flatMap]

theorem longitud_ancho_fijo {A : Type*} (f : A → List Octeto) (xs : List A) (ancho : ℕ)
    (h : ∀ x ∈ xs, (f x).length = ancho) : (vector f xs).length = 8 + xs.length * ancho := by
  rw [longitud_vector]
  congr 1
  induction xs with
  | nil => simp
  | cons x xs ih =>
    simp only [List.map_cons, List.sum_cons, List.length_cons, Nat.add_mul, Nat.one_mul]
    rw [h x List.mem_cons_self, ih (fun y hy => h y (List.mem_cons_of_mem x hy))]
    omega

@[expose] def camino (hermanos : List Digest) : List Octeto := vector Subtype.val hermanos

theorem longitud_camino (hermanos : List Digest) : (camino hermanos).length = 8 + 32 * hermanos.length := by
  simpa only [camino, Nat.mul_comm] using longitud_ancho_fijo Subtype.val hermanos 32 (fun d _ => d.property)

@[expose] def capa (d : Apertura) : List Octeto :=
  bytesFp2 d.izquierda ++ (bytesFp2 d.derecha ++ (camino d.pruebaIzquierda ++ camino d.pruebaDerecha))

theorem longitud_capa (d : Apertura) (h : ℕ) (hl : d.pruebaIzquierda.length = h)
    (hr : d.pruebaDerecha.length = h) : (capa d).length = 48 + 64 * h := by
  simp only [capa, List.length_append, bytes_fp2_longitud, longitud_camino, hl, hr]
  omega

@[expose] def serializarFri (ds : List Apertura) : List Octeto := vector capa ds

theorem longitud_fri (ds : List Apertura) (altura : ℕ)
    (h : ∀ (j : ℕ) (hj : j < ds.length), (ds[j]'hj).pruebaIzquierda.length = altura - j ∧
      (ds[j]'hj).pruebaDerecha.length = altura - j) :
    (serializarFri ds).length = 8 + 48 * ds.length +
      64 * Comunicacion.caminos altura ds.length := by
  rw [serializarFri, longitud_vector]
  have he : ds.map (fun d => (capa d).length) =
      List.ofFn (fun j : Fin ds.length => 48 + 64 * (altura - j.val)) := by
    apply List.ext_get
    · simp
    · intro j hj _hk
      have hj' : j < ds.length := by simpa only [List.length_map] using hj
      simp only [List.get_eq_getElem, List.getElem_map, List.getElem_ofFn]
      exact longitud_capa _ _ (h j hj').1 (h j hj').2
  rw [he, List.sum_ofFn]
  simp only [Finset.sum_add_distrib, Finset.sum_const, Finset.card_univ, Fintype.card_fin,
    nsmul_eq_mul, Nat.cast_id, ← Finset.mul_sum, Fin.sum_univ_eq_sum_range, Comunicacion.caminos]
  ring

theorem cabeceras_certificado : (24 + (2 + 4 + 32 + 2 * (8 + 16) + 8 + 8) : ℕ) = 126 := by norm_num

theorem cabecera_prueba_sola : (2 + 4 + 32 + 2 * (8 + 16) + 8 + 8 : ℕ) = 102 := by norm_num

theorem separar_enunciado (q k : ℕ) : Comunicacion.bytesTG2 q k =
    24 + (102 + 32 * (k + (k + 1)) + q * Comunicacion.consultaTG2 k) := by
  unfold Comunicacion.bytesTG2
  omega

end Nexus.Complejidad.Serializacion
