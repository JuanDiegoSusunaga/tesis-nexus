module

public import Nexus.Canal.UnionPrefijo
public import Nexus.Verificador.PoliticasFalsas
public import Nexus.ROM.PresupuestoPrefijo
import Mathlib.Tactic

/-!
# Unión de candidatos falsos filtrados sin una hipótesis global sobre g

El límite de cardinal se cumple por construcción de las políticas. El
pasado de una primera dirección fresca tiene a lo sumo B-1 entradas si la
ejecución completa tiene a lo sumo B. La pérdida por filtrar se conserva
como evento de exceso y no se descarta ni se condiciona la distribución.
-/

public section
namespace Nexus.Canal.UnionFiltrada

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM Nexus.Verificador
open ProgramaBytes SelectorAdaptativo

variable {A : Type}
attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem omision_iff (p : Programa A) (defecto : Digest) (n R e g : ℕ) (H : universo p → Digest) :
    PoliticasFalsas.Omite (oraculo p defecto H) p defecto n R e g ↔
      acepta p defecto n R e (SemillaProxima.semilla p defecto)
        (PoliticasFalsas.GT p defecto e g) (PoliticasFalsas.GC p defecto e g) H = true := by
  unfold PoliticasFalsas.Omite acepta
  dsimp only
  rw [Nexus.Canal.SelectorAcoplado.programa_omision]
  simp only [historia, Finset.subset_inter_iff]

theorem cota_union (p : Programa A) (defecto : Digest) (N R e g B : ℕ)
    (he : e ≤ 64) (hqM : 40 ≤ 2 ^ e) (hqR : 40 ≤ R)
    (hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B) :
    FiltroSelector.medida (fun H : universo p → Digest => ∃ n : Fin N,
      PoliticasPrefijo.Inicia (oraculo p defecto H) p defecto n.val ∧
      PoliticasFalsas.Omite (oraculo p defecto H) p defecto n.val R e g) ≤
      ROM.SelectorPrimeras.riesgo R e 40 g (B - 1) * B := by
  have hu := PrimerasExposiciones.cota_programas p defecto N R e g (B - 1) B
    (fun _ => SemillaProxima.semilla p defecto) (fun _ => PoliticasFalsas.GT p defecto e g)
    (fun _ => PoliticasFalsas.GC p defecto e g) he hqM hqR
    (fun n H _ => PoliticasFalsas.cardinal p defecto e g (historia p defecto n.val H))
    (fun n H ha => by
      have hi := (UnionPrefijo.inicio_iff p defecto n.val H).mpr ha
      simpa only [historia] using PresupuestoPrefijo.prefijo_desde_total
        (oraculo p defecto H) p defecto n.val B hi (hB H)) hB
  rw [FiltroSelector.medida_media]
  simpa only [← UnionPrefijo.inicio_iff, ← omision_iff] using hu

end Nexus.Canal.UnionFiltrada
