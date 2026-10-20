module

public import Nexus.Cripto.Probabilidad
import Mathlib.Tactic

public section
namespace Nexus.Cripto.Variacion

open scoped BigOperators

/-- Ley finita racional: permite certificar exactamente los redondeos del manuscrito. -/
structure Ley (A : Type) [Fintype A] where
  peso : A → ℚ
  noNegativo : ∀ x, 0 ≤ peso x
  normalizada : ∑ x, peso x = 1

variable {A B : Type} [Fintype A] [Fintype B]

@[expose] def distancia (p q : Ley A) : ℚ := (∑ x, |p.peso x - q.peso x|) / 2

@[expose] noncomputable def evento (p : Ley A) (E : A → Prop) : ℚ := by
  classical
  exact ∑ x, if E x then p.peso x else 0

theorem distancia_no_negativa (p q : Ley A) : 0 ≤ distancia p q := by
  unfold distancia
  positivity

theorem distancia_simetrica (p q : Ley A) : distancia p q = distancia q p := by
  simp only [distancia, abs_sub_comm]

theorem distancia_reflexiva (p : Ley A) : distancia p p = 0 := by simp [distancia]

theorem evento_complemento (p : Ley A) (E : A → Prop) :
    evento p E + evento p (fun x => ¬ E x) = 1 := by
  classical
  unfold evento
  rw [← Finset.sum_add_distrib, ← p.normalizada]
  apply Finset.sum_congr rfl
  intro x _
  by_cases h : E x <;> simp [h]

theorem diferencia_evento_acotada (p q : Ley A) (E : A → Prop) :
    |evento p E - evento q E| ≤ distancia p q := by
  classical
  let u := fun x => if E x then p.peso x - q.peso x else 0
  let v := fun x => if E x then 0 else p.peso x - q.peso x
  have hu : evento p E - evento q E = ∑ x, u x := by
    rw [evento, evento, ← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro x _
    by_cases h : E x <;> simp [u, h]
  have hv : evento p (fun x => ¬ E x) - evento q (fun x => ¬ E x) = ∑ x, v x := by
    rw [evento, evento, ← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro x _
    by_cases h : E x <;> simp [v, h]
  have hc : (∑ x, v x) = -(∑ x, u x) := by
    have hp := evento_complemento p E
    have hq := evento_complemento q E
    rw [← hu, ← hv]
    linarith
  have hsplit : (∑ x, |u x|) + (∑ x, |v x|) = ∑ x, |p.peso x - q.peso x| := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro x _
    by_cases h : E x <;> simp [u, v, h]
  have h1 := Finset.abs_sum_le_sum_abs (s := Finset.univ) (f := u)
  have h2 := Finset.abs_sum_le_sum_abs (s := Finset.univ) (f := v)
  rw [hc, abs_neg] at h2
  rw [hu]
  unfold distancia
  linarith

@[expose] noncomputable def producto (p : Ley A) (q : Ley B) : Ley (A × B) where
  peso x := p.peso x.1 * q.peso x.2
  noNegativo x := mul_nonneg (p.noNegativo _) (q.noNegativo _)
  normalizada := by
    rw [Fintype.sum_prod_type]
    simp only [← Finset.mul_sum, q.normalizada, mul_one, p.normalizada]

theorem producto_distancia (p q : Ley A) (r s : Ley B) :
    distancia (producto p r) (producto q s) ≤ distancia p q + distancia r s := by
  have hpoint (a : A) (b : B) :
      |p.peso a * r.peso b - q.peso a * s.peso b| ≤
        p.peso a * |r.peso b - s.peso b| + |p.peso a - q.peso a| * s.peso b := by
    calc
      _ = |p.peso a * (r.peso b - s.peso b) + (p.peso a - q.peso a) * s.peso b| := by ring_nf
      _ ≤ |p.peso a * (r.peso b - s.peso b)| + |(p.peso a - q.peso a) * s.peso b| := abs_add_le _ _
      _ = _ := by rw [abs_mul, abs_mul, abs_of_nonneg (p.noNegativo a), abs_of_nonneg (s.noNegativo b)]
  have hsum := Finset.sum_le_sum (fun a (_ : a ∈ (Finset.univ : Finset A)) =>
    Finset.sum_le_sum (fun b (_ : b ∈ (Finset.univ : Finset B)) => hpoint a b))
  simp only [Finset.sum_add_distrib, ← Finset.mul_sum, s.normalizada, mul_one,
    ← Finset.sum_mul, p.normalizada, one_mul] at hsum
  unfold distancia
  change (∑ x : A × B, |p.peso x.1 * r.peso x.2 - q.peso x.1 * s.peso x.2|) / 2 ≤ _
  rw [Fintype.sum_prod_type]
  linarith

@[expose] def Espacio (A : Type) : ℕ → Type
  | 0 => Unit
  | m + 1 => A × Espacio A m

instance fintypeEspacio (A : Type) [Fintype A] : (m : ℕ) → Fintype (Espacio A m)
  | 0 => inferInstanceAs (Fintype Unit)
  | m + 1 => by
      haveI := fintypeEspacio A m
      exact inferInstanceAs (Fintype (A × Espacio A m))

@[expose] noncomputable def repite (p : Ley A) : (m : ℕ) → Ley (Espacio A m)
  | 0 => ⟨fun _ => 1, fun _ => by norm_num, by change (∑ _ : Unit, (1 : ℚ)) = 1; simp⟩
  | m + 1 => producto p (repite p m)

theorem producto_independiente_cota (p q : Ley A) (m : ℕ) :
    distancia (repite p m) (repite q m) ≤ (m : ℚ) * distancia p q := by
  induction m with
  | zero => simp [repite, distancia, Espacio]
  | succ m ih =>
    change distancia (producto p (repite p m)) (producto q (repite q m)) ≤ _
    have h := producto_distancia p q (repite p m) (repite q m)
    push_cast
    nlinarith

theorem evento_producto_cota (p q : Ley A) (m : ℕ) (E : Espacio A m → Prop) :
    |evento (repite p m) E - evento (repite q m) E| ≤ (m : ℚ) * distancia p q :=
  (diferencia_evento_acotada _ _ E).trans (producto_independiente_cota p q m)

end Nexus.Cripto.Variacion
