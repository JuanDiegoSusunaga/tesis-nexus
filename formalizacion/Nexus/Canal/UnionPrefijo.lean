module

public import Nexus.Canal.PrimerasExposiciones
public import Nexus.Verificador.PoliticasPrefijo
import Mathlib.Tactic

/-!
# Unión de primeras exposiciones con las políticas reconstruidas

La activación y la omisión de bytes coinciden con los eventos del selector
finito. La cota exige cotas explícitas de cardinal y presupuestos para todas
las activaciones; no demuestra que esas cotas sean pequeñas en el protocolo.
-/

public section
namespace Nexus.Canal.UnionPrefijo

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM Nexus.Verificador
open ProgramaBytes PoliticasPrefijo SelectorAdaptativo

variable {A : Type}
attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem inicio_iff (p : Programa A) (defecto : Digest) (n : ℕ) (H : universo p → Digest) :
    Inicia (oraculo p defecto H) p defecto n ↔
      PrimerasExposiciones.IniciaBytes p defecto n (SemillaProxima.semilla p defecto) H := Iff.rfl

theorem omision_iff (p : Programa A) (defecto : Digest) (n R e : ℕ) (H : universo p → Digest) :
    Omite (oraculo p defecto H) p defecto n R e ↔
      acepta p defecto n R e (SemillaProxima.semilla p defecto) (GT p defecto e) (GC p defecto e) H = true := by
  unfold Omite acepta
  dsimp only
  rw [Nexus.Canal.SelectorAcoplado.programa_omision]
  simp only [historia, Finset.subset_inter_iff]

theorem cota_union (p : Programa A) (defecto : Digest) (N R e g m B : ℕ)
    (he : e ≤ 64) (hqM : 40 ≤ 2 ^ e) (hqR : 40 ≤ R)
    (hg : ∀ (n : Fin N) H, Inicia (oraculo p defecto H) p defecto n.val →
      (GT p defecto e (historia p defecto n.val H) ∩ GC p defecto e (historia p defecto n.val H)).card ≤ g)
    (hm : ∀ (n : Fin N) H, Inicia (oraculo p defecto H) p defecto n.val →
      ((historia p defecto n.val H).map Prod.fst).toFinset.card ≤ m)
    (hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B) :
    promedio (fun H : universo p → Digest => if ∃ n : Fin N,
      Inicia (oraculo p defecto H) p defecto n.val ∧
      Omite (oraculo p defecto H) p defecto n.val R e then (1 : ℚ) else 0) ≤
      ROM.SelectorPrimeras.riesgo R e 40 g m * B := by
  have hu := PrimerasExposiciones.cota_programas p defecto N R e g m B
    (fun _ => SemillaProxima.semilla p defecto) (fun _ => GT p defecto e) (fun _ => GC p defecto e)
    he hqM hqR (fun n H ha => hg n H ((inicio_iff p defecto n.val H).mpr ha))
    (fun n H ha => hm n H ((inicio_iff p defecto n.val H).mpr ha)) hB
  simpa only [← inicio_iff, ← omision_iff] using hu

end Nexus.Canal.UnionPrefijo
