module

public import Nexus.AIR.CocientesAlejados
public import Nexus.AIR.Interpolacion
public import Nexus.FRI.Cosets
import Mathlib.Tactic

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.AIR.Contraejemplo

/-- Traza honesta interpolada desde 3 y 5; el final es el de la recurrencia. -/
@[expose] noncomputable def trazaHonesta (k : ℕ) : Polynomial Fp2 :=
  interpolante (2 ^ k) (raizExtension k) 3 5

/-- Contraejemplo algebraico con lambda=1, sin ejecutar ni asumir el verificador. -/
@[expose] noncomputable def trazaAlejada (k : ℕ) : Polynomial Fp2 :=
  perturbada (2 ^ k) (trazaHonesta k) 1

theorem grado_traza_honesta (k : ℕ) (hk : k ≤ 32) : (trazaHonesta k).natDegree < 2 ^ k :=
  grado_interpolante _ (by positivity) _ _ _ (raiz_extension_primitiva k hk)

/-- El interpolante de extensión es la imagen de una traza del campo base. -/
theorem traza_honesta_imagen_base (k : ℕ) (hk : k ≤ 32) :
    (interpolante (2 ^ k) (raiz k) (3 : Fp) 5).map (algebraMap Fp Fp2) = trazaHonesta k := by
  let phi := algebraMap Fp Fp2
  apply Polynomial.eq_of_degrees_lt_of_eval_index_eq (Finset.range (2 ^ k))
    (v := fun i => raizExtension k ^ i)
  · intro i hi j hj hij
    exact (raiz_extension_primitiva k hk).pow_inj
      (Finset.mem_range.mp hi) (Finset.mem_range.mp hj) hij
  · have h := (natDegree_map_le (p := interpolante (2 ^ k) (raiz k) (3 : Fp) 5)
        (f := phi)).trans_lt (grado_interpolante _ (by positivity) _ _ _ (raiz_primitiva k hk))
    rw [Finset.card_range]
    exact degree_le_natDegree.trans_lt (by exact_mod_cast h)
  · rw [Finset.card_range]
    exact degree_le_natDegree.trans_lt (by exact_mod_cast grado_traza_honesta k hk)
  · intro i hi
    change ((interpolante (2 ^ k) (raiz k) (3 : Fp) 5).map phi).eval (phi (raiz k) ^ i) = _
    rw [← map_pow, eval_map_apply, evaluacion_interpolante _ _ _ _ (raiz_primitiva k hk)
      i (Finset.mem_range.mp hi), fila_map]
    simpa only [trazaHonesta, map_ofNat] using
      (evaluacion_interpolante _ _ _ _ (raiz_extension_primitiva k hk) i (Finset.mem_range.mp hi)).symm

theorem traza_alejada_imagen_base (k : ℕ) (hk : k ≤ 32) :
    (perturbada (2 ^ k) (interpolante (2 ^ k) (raiz k) (3 : Fp) 5) 1).map
      (algebraMap Fp Fp2) = trazaAlejada k := by
  unfold trazaAlejada perturbada Nexus.AIR.denominador
  rw [Polynomial.map_add, Polynomial.map_mul, Polynomial.map_C, map_one,
    Polynomial.map_sub, Polynomial.map_pow, Polynomial.map_X, Polynomial.map_one,
    traza_honesta_imagen_base k hk]

theorem grado_traza_alejada (k : ℕ) (hk : k ≤ 32) : (trazaAlejada k).natDegree = 2 ^ k :=
  grado_perturbada _ _ _ (grado_traza_honesta k hk) one_ne_zero

theorem validez_traza_alejada (k : ℕ) (hk0 : 2 ≤ k) (hk : k ≤ 32) :
    Nexus.AIR.Valida (raizExtension k) (2 ^ k) (trazaAlejada k) 3
      (fila (3 : Fp2) 5 (2 ^ k - 1)) := by
  have hT : 3 ≤ 2 ^ k := by
    have h := Nat.pow_le_pow_right (n := 2) (by decide) hk0
    norm_num at h
    omega
  apply (validez_conservada _ _ (raiz_extension_primitiva k hk).pow_eq_one _ _ _ _).mpr
  exact interpolante_valido _ hT _ _ _ (raiz_extension_primitiva k hk)

theorem distancia_exacta_traza_alejada (k : ℕ) (hk : k ≤ 29) :
    IsLeast {d : ℚ | ∃ h : Polynomial Fp2, h.natDegree < 2 ^ k ∧
      Nexus.distancia (cosetExtension (k + 3)) (trazaAlejada k).eval h.eval = d} (7 / 8) := by
  apply distancia_exacta_siete_octavos (2 ^ k) (by positivity) _ _ _
    (grado_traza_alejada k (by omega))
  rw [cardinal_coset_extension _ (by omega), pow_add]
  norm_num [Nat.mul_comm]

theorem distancia_honesta_alejada (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) :
    Nexus.distancia (cosetExtension (k + 3)) (trazaAlejada k).eval (trazaHonesta k).eval = 1 := by
  apply distancia_del_testigo (2 ^ k) (trazaHonesta k) 1 one_ne_zero
  · intro x hx
    have h := denominador_extension_no_nulo k hk0 hk x hx
    simpa only [Nexus.AIR.denominador, eval_sub, eval_pow, eval_X, eval_one, sub_ne_zero] using h
  · apply Finset.card_pos.mp
    rw [cardinal_coset_extension _ (by omega)]
    positivity

theorem composicion_alejada_en_codigo (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (a : Nexus.N01.Coeficientes Fp2) :
    (composicion (2 ^ k) (raizExtension k) (trazaAlejada k) 3
      (fila (3 : Fp2) 5 (2 ^ k - 1)) a).natDegree < 2 * 2 ^ k := by
  apply grado_composicion_objetivo (2 ^ k) _ _ _ 1 _ _ a (grado_traza_honesta k (by omega)) one_ne_zero
  have h := Nat.pow_le_pow_right (n := 2) (by decide) hk0
  norm_num at h
  omega

theorem transicion_alejada_grado (k : ℕ) (hk : k ≤ 32) :
    (Nexus.AIR.transicion (raizExtension k) (trazaAlejada k)).natDegree = 2 * 2 ^ k :=
  grado_transicion_exacto _ (by positivity) _ (raiz_extension_primitiva k hk).pow_eq_one
    _ 1 (grado_traza_honesta k hk) one_ne_zero dos_extension_no_cero

/-- Contraejemplo completo del modelo: ejecución válida, traza distante y composición de bajo grado. -/
theorem contraejemplo_concreto (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) :
    let F := trazaAlejada k
    let T := 2 ^ k
    let o := fila (3 : Fp2) 5 (T - 1)
    F.natDegree = T ∧ Nexus.AIR.Valida (raizExtension k) T F 3 o ∧
      IsLeast {d : ℚ | ∃ h : Polynomial Fp2, h.natDegree < T ∧
        Nexus.distancia (cosetExtension (k + 3)) F.eval h.eval = d} (7 / 8) ∧
      ∀ a : Nexus.N01.Coeficientes Fp2,
        (composicion T (raizExtension k) F 3 o a).natDegree < 2 * T ∧
        ∀ x ∈ cosetExtension (k + 3),
          (composicion T (raizExtension k) F 3 o a).eval x =
            (Nexus.AIR.numeradorCombinado T (raizExtension k) F 3 o a).eval x /
              (Nexus.AIR.denominador T : Polynomial Fp2).eval x := by
  refine ⟨grado_traza_alejada k (by omega), validez_traza_alejada k (by omega) (by omega),
    distancia_exacta_traza_alejada k hk, ?_⟩
  intro a
  refine ⟨composicion_alejada_en_codigo k hk0 hk a, ?_⟩
  intro x hx
  apply evaluacion_composicion (2 ^ k) _ _ (raiz_extension_primitiva k (by omega))
    (trazaHonesta k) 1 _ _ a _ x (denominador_extension_no_nulo k hk0 hk x hx)
  · have h := Nat.pow_le_pow_right (n := 2) (by decide) hk0
    norm_num at h
    omega
  · exact interpolante_valido _ (by
      have h := Nat.pow_le_pow_right (n := 2) (by decide) hk0
      norm_num at h
      omega) _ _ _ (raiz_extension_primitiva k (by omega))

theorem sin_aproximante_un_veinticuatro (k : ℕ) (hk : k ≤ 29)
    (h : Polynomial Fp2) (hh : h.natDegree < 2 ^ k) :
    ¬ Nexus.distancia (cosetExtension (k + 3)) (trazaAlejada k).eval h.eval ≤ 1 / 24 := by
  have hd := (distancia_exacta_traza_alejada k hk).2 ⟨h, hh, rfl⟩
  linarith

/-- Columnas algebraicas de la tabla 6.17; no afirma aceptaciones de programas. -/
theorem cuentas_tabla_6_17 (k : ℕ) (hk : k = 4 ∨ k = 5 ∨ k = 6) :
    (2 ^ k, 2 ^ k + 2) ∈ ({(16, 18), (32, 34), (64, 66)} : Finset (ℕ × ℕ)) := by
  rcases hk with rfl | rfl | rfl <;> norm_num

end Nexus.Goldilocks
