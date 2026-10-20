module

public import Nexus.N06.MensajesCompatibles
import Mathlib.Tactic

/-!
# Reinicios sobre mensajes observados y políticas elegidas por petición

Cada nodo es un prefijo observado: su estado no contiene una política
futura. Cada petición elige una política compatible con su origen guardado.
Los mensajes siguen la gramática y cada sorteo nuevo consume presupuesto.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

theorem aceptacion_mismos_mensajes (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (p r : PoliticaConsulta) (q : ℕ) (t : TranscripcionCausal k q) (h : MismosMensajes k q p r t) :
    aceptaCausal k hk s o (normalizarTerminal k p) q t ↔
      aceptaCausal k hk s o (normalizarTerminal k r) q t := by
  cases t with
  | salida a bt bc S =>
    exact aceptacion_compartida_congruente k hk s o (normalizarTerminal k p) (normalizarTerminal k r) a bt bc
      (mensajes_finales_normalizados k hk0 p r a bt bc h) S.val
  | _ => exact Iff.rfl

@[expose] noncomputable def aceptaObservado (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29)
    (s o : Fp) (q : ℕ) (v : PrefijoObservado k q) : Prop :=
  Quotient.lift (fun p => aceptaCausal k hk s o (normalizarTerminal k p) q v.1)
    (fun p r h => propext (aceptacion_mismos_mensajes k hk0 hk s o p r q v.1 h)) v.2

theorem acepta_observado_coincide (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (p : PoliticaConsulta) (t : TranscripcionCausal k q) :
    aceptaObservado k hk0 hk s o q (observarPrefijo k q p t) ↔
      aceptaCausal k hk s o (normalizarTerminal k p) q t := Iff.rfl

theorem acepta_observado_marcado (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (v : PrefijoObservado k q) (h : aceptaObservado k hk0 hk s o q v) :
    estadoObservado k hk0 hk s o q v = true := by
  rcases v with ⟨t, c⟩
  induction c using Quotient.inductionOn with
  | h p => exact acepta_causal_marcada k hk s o (normalizarTerminal k p) q t h

theorem estado_observado_cero_rechaza (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (v : PrefijoObservado k q) (h : estadoObservado k hk0 hk s o q v = false) :
    ¬ aceptaObservado k hk0 hk s o q v := by
  intro ha
  have hm := acepta_observado_marcado k hk0 hk s o q v ha
  rw [h] at hm
  exact Bool.noConfusion hm

theorem estado_observado_valido (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (v : PrefijoObservado k q) (hv : EnunciadoValido k s o) :
    estadoObservado k hk0 hk s o q v = true := by
  rcases v with ⟨t, c⟩
  induction c using Quotient.inductionOn with
  | h p => exact estado_causal_valido k hk s o (normalizarTerminal k p) q t hv

@[expose] def politicaCero : PoliticaConsulta where
  inicial := fun _ => 0
  traza := fun _ _ _ _ => 0
  composicion := fun _ _ _ _ _ => 0
  constanteTraza := fun _ _ => 0
  constanteComposicion := fun _ _ _ => 0

@[expose] def raizObservada (k q : ℕ) : PrefijoObservado k q := observarPrefijo k q politicaCero .vacia

theorem raiz_observada_unica (k q : ℕ) (p : PoliticaConsulta) :
    observarPrefijo k q p .vacia = raizObservada k q :=
  mismos_mensajes_misma_observacion k q p politicaCero .vacia trivial

structure PeticionObservada (k : ℕ) where
  politica : PoliticaConsulta
  ronda : PeticionCausal k

abbrev RespuestaObservada (k q : ℕ) (r : PeticionObservada k) := RespuestaCausal k q r.ronda

noncomputable instance fintypeRespuestaObservada (k q : ℕ) (r : PeticionObservada k) :
    Fintype (RespuestaObservada k q r) := inferInstanceAs (Fintype (RespuestaCausal k q r.ronda))

@[expose] def origenObservado (k q : ℕ) (r : PeticionObservada k) : PrefijoObservado k q :=
  observarPrefijo k q r.politica (origenCausal k q r.ronda)

@[expose] def destinoObservado (k q : ℕ) (r : PeticionObservada k)
    (x : RespuestaObservada k q r) : PrefijoObservado k q :=
  observarPrefijo k q r.politica (destinoCausal k q r.ronda x)

theorem reto_observado_absorbente (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (r : PeticionObservada k) (x : RespuestaObservada k q r)
    (h : estadoObservado k hk0 hk s o q (origenObservado k q r) = true) :
    estadoObservado k hk0 hk s o q (destinoObservado k q r x) = true := by
  exact reto_causal_absorbente k hk s o (normalizarTerminal k r.politica) q r.ronda x h

theorem cambio_observado_cota (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) (r : PeticionObservada k) :
    cambioFresco (RespuestaObservada k q) (origenObservado k q) (destinoObservado k q)
      (estadoObservado k (by omega) hk s o q) r ≤ errorRonda k q := by
  classical
  have he : cambioFresco (RespuestaObservada k q) (origenObservado k q) (destinoObservado k q)
      (estadoObservado k (by omega) hk s o q) r =
      cambioCausal k hk s o (normalizarTerminal k r.politica) q r.ronda := by
    unfold cambioFresco cambioCausal
    apply promedio_entre_instancias
    intro x
    simp only [origenObservado, destinoObservado, estado_observado_coincide]
    rfl
  exact he.le.trans (cambio_causal_cota k hk0 hk s o (normalizarTerminal k r.politica) hfalso q hq r.ronda)

theorem cambio_observado_universal (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) (r : PeticionObservada k) :
    cambioFresco (RespuestaObservada k q) (origenObservado k q) (destinoObservado k q)
      (estadoObservado k (by omega) hk s o q) r ≤ errorRonda k q := by
  classical
  by_cases hv : EnunciadoValido k s o
  · have hz : cambioFresco (RespuestaObservada k q) (origenObservado k q) (destinoObservado k q)
        (estadoObservado k (by omega) hk s o q) r = 0 := by
      simp only [cambioFresco, estado_observado_valido k (by omega) hk s o q _ hv,
        Bool.true_eq_false, false_and, reduceIte, promedio, Finset.sum_const_zero, zero_div]
    exact hz.le.trans ((show (0 : ℚ) ≤ 1 / (Nexus.Goldilocks.p : ℚ) ^ 2 by positivity).trans (le_max_left _ _))
  · apply cambio_observado_cota k hk0 hk s o _ q hq r
    intro A hA hval
    exact hv ⟨A, hA, hval⟩

/-- La pertenencia del origen al registro exige la misma clase de mensajes ya fijados. -/
inductive PlanObservado (k q : ℕ) : List (PrefijoObservado k q) → ℕ → Type
  | terminar (h : List (PrefijoObservado k q)) (n : ℕ) : PlanObservado k q h n
  | mensaje {h : List (PrefijoObservado k q)} {n : ℕ} (p : PoliticaConsulta)
      (t u : TranscripcionCausal k q) (ht : observarPrefijo k q p t ∈ h)
      (paso : PasoSinReto k q t u)
      (resto : PlanObservado k q (observarPrefijo k q p u :: h) n) : PlanObservado k q h n
  | nuevo {h : List (PrefijoObservado k q)} {n : ℕ} (r : PeticionObservada k)
      (hr : origenObservado k q r ∈ h)
      (resto : ∀ x : RespuestaObservada k q r, PlanObservado k q (destinoObservado k q r x :: h) n) :
      PlanObservado k q h (n + 1)

@[expose] noncomputable def expandirPlanObservado (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29)
    (s o : Fp) (q : ℕ) {h : List (PrefijoObservado k q)} {n : ℕ} :
    PlanObservado k q h n → PlanRestaurable (RespuestaObservada k q) (origenObservado k q)
      (destinoObservado k q) (estadoObservado k hk0 hk s o q) h n
  | .terminar h n => .terminar h n
  | .mensaje p t u ht paso resto => .mensaje (observarPrefijo k q p t) ht (observarPrefijo k q p u)
      (paso_sin_reto_conserva_estado k hk s o (normalizarTerminal k p) q paso)
      (expandirPlanObservado k hk0 hk s o q resto)
  | .nuevo r hr resto => .nuevo r hr (fun x => expandirPlanObservado k hk0 hk s o q (resto x))

@[expose] noncomputable def probabilidadObservada (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29)
    (s o : Fp) (q B : ℕ) (plan : PlanObservado k q [raizObservada k q] B) : ℚ :=
  probabilidadAceptarRegistro (RespuestaObservada k q) (origenObservado k q) (destinoObservado k q)
    (estadoObservado k hk0 hk s o q) (aceptaObservado k hk0 hk s o q)
    (expandirPlanObservado k hk0 hk s o q plan)

theorem reinicios_observados_cota (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) (B : ℕ) (plan : PlanObservado k q [raizObservada k q] B) :
    probabilidadObservada k (by omega) hk s o q B plan ≤ min 1 (B * errorRonda k q) := by
  have hD : (dominioCapa k 1).card = 4 * 2 ^ k := parejas_iniciales_torre k k hk (Nat.le_succ k)
  have : ∀ r : PeticionObservada k, Nonempty (RespuestaObservada k q r) :=
    fun r => respuestas_causales_no_vacias k q (by rw [hD]; exact hq) r.ronda
  have hε : 0 ≤ errorRonda k q :=
    (show (0 : ℚ) ≤ 1 / (Nexus.Goldilocks.p : ℚ) ^ 2 by positivity).trans (le_max_left _ _)
  have hf : ¬ EnunciadoValido k s o := by
    rintro ⟨A, hA, hval⟩
    exact hfalso A hA hval
  apply aceptacion_desde_raiz (RespuestaObservada k q) (origenObservado k q) (destinoObservado k q)
    (estadoObservado k (by omega) hk s o q) (aceptaObservado k (by omega) hk s o q)
    (acepta_observado_marcado k (by omega) hk s o q) _ hε
    (cambio_observado_cota k hk0 hk s o hfalso q hq) (raizObservada k q) ?_ B
    (expandirPlanObservado k (by omega) hk s o q plan)
  exact estado_causal_falso k hk s o (normalizarTerminal k politicaCero) q .vacia hf

theorem reinicios_observados_perfiles (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) (s o : Fp)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (B : ℕ) (plan : PlanObservado k 40 [raizObservada k 40] B) :
    probabilidadObservada k (by omega) (by omega) s o 40 B plan ≤
      min 1 (B * Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8)) := by
  have hc := reinicios_observados_cota k hk0 (by omega) s o hfalso 40
    (Nexus.Modelos.Omision.muestras_perfiles k hk0) B plan
  simpa only [error_ronda_perfiles k hk0 hk1] using hc

end Nexus.Goldilocks
