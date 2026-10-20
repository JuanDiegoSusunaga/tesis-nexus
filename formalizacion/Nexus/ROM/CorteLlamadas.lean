module

public import Nexus.ROM.PrefijoPrograma
public import Nexus.ROM.PrefijoCorte
import Mathlib.Tactic

/-!
# El corte de entradas nuevas procede de un prefijo de llamadas

Se localiza la primera aparición en la transcripción completa, aun si el
adversario hizo la consulta antes del verificador. Su tabla memorizada es
exactamente la tabla anterior del corte causal.
-/

public section
namespace Nexus.ROM.CorteLlamadas

open Nexus.Bytes Nexus.Merkle ProgramaBytes EjecucionBytes PrefijoPrograma

variable {A : Type}
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem entrada_corte (H : Entrada → Digest) (B : ℕ) (p : Programa A) (e : Entrada)
    (c : CorteConsulta (inicial B) (final H (inicial B) p) e (H e)) : e ∈ entradas H p := by
  have hm : e ∈ (final H (inicial B) p).tabla.map Prod.fst := List.mem_map.mpr
    ⟨(e, H e), buscar_some_mem _ _ _ (corte_respuesta_final c), rfl⟩
  rw [tabla_final] at hm
  exact (TablaObservada.claves_tabla _ e).mp hm

theorem primera_de_entrada (H : Entrada → Digest) (p : Programa A) (e : Entrada)
    (he : e ∈ entradas H p) :
    ∃ n, n < (traza H p).length ∧ (entradas H p)[n]? = some e ∧
      e ∉ ((traza H p).take n).map Prod.fst := by
  refine ⟨(entradas H p).idxOf e, ?_, List.getElem?_idxOf he, ?_⟩
  · simpa only [entradas, List.length_map] using List.idxOf_lt_length_of_mem he
  · rw [List.map_take]
    change e ∉ (entradas H p).take ((entradas H p).idxOf e)
    simp only [List.mem_take_iff_idxOf_lt he, lt_self_iff_false, not_false_eq_true]

theorem existe_corte (H : Entrada → Digest) (B : ℕ) (p : Programa A)
    (hs : SinBad H (inicial B) p) (n : ℕ) (e : Entrada)
    (hn : (entradas H p)[n]? = some e) (hf : e ∉ ((traza H p).take n).map Prod.fst) :
    ∃ c : CorteConsulta (inicial B) (final H (inicial B) p) e (H e),
      c.antes.tabla = TablaObservada.tabla ((traza H p).take n) := by
  have hc0 : Compatibles H (inicial B).tabla := by intro a d hd; contradiction
  let st := estado H (inicial B) p n
  have ht : st.tabla = TablaObservada.tabla ((traza H p).take n) := tabla_desde_vacio H B p n
  have hnew : buscar st.tabla e = none := by
    apply (buscar_none_iff _ _).mpr
    rw [ht]
    exact (TablaObservada.claves_tabla _ e).not.mpr hf
  have hnext : proxima (resto H p n) = some e := by
    rw [← reanudar_prefijo]
    exact (proxima_prefijo H p n).trans hn
  have hsr := sinbad_resto H (inicial B) p n hs
  have hcr := compatible_estado H (inicial B) p n hc0
  cases hp : resto H p n with
  | terminar a => simp only [hp, proxima, reduceCtorEq] at hnext
  | consultar a f =>
    have hae : a = e := Option.some.inj (by simpa only [hp, proxima] using hnext)
    subst a
    rw [hp] at hsr
    have hadv : avanzar H st e = estadoNuevo st (solicitar st e) (H e) hnew := by
      rw [avanzar, dite_eq_left hnew]
    have hfin : final H (avanzar H st e) (f (H e)) = final H (inicial B) p := by
      simpa only [hp, final] using final_resto H (inicial B) p n
    refine ⟨⟨st, solicitar st e, rfl, hnew, hsr.1 hnew,
      recorrido_prefijo H (inicial B) p n hc0 hs, ?_⟩, ht⟩
    rw [← hadv, ← hfin]
    exact recorrido_desde_programa H (avanzar H st e) (f (H e)) (avanzar_compatible H st e hcr) hsr.2

theorem tabla_corte (H : Entrada → Digest) (B : ℕ) (p : Programa A)
    (hs : SinBad H (inicial B) p) (e : Entrada)
    (c : CorteConsulta (inicial B) (final H (inicial B) p) e (H e))
    (n : ℕ) (hn : (entradas H p)[n]? = some e) (hf : e ∉ ((traza H p).take n).map Prod.fst) :
    c.antes.tabla = TablaObservada.tabla ((traza H p).take n) := by
  obtain ⟨d, hd⟩ := existe_corte H B p hs n e hn hf
  rw [PrefijoCorte.tabla_antes c, ← PrefijoCorte.tabla_antes d]
  exact hd

theorem corte_en_llamadas (H : Entrada → Digest) (B : ℕ) (p : Programa A)
    (hs : SinBad H (inicial B) p) (e : Entrada) (he : e ∈ entradas H p)
    (c : CorteConsulta (inicial B) (final H (inicial B) p) e (H e)) :
    ∃ n, n < (traza H p).length ∧ (entradas H p)[n]? = some e ∧
      e ∉ ((traza H p).take n).map Prod.fst ∧
      c.antes.tabla = TablaObservada.tabla ((traza H p).take n) := by
  obtain ⟨n, hn, hnext, hf⟩ := primera_de_entrada H p e he
  exact ⟨n, hn, hnext, hf, tabla_corte H B p hs e c n hnext hf⟩

end Nexus.ROM.CorteLlamadas
