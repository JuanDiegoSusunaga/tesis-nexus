module

public import Nexus.FRI.Dominios
public import Nexus.N05.Cotas
public import Nexus.N06.Experimento
import Mathlib.Tactic

/-!
# Una consulta uniforme de parejas distintas

El predicado de aceptación se fija antes de la muestra. La probabilidad
es el cociente exacto de muestras aceptantes; puede usarse para varios
controles sobre la misma muestra, sin multiplicar sus probabilidades.
-/

public section
namespace Nexus.N06

variable {α : Type*}

@[expose] noncomputable def probabilidadConsulta (L : Finset α) (q : ℕ)
    (P : Finset α → Prop) : ℚ := by
  classical
  exact ((L.powersetCard q).filter P).card / ((L.powersetCard q).card : ℚ)

theorem consulta_monotona (L : Finset α) (q : ℕ) (P Q : Finset α → Prop)
    (h : ∀ S ∈ L.powersetCard q, P S → Q S) :
    probabilidadConsulta L q P ≤ probabilidadConsulta L q Q := by
  classical
  apply div_le_div_of_nonneg_right _ (by positivity)
  exact_mod_cast Finset.card_le_card (show (L.powersetCard q).filter P ⊆
      (L.powersetCard q).filter Q from by
    intro S hS
    have hs := Finset.mem_filter.mp hS
    exact Finset.mem_filter.mpr ⟨hs.1, h S hs.1 hs.2⟩)

theorem consulta_no_negativa (L : Finset α) (q : ℕ) (P : Finset α → Prop) :
    0 ≤ probabilidadConsulta L q P := by
  unfold probabilidadConsulta
  positivity

theorem consulta_le_uno (L : Finset α) (q : ℕ) (P : Finset α → Prop) (hq : q ≤ L.card) :
    probabilidadConsulta L q P ≤ 1 := by
  classical
  have hpos : (0 : ℚ) < (L.powersetCard q).card := by
    exact_mod_cast Nexus.N05.muestras_no_vacias L q hq
  apply (div_le_one hpos).mpr
  exact_mod_cast Finset.card_filter_le (L.powersetCard q) P

variable {K : Type*} [Field K]

@[expose] def ConsultaParejas (r : K → K) (P : K → Prop) (S : Finset K) : Prop :=
  ∀ y ∈ S, P (r y) ∧ P (-r y)

@[expose] noncomputable def parejasBuenas (L : Finset K) (r : K → K) (P : K → Prop) :
    Finset K := by
  classical
  exact L.filter (fun y => P (r y) ∧ P (-r y))

@[expose] noncomputable def fraccionFallos (D : Finset K) (P : K → Prop) : ℚ := by
  classical
  exact (D.filter (fun x => ¬ P x)).card / (D.card : ℚ)

theorem pertenencia_parejas_buenas (L : Finset K) (r : K → K) (P : K → Prop) (y : K) :
    y ∈ parejasBuenas L r P ↔ y ∈ L ∧ P (r y) ∧ P (-r y) := by
  classical
  simp only [parejasBuenas, Finset.mem_filter]

theorem parejas_buenas_subconjunto (L : Finset K) (r : K → K) (P : K → Prop) :
    parejasBuenas L r P ⊆ L := by
  intro y hy
  exact ((pertenencia_parejas_buenas L r P y).mp hy).1

theorem pertenencia_elevar (S : Finset K) (r : K → K) (x : K) :
    x ∈ Nexus.FRI.elevar r S ↔
      (∃ y ∈ S, r y = x) ∨ (∃ y ∈ S, -r y = x) := by
  classical
  simp only [Nexus.FRI.elevar, Finset.mem_union, Finset.mem_image]

theorem consulta_parejas_iff (r : K → K) (P : K → Prop) (S : Finset K) :
    ConsultaParejas r P S ↔ ∀ x ∈ Nexus.FRI.elevar r S, P x := by
  constructor
  · intro h x hx
    rcases (pertenencia_elevar S r x).mp hx with ⟨y, hy, rfl⟩ | ⟨y, hy, rfl⟩
    · exact (h y hy).1
    · exact (h y hy).2
  · intro h y hy
    exact ⟨h (r y) ((pertenencia_elevar S r _).mpr (Or.inl ⟨y, hy, rfl⟩)),
      h (-r y) ((pertenencia_elevar S r _).mpr (Or.inr ⟨y, hy, rfl⟩))⟩

theorem consulta_buenas_iff (L S : Finset K) (r : K → K) (P : K → Prop)
    (hS : S ⊆ L) : ConsultaParejas r P S ↔ S ⊆ parejasBuenas L r P := by
  classical
  constructor
  · intro h y hy
    exact Finset.mem_filter.mpr ⟨hS hy, h y hy⟩
  · intro h y hy
    exact (Finset.mem_filter.mp (h hy)).2

theorem elevar_cardinal_le (S : Finset K) (r : K → K) :
    (Nexus.FRI.elevar r S).card ≤ 2 * S.card := by
  classical
  exact (Finset.card_union_le _ _).trans (by
    have h1 := Finset.card_image_le (s := S) (f := r)
    have h2 := Finset.card_image_le (s := S) (f := fun y => -r y)
    omega)

/-- Cada pareja que falla contiene como máximo dos puntos que fallan. -/
theorem fallos_predicado_le_doble [DecidableEq K] (L : Finset K) (r : K → K)
    (P : K → Prop) [DecidablePred P] :
    ((Nexus.FRI.elevar r L).filter (fun x => ¬ P x)).card ≤
      2 * (L \ parejasBuenas L r P).card := by
  classical
  have hsub : (Nexus.FRI.elevar r L).filter (fun x => ¬ P x) ⊆
      Nexus.FRI.elevar r (L \ parejasBuenas L r P) := by
    intro x hx
    have hs := Finset.mem_filter.mp hx
    rcases (pertenencia_elevar L r x).mp hs.1 with ⟨y, hy, heq⟩ | ⟨y, hy, heq⟩
    · apply (pertenencia_elevar _ r x).mpr
      refine Or.inl ⟨y, Finset.mem_sdiff.mpr ⟨hy, ?_⟩, heq⟩
      intro hgood
      exact hs.2 (heq ▸ ((pertenencia_parejas_buenas L r P y).mp hgood).2.1)
    · apply (pertenencia_elevar _ r x).mpr
      refine Or.inr ⟨y, Finset.mem_sdiff.mpr ⟨hy, ?_⟩, heq⟩
      intro hgood
      exact hs.2 (heq ▸ ((pertenencia_parejas_buenas L r P y).mp hgood).2.2)
  exact (Finset.card_le_card hsub).trans (elevar_cardinal_le _ r)

theorem probabilidad_consulta_parejas [DecidableEq K] (L : Finset K) (r : K → K)
    (P : K → Prop) (q : ℕ) :
    probabilidadConsulta L q (ConsultaParejas r P) =
      ((((L.powersetCard q).filter (fun S => S ⊆ parejasBuenas L r P)).card : ℚ) /
        (L.powersetCard q).card) := by
  classical
  unfold probabilidadConsulta
  congr 2
  apply congrArg Finset.card
  apply Finset.filter_congr
  intro S hS
  exact consulta_buenas_iff L S r P (Finset.mem_powersetCard.mp hS).1

/-- Cota local por el número real de puntos rechazados en las dos mitades del coset. -/
theorem muestreo_predicado [DecidableEq K] (L : Finset K) (r : K → K) (P : K → Prop)
    (q : ℕ) (θ : ℚ) (hL : 0 < L.card)
    (hr : ∀ y ∈ L, (r y) ^ 2 = y) (hn : ∀ y ∈ L, r y ≠ 0) (h2 : (2 : K) ≠ 0)
    (hd : θ ≤ fraccionFallos (Nexus.FRI.elevar r L) P) :
    probabilidadConsulta L q (ConsultaParejas r P) ≤ Nexus.N05.H L.card q θ := by
  classical
  rw [probabilidad_consulta_parejas]
  have hsub := parejas_buenas_subconjunto L r P
  apply Nexus.N05.cota_omision_radio L (parejasBuenas L r P) q θ hsub
  rw [fraccionFallos, Nexus.FRI.cardinal_elevar L r hr hn h2] at hd
  have hbad := fallos_predicado_le_doble L r P
  have hcast : (((Nexus.FRI.elevar r L).filter (fun x => ¬ P x)).card : ℚ) ≤
      2 * (L \ parejasBuenas L r P).card := by exact_mod_cast hbad
  have hmul := (le_div_iff₀ (by positivity : (0 : ℚ) < (2 * L.card : ℕ))).mp hd
  rw [Finset.card_sdiff_of_subset hsub] at hcast
  rw [Nat.cast_sub (Finset.card_le_card hsub)] at hcast ⊢
  push_cast at hmul
  nlinarith

end Nexus.N06
