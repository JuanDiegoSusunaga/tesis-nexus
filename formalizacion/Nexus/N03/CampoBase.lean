module

public import Nexus.Campos.Polinomios
public import Nexus.Distancia.Propiedades
public import Mathlib.Data.Rat.Cast.Order
public import Mathlib.Basic.Real.Basic
import Mathlib.Tactic

public section
namespace Nexus.Goldilocks

open Polynomial

@[expose] noncomputable def puntosFueraBase (L : Finset Fp2) (u : Fp2 → Fp2) : ℕ := by
  classical
  exact (L.filter (fun x => ¬ EsBase (u x))).card

@[expose] noncomputable def fraccionFueraBase (L : Finset Fp2) (u : Fp2 → Fp2) : ℚ :=
  puntosFueraBase L u / (L.card : ℚ)

theorem valores_base_acotados (L : Finset Fp) (f : Polynomial Fp2)
    (hf : parteImaginaria f ≠ 0) :
    (L.filter (fun x => EsBase (f.eval (algebraMap Fp Fp2 x)))).card ≤
      (parteImaginaria f).natDegree := by
  classical
  simpa only [evaluacion_es_base] using Nexus.ceros_acotados L (parteImaginaria f) hf

/-- Un candidato que no viene del campo base tiene a lo sumo T-1 valores base. -/
theorem candidato_no_base (L : Finset Fp) (f : Polynomial Fp2) (T : ℕ)
    (hf : f.natDegree < T)
    (hno : ¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) :
    (L.filter (fun x => EsBase (f.eval (algebraMap Fp Fp2 x)))).card ≤ T - 1 := by
  have hB : parteImaginaria f ≠ 0 := mt (polinomio_base_iff_imaginaria_cero f).mpr hno
  exact (valores_base_acotados L f hB).trans ((grado_parte_imaginaria f).trans (by omega))

theorem candidato_no_base_dominio_elevado (L : Finset Fp) (f : Polynomial Fp2) (T : ℕ)
    (hf : f.natDegree < T)
    (hno : ¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) :
    ((L.image (algebraMap Fp Fp2)).filter (fun x => EsBase (f.eval x))).card ≤ T - 1 := by
  classical
  rw [Finset.filter_image, Finset.card_image_of_injective _ (algebraMap Fp Fp2).injective]
  exact candidato_no_base L f T hf hno

/-- Los errores frente a f son la única forma de ocultar sus valores no base. -/
theorem conteo_oraculo_no_base (L : Finset Fp) (u : Fp2 → Fp2) (f : Polynomial Fp2)
    (T : ℕ) (hf : f.natDegree < T)
    (hno : ¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) :
    (L.image (algebraMap Fp Fp2)).card ≤ T - 1 +
      Nexus.errores (L.image (algebraMap Fp Fp2)) u f.eval +
      puntosFueraBase (L.image (algebraMap Fp Fp2)) u := by
  classical
  let D := L.image (algebraMap Fp Fp2)
  let B := D.filter (fun x => EsBase (f.eval x))
  let E := D.filter (fun x => u x ≠ f.eval x)
  let U := D.filter (fun x => EsBase (u x))
  have hsub : U ⊆ B ∪ E := by
    intro x hx
    obtain ⟨hxD, hx⟩ := Finset.mem_filter.mp hx
    by_cases heq : u x = f.eval x
    · exact Finset.mem_union_left _ (Finset.mem_filter.mpr ⟨hxD, by simpa only [heq] using hx⟩)
    · exact Finset.mem_union_right _ (Finset.mem_filter.mpr ⟨hxD, heq⟩)
  have hcard := (Finset.card_le_card hsub).trans (Finset.card_union_le B E)
  have hB : B.card ≤ T - 1 := candidato_no_base_dominio_elevado L f T hf hno
  have hE : E.card = Nexus.errores D u f.eval := by simp only [E, Nexus.errores]
  have hpart : U.card + puntosFueraBase D u = D.card :=
    Finset.card_filter_add_card_filter_not (fun x => EsBase (u x))
  change D.card ≤ T - 1 + Nexus.errores D u f.eval + puntosFueraBase D u
  omega

theorem fraccion_oraculo_no_base (L : Finset Fp) (hL : 0 < L.card)
    (u : Fp2 → Fp2) (f : Polynomial Fp2) (T : ℕ) (hf : f.natDegree < T)
    (hno : ¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f)
    (δ : ℚ) (hu : Nexus.distancia (L.image (algebraMap Fp Fp2)) u f.eval ≤ δ) :
    1 - (T - 1 : ℕ) / (L.card : ℚ) - δ ≤
      fraccionFueraBase (L.image (algebraMap Fp Fp2)) u := by
  classical
  have hcard : (L.image (algebraMap Fp Fp2)).card = L.card :=
    Finset.card_image_of_injective _ (algebraMap Fp Fp2).injective
  have hLq : (0 : ℚ) < L.card := by exact_mod_cast hL
  have hc : (L.card : ℚ) ≤ (T - 1 : ℕ) +
      Nexus.errores (L.image (algebraMap Fp Fp2)) u f.eval +
      puntosFueraBase (L.image (algebraMap Fp Fp2)) u := by
    exact_mod_cast (by simpa only [hcard] using conteo_oraculo_no_base L u f T hf hno)
  have he := (div_le_iff₀ hLq).mp (by simpa only [Nexus.distancia, hcard] using hu)
  unfold fraccionFueraBase
  rw [hcard, le_div_iff₀ hLq, sub_mul, sub_mul, one_mul, div_mul_cancel₀ _ hLq.ne']
  linarith

theorem fraccion_oraculo_no_base_real (L : Finset Fp) (hL : 0 < L.card)
    (u : Fp2 → Fp2) (f : Polynomial Fp2) (T : ℕ) (hf : f.natDegree < T)
    (hno : ¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f)
    (δ : ℝ) (hu : (Nexus.distancia (L.image (algebraMap Fp Fp2)) u f.eval : ℝ) ≤ δ) :
    1 - (T - 1 : ℕ) / (L.card : ℝ) - δ ≤
      (fraccionFueraBase (L.image (algebraMap Fp Fp2)) u : ℝ) := by
  classical
  have hcard : (L.image (algebraMap Fp Fp2)).card = L.card :=
    Finset.card_image_of_injective _ (algebraMap Fp Fp2).injective
  have hLr : (0 : ℝ) < L.card := by exact_mod_cast hL
  have hc : (L.card : ℝ) ≤ (T - 1 : ℕ) +
      Nexus.errores (L.image (algebraMap Fp Fp2)) u f.eval +
      puntosFueraBase (L.image (algebraMap Fp Fp2)) u := by
    exact_mod_cast (by simpa only [hcard] using conteo_oraculo_no_base L u f T hf hno)
  have hu' : (Nexus.errores (L.image (algebraMap Fp Fp2)) u f.eval : ℝ) / L.card ≤ δ := by
    simpa only [Nexus.distancia, hcard, Rat.cast_div, Rat.cast_natCast] using hu
  have he := (div_le_iff₀ hLr).mp hu'
  unfold fraccionFueraBase
  simp only [Rat.cast_div, Rat.cast_natCast, hcard]
  rw [le_div_iff₀ hLr,
    sub_mul, sub_mul, one_mul, div_mul_cancel₀ _ hLr.ne']
  linarith

end Nexus.Goldilocks
