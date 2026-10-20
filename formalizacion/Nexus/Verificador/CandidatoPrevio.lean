module

public import Nexus.Canal.SoporteCandidato
public import Nexus.Canal.ReconstruccionSelector
public import Nexus.Verificador.FamiliasAceptadas
import Mathlib.Tactic

/-!
# Candidato efectivo recuperado antes del primer índice

La aceptación del verificador proporciona la cadena y la consulta I sin
recibirlas como premisas de soporte. La propuesta adaptativa y las consultas
intercaladas pueden haber expuesto esa dirección antes del verificador.
El registro recupera la cadena de bytes y congela sus vectores de raíces;
falta derivar de ella las políticas GT/GC y las inclusiones de solidez.
-/

public section
namespace Nexus.Verificador.CandidatoPrevio

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open ProgramaCompartido RegistroPrograma TrayectoTG2 ReconstruccionSelector

set_option maxRecDepth 4096
set_option maxHeartbeats 800000
attribute [local instance] Classical.propDecidable

abbrev cadenaCert (H : Entrada → Digest) (k bits : ℕ) (c : Certificado) : List Entrada :=
  cadena H k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz c.prueba.traza.raices
    c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final (Completo.nonce c.prueba)

abbrev semillaCert (H : Entrada → Digest) (k bits : ℕ) (c : Certificado) : Digest :=
  semilla H k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz c.prueba.traza.raices
    c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final (Completo.nonce c.prueba)

abbrev CorteSelector {A : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa A)
    (k bits : ℕ) (c : Certificado) := CorteConsulta (inicial B) (EjecucionBytes.final H (inicial B) p)
      (entradaReto (semillaCert H k bits c) .indice) (H (entradaReto (semillaCert H k bits c) .indice))

structure Registro {A : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa A)
    (k bits : ℕ) (c : Certificado) where
  corte : CorteSelector H B p k bits c
  disponible : ∀ e ∈ cadenaCert H k bits c, buscar corte.antes.tabla e = some (H e)
  recuperada : candidato corte.antes.tabla (semillaCert H k bits c) = cadenaCert H k bits c
  raices : ∀ (estado raiz : Digest) (tag : Octeto),
    entradaAbsorcion estado tag raiz.val ∈ cadenaCert H k bits c → raiz ∈ marcasEstado corte.antes
  vectores : ∀ (estado raiz : Digest) (tag : Octeto),
    entradaAbsorcion estado tag raiz.val ∈ cadenaCert H k bits c → ∀ (defecto : Digest) (altura : ℕ),
    vectorExtraido formatoBytes (funcionTabla defecto corte.antes.tabla)
      (corte.antes.tabla.map Prod.fst) altura raiz =
    vectorExtraido formatoBytes (funcionTabla defecto (EjecucionBytes.final H (inicial B) p).tabla)
      ((EjecucionBytes.final H (inicial B) p).tabla.map Prod.fst) altura raiz

theorem soporte_verificador (H : Entrada → Digest) (k bits R : ℕ) (c : Certificado)
    (ha : resultado (tabla H) (Completo.verificar k bits R c) = true) :
    (∀ e ∈ cadenaCert H k bits c, e ∈ entradas H (Completo.verificar k bits R c)) ∧
      entradaReto (semillaCert H k bits c) .indice ∈ entradas H (Completo.verificar k bits R c) := by
  have hf := (Completo.aceptacion_verificador H k bits R c ha).1
  rw [Completo.verificar, ite_eq_left hf] at ha ⊢
  exact ⟨SoporteCandidato.cadena_registrada H k bits R c.enunciado.inicio c.enunciado.salida c.prueba.raiz
    c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final
    (Completo.nonce c.prueba) (Completo.trabajo bits) _ ha,
    SoporteCandidato.indice_registrado H k bits R c.enunciado.inicio c.enunciado.salida c.prueba.raiz
    c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final
    (Completo.nonce c.prueba) (Completo.trabajo bits) _ ha⟩

theorem construir {A : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (k bits R : ℕ) (c : Certificado)
    (ha : resultado (tabla H) (Completo.verificar k bits R c) = true)
    (hlog : ∀ e ∈ entradas H (Completo.verificar k bits R c), e ∈ ProgramaBytes.entradas H p) :
    Nonempty (Registro H B p k bits c) := by
  have hc0 : Compatibles H (inicial B).tabla := by intro e d hd; contradiction
  have recorrido := EjecucionBytes.recorrido_desde_programa H (inicial B) p hc0 hs
  have hc := EjecucionBytes.final_compatible H (inicial B) p hc0
  obtain ⟨hcadena, hindice⟩ := soporte_verificador H k bits R c ha
  have hq (e : Entrada) (he : e ∈ cadenaCert H k bits c) :
      buscar (EjecucionBytes.final H (inicial B) p).tabla e = some (H e) :=
    EjecucionBytes.consulta_en_tabla H (inicial B) p hc0 e (hlog e (hcadena e he))
  have hi := EjecucionBytes.consulta_en_tabla H (inicial B) p hc0 _ (hlog _ hindice)
  obtain ⟨corte⟩ := origen_desde_vacio recorrido _ _ hi
  have hf := (Completo.aceptacion_verificador H k bits R c ha).1
  have hlen := forma_implica_cantidades k bits c hf
  have hk : k ≤ 29 := by have hh := hf.1.2.1; omega
  refine ⟨⟨corte, ?_, ?_, ?_, ?_⟩⟩
  · exact cadena_antes_corte H recorrido
      (camino_canal H k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz c.prueba.traza.raices
        c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final (Completo.nonce c.prueba))
      hq corte (estado_reto_en_ventanas _ _)
  · exact candidato_canal H recorrido hc k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz
      c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final
      (Completo.nonce c.prueba) hlen.1 hlen.2.1 hk hq _ corte
  · exact raices_antes_selector H recorrido k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz
      c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final
      (Completo.nonce c.prueba) hq _ corte
  · exact vector_antes_selector H recorrido k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz
      c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final
      (Completo.nonce c.prueba) hq _ corte

theorem desde_adversario {A : Type} (H : Entrada → Digest) (B bits R : ℕ)
    (proponer : ProgramaBytes.Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → ProgramaBytes.Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (hs : EjecucionBytes.SinBad H (inicial B) (Adversario.ejecutar bits R proponer atacar actualizar))
    (ha : ProgramaBytes.resultado H (Adversario.ejecutar bits R proponer atacar actualizar) = true) :
    ∃ c, Lectura.exacto codecCertificado.leer (ProgramaBytes.resultado H proponer).1 = some c ∧
      Nonempty (Registro H B (Adversario.ejecutar bits R proponer atacar actualizar)
        (Nat.log2 c.enunciado.pasos) bits c) := by
  rw [Adversario.resultado_con_bytes] at ha
  cases hp : Lectura.exacto codecCertificado.leer (ProgramaBytes.resultado H proponer).1 with
  | none => rw [Completo.desdeBytes, hp] at ha; contradiction
  | some c =>
    refine ⟨c, rfl, ?_⟩
    rw [Completo.desdeBytes, hp] at ha
    apply construir H B _ hs (Nat.log2 c.enunciado.pasos) bits R c ha
    intro e he
    apply (Adversario.registro_verificador H bits R proponer atacar actualizar).subset
    simpa only [Completo.desdeBytes, hp] using he

theorem tabla_independiente {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k j bits otrosBits : ℕ} {c d : Certificado}
    (f : Registro H B p k bits c) (g : Registro H B p j otrosBits d)
    (hs : semillaCert H k bits c = semillaCert H j otrosBits d) :
    f.corte.antes.tabla = g.corte.antes.tabla := by
  rw [PrefijoCorte.tabla_antes f.corte, PrefijoCorte.tabla_antes g.corte, hs]

theorem misma_semilla_misma_cadena {A : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa A} {k j bits otrosBits : ℕ} {c d : Certificado}
    (f : Registro H B p k bits c) (g : Registro H B p j otrosBits d)
    (hs : semillaCert H k bits c = semillaCert H j otrosBits d) :
    cadenaCert H k bits c = cadenaCert H j otrosBits d := by
  rw [← f.recuperada, ← g.recuperada, tabla_independiente f g hs, hs]

end Nexus.Verificador.CandidatoPrevio
