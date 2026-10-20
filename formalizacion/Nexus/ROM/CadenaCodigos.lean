module

public import Nexus.ROM.AcoplamientoArbol
public import Nexus.ROM.CintasRetos
public import Nexus.ROM.RepeticionesCinta
import Mathlib.Tactic

/-!
# Cadenas con codificaciones que cambian entre rondas

Cada respuesta pasa a ser el estado de la siguiente consulta. Las distintas
codificaciones pueden solaparse, pero una coincidencia de entradas debe
determinar el mismo estado. Esto incluye la alternancia absorción/extensión.
-/

public section
namespace Nexus.ROM.CadenaCodigos

open Nexus.N06 LeyArbol AcoplamientoArbol

variable {A Q : Type}

@[expose] def arbol : List (A → Q) → A → Arbol Q A (List A)
  | [], _ => .terminar []
  | c :: cs, s => .consultar (c s) (fun a => transformar (List.cons a) (arbol cs a))

@[expose] def EstadosSeparados (cs : List (A → Q)) : Prop :=
  ∀ c ∈ cs, ∀ d ∈ cs, ∀ a b, c a = d b → a = b

theorem separados_cola {c : A → Q} {cs : List (A → Q)}
    (h : EstadosSeparados (c :: cs)) : EstadosSeparados cs := by
  intro d hd e he a b hab
  exact h d (List.mem_cons_of_mem _ hd) e (List.mem_cons_of_mem _ he) a b hab

theorem transformar_comp {R T U : Type} (f : R → T) (g : T → U) (p : Arbol Q A R) :
    transformar g (transformar f p) = transformar (fun r => g (f r)) p := by
  induction p with
  | terminar => rfl
  | consultar q k ih =>
    simp only [transformar]
    congr 1
    funext a
    exact ih a

variable [Fintype A] [Nonempty A] [DecidableEq Q]

omit [DecidableEq Q] [Nonempty A] in
theorem media_transformar {R T : Type} (g : R → T) (p : Arbol Q A R) (f : T → ℚ) :
    media f (transformar g p) = media (fun r => f (g r)) p := by
  induction p with
  | terminar => rfl
  | consultar q k ih =>
    simp only [transformar, media]
    apply congrArg promedio
    funext a
    exact ih a

omit [DecidableEq Q] in
theorem media_arbol (cs : List (A → Q)) (s : A) (f : List A → ℚ) :
    media f (arbol cs s) =
      promedio (fun xs : Retos A cs.length => f (CintasRetos.lista xs)) := by
  induction cs generalizing s f with
  | nil => simp only [arbol, media, List.length_nil, CintasRetos.lista, promedio_constante]
  | cons c cs ih =>
    simp only [arbol, media, media_transformar, List.length_cons]
    simp_rw [ih]
    exact (promedio_producto
      (fun xs : A × Retos A cs.length => f (xs.1 :: CintasRetos.lista xs.2))).symm

variable [DecidableEq A]

theorem repeticion_le_cinta (cs : List (A → Q)) (s : A) (S : Finset Q) (T : Finset A)
    (hsep : EstadosSeparados cs) (hs : ∀ c ∈ cs, c s ∉ S) (hst : s ∈ T)
    (hS : ∀ c ∈ cs, ∀ a, c a ∈ S → a ∈ T) :
    repeticion (arbol cs s) S ≤ RepeticionesCinta.probabilidad T cs.length := by
  classical
  induction cs generalizing s S T with
  | nil => simp [arbol, repeticion, RepeticionesCinta.probabilidad,
      RepeticionesCinta.Limpia, promedio_constante]
  | cons c cs ih =>
    simp only [arbol, repeticion, hs c (List.mem_cons_self), ite_false]
    simp_rw [repeticion_transformar]
    rw [List.length_cons, RepeticionesCinta.recurrencia]
    apply promedio_monotono
    intro a
    by_cases ha : a ∈ T
    · simp only [ha, ite_true]
      exact repeticion_acotada_uno _ _
    · simp only [ha, ite_false]
      apply ih a (insert (c s) S) (insert a T) (separados_cola hsep)
      · intro d hd hmem
        rcases Finset.mem_insert.mp hmem with he | he
        · exact ha ((hsep d (List.mem_cons_of_mem _ hd) c
            (List.mem_cons_self) a s he) ▸ hst)
        · exact ha (hS d (List.mem_cons_of_mem _ hd) a he)
      · exact Finset.mem_insert_self _ _
      · intro d hd b hmem
        apply Finset.mem_insert_of_mem
        rcases Finset.mem_insert.mp hmem with he | he
        · exact (hsep d (List.mem_cons_of_mem _ hd) c
            (List.mem_cons_self) b s he) ▸ hst
        · exact hS d (List.mem_cons_of_mem _ hd) b he

theorem repeticion_desde_vacio (cs : List (A → Q)) (s : A)
    (hsep : EstadosSeparados cs) :
    repeticion (arbol cs s) ∅ ≤
      min 1 (((cs.length * (cs.length + 1) : ℕ) : ℚ) / Fintype.card A) := by
  have h := repeticion_le_cinta cs s ∅ {s} hsep
    (by intros; simp) (Finset.mem_singleton_self s) (by intros; simp_all)
  exact h.trans (by simpa [Nat.add_comm] using RepeticionesCinta.cota_minimo {s} cs.length)

end Nexus.ROM.CadenaCodigos
