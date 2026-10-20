module

public import Nexus.AIR.Solucion
public import Nexus.Distancia
import Mathlib.Tactic

public section
namespace Nexus.AIR.Contraejemplo

open Polynomial
variable {K : Type*} [Field K]

/-- Acuerdos en un dominio sin puntos repetidos. -/
@[expose] noncomputable def acuerdos (L : Finset K) (F h : Polynomial K) : Finset K := by
  classical
  exact L.filter (fun x => F.eval x = h.eval x)

theorem errores_mas_acuerdos (L : Finset K) (F h : Polynomial K) :
    Nexus.errores L F.eval h.eval + (acuerdos L F h).card = L.card := by
  classical
  simpa only [Nexus.errores, acuerdos, not_not] using
    Finset.card_filter_add_card_filter_not (s := L) (fun x => F.eval x ≠ h.eval x)

theorem acuerdos_acotados (L : Finset K) (F h : Polynomial K) (hh : h.natDegree < F.natDegree) :
    (acuerdos L F h).card ≤ F.natDegree := by
  classical
  have hdeg : (F - h).natDegree = F.natDegree :=
    natDegree_sub_eq_left_of_natDegree_lt hh
  have hne : F - h ≠ 0 := by
    intro heq
    have he := sub_eq_zero.mp heq
    rw [he] at hh
    omega
  simpa only [acuerdos, eval_sub, sub_eq_zero, hdeg] using Nexus.ceros_acotados L (F - h) hne

theorem distancia_cota_inferior (L : Finset K) (F h : Polynomial K)
    (hh : h.natDegree < F.natDegree) :
    ((L.card : ℚ) - F.natDegree) / L.card ≤ Nexus.distancia L F.eval h.eval := by
  have hc := errores_mas_acuerdos L F h
  have ha := acuerdos_acotados L F h hh
  have hi : (L.card : ℚ) - F.natDegree ≤ Nexus.errores L F.eval h.eval := by
    have hc' : (Nexus.errores L F.eval h.eval : ℚ) + (acuerdos L F h).card = L.card := by
      exact_mod_cast hc
    have ha' : ((acuerdos L F h).card : ℚ) ≤ F.natDegree := by exact_mod_cast ha
    linarith
  exact div_le_div_of_nonneg_right hi (by positivity)

theorem anulador_monico (S : Finset K) : (Nexus.AIR.anulador S).Monic :=
  Polynomial.monic_prod_X_sub_C id S

theorem grado_anulador (S : Finset K) : (Nexus.AIR.anulador S).natDegree = S.card :=
  Polynomial.natDegree_finsetProd_X_sub_C_eq_card S id

theorem ceros_anulador (S : Finset K) (x : K) :
    (Nexus.AIR.anulador S).eval x = 0 ↔ x ∈ S := by
  classical
  change (∏ y ∈ S, (X - C y : Polynomial K)).eval x = 0 ↔ x ∈ S
  rw [eval_prod]
  simp only [eval_sub, eval_X, eval_C, Finset.prod_eq_zero_iff, sub_eq_zero]
  constructor
  · rintro ⟨a, ha, rfl⟩
    exact ha
  · intro hx
    exact ⟨x, hx, rfl⟩

/-- Se cancela exactamente el término principal y se eligen los acuerdos. -/
@[expose] noncomputable def aproximante (F : Polynomial K) (S : Finset K) : Polynomial K :=
  F - C F.leadingCoeff * Nexus.AIR.anulador S

theorem diferencia_aproximante (F : Polynomial K) (S : Finset K) :
    F - aproximante F S = C F.leadingCoeff * Nexus.AIR.anulador S := by
  simp [aproximante]

theorem grado_aproximante (F : Polynomial K) (S : Finset K)
    (hF : 0 < F.natDegree) (hS : S.card = F.natDegree) :
    (aproximante F S).natDegree < F.natDegree := by
  have hF0 : F ≠ 0 := by intro h; simp [h] at hF
  have hlc : F.leadingCoeff ≠ 0 := leadingCoeff_ne_zero.mpr hF0
  have hdeg : (C F.leadingCoeff * Nexus.AIR.anulador S).natDegree = F.natDegree := by
    rw [natDegree_C_mul hlc, grado_anulador, hS]
  have hq0 : C F.leadingCoeff * Nexus.AIR.anulador S ≠ 0 :=
    mul_ne_zero (C_ne_zero.mpr hlc) (anulador_monico S).ne_zero
  have hlead : (C F.leadingCoeff * Nexus.AIR.anulador S).leadingCoeff = F.leadingCoeff := by
    rw [leadingCoeff_mul, leadingCoeff_C, (anulador_monico S).leadingCoeff, mul_one]
  have hd := degree_sub_lt_left
    (show F.degree = (C F.leadingCoeff * Nexus.AIR.anulador S).degree by
      rw [degree_eq_natDegree hF0, degree_eq_natDegree hq0, hdeg]) hF0 hlead.symm
  by_cases hh : aproximante F S = 0
  · simpa [hh] using hF
  · apply (natDegree_lt_iff_degree_lt hh).mpr
    simpa [aproximante, degree_eq_natDegree hF0] using hd

theorem acuerdos_aproximante (F : Polynomial K) (S : Finset K) (hF : F ≠ 0) (x : K) :
    F.eval x = (aproximante F S).eval x ↔ x ∈ S := by
  have hlc : F.leadingCoeff ≠ 0 := leadingCoeff_ne_zero.mpr hF
  rw [← sub_eq_zero, ← eval_sub, diferencia_aproximante, eval_mul, eval_C,
    mul_eq_zero, or_iff_right hlc, ceros_anulador]

theorem numero_acuerdos_exacto (L S : Finset K) (F : Polynomial K)
    (hF : F ≠ 0) (hSL : S ⊆ L) : acuerdos L F (aproximante F S) = S := by
  classical
  ext x
  simp only [acuerdos, Finset.mem_filter, acuerdos_aproximante F S hF]
  exact and_iff_right_of_imp (hSL (x := x))

theorem errores_aproximante (L S : Finset K) (F : Polynomial K)
    (hF : F ≠ 0) (hSL : S ⊆ L) :
    Nexus.errores L F.eval (aproximante F S).eval = L.card - S.card := by
  have h := errores_mas_acuerdos L F (aproximante F S)
  rw [numero_acuerdos_exacto L S F hF hSL] at h
  omega

theorem distancia_aproximante (L S : Finset K) (F : Polynomial K)
    (hF : F ≠ 0) (hSL : S ⊆ L) :
    Nexus.distancia L F.eval (aproximante F S).eval =
      ((L.card : ℚ) - S.card) / L.card := by
  rw [Nexus.distancia, errores_aproximante L S F hF hSL, Nat.cast_sub (Finset.card_le_card hSL)]

/-- La distancia al código es el mínimo alcanzado, no solo una cota inferior. -/
theorem minimo_distancia_codigo (L : Finset K) (F : Polynomial K)
    (hF : 0 < F.natDegree) (hL : F.natDegree ≤ L.card) :
    IsLeast {d : ℚ | ∃ h : Polynomial K, h.natDegree < F.natDegree ∧
      Nexus.distancia L F.eval h.eval = d}
      (((L.card : ℚ) - F.natDegree) / L.card) := by
  classical
  obtain ⟨S, hSL, hS⟩ := Finset.exists_subset_card_eq hL
  refine ⟨⟨aproximante F S, grado_aproximante F S hF hS, ?_⟩, ?_⟩
  · rw [distancia_aproximante L S F (by intro h; simp [h] at hF) hSL, hS]
  · rintro d ⟨h, hh, rfl⟩
    exact distancia_cota_inferior L F h hh

theorem distancia_exacta_siete_octavos (T : ℕ) (hT : 0 < T) (L : Finset K)
    (hL : L.card = 8 * T) (F : Polynomial K) (hF : F.natDegree = T) :
    IsLeast {d : ℚ | ∃ h : Polynomial K, h.natDegree < T ∧
      Nexus.distancia L F.eval h.eval = d} (7 / 8) := by
  have h := minimo_distancia_codigo L F (by omega) (by omega)
  have hc : (((L.card : ℚ) - F.natDegree) / L.card) = 7 / 8 := by
    rw [hL, hF]
    have ht : (T : ℚ) ≠ 0 := by exact_mod_cast hT.ne'
    push_cast
    field_simp
    ring
  rw [hc] at h
  simpa only [hF] using h

end Nexus.AIR.Contraejemplo
