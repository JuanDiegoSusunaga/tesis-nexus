module

public import Nexus.MLDSA.NTTAlgebra
import Mathlib.Tactic

/-!
# Coste de la NTT recursiva con resultados intermedios compartidos

El plan evalúa una vez cada mitad y combina mediante 2^r mariposas.
La cuenta es de operaciones de campo; no es una cota de bits ni de CPU.
La función transformar de referencia permite repetir evaluaciones aisladas:
esta cuenta corresponde al plan completo que comparte ambas mitades.
-/

public section
namespace Nexus.Complejidad.CosteNTT

@[expose] def mariposas : ℕ → ℕ
  | 0 => 0
  | r + 1 => 2 * mariposas r + 2 ^ r

@[expose] def sumas (r : ℕ) : ℕ := 2 * mariposas r
@[expose] def productos (r : ℕ) : ℕ := mariposas r

theorem mariposas_doble (r : ℕ) : 2 * mariposas r = r * 2 ^ r := by
  induction r with
  | zero => rfl
  | succ r ih => rw [mariposas, pow_succ]; nlinarith

theorem mariposas_exactas (r : ℕ) : mariposas (r + 1) = (r + 1) * 2 ^ r := by
  rw [mariposas, mariposas_doble]
  ring

theorem sumas_exactas (r : ℕ) : sumas r = r * 2 ^ r := mariposas_doble r

theorem productos_exactos (r : ℕ) : productos (r + 1) = (r + 1) * 2 ^ r :=
  mariposas_exactas r

theorem trabajo_nlogn (r : ℕ) : sumas r + productos r ≤ 2 * (r * 2 ^ r) := by
  have h := mariposas_doble r
  unfold sumas productos
  omega

theorem mldsa_256_cuenta : mariposas 8 = 1024 ∧ sumas 8 = 2048 ∧ productos 8 = 1024 := by
  norm_num [sumas, productos, mariposas]

theorem base_sin_operaciones : sumas 0 = 0 ∧ productos 0 = 0 := ⟨rfl, rfl⟩

theorem mariposas_crecientes (r : ℕ) : mariposas r < mariposas (r + 1) := by
  rw [mariposas]
  have hp : 0 < 2 ^ r := by positivity
  omega

end Nexus.Complejidad.CosteNTT
