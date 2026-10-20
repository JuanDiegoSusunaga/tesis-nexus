module

public import Nexus.ROM.SoporteFinito
public import Nexus.ROM.EjecucionBytes
import Mathlib.Tactic

/-!
# Recorte por llamadas con conservación del evento SinBad

El recorte tiene altura acotada en todas sus ramas, incluso las que no
pueden realizarse con un oráculo con memoria. Si una ejecución del programa
original usa a lo sumo n llamadas, su evento SinBad coincide con el del
recorte. Esto permite aprovechar presupuestos de ejecuciones reales sin
identificarlos con la altura del árbol original.
-/

public section
namespace Nexus.ROM.RecortePrograma

open Nexus.Bytes Nexus.Merkle ProgramaBytes SoporteFinito

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def recortar {R : Type} : ℕ → Programa R → Programa Unit
  | 0, _ => .terminar ()
  | _ + 1, .terminar _ => .terminar ()
  | n + 1, .consultar e k => .consultar e (fun d => recortar n (k d))

theorem altura_recortar {R : Type} (n : ℕ) (p : Programa R) :
    altura (recortar n p) ≤ n := by
  induction n generalizing p with
  | zero => exact Nat.le_refl 0
  | succ n ih =>
    cases p with
    | terminar r => exact Nat.zero_le _
    | consultar e k =>
      change 1 + Finset.univ.sup (fun d => altura (recortar n (k d))) ≤ n + 1
      have hc : Finset.univ.sup (fun d => altura (recortar n (k d))) ≤ n := by
        apply Finset.sup_le
        intro d _
        exact ih (k d)
      omega

theorem soporte_recortar {R : Type} (n : ℕ) (p : Programa R) :
    soporte (recortar n p) ⊆ soporte p := by
  induction n generalizing p with
  | zero => exact Finset.empty_subset _
  | succ n ih =>
    cases p with
    | terminar r => exact Finset.empty_subset _
    | consultar e k =>
      intro q hq
      simp only [recortar, soporte] at hq
      rcases Finset.mem_insert.mp hq with rfl | hq
      · exact Finset.mem_insert_self _ _
      · obtain ⟨d, _, hd⟩ := Finset.mem_biUnion.mp hq
        exact rama_en_soporte e k d (ih (k d) hd)

theorem sinbad_recortar_iff {R : Type} {B : ℕ} (H : Entrada → Digest)
    (n : ℕ) (p : Programa R) (s : Estado B) (hc : (traza H p).length ≤ n) :
    EjecucionBytes.SinBad H s (recortar n p) ↔ EjecucionBytes.SinBad H s p := by
  induction n generalizing p s with
  | zero =>
    cases p with
    | terminar r => rfl
    | consultar e k => simp only [traza, List.length_cons] at hc; omega
  | succ n ih =>
    cases p with
    | terminar r => rfl
    | consultar e k =>
      simp only [traza, List.length_cons] at hc
      change (_ ∧ EjecucionBytes.SinBad H (EjecucionBytes.avanzar H s e)
        (recortar n (k (H e)))) ↔ (_ ∧ EjecucionBytes.SinBad H
          (EjecucionBytes.avanzar H s e) (k (H e)))
      exact and_congr Iff.rfl (ih (k (H e)) (EjecucionBytes.avanzar H s e) (by omega))

end Nexus.ROM.RecortePrograma
