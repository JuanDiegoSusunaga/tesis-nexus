module

public import Nexus.Verificador.CotaTrabajoFinal
public import Nexus.Verificador.CotaRondas
import Mathlib.Tactic

/-!
# Ejemplos racionales de la cota conjunta, sin evaluar binomiales gigantes

Se usa el mayorante probado 1/200 para cada uno de los nueve perfiles.
Las cifras incluyen Bad, AIR/FRI, transporte de campo, cola, acoplamiento,
trabajo y Q+1 intentos. Son garantías del modelo ROM, no de SHA3 determinista.
-/

public section
namespace Nexus.Verificador.CotaTrabajoNumerica

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.N06 Nexus.ROM Nexus.Canal
open CotaTrabajoFinal ProgramaBytes SelectorAdaptativo FiltroSelector
open scoped BigOperators

set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 1024

@[expose] def colaComun (B : ℕ) : ℚ :=
  1 / (2 : ℚ) ^ 300 + ((512 * (B + 515) : ℕ) : ℚ) / (2 : ℚ) ^ 256

theorem selector_uniforme (k B : ℕ) (hk : 4 ≤ k) :
    selector k B ≤ 1 / 200 + colaComun B := by
  have hh := (CotaRondas.hipergeometrica k hk).trans CotaRondas.omision_cuarenta
  have he : AcoplamientoCadena.error Digest 512 (B + 2) ≤
      ((512 * (B + 515) : ℕ) : ℚ) / (2 : ℚ) ^ 256 := by
    rw [SelectorAcoplado.error_digest]
    have hsum : B + 2 + 512 + 1 = B + 515 := by omega
    rw [hsum]
    exact min_le_right _ _
  unfold selector colaComun
  linarith only [hh, he]

theorem selector_todos_uniforme (B : ℕ) : selectorTodos B ≤ 9 * (1 / 200 + colaComun B) := by
  unfold selectorTodos
  calc
    _ ≤ ∑ _ : Fin 9, (1 / 200 + colaComun B) := by
      apply Finset.sum_le_sum
      intro i _
      exact selector_uniforme (i.val + 4) B (by omega)
    _ = _ := by simp; ring

theorem cota_todos_uniforme (L bits Q : ℕ) :
    cota512Todos L bits Q ≤
      let B := Q + 24895
      min 1 (((B * (49 * B + L) : ℕ) : ℚ) / (2 : ℚ) ^ 256) + CotaAdaptativaFinal.tasa * B +
        (1 / (2 : ℚ) ^ bits) * (9 * (1 / 200 + colaComun B)) * (Q + 1) := by
  have hs := selector_todos_uniforme (Q + 24895)
  have hm := mul_le_mul_of_nonneg_right
    (mul_le_mul_of_nonneg_left hs (by positivity : (0 : ℚ) ≤ 1 / (2 : ℚ) ^ bits))
    (by positivity : (0 : ℚ) ≤ (Q : ℚ) + 1)
  unfold cota512Todos
  dsimp only
  linarith only [hm]

theorem ejemplo_release : cota512Todos 1000000 20 1000000 < 1 / 20 := by
  apply lt_of_le_of_lt (cota_todos_uniforme 1000000 20 1000000)
  norm_num [colaComun, CotaAdaptativaFinal.tasa, Nexus.Goldilocks.p]

theorem ejemplo_debug : cota512Todos 1000000 12 1000 < 1 / 80 := by
  apply lt_of_le_of_lt (cota_todos_uniforme 1000000 12 1000)
  norm_num [colaComun, CotaAdaptativaFinal.tasa, Nexus.Goldilocks.p]

theorem ejemplo_4096_release : cota512 1000000 20 12 (2 ^ 20) < (4757335454 : ℚ) / 10 ^ 12 := by
  norm_num [cota512, selector, CardinalVista.umbral, AcoplamientoCadena.error,
    ProyeccionDigest.cardinal_digest, CotaAdaptativaFinal.tasa, Nexus.Goldilocks.p,
    Nat.choose_eq_descFactorial_div_factorial, Nat.descFactorial]

theorem aceptacion_release {A : Type}
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hQ : ∀ H : universo (Adversario.ejecutar 20 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias (oraculo (Adversario.ejecutar 20 512 proponer atacar actualizar) defecto H)
        20 512 proponer atacar actualizar ≤ 1000000) :
    let p := Adversario.ejecutar 20 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      CotaPerfilesFinal.AceptaFalsaTotal (oraculo p defecto H) 20 512 proponer atacar actualizar) < 1 / 20 := by
  have h := cota_512_todos 1000000 20 1000000 proponer atacar actualizar defecto (Or.inr rfl) hQ
  exact (h.trans (min_le_right _ _)).trans_lt ejemplo_release

theorem aceptacion_4096_release {A : Type}
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hQ : ∀ H : universo (Adversario.ejecutar 20 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias (oraculo (Adversario.ejecutar 20 512 proponer atacar actualizar) defecto H)
        20 512 proponer atacar actualizar ≤ 2 ^ 20) :
    let p := Adversario.ejecutar 20 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) 20 512 12 proponer atacar actualizar) <
      (4757335454 : ℚ) / 10 ^ 12 := by
  have h := cota_512 1000000 20 12 (2 ^ 20) proponer atacar actualizar defecto (Or.inr rfl)
    (by decide) (by decide) hQ
  exact (h.trans (min_le_right _ _)).trans_lt ejemplo_4096_release

end Nexus.Verificador.CotaTrabajoNumerica
