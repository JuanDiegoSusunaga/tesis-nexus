module

public import Nexus.Canal.PrimerasExposiciones
public import Nexus.Canal.SemillaProxima
public import Nexus.Verificador.ExcepcionesHash
import Mathlib.Tactic

/-!
# Excepciones de E cobradas en el universo real del programa de bytes

No se agranda el universo probabilístico del selector: las direcciones E
se incluyen solo si ya pertenecen a él. La cobertura usa que una consulta
efectiva pertenece al soporte. Cada nueva dirección se cobra una sola vez.
-/

public section
namespace Nexus.Canal.ExtensionesPrefijo

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.N06 Nexus.ROM
open LeyArbol ObservacionesPrefijo PrimeraExposicion CargaPrimeras ConteoActivaciones
open SelectorAdaptativo

variable {X : Type}
attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] noncomputable def codigo (p : ProgramaBytes.Programa X) (a : Digest) : universo p :=
  if h : entradaReto a .extension ∈ universo p then ⟨entradaReto a .extension, h⟩
  else SelectorAdaptativo.codigo p a

abbrev IniciaBytes (H : Entrada → Digest) (p : ProgramaBytes.Programa X) (n : ℕ)
    (semilla : List (Entrada × Digest) → Digest) : Prop :=
  (ProgramaBytes.entradas H p)[n]? = some (entradaReto (semilla ((ProgramaBytes.traza H p).take n)) .extension) ∧
    entradaReto (semilla ((ProgramaBytes.traza H p).take n)) .extension ∉
      ((((ProgramaBytes.traza H p).take n).map Prod.fst).toFinset)

theorem codigo_conocido (p : ProgramaBytes.Programa X) (a : Digest)
    (ha : entradaReto a .extension ∈ universo p) :
    (codigo p a).val = entradaReto a .extension := by
  simp only [codigo, ha, dite_true]

theorem codigo_inicio (p : ProgramaBytes.Programa X) (defecto : Digest) (n : ℕ)
    (semilla : List (Entrada × Digest) → Digest) (H : universo p → Digest)
    (hi : IniciaBytes (oraculo p defecto H) p n semilla) :
    (codigo p (semilla (historia p defecto n H))).val =
      entradaReto (semilla (historia p defecto n H)) .extension := by
  apply codigo_conocido
  exact SelectorAcoplado.pasado_en_universo _
    (SoporteFinito.entradas_en_soporte (oraculo p defecto H) p _ (List.mem_of_getElem? hi.1))

theorem inicio_implica (p : ProgramaBytes.Programa X) (defecto : Digest) (n : ℕ)
    (semilla : List (Entrada × Digest) → Digest) (H : universo p → Digest)
    (hi : IniciaBytes (oraculo p defecto H) p n semilla) :
    Activa (arbol p) (fun t => codigo p (semilla (proyectar t))) (prefijo (arbol p) n H) := by
  rw [activa_iff]
  have hv := codigo_inicio p defecto n semilla H hi
  dsimp only [historia] at hv
  rw [prefijo_bytes p defecto]
  constructor
  · apply (Option.map_inj_right Subtype.val_injective).mp
    simpa only [Option.map_some, hv, ← PrimerasExposiciones.consulta_siguiente p defecto n H,
      ProgramaBytes.entradas, historia] using hi.1
  · have hf := (consulta_proyectada (prefijo (arbol p) n H)
      (codigo p (semilla (historia p defecto n H)))).not.mpr
      (by simpa only [prefijo_bytes p defecto, hv, historia] using hi.2)
    simpa only [List.mem_toFinset, List.map_take] using hf

theorem respuesta_inicio (p : ProgramaBytes.Programa X) (defecto : Digest) (n : ℕ)
    (semilla : List (Entrada × Digest) → Digest) (H : universo p → Digest)
    (hi : IniciaBytes (oraculo p defecto H) p n semilla) :
    H (codigo p (semilla (historia p defecto n H))) =
      oraculo p defecto H (entradaReto (semilla (historia p defecto n H)) .extension) := by
  have hv := codigo_inicio p defecto n semilla H hi
  exact (SoporteFinito.prolongar_en_universo _ defecto H _
    (codigo p (semilla (historia p defecto n H))).property).symm.trans
      (congrArg (oraculo p defecto H) hv)

theorem cardinal_distintas (p : ProgramaBytes.Programa X) (defecto : Digest) (H : universo p → Digest) :
    ((LeyArbol.traza H (arbol p)).map Prod.fst).toFinset.card =
      (ProgramaBytes.entradas (oraculo p defecto H) p).toFinset.card := by
  have h := cardinal_vistas p defecto (LeyArbol.traza H (arbol p)).length H
  have hl : (ProgramaBytes.traza (oraculo p defecto H) p).length =
      (LeyArbol.traza H (arbol p)).length := by
    rw [← PrimerasExposiciones.traza_bytes p defecto H]
    simp only [proyectar, List.length_map]
  simp only [PrefijosGlobales.vistas, List.take_length, historia] at h
  rw [← hl, List.take_length] at h
  exact h

theorem cota_programa (p : ProgramaBytes.Programa X) (defecto : Digest) (N B C : ℕ)
    (semilla : ℕ → List (Entrada × Digest) → Digest)
    (E : ℕ → List (Entrada × Digest) → Finset Fp2)
    (hE : ∀ (n : Fin N) t, (E n.val t).card ≤ C)
    (hB : ∀ H : universo p → Digest,
      (ProgramaBytes.entradas (oraculo p defecto H) p).toFinset.card ≤ B) :
    promedio (fun H : universo p → Digest => if ∃ n : Fin N,
      IniciaBytes (oraculo p defecto H) p n.val (semilla n.val) ∧
      DesafiosPrograma.extension (oraculo p defecto H
        (entradaReto (semilla n.val (historia p defecto n.val H)) .extension)) ∈
        E n.val (historia p defecto n.val H) then (1 : ℚ) else 0) ≤
      ((C : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2 + (2524360 / 10 ^ 35)) * B := by
  let dir := fun (n : ℕ) (t : List ((universo p) × Digest)) => codigo p (semilla n (proyectar t))
  have h := Nexus.Verificador.ExcepcionesHash.cota_presupuesto (arbol p) N B C dir
    (fun n t => E n (proyectar t)) (fun n _ _ => hE n _)
    (fun H => by rw [cardinal_distintas p defecto H]; exact hB H)
  refine le_trans ?_ h
  apply transferir_evento
  intro H hh
  obtain ⟨n, hi, he⟩ := hh
  refine ⟨n, inicio_implica p defecto n.val (semilla n.val) H hi, ?_⟩
  dsimp only [dir]
  rw [prefijo_bytes p defecto, respuesta_inicio p defecto n.val (semilla n.val) H hi]
  exact he

theorem leer_extension (defecto a : Digest) : SemillaProxima.leer defecto (entradaReto a .extension) = a := by
  have ht : (entradaReto a .extension).take 32 = a.val := List.take_left' a.property
  have hl : ((entradaReto a .extension).take 32).length = 32 := ht ▸ a.property
  unfold SemillaProxima.leer
  rw [dite_eq_left hl]
  exact Subtype.ext ht

theorem semilla_extension (p : ProgramaBytes.Programa X) (defecto a : Digest)
    (t : List (Entrada × Digest))
    (he : PrefijoPrograma.proxima (PrefijoPrograma.reanudar p t) = some (entradaReto a .extension)) :
    SemillaProxima.semilla p defecto t = a := by
  simp only [SemillaProxima.semilla, he, Option.map_some, Option.getD_some, leer_extension]

theorem inicio_conocido (H : Entrada → Digest) (p : ProgramaBytes.Programa X) (defecto a : Digest)
    (n : ℕ) (hn : (ProgramaBytes.entradas H p)[n]? = some (entradaReto a .extension))
    (hf : entradaReto a .extension ∉ ((ProgramaBytes.traza H p).take n).map Prod.fst) :
    IniciaBytes H p n (SemillaProxima.semilla p defecto) ∧
      SemillaProxima.semilla p defecto ((ProgramaBytes.traza H p).take n) = a := by
  have hs := semilla_extension p defecto a _ ((PrefijoPrograma.proxima_prefijo H p n).trans hn)
  exact ⟨⟨by simpa only [hs] using hn, by simpa only [hs, List.mem_toFinset] using hf⟩, hs⟩

end Nexus.Canal.ExtensionesPrefijo
