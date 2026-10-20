module

public import Nexus.FRI.ListaCampo
public import Nexus.Verificador.FiltroFalso
import Mathlib.Tactic

/-!
# Prefijo AIR/FRI construido desde la vista anterior a los índices

Las funciones, constantes y retos se extraen de la propia vista. Esta
construcción determinista no declara que sus retos sean uniformes ni que
los vectores ya estuvieran fijados antes de cada reto E.
-/

public section
namespace Nexus.Canal.VistaCampo

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM VistaSemantica
open Nexus.Verificador.FiltroFalso

@[expose] def FormaVista (v : Vista) : Prop :=
  v.traza.length = v.datos.k ∧ v.composicion.length = v.datos.k + 1 ∧
    v.traza.head? = some v.base

@[expose] def betasTraza (v : Vista) : List Fp2 := (v.retos.drop 3).take v.datos.k
@[expose] def betasComposicion (v : Vista) : List Fp2 := v.retos.drop (3 + v.datos.k)
@[expose] def alfas (v : Vista) : Nexus.N01.Coeficientes Fp2 :=
  (v.retos.getD 0 0, v.retos.getD 1 0, v.retos.getD 2 0)

@[expose] noncomputable def prefijo (v : Vista) : PrefijoConsulta where
  traza := fun j _ => ListaCampo.oraculos v.datos.k v.traza v.datos.vt j
  composicion := fun j _ => ListaCampo.oraculos v.datos.k v.composicion v.datos.vc j
  betaTraza := fun j => (betasTraza v).getD j 0
  betaComposicion := fun j => (betasComposicion v).getD j 0
  constanteTraza := v.datos.vt
  constanteComposicion := v.datos.vc
  coeficientes := alfas v

theorem oraculo_traza (v : Vista) : oraculoTraza (prefijo v) =
    ListaCampo.oraculos v.datos.k v.traza v.datos.vt := rfl

theorem oraculo_composicion (v : Vista) : oraculoComposicion (prefijo v) =
    ListaCampo.oraculos v.datos.k v.composicion v.datos.vc := rfl

theorem traza_inicial (v : Vista) (hv : FormaVista v) :
    oraculoTraza (prefijo v) 0 = VectoresCampo.funcion v.datos.k 0 v.base := by
  rw [oraculo_traza]
  cases ht : v.traza with
  | nil => have hf := hv.2.2; rw [ht] at hf; contradiction
  | cons t ts =>
    have he : t = v.base := Option.some.inj (by simpa only [ht, List.head?_cons] using hv.2.2)
    rw [he]
    exact ListaCampo.inicial _ _ _ _

theorem alfas_de_lista (v : Vista) (a b c : Fp2) (h : v.retos.take 3 = [a, b, c]) :
    alfas v = (a, b, c) := by
  have he := List.take_append_drop 3 v.retos
  rw [h] at he
  unfold alfas
  rw [← he]
  rfl

theorem forma_construida (t : Tabla Entrada Digest) (defecto : Digest)
    (d : ParametrosRecuperados.DatosCanal) (es : List Entrada) (hd : Admisible d) :
    FormaVista (construir t defecto d es) := by
  refine ⟨?_, ?_, ?_⟩
  · simpa only [construir, capas, List.length_map, List.length_zipIdx] using hd.2.2.1
  · simpa only [construir, capas, List.length_map, List.length_zipIdx] using hd.2.2.2.1
  · have hh := hd.2.2.2.2
    cases ht : d.rt with
    | nil => rw [ht] at hh; contradiction
    | cons r rs =>
      have hr : r = d.raiz := Option.some.inj (by simpa only [ht, List.head?_cons] using hh)
      simp [construir, capas, ht, hr]

theorem lectura_canonica (t : Tabla Entrada Digest) (defecto s : Digest)
    (d : ParametrosRecuperados.DatosCanal) (hc : Canonico t defecto s d) :
    VistaSemantica.leer t defecto s = some
      (construir t defecto d (ReconstruccionSelector.candidato t s)) := by
  rw [VistaSemantica.leer]
  change (Nexus.Verificador.SemanticaPrevia.interpretar t s).map _ = _
  rw [parametros_canonicos t defecto s d hc]
  rfl

theorem forma_canonica (t : Tabla Entrada Digest) (defecto s : Digest)
    (d : ParametrosRecuperados.DatosCanal) (hc : Canonico t defecto s d) :
    FormaVista (construir t defecto d (ReconstruccionSelector.candidato t s)) :=
  forma_construida t defecto d _ hc.perfil

end Nexus.Canal.VistaCampo
