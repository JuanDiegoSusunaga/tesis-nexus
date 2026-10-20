module

public import Mathlib.Analysis.Asymptotics.Basic
public import Mathlib.Analysis.SpecialFunctions.Log.Base
public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
public import Mathlib.Data.Fintype.Card
import Mathlib.Tactic

/-!
# Recuento de una NTT radix dos y productos matriz–vector

Familia n=2^r y costo unitario de operaciones del anillo. El calendario
divide en dos y ejecuta n/2 mariposas por nivel; cada mariposa cuenta una
multiplicación y dos sumas. La corrección algebraica y el backend son
obligaciones separadas de este modelo de costo.
-/

public section
namespace Nexus.Complejidad

open Filter Topology Asymptotics
open scoped BigOperators

@[expose] def mariposas : ℕ → ℕ
  | 0 => 0
  | r + 1 => 2 * mariposas r + 2 ^ r

@[expose] def costoNTT (r : ℕ) : ℕ := 3 * mariposas r
@[expose] def costoInversa (r : ℕ) : ℕ := costoNTT r + 2 ^ r
@[expose] def costoProducto (r : ℕ) : ℕ := 2 * costoNTT r + costoInversa r + 2 ^ r
@[expose] def costoEscolar (n : ℕ) : ℕ := n * n
@[expose] def costoMatrizGrueso (k l r : ℕ) : ℕ := k * l * (costoProducto r + 2 ^ r)
@[expose] def costoMatrizNTT (k l r : ℕ) : ℕ := (k + l) * costoNTT r + 2 * k * l * 2 ^ r

theorem mariposas_sucesor (r : ℕ) : mariposas (r + 1) = (r + 1) * 2 ^ r := by
  induction r with
  | zero => norm_num [mariposas]
  | succ r ih => rw [mariposas, ih, pow_succ]; ring

theorem mariposas_doble (r : ℕ) : 2 * mariposas r = r * 2 ^ r := by
  cases r with
  | zero => norm_num [mariposas]
  | succ r => rw [mariposas_sucesor, pow_succ]; ring

theorem mariposas_cerrado (r : ℕ) : mariposas r = r * 2 ^ r / 2 := by
  have h := mariposas_doble r
  omega

theorem mariposas_real (r : ℕ) : (mariposas r : ℝ) = (r : ℝ) * (2 : ℝ) ^ r / 2 := by
  have h : (2 : ℝ) * mariposas r = (r : ℝ) * (2 : ℝ) ^ r := by exact_mod_cast mariposas_doble r
  linarith

theorem log_tamano (r : ℕ) : Real.logb 2 ((2 : ℝ) ^ r) = r := by
  rw [Real.logb_pow, Real.logb_self_eq_one (by norm_num : (1 : ℝ) < 2), mul_one]

theorem costo_ntt_real (r : ℕ) : (costoNTT r : ℝ) = (3 / 2 : ℝ) * (2 : ℝ) ^ r * r := by
  simp only [costoNTT, Nat.cast_mul, Nat.cast_ofNat, mariposas_real]
  ring

theorem costo_producto_real (r : ℕ) :
    (costoProducto r : ℝ) = (9 / 2 : ℝ) * (2 : ℝ) ^ r * r + 2 * (2 : ℝ) ^ r := by
  simp only [costoProducto, costoInversa, Nat.cast_add, Nat.cast_mul, Nat.cast_ofNat,
    Nat.cast_pow, costo_ntt_real]
  ring

theorem costo_producto_cota (r : ℕ) (hr : 1 ≤ r) :
    (costoProducto r : ℝ) ≤ 7 * ((2 : ℝ) ^ r * r) := by
  have hr' : (1 : ℝ) ≤ r := by exact_mod_cast hr
  have hp : (0 : ℝ) ≤ (2 : ℝ) ^ r := by positivity
  have h := mul_le_mul_of_nonneg_left hr' hp
  rw [costo_producto_real]
  nlinarith

private theorem bigO_de_cota (f g : ℕ → ℝ) (C : ℝ)
    (hf : ∀ r, 0 ≤ f r) (hg : ∀ r, 0 ≤ g r)
    (h : ∀ r, 1 ≤ r → f r ≤ C * g r) : f =O[atTop] g := by
  apply IsBigO.of_bound C
  filter_upwards [eventually_ge_atTop (1 : ℕ)] with r hr
  simpa only [Real.norm_eq_abs, abs_of_nonneg (hf r), abs_of_nonneg (hg r)] using h r hr

theorem ntt_es_O_n_log_n :
    (fun r : ℕ => (costoNTT r : ℝ)) =O[atTop]
      (fun r => (2 : ℝ) ^ r * Real.logb 2 ((2 : ℝ) ^ r)) := by
  apply bigO_de_cota _ _ (3 / 2) (fun _ => Nat.cast_nonneg _)
  · intro r
    rw [log_tamano]
    positivity
  · intro r _
    rw [log_tamano, costo_ntt_real]
    ring_nf
    exact le_refl _

theorem producto_es_O_n_log_n :
    (fun r : ℕ => (costoProducto r : ℝ)) =O[atTop]
      (fun r => (2 : ℝ) ^ r * Real.logb 2 ((2 : ℝ) ^ r)) := by
  apply bigO_de_cota _ _ 7 (fun _ => Nat.cast_nonneg _)
  · intro r; rw [log_tamano]; positivity
  · intro r hr
    rw [log_tamano]
    exact costo_producto_cota r hr

theorem productos_matriz (k l : ℕ) : Fintype.card (Fin k × Fin l) = k * l := by simp

theorem transformadas_compartidas (k l r : ℕ) :
    costoMatrizNTT k l r = (k + l) * costoNTT r + 2 * k * l * 2 ^ r := rfl

theorem dimensiones_cota (k l : ℕ) (hk : 1 ≤ k) (hl : 1 ≤ l) : k + l ≤ 2 * k * l := by
  have h1 : k ≤ k * l := by simpa using Nat.mul_le_mul_left k hl
  have h2 : l ≤ k * l := by simpa using Nat.mul_le_mul_right l hk
  nlinarith

theorem costo_matriz_real (k l r : ℕ) :
    (costoMatrizNTT k l r : ℝ) =
      (3 / 2 : ℝ) * (k + l) * (2 : ℝ) ^ r * r + 2 * k * l * (2 : ℝ) ^ r := by
  simp only [costoMatrizNTT, Nat.cast_add, Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat, costo_ntt_real]
  ring

theorem costo_matriz_fino (k l r : ℕ) :
    (costoMatrizNTT k l r : ℝ) ≤
      2 * (((k : ℝ) + l) * (2 : ℝ) ^ r * r + (k : ℝ) * l * (2 : ℝ) ^ r) := by
  rw [costo_matriz_real]
  have h : (0 : ℝ) ≤ ((k : ℝ) + l) * (2 : ℝ) ^ r * r := by positivity
  nlinarith

theorem matriz_es_O_fino (k l : ℕ) :
    (fun r : ℕ => (costoMatrizNTT k l r : ℝ)) =O[atTop]
      (fun r => ((k : ℝ) + l) * (2 : ℝ) ^ r * Real.logb 2 ((2 : ℝ) ^ r) +
        (k : ℝ) * l * (2 : ℝ) ^ r) := by
  apply bigO_de_cota _ _ 2 (fun _ => Nat.cast_nonneg _)
  · intro r; rw [log_tamano]; positivity
  · intro r _; rw [log_tamano]; exact costo_matriz_fino k l r

theorem costo_matriz_grueso_cota (k l r : ℕ) (hr : 1 ≤ r) :
    (costoMatrizGrueso k l r : ℝ) ≤ 8 * ((k : ℝ) * l * ((2 : ℝ) ^ r * r)) := by
  have h := costo_producto_cota r hr
  have hn : (2 : ℝ) ^ r ≤ (2 : ℝ) ^ r * r := by
    exact le_mul_of_one_le_right (by positivity) (by exact_mod_cast hr)
  have hb := mul_le_mul_of_nonneg_left (add_le_add h hn) (show (0 : ℝ) ≤ (k : ℝ) * l by positivity)
  simpa only [costoMatrizGrueso, Nat.cast_mul, Nat.cast_add, Nat.cast_pow, Nat.cast_ofNat] using
    hb.trans_eq (by ring)

theorem matriz_gruesa_es_O (k l : ℕ) :
    (fun r : ℕ => (costoMatrizGrueso k l r : ℝ)) =O[atTop]
      (fun r => (k : ℝ) * l * ((2 : ℝ) ^ r * Real.logb 2 ((2 : ℝ) ^ r))) := by
  apply bigO_de_cota _ _ 8 (fun _ => Nat.cast_nonneg _)
  · intro r; rw [log_tamano]; positivity
  · intro r hr; rw [log_tamano]; exact costo_matriz_grueso_cota k l r hr

theorem perfil_256 : (2 : ℕ) ^ 8 = 256 ∧ mariposas 8 = 1024 ∧ costoNTT 8 = 3072 := by
  norm_num [mariposas, costoNTT]

theorem productos_perfiles : (4 : ℕ) * 4 = 16 ∧ (6 : ℕ) * 5 = 30 ∧ (8 : ℕ) * 7 = 56 := by norm_num

theorem n_fijo_cota (k l : ℕ) (hk : 1 ≤ k) (hl : 1 ≤ l) :
    costoMatrizNTT k l 8 ≤ 6656 * (k * l) := by
  have h := dimensiones_cota k l hk hl
  norm_num [costoMatrizNTT, costoNTT, mariposas]
  nlinarith

theorem n_fijo_es_O (k l : ℕ → ℕ) (hk : ∀ i, 1 ≤ k i) (hl : ∀ i, 1 ≤ l i) :
    (fun i : ℕ => (costoMatrizNTT (k i) (l i) 8 : ℝ)) =O[atTop]
      (fun i => ((k i * l i : ℕ) : ℝ)) := by
  apply bigO_de_cota _ _ 6656 (fun _ => Nat.cast_nonneg _) (fun _ => Nat.cast_nonneg _)
  intro i _
  exact_mod_cast n_fijo_cota (k i) (l i) (hk i) (hl i)

theorem escolar_cuenta_pares (n : ℕ) : costoEscolar n = Fintype.card (Fin n × Fin n) := by
  simp [costoEscolar]

theorem matriz_optimizada_cota_gruesa (k l r : ℕ) (hk : 1 ≤ k) (hl : 1 ≤ l) :
    costoMatrizNTT k l r ≤ costoMatrizGrueso k l r := by
  have h := Nat.mul_le_mul_right (costoNTT r) (dimensiones_cota k l hk hl)
  have hz := Nat.zero_le (k * l * (costoNTT r + 2 ^ r))
  unfold costoMatrizNTT costoMatrizGrueso costoProducto costoInversa
  nlinarith

end Nexus.Complejidad
