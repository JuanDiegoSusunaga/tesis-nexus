module

public import Mathlib.Analysis.SpecialFunctions.Log.Base
import Mathlib.Tactic

public section
set_option maxRecDepth 8192
set_option exponentiation.threshold 1200
set_option maxHeartbeats 1000000

namespace Nexus.Cripto.PerdidaQROM

/-- Fórmula numérica citada en §6.3.2; no afirma una reducción criptográfica. -/
@[expose] noncomputable def perdida (qS qH p epsilon zeta delta : ℝ) : ℝ :=
  (2 * qS * Real.sqrt epsilon / (1 - p)) * Real.sqrt (qH + 1 + qS / (1 - p)) +
    2 * (qH + 1) * Real.sqrt (qS * epsilon / (1 - p)) + qS * zeta + delta

@[expose] noncomputable def referencia : ℝ :=
  perdida (2 ^ 64) (2 ^ 192) (103 / 128) (1 / 2 ^ 1180) 0 (1 / 2 ^ 362)

@[expose] noncomputable def primero : ℝ :=
  (2 * 2 ^ 64 / (1 - 103 / 128) * 2 ^ 362) * Real.sqrt (1 / 2 ^ 1180) *
    Real.sqrt (2 ^ 192 + 1 + 2 ^ 64 / (1 - 103 / 128))

@[expose] noncomputable def segundo : ℝ :=
  (2 * (2 ^ 192 + 1) * 2 ^ 362) * Real.sqrt (2 ^ 64 * (1 / 2 ^ 1180) / (1 - 103 / 128))

theorem escala_exacta : referencia * 2 ^ 362 = primero + segundo + 1 := by
  unfold referencia perdida primero segundo
  ring

theorem primer_intervalo : 0 ≤ primero ∧ primero < 1 / 10000000000 := by
  have ha : 0 ≤ primero := by unfold primero; positivity
  have hs : primero ^ 2 < (1 / 10000000000 : ℝ) ^ 2 := by
    unfold primero
    rw [mul_pow, mul_pow, Real.sq_sqrt (by positivity), Real.sq_sqrt (by positivity)]
    norm_num
  exact ⟨ha, by nlinarith⟩

theorem segundo_intervalo :
    (28284271 / 100000000 : ℝ) < segundo ∧ segundo < 28284272 / 100000000 := by
  have ha : 0 ≤ segundo := by unfold segundo; positivity
  have hs : (28284271 / 100000000 : ℝ) ^ 2 < segundo ^ 2 ∧
      segundo ^ 2 < (28284272 / 100000000 : ℝ) ^ 2 := by
    unfold segundo
    rw [mul_pow, Real.sq_sqrt (by positivity)]
    norm_num
  constructor <;> nlinarith [hs.1, hs.2]

theorem perdida_intervalo_escalado :
    (12828427 / 10000000 : ℝ) < referencia * 2 ^ 362 ∧
      referencia * 2 ^ 362 < 12828428 / 10000000 := by
  rw [escala_exacta]
  have h1 := primer_intervalo
  have h2 := segundo_intervalo
  constructor <;> linarith

theorem perdida_positiva : 0 < referencia := by
  have h := perdida_intervalo_escalado.1
  have hp : (0 : ℝ) < 2 ^ 362 := by positivity
  nlinarith

theorem perdida_menor_dos_menos_360 : referencia < 1 / 2 ^ 360 := by
  have h := perdida_intervalo_escalado.2
  norm_num at h ⊢
  linarith

theorem logaritmo_perdida_decimal :
    |Real.logb 2 referencia - (-36164 / 100 : ℝ)| < 1 / 200 := by
  have hlo : (2 : ℝ) ^ 71 < (12828427 / 10000000 : ℝ) ^ 200 := by norm_num
  have hhi : (12828428 / 10000000 : ℝ) ^ 200 < (2 : ℝ) ^ 73 := by norm_num
  have hl := Real.logb_lt_logb (by norm_num : (1 : ℝ) < 2) (by positivity) hlo
  have hu := Real.logb_lt_logb (by norm_num : (1 : ℝ) < 2) (by norm_num) hhi
  rw [Real.logb_pow, Real.logb_pow] at hl hu
  norm_num at hl hu
  have h := perdida_intervalo_escalado
  have hlow := Real.logb_lt_logb (by norm_num : (1 : ℝ) < 2)
    (by norm_num : (0 : ℝ) < 12828427 / 10000000) h.1
  have hhigh := Real.logb_lt_logb (by norm_num : (1 : ℝ) < 2)
    (mul_pos perdida_positiva (by positivity)) h.2
  rw [Real.logb_mul (ne_of_gt perdida_positiva) (by positivity), Real.logb_pow] at hlow hhigh
  norm_num at hlow hhigh
  exact abs_lt.mpr ⟨by linarith, by linarith⟩

end Nexus.Cripto.PerdidaQROM
