module

public import Nexus.ROM.SelectorAcoplado
public import Nexus.ROM.SoporteFinito
public import Nexus.Canal.CintaSelector
import Mathlib.Tactic

/-!
# Acoplamiento para las entradas I del canal matemático TG2

El universo finito contiene todas las entradas de índice, además del pasado
observado. La codificación real es inyectiva. La cota conserva la hipótesis
de primera dirección fresca; no la deduce para candidatos elegidos después
de consultar el oráculo. R es un corte analítico, sin cambio de Rust.
-/

public section
namespace Nexus.Canal.SelectorAcoplado

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM FrescuraFinita

set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 1024
attribute [local instance] Classical.propDecidable

@[expose] noncomputable def universo (S : Finset Entrada) : Finset Entrada :=
  S ∪ Finset.univ.image (fun d : Digest => entradaReto d .indice)

theorem pasado_en_universo (S : Finset Entrada) : S ⊆ universo S := Finset.subset_union_left

theorem indices_en_universo (S : Finset Entrada) (d : Digest) : entradaReto d .indice ∈ universo S := by
  exact Finset.mem_union_right _ (Finset.mem_image.mpr ⟨d, Finset.mem_univ _, rfl⟩)

@[expose] def codificar (V : Finset Entrada) (hv : ∀ d, entradaReto d .indice ∈ V) (d : Digest) : V :=
  ⟨entradaReto d .indice, hv d⟩

theorem codificar_inyectiva (V : Finset Entrada) (hv : ∀ d, entradaReto d .indice ∈ V) :
    Function.Injective (codificar V hv) := by
  intro s t h
  exact (reto_inyectivo (congrArg (fun z : V => z.val) h)).1

theorem cinta_igual (V : Finset Entrada) (hv : ∀ d, entradaReto d .indice ∈ V)
    (defecto : Digest) (H : V → Digest) (R : ℕ) (s : Digest) :
    CadenaMemoria.cinta (codificar V hv) H R s = CintaSelector.cinta (SoporteFinito.prolongar V defecto H) R s := by
  induction R generalizing s with
  | zero => rfl
  | succ R ih =>
    simp only [CadenaMemoria.cinta, CintaSelector.cinta,
      SoporteFinito.prolongar_en_universo V defecto H _ (hv s), codificar, ih]

theorem error_digest (R m : ℕ) : AcoplamientoCadena.error Digest R m =
    min 1 (((R * (m + R + 1) : ℕ) : ℚ) / (2 ^ 256 : ℚ)) := by
  simp only [AcoplamientoCadena.error, ProyeccionDigest.cardinal_digest, Nat.cast_pow, Nat.cast_ofNat]

theorem diferencia_cinta (V : Finset Entrada) (hv : ∀ d, entradaReto d .indice ∈ V)
    (S : Finset V) (v : V → Digest) (R : ℕ) (s defecto : Digest) (hs : codificar V hv s ∉ S)
    (E : List Digest → Prop) [DecidablePred E] :
    |promedio (fun H : Completaciones S v => if E (CintaSelector.cinta (SoporteFinito.prolongar V defecto H.val) R s)
        then (1 : ℚ) else 0) - promedio (fun w : Fin R → Digest => if E (List.ofFn w) then 1 else 0)| ≤
      AcoplamientoCadena.error Digest R S.card := by
  have h := AcoplamientoCadena.diferencia_vector (codificar V hv) (codificar_inyectiva V hv) R s S v hs E
  simpa only [cinta_igual V hv defecto] using h

theorem programa_omision (H : Entrada → Digest) (e R : ℕ) (s : Digest)
    (GT GC : Finset (Fin (2 ^ e))) :
    ProgramaCompartido.resultado (RegistroPrograma.tabla H)
      (ProgramaTG2.seleccionar (2 ^ e) (by positivity) R s ∅
        (fun T => .terminar (decide (T ⊆ GT ∧ T ⊆ GC)))) = true ↔
      (ROM.SelectorAcoplado.salida e 40 (CintaSelector.cinta H R s)).card = 40 ∧
        ROM.SelectorAcoplado.salida e 40 (CintaSelector.cinta H R s) ⊆ GT ∧
        ROM.SelectorAcoplado.salida e 40 (CintaSelector.cinta H R s) ⊆ GC := by
  rw [CintaSelector.resultado_desde_cinta H (2 ^ e) (by positivity) R s ∅ (by simp)]
  change (if (ROM.SelectorAcoplado.salida e 40 (CintaSelector.cinta H R s)).card = 40 then
    decide (ROM.SelectorAcoplado.salida e 40 (CintaSelector.cinta H R s) ⊆ GT ∧
      ROM.SelectorAcoplado.salida e 40 (CintaSelector.cinta H R s) ⊆ GC) else false) = true ↔ _
  split_ifs with hc <;> simp only [hc, true_and, false_and, decide_eq_true_eq]

theorem omision_programa (V : Finset Entrada) (hv : ∀ d, entradaReto d .indice ∈ V)
    (S : Finset V) (v : V → Digest) (R : ℕ) (s defecto : Digest) (hs : codificar V hv s ∉ S)
    (e : ℕ) (he : e ≤ 64) (hqM : 40 ≤ 2 ^ e) (hR : 40 ≤ R) (GT GC : Finset (Fin (2 ^ e))) :
    promedio (fun H : Completaciones S v => if ProgramaCompartido.resultado
      (RegistroPrograma.tabla (SoporteFinito.prolongar V defecto H.val))
      (ProgramaTG2.seleccionar (2 ^ e) (by positivity) R s ∅
        (fun T => .terminar (decide (T ⊆ GT ∧ T ⊆ GC)))) = true then (1 : ℚ) else 0) ≤
      (Nat.choose (GT ∩ GC).card 40 : ℚ) / Nat.choose (2 ^ e) 40 + AcoplamientoCadena.error Digest R S.card := by
  simp_rw [programa_omision]
  have h := ROM.SelectorAcoplado.omision_compartida (codificar V hv) (codificar_inyectiva V hv)
    R s S v hs e 40 he hqM hR GT GC
  simpa only [cinta_igual V hv defecto] using h

theorem abandono_512 (V : Finset Entrada) (hv : ∀ d, entradaReto d .indice ∈ V)
    (S : Finset V) (v : V → Digest) (s defecto : Digest) (hs : codificar V hv s ∉ S)
    (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) :
    promedio (fun H : Completaciones S v => if
      (ROM.SelectorAcoplado.salida (k + 2) 40 (CintaSelector.cinta (SoporteFinito.prolongar V defecto H.val) 512 s)).card < 40
      then (1 : ℚ) else 0) < (1 : ℚ) / 2 ^ 300 + AcoplamientoCadena.error Digest 512 S.card := by
  have h := ROM.SelectorAcoplado.abandono_rom (codificar V hv) (codificar_inyectiva V hv)
    512 s S v hs (k + 2) 40 (by omega)
  have ht := Selector.selector_corte_512 k hk0 hk1
  have hp : 2 ^ (k + 2) = 4 * 2 ^ k := by rw [pow_add]; ring
  have ht' : Selector.probabilidadIncompleta (2 ^ (k + 2)) 512 40 < (1 : ℚ) / 2 ^ 300 := by
    simpa only [hp] using ht
  simp only [cinta_igual V hv defecto] at h
  linarith

theorem omision_o_abandono_512 (V : Finset Entrada) (hv : ∀ d, entradaReto d .indice ∈ V)
    (S : Finset V) (v : V → Digest) (s defecto : Digest) (hs : codificar V hv s ∉ S)
    (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) (GT GC : Finset (Fin (2 ^ (k + 2)))) :
    promedio (fun H : Completaciones S v => if
      (ROM.SelectorAcoplado.salida (k + 2) 40 (CintaSelector.cinta (SoporteFinito.prolongar V defecto H.val) 512 s)).card < 40 ∨
      ((ROM.SelectorAcoplado.salida (k + 2) 40 (CintaSelector.cinta (SoporteFinito.prolongar V defecto H.val) 512 s)).card = 40 ∧
        ROM.SelectorAcoplado.salida (k + 2) 40 (CintaSelector.cinta (SoporteFinito.prolongar V defecto H.val) 512 s) ⊆ GT ∩ GC)
      then (1 : ℚ) else 0) <
      (Nat.choose (GT ∩ GC).card 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 + (1 : ℚ) / 2 ^ 300 +
        AcoplamientoCadena.error Digest 512 S.card := by
  have hq : 40 ≤ 2 ^ (k + 2) := by
    have hp : 2 ^ 6 ≤ 2 ^ (k + 2) := Nat.pow_le_pow_right (by decide) (by omega)
    norm_num at hp
    omega
  have h := ROM.SelectorAcoplado.omision_o_abandono_rom (codificar V hv) (codificar_inyectiva V hv)
    512 s S v hs (k + 2) 40 (by omega) hq (by decide) (GT ∩ GC)
  have ht := Selector.selector_corte_512 k hk0 hk1
  have hp : 2 ^ (k + 2) = 4 * 2 ^ k := by rw [pow_add]; ring
  have ht' : Selector.probabilidadIncompleta (2 ^ (k + 2)) 512 40 < (1 : ℚ) / 2 ^ 300 := by
    simpa only [hp] using ht
  simp only [cinta_igual V hv defecto] at h
  linarith

end Nexus.Canal.SelectorAcoplado
