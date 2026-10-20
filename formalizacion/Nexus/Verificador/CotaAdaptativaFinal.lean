module

public import Nexus.Verificador.CancelacionAIRCausal
import Mathlib.Tactic

/-!
# Cota final AIR/FRI para el verificador con adversario adaptativo

El mismo conjunto anterior a E cubre todas las rondas FRI de los nueve
perfiles y la cancelación AIR. Su cardinal es a lo sumo 130709: el sesgo
de transporte se paga una sola vez por primera consulta. Se deriva todo
desde Q y el programa real, sin hSin, hpuente, raíces fijas ni leyes ideales
postuladas para retos elegidos después de observar el oráculo.
-/

public section
namespace Nexus.Verificador.CotaAdaptativaFinal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal Nexus.N06
open ProgramaBytes SelectorAdaptativo FiltroSelector

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 1024

@[expose] noncomputable def excepciones (t : Tabla Entrada Digest) (defecto a : Digest) : Finset Fp2 :=
  UnionPerfilesFRI.todos defecto t a ∪ ContextoAIR.excepciones t defecto a

theorem cardinal_excepciones (t : Tabla Entrada Digest) (defecto a : Digest) :
    (excepciones t defecto a).card ≤ 130709 := by
  have hu := Finset.card_union_le (UnionPerfilesFRI.todos defecto t a) (ContextoAIR.excepciones t defecto a)
  have hf := UnionPerfilesFRI.cardinal_todos defecto t a
  have ha := ContextoAIR.cardinal_excepciones t defecto a
  change (excepciones t defecto a).card ≤ _ at hu
  omega

@[expose] def tasa : ℚ := (130709 : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2 + 2524360 / 10 ^ 35

@[expose] noncomputable def ExcepcionE {A : Type} (H : Entrada → Digest)
    (p : Programa A) (defecto : Digest) (N : ℕ) : Prop :=
  ∃ n : Fin N,
    ExtensionesPrefijo.IniciaBytes H p n.val (SemillaProxima.semilla p defecto) ∧
    DesafiosPrograma.extension
      (H (entradaReto (SemillaProxima.semilla p defecto ((traza H p).take n.val)) .extension)) ∈
      excepciones (TablaObservada.tabla ((traza H p).take n.val)) defecto
        (SemillaProxima.semilla p defecto ((traza H p).take n.val))

theorem cubre_fri {A : Type} (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (N : ℕ)
    (h : CotaFRICausal.ExcepcionE H p defecto N) : ExcepcionE H p defecto N := by
  obtain ⟨n, hi, he⟩ := h
  exact ⟨n, hi, Finset.mem_union_left _ he⟩

theorem cubre_air {A : Type} (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (N : ℕ)
    (h : CancelacionAIRCausal.ExcepcionAIR H p defecto N) : ExcepcionE H p defecto N := by
  obtain ⟨n, hi, he⟩ := h
  exact ⟨n, hi, Finset.mem_union_right _ he⟩

theorem rondas_cubiertas {A : Type} (H : Entrada → Digest) (L : ℕ) (p : Programa A)
    (defecto : Digest) (N : ℕ) (hs : EjecucionBytes.SinBad H (inicial L) p)
    (hx : ExcesoRondas.Rondas H p defecto N) : ExcepcionE H p defecto (altura p) := by
  rcases CotaFRICausal.rondas_cubiertas H L p defecto N hs hx with hf | ha
  · exact cubre_fri H p defecto _ hf
  · exact cubre_air H p defecto _ (CancelacionAIRCausal.air_real_cubierta H L p defecto N hs ha)

theorem cota_excepcion {A : Type} (p : Programa A) (defecto : Digest) (N B : ℕ)
    (hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B) :
    medida (fun H : universo p → Digest => ExcepcionE (oraculo p defecto H) p defecto N) ≤ tasa * B := by
  have h := ExtensionesPrefijo.cota_programa p defecto N B 130709
    (fun _ => SemillaProxima.semilla p defecto)
    (fun _ t => excepciones (TablaObservada.tabla t) defecto (SemillaProxima.semilla p defecto t))
    (fun _ _ => cardinal_excepciones _ _ _) hB
  rw [medida_media]
  refine le_trans ?_ h
  apply promedio_monotono
  intro H
  unfold ExcepcionE
  dsimp only [historia]
  split_ifs
  · simp_all
  · positivity

theorem cota_rondas {A : Type} (p : Programa A) (defecto : Digest) (L N B : ℕ)
    (hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B) :
    medida (fun H : universo p → Digest => EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
      ExcesoRondas.Rondas (oraculo p defecto H) p defecto N) ≤ tasa * B := by
  apply le_trans _ (cota_excepcion p defecto (altura p) B hB)
  exact medida_monotona _ _ (fun H hh => rondas_cubiertas (oraculo p defecto H) L p defecto N hh.1 hh.2)

@[expose] noncomputable def selector (k B : ℕ) : ℚ :=
  (Nat.choose (CardinalVista.umbral (k + 2)) 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 +
    1 / (2 : ℚ) ^ 300 + AcoplamientoCadena.error Digest 512 (B - 1)

@[expose] noncomputable def cota512 (L k Q : ℕ) : ℚ :=
  let B := Q + 24895
  min 1 (((B * (49 * B + L) : ℕ) : ℚ) / (2 : ℚ) ^ 256) +
    (tasa + selector k B) * B

theorem cota_512 {A : Type} (L bits k Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias
          (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
          bits 512 proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar) ≤
      cota512 L k Q := by
  dsimp only
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  have hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ Q + 24895 := by
    intro H
    simpa only [PresupuestoGlobal.presupuesto_512] using
      PresupuestoGlobal.entradas_distintas (oraculo p defecto H) bits 512 Q
        proponer atacar actualizar (hQ H)
  have hbase := CotaSinBad.cota_512_rondas_seguras L bits k Q proponer atacar actualizar defecto hk0 hk1 hQ
  have hrondas := cota_rondas p defecto L (altura p) (Q + 24895) hB
  dsimp only at hbase
  dsimp only [p] at hrondas
  have hsub : Q + 24895 - 1 = Q + 24894 := by omega
  unfold cota512 selector
  dsimp only
  rw [hsub]
  simp only [Nat.cast_add, Nat.cast_ofNat] at hrondas ⊢
  nlinarith only [hbase, hrondas]

end Nexus.Verificador.CotaAdaptativaFinal
