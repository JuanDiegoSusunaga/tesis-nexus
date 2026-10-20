module

public import Nexus.ROM.ProgramaCompartido
public import Nexus.Canal.ProgramaTG2
import Mathlib.Tactic

/-!
# Entradas y composición de programas sobre la tabla común

Se recuperan los bytes de las claves y se interpreta cada petición con el
mismo oráculo de bytes. El registro cuenta llamadas, incluidas repeticiones.
La secuencia conserva el rechazo: el segundo programa solo se ejecuta si
el primero acepta. No se presupone registro como hipótesis del verificador.
-/

public section
namespace Nexus.ROM.RegistroPrograma

open Nexus.Bytes Nexus.Merkle Nexus.Canal.GramaticaTG2 ProgramaCompartido

@[expose] def bytesClave (k : Clave) : List Octeto := (List.ofFn k.2).take k.1.val

theorem bytes_de_clave (p : Peticion) : bytesClave (clave p) = codificar p := by
  apply List.ext_getElem
  · simp only [bytesClave, List.length_take, List.length_ofFn, clave]
    exact Nat.min_eq_left (entrada_acotada p)
  · intro i hi hj
    have hi79 : i < 79 := lt_of_lt_of_le hj (entrada_acotada p)
    simp only [bytesClave, List.getElem_take, List.getElem_ofFn, clave,
      List.getElem?_eq_getElem hj, Option.getD_some]

@[expose] def tabla (H : List Octeto → Digest) : Clave → Digest := H ∘ bytesClave

theorem tabla_codificacion (H : List Octeto → Digest) (q : Peticion) :
    tabla H (clave q) = H (codificar q) := by rw [tabla, Function.comp_apply, bytes_de_clave]

@[expose] def entradas (H : List Octeto → Digest) : Programa → List (List Octeto)
  | .terminar _ => []
  | .consultar q f => codificar q :: entradas H (f (H (codificar q)))

theorem entradas_cuentan_respuestas (H : List Octeto → Digest) (p : Programa) :
    (entradas H p).length = (respuestas (tabla H) p).length := by
  induction p with
  | terminar b => rfl
  | consultar q f ih => simp only [entradas, respuestas, List.length_cons, tabla_codificacion, ih]

theorem todas_las_entradas_acotadas (H : List Octeto → Digest) (p : Programa)
    (e : List Octeto) (he : e ∈ entradas H p) : e.length ≤ 79 := by
  induction p with
  | terminar b => simp [entradas] at he
  | consultar q f ih =>
    rcases List.mem_cons.mp he with h | h
    · subst e
      exact entrada_acotada q
    · exact ih _ h

@[expose] def encadenar : Programa → Programa → Programa
  | .terminar b, siguiente => if b then siguiente else .terminar false
  | .consultar q f, siguiente => .consultar q (fun d => encadenar (f d) siguiente)

theorem resultado_encadenado (H : Clave → Digest) (p q : Programa) :
    resultado H (encadenar p q) = (resultado H p && resultado H q) := by
  induction p with
  | terminar b => cases b <;> rfl
  | consultar r f ih => exact ih _

theorem registro_encadenado (H : List Octeto → Digest) (p q : Programa) :
    entradas H (encadenar p q) = entradas H p ++
      (if resultado (tabla H) p then entradas H q else []) := by
  induction p with
  | terminar b => cases b <;> rfl
  | consultar r f ih =>
    simp only [encadenar, entradas, resultado, tabla_codificacion, ih, List.cons_append]

theorem costo_encadenado (H : List Octeto → Digest) (p q : Programa) :
    (entradas H (encadenar p q)).length ≤ (entradas H p).length + (entradas H q).length := by
  rw [registro_encadenado, List.length_append]
  split <;> simp

theorem aceptacion_ambos (H : Clave → Digest) (p q : Programa)
    (h : resultado H (encadenar p q) = true) : resultado H p = true ∧ resultado H q = true := by
  simpa only [resultado_encadenado, Bool.and_eq_true] using h

theorem primero_registrado (H : List Octeto → Digest) (p q : Programa) :
    entradas H p <+: entradas H (encadenar p q) := by
  rw [registro_encadenado]
  exact List.prefix_append _ _

theorem segundo_registrado (H : List Octeto → Digest) (p q : Programa)
    (h : resultado (tabla H) p = true) :
    ∀ e ∈ entradas H q, e ∈ entradas H (encadenar p q) := by
  rw [registro_encadenado, h]
  intro e he
  exact List.mem_append_right _ he

theorem respuestas_encadenadas (H : Clave → Digest) (p q : Programa) :
    respuestas H (encadenar p q) = respuestas H p ++
      (if resultado H p then respuestas H q else []) := by
  induction p with
  | terminar b => cases b <;> rfl
  | consultar r f ih =>
    calc
      respuestas H (encadenar (.consultar r f) q) =
          H (clave r) :: respuestas H (encadenar (f (H (clave r))) q) := rfl
      _ = H (clave r) :: (respuestas H (f (H (clave r))) ++
          (if resultado H (f (H (clave r))) then respuestas H q else [])) :=
        congrArg (List.cons (H (clave r))) (ih (H (clave r)))
      _ = respuestas H (.consultar r f) ++
          (if resultado H (.consultar r f) then respuestas H q else []) := rfl

theorem presupuesto_encadenado (p q : Programa) (A B : ℕ)
    (hp : Nexus.Canal.ProgramaTG2.Acotado p A) (hq : Nexus.Canal.ProgramaTG2.Acotado q B) :
    Nexus.Canal.ProgramaTG2.Acotado (encadenar p q) (A + B) := by
  intro H
  rw [respuestas_encadenadas, List.length_append]
  have h1 := hp H
  have h2 := hq H
  split
  · exact Nat.add_le_add h1 h2
  · simp only [List.length_nil]
    omega

end Nexus.ROM.RegistroPrograma
