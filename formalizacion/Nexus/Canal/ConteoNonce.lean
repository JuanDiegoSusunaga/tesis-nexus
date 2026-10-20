module

public import Nexus.Verificador.Adversario
public import Nexus.Canal.RegistroCompleto
import Mathlib.Tactic

/-!
# El programa real consulta a lo sumo Q+1 entradas de 49 octetos

En la gramática del verificador solo la absorción del nonce tiene esa
longitud. Merkle, AIR, ambos FRI y las continuaciones del selector no
añaden ninguna. Las consultas adversarias arbitrarias se cobran una a una,
también cuando están intercaladas. El argumento vale para cualquier H.
-/

public section
namespace Nexus.Canal.ConteoNonce

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open ProgramaCompartido RegistroPrograma GramaticaTG2

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def contar (es : List Entrada) : ℕ := (es.filter (fun e => e.length = 49)).length
@[expose] def registro (H : Entrada → Digest) (p : Programa) : ℕ := contar (entradas H p)

@[simp] theorem contar_nil : contar [] = 0 := rfl

theorem contar_cons (e : Entrada) (es : List Entrada) :
    contar (e :: es) = (if e.length = 49 then 1 else 0) + contar es := by
  by_cases he : e.length = 49 <;> simp [contar, he, Nat.add_comm]

@[simp] theorem contar_append (es fs : List Entrada) : contar (es ++ fs) = contar es + contar fs := by
  simp only [contar, List.filter_append, List.length_append]

theorem contar_le_longitud (es : List Entrada) : contar es ≤ es.length := List.length_filter_le _ _

@[simp] theorem registro_terminal (H : Entrada → Digest) (b : Bool) : registro H (.terminar b) = 0 := rfl

theorem consulta_no_nonce (H : Entrada → Digest) (q : Peticion) (f : Digest → Programa)
    (hq : (codificar q).length ≠ 49) : registro H (.consultar q f) = registro H (f (H (codificar q))) := by
  simp only [registro, entradas, contar_cons, hq, ite_false, Nat.zero_add]

theorem registro_encadenar (H : Entrada → Digest) (p q : Programa) :
    registro H (encadenar p q) ≤ registro H p + registro H q := by
  unfold registro
  rw [registro_encadenado, contar_append]
  split_ifs <;> simp

theorem encadenar_cero (H : Entrada → Digest) (p q : Programa)
    (hp : registro H p = 0) (hq : registro H q = 0) : registro H (encadenar p q) = 0 := by
  have h := registro_encadenar H p q
  rw [hp, hq] at h
  omega

theorem merkle_evaluar (H : Entrada → Digest) (v : Fp2) (hs : List (Bool × Digest))
    (c : Digest → Programa) (hc : ∀ d, registro H (c d) = 0) :
    registro H (Nexus.Merkle.ProgramaVerificacion.evaluar v hs c) = 0 := by
  induction hs generalizing c with
  | nil =>
    rw [Nexus.Merkle.ProgramaVerificacion.evaluar, consulta_no_nonce]
    · exact hc _
    · simp [codificar, hoja_codificada_longitud]
  | cons par hs ih =>
    rw [Nexus.Merkle.ProgramaVerificacion.evaluar]
    apply ih
    intro hijo
    rw [consulta_no_nonce]
    · exact hc _
    · cases par.1 <;> simp [Nexus.Merkle.ProgramaVerificacion.peticionNodo, codificar, nodo_codificado_longitud]

theorem merkle_verificar (H : Entrada → Digest) (r : Digest) (h i : ℕ) (v : Fp2) (hs : List Digest) :
    registro H (Nexus.Merkle.ProgramaVerificacion.verificar r h i v hs) = 0 := by
  unfold Nexus.Merkle.ProgramaVerificacion.verificar
  split
  · exact merkle_evaluar H v _ _ (fun _ => rfl)
  · rfl

theorem air_aperturas (H : Entrada → Digest) (r : Digest) (h : ℕ)
    (ps : List (Nexus.Verificador.Punto × ℕ)) :
    registro H (Nexus.Verificador.ProgramaConsulta.air r h ps) = 0 := by
  induction ps with
  | nil => rfl
  | cons p ps ih => exact encadenar_cero H _ _ (merkle_verificar H _ _ _ _ _) ih

theorem fri_recorrer (H : Entrada → Digest) (k j : ℕ) (cs : List ProgramaFRI.Capa)
    (s : Recorrido.Estado) (c : Recorrido.Estado → Programa) (hc : ∀ s, registro H (c s) = 0) :
    registro H (ProgramaFRI.recorrer k j cs s c) = 0 := by
  induction cs generalizing j s with
  | nil => exact hc s
  | cons capa cs ih =>
    unfold ProgramaFRI.recorrer ProgramaFRI.paso
    apply encadenar_cero H _ _ (merkle_verificar H _ _ _ _ _)
    apply encadenar_cero H _ _ (merkle_verificar H _ _ _ _ _)
    split
    · exact ih _ _
    · rfl

theorem fri_verificar (H : Entrada → Digest) (k m pos : ℕ) (rs : List Digest) (bs : List Fp2)
    (ds : List Recorrido.Apertura) (v : Fp2) : registro H (ProgramaFRI.verificar k m pos rs bs ds v) = 0 := by
  unfold ProgramaFRI.verificar
  split
  · exact fri_recorrer H _ _ _ _ _ (fun _ => rfl)
  · rfl

theorem consulta (H : Entrada → Digest) (k i : ℕ) (e : Nexus.Verificador.Enunciado)
    (p : Nexus.Verificador.Prueba) (a bt bc : List Fp2) (q : Nexus.Verificador.Consulta) :
    registro H (Nexus.Verificador.ProgramaConsulta.verificar k i e p a bt bc q) = 0 := by
  unfold Nexus.Verificador.ProgramaConsulta.verificar
  split
  · apply encadenar_cero H _ _ (air_aperturas H _ _ _)
    apply encadenar_cero H _ _ rfl
    apply encadenar_cero H _ _ (fri_verificar H _ _ _ _ _ _ _)
    exact encadenar_cero H _ _ rfl (fri_verificar H _ _ _ _ _ _ _)
  · rfl

theorem consultas (H : Entrada → Digest) (k : ℕ) (e : Nexus.Verificador.Enunciado)
    (p : Nexus.Verificador.Prueba) (a bt bc : List Fp2)
    (qs : List Nexus.Verificador.Consulta) (is : List ℕ) :
    registro H (Nexus.Verificador.Completo.consultas k e p a bt bc qs is) = 0 := by
  induction qs generalizing is with
  | nil => cases is <;> rfl
  | cons q qs ih => cases is with
    | nil => rfl
    | cons i is => exact encadenar_cero H _ _ (consulta H _ _ _ _ _ _ _ _) (ih is)

theorem selector_cero (H : Entrada → Digest) (M : ℕ) (hM : 0 < M) (R : ℕ) (s : Digest)
    (S : List (Fin M)) (c : List (Fin M) → Programa) (hc : ∀ xs, registro H (c xs) = 0) :
    registro H (SelectorOrdenado.seleccionar M hM R s S c) = 0 := by
  induction R generalizing s S with
  | zero =>
    unfold SelectorOrdenado.seleccionar
    split
    · exact hc _
    · rfl
  | succ R ih =>
    unfold SelectorOrdenado.seleccionar
    split
    · exact hc _
    · rw [consulta_no_nonce]
      · exact ih _ _
      · simp [codificar, reto_longitud]

@[simp] theorem contar_log_retos (H : Entrada → Digest) (n : ℕ) (s : Digest) :
    contar (RegistroRaices.logRetos H n s) = 0 := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => simp only [RegistroRaices.logRetos, contar_cons, reto_longitud, ih]; norm_num

@[simp] theorem contar_log_raices (H : Entrada → Digest) (rs : List Digest) (v : Fp2) (s : Digest) :
    contar (RegistroRaices.logRaices H rs v s) = 0 := by
  induction rs generalizing s with
  | nil => simp [RegistroRaices.logRaices, contar_cons, codificar, entrada, absorcion_longitud,
      datos, bytes_fp2_longitud]
  | cons r rs ih =>
    simp [RegistroRaices.logRaices, contar_cons, RegistroRaices.absorcion, RegistroRaices.reto,
      absorcion_longitud, r.property, reto_longitud, ih]

theorem contar_prefijo (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (r : Digest)
    (rt rc : List Digest) (vt vc : Fp2) :
    contar (RegistroCompleto.prefijo H k bits inicio salida r rt rc vt vc) = 0 := by
  have hb : (RegistroRaices.absorcion
      (RegistroCompleto.evaluar H k bits inicio salida r rt rc vt vc).base).length = 73 := by
    change (entradaAbsorcion _ 1 r.val).length = 73
    rw [absorcion_longitud, r.property]
  simp [RegistroCompleto.prefijo, contar_cons, codificar, entrada, absorcion_longitud,
    datos, longitud_datos, hb, dominio]

theorem canal (H : Entrada → Digest) (k bits R : ℕ) (inicio salida : Fp) (r : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) (trabajo : Digest → Bool)
    (c : List Fp2 → List Fp2 → List Fp2 → List (Fin (4 * 2 ^ k)) → Programa)
    (hc : ∀ a bt bc S, registro H (c a bt bc S) = 0) :
    registro H (DesafiosPrograma.ejecutar k bits R inicio salida r rt rc vt vc n trabajo c) ≤ 1 := by
  unfold registro
  rw [RegistroCompleto.registro_canal]
  dsimp only
  rw [contar_append, contar_prefijo]
  let v := RegistroCompleto.evaluar H k bits inicio salida r rt rc vt vc
  have hwlen : (codificar (.trabajo v.composicion.1 n)).length ≠ 49 := by
    simp only [codificar, trabajo_longitud]; decide
  rw [contar_cons, ite_eq_right hwlen]
  simp only [Nat.zero_add]
  by_cases hw : trabajo (H (codificar (.trabajo v.composicion.1 n))) = true
  · rw [ite_eq_left hw]
    have hs := selector_cero H (4 * 2 ^ k) (by positivity) R
      (H (codificar (.absorber v.composicion.1 (.nonce n)))) []
      (c v.alfas.2 (v.traza.2.map (RegistroRaices.beta H)) (v.composicion.2.map (RegistroRaices.beta H)))
      (hc v.alfas.2 (v.traza.2.map (RegistroRaices.beta H)) (v.composicion.2.map (RegistroRaices.beta H)))
    change contar (_ :: entradas H (SelectorOrdenado.seleccionar _ _ _ _ _ _)) ≤ 1
    rw [contar_cons]
    have hn : (codificar (.absorber v.composicion.1 (.nonce n))).length = 49 :=
      longitud_nonce_absorbido _ n
    rw [hn, ite_eq_left rfl]
    change 1 + registro H _ ≤ 1
    rw [hs]
  · rw [ite_eq_right hw]
    exact Nat.zero_le 1

theorem verificador (H : Entrada → Digest) (k bits R : ℕ) (c : Nexus.Verificador.Certificado) :
    registro H (Nexus.Verificador.Completo.verificar k bits R c) ≤ 1 := by
  unfold Nexus.Verificador.Completo.verificar
  split
  · exact canal H _ _ _ _ _ _ _ _ _ _ _ _ _ (fun a bt bc S => consultas H _ _ _ _ _ _ _ _)
  · exact Nat.zero_le _

theorem bytes (H : Entrada → Digest) (bits R : ℕ) (bs : List Octeto) :
    registro H (Nexus.Verificador.Completo.desdeBytes bits R bs) ≤ 1 := by
  unfold Nexus.Verificador.Completo.desdeBytes
  split
  · exact Nat.zero_le _
  · exact verificador H _ _ _ _

theorem intercalado {A : Type} (H : Entrada → Digest)
    (atacar : A → Peticion → ProgramaBytes.Programa A)
    (actualizar : A → Peticion → Digest → A) (p : Programa) (a : A) :
    contar (ProgramaBytes.entradas H (Intercalaciones.intercalar atacar actualizar p a)) ≤
      Intercalaciones.extras H atacar actualizar p a + registro H p := by
  induction p generalizing a with
  | terminar b => rfl
  | consultar q f ih =>
    have ha := contar_le_longitud (ProgramaBytes.entradas H (atacar a q))
    have hr := ih (H (codificar q)) (actualizar (ProgramaBytes.resultado H (atacar a q)) q (H (codificar q)))
    simp only [Intercalaciones.intercalar, ProgramaBytes.entradas, ProgramaBytes.traza_unir,
      ProgramaBytes.traza, List.map_append, List.map_cons, contar_append, contar_cons,
      Intercalaciones.extras, registro, entradas]
    simp only [ProgramaBytes.entradas, List.length_map, registro] at ha hr
    omega

theorem adversario {A : Type} (H : Entrada → Digest) (bits R : ℕ)
    (proponer : ProgramaBytes.Programa (List Octeto × A)) (atacar : A → Peticion → ProgramaBytes.Programa A)
    (actualizar : A → Peticion → Digest → A) :
    contar (ProgramaBytes.entradas H (Nexus.Verificador.Adversario.ejecutar bits R proponer atacar actualizar)) ≤
      Nexus.Verificador.Adversario.adversarias H bits R proponer atacar actualizar + 1 := by
  have hp := contar_le_longitud (ProgramaBytes.entradas H proponer)
  have hi := intercalado H atacar actualizar
    (Nexus.Verificador.Completo.desdeBytes bits R (ProgramaBytes.resultado H proponer).1)
    (ProgramaBytes.resultado H proponer).2
  have hv := bytes H bits R (ProgramaBytes.resultado H proponer).1
  simp only [Nexus.Verificador.Adversario.ejecutar, ProgramaBytes.entradas, ProgramaBytes.traza_unir,
    List.map_append, contar_append, Nexus.Verificador.Adversario.adversarias]
  simp only [ProgramaBytes.entradas, List.length_map] at hp hi
  omega

end Nexus.Canal.ConteoNonce
