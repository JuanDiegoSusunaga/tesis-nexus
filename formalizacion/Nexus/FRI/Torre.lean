module

public import Nexus.FRI.Dominios
public import Nexus.Distancia
import Mathlib.Tactic

/-!
# Propagación determinista del acuerdo por una torre FRI finita

Los dominios, raíces y grados deben satisfacer las relaciones indicadas en
Torre. No se asume la proximidad del oráculo inicial ni la conclusión del
lema B. Los retos excepcionales se construyen mediante el lema A.
-/

public section
namespace Nexus.FRI

open Polynomial Nexus.N04
variable {K : Type*} [Field K] {m : ℕ}

/-- Datos y relaciones geométricas de una torre de m plegados. -/
structure Torre (K : Type*) [Field K] (m : ℕ) where
  dominio : ℕ → Finset K
  raiz : ℕ → K → K
  grado : ℕ → ℕ
  cuadrado : ∀ j < m, ∀ y ∈ dominio (j + 1), (raiz j y) ^ 2 = y
  noCero : ∀ j < m, ∀ y ∈ dominio (j + 1), raiz j y ≠ 0
  enlace : ∀ j < m, dominio j = elevar (raiz j) (dominio (j + 1))
  grados : ∀ j < m, grado j = 2 * grado (j + 1)
  grado_final : grado m = 1
  final_no_vacio : 0 < (dominio m).card

@[expose] noncomputable def recorrido (A : Finset K) : ℕ → Finset K
  | 0 => A
  | j + 1 => cuadrados (recorrido A j)

theorem dominios_cuadrados (t : Torre K m) (j : ℕ) (hj : j < m) :
    cuadrados (t.dominio j) = t.dominio (j + 1) := by
  rw [t.enlace j hj, cuadrados_elevar _ _ (t.cuadrado j hj)]

theorem grados_positivos (t : Torre K m) (j : ℕ) (hj : j ≤ m) : 0 < t.grado j := by
  apply Nat.decreasingInduction (motive := fun j _ => 0 < t.grado j) _ _ hj
  · intro i hi hnext
    rw [t.grados i hi]
    omega
  · rw [t.grado_final]
    decide

theorem dominios_positivos (t : Torre K m) (h2 : (2 : K) ≠ 0)
    (j : ℕ) (hj : j ≤ m) : 0 < (t.dominio j).card := by
  apply Nat.decreasingInduction (motive := fun j _ => 0 < (t.dominio j).card) _ _ hj
  · intro i hi hnext
    rw [t.enlace i hi, cardinal_elevar _ _ (t.cuadrado i hi) (t.noCero i hi) h2]
    omega
  · exact t.final_no_vacio

theorem recorrido_subconjunto (t : Torre K m) (A : Finset K)
    (hA : A ⊆ t.dominio 0) (j : ℕ) (hj : j ≤ m) :
    recorrido A j ⊆ t.dominio j := by
  classical
  induction j with
  | zero => exact hA
  | succ j ih =>
    have hprev := ih (by omega)
    rw [← dominios_cuadrados t j (by omega)]
    exact Finset.image_subset_image hprev

theorem densidad_recorrido (t : Torre K m) (h2 : (2 : K) ≠ 0)
    (A : Finset K) (hA : A ⊆ t.dominio 0) (ρ : ℝ)
    (hd : ρ * (t.dominio 0).card ≤ (A.card : ℝ)) (j : ℕ) (hj : j ≤ m) :
    ρ * (t.dominio j).card ≤ ((recorrido A j).card : ℝ) := by
  induction j with
  | zero => exact hd
  | succ j ih =>
    have hprev := ih (by omega)
    rw [t.enlace j (by omega)] at hprev
    exact densidad_cuadrados (recorrido A j) (t.dominio (j + 1)) (t.raiz j) ρ
      (recorrido_subconjunto t A hA (j + 1) hj)
      (t.cuadrado j (by omega)) (t.noCero j (by omega)) h2 hprev

/-- Control de una capa, uniforme en el conjunto y polinomio de acuerdo. -/
@[expose] def Control (t : Torre K m) (u : ℕ → K → K) (θ : ℝ)
    (j : Fin m) (E : Finset K) : Prop :=
  ∀ β, β ∉ E → ∀ W : Finset K, W ⊆ t.dominio j →
    (1 - θ) * (t.dominio (j + 1)).card ≤ ((cuadrados W).card : ℝ) →
    ∀ Q : Polynomial K, Q.natDegree < t.grado (j + 1) →
      Sobre (cuadrados W) (fun y => par (u j) (t.raiz j) y + β * impar (u j) (t.raiz j) y) Q →
      ∃ P : Polynomial K, P.natDegree < t.grado j ∧ Sobre W (u j) P

/-- El conjunto excepcional se obtiene del lema A y no recibe el reto β. -/
theorem control_capa (t : Torre K m) (u : ℕ → K → K) (θ : ℝ)
    (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0) (j : Fin m)
    (hmargin : (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card) :
    ∃ E : Finset K, E.card ≤ (t.dominio (j + 1)).card ∧ Control t u θ j E := by
  classical
  obtain ⟨E, hE, hgood⟩ := recuperacion_capa (t.dominio (j + 1))
    (u j) (t.raiz j) (t.grado (j + 1)) θ
    (dominios_positivos t h2 (j + 1) (by omega))
    (grados_positivos t (j + 1) (by omega)) hθ hmargin h2
    (t.noCero j j.isLt) (t.cuadrado j j.isLt)
  refine ⟨E, hE, ?_⟩
  intro β hβ W hW hd Q hQ ha
  have hS : cuadrados W ⊆ t.dominio (j + 1) := by
    rw [← dominios_cuadrados t j j.isLt]
    exact Finset.image_subset_image hW
  obtain ⟨P, hP, hPS⟩ := hgood β hβ (cuadrados W) Q hS hd hQ ha
  refine ⟨P, by simpa only [t.grados j j.isLt] using hP, ?_⟩
  intro x hx
  have hx2 : x ^ 2 ∈ cuadrados W := Finset.mem_image.mpr ⟨x, hx, rfl⟩
  have hsq : x ^ 2 = (t.raiz j (x ^ 2)) ^ 2 := (t.cuadrado j j.isLt _ (hS hx2)).symm
  rcases raices_opuestas x (t.raiz j (x ^ 2)) hsq with heq | heq
  · exact (congrArg (u j) heq).trans ((hPS (x ^ 2) hx2).1.trans
      (congrArg P.eval heq.symm))
  · exact (congrArg (u j) heq).trans ((hPS (x ^ 2) hx2).2.trans
      (congrArg P.eval heq.symm))

/-- Remonta todas las capas desde la constante final, sin postular proximidad inicial. -/
theorem recuperar_torre (t : Torre K m) (u : ℕ → K → K) (θ : ℝ)
    (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card) :
    ∃ E : Fin m → Finset K,
      (∀ j, (E j).card ≤ (t.dominio (j + 1)).card) ∧
      ∀ β : Fin m → K, (∀ j, β j ∉ E j) →
      ∀ (A : Finset K) (c : K), A ⊆ t.dominio 0 →
        (1 - θ) * (t.dominio 0).card ≤ (A.card : ℝ) →
        (∀ j : Fin m, ∀ y ∈ recorrido A (j + 1),
          u (j + 1) y = par (u j) (t.raiz j) y + β j * impar (u j) (t.raiz j) y) →
        (∀ y ∈ recorrido A m, u m y = c) →
        ∃ P : Polynomial K, P.natDegree < t.grado 0 ∧ Sobre A (u 0) P := by
  classical
  have hlocal := fun j : Fin m => control_capa t u θ hθ h2 j (hmargin j)
  choose E hE hcontrol using hlocal
  refine ⟨E, hE, ?_⟩
  intro β hβ A c hA hd hsteps hfinal
  have hrecover : ∀ j (hj : j ≤ m), ∃ P : Polynomial K,
      P.natDegree < t.grado j ∧ Sobre (recorrido A j) (u j) P := by
    intro j hj
    apply Nat.decreasingInduction (motive := fun j _ => ∃ P : Polynomial K,
      P.natDegree < t.grado j ∧ Sobre (recorrido A j) (u j) P) _ _ hj
    · intro i hi hnext
      obtain ⟨Q, hQ, hQS⟩ := hnext
      let index : Fin m := ⟨i, hi⟩
      apply hcontrol index (β index) (hβ index) (recorrido A i)
        (recorrido_subconjunto t A hA i (by omega))
        (densidad_recorrido t h2 A hA (1 - θ) hd (i + 1) (by omega)) Q hQ
      intro y hy
      exact (hsteps index y hy).symm.trans (hQS y hy)
    · refine ⟨C c, ?_, ?_⟩
      · rw [t.grado_final, natDegree_C]
        decide
      · intro y hy
        simpa only [eval_C] using hfinal y hy
  exact hrecover 0 (Nat.zero_le _)

/-- El acuerdo sobre A limita las discrepancias en el dominio completo. -/
theorem distancia_desde_acuerdo (D A : Finset K) (u : K → K) (P : Polynomial K)
    (hA : A ⊆ D) (hD : 0 < D.card) (θ : ℝ)
    (hd : (1 - θ) * D.card ≤ (A.card : ℝ)) (ha : Sobre A u P) :
    (Nexus.distancia D u P.eval : ℝ) ≤ θ := by
  classical
  have hsub : D.filter (fun x => u x ≠ P.eval x) ⊆ D \ A := by
    intro x hx
    obtain ⟨hxD, hne⟩ := Finset.mem_filter.mp hx
    exact Finset.mem_sdiff.mpr ⟨hxD, fun hxA => hne (ha x hxA)⟩
  have hc : (Nexus.errores D u P.eval : ℝ) ≤ D.card - A.card := by
    have h := Finset.card_le_card hsub
    rw [Finset.card_sdiff_of_subset hA] at h
    have hnat : Nexus.errores D u P.eval ≤ D.card - A.card := h
    have hcast : (Nexus.errores D u P.eval : ℝ) ≤ ((D.card - A.card : ℕ) : ℝ) := by
      exact_mod_cast hnat
    simpa only [Nat.cast_sub (Finset.card_le_card hA)] using hcast
  have hpos : (0 : ℝ) < D.card := by exact_mod_cast hD
  rw [Nexus.distancia]
  push_cast
  apply (div_le_iff₀ hpos).mpr
  nlinarith

/-- Lema B determinista: lejos del código obliga a una fracción de recorridos rechazados. -/
theorem lema_B (t : Torre K m) (u : ℕ → K → K) (θ : ℝ)
    (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card) :
    ∃ E : Fin m → Finset K,
      (∀ j, (E j).card ≤ (t.dominio (j + 1)).card) ∧
      ∀ β : Fin m → K, (∀ j, β j ∉ E j) →
      ∀ (A : Finset K) (c : K), A ⊆ t.dominio 0 →
        (∀ j : Fin m, ∀ y ∈ recorrido A (j + 1),
          u (j + 1) y = par (u j) (t.raiz j) y + β j * impar (u j) (t.raiz j) y) →
        (∀ y ∈ recorrido A m, u m y = c) →
        (∀ P : Polynomial K, P.natDegree < t.grado 0 →
          θ < (Nexus.distancia (t.dominio 0) (u 0) P.eval : ℝ)) →
        (A.card : ℝ) ≤ (1 - θ) * (t.dominio 0).card := by
  obtain ⟨E, hE, hrecover⟩ := recuperar_torre t u θ hθ h2 hmargin
  refine ⟨E, hE, ?_⟩
  intro β hβ A c hA hsteps hfinal hfar
  by_contra hlarge
  have hd : (1 - θ) * (t.dominio 0).card ≤ (A.card : ℝ) := le_of_lt (lt_of_not_ge hlarge)
  obtain ⟨P, hP, ha⟩ := hrecover β hβ A c hA hd hsteps hfinal
  have hsmall := distancia_desde_acuerdo (t.dominio 0) A (u 0) P hA
    (dominios_positivos t h2 0 (Nat.zero_le _)) θ hd ha
  exact (not_lt_of_ge hsmall) (hfar P hP)

end Nexus.FRI
