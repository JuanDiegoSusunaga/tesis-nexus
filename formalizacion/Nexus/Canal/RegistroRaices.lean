module

public import Nexus.Canal.DesafiosPrograma
public import Nexus.ROM.EjecucionBytes
import Mathlib.Tactic

/-!
# Registro efectivo de raíces y respuestas del canal

Se despliegan los estados, las consultas y los valores entregados por los
bucles de retos y raíces. Todo se calcula sobre la misma H. Las entradas
se prueban como prefijos del programa, sin hipótesis de registro ni frescura.
-/

public section
namespace Nexus.Canal.RegistroRaices

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open ProgramaCompartido RegistroPrograma GramaticaTG2

structure Evento where
  estado : Digest
  tag : Octeto
  raiz : Digest

@[expose] def absorcion (e : Evento) : Entrada := entradaAbsorcion e.estado e.tag e.raiz.val
@[expose] def reto (H : Entrada → Digest) (e : Evento) : Entrada := entradaReto (H (absorcion e)) .extension
@[expose] def respuesta (H : Entrada → Digest) (e : Evento) : Digest := H (reto H e)
@[expose] def beta (H : Entrada → Digest) (e : Evento) : Fp2 := DesafiosPrograma.extension (respuesta H e)
@[expose] def Registrado (H : Entrada → Digest) (log : List Entrada) (e : Evento) : Prop :=
  absorcion e ∈ log ∧ reto H e ∈ log

@[expose] def evaluarRetos (H : Entrada → Digest) : ℕ → Digest → Digest × List Fp2
  | 0, s => (s, [])
  | n + 1, s => let d := H (entradaReto s .extension)
    let r := evaluarRetos H n d
    (r.1, DesafiosPrograma.extension d :: r.2)

@[expose] def logRetos (H : Entrada → Digest) : ℕ → Digest → List Entrada
  | 0, _ => []
  | n + 1, s => entradaReto s .extension :: logRetos H n (H (entradaReto s .extension))

@[expose] def evaluarRaices (H : Entrada → Digest) : List Digest → Fp2 → Digest → Digest × List Evento
  | [], v, s => (H (codificar (.absorber s (.final v))), [])
  | r :: rs, v, s => let e : Evento := ⟨s, 2, r⟩
    let t := evaluarRaices H rs v (respuesta H e)
    (t.1, e :: t.2)

@[expose] def logRaices (H : Entrada → Digest) : List Digest → Fp2 → Digest → List Entrada
  | [], v, s => [codificar (.absorber s (.final v))]
  | r :: rs, v, s => let e : Evento := ⟨s, 2, r⟩
    absorcion e :: reto H e :: logRaices H rs v (respuesta H e)

theorem retos_resultado (H : Entrada → Digest) (n : ℕ) (s : Digest)
    (c : Digest → List Fp2 → Programa) :
    resultado (tabla H) (DesafiosPrograma.retos n s c) =
      resultado (tabla H) (c (evaluarRetos H n s).1 (evaluarRetos H n s).2) := by
  induction n generalizing s c with
  | zero => rfl
  | succ n ih =>
    simpa only [DesafiosPrograma.retos, resultado, tabla_codificacion, codificar, evaluarRetos] using
      ih (H (entradaReto s .extension))
        (fun t xs => c t (DesafiosPrograma.extension (H (entradaReto s .extension)) :: xs))

theorem retos_registro (H : Entrada → Digest) (n : ℕ) (s : Digest)
    (c : Digest → List Fp2 → Programa) :
    entradas H (DesafiosPrograma.retos n s c) = logRetos H n s ++
      entradas H (c (evaluarRetos H n s).1 (evaluarRetos H n s).2) := by
  induction n generalizing s c with
  | zero => rfl
  | succ n ih => simp only [DesafiosPrograma.retos, entradas, codificar, ih, logRetos,
      evaluarRetos, List.cons_append]

theorem retos_longitud (H : Entrada → Digest) (n : ℕ) (s : Digest) :
    (evaluarRetos H n s).2.length = n := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => simp only [evaluarRetos, List.length_cons, ih]

theorem raices_resultado (H : Entrada → Digest) (rs : List Digest) (v : Fp2) (s : Digest)
    (c : Digest → List Fp2 → Programa) :
    resultado (tabla H) (DesafiosPrograma.raices rs v s c) =
      resultado (tabla H) (c (evaluarRaices H rs v s).1 ((evaluarRaices H rs v s).2.map (beta H))) := by
  induction rs generalizing s c with
  | nil => simp only [DesafiosPrograma.raices, resultado, tabla_codificacion, evaluarRaices, List.map_nil]
  | cons r rs ih =>
    simpa only [DesafiosPrograma.raices, resultado, tabla_codificacion, codificar, entrada,
      etiqueta, datos, evaluarRaices, beta, respuesta, reto, absorcion, List.map_cons] using
      ih (H (entradaReto (H (entradaAbsorcion s 2 r.val)) .extension))
        (fun t xs => c t (DesafiosPrograma.extension (H (entradaReto (H (entradaAbsorcion s 2 r.val)) .extension)) :: xs))

theorem raices_registro (H : Entrada → Digest) (rs : List Digest) (v : Fp2) (s : Digest)
    (c : Digest → List Fp2 → Programa) :
    entradas H (DesafiosPrograma.raices rs v s c) = logRaices H rs v s ++
      entradas H (c (evaluarRaices H rs v s).1 ((evaluarRaices H rs v s).2.map (beta H))) := by
  induction rs generalizing s c with
  | nil => rfl
  | cons r rs ih => simp only [DesafiosPrograma.raices, entradas, codificar, entrada,
      etiqueta, datos, ih, logRaices, evaluarRaices, beta, respuesta, reto, absorcion,
      List.map_cons, List.cons_append]

theorem raices_proyeccion (H : Entrada → Digest) (rs : List Digest) (v : Fp2) (s : Digest) :
    (evaluarRaices H rs v s).2.map Evento.raiz = rs := by
  induction rs generalizing s with
  | nil => rfl
  | cons r rs ih => simp only [evaluarRaices, List.map_cons, ih]

theorem raices_longitud (H : Entrada → Digest) (rs : List Digest) (v : Fp2) (s : Digest) :
    (evaluarRaices H rs v s).2.length = rs.length := by
  have h := congrArg List.length (raices_proyeccion H rs v s)
  simpa only [List.length_map] using h

theorem eventos_registrados (H : Entrada → Digest) (rs : List Digest) (v : Fp2) (s : Digest)
    (e : Evento) (he : e ∈ (evaluarRaices H rs v s).2) : Registrado H (logRaices H rs v s) e := by
  induction rs generalizing s with
  | nil => simp only [evaluarRaices, List.not_mem_nil] at he
  | cons r rs ih =>
    rcases List.mem_cons.mp he with rfl | he
    · exact ⟨List.mem_cons_self, List.mem_cons_of_mem _ List.mem_cons_self⟩
    · have hr := ih _ he
      exact ⟨List.mem_cons_of_mem _ (List.mem_cons_of_mem _ hr.1),
        List.mem_cons_of_mem _ (List.mem_cons_of_mem _ hr.2)⟩

theorem registrado_monotono (H : Entrada → Digest) (a b : List Entrada)
    (hab : ∀ x ∈ a, x ∈ b) (e : Evento) (he : Registrado H a e) : Registrado H b e :=
  ⟨hab _ he.1, hab _ he.2⟩

end Nexus.Canal.RegistroRaices
