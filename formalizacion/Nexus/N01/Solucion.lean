module

public import Nexus.N01.Enunciado
import Mathlib.Algebra.Module.Torsion.Free
import Mathlib.Tactic

public section
namespace Nexus.N01

variable {K : Type*} [Field K] [Fintype K]

omit [Fintype K] in
/-- Fijados los otros coeficientes, un residuo no nulo impide dos cancelaciones. -/
theorem coeficiente_unico (r s : Polynomial K) (hr : r ≠ 0) (a b : K)
    (ha : a • r + s = 0) (hb : b • r + s = 0) : a = b := by
  exact smul_left_injective K hr (add_right_cancel (ha.trans hb.symm))

/-- A lo sumo |K|² triples anulan una combinación de residuos no todos nulos. -/
theorem conteo (r₀ r₁ r₂ : Polynomial K) (hn : r₀ ≠ 0 ∨ r₁ ≠ 0 ∨ r₂ ≠ 0) :
    (cancelantes r₀ r₁ r₂).card ≤ Fintype.card K ^ 2 := by
  classical
  let C := {a : Coeficientes K // combinacion r₀ r₁ r₂ a = 0}
  have hcard : Fintype.card C ≤ Fintype.card (K × K) := by
    rcases hn with h₀ | h₁ | h₂
    · apply Fintype.card_le_of_injective (fun a : C => a.val.2)
      intro a b hab
      apply Subtype.ext
      apply Prod.ext
      · apply smul_left_injective K h₀
        have heq := a.property.trans b.property.symm
        simp only [combinacion, hab] at heq
        exact add_right_cancel (add_right_cancel heq)
      · exact hab
    · apply Fintype.card_le_of_injective (fun a : C => (a.val.1, a.val.2.2))
      intro a b hab
      have h₀ : a.val.1 = b.val.1 := congrArg (fun z : K × K => z.1) hab
      have h₂ := congrArg (fun z : K × K => z.2) hab
      change a.val.2.2 = b.val.2.2 at h₂
      apply Subtype.ext
      apply Prod.ext h₀
      apply Prod.ext
      · apply smul_left_injective K h₁
        have heq := a.property.trans b.property.symm
        simp only [combinacion, h₀, h₂] at heq
        exact add_left_cancel (add_right_cancel heq)
      · exact h₂
    · apply Fintype.card_le_of_injective (fun a : C => (a.val.1, a.val.2.1))
      intro a b hab
      have h₀ : a.val.1 = b.val.1 := congrArg (fun z : K × K => z.1) hab
      have h₁ : a.val.2.1 = b.val.2.1 := congrArg (fun z : K × K => z.2) hab
      apply Subtype.ext
      apply Prod.ext h₀
      apply Prod.ext h₁
      apply smul_left_injective K h₂
      have heq := a.property.trans b.property.symm
      simp only [combinacion, h₀, h₁] at heq
      exact add_left_cancel heq
  simpa [C, cancelantes, Fintype.card_subtype, Fintype.card_prod, pow_two] using hcard

/-- Probabilidad de cancelación en el modelo uniforme independiente. -/
theorem cota : Enunciado K := by
  intro r₀ r₁ r₂ hn
  have hnK : (0 : ℚ) < Fintype.card K := by exact_mod_cast Fintype.card_pos
  have hc : ((cancelantes r₀ r₁ r₂).card : ℚ) ≤ (Fintype.card K : ℚ) ^ 2 := by
    exact_mod_cast conteo r₀ r₁ r₂ hn
  unfold probabilidad
  calc
    _ ≤ (Fintype.card K : ℚ) ^ 2 / (Fintype.card K : ℚ) ^ 3 :=
      div_le_div_of_nonneg_right hc (by positivity)
    _ = 1 / (Fintype.card K : ℚ) := by field_simp

/-- Especialización a cualquier campo K de cardinal p², como en la tesis. -/
theorem cota_extension_cuadratica (p : ℕ) (hK : Fintype.card K = p ^ 2)
    (r₀ r₁ r₂ : Polynomial K) (hn : r₀ ≠ 0 ∨ r₁ ≠ 0 ∨ r₂ ≠ 0) :
    probabilidad r₀ r₁ r₂ ≤ 1 / (p : ℚ) ^ 2 := by
  simpa [hK] using (cota r₀ r₁ r₂ hn)

end Nexus.N01
