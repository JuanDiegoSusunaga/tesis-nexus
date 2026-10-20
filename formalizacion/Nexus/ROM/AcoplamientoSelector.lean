module

public import Nexus.ROM.LeySelector
import Mathlib.Tactic

/-!
# Pérdida exacta del selector con aborto

Cuando el resultado completo es uniforme, la ley que devuelve aborto con
probabilidad tau dista exactamente tau de la muestra uniforme que siempre
termina. No se identifica un corte de análisis con una parada del Rust.
-/

public section
namespace Nexus.ROM.Selector.Acoplamiento

open scoped BigOperators
variable {A : Type} [Fintype A]

abbrev Muestra (A : Type) (q : ℕ) := Uniformidad.Subconjuntos A q

@[expose] noncomputable def masa (q : ℕ) (tau : ℚ) : Option (Muestra A q) → ℚ
  | none => tau
  | some _ => (1 - tau) / Nat.choose (Fintype.card A) q

@[expose] noncomputable def variacion (q : ℕ) (tau : ℚ) : ℚ :=
  (∑ x : Option (Muestra A q), |masa q tau x - masa q 0 x|) / 2

theorem masa_no_negativa (q : ℕ) (tau : ℚ) (h0 : 0 ≤ tau) (h1 : tau ≤ 1)
    (x : Option (Muestra A q)) : 0 ≤ masa q tau x := by
  cases x
  · exact h0
  · exact div_nonneg (by linarith) (by positivity)

theorem masa_normalizada (q : ℕ) (tau : ℚ) (hq : q ≤ Fintype.card A) :
    (∑ x : Option (Muestra A q), masa q tau x) = 1 := by
  classical
  rw [Fintype.sum_option]
  simp only [masa, Finset.sum_const, Finset.card_univ, nsmul_eq_mul,
    Uniformidad.cardinal_subconjuntos]
  have hc : (Nat.choose (Fintype.card A) q : ℚ) ≠ 0 := by
    exact_mod_cast Nat.ne_of_gt (Nat.choose_pos hq)
  field_simp
  ring

theorem perdida_exacta (q : ℕ) (tau : ℚ) (hq : q ≤ Fintype.card A) (h0 : 0 ≤ tau) :
    variacion (A := A) q tau = tau := by
  classical
  have hc : (0 : ℚ) < Nat.choose (Fintype.card A) q := by exact_mod_cast Nat.choose_pos hq
  have hs (S : Muestra A q) : |masa q tau (some S) - masa q 0 (some S)| =
      tau / Nat.choose (Fintype.card A) q := by
    change |(1 - tau) / _ - (1 - 0) / _| = _
    rw [← sub_div, show (1 - tau : ℚ) - (1 - 0) = -tau by ring, neg_div,
      abs_neg, abs_of_nonneg (div_nonneg h0 hc.le)]
  unfold variacion
  rw [Fintype.sum_option]
  have hn : |masa (A := A) q tau none - masa (A := A) q 0 none| = tau := by
    change |tau - 0| = tau
    simpa only [sub_zero] using abs_of_nonneg h0
  rw [hn]
  simp_rw [hs]
  rw [Finset.sum_const, Finset.card_univ, nsmul_eq_mul, Uniformidad.cardinal_subconjuntos]
  field_simp
  ring

@[expose] noncomputable def ley (q : ℕ) (tau : ℚ) (hq : q ≤ Fintype.card A)
    (h0 : 0 ≤ tau) (h1 : tau ≤ 1) : Nexus.Cripto.Variacion.Ley (Option (Muestra A q)) where
  peso := masa q tau
  noNegativo := masa_no_negativa q tau h0 h1
  normalizada := masa_normalizada q tau hq

theorem error_de_evento (q : ℕ) (tau : ℚ) (E : Option (Muestra A q) → Prop)
    (hq : q ≤ Fintype.card A) (h0 : 0 ≤ tau) (h1 : tau ≤ 1) :
    |Nexus.Cripto.Variacion.evento (ley q tau hq h0 h1) E -
      Nexus.Cripto.Variacion.evento (ley q 0 hq (by rfl) (by norm_num)) E| ≤ tau := by
  have hh := Nexus.Cripto.Variacion.diferencia_evento_acotada
    (ley q tau hq h0 h1) (ley q 0 hq (by rfl) (by norm_num)) E
  change _ ≤ variacion (A := A) q tau at hh
  rwa [perdida_exacta q tau hq h0] at hh

theorem perdida_acotada (q : ℕ) (tau eps : ℚ) (hq : q ≤ Fintype.card A)
    (h0 : 0 ≤ tau) (ht : tau ≤ eps) : variacion (A := A) q tau ≤ eps := by
  rw [perdida_exacta q tau hq h0]
  exact ht

theorem perdida_corte_512 (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) :
    variacion (A := Fin (4 * 2 ^ k)) 40
      (probabilidadIncompleta (4 * 2 ^ k) 512 40) < (1 : ℚ) / 2 ^ 300 := by
  have hq : 40 ≤ Fintype.card (Fin (4 * 2 ^ k)) := by
    have hp : 2 ^ 4 ≤ 2 ^ k := Nat.pow_le_pow_right (by decide) hk0
    norm_num at hp
    simp only [Fintype.card_fin]
    omega
  have h0 : 0 ≤ probabilidadIncompleta (4 * 2 ^ k) 512 40 := by
    unfold probabilidadIncompleta
    positivity
  rw [perdida_exacta 40 _ hq h0]
  exact selector_corte_512 k hk0 hk1

end Nexus.ROM.Selector.Acoplamiento
