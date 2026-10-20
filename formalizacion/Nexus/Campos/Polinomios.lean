module

public import Nexus.Campos.Goldilocks
import Mathlib.Tactic

public section
namespace Nexus.Goldilocks

open Polynomial

/-- Pertenencia a la imagen de la inmersión del campo base. -/
@[expose] def EsBase (z : Fp2) : Prop := ∃ x : Fp, algebraMap Fp Fp2 x = z

theorem esBase_iff_im_cero (z : Fp2) : EsBase z ↔ z.im = 0 := by
  constructor
  · rintro ⟨x, rfl⟩
    simp
  · intro h
    refine ⟨z.re, ?_⟩
    ext <;> simp [h]

instance (z : Fp2) : Decidable (EsBase z) :=
  decidable_of_iff (z.im = 0) (esBase_iff_im_cero z).symm

@[expose] noncomputable def parteReal (f : Polynomial Fp2) : Polynomial Fp :=
  f.sum fun n c => monomial n c.re

@[expose] noncomputable def parteImaginaria (f : Polynomial Fp2) : Polynomial Fp :=
  f.sum fun n c => monomial n c.im

theorem coeficiente_real (f : Polynomial Fp2) (n : ℕ) :
    (parteReal f).coeff n = (f.coeff n).re := by
  classical
  by_cases hn : n ∈ f.support
  · simp [parteReal, Polynomial.sum, coeff_monomial, hn]
  · have hzero : f.coeff n = 0 := notMem_support_iff.mp hn
    simp [parteReal, Polynomial.sum, coeff_monomial, hn, hzero]

theorem coeficiente_imaginario (f : Polynomial Fp2) (n : ℕ) :
    (parteImaginaria f).coeff n = (f.coeff n).im := by
  classical
  by_cases hn : n ∈ f.support
  · simp [parteImaginaria, Polynomial.sum, coeff_monomial, hn]
  · have hzero : f.coeff n = 0 := notMem_support_iff.mp hn
    simp [parteImaginaria, Polynomial.sum, coeff_monomial, hn, hzero]

theorem grado_parte_real (f : Polynomial Fp2) :
    (parteReal f).natDegree ≤ f.natDegree := by
  apply natDegree_le_iff_coeff_eq_zero.mpr
  intro n hn
  rw [coeficiente_real, coeff_eq_zero_of_natDegree_lt hn]
  simp

theorem grado_parte_imaginaria (f : Polynomial Fp2) :
    (parteImaginaria f).natDegree ≤ f.natDegree := by
  apply natDegree_le_iff_coeff_eq_zero.mpr
  intro n hn
  rw [coeficiente_imaginario, coeff_eq_zero_of_natDegree_lt hn]
  simp

theorem imaginaria_suma (f g : Polynomial Fp2) :
    parteImaginaria (f + g) = parteImaginaria f + parteImaginaria g := by
  ext n
  simp [coeficiente_imaginario]

theorem imaginaria_monomio (n : ℕ) (c : Fp2) :
    parteImaginaria (monomial n c) = monomial n c.im := by
  simp [parteImaginaria]

theorem evaluacion_imaginaria (f : Polynomial Fp2) (x : Fp) :
    (parteImaginaria f).eval x = (f.eval (algebraMap Fp Fp2 x)).im := by
  induction f using Polynomial.induction_on' with
  | add f g hf hg => simp [imaginaria_suma, hf, hg]
  | monomial n c =>
    simp [imaginaria_monomio, eval_monomial, ← map_pow]

theorem evaluacion_es_base (f : Polynomial Fp2) (x : Fp) :
    EsBase (f.eval (algebraMap Fp Fp2 x)) ↔ (parteImaginaria f).eval x = 0 := by
  rw [esBase_iff_im_cero, evaluacion_imaginaria]

/-- La descomposición f=A+zB se construye a partir de sus coeficientes. -/
theorem descomposicion_polinomio (f : Polynomial Fp2) :
    f = (parteReal f).map (algebraMap Fp Fp2) +
      C (QuadraticAlgebra.omega : Fp2) * (parteImaginaria f).map (algebraMap Fp Fp2) := by
  apply Polynomial.ext
  intro n
  rw [coeff_add, coeff_C_mul, coeff_map, coeff_map, coeficiente_real, coeficiente_imaginario]
  ext <;> simp [QuadraticAlgebra.omega]

theorem polinomio_base_iff_imaginaria_cero (f : Polynomial Fp2) :
    (∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) ↔ parteImaginaria f = 0 := by
  constructor
  · rintro ⟨A, rfl⟩
    ext n
    simp [coeficiente_imaginario]
  · intro h
    refine ⟨parteReal f, ?_⟩
    simpa only [h, Polynomial.map_zero, mul_zero, add_zero] using (descomposicion_polinomio f).symm

end Nexus.Goldilocks
