module

public import Nexus.MLDSA.Normas
public import Mathlib.Data.Int.Interval
import Mathlib.Tactic

public section
namespace Nexus.MLDSA

open Polynomial
open scoped BigOperators

/-- Construcción del polinomio de grado menor que 256 a partir de sus coeficientes. -/
@[expose] noncomputable def deCoeficientes {A : Type*} [CommRing A]
    (v : Fin n → A) : Polynomial A := ∑ i : Fin n, monomial i (v i)

theorem grado_deCoeficientes {A : Type*} [CommRing A] [Nontrivial A] (v : Fin n → A) :
    (deCoeficientes v).natDegree < n := by
  have hd : (deCoeficientes v).degree < n := by
    simpa only [deCoeficientes, ← C_mul_X_pow_eq_monomial] using degree_sum_fin_lt v
  by_cases h : deCoeficientes v = 0
  · simp [h, n]
  · exact (natDegree_lt_iff_degree_lt h).mpr hd

theorem coef_deCoeficientes {A : Type*} [CommRing A] (v : Fin n → A) (i : Fin n) :
    (deCoeficientes v).coeff i = v i := by
  classical
  simp only [deCoeficientes, finsetSum_coeff, coeff_monomial, Fin.val_eq_val,
    Finset.sum_ite_eq', Finset.mem_univ, ite_true]

@[expose] noncomputable def claseCoeficientes {A : Type*} [CommRing A]
    (v : Fin n → A) : Anillo A := AdjoinRoot.mk (moduloPolinomio A) (deCoeficientes v)

theorem representante_claseCoeficientes {A : Type*} [CommRing A] [Nontrivial A]
    (v : Fin n → A) : representante (claseCoeficientes v) = deCoeficientes v :=
  representante_grado_menor _ (grado_deCoeficientes v)

theorem coeficiente_claseCoeficientes {A : Type*} [CommRing A] [Nontrivial A]
    (v : Fin n → A) (i : Fin n) : coeficiente (claseCoeficientes v) i = v i := by
  rw [coeficiente, representante_claseCoeficientes, coef_deCoeficientes]

theorem claseCoeficientes_coeficiente {A : Type*} [CommRing A] [Nontrivial A] (w : Anillo A) :
    claseCoeficientes (coeficiente w) = w := by
  apply coeficiente_determina
  exact coeficiente_claseCoeficientes _

theorem claseCoeficientes_inyectiva {A : Type*} [CommRing A] [Nontrivial A] :
    Function.Injective (claseCoeficientes (A := A)) := by
  intro u v huv
  funext i
  have h := congrArg (fun w => coeficiente w i) huv
  simpa only [coeficiente_claseCoeficientes] using h

theorem deCoeficientes_map {A B : Type*} [CommRing A] [CommRing B]
    (f : A →+* B) (v : Fin n → A) :
    (deCoeficientes v).map f = deCoeficientes (fun i => f (v i)) := by
  simp only [deCoeficientes, Polynomial.map_sum, Polynomial.map_monomial]

theorem reduccion_coeficientes (v : Fin n → ℤ) :
    reduccion (claseCoeficientes v) = claseCoeficientes (fun i => (v i : Fq)) := by
  change reduccion (AdjoinRoot.mk (moduloPolinomio ℤ) (deCoeficientes v)) =
    AdjoinRoot.mk (moduloPolinomio Fq) (deCoeficientes (fun i => (v i : Fq)))
  rw [reduccion_clase, deCoeficientes_map]
  simp only [Int.coe_castRingHom]

set_option maxRecDepth 2048 in
theorem coeficiente_reduccion (w : R) (i : Fin n) :
    coeficiente (A := Fq) (reduccion w) i = (coeficiente (A := ℤ) w i : Fq) := by
  have hr := reduccion_coeficientes (coeficiente w)
  rw [claseCoeficientes_coeficiente w] at hr
  have hc := congrArg (fun u => coeficiente u i) hr
  exact hc.trans (coeficiente_claseCoeficientes _ i)

theorem coeficiente_suma {A : Type*} [CommRing A] (u v : Anillo A) (i : Fin n) :
    coeficiente (u + v) i = coeficiente u i + coeficiente v i := by
  exact congrArg (fun p : Polynomial A => p.coeff i)
    ((AdjoinRoot.modByMonicHom (modulo_monico A)).map_add u v) |>.trans (coeff_add _ _ _)

theorem coeficiente_resta {A : Type*} [CommRing A] (u v : Anillo A) (i : Fin n) :
    coeficiente (u - v) i = coeficiente u i - coeficiente v i := by
  exact congrArg (fun p : Polynomial A => p.coeff i)
    ((AdjoinRoot.modByMonicHom (modulo_monico A)).map_sub u v) |>.trans (coeff_sub _ _ _)

/-- Levantamiento centrado concreto del cociente modular al cociente entero. -/
@[expose] noncomputable def levanta (w : Rq) : R := claseCoeficientes (centrado w)

theorem coeficiente_levanta (w : Rq) (i : Fin n) : coeficiente (levanta w) i = centrado w i :=
  coeficiente_claseCoeficientes _ i

theorem reduccion_levanta (w : Rq) : reduccion (levanta w) = w := by
  rw [levanta, reduccion_coeficientes]
  apply coeficiente_determina
  intro i
  rw [coeficiente_claseCoeficientes, centrado_reduce]

theorem norma_levanta (w : Rq) : normaR (levanta w) = normaRq w := by
  unfold normaR normaRq
  congr 1
  funext i
  exact coeficiente_levanta w i

theorem levanta_inyectiva : Function.Injective levanta := by
  intro u v h
  simpa only [reduccion_levanta] using congrArg reduccion h

end Nexus.MLDSA
