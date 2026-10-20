module

public import Nexus.Complejidad.NTT
public import Nexus.MLDSA.Parametros
import Mathlib.Tactic

public section
namespace Nexus.Complejidad.Comunicacion

open Filter Asymptotics
open scoped BigOperators

/-- Caminos Merkle individuales, sin deduplicación entre consultas o capas. -/
@[expose] def caminos (altura capas : ℕ) : ℕ := (Finset.range capas).sum (fun j => altura - j)

@[expose] def sumaTG2 (k : ℕ) : ℕ := caminos (k + 3) k + caminos (k + 3) (k + 1)

@[expose] def consultaTG2 (k : ℕ) : ℕ :=
  120 + 192 * (k + 3) + 48 * (k + (k + 1)) + 64 * sumaTG2 k

@[expose] def bytesTG2 (q k : ℕ) : ℕ := 126 + 32 * (k + (k + 1)) + q * consultaTG2 k

theorem caminos_cota (h l : ℕ) : caminos h l ≤ l * h := by
  unfold caminos
  calc
    ((Finset.range l).sum (fun j => h - j)) ≤ ∑ _ ∈ Finset.range l, h :=
      Finset.sum_le_sum (fun _ _ => Nat.sub_le _ _)
    _ = _ := by simp

theorem suma_tg2_cota (k : ℕ) : sumaTG2 k ≤ (2 * k + 1) * (k + 3) := by
  have h1 := caminos_cota (k + 3) k
  have h2 := caminos_cota (k + 3) (k + 1)
  unfold sumaTG2
  nlinarith

theorem consulta_tg2_cuadratica (k : ℕ) : consultaTG2 k ≤ 300 * (k + 3) ^ 2 := by
  have h := suma_tg2_cota k
  unfold consultaTG2
  nlinarith

theorem bytes_tg2_cota (q k : ℕ) (hq : 1 ≤ q) : bytesTG2 q k ≤ 400 * q * (k + 3) ^ 2 := by
  have h := Nat.mul_le_mul_left q (consulta_tg2_cuadratica k)
  have hh : 126 + 32 * (k + (k + 1)) ≤ 100 * (k + 3) ^ 2 := by nlinarith
  have hq' := Nat.mul_le_mul_right (100 * (k + 3) ^ 2) hq
  unfold bytesTG2
  nlinarith

theorem bytes_tg2_es_O (q : ℕ) (hq : 1 ≤ q) :
    (fun k : ℕ => (bytesTG2 q k : ℝ)) =O[atTop]
      (fun k => (q : ℝ) * Real.logb 2 ((2 : ℝ) ^ (k + 3)) ^ 2) := by
  refine Asymptotics.IsBigO.of_bound 400 (Eventually.of_forall ?_)
  intro k
  rw [Nexus.Complejidad.log_tamano]
  rw [Real.norm_eq_abs, abs_of_nonneg (Nat.cast_nonneg _), Real.norm_eq_abs,
    abs_of_nonneg (by positivity)]
  have h : (bytesTG2 q k : ℝ) ≤ 400 * (q : ℝ) * ((k : ℝ) + 3) ^ 2 := by
    exact_mod_cast bytes_tg2_cota q k hq
  simpa only [mul_assoc, Nat.cast_add, Nat.cast_ofNat] using h

theorem tabla_bytes_tg2 :
    bytesTG2 40 4 = 196574 ∧ bytesTG2 40 6 = 306782 ∧
      bytesTG2 40 8 = 437470 ∧ bytesTG2 40 12 = 760286 := by
  norm_num [bytesTG2, consultaTG2, sumaTG2, caminos, Finset.sum_range_succ]

theorem tabla_lde : 8 * (8 * (16 : ℕ)) = 1024 ∧ 8 * (8 * (64 : ℕ)) = 4096 ∧
    8 * (8 * (256 : ℕ)) = 16384 ∧ 8 * (8 * (4096 : ℕ)) = 262144 := by norm_num

/-- Conteo por coeficientes y anchos declarados; no es un teorema del codec Rust. -/
@[expose] def bitsPublica (cabecera k n ancho : ℕ) : ℕ := cabecera + k * n * ancho
@[expose] def bitsFirma (cabecera k r n ancho : ℕ) : ℕ := cabecera + (k + r) * n * ancho

theorem publica_cota (cabecera k n ancho : ℕ) (h : cabecera ≤ k * n * ancho) :
    bitsPublica cabecera k n ancho ≤ 2 * (k * n * ancho) := by unfold bitsPublica; omega

theorem firma_cota (cabecera k r n ancho : ℕ) (h : cabecera ≤ (k + r) * n * ancho) :
    bitsFirma cabecera k r n ancho ≤ 2 * ((k + r) * n * ancho) := by unfold bitsFirma; omega

end Nexus.Complejidad.Comunicacion
