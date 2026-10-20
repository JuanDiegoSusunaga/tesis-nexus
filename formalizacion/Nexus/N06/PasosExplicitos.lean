module

public import Nexus.N06.ExtensionRetos
import Mathlib.Tactic

/-!
# Pasos de mensajes sobre datos explícitos

El destino contiene los datos emitidos después del paso. La compatibilidad
exige que esos datos, restringidos al origen, reproduzcan sus mensajes.
No se recibe una igualdad de estados como permiso para modificar el registro.
La gramática es exactamente PasoSinReto y admite el contenido de cualquier
política compatible. Los oráculos siguen siendo funciones matemáticas completas.
-/

public section
namespace Nexus.Goldilocks

open Nexus.N06

theorem mismos_mensajes_antes_paso (k q : ℕ) (p r : PoliticaConsulta)
    {t u : TranscripcionCausal k q} (paso : PasoSinReto k q t u)
    (h : MismosMensajes k q p r u) : MismosMensajes k q p r t := by
  cases paso with
  | inicial => trivial
  | abrirTraza a => exact h.1
  | capaTraza a j bt =>
    refine ⟨h.1, fun i hi => h.2 i ?_⟩
    have hj : j.val < k := j.isLt
    simp only [capasEmitidas, Bool.false_eq_true, false_and, ite_false, Nat.add_zero] at hi
    simp only [capasEmitidas, and_true, hj, ite_true]
    omega
  | cerrarTraza a bt listo =>
    refine ⟨h.1, fun i hi => h.2.1 i ?_⟩
    simpa only [capasEmitidas, lt_self_iff_false, and_false, ite_false, Nat.add_zero] using hi
  | capaComposicion a bt j bc =>
    refine ⟨h.1, h.2.1, h.2.2.1, h.2.2.2.1, fun i hi => h.2.2.2.2 i ?_⟩
    have hj : j.val < k + 1 := j.isLt
    simp only [capasEmitidas, Bool.false_eq_true, false_and, ite_false, Nat.add_zero] at hi
    simp only [capasEmitidas, and_true, hj, ite_true]
    omega
  | cerrarComposicion a bt bc listo =>
    refine ⟨h.inicial, h.traza, h.constanteTraza, ?_, fun i hi => h.composicion i ?_⟩
    · exact h.composicion 0 (by omega)
    · simpa only [capasEmitidas, lt_self_iff_false, and_false, ite_false, Nat.add_zero] using hi

/-- Un paso de la gramática y la igualdad de todos los mensajes ya fijados. -/
structure PasoExplicito (k q : ℕ) (v w : TranscripcionExplicita k q) where
  paso : PasoSinReto k q v.1 w.1
  anteriores : capturarMensajes k q (politicaDeDatos k q w.1 w.2) v.1 = v.2

@[expose] def capturarPasoExplicito (k q : ℕ) (p : PoliticaConsulta)
    {t u : TranscripcionCausal k q} (paso : PasoSinReto k q t u) :
    PasoExplicito k q ⟨t, capturarMensajes k q p t⟩ ⟨u, capturarMensajes k q p u⟩ := by
  refine ⟨paso, ?_⟩
  apply (captura_mensajes_igual_iff k q _ p t).mpr
  apply mismos_mensajes_antes_paso k q _ p paso
  exact (captura_mensajes_igual_iff k q _ p u).mp
    (capturar_realizacion_prefijo k q u (capturarMensajes k q p u))

theorem codificar_origen_paso (k q : ℕ) {v w : TranscripcionExplicita k q}
    (paso : PasoExplicito k q v w) :
    codificarExplicita k q v = observarPrefijo k q (politicaDeDatos k q w.1 w.2) v.1 := by
  rw [← codificar_captura k q (politicaDeDatos k q w.1 w.2) v.1, paso.anteriores]

theorem paso_explicito_conserva_estado (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) {v w : TranscripcionExplicita k q} (paso : PasoExplicito k q v w) :
    estadoExplicito k hk0 hk s o q w = estadoExplicito k hk0 hk s o q v := by
  rw [estadoExplicito, estadoExplicito, codificar_origen_paso k q paso]
  exact paso_sin_reto_conserva_estado k hk s o
    (normalizarTerminal k (politicaDeDatos k q w.1 w.2)) q paso.paso

theorem paso_explicito_iff_observado (k q : ℕ) (v w : TranscripcionExplicita k q) :
    Nonempty (PasoExplicito k q v w) ↔
      ∃ p : PoliticaConsulta, Nonempty (PasoSinReto k q v.1 w.1) ∧
        codificarExplicita k q v = observarPrefijo k q p v.1 ∧
        codificarExplicita k q w = observarPrefijo k q p w.1 := by
  constructor
  · rintro ⟨paso⟩
    exact ⟨politicaDeDatos k q w.1 w.2, ⟨paso.paso⟩,
      codificar_origen_paso k q paso, rfl⟩
  · rintro ⟨p, ⟨paso⟩, hv, hw⟩
    have hv' : v = ⟨v.1, capturarMensajes k q p v.1⟩ :=
      codificacion_inyectiva k q (hv.trans (codificar_captura k q p v.1).symm)
    have hw' : w = ⟨w.1, capturarMensajes k q p w.1⟩ :=
      codificacion_inyectiva k q (hw.trans (codificar_captura k q p w.1).symm)
    exact ⟨hv' ▸ hw' ▸ capturarPasoExplicito k q p paso⟩

end Nexus.Goldilocks
