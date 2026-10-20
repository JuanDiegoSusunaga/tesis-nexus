module

public import Nexus.MLDSA.SelfTarget
import Mathlib.Tactic

/-!
# Alfabeto concreto de retos B_tau

Es el alfabeto polinómico de JMW24v2, con coeficientes centrados en
{-1,0,1} y exactamente tau coeficientes no nulos. La codificación externa,
SampleInBall y el acceso cuántico al oráculo requieren pruebas adicionales.
-/

public section
namespace Nexus.MLDSA.Retos

@[expose] noncomputable def soporte (w : Rq) : Finset (Fin n) := by
  classical
  exact Finset.univ.filter (fun i => centrado w i ≠ 0)

@[expose] def EsReto (t : ℕ) (w : Rq) : Prop :=
  (∀ i, centrado w i = -1 ∨ centrado w i = 0 ∨ centrado w i = 1) ∧ (soporte w).card = t

abbrev Reto (t : ℕ) := {w : Rq // EsReto t w}

@[expose] def codifica (t : ℕ) : Reto t ↪ Rq := ⟨Subtype.val, Subtype.val_injective⟩

theorem soporte_cero : soporte 0 = ∅ := by
  classical
  ext i
  simp [soporte, centrado, coeficiente_cero]

theorem reto_no_nulo (t : ℕ) (ht : 0 < t) (w : Reto t) : codifica t w ≠ 0 := by
  intro he
  have hc := w.property.2
  change w.val = 0 at he
  rw [he, soporte_cero, Finset.card_empty] at hc
  omega

theorem norma_reto_le_uno (t : ℕ) (w : Reto t) : normaRq w.val ≤ 1 := by
  apply (norma_le_iff _ _).mpr
  intro i
  rcases w.property.1 i with h | h | h <;> simp only [h] <;> norm_num

theorem norma_reto (t : ℕ) (ht : 0 < t) (w : Reto t) : normaRq w.val = 1 := by
  have hl := norma_reto_le_uno t w
  have hn : normaRq w.val ≠ 0 := fun h => reto_no_nulo t ht w ((normaRq_cero_iff _).mp h)
  omega

theorem peso_acotado (t : ℕ) (w : Reto t) : t ≤ n := by
  rw [← w.property.2]
  exact (Finset.card_le_card (Finset.filter_subset _ _)).trans (by simp)

@[expose] noncomputable def desdeSoporte (S : Finset (Fin n)) (signo : Fin n → Bool) : Rq := by
  classical
  exact claseCoeficientes (fun i => if i ∈ S then if signo i then (-1 : Fq) else 1 else 0)

theorem centrado_desde_soporte (S : Finset (Fin n)) (signo : Fin n → Bool) (i : Fin n) :
    centrado (desdeSoporte S signo) i =
      if i ∈ S then if signo i then (-1 : ℤ) else 1 else 0 := by
  classical
  apply centrado_unico
  · rw [desdeSoporte, coeficiente_claseCoeficientes]
    split_ifs <;> norm_num
  · split_ifs <;> norm_num [q]
  · split_ifs <;> norm_num [q]

theorem soporte_desde_soporte (S : Finset (Fin n)) (signo : Fin n → Bool) :
    soporte (desdeSoporte S signo) = S := by
  classical
  ext i
  simp only [soporte, Finset.mem_filter, Finset.mem_univ, true_and, centrado_desde_soporte]
  by_cases hi : i ∈ S
  · simp only [hi, ite_true]
    cases signo i <;> norm_num
  · simp [hi]

theorem desde_soporte_es_reto (S : Finset (Fin n)) (signo : Fin n → Bool) :
    EsReto S.card (desdeSoporte S signo) := by
  classical
  constructor
  · intro i
    rw [centrado_desde_soporte]
    split_ifs <;> simp
  · rw [soporte_desde_soporte]

theorem signo_determina_reto (S : Finset (Fin n)) (s t : Fin n → Bool)
    (h : ∀ i ∈ S, s i = t i) : desdeSoporte S s = desdeSoporte S t := by
  classical
  apply centrado_determina
  intro i
  rw [centrado_desde_soporte, centrado_desde_soporte]
  by_cases hi : i ∈ S
  · simp [hi, h i hi]
  · simp [hi]

theorem self_target_reto_concreto {m r : ℕ} {Mensaje Entrada : Type*} (t : ℕ)
    (enc : (Vector m × Mensaje) ↪ Entrada) (A : Matriz m (r + 1)) (H : Entrada → Reto t)
    (B : ℕ) (y : TestigoSelf m r) (mu : Mensaje) :
    SolucionSelfTarget (codifica t) enc A H B y mu ↔
      normaTestigoSelf y ≤ B ∧ (H (enc (valorSelf A y, mu))).val = ultimoSelf y := Iff.rfl

end Nexus.MLDSA.Retos
