module

public import Nexus.Verificador.CoberturaPrimeras
public import Nexus.Canal.UnionPrefijo
import Mathlib.Tactic

/-!
# Cota de aceptación por perfil con presupuestos explícitos

Se usa un solo experimento uniforme de funciones sobre el universo finito
del programa. SinBad se mantiene como evento determinista: al eliminarlo se
añade su probabilidad de fallo, sin condicionar a él la ley de las respuestas.
Los límites g/m/B de todas las activaciones siguen siendo hipótesis.
-/

public section
namespace Nexus.Verificador.CotaAceptacion

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM Nexus.Canal
open ProgramaBytes PoliticasPrefijo SelectorAdaptativo ObservacionesPrefijo
open ConteoActivaciones

variable {A : Type}
attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def AceptaPerfil (H : Entrada → Digest) (bits R k : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) : Prop :=
  resultado H (Adversario.ejecutar bits R proponer atacar actualizar) = true ∧
    ∃ c, Lectura.exacto codecCertificado.leer (resultado H proponer).1 = some c ∧
      Nat.log2 c.enunciado.pasos = k

theorem cobertura_perfil (H : Entrada → Digest) (L bits R k : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (hs : EjecucionBytes.SinBad H (inicial L) (Adversario.ejecutar bits R proponer atacar actualizar))
    (ha : AceptaPerfil H bits R k proponer atacar actualizar) (defecto : Digest) :
    ∃ n, n < (traza H (Adversario.ejecutar bits R proponer atacar actualizar)).length ∧
      Inicia H (Adversario.ejecutar bits R proponer atacar actualizar) defecto n ∧
      Omite H (Adversario.ejecutar bits R proponer atacar actualizar) defecto n R (k + 2) := by
  obtain ⟨hacc, d, hd, hk⟩ := ha
  obtain ⟨c, hc, n, hn, hs0, ho⟩ := CoberturaPrimeras.cobertura_adversario H L bits R proponer atacar actualizar hs hacc defecto
  have hcd : c = d := Option.some.inj (hc.symm.trans hd)
  subst d
  exact ⟨n, hn, hs0, by simpa only [hk] using ho⟩

theorem cota_sin_excepciones (L bits R k g m B : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (he : k + 2 ≤ 64) (hqM : 40 ≤ 2 ^ (k + 2)) (hqR : 40 ≤ R)
    (hg : ∀ (n : Fin (altura (Adversario.ejecutar bits R proponer atacar actualizar))) H,
      Inicia (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H) (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val →
      (GT (Adversario.ejecutar bits R proponer atacar actualizar) defecto (k + 2) (historia (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val H) ∩ GC (Adversario.ejecutar bits R proponer atacar actualizar) defecto (k + 2) (historia (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val H)).card ≤ g)
    (hm : ∀ (n : Fin (altura (Adversario.ejecutar bits R proponer atacar actualizar))) H,
      Inicia (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H) (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val →
      ((historia (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val H).map Prod.fst).toFinset.card ≤ m)
    (hB : ∀ H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest,
      (entradas (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H) (Adversario.ejecutar bits R proponer atacar actualizar)).toFinset.card ≤ B) :
    promedio (fun H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest =>
      if AceptaPerfil (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H) bits R k proponer atacar actualizar ∧
        EjecucionBytes.SinBad (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H) (inicial L) (Adversario.ejecutar bits R proponer atacar actualizar)
      then (1 : ℚ) else 0) ≤ ROM.SelectorPrimeras.riesgo R (k + 2) 40 g m * B := by
  let p := Adversario.ejecutar bits R proponer atacar actualizar
  have hu := UnionPrefijo.cota_union p defecto (altura p) R (k + 2) g m B he hqM hqR hg hm hB
  apply le_trans _ hu
  apply transferir_evento
  intro H ha
  obtain ⟨n, hn, hs0, ho⟩ := cobertura_perfil (oraculo p defecto H) L bits R k proponer atacar actualizar ha.2 ha.1 defecto
  exact ⟨⟨n, hn.trans_le (costo_acotado (oraculo p defecto H) p)⟩, hs0, ho⟩

theorem cota_aditiva (L bits R k g m B : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (he : k + 2 ≤ 64) (hqM : 40 ≤ 2 ^ (k + 2)) (hqR : 40 ≤ R)
    (hg : ∀ (n : Fin (altura (Adversario.ejecutar bits R proponer atacar actualizar))) H,
      Inicia (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H) (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val →
      (GT (Adversario.ejecutar bits R proponer atacar actualizar) defecto (k + 2) (historia (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val H) ∩ GC (Adversario.ejecutar bits R proponer atacar actualizar) defecto (k + 2) (historia (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val H)).card ≤ g)
    (hm : ∀ (n : Fin (altura (Adversario.ejecutar bits R proponer atacar actualizar))) H,
      Inicia (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H) (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val →
      ((historia (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val H).map Prod.fst).toFinset.card ≤ m)
    (hB : ∀ H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest,
      (entradas (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H) (Adversario.ejecutar bits R proponer atacar actualizar)).toFinset.card ≤ B) :
    promedio (fun H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest =>
      if AceptaPerfil (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H) bits R k proponer atacar actualizar then (1 : ℚ) else 0) ≤
    promedio (fun H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest =>
      @ite ℚ (¬ EjecucionBytes.SinBad (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
        (inicial L) (Adversario.ejecutar bits R proponer atacar actualizar)) (Classical.propDecidable _) 1 0) +
        ROM.SelectorPrimeras.riesgo R (k + 2) 40 g m * B := by
  let p := Adversario.ejecutar bits R proponer atacar actualizar
  have hb := cota_sin_excepciones L bits R k g m B proponer atacar actualizar defecto he hqM hqR hg hm hB
  apply le_trans _ (add_le_add (le_refl (promedio (fun H : universo p → Digest =>
    @ite ℚ (¬ EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p) (Classical.propDecidable _) 1 0))) hb)
  rw [← promedio_suma]
  apply promedio_monotono
  intro H
  by_cases hs : EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p <;>
    by_cases ha : AceptaPerfil (oraculo p defecto H) bits R k proponer atacar actualizar <;>
    dsimp only [p] at hs ha ⊢ <;> norm_num [hs, ha]

end Nexus.Verificador.CotaAceptacion
