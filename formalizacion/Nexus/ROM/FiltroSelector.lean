module

public import Nexus.ROM.SelectorPrimeras
import Mathlib.Tactic

/-!
# Restricción previsible de conjuntos y separación de excepciones

Una condición del pasado puede vaciar ambos conjuntos buenos sin alterar
una muestra que ya cumple esa condición. Las probabilidades siguen siendo
medias incondicionales, incluidas las ramas que incumplen una cota de cardinal.
-/

public section
namespace Nexus.ROM.FiltroSelector

open Nexus.N06

variable {α W : Type} [DecidableEq α]

@[expose] noncomputable def filtrar (P : Prop) (S : Finset α) : Finset α := by
  classical
  exact if P then S else ∅

omit [DecidableEq α] in
theorem pertenencia (P : Prop) (S : Finset α) (x : α) : x ∈ filtrar P S ↔ P ∧ x ∈ S := by
  classical
  by_cases hp : P <;> simp [filtrar, hp]

theorem interseccion (P : Prop) (S T : Finset α) :
    filtrar P S ∩ filtrar P T = filtrar P (S ∩ T) := by
  classical
  by_cases hp : P <;> simp [filtrar, hp]

omit [DecidableEq α] in
theorem cardinal (P : Prop) (S : Finset α) (g : ℕ) (h : P → S.card ≤ g) :
    (filtrar P S).card ≤ g := by
  classical
  by_cases hp : P
  · simpa only [filtrar, hp, ite_true] using h hp
  · simp only [filtrar, hp, ite_false, Finset.card_empty, Nat.zero_le]

theorem cardinal_interseccion (P : Prop) (S T : Finset α) (g : ℕ) (h : P → (S ∩ T).card ≤ g) :
    (filtrar P S ∩ filtrar P T).card ≤ g := by
  rw [interseccion]
  exact cardinal P (S ∩ T) g h

theorem muestra_positiva (P : Prop) (S T U : Finset α) (q : ℕ) (hq : 0 < q) :
    (U.card = q ∧ U ⊆ filtrar P S ∩ filtrar P T) ↔
      P ∧ U.card = q ∧ U ⊆ S ∩ T := by
  classical
  constructor
  · rintro ⟨hc, hu⟩
    have hn : U.Nonempty := Finset.card_pos.mp (by omega)
    obtain ⟨x, hx⟩ := hn
    have hp := ((pertenencia P S x).mp (Finset.mem_inter.mp (hu hx)).1).1
    refine ⟨hp, hc, ?_⟩
    simpa only [filtrar, hp, ite_true] using hu
  · rintro ⟨hp, hc, hu⟩
    exact ⟨hc, by simpa only [filtrar, hp, ite_true] using hu⟩

omit [DecidableEq α] in
@[expose] noncomputable def medida [Fintype W] (E : W → Prop) : ℚ :=
  promedio (fun w => @ite ℚ (E w) (Classical.propDecidable _) 1 0)

omit [DecidableEq α] in
theorem medida_media [Fintype W] (E : W → Prop) [DecidablePred E] :
    medida E = promedio (fun w => if E w then (1 : ℚ) else 0) := by
  unfold medida
  congr 1
  funext w
  by_cases he : E w <;> simp only [he, ite_true, ite_false]

omit [DecidableEq α] in
theorem medida_monotona [Fintype W] (E F : W → Prop) (h : ∀ w, E w → F w) : medida E ≤ medida F := by
  apply promedio_monotono
  intro w
  by_cases he : E w
  · simp only [he, h w he, ite_true, le_refl]
  · simp only [he, ite_false]
    split_ifs <;> norm_num

omit [DecidableEq α] in
theorem separar_excepciones [Fintype W] (E S X : W → Prop) (rho : ℚ)
    (h : medida (fun w => E w ∧ S w ∧ ¬ X w) ≤ rho) :
    medida E ≤ medida (fun w => ¬ S w) + medida X + rho := by
  have hi : medida E ≤ medida (fun w => ¬ S w) + medida X +
      medida (fun w => E w ∧ S w ∧ ¬ X w) := by
    unfold medida
    rw [← promedio_suma, ← promedio_suma]
    apply promedio_monotono
    intro w
    by_cases he : E w <;> by_cases hs : S w <;> by_cases hx : X w <;> norm_num [he, hs, hx]
  exact hi.trans (add_le_add (le_refl _) h)

end Nexus.ROM.FiltroSelector
