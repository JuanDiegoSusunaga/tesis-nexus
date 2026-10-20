module

public import Nexus.N06.PasosExplicitos
import Mathlib.Tactic

/-!
# Planes de reinicios con transcripciones explícitas

Los mensajes obedecen la gramática y preservan los datos anteriores.
Cada reto usa un origen guardado y añade su respuesta al registro sin
modificar otros nodos. Restaurar no devuelve presupuesto de retos frescos.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

@[expose] def raizExplicita (k q : ℕ) : TranscripcionExplicita k q := ⟨.vacia, PUnit.unit⟩

theorem codificar_raiz_explicita (k q : ℕ) :
    codificarExplicita k q (raizExplicita k q) = raizObservada k q := rfl

inductive PlanExplicito (k q : ℕ) : List (TranscripcionExplicita k q) → ℕ → Type
  | terminar (h : List (TranscripcionExplicita k q)) (n : ℕ) : PlanExplicito k q h n
  | mensaje {h : List (TranscripcionExplicita k q)} {n : ℕ}
      (v : TranscripcionExplicita k q) (hv : v ∈ h) (w : TranscripcionExplicita k q)
      (paso : PasoExplicito k q v w)
      (resto : PlanExplicito k q (w :: h) n) : PlanExplicito k q h n
  | nuevo {h : List (TranscripcionExplicita k q)} {n : ℕ} (r : PeticionExplicita k q)
      (hr : origenExplicito k q r ∈ h)
      (resto : ∀ x : RespuestaExplicita k q r, PlanExplicito k q (destinoExplicito k q r x :: h) n) :
      PlanExplicito k q h (n + 1)

@[expose] noncomputable def expandirPlanExplicito (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29)
    (s o : Fp) (q : ℕ) {h : List (TranscripcionExplicita k q)} {n : ℕ} :
    PlanExplicito k q h n → PlanRestaurable (RespuestaExplicita k q) (origenExplicito k q)
      (destinoExplicito k q) (estadoExplicito k hk0 hk s o q) h n
  | .terminar h n => .terminar h n
  | .mensaje v hv w paso resto => .mensaje v hv w
      (paso_explicito_conserva_estado k hk0 hk s o q paso)
      (expandirPlanExplicito k hk0 hk s o q resto)
  | .nuevo r hr resto => .nuevo r hr (fun x => expandirPlanExplicito k hk0 hk s o q (resto x))

/-- Evaluación propia por medias uniformes, antes de expandir al modelo genérico. -/
@[expose] noncomputable def valorPlanExplicito (k q : ℕ) (fin : List (TranscripcionExplicita k q) → ℚ) :
    {h : List (TranscripcionExplicita k q)} → {n : ℕ} → PlanExplicito k q h n → ℚ
  | _, _, .terminar h _ => fin h
  | _, _, .mensaje _ _ _ _ resto => valorPlanExplicito k q fin resto
  | _, _, .nuevo r _ resto => promedio (fun x : RespuestaExplicita k q r => valorPlanExplicito k q fin (resto x))

theorem valor_expansion_explicita (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp) (q : ℕ)
    (fin : List (TranscripcionExplicita k q) → ℚ) {h : List (TranscripcionExplicita k q)} {n : ℕ}
    (plan : PlanExplicito k q h n) :
    valorRestaurable (RespuestaExplicita k q) (origenExplicito k q) (destinoExplicito k q)
      (estadoExplicito k hk0 hk s o q) fin (expandirPlanExplicito k hk0 hk s o q plan) =
      valorPlanExplicito k q fin plan := by
  induction plan with
  | terminar => rfl
  | mensaje v hv w paso resto ih => exact ih
  | nuevo r hr resto ih =>
    change promedio (fun x : RespuestaExplicita k q r => _) = promedio (fun x : RespuestaExplicita k q r => _)
    congr 1
    funext x
    exact ih x

@[expose] noncomputable def aceptaRegistroExplicito (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29)
    (s o : Fp) (q : ℕ) (h : List (TranscripcionExplicita k q)) : ℚ := by
  classical
  exact if ∃ v ∈ h, aceptaExplicita k hk0 hk s o q v then 1 else 0

@[expose] noncomputable def probabilidadExplicita (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29)
    (s o : Fp) (q : ℕ) {h : List (TranscripcionExplicita k q)} {B : ℕ}
    (plan : PlanExplicito k q h B) : ℚ :=
  valorPlanExplicito k q (aceptaRegistroExplicito k hk0 hk s o q) plan

theorem probabilidad_expansion_explicita (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) {h : List (TranscripcionExplicita k q)} {B : ℕ} (plan : PlanExplicito k q h B) :
    probabilidadAceptarRegistro (RespuestaExplicita k q) (origenExplicito k q) (destinoExplicito k q)
      (estadoExplicito k hk0 hk s o q) (aceptaExplicita k hk0 hk s o q)
      (expandirPlanExplicito k hk0 hk s o q plan) = probabilidadExplicita k hk0 hk s o q plan :=
  valor_expansion_explicita k hk0 hk s o q _ plan

theorem acepta_explicita_marcada (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (v : TranscripcionExplicita k q) (h : aceptaExplicita k hk0 hk s o q v) :
    estadoExplicito k hk0 hk s o q v = true :=
  acepta_observado_marcado k hk0 hk s o q (codificarExplicita k q v) h

theorem reinicios_explicitos_cota (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) (B : ℕ) (plan : PlanExplicito k q [raizExplicita k q] B) :
    probabilidadExplicita k (by omega) hk s o q plan ≤ min 1 (B * errorRonda k q) := by
  have hD : (dominioCapa k 1).card = 4 * 2 ^ k := parejas_iniciales_torre k k hk (Nat.le_succ k)
  have : ∀ r : PeticionExplicita k q, Nonempty (RespuestaExplicita k q r) :=
    respuestas_explicitas_no_vacias k q (by rw [hD]; exact hq)
  have hε : 0 ≤ errorRonda k q :=
    (show (0 : ℚ) ≤ 1 / (Nexus.Goldilocks.p : ℚ) ^ 2 by positivity).trans (le_max_left _ _)
  have hf : ¬ EnunciadoValido k s o := by
    rintro ⟨A, hA, hval⟩
    exact hfalso A hA hval
  rw [← probabilidad_expansion_explicita k (by omega) hk s o q plan]
  apply aceptacion_desde_raiz (RespuestaExplicita k q) (origenExplicito k q) (destinoExplicito k q)
    (estadoExplicito k (by omega) hk s o q) (aceptaExplicita k (by omega) hk s o q)
    (acepta_explicita_marcada k (by omega) hk s o q) _ hε
    (cambio_explicito_cota k hk0 hk s o q hq) (raizExplicita k q) ?_ B
    (expandirPlanExplicito k (by omega) hk s o q plan)
  cases he : estadoExplicito k (by omega) hk s o q (raizExplicita k q) with
  | false => rfl
  | true => exact False.elim (hf ((estado_explicito_inicial_iff k (by omega) hk s o q).mp he))

theorem reinicios_explicitos_perfiles (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) (s o : Fp)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (B : ℕ) (plan : PlanExplicito k 40 [raizExplicita k 40] B) :
    probabilidadExplicita k (by omega) (by omega) s o 40 plan ≤
      min 1 (B * Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8)) := by
  have hc := reinicios_explicitos_cota k hk0 (by omega) s o hfalso 40
    (Nexus.Modelos.Omision.muestras_perfiles k hk0) B plan
  simpa only [error_ronda_perfiles k hk0 hk1] using hc

end Nexus.Goldilocks
