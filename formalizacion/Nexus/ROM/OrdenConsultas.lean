module

public import Nexus.ROM.Frescura
public import Nexus.ROM.Origen
import Mathlib.Tactic

/-!
# Orden de primeras consultas en el grafo de ventanas

La posición de una entrada en la tabla es su número de respuestas nuevas
anteriores. Si una respuesta aparece en las ventanas de otra entrada, el
origen de esta última está después del primero. La afirmación usa el registro
completo, aunque las llamadas actuales a esas entradas sean repeticiones.
-/

public section
namespace Nexus.ROM

open Nexus.Merkle

@[expose] def posicionConsulta (tabla : Tabla Entrada Digest) (e : Entrada) : ℕ :=
  (tabla.map Prod.fst).idxOf e

theorem corte_posicion {B : ℕ} {inicio fin : Estado B} {e : Entrada} {d : Digest}
    (c : CorteConsulta inicio fin e d) : posicionConsulta fin.tabla e = c.antes.tabla.length := by
  obtain ⟨resto, he⟩ := recorrido_tabla_prefijo c.sufijo
  have hn := (buscar_none_iff c.antes.tabla e).mp (corte_entrada_ausente c)
  unfold posicionConsulta
  rw [he]
  simp only [estadoNuevo, List.map_append, List.map_cons,
    c.entrada_eq, List.append_assoc, List.singleton_append]
  rw [List.idxOf_append_of_notMem hn]
  simp only [List.idxOf_cons_self, List.length_map, Nat.add_zero]

theorem corte_posicion_dentro {B : ℕ} {inicio fin : Estado B} {e : Entrada} {d : Digest}
    (c : CorteConsulta inicio fin e d) : posicionConsulta fin.tabla e < fin.tabla.length := by
  have hl := recorrido_longitud_mono c.sufijo
  simp only [estadoNuevo, List.length_append, List.length_cons, List.length_nil] at hl
  rw [corte_posicion c]
  omega

structure ConsultasOrdenadas {B : ℕ} (fin : Estado B) (a b : Entrada) (da db : Digest) where
  primera : CorteConsulta (inicial B) fin a da
  segunda : CorteConsulta primera.despues fin b db

theorem segunda_tiene_prefijo {B : ℕ} {fin : Estado B} {a b : Entrada} {da db : Digest}
    (c : ConsultasOrdenadas fin a b da db) : RecorridoSinAcierto B (inicial B) c.segunda.antes :=
  recorrido_trans c.primera.prefijo
    (recorrido_trans (paso_es_recorrido (corte_paso c.primera)) c.segunda.prefijo)

theorem consultas_ordenadas_longitud {B : ℕ} {fin : Estado B} {a b : Entrada} {da db : Digest}
    (c : ConsultasOrdenadas fin a b da db) : c.primera.antes.tabla.length < c.segunda.antes.tabla.length := by
  have hl := recorrido_longitud_mono c.segunda.prefijo
  simp only [CorteConsulta.despues, estadoNuevo, List.length_append, List.length_cons,
    List.length_nil] at hl
  omega

theorem origenes_ordenados_por_ventana {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (a b : Entrada) (da db : Digest)
    (ha : buscar fin.tabla a = some da) (hb : buscar fin.tabla b = some db)
    (hw : da ∈ ventanas b) : Nonempty (ConsultasOrdenadas fin a b da db) := by
  obtain ⟨ca⟩ := origen_desde_vacio r a da ha
  have hn := entrada_con_respuesta_ausente_despues ca.antes ca.solicitud da ca.nueva ca.sinAcierto b hw
  obtain ⟨cb⟩ := origen_de_consulta_ausente ca.sufijo b db hn hb
  exact ⟨⟨ca, cb⟩⟩

theorem orden_estricto_por_ventana {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (a b : Entrada) (da db : Digest)
    (ha : buscar fin.tabla a = some da) (hb : buscar fin.tabla b = some db)
    (hw : da ∈ ventanas b) : posicionConsulta fin.tabla a < posicionConsulta fin.tabla b := by
  obtain ⟨c⟩ := origenes_ordenados_por_ventana r a b da db ha hb hw
  rw [corte_posicion c.primera, corte_posicion c.segunda]
  exact consultas_ordenadas_longitud c

@[expose] def DependeTabla (tabla : Tabla Entrada Digest) (a b : Entrada) : Prop :=
  ∃ da db : Digest, buscar tabla a = some da ∧ buscar tabla b = some db ∧ da ∈ ventanas b

theorem dependencia_aumenta_posicion {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) {a b : Entrada} (h : DependeTabla fin.tabla a b) :
    posicionConsulta fin.tabla a < posicionConsulta fin.tabla b := by
  obtain ⟨da, db, ha, hb, hw⟩ := h
  exact orden_estricto_por_ventana r a b da db ha hb hw

theorem dependencia_irreflexiva {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (a : Entrada) : ¬ DependeTabla fin.tabla a a := by
  intro h
  exact (Nat.lt_irrefl _) (dependencia_aumenta_posicion r h)

theorem dependencia_asimetrica {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) {a b : Entrada} (h : DependeTabla fin.tabla a b) :
    ¬ DependeTabla fin.tabla b a := by
  intro hg
  exact (Nat.lt_asymm (dependencia_aumenta_posicion r h)) (dependencia_aumenta_posicion r hg)

theorem dependencias_bien_fundadas {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) : WellFounded (DependeTabla fin.tabla) := by
  have hsub : Subrelation (DependeTabla fin.tabla)
      (InvImage (fun a b : ℕ => a < b) (posicionConsulta fin.tabla)) :=
    fun {_ _} h => dependencia_aumenta_posicion r h
  exact Subrelation.wf hsub (InvImage.wf _ Nat.lt_wfRel.wf)

end Nexus.ROM
