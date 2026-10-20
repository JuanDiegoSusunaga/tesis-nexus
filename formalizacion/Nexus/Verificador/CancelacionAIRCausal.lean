module

public import Nexus.Canal.ContextoAIR
public import Nexus.Canal.ExtensionesPrefijo
public import Nexus.Verificador.RondasCausales
public import Nexus.Verificador.CotaFRICausal
import Mathlib.Tactic

/-!
# Toda cancelación AIR real pertenece a una excepción anterior al alfa

El candidato y los residuos se recuperan desde la tabla anterior a la
primera consulta del alfa crítico. La respuesta real puede haberse pedido
antes del verificador; su primera exposición se localiza en el programa.
-/

public section
namespace Nexus.Verificador.CancelacionAIRCausal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal Nexus.N06
open ProgramaBytes VistaSemantica VistaCampo FiltroFalso RondasCausales
open RegistroRaices ParametrosRecuperados

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def alfa (H : Entrada → Digest) (d : DatosCanal) (j : ℕ) : Fp2 :=
  DesafiosPrograma.extension (H (entradaReto (PrefijoAIR.estado H d j) .extension))

theorem coeficientes_canonicos (t : Tabla Entrada Digest) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico t defecto s d) :
    (prefijo (construir t defecto d (ReconstruccionSelector.candidato t s))).coeficientes =
      (alfa (funcionTabla defecto t) d 0, alfa (funcionTabla defecto t) d 1,
        alfa (funcionTabla defecto t) d 2) := by
  change alfas _ = _
  apply alfas_de_lista
  change (RetosRecuperados.retos (funcionTabla defecto t) (ReconstruccionSelector.candidato t s)).take 3 = _
  rw [retos_canonicos t defecto s d hc]
  rfl

theorem escape_tres (R : ℕ → Polynomial Fp2)
    (E : ℕ → Polynomial Fp2 → Finset Fp2) (a b c : Fp2)
    (hx : Escapa E (pasoAIR R) 0 3 0 (a, b, c, PUnit.unit)) :
    ∃ j, j < 3 ∧ [a, b, c].getD j 0 ∈
      E j (ContextoAIR.acumular R 0 0 ([a, b, c].take j)) := by
  change a ∈ E 0 0 ∨ Escapa E (pasoAIR R) 1 2 (0 + a • R 0) (b, c, PUnit.unit) at hx
  rcases hx with ha | hx
  · exact ⟨0, by decide, ha⟩
  · change b ∈ E 1 (0 + a • R 0) ∨
      Escapa E (pasoAIR R) 2 1 ((0 + a • R 0) + b • R 1) (c, PUnit.unit) at hx
    rcases hx with hb | hx
    · exact ⟨1, by decide, hb⟩
    · change c ∈ E 2 ((0 + a • R 0) + b • R 1) ∨ False at hx
      exact ⟨2, by decide, hx.resolve_right not_false⟩

theorem critico_de_escape (R : ℕ → Polynomial Fp2) (a b c : Fp2)
    (hn : ∃ j < 3, R j ≠ 0)
    (hx : Escapa (excepcionesAIR R (rondaCritica R 3 hn)) (pasoAIR R)
      0 3 0 (a, b, c, PUnit.unit)) :
    ∃ j, j < 3 ∧ [a, b, c].getD j 0 ∈
      excepcionesCriticas R j (ContextoAIR.acumular R 0 0 ([a, b, c].take j)) := by
  have he : excepcionesCriticas R = excepcionesAIR R (rondaCritica R 3 hn) := by
    unfold excepcionesCriticas
    rw [dite_eq_left hn]
  rw [← he] at hx
  exact escape_tres R (excepcionesCriticas R) a b c hx

theorem cancelacion_en_corte {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (hfalso : Falso d)
    (hx : CancelacionAIR (construir fin.tabla defecto d (ReconstruccionSelector.candidato fin.tabla s))) :
    ∃ j, ∃ _hj : j < 3, ∃ c : PrefijoAIR.Corte fin defecto d j,
      alfa (funcionTabla defecto fin.tabla) d j ∈ ContextoAIR.excepciones c.antes.tabla defecto
        (PrefijoAIR.estado (funcionTabla defecto fin.tabla) d j) := by
  let G := funcionTabla defecto fin.tabla
  let v := construir fin.tabla defecto d (ReconstruccionSelector.candidato fin.tabla s)
  obtain ⟨f, hprofile, hbase, hcancel⟩ := hx
  obtain ⟨i, hi, hR, _, _⟩ := candidato_base_ronda_critica d.k (by have h := hc.perfil.1.1; omega)
    (by have h := hc.perfil.1.2; omega) (oraculoTraza (prefijo v) 0) (1 / 8) f
    hprofile hbase d.inicio d.salida ((falso_iff d).mp hfalso)
  let R := residuosPerfil d.k f (algebraMap Fp Fp2 d.inicio) (algebraMap Fp Fp2 d.salida)
  have hn : ∃ j < 3, R j ≠ 0 := ⟨i, hi, hR⟩
  have hjcrit := ronda_critica_propiedades R 3 hn
  have hescape := (escape_air_iff_resto d.k f (algebraMap Fp Fp2 d.inicio)
    (algebraMap Fp Fp2 d.salida) (rondaCritica R 3 hn) hjcrit.1 hjcrit.2.2
    (prefijo v).coeficientes).mpr hcancel
  rw [coeficientes_canonicos fin.tabla defecto s d hc] at hescape
  obtain ⟨j, hj, he⟩ := critico_de_escape R (alfa G d 0) (alfa G d 1) (alfa G d 2) hn hescape
  have halfa : [alfa G d 0, alfa G d 1, alfa G d 2].getD j 0 = alfa G d j := by
    interval_cases j <;> rfl
  have hprev : [alfa G d 0, alfa G d 1, alfa G d 2].take j =
      (evaluarRetos G j (G (absorcion (PrefijoAIR.base G d)))).2 := by
    interval_cases j <;> rfl
  rw [halfa, hprev] at he
  obtain ⟨c⟩ := PrefijoAIR.existe_corte r defecto s d hc j hj
  have horaculo := PrefijoAIR.oraculo_antes_alfa r defecto s d hc j hj c
  have hantes : candidatoPerfil d.k
      (oraculoMerkle d.k 0 (funcionTabla defecto c.antes.tabla) (c.antes.tabla.map Prod.fst) d.raiz)
      (1 / 8) = some f := by
    change candidatoPerfil d.k (oraculoEnEstado d.k 0 defecto c.antes d.raiz) (1 / 8) = some f
    rw [← horaculo]
    exact hprofile
  refine ⟨j, hj, c, ?_⟩
  unfold ContextoAIR.excepciones
  rw [ContextoAIR.previo_correcto r defecto s d hc j hj c]
  dsimp only
  rw [hantes]
  dsimp only
  rw [retos_longitud]
  exact he

theorem corte_en_llamadas {A : Type} (H : Entrada → Digest) (L : ℕ) (p : Programa A)
    (n : ℕ) (hs : EjecucionBytes.SinBad H (inicial L) p) (q : Entrada) (d : Digest)
    (c : CorteConsulta (inicial L) (PrefijoPrograma.estado H (inicial L) p n) q d) :
    ∃ m, m < (traza H p).length ∧ (entradas H p)[m]? = some q ∧
      q ∉ ((traza H p).take m).map Prod.fst ∧
      c.antes.tabla = TablaObservada.tabla ((traza H p).take m) := by
  let fin := PrefijoPrograma.estado H (inicial L) p n
  have h0 : Compatibles H (inicial L).tabla := by intro e valor he; cases he
  have hfin := PrefijoPrograma.compatible_estado H (inicial L) p n h0
  have hres : H q = d := hfin _ _ (buscar_some_mem _ _ _ (corte_respuesta_final c))
  have rfin : RecorridoSinAcierto L fin (EjecucionBytes.final H (inicial L) p) := by
    rw [← PrefijoPrograma.final_resto H (inicial L) p n]
    exact EjecucionBytes.recorrido_desde_programa H fin (PrefijoPrograma.resto H p n) hfin
      (PrefijoPrograma.sinbad_resto H (inicial L) p n hs)
  let cp : CorteConsulta (inicial L) (EjecucionBytes.final H (inicial L) p) q (H q) := {
    antes := c.antes
    solicitud := c.solicitud
    entrada_eq := c.entrada_eq
    nueva := c.nueva
    sinAcierto := by rw [hres]; exact c.sinAcierto
    prefijo := c.prefijo
    sufijo := by rw [hres]; exact recorrido_trans c.sufijo rfin }
  exact CorteLlamadas.corte_en_llamadas H L p hs q (CorteLlamadas.entrada_corte H L p q cp) cp

@[expose] noncomputable def ExcepcionAIR {A : Type} (H : Entrada → Digest)
    (p : Programa A) (defecto : Digest) (N : ℕ) : Prop :=
  ∃ n : Fin N,
    ExtensionesPrefijo.IniciaBytes H p n.val (SemillaProxima.semilla p defecto) ∧
    DesafiosPrograma.extension
      (H (entradaReto (SemillaProxima.semilla p defecto ((traza H p).take n.val)) .extension)) ∈
      ContextoAIR.excepciones (TablaObservada.tabla ((traza H p).take n.val)) defecto
        (SemillaProxima.semilla p defecto ((traza H p).take n.val))

theorem cancelacion_reasignada {A : Type} (H : Entrada → Digest) (L : ℕ) (p : Programa A)
    (defecto s : Digest) (n : ℕ) (d : DatosCanal)
    (hs : EjecucionBytes.SinBad H (inicial L) p)
    (hc : Canonico (PrefijoPrograma.estado H (inicial L) p n).tabla defecto s d) (hfalso : Falso d)
    (hx : CancelacionAIR (construir (PrefijoPrograma.estado H (inicial L) p n).tabla defecto d
      (ReconstruccionSelector.candidato (PrefijoPrograma.estado H (inicial L) p n).tabla s))) :
    ExcepcionAIR H p defecto (altura p) := by
  let fin := PrefijoPrograma.estado H (inicial L) p n
  let G := funcionTabla defecto fin.tabla
  have h0 : Compatibles H (inicial L).tabla := by intro e valor he; cases he
  have hfin := PrefijoPrograma.compatible_estado H (inicial L) p n h0
  have r := PrefijoPrograma.recorrido_prefijo H (inicial L) p n h0 hs
  obtain ⟨j, hj, c, he⟩ := cancelacion_en_corte r defecto s d hc hfalso hx
  have hreal : alfa G d j = DesafiosPrograma.extension (H (entradaReto (PrefijoAIR.estado G d j) .extension)) :=
    congrArg DesafiosPrograma.extension
      (hfin _ _ (buscar_some_mem _ _ _ (corte_respuesta_final c))).symm
  obtain ⟨m, hm, hnext, hfresh, htabla⟩ := corte_en_llamadas H L p n hs _ _ c
  obtain ⟨hinicia, hsemilla⟩ := ExtensionesPrefijo.inicio_conocido H p defecto
    (PrefijoAIR.estado G d j) m hnext hfresh
  refine ⟨⟨m, hm.trans_le (costo_acotado H p)⟩, hinicia, ?_⟩
  rw [hsemilla, ← htabla]
  rw [hreal] at he
  exact he

theorem air_real_cubierta {A : Type} (H : Entrada → Digest) (L : ℕ) (p : Programa A)
    (defecto : Digest) (N : ℕ) (hs : EjecucionBytes.SinBad H (inicial L) p)
    (hx : CotaFRICausal.AIRReal H p defecto N) : ExcepcionAIR H p defecto (altura p) := by
  obtain ⟨n, _, d, hc, hfalso, hcancel⟩ := hx
  apply cancelacion_reasignada H L p defecto _ n.val d hs
  · simpa only [PrefijoPrograma.tabla_desde_vacio] using hc
  · exact hfalso
  · simpa only [PrefijoPrograma.tabla_desde_vacio] using hcancel

end Nexus.Verificador.CancelacionAIRCausal
