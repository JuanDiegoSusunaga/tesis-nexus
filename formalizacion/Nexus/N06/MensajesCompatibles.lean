module

public import Nexus.N06.TerminalesConstantes
import Mathlib.Tactic

/-!
# El estado pertenece al prefijo de mensajes, no a una política futura

Dos políticas se identifican cuando coinciden en los oráculos y constantes
ya emitidos. El cociente conserva la fase y los retos, y olvida todas las
decisiones fuera de ese prefijo. La capa terminal se obtiene de la constante.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

@[expose] def capasEmitidas (m n : ℕ) (listo : Bool) : ℕ :=
  n + if listo = true ∧ n < m then 1 else 0

structure MensajesFinales (k : ℕ) (p r : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) : Prop where
  inicial : p.inicial = r.inicial
  traza : ∀ i < k, capaTraza p a bt i = capaTraza r a bt i
  composicion : ∀ i < k + 1, capaComposicion p a bt bc i = capaComposicion r a bt bc i
  constanteTraza : p.constanteTraza a (listaRetos bt) = r.constanteTraza a (listaRetos bt)
  constanteComposicion : p.constanteComposicion a (listaRetos bt) (listaRetos bc) =
    r.constanteComposicion a (listaRetos bt) (listaRetos bc)

theorem mensajes_finales_normalizados (k : ℕ) (hk : 0 < k) (p r : PoliticaConsulta)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (h : MensajesFinales k p r a bt bc) :
    AcuerdoFinal k (normalizarTerminal k p) (normalizarTerminal k r) a bt bc := by
  refine ⟨h.inicial, ?_, ?_, h.constanteTraza, h.constanteComposicion⟩
  · intro i hi
    by_cases hit : i = k
    · subst i
      rw [capa_traza_terminal_constante k hk, capa_traza_terminal_constante k hk, h.constanteTraza]
    · rw [capa_traza_normalizada_anterior k k p a bt i (by omega),
        capa_traza_normalizada_anterior k k r a bt i (by omega), h.traza i (by omega)]
  · intro i hi
    by_cases hic : i = k + 1
    · subst i
      rw [capa_composicion_terminal_constante, capa_composicion_terminal_constante, h.constanteComposicion]
    · rw [capa_composicion_normalizada_anterior k (k + 1) p a bt bc i (by omega),
        capa_composicion_normalizada_anterior k (k + 1) r a bt bc i (by omega), h.composicion i (by omega)]

@[expose] def MismosMensajes (k q : ℕ) (p r : PoliticaConsulta) : TranscripcionCausal k q → Prop
  | .vacia => True
  | .air _ _ => p.inicial = r.inicial
  | .traza a j bt listo => p.inicial = r.inicial ∧
      ∀ i < capasEmitidas k j listo, capaTraza p a bt i = capaTraza r a bt i
  | .composicion a bt j bc listo => p.inicial = r.inicial ∧
      (∀ i < k, capaTraza p a bt i = capaTraza r a bt i) ∧
      p.constanteTraza a (listaRetos bt) = r.constanteTraza a (listaRetos bt) ∧
      inicioComposicion p a bt = inicioComposicion r a bt ∧
      ∀ i < capasEmitidas (k + 1) j listo, capaComposicion p a bt bc i = capaComposicion r a bt bc i
  | .consulta a bt bc => MensajesFinales k p r a bt bc
  | .salida a bt bc _ => MensajesFinales k p r a bt bc

theorem mismos_mensajes_compatible (k : ℕ) (hk : 0 < k) (p r : PoliticaConsulta)
    (q : ℕ) (t : TranscripcionCausal k q) (h : MismosMensajes k q p r t) :
    CompatibleCausal k q (normalizarTerminal k p) (normalizarTerminal k r) t := by
  cases t with
  | vacia => trivial
  | air => exact h
  | traza a j bt listo =>
    refine ⟨h.1, ?_⟩
    intro i hi
    have hib : i < capasEmitidas k j listo := by unfold capasEmitidas; omega
    rw [capa_traza_normalizada_anterior k j p a bt i (by omega),
      capa_traza_normalizada_anterior k j r a bt i (by omega), h.2 i hib]
  | composicion a bt j bc listo =>
    refine ⟨h.1, ?_, ?_, ?_⟩
    · intro i hi
      rw [capa_traza_normalizada_anterior k k p a bt i hi,
        capa_traza_normalizada_anterior k k r a bt i hi, h.2.1 i hi]
    · simpa only [inicio_composicion_normalizado] using h.2.2.2.1
    · intro i hi
      have hib : i < capasEmitidas (k + 1) j listo := by unfold capasEmitidas; omega
      rw [capa_composicion_normalizada_anterior k j p a bt bc i (by omega),
        capa_composicion_normalizada_anterior k j r a bt bc i (by omega), h.2.2.2.2 i hib]
  | consulta a bt bc =>
    have hf := mensajes_finales_normalizados k hk p r a bt bc h
    exact ⟨hf.inicial, fun i hi => hf.traza i (by omega), fun i hi => hf.composicion i (by omega)⟩
  | salida a bt bc S => exact mensajes_finales_normalizados k hk p r a bt bc h

theorem estado_mismos_mensajes (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (p r : PoliticaConsulta) (q : ℕ) (t : TranscripcionCausal k q) (h : MismosMensajes k q p r t) :
    estadoCausal k hk s o (normalizarTerminal k p) q t =
      estadoCausal k hk s o (normalizarTerminal k r) q t :=
  estado_causal_congruente k hk s o _ _ q t (mismos_mensajes_compatible k hk0 p r q t h)

theorem mensajes_reflexivos (k q : ℕ) (p : PoliticaConsulta) (t : TranscripcionCausal k q) :
    MismosMensajes k q p p t := by
  cases t with
  | vacia => trivial
  | air => rfl
  | traza => exact ⟨rfl, fun _ _ => rfl⟩
  | composicion => exact ⟨rfl, fun _ _ => rfl, rfl, rfl, fun _ _ => rfl⟩
  | consulta => exact ⟨rfl, fun _ _ => rfl, fun _ _ => rfl, rfl, rfl⟩
  | salida => exact ⟨rfl, fun _ _ => rfl, fun _ _ => rfl, rfl, rfl⟩

theorem mensajes_simetricos (k q : ℕ) (p r : PoliticaConsulta) (t : TranscripcionCausal k q)
    (h : MismosMensajes k q p r t) : MismosMensajes k q r p t := by
  cases t with
  | vacia => trivial
  | air => exact h.symm
  | traza => exact ⟨h.1.symm, fun i hi => (h.2 i hi).symm⟩
  | composicion => exact ⟨h.1.symm, fun i hi => (h.2.1 i hi).symm, h.2.2.1.symm,
      h.2.2.2.1.symm, fun i hi => (h.2.2.2.2 i hi).symm⟩
  | consulta => exact ⟨h.inicial.symm, fun i hi => (h.traza i hi).symm,
      fun i hi => (h.composicion i hi).symm, h.constanteTraza.symm, h.constanteComposicion.symm⟩
  | salida => exact ⟨h.inicial.symm, fun i hi => (h.traza i hi).symm,
      fun i hi => (h.composicion i hi).symm, h.constanteTraza.symm, h.constanteComposicion.symm⟩

theorem mensajes_transitivos (k q : ℕ) (p r v : PoliticaConsulta) (t : TranscripcionCausal k q)
    (h : MismosMensajes k q p r t) (g : MismosMensajes k q r v t) : MismosMensajes k q p v t := by
  cases t with
  | vacia => trivial
  | air => exact h.trans g
  | traza => exact ⟨h.1.trans g.1, fun i hi => (h.2 i hi).trans (g.2 i hi)⟩
  | composicion => exact ⟨h.1.trans g.1, fun i hi => (h.2.1 i hi).trans (g.2.1 i hi),
      h.2.2.1.trans g.2.2.1, h.2.2.2.1.trans g.2.2.2.1,
      fun i hi => (h.2.2.2.2 i hi).trans (g.2.2.2.2 i hi)⟩
  | consulta => exact ⟨h.inicial.trans g.inicial, fun i hi => (h.traza i hi).trans (g.traza i hi),
      fun i hi => (h.composicion i hi).trans (g.composicion i hi),
      h.constanteTraza.trans g.constanteTraza, h.constanteComposicion.trans g.constanteComposicion⟩
  | salida => exact ⟨h.inicial.trans g.inicial, fun i hi => (h.traza i hi).trans (g.traza i hi),
      fun i hi => (h.composicion i hi).trans (g.composicion i hi),
      h.constanteTraza.trans g.constanteTraza, h.constanteComposicion.trans g.constanteComposicion⟩

@[expose] def equivalenciaMensajes (k q : ℕ) (t : TranscripcionCausal k q) : Setoid PoliticaConsulta where
  r := fun p r => MismosMensajes k q p r t
  iseqv := ⟨fun p => mensajes_reflexivos k q p t,
    fun h => mensajes_simetricos k q _ _ t h, fun h g => mensajes_transitivos k q _ _ _ t h g⟩

abbrev PrefijoObservado (k q : ℕ) := (t : TranscripcionCausal k q) × Quotient (equivalenciaMensajes k q t)

@[expose] def observarPrefijo (k q : ℕ) (p : PoliticaConsulta) (t : TranscripcionCausal k q) :
    PrefijoObservado k q := ⟨t, Quotient.mk (equivalenciaMensajes k q t) p⟩

@[expose] noncomputable def estadoObservado (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29)
    (s o : Fp) (q : ℕ) (v : PrefijoObservado k q) : Bool :=
  Quotient.lift (fun p => estadoCausal k hk s o (normalizarTerminal k p) q v.1)
    (fun p r h => estado_mismos_mensajes k hk0 hk s o p r q v.1 h) v.2

theorem estado_observado_coincide (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (p : PoliticaConsulta) (t : TranscripcionCausal k q) :
    estadoObservado k hk0 hk s o q (observarPrefijo k q p t) =
      estadoCausal k hk s o (normalizarTerminal k p) q t := rfl

theorem mismos_mensajes_misma_observacion (k q : ℕ) (p r : PoliticaConsulta)
    (t : TranscripcionCausal k q) (h : MismosMensajes k q p r t) :
    observarPrefijo k q p t = observarPrefijo k q r t := by
  exact congrArg (fun c => (⟨t, c⟩ : PrefijoObservado k q)) (Quotient.sound h)

theorem estado_observado_inicial_iff (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (p : PoliticaConsulta) :
    estadoObservado k hk0 hk s o q (observarPrefijo k q p .vacia) = true ↔ EnunciadoValido k s o :=
  estado_causal_inicial_iff k hk s o (normalizarTerminal k p) q

theorem mensaje_con_politica_compatible (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (p r : PoliticaConsulta) {t u : TranscripcionCausal k q}
    (h : MismosMensajes k q p r t) (paso : PasoSinReto k q t u) :
    estadoObservado k hk0 hk s o q (observarPrefijo k q r u) =
      estadoObservado k hk0 hk s o q (observarPrefijo k q p t) := by
  rw [estado_observado_coincide, estado_observado_coincide,
    paso_sin_reto_conserva_estado k hk s o (normalizarTerminal k r) q paso]
  exact (estado_mismos_mensajes k hk0 hk s o p r q t h).symm

end Nexus.Goldilocks
