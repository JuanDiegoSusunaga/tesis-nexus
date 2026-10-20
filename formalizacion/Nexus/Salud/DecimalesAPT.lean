module

public import Nexus.Salud.APT
import Mathlib.Tactic

public section
set_option maxRecDepth 8192
set_option exponentiation.threshold 512
set_option maxHeartbeats 2000000

namespace Nexus.Salud

/-- Encierra 2^(-7,5) entre racionales sin usar coma flotante. -/
theorem probabilidad_apt_intervalo_decimal :
    (552427 / 100000000 : ℝ) ≤ probabilidadPerfilAPT ∧
      probabilidadPerfilAPT ≤ 552428 / 100000000 := by
  constructor
  · apply (sq_le_sq₀ (by norm_num : (0 : ℝ) ≤ 552427 / 100000000)
      (le_of_lt probabilidad_apt_positiva)).mp
    rw [probabilidad_apt_cuadrado]
    norm_num
  · apply (sq_le_sq₀ (le_of_lt probabilidad_apt_positiva)
      (by norm_num : (0 : ℝ) ≤ 552428 / 100000000)).mp
    rw [probabilidad_apt_cuadrado]
    norm_num

@[expose] noncomputable def pesoAPTInferior (k : ℕ) : ℝ :=
  (Nat.choose 511 k : ℝ) * (552427 / 100000000) ^ k *
    (1 - 552428 / 100000000) ^ (511 - k)

@[expose] noncomputable def pesoAPTSuperior (k : ℕ) : ℝ :=
  (Nat.choose 511 k : ℝ) * (552428 / 100000000) ^ k *
    (1 - 552427 / 100000000) ^ (511 - k)

theorem peso_apt_intervalo_decimal (k : ℕ) :
    pesoAPTInferior k ≤ pesoBinomial 511 probabilidadPerfilAPT k ∧
      pesoBinomial 511 probabilidadPerfilAPT k ≤ pesoAPTSuperior k := by
  have hp := probabilidad_apt_intervalo_decimal
  have hp0 := le_of_lt probabilidad_apt_positiva
  have hp1 : 0 ≤ 1 - probabilidadPerfilAPT := by linarith [hp.2]
  unfold pesoAPTInferior pesoAPTSuperior pesoBinomial
  constructor
  · exact mul_le_mul
      (mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (by norm_num) hp.1 k) (by positivity))
      (pow_le_pow_left₀ (by norm_num) (by linarith [hp.2]) _)
      (by positivity) (by positivity)
  · exact mul_le_mul
      (mul_le_mul_of_nonneg_left
        (pow_le_pow_left₀ (le_of_lt probabilidad_apt_positiva) hp.2 k) (by positivity))
      (pow_le_pow_left₀ (by linarith [hp.2]) (by linarith [hp.1]) _)
      (by positivity) (by positivity)

theorem cola_apt_partida (t h : ℕ) (hth : t ≤ h) (hh : h ≤ 512) :
    colaBinomial 511 probabilidadPerfilAPT t =
      (∑ k ∈ Finset.Ico t h, pesoBinomial 511 probabilidadPerfilAPT k) +
        colaBinomial 511 probabilidadPerfilAPT h := by
  exact (Finset.sum_Ico_consecutive _ hth hh).symm

theorem cola_apt_intervalo_finito (t h : ℕ) (ht : 15 ≤ h)
    (hth : t ≤ h) (hh : h ≤ 512) :
    (∑ k ∈ Finset.Ico t h, pesoAPTInferior k) ≤ colaBinomial 511 probabilidadPerfilAPT t ∧
      colaBinomial 511 probabilidadPerfilAPT t ≤
        (∑ k ∈ Finset.Ico t h, pesoAPTSuperior k) + pesoAPTSuperior h / (1 - 1 / 5) := by
  rw [cola_apt_partida t h hth hh]
  have hp := probabilidad_apt_intervalo
  constructor
  · exact (Finset.sum_le_sum fun k _ => (peso_apt_intervalo_decimal k).1).trans
      (le_add_of_nonneg_right (cola_binomial_no_negativa 511 h probabilidadPerfilAPT
        (le_of_lt probabilidad_apt_positiva) (by linarith [hp.2])))
  · apply add_le_add (Finset.sum_le_sum fun k _ => (peso_apt_intervalo_decimal k).2)
    exact (cola_binomial_geometrica 511 h probabilidadPerfilAPT (1 / 5)
      (le_of_lt probabilidad_apt_positiva) (by linarith [hp.2]) (by norm_num) (by norm_num)
      (fun k hk => pesos_apt_contraccion k (ht.trans hk))).trans
        (div_le_div_of_nonneg_right (peso_apt_intervalo_decimal h).2 (by norm_num))

theorem cola_apt_quince_decimal :
    |colaBinomial 511 probabilidadPerfilAPT 14 - (1523 / 1000000000 : ℝ)| <
      1 / 2000000000 := by
  have h := cola_apt_intervalo_finito 14 22 (by norm_num) (by norm_num) (by norm_num)
  have hlo : (1523 / 1000000000 - 1 / 2000000000 : ℝ) <
      ∑ k ∈ Finset.Ico 14 22, pesoAPTInferior k := by
    norm_num [Finset.sum_Ico_eq_sum_range, Finset.sum_range_succ, pesoAPTInferior,
      Nat.choose_eq_descFactorial_div_factorial, Nat.descFactorial, Nat.factorial]
  have hhi : (∑ k ∈ Finset.Ico 14 22, pesoAPTSuperior k) + pesoAPTSuperior 22 / (1 - 1 / 5) <
      (1523 / 1000000000 + 1 / 2000000000 : ℝ) := by
    norm_num [Finset.sum_Ico_eq_sum_range, Finset.sum_range_succ, pesoAPTSuperior,
      Nat.choose_eq_descFactorial_div_factorial, Nat.descFactorial, Nat.factorial]
  exact abs_lt.mpr ⟨by linarith [h.1], by linarith [h.2]⟩

theorem cola_apt_dieciseis_decimal :
    |colaBinomial 511 probabilidadPerfilAPT 15 - (2764 / 10000000000 : ℝ)| <
      1 / 20000000000 := by
  have h := cola_apt_intervalo_finito 15 23 (by norm_num) (by norm_num) (by norm_num)
  have hlo : (2764 / 10000000000 - 1 / 20000000000 : ℝ) <
      ∑ k ∈ Finset.Ico 15 23, pesoAPTInferior k := by
    norm_num [Finset.sum_Ico_eq_sum_range, Finset.sum_range_succ, pesoAPTInferior,
      Nat.choose_eq_descFactorial_div_factorial, Nat.descFactorial, Nat.factorial]
  have hhi : (∑ k ∈ Finset.Ico 15 23, pesoAPTSuperior k) + pesoAPTSuperior 23 / (1 - 1 / 5) <
      (2764 / 10000000000 + 1 / 20000000000 : ℝ) := by
    norm_num [Finset.sum_Ico_eq_sum_range, Finset.sum_range_succ, pesoAPTSuperior,
      Nat.choose_eq_descFactorial_div_factorial, Nat.descFactorial, Nat.factorial]
  exact abs_lt.mpr ⟨by linarith [h.1], by linarith [h.2]⟩

end Nexus.Salud
