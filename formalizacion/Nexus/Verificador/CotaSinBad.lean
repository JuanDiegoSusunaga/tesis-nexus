module

public import Nexus.ROM.LeySinBad
public import Nexus.Verificador.PresupuestoGlobal
import Mathlib.Tactic

/-!
# Probabilidad de fallo de reconstrucción desde el presupuesto real

El presupuesto Q limita las llamadas adversarias en el ROM finito. Se usa
la cota de llamadas del verificador completo y el recorte del programa,
sin suponer una cota sobre ramas inconsistentes del árbol de consultas.
-/

public section
namespace Nexus.Verificador.CotaSinBad

open Nexus.Bytes Nexus.Merkle Nexus.ROM Nexus.Canal
open ProgramaBytes SelectorAdaptativo FiltroSelector

set_option maxRecDepth 4096
set_option maxHeartbeats 800000
attribute [local instance] Classical.propDecidable

theorem cota_desde_Q {A : Type} (L bits R Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hQ : ∀ H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest,
      Adversario.adversarias
          (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
          bits R proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits R proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      ¬ EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p) ≤
      min 1 (((PresupuestoGlobal.B Q R * (49 * PresupuestoGlobal.B Q R + L) : ℕ) : ℚ) /
        (2 : ℚ) ^ 256) := by
  dsimp only
  let p := Adversario.ejecutar bits R proponer atacar actualizar
  have hc (H : universo p → Digest) :
      (traza (oraculo p defecto H) p).length ≤ PresupuestoGlobal.B Q R :=
    PresupuestoGlobal.llamadas_totales _ bits R Q proponer atacar actualizar (hQ H)
  have hraw := LeySinBad.cota_sinBad_llamadas L (PresupuestoGlobal.B Q R) p (universo p)
    (SelectorAcoplado.pasado_en_universo (SoporteFinito.soporte p)) defecto hc
  rw [medida_media]
  apply le_trans ?_ hraw
  apply Nexus.N06.promedio_monotono
  intro H
  by_cases hs : EjecucionBytes.SinBad (SoporteFinito.prolongar (universo p) defecto H) (inicial L) p
  · dsimp only [p] at hs
    simp only [p, oraculo, hs, not_true_eq_false, reduceIte, le_refl]
  · dsimp only [p] at hs
    simp only [p, oraculo, hs, not_false_eq_true, reduceIte, le_refl]

theorem cota_512 {A : Type} (L bits Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias
          (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
          bits 512 proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      ¬ EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p) ≤
      min 1 ((((Q + 24895) * (49 * (Q + 24895) + L) : ℕ) : ℚ) / (2 : ℚ) ^ 256) := by
  simpa only [PresupuestoGlobal.presupuesto_512] using
    (cota_desde_Q L bits 512 Q proponer atacar actualizar defecto hQ)

/-! La clasificación AIR/FRI solo necesita aplicarse a ejecuciones sin la
excepción ROM. Se conserva esa intersección antes de sumar probabilidades,
para no cobrar dos veces el término de fallo de reconstrucción. -/
set_option exponentiation.threshold 512 in
theorem cota_512_rondas_seguras {A : Type} (L bits k Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias
          (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
          bits 512 proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar) ≤
      min 1 ((((Q + 24895) * (49 * (Q + 24895) + L) : ℕ) : ℚ) / (2 : ℚ) ^ 256) +
      medida (fun H : universo p → Digest =>
        EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
        ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p)) +
      ((Nat.choose (CardinalVista.umbral (k + 2)) 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 +
        1 / (2 : ℚ) ^ 300 + AcoplamientoCadena.error Digest 512 (Q + 24894)) *
        (Q + 24895) := by
  dsimp only
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  have hB : ∀ H : universo p → Digest,
      (entradas (oraculo p defecto H) p).toFinset.card ≤ PresupuestoGlobal.B Q 512 :=
    fun H => PresupuestoGlobal.entradas_distintas _ bits 512 Q proponer atacar actualizar (hQ H)
  have hm : 40 ≤ 2 ^ (k + 2) := (by decide : 40 ≤ 2 ^ 6).trans
    (Nat.pow_le_pow_right (by decide : 0 < 2) (by omega : 6 ≤ k + 2))
  have hsafe := CotaFalsa.cota_sin_exceso L bits 512 k (CardinalVista.umbral (k + 2))
    (PresupuestoGlobal.B Q 512) proponer atacar actualizar defecto (by omega) hm (by decide) hB
  have hrondas : medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar ∧
      EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
      ¬ (EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
        ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p))) ≤
      ROM.SelectorPrimeras.riesgo 512 (k + 2) 40 (CardinalVista.umbral (k + 2))
        (PresupuestoGlobal.B Q 512 - 1) * PresupuestoGlobal.B Q 512 := by
    apply le_trans _ hsafe
    apply medida_monotona
    intro H hh
    refine ⟨hh.1, hh.2.1, ?_⟩
    intro hexceso
    exact hh.2.2 ⟨hh.2.1,
      ExcesoRondas.exceso_implica_rondas (oraculo p defecto H) p defecto
        (altura p) (k + 2) hexceso⟩
  have hsep := separar_excepciones _ _ _ _ hrondas
  have hselector := (ROM.SelectorPrimeras.riesgo_512 k (CardinalVista.umbral (k + 2))
    (PresupuestoGlobal.B Q 512 - 1) hk0 hk1).le
  have hbase := hsep.trans (add_le_add (le_refl _)
    (mul_le_mul_of_nonneg_right hselector (by positivity)))
  have hsub : PresupuestoGlobal.B Q 512 - 1 = Q + 24894 := by
    rw [PresupuestoGlobal.presupuesto_512]
    omega
  rw [hsub, PresupuestoGlobal.presupuesto_512] at hbase
  have hsin := cota_512 L bits Q proponer atacar actualizar defecto hQ
  dsimp only [p] at hbase
  dsimp only at hsin
  simp only [Nat.cast_add, Nat.cast_ofNat] at hbase
  linarith

end Nexus.Verificador.CotaSinBad
