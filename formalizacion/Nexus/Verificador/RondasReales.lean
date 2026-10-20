module

public import Nexus.Verificador.ExcesoRondas
import Mathlib.Tactic

/-!
# Clasificación algebraica de las excepciones del candidato real

Una excepción procede de la rama FRI de traza lejana, de una cancelación
AIR o de la rama FRI de composición lejana. Los retos y funciones son los
obtenidos de la vista concreta; aquí no se les asigna una ley ideal.
-/

public section
namespace Nexus.Verificador.RondasReales

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open VistaSemantica VistaCampo FiltroFalso ExcesoRondas Nexus.N06
open ProgramaBytes

@[expose] noncomputable def FallaTraza (v : Vista) (hk : v.datos.k ≤ 29) : Prop :=
  ∃ j : Fin v.datos.k, (prefijo v).betaTraza j ∈
    Nexus.FRI.excepciones (torreTraza v.datos.k hk) (1 / 8) (by norm_num)
      dos_extension_no_cero (margen_torre_goldilocks v.datos.k v.datos.k hk (Nat.le_succ _))
      j (oraculoTraza (prefijo v) j)

@[expose] noncomputable def FallaComposicion (v : Vista) (hk : v.datos.k ≤ 29) : Prop :=
  ∃ j : Fin (v.datos.k + 1), (prefijo v).betaComposicion j ∈
    Nexus.FRI.excepciones (torreComposicion v.datos.k hk) (1 / 8) (by norm_num)
      dos_extension_no_cero (margen_torre_goldilocks v.datos.k (v.datos.k + 1) hk (le_refl _))
      j (oraculoComposicion (prefijo v) j)

@[expose] noncomputable def Fallos (v : Vista) (hk : v.datos.k ≤ 29) : Prop :=
  (candidatoPerfil v.datos.k (oraculoTraza (prefijo v) 0) (1 / 8) = none ∧ FallaTraza v hk) ∨
  ∃ f : Polynomial Fp2,
    candidatoPerfil v.datos.k (oraculoTraza (prefijo v) 0) (1 / 8) = some f ∧
    (∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) ∧
    (Nexus.AIR.numeradorCombinado (2 ^ v.datos.k) (raizExtension v.datos.k) f
        (algebraMap Fp Fp2 v.datos.inicio) (algebraMap Fp Fp2 v.datos.salida)
        (prefijo v).coeficientes % Nexus.AIR.denominador (2 ^ v.datos.k) = 0 ∨
      (candidato (cosetExtension (v.datos.k + 3)) (oraculoComposicion (prefijo v) 0)
        (2 * 2 ^ v.datos.k) (1 / 8) = none ∧ FallaComposicion v hk))

theorem traza_iff (v : Vista) (hk : v.datos.k ≤ 29) :
    FallaTraza v hk ↔ ¬ SinExcepciones v.datos.k v.datos.k hk (Nat.le_succ _)
      (prefijo v).traza (prefijo v).betaTraza := by
  classical
  simp only [FallaTraza, SinExcepciones, not_forall, not_not, torreTraza, oraculoTraza]

theorem composicion_iff (v : Vista) (hk : v.datos.k ≤ 29) :
    FallaComposicion v hk ↔ ¬ SinExcepciones v.datos.k (v.datos.k + 1) hk (le_refl _)
      (prefijo v).composicion (prefijo v).betaComposicion := by
  classical
  simp only [FallaComposicion, SinExcepciones, not_forall, not_not, torreComposicion, oraculoComposicion]

theorem fallos_iff (v : Vista) (hk : v.datos.k ≤ 29) :
    Fallos v hk ↔ ¬ PrefijoSeguro v.datos.k hk v.datos.inicio v.datos.salida (prefijo v) := by
  classical
  cases ht : candidatoPerfil v.datos.k (oraculoTraza (prefijo v) 0) (1 / 8) with
  | none =>
    simp only [Fallos, PrefijoSeguro, ht]
    simp [traza_iff]
  | some f =>
    by_cases hb : ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f
    · cases hc : candidato (cosetExtension (v.datos.k + 3)) (oraculoComposicion (prefijo v) 0)
        (2 * 2 ^ v.datos.k) (1 / 8) with
      | none =>
        simp only [Fallos, PrefijoSeguro, ht]
        simp only [reduceCtorEq, Option.some.injEq, false_and, false_or, exists_eq_left']
        simp only [hb, hc, true_and, ite_true]
        rw [composicion_iff]
        tauto
      | some g =>
        simp only [Fallos, PrefijoSeguro, ht]
        simp only [reduceCtorEq, Option.some.injEq, false_and, false_or, exists_eq_left']
        simp only [hb, hc, true_and, ite_true]
        simp
    · simp only [Fallos, PrefijoSeguro, ht]
      simp only [reduceCtorEq, Option.some.injEq, false_and, false_or, exists_eq_left']
      simp [hb]

theorem excepcion_clasificada (t : Tabla Entrada Digest) (defecto s : Digest)
    (hx : Excepcion t defecto s) :
    ∃ d, ∃ hc : Canonico t defecto s d, Falso d ∧
      Fallos (construir t defecto d (ReconstruccionSelector.candidato t s))
        (by change d.k ≤ 29; have hk := hc.perfil.1.2; omega) := by
  obtain ⟨d, hc, hf, hx⟩ := hx
  exact ⟨d, hc, hf, (fallos_iff _ _).mpr hx⟩

theorem rondas_clasificadas {A : Type} (H : Entrada → Digest) (p : Programa A)
    (defecto : Digest) (N : ℕ) (hx : ExcesoRondas.Rondas H p defecto N) :
    ∃ n : Fin N, PoliticasPrefijo.Inicia H p defecto n.val ∧
      ∃ d, ∃ hc : Canonico
        (TablaObservada.tabla ((traza H p).take n.val)) defecto
        (SemillaProxima.semilla p defecto ((traza H p).take n.val)) d,
        Falso d ∧
          Fallos (construir (TablaObservada.tabla ((traza H p).take n.val)) defecto d
            (ReconstruccionSelector.candidato
              (TablaObservada.tabla ((traza H p).take n.val))
              (SemillaProxima.semilla p defecto ((traza H p).take n.val))))
            (by change d.k ≤ 29; have hk := hc.perfil.1.2; omega) := by
  obtain ⟨n, hi, he⟩ := hx
  exact ⟨n, hi, excepcion_clasificada _ _ _ he⟩

theorem rondas_inseguras {A : Type} (H : Entrada → Digest) (p : Programa A)
    (defecto : Digest) (N : ℕ) (hx : ExcesoRondas.Rondas H p defecto N) :
    ∃ n : Fin N, PoliticasPrefijo.Inicia H p defecto n.val ∧
      ∃ d, ∃ hc : Canonico
        (TablaObservada.tabla ((traza H p).take n.val)) defecto
        (SemillaProxima.semilla p defecto ((traza H p).take n.val)) d,
        Falso d ∧
          ¬ PrefijoSeguro d.k (by have hk := hc.perfil.1.2; omega) d.inicio d.salida
            (prefijo (construir (TablaObservada.tabla ((traza H p).take n.val)) defecto d
              (ReconstruccionSelector.candidato
                (TablaObservada.tabla ((traza H p).take n.val))
                (SemillaProxima.semilla p defecto ((traza H p).take n.val))))) := by
  obtain ⟨n, hi, ⟨d, hc, hf, hs⟩⟩ := hx
  exact ⟨n, hi, d, hc, hf, hs⟩

end Nexus.Verificador.RondasReales
