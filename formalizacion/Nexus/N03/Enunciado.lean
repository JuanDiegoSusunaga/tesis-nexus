module

public import Nexus.Distancia

public section
namespace Nexus.N03

/-- Unicidad de candidatos RS cercanos. No afirma que exista un candidato. -/
@[expose] def Enunciado (K : Type*) [Field K] : Prop :=
  ∀ (L : Finset K) (u : K → K) (f g : Polynomial K) (T : ℕ) (δ : ℚ),
    0 < L.card → T ≤ L.card →
    f.natDegree < T → g.natDegree < T →
    2 * δ < (L.card - T + 1 : ℕ) / (L.card : ℚ) →
    distancia L u f.eval ≤ δ → distancia L u g.eval ≤ δ → f = g

end Nexus.N03
