module

public import Nexus.N06.Prefijos
public import Nexus.FRI.Consulta
import Mathlib.Tactic

/-!
# Congruencia sobre la historia efectivamente recorrida

Se comparan monitores solo en los prefijos usados, y oráculos FRI solo
en las capas consultadas. No se impone igualdad fuera de esa historia.
-/

public section
namespace Nexus.N06

theorem marca_historia_congruente {K : Type*} [Zero K] [DecidableEq K]
    (E F : ℕ → List K → Finset K) (i n : ℕ) (h : List K) (b : Bool) (xs : Retos K n)
    (he : ∀ j < n, E (i + j) (h ++ Nexus.FRI.historia (reto xs) j) =
      F (i + j) (h ++ Nexus.FRI.historia (reto xs) j)) :
    recorrerMarca E (fun _ h x => h ++ [x]) i n h b xs =
      recorrerMarca F (fun _ h x => h ++ [x]) i n h b xs := by
  induction n generalizing i h b with
  | zero => rfl
  | succ n ih =>
    rcases xs with ⟨x, rest⟩
    have h0 : E i h = F i h := by
      simpa only [Nat.add_zero, Nexus.FRI.historia, List.append_nil] using he 0 (by omega)
    simp only [recorrerMarca, h0]
    apply ih
    intro j hj
    simpa only [historia_retos_cons, List.append_assoc, Nat.add_assoc, Nat.add_comm 1 j] using
      he (j + 1) (by omega)

end Nexus.N06

namespace Nexus.FRI

theorem acepta_oraculos_congruentes {K : Type*} [Field K] {m : ℕ}
    (t : Torre K m) (u v : ℕ → K → K) (β : Fin m → K) (A : Finset K) (c : K)
    (hu : ∀ j ≤ m, u j = v j) : Acepta t u β A c ↔ Acepta t v β A c := by
  constructor
  · rintro ⟨hs, hf⟩
    constructor
    · intro j y hy
      simpa only [hu (j + 1) (by omega), hu j (by omega)] using hs j y hy
    · intro y hy
      simpa only [hu m (le_refl _)] using hf y hy
  · rintro ⟨hs, hf⟩
    constructor
    · intro j y hy
      simpa only [hu (j + 1) (by omega), hu j (by omega)] using hs j y hy
    · intro y hy
      simpa only [hu m (le_refl _)] using hf y hy

end Nexus.FRI
