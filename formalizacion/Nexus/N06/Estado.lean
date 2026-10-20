module

public import Nexus.N06.Transcripcion
public import Nexus.N06.Consulta
import Mathlib.Tactic

/-!
# Marca excepcional absorbente y cambio de estado por reto

Los mensajes del probador conservan la marca. Un reto nuevo puede activarla
al pertenecer al conjunto excepcional fijado con el estado anterior.
-/

public section
namespace Nexus.N06

@[expose] def actualizarMarca (b : Bool) (P : Prop) [Decidable P] : Bool := b || decide P

theorem marca_absorbente (P : Prop) [Decidable P] : actualizarMarca true P = true := by
  simp only [actualizarMarca, Bool.true_or]

theorem marca_cero_iff (b : Bool) (P : Prop) [Decidable P] :
    actualizarMarca b P = false ↔ b = false ∧ ¬ P := by
  simp [actualizarMarca]

variable {K S : Type*} [DecidableEq K]

@[expose] def recorrerMarca (E : ℕ → S → Finset K) (paso : ℕ → S → K → S) :
    (i n : ℕ) → S → Bool → Retos K n → Bool
  | _, 0, _, b, _ => b
  | i, n + 1, s, b, xs => recorrerMarca E paso (i + 1) n (paso i s xs.1)
      (actualizarMarca b (xs.1 ∈ E i s)) xs.2

theorem recorrer_marca_escape (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (i n : ℕ) (s : S) (b : Bool) (xs : Retos K n) :
    recorrerMarca E paso i n s b xs = actualizarMarca b (Escapa E paso i n s xs) := by
  induction n generalizing i s b with
  | zero => simp [recorrerMarca, Escapa, actualizarMarca]
  | succ n ih =>
    rw [recorrerMarca, ih]
    by_cases hx : xs.1 ∈ E i s <;>
      by_cases ht : Escapa E paso (i + 1) n (paso i s xs.1) xs.2 <;>
        simp [actualizarMarca, Escapa, hx, ht]

theorem recorrer_marca_cero (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (i n : ℕ) (s : S) (b : Bool) (xs : Retos K n) :
    recorrerMarca E paso i n s b xs = false ↔ b = false ∧ ¬ Escapa E paso i n s xs := by
  rw [recorrer_marca_escape, marca_cero_iff]

theorem recorrer_marca_absorbente (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (i n : ℕ) (s : S) (xs : Retos K n) :
    recorrerMarca E paso i n s true xs = true := by
  rw [recorrer_marca_escape, marca_absorbente]

theorem recorrer_marca_vacia (paso : ℕ → S → K → S)
    (i n : ℕ) (s : S) (b : Bool) (xs : Retos K n) :
    recorrerMarca (fun _ _ => ∅) paso i n s b xs = b := by
  induction n generalizing i s b with
  | zero => rfl
  | succ n ih =>
    simpa only [recorrerMarca, actualizarMarca, Finset.notMem_empty, decide_false,
      Bool.or_false] using ih (i + 1) (paso i s xs.1) b xs.2

variable [Fintype K]

/-- Probabilidad de una transición nueva de cero a uno, no de permanecer en uno. -/
@[expose] noncomputable def probabilidadCambio (b : Bool) (E : Finset K) : ℚ :=
  promedio (fun x => if b = false ∧ actualizarMarca b (x ∈ E) = true then 1 else 0)

theorem cambio_por_conjunto (b : Bool) (E : Finset K) :
    probabilidadCambio b E ≤ (E.card : ℚ) / Fintype.card K := by
  cases b with
  | false => simp [probabilidadCambio, actualizarMarca, promedio_indicador]
  | true => simp [probabilidadCambio, promedio]; positivity

theorem cambio_marca_absorbida (E : Finset K) : probabilidadCambio true E = 0 := by
  simp [probabilidadCambio, promedio]

end Nexus.N06
