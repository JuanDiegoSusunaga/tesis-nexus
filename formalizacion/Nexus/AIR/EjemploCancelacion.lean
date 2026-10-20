module

public import Nexus.AIR.GradosValidos
public import Nexus.AIR.Goldilocks
public import Nexus.AIR.Interpolacion
import Mathlib.Tactic

public section
namespace Nexus.AIR.EjemploCancelacion

open Polynomial Nexus.Goldilocks
open scoped BigOperators

/-- Datos exactos del caso T=16: solo cambia la primera fila de 3 a 4. -/
@[expose] def valores : Fin 16 → Fp := ![4, 5, 34, 1181, 1395917, 1948585665650, 530850651210480354, 16145743797608257389, 2930132624031665497, 14981270192906269032, 1275097236305329950, 18423289286765085571, 14560713114209424006, 11514122190078980083, 11401145570263550979, 16711650847234044346]
@[expose] def coeficientes : Fin 16 → Fp := ![9085469099876832415, 17269910161716940662, 3376097262561141132, 5273739047894566180, 9009357275199119700, 14238844997140174664, 15150872075853112680, 17680293220330922250, 1669302325656367548, 3387601232027480112, 10021230211110246259, 15366671586324698949, 3055326803242886014, 5032383250656143115, 14661015501467172126, 3295838504258870766]
@[expose] noncomputable def traza : Polynomial Fp :=
  ∑ i : Fin 16, monomial i (coeficientes i)

theorem raiz_valor : raiz 4 = 17293822564807737345 := by
  have h : (7 : ZMod p) ^ ((p - 1) / 16) = 17293822564807737345 := by
    unfold p
    norm_num only [Nat.reduceSub, Nat.reduceDiv]
    reduce_mod_char
  exact h

theorem grado_traza : traza.natDegree < 16 := by
  have hd : traza.degree < (16 : ℕ) := by
    simpa only [traza, ← C_mul_X_pow_eq_monomial] using degree_sum_fin_lt coeficientes
  by_cases h : traza = 0
  · simp [h]
  · exact (natDegree_lt_iff_degree_lt h).mpr hd

theorem coeficiente_ultimo : traza.coeff 15 = 3295838504258870766 := by
  classical
  change (∑ i : Fin 16, monomial i (coeficientes i)).coeff (15 : Fin 16) = _
  simp only [finsetSum_coeff, coeff_monomial, Fin.val_eq_val, Finset.sum_ite_eq',
    Finset.mem_univ, ite_true]
  rfl

theorem grado_traza_exacto : traza.natDegree = 15 := by
  apply natDegree_eq_of_le_of_coeff_ne_zero (by have h := grado_traza; omega)
  rw [coeficiente_ultimo]
  decide

set_option maxHeartbeats 2000000 in
theorem evaluaciones (i : Fin 16) : traza.eval (raiz 4 ^ (i : ℕ)) = valores i := by
  have : CharP Fp 18446744069414584321 := inferInstance
  rw [raiz_valor]
  fin_cases i <;>
    norm_num [traza, valores, coeficientes, Fin.sum_univ_succ, eval_monomial] <;> reduce_mod_char!


theorem primera_fila : traza.eval 1 = 4 := by
  simpa [valores] using evaluaciones 0

theorem segunda_fila : traza.eval (raiz 4) = 5 := by
  simpa [valores] using evaluaciones 1

theorem tercera_fila : traza.eval (raiz 4 ^ 2) = 34 := by
  simpa [valores] using evaluaciones 2

theorem final_fila : traza.eval (raiz 4 ^ 15) = valores 15 := evaluaciones 15

theorem traza_invalida : ¬ Nexus.AIR.Valida (raiz 4) 16 traza 3 (valores 15) := by
  intro hv
  have h := primera_fila.symm.trans hv.1
  exact (by decide : (4 : Fp) ≠ 3) h

set_option maxHeartbeats 1000000 in
theorem recurrencias (i : Fin 13) :
    valores ⟨(i : ℕ) + 3, by omega⟩ =
      valores ⟨(i : ℕ) + 2, by omega⟩ ^ 2 + valores ⟨(i : ℕ) + 1, by omega⟩ ^ 2 := by
  have : CharP Fp 18446744069414584321 := inferInstance
  fin_cases i <;> norm_num [valores] <;> reduce_mod_char!

theorem transicion_positiva (i : ℕ) (hi0 : 0 < i) (hi : i < 14) :
    (Nexus.AIR.transicion (raiz 4) traza).eval (raiz 4 ^ i) = 0 := by
  have h1 : raiz 4 * raiz 4 ^ i = raiz 4 ^ (i + 1) := by rw [pow_succ, mul_comm]
  have h2 : raiz 4 ^ 2 * raiz 4 ^ i = raiz 4 ^ (i + 2) := by rw [pow_add, mul_comm]
  simp only [Nexus.AIR.transicion, eval_sub, eval_comp, eval_mul, eval_C, eval_X,
    eval_pow, h1, h2]
  rw [evaluaciones ⟨i + 2, by omega⟩, evaluaciones ⟨i + 1, by omega⟩,
    evaluaciones ⟨i, by omega⟩]
  have hrec := recurrencias ⟨i - 1, by omega⟩
  have h3 : i - 1 + 3 = i + 2 := by omega
  have h2' : i - 1 + 2 = i + 1 := by omega
  have h1' : i - 1 + 1 = i := by omega
  simp only [h3, h2', h1'] at hrec
  rw [hrec]
  ring

theorem transicion_inicial : (Nexus.AIR.transicion (raiz 4) traza).eval 1 = -7 := by
  simp only [Nexus.AIR.transicion, eval_sub, eval_comp, eval_mul, eval_C, eval_X,
    eval_pow, mul_one, primera_fila, segunda_fila, tercera_fila]
  norm_num

theorem denominador_filas (i : ℕ) :
    (Nexus.AIR.denominador 16 : Polynomial Fp).eval (raiz 4 ^ i) = 0 := by
  have hg : raiz 4 ^ 16 = 1 := by simpa using (raiz_primitiva 4 (by decide)).pow_eq_one
  have hp : (raiz 4 ^ i) ^ 16 = 1 := by
    rw [← pow_mul, Nat.mul_comm i 16, pow_mul, hg, one_pow]
  simp [Nexus.AIR.denominador, hp]

theorem frontera_inicial :
    (Nexus.AIR.frontera (Nexus.AIR.denominador 16) traza 3 1).eval 1 = 16 := by
  have hfac : (Nexus.AIR.denominador 16 : Polynomial Fp) =
      (X - C 1) * ∑ i ∈ Finset.range 16, X ^ i := by
    norm_num [Nexus.AIR.denominador, Finset.sum_range_succ]
    ring
  unfold Nexus.AIR.frontera
  rw [hfac, mul_div_cancel_left₀ _ (Polynomial.X_sub_C_ne_zero (1 : Fp))]
  simp [primera_fila]
  ring

theorem frontera_inicial_otra (i : ℕ) (hi0 : 0 < i) (hi : i < 16) :
    (Nexus.AIR.frontera (Nexus.AIR.denominador 16) traza 3 1).eval (raiz 4 ^ i) = 0 := by
  have hx : raiz 4 ^ i ≠ 1 :=
    (raiz_primitiva 4 (by decide)).pow_ne_one_of_pos_of_lt hi0.ne' hi
  have hd : (X - C 1 : Polynomial Fp) ∣ Nexus.AIR.denominador 16 := by
    apply Polynomial.dvd_iff_isRoot.mpr
    simp [Polynomial.IsRoot, Nexus.AIR.denominador]
  have he := congrArg (fun P : Polynomial Fp => P.eval (raiz 4 ^ i))
    (EuclideanDomain.mul_div_cancel' (Polynomial.X_sub_C_ne_zero (1 : Fp)) hd)
  rw [eval_mul, eval_sub, eval_X, eval_C, denominador_filas] at he
  have hq := (mul_eq_zero.mp he).resolve_left (sub_ne_zero.mpr hx)
  rw [Nexus.AIR.frontera, eval_mul, hq, mul_zero]

theorem frontera_final (i : ℕ) :
    (Nexus.AIR.frontera (Nexus.AIR.denominador 16) traza (valores 15)
      (raiz 4 ^ 15)).eval (raiz 4 ^ i) = 0 := by
  have hd : (X - C (raiz 4 ^ 15) : Polynomial Fp) ∣ Nexus.AIR.denominador 16 :=
    Polynomial.dvd_iff_isRoot.mpr (denominador_filas 15)
  rw [Nexus.AIR.GradosValidos.frontera_factoriza _ _ _ _ hd final_fila, eval_mul,
    denominador_filas, zero_mul]

theorem numerador_transicion_otra (i : ℕ) (hi0 : 0 < i) (hi : i < 16) :
    (Nexus.AIR.numeradorTransicion (raiz 4) traza (raiz 4 ^ 15) (raiz 4 ^ 14)).eval
      (raiz 4 ^ i) = 0 := by
  by_cases hit : i < 14
  · simp [Nexus.AIR.numeradorTransicion, transicion_positiva i hi0 hit]
  · have hc : i = 14 ∨ i = 15 := by omega
    rcases hc with rfl | rfl <;> simp [Nexus.AIR.numeradorTransicion]

@[expose] def retos : Nexus.N01.Coeficientes Fp := (10376293027944593777, 1, 1)

theorem calculo_coeficiente :
    (10376293027944593777 : Fp) * 16 - 7 * (1 - raiz 4 ^ 15) * (1 - raiz 4 ^ 14) = 0 := by
  have : CharP Fp 18446744069414584321 := inferInstance
  rw [raiz_valor]
  norm_num
  reduce_mod_char!

theorem numerador_filas (i : ℕ) (hi : i < 16) :
    (Nexus.AIR.numeradorCombinado 16 (raiz 4) traza 3 (valores 15) retos).eval
      (raiz 4 ^ i) = 0 := by
  simp only [Nexus.AIR.numeradorCombinado, Nexus.N01.combinacion, eval_add,
    eval_smul, retos, smul_eq_mul, one_mul, Nat.reduceSub]
  rw [frontera_final i, add_zero]
  by_cases hz : i = 0
  · subst i
    simp only [pow_zero, frontera_inicial, Nexus.AIR.numeradorTransicion,
      eval_mul, eval_sub, eval_X, eval_C, transicion_inicial]
    linear_combination calculo_coeficiente
  · rw [frontera_inicial_otra i (by omega) hi,
      numerador_transicion_otra i (by omega) hi]
    simp

/-- La traza es inválida, pero la combinación tiene resto nulo para estos retos elegidos. -/
theorem cancelacion_exacta :
    Nexus.AIR.numeradorCombinado 16 (raiz 4) traza 3 (valores 15) retos %
      Nexus.AIR.denominador 16 = 0 := by
  classical
  rw [EuclideanDomain.mod_eq_zero,
    ← Nexus.AIR.anulador_dominio 16 (raiz 4) (by decide) (raiz_primitiva 4 (by decide))]
  apply (Nexus.AIR.anulador_dvd_iff _ _).mpr
  intro x hx
  simp only [Nexus.AIR.dominio, Finset.mem_image, Finset.mem_range] at hx
  obtain ⟨i, hi, rfl⟩ := hx
  exact numerador_filas i hi

theorem grado_composicion_cota :
    (Nexus.AIR.Contraejemplo.composicion 16 (raiz 4) traza 3 (valores 15) retos).natDegree ≤ 16 :=
  Nexus.AIR.GradosValidos.grado_cociente_combinado 16 (by decide) _ _ _ _ _ grado_traza

theorem evaluacion_tras_cancelar (x : Fp)
    (hx : (Nexus.AIR.denominador 16 : Polynomial Fp).eval x ≠ 0) :
    (Nexus.AIR.Contraejemplo.composicion 16 (raiz 4) traza 3 (valores 15) retos).eval x =
      (Nexus.AIR.numeradorCombinado 16 (raiz 4) traza 3 (valores 15) retos).eval x /
        (Nexus.AIR.denominador 16 : Polynomial Fp).eval x := by
  have hd := EuclideanDomain.mod_eq_zero.mp cancelacion_exacta
  have hD : (Nexus.AIR.denominador 16 : Polynomial Fp) ≠ 0 := by
    intro h
    exact hx (by rw [h, eval_zero])
  have he := congrArg (fun P : Polynomial Fp => P.eval x)
    (EuclideanDomain.mul_div_cancel' hD hd)
  rw [eval_mul] at he
  apply (eq_div_iff hx).mpr
  simpa only [Nexus.AIR.Contraejemplo.composicion, mul_comm] using he

theorem coeficiente_reescalado (a : Fp) (ha : a ≠ 0) :
    (traza.comp (C a * X)).coeff 15 = 3295838504258870766 * a ^ 15 := by
  have hq : (C a * X : Polynomial Fp).natDegree = 1 := by
    rw [natDegree_C_mul ha, natDegree_X]
  have hl : traza.leadingCoeff = 3295838504258870766 := by
    rw [Polynomial.leadingCoeff, grado_traza_exacto, coeficiente_ultimo]
  have hc := coeff_comp_degree_mul_degree (p := traza) (q := C a * X) (by rw [hq]; decide)
  simpa only [grado_traza_exacto, hq, Nat.mul_one, hl, leadingCoeff_mul,
    leadingCoeff_C, leadingCoeff_X, mul_one] using hc

theorem coeficiente_transicion :
    (Nexus.AIR.transicion (raiz 4) traza).coeff 30 =
      -(3295838504258870766 * raiz 4 ^ 15) ^ 2 - 3295838504258870766 ^ 2 := by
  have hg := (raiz_primitiva 4 (by decide)).ne_zero (by decide)
  have h0 : (traza.comp (C (raiz 4 ^ 2) * X)).coeff 30 = 0 :=
    coeff_eq_zero_of_natDegree_lt ((Nexus.AIR.grado_reescalado _ _).trans_lt
      (grado_traza.trans_le (by decide)))
  have hdeg : traza.natDegree ≤ 15 := by have h := grado_traza; omega
  have h1 := Nexus.AIR.Contraejemplo.coeficiente_cuadrado 15 (traza.comp (C (raiz 4) * X))
    ((Nexus.AIR.grado_reescalado _ _).trans hdeg)
  have h2 := Nexus.AIR.Contraejemplo.coeficiente_cuadrado 15 traza hdeg
  simp only [Nexus.AIR.transicion, coeff_sub, h0, h1, h2, coeficiente_reescalado _ hg,
    coeficiente_ultimo, zero_sub]

theorem coeficiente_transicion_exacto :
    (Nexus.AIR.transicion (raiz 4) traza).coeff 30 = 11447569686273502510 := by
  rw [coeficiente_transicion, raiz_valor]
  have h : -(3295838504258870766 * (17293822564807737345 : ZMod p) ^ 15) ^ 2 -
      3295838504258870766 ^ 2 = 11447569686273502510 := by
    unfold p
    norm_num
    reduce_mod_char
  exact h

theorem coeficiente_numerador_transicion :
    (Nexus.AIR.numeradorTransicion (raiz 4) traza (raiz 4 ^ 15) (raiz 4 ^ 14)).coeff 32 =
      (Nexus.AIR.transicion (raiz 4) traza).coeff 30 := by
  have hd : (Nexus.AIR.transicion (raiz 4) traza).natDegree ≤ 30 :=
    Nexus.AIR.grado_transicion 16 _ _ grado_traza
  have hp : ((Nexus.AIR.transicion (raiz 4) traza) * (X - C (raiz 4 ^ 15))).natDegree ≤ 31 :=
    (natDegree_mul_le_of_le hd (natDegree_X_sub_C _).le).trans (by decide)
  have h1 : ((Nexus.AIR.transicion (raiz 4) traza) * (X - C (raiz 4 ^ 15))).coeff 31 =
      (Nexus.AIR.transicion (raiz 4) traza).coeff 30 := by
    have hz : (Nexus.AIR.transicion (raiz 4) traza).coeff 31 = 0 :=
      coeff_eq_zero_of_natDegree_lt (by omega)
    change ((Nexus.AIR.transicion (raiz 4) traza) * (X - C (raiz 4 ^ 15))).coeff (30 + 1) = _
    rw [coeff_mul_X_sub_C, hz, zero_mul, sub_zero]
  have hz : ((Nexus.AIR.transicion (raiz 4) traza) * (X - C (raiz 4 ^ 15))).coeff 32 = 0 :=
    coeff_eq_zero_of_natDegree_lt (by omega)
  unfold Nexus.AIR.numeradorTransicion
  change (((Nexus.AIR.transicion (raiz 4) traza) * (X - C (raiz 4 ^ 15))) *
    (X - C (raiz 4 ^ 14))).coeff (31 + 1) = _
  rw [coeff_mul_X_sub_C, hz, zero_mul, sub_zero, h1]

theorem coeficiente_numerador_combinado :
    (Nexus.AIR.numeradorCombinado 16 (raiz 4) traza 3 (valores 15) retos).coeff 32 = 11447569686273502510 := by
  have hb (s a : Fp) :
      (Nexus.AIR.frontera (Nexus.AIR.denominador 16) traza s a).coeff 32 = 0 := by
    apply coeff_eq_zero_of_natDegree_lt
    have h := Nexus.AIR.GradosValidos.grado_numerador_frontera 16 (by decide) traza s a grado_traza
    omega
  simp only [Nexus.AIR.numeradorCombinado, Nexus.N01.combinacion, coeff_add, coeff_smul,
    retos, hb, smul_zero, zero_add, Nat.reduceSub, one_smul,
    coeficiente_numerador_transicion, coeficiente_transicion_exacto]

theorem grado_numerador_exacto :
    (Nexus.AIR.numeradorCombinado 16 (raiz 4) traza 3 (valores 15) retos).natDegree = 32 := by
  apply natDegree_eq_of_le_of_coeff_ne_zero
    (Nexus.AIR.grado_numerador_combinado 16 _ _ _ _ _ (by decide) grado_traza)
  rw [coeficiente_numerador_combinado]
  decide

theorem grado_composicion_exacto :
    (Nexus.AIR.Contraejemplo.composicion 16 (raiz 4) traza 3 (valores 15) retos).natDegree = 16 := by
  have hm : (Nexus.AIR.denominador 16 : Polynomial Fp).Monic := by
    simpa [Nexus.AIR.denominador] using monic_X_pow_sub_C (1 : Fp) (by decide : 16 ≠ 0)
  rw [Nexus.AIR.Contraejemplo.composicion, ← divByMonic_eq_div _ hm,
    natDegree_divByMonic _ hm, grado_numerador_exacto, Nexus.AIR.grado_denominador]

theorem salida_honesta : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 15 = valores 15 := by
  have : CharP Fp 18446744069414584321 := inferInstance
  have h0 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 0 = 3 := rfl
  have h1 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 1 = 5 := rfl
  have h2 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 2 = 34 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h1, h0]
    norm_num
  have h3 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 3 = 1181 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h2, h1]
    norm_num
  have h4 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 4 = 1395917 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h3, h2]
    norm_num
  have h5 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 5 = 1948585665650 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h4, h3]
    norm_num
  have h6 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 6 = 530850651210480354 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h5, h4]
    norm_num
    reduce_mod_char!
  have h7 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 7 = 16145743797608257389 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h6, h5]
    norm_num
    reduce_mod_char!
  have h8 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 8 = 2930132624031665497 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h7, h6]
    norm_num
    reduce_mod_char!
  have h9 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 9 = 14981270192906269032 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h8, h7]
    norm_num
    reduce_mod_char!
  have h10 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 10 = 1275097236305329950 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h9, h8]
    norm_num
    reduce_mod_char!
  have h11 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 11 = 18423289286765085571 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h10, h9]
    norm_num
    reduce_mod_char!
  have h12 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 12 = 14560713114209424006 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h11, h10]
    norm_num
    reduce_mod_char!
  have h13 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 13 = 11514122190078980083 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h12, h11]
    norm_num
    reduce_mod_char!
  have h14 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 14 = 11401145570263550979 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h13, h12]
    norm_num
    reduce_mod_char!
  have h15 : Nexus.AIR.Contraejemplo.fila (3 : Fp) 5 15 = 16711650847234044346 := by
    rw [Nexus.AIR.Contraejemplo.fila_recurrencia, h14, h13]
    norm_num
    reduce_mod_char!
  exact h15

theorem existe_valida_alternativa : ∃ f : Polynomial Fp,
    f.natDegree < 16 ∧ Nexus.AIR.Valida (raiz 4) 16 f 3 (valores 15) := by
  refine ⟨Nexus.AIR.Contraejemplo.interpolante 16 (raiz 4) 3 5,
    Nexus.AIR.Contraejemplo.grado_interpolante 16 (by decide) _ _ _
      (raiz_primitiva 4 (by decide)), ?_⟩
  have hv := Nexus.AIR.Contraejemplo.interpolante_valido 16 (by decide) (raiz 4) 3 5
    (raiz_primitiva 4 (by decide))
  simpa only [Nat.reduceSub, salida_honesta] using hv

/-- El ejemplo no corresponde a un enunciado falso: hay una traza válida alternativa. -/
theorem certificado_cancelacion :
    ¬ Nexus.AIR.Valida (raiz 4) 16 traza 3 (valores 15) ∧
    Nexus.AIR.numeradorCombinado 16 (raiz 4) traza 3 (valores 15) retos %
      Nexus.AIR.denominador 16 = 0 ∧
    (Nexus.AIR.Contraejemplo.composicion 16 (raiz 4) traza 3 (valores 15) retos).natDegree = 16 ∧
    (∃ f : Polynomial Fp, f.natDegree < 16 ∧ Nexus.AIR.Valida (raiz 4) 16 f 3 (valores 15)) :=
  ⟨traza_invalida, cancelacion_exacta, grado_composicion_exacto, existe_valida_alternativa⟩

end Nexus.AIR.EjemploCancelacion
