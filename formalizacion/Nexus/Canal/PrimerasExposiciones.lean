module

public import Nexus.ROM.SelectorPrimeras
public import Nexus.Canal.SelectorAdaptativo
import Mathlib.Tactic

/-!
# Primeras exposiciones del selector con consultas de bytes

Se identifica la activación causal con la próxima consulta I de la traza
real y su ausencia del prefijo. La unión se cobra por direcciones distintas,
incluidas las consultas deliberadas del adversario antes del verificador.
-/

public section
namespace Nexus.Canal.PrimerasExposiciones

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM LeyArbol ObservacionesPrefijo
open PrimeraExposicion CargaPrimeras ConteoActivaciones SelectorAdaptativo

set_option maxRecDepth 4096
set_option maxHeartbeats 800000
attribute [local instance] Classical.propDecidable

variable {X : Type}

theorem traza_bytes (p : ProgramaBytes.Programa X) (defecto : Digest) (H : universo p → Digest) :
    proyectar (LeyArbol.traza H (arbol p)) = ProgramaBytes.traza (oraculo p defecto H) p := by
  have h := SoporteFinito.traza_restringir (universo p) (oraculo p defecto H) p
    (SelectorAcoplado.pasado_en_universo (SoporteFinito.soporte p))
  simp only [restriccion_oraculo] at h
  exact h

theorem consulta_siguiente (p : ProgramaBytes.Programa X) (defecto : Digest) (n : ℕ)
    (H : universo p → Digest) :
    ((ProgramaBytes.traza (oraculo p defecto H) p).map Prod.fst)[n]? =
      (((LeyArbol.traza H (arbol p)).map Prod.fst)[n]?).map Subtype.val := by
  rw [← traza_bytes p defecto H]
  simp only [proyectar, List.map_map, List.getElem?_map, Option.map_map, Function.comp_def]

abbrev IniciaBytes (p : ProgramaBytes.Programa X) (defecto : Digest) (n : ℕ)
    (semilla : List (Entrada × Digest) → Digest) (H : universo p → Digest) : Prop :=
  ((ProgramaBytes.traza (oraculo p defecto H) p).map Prod.fst)[n]? =
      some (entradaReto (semilla (historia p defecto n H)) .indice) ∧
    entradaReto (semilla (historia p defecto n H)) .indice ∉ ((historia p defecto n H).map Prod.fst).toFinset

theorem inicio_iff (p : ProgramaBytes.Programa X) (defecto : Digest) (n : ℕ)
    (semilla : List (Entrada × Digest) → Digest) (H : universo p → Digest) :
    Activa (arbol p) (fun t => codigo p (semilla (proyectar t))) (prefijo (arbol p) n H) ↔
      IniciaBytes p defecto n semilla H := by
  rw [activa_iff]
  have hf := consulta_proyectada (prefijo (arbol p) n H)
    (codigo p (semilla (proyectar (prefijo (arbol p) n H))))
  simp only [List.mem_toFinset] at hf
  have he : (((LeyArbol.traza H (arbol p)).map Prod.fst)[n]? =
      some (codigo p (semilla (proyectar (prefijo (arbol p) n H))))) ↔
      (((LeyArbol.traza H (arbol p)).map Prod.fst)[n]?).map Subtype.val =
        some (entradaReto (semilla (historia p defecto n H)) .indice) := by
    rw [← prefijo_bytes p defecto n H]
    exact (Option.map_inj_right Subtype.val_injective).symm
  simp only [List.map_take] at hf
  have h := and_congr he (not_congr hf)
  simpa only [IniciaBytes, consulta_siguiente, prefijo_bytes p defecto, List.mem_toFinset,
    codigo, SelectorAcoplado.codificar] using h

theorem ampliada_iff (p : ProgramaBytes.Programa X) (defecto : Digest) (n R e q : ℕ)
    (semilla : List (Entrada × Digest) → Digest)
    (GT GC : List (Entrada × Digest) → Finset (Fin (2 ^ e))) (H : universo p → Digest) :
    SelectorPrefijo.OmiteOAbandona (codigo p) (arbol p) n R e q (fun t => semilla (proyectar t))
      (fun t => GT (proyectar t)) (fun t => GC (proyectar t)) H ↔
    let T := ROM.SelectorAcoplado.salida e q (CintaSelector.cinta (oraculo p defecto H) R
      (semilla (historia p defecto n H)))
    T.card < q ∨ (T.card = q ∧ T ⊆ GT (historia p defecto n H) ∩ GC (historia p defecto n H)) := by
  simp only [SelectorPrefijo.OmiteOAbandona, SelectorPrefijo.Omite, muestra_igual p defecto,
    prefijo_bytes p defecto]

theorem carga_bytes (p : ProgramaBytes.Programa X) (defecto : Digest) (N : ℕ)
    (semilla : ℕ → List (Entrada × Digest) → Digest) (H : universo p → Digest) :
    numero (fun n : Fin N => IniciaBytes p defecto n.val (semilla n.val)) H ≤
      ((ProgramaBytes.traza (oraculo p defecto H) p).map Prod.fst).toFinset.card := by
  have h := carga_distintas H (arbol p) N (fun j t => codigo p (semilla j (proyectar t)))
  have he : numero (fun n : Fin N => Inicia (arbol p) (fun j t => codigo p (semilla j (proyectar t))) n.val) H =
      numero (fun n : Fin N => IniciaBytes p defecto n.val (semilla n.val)) H := by
    unfold numero Inicia
    simp only [inicio_iff p defecto]
  rw [he] at h
  have hc : ((LeyArbol.traza H (arbol p)).map Prod.fst).toFinset.card =
      ((ProgramaBytes.traza (oraculo p defecto H) p).map Prod.fst).toFinset.card := by
    have ht := cardinal_vistas p defecto (LeyArbol.traza H (arbol p)).length H
    have hl : (ProgramaBytes.traza (oraculo p defecto H) p).length = (LeyArbol.traza H (arbol p)).length := by
      rw [← traza_bytes p defecto H]
      simp only [proyectar, List.length_map]
    simp only [PrefijosGlobales.vistas, List.take_length, historia] at ht
    rw [← hl, List.take_length] at ht
    exact ht
  simpa only [hc] using h

theorem cota_programas (p : ProgramaBytes.Programa X) (defecto : Digest) (N R e g m B : ℕ)
    (semilla : ℕ → List (Entrada × Digest) → Digest)
    (GT GC : ℕ → List (Entrada × Digest) → Finset (Fin (2 ^ e)))
    (he : e ≤ 64) (hqM : 40 ≤ 2 ^ e) (hqR : 40 ≤ R)
    (hg : ∀ (n : Fin N) H, IniciaBytes p defecto n.val (semilla n.val) H →
      (GT n.val (historia p defecto n.val H) ∩ GC n.val (historia p defecto n.val H)).card ≤ g)
    (hm : ∀ (n : Fin N) H, IniciaBytes p defecto n.val (semilla n.val) H →
      ((historia p defecto n.val H).map Prod.fst).toFinset.card ≤ m)
    (hB : ∀ H : universo p → Digest,
      ((ProgramaBytes.traza (oraculo p defecto H) p).map Prod.fst).toFinset.card ≤ B) :
    promedio (fun H : universo p → Digest => if ∃ n : Fin N,
      IniciaBytes p defecto n.val (semilla n.val) H ∧
      acepta p defecto n.val R e (semilla n.val) (GT n.val) (GC n.val) H = true then (1 : ℚ) else 0) ≤
      ROM.SelectorPrimeras.riesgo R e 40 g m * B := by
  let dir : ℕ → SelectorPrefijo.Historia (universo p) → universo p :=
    fun j t => codigo p (semilla j (proyectar t))
  let ev := fun (j : Fin N) H => SelectorPrefijo.OmiteOAbandona (codigo p) (arbol p) j.val R e 40
    (fun t => semilla j.val (proyectar t)) (fun t => GT j.val (proyectar t)) (fun t => GC j.val (proyectar t)) H
  have hu := ROM.SelectorPrimeras.cota_presupuesto (codigo p)
    (SelectorAcoplado.codificar_inyectiva _ _) (arbol p) N R e 40 g m B
    (fun j t => semilla j (proyectar t)) (fun j t => GT j (proyectar t)) (fun j t => GC j (proyectar t))
    he hqM hqR
    (fun j H ha => by
      have ha' := (inicio_iff p defecto j.val (semilla j.val) H).mp ha
      simpa only [prefijo_bytes p defecto] using hg j H ha')
    (fun j H ha => by
      have ha' := (inicio_iff p defecto j.val (semilla j.val) H).mp ha
      simpa only [cardinal_vistas p defecto] using hm j H ha')
    (fun H => by
      have hl : ((LeyArbol.traza H (arbol p)).map Prod.fst).toFinset.card =
          ((ProgramaBytes.traza (oraculo p defecto H) p).map Prod.fst).toFinset.card := by
        have hv := cardinal_vistas p defecto (LeyArbol.traza H (arbol p)).length H
        have hh : (ProgramaBytes.traza (oraculo p defecto H) p).length = (LeyArbol.traza H (arbol p)).length := by
          rw [← traza_bytes p defecto H]
          simp only [proyectar, List.length_map]
        simp only [PrefijosGlobales.vistas, List.take_length, historia] at hv
        rw [← hh, List.take_length] at hv
        exact hv
      simpa only [hl] using hB H)
  have ht : promedio (fun H : universo p → Digest => if ∃ n : Fin N,
      IniciaBytes p defecto n.val (semilla n.val) H ∧
      acepta p defecto n.val R e (semilla n.val) (GT n.val) (GC n.val) H = true then (1 : ℚ) else 0) ≤
      promedio (fun H : universo p → Digest => if ∃ n : Fin N, Inicia (arbol p) dir n.val H ∧ ev n H then (1 : ℚ) else 0) := by
    apply transferir_evento
    intro H ha
    obtain ⟨n, hn, hav⟩ := ha
    exact ⟨n, (inicio_iff p defecto n.val (semilla n.val) H).mpr hn,
      acepta_implica p defecto n.val R e (semilla n.val) (GT n.val) (GC n.val) H hav⟩
  exact ht.trans hu

end Nexus.Canal.PrimerasExposiciones
