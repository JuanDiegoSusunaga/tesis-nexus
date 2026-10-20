module

public import Nexus.N04.Plegado
import Mathlib.Tactic

/-!
# Geometría de las parejas de una torre FRI

Se trabaja con dominios finitos de un campo y representantes r(y) tales
que r(y)²=y. Las dos mitades son disjuntas cuando r(y)≠0 y 2≠0.
La construcción no recibe como premisa el conteo de las fibras.
-/

public section
namespace Nexus.FRI

variable {K : Type*} [Field K]

@[expose] noncomputable def elevar (r : K → K) (S : Finset K) : Finset K := by
  classical
  exact S.image r ∪ S.image (fun y => -r y)

@[expose] noncomputable def cuadrados (S : Finset K) : Finset K := by
  classical
  exact S.image (fun x => x ^ 2)

/-- En un campo, dos raíces del mismo cuadrado solo pueden diferir por el signo. -/
theorem raices_opuestas (x y : K) (h : x ^ 2 = y ^ 2) : x = y ∨ x = -y := by
  have hz : (x - y) * (x + y) = 0 := by linear_combination h
  rcases mul_eq_zero.mp hz with hminus | hplus
  · exact Or.inl (sub_eq_zero.mp hminus)
  · exact Or.inr (eq_neg_of_add_eq_zero_left hplus)

/-- Cambiar el representante de una pareja no cambia las partes par e impar. -/
theorem partes_independientes (u : K → K) (x y : K) (h : x ^ 2 = y ^ 2) :
    (u x + u (-x)) / 2 = (u y + u (-y)) / 2 ∧
      (u x - u (-x)) / (2 * x) = (u y - u (-y)) / (2 * y) := by
  rcases raices_opuestas x y h with hxy | hxy
  · simp only [hxy, and_self]
  · rw [hxy]
    simp only [neg_neg, mul_neg, sub_eq_add_neg,
      div_eq_mul_inv, inv_neg]
    constructor <;> ring

theorem elevar_mono (r : K → K) {S T : Finset K} (h : S ⊆ T) :
    elevar r S ⊆ elevar r T := by
  classical
  exact Finset.union_subset_union (Finset.image_subset_image h) (Finset.image_subset_image h)

theorem raiz_inyectiva (S : Finset K) (r : K → K)
    (hr : ∀ y ∈ S, (r y) ^ 2 = y) : Set.InjOn r S := by
  intro x hx y hy hxy
  calc
    x = (r x) ^ 2 := (hr x hx).symm
    _ = (r y) ^ 2 := congrArg (fun z : K => z ^ 2) hxy
    _ = y := hr y hy

/-- Las mitades positiva y negativa no se solapan. -/
theorem mitades_disjuntas [DecidableEq K] (S : Finset K) (r : K → K)
    (hr : ∀ y ∈ S, (r y) ^ 2 = y) (hn : ∀ y ∈ S, r y ≠ 0)
    (h2 : (2 : K) ≠ 0) : Disjoint (S.image r) (S.image (fun y => -r y)) := by
  classical
  apply Finset.disjoint_left.mpr
  intro z hz hz'
  obtain ⟨x, hx, rfl⟩ := Finset.mem_image.mp hz
  obtain ⟨y, hy, heq⟩ := Finset.mem_image.mp hz'
  have hxy : x = y := by
    calc
      x = (r x) ^ 2 := (hr x hx).symm
      _ = (r y) ^ 2 := by rw [← heq, neg_sq]
      _ = y := hr y hy
  subst y
  have hz : 2 * r x = 0 := by linear_combination -heq
  exact hn x hx ((mul_eq_zero.mp hz).resolve_left h2)

theorem cardinal_elevar (S : Finset K) (r : K → K)
    (hr : ∀ y ∈ S, (r y) ^ 2 = y) (hn : ∀ y ∈ S, r y ≠ 0)
    (h2 : (2 : K) ≠ 0) : (elevar r S).card = 2 * S.card := by
  classical
  have hi := raiz_inyectiva S r hr
  have hni : Set.InjOn (fun y => -r y) S := by
    intro x hx y hy hxy
    exact hi hx hy (neg_injective hxy)
  rw [elevar, Finset.card_union_of_disjoint (mitades_disjuntas S r hr hn h2),
    Finset.card_image_of_injOn hi, Finset.card_image_of_injOn hni]
  omega

theorem cuadrados_elevar (S : Finset K) (r : K → K)
    (hr : ∀ y ∈ S, (r y) ^ 2 = y) : cuadrados (elevar r S) = S := by
  classical
  ext y
  constructor
  · intro hy
    obtain ⟨x, hx, rfl⟩ := Finset.mem_image.mp hy
    rcases Finset.mem_union.mp hx with hx | hx
    · obtain ⟨z, hz, rfl⟩ := Finset.mem_image.mp hx
      simpa only [hr z hz] using hz
    · obtain ⟨z, hz, rfl⟩ := Finset.mem_image.mp hx
      simpa only [neg_sq, hr z hz] using hz
  · intro hy
    apply Finset.mem_image.mpr
    exact ⟨r y, Finset.mem_union_left _ (Finset.mem_image.mpr ⟨y, hy, rfl⟩), hr y hy⟩

/-- Todo punto se recupera de alguna de las dos raíces de su cuadrado. -/
theorem subconjunto_elevar (W S : Finset K) (r : K → K)
    (hWS : cuadrados W ⊆ S) (hr : ∀ y ∈ S, (r y) ^ 2 = y) :
    W ⊆ elevar r (cuadrados W) := by
  classical
  intro x hx
  have hx2 : x ^ 2 ∈ cuadrados W := Finset.mem_image.mpr ⟨x, hx, rfl⟩
  have hsq : x ^ 2 = (r (x ^ 2)) ^ 2 := (hr _ (hWS hx2)).symm
  rcases raices_opuestas x (r (x ^ 2)) hsq with heq | heq
  · exact Finset.mem_union_left _ (Finset.mem_image.mpr ⟨x ^ 2, hx2, heq.symm⟩)
  · exact Finset.mem_union_right _ (Finset.mem_image.mpr ⟨x ^ 2, hx2, heq.symm⟩)

/-- El cuadrado identifica como máximo dos puntos; se deriva por inclusión. -/
theorem cardinal_cuadrados (W S : Finset K) (r : K → K)
    (hWS : cuadrados W ⊆ S) (hr : ∀ y ∈ S, (r y) ^ 2 = y)
    (hn : ∀ y ∈ S, r y ≠ 0) (h2 : (2 : K) ≠ 0) :
    W.card ≤ 2 * (cuadrados W).card := by
  have hcard := Finset.card_le_card (subconjunto_elevar W S r hWS hr)
  rw [cardinal_elevar _ r (fun y hy => hr y (hWS hy))
    (fun y hy => hn y (hWS hy)) h2] at hcard
  exact hcard

/-- La densidad de cualquier subconjunto no disminuye al pasar a los cuadrados. -/
theorem densidad_cuadrados (W S : Finset K) (r : K → K) (ρ : ℝ)
    (hWS : cuadrados W ⊆ S) (hr : ∀ y ∈ S, (r y) ^ 2 = y)
    (hn : ∀ y ∈ S, r y ≠ 0) (h2 : (2 : K) ≠ 0)
    (hd : ρ * (elevar r S).card ≤ (W.card : ℝ)) :
    ρ * S.card ≤ ((cuadrados W).card : ℝ) := by
  rw [cardinal_elevar S r hr hn h2] at hd
  have hc : (W.card : ℝ) ≤ 2 * (cuadrados W).card := by
    exact_mod_cast cardinal_cuadrados W S r hWS hr hn h2
  push_cast at hd
  nlinarith

end Nexus.FRI
