module

public import Nexus.N06.SeleccionAIR
public import Nexus.AIR.Transferencia
import Mathlib.Tactic

/-!
# Del estado AIR sin escape al enlace con la composición

La elección de la composición puede depender de todos los retos anteriores.
Las cotas son uniformes para cualquier oráculo v fijado antes de la consulta.
Todavía no se afirma una cota probabilística del IOP conjunto.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

theorem escape_air_iff_resto (k : ℕ) (f : Polynomial Fp2) (s o : Fp2)
    (j : ℕ) (hj : j < 3)
    (hR : ∀ i, j < i → i < 3 → residuosPerfil k f s o i = 0)
    (a : Nexus.N01.Coeficientes Fp2) :
    Escapa (excepcionesAIR (residuosPerfil k f s o) j) (pasoAIR (residuosPerfil k f s o))
      0 3 0 (a.1, a.2.1, a.2.2, PUnit.unit) ↔
      Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f s o a %
        Nexus.AIR.denominador (2 ^ k) = 0 := by
  have he := escape_iff_cancelacion (residuosPerfil k f s o) j 0 3 (by omega) (by omega)
    (by simpa only [Nat.zero_add] using hR) 0
    (show Retos Fp2 3 from (a.1, a.2.1, a.2.2, PUnit.unit))
  simpa only [zero_add, suma_retos_residuo_combinado, Nexus.AIR.numeradorCombinado] using he

/-- El candidato previo a AIR da la transferencia fuera de su evento crítico exacto. -/
theorem candidato_sin_escape_transferencia (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (u : Fp2 → Fp2) (δt : ℚ) (f : Polynomial Fp2)
    (hc : candidatoPerfil k u δt = some f) (s o : Fp2)
    (hf : ¬ Nexus.AIR.Valida (raizExtension k) (2 ^ k) f s o)
    (a : Nexus.N01.Coeficientes Fp2) :
    let R := residuosPerfil k f s o
    let j := rondaCritica R 3 (residuos_perfil_no_nulos k (by omega) (by omega) f s o hf)
    (¬ Escapa (excepcionesAIR R j) (pasoAIR R) 0 3 0 (a.1, a.2.1, a.2.2, PUnit.unit)) →
    ∀ h : Polynomial Fp2, h.natDegree < 2 * 2 ^ k →
      max 0 ((5 * (2 ^ k : ℕ) + 1 : ℚ) / (8 * (2 ^ k : ℕ) : ℚ) - 3 * δt) ≤
        Nexus.distancia (cosetExtension (k + 3))
          (Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) s o a u) h.eval := by
  let R := residuosPerfil k f s o
  have hn := residuos_perfil_no_nulos k (by omega : 2 ≤ k) (by omega : k ≤ 32) f s o hf
  let j := rondaCritica R 3 hn
  change (¬ Escapa (excepcionesAIR R j) (pasoAIR R) 0 3 0 (a.1, a.2.1, a.2.2, PUnit.unit)) → _
  intro hno h hh
  have hj := ronda_critica_propiedades R 3 hn
  have hr : Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f s o a %
      Nexus.AIR.denominador (2 ^ k) ≠ 0 := by
    intro hz
    exact hno ((escape_air_iff_resto k f s o j hj.1 hj.2.2 a).mpr hz)
  have hp := candidato_propiedad _ u _ δt f hc
  exact transferencia_concreta k hk0 hk f s o a hp.1 u δt hp.2 h hh hr

/-- La cercanía de v al código resta solo δc, aunque v se elija después de los retos. -/
theorem candidato_composicion_enlace (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (u v : Fp2 → Fp2) (δt δc : ℚ) (f h : Polynomial Fp2)
    (hc : candidatoPerfil k u δt = some f)
    (hv : candidato (cosetExtension (k + 3)) v (2 * 2 ^ k) δc = some h)
    (s o : Fp2) (a : Nexus.N01.Coeficientes Fp2)
    (hr : Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f s o a %
      Nexus.AIR.denominador (2 ^ k) ≠ 0) :
    max 0 ((5 * (2 ^ k : ℕ) + 1 : ℚ) / (8 * (2 ^ k : ℕ) : ℚ) - 3 * δt - δc) ≤
      Nexus.distancia (cosetExtension (k + 3)) v
        (Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) s o a u) := by
  have hp := candidato_propiedad _ u _ δt f hc
  have hq := candidato_propiedad _ v _ δc h hv
  have hlower := transferencia_concreta k hk0 hk f s o a hp.1 u δt hp.2 h hq.1 hr
  have htri := Nexus.distancia_triangular (cosetExtension (k + 3))
    (Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) s o a u) v h.eval
  rw [Nexus.distancia_simetrica (cosetExtension (k + 3))
    (Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) s o a u) v] at htri
  apply max_le (Nexus.distancia_no_negativa _ _ _)
  have hl := (le_max_right 0 _).trans hlower
  linarith [hq.2]

/-- La composición elegida arbitrariamente cae en la rama lejana o en la rama de enlace. -/
theorem alternativa_composicion (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (u v : Fp2 → Fp2) (δt δc : ℚ) (f : Polynomial Fp2)
    (hc : candidatoPerfil k u δt = some f) (s o : Fp2) (a : Nexus.N01.Coeficientes Fp2)
    (hr : Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f s o a %
      Nexus.AIR.denominador (2 ^ k) ≠ 0) :
    match candidato (cosetExtension (k + 3)) v (2 * 2 ^ k) δc with
    | none => ∀ h : Polynomial Fp2, h.natDegree < 2 * 2 ^ k →
        δc < Nexus.distancia (cosetExtension (k + 3)) v h.eval
    | some h => Proximo (cosetExtension (k + 3)) v (2 * 2 ^ k) δc h ∧
        max 0 ((5 * (2 ^ k : ℕ) + 1 : ℚ) / (8 * (2 ^ k : ℕ) : ℚ) - 3 * δt - δc) ≤
          Nexus.distancia (cosetExtension (k + 3)) v
            (Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) s o a u) := by
  cases hv : candidato (cosetExtension (k + 3)) v (2 * 2 ^ k) δc with
  | none => exact (candidato_ninguno_iff _ v _ δc).mp hv
  | some h => exact ⟨candidato_propiedad _ v _ δc h hv,
      candidato_composicion_enlace k hk0 hk u v δt δc f h hc hv s o a hr⟩

end Nexus.Goldilocks
