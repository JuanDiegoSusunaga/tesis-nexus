module

public import Nexus.Canal.GramaticaTG2
public import Nexus.ROM.HistoriaCausal
public import Nexus.ROM.PotencialCandidatos
import Mathlib.Tactic

/-!
# Programas causales con la gramática y una sola tabla

Las claves incluyen longitud y hasta 79 octetos. Se preservan las igualdades
de bytes entre roles. Cada programa finito produce una historia compatible;
la respuesta fresca es uniforme al condicionar a esa historia, y la repetida
queda fijada. El compilador hacia árboles de candidatos memoriza por clave,
sin volver a sortear las repeticiones.

Es un adaptador de programas finitos, todavía sin traducción completa del
parser y los bucles Rust, ni prueba del conjunto bueno de cada candidato.
-/

public section
namespace Nexus.ROM.ProgramaCompartido

open Nexus.Bytes Nexus.Merkle Nexus.Canal.GramaticaTG2
open HistoriaCausal

abbrev Clave := Fin 80 × (Fin 79 → Octeto)

instance : Nonempty Digest := ⟨⟨List.replicate 32 0, by simp⟩⟩

theorem entrada_acotada (p : Peticion) : (codificar p).length ≤ 79 := by
  have h := longitudes_gramatica p
  simp only [List.mem_cons, List.not_mem_nil, or_false] at h
  omega

@[expose] def clave (p : Peticion) : Clave :=
  (⟨(codificar p).length, by have h := entrada_acotada p; omega⟩,
    fun i => ((codificar p)[i.val]?).getD 0)

theorem clave_igual_si_bytes_iguales (p q : Peticion) (h : codificar p = codificar q) :
    clave p = clave q := by
  apply Prod.ext
  · exact Fin.ext (congrArg List.length h)
  · funext i
    exact congrArg (fun bs : List Octeto => (bs[i.val]?).getD 0) h

theorem bytes_iguales_si_clave_igual (p q : Peticion) (h : clave p = clave q) :
    codificar p = codificar q := by
  have hn : (codificar p).length = (codificar q).length := congrArg (fun k : Clave => k.1.val) h
  apply List.ext_getElem hn
  intro i hi hj
  have hib : i < 79 := lt_of_lt_of_le hi (entrada_acotada p)
  have he := congrArg (fun k : Clave => k.2 ⟨i, hib⟩) h
  simpa only [clave, List.getElem?_eq_getElem hi, List.getElem?_eq_getElem hj,
    Option.getD_some] using he

theorem clave_igual_iff (p q : Peticion) : clave p = clave q ↔ codificar p = codificar q :=
  ⟨bytes_iguales_si_clave_igual p q, clave_igual_si_bytes_iguales p q⟩

theorem roles_solapados_comparten_clave : ∃ s l r : Digest, ∃ bs : Datos 24,
    clave (.absorber s (.enunciado bs)) = clave (.nodo l r) := by
  obtain ⟨s, l, r, bs, h⟩ := solapamiento_conjunto
  exact ⟨s, l, r, bs, clave_igual_si_bytes_iguales _ _ h⟩

inductive Programa where
  | terminar (aceptado : Bool)
  | consultar (peticion : Peticion) (continuacion : Digest → Programa)

@[expose] def resultado (H : Clave → Digest) : Programa → Bool
  | .terminar b => b
  | .consultar q f => resultado H (f (H (clave q)))

@[expose] def respuestas (H : Clave → Digest) : Programa → List Digest
  | .terminar _ => []
  | .consultar q f => H (clave q) :: respuestas H (f (H (clave q)))

@[expose] def despues : Programa → List Digest → Programa
  | p, [] => p
  | .terminar b, _ :: _ => .terminar b
  | .consultar _ f, d :: ds => despues (f d) ds

@[expose] def proxima : Programa → Clave
  | .terminar _ => clave .inicio
  | .consultar q _ => clave q

@[expose] def estrategia (p : Programa) (rs : List Digest) : Clave := proxima (despues p rs)

theorem historia_producida_compatible (p : Programa) (H : Clave → Digest) :
    Compatible (estrategia p) (respuestas H p) H := by
  induction p with
  | terminar b =>
    intro i
    exact Fin.elim0 i
  | consultar q f ih =>
    intro i
    rcases i with ⟨i, hi⟩
    cases i with
    | zero => rfl
    | succ i =>
      have hin : i < (respuestas H (f (H (clave q)))).length := by
        simpa only [respuestas, List.length_cons, Nat.succ_lt_succ_iff] using hi
      simpa only [estrategia, respuestas, List.take_succ_cons, despues,
        List.getElem_cons_succ] using ih (H (clave q)) ⟨i, hin⟩

theorem prefijo_compatible (e : List Digest → Clave) (rs : List Digest) (H : Clave → Digest)
    (hc : Compatible e rs H) (n : ℕ) : Compatible e (rs.take n) H := by
  intro i
  have hi : i.val < rs.length := by
    have hb := i.isLt
    simp only [List.length_take] at hb
    omega
  have hin : i.val < n := by have hb := i.isLt; simp only [List.length_take] at hb; omega
  simpa only [List.take_take, Nat.min_eq_left hin.le, List.getElem_take] using hc ⟨i.val, hi⟩

/-- La ley se obtiene para todo prefijo producido, manteniendo la condición de frescura. -/
theorem uniforme_en_prefijo (p : Programa) (G : Clave → Digest) (n : ℕ) (a : Digest)
    (hf : estrategia p ((respuestas G p).take n) ∉ vistas (estrategia p) ((respuestas G p).take n)) :
    (Fintype.card (Respuesta (estrategia p) ((respuestas G p).take n)
      (estrategia p ((respuestas G p).take n)) a) : ℚ) /
      Fintype.card (Tablas (estrategia p) ((respuestas G p).take n)) =
        1 / (Fintype.card Digest : ℚ) := by
  exact uniforme_tras_historia _ _ G
    (prefijo_compatible _ _ G (historia_producida_compatible p G) n) a hf

theorem repetida_en_prefijo (p : Programa) (G : Clave → Digest) (n : ℕ) (a : Digest)
    (hq : estrategia p ((respuestas G p).take n) ∈ vistas (estrategia p) ((respuestas G p).take n))
    (ha : a ≠ G (estrategia p ((respuestas G p).take n))) :
    Fintype.card (Respuesta (estrategia p) ((respuestas G p).take n)
      (estrategia p ((respuestas G p).take n)) a) = 0 := by
  exact repetida_tras_historia _ _ G
    (prefijo_compatible _ _ G (historia_producida_compatible p G) n) a hq ha

theorem entradas_distintas_acotadas (p : Programa) (H : Clave → Digest) :
    (vistas (estrategia p) (respuestas H p)).card ≤ (respuestas H p).length :=
  consultas_distintas_acotadas _ _

abbrev Tabla := Clave → Option Digest

@[expose] noncomputable def compilar (tabla : Tabla) : Programa → Potencial.Ensayo Digest
  | .terminar b => .resultado b
  | .consultar q f =>
    match tabla (clave q) with
    | some d => compilar tabla (f d)
    | none => .consultar (fun d => compilar (Function.update tabla (clave q) (some d)) (f d))

theorem compilar_repetida (tabla : Tabla) (q : Peticion) (f : Digest → Programa) (d : Digest)
    (h : tabla (clave q) = some d) :
    compilar tabla (.consultar q f) = compilar tabla (f d) := by
  rw [compilar, h]

theorem compilar_fresca (tabla : Tabla) (q : Peticion) (f : Digest → Programa)
    (h : tabla (clave q) = none) :
    compilar tabla (.consultar q f) =
      .consultar (fun d => compilar (Function.update tabla (clave q) (some d)) (f d)) := by
  rw [compilar, h]

/-- Una segunda consulta de los mismos bytes usa la respuesta memorizada, incluso entre roles. -/
theorem segunda_consulta_sin_sorteo (tabla : Tabla) (q r : Peticion) (f : Digest → Programa)
    (d : Digest) (h : codificar q = codificar r) :
    compilar (Function.update tabla (clave q) (some d)) (.consultar r f) =
      compilar (Function.update tabla (clave q) (some d)) (f d) := by
  apply compilar_repetida
  rw [← clave_igual_si_bytes_iguales q r h, Function.update_self]

end Nexus.ROM.ProgramaCompartido
