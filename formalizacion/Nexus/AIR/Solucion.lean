module

public import Nexus.AIR.Enunciado
public import Nexus.N01.Solucion
import Mathlib.Tactic

public section
namespace Nexus.AIR

open Polynomial
variable {K : Type*} [Field K]

/-- Divisibilidad por el anulador equivale a anularse en todas las filas. -/
theorem anulador_dvd_iff (H : Finset K) (P : Polynomial K) :
    anulador H ∣ P ↔ ∀ x ∈ H, P.eval x = 0 := by
  classical
  constructor
  · intro h x hx
    have hfactor : (X - C x : Polynomial K) ∣ anulador H :=
      Finset.dvd_prod_of_mem (fun y => (X - C y : Polynomial K)) hx
    exact (Polynomial.dvd_iff_isRoot.mp (hfactor.trans h))
  · intro h
    apply Finset.prod_dvd_of_coprime
    · intro a _ b _ hab
      exact Polynomial.pairwise_coprime_X_sub_C Function.injective_id hab
    · intro a ha
      exact Polynomial.dvd_iff_isRoot.mpr (h a ha)

/-- El cociente de frontera es el producto de los factores de las otras filas. -/
theorem cociente_frontera [DecidableEq K] (H : Finset K) (a : K) (ha : a ∈ H) :
    anulador H / (X - C a) = anulador (H.erase a) := by
  classical
  have hfactor := Finset.mul_prod_erase H (fun x => (X - C x : Polynomial K)) ha
  change (∏ x ∈ H, (X - C x : Polynomial K)) / (X - C a) = _
  rw [← hfactor, mul_div_cancel_left₀ _ (Polynomial.X_sub_C_ne_zero a)]
  rfl

/-- El cociente no se anula en la fila que se quitó del producto. -/
theorem cociente_no_nulo [DecidableEq K] (H : Finset K) (a : K) :
    (anulador (H.erase a)).eval a ≠ 0 := by
  classical
  simp only [anulador, Polynomial.eval_prod, Polynomial.eval_sub, Polynomial.eval_X,
    Polynomial.eval_C, Finset.prod_ne_zero_iff]
  intro x hx
  exact sub_ne_zero.mpr (Finset.mem_erase.mp hx).1.symm

/-- La frontera inicial o final equivale a la divisibilidad de su numerador. -/
theorem frontera_dvd_iff (H : Finset K) (f : Polynomial K) (s a : K) (ha : a ∈ H) :
    anulador H ∣ frontera (anulador H) f s a ↔ f.eval a = s := by
  classical
  rw [anulador_dvd_iff]
  simp only [frontera, cociente_frontera H a ha, Polynomial.eval_mul,
    Polynomial.eval_sub, Polynomial.eval_C]
  constructor
  · intro h
    exact sub_eq_zero.mp ((mul_eq_zero.mp (h a ha)).resolve_right (cociente_no_nulo H a))
  · intro h x hx
    by_cases hxa : x = a
    · simp [hxa, h]
    · have hx' : x ∈ H.erase a := Finset.mem_erase.mpr ⟨hxa, hx⟩
      have hz := (anulador_dvd_iff (H.erase a) (anulador (H.erase a))).mp dvd_rfl x hx'
      rw [hz, mul_zero]

/-- Los dos factores excluyen exactamente las dos últimas filas de la transición. -/
theorem transicion_dvd_iff (H : Finset K) (g : K) (f : Polynomial K) (h₁ h₂ : K) :
    anulador H ∣ numeradorTransicion g f h₁ h₂ ↔
      ∀ x ∈ H, x ≠ h₁ → x ≠ h₂ → (transicion g f).eval x = 0 := by
  rw [anulador_dvd_iff]
  simp only [numeradorTransicion, Polynomial.eval_mul, Polynomial.eval_sub,
    Polynomial.eval_X, Polynomial.eval_C]
  constructor
  · intro h x hx h₁x h₂x
    exact (mul_eq_zero.mp ((mul_eq_zero.mp (h x hx)).resolve_right
      (sub_ne_zero.mpr h₂x))).resolve_right (sub_ne_zero.mpr h₁x)
  · intro h x hx
    by_cases h₁x : x = h₁
    · simp [h₁x]
    by_cases h₂x : x = h₂
    · simp [h₂x]
    rw [h x hx h₁x h₂x, zero_mul, zero_mul]

/-- Una raíz primitiva produce T filas distintas. -/
theorem cardinal_dominio (T : ℕ) (g : K) (hg : IsPrimitiveRoot g T) :
    (dominio g T).card = T := by
  classical
  unfold dominio
  rw [Finset.card_image_of_injOn (fun i hi j hj hij =>
    hg.pow_inj (Finset.mem_range.mp hi) (Finset.mem_range.mp hj) hij)]
  exact Finset.card_range T

/-- El anulador de las filas es exactamente X^T-1, sin postular la factorización. -/
theorem anulador_dominio (T : ℕ) (g : K) (hT : 0 < T) (hg : IsPrimitiveRoot g T) :
    anulador (dominio g T) = denominador (K := K) T := by
  classical
  have hdvd : anulador (dominio g T) ∣ denominador (K := K) T := by
    apply (anulador_dvd_iff _ _).mpr
    intro x hx
    obtain ⟨i, hi, rfl⟩ := Finset.mem_image.mp hx
    have hp : (g ^ i) ^ T = 1 := by
      calc
        (g ^ i) ^ T = (g ^ T) ^ i := by rw [← pow_mul, ← pow_mul, Nat.mul_comm]
        _ = 1 := by rw [hg.pow_eq_one, one_pow]
    simpa [denominador] using sub_eq_zero.mpr hp
  have hm : (anulador (dominio g T)).Monic := Polynomial.monic_prod_X_sub_C id _
  have hD : (denominador (K := K) T).Monic := by
    simpa [denominador] using (Polynomial.monic_X_pow_sub_C (1 : K) hT.ne')
  have hdeg : (denominador (K := K) T).natDegree ≤ (anulador (dominio g T)).natDegree := by
    simp only [denominador, ← Polynomial.C_1, Polynomial.natDegree_X_pow_sub_C,
      anulador, Polynomial.natDegree_finsetProd_X_sub_C_eq_card, cardinal_dominio T g hg,
      le_refl]
  exact (Polynomial.eq_of_monic_of_dvd_of_natDegree_le hm hD hdvd hdeg).symm

/-- Las filas distintas de las dos últimas son exactamente los índices i<T-2. -/
theorem transiciones_por_indices (T : ℕ) (g : K) (f : Polynomial K)
    (hT : 3 ≤ T) (hg : IsPrimitiveRoot g T) :
    (∀ x ∈ dominio g T, x ≠ g ^ (T - 1) → x ≠ g ^ (T - 2) →
      (transicion g f).eval x = 0) ↔
    (∀ i : ℕ, i < T - 2 → (transicion g f).eval (g ^ i) = 0) := by
  classical
  constructor
  · intro h i hi
    apply h (g ^ i) (Finset.mem_image.mpr ⟨i, Finset.mem_range.mpr (by omega), rfl⟩)
    · intro heq
      have := hg.pow_inj (by omega : i < T) (by omega : T - 1 < T) heq
      omega
    · intro heq
      have := hg.pow_inj (by omega : i < T) (by omega : T - 2 < T) heq
      omega
  · intro h x hx hx₁ hx₂
    obtain ⟨i, hi, rfl⟩ := Finset.mem_image.mp hx
    have hiT := Finset.mem_range.mp hi
    have hi₁ : i ≠ T - 1 := fun heq => hx₁ (congrArg (fun j => g ^ j) heq)
    have hi₂ : i ≠ T - 2 := fun heq => hx₂ (congrArg (fun j => g ^ j) heq)
    exact h i (by omega)

/-- S1.1 del manuscrito: las restricciones AIR equivalen a los tres residuos nulos. -/
theorem validez_iff_residuos : Enunciado K := by
  classical
  intro T g f s o hT hg
  have hD := anulador_dominio T g (by omega) hg
  have hinit : (1 : K) ∈ dominio g T := by
    exact Finset.mem_image.mpr ⟨0, Finset.mem_range.mpr (by omega), pow_zero g⟩
  have hfinal : g ^ (T - 1) ∈ dominio g T :=
    Finset.mem_image.mpr ⟨T - 1, Finset.mem_range.mpr (by omega), rfl⟩
  unfold Valida ResiduosNulos
  simp only [EuclideanDomain.mod_eq_zero, ← hD]
  rw [frontera_dvd_iff _ f s 1 hinit,
    frontera_dvd_iff _ f o (g ^ (T - 1)) hfinal,
    transicion_dvd_iff, transiciones_por_indices T g f hT hg]

/-- Linealidad del resto: R_alpha es la combinación de los residuos individuales. -/
theorem resto_combinacion (D N₀ N₁ N₂ : Polynomial K) (a : Nexus.N01.Coeficientes K) :
    Nexus.N01.combinacion N₀ N₁ N₂ a % D =
      Nexus.N01.combinacion (N₀ % D) (N₁ % D) (N₂ % D) a := by
  simp only [Nexus.N01.combinacion, Polynomial.mod_def, Polynomial.add_modByMonic,
    Polynomial.smul_modByMonic]

/-- Traza AIR inválida implica un residuo individual no nulo. -/
theorem invalida_residuo_no_nulo (T : ℕ) (g : K) (f : Polynomial K) (s o : K)
    (hT : 3 ≤ T) (hg : IsPrimitiveRoot g T) (hinvalida : ¬ Valida g T f s o) :
    frontera (denominador T) f s 1 % denominador T ≠ 0 ∨
    frontera (denominador T) f o (g ^ (T - 1)) % denominador T ≠ 0 ∨
    numeradorTransicion g f (g ^ (T - 1)) (g ^ (T - 2)) % denominador T ≠ 0 := by
  by_contra! hn
  exact hinvalida ((validez_iff_residuos T g f s o hT hg).mpr hn)

/-- Puente completo de S1.1 a la cota uniforme de cancelación, para la traza fija. -/
theorem cancelacion_traza_invalida [Fintype K] (T : ℕ) (g : K) (f : Polynomial K) (s o : K)
    (hT : 3 ≤ T) (hg : IsPrimitiveRoot g T) (hinvalida : ¬ Valida g T f s o) :
    Nexus.N01.probabilidad
      (frontera (denominador T) f s 1 % denominador T)
      (frontera (denominador T) f o (g ^ (T - 1)) % denominador T)
      (numeradorTransicion g f (g ^ (T - 1)) (g ^ (T - 2)) % denominador T) ≤
        1 / (Fintype.card K : ℚ) := by
  exact Nexus.N01.cota _ _ _ (invalida_residuo_no_nulo T g f s o hT hg hinvalida)

end Nexus.AIR
