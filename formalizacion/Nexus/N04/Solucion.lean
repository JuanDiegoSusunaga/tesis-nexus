module

public import Nexus.N04.Enunciado
import Mathlib.Algebra.Polynomial.Eval.SMul
import Mathlib.Tactic

public section
namespace Nexus.N04

variable {K : Type*} [Field K]

omit [Field K] in
/-- Tres conjuntos con a lo sumo t omisiones tienen al menos |L|-3t puntos comunes. -/
theorem interseccion_triple [DecidableEq K] (L S S₀ S₁ : Finset K) (e t : ℕ)
    (hS : S ⊆ L) (h₀ : S₀ ⊆ L) (h₁ : S₁ ⊆ L)
    (hc : L.card ≤ S.card + t) (hc₀ : L.card ≤ S₀.card + t)
    (hc₁ : L.card ≤ S₁.card + t) (hmargin : e + 3 * t ≤ L.card) :
    e ≤ ((S ∩ S₀) ∩ S₁).card := by
  classical
  have hi₀ := Finset.card_inter_add_card_union S S₀
  have hu₀ := Finset.card_le_card (Finset.union_subset hS h₀)
  have hi₁ := Finset.card_inter_add_card_union (S ∩ S₀) S₁
  have hu₁ : ((S ∩ S₀) ∪ S₁).card ≤ L.card := Finset.card_le_card
    (Finset.union_subset ((Finset.inter_subset_left).trans hS) h₁)
  omega

/-- Lema A: salvo |L| retos, se recuperan ambos polinomios sobre el mismo S. -/
theorem acuerdo_correlacionado : Enunciado K := by
  classical
  intro L a b e t hN he hmargin
  let R := fun β : K => ∃ (S : Finset K) (h : Polynomial K),
    S ⊆ L ∧ L.card ≤ S.card + t ∧ h.natDegree < e ∧
      Sobre S (fun x => a x + β * b x) h
  by_cases htwo : ∃ β₀ β₁, β₀ ≠ β₁ ∧ R β₀ ∧ R β₁
  · obtain ⟨β₀, β₁, hne, ⟨S₀, h₀, hs₀, hc₀, hd₀, ha₀⟩,
      ⟨S₁, h₁, hs₁, hc₁, hd₁, ha₁⟩⟩ := htwo
    have hdelta : β₁ - β₀ ≠ 0 := sub_ne_zero.mpr hne.symm
    let B : Polynomial K := (β₁ - β₀)⁻¹ • (h₁ - h₀)
    let A : Polynomial K := h₀ - β₀ • B
    have hBd : B.natDegree < e := by
      have hsub := Polynomial.natDegree_sub_le h₁ h₀
      have hsmul := Polynomial.natDegree_smul_le (β₁ - β₀)⁻¹ (h₁ - h₀)
      change ((β₁ - β₀)⁻¹ • (h₁ - h₀)).natDegree < e
      omega
    have hAd : A.natDegree < e := by
      have hsub := Polynomial.natDegree_sub_le h₀ (β₀ • B)
      have hsmul := Polynomial.natDegree_smul_le β₀ B
      change (h₀ - β₀ • B).natDegree < e
      omega
    have hAB : ∀ x ∈ S₀ ∩ S₁, a x = A.eval x ∧ b x = B.eval x := by
      intro x hx
      have hzero := ha₀ x (Finset.mem_inter.mp hx).1
      have hone := ha₁ x (Finset.mem_inter.mp hx).2
      have hb : b x = B.eval x := by
        dsimp [B]
        simp only [Polynomial.eval_smul, Polynomial.eval_sub, smul_eq_mul]
        field_simp
        linear_combination hone - hzero
      refine ⟨?_, hb⟩
      dsimp [A]
      simp only [Polynomial.eval_sub, Polynomial.eval_smul, smul_eq_mul]
      rw [← hb]
      linear_combination hzero
    let E := (L.filter (fun x => b x ≠ B.eval x)).image
      (fun x => (A.eval x - a x) / (b x - B.eval x))
    refine ⟨E, (Finset.card_image_le).trans (Finset.card_filter_le _ _), ?_⟩
    intro β hβ S h hs hc hd ha
    have hpoly : h = A + β • B := by
      apply Polynomial.eq_of_natDegree_lt_card_of_eval_eq' h (A + β • B) ((S ∩ S₀) ∩ S₁)
      · intro x hx
        have hxS := (Finset.mem_inter.mp (Finset.mem_inter.mp hx).1).1
        have hx₀ := (Finset.mem_inter.mp (Finset.mem_inter.mp hx).1).2
        have hx₁ := (Finset.mem_inter.mp hx).2
        obtain ⟨hax, hbx⟩ := hAB x (Finset.mem_inter.mpr ⟨hx₀, hx₁⟩)
        simpa only [Polynomial.eval_add, Polynomial.eval_smul, smul_eq_mul, ← hax, ← hbx]
          using (ha x hxS).symm
      · have hsum := Polynomial.natDegree_add_le A (β • B)
        have hsmul := Polynomial.natDegree_smul_le β B
        have hcard := interseccion_triple L S S₀ S₁ e t hs hs₀ hs₁ hc hc₀ hc₁ hmargin
        omega
    refine ⟨A, B, hAd, hBd, ?_, ?_⟩
    · intro x hx
      have hax := ha x hx
      rw [hpoly] at hax
      simp only [Polynomial.eval_add, Polynomial.eval_smul, smul_eq_mul] at hax
      have hbx : b x = B.eval x := by
        by_contra hbn
        apply hβ
        apply Finset.mem_image.mpr
        refine ⟨x, Finset.mem_filter.mpr ⟨hs hx, hbn⟩, ?_⟩
        apply (div_eq_iff (sub_ne_zero.mpr hbn)).mpr
        linear_combination -hax
      rw [hbx] at hax
      exact add_right_cancel hax
    · intro x hx
      have hax := ha x hx
      rw [hpoly] at hax
      simp only [Polynomial.eval_add, Polynomial.eval_smul, smul_eq_mul] at hax
      by_contra hbn
      apply hβ
      apply Finset.mem_image.mpr
      refine ⟨x, Finset.mem_filter.mpr ⟨hs hx, hbn⟩, ?_⟩
      apply (div_eq_iff (sub_ne_zero.mpr hbn)).mpr
      linear_combination -hax
  · by_cases hone : ∃ β₀, R β₀
    · obtain ⟨β₀, hr₀⟩ := hone
      refine ⟨{β₀}, by simpa using hN, ?_⟩
      intro β hβ S h hs hc hd ha
      have hne : β₀ ≠ β := by simpa [ne_comm] using hβ
      exact (htwo ⟨β₀, β, hne, hr₀, ⟨S, h, hs, hc, hd, ha⟩⟩).elim
    · refine ⟨∅, by simp, ?_⟩
      intro β _ S h hs hc hd ha
      exact (hone ⟨β, S, h, hs, hc, hd, ha⟩).elim

/-- Conversión de la desigualdad estricta de la tesis a la cota entera. -/
theorem acuerdo_correlacionado_radio : EnunciadoRadio K := by
  intro L a b e θ hN he hθ hmargin
  let t := ⌊θ * (L.card : ℚ)⌋₊
  have hprod : (0 : ℚ) ≤ θ * L.card := mul_nonneg hθ (by positivity)
  have ht : (t : ℚ) ≤ θ * L.card := Nat.floor_le hprod
  have hlt : ((e + 3 * t : ℕ) : ℚ) < ((L.card + 1 : ℕ) : ℚ) := by
    push_cast
    nlinarith
  have hnat : e + 3 * t < L.card + 1 := by exact_mod_cast hlt
  obtain ⟨E, hE, hgood⟩ := acuerdo_correlacionado L a b e t hN he (by omega)
  refine ⟨E, hE, ?_⟩
  intro β hβ S h hs hc hd ha
  apply hgood β hβ S h hs _ hd ha
  have hsub : ((L.card - S.card : ℕ) : ℚ) ≤ θ * L.card := by
    rw [Nat.cast_sub (Finset.card_le_card hs)]
    nlinarith
  have hfloor : L.card - S.card ≤ t := Nat.le_floor hsub
  omega

end Nexus.N04
