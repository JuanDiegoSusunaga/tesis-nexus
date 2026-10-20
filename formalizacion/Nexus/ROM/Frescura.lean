module

public import Nexus.ROM.Preparacion
import Mathlib.Tactic

/-!
# Una respuesta nueva precede a las entradas que la contienen

Las ventanas de entradas ya consultadas están marcadas. Una respuesta nueva
sin acierto tampoco está en las ventanas de su propia entrada. Por tanto,
cualquier entrada que contenga esa respuesta como ventana sigue ausente
inmediatamente después de almacenar la respuesta.
-/

public section
namespace Nexus.ROM

open Nexus.Bytes Nexus.Merkle

theorem ventanas_consultadas_marcadas {B : ℕ} (s : Estado B) (e : Entrada)
    (he : e ∈ s.tabla.map Prod.fst) : ventanas e ⊆ marcasEstado s := by
  obtain ⟨⟨x, d⟩, hx, hxe⟩ := List.mem_map.mp he
  change x = e at hxe
  subst x
  intro y hy
  exact Finset.mem_union_right _ (marcas_par_incluidas s.tabla (e, d) hx (Finset.mem_insert_of_mem hy))

theorem respuesta_evade_ventanas_actuales {B : ℕ} (s : Estado B) (q : Solicitud s) (d : Digest)
    (hd : d ∉ antesRespuesta s q) : d ∉ ventanas q.entrada :=
  fun h => hd (Finset.mem_union_right _ h)

theorem entrada_con_respuesta_ausente_antes {B : ℕ} (s : Estado B) (q : Solicitud s) (d : Digest)
    (hd : d ∉ antesRespuesta s q) (e : Entrada) (he : d ∈ ventanas e) : buscar s.tabla e = none := by
  apply (buscar_none_iff s.tabla e).mpr
  intro hm
  exact hd (marcas_antes_respuesta s q (ventanas_consultadas_marcadas s e hm he))

theorem entrada_con_respuesta_distinta {B : ℕ} (s : Estado B) (q : Solicitud s) (d : Digest)
    (hd : d ∉ antesRespuesta s q) (e : Entrada) (he : d ∈ ventanas e) : e ≠ q.entrada := by
  intro heq
  subst e
  exact respuesta_evade_ventanas_actuales s q d hd he

theorem entrada_con_respuesta_ausente_despues {B : ℕ} (s : Estado B) (q : Solicitud s) (d : Digest)
    (hn : buscar s.tabla q.entrada = none) (hd : d ∉ antesRespuesta s q)
    (e : Entrada) (he : d ∈ ventanas e) : buscar (estadoNuevo s q d hn).tabla e = none := by
  have ha := entrada_con_respuesta_ausente_antes s q d hd e he
  have hne := entrada_con_respuesta_distinta s q d hd e he
  simp only [estadoNuevo, buscar_append, ha, buscar, Ne.symm hne, ite_false]

theorem digest_prefijo_en_ventanas (d : Digest) (resto : List Octeto) (hr : resto.length ≤ 47) :
    d ∈ ventanas (d.val ++ resto) := by
  apply ventana_por_posicion (d.val ++ resto) 0
    (by simp only [List.length_append, d.property]; omega)
    (by simp only [List.length_append, d.property]; omega) d
  simp only [List.drop_zero]
  exact List.take_left' d.property

end Nexus.ROM
