module

public import Nexus.Canal.LecturaAbsorcion
public import Nexus.Canal.TrayectoTG2
import Mathlib.Tactic

/-!
# Interpretación ordenada de las dos fases del canal

La lectura consume las dos fases, sus constantes y exactamente un nonce.
Las respuestas E se recuperan aparte de la tabla observada; no son absorciones.
-/

public section
namespace Nexus.Canal.LecturaCadena

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks GramaticaTG2 RegistroRaices

structure Paquete where
  perfil : Datos 38
  enunciado : Datos 24
  raiz : Digest
  rt : List Digest
  rc : List Digest
  vt : Fp2
  vc : Fp2
  nonce : Nonce

@[expose] def fase : List Absorcion → Option (List Digest × Fp2 × List Absorcion)
  | .final v :: resto => some ([], v, resto)
  | .raizFRI r :: resto => (fase resto).map (fun t => (r :: t.1, t.2.1, t.2.2))
  | _ => none

@[expose] def tokens : List Absorcion → Option Paquete
  | .perfil p :: .enunciado e :: .raizTraza r :: .faseTraza :: xs => do
    let t ← fase xs
    match t.2.2 with
    | .faseComposicion :: ys => do
      let c ← fase ys
      match c.2.2 with
      | [.nonce n] => some ⟨p, e, r, t.1, c.1, t.2.1, c.2.1, n⟩
      | _ => none
    | _ => none
  | _ => none

@[expose] def absorciones (es : List (List Octeto)) : List Absorcion :=
  es.filterMap LecturaAbsorcion.leer

@[expose] def leer (es : List (List Octeto)) : Option Paquete := tokens (absorciones es)

theorem fase_leida (rs : List Digest) (v : Fp2) (resto : List Absorcion) :
    fase (rs.map Absorcion.raizFRI ++ .final v :: resto) = some (rs, v, resto) := by
  induction rs with
  | nil => rfl
  | cons r rs ih => simp only [List.map_cons, List.cons_append, fase, ih, Option.map_some]

theorem tokens_completos (p : Datos 38) (e : Datos 24) (r : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) :
    tokens ([.perfil p, .enunciado e, .raizTraza r, .faseTraza] ++
      rt.map Absorcion.raizFRI ++ [.final vt, .faseComposicion] ++
      rc.map Absorcion.raizFRI ++ [.final vc, .nonce n]) = some ⟨p, e, r, rt, rc, vt, vc, n⟩ := by
  simp only [List.append_assoc, List.cons_append, List.nil_append, tokens,
    fase_leida, bind, Option.bind_some]

theorem retos_sin_absorciones (H : List Octeto → Digest) (n : ℕ) (s : Digest) :
    absorciones (logRetos H n s) = [] := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih =>
    simpa only [absorciones, logRetos, List.filterMap_cons, LecturaAbsorcion.leer_reto] using
      ih (H (entradaReto s .extension))

theorem raices_con_absorciones (H : List Octeto → Digest) (rs : List Digest) (v : Fp2) (s : Digest) :
    absorciones (logRaices H rs v s) = rs.map Absorcion.raizFRI ++ [.final v] := by
  induction rs generalizing s with
  | nil => simp only [logRaices, absorciones, codificar, List.filterMap_cons,
      LecturaAbsorcion.leer_entrada, List.filterMap_nil, List.map_nil, List.nil_append]
  | cons r rs ih =>
    have ha : LecturaAbsorcion.leer (absorcion ⟨s, 2, r⟩) = some (.raizFRI r) :=
      LecturaAbsorcion.leer_entrada s (.raizFRI r)
    simp only [absorciones, logRaices, List.filterMap_cons, ha, reto,
      LecturaAbsorcion.leer_reto, List.map_cons, List.cons_append] at ih ⊢
    exact congrArg (Absorcion.raizFRI r :: ·) (ih _)

theorem cadena_con_absorciones (H : List Octeto → Digest) (k bits : ℕ) (inicio salida : Fp)
    (r : Digest) (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) :
    absorciones (TrayectoTG2.cadena H k bits inicio salida r rt rc vt vc n) =
      [.perfil (ProgramaTG2.perfil k bits), .enunciado (ProgramaTG2.enunciado inicio salida k),
        .raizTraza r, .faseTraza] ++ rt.map Absorcion.raizFRI ++
        [.final vt, .faseComposicion] ++ rc.map Absorcion.raizFRI ++ [.final vc, .nonce n] := by
  simp only [TrayectoTG2.cadena, RegistroCompleto.prefijo, absorciones, List.filterMap_append,
    List.filterMap_cons, List.filterMap_nil,
    codificar, LecturaAbsorcion.leer_entrada]
  rw [show (logRetos H 3 _).filterMap LecturaAbsorcion.leer = [] from retos_sin_absorciones H 3 _]
  rw [show (logRaices H rt vt _).filterMap LecturaAbsorcion.leer =
    rt.map Absorcion.raizFRI ++ [.final vt] from raices_con_absorciones H rt vt _]
  rw [show (logRaices H rc vc _).filterMap LecturaAbsorcion.leer =
    rc.map Absorcion.raizFRI ++ [.final vc] from raices_con_absorciones H rc vc _]
  have hi : LecturaAbsorcion.leer dominio = none := LecturaAbsorcion.leer_inicio
  have hb (s : Digest) : LecturaAbsorcion.leer (entradaAbsorcion s 1 r.val) = some (.raizTraza r) :=
    LecturaAbsorcion.leer_entrada s (.raizTraza r)
  simp only [RegistroCompleto.evaluar, absorcion, hi, hb,
    List.append_assoc, List.cons_append, List.nil_append]

theorem cadena_leida (H : List Octeto → Digest) (k bits : ℕ) (inicio salida : Fp)
    (r : Digest) (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) :
    leer (TrayectoTG2.cadena H k bits inicio salida r rt rc vt vc n) =
      some ⟨ProgramaTG2.perfil k bits, ProgramaTG2.enunciado inicio salida k, r, rt, rc, vt, vc, n⟩ := by
  rw [leer, cadena_con_absorciones, tokens_completos]

end Nexus.Canal.LecturaCadena
