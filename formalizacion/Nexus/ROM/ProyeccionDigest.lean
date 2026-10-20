module

public import Nexus.Canal.ProgramaTG2
public import Nexus.ROM.Sesgo
public import Nexus.N06.Experimento
import Mathlib.Tactic

/-!
# El índice de los primeros ocho bytes de un digest uniforme

La distribución se cuenta sobre los 32 octetos completos del digest. Se
prueba que leer solo los primeros ocho bytes y reducir módulo 2^e tiene
fibras exactamente iguales para e≤64. La uniformidad corresponde al ROM
ideal, antes de excluir eventos excepcionales, no a SHA3 concreto.
-/

public section
namespace Nexus.ROM.ProyeccionDigest

set_option maxRecDepth 4096

open Nexus.Bytes Nexus.Merkle Nexus.N06
open scoped BigOperators

@[expose] def entero : Digest ≃ Fin (256 ^ 32) where
  toFun d := ⟨leerLE d.val, by simpa only [d.property] using leer_le_cota d.val⟩
  invFun x := ⟨codificarLE 32 x.val, codificar_le_longitud _ _⟩
  left_inv d := by
    apply Subtype.ext
    simpa only [d.property] using codificar_le_leer d.val
  right_inv x := Fin.ext (leer_le_codificar 32 x.val x.isLt)

theorem leer_append (a b : List Octeto) :
    leerLE (a ++ b) = leerLE a + 256 ^ a.length * leerLE b := by
  induction a with
  | nil => simp [leerLE]
  | cons x xs ih => simp only [List.cons_append, leerLE, List.length_cons, ih, pow_succ]; ring

theorem leer_digest_separa (d : Digest) :
    (entero d).val = leerLE (d.val.take 8) + 256 ^ 8 * leerLE (d.val.drop 8) := by
  change leerLE d.val = _
  conv_lhs => rw [← List.take_append_drop 8 d.val]
  rw [leer_append]
  simp only [List.length_take, d.property, show min 8 32 = 8 from rfl]

theorem indice_es_residuo (e : ℕ) (he : e ≤ 64) (d : Digest) :
    Nexus.Canal.ProgramaTG2.indice (2 ^ e) (by positivity) d =
      ⟨(entero d).val % 2 ^ e, Nat.mod_lt _ (by positivity)⟩ := by
  apply Fin.ext
  have hp : 2 ^ e ∣ 256 ^ 8 := by
    change 2 ^ e ∣ 2 ^ 64
    exact Nat.pow_dvd_pow 2 he
  change leerLE (d.val.take 8) % 2 ^ e = (entero d).val % 2 ^ e
  rw [leer_digest_separa, Nat.add_mod, Nat.mul_mod, Nat.mod_eq_zero_of_dvd hp, Nat.zero_mul,
    Nat.zero_mod, Nat.add_zero, Nat.mod_mod]

@[expose] def equivalenciaFibra (e : ℕ) (he : e ≤ 64) (j : Fin (2 ^ e)) :
    {d : Digest // Nexus.Canal.ProgramaTG2.indice (2 ^ e) (by positivity) d = j} ≃
      {x : Fin (256 ^ 32) // x.val % 2 ^ e = j.val} where
  toFun d := ⟨entero d.val, by
    have h := congrArg Fin.val d.property
    simpa only [indice_es_residuo e he] using h⟩
  invFun x := ⟨entero.symm x.val, by
    apply Fin.ext
    simpa only [indice_es_residuo e he, entero.apply_symm_apply] using x.property⟩
  left_inv d := Subtype.ext (entero.symm_apply_apply d.val)
  right_inv x := Subtype.ext (entero.apply_symm_apply x.val)

theorem fibras_iguales (e : ℕ) (he : e ≤ 64) (j : Fin (2 ^ e)) :
    Fintype.card {d : Digest // Nexus.Canal.ProgramaTG2.indice (2 ^ e) (by positivity) d = j} =
      2 ^ (256 - e) := by
  rw [Fintype.card_congr (equivalenciaFibra e he j)]
  have hs : (256 : ℕ) ^ 32 = 2 ^ e * 2 ^ (256 - e) := by
    calc
      (256 : ℕ) ^ 32 = 2 ^ (256 : ℕ) := by norm_num
      _ = 2 ^ e * 2 ^ (256 - e) := by rw [← pow_add, Nat.add_sub_of_le (by omega : e ≤ 256)]
  rw [Sesgo.cardinal_fibra _ _ (by positivity), Sesgo.cuenta, hs]
  simp

theorem cardinal_digest : Fintype.card Digest = 2 ^ 256 := by
  rw [Fintype.card_congr entero, Fintype.card_fin]
  norm_num

theorem masa_indice (e : ℕ) (he : e ≤ 64) (j : Fin (2 ^ e)) :
    (Fintype.card {d : Digest // Nexus.Canal.ProgramaTG2.indice (2 ^ e) (by positivity) d = j} : ℚ) /
      Fintype.card Digest = 1 / (2 ^ e : ℚ) := by
  rw [fibras_iguales e he, cardinal_digest]
  have hsum : 256 - e + e = 256 := by omega
  have hpow : (2 : ℚ) ^ 256 = 2 ^ (256 - e) * 2 ^ e := by rw [← pow_add, hsum]
  simp only [Nat.cast_pow, Nat.cast_ofNat]
  rw [hpow]
  field_simp

theorem promedio_indice (e : ℕ) (he : e ≤ 64) (f : Fin (2 ^ e) → ℚ) :
    promedio (fun d : Digest => f (Nexus.Canal.ProgramaTG2.indice (2 ^ e) (by positivity) d)) =
      promedio f := by
  classical
  let g := Nexus.Canal.ProgramaTG2.indice (2 ^ e) (by positivity)
  have hs : (∑ d : Digest, f (g d)) =
      ∑ j : Fin (2 ^ e), (Fintype.card {d : Digest // g d = j} : ℚ) * f j := by
    rw [← Fintype.sum_fiberwise' g f]
    simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
  unfold promedio
  rw [hs]
  simp_rw [show ∀ j, Fintype.card {d : Digest // g d = j} = 2 ^ (256 - e) from fibras_iguales e he]
  rw [← Finset.mul_sum, cardinal_digest, Fintype.card_fin]
  have hsum : 256 - e + e = 256 := by omega
  have hpow : (2 : ℚ) ^ 256 = 2 ^ (256 - e) * 2 ^ e := by rw [← pow_add, hsum]
  simp only [Nat.cast_pow, Nat.cast_ofNat]
  rw [hpow]
  field_simp

end Nexus.ROM.ProyeccionDigest
