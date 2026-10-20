module

public import Nexus.Merkle.Codificacion
public import Nexus.AIR.Interpolacion
import Mathlib.Tactic

public section
namespace Nexus.ROM.Raices

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks

/-- El puente legado solo lee ocho octetos y reduce módulo p. -/
@[expose] def puenteLegado (d : Digest) : Fp := (leerLE (d.val.take 8) : Fp)

@[expose] def raizCanonica (v : Fp) : Digest :=
  ⟨codificarLE 8 v.val ++ List.replicate 24 0,
    by simp only [List.length_append, codificar_le_longitud, List.length_replicate]⟩

theorem puente_raiz_canonica (v : Fp) : puenteLegado (raizCanonica v) = v := by
  have hv : v.val < 256 ^ 8 := v.val_lt.trans (by norm_num [p])
  have ht : ((raizCanonica v).val).take 8 = codificarLE 8 v.val :=
    List.take_left' (codificar_le_longitud _ _)
  rw [puenteLegado, ht, leer_le_codificar _ _ hv, ZMod.natCast_zmod_val]

theorem raiz_canonica_inyectiva : Function.Injective raizCanonica := by
  intro a b h
  simpa only [puente_raiz_canonica] using congrArg puenteLegado h

@[expose] def Canonica (d : Digest) : Prop :=
  leerLE (d.val.take 8) < p ∧ d.val.drop 8 = List.replicate 24 0

theorem raiz_canonica_valida (v : Fp) : Canonica (raizCanonica v) := by
  have ht : ((raizCanonica v).val).take 8 = codificarLE 8 v.val :=
    List.take_left' (codificar_le_longitud _ _)
  have hd : ((raizCanonica v).val).drop 8 = List.replicate 24 0 :=
    List.drop_left' (codificar_le_longitud _ _)
  exact ⟨by rw [ht, leer_le_codificar _ _ (v.val_lt.trans (by norm_num [p]))]; exact v.val_lt, hd⟩

theorem dominio_canonico_invertible (d : Digest) (hd : Canonica d) :
    raizCanonica (puenteLegado d) = d := by
  apply Subtype.ext
  change codificarLE 8 (puenteLegado d).val ++ List.replicate 24 0 = d.val
  rw [puenteLegado, ZMod.val_natCast_of_lt hd.1, ← hd.2]
  have ht : (d.val.take 8).length = 8 := by simp only [List.length_take, d.property]; decide
  have hc := codificar_le_leer (d.val.take 8)
  rw [ht] at hc
  rw [hc, List.take_append_drop]

theorem puente_inyectivo_en_dominio (a b : Digest) (ha : Canonica a) (hb : Canonica b)
    (h : puenteLegado a = puenteLegado b) : a = b := by
  rw [← dominio_canonico_invertible a ha, ← dominio_canonico_invertible b hb, h]

theorem cola_ignorada (prefijo : List Octeto) (hp : prefijo.length = 8)
    (a b : List Octeto) (ha : a.length = 24) (hb : b.length = 24) :
    puenteLegado ⟨prefijo ++ a, by simp [hp, ha]⟩ =
      puenteLegado ⟨prefijo ++ b, by simp [hp, hb]⟩ := by
  simp only [puenteLegado, List.take_left' hp]

@[expose] def codificaEntero (x : ℕ) : Digest :=
  ⟨codificarLE 8 x ++ List.replicate 24 0,
    by simp only [List.length_append, codificar_le_longitud, List.length_replicate]⟩

theorem alias_modular_concreto :
    codificaEntero 0 ≠ codificaEntero p ∧ puenteLegado (codificaEntero 0) = puenteLegado (codificaEntero p) := by
  constructor
  · intro h
    have hh := congrArg (fun d : Digest => leerLE (d.val.take 8)) h
    have ht (x : ℕ) : ((codificaEntero x).val).take 8 = codificarLE 8 x :=
      List.take_left' (codificar_le_longitud _ _)
    rw [ht, ht, leer_le_codificar _ _ (by norm_num), leer_le_codificar _ _ (by norm_num [p])] at hh
    norm_num [p] at hh
  · have ht (x : ℕ) : ((codificaEntero x).val).take 8 = codificarLE 8 x :=
      List.take_left' (codificar_le_longitud _ _)
    rw [puenteLegado, puenteLegado, ht, ht, leer_le_codificar _ _ (by norm_num),
      leer_le_codificar _ _ (by norm_num [p])]
    simp

theorem alias_indice (h n k : ℕ) : (n + k * 2 ^ h) % (2 ^ h) = n % (2 ^ h) := by
  simp only [Nat.add_mod, Nat.mul_mod_left, add_zero, Nat.mod_mod]

theorem alias_3_19 : 3 % (2 ^ 4) = 19 % (2 ^ 4) := by norm_num

/-- Las evaluaciones públicas de un polinomio de grado menor que T determinan sus filas. -/
theorem reconstruccion_por_aperturas {K : Type*} [Field K] (T : ℕ)
    (nodos : ℕ → K) (hn : Set.InjOn nodos (Finset.range T))
    (f : Polynomial K) (hf : f.degree < T) :
    Lagrange.interpolate (Finset.range T) nodos (fun i => f.eval (nodos i)) = f := by
  exact (Lagrange.eq_interpolate hn (by simpa only [Finset.card_range] using hf)).symm

end Nexus.ROM.Raices
