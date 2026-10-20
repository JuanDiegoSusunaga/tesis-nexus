module

public import Nexus.ROM.RegistroPrograma
public import Nexus.ROM.Memoria
public import Nexus.ROM.RegistroFinal
import Mathlib.Tactic

/-!
# Programas finitos con entradas de bytes arbitrarias

El adversario puede consultar listas de cualquier longitud. El programa del
verificador se incorpora conservando sus resultados y su registro. Una sola
función responde a todos los roles; la continuación solo recibe respuestas
anteriores. La finitud corresponde a programas de consultas acotados.
-/

public section
namespace Nexus.ROM.ProgramaBytes

open Nexus.Bytes Nexus.Merkle
inductive Programa (R : Type) where
  | terminar (r : R)
  | consultar (e : Entrada) (f : Digest → Programa R)

@[expose] def resultado {R : Type} (H : Entrada → Digest) : Programa R → R
  | .terminar r => r
  | .consultar e f => resultado H (f (H e))

@[expose] def traza {R : Type} (H : Entrada → Digest) : Programa R → List (Entrada × Digest)
  | .terminar _ => []
  | .consultar e f => (e, H e) :: traza H (f (H e))

@[expose] def entradas {R : Type} (H : Entrada → Digest) (p : Programa R) : List Entrada :=
  (traza H p).map Prod.fst

@[expose] def unir {R S : Type} : Programa R → (R → Programa S) → Programa S
  | .terminar r, f => f r
  | .consultar e k, f => .consultar e (fun d => unir (k d) f)

@[expose] def levantar : ProgramaCompartido.Programa → Programa Bool
  | .terminar b => .terminar b
  | .consultar q f => .consultar (Nexus.Canal.GramaticaTG2.codificar q) (fun d => levantar (f d))

theorem resultado_unir {R S : Type} (H : Entrada → Digest) (p : Programa R) (f : R → Programa S) :
    resultado H (unir p f) = resultado H (f (resultado H p)) := by
  induction p with
  | terminar r => rfl
  | consultar e k ih => exact ih _

theorem traza_unir {R S : Type} (H : Entrada → Digest) (p : Programa R) (f : R → Programa S) :
    traza H (unir p f) = traza H p ++ traza H (f (resultado H p)) := by
  induction p with
  | terminar r => rfl
  | consultar e k ih => simp only [unir, traza, resultado, ih, List.cons_append]

theorem traza_responde {R : Type} (H : Entrada → Digest) (p : Programa R) (e : Entrada) (d : Digest)
    (h : (e, d) ∈ traza H p) : H e = d := by
  induction p with
  | terminar r => contradiction
  | consultar a f ih =>
    rcases List.mem_cons.mp h with h | h
    · exact (congrArg H (Prod.mk.inj h).1).trans (Prod.mk.inj h).2.symm
    · exact ih _ h

theorem resultado_levantado (H : Entrada → Digest) (p : ProgramaCompartido.Programa) :
    resultado H (levantar p) = ProgramaCompartido.resultado (RegistroPrograma.tabla H) p := by
  induction p with
  | terminar b => rfl
  | consultar q f ih => simp only [levantar, resultado, ProgramaCompartido.resultado,
      RegistroPrograma.tabla_codificacion, ih]

theorem entradas_levantadas (H : Entrada → Digest) (p : ProgramaCompartido.Programa) :
    entradas H (levantar p) = RegistroPrograma.entradas H p := by
  induction p with
  | terminar b => rfl
  | consultar q f ih => simpa only [entradas, levantar, traza, List.map_cons,
      RegistroPrograma.entradas] using congrArg (List.cons _) (ih _)

@[expose] noncomputable def altura {R : Type} : Programa R → ℕ
  | .terminar _ => 0
  | .consultar _ f => 1 + Finset.univ.sup (fun d : Digest => altura (f d))

theorem costo_acotado {R : Type} (H : Entrada → Digest) (p : Programa R) :
    (traza H p).length ≤ altura p := by
  induction p with
  | terminar r => rfl
  | consultar e f ih =>
    have hm := Finset.le_sup (f := fun d : Digest => altura (f d)) (Finset.mem_univ (H e))
    simp only [traza, List.length_cons, altura]
    exact (Nat.add_le_add_right (ih _) 1).trans (by omega)

theorem tabla_de_traza_compatible {R : Type} (H : Entrada → Digest) (p : Programa R) :
    Compatibles H (traza H p) := fun e d h => traza_responde H p e d h

end Nexus.ROM.ProgramaBytes
