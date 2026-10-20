module

public import Nexus.ROM.Juego
import Mathlib.Tactic

/-!
# Probabilidad exacta y unión adaptativa para el oráculo con memoria

El espacio uniforme contiene solo respuestas frescas. Las repeticiones siguen
una única rama determinada por la tabla. El primer acierto es absorbente.
-/

public section
namespace Nexus.ROM

open Nexus.Merkle Nexus.N06

instance nonemptyDigestROM : Nonempty Digest :=
  ⟨⟨List.replicate 32 0, by simp⟩⟩

@[expose] noncomputable def riesgo {B : ℕ} {s : Estado B} {n : ℕ} : Plan B s n → ℚ
  | .terminar _ _ => 0
  | .repetir _ _ _ resto => riesgo resto
  | .nuevo q _ resto => promedio (fun d => if d ∈ antesRespuesta s q then 1 else riesgo (resto d))

@[expose] def acierta {B : ℕ} {s : Estado B} {n : ℕ} : Plan B s n → Retos Digest n → Bool
  | .terminar _ _, _ => false
  | .repetir _ _ _ resto, xs => acierta resto xs
  | .nuevo q _ resto, xs => decide (xs.1 ∈ antesRespuesta s q) || acierta (resto xs.1) xs.2

theorem riesgo_es_promedio {B : ℕ} {s : Estado B} {n : ℕ} (p : Plan B s n) :
    riesgo p = promedio (fun xs => if acierta p xs then 1 else 0) := by
  induction p with
  | terminar s n => exact (promedio_constante 0).symm
  | repetir q d hd resto ih => exact ih
  | @nuevo s n q hn resto ih =>
    simp only [riesgo]
    change _ = promedio (fun xs : Digest × Retos Digest n =>
      if decide (xs.1 ∈ antesRespuesta s q) || acierta (resto xs.1) xs.2 then 1 else 0)
    rw [promedio_producto]
    congr 1
    funext d
    by_cases hd : d ∈ antesRespuesta s q
    · simp only [hd, decide_true, Bool.true_or, ite_true]
      exact (promedio_constante 1).symm
    · simp only [hd, decide_false, Bool.false_or, ite_false]
      exact ih d

theorem probabilidad_acierto {B : ℕ} {s : Estado B} {n : ℕ} (p : Plan B s n) :
    riesgo p =
      ((Finset.univ.filter (fun xs => acierta p xs = true)).card : ℚ) / (2 ^ 256 : ℚ) ^ n := by
  classical
  rw [riesgo_es_promedio]
  simp only [promedio, Finset.sum_boole, cardinal_retos, digest_cardinal,
    Nat.cast_pow, Nat.cast_ofNat]

theorem riesgo_no_negativo {B : ℕ} {s : Estado B} {n : ℕ} (p : Plan B s n) : 0 ≤ riesgo p := by
  induction p with
  | terminar => rfl
  | repetir q d hd resto ih => exact ih
  | nuevo q hn resto ih =>
    change 0 ≤ promedio _
    rw [← promedio_constante (K := Digest) 0]
    apply promedio_monotono
    intro d
    split_ifs
    · norm_num
    · exact ih d

theorem riesgo_le_uno {B : ℕ} {s : Estado B} {n : ℕ} (p : Plan B s n) : riesgo p ≤ 1 := by
  induction p with
  | terminar => norm_num [riesgo]
  | repetir q d hd resto ih => exact ih
  | nuevo q hn resto ih =>
    change promedio _ ≤ 1
    calc
      _ ≤ promedio (fun _ : Digest => 1) := by
        apply promedio_monotono
        intro d
        split_ifs
        · rfl
        · exact ih d
      _ = 1 := promedio_constante 1

theorem probabilidad_respuesta_nueva {B : ℕ} (s : Estado B) (q : Solicitud s)
    (S : ℕ) (hs : s.tabla.length < S) :
    promedio (fun d : Digest => if d ∈ antesRespuesta s q then 1 else 0) ≤
      ((49 * S + B : ℕ) : ℚ) / 2 ^ 256 := by
  rw [promedio_indicador, digest_cardinal]
  simp only [Nat.cast_pow, Nat.cast_ofNat]
  exact div_le_div_of_nonneg_right (by exact_mod_cast antes_respuesta_card s q S hs) (by positivity)

theorem cota_union_adaptativa {B : ℕ} {s : Estado B} {n : ℕ} (p : Plan B s n)
    (S : ℕ) (hs : s.tabla.length + n ≤ S) :
    riesgo p ≤ (n : ℚ) * (((49 * S + B : ℕ) : ℚ) / 2 ^ 256) := by
  induction p with
  | terminar s n => change 0 ≤ _; positivity
  | @repetir s n q d hd resto ih => exact ih hs
  | @nuevo s n q hn resto ih =>
    let ε : ℚ := ((49 * S + B : ℕ) : ℚ) / 2 ^ 256
    have hε : 0 ≤ ε := by dsimp [ε]; positivity
    have hs' : s.tabla.length < S := by omega
    have hlocal := probabilidad_respuesta_nueva s q S hs'
    have hcont (d : Digest) : riesgo (resto d) ≤ (n : ℚ) * ε := by
      apply ih d
      simp only [estadoNuevo, List.length_append, List.length_cons, List.length_nil]
      omega
    have hpoint (d : Digest) :
        (if d ∈ antesRespuesta s q then 1 else riesgo (resto d)) ≤
          (if d ∈ antesRespuesta s q then 1 else 0) + (n : ℚ) * ε := by
      by_cases hd : d ∈ antesRespuesta s q
      · simp only [hd, ite_true]
        have h := mul_nonneg (show (0 : ℚ) ≤ n by positivity) hε
        linarith
      · simpa only [hd, ite_false, zero_add] using hcont d
    calc
      _ ≤ promedio (fun d : Digest =>
          (if d ∈ antesRespuesta s q then 1 else 0) + (n : ℚ) * ε) := promedio_monotono _ _ hpoint
      _ = promedio (fun d : Digest => if d ∈ antesRespuesta s q then 1 else 0) + (n : ℚ) * ε := by
        rw [promedio_suma, promedio_constante]
      _ ≤ ε + (n : ℚ) * ε := by
        dsimp only [ε]
        linarith [hlocal]
      _ = ((n + 1 : ℕ) : ℚ) * ε := by push_cast; ring

theorem cota_union_minimo {B : ℕ} {s : Estado B} {n : ℕ} (p : Plan B s n)
    (S : ℕ) (hs : s.tabla.length + n ≤ S) :
    riesgo p ≤ min 1 ((n : ℚ) * (((49 * S + B : ℕ) : ℚ) / 2 ^ 256)) :=
  le_min (riesgo_le_uno p) (cota_union_adaptativa p S hs)

theorem cota_desde_vacio (S B : ℕ) (p : Plan B (inicial B) S) :
    riesgo p ≤ min 1 (((S * (49 * S + B) : ℕ) : ℚ) / 2 ^ 256) := by
  have h := cota_union_minimo p S (by simp [inicial])
  simpa only [Nat.cast_mul, mul_div_assoc] using h

end Nexus.ROM
