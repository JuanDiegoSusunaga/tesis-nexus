module

public import Nexus.N05.Muestreo
public import Mathlib.Algebra.Order.Floor.Ring
public import Mathlib.Data.Rat.Floor
import Mathlib.Tactic

/-!
# Cotas de omisión sin reemplazo

El espacio uniforme son los q-subconjuntos, con q≤M. El umbral se redondea
hacia arriba. Estas cuentas no especifican un canal hash ni el recorrido FRI.
-/

public section
namespace Nexus.N05

/-- Umbral entero de parejas malas y cota hipergeométrica del manuscrito. -/
@[expose] def H (M q : ℕ) (θ : ℚ) : ℚ :=
  (Nat.choose (M - ⌈θ * M⌉₊) q : ℚ) / Nat.choose M q

/-- Comparación multiplicativa sin divisiones, válida también en los extremos. -/
theorem binomiales_por_potencias (A M q : ℕ) (hAM : A ≤ M) :
    (Nat.choose A q : ℚ) * (M : ℚ) ^ q ≤
      (Nat.choose M q : ℚ) * (A : ℚ) ^ q := by
  induction q with
  | zero => simp
  | succ q ih =>
    by_cases hq : q + 1 ≤ A
    · have hqA : q ≤ A := by omega
      have hqM : q ≤ M := hqA.trans hAM
      have ha : (Nat.choose A (q + 1) : ℚ) * (q + 1) =
          (Nat.choose A q : ℚ) * ((A : ℚ) - q) := by
        exact_mod_cast (Nat.choose_succ_right_eq A q)
      have hm : (Nat.choose M (q + 1) : ℚ) * (q + 1) =
          (Nat.choose M q : ℚ) * ((M : ℚ) - q) := by
        exact_mod_cast (Nat.choose_succ_right_eq M q)
      have hAM' : (A : ℚ) ≤ M := by exact_mod_cast hAM
      have hqA' : (q : ℚ) ≤ A := by exact_mod_cast hqA
      have hfactor : ((A : ℚ) - q) * M ≤ ((M : ℚ) - q) * A := by
        nlinarith [show (0 : ℚ) ≤ q by positivity]
      have hmul := mul_le_mul ih hfactor
        (mul_nonneg (sub_nonneg.mpr hqA') (by positivity)) (by positivity)
      have hresult : (Nat.choose A (q + 1) : ℚ) * (M : ℚ) ^ (q + 1) * (q + 1) ≤
          (Nat.choose M (q + 1) : ℚ) * (A : ℚ) ^ (q + 1) * (q + 1) := by
        calc
          _ = ((Nat.choose A q : ℚ) * (M : ℚ) ^ q) * (((A : ℚ) - q) * M) := by
            rw [pow_succ]
            nlinarith [congrArg (fun x : ℚ => x * (M : ℚ) ^ q * M) ha]
          _ ≤ ((Nat.choose M q : ℚ) * (A : ℚ) ^ q) * (((M : ℚ) - q) * A) := hmul
          _ = _ := by
            rw [pow_succ]
            nlinarith [congrArg (fun x : ℚ => x * (A : ℚ) ^ q * A) hm]
      exact (mul_le_mul_iff_left₀ (show (0 : ℚ) < q + 1 by positivity)).mp hresult
    · rw [Nat.choose_eq_zero_of_lt (by omega)]
      simp only [Nat.cast_zero, zero_mul]
      positivity

/-- Muestrear sin reemplazo no aumenta la omisión respecto de (A/M)^q. -/
theorem razon_binomial_le_potencia (A M q : ℕ) (hM : 0 < M)
    (hq : q ≤ M) (hAM : A ≤ M) :
    (Nat.choose A q : ℚ) / Nat.choose M q ≤ ((A : ℚ) / M) ^ q := by
  have hc : (0 : ℚ) < Nat.choose M q := by exact_mod_cast Nat.choose_pos hq
  have hp : (0 : ℚ) < (M : ℚ) ^ q := by positivity
  rw [div_pow, div_le_div_iff₀ hc hp]
  simpa only [mul_comm] using binomiales_por_potencias A M q hAM

theorem H_no_negativa (M q : ℕ) (θ : ℚ) : 0 ≤ H M q θ := by
  unfold H
  positivity

/-- No hay muestras buenas si quedan menos de q parejas disponibles. -/
theorem H_cero (M q : ℕ) (θ : ℚ) (h : M - ⌈θ * M⌉₊ < q) : H M q θ = 0 := by
  simp [H, Nat.choose_eq_zero_of_lt h]

/-- Cota exponencial con redondeo hacia arriba, para radios de [0,1]. -/
theorem H_le_potencia (M q : ℕ) (θ : ℚ) (hM : 0 < M)
    (hq : q ≤ M) (_hθ : 0 ≤ θ) (hθ1 : θ ≤ 1) :
    H M q θ ≤ (1 - θ) ^ q := by
  have hceil : ⌈θ * M⌉₊ ≤ M := Nat.ceil_le.mpr (by nlinarith)
  have hround := Nat.le_ceil (θ * (M : ℚ))
  have hratio : ((M - ⌈θ * M⌉₊ : ℕ) : ℚ) / M ≤ 1 - θ := by
    rw [Nat.cast_sub hceil, div_le_iff₀ (by exact_mod_cast hM)]
    nlinarith
  exact (razon_binomial_le_potencia _ M q hM hq (Nat.sub_le _ _)).trans
    (pow_le_pow_left₀ (by positivity) hratio q)

/-- Más discrepancias exigidas solo disminuyen la cota de omisión. -/
theorem H_antitona (M q : ℕ) {θ φ : ℚ} (h : θ ≤ φ) : H M q φ ≤ H M q θ := by
  have hr : ⌈θ * (M : ℚ)⌉₊ ≤ ⌈φ * (M : ℚ)⌉₊ :=
    Nat.ceil_le_ceil (mul_le_mul_of_nonneg_right h (by positivity))
  unfold H
  apply div_le_div_of_nonneg_right _ (by positivity)
  exact_mod_cast Nat.choose_le_choose q (Nat.sub_le_sub_left hr M)

/-- El máximo entero exigido por una cota real de cardinal es precisamente el techo. -/
theorem cota_omision_radio {α : Type*} [DecidableEq α]
    (L G : Finset α) (q : ℕ) (θ : ℚ) (hG : G ⊆ L)
    (hmalas : θ * L.card ≤ ((L.card - G.card : ℕ) : ℚ)) :
    (((L.powersetCard q).filter (fun S => S ⊆ G)).card : ℚ) /
        (L.powersetCard q).card ≤ H L.card q θ := by
  have hceil : ⌈θ * (L.card : ℚ)⌉₊ ≤ L.card - G.card := Nat.ceil_le.mpr hmalas
  have hcard := Finset.card_le_card hG
  exact cota_omision L G q _ hG (by omega)

/-- Omisión exponencial para cualquier conjunto aceptante con la fracción indicada. -/
theorem omision_le_potencia {α : Type*} [DecidableEq α]
    (L G : Finset α) (q : ℕ) (θ : ℚ) (hG : G ⊆ L)
    (hL : 0 < L.card) (hq : q ≤ L.card) (hθ : 0 ≤ θ) (hθ1 : θ ≤ 1)
    (hmalas : θ * L.card ≤ ((L.card - G.card : ℕ) : ℚ)) :
    (((L.powersetCard q).filter (fun S => S ⊆ G)).card : ℚ) /
        (L.powersetCard q).card ≤ (1 - θ) ^ q :=
  (cota_omision_radio L G q θ hG hmalas).trans (H_le_potencia _ q θ hL hq hθ hθ1)

end Nexus.N05
