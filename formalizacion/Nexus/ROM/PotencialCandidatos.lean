module

public import Nexus.N06.Experimento
public import Nexus.ROM.ColaSelector
import Mathlib.Tactic

/-!
# Potencial de candidatos antes de sus respuestas frescas

La estrategia puede abrir candidatos según la historia, intercalar sus
consultas y abandonarlos. Abrir cobra una cota antes de la respuesta;
repetir no sortea otra respuesta. El modelo exige demostrar por separado
que cada candidato real se representa por uno de estos árboles frescos.
-/

public section
namespace Nexus.ROM.Potencial

open Nexus.N06
variable {D : Type} [Fintype D] [Nonempty D]

inductive Ensayo (D : Type) where
  | resultado (aceptado : Bool)
  | consultar (continuacion : D → Ensayo D)

@[expose] noncomputable def valor : Ensayo D → ℚ
  | .resultado b => if b then 1 else 0
  | .consultar f => promedio (fun d => valor (f d))

@[expose] noncomputable def cartera (es : List (Ensayo D)) : ℚ := (es.map valor).sum

theorem valor_no_negativo (e : Ensayo D) : 0 ≤ valor e := by
  induction e with
  | resultado b => cases b <;> norm_num [valor]
  | consultar f ih =>
    exact (promedio_constante (K := D) 0).symm.le.trans (promedio_monotono _ _ ih)

theorem cartera_no_negativa (es : List (Ensayo D)) : 0 ≤ cartera es := by
  induction es with
  | nil => rfl
  | cons e es ih => exact add_nonneg (valor_no_negativo e) ih

omit [Nonempty D] in
theorem cartera_concatenar (a b : List (Ensayo D)) : cartera (a ++ b) = cartera a + cartera b := by
  simp only [cartera, List.map_append, List.sum_append]

omit [Nonempty D] in
theorem cartera_insertar (a b : List (Ensayo D)) (e : Ensayo D) :
    cartera (a ++ e :: b) = cartera a + valor e + cartera b := by
  rw [cartera_concatenar]
  simp only [cartera, List.map_cons, List.sum_cons]
  ring

theorem terminal_en_cartera (es : List (Ensayo D)) (he : Ensayo.resultado true ∈ es) :
    1 ≤ cartera es := by
  induction es with
  | nil => simp at he
  | cons e es ih =>
    rcases List.mem_cons.mp he with he | he
    · subst e
      have hn := cartera_no_negativa es
      change 1 ≤ 1 + cartera es
      linarith
    · have hn := valor_no_negativo e
      change 1 ≤ valor e + cartera es
      linarith [ih he]

/-- El presupuesto cuenta aperturas de candidatos; las respuestas se intercalan libremente. -/
inductive Plan (D : Type) [Fintype D] (rho : ℚ) : List (Ensayo D) → ℕ → Type
  | terminar (es : List (Ensayo D)) (B : ℕ) (b : Bool)
      (h : b = true → Ensayo.resultado true ∈ es) : Plan D rho es B
  | abrir (es : List (Ensayo D)) (B : ℕ) (e : Ensayo D) (h : valor e ≤ rho)
      (resto : Plan D rho (e :: es) B) : Plan D rho es (B + 1)
  | abandonar (a b : List (Ensayo D)) (B : ℕ) (e : Ensayo D)
      (resto : Plan D rho (a ++ b) B) : Plan D rho (a ++ e :: b) B
  | responder (a b : List (Ensayo D)) (B : ℕ) (f : D → Ensayo D)
      (resto : ∀ d, Plan D rho (a ++ f d :: b) B) : Plan D rho (a ++ Ensayo.consultar f :: b) B
  | repetir (es : List (Ensayo D)) (B : ℕ) (resto : Plan D rho es B) : Plan D rho es B

@[expose] noncomputable def riesgo {rho : ℚ} {es : List (Ensayo D)} {B : ℕ} : Plan D rho es B → ℚ
  | .terminar _ _ b _ => if b then 1 else 0
  | .abrir _ _ _ _ resto => riesgo resto
  | .abandonar _ _ _ _ resto => riesgo resto
  | .responder _ _ _ _ resto => promedio (fun d => riesgo (resto d))
  | .repetir _ _ resto => riesgo resto

theorem cota_potencial {rho : ℚ} (hr : 0 ≤ rho) {es : List (Ensayo D)} {B : ℕ}
    (p : Plan D rho es B) : riesgo p ≤ cartera es + (B : ℚ) * rho := by
  induction p with
  | terminar es B b hb =>
    have hc := cartera_no_negativa es
    have hn : 0 ≤ (B : ℚ) * rho := mul_nonneg (by positivity) hr
    cases b with
    | false => change 0 ≤ _; linarith
    | true => change 1 ≤ _; linarith [terminal_en_cartera es (hb rfl)]
  | abrir es B e he resto ih =>
    change riesgo resto ≤ _
    change riesgo resto ≤ valor e + cartera es + (B : ℚ) * rho at ih
    push_cast
    nlinarith
  | abandonar a b B e resto ih =>
    change riesgo resto ≤ _
    rw [cartera_concatenar] at ih
    rw [cartera_insertar]
    linarith [valor_no_negativo e]
  | responder a b B f resto ih =>
    change promedio (fun d => riesgo (resto d)) ≤ _
    calc
      _ ≤ promedio (fun d => cartera (a ++ f d :: b) + (B : ℚ) * rho) := promedio_monotono _ _ ih
      _ = cartera (a ++ Ensayo.consultar f :: b) + (B : ℚ) * rho := by
        simp_rw [cartera_insertar]
        simp only [valor, promedio_suma, promedio_constante]
  | repetir es B resto ih => exact ih

theorem cota_desde_vacio {rho : ℚ} (hr : 0 ≤ rho) (B : ℕ) (p : Plan D rho [] B) :
    riesgo p ≤ (B : ℚ) * rho := by simpa only [cartera, List.map_nil, List.sum_nil, zero_add] using cota_potencial hr p

@[expose] noncomputable def conTrabajo [DecidableEq D] (W : Finset D) (s : D → Ensayo D) : Ensayo D :=
  .consultar (fun d => if d ∈ W then s d else .resultado false)

omit [Nonempty D] in
theorem trabajo_antes_respuesta [DecidableEq D] (W : Finset D) (s : D → Ensayo D)
    (epsilon : ℚ) (h : ∀ d ∈ W, valor (s d) ≤ epsilon) :
    valor (conTrabajo W s) ≤ ((W.card : ℚ) / Fintype.card D) * epsilon := by
  classical
  change promedio (fun d => valor (if d ∈ W then s d else .resultado false)) ≤ _
  calc
    _ ≤ promedio (fun d => if d ∈ W then epsilon else 0) := by
      apply promedio_monotono
      intro d
      by_cases hd : d ∈ W <;> simp only [hd, ite_true, ite_false, valor, Bool.false_eq_true] <;> simp_all
    _ = _ := by
      simp only [promedio, Finset.sum_ite_mem, Finset.sum_const, nsmul_eq_mul]
      rw [Finset.univ_inter]
      ring

theorem presupuestar_inicios (Q B : ℕ) (hB : B ≤ Q + 1) (rho : ℚ) (hr : 0 ≤ rho)
    (p : Plan D rho [] B) : riesgo p ≤ ((Q + 1 : ℕ) : ℚ) * rho :=
  (cota_desde_vacio hr B p).trans (mul_le_mul_of_nonneg_right (by exact_mod_cast hB) hr)

theorem factor_trabajo_y_cola (Q B : ℕ) (hB : B ≤ Q + 1) (trabajo omision cola : ℚ)
    (ht : 0 ≤ trabajo) (ho : 0 ≤ omision) (hc : 0 ≤ cola)
    (p : Plan D (trabajo * (omision + cola)) [] B) :
    riesgo p ≤ ((Q + 1 : ℕ) : ℚ) * trabajo * (omision + cola) := by
  simpa only [mul_assoc] using presupuestar_inicios Q B hB _ (mul_nonneg ht (add_nonneg ho hc)) p

end Nexus.ROM.Potencial
