module

public import Nexus.Entropia.Minima
public import Mathlib.Probability.Distributions.Binomial
import Mathlib.Tactic

/-! # Pesos binomiales, cola y una cota geométrica finita. -/

public section
namespace Nexus.Salud

open scoped BigOperators

@[expose] noncomputable def pesoBinomial (n : ℕ) (p : ℝ) (k : ℕ) : ℝ :=
  (n.choose k : ℝ) * p ^ k * (1 - p) ^ (n - k)

@[expose] noncomputable def colaBinomial (n : ℕ) (p : ℝ) (t : ℕ) : ℝ :=
  ∑ k ∈ Finset.Ico t (n + 1), pesoBinomial n p k

theorem peso_binomial_no_negativo (n k : ℕ) (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    0 ≤ pesoBinomial n p k := by
  exact mul_nonneg (mul_nonneg (by positivity) (pow_nonneg hp0 k)) (pow_nonneg (by linarith) _)

theorem peso_binomial_fuera (n k : ℕ) (p : ℝ) (hk : n < k) : pesoBinomial n p k = 0 := by
  simp only [pesoBinomial, Nat.choose_eq_zero_of_lt hk, Nat.cast_zero, zero_mul]

theorem pesos_binomiales_suman_uno (n : ℕ) (p : ℝ) :
    (∑ k ∈ Finset.range (n + 1), pesoBinomial n p k) = 1 := by
  calc
    _ = ∑ k ∈ Finset.range (n + 1), p ^ k * (1 - p) ^ (n - k) * (n.choose k : ℝ) := by
      apply Finset.sum_congr rfl
      intro k _
      unfold pesoBinomial
      ring
    _ = (p + (1 - p)) ^ n := (add_pow p (1 - p) n).symm
    _ = 1 := by ring_nf

theorem peso_binomial_ley (n k : ℕ) (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    pesoBinomial n p k = (ProbabilityTheory.binomial n ⟨p, hp0, hp1⟩).real {k} := by
  exact (ProbabilityTheory.binomial_real_singleton n k ⟨p, hp0, hp1⟩).symm

theorem cola_binomial_ley_finita (n t : ℕ) (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    colaBinomial n p t =
      (ProbabilityTheory.binomial n ⟨p, hp0, hp1⟩).real (Finset.Ico t (n + 1)) := by
  unfold colaBinomial
  simp_rw [peso_binomial_ley n _ p hp0 hp1]
  exact MeasureTheory.sum_measureReal_singleton _

theorem cola_binomial_no_negativa (n t : ℕ) (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    0 ≤ colaBinomial n p t :=
  Finset.sum_nonneg (fun k _ => peso_binomial_no_negativo n k p hp0 hp1)

theorem cola_binomial_antitona (n : ℕ) (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (a b : ℕ) (hab : a ≤ b) : colaBinomial n p b ≤ colaBinomial n p a := by
  apply Finset.sum_le_sum_of_subset_of_nonneg
  · intro k hk
    simp only [Finset.mem_Ico] at hk ⊢
    omega
  · intro k _ _
    exact peso_binomial_no_negativo n k p hp0 hp1

theorem peso_le_cola_binomial (n k t : ℕ) (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (ht : t ≤ k) (hk : k ≤ n) : pesoBinomial n p k ≤ colaBinomial n p t := by
  exact Finset.single_le_sum (fun j _ => peso_binomial_no_negativo n j p hp0 hp1)
    (Finset.mem_Ico.mpr ⟨ht, by omega⟩)

theorem cola_binomial_le_uno (n t : ℕ) (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    colaBinomial n p t ≤ 1 := by
  have h := cola_binomial_antitona n p hp0 hp1 0 t (Nat.zero_le t)
  simpa only [colaBinomial, Nat.Ico_zero_eq_range, pesos_binomiales_suman_uno] using h

theorem peso_binomial_recurrencia (n k : ℕ) (p : ℝ) (hk : k < n) :
    ((k + 1 : ℕ) : ℝ) * (1 - p) * pesoBinomial n p (k + 1) =
      ((n - k : ℕ) : ℝ) * p * pesoBinomial n p k := by
  have hc : (n.choose (k + 1) : ℝ) * (k + 1 : ℕ) = (n.choose k : ℝ) * (n - k : ℕ) := by
    exact_mod_cast Nat.choose_succ_right_eq n k
  have hs : n - k = n - (k + 1) + 1 := by omega
  rw [hs] at hc
  unfold pesoBinomial
  rw [hs, pow_succ, pow_succ]
  linear_combination (p ^ k * p * (1 - p) ^ (n - (k + 1)) * (1 - p)) * hc

theorem suma_contraccion_geometrica (a : ℕ → ℝ) (r : ℝ) (hr0 : 0 ≤ r) (hr1 : r < 1)
    (ha0 : 0 ≤ a 0) (hrec : ∀ k, a (k + 1) ≤ r * a k) (m : ℕ) :
    (∑ k ∈ Finset.range m, a k) ≤ a 0 / (1 - r) := by
  induction m with
  | zero => simpa only [Finset.range_zero, Finset.sum_empty] using div_nonneg ha0 (by linarith : 0 ≤ 1 - r)
  | succ m ih =>
    rw [Finset.sum_range_succ']
    calc
      _ ≤ (∑ k ∈ Finset.range m, r * a k) + a 0 :=
        add_le_add (Finset.sum_le_sum (fun k _ => hrec k)) (le_refl _)
      _ = r * (∑ k ∈ Finset.range m, a k) + a 0 := by rw [Finset.mul_sum]
      _ ≤ r * (a 0 / (1 - r)) + a 0 := add_le_add (mul_le_mul_of_nonneg_left ih hr0) (le_refl _)
      _ = a 0 / (1 - r) := by field_simp; ring

theorem cola_binomial_geometrica (n t : ℕ) (p r : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (hr0 : 0 ≤ r) (hr1 : r < 1)
    (hrec : ∀ k, t ≤ k → pesoBinomial n p (k + 1) ≤ r * pesoBinomial n p k) :
    colaBinomial n p t ≤ pesoBinomial n p t / (1 - r) := by
  unfold colaBinomial
  rw [Finset.sum_Ico_eq_sum_range]
  apply suma_contraccion_geometrica (fun j => pesoBinomial n p (t + j)) r hr0 hr1
    (by simpa only [Nat.add_zero] using peso_binomial_no_negativo n t p hp0 hp1)
  intro j
  simpa only [Nat.add_assoc] using hrec (t + j) (by omega)

end Nexus.Salud
