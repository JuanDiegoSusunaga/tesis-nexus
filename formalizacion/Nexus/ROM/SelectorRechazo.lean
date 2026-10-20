module

public import Nexus.ROM.ColaSelector
public import Nexus.ROM.Sesgo
import Mathlib.Tactic

/-!
# Selector por rechazo de duplicados y corte finito

Se verifica la proyección a conjuntos del acumulador Vec: insertar una
repetición conserva el conjunto y se detiene al alcanzar el objetivo.
Se enlaza el fallo antes del corte con el evento de pocas distintas y con
la cola ya demostrada. La uniformidad de respuestas ROM sigue separada.
-/

public section
namespace Nexus.ROM.Selector

variable {A : Type} [DecidableEq A]

@[expose] def seleccionar (q : ℕ) (vistos : Finset A) : List A → Finset A
  | [] => vistos
  | x :: xs => if q ≤ vistos.card then vistos else seleccionar q (insert x vistos) xs

theorem cardinal_objetivo (q : ℕ) (vistos : Finset A) (xs : List A) (hv : vistos.card ≤ q) :
    (seleccionar q vistos xs).card = min q (vistos ∪ xs.toFinset).card := by
  induction xs generalizing vistos with
  | nil => simp [seleccionar, min_eq_right hv]
  | cons x xs ih =>
    by_cases hq : q ≤ vistos.card
    · have he : vistos.card = q := by omega
      have hc := Finset.card_le_card (Finset.subset_union_left (s₂ := (x :: xs).toFinset) :
        vistos ⊆ vistos ∪ (x :: xs).toFinset)
      rw [seleccionar, ite_eq_left hq]
      rw [he]
      exact (min_eq_left (by omega)).symm
    · have hins : (insert x vistos).card ≤ q :=
        (Finset.card_insert_le _ _).trans (by omega)
      rw [seleccionar, ite_eq_right hq, ih _ hins, List.toFinset_cons]
      congr 2
      ext a
      simp only [Finset.mem_union, Finset.mem_insert]
      tauto

theorem nunca_excede_objetivo (q : ℕ) (vistos : Finset A) (xs : List A) (hv : vistos.card ≤ q) :
    (seleccionar q vistos xs).card ≤ q := by rw [cardinal_objetivo q vistos xs hv]; exact min_le_left _ _

theorem sin_reemplazo (q : ℕ) (vistos : Finset A) (x : A) (xs : List A) (hx : x ∈ vistos) :
    seleccionar q vistos (x :: xs) = if q ≤ vistos.card then vistos else seleccionar q vistos xs := by
  simp only [seleccionar, Finset.insert_eq_of_mem hx]

theorem vacio_completa_iff (q : ℕ) (xs : List A) :
    (seleccionar q ∅ xs).card = q ↔ q ≤ xs.toFinset.card := by
  rw [cardinal_objetivo q ∅ xs (by simp), Finset.empty_union]
  omega

theorem vacio_incompleto_iff (q : ℕ) (xs : List A) :
    (seleccionar q ∅ xs).card < q ↔ xs.toFinset.card < q := by
  rw [cardinal_objetivo q ∅ xs (by simp), Finset.empty_union]
  omega

theorem equivariancia (q : ℕ) (vistos : Finset A) (xs : List A) (p : A ≃ A) :
    seleccionar q (vistos.image p) (xs.map p) = (seleccionar q vistos xs).image p := by
  induction xs generalizing vistos with
  | nil => rfl
  | cons x xs ih =>
    simp only [List.map_cons, seleccionar, Finset.card_image_of_injective _ p.injective]
    by_cases h : q ≤ vistos.card
    · simp only [h, ite_true]
    · simp only [h, ite_false, ← Finset.image_insert, ih]

theorem mascara_es_residuo (x e : ℕ) : x &&& (2 ^ e - 1) = x % 2 ^ e :=
  Nat.and_two_pow_sub_one_eq_mod x e

theorem fibras_indice (e w : ℕ) (he : e ≤ w) (j : Fin (2 ^ e)) :
    Fintype.card {x : Fin (2 ^ w) // x.val % 2 ^ e = j.val} = 2 ^ (w - e) := by
  have hs : 2 ^ w = 2 ^ e * 2 ^ (w - e) := by rw [← pow_add, Nat.add_sub_of_le he]
  rw [Sesgo.cardinal_fibra _ _ (by positivity), Sesgo.cuenta, hs]
  simp

theorem masa_indice_uniforme (e w : ℕ) (he : e ≤ w) (j : Fin (2 ^ e)) :
    Sesgo.masa (2 ^ e) (2 ^ w) j = 1 / (2 ^ e : ℚ) := by
  have hs : 2 ^ w = 2 ^ e * 2 ^ (w - e) := by rw [← pow_add, Nat.add_sub_of_le he]
  have hc := fibras_indice e w he j
  rw [Sesgo.cardinal_fibra _ _ (by positivity)] at hc
  unfold Sesgo.masa
  rw [hc, hs, Nat.cast_mul, Nat.cast_pow, Nat.cast_pow, Nat.cast_ofNat]
  field_simp

@[expose] noncomputable def probabilidadIncompleta (M R q : ℕ) : ℚ :=
  (Fintype.card {w : Fin R → Fin M // (seleccionar q ∅ (List.ofFn w)).card < q} : ℚ) / (M : ℚ) ^ R

theorem conjunto_ofFn {M R : ℕ} (w : Fin R → Fin M) :
    (List.ofFn w).toFinset = Finset.univ.image w := by
  ext x
  simp

theorem incompleta_es_cola (M R q : ℕ) :
    probabilidadIncompleta M R (q + 1) = probabilidadCola M R q := by
  classical
  have he : {w : Fin R → Fin M // (seleccionar (q + 1) ∅ (List.ofFn w)).card < q + 1} ≃
      PocasDistintas M R q :=
    { toFun := fun w => ⟨w.val, by
        have h := (vacio_incompleto_iff (q + 1) (List.ofFn w.val)).mp w.property
        rw [conjunto_ofFn] at h
        omega⟩
      invFun := fun w => ⟨w.val, (vacio_incompleto_iff (q + 1) (List.ofFn w.val)).mpr (by
        rw [conjunto_ofFn]
        exact Nat.lt_succ_iff.mpr w.property)⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  simp only [probabilidadIncompleta, probabilidadCola, Fintype.card_congr he]

theorem selector_corte_512 (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) :
    probabilidadIncompleta (4 * 2 ^ k) 512 40 < (1 : ℚ) / 2 ^ 300 := by
  rw [show 40 = 39 + 1 from rfl, incompleta_es_cola]
  exact (cola_selector_acotada _ _ _ (by positivity) (by
    have hp : 2 ^ 4 ≤ 2 ^ k := Nat.pow_le_pow_right (by decide) hk0
    norm_num at hp
    omega)).trans_lt (tau_corte_512 k hk0 hk1)

end Nexus.ROM.Selector
