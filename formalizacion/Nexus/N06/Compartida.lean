module

public import Nexus.N06.Parejas
public import Nexus.FRI.Consulta
import Mathlib.Tactic

/-!
# La única consulta compartida del perfil δt=δc=1/8

Un prefijo fija los coeficientes, las estrategias FRI, sus retos y constantes.
La muestra se sortea después. Solo se exige ausencia de excepciones en la
rama activa: traza lejana, no base, composición lejana o enlace local.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

structure PrefijoConsulta where
  traza : ℕ → List Fp2 → Fp2 → Fp2
  composicion : ℕ → List Fp2 → Fp2 → Fp2
  betaTraza : ℕ → Fp2
  betaComposicion : ℕ → Fp2
  constanteTraza : Fp2
  constanteComposicion : Fp2
  coeficientes : Nexus.N01.Coeficientes Fp2

@[expose] def oraculoTraza (h : PrefijoConsulta) (j : ℕ) : Fp2 → Fp2 :=
  h.traza j (Nexus.FRI.historia h.betaTraza j)

@[expose] def oraculoComposicion (h : PrefijoConsulta) (j : ℕ) : Fp2 → Fp2 :=
  h.composicion j (Nexus.FRI.historia h.betaComposicion j)

@[expose] noncomputable def SinExcepciones (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2) (β : ℕ → Fp2) : Prop :=
  ∀ j : Fin m, β j ∉ Nexus.FRI.excepciones (torreGoldilocks k m hk hm) (1 / 8)
    (by norm_num) dos_extension_no_cero (margen_torre_goldilocks k m hk hm) j
    (estrategia j (Nexus.FRI.historia β j))

@[expose] noncomputable def radioEnlace (k : ℕ) : ℚ :=
  (5 * (2 ^ k : ℕ) + 1 : ℚ) / (8 * (2 ^ k : ℕ) : ℚ) - 3 * (1 / 8) - 1 / 8

@[expose] noncomputable def radioBase (k : ℕ) : ℚ :=
  1 - (2 ^ k - 1 : ℕ) / (8 * (2 ^ k : ℕ) : ℚ) - 1 / 8

theorem radios_consulta_perfil (k : ℕ) : (1 / 8 : ℚ) ≤ radioEnlace k ∧
    (1 / 8 : ℚ) ≤ radioBase k := by
  have hT : (0 : ℚ) < 2 ^ k := by positivity
  have heq : radioEnlace k = 1 / 8 + 1 / (8 * (2 ^ k : ℕ) : ℚ) := by
    unfold radioEnlace
    field_simp
    ring
  have hb := margen_no_base (2 ^ k) (by positivity) (1 / 8) (le_refl _)
  constructor
  · rw [heq]
    linarith [show (0 : ℚ) < 1 / (8 * (2 ^ k : ℕ) : ℚ) by positivity]
  · change (1 / 8 : ℚ) ≤ 1 - _ - _
    linarith

/-- El máximo de los cuatro casos coincide con H del radio 1/8 en este perfil. -/
theorem maximo_consulta_perfil (k q : ℕ) :
    max (Nexus.N05.H (4 * 2 ^ k) q (1 / 8))
      (max (Nexus.N05.H (4 * 2 ^ k) q (1 / 8))
        (max (Nexus.N05.H (4 * 2 ^ k) q (radioEnlace k))
          (Nexus.N05.H (4 * 2 ^ k) q (radioBase k)))) =
      Nexus.N05.H (4 * 2 ^ k) q (1 / 8) := by
  have hr := radios_consulta_perfil k
  apply max_eq_left
  exact max_le (le_refl _) (max_le (Nexus.N05.H_antitona _ q hr.1)
    (Nexus.N05.H_antitona _ q hr.2))

/-- El control de base comprende las seis posiciones AIR de cada pareja. -/
@[expose] noncomputable def AceptaCompartida (k : ℕ) (hk : k ≤ 29)
    (s o : Fp) (h : PrefijoConsulta) (S : Finset Fp2) : Prop :=
  Nexus.FRI.Acepta (torreTraza k hk) (oraculoTraza h) (fun j => h.betaTraza j)
    (Nexus.FRI.elevar (representanteCapa k 0) S) h.constanteTraza ∧
  Nexus.FRI.Acepta (torreComposicion k hk) (oraculoComposicion h) (fun j => h.betaComposicion j)
    (Nexus.FRI.elevar (representanteCapa k 0) S) h.constanteComposicion ∧
  (∀ x ∈ Nexus.FRI.elevar (representanteCapa k 0) S, ∀ i < 3,
    EsBase (oraculoTraza h 0 (raizExtension k ^ i * x))) ∧
  ConsultaParejas (representanteCapa k 0) (fun x => oraculoComposicion h 0 x =
    Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) (algebraMap Fp Fp2 s)
      (algebraMap Fp Fp2 o) h.coeficientes (oraculoTraza h 0) x) S

@[expose] noncomputable def PrefijoSeguro (k : ℕ) (hk : k ≤ 29)
    (s o : Fp) (h : PrefijoConsulta) : Prop := by
  classical
  exact match candidatoPerfil k (oraculoTraza h 0) (1 / 8) with
    | none => SinExcepciones k k hk (by omega) h.traza h.betaTraza
    | some f => if (∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) then
        (Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f
          (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o) h.coeficientes %
            Nexus.AIR.denominador (2 ^ k) ≠ 0) ∧
        (match candidato (cosetExtension (k + 3)) (oraculoComposicion h 0) (2 * 2 ^ k) (1 / 8) with
        | none => SinExcepciones k (k + 1) hk (by omega) h.composicion h.betaComposicion
        | some _ => True)
      else True

theorem compartida_implica_base (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (h : PrefijoConsulta) (S : Finset Fp2) (ha : AceptaCompartida k hk s o h S) :
    ConsultaParejas (representanteCapa k 0) (fun x => EsBase (oraculoTraza h 0 x)) S := by
  apply (consulta_parejas_iff _ _ S).mpr
  intro x hx
  simpa only [pow_zero, one_mul] using ha.2.2.1 x hx 0 (by decide)

theorem consulta_fri_perfil (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1) (hm0 : 0 < m)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2) (β : ℕ → Fp2) (c : Fp2)
    (hs : SinExcepciones k m hk hm estrategia β)
    (hfar : Nexus.FRI.Lejano (torreGoldilocks k m hk hm)
      (fun j => estrategia j (Nexus.FRI.historia β j)) ((1 / 8 : ℚ) : ℝ))
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) :
    probabilidadConsulta (dominioCapa k 1) q (fun S =>
      Nexus.FRI.Acepta (torreGoldilocks k m hk hm)
        (fun j => estrategia j (Nexus.FRI.historia β j)) (fun j => β j)
        (Nexus.FRI.elevar (representanteCapa k 0) S) c) ≤
      Nexus.N05.H (4 * 2 ^ k) q (1 / 8) := by
  have hcast : ((1 / 8 : ℚ) : ℝ) = (1 / 8 : ℝ) := by norm_num
  have hmargin : ∀ j : Fin m,
      (((torreGoldilocks k m hk hm).grado (j + 1)) : ℝ) - 1 <
        (1 - 3 * ((1 / 8 : ℚ) : ℝ)) * ((torreGoldilocks k m hk hm).dominio (j + 1)).card := by
    rw [hcast]
    exact margen_torre_goldilocks k m hk hm
  have hs' : ∀ j : Fin m, β j ∉ Nexus.FRI.excepciones (torreGoldilocks k m hk hm)
      ((1 / 8 : ℚ) : ℝ) (by norm_num) dos_extension_no_cero hmargin j
      (estrategia j (Nexus.FRI.historia β j)) := by
    simpa only [SinExcepciones, hcast] using hs
  have hq' : q ≤ ((torreGoldilocks k m hk hm).dominio 1).card := by
    rw [parejas_iniciales_torre]
    exact hq
  have hprob := Nexus.FRI.muestreo_consulta_fri (torreGoldilocks k m hk hm) hm0
    estrategia β (1 / 8) (by norm_num) dos_extension_no_cero hmargin hs' hfar c q hq'
  have hD : (dominioCapa k 1).card = 4 * 2 ^ k := parejas_iniciales_torre k m hk hm
  simpa only [torreGoldilocks, hD] using hprob

theorem traza_lejana_de_ninguno (k : ℕ) (hk : k ≤ 29) (h : PrefijoConsulta)
    (hc : candidatoPerfil k (oraculoTraza h 0) (1 / 8) = none) :
    Nexus.FRI.Lejano (torreTraza k hk) (oraculoTraza h) ((1 / 8 : ℚ) : ℝ) := by
  intro P hP
  rw [(torres_grados_iniciales k hk).1] at hP
  have hfar := (candidato_perfil_ninguno k (oraculoTraza h 0) (1 / 8)).mp hc P hP
  change ((1 / 8 : ℚ) : ℝ) < (Nexus.distancia ((torreTraza k hk).dominio 0)
    (oraculoTraza h 0) P.eval : ℝ)
  rw [(torres_dominio_inicial k hk).1]
  exact_mod_cast hfar

theorem composicion_lejana_de_ninguno (k : ℕ) (hk : k ≤ 29) (h : PrefijoConsulta)
    (hc : candidato (cosetExtension (k + 3)) (oraculoComposicion h 0) (2 * 2 ^ k) (1 / 8) = none) :
    Nexus.FRI.Lejano (torreComposicion k hk) (oraculoComposicion h) ((1 / 8 : ℚ) : ℝ) := by
  intro P hP
  rw [(torres_grados_iniciales k hk).2] at hP
  have hfar := (candidato_ninguno_iff _ (oraculoComposicion h 0) _ (1 / 8)).mp hc P hP
  change ((1 / 8 : ℚ) : ℝ) < (Nexus.distancia ((torreComposicion k hk).dominio 0)
    (oraculoComposicion h 0) P.eval : ℝ)
  rw [(torres_dominio_inicial k hk).2]
  exact_mod_cast hfar

/-- Una sola muestra, un solo caso activo y una sola cota H, sin productos entre FRI. -/
theorem consulta_compartida_perfil (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (s o : Fp) (h : PrefijoConsulta) (hs : PrefijoSeguro k hk s o h)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) :
    probabilidadConsulta (dominioCapa k 1) q (AceptaCompartida k hk s o h) ≤
      Nexus.N05.H (4 * 2 ^ k) q (1 / 8) := by
  classical
  cases hc : candidatoPerfil k (oraculoTraza h 0) (1 / 8) with
  | none =>
    have hsafe : SinExcepciones k k hk (by omega) h.traza h.betaTraza := by
      simpa only [PrefijoSeguro, hc] using hs
    apply (consulta_monotona _ q _ _ (by intro S _ ha; exact ha.1)).trans
      (consulta_fri_perfil k k hk (Nat.le_succ k) (by omega) h.traza h.betaTraza h.constanteTraza
        hsafe (traza_lejana_de_ninguno k hk h hc) q hq)
  | some f =>
    by_cases hb : ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f
    · have hsafe := hs
      simp only [PrefijoSeguro, hc, hb, ite_eq_left] at hsafe
      cases hv : candidato (cosetExtension (k + 3)) (oraculoComposicion h 0) (2 * 2 ^ k) (1 / 8) with
      | none =>
        have hsc : SinExcepciones k (k + 1) hk (by omega) h.composicion h.betaComposicion := by
          simpa only [hv] using hsafe.2
        apply (consulta_monotona _ q _ _ (by intro S _ ha; exact ha.2.1)).trans
          (consulta_fri_perfil k (k + 1) hk (le_refl _) (by omega) h.composicion h.betaComposicion
            h.constanteComposicion hsc (composicion_lejana_de_ninguno k hk h hv) q hq)
      | some P =>
        have hlocal := consulta_candidato_enlace k hk0 hk (oraculoTraza h 0) (oraculoComposicion h 0)
          (1 / 8) (1 / 8) f P hc hv (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o)
          h.coeficientes hsafe.1 q
        exact (consulta_monotona _ q _ _ (by intro S _ ha; exact ha.2.2.2)).trans
          (hlocal.trans (Nexus.N05.H_antitona _ q (radios_consulta_perfil k).1))
    · have hlocal := consulta_candidato_no_base k hk (oraculoTraza h 0) (1 / 8) f hc hb q
      exact (consulta_monotona _ q _ _ (by
        intro S _ ha
        exact compartida_implica_base k hk s o h S ha)).trans
          (hlocal.trans (Nexus.N05.H_antitona _ q (radios_consulta_perfil k).2))

/-- La rama puede cambiar con toda la historia; el promedio conserva la misma cota. -/
theorem consulta_compartida_promedio {H : Type*} [Fintype H] [Nonempty H]
    (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (prefijos : H → PrefijoConsulta) (hs : ∀ x, PrefijoSeguro k hk s o (prefijos x))
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) :
    promedio (fun x => probabilidadConsulta (dominioCapa k 1) q
      (AceptaCompartida k hk s o (prefijos x))) ≤ Nexus.N05.H (4 * 2 ^ k) q (1 / 8) := by
  calc
    _ ≤ promedio (fun _ : H => Nexus.N05.H (4 * 2 ^ k) q (1 / 8)) :=
      promedio_monotono _ _ (fun x => consulta_compartida_perfil k hk0 hk s o (prefijos x) (hs x) q hq)
    _ = _ := promedio_constante _

/-- Cualquier distribución finita de prefijos seguros admite la misma cota final. -/
theorem consulta_compartida_ponderada {H : Type*} [Fintype H]
    (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (prefijos : H → PrefijoConsulta) (w : H → ℚ) (hw : ∀ x, 0 ≤ w x)
    (hsuma : ∑ x, w x = 1) (hs : ∀ x, w x ≠ 0 → PrefijoSeguro k hk s o (prefijos x))
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) :
    (∑ x, w x * probabilidadConsulta (dominioCapa k 1) q
      (AceptaCompartida k hk s o (prefijos x))) ≤ Nexus.N05.H (4 * 2 ^ k) q (1 / 8) := by
  calc
    _ ≤ ∑ x, w x * Nexus.N05.H (4 * 2 ^ k) q (1 / 8) := by
      apply Finset.sum_le_sum
      intro x _
      by_cases hx : w x = 0
      · simp only [hx, zero_mul, le_refl]
      · exact mul_le_mul_of_nonneg_left
          (consulta_compartida_perfil k hk0 hk s o (prefijos x) (hs x hx) q hq) (hw x)
    _ = _ := by rw [← Finset.sum_mul, hsuma, one_mul]

theorem consulta_compartida_cuarenta (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (s o : Fp) (h : PrefijoConsulta) (hs : PrefijoSeguro k hk s o h) :
    let prob := probabilidadConsulta (dominioCapa k 1) 40 (AceptaCompartida k hk s o h)
    prob ≤ Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8) ∧ prob ≤ (7 / 8 : ℚ) ^ 40 := by
  have hq := Nexus.Modelos.Omision.muestras_perfiles k hk0
  have hprob := consulta_compartida_perfil k hk0 hk s o h hs 40 hq
  refine ⟨hprob, hprob.trans ?_⟩
  have hbound := Nexus.N05.H_le_potencia (4 * 2 ^ k) 40 (1 / 8)
    (by positivity) hq (by norm_num) (by norm_num)
  convert hbound using 1
  norm_num

end Nexus.Goldilocks
