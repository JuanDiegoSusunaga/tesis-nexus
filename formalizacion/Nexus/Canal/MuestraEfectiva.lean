module

public import Nexus.Canal.CintaSelector
import Mathlib.Tactic

/-!
# La muestra ordenada es una función de la cadena efectiva de índices

Se conserva la parada al completar cuarenta índices distintos. La igualdad
con la cinta permite identificar la muestra del verificador sin elegir una
lista aceptante ajena a su ejecución. R conserva su interpretación analítica.
-/

public section
namespace Nexus.Canal.MuestraEfectiva

open Nexus.Bytes Nexus.Merkle Nexus.ROM
open ProgramaCompartido RegistroPrograma GramaticaTG2 SelectorOrdenado

@[expose] def recoger (H : Entrada → Digest) (M : ℕ) (hM : 0 < M) :
    ℕ → Digest → List (Fin M) → List (Fin M)
  | R, s, S => if S.length = 40 then S else
      match R with
      | 0 => S
      | R + 1 => let d := H (entradaReto s .indice)
          recoger H M hM R d (agregar S (ProgramaTG2.indice M hM d))

theorem resultado_lista (H : Entrada → Digest) (M : ℕ) (hM : 0 < M) (R : ℕ)
    (s : Digest) (S : List (Fin M)) (c : List (Fin M) → Programa) :
    resultado (tabla H) (seleccionar M hM R s S c) =
      if (recoger H M hM R s S).length = 40 then resultado (tabla H) (c (recoger H M hM R s S)) else false := by
  induction R generalizing s S with
  | zero => simp only [seleccionar, recoger]; split_ifs <;> rfl
  | succ R ih =>
    by_cases h : S.length = 40
    · simp only [seleccionar, recoger, h, ite_true]
    · simp only [seleccionar, recoger, h, ite_false, resultado, tabla_codificacion, codificar]
      exact ih _ _

theorem lista_sin_duplicados (H : Entrada → Digest) (M : ℕ) (hM : 0 < M) (R : ℕ)
    (s : Digest) (S : List (Fin M)) (hs : S.Nodup) : (recoger H M hM R s S).Nodup := by
  induction R generalizing s S with
  | zero => simpa only [recoger, ite_self] using hs
  | succ R ih =>
    simp only [recoger]
    split_ifs
    · exact hs
    · exact ih _ _ (agregar_sin_duplicados S _ hs)

theorem soporte_lista (H : Entrada → Digest) (M : ℕ) (hM : 0 < M) (R : ℕ)
    (s : Digest) (S : List (Fin M)) (c : List (Fin M) → Programa)
    (hc : (recoger H M hM R s S).length = 40) :
    ∀ e ∈ entradas H (c (recoger H M hM R s S)), e ∈ entradas H (seleccionar M hM R s S c) := by
  induction R generalizing s S with
  | zero =>
    simp only [recoger, ite_self] at hc ⊢
    simp only [seleccionar, hc, ite_true]
    exact fun _ h => h
  | succ R ih =>
    by_cases h : S.length = 40
    · simp only [recoger, seleccionar, h, ite_true]
      exact fun _ h => h
    · simp only [recoger, seleccionar, h, ite_false, entradas, codificar] at hc ⊢
      intro e he
      exact List.mem_cons_of_mem _ (ih _ _ hc e he)

theorem aceptacion_lista (H : Entrada → Digest) (M : ℕ) (hM : 0 < M) (R : ℕ)
    (s : Digest) (S : List (Fin M)) (hs : S.Nodup) (c : List (Fin M) → Programa)
    (ha : resultado (tabla H) (seleccionar M hM R s S c) = true) :
    let T := recoger H M hM R s S
    T.Nodup ∧ T.length = 40 ∧ resultado (tabla H) (c T) = true ∧
      ∀ e ∈ entradas H (c T), e ∈ entradas H (seleccionar M hM R s S c) := by
  rw [resultado_lista] at ha
  split_ifs at ha with hc
  exact ⟨lista_sin_duplicados H M hM R s S hs, hc, ha, soporte_lista H M hM R s S c hc⟩

theorem conjunto_desde_cinta (H : Entrada → Digest) (M : ℕ) (hM : 0 < M) (R : ℕ)
    (s : Digest) (S : List (Fin M)) (hs : S.Nodup) (hlen : S.length ≤ 40)
    (hc : (recoger H M hM R s S).length = 40) :
    (recoger H M hM R s S).toFinset =
      Selector.seleccionar 40 S.toFinset (CintaSelector.indices H M hM R s) := by
  classical
  let c : Finset (Fin M) → Programa := fun T => .terminar (decide (T = (recoger H M hM R s S).toFinset))
  have ha : resultado (tabla H) (seleccionar M hM R s S (fun xs => c xs.toFinset)) = true := by
    rw [resultado_lista]
    simp only [hc, ite_true, c, resultado, decide_true]
  rw [CintaSelector.resultado_ordenado_desde_cinta H M hM R s S hs hlen c] at ha
  dsimp only at ha
  split_ifs at ha
  simp only [c, resultado, decide_eq_true_eq] at ha
  exact ha.symm

theorem transportar_selector (M N : ℕ) (hM : 0 < M) (hN : 0 < N) (h : M = N) (ds : List Digest) :
    (Selector.seleccionar 40 ∅ (ds.map (ProgramaTG2.indice M hM))).image (Fin.cast h) =
      Selector.seleccionar 40 ∅ (ds.map (ProgramaTG2.indice N hN)) := by
  subst N
  simp only [Fin.cast_refl, Finset.image_id]

end Nexus.Canal.MuestraEfectiva
