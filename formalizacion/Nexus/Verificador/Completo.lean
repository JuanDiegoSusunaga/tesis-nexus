module

public import Nexus.Verificador.Consulta
public import Nexus.Canal.DesafiosPrograma
import Mathlib.Tactic

/-!
# Ruta matemática completa del certificado TG2 v1

Lectura estricta, forma, canal con desafíos, trabajo, índices ordenados y
cuarenta consultas se componen sobre una sola función hash. El presupuesto
se demuestra sobre este programa, incluidos sus rechazos. El corte R no
existe en Rust: limita analíticamente las extracciones del selector.
No se verifica aquí el compilador, bincode ni el refinamiento universal de
las operaciones de máquina; tampoco la solidez probabilística global.
-/

public section
namespace Nexus.Verificador.Completo

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks
open Nexus.ROM.ProgramaCompartido Nexus.ROM.RegistroPrograma
open Nexus.Canal.ProgramaTG2 (Acotado)

@[expose] def ceros : List Octeto → ℕ
  | [] => 0
  | b :: bs => if b.val = 0 then 8 + ceros bs else 7 - Nat.log2 b.val

@[expose] def trabajo (bits : ℕ) (d : Digest) : Bool := decide (bits ≤ ceros d.val)

@[expose] def nonce (p : Prueba) : Nexus.Canal.Nonce :=
  ⟨p.nonce % 2 ^ 64, Nat.mod_lt _ (by positivity)⟩

@[expose] noncomputable def consultas (k : ℕ) (e : Enunciado) (p : Prueba)
    (a bt bc : List Fp2) : List Consulta → List ℕ → Programa
  | [], [] => .terminar true
  | q :: qs, i :: is => encadenar (ProgramaConsulta.verificar k i e p a bt bc q)
      (consultas k e p a bt bc qs is)
  | _, _ => .terminar false

@[expose] noncomputable def Condiciones (H : List Octeto → Digest) (k : ℕ) (e : Enunciado)
    (p : Prueba) (a bt bc : List Fp2) : List Consulta → List ℕ → Prop
  | [], [] => True
  | q :: qs, i :: is => resultado (tabla H) (ProgramaConsulta.verificar k i e p a bt bc q) = true ∧
      Condiciones H k e p a bt bc qs is
  | _, _ => False

@[expose] noncomputable def verificar (k bits R : ℕ) (c : Certificado) : Programa := by
  classical
  exact if Forma k bits c then Nexus.Canal.DesafiosPrograma.ejecutar k bits R
    c.enunciado.inicio c.enunciado.salida c.prueba.raiz c.prueba.traza.raices c.prueba.composicion.raices
    c.prueba.traza.final c.prueba.composicion.final (nonce c.prueba) (trabajo bits)
    (fun a bt bc S => consultas k c.enunciado c.prueba a bt bc c.prueba.consultas (S.map Fin.val))
  else .terminar false

@[expose] noncomputable def desdeBytes (bits R : ℕ) (bs : List Octeto) : Programa :=
  match Lectura.exacto codecCertificado.leer bs with
  | none => .terminar false
  | some c => verificar (Nat.log2 c.enunciado.pasos) bits R c

theorem ceros_acotados (bs : List Octeto) : ceros bs ≤ 8 * bs.length := by
  induction bs with
  | nil => rfl
  | cons b bs ih =>
    simp only [ceros, List.length_cons]
    split_ifs <;> omega

theorem trabajo_imposible (bits : ℕ) (d : Digest) (h : 256 < bits) : trabajo bits d = false := by
  have hc := ceros_acotados d.val
  rw [d.property] at hc
  simp only [trabajo, decide_eq_false_iff_not]
  omega

theorem nonce_sin_alias (k bits : ℕ) (c : Certificado) (h : Forma k bits c) :
    (nonce c.prueba).val = c.prueba.nonce := by
  apply Nat.mod_eq_of_lt
  have hn := h.2.2.2.2.1
  norm_num at hn ⊢
  exact hn

theorem consultas_aceptadas (H : List Octeto → Digest) (k : ℕ) (e : Enunciado) (p : Prueba)
    (a bt bc : List Fp2) (qs : List Consulta) (is : List ℕ) :
    resultado (tabla H) (consultas k e p a bt bc qs is) = true ↔ Condiciones H k e p a bt bc qs is := by
  induction qs generalizing is with
  | nil => cases is <;> simp [consultas, Condiciones, resultado]
  | cons q qs ih => cases is with
    | nil => simp [consultas, Condiciones, resultado]
    | cons i is => simp only [consultas, resultado_encadenado, Bool.and_eq_true, ih, Condiciones]

theorem condiciones_longitudes (H : List Octeto → Digest) (k : ℕ) (e : Enunciado) (p : Prueba)
    (a bt bc : List Fp2) (qs : List Consulta) (is : List ℕ)
    (h : Condiciones H k e p a bt bc qs is) : qs.length = is.length := by
  induction qs generalizing is with
  | nil => cases is <;> simp_all [Condiciones]
  | cons q qs ih => cases is with
    | nil => contradiction
    | cons i is => simpa only [List.length_cons] using congrArg Nat.succ (ih is h.2)

theorem presupuesto_consultas (k : ℕ) (e : Enunciado) (p : Prueba) (a bt bc : List Fp2)
    (qs : List Consulta) (is : List ℕ) :
    Acotado (consultas k e p a bt bc qs is) (qs.length * ProgramaConsulta.presupuesto k) := by
  induction qs generalizing is with
  | nil => cases is <;> intro H <;> exact Nat.zero_le _
  | cons q qs ih => cases is with
    | nil => intro H; exact Nat.zero_le _
    | cons i is =>
      have hb := presupuesto_encadenado _ _ _ _
        (ProgramaConsulta.presupuesto_consulta k i e p a bt bc q) (ih is)
      simpa only [consultas, List.length_cons, Nat.add_mul, Nat.one_mul, Nat.add_comm] using hb

theorem presupuesto_concuerda (k R : ℕ) :
    13 + 2 * (k + (k + 1)) + R + 40 * ProgramaConsulta.presupuesto k =
      Nexus.ROM.Presupuestos.verificadorPerfil k R := by
  unfold ProgramaConsulta.presupuesto Nexus.ROM.Presupuestos.verificadorPerfil
    Nexus.ROM.Presupuestos.caminosPerfil Nexus.ROM.Presupuestos.hojasPerfil
    Nexus.ROM.Presupuestos.canalPerfil Nexus.Complejidad.Comunicacion.sumaTG2
  ring

theorem presupuesto_verificador (k bits R : ℕ) (c : Certificado) :
    Acotado (verificar k bits R c) (Nexus.ROM.Presupuestos.verificadorPerfil k R) := by
  classical
  by_cases hf : Forma k bits c
  · rw [verificar, ite_eq_left hf]
    have h := Nexus.Canal.DesafiosPrograma.presupuesto_canal k bits R
      (c.prueba.consultas.length * ProgramaConsulta.presupuesto k)
      c.enunciado.inicio c.enunciado.salida c.prueba.raiz c.prueba.traza.raices c.prueba.composicion.raices
      c.prueba.traza.final c.prueba.composicion.final (nonce c.prueba) (trabajo bits)
      (fun a bt bc S => consultas k c.enunciado c.prueba a bt bc c.prueba.consultas (S.map Fin.val))
      (fun a bt bc S => presupuesto_consultas k c.enunciado c.prueba a bt bc c.prueba.consultas (S.map Fin.val))
    obtain ⟨ht, hc, hq⟩ := forma_implica_cantidades k bits c hf
    simpa only [ht, hc, hq, presupuesto_concuerda] using h
  · rw [verificar, ite_eq_right hf]; intro H; exact Nat.zero_le _

theorem rechazo_previo_sin_consultas (k bits R : ℕ) (c : Certificado) (h : ¬ Forma k bits c) :
    verificar k bits R c = .terminar false := by classical exact ite_eq_right h

theorem aceptacion_verificador (H : List Octeto → Digest) (k bits R : ℕ) (c : Certificado)
    (h : resultado (tabla H) (verificar k bits R c) = true) :
    Forma k bits c ∧ ∃ (a bt bc : List Fp2) (S : List (Fin (4 * 2 ^ k))),
      a.length = 3 ∧ bt.length = k ∧ bc.length = k + 1 ∧
      S.Nodup ∧ S.length = 40 ∧ Condiciones H k c.enunciado c.prueba a bt bc c.prueba.consultas
        (S.map (fun i : Fin (4 * 2 ^ k) => i.val)) := by
  classical
  by_cases hf : Forma k bits c
  · refine ⟨hf, ?_⟩
    rw [verificar, ite_eq_left hf] at h
    obtain ⟨a, bt, bc, S, ha, hbt, hbc, hS, hlen, hfin⟩ :=
      Nexus.Canal.DesafiosPrograma.aceptacion_entrega k bits R
        c.enunciado.inicio c.enunciado.salida c.prueba.raiz c.prueba.traza.raices c.prueba.composicion.raices
        c.prueba.traza.final c.prueba.composicion.final (nonce c.prueba) (trabajo bits) _ (tabla H) h
    obtain ⟨ht, hc, _⟩ := forma_implica_cantidades k bits c hf
    exact ⟨a, bt, bc, S, ha, ht ▸ hbt, hc ▸ hbc, hS, hlen, (consultas_aceptadas _ _ _ _ _ _ _ _ _).mp hfin⟩
  · rw [rechazo_previo_sin_consultas k bits R c hf] at h
    contradiction

theorem registro_limitado (H : List Octeto → Digest) (k bits R : ℕ) (c : Certificado) :
    (entradas H (verificar k bits R c)).length ≤ Nexus.ROM.Presupuestos.verificadorPerfil k R := by
  rw [entradas_cuentan_respuestas]
  exact presupuesto_verificador k bits R c (tabla H)

theorem lectura_al_programa (bits R : ℕ) (c : Certificado) (h : codecCertificado.dominio c) :
    desdeBytes bits R (codecCertificado.codificar c) = verificar (Nat.log2 c.enunciado.pasos) bits R c := by
  rw [desdeBytes, lectura_exacta_certificado c h]

theorem parser_rechaza_sin_hash (bits R : ℕ) (bs : List Octeto)
    (h : Lectura.exacto codecCertificado.leer bs = none) : desdeBytes bits R bs = .terminar false := by
  rw [desdeBytes, h]

theorem sufijo_rechaza_antes_del_hash (bits R : ℕ) (c : Certificado) (h : codecCertificado.dominio c)
    (resto : List Octeto) (hr : resto ≠ []) :
    desdeBytes bits R (codecCertificado.codificar c ++ resto) = .terminar false :=
  parser_rechaza_sin_hash bits R _ (sufijo_en_envoltura_estricta c h resto hr)

theorem bytes_aceptados (H : List Octeto → Digest) (bits R : ℕ) (bs : List Octeto)
    (h : resultado (tabla H) (desdeBytes bits R bs) = true) :
    ∃ c, Lectura.exacto codecCertificado.leer bs = some c ∧
      Forma (Nat.log2 c.enunciado.pasos) bits c := by
  cases he : Lectura.exacto codecCertificado.leer bs with
  | none => rw [parser_rechaza_sin_hash bits R bs he] at h; contradiction
  | some c =>
    refine ⟨c, rfl, ?_⟩
    rw [desdeBytes, he] at h
    exact (aceptacion_verificador H _ bits R c h).1

end Nexus.Verificador.Completo
