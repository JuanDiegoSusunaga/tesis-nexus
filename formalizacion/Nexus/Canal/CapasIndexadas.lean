module

public import Nexus.Canal.VistaSemantica
import Mathlib.Tactic

/-!
# Recorrido de los vectores por su altura efectiva

La representación recursiva conserva el índice de capa al retirar la cabeza.
Se demuestra su igualdad con la lista zipIdx ya usada en la vista semántica.
-/

public section
namespace Nexus.Canal.CapasIndexadas

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM VistaSemantica

@[expose] def desde (t : Tabla Entrada Digest) (defecto : Digest) (altura : ℕ) :
    ℕ → List Digest → List (ℕ → Fp2)
  | _, [] => []
  | j, r :: rs => valor t defecto (altura - j) r :: desde t defecto altura (j + 1) rs

theorem desde_mapIdx (t : Tabla Entrada Digest) (defecto : Digest) (altura j : ℕ) (rs : List Digest) :
    desde t defecto altura j rs = rs.mapIdx (fun i r => valor t defecto (altura - (j + i)) r) := by
  induction rs generalizing j with
  | nil => rfl
  | cons r rs ih =>
    rw [desde, List.mapIdx_cons, ih]
    simp only [Nat.add_zero]
    congr 1
    apply congrArg (fun f => rs.mapIdx f)
    funext i r
    have h : j + 1 + i = j + (i + 1) := by omega
    rw [h]

theorem capas_desde (t : Tabla Entrada Digest) (defecto : Digest) (altura : ℕ) (rs : List Digest) :
    capas t defecto altura rs = desde t defecto altura 0 rs := by
  rw [desde_mapIdx, List.mapIdx_eq_zipIdx_map]
  simp only [capas, Nat.zero_add]

theorem longitud_desde (t : Tabla Entrada Digest) (defecto : Digest) (altura j : ℕ) (rs : List Digest) :
    (desde t defecto altura j rs).length = rs.length := by
  rw [desde_mapIdx, List.length_mapIdx]

theorem longitud_capas (t : Tabla Entrada Digest) (defecto : Digest) (altura : ℕ) (rs : List Digest) :
    (capas t defecto altura rs).length = rs.length := by rw [capas_desde, longitud_desde]

end Nexus.Canal.CapasIndexadas
