module

public import Nexus.Canal.OraculosVista
public import Nexus.ROM.CorteLlamadas
import Mathlib.Tactic

/-!
# Cada capa del candidato real estaba fijada antes de su primera E

El candidato se interpreta desde una tabla alcanzada sin aciertos Bad.
Sus raíces no son parámetros fijados antes del experimento: se recuperan
de esa tabla. Para cada capa se construye el corte de primera consulta y
se identifican tanto el oráculo anterior al reto como su respuesta real.
-/

public section
namespace Nexus.Canal.VistaCausal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open VistaSemantica VistaCampo ParametrosRecuperados RegistroRaices
open Nexus.Verificador.FiltroFalso

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def registro (t : Tabla Entrada Digest) (defecto : Digest) (d : DatosCanal) :
    RegistroCompleto.Vista :=
  RegistroCompleto.evaluar (funcionTabla defecto t) d.k d.bits d.inicio d.salida
    d.raiz d.rt d.rc d.vt d.vc

theorem longitud_traza (t : Tabla Entrada Digest) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico t defecto s d) : (registro t defecto d).traza.2.length = d.k := by
  change (evaluarRaices (funcionTabla defecto t) d.rt d.vt _).2.length = d.k
  rw [raices_longitud]
  exact hc.perfil.2.2.1

theorem longitud_composicion (t : Tabla Entrada Digest) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico t defecto s d) : (registro t defecto d).composicion.2.length = d.k + 1 := by
  change (evaluarRaices (funcionTabla defecto t) d.rc d.vc _).2.length = d.k + 1
  rw [raices_longitud]
  exact hc.perfil.2.2.2.1

theorem etiqueta_evento (H : Entrada → Digest) (rs : List Digest) (v : Fp2) (s : Digest)
    (e : Evento) (he : e ∈ (evaluarRaices H rs v s).2) : e.tag = 2 := by
  induction rs generalizing s with
  | nil => simp only [evaluarRaices, List.not_mem_nil] at he
  | cons r rs ih =>
    rcases List.mem_cons.mp he with h | he
    · subst e; rfl
    · exact ih _ he

theorem raiz_por_indice (es : List Evento) (rs : List Digest)
    (h : es.map Evento.raiz = rs) (j : ℕ) (he : j < es.length) (hr : j < rs.length) :
    es[j].raiz = rs[j] := by
  have hi := congrArg (fun xs : List Digest => xs[j]?) h
  simpa only [List.getElem?_map, List.getElem?_eq_getElem he,
    List.getElem?_eq_getElem hr, Option.map_some, Option.some.injEq] using hi

theorem betas_traza (t : Tabla Entrada Digest) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico t defecto s d) :
    betasTraza (construir t defecto d (ReconstruccionSelector.candidato t s)) =
      (registro t defecto d).traza.2.map (beta (funcionTabla defecto t)) := by
  have hcanon := retos_canonicos t defecto s d hc
  have h3 : (registro t defecto d).alfas.2.length = 3 :=
    RegistroCompleto.alfas_tres _ _ _ _ _ _ _ _ _ _
  have ht := longitud_traza t defecto s d hc
  change ((RetosRecuperados.retos (funcionTabla defecto t)
    (ReconstruccionSelector.candidato t s)).drop 3).take d.k = _
  change RetosRecuperados.retos (funcionTabla defecto t) (ReconstruccionSelector.candidato t s) =
    (registro t defecto d).alfas.2 ++
      (registro t defecto d).traza.2.map (beta (funcionTabla defecto t)) ++
      (registro t defecto d).composicion.2.map (beta (funcionTabla defecto t)) at hcanon
  rw [hcanon]
  simp [h3, List.length_map, ht]

theorem betas_composicion (t : Tabla Entrada Digest) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico t defecto s d) :
    betasComposicion (construir t defecto d (ReconstruccionSelector.candidato t s)) =
      (registro t defecto d).composicion.2.map (beta (funcionTabla defecto t)) := by
  have hcanon := retos_canonicos t defecto s d hc
  have h3 : (registro t defecto d).alfas.2.length = 3 :=
    RegistroCompleto.alfas_tres _ _ _ _ _ _ _ _ _ _
  have ht := longitud_traza t defecto s d hc
  change (RetosRecuperados.retos (funcionTabla defecto t)
    (ReconstruccionSelector.candidato t s)).drop (3 + d.k) = _
  change RetosRecuperados.retos (funcionTabla defecto t) (ReconstruccionSelector.candidato t s) =
    (registro t defecto d).alfas.2 ++
      (registro t defecto d).traza.2.map (beta (funcionTabla defecto t)) ++
      (registro t defecto d).composicion.2.map (beta (funcionTabla defecto t)) at hcanon
  rw [hcanon]
  simp [List.drop_append, h3, List.length_map, ht]

theorem registro_en_tabla (t : Tabla Entrada Digest) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico t defecto s d) (e : Evento)
    (he : Registrado (funcionTabla defecto t)
      (RegistroCompleto.prefijo (funcionTabla defecto t) d.k d.bits d.inicio d.salida
        d.raiz d.rt d.rc d.vt d.vc) e) :
    buscar t (absorcion e) = some (funcionTabla defecto t (absorcion e)) ∧
      buscar t (reto (funcionTabla defecto t) e) =
        some (funcionTabla defecto t (reto (funcionTabla defecto t) e)) := by
  have hmem : ∀ x ∈ RegistroCompleto.prefijo (funcionTabla defecto t) d.k d.bits
      d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc,
      x ∈ ReconstruccionSelector.candidato t s := by
    intro x hx
    rw [hc.cadena]
    exact List.mem_append_left _ hx
  exact ⟨hc.conocidas _ (hmem _ he.1), hc.conocidas _ (hmem _ he.2)⟩

theorem corte_canonico {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (e : Evento)
    (he : Registrado (funcionTabla defecto fin.tabla)
      (RegistroCompleto.prefijo (funcionTabla defecto fin.tabla) d.k d.bits d.inicio d.salida
        d.raiz d.rt d.rc d.vt d.vc) e) :
    Nonempty (CorteRaizReto fin e.estado e.tag e.raiz .extension
      (funcionTabla defecto fin.tabla (absorcion e))
      (funcionTabla defecto fin.tabla (reto (funcionTabla defecto fin.tabla) e))) := by
  have ht := registro_en_tabla fin.tabla defecto s d hc e he
  exact origenes_raiz_reto r e.estado e.tag e.raiz .extension _ _ ht.1 ht.2

structure CapaPrevia {B : ℕ} (fin : Estado B) (k j : ℕ) (defecto : Digest)
    (b : Fp2) (o : Fp2 → Fp2) where
  evento : Evento
  corte : CorteRaizReto fin evento.estado evento.tag evento.raiz .extension
    (funcionTabla defecto fin.tabla (absorcion evento))
    (funcionTabla defecto fin.tabla (reto (funcionTabla defecto fin.tabla) evento))
  etiqueta_fri : evento.tag = 2
  beta_eq : b = beta (funcionTabla defecto fin.tabla) evento
  oraculo_eq : o = oraculoEnEstado k j defecto corte.segunda.antes evento.raiz

theorem traza_causal {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (j : Fin d.k) :
    Nonempty (CapaPrevia fin d.k j.val defecto
      ((prefijo (construir fin.tabla defecto d (ReconstruccionSelector.candidato fin.tabla s))).betaTraza j)
      (oraculoTraza (prefijo
        (construir fin.tabla defecto d (ReconstruccionSelector.candidato fin.tabla s))) j)) := by
  have hj : j.val < (registro fin.tabla defecto d).traza.2.length := by
    rw [longitud_traza fin.tabla defecto s d hc]; exact j.isLt
  have hr : j.val < d.rt.length := by rw [hc.perfil.2.2.1]; exact j.isLt
  let e := (registro fin.tabla defecto d).traza.2[j.val]
  have he : e ∈ (registro fin.tabla defecto d).traza.2 := List.getElem_mem hj
  have hroot : e.raiz = d.rt[j.val] := raiz_por_indice _ _
    (RegistroCompleto.raices_conservadas _ _ _ _ _ _ _ _ _ _).1 j.val hj hr
  obtain ⟨c⟩ := corte_canonico r defecto s d hc e
    (RegistroCompleto.traza_registrada _ _ _ _ _ _ _ _ _ _ e he)
  refine ⟨⟨e, c, etiqueta_evento _ _ _ _ e he, ?_, ?_⟩⟩
  · change (betasTraza _).getD j.val 0 = _
    rw [betas_traza fin.tabla defecto s d hc]
    unfold List.getD
    rw [List.getElem?_map, List.getElem?_eq_getElem hj]
    rfl
  · rw [OraculosVista.traza_construida fin.tabla defecto d _ j.val hr, ← hroot]
    exact (oraculo_antes_reto_estable c d.k j.val defecto).symm

theorem composicion_causal {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (j : Fin (d.k + 1)) :
    Nonempty (CapaPrevia fin d.k j.val defecto
      ((prefijo (construir fin.tabla defecto d (ReconstruccionSelector.candidato fin.tabla s))).betaComposicion j)
      (oraculoComposicion (prefijo
        (construir fin.tabla defecto d (ReconstruccionSelector.candidato fin.tabla s))) j)) := by
  have hj : j.val < (registro fin.tabla defecto d).composicion.2.length := by
    rw [longitud_composicion fin.tabla defecto s d hc]; exact j.isLt
  have hr : j.val < d.rc.length := by rw [hc.perfil.2.2.2.1]; exact j.isLt
  let e := (registro fin.tabla defecto d).composicion.2[j.val]
  have he : e ∈ (registro fin.tabla defecto d).composicion.2 := List.getElem_mem hj
  have hroot : e.raiz = d.rc[j.val] := raiz_por_indice _ _
    (RegistroCompleto.raices_conservadas _ _ _ _ _ _ _ _ _ _).2 j.val hj hr
  obtain ⟨c⟩ := corte_canonico r defecto s d hc e
    (RegistroCompleto.composicion_registrada _ _ _ _ _ _ _ _ _ _ e he)
  refine ⟨⟨e, c, etiqueta_evento _ _ _ _ e he, ?_, ?_⟩⟩
  · change (betasComposicion _).getD j.val 0 = _
    rw [betas_composicion fin.tabla defecto s d hc]
    unfold List.getD
    rw [List.getElem?_map, List.getElem?_eq_getElem hj]
    rfl
  · rw [OraculosVista.composicion_construida fin.tabla defecto d _ j.val hr, ← hroot]
    exact (oraculo_antes_reto_estable c d.k j.val defecto).symm

theorem CapaPrevia.excepcion {B : ℕ} {fin : Estado B} {k j : ℕ} {defecto : Digest}
    {b : Fp2} {o : Fp2 → Fp2} (c : CapaPrevia fin k j defecto b o)
    (E : (Fp2 → Fp2) → Finset Fp2) (hx : b ∈ E o) :
    beta (funcionTabla defecto fin.tabla) c.evento ∈
      E (oraculoEnEstado k j defecto c.corte.segunda.antes c.evento.raiz) := by
  rw [← c.beta_eq, ← c.oraculo_eq]
  exact hx

@[expose] def raizPrevia (t : Tabla Entrada Digest) (a : Digest) : Option Digest :=
  (TablaInversa.buscarSalida t a).bind fun e =>
    (LecturaAbsorcion.leer e).bind fun dato =>
      match dato with
      | .raizFRI raiz => some raiz
      | _ => none

@[expose] noncomputable def oraculoPrevio (k j : ℕ) (defecto : Digest)
    (t : Tabla Entrada Digest) (a : Digest) : Fp2 → Fp2 :=
  match raizPrevia t a with
  | some raiz => oraculoMerkle k j (funcionTabla defecto t) (t.map Prod.fst) raiz
  | none => fun _ => 0

theorem CapaPrevia.raiz_recuperada {B : ℕ} {fin : Estado B} {k j : ℕ} {defecto : Digest}
    {b : Fp2} {o : Fp2 → Fp2} (c : CapaPrevia fin k j defecto b o) :
    raizPrevia c.corte.segunda.antes.tabla
      (funcionTabla defecto fin.tabla (absorcion c.evento)) = some c.evento.raiz := by
  let G := funcionTabla defecto fin.tabla
  have hfin : Compatibles G fin.tabla := funcion_tabla_compatible defecto fin.tabla fin.sinRepetidos
  have hdespues := recorrido_trans (paso_es_recorrido (corte_paso c.corte.segunda))
    c.corte.segunda.sufijo
  have hantes := recorrido_compatible_antes G hdespues hfin
  have h0 : SinColisiones G ((inicial B).tabla.map Prod.fst) := by
    intro x hx
    simp only [inicial, List.map_nil, List.not_mem_nil] at hx
  have hsin := recorrido_sin_colisiones G (segunda_tiene_prefijo c.corte) hantes h0
  have ha := buscar_persiste_en_recorrido c.corte.segunda.prefijo
    (absorcion c.evento) (G (absorcion c.evento))
    (by simpa only [c.corte.primera.entrada_eq, G, absorcion] using
      paso_respuesta_guardada (corte_paso c.corte.primera))
  have hi := TablaInversa.preimagen_de_tabla G c.corte.segunda.antes.tabla hantes hsin
    (absorcion c.evento) (buscar_some_mem _ _ _ ha)
  unfold raizPrevia
  rw [hi]
  simp only [Option.bind_some]
  have he : absorcion c.evento = GramaticaTG2.entrada c.evento.estado (.raizFRI c.evento.raiz) := by
    simp only [absorcion, c.etiqueta_fri, GramaticaTG2.entrada,
      GramaticaTG2.etiqueta, GramaticaTG2.datos]
  rw [he, LecturaAbsorcion.leer_entrada]
  rfl

theorem CapaPrevia.oraculo_desde_pasado {B : ℕ} {fin : Estado B} {k j : ℕ} {defecto : Digest}
    {b : Fp2} {o : Fp2 → Fp2} (c : CapaPrevia fin k j defecto b o) :
    o = oraculoPrevio k j defecto c.corte.segunda.antes.tabla
      (funcionTabla defecto fin.tabla (absorcion c.evento)) := by
  rw [oraculoPrevio, c.raiz_recuperada]
  exact c.oraculo_eq

theorem CapaPrevia.respuesta_real {B : ℕ} {fin : Estado B} {k j : ℕ} {defecto : Digest}
    {b : Fp2} {o : Fp2 → Fp2} (c : CapaPrevia fin k j defecto b o)
    (H : Entrada → Digest) (hH : Compatibles H fin.tabla) :
    b = DesafiosPrograma.extension
      (H (RegistroRaices.reto (funcionTabla defecto fin.tabla) c.evento)) := by
  have h := hH _ _ (buscar_some_mem _ _ _ (corte_respuesta_final c.corte.segunda))
  exact c.beta_eq.trans (congrArg DesafiosPrograma.extension h.symm)

theorem CapaPrevia.en_llamadas {A : Type} {B k j n : ℕ} {defecto : Digest}
    (H : Entrada → Digest) (p : ProgramaBytes.Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) {b : Fp2} {o : Fp2 → Fp2}
    (c : CapaPrevia (PrefijoPrograma.estado H (inicial B) p n) k j defecto b o) :
    ∃ m, m < (ProgramaBytes.traza H p).length ∧
      (ProgramaBytes.entradas H p)[m]? = some
        (RegistroRaices.reto
          (funcionTabla defecto (PrefijoPrograma.estado H (inicial B) p n).tabla) c.evento) ∧
      RegistroRaices.reto
          (funcionTabla defecto (PrefijoPrograma.estado H (inicial B) p n).tabla) c.evento ∉
        ((ProgramaBytes.traza H p).take m).map Prod.fst ∧
      c.corte.segunda.antes.tabla = TablaObservada.tabla ((ProgramaBytes.traza H p).take m) := by
  let fin := PrefijoPrograma.estado H (inicial B) p n
  let G := funcionTabla defecto fin.tabla
  let q := RegistroRaices.reto G c.evento
  have h0 : Compatibles H (inicial B).tabla := by intro e d hd; cases hd
  have hfin : Compatibles H fin.tabla := PrefijoPrograma.compatible_estado H (inicial B) p n h0
  have hres : H q = G q := hfin _ _
    (buscar_some_mem _ _ _ (corte_respuesta_final c.corte.segunda))
  have rfin : RecorridoSinAcierto B fin (EjecucionBytes.final H (inicial B) p) := by
    rw [← PrefijoPrograma.final_resto H (inicial B) p n]
    exact EjecucionBytes.recorrido_desde_programa H fin (PrefijoPrograma.resto H p n) hfin
      (PrefijoPrograma.sinbad_resto H (inicial B) p n hs)
  let cp : CorteConsulta (inicial B) (EjecucionBytes.final H (inicial B) p) q (H q) := {
    antes := c.corte.segunda.antes
    solicitud := c.corte.segunda.solicitud
    entrada_eq := c.corte.segunda.entrada_eq
    nueva := c.corte.segunda.nueva
    sinAcierto := by rw [hres]; exact c.corte.segunda.sinAcierto
    prefijo := segunda_tiene_prefijo c.corte
    sufijo := by rw [hres]; exact recorrido_trans c.corte.segunda.sufijo rfin }
  have hq := CorteLlamadas.entrada_corte H B p q cp
  exact CorteLlamadas.corte_en_llamadas H B p hs q hq cp

end Nexus.Canal.VistaCausal
