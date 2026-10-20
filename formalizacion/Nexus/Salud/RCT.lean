module

public import Nexus.Entropia.Minima
public import Mathlib.Algebra.Order.Floor.Ring
import Mathlib.Tactic

/-!
# Corte RCT y probabilidad de una racha IID

La cuenta probabilística usa explícitamente muestras independientes. No
certifica que un flujo físico tenga esa distribución ni el cálculo f64 de Rust.
-/

public section
namespace Nexus.Salud

open Nexus.Entropia
open scoped BigOperators

@[expose] noncomputable def corteRCT (H alpha : ℝ) : ℕ :=
  ⌈-Real.logb 2 alpha / H⌉₊ + 1

private lemma techo_ocho_tercios : ⌈(8 / 3 : ℝ)⌉₊ = 3 :=
  (Nat.ceil_eq_iff (by norm_num : (3 : ℕ) ≠ 0)).mpr (by norm_num)

theorem corte_rct_iff (H alpha : ℝ) (hH : 0 < H) (ha : 0 < alpha) (n : ℕ) :
    corteRCT H alpha ≤ n + 1 ↔ (2 : ℝ) ^ (-H * n) ≤ alpha := by
  rw [corteRCT, Nat.add_le_add_iff_right, Nat.ceil_le, div_le_iff₀ hH,
    ← Real.le_logb_iff_rpow_le (by norm_num : (1 : ℝ) < 2) ha]
  constructor <;> intro h <;> nlinarith

theorem corte_rct_satisface (H alpha : ℝ) (hH : 0 < H) (ha : 0 < alpha) :
    (2 : ℝ) ^ (-H * (⌈-Real.logb 2 alpha / H⌉₊ : ℕ)) ≤ alpha := by
  exact (corte_rct_iff H alpha hH ha _).mp (le_refl _)

theorem corte_rct_minimo (H alpha : ℝ) (hH : 0 < H) (ha : 0 < alpha)
    (n : ℕ) (hn : (2 : ℝ) ^ (-H * n) ≤ alpha) : corteRCT H alpha ≤ n + 1 :=
  (corte_rct_iff H alpha hH ha n).mpr hn

theorem corte_rct_perfil : corteRCT (15 / 2) ((2 : ℝ) ^ (-20 : ℝ)) = 4 := by
  rw [corteRCT, Real.logb_rpow (by norm_num : (0 : ℝ) < 2) (by norm_num : (2 : ℝ) ≠ 1)]
  norm_num
  exact techo_ocho_tercios

theorem alpha_perfil : (2 : ℝ) ^ (-20 : ℝ) = 1 / 1048576 := by
  rw [Real.rpow_neg (by norm_num : (0 : ℝ) ≤ 2)]
  norm_num

variable {A : Type*} [Fintype A] [Nonempty A]

@[expose] noncomputable def probabilidadRachaIID (d : Distribucion A) (n : ℕ) : ℝ :=
  ∑ x, d.masa x * d.masa x ^ n

omit [Nonempty A] in
theorem probabilidad_racha_no_negativa (d : Distribucion A) (n : ℕ) :
    0 ≤ probabilidadRachaIID d n := by
  exact Finset.sum_nonneg (fun x _ => mul_nonneg (d.no_negativa x) (pow_nonneg (d.no_negativa x) n))

theorem probabilidad_racha_cota (d : Distribucion A) (n : ℕ) :
    probabilidadRachaIID d n ≤ maximo d ^ n := by
  calc
    _ ≤ ∑ x, d.masa x * maximo d ^ n := Finset.sum_le_sum (fun x _ =>
      mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (d.no_negativa x) (masa_le_maximo d x) n)
        (d.no_negativa x))
    _ = _ := by rw [← Finset.sum_mul, d.normalizada, one_mul]

theorem rct_falsa_alarma_iid (d : Distribucion A) (H alpha : ℝ)
    (hH : 0 < H) (ha : 0 < alpha) (hd : H ≤ minEntropia d) :
    probabilidadRachaIID d ⌈-Real.logb 2 alpha / H⌉₊ ≤ alpha := by
  let n := ⌈-Real.logb 2 alpha / H⌉₊
  have hm := (min_entropia_iff_masa d H).mp hd
  calc
    _ ≤ maximo d ^ n := probabilidad_racha_cota d n
    _ ≤ ((2 : ℝ) ^ (-H)) ^ n := pow_le_pow_left₀ (le_of_lt (maximo_positivo d)) hm n
    _ = (2 : ℝ) ^ (-H * n) := by
      rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 2)]
    _ ≤ alpha := corte_rct_satisface H alpha hH ha

theorem rct_perfil_falsa_alarma (d : Distribucion A) (hd : (15 / 2 : ℝ) ≤ minEntropia d) :
    probabilidadRachaIID d 3 ≤ 1 / 1048576 := by
  have h := rct_falsa_alarma_iid d (15 / 2) ((2 : ℝ) ^ (-20 : ℝ))
    (by norm_num) (by positivity) hd
  rw [alpha_perfil] at h
  norm_num [show Real.logb 2 (1 / 1048576 : ℝ) = -20 by
    rw [← alpha_perfil, Real.logb_rpow (by norm_num) (by norm_num)]] at h
  simpa only [techo_ocho_tercios] using h

end Nexus.Salud
