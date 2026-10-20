module

public import Nexus.FRI.Adaptativo
public import Nexus.N06.Consulta
import Mathlib.Tactic

/-!
# Aceptación de una muestra FRI, desde sus recorridos individuales

Se construye el conjunto de parejas que pasan todas las capas y la constante
final. No se recibe su cardinal ni la aceptación de su unión como premisa.
-/

public section
namespace Nexus.FRI

open Nexus.N06
variable {K : Type*} [Field K] {m : ℕ}

@[expose] noncomputable def imagenPotencias (A : Finset K) (j : ℕ) : Finset K := by
  classical
  exact A.image (fun x => x ^ (2 ^ j))

theorem recorrido_imagen (A : Finset K) (j : ℕ) :
    recorrido A j = imagenPotencias A j := by
  classical
  induction j with
  | zero => simp [recorrido, imagenPotencias]
  | succ j ih =>
    rw [recorrido, ih]
    simp only [cuadrados, imagenPotencias, Finset.image_image]
    congr 1
    funext x
    change (x ^ (2 ^ j)) ^ 2 = x ^ (2 ^ (j + 1))
    rw [← pow_mul, pow_succ]

theorem recorrido_mono {A B : Finset K} (h : A ⊆ B) (j : ℕ) :
    recorrido A j ⊆ recorrido B j := by
  classical
  rw [recorrido_imagen, recorrido_imagen, imagenPotencias, imagenPotencias]
  exact Finset.image_subset_image h

theorem recorrido_parejas (S : Finset K) (r : K → K) (j : ℕ) (x : K) :
    x ∈ recorrido (elevar r S) j ↔ ∃ y ∈ S, x ∈ recorrido (elevar r {y}) j := by
  classical
  constructor
  · intro hx
    rw [recorrido_imagen, imagenPotencias] at hx
    obtain ⟨z, hz, heq⟩ := Finset.mem_image.mp hx
    rcases (pertenencia_elevar S r z).mp hz with ⟨y, hy, hr⟩ | ⟨y, hy, hr⟩
    · refine ⟨y, hy, ?_⟩
      rw [recorrido_imagen, imagenPotencias]
      exact Finset.mem_image.mpr ⟨z, (pertenencia_elevar {y} r z).mpr
        (Or.inl ⟨y, Finset.mem_singleton_self y, hr⟩), heq⟩
    · refine ⟨y, hy, ?_⟩
      rw [recorrido_imagen, imagenPotencias]
      exact Finset.mem_image.mpr ⟨z, (pertenencia_elevar {y} r z).mpr
        (Or.inr ⟨y, Finset.mem_singleton_self y, hr⟩), heq⟩
  · rintro ⟨y, hy, hx⟩
    exact recorrido_mono (elevar_mono r (Finset.singleton_subset_iff.mpr hy)) j hx

theorem acepta_mono (t : Torre K m) (u : ℕ → K → K) (β : Fin m → K)
    (A B : Finset K) (c : K) (hAB : A ⊆ B) (h : Acepta t u β B c) :
    Acepta t u β A c := by
  constructor
  · intro j y hy
    exact h.1 j y (recorrido_mono hAB (j + 1) hy)
  · intro y hy
    exact h.2 y (recorrido_mono hAB m hy)

theorem acepta_parejas_iff (t : Torre K m) (u : ℕ → K → K) (β : Fin m → K)
    (S : Finset K) (c : K) :
    Acepta t u β (elevar (t.raiz 0) S) c ↔
      ∀ y ∈ S, Acepta t u β (elevar (t.raiz 0) {y}) c := by
  classical
  constructor
  · intro h y hy
    exact acepta_mono t u β _ _ c (elevar_mono _ (Finset.singleton_subset_iff.mpr hy)) h
  · intro h
    constructor
    · intro j x hx
      obtain ⟨y, hy, hxy⟩ := (recorrido_parejas S (t.raiz 0) (j + 1) x).mp hx
      exact (h y hy).1 j x hxy
    · intro x hx
      obtain ⟨y, hy, hxy⟩ := (recorrido_parejas S (t.raiz 0) m x).mp hx
      exact (h y hy).2 x hxy

@[expose] noncomputable def parejasAceptantes (t : Torre K m) (u : ℕ → K → K)
    (β : Fin m → K) (c : K) : Finset K := by
  classical
  exact (t.dominio 1).filter (fun y => Acepta t u β (elevar (t.raiz 0) {y}) c)

theorem parejas_aceptantes_acepta (t : Torre K m) (u : ℕ → K → K) (β : Fin m → K) (c : K) :
    Acepta t u β (elevar (t.raiz 0) (parejasAceptantes t u β c)) c := by
  classical
  apply (acepta_parejas_iff t u β _ c).mpr
  intro y hy
  exact (Finset.mem_filter.mp hy).2

theorem consulta_fri_iff (t : Torre K m) (u : ℕ → K → K) (β : Fin m → K)
    (S : Finset K) (c : K) (hS : S ⊆ t.dominio 1) :
    Acepta t u β (elevar (t.raiz 0) S) c ↔ S ⊆ parejasAceptantes t u β c := by
  classical
  rw [acepta_parejas_iff]
  constructor
  · intro h y hy
    exact Finset.mem_filter.mpr ⟨hS hy, h y hy⟩
  · intro h y hy
    exact (Finset.mem_filter.mp (h hy)).2

/-- La probabilidad se refiere a la muestra aceptada, no a un conjunto G dado. -/
theorem muestreo_consulta_fri [DecidableEq K] (t : Torre K m) (hm : 0 < m)
    (estrategia : ℕ → List K → K → K) (β : ℕ → K)
    (θ : ℚ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * (θ : ℝ)) * (t.dominio (j + 1)).card)
    (hβ : ∀ j : Fin m, β j ∉ excepciones t θ (by exact_mod_cast hθ) h2 hmargin j
      (estrategia j (historia β j)))
    (hfar : Lejano t (fun j => estrategia j (historia β j)) θ)
    (c : K) (q : ℕ) (hq : q ≤ (t.dominio 1).card) :
    probabilidadConsulta (t.dominio 1) q (fun S =>
      Acepta t (fun j => estrategia j (historia β j)) (fun j => β j) (elevar (t.raiz 0) S) c) ≤
        Nexus.N05.H (t.dominio 1).card q θ := by
  classical
  let u := fun j => estrategia j (historia β j)
  let G := parejasAceptantes t u (fun j => β j) c
  have hG : G ⊆ t.dominio 1 := Finset.filter_subset _ _
  have hacc := parejas_aceptantes_acepta t u (fun j => β j) c
  have hfilter : ((t.dominio 1).powersetCard q).filter
      (fun S => Acepta t u (fun j => β j) (elevar (t.raiz 0) S) c) =
        ((t.dominio 1).powersetCard q).filter (fun S => S ⊆ G) := by
    apply Finset.filter_congr
    intro S hS
    exact consulta_fri_iff t u (fun j => β j) S c (Finset.mem_powersetCard.mp hS).1
  rw [probabilidadConsulta, hfilter]
  exact muestreo_adaptativo t hm estrategia β θ hθ h2 hmargin hβ G c hG hacc hfar q hq

end Nexus.FRI
