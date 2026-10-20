module

public import Nexus.ROM.FrescuraFinita
public import Nexus.N06.Experimento
import Mathlib.Tactic

/-!
# Partición exacta de la media de tablas compatibles

Revelar una dirección nueva particiona las completaciones en fibras de igual
tamaño. Se obtiene una identidad para cualquier observable de toda la tabla,
sin condicionar a ausencia de excepciones ni postular independencia futura.
-/

public section
namespace Nexus.ROM.PromediosCompletaciones

open Nexus.N06 FrescuraFinita
open scoped BigOperators

theorem media_equivalencia {X Y : Type*} [Fintype X] [Fintype Y]
    (e : X ≃ Y) (f : Y → ℚ) : promedio (fun x => f (e x)) = promedio f := by
  unfold promedio
  rw [Fintype.card_congr e, Equiv.sum_comp e]

theorem media_sigma {X : Type*} {Y : X → Type*} [Fintype X] [∀ x, Fintype (Y x)]
    (m : ℕ) (hc : ∀ x, Fintype.card (Y x) = m)
    (f : (x : X) × Y x → ℚ) :
    promedio f = promedio (fun x => promedio (fun y => f ⟨x, y⟩)) := by
  simp only [promedio, Fintype.sum_sigma, Fintype.card_sigma, hc, Finset.sum_const,
    Finset.card_univ, nsmul_eq_mul, Nat.cast_mul]
  rw [← Finset.sum_div, div_div]
  push_cast
  ring

variable {Q A : Type} [Fintype Q] [Fintype A] [DecidableEq Q]

@[expose] noncomputable def particion (S : Finset Q) (v : Q → A) (q : Q) (hq : q ∉ S) :
    Completaciones S v ≃ (a : A) × Completaciones (insert q S) (Function.update v q a) where
  toFun H := ⟨H.val q, ⟨H.val, by
    intro x hx
    rcases Finset.mem_insert.mp hx with rfl | hx
    · simp only [Function.update_self]
    · have hn : x ≠ q := fun h => hq (h ▸ hx)
      simpa only [Function.update_of_ne hn] using H.property x hx⟩⟩
  invFun H := ⟨H.2.val, by
    intro x hx
    have hn : x ≠ q := fun h => hq (h ▸ hx)
    simpa only [Function.update_of_ne hn] using H.2.property x (Finset.mem_insert_of_mem hx)⟩
  left_inv _ := rfl
  right_inv H := by
    rcases H with ⟨a, H⟩
    have ha : H.val q = a := by
      simpa only [Function.update_self] using H.property q (Finset.mem_insert_self _ _)
    exact Sigma.ext ha ((Subtype.heq_iff_coe_eq (fun _ => by dsimp only; rw [ha])).mpr rfl)

theorem media_revelar (S : Finset Q) (v : Q → A) (q : Q) (hq : q ∉ S)
    (f : (Q → A) → ℚ) :
    promedio (fun H : Completaciones S v => f H.val) =
      promedio (fun a : A => promedio
        (fun H : Completaciones (insert q S) (Function.update v q a) => f H.val)) := by
  have he := media_equivalencia (particion S v q hq).symm
    (fun H : Completaciones S v => f H.val)
  rw [← he]
  exact media_sigma (Fintype.card A ^ (Fintype.card Q - (insert q S).card))
    (fun _ => cardinal_completaciones _ _) _

theorem media_vacia (v : Q → A) (f : (Q → A) → ℚ) :
    promedio (fun H : Completaciones ∅ v => f H.val) = promedio f := by
  let e : Completaciones ∅ v ≃ (Q → A) :=
    { toFun := Subtype.val
      invFun := fun H => ⟨H, by simp⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  exact media_equivalencia e f

end Nexus.ROM.PromediosCompletaciones
