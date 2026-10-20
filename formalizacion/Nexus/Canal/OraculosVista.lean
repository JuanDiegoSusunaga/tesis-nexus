module

public import Nexus.Canal.VistaCampo
public import Nexus.Canal.OraculosMerkle
import Mathlib.Tactic

/-!
# Las capas de la vista son los oráculos Merkle de sus raíces

La igualdad es exacta para cada índice existente. Combinada con el corte
de primera exposición, transporta el oráculo leído antes de los índices
al estado anterior a la primera respuesta E, sin fijar las raíces de antemano.
-/

public section
namespace Nexus.Canal.OraculosVista

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open VistaSemantica VistaCampo ParametrosRecuperados

theorem capa_en_indice (t : Tabla Entrada Digest) (defecto : Digest) (altura : ℕ)
    (rs : List Digest) (j : ℕ) (hj : j < rs.length) :
    (capas t defecto altura rs).getD j (fun _ => 0) =
      valor t defecto (altura - j) rs[j] := by
  have hl : j < (capas t defecto altura rs).length := by
    simpa only [capas, List.length_map, List.length_zipIdx] using hj
  unfold List.getD
  rw [List.getElem?_eq_getElem hl]
  simp only [Option.getD_some, capas, List.getElem_map, List.getElem_zipIdx, Nat.zero_add]

theorem oraculo_capas (t : Tabla Entrada Digest) (defecto : Digest) (k : ℕ)
    (rs : List Digest) (c : Fp2) (j : ℕ) (hj : j < rs.length) :
    ListaCampo.oraculos k (capas t defecto (k + 3) rs) c j =
      oraculoMerkle k j (funcionTabla defecto t) (t.map Prod.fst) rs[j] := by
  have hl : j < (capas t defecto (k + 3) rs).length := by
    simpa only [capas, List.length_map, List.length_zipIdx] using hj
  funext x
  rw [ListaCampo.oraculos, ite_eq_left hl, capa_en_indice t defecto (k + 3) rs j hj]
  exact congrFun (VectoresCampo.funcion_valor k j t defecto rs[j]) x

theorem traza_construida (t : Tabla Entrada Digest) (defecto : Digest)
    (d : DatosCanal) (es : List Entrada) (j : ℕ) (hj : j < d.rt.length) :
    oraculoTraza (prefijo (construir t defecto d es)) j =
      oraculoMerkle d.k j (funcionTabla defecto t) (t.map Prod.fst) d.rt[j] :=
  oraculo_capas t defecto d.k d.rt d.vt j hj

theorem composicion_construida (t : Tabla Entrada Digest) (defecto : Digest)
    (d : DatosCanal) (es : List Entrada) (j : ℕ) (hj : j < d.rc.length) :
    oraculoComposicion (prefijo (construir t defecto d es)) j =
      oraculoMerkle d.k j (funcionTabla defecto t) (t.map Prod.fst) d.rc[j] :=
  oraculo_capas t defecto d.k d.rc d.vc j hj

theorem traza_antes_reto {B : ℕ} {fin : Estado B} (defecto : Digest)
    (d : DatosCanal) (es : List Entrada) (j : ℕ) (hj : j < d.rt.length)
    {estado dAbs dReto : Digest} {tag : Octeto}
    (c : CorteRaizReto fin estado tag d.rt[j] .extension dAbs dReto) :
    oraculoTraza (prefijo (construir fin.tabla defecto d es)) j =
      oraculoEnEstado d.k j defecto c.segunda.antes d.rt[j] := by
  rw [traza_construida fin.tabla defecto d es j hj]
  exact (oraculo_antes_reto_estable c d.k j defecto).symm

theorem composicion_antes_reto {B : ℕ} {fin : Estado B} (defecto : Digest)
    (d : DatosCanal) (es : List Entrada) (j : ℕ) (hj : j < d.rc.length)
    {estado dAbs dReto : Digest} {tag : Octeto}
    (c : CorteRaizReto fin estado tag d.rc[j] .extension dAbs dReto) :
    oraculoComposicion (prefijo (construir fin.tabla defecto d es)) j =
      oraculoEnEstado d.k j defecto c.segunda.antes d.rc[j] := by
  rw [composicion_construida fin.tabla defecto d es j hj]
  exact (oraculo_antes_reto_estable c d.k j defecto).symm

end Nexus.Canal.OraculosVista
