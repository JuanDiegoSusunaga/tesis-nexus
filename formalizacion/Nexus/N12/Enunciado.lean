module

public import Mathlib.Data.Nat.Basic

public section
namespace Nexus.N12

/-- Perfiles de la tabla de R1; se comprueba la aritmética, no su procedencia. -/
inductive Perfil where
  | mldsa44 | mldsa65 | mldsa87
  deriving DecidableEq

@[expose] def zeta : Perfil → ℕ
  | .mldsa44 => 350209
  | .mldsa65 => 724481
  | .mldsa87 => 769537

@[expose] def dimensiones : Perfil → ℕ
  | .mldsa44 => 9
  | .mldsa65 => 12
  | .mldsa87 => 16

/-- Desigualdad necesaria examinada en R1 para η' entero positivo. -/
@[expose] def condicion (perfil : Perfil) (eta : ℕ) : Prop :=
  2 * zeta perfil * eta * 256 * dimensiones perfil < 8380417 / 32

@[expose] def Enunciado : Prop :=
  ∀ (perfil : Perfil) (eta : ℕ), 1 ≤ eta → ¬ condicion perfil eta

end Nexus.N12
