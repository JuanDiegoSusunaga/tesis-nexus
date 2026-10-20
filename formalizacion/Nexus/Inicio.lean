module

public import Mathlib.Basic.Real.Basic
import Mathlib.Tactic.Ring

/-!
# Primera demostración con mathlib

Este ejemplo comprueba el entorno de formalización. Los resultados de la tesis
se incorporarán como teoremas separados, con sus hipótesis explícitas.
-/

public section

namespace Nexus

/-- Desarrollo del cuadrado de una suma de números reales. -/
theorem cuadrado_suma (a b : ℝ) :
    (a + b) ^ 2 = a ^ 2 + 2 * a * b + b ^ 2 := by
  ring

end Nexus
