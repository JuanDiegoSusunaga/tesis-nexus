module

public import Nexus.ROM.SelectorRechazo
import Mathlib.Tactic

/-!
# Uniformidad del subconjunto producido por rechazo de duplicados

Se prueban iguales los cardinales de las fibras de todos los q-subconjuntos.
Por tanto, condicionado a completar antes de un corte fijo, el subconjunto
es uniforme. El supuesto de entradas uniformes se separa del canal real.
-/

public section
namespace Nexus.ROM.Selector.Uniformidad

open scoped BigOperators
variable {A : Type} [Fintype A] [DecidableEq A]

@[expose] def salida (q R : ℕ) (w : Fin R → A) : Finset A :=
  seleccionar q ∅ (List.ofFn w)

abbrev Subconjuntos (A : Type) (q : ℕ) := {S : Finset A // S.card = q}
abbrev Fibra (q R : ℕ) (S : Finset A) := {w : Fin R → A // salida q R w = S}
abbrev Completas (A : Type) [DecidableEq A] (q R : ℕ) :=
  {w : Fin R → A // (salida q R w).card = q}

noncomputable instance (q R : ℕ) (S : Finset A) : Fintype (Fibra q R S) := Fintype.ofFinite _
noncomputable instance (q R : ℕ) : Fintype (Completas A q R) := Fintype.ofFinite _

omit [Fintype A] in
theorem salida_permutada (q R : ℕ) (w : Fin R → A) (p : A ≃ A) :
    salida q R (p ∘ w) = (salida q R w).image p := by
  have he : List.ofFn (p ∘ w) = (List.ofFn w).map p := by simp
  rw [salida, he]
  simpa only [Finset.image_empty, salida] using equivariancia q ∅ (List.ofFn w) p

theorem permutacion_subconjuntos (S T : Finset A) (h : S.card = T.card) :
    ∃ p : A ≃ A, S.image p = T := by
  classical
  let e : ↥S ≃ ↥T := Fintype.equivOfCardEq (by simpa using h)
  let f : {a : A // a ∉ S} ≃ {a : A // a ∉ T} :=
    Fintype.equivOfCardEq (by
      simp only [Fintype.card_subtype_compl, Fintype.card_coe, h])
  let p := Equiv.subtypeCongr e f
  have hmem (a : A) : p a ∈ T ↔ a ∈ S := by
    by_cases ha : a ∈ S
    · have he : p a = (e ⟨a, ha⟩).val := by
        simp [p, Equiv.subtypeCongr, ha]
      rw [he]
      exact iff_of_true (e ⟨a, ha⟩).property ha
    · have he : p a = (f ⟨a, ha⟩).val := by
        simp [p, Equiv.subtypeCongr, ha]
      rw [he]
      exact iff_of_false (f ⟨a, ha⟩).property ha
  refine ⟨p, ?_⟩
  ext a
  constructor
  · intro ha
    obtain ⟨b, hb, rfl⟩ := Finset.mem_image.mp ha
    exact (hmem b).mpr hb
  · intro ha
    exact Finset.mem_image.mpr ⟨p.symm a, (hmem _).mp (by simpa using ha), by simp⟩

@[expose] noncomputable def equivalenciaFibras (q R : ℕ) (S T : Finset A)
    (p : A ≃ A) (h : S.image p = T) : Fibra q R S ≃ Fibra q R T := by
  classical
  have hinv : T.image p.symm = S := by
    rw [← h, Finset.image_image]
    have he : (p.symm ∘ p : A → A) = id := funext p.symm_apply_apply
    rw [he, Finset.image_id]
  exact
    { toFun := fun w => ⟨p ∘ w.val, by rw [salida_permutada, w.property, h]⟩
      invFun := fun w => ⟨p.symm ∘ w.val, by rw [salida_permutada, w.property, hinv]⟩
      left_inv := fun w => Subtype.ext (by funext i; simp)
      right_inv := fun w => Subtype.ext (by funext i; simp) }

theorem fibras_iguales (q R : ℕ) (S T : Finset A) (h : S.card = T.card) :
    Fintype.card (Fibra q R S) = Fintype.card (Fibra q R T) := by
  obtain ⟨p, hp⟩ := permutacion_subconjuntos S T h
  exact Fintype.card_congr (equivalenciaFibras q R S T p hp)

omit [DecidableEq A] in
theorem cardinal_subconjuntos (q : ℕ) :
    Fintype.card (Subconjuntos A q) = Nat.choose (Fintype.card A) q := by
  classical
  let e : Subconjuntos A q ≃ ↥((Finset.univ : Finset A).powersetCard q) :=
    { toFun := fun S => ⟨S.val, Finset.mem_powersetCard.mpr ⟨Finset.subset_univ _, S.property⟩⟩
      invFun := fun S => ⟨S.val, (Finset.mem_powersetCard.mp S.property).2⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  rw [Fintype.card_congr e, Fintype.card_coe, Finset.card_powersetCard, Finset.card_univ]

@[expose] noncomputable def particionCompletas (q R : ℕ) :
    Completas A q R ≃ (S : Subconjuntos A q) × Fibra q R S.val where
  toFun w := ⟨⟨salida q R w.val, w.property⟩, ⟨w.val, rfl⟩⟩
  invFun e := ⟨e.2.val, by rw [e.2.property]; exact e.1.property⟩
  left_inv _ := rfl
  right_inv e := by
    rcases e with ⟨⟨S, hS⟩, ⟨w, hw⟩⟩
    dsimp at hw
    subst S
    rfl

theorem completas_por_fibra (q R : ℕ) (S : Finset A) (hS : S.card = q) :
    Fintype.card (Completas A q R) =
      Nat.choose (Fintype.card A) q * Fintype.card (Fibra q R S) := by
  classical
  rw [Fintype.card_congr (particionCompletas q R), Fintype.card_sigma]
  have he (T : Subconjuntos A q) : Fintype.card (Fibra q R T.val) =
      Fintype.card (Fibra q R S) := fibras_iguales q R T.val S (T.property.trans hS.symm)
  simp_rw [he]
  rw [Finset.sum_const, Finset.card_univ, nsmul_eq_mul, cardinal_subconjuntos]
  simp

theorem uniforme_condicionado_a_completar (q R : ℕ) (S : Finset A) (hS : S.card = q)
    (hpos : 0 < Fintype.card (Completas A q R)) :
    (Fintype.card (Fibra q R S) : ℚ) / Fintype.card (Completas A q R) =
      1 / (Nat.choose (Fintype.card A) q : ℚ) := by
  have hc := completas_por_fibra q R S hS
  have hf : 0 < Fintype.card (Fibra q R S) := by
    by_contra! hf
    have hz : Fintype.card (Fibra q R S) = 0 := Nat.eq_zero_of_le_zero hf
    rw [hz, Nat.mul_zero] at hc
    omega
  rw [hc, Nat.cast_mul]
  have hn : (Fintype.card (Fibra q R S) : ℚ) ≠ 0 := by positivity
  field_simp

end Nexus.ROM.Selector.Uniformidad
