module

public import Nexus.Distancia

public section
namespace Nexus.N04

/-- Acuerdo puntual sobre el conjunto indicado, sin cambiarlo entre funciones. -/
@[expose] def Sobre {K : Type*} [Field K] (S : Finset K)
    (u : K → K) (h : Polynomial K) : Prop := ∀ x ∈ S, u x = h.eval x

/-- Lema A en forma de conteo: t es el máximo número entero de desacuerdos.
La condición e+3t≤|L| expresa que toda intersección triple tiene al menos e puntos. -/
@[expose] def Enunciado (K : Type*) [Field K] : Prop :=
  ∀ (L : Finset K) (a b : K → K) (e t : ℕ),
    0 < L.card → 0 < e → e + 3 * t ≤ L.card →
    ∃ E : Finset K, E.card ≤ L.card ∧
      ∀ β, β ∉ E → ∀ (S : Finset K) (h : Polynomial K),
        S ⊆ L → L.card ≤ S.card + t → h.natDegree < e →
        Sobre S (fun x => a x + β * b x) h →
        ∃ A B : Polynomial K, A.natDegree < e ∧ B.natDegree < e ∧
          Sobre S a A ∧ Sobre S b B

/-- Forma con radio racional, que incluye θ=1/8 usado por NEXUS. -/
@[expose] def EnunciadoRadio (K : Type*) [Field K] : Prop :=
  ∀ (L : Finset K) (a b : K → K) (e : ℕ) (θ : ℚ),
    0 < L.card → 0 < e → 0 ≤ θ → (e : ℚ) - 1 < (1 - 3 * θ) * L.card →
    ∃ E : Finset K, E.card ≤ L.card ∧
      ∀ β, β ∉ E → ∀ (S : Finset K) (h : Polynomial K),
        S ⊆ L → (1 - θ) * L.card ≤ (S.card : ℚ) → h.natDegree < e →
        Sobre S (fun x => a x + β * b x) h →
        ∃ A B : Polynomial K, A.natDegree < e ∧ B.natDegree < e ∧
          Sobre S a A ∧ Sobre S b B

end Nexus.N04
