module

public import Nexus.Modelos.Omision
public import Nexus.Cripto.Probabilidad
import Mathlib.Tactic

public section
namespace Nexus.Modelos.IdealHistorico

open Nexus.Goldilocks
open scoped ENNReal

/-- Fórmula histórica de §6.7.5, conservada separadamente de la cota refinada. -/
@[expose] def errorFRI (T rondas : ℕ) (delta : ℚ) : ℚ :=
  min 1 ((rondas : ℚ) * max ((8 * (T : ℚ)) / (p : ℚ) ^ 2) ((1 - delta) ^ 40))

@[expose] def omision (T : ℕ) : ℚ :=
  Nexus.N05.H (4 * T) 40 ((1 / 8 : ℚ) + 1 / (8 * (T : ℚ)))

@[expose] def limite (T : ℕ) : ℚ :=
  min 1 ((p : ℚ)⁻¹ ^ 2 + errorFRI T (Nat.log2 T + 1) (1 / 8) +
    errorFRI T (Nat.log2 (2 * T) + 1) (1 / 8) + omision T)

@[expose] def superior : Fin 4 → ℚ := ![52736 / 1000000, 74258 / 1000000,
  95099 / 1000000, 134071 / 1000000]

theorem error_fri_le_uno (T rondas : ℕ) (delta : ℚ) : errorFRI T rondas delta ≤ 1 := min_le_left _ _

theorem limite_le_uno (T : ℕ) : limite T ≤ 1 := min_le_left _ _

theorem error_fri_no_negativo (T rondas : ℕ) (delta : ℚ) :
    0 ≤ errorFRI T rondas delta := by
  unfold errorFRI
  apply le_min (by norm_num)
  apply mul_nonneg (by positivity)
  exact (by positivity : (0 : ℚ) ≤ 8 * T / (p : ℚ) ^ 2).trans (le_max_left _ _)

theorem techo_omision (i : Fin 4) :
    ⌈((1 / 8 : ℚ) + 1 / (8 * (Nexus.Modelos.Omision.filas i : ℚ))) *
      (4 * Nexus.Modelos.Omision.filas i : ℕ)⌉₊ = Nexus.Modelos.Omision.filas i / 2 + 1 := by
  fin_cases i <;> apply (Nat.ceil_eq_iff (by norm_num [Nexus.Modelos.Omision.filas])).mpr <;>
    norm_num [Nexus.Modelos.Omision.filas]

set_option maxRecDepth 4096 in
theorem tabla6_19 (i : Fin 4) :
    limite (Nexus.Modelos.Omision.filas i) ≤ superior i ∧
      superior i - limite (Nexus.Modelos.Omision.filas i) < 1 / 1000000 := by
  simp only [limite, omision, Nexus.N05.H]
  rw [techo_omision]
  fin_cases i <;>
    norm_num [errorFRI, superior, Nexus.Modelos.Omision.filas,
      Nexus.N05.H, p, Nat.choose_eq_descFactorial_div_factorial, Nat.descFactorial]

theorem presupuesto_por_rondas (rondas : ℕ) (e : ℚ) (P : Fin rondas → ℚ)
    (h : ∀ j, P j ≤ e) : (∑ j, P j) ≤ (rondas : ℚ) * e := by
  calc
    (∑ j, P j) ≤ ∑ _ : Fin rondas, e := Finset.sum_le_sum (fun j _ => h j)
    _ = _ := by simp

theorem union_eventos {A : Type*} (ley : PMF A) (eventos : Fin 4 → A → Prop) :
    Nexus.Cripto.probabilidad ley (fun x => ∃ j, eventos j x) ≤
      ∑ j, Nexus.Cripto.probabilidad ley (eventos j) := by
  have h := MeasureTheory.measure_iUnion_fintype_le ley.toOuterMeasure
    (fun j : Fin 4 => {x | eventos j x})
  have he : {x | ∃ j, eventos j x} = ⋃ j, {x | eventos j x} := by ext x; simp
  change ley.toOuterMeasure {x | ∃ j, eventos j x} ≤ ∑ j, ley.toOuterMeasure {x | eventos j x}
  rw [he]
  exact h

theorem union_conservadora {A : Type*} (ley : PMF A) (acepta : A → Prop)
    (eventos : Fin 4 → A → Prop) (cotas : Fin 4 → ℝ≥0∞)
    (hcasos : ∀ x, acepta x → ∃ j, eventos j x)
    (hcotas : ∀ j, Nexus.Cripto.probabilidad ley (eventos j) ≤ cotas j) :
    Nexus.Cripto.probabilidad ley acepta ≤ min 1 (∑ j, cotas j) := by
  apply le_min (Nexus.Cripto.probabilidad_le_uno _ _)
  exact (Nexus.Cripto.probabilidad_monotona _ _ _ hcasos).trans
    ((union_eventos ley eventos).trans (Finset.sum_le_sum (fun j _ => hcotas j)))

end Nexus.Modelos.IdealHistorico
