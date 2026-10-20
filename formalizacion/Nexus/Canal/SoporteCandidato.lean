module

public import Nexus.Canal.TrayectoTG2
import Mathlib.Tactic

/-!
# La aceptación registra el candidato y la primera consulta I

El trabajo válido se conserva como hecho separado. Su digest no se usa como
semilla: la semilla es la respuesta a la absorción del nonce.
-/

public section
namespace Nexus.Canal.SoporteCandidato

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open ProgramaCompartido RegistroPrograma GramaticaTG2 TrayectoTG2

theorem trabajo_aceptado (H : Entrada → Digest) (k bits R : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) (trabajo : Digest → Bool)
    (c : List Fp2 → List Fp2 → List Fp2 → List (Fin (4 * 2 ^ k)) → Programa)
    (ha : resultado (tabla H) (DesafiosPrograma.ejecutar k bits R inicio salida raiz rt rc vt vc n trabajo c) = true) :
    trabajo (H (codificar (.trabajo (RegistroCompleto.evaluar H k bits inicio salida raiz rt rc vt vc).composicion.1 n))) = true := by
  rw [RegistroCompleto.resultado_canal] at ha
  dsimp only at ha
  split_ifs at ha with hw
  exact hw

theorem cadena_registrada (H : Entrada → Digest) (k bits R : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) (trabajo : Digest → Bool)
    (c : List Fp2 → List Fp2 → List Fp2 → List (Fin (4 * 2 ^ k)) → Programa)
    (ha : resultado (tabla H) (DesafiosPrograma.ejecutar k bits R inicio salida raiz rt rc vt vc n trabajo c) = true) :
    ∀ e ∈ cadena H k bits inicio salida raiz rt rc vt vc n,
      e ∈ entradas H (DesafiosPrograma.ejecutar k bits R inicio salida raiz rt rc vt vc n trabajo c) := by
  have hw := trabajo_aceptado H k bits R inicio salida raiz rt rc vt vc n trabajo c ha
  intro e he
  rw [RegistroCompleto.registro_canal]
  dsimp only
  rw [ite_eq_left hw]
  rcases List.mem_append.mp he with he | he
  · exact List.mem_append_left _ he
  · have heq := List.mem_singleton.mp he
    subst e
    exact List.mem_append_right _ (List.mem_cons_of_mem _ List.mem_cons_self)

theorem indice_registrado (H : Entrada → Digest) (k bits R : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) (trabajo : Digest → Bool)
    (c : List Fp2 → List Fp2 → List Fp2 → List (Fin (4 * 2 ^ k)) → Programa)
    (ha : resultado (tabla H) (DesafiosPrograma.ejecutar k bits R inicio salida raiz rt rc vt vc n trabajo c) = true) :
    entradaReto (semilla H k bits inicio salida raiz rt rc vt vc n) .indice ∈
      entradas H (DesafiosPrograma.ejecutar k bits R inicio salida raiz rt rc vt vc n trabajo c) := by
  have hw := trabajo_aceptado H k bits R inicio salida raiz rt rc vt vc n trabajo c ha
  rw [RegistroCompleto.resultado_canal] at ha
  dsimp only at ha
  rw [ite_eq_left hw] at ha
  cases R with
  | zero => simp [SelectorOrdenado.seleccionar, resultado] at ha
  | succ R =>
    rw [RegistroCompleto.registro_canal]
    dsimp only
    rw [ite_eq_left hw]
    apply List.mem_append_right
    apply List.mem_cons_of_mem
    apply List.mem_cons_of_mem
    simp only [SelectorOrdenado.seleccionar, List.length_nil, show (0 : ℕ) ≠ 40 by decide, ite_false, entradas]
    exact List.mem_cons_self

end Nexus.Canal.SoporteCandidato
