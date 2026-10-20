module

public import Nexus.AIR.CocientesAlejados
import Mathlib.Tactic

public section
namespace Nexus.AIR.GradosValidos

open Polynomial
variable {K : Type*} [Field K]

/-- La divisibilidad de frontera permite cancelar factores como polinomios. -/
theorem frontera_factoriza (D f : Polynomial K) (s a : K)
    (hD : X - C a ∣ D) (hf : f.eval a = s) :
    Nexus.AIR.frontera D f s a = D * ((f - C s) / (X - C a)) := by
  have hX := Polynomial.X_sub_C_ne_zero a
  have hd : X - C a ∣ f - C s := by
    apply Polynomial.dvd_iff_isRoot.mpr
    simpa [Polynomial.IsRoot] using sub_eq_zero.mpr hf
  have h1 := EuclideanDomain.mul_div_cancel' hX hd
  have h2 := EuclideanDomain.mul_div_cancel' hX hD
  unfold Nexus.AIR.frontera
  conv_lhs => rw [← h1]
  conv_rhs => rw [← h2]
  ring

theorem cociente_frontera_valida (D f : Polynomial K) (s a : K)
    (hD0 : D ≠ 0) (hD : X - C a ∣ D) (hf : f.eval a = s) :
    Nexus.AIR.frontera D f s a / D = (f - C s) / (X - C a) := by
  rw [frontera_factoriza D f s a hD hf, mul_div_cancel_left₀ _ hD0]

/-- La cota T-2 se refiere al cociente; la identidad racional exige validez aparte. -/
theorem grado_cociente_frontera (T : ℕ) (hT : 2 ≤ T) (f : Polynomial K)
    (s a : K) (hf : f.natDegree < T) :
    ((f - C s) / (X - C a)).natDegree ≤ T - 2 := by
  rw [← divByMonic_eq_div _ (monic_X_sub_C a),
    natDegree_divByMonic _ (monic_X_sub_C a), natDegree_sub_C, natDegree_X_sub_C]
  omega

theorem grado_cociente_transicion (T : ℕ) (hT : 3 ≤ T) (g : K)
    (hg : IsPrimitiveRoot g T) (f : Polynomial K) (hf : f.natDegree < T) :
    (Nexus.AIR.transicion g f / Nexus.AIR.Contraejemplo.anuladorTransiciones T g).natDegree ≤ T := by
  rw [← divByMonic_eq_div _ (Nexus.AIR.Contraejemplo.anulador_transiciones_monico T g),
    natDegree_divByMonic _ (Nexus.AIR.Contraejemplo.anulador_transiciones_monico T g),
    Nexus.AIR.Contraejemplo.grado_anulador_transiciones T (by omega) g hg]
  have h := Nexus.AIR.grado_transicion T g f hf
  omega

theorem grado_numerador_frontera (T : ℕ) (hT : 2 ≤ T) (f : Polynomial K)
    (s a : K) (hf : f.natDegree < T) :
    (Nexus.AIR.frontera (Nexus.AIR.denominador T) f s a).natDegree ≤ 2 * (T - 1) := by
  have hsub : (f - C s).natDegree ≤ T - 1 := by rw [natDegree_sub_C]; omega
  have hdiv : (Nexus.AIR.denominador T / (X - C a) : Polynomial K).natDegree = T - 1 := by
    rw [← divByMonic_eq_div _ (monic_X_sub_C a), natDegree_divByMonic _ (monic_X_sub_C a),
      Nexus.AIR.grado_denominador, natDegree_X_sub_C]
  unfold Nexus.AIR.frontera
  exact (natDegree_mul_le_of_le hsub hdiv.le).trans (by omega)

theorem numerador_valido_divisible (T : ℕ) (hT : 3 ≤ T) (g : K)
    (hg : IsPrimitiveRoot g T) (f : Polynomial K) (s o : K)
    (a : Nexus.N01.Coeficientes K) (hv : Nexus.AIR.Valida g T f s o) :
    Nexus.AIR.denominador T ∣ Nexus.AIR.numeradorCombinado T g f s o a := by
  have hr := (Nexus.AIR.validez_iff_residuos T g f s o hT hg).mp hv
  rw [← EuclideanDomain.mod_eq_zero]
  unfold Nexus.AIR.numeradorCombinado
  rw [Nexus.AIR.resto_combinacion, hr.1, hr.2.1, hr.2.2]
  simp [Nexus.N01.combinacion]

theorem factorizacion_valida (T : ℕ) (hT : 3 ≤ T) (g : K)
    (hg : IsPrimitiveRoot g T) (f : Polynomial K) (s o : K)
    (a : Nexus.N01.Coeficientes K) (hv : Nexus.AIR.Valida g T f s o) :
    Nexus.AIR.denominador T * Nexus.AIR.Contraejemplo.composicion T g f s o a =
      Nexus.AIR.numeradorCombinado T g f s o a := by
  apply EuclideanDomain.mul_div_cancel' _ (numerador_valido_divisible T hT g hg f s o a hv)
  exact (show (Nexus.AIR.denominador T : Polynomial K).Monic from
    by simpa [Nexus.AIR.denominador] using monic_X_pow_sub_C (1 : K) (by omega)).ne_zero

/-- El cociente euclídeo tiene esta cota incluso si el resto no es cero. -/
theorem grado_cociente_combinado (T : ℕ) (hT : 0 < T) (g : K)
    (f : Polynomial K) (s o : K) (a : Nexus.N01.Coeficientes K) (hf : f.natDegree < T) :
    (Nexus.AIR.Contraejemplo.composicion T g f s o a).natDegree ≤ T := by
  have hm : (Nexus.AIR.denominador T : Polynomial K).Monic := by
    simpa [Nexus.AIR.denominador] using monic_X_pow_sub_C (1 : K) hT.ne'
  rw [Nexus.AIR.Contraejemplo.composicion, ← divByMonic_eq_div _ hm,
    natDegree_divByMonic _ hm, Nexus.AIR.grado_denominador]
  have h := Nexus.AIR.grado_numerador_combinado T g f s o a hT hf
  omega

theorem evaluacion_composicion_valida (T : ℕ) (hT : 3 ≤ T) (g : K)
    (hg : IsPrimitiveRoot g T) (f : Polynomial K) (s o : K)
    (a : Nexus.N01.Coeficientes K) (hv : Nexus.AIR.Valida g T f s o)
    (x : K) (hx : (Nexus.AIR.denominador T : Polynomial K).eval x ≠ 0) :
    (Nexus.AIR.Contraejemplo.composicion T g f s o a).eval x =
      (Nexus.AIR.numeradorCombinado T g f s o a).eval x /
        (Nexus.AIR.denominador T : Polynomial K).eval x := by
  have he := congrArg (fun P : Polynomial K => P.eval x)
    (factorizacion_valida T hT g hg f s o a hv)
  rw [eval_mul] at he
  apply (eq_div_iff hx).mpr
  simpa only [mul_comm] using he

/-- Para una traza válida, la composición racional es de grado menor que 2T. -/
theorem certificado_valido (T : ℕ) (hT : 3 ≤ T) (g : K)
    (hg : IsPrimitiveRoot g T) (f : Polynomial K) (s o : K)
    (a : Nexus.N01.Coeficientes K) (hf : f.natDegree < T)
    (hv : Nexus.AIR.Valida g T f s o) :
    (Nexus.AIR.Contraejemplo.composicion T g f s o a).natDegree < 2 * T ∧
      ∀ x : K, (Nexus.AIR.denominador T : Polynomial K).eval x ≠ 0 →
        (Nexus.AIR.Contraejemplo.composicion T g f s o a).eval x =
          (Nexus.AIR.numeradorCombinado T g f s o a).eval x /
            (Nexus.AIR.denominador T : Polynomial K).eval x := by
  constructor
  · have h := grado_cociente_combinado T (by omega) g f s o a hf
    omega
  · exact fun x hx => evaluacion_composicion_valida T hT g hg f s o a hv x hx

end Nexus.AIR.GradosValidos
