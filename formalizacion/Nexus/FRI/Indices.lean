module

public import Nexus.FRI.Cosets
import Mathlib.Tactic

/-!
# Índices de parejas y fórmula algebraica del plegado

Se justifican a=pos mod (n/2), los índices a,a+n/2 y la expresión
even+beta*odd usada en fri.rs. No se formalizan aquí los enteros de máquina,
las aperturas Merkle ni la ejecución completa de ese programa.
-/

public section
namespace Nexus.Goldilocks

theorem representante_indice_modulo (k j pos : ℕ) (hk : k ≤ 29) (hj : j < k + 3) :
    let a := pos % (2 ^ (k + 3 - (j + 1)))
    representanteCapa k j (puntoCapa k (j + 1) a) = puntoCapa k j a := by
  exact representante_en_punto k j _ hk hj (Nat.mod_lt _ (by positivity))

/-- La posición pedida selecciona la mitad correcta de la pareja canónica. -/
theorem punto_consulta_modulo (k j pos : ℕ) (hk : k ≤ 29) (hj : j < k + 3)
    (hpos : pos < 2 ^ (k + 3 - j)) :
    let M := 2 ^ (k + 3 - (j + 1))
    let a := pos % M
    puntoCapa k j pos = if pos < M then puntoCapa k j a else -puntoCapa k j a := by
  let M := 2 ^ (k + 3 - (j + 1))
  have hsize : 2 ^ (k + 3 - j) = 2 * M := tamano_capa_siguiente k j hj
  change puntoCapa k j pos = if pos < M then puntoCapa k j (pos % M) else -puntoCapa k j (pos % M)
  by_cases hp : pos < M
  · rw [ite_eq_left hp, Nat.mod_eq_of_lt hp]
  · have hM : M ≤ pos := by omega
    let b := pos - M
    have hb : b < M := by dsimp [b]; omega
    have hsum : b + M = pos := by dsimp [b]; omega
    have hmod : pos % M = b := by
      calc
        _ = (b + M) % M := congrArg (fun n => n % M) hsum.symm
        _ = b := by rw [Nat.add_mod, Nat.mod_self, Nat.mod_eq_of_lt hb, Nat.add_zero, Nat.mod_eq_of_lt hb]
    have hhalf : k + 2 - j = k + 3 - (j + 1) := by omega
    have hop := punto_capa_opuesto k j b hk hj
    rw [hhalf] at hop
    rw [ite_eq_right hp, hmod]
    simpa only [← hsum] using hop

/-- La fórmula par/impar coincide con el plegado de los índices a,a+n/2. -/
theorem formula_plegado_indices (k j a : ℕ) (hk : k ≤ 29) (hj : j < k + 3)
    (ha : a < 2 ^ (k + 3 - (j + 1))) (u : Fp2 → Fp2) (β : Fp2) :
    Nexus.N04.par u (representanteCapa k j) (puntoCapa k (j + 1) a) +
        β * Nexus.N04.impar u (representanteCapa k j) (puntoCapa k (j + 1) a) =
      (u (puntoCapa k j a) + u (puntoCapa k j (a + 2 ^ (k + 3 - (j + 1))))) / 2 +
        β * (((u (puntoCapa k j a) - u (puntoCapa k j (a + 2 ^ (k + 3 - (j + 1))))) / 2) *
          (puntoCapa k j a)⁻¹) := by
  have hhalf : k + 2 - j = k + 3 - (j + 1) := by omega
  have hop := punto_capa_opuesto k j a hk hj
  rw [hhalf] at hop
  simp only [Nexus.N04.par, Nexus.N04.impar, representante_en_punto k j a hk hj ha,
    hop, div_eq_mul_inv, mul_inv_rev]
  ring

end Nexus.Goldilocks
