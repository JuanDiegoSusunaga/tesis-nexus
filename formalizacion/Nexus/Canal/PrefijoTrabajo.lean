module

public import Nexus.Canal.PrefijoAIR
import Mathlib.Tactic

/-!
# El canal y sus vectores ya están fijados antes de trabajo o nonce

Se recupera el prefijo anterior al nonce desde el estado incluido en cualquiera
de las dos consultas. La reconstrucción no usa la respuesta de trabajo ni la
de absorción del nonce. Vale en el primer corte, incluidas las preconsultas.
-/

public section
namespace Nexus.Canal.PrefijoTrabajo

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open GramaticaTG2 RegistroRaices ParametrosRecuperados
open Nexus.Verificador.FiltroFalso

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def registro (H : Entrada → Digest) (d : DatosCanal) : List Entrada :=
  RegistroCompleto.prefijo H d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc

@[expose] def estado (H : Entrada → Digest) (d : DatosCanal) : Digest :=
  (RegistroCompleto.evaluar H d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc).composicion.1

@[expose] def consulta (trabajo : Bool) (s : Digest) (n : Nonce) : Entrada :=
  if trabajo then entradaTrabajo s n else entrada s (.nonce n)

theorem longitud_consulta (b : Bool) (s : Digest) (n : Nonce) :
    (consulta b s n).length = if b then 41 else 49 := by
  cases b <;> simp only [consulta, Bool.false_eq_true, ite_false, ite_true,
    trabajo_longitud, longitud_nonce_absorbido]

theorem cabecera_consulta (b : Bool) (s : Digest) (n : Nonce) :
    (consulta b s n).take 32 = s.val := by
  cases b
  · exact LecturaAbsorcion.estado_absorcion s (.nonce n)
  · simp only [consulta, ite_true, entradaTrabajo, cabecera, List.append_assoc]
    exact List.take_left' s.property

theorem estado_en_ventanas (b : Bool) (s : Digest) (n : Nonce) :
    s ∈ ventanas (consulta b s n) :=
  Trayecto.estado_en_ventanas _ s (cabecera_consulta b s n)
    (by rw [longitud_consulta]; cases b <;> decide)

theorem camino (H : Entrada → Digest) (d : DatosCanal) :
    Trayecto.Camino H (registro H d) (estado H d) := by
  let s0 := H (codificar .inicio)
  let s1 := H (entrada s0 (.perfil (ProgramaTG2.perfil d.k d.bits)))
  let s2 := H (entrada s1 (.enunciado (ProgramaTG2.enunciado d.inicio d.salida d.k)))
  let s3 := H (entrada s2 (.raizTraza d.raiz))
  let a := evaluarRetos H 3 s3
  let st := H (entrada a.1 .faseTraza)
  let t := evaluarRaices H d.rt d.vt st
  let sc := H (entrada t.1 .faseComposicion)
  let c := evaluarRaices H d.rc d.vc sc
  have h0 : Trayecto.Camino H [codificar .inicio] s0 := .origen _ (by decide)
  have h1 := TrayectoTG2.agregar_absorcion H h0 (.perfil (ProgramaTG2.perfil d.k d.bits))
  have h2 := TrayectoTG2.agregar_absorcion H h1 (.enunciado (ProgramaTG2.enunciado d.inicio d.salida d.k))
  have h3 := TrayectoTG2.agregar_absorcion H h2 (.raizTraza d.raiz)
  have h4 := TrayectoTG2.prolongar_retos H 3 s3 _ h3
  have h5 := TrayectoTG2.agregar_absorcion H h4 .faseTraza
  have h6 := TrayectoTG2.prolongar_raices H d.rt d.vt st _ h5
  have h7 := TrayectoTG2.agregar_absorcion H h6 .faseComposicion
  have h8 := TrayectoTG2.prolongar_raices H d.rc d.vc sc _ h7
  simpa only [registro, estado, RegistroCompleto.prefijo, RegistroCompleto.evaluar,
    codificar, entrada, etiqueta, datos, absorcion, s0, s1, s2, s3, a, st, t, sc, c,
    List.append_assoc, List.singleton_append, List.cons_append, List.nil_append] using h8

theorem longitud (H : Entrada → Digest) (d : DatosCanal) :
    (registro H d).length + 1 = 12 + 2 * (d.rt.length + d.rc.length) := by
  have h := TrayectoTG2.longitud_cadena H d.k d.bits d.inicio d.salida d.raiz
    d.rt d.rc d.vt d.vc d.nonce
  simpa only [registro, TrayectoTG2.cadena, List.length_append, List.length_singleton] using h

theorem longitud_admisible (H : Entrada → Digest) (d : DatosCanal) (hd : Admisible d) :
    (registro H d).length ≤ 130 := by
  have h := longitud H d
  rw [hd.2.2.1, hd.2.2.2.1] at h
  have hk := hd.1.2
  omega

abbrev Corte {B : ℕ} (fin : Estado B) (defecto : Digest) (d : DatosCanal) (b : Bool) :=
  CorteConsulta (inicial B) fin (consulta b (estado (funcionTabla defecto fin.tabla) d) d.nonce)
    (funcionTabla defecto fin.tabla (consulta b (estado (funcionTabla defecto fin.tabla) d) d.nonce))

theorem registro_antes_corte {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (b : Bool) (c : Corte fin defecto d b) :
    ∀ e ∈ registro (funcionTabla defecto fin.tabla) d,
      buscar c.antes.tabla e = some (funcionTabla defecto fin.tabla e) := by
  exact ReconstruccionSelector.cadena_antes_corte (funcionTabla defecto fin.tabla) r (camino _ d)
    (fun e he => PrefijoAIR.consulta_canonica fin.tabla defecto s d hc e he) c
    (estado_en_ventanas b _ _)

theorem reconstruccion_previa {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (b : Bool) (c : Corte fin defecto d b) :
    Trayecto.recuperar c.antes.tabla 130 (estado (funcionTabla defecto fin.tabla) d) =
      (registro (funcionTabla defecto fin.tabla) d).reverse := by
  exact ReconstruccionSelector.recuperar_antes_corte (funcionTabla defecto fin.tabla) r
    (funcion_tabla_compatible defecto fin.tabla fin.sinRepetidos) (camino _ d)
    (fun e he => PrefijoAIR.consulta_canonica fin.tabla defecto s d hc e he) c
    (estado_en_ventanas b _ _) 130 (longitud_admisible _ d hc.perfil)

@[expose] def cadenaPrevia (t : Tabla Entrada Digest) (s : Digest) (n : Nonce) : List Entrada :=
  (Trayecto.recuperar t 130 s).reverse ++ [entrada s (.nonce n)]

theorem cadena_previa_correcta {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (b : Bool) (c : Corte fin defecto d b) :
    cadenaPrevia c.antes.tabla (estado (funcionTabla defecto fin.tabla) d) d.nonce =
      CanalPrevio.cadena (funcionTabla defecto fin.tabla) d := by
  rw [cadenaPrevia, reconstruccion_previa r defecto s d hc b c, List.reverse_reverse]
  rfl

theorem parametros_previos {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (b : Bool) (c : Corte fin defecto d b) :
    ParametrosRecuperados.leer
      (cadenaPrevia c.antes.tabla (estado (funcionTabla defecto fin.tabla) d) d.nonce) = some d := by
  rw [cadena_previa_correcta r defecto s d hc b c]
  have hb : d.bits < 256 ^ 4 := by rcases hc.perfil.2.1 with h | h <;> rw [h] <;> decide
  exact ParametrosRecuperados.cadena_decodificada (funcionTabla defecto fin.tabla)
    d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc d.nonce
    (by have hk := hc.perfil.1.2; omega) hb

theorem raiz_antes_corte {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (b : Bool) (c : Corte fin defecto d b)
    (a raiz : Digest) (tag : Octeto)
    (he : entradaAbsorcion a tag raiz.val ∈ registro (funcionTabla defecto fin.tabla) d) :
    raiz ∈ marcasEstado c.antes := by
  have hq := registro_antes_corte r defecto s d hc b c _ he
  apply raiz_absorbida_estado c.antes a raiz tag
  rw [← absorcion_raiz_coincide]
  exact List.mem_map.mpr ⟨(_, _), buscar_some_mem _ _ _ hq, rfl⟩

theorem vector_antes_corte {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (b : Bool) (c : Corte fin defecto d b)
    (a raiz : Digest) (tag : Octeto)
    (he : entradaAbsorcion a tag raiz.val ∈ registro (funcionTabla defecto fin.tabla) d) (altura : ℕ) :
    vectorExtraido formatoBytes (funcionTabla defecto c.antes.tabla) (c.antes.tabla.map Prod.fst) altura raiz =
      vectorExtraido formatoBytes (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) altura raiz := by
  exact vector_previo_estable (corte_paso c) c.sufijo defecto raiz
    (marcas_antes_respuesta _ _ (raiz_antes_corte r defecto s d hc b c a raiz tag he)) altura

theorem raiz_en_registro (H : Entrada → Digest) (d : DatosCanal) (raiz : Digest)
    (hr : raiz ∈ d.raiz :: (d.rt ++ d.rc)) :
    ∃ a tag, entradaAbsorcion a tag raiz.val ∈ registro H d := by
  rcases List.mem_cons.mp hr with rfl | hr
  · exact ⟨(RegistroCompleto.evaluar H d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc).base.estado,
      1, (RegistroCompleto.base_registrada H d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc).1⟩
  · rcases List.mem_append.mp hr with hr | hr
    · have he : raiz ∈ (evaluarRaices H d.rt d.vt
          (RegistroCompleto.evaluar H d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc).inicioTraza).2.map Evento.raiz := by
        rw [raices_proyeccion]
        exact hr
      obtain ⟨evento, hev, heq⟩ := List.mem_map.mp he
      subst raiz
      exact ⟨evento.estado, evento.tag,
        (RegistroCompleto.traza_registrada H d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc evento hev).1⟩
    · have he : raiz ∈ (evaluarRaices H d.rc d.vc
          (RegistroCompleto.evaluar H d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc).inicioComposicion).2.map Evento.raiz := by
        rw [raices_proyeccion]
        exact hr
      obtain ⟨evento, hev, heq⟩ := List.mem_map.mp he
      subst raiz
      exact ⟨evento.estado, evento.tag,
        (RegistroCompleto.composicion_registrada H d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc evento hev).1⟩

theorem vista_antes_corte {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (b : Bool) (c : Corte fin defecto d b) :
    VistaSemantica.construir c.antes.tabla defecto d
        (cadenaPrevia c.antes.tabla (estado (funcionTabla defecto fin.tabla) d) d.nonce) =
      VistaSemantica.construir fin.tabla defecto d (ReconstruccionSelector.candidato fin.tabla s) := by
  rw [cadena_previa_correcta r defecto s d hc b c, hc.cadena]
  apply VistaSemantica.vista_conservada
  · change RetosRecuperados.retos (funcionTabla defecto c.antes.tabla)
        (registro (funcionTabla defecto fin.tabla) d ++ [entrada (estado (funcionTabla defecto fin.tabla) d) (.nonce d.nonce)]) =
      RetosRecuperados.retos (funcionTabla defecto fin.tabla)
        (registro (funcionTabla defecto fin.tabla) d ++ [entrada (estado (funcionTabla defecto fin.tabla) d) (.nonce d.nonce)])
    rw [RetosRecuperados.retos_append, RetosRecuperados.retos_append,
      RetosRecuperados.absorcion_sin_reto, RetosRecuperados.absorcion_sin_reto,
      List.append_nil, List.append_nil]
    exact RetosRecuperados.retos_de_tabla (funcionTabla defecto fin.tabla) c.antes.tabla
      (registro (funcionTabla defecto fin.tabla) d) (registro_antes_corte r defecto s d hc b c) defecto
  · intro raiz hr j
    obtain ⟨a, tag, he⟩ := raiz_en_registro (funcionTabla defecto fin.tabla) d raiz hr
    exact VistaSemantica.valor_conservado c.antes.tabla fin.tabla defecto j raiz
      (vector_antes_corte r defecto s d hc b c a raiz tag he j)

@[expose] def vistaPrevia (t : Tabla Entrada Digest) (defecto sc : Digest) (n : Nonce) :
    Option VistaSemantica.Vista :=
  let es := cadenaPrevia t sc n
  (ParametrosRecuperados.leer es).map (fun d => VistaSemantica.construir t defecto d es)

theorem vista_previa_leida {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (b : Bool) (c : Corte fin defecto d b) :
    vistaPrevia c.antes.tabla defecto (estado (funcionTabla defecto fin.tabla) d) d.nonce =
      some (VistaSemantica.construir fin.tabla defecto d (ReconstruccionSelector.candidato fin.tabla s)) := by
  rw [vistaPrevia, parametros_previos r defecto s d hc b c, Option.map_some,
    vista_antes_corte r defecto s d hc b c]

end Nexus.Canal.PrefijoTrabajo
