module

public import Nexus.N04.Solucion
public import Mathlib.Basic.Real.Basic
import Mathlib.Tactic

public section
namespace Nexus.N04

variable {K : Type*} [Field K]

/-- Lema A con el radio real del manuscrito y el mismo conjunto S en las dos ramas. -/
theorem acuerdo_correlacionado_real
    (L : Finset K) (a b : K → K) (e : ℕ) (θ : ℝ)
    (hN : 0 < L.card) (he : 0 < e) (hθ : 0 ≤ θ)
    (hmargin : (e : ℝ) - 1 < (1 - 3 * θ) * L.card) :
    ∃ E : Finset K, E.card ≤ L.card ∧
      ∀ β, β ∉ E → ∀ (S : Finset K) (h : Polynomial K),
        S ⊆ L → (1 - θ) * L.card ≤ (S.card : ℝ) → h.natDegree < e →
        Sobre S (fun x => a x + β * b x) h →
        ∃ A B : Polynomial K, A.natDegree < e ∧ B.natDegree < e ∧
          Sobre S a A ∧ Sobre S b B := by
  let t := ⌊θ * (L.card : ℝ)⌋₊
  have hprod : (0 : ℝ) ≤ θ * L.card := mul_nonneg hθ (by positivity)
  have ht : (t : ℝ) ≤ θ * L.card := Nat.floor_le hprod
  have hlt : ((e + 3 * t : ℕ) : ℝ) < ((L.card + 1 : ℕ) : ℝ) := by
    push_cast
    nlinarith
  have hnat : e + 3 * t < L.card + 1 := by exact_mod_cast hlt
  obtain ⟨E, hE, hgood⟩ := acuerdo_correlacionado L a b e t hN he (by omega)
  refine ⟨E, hE, ?_⟩
  intro β hβ S h hs hc hd ha
  apply hgood β hβ S h hs _ hd ha
  have hsub : ((L.card - S.card : ℕ) : ℝ) ≤ θ * L.card := by
    rw [Nat.cast_sub (Finset.card_le_card hs)]
    nlinarith
  have hfloor : L.card - S.card ≤ t := Nat.le_floor hsub
  omega

/-- Margen del lema A en todas las capas de composición con N=8T y θ=1/8. -/
theorem margen_capas_composicion (k j : ℕ) (hj : j ≤ k) :
    ((2 ^ (k - j) : ℕ) : ℝ) - 1 <
      (1 - 3 * (1 / 8 : ℝ)) * (2 ^ (k + 2 - j) : ℕ) := by
  have hexp : k + 2 - j = k - j + 2 := by omega
  rw [hexp, pow_add]
  push_cast
  norm_num
  nlinarith [show (0 : ℝ) ≤ 2 ^ (k - j) by positivity]

/-- Margen del lema A en todas las capas de traza con N=8T y θ=1/8. -/
theorem margen_capas_traza (k j : ℕ) (hj : j < k) :
    ((2 ^ (k - 1 - j) : ℕ) : ℝ) - 1 <
      (1 - 3 * (1 / 8 : ℝ)) * (2 ^ (k + 2 - j) : ℕ) := by
  have hexp : k + 2 - j = k - 1 - j + 3 := by omega
  rw [hexp, pow_add]
  push_cast
  norm_num
  nlinarith [show (0 : ℝ) ≤ 2 ^ (k - 1 - j) by positivity]

end Nexus.N04
