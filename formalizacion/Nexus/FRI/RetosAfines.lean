module

public import Nexus.FRI.Dominios
public import Nexus.Cripto.Probabilidad
import Mathlib.Tactic

/-!
# Cambio de reto de plegado a combinación afín

Para un representante no nulo x, beta y a=1/2+beta/(2x)
son coordenadas biyectivas del reto. La equivalencia es por representante:
no convierte los a(x) de distintos puntos en retos independientes.
-/

public section
namespace Nexus.FRI.Afin

variable {K : Type*} [Field K]

@[expose] def coeficiente (x beta : K) : K := 1 / 2 + beta / (2 * x)
@[expose] def recuperar (x a : K) : K := (2 * a - 1) * x

theorem recuperar_coeficiente (x beta : K) (hx : x ≠ 0) (h2 : (2 : K) ≠ 0) :
    recuperar x (coeficiente x beta) = beta := by
  unfold recuperar coeficiente
  field_simp
  ring

theorem coeficiente_recuperar (x a : K) (hx : x ≠ 0) (h2 : (2 : K) ≠ 0) :
    coeficiente x (recuperar x a) = a := by
  unfold recuperar coeficiente
  field_simp
  ring

@[expose] def equivalencia (x : K) (hx : x ≠ 0) (h2 : (2 : K) ≠ 0) : K ≃ K where
  toFun := coeficiente x
  invFun := recuperar x
  left_inv := fun beta => recuperar_coeficiente x beta hx h2
  right_inv := fun a => coeficiente_recuperar x a hx h2

theorem formula_afin (left right x beta : K) (hx : x ≠ 0) (h2 : (2 : K) ≠ 0) :
    (left + right) / 2 + beta * ((left - right) / 2) * x⁻¹ =
      coeficiente x beta * left + (1 - coeficiente x beta) * right := by
  unfold coeficiente
  field_simp
  ring

theorem mismo_reto_acopla_puntos (x y beta : K) (hx : x ≠ 0) (hy : y ≠ 0)
    (h2 : (2 : K) ≠ 0) :
    recuperar x (coeficiente x beta) = recuperar y (coeficiente y beta) := by
  rw [recuperar_coeficiente x beta hx h2, recuperar_coeficiente y beta hy h2]

theorem preimagen_evento_cardinal [Fintype K] (x : K) (hx : x ≠ 0) (h2 : (2 : K) ≠ 0)
    (E : K → Prop) [DecidablePred E] :
    Fintype.card {beta : K // E (coeficiente x beta)} = Fintype.card {a : K // E a} := by
  classical
  let e : {beta : K // E (coeficiente x beta)} ≃ {a : K // E a} :=
    { toFun := fun beta => ⟨coeficiente x beta.val, beta.property⟩
      invFun := fun a => ⟨recuperar x a.val, by simpa only [coeficiente_recuperar x a.val hx h2] using a.property⟩
      left_inv := fun beta => Subtype.ext (recuperar_coeficiente x beta.val hx h2)
      right_inv := fun a => Subtype.ext (coeficiente_recuperar x a.val hx h2) }
  exact Fintype.card_congr e

/-- Cambio global de coset x=a*y: el mismo beta/a se usa en todos los puntos de la capa. -/
@[expose] def retoCoset (a beta : K) : K := beta / a

@[expose] def equivalenciaCoset (a : K) (ha : a ≠ 0) : K ≃ K where
  toFun := retoCoset a
  invFun := fun beta => beta * a
  left_inv := fun beta => by simp only [retoCoset, div_mul_cancel₀ _ ha]
  right_inv := fun beta => by simp only [retoCoset, mul_div_cancel_right₀ _ ha]

theorem plegado_coset (u : K → K) (a y beta : K) :
    (u (a * y) + u (-(a * y))) / 2 +
      beta * ((u (a * y) - u (-(a * y))) / 2) * (a * y)⁻¹ =
    (u (a * y) + u (a * -y)) / 2 +
      retoCoset a beta * ((u (a * y) - u (a * -y)) / 2) * y⁻¹ := by
  simp only [retoCoset, mul_neg, mul_inv_rev, div_eq_mul_inv]
  ring

theorem coset_uniforme_cardinal [Fintype K] (a : K) (ha : a ≠ 0)
    (E : K → Prop) [DecidablePred E] :
    Fintype.card {beta : K // E (retoCoset a beta)} = Fintype.card {beta : K // E beta} := by
  classical
  let e := equivalenciaCoset a ha
  let t : {beta : K // E (retoCoset a beta)} ≃ {beta : K // E beta} :=
    { toFun := fun beta => ⟨e beta.val, beta.property⟩
      invFun := fun beta => ⟨e.symm beta.val, by change E (e (e.symm beta.val)); simpa using beta.property⟩
      left_inv := fun beta => Subtype.ext (e.symm_apply_apply beta.val)
      right_inv := fun beta => Subtype.ext (e.apply_symm_apply beta.val) }
  exact Fintype.card_congr t

end Nexus.FRI.Afin
