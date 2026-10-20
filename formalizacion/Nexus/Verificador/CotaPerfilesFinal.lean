module

public import Nexus.Verificador.CotaAdaptativaFinal
import Mathlib.Tactic

/-!
# Perfil de salida elegido adaptativamente con un presupuesto común

La unión sobre los nueve perfiles cobra SinBad y el evento AIR/FRI una
sola vez. Únicamente se suman los riesgos del selector por perfil. No se
presupone qué perfil elegirá el certificado que termine aceptado.
-/

public section
namespace Nexus.Verificador.CotaPerfilesFinal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal Nexus.N06
open ProgramaBytes SelectorAdaptativo FiltroSelector CotaAdaptativaFinal
open scoped BigOperators

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 1024

@[expose] def AceptaFalsaTotal {A : Type} (H : Entrada → Digest) (bits R : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) : Prop :=
  ∃ k : ℕ, PoliticasFalsas.AceptaFalsa H bits R k proponer atacar actualizar

theorem perfil_aceptado {A : Type} (H : Entrada → Digest) (bits R k : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (ha : PoliticasFalsas.AceptaFalsa H bits R k proponer atacar actualizar) : 4 ≤ k ∧ k ≤ 12 := by
  obtain ⟨hacc, c, hparse, hk, _⟩ := ha
  obtain ⟨c', hparse', hforma⟩ := Adversario.aceptacion_certificado_elegido H bits R proponer atacar actualizar hacc
  have heq : c' = c := Option.some.inj (hparse'.symm.trans hparse)
  subst c'
  rw [hk] at hforma
  exact ⟨hforma.1.1, hforma.1.2.1⟩

theorem falsa_total_iff_perfiles {A : Type} (H : Entrada → Digest) (bits R : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) :
    AceptaFalsaTotal H bits R proponer atacar actualizar ↔
      ∃ i : Fin 9, PoliticasFalsas.AceptaFalsa H bits R (i.val + 4) proponer atacar actualizar := by
  constructor
  · rintro ⟨k, hk⟩
    have hperfil := perfil_aceptado H bits R k proponer atacar actualizar hk
    let i : Fin 9 := ⟨k - 4, by omega⟩
    have hi : i.val + 4 = k := by dsimp [i]; omega
    exact ⟨i, hi.symm ▸ hk⟩
  · rintro ⟨i, hi⟩
    exact ⟨i.val + 4, hi⟩

@[expose] noncomputable def selectorTodos (B : ℕ) : ℚ := ∑ i : Fin 9, selector (i.val + 4) B

@[expose] noncomputable def cota512Todos (L Q : ℕ) : ℚ :=
  let B := Q + 24895
  min 1 (((B * (49 * B + L) : ℕ) : ℚ) / (2 : ℚ) ^ 256) +
    (tasa + selectorTodos B) * B

theorem cota_selector_seguro {A : Type} (L bits k B : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hB : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      (entradas (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
        (Adversario.ejecutar bits 512 proponer atacar actualizar)).toFinset.card ≤ B) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar ∧
        EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
        ¬ (EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
          ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p))) ≤ selector k B * B := by
  dsimp only
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  have hm : 40 ≤ 2 ^ (k + 2) := (by decide : 40 ≤ 2 ^ 6).trans
    (Nat.pow_le_pow_right (by decide : 0 < 2) (by omega : 6 ≤ k + 2))
  have hbase := CotaFalsa.cota_sin_exceso L bits 512 k (CardinalVista.umbral (k + 2)) B
    proponer atacar actualizar defecto (by omega) hm (by decide) hB
  have hsafe : medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar ∧
        EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
        ¬ (EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
          ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p))) ≤
      ROM.SelectorPrimeras.riesgo 512 (k + 2) 40 (CardinalVista.umbral (k + 2)) (B - 1) * B := by
    apply le_trans _ hbase
    apply medida_monotona
    intro H hh
    refine ⟨hh.1, hh.2.1, ?_⟩
    intro hexceso
    exact hh.2.2 ⟨hh.2.1, ExcesoRondas.exceso_implica_rondas (oraculo p defecto H) p defecto
      (altura p) (k + 2) hexceso⟩
  have hr := (ROM.SelectorPrimeras.riesgo_512 k (CardinalVista.umbral (k + 2)) (B - 1) hk0 hk1).le
  exact hsafe.trans (mul_le_mul_of_nonneg_right hr (by positivity))

theorem cota_512_todos {A : Type} (L bits Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias
          (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
          bits 512 proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      AceptaFalsaTotal (oraculo p defecto H) bits 512 proponer atacar actualizar) ≤ cota512Todos L Q := by
  dsimp only
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  let B := Q + 24895
  let E := fun H : universo p → Digest => AceptaFalsaTotal (oraculo p defecto H) bits 512 proponer atacar actualizar
  let S := fun H : universo p → Digest => EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p
  let X := fun H : universo p → Digest => S H ∧ ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p)
  have hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B := by
    intro H
    simpa only [PresupuestoGlobal.presupuesto_512] using
      PresupuestoGlobal.entradas_distintas (oraculo p defecto H) bits 512 Q proponer atacar actualizar (hQ H)
  have hsafe : medida (fun H => E H ∧ S H ∧ ¬ X H) ≤ selectorTodos B * B := by
    let F := fun (i : Fin 9) H =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 (i.val + 4) proponer atacar actualizar ∧
        S H ∧ ¬ X H
    calc
      _ ≤ medida (fun H => ∃ i : Fin 9, F i H) := by
        apply medida_monotona
        intro H hh
        obtain ⟨i, hi⟩ := (falsa_total_iff_perfiles (oraculo p defecto H) bits 512 proponer atacar actualizar).mp hh.1
        exact ⟨i, hi, hh.2⟩
      _ ≤ ∑ i : Fin 9, medida (F i) := by
        simp_rw [medida_media]
        exact ConteoActivaciones.union_finita F
      _ ≤ ∑ i : Fin 9, selector (i.val + 4) B * B := by
        apply Finset.sum_le_sum
        intro i _
        exact cota_selector_seguro L bits (i.val + 4) B proponer atacar actualizar defecto (by omega) (by omega) hB
      _ = selectorTodos B * B := by unfold selectorTodos; rw [Finset.sum_mul]
  have hsep := separar_excepciones E S X (selectorTodos B * B) hsafe
  have hsin := CotaSinBad.cota_512 L bits Q proponer atacar actualizar defecto hQ
  have hrondas := CotaAdaptativaFinal.cota_rondas p defecto L (altura p) B hB
  dsimp only [E, S, X, p, B] at hsep hrondas
  dsimp only at hsin
  unfold cota512Todos
  dsimp only
  simp only [Nat.cast_add, Nat.cast_ofNat] at hsep hrondas ⊢
  nlinarith only [hsep, hsin, hrondas]

theorem medida_le_uno {W : Type} [Fintype W] [Nonempty W] (E : W → Prop) : medida E ≤ 1 := by
  rw [medida_media]
  apply le_trans _ (promedio_constante (K := W) 1).le
  apply promedio_monotono
  intro w
  split_ifs <;> norm_num

theorem cota_512_todos_truncada {A : Type} (L bits Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias
          (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
          bits 512 proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      AceptaFalsaTotal (oraculo p defecto H) bits 512 proponer atacar actualizar) ≤ min 1 (cota512Todos L Q) := by
  exact le_min (medida_le_uno _) (cota_512_todos L bits Q proponer atacar actualizar defecto hQ)

end Nexus.Verificador.CotaPerfilesFinal
