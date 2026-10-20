module

public import Nexus.Canal.VistaSemantica
public import Nexus.FRI.OraculoMerkle
public import Nexus.FRI.PosicionesAIR
public import Nexus.FRI.IndicesMaquina
import Mathlib.Tactic

/-!
# Vectores indexados como funciones sobre los dominios concretos

La extensión fuera del dominio es cero. Dentro del dominio se recupera el
índice único, y la imagen de una muestra conserva exactamente su cardinal.
-/

public section
namespace Nexus.Canal.VectoresCampo

open Nexus.Goldilocks Nexus.Merkle Nexus.ROM VistaSemantica

@[expose] noncomputable def funcion (k j : ℕ) (v : ℕ → Fp2) : Fp2 → Fp2 :=
  oraculoDeVector k j (fun i => v i.val)

theorem funcion_en_indice (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3)
    (v : ℕ → Fp2) (i : ℕ) (hi : i < 2 ^ (k + 3 - j)) :
    funcion k j v (puntoCapa k j i) = v i :=
  oraculo_vector_en_punto k j hk hj _ ⟨i, hi⟩

theorem funcion_fuera (k j : ℕ) (v : ℕ → Fp2) (x : Fp2)
    (hx : x ∉ dominioCapa k j) : funcion k j v x = 0 :=
  oraculo_vector_fuera k j _ x hx

theorem valor_periodico (t : Tabla Entrada Digest) (d : Digest) (h : ℕ) (r : Digest) (i : ℕ) :
    valor t d h r (i % 2 ^ h) = valor t d h r i := by
  simp only [valor, Nat.mod_mod]

theorem funcion_valor (k j : ℕ) (t : Tabla Entrada Digest) (d r : Digest) :
    funcion k j (valor t d (k + 3 - j) r) =
      oraculoMerkle k j (funcionTabla d t) (t.map Prod.fst) r := by
  unfold funcion oraculoMerkle
  congr 1
  funext i
  simp only [valor, Nat.mod_eq_of_lt i.isLt]

@[expose] noncomputable def muestra (k : ℕ) (S : Finset (Fin (2 ^ (k + 2)))) : Finset Fp2 := by
  classical
  exact S.image (fun i => puntoCapa k 1 i.val)

theorem muestra_dominio (k : ℕ) (S : Finset (Fin (2 ^ (k + 2)))) :
    muestra k S ⊆ dominioCapa k 1 := by
  classical
  intro y hy
  obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hy
  exact Finset.mem_image.mpr ⟨i.val, Finset.mem_range.mpr (by simp), rfl⟩

theorem muestra_cardinal (k : ℕ) (hk : k ≤ 29) (S : Finset (Fin (2 ^ (k + 2)))) :
    (muestra k S).card = S.card := by
  classical
  apply Finset.card_image_of_injOn
  intro a _ b _ hab
  apply Fin.ext
  exact punto_capa_inyectivo k 1 hk (by omega)
    (Finset.mem_range.mpr (by simp))
    (Finset.mem_range.mpr (by simp)) hab

@[expose] def posicionSeis (b : Bool) (j : Fin 3) : Fin 6 :=
  ⟨(if b then 3 else 0) + j.val, by cases b <;> simp <;> omega⟩

theorem posiciones_seis (k i : ℕ) (hi : i < 2 ^ (k + 2)) (b : Bool) (j : Fin 3) :
    IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i (posicionSeis b j) =
      indiceAIR k i b j.val := by
  have hhalf : 2 ^ (k + 3) / 2 = 2 ^ (k + 2) := by
    rw [show k + 3 = k + 2 + 1 by omega, pow_succ, Nat.mul_div_cancel _ (by decide)]
  have hn : 2 ^ (k + 3) = 2 * 2 ^ (k + 2) := by
    rw [show k + 3 = k + 2 + 1 by omega, pow_succ, Nat.mul_comm]
  have hleft : i < 2 ^ (k + 3) := by omega
  have hright : i + 2 ^ (k + 2) < 2 ^ (k + 3) := by omega
  cases b <;> fin_cases j <;>
    simp [posicionSeis, IndicesMaquina.posicionesNaturales, indiceAIR, hhalf,
      Nat.mod_eq_of_lt hleft, Nat.mod_eq_of_lt hright]

end Nexus.Canal.VectoresCampo
