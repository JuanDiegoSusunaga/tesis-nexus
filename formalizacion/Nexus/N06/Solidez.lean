module

public import Nexus.N06.Ejecucion
import Mathlib.Tactic

/-!
# Solidez del experimento interactivo con consulta compartida

La rama se elige a partir del único oráculo inicial, antes de AIR. Si la
traza es lejana solo se paga FRI de traza; si el candidato es base solo se
pagan la cancelación AIR y FRI de composición. Las fases comparten la misma
muestra: no se multiplican sus probabilidades de aceptación.

El resultado corresponde a retos uniformes interactivos y oráculos ideales.
La vinculación con compromisos, Fiat–Shamir y el ejecutable queda pendiente.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

theorem ejecucion_segura_traza (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (hc : candidatoPerfil k p.inicial (1 / 8) = none)
    (hs : SinExcepciones k k hk (Nat.le_succ k) (estrategiaTraza p a) (reto bt)) :
    PrefijoSeguro k hk s o (ejecutarPrefijo k p a bt bc) := by
  simp only [PrefijoSeguro, ejecucion_traza_inicial, hc]
  exact hs

theorem ejecucion_segura_no_base (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (f : Polynomial Fp2) (hc : candidatoPerfil k p.inicial (1 / 8) = some f)
    (hb : ¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) :
    PrefijoSeguro k hk s o (ejecutarPrefijo k p a bt bc) := by
  simp only [PrefijoSeguro, ejecucion_traza_inicial, hc, hb, reduceIte]

theorem ejecucion_segura_base (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (f : Polynomial Fp2) (hc : candidatoPerfil k p.inicial (1 / 8) = some f)
    (hb : ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f)
    (hr : Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f
      (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o) (coeficientesRetos a) %
        Nexus.AIR.denominador (2 ^ k) ≠ 0)
    (hs : SinExcepciones k (k + 1) hk (le_refl _)
      (p.composicion a (Nexus.FRI.historia (reto bt) k)) (reto bc)) :
    PrefijoSeguro k hk s o (ejecutarPrefijo k p a bt bc) := by
  classical
  simp only [PrefijoSeguro, ejecucion_traza_inicial, hc, hb, ite_eq_left]
  refine ⟨hr, ?_⟩
  split
  · exact hs
  · trivial

/-- Un valor terminal acotado sobre prefijos seguros paga únicamente las
excepciones de la rama activa de la ejecución causal. -/
theorem cota_terminal_conjunta (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (s o : Fp) (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (g : PrefijoConsulta → ℚ) (H : ℚ) (hH : 0 ≤ H) (huno : ∀ h, g h ≤ 1)
    (hseguro : ∀ h, PrefijoSeguro k hk s o h → g h ≤ H) :
    promedio (fun a : Retos Fp2 3 => promedio (fun bt : Retos Fp2 k =>
      promedio (fun bc : Retos Fp2 (k + 1) => g (ejecutarPrefijo k p a bt bc)))) ≤ H +
      (8 * 2 ^ k - 3 : ℕ) / (Nexus.Goldilocks.p : ℚ) ^ 2 := by
  classical
  let v := fun (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) =>
    g (ejecutarPrefijo k p a bt bc)
  have hvuno : ∀ a bt bc, v a bt bc ≤ 1 := fun a bt bc => huno (ejecutarPrefijo k p a bt bc)
  have hvseg : ∀ a bt bc, PrefijoSeguro k hk s o (ejecutarPrefijo k p a bt bc) → v a bt bc ≤ H :=
    fun a bt bc => hseguro (ejecutarPrefijo k p a bt bc)
  have hT : 0 < 2 ^ k := by positivity
  change promedio (fun a : Retos Fp2 3 => promedio (fun bt : Retos Fp2 k =>
    promedio (v a bt))) ≤ _
  cases hc : candidatoPerfil k p.inicial (1 / 8) with
  | none =>
    apply (promedio_cota _ (H + (8 * 2 ^ k - 8 : ℕ) / (Nexus.Goldilocks.p : ℚ) ^ 2) ?_).trans
    · apply add_le_add (le_refl H)
      exact div_le_div_of_nonneg_right (by exact_mod_cast
        (show 8 * 2 ^ k - 8 ≤ 8 * 2 ^ k - 3 by omega)) (by positivity)
    · intro a
      have hb := cota_terminal_perfil k k hk (Nat.le_succ k) (estrategiaTraza p a)
        (fun bt => promedio (v a bt)) H hH
        (fun bt => promedio_cota _ 1 (hvuno a bt)) (by
          intro bt hs
          exact promedio_cota _ H (fun bc => hvseg a bt bc
            (ejecucion_segura_traza k hk s o p a bt bc hc hs)))
      simpa only [show k + 3 - k = 3 by omega, show (2 : ℕ) ^ 3 = 8 by norm_num] using hb
  | some f =>
    by_cases hb : ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f
    · have hp := candidato_propiedad _ p.inicial _ (1 / 8) f hc
      have hinval := invalidez_candidato_base k s o f hp.1 hb hfalso
      let C : ℚ := H + (8 * 2 ^ k - 4 : ℕ) / (Nexus.Goldilocks.p : ℚ) ^ 2
      have hC : 0 ≤ C := add_nonneg hH (by positivity)
      have hbound := cota_terminal_air k (by omega) (by omega) f _ _ hinval
        (fun a => promedio (fun bt => promedio (v a bt))) C hC
        (fun a => promedio_cota _ 1 (fun bt => promedio_cota _ 1 (hvuno a bt))) (by
          intro a hr
          apply promedio_cota _ C
          intro bt
          have hbnd := cota_terminal_perfil k (k + 1) hk (le_refl _)
            (p.composicion a (Nexus.FRI.historia (reto bt) k)) (v a bt) H hH (hvuno a bt) (by
              intro bc hs
              exact hvseg a bt bc (ejecucion_segura_base k hk s o p a bt bc f hc hb hr hs))
          simpa only [show k + 3 - (k + 1) = 2 by omega,
            show (2 : ℕ) ^ 2 = 4 by norm_num] using hbnd)
      apply hbound.trans_eq
      dsimp [C]
      rw [Nat.cast_sub (show 4 ≤ 8 * 2 ^ k by omega),
        Nat.cast_sub (show 3 ≤ 8 * 2 ^ k by omega)]
      push_cast
      ring
    · apply (promedio_cota _ H ?_).trans
      · exact le_add_of_nonneg_right (by positivity)
      · intro a
        apply promedio_cota _ H
        intro bt
        exact promedio_cota _ H (fun bc => hvseg a bt bc
          (ejecucion_segura_no_base k hk s o p a bt bc f hc hb))

/-- Probabilidad de producir un prefijo inseguro, incluyendo todas las monedas de las tres fases. -/
@[expose] noncomputable def probabilidadPrefijoInseguro (k : ℕ) (hk : k ≤ 29)
    (s o : Fp) (p : PoliticaConsulta) : ℚ := by
  classical
  exact promedio (fun a : Retos Fp2 3 => promedio (fun bt : Retos Fp2 k =>
    promedio (fun bc : Retos Fp2 (k + 1) =>
      if PrefijoSeguro k hk s o (ejecutarPrefijo k p a bt bc) then 0 else 1)))

theorem cota_prefijo_inseguro (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (s o : Fp) (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o) :
    probabilidadPrefijoInseguro k hk s o p ≤
      (8 * 2 ^ k - 3 : ℕ) / (Nexus.Goldilocks.p : ℚ) ^ 2 := by
  classical
  simpa only [probabilidadPrefijoInseguro, zero_add] using
    cota_terminal_conjunta k hk0 hk s o p hfalso
      (fun h => if PrefijoSeguro k hk s o h then 0 else 1) 0 (le_refl _)
      (by intro h; split_ifs <;> norm_num)
      (by intro h hs; simp only [hs, reduceIte, le_refl])

/-- Cota conjunta ordinaria para todas las transcripciones, incluidas las excepcionales. -/
theorem solidez_interactiva_compartida (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (s o : Fp) (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) :
    probabilidadConjunta k hk s o p q ≤ Nexus.N05.H (4 * 2 ^ k) q (1 / 8) +
      (8 * 2 ^ k - 3 : ℕ) / (Nexus.Goldilocks.p : ℚ) ^ 2 := by
  have hD : (dominioCapa k 1).card = 4 * 2 ^ k := parejas_iniciales_torre k k hk (Nat.le_succ k)
  exact cota_terminal_conjunta k hk0 hk s o p hfalso
    (fun h => probabilidadConsulta (dominioCapa k 1) q (AceptaCompartida k hk s o h))
    (Nexus.N05.H (4 * 2 ^ k) q (1 / 8)) (by unfold Nexus.N05.H; positivity)
    (fun _ => consulta_le_uno _ q _ (by rw [hD]; exact hq))
    (fun h hs => consulta_compartida_perfil k hk0 hk s o h hs q hq)

theorem solidez_interactiva_cuarenta (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (s o : Fp) (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o) :
    probabilidadConjunta k hk s o p 40 ≤ (7 / 8 : ℚ) ^ 40 +
      (8 * 2 ^ k - 3 : ℕ) / (Nexus.Goldilocks.p : ℚ) ^ 2 := by
  have hq := Nexus.Modelos.Omision.muestras_perfiles k hk0
  apply (solidez_interactiva_compartida k hk0 hk s o p hfalso 40 hq).trans
  apply add_le_add _ (le_refl _)
  have hbound := Nexus.N05.H_le_potencia (4 * 2 ^ k) 40 (1 / 8)
    (by positivity) hq (by norm_num) (by norm_num)
  convert hbound using 1
  norm_num

/-- Enlace de la desigualdad probabilística con el lado derecho exacto tabulado. -/
theorem solidez_interactiva_limite_tabla (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (s o : Fp) (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o) :
    probabilidadConjunta k hk s o p 40 ≤ Nexus.Modelos.Omision.limiteIdeal (2 ^ k) := by
  have hq := Nexus.Modelos.Omision.muestras_perfiles k hk0
  have hb := solidez_interactiva_compartida k hk0 hk s o p hfalso 40 hq
  have hT : 0 < 2 ^ k := by positivity
  simpa only [Nexus.Modelos.Omision.limiteIdeal,
    Nat.cast_sub (show 3 ≤ 8 * 2 ^ k by omega), Nat.cast_mul, Nat.cast_ofNat] using hb

theorem solidez_interactiva_tabla6_22 (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (s o : Fp) (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (i : Fin 4) (hperfil : 2 ^ k = Nexus.Modelos.Omision.filas i) :
    probabilidadConjunta k hk s o p 40 ≤ Nexus.Modelos.Omision.superior i := by
  apply (solidez_interactiva_limite_tabla k hk0 hk s o p hfalso).trans
  rw [hperfil]
  exact (Nexus.Modelos.Omision.tabla6_22 i).1

end Nexus.Goldilocks
