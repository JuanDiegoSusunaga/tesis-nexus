module

public import Nexus.ROM.UniformidadSelector
public import Nexus.N05.Cotas
import Mathlib.Tactic

/-!
# Del selector ejecutado al cociente hipergeométrico

Sobre palabras uniformes independientes, completar el selector induce
la ley uniforme de q-subconjuntos, incluso con un corte finito. La cota
sin condicionar incluye además la probabilidad de no completar.
-/

public section
namespace Nexus.ROM.Selector.Uniformidad.Ley

open scoped BigOperators
variable {A : Type} [Fintype A] [DecidableEq A]

abbrev Buenas (q R : ℕ) (G : Finset A) :=
  {w : Completas A q R // salida q R w.val ⊆ G}

noncomputable instance (q R : ℕ) (G : Finset A) : Fintype (Buenas q R G) := Fintype.ofFinite _

@[expose] noncomputable def particionBuenas (q R : ℕ) (G : Finset A) :
    Buenas q R G ≃ (S : ↥(G.powersetCard q)) × Fibra q R S.val where
  toFun w := ⟨⟨salida q R w.val.val,
    Finset.mem_powersetCard.mpr ⟨w.property, w.val.property⟩⟩, ⟨w.val.val, rfl⟩⟩
  invFun e := ⟨⟨e.2.val, by rw [e.2.property]; exact (Finset.mem_powersetCard.mp e.1.property).2⟩,
    by rw [e.2.property]; exact (Finset.mem_powersetCard.mp e.1.property).1⟩
  left_inv _ := rfl
  right_inv e := by
    rcases e with ⟨⟨S, hS⟩, ⟨w, hw⟩⟩
    dsimp at hw
    subst S
    rfl

theorem buenas_por_fibra (q R : ℕ) (G S : Finset A) (hS : S.card = q) :
    Fintype.card (Buenas q R G) = Nat.choose G.card q * Fintype.card (Fibra q R S) := by
  classical
  rw [Fintype.card_congr (particionBuenas q R G), Fintype.card_sigma]
  have he (T : ↥(G.powersetCard q)) : Fintype.card (Fibra q R T.val) =
      Fintype.card (Fibra q R S) :=
    fibras_iguales q R T.val S ((Finset.mem_powersetCard.mp T.property).2.trans hS.symm)
  simp_rw [he]
  rw [Finset.sum_const, Finset.card_univ, Fintype.card_coe, Finset.card_powersetCard, nsmul_eq_mul]
  simp

theorem hipergeometrica_condicionada (q R : ℕ) (G : Finset A)
    (hpos : 0 < Fintype.card (Completas A q R)) :
    (Fintype.card (Buenas q R G) : ℚ) / Fintype.card (Completas A q R) =
      (Nat.choose G.card q : ℚ) / Nat.choose (Fintype.card A) q := by
  classical
  obtain ⟨w⟩ := Fintype.card_pos_iff.mp hpos
  let S := salida q R w.val
  have hS : S.card = q := w.property
  have hc := completas_por_fibra q R S hS
  have hf : 0 < Fintype.card (Fibra q R S) := Nat.pos_of_mul_pos_left (hc ▸ hpos)
  rw [buenas_por_fibra q R G S hS, hc, Nat.cast_mul, Nat.cast_mul]
  have hn : (Fintype.card (Fibra q R S) : ℚ) ≠ 0 := by positivity
  field_simp

theorem cota_H_condicionada (q R : ℕ) (G : Finset A) (theta : ℚ)
    (hpos : 0 < Fintype.card (Completas A q R))
    (hmalas : theta * Fintype.card A ≤ ((Fintype.card A - G.card : ℕ) : ℚ)) :
    (Fintype.card (Buenas q R G) : ℚ) / Fintype.card (Completas A q R) ≤
      Nexus.N05.H (Fintype.card A) q theta := by
  rw [hipergeometrica_condicionada q R G hpos]
  have hc := Nexus.N05.cota_omision_radio (Finset.univ : Finset A) G q theta
    (Finset.subset_univ _) (by simpa only [Finset.card_univ] using hmalas)
  rw [Nexus.N05.probabilidad_omision _ _ _ (Finset.subset_univ _)] at hc
  simpa only [Finset.card_univ] using hc

theorem cota_exponencial_condicionada [Nonempty A] (q R : ℕ) (G : Finset A) (theta : ℚ)
    (hpos : 0 < Fintype.card (Completas A q R)) (hq : q ≤ Fintype.card A)
    (h0 : 0 ≤ theta) (h1 : theta ≤ 1)
    (hmalas : theta * Fintype.card A ≤ ((Fintype.card A - G.card : ℕ) : ℚ)) :
    (Fintype.card (Buenas q R G) : ℚ) / Fintype.card (Completas A q R) ≤ (1 - theta) ^ q :=
  (cota_H_condicionada q R G theta hpos hmalas).trans
    (Nexus.N05.H_le_potencia _ q theta Fintype.card_pos hq h0 h1)

theorem mezcla_con_fallo (a b e H tau : ℚ) (hb : 0 ≤ b) (hpart : a + b = 1)
    (hH : 0 ≤ H) (he : e ≤ a * H + b) (htau : b ≤ tau) :
    e ≤ H + tau := by nlinarith

end Nexus.ROM.Selector.Uniformidad.Ley
