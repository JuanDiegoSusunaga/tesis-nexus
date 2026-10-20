module

public import Nexus.AIR.Perturbacion
public import Nexus.AIR.Localidad
import Mathlib.Tactic

public section
namespace Nexus.AIR.Contraejemplo

open Polynomial
variable {K : Type*} [Field K]

theorem grado_transicion_cota (T : ℕ) (g : K) (F : Polynomial K) (hF : F.natDegree ≤ T) :
    (Nexus.AIR.transicion g F).natDegree ≤ 2 * T := by
  simpa using Nexus.AIR.grado_transicion (T + 1) g F (by omega)

theorem coeficiente_cuadrado (T : ℕ) (P : Polynomial K) (hP : P.natDegree ≤ T) :
    (P ^ 2).coeff (2 * T) = (P.coeff T) ^ 2 := by
  rw [pow_two, show 2 * T = T + T by omega, coeff_mul_add_eq_of_natDegree_le hP hP, pow_two]

theorem coeficiente_transicion (T : ℕ) (hT : 0 < T) (g : K) (hg : g ^ T = 1)
    (f : Polynomial K) (lambda : K) (hf : f.natDegree < T) (hl : lambda ≠ 0) :
    (Nexus.AIR.transicion g (perturbada T f lambda)).coeff (2 * T) = -2 * lambda ^ 2 := by
  have hF := grado_perturbada T f lambda hf hl
  have hcoef : (perturbada T f lambda).coeff T = lambda := by
    have hc := coeff_natDegree (p := perturbada T f lambda)
    rw [hF, coeficiente_principal T hT f lambda hf hl] at hc
    exact hc
  have hcomp := Nexus.AIR.grado_reescalado (perturbada T f lambda) (g ^ 2)
  rw [hF] at hcomp
  rw [Nexus.AIR.transicion, coeff_sub, coeff_sub,
    coeff_eq_zero_of_natDegree_lt (hcomp.trans_lt (by omega)),
    coeficiente_cuadrado T _ ((Nexus.AIR.grado_reescalado _ g).trans hF.le),
    coeficiente_cuadrado T _ hF.le, comp_C_mul_X_coeff, hcoef, hg]
  ring

theorem grado_transicion_exacto (T : ℕ) (hT : 0 < T) (g : K) (hg : g ^ T = 1)
    (f : Polynomial K) (lambda : K) (hf : f.natDegree < T) (hl : lambda ≠ 0)
    (h2 : (2 : K) ≠ 0) :
    (Nexus.AIR.transicion g (perturbada T f lambda)).natDegree = 2 * T := by
  apply natDegree_eq_of_le_of_coeff_ne_zero
    (grado_transicion_cota T g _ (grado_perturbada T f lambda hf hl).le)
  rw [coeficiente_transicion T hT g hg f lambda hf hl]
  exact mul_ne_zero (neg_ne_zero.mpr h2) (pow_ne_zero _ hl)

theorem principal_transicion (T : ℕ) (hT : 0 < T) (g : K) (hg : g ^ T = 1)
    (f : Polynomial K) (lambda : K) (hf : f.natDegree < T) (hl : lambda ≠ 0)
    (h2 : (2 : K) ≠ 0) :
    (Nexus.AIR.transicion g (perturbada T f lambda)).leadingCoeff = -2 * lambda ^ 2 := by
  rw [← coeff_natDegree, grado_transicion_exacto T hT g hg f lambda hf hl h2]
  exact coeficiente_transicion T hT g hg f lambda hf hl

theorem grado_cociente_frontera (T : ℕ) (f : Polynomial K) (lambda s a : K)
    (hf : f.natDegree < T) (hl : lambda ≠ 0) :
    ((perturbada T f lambda - C s) / (X - C a)).natDegree = T - 1 := by
  rw [← divByMonic_eq_div _ (monic_X_sub_C a), natDegree_divByMonic _ (monic_X_sub_C a),
    natDegree_sub_C, grado_perturbada T f lambda hf hl, natDegree_X_sub_C]

theorem grado_frontera_cota (T : ℕ) (F : Polynomial K) (s a : K) (hF : F.natDegree ≤ T) :
    (Nexus.AIR.frontera (Nexus.AIR.denominador T) F s a).natDegree ≤ 2 * T := by
  have hdiv : ((Nexus.AIR.denominador T : Polynomial K) / (X - C a)).natDegree ≤ T :=
    (natDegree_le_natDegree (degree_div_le _ _)).trans (Nexus.AIR.grado_denominador T).le
  exact (natDegree_mul_le_of_le
    (show (F - C s).natDegree ≤ T by rwa [natDegree_sub_C]) hdiv).trans (by omega)

theorem grado_numerador_cota (T : ℕ) (g : K) (F : Polynomial K) (s o : K)
    (a : Nexus.N01.Coeficientes K) (hF : F.natDegree ≤ T) :
    (Nexus.AIR.numeradorCombinado T g F s o a).natDegree ≤ 2 * T + 2 := by
  have h0 := (grado_frontera_cota T F s 1 hF).trans (show 2 * T ≤ 2 * T + 2 by omega)
  have h1 := (grado_frontera_cota T F o (g ^ (T - 1)) hF).trans
    (show 2 * T ≤ 2 * T + 2 by omega)
  have h2 : (Nexus.AIR.numeradorTransicion g F (g ^ (T - 1)) (g ^ (T - 2))).natDegree ≤
      2 * T + 2 := by
    exact (natDegree_mul_le_of_le
      (natDegree_mul_le_of_le (grado_transicion_cota T g F hF)
        (natDegree_X_sub_C _).le) (natDegree_X_sub_C _).le).trans (by omega)
  unfold Nexus.AIR.numeradorCombinado Nexus.N01.combinacion
  simpa only [max_self] using natDegree_add_le_of_le
    (natDegree_add_le_of_le ((natDegree_smul_le a.1 _).trans h0)
      ((natDegree_smul_le a.2.1 _).trans h1)) ((natDegree_smul_le a.2.2 _).trans h2)

/-- Cociente polinómico de la composición racional; la divisibilidad se prueba aparte. -/
@[expose] noncomputable def composicion (T : ℕ) (g : K) (F : Polynomial K) (s o : K)
    (a : Nexus.N01.Coeficientes K) : Polynomial K :=
  Nexus.AIR.numeradorCombinado T g F s o a / Nexus.AIR.denominador T

theorem grado_composicion (T : ℕ) (hT : 0 < T) (g : K) (f : Polynomial K)
    (lambda s o : K) (a : Nexus.N01.Coeficientes K) (hf : f.natDegree < T)
    (hl : lambda ≠ 0) :
    (composicion T g (perturbada T f lambda) s o a).natDegree ≤ T + 2 := by
  have hm : (Nexus.AIR.denominador T : Polynomial K).Monic := by
    simpa [Nexus.AIR.denominador] using monic_X_pow_sub_C (1 : K) hT.ne'
  rw [composicion, ← divByMonic_eq_div _ hm, natDegree_divByMonic _ hm,
    Nexus.AIR.grado_denominador]
  have h := grado_numerador_cota T g (perturbada T f lambda) s o a
    (grado_perturbada T f lambda hf hl).le
  omega

theorem grado_composicion_objetivo (T : ℕ) (hT : 4 ≤ T) (g : K) (f : Polynomial K)
    (lambda s o : K) (a : Nexus.N01.Coeficientes K) (hf : f.natDegree < T)
    (hl : lambda ≠ 0) :
    (composicion T g (perturbada T f lambda) s o a).natDegree < 2 * T := by
  have h := grado_composicion T (by omega) g f lambda s o a hf hl
  omega

theorem numerador_divisible (T : ℕ) (hT : 3 ≤ T) (g : K) (hg : IsPrimitiveRoot g T)
    (f : Polynomial K) (lambda s o : K) (a : Nexus.N01.Coeficientes K)
    (hv : Nexus.AIR.Valida g T f s o) :
    Nexus.AIR.denominador T ∣ Nexus.AIR.numeradorCombinado T g (perturbada T f lambda) s o a := by
  have hr := residuos_nulos T hT g hg f lambda s o hv
  rw [← EuclideanDomain.mod_eq_zero]
  unfold Nexus.AIR.numeradorCombinado
  rw [Nexus.AIR.resto_combinacion, hr.1, hr.2.1, hr.2.2]
  simp [Nexus.N01.combinacion]

theorem evaluacion_composicion (T : ℕ) (hT : 3 ≤ T) (g : K) (hg : IsPrimitiveRoot g T)
    (f : Polynomial K) (lambda s o : K) (a : Nexus.N01.Coeficientes K)
    (hv : Nexus.AIR.Valida g T f s o) (x : K)
    (hx : (Nexus.AIR.denominador T : Polynomial K).eval x ≠ 0) :
    (composicion T g (perturbada T f lambda) s o a).eval x =
      (Nexus.AIR.numeradorCombinado T g (perturbada T f lambda) s o a).eval x /
        (Nexus.AIR.denominador T : Polynomial K).eval x := by
  have hd := numerador_divisible T hT g hg f lambda s o a hv
  have hD0 : (Nexus.AIR.denominador T : Polynomial K) ≠ 0 := by
    intro h
    exact hx (by rw [h, eval_zero])
  have he := congrArg (fun P : Polynomial K => P.eval x)
    (EuclideanDomain.mul_div_cancel' hD0 hd)
  rw [eval_mul] at he
  apply (eq_div_iff hx).mpr
  simpa only [composicion, mul_comm] using he

end Nexus.AIR.Contraejemplo
