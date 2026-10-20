module

public import Nexus.ROM.PrefijoPrograma
public import Nexus.Canal.Entradas
import Mathlib.Tactic

/-!
# Semilla previsible desde la próxima llamada

El programa residual se reconstruye con las respuestas pasadas. Se toma
el prefijo de 32 octetos de su próxima entrada; la activación comprueba
además que la entrada completa sea precisamente I de esa semilla.
-/

public section
namespace Nexus.Canal.SemillaProxima

open Nexus.Bytes Nexus.Merkle Nexus.ROM ProgramaBytes PrefijoPrograma

variable {A : Type}

@[expose] def leer (defecto : Digest) (e : Entrada) : Digest :=
  if h : (e.take 32).length = 32 then ⟨e.take 32, h⟩ else defecto

@[expose] def semilla (p : Programa A) (defecto : Digest) (t : List (Entrada × Digest)) : Digest :=
  ((proxima (reanudar p t)).map (leer defecto)).getD defecto

theorem leer_indice (defecto s : Digest) : leer defecto (entradaReto s .indice) = s := by
  have ht : (entradaReto s .indice).take 32 = s.val := by
    exact List.take_left' s.property
  have hl : ((entradaReto s .indice).take 32).length = 32 := ht ▸ s.property
  unfold leer
  rw [dite_eq_left hl]
  exact Subtype.ext ht

theorem semilla_indice (p : Programa A) (defecto s : Digest) (t : List (Entrada × Digest))
    (he : proxima (reanudar p t) = some (entradaReto s .indice)) : semilla p defecto t = s := by
  simp only [semilla, he, Option.map_some, Option.getD_some, leer_indice]

theorem semilla_prefijo (H : Entrada → Digest) (p : Programa A) (defecto s : Digest) (n : ℕ)
    (he : (entradas H p)[n]? = some (entradaReto s .indice)) :
    semilla p defecto ((traza H p).take n) = s :=
  semilla_indice p defecto s _ ((proxima_prefijo H p n).trans he)

end Nexus.Canal.SemillaProxima
