module

public import Nexus.Merkle.AperturasPrograma
public import Nexus.Canal.VistaSemantica
import Mathlib.Tactic

/-!
# Valores autenticados en la tabla final del programa

El soporte efectivo de una apertura permite leer su valor sin consultar H
fuera de la tabla. La ausencia de colisiones se deriva del recorrido SinBad;
su uso es determinista y no condiciona una distribución de respuestas.
-/

public section
namespace Nexus.ROM.ValoresFinales

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.Canal.VistaSemantica
open AperturasPrograma

theorem tabla_sin_colisiones {A : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) :
    SinColisiones H ((EjecucionBytes.final H (inicial B) p).tabla.map Prod.fst) := by
  have hc0 : Compatibles H (inicial B).tabla := by intro e d hd; contradiction
  exact recorrido_sin_colisiones H (EjecucionBytes.recorrido_desde_programa H _ p hc0 hs)
    (EjecucionBytes.final_compatible H _ p hc0) (by intro e he; contradiction)

theorem consulta_guardada {A : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa A)
    (e : Entrada) (he : e ∈ ProgramaBytes.entradas H p) :
    e ∈ (EjecucionBytes.final H (inicial B) p).tabla.map Prod.fst := by
  have h := EjecucionBytes.consulta_en_tabla H (inicial B) p (by intro e d hd; contradiction) e he
  exact List.mem_map.mpr ⟨(e, H e), buscar_some_mem _ _ _ h, rfl⟩

theorem valor_en_tabla (H : Entrada → Digest) (t : Tabla Entrada Digest)
    (ht : SinRepetidos t) (hc : Compatibles H t) (hs : SinColisiones H (t.map Prod.fst))
    (defecto : Digest) (a : Apertura) (hi : a.indice < 2 ^ a.altura) (ha : Valida H a)
    (hq : Registrada H (t.map Prod.fst) a) : valor t defecto a.altura a.raiz a.indice = a.valor := by
  have he := funciones_compatibles_coinciden (funcionTabla defecto t) H t
    (funcion_tabla_compatible defecto t ht) hc
  unfold valor vectorIndexado
  simp only [Nat.mod_eq_of_lt hi]
  rw [extraer_congruente _ H _ he]
  exact apertura_indexada_extraida formatoBytes H (t.map Prod.fst) hs a.raiz a.altura a.indice hi
    a.valor a.hermanos ha hq

theorem valor_del_programa {A : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (defecto : Digest) (a : Apertura)
    (hi : a.indice < 2 ^ a.altura) (ha : Valida H a)
    (hq : Registrada H (ProgramaBytes.entradas H p) a) :
    valor (EjecucionBytes.final H (inicial B) p).tabla defecto a.altura a.raiz a.indice = a.valor := by
  apply valor_en_tabla H _ (EjecucionBytes.final H (inicial B) p).sinRepetidos
    (EjecucionBytes.final_compatible H _ p (by intro e d hd; contradiction))
    (tabla_sin_colisiones H B p hs) defecto a hi ha
  exact registrada_monotona H _ _ (consulta_guardada H B p) a hq

end Nexus.ROM.ValoresFinales
