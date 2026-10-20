module

public import Nexus.Modelos.Residencia
public import Mathlib.MeasureTheory.Integral.Bochner.Set
public import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
public import Mathlib.Data.Rat.Cast.Order
import Mathlib.Tactic

/-!
# Residencia acumulada e intervalos de exposición

Integral de bytes·tiempo sobre un horizonte. Las regiones se suman como
copias distintas; la coincidencia temporal emplea la unión de intervalos.
-/

public section
namespace Nexus.Modelos.Temporal

open Set MeasureTheory
open scoped BigOperators

structure Region where
  bytes : ℝ
  inicio : ℝ
  fin : ℝ
  bytes_no_negativos : 0 ≤ bytes
  orden : inicio ≤ fin

@[expose] def intervalo (r : Region) : Set ℝ := Ioc r.inicio r.fin
@[expose] noncomputable def actividad (r : Region) (t : ℝ) : ℝ :=
  (intervalo r).indicator (fun _ => r.bytes) t
@[expose] noncomputable def acumulada (T : ℝ) (f : ℝ → ℝ) : ℝ := ∫ t in Ioc 0 T, f t
@[expose] noncomputable def regiones {n : ℕ} (T : ℝ) (r : Fin n → Region) : ℝ :=
  acumulada T (fun t => ∑ i, actividad (r i) t)
@[expose] noncomputable def exposicion {n : ℕ} (a b : Fin n → ℝ) : Set ℝ := ⋃ i, Ioc (a i) (b i)

theorem actividad_no_negativa (r : Region) (t : ℝ) : 0 ≤ actividad r t := by
  unfold actividad
  exact Set.indicator_nonneg (fun _ _ => r.bytes_no_negativos) _

theorem actividad_integrable (r : Region) : Integrable (actividad r) := by
  unfold actividad intervalo
  exact (integrable_indicator_iff measurableSet_Ioc).mpr
    (integrableOn_const (by rw [Real.volume_Ioc]; exact ENNReal.ofReal_ne_top))

theorem integral_region (r : Region) :
    (∫ t, actividad r t) = r.bytes * (r.fin - r.inicio) := by
  change (∫ t, (Ioc r.inicio r.fin).indicator (fun _ => r.bytes) t) = _
  rw [integral_indicator_const _ measurableSet_Ioc]
  rw [Real.volume_real_Ioc_of_le r.orden, smul_eq_mul, mul_comm]

theorem integral_region_recortada (T : ℝ) (r : Region) :
    acumulada T (actividad r) = volume.real (Ioc 0 T ∩ intervalo r) * r.bytes := by
  unfold acumulada actividad intervalo
  rw [setIntegral_indicator measurableSet_Ioc, setIntegral_const, smul_eq_mul]

theorem integral_region_contenida (T : ℝ) (r : Region)
    (h0 : 0 ≤ r.inicio) (hT : r.fin ≤ T) :
    acumulada T (actividad r) = r.bytes * (r.fin - r.inicio) := by
  rw [integral_region_recortada, intervalo, inter_eq_right.mpr (Ioc_subset_Ioc h0 hT)]
  rw [Real.volume_real_Ioc_of_le r.orden, mul_comm]

theorem residencia_suma {n : ℕ} (T : ℝ) (r : Fin n → Region) :
    regiones T r = ∑ i, acumulada T (actividad (r i)) := by
  exact integral_finsetSum _ (fun i _ => (actividad_integrable (r i)).integrableOn)

theorem residencia_formula {n : ℕ} (T : ℝ) (r : Fin n → Region)
    (h0 : ∀ i, 0 ≤ (r i).inicio) (hT : ∀ i, (r i).fin ≤ T) :
    regiones T r = ∑ i, (r i).bytes * ((r i).fin - (r i).inicio) := by
  rw [residencia_suma]
  exact Finset.sum_congr rfl (fun i _ => integral_region_contenida T (r i) (h0 i) (hT i))

theorem residencia_no_negativa {n : ℕ} (T : ℝ) (r : Fin n → Region) : 0 ≤ regiones T r := by
  exact integral_nonneg (fun t => Finset.sum_nonneg (fun i _ => actividad_no_negativa (r i) t))

theorem exposicion_medible {n : ℕ} (a b : Fin n → ℝ) : MeasurableSet (exposicion a b) :=
  MeasurableSet.iUnion (fun _ => measurableSet_Ioc)

theorem exposicion_contenida {n : ℕ} (T : ℝ) (a b : Fin n → ℝ)
    (h0 : ∀ i, 0 ≤ a i) (hT : ∀ i, b i ≤ T) : exposicion a b ⊆ Ioc 0 T := by
  intro t ht
  obtain ⟨i, hi⟩ := mem_iUnion.mp ht
  exact Ioc_subset_Ioc (h0 i) (hT i) hi

theorem longitud_union_cota {n : ℕ} (a b : Fin n → ℝ) (hab : ∀ i, a i ≤ b i) :
    volume.real (exposicion a b) ≤ ∑ i, (b i - a i) := by
  have h := measureReal_iUnion_fintype_le (μ := (volume : Measure ℝ)) (fun i => Ioc (a i) (b i))
  simpa only [exposicion, Real.volume_real_Ioc_of_le (hab _)] using h

theorem longitud_union_disjunta {n : ℕ} (a b : Fin n → ℝ) (hab : ∀ i, a i ≤ b i)
    (hd : Pairwise (fun i j => Disjoint (Ioc (a i) (b i)) (Ioc (a j) (b j)))) :
    volume.real (exposicion a b) = ∑ i, (b i - a i) := by
  rw [exposicion, measureReal_iUnion_fintype hd (fun _ => measurableSet_Ioc)
    (fun _ => by rw [Real.volume_Ioc]; exact ENNReal.ofReal_ne_top)]
  exact Finset.sum_congr rfl (fun i _ => Real.volume_real_Ioc_of_le (hab i))

theorem longitud_union_horizonte {n : ℕ} (T : ℝ) (hT0 : 0 ≤ T) (a b : Fin n → ℝ)
    (h0 : ∀ i, 0 ≤ a i) (hT : ∀ i, b i ≤ T) : volume.real (exposicion a b) ≤ T := by
  have h := measureReal_mono (μ := (volume : Measure ℝ)) (exposicion_contenida T a b h0 hT)
    (by rw [Real.volume_Ioc]; exact ENNReal.ofReal_ne_top)
  simpa only [Real.volume_real_Ioc_of_le hT0, sub_zero] using h

theorem duracion_fija {n : ℕ} (a b : Fin n → ℝ) (tau : ℝ)
    (hab : ∀ i, a i ≤ b i) (ht : ∀ i, b i - a i = tau)
    (hd : Pairwise (fun i j => Disjoint (Ioc (a i) (b i)) (Ioc (a j) (b j)))) :
    volume.real (exposicion a b) = n * tau := by
  rw [longitud_union_disjunta a b hab hd]
  simp_rw [ht]
  simp

theorem solapamiento_no_duplica_union :
    volume.real (exposicion (fun _ : Fin 2 => 0) (fun _ => 1)) = 1 ∧
      (∑ _i : Fin 2, ((1 : ℝ) - 0)) = 2 := by
  constructor
  · change volume.real (⋃ _i : Fin 2, Ioc (0 : ℝ) 1) = 1
    rw [iUnion_const]
    norm_num
  · norm_num

@[expose] noncomputable def modelo (T b s : ℝ) (E : Set ℝ) : ℝ :=
  acumulada T (fun t => b + E.indicator (fun _ => s) t)

theorem modelo_integral (T b s : ℝ) (hT : 0 ≤ T) (E : Set ℝ)
    (hE : MeasurableSet E) (hsub : E ⊆ Ioc 0 T) :
    modelo T b s E = b * T + s * volume.real E := by
  have hf : IntegrableOn (fun _ : ℝ => b) (Ioc 0 T) :=
    integrableOn_const (by rw [Real.volume_Ioc]; exact ENNReal.ofReal_ne_top)
  have hg : IntegrableOn (E.indicator (fun _ : ℝ => s)) (Ioc 0 T) :=
    ((integrable_indicator_iff hE).mpr (integrableOn_const (measure_ne_top_of_subset hsub
      (by rw [Real.volume_Ioc]; exact ENNReal.ofReal_ne_top)))).integrableOn
  unfold modelo acumulada
  rw [integral_add hf hg, setIntegral_const, setIntegral_indicator hE,
    inter_eq_right.mpr hsub, setIntegral_const,
    Real.volume_real_Ioc_of_le hT, sub_zero, smul_eq_mul, smul_eq_mul]
  ring

theorem media_modelo (T b s : ℝ) (hT : 0 < T) (E : Set ℝ)
    (hE : MeasurableSet E) (hsub : E ⊆ Ioc 0 T) :
    modelo T b s E / T = b + s * (volume.real E / T) := by
  rw [modelo_integral T b s (le_of_lt hT) E hE hsub]
  field_simp

theorem media_modelo_racional (T : ℝ) (hT : 0 < T) (b s rho : ℚ) (E : Set ℝ)
    (hE : MeasurableSet E) (hsub : E ⊆ Ioc 0 T) (hr : volume.real E / T = (rho : ℝ)) :
    modelo T b s E / T = (Nexus.Modelos.Residencia.promedio b s rho : ℚ) := by
  rw [media_modelo T b s hT E hE hsub, hr]
  norm_num [Nexus.Modelos.Residencia.promedio]

theorem media_secuencial {n : ℕ} (T b s tau : ℝ) (hT0 : 0 < T)
    (a z : Fin n → ℝ) (h0 : ∀ i, 0 ≤ a i) (hT : ∀ i, z i ≤ T)
    (haz : ∀ i, a i ≤ z i) (ht : ∀ i, z i - a i = tau)
    (hd : Pairwise (fun i j => Disjoint (Ioc (a i) (z i)) (Ioc (a j) (z j)))) :
    modelo T b s (exposicion a z) / T = b + s * ((n : ℝ) / T * tau) := by
  rw [media_modelo T b s hT0 _ (exposicion_medible a z) (exposicion_contenida T a z h0 hT),
    duracion_fija a z tau haz ht hd]
  ring

theorem ocupacion_secuencial_cota {n : ℕ} (T tau : ℝ) (hT0 : 0 < T)
    (a z : Fin n → ℝ) (h0 : ∀ i, 0 ≤ a i) (hT : ∀ i, z i ≤ T)
    (haz : ∀ i, a i ≤ z i) (ht : ∀ i, z i - a i = tau)
    (hd : Pairwise (fun i j => Disjoint (Ioc (a i) (z i)) (Ioc (a j) (z j)))) :
    (n : ℝ) / T * tau ≤ 1 := by
  have h := longitud_union_horizonte T (le_of_lt hT0) a z h0 hT
  rw [duracion_fija a z tau haz ht hd] at h
  rw [div_mul_eq_mul_div]
  apply (div_le_iff₀ hT0).mpr
  simpa only [one_mul] using h

theorem modelo_cacheado (T b s : ℝ) (hT : 0 ≤ T) :
    modelo T b s (Ioc 0 T) = (b + s) * T := by
  rw [modelo_integral T b s hT _ measurableSet_Ioc (Subset.refl _),
    Real.volume_real_Ioc_of_le hT, sub_zero]
  ring

theorem ocupacion_cotas (T : ℝ) (hT : 0 < T) (E : Set ℝ) (hsub : E ⊆ Ioc 0 T) :
    0 ≤ volume.real E / T ∧ volume.real E / T ≤ 1 := by
  constructor
  · exact div_nonneg measureReal_nonneg (le_of_lt hT)
  · apply (div_le_iff₀ hT).mpr
    have h := measureReal_mono (μ := (volume : Measure ℝ)) hsub
      (by rw [Real.volume_Ioc]; exact ENNReal.ofReal_ne_top)
    simpa only [Real.volume_real_Ioc_of_le (le_of_lt hT), sub_zero, one_mul] using h

theorem media_cotas (T b s : ℝ) (hT : 0 < T) (hs : 0 ≤ s) (E : Set ℝ)
    (hE : MeasurableSet E) (hsub : E ⊆ Ioc 0 T) :
    b ≤ modelo T b s E / T ∧ modelo T b s E / T ≤ b + s := by
  rw [media_modelo T b s hT E hE hsub]
  have h := ocupacion_cotas T hT E hsub
  constructor <;> nlinarith

theorem razon_temporal_al_menos_uno (T b s : ℝ) (hT : 0 < T) (hb : 0 < b) (hs : 0 ≤ s)
    (E : Set ℝ) (hE : MeasurableSet E) (hsub : E ⊆ Ioc 0 T) :
    1 ≤ (b + s) / (modelo T b s E / T) := by
  have h := media_cotas T b s hT hs E hE hsub
  exact (le_div_iff₀ (hb.trans_le h.1)).mpr (by simpa only [one_mul] using h.2)

theorem razon_modelo_racional (T : ℝ) (hT : 0 < T) (b s rho : ℚ) (E : Set ℝ)
    (hE : MeasurableSet E) (hsub : E ⊆ Ioc 0 T) (hr : volume.real E / T = (rho : ℝ)) :
    ((b : ℝ) + s) / (modelo T b s E / T) = (Nexus.Modelos.Residencia.razon b s rho : ℚ) := by
  rw [media_modelo_racional T hT b s rho E hE hsub hr]
  norm_num [Nexus.Modelos.Residencia.razon]

@[expose] noncomputable def intervaloTabla (i : Fin 5) : Set ℝ :=
  Ioc 0 ((Nexus.Modelos.Residencia.tasas i * Nexus.Modelos.Residencia.latencia : ℚ) : ℝ)

theorem ocupacion_tabla_cotas (i : Fin 5) :
    (0 : ℚ) ≤ Nexus.Modelos.Residencia.tasas i * Nexus.Modelos.Residencia.latencia ∧
      Nexus.Modelos.Residencia.tasas i * Nexus.Modelos.Residencia.latencia ≤ 1 := by
  fin_cases i <;> norm_num [Nexus.Modelos.Residencia.tasas, Nexus.Modelos.Residencia.latencia]

theorem intervalo_tabla_contenido (i : Fin 5) : intervaloTabla i ⊆ Ioc 0 1 := by
  exact Ioc_subset_Ioc (le_refl _) (by exact_mod_cast (ocupacion_tabla_cotas i).2)

theorem ocupacion_tabla (i : Fin 5) :
    volume.real (intervaloTabla i) / 1 =
      ((Nexus.Modelos.Residencia.tasas i * Nexus.Modelos.Residencia.latencia : ℚ) : ℝ) := by
  rw [intervaloTabla, Real.volume_real_Ioc_of_le (by exact_mod_cast (ocupacion_tabla_cotas i).1),
    sub_zero, div_one]

theorem tabla5_2_desde_integral (i : Fin 5) :
    |modelo 1 32 4032 (intervaloTabla i) / 1 - (Nexus.Modelos.Residencia.promedios_tabla i : ℝ)| < 1 / 2000 ∧
    |(32 + 4032) / (modelo 1 32 4032 (intervaloTabla i) / 1) -
      (Nexus.Modelos.Residencia.razones_tabla i : ℝ)| < 1 / 2000 := by
  have hE : MeasurableSet (intervaloTabla i) := measurableSet_Ioc
  rw [show (32 : ℝ) = ((32 : ℚ) : ℝ) by norm_num,
    show (4032 : ℝ) = ((4032 : ℚ) : ℝ) by norm_num]
  rw [razon_modelo_racional 1 (by norm_num) 32 4032 _ (intervaloTabla i) hE
      (intervalo_tabla_contenido i) (ocupacion_tabla i),
    media_modelo_racional 1 (by norm_num) 32 4032 _ (intervaloTabla i) hE
      (intervalo_tabla_contenido i) (ocupacion_tabla i)]
  have h1 := (Rat.cast_lt (K := ℝ)).mpr (Nexus.Modelos.Residencia.tabla5_2 i).2.1
  have h2 := (Rat.cast_lt (K := ℝ)).mpr (Nexus.Modelos.Residencia.tabla5_2 i).2.2
  push_cast at h1 h2
  exact ⟨h1, h2⟩

end Nexus.Modelos.Temporal
