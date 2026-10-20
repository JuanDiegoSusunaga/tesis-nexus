module

public import Nexus.ROM.ComposicionCotas
public import Nexus.ROM.ColaSelector
public import Nexus.N05.Cotas
import Mathlib.Tactic

/-!
# Aritmética exacta de la cota propuesta de sección 6.7.9

Esta fórmula reproduce los tres términos del manuscrito. Sus números
no demuestran que los eventos del ejecutable satisfagan las premisas;
el adaptador causal y el refinamiento global se mantienen pendientes.
-/

public section
namespace Nexus.ROM.Ejemplo

open Nexus.ROM.Presupuestos

@[expose] def mu : ℚ := Sesgo.masaMaxima Nexus.Goldilocks.p (2 ^ 128) ^ 2

@[expose] def sumaPropuesta (k g Q : ℕ) : ℚ :=
  let S := Q + verificadorPerfil k 512
  Composicion.cotaROM S (etiquetasPerfil k) +
    ((Q + retosPerfil k : ℕ) : ℚ) * ((8 * 2 ^ k : ℕ) : ℚ) * mu / 2 +
    ((Q + 1 : ℕ) : ℚ) / (2 : ℚ) ^ g *
      (Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8) + Selector.tau (4 * 2 ^ k) 512 39)

@[expose] def cotaPropuesta (k g Q : ℕ) : ℚ := min 1 (sumaPropuesta k g Q)

theorem cota_no_negativa (k g Q : ℕ) : 0 ≤ cotaPropuesta k g Q := by
  unfold cotaPropuesta sumaPropuesta Composicion.cotaROM mu Sesgo.masaMaxima Nexus.N05.H Selector.tau
  positivity

theorem cota_no_supera_uno (k g Q : ℕ) : cotaPropuesta k g Q ≤ 1 := min_le_left _ _

set_option maxRecDepth 8192 in
set_option exponentiation.threshold 512 in
theorem ejemplo_4096_20 :
    (4757335453 : ℚ) / 10 ^ 12 < cotaPropuesta 12 20 (2 ^ 20) ∧
      cotaPropuesta 12 20 (2 ^ 20) ≤ (4757335454 : ℚ) / 10 ^ 12 := by
  norm_num [cotaPropuesta, sumaPropuesta, Composicion.cotaROM, mu, Sesgo.masaMaxima,
    Nexus.Goldilocks.p, verificadorPerfil, caminosPerfil, hojasPerfil, canalPerfil,
    etiquetasPerfil, retosPerfil, Nexus.Complejidad.Comunicacion.sumaTG2,
    Nexus.Complejidad.Comunicacion.caminos, Finset.sum_range_succ, Nexus.N05.H, Selector.tau,
    Nat.choose_eq_descFactorial_div_factorial, Nat.descFactorial]

set_option maxRecDepth 8192 in
set_option exponentiation.threshold 512 in
theorem ejemplo_presupuesto_saturado : cotaPropuesta 12 20 (2 ^ 28) = 1 := by
  norm_num [cotaPropuesta, sumaPropuesta, Composicion.cotaROM, mu, Sesgo.masaMaxima,
    Nexus.Goldilocks.p, verificadorPerfil, caminosPerfil, hojasPerfil, canalPerfil,
    etiquetasPerfil, retosPerfil, Nexus.Complejidad.Comunicacion.sumaTG2,
    Nexus.Complejidad.Comunicacion.caminos, Finset.sum_range_succ, Nexus.N05.H, Selector.tau,
    Nat.choose_eq_descFactorial_div_factorial, Nat.descFactorial]

end Nexus.ROM.Ejemplo
