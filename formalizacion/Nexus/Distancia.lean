module

public import Mathlib.Algebra.Polynomial.Roots
public import Mathlib.Data.Rat.Defs
import Mathlib.Tactic

public section
namespace Nexus

variable {K : Type*} [Field K]

/-- Número de discrepancias de dos funciones en puntos distintos de un dominio. -/
@[expose] noncomputable def errores (L : Finset K) (u v : K → K) : ℕ := by
  classical
  exact (L.filter (fun x => u x ≠ v x)).card

/-- Distancia Hamming relativa exacta, con valores racionales. -/
@[expose] noncomputable def distancia (L : Finset K) (u v : K → K) : ℚ :=
  errores L u v / (L.card : ℚ)

/-- Un polinomio no nulo tiene a lo sumo su grado en ceros distintos de L. -/
theorem ceros_acotados [DecidableEq K] (L : Finset K) (P : Polynomial K) (hP : P ≠ 0) :
    (L.filter (fun x => P.eval x = 0)).card ≤ P.natDegree := by
  classical
  apply Polynomial.card_le_degree_of_subset_roots
  intro x hx
  exact (Polynomial.mem_roots hP).mpr (Finset.mem_filter.mp hx).2

end Nexus
