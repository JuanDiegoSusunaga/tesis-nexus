module

public import Nexus.ROM.PalabrasDigest
public import Nexus.ROM.PromediosCompletaciones
import Mathlib.Tactic

/-!
# Cintas recursivas y vectores de respuestas

Se identifica el producto de retos usado por el muestreador con las funciones
Fin R → A de las leyes del selector. La igualdad de medias incluye cualquier
evento de toda la cinta, sin condicionarlo a un evento futuro.
-/

public section
namespace Nexus.ROM.CintasRetos

open Nexus.N06

variable {A : Type}

@[expose] def lista : {n : ℕ} → Retos A n → List A
  | 0, _ => []
  | _ + 1, xs => xs.1 :: lista xs.2

theorem longitud (n : ℕ) (xs : Retos A n) : (lista xs).length = n := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [lista, List.length_cons, ih]

@[expose] def equivalencia : (n : ℕ) → Retos A n ≃ (Fin n → A)
  | 0 =>
      { toFun := fun _ i => Fin.elim0 i
        invFun := fun _ => PUnit.unit
        left_inv := fun xs => by cases xs; rfl
        right_inv := fun w => by funext i; exact Fin.elim0 i }
  | n + 1 =>
      { toFun := fun xs => Fin.cons xs.1 (equivalencia n xs.2)
        invFun := fun w => (w 0, (equivalencia n).symm (Fin.tail w))
        left_inv := fun xs => by
          change (xs.1, (equivalencia n).symm (equivalencia n xs.2)) = xs
          rw [Equiv.symm_apply_apply]
          cases xs
          rfl
        right_inv := fun w => by
          funext i
          refine Fin.cases ?_ (fun j => ?_) i
          · rfl
          · change equivalencia n ((equivalencia n).symm (Fin.tail w)) j = w j.succ
            rw [Equiv.apply_symm_apply]
            rfl }

theorem lista_equivalencia (n : ℕ) (xs : Retos A n) :
    lista xs = List.ofFn (equivalencia n xs) := by
  induction n with
  | zero => simp only [lista, List.ofFn_zero]
  | succ n ih =>
    rw [List.ofFn_succ]
    change xs.1 :: lista xs.2 = xs.1 :: List.ofFn (equivalencia n xs.2)
    rw [ih]

theorem promedio_equivalencia [Fintype A] (n : ℕ) (f : (Fin n → A) → ℚ) :
    promedio (fun xs : Retos A n => f (equivalencia n xs)) = promedio f :=
  PromediosCompletaciones.media_equivalencia (equivalencia n) f

theorem promedio_listas [Fintype A] (n : ℕ) (f : List A → ℚ) :
    promedio (fun xs : Retos A n => f (lista xs)) =
      promedio (fun w : Fin n → A => f (List.ofFn w)) := by
  simp_rw [lista_equivalencia]
  exact promedio_equivalencia (A := A) n (fun w : Fin n → A => f (List.ofFn w))

end Nexus.ROM.CintasRetos
