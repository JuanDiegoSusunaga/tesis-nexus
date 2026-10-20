module

public import Mathlib.Algebra.Group.Hom.Defs
public import Mathlib.Data.Int.Basic
public import Mathlib.Algebra.Order.Ring.Int
public import Mathlib.Algebra.Group.Pi.Basic
public import Mathlib.Algebra.Order.Group.Unbundled.Abs
import Mathlib.Tactic

/-! # Lema 6.1: diferencia de preimágenes cortas, con reducción aditiva explícita. -/

public section
namespace Nexus.Reticulos

variable {ι V W : Type*} [AddCommGroup V] [AddCommGroup W]

/-- El mapa red representa la reducción al módulo cociente; B representa su mapa lineal.
La distinción se exige después de reducir, como en el enunciado del manuscrito. -/
theorem diferencia_preimagenes (red : (ι → ℤ) →+ V) (B : V →+ W)
    (x y : ι → ℤ) (L : ℤ) (hxy : red x ≠ red y) (hB : B (red x) = B (red y))
    (hx : ∀ i, |x i| ≤ L) (hy : ∀ i, |y i| ≤ L) :
    red (x - y) ≠ 0 ∧ B (red (x - y)) = 0 ∧ ∀ i, |(x - y) i| ≤ 2 * L := by
  refine ⟨?_, ?_, ?_⟩
  · simpa only [map_sub, sub_ne_zero] using hxy
  · simpa only [map_sub, sub_eq_zero] using hB
  · intro i
    change |x i - y i| ≤ 2 * L
    calc
      |x i - y i| ≤ |x i| + |y i| := abs_sub (x i) (y i)
      _ ≤ L + L := add_le_add (hx i) (hy i)
      _ = 2 * L := by ring

end Nexus.Reticulos
