module

public import Nexus.FRI.ControlesCampo
import Mathlib.Tactic

/-!
# Aceptación FRI de los vectores leídos por el verificador

Cada capa procede de la lista indexada; después de la última se usa la
constante declarada. El acarreo deriva toda la aceptación sobre el campo.
-/

public section
namespace Nexus.Goldilocks.ListaCampo

open Nexus.Canal Nexus.Verificador.ConjuntosPrevios Recorrido VectoresCampo

@[expose] noncomputable def oraculos (k : ℕ) (vs : List (ℕ → Fp2)) (c : Fp2)
    (j : ℕ) (x : Fp2) : Fp2 :=
  if j < vs.length then funcion k j (vs.getD j (fun _ => 0)) x else c

theorem en_indice (k : ℕ) (hk : k ≤ 29) (vs : List (ℕ → Fp2)) (c : Fp2)
    (j : ℕ) (hj : j < vs.length) (hbound : j ≤ k + 3) (i : ℕ)
    (hi : i < 2 ^ (k + 3 - j)) :
    oraculos k vs c j (puntoCapa k j i) = (vs.getD j (fun _ => 0)) i := by
  rw [oraculos, ite_eq_left hj]
  exact funcion_en_indice k j hk hbound _ i hi

theorem final (k : ℕ) (vs : List (ℕ → Fp2)) (c : Fp2) (x : Fp2) :
    oraculos k vs c vs.length x = c := by
  simp only [oraculos, lt_self_iff_false, ite_false]

theorem inicial (k : ℕ) (v : ℕ → Fp2) (vs : List (ℕ → Fp2)) (c : Fp2) :
    oraculos k (v :: vs) c 0 = funcion k 0 v := by
  funext x
  simp only [oraculos, List.length_cons, Nat.zero_lt_succ, ite_true, List.getD_cons_zero]

theorem aceptacion (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1)
    (vs : List (ℕ → Fp2)) (bs : List Fp2) (c : Fp2) (i : ℕ)
    (hi : i < 2 ^ (k + 2)) (hl : vs.length = m)
    (hc : controlesFRI k 0 vs bs ⟨i, none⟩ c) :
    Nexus.FRI.Acepta (torreGoldilocks k m hk hm) (oraculos k vs c) (fun j => bs.getD j.val 0)
      (Nexus.FRI.elevar (representanteCapa k 0) {puntoCapa k 1 i}) c := by
  classical
  have hpos : i < 2 ^ (k + 3) := hi.trans
    (Nat.pow_lt_pow_right (by decide) (by omega))
  have he := ControlesCampo.ecuaciones k 0 hk vs bs ⟨i, none⟩ c (oraculos k vs c)
    (fun j => bs.getD j 0) (posicion k i) (by omega) hc
    (by
      intro n hn a ha
      simpa only [Nat.zero_add] using en_indice k hk vs c n hn (by omega) a (by simpa only [Nat.zero_add] using ha))
    (by intro n _; simp only [Nat.zero_add]) (by simpa only [Nat.zero_add] using final k vs c)
    rfl (by intro n; rfl) (by intro n _; exact posicion_acotada k i n hpos)
  constructor
  · intro j y hy
    rw [recorrido_de_indices k i j hk (by omega) hi] at hy
    rw [Finset.mem_singleton.mp hy]
    simpa only [Nat.zero_add, torreGoldilocks] using he j.val (by omega)
  · intro y _
    rw [← hl]
    exact final k vs c y

theorem muestra_aceptada (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1)
    (vs : List (ℕ → Fp2)) (bs : List Fp2) (c : Fp2)
    (S : Finset (Fin (2 ^ (k + 2)))) (hl : vs.length = m)
    (hc : ∀ i ∈ S, controlesFRI k 0 vs bs ⟨i.val, none⟩ c) :
    Nexus.FRI.Acepta (torreGoldilocks k m hk hm) (oraculos k vs c) (fun j => bs.getD j.val 0)
      (Nexus.FRI.elevar (representanteCapa k 0) (muestra k S)) c := by
  classical
  apply (Nexus.FRI.acepta_parejas_iff _ _ _ _ _).mpr
  intro y hy
  obtain ⟨i, hi, rfl⟩ := Finset.mem_image.mp hy
  exact aceptacion k m hk hm vs bs c i.val i.isLt hl (hc i hi)

end Nexus.Goldilocks.ListaCampo
