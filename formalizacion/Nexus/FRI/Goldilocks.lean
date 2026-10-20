module

public import Nexus.FRI.Cosets
public import Nexus.FRI.Muestreo
public import Nexus.FRI.Presupuesto
public import Nexus.Modelos.Omision
import Mathlib.Tactic

/-!
# Torres concretas de traza y composición

Las relaciones de Torre se construyen a partir de las raíces Goldilocks y
los índices de los cosets. La familia de oráculos u sigue fija: aquí no se
afirma todavía la cota probabilística adaptativa del IOP ni su equivalencia
con las aperturas del ejecutable.
-/

public section
namespace Nexus.Goldilocks

open scoped BigOperators

@[expose] noncomputable def torreGoldilocks (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1) :
    Nexus.FRI.Torre Fp2 m where
  dominio := dominioCapa k
  raiz := representanteCapa k
  grado := fun j => 2 ^ (m - j)
  cuadrado := by
    intro j hj y hy
    exact representante_cuadrado k j hk (by omega) y hy
  noCero := by
    intro j hj y _
    exact representante_no_cero k j hk (by omega) y
  enlace := by
    intro j hj
    exact enlace_dominios_capa k j hk (by omega)
  grados := by
    intro j hj
    have hexp : m - j = m - (j + 1) + 1 := by omega
    rw [hexp, pow_succ, Nat.mul_comm]
  grado_final := by simp
  final_no_vacio := by
    rw [cardinal_dominio_capa k m hk (by omega)]
    positivity

@[expose] noncomputable def torreTraza (k : ℕ) (hk : k ≤ 29) : Nexus.FRI.Torre Fp2 k :=
  torreGoldilocks k k hk (by omega)

@[expose] noncomputable def torreComposicion (k : ℕ) (hk : k ≤ 29) : Nexus.FRI.Torre Fp2 (k + 1) :=
  torreGoldilocks k (k + 1) hk (by omega)

/-- Las dos fases empiezan en el dominio ya utilizado por AIR y por N03. -/
theorem torres_dominio_inicial (k : ℕ) (hk : k ≤ 29) :
    (torreTraza k hk).dominio 0 = cosetExtension (k + 3) ∧
      (torreComposicion k hk).dominio 0 = cosetExtension (k + 3) := by
  exact ⟨dominio_capa_inicial k, dominio_capa_inicial k⟩

theorem torres_grados_iniciales (k : ℕ) (hk : k ≤ 29) :
    (torreTraza k hk).grado 0 = 2 ^ k ∧
      (torreComposicion k hk).grado 0 = 2 * 2 ^ k := by
  simp [torreTraza, torreComposicion, torreGoldilocks,
    pow_succ, Nat.mul_comm]

theorem torres_dominios_finales (k : ℕ) (hk : k ≤ 29) :
    ((torreTraza k hk).dominio k).card = 8 ∧
      ((torreComposicion k hk).dominio (k + 1)).card = 4 := by
  change (dominioCapa k k).card = 8 ∧ (dominioCapa k (k + 1)).card = 4
  rw [cardinal_dominio_capa k k hk (by omega),
    cardinal_dominio_capa k (k + 1) hk (by omega)]
  norm_num [show k + 3 - k = 3 by omega, show k + 3 - (k + 1) = 2 by omega]

theorem cardinal_inicial_torre (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1) :
    ((torreGoldilocks k m hk hm).dominio 0).card = 8 * 2 ^ k := by
  change (dominioCapa k 0).card = 8 * 2 ^ k
  rw [cardinal_dominio_capa k 0 hk (by omega)]
  norm_num [pow_add, Nat.mul_comm]

theorem parejas_iniciales_torre (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1) :
    ((torreGoldilocks k m hk hm).dominio 1).card = 4 * 2 ^ k := by
  change (dominioCapa k 1).card = 4 * 2 ^ k
  rw [cardinal_dominio_capa k 1 hk (by omega)]
  have hexp : k + 3 - 1 = k + 2 := by omega
  rw [hexp, pow_add]
  norm_num [Nat.mul_comm]

/-- El margen de composición domina todos los grados de m≤k+1 plegados. -/
theorem margen_torre_goldilocks (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1) (j : Fin m) :
    (((torreGoldilocks k m hk hm).grado (j + 1)) : ℝ) - 1 <
      (1 - 3 * (1 / 8 : ℝ)) * ((torreGoldilocks k m hk hm).dominio (j + 1)).card := by
  change ((2 ^ (m - (j.val + 1)) : ℕ) : ℝ) - 1 <
    (1 - 3 * (1 / 8 : ℝ)) * (dominioCapa k (j.val + 1)).card
  rw [cardinal_dominio_capa k (j.val + 1) hk (by omega)]
  have hexp : k + 3 - (j.val + 1) = k + 2 - j.val := by omega
  rw [hexp]
  have hle : ((2 ^ (m - (j.val + 1)) : ℕ) : ℝ) ≤ (2 ^ (k - j.val) : ℕ) := by
    exact_mod_cast Nat.pow_le_pow_right (by decide : 0 < 2) (by omega : m - (j.val + 1) ≤ k - j.val)
  have hmargin := Nexus.N04.margen_capas_composicion k j.val (by omega)
  linarith

/-- Conteos de excepciones de las dos fases, sin convertirlos aún en probabilidades. -/
theorem presupuestos_torres (k : ℕ) (hk : k ≤ 29)
    (Et : Fin k → Finset Fp2) (Ec : Fin (k + 1) → Finset Fp2)
    (ht : ∀ j, (Et j).card ≤ ((torreTraza k hk).dominio (j + 1)).card)
    (hc : ∀ j, (Ec j).card ≤ ((torreComposicion k hk).dominio (j + 1)).card) :
    (∑ j, (Et j).card) ≤ 8 * 2 ^ k - 8 ∧
      (∑ j, (Ec j).card) ≤ 8 * 2 ^ k - 4 := by
  have htrace := Nexus.FRI.suma_excepciones (torreTraza k hk) dos_extension_no_cero Et ht
  have hcomp := Nexus.FRI.suma_excepciones (torreComposicion k hk) dos_extension_no_cero Ec hc
  have hfinal := torres_dominios_finales k hk
  rw [hfinal.1] at htrace
  rw [hfinal.2] at hcomp
  exact ⟨by simpa only [torreTraza, cardinal_inicial_torre] using htrace,
    by simpa only [torreComposicion, cardinal_inicial_torre] using hcomp⟩

/-- Muestreo completo sobre los cosets construidos, para cualquiera de las dos fases.
La cota sigue condicionada a evitar los retos excepcionales de la fase. -/
theorem muestreo_torre_goldilocks (k m : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (hm : m ≤ k + 1) (hm0 : 0 < m) (u : ℕ → Fp2 → Fp2) :
    let t := torreGoldilocks k m hk hm
    ∃ E : Fin m → Finset Fp2,
      (∀ j, (E j).card ≤ (t.dominio (j + 1)).card) ∧
      ∀ β : Fin m → Fp2, (∀ j, β j ∉ E j) →
      ∀ (G : Finset Fp2) (c : Fp2), G ⊆ t.dominio 1 →
        Nexus.FRI.Acepta t u β (Nexus.FRI.elevar (t.raiz 0) G) c →
        Nexus.FRI.Lejano t u (1 / 8) →
        let prob : ℚ := ((((t.dominio 1).powersetCard 40).filter (fun S => S ⊆ G)).card : ℚ) /
          ((t.dominio 1).powersetCard 40).card
        prob ≤ Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8) ∧ prob ≤ (7 / 8 : ℚ) ^ 40 := by
  let t := torreGoldilocks k m hk hm
  have hM : (t.dominio 1).card = 4 * 2 ^ k := parejas_iniciales_torre k m hk hm
  have hq : 40 ≤ (t.dominio 1).card := by
    rw [hM]
    exact Nexus.Modelos.Omision.muestras_perfiles k hk0
  have hcast : ((1 / 8 : ℚ) : ℝ) = (1 / 8 : ℝ) := by norm_num
  have hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * ((1 / 8 : ℚ) : ℝ)) * (t.dominio (j + 1)).card := by
    intro j
    rw [hcast]
    exact margen_torre_goldilocks k m hk hm j
  obtain ⟨E, hE, hsample⟩ := Nexus.FRI.lema_B_muestreo t hm0 u (1 / 8) (by norm_num)
    dos_extension_no_cero hmargin 40 hq
  refine ⟨E, hE, ?_⟩
  intro β hβ G c hG hacc hfar
  have hfar' : Nexus.FRI.Lejano t u ((1 / 8 : ℚ) : ℝ) := by
    rw [hcast]
    exact hfar
  have hprob := hsample β hβ G c hG hacc hfar'
  rw [hM] at hprob
  refine ⟨hprob, hprob.trans ?_⟩
  have hbound := Nexus.N05.H_le_potencia (4 * 2 ^ k) 40 (1 / 8) (by positivity)
    (Nexus.Modelos.Omision.muestras_perfiles k hk0) (by norm_num) (by norm_num)
  convert hbound using 1
  norm_num

end Nexus.Goldilocks
