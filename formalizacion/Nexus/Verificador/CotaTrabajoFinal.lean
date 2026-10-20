module

public import Nexus.Verificador.CoberturaTrabajo
import Mathlib.Tactic

/-!
# Cota final adaptativa con Q+1 intentos y factor de trabajo real

La descomposición cobra Bad y las excepciones AIR/FRI una sola vez. El
selector se cobra por parejas nuevas, no por llamadas del verificador, y su
riesgo se multiplica por 2^(-bits) sin condicionar a un futuro seguro.
Se conserva un error de acoplamiento explícito para todas las repeticiones.
-/

public section
namespace Nexus.Verificador.CotaTrabajoFinal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.N06 Nexus.ROM Nexus.Canal
open ProgramaBytes SelectorAdaptativo FiltroSelector
open LeyArbol ObservacionesPrefijo
open scoped BigOperators

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 1024

@[expose] noncomputable def selector (k B : ℕ) : ℚ :=
  (Nat.choose (CardinalVista.umbral (k + 2)) 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 +
    1 / (2 : ℚ) ^ 300 + AcoplamientoCadena.error Digest 512 (B + 2)

theorem cota_selector_seguro {A : Type} (L bits k Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hbits : bits = 12 ∨ bits = 20) (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
        bits 512 proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar ∧
        EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
        ¬ (EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
          ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p))) ≤
      (1 / (2 : ℚ) ^ bits) * selector k (Q + 24895) * (Q + 1) := by
  dsimp only
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  let B := Q + 24895
  have hm : 40 ≤ 2 ^ (k + 2) := (by decide : 40 ≤ 2 ^ 6).trans
    (Nat.pow_le_pow_right (by decide : 0 < 2) (by omega : 6 ≤ k + 2))
  have hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B := by
    intro H
    simpa only [PresupuestoGlobal.presupuesto_512] using
      PresupuestoGlobal.entradas_distintas _ bits 512 Q proponer atacar actualizar (hQ H)
  have hK (H : universo p → Digest) : (ParTrabajo.claves (entradas (oraculo p defecto H) p)).card ≤ Q + 1 :=
    (ConteoPares.adversario _ bits 512 proponer atacar actualizar).trans (Nat.add_le_add_right (hQ H) 1)
  have hu := TrabajoPrefijo.cota_union p defecto (altura p) bits 512 (k + 2)
    (CardinalVista.umbral (k + 2)) B (Q + 1) hbits (by omega) hm (by decide) hB hK
  have hr := (SelectorPrimeras.riesgo_512 k (CardinalVista.umbral (k + 2)) (B + 2) hk0 hk1).le
  have hr' : (1 / (2 : ℚ) ^ bits) *
      SelectorPrimeras.riesgo 512 (k + 2) 40 (CardinalVista.umbral (k + 2)) (B + 2) * (Q + 1) ≤
      (1 / (2 : ℚ) ^ bits) * selector k B * (Q + 1) := by
    apply mul_le_mul_of_nonneg_right _ (by positivity)
    exact mul_le_mul_of_nonneg_left hr (by positivity)
  have hc : medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar ∧
        EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
        ¬ (EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
          ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p))) ≤
      medida (fun H : universo p → Digest => ∃ n : Fin (altura p),
        TrabajoPrefijo.Activa p defecto (prefijo (arbol p) n.val H) ∧
          TrabajoPrefijo.Evento p defecto bits 512 (k + 2) (CardinalVista.umbral (k + 2))
            (prefijo (arbol p) n.val H) H) := by
    apply medida_monotona
    intro H hh
    exact CoberturaTrabajo.adversario_seguro L bits 512 k proponer atacar actualizar defecto H
      hh.1 hh.2.1 (fun hx => hh.2.2 ⟨hh.2.1, hx⟩)
  simp only [medida_media] at hc ⊢
  simp only [Nat.cast_add, Nat.cast_one] at hu
  exact hc.trans (hu.trans hr')

@[expose] noncomputable def cota512 (L bits k Q : ℕ) : ℚ :=
  let B := Q + 24895
  min 1 (((B * (49 * B + L) : ℕ) : ℚ) / (2 : ℚ) ^ 256) + CotaAdaptativaFinal.tasa * B +
    (1 / (2 : ℚ) ^ bits) * selector k B * (Q + 1)

theorem cota_512 {A : Type} (L bits k Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hbits : bits = 12 ∨ bits = 20) (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
        bits 512 proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar) ≤
      min 1 (cota512 L bits k Q) := by
  dsimp only
  apply le_min (CotaPerfilesFinal.medida_le_uno _)
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  have hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ Q + 24895 := by
    intro H
    simpa only [PresupuestoGlobal.presupuesto_512] using
      PresupuestoGlobal.entradas_distintas _ bits 512 Q proponer atacar actualizar (hQ H)
  have hsafe := cota_selector_seguro L bits k Q proponer atacar actualizar defecto hbits hk0 hk1 hQ
  have hsep := separar_excepciones _ _ _ _ hsafe
  have hsin := CotaSinBad.cota_512 L bits Q proponer atacar actualizar defecto hQ
  have hrondas := CotaAdaptativaFinal.cota_rondas p defecto L (altura p) (Q + 24895) hB
  dsimp only at hsep hsin
  dsimp only [p] at hrondas
  unfold cota512
  dsimp only
  simp only [Nat.cast_add, Nat.cast_ofNat] at hrondas ⊢
  linarith only [hsep, hsin, hrondas]

@[expose] noncomputable def selectorTodos (B : ℕ) : ℚ := ∑ i : Fin 9, selector (i.val + 4) B

@[expose] noncomputable def cota512Todos (L bits Q : ℕ) : ℚ :=
  let B := Q + 24895
  min 1 (((B * (49 * B + L) : ℕ) : ℚ) / (2 : ℚ) ^ 256) + CotaAdaptativaFinal.tasa * B +
    (1 / (2 : ℚ) ^ bits) * selectorTodos B * (Q + 1)

theorem cota_512_todos {A : Type} (L bits Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hbits : bits = 12 ∨ bits = 20)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
        bits 512 proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      CotaPerfilesFinal.AceptaFalsaTotal (oraculo p defecto H) bits 512 proponer atacar actualizar) ≤
      min 1 (cota512Todos L bits Q) := by
  dsimp only
  apply le_min (CotaPerfilesFinal.medida_le_uno _)
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  let B := Q + 24895
  let E := fun (i : Fin 9) (H : universo p → Digest) =>
    PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 (i.val + 4) proponer atacar actualizar
  let S := fun H : universo p → Digest => EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p
  let X := fun H : universo p → Digest => S H ∧ ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p)
  have hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B := by
    intro H
    simpa only [PresupuestoGlobal.presupuesto_512] using
      PresupuestoGlobal.entradas_distintas _ bits 512 Q proponer atacar actualizar (hQ H)
  have hsafe : medida (fun H => (∃ i : Fin 9, E i H) ∧ S H ∧ ¬ X H) ≤
      (1 / (2 : ℚ) ^ bits) * selectorTodos B * (Q + 1) := by
    calc
      _ ≤ ∑ i : Fin 9, medida (fun H => E i H ∧ S H ∧ ¬ X H) := CotaInicios.union_con_pasado E S X
      _ ≤ ∑ i : Fin 9, (1 / (2 : ℚ) ^ bits) * selector (i.val + 4) B * (Q + 1) := by
        apply Finset.sum_le_sum
        intro i _
        exact cota_selector_seguro L bits (i.val + 4) Q proponer atacar actualizar defecto hbits (by omega) (by omega) hQ
      _ = _ := by simp only [selectorTodos, Finset.mul_sum, Finset.sum_mul]
  have hsep := separar_excepciones (fun H => ∃ i : Fin 9, E i H) S X
    ((1 / (2 : ℚ) ^ bits) * selectorTodos B * (Q + 1)) hsafe
  have hsin := CotaSinBad.cota_512 L bits Q proponer atacar actualizar defecto hQ
  have hrondas := CotaAdaptativaFinal.cota_rondas p defecto L (altura p) B hB
  have htotal := medida_monotona
    (fun H : universo p → Digest =>
      CotaPerfilesFinal.AceptaFalsaTotal (oraculo p defecto H) bits 512 proponer atacar actualizar)
    (fun H => ∃ i : Fin 9, E i H)
    (fun H h => (CotaPerfilesFinal.falsa_total_iff_perfiles (oraculo p defecto H) bits 512
      proponer atacar actualizar).mp h)
  dsimp only [E, S, X, p, B] at hsep hrondas htotal
  dsimp only at hsin
  unfold cota512Todos
  dsimp only
  simp only [Nat.cast_add, Nat.cast_ofNat] at hsep hrondas ⊢
  linarith only [htotal, hsep, hsin, hrondas]

end Nexus.Verificador.CotaTrabajoFinal
