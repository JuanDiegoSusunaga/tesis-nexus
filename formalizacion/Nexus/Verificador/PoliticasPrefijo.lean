module

public import Nexus.ROM.CorteLlamadas
public import Nexus.Canal.SemillaProxima
public import Nexus.Verificador.ConjuntosPrevios
public import Nexus.ROM.SelectorAcoplado
public import Nexus.Canal.CintaSelector
import Mathlib.Tactic

/-!
# Políticas del selector fijadas por el prefijo bruto

La semilla se lee de la próxima llamada reconstruida y la tabla se obtiene
memorizando el pasado. Ninguna política recibe el certificado futuro. El
registro aceptado permite identificarlas con las del corte causal anterior.
-/

public section
namespace Nexus.Verificador.PoliticasPrefijo

open Nexus.Bytes Nexus.Merkle Nexus.ROM Nexus.Canal
open ProgramaBytes CandidatoPrevio

variable {A : Type}
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] noncomputable def GT (p : Programa A) (defecto : Digest) (e : ℕ)
    (t : List (Entrada × Digest)) : Finset (Fin (2 ^ e)) :=
  ConjuntosPrevios.GT e defecto (SemillaProxima.semilla p defecto t) (TablaObservada.tabla t)

@[expose] noncomputable def GC (p : Programa A) (defecto : Digest) (e : ℕ)
    (t : List (Entrada × Digest)) : Finset (Fin (2 ^ e)) :=
  ConjuntosPrevios.GC e defecto (SemillaProxima.semilla p defecto t) (TablaObservada.tabla t)

abbrev Inicia (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (n : ℕ) : Prop :=
  (entradas H p)[n]? = some (entradaReto (SemillaProxima.semilla p defecto ((traza H p).take n)) .indice) ∧
    entradaReto (SemillaProxima.semilla p defecto ((traza H p).take n)) .indice ∉
      (((traza H p).take n).map Prod.fst).toFinset

@[expose] noncomputable def Omite (H : Entrada → Digest) (p : Programa A) (defecto : Digest)
    (n R e : ℕ) : Prop :=
  let t := (traza H p).take n
  let T := ROM.SelectorAcoplado.salida e 40 (CintaSelector.cinta H R (SemillaProxima.semilla p defecto t))
  T.card = 40 ∧ T ⊆ GT p defecto e t ∩ GC p defecto e t

theorem registro_previsible (H : Entrada → Digest) (B : ℕ) (p : Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (k bits : ℕ) (c : Certificado)
    (r : Registro H B p k bits c) (defecto : Digest) :
    ∃ n, n < (traza H p).length ∧ Inicia H p defecto n ∧
      SemillaProxima.semilla p defecto ((traza H p).take n) = semillaCert H k bits c ∧
      r.corte.antes.tabla = TablaObservada.tabla ((traza H p).take n) := by
  have he := CorteLlamadas.entrada_corte H B p _ r.corte
  obtain ⟨n, hn, hnext, hf, ht⟩ := CorteLlamadas.corte_en_llamadas H B p hs _ he r.corte
  have hseed := SemillaProxima.semilla_prefijo H p defecto (semillaCert H k bits c) n hnext
  refine ⟨n, hn, ?_, hseed, ht⟩
  constructor
  · simpa only [hseed] using hnext
  · simpa only [hseed, List.mem_toFinset] using hf

theorem conjuntos_registro (H : Entrada → Digest) (B : ℕ) (p : Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (k bits : ℕ) (c : Certificado)
    (r : Registro H B p k bits c) (defecto : Digest) (n e : ℕ)
    (hn : (entradas H p)[n]? = some (entradaReto (semillaCert H k bits c) .indice))
    (hf : entradaReto (semillaCert H k bits c) .indice ∉ ((traza H p).take n).map Prod.fst) :
    GT p defecto e ((traza H p).take n) = ConjuntosPrevios.GT e defecto (semillaCert H k bits c) r.corte.antes.tabla ∧
    GC p defecto e ((traza H p).take n) = ConjuntosPrevios.GC e defecto (semillaCert H k bits c) r.corte.antes.tabla := by
  have hseed := SemillaProxima.semilla_prefijo H p defecto (semillaCert H k bits c) n hn
  have ht := CorteLlamadas.tabla_corte H B p hs _ r.corte n hn hf
  simp only [GT, GC, hseed, ← ht, and_self]

theorem cantidad_entradas (H : Entrada → Digest) (B : ℕ) (p : Programa A) (n : ℕ) :
    (PrefijoPrograma.estado H (inicial B) p n).tabla.length =
      (((traza H p).take n).map Prod.fst).toFinset.card := by
  rw [PrefijoPrograma.tabla_desde_vacio, TablaObservada.cardinal_tabla]

end Nexus.Verificador.PoliticasPrefijo
