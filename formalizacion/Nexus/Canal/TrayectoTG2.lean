module

public import Nexus.Canal.Trayecto
public import Nexus.Canal.RegistroCompleto
import Mathlib.Tactic

/-!
# La transcripción efectiva anterior al selector es una cadena recuperable

El trabajo no actualiza el estado del canal. La última entrada de la cadena
es la absorción del nonce, cuya respuesta es la semilla de los índices.
Las listas se toman del canal ejecutado, no de una historia postulada aparte.
-/

public section
namespace Nexus.Canal.TrayectoTG2

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open GramaticaTG2 RegistroRaices Trayecto

theorem agregar_absorcion (H : Entrada → Digest) {es : List Entrada} {s : Digest}
    (c : Camino H es s) (a : Absorcion) :
    Camino H (es ++ [entrada s a]) (H (entrada s a)) := by
  apply Camino.paso c (entrada s a)
  · simp only [entrada, entradaAbsorcion, cabecera, List.append_assoc, List.take_left' s.property]
  · have hl := longitudes_absorcion s a
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hl
    omega

theorem agregar_extension (H : Entrada → Digest) {es : List Entrada} {s : Digest}
    (c : Camino H es s) : Camino H (es ++ [entradaReto s .extension]) (H (entradaReto s .extension)) := by
  apply Camino.paso c (entradaReto s .extension)
  · exact List.take_left' s.property
  · rw [reto_longitud]; omega

theorem prolongar_retos (H : Entrada → Digest) (n : ℕ) (s : Digest) (es : List Entrada)
    (c : Camino H es s) :
    Camino H (es ++ logRetos H n s) (evaluarRetos H n s).1 := by
  induction n generalizing s es with
  | zero => simpa only [logRetos, evaluarRetos, List.append_nil] using c
  | succ n ih =>
    have h := ih (H (entradaReto s .extension)) (es ++ [entradaReto s .extension]) (agregar_extension H c)
    simpa only [logRetos, evaluarRetos, List.append_assoc, List.singleton_append] using h

theorem prolongar_raices (H : Entrada → Digest) (rs : List Digest) (v : Fp2)
    (s : Digest) (es : List Entrada) (c : Camino H es s) :
    Camino H (es ++ logRaices H rs v s) (evaluarRaices H rs v s).1 := by
  induction rs generalizing s es with
  | nil => exact agregar_absorcion H c (.final v)
  | cons r rs ih =>
    have ca := agregar_absorcion H c (.raizFRI r)
    have cr := agregar_extension H ca
    have h := ih (H (entradaReto (H (entrada s (.raizFRI r))) .extension))
      ((es ++ [entrada s (.raizFRI r)]) ++ [entradaReto (H (entrada s (.raizFRI r))) .extension]) cr
    simpa only [logRaices, evaluarRaices, absorcion, reto, respuesta, entrada, etiqueta, datos,
      List.append_assoc, List.singleton_append, List.cons_append, List.nil_append] using h

@[expose] def cadena (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) : List Entrada :=
  RegistroCompleto.prefijo H k bits inicio salida raiz rt rc vt vc ++
    [entrada (RegistroCompleto.evaluar H k bits inicio salida raiz rt rc vt vc).composicion.1 (.nonce n)]

@[expose] def semilla (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) : Digest :=
  H (entrada (RegistroCompleto.evaluar H k bits inicio salida raiz rt rc vt vc).composicion.1 (.nonce n))

theorem camino_canal (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) :
    Camino H (cadena H k bits inicio salida raiz rt rc vt vc n)
      (semilla H k bits inicio salida raiz rt rc vt vc n) := by
  let s0 := H (codificar .inicio)
  let s1 := H (entrada s0 (.perfil (ProgramaTG2.perfil k bits)))
  let s2 := H (entrada s1 (.enunciado (ProgramaTG2.enunciado inicio salida k)))
  let s3 := H (entrada s2 (.raizTraza raiz))
  let a := evaluarRetos H 3 s3
  let st := H (entrada a.1 .faseTraza)
  let t := evaluarRaices H rt vt st
  let sc := H (entrada t.1 .faseComposicion)
  let c := evaluarRaices H rc vc sc
  have h0 : Camino H [codificar .inicio] s0 := Camino.origen _ (by decide)
  have h1 := agregar_absorcion H h0 (.perfil (ProgramaTG2.perfil k bits))
  have h2 := agregar_absorcion H h1 (.enunciado (ProgramaTG2.enunciado inicio salida k))
  have h3 := agregar_absorcion H h2 (.raizTraza raiz)
  have h4 := prolongar_retos H 3 s3 _ h3
  have h5 := agregar_absorcion H h4 .faseTraza
  have h6 := prolongar_raices H rt vt st _ h5
  have h7 := agregar_absorcion H h6 .faseComposicion
  have h8 := prolongar_raices H rc vc sc _ h7
  have h9 := agregar_absorcion H h8 (.nonce n)
  simpa only [cadena, semilla, RegistroCompleto.prefijo, RegistroCompleto.evaluar,
    codificar, entrada, etiqueta, datos, absorcion, s0, s1, s2, s3, a, st, t, sc, c,
    List.append_assoc, List.singleton_append, List.cons_append, List.nil_append] using h9

theorem longitud_cadena (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) :
    (cadena H k bits inicio salida raiz rt rc vt vc n).length = 12 + 2 * (rt.length + rc.length) := by
  have hr (j : ℕ) (s : Digest) : (logRetos H j s).length = j := by
    induction j generalizing s with
    | zero => rfl
    | succ j ih => simp only [logRetos, List.length_cons, ih]
  have hc (rs : List Digest) (v : Fp2) (s : Digest) : (logRaices H rs v s).length = 2 * rs.length + 1 := by
    induction rs generalizing s with
    | nil => rfl
    | cons r rs ih => simp only [logRaices, List.length_cons, ih]; omega
  simp only [cadena, RegistroCompleto.prefijo, List.length_append, List.length_cons,
    List.length_nil, hr, hc]
  omega

theorem longitud_perfil (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) (ht : rt.length = k) (hc : rc.length = k + 1)
    (hk : k ≤ 29) : (cadena H k bits inicio salida raiz rt rc vt vc n).length ≤ 130 := by
  rw [longitud_cadena, ht, hc]
  omega

end Nexus.Canal.TrayectoTG2
