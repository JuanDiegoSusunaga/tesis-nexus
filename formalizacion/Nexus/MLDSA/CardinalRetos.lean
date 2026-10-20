module

public import Nexus.MLDSA.Retos
public import Mathlib.Data.Finset.Powerset
import Mathlib.Tactic

/-!
# Cardinal exacto del alfabeto de retos

Un reto equivale a elegir t posiciones y un signo por posición elegida.
El conteo no identifica SampleInBall ni los bytes de un oráculo cuántico.
-/

public section
namespace Nexus.MLDSA.Retos.Conteo

open scoped BigOperators

abbrev Soportes (t : ℕ) := {S : Finset (Fin n) // S.card = t}
abbrev Eleccion (t : ℕ) := (S : Soportes t) × (↥S.val → Bool)

noncomputable instance (t : ℕ) : Fintype (Reto t) := Fintype.ofFinite _

@[expose] noncomputable def construir (t : ℕ) (e : Eleccion t) : Reto t := by
  classical
  refine ⟨desdeSoporte e.1.val (fun i => if h : i ∈ e.1.val then e.2 ⟨i, h⟩ else false), ?_⟩
  simpa only [e.1.property] using desde_soporte_es_reto e.1.val
    (fun i => if h : i ∈ e.1.val then e.2 ⟨i, h⟩ else false)

@[expose] noncomputable def extraer (t : ℕ) (w : Reto t) : Eleccion t := by
  classical
  exact ⟨⟨soporte w.val, w.property.2⟩, fun i => decide (centrado w.val i.val = -1)⟩

theorem construir_extraer (t : ℕ) (w : Reto t) : construir t (extraer t w) = w := by
  classical
  apply Subtype.ext
  apply centrado_determina
  intro i
  change centrado (desdeSoporte _ _) i = _
  rw [centrado_desde_soporte]
  simp only [extraer, soporte, Finset.mem_filter, Finset.mem_univ, true_and]
  rcases w.property.1 i with h | h | h <;> simp [h]

theorem signos_heq (t : ℕ) (S T : Soportes t) (h : S = T)
    (f : ↥S.val → Bool) (g : ↥T.val → Bool)
    (hf : ∀ i j, i.val = j.val → f i = g j) : HEq f g := by
  subst T
  apply heq_of_eq
  funext i
  exact hf i i rfl

theorem extraer_construir (t : ℕ) (e : Eleccion t) : extraer t (construir t e) = e := by
  classical
  rcases e with ⟨⟨S, hS⟩, signo⟩
  have hs : (extraer t (construir t ⟨⟨S, hS⟩, signo⟩)).1 = ⟨S, hS⟩ :=
    Subtype.ext (soporte_desde_soporte _ _)
  apply Sigma.ext hs
  apply signos_heq t _ _ hs
  intro i j hv
  change decide (centrado (desdeSoporte S _) i.val = -1) = signo j
  rw [hv]
  rw [centrado_desde_soporte]
  simp only [j.property, dite_true, ite_true]
  cases signo j <;> rfl

@[expose] noncomputable def equivalencia (t : ℕ) : Reto t ≃ Eleccion t where
  toFun := extraer t
  invFun := construir t
  left_inv := construir_extraer t
  right_inv := extraer_construir t

theorem cardinal_soportes (t : ℕ) : Fintype.card (Soportes t) = Nat.choose n t := by
  classical
  have he : Soportes t ≃ ↥((Finset.univ : Finset (Fin n)).powersetCard t) :=
    { toFun := fun S => ⟨S.val, Finset.mem_powersetCard.mpr ⟨Finset.subset_univ _, S.property⟩⟩
      invFun := fun S => ⟨S.val, (Finset.mem_powersetCard.mp S.property).2⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  rw [Fintype.card_congr he, Fintype.card_coe, Finset.card_powersetCard]
  simp

theorem cardinal_retos (t : ℕ) : Fintype.card (Reto t) = Nat.choose n t * 2 ^ t := by
  classical
  rw [Fintype.card_congr (equivalencia t), Fintype.card_sigma]
  have hc (S : Soportes t) : Fintype.card (↥S.val → Bool) = 2 ^ t := by
    rw [Fintype.card_fun, Fintype.card_bool, Fintype.card_coe, S.property]
  simp_rw [hc]
  rw [Finset.sum_const, Finset.card_univ, nsmul_eq_mul, cardinal_soportes]
  simp

theorem retos_no_vacios (t : ℕ) : Nonempty (Reto t) ↔ t ≤ n := by
  classical
  rw [← Fintype.card_pos_iff, cardinal_retos]
  constructor
  · intro h
    by_contra hn
    rw [Nat.choose_eq_zero_of_lt (by omega)] at h
    omega
  · intro h
    exact Nat.mul_pos (Nat.choose_pos h) (by positivity)

theorem fuera_de_dimension_vacio (t : ℕ) (ht : n < t) : Fintype.card (Reto t) = 0 := by
  rw [cardinal_retos, Nat.choose_eq_zero_of_lt ht, zero_mul]

end Nexus.MLDSA.Retos.Conteo
