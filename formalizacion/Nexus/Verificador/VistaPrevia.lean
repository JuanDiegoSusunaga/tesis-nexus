module

public import Nexus.Verificador.SemanticaPrevia
public import Nexus.Canal.VistaSemantica
import Mathlib.Tactic

/-!
# Conservación de la vista completa del candidato registrado

Cada raíz utilizada procede de una absorción real del canal. Se transportan
sus vectores y los retos desde el corte anterior al primer I al registro final.
-/

public section
namespace Nexus.Verificador.VistaPrevia

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open ProgramaCompartido RegistroPrograma CandidatoPrevio SemanticaPrevia
open ParametrosRecuperados VistaSemantica RegistroRaices

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem raiz_absorbida (H : Entrada → Digest) (k bits : ℕ) (c : Certificado) (r : Digest)
    (hr : r ∈ c.prueba.raiz :: (c.prueba.traza.raices ++ c.prueba.composicion.raices)) :
    ∃ s tag, entradaAbsorcion s tag r.val ∈ cadenaCert H k bits c := by
  let v := RegistroCompleto.evaluar H k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz
    c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final
  have hm (e : Entrada) (he : e ∈ RegistroCompleto.prefijo H k bits c.enunciado.inicio c.enunciado.salida
      c.prueba.raiz c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final) :
      e ∈ cadenaCert H k bits c := List.mem_append_left _ he
  rcases List.mem_cons.mp hr with h | h
  · subst r
    refine ⟨v.base.estado, 1, ?_⟩
    exact hm _ (RegistroCompleto.base_registrada H k bits _ _ _ _ _ _ _).1
  · rcases List.mem_append.mp h with ht | hc
    · have hmap : r ∈ v.traza.2.map Evento.raiz := by
        rw [(RegistroCompleto.raices_conservadas H k bits _ _ _ _ _ _ _).1]
        exact ht
      obtain ⟨e, he, her⟩ := List.mem_map.mp hmap
      refine ⟨e.estado, e.tag, ?_⟩
      rw [← her]
      exact hm _ (RegistroCompleto.traza_registrada H k bits _ _ _ _ _ _ _ e he).1
    · have hmap : r ∈ v.composicion.2.map Evento.raiz := by
        rw [(RegistroCompleto.raices_conservadas H k bits _ _ _ _ _ _ _).2]
        exact hc
      obtain ⟨e, he, her⟩ := List.mem_map.mp hmap
      refine ⟨e.estado, e.tag, ?_⟩
      rw [← her]
      exact hm _ (RegistroCompleto.composicion_registrada H k bits _ _ _ _ _ _ _ e he).1

theorem disponible_final {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k bits : ℕ} {c : Certificado} (r : Registro H B p k bits c) :
    ∀ e ∈ cadenaCert H k bits c, buscar (EjecucionBytes.final H (inicial B) p).tabla e = some (H e) := by
  intro e he
  exact buscar_persiste_en_recorrido
    (recorrido_trans (paso_es_recorrido (corte_paso r.corte)) r.corte.sufijo) e (H e) (r.disponible e he)

theorem vista_congelada {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k bits : ℕ} {c : Certificado} (r : Registro H B p k bits c) (defecto : Digest) :
    construir r.corte.antes.tabla defecto (datosCert k bits c) (cadenaCert H k bits c) =
      construir (EjecucionBytes.final H (inicial B) p).tabla defecto (datosCert k bits c) (cadenaCert H k bits c) := by
  apply vista_conservada
  · exact (RetosRecuperados.retos_de_tabla H _ _ r.disponible defecto).trans
      (RetosRecuperados.retos_de_tabla H _ _ (disponible_final r) defecto).symm
  · intro raiz hr altura
    obtain ⟨s, tag, hq⟩ := raiz_absorbida H k bits c raiz hr
    exact valor_conservado _ _ defecto altura raiz (r.vectores s raiz tag hq defecto altura)

theorem vista_leida {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k bits : ℕ} {c : Certificado} (r : Registro H B p k bits c) (hf : Forma k bits c) (defecto : Digest) :
    VistaSemantica.leer r.corte.antes.tabla defecto (semillaCert H k bits c) =
      some (construir (EjecucionBytes.final H (inicial B) p).tabla defecto
        (datosCert k bits c) (cadenaCert H k bits c)) := by
  have hd := parametros_antes r hf
  unfold interpretar at hd
  rw [r.recuperada] at hd
  simp only [VistaSemantica.leer, r.recuperada, hd, Option.map_some]
  exact congrArg some (vista_congelada r defecto)

theorem misma_semilla_misma_vista {A : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa A} {k j bits otrosBits : ℕ} {c d : Certificado}
    (f : Registro H B p k bits c) (g : Registro H B p j otrosBits d)
    (hc : Forma k bits c) (hd : Forma j otrosBits d) (defecto : Digest)
    (hs : semillaCert H k bits c = semillaCert H j otrosBits d) :
    construir (EjecucionBytes.final H (inicial B) p).tabla defecto (datosCert k bits c) (cadenaCert H k bits c) =
      construir (EjecucionBytes.final H (inicial B) p).tabla defecto (datosCert j otrosBits d) (cadenaCert H j otrosBits d) := by
  have hh := vista_leida f hc defecto
  rw [tabla_independiente f g hs, hs, vista_leida g hd defecto] at hh
  exact (Option.some.inj hh).symm

end Nexus.Verificador.VistaPrevia
