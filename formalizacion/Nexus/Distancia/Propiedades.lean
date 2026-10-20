module

public import Nexus.Distancia
import Mathlib.Tactic

public section
namespace Nexus

variable {K : Type*}

theorem distancia_no_negativa (L : Finset K) (u v : K → K) : 0 ≤ distancia L u v := by
  unfold distancia
  positivity

theorem distancia_simetrica (L : Finset K) (u v : K → K) :
    distancia L u v = distancia L v u := by
  classical
  simp only [distancia, errores, ne_comm]

theorem errores_triangular (L : Finset K) (u v w : K → K) :
    errores L u w ≤ errores L u v + errores L v w := by
  classical
  have hsub : L.filter (fun x => u x ≠ w x) ⊆
      L.filter (fun x => u x ≠ v x) ∪ L.filter (fun x => v x ≠ w x) := by
    intro x hx
    obtain ⟨hxL, hx⟩ := Finset.mem_filter.mp hx
    by_cases huv : u x = v x
    · exact Finset.mem_union_right _ (Finset.mem_filter.mpr ⟨hxL, by simpa [huv] using hx⟩)
    · exact Finset.mem_union_left _ (Finset.mem_filter.mpr ⟨hxL, huv⟩)
  exact (Finset.card_le_card hsub).trans (Finset.card_union_le _ _)

theorem distancia_triangular (L : Finset K) (u v w : K → K) :
    distancia L u w ≤ distancia L u v + distancia L v w := by
  have h : (errores L u w : ℚ) ≤ errores L u v + errores L v w := by
    exact_mod_cast errores_triangular L u v w
  simpa only [distancia, add_div] using
    div_le_div_of_nonneg_right h (show (0 : ℚ) ≤ L.card by positivity)

/-- Una reindexación inyectiva dentro de L no aumenta las discrepancias. -/
theorem errores_reindexacion (L : Finset K) (u v : K → K) (r : K → K)
    (hrL : ∀ x ∈ L, r x ∈ L) (hr : Set.InjOn r L) :
    errores L (u ∘ r) (v ∘ r) ≤ errores L u v := by
  classical
  apply Finset.card_le_card_of_injOn r
  · intro x hx
    obtain ⟨hxL, hx⟩ := Finset.mem_filter.mp hx
    exact Finset.mem_filter.mpr ⟨hrL x hxL, hx⟩
  · intro x hx y hy hxy
    exact hr (Finset.mem_filter.mp hx).1 (Finset.mem_filter.mp hy).1 hxy

end Nexus
