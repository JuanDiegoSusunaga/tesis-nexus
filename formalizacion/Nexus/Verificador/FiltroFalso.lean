module

public import Nexus.Canal.CanalPrevio
public import Nexus.Verificador.PoliticasPrefijo
public import Nexus.N06.TranscripcionCausal
import Mathlib.Tactic

/-!
# Canal canónico y falsedad reconocidos desde la tabla previa

La lectura semántica se contrasta con la reejecución de todo el canal sobre
una función completada desde la tabla. Se comprueba también que todas sus
entradas estén guardadas y que su salida sea la semilla observada. Falsedad
significa ausencia del polinomio AIR de bajo grado que define EnunciadoValido.
-/

public section
namespace Nexus.Verificador.FiltroFalso

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open ParametrosRecuperados CandidatoPrevio SemanticaPrevia

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def Admisible (d : DatosCanal) : Prop :=
  (4 ≤ d.k ∧ d.k ≤ 12) ∧ (d.bits = 12 ∨ d.bits = 20) ∧
    d.rt.length = d.k ∧ d.rc.length = d.k + 1 ∧ d.rt.head? = some d.raiz

@[expose] def Falso (d : DatosCanal) : Prop := ¬ EnunciadoValido d.k d.inicio d.salida

structure Canonico (t : Tabla Entrada Digest) (defecto s : Digest) (d : DatosCanal) : Prop where
  perfil : Admisible d
  cadena : ReconstruccionSelector.candidato t s = CanalPrevio.cadena (funcionTabla defecto t) d
  semilla : CanalPrevio.semilla (funcionTabla defecto t) d = s
  conocidas : ∀ e ∈ ReconstruccionSelector.candidato t s, buscar t e = some (funcionTabla defecto t e)

@[expose] def Elegible (t : Tabla Entrada Digest) (defecto s : Digest) : Prop :=
  match interpretar t s with
  | none => False
  | some d => Canonico t defecto s d ∧ Falso d

theorem admisible_certificado (k bits : ℕ) (c : Certificado) (hf : Forma k bits c) :
    Admisible (datosCert k bits c) := by
  rcases hf with ⟨⟨hlo, hhi, _⟩, hb, _, _, _, ht, hc, _, hr, _⟩
  exact ⟨⟨hlo, hhi⟩, hb, ht, hc, hr⟩

theorem falso_iff (d : DatosCanal) : Falso d ↔
    ∀ A : Polynomial Fp, A.natDegree < 2 ^ d.k →
      ¬ Nexus.AIR.Valida (raiz d.k) (2 ^ d.k) A d.inicio d.salida := by
  simp only [Falso, EnunciadoValido, not_exists, not_and]

theorem canonico_registro {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k bits : ℕ} {c : Certificado} (r : Registro H B p k bits c) (hf : Forma k bits c) (defecto : Digest) :
    Canonico r.corte.antes.tabla defecto (semillaCert H k bits c) (datosCert k bits c) := by
  have hc := CanalPrevio.canal_congruente H (funcionTabla defecto r.corte.antes.tabla) (datosCert k bits c)
    (fun e he => by simp only [funcionTabla, r.disponible e he, Option.getD_some])
  refine ⟨admisible_certificado k bits c hf, r.recuperada.trans hc.2, hc.1.symm, ?_⟩
  intro e he
  rw [r.recuperada] at he
  simp only [funcionTabla, r.disponible e he, Option.getD_some]

theorem parametros_canonicos (t : Tabla Entrada Digest) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico t defecto s d) : interpretar t s = some d := by
  have hb : d.bits < 256 ^ 4 := by rcases hc.perfil.2.1 with h | h <;> rw [h] <;> decide
  rw [interpretar, hc.cadena]
  exact ParametrosRecuperados.cadena_decodificada (funcionTabla defecto t) d.k d.bits d.inicio d.salida
    d.raiz d.rt d.rc d.vt d.vc d.nonce (by have hk := hc.perfil.1.2; omega) hb

theorem elegible_iff (t : Tabla Entrada Digest) (defecto s : Digest) :
    Elegible t defecto s ↔ ∃ d, Canonico t defecto s d ∧ Falso d := by
  constructor
  · unfold Elegible
    cases hd : interpretar t s with
    | none => simp only [false_implies]
    | some d => intro h; exact ⟨d, h⟩
  · rintro ⟨d, hc, hf⟩
    rw [Elegible, parametros_canonicos t defecto s d hc]
    exact ⟨hc, hf⟩

theorem elegible_registro {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k bits : ℕ} {c : Certificado} (r : Registro H B p k bits c) (hf : Forma k bits c)
    (hfalse : ¬ EnunciadoValido k c.enunciado.inicio c.enunciado.salida) (defecto : Digest) :
    Elegible r.corte.antes.tabla defecto (semillaCert H k bits c) :=
  (elegible_iff _ _ _).mpr ⟨datosCert k bits c, canonico_registro r hf defecto, hfalse⟩

theorem valido_excluido (t : Tabla Entrada Digest) (defecto s : Digest) (d : DatosCanal)
    (hd : interpretar t s = some d) (hv : EnunciadoValido d.k d.inicio d.salida) :
    ¬ Elegible t defecto s := by
  rw [Elegible, hd]
  exact fun h => h.2 hv

theorem retos_canonicos (t : Tabla Entrada Digest) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico t defecto s d) :
    let G := funcionTabla defecto t
    let v := RegistroCompleto.evaluar G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
    RetosRecuperados.retos G (ReconstruccionSelector.candidato t s) =
      v.alfas.2 ++ v.traza.2.map (RegistroRaices.beta G) ++ v.composicion.2.map (RegistroRaices.beta G) := by
  rw [hc.cadena]
  exact RetosRecuperados.retos_de_cadena _ _ _ _ _ _ _ _ _ _ _

end Nexus.Verificador.FiltroFalso
