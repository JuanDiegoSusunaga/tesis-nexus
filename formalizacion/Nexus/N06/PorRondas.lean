module

public import Nexus.N06.EstadoConjunto
import Mathlib.Tactic

/-!
# Certificado de solidez por rondas del modelo interactivo ideal

El estado empieza en cero, los mensajes lo conservan, uno es absorbente,
cada reto tiene una cota condicional y el estado final cero implica rechazo.
La comparación con h_T se verifica en los nueve perfiles de TG2 v1.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

@[expose] def estadoInicial : Bool := false

/-- El contenido del mensaje cambia los próximos monitores, no la marca actual. -/
@[expose] def emitirMensaje {M : Type*} (b : Bool) (_m : M) : Bool := b

@[expose] noncomputable def marcaFinal (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (S : Finset Fp2) : Bool := by
  classical
  exact actualizarMarca (marcaAntesConsulta k hk s o p a bt bc)
    (AceptaCompartida k hk s o (ejecutarPrefijo k p a bt bc) S)

@[expose] noncomputable def cambioConsulta (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (q : ℕ) : ℚ :=
  probabilidadConsulta (dominioCapa k 1) q (fun S =>
    marcaAntesConsulta k hk s o p a bt bc = false ∧ marcaFinal k hk s o p a bt bc S = true)

theorem estado_inicial_cero : estadoInicial = false := rfl

theorem mensajes_conservan_estado {M : Type*} (b : Bool) (m : M) : emitirMensaje b m = b := rfl

theorem estado_final_cero_rechaza (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (S : Finset Fp2) (h : marcaFinal k hk s o p a bt bc S = false) :
    ¬ AceptaCompartida k hk s o (ejecutarPrefijo k p a bt bc) S := by
  classical
  exact (marca_cero_iff _ _).mp h |>.2

theorem aceptacion_activa_estado (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (S : Finset Fp2) (ha : AceptaCompartida k hk s o (ejecutarPrefijo k p a bt bc) S) :
    marcaFinal k hk s o p a bt bc S = true := by
  simp only [marcaFinal, actualizarMarca, ha, decide_true, Bool.or_true]

theorem cambio_consulta_condicional (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) :
    cambioConsulta k hk s o p a bt bc q ≤ Nexus.N05.H (4 * 2 ^ k) q (1 / 8) := by
  classical
  cases hb : marcaAntesConsulta k hk s o p a bt bc with
  | false =>
    have hs := (estado_cero_iff_prefijo_seguro k hk0 hk s o p hfalso a bt bc).mp hb
    apply (consulta_monotona _ q _ _ ?_).trans
      (consulta_compartida_perfil k hk0 hk s o _ hs q hq)
    intro S _ ha
    have hacc := ha.2
    simpa only [marcaFinal, hb, actualizarMarca, Bool.false_or, decide_eq_true_eq] using hacc
  | true =>
    have hz : cambioConsulta k hk s o p a bt bc q = 0 := by
      simp [cambioConsulta, probabilidadConsulta, hb]
    rw [hz]
    unfold Nexus.N05.H
    positivity

@[expose] noncomputable def errorRonda (k q : ℕ) : ℚ :=
  max (1 / (p : ℚ) ^ 2) (max ((4 * 2 ^ k : ℕ) / (p : ℚ) ^ 2)
    (Nexus.N05.H (4 * 2 ^ k) q (1 / 8)))

/-- Las propiedades se refieren a las transiciones concretas definidas arriba. -/
structure CertificadoRondas (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q : ℕ) (ε : ℚ) : Prop where
  inicial : estadoInicial = false
  mensajes : ∀ (b : Bool) (m : Fp2 → Fp2), emitirMensaje b m = b
  absorbente : ∀ (P : Prop) (d : Decidable P), @actualizarMarca true P d = true
  air : ∀ i estado b, probabilidadCambio b
    (excepcionesCriticas (residuosVigilados k s o p) i estado) ≤ ε
  traza : ∀ a (j : Fin k) h b, probabilidadCambio b (monitorTraza k hk p a j h) ≤ ε
  composicion : ∀ a bt (j : Fin (k + 1)) h b,
    probabilidadCambio b (monitorComposicion k hk p a bt j h) ≤ ε
  consulta : ∀ a bt bc, cambioConsulta k hk s o p a bt bc q ≤ ε
  rechazo : ∀ a bt bc S, marcaFinal k hk s o p a bt bc S = false →
    ¬ AceptaCompartida k hk s o (ejecutarPrefijo k p a bt bc) S

theorem solidez_por_rondas (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) :
    CertificadoRondas k hk s o p q (errorRonda k q) := by
  refine ⟨estado_inicial_cero, mensajes_conservan_estado,
    (fun P d => @marca_absorbente P d), ?_, ?_, ?_, ?_, estado_final_cero_rechaza k hk s o p⟩
  · intro i estado b
    exact (cambio_air_condicional _ i estado b).trans (le_max_left _ _)
  · intro a j h b
    exact (cambio_traza_condicional k hk p a j h b).trans
      ((le_max_left _ _).trans (le_max_right _ _))
  · intro a bt j h b
    exact (cambio_composicion_condicional k hk p a bt j h b).trans
      ((le_max_left _ _).trans (le_max_right _ _))
  · intro a bt bc
    exact (cambio_consulta_condicional k hk0 hk s o p hfalso a bt bc q hq).trans
      ((le_max_right _ _).trans (le_max_right _ _))

set_option maxRecDepth 4096 in
set_option maxHeartbeats 1600000 in
/-- Comparación exacta de los tres errores en los nueve perfiles implementados. -/
theorem error_ronda_perfiles (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) :
    errorRonda k 40 = Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8) := by
  interval_cases k <;>
    norm_num [errorRonda, Nexus.N05.H, p, Nat.choose_eq_descFactorial_div_factorial,
      Nat.descFactorial]

/-- h_T es una cota escogida por ronda, sin afirmar que sea el error óptimo. -/
theorem solidez_por_rondas_perfiles (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (s o : Fp) (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o) :
    CertificadoRondas k (by omega) s o p 40 (Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8)) := by
  have hc := solidez_por_rondas k hk0 (by omega) s o p hfalso 40
    (Nexus.Modelos.Omision.muestras_perfiles k hk0)
  simpa only [error_ronda_perfiles k hk0 hk1] using hc

end Nexus.Goldilocks
