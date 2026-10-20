module

public import Nexus.N06.Monitores
import Mathlib.Tactic

/-!
# Estado alcanzado después de cada fase del protocolo ideal

La misma marca se conserva entre fases. Su valor cero antes de consultar
equivale al prefijo seguro de la cota de aceptación ya demostrada.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

@[expose] noncomputable def marcaAIR (k : ℕ) (s o : Fp) (p : PoliticaConsulta)
    (a : Retos Fp2 3) : Bool :=
  let R := residuosVigilados k s o p
  recorrerMarca (excepcionesCriticas R) (pasoAIR R) 0 3 0 false a

@[expose] noncomputable def marcaTraza (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) : Bool :=
  recorrerMarca (monitorTraza k hk p a) (fun _ h x => h ++ [x])
    0 k [] (marcaAIR k s o p a) bt

@[expose] noncomputable def marcaAntesConsulta (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) : Bool :=
  recorrerMarca (monitorComposicion k hk p a bt) (fun _ h x => h ++ [x])
    0 (k + 1) [] (marcaTraza k hk s o p a bt) bc

theorem marca_air_sin_residuos (k : ℕ) (s o : Fp) (p : PoliticaConsulta)
    (a : Retos Fp2 3) (hR : residuosVigilados k s o p = 0) : marcaAIR k s o p a = false := by
  have hn : ¬ ∃ j < 3, (0 : ℕ → Polynomial Fp2) j ≠ 0 := by simp
  simp only [marcaAIR, hR, excepcionesCriticas, hn, reduceDIte, recorrer_marca_vacia]

theorem marca_traza_inactiva (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (hv : ¬ vigilaTraza k p) :
    marcaTraza k hk s o p a bt = marcaAIR k s o p a := by
  simp only [marcaTraza, monitorTraza, hv, reduceIte, recorrer_marca_vacia]

theorem marca_composicion_inactiva (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (hv : ¬ vigilaComposicion k p a bt) :
    marcaAntesConsulta k hk s o p a bt bc = marcaTraza k hk s o p a bt := by
  simp only [marcaAntesConsulta, monitorComposicion, hv, reduceIte, recorrer_marca_vacia]

theorem marca_traza_activa (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (hv : vigilaTraza k p) :
    marcaTraza k hk s o p a bt = false ↔ marcaAIR k s o p a = false ∧
      SinExcepciones k k hk (Nat.le_succ k) (estrategiaTraza p a) (reto bt) := by
  simp only [marcaTraza, monitorTraza, hv, ite_eq_left, recorrer_marca_cero, torreTraza]
  rw [Nexus.FRI.escape_historia_iff]
  rfl

theorem marca_composicion_activa (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (hv : vigilaComposicion k p a bt) :
    marcaAntesConsulta k hk s o p a bt bc = false ↔ marcaTraza k hk s o p a bt = false ∧
      SinExcepciones k (k + 1) hk (le_refl _)
        (p.composicion a (Nexus.FRI.historia (reto bt) k)) (reto bc) := by
  simp only [marcaAntesConsulta, monitorComposicion, hv, ite_eq_left, recorrer_marca_cero, torreComposicion]
  rw [Nexus.FRI.escape_historia_iff]
  rfl

theorem marca_air_base (k : ℕ) (hk0 : 2 ≤ k) (hk : k ≤ 32) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (f : Polynomial Fp2)
    (hc : candidatoPerfil k p.inicial (1 / 8) = some f)
    (hb : ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f)
    (hf : ¬ Nexus.AIR.Valida (raizExtension k) (2 ^ k) f
      (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o)) :
    marcaAIR k s o p a = false ↔
      Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f
        (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o) (coeficientesRetos a) %
          Nexus.AIR.denominador (2 ^ k) ≠ 0 := by
  classical
  let R := residuosPerfil k f (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o)
  have hn := residuos_perfil_no_nulos k hk0 hk f _ _ hf
  have hj := ronda_critica_propiedades R 3 hn
  have hR : residuosVigilados k s o p = R := by
    simp only [residuosVigilados, hc, hb, ite_eq_left, R]
  have hE : excepcionesCriticas R = excepcionesAIR R (rondaCritica R 3 hn) := by
    unfold excepcionesCriticas
    split
    · rfl
    · rename_i hno
      exact (hno hn).elim
  simp only [marcaAIR, hR, hE, recorrer_marca_cero, true_and]
  rcases a with ⟨a, b, c, z⟩
  cases z
  exact not_congr (escape_air_iff_resto k f _ _ (rondaCritica R 3 hn) hj.1 hj.2.2 (a, b, c))

theorem ejecucion_composicion_inicial (k : ℕ) (p : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) :
    oraculoComposicion (ejecutarPrefijo k p a bt bc) 0 =
      p.composicion a (Nexus.FRI.historia (reto bt) k) 0 [] := rfl

/-- El estado alcanzado, no una hipótesis adicional de seguridad, determina el prefijo seguro. -/
theorem estado_cero_iff_prefijo_seguro (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) :
    marcaAntesConsulta k hk s o p a bt bc = false ↔
      PrefijoSeguro k hk s o (ejecutarPrefijo k p a bt bc) := by
  classical
  cases hc : candidatoPerfil k p.inicial (1 / 8) with
  | none =>
    have hv : ¬ vigilaComposicion k p a bt := by simp only [vigilaComposicion, hc, not_false_eq_true]
    have hR : residuosVigilados k s o p = 0 := by simp only [residuosVigilados, hc]
    rw [marca_composicion_inactiva k hk s o p a bt bc hv,
      marca_traza_activa k hk s o p a bt hc, marca_air_sin_residuos k s o p a hR]
    simp only [true_and, PrefijoSeguro, ejecucion_traza_inicial, hc]
    rfl
  | some f =>
    have ht : ¬ vigilaTraza k p := by simp only [vigilaTraza, hc, reduceCtorEq, not_false_eq_true]
    by_cases hb : ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f
    · have hp := candidato_propiedad _ p.inicial _ (1 / 8) f hc
      have hf := invalidez_candidato_base k s o f hp.1 hb hfalso
      have hAIR := marca_air_base k (by omega) (by omega) s o p a f hc hb hf
      cases hv : candidato (cosetExtension (k + 3))
          (p.composicion a (Nexus.FRI.historia (reto bt) k) 0 []) (2 * 2 ^ k) (1 / 8) with
      | none =>
        have hvig : vigilaComposicion k p a bt := by
          simp only [vigilaComposicion, hc, hb, hv, and_self]
        rw [marca_composicion_activa k hk s o p a bt bc hvig,
          marca_traza_inactiva k hk s o p a bt ht, hAIR]
        simp only [PrefijoSeguro, ejecucion_traza_inicial, hc, hb, ite_eq_left,
          ejecucion_composicion_inicial, hv]
        rfl
      | some g =>
        have hvig : ¬ vigilaComposicion k p a bt := by
          simp only [vigilaComposicion, hc, hv, reduceCtorEq, and_false, not_false_eq_true]
        rw [marca_composicion_inactiva k hk s o p a bt bc hvig,
          marca_traza_inactiva k hk s o p a bt ht, hAIR]
        simp only [PrefijoSeguro, ejecucion_traza_inicial, hc, hb, ite_eq_left,
          ejecucion_composicion_inicial, hv, and_true]
        rfl
    · have hv : ¬ vigilaComposicion k p a bt := by simp only [vigilaComposicion, hc, hb, false_and, not_false_eq_true]
      have hR : residuosVigilados k s o p = 0 := by simp only [residuosVigilados, hc, hb, reduceIte]
      rw [marca_composicion_inactiva k hk s o p a bt bc hv,
        marca_traza_inactiva k hk s o p a bt ht, marca_air_sin_residuos k s o p a hR]
      simp only [PrefijoSeguro, ejecucion_traza_inicial, hc, hb, reduceIte]

end Nexus.Goldilocks
