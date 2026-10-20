module

public import Nexus.N06.PrimerCambio
public import Nexus.N06.Muestras
public import Nexus.N06.PorRondas
import Mathlib.Tactic

/-!
# Reinicios adaptativos de las rondas ideales AIR/FRI

Se guardan nodos completos con su fase, historia y marca. Cada petición
de reto debe partir de un nodo guardado. Los mensajes pueden cambiar los
demás datos conservando la marca; esto permite todas las decisiones del
probador ideal y no establece una extracción de compromisos Merkle.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

inductive NodoIdeal (k : ℕ) where
  | raiz
  | air (i : ℕ) (estado : Polynomial Fp2) (b : Bool)
  | traza (a : Retos Fp2 3) (j : ℕ) (h : List Fp2) (b : Bool)
  | composicion (a : Retos Fp2 3) (bt : Retos Fp2 k) (j : ℕ) (h : List Fp2) (b : Bool)
  | consulta (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
  | salida (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) (S : Finset Fp2)

inductive PeticionIdeal (k : ℕ) where
  | air (i : ℕ) (estado : Polynomial Fp2) (b : Bool)
  | traza (a : Retos Fp2 3) (j : Fin k) (h : List Fp2) (b : Bool)
  | composicion (a : Retos Fp2 3) (bt : Retos Fp2 k) (j : Fin (k + 1)) (h : List Fp2) (b : Bool)
  | consulta (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))

abbrev RespuestaIdeal (k q : ℕ) : PeticionIdeal k → Type
  | .air _ _ _ => Fp2
  | .traza _ _ _ _ => Fp2
  | .composicion _ _ _ _ _ => Fp2
  | .consulta _ _ _ => MuestraParejas (dominioCapa k 1) q

noncomputable instance fintypeRespuestaIdeal (k q : ℕ) (r : PeticionIdeal k) :
    Fintype (RespuestaIdeal k q r) :=
  match r with
  | .air _ _ _ => inferInstanceAs (Fintype Fp2)
  | .traza _ _ _ _ => inferInstanceAs (Fintype Fp2)
  | .composicion _ _ _ _ _ => inferInstanceAs (Fintype Fp2)
  | .consulta _ _ _ => inferInstanceAs (Fintype (MuestraParejas (dominioCapa k 1) q))

theorem respuestas_ideales_no_vacias (k q : ℕ) (hq : q ≤ (dominioCapa k 1).card)
    (r : PeticionIdeal k) : Nonempty (RespuestaIdeal k q r) := by
  cases r with
  | air => exact inferInstanceAs (Nonempty Fp2)
  | traza => exact inferInstanceAs (Nonempty Fp2)
  | composicion => exact inferInstanceAs (Nonempty Fp2)
  | consulta => exact muestra_parejas_no_vacia _ q hq

@[expose] def origenIdeal (k : ℕ) : PeticionIdeal k → NodoIdeal k
  | .air i estado b => .air i estado b
  | .traza a j h b => .traza a j h b
  | .composicion a bt j h b => .composicion a bt j h b
  | .consulta a bt bc => .consulta a bt bc

@[expose] noncomputable def marcaNodo (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta) :
    NodoIdeal k → Bool
  | .raiz => false
  | .air _ _ b => b
  | .traza _ _ _ b => b
  | .composicion _ _ _ _ b => b
  | .consulta a bt bc => marcaAntesConsulta k hk s o p a bt bc
  | .salida a bt bc S => marcaFinal k hk s o p a bt bc S

@[expose] noncomputable def destinoIdeal (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q : ℕ) : (r : PeticionIdeal k) → RespuestaIdeal k q r → NodoIdeal k := by
  classical
  exact fun r => match r with
    | .air i estado b => fun x => .air (i + 1) (pasoAIR (residuosVigilados k s o p) i estado x)
        (actualizarMarca b (x ∈ excepcionesCriticas (residuosVigilados k s o p) i estado))
    | .traza a j h b => fun x => .traza a (j + 1) (h ++ [x])
        (actualizarMarca b (x ∈ monitorTraza k hk p a j h))
    | .composicion a bt j h b => fun x => .composicion a bt (j + 1) (h ++ [x])
        (actualizarMarca b (x ∈ monitorComposicion k hk p a bt j h))
    | .consulta a bt bc => fun S => .salida a bt bc S.val

@[expose] noncomputable def aceptaNodo (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta) :
    NodoIdeal k → Prop
  | .salida a bt bc S => AceptaCompartida k hk s o (ejecutarPrefijo k p a bt bc) S
  | _ => False

theorem acepta_nodo_marcado (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (v : NodoIdeal k) (hv : aceptaNodo k hk s o p v) : marcaNodo k hk s o p v = true := by
  cases v with
  | salida a bt bc S => exact aceptacion_activa_estado k hk s o p a bt bc S hv
  | _ => exact hv.elim

/-- Cada petición reutiliza exactamente la distribución y la cota del certificado previo. -/
theorem cambio_ideal_certificado (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (q : ℕ) (ε : ℚ) (hc : CertificadoRondas k hk s o p q ε) (r : PeticionIdeal k) :
    cambioFresco (RespuestaIdeal k q) (origenIdeal k) (destinoIdeal k hk s o p q)
      (marcaNodo k hk s o p) r ≤ ε := by
  classical
  cases r with
  | air i estado b =>
    apply (le_of_eq ?_).trans (hc.air i estado b)
    unfold cambioFresco probabilidadCambio
    apply promedio_entre_instancias
    intro x
    cases b <;> by_cases hx : x ∈ excepcionesCriticas (residuosVigilados k s o p) i estado <;>
      simp [origenIdeal, destinoIdeal, marcaNodo, actualizarMarca, hx]
  | traza a j h b =>
    apply (le_of_eq ?_).trans (hc.traza a j h b)
    unfold cambioFresco probabilidadCambio
    apply promedio_entre_instancias
    intro x
    cases b <;> by_cases hx : x ∈ monitorTraza k hk p a j h <;>
      simp [origenIdeal, destinoIdeal, marcaNodo, actualizarMarca, hx]
  | composicion a bt j h b =>
    apply (le_of_eq ?_).trans (hc.composicion a bt j h b)
    unfold cambioFresco probabilidadCambio
    apply promedio_entre_instancias
    intro x
    cases b <;> by_cases hx : x ∈ monitorComposicion k hk p a bt j h <;>
      simp [origenIdeal, destinoIdeal, marcaNodo, actualizarMarca, hx]
  | consulta a bt bc =>
    have he := promedio_muestra_consulta (dominioCapa k 1) q (fun S =>
      marcaAntesConsulta k hk s o p a bt bc = false ∧ marcaFinal k hk s o p a bt bc S = true)
    have heq : cambioFresco (RespuestaIdeal k q) (origenIdeal k) (destinoIdeal k hk s o p q)
        (marcaNodo k hk s o p) (.consulta a bt bc) = cambioConsulta k hk s o p a bt bc q := by
      apply Eq.trans ?_ he
      unfold cambioFresco
      apply promedio_entre_instancias
      intro S
      by_cases hb : marcaAntesConsulta k hk s o p a bt bc = false ∧
          marcaFinal k hk s o p a bt bc S.val = true <;>
        simp only [origenIdeal, destinoIdeal, marcaNodo, hb, reduceIte]
    exact heq.le.trans (hc.consulta a bt bc)

abbrev PlanReinicios (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta) (q B : ℕ) :=
  PlanRestaurable (RespuestaIdeal k q) (origenIdeal k) (destinoIdeal k hk s o p q)
    (marcaNodo k hk s o p) [.raiz] B

@[expose] noncomputable def probabilidadReinicios (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q B : ℕ) (plan : PlanReinicios k hk s o p q B) : ℚ :=
  probabilidadAceptarRegistro (RespuestaIdeal k q) (origenIdeal k) (destinoIdeal k hk s o p q)
    (marcaNodo k hk s o p) (aceptaNodo k hk s o p) plan

theorem reinicios_desde_certificado (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (q : ℕ) (hq : q ≤ (dominioCapa k 1).card) (ε : ℚ) (hε : 0 ≤ ε)
    (hc : CertificadoRondas k hk s o p q ε) (B : ℕ) (plan : PlanReinicios k hk s o p q B) :
    probabilidadReinicios k hk s o p q B plan ≤ min 1 (B * ε) := by
  have : ∀ r, Nonempty (RespuestaIdeal k q r) := respuestas_ideales_no_vacias k q hq
  exact aceptacion_desde_raiz (RespuestaIdeal k q) (origenIdeal k) (destinoIdeal k hk s o p q)
    (marcaNodo k hk s o p) (aceptaNodo k hk s o p) (acepta_nodo_marcado k hk s o p)
    ε hε (cambio_ideal_certificado k hk s o p q ε hc) .raiz rfl B plan

theorem reinicios_ideales_cota (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) (B : ℕ) (plan : PlanReinicios k hk s o p q B) :
    probabilidadReinicios k hk s o p q B plan ≤ min 1 (B * errorRonda k q) := by
  have hD : (dominioCapa k 1).card = 4 * 2 ^ k := parejas_iniciales_torre k k hk (Nat.le_succ k)
  apply reinicios_desde_certificado k hk s o p q (by rw [hD]; exact hq) _ _
    (solidez_por_rondas k hk0 hk s o p hfalso q hq) B plan
  exact (show (0 : ℚ) ≤ 1 / (Nexus.Goldilocks.p : ℚ) ^ 2 by positivity).trans (le_max_left _ _)

theorem reinicios_ideales_perfiles (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) (s o : Fp)
    (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (B : ℕ) (plan : PlanReinicios k (by omega) s o p 40 B) :
    probabilidadReinicios k (by omega) s o p 40 B plan ≤
      min 1 (B * Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8)) := by
  have hb := reinicios_ideales_cota k hk0 (by omega) s o p hfalso 40
    (Nexus.Modelos.Omision.muestras_perfiles k hk0) B plan
  simpa only [error_ronda_perfiles k hk0 hk1] using hb

end Nexus.Goldilocks
