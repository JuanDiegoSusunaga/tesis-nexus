module

public import Nexus.Canal.VistaCausal
public import Nexus.FRI.Adaptativo
import Mathlib.Tactic

/-!
# Un único conjunto excepcional previo para todos los perfiles FRI

La unión cubre k=4,...,12 y ambas fases. La raíz se lee del pasado de la
consulta E; no se fija el perfil ni la ronda después de ver su respuesta.
La cardinal se suma por capas y telescopa en cada torre.
-/

public section
namespace Nexus.Verificador.UnionPerfilesFRI

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open VistaCausal
open scoped BigOperators

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] noncomputable def traza (k : ℕ) (hk : k ≤ 29) (defecto : Digest)
    (t : Tabla Entrada Digest) (a : Digest) (j : Fin k) : Finset Fp2 :=
  Nexus.FRI.excepciones (torreTraza k hk) (1 / 8) (by norm_num)
    dos_extension_no_cero (margen_torre_goldilocks k k hk (Nat.le_succ _)) j
    (oraculoPrevio k j.val defecto t a)

@[expose] noncomputable def composicion (k : ℕ) (hk : k ≤ 29) (defecto : Digest)
    (t : Tabla Entrada Digest) (a : Digest) (j : Fin (k + 1)) : Finset Fp2 :=
  Nexus.FRI.excepciones (torreComposicion k hk) (1 / 8) (by norm_num)
    dos_extension_no_cero (margen_torre_goldilocks k (k + 1) hk (le_refl _)) j
    (oraculoPrevio k j.val defecto t a)

@[expose] noncomputable def perfil (k : ℕ) (hk : k ≤ 29) (defecto : Digest)
    (t : Tabla Entrada Digest) (a : Digest) : Finset Fp2 :=
  (Finset.univ.biUnion (traza k hk defecto t a)) ∪
    Finset.univ.biUnion (composicion k hk defecto t a)

@[expose] noncomputable def todos (defecto : Digest) (t : Tabla Entrada Digest)
    (a : Digest) : Finset Fp2 :=
  Finset.univ.biUnion (fun k : Fin 9 => perfil (k.val + 4) (by omega) defecto t a)

theorem cardinal_perfil (k : ℕ) (hk : k ≤ 29) (defecto : Digest)
    (t : Tabla Entrada Digest) (a : Digest) :
    (perfil k hk defecto t a).card ≤ 16 * 2 ^ k - 12 := by
  have ht (j : Fin k) := Nexus.FRI.excepciones_cardinal (torreTraza k hk)
    (1 / 8) (by norm_num) dos_extension_no_cero
    (margen_torre_goldilocks k k hk (Nat.le_succ _)) j (oraculoPrevio k j.val defecto t a)
  have hc (j : Fin (k + 1)) := Nexus.FRI.excepciones_cardinal (torreComposicion k hk)
    (1 / 8) (by norm_num) dos_extension_no_cero
    (margen_torre_goldilocks k (k + 1) hk (le_refl _)) j (oraculoPrevio k j.val defecto t a)
  obtain ⟨htrace, hcomp⟩ := presupuestos_torres k hk (traza k hk defecto t a)
    (composicion k hk defecto t a) ht hc
  have hu := Finset.card_union_le
    (Finset.univ.biUnion (traza k hk defecto t a))
    (Finset.univ.biUnion (composicion k hk defecto t a))
  have htu := Finset.card_biUnion_le (s := Finset.univ) (t := traza k hk defecto t a)
  have hcu := Finset.card_biUnion_le (s := Finset.univ) (t := composicion k hk defecto t a)
  change (perfil k hk defecto t a).card ≤ _ at hu
  have hpow : 1 ≤ 2 ^ k := Nat.one_le_pow k 2 (by decide)
  omega

theorem cardinal_todos (defecto : Digest) (t : Tabla Entrada Digest) (a : Digest) :
    (todos defecto t a).card ≤ 130708 := by
  have h := Finset.card_biUnion_le (s := Finset.univ)
    (t := fun k : Fin 9 => perfil (k.val + 4) (by omega) defecto t a)
  calc
    _ ≤ ∑ k : Fin 9, (perfil (k.val + 4) (by omega) defecto t a).card := h
    _ ≤ ∑ k : Fin 9, (16 * 2 ^ (k.val + 4) - 12) :=
      Finset.sum_le_sum (fun k _ => cardinal_perfil _ _ defecto t a)
    _ = 130708 := by norm_num [Fin.sum_univ_succ]

theorem mem_traza (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) (defecto : Digest)
    (t : Tabla Entrada Digest) (a : Digest) (j : Fin k) (x : Fp2)
    (hx : x ∈ traza k (by omega) defecto t a j) : x ∈ todos defecto t a := by
  let i : Fin 9 := ⟨k - 4, by omega⟩
  have hi : i.val + 4 = k := by dsimp [i]; omega
  apply Finset.mem_biUnion.mpr
  refine ⟨i, Finset.mem_univ _, ?_⟩
  simp only [hi]
  exact Finset.mem_union_left _ (Finset.mem_biUnion.mpr ⟨j, Finset.mem_univ _, hx⟩)

theorem mem_composicion (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) (defecto : Digest)
    (t : Tabla Entrada Digest) (a : Digest) (j : Fin (k + 1)) (x : Fp2)
    (hx : x ∈ composicion k (by omega) defecto t a j) : x ∈ todos defecto t a := by
  let i : Fin 9 := ⟨k - 4, by omega⟩
  have hi : i.val + 4 = k := by dsimp [i]; omega
  apply Finset.mem_biUnion.mpr
  refine ⟨i, Finset.mem_univ _, ?_⟩
  simp only [hi]
  exact Finset.mem_union_right _ (Finset.mem_biUnion.mpr ⟨j, Finset.mem_univ _, hx⟩)

end Nexus.Verificador.UnionPerfilesFRI
