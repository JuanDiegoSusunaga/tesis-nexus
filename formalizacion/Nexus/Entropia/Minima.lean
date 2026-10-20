module

public import Mathlib.Analysis.SpecialFunctions.Log.Base
public import Mathlib.Data.Finset.Lattice.Fold
import Mathlib.Tactic

/-!
# Min-entropía de una distribución finita

La masa máxima es alcanzable. La regla aditiva se prueba para el producto
independiente; no se impone a un flujo arbitrario ni califica una fuente física.
-/

public section
namespace Nexus.Entropia

open scoped BigOperators

structure Distribucion (A : Type*) [Fintype A] where
  masa : A → ℝ
  no_negativa : ∀ x, 0 ≤ masa x
  normalizada : ∑ x, masa x = 1

variable {A B : Type*} [Fintype A] [Nonempty A] [Fintype B] [Nonempty B]

@[expose] noncomputable def maximo (d : Distribucion A) : ℝ := by
  classical
  exact Finset.univ.sup' Finset.univ_nonempty d.masa

@[expose] noncomputable def minEntropia (d : Distribucion A) : ℝ :=
  -Real.logb 2 (maximo d)

theorem masa_le_maximo (d : Distribucion A) (x : A) : d.masa x ≤ maximo d := by
  classical
  exact Finset.le_sup' d.masa (Finset.mem_univ x)

theorem maximo_alcanzado (d : Distribucion A) : ∃ x, maximo d = d.masa x := by
  classical
  obtain ⟨x, _, hx⟩ := Finset.exists_mem_eq_sup' Finset.univ_nonempty d.masa
  exact ⟨x, hx⟩

omit [Nonempty A] in
theorem masa_le_uno (d : Distribucion A) (x : A) : d.masa x ≤ 1 := by
  classical
  have h := Finset.single_le_sum (fun y (_ : y ∈ (Finset.univ : Finset A)) => d.no_negativa y)
    (Finset.mem_univ x)
  simpa only [d.normalizada] using h

theorem maximo_positivo (d : Distribucion A) : 0 < maximo d := by
  classical
  by_contra hn
  have hsum : ∑ x, d.masa x ≤ 0 := Finset.sum_nonpos (fun x _ =>
    (masa_le_maximo d x).trans (le_of_not_gt hn))
  rw [d.normalizada] at hsum
  norm_num at hsum

theorem maximo_le_uno (d : Distribucion A) : maximo d ≤ 1 := by
  obtain ⟨x, hx⟩ := maximo_alcanzado d
  rw [hx]
  exact masa_le_uno d x

theorem min_entropia_no_negativa (d : Distribucion A) : 0 ≤ minEntropia d := by
  have h := Real.logb_le_logb_of_le (b := 2) (by norm_num) (maximo_positivo d) (maximo_le_uno d)
  simpa only [Real.logb_one, minEntropia, neg_nonneg] using h

theorem min_entropia_iff_masa (d : Distribucion A) (h : ℝ) :
    h ≤ minEntropia d ↔ maximo d ≤ (2 : ℝ) ^ (-h) := by
  constructor
  · intro hh
    apply (Real.logb_le_iff_le_rpow (by norm_num : (1 : ℝ) < 2) (maximo_positivo d)).mp
    change h ≤ -Real.logb 2 (maximo d) at hh
    linarith
  · intro hh
    have hl := (Real.logb_le_iff_le_rpow (by norm_num : (1 : ℝ) < 2) (maximo_positivo d)).mpr hh
    change h ≤ -Real.logb 2 (maximo d)
    linarith

theorem probabilidad_adivinacion (d : Distribucion A) :
    (∀ x, d.masa x ≤ (2 : ℝ) ^ (-minEntropia d)) ∧
      ∃ x, d.masa x = (2 : ℝ) ^ (-minEntropia d) := by
  have he : (2 : ℝ) ^ (-minEntropia d) = maximo d := by
    simp only [minEntropia, neg_neg]
    exact Real.rpow_logb (by norm_num) (by norm_num) (maximo_positivo d)
  rw [he]
  exact ⟨masa_le_maximo d, by obtain ⟨x, hx⟩ := maximo_alcanzado d; exact ⟨x, hx.symm⟩⟩

@[expose] noncomputable def producto (d : Distribucion A) (e : Distribucion B) : Distribucion (A × B) where
  masa x := d.masa x.1 * e.masa x.2
  no_negativa x := mul_nonneg (d.no_negativa x.1) (e.no_negativa x.2)
  normalizada := by
    classical
    simp only [Fintype.sum_prod_type, ← Finset.mul_sum, e.normalizada, mul_one, d.normalizada]

theorem maximo_producto (d : Distribucion A) (e : Distribucion B) :
    maximo (producto d e) = maximo d * maximo e := by
  apply le_antisymm
  · obtain ⟨⟨x, y⟩, hxy⟩ := maximo_alcanzado (producto d e)
    rw [hxy]
    exact mul_le_mul (masa_le_maximo d x) (masa_le_maximo e y) (e.no_negativa y)
      (le_of_lt (maximo_positivo d))
  · obtain ⟨x, hx⟩ := maximo_alcanzado d
    obtain ⟨y, hy⟩ := maximo_alcanzado e
    rw [hx, hy]
    exact masa_le_maximo (producto d e) (x, y)

theorem min_entropia_producto (d : Distribucion A) (e : Distribucion B) :
    minEntropia (producto d e) = minEntropia d + minEntropia e := by
  simp only [minEntropia, maximo_producto,
    Real.logb_mul (ne_of_gt (maximo_positivo d)) (ne_of_gt (maximo_positivo e)), neg_add]

@[expose] noncomputable def iid (d : Distribucion A) (n : ℕ) : Distribucion (Fin n → A) where
  masa xs := ∏ i, d.masa (xs i)
  no_negativa xs := Finset.prod_nonneg (fun i _ => d.no_negativa (xs i))
  normalizada := by
    rw [← Fintype.sum_pow, d.normalizada, one_pow]

theorem maximo_iid (d : Distribucion A) (n : ℕ) : maximo (iid d n) = maximo d ^ n := by
  classical
  apply le_antisymm
  · obtain ⟨xs, hx⟩ := maximo_alcanzado (iid d n)
    rw [hx]
    change (∏ i : Fin n, d.masa (xs i)) ≤ maximo d ^ n
    calc
      _ ≤ ∏ _i : Fin n, maximo d := Finset.prod_le_prod₀
        (fun i _ => d.no_negativa (xs i)) (fun i _ => masa_le_maximo d (xs i))
      _ = _ := by simp
  · obtain ⟨x, hx⟩ := maximo_alcanzado d
    have h := masa_le_maximo (iid d n) (fun _ => x)
    simpa only [iid, hx, Finset.prod_const, Finset.card_univ, Fintype.card_fin] using h

theorem min_entropia_iid (d : Distribucion A) (n : ℕ) :
    minEntropia (iid d n) = n * minEntropia d := by
  simp only [minEntropia, maximo_iid, Real.logb_pow, mul_neg]

@[expose] noncomputable def bitsCorrelacionados : Distribucion (Fin 2 × Fin 2) where
  masa x := if x.1 = x.2 then 1 / 2 else 0
  no_negativa x := by split_ifs <;> norm_num
  normalizada := by norm_num [Fintype.sum_prod_type, Fin.sum_univ_two]

theorem marginales_bits_correlacionados (b : Fin 2) :
    (∑ c : Fin 2, bitsCorrelacionados.masa (b, c)) = 1 / 2 ∧
      (∑ c : Fin 2, bitsCorrelacionados.masa (c, b)) = 1 / 2 := by
  fin_cases b <;> norm_num [bitsCorrelacionados, Fin.sum_univ_two]

theorem maximo_bits_correlacionados : maximo bitsCorrelacionados = 1 / 2 := by
  apply le_antisymm
  · obtain ⟨x, hx⟩ := maximo_alcanzado bitsCorrelacionados
    rw [hx]
    dsimp [bitsCorrelacionados]
    split_ifs <;> norm_num
  · have h := masa_le_maximo bitsCorrelacionados (0, 0)
    simpa only [bitsCorrelacionados, ite_true] using h

theorem min_entropia_bits_correlacionados : minEntropia bitsCorrelacionados = 1 := by
  rw [minEntropia, maximo_bits_correlacionados,
    show (1 / 2 : ℝ) = (2 : ℝ)⁻¹ by norm_num, Real.logb_inv,
    Real.logb_self_eq_one (by norm_num : (1 : ℝ) < 2)]
  norm_num

end Nexus.Entropia
