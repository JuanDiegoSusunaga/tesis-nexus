module

public import Nexus.N02.Enunciado
import Mathlib.Tactic

public section
namespace Nexus.N02

variable {K : Type*} [Field K]

theorem cota : Enunciado K := by
  classical
  intro T L A D h hT hL hD hres hAdeg hDdeg hhdeg
  have hP : A - D * h ≠ 0 := by
    intro hz
    have heq : A = D * h := sub_eq_zero.mp hz
    apply hres
    rw [heq]
    exact EuclideanDomain.mod_eq_zero.mpr (dvd_mul_right D h)
  have hdeg : (A - D * h).natDegree ≤ 3 * T - 1 := by
    have hmul := Polynomial.natDegree_mul_le (p := D) (q := h)
    have hsub := Polynomial.natDegree_sub_le A (D * h)
    omega
  let S := L.filter (fun x => A.eval x / D.eval x = h.eval x)
  have hagree : S.card ≤ (A - D * h).natDegree := by
    apply Polynomial.card_le_degree_of_subset_roots
    intro x hx
    have hxL := (Finset.mem_filter.mp hx).1
    have heq := (div_eq_iff (hD x hxL)).mp (Finset.mem_filter.mp hx).2
    apply (Polynomial.mem_roots hP).mpr
    change (A - D * h).eval x = 0
    simp only [Polynomial.eval_sub, Polynomial.eval_mul]
    rw [heq, mul_comm (h.eval x) (D.eval x), sub_self]
  have hpartition := Finset.card_filter_add_card_filter_not
    (s := L) (fun x => A.eval x / D.eval x = h.eval x)
  have herrors : 5 * T + 1 ≤ errores L (fun x => A.eval x / D.eval x) h.eval := by
    change S.card + errores L (fun x => A.eval x / D.eval x) h.eval = L.card at hpartition
    omega
  have hcast : (5 * T + 1 : ℚ) ≤
      errores L (fun x => A.eval x / D.eval x) h.eval := by exact_mod_cast herrors
  unfold distancia
  rw [hL]
  push_cast
  exact div_le_div_of_nonneg_right hcast (by positivity)

end Nexus.N02
