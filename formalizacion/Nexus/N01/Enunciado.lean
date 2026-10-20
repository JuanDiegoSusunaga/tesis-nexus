module

public import Mathlib.Algebra.Polynomial.Basic
public import Mathlib.Data.Fintype.Prod
public import Mathlib.Data.Rat.Defs

/-! # N01: cancelación de tres residuos fijados antes de los retos. -/

public section
namespace Nexus.N01

variable {K : Type*} [Field K] [Fintype K]

/-- Tres coeficientes uniformes independientes se modelan por el producto K³. -/
abbrev Coeficientes (K : Type*) := K × K × K

/-- Combinación de los residuos individuales; los residuos son parámetros fijos. -/
@[expose] noncomputable def combinacion (r₀ r₁ r₂ : Polynomial K) (a : Coeficientes K) : Polynomial K :=
  a.1 • r₀ + a.2.1 • r₁ + a.2.2 • r₂

/-- Resultados del espacio uniforme producto que anulan todo el residuo. -/
@[expose] noncomputable def cancelantes (r₀ r₁ r₂ : Polynomial K) : Finset (Coeficientes K) := by
  classical
  exact Finset.univ.filter (fun a => combinacion r₀ r₁ r₂ a = 0)

/-- Probabilidad exacta por conteo en el espacio uniforme producto, en ℚ. -/
@[expose] noncomputable def probabilidad (r₀ r₁ r₂ : Polynomial K) : ℚ :=
  (cancelantes r₀ r₁ r₂).card / (Fintype.card K : ℚ) ^ 3

/-- Forma matemática de N01, parametrizada por un campo finito arbitrario. -/
@[expose] def Enunciado (K : Type*) [Field K] [Fintype K] : Prop :=
  ∀ r₀ r₁ r₂ : Polynomial K, r₀ ≠ 0 ∨ r₁ ≠ 0 ∨ r₂ ≠ 0 →
    probabilidad r₀ r₁ r₂ ≤ 1 / (Fintype.card K : ℚ)

end Nexus.N01
