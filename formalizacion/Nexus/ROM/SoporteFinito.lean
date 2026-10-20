module

public import Nexus.ROM.LeyArbol
public import Nexus.ROM.ProgramaBytes
import Mathlib.Tactic

/-!
# Universo finito derivado del programa de bytes

El soporte contiene las direcciones de todas las ramas, incluidas las elegidas
adaptativamente. Restringir una tabla a cualquier universo que lo contenga
conserva resultado y transcripción. Su ley conjunta es la del muestreo con
memoria, sin hipótesis SinBad y sin distribuir uniformemente funciones sobre
el dominio infinito de listas de bytes.
-/

public section
namespace Nexus.ROM.SoporteFinito

open Nexus.Bytes Nexus.Merkle Nexus.N06 ProgramaBytes

set_option maxRecDepth 4096

@[expose] noncomputable def soporte {R : Type} : Programa R → Finset Entrada
  | .terminar _ => ∅
  | .consultar e k => insert e (Finset.univ.biUnion (fun d => soporte (k d)))

theorem consulta_en_soporte {R : Type} (e : Entrada) (k : Digest → Programa R) :
    e ∈ soporte (.consultar e k) := Finset.mem_insert_self _ _

theorem rama_en_soporte {R : Type} (e : Entrada) (k : Digest → Programa R) (d : Digest) :
    soporte (k d) ⊆ soporte (.consultar e k) := by
  intro x hx
  exact Finset.mem_insert_of_mem (Finset.mem_biUnion.mpr ⟨d, Finset.mem_univ _, hx⟩)

theorem entradas_en_soporte {R : Type} (H : Entrada → Digest) (p : Programa R) :
    ∀ e ∈ entradas H p, e ∈ soporte p := by
  induction p with
  | terminar r => intro e he; contradiction
  | consultar q k ih =>
    intro e he
    rcases List.mem_cons.mp he with heq | he
    · subst e
      exact consulta_en_soporte q k
    · exact rama_en_soporte q k (H q) (ih _ e he)

theorem resultado_por_soporte {R : Type} (H G : Entrada → Digest) (p : Programa R)
    (h : ∀ e ∈ soporte p, H e = G e) : resultado H p = resultado G p := by
  induction p with
  | terminar => rfl
  | consultar q k ih =>
    have he := h q (consulta_en_soporte q k)
    simp only [resultado, he]
    exact ih _ (fun e hm => h e (rama_en_soporte q k _ hm))

theorem traza_por_soporte {R : Type} (H G : Entrada → Digest) (p : Programa R)
    (h : ∀ e ∈ soporte p, H e = G e) : traza H p = traza G p := by
  induction p with
  | terminar => rfl
  | consultar q k ih =>
    have he := h q (consulta_en_soporte q k)
    simp only [traza, he]
    exact congrArg (List.cons _) (ih _ (fun e hm => h e (rama_en_soporte q k _ hm)))

@[expose] noncomputable def prolongar (V : Finset Entrada) (defecto : Digest)
    (H : V → Digest) (e : Entrada) : Digest := if h : e ∈ V then H ⟨e, h⟩ else defecto

theorem prolongar_en_universo (V : Finset Entrada) (defecto : Digest) (H : V → Digest)
    (e : Entrada) (he : e ∈ V) : prolongar V defecto H e = H ⟨e, he⟩ := by
  simp only [prolongar, he, dite_true]

@[expose] def arbol {R : Type} : Programa R → LeyArbol.Arbol Entrada Digest R
  | .terminar r => .terminar r
  | .consultar e k => .consultar e (fun d => arbol (k d))

theorem resultado_arbol {R : Type} (H : Entrada → Digest) (p : Programa R) :
    LeyArbol.evaluar H (arbol p) = resultado H p := by
  induction p with
  | terminar => rfl
  | consultar e k ih => exact ih _

theorem traza_arbol {R : Type} (H : Entrada → Digest) (p : Programa R) :
    LeyArbol.traza H (arbol p) = traza H p := by
  induction p with
  | terminar => rfl
  | consultar e k ih => exact congrArg (List.cons _) (ih _)

@[expose] noncomputable def restringir {R : Type} (V : Finset Entrada) :
    (p : Programa R) → soporte p ⊆ V → LeyArbol.Arbol V Digest R
  | .terminar r, _ => .terminar r
  | .consultar e k, hp => .consultar ⟨e, hp (consulta_en_soporte e k)⟩
      (fun d => restringir V (k d) ((rama_en_soporte e k d).trans hp))

theorem resultado_restringir {R : Type} (V : Finset Entrada) (H : Entrada → Digest)
    (p : Programa R) (hp : soporte p ⊆ V) :
    LeyArbol.evaluar (fun e : V => H e.val) (restringir V p hp) = resultado H p := by
  induction p with
  | terminar => rfl
  | consultar e k ih => exact ih _ _

theorem traza_restringir {R : Type} (V : Finset Entrada) (H : Entrada → Digest)
    (p : Programa R) (hp : soporte p ⊆ V) :
    (LeyArbol.traza (fun e : V => H e.val) (restringir V p hp)).map
      (fun ed => (ed.1.val, ed.2)) = traza H p := by
  induction p with
  | terminar => rfl
  | consultar e k ih => exact congrArg (List.cons _) (ih _ _)

@[expose] noncomputable def vistas (V S : Finset Entrada) : Finset V :=
  Finset.univ.filter (fun e => e.val ∈ S)

theorem vistas_insertar (V S : Finset Entrada) (e : Entrada) (he : e ∈ V) :
    vistas V (insert e S) = insert ⟨e, he⟩ (vistas V S) := by
  ext x
  simp only [vistas, Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_insert,
    Subtype.ext_iff]

theorem actualizar_restriccion (V : Finset Entrada) (v : Entrada → Digest)
    (e : Entrada) (he : e ∈ V) (d : Digest) :
    (fun x : V => Function.update v e d x.val) =
      Function.update (fun x : V => v x.val) ⟨e, he⟩ d := by
  funext x
  by_cases hx : x.val = e
  · have heq : x = ⟨e, he⟩ := Subtype.ext hx
    subst x
    simp only [Function.update_self]
  · have hn : x ≠ ⟨e, he⟩ := fun h => hx (congrArg Subtype.val h)
    simp only [Function.update_of_ne hx, Function.update_of_ne hn]

theorem valor_restringir {R : Type} (V : Finset Entrada) (p : Programa R)
    (hp : soporte p ⊆ V) (S : Finset Entrada) (v : Entrada → Digest) (f : R → ℚ) :
    LeyArbol.valor f (restringir V p hp) (vistas V S) (fun e : V => v e.val) =
      LeyArbol.valor f (arbol p) S v := by
  induction p generalizing S v with
  | terminar => rfl
  | consultar e k ih =>
    have he : e ∈ V := hp (consulta_en_soporte e k)
    change (if (⟨e, he⟩ : V) ∈ vistas V S then _ else _) = (if e ∈ S then _ else _)
    have hm : (⟨e, he⟩ : V) ∈ vistas V S ↔ e ∈ S := by simp only [vistas, Finset.mem_filter, Finset.mem_univ, true_and]
    by_cases hs : e ∈ S
    · rw [ite_eq_left (hm.mpr hs), ite_eq_left hs]
      exact ih _ _ S v
    · rw [ite_eq_right (fun h => hs (hm.mp h)), ite_eq_right hs]
      congr 1
      funext d
      rw [← actualizar_restriccion V v e he d, ← vistas_insertar V S e he]
      exact ih _ _ _ _

theorem ley_global {R : Type} (V : Finset Entrada) (p : Programa R)
    (hp : soporte p ⊆ V) (defecto : Digest) (f : R → ℚ) :
    promedio (fun H : V → Digest => f (resultado (prolongar V defecto H) p)) =
      LeyArbol.valor f (arbol p) ∅ (fun _ => defecto) := by
  have he (H : V → Digest) : (fun e : V => prolongar V defecto H e.val) = H := by
    funext e
    exact prolongar_en_universo V defecto H e.val e.property
  have hr (H : V → Digest) := resultado_restringir V (prolongar V defecto H) p hp
  simp only [he] at hr
  simp_rw [← hr]
  rw [LeyArbol.ley_desde_vacio (restringir V p hp) (fun _ => defecto)]
  simpa [vistas] using
    valor_restringir V p hp ∅ (fun _ => defecto) f

theorem universo_inmaterial {R : Type} (V W : Finset Entrada) (p : Programa R)
    (hV : soporte p ⊆ V) (hW : soporte p ⊆ W) (defecto : Digest) (f : R → ℚ) :
    promedio (fun H : V → Digest => f (resultado (prolongar V defecto H) p)) =
      promedio (fun H : W → Digest => f (resultado (prolongar W defecto H) p)) := by
  rw [ley_global V p hV defecto f, ley_global W p hW defecto f]

end Nexus.ROM.SoporteFinito
