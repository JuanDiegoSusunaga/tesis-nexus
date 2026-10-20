module

public import Nexus.Verificador.SoporteConsulta
public import Nexus.ROM.ValoresFinales
public import Nexus.FRI.ControlesValores
import Mathlib.Tactic

/-!
# Valores de las seis posiciones AIR y ambas fases FRI

La aceptación y el registro del subprograma proporcionan los valores
extraídos. No se supone una lista adicional de aperturas autenticadas.
-/

public section
namespace Nexus.Verificador.ValoresConsulta

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open ProgramaCompartido RegistroPrograma VistaSemantica Recorrido

theorem aperturas_extraidas {A : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (defecto : Digest) (k i : ℕ)
    (hi : i < 2 ^ (k + 2)) (e : Enunciado) (pr : Prueba) (alfas bt bc : List Fp2) (q : Consulta)
    (ha : resultado (tabla H) (ProgramaConsulta.verificar k i e pr alfas bt bc q) = true)
    (hlog : ∀ x ∈ entradas H (ProgramaConsulta.verificar k i e pr alfas bt bc q), x ∈ ProgramaBytes.entradas H p) :
    ∀ a ∈ SoporteConsulta.aperturas k i pr bt bc q,
      valor (EjecucionBytes.final H (inicial B) p).tabla defecto a.altura a.raiz a.indice = a.valor := by
  intro a hm
  have hh := SoporteConsulta.todas_con_soporte H k i e pr alfas bt bc q ha a hm
  apply ValoresFinales.valor_del_programa H B p hs defecto a
    (SoporteConsulta.indices_acotados H k i hi e pr alfas bt bc q ha a hm) hh.1
  exact AperturasPrograma.registrada_monotona H _ _ hlog a hh.2

theorem puntos_como_funcion (q : Consulta) (hl : q.traza.length = 6) :
    ∃ f : Fin 6 → Punto, q.traza = List.ofFn f := by
  let f : Fin 6 → Punto := fun j => q.traza[j.val]'(by rw [hl]; exact j.isLt)
  refine ⟨f, ?_⟩
  apply List.ext_getElem
  · simp only [List.length_ofFn, hl]
  · intro j hj hj2
    simp only [List.getElem_ofFn, f]

theorem seis_puntos (f : Fin 6 → Punto) : List.ofFn f = [f 0, f 1, f 2, f 3, f 4, f 5] := rfl

theorem valores_air (t : Tabla Entrada Digest) (defecto : Digest) (k i : ℕ) (pr : Prueba)
    (bt bc : List Fp2) (q : Consulta) (f : Fin 6 → Punto) (hf : q.traza = List.ofFn f)
    (hv : ∀ a ∈ SoporteConsulta.aperturas k i pr bt bc q,
      valor t defecto a.altura a.raiz a.indice = a.valor) :
    ∀ j : Fin 6, valor t defecto (k + 3) pr.raiz
      (IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i j) = algebraMap Fp Fp2 (f j).valor := by
  intro j
  let a : AperturasPrograma.Apertura := ⟨pr.raiz, k + 3,
    IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i j, algebraMap Fp Fp2 (f j).valor, (f j).hermanos⟩
  apply hv a
  apply List.mem_append_left
  apply List.mem_append_left
  apply List.mem_map.mpr
  refine ⟨(f j, IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i j), ?_, rfl⟩
  rw [hf]
  have hj : j.val < ((List.ofFn f).zip
      (List.ofFn (IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i))).length := by
    simpa only [List.length_zip, List.length_ofFn, Nat.min_self] using j.isLt
  simpa only [List.getElem_zip, List.getElem_ofFn] using List.getElem_mem hj

theorem fri_traza (t : Tabla Entrada Digest) (defecto : Digest) (k i : ℕ) (pr : Prueba)
    (bt bc : List Fp2) (q : Consulta)
    (hv : ∀ a ∈ SoporteConsulta.aperturas k i pr bt bc q,
      valor t defecto a.altura a.raiz a.indice = a.valor) :
    ∀ a ∈ AperturasFRI.aperturas k 0 (pr.traza.raices.zip (bt.zip q.friTraza)) ⟨i, none⟩,
      valor t defecto a.altura a.raiz a.indice = a.valor := by
  intro a hm
  exact hv a (List.mem_append_left _ (List.mem_append_right _ hm))

theorem fri_composicion (t : Tabla Entrada Digest) (defecto : Digest) (k i : ℕ) (pr : Prueba)
    (bt bc : List Fp2) (q : Consulta)
    (hv : ∀ a ∈ SoporteConsulta.aperturas k i pr bt bc q,
      valor t defecto a.altura a.raiz a.indice = a.valor) :
    ∀ a ∈ AperturasFRI.aperturas k 0 (pr.composicion.raices.zip (bc.zip q.friComposicion)) ⟨i, none⟩,
      valor t defecto a.altura a.raiz a.indice = a.valor := by
  intro a hm
  exact hv a (List.mem_append_right _ hm)

end Nexus.Verificador.ValoresConsulta
