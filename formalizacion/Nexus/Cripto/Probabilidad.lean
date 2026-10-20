module

public import Mathlib.Probability.ProbabilityMassFunction.Constructions
import Mathlib.Tactic

public section
namespace Nexus.Cripto

open scoped BigOperators ENNReal
variable {A B : Type*}

/-- Probabilidad discreta de un predicado, también sobre mensajes o registros infinitos. -/
@[expose] noncomputable def probabilidad (p : PMF A) (E : A → Prop) : ℝ≥0∞ :=
  p.toOuterMeasure {x | E x}

theorem probabilidad_uno (p : PMF A) : probabilidad p (fun _ => True) = 1 := by
  simp [probabilidad, PMF.toOuterMeasure_apply, PMF.tsum_coe]

theorem probabilidad_cero (p : PMF A) : probabilidad p (fun _ => False) = 0 := by
  simp [probabilidad]

theorem probabilidad_monotona (p : PMF A) (E F : A → Prop) (h : ∀ x, E x → F x) :
    probabilidad p E ≤ probabilidad p F := p.toOuterMeasure.mono h

theorem probabilidad_congruente_soporte (p : PMF A) (E F : A → Prop)
    (h : ∀ x ∈ p.support, E x ↔ F x) : probabilidad p E = probabilidad p F := by
  apply p.toOuterMeasure_apply_eq_of_inter_support_eq
  ext x
  exact and_congr_left (fun hx => h x hx)

theorem probabilidad_le_uno (p : PMF A) (E : A → Prop) : probabilidad p E ≤ 1 := by
  rw [← probabilidad_uno p]
  exact probabilidad_monotona p E _ (fun _ _ => trivial)

theorem probabilidad_finita (p : PMF A) (E : A → Prop) : probabilidad p E ≠ ⊤ :=
  ne_of_lt ((probabilidad_le_uno p E).trans_lt ENNReal.one_lt_top)

theorem probabilidad_pura (x : A) (E : A → Prop) [DecidablePred E] :
    probabilidad (PMF.pure x) E = if E x then 1 else 0 := by
  by_cases h : E x <;> simp [probabilidad, h]

theorem probabilidad_map (p : PMF A) (f : A → B) (E : B → Prop) :
    probabilidad (p.map f) E = probabilidad p (fun x => E (f x)) :=
  PMF.toOuterMeasure_map_apply f p {x | E x}

theorem probabilidad_bind (p : PMF A) (f : A → PMF B) (E : B → Prop) :
    probabilidad (p.bind f) E = ∑' x, p x * probabilidad (f x) E :=
  PMF.toOuterMeasure_bind_apply p f {x | E x}

theorem probabilidad_predicado (p : PMF A) (E : A → Prop) [DecidablePred E] :
    probabilidad (p.bind (fun x => PMF.pure (decide (E x)))) (fun b => b = true) =
      probabilidad p E := by
  change probabilidad (p.map (fun x => decide (E x))) (fun b => b = true) = _
  rw [probabilidad_map]
  congr 1
  funext x
  exact propext (by simp)

theorem probabilidad_uno_por_soporte (p : PMF A) (E : A → Prop)
    (h : ∀ x ∈ p.support, E x) : probabilidad p E = 1 :=
  (p.toOuterMeasure_apply_eq_one_iff {x | E x}).mpr h

theorem probabilidad_cero_por_soporte (p : PMF A) (E : A → Prop)
    (h : ∀ x ∈ p.support, ¬ E x) : probabilidad p E = 0 := by
  apply (p.toOuterMeasure_apply_eq_zero_iff {x | E x}).mpr
  apply Set.disjoint_left.mpr
  intro x hs he
  exact h x hs he

/-- Producto independiente, con marginales dadas por las leyes originales. -/
@[expose] noncomputable def producto (p : PMF A) (q : PMF B) : PMF (A × B) :=
  p.bind (fun a => q.map (fun b => (a, b)))

theorem masa_producto (p : PMF A) (q : PMF B) (a : A) (b : B) :
    producto p q (a, b) = p a * q b := by
  classical
  have hm (a' : A) : (q.map (fun b' => (a', b'))) (a, b) = if a' = a then q b else 0 := by
    rw [PMF.map_apply, tsum_eq_single b]
    · simp [Prod.mk.injEq, eq_comm]
    · intro b' hb'
      simp [Prod.mk.injEq, Ne.symm hb']
  simp [producto, PMF.bind_apply, hm]

theorem soporte_producto (p : PMF A) (q : PMF B) (x : A × B) :
    x ∈ (producto p q).support ↔ x.1 ∈ p.support ∧ x.2 ∈ q.support := by
  rw [PMF.mem_support_iff, masa_producto, mul_ne_zero_iff]
  rfl

theorem primera_marginal (p : PMF A) (q : PMF B) : (producto p q).map Prod.fst = p := by
  rw [producto, PMF.map_bind]
  simp only [PMF.map_comp, Function.comp_def]
  change p.bind (fun a => q.map (Function.const B a)) = p
  rw [show (fun a => q.map (Function.const B a)) = PMF.pure by
    funext a; exact PMF.map_const q a]
  exact PMF.bind_pure p

theorem segunda_marginal (p : PMF A) (q : PMF B) : (producto p q).map Prod.snd = q := by
  rw [producto, PMF.map_bind]
  simp only [PMF.map_comp, Function.comp_def]
  change p.bind (fun _ => q.map id) = q
  rw [PMF.map_id, PMF.bind_const]

/-- Uniforme finita normalizada; no se identifica con expansión de una semilla. -/
@[expose] noncomputable def uniforme (A : Type*) [Fintype A] [Nonempty A] : PMF A :=
  PMF.ofFintype (fun _ => (Fintype.card A : ℝ≥0∞)⁻¹) (by
    simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
    exact ENNReal.mul_inv_cancel (by exact_mod_cast Fintype.card_ne_zero)
      (ENNReal.natCast_ne_top _))

theorem masa_uniforme [Fintype A] [Nonempty A] (x : A) :
    uniforme A x = (Fintype.card A : ℝ≥0∞)⁻¹ := rfl

theorem soporte_uniforme [Fintype A] [Nonempty A] (x : A) : x ∈ (uniforme A).support := by
  rw [PMF.mem_support_iff, masa_uniforme]
  exact ENNReal.inv_ne_zero.mpr (ENNReal.natCast_ne_top _)

theorem probabilidad_uniforme [Fintype A] [Nonempty A] (E : A → Prop) [DecidablePred E] :
    probabilidad (uniforme A) E =
      ((Finset.univ.filter E).card : ℝ≥0∞) / Fintype.card A := by
  classical
  have hs : {x | E x} = ((Finset.univ.filter E : Finset A) : Set A) := by
    ext x
    simp
  rw [probabilidad, hs, PMF.toOuterMeasure_apply_finset]
  simp only [masa_uniforme]
  simp [div_eq_mul_inv]

theorem probabilidad_real_cotas (p : PMF A) (E : A → Prop) :
    0 ≤ (probabilidad p E).toReal ∧ (probabilidad p E).toReal ≤ 1 := by
  exact ⟨ENNReal.toReal_nonneg, ENNReal.toReal_le_of_le_ofReal (by norm_num)
    (by simpa using probabilidad_le_uno p E)⟩

end Nexus.Cripto
