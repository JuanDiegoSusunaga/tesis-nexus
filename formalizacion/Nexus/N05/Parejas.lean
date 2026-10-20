module

public import Nexus.N05.Cotas
public import Mathlib.Data.Finset.Prod
import Mathlib.Tactic

/-!
# De discrepancias puntuales a parejas malas

Se representa una pareja por (i,false),(i,true). El resultado vale para
cualquier enumeración de dos puntos por pareja; la enumeración concreta de
los cosets y las aperturas Merkle sigue siendo una obligación distinta.
-/

public section
namespace Nexus.N05

variable {ι V : Type*} [DecidableEq ι] [DecidableEq V]

@[expose] def parejasMalas (L : Finset ι) (u v : ι × Bool → V) : Finset ι :=
  L.filter (fun i => u (i, false) ≠ v (i, false) ∨ u (i, true) ≠ v (i, true))

@[expose] def discrepancias (L : Finset ι) (u v : ι × Bool → V) : Finset (ι × Bool) :=
  (L ×ˢ Finset.univ).filter (fun x => u x ≠ v x)

omit [DecidableEq ι] in
/-- Una pareja contiene a lo sumo dos discrepancias. -/
theorem discrepancias_le_doble (L : Finset ι) (u v : ι × Bool → V) :
    (discrepancias L u v).card ≤ 2 * (parejasMalas L u v).card := by
  have hsub : discrepancias L u v ⊆ parejasMalas L u v ×ˢ Finset.univ := by
    rintro ⟨i, b⟩ hx
    obtain ⟨hi, hne⟩ := Finset.mem_filter.mp hx
    have hL := (Finset.mem_product.mp hi).1
    apply Finset.mem_product.mpr
    refine ⟨Finset.mem_filter.mpr ⟨hL, ?_⟩, Finset.mem_univ b⟩
    cases b with
    | false => exact Or.inl hne
    | true => exact Or.inr hne
  simpa only [Finset.card_product, Finset.card_univ, Fintype.card_bool, mul_comm]
    using Finset.card_le_card hsub

omit [DecidableEq ι] in
/-- Distancia puntual al menos θ implica al menos ceil(θ*M) parejas malas. -/
theorem techo_parejas_malas (L : Finset ι) (u v : ι × Bool → V) (θ : ℚ)
    (hL : 0 < L.card)
    (hd : θ ≤ (discrepancias L u v).card / (2 * (L.card : ℚ))) :
    ⌈θ * (L.card : ℚ)⌉₊ ≤ (parejasMalas L u v).card := by
  have he : ((discrepancias L u v).card : ℚ) ≤ 2 * (parejasMalas L u v).card := by
    exact_mod_cast discrepancias_le_doble L u v
  have hden : (0 : ℚ) < 2 * (L.card : ℚ) := by positivity
  have hmul := (le_div_iff₀ hden).mp hd
  apply Nat.ceil_le.mpr
  nlinarith

/-- Las consultas que no tocan parejas malas quedan acotadas por H(M,q,θ). -/
theorem omision_parejas (L : Finset ι) (u v : ι × Bool → V) (q : ℕ) (θ : ℚ)
    (hL : 0 < L.card)
    (hd : θ ≤ (discrepancias L u v).card / (2 * (L.card : ℚ))) :
    (((L.powersetCard q).filter (fun S => S ⊆ L \ parejasMalas L u v)).card : ℚ) /
        (L.powersetCard q).card ≤ H L.card q θ := by
  have hb : parejasMalas L u v ⊆ L := Finset.filter_subset _ _
  have hc := Finset.card_sdiff_add_card_eq_card hb
  exact cota_omision L (L \ parejasMalas L u v) q _ Finset.sdiff_subset
    (by have ht := techo_parejas_malas L u v θ hL hd; omega)

/-- Cota exponencial para la misma consulta uniforme distinta. -/
theorem omision_parejas_le_potencia (L : Finset ι) (u v : ι × Bool → V)
    (q : ℕ) (θ : ℚ) (hL : 0 < L.card) (hq : q ≤ L.card)
    (hθ : 0 ≤ θ) (hθ1 : θ ≤ 1)
    (hd : θ ≤ (discrepancias L u v).card / (2 * (L.card : ℚ))) :
    (((L.powersetCard q).filter (fun S => S ⊆ L \ parejasMalas L u v)).card : ℚ) /
        (L.powersetCard q).card ≤ (1 - θ) ^ q :=
  (omision_parejas L u v q θ hL hd).trans (H_le_potencia _ q θ hL hq hθ hθ1)

end Nexus.N05
