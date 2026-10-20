module

public import Nexus.AIR.Goldilocks
public import Nexus.AIR.Localidad
import Mathlib.Tactic

public section
namespace Nexus.Goldilocks

open Polynomial

theorem potencia_indice_modulo (k : ℕ) (hk : k ≤ 32) (n : ℕ) :
    raiz k ^ (n % 2 ^ k) = raiz k ^ n := by
  have hp := (raiz_primitiva k hk).pow_eq_one
  calc
    _ = raiz k ^ (n % 2 ^ k) * (raiz k ^ (2 ^ k)) ^ (n / 2 ^ k) := by
      rw [hp, one_pow, mul_one]
    _ = raiz k ^ (n % 2 ^ k + 2 ^ k * (n / 2 ^ k)) := by rw [pow_add, pow_mul]
    _ = _ := by rw [Nat.mod_add_div]

theorem coset_cerrado_potencias (k : ℕ) (hk : k ≤ 32) (j : ℕ)
    (x : Fp) (hx : x ∈ coset k) : raiz k ^ j * x ∈ coset k := by
  obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hx
  apply Finset.mem_image.mpr
  refine ⟨(i + j) % 2 ^ k, Finset.mem_range.mpr (Nat.mod_lt _ (by positivity)), ?_⟩
  rw [potencia_indice_modulo k hk, pow_add]
  ring

/-- Los índices (i+8j) mod N usados en el código evalúan g^j*x.
Los casos j=1 y j=2 corresponden a las dos posiciones de transición. -/
theorem punto_lde_desplazado (k : ℕ) (hk : k ≤ 29) (i j : ℕ) :
    7 * raiz (k + 3) ^ ((i + 8 * j) % 2 ^ (k + 3)) =
      raiz k ^ j * (7 * raiz (k + 3) ^ i) := by
  rw [potencia_indice_modulo (k + 3) (by omega), pow_add, pow_mul,
    coherencia_raices k (by omega)]
  ring

/-- La rotación x↦gx se queda en el coset L, sin asumir esa propiedad. -/
theorem coset_extension_cerrado (k : ℕ) (hk : k ≤ 29) (x : Fp2)
    (hx : x ∈ cosetExtension (k + 3)) :
    raizExtension k * x ∈ cosetExtension (k + 3) := by
  obtain ⟨y, hy, rfl⟩ := Finset.mem_image.mp hx
  apply Finset.mem_image.mpr
  refine ⟨raiz k * y, ?_, ?_⟩
  · rw [← coherencia_raices k (by omega)]
    exact coset_cerrado_potencias (k + 3) (by omega) 8 y hy
  · simp [raizExtension]

/-- S2: transferencia de la cota determinista al oráculo local sobre Goldilocks.
El candidato y los coeficientes son arbitrarios; el residuo no nulo es explícito. -/
theorem transferencia_concreta (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (f : Polynomial Fp2) (s o : Fp2) (a : Nexus.N01.Coeficientes Fp2)
    (hf : f.natDegree < 2 ^ k) (u : Fp2 → Fp2) (ε : ℚ)
    (hu : Nexus.distancia (cosetExtension (k + 3)) u f.eval ≤ ε)
    (h : Polynomial Fp2) (hh : h.natDegree < 2 * 2 ^ k)
    (hr : Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f s o a %
      Nexus.AIR.denominador (2 ^ k) ≠ 0) :
    max 0 ((5 * (2 ^ k : ℕ) + 1 : ℚ) / (8 * (2 ^ k : ℕ) : ℚ) - 3 * ε) ≤
      Nexus.distancia (cosetExtension (k + 3))
        (Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) s o a u) h.eval := by
  have hroot := raiz_extension_primitiva k (by omega : k ≤ 32)
  apply Nexus.AIR.transferencia_distancia _ _ _ s o a u f.eval h.eval
    (hroot.ne_zero (by positivity)) (coset_extension_cerrado k hk) _ ε hu
  simpa only [Nexus.AIR.composicion_polinomio] using
    distancia_composicion_concreta k hk0 hk f s o a hf h hh hr

theorem transferencia_concreta_real (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (f : Polynomial Fp2) (s o : Fp2) (a : Nexus.N01.Coeficientes Fp2)
    (hf : f.natDegree < 2 ^ k) (u : Fp2 → Fp2) (ε : ℝ)
    (hu : (Nexus.distancia (cosetExtension (k + 3)) u f.eval : ℝ) ≤ ε)
    (h : Polynomial Fp2) (hh : h.natDegree < 2 * 2 ^ k)
    (hr : Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f s o a %
      Nexus.AIR.denominador (2 ^ k) ≠ 0) :
    max 0 ((5 * (2 ^ k : ℕ) + 1 : ℝ) / (8 * (2 ^ k : ℕ) : ℝ) - 3 * ε) ≤
      (Nexus.distancia (cosetExtension (k + 3))
        (Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) s o a u) h.eval : ℝ) := by
  have hroot := raiz_extension_primitiva k (by omega : k ≤ 32)
  apply Nexus.AIR.transferencia_distancia_real _ _ _ s o a u f.eval h.eval
    (hroot.ne_zero (by positivity)) (coset_extension_cerrado k hk) _ ε hu
  have hrat : (5 * (2 ^ k : ℕ) + 1 : ℚ) / (8 * (2 ^ k : ℕ) : ℚ) ≤
      Nexus.distancia (cosetExtension (k + 3))
        (Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) s o a f.eval) h.eval := by
    simpa only [Nexus.AIR.composicion_polinomio] using
      distancia_composicion_concreta k hk0 hk f s o a hf h hh hr
  have hreal := (Rat.cast_le (K := ℝ)).mpr hrat
  simpa only [Rat.cast_div, Rat.cast_add, Rat.cast_mul, Rat.cast_natCast,
    Rat.cast_ofNat, Rat.cast_one]
    using hreal

theorem distancia_mayor_un_medio (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (f : Polynomial Fp2) (s o : Fp2) (a : Nexus.N01.Coeficientes Fp2)
    (hf : f.natDegree < 2 ^ k) (u : Fp2 → Fp2) (ε : ℚ)
    (hu : Nexus.distancia (cosetExtension (k + 3)) u f.eval ≤ ε) (hε : ε ≤ 1 / 24)
    (h : Polynomial Fp2) (hh : h.natDegree < 2 * 2 ^ k)
    (hr : Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f s o a %
      Nexus.AIR.denominador (2 ^ k) ≠ 0) :
    (1 : ℚ) / 2 < Nexus.distancia (cosetExtension (k + 3))
      (Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) s o a u) h.eval := by
  have hm := Nexus.AIR.margen_un_veinticuatro (2 ^ k) (by positivity) ε hε
  exact hm.trans_le ((le_max_right 0 _).trans
    (transferencia_concreta k hk0 hk f s o a hf u ε hu h hh hr))

end Nexus.Goldilocks
