module

public import Nexus.AIR.Grados
public import Nexus.AIR.DistanciaExacta
import Mathlib.Tactic

public section
namespace Nexus.AIR.Contraejemplo

open Polynomial
variable {K : Type*} [Field K]

/-- Familia alejada de §6.7.3, conservando la ejecución en las filas. -/
@[expose] noncomputable def perturbada (T : ℕ) (f : Polynomial K) (lambda : K) : Polynomial K :=
  f + C lambda * Nexus.AIR.denominador T

theorem grado_perturbacion (T : ℕ) (lambda : K) (hl : lambda ≠ 0) :
    (C lambda * Nexus.AIR.denominador T).natDegree = T := by
  rw [natDegree_C_mul hl, Nexus.AIR.grado_denominador]

theorem grado_perturbada (T : ℕ) (f : Polynomial K) (lambda : K)
    (hf : f.natDegree < T) (hl : lambda ≠ 0) : (perturbada T f lambda).natDegree = T := by
  rw [perturbada, natDegree_add_eq_right_of_natDegree_lt]
  · exact grado_perturbacion T lambda hl
  · rwa [grado_perturbacion T lambda hl]

theorem coeficiente_principal (T : ℕ) (hT : 0 < T) (f : Polynomial K) (lambda : K)
    (hf : f.natDegree < T) (hl : lambda ≠ 0) :
    (perturbada T f lambda).leadingCoeff = lambda := by
  rw [perturbada, leadingCoeff_add_of_degree_lt]
  · rw [leadingCoeff_mul, leadingCoeff_C]
    have hm : (Nexus.AIR.denominador T : Polynomial K).Monic := by
      simpa [Nexus.AIR.denominador] using monic_X_pow_sub_C (1 : K) hT.ne'
    rw [hm.leadingCoeff, mul_one]
  · apply degree_lt_degree
    rwa [grado_perturbacion T lambda hl]

theorem evaluacion_perturbada (T : ℕ) (f : Polynomial K) (lambda x : K) :
    (perturbada T f lambda).eval x = f.eval x + lambda * (x ^ T - 1) := by
  simp [perturbada, Nexus.AIR.denominador]

theorem coincide_en_fila (T : ℕ) (f : Polynomial K) (lambda x : K) (hx : x ^ T = 1) :
    (perturbada T f lambda).eval x = f.eval x := by
  rw [evaluacion_perturbada, hx]
  ring

theorem coincide_en_potencias (T : ℕ) (f : Polynomial K) (lambda g : K)
    (hg : g ^ T = 1) (i : ℕ) :
    (perturbada T f lambda).eval (g ^ i) = f.eval (g ^ i) := by
  apply coincide_en_fila
  rw [← pow_mul, Nat.mul_comm, pow_mul, hg, one_pow]

theorem transicion_en_filas (T : ℕ) (f : Polynomial K) (lambda g : K)
    (hg : g ^ T = 1) (i : ℕ) :
    (Nexus.AIR.transicion g (perturbada T f lambda)).eval (g ^ i) =
      (Nexus.AIR.transicion g f).eval (g ^ i) := by
  have hp (j : ℕ) : g ^ j * g ^ i = g ^ (j + i) := (pow_add _ _ _).symm
  simp only [Nexus.AIR.transicion, eval_sub, eval_comp, eval_pow, eval_mul, eval_C, eval_X,
    hp, coincide_en_potencias T f lambda g hg]
  rw [show g * g ^ i = g ^ (1 + i) by rw [pow_add, pow_one],
    coincide_en_potencias T f lambda g hg]

theorem validez_conservada (T : ℕ) (g : K) (hg : g ^ T = 1)
    (f : Polynomial K) (lambda s o : K) :
    Nexus.AIR.Valida g T (perturbada T f lambda) s o ↔ Nexus.AIR.Valida g T f s o := by
  simp only [Nexus.AIR.Valida, coincide_en_fila T f lambda 1 (one_pow T),
    coincide_en_potencias T f lambda g hg, transicion_en_filas T f lambda g hg]

theorem residuos_nulos (T : ℕ) (hT : 3 ≤ T) (g : K) (hg : IsPrimitiveRoot g T)
    (f : Polynomial K) (lambda s o : K) (hv : Nexus.AIR.Valida g T f s o) :
    Nexus.AIR.ResiduosNulos g T (perturbada T f lambda) s o :=
  (Nexus.AIR.validez_iff_residuos T g _ s o hT hg).mp
    ((validez_conservada T g hg.pow_eq_one f lambda s o).mpr hv)

theorem difiere_fuera_filas (T : ℕ) (f : Polynomial K) (lambda x : K)
    (hl : lambda ≠ 0) (hx : x ^ T ≠ 1) :
    (perturbada T f lambda).eval x ≠ f.eval x := by
  rw [evaluacion_perturbada]
  intro h
  apply mul_ne_zero hl (sub_ne_zero.mpr hx)
  exact add_left_cancel (h.trans (add_zero _).symm)

theorem errores_todos (T : ℕ) (f : Polynomial K) (lambda : K) (hl : lambda ≠ 0)
    (L : Finset K) (hL : ∀ x ∈ L, x ^ T ≠ 1) :
    Nexus.errores L (perturbada T f lambda).eval f.eval = L.card := by
  classical
  apply congrArg Finset.card
  apply Finset.filter_eq_self.mpr
  intro x hx
  exact difiere_fuera_filas T f lambda x hl (hL x hx)

theorem distancia_del_testigo (T : ℕ) (f : Polynomial K) (lambda : K) (hl : lambda ≠ 0)
    (L : Finset K) (hL : ∀ x ∈ L, x ^ T ≠ 1) (hL0 : L.Nonempty) :
    Nexus.distancia L (perturbada T f lambda).eval f.eval = 1 := by
  rw [Nexus.distancia, errores_todos T f lambda hl L hL]
  exact div_self (by exact_mod_cast hL0.card_pos.ne')

theorem minimo_siete_octavos (T : ℕ) (hT : 0 < T) (f : Polynomial K) (lambda : K)
    (hf : f.natDegree < T) (hl : lambda ≠ 0) (L : Finset K) (hL : L.card = 8 * T) :
    IsLeast {d : ℚ | ∃ h : Polynomial K, h.natDegree < T ∧
      Nexus.distancia L (perturbada T f lambda).eval h.eval = d} (7 / 8) :=
  distancia_exacta_siete_octavos T hT L hL _ (grado_perturbada T f lambda hf hl)

end Nexus.AIR.Contraejemplo
