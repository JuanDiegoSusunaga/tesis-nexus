module

public import Nexus.N06.Estado
public import Nexus.N06.Solidez
public import Nexus.N06.Goldilocks
import Mathlib.Tactic

/-!
# Monitores causales de cada clase de reto

Los residuos y la rama de traza se fijan antes de AIR. La rama de
composición usa su oráculo inicial, fijado antes de sus retos FRI.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

@[expose] noncomputable def residuosVigilados (k : ℕ) (s o : Fp) (p : PoliticaConsulta) :
    ℕ → Polynomial Fp2 := by
  classical
  exact match candidatoPerfil k p.inicial (1 / 8) with
    | none => 0
    | some f => if (∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) then
        residuosPerfil k f (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o) else 0

@[expose] noncomputable def excepcionesCriticas (R : ℕ → Polynomial Fp2) :
    ℕ → Polynomial Fp2 → Finset Fp2 :=
  if hn : ∃ j < 3, R j ≠ 0 then excepcionesAIR R (rondaCritica R 3 hn) else fun _ _ => ∅

theorem excepciones_criticas_cardinal (R : ℕ → Polynomial Fp2)
    (i : ℕ) (estado : Polynomial Fp2) : (excepcionesCriticas R i estado).card ≤ 1 := by
  classical
  by_cases hn : ∃ j < 3, R j ≠ 0
  · have hj := ronda_critica_propiedades R 3 hn
    by_cases hi : i = rondaCritica R 3 hn
    · simpa only [excepcionesCriticas, hn, dite_eq_left, excepcionesAIR, hi, ite_eq_left] using
        cancelantes_ronda_cardinal (R (rondaCritica R 3 hn)) estado hj.2.1
    · simp only [excepcionesCriticas, hn, dite_eq_left, excepcionesAIR, hi,
        reduceIte, Finset.card_empty, zero_le]
  · simp only [excepcionesCriticas, hn, reduceDIte, Finset.card_empty, zero_le]

theorem excepciones_criticas_nulas (i : ℕ) (estado : Polynomial Fp2) :
    excepcionesCriticas 0 i estado = ∅ := by
  simp [excepcionesCriticas]

@[expose] noncomputable def vigilaTraza (k : ℕ) (p : PoliticaConsulta) : Prop :=
  candidatoPerfil k p.inicial (1 / 8) = none

@[expose] noncomputable def vigilaComposicion (k : ℕ) (p : PoliticaConsulta)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) : Prop := by
  classical
  exact match candidatoPerfil k p.inicial (1 / 8) with
    | none => False
    | some f => (∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) ∧
        candidato (cosetExtension (k + 3))
          (p.composicion a (Nexus.FRI.historia (reto bt) k) 0 []) (2 * 2 ^ k) (1 / 8) = none

@[expose] noncomputable def monitorTraza (k : ℕ) (hk : k ≤ 29) (p : PoliticaConsulta)
    (a : Retos Fp2 3) : ℕ → List Fp2 → Finset Fp2 := by
  classical
  exact if vigilaTraza k p then Nexus.FRI.excepcionesHistoria (torreTraza k hk) (1 / 8)
    (by norm_num) dos_extension_no_cero (margen_torre_goldilocks k k hk (Nat.le_succ k))
    (estrategiaTraza p a) else fun _ _ => ∅

@[expose] noncomputable def monitorComposicion (k : ℕ) (hk : k ≤ 29) (p : PoliticaConsulta)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) : ℕ → List Fp2 → Finset Fp2 := by
  classical
  exact if vigilaComposicion k p a bt then
    Nexus.FRI.excepcionesHistoria (torreComposicion k hk) (1 / 8)
      (by norm_num) dos_extension_no_cero (margen_torre_goldilocks k (k + 1) hk (le_refl _))
      (p.composicion a (Nexus.FRI.historia (reto bt) k)) else fun _ _ => ∅

theorem cambio_air_condicional (R : ℕ → Polynomial Fp2) (i : ℕ)
    (estado : Polynomial Fp2) (b : Bool) :
    probabilidadCambio b (excepcionesCriticas R i estado) ≤ 1 / (p : ℚ) ^ 2 := by
  apply (cambio_por_conjunto b _).trans
  rw [cardinal_extension, Nat.cast_pow]
  exact div_le_div_of_nonneg_right (by exact_mod_cast excepciones_criticas_cardinal R i estado)
    (by positivity)

theorem cambio_traza_condicional (k : ℕ) (hk : k ≤ 29) (p : PoliticaConsulta)
    (a : Retos Fp2 3) (j : Fin k) (h : List Fp2) (b : Bool) :
    probabilidadCambio b (monitorTraza k hk p a j h) ≤
      (4 * 2 ^ k : ℕ) / (Nexus.Goldilocks.p : ℚ) ^ 2 := by
  classical
  apply (cambio_por_conjunto b _).trans
  by_cases hv : vigilaTraza k p
  · simp only [monitorTraza, hv, ite_eq_left, Nexus.FRI.excepcionesHistoria, j.isLt, dite_eq_left]
    have hc := probabilidad_excepcion_capa k k hk (Nat.le_succ k) j (estrategiaTraza p a j h)
    simpa only [promedio_indicador, torreTraza] using hc
  · simp only [monitorTraza, hv, reduceIte, Finset.card_empty, Nat.cast_zero, zero_div]
    positivity

theorem cambio_composicion_condicional (k : ℕ) (hk : k ≤ 29) (p : PoliticaConsulta)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) (j : Fin (k + 1)) (h : List Fp2) (b : Bool) :
    probabilidadCambio b (monitorComposicion k hk p a bt j h) ≤
      (4 * 2 ^ k : ℕ) / (Nexus.Goldilocks.p : ℚ) ^ 2 := by
  classical
  apply (cambio_por_conjunto b _).trans
  by_cases hv : vigilaComposicion k p a bt
  · simp only [monitorComposicion, hv, ite_eq_left, Nexus.FRI.excepcionesHistoria, j.isLt, dite_eq_left]
    have hc := probabilidad_excepcion_capa k (k + 1) hk (le_refl _) j
      (p.composicion a (Nexus.FRI.historia (reto bt) k) j h)
    simpa only [promedio_indicador, torreComposicion] using hc
  · simp only [monitorComposicion, hv, reduceIte, Finset.card_empty, Nat.cast_zero, zero_div]
    positivity

end Nexus.Goldilocks
