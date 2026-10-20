module

public import Nexus.Verificador.SoporteConsulta
public import Nexus.Verificador.Completo
public import Nexus.Canal.RegistroCompleto
import Mathlib.Tactic

/-!
# La aceptación completa produce todos los hechos de registro

La muestra y los desafíos se recuperan del canal ejecutado. Se enumeran
todas las aperturas de las cuarenta consultas y se prueba su soporte en el
programa completo, sin recibir como premisas listas de registro arbitrarias.
-/

public section
namespace Nexus.Verificador.SoporteCompleto

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open ProgramaCompartido RegistroPrograma RegistroRaices

@[expose] def vista (H : Entrada → Digest) (k bits : ℕ) (c : Certificado) : RegistroCompleto.Vista :=
  RegistroCompleto.evaluar H k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz
    c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final

@[expose] noncomputable def ultimas (H : Entrada → Digest) (k bits : ℕ) (c : Certificado)
    (S : List (Fin (4 * 2 ^ k))) : Programa := Completo.consultas k c.enunciado c.prueba
      (vista H k bits c).alfas.2 ((vista H k bits c).traza.2.map (beta H))
      ((vista H k bits c).composicion.2.map (beta H)) c.prueba.consultas (S.map Fin.val)

structure Testigo (H : Entrada → Digest) (k bits R : ℕ) (c : Certificado) where
  forma : Forma k bits c
  muestra : List (Fin (4 * 2 ^ k))
  sinDuplicados : muestra.Nodup
  cantidad : muestra.length = 40
  aceptacion : resultado (tabla H) (ultimas H k bits c muestra) = true
  soporte : ∀ e ∈ entradas H (ultimas H k bits c muestra), e ∈ entradas H (Completo.verificar k bits R c)

theorem del_programa (H : Entrada → Digest) (k bits R : ℕ) (c : Certificado)
    (ha : resultado (tabla H) (Completo.verificar k bits R c) = true) : Nonempty (Testigo H k bits R c) := by
  have hf := (Completo.aceptacion_verificador H k bits R c ha).1
  rw [Completo.verificar, ite_eq_left hf] at ha
  obtain ⟨S, hS, hlen, hres, hlog⟩ := RegistroCompleto.aceptacion_con_soporte H k bits R
    c.enunciado.inicio c.enunciado.salida c.prueba.raiz c.prueba.traza.raices c.prueba.composicion.raices
    c.prueba.traza.final c.prueba.composicion.final (Completo.nonce c.prueba) (Completo.trabajo bits)
    (fun a bt bc S => Completo.consultas k c.enunciado c.prueba a bt bc c.prueba.consultas (S.map Fin.val)) ha
  refine ⟨⟨hf, S, hS, hlen, hres, ?_⟩⟩
  intro e he
  rw [Completo.verificar, ite_eq_left hf]
  exact hlog e he

theorem prefijo_registrado {H : Entrada → Digest} {k bits R : ℕ} {c : Certificado}
    (t : Testigo H k bits R c) : ∀ e ∈ RegistroCompleto.prefijo H k bits c.enunciado.inicio c.enunciado.salida
      c.prueba.raiz c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final,
        e ∈ entradas H (Completo.verificar k bits R c) := by
  intro e he
  rw [Completo.verificar, ite_eq_left t.forma, RegistroCompleto.registro_canal]
  exact List.mem_append_left _ he

theorem base_registrada {H : Entrada → Digest} {k bits R : ℕ} {c : Certificado}
    (t : Testigo H k bits R c) : Registrado H (entradas H (Completo.verificar k bits R c)) (vista H k bits c).base :=
  registrado_monotono H _ _ (prefijo_registrado t) _ (RegistroCompleto.base_registrada H k bits
    c.enunciado.inicio c.enunciado.salida c.prueba.raiz c.prueba.traza.raices c.prueba.composicion.raices
    c.prueba.traza.final c.prueba.composicion.final)

theorem traza_registrada {H : Entrada → Digest} {k bits R : ℕ} {c : Certificado}
    (t : Testigo H k bits R c) (e : Evento) (he : e ∈ (vista H k bits c).traza.2) :
    Registrado H (entradas H (Completo.verificar k bits R c)) e :=
  registrado_monotono H _ _ (prefijo_registrado t) e (RegistroCompleto.traza_registrada H k bits
    c.enunciado.inicio c.enunciado.salida c.prueba.raiz c.prueba.traza.raices c.prueba.composicion.raices
    c.prueba.traza.final c.prueba.composicion.final e he)

theorem composicion_registrada {H : Entrada → Digest} {k bits R : ℕ} {c : Certificado}
    (t : Testigo H k bits R c) (e : Evento) (he : e ∈ (vista H k bits c).composicion.2) :
    Registrado H (entradas H (Completo.verificar k bits R c)) e :=
  registrado_monotono H _ _ (prefijo_registrado t) e (RegistroCompleto.composicion_registrada H k bits
    c.enunciado.inicio c.enunciado.salida c.prueba.raiz c.prueba.traza.raices c.prueba.composicion.raices
    c.prueba.traza.final c.prueba.composicion.final e he)

@[expose] noncomputable def aperturasDe (k : ℕ) (p : Prueba) (bt bc : List Fp2) :
    List Consulta → List ℕ → List AperturasPrograma.Apertura
  | q :: qs, i :: is => SoporteConsulta.aperturas k i p bt bc q ++ aperturasDe k p bt bc qs is
  | _, _ => []

theorem consultas_soporte (H : Entrada → Digest) (k : ℕ) (e : Enunciado) (p : Prueba)
    (alfas bt bc : List Fp2) (qs : List Consulta) (is : List ℕ)
    (ha : resultado (tabla H) (Completo.consultas k e p alfas bt bc qs is) = true) :
    ∀ a ∈ aperturasDe k p bt bc qs is, AperturasPrograma.Valida H a ∧
      AperturasPrograma.Registrada H (entradas H (Completo.consultas k e p alfas bt bc qs is)) a := by
  induction qs generalizing is with
  | nil => cases is <;> intro a hm <;> contradiction
  | cons q qs ih => cases is with
    | nil => intro a hm; contradiction
    | cons i is =>
      obtain ⟨hq, hr⟩ := aceptacion_ambos _ _ _ ha
      intro a hm
      rcases List.mem_append.mp hm with hm | hm
      · have hh := SoporteConsulta.todas_con_soporte H k i e p alfas bt bc q hq a hm
        exact ⟨hh.1, AperturasPrograma.registrada_monotona H _ _
          (fun x hx => (primero_registrado H _ _).subset hx) a hh.2⟩
      · have hh := ih _ hr a hm
        exact ⟨hh.1, AperturasPrograma.registrada_monotona H _ _ (segundo_registrado H _ _ hq) a hh.2⟩

theorem consultas_indices (H : Entrada → Digest) (k : ℕ) (e : Enunciado) (p : Prueba)
    (alfas bt bc : List Fp2) (qs : List Consulta) (is : List ℕ)
    (ha : resultado (tabla H) (Completo.consultas k e p alfas bt bc qs is) = true)
    (hi : ∀ i ∈ is, i < 2 ^ (k + 2)) (a : AperturasPrograma.Apertura)
    (hm : a ∈ aperturasDe k p bt bc qs is) : a.indice < 2 ^ a.altura := by
  induction qs generalizing is with
  | nil => cases is <;> contradiction
  | cons q qs ih => cases is with
    | nil => contradiction
    | cons i is =>
      obtain ⟨hq, hr⟩ := aceptacion_ambos _ _ _ ha
      rcases List.mem_append.mp hm with hm | hm
      · exact SoporteConsulta.indices_acotados H k i (hi i List.mem_cons_self) e p alfas bt bc q hq a hm
      · exact ih _ hr (fun j hj => hi j (List.mem_cons_of_mem _ hj)) hm

theorem consultas_origenes (k : ℕ) (p : Prueba) (bt bc : List Fp2) (qs : List Consulta) (is : List ℕ)
    (a : AperturasPrograma.Apertura) (hm : a ∈ aperturasDe k p bt bc qs is) : SoporteConsulta.Origen k p a := by
  induction qs generalizing is with
  | nil => cases is <;> contradiction
  | cons q qs ih => cases is with
    | nil => contradiction
    | cons i is =>
      rcases List.mem_append.mp hm with hm | hm
      · exact SoporteConsulta.origenes k i p bt bc q a hm
      · exact ih _ hm

theorem consultas_cantidad (H : Entrada → Digest) (k : ℕ) (e : Enunciado) (p : Prueba)
    (alfas bt bc : List Fp2) (qs : List Consulta) (is : List ℕ)
    (ha : resultado (tabla H) (Completo.consultas k e p alfas bt bc qs is) = true) :
    (aperturasDe k p bt bc qs is).length = qs.length * (6 + 2 * k + 2 * (k + 1)) := by
  induction qs generalizing is with
  | nil => cases is <;> simp only [aperturasDe, List.length_nil, Nat.zero_mul]
  | cons q qs ih => cases is with
    | nil => contradiction
    | cons i is =>
      obtain ⟨hq, hr⟩ := aceptacion_ambos _ _ _ ha
      simp only [aperturasDe, List.length_append, SoporteConsulta.cantidad H k i e p alfas bt bc q hq,
        ih is hr, List.length_cons, Nat.add_mul, Nat.one_mul]
      omega

@[expose] noncomputable def aperturas {H : Entrada → Digest} {k bits R : ℕ} {c : Certificado}
    (t : Testigo H k bits R c) : List AperturasPrograma.Apertura := aperturasDe k c.prueba
      ((vista H k bits c).traza.2.map (beta H)) ((vista H k bits c).composicion.2.map (beta H))
      c.prueba.consultas (t.muestra.map Fin.val)

theorem soporte_total {H : Entrada → Digest} {k bits R : ℕ} {c : Certificado}
    (t : Testigo H k bits R c) (a : AperturasPrograma.Apertura) (hm : a ∈ aperturas t) :
    AperturasPrograma.Valida H a ∧ AperturasPrograma.Registrada H (entradas H (Completo.verificar k bits R c)) a := by
  have hh := consultas_soporte H k c.enunciado c.prueba _ _ _ _ _ t.aceptacion a hm
  exact ⟨hh.1, AperturasPrograma.registrada_monotona H _ _ t.soporte a hh.2⟩

theorem rango_total {H : Entrada → Digest} {k bits R : ℕ} {c : Certificado}
    (t : Testigo H k bits R c) (a : AperturasPrograma.Apertura) (hm : a ∈ aperturas t) :
    a.indice < 2 ^ a.altura := by
  apply consultas_indices H k c.enunciado c.prueba _ _ _ _ _ t.aceptacion _ a hm
  intro i hi
  obtain ⟨j, _, rfl⟩ := List.mem_map.mp hi
  have hp : 4 * 2 ^ k = 2 ^ (k + 2) := by rw [pow_add]; norm_num; ring
  simpa only [hp] using j.isLt

theorem origen_total {H : Entrada → Digest} {k bits R : ℕ} {c : Certificado}
    (t : Testigo H k bits R c) (a : AperturasPrograma.Apertura) (hm : a ∈ aperturas t) :
    SoporteConsulta.Origen k c.prueba a := consultas_origenes k c.prueba _ _ _ _ a hm

theorem cantidad_total {H : Entrada → Digest} {k bits R : ℕ} {c : Certificado}
    (t : Testigo H k bits R c) : (aperturas t).length = 40 * (6 + 2 * k + 2 * (k + 1)) := by
  have h := consultas_cantidad H k c.enunciado c.prueba _ _ _ _ _ t.aceptacion
  have hlen := (forma_implica_cantidades k bits c t.forma).2.2
  simpa only [aperturas, hlen] using h

end Nexus.Verificador.SoporteCompleto
