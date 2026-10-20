module

public import Nexus.ROM.LeyMuestreoPrograma
import Mathlib.Tactic

/-!
# Instrumentación sin consultas adicionales

El programa devuelve su resultado y la lista completa de consultas/respuestas.
La instrumentación conserva transcripción, soporte y altura. Su muestreo
identifica así la ley conjunta del protocolo, no solo su bit de aceptación.
-/

public section
namespace Nexus.ROM.ProgramaObservado

open Nexus.Bytes Nexus.Merkle Nexus.N06 ProgramaBytes SoporteFinito

set_option maxRecDepth 4096

@[expose] def transformar {R T : Type} (g : R → T) : Programa R → Programa T
  | .terminar r => .terminar (g r)
  | .consultar e k => .consultar e (fun d => transformar g (k d))

theorem resultado_transformar {R T : Type} (H : Entrada → Digest) (g : R → T) (p : Programa R) :
    resultado H (transformar g p) = g (resultado H p) := by
  induction p with
  | terminar => rfl
  | consultar e k ih => exact ih _

theorem traza_transformar {R T : Type} (H : Entrada → Digest) (g : R → T) (p : Programa R) :
    traza H (transformar g p) = traza H p := by
  induction p with
  | terminar => rfl
  | consultar e k ih => exact congrArg (List.cons _) (ih _)

theorem altura_transformar {R T : Type} (g : R → T) (p : Programa R) :
    altura (transformar g p) = altura p := by
  induction p with
  | terminar => rfl
  | consultar e k ih => simp only [transformar, altura, ih]

theorem soporte_transformar {R T : Type} (g : R → T) (p : Programa R) :
    soporte (transformar g p) = soporte p := by
  induction p with
  | terminar => rfl
  | consultar e k ih => simp only [transformar, soporte, ih]

@[expose] def registrar {R : Type} : Programa R → Programa (R × List (Entrada × Digest))
  | .terminar r => .terminar (r, [])
  | .consultar e k => .consultar e (fun d =>
      transformar (fun rt => (rt.1, (e, d) :: rt.2)) (registrar (k d)))

theorem resultado_registrar {R : Type} (H : Entrada → Digest) (p : Programa R) :
    resultado H (registrar p) = (resultado H p, traza H p) := by
  induction p with
  | terminar => rfl
  | consultar e k ih => simp only [registrar, resultado, resultado_transformar, ih, traza]

theorem traza_registrar {R : Type} (H : Entrada → Digest) (p : Programa R) :
    traza H (registrar p) = traza H p := by
  induction p with
  | terminar => rfl
  | consultar e k ih => simp only [registrar, traza, traza_transformar, ih]

theorem altura_registrar {R : Type} (p : Programa R) : altura (registrar p) = altura p := by
  induction p with
  | terminar => rfl
  | consultar e k ih => simp only [registrar, altura, altura_transformar, ih]

theorem soporte_registrar {R : Type} (p : Programa R) : soporte (registrar p) = soporte p := by
  induction p with
  | terminar => rfl
  | consultar e k ih => simp only [registrar, soporte, soporte_transformar, ih]

theorem plan_transformar {R T : Type} (B : ℕ) (g : R → T) (p : Programa R)
    (s : Estado B) (n : ℕ) (h : altura p ≤ n) :
    PlanPrograma.planificar B (transformar g p) s n (by rw [altura_transformar]; exact h) =
      PlanPrograma.planificar B p s n h := by
  induction p generalizing s n with
  | terminar => rfl
  | consultar e k ih =>
    cases n with
    | zero => have hm := PlanPrograma.rama_menor e k (Classical.choice (inferInstance : Nonempty Digest)); omega
    | succ n =>
      cases hh : buscar s.tabla e with
      | none =>
        simp only [transformar, PlanPrograma.planificar, EjecucionBytes.solicitar, hh, dite_true]
        congr 1
        funext d
        exact ih d _ n (by have hm := PlanPrograma.rama_menor e k d; omega)
      | some d =>
        simp only [transformar, PlanPrograma.planificar, EjecucionBytes.solicitar, hh,
          reduceCtorEq, dite_false, Option.getD_some]
        congr 1
        exact ih d _ (n + 1) (by have hm := PlanPrograma.rama_menor e k d; omega)

theorem plan_registrar {R : Type} (B : ℕ) (p : Programa R) (s : Estado B)
    (n : ℕ) (h : altura p ≤ n) :
    PlanPrograma.planificar B (registrar p) s n (by rw [altura_registrar]; exact h) =
      PlanPrograma.planificar B p s n h := by
  induction p generalizing s n with
  | terminar => rfl
  | consultar e k ih =>
    cases n with
    | zero => have hm := PlanPrograma.rama_menor e k (Classical.choice (inferInstance : Nonempty Digest)); omega
    | succ n =>
      cases hh : buscar s.tabla e with
      | none =>
        simp only [registrar, PlanPrograma.planificar, EjecucionBytes.solicitar, hh, dite_true]
        congr 1
        funext d
        rw [plan_transformar]
        exact ih d _ n (by have hm := PlanPrograma.rama_menor e k d; omega)
      | some d =>
        simp only [registrar, PlanPrograma.planificar, EjecucionBytes.solicitar, hh,
          reduceCtorEq, dite_false, Option.getD_some]
        congr 1
        rw [plan_transformar]
        exact ih d _ (n + 1) (by have hm := PlanPrograma.rama_menor e k d; omega)

theorem ley_transcripcion {R : Type} (B S : ℕ) (p : Programa R) (h : altura p ≤ S)
    (V : Finset Entrada) (hV : soporte p ⊆ V) (defecto : Digest)
    (f : R × List (Entrada × Digest) → ℚ) :
    promedio (fun xs : Retos Digest S =>
      let H := funcionTabla defecto (ejecutar
        (PlanPrograma.experimento B S p h) xs).tabla
      f (resultado H p, traza H p)) =
      promedio (fun H : V → Digest =>
        f (resultado (prolongar V defecto H) p, traza (prolongar V defecto H) p)) := by
  have hh := LeyMuestreoPrograma.ley_programa B S (registrar p)
    (by rw [altura_registrar]; exact h) V (by rw [soporte_registrar]; exact hV) defecto f
  have he := plan_registrar B p (inicial B) S h
  simpa only [resultado_registrar, PlanPrograma.experimento, he] using hh

end Nexus.ROM.ProgramaObservado
