module

public import Nexus.ROM.RegistroPrograma
public import Nexus.Merkle.RegistroVerificador
import Mathlib.Tactic

/-!
# Aperturas Merkle como peticiones reales al programa común

El programa emite la hoja y cada nodo; verifica la longitud antes del primer
hash y conserva las llamadas cuando la raíz final rechaza. El registro y
la autenticación se deducen de ejecutar, sin suponerlos como premisas.
-/

public section
namespace Nexus.Merkle.ProgramaVerificacion

open Nexus.Bytes Nexus.Goldilocks Nexus.Canal.GramaticaTG2
open Nexus.ROM.ProgramaCompartido Nexus.ROM.RegistroPrograma

@[expose] def peticionNodo (b : Bool) (hermano hijo : Digest) : Peticion :=
  if b then .nodo hermano hijo else .nodo hijo hermano

theorem bytes_nodo (b : Bool) (hijo hermano : Digest) :
    codificar (peticionNodo b hermano hijo) =
      if b then codificarNodo hermano hijo else codificarNodo hijo hermano := by
  cases b <;> rfl

@[expose] def evaluar (v : Fp2) : List (Bool × Digest) → (Digest → Programa) → Programa
  | [], continuar => .consultar (.hoja v) continuar
  | (b, hermano) :: resto, continuar => evaluar v resto (fun hijo =>
      .consultar (peticionNodo b hermano hijo) continuar)

theorem resultado_evaluacion (H : List Octeto → Digest) (v : Fp2)
    (hermanos : List (Bool × Digest)) (continuar : Digest → Programa) :
    resultado (tabla H) (evaluar v hermanos continuar) =
      resultado (tabla H) (continuar (reconstruir formatoBytes H v hermanos)) := by
  induction hermanos generalizing continuar with
  | nil => simp only [evaluar, resultado, tabla_codificacion, codificar, reconstruir, formatoBytes]
  | cons par resto ih =>
    rcases par with ⟨b, hermano⟩
    rw [evaluar, ih]
    simp only [resultado, tabla_codificacion, bytes_nodo, reconstruir, formatoBytes]

theorem entradas_evaluacion (H : List Octeto → Digest) (v : Fp2)
    (hermanos : List (Bool × Digest)) (continuar : Digest → Programa) :
    entradas H (evaluar v hermanos continuar) =
      (RegistroVerificador.evaluar formatoBytes H v hermanos).2 ++
        entradas H (continuar (reconstruir formatoBytes H v hermanos)) := by
  induction hermanos generalizing continuar with
  | nil => simp only [evaluar, entradas, codificar, RegistroVerificador.evaluar, formatoBytes,
      reconstruir, List.singleton_append]
  | cons par resto ih =>
    rcases par with ⟨b, hermano⟩
    rw [evaluar, ih]
    simp only [entradas, bytes_nodo, RegistroVerificador.evaluar,
      RegistroVerificador.digest_evaluado, reconstruir, formatoBytes,
      List.append_assoc, List.singleton_append]

@[expose] def verificar (raiz : Digest) (altura i : ℕ) (v : Fp2) (hermanos : List Digest) : Programa :=
  if hermanos.length = altura then
    evaluar v (hermanosDesdeRaiz i hermanos) (fun d => .terminar (decide (d = raiz)))
  else .terminar false

theorem resultado_verificacion (H : List Octeto → Digest) (raiz : Digest) (altura i : ℕ)
    (v : Fp2) (hermanos : List Digest) :
    resultado (tabla H) (verificar raiz altura i v hermanos) =
      (RegistroVerificador.verificar formatoBytes H raiz altura i v hermanos).1 := by
  simp only [verificar, RegistroVerificador.verificar]
  split_ifs with hs
  · rw [resultado_evaluacion]
    simp only [resultado, RegistroVerificador.evaluarIndice, RegistroVerificador.digest_evaluado]
  · rfl

theorem registro_verificacion (H : List Octeto → Digest) (raiz : Digest) (altura i : ℕ)
    (v : Fp2) (hermanos : List Digest) :
    entradas H (verificar raiz altura i v hermanos) =
      (RegistroVerificador.verificar formatoBytes H raiz altura i v hermanos).2 := by
  simp only [verificar, RegistroVerificador.verificar]
  split_ifs with hs
  · rw [entradas_evaluacion]
    simp only [entradas, List.append_nil, RegistroVerificador.evaluarIndice]
  · rfl

theorem aceptacion_equivale (H : List Octeto → Digest) (raiz : Digest) (altura i : ℕ)
    (v : Fp2) (hermanos : List Digest) :
    resultado (tabla H) (verificar raiz altura i v hermanos) = true ↔
      VerificaIndice formatoBytes H raiz altura i v hermanos := by
  rw [resultado_verificacion]
  exact RegistroVerificador.aceptacion_equivalente _ _ _ _ _ _ _

theorem aceptacion_produce_registro (H : List Octeto → Digest) (raiz : Digest) (altura i : ℕ)
    (v : Fp2) (hermanos : List Digest)
    (ha : resultado (tabla H) (verificar raiz altura i v hermanos) = true) :
    AperturaRegistrada formatoBytes H (entradas H (verificar raiz altura i v hermanos))
      v (hermanosDesdeRaiz i hermanos) := by
  rw [registro_verificacion]
  apply (RegistroVerificador.aceptacion_registra_y_cuenta _ _ _ _ _ _ _ _).1
  rwa [← resultado_verificacion]

theorem costo_forma_valida (H : List Octeto → Digest) (raiz : Digest) (altura i : ℕ)
    (v : Fp2) (hermanos : List Digest) (hs : hermanos.length = altura) :
    (entradas H (verificar raiz altura i v hermanos)).length = altura + 1 := by
  rw [registro_verificacion, RegistroVerificador.verificar, ite_eq_left hs]
  rw [RegistroVerificador.indice_consultas_contadas, hs]

theorem rechazo_forma_no_consulta (raiz : Digest) (altura i : ℕ) (v : Fp2) (hermanos : List Digest)
    (hs : hermanos.length ≠ altura) : verificar raiz altura i v hermanos = .terminar false := by
  simp only [verificar, hs, ite_false]

theorem presupuesto_evaluacion (H : Clave → Digest) (v : Fp2) (hermanos : List (Bool × Digest))
    (continuar : Digest → Programa) (C : ℕ)
    (hc : ∀ d, (respuestas H (continuar d)).length ≤ C) :
    (respuestas H (evaluar v hermanos continuar)).length ≤ hermanos.length + 1 + C := by
  induction hermanos generalizing continuar C with
  | nil =>
    simp only [evaluar, respuestas, List.length_cons, List.length_nil]
    have h := hc (H (clave (.hoja v)))
    omega
  | cons par resto ih =>
    rcases par with ⟨b, hermano⟩
    have hcont (hijo : Digest) :
        (respuestas H (.consultar (peticionNodo b hermano hijo) continuar)).length ≤ C + 1 := by
      simp only [respuestas, List.length_cons]
      have h := hc (H (clave (peticionNodo b hermano hijo)))
      omega
    have h := ih _ (C + 1) hcont
    simpa only [evaluar, List.length_cons, Nat.add_assoc, Nat.add_comm 1 C] using h

theorem presupuesto_verificacion (raiz : Digest) (altura i : ℕ) (v : Fp2) (hermanos : List Digest) :
    Nexus.Canal.ProgramaTG2.Acotado (verificar raiz altura i v hermanos) (altura + 1) := by
  intro H
  by_cases hs : hermanos.length = altura
  · rw [verificar, ite_eq_left hs]
    have h := presupuesto_evaluacion H v (hermanosDesdeRaiz i hermanos)
      (fun d => .terminar (decide (d = raiz))) 0 (by intro d; rfl)
    simpa only [hermanos_desde_raiz_longitud, hs, Nat.add_zero] using h
  · rw [rechazo_forma_no_consulta raiz altura i v hermanos hs]
    exact Nat.zero_le _

theorem costo_acotado (H : List Octeto → Digest) (raiz : Digest) (altura i : ℕ)
    (v : Fp2) (hermanos : List Digest) :
    (entradas H (verificar raiz altura i v hermanos)).length ≤ altura + 1 := by
  by_cases hs : hermanos.length = altura
  · exact (costo_forma_valida H raiz altura i v hermanos hs).le
  · rw [rechazo_forma_no_consulta raiz altura i v hermanos hs]
    simp [entradas]

theorem extraccion_desde_ejecucion (H : List Octeto → Digest) (raiz : Digest) (altura i : ℕ)
    (hi : i < 2 ^ altura) (v : Fp2) (hermanos : List Digest)
    (ha : resultado (tabla H) (verificar raiz altura i v hermanos) = true)
    (hc : SinColisiones H (entradas H (verificar raiz altura i v hermanos))) :
    vectorIndexado formatoBytes H (entradas H (verificar raiz altura i v hermanos))
      altura raiz ⟨i, hi⟩ = v :=
  apertura_indexada_extraida _ _ _ hc raiz altura i hi v hermanos
    ((aceptacion_equivale _ _ _ _ _ _).mp ha)
    (aceptacion_produce_registro _ _ _ _ _ _ ha)

end Nexus.Merkle.ProgramaVerificacion
