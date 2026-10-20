module

public import Nexus.ROM.ProgramaBytes
import Mathlib.Tactic

/-!
# La ejecución solo depende de las respuestas consultadas

Si dos funciones coinciden en las entradas efectivamente observadas, producen
el mismo resultado y la misma traza. La hipótesis no exige igualdad fuera del
soporte ejecutado ni independencia entre roles.
-/

public section
namespace Nexus.ROM.CoincidenciaPrograma

open Nexus.Bytes Nexus.Merkle ProgramaBytes

variable {A C : Type}

theorem entradas_terminar (H : Entrada → Digest) (a : A) : entradas H (.terminar a) = [] := rfl

theorem entradas_consultar (H : Entrada → Digest) (e : Entrada) (f : Digest → Programa A) :
    entradas H (.consultar e f) = e :: entradas H (f (H e)) := rfl

theorem entradas_unir (H : Entrada → Digest) (p : Programa A) (f : A → Programa C) :
    entradas H (unir p f) = entradas H p ++ entradas H (f (resultado H p)) := by
  simp only [entradas, traza_unir, List.map_append]

theorem ejecucion_congruente (H G : Entrada → Digest) (p : Programa A)
    (h : ∀ e ∈ entradas H p, H e = G e) :
    resultado H p = resultado G p ∧ traza H p = traza G p := by
  induction p with
  | terminar a => exact ⟨rfl, rfl⟩
  | consultar e f ih =>
    have he : H e = G e := h e (List.mem_cons_self)
    have hr := ih (H e) (fun a ha => h a (List.mem_cons_of_mem e ha))
    simp only [resultado, traza, ← he, hr.1, hr.2, and_self]

theorem entradas_congruentes (H G : Entrada → Digest) (p : Programa A)
    (h : ∀ e ∈ entradas H p, H e = G e) : entradas H p = entradas G p :=
  congrArg (List.map Prod.fst) (ejecucion_congruente H G p h).2

theorem resultado_desde_tabla (H : Entrada → Digest) (t : Tabla Entrada Digest)
    (p : Programa A) (defecto : Digest)
    (h : ∀ e ∈ entradas H p, buscar t e = some (H e)) :
    resultado (funcionTabla defecto t) p = resultado H p := by
  exact (ejecucion_congruente H (funcionTabla defecto t) p (fun e he => by
    simp only [funcionTabla, h e he, Option.getD_some])).1.symm

end Nexus.ROM.CoincidenciaPrograma
