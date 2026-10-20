module

public import Nexus.AIR.Enunciado
import Mathlib.Tactic

public section
namespace Nexus.AIR

open Polynomial
variable {K : Type*} [Field K]

theorem grado_reescalado (f : Polynomial K) (a : K) :
    (f.comp (C a * X)).natDegree ≤ f.natDegree := by
  calc
    _ ≤ f.natDegree * (C a * X).natDegree := natDegree_comp_le
    _ ≤ f.natDegree * 1 := Nat.mul_le_mul_left _
      ((natDegree_C_mul_le a X).trans natDegree_X_le)
    _ = _ := Nat.mul_one _

theorem grado_transicion (T : ℕ) (g : K) (f : Polynomial K) (hf : f.natDegree < T) :
    (transicion g f).natDegree ≤ 2 * (T - 1) := by
  have hf' : f.natDegree ≤ T - 1 := by omega
  have h1 := (grado_reescalado f (g ^ 2)).trans hf'
  have h2 := (natDegree_pow_le_of_le 2 ((grado_reescalado f g).trans hf'))
  have h3 := natDegree_pow_le_of_le 2 hf'
  have h1' : (f.comp (C (g ^ 2) * X)).natDegree ≤ 2 * (T - 1) := by omega
  simpa only [transicion, max_self] using
    natDegree_sub_le_of_le (natDegree_sub_le_of_le h1' h2) h3

theorem grado_numerador_transicion (T : ℕ) (g h1 h2 : K) (f : Polynomial K)
    (hT : 0 < T) (hf : f.natDegree < T) :
    (numeradorTransicion g f h1 h2).natDegree ≤ 2 * T := by
  have hdeg := natDegree_mul_le_of_le
    (natDegree_mul_le_of_le (grado_transicion T g f hf)
      (natDegree_X_sub_C h1).le) (natDegree_X_sub_C h2).le
  unfold numeradorTransicion
  exact hdeg.trans (by omega)

theorem grado_denominador (T : ℕ) :
    (denominador T : Polynomial K).natDegree = T := by
  simpa [denominador] using (natDegree_X_pow_sub_C (R := K) (n := T) (r := 1))

theorem grado_frontera (T : ℕ) (f : Polynomial K) (s a : K) (hf : f.natDegree < T) :
    (frontera (denominador T) f s a).natDegree ≤ 2 * T := by
  have hf' : f.natDegree ≤ T - 1 := by omega
  have hsub : (f - C s).natDegree ≤ T - 1 := by
    simpa only [natDegree_C, max_eq_left (Nat.zero_le _)] using
      natDegree_sub_le_of_le hf' (show (C s).natDegree ≤ 0 from (natDegree_C s).le)
  have hdiv : (denominador T / (X - C a) : Polynomial K).natDegree ≤ T := by
    calc
      _ ≤ (denominador T : Polynomial K).natDegree :=
        natDegree_le_natDegree (degree_div_le _ _)
      _ = T := grado_denominador T
  exact (natDegree_mul_le_of_le hsub hdiv).trans (by omega)

theorem grado_combinacion (T : ℕ) (r0 r1 r2 : Polynomial K)
    (a : Nexus.N01.Coeficientes K) (h0 : r0.natDegree ≤ 2 * T)
    (h1 : r1.natDegree ≤ 2 * T) (h2 : r2.natDegree ≤ 2 * T) :
    (Nexus.N01.combinacion r0 r1 r2 a).natDegree ≤ 2 * T := by
  simpa only [Nexus.N01.combinacion, max_self] using
    natDegree_add_le_of_le
      (natDegree_add_le_of_le ((natDegree_smul_le a.1 r0).trans h0)
        ((natDegree_smul_le a.2.1 r1).trans h1))
      ((natDegree_smul_le a.2.2 r2).trans h2)

/-- Numerador AIR A_alpha antes de dividir por X^T-1. -/
@[expose] noncomputable def numeradorCombinado (T : ℕ) (g : K)
    (f : Polynomial K) (s o : K) (a : Nexus.N01.Coeficientes K) : Polynomial K :=
  Nexus.N01.combinacion (frontera (denominador T) f s 1)
    (frontera (denominador T) f o (g ^ (T - 1)))
    (numeradorTransicion g f (g ^ (T - 1)) (g ^ (T - 2))) a

theorem grado_numerador_combinado (T : ℕ) (g : K) (f : Polynomial K) (s o : K)
    (a : Nexus.N01.Coeficientes K) (hT : 0 < T) (hf : f.natDegree < T) :
    (numeradorCombinado T g f s o a).natDegree ≤ 2 * T :=
  grado_combinacion T _ _ _ a (grado_frontera T f s 1 hf)
    (grado_frontera T f o _ hf) (grado_numerador_transicion T g _ _ f hT hf)

end Nexus.AIR
