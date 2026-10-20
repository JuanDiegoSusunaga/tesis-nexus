module

public import Nexus.AIR.Grados
public import Nexus.Distancia.Propiedades
public import Mathlib.Basic.Real.Basic
public import Mathlib.Data.Rat.Cast.Order
import Mathlib.Tactic

public section
namespace Nexus.AIR

open Polynomial
variable {K : Type*} [Field K]

/-- Numerador de composición obtenido de las tres evaluaciones locales de u.
Los pesos de frontera son cocientes polinómicos y no dependen de u. -/
@[expose] noncomputable def numeradorLocal (T : ℕ) (g s o : K)
    (a : Nexus.N01.Coeficientes K) (u : K → K) (x : K) : K :=
  a.1 * ((u x - s) * (denominador T / (X - C 1) : Polynomial K).eval x) +
  a.2.1 * ((u x - o) * (denominador T / (X - C (g ^ (T - 1))) : Polynomial K).eval x) +
  a.2.2 * ((u (g ^ 2 * x) - u (g * x) ^ 2 - u x ^ 2) *
    (x - g ^ (T - 1)) * (x - g ^ (T - 2)))

@[expose] noncomputable def composicionLocal (T : ℕ) (g s o : K)
    (a : Nexus.N01.Coeficientes K) (u : K → K) (x : K) : K :=
  numeradorLocal T g s o a u x / (denominador T : Polynomial K).eval x

/-- El modelo local coincide con el numerador polinómico cuando u=f.eval. -/
theorem composicion_polinomio (T : ℕ) (g s o : K) (a : Nexus.N01.Coeficientes K)
    (f : Polynomial K) :
    composicionLocal T g s o a f.eval =
      (fun x => (numeradorCombinado T g f s o a).eval x /
        (denominador T : Polynomial K).eval x) := by
  funext x
  simp [composicionLocal, numeradorLocal, numeradorCombinado, Nexus.N01.combinacion,
    frontera, numeradorTransicion, transicion]

theorem evaluacion_cociente_lineal (D : Polynomial K) (b x : K)
    (hb : D.IsRoot b) (hx : x ≠ b) :
    (D / (X - C b)).eval x = D.eval x / (x - b) := by
  have he := congrArg (fun P : Polynomial K => P.eval x) hb.mul_div_eq
  simp only [eval_mul, eval_sub, eval_X, eval_C] at he
  exact (eq_div_iff (sub_ne_zero.mpr hx)).mpr (by simpa only [mul_comm] using he)

/-- Expresión racional de las tres partes que calcula `compose` en la copia Rust.
La hipótesis de ausencia de polos justifica todas las divisiones. -/
theorem formula_composicion_local (T : ℕ) (g s o : K) (a : Nexus.N01.Coeficientes K)
    (u : K → K) (x : K) (hg : IsPrimitiveRoot g T)
    (hD : (denominador T : Polynomial K).eval x ≠ 0) :
    composicionLocal T g s o a u x =
      a.1 * ((u x - s) / (x - 1)) +
      a.2.1 * ((u x - o) / (x - g ^ (T - 1))) +
      a.2.2 * ((u (g ^ 2 * x) - u (g * x) ^ 2 - u x ^ 2) *
        (x - g ^ (T - 1)) * (x - g ^ (T - 2)) / (x ^ T - 1)) := by
  have hroot0 : (denominador T : Polynomial K).IsRoot 1 := by
    simp [IsRoot, denominador]
  have hpow : (g ^ (T - 1)) ^ T = 1 := by
    rw [← pow_mul, Nat.mul_comm, pow_mul, hg.pow_eq_one, one_pow]
  have hroot1 : (denominador T : Polynomial K).IsRoot (g ^ (T - 1)) := by
    simp [IsRoot, denominador, hpow]
  have hx0 : x ≠ 1 := by
    intro h
    apply hD
    simpa only [h, IsRoot] using hroot0
  have hx1 : x ≠ g ^ (T - 1) := by
    intro h
    apply hD
    simpa only [h, IsRoot] using hroot1
  have hsub0 : x - 1 ≠ 0 := sub_ne_zero.mpr hx0
  have hsub1 : x - g ^ (T - 1) ≠ 0 := sub_ne_zero.mpr hx1
  unfold composicionLocal numeradorLocal
  rw [evaluacion_cociente_lineal _ _ _ hroot0 hx0,
    evaluacion_cociente_lineal _ _ _ hroot1 hx1]
  have hDen : x ^ T - 1 ≠ 0 := by simpa [denominador] using hD
  simp only [denominador, eval_sub, eval_pow, eval_X, eval_one]
  field_simp

theorem localidad_tres_puntos (T : ℕ) (g s o : K) (a : Nexus.N01.Coeficientes K)
    (u v : K → K) (x : K) (h0 : u x = v x) (h1 : u (g * x) = v (g * x))
    (h2 : u (g ^ 2 * x) = v (g ^ 2 * x)) :
    composicionLocal T g s o a u x = composicionLocal T g s o a v x := by
  simp only [composicionLocal, numeradorLocal, h0, h1, h2]

/-- Cada error local procede de un error en x, gx o g²x; no requiere independencia. -/
theorem errores_composicion_local (L : Finset K) (T : ℕ) (g s o : K)
    (a : Nexus.N01.Coeficientes K) (u v : K → K) (hg : g ≠ 0)
    (hL : ∀ x ∈ L, g * x ∈ L) :
    Nexus.errores L (composicionLocal T g s o a u) (composicionLocal T g s o a v) ≤
      3 * Nexus.errores L u v := by
  classical
  let E0 := L.filter (fun x => u x ≠ v x)
  let E1 := L.filter (fun x => u (g * x) ≠ v (g * x))
  let E2 := L.filter (fun x => u (g ^ 2 * x) ≠ v (g ^ 2 * x))
  have h2L : ∀ x ∈ L, g ^ 2 * x ∈ L := by
    intro x hx
    simpa only [pow_two, mul_assoc] using hL (g * x) (hL x hx)
  have h1 : E1.card ≤ Nexus.errores L u v :=
    Nexus.errores_reindexacion L u v (g * ·) hL
      (fun _ _ _ _ h => mul_left_cancel₀ hg h)
  have h2 : E2.card ≤ Nexus.errores L u v :=
    Nexus.errores_reindexacion L u v (g ^ 2 * ·) h2L
      (fun _ _ _ _ h => mul_left_cancel₀ (pow_ne_zero _ hg) h)
  have hsub : L.filter (fun x => composicionLocal T g s o a u x ≠
      composicionLocal T g s o a v x) ⊆ E0 ∪ E1 ∪ E2 := by
    intro x hx
    obtain ⟨hxL, hx⟩ := Finset.mem_filter.mp hx
    by_contra hnot
    have h0 : u x = v x := by
      by_contra h
      exact hnot (Finset.mem_union_left _ (Finset.mem_union_left _
        (Finset.mem_filter.mpr ⟨hxL, h⟩)))
    have h1' : u (g * x) = v (g * x) := by
      by_contra h
      exact hnot (Finset.mem_union_left _ (Finset.mem_union_right _
        (Finset.mem_filter.mpr ⟨hxL, h⟩)))
    have h2' : u (g ^ 2 * x) = v (g ^ 2 * x) := by
      by_contra h
      exact hnot (Finset.mem_union_right _ (Finset.mem_filter.mpr ⟨hxL, h⟩))
    exact hx (localidad_tres_puntos T g s o a u v x h0 h1' h2')
  have hc : Nexus.errores L (composicionLocal T g s o a u)
      (composicionLocal T g s o a v) ≤ (E0 ∪ E1).card + E2.card :=
    (Finset.card_le_card hsub).trans (Finset.card_union_le _ _)
  have hc01 := Finset.card_union_le E0 E1
  have h0 : E0.card = Nexus.errores L u v := rfl
  omega

theorem distancia_composicion_local (L : Finset K) (T : ℕ) (g s o : K)
    (a : Nexus.N01.Coeficientes K) (u v : K → K) (hg : g ≠ 0)
    (hL : ∀ x ∈ L, g * x ∈ L) :
    Nexus.distancia L (composicionLocal T g s o a u) (composicionLocal T g s o a v) ≤
      3 * Nexus.distancia L u v := by
  have hc : (Nexus.errores L (composicionLocal T g s o a u)
      (composicionLocal T g s o a v) : ℚ) ≤ 3 * Nexus.errores L u v := by
    exact_mod_cast errores_composicion_local L T g s o a u v hg hL
  unfold Nexus.distancia
  calc
    _ ≤ (3 * Nexus.errores L u v : ℚ) / L.card :=
      div_le_div_of_nonneg_right hc (by positivity)
    _ = _ := by ring

/-- La pérdida 3ε se resta de cualquier cota inferior de la composición de v. -/
theorem transferencia_distancia (L : Finset K) (T : ℕ) (g s o : K)
    (a : Nexus.N01.Coeficientes K) (u v w : K → K) (hg : g ≠ 0)
    (hL : ∀ x ∈ L, g * x ∈ L) (d ε : ℚ) (huv : Nexus.distancia L u v ≤ ε)
    (hv : d ≤ Nexus.distancia L (composicionLocal T g s o a v) w) :
    max 0 (d - 3 * ε) ≤ Nexus.distancia L (composicionLocal T g s o a u) w := by
  have hlocal := distancia_composicion_local L T g s o a u v hg hL
  have htri := Nexus.distancia_triangular L (composicionLocal T g s o a v)
    (composicionLocal T g s o a u) w
  rw [Nexus.distancia_simetrica L (composicionLocal T g s o a v)
    (composicionLocal T g s o a u)] at htri
  exact max_le (Nexus.distancia_no_negativa L _ w) (by linarith)

/-- La misma transferencia con una tolerancia real, como permite el manuscrito. -/
theorem transferencia_distancia_real (L : Finset K) (T : ℕ) (g s o : K)
    (a : Nexus.N01.Coeficientes K) (u v w : K → K) (hg : g ≠ 0)
    (hL : ∀ x ∈ L, g * x ∈ L) (d ε : ℝ)
    (huv : (Nexus.distancia L u v : ℝ) ≤ ε)
    (hv : d ≤ (Nexus.distancia L (composicionLocal T g s o a v) w : ℝ)) :
    max 0 (d - 3 * ε) ≤ (Nexus.distancia L (composicionLocal T g s o a u) w : ℝ) := by
  have hlocal : (Nexus.distancia L (composicionLocal T g s o a u)
      (composicionLocal T g s o a v) : ℝ) ≤ 3 * (Nexus.distancia L u v : ℝ) := by
    exact_mod_cast distancia_composicion_local L T g s o a u v hg hL
  have htri : (Nexus.distancia L (composicionLocal T g s o a v) w : ℝ) ≤
      (Nexus.distancia L (composicionLocal T g s o a u)
        (composicionLocal T g s o a v) : ℝ) +
      (Nexus.distancia L (composicionLocal T g s o a u) w : ℝ) := by
    have h := Nexus.distancia_triangular L (composicionLocal T g s o a v)
      (composicionLocal T g s o a u) w
    rw [Nexus.distancia_simetrica L (composicionLocal T g s o a v)
      (composicionLocal T g s o a u)] at h
    exact_mod_cast h
  have hnonneg : (0 : ℝ) ≤ (Nexus.distancia L (composicionLocal T g s o a u) w : ℝ) := by
    exact_mod_cast Nexus.distancia_no_negativa L (composicionLocal T g s o a u) w
  exact max_le hnonneg (by linarith)

theorem margen_un_veinticuatro (T : ℕ) (hT : 0 < T) (ε : ℚ) (hε : ε ≤ 1 / 24) :
    (1 : ℚ) / 2 < (5 * T + 1 : ℚ) / (8 * T : ℚ) - 3 * ε := by
  have hTq : (0 : ℚ) < T := by exact_mod_cast hT
  calc
    (1 : ℚ) / 2 < 1 / 2 + 1 / (8 * T : ℚ) :=
      lt_add_of_pos_right _ (by positivity)
    _ = (5 * T + 1 : ℚ) / (8 * T : ℚ) - 3 * (1 / 24 : ℚ) := by
      field_simp
      ring
    _ ≤ _ := by linarith

end Nexus.AIR
