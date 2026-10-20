module

public import Nexus.Complejidad.NTT
public import Nexus.Complejidad.Rechazo
import Mathlib.Tactic

/-! # Composición del costo NTT y los intentos geométricos de §6.5.2. -/

public section
namespace Nexus.Complejidad

open Filter Topology Asymptotics Rechazo

theorem firma_gruesa_O (k l : ℕ) (p : ℕ → unitInterval) (p0 : ℝ) (hp0 : 0 < p0)
    (hp : ∀ r, p0 ≤ p r) :
    (fun r : ℕ => costoEsperado (p r) (costoMatrizGrueso k l r)) =O[atTop]
      (fun r => (k : ℝ) * l * ((2 : ℝ) ^ r * Real.logb 2 ((2 : ℝ) ^ r))) :=
  costo_esperado_preserva_O p p0 hp0 hp _ _ (matriz_gruesa_es_O k l)

theorem firma_optimizada_O (k l : ℕ) (p : ℕ → unitInterval) (p0 : ℝ) (hp0 : 0 < p0)
    (hp : ∀ r, p0 ≤ p r) :
    (fun r : ℕ => costoEsperado (p r) (costoMatrizNTT k l r)) =O[atTop]
      (fun r => ((k : ℝ) + l) * (2 : ℝ) ^ r * Real.logb 2 ((2 : ℝ) ^ r) +
        (k : ℝ) * l * (2 : ℝ) ^ r) :=
  costo_esperado_preserva_O p p0 hp0 hp _ _ (matriz_es_O_fino k l)

theorem firma_n_fijo_O (k l : ℕ → ℕ) (hk : ∀ i, 1 ≤ k i) (hl : ∀ i, 1 ≤ l i)
    (p : ℕ → unitInterval) (p0 : ℝ) (hp0 : 0 < p0) (hp : ∀ i, p0 ≤ p i) :
    (fun i : ℕ => costoEsperado (p i) (costoMatrizNTT (k i) (l i) 8)) =O[atTop]
      (fun i => ((k i * l i : ℕ) : ℝ)) :=
  costo_esperado_preserva_O p p0 hp0 hp _ _ (n_fijo_es_O k l hk hl)

theorem firma_cota_n_fijo (k l : ℕ) (hk : 1 ≤ k) (hl : 1 ≤ l)
    (p : unitInterval) (p0 : ℝ) (hp0 : 0 < p0) (hp : p0 ≤ p) :
    costoEsperado p (costoMatrizNTT k l 8) ≤ (6656 / p0) * (k * l) := by
  rw [costo_esperado p (hp0.trans_le hp)]
  calc
    (costoMatrizNTT k l 8 : ℝ) / (p : ℝ) ≤ (costoMatrizNTT k l 8 : ℝ) / p0 :=
      div_le_div_of_nonneg_left (Nat.cast_nonneg _) hp0 hp
    _ ≤ (6656 * ((k * l : ℕ) : ℝ)) / p0 :=
      div_le_div_of_nonneg_right (by exact_mod_cast n_fijo_cota k l hk hl) (le_of_lt hp0)
    _ = (6656 / p0) * (k * l) := by push_cast; ring

@[expose] noncomputable def probabilidadDecreciente (m : ℕ) : unitInterval :=
  ⟨1 / ((m : ℝ) + 1), by
    constructor
    · positivity
    · apply (div_le_iff₀ (by positivity : (0 : ℝ) < m + 1)).mpr
      have h : (0 : ℝ) ≤ m := Nat.cast_nonneg m
      linarith⟩

theorem probabilidad_decreciente_positiva (m : ℕ) : 0 < (probabilidadDecreciente m : ℝ) := by
  change 0 < 1 / ((m : ℝ) + 1)
  positivity

theorem esperanza_decreciente (m : ℕ) : esperanza (probabilidadDecreciente m) = (m : ℝ) + 1 := by
  rw [esperanza_intentos _ (probabilidad_decreciente_positiva m)]
  change (1 : ℝ) / (1 / ((m : ℝ) + 1)) = _
  simp

theorem sin_cota_uniforme_no_O_uno :
    ¬ (fun m : ℕ => esperanza (probabilidadDecreciente m)) =O[atTop] (fun _ => (1 : ℝ)) := by
  intro h
  obtain ⟨C, hC⟩ := isBigO_iff.mp h
  have hgt : ∀ᶠ m : ℕ in atTop, C < (m : ℝ) + 1 := by
    filter_upwards [tendsto_natCast_atTop_atTop.eventually (eventually_gt_atTop C)] with m hm
    linarith
  obtain ⟨m, hm, hCm⟩ := (hC.and hgt).exists
  rw [esperanza_decreciente] at hm
  have hn : (0 : ℝ) ≤ (m : ℝ) + 1 := by positivity
  simp only [Real.norm_eq_abs, abs_of_nonneg hn, abs_one, mul_one] at hm
  linarith

end Nexus.Complejidad
