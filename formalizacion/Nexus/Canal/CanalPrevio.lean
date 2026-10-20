module

public import Nexus.ROM.CoincidenciaPrograma
public import Nexus.Canal.ParametrosRecuperados
import Mathlib.Tactic

/-!
# Reejecución canónica del canal anterior al selector

Este programa termina tras la absorción del nonce. No consulta el trabajo ni
los índices: una primera I deliberada puede preceder a la consulta de trabajo.
Su salida es la semilla y sus entradas son exactamente la cadena recuperada.
-/

public section
namespace Nexus.Canal.CanalPrevio

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open ProgramaBytes CoincidenciaPrograma ParametrosRecuperados RegistroRaices GramaticaTG2

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def retos : ℕ → Digest → Programa Digest
  | 0, s => .terminar s
  | n + 1, s => .consultar (entradaReto s .extension) (retos n)

@[expose] def raices : List Digest → Fp2 → Digest → Programa Digest
  | [], v, s => .consultar (entrada s (.final v)) .terminar
  | r :: rs, v, s => .consultar (entrada s (.raizFRI r)) (fun d =>
      .consultar (entradaReto d .extension) (raices rs v))

@[expose] def programa (d : DatosCanal) : Programa Digest :=
  .consultar (codificar .inicio) (fun s0 =>
    .consultar (entrada s0 (.perfil (ProgramaTG2.perfil d.k d.bits))) (fun s1 =>
      .consultar (entrada s1 (.enunciado (ProgramaTG2.enunciado d.inicio d.salida d.k))) (fun s2 =>
        .consultar (entrada s2 (.raizTraza d.raiz)) (fun s3 =>
          unir (retos 3 s3) (fun s4 =>
            .consultar (entrada s4 .faseTraza) (fun st =>
              unir (raices d.rt d.vt st) (fun s5 =>
                .consultar (entrada s5 .faseComposicion) (fun sc =>
                  unir (raices d.rc d.vc sc) (fun s6 =>
                    .consultar (entrada s6 (.nonce d.nonce)) .terminar)))))))))

@[expose] def cadena (H : Entrada → Digest) (d : DatosCanal) : List Entrada :=
  TrayectoTG2.cadena H d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc d.nonce

@[expose] def semilla (H : Entrada → Digest) (d : DatosCanal) : Digest :=
  TrayectoTG2.semilla H d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc d.nonce

theorem resultado_retos (H : Entrada → Digest) (n : ℕ) (s : Digest) :
    resultado H (retos n s) = (evaluarRetos H n s).1 := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => exact ih (H (entradaReto s .extension))

theorem entradas_retos (H : Entrada → Digest) (n : ℕ) (s : Digest) :
    entradas H (retos n s) = logRetos H n s := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih =>
    simpa only [retos, entradas_consultar, logRetos] using
      (congrArg (List.cons (entradaReto s .extension)) (ih (H (entradaReto s .extension))))

theorem resultado_raices (H : Entrada → Digest) (rs : List Digest) (v : Fp2) (s : Digest) :
    resultado H (raices rs v s) = (evaluarRaices H rs v s).1 := by
  induction rs generalizing s with
  | nil => rfl
  | cons r rs ih => exact ih (H (entradaReto (H (entrada s (.raizFRI r))) .extension))

theorem entradas_raices (H : Entrada → Digest) (rs : List Digest) (v : Fp2) (s : Digest) :
    entradas H (raices rs v s) = logRaices H rs v s := by
  induction rs generalizing s with
  | nil => rfl
  | cons r rs ih =>
    simpa only [raices, entradas, traza, List.map_cons, logRaices, absorcion, reto, respuesta,
      entrada, etiqueta, datos] using congrArg (fun es => entrada s (.raizFRI r) ::
        entradaReto (H (entrada s (.raizFRI r))) .extension :: es)
      (ih (H (entradaReto (H (entrada s (.raizFRI r))) .extension)))

theorem resultado_programa (H : Entrada → Digest) (d : DatosCanal) :
    resultado H (programa d) = semilla H d := by
  simp only [programa, resultado, resultado_unir, resultado_retos, resultado_raices,
    semilla, TrayectoTG2.semilla, RegistroCompleto.evaluar, absorcion, entrada, etiqueta, datos, codificar]

theorem entradas_programa (H : Entrada → Digest) (d : DatosCanal) :
    entradas H (programa d) = cadena H d := by
  simp only [programa, entradas_consultar, entradas_terminar, entradas_unir,
    entradas_retos, entradas_raices, resultado_retos, resultado_raices]
  simp only [cadena, TrayectoTG2.cadena, RegistroCompleto.prefijo, RegistroCompleto.evaluar,
    absorcion, entrada, etiqueta, datos, codificar, List.cons_append, List.nil_append, List.append_assoc]

theorem canal_congruente (H G : Entrada → Digest) (d : DatosCanal)
    (h : ∀ e ∈ cadena H d, H e = G e) :
    semilla H d = semilla G d ∧ cadena H d = cadena G d := by
  have hh := ejecucion_congruente H G (programa d) (by simpa only [entradas_programa] using h)
  have ht := entradas_congruentes H G (programa d) (by simpa only [entradas_programa] using h)
  exact ⟨by simpa only [resultado_programa] using hh.1,
    by simpa only [entradas_programa] using ht⟩

end Nexus.Canal.CanalPrevio
