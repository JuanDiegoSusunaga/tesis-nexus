module

public import Nexus.Verificador.FamiliasAceptadas
public import Nexus.ROM.PlanPrograma
import Mathlib.Tactic

/-!
# Riesgo de no reconstruir las familias en el experimento ROM

La cota corresponde al fallo de reconstrucción causal tras aceptar. No es
la probabilidad de aceptar un enunciado falso. Se conserva explícito el
presupuesto de altura del programa y la ley conjunta del selector sigue aparte.
-/

public section
namespace Nexus.Verificador.ExperimentoCausal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.N06
open FamiliasAceptadas

attribute [local instance] Classical.propDecidable

structure Politica (A : Type) where
  proponer : ProgramaBytes.Programa (List Octeto × A)
  atacar : A → Nexus.Canal.GramaticaTG2.Peticion → ProgramaBytes.Programa A
  actualizar : A → Nexus.Canal.GramaticaTG2.Peticion → Digest → A

@[expose] noncomputable def programa {A : Type} (u : Politica A) (bits R : ℕ) : ProgramaBytes.Programa Bool :=
  Adversario.ejecutar bits R u.proponer u.atacar u.actualizar

@[expose] noncomputable def tablaMuestreada {A : Type} (B S bits R : ℕ) (u : Politica A)
    (h : ProgramaBytes.altura (programa u bits R) ≤ S) (defecto : Digest) (xs : Retos Digest S) : Entrada → Digest :=
  funcionTabla defecto (ejecutar (PlanPrograma.experimento B S (programa u bits R) h) xs).tabla

@[expose] noncomputable def Conclusion {A : Type} (H : Entrada → Digest) (B bits R : ℕ) (u : Politica A) : Prop :=
  ∃ c, ∃ f : Familias H B (programa u bits R) (Nat.log2 c.enunciado.pasos) bits R c,
    Lectura.exacto codecCertificado.leer (ProgramaBytes.resultado H u.proponer).1 = some c ∧
    ∀ (defecto : Digest) (a : AperturasPrograma.Apertura),
      a ∈ SoporteCompleto.aperturas f.testigo → Congelada f defecto a

@[expose] noncomputable def Fallo {A : Type} (B S bits R : ℕ) (u : Politica A)
    (h : ProgramaBytes.altura (programa u bits R) ≤ S) (defecto : Digest) (xs : Retos Digest S) : Prop :=
  let H := tablaMuestreada B S bits R u h defecto xs
  ProgramaBytes.resultado H (programa u bits R) = true ∧ ¬ Conclusion H B bits R u

theorem familias_muestreadas {A : Type} (B S bits R : ℕ) (u : Politica A)
    (h : ProgramaBytes.altura (programa u bits R) ≤ S) (defecto : Digest) (xs : Retos Digest S)
    (hs : acierta (PlanPrograma.experimento B S (programa u bits R) h) xs = false)
    (ha : ProgramaBytes.resultado (tablaMuestreada B S bits R u h defecto xs) (programa u bits R) = true) :
    Conclusion (tablaMuestreada B S bits R u h defecto xs) B bits R u := by
  have hh := (PlanPrograma.memoria_realiza B S (programa u bits R) h xs hs defecto).2
  exact cierre_adversario _ B bits R u.proponer u.atacar u.actualizar hh ha

theorem fallo_implica_excepcion {A : Type} (B S bits R : ℕ) (u : Politica A)
    (h : ProgramaBytes.altura (programa u bits R) ≤ S) (defecto : Digest) (xs : Retos Digest S)
    (hf : Fallo B S bits R u h defecto xs) :
    acierta (PlanPrograma.experimento B S (programa u bits R) h) xs = true := by
  cases hb : acierta (PlanPrograma.experimento B S (programa u bits R) h) xs with
  | false => exact False.elim (hf.2 (familias_muestreadas B S bits R u h defecto xs hb hf.1))
  | true => rfl

theorem riesgo_fallo {A : Type} (B S bits R : ℕ) (u : Politica A)
    (h : ProgramaBytes.altura (programa u bits R) ≤ S) (defecto : Digest) :
    promedio (fun xs : Retos Digest S => if Fallo B S bits R u h defecto xs then 1 else 0) ≤
      riesgo (PlanPrograma.experimento B S (programa u bits R) h) := by
  rw [riesgo_es_promedio]
  apply promedio_monotono
  intro xs
  by_cases hf : Fallo B S bits R u h defecto xs
  · have hb := fallo_implica_excepcion B S bits R u h defecto xs hf
    simp only [hf, hb, ite_true, le_refl]
  · simp only [hf, ite_false]
    split <;> norm_num

theorem cota_fallo {A : Type} (B S bits R : ℕ) (u : Politica A)
    (h : ProgramaBytes.altura (programa u bits R) ≤ S) (defecto : Digest) :
    promedio (fun xs : Retos Digest S => if Fallo B S bits R u h defecto xs then 1 else 0) ≤
      min 1 (((S * (49 * S + B) : ℕ) : ℚ) / 2 ^ 256) :=
  (riesgo_fallo B S bits R u h defecto).trans (PlanPrograma.cota_excepcion B S (programa u bits R) h)

end Nexus.Verificador.ExperimentoCausal
