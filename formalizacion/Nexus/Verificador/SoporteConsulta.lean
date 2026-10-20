module

public import Nexus.Verificador.Consulta
public import Nexus.FRI.AperturasPrograma
import Mathlib.Tactic

/-!
# Soporte de todas las aperturas de una consulta aceptada

Los hechos de registro AIR y FRI se transportan desde sus subprogramas al
programa que los compone. Las seis posiciones conservan su índice efectivo.
-/

public section
namespace Nexus.Verificador.SoporteConsulta

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open ProgramaCompartido RegistroPrograma
open AperturasPrograma

@[expose] def air (r : Digest) (h : ℕ) (ps : List (Punto × ℕ)) : List Apertura :=
  ps.map (fun p => ⟨r, h, p.2, algebraMap Fp Fp2 p.1.valor, p.1.hermanos⟩)

@[expose] noncomputable def frit (k i : ℕ) (p : Prueba) (bt : List Fp2) (q : Consulta) : List Apertura :=
  AperturasFRI.aperturas k 0 (p.traza.raices.zip (bt.zip q.friTraza)) ⟨i, none⟩

@[expose] noncomputable def fric (k i : ℕ) (p : Prueba) (bc : List Fp2) (q : Consulta) : List Apertura :=
  AperturasFRI.aperturas k 0 (p.composicion.raices.zip (bc.zip q.friComposicion)) ⟨i, none⟩

@[expose] noncomputable def aperturas (k i : ℕ) (p : Prueba) (bt bc : List Fp2) (q : Consulta) : List Apertura :=
  air p.raiz (k + 3) (q.traza.zip (List.ofFn (IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i))) ++
    frit k i p bt q ++ fric k i p bc q

theorem air_soporte (H : Entrada → Digest) (r : Digest) (h : ℕ) (ps : List (Punto × ℕ))
    (ha : resultado (tabla H) (ProgramaConsulta.air r h ps) = true) :
    ∀ a ∈ air r h ps, Valida H a ∧ Registrada H (entradas H (ProgramaConsulta.air r h ps)) a := by
  induction ps with
  | nil => simp only [air, List.map_nil, List.not_mem_nil, false_implies, implies_true]
  | cons p ps ih =>
    obtain ⟨hp, hr⟩ := aceptacion_ambos _ _ _ ha
    intro a hm
    rcases List.mem_cons.mp hm with rfl | hm
    · refine ⟨(programa_valido H _).mp hp, ?_⟩
      exact registrada_monotona H _ _ (fun e he => (primero_registrado H _ _).subset he) _
        (programa_registrado H _ hp)
    · have hh := ih hr a hm
      exact ⟨hh.1, registrada_monotona H _ _ (segundo_registrado H _ _ hp) a hh.2⟩

theorem registro_consulta (H : Entrada → Digest) (k i : ℕ) (e : Enunciado) (p : Prueba)
    (a bt bc : List Fp2) (q : Consulta)
    (ha : resultado (tabla H) (ProgramaConsulta.verificar k i e p a bt bc q) = true) :
    entradas H (ProgramaConsulta.verificar k i e p a bt bc q) =
      entradas H (ProgramaConsulta.air p.raiz (k + 3)
        (q.traza.zip (List.ofFn (IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i)))) ++
      entradas H (ProgramaFRI.verificar k k i p.traza.raices bt q.friTraza p.traza.final) ++
      entradas H (ProgramaFRI.verificar k (k + 1) i p.composicion.raices bc q.friComposicion p.composicion.final) := by
  have hh := (ProgramaConsulta.aceptacion_controles H k i e p a bt bc q).mp ha
  simp only [ProgramaConsulta.verificar, hh.1, ite_true, registro_encadenado, resultado,
    hh.2.1, hh.2.2.1, hh.2.2.2.1, hh.2.2.2.2.1, entradas,
    List.nil_append, List.append_assoc]

theorem todas_con_soporte (H : Entrada → Digest) (k i : ℕ) (e : Enunciado) (p : Prueba)
    (alfas bt bc : List Fp2) (q : Consulta)
    (ha : resultado (tabla H) (ProgramaConsulta.verificar k i e p alfas bt bc q) = true) :
    ∀ a ∈ aperturas k i p bt bc q, Valida H a ∧
      Registrada H (entradas H (ProgramaConsulta.verificar k i e p alfas bt bc q)) a := by
  have hh := (ProgramaConsulta.aceptacion_controles H k i e p alfas bt bc q).mp ha
  intro a hm
  rcases List.mem_append.mp hm with hm | hm
  · rcases List.mem_append.mp hm with hm | hm
    · have hv := air_soporte H p.raiz (k + 3) _ hh.2.1 a hm
      refine ⟨hv.1, registrada_monotona H _ _ ?_ a hv.2⟩
      intro x hx
      rw [registro_consulta H k i e p alfas bt bc q ha]
      exact List.mem_append_left _ (List.mem_append_left _ hx)
    · have hv := AperturasFRI.verificacion_registra H k k i p.traza.raices bt q.friTraza p.traza.final
        hh.2.2.2.1 a hm
      refine ⟨hv.1, registrada_monotona H _ _ ?_ a hv.2⟩
      intro x hx
      rw [registro_consulta H k i e p alfas bt bc q ha]
      exact List.mem_append_left _ (List.mem_append_right _ hx)
  · have hv := AperturasFRI.verificacion_registra H k (k + 1) i p.composicion.raices bc q.friComposicion
      p.composicion.final hh.2.2.2.2.2 a hm
    refine ⟨hv.1, registrada_monotona H _ _ ?_ a hv.2⟩
    intro x hx
    rw [registro_consulta H k i e p alfas bt bc q ha]
    exact List.mem_append_right _ hx

theorem posiciones_acotadas (n i : ℕ) (hn : 0 < n) (hi : i < n / 2) (j : Fin 6) :
    IndicesMaquina.posicionesNaturales n i j < n := by
  fin_cases j
  · change i < n; omega
  · exact Nat.mod_lt _ hn
  · exact Nat.mod_lt _ hn
  · change i + n / 2 < n; omega
  · exact Nat.mod_lt _ hn
  · exact Nat.mod_lt _ hn

theorem air_indices (k i : ℕ) (hi : i < 2 ^ (k + 2)) (q : Consulta) (r : Digest)
    (a : Apertura)
    (hm : a ∈ air r (k + 3) (q.traza.zip (List.ofFn (IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i)))) :
    a.indice < 2 ^ a.altura := by
  obtain ⟨⟨p, pos⟩, hp, rfl⟩ := List.mem_map.mp hm
  have hpos := List.of_mem_zip hp |>.2
  obtain ⟨j, hj⟩ := List.mem_ofFn.mp hpos
  change pos < 2 ^ (k + 3)
  rw [← hj]
  apply posiciones_acotadas _ _ (by positivity)
  have hhalf : 2 ^ (k + 3) / 2 = 2 ^ (k + 2) := by
    rw [show k + 3 = k + 2 + 1 by omega, pow_succ, Nat.mul_div_cancel _ (by decide : 0 < 2)]
  simpa only [hhalf] using hi

theorem indices_acotados (H : Entrada → Digest) (k i : ℕ) (hi : i < 2 ^ (k + 2))
    (e : Enunciado) (p : Prueba) (alfas bt bc : List Fp2) (q : Consulta)
    (ha : resultado (tabla H) (ProgramaConsulta.verificar k i e p alfas bt bc q) = true)
    (a : Apertura) (hm : a ∈ aperturas k i p bt bc q) : a.indice < 2 ^ a.altura := by
  have hh := (ProgramaConsulta.aceptacion_controles H k i e p alfas bt bc q).mp ha
  have ht := (ProgramaFRI.formas_y_condiciones H k k i p.traza.raices bt q.friTraza p.traza.final).mp hh.2.2.2.1
  have hc := (ProgramaFRI.formas_y_condiciones H k (k + 1) i p.composicion.raices bc q.friComposicion p.composicion.final).mp hh.2.2.2.2.2
  rcases List.mem_append.mp hm with hm | hm
  · rcases List.mem_append.mp hm with hm | hm
    · exact air_indices k i hi q p.raiz a hm
    · exact AperturasFRI.indices_acotados k 0 _ _ (by simp [List.length_zip, ht.1, ht.2.1, ht.2.2.1]) a hm
  · exact AperturasFRI.indices_acotados k 0 _ _ (by simp [List.length_zip, hc.1, hc.2.1, hc.2.2.1]) a hm

theorem cantidad (H : Entrada → Digest) (k i : ℕ) (e : Enunciado) (p : Prueba)
    (alfas bt bc : List Fp2) (q : Consulta)
    (ha : resultado (tabla H) (ProgramaConsulta.verificar k i e p alfas bt bc q) = true) :
    (aperturas k i p bt bc q).length = 6 + 2 * k + 2 * (k + 1) := by
  have hh := (ProgramaConsulta.aceptacion_controles H k i e p alfas bt bc q).mp ha
  have ht := (ProgramaFRI.formas_y_condiciones H k k i p.traza.raices bt q.friTraza p.traza.final).mp hh.2.2.2.1
  have hc := (ProgramaFRI.formas_y_condiciones H k (k + 1) i p.composicion.raices bc q.friComposicion p.composicion.final).mp hh.2.2.2.2.2
  simp only [aperturas, air, frit, fric, List.length_append, List.length_map, List.length_zip,
    List.length_ofFn, hh.1, ht.1, ht.2.1, ht.2.2.1, hc.1, hc.2.1, hc.2.2.1,
    AperturasFRI.cantidad, Nat.min_self]

@[expose] def Origen (k : ℕ) (p : Prueba) (a : Apertura) : Prop :=
  (a.raiz = p.raiz ∧ a.altura = k + 3) ∨
    (∃ j : Fin p.traza.raices.length, a.raiz = p.traza.raices[j] ∧ a.altura = k + 3 - j.val) ∨
    (∃ j : Fin p.composicion.raices.length, a.raiz = p.composicion.raices[j] ∧ a.altura = k + 3 - j.val)

theorem origenes (k i : ℕ) (p : Prueba) (bt bc : List Fp2) (q : Consulta)
    (a : Apertura) (hm : a ∈ aperturas k i p bt bc q) : Origen k p a := by
  rcases List.mem_append.mp hm with hm | hm
  · rcases List.mem_append.mp hm with hm | hm
    · obtain ⟨⟨x, j⟩, _, rfl⟩ := List.mem_map.mp hm
      exact Or.inl ⟨rfl, rfl⟩
    · exact Or.inr (Or.inl (by
        simpa only [Nat.zero_add] using AperturasFRI.origen_en_raices k 0 p.traza.raices bt q.friTraza ⟨i, none⟩ a hm))
  · exact Or.inr (Or.inr (by
      simpa only [Nat.zero_add] using AperturasFRI.origen_en_raices k 0 p.composicion.raices bc q.friComposicion ⟨i, none⟩ a hm))

end Nexus.Verificador.SoporteConsulta
