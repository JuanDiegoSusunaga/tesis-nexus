module

public import Nexus.N06.Experimento
public import Nexus.N01.Solucion
public import Mathlib.Data.Finset.Max
import Mathlib.Tactic

/-!
# Ronda crítica AIR y cancelación secuencial

Los residuos están fijados antes de sortear los coeficientes. Se elige el
último residuo no nulo, sin recibir ninguno de los retos. El estado es la
suma acumulada; solo en esa ronda se vigila un conjunto de a lo sumo un reto.
-/

public section
namespace Nexus.N06

open Polynomial
open scoped BigOperators
variable {K : Type*} [Field K]

@[expose] noncomputable def soporteResiduos (R : ℕ → Polynomial K) (n : ℕ) : Finset ℕ := by
  classical
  exact (Finset.range n).filter (fun i => R i ≠ 0)

theorem soporte_no_vacio (R : ℕ → Polynomial K) (n : ℕ)
    (hn : ∃ i < n, R i ≠ 0) : (soporteResiduos R n).Nonempty := by
  classical
  obtain ⟨i, hi, hR⟩ := hn
  exact ⟨i, Finset.mem_filter.mpr ⟨Finset.mem_range.mpr hi, hR⟩⟩

@[expose] noncomputable def rondaCritica (R : ℕ → Polynomial K) (n : ℕ)
    (hn : ∃ i < n, R i ≠ 0) : ℕ := (soporteResiduos R n).max' (soporte_no_vacio R n hn)

theorem ronda_critica_propiedades (R : ℕ → Polynomial K) (n : ℕ)
    (hn : ∃ i < n, R i ≠ 0) :
    rondaCritica R n hn < n ∧ R (rondaCritica R n hn) ≠ 0 ∧
      ∀ i, rondaCritica R n hn < i → i < n → R i = 0 := by
  classical
  have hmem := Finset.max'_mem (soporteResiduos R n) (soporte_no_vacio R n hn)
  have hs := Finset.mem_filter.mp hmem
  refine ⟨Finset.mem_range.mp hs.1, hs.2, ?_⟩
  intro i hi hin
  by_contra hR
  have hle := Finset.le_max' (soporteResiduos R n) i
    (Finset.mem_filter.mpr ⟨Finset.mem_range.mpr hin, hR⟩)
  exact (not_le_of_gt hi) hle

@[expose] noncomputable def sumaRetos (R : ℕ → Polynomial K) :
    (i n : ℕ) → Retos K n → Polynomial K
  | _, 0, _ => 0
  | i, n + 1, xs => xs.1 • R i + sumaRetos R (i + 1) n xs.2

theorem suma_retos_cero (R : ℕ → Polynomial K) (i n : ℕ) (xs : Retos K n)
    (hR : ∀ j, i ≤ j → j < i + n → R j = 0) : sumaRetos R i n xs = 0 := by
  induction n generalizing i with
  | zero => rfl
  | succ n ih =>
    rw [sumaRetos, hR i (by omega) (by omega), smul_zero, zero_add]
    exact ih (i + 1) xs.2 (by intro j hj hjn; exact hR j (by omega) (by omega))

@[expose] noncomputable def pasoAIR (R : ℕ → Polynomial K) (i : ℕ)
    (s : Polynomial K) (x : K) : Polynomial K := s + x • R i

variable [Fintype K] [DecidableEq K]

@[expose] noncomputable def cancelantesRonda (r s : Polynomial K) : Finset K := by
  classical
  exact Finset.univ.filter (fun x => x • r + s = 0)

theorem cancelantes_ronda_cardinal (r s : Polynomial K) (hr : r ≠ 0) :
    (cancelantesRonda r s).card ≤ 1 := by
  classical
  apply Finset.card_le_one.mpr
  intro a ha b hb
  exact Nexus.N01.coeficiente_unico r s hr a b
    (Finset.mem_filter.mp ha).2 (Finset.mem_filter.mp hb).2

theorem probabilidad_ronda_critica (r s : Polynomial K) (hr : r ≠ 0) :
    promedio (fun x => if x ∈ cancelantesRonda r s then (1 : ℚ) else 0) ≤
      1 / (Fintype.card K : ℚ) := by
  rw [promedio_indicador]
  exact div_le_div_of_nonneg_right (by exact_mod_cast cancelantes_ronda_cardinal r s hr)
    (by positivity)

/-- Ninguna otra ronda modifica el estado de escape. -/
@[expose] noncomputable def excepcionesAIR (R : ℕ → Polynomial K) (j i : ℕ)
    (s : Polynomial K) : Finset K := if i = j then cancelantesRonda (R j) s else ∅

theorem escape_despues_critica (R : ℕ → Polynomial K) (j i n : ℕ)
    (hi : j < i) (s : Polynomial K) (xs : Retos K n) :
    ¬ Escapa (excepcionesAIR R j) (pasoAIR R) i n s xs := by
  classical
  induction n generalizing i s with
  | zero => exact not_false
  | succ n ih =>
    have hne : i ≠ j := by omega
    simpa only [Escapa, excepcionesAIR, hne, reduceIte, Finset.notMem_empty,
      false_or] using ih (i + 1) (by omega) (pasoAIR R i s xs.1) xs.2

/-- La única excepción es la cancelación total, porque todos los residuos posteriores son cero. -/
theorem escape_iff_cancelacion (R : ℕ → Polynomial K) (j i n : ℕ)
    (hantes : i ≤ j) (hdentro : j < i + n)
    (hR : ∀ l, j < l → l < i + n → R l = 0) (s : Polynomial K) (xs : Retos K n) :
    Escapa (excepcionesAIR R j) (pasoAIR R) i n s xs ↔ s + sumaRetos R i n xs = 0 := by
  classical
  induction n generalizing i s with
  | zero => omega
  | succ n ih =>
    by_cases hij : i = j
    · subst i
      have hno := escape_despues_critica R j (j + 1) n (by omega)
        (pasoAIR R j s xs.1) xs.2
      have hz := suma_retos_cero R (j + 1) n xs.2
        (by intro l hl hln; exact hR l (by omega) (by omega))
      simp only [Escapa, excepcionesAIR, ite_eq_left, cancelantesRonda, Finset.mem_filter,
        Finset.mem_univ, true_and, hno, or_false, sumaRetos, hz, add_zero]
      rw [add_comm s]
    · have htail := ih (i + 1) (by omega) (by omega)
        (by intro l hl hln; exact hR l hl (by omega)) (pasoAIR R i s xs.1) xs.2
      simpa only [Escapa, excepcionesAIR, hij, reduceIte, Finset.notMem_empty,
        false_or, pasoAIR, sumaRetos, add_assoc] using htail

@[expose] noncomputable def probabilidadAIR (R : ℕ → Polynomial K) (j n : ℕ) : ℚ :=
  riesgo (excepcionesAIR R j) (pasoAIR R) (fun _ => 0) 0 n 0

theorem probabilidad_air_es_media (R : ℕ → Polynomial K) (j n : ℕ) (hj : j < n)
    (hR : ∀ i, j < i → i < n → R i = 0) :
    probabilidadAIR R j n = promedio (fun xs : Retos K n =>
      if sumaRetos R 0 n xs = 0 then (1 : ℚ) else 0) := by
  classical
  rw [probabilidadAIR, riesgo_es_promedio]
  congr 1
  funext xs
  rw [valor_escape]
  simp only [escape_iff_cancelacion R j 0 n (by omega) (by omega)
    (by simpa only [Nat.zero_add] using hR), zero_add]

theorem cota_cancelacion_secuencial (R : ℕ → Polynomial K) (j n : ℕ)
    (hj : j < n) (hR : R j ≠ 0) :
    probabilidadAIR R j n ≤ 1 / (Fintype.card K : ℚ) := by
  let B : ℕ → ℕ := fun i => if i = j then 1 else 0
  have hE : ∀ i s, (excepcionesAIR R j i s).card ≤ B i := by
    intro i s
    by_cases hi : i = j
    · simpa only [excepcionesAIR, hi, ite_eq_left, B] using cancelantes_ronda_cardinal (R j) s hR
    · simp only [excepcionesAIR, hi, reduceIte, Finset.card_empty, B, le_refl]
  have hbound := cota_riesgo (excepcionesAIR R j) (pasoAIR R) (fun _ => 0)
    B 0 (by rfl) (by intro _; rfl) hE 0 n 0
  have hsum : (∑ i ∈ Finset.range n, (B i : ℚ)) = 1 := by
    simp [B, hj]
  simpa only [probabilidadAIR, Nat.zero_add, zero_add, hsum] using hbound

/-- Cota de la cancelación total al elegir la ronda únicamente a partir de los residuos. -/
theorem cota_critica_elegida (R : ℕ → Polynomial K) (n : ℕ)
    (hn : ∃ i < n, R i ≠ 0) :
    promedio (fun xs : Retos K n => if sumaRetos R 0 n xs = 0 then (1 : ℚ) else 0) ≤
      1 / (Fintype.card K : ℚ) := by
  have hs := ronda_critica_propiedades R n hn
  rw [← probabilidad_air_es_media R (rondaCritica R n hn) n hs.1 hs.2.2]
  exact cota_cancelacion_secuencial R _ n hs.1 hs.2.1

end Nexus.N06
