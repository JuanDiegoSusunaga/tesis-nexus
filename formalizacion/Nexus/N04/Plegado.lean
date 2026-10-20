module

public import Nexus.N04.RadioReal
import Mathlib.Tactic

/-!
# Recuperación de una capa FRI por parejas opuestas

La función r elige la raíz usada para cada pareja: (r(y))²=y y r(y)≠0.
Se recupera un mismo polinomio sobre ambas mitades y el mismo conjunto de
acuerdo, salvo a lo sumo |L| retos. La iteración por todos los cosets y el
muestreo final del protocolo no se deducen solamente de este paso.
-/

public section
namespace Nexus.N04

open Polynomial
variable {K : Type*} [Field K]

@[expose] noncomputable def par (u r : K → K) (y : K) : K :=
  (u (r y) + u (-r y)) / 2

@[expose] noncomputable def impar (u r : K → K) (y : K) : K :=
  (u (r y) - u (-r y)) / (2 * r y)

@[expose] noncomputable def desplegar (A B : Polynomial K) : Polynomial K :=
  A.comp (X ^ 2) + X * B.comp (X ^ 2)

/-- La recomposición de dos polinomios de grado <e tiene grado <2e. -/
theorem grado_desplegado (A B : Polynomial K) (e : ℕ)
    (hA : A.natDegree < e) (hB : B.natDegree < e) :
    (desplegar A B).natDegree < 2 * e := by
  have h₂ : (X ^ 2 : Polynomial K).natDegree = 2 := by simp
  have ha : (A.comp (X ^ 2)).natDegree ≤ A.natDegree * 2 := by
    calc
      _ ≤ A.natDegree * (X ^ 2 : Polynomial K).natDegree := natDegree_comp_le
      _ = _ := by rw [h₂]
  have hb : (B.comp (X ^ 2)).natDegree ≤ B.natDegree * 2 := by
    calc
      _ ≤ B.natDegree * (X ^ 2 : Polynomial K).natDegree := natDegree_comp_le
      _ = _ := by rw [h₂]
  have hm := natDegree_mul_le (p := (X : Polynomial K)) (q := B.comp (X ^ 2))
  have hs := natDegree_add_le (A.comp (X ^ 2)) (X * B.comp (X ^ 2))
  simp only [natDegree_X] at hm
  unfold desplegar
  omega

theorem evaluacion_desplegado (A B : Polynomial K) (x : K) :
    (desplegar A B).eval x = A.eval (x ^ 2) + x * B.eval (x ^ 2) := by
  simp only [desplegar, eval_add, eval_comp, eval_pow, eval_X, eval_mul]

/-- Recuperación de los dos valores de una pareja; se excluyen 2=0 y la raíz cero. -/
theorem recomposicion_pareja (u r : K → K) (y : K) (h2 : (2 : K) ≠ 0)
    (hr : r y ≠ 0) :
    u (r y) = par u r y + r y * impar u r y ∧
      u (-r y) = par u r y - r y * impar u r y := by
  dsimp [par, impar]
  constructor <;> field_simp <;> ring

/-- Lema A aplicado al plegado real: recupera las dos mitades sobre el mismo S. -/
theorem recuperacion_capa (L : Finset K) (u r : K → K) (e : ℕ) (θ : ℝ)
    (hN : 0 < L.card) (he : 0 < e) (hθ : 0 ≤ θ)
    (hmargin : (e : ℝ) - 1 < (1 - 3 * θ) * L.card)
    (h2 : (2 : K) ≠ 0) (hr : ∀ y ∈ L, r y ≠ 0)
    (hcuadrado : ∀ y ∈ L, (r y) ^ 2 = y) :
    ∃ E : Finset K, E.card ≤ L.card ∧
      ∀ β, β ∉ E → ∀ (S : Finset K) (h : Polynomial K),
        S ⊆ L → (1 - θ) * L.card ≤ (S.card : ℝ) → h.natDegree < e →
        Sobre S (fun y => par u r y + β * impar u r y) h →
        ∃ P : Polynomial K, P.natDegree < 2 * e ∧
          ∀ y ∈ S, u (r y) = P.eval (r y) ∧ u (-r y) = P.eval (-r y) := by
  obtain ⟨E, hE, hgood⟩ := acuerdo_correlacionado_real L (par u r) (impar u r)
    e θ hN he hθ hmargin
  refine ⟨E, hE, ?_⟩
  intro β hβ S h hs hc hd ha
  obtain ⟨A, B, hA, hB, hAS, hBS⟩ := hgood β hβ S h hs hc hd ha
  refine ⟨desplegar A B, grado_desplegado A B e hA hB, ?_⟩
  intro y hy
  have hroot := hcuadrado y (hs hy)
  have hv := recomposicion_pareja u r y h2 (hr y (hs hy))
  rw [hAS y hy, hBS y hy] at hv
  simpa only [evaluacion_desplegado, neg_sq, hroot, neg_mul, ← sub_eq_add_neg] using hv

end Nexus.N04
