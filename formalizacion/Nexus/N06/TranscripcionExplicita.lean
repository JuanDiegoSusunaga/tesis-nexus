module

public import Nexus.N06.DatosTranscripcion
import Mathlib.Tactic

/-!
# Equivalencia entre prefijos observados y transcripciones con datos explícitos

La fase y los retos se acompañan de los oráculos y constantes emitidos.
La codificación y decodificación son inversas; transportan el estado y la
aceptación sin imponer una política futura ni una hipótesis de seguridad nueva.
-/

public section
namespace Nexus.Goldilocks

open Nexus.N06

abbrev TranscripcionExplicita (k q : ℕ) := (t : TranscripcionCausal k q) × MensajesExplicitos k q t

@[expose] def codificarExplicita (k q : ℕ) (v : TranscripcionExplicita k q) : PrefijoObservado k q :=
  observarPrefijo k q (politicaDeDatos k q v.1 v.2) v.1

@[expose] def decodificarObservado (k q : ℕ) (v : PrefijoObservado k q) : TranscripcionExplicita k q :=
  ⟨v.1, Quotient.lift (fun p => capturarMensajes k q p v.1)
    (fun p r h => (captura_mensajes_igual_iff k q p r v.1).mpr h) v.2⟩

theorem decodificar_codificar (k q : ℕ) (v : TranscripcionExplicita k q) :
    decodificarObservado k q (codificarExplicita k q v) = v := by
  rcases v with ⟨t, d⟩
  change (⟨t, capturarMensajes k q (politicaDeDatos k q t d) t⟩ : TranscripcionExplicita k q) = ⟨t, d⟩
  rw [capturar_realizacion_prefijo]

theorem codificar_decodificar (k q : ℕ) (v : PrefijoObservado k q) :
    codificarExplicita k q (decodificarObservado k q v) = v := by
  rcases v with ⟨t, c⟩
  induction c using Quotient.inductionOn with
  | h p =>
    apply mismos_mensajes_misma_observacion k q (politicaDeDatos k q t (capturarMensajes k q p t)) p t
    apply (captura_mensajes_igual_iff k q _ p t).mp
    exact capturar_realizacion_prefijo k q t (capturarMensajes k q p t)

@[expose] def equivalenciaExplicita (k q : ℕ) : TranscripcionExplicita k q ≃ PrefijoObservado k q where
  toFun := codificarExplicita k q
  invFun := decodificarObservado k q
  left_inv := decodificar_codificar k q
  right_inv := codificar_decodificar k q

theorem codificar_captura (k q : ℕ) (p : PoliticaConsulta) (t : TranscripcionCausal k q) :
    codificarExplicita k q ⟨t, capturarMensajes k q p t⟩ = observarPrefijo k q p t :=
  codificar_decodificar k q (observarPrefijo k q p t)

theorem codificacion_inyectiva (k q : ℕ) : Function.Injective (codificarExplicita k q) :=
  (equivalenciaExplicita k q).injective

theorem codificacion_sobreyectiva (k q : ℕ) : Function.Surjective (codificarExplicita k q) :=
  (equivalenciaExplicita k q).surjective

@[expose] noncomputable def estadoExplicito (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29)
    (s o : Fp) (q : ℕ) (v : TranscripcionExplicita k q) : Bool :=
  estadoObservado k hk0 hk s o q (codificarExplicita k q v)

@[expose] noncomputable def aceptaExplicita (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29)
    (s o : Fp) (q : ℕ) (v : TranscripcionExplicita k q) : Prop :=
  aceptaObservado k hk0 hk s o q (codificarExplicita k q v)

theorem estado_explicito_captura (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (p : PoliticaConsulta) (t : TranscripcionCausal k q) :
    estadoExplicito k hk0 hk s o q ⟨t, capturarMensajes k q p t⟩ =
      estadoCausal k hk s o (normalizarTerminal k p) q t := by
  rw [estadoExplicito, codificar_captura, estado_observado_coincide]

theorem aceptacion_explicita_captura (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (p : PoliticaConsulta) (t : TranscripcionCausal k q) :
    aceptaExplicita k hk0 hk s o q ⟨t, capturarMensajes k q p t⟩ ↔
      aceptaCausal k hk s o (normalizarTerminal k p) q t := by
  rw [aceptaExplicita, codificar_captura, acepta_observado_coincide]

theorem estado_explicito_inicial_iff (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) :
    estadoExplicito k hk0 hk s o q ⟨.vacia, PUnit.unit⟩ = true ↔ EnunciadoValido k s o :=
  estado_observado_inicial_iff k hk0 hk s o q politicaCero

theorem estado_explicito_cero_rechaza (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (v : TranscripcionExplicita k q) (h : estadoExplicito k hk0 hk s o q v = false) :
    ¬ aceptaExplicita k hk0 hk s o q v :=
  estado_observado_cero_rechaza k hk0 hk s o q (codificarExplicita k q v) h

theorem estado_explicito_valido (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (v : TranscripcionExplicita k q) (hv : EnunciadoValido k s o) :
    estadoExplicito k hk0 hk s o q v = true :=
  estado_observado_valido k hk0 hk s o q (codificarExplicita k q v) hv

theorem mensaje_explicito_conserva_estado (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (p : PoliticaConsulta) {t u : TranscripcionCausal k q} (paso : PasoSinReto k q t u) :
    estadoExplicito k hk0 hk s o q ⟨u, capturarMensajes k q p u⟩ =
      estadoExplicito k hk0 hk s o q ⟨t, capturarMensajes k q p t⟩ := by
  rw [estado_explicito_captura, estado_explicito_captura]
  exact paso_sin_reto_conserva_estado k hk s o (normalizarTerminal k p) q paso

end Nexus.Goldilocks
