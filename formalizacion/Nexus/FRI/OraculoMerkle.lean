module

public import Nexus.Merkle.Codificacion
public import Nexus.Merkle.PruebasIndexadas
public import Nexus.FRI.Indices
import Mathlib.Tactic

/-!
# Del vector de hojas al oráculo sobre el dominio FRI

El índice binario de una hoja coincide con el exponente del punto de la
capa. La función se completa con cero fuera del dominio. La unicidad de
esa extensión evita depender de decisiones futuras o de valores externos.
Las aperturas aceptadas y registradas vinculan la función y el plegado.
-/

public section
namespace Nexus.Goldilocks

open Nexus.Bytes Nexus.Merkle

@[expose] noncomputable def oraculoDeVector (k j : ℕ)
    (vector : Fin (2 ^ (k + 3 - j)) → Fp2) (x : Fp2) : Fp2 := by
  classical
  exact if hx : x ∈ dominioCapa k j then
    vector ⟨indiceCapa k j x, (indice_capa_especificacion k j x hx).1⟩ else 0

@[expose] noncomputable def oraculoMerkle (k j : ℕ) (H : List Octeto → Digest)
    (registro : List (List Octeto)) (raiz : Digest) : Fp2 → Fp2 :=
  oraculoDeVector k j (vectorIndexado formatoBytes H registro (k + 3 - j) raiz)

theorem indice_capa_en_punto (k j i : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3)
    (hi : i < 2 ^ (k + 3 - j)) : indiceCapa k j (puntoCapa k j i) = i := by
  classical
  have hx : puntoCapa k j i ∈ dominioCapa k j :=
    Finset.mem_image.mpr ⟨i, Finset.mem_range.mpr hi, rfl⟩
  have hs := indice_capa_especificacion k j _ hx
  exact punto_capa_inyectivo k j hk hj (Finset.mem_range.mpr hs.1) (Finset.mem_range.mpr hi) hs.2

theorem oraculo_vector_en_punto (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3)
    (vector : Fin (2 ^ (k + 3 - j)) → Fp2) (i : Fin (2 ^ (k + 3 - j))) :
    oraculoDeVector k j vector (puntoCapa k j i.val) = vector i := by
  classical
  have hx : puntoCapa k j i.val ∈ dominioCapa k j :=
    Finset.mem_image.mpr ⟨i.val, Finset.mem_range.mpr i.isLt, rfl⟩
  simp only [oraculoDeVector, hx, dite_true, indice_capa_en_punto k j i.val hk hj i.isLt]

theorem oraculo_vector_fuera (k j : ℕ) (vector : Fin (2 ^ (k + 3 - j)) → Fp2)
    (x : Fp2) (hx : x ∉ dominioCapa k j) : oraculoDeVector k j vector x = 0 := by
  classical
  simp only [oraculoDeVector, hx, dite_false]

theorem oraculo_vector_inyectivo (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3) :
    Function.Injective (oraculoDeVector k j) := by
  intro v w he
  funext i
  have h := congrFun he (puntoCapa k j i.val)
  simpa only [oraculo_vector_en_punto k j hk hj] using h

theorem oraculo_vector_unico (k j : ℕ) (vector : Fin (2 ^ (k + 3 - j)) → Fp2)
    (u : Fp2 → Fp2)
    (hd : ∀ i : Fin (2 ^ (k + 3 - j)), u (puntoCapa k j i.val) = vector i)
    (hf : ∀ x ∉ dominioCapa k j, u x = 0) : u = oraculoDeVector k j vector := by
  classical
  funext x
  by_cases hx : x ∈ dominioCapa k j
  · have hs := indice_capa_especificacion k j x hx
    have he := hd ⟨indiceCapa k j x, hs.1⟩
    simpa only [hs.2, oraculoDeVector, hx, dite_true] using he
  · exact (hf x hx).trans (oraculo_vector_fuera k j vector x hx).symm

theorem oraculo_merkle_en_indice (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3)
    (H : List Octeto → Digest) (registro : List (List Octeto)) (raiz : Digest)
    (i : Fin (2 ^ (k + 3 - j))) :
    oraculoMerkle k j H registro raiz (puntoCapa k j i.val) =
      vectorIndexado formatoBytes H registro (k + 3 - j) raiz i :=
  oraculo_vector_en_punto k j hk hj _ i

theorem oraculos_merkle_iguales (k j : ℕ) (H G : List Octeto → Digest)
    (A B : List (List Octeto)) (raiz : Digest)
    (hv : vectorIndexado formatoBytes H A (k + 3 - j) raiz =
      vectorIndexado formatoBytes G B (k + 3 - j) raiz) :
    oraculoMerkle k j H A raiz = oraculoMerkle k j G B raiz :=
  congrArg (oraculoDeVector k j) hv

theorem oraculo_merkle_apertura (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3)
    (H : List Octeto → Digest) (registro : List (List Octeto)) (hc : SinColisiones H registro)
    (raiz : Digest) (i : ℕ) (hi : i < 2 ^ (k + 3 - j)) (v : Fp2) (hermanos : List Digest)
    (ha : VerificaIndice formatoBytes H raiz (k + 3 - j) i v hermanos)
    (hq : AperturaRegistrada formatoBytes H registro v (hermanosDesdeRaiz i hermanos)) :
    oraculoMerkle k j H registro raiz (puntoCapa k j i) = v :=
  (oraculo_merkle_en_indice k j hk hj H registro raiz ⟨i, hi⟩).trans
    (apertura_indexada_extraida formatoBytes H registro hc raiz (k + 3 - j) i hi v hermanos ha hq)

theorem plegado_de_pareja_abierta (k j a : ℕ) (hk : k ≤ 29) (hj : j < k + 3)
    (ha : a < 2 ^ (k + 3 - (j + 1))) (H : List Octeto → Digest) (registro : List (List Octeto))
    (hc : SinColisiones H registro) (raiz : Digest) (v w β : Fp2) (hv hw : List Digest)
    (av : VerificaIndice formatoBytes H raiz (k + 3 - j) a v hv)
    (aw : VerificaIndice formatoBytes H raiz (k + 3 - j) (a + 2 ^ (k + 3 - (j + 1))) w hw)
    (qv : AperturaRegistrada formatoBytes H registro v (hermanosDesdeRaiz a hv))
    (qw : AperturaRegistrada formatoBytes H registro w
      (hermanosDesdeRaiz (a + 2 ^ (k + 3 - (j + 1))) hw)) :
    Nexus.N04.par (oraculoMerkle k j H registro raiz) (representanteCapa k j)
        (puntoCapa k (j + 1) a) +
      β * Nexus.N04.impar (oraculoMerkle k j H registro raiz) (representanteCapa k j)
        (puntoCapa k (j + 1) a) =
      (v + w) / 2 + β * ((v - w) / 2) * (puntoCapa k j a)⁻¹ := by
  have ht := tamano_capa_siguiente k j hj
  have hleft : a < 2 ^ (k + 3 - j) := by omega
  have hright : a + 2 ^ (k + 3 - (j + 1)) < 2 ^ (k + 3 - j) := by omega
  rw [formula_plegado_indices k j a hk hj ha]
  rw [oraculo_merkle_apertura k j hk (by omega) H registro hc raiz a hleft v hv av qv,
    oraculo_merkle_apertura k j hk (by omega) H registro hc raiz _ hright w hw aw qw]
  ring

end Nexus.Goldilocks
