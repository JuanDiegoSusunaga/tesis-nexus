module

public import Nexus.Distancia
public import Mathlib.Algebra.Polynomial.FieldDivision

public section
namespace Nexus.N02

/-- Cota determinista de N02, dadas las cotas de grado y el residuo no nulo.
Las fórmulas concretas de los numeradores AIR se verifican por separado. -/
@[expose] def Enunciado (K : Type*) [Field K] : Prop :=
  ∀ (T : ℕ) (L : Finset K) (A D h : Polynomial K),
    0 < T → L.card = 8 * T →
    (∀ x ∈ L, D.eval x ≠ 0) →
    A % D ≠ 0 → A.natDegree ≤ 2 * T → D.natDegree ≤ T → h.natDegree < 2 * T →
    (5 * T + 1 : ℚ) / (8 * T : ℚ) ≤
      distancia L (fun x => A.eval x / D.eval x) h.eval

end Nexus.N02
