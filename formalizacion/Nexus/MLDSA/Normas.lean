module

public import Nexus.MLDSA.Anillos
public import Mathlib.Data.ZMod.ValMinAbs
public import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Tactic

public section
namespace Nexus.MLDSA

open scoped BigOperators

/-- Representante centrado en (-q/2,q/2], sin aritmética de punto flotante. -/
@[expose] noncomputable def centrado (w : Rq) (i : Fin n) : ℤ :=
  (coeficiente w i).valMinAbs

theorem centrado_reduce (w : Rq) (i : Fin n) :
    (centrado w i : Fq) = coeficiente w i := ZMod.coe_valMinAbs _

theorem centrado_intervalo (w : Rq) (i : Fin n) :
    -(q : ℤ) < 2 * centrado w i ∧ 2 * centrado w i ≤ q := by
  have h := ZMod.valMinAbs_mem_Ioc (coeficiente w i)
  simpa [centrado, mul_comm] using h

theorem centrado_cota (w : Rq) (i : Fin n) : (centrado w i).natAbs ≤ 4190208 := by
  exact (ZMod.natAbs_valMinAbs_le (n := q) (coeficiente w i)).trans (by decide)

theorem centrado_unico (w : Rq) (i : Fin n) (z : ℤ)
    (hz : (z : Fq) = coeficiente w i) (hlo : -(q : ℤ) < 2 * z)
    (hhi : 2 * z ≤ q) : centrado w i = z := by
  apply (ZMod.valMinAbs_spec _ z).mpr
  exact ⟨hz.symm, by simpa [mul_comm] using And.intro hlo hhi⟩

theorem centrado_determina (u v : Rq) (h : ∀ i, centrado u i = centrado v i) : u = v := by
  apply coeficiente_determina
  intro i
  rw [← centrado_reduce u i, ← centrado_reduce v i, h i]

/-- Las mismas fórmulas sirven para polinomios y vectores aplanados. -/
@[expose] def normaInfinito {ι : Type*} [Fintype ι] (v : ι → ℤ) : ℕ :=
  Finset.univ.sup (fun i => (v i).natAbs)

@[expose] noncomputable def normaDos {ι : Type*} [Fintype ι] (v : ι → ℤ) : ℝ :=
  Real.sqrt (∑ i, (v i : ℝ) ^ 2)

@[expose] noncomputable def normaRq (w : Rq) : ℕ := normaInfinito (centrado w)
@[expose] noncomputable def normaR (w : R) : ℕ := normaInfinito (coeficiente w)
@[expose] noncomputable def normaDosRq (w : Rq) : ℝ := normaDos (centrado w)
@[expose] noncomputable def normaDosR (w : R) : ℝ := normaDos (coeficiente w)
@[expose] noncomputable def normaVector {r : ℕ} (w : Vector r) : ℕ :=
  normaInfinito (fun i : Fin r × Fin n => centrado (w i.1) i.2)
@[expose] noncomputable def normaDosVector {r : ℕ} (w : Vector r) : ℝ :=
  normaDos (fun i : Fin r × Fin n => centrado (w i.1) i.2)
@[expose] noncomputable def pequenos (eta : ℕ) : Set R := {w | normaR w ≤ eta}

theorem coeficiente_le_norma {ι : Type*} [Fintype ι] (v : ι → ℤ) (i : ι) :
    (v i).natAbs ≤ normaInfinito v := by
  unfold normaInfinito
  exact Finset.le_sup (f := fun j => (v j).natAbs) (Finset.mem_univ i)

theorem norma_le_iff {ι : Type*} [Fintype ι] (v : ι → ℤ) (B : ℕ) :
    normaInfinito v ≤ B ↔ ∀ i, (v i).natAbs ≤ B := by
  simp [normaInfinito, Finset.sup_le_iff]

theorem norma_cero_iff {ι : Type*} [Fintype ι] (v : ι → ℤ) :
    normaInfinito v = 0 ↔ ∀ i, v i = 0 := by
  simpa only [Nat.le_zero, Int.natAbs_eq_zero] using norma_le_iff v 0

theorem normaRq_cero_iff (w : Rq) : normaRq w = 0 ↔ w = 0 := by
  constructor
  · intro hw
    apply centrado_determina
    intro i
    have h := (norma_cero_iff (centrado w)).mp hw i
    simpa [centrado, coeficiente_cero] using h
  · rintro rfl
    apply (norma_cero_iff _).mpr
    intro i
    simp [centrado, coeficiente_cero]

theorem normaRq_acotada (w : Rq) : normaRq w ≤ 4190208 :=
  (norma_le_iff _ _).mpr (centrado_cota w)

theorem norma_vector_iff {r : ℕ} (w : Vector r) (B : ℕ) :
    normaVector w ≤ B ↔ ∀ j i, (centrado (w j) i).natAbs ≤ B := by
  simp [normaVector, norma_le_iff, Prod.forall]

theorem pequenos_iff (w : R) (B : ℕ) :
    w ∈ pequenos B ↔ ∀ i, (coeficiente w i).natAbs ≤ B := norma_le_iff _ _

theorem norma_dos_no_negativa {ι : Type*} [Fintype ι] (v : ι → ℤ) : 0 ≤ normaDos v :=
  Real.sqrt_nonneg _

theorem cuadrado_norma_dos {ι : Type*} [Fintype ι] (v : ι → ℤ) :
    normaDos v ^ 2 = ∑ i, (v i : ℝ) ^ 2 := by
  exact Real.sq_sqrt (Finset.sum_nonneg (fun i _ => sq_nonneg (v i : ℝ)))

theorem cota_norma_dos {ι : Type*} [Fintype ι] (v : ι → ℤ) :
    normaDos v ^ 2 ≤ Fintype.card ι * (normaInfinito v : ℝ) ^ 2 := by
  rw [cuadrado_norma_dos]
  calc
    _ ≤ ∑ _ : ι, (normaInfinito v : ℝ) ^ 2 := by
      apply Finset.sum_le_sum
      intro i _
      have h : |(v i : ℝ)| ≤ (normaInfinito v : ℝ) := by
        have hn : ((v i).natAbs : ℝ) ≤ (normaInfinito v : ℝ) := by
          exact_mod_cast coeficiente_le_norma v i
        simpa only [Nat.cast_natAbs, Int.cast_abs] using hn
      nlinarith [abs_nonneg (v i : ℝ), sq_abs (v i : ℝ)]
    _ = _ := by simp

end Nexus.MLDSA
