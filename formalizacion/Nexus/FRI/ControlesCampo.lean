module

public import Nexus.Canal.VectoresCampo
public import Nexus.FRI.ControlesValores
import Mathlib.Tactic

/-!
# Del acarreo sobre valores a las ecuaciones FRI sobre el campo

No se reciben las ecuaciones de plegado como premisa. Se extraen del
recorrido de controles, incluida la compatibilidad con la capa siguiente.
-/

public section
namespace Nexus.Goldilocks.ControlesCampo

open Nexus.Canal Nexus.Verificador.ConjuntosPrevios Recorrido ProgramaFRI
open VectoresCampo

set_option maxHeartbeats 800000

@[expose] noncomputable def apertura (k j i : ℕ) (v : ℕ → Fp2) : Apertura :=
  ⟨v (i % mitad k j), v (i % mitad k j + mitad k j), [], []⟩

theorem longitudes (k j : ℕ) (vs : List (ℕ → Fp2)) (bs : List Fp2) (s : Estado) (c : Fp2)
    (h : controlesFRI k j vs bs s c) : vs.length = bs.length := by
  induction vs generalizing j bs s with
  | nil => cases bs <;> simp_all [controlesFRI]
  | cons v vs ih =>
    cases bs with
    | nil => exact h.elim
    | cons b bs => exact congrArg Nat.succ (ih (j + 1) bs _ h.2)

theorem valor_compatible (k j : ℕ) (hk : k ≤ 29) (hj : j < k + 3)
    (v : ℕ → Fp2) (u : Fp2 → Fp2) (s : Estado) (c : Fp2)
    (hp : s.posicion < 2 ^ (k + 3 - j)) (hs : s.acarreo = some c)
    (hv : ∀ i < 2 ^ (k + 3 - j), u (puntoCapa k j i) = v i)
    (hc : Compatible k j s (apertura k j s.posicion v)) :
    u (puntoCapa k j s.posicion) = c := by
  have hm : 0 < mitad k j := by unfold mitad; positivity
  have hsize := tamano_capa_siguiente k j hj
  change 2 ^ (k + 3 - j) = 2 * mitad k j at hsize
  have ha : s.posicion % mitad k j < mitad k j := Nat.mod_lt _ hm
  have hb : s.posicion % mitad k j + mitad k j < 2 ^ (k + 3 - j) := by omega
  have he := punto_consulta_modulo k j s.posicion hk hj hp
  change puntoCapa k j s.posicion = if s.posicion < mitad k j then
    puntoCapa k j (s.posicion % mitad k j) else -puntoCapa k j (s.posicion % mitad k j) at he
  simp only [Compatible, hs, apertura] at hc
  by_cases hleft : s.posicion < mitad k j
  · rw [ite_eq_left hleft] at hc he
    exact (congrArg u he).trans ((hv _ (by omega)).trans hc)
  · rw [ite_eq_right hleft] at hc he
    have hop := punto_capa_opuesto k j (s.posicion % mitad k j) hk hj
    have hh : k + 2 - j = k + 3 - (j + 1) := by omega
    rw [hh] at hop
    exact (congrArg u he).trans ((congrArg u hop.symm).trans ((hv _ hb).trans hc))

theorem plegado_campo (k j : ℕ) (hk : k ≤ 29) (hj : j < k + 3)
    (v : ℕ → Fp2) (u : Fp2 → Fp2) (i : ℕ) (b : Fp2)
    (hv : ∀ a < 2 ^ (k + 3 - j), u (puntoCapa k j a) = v a) :
    plegar k j (i % mitad k j) (apertura k j i v) b =
      Nexus.N04.par u (representanteCapa k j) (puntoCapa k (j + 1) (i % mitad k j)) +
        b * Nexus.N04.impar u (representanteCapa k j) (puntoCapa k (j + 1) (i % mitad k j)) := by
  have ha : i % mitad k j < mitad k j := Nat.mod_lt _ (by unfold mitad; positivity)
  have hn := tamano_capa_siguiente k j hj
  change 2 ^ (k + 3 - j) = 2 * mitad k j at hn
  simp only [mitad] at ha hn ⊢
  rw [formula_plegado_indices k j _ hk hj ha, hv _ (by omega), hv _ (by omega)]
  simp only [plegar, apertura, mitad]
  ring

theorem ecuaciones (k j : ℕ) (hk : k ≤ 29) (vs : List (ℕ → Fp2)) (bs : List Fp2)
    (s : Estado) (c : Fp2) (u : ℕ → Fp2 → Fp2) (b : ℕ → Fp2) (P : ℕ → ℕ)
    (hj : j + vs.length ≤ k + 1) (hc : controlesFRI k j vs bs s c)
    (hv : ∀ n < vs.length, ∀ i < 2 ^ (k + 3 - (j + n)),
      u (j + n) (puntoCapa k (j + n) i) = (vs.getD n (fun _ => 0)) i)
    (hb : ∀ n < bs.length, b (j + n) = bs.getD n 0)
    (hf : ∀ x, u (j + vs.length) x = c)
    (hp : P j = s.posicion) (hstep : ∀ n, P (n + 1) = P n % mitad k n)
    (hbound : ∀ n ≤ k + 1, P n < 2 ^ (k + 3 - n)) :
    ∀ n < vs.length,
      u (j + n + 1) (puntoCapa k (j + n + 1) (P (j + n + 1))) =
        Nexus.N04.par (u (j + n)) (representanteCapa k (j + n))
          (puntoCapa k (j + n + 1) (P (j + n + 1))) +
        b (j + n) * Nexus.N04.impar (u (j + n)) (representanteCapa k (j + n))
          (puntoCapa k (j + n + 1) (P (j + n + 1))) := by
  induction vs generalizing j bs s with
  | nil => intro n hn; simp only [List.length_nil] at hn; omega
  | cons v vs ih =>
    cases bs with
    | nil => exact hc.elim
    | cons beta bs =>
      have hvl : ∀ i < 2 ^ (k + 3 - j), u j (puntoCapa k j i) = v i := by
        simpa only [Nat.add_zero, List.getD_cons_zero] using hv 0 (by simp)
      have hbl : b j = beta := by simpa only [Nat.add_zero, List.getD_cons_zero] using hb 0 (by simp)
      let d := apertura k j s.posicion v
      let t := siguiente k j s d beta
      have hct : controlesFRI k (j + 1) vs bs t c := hc.2
      have hpt : P (j + 1) = t.posicion := by simp only [hstep, hp, t, siguiente]
      have hvt : ∀ n < vs.length, ∀ i < 2 ^ (k + 3 - (j + 1 + n)),
          u (j + 1 + n) (puntoCapa k (j + 1 + n) i) = (vs.getD n (fun _ => 0)) i := by
        intro n hn i hi
        have he : j + (n + 1) = j + 1 + n := by omega
        have h := hv (n + 1) (by simp only [List.length_cons]; omega) i
        simpa only [he, List.getD_cons_succ] using h (by simpa only [he] using hi)
      have hbt : ∀ n < bs.length, b (j + 1 + n) = bs.getD n 0 := by
        intro n hn
        have he : j + (n + 1) = j + 1 + n := by omega
        have h := hb (n + 1) (by simp only [List.length_cons]; omega)
        simpa only [he, List.getD_cons_succ] using h
      have hft : ∀ x, u (j + 1 + vs.length) x = c := by
        simpa only [List.length_cons, Nat.add_assoc, Nat.add_left_comm, Nat.add_comm] using hf
      intro n hn
      cases n with
      | zero =>
        simp only [Nat.add_zero]
        have hnext : u (j + 1) (puntoCapa k (j + 1) (P (j + 1))) =
            plegar k j (s.posicion % mitad k j) d beta := by
          cases vs with
          | nil =>
            have hz : c = plegar k j (s.posicion % mitad k j) d beta := by
              cases bs with
              | nil => exact (Option.some.inj hct).symm
              | cons b bs => exact hct.elim
            exact (hft _).trans hz
          | cons w ws =>
            cases bs with
            | nil => exact hct.elim
            | cons b bs =>
              rw [hpt]
              exact valor_compatible k (j + 1) hk (by simp only [List.length_cons] at hj; omega)
                w (u (j + 1)) t _ (hpt ▸ hbound (j + 1) (by omega)) rfl
                (by simpa only [Nat.add_zero, List.getD_cons_zero] using hvt 0 (by simp)) hct.1
        rw [hnext, hstep, hp, hbl]
        exact plegado_campo k j hk (by omega) v (u j) s.posicion beta hvl
      | succ n =>
        have hi := ih (j + 1) bs t (by simp only [List.length_cons] at hj; omega)
          hct hvt hbt hft hpt n (by simp only [List.length_cons] at hn; omega)
        simpa only [Nat.add_assoc, Nat.add_left_comm, Nat.add_comm] using hi

end Nexus.Goldilocks.ControlesCampo
