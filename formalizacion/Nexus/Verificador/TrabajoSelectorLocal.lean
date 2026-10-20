module

public import Nexus.Verificador.TrabajoDigest
public import Nexus.ROM.SelectorPrimeras
import Mathlib.Tactic

/-!
# Trabajo y selector sobre una misma tabla parcial

El trabajo y la absorción del nonce son dos direcciones distintas y frescas.
El resto conserva la tabla: no se vuelve a sortear una consulta repetida.
Se exige explícitamente que el primer índice no estuviera en el pasado.
Falta trasladar este corte local a todos los candidatos del programa real.
-/

public section
namespace Nexus.Verificador.TrabajoSelectorLocal

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM
open FrescuraFinita PromediosCompletaciones

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

variable {Q : Type} [Fintype Q] [DecidableEq Q]

@[expose] noncomputable def Omite (codigo : Digest → Q) (H : Q → Digest)
    (R e q : ℕ) (s : Digest) (G : Finset (Fin (2 ^ e))) : Prop :=
  let T := SelectorAcoplado.salida e q (CadenaMemoria.cinta codigo H R s)
  T.card < q ∨ (T.card = q ∧ T ⊆ G)

theorem cota_semilla (codigo : Digest → Q) (hi : Function.Injective codigo)
    (S : Finset Q) (v : Q → Digest) (qn : Q) (hn : qn ∉ S)
    (hc : ∀ d, codigo d ≠ qn) (R e q : ℕ)
    (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R) (G : Finset (Fin (2 ^ e))) :
    promedio (fun H : Completaciones S v =>
      if codigo (H.val qn) ∉ S ∧ Omite codigo H.val R e q (H.val qn) G then (1 : ℚ) else 0) ≤
      SelectorPrimeras.riesgo R e q G.card (S.card + 1) := by
  rw [media_revelar S v qn hn (fun H =>
    if codigo (H qn) ∉ S ∧ Omite codigo H R e q (H qn) G then (1 : ℚ) else 0)]
  apply (promedio_monotono _ (fun _ => SelectorPrimeras.riesgo R e q G.card (S.card + 1)) ?_).trans_eq
    (promedio_constante _)
  intro d
  have heq : (fun H : Completaciones (insert qn S) (Function.update v qn d) =>
      if codigo (H.val qn) ∉ S ∧ Omite codigo H.val R e q (H.val qn) G then (1 : ℚ) else 0) =
      (fun H => if codigo d ∉ S ∧ Omite codigo H.val R e q d G then (1 : ℚ) else 0) := by
    funext H
    have hd := H.property qn (Finset.mem_insert_self _ _)
    rw [Function.update_self] at hd
    rw [hd]
  rw [heq]
  by_cases hs : codigo d ∈ S
  · let _ : Nonempty (Completaciones (insert qn S) (Function.update v qn d)) :=
      ⟨⟨Function.update v qn d, by intro _ _; rfl⟩⟩
    simp only [hs, not_true_eq_false, false_and, ite_false, promedio_constante]
    exact SelectorPrimeras.riesgo_no_negativo _ _ _ _ _
  · simp only [hs, not_false_eq_true, true_and]
    have hf : codigo d ∉ insert qn S := by simp only [Finset.mem_insert, hc d, hs, or_self, not_false_eq_true]
    have h := SelectorAcoplado.omision_o_abandono_rom codigo hi R d (insert qn S)
      (Function.update v qn d) hf e q he hqM hqR G
    rw [Finset.card_insert_of_notMem hn] at h
    unfold SelectorPrimeras.riesgo
    refine le_trans ?_ h
    apply promedio_monotono
    intro H
    unfold Omite
    split_ifs <;> norm_num

theorem cota_tras_trabajo (S : Finset Q) (v : Q → Digest) (qw : Q) (hw : qw ∉ S)
    (bits : ℕ) (hbits : bits = 12 ∨ bits = 20) (f : (Q → Digest) → ℚ) (rho : ℚ)
    (h : ∀ d : Digest, Completo.trabajo bits d = true →
      promedio (fun H : Completaciones (insert qw S) (Function.update v qw d) => f H.val) ≤ rho) :
    promedio (fun H : Completaciones S v =>
      if Completo.trabajo bits (H.val qw) = true then f H.val else 0) ≤
      (1 / (2 : ℚ) ^ bits) * rho := by
  rw [media_revelar S v qw hw (fun H => if Completo.trabajo bits (H qw) = true then f H else 0)]
  have hp : promedio (fun d : Digest => promedio
      (fun H : Completaciones (insert qw S) (Function.update v qw d) =>
        if Completo.trabajo bits (H.val qw) = true then f H.val else 0)) ≤
      promedio (fun d : Digest => (if Completo.trabajo bits d = true then (1 : ℚ) else 0) * rho) := by
    apply promedio_monotono
    intro d
    have heq : (fun H : Completaciones (insert qw S) (Function.update v qw d) =>
        if Completo.trabajo bits (H.val qw) = true then f H.val else 0) =
        (fun H => if Completo.trabajo bits d = true then f H.val else 0) := by
      funext H
      have hd := H.property qw (Finset.mem_insert_self _ _)
      rw [Function.update_self] at hd
      rw [hd]
    rw [heq]
    by_cases hd : Completo.trabajo bits d = true
    · simp only [hd, ite_true, one_mul]
      exact h d hd
    · let _ : Nonempty (Completaciones (insert qw S) (Function.update v qw d)) :=
        ⟨⟨Function.update v qw d, by intro _ _; rfl⟩⟩
      simp [hd, promedio_constante]
  refine hp.trans_eq ?_
  calc
    _ = promedio (fun d : Digest => if Completo.trabajo bits d = true then (1 : ℚ) else 0) * rho := by
      simp only [promedio, ← Finset.sum_mul, div_mul_eq_mul_div]
    _ = _ := by rw [TrabajoDigest.masa_trabajo bits hbits]

theorem cota_trabajo_selector (codigo : Digest → Q) (hi : Function.Injective codigo)
    (S : Finset Q) (v : Q → Digest) (qw qn : Q)
    (hw : qw ∉ S) (hn : qn ∉ S) (hne : qn ≠ qw)
    (hcw : ∀ d, codigo d ≠ qw) (hcn : ∀ d, codigo d ≠ qn)
    (bits R e q : ℕ) (hbits : bits = 12 ∨ bits = 20)
    (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R) (G : Finset (Fin (2 ^ e))) :
    promedio (fun H : Completaciones S v =>
      if Completo.trabajo bits (H.val qw) = true ∧ codigo (H.val qn) ∉ S ∧
        Omite codigo H.val R e q (H.val qn) G then (1 : ℚ) else 0) ≤
      (1 / (2 : ℚ) ^ bits) * SelectorPrimeras.riesgo R e q G.card (S.card + 2) := by
  let f := fun H : Q → Digest =>
    if codigo (H qn) ∉ S ∧ Omite codigo H R e q (H qn) G then (1 : ℚ) else 0
  have h := cota_tras_trabajo S v qw hw bits hbits f
    (SelectorPrimeras.riesgo R e q G.card (S.card + 2)) (by
      intro d _
      have hnf : qn ∉ insert qw S := by simp only [Finset.mem_insert, hne, hn, or_self, not_false_eq_true]
      have hs := cota_semilla codigo hi (insert qw S) (Function.update v qw d) qn hnf hcn R e q he hqM hqR G
      simpa only [f, Finset.mem_insert, hcw, false_or, Finset.card_insert_of_notMem hw,
        Nat.add_assoc] using hs)
  refine le_trans ?_ h
  apply promedio_monotono
  intro H
  dsimp only [f]
  by_cases hw' : Completo.trabajo bits (H.val qw) = true <;> simp [hw']

end Nexus.Verificador.TrabajoSelectorLocal
