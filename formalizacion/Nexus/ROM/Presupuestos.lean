module

public import Nexus.Complejidad.Comunicacion
import Mathlib.Tactic

public section
namespace Nexus.ROM.Presupuestos

open scoped BigOperators

abbrev Digest := Fin 32 → Fin 256
abbrev Camino (h : ℕ) := Fin h → Digest

/-- Seis aperturas AIR y dos por capa en cada uno de los dos FRI. -/
structure Consulta (k : ℕ) where
  air : Fin 6 → Camino (k + 3)
  traza : (j : Fin k) → Fin 2 → Camino (k + 3 - j.val)
  composicion : (j : Fin (k + 1)) → Fin 2 → Camino (k + 3 - j.val)

@[expose] def rutas (k : ℕ) (c : Consulta k) : List (List Digest) :=
  (List.ofFn fun i => List.ofFn (c.air i)) ++
    ((List.ofFn fun j => List.ofFn fun i => List.ofFn (c.traza j i)).flatten) ++
    ((List.ofFn fun j => List.ofFn fun i => List.ofFn (c.composicion j i)).flatten)

/-- Cada ruta usa un hash de hoja y uno por hermano; no se deduplican consultas. -/
@[expose] def hashesRutas (rs : List (List Digest)) : ℕ :=
  (rs.map (fun r => 1 + r.length)).sum

@[expose] def caminosPerfil (k : ℕ) : ℕ :=
  40 * (6 * (k + 3) + 2 * Nexus.Complejidad.Comunicacion.sumaTG2 k)
@[expose] def hojasPerfil (k : ℕ) : ℕ := 40 * (6 + 2 * k + 2 * (k + 1))
@[expose] def etiquetasPerfil (k : ℕ) : ℕ := 1 + k + (k + 1) + caminosPerfil k
@[expose] def canalPerfil (k R : ℕ) : ℕ := 13 + 2 * (k + (k + 1)) + R
@[expose] def verificadorPerfil (k R : ℕ) : ℕ := caminosPerfil k + hojasPerfil k + canalPerfil k R
@[expose] def retosPerfil (k : ℕ) : ℕ := 3 + k + (k + 1)

theorem rutas_numero (k : ℕ) (c : Consulta k) : (rutas k c).length = 6 + 2 * k + 2 * (k + 1) := by
  simp only [rutas, List.length_append, List.length_flatten, List.map_ofFn, List.length_ofFn,
    Function.comp_apply, List.sum_ofFn, Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul, Nat.cast_id]
  ring

theorem hashes_rutas_numero (k : ℕ) (c : Consulta k) :
    hashesRutas (rutas k c) =
      6 + 2 * k + 2 * (k + 1) + 6 * (k + 3) + 2 * Nexus.Complejidad.Comunicacion.sumaTG2 k := by
  simp only [hashesRutas, rutas, List.map_append, List.sum_append, List.map_flatten,
    List.sum_flatten, List.map_ofFn, Function.comp_apply, List.length_ofFn, List.sum_ofFn,
    Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul, Nat.cast_id]
  simp_rw [mul_add, Finset.sum_add_distrib]
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul, Nat.cast_id]
  simp_rw [← Finset.mul_sum, Fin.sum_univ_eq_sum_range]
  unfold Nexus.Complejidad.Comunicacion.sumaTG2 Nexus.Complejidad.Comunicacion.caminos
  ring

theorem canal_menos_extracciones (k r R : ℕ) (h : r ≤ R) : canalPerfil k r ≤ canalPerfil k R := by
  unfold canalPerfil
  omega

theorem verificador_menos_extracciones (k r R : ℕ) (h : r ≤ R) :
    verificadorPerfil k r ≤ verificadorPerfil k R := by
  exact Nat.add_le_add_left (canal_menos_extracciones k r R h) _

theorem presupuesto_total (Q k R consultasAdversario consultasVerificador : ℕ)
    (ha : consultasAdversario ≤ Q) (hv : consultasVerificador ≤ verificadorPerfil k R) :
    consultasAdversario + consultasVerificador ≤ Q + verificadorPerfil k R := Nat.add_le_add ha hv

theorem tabla_presupuestos :
    verificadorPerfil 4 512 = 6943 ∧ etiquetasPerfil 4 = 5450 ∧ retosPerfil 4 = 12 ∧
      verificadorPerfil 12 512 = 24895 ∧ etiquetasPerfil 12 = 22106 ∧ retosPerfil 12 = 28 := by
  norm_num [verificadorPerfil, caminosPerfil, hojasPerfil, canalPerfil, etiquetasPerfil, retosPerfil,
    Nexus.Complejidad.Comunicacion.sumaTG2, Nexus.Complejidad.Comunicacion.caminos,
    Finset.sum_range_succ]

end Nexus.ROM.Presupuestos
