module

public import Nexus.N06.Compartida
import Mathlib.Tactic

/-!
# Del muestreo compartido al cardinal de todas las parejas aceptantes

La cota de una sola consulta controla el conjunto completo. Así se evita
suponer su cardinal al aplicar más tarde el selector real sin reemplazo.
-/

public section
namespace Nexus.Goldilocks.CardinalCompartida

open Nexus.N06

@[expose] noncomputable def aceptantes {α : Type*} (L : Finset α) (P : Finset α → Prop) : Finset α := by
  classical
  exact L.filter (fun x => P {x})

theorem probabilidad_unitaria {α : Type*} (L : Finset α) (P : Finset α → Prop) :
    probabilidadConsulta L 1 P = ((aceptantes L P).card : ℚ) / L.card := by
  classical
  unfold probabilidadConsulta aceptantes
  rw [Finset.powersetCard_one, Finset.filter_map, Finset.card_map, Finset.card_map]
  rfl

@[expose] noncomputable def parejas (k : ℕ) (hk : k ≤ 29) (s o : Fp) (h : PrefijoConsulta) : Finset Fp2 := by
  classical
  exact (dominioCapa k 1).filter (fun y => AceptaCompartida k hk s o h {y})

theorem cardinal_seguro (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (s o : Fp) (h : PrefijoConsulta) (hs : PrefijoSeguro k hk s o h) :
    8 * (parejas k hk s o h).card ≤ 7 * (4 * 2 ^ k) := by
  classical
  have hq : 1 ≤ 4 * 2 ^ k := by
    have : 0 < 4 * 2 ^ k := by positivity
    omega
  have hc := (consulta_compartida_perfil k hk0 hk s o h hs 1 hq).trans
    (Nexus.N05.H_le_potencia (4 * 2 ^ k) 1 (1 / 8) (by positivity) hq (by norm_num) (by norm_num))
  rw [probabilidad_unitaria] at hc
  change ((parejas k hk s o h).card : ℚ) / (dominioCapa k 1).card ≤ (1 - 1 / 8 : ℚ) ^ 1 at hc
  have hD : (dominioCapa k 1).card = 4 * 2 ^ k :=
    parejas_iniciales_torre k k hk (Nat.le_succ k)
  rw [hD] at hc
  norm_num only [pow_one] at hc
  have hd : (0 : ℚ) < (4 * 2 ^ k : ℕ) := by positivity
  have hm := (div_le_iff₀ hd).mp hc
  have hn : (8 : ℚ) * (parejas k hk s o h).card ≤ 7 * (4 * 2 ^ k : ℕ) := by linarith
  exact_mod_cast hn

theorem cardinal_subconjunto (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (s o : Fp) (h : PrefijoConsulta) (hs : PrefijoSeguro k hk s o h)
    (S : Finset Fp2) (hS : S ⊆ dominioCapa k 1)
    (ha : ∀ y ∈ S, AceptaCompartida k hk s o h {y}) :
    8 * S.card ≤ 7 * (4 * 2 ^ k) := by
  classical
  have hsub : S ⊆ parejas k hk s o h := by
    intro y hy
    exact Finset.mem_filter.mpr ⟨hS hy, ha y hy⟩
  exact (Nat.mul_le_mul_left 8 (Finset.card_le_card hsub)).trans
    (cardinal_seguro k hk0 hk s o h hs)

end Nexus.Goldilocks.CardinalCompartida
