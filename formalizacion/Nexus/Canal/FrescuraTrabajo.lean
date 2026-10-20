module

public import Nexus.Canal.PrimerosPares
public import Nexus.ROM.CorteLlamadas
import Mathlib.Tactic

/-!
# Los cortes de primeras parejas preceden también al primer índice

La ausencia de Bad solo se usa para la inclusión determinista: si la
respuesta del nonce se usa como estado I, la consulta del nonce precede a
esa I. No se condiciona a SinBad la ley probabilística de las respuestas.
-/

public section
namespace Nexus.Canal.FrescuraTrabajo

open Nexus.Bytes Nexus.Merkle Nexus.ROM ProgramaBytes

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

variable {A : Type}

@[expose] def reetiquetar {B : ℕ} {inicio fin : Estado B} {e e' : Entrada} {d d' : Digest}
    (c : CorteConsulta inicio fin e d) (he : e = e') (hd : d = d') : CorteConsulta inicio fin e' d' where
  antes := c.antes
  solicitud := c.solicitud
  entrada_eq := c.entrada_eq.trans he
  nueva := c.nueva
  sinAcierto := hd ▸ c.sinAcierto
  prefijo := c.prefijo
  sufijo := hd ▸ c.sufijo

theorem indice_fresco (H : Entrada → Digest) (B : ℕ) (p : Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (n : ℕ) (qn : Entrada)
    (hqn : qn ∈ entradas H p) (hn : qn ∉ (entradas H p).take n) :
    entradaReto (H qn) .indice ∉ (entradas H p).take n := by
  intro hi
  let qi := entradaReto (H qn) .indice
  have hifull : qi ∈ entradas H p := List.mem_of_mem_take hi
  let m := (entradas H p).idxOf qi
  have hm : m < n := (List.mem_take_iff_idxOf_lt hifull).mp hi
  have hget : (entradas H p)[m]? = some qi := List.getElem?_idxOf hifull
  have hnew : qi ∉ ((traza H p).take m).map Prod.fst := by
    rw [List.map_take]
    exact (List.mem_take_iff_idxOf_lt hifull).not.mpr (by exact Nat.lt_irrefl _)
  obtain ⟨c, hc⟩ := CorteLlamadas.existe_corte H B p hs m qi hget hnew
  have hr := EjecucionBytes.recorrido_desde_programa H (inicial B) p
    (by intro e d he; contradiction) hs
  have hq := EjecucionBytes.consulta_en_tabla H (inicial B) p
    (by intro e d he; contradiction) qn hqn
  have hbefore := PrefijoCorte.dependencia_antes hr c hq (estado_reto_en_ventanas (H qn) .indice)
  rw [hc] at hbefore
  have hmem := (TablaObservada.claves_tabla ((traza H p).take m) qn).mp
    (List.mem_map.mpr ⟨(qn, H qn), buscar_some_mem _ _ _ hbefore, rfl⟩)
  have hraw : qn ∈ (entradas H p).take m := by simpa only [entradas, List.map_take] using hmem
  exact hn ((List.mem_take_iff_idxOf_lt hqn).mpr (((List.mem_take_iff_idxOf_lt hqn).mp hraw).trans hm))

theorem corte_inicio (H : Entrada → Digest) (B : ℕ) (p : Programa A) (defecto : Digest)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (n : ℕ) (hn : PrimerosPares.Inicia H p defecto n) :
    let k := PrimerosPares.clave p defecto ((traza H p).take n)
    ∃ b : Bool, ∃ c : CorteConsulta (inicial B) (EjecucionBytes.final H (inicial B) p)
        (PrefijoTrabajo.consulta b k.1 k.2) (H (PrefijoTrabajo.consulta b k.1 k.2)),
      c.antes.tabla = TablaObservada.tabla ((traza H p).take n) := by
  dsimp only
  have hr := hn.1
  rw [PrimerosPares.siguiente_prefijo] at hr
  cases he : (entradas H p)[n]? with
  | none => simp only [he, Option.bind_none, reduceCtorEq] at hr
  | some e =>
    have hleer : ParTrabajo.leer e = some (PrimerosPares.clave p defecto ((traza H p).take n)) := by
      simpa only [he, Option.bind_some] using hr
    obtain ⟨b, hb⟩ := (ParTrabajo.leer_iff e _).mp hleer
    have hf := PrimerosPares.frescura_ambas H p defecto n hn b
    obtain ⟨c, hc⟩ := CorteLlamadas.existe_corte H B p hs n
      (PrefijoTrabajo.consulta b (PrimerosPares.clave p defecto ((traza H p).take n)).1
        (PrimerosPares.clave p defecto ((traza H p).take n)).2)
      (by rw [hb]; exact he) (by simpa only [entradas, List.map_take] using hf)
    exact ⟨b, c, hc⟩

end Nexus.Canal.FrescuraTrabajo
