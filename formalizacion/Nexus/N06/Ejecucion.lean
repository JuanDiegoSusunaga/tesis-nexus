module

public import Nexus.N06.Compartida
public import Nexus.FRI.Experimento
import Mathlib.Tactic

/-!
# Ejecución causal de AIR y las dos fases FRI

El oráculo de traza se fija antes de los tres coeficientes AIR. Después se
ejecuta FRI de traza y luego FRI de composición. Cada oráculo recibe solo
las monedas de fases anteriores y su propio prefijo; las constantes finales
pueden depender de toda su fase. La muestra compartida se sortea al final.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

@[expose] def coeficientesRetos (a : Retos Fp2 3) : Nexus.N01.Coeficientes Fp2 :=
  (a.1, a.2.1, a.2.2.1)

/-- La estructura impide que el oráculo inicial reciba monedas AIR o FRI futuras. -/
structure PoliticaConsulta where
  inicial : Fp2 → Fp2
  traza : Retos Fp2 3 → ℕ → List Fp2 → Fp2 → Fp2
  composicion : Retos Fp2 3 → List Fp2 → ℕ → List Fp2 → Fp2 → Fp2
  constanteTraza : Retos Fp2 3 → List Fp2 → Fp2
  constanteComposicion : Retos Fp2 3 → List Fp2 → List Fp2 → Fp2

@[expose] def estrategiaTraza (p : PoliticaConsulta) (a : Retos Fp2 3)
    (j : ℕ) (h : List Fp2) : Fp2 → Fp2 :=
  if j = 0 then p.inicial else p.traza a j h

@[expose] def ejecutarPrefijo (k : ℕ) (p : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) : PrefijoConsulta where
  traza := estrategiaTraza p a
  composicion := p.composicion a (Nexus.FRI.historia (reto bt) k)
  betaTraza := reto bt
  betaComposicion := reto bc
  constanteTraza := p.constanteTraza a (Nexus.FRI.historia (reto bt) k)
  constanteComposicion := p.constanteComposicion a (Nexus.FRI.historia (reto bt) k)
    (Nexus.FRI.historia (reto bc) (k + 1))
  coeficientes := coeficientesRetos a

theorem ejecucion_traza_inicial (k : ℕ) (p : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) :
    oraculoTraza (ejecutarPrefijo k p a bt bc) 0 = p.inicial := by
  simp only [oraculoTraza, ejecutarPrefijo, estrategiaTraza, ite_eq_left]

/-- Media exacta de la aceptación: coeficientes AIR, FRI de traza, FRI de composición y muestra. -/
@[expose] noncomputable def probabilidadConjunta (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q : ℕ) : ℚ :=
  promedio (fun a : Retos Fp2 3 => promedio (fun bt : Retos Fp2 k =>
    promedio (fun bc : Retos Fp2 (k + 1) => probabilidadConsulta (dominioCapa k 1) q
      (AceptaCompartida k hk s o (ejecutarPrefijo k p a bt bc)))))

theorem promedio_cota {H : Type*} [Fintype H] [Nonempty H] (f : H → ℚ)
    (c : ℚ) (h : ∀ x, f x ≤ c) : promedio f ≤ c :=
  (promedio_monotono f (fun _ => c) h).trans_eq (promedio_constante c)

/-- Cota uniforme con la geometría concreta del perfil, para cualquier valor terminal. -/
theorem cota_terminal_perfil (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2) (f : Retos Fp2 m → ℚ)
    (h : ℚ) (hh : 0 ≤ h) (huno : ∀ xs, f xs ≤ 1)
    (hseguro : ∀ xs, SinExcepciones k m hk hm estrategia (reto xs) → f xs ≤ h) :
    promedio f ≤ h + (8 * 2 ^ k - 2 ^ (k + 3 - m) : ℕ) / (p : ℚ) ^ 2 := by
  have hb := Nexus.FRI.cota_terminal_adaptativa (torreGoldilocks k m hk hm) (1 / 8)
    (by norm_num) dos_extension_no_cero (margen_torre_goldilocks k m hk hm)
    estrategia f h hh huno hseguro
  have hfinal : ((torreGoldilocks k m hk hm).dominio m).card = 2 ^ (k + 3 - m) :=
    cardinal_dominio_capa k m hk (by omega)
  simpa only [cardinal_inicial_torre, hfinal, cardinal_extension, Nat.cast_pow] using hb

theorem coeficientes_retos_completos (a : Retos Fp2 3) :
    (coeficientesRetos a).1 = reto a 0 ∧ (coeficientesRetos a).2.1 = reto a 1 ∧
      (coeficientesRetos a).2.2 = reto a 2 := by
  exact ⟨rfl, rfl, rfl⟩

/-- La ronda crítica se fija a partir de f; su coste se añade al mismo valor terminal. -/
theorem cota_terminal_air (k : ℕ) (hk0 : 2 ≤ k) (hk : k ≤ 32)
    (f : Polynomial Fp2) (s o : Fp2)
    (hf : ¬ Nexus.AIR.Valida (raizExtension k) (2 ^ k) f s o)
    (g : Retos Fp2 3 → ℚ) (h : ℚ) (hh : 0 ≤ h) (huno : ∀ a, g a ≤ 1)
    (hseguro : ∀ a, Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f s o
      (coeficientesRetos a) % Nexus.AIR.denominador (2 ^ k) ≠ 0 → g a ≤ h) :
    promedio g ≤ h + 1 / (p : ℚ) ^ 2 := by
  classical
  let R := residuosPerfil k f s o
  have hn := residuos_perfil_no_nulos k hk0 hk f s o hf
  let j := rondaCritica R 3 hn
  have hj := ronda_critica_propiedades R 3 hn
  let B : ℕ → ℕ := fun i => if i = j then 1 else 0
  have hE : ∀ i estado, (excepcionesAIR R j i estado).card ≤ B i := by
    intro i estado
    by_cases hi : i = j
    · simpa only [excepcionesAIR, hi, ite_eq_left, B] using
        cancelantes_ronda_cardinal (R j) estado hj.2.1
    · simp only [excepcionesAIR, hi, reduceIte, Finset.card_empty, B, le_refl]
  have hb := cota_promedio_fuera_escape (excepcionesAIR R j) (pasoAIR R) B h hh hE
    0 3 0 g huno (by
      intro a ha
      apply hseguro a
      intro hz
      rcases a with ⟨a, b, c, z⟩
      cases z
      exact ha ((escape_air_iff_resto k f s o j hj.1 hj.2.2 (a, b, c)).mpr hz))
  have hJ : j < 3 := hj.1
  have hsum : (∑ i ∈ Finset.range 3, (B i : ℚ)) = 1 := by simp [B, hJ]
  simpa only [Nat.zero_add, hsum, cardinal_extension, Nat.cast_pow] using hb

end Nexus.Goldilocks
