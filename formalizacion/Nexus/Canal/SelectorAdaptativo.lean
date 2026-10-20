module

public import Nexus.ROM.SelectorAdaptativo
public import Nexus.Canal.SelectorAcoplado
import Mathlib.Tactic

/-!
# Selector de bytes después de un programa adversario finito

La exploración anterior admite entradas arbitrarias y decisiones adaptativas.
La elección posterior de semilla y conjuntos usa su prefijo efectivo. La
probabilidad de haber consultado ya la primera dirección se conserva como
término explícito: aquí no se demuestra una cota pequeña para ese evento.
-/

public section
namespace Nexus.Canal.SelectorAdaptativo

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM LeyArbol PrefijosGlobales ObservacionesPrefijo

set_option maxRecDepth 4096
set_option maxHeartbeats 800000
attribute [local instance] Classical.propDecidable

variable {X : Type}

@[expose] noncomputable def universo (p : ProgramaBytes.Programa X) : Finset Entrada :=
  SelectorAcoplado.universo (SoporteFinito.soporte p)

@[expose] noncomputable def arbol (p : ProgramaBytes.Programa X) : Arbol (universo p) Digest X :=
  SoporteFinito.restringir (universo p) p (SelectorAcoplado.pasado_en_universo _)

@[expose] noncomputable def oraculo (p : ProgramaBytes.Programa X) (defecto : Digest)
    (H : universo p → Digest) : Entrada → Digest := SoporteFinito.prolongar (universo p) defecto H

@[expose] noncomputable def codigo (p : ProgramaBytes.Programa X) : Digest → universo p :=
  SelectorAcoplado.codificar (universo p) (SelectorAcoplado.indices_en_universo _)

@[expose] def proyectar {V : Finset Entrada} (t : SelectorPrefijo.Historia V) : List (Entrada × Digest) :=
  t.map (fun ed => (ed.1.val, ed.2))

@[expose] noncomputable def historia (p : ProgramaBytes.Programa X) (defecto : Digest) (n : ℕ)
    (H : universo p → Digest) : List (Entrada × Digest) := (ProgramaBytes.traza (oraculo p defecto H) p).take n

theorem restriccion_oraculo (p : ProgramaBytes.Programa X) (defecto : Digest) (H : universo p → Digest) :
    (fun e : universo p => oraculo p defecto H e.val) = H := by
  funext e
  exact SoporteFinito.prolongar_en_universo _ defecto H e.val e.property

theorem prefijo_bytes (p : ProgramaBytes.Programa X) (defecto : Digest) (n : ℕ) (H : universo p → Digest) :
    proyectar (prefijo (arbol p) n H) = historia p defecto n H := by
  have h := SoporteFinito.traza_restringir (universo p) (oraculo p defecto H) p
    (SelectorAcoplado.pasado_en_universo (SoporteFinito.soporte p))
  simp only [restriccion_oraculo] at h
  simpa only [proyectar, prefijo, List.map_take, historia, arbol] using congrArg (List.take n) h

theorem consulta_proyectada {V : Finset Entrada} (t : SelectorPrefijo.Historia V) (e : V) :
    e ∈ (t.map Prod.fst).toFinset ↔ e.val ∈ ((proyectar t).map Prod.fst).toFinset := by
  simp only [List.mem_toFinset, List.mem_map, proyectar, List.map_map, Function.comp_def]
  constructor
  · rintro ⟨⟨q, d⟩, hq, he⟩
    exact ⟨(q, d), hq, congrArg (fun x : V => x.val) he⟩
  · rintro ⟨⟨q, d⟩, hq, he⟩
    exact ⟨(q, d), hq, Subtype.ext he⟩

theorem cardinal_vistas (p : ProgramaBytes.Programa X) (defecto : Digest) (n : ℕ) (H : universo p → Digest) :
    (vistas H (arbol p) n).card = ((historia p defecto n H).map Prod.fst).toFinset.card := by
  rw [← prefijo_bytes p defecto n H]
  simp only [vistas]
  have hmap : (proyectar (prefijo (arbol p) n H)).map Prod.fst =
      ((prefijo (arbol p) n H).map Prod.fst).map Subtype.val := by
    simp only [proyectar, List.map_map, Function.comp_def]
  have hset : (((prefijo (arbol p) n H).map Prod.fst).map Subtype.val).toFinset =
      ((prefijo (arbol p) n H).map Prod.fst).toFinset.image Subtype.val := by
    ext e
    simp only [List.mem_toFinset, List.mem_map, Finset.mem_image]
  rw [hmap, hset, Finset.card_image_of_injective _ Subtype.val_injective]

@[expose] noncomputable def Preconsultada (p : ProgramaBytes.Programa X) (defecto : Digest) (n : ℕ)
    (semilla : List (Entrada × Digest) → Digest) (H : universo p → Digest) : Prop :=
  entradaReto (semilla (historia p defecto n H)) .indice ∈ ((historia p defecto n H).map Prod.fst).toFinset

theorem preconsulta_iff (p : ProgramaBytes.Programa X) (defecto : Digest) (n : ℕ)
    (semilla : List (Entrada × Digest) → Digest) (H : universo p → Digest) :
    SelectorPrefijo.Preconsultada (codigo p) (fun t => semilla (proyectar t)) (prefijo (arbol p) n H) ↔
      Preconsultada p defecto n semilla H := by
  have h := consulta_proyectada (prefijo (arbol p) n H)
    (codigo p (semilla (proyectar (prefijo (arbol p) n H))))
  simpa only [SelectorPrefijo.Preconsultada, codigo, SelectorAcoplado.codificar, prefijo_bytes p defecto,
    Preconsultada] using h

theorem muestra_igual (p : ProgramaBytes.Programa X) (defecto : Digest) (n R e q : ℕ)
    (semilla : List (Entrada × Digest) → Digest) (H : universo p → Digest) :
    SelectorPrefijo.muestra (codigo p) (arbol p) n R e q (fun t => semilla (proyectar t)) H =
      ROM.SelectorAcoplado.salida e q (CintaSelector.cinta (oraculo p defecto H) R (semilla (historia p defecto n H))) := by
  unfold SelectorPrefijo.muestra
  dsimp only
  rw [prefijo_bytes p defecto]
  unfold codigo
  rw [SelectorAcoplado.cinta_igual (universo p) (SelectorAcoplado.indices_en_universo _) defecto]
  rfl

@[expose] noncomputable def acepta (p : ProgramaBytes.Programa X) (defecto : Digest) (n R e : ℕ)
    (semilla : List (Entrada × Digest) → Digest) (GT GC : List (Entrada × Digest) → Finset (Fin (2 ^ e)))
    (H : universo p → Digest) : Bool :=
  ProgramaCompartido.resultado (RegistroPrograma.tabla (oraculo p defecto H))
    (ProgramaTG2.seleccionar (2 ^ e) (by positivity) R (semilla (historia p defecto n H)) ∅
      (fun T => .terminar (decide (T ⊆ GT (historia p defecto n H) ∧ T ⊆ GC (historia p defecto n H)))))

theorem acepta_implica (p : ProgramaBytes.Programa X) (defecto : Digest) (n R e : ℕ)
    (semilla : List (Entrada × Digest) → Digest) (GT GC : List (Entrada × Digest) → Finset (Fin (2 ^ e)))
    (H : universo p → Digest) (ha : acepta p defecto n R e semilla GT GC H = true) :
    SelectorPrefijo.OmiteOAbandona (codigo p) (arbol p) n R e 40 (fun t => semilla (proyectar t))
      (fun t => GT (proyectar t)) (fun t => GC (proyectar t)) H := by
  have h := (SelectorAcoplado.programa_omision (oraculo p defecto H) e R (semilla (historia p defecto n H))
    (GT (historia p defecto n H)) (GC (historia p defecto n H))).mp ha
  apply Or.inr
  simp only [SelectorPrefijo.Omite, muestra_igual p defecto, prefijo_bytes p defecto]
  exact ⟨h.1, Finset.subset_inter h.2.1 h.2.2⟩

theorem cota_programa_512 (p : ProgramaBytes.Programa X) (defecto : Digest) (n k g m : ℕ)
    (semilla : List (Entrada × Digest) → Digest)
    (GT GC : List (Entrada × Digest) → Finset (Fin (2 ^ (k + 2)))) (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hg : ∀ H, (GT (historia p defecto n H) ∩ GC (historia p defecto n H)).card ≤ g)
    (hm : ∀ H, ((historia p defecto n H).map Prod.fst).toFinset.card ≤ m) :
    promedio (fun H : universo p → Digest => if acepta p defecto n 512 (k + 2) semilla GT GC H = true then (1 : ℚ) else 0) <
      (Nat.choose g 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 + (1 : ℚ) / 2 ^ 300 +
        AcoplamientoCadena.error Digest 512 m +
        promedio (fun H : universo p → Digest => if Preconsultada p defecto n semilla H then 1 else 0) := by
  have hg' (H : universo p → Digest) := hg H
  have hm' (H : universo p → Digest) : (vistas H (arbol p) n).card ≤ m := by
    simpa only [cardinal_vistas p defecto n H] using hm H
  have h := ROM.SelectorAdaptativo.cota_512 (codigo p)
    (SelectorAcoplado.codificar_inyectiva _ _) (arbol p) n k g m
    (fun t => semilla (proyectar t)) (fun t => GT (proyectar t)) (fun t => GC (proyectar t))
    hk0 hk1 (fun H => by simpa only [prefijo_bytes p defecto] using hg' H) hm'
  have hu : promedio (fun H : universo p → Digest => if acepta p defecto n 512 (k + 2) semilla GT GC H = true then (1 : ℚ) else 0) ≤
      promedio (fun H : universo p → Digest => if SelectorPrefijo.OmiteOAbandona (codigo p) (arbol p) n 512 (k + 2) 40
        (fun t => semilla (proyectar t)) (fun t => GT (proyectar t)) (fun t => GC (proyectar t)) H then 1 else 0) := by
    apply promedio_monotono
    intro H
    by_cases ha : acepta p defecto n 512 (k + 2) semilla GT GC H = true
    · simp only [ha, ite_true, acepta_implica p defecto n 512 (k + 2) semilla GT GC H ha, ite_true, le_refl]
    · rw [ite_eq_right ha]
      split_ifs <;> norm_num
  have h' := lt_of_le_of_lt hu h
  simpa only [preconsulta_iff p defecto n semilla] using h'

end Nexus.Canal.SelectorAdaptativo
