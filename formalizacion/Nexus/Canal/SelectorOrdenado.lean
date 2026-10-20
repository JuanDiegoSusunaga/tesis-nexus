module

public import Nexus.Canal.ProgramaTG2
import Mathlib.Tactic

/-!
# Selector con orden de primera aparición

Rust agrega cada índice nuevo al final y lo empareja con la consulta de esa
posición del certificado. Se conserva ese orden y se prueba que olvidarlo
produce exactamente el programa anterior de conjuntos, con la misma tabla.
El corte R sigue siendo analítico, no una parada añadida a Rust.
-/

public section
namespace Nexus.Canal.SelectorOrdenado

open Nexus.Bytes Nexus.Merkle Nexus.Canal.GramaticaTG2
open Nexus.ROM.ProgramaCompartido

@[expose] def agregar {A : Type*} [DecidableEq A] (S : List A) (a : A) : List A :=
  if a ∈ S then S else S ++ [a]

theorem agregar_sin_duplicados {A : Type*} [DecidableEq A] (S : List A) (a : A) (hs : S.Nodup) :
    (agregar S a).Nodup := by
  by_cases ha : a ∈ S
  · simpa only [agregar, ha, ite_true] using hs
  · simp only [agregar, ha, ite_false, List.nodup_append, hs, List.nodup_singleton,
      true_and, List.mem_singleton]
    intro b hb c hc he
    exact ha (hc ▸ he ▸ hb)

theorem agregar_conjunto {A : Type*} [DecidableEq A] (S : List A) (a : A) :
    (agregar S a).toFinset = insert a S.toFinset := by
  by_cases ha : a ∈ S
  · simp [agregar, ha, Finset.insert_eq_of_mem (List.mem_toFinset.mpr ha)]
  · simp [agregar, ha]

theorem agregar_conserva_prefijo {A : Type*} [DecidableEq A] (S : List A) (a : A) : S <+: agregar S a := by
  by_cases ha : a ∈ S
  · simp only [agregar, ha, ite_true]
    exact List.prefix_refl S
  · simp only [agregar, ha, ite_false]
    exact List.prefix_append _ _

@[expose] def seleccionar (M : ℕ) (hM : 0 < M) :
    ℕ → Digest → List (Fin M) → (List (Fin M) → Programa) → Programa
  | R, s, S, continuar =>
    if S.length = 40 then continuar S else
      match R with
      | 0 => .terminar false
      | R + 1 => .consultar (.indice s) (fun d => seleccionar M hM R d
          (agregar S (ProgramaTG2.indice M hM d)) continuar)

theorem proyeccion_conjuntos (M : ℕ) (hM : 0 < M) (R : ℕ) (s : Digest) (S : List (Fin M))
    (hs : S.Nodup) (continuar : Finset (Fin M) → Programa) :
    seleccionar M hM R s S (fun xs => continuar xs.toFinset) =
      ProgramaTG2.seleccionar M hM R s S.toFinset continuar := by
  induction R generalizing s S with
  | zero => simp only [seleccionar, ProgramaTG2.seleccionar, List.toFinset_card_of_nodup hs]
  | succ R ih =>
    simp only [seleccionar, ProgramaTG2.seleccionar, List.toFinset_card_of_nodup hs]
    split_ifs with h
    · rfl
    · congr 1
      funext d
      rw [ih d _ (agregar_sin_duplicados S _ hs), agregar_conjunto]

theorem aceptacion_lista_completa (M : ℕ) (hM : 0 < M) (R : ℕ) (s : Digest) (S : List (Fin M))
    (hs : S.Nodup) (H : Clave → Digest) (continuar : List (Fin M) → Programa)
    (ha : resultado H (seleccionar M hM R s S continuar) = true) :
    ∃ T, T.Nodup ∧ T.length = 40 ∧ S <+: T ∧ resultado H (continuar T) = true := by
  induction R generalizing s S with
  | zero =>
    simp only [seleccionar] at ha
    split_ifs at ha with h
    · exact ⟨S, hs, h, List.prefix_refl S, ha⟩
    · contradiction
  | succ R ih =>
    simp only [seleccionar] at ha
    split_ifs at ha with h
    · exact ⟨S, hs, h, List.prefix_refl S, ha⟩
    · have hrec := ih (H (clave (.indice s))) _ (agregar_sin_duplicados S _ hs) ha
      obtain ⟨T, hT, hlen, hpre, hfin⟩ := hrec
      exact ⟨T, hT, hlen, (agregar_conserva_prefijo S _).trans hpre, hfin⟩

end Nexus.Canal.SelectorOrdenado
