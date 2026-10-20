module

public import Nexus.Distancia
import Mathlib.Tactic

/-!
# Selección matemática del candidato al fijar un oráculo

La selección recibe el dominio, el oráculo, el grado y el radio. No recibe
retos AIR, capas FRI ni consultas posteriores. Puede devolver ninguno.
La unicidad se usa al especializarla al perfil de la tesis.
-/

public section
namespace Nexus.N06

open Polynomial
variable {K : Type*} [Field K]

@[expose] def Proximo (L : Finset K) (u : K → K) (d : ℕ) (δ : ℚ)
    (f : Polynomial K) : Prop := f.natDegree < d ∧ Nexus.distancia L u f.eval ≤ δ

@[expose] noncomputable def candidato (L : Finset K) (u : K → K) (d : ℕ) (δ : ℚ) :
    Option (Polynomial K) := by
  classical
  exact if h : ∃ f, Proximo L u d δ f then some (Classical.choose h) else none

theorem candidato_ninguno_iff (L : Finset K) (u : K → K) (d : ℕ) (δ : ℚ) :
    candidato L u d δ = none ↔
      ∀ f : Polynomial K, f.natDegree < d → δ < Nexus.distancia L u f.eval := by
  classical
  rw [candidato]
  split_ifs with h
  · simp only [false_iff]
    obtain ⟨f, hf, hu⟩ := h
    intro hfar
    exact (not_lt_of_ge hu) (hfar f hf)
  · simp only [true_iff]
    intro f hf
    exact lt_of_not_ge (fun hu => h ⟨f, hf, hu⟩)

theorem candidato_propiedad (L : Finset K) (u : K → K) (d : ℕ) (δ : ℚ)
    (f : Polynomial K) (h : candidato L u d δ = some f) : Proximo L u d δ f := by
  classical
  rw [candidato] at h
  split_ifs at h with hex
  · have heq : Classical.choose hex = f := Option.some.inj h
    exact heq ▸ Classical.choose_spec hex

theorem candidato_existe (L : Finset K) (u : K → K) (d : ℕ) (δ : ℚ)
    (hex : ∃ f, Proximo L u d δ f) :
    ∃ f, candidato L u d δ = some f ∧ Proximo L u d δ f := by
  classical
  refine ⟨Classical.choose hex, ?_, Classical.choose_spec hex⟩
  simp only [candidato, hex, dite_eq_left]

theorem candidato_unico (L : Finset K) (u : K → K) (d : ℕ) (δ : ℚ)
    (hunico : ∀ f g, Proximo L u d δ f → Proximo L u d δ g → f = g)
    (f : Polynomial K) (hf : Proximo L u d δ f) : candidato L u d δ = some f := by
  obtain ⟨g, hg, hgp⟩ := candidato_existe L u d δ ⟨f, hf⟩
  exact hg.trans (congrArg some (hunico g f hgp hf))

omit [Field K] in
theorem distancia_depende_dominio (L : Finset K) (u v w : K → K)
    (huv : ∀ x ∈ L, u x = v x) : Nexus.distancia L u w = Nexus.distancia L v w := by
  classical
  have heq : L.filter (fun x => u x ≠ w x) = L.filter (fun x => v x ≠ w x) := by
    ext x
    simp only [Finset.mem_filter]
    by_cases hx : x ∈ L
    · simp only [hx, huv x hx]
    · simp only [hx, false_and]
  simp only [Nexus.distancia, Nexus.errores, heq]

/-- Cambiar valores fuera del dominio no cambia la elección del candidato. -/
theorem candidato_depende_dominio (L : Finset K) (u v : K → K) (d : ℕ) (δ : ℚ)
    (huv : ∀ x ∈ L, u x = v x) : candidato L u d δ = candidato L v d δ := by
  classical
  have hp : Proximo L u d δ = Proximo L v d δ := by
    funext f
    rw [Proximo, Proximo, distancia_depende_dominio L u v f.eval huv]
  simp only [candidato, hp]

end Nexus.N06
