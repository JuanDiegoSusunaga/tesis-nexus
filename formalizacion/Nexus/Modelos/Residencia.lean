module

public import Mathlib.Data.Rat.Defs
public import Mathlib.Algebra.Order.Ring.Rat
public import Mathlib.Data.Fin.VecNotation
public import Mathlib.Algebra.Order.Group.Unbundled.Abs
import Mathlib.Tactic

/-! # Modelo de regiones protegidas de §5.6.3. No es una probabilidad de compromiso. -/

public section
namespace Nexus.Modelos.Residencia

@[expose] def promedio (b s ρ : ℚ) : ℚ := b + s * ρ
@[expose] def razon (b s ρ : ℚ) : ℚ := (b + s) / promedio b s ρ

/-- Con ocupación ρ∈[0,1], la media está entre la semilla y el contenedor cacheado. -/
theorem cotas_promedio (b s ρ : ℚ) (hs : 0 ≤ s) (hρ : 0 ≤ ρ) (hρ₁ : ρ ≤ 1) :
    b ≤ promedio b s ρ ∧ promedio b s ρ ≤ b + s := by
  unfold promedio
  constructor <;> nlinarith

/-- Bajo las condiciones del modelo, la razón cacheada/reexpansión es al menos uno. -/
theorem razon_al_menos_uno (b s ρ : ℚ) (hb : 0 < b) (hs : 0 ≤ s)
    (hρ : 0 ≤ ρ) (hρ₁ : ρ ≤ 1) : 1 ≤ razon b s ρ := by
  have hbounds := cotas_promedio b s ρ hs hρ hρ₁
  have hpos : 0 < promedio b s ρ := lt_of_lt_of_le hb hbounds.1
  unfold razon
  apply (le_div_iff₀ hpos).mpr
  simpa using hbounds.2

/-- La ventaja de residencia desaparece al llegar a ocupación continua. -/
theorem ocupacion_continua (b s : ℚ) : promedio b s 1 = b + s := by
  simp [promedio]

/-- Decimal conservado en R5/sensibilidad.json, convertido exactamente a segundos. -/
@[expose] def latencia : ℚ := 47874407894736845 / 100000000000000000000
@[expose] def tasas : Fin 5 → ℚ := ![1, 10, 100, 1000, 2000]
@[expose] def porcentajes_tabla : Fin 5 → ℚ := ![0.048, 0.479, 4.787, 47.874, 95.749]
@[expose] def promedios_tabla : Fin 5 → ℚ := ![33.930, 51.303, 225.030, 1962.296, 3892.592]
@[expose] def razones_tabla : Fin 5 → ℚ := ![119.775, 79.216, 18.060, 2.071, 1.044]

/-- Las quince cifras de la tabla 5.2 son redondeos correctos a tres decimales.
Se usa la latencia de la evidencia, no su presentación abreviada 478.74 µs. -/
theorem tabla5_2 (i : Fin 5) :
    |100 * tasas i * latencia - porcentajes_tabla i| < 1 / 2000 ∧
    |promedio 32 4032 (tasas i * latencia) - promedios_tabla i| < 1 / 2000 ∧
    |razon 32 4032 (tasas i * latencia) - razones_tabla i| < 1 / 2000 := by
  fin_cases i <;> norm_num [latencia, tasas, porcentajes_tabla, promedios_tabla,
    razones_tabla, promedio, razon]

end Nexus.Modelos.Residencia
