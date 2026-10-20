module

public import Nexus.N06.Transcripcion
public import Nexus.FRI.Consulta
import Mathlib.Tactic

/-!
# El experimento FRI incluye los prefijos excepcionales

Se sortean m retos uniformes frescos, se emite la constante final según su
historia y se toma después una muestra uniforme de parejas sin reemplazo.
La estrategia de cada capa recibe únicamente los retos anteriores.
-/

public section
namespace Nexus.FRI

open Nexus.N06
variable {K : Type*} [Field K] {m : ℕ}

theorem escape_historia_iff (t : Torre K m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List K → K → K) (xs : Retos K m) :
    ¬ Escapa (excepcionesHistoria t θ hθ h2 hmargin estrategia)
      (fun _ h x => h ++ [x]) 0 m [] xs ↔
      ∀ j : Fin m, reto xs j ∉ excepciones t θ hθ h2 hmargin j
        (estrategia j (historia (reto xs) j)) := by
  classical
  rw [no_escape_historia]
  constructor
  · intro h j
    simpa only [Nat.zero_add, List.nil_append, excepcionesHistoria, j.isLt,
      dite_eq_left] using h j j.isLt
  · intro h j hj
    simpa only [Nat.zero_add, List.nil_append, excepcionesHistoria, hj,
      dite_eq_left] using h ⟨j, hj⟩

variable [Fintype K] [DecidableEq K]

/-- La probabilidad antes definida por recursión cuenta exactamente los prefijos inseguros. -/
theorem probabilidad_prefijos_inseguros (t : Torre K m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List K → K → K) :
    promedio (fun xs : Retos K m => if (∀ j : Fin m,
      reto xs j ∉ excepciones t θ hθ h2 hmargin j
        (estrategia j (historia (reto xs) j))) then 0 else 1) =
      probabilidadExcepciones t θ hθ h2 hmargin estrategia := by
  classical
  rw [probabilidadExcepciones, riesgo_es_promedio]
  congr 1
  funext xs
  rw [valor_escape]
  simp only [← escape_historia_iff]
  by_cases hx : Escapa (excepcionesHistoria t θ hθ h2 hmargin estrategia)
      (fun _ h x => h ++ [x]) 0 m [] xs <;> simp only [hx, not_true_eq_false,
        not_false_eq_true, reduceIte]

/-- Toda función de la transcripción con cota H fuera de las excepciones paga
una sola vez la suma telescópica de los tamaños de dominio. -/
theorem cota_terminal_adaptativa (t : Torre K m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List K → K → K) (f : Retos K m → ℚ)
    (h : ℚ) (hh : 0 ≤ h) (huno : ∀ xs, f xs ≤ 1)
    (hseguro : ∀ xs, (∀ j : Fin m, reto xs j ∉ excepciones t θ hθ h2 hmargin j
      (estrategia j (historia (reto xs) j))) → f xs ≤ h) :
    promedio f ≤ h + ((t.dominio 0).card - (t.dominio m).card : ℕ) /
      (Fintype.card K : ℚ) := by
  let B : ℕ → ℕ := fun i => if i < m then (t.dominio (i + 1)).card else 0
  have hE : ∀ i hs, (excepcionesHistoria t θ hθ h2 hmargin estrategia i hs).card ≤ B i := by
    intro i hs
    by_cases hi : i < m
    · simpa only [excepcionesHistoria, hi, dite_eq_left, B, ite_eq_left] using
        excepciones_cardinal t θ hθ h2 hmargin ⟨i, hi⟩ (estrategia i hs)
    · simp [excepcionesHistoria, hi, B]
  have hb := cota_promedio_fuera_escape
    (excepcionesHistoria t θ hθ h2 hmargin estrategia) (fun _ hs x => hs ++ [x])
    B h hh hE 0 m [] f huno (fun xs hx => hseguro xs
      ((escape_historia_iff t θ hθ h2 hmargin estrategia xs).mp hx))
  have hsum : (∑ j ∈ Finset.range m, B j) = (t.dominio 0).card - (t.dominio m).card := by
    have hB : ∀ j ∈ Finset.range m, B j = (t.dominio (j + 1)).card := by
      intro j hj
      simp only [B, Finset.mem_range.mp hj, ite_eq_left]
    rw [Finset.sum_congr rfl hB, ← Fin.sum_univ_eq_sum_range]
    exact suma_capas t h2
  simpa only [Nat.zero_add, ← Nat.cast_sum, hsum] using hb

/-- Cota de la aceptación real, promediada sobre retos y consulta en un mismo experimento. -/
theorem consulta_fri_total (t : Torre K m) (hm : 0 < m)
    (estrategia : ℕ → List K → K → K) (constante : Retos K m → K)
    (θ : ℚ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * (θ : ℝ)) * (t.dominio (j + 1)).card)
    (hfar : ∀ P : Polynomial K, P.natDegree < t.grado 0 →
      (θ : ℝ) < (Nexus.distancia (t.dominio 0) (estrategia 0 []) P.eval : ℝ))
    (q : ℕ) (hq : q ≤ (t.dominio 1).card) :
    promedio (fun xs : Retos K m => probabilidadConsulta (t.dominio 1) q (fun S =>
      Acepta t (fun j => estrategia j (historia (reto xs) j)) (fun j => reto xs j)
        (elevar (t.raiz 0) S) (constante xs))) ≤
      Nexus.N05.H (t.dominio 1).card q θ +
        ((t.dominio 0).card - (t.dominio m).card : ℕ) / (Fintype.card K : ℚ) := by
  apply cota_terminal_adaptativa t θ (by exact_mod_cast hθ) h2 hmargin estrategia _ _
    (by unfold Nexus.N05.H; positivity)
    (fun _ => consulta_le_uno _ q _ hq)
  intro xs hs
  exact muestreo_consulta_fri t hm estrategia (reto xs) θ hθ h2 hmargin hs
    (by simpa only [Lejano, historia] using hfar) (constante xs) q hq

end Nexus.FRI
