module

public import Nexus.Verificador.CandidatoPrevio
public import Nexus.Canal.ParametrosRecuperados
public import Nexus.Canal.RetosRecuperados
import Mathlib.Tactic

/-!
# Interpretación del candidato en su corte efectivo

El dato leído depende solo de la semilla y la tabla anterior al primer I.
Las aperturas posteriores del certificado no forman parte de ese dato.
-/

public section
namespace Nexus.Verificador.SemanticaPrevia

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open ProgramaCompartido RegistroPrograma CandidatoPrevio ParametrosRecuperados

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def datosCert (k bits : ℕ) (c : Certificado) : DatosCanal :=
  ⟨k, bits, c.enunciado.inicio, c.enunciado.salida, c.prueba.raiz, c.prueba.traza.raices,
    c.prueba.composicion.raices, c.prueba.traza.final, c.prueba.composicion.final, Completo.nonce c.prueba⟩

@[expose] def interpretar (t : Tabla Entrada Digest) (s : Digest) : Option DatosCanal :=
  ParametrosRecuperados.leer (ReconstruccionSelector.candidato t s)

theorem parametros_antes {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k bits : ℕ} {c : Certificado} (r : Registro H B p k bits c) (hf : Forma k bits c) :
    interpretar r.corte.antes.tabla (semillaCert H k bits c) = some (datosCert k bits c) := by
  rw [interpretar, r.recuperada]
  apply cadena_decodificada
  · have hk := hf.1.2.1; omega
  · rcases hf.2.1 with h | h <;> subst bits <;> decide

theorem desde_aceptacion {A : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (k bits R : ℕ) (c : Certificado)
    (ha : resultado (tabla H) (Completo.verificar k bits R c) = true)
    (hlog : ∀ e ∈ entradas H (Completo.verificar k bits R c), e ∈ ProgramaBytes.entradas H p) :
    ∃ r : Registro H B p k bits c,
      interpretar r.corte.antes.tabla (semillaCert H k bits c) = some (datosCert k bits c) := by
  obtain ⟨r⟩ := CandidatoPrevio.construir H B p hs k bits R c ha hlog
  exact ⟨r, parametros_antes r (Completo.aceptacion_verificador H k bits R c ha).1⟩

theorem misma_semilla_mismos_datos {A : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa A} {k j bits otrosBits : ℕ} {c d : Certificado}
    (f : Registro H B p k bits c) (g : Registro H B p j otrosBits d)
    (hc : Forma k bits c) (hd : Forma j otrosBits d)
    (hs : semillaCert H k bits c = semillaCert H j otrosBits d) :
    datosCert k bits c = datosCert j otrosBits d := by
  have hf := parametros_antes f hc
  rw [tabla_independiente f g hs, hs, parametros_antes g hd] at hf
  exact (Option.some.inj hf).symm

theorem retos_antes {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k bits : ℕ} {c : Certificado} (r : Registro H B p k bits c) (defecto : Digest) :
    RetosRecuperados.retos (funcionTabla defecto r.corte.antes.tabla)
        (ReconstruccionSelector.candidato r.corte.antes.tabla (semillaCert H k bits c)) =
      RetosRecuperados.retos H (cadenaCert H k bits c) := by
  rw [r.recuperada]
  exact RetosRecuperados.retos_de_tabla H _ _ r.disponible defecto

theorem retos_fases_antes {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k bits : ℕ} {c : Certificado} (r : Registro H B p k bits c) (defecto : Digest) :
    let v := RegistroCompleto.evaluar H k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz
      c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final
    RetosRecuperados.retos (funcionTabla defecto r.corte.antes.tabla)
        (ReconstruccionSelector.candidato r.corte.antes.tabla (semillaCert H k bits c)) =
      v.alfas.2 ++ v.traza.2.map (RegistroRaices.beta H) ++ v.composicion.2.map (RegistroRaices.beta H) := by
  rw [retos_antes r defecto]
  exact RetosRecuperados.retos_de_cadena H k bits _ _ _ _ _ _ _ _

theorem raices_determinadas {A : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa A} {k j bits otrosBits : ℕ} {c d : Certificado}
    (f : Registro H B p k bits c) (g : Registro H B p j otrosBits d)
    (hc : Forma k bits c) (hd : Forma j otrosBits d)
    (hs : semillaCert H k bits c = semillaCert H j otrosBits d) :
    k = j ∧ bits = otrosBits ∧ c.enunciado.inicio = d.enunciado.inicio ∧
      c.enunciado.salida = d.enunciado.salida ∧ c.prueba.raiz = d.prueba.raiz ∧
      c.prueba.traza.raices = d.prueba.traza.raices ∧
      c.prueba.composicion.raices = d.prueba.composicion.raices ∧
      c.prueba.traza.final = d.prueba.traza.final ∧ c.prueba.composicion.final = d.prueba.composicion.final ∧
      Completo.nonce c.prueba = Completo.nonce d.prueba := by
  have h := misma_semilla_mismos_datos f g hc hd hs
  exact ⟨congrArg DatosCanal.k h, congrArg DatosCanal.bits h, congrArg DatosCanal.inicio h,
    congrArg DatosCanal.salida h, congrArg DatosCanal.raiz h, congrArg DatosCanal.rt h,
    congrArg DatosCanal.rc h, congrArg DatosCanal.vt h, congrArg DatosCanal.vc h, congrArg DatosCanal.nonce h⟩

end Nexus.Verificador.SemanticaPrevia
