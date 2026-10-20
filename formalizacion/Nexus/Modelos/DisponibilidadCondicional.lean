module

public import Nexus.Modelos.QuorumIncentivos
public import Nexus.N05.Muestreo
import Mathlib.Tactic

/-!
# Alcance de las afirmaciones de disponibilidad y quórum

Se fija el conjunto de fragmentos disponibles antes del muestreo uniforme.
La fórmula no certifica disponibilidad desplegada ni un incentivo económico.
Un ejemplo en la frontera 2/3 muestra por qué no puede omitirse la desigualdad
estricta del límite bizantino. No modifica el consenso ni los entregables TG1.
-/

public section
namespace Nexus.Modelos.Disponibilidad.Condicional

open Nexus.Modelos.Quorum

theorem omision_fragmentos_no_disponibles {I : Type*} [DecidableEq I]
    (fragmentos disponibles : Finset I) (q : ℕ) (hs : disponibles ⊆ fragmentos)
    (hq : q ≤ fragmentos.card) :
    0 < (fragmentos.powersetCard q).card ∧
      ((((fragmentos.powersetCard q).filter (fun S => S ⊆ disponibles)).card : ℚ) /
        (fragmentos.powersetCard q).card =
        (Nat.choose disponibles.card q : ℚ) / Nat.choose fragmentos.card q) :=
  ⟨Nexus.N05.muestras_no_vacias fragmentos q hq,
    Nexus.N05.probabilidad_omision fragmentos disponibles q hs⟩

theorem frontera_quorum_sin_interseccion_honesta :
    let w : Fin 3 → ℚ := fun _ => 1 / 3
    let a : Finset (Fin 3) := {0, 1}
    let b : Finset (Fin 3) := {0, 2}
    let malos : Finset (Fin 3) := {0}
    peso w Finset.univ = 1 ∧ peso w a = 2 / 3 ∧ peso w b = 2 / 3 ∧
      peso w malos = 1 / 3 ∧ ¬ ∃ i ∈ a ∩ b, i ∉ malos := by
  norm_num [peso, Fin.sum_univ_succ, Finset.mem_inter, Finset.mem_insert, Finset.mem_singleton]

end Nexus.Modelos.Disponibilidad.Condicional
