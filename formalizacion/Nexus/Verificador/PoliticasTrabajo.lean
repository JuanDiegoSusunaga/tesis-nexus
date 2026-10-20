module

public import Nexus.Verificador.CandidatoTrabajo
public import Nexus.Verificador.ConjuntosPrevios
import Mathlib.Tactic

/-!
# El conjunto bueno del selector se elige antes del trabajo y del nonce

La lectura usa solo la tabla anterior a la primera consulta de la pareja.
El filtro da cardinal acotado para todas las tablas, sin condicionar a que el
canal resulte válido o aceptado. En un candidato real seguro conserva el
conjunto bueno original cuando su cardinal no supera el umbral.
-/

public section
namespace Nexus.Verificador.PoliticasTrabajo

open Nexus.Bytes Nexus.Merkle Nexus.ROM Nexus.Canal
open ParTrabajo CandidatoPrevio SemanticaPrevia

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] noncomputable def brutos (e : ℕ) (t : Tabla Entrada Digest) (defecto : Digest) (k : Clave) :
    Finset (Fin (2 ^ e)) :=
  match PrefijoTrabajo.vistaPrevia t defecto k.1 k.2 with
  | none => ∅
  | some v => ConjuntosPrevios.buenos e ConjuntosPrevios.pruebaTraza v ∩
      ConjuntosPrevios.buenos e ConjuntosPrevios.pruebaComposicion v

@[expose] noncomputable def buenos (e g : ℕ) (t : Tabla Entrada Digest) (defecto : Digest) (k : Clave) :
    Finset (Fin (2 ^ e)) :=
  if (brutos e t defecto k).card ≤ g then brutos e t defecto k else ∅

theorem cardinal (e g : ℕ) (t : Tabla Entrada Digest) (defecto : Digest) (k : Clave) :
    (buenos e g t defecto k).card ≤ g := by
  unfold buenos
  split_ifs with h
  · exact h
  · exact Nat.zero_le g

theorem brutos_corte {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    (hs : EjecucionBytes.SinBad H (inicial B) p) {k bits : ℕ} {cert : Certificado}
    (r : Registro H B p k bits cert) (hf : Forma k bits cert) (defecto : Digest)
    (b : Bool) (c : PrefijoTrabajo.Corte (EjecucionBytes.final H (inicial B) p) defecto
      (datosCert k bits cert) b) (e : ℕ) :
    brutos e c.antes.tabla defecto
      (PrefijoTrabajo.estado H (datosCert k bits cert), Completo.nonce cert.prueba) =
      ConjuntosPrevios.GT e defecto (semillaCert H k bits cert) r.corte.antes.tabla ∩
        ConjuntosPrevios.GC e defecto (semillaCert H k bits cert) r.corte.antes.tabla := by
  have hc := CandidatoTrabajo.canonico_final hs r hf defecto
  have hr := EjecucionBytes.recorrido_desde_programa H (inicial B) p
    (by intro e d he; contradiction) hs
  have hv := PrefijoTrabajo.vista_previa_leida hr defecto (semillaCert H k bits cert)
    (datosCert k bits cert) hc b c
  have hcadena : ReconstruccionSelector.candidato (EjecucionBytes.final H (inicial B) p).tabla
      (semillaCert H k bits cert) = cadenaCert H k bits cert :=
    hc.cadena.trans (CandidatoTrabajo.canal_final r defecto).symm
  have hnonce : (datosCert k bits cert).nonce = Completo.nonce cert.prueba := rfl
  have hv' : PrefijoTrabajo.vistaPrevia c.antes.tabla defecto
      (PrefijoTrabajo.estado (funcionTabla defecto (EjecucionBytes.final H (inicial B) p).tabla)
        (datosCert k bits cert)) (Completo.nonce cert.prueba) =
      some (VistaSemantica.construir (EjecucionBytes.final H (inicial B) p).tabla defecto (datosCert k bits cert)
        (ReconstruccionSelector.candidato (EjecucionBytes.final H (inicial B) p).tabla (semillaCert H k bits cert))) := by
    simpa only [SemanticaPrevia.datosCert] using hv
  rw [brutos]
  dsimp only [Prod.fst, Prod.snd]
  rw [CandidatoTrabajo.estado_final r defecto, hv', hcadena]
  have hg := ConjuntosPrevios.conjuntos_antes r hf e defecto
  rw [hg.1, hg.2]

theorem buenos_corte {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    (hs : EjecucionBytes.SinBad H (inicial B) p) {k bits : ℕ} {cert : Certificado}
    (r : Registro H B p k bits cert) (hf : Forma k bits cert) (defecto : Digest)
    (b : Bool) (c : PrefijoTrabajo.Corte (EjecucionBytes.final H (inicial B) p) defecto
      (datosCert k bits cert) b) (e g : ℕ)
    (hg : (ConjuntosPrevios.GT e defecto (semillaCert H k bits cert) r.corte.antes.tabla ∩
      ConjuntosPrevios.GC e defecto (semillaCert H k bits cert) r.corte.antes.tabla).card ≤ g) :
    buenos e g c.antes.tabla defecto (PrefijoTrabajo.estado H (datosCert k bits cert), Completo.nonce cert.prueba) =
      ConjuntosPrevios.GT e defecto (semillaCert H k bits cert) r.corte.antes.tabla ∩
        ConjuntosPrevios.GC e defecto (semillaCert H k bits cert) r.corte.antes.tabla := by
  rw [buenos, brutos_corte hs r hf defecto b c e, ite_eq_left hg]

end Nexus.Verificador.PoliticasTrabajo
