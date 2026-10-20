module

public import Nexus.AIR.Solucion
public import Mathlib.LinearAlgebra.Lagrange
import Mathlib.Tactic

public section
namespace Nexus.AIR.Contraejemplo

open Polynomial
variable {K : Type*} [Field K]

/-- Ejecución de la recurrencia del AIR desde sus dos primeras filas. -/
@[expose] def fila (s0 s1 : K) : ℕ → K
  | 0 => s0
  | 1 => s1
  | i + 2 => fila s0 s1 (i + 1) ^ 2 + fila s0 s1 i ^ 2

theorem fila_inicial (s0 s1 : K) : fila s0 s1 0 = s0 := rfl

theorem fila_segunda (s0 s1 : K) : fila s0 s1 1 = s1 := rfl

theorem fila_recurrencia (s0 s1 : K) (i : ℕ) :
    fila s0 s1 (i + 2) = fila s0 s1 (i + 1) ^ 2 + fila s0 s1 i ^ 2 := by
  rw [fila]

theorem fila_map {L : Type*} [Field L] (phi : K →+* L) (s0 s1 : K) (i : ℕ) :
    phi (fila s0 s1 i) = fila (phi s0) (phi s1) i := by
  induction i using Nat.strong_induction_on with
  | h i ih =>
    rcases i with _ | (_ | i)
    · rfl
    · rfl
    · simp only [fila_recurrencia, map_add, map_pow, ih (i + 1) (by omega), ih i (by omega)]

@[expose] noncomputable def interpolante (T : ℕ) (g s0 s1 : K) : Polynomial K :=
  Lagrange.interpolate (Finset.range T) (fun i => g ^ i) (fila s0 s1)

theorem evaluacion_interpolante (T : ℕ) (g s0 s1 : K) (hg : IsPrimitiveRoot g T)
    (i : ℕ) (hi : i < T) : (interpolante T g s0 s1).eval (g ^ i) = fila s0 s1 i := by
  apply Lagrange.eval_interpolate_at_node
  · intro a ha b hb hab
    exact hg.pow_inj (Finset.mem_range.mp ha) (Finset.mem_range.mp hb) hab
  · exact Finset.mem_range.mpr hi

theorem grado_interpolante (T : ℕ) (hT : 0 < T) (g s0 s1 : K) (hg : IsPrimitiveRoot g T) :
    (interpolante T g s0 s1).natDegree < T := by
  have hdeg : (interpolante T g s0 s1).degree < T := by
    have hd := Lagrange.degree_interpolate_lt (fila s0 s1)
      (show Set.InjOn (fun i => g ^ i) (Finset.range T) from fun a ha b hb hab =>
        hg.pow_inj (Finset.mem_range.mp ha) (Finset.mem_range.mp hb) hab)
    simpa only [interpolante, Finset.card_range] using hd
  by_cases h : interpolante T g s0 s1 = 0
  · simpa [h] using hT
  · exact (natDegree_lt_iff_degree_lt h).mpr hdeg

theorem interpolante_valido (T : ℕ) (hT : 3 ≤ T) (g s0 s1 : K) (hg : IsPrimitiveRoot g T) :
    Nexus.AIR.Valida g T (interpolante T g s0 s1) s0 (fila s0 s1 (T - 1)) := by
  refine ⟨?_, evaluacion_interpolante T g s0 s1 hg (T - 1) (by omega), ?_⟩
  · simpa only [pow_zero, fila_inicial] using evaluacion_interpolante T g s0 s1 hg 0 (by omega)
  · intro i hi
    have h1 : g * g ^ i = g ^ (i + 1) := by rw [pow_succ, mul_comm]
    have h2 : g ^ 2 * g ^ i = g ^ (i + 2) := by rw [pow_add, mul_comm]
    simp only [Nexus.AIR.transicion, eval_sub, eval_comp, eval_mul, eval_C, eval_X, eval_pow,
      h1, h2, evaluacion_interpolante T g s0 s1 hg i (by omega),
      evaluacion_interpolante T g s0 s1 hg (i + 1) (by omega),
      evaluacion_interpolante T g s0 s1 hg (i + 2) (by omega), fila_recurrencia]
    ring

theorem segunda_fila_interpolante (T : ℕ) (hT : 2 ≤ T) (g s0 s1 : K)
    (hg : IsPrimitiveRoot g T) : (interpolante T g s0 s1).eval g = s1 := by
  simpa only [pow_one, fila_segunda] using evaluacion_interpolante T g s0 s1 hg 1 (by omega)

end Nexus.AIR.Contraejemplo
