module

public import Nexus.Entropia.Minima
public import Mathlib.Analysis.SpecialFunctions.Log.NegMulLog
import Mathlib.Tactic

/-! # Shannon empírico: el soporte de n muestras tiene a lo sumo n valores. -/

public section
namespace Nexus.Entropia

open scoped BigOperators

variable {A : Type*} [Fintype A]

@[expose] noncomputable def shannon (d : Distribucion A) : ℝ :=
  (∑ x, Real.negMulLog (d.masa x)) / Real.log 2

theorem shannon_no_negativa (d : Distribucion A) : 0 ≤ shannon d := by
  exact div_nonneg (Finset.sum_nonneg (fun x _ =>
    Real.negMulLog_nonneg (d.no_negativa x) (masa_le_uno d x))) (by positivity)

theorem shannon_cota_soporte (d : Distribucion A) (s : Finset A) (hs : s.Nonempty)
    (hz : ∀ x, x ∉ s → d.masa x = 0) : shannon d ≤ Real.logb 2 s.card := by
  classical
  have hcard : (0 : ℝ) < s.card := by exact_mod_cast hs.card_pos
  have hmass : ∑ x ∈ s, d.masa x = 1 := by
    rw [← d.normalizada]
    exact Finset.sum_subset (Finset.subset_univ s) (fun x _ hx => hz x hx)
  have htotal : ∑ x, Real.negMulLog (d.masa x) = ∑ x ∈ s, Real.negMulLog (d.masa x) := by
    symm
    apply Finset.sum_subset (Finset.subset_univ s)
    intro x _ hx
    rw [hz x hx, Real.negMulLog_zero]
  have hterm : ∀ x ∈ s, (s.card : ℝ) * Real.negMulLog (d.masa x) +
      d.masa x * Real.negMulLog s.card ≤ 1 - s.card * d.masa x := by
    intro x _
    have h := Real.negMulLog_le_one_sub_self
      (mul_nonneg (le_of_lt hcard) (d.no_negativa x))
    rw [Real.negMulLog_mul] at h
    linarith
  have hsum := Finset.sum_le_sum hterm
  simp only [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.sum_mul,
    Finset.sum_sub_distrib, Finset.sum_const, nsmul_eq_mul, hmass,
    mul_one, one_mul] at hsum
  change (s.card : ℝ) * (∑ x ∈ s, Real.negMulLog (d.masa x)) +
    (-(s.card : ℝ) * Real.log s.card) ≤ (s.card : ℝ) - s.card at hsum
  have hent : (∑ x ∈ s, Real.negMulLog (d.masa x)) ≤ Real.log s.card := by
    nlinarith
  unfold shannon Real.logb
  rw [htotal]
  exact div_le_div_of_nonneg_right hent (by positivity)

variable [DecidableEq A]

@[expose] def soporteMuestra {n : ℕ} (m : Fin n → A) : Finset A := Finset.univ.image m

@[expose] noncomputable def masaEmpirica {n : ℕ} (m : Fin n → A) (x : A) : ℝ :=
  (∑ i, if m i = x then (1 : ℝ) else 0) / n

@[expose] noncomputable def empirica {n : ℕ} (m : Fin n → A) (hn : 0 < n) : Distribucion A where
  masa := masaEmpirica m
  no_negativa x := div_nonneg (Finset.sum_nonneg (fun i _ => by split_ifs <;> norm_num)) (Nat.cast_nonneg n)
  normalizada := by
    classical
    simp only [masaEmpirica]
    rw [← Finset.sum_div, Finset.sum_comm]
    have hinner : ∀ i : Fin n, (∑ x : A, if m i = x then (1 : ℝ) else 0) = 1 := by
      intro i
      simp
    simp_rw [hinner]
    simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul, mul_one]
    exact div_self (by exact_mod_cast (ne_of_gt hn))

omit [Fintype A] in
theorem soporte_muestra_no_vacio {n : ℕ} (m : Fin n → A) (hn : 0 < n) :
    (soporteMuestra m).Nonempty := by
  exact ⟨m ⟨0, hn⟩, Finset.mem_image.mpr ⟨⟨0, hn⟩, Finset.mem_univ _, rfl⟩⟩

theorem soporte_muestra_cota {n : ℕ} (m : Fin n → A) :
    (soporteMuestra m).card ≤ min n (Fintype.card A) := by
  apply le_min
  · exact (Finset.card_image_le).trans_eq (by simp)
  · exact Finset.card_le_univ _

omit [Fintype A] in
theorem masa_empirica_fuera {n : ℕ} (m : Fin n → A) (x : A) (hx : x ∉ soporteMuestra m) :
    masaEmpirica m x = 0 := by
  have hne : ∀ i, m i ≠ x := by
    intro i hi
    exact hx (Finset.mem_image.mpr ⟨i, Finset.mem_univ _, hi⟩)
  simp only [masaEmpirica, hne, ite_false, Finset.sum_const_zero, zero_div]

theorem shannon_empirica_cota {n : ℕ} (m : Fin n → A) (hn : 0 < n) :
    shannon (empirica m hn) ≤ Real.logb 2 (min n (Fintype.card A) : ℕ) := by
  have hs := soporte_muestra_no_vacio m hn
  apply (shannon_cota_soporte (empirica m hn) (soporteMuestra m) hs
    (fun x hx => masa_empirica_fuera m x hx)).trans
  apply Real.logb_le_logb_of_le (by norm_num)
  · exact_mod_cast hs.card_pos
  · exact_mod_cast soporte_muestra_cota m

theorem shannon_treinta_y_dos_bytes (m : Fin 32 → Fin 256) :
    shannon (empirica m (by norm_num)) ≤ 5 := by
  have h := shannon_empirica_cota m (by norm_num)
  have hl : Real.logb 2 (32 : ℝ) = 5 := by
    rw [show (32 : ℝ) = 2 ^ (5 : ℕ) by norm_num, Real.logb_pow]
    norm_num [Real.logb_self_eq_one (by norm_num : (1 : ℝ) < 2)]
  norm_num at h
  exact h.trans_eq hl

theorem umbral_shannon_inalcanzable (m : Fin 32 → Fin 256) :
    ¬ (7.5 : ℝ) ≤ shannon (empirica m (by norm_num)) := by
  have h := shannon_treinta_y_dos_bytes m
  linarith

end Nexus.Entropia
