module

public import Nexus.ROM.OrdenConsultas
import Mathlib.Tactic

/-!
# Tabla anterior a una primera consulta y sus dependencias

La tabla del corte es el prefijo exacto de entradas nuevas. Se transportan
al pasado las entradas cuya primera aparición es anterior, incluso cuando
la ejecución actual vuelve a consultar esas mismas entradas.
-/

public section
namespace Nexus.ROM.PrefijoCorte

open Nexus.Bytes Nexus.Merkle

theorem tabla_antes {B : ℕ} {inicio fin : Estado B} {e : Entrada} {d : Digest}
    (c : CorteConsulta inicio fin e d) : c.antes.tabla = fin.tabla.take (posicionConsulta fin.tabla e) := by
  rw [corte_posicion c]
  obtain ⟨resto, hr⟩ := recorrido_tabla_prefijo c.sufijo
  rw [hr]
  change _ = ((c.antes.tabla ++ _) ++ resto).take c.antes.tabla.length
  rw [List.append_assoc]
  simp

theorem consulta_anterior {B : ℕ} {inicio fin : Estado B} {e a : Entrada} {d da : Digest}
    (c : CorteConsulta inicio fin e d) (ha : buscar fin.tabla a = some da)
    (hp : posicionConsulta fin.tabla a < posicionConsulta fin.tabla e) :
    buscar c.antes.tabla a = some da := by
  have ham : a ∈ fin.tabla.map Prod.fst :=
    List.mem_map.mpr ⟨(a, da), buscar_some_mem _ _ _ ha, rfl⟩
  have htake : a ∈ (fin.tabla.map Prod.fst).take (posicionConsulta fin.tabla e) :=
    (List.mem_take_iff_idxOf_lt ham).mpr hp
  have hb : a ∈ c.antes.tabla.map Prod.fst := by
    rw [tabla_antes c, List.map_take]
    exact htake
  cases hh : buscar c.antes.tabla a with
  | none => exact False.elim ((buscar_none_iff _ _).mp hh hb)
  | some v =>
    have hf := buscar_persiste_en_recorrido
      (recorrido_trans (paso_es_recorrido (corte_paso c)) c.sufijo) a v hh
    have hv : v = da := Option.some.inj (hf.symm.trans ha)
    rw [hv]

theorem dependencia_antes {B : ℕ} {fin : Estado B} {e a : Entrada} {d da : Digest}
    (r : RecorridoSinAcierto B (inicial B) fin) (c : CorteConsulta (inicial B) fin e d)
    (ha : buscar fin.tabla a = some da) (hw : da ∈ ventanas e) :
    buscar c.antes.tabla a = some da :=
  consulta_anterior c ha (orden_estricto_por_ventana r a e da d ha (corte_respuesta_final c) hw)

end Nexus.ROM.PrefijoCorte
