module

public import Nexus.ROM.ProgramaObservado
public import Nexus.ROM.PrefijosGlobales
public import Nexus.ROM.ContinuacionPrefijo
public import Nexus.Verificador.ExperimentoCausal
import Mathlib.Tactic

/-!
# Ley conjunta del verificador con adversario

Se instancia el universo derivado con la propuesta adaptativa de bytes y las
intercalaciones reales. La igualdad de leyes incluye toda la transcripción,
también si hay excepciones. Las respuestas frescas tras un pasado fijo son
uniformes; esto no afirma uniformidad al condicionar a SinBad o a aceptación.
El acoplamiento del selector ideal y la solidez global siguen pendientes.
-/

public section
namespace Nexus.Verificador.LeyConjunta

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM
open ProgramaBytes SoporteFinito ExperimentoCausal

set_option maxRecDepth 4096
set_option pp.deepTerms false
set_option pp.deepTerms.threshold 12

@[expose] noncomputable def universo {A : Type} (u : Politica A) (bits R : ℕ) : Finset Entrada :=
  soporte (programa u bits R)

@[expose] noncomputable def arbolProtocolo {A : Type} (u : Politica A) (bits R : ℕ) :
    LeyArbol.Arbol (universo u bits R) Digest Bool :=
  restringir (universo u bits R) (programa u bits R) (Finset.Subset.refl _)

@[expose] noncomputable def oraculo {A : Type} (u : Politica A) (bits R : ℕ)
    (defecto : Digest) (H : universo u bits R → Digest) : Entrada → Digest :=
  prolongar (universo u bits R) defecto H

theorem restriccion_oraculo {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) : (fun q : universo u bits R => oraculo u bits R defecto H q.val) = H := by
  funext q
  exact prolongar_en_universo _ defecto H q.val q.property

theorem traza_arbol {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) :
    (LeyArbol.traza H (arbolProtocolo u bits R)).map (fun ed => (ed.1.val, ed.2)) =
      traza (oraculo u bits R defecto H) (programa u bits R) := by
  have h := traza_restringir (universo u bits R) (oraculo u bits R defecto H)
    (programa u bits R) (Finset.Subset.refl _)
  simpa only [restriccion_oraculo, arbolProtocolo] using h

theorem prefijo_arbol {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) (n : ℕ) :
    ((LeyArbol.traza H (arbolProtocolo u bits R)).take n).map (fun ed => (ed.1.val, ed.2)) =
      (traza (oraculo u bits R defecto H) (programa u bits R)).take n := by
  rw [List.map_take, traza_arbol]

theorem proyeccion_inyectiva (V : Finset Entrada) :
    Function.Injective (fun ed : V × Digest => (ed.1.val, ed.2)) := by
  intro x y h
  exact Prod.ext (Subtype.ext (congrArg (fun ed : Entrada × Digest => ed.1) h))
    (congrArg (fun ed : Entrada × Digest => ed.2) h)

theorem prefijos_iguales {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H G : universo u bits R → Digest) (n : ℕ) :
    (traza (oraculo u bits R defecto G) (programa u bits R)).take n =
      (traza (oraculo u bits R defecto H) (programa u bits R)).take n ↔
      (LeyArbol.traza G (arbolProtocolo u bits R)).take n =
        (LeyArbol.traza H (arbolProtocolo u bits R)).take n := by
  rw [← prefijo_arbol u bits R defecto G n, ← prefijo_arbol u bits R defecto H n]
  exact List.map_inj_right (proyeccion_inyectiva _)

theorem ley_resultado {A : Type} (B S bits R : ℕ) (u : Politica A)
    (h : altura (programa u bits R) ≤ S) (defecto : Digest) (f : Bool → ℚ) :
    promedio (fun xs : Retos Digest S =>
      f (resultado (tablaMuestreada B S bits R u h defecto xs) (programa u bits R))) =
      promedio (fun H : universo u bits R → Digest =>
        f (resultado (oraculo u bits R defecto H) (programa u bits R))) :=
  LeyMuestreoPrograma.ley_programa B S (programa u bits R) h (universo u bits R)
    (Finset.Subset.refl _) defecto f

theorem ley_historia {A : Type} (B S bits R : ℕ) (u : Politica A)
    (h : altura (programa u bits R) ≤ S) (defecto : Digest)
    (f : Bool × List (Entrada × Digest) → ℚ) :
    promedio (fun xs : Retos Digest S =>
      let H := tablaMuestreada B S bits R u h defecto xs
      f (resultado H (programa u bits R), traza H (programa u bits R))) =
      promedio (fun H : universo u bits R → Digest =>
        let G := oraculo u bits R defecto H
        f (resultado G (programa u bits R), traza G (programa u bits R))) :=
  ProgramaObservado.ley_transcripcion B S (programa u bits R) h (universo u bits R)
    (Finset.Subset.refl _) defecto f

abbrev Tablas {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) (n : ℕ) :=
  {G : universo u bits R → Digest //
    (traza (oraculo u bits R defecto G) (programa u bits R)).take n =
      (traza (oraculo u bits R defecto H) (programa u bits R)).take n}

abbrev Respuesta {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) (n : ℕ) (q : universo u bits R) (d : Digest) :=
  {G : Tablas u bits R defecto H n // oraculo u bits R defecto G.val q.val = d}

noncomputable instance {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) (n : ℕ) : Fintype (Tablas u bits R defecto H n) := Fintype.ofFinite _
noncomputable instance {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) (n : ℕ) (q : universo u bits R) (d : Digest) :
    Fintype (Respuesta u bits R defecto H n q d) := Fintype.ofFinite _

@[expose] noncomputable def equivalencia_prefijo {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) (n : ℕ) :
    Tablas u bits R defecto H n ≃ PrefijosGlobales.Tablas H (arbolProtocolo u bits R) n where
  toFun G := ⟨G.val, (prefijos_iguales u bits R defecto H G.val n).mp G.property⟩
  invFun G := ⟨G.val, (prefijos_iguales u bits R defecto H G.val n).mpr G.property⟩
  left_inv _ := rfl
  right_inv _ := rfl

@[expose] noncomputable def equivalencia_respuesta {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) (n : ℕ) (q : universo u bits R) (d : Digest) :
    Respuesta u bits R defecto H n q d ≃ PrefijosGlobales.Respuesta H (arbolProtocolo u bits R) n q d where
  toFun G := ⟨equivalencia_prefijo u bits R defecto H n G.val, by
    change G.val.val q = d
    simpa only [oraculo, prolongar_en_universo _ defecto G.val.val q.val q.property] using G.property⟩
  invFun G := ⟨(equivalencia_prefijo u bits R defecto H n).symm G.val, by
    change prolongar (universo u bits R) defecto G.val.val q.val = d
    rw [prolongar_en_universo _ defecto G.val.val q.val q.property]
    exact G.property⟩
  left_inv _ := rfl
  right_inv _ := rfl

theorem probabilidad_prefijo {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) (n : ℕ) :
    (Fintype.card (Tablas u bits R defecto H n) : ℚ) / Fintype.card (universo u bits R → Digest) =
      1 / (2 ^ 256 : ℚ) ^ (PrefijosGlobales.vistas H (arbolProtocolo u bits R) n).card := by
  rw [Fintype.card_congr (equivalencia_prefijo u bits R defecto H n)]
  simpa only [ProyeccionDigest.cardinal_digest, Nat.cast_pow, Nat.cast_ofNat] using
    PrefijosGlobales.probabilidad_prefijo H (arbolProtocolo u bits R) n

theorem respuesta_fresca {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) (n : ℕ) (q : universo u bits R) (d : Digest)
    (hq : q ∉ PrefijosGlobales.vistas H (arbolProtocolo u bits R) n) :
    (Fintype.card (Respuesta u bits R defecto H n q d) : ℚ) /
        Fintype.card (Tablas u bits R defecto H n) = 1 / (2 ^ 256 : ℚ) := by
  rw [Fintype.card_congr (equivalencia_respuesta u bits R defecto H n q d),
    Fintype.card_congr (equivalencia_prefijo u bits R defecto H n)]
  simpa only [ProyeccionDigest.cardinal_digest, Nat.cast_pow, Nat.cast_ofNat] using
    PrefijosGlobales.siguiente_uniforme H (arbolProtocolo u bits R) n q d hq

theorem ley_causal_adicional {A : Type} (u : Politica A) (bits R : ℕ)
    (H : universo u bits R → Digest) (n : ℕ)
    (f : Bool × List ((universo u bits R) × Digest) → ℚ) :
    promedio (fun G : PrefijosGlobales.Tablas H (arbolProtocolo u bits R) n =>
      f (LeyArbol.evaluar G.val
          (Nexus.ROM.ContinuacionPrefijo.despues G.val (arbolProtocolo u bits R) n),
        LeyArbol.traza G.val
          (Nexus.ROM.ContinuacionPrefijo.despues G.val (arbolProtocolo u bits R) n))) =
      LeyArbol.valor f
        (LeyArbol.registrar
          (Nexus.ROM.ContinuacionPrefijo.despues H (arbolProtocolo u bits R) n))
        (PrefijosGlobales.vistas H (arbolProtocolo u bits R) n) H := by
  exact Nexus.ROM.ContinuacionPrefijo.ley_continuacion
    H (arbolProtocolo u bits R) n f

end Nexus.Verificador.LeyConjunta
