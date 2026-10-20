module

public import Mathlib.Data.Finset.Powerset
public import Mathlib.Data.Rat.Defs
import Mathlib.Tactic

/-!
# N05: componente combinatoria del muestreo sin reemplazo

No demuestra aún el lema B sobre el recorrido FRI. G es un conjunto de parejas
aceptantes dado; las muestras son subconjuntos uniformes de q parejas distintas.
-/

public section
namespace Nexus.N05

variable {α : Type*} [DecidableEq α]

/-- Las muestras de L enteramente contenidas en G son los q-subconjuntos de G. -/
theorem muestras_buenas (L G : Finset α) (q : ℕ) (hG : G ⊆ L) :
    (L.powersetCard q).filter (fun S => S ⊆ G) = G.powersetCard q := by
  ext S
  simp only [Finset.mem_filter, Finset.mem_powersetCard]
  constructor
  · rintro ⟨⟨_, hq⟩, hSG⟩
    exact ⟨hSG, hq⟩
  · rintro ⟨hSG, hq⟩
    exact ⟨⟨hSG.trans hG, hq⟩, hSG⟩

/-- Probabilidad exacta de omitir todas las parejas malas en una muestra uniforme. -/
theorem probabilidad_omision (L G : Finset α) (q : ℕ) (hG : G ⊆ L) :
    (((L.powersetCard q).filter (fun S => S ⊆ G)).card : ℚ) /
        (L.powersetCard q).card =
      (Nat.choose G.card q : ℚ) / Nat.choose L.card q := by
  rw [muestras_buenas L G q hG]
  simp only [Finset.card_powersetCard]

/-- Si hay al menos m parejas malas, la omisión queda acotada por H(M,q,m/M). -/
theorem cota_omision (L G : Finset α) (q m : ℕ) (hG : G ⊆ L)
    (hmalas : G.card + m ≤ L.card) :
    (((L.powersetCard q).filter (fun S => S ⊆ G)).card : ℚ) /
        (L.powersetCard q).card ≤
      (Nat.choose (L.card - m) q : ℚ) / Nat.choose L.card q := by
  rw [probabilidad_omision L G q hG]
  have hle : G.card ≤ L.card - m := by omega
  have hchoose : (Nat.choose G.card q : ℚ) ≤ Nat.choose (L.card - m) q := by
    exact_mod_cast Nat.choose_le_choose q hle
  exact div_le_div_of_nonneg_right hchoose (by positivity)

omit [DecidableEq α] in
/-- Con q≤M el espacio de muestras no está vacío, como exige la interpretación uniforme. -/
theorem muestras_no_vacias (L : Finset α) (q : ℕ) (hq : q ≤ L.card) :
    0 < (L.powersetCard q).card := by
  simpa only [Finset.card_powersetCard] using Nat.choose_pos hq

end Nexus.N05
