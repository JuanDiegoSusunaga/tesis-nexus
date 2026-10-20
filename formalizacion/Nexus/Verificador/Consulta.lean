module

public import Nexus.Verificador.Forma
public import Nexus.FRI.ProgramaVerificacion
public import Nexus.FRI.IndicesMaquina
public import Nexus.Canal.EnlaceComposicion
import Mathlib.Tactic

/-!
# Las seis aperturas y las dos fases de una consulta

Se ejecutan las seis aperturas AIR, el enlace de traza, FRI de traza, el
enlace de composición y FRI de composición. Las longitudes incorrectas no
se ocultan por zip: se comprueban por separado. La composición usa el campo
matemático y la misma presentación Goldilocks del resto de la formalización.
-/

public section
namespace Nexus.Verificador.ProgramaConsulta

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.Goldilocks.Recorrido
open Nexus.ROM.ProgramaCompartido Nexus.ROM.RegistroPrograma
open Nexus.Canal.ProgramaTG2 (Acotado)

@[expose] noncomputable def air (raiz : Digest) (altura : ℕ) : List (Punto × ℕ) → Programa
  | [] => .terminar true
  | p :: ps => encadenar (Nexus.Merkle.ProgramaVerificacion.verificar raiz altura p.2
      (algebraMap Fp Fp2 p.1.valor) p.1.hermanos) (air raiz altura ps)

@[expose] noncomputable def enlaceTraza (q : Consulta) : Bool := by
  classical
  exact match q.traza, q.friTraza with
  | [a, _, _, b, _, _], f :: _ => decide (f.izquierda = algebraMap Fp Fp2 a.valor ∧
      f.derecha = algebraMap Fp Fp2 b.valor)
  | _, _ => false

@[expose] noncomputable def enlaceComposicion (k i : ℕ) (e : Enunciado)
    (alfas : List Fp2) (q : Consulta) : Bool := by
  classical
  exact match alfas, q.traza, q.friComposicion with
  | [a0, a1, a2], [f0, f1, f2, f3, f4, f5], d :: _ =>
    let x : Fp := 7 * raiz (k + 3) ^ i
    decide (d.izquierda = Nexus.Canal.componerBase (2 ^ k) (raiz k) e.inicio e.salida x
      (a0, a1, a2) ![f0.valor, f1.valor, f2.valor] ∧
      d.derecha = Nexus.Canal.componerBase (2 ^ k) (raiz k) e.inicio e.salida (-x)
        (a0, a1, a2) ![f3.valor, f4.valor, f5.valor])
  | _, _, _ => false

@[expose] noncomputable def verificar (k i : ℕ) (e : Enunciado) (p : Prueba)
    (a bt bc : List Fp2) (q : Consulta) : Programa :=
  if q.traza.length = 6 then
    encadenar (air p.raiz (k + 3) (q.traza.zip (List.ofFn (IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i)) ))
      (encadenar (.terminar (enlaceTraza q))
        (encadenar (ProgramaFRI.verificar k k i p.traza.raices bt q.friTraza p.traza.final)
          (encadenar (.terminar (enlaceComposicion k i e a q))
            (ProgramaFRI.verificar k (k + 1) i p.composicion.raices bc q.friComposicion p.composicion.final))))
  else .terminar false

@[expose] def presupuesto (k : ℕ) : ℕ := 6 * (k + 4) +
  2 * (Nexus.Complejidad.Comunicacion.caminos (k + 3) k + k) +
  2 * (Nexus.Complejidad.Comunicacion.caminos (k + 3) (k + 1) + (k + 1))

theorem air_aceptado (H : List Octeto → Digest) (r : Digest) (h : ℕ) (ps : List (Punto × ℕ)) :
    resultado (tabla H) (air r h ps) = true ↔ ∀ x ∈ ps,
      VerificaIndice formatoBytes H r h x.2 (algebraMap Fp Fp2 x.1.valor) x.1.hermanos := by
  induction ps with
  | nil => simp [air, resultado]
  | cons p ps ih =>
    simp only [air, resultado_encadenado, Bool.and_eq_true,
      Nexus.Merkle.ProgramaVerificacion.aceptacion_equivale, ih, List.forall_mem_cons]

theorem presupuesto_air (r : Digest) (h : ℕ) (ps : List (Punto × ℕ)) :
    Acotado (air r h ps) (ps.length * (h + 1)) := by
  induction ps with
  | nil => intro H; exact Nat.zero_le _
  | cons p ps ih =>
    have hb := presupuesto_encadenado _ _ _ _
      (Nexus.Merkle.ProgramaVerificacion.presupuesto_verificacion r h p.2
        (algebraMap Fp Fp2 p.1.valor) p.1.hermanos) ih
    simpa only [air, List.length_cons, Nat.add_mul, Nat.one_mul, Nat.add_comm] using hb

theorem aceptacion_controles (H : List Octeto → Digest) (k i : ℕ) (e : Enunciado) (p : Prueba)
    (a bt bc : List Fp2) (q : Consulta) :
    resultado (tabla H) (verificar k i e p a bt bc q) = true ↔
      q.traza.length = 6 ∧
      resultado (tabla H) (air p.raiz (k + 3)
        (q.traza.zip (List.ofFn (IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i)))) = true ∧
      enlaceTraza q = true ∧
      resultado (tabla H) (ProgramaFRI.verificar k k i p.traza.raices bt q.friTraza p.traza.final) = true ∧
      enlaceComposicion k i e a q = true ∧
      resultado (tabla H) (ProgramaFRI.verificar k (k + 1) i p.composicion.raices bc
        q.friComposicion p.composicion.final) = true := by
  by_cases hl : q.traza.length = 6
  · simp only [verificar, hl, ite_true, resultado_encadenado, Bool.and_eq_true, resultado, true_and]
  · simp only [verificar, hl, ite_false, resultado, Bool.false_eq_true, false_and]

theorem presupuesto_consulta (k i : ℕ) (e : Enunciado) (p : Prueba)
    (a bt bc : List Fp2) (q : Consulta) : Acotado (verificar k i e p a bt bc q) (presupuesto k) := by
  by_cases hl : q.traza.length = 6
  · rw [verificar, ite_eq_left hl]
    have ht : Acotado (.terminar (enlaceTraza q)) 0 := by intro H; rfl
    have hc : Acotado (.terminar (enlaceComposicion k i e a q)) 0 := by intro H; rfl
    have h := presupuesto_encadenado _ _ _ _ (presupuesto_air p.raiz (k + 3)
      (q.traza.zip (List.ofFn (IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i))))
      (presupuesto_encadenado _ _ _ _ ht (presupuesto_encadenado _ _ _ _
        (ProgramaFRI.presupuesto_verificacion k k i p.traza.raices bt q.friTraza p.traza.final)
        (presupuesto_encadenado _ _ _ _ hc
          (ProgramaFRI.presupuesto_verificacion k (k + 1) i p.composicion.raices bc q.friComposicion p.composicion.final))))
    simpa only [List.length_zip, List.length_ofFn, hl, Nat.min_self, Nat.add_zero, Nat.zero_add,
      show k + 3 + 1 = k + 4 by omega, ← Nat.add_assoc, presupuesto] using h
  · rw [verificar, ite_eq_right hl]; intro H; exact Nat.zero_le _

theorem faltan_puntos_rechaza (k i : ℕ) (e : Enunciado) (p : Prueba)
    (a bt bc : List Fp2) (q : Consulta) (h : q.traza.length ≠ 6) :
    verificar k i e p a bt bc q = .terminar false := ite_eq_right h

end Nexus.Verificador.ProgramaConsulta
