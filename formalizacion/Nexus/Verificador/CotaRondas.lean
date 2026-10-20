module

public import Nexus.Verificador.PresupuestoGlobal
public import Nexus.Verificador.RondasReales
public import Nexus.Canal.UnionFiltrada
import Mathlib.Tactic

/-!
# Cota integrada con umbral algebraico y presupuesto derivado

El término de exceso se sustituye por el evento de rondas reales y B se
deriva de Q y del coste del verificador. Las probabilidades de excepción
ROM y de rondas permanecen explícitas, junto con el error de acoplamiento.
-/

public section
namespace Nexus.Verificador.CotaRondas

open Nexus.Bytes Nexus.Merkle Nexus.ROM Nexus.Canal Nexus.Goldilocks
open ProgramaBytes SelectorAdaptativo FiltroSelector PresupuestoGlobal

variable {A : Type}
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem hipergeometrica (k : ℕ) (hk0 : 4 ≤ k) :
    (Nat.choose (CardinalVista.umbral (k + 2)) 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 ≤ (7 / 8 : ℚ) ^ 40 := by
  have hM : (0 : ℕ) < 2 ^ (k + 2) := by positivity
  have hq : 40 ≤ 2 ^ (k + 2) := by
    have h := Nexus.Modelos.Omision.muestras_perfiles k hk0
    simpa only [pow_add, show (2 : ℕ) ^ 2 = 4 by decide, Nat.mul_comm] using h
  have hdiv : 8 * CardinalVista.umbral (k + 2) ≤ 7 * 2 ^ (k + 2) := by
    have h := Nat.div_mul_le_self (7 * 2 ^ (k + 2)) 8
    simpa only [CardinalVista.umbral, Nat.mul_comm] using h
  have hA : CardinalVista.umbral (k + 2) ≤ 2 ^ (k + 2) := by omega
  have hc := Nexus.N05.razon_binomial_le_potencia (CardinalVista.umbral (k + 2))
    (2 ^ (k + 2)) 40 hM hq hA
  have hratio : (CardinalVista.umbral (k + 2) : ℚ) / (2 ^ (k + 2) : ℕ) ≤ 7 / 8 := by
    apply (div_le_iff₀ (by positivity : (0 : ℚ) < (2 ^ (k + 2) : ℕ))).mpr
    have h : (8 : ℚ) * CardinalVista.umbral (k + 2) ≤ 7 * (2 ^ (k + 2) : ℕ) := by exact_mod_cast hdiv
    linarith
  exact hc.trans (pow_le_pow_left₀ (by positivity) hratio 40)

theorem omision_cuarenta : (7 / 8 : ℚ) ^ 40 ≤ 1 / 200 := by norm_num

theorem cota_512 (L bits k Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
        bits 512 proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar) ≤
    medida (fun H : universo p → Digest => ¬ EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p) +
    medida (fun H : universo p → Digest => ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p)) +
      ((Nat.choose (CardinalVista.umbral (k + 2)) 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 +
        1 / (2 : ℚ) ^ 300 + AcoplamientoCadena.error Digest 512 (Q + 24894)) * (Q + 24895) := by
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  have hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B Q 512 :=
    fun H => entradas_distintas _ bits 512 Q proponer atacar actualizar (hQ H)
  have hc := CotaFalsa.cota_512 L bits k (CardinalVista.umbral (k + 2)) (B Q 512)
    proponer atacar actualizar defecto hk0 hk1 hB
  have hu := ExcesoRondas.medida_exceso p defecto (altura p) (k + 2)
  have hsum := hc.trans (add_le_add (add_le_add (le_refl _) hu) (le_refl _))
  have hb : B Q 512 - 1 = Q + 24894 := by rw [presupuesto_512]; omega
  rw [hb, presupuesto_512] at hsum
  simpa only [Nat.cast_add, Nat.cast_ofNat] using hsum

theorem cota_rondas_condicional (p : Programa A) (defecto : Digest)
    (N R e g B : ℕ) (he : e ≤ 64) (hqM : 40 ≤ 2 ^ e) (hqR : 40 ≤ R)
    (hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B)
    (hpuente : ∀ H : universo p → Digest,
      ExcesoRondas.Rondas (oraculo p defecto H) p defecto N →
        ∃ n : Fin N,
          PoliticasPrefijo.Inicia (oraculo p defecto H) p defecto n.val ∧
          PoliticasFalsas.Omite (oraculo p defecto H) p defecto n.val R e g) :
    medida (fun H : universo p → Digest =>
      ExcesoRondas.Rondas (oraculo p defecto H) p defecto N) ≤
      ROM.SelectorPrimeras.riesgo R e 40 g (B - 1) * B := by
  apply (FiltroSelector.medida_monotona _ _ hpuente).trans
  exact Nexus.Canal.UnionFiltrada.cota_union p defecto N R e g B he hqM hqR hB

/-! Puente abstracto entre el evento real de rondas y el experimento de retos.
    La igualdad `hley` es la ley causal de primeras exposiciones; `hpuente`
    es la fijación del vector antes de su reto y la clasificación de toda
    ronda insegura como escape adaptativo. -/

theorem medida_rondas_le_riesgo {D S : Type} [Fintype D] [DecidableEq D]
    [Nonempty D] (p : Programa A) (defecto : Digest) (N : ℕ)
    (secuencia : (universo p → Digest) → Nexus.N06.Retos D N)
    (E : ℕ → S → Finset D) (paso : ℕ → S → D → S) (s : S)
    (hley : ∀ f : Nexus.N06.Retos D N → ℚ, Nexus.N06.promedio
      (fun H : universo p → Digest => f (secuencia H)) = Nexus.N06.promedio f)
    (hpuente : ∀ H : universo p → Digest,
      ExcesoRondas.Rondas (oraculo p defecto H) p defecto N →
        Nexus.N06.Escapa E paso 0 N s (secuencia H)) :
    medida (fun H : universo p → Digest =>
      ExcesoRondas.Rondas (oraculo p defecto H) p defecto N) ≤
      Nexus.N06.riesgo E paso (fun _ => 0) 0 N s := by
  classical
  calc
    _ = Nexus.N06.promedio (fun H : universo p → Digest =>
        if ExcesoRondas.Rondas (oraculo p defecto H) p defecto N then (1 : ℚ) else 0) := by
      exact Nexus.ROM.FiltroSelector.medida_media _
    _ ≤ Nexus.N06.promedio (fun H : universo p → Digest =>
        Nexus.N06.valor E paso (fun _ => 0) 0 N s (secuencia H)) := by
      apply Nexus.N06.promedio_monotono
      intro H
      by_cases hr : ExcesoRondas.Rondas (oraculo p defecto H) p defecto N
      · rw [Nexus.N06.valor_escape]
        simp [hr, hpuente H hr]
      · simp only [hr, reduceIte]
        rw [Nexus.N06.valor_escape]
        split <;> norm_num
    _ = Nexus.N06.promedio (fun xs : Nexus.N06.Retos D N =>
        Nexus.N06.valor E paso (fun _ => 0) 0 N s xs) := hley _
    _ = Nexus.N06.riesgo E paso (fun _ => 0) 0 N s := by
      symm
      exact Nexus.N06.riesgo_es_promedio E paso (fun _ => 0) 0 N s

theorem sustituir_excepciones {W : Type} [Fintype W]
    (Acepta SinBad Rondas : W → Prop) (cota epsSin epsRondas : ℚ)
    (hbase : medida Acepta ≤ medida (fun w => ¬ SinBad w) + medida Rondas + cota)
    (hsin : medida (fun w => ¬ SinBad w) ≤ epsSin)
    (hrondas : medida Rondas ≤ epsRondas) :
    medida Acepta ≤ epsSin + epsRondas + cota := by
  linarith

theorem cota_512_final (L bits k Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
        bits 512 proponer atacar actualizar ≤ Q)
    (epsSin epsRondas : ℚ) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    (medida (fun H : universo p → Digest =>
      ¬ EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p) ≤ epsSin) →
    (medida (fun H : universo p → Digest =>
      ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p)) ≤ epsRondas) →
    medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar) ≤
      epsSin + epsRondas +
        ((Nat.choose (CardinalVista.umbral (k + 2)) 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 +
          1 / (2 : ℚ) ^ 300 + AcoplamientoCadena.error Digest 512 (Q + 24894)) * (Q + 24895) := by
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  dsimp only
  intro hSin hRondas
  have hbase :
      medida (fun H : universo p → Digest =>
        PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar) ≤
      medida (fun H : universo p → Digest =>
        ¬ EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p) +
      medida (fun H : universo p → Digest =>
        ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p)) +
        ((Nat.choose (CardinalVista.umbral (k + 2)) 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 +
          1 / (2 : ℚ) ^ 300 + AcoplamientoCadena.error Digest 512 (Q + 24894)) * (Q + 24895) := by
    simpa only [p] using
      (cota_512 L bits k Q proponer atacar actualizar defecto hk0 hk1 hQ)
  exact sustituir_excepciones _ _ _ _ _ _ hbase hSin hRondas

end Nexus.Verificador.CotaRondas
