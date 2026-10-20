module

public import Nexus.N12.Enunciado
import Mathlib.Tactic

public section
namespace Nexus.N12

/-- La condición falla para todo η'≥1 en los tres perfiles de la tabla. -/
theorem condicion_falla : Enunciado := by
  intro perfil eta heta
  cases perfil <;> norm_num [condicion, zeta, dimensiones] <;> omega

/-- Los valores del lado izquierdo con η'=1 coinciden con el manuscrito. -/
theorem cuentas_minimas :
    2 * zeta .mldsa44 * 1 * 256 * dimensiones .mldsa44 = 1613763072 ∧
    2 * zeta .mldsa65 * 1 * 256 * dimensiones .mldsa65 = 4451211264 ∧
    2 * zeta .mldsa87 * 1 * 256 * dimensiones .mldsa87 = 6304047104 ∧
    8380417 / 32 = (261888 : ℕ) := by
  norm_num [zeta, dimensiones]

end Nexus.N12
