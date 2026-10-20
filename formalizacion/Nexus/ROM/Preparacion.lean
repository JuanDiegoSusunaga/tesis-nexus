module

public import Nexus.ROM.RegistroFinal
import Mathlib.Tactic

/-!
# Marcas preparadas antes de responder a una consulta

Una raíz puede estar en las ventanas de la entrada actual aunque todavía
no figure en la tabla. Las marcas previas cubren las etiquetas Merkle en ese
instante y persisten tras la respuesta, también cuando la consulta se repite.
-/

public section
namespace Nexus.ROM

open Nexus.Bytes Nexus.Merkle

inductive PasoSinAcierto {B : ℕ} (s : Estado B) (q : Solicitud s) : Digest → Estado B → Prop
  | repetida (d : Digest) (hd : buscar s.tabla q.entrada = some d) :
      PasoSinAcierto s q d (estadoRepetido s q)
  | nueva (d : Digest) (hn : buscar s.tabla q.entrada = none) (hd : d ∉ antesRespuesta s q) :
      PasoSinAcierto s q d (estadoNuevo s q d hn)

theorem paso_es_recorrido {B : ℕ} {s t : Estado B} {q : Solicitud s} {d : Digest}
    (h : PasoSinAcierto s q d t) : RecorridoSinAcierto B s t := by
  cases h with
  | repetida hd => exact .repetida (.refl s) q d hd
  | nueva hn hd => exact .nueva (.refl s) q d hn hd

theorem paso_responde_memoria {B : ℕ} {s t : Estado B} {q : Solicitud s} {d : Digest}
    (h : PasoSinAcierto s q d t) : responder s.tabla q.entrada d = (d, t.tabla) := by
  cases h with
  | repetida hd => exact respuesta_repetida s.tabla q.entrada d d hd
  | nueva hn hd => exact respuesta_nueva s.tabla q.entrada d hn

theorem paso_respuesta_guardada {B : ℕ} {s t : Estado B} {q : Solicitud s} {d : Digest}
    (h : PasoSinAcierto s q d t) : buscar t.tabla q.entrada = some d := by
  cases h with
  | repetida hd => exact hd
  | nueva hn hd => exact buscar_anexado s.tabla q.entrada d hn

theorem paso_respuesta_compatible (H : Entrada → Digest) {B : ℕ} {s t : Estado B}
    {q : Solicitud s} {d : Digest} (h : PasoSinAcierto s q d t) (hc : Compatibles H t.tabla) :
    H q.entrada = d := hc _ _ (buscar_some_mem _ _ _ (paso_respuesta_guardada h))

theorem ventanas_repetidas_marcadas {B : ℕ} (s : Estado B) (q : Solicitud s) (d : Digest)
    (hd : buscar s.tabla q.entrada = some d) : ventanas q.entrada ⊆ marcasTabla s.tabla := by
  intro x hx
  exact marcas_par_incluidas s.tabla (q.entrada, d) (buscar_some_mem _ _ _ hd)
    (Finset.mem_insert_of_mem hx)

theorem marcas_previas_persisten {B : ℕ} {s t : Estado B} {q : Solicitud s} {d : Digest}
    (h : PasoSinAcierto s q d t) : antesRespuesta s q ⊆ marcasEstado t := by
  cases h with
  | repetida hd =>
    intro x hx
    rcases Finset.mem_union.mp hx with hx | hx
    · exact hx
    · exact Finset.mem_union_right _ (ventanas_repetidas_marcadas s q d hd hx)
  | nueva hn hd =>
    intro x hx
    simp only [antesRespuesta, Finset.mem_union] at hx
    simp only [marcasEstado, estadoNuevo, marcas_tabla_append, marcasTabla, marcasPar,
      Finset.mem_union, Finset.mem_insert, Finset.notMem_empty, or_false]
    tauto

theorem marcas_previas_coinciden (H : Entrada → Digest) {B : ℕ} (s : Estado B) (q : Solicitud s)
    (hc : Compatibles H s.tabla) :
    antesRespuesta s q = marcas H ((s.adicionales ∪ q.nuevas) ∪ ventanas q.entrada)
      (s.tabla.map Prod.fst) := by
  simp only [antesRespuesta, marcas, marcas_tabla_coinciden H s.tabla hc]
  ac_rfl

theorem etiquetas_antes_cubiertas (H : Entrada → Digest) {B : ℕ} (s : Estado B) (q : Solicitud s)
    (hc : Compatibles H s.tabla) (raiz : Digest) (hr : raiz ∈ antesRespuesta s q) :
    etiquetas formatoBytes H raiz (s.tabla.map Prod.fst) ⊆ antesRespuesta s q := by
  rw [marcas_previas_coinciden H s q hc] at hr ⊢
  exact etiquetas_bytes_cubiertas H _ _ raiz hr

theorem paso_seguro_desde_preparacion (H : Entrada → Digest) {B : ℕ} {s t : Estado B}
    {q : Solicitud s} {d : Digest} (h : PasoSinAcierto s q d t)
    (hc : Compatibles H t.tabla) (raiz : Digest) (hr : raiz ∈ antesRespuesta s q) :
    ExtensionSegura formatoBytes H raiz (s.tabla.map Prod.fst) (t.tabla.map Prod.fst) := by
  cases h with
  | repetida hd => exact .refl _
  | nueva hn hd =>
    have hca : Compatibles H s.tabla := fun e y he => hc e y (List.mem_append_left _ he)
    have hHd : H q.entrada = d := hc _ _ (List.mem_append_right _ (List.mem_singleton_self _))
    have hlocal : H q.entrada ∉ etiquetas formatoBytes H raiz (s.tabla.map Prod.fst) := by
      intro he
      apply hd
      rw [← hHd]
      exact etiquetas_antes_cubiertas H s q hca raiz hr he
    simpa only [estadoNuevo, List.map_append, List.map_cons, List.map_nil] using
      ExtensionSegura.paso (.refl _) q.entrada hlocal

end Nexus.ROM
