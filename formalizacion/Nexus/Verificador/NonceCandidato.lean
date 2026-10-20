module

public import Nexus.Verificador.PoliticasFalsas
public import Nexus.ROM.CargaPrimeras
import Mathlib.Tactic

/-!
# Cada inicio elegible se carga a una absorción de nonce distinta

No se cuentan las continuaciones I del selector como candidatos nuevos.
Una semilla canónica procede de una consulta de 49 octetos ya guardada.
Dos primeras direcciones I distintas no pueden provenir de la misma entrada,
incluso si el oráculo contiene colisiones. No se necesita SinBad aquí.
-/

public section
namespace Nexus.Verificador.NonceCandidato

open Nexus.Bytes Nexus.Merkle Nexus.ROM Nexus.Canal
open ProgramaBytes FiltroFalso ParametrosRecuperados

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem nonce_canonico (t : Tabla Entrada Digest) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico t defecto s d) : ∃ q : Entrada, q.length = 49 ∧ buscar t q = some s := by
  let G := funcionTabla defecto t
  let q := GramaticaTG2.entrada
    (RegistroCompleto.evaluar G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc).composicion.1
    (.nonce d.nonce)
  have hs : G q = s := hc.semilla
  have hm : q ∈ ReconstruccionSelector.candidato t s := by
    rw [hc.cadena]
    exact List.mem_append_right _ (List.mem_singleton_self q)
  exact ⟨q, GramaticaTG2.longitud_nonce_absorbido _ _, (hc.conocidas q hm).trans (congrArg some hs)⟩

theorem nonce_en_pasado {A : Type} (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (n : ℕ)
    (he : PoliticasFalsas.elegible p defecto ((traza H p).take n)) :
    ∃ q : Entrada, q.length = 49 ∧ q ∈ (entradas H p).take n ∧
      H q = SemillaProxima.semilla p defecto ((traza H p).take n) := by
  obtain ⟨d, hc, _⟩ := (elegible_iff _ _ _).mp he
  obtain ⟨q, hlen, hq⟩ := nonce_canonico _ defecto _ d hc
  have hm : q ∈ (TablaObservada.tabla ((traza H p).take n)).map Prod.fst :=
    List.mem_map.mpr ⟨(_, _), buscar_some_mem _ _ _ hq, rfl⟩
  have hp : q ∈ (entradas H p).take n := by
    simpa only [entradas, List.map_take] using (TablaObservada.claves_tabla _ q).mp hm
  have hcompatible := PrefijoPrograma.compatible_estado H (inicial 0) p n
    (by intro e d hd; cases hd)
  rw [PrefijoPrograma.tabla_desde_vacio] at hcompatible
  exact ⟨q, hlen, hp, hcompatible _ _ (buscar_some_mem _ _ _ hq)⟩

abbrev Activa {A : Type} (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (n : ℕ) : Prop :=
  PoliticasPrefijo.Inicia H p defecto n ∧ PoliticasFalsas.elegible p defecto ((traza H p).take n)

theorem semilla_inyectiva {A : Type} (H : Entrada → Digest) (p : Programa A) (defecto : Digest)
    (n m : ℕ) (hn : PoliticasPrefijo.Inicia H p defecto n) (hm : PoliticasPrefijo.Inicia H p defecto m)
    (hs : SemillaProxima.semilla p defecto ((traza H p).take n) =
      SemillaProxima.semilla p defecto ((traza H p).take m)) : n = m := by
  have hfn := PrimeraExposicion.indice_primero (entradas H p) n _ hn.1
    (by simpa only [List.mem_toFinset, entradas, List.map_take] using hn.2)
  have hfm := PrimeraExposicion.indice_primero (entradas H p) m _ hm.1
    (by simpa only [List.mem_toFinset, entradas, List.map_take] using hm.2)
  rw [hs] at hfn
  exact hfn.symm.trans hfm

@[expose] noncomputable def nonces {A : Type} (H : Entrada → Digest) (p : Programa A) : Finset Entrada :=
  ((entradas H p).filter (fun q => q.length = 49)).toFinset

theorem carga_nonces {A : Type} (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (N : ℕ) :
    ConteoActivaciones.numero (fun n : Fin N => fun H => Activa H p defecto n.val) H ≤ (nonces H p).card := by
  let I := {n : Fin N // Activa H p defecto n.val}
  have hq (i : I) := nonce_en_pasado H p defecto i.val.val i.property.2
  let f : I → ↥(nonces H p) := fun i => ⟨Classical.choose (hq i), by
    have hi := Classical.choose_spec (hq i)
    exact List.mem_toFinset.mpr (List.mem_filter.mpr
      ⟨List.mem_of_mem_take hi.2.1, by simpa only [decide_eq_true_eq] using hi.1⟩)⟩
  have hf : Function.Injective f := by
    intro i j hij
    have hsame : Classical.choose (hq i) = Classical.choose (hq j) := congrArg Subtype.val hij
    have hi := Classical.choose_spec (hq i)
    have hj := Classical.choose_spec (hq j)
    have hs := hi.2.2.symm.trans ((congrArg H hsame).trans hj.2.2)
    exact Subtype.ext (Fin.ext (semilla_inyectiva H p defecto i.val.val j.val.val i.property.1 j.property.1 hs))
  have hcard := Fintype.card_le_of_injective f hf
  simpa only [I, ConteoActivaciones.numero, Fintype.card_subtype, Fintype.card_coe] using hcard

theorem carga_llamadas_nonce {A : Type} (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (N : ℕ) :
    ConteoActivaciones.numero (fun n : Fin N => fun H => Activa H p defecto n.val) H ≤
      ((entradas H p).filter (fun q => q.length = 49)).length :=
  (carga_nonces H p defecto N).trans (List.toFinset_card_le _)

end Nexus.Verificador.NonceCandidato
