module

public import Mathlib.Data.Fintype.BigOperators
public import Mathlib.Data.Fintype.Prod
public import Mathlib.Data.Rat.Defs
import Mathlib.Tactic

/-!
# Retos uniformes frescos y riesgo adaptativo finito

El estado puede contener toda la historia y las decisiones del adversario.
El conjunto excepcional recibe ese estado antes del reto actual. Las medias
son probabilidades racionales exactas de un experimento finito, sin hashes.
-/

public section
namespace Nexus.N06

open scoped BigOperators
universe u
variable {K S : Type*} [Fintype K]

@[expose] noncomputable def promedio (f : K → ℚ) : ℚ :=
  (∑ x, f x) / Fintype.card K

theorem promedio_constante [Nonempty K] (c : ℚ) : promedio (fun _ : K => c) = c := by
  have h : (Fintype.card K : ℚ) ≠ 0 := by exact_mod_cast Fintype.card_ne_zero
  simp [promedio, h]

theorem promedio_monotono (f g : K → ℚ) (h : ∀ x, f x ≤ g x) :
    promedio f ≤ promedio g := by
  exact div_le_div_of_nonneg_right (Finset.sum_le_sum (fun x _ => h x)) (by positivity)

theorem promedio_suma (f g : K → ℚ) :
    promedio (fun x => f x + g x) = promedio f + promedio g := by
  simp only [promedio, Finset.sum_add_distrib, add_div]

theorem promedio_indicador [DecidableEq K] (E : Finset K) :
    promedio (fun x => if x ∈ E then 1 else 0) = (E.card : ℚ) / Fintype.card K := by
  classical
  simp [promedio]

theorem promedio_producto {L : Type*} [Fintype L] (f : K × L → ℚ) :
    promedio f = promedio (fun x => promedio (fun y => f (x, y))) := by
  simp only [promedio, Fintype.sum_prod_type, Fintype.card_prod, Nat.cast_mul]
  rw [← Finset.sum_div, div_div]
  ring

/-- Espacio de n retos: cada coordenada se sortea uniformemente. -/
@[expose] def Retos (K : Type u) : ℕ → Type u
  | 0 => PUnit
  | n + 1 => K × Retos K n

instance fintypeRetos (n : ℕ) : Fintype (Retos K n) := by
  induction n with
  | zero => exact inferInstanceAs (Fintype PUnit)
  | succ n ih => exact inferInstanceAs (Fintype (K × Retos K n))

instance nonemptyRetos [Nonempty K] (n : ℕ) : Nonempty (Retos K n) := by
  induction n with
  | zero => exact inferInstanceAs (Nonempty PUnit)
  | succ n ih => exact inferInstanceAs (Nonempty (K × Retos K n))

theorem cardinal_retos (n : ℕ) : Fintype.card (Retos K n) = Fintype.card K ^ n := by
  induction n with
  | zero =>
    exact (Fintype.card_congr (show Retos K 0 ≃ PUnit from Equiv.refl _)).trans
      Fintype.card_unique
  | succ n ih =>
    calc
      _ = Fintype.card (K × Retos K n) :=
        Fintype.card_congr (show Retos K (n + 1) ≃ K × Retos K n from Equiv.refl _)
      _ = _ := by rw [Fintype.card_prod, ih, pow_succ, mul_comm]

variable [Nonempty K] [DecidableEq K]

/-- Valor terminal, o uno desde la primera excepción: el escape es absorbente. -/
@[expose] noncomputable def valor (E : ℕ → S → Finset K)
    (paso : ℕ → S → K → S) (fin : S → ℚ) :
    (i n : ℕ) → S → Retos K n → ℚ
  | _, 0, s, _ => fin s
  | i, n + 1, s, xs =>
      if xs.1 ∈ E i s then 1 else valor E paso fin (i + 1) n (paso i s xs.1) xs.2

/-- Probabilidad por medias condicionales, con estado arbitrariamente adaptativo. -/
@[expose] noncomputable def riesgo (E : ℕ → S → Finset K)
    (paso : ℕ → S → K → S) (fin : S → ℚ) : ℕ → ℕ → S → ℚ
  | _, 0, s => fin s
  | i, n + 1, s =>
      promedio (fun x => if x ∈ E i s then 1 else riesgo E paso fin (i + 1) n (paso i s x))

/-- Evento de alcanzar alguna excepción en el recorrido adaptativo. -/
@[expose] def Escapa (E : ℕ → S → Finset K) (paso : ℕ → S → K → S) :
    (i n : ℕ) → S → Retos K n → Prop
  | _, 0, _, _ => False
  | i, n + 1, s, xs => xs.1 ∈ E i s ∨ Escapa E paso (i + 1) n (paso i s xs.1) xs.2

instance decidableEscapa (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (i n : ℕ) (s : S) (xs : Retos K n) : Decidable (Escapa E paso i n s xs) := by
  induction n generalizing i s with
  | zero => exact isFalse id
  | succ n ih =>
    change Decidable (xs.1 ∈ E i s ∨ Escapa E paso (i + 1) n (paso i s xs.1) xs.2)
    haveI := ih (i + 1) (paso i s xs.1) xs.2
    infer_instance

omit [Nonempty K] [Fintype K] in
theorem valor_escape (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (i n : ℕ) (s : S) (xs : Retos K n) :
    valor E paso (fun _ => 0) i n s xs = if Escapa E paso i n s xs then 1 else 0 := by
  classical
  induction n generalizing i s with
  | zero => simp [valor, Escapa]
  | succ n ih =>
    obtain ⟨x, rest⟩ := xs
    by_cases hx : x ∈ E i s
    · simp only [valor, Escapa, hx, true_or, reduceIte]
    · simp only [valor, Escapa, hx, false_or, reduceIte, ih]

/-- La recursión coincide con el promedio sobre todos los vectores equiprobables. -/
theorem riesgo_es_promedio (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (fin : S → ℚ) (i n : ℕ) (s : S) :
    riesgo E paso fin i n s = promedio (valor E paso fin i n s) := by
  induction n generalizing i s with
  | zero => exact (promedio_constante (fin s)).symm
  | succ n ih =>
    rw [riesgo]
    change _ = promedio (fun xs : K × Retos K n =>
      if xs.1 ∈ E i s then 1 else valor E paso fin (i + 1) n (paso i s xs.1) xs.2)
    rw [promedio_producto]
    congr 1
    funext x
    by_cases hx : x ∈ E i s
    · simp only [hx, reduceIte]
      exact (promedio_constante 1).symm
    · simp only [hx, reduceIte]
      exact ih (i + 1) (paso i s x)

/-- Conteo exacto de transcripciones excepcionales entre |K|^n transcripciones. -/
theorem probabilidad_escape (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (i n : ℕ) (s : S) :
    riesgo E paso (fun _ => 0) i n s =
      ((Finset.univ.filter (Escapa E paso i n s)).card : ℚ) / (Fintype.card K : ℚ) ^ n := by
  classical
  rw [riesgo_es_promedio]
  simp_rw [promedio, valor_escape]
  rw [Finset.sum_boole, cardinal_retos, Nat.cast_pow]

theorem riesgo_no_negativo (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (fin : S → ℚ) (hfin : ∀ s, 0 ≤ fin s) (i n : ℕ) (s : S) :
    0 ≤ riesgo E paso fin i n s := by
  induction n generalizing i s with
  | zero => exact hfin s
  | succ n ih =>
    rw [riesgo]
    apply (show promedio (fun _ : K => 0) ≤ _ from ?_).trans_eq' (promedio_constante 0)
    apply promedio_monotono
    intro x
    split_ifs
    · norm_num
    · exact ih (i + 1) (paso i s x)

theorem riesgo_le_uno (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (fin : S → ℚ) (hfin : ∀ s, fin s ≤ 1) (i n : ℕ) (s : S) :
    riesgo E paso fin i n s ≤ 1 := by
  induction n generalizing i s with
  | zero => exact hfin s
  | succ n ih =>
    calc
      _ = promedio (fun x => if x ∈ E i s then 1 else
          riesgo E paso fin (i + 1) n (paso i s x)) := rfl
      _ ≤ promedio (fun _ : K => 1) := by
        apply promedio_monotono
        intro x
        split_ifs
        · rfl
        · exact ih (i + 1) (paso i s x)
      _ = 1 := promedio_constante 1

/-- Unión adaptativa: no requiere independencia entre los eventos excepcionales. -/
theorem cota_riesgo (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (fin : S → ℚ) (B : ℕ → ℕ) (h : ℚ) (hh : 0 ≤ h)
    (hfin : ∀ s, fin s ≤ h) (hE : ∀ i s, (E i s).card ≤ B i)
    (i n : ℕ) (s : S) :
    riesgo E paso fin i n s ≤ h +
      (∑ j ∈ Finset.range n, (B (i + j) : ℚ)) / Fintype.card K := by
  induction n generalizing i s with
  | zero => simpa only [riesgo, Finset.sum_range_zero, zero_div, add_zero] using hfin s
  | succ n ih =>
    let C : ℚ := h + (∑ j ∈ Finset.range n, (B (i + 1 + j) : ℚ)) / Fintype.card K
    have hC : 0 ≤ C := by dsimp [C]; positivity
    have hstep : riesgo E paso fin i (n + 1) s ≤
        (E i s).card / (Fintype.card K : ℚ) + C := by
      rw [riesgo, ← promedio_indicador, ← promedio_constante (K := K) C,
        ← promedio_suma]
      apply promedio_monotono
      intro x
      by_cases hx : x ∈ E i s
      · simp only [hx, reduceIte]
        linarith
      · simp only [hx, reduceIte, zero_add]
        exact ih (i + 1) (paso i s x)
    have hcard : ((E i s).card : ℚ) / Fintype.card K ≤ (B i : ℚ) / Fintype.card K :=
      div_le_div_of_nonneg_right (by exact_mod_cast hE i s) (by positivity)
    calc
      _ ≤ (B i : ℚ) / Fintype.card K + C := by linarith
      _ = _ := by
        dsimp [C]
        rw [Finset.sum_range_succ']
        simp only [Nat.add_zero, Nat.add_succ, Nat.add_right_comm i 1]
        ring

/-! La misma uni\u00f3n, pero con una cota de media por estado. Es la forma
adecuada cuando cada reto se obtiene aplicando una proyecci\u00f3n sesgada a un
alfabeto uniforme mayor. -/

theorem cota_riesgo_media (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (fin : S → ℚ) (B : ℕ → ℚ) (h : ℚ) (hh : 0 ≤ h)
    (hfin : ∀ s, fin s ≤ h)
    (hE : ∀ i s, promedio (fun x => if x ∈ E i s then (1 : ℚ) else 0) ≤ B i)
    (i n : ℕ) (s : S) :
    riesgo E paso fin i n s ≤ h + ∑ j ∈ Finset.range n, B (i + j) := by
  induction n generalizing i s with
  | zero => simpa only [riesgo, Finset.sum_range_zero, add_zero] using hfin s
  | succ n ih =>
    let C : ℚ := h + ∑ j ∈ Finset.range n, B (i + 1 + j)
    have hnonneg : ∀ (j : ℕ) (t : S), 0 ≤ B j := by
      intro j t
      have hp : 0 ≤ promedio (fun x => if x ∈ E j t then (1 : ℚ) else 0) := by
        unfold promedio
        positivity
      exact hp.trans (hE j t)
    have hC : 0 ≤ C := by
      dsimp [C]
      exact add_nonneg hh
        (Finset.sum_nonneg (fun j _ => hnonneg (i + 1 + j) s))
    have hstep : riesgo E paso fin i (n + 1) s ≤
        promedio (fun x => if x ∈ E i s then (1 : ℚ) else 0) + C := by
      rw [riesgo, ← promedio_constante (K := K) C, ← promedio_suma]
      apply promedio_monotono
      intro x
      by_cases hx : x ∈ E i s
      · simp only [hx, reduceIte]
        linarith
      · simp only [hx, reduceIte, zero_add]
        exact ih (i + 1) (paso i s x)
    have hstep' : riesgo E paso fin i (n + 1) s ≤ B i + C := by
      linarith [hstep, hE i s]
    calc
      _ ≤ B i + C := hstep'
      _ = h + ∑ j ∈ Finset.range (n + 1), B (i + j) := by
        dsimp [C]
        rw [Finset.sum_range_succ']
        simp only [Nat.add_zero, Nat.add_succ, Nat.add_right_comm i 1]
        ring

end Nexus.N06
