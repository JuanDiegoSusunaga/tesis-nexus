module

public import Nexus.N01.Enunciado
public import Mathlib.Algebra.Polynomial.Roots
public import Mathlib.Algebra.Polynomial.FieldDivision
public import Mathlib.RingTheory.RootsOfUnity.PrimitiveRoots

/-! # AIR demostrativo de la tesis: fronteras, transición y residuos individuales. -/

public section
namespace Nexus.AIR

open Polynomial
variable {K : Type*} [Field K]

/-- Polinomio anulador de puntos distintos. -/
@[expose] noncomputable def anulador (H : Finset K) : Polynomial K :=
  ∏ x ∈ H, (X - C x)

/-- Dominio de filas H={1,g,...,g^(T-1)}. -/
@[expose] noncomputable def dominio (g : K) (T : ℕ) : Finset K := by
  classical
  exact (Finset.range T).image (fun i => g ^ i)

@[expose] noncomputable def denominador (T : ℕ) : Polynomial K := X ^ T - 1

/-- C_f(X)=f(g²X)-f(gX)²-f(X)², la recurrencia AIR del manuscrito. -/
@[expose] noncomputable def transicion (g : K) (f : Polynomial K) : Polynomial K :=
  f.comp (C (g ^ 2) * X) - (f.comp (C g * X)) ^ 2 - f ^ 2

@[expose] noncomputable def frontera (D f : Polynomial K) (s a : K) : Polynomial K :=
  (f - C s) * (D / (X - C a))

@[expose] noncomputable def numeradorTransicion (g : K) (f : Polynomial K)
    (h₁ h₂ : K) : Polynomial K :=
  transicion g f * (X - C h₁) * (X - C h₂)

@[expose] def Valida (g : K) (T : ℕ) (f : Polynomial K) (s o : K) : Prop :=
  f.eval 1 = s ∧ f.eval (g ^ (T - 1)) = o ∧
    ∀ i : ℕ, i < T - 2 → (transicion g f).eval (g ^ i) = 0

@[expose] def ResiduosNulos (g : K) (T : ℕ) (f : Polynomial K) (s o : K) : Prop :=
  frontera (denominador T) f s 1 % denominador T = 0 ∧
  frontera (denominador T) f o (g ^ (T - 1)) % denominador T = 0 ∧
  numeradorTransicion g f (g ^ (T - 1)) (g ^ (T - 2)) % denominador T = 0

/-- Equivalencia del manuscrito para cualquier campo con una raíz de orden T.
No necesita suponer grado(f)<T; por tanto también cubre el caso de la tesis. -/
@[expose] def Enunciado (K : Type*) [Field K] : Prop :=
  ∀ (T : ℕ) (g : K) (f : Polynomial K) (s o : K),
    3 ≤ T → IsPrimitiveRoot g T → (Valida g T f s o ↔ ResiduosNulos g T f s o)

end Nexus.AIR
