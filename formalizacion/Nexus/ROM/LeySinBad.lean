module

public import Nexus.ROM.LeyMuestreoPrograma
public import Nexus.ROM.RecortePrograma
import Mathlib.Tactic

/-!
# Ley del fallo de reconstrucción en el ROM del programa real

Se instrumenta el programa para detenerse en la primera respuesta nueva
que pertenece a las marcas preparadas. Las consultas repetidas conservan
su respuesta y no cuentan como nuevas. El detector tiene soporte incluido
en el del programa original. Su media coincide con el riesgo del plan
con memoria, sin condicionar la distribución a ausencia de excepciones.
-/

public section
namespace Nexus.ROM.LeySinBad

open Nexus.Bytes Nexus.Merkle Nexus.N06 ProgramaBytes SoporteFinito
open LeyMuestreoPrograma

set_option maxRecDepth 4096
set_option maxHeartbeats 800000
attribute [local instance] Classical.propDecidable

@[expose] noncomputable def detectar {R : Type} {B : ℕ} :
    Programa R → Estado B → Programa Bool
  | .terminar _, _ => .terminar false
  | .consultar e k, s => .consultar e (fun d =>
      if hn : buscar s.tabla e = none then
        if d ∈ antesRespuesta s (EjecucionBytes.solicitar s e) then .terminar true
        else detectar (k d) (estadoNuevo s (EjecucionBytes.solicitar s e) d hn)
      else detectar (k d) (estadoRepetido s (EjecucionBytes.solicitar s e)))

@[expose] def indicador (b : Bool) : ℚ := if b then 1 else 0

theorem resultado_detectar {R : Type} {B : ℕ} (H : Entrada → Digest)
    (p : Programa R) (s : Estado B) :
    resultado H (detectar p s) = if EjecucionBytes.SinBad H s p then false else true := by
  induction p generalizing s with
  | terminar r => simp [detectar, resultado, EjecucionBytes.SinBad]
  | consultar e k ih =>
    by_cases hn : buscar s.tabla e = none
    · by_cases hd : H e ∈ antesRespuesta s (EjecucionBytes.solicitar s e)
      · simp [detectar, resultado, hn, hd, EjecucionBytes.SinBad]
      · simp [detectar, resultado, hn, hd, ih,
          EjecucionBytes.SinBad, EjecucionBytes.avanzar]
    · simp [detectar, resultado, hn, ih, EjecucionBytes.SinBad, EjecucionBytes.avanzar]

theorem indicador_resultado {R : Type} {B : ℕ} (H : Entrada → Digest)
    (p : Programa R) (s : Estado B) :
    indicador (resultado H (detectar p s)) =
      if ¬ EjecucionBytes.SinBad H s p then (1 : ℚ) else 0 := by
  rw [resultado_detectar]
  by_cases hs : EjecucionBytes.SinBad H s p <;> simp [hs, indicador]

theorem soporte_detectar {R : Type} {B : ℕ} (p : Programa R) (s : Estado B) :
    soporte (detectar p s) ⊆ soporte p := by
  induction p generalizing s with
  | terminar r => simp only [detectar, soporte, Finset.Subset.refl]
  | consultar e k ih =>
    intro q hq
    simp only [detectar, soporte, Finset.mem_insert] at hq
    rcases hq with rfl | hq
    · exact Finset.mem_insert_self _ _
    · obtain ⟨d, _, hd⟩ := Finset.mem_biUnion.mp hq
      apply rama_en_soporte e k d
      split_ifs at hd with hn hb
      · simp only [soporte, Finset.notMem_empty] at hd
      · exact ih d _ hd
      · exact ih d _ hd

theorem valor_detectar {R : Type} (B : ℕ) (p : Programa R) (s : Estado B)
    (n : ℕ) (h : altura p ≤ n) (defecto : Digest) :
    LeyArbol.valor indicador (arbol (detectar p s))
        (s.tabla.map Prod.fst).toFinset (funcionTabla defecto s.tabla) =
      Nexus.ROM.riesgo (PlanPrograma.planificar B p s n h) := by
  induction p generalizing s n with
  | terminar r =>
    simp [detectar, arbol, LeyArbol.valor, indicador, PlanPrograma.planificar, Nexus.ROM.riesgo]
  | consultar e k ih =>
    cases n with
    | zero => have hm := PlanPrograma.rama_menor e k defecto; omega
    | succ n =>
      cases hh : buscar s.tabla e with
      | none =>
        have hn := (consulta_en_claves s.tabla e).mpr hh
        simp only [detectar, arbol, LeyArbol.valor, hn, ite_false,
          PlanPrograma.planificar, hh, dite_true, Nexus.ROM.riesgo]
        apply congrArg promedio
        funext d
        by_cases hd : d ∈ antesRespuesta s (EjecucionBytes.solicitar s e)
        · simp [hd, arbol, LeyArbol.valor, indicador]
        · simp only [hd, ite_false]
          have hi := ih d (estadoNuevo s (EjecucionBytes.solicitar s e) d hh) n
            (by have hm := PlanPrograma.rama_menor e k d; omega)
          simpa only [estadoNuevo, EjecucionBytes.solicitar, claves_anexar,
            funcion_anexar s.tabla e d defecto hh] using hi
      | some d =>
        have hn : ¬ buscar s.tabla e = none := by rw [hh]; simp
        have hm : e ∈ (s.tabla.map Prod.fst).toFinset := by
          by_contra hne
          exact hn ((consulta_en_claves s.tabla e).mp hne)
        have hval : funcionTabla defecto s.tabla e = d := by
          simp only [funcionTabla, hh, Option.getD_some]
        simp only [detectar, arbol, LeyArbol.valor, hm, ite_true, dite_false,
          hval, PlanPrograma.planificar, hh, reduceCtorEq, Option.getD_some, Nexus.ROM.riesgo]
        simpa only [estadoRepetido, EjecucionBytes.solicitar] using
          ih d (estadoRepetido s (EjecucionBytes.solicitar s e)) (n + 1)
            (by have hj := PlanPrograma.rama_menor e k d; omega)

theorem ley_sinBad {R : Type} (B S : ℕ) (p : Programa R) (h : altura p ≤ S)
    (V : Finset Entrada) (hV : soporte p ⊆ V) (defecto : Digest) :
    promedio (fun H : V → Digest =>
      if ¬ EjecucionBytes.SinBad (prolongar V defecto H) (inicial B) p then (1 : ℚ) else 0) =
      Nexus.ROM.riesgo (PlanPrograma.experimento B S p h) := by
  have hl := ley_global V (detectar p (inicial B))
    ((soporte_detectar p (inicial B)).trans hV) defecto indicador
  simp_rw [indicador_resultado] at hl
  rw [hl]
  have he : funcionTabla defecto ([] : Tabla Entrada Digest) = (fun _ => defecto) := by
    funext e
    rfl
  simpa only [PlanPrograma.experimento, inicial, List.map_nil, List.toFinset_nil, he] using
    valor_detectar B p (inicial B) S h defecto

theorem cota_sinBad_altura {R : Type} (B S : ℕ) (p : Programa R) (h : altura p ≤ S)
    (V : Finset Entrada) (hV : soporte p ⊆ V) (defecto : Digest) :
    promedio (fun H : V → Digest =>
      if ¬ EjecucionBytes.SinBad (prolongar V defecto H) (inicial B) p then (1 : ℚ) else 0) ≤
      min 1 (((S * (49 * S + B) : ℕ) : ℚ) / (2 : ℚ) ^ 256) := by
  rw [ley_sinBad B S p h V hV defecto]
  exact PlanPrograma.cota_excepcion B S p h

theorem cota_sinBad_llamadas {R : Type} (B S : ℕ) (p : Programa R)
    (V : Finset Entrada) (hV : soporte p ⊆ V) (defecto : Digest)
    (hc : ∀ H : V → Digest, (traza (prolongar V defecto H) p).length ≤ S) :
    promedio (fun H : V → Digest =>
      if ¬ EjecucionBytes.SinBad (prolongar V defecto H) (inicial B) p then (1 : ℚ) else 0) ≤
      min 1 (((S * (49 * S + B) : ℕ) : ℚ) / (2 : ℚ) ^ 256) := by
  have hr := cota_sinBad_altura B S (RecortePrograma.recortar S p)
    (RecortePrograma.altura_recortar S p) V
    ((RecortePrograma.soporte_recortar S p).trans hV) defecto
  have he : (fun H : V → Digest =>
      if ¬ EjecucionBytes.SinBad (prolongar V defecto H) (inicial B)
          (RecortePrograma.recortar S p) then (1 : ℚ) else 0) =
      (fun H : V → Digest =>
        if ¬ EjecucionBytes.SinBad (prolongar V defecto H) (inicial B) p
          then (1 : ℚ) else 0) := by
    funext H
    rw [RecortePrograma.sinbad_recortar_iff (prolongar V defecto H) S p (inicial B) (hc H)]
  rw [he] at hr
  exact hr

end Nexus.ROM.LeySinBad
