module

public import Nexus.MLDSA.Parametros
public import Nexus.N12.Solucion
import Mathlib.Tactic

/-!
# Instanciación del contraste de JMW24

Se usa arXiv:2312.16619v2, Teorema 2 y sección 4. La norma del
teorema citado es infinito de coeficientes centrados. Solo se demuestra
el incumplimiento de su desigualdad necesaria para la traducción indicada;
no se formaliza la reducción cuántica ni se obtiene un ataque.
-/

public section
namespace Nexus.MLDSA.ContrasteJMW

@[expose] def gammaExtraccion (p : Perfil) : ℕ :=
  max (gammaUno p - beta p) (2 * gammaDos p + 1 + 2 ^ (d - 1) * tau p)

@[expose] def dimensiones (p : Perfil) : ℕ := k p + ell p + 1

@[expose] def perfilNumerico : Perfil → Nexus.N12.Perfil
  | .m44 => .mldsa44
  | .m65 => .mldsa65
  | .m87 => .mldsa87

theorem gamma_desde_parametros (p : Perfil) :
    gammaExtraccion p = Nexus.N12.zeta (perfilNumerico p) := by
  cases p <;> norm_num [gammaExtraccion, gammaUno, gammaDos, beta, tau, d,
    Nexus.N12.zeta, perfilNumerico]

theorem dimensiones_desde_parametros (p : Perfil) :
    dimensiones p = Nexus.N12.dimensiones (perfilNumerico p) := by
  cases p <;> norm_num [dimensiones, k, ell, perfilNumerico, Nexus.N12.dimensiones]

theorem dimensiones_testigo (p : Perfil) :
    Fintype.card (Fin (k p) ⊕ Fin (ell p + 1)) = dimensiones p := by
  simp [dimensiones, Nat.add_assoc]

theorem parametro_auxiliar_separado : eta .m44 = 2 ∧ eta .m65 = 4 ∧ eta .m87 = 2 := by
  norm_num [eta]

@[expose] def CondicionNecesaria (p : Perfil) (etaAux : ℕ) : Prop :=
  2 * gammaExtraccion p * etaAux * n * dimensiones p < q / 32

theorem condicion_equivalente (p : Perfil) (etaAux : ℕ) :
    CondicionNecesaria p etaAux ↔ Nexus.N12.condicion (perfilNumerico p) etaAux := by
  rw [CondicionNecesaria, gamma_desde_parametros, dimensiones_desde_parametros]
  rfl

theorem aplicacion_directa_descartada (p : Perfil) (etaAux : ℕ) (h : 1 ≤ etaAux) :
    ¬ CondicionNecesaria p etaAux := by
  rw [condicion_equivalente]
  exact Nexus.N12.condicion_falla (perfilNumerico p) etaAux h

theorem lado_derecho : q / 32 = 261888 := by norm_num [q]

theorem lados_izquierdos (p : Perfil) :
    2 * gammaExtraccion p * 1 * n * dimensiones p =
      match p with | .m44 => 1613763072 | .m65 => 4451211264 | .m87 => 6304047104 := by
  cases p <;> norm_num [gammaExtraccion, gammaUno, gammaDos, beta, tau, d, n, dimensiones, k, ell]

theorem robustez_cota_mayor (p : Perfil) (etaAux gamma : ℕ)
    (he : 1 ≤ etaAux) (hg : gammaExtraccion p ≤ gamma) :
    ¬ 2 * gamma * etaAux * n * dimensiones p < q / 32 := by
  have hb := aplicacion_directa_descartada p etaAux he
  unfold CondicionNecesaria at hb
  have hm := Nat.mul_le_mul_right (dimensiones p)
    (Nat.mul_le_mul_right n (Nat.mul_le_mul_right etaAux (Nat.mul_le_mul_left 2 hg)))
  exact fun h => hb (hm.trans_lt h)

end Nexus.MLDSA.ContrasteJMW
