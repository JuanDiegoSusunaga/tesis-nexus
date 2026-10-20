module

public import Nexus.N06.OraculosEmitidos
import Mathlib.Tactic

/-!
# Datos explícitos y realización de cada prefijo tipado

Los mensajes son arreglos de funciones y constantes. Una política fija
construida a partir de esos datos los reproduce sobre el prefijo indicado.
Esto realiza los datos de un prefijo, sin afirmar todavía su alcanzabilidad
desde la transcripción vacía por una gramática completa de mensajes.
-/

public section
namespace Nexus.Goldilocks

open Nexus.N06

@[ext] structure DatosTraza (k : ℕ) where
  oraculos : OraculosEmitidos k
  constante : Fp2

@[ext] structure DatosFinales (k : ℕ) where
  traza : DatosTraza k
  composicion : OraculosEmitidos (k + 1)
  constanteComposicion : Fp2

abbrev MensajesExplicitos (k q : ℕ) : TranscripcionCausal k q → Type
  | .vacia => PUnit
  | .air _ _ => Fp2 → Fp2
  | .traza _ j _ listo => OraculosEmitidos (capasEmitidas k j listo)
  | .composicion _ _ j _ listo => DatosTraza k × OraculosEmitidos (capasEmitidas (k + 1) j listo)
  | .consulta _ _ _ => DatosFinales k
  | .salida _ _ _ _ => DatosFinales k

@[expose] def capturarDatosTraza (k : ℕ) (p : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 k) : DatosTraza k :=
  ⟨capturarOraculos k (capaTraza p a bt), p.constanteTraza a (listaRetos bt)⟩

@[expose] def capturarDatosFinales (k : ℕ) (p : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) : DatosFinales k :=
  ⟨capturarDatosTraza k p a bt, capturarOraculos (k + 1) (capaComposicion p a bt bc),
    p.constanteComposicion a (listaRetos bt) (listaRetos bc)⟩

@[expose] def capturarMensajes (k q : ℕ) (p : PoliticaConsulta) :
    (t : TranscripcionCausal k q) → MensajesExplicitos k q t
  | .vacia => PUnit.unit
  | .air _ _ => p.inicial
  | .traza a j bt listo => capturarOraculos (capasEmitidas k j listo) (capaTraza p a bt)
  | .composicion a bt j bc listo =>
      (capturarDatosTraza k p a bt, capturarOraculos (capasEmitidas (k + 1) j listo) (capaComposicion p a bt bc))
  | .consulta a bt bc => capturarDatosFinales k p a bt bc
  | .salida a bt bc _ => capturarDatosFinales k p a bt bc

theorem capa_traza_inicial_datos {n : ℕ} (p : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 n) : capaTraza p a bt 0 = p.inicial := rfl

theorem capa_composicion_inicial_datos {k n : ℕ} (p : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 k) (bc : Retos Fp2 n) : capaComposicion p a bt bc 0 = inicioComposicion p a bt := rfl

theorem captura_datos_traza_igual_iff (k : ℕ) (p r : PoliticaConsulta)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) :
    capturarDatosTraza k p a bt = capturarDatosTraza k r a bt ↔
      p.inicial = r.inicial ∧ (∀ i < k, capaTraza p a bt i = capaTraza r a bt i) ∧
      p.constanteTraza a (listaRetos bt) = r.constanteTraza a (listaRetos bt) := by
  simp only [capturarDatosTraza, DatosTraza.mk.injEq, captura_oraculos_igual_iff,
    capa_traza_inicial_datos, and_assoc]

theorem captura_datos_finales_igual_iff (k : ℕ) (p r : PoliticaConsulta)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) :
    capturarDatosFinales k p a bt bc = capturarDatosFinales k r a bt bc ↔ MensajesFinales k p r a bt bc := by
  constructor
  · intro h
    obtain ⟨hi, ht, hct⟩ := (captura_datos_traza_igual_iff k p r a bt).mp (congrArg DatosFinales.traza h)
    have hc := (captura_oraculos_igual_iff (k + 1) _ _).mp (congrArg DatosFinales.composicion h)
    exact ⟨hi, ht, hc.2, hct, congrArg DatosFinales.constanteComposicion h⟩
  · intro h
    apply DatosFinales.ext
    · exact (captura_datos_traza_igual_iff k p r a bt).mpr ⟨h.inicial, h.traza, h.constanteTraza⟩
    · exact (captura_oraculos_igual_iff (k + 1) _ _).mpr ⟨h.composicion 0 (by omega), h.composicion⟩
    · exact h.constanteComposicion

theorem captura_mensajes_igual_iff (k q : ℕ) (p r : PoliticaConsulta) (t : TranscripcionCausal k q) :
    capturarMensajes k q p t = capturarMensajes k q r t ↔ MismosMensajes k q p r t := by
  cases t with
  | vacia => exact ⟨fun _ => trivial, fun _ => rfl⟩
  | air => exact Iff.rfl
  | traza a j bt listo =>
    simpa only [capturarMensajes, MismosMensajes, capa_traza_inicial_datos] using
      captura_oraculos_igual_iff (capasEmitidas k j listo) (capaTraza p a bt) (capaTraza r a bt)
  | composicion a bt j bc listo =>
    simp only [capturarMensajes, MismosMensajes, Prod.mk.injEq,
      captura_datos_traza_igual_iff, captura_oraculos_igual_iff, capa_composicion_inicial_datos]
    tauto
  | consulta a bt bc => exact captura_datos_finales_igual_iff k p r a bt bc
  | salida a bt bc S => exact captura_datos_finales_igual_iff k p r a bt bc

@[expose] def politicaFija (t c : ℕ → Fp2 → Fp2) (ct cc : Fp2) : PoliticaConsulta where
  inicial := t 0
  traza := fun _ j _ => t j
  composicion := fun _ _ j _ => c j
  constanteTraza := fun _ _ => ct
  constanteComposicion := fun _ _ _ => cc

theorem capa_politica_fija_traza (t c : ℕ → Fp2 → Fp2) (ct cc : Fp2)
    {n : ℕ} (a : Retos Fp2 3) (bt : Retos Fp2 n) :
    capaTraza (politicaFija t c ct cc) a bt = t := by
  funext i
  by_cases hi : i = 0 <;> simp only [capaTraza, estrategiaTraza, politicaFija, hi, reduceIte]

theorem capa_politica_fija_composicion (t c : ℕ → Fp2 → Fp2) (ct cc : Fp2)
    {k n : ℕ} (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 n) :
    capaComposicion (politicaFija t c ct cc) a bt bc = c := rfl

@[expose] def politicaDeDatosFinales {k : ℕ} (d : DatosFinales k) : PoliticaConsulta :=
  politicaFija (leerOraculo d.traza.oraculos) (leerOraculo d.composicion)
    d.traza.constante d.constanteComposicion

@[expose] def politicaDeDatos (k q : ℕ) : (t : TranscripcionCausal k q) → MensajesExplicitos k q t → PoliticaConsulta
  | .vacia, _ => politicaCero
  | .air _ _, d => politicaFija (fun _ => d) (fun _ _ => 0) 0 0
  | .traza _ _ _ _, d => politicaFija (leerOraculo d) (fun _ _ => 0) 0 0
  | .composicion _ _ _ _ _, d =>
      politicaFija (leerOraculo d.1.oraculos) (leerOraculo d.2) d.1.constante 0
  | .consulta _ _ _, d => politicaDeDatosFinales d
  | .salida _ _ _ _, d => politicaDeDatosFinales d

theorem capturar_realizacion_final (k : ℕ) (a : Retos Fp2 3) (bt : Retos Fp2 k)
    (bc : Retos Fp2 (k + 1)) (d : DatosFinales k) :
    capturarDatosFinales k (politicaDeDatosFinales d) a bt bc = d := by
  simp only [capturarDatosFinales, capturarDatosTraza, politicaDeDatosFinales]
  simp only [capa_politica_fija_traza, capa_politica_fija_composicion, capturar_lectura_oraculos]
  rfl

theorem capturar_realizacion_prefijo (k q : ℕ) (t : TranscripcionCausal k q) (d : MensajesExplicitos k q t) :
    capturarMensajes k q (politicaDeDatos k q t d) t = d := by
  cases t with
  | vacia => exact Subsingleton.elim _ _
  | air => rfl
  | traza =>
    simp only [capturarMensajes, politicaDeDatos, capa_politica_fija_traza, capturar_lectura_oraculos]
  | composicion =>
    simp only [capturarMensajes, politicaDeDatos, capturarDatosTraza]
    simp only [capa_politica_fija_traza, capa_politica_fija_composicion, capturar_lectura_oraculos]
    exact Prod.eta d
  | consulta a bt bc => exact capturar_realizacion_final k a bt bc d
  | salida a bt bc S => exact capturar_realizacion_final k a bt bc d

end Nexus.Goldilocks
