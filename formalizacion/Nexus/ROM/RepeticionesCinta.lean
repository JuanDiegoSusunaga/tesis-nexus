module

public import Nexus.N06.Experimento
import Mathlib.Tactic

/-!
# Error por repetir estados en una cinta uniforme

La cinta ideal se compara con un conjunto inicial de estados prohibidos.
El evento incluye también su último valor, aunque no llegue a utilizarse
como siguiente dirección; la cota es deliberadamente conservadora.
-/

public section
namespace Nexus.ROM.RepeticionesCinta

open Nexus.N06

variable {A : Type} [DecidableEq A]

@[expose] def Limpia : {n : ℕ} → Finset A → Retos A n → Prop
  | 0, _, _ => True
  | _ + 1, T, xs => xs.1 ∉ T ∧ Limpia (insert xs.1 T) xs.2

attribute [local instance] Classical.propDecidable

variable [Fintype A] [Nonempty A]

@[expose] noncomputable def probabilidad (T : Finset A) (n : ℕ) : ℚ :=
  promedio (fun xs : Retos A n => if ¬ Limpia T xs then 1 else 0)

theorem no_negativa (T : Finset A) (n : ℕ) : 0 ≤ probabilidad T n := by
  rw [← promedio_constante (K := Retos A n) 0]
  exact promedio_monotono _ _ (fun _ => by split_ifs <;> norm_num)

theorem acotada_uno (T : Finset A) (n : ℕ) : probabilidad T n ≤ 1 := by
  rw [← promedio_constante (K := Retos A n) 1]
  exact promedio_monotono _ _ (fun _ => by split_ifs <;> norm_num)

theorem recurrencia (T : Finset A) (n : ℕ) :
    probabilidad T (n + 1) = promedio (fun a : A => if a ∈ T then 1 else probabilidad (insert a T) n) := by
  unfold probabilidad
  change (promedio (fun xs : A × Retos A n => if ¬ Limpia (n := n + 1) T xs then (1 : ℚ) else 0)) = _
  rw [promedio_producto]
  congr 1
  funext a
  by_cases ha : a ∈ T
  · simp only [Limpia, ha, not_true_eq_false, false_and, not_false_eq_true, ite_true]
    exact promedio_constante 1
  · simp only [Limpia, ha, not_false_eq_true, true_and, ite_false]

theorem cota_union (T : Finset A) (n : ℕ) :
    probabilidad T n ≤ ((n * (T.card + n) : ℕ) : ℚ) / Fintype.card A := by
  induction n generalizing T with
  | zero => simp [probabilidad, Limpia, promedio_constante]
  | succ n ih =>
    let C : ℚ := ((n * (T.card + 1 + n) : ℕ) : ℚ) / Fintype.card A
    have hC : 0 ≤ C := by dsimp [C]; positivity
    have ht (a : A) : probabilidad (insert a T) n ≤ C := by
      apply (ih (insert a T)).trans
      apply div_le_div_of_nonneg_right _ (by positivity)
      exact_mod_cast Nat.mul_le_mul_left n
        (Nat.add_le_add_right (Finset.card_insert_le a T) n)
    have hp (a : A) : (if a ∈ T then (1 : ℚ) else probabilidad (insert a T) n) ≤
        (if a ∈ T then 1 else 0) + C := by
      by_cases ha : a ∈ T
      · simp only [ha, ite_true]; linarith
      · simpa only [ha, ite_false, zero_add] using ht a
    rw [recurrencia]
    calc
      _ ≤ promedio (fun a : A => (if a ∈ T then (1 : ℚ) else 0) + C) := promedio_monotono _ _ hp
      _ = (T.card : ℚ) / Fintype.card A + C := by
        rw [promedio_suma, promedio_constante, promedio_indicador]
      _ ≤ _ := by
        dsimp only [C]
        rw [← add_div]
        apply div_le_div_of_nonneg_right _ (by positivity)
        push_cast
        nlinarith [show (0 : ℚ) ≤ n by positivity]

theorem cota_minimo (T : Finset A) (n : ℕ) :
    probabilidad T n ≤ min 1 (((n * (T.card + n) : ℕ) : ℚ) / Fintype.card A) :=
  le_min (acotada_uno T n) (cota_union T n)

end Nexus.ROM.RepeticionesCinta
