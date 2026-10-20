module

public import Nexus.Canal.CongelacionPrograma
public import Nexus.ROM.HistoriaLocal
import Mathlib.Tactic

/-!
# Propuesta adaptativa de bytes antes de la verificación

El proponente puede consultar bytes arbitrarios y elegir después tanto el
certificado como su estado. La misma función y memoria se usan al leer y
verificar el candidato con intercalaciones posteriores. El presupuesto Q
cuenta todas las consultas adversarias de la ejecución, incluidas las previas.
No se demuestra aquí la solidez de todo el experimento ni el refinamiento Rust.
-/

public section
namespace Nexus.Verificador.Adversario

open Nexus.Bytes Nexus.Merkle Nexus.ROM
open ProgramaBytes EjecucionBytes
open Nexus.Canal (GramaticaTG2.Peticion)

@[expose] noncomputable def ejecutar {A : Type} (bits R : ℕ)
    (proponer : Programa (List Octeto × A)) (atacar : A → Nexus.Canal.GramaticaTG2.Peticion → Programa A)
    (actualizar : A → Nexus.Canal.GramaticaTG2.Peticion → Digest → A) : Programa Bool :=
  unir proponer (fun c => Nexus.Canal.Intercalaciones.intercalar atacar actualizar
    (Completo.desdeBytes bits R c.1) c.2)

@[expose] noncomputable def adversarias {A : Type} (H : Entrada → Digest) (bits R : ℕ)
    (proponer : Programa (List Octeto × A)) (atacar : A → Nexus.Canal.GramaticaTG2.Peticion → Programa A)
    (actualizar : A → Nexus.Canal.GramaticaTG2.Peticion → Digest → A) : ℕ :=
  (traza H proponer).length + Nexus.Canal.Intercalaciones.extras H atacar actualizar
    (Completo.desdeBytes bits R (resultado H proponer).1) (resultado H proponer).2

theorem resultado_con_bytes {A : Type} (H : Entrada → Digest) (bits R : ℕ)
    (proponer : Programa (List Octeto × A)) (atacar : A → Nexus.Canal.GramaticaTG2.Peticion → Programa A)
    (actualizar : A → Nexus.Canal.GramaticaTG2.Peticion → Digest → A) :
    resultado H (ejecutar bits R proponer atacar actualizar) =
      ProgramaCompartido.resultado (RegistroPrograma.tabla H)
        (Completo.desdeBytes bits R (resultado H proponer).1) := by
  rw [ejecutar, resultado_unir, Nexus.Canal.Intercalaciones.resultado_intercalado]

theorem aceptacion_certificado_elegido {A : Type} (H : Entrada → Digest) (bits R : ℕ)
    (proponer : Programa (List Octeto × A)) (atacar : A → Nexus.Canal.GramaticaTG2.Peticion → Programa A)
    (actualizar : A → Nexus.Canal.GramaticaTG2.Peticion → Digest → A)
    (ha : resultado H (ejecutar bits R proponer atacar actualizar) = true) :
    ∃ c, Lectura.exacto codecCertificado.leer (resultado H proponer).1 = some c ∧
      Forma (Nat.log2 c.enunciado.pasos) bits c := by
  rw [resultado_con_bytes] at ha
  exact Completo.bytes_aceptados H bits R _ ha

theorem costo_total {A : Type} (H : Entrada → Digest) (bits R : ℕ)
    (proponer : Programa (List Octeto × A)) (atacar : A → Nexus.Canal.GramaticaTG2.Peticion → Programa A)
    (actualizar : A → Nexus.Canal.GramaticaTG2.Peticion → Digest → A) :
    (traza H (ejecutar bits R proponer atacar actualizar)).length = adversarias H bits R proponer atacar actualizar +
      (RegistroPrograma.entradas H (Completo.desdeBytes bits R (resultado H proponer).1)).length := by
  rw [ejecutar, traza_unir, List.length_append, Nexus.Canal.Intercalaciones.costo_intercalado]
  unfold adversarias
  omega

theorem presupuesto_condicional {A : Type} (H : Entrada → Digest) (bits R Q V : ℕ)
    (proponer : Programa (List Octeto × A)) (atacar : A → Nexus.Canal.GramaticaTG2.Peticion → Programa A)
    (actualizar : A → Nexus.Canal.GramaticaTG2.Peticion → Digest → A)
    (hq : adversarias H bits R proponer atacar actualizar ≤ Q)
    (hv : Nexus.Canal.ProgramaTG2.Acotado (Completo.desdeBytes bits R (resultado H proponer).1) V) :
    (traza H (ejecutar bits R proponer atacar actualizar)).length ≤ Q + V := by
  rw [costo_total]
  have hc : (RegistroPrograma.entradas H (Completo.desdeBytes bits R (resultado H proponer).1)).length ≤ V := by
    rw [RegistroPrograma.entradas_cuentan_respuestas]
    exact hv (RegistroPrograma.tabla H)
  omega

theorem registro_proponente {A : Type} (H : Entrada → Digest) (bits R : ℕ)
    (proponer : Programa (List Octeto × A)) (atacar : A → Nexus.Canal.GramaticaTG2.Peticion → Programa A)
    (actualizar : A → Nexus.Canal.GramaticaTG2.Peticion → Digest → A) :
    List.Sublist (entradas H proponer) (entradas H (ejecutar bits R proponer atacar actualizar)) := by
  simp only [ejecutar, entradas, traza_unir, List.map_append]
  exact List.sublist_append_left _ _

theorem registro_verificador {A : Type} (H : Entrada → Digest) (bits R : ℕ)
    (proponer : Programa (List Octeto × A)) (atacar : A → Nexus.Canal.GramaticaTG2.Peticion → Programa A)
    (actualizar : A → Nexus.Canal.GramaticaTG2.Peticion → Digest → A) :
    List.Sublist (RegistroPrograma.entradas H (Completo.desdeBytes bits R (resultado H proponer).1))
      (entradas H (ejecutar bits R proponer atacar actualizar)) := by
  simp only [ejecutar, entradas, traza_unir, List.map_append]
  exact (Nexus.Canal.Intercalaciones.registro_intercalado H atacar actualizar _ _).trans
    (List.sublist_append_right _ _)

theorem tabla_efectiva_compatible {A : Type} (H : Entrada → Digest) (B bits R : ℕ)
    (proponer : Programa (List Octeto × A)) (atacar : A → Nexus.Canal.GramaticaTG2.Peticion → Programa A)
    (actualizar : A → Nexus.Canal.GramaticaTG2.Peticion → Digest → A) :
    Compatibles H (final H (inicial B) (ejecutar bits R proponer atacar actualizar)).tabla :=
  final_compatible H _ _ (by intro e d hd; contradiction)

theorem historia_efectiva_compatible {A : Type} (H : Entrada → Digest) (bits R : ℕ)
    (proponer : Programa (List Octeto × A)) (atacar : A → Nexus.Canal.GramaticaTG2.Peticion → Programa A)
    (actualizar : A → Nexus.Canal.GramaticaTG2.Peticion → Digest → A) :
    HistoriaCausal.Compatible (HistoriaLocal.estrategia (ejecutar bits R proponer atacar actualizar))
      (HistoriaLocal.respuestas H (ejecutar bits R proponer atacar actualizar)) H :=
  HistoriaLocal.historia_compatible H _

end Nexus.Verificador.Adversario
