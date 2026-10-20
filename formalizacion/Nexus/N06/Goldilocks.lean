module

public import Nexus.FRI.Adaptativo
public import Nexus.FRI.Goldilocks
import Mathlib.Tactic

/-!
# Riesgo de las excepciones de FRI en el campo concreto

Son probabilidades del experimento interactivo con retos uniformes frescos.
No se presupone independencia de los eventos entre capas y no se modela
todavía el selector hash, la elección de rama AIR ni la consulta compartida.
-/

public section
namespace Nexus.Goldilocks

/-- En cada prefijo, el nuevo reto cae en el conjunto excepcional con probabilidad ≤4T/p². -/
theorem probabilidad_excepcion_capa (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1)
    (j : Fin m) (w : Fp2 → Fp2) :
    let t := torreGoldilocks k m hk hm
    Nexus.N06.promedio (fun β =>
      if β ∈ Nexus.FRI.excepciones t (1 / 8) (by norm_num) dos_extension_no_cero
        (margen_torre_goldilocks k m hk hm) j w then (1 : ℚ) else 0) ≤
      (4 * 2 ^ k : ℕ) / (p : ℚ) ^ 2 := by
  let t := torreGoldilocks k m hk hm
  dsimp only
  rw [Nexus.N06.promedio_indicador, cardinal_extension, Nat.cast_pow]
  apply div_le_div_of_nonneg_right _ (by positivity)
  have hE := Nexus.FRI.excepciones_cardinal t (1 / 8) (by norm_num)
    dos_extension_no_cero (margen_torre_goldilocks k m hk hm) j w
  have hsize : (t.dominio (j + 1)).card ≤ 4 * 2 ^ k := by
    change (dominioCapa k (j.val + 1)).card ≤ 4 * 2 ^ k
    rw [cardinal_dominio_capa k (j.val + 1) hk (by omega)]
    calc
      _ ≤ 2 ^ (k + 2) := Nat.pow_le_pow_right (by decide) (by omega)
      _ = _ := by norm_num [pow_add, Nat.mul_comm]
  exact_mod_cast hE.trans hsize

/-- Cota de una fase con oráculos que se adaptan a todos los retos anteriores. -/
theorem probabilidad_excepciones_torre (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2) :
    let t := torreGoldilocks k m hk hm
    Nexus.FRI.probabilidadExcepciones t (1 / 8) (by norm_num) dos_extension_no_cero
      (margen_torre_goldilocks k m hk hm) estrategia ≤
        (8 * 2 ^ k - 2 ^ (k + 3 - m) : ℕ) / (p : ℚ) ^ 2 := by
  have hbound := Nexus.FRI.cota_excepciones_adaptativas (torreGoldilocks k m hk hm)
    (1 / 8) (by norm_num) dos_extension_no_cero (margen_torre_goldilocks k m hk hm) estrategia
  have hfinal : ((torreGoldilocks k m hk hm).dominio m).card = 2 ^ (k + 3 - m) :=
    cardinal_dominio_capa k m hk (by omega)
  simpa only [cardinal_inicial_torre, hfinal, cardinal_extension, Nat.cast_pow] using hbound

/-- Las dos cotas se establecen por separado; no se multiplican probabilidades de FRI. -/
theorem probabilidades_excepciones_fases (k : ℕ) (hk : k ≤ 29)
    (traza composicion : ℕ → List Fp2 → Fp2 → Fp2) :
    Nexus.FRI.probabilidadExcepciones (torreTraza k hk) (1 / 8) (by norm_num)
      dos_extension_no_cero (margen_torre_goldilocks k k hk (by omega)) traza ≤
        (8 * 2 ^ k - 8 : ℕ) / (p : ℚ) ^ 2 ∧
    Nexus.FRI.probabilidadExcepciones (torreComposicion k hk) (1 / 8) (by norm_num)
      dos_extension_no_cero (margen_torre_goldilocks k (k + 1) hk (by omega)) composicion ≤
        (8 * 2 ^ k - 4 : ℕ) / (p : ℚ) ^ 2 := by
  constructor
  · have h := probabilidad_excepciones_torre k k hk (by omega) traza
    simpa only [torreTraza, show k + 3 - k = 3 by omega, show (2 : ℕ) ^ 3 = 8 by norm_num] using h
  · have h := probabilidad_excepciones_torre k (k + 1) hk (by omega) composicion
    simpa only [torreComposicion, show k + 3 - (k + 1) = 2 by omega,
      show (2 : ℕ) ^ 2 = 4 by norm_num] using h

/-- Consulta final de cuarenta parejas, condicionada al historial sin excepciones. -/
theorem consulta_adaptativa_goldilocks (k m : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (hm : m ≤ k + 1) (hm0 : 0 < m)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2) (β : ℕ → Fp2)
    (hβ : ∀ j : Fin m, β j ∉ Nexus.FRI.excepciones (torreGoldilocks k m hk hm)
      (1 / 8) (by norm_num) dos_extension_no_cero (margen_torre_goldilocks k m hk hm) j
      (estrategia j (Nexus.FRI.historia β j)))
    (G : Finset Fp2) (c : Fp2)
    (hG : G ⊆ (torreGoldilocks k m hk hm).dominio 1)
    (hacc : Nexus.FRI.Acepta (torreGoldilocks k m hk hm)
      (fun j => estrategia j (Nexus.FRI.historia β j)) (fun j => β j)
      (Nexus.FRI.elevar (representanteCapa k 0) G) c)
    (hfar : Nexus.FRI.Lejano (torreGoldilocks k m hk hm)
      (fun j => estrategia j (Nexus.FRI.historia β j)) (1 / 8)) :
    let D := (torreGoldilocks k m hk hm).dominio 1
    let prob : ℚ := (((D.powersetCard 40).filter (fun S => S ⊆ G)).card : ℚ) /
      (D.powersetCard 40).card
    prob ≤ Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8) ∧ prob ≤ (7 / 8 : ℚ) ^ 40 := by
  let t := torreGoldilocks k m hk hm
  have hM : (t.dominio 1).card = 4 * 2 ^ k := parejas_iniciales_torre k m hk hm
  have hq : 40 ≤ (t.dominio 1).card := by
    rw [hM]
    exact Nexus.Modelos.Omision.muestras_perfiles k hk0
  have hcast : ((1 / 8 : ℚ) : ℝ) = (1 / 8 : ℝ) := by norm_num
  have hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * ((1 / 8 : ℚ) : ℝ)) * (t.dominio (j + 1)).card := by
    rw [hcast]
    exact margen_torre_goldilocks k m hk hm
  have hβ' : ∀ j : Fin m, β j ∉ Nexus.FRI.excepciones t ((1 / 8 : ℚ) : ℝ)
      (by norm_num) dos_extension_no_cero hmargin j (estrategia j (Nexus.FRI.historia β j)) := by
    simpa only [hcast] using hβ
  have hfar' : Nexus.FRI.Lejano t (fun j => estrategia j (Nexus.FRI.historia β j))
      ((1 / 8 : ℚ) : ℝ) := by
    rw [hcast]
    exact hfar
  have hprob := Nexus.FRI.muestreo_adaptativo t hm0 estrategia β (1 / 8) (by norm_num)
    dos_extension_no_cero hmargin hβ' G c hG hacc hfar' 40 hq
  rw [hM] at hprob
  refine ⟨hprob, hprob.trans ?_⟩
  have hbound := Nexus.N05.H_le_potencia (4 * 2 ^ k) 40 (1 / 8) (by positivity)
    (Nexus.Modelos.Omision.muestras_perfiles k hk0) (by norm_num) (by norm_num)
  convert hbound using 1
  norm_num

end Nexus.Goldilocks
