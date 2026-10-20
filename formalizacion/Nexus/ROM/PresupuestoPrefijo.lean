module

public import Nexus.Verificador.PoliticasPrefijo
import Mathlib.Tactic

/-!
# Presupuesto del pasado anterior a una dirección fresca

La próxima entrada pertenece al registro completo y no al prefijo. Por
tanto el pasado tiene al menos una entrada distinta menos que el total.
Este argumento cuenta entradas del programa, sin identificar su altura con Q.
-/

public section
namespace Nexus.ROM.PresupuestoPrefijo

open Nexus.Bytes Nexus.Merkle Nexus.Canal Nexus.Verificador
open ProgramaBytes PoliticasPrefijo

variable {A : Type}

theorem frescura_descuenta (l : List Entrada) (n : ℕ) (e : Entrada)
    (hn : l[n]? = some e) (hf : e ∉ (l.take n).toFinset) :
    (l.take n).toFinset.card < l.toFinset.card := by
  have he : e ∈ l.toFinset := List.mem_toFinset.mpr (List.mem_of_getElem? hn)
  have hsub : (l.take n).toFinset ⊆ l.toFinset.erase e := by
    intro x hx
    refine Finset.mem_erase.mpr ⟨?_, List.mem_toFinset.mpr (List.mem_of_mem_take (List.mem_toFinset.mp hx))⟩
    intro hxe
    exact hf (hxe ▸ hx)
  have hb := Finset.card_le_card hsub
  rw [Finset.card_erase_of_mem he] at hb
  have hp := Finset.card_pos.mpr ⟨e, he⟩
  omega

theorem activacion_descuenta (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (n : ℕ)
    (hi : Inicia H p defecto n) :
    (((traza H p).take n).map Prod.fst).toFinset.card < (entradas H p).toFinset.card := by
  have h := frescura_descuenta (entradas H p) n _ hi.1 (by simpa only [entradas, List.map_take] using hi.2)
  simpa only [entradas, List.map_take] using h

theorem prefijo_desde_total (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (n B : ℕ)
    (hi : Inicia H p defecto n) (hb : (entradas H p).toFinset.card ≤ B) :
    (((traza H p).take n).map Prod.fst).toFinset.card ≤ B - 1 := by
  have h := activacion_descuenta H p defecto n hi
  omega

theorem total_desde_altura (H : Entrada → Digest) (p : Programa A) :
    (entradas H p).toFinset.card ≤ altura p := by
  have h := List.toFinset_card_le (entradas H p)
  have ht := costo_acotado H p
  simp only [entradas, List.length_map] at h
  exact h.trans ht

theorem estado_desde_total (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (n B L : ℕ)
    (hi : Inicia H p defecto n) (hb : (entradas H p).toFinset.card ≤ B) :
    (PrefijoPrograma.estado H (inicial L) p n).tabla.length ≤ B - 1 := by
  rw [cantidad_entradas]
  exact prefijo_desde_total H p defecto n B hi hb

end Nexus.ROM.PresupuestoPrefijo
