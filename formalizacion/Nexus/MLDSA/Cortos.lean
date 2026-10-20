module

public import Nexus.MLDSA.Representantes
import Mathlib.Tactic

public section
namespace Nexus.MLDSA

open scoped BigOperators

theorem cota_entera_iff (z : ℤ) (B : ℕ) :
    z.natAbs ≤ B ↔ -(B : ℤ) ≤ z ∧ z ≤ B := by
  have hc : z.natAbs ≤ B ↔ |z| ≤ (B : ℤ) := by
    rw [← Nat.cast_le (α := ℤ), Int.natCast_natAbs]
  exact hc.trans abs_le

/-- Intervalo entero finito utilizado en S_eta, con ambos extremos incluidos. -/
abbrev CoefCorto (B : ℕ) := ↥(Finset.Icc (-(B : ℤ)) (B : ℤ))

instance (B : ℕ) : Nonempty (CoefCorto B) :=
  ⟨⟨0, Finset.mem_Icc.mpr ⟨by omega, by omega⟩⟩⟩

theorem cardinal_coef_corto (B : ℕ) : Fintype.card (CoefCorto B) = 2 * B + 1 := by
  rw [Fintype.card_coe, Int.card_Icc]
  omega

/-- El conjunto definido en el manuscrito como polinomios enteros pequeños. -/
abbrev Pequeno (B : ℕ) := {w : R // w ∈ pequenos B}

@[expose] noncomputable def pequenoDeCoef (B : ℕ) (v : Fin n → CoefCorto B) : Pequeno B := by
  refine ⟨claseCoeficientes (fun i => (v i).val), (pequenos_iff _ B).mpr ?_⟩
  intro i
  rw [coeficiente_claseCoeficientes, cota_entera_iff]
  exact Finset.mem_Icc.mp (v i).property

@[expose] noncomputable def coefDePequeno (B : ℕ) (w : Pequeno B) (i : Fin n) : CoefCorto B :=
  ⟨coeficiente w.val i, Finset.mem_Icc.mpr
    ((cota_entera_iff _ B).mp ((pequenos_iff w.val B).mp w.property i))⟩

theorem pequeno_coef_ida (B : ℕ) (v : Fin n → CoefCorto B) :
    coefDePequeno B (pequenoDeCoef B v) = v := by
  funext i
  apply Subtype.ext
  exact coeficiente_claseCoeficientes _ i

theorem pequeno_coef_vuelta (B : ℕ) (w : Pequeno B) :
    pequenoDeCoef B (coefDePequeno B w) = w := by
  apply Subtype.ext
  exact claseCoeficientes_coeficiente w.val

@[expose] noncomputable def equivalenciaPequenos (B : ℕ) :
    Pequeno B ≃ (Fin n → CoefCorto B) where
  toFun := coefDePequeno B
  invFun := pequenoDeCoef B
  left_inv := pequeno_coef_vuelta B
  right_inv := pequeno_coef_ida B

noncomputable instance (B : ℕ) : Fintype (Pequeno B) :=
  Fintype.ofEquiv (Fin n → CoefCorto B) (equivalenciaPequenos B).symm

instance (B : ℕ) : Nonempty (Pequeno B) :=
  ⟨pequenoDeCoef B (fun _ => Classical.choice inferInstance)⟩

theorem cardinal_pequenos (B : ℕ) : Fintype.card (Pequeno B) = (2 * B + 1) ^ n := by
  rw [Fintype.card_congr (equivalenciaPequenos B), Fintype.card_fun,
    Fintype.card_fin, cardinal_coef_corto]

theorem coeficiente_pequeno (B : ℕ) (w : Pequeno B) (i : Fin n) :
    (coeficiente w.val i).natAbs ≤ B := (pequenos_iff w.val B).mp w.property i

theorem centrado_pequeno (B : ℕ) (hB : B ≤ 4190208) (w : Pequeno B) (i : Fin n) :
    centrado (reduccion w.val) i = coeficiente w.val i := by
  apply centrado_unico
  · exact (coeficiente_reduccion w.val i).symm
  · have hb := (cota_entera_iff _ B).mp (coeficiente_pequeno B w i)
    norm_num [q]
    omega
  · have hb := (cota_entera_iff _ B).mp (coeficiente_pequeno B w i)
    norm_num [q]
    omega

theorem reduccion_pequenos_inyectiva (B : ℕ) (hB : B ≤ 4190208) :
    Function.Injective (fun w : Pequeno B => reduccion w.val) := by
  intro u v huv
  apply Subtype.ext
  apply coeficiente_determina
  intro i
  have h := congrArg (fun w => centrado w i) huv
  simpa only [centrado_pequeno B hB] using h

theorem norma_reduccion_pequeno (B : ℕ) (hB : B ≤ 4190208) (w : Pequeno B) :
    normaRq (reduccion w.val) = normaR w.val := by
  unfold normaRq normaR
  congr 1
  funext i
  exact centrado_pequeno B hB w i

theorem eta_perfil_pequeno (p : Perfil) : eta p ≤ 4190208 := by
  cases p <;> norm_num [eta]

theorem pequeno_cero (w : Pequeno 0) : w.val = 0 := by
  apply coeficiente_determina
  intro i
  have hz : coeficiente w.val i = 0 := Int.natAbs_eq_zero.mp
    (Nat.eq_zero_of_le_zero (coeficiente_pequeno 0 w i))
  rw [hz]
  simp [coeficiente, representante]

end Nexus.MLDSA
