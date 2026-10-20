module

public import Nexus.N03.Perfil
import Mathlib.Tactic

public section
namespace Nexus.Goldilocks

open Polynomial

theorem evaluacion_transicion_map (g : Fp) (A : Polynomial Fp) (x : Fp) :
    (Nexus.AIR.transicion (algebraMap Fp Fp2 g) (A.map (algebraMap Fp Fp2))).eval
      (algebraMap Fp Fp2 x) =
      algebraMap Fp Fp2 ((Nexus.AIR.transicion g A).eval x) := by
  simp only [Nexus.AIR.transicion, eval_sub, eval_comp, eval_mul, eval_C, eval_X, eval_pow]
  simp only [← map_pow, ← map_mul, eval_map_apply, ← map_sub]

/-- La validez AIR de un polinomio base se conserva y refleja al elevarlo. -/
theorem validez_air_map (T : ℕ) (g s o : Fp) (A : Polynomial Fp) :
    Nexus.AIR.Valida (algebraMap Fp Fp2 g) T (A.map (algebraMap Fp Fp2))
      (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o) ↔ Nexus.AIR.Valida g T A s o := by
  simp only [Nexus.AIR.Valida, ← map_one (algebraMap Fp Fp2), ← map_pow,
    eval_map_apply, evaluacion_transicion_map, ← map_zero (algebraMap Fp Fp2),
    (algebraMap Fp Fp2).injective.eq_iff]

theorem invalidez_candidato_base (k : ℕ) (s o : Fp) (f : Polynomial Fp2)
    (hf : f.natDegree < 2 ^ k)
    (hbase : ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o) :
    ¬ Nexus.AIR.Valida (raizExtension k) (2 ^ k) f
      (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o) := by
  have hB := (polinomio_base_iff_imaginaria_cero f).mp hbase
  have hmap : (parteReal f).map (algebraMap Fp Fp2) = f := by
    simpa only [hB, Polynomial.map_zero, mul_zero, add_zero] using (descomposicion_polinomio f).symm
  intro hv
  apply hfalso (parteReal f) ((grado_parte_real f).trans_lt hf)
  apply (validez_air_map (2 ^ k) (raiz k) s o (parteReal f)).mp
  simpa only [hmap, raizExtension] using hv

/-- Alternativa algebraica completa del candidato próximo a u para un enunciado falso.
La existencia del candidato se recibe explícitamente; no se infiere de aceptar una prueba. -/
theorem alternativa_candidato (k : ℕ) (hk : k ≤ 29) (s o : Fp) (u : Fp2 → Fp2)
    (f : Polynomial Fp2) (hf : f.natDegree < 2 ^ k) (δt δc : ℚ)
    (ht : 0 ≤ δt) (hc : 0 ≤ δc)
    (hu : Nexus.distancia (cosetExtension (k + 3)) u f.eval ≤ δt)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o) :
    ((∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) ∧
      ¬ Nexus.AIR.Valida (raizExtension k) (2 ^ k) f
        (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o)) ∨
    ((¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) ∧
      (5 * (2 ^ k : ℕ) + 1 : ℚ) / (8 * (2 ^ k : ℕ) : ℚ) - 3 * δt - δc + 1 / 4 ≤
        fraccionFueraBase (cosetExtension (k + 3)) u) := by
  classical
  by_cases hbase : ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f
  · exact Or.inl ⟨hbase, invalidez_candidato_base k s o f hf hbase hfalso⟩
  · exact Or.inr ⟨hbase, deteccion_no_base_perfil k hk u f hf hbase δt δc ht hc hu⟩

end Nexus.Goldilocks
