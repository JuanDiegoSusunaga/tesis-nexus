module

public import Nexus.Modelos.Costos
public import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Tactic

/-!
# Amortización con tamaño y verificación variables

Modelo de §§3.4 y 6.6.5. Los costos de disponibilidad, prueba de la lógica,
prover y llenado del lote son obligaciones de aplicación separadas.
-/

public section
namespace Nexus.Modelos.Amortizacion

open Filter Topology

@[expose] noncomputable def datos (d c : ℝ) (pi : ℕ → ℝ) (m : ℕ) : ℝ := d + (c + pi m) / m
@[expose] noncomputable def porOperacion (tiempo : ℕ → ℝ) (m : ℕ) : ℝ := tiempo m / m

theorem descomposicion (d c : ℝ) (pi : ℕ → ℝ) (m : ℕ) :
    datos d c pi m = d + c / m + pi m / m := by
  simp only [datos, add_div]
  ring

theorem limite_datos_variable (d c L : ℝ) (pi : ℕ → ℝ)
    (hpi : Tendsto (fun m : ℕ => pi m / m) atTop (𝓝 L)) :
    Tendsto (datos d c pi) atTop (𝓝 (d + L)) := by
  have h := ((tendsto_const_nhds (x := d)).add
    (tendsto_const_div_atTop_nhds_zero_nat c)).add hpi
  simpa only [add_zero, ← descomposicion] using h

theorem limite_datos_sublineal (d c : ℝ) (pi : ℕ → ℝ)
    (hpi : Tendsto (fun m : ℕ => pi m / m) atTop (𝓝 0)) :
    Tendsto (datos d c pi) atTop (𝓝 d) := by
  simpa only [add_zero] using limite_datos_variable d c 0 pi hpi

theorem sublineal_si_limite_datos (d c : ℝ) (pi : ℕ → ℝ)
    (h : Tendsto (datos d c pi) atTop (𝓝 d)) :
    Tendsto (fun m : ℕ => pi m / m) atTop (𝓝 0) := by
  have h' := (h.sub (tendsto_const_nhds (x := d))).sub
    (tendsto_const_div_atTop_nhds_zero_nat c)
  simp only [sub_self] at h'
  convert h' using 1
  ext m
  rw [descomposicion]
  ring

theorem limite_datos_iff_sublineal (d c : ℝ) (pi : ℕ → ℝ) :
    Tendsto (datos d c pi) atTop (𝓝 d) ↔
      Tendsto (fun m : ℕ => pi m / m) atTop (𝓝 0) :=
  ⟨sublineal_si_limite_datos d c pi, limite_datos_sublineal d c pi⟩

theorem piso_datos (d c : ℝ) (pi : ℕ → ℝ) (m : ℕ)
    (hc : 0 ≤ c) (hpi : 0 ≤ pi m) : d ≤ datos d c pi m := by
  exact le_add_of_nonneg_right (div_nonneg (add_nonneg hc hpi) (Nat.cast_nonneg m))

theorem equilibrio_variable (d c base : ℝ) (pi : ℕ → ℝ) (m : ℕ) (hm : 0 < m) :
    datos d c pi m ≤ base ↔ c + pi m ≤ (base - d) * m := by
  have hm' : (0 : ℝ) < m := by exact_mod_cast hm
  unfold datos
  rw [← le_sub_iff_add_le']
  exact div_le_iff₀ hm'

theorem disponibilidad_suma (d c D : ℝ) (pi : ℕ → ℝ) (m : ℕ) :
    datos (d + D) c pi m = datos d c pi m + D := by unfold datos; ring

theorem limite_con_disponibilidad (d c D : ℝ) (pi : ℕ → ℝ)
    (hpi : Tendsto (fun m : ℕ => pi m / m) atTop (𝓝 0)) :
    Tendsto (datos (d + D) c pi) atTop (𝓝 (d + D)) :=
  limite_datos_sublineal (d + D) c pi hpi

theorem limite_costo_lineal (d c a : ℝ) :
    Tendsto (datos d c (fun m => a * m)) atTop (𝓝 (d + a)) := by
  apply limite_datos_variable
  apply tendsto_const_nhds.congr'
  filter_upwards [eventually_gt_atTop (0 : ℕ)] with m hm
  have hn : (m : ℝ) ≠ 0 := by exact_mod_cast (ne_of_gt hm)
  simp only [mul_div_cancel_right₀ a hn]

theorem log_potencia_sublineal (r : ℕ) :
    Tendsto (fun m : ℕ => Real.log m ^ r / m) atTop (𝓝 0) := by
  simpa only [one_mul, add_zero, Function.comp_def] using
    (Real.tendsto_pow_log_div_mul_add_atTop 1 0 r one_ne_zero).comp tendsto_natCast_atTop_atTop

theorem limite_datos_polilog (d c a b : ℝ) (r : ℕ) :
    Tendsto (datos d c (fun m => a * Real.log m ^ r + b)) atTop (𝓝 d) := by
  apply limite_datos_sublineal
  have h := ((log_potencia_sublineal r).const_mul a).add
    (tendsto_const_div_atTop_nhds_zero_nat b)
  simpa only [mul_zero, zero_add, add_div, mul_div_assoc] using h

theorem limite_verificacion_polilog (a b : ℝ) (r : ℕ) :
    Tendsto (porOperacion (fun m => a * Real.log m ^ r + b)) atTop (𝓝 0) := by
  change Tendsto (fun m : ℕ => (a * Real.log m ^ r + b) / m) atTop (𝓝 0)
  have h := ((log_potencia_sublineal r).const_mul a).add
    (tendsto_const_div_atTop_nhds_zero_nat b)
  simpa only [mul_zero, zero_add, add_div, mul_div_assoc] using h

theorem sensibilidad_datos :
    |datos 32 128 (fun _ => 786600) 1024 - 800.289| < (1 / 2000 : ℝ) ∧
    |datos 32 128 (fun _ => 786600) 16384 - 80.018| < (1 / 2000 : ℝ) ∧
    |datos 32 128 (fun _ => 786600) 262144 - 35.001| < (1 / 2000 : ℝ) ∧
    |datos 32 128 (fun _ => 2 * 786600) 262144 - 38.002| < (1 / 2000 : ℝ) ∧
    |datos (32 + 3309) 128 (fun _ => 786600) 262144 - 3344.001| < (1 / 2000 : ℝ) := by
  norm_num [datos]

theorem mayor_prueba_mayor_costo (d c : ℝ) (pi psi : ℕ → ℝ) (m : ℕ)
    (h : pi m ≤ psi m) : datos d c pi m ≤ datos d c psi m := by
  unfold datos
  exact add_le_add (le_refl d)
    (div_le_div_of_nonneg_right (add_le_add (le_refl c) h) (Nat.cast_nonneg m))

end Nexus.Modelos.Amortizacion
