module

public import Mathlib.Algebra.Module.ZLattice.Basic
public import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Tactic

public section
namespace Nexus.Reticulos

open scoped BigOperators
open Module Submodule

/-- El rango m y la dimensión ambiente d son datos distintos. -/
structure BaseReticular (m d : ℕ) where
  vectores : Fin m → EuclideanSpace ℝ (Fin d)
  independiente : LinearIndependent ℝ vectores

variable {m d : ℕ}
abbrev Ambiente (d : ℕ) := EuclideanSpace ℝ (Fin d)

@[expose] noncomputable def generado (B : BaseReticular m d) : Submodule ℤ (Ambiente d) :=
  span ℤ (Set.range B.vectores)

@[expose] noncomputable def espacio (B : BaseReticular m d) : Submodule ℝ (Ambiente d) :=
  span ℝ (Set.range B.vectores)

@[expose] noncomputable def baseEspacio (B : BaseReticular m d) : Basis (Fin m) ℝ (espacio B) :=
  Basis.span B.independiente

theorem rango_le_dimension (B : BaseReticular m d) : m ≤ d := by
  simpa using B.independiente.fintype_card_le_finrank

theorem dimension_intrinseca (B : BaseReticular m d) : Module.finrank ℝ (espacio B) = m := by
  unfold espacio
  rw [finrank_span_eq_card B.independiente, Fintype.card_fin]

theorem generador_pertenece (B : BaseReticular m d) (j : Fin m) : B.vectores j ∈ generado B :=
  subset_span ⟨j, rfl⟩

theorem generador_no_nulo (B : BaseReticular m d) (j : Fin m) : B.vectores j ≠ 0 :=
  B.independiente.ne_zero j

theorem combinacion_pertenece (B : BaseReticular m d) (z : Fin m → ℤ) :
    ∑ j, z j • B.vectores j ∈ generado B :=
  sum_mem (fun j _ => smul_mem _ _ (generador_pertenece B j))

theorem combinacion_inyectiva (B : BaseReticular m d) :
    Function.Injective (fun z : Fin m → ℤ => ∑ j, z j • B.vectores j) := by
  intro z w h
  have hreal : (∑ j, (z j : ℝ) • B.vectores j) = ∑ j, (w j : ℝ) • B.vectores j := by
    simpa only [Int.cast_smul_eq_zsmul] using h
  have hz := B.independiente.fintypeLinearCombination_injective hreal
  funext j
  exact_mod_cast congrFun hz j

theorem base_espacio_coincide (B : BaseReticular m d) (j : Fin m) :
    (baseEspacio B j : Ambiente d) = B.vectores j := by
  change ((Basis.span B.independiente j : span ℝ (Set.range B.vectores)) : Ambiente d) = _
  exact congrArg Subtype.val (Basis.span_apply B.independiente j)

theorem imagen_reticulo_interno (B : BaseReticular m d) :
    (span ℤ (Set.range (baseEspacio B))).map ((espacio B).subtype.restrictScalars ℤ) = generado B := by
  rw [Submodule.map_span]
  congr 1
  ext x
  simp only [Set.mem_image, Set.mem_range, LinearMap.restrictScalars_apply,
    Submodule.subtype_apply]
  constructor
  · rintro ⟨y, ⟨j, rfl⟩, rfl⟩
    exact ⟨j, (base_espacio_coincide B j).symm⟩
  · rintro ⟨j, rfl⟩
    exact ⟨baseEspacio B j, ⟨j, rfl⟩, base_espacio_coincide B j⟩

theorem combinaciones_exactas (B : BaseReticular m d) (x : Ambiente d) :
    x ∈ generado B ↔ ∃ z : Fin m → ℤ, ∑ j, z j • B.vectores j = x := by
  exact Submodule.mem_span_range_iff_exists_fun ℤ

theorem bola_finita (B : BaseReticular m d) (R : ℝ) :
    Set.Finite {x : Ambiente d | x ∈ generado B ∧ ‖x‖ ≤ R} := by
  have hs := ZSpan.setFinite_inter (baseEspacio B) (Metric.isBounded_closedBall (x := (0 : espacio B)) (r := R))
  have hi := hs.image (fun v : espacio B => (v : Ambiente d))
  apply hi.subset
  intro x hx
  have hx' := hx.1
  rw [← imagen_reticulo_interno B] at hx'
  obtain ⟨y, hy, rfl⟩ := hx'
  refine ⟨y, ⟨?_, hy⟩, rfl⟩
  rw [Metric.mem_closedBall, dist_zero_right]
  change ‖((espacio B).subtype.restrictScalars ℤ) y‖ ≤ R
  exact hx.2

/-- Radios que contienen i vectores independientes; se usa 0≤i≤m. -/
@[expose] def Radios (B : BaseReticular m d) (i : ℕ) : Set ℝ :=
  {R | 0 ≤ R ∧ ∃ v : Fin i → Ambiente d, LinearIndependent ℝ v ∧
    ∀ j, v j ∈ generado B ∧ ‖v j‖ ≤ R}

@[expose] noncomputable def minimoSucesivo (B : BaseReticular m d) (i : Fin (m + 1)) : ℝ :=
  sInf (Radios B i)

theorem radios_acotados_inferiormente (B : BaseReticular m d) (i : ℕ) : BddBelow (Radios B i) :=
  ⟨0, fun _ hx => hx.1⟩

theorem radios_no_vacios (B : BaseReticular m d) (i : ℕ) (hi : i ≤ m) : (Radios B i).Nonempty := by
  refine ⟨∑ j, ‖B.vectores j‖, Finset.sum_nonneg (fun _ _ => norm_nonneg _),
    fun j => B.vectores (Fin.castLE hi j), B.independiente.comp _ (Fin.castLE_injective hi), ?_⟩
  intro j
  exact ⟨generador_pertenece B _, Finset.single_le_sum (fun _ _ => norm_nonneg _) (Finset.mem_univ _)⟩

theorem minimo_no_negativo (B : BaseReticular m d) (i : Fin (m + 1)) : 0 ≤ minimoSucesivo B i :=
  le_csInf (radios_no_vacios B i (by omega)) (fun _ h => h.1)

theorem minimo_le_radio (B : BaseReticular m d) (i : Fin (m + 1)) (R : ℝ) (hR : R ∈ Radios B i) :
    minimoSucesivo B i ≤ R := csInf_le (radios_acotados_inferiormente B i) hR

theorem radios_monotonos (B : BaseReticular m d) (i j : ℕ) (hij : i ≤ j) :
    Radios B j ⊆ Radios B i := by
  rintro R ⟨hR, v, hv, hbound⟩
  exact ⟨hR, v ∘ Fin.castLE hij, hv.comp _ (Fin.castLE_injective hij), fun a => hbound _⟩

theorem minimos_monotonos (B : BaseReticular m d) (i j : Fin (m + 1)) (hij : i ≤ j) :
    minimoSucesivo B i ≤ minimoSucesivo B j := by
  apply le_csInf (radios_no_vacios B j (by omega))
  intro R hR
  exact minimo_le_radio B i R (radios_monotonos B i j hij hR)

theorem existe_vector_mas_corto (B : BaseReticular m d) (hm : 0 < m) :
    ∃ v ∈ generado B, v ≠ 0 ∧ ∀ w ∈ generado B, w ≠ 0 → ‖v‖ ≤ ‖w‖ := by
  let v₀ := B.vectores ⟨0, hm⟩
  let s := {x : Ambiente d | x ∈ generado B ∧ x ≠ 0 ∧ ‖x‖ ≤ ‖v₀‖}
  have hs : s.Finite := (bola_finita B ‖v₀‖).subset (fun _ hx => ⟨hx.1, hx.2.2⟩)
  have hn : s.Nonempty := ⟨v₀, generador_pertenece B _, generador_no_nulo B _, le_rfl⟩
  obtain ⟨v, hv, hmin⟩ := Set.exists_min_image s (fun x => ‖x‖) hs hn
  refine ⟨v, hv.1, hv.2.1, ?_⟩
  intro w hw hw0
  by_cases h : ‖w‖ ≤ ‖v₀‖
  · exact hmin w ⟨hw, hw0, h⟩
  · exact hv.2.2.trans (le_of_not_ge h)

theorem radio_uno_iff (B : BaseReticular m d) (R : ℝ) :
    R ∈ Radios B 1 ↔ 0 ≤ R ∧ ∃ v ∈ generado B, v ≠ 0 ∧ ‖v‖ ≤ R := by
  constructor
  · rintro ⟨hR, v, hv, hb⟩
    exact ⟨hR, v 0, (hb 0).1, hv.ne_zero 0, (hb 0).2⟩
  · rintro ⟨hR, v, hv, h0, hn⟩
    exact ⟨hR, fun _ => v, LinearIndependent.of_subsingleton 0 h0, fun _ => ⟨hv, hn⟩⟩

theorem primer_minimo_alcanzado (B : BaseReticular m d) (hm : 0 < m) :
    ∃ v ∈ generado B, v ≠ 0 ∧ minimoSucesivo B ⟨1, by omega⟩ = ‖v‖ := by
  obtain ⟨v, hv, h0, hmin⟩ := existe_vector_mas_corto B hm
  refine ⟨v, hv, h0, le_antisymm ?_ ?_⟩
  · apply minimo_le_radio
    exact (radio_uno_iff B ‖v‖).mpr ⟨norm_nonneg v, v, hv, h0, le_rfl⟩
  · apply le_csInf (radios_no_vacios B 1 hm)
    intro R hR
    obtain ⟨_, w, hw, hw0, hn⟩ := (radio_uno_iff B R).mp hR
    exact (hmin w hw hw0).trans hn

theorem primer_minimo_positivo (B : BaseReticular m d) (hm : 0 < m) :
    0 < minimoSucesivo B ⟨1, by omega⟩ := by
  obtain ⟨v, _, h0, he⟩ := primer_minimo_alcanzado B hm
  rw [he]
  exact norm_pos_iff.mpr h0

/-- SVP, SIVP y GapSVP son relaciones distintas, sin una hipótesis de dureza implícita. -/
@[expose] def SolucionSVP (B : BaseReticular m d) (hm : 0 < m) (gamma : ℝ) (v : Ambiente d) : Prop :=
  v ∈ generado B ∧ v ≠ 0 ∧ ‖v‖ ≤ gamma * minimoSucesivo B ⟨1, by omega⟩

@[expose] def SolucionSIVP (B : BaseReticular m d) (gamma : ℝ) (v : Fin m → Ambiente d) : Prop :=
  LinearIndependent ℝ v ∧ ∀ j, v j ∈ generado B ∧
    ‖v j‖ ≤ gamma * minimoSucesivo B ⟨m, by omega⟩

@[expose] def GapSi (B : BaseReticular m d) (hm : 0 < m) (R : ℝ) : Prop :=
  minimoSucesivo B ⟨1, by omega⟩ ≤ R

@[expose] def GapNo (B : BaseReticular m d) (hm : 0 < m) (gamma R : ℝ) : Prop :=
  gamma * R < minimoSucesivo B ⟨1, by omega⟩

theorem promesa_gap_disjunta (B : BaseReticular m d) (hm : 0 < m) (gamma R : ℝ)
    (hg : 1 ≤ gamma) (hR : 0 ≤ R) : ¬ (GapSi B hm R ∧ GapNo B hm gamma R) := by
  rintro ⟨hsi, hno⟩
  have hmul : R ≤ gamma * R := by nlinarith
  exact (not_lt_of_ge (hsi.trans hmul)) hno

theorem svp_mayor_factor (B : BaseReticular m d) (hm : 0 < m) (a b : ℝ) (hab : a ≤ b)
    (v : Ambiente d) (hv : SolucionSVP B hm a v) : SolucionSVP B hm b v :=
  ⟨hv.1, hv.2.1, hv.2.2.trans (mul_le_mul_of_nonneg_right hab (minimo_no_negativo B _))⟩

theorem sivp_mayor_factor (B : BaseReticular m d) (a b : ℝ) (hab : a ≤ b)
    (v : Fin m → Ambiente d) (hv : SolucionSIVP B a v) : SolucionSIVP B b v :=
  ⟨hv.1, fun j => ⟨(hv.2 j).1, (hv.2 j).2.trans
    (mul_le_mul_of_nonneg_right hab (minimo_no_negativo B _))⟩⟩

end Nexus.Reticulos
