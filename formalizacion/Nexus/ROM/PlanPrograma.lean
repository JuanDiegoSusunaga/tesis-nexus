module

public import Nexus.ROM.EjecucionBytes
import Mathlib.Tactic

/-!
# Muestreo con memoria derivado de un programa de bytes

Se compila el árbol de consultas en el experimento de respuestas frescas.
Las repeticiones usan la tabla y conservan el presupuesto. El límite de
altura es explícito y no se identifica automáticamente con Q+V_T de Rust.
-/

public section
namespace Nexus.ROM.PlanPrograma

set_option maxRecDepth 4096
set_option pp.deepTerms false
set_option pp.deepTerms.threshold 8

open Nexus.Bytes Nexus.Merkle Nexus.N06 ProgramaBytes

theorem rama_menor {R : Type} (e : Entrada) (f : Digest → Programa R) (d : Digest) :
    altura (f d) < altura (.consultar e f) := by
  have h := Finset.le_sup (f := fun d : Digest => altura (f d)) (Finset.mem_univ d)
  change altura (f d) < 1 + Finset.univ.sup (fun d : Digest => altura (f d))
  omega

@[expose] noncomputable def planificar {R : Type} (B : ℕ) :
    (p : Programa R) → (s : Estado B) → (n : ℕ) → altura p ≤ n → Plan B s n
  | .terminar _, s, n, _ => .terminar s n
  | .consultar e f, _, 0, h => False.elim (by
      have hm := rama_menor e f (Classical.choice (inferInstance : Nonempty Digest))
      omega)
  | .consultar e f, s, n + 1, h =>
      if hh : buscar s.tabla e = none then .nuevo (EjecucionBytes.solicitar s e) hh
          (fun d => planificar B (f d) (estadoNuevo s (EjecucionBytes.solicitar s e) d hh) n
            (by have hm := rama_menor e f d; omega))
      else
        let d := (buscar s.tabla e).getD (Classical.choice (inferInstance : Nonempty Digest))
        have hd : buscar s.tabla e = some d := by
          cases hl : buscar s.tabla e with
          | none => exact False.elim (hh hl)
          | some v => simp only [d, hl, Option.getD_some]
        .repetir (EjecucionBytes.solicitar s e) d hd
          (planificar B (f d) (estadoRepetido s (EjecucionBytes.solicitar s e)) (n + 1)
            (by have hm := rama_menor e f d; omega))

@[expose] noncomputable def experimento {R : Type} (B S : ℕ) (p : Programa R) (h : altura p ≤ S) :
    Plan B (inicial B) S := planificar B p (inicial B) S h

theorem probabilidad_excepcion {R : Type} (B S : ℕ) (p : Programa R) (h : altura p ≤ S) :
    riesgo (experimento B S p h) =
      ((Finset.univ.filter (fun xs => acierta (experimento B S p h) xs = true)).card : ℚ) /
        (2 ^ 256 : ℚ) ^ S := probabilidad_acierto _

theorem cota_excepcion {R : Type} (B S : ℕ) (p : Programa R) (h : altura p ≤ S) :
    riesgo (experimento B S p h) ≤ min 1 (((S * (49 * S + B) : ℕ) : ℚ) / 2 ^ 256) :=
  cota_desde_vacio S B _

theorem recorrido_efectivo {R : Type} (B S : ℕ) (p : Programa R) (h : altura p ≤ S)
    (xs : Retos Digest S) (hs : acierta (experimento B S p h) xs = false) :
    RecorridoSinAcierto B (inicial B) (ejecutar (experimento B S p h) xs) :=
  ejecucion_sin_acierto _ xs hs

theorem realizacion {R : Type} (B : ℕ) (p : Programa R) (s : Estado B) (n : ℕ) (h : altura p ≤ n)
    (xs : Retos Digest n) (H : Entrada → Digest)
    (hc : Compatibles H (ejecutar (planificar B p s n h) xs).tabla)
    (hs : acierta (planificar B p s n h) xs = false) :
    EjecucionBytes.final H s p = ejecutar (planificar B p s n h) xs ∧ EjecucionBytes.SinBad H s p := by
  induction p generalizing s n with
  | terminar r => exact ⟨rfl, trivial⟩
  | consultar e f ih =>
    cases n with
    | zero => have hm := rama_menor e f (Classical.choice (inferInstance : Nonempty Digest)); omega
    | succ n =>
      cases hh : buscar s.tabla e with
      | none =>
        rw [planificar] at hs
        simp only [EjecucionBytes.solicitar, hh, dite_true, acierta, Bool.or_eq_false_iff, decide_eq_false_iff_not] at hs
        rw [planificar] at hc ⊢
        simp only [EjecucionBytes.solicitar, hh, dite_true, ejecutar] at hc ⊢
        have r := ejecucion_sin_acierto _ xs.2 hs.2
        have hantes := recorrido_compatible_antes H r hc
        have hed : H e = xs.1 := hantes e xs.1
          (buscar_some_mem _ _ _ (buscar_anexado s.tabla e xs.1 hh))
        have hi := ih xs.1 _ _ _ xs.2 hc hs.2
        constructor
        · simpa only [EjecucionBytes.final, EjecucionBytes.avanzar, dite_eq_left hh, hed,
            EjecucionBytes.solicitar] using hi.1
        · rw [EjecucionBytes.SinBad]
          refine ⟨fun _ => by simpa only [hed, EjecucionBytes.solicitar] using hs.1, ?_⟩
          simpa only [EjecucionBytes.avanzar, dite_eq_left hh, hed, EjecucionBytes.solicitar] using hi.2
      | some d =>
        rw [planificar] at hs
        simp only [EjecucionBytes.solicitar, hh, reduceCtorEq, dite_false, Option.getD_some, acierta] at hs
        rw [planificar] at hc ⊢
        simp only [EjecucionBytes.solicitar, hh, reduceCtorEq, dite_false, Option.getD_some, ejecutar] at hc ⊢
        have r := ejecucion_sin_acierto _ xs hs
        have hantes := recorrido_compatible_antes H r hc
        have hed : H e = d := hantes e d (buscar_some_mem _ _ _ hh)
        have hi := ih d _ _ _ xs hc hs
        have hn : ¬ buscar s.tabla e = none := by rw [hh]; simp
        constructor
        · simpa only [EjecucionBytes.final, EjecucionBytes.avanzar, dite_eq_right hn, hed,
            EjecucionBytes.solicitar] using hi.1
        · rw [EjecucionBytes.SinBad]
          refine ⟨fun hn' => False.elim (hn hn'), ?_⟩
          simpa only [EjecucionBytes.avanzar, dite_eq_right hn, hed, EjecucionBytes.solicitar] using hi.2

theorem memoria_realiza {R : Type} (B S : ℕ) (p : Programa R) (h : altura p ≤ S)
    (xs : Retos Digest S) (hs : acierta (experimento B S p h) xs = false) (defecto : Digest) :
    let fin := ejecutar (experimento B S p h) xs
    let H := funcionTabla defecto fin.tabla
    EjecucionBytes.final H (inicial B) p = fin ∧ EjecucionBytes.SinBad H (inicial B) p := by
  dsimp only
  exact realizacion B p (inicial B) S h xs _
    (funcion_tabla_compatible defecto _ (ejecutar (experimento B S p h) xs).sinRepetidos) hs

end Nexus.ROM.PlanPrograma
