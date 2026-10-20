module

public import Nexus.AIR.Transferencia
public import Nexus.FRI.Indices
import Mathlib.Tactic

/-!
# Las seis posiciones AIR de una pareja de consulta

Las posiciones son i+8j en la mitad positiva e i+N/2+8j en la negativa,
módulo N, con j=0,1,2. Se identifican con g^j*x y g^j*(-x) sobre
Goldilocks. Las operaciones aquí son de naturales, sin desbordamientos.
-/

public section
namespace Nexus.Goldilocks

abbrev PosicionAIR := Bool × Fin 3

@[expose] def signoPareja (b : Bool) (x : Fp2) : Fp2 := if b then -x else x

@[expose] def indiceAIR (k i : ℕ) (b : Bool) (j : ℕ) : ℕ :=
  (i + (if b then 2 ^ (k + 2) else 0) + 8 * j) % 2 ^ (k + 3)

theorem posiciones_air_cardinal : Fintype.card PosicionAIR = 6 := by simp [PosicionAIR]

theorem punto_inicial_inmersion (k i : ℕ) :
    puntoCapa k 0 i = algebraMap Fp Fp2 (7 * raiz (k + 3) ^ i) := by
  simp only [puntoCapa, desplazamientoCapa, pow_zero, pow_one, Nat.sub_zero, raizExtension, map_mul, map_pow]

theorem punto_inicial_periodico (k : ℕ) (hk : k ≤ 29) (i : ℕ) :
    puntoCapa k 0 (i % 2 ^ (k + 3)) = puntoCapa k 0 i := by
  simp only [punto_inicial_inmersion, potencia_indice_modulo (k + 3) (by omega)]

theorem punto_inicial_desplazado (k : ℕ) (hk : k ≤ 29) (i j : ℕ) :
    puntoCapa k 0 ((i + 8 * j) % 2 ^ (k + 3)) = raizExtension k ^ j * puntoCapa k 0 i := by
  simpa only [punto_inicial_inmersion, raizExtension, map_mul, map_pow] using
    congrArg (algebraMap Fp Fp2) (punto_lde_desplazado k hk i j)

theorem indice_air_cota (k i : ℕ) (b : Bool) (j : ℕ) : indiceAIR k i b j < 2 ^ (k + 3) :=
  Nat.mod_lt _ (by positivity)

theorem punto_indice_air (k : ℕ) (hk : k ≤ 29) (i j : ℕ) (b : Bool) :
    puntoCapa k 0 (indiceAIR k i b j) = raizExtension k ^ j * signoPareja b (puntoCapa k 0 i) := by
  cases b with
  | false =>
    simpa only [indiceAIR, signoPareja, Bool.false_eq_true, ite_false, Nat.add_zero] using
      punto_inicial_desplazado k hk i j
  | true =>
    have hop : puntoCapa k 0 (i + 2 ^ (k + 2)) = -puntoCapa k 0 i := by
      simpa only [Nat.sub_zero] using punto_capa_opuesto k 0 i hk (by omega)
    simpa only [indiceAIR, signoPareja, ite_true, hop] using
      punto_inicial_desplazado k hk (i + 2 ^ (k + 2)) j

theorem indice_air_inicial (k i : ℕ) (hi : i < 2 ^ (k + 2)) (b : Bool) :
    indiceAIR k i b 0 = i + (if b then 2 ^ (k + 2) else 0) := by
  have ht : 2 ^ (k + 3) = 2 * 2 ^ (k + 2) := by
    rw [show k + 3 = k + 2 + 1 by omega, pow_succ, Nat.mul_comm]
  simp only [indiceAIR, Nat.mul_zero, Nat.add_zero]
  apply Nat.mod_eq_of_lt
  split_ifs <;> omega

theorem pareja_indice_air (k : ℕ) (hk : k ≤ 29) (i : ℕ) (hi : i < 2 ^ (k + 2)) :
    Nexus.FRI.elevar (representanteCapa k 0) {puntoCapa k 1 i} =
      {puntoCapa k 0 i, -puntoCapa k 0 i} := by
  have hr : representanteCapa k 0 (puntoCapa k 1 i) = puntoCapa k 0 i := by
    simpa only [show k + 3 - (0 + 1) = k + 2 by omega] using representante_en_punto k 0 i hk (by omega) hi
  simp only [Nexus.FRI.elevar, Finset.image_singleton, hr, Finset.union_singleton]
  ext x
  simp only [Finset.mem_insert, Finset.mem_singleton]
  tauto

end Nexus.Goldilocks
