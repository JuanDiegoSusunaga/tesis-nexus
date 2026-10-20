module

public import Nexus.Canal.ParTrabajo
public import Nexus.Verificador.Adversario
import Mathlib.Tactic

/-!
# A lo sumo Q+1 parejas distintas de trabajo y nonce en el programa real

Las dos consultas del verificador pertenecen a una sola pareja. Cada llamada
adversaria añade como máximo una. El conteo es de claves distintas, por lo
que tampoco se duplica un candidato al consultar el nonce antes del trabajo.
-/

public section
namespace Nexus.Canal.ConteoPares

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open ProgramaCompartido RegistroPrograma GramaticaTG2 ParTrabajo

set_option maxRecDepth 4096
set_option maxHeartbeats 800000
attribute [local instance] Classical.propDecidable

@[expose] noncomputable def registro (H : Entrada → Digest) (p : Programa) : Finset ParTrabajo.Clave :=
  claves (entradas H p)

@[simp] theorem registro_terminal (H : Entrada → Digest) (b : Bool) : registro H (.terminar b) = ∅ := rfl

theorem consulta_ignorada (H : Entrada → Digest) (q : Peticion) (f : Digest → Programa)
    (hq : peticion q = none) : registro H (.consultar q f) = registro H (f (H (codificar q))) := by
  exact claves_cons_none _ _ ((leer_codificar q).trans hq)

theorem encadenar_vacio (H : Entrada → Digest) (p q : Programa)
    (hp : registro H p = ∅) (hq : registro H q = ∅) : registro H (encadenar p q) = ∅ := by
  unfold registro at hp hq ⊢
  rw [registro_encadenado]
  split_ifs <;> simp only [claves_append, hp, hq, Finset.union_self, claves_nil]

theorem merkle_evaluar (H : Entrada → Digest) (v : Fp2) (hs : List (Bool × Digest))
    (c : Digest → Programa) (hc : ∀ d, registro H (c d) = ∅) :
    registro H (Nexus.Merkle.ProgramaVerificacion.evaluar v hs c) = ∅ := by
  induction hs generalizing c with
  | nil =>
    rw [Nexus.Merkle.ProgramaVerificacion.evaluar, consulta_ignorada]
    · exact hc _
    · rfl
  | cons par hs ih =>
    rw [Nexus.Merkle.ProgramaVerificacion.evaluar]
    apply ih
    intro hijo
    rw [consulta_ignorada]
    · exact hc _
    · cases par.1 <;> rfl

theorem merkle_verificar (H : Entrada → Digest) (r : Digest) (h i : ℕ) (v : Fp2) (hs : List Digest) :
    registro H (Nexus.Merkle.ProgramaVerificacion.verificar r h i v hs) = ∅ := by
  unfold Nexus.Merkle.ProgramaVerificacion.verificar
  split
  · exact merkle_evaluar H v _ _ (fun _ => rfl)
  · rfl

theorem air_aperturas (H : Entrada → Digest) (r : Digest) (h : ℕ)
    (ps : List (Nexus.Verificador.Punto × ℕ)) :
    registro H (Nexus.Verificador.ProgramaConsulta.air r h ps) = ∅ := by
  induction ps with
  | nil => rfl
  | cons p ps ih => exact encadenar_vacio H _ _ (merkle_verificar H _ _ _ _ _) ih

theorem fri_recorrer (H : Entrada → Digest) (k j : ℕ) (cs : List ProgramaFRI.Capa)
    (s : Recorrido.Estado) (c : Recorrido.Estado → Programa) (hc : ∀ s, registro H (c s) = ∅) :
    registro H (ProgramaFRI.recorrer k j cs s c) = ∅ := by
  induction cs generalizing j s with
  | nil => exact hc s
  | cons capa cs ih =>
    unfold ProgramaFRI.recorrer ProgramaFRI.paso
    apply encadenar_vacio H _ _ (merkle_verificar H _ _ _ _ _)
    apply encadenar_vacio H _ _ (merkle_verificar H _ _ _ _ _)
    split
    · exact ih _ _
    · rfl

theorem fri_verificar (H : Entrada → Digest) (k m pos : ℕ) (rs : List Digest) (bs : List Fp2)
    (ds : List Recorrido.Apertura) (v : Fp2) : registro H (ProgramaFRI.verificar k m pos rs bs ds v) = ∅ := by
  unfold ProgramaFRI.verificar
  split
  · exact fri_recorrer H _ _ _ _ _ (fun _ => rfl)
  · rfl

theorem consulta (H : Entrada → Digest) (k i : ℕ) (e : Nexus.Verificador.Enunciado)
    (p : Nexus.Verificador.Prueba) (a bt bc : List Fp2) (q : Nexus.Verificador.Consulta) :
    registro H (Nexus.Verificador.ProgramaConsulta.verificar k i e p a bt bc q) = ∅ := by
  unfold Nexus.Verificador.ProgramaConsulta.verificar
  split
  · apply encadenar_vacio H _ _ (air_aperturas H _ _ _)
    apply encadenar_vacio H _ _ rfl
    apply encadenar_vacio H _ _ (fri_verificar H _ _ _ _ _ _ _)
    exact encadenar_vacio H _ _ rfl (fri_verificar H _ _ _ _ _ _ _)
  · rfl

theorem consultas (H : Entrada → Digest) (k : ℕ) (e : Nexus.Verificador.Enunciado)
    (p : Nexus.Verificador.Prueba) (a bt bc : List Fp2)
    (qs : List Nexus.Verificador.Consulta) (is : List ℕ) :
    registro H (Nexus.Verificador.Completo.consultas k e p a bt bc qs is) = ∅ := by
  induction qs generalizing is with
  | nil => cases is <;> rfl
  | cons q qs ih => cases is with
    | nil => rfl
    | cons i is => exact encadenar_vacio H _ _ (consulta H _ _ _ _ _ _ _ _) (ih is)

theorem selector_vacio (H : Entrada → Digest) (M : ℕ) (hM : 0 < M) (R : ℕ) (s : Digest)
    (S : List (Fin M)) (c : List (Fin M) → Programa) (hc : ∀ xs, registro H (c xs) = ∅) :
    registro H (SelectorOrdenado.seleccionar M hM R s S c) = ∅ := by
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
    · rw [consulta_ignorada]
      · exact ih _ _
      · rfl

@[simp] theorem claves_log_retos (H : Entrada → Digest) (n : ℕ) (s : Digest) :
    claves (RegistroRaices.logRetos H n s) = ∅ := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih =>
    rw [RegistroRaices.logRetos, claves_cons_none, ih]
    exact leer_fuera _ (by rw [reto_longitud]; decide) (by rw [reto_longitud]; decide)

@[simp] theorem claves_log_raices (H : Entrada → Digest) (rs : List Digest) (v : Fp2) (s : Digest) :
    claves (RegistroRaices.logRaices H rs v s) = ∅ := by
  induction rs generalizing s with
  | nil =>
    change claves [codificar (.absorber s (.final v))] = ∅
    have he : leer (codificar (.absorber s (.final v))) = none := by rw [leer_codificar]; rfl
    exact (claves_cons_none _ [] he).trans claves_nil
  | cons r rs ih =>
    rw [RegistroRaices.logRaices, claves_cons_none, claves_cons_none, ih]
    · exact leer_fuera _ (by rw [RegistroRaices.reto, reto_longitud]; decide)
        (by rw [RegistroRaices.reto, reto_longitud]; decide)
    · exact leer_fuera _ (by simp [RegistroRaices.absorcion, absorcion_longitud, r.property])
        (by simp [RegistroRaices.absorcion, absorcion_longitud, r.property])

theorem claves_prefijo (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (r : Digest)
    (rt rc : List Digest) (vt vc : Fp2) :
    claves (RegistroCompleto.prefijo H k bits inicio salida r rt rc vt vc) = ∅ := by
  have hb : leer (RegistroRaices.absorcion
      (RegistroCompleto.evaluar H k bits inicio salida r rt rc vt vc).base) = none := by
    apply leer_fuera
    · change (entradaAbsorcion _ 1 r.val).length ≠ 41
      rw [absorcion_longitud, r.property]
      decide
    · change (entradaAbsorcion _ 1 r.val).length ≠ 49
      rw [absorcion_longitud, r.property]
      decide
  simp only [RegistroCompleto.prefijo, claves_append, claves_log_retos, claves_log_raices,
    claves_cons_none _ _ ((leer_codificar .inicio).trans rfl),
    claves_cons_none _ _ ((leer_codificar (.absorber _ (.perfil _))).trans rfl),
    claves_cons_none _ _ ((leer_codificar (.absorber _ (.enunciado _))).trans rfl),
    claves_cons_none _ _ hb,
    claves_cons_none _ _ ((leer_codificar (.absorber _ .faseTraza)).trans rfl),
    claves_cons_none _ _ ((leer_codificar (.absorber _ .faseComposicion)).trans rfl),
    claves_nil, Finset.union_self]

theorem canal (H : Entrada → Digest) (k bits R : ℕ) (inicio salida : Fp) (r : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) (trabajo : Digest → Bool)
    (c : List Fp2 → List Fp2 → List Fp2 → List (Fin (4 * 2 ^ k)) → Programa)
    (hc : ∀ a bt bc S, registro H (c a bt bc S) = ∅) :
    (registro H (DesafiosPrograma.ejecutar k bits R inicio salida r rt rc vt vc n trabajo c)).card ≤ 1 := by
  unfold registro
  rw [RegistroCompleto.registro_canal]
  dsimp only
  rw [claves_append, claves_prefijo, Finset.empty_union]
  let v := RegistroCompleto.evaluar H k bits inicio salida r rt rc vt vc
  rw [claves_cons_some _ _ (v.composicion.1, n) (leer_codificar (.trabajo v.composicion.1 n))]
  by_cases hw : trabajo (H (codificar (.trabajo v.composicion.1 n))) = true
  · rw [ite_eq_left hw]
    have hs := selector_vacio H (4 * 2 ^ k) (by positivity) R
      (H (codificar (.absorber v.composicion.1 (.nonce n)))) []
      (c v.alfas.2 (v.traza.2.map (RegistroRaices.beta H)) (v.composicion.2.map (RegistroRaices.beta H)))
      (hc v.alfas.2 (v.traza.2.map (RegistroRaices.beta H)) (v.composicion.2.map (RegistroRaices.beta H)))
    rw [claves_cons_some _ _ (v.composicion.1, n) (leer_codificar (.absorber v.composicion.1 (.nonce n)))]
    change (insert _ (insert _ (registro H _))).card ≤ 1
    rw [hs]
    simp
  · rw [ite_eq_right hw]
    simp

theorem verificador (H : Entrada → Digest) (k bits R : ℕ) (c : Nexus.Verificador.Certificado) :
    (registro H (Nexus.Verificador.Completo.verificar k bits R c)).card ≤ 1 := by
  unfold Nexus.Verificador.Completo.verificar
  split
  · exact canal H _ _ _ _ _ _ _ _ _ _ _ _ _ (fun a bt bc S => consultas H _ _ _ _ _ _ _ _)
  · simp

theorem bytes (H : Entrada → Digest) (bits R : ℕ) (bs : List Octeto) :
    (registro H (Nexus.Verificador.Completo.desdeBytes bits R bs)).card ≤ 1 := by
  unfold Nexus.Verificador.Completo.desdeBytes
  split
  · simp
  · exact verificador H _ _ _ _

@[expose] def extras {A : Type} (H : Entrada → Digest) (atacar : A → Peticion → ProgramaBytes.Programa A)
    (actualizar : A → Peticion → Digest → A) : Programa → A → List Entrada
  | .terminar _, _ => []
  | .consultar q f, a => ProgramaBytes.entradas H (atacar a q) ++
      extras H atacar actualizar (f (H (codificar q)))
        (actualizar (ProgramaBytes.resultado H (atacar a q)) q (H (codificar q)))

theorem longitud_extras {A : Type} (H : Entrada → Digest) (atacar : A → Peticion → ProgramaBytes.Programa A)
    (actualizar : A → Peticion → Digest → A) (p : Programa) (a : A) :
    (extras H atacar actualizar p a).length = Intercalaciones.extras H atacar actualizar p a := by
  induction p generalizing a with
  | terminar b => rfl
  | consultar q f ih => simp only [extras, List.length_append, Intercalaciones.extras,
      ProgramaBytes.entradas, List.length_map, ih]

theorem registro_intercalado {A : Type} (H : Entrada → Digest) (atacar : A → Peticion → ProgramaBytes.Programa A)
    (actualizar : A → Peticion → Digest → A) (p : Programa) (a : A) :
    ∀ e ∈ ProgramaBytes.entradas H (Intercalaciones.intercalar atacar actualizar p a),
      e ∈ extras H atacar actualizar p a ∨ e ∈ entradas H p := by
  induction p generalizing a with
  | terminar b => intro e he; contradiction
  | consultar q f ih =>
    intro e he
    simp only [Intercalaciones.intercalar, ProgramaBytes.entradas, ProgramaBytes.traza_unir,
      ProgramaBytes.traza, List.map_append, List.map_cons, List.mem_append, List.mem_cons] at he
    simp only [extras, List.mem_append, entradas, List.mem_cons]
    rcases he with he | he | he
    · exact Or.inl (Or.inl he)
    · exact Or.inr (Or.inl he)
    · rcases ih _ _ e he with h | h
      · exact Or.inl (Or.inr h)
      · exact Or.inr (Or.inr h)

theorem intercalado {A : Type} (H : Entrada → Digest) (atacar : A → Peticion → ProgramaBytes.Programa A)
    (actualizar : A → Peticion → Digest → A) (p : Programa) (a : A) :
    (claves (ProgramaBytes.entradas H (Intercalaciones.intercalar atacar actualizar p a))).card ≤
      Intercalaciones.extras H atacar actualizar p a + (registro H p).card := by
  have hsub : claves (ProgramaBytes.entradas H (Intercalaciones.intercalar atacar actualizar p a)) ⊆
      claves (extras H atacar actualizar p a) ∪ registro H p := by
    unfold registro
    rw [← claves_append]
    exact claves_monotonas _ _ (by intro e he; exact List.mem_append.mpr (registro_intercalado H atacar actualizar p a e he))
  have h := (Finset.card_le_card hsub).trans (Finset.card_union_le _ _)
  have hc := cardinal_le_longitud (extras H atacar actualizar p a)
  rw [longitud_extras] at hc
  omega

theorem adversario {A : Type} (H : Entrada → Digest) (bits R : ℕ)
    (proponer : ProgramaBytes.Programa (List Octeto × A)) (atacar : A → Peticion → ProgramaBytes.Programa A)
    (actualizar : A → Peticion → Digest → A) :
    (claves (ProgramaBytes.entradas H (Nexus.Verificador.Adversario.ejecutar bits R proponer atacar actualizar))).card ≤
      Nexus.Verificador.Adversario.adversarias H bits R proponer atacar actualizar + 1 := by
  have hp := cardinal_le_longitud (ProgramaBytes.entradas H proponer)
  have hi := intercalado H atacar actualizar
    (Nexus.Verificador.Completo.desdeBytes bits R (ProgramaBytes.resultado H proponer).1)
    (ProgramaBytes.resultado H proponer).2
  have hv := bytes H bits R (ProgramaBytes.resultado H proponer).1
  simp only [Nexus.Verificador.Adversario.ejecutar, ProgramaBytes.entradas, ProgramaBytes.traza_unir,
    List.map_append, claves_append, Nexus.Verificador.Adversario.adversarias]
  have hcard := Finset.card_union_le (claves ((ProgramaBytes.traza H proponer).map Prod.fst))
    (claves ((ProgramaBytes.traza H (Intercalaciones.intercalar atacar actualizar
      (Nexus.Verificador.Completo.desdeBytes bits R (ProgramaBytes.resultado H proponer).1)
        (ProgramaBytes.resultado H proponer).2)).map Prod.fst))
  simp only [ProgramaBytes.entradas, List.length_map] at hp hi
  omega

end Nexus.Canal.ConteoPares
