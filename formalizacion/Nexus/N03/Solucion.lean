module

public import Nexus.N03.Enunciado
import Mathlib.Tactic

public section
namespace Nexus.N03

variable {K : Type*} [Field K]

/-- Dos candidatos de grado <T son iguales si T más sus errores no supera N. -/
theorem unicidad_conteo (L : Finset K) (u : K → K) (f g : Polynomial K) (T : ℕ)
    (hf : f.natDegree < T) (hg : g.natDegree < T)
    (hsize : T + errores L u f.eval + errores L u g.eval ≤ L.card) : f = g := by
  classical
  let E₁ := L.filter (fun x => u x ≠ f.eval x)
  let E₂ := L.filter (fun x => u x ≠ g.eval x)
  let S := L \ (E₁ ∪ E₂)
  have hsub : E₁ ∪ E₂ ⊆ L := Finset.union_subset
    (Finset.filter_subset _ _) (Finset.filter_subset _ _)
  have hcard := Finset.card_sdiff_add_card_eq_card hsub
  have hunion := Finset.card_union_le E₁ E₂
  have hsize' : T + E₁.card + E₂.card ≤ L.card := hsize
  apply Polynomial.eq_of_natDegree_lt_card_of_eval_eq' f g S
  · intro x hx
    have hxL := (Finset.mem_sdiff.mp hx).1
    have hxE := (Finset.mem_sdiff.mp hx).2
    have hxf : u x = f.eval x := by
      by_contra hne
      exact hxE (Finset.mem_union_left _ (Finset.mem_filter.mpr ⟨hxL, hne⟩))
    have hxg : u x = g.eval x := by
      by_contra hne
      exact hxE (Finset.mem_union_right _ (Finset.mem_filter.mpr ⟨hxL, hne⟩))
    exact hxf.symm.trans hxg
  · change S.card + _ = L.card at hcard
    omega

theorem unicidad : Enunciado K := by
  intro L u f g T δ hN hTN hf hg hsep huf hug
  have hNq : (0 : ℚ) < L.card := by exact_mod_cast hN
  have hsub : ((L.card - T + 1 : ℕ) : ℚ) = L.card - T + 1 := by
    rw [Nat.cast_add, Nat.cast_sub hTN]
    norm_num
  unfold distancia at huf hug
  have h₁ := (div_le_iff₀ hNq).mp huf
  have h₂ := (div_le_iff₀ hNq).mp hug
  have h₃ := (lt_div_iff₀ hNq).mp hsep
  rw [hsub] at h₃
  have hlt : ((T + errores L u f.eval + errores L u g.eval : ℕ) : ℚ) <
      ((L.card + 1 : ℕ) : ℚ) := by
    push_cast
    linarith
  have hnat : T + errores L u f.eval + errores L u g.eval < L.card + 1 := by
    exact_mod_cast hlt
  exact unicidad_conteo L u f g T hf hg (by omega)

end Nexus.N03
