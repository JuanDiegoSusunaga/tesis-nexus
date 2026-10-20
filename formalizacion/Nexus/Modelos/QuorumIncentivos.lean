module

public import Mathlib.LinearAlgebra.Lagrange
import Mathlib.Tactic

public section
namespace Nexus.Modelos.Quorum

open scoped BigOperators
variable {I : Type}

@[expose] def peso (w : I → ℚ) (s : Finset I) : ℚ := ∑ i ∈ s, w i

theorem peso_monotono (w : I → ℚ) (hw : ∀ i, 0 ≤ w i) (a b : Finset I) (h : a ⊆ b) :
    peso w a ≤ peso w b := Finset.sum_le_sum_of_subset_of_nonneg h (fun i _ _ => hw i)

variable [Fintype I] [DecidableEq I]

theorem interseccion_cota (w : I → ℚ) (hw : ∀ i, 0 ≤ w i)
    (hn : peso w Finset.univ = 1) (a b : Finset I) :
    peso w a + peso w b - 1 ≤ peso w (a ∩ b) := by
  have he : peso w (a ∪ b) + peso w (a ∩ b) = peso w a + peso w b :=
    Finset.sum_union_inter
  have hu := peso_monotono w hw (a ∪ b) Finset.univ (Finset.subset_univ _)
  rw [hn] at hu
  linarith

theorem quorum_estricto_interseca_honestos (w : I → ℚ) (hw : ∀ i, 0 ≤ w i)
    (hn : peso w Finset.univ = 1) (a b malos : Finset I)
    (ha : (2 / 3 : ℚ) < peso w a) (hb : (2 / 3 : ℚ) < peso w b)
    (hm : peso w malos ≤ 1 / 3) : ∃ i ∈ a ∩ b, i ∉ malos := by
  by_contra h
  have hsub : a ∩ b ⊆ malos := by
    intro i hi
    by_contra hmal
    exact h ⟨i, hi, hmal⟩
  have hi := peso_monotono w hw (a ∩ b) malos hsub
  have hc := interseccion_cota w hw hn a b
  linarith

theorem quorum_inclusivo_requiere_menor_byzantino (w : I → ℚ) (hw : ∀ i, 0 ≤ w i)
    (hn : peso w Finset.univ = 1) (a b malos : Finset I)
    (ha : (2 / 3 : ℚ) ≤ peso w a) (hb : (2 / 3 : ℚ) ≤ peso w b)
    (hm : peso w malos < 1 / 3) : ∃ i ∈ a ∩ b, i ∉ malos := by
  by_contra h
  have hsub : a ∩ b ⊆ malos := by
    intro i hi
    by_contra hmal
    exact h ⟨i, hi, hmal⟩
  have hi := peso_monotono w hw (a ∩ b) malos hsub
  have hc := interseccion_cota w hw hn a b
  linarith

end Nexus.Modelos.Quorum

namespace Nexus.Modelos.Incentivos

/-- Juego de referencia explícito; true significa cumplir y false desviarse. -/
structure Pagos (n : ℕ) where
  recompensa : Fin n → ℚ
  costo : Fin n → ℚ
  ganancia : Fin n → ℚ
  deteccion : Fin n → ℚ
  deposito : Fin n → ℚ

@[expose] def utilidad {n : ℕ} (p : Pagos n) (perfil : Fin n → Bool) (i : Fin n) : ℚ :=
  if perfil i then p.recompensa i - p.costo i else p.ganancia i - p.deteccion i * p.deposito i

@[expose] def Nash {n : ℕ} (p : Pagos n) (perfil : Fin n → Bool) : Prop :=
  ∀ i accion, utilidad p (Function.update perfil i accion) i ≤ utilidad p perfil i

theorem honestidad_nash_iff {n : ℕ} (p : Pagos n) : Nash p (fun _ => true) ↔
    ∀ i, p.ganancia i - p.deteccion i * p.deposito i ≤ p.recompensa i - p.costo i := by
  constructor
  · intro h i
    simpa [utilidad] using h i false
  · intro h i a
    cases a <;> simp [utilidad, h i]

theorem desviacion_unilateral_rentable {n : ℕ} (p : Pagos n) (i : Fin n)
    (h : p.recompensa i - p.costo i < p.ganancia i - p.deteccion i * p.deposito i) :
    ¬ Nash p (fun _ => true) := by
  intro hn
  exact (not_lt_of_ge ((honestidad_nash_iff p).mp hn i)) h

theorem deposito_suficiente {n : ℕ} (p : Pagos n)
    (h : ∀ i, p.ganancia i + p.costo i - p.recompensa i ≤ p.deteccion i * p.deposito i) :
    Nash p (fun _ => true) := by
  apply (honestidad_nash_iff p).mpr
  intro i
  linarith [h i]

end Nexus.Modelos.Incentivos

namespace Nexus.Modelos.Disponibilidad

/-- Propiedad MDS de evaluaciones: k valores distintos determinan el mensaje polinómico. -/
theorem recuperacion_reed_solomon {K I : Type*} [Field K] (indices : Finset I)
    (nodos : I → K) (hn : Set.InjOn nodos indices) (k : ℕ) (hk : k ≤ indices.card)
    (f g : Polynomial K) (hf : f.degree < k) (hg : g.degree < k)
    (he : ∀ i ∈ indices, f.eval (nodos i) = g.eval (nodos i)) : f = g := by
  apply Polynomial.eq_of_degrees_lt_of_eval_index_eq indices hn
  · exact hf.trans_le (by exact_mod_cast hk)
  · exact hg.trans_le (by exact_mod_cast hk)
  · exact he

theorem duplicar_no_recupera_dos_componentes (n : ℕ) :
    (fun _ : Fin n => ((0, 0) : ℚ × ℚ).1) = (fun _ : Fin n => ((0, 1) : ℚ × ℚ).1) ∧
      ((0, 0) : ℚ × ℚ) ≠ (0, 1) := by
  constructor
  · rfl
  · norm_num

end Nexus.Modelos.Disponibilidad
