module

public import Nexus.Verificador.CardinalVista
public import Nexus.Verificador.CotaFalsa
import Mathlib.Tactic

/-!
# Todo exceso real requiere una excepción AIR/FRI identificada

El evento conserva la tabla y los retos realmente leídos antes de la primera
I. No se afirma que ese evento tenga la ley del experimento ideal: falta
demostrar la previsibilidad de cada vector antes de su propio reto E.
-/

public section
namespace Nexus.Verificador.ExcesoRondas

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open ProgramaBytes FiltroFalso VistaSemantica VistaCampo FiltroSelector

variable {A : Type}
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] noncomputable def SeguroDatos (t : Tabla Entrada Digest) (defecto s : Digest)
    (d : ParametrosRecuperados.DatosCanal) (hc : Canonico t defecto s d) : Prop :=
  PrefijoSeguro d.k (by have hk := hc.perfil.1.2; omega) d.inicio d.salida
    (prefijo (construir t defecto d (ReconstruccionSelector.candidato t s)))

@[expose] noncomputable def Excepcion (t : Tabla Entrada Digest) (defecto s : Digest) : Prop :=
  ∃ d, ∃ hc : Canonico t defecto s d, Falso d ∧ ¬ SeguroDatos t defecto s d hc

@[expose] noncomputable def Rondas (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (N : ℕ) : Prop :=
  ∃ n : Fin N, PoliticasPrefijo.Inicia H p defecto n.val ∧
    Excepcion (TablaObservada.tabla ((traza H p).take n.val)) defecto
      (SemillaProxima.semilla p defecto ((traza H p).take n.val))

theorem exceso_tabla (t : Tabla Entrada Digest) (defecto s : Digest) (e : ℕ)
    (he : Elegible t defecto s)
    (hg : CardinalVista.umbral e < (ConjuntosPrevios.GT e defecto s t ∩ ConjuntosPrevios.GC e defecto s t).card) :
    Excepcion t defecto s := by
  obtain ⟨d, hc, hf⟩ := (elegible_iff t defecto s).mp he
  refine ⟨d, hc, hf, ?_⟩
  intro hs
  exact (Nat.not_lt_of_ge (CardinalVista.cardinal_canonico t defecto s d hc hs e)) hg

theorem exceso_implica_rondas (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (N e : ℕ)
    (hx : PoliticasFalsas.Exceso H p defecto N e (CardinalVista.umbral e)) :
    Rondas H p defecto N := by
  obtain ⟨n, hi, he, hg⟩ := hx
  exact ⟨n, hi, exceso_tabla _ defecto _ e he hg⟩

theorem medida_exceso (p : Programa A) (defecto : Digest) (N e : ℕ) :
    medida (fun H : SelectorAdaptativo.universo p → Digest =>
      PoliticasFalsas.Exceso (SelectorAdaptativo.oraculo p defecto H) p defecto N e (CardinalVista.umbral e)) ≤
    medida (fun H : SelectorAdaptativo.universo p → Digest =>
      Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto N) :=
  medida_monotona _ _ (fun _ => exceso_implica_rondas _ p defecto N e)

theorem cota_aceptacion (L bits R k B : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (he : k + 2 ≤ 64) (hqM : 40 ≤ 2 ^ (k + 2)) (hqR : 40 ≤ R)
    (hB : ∀ H : SelectorAdaptativo.universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest,
      (entradas (SelectorAdaptativo.oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
        (Adversario.ejecutar bits R proponer atacar actualizar)).toFinset.card ≤ B) :
    let p := Adversario.ejecutar bits R proponer atacar actualizar
    medida (fun H : SelectorAdaptativo.universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (SelectorAdaptativo.oraculo p defecto H) bits R k proponer atacar actualizar) ≤
    medida (fun H : SelectorAdaptativo.universo p → Digest =>
      ¬ EjecucionBytes.SinBad (SelectorAdaptativo.oraculo p defecto H) (inicial L) p) +
    medida (fun H : SelectorAdaptativo.universo p → Digest =>
      Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto (altura p)) +
      ROM.SelectorPrimeras.riesgo R (k + 2) 40 (CardinalVista.umbral (k + 2)) (B - 1) * B := by
  let p := Adversario.ejecutar bits R proponer atacar actualizar
  have hc := CotaFalsa.cota_aditiva L bits R k (CardinalVista.umbral (k + 2)) B
    proponer atacar actualizar defecto he hqM hqR hB
  exact hc.trans (add_le_add (add_le_add (le_refl _) (medida_exceso p defecto (altura p) (k + 2))) (le_refl _))

end Nexus.Verificador.ExcesoRondas
