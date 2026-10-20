module

public import Nexus.Salud.Binomial
public import Nexus.Salud.RCT
import Mathlib.Tactic

/-!
# Certificado del corte APT del manuscrito

La referencia cuenta una vez: B=1+Bin(511,2^(-7.5)). Se certifica que el
menor C≥1 cuya cola es ≤2^(-20) es 16. Las cotas usan racionales exactos.
-/

public section
set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace Nexus.Salud

@[expose] noncomputable def probabilidadPerfilAPT : ℝ := (2 : ℝ) ^ (-(15 / 2 : ℝ))

theorem probabilidad_apt_positiva : 0 < probabilidadPerfilAPT := by
  exact Real.rpow_pos_of_pos (by norm_num) _

theorem probabilidad_apt_cuadrado : probabilidadPerfilAPT ^ 2 = 1 / 32768 := by
  unfold probabilidadPerfilAPT
  rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 2)]
  norm_num [Real.rpow_neg (by norm_num : (0 : ℝ) ≤ 2)]

theorem probabilidad_apt_intervalo :
    (1 / 182 : ℝ) ≤ probabilidadPerfilAPT ∧ probabilidadPerfilAPT ≤ 1 / 181 := by
  constructor
  · apply (sq_le_sq₀ (by norm_num : (0 : ℝ) ≤ 1 / 182) (le_of_lt probabilidad_apt_positiva)).mp
    rw [probabilidad_apt_cuadrado]
    norm_num
  · apply (sq_le_sq₀ (le_of_lt probabilidad_apt_positiva) (by norm_num : (0 : ℝ) ≤ 1 / 181)).mp
    rw [probabilidad_apt_cuadrado]
    norm_num

private lemma potencia_inferior : (1 / 16 : ℝ) ≤ (180 / 181 : ℝ) ^ (497 : ℕ) := by norm_num
private lemma potencia_superior : (181 / 182 : ℝ) ^ (496 : ℕ) ≤ 1 / 10 := by norm_num

private lemma elegir_catorce : Nat.choose 511 14 = 793330096347923224835954625 := by
  have h := Nat.descFactorial_eq_factorial_mul_choose 511 14
  norm_num [Nat.descFactorial, Nat.factorial] at h
  omega

private lemma elegir_quince : Nat.choose 511 15 = 26285670525661189516231296575 := by
  have h := Nat.descFactorial_eq_factorial_mul_choose 511 15
  norm_num [Nat.descFactorial, Nat.factorial] at h
  omega

theorem peso_apt_catorce_inferior :
    (Nat.choose 511 14 : ℝ) * (1 / 182 : ℝ) ^ 14 * (1 / 16) ≤
      pesoBinomial 511 probabilidadPerfilAPT 14 := by
  have hp := probabilidad_apt_intervalo
  have hpow : (1 / 182 : ℝ) ^ 14 ≤ probabilidadPerfilAPT ^ 14 :=
    pow_le_pow_left₀ (by norm_num) hp.1 14
  have htail : (1 / 16 : ℝ) ≤ (1 - probabilidadPerfilAPT) ^ 497 :=
    potencia_inferior.trans (pow_le_pow_left₀ (by norm_num) (by linarith [hp.2]) 497)
  unfold pesoBinomial
  exact mul_le_mul (mul_le_mul_of_nonneg_left hpow (by positivity)) htail
    (by norm_num) (by positivity)

theorem peso_apt_quince_superior :
    pesoBinomial 511 probabilidadPerfilAPT 15 ≤
      (Nat.choose 511 15 : ℝ) * (1 / 181 : ℝ) ^ 15 * (1 / 10) := by
  have hp := probabilidad_apt_intervalo
  have hpow : probabilidadPerfilAPT ^ 15 ≤ (1 / 181 : ℝ) ^ 15 :=
    pow_le_pow_left₀ (le_of_lt probabilidad_apt_positiva) hp.2 15
  have htail : (1 - probabilidadPerfilAPT) ^ 496 ≤ (1 / 10 : ℝ) :=
    (pow_le_pow_left₀ (by linarith [hp.2]) (by linarith [hp.1]) 496).trans potencia_superior
  unfold pesoBinomial
  exact mul_le_mul (mul_le_mul_of_nonneg_left hpow (by positivity)) htail
    (pow_nonneg (by linarith [hp.2]) _) (by positivity)

theorem pesos_apt_contraccion (k : ℕ) (hk : 15 ≤ k) :
    pesoBinomial 511 probabilidadPerfilAPT (k + 1) ≤
      (1 / 5 : ℝ) * pesoBinomial 511 probabilidadPerfilAPT k := by
  have hp := probabilidad_apt_intervalo
  have hp0 := le_of_lt probabilidad_apt_positiva
  have hp1 : probabilidadPerfilAPT ≤ 1 := by linarith [hp.2]
  by_cases hkn : k < 511
  · have he := peso_binomial_recurrencia 511 k probabilidadPerfilAPT hkn
    have ha := peso_binomial_no_negativo 511 k probabilidadPerfilAPT hp0 hp1
    have hb := peso_binomial_no_negativo 511 (k + 1) probabilidadPerfilAPT hp0 hp1
    have hkp : (16 : ℝ) * (180 / 181) ≤ ((k + 1 : ℕ) : ℝ) * (1 - probabilidadPerfilAPT) :=
      mul_le_mul (by exact_mod_cast (show 16 ≤ k + 1 by omega)) (by linarith [hp.2])
        (by norm_num) (by positivity)
    have hnp : ((511 - k : ℕ) : ℝ) * probabilidadPerfilAPT ≤ (511 / 181 : ℝ) := by
      calc
        _ ≤ (511 : ℝ) * (1 / 181) := mul_le_mul (by exact_mod_cast Nat.sub_le 511 k)
          hp.2 hp0 (by norm_num)
        _ = _ := by norm_num
    have hl := mul_le_mul_of_nonneg_right hkp hb
    have hr := mul_le_mul_of_nonneg_right hnp ha
    nlinarith
  · rw [peso_binomial_fuera 511 (k + 1) probabilidadPerfilAPT (by omega)]
    exact mul_nonneg (by norm_num) (peso_binomial_no_negativo 511 k probabilidadPerfilAPT hp0 hp1)

theorem apt_quince_no_admisible :
    (1 / 1048576 : ℝ) < colaBinomial 511 probabilidadPerfilAPT 14 := by
  have hp := probabilidad_apt_intervalo
  have h := peso_le_cola_binomial 511 14 14 probabilidadPerfilAPT
    (le_of_lt probabilidad_apt_positiva) (by linarith [hp.2]) (le_refl _) (by norm_num)
  have hn : (1 / 1048576 : ℝ) < (Nat.choose 511 14 : ℝ) * (1 / 182 : ℝ) ^ 14 * (1 / 16) := by norm_num [elegir_catorce]
  exact hn.trans_le (peso_apt_catorce_inferior.trans h)

theorem apt_dieciseis_admisible :
    colaBinomial 511 probabilidadPerfilAPT 15 ≤ (1 / 1048576 : ℝ) := by
  have hp := probabilidad_apt_intervalo
  have h := cola_binomial_geometrica 511 15 probabilidadPerfilAPT (1 / 5)
    (le_of_lt probabilidad_apt_positiva) (by linarith [hp.2]) (by norm_num) (by norm_num)
    pesos_apt_contraccion
  have hu := div_le_div_of_nonneg_right peso_apt_quince_superior (by norm_num : (0 : ℝ) ≤ 1 - 1 / 5)
  have hn : ((Nat.choose 511 15 : ℝ) * (1 / 181 : ℝ) ^ 15 * (1 / 10)) / (1 - 1 / 5) ≤
      (1 / 1048576 : ℝ) := by norm_num [elegir_quince]
  exact h.trans (hu.trans hn)

theorem corte_apt_perfil_minimo (C : ℕ) (hC : 1 ≤ C) :
    colaBinomial 511 probabilidadPerfilAPT (C - 1) ≤ (1 / 1048576 : ℝ) ↔ 16 ≤ C := by
  have hp := probabilidad_apt_intervalo
  have hp0 := le_of_lt probabilidad_apt_positiva
  have hp1 : probabilidadPerfilAPT ≤ 1 := by linarith [hp.2]
  constructor
  · intro hc
    by_contra hn
    have ht := cola_binomial_antitona 511 probabilidadPerfilAPT hp0 hp1 (C - 1) 14 (by omega)
    exact (not_le_of_gt apt_quince_no_admisible) (ht.trans hc)
  · intro hc
    exact (cola_binomial_antitona 511 probabilidadPerfilAPT hp0 hp1 15 (C - 1) (by omega)).trans
      apt_dieciseis_admisible

end Nexus.Salud
