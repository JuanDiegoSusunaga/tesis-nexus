module

public import Nexus.Canal.UnionFiltrada
import Mathlib.Tactic

/-!
# Aceptación falsa separada de las excepciones y del exceso de cardinal

El presupuesto global de entradas distintas es la única hipótesis de coste.
La cota del pasado B-1 y la cota g de las políticas filtradas se derivan.
La probabilidad del exceso permanece explícita: todavía debe acotarse con
los argumentos AIR/FRI para obtener una garantía concreta de solidez.
-/

public section
namespace Nexus.Verificador.CotaFalsa

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM Nexus.Canal
open ProgramaBytes PoliticasFalsas SelectorAdaptativo FiltroSelector

variable {A : Type}
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem cota_sin_exceso (L bits R k g B : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (he : k + 2 ≤ 64) (hqM : 40 ≤ 2 ^ (k + 2)) (hqR : 40 ≤ R)
    (hB : ∀ H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest,
      (entradas (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
        (Adversario.ejecutar bits R proponer atacar actualizar)).toFinset.card ≤ B) :
    medida (fun H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest =>
      AceptaFalsa (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H) bits R k proponer atacar actualizar ∧
      EjecucionBytes.SinBad (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
        (inicial L) (Adversario.ejecutar bits R proponer atacar actualizar) ∧
      ¬ Exceso (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
        (Adversario.ejecutar bits R proponer atacar actualizar) defecto
        (altura (Adversario.ejecutar bits R proponer atacar actualizar)) (k + 2) g) ≤
      ROM.SelectorPrimeras.riesgo R (k + 2) 40 g (B - 1) * B := by
  let p := Adversario.ejecutar bits R proponer atacar actualizar
  have hu := UnionFiltrada.cota_union p defecto (altura p) R (k + 2) g B he hqM hqR hB
  apply le_trans _ hu
  apply medida_monotona
  intro H ha
  exact sin_exceso_cubre (oraculo p defecto H) p defecto (altura p) R (k + 2) g
    (cobertura_adversario (oraculo p defecto H) L bits R k proponer atacar actualizar ha.2.1 ha.1 defecto) ha.2.2

theorem cota_aditiva (L bits R k g B : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (he : k + 2 ≤ 64) (hqM : 40 ≤ 2 ^ (k + 2)) (hqR : 40 ≤ R)
    (hB : ∀ H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest,
      (entradas (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
        (Adversario.ejecutar bits R proponer atacar actualizar)).toFinset.card ≤ B) :
    medida (fun H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest =>
      AceptaFalsa (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H) bits R k proponer atacar actualizar) ≤
    medida (fun H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest =>
      ¬ EjecucionBytes.SinBad (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
        (inicial L) (Adversario.ejecutar bits R proponer atacar actualizar)) +
    medida (fun H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest =>
      Exceso (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
        (Adversario.ejecutar bits R proponer atacar actualizar) defecto
        (altura (Adversario.ejecutar bits R proponer atacar actualizar)) (k + 2) g) +
      ROM.SelectorPrimeras.riesgo R (k + 2) 40 g (B - 1) * B := by
  exact separar_excepciones _ _ _ _
    (cota_sin_exceso L bits R k g B proponer atacar actualizar defecto he hqM hqR hB)

theorem cota_512 (L bits k g B : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hB : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      (entradas (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
        (Adversario.ejecutar bits 512 proponer atacar actualizar)).toFinset.card ≤ B) :
    medida (fun H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest =>
      AceptaFalsa (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H) bits 512 k proponer atacar actualizar) ≤
    medida (fun H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest =>
      ¬ EjecucionBytes.SinBad (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
        (inicial L) (Adversario.ejecutar bits 512 proponer atacar actualizar)) +
    medida (fun H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest =>
      Exceso (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
        (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto
        (altura (Adversario.ejecutar bits 512 proponer atacar actualizar)) (k + 2) g) +
      ((Nat.choose g 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 + (1 : ℚ) / 2 ^ 300 +
        AcoplamientoCadena.error Digest 512 (B - 1)) * B := by
  have hm : 40 ≤ 2 ^ (k + 2) := (by decide : 40 ≤ 2 ^ 6).trans
    (Nat.pow_le_pow_right (by decide : 0 < 2) (by omega : 6 ≤ k + 2))
  have hb := cota_aditiva L bits 512 k g B proponer atacar actualizar defecto (by omega) hm (by decide) hB
  have hr := (ROM.SelectorPrimeras.riesgo_512 k g (B - 1) hk0 hk1).le
  exact hb.trans (add_le_add (le_refl _) (mul_le_mul_of_nonneg_right hr (by positivity)))

end Nexus.Verificador.CotaFalsa
