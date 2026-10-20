module

public import Nexus.ROM.SoporteFinito
public import Nexus.ROM.PlanPrograma
import Mathlib.Tactic

/-!
# Identificación del programa muestreado con el ROM finito

La tabla crece aun cuando ocurre una excepción. Se prueba la igualdad de
leyes para cualquier observable del resultado del programa. El presupuesto
de altura sigue explícito; no se lo identifica con el coste de Rust.
-/

public section
namespace Nexus.ROM.LeyMuestreoPrograma

open Nexus.Bytes Nexus.Merkle Nexus.N06 ProgramaBytes SoporteFinito

set_option maxRecDepth 4096
set_option pp.deepTerms false
set_option pp.deepTerms.threshold 8

theorem tabla_prefijo {B : ℕ} {s : Estado B} {n : ℕ} (p : Plan B s n)
    (xs : Retos Digest n) : ∃ resto, (ejecutar p xs).tabla = s.tabla ++ resto := by
  induction p with
  | terminar s n => exact ⟨[], (List.append_nil _).symm⟩
  | repetir q d hd resto ih => exact ih xs
  | nuevo q hn resto ih =>
    obtain ⟨t, ht⟩ := ih xs.1 xs.2
    exact ⟨[(q.entrada, xs.1)] ++ t, ht.trans (List.append_assoc ..)⟩

theorem respuesta_guardada {B : ℕ} {s : Estado B} {n : ℕ} (p : Plan B s n)
    (xs : Retos Digest n) (defecto : Digest) (e : Entrada) (d : Digest)
    (hd : buscar s.tabla e = some d) : funcionTabla defecto (ejecutar p xs).tabla e = d := by
  obtain ⟨t, ht⟩ := tabla_prefijo p xs
  simp only [funcionTabla, ht, buscar_conservado s.tabla t e d hd, Option.getD_some]

theorem funcion_anexar (t : Tabla Entrada Digest) (e : Entrada) (d defecto : Digest)
    (he : buscar t e = none) :
    funcionTabla defecto (t ++ [(e, d)]) = Function.update (funcionTabla defecto t) e d := by
  funext x
  by_cases hx : x = e
  · subst x
    simp only [funcionTabla, buscar_anexado t e d he, Option.getD_some, Function.update_self]
  · rw [Function.update_of_ne hx]
    simp only [funcionTabla, buscar_append, buscar, Ne.symm hx, ite_false]
    cases buscar t x <;> rfl

theorem claves_anexar (t : Tabla Entrada Digest) (e : Entrada) (d : Digest) :
    ((t ++ [(e, d)]).map Prod.fst).toFinset = insert e (t.map Prod.fst).toFinset := by
  simp only [List.map_append, List.map_cons, List.map_nil, List.toFinset_append,
    List.toFinset_cons, List.toFinset_nil, Finset.union_insert, Finset.union_empty]

theorem consulta_en_claves (t : Tabla Entrada Digest) (e : Entrada) :
    e ∉ (t.map Prod.fst).toFinset ↔ buscar t e = none := by
  simp only [List.mem_toFinset]
  exact (buscar_none_iff t e).symm

theorem media_plan {R : Type} (B : ℕ) (p : Programa R) (s : Estado B) (n : ℕ)
    (h : altura p ≤ n) (defecto : Digest) (f : R → ℚ) :
    promedio (fun xs : Retos Digest n =>
      f (resultado (funcionTabla defecto (ejecutar (PlanPrograma.planificar B p s n h) xs).tabla) p)) =
      LeyArbol.valor f (arbol p) (s.tabla.map Prod.fst).toFinset (funcionTabla defecto s.tabla) := by
  induction p generalizing s n with
  | terminar r => exact promedio_constante (f r)
  | consultar e k ih =>
    cases n with
    | zero => have hm := PlanPrograma.rama_menor e k defecto; omega
    | succ n =>
      cases hh : buscar s.tabla e with
      | none =>
        have hn := (consulta_en_claves s.tabla e).mpr hh
        rw [PlanPrograma.planificar]
        simp only [EjecucionBytes.solicitar, hh, dite_true, ejecutar]
        change promedio (fun xs : Digest × Retos Digest n => _) = _
        rw [promedio_producto]
        have he (d : Digest) (ys : Retos Digest n) :
            funcionTabla defecto (ejecutar
              (PlanPrograma.planificar B (k d) (estadoNuevo s (EjecucionBytes.solicitar s e) d hh) n
                (by have hm := PlanPrograma.rama_menor e k d; omega)) ys).tabla e = d := by
          apply respuesta_guardada
          exact buscar_anexado s.tabla e d hh
        simp only [EjecucionBytes.solicitar] at he
        simp only [resultado, he]
        change promedio (fun d => _) = if e ∈ (s.tabla.map Prod.fst).toFinset then _ else _
        rw [ite_eq_right hn]
        congr 1
        funext d
        have hi := ih d (estadoNuevo s (EjecucionBytes.solicitar s e) d hh) n
          (by have hm := PlanPrograma.rama_menor e k d; omega)
        simpa only [estadoNuevo, EjecucionBytes.solicitar, claves_anexar,
          funcion_anexar s.tabla e d defecto hh] using hi
      | some d =>
        have hn : ¬ buscar s.tabla e = none := by rw [hh]; simp
        have hm : e ∈ (s.tabla.map Prod.fst).toFinset := by
          by_contra hne
          exact hn ((consulta_en_claves s.tabla e).mp hne)
        rw [PlanPrograma.planificar]
        simp only [EjecucionBytes.solicitar, hh, reduceCtorEq, dite_false, Option.getD_some, ejecutar]
        have he (ys : Retos Digest (n + 1)) :
            funcionTabla defecto (ejecutar
              (PlanPrograma.planificar B (k d) (estadoRepetido s (EjecucionBytes.solicitar s e)) (n + 1)
                (by have hj := PlanPrograma.rama_menor e k d; omega)) ys).tabla e = d := by
          apply respuesta_guardada
          exact hh
        simp only [EjecucionBytes.solicitar] at he
        simp only [resultado, he]
        change _ = if e ∈ (s.tabla.map Prod.fst).toFinset then _ else _
        rw [ite_eq_left hm]
        have hd : funcionTabla defecto s.tabla e = d := by simp only [funcionTabla, hh, Option.getD_some]
        rw [hd]
        simpa only [estadoRepetido, EjecucionBytes.solicitar] using
          ih d (estadoRepetido s (EjecucionBytes.solicitar s e)) (n + 1)
            (by have hj := PlanPrograma.rama_menor e k d; omega)

theorem ley_programa {R : Type} (B S : ℕ) (p : Programa R) (h : altura p ≤ S)
    (V : Finset Entrada) (hV : soporte p ⊆ V) (defecto : Digest) (f : R → ℚ) :
    promedio (fun xs : Retos Digest S =>
      f (resultado (funcionTabla defecto (ejecutar (PlanPrograma.experimento B S p h) xs).tabla) p)) =
      promedio (fun H : V → Digest => f (resultado (prolongar V defecto H) p)) := by
  rw [ley_global V p hV defecto f]
  have he : funcionTabla defecto ([] : Tabla Entrada Digest) = (fun _ => defecto) := by
    funext e
    rfl
  simpa only [PlanPrograma.experimento, inicial, List.map_nil, List.toFinset_nil, he] using
    media_plan B p (inicial B) S h defecto f

end Nexus.ROM.LeyMuestreoPrograma
