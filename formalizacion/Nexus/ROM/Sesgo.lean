module

public import Nexus.Campos.Goldilocks
public import Nexus.Cripto.Probabilidad
public import Nexus.Cripto.Variacion
import Mathlib.Tactic

public section
namespace Nexus.ROM.Sesgo

open scoped BigOperators

/-- Número de preimágenes de un residuo al reducir S valores uniformes módulo p. -/
@[expose] def cuenta (p S j : ℕ) : ℕ := S / p + if j < S % p then 1 else 0

theorem descomposicion (p S : ℕ) : S = S / p * p + S % p := by
  simpa only [Nat.mul_comm] using (Nat.div_add_mod S p).symm

theorem cociente_fibra (p S : ℕ) (hp : 0 < p) (x : Fin S) :
    x.val / p < cuenta p S (x.val % p) := by
  have hx := x.isLt
  have he := Nat.div_add_mod x.val p
  have hs := Nat.div_add_mod S p
  have hr := Nat.mod_lt S hp
  have hxr := Nat.mod_lt x.val hp
  unfold cuenta
  split_ifs with h
  · by_contra hbad
    have hb : S / p + 1 ≤ x.val / p := by omega
    have hm := Nat.mul_le_mul_left p hb
    simp only [Nat.mul_add, Nat.mul_one] at hm
    omega
  · by_contra hbad
    have hb : S / p ≤ x.val / p := by omega
    have hh : S % p ≤ x.val % p := by omega
    have hm := Nat.mul_le_mul_left p hb
    nlinarith

theorem representante_fibra (p S : ℕ) (hp : 0 < p) (j : Fin p) (k : Fin (cuenta p S j)) :
    j.val + p * k.val < S := by
  have hk := k.isLt
  have hj := j.isLt
  have hs := Nat.div_add_mod S p
  have hr := Nat.mod_lt S hp
  unfold cuenta at hk
  split_ifs at hk with h
  · have hb : k.val ≤ S / p := by omega
    have hm := Nat.mul_le_mul_left p hb
    nlinarith
  · have hb : k.val + 1 ≤ S / p := by omega
    have hm := Nat.mul_le_mul_left p hb
    simp only [Nat.mul_add, Nat.mul_one] at hm
    omega

@[expose] def equivalenciaFibra (p S : ℕ) (hp : 0 < p) (j : Fin p) :
    {x : Fin S // x.val % p = j.val} ≃ Fin (cuenta p S j) where
  toFun x := ⟨x.val.val / p, by simpa only [x.property] using cociente_fibra p S hp x.val⟩
  invFun k := ⟨⟨j.val + p * k.val, representante_fibra p S hp j k⟩, by
    simp only [Nat.add_mod, Nat.mul_mod_right, add_zero, Nat.mod_eq_of_lt j.isLt]⟩
  left_inv x := by
    apply Subtype.ext
    apply Fin.ext
    dsimp only
    have h := Nat.mod_add_div x.val.val p
    rw [x.property] at h
    exact h
  right_inv k := by
    apply Fin.ext
    dsimp only
    rw [Nat.add_mul_div_left _ _ hp, Nat.div_eq_of_lt j.isLt, zero_add]

theorem cardinal_fibra (p S : ℕ) (hp : 0 < p) (j : Fin p) :
    Fintype.card {x : Fin S // x.val % p = j.val} = cuenta p S j := by
  rw [Fintype.card_congr (equivalenciaFibra p S hp j), Fintype.card_fin]

theorem particion_residuos (p r : ℕ) (hr : r ≤ p) (a b : ℚ) :
    (∑ j : Fin p, if j.val < r then a else b) = (r : ℚ) * a + ((p - r : ℕ) : ℚ) * b := by
  have he : {j : Fin p // j.val < r} ≃ Fin r :=
    { toFun := fun j => ⟨j.val.val, j.property⟩
      invFun := fun j => ⟨⟨j.val, j.isLt.trans_le hr⟩, j.isLt⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  have hc : (Finset.univ.filter (fun j : Fin p => j.val < r)).card = r := by
    simpa only [Fintype.card_subtype, Fintype.card_fin] using Fintype.card_congr he
  have hn : (Finset.univ.filter (fun j : Fin p => ¬ j.val < r)).card = p - r := by
    have h := Finset.card_filter_add_card_filter_not (s := Finset.univ) (fun j : Fin p => j.val < r)
    rw [hc, Finset.card_univ, Fintype.card_fin] at h
    omega
  rw [Finset.sum_ite, Finset.sum_const, Finset.sum_const, hc, hn]
  simp only [nsmul_eq_mul]

@[expose] def masa (p S j : ℕ) : ℚ := cuenta p S j / (S : ℚ)
@[expose] def delta (p S : ℕ) : ℚ := (∑ j : Fin p, |masa p S j - 1 / (p : ℚ)|) / 2

theorem masa_no_negativa (p S j : ℕ) : 0 ≤ masa p S j := by unfold masa; positivity

theorem masa_normalizada (p S : ℕ) (hp : 0 < p) (hS : 0 < S) :
    (∑ j : Fin p, masa p S j) = 1 := by
  have hs : (S : ℚ) = (S / p : ℕ) * (p : ℚ) + (S % p : ℕ) := by
    exact_mod_cast descomposicion p S
  have hpoint (j : Fin p) : masa p S j =
      if j.val < S % p then ((S / p : ℕ) + 1) / (S : ℚ) else (S / p : ℕ) / (S : ℚ) := by
    unfold masa cuenta
    split_ifs <;> simp only [Nat.cast_add, Nat.cast_one, add_zero]
  simp_rw [hpoint]
  rw [particion_residuos p (S % p) (Nat.mod_lt S hp).le]
  rw [Nat.cast_sub (Nat.mod_lt S hp).le]
  have hS' : (S : ℚ) ≠ 0 := by positivity
  field_simp
  nlinarith

theorem desviacion_residuo (p S : ℕ) (hp : 0 < p) (hS : 0 < S) (j : Fin p) :
    |masa p S j - 1 / (p : ℚ)| =
      if j.val < S % p then ((p - S % p : ℕ) : ℚ) / ((p : ℚ) * S)
      else (S % p : ℕ) / ((p : ℚ) * S) := by
  have hp' : (0 : ℚ) < p := by exact_mod_cast hp
  have hS' : (0 : ℚ) < S := by exact_mod_cast hS
  have hr := (Nat.mod_lt S hp).le
  have hs : (S : ℚ) = (S / p : ℕ) * (p : ℚ) + (S % p : ℕ) := by
    exact_mod_cast descomposicion p S
  have hsub : ((p - S % p : ℕ) : ℚ) = (p : ℚ) - (S % p : ℕ) := Nat.cast_sub hr
  unfold masa cuenta
  split_ifs with h
  · rw [Nat.cast_add, Nat.cast_one, abs_of_nonneg]
    · rw [hsub]
      field_simp
      nlinarith
    · apply sub_nonneg.mpr
      apply (div_le_div_iff₀ hp' hS').mpr
      nlinarith
  · rw [Nat.cast_add, Nat.cast_zero, add_zero, abs_of_nonpos]
    · field_simp
      nlinarith
    · apply sub_nonpos.mpr
      apply (div_le_div_iff₀ hS' hp').mpr
      nlinarith

theorem sesgo_exacto (p S : ℕ) (hp : 0 < p) (hS : 0 < S) :
    delta p S = ((S % p : ℕ) : ℚ) * (p - S % p : ℕ) / ((p : ℚ) * S) := by
  unfold delta
  simp_rw [desviacion_residuo p S hp hS]
  rw [particion_residuos p (S % p) (Nat.mod_lt S hp).le]
  ring

@[expose] def masaMaxima (p S : ℕ) : ℚ := ((S / p + 1 : ℕ) : ℚ) / S

theorem masa_le_maxima (p S j : ℕ) : masa p S j ≤ masaMaxima p S := by
  unfold masa masaMaxima cuenta
  apply div_le_div_of_nonneg_right _ (by positivity)
  exact_mod_cast (by split_ifs <;> omega : S / p + (if j < S % p then 1 else 0) ≤ S / p + 1)

theorem goldilocks_resto : 2 ^ 128 % Nexus.Goldilocks.p = Nexus.Goldilocks.p - 2 ^ 32 := by
  norm_num [Nexus.Goldilocks.p]

theorem goldilocks_intervalo :
    (1262177 : ℚ) / 10 ^ 35 < delta Nexus.Goldilocks.p (2 ^ 128) ∧
      delta Nexus.Goldilocks.p (2 ^ 128) < (1262180 : ℚ) / 10 ^ 35 := by
  rw [sesgo_exacto _ _ (by norm_num [Nexus.Goldilocks.p]) (by norm_num)]
  norm_num [Nexus.Goldilocks.p]

theorem hibrido_cota (f : ℕ → ℚ) (e : ℚ)
    (h : ∀ i, |f (i + 1) - f i| ≤ e) (m : ℕ) : |f m - f 0| ≤ (m : ℚ) * e := by
  induction m with
  | zero => simp
  | succ m ih =>
    calc
      |f (m + 1) - f 0| ≤ |f (m + 1) - f m| + |f m - f 0| := by
        simpa only [sub_add_sub_cancel] using abs_add_le (f (m + 1) - f m) (f m - f 0)
      _ ≤ e + (m : ℚ) * e := add_le_add (h m) ih
      _ = ((m + 1 : ℕ) : ℚ) * e := by push_cast; ring

theorem goldilocks_28_retos :
    2 * 28 * delta Nexus.Goldilocks.p (2 ^ 128) < (7069 : ℚ) / 10 ^ 31 := by
  rw [sesgo_exacto _ _ (by norm_num [Nexus.Goldilocks.p]) (by norm_num)]
  norm_num [Nexus.Goldilocks.p]

@[expose] def leyReducida (p S : ℕ) (hp : 0 < p) (hS : 0 < S) : Nexus.Cripto.Variacion.Ley (Fin p) :=
  ⟨fun j => masa p S j, fun j => masa_no_negativa p S j, masa_normalizada p S hp hS⟩

@[expose] def leyUniforme (p : ℕ) (hp : 0 < p) : Nexus.Cripto.Variacion.Ley (Fin p) :=
  ⟨fun _ => 1 / (p : ℚ), fun _ => by positivity, by
    simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
    have hp' : (p : ℚ) ≠ 0 := by positivity
    field_simp⟩

theorem distancia_reduccion (p S : ℕ) (hp : 0 < p) (hS : 0 < S) :
    Nexus.Cripto.Variacion.distancia (leyReducida p S hp hS) (leyUniforme p hp) = delta p S := rfl

/-- Las dos coordenadas proceden de bloques independientes de la ley declarada. -/
theorem masa_extension_acotada (p S : ℕ) (hp : 0 < p) (hS : 0 < S) (x : Fin p × Fin p) :
    (Nexus.Cripto.Variacion.producto (leyReducida p S hp hS)
      (leyReducida p S hp hS)).peso x ≤ masaMaxima p S ^ 2 := by
  change masa p S x.1 * masa p S x.2 ≤ _
  simpa only [pow_two] using mul_le_mul (masa_le_maxima p S x.1)
    (masa_le_maxima p S x.2) (masa_no_negativa p S x.2)
    (show 0 ≤ masaMaxima p S by unfold masaMaxima; positivity)

theorem evento_retos_extension (p S m : ℕ) (hp : 0 < p) (hS : 0 < S)
    (E : Nexus.Cripto.Variacion.Espacio (Fin p × Fin p) m → Prop) :
    let real := Nexus.Cripto.Variacion.producto (leyReducida p S hp hS) (leyReducida p S hp hS)
    let ideal := Nexus.Cripto.Variacion.producto (leyUniforme p hp) (leyUniforme p hp)
    |Nexus.Cripto.Variacion.evento (Nexus.Cripto.Variacion.repite real m) E -
      Nexus.Cripto.Variacion.evento (Nexus.Cripto.Variacion.repite ideal m) E| ≤
        2 * (m : ℚ) * delta p S := by
  dsimp only
  have he := Nexus.Cripto.Variacion.evento_producto_cota
    (Nexus.Cripto.Variacion.producto (leyReducida p S hp hS) (leyReducida p S hp hS))
    (Nexus.Cripto.Variacion.producto (leyUniforme p hp) (leyUniforme p hp)) m E
  have ht := Nexus.Cripto.Variacion.producto_distancia (leyReducida p S hp hS)
    (leyUniforme p hp) (leyReducida p S hp hS) (leyUniforme p hp)
  rw [distancia_reduccion] at ht
  exact he.trans (by nlinarith [mul_le_mul_of_nonneg_left ht (show (0 : ℚ) ≤ m by positivity)])

end Nexus.ROM.Sesgo
