module

public import Nexus.ROM.CargaPrimeras
import Mathlib.Tactic

/-!
# Excepciones elegidas con el pasado de la primera consulta

La dirección y el conjunto excepcional dependen de todo el prefijo, pero
no de la respuesta que se va a revelar. Se obtiene su ley exacta en cada
fibra y una unión pagada por direcciones nuevas, incluidas las preconsultas.
No se condiciona a SinBad ni a la aceptación futura.
-/

public section
namespace Nexus.ROM.ExcepcionesPrefijo

open Nexus.N06 LeyArbol PrefijosGlobales ObservacionesPrefijo
open FrescuraFinita PromediosCompletaciones ContinuacionPrefijo
open PrimeraExposicion CargaPrimeras ConteoActivaciones ActivacionPrefijo

variable {Q A X : Type} [DecidableEq Q] [Fintype Q] [Fintype A]
attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem ley_respuesta (H : Q → A) (p : Arbol Q A X) (n : ℕ)
    (direccion : List (Q × A) → Q) (f : List (Q × A) → A → ℚ)
    (hq : direccion (prefijo p n H) ∉ vistas H p n) :
    promedio (fun G : Tablas H p n =>
      f (prefijo p n G.val) (G.val (direccion (prefijo p n G.val)))) =
      promedio (f (prefijo p n H)) := by
  rw [ley_tabla_y_pasado H p n (fun t G => f t (G (direccion t)))]
  rw [media_revelar (vistas H p n) H (direccion (prefijo p n H)) hq
    (fun G : Q → A => f (prefijo p n H) (G (direccion (prefijo p n H))))]
  congr 1
  funext a
  let _ : Nonempty
      (Completaciones (insert (direccion (prefijo p n H)) (vistas H p n))
        (Function.update H (direccion (prefijo p n H)) a)) :=
    ⟨⟨Function.update H (direccion (prefijo p n H)) a, by intro q _; rfl⟩⟩
  have he : (fun G : Completaciones
      (insert (direccion (prefijo p n H)) (vistas H p n))
      (Function.update H (direccion (prefijo p n H)) a) =>
        f (prefijo p n H) (G.val (direccion (prefijo p n H)))) =
      (fun _ => f (prefijo p n H) a) := by
    funext G
    have ha := G.property (direccion (prefijo p n H)) (Finset.mem_insert_self _ _)
    rw [Function.update_self] at ha
    rw [ha]
  rw [he]
  exact promedio_constante _

theorem ley_conjunto (H : Q → A) (p : Arbol Q A X) (n : ℕ)
    (direccion : List (Q × A) → Q) (E : List (Q × A) → Finset A)
    (hq : direccion (prefijo p n H) ∉ vistas H p n) :
    promedio (fun G : Tablas H p n =>
      if G.val (direccion (prefijo p n G.val)) ∈ E (prefijo p n G.val)
        then (1 : ℚ) else 0) =
      ((E (prefijo p n H)).card : ℚ) / Fintype.card A := by
  rw [ley_respuesta H p n direccion (fun t a => if a ∈ E t then 1 else 0) hq]
  exact promedio_indicador _

theorem cota_inicio (p : Arbol Q A X) (n : ℕ)
    (direccion : List (Q × A) → Q) (E : List (Q × A) → A → Prop) (rho : ℚ)
    (h : ∀ H, Activa p direccion (prefijo p n H) →
      promedio (fun a : A => if E (prefijo p n H) a then (1 : ℚ) else 0) ≤ rho) :
    promedio (fun H : Q → A =>
      if Activa p direccion (prefijo p n H) ∧
        E (prefijo p n H) (H (direccion (prefijo p n H))) then (1 : ℚ) else 0) ≤
      rho * promedio (fun H : Q → A =>
        if Activa p direccion (prefijo p n H) then (1 : ℚ) else 0) := by
  apply cota_activada_constante
  intro H ha
  rw [ley_respuesta H p n direccion (fun t a => if E t a then 1 else 0) ha.2]
  exact h H ha

theorem cota_presupuesto [Nonempty A] (p : Arbol Q A X) (N B : ℕ)
    (direccion : ℕ → List (Q × A) → Q)
    (E : ℕ → List (Q × A) → A → Prop) (rho : ℚ) (hr : 0 ≤ rho)
    (h : ∀ (n : Fin N) H, Inicia p direccion n.val H →
      promedio (fun a : A => if E n.val (prefijo p n.val H) a then (1 : ℚ) else 0) ≤ rho)
    (hB : ∀ H : Q → A, ((traza H p).map Prod.fst).toFinset.card ≤ B) :
    promedio (fun H : Q → A => if ∃ n : Fin N,
      Inicia p direccion n.val H ∧
        E n.val (prefijo p n.val H) (H (direccion n.val (prefijo p n.val H)))
      then (1 : ℚ) else 0) ≤ rho * B := by
  apply cota_por_presupuesto
    (fun (n : Fin N) H => Inicia p direccion n.val H)
    (fun (n : Fin N) H =>
      E n.val (prefijo p n.val H) (H (direccion n.val (prefijo p n.val H)))) rho B hr
  · intro H
    exact (carga_distintas H p N direccion).trans (hB H)
  · intro n
    exact cota_inicio p n.val (direccion n.val) (E n.val) rho (h n)

theorem cota_cardinal [Nonempty A] (p : Arbol Q A X) (N B C : ℕ)
    (direccion : ℕ → List (Q × A) → Q) (E : ℕ → List (Q × A) → Finset A)
    (hE : ∀ (n : Fin N) H, Inicia p direccion n.val H →
      (E n.val (prefijo p n.val H)).card ≤ C)
    (hB : ∀ H : Q → A, ((traza H p).map Prod.fst).toFinset.card ≤ B) :
    promedio (fun H : Q → A => if ∃ n : Fin N,
      Inicia p direccion n.val H ∧
        H (direccion n.val (prefijo p n.val H)) ∈ E n.val (prefijo p n.val H)
      then (1 : ℚ) else 0) ≤ ((C : ℚ) / Fintype.card A) * B := by
  have hlocal : ∀ (n : Fin N) H, Inicia p direccion n.val H →
      promedio (fun a : A => if a ∈ E n.val (prefijo p n.val H) then (1 : ℚ) else 0) ≤
        (C : ℚ) / Fintype.card A := by
    intro n H ha
    rw [promedio_indicador]
    exact div_le_div_of_nonneg_right (by exact_mod_cast hE n H ha) (by positivity)
  have h := cota_presupuesto p N B direccion (fun n t a => a ∈ E n t)
    ((C : ℚ) / Fintype.card A) (by positivity) (by
      intro n H ha
      refine le_trans ?_ (hlocal n H ha)
      apply promedio_monotono
      intro a
      split_ifs <;> norm_num) hB
  refine le_trans ?_ h
  apply promedio_monotono
  intro H
  split_ifs <;> norm_num

end Nexus.ROM.ExcepcionesPrefijo
