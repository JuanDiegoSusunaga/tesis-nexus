module

public import Nexus.Complejidad.Rechazo
public import Nexus.MLDSA.Parametros
import Mathlib.Tactic

/-!
# Bloques de máscaras y agotamiento de kappa de 16 bits

El contador de la copia fips204-0.4.6 avanza ell tras un rechazo.
El modelo distingue usar un bloque completo, incrementar sin desbordar y
un eventual rollover; la ley IID sigue siendo una hipótesis separada.
-/

public section
namespace Nexus.Complejidad.ContadorFirma

open Nexus.MLDSA

@[expose] def inicio (l intento : ℕ) : ℕ := l * intento
@[expose] def bloqueValido (l intento : ℕ) : Prop := l * intento + l ≤ 2 ^ 16
@[expose] def incrementoValido (l intento : ℕ) : Prop := l * intento + l < 2 ^ 16
@[expose] def capacidad (l : ℕ) : ℕ := 2 ^ 16 / l
@[expose] def contadorEnvuelto (l intento : ℕ) : ℕ := l * intento % 2 ^ 16

theorem bloques_disjuntos (l i j a b : ℕ) (ha : a < l) (hb : b < l)
    (he : inicio l i + a = inicio l j + b) : i = j ∧ a = b := by
  unfold inicio at he
  have hij : i = j := by
    rcases lt_trichotomy i j with h | h | h
    · have hm := Nat.mul_le_mul_left l (Nat.succ_le_iff.mpr h)
      simp only [Nat.mul_succ] at hm
      omega
    · exact h
    · have hm := Nat.mul_le_mul_left l (Nat.succ_le_iff.mpr h)
      simp only [Nat.mul_succ] at hm
      omega
  exact ⟨hij, by simpa only [hij, Nat.add_left_cancel_iff] using he⟩

theorem mascara_dentro_u16 (l intento j : ℕ) (hb : bloqueValido l intento) (hj : j < l) :
    inicio l intento + j < 2 ^ 16 := by unfold inicio bloqueValido at *; omega

theorem bloque_por_capacidad (l intento : ℕ) (hl : 0 < l) :
    bloqueValido l intento ↔ intento < capacidad l := by
  unfold bloqueValido capacidad
  rw [show l * intento + l = l * (intento + 1) by ring]
  rw [Nat.mul_comm l, ← Nat.le_div_iff_mul_le hl]
  omega

theorem anterior_no_envuelve (l intento : ℕ) (h : incrementoValido l intento) :
    contadorEnvuelto l (intento + 1) = inicio l intento + l := by
  unfold contadorEnvuelto inicio incrementoValido at *
  rw [Nat.mul_add, Nat.mul_one, Nat.mod_eq_of_lt h]

theorem capacidades_perfiles : capacidad (ell .m44) = 16384 ∧
    capacidad (ell .m65) = 13107 ∧ capacidad (ell .m87) = 9362 := by
  norm_num [capacidad, ell]

theorem frontera_44 : bloqueValido (ell .m44) 16383 ∧ ¬ incrementoValido (ell .m44) 16383 ∧
    contadorEnvuelto (ell .m44) 16384 = 0 := by
  norm_num [bloqueValido, incrementoValido, contadorEnvuelto, ell]

theorem frontera_65 : bloqueValido (ell .m65) 13106 ∧ ¬ bloqueValido (ell .m65) 13107 := by
  norm_num [bloqueValido, ell]

theorem frontera_87 : bloqueValido (ell .m87) 9361 ∧ ¬ bloqueValido (ell .m87) 9362 := by
  norm_num [bloqueValido, ell]

theorem agotamiento_ideal (p : unitInterval) (hp : 0 < (p : ℝ)) (l : ℕ) :
    (ProbabilityTheory.geometricMeasure p).real (Set.Ici (capacidad l)) =
      (1 - (p : ℝ)) ^ capacidad l := Rechazo.probabilidad_agotamiento p hp (capacidad l)

end Nexus.Complejidad.ContadorFirma
