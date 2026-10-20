module

public import Nexus.N05.Muestreo
public import Nexus.Cripto.Probabilidad
import Mathlib.Tactic

public section
namespace Nexus.ROM.Selector

open scoped BigOperators

abbrev Subconjuntos (M q : ℕ) := ↥((Finset.univ : Finset (Fin M)).powersetCard q)
abbrev PocasDistintas (M R q : ℕ) := {f : Fin R → Fin M // (Finset.univ.image f).card ≤ q}

theorem completar_rango (M R q : ℕ) (hq : q ≤ M) (f : PocasDistintas M R q) :
    ∃ G : Subconjuntos M q, ∀ j, f.val j ∈ G.val := by
  obtain ⟨G, hRG, hGU, hcard⟩ := Finset.exists_subsuperset_card_eq
    (Finset.subset_univ (Finset.univ.image f.val)) f.property
    (show q ≤ (Finset.univ : Finset (Fin M)).card by simpa using hq)
  exact ⟨⟨G, Finset.mem_powersetCard.mpr ⟨hGU, hcard⟩⟩,
    fun j => hRG (Finset.mem_image.mpr ⟨j, Finset.mem_univ _, rfl⟩)⟩

@[expose] noncomputable def testigoRango (M R q : ℕ) (hq : q ≤ M) (f : PocasDistintas M R q) :
    Σ G : Subconjuntos M q, (Fin R → ↥G.val) :=
  ⟨Classical.choose (completar_rango M R q hq f),
    fun j => ⟨f.val j, Classical.choose_spec (completar_rango M R q hq f) j⟩⟩

theorem testigo_rango_inyectivo (M R q : ℕ) (hq : q ≤ M) :
    Function.Injective (testigoRango M R q hq) := by
  intro f g h
  apply Subtype.ext
  funext j
  exact congrArg (fun z : Σ G : Subconjuntos M q, (Fin R → ↥G.val) => (z.2 j).val) h

theorem cardinal_subconjuntos (M q : ℕ) : Fintype.card (Subconjuntos M q) = M.choose q := by
  simp only [Subconjuntos, Fintype.card_coe, Finset.card_powersetCard, Finset.card_univ, Fintype.card_fin]

theorem cardinal_testigos (M R q : ℕ) :
    Fintype.card (Σ G : Subconjuntos M q, (Fin R → ↥G.val)) = M.choose q * q ^ R := by
  rw [Fintype.card_sigma]
  have hcard (G : Subconjuntos M q) : Fintype.card ↥G.val = q := by
    exact (Fintype.card_coe _).trans (Finset.mem_powersetCard.mp G.property).2
  simp only [Fintype.card_fun, hcard, Fintype.card_fin, Finset.sum_const, Finset.card_univ,
    nsmul_eq_mul, cardinal_subconjuntos]
  rfl

theorem cola_cardinal (M R q : ℕ) (hq : q ≤ M) :
    Fintype.card (PocasDistintas M R q) ≤ M.choose q * q ^ R := by
  rw [← cardinal_testigos]
  exact Fintype.card_le_of_injective _ (testigo_rango_inyectivo M R q hq)

@[expose] noncomputable def probabilidadCola (M R q : ℕ) : ℚ :=
  (Fintype.card (PocasDistintas M R q) : ℚ) / (M : ℚ) ^ R

@[expose] def tau (M R q : ℕ) : ℚ := min 1 ((M.choose q : ℚ) * ((q : ℚ) / M) ^ R)

theorem cola_le_uno (M R q : ℕ) (hM : 0 < M) : probabilidadCola M R q ≤ 1 := by
  have hc : Fintype.card (PocasDistintas M R q) ≤ M ^ R := by
    simpa only [Fintype.card_fun, Fintype.card_fin] using
      (Fintype.card_subtype_le (p := fun f : Fin R → Fin M => (Finset.univ.image f).card ≤ q))
  have hp : (0 : ℚ) < (M : ℚ) ^ R := by positivity
  apply (div_le_one hp).mpr
  exact_mod_cast hc

theorem cola_selector_acotada (M R q : ℕ) (hM : 0 < M) (hq : q ≤ M) :
    probabilidadCola M R q ≤ tau M R q := by
  apply le_min (cola_le_uno M R q hM)
  unfold probabilidadCola
  have h := div_le_div_of_nonneg_right
    (show (Fintype.card (PocasDistintas M R q) : ℚ) ≤ M.choose q * (q : ℚ) ^ R by
      exact_mod_cast cola_cardinal M R q hq) (show (0 : ℚ) ≤ (M : ℚ) ^ R by positivity)
  simpa only [div_pow, mul_div_assoc] using h

theorem tau_no_negativa (M R q : ℕ) : 0 ≤ tau M R q := by unfold tau; positivity

set_option exponentiation.threshold 512 in
theorem tau_corte_512 (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) :
    tau (4 * 2 ^ k) 512 39 < (1 : ℚ) / 2 ^ 300 := by
  unfold tau
  apply lt_of_le_of_lt (min_le_right _ _)
  interval_cases k <;> norm_num [Nat.choose_eq_descFactorial_div_factorial, Nat.descFactorial]

/-- Condicionar a trabajo válido elimina el factor de trabajo de esa probabilidad condicionada. -/
theorem condicionar_trabajo (p a : ℚ) (hp : p ≠ 0) : p * a / p = a := by field_simp

theorem presupuesto_inicios (Q inicios : ℕ) (h : inicios ≤ Q + 1) (p riesgo : ℚ)
    (hp : 0 ≤ p) (hr : 0 ≤ riesgo) : (inicios : ℚ) * (p * riesgo) ≤ (Q + 1 : ℕ) * (p * riesgo) := by
  exact mul_le_mul_of_nonneg_right (by exact_mod_cast h) (mul_nonneg hp hr)

end Nexus.ROM.Selector
