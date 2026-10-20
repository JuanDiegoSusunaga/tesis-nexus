module

public import Nexus.ROM.CadenaMemoria
public import Nexus.ROM.ComparacionAcoplada
import Mathlib.Tactic

/-!
# Transferencia cuantitativa desde una cadena ROM a una cinta independiente

El pasado es fijo y compatible. La dirección inicial debe ser nueva.
No se condiciona al evento de ausencia de repeticiones: su probabilidad
se paga como un término aditivo explícito en la comparación de leyes.
-/

public section
namespace Nexus.ROM.AcoplamientoCadena

open Nexus.N06 FrescuraFinita

variable {A Q : Type} [DecidableEq A] [DecidableEq Q] [Fintype A] [Nonempty A]

attribute [local instance] Classical.propDecidable

@[expose] noncomputable def error (A : Type) [Fintype A] (n m : ℕ) : ℚ :=
  min 1 (((n * (m + n + 1) : ℕ) : ℚ) / Fintype.card A)

omit [DecidableEq A] in
theorem error_no_negativo (n m : ℕ) : 0 ≤ error A n m := by
  unfold error
  exact le_min (by norm_num) (by positivity)

omit [DecidableEq A] [Nonempty A] in
theorem error_acotado_uno (n m : ℕ) : error A n m ≤ 1 := min_le_left _ _

theorem cota_repeticiones (codificar : A → Q) (hi : Function.Injective codificar)
    (n : ℕ) (s : A) (S : Finset Q) :
    RepeticionesCinta.probabilidad (insert s (CadenaMemoria.previos codificar S)) n ≤ error A n S.card := by
  apply (RepeticionesCinta.cota_minimo _ _).trans
  apply min_le_min_left
  apply div_le_div_of_nonneg_right _ (by positivity)
  exact_mod_cast Nat.mul_le_mul_left n (show
    (insert s (CadenaMemoria.previos codificar S)).card + n ≤ S.card + n + 1 from by
      have hc := CadenaMemoria.cardinal_previos codificar hi S
      have hi := Finset.card_insert_le s (CadenaMemoria.previos codificar S)
      omega)

theorem diferencia_muestreo (codificar : A → Q) (hi : Function.Injective codificar)
    (n : ℕ) (s : A) (S : Finset Q) (v : Q → A) (hs : codificar s ∉ S)
    (E : List A → Prop) [DecidablePred E] :
    |promedio (fun xs : Retos A n => if E (CadenaMemoria.muestrear codificar n s S v xs) then (1 : ℚ) else 0) -
        promedio (fun xs : Retos A n => if E (CintasRetos.lista xs) then 1 else 0)| ≤ error A n S.card := by
  apply (ComparacionAcoplada.diferencia_evento _ _
    (fun xs : Retos A n => ¬ RepeticionesCinta.Limpia (insert s (CadenaMemoria.previos codificar S)) xs)
    (fun xs hx => CadenaMemoria.limpia_acopla codificar hi n s S v xs hs (not_not.mp hx)) E).trans
  exact cota_repeticiones codificar hi n s S

theorem transferencia_muestreo (codificar : A → Q) (hi : Function.Injective codificar)
    (n : ℕ) (s : A) (S : Finset Q) (v : Q → A) (hs : codificar s ∉ S)
    (E : List A → Prop) [DecidablePred E] :
    promedio (fun xs : Retos A n => if E (CadenaMemoria.muestrear codificar n s S v xs) then (1 : ℚ) else 0) ≤
      promedio (fun xs : Retos A n => if E (CintasRetos.lista xs) then 1 else 0) + error A n S.card := by
  have h := diferencia_muestreo codificar hi n s S v hs E
  linarith [(abs_le.mp h).2]

theorem diferencia_rom [Fintype Q] (codificar : A → Q) (hi : Function.Injective codificar)
    (n : ℕ) (s : A) (S : Finset Q) (v : Q → A) (hs : codificar s ∉ S)
    (E : List A → Prop) [DecidablePred E] :
    |promedio (fun H : Completaciones S v => if E (CadenaMemoria.cinta codificar H.val n s) then (1 : ℚ) else 0) -
        promedio (fun xs : Retos A n => if E (CintasRetos.lista xs) then 1 else 0)| ≤ error A n S.card := by
  rw [CadenaMemoria.ley_condicionada codificar n s S v (fun ys => if E ys then (1 : ℚ) else 0)]
  exact diferencia_muestreo codificar hi n s S v hs E

theorem diferencia_vector [Fintype Q] (codificar : A → Q) (hi : Function.Injective codificar)
    (n : ℕ) (s : A) (S : Finset Q) (v : Q → A) (hs : codificar s ∉ S)
    (E : List A → Prop) [DecidablePred E] :
    |promedio (fun H : Completaciones S v => if E (CadenaMemoria.cinta codificar H.val n s) then (1 : ℚ) else 0) -
        promedio (fun w : Fin n → A => if E (List.ofFn w) then 1 else 0)| ≤ error A n S.card := by
  rw [← CintasRetos.promedio_listas n (fun ys => if E ys then (1 : ℚ) else 0)]
  exact diferencia_rom codificar hi n s S v hs E

end Nexus.ROM.AcoplamientoCadena
