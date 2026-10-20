module

public import Nexus.Canal.TrabajoPrefijo
public import Nexus.Canal.FrescuraTrabajo
public import Nexus.Verificador.CotaInicios
import Mathlib.Tactic

/-!
# La aceptación real está cubierta en la primera pareja de trabajo y nonce

La semilla, el trabajo y la muestra pertenecen al mismo certificado. Su
conjunto bueno se recupera antes de ambas respuestas, incluso cuando el
adversario consulta el nonce antes del trabajo o adelanta los índices.
-/

public section
namespace Nexus.Verificador.CoberturaTrabajo

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.N06 Nexus.ROM Nexus.Canal
open CandidatoPrevio SemanticaPrevia SelectorAdaptativo LeyArbol ObservacionesPrefijo

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem registro_cubierto {A : Type} (p : ProgramaBytes.Programa A) (defecto : Digest)
    (H : universo p → Digest) (L k bits R g : ℕ) (cert : Certificado)
    (hs : EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p)
    (ha : ProgramaCompartido.resultado (RegistroPrograma.tabla (oraculo p defecto H))
      (Completo.verificar k bits R cert) = true)
    (hlog : ∀ e ∈ RegistroPrograma.entradas (oraculo p defecto H) (Completo.verificar k bits R cert),
      e ∈ ProgramaBytes.entradas (oraculo p defecto H) p)
    (r : Registro (oraculo p defecto H) L p k bits cert)
    (hcard : (ConjuntosPrevios.GT (k + 2) defecto (semillaCert (oraculo p defecto H) k bits cert) r.corte.antes.tabla ∩
      ConjuntosPrevios.GC (k + 2) defecto (semillaCert (oraculo p defecto H) k bits cert) r.corte.antes.tabla).card ≤ g)
    (hb : let T := ROM.SelectorAcoplado.salida (k + 2) 40 (CintaSelector.cinta (oraculo p defecto H) R (semillaCert (oraculo p defecto H) k bits cert))
      T.card = 40 ∧ T ⊆ ConjuntosPrevios.GT (k + 2) defecto
        (semillaCert (oraculo p defecto H) k bits cert) r.corte.antes.tabla ∩
        ConjuntosPrevios.GC (k + 2) defecto (semillaCert (oraculo p defecto H) k bits cert) r.corte.antes.tabla) :
    ∃ n : Fin (ProgramaBytes.altura p), TrabajoPrefijo.Activa p defecto (prefijo (arbol p) n.val H) ∧
      TrabajoPrefijo.Evento p defecto bits R (k + 2) g (prefijo (arbol p) n.val H) H := by
  let S := oraculo p defecto H
  let d := datosCert k bits cert
  let key : ParTrabajo.Clave := (PrefijoTrabajo.estado S d, Completo.nonce cert.prueba)
  have hf := (Completo.aceptacion_verificador S k bits R cert ha).1
  have hw := CandidatoTrabajo.trabajo_aceptado S k bits R cert ha
  have hqueries (b : Bool) : PrefijoTrabajo.consulta b key.1 key.2 ∈ ProgramaBytes.entradas S p := by
    cases b
    · apply hlog
      apply (CandidatoPrevio.soporte_verificador S k bits R cert ha).1
      exact List.mem_append_right _ (List.mem_singleton_self _)
    · exact hlog _ hw.2
  have hkey : key ∈ ParTrabajo.claves (ProgramaBytes.entradas S p) :=
    (ParTrabajo.mem_claves _ key).mpr ⟨_, hqueries true, ParTrabajo.leer_consulta true key.1 key.2⟩
  obtain ⟨n, hn, hinit, hk⟩ := PrimerosPares.existe_primera S p defecto key hkey
  have hk' : PrimerosPares.clave p defecto (historia p defecto n H) = key := by
    simpa only [historia, S] using hk
  have hu (b : Bool) : PrefijoTrabajo.consulta b key.1 key.2 ∈ universo p :=
    SelectorAcoplado.pasado_en_universo _ (SoporteFinito.entradas_en_soporte S p _ (hqueries b))
  have hresp (b : Bool) : H (TrabajoPrefijo.codigo p b key) = S (PrefijoTrabajo.consulta b key.1 key.2) :=
    (SoporteFinito.prolongar_en_universo (universo p) defecto H _
      (TrabajoPrefijo.codigo p b key).property).symm.trans
      (congrArg S (TrabajoPrefijo.codigo_conocido p b key (hu b)))
  have hcuts := FrescuraTrabajo.corte_inicio S L p defecto hs n hinit
  dsimp only at hcuts
  rw [hk] at hcuts
  obtain ⟨b, c, htabla⟩ := hcuts
  have hestate := CandidatoTrabajo.estado_final r defecto
  have he : PrefijoTrabajo.consulta b key.1 key.2 =
      PrefijoTrabajo.consulta b
        (PrefijoTrabajo.estado (funcionTabla defecto (EjecucionBytes.final S (inicial L) p).tabla) d) d.nonce := by
    change PrefijoTrabajo.consulta b (PrefijoTrabajo.estado S d) (Completo.nonce cert.prueba) = _
    rw [← hestate]
    rfl
  have hq := EjecucionBytes.consulta_en_tabla S (inicial L) p
    (by intro e v he; contradiction) _ (hqueries b)
  have hd : S (PrefijoTrabajo.consulta b key.1 key.2) =
      funcionTabla defecto (EjecucionBytes.final S (inicial L) p).tabla
        (PrefijoTrabajo.consulta b
          (PrefijoTrabajo.estado (funcionTabla defecto (EjecucionBytes.final S (inicial L) p).tabla) d) d.nonce) := by
    rw [← he]
    simp only [funcionTabla, hq, Option.getD_some]
  let cc : PrefijoTrabajo.Corte (EjecucionBytes.final S (inicial L) p) defecto d b :=
    FrescuraTrabajo.reetiquetar c he hd
  have hgood := PoliticasTrabajo.buenos_corte hs r hf defecto b cc (k + 2) g hcard
  change PoliticasTrabajo.buenos (k + 2) g c.antes.tabla defecto key = _ at hgood
  rw [htabla] at hgood
  have hfn := PrimerosPares.frescura_ambas S p defecto n hinit false
  rw [hk] at hfn
  have hfi := FrescuraTrabajo.indice_fresco S L p hs n
    (PrefijoTrabajo.consulta false key.1 key.2) (hqueries false) hfn
  have hseed : S (PrefijoTrabajo.consulta false key.1 key.2) = semillaCert S k bits cert := rfl
  rw [hseed] at hfi
  refine ⟨⟨n, hn.trans_le (ProgramaBytes.costo_acotado S p)⟩, ?_, ?_⟩
  · constructor
    · have hraw := hinit
      rw [prefijo_bytes p defecto n H]
      simpa only [historia, S] using hraw
    · intro b'
      rw [prefijo_bytes p defecto n H, hk']
      exact hu b'
  · dsimp only [TrabajoPrefijo.Evento]
    rw [prefijo_bytes p defecto n H, hk', hresp true, hresp false, hseed]
    refine ⟨hw.1, ?_, ?_⟩
    · apply (consulta_proyectada (prefijo (arbol p) n H)
        (SelectorAdaptativo.codigo p (semillaCert S k bits cert))).not.mpr
      rw [prefijo_bytes p defecto n H]
      simpa only [historia, S, List.mem_toFinset, ProgramaBytes.entradas, List.map_take,
        SelectorAdaptativo.codigo, SelectorAcoplado.codificar] using hfi
    · have hcinta := SelectorAcoplado.cinta_igual (universo p) (SelectorAcoplado.indices_en_universo _)
        defecto H R (semillaCert S k bits cert)
      change CadenaMemoria.cinta (SelectorAdaptativo.codigo p) H R (semillaCert S k bits cert) =
        CintaSelector.cinta S R (semillaCert S k bits cert) at hcinta
      unfold TrabajoSelectorLocal.Omite
      dsimp only
      rw [hcinta]
      change _ ∨ (_ ∧ _ ⊆ PoliticasTrabajo.buenos (k + 2) g
        (TablaObservada.tabla ((ProgramaBytes.traza S p).take n)) defecto key)
      rw [hgood]
      exact Or.inr hb

theorem adversario_seguro {A : Type} (L bits R k : ℕ)
    (proponer : ProgramaBytes.Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → ProgramaBytes.Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest)
    (ha : PoliticasFalsas.AceptaFalsa
      (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
      bits R k proponer atacar actualizar)
    (hs : EjecucionBytes.SinBad
      (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H) (inicial L)
      (Adversario.ejecutar bits R proponer atacar actualizar))
    (hr : ¬ ExcesoRondas.Rondas
      (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
      (Adversario.ejecutar bits R proponer atacar actualizar) defecto
      (ProgramaBytes.altura (Adversario.ejecutar bits R proponer atacar actualizar))) :
    let p := Adversario.ejecutar bits R proponer atacar actualizar
    ∃ n : Fin (ProgramaBytes.altura p), TrabajoPrefijo.Activa p defecto (prefijo (arbol p) n.val H) ∧
      TrabajoPrefijo.Evento p defecto bits R (k + 2) (CardinalVista.umbral (k + 2))
        (prefijo (arbol p) n.val H) H := by
  dsimp only
  let p := Adversario.ejecutar bits R proponer atacar actualizar
  let S := oraculo p defecto H
  obtain ⟨hacc, cert, hparse, hk, hfalse⟩ := ha
  have hparseS : Lectura.exacto codecCertificado.leer (ProgramaBytes.resultado S proponer).1 = some cert := hparse
  have hacert : ProgramaCompartido.resultado (RegistroPrograma.tabla S) (Completo.verificar k bits R cert) = true := by
    rw [Adversario.resultado_con_bytes, Completo.desdeBytes, hparse] at hacc
    change ProgramaCompartido.resultado (RegistroPrograma.tabla S)
      (Completo.verificar (Nat.log2 cert.enunciado.pasos) bits R cert) = true at hacc
    rw [hk] at hacc
    exact hacc
  have hf := (Completo.aceptacion_verificador S k bits R cert hacert).1
  have hlog (e : Entrada) (he : e ∈ RegistroPrograma.entradas S (Completo.verificar k bits R cert)) :
      e ∈ ProgramaBytes.entradas S p := by
    apply (Adversario.registro_verificador S bits R proponer atacar actualizar).subset
    rw [Completo.desdeBytes, hparseS]
    change e ∈ RegistroPrograma.entradas S (Completo.verificar (Nat.log2 cert.enunciado.pasos) bits R cert)
    rw [hk]
    exact he
  obtain ⟨r, hb⟩ := MuestraBuena.omision_efectiva S L p hs k bits R cert hacert hlog defecto
  have hcard : (ConjuntosPrevios.GT (k + 2) defecto (semillaCert S k bits cert) r.corte.antes.tabla ∩
      ConjuntosPrevios.GC (k + 2) defecto (semillaCert S k bits cert) r.corte.antes.tabla).card ≤
      CardinalVista.umbral (k + 2) := by
    by_contra hg
    obtain ⟨m, hm, hi, hseed, ht⟩ := PoliticasPrefijo.registro_previsible S L p hs k bits cert r defecto
    have he : PoliticasFalsas.elegible p defecto ((ProgramaBytes.traza S p).take m) := by
      unfold PoliticasFalsas.elegible
      rw [hseed, ← ht]
      exact FiltroFalso.elegible_registro r hf hfalse defecto
    have hgt : CardinalVista.umbral (k + 2) <
        (PoliticasPrefijo.GT p defecto (k + 2) ((ProgramaBytes.traza S p).take m) ∩
          PoliticasPrefijo.GC p defecto (k + 2) ((ProgramaBytes.traza S p).take m)).card := by
      simpa only [PoliticasPrefijo.GT, PoliticasPrefijo.GC, hseed, ← ht] using Nat.lt_of_not_ge hg
    exact hr (ExcesoRondas.exceso_implica_rondas S p defecto (ProgramaBytes.altura p) (k + 2)
      ⟨⟨m, hm.trans_le (ProgramaBytes.costo_acotado S p)⟩, hi, he, hgt⟩)
  exact registro_cubierto p defecto H L k bits R (CardinalVista.umbral (k + 2)) cert hs hacert hlog r hcard hb

end Nexus.Verificador.CoberturaTrabajo
