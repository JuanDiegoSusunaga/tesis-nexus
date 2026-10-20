module

public import Nexus.ROM.AcoplamientoCadena
public import Nexus.ROM.PalabrasDigest
import Mathlib.Tactic

/-!
# Omisión y abandono del selector tras un pasado fijo

La misma muestra se usa para los dos conjuntos buenos. La hipergeométrica
ideal se transfiere con error aditivo, sin afirmar que la cadena real sea
uniforme al condicionar a ausencia de repeticiones o a completar.
-/

public section
namespace Nexus.ROM.SelectorAcoplado

open Nexus.Bytes Nexus.Merkle Nexus.N06 FrescuraFinita Selector.Uniformidad

attribute [local instance] Classical.propDecidable
set_option maxHeartbeats 800000

@[expose] def salida (e q : ℕ) (ds : List Digest) : Finset (Fin (2 ^ e)) :=
  Selector.seleccionar q ∅ (ds.map (Nexus.Canal.ProgramaTG2.indice (2 ^ e) (by positivity)))

theorem salida_vector (e q R : ℕ) (w : Fin R → Digest) :
    salida e q (List.ofFn w) = Selector.Uniformidad.salida q R (PalabrasDigest.proyectar e R w) := by
  simp only [salida, Selector.Uniformidad.salida, List.map_ofFn]
  rfl

theorem completas_positivas (M q R : ℕ) (hM : 0 < M) (hqM : q ≤ M) (hqR : q ≤ R) :
    0 < Fintype.card (Completas (Fin M) q R) := by
  classical
  let w : Fin R → Fin M := fun i => ⟨i.val % M, Nat.mod_lt _ hM⟩
  let f : Fin q → Fin M := fun i => ⟨i.val, lt_of_lt_of_le i.isLt hqM⟩
  have hf : Function.Injective f := fun _ _ h => Fin.ext (congrArg (fun z : Fin M => z.val) h)
  have hsub : Finset.univ.image f ⊆ Finset.univ.image w := by
    intro x hx
    obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hx
    refine Finset.mem_image.mpr ⟨⟨i.val, lt_of_lt_of_le i.isLt hqR⟩, Finset.mem_univ _, ?_⟩
    exact Fin.ext (Nat.mod_eq_of_lt (lt_of_lt_of_le i.isLt hqM))
  have hc : q ≤ (Finset.univ.image w).card := by
    simpa only [Finset.card_image_of_injective _ hf, Finset.card_univ, Fintype.card_fin] using
      Finset.card_le_card hsub
  apply Fintype.card_pos_iff.mpr
  refine ⟨⟨w, ?_⟩⟩
  exact (Selector.vacio_completa_iff q (List.ofFn w)).mpr (by
    simpa only [Selector.conjunto_ofFn] using hc)

theorem ideal_omision (e q R : ℕ) (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R)
    (G : Finset (Fin (2 ^ e))) :
    promedio (fun w : Fin R → Digest => if (salida e q (List.ofFn w)).card = q ∧
      salida e q (List.ofFn w) ⊆ G then (1 : ℚ) else 0) ≤
      (Nat.choose G.card q : ℚ) / Nat.choose (2 ^ e) q := by
  simp_rw [salida_vector]
  apply ComparacionAcoplada.cota_desde_condicional _
    (fun w : Fin R → Digest => (Selector.Uniformidad.salida q R (PalabrasDigest.proyectar e R w)).card = q)
    (fun _ h => h.1) _ (by positivity)
  exact PalabrasDigest.selector_hipergeometrico e q R he G (completas_positivas _ _ _ (by positivity) hqM hqR)

theorem ideal_abandono (e q R : ℕ) (he : e ≤ 64) :
    promedio (fun w : Fin R → Digest => if (salida e q (List.ofFn w)).card < q then (1 : ℚ) else 0) =
      Selector.probabilidadIncompleta (2 ^ e) R q := by
  simp_rw [salida_vector]
  rw [PalabrasDigest.promedio_palabras e R he
    (fun v => if (Selector.Uniformidad.salida q R v).card < q then (1 : ℚ) else 0)]
  rw [ComparacionAcoplada.promedio_evento]
  simp only [Selector.probabilidadIncompleta, Selector.Uniformidad.salida, Fintype.card_fun,
    Fintype.card_fin, Nat.cast_pow]
  simp only [← Nat.card_eq_fintype_card]
  apply congrArg₂ (fun x y : ℚ => x / y)
  · exact congrArg (fun n : ℕ => (n : ℚ)) Nat.card_eq_fintype_card.symm
  · rfl

theorem ideal_con_abandono (e q R : ℕ) (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R)
    (G : Finset (Fin (2 ^ e))) :
    promedio (fun w : Fin R → Digest => if (salida e q (List.ofFn w)).card < q ∨
      ((salida e q (List.ofFn w)).card = q ∧ salida e q (List.ofFn w) ⊆ G) then (1 : ℚ) else 0) ≤
      (Nat.choose G.card q : ℚ) / Nat.choose (2 ^ e) q + Selector.probabilidadIncompleta (2 ^ e) R q := by
  have hp := ComparacionAcoplada.union_eventos
    (fun w : Fin R → Digest => (salida e q (List.ofFn w)).card < q)
    (fun w : Fin R → Digest => (salida e q (List.ofFn w)).card = q ∧ salida e q (List.ofFn w) ⊆ G)
  rw [ideal_abandono e q R he] at hp
  have hu := ideal_omision e q R he hqM hqR G
  linarith

variable {Q : Type} [DecidableEq Q] [Fintype Q]

theorem omision_rom (codificar : Digest → Q) (hi : Function.Injective codificar)
    (R : ℕ) (s : Digest) (S : Finset Q) (v : Q → Digest) (hs : codificar s ∉ S)
    (e q : ℕ) (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R) (G : Finset (Fin (2 ^ e))) :
    promedio (fun H : Completaciones S v => if (salida e q (CadenaMemoria.cinta codificar H.val R s)).card = q ∧
      salida e q (CadenaMemoria.cinta codificar H.val R s) ⊆ G then (1 : ℚ) else 0) ≤
      (Nat.choose G.card q : ℚ) / Nat.choose (2 ^ e) q + AcoplamientoCadena.error Digest R S.card := by
  have h := AcoplamientoCadena.diferencia_vector codificar hi R s S v hs
    (fun ds => (salida e q ds).card = q ∧ salida e q ds ⊆ G)
  have hu := ideal_omision e q R he hqM hqR G
  linarith [(abs_le.mp h).2]

theorem abandono_rom (codificar : Digest → Q) (hi : Function.Injective codificar)
    (R : ℕ) (s : Digest) (S : Finset Q) (v : Q → Digest) (hs : codificar s ∉ S)
    (e q : ℕ) (he : e ≤ 64) :
    promedio (fun H : Completaciones S v => if (salida e q (CadenaMemoria.cinta codificar H.val R s)).card < q
      then (1 : ℚ) else 0) ≤ Selector.probabilidadIncompleta (2 ^ e) R q + AcoplamientoCadena.error Digest R S.card := by
  have h := AcoplamientoCadena.diferencia_vector codificar hi R s S v hs (fun ds => (salida e q ds).card < q)
  rw [ideal_abandono e q R he] at h
  linarith [(abs_le.mp h).2]

theorem omision_compartida (codificar : Digest → Q) (hi : Function.Injective codificar)
    (R : ℕ) (s : Digest) (S : Finset Q) (v : Q → Digest) (hs : codificar s ∉ S)
    (e q : ℕ) (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R) (GT GC : Finset (Fin (2 ^ e))) :
    promedio (fun H : Completaciones S v => if (salida e q (CadenaMemoria.cinta codificar H.val R s)).card = q ∧
      salida e q (CadenaMemoria.cinta codificar H.val R s) ⊆ GT ∧
      salida e q (CadenaMemoria.cinta codificar H.val R s) ⊆ GC then (1 : ℚ) else 0) ≤
      (Nat.choose (GT ∩ GC).card q : ℚ) / Nat.choose (2 ^ e) q + AcoplamientoCadena.error Digest R S.card := by
  have h := omision_rom codificar hi R s S v hs e q he hqM hqR (GT ∩ GC)
  simpa only [Finset.subset_inter_iff, and_assoc] using h

theorem omision_o_abandono_rom (codificar : Digest → Q) (hi : Function.Injective codificar)
    (R : ℕ) (s : Digest) (S : Finset Q) (v : Q → Digest) (hs : codificar s ∉ S)
    (e q : ℕ) (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R) (G : Finset (Fin (2 ^ e))) :
    promedio (fun H : Completaciones S v => if (salida e q (CadenaMemoria.cinta codificar H.val R s)).card < q ∨
      ((salida e q (CadenaMemoria.cinta codificar H.val R s)).card = q ∧
        salida e q (CadenaMemoria.cinta codificar H.val R s) ⊆ G) then (1 : ℚ) else 0) ≤
      (Nat.choose G.card q : ℚ) / Nat.choose (2 ^ e) q + Selector.probabilidadIncompleta (2 ^ e) R q +
        AcoplamientoCadena.error Digest R S.card := by
  have h := AcoplamientoCadena.diferencia_vector codificar hi R s S v hs
    (fun ds => (salida e q ds).card < q ∨ ((salida e q ds).card = q ∧ salida e q ds ⊆ G))
  have hu := ideal_con_abandono e q R he hqM hqR G
  linarith [(abs_le.mp h).2]

end Nexus.ROM.SelectorAcoplado
