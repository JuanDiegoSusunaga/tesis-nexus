module

public import Nexus.ROM.UniformidadSelector
import Mathlib.Tactic

/-!
# Respuesta uniforme condicionada a una tabla parcial

Se cuenta el espacio de funciones uniformes compatibles con una tabla.
Una clave fuera de la tabla tiene respuesta uniforme; una repetida conserva
su respuesta. El dominio es finito y no se presupone SHA3 uniforme.
-/

public section
namespace Nexus.ROM.FrescuraFinita

variable {Q A : Type} [Fintype Q] [Fintype A] [DecidableEq Q]

abbrev Completaciones (S : Finset Q) (v : Q → A) :=
  {H : Q → A // ∀ q ∈ S, H q = v q}
abbrev Fibra (S : Finset Q) (v : Q → A) (q : Q) (a : A) :=
  {H : Completaciones S v // H.val q = a}

noncomputable instance (S : Finset Q) (v : Q → A) : Fintype (Completaciones S v) := Fintype.ofFinite _
noncomputable instance (S : Finset Q) (v : Q → A) (q : Q) (a : A) :
    Fintype (Fibra S v q a) := Fintype.ofFinite _

@[expose] noncomputable def libres (S : Finset Q) (v : Q → A) :
    Completaciones S v ≃ ({q : Q // q ∉ S} → A) where
  toFun H q := H.val q.val
  invFun f := ⟨fun q => if h : q ∈ S then v q else f ⟨q, h⟩, by
    intro q hq
    simp only [hq, dite_true]⟩
  left_inv H := by
    apply Subtype.ext
    funext q
    by_cases hq : q ∈ S
    · simp only [hq, dite_true]
      exact (H.property q hq).symm
    · simp only [hq, dite_false]
  right_inv f := by
    funext q
    simp only [q.property, dite_false]

theorem cardinal_completaciones (S : Finset Q) (v : Q → A) :
    Fintype.card (Completaciones S v) = Fintype.card A ^ (Fintype.card Q - S.card) := by
  classical
  rw [Fintype.card_congr (libres S v), Fintype.card_fun, Fintype.card_subtype_compl, Fintype.card_coe]

@[expose] noncomputable def fibraNueva (S : Finset Q) (v : Q → A) (q : Q) (a : A)
    (hq : q ∉ S) : Fibra S v q a ≃ Completaciones (insert q S) (Function.update v q a) where
  toFun H := ⟨H.val.val, by
    intro x hx
    rcases Finset.mem_insert.mp hx with h | h
    · subst x
      simpa only [Function.update_self] using H.property
    · have hn : x ≠ q := fun he => hq (he ▸ h)
      rw [Function.update_of_ne hn]
      exact H.val.property x h⟩
  invFun H := ⟨⟨H.val, by
    intro x hx
    have hn : x ≠ q := fun he => hq (he ▸ hx)
    have hh := H.property x (Finset.mem_insert_of_mem hx)
    simpa only [Function.update_of_ne hn] using hh⟩,
    by simpa only [Function.update_self] using H.property q (Finset.mem_insert_self _ _)⟩
  left_inv _ := rfl
  right_inv _ := rfl

theorem cardinal_fibra_nueva (S : Finset Q) (v : Q → A) (q : Q) (a : A) (hq : q ∉ S) :
    Fintype.card (Fibra S v q a) =
      Fintype.card A ^ (Fintype.card Q - (S.card + 1)) := by
  rw [Fintype.card_congr (fibraNueva S v q a hq), cardinal_completaciones,
    Finset.card_insert_of_notMem hq]

theorem exponente_antes_despues (S : Finset Q) (q : Q) (hq : q ∉ S) :
    Fintype.card Q - S.card = (Fintype.card Q - (S.card + 1)) + 1 := by
  have hc := Finset.card_le_card (Finset.subset_univ (insert q S))
  rw [Finset.card_insert_of_notMem hq, Finset.card_univ] at hc
  omega

theorem respuesta_nueva_uniforme [Nonempty A] (S : Finset Q) (v : Q → A) (q : Q) (a : A)
    (hq : q ∉ S) :
    (Fintype.card (Fibra S v q a) : ℚ) / Fintype.card (Completaciones S v) =
      1 / (Fintype.card A : ℚ) := by
  rw [cardinal_fibra_nueva S v q a hq, cardinal_completaciones, exponente_antes_despues S q hq,
    pow_succ, Nat.cast_mul]
  have hp : (0 : ℚ) < Fintype.card A := by exact_mod_cast Fintype.card_pos (α := A)
  have hn : (Fintype.card A ^ (Fintype.card Q - (S.card + 1)) : ℚ) ≠ 0 := by positivity
  field_simp

omit [Fintype Q] [Fintype A] [DecidableEq Q] in
theorem respuesta_repetida_fija (S : Finset Q) (v : Q → A) (q : Q) (hq : q ∈ S)
    (H : Completaciones S v) : H.val q = v q := H.property q hq

omit [DecidableEq Q] in
theorem respuesta_repetida_distinta_imposible (S : Finset Q) (v : Q → A) (q : Q) (a : A)
    (hq : q ∈ S) (ha : a ≠ v q) : Fintype.card (Fibra S v q a) = 0 := by
  classical
  apply Fintype.card_eq_zero_iff.mpr
  exact ⟨fun H => ha (H.property.symm.trans (H.val.property q hq))⟩

end Nexus.ROM.FrescuraFinita
