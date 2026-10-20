module

public import Nexus.ROM.LeyArbol
public import Nexus.ROM.CintasRetos
public import Nexus.ROM.RepeticionesCinta
import Mathlib.Tactic

/-!
# Cadena de consultas memorizadas sobre una cinta uniforme

Se consume una coordenada ideal por paso; una repetición ignora esa coordenada
y devuelve el valor guardado. Esa coordenada no utilizada no altera la ley.
Fuera de las repeticiones especificadas, el resultado es la propia cinta.
-/

public section
namespace Nexus.ROM.CadenaMemoria

open Nexus.N06 LeyArbol FrescuraFinita

variable {A Q : Type}

@[expose] def cinta (codificar : A → Q) (H : Q → A) : ℕ → A → List A
  | 0, _ => []
  | n + 1, s => let a := H (codificar s); a :: cinta codificar H n a

@[expose] def arbol (codificar : A → Q) : ℕ → A → Arbol Q A (List A)
  | 0, _ => .terminar []
  | n + 1, s => .consultar (codificar s) (fun a => transformar (List.cons a) (arbol codificar n a))

theorem evaluar_arbol (codificar : A → Q) (H : Q → A) (n : ℕ) (s : A) :
    evaluar H (arbol codificar n s) = cinta codificar H n s := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => simp only [arbol, evaluar, evaluar_transformar, ih, cinta]

variable [DecidableEq Q]

@[expose] def muestrear (codificar : A → Q) :
    (n : ℕ) → A → Finset Q → (Q → A) → Retos A n → List A
  | 0, _, _, _, _ => []
  | n + 1, s, S, v, xs =>
      let a := if codificar s ∈ S then v (codificar s) else xs.1
      a :: muestrear codificar n a (insert (codificar s) S) (Function.update v (codificar s) a) xs.2

@[expose] def Fresca (codificar : A → Q) :
    {n : ℕ} → A → Finset Q → Retos A n → Prop
  | 0, _, _, _ => True
  | _ + 1, s, S, xs => codificar s ∉ S ∧ Fresca codificar xs.1 (insert (codificar s) S) xs.2

theorem fresca_igual_cinta (codificar : A → Q) (n : ℕ) (s : A) (S : Finset Q)
    (v : Q → A) (xs : Retos A n) (hf : Fresca codificar s S xs) :
    muestrear codificar n s S v xs = CintasRetos.lista xs := by
  induction n generalizing s S v with
  | zero => rfl
  | succ n ih =>
    simp only [muestrear, hf.1, ite_false, CintasRetos.lista]
    exact congrArg (List.cons xs.1) (ih _ _ _ xs.2 hf.2)

variable [DecidableEq A]

theorem limpia_implica_fresca (codificar : A → Q) (hi : Function.Injective codificar)
    (n : ℕ) (s : A) (S : Finset Q) (T : Finset A) (xs : Retos A n)
    (hs : codificar s ∉ S) (hT : s ∈ T)
    (hc : ∀ a, codificar a ∈ S → a ∈ T) (hl : RepeticionesCinta.Limpia T xs) :
    Fresca codificar s S xs := by
  induction n generalizing s S T with
  | zero => trivial
  | succ n ih =>
    refine ⟨hs, ih xs.1 (insert (codificar s) S) (insert xs.1 T) xs.2 ?_
      (Finset.mem_insert_self _ _) ?_ hl.2⟩
    · intro he
      rcases Finset.mem_insert.mp he with he | he
      · exact hl.1 (hi he ▸ hT)
      · exact hl.1 (hc xs.1 he)
    · intro a ha
      apply Finset.mem_insert_of_mem
      rcases Finset.mem_insert.mp ha with he | he
      · exact hi he ▸ hT
      · exact hc a he

variable [Fintype A]

@[expose] noncomputable def previos (codificar : A → Q) (S : Finset Q) : Finset A :=
  Finset.univ.filter (fun a => codificar a ∈ S)

omit [DecidableEq A] in
theorem cardinal_previos (codificar : A → Q) (hi : Function.Injective codificar) (S : Finset Q) :
    (previos codificar S).card ≤ S.card := by
  rw [← Finset.card_image_of_injective (previos codificar S) hi]
  apply Finset.card_le_card
  intro q hq
  obtain ⟨a, ha, rfl⟩ := Finset.mem_image.mp hq
  exact (Finset.mem_filter.mp ha).2

theorem limpia_acopla (codificar : A → Q) (hi : Function.Injective codificar)
    (n : ℕ) (s : A) (S : Finset Q) (v : Q → A) (xs : Retos A n)
    (hs : codificar s ∉ S) (hl : RepeticionesCinta.Limpia (insert s (previos codificar S)) xs) :
    muestrear codificar n s S v xs = CintasRetos.lista xs := by
  apply fresca_igual_cinta
  apply limpia_implica_fresca codificar hi n s S _ xs hs (Finset.mem_insert_self _ _)
  · intro a ha
    exact Finset.mem_insert_of_mem (Finset.mem_filter.mpr ⟨Finset.mem_univ _, ha⟩)
  · exact hl

omit [DecidableEq A] in
theorem valor_transformar {R T : Type} (g : R → T) (p : Arbol Q A R) (f : T → ℚ)
    (S : Finset Q) (v : Q → A) :
    LeyArbol.valor f (transformar g p) S v = LeyArbol.valor (fun r => f (g r)) p S v := by
  induction p generalizing S v with
  | terminar => rfl
  | consultar q k ih =>
    simp only [transformar, LeyArbol.valor]
    split_ifs
    · exact ih _ _ _
    · congr 1
      funext a
      exact ih _ _ _

variable [Nonempty A]

omit [DecidableEq A] in
theorem media_muestreo (codificar : A → Q) (n : ℕ) (s : A) (S : Finset Q)
    (v : Q → A) (f : List A → ℚ) :
    promedio (fun xs : Retos A n => f (muestrear codificar n s S v xs)) =
      LeyArbol.valor f (arbol codificar n s) S v := by
  induction n generalizing s S v f with
  | zero => exact promedio_constante (f [])
  | succ n ih =>
    change (promedio (fun xs : A × Retos A n => _)) = _
    rw [promedio_producto]
    by_cases hs : codificar s ∈ S
    · simp only [muestrear, hs, ite_true, Finset.insert_eq_of_mem hs, Function.update_eq_self]
      have ht := ih (v (codificar s)) S v (fun ys => f (v (codificar s) :: ys))
      simp_rw [ht]
      rw [promedio_constante]
      simp only [arbol, LeyArbol.valor, hs, ite_true, valor_transformar]
    · simp only [muestrear, hs, ite_false]
      change promedio (fun a : A => _) = _
      simp only [arbol, LeyArbol.valor, hs, ite_false, valor_transformar]
      congr 1
      funext a
      exact ih a (insert (codificar s) S) (Function.update v (codificar s) a) (fun ys => f (a :: ys))

omit [DecidableEq A] in
theorem ley_condicionada [Fintype Q] (codificar : A → Q) (n : ℕ) (s : A)
    (S : Finset Q) (v : Q → A) (f : List A → ℚ) :
    promedio (fun H : Completaciones S v => f (cinta codificar H.val n s)) =
      promedio (fun xs : Retos A n => f (muestrear codificar n s S v xs)) := by
  rw [media_muestreo, ← LeyArbol.ley_condicionada (arbol codificar n s) S v f]
  simp_rw [evaluar_arbol]

end Nexus.ROM.CadenaMemoria
