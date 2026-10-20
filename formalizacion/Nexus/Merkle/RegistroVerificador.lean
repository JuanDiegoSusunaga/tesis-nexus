module

public import Nexus.Merkle.PruebasIndexadas
import Mathlib.Tactic

/-!
# Consultas producidas al verificar una apertura

El evaluador devuelve el digest y las entradas hasheadas en orden de
ejecución, desde la hoja. Se demuestra el registro de todas las entradas
de una apertura aceptada y su costo exacto. La tabla ROM global se debe
construir a partir de esos eventos, conservando respuestas repetidas.
-/

public section
namespace Nexus.Merkle.RegistroVerificador

variable {V D E : Type*}

@[expose] def evaluar (f : Formato V D E) (H : E → D) (v : V) : List (Bool × D) → D × List E
  | [] => (H (f.hoja v), [f.hoja v])
  | (b, hermano) :: resto =>
      let anterior := evaluar f H v resto
      let e := if b then f.nodo hermano anterior.1 else f.nodo anterior.1 hermano
      (H e, anterior.2 ++ [e])

theorem digest_evaluado (f : Formato V D E) (H : E → D) (v : V) (hermanos : List (Bool × D)) :
    (evaluar f H v hermanos).1 = reconstruir f H v hermanos := by
  induction hermanos with
  | nil => rfl
  | cons par resto ih => cases par; simp only [evaluar, reconstruir, ih]

theorem registro_evaluado (f : Formato V D E) (H : E → D) (v : V) (hermanos : List (Bool × D)) :
    (evaluar f H v hermanos).2 = (consultasApertura f H v hermanos).reverse := by
  induction hermanos with
  | nil => rfl
  | cons par resto ih =>
    cases par
    simp only [evaluar, consultasApertura, List.reverse_cons, ih, digest_evaluado]

theorem apertura_registrada_por_evaluacion (f : Formato V D E) (H : E → D) (v : V)
    (hermanos : List (Bool × D)) : AperturaRegistrada f H (evaluar f H v hermanos).2 v hermanos := by
  intro e he
  rw [registro_evaluado, List.mem_reverse]
  exact he

theorem costo_consultas (f : Formato V D E) (H : E → D) (v : V) (hermanos : List (Bool × D)) :
    (evaluar f H v hermanos).2.length = hermanos.length + 1 := by
  induction hermanos with
  | nil => rfl
  | cons par resto ih => simp only [evaluar, List.length_append, List.length_cons, List.length_nil, ih]

@[expose] def evaluarIndice (f : Formato V D E) (H : E → D) (i : ℕ) (v : V) (hermanos : List D) : D × List E :=
  evaluar f H v (hermanosDesdeRaiz i hermanos)

theorem indice_coincide_bucle (f : Formato V D E) (H : E → D) (i : ℕ) (v : V) (hermanos : List D) :
    (evaluarIndice f H i v hermanos).1 = verificarDesde f H i (H (f.hoja v)) hermanos := by
  rw [evaluarIndice, digest_evaluado, reconstruir_prueba_indexada]

theorem indice_consultas_contadas (f : Formato V D E) (H : E → D) (i : ℕ) (v : V) (hermanos : List D) :
    (evaluarIndice f H i v hermanos).2.length = hermanos.length + 1 := by
  rw [evaluarIndice, costo_consultas, hermanos_desde_raiz_longitud]

variable [DecidableEq D]

@[expose] def verificar (f : Formato V D E) (H : E → D) (raiz : D) (altura i : ℕ)
    (v : V) (hermanos : List D) : Bool × List E :=
  if hermanos.length = altura then
    let r := evaluarIndice f H i v hermanos
    (decide (r.1 = raiz), r.2)
  else (false, [])

theorem rechazo_forma_sin_consultas (f : Formato V D E) (H : E → D) (raiz : D) (altura i : ℕ)
    (v : V) (hermanos : List D) (h : hermanos.length ≠ altura) :
    verificar f H raiz altura i v hermanos = (false, []) := by simp only [verificar, h, ite_false]

theorem aceptacion_equivalente (f : Formato V D E) (H : E → D) (raiz : D) (altura i : ℕ)
    (v : V) (hermanos : List D) :
    (verificar f H raiz altura i v hermanos).1 = true ↔ VerificaIndice f H raiz altura i v hermanos := by
  unfold verificar
  split_ifs with h
  · simp only [decide_eq_true_eq, indice_coincide_bucle, VerificaIndice, h, true_and]
  · simp only [VerificaIndice, h, false_and]

theorem aceptacion_registra_y_cuenta (f : Formato V D E) (H : E → D) (raiz : D) (altura i : ℕ)
    (v : V) (hermanos : List D) (h : (verificar f H raiz altura i v hermanos).1 = true) :
    AperturaRegistrada f H (verificar f H raiz altura i v hermanos).2 v (hermanosDesdeRaiz i hermanos) ∧
      (verificar f H raiz altura i v hermanos).2.length = altura + 1 := by
  have ha := (aceptacion_equivalente f H raiz altura i v hermanos).mp h
  rw [verificar, ite_eq_left ha.1]
  exact ⟨apertura_registrada_por_evaluacion f H v _, (indice_consultas_contadas f H i v hermanos).trans (by rw [ha.1])⟩

end Nexus.Merkle.RegistroVerificador
