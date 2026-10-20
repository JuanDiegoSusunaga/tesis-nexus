module

public import Mathlib.Algebra.Order.Ring.Rat
public import Mathlib.Data.Fin.VecNotation
import Mathlib.Tactic

public section
namespace Nexus.Modelos.DistanciaAIR

@[expose] def filas : Fin 5 → ℕ := ![16, 64, 256, 4096, 262144]
@[expose] def dominios : Fin 5 → ℕ := ![128, 512, 2048, 32768, 2097152]
@[expose] def exacta : Fin 5 → ℚ :=
  ![632812 / 1000000, 626953 / 1000000, 625488 / 1000000,
    625030 / 1000000, 625000 / 1000000]
@[expose] def cercana : Fin 5 → ℚ :=
  ![507812 / 1000000, 501953 / 1000000, 500488 / 1000000,
    500030 / 1000000, 500000 / 1000000]

/-- Tabla 6.16: N=8T y las diez cotas redondeadas hacia abajo a seis decimales. -/
theorem tabla6_16 (i : Fin 5) :
    let T := filas i
    let d : ℚ := (5 * T + 1) / (8 * T)
    dominios i = 8 * T ∧
    exacta i ≤ d ∧ d - exacta i < 1 / 1000000 ∧
    cercana i ≤ d - 1 / 8 ∧ d - 1 / 8 - cercana i < 1 / 1000000 := by
  fin_cases i <;> norm_num [filas, dominios, exacta, cercana]

end Nexus.Modelos.DistanciaAIR
