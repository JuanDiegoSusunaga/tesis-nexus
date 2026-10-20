module

public import Nexus.Verificador.VistaPrevia
import Mathlib.Tactic

/-!
# Conjuntos buenos definidos desde el pasado

Los predicados usan valores extraídos, enlaces AIR y el acarreo FRI, sin
aperturas futuras. Su conservación no demuestra todavía que toda aceptación
falsa esté cubierta ni proporciona una cota de sus cardinales.
-/

public section
namespace Nexus.Verificador.ConjuntosPrevios

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open CandidatoPrevio SemanticaPrevia VistaSemantica VistaPrevia Recorrido

@[expose] noncomputable def controlesFRI (k : ℕ) :
    ℕ → List (ℕ → Fp2) → List Fp2 → Estado → Fp2 → Prop
  | _, [], [], s, final => s.acarreo = some final
  | j, v :: vs, β :: bs, s, final =>
      let a := s.posicion % mitad k j
      let d : Apertura := ⟨v a, v (a + mitad k j), [], []⟩
      Compatible k j s d ∧ controlesFRI k (j + 1) vs bs (ProgramaFRI.siguiente k j s d β) final
  | _, _, _, _, _ => False

@[expose] def baseCanonica (v : Vista) (i : ℕ) : Prop :=
  ∀ j : Fin 6, let y := v.base (IndicesMaquina.posicionesNaturales (2 ^ (v.datos.k + 3)) i j)
    y = algebraMap Fp Fp2 y.re

@[expose] noncomputable def pruebaTraza (v : Vista) (i : ℕ) : Prop :=
  baseCanonica v i ∧
    match v.traza with
    | t :: _ => t i = v.base i ∧ t (i + 2 ^ (v.datos.k + 2)) = v.base (i + 2 ^ (v.datos.k + 2)) ∧
        v.traza.length = v.datos.k ∧ controlesFRI v.datos.k 0 v.traza
          ((v.retos.drop 3).take v.datos.k) ⟨i, none⟩ v.datos.vt
    | [] => False

@[expose] noncomputable def pruebaComposicion (v : Vista) (i : ℕ) : Prop :=
  baseCanonica v i ∧
    match v.composicion, v.retos.take 3 with
    | t :: _, [a0, a1, a2] =>
        let k := v.datos.k
        let x : Fp := 7 * raiz (k + 3) ^ i
        let f : Fin 6 → Fp := fun j => (v.base (IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i j)).re
        t i = componerBase (2 ^ k) (raiz k) v.datos.inicio v.datos.salida x
          (a0, a1, a2) ![f 0, f 1, f 2] ∧
        t (i + 2 ^ (k + 2)) = componerBase (2 ^ k) (raiz k) v.datos.inicio v.datos.salida (-x)
          (a0, a1, a2) ![f 3, f 4, f 5] ∧
        v.composicion.length = k + 1 ∧ controlesFRI k 0 v.composicion
          (v.retos.drop (3 + k)) ⟨i, none⟩ v.datos.vc
    | _, _ => False

@[expose] noncomputable def buenos (e : ℕ) (P : Vista → ℕ → Prop) (v : Vista) : Finset (Fin (2 ^ e)) := by
  classical
  exact Finset.univ.filter (fun i => v.datos.k + 2 = e ∧ P v i.val)

@[expose] noncomputable def politica (e : ℕ) (P : Vista → ℕ → Prop)
    (defecto s : Digest) (t : Tabla Entrada Digest) : Finset (Fin (2 ^ e)) :=
  match VistaSemantica.leer t defecto s with
  | none => ∅
  | some v => buenos e P v

@[expose] noncomputable def GT (e : ℕ) (defecto s : Digest) (t : Tabla Entrada Digest) : Finset (Fin (2 ^ e)) :=
  politica e pruebaTraza defecto s t

@[expose] noncomputable def GC (e : ℕ) (defecto s : Digest) (t : Tabla Entrada Digest) : Finset (Fin (2 ^ e)) :=
  politica e pruebaComposicion defecto s t

theorem pertenencia_buenos (e : ℕ) (P : Vista → ℕ → Prop) (v : Vista) (i : Fin (2 ^ e)) :
    i ∈ buenos e P v ↔ v.datos.k + 2 = e ∧ P v i.val := by
  classical
  simp only [buenos, Finset.mem_filter, Finset.mem_univ, true_and]

theorem lectura_fallida_sin_buenos (e : ℕ) (P : Vista → ℕ → Prop) (defecto s : Digest)
    (t : Tabla Entrada Digest) (h : VistaSemantica.leer t defecto s = none) :
    politica e P defecto s t = ∅ := by rw [politica, h]

theorem politica_antes {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k bits : ℕ} {c : Certificado} (r : Registro H B p k bits c) (hf : Forma k bits c)
    (e : ℕ) (P : Vista → ℕ → Prop) (defecto : Digest) :
    politica e P defecto (semillaCert H k bits c) r.corte.antes.tabla =
      buenos e P (construir (EjecucionBytes.final H (inicial B) p).tabla defecto
        (datosCert k bits c) (cadenaCert H k bits c)) := by
  rw [politica, vista_leida r hf defecto]

theorem conjuntos_antes {A : Type} {H : Entrada → Digest} {B : ℕ} {p : ProgramaBytes.Programa A}
    {k bits : ℕ} {c : Certificado} (r : Registro H B p k bits c) (hf : Forma k bits c)
    (e : ℕ) (defecto : Digest) :
    let v := construir (EjecucionBytes.final H (inicial B) p).tabla defecto
      (datosCert k bits c) (cadenaCert H k bits c)
    GT e defecto (semillaCert H k bits c) r.corte.antes.tabla = buenos e pruebaTraza v ∧
      GC e defecto (semillaCert H k bits c) r.corte.antes.tabla = buenos e pruebaComposicion v :=
  ⟨politica_antes r hf e pruebaTraza defecto, politica_antes r hf e pruebaComposicion defecto⟩

theorem misma_semilla_mismas_politicas {A : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa A} {k j bits otrosBits : ℕ} {c d : Certificado}
    (f : Registro H B p k bits c) (g : Registro H B p j otrosBits d)
    (hs : semillaCert H k bits c = semillaCert H j otrosBits d)
    (e : ℕ) (P : Vista → ℕ → Prop) (defecto : Digest) :
    politica e P defecto (semillaCert H k bits c) f.corte.antes.tabla =
      politica e P defecto (semillaCert H j otrosBits d) g.corte.antes.tabla := by
  rw [tabla_independiente f g hs, hs]

theorem consulta_compartida (e : ℕ) (P Q : Vista → ℕ → Prop) (v : Vista) (S : Finset (Fin (2 ^ e))) :
    S ⊆ buenos e P v ∩ buenos e Q v ↔
      ∀ i ∈ S, v.datos.k + 2 = e ∧ P v i.val ∧ Q v i.val := by
  constructor
  · intro h i hi
    have hh := Finset.mem_inter.mp (h hi)
    exact ⟨((pertenencia_buenos e P v i).mp hh.1).1,
      ((pertenencia_buenos e P v i).mp hh.1).2, ((pertenencia_buenos e Q v i).mp hh.2).2⟩
  · intro h i hi
    exact Finset.mem_inter.mpr ⟨(pertenencia_buenos e P v i).mpr ⟨(h i hi).1, (h i hi).2.1⟩,
      (pertenencia_buenos e Q v i).mpr ⟨(h i hi).1, (h i hi).2.2⟩⟩

end Nexus.Verificador.ConjuntosPrevios
