module

public import Nexus.Complejidad.Comunicacion
public import Mathlib.Logic.Equiv.Fin.Basic
public import Mathlib.Data.List.OfFn
import Mathlib.Tactic

/-!
# Codificación de ancho fijo y familias completas de parámetros

Cada coeficiente se entrega como ancho bits, con cabecera también en bits.
La biyección de índices fija un orden inequívoco y permite recuperar cada bit.
Cabecera, número de componentes, grado y ancho pueden variar simultáneamente.
No se afirma correspondencia con el empaquetado o parser Rust.
-/

public section
namespace Nexus.Complejidad.Comunicacion.Familias

open Filter Asymptotics

abbrev Indices (h k n w : ℕ) := Fin h ⊕ ((Fin k × Fin n) × Fin w)

@[expose] def indice (h k n w : ℕ) : Indices h k n w ≃ Fin (h + k * n * w) :=
  (Equiv.sumCongr (Equiv.refl (Fin h))
    ((Equiv.prodCongr finProdFinEquiv (Equiv.refl (Fin w))).trans finProdFinEquiv)).trans
    finSumFinEquiv

@[expose] def codifica {h k n w : ℕ} (bits : Indices h k n w → Bool) : List Bool :=
  List.ofFn (fun i => bits ((indice h k n w).symm i))

@[expose] def decodifica {h k n w : ℕ} (xs : List Bool) (hx : xs.length = h + k * n * w) :
    Indices h k n w → Bool := fun i => xs[(indice h k n w i).val]'(by rw [hx]; exact (indice h k n w i).isLt)

theorem longitud_codifica {h k n w : ℕ} (bits : Indices h k n w → Bool) :
    (codifica bits).length = h + k * n * w := List.length_ofFn

theorem decodifica_codifica {h k n w : ℕ} (bits : Indices h k n w → Bool) :
    decodifica (codifica bits) (longitud_codifica bits) = bits := by
  funext i
  simp [decodifica, codifica]

theorem codifica_inyectiva {h k n w : ℕ} :
    Function.Injective (codifica : (Indices h k n w → Bool) → List Bool) := by
  intro a b hab
  have he := List.ofFn_injective hab
  funext i
  have hi := congrFun he (indice h k n w i)
  simpa only [Equiv.symm_apply_apply] using hi

theorem longitud_publica {h k n w : ℕ} (bits : Indices h k n w → Bool) :
    (codifica bits).length = bitsPublica h k n w := longitud_codifica bits

theorem longitud_firma {h k r n w : ℕ} (bits : Indices h (k + r) n w → Bool) :
    (codifica bits).length = bitsFirma h k r n w := longitud_codifica bits

/-- La cota uniforme de la cabecera es explícita; todos los parámetros pueden variar. -/
theorem publica_familia_es_O (C : ℕ) (h k n w : ℕ → ℕ)
    (hh : ∀ᶠ t in atTop, h t ≤ C * (k t * n t * w t)) :
    (fun t => (bitsPublica (h t) (k t) (n t) (w t) : ℝ)) =O[atTop]
      (fun t => ((k t * n t * w t : ℕ) : ℝ)) := by
  refine IsBigO.of_bound ((C + 1 : ℕ) : ℝ) ?_
  filter_upwards [hh] with t ht
  rw [Real.norm_eq_abs, abs_of_nonneg (Nat.cast_nonneg _), Real.norm_eq_abs,
    abs_of_nonneg (Nat.cast_nonneg _)]
  have hb : bitsPublica (h t) (k t) (n t) (w t) ≤ (C + 1) * (k t * n t * w t) := by
    unfold bitsPublica
    nlinarith
  exact_mod_cast hb

theorem firma_familia_es_O (C : ℕ) (h k r n w : ℕ → ℕ)
    (hh : ∀ᶠ t in atTop, h t ≤ C * ((k t + r t) * n t * w t)) :
    (fun t => (bitsFirma (h t) (k t) (r t) (n t) (w t) : ℝ)) =O[atTop]
      (fun t => (((k t + r t) * n t * w t : ℕ) : ℝ)) :=
  publica_familia_es_O C h (fun t => k t + r t) n w hh

end Nexus.Complejidad.Comunicacion.Familias
