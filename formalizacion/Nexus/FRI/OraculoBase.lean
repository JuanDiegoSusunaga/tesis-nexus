module

public import Nexus.Merkle.CodificacionBase
public import Nexus.FRI.OraculoMerkle
public import Nexus.N03.CampoBase
import Mathlib.Tactic

/-!
# Oráculo de la traza a partir de hojas Fp

La extracción se hace con el formato de nueve bytes. Solo después se
inyectan los valores en Fp2. Esto conserva los valores algebraicos sin
identificar sus compromisos con los de hojas de diecisiete bytes.
El oráculo completado toma valores base, también fuera de su dominio.
-/

public section
namespace Nexus.Goldilocks

open Nexus.Bytes Nexus.Merkle

@[expose] noncomputable def oraculoBase (k j : ℕ) (H : List Octeto → Digest)
    (registro : List (List Octeto)) (raiz : Digest) : Fp2 → Fp2 :=
  oraculoDeVector k j (fun i => algebraMap Fp Fp2 (vectorIndexado formatoBase H registro (k + 3 - j) raiz i))

theorem oraculo_base_en_indice (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3)
    (H : List Octeto → Digest) (registro : List (List Octeto)) (raiz : Digest)
    (i : Fin (2 ^ (k + 3 - j))) :
    oraculoBase k j H registro raiz (puntoCapa k j i.val) =
      algebraMap Fp Fp2 (vectorIndexado formatoBase H registro (k + 3 - j) raiz i) :=
  oraculo_vector_en_punto k j hk hj _ i

theorem oraculo_base_fuera (k j : ℕ) (H : List Octeto → Digest)
    (registro : List (List Octeto)) (raiz : Digest) (x : Fp2) (hx : x ∉ dominioCapa k j) :
    oraculoBase k j H registro raiz x = 0 :=
  oraculo_vector_fuera k j _ x hx

theorem oraculo_base_es_base (k j : ℕ) (H : List Octeto → Digest)
    (registro : List (List Octeto)) (raiz : Digest) (x : Fp2) :
    EsBase (oraculoBase k j H registro raiz x) := by
  classical
  unfold oraculoBase oraculoDeVector
  split_ifs
  · exact ⟨_, rfl⟩
  · exact ⟨0, map_zero _⟩

theorem oraculo_base_sin_valores_fuera_base (k j : ℕ) (H : List Octeto → Digest)
    (registro : List (List Octeto)) (raiz : Digest) (L : Finset Fp2) :
    puntosFueraBase L (oraculoBase k j H registro raiz) = 0 := by
  classical
  simp only [puntosFueraBase, oraculo_base_es_base, not_true_eq_false, Finset.filter_false, Finset.card_empty]

theorem oraculos_base_iguales (k j : ℕ) (H G : List Octeto → Digest)
    (A B : List (List Octeto)) (raiz : Digest)
    (hv : vectorIndexado formatoBase H A (k + 3 - j) raiz = vectorIndexado formatoBase G B (k + 3 - j) raiz) :
    oraculoBase k j H A raiz = oraculoBase k j G B raiz := by
  apply congrArg (oraculoDeVector k j)
  funext i
  exact congrArg (algebraMap Fp Fp2) (congrFun hv i)

theorem oraculo_base_apertura (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3)
    (H : List Octeto → Digest) (registro : List (List Octeto)) (hc : SinColisiones H registro)
    (raiz : Digest) (i : ℕ) (hi : i < 2 ^ (k + 3 - j)) (v : Fp) (hermanos : List Digest)
    (ha : VerificaIndice formatoBase H raiz (k + 3 - j) i v hermanos)
    (hq : AperturaRegistrada formatoBase H registro v (hermanosDesdeRaiz i hermanos)) :
    oraculoBase k j H registro raiz (puntoCapa k j i) = algebraMap Fp Fp2 v :=
  (oraculo_base_en_indice k j hk hj H registro raiz ⟨i, hi⟩).trans
    (congrArg (algebraMap Fp Fp2)
      (apertura_indexada_extraida formatoBase H registro hc raiz (k + 3 - j) i hi v hermanos ha hq))

theorem plegado_de_pareja_base_abierta (k j a : ℕ) (hk : k ≤ 29) (hj : j < k + 3)
    (ha : a < 2 ^ (k + 3 - (j + 1))) (H : List Octeto → Digest) (registro : List (List Octeto))
    (hc : SinColisiones H registro) (raiz : Digest) (v w : Fp) (β : Fp2) (hv hw : List Digest)
    (av : VerificaIndice formatoBase H raiz (k + 3 - j) a v hv)
    (aw : VerificaIndice formatoBase H raiz (k + 3 - j) (a + 2 ^ (k + 3 - (j + 1))) w hw)
    (qv : AperturaRegistrada formatoBase H registro v (hermanosDesdeRaiz a hv))
    (qw : AperturaRegistrada formatoBase H registro w
      (hermanosDesdeRaiz (a + 2 ^ (k + 3 - (j + 1))) hw)) :
    Nexus.N04.par (oraculoBase k j H registro raiz) (representanteCapa k j)
        (puntoCapa k (j + 1) a) +
      β * Nexus.N04.impar (oraculoBase k j H registro raiz) (representanteCapa k j)
        (puntoCapa k (j + 1) a) =
      (algebraMap Fp Fp2 v + algebraMap Fp Fp2 w) / 2 +
        β * ((algebraMap Fp Fp2 v - algebraMap Fp Fp2 w) / 2) * (puntoCapa k j a)⁻¹ := by
  have ht := tamano_capa_siguiente k j hj
  have hleft : a < 2 ^ (k + 3 - j) := by omega
  have hright : a + 2 ^ (k + 3 - (j + 1)) < 2 ^ (k + 3 - j) := by omega
  rw [formula_plegado_indices k j a hk hj ha]
  rw [oraculo_base_apertura k j hk (by omega) H registro hc raiz a hleft v hv av qv,
    oraculo_base_apertura k j hk (by omega) H registro hc raiz _ hright w hw aw qw]
  ring

end Nexus.Goldilocks
