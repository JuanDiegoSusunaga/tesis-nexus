module

public import Nexus.N06.ReiniciosIdeal
import Mathlib.Tactic

/-!
# Políticas de oráculos elegidas adaptativamente entre reinicios

Cada nodo conserva su propia política. Un mensaje puede elegir otra política
para un nodo nuevo con la misma marca, sin cambiar ningún nodo ya guardado.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

inductive NodoAdaptativo (k : ℕ) where
  | raiz
  | guardado (p : PoliticaConsulta) (v : NodoIdeal k)

structure PeticionAdaptativa (k : ℕ) where
  politica : PoliticaConsulta
  ronda : PeticionIdeal k

abbrev RespuestaAdaptativa (k q : ℕ) (r : PeticionAdaptativa k) := RespuestaIdeal k q r.ronda

noncomputable instance (k q : ℕ) (r : PeticionAdaptativa k) : Fintype (RespuestaAdaptativa k q r) :=
  fintypeRespuestaIdeal k q r.ronda

@[expose] def origenAdaptativo (k : ℕ) (r : PeticionAdaptativa k) : NodoAdaptativo k :=
  .guardado r.politica (origenIdeal k r.ronda)

@[expose] noncomputable def destinoAdaptativo (k : ℕ) (hk : k ≤ 29) (s o : Fp) (q : ℕ)
    (r : PeticionAdaptativa k) (x : RespuestaAdaptativa k q r) : NodoAdaptativo k :=
  .guardado r.politica (destinoIdeal k hk s o r.politica q r.ronda x)

@[expose] noncomputable def marcaAdaptativa (k : ℕ) (hk : k ≤ 29) (s o : Fp) : NodoAdaptativo k → Bool
  | .raiz => false
  | .guardado p v => marcaNodo k hk s o p v

@[expose] noncomputable def aceptaAdaptativo (k : ℕ) (hk : k ≤ 29) (s o : Fp) : NodoAdaptativo k → Prop
  | .raiz => False
  | .guardado p v => aceptaNodo k hk s o p v

theorem acepta_adaptativo_marcado (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (v : NodoAdaptativo k) (hv : aceptaAdaptativo k hk s o v) :
    marcaAdaptativa k hk s o v = true := by
  cases v with
  | raiz => exact hv.elim
  | guardado p v => exact acepta_nodo_marcado k hk s o p v hv

theorem cambio_adaptativo_cota (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) (r : PeticionAdaptativa k) :
    cambioFresco (RespuestaAdaptativa k q) (origenAdaptativo k) (destinoAdaptativo k hk s o q)
      (marcaAdaptativa k hk s o) r ≤ errorRonda k q := by
  apply (le_of_eq ?_).trans
    (cambio_ideal_certificado k hk s o r.politica q (errorRonda k q)
      (solidez_por_rondas k hk0 hk s o r.politica hfalso q hq) r.ronda)
  unfold cambioFresco
  apply promedio_entre_instancias
  intro x
  rfl

abbrev PlanAdaptativo (k : ℕ) (hk : k ≤ 29) (s o : Fp) (q B : ℕ) :=
  PlanRestaurable (RespuestaAdaptativa k q) (origenAdaptativo k) (destinoAdaptativo k hk s o q)
    (marcaAdaptativa k hk s o) [.raiz] B

@[expose] noncomputable def probabilidadAdaptativa (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (q B : ℕ) (plan : PlanAdaptativo k hk s o q B) : ℚ :=
  probabilidadAceptarRegistro (RespuestaAdaptativa k q) (origenAdaptativo k)
    (destinoAdaptativo k hk s o q) (marcaAdaptativa k hk s o) (aceptaAdaptativo k hk s o) plan

theorem reinicios_politicas_adaptativas (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) (B : ℕ) (plan : PlanAdaptativo k hk s o q B) :
    probabilidadAdaptativa k hk s o q B plan ≤ min 1 (B * errorRonda k q) := by
  have hD : (dominioCapa k 1).card = 4 * 2 ^ k := parejas_iniciales_torre k k hk (Nat.le_succ k)
  have hn : ∀ r, Nonempty (RespuestaAdaptativa k q r) := by
    intro r
    exact respuestas_ideales_no_vacias k q (by rw [hD]; exact hq) r.ronda
  exact aceptacion_desde_raiz (RespuestaAdaptativa k q) (origenAdaptativo k)
    (destinoAdaptativo k hk s o q) (marcaAdaptativa k hk s o) (aceptaAdaptativo k hk s o)
    (acepta_adaptativo_marcado k hk s o) (errorRonda k q)
    ((show (0 : ℚ) ≤ 1 / (p : ℚ) ^ 2 by positivity).trans (le_max_left _ _))
    (cambio_adaptativo_cota k hk0 hk s o hfalso q hq) .raiz rfl B plan

theorem reinicios_adaptativos_perfiles (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) (s o : Fp)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (B : ℕ) (plan : PlanAdaptativo k (by omega) s o 40 B) :
    probabilidadAdaptativa k (by omega) s o 40 B plan ≤
      min 1 (B * Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8)) := by
  have hb := reinicios_politicas_adaptativas k hk0 (by omega) s o hfalso 40
    (Nexus.Modelos.Omision.muestras_perfiles k hk0) B plan
  simpa only [error_ronda_perfiles k hk0 hk1] using hb

theorem reinicios_adaptativos_promedio {S : Type} [Fintype S] [Nonempty S]
    (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) (s o : Fp)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (B : ℕ) (planes : S → PlanAdaptativo k (by omega) s o 40 B) :
    promedio (fun z => probabilidadAdaptativa k (by omega) s o 40 B (planes z)) ≤
      min 1 (B * Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8)) := by
  exact promedio_cota _ _ (fun z => reinicios_adaptativos_perfiles k hk0 hk1 s o hfalso B (planes z))

end Nexus.Goldilocks
