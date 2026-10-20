module

public import Nexus.MLDSA.MSIS
import Mathlib.Tactic

public section
namespace Nexus.MLDSA

open Nexus.Cripto
open scoped ENNReal Matrix

abbrev VectorPequeno (r B : ℕ) := Fin r → Pequeno B
abbrev PublicoMLWE (k r : ℕ) := Matriz k r × Vector k
abbrev MonedasMLWE (k r B : ℕ) := Matriz k r × (VectorPequeno r B × VectorPequeno k B)

@[expose] noncomputable def reducePequeno {r B : ℕ} (s : VectorPequeno r B) : Vector r :=
  fun j => reduccion (s j).val

theorem reduccion_secreto_inyectiva (r B : ℕ) (hB : B ≤ 4190208) :
    Function.Injective (reducePequeno (r := r) (B := B)) := by
  intro s t h
  funext j
  exact reduccion_pequenos_inyectiva B hB (congrFun h j)

theorem norma_secreto_reducido (r B : ℕ) (hB : B ≤ 4190208) (s : VectorPequeno r B) :
    normaVector (reducePequeno s) ≤ B := by
  apply (norma_vector_iff _ _).mpr
  intro j i
  rw [show reducePequeno s j = reduccion (s j).val from rfl, centrado_pequeno B hB]
  exact coeficiente_pequeno B (s j) i

/-- La matriz, el secreto y el error se sortean independientemente. -/
@[expose] noncomputable def monedasMLWE (k r B : ℕ) : PMF (MonedasMLWE k r B) :=
  producto (uniforme (Matriz k r))
    (producto (uniforme (VectorPequeno r B)) (uniforme (VectorPequeno k B)))

theorem soporte_monedas_mlwe (k r B : ℕ) (x : MonedasMLWE k r B) :
    x ∈ (monedasMLWE k r B).support := by
  apply (soporte_producto _ _ x).mpr
  refine ⟨soporte_uniforme x.1, ?_⟩
  exact (soporte_producto _ _ x.2).mpr ⟨soporte_uniforme x.2.1, soporte_uniforme x.2.2⟩

theorem masa_monedas_mlwe (k r B : ℕ) (x : MonedasMLWE k r B) :
    monedasMLWE k r B x = (Fintype.card (Matriz k r) : ℝ≥0∞)⁻¹ *
      ((Fintype.card (VectorPequeno r B) : ℝ≥0∞)⁻¹ *
        (Fintype.card (VectorPequeno k B) : ℝ≥0∞)⁻¹) := by
  rw [monedasMLWE, masa_producto, masa_producto, masa_uniforme, masa_uniforme, masa_uniforme]

theorem cardinal_secreto (r B : ℕ) : Fintype.card (VectorPequeno r B) = (2 * B + 1) ^ (n * r) := by
  rw [Fintype.card_fun, Fintype.card_fin, cardinal_pequenos, ← pow_mul]

@[expose] noncomputable def observacionMLWE {k r B : ℕ} (x : MonedasMLWE k r B) : PublicoMLWE k r :=
  (x.1, x.1 *ᵥ reducePequeno x.2.1 + reducePequeno x.2.2)

@[expose] noncomputable def leyMLWE (k r B : ℕ) : PMF (PublicoMLWE k r) :=
  (monedasMLWE k r B).map observacionMLWE

@[expose] noncomputable def leyIdealMLWE (k r : ℕ) : PMF (PublicoMLWE k r) :=
  producto (uniforme (Matriz k r)) (uniforme (Vector k))

theorem soporte_mlwe (k r B : ℕ) (A : Matriz k r) (t : Vector k) :
    (A, t) ∈ (leyMLWE k r B).support ↔
      ∃ s : VectorPequeno r B, ∃ e : VectorPequeno k B,
        t = A *ᵥ reducePequeno s + reducePequeno e := by
  rw [leyMLWE, PMF.mem_support_map_iff]
  constructor
  · rintro ⟨⟨A', s, e⟩, _, he⟩
    have hA := congrArg Prod.fst he
    change A' = A at hA
    subst A'
    exact ⟨s, e, (congrArg Prod.snd he).symm⟩
  · rintro ⟨s, e, rfl⟩
    exact ⟨(A, s, e), soporte_monedas_mlwe k r B _, rfl⟩

theorem matriz_mlwe_uniforme (k r B : ℕ) :
    (leyMLWE k r B).map Prod.fst = uniforme (Matriz k r) := by
  rw [leyMLWE, PMF.map_comp]
  change (monedasMLWE k r B).map Prod.fst = _
  exact primera_marginal _ _

theorem matriz_ideal_uniforme (k r : ℕ) :
    (leyIdealMLWE k r).map Prod.fst = uniforme (Matriz k r) := primera_marginal _ _

/-- Ventaja decisional de un distinguidor probabilístico que solo recibe el par público. -/
@[expose] noncomputable def ventajaMLWE (k r B : ℕ) (D : PublicoMLWE k r → PMF Bool) : ℝ :=
  |(probabilidad ((leyMLWE k r B).bind D) (fun b => b = true)).toReal -
    (probabilidad ((leyIdealMLWE k r).bind D) (fun b => b = true)).toReal|

theorem ventaja_mlwe_cotas (k r B : ℕ) (D : PublicoMLWE k r → PMF Bool) :
    0 ≤ ventajaMLWE k r B D ∧ ventajaMLWE k r B D ≤ 1 := by
  have hr := probabilidad_real_cotas ((leyMLWE k r B).bind D) (fun b => b = true)
  have hi := probabilidad_real_cotas ((leyIdealMLWE k r).bind D) (fun b => b = true)
  refine ⟨abs_nonneg _, ?_⟩
  apply abs_le.mpr
  constructor <;> linarith

theorem ventaja_mlwe_constante (k r B : ℕ) (p : PMF Bool) :
    ventajaMLWE k r B (fun _ => p) = 0 := by
  simp only [ventajaMLWE, PMF.bind_const, sub_self, abs_zero]

theorem ventaja_mlwe_leyes_iguales (k r B : ℕ)
    (h : leyMLWE k r B = leyIdealMLWE k r) (D : PublicoMLWE k r → PMF Bool) :
    ventajaMLWE k r B D = 0 := by
  rw [ventajaMLWE, h, sub_self, abs_zero]

@[expose] noncomputable def ensayoBusquedaMLWE (k r B : ℕ)
    (buscador : PublicoMLWE k r → PMF (VectorPequeno r B)) :
    PMF (VectorPequeno r B × VectorPequeno r B) :=
  (monedasMLWE k r B).bind
    (fun x => (buscador (observacionMLWE x)).map (fun s => (s, x.2.1)))

@[expose] noncomputable def ventajaBusquedaMLWE (k r B : ℕ)
    (buscador : PublicoMLWE k r → PMF (VectorPequeno r B)) : ℝ≥0∞ :=
  probabilidad (ensayoBusquedaMLWE k r B buscador) (fun ss => ss.1 = ss.2)

theorem ventaja_busqueda_le_uno (k r B : ℕ)
    (buscador : PublicoMLWE k r → PMF (VectorPequeno r B)) :
    ventajaBusquedaMLWE k r B buscador ≤ 1 := probabilidad_le_uno _ _

theorem reduce_secreto_cero (r : ℕ) (s : VectorPequeno r 0) : reducePequeno s = 0 := by
  funext j
  change reduccion (s j).val = 0
  rw [pequeno_cero, map_zero]

theorem observacion_sin_ruido (k r : ℕ) (x : MonedasMLWE k r 0) :
    (observacionMLWE x).2 = 0 := by
  change x.1 *ᵥ reducePequeno x.2.1 + reducePequeno x.2.2 = 0
  rw [reduce_secreto_cero, reduce_secreto_cero, Matrix.mulVec_zero, add_zero]

theorem distingue_sin_ruido (k r : ℕ) :
    probabilidad (leyMLWE k r 0) (fun x => x.2 = 0) = 1 := by
  rw [leyMLWE, probabilidad_map]
  apply probabilidad_uno_por_soporte
  intro x _
  exact observacion_sin_ruido k r x

theorem probabilidad_ideal_cero (k r : ℕ) :
    probabilidad (leyIdealMLWE k r) (fun x => x.2 = 0) = (q ^ (n * k) : ℝ≥0∞)⁻¹ := by
  have h := probabilidad_map (leyIdealMLWE k r) Prod.snd (fun x => x = 0)
  rw [leyIdealMLWE, segunda_marginal] at h
  rw [leyIdealMLWE, ← h]
  change (uniforme (Vector k)).toOuterMeasure {0} = _
  rw [PMF.toOuterMeasure_apply_singleton, masa_uniforme, cardinal_vector, Nat.cast_pow]

/-- Contraste de las leyes: el caso sin ruido no puede declararse difícil por definición. -/
theorem ventaja_sin_ruido (k r : ℕ) :
    let D : PublicoMLWE k r → PMF Bool := fun x => by
      classical
      exact PMF.pure (decide (x.2 = 0))
    ventajaMLWE k r 0 D = 1 - ((q ^ (n * k) : ℝ≥0∞)⁻¹).toReal := by
  classical
  dsimp only
  rw [ventajaMLWE, probabilidad_predicado, probabilidad_predicado,
    distingue_sin_ruido, probabilidad_ideal_cero, ENNReal.toReal_one]
  apply abs_of_nonneg
  have h := (probabilidad_real_cotas (leyIdealMLWE k r) (fun x => x.2 = 0)).2
  rw [probabilidad_ideal_cero] at h
  linarith

end Nexus.MLDSA
