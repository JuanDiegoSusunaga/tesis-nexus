module

public import Nexus.N05.Cotas
public import Nexus.Campos.Goldilocks
public import Mathlib.Data.Fin.VecNotation
import Mathlib.Tactic

public section
namespace Nexus.Modelos.Omision

@[expose] def filas : Fin 4 → ℕ := ![16, 64, 256, 4096]
@[expose] def superior : Fin 4 → ℚ :=
  ![166165 / 1000000000, 2934060 / 1000000000,
    4282720 / 1000000000, 4757331 / 1000000000]

/-- Aritmética del límite propuesto; no demuestra la solidez ideal del IOP. -/
@[expose] def limiteIdeal (T : ℕ) : ℚ :=
  Nexus.N05.H (4 * T) 40 (1 / 8) + (8 * (T : ℚ) - 3) / (Nexus.Goldilocks.p : ℚ) ^ 2

set_option maxRecDepth 4096 in
/-- Los cuatro límites refinados de la tabla 6.22 se redondean hacia arriba. -/
theorem tabla6_22 (i : Fin 4) :
    limiteIdeal (filas i) ≤ superior i ∧
      superior i - limiteIdeal (filas i) < 1 / 1000000000 := by
  fin_cases i <;>
    norm_num [limiteIdeal, filas, superior, Nexus.N05.H, Nexus.Goldilocks.p,
      Nat.choose_eq_descFactorial_div_factorial, Nat.descFactorial]

/-- Todos los perfiles implementados admiten cuarenta parejas distintas. -/
theorem muestras_perfiles (k : ℕ) (hk : 4 ≤ k) : 40 ≤ 4 * 2 ^ k := by
  have hpow : 2 ^ 4 ≤ 2 ^ k := Nat.pow_le_pow_right (by decide) hk
  norm_num at hpow
  omega

/-- En todos los perfiles implementados, el redondeo de (1/8)*4T es T/2. -/
theorem techo_perfiles (k : ℕ) (hk : 4 ≤ k) (hk1 : k ≤ 12) :
    ⌈(1 / 8 : ℚ) * (4 * (2 ^ k : ℕ))⌉₊ = 2 ^ (k - 1) := by
  interval_cases k <;> norm_num

end Nexus.Modelos.Omision
