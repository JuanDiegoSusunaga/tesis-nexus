module

public import Nexus.Verificador.RondasReales
public import Nexus.Canal.VistaCausal
import Mathlib.Tactic

/-!
# Los fallos FRI reales se trasladan a su primera respuesta E

La inclusión es determinista bajo SinBad. La raíz se vuelve a leer de la
tabla anterior a esa respuesta, no de un parámetro fijado antes de ejecutar
al adversario. La rama de cancelación AIR se mantiene separada: aquí no se
le atribuye una cota ni se supone uniformidad condicionada al futuro.
-/

public section
namespace Nexus.Verificador.RondasCausales

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open VistaSemantica VistaCampo VistaCausal FiltroFalso RondasReales
open ProgramaBytes

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] noncomputable def FallaFRICausal {B : ℕ} (fin : Estado B) (defecto : Digest)
    (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1) : Prop :=
  ∃ j : Fin m, ∃ e : RegistroRaices.Evento,
    ∃ c : CorteRaizReto fin e.estado e.tag e.raiz .extension
      (funcionTabla defecto fin.tabla (RegistroRaices.absorcion e))
      (funcionTabla defecto fin.tabla (RegistroRaices.reto (funcionTabla defecto fin.tabla) e)),
      e.tag = 2 ∧
      raizPrevia c.segunda.antes.tabla
        (funcionTabla defecto fin.tabla (RegistroRaices.absorcion e)) = some e.raiz ∧
      RegistroRaices.beta (funcionTabla defecto fin.tabla) e ∈
        Nexus.FRI.excepciones (torreGoldilocks k m hk hm) (1 / 8) (by norm_num)
          dos_extension_no_cero (margen_torre_goldilocks k m hk hm) j
          (oraculoPrevio k j.val defecto c.segunda.antes.tabla
            (funcionTabla defecto fin.tabla (RegistroRaices.absorcion e)))

@[expose] noncomputable def CancelacionAIR (v : Vista) : Prop :=
  ∃ f : Polynomial Fp2,
    candidatoPerfil v.datos.k (oraculoTraza (prefijo v) 0) (1 / 8) = some f ∧
    (∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) ∧
    Nexus.AIR.numeradorCombinado (2 ^ v.datos.k) (raizExtension v.datos.k) f
      (algebraMap Fp Fp2 v.datos.inicio) (algebraMap Fp Fp2 v.datos.salida)
      (prefijo v).coeficientes % Nexus.AIR.denominador (2 ^ v.datos.k) = 0

theorem capa_excepcional {B : ℕ} {fin : Estado B} {defecto : Digest}
    (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1) (j : Fin m)
    {b : Fp2} {o : Fp2 → Fp2} (c : CapaPrevia fin k j.val defecto b o)
    (hx : b ∈ Nexus.FRI.excepciones (torreGoldilocks k m hk hm) (1 / 8) (by norm_num)
      dos_extension_no_cero (margen_torre_goldilocks k m hk hm) j o) :
    FallaFRICausal fin defecto k m hk hm := by
  refine ⟨j, c.evento, c.corte, c.etiqueta_fri, c.raiz_recuperada, ?_⟩
  rw [← c.beta_eq, ← c.oraculo_desde_pasado]
  exact hx

theorem traza_clasificada {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : ParametrosRecuperados.DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (hk : d.k ≤ 29)
    (hx : FallaTraza (construir fin.tabla defecto d
      (ReconstruccionSelector.candidato fin.tabla s)) hk) :
    FallaFRICausal fin defecto d.k d.k hk (Nat.le_succ _) := by
  obtain ⟨j, hj⟩ := hx
  obtain ⟨c⟩ := traza_causal r defecto s d hc j
  exact capa_excepcional d.k d.k hk (Nat.le_succ _) j c hj

theorem composicion_clasificada {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : ParametrosRecuperados.DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (hk : d.k ≤ 29)
    (hx : FallaComposicion (construir fin.tabla defecto d
      (ReconstruccionSelector.candidato fin.tabla s)) hk) :
    FallaFRICausal fin defecto d.k (d.k + 1) hk (le_refl _) := by
  obtain ⟨j, hj⟩ := hx
  obtain ⟨c⟩ := composicion_causal r defecto s d hc j
  exact capa_excepcional d.k (d.k + 1) hk (le_refl _) j c hj

theorem fallos_causales {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : ParametrosRecuperados.DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (hk : d.k ≤ 29)
    (hx : Fallos (construir fin.tabla defecto d (ReconstruccionSelector.candidato fin.tabla s)) hk) :
    FallaFRICausal fin defecto d.k d.k hk (Nat.le_succ _) ∨
      CancelacionAIR (construir fin.tabla defecto d (ReconstruccionSelector.candidato fin.tabla s)) ∨
      FallaFRICausal fin defecto d.k (d.k + 1) hk (le_refl _) := by
  rcases hx with ht | ⟨f, hf, hA, hair | hcomp⟩
  · exact Or.inl (traza_clasificada r defecto s d hc hk ht.2)
  · exact Or.inr (Or.inl ⟨f, hf, hA, hair⟩)
  · exact Or.inr (Or.inr (composicion_clasificada r defecto s d hc hk hcomp.2))

theorem rondas_causales {A : Type} (H : Entrada → Digest) (L : ℕ) (p : Programa A)
    (defecto : Digest) (N : ℕ) (hs : EjecucionBytes.SinBad H (inicial L) p)
    (hx : ExcesoRondas.Rondas H p defecto N) :
    ∃ n : Fin N, PoliticasPrefijo.Inicia H p defecto n.val ∧
      ∃ d : ParametrosRecuperados.DatosCanal, ∃ hc : Canonico
        (PrefijoPrograma.estado H (inicial L) p n.val).tabla defecto
        (SemillaProxima.semilla p defecto ((traza H p).take n.val)) d,
        Falso d ∧
        (let fin := PrefijoPrograma.estado H (inicial L) p n.val
         let hk : d.k ≤ 29 := by have hh := hc.perfil.1.2; omega
         FallaFRICausal fin defecto d.k d.k hk (Nat.le_succ _) ∨
           CancelacionAIR (construir fin.tabla defecto d
             (ReconstruccionSelector.candidato fin.tabla
               (SemillaProxima.semilla p defecto ((traza H p).take n.val)))) ∨
           FallaFRICausal fin defecto d.k (d.k + 1) hk (le_refl _)) := by
  obtain ⟨n, hi, d, hc, hf, hfall⟩ := rondas_clasificadas H p defecto N hx
  let fin := PrefijoPrograma.estado H (inicial L) p n.val
  have htab : fin.tabla = TablaObservada.tabla ((traza H p).take n.val) :=
    PrefijoPrograma.tabla_desde_vacio H L p n.val
  have hcanon : Canonico fin.tabla defecto
      (SemillaProxima.semilla p defecto ((traza H p).take n.val)) d := by
    rw [htab]; exact hc
  refine ⟨n, hi, d, hcanon, hf, ?_⟩
  have r : RecorridoSinAcierto L (inicial L) fin :=
    PrefijoPrograma.recorrido_prefijo H (inicial L) p n.val
      (by intro e valor h; cases h) hs
  apply fallos_causales r defecto _ d hcanon
  simpa only [htab] using hfall

end Nexus.Verificador.RondasCausales
