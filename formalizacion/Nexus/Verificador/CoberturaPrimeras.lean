module

public import Nexus.Verificador.PoliticasPrefijo
public import Nexus.Verificador.MuestraBuena
import Mathlib.Tactic

/-!
# Cobertura de la aceptación por una primera exposición efectiva

La muestra aceptada se registra en las políticas del prefijo de llamadas
anterior a su primer I. Ese I puede pertenecer a una preconsulta deliberada
del adversario. La ausencia de excepciones solo se usa determinísticamente.
-/

public section
namespace Nexus.Verificador.CoberturaPrimeras

open Nexus.Bytes Nexus.Merkle Nexus.ROM Nexus.Canal
open ProgramaBytes CandidatoPrevio PoliticasPrefijo

variable {A : Type}
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem registro_cubierto (H : Entrada → Digest) (B : ℕ) (p : Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (k bits R : ℕ) (c : Certificado)
    (r : Registro H B p k bits c) (defecto : Digest)
    (hb : let T := ROM.SelectorAcoplado.salida (k + 2) 40 (CintaSelector.cinta H R (semillaCert H k bits c))
      T.card = 40 ∧ T ⊆ ConjuntosPrevios.GT (k + 2) defecto (semillaCert H k bits c) r.corte.antes.tabla ∩
        ConjuntosPrevios.GC (k + 2) defecto (semillaCert H k bits c) r.corte.antes.tabla) :
    ∃ n, n < (traza H p).length ∧ Inicia H p defecto n ∧ Omite H p defecto n R (k + 2) := by
  obtain ⟨n, hn, hstart, hseed, ht⟩ := registro_previsible H B p hs k bits c r defecto
  refine ⟨n, hn, hstart, ?_⟩
  simpa only [Omite, GT, GC, hseed, ← ht] using hb

theorem cobertura_certificado (H : Entrada → Digest) (B : ℕ) (p : Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (k bits R : ℕ) (c : Certificado)
    (ha : ProgramaCompartido.resultado (RegistroPrograma.tabla H) (Completo.verificar k bits R c) = true)
    (hlog : ∀ e ∈ RegistroPrograma.entradas H (Completo.verificar k bits R c), e ∈ entradas H p)
    (defecto : Digest) :
    ∃ n, n < (traza H p).length ∧ Inicia H p defecto n ∧ Omite H p defecto n R (k + 2) := by
  obtain ⟨r, hb⟩ := MuestraBuena.omision_efectiva H B p hs k bits R c ha hlog defecto
  exact registro_cubierto H B p hs k bits R c r defecto hb

theorem cobertura_adversario (H : Entrada → Digest) (B bits R : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (hs : EjecucionBytes.SinBad H (inicial B) (Adversario.ejecutar bits R proponer atacar actualizar))
    (ha : resultado H (Adversario.ejecutar bits R proponer atacar actualizar) = true)
    (defecto : Digest) :
    ∃ c, Lectura.exacto codecCertificado.leer (resultado H proponer).1 = some c ∧
      ∃ n, n < (traza H (Adversario.ejecutar bits R proponer atacar actualizar)).length ∧
        Inicia H (Adversario.ejecutar bits R proponer atacar actualizar) defecto n ∧
        Omite H (Adversario.ejecutar bits R proponer atacar actualizar) defecto n R (Nat.log2 c.enunciado.pasos + 2) := by
  obtain ⟨c, r, hdecode, hb⟩ := MuestraBuena.cobertura_selector_adversario H B bits R proponer atacar actualizar hs ha defecto
  exact ⟨c, hdecode, registro_cubierto H B _ hs (Nat.log2 c.enunciado.pasos) bits R c r defecto hb⟩

end Nexus.Verificador.CoberturaPrimeras
