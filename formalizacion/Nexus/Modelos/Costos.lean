module

public import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Tactic

/-! # Modelos de datos y amortización de §§3.3–3.4. -/

public section
namespace Nexus.Modelos.Costos

open Filter Topology

@[expose] def throughput (B τ b s : ℚ) : ℚ := B / (τ * (b + s))
@[expose] def costo (d P : ℚ) (M : ℕ) : ℚ := d + P / M

/-- Cancelación de los parámetros comunes del modelo de throughput. -/
theorem razon_throughput (B τ b s₁ s₂ : ℚ) (hB : B ≠ 0) (hτ : τ ≠ 0)
    (h₁ : b + s₁ ≠ 0) (h₂ : b + s₂ ≠ 0) :
    throughput B τ b s₁ / throughput B τ b s₂ = (b + s₂) / (b + s₁) := by
  unfold throughput
  field_simp

/-- El límite publicado de F(M)=d+(C+π)/M, como límite sobre tamaños naturales. -/
theorem limite_amortizacion (d C π : ℝ) :
    Tendsto (fun M : ℕ => d + (C + π) / M) atTop (𝓝 d) := by
  simpa using (tendsto_const_nhds (x := d)).add
    (tendsto_const_div_atTop_nhds_zero_nat (C + π))

/-- El costo marginal d es una cota inferior si el costo fijo es no negativo. -/
theorem piso_costo (d P : ℚ) (M : ℕ) (hP : 0 ≤ P) : d ≤ costo d P M := by
  unfold costo
  have : 0 ≤ P / (M : ℚ) := div_nonneg hP (by positivity)
  linarith

/-- Aumentar un lote positivo no aumenta el costo por operación del modelo. -/
theorem costo_decrece (d P : ℚ) (M N : ℕ) (hP : 0 ≤ P) (hM : 0 < M) (hMN : M ≤ N) :
    costo d P N ≤ costo d P M := by
  unfold costo
  apply add_le_add (le_refl d)
  apply div_le_div_of_nonneg_left hP
  · exact_mod_cast hM
  · exact_mod_cast hMN

/-- Condición exacta de equilibrio con un costo por operación de referencia. -/
theorem equilibrio (d P base : ℚ) (M : ℕ) (hM : 0 < M) :
    costo d P M ≤ base ↔ P ≤ (base - d) * M := by
  have hMq : (0 : ℚ) < M := by exact_mod_cast hM
  unfold costo
  rw [← le_sub_iff_add_le']
  exact div_le_iff₀ hMq

/-- Razones de tamaños y throughput de §3.3, con tolerancia de redondeo explícita. -/
theorem cuentas_capitulo3 :
    (100 + 3309 : ℚ) / (100 + 64) = 3409 / 164 ∧
    |(3409 : ℚ) / 164 - 20.8| < 0.05 ∧
    |(3309 : ℚ) / 64 - 52| < 0.5 ∧
    |(1952 : ℚ) / 33 - 59| < 0.5 ∧
    (97 : ℚ) / 100 < 3309 / 3409 ∧
    (24.35 : ℚ) ≤ 3409 / 140 ∧ 3409 / 40 < (85.23 : ℚ) := by
  norm_num

end Nexus.Modelos.Costos
