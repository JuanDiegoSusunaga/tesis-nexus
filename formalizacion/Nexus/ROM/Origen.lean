module

public import Nexus.ROM.Preparacion
import Mathlib.Tactic

/-!
# Origen de una entrada almacenada

Cada par de la tabla procede del estado inicial o de un paso nuevo del
recorrido. El corte conserva la solicitud original, la tabla anterior y los
recorridos a ambos lados. Una consulta repetida no cambia ese origen.
-/

public section
namespace Nexus.ROM

open Nexus.Merkle

theorem recorrido_tabla_prefijo {B : ℕ} {a b : Estado B} (r : RecorridoSinAcierto B a b) :
    ∃ resto : Tabla Entrada Digest, b.tabla = a.tabla ++ resto := by
  induction r with
  | refl => exact ⟨[], (List.append_nil _).symm⟩
  | repetida previo q d hd ih => exact ih
  | nueva previo q d hn hd ih =>
    obtain ⟨resto, he⟩ := ih
    exact ⟨resto ++ [(q.entrada, d)], by simp only [estadoNuevo, he, List.append_assoc]⟩

theorem recorrido_longitud_mono {B : ℕ} {a b : Estado B} (r : RecorridoSinAcierto B a b) :
    a.tabla.length ≤ b.tabla.length := by
  obtain ⟨resto, he⟩ := recorrido_tabla_prefijo r
  rw [he, List.length_append]
  omega

theorem buscar_persiste_en_recorrido {B : ℕ} {a b : Estado B} (r : RecorridoSinAcierto B a b)
    (e : Entrada) (d : Digest) (he : buscar a.tabla e = some d) : buscar b.tabla e = some d :=
  buscar_de_mem b.tabla b.sinRepetidos e d (recorrido_tablas_incluidas r _ (buscar_some_mem _ _ _ he))

theorem buscar_ausente_en_prefijo {B : ℕ} {a b : Estado B} (r : RecorridoSinAcierto B a b)
    (e : Entrada) (he : buscar b.tabla e = none) : buscar a.tabla e = none := by
  cases ha : buscar a.tabla e with
  | none => rfl
  | some d =>
    have hb := buscar_persiste_en_recorrido r e d ha
    rw [he] at hb
    cases hb

structure CorteConsulta {B : ℕ} (inicio fin : Estado B) (entrada : Entrada) (respuesta : Digest) where
  antes : Estado B
  solicitud : Solicitud antes
  entrada_eq : solicitud.entrada = entrada
  nueva : buscar antes.tabla solicitud.entrada = none
  sinAcierto : respuesta ∉ antesRespuesta antes solicitud
  prefijo : RecorridoSinAcierto B inicio antes
  sufijo : RecorridoSinAcierto B (estadoNuevo antes solicitud respuesta nueva) fin

@[expose] def CorteConsulta.despues {B : ℕ} {inicio fin : Estado B} {e : Entrada} {d : Digest}
    (c : CorteConsulta inicio fin e d) : Estado B := estadoNuevo c.antes c.solicitud d c.nueva

@[expose] def CorteConsulta.prolongar {B : ℕ} {inicio medio fin : Estado B} {e : Entrada} {d : Digest}
    (c : CorteConsulta inicio medio e d) (r : RecorridoSinAcierto B medio fin) :
    CorteConsulta inicio fin e d :=
  ⟨c.antes, c.solicitud, c.entrada_eq, c.nueva, c.sinAcierto, c.prefijo, recorrido_trans c.sufijo r⟩

theorem corte_paso {B : ℕ} {inicio fin : Estado B} {e : Entrada} {d : Digest}
    (c : CorteConsulta inicio fin e d) : PasoSinAcierto c.antes c.solicitud d c.despues :=
  .nueva d c.nueva c.sinAcierto

theorem corte_entrada_ausente {B : ℕ} {inicio fin : Estado B} {e : Entrada} {d : Digest}
    (c : CorteConsulta inicio fin e d) : buscar c.antes.tabla e = none := by
  exact (congrArg (buscar c.antes.tabla) c.entrada_eq).symm.trans c.nueva

theorem corte_respuesta_final {B : ℕ} {inicio fin : Estado B} {e : Entrada} {d : Digest}
    (c : CorteConsulta inicio fin e d) : buscar fin.tabla e = some d := by
  rw [← c.entrada_eq]
  exact buscar_persiste_en_recorrido c.sufijo _ d (paso_respuesta_guardada (corte_paso c))

theorem consulta_registrada_o_nueva {B : ℕ} {inicio fin : Estado B}
    (r : RecorridoSinAcierto B inicio fin) (e : Entrada) (valor : Digest) (hm : (e, valor) ∈ fin.tabla) :
    (e, valor) ∈ inicio.tabla ∨ Nonempty (CorteConsulta inicio fin e valor) := by
  induction r with
  | refl => exact Or.inl hm
  | @repetida actual previo q d hd ih =>
    rcases ih hm with hi | hc
    · exact Or.inl hi
    · obtain ⟨c⟩ := hc
      exact Or.inr ⟨c.prolongar (.repetida (.refl actual) q d hd)⟩
  | @nueva actual previo q d hn hd ih =>
    rcases List.mem_append.mp hm with hi | hi
    · rcases ih hi with h0 | hc
      · exact Or.inl h0
      · obtain ⟨c⟩ := hc
        exact Or.inr ⟨c.prolongar (.nueva (.refl actual) q d hn hd)⟩
    · obtain ⟨he, hv⟩ := Prod.mk.inj (List.mem_singleton.mp hi)
      subst e
      subst valor
      exact Or.inr ⟨⟨actual, q, rfl, hn, hd, previo, .refl _⟩⟩

theorem origen_de_consulta_ausente {B : ℕ} {inicio fin : Estado B}
    (r : RecorridoSinAcierto B inicio fin) (e : Entrada) (d : Digest)
    (hn : buscar inicio.tabla e = none) (hd : buscar fin.tabla e = some d) :
    Nonempty (CorteConsulta inicio fin e d) := by
  rcases consulta_registrada_o_nueva r e d (buscar_some_mem _ _ _ hd) with hm | hc
  · have he := buscar_de_mem inicio.tabla inicio.sinRepetidos e d hm
    rw [hn] at he
    cases he
  · exact hc

theorem origen_desde_vacio {B : ℕ} {fin : Estado B} (r : RecorridoSinAcierto B (inicial B) fin)
    (e : Entrada) (d : Digest) (hd : buscar fin.tabla e = some d) :
    Nonempty (CorteConsulta (inicial B) fin e d) :=
  origen_de_consulta_ausente r e d rfl hd

theorem corte_ausente_en_prefijos {B : ℕ} {inicio fin u : Estado B} {e : Entrada} {d : Digest}
    (c : CorteConsulta inicio fin e d) (r : RecorridoSinAcierto B u c.antes) : buscar u.tabla e = none :=
  buscar_ausente_en_prefijo r e (corte_entrada_ausente c)

end Nexus.ROM
