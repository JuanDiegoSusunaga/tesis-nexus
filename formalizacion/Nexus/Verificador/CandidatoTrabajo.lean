module

public import Nexus.Canal.PrefijoTrabajo
public import Nexus.Canal.ParTrabajo
public import Nexus.Verificador.MuestraBuena
public import Nexus.Verificador.FiltroFalso
import Mathlib.Tactic

/-!
# El candidato aceptado conserva su canal canónico en la tabla final

Se deriva la canonicidad final desde el registro real, no se añade como una
hipótesis de solidez. Además, la aceptación exige y registra la consulta de
trabajo del mismo estado y nonce usados por la semilla del selector.
-/

public section
namespace Nexus.Verificador.CandidatoTrabajo

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open CandidatoPrevio ParametrosRecuperados FiltroFalso

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem trabajo_aceptado (H : Entrada → Digest) (k bits R : ℕ) (c : Certificado)
    (ha : ProgramaCompartido.resultado (RegistroPrograma.tabla H) (Completo.verificar k bits R c) = true) :
    let sc := (RegistroCompleto.evaluar H k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz
      c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final).composicion.1
    Completo.trabajo bits (H (entradaTrabajo sc (Completo.nonce c.prueba))) = true ∧
      entradaTrabajo sc (Completo.nonce c.prueba) ∈ RegistroPrograma.entradas H (Completo.verificar k bits R c) := by
  have hf := (Completo.aceptacion_verificador H k bits R c ha).1
  rw [Completo.verificar, ite_eq_left hf] at ha ⊢
  have hw := SoporteCandidato.trabajo_aceptado H k bits R c.enunciado.inicio c.enunciado.salida c.prueba.raiz
    c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final
    (Completo.nonce c.prueba) (Completo.trabajo bits) _ ha
  refine ⟨hw, ?_⟩
  rw [RegistroCompleto.registro_canal]
  exact List.mem_append_right _ List.mem_cons_self

theorem canonico_final {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    (hs : EjecucionBytes.SinBad H (inicial B) p) {k bits : ℕ} {c : Certificado}
    (r : Registro H B p k bits c) (hf : Forma k bits c) (defecto : Digest) :
    Canonico (EjecucionBytes.final H (inicial B) p).tabla defecto
      (semillaCert H k bits c) (SemanticaPrevia.datosCert k bits c) := by
  let fin := EjecucionBytes.final H (inicial B) p
  let d := SemanticaPrevia.datosCert k bits c
  let G := funcionTabla defecto fin.tabla
  have hcomp : Compatibles H fin.tabla :=
    EjecucionBytes.final_compatible H (inicial B) p (by intro e v he; contradiction)
  have hq := VistaPrevia.disponible_final r
  have hagree : ∀ e ∈ CanalPrevio.cadena H d, H e = G e := by
    intro e he
    simp only [G, fin, funcionTabla, hq e he, Option.getD_some]
  have hc := CanalPrevio.canal_congruente H G d hagree
  have hrecorrido := EjecucionBytes.recorrido_desde_programa H (inicial B) p
    (by intro e v he; contradiction) hs
  have hcol := recorrido_sin_colisiones H hrecorrido hcomp
    (by intro e he; simp only [inicial, List.map_nil, List.not_mem_nil] at he)
  have hcant := forma_implica_cantidades k bits c hf
  have hlen := TrayectoTG2.longitud_perfil H k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz
    c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final
    (Completo.nonce c.prueba) hcant.1 hcant.2.1 (by have hk := hf.1.2.1; omega)
  have hrec := Trayecto.reconstruccion_exacta H fin.tabla hcomp hcol
    (TrayectoTG2.camino_canal H k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz
      c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final
      (Completo.nonce c.prueba))
    (fun e he => buscar_some_mem _ _ _ (hq e he)) 130 hlen
  have hcadena : ReconstruccionSelector.candidato fin.tabla (semillaCert H k bits c) = CanalPrevio.cadena H d := by
    rw [ReconstruccionSelector.candidato, hrec, List.reverse_reverse]
    rfl
  refine ⟨admisible_certificado k bits c hf, hcadena.trans hc.2, hc.1.symm, ?_⟩
  intro e he
  rw [hcadena] at he
  exact (hq e he).trans (congrArg some (hagree e he))

theorem canal_final {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k bits : ℕ} {c : Certificado} (r : Registro H B p k bits c) (defecto : Digest) :
    CanalPrevio.cadena H (SemanticaPrevia.datosCert k bits c) =
      CanalPrevio.cadena (funcionTabla defecto (EjecucionBytes.final H (inicial B) p).tabla)
        (SemanticaPrevia.datosCert k bits c) := by
  apply (CanalPrevio.canal_congruente H _ _ ?_).2
  intro e he
  simp only [funcionTabla, VistaPrevia.disponible_final r e he, Option.getD_some]

theorem estado_final {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k bits : ℕ} {c : Certificado} (r : Registro H B p k bits c) (defecto : Digest) :
    PrefijoTrabajo.estado H (SemanticaPrevia.datosCert k bits c) =
      PrefijoTrabajo.estado (funcionTabla defecto (EjecucionBytes.final H (inicial B) p).tabla)
        (SemanticaPrevia.datosCert k bits c) := by
  have h := congrArg List.getLast? (canal_final r defecto)
  simp only [CanalPrevio.cadena, TrayectoTG2.cadena, List.getLast?_append,
    List.getLast?_singleton] at h
  exact (ParTrabajo.nonce_inyectivo (Option.some.inj h)).1

end Nexus.Verificador.CandidatoTrabajo
