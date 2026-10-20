module

public import Nexus.Verificador.FiltroFalso
public import Nexus.Verificador.MuestraBuena
public import Nexus.ROM.FiltroSelector
import Mathlib.Tactic

/-!
# Políticas para candidatos falsos con cardinal controlado

Ambos conjuntos se vacían fuera del canal canónico falso y cuando su
intersección supera g. El segundo filtro introduce un evento de exceso
explícito; no demuestra por sí solo que ese evento sea improbable.
-/

public section
namespace Nexus.Verificador.PoliticasFalsas

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open ProgramaBytes CandidatoPrevio ParametrosRecuperados

variable {A : Type}
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def elegible (p : Programa A) (defecto : Digest) (t : List (Entrada × Digest)) : Prop :=
  FiltroFalso.Elegible (TablaObservada.tabla t) defecto (SemillaProxima.semilla p defecto t)

@[expose] noncomputable def Admite (p : Programa A) (defecto : Digest) (e g : ℕ)
    (t : List (Entrada × Digest)) : Prop :=
  elegible p defecto t ∧ (PoliticasPrefijo.GT p defecto e t ∩ PoliticasPrefijo.GC p defecto e t).card ≤ g

@[expose] noncomputable def GT (p : Programa A) (defecto : Digest) (e g : ℕ)
    (t : List (Entrada × Digest)) : Finset (Fin (2 ^ e)) :=
  FiltroSelector.filtrar (Admite p defecto e g t) (PoliticasPrefijo.GT p defecto e t)

@[expose] noncomputable def GC (p : Programa A) (defecto : Digest) (e g : ℕ)
    (t : List (Entrada × Digest)) : Finset (Fin (2 ^ e)) :=
  FiltroSelector.filtrar (Admite p defecto e g t) (PoliticasPrefijo.GC p defecto e t)

@[expose] noncomputable def Omite (H : Entrada → Digest) (p : Programa A) (defecto : Digest)
    (n R e g : ℕ) : Prop :=
  let t := (traza H p).take n
  let T := ROM.SelectorAcoplado.salida e 40 (CintaSelector.cinta H R (SemillaProxima.semilla p defecto t))
  T.card = 40 ∧ T ⊆ GT p defecto e g t ∩ GC p defecto e g t

@[expose] noncomputable def Exceso (H : Entrada → Digest) (p : Programa A) (defecto : Digest)
    (N e g : ℕ) : Prop :=
  ∃ n : Fin N, PoliticasPrefijo.Inicia H p defecto n.val ∧
    elegible p defecto ((traza H p).take n.val) ∧
    g < (PoliticasPrefijo.GT p defecto e ((traza H p).take n.val) ∩
      PoliticasPrefijo.GC p defecto e ((traza H p).take n.val)).card

@[expose] def AceptaFalsa (H : Entrada → Digest) (bits R k : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) : Prop :=
  resultado H (Adversario.ejecutar bits R proponer atacar actualizar) = true ∧
    ∃ c, Lectura.exacto codecCertificado.leer (resultado H proponer).1 = some c ∧
      Nat.log2 c.enunciado.pasos = k ∧ ¬ EnunciadoValido k c.enunciado.inicio c.enunciado.salida

theorem cardinal (p : Programa A) (defecto : Digest) (e g : ℕ) (t : List (Entrada × Digest)) :
    (GT p defecto e g t ∩ GC p defecto e g t).card ≤ g :=
  FiltroSelector.cardinal_interseccion _ _ _ g (fun h => h.2)

theorem omision_iff (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (n R e g : ℕ) :
    Omite H p defecto n R e g ↔
      Admite p defecto e g ((traza H p).take n) ∧ PoliticasPrefijo.Omite H p defecto n R e := by
  exact FiltroSelector.muestra_positiva _ _ _ _ 40 (by norm_num)

theorem registro_cubierto (H : Entrada → Digest) (B : ℕ) (p : Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (k bits R : ℕ) (c : Certificado)
    (r : Registro H B p k bits c) (hf : Forma k bits c)
    (hfalse : ¬ EnunciadoValido k c.enunciado.inicio c.enunciado.salida) (defecto : Digest)
    (hb : let T := ROM.SelectorAcoplado.salida (k + 2) 40 (CintaSelector.cinta H R (semillaCert H k bits c))
      T.card = 40 ∧ T ⊆ ConjuntosPrevios.GT (k + 2) defecto (semillaCert H k bits c) r.corte.antes.tabla ∩
        ConjuntosPrevios.GC (k + 2) defecto (semillaCert H k bits c) r.corte.antes.tabla) :
    ∃ n, n < (traza H p).length ∧ PoliticasPrefijo.Inicia H p defecto n ∧
      elegible p defecto ((traza H p).take n) ∧ PoliticasPrefijo.Omite H p defecto n R (k + 2) := by
  obtain ⟨n, hn, hi, hseed, ht⟩ := PoliticasPrefijo.registro_previsible H B p hs k bits c r defecto
  refine ⟨n, hn, hi, ?_, ?_⟩
  · unfold elegible
    rw [hseed, ← ht]
    exact FiltroFalso.elegible_registro r hf hfalse defecto
  · simpa only [PoliticasPrefijo.Omite, PoliticasPrefijo.GT, PoliticasPrefijo.GC, hseed, ← ht] using hb

theorem cobertura_certificado (H : Entrada → Digest) (B : ℕ) (p : Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (k bits R : ℕ) (c : Certificado)
    (ha : ProgramaCompartido.resultado (RegistroPrograma.tabla H) (Completo.verificar k bits R c) = true)
    (hlog : ∀ e ∈ RegistroPrograma.entradas H (Completo.verificar k bits R c), e ∈ entradas H p)
    (hfalse : ¬ EnunciadoValido k c.enunciado.inicio c.enunciado.salida) (defecto : Digest) :
    ∃ n, n < (traza H p).length ∧ PoliticasPrefijo.Inicia H p defecto n ∧
      elegible p defecto ((traza H p).take n) ∧ PoliticasPrefijo.Omite H p defecto n R (k + 2) := by
  obtain ⟨r, hb⟩ := MuestraBuena.omision_efectiva H B p hs k bits R c ha hlog defecto
  exact registro_cubierto H B p hs k bits R c r (Completo.aceptacion_verificador H k bits R c ha).1 hfalse defecto hb

theorem cobertura_adversario (H : Entrada → Digest) (L bits R k : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (hs : EjecucionBytes.SinBad H (inicial L) (Adversario.ejecutar bits R proponer atacar actualizar))
    (ha : AceptaFalsa H bits R k proponer atacar actualizar) (defecto : Digest) :
    ∃ n : Fin (altura (Adversario.ejecutar bits R proponer atacar actualizar)),
      PoliticasPrefijo.Inicia H (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val ∧
      elegible (Adversario.ejecutar bits R proponer atacar actualizar) defecto
        ((traza H (Adversario.ejecutar bits R proponer atacar actualizar)).take n.val) ∧
      PoliticasPrefijo.Omite H (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val R (k + 2) := by
  obtain ⟨hacc, c, hd, hk, hfalse⟩ := ha
  subst k
  rw [Adversario.resultado_con_bytes, Completo.desdeBytes, hd] at hacc
  obtain ⟨n, hn, hi, he, ho⟩ := cobertura_certificado H L _ hs (Nat.log2 c.enunciado.pasos) bits R c hacc
    (fun e he => (Adversario.registro_verificador H bits R proponer atacar actualizar).subset
      (by simpa only [Completo.desdeBytes, hd] using he)) hfalse defecto
  exact ⟨⟨n, hn.trans_le (costo_acotado H _)⟩, hi, he, ho⟩

theorem sin_exceso_cubre (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (N R e g : ℕ)
    (hc : ∃ n : Fin N, PoliticasPrefijo.Inicia H p defecto n.val ∧
      elegible p defecto ((traza H p).take n.val) ∧ PoliticasPrefijo.Omite H p defecto n.val R e)
    (hx : ¬ Exceso H p defecto N e g) :
    ∃ n : Fin N, PoliticasPrefijo.Inicia H p defecto n.val ∧ Omite H p defecto n.val R e g := by
  obtain ⟨n, hi, he, ho⟩ := hc
  have hg : (PoliticasPrefijo.GT p defecto e ((traza H p).take n.val) ∩
      PoliticasPrefijo.GC p defecto e ((traza H p).take n.val)).card ≤ g := by
    by_contra h
    exact hx ⟨n, hi, he, Nat.lt_of_not_ge h⟩
  exact ⟨n, hi, (omision_iff H p defecto n.val R e g).mpr ⟨⟨he, hg⟩, ho⟩⟩

end Nexus.Verificador.PoliticasFalsas
