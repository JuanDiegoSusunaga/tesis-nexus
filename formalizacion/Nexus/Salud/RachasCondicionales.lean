module

public import Nexus.Salud.RCT
public import Nexus.Salud.Fuente
import Mathlib.Tactic

/-!
# Rachas con leyes condicionales y contadores acotados

La ley de la continuación puede depender del símbolo inicial y de la
longitud de la historia repetida. La cota se exige en esas historias;
una min-entropía marginal por sí sola no basta.
-/

public section
namespace Nexus.Salud.Condicional

open Nexus.Entropia
open scoped BigOperators
variable {A : Type*} [Fintype A]

@[expose] noncomputable def continuacion (K : A → ℕ → Distribucion A) (x : A) : ℕ → ℝ
  | 0 => 1
  | n + 1 => continuacion K x n * (K x n).masa x

@[expose] noncomputable def racha (d : Distribucion A) (K : A → ℕ → Distribucion A) (n : ℕ) : ℝ :=
  ∑ x, d.masa x * continuacion K x n

theorem continuacion_no_negativa (K : A → ℕ → Distribucion A) (x : A) (n : ℕ) :
    0 ≤ continuacion K x n := by
  induction n with
  | zero => norm_num [continuacion]
  | succ n ih => exact mul_nonneg ih ((K x n).no_negativa x)

theorem continuacion_acotada (K : A → ℕ → Distribucion A) (rho : ℝ) (hr : 0 ≤ rho)
    (h : ∀ x j, (K x j).masa x ≤ rho) (x : A) (n : ℕ) :
    continuacion K x n ≤ rho ^ n := by
  induction n with
  | zero => simp [continuacion]
  | succ n ih =>
    rw [continuacion, pow_succ]
    exact mul_le_mul ih (h x n) ((K x n).no_negativa x) (pow_nonneg hr n)

theorem racha_condicional_acotada (d : Distribucion A) (K : A → ℕ → Distribucion A)
    (rho : ℝ) (hr : 0 ≤ rho) (h : ∀ x j, (K x j).masa x ≤ rho) (n : ℕ) :
    racha d K n ≤ rho ^ n := by
  calc
    _ ≤ ∑ x, d.masa x * rho ^ n := Finset.sum_le_sum (fun x _ =>
      mul_le_mul_of_nonneg_left (continuacion_acotada K rho hr h x n) (d.no_negativa x))
    _ = _ := by rw [← Finset.sum_mul, d.normalizada, one_mul]

theorem rct_condicional (d : Distribucion A) (K : A → ℕ → Distribucion A) (H alpha : ℝ)
    (hH : 0 < H) (ha : 0 < alpha) (h : ∀ x j, (K x j).masa x ≤ (2 : ℝ) ^ (-H)) :
    racha d K ⌈-Real.logb 2 alpha / H⌉₊ ≤ alpha := by
  calc
    _ ≤ ((2 : ℝ) ^ (-H)) ^ ⌈-Real.logb 2 alpha / H⌉₊ :=
      racha_condicional_acotada d K _ (by positivity) h _
    _ = (2 : ℝ) ^ (-H * (⌈-Real.logb 2 alpha / H⌉₊ : ℕ)) := by
      rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 2)]
    _ ≤ alpha := corte_rct_satisface H alpha hH ha

variable [DecidableEq A]

omit [Fintype A] in
theorem racha_no_fallida_acotada (C : ℕ) (hC : 1 < C) (s : CuentaRCT A) (x : A)
    (h : (actualizarRCT C s x).2 = false) : (actualizarRCT C s x).1.racha < C := by
  by_cases hx : s.ultimo = some x
  · simpa [actualizarRCT, hx] using h
  · simpa only [actualizarRCT, hx, ite_false] using hC

omit [Fintype A] [DecidableEq A] in
theorem incremento_sin_desbordamiento (C limite : ℕ) (hC : C < limite)
    (s : CuentaRCT A) (hs : s.racha < C) : s.racha + 1 < limite := by omega

omit [Fintype A] [DecidableEq A] in
theorem perfil_incremento_u64 (s : CuentaRCT A) (hs : s.racha < 4) :
    s.racha + 1 < 2 ^ 64 := by omega

omit [Fintype A] in
theorem monitor_sano_racha (s : Monitor A) (x : A) (hf : s.fallo = false)
    (hn : (pasoMonitor 4 512 16 s x).fallo = false) :
    (pasoMonitor 4 512 16 s x).rct.racha < 4 := by
  have hr : (actualizarRCT 4 s.rct x).2 = false := by
    simp only [pasoMonitor, hf, Bool.false_eq_true, ite_false, Bool.or_eq_false_iff] at hn
    exact hn.1
  simpa only [pasoMonitor, hf, Bool.false_eq_true, ite_false] using
    racha_no_fallida_acotada 4 (by norm_num) s.rct x hr

end Nexus.Salud.Condicional
