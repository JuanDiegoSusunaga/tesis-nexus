module

public import Nexus.N06.TranscripcionCausal
import Mathlib.Tactic

/-!
# Solidez y reinicios de prefijos con marca reconstruida

Se transportan las cotas a las transcripciones tipadas. El plan restaurable
solo añade mensajes permitidos por la gramática, y cada respuesta extiende
un prefijo guardado. La política causal es fija en esta expansión; el juego
anterior de políticas adaptativas por nodo conserva su alcance separado.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

@[expose] noncomputable def cambioCausal (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q : ℕ) (r : PeticionCausal k) : ℚ := by
  classical
  exact promedio (fun x : RespuestaCausal k q r =>
    if estadoCausal k hk s o p q (origenCausal k q r) = false ∧
      estadoCausal k hk s o p q (destinoCausal k q r x) = true then 1 else 0)

theorem cambio_causal_certificado (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (q : ℕ) (ε : ℚ) (hε : 0 ≤ ε) (hc : CertificadoRondas k hk s o p q ε)
    (r : PeticionCausal k) : cambioCausal k hk s o p q r ≤ ε := by
  classical
  by_cases hv : EnunciadoValido k s o
  · have hz : cambioCausal k hk s o p q r = 0 := by
      simp only [cambioCausal, estado_causal_valido k hk s o p q _ hv,
        Bool.true_eq_false, false_and, reduceIte]
      simp only [promedio, Finset.sum_const_zero, zero_div]
    exact hz.le.trans hε
  · have he : cambioCausal k hk s o p q r =
        cambioFresco (RespuestaIdeal k q) (origenIdeal k) (destinoIdeal k hk s o p q)
          (marcaNodo k hk s o p) (peticionSubyacente k hk s o p r) := by
      cases r <;> unfold cambioCausal cambioFresco <;> apply promedio_entre_instancias <;>
        intro x <;>
        simp only [estado_causal_falso k hk s o p q _ hv, nodo_causal_origen, nodo_causal_destino,
          respuestaSubyacente, id_eq]
    exact he.le.trans (cambio_ideal_certificado k hk s o p q ε hc _)

theorem cambio_causal_cota (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) (r : PeticionCausal k) :
    cambioCausal k hk s o p q r ≤ errorRonda k q := by
  apply cambio_causal_certificado k hk s o p q _ _
    (solidez_por_rondas k hk0 hk s o p hfalso q hq) r
  exact (show (0 : ℚ) ≤ 1 / (Nexus.Goldilocks.p : ℚ) ^ 2 by positivity).trans (le_max_left _ _)

theorem destino_ideal_absorbente (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (q : ℕ) (r : PeticionIdeal k) (x : RespuestaIdeal k q r)
    (h : marcaNodo k hk s o p (origenIdeal k r) = true) :
    marcaNodo k hk s o p (destinoIdeal k hk s o p q r x) = true := by
  cases r <;> simp only [origenIdeal, marcaNodo] at h <;>
    simp only [destinoIdeal, marcaNodo, marcaFinal, actualizarMarca, h, Bool.true_or]

theorem reto_causal_absorbente (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (q : ℕ) (r : PeticionCausal k) (x : RespuestaCausal k q r)
    (h : estadoCausal k hk s o p q (origenCausal k q r) = true) :
    estadoCausal k hk s o p q (destinoCausal k q r x) = true := by
  by_cases hv : EnunciadoValido k s o
  · exact estado_causal_valido k hk s o p q _ hv
  · rw [estado_causal_falso k hk s o p q _ hv, nodo_causal_destino]
    rw [estado_causal_falso k hk s o p q _ hv, nodo_causal_origen] at h
    exact destino_ideal_absorbente k hk s o p q _ _ h

@[expose] noncomputable def aceptaCausal (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q : ℕ) : TranscripcionCausal k q → Prop
  | .salida a bt bc S => AceptaCompartida k hk s o (ejecutarPrefijo k p a bt bc) S.val
  | _ => False

theorem acepta_causal_marcada (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (q : ℕ) (t : TranscripcionCausal k q) (ha : aceptaCausal k hk s o p q t) :
    estadoCausal k hk s o p q t = true := by
  cases t with
  | salida a bt bc S =>
    cases he : estadoCausal k hk s o p q (.salida a bt bc S) with
    | false => exact (salida_causal_cero_rechaza k hk s o p q a bt bc S he ha).elim
    | true => rfl
  | _ => exact ha.elim

/-- Restaurar un prefijo no restaura el presupuesto; los mensajes tienen tipo propio. -/
inductive PlanCausal (k q : ℕ) : List (TranscripcionCausal k q) → ℕ → Type
  | terminar (h : List (TranscripcionCausal k q)) (n : ℕ) : PlanCausal k q h n
  | mensaje {h : List (TranscripcionCausal k q)} {n : ℕ}
      (t : TranscripcionCausal k q) (ht : t ∈ h) (u : TranscripcionCausal k q)
      (paso : PasoSinReto k q t u) (resto : PlanCausal k q (u :: h) n) : PlanCausal k q h n
  | nuevo {h : List (TranscripcionCausal k q)} {n : ℕ}
      (r : PeticionCausal k) (hr : origenCausal k q r ∈ h)
      (resto : ∀ x : RespuestaCausal k q r, PlanCausal k q (destinoCausal k q r x :: h) n) :
      PlanCausal k q h (n + 1)

@[expose] noncomputable def expandirPlanCausal (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q : ℕ) {h : List (TranscripcionCausal k q)} {n : ℕ} :
    PlanCausal k q h n → PlanRestaurable (RespuestaCausal k q) (origenCausal k q)
      (destinoCausal k q) (estadoCausal k hk s o p q) h n
  | .terminar h n => .terminar h n
  | .mensaje t ht u paso resto => .mensaje t ht u
      (paso_sin_reto_conserva_estado k hk s o p q paso)
      (expandirPlanCausal k hk s o p q resto)
  | .nuevo r hr resto => .nuevo r hr (fun x => expandirPlanCausal k hk s o p q (resto x))

@[expose] noncomputable def probabilidadPlanCausal (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q B : ℕ) (plan : PlanCausal k q [.vacia] B) : ℚ :=
  probabilidadAceptarRegistro (RespuestaCausal k q) (origenCausal k q) (destinoCausal k q)
    (estadoCausal k hk s o p q) (aceptaCausal k hk s o p q)
    (expandirPlanCausal k hk s o p q plan)

theorem respuestas_causales_no_vacias (k q : ℕ) (hq : q ≤ (dominioCapa k 1).card)
    (r : PeticionCausal k) : Nonempty (RespuestaCausal k q r) := by
  cases r with
  | air => exact inferInstanceAs (Nonempty Fp2)
  | traza => exact inferInstanceAs (Nonempty Fp2)
  | composicion => exact inferInstanceAs (Nonempty Fp2)
  | consulta => exact muestra_parejas_no_vacia _ q hq

/-- La cota se aplica a prefijos extendidos, no a marcas suministradas al juego. -/
theorem plan_causal_cota (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) (B : ℕ) (plan : PlanCausal k q [.vacia] B) :
    probabilidadPlanCausal k hk s o p q B plan ≤ min 1 (B * errorRonda k q) := by
  have hf : ¬ EnunciadoValido k s o := by
    rintro ⟨A, hA, hval⟩
    exact hfalso A hA hval
  have hD : (dominioCapa k 1).card = 4 * 2 ^ k := parejas_iniciales_torre k k hk (Nat.le_succ k)
  have : ∀ r, Nonempty (RespuestaCausal k q r) :=
    respuestas_causales_no_vacias k q (by rw [hD]; exact hq)
  have hε : 0 ≤ errorRonda k q :=
    (show (0 : ℚ) ≤ 1 / (Nexus.Goldilocks.p : ℚ) ^ 2 by positivity).trans (le_max_left _ _)
  apply aceptacion_desde_raiz (RespuestaCausal k q) (origenCausal k q) (destinoCausal k q)
    (estadoCausal k hk s o p q) (aceptaCausal k hk s o p q) (acepta_causal_marcada k hk s o p q)
    _ hε ?_ .vacia ?_ B (expandirPlanCausal k hk s o p q plan)
  · exact cambio_causal_cota k hk0 hk s o p hfalso q hq
  · rw [estado_causal_falso k hk s o p q _ hf]
    rfl

theorem plan_causal_perfiles (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) (s o : Fp)
    (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (B : ℕ) (plan : PlanCausal k 40 [.vacia] B) :
    probabilidadPlanCausal k (by omega) s o p 40 B plan ≤
      min 1 (B * Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8)) := by
  have hc := plan_causal_cota k hk0 (by omega) s o p hfalso 40
    (Nexus.Modelos.Omision.muestras_perfiles k hk0) B plan
  simpa only [error_ronda_perfiles k hk0 hk1] using hc

end Nexus.Goldilocks
