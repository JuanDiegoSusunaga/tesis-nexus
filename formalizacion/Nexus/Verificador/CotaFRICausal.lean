module

public import Nexus.Verificador.RondasCausales
public import Nexus.Verificador.UnionPerfilesFRI
public import Nexus.Verificador.CotaSinBad
public import Nexus.Canal.ExtensionesPrefijo
import Mathlib.Tactic

/-!
# Cota FRI del adversario real, sin raíces ni perfiles fijados de antemano

Cada fallo FRI se reasigna a la primera llamada E de su historia. La unión
previa incluye todos los perfiles y rondas posibles; se paga una sola vez
el sesgo de esa respuesta. El presupuesto es el de direcciones distintas
del programa original. La cancelación AIR queda como evento explícito.
-/

public section
namespace Nexus.Verificador.CotaFRICausal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal Nexus.N06
open ProgramaBytes SelectorAdaptativo VistaSemantica VistaCampo VistaCausal
open FiltroFalso RondasCausales FiltroSelector

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def tasa : ℚ := (130708 : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2 + 2524360 / 10 ^ 35

@[expose] noncomputable def ExcepcionE {A : Type} (H : Entrada → Digest)
    (p : Programa A) (defecto : Digest) (N : ℕ) : Prop :=
  ∃ n : Fin N,
    ExtensionesPrefijo.IniciaBytes H p n.val (SemillaProxima.semilla p defecto) ∧
    DesafiosPrograma.extension
      (H (entradaReto (SemillaProxima.semilla p defecto ((traza H p).take n.val)) .extension)) ∈
      UnionPerfilesFRI.todos defecto (TablaObservada.tabla ((traza H p).take n.val))
        (SemillaProxima.semilla p defecto ((traza H p).take n.val))

@[expose] noncomputable def AIRReal {A : Type} (H : Entrada → Digest)
    (p : Programa A) (defecto : Digest) (N : ℕ) : Prop :=
  ∃ n : Fin N, PoliticasPrefijo.Inicia H p defecto n.val ∧
    ∃ d : ParametrosRecuperados.DatosCanal,
      Canonico (TablaObservada.tabla ((traza H p).take n.val)) defecto
        (SemillaProxima.semilla p defecto ((traza H p).take n.val)) d ∧
      Falso d ∧ CancelacionAIR (construir (TablaObservada.tabla ((traza H p).take n.val))
        defecto d (ReconstruccionSelector.candidato (TablaObservada.tabla ((traza H p).take n.val))
          (SemillaProxima.semilla p defecto ((traza H p).take n.val))))

theorem cota_excepcion {A : Type} (p : Programa A) (defecto : Digest) (N B : ℕ)
    (hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B) :
    medida (fun H : universo p → Digest => ExcepcionE (oraculo p defecto H) p defecto N) ≤ tasa * B := by
  have h := ExtensionesPrefijo.cota_programa p defecto N B 130708
    (fun _ => SemillaProxima.semilla p defecto)
    (fun _ t => UnionPerfilesFRI.todos defecto (TablaObservada.tabla t) (SemillaProxima.semilla p defecto t))
    (fun _ _ => UnionPerfilesFRI.cardinal_todos _ _ _) hB
  rw [medida_media]
  refine le_trans ?_ h
  apply promedio_monotono
  intro H
  unfold ExcepcionE
  dsimp only [historia]
  split_ifs
  · simp_all
  · positivity

theorem fri_implica_excepcion {A : Type} (H : Entrada → Digest) (L : ℕ)
    (p : Programa A) (defecto : Digest) (n k m : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hk : k ≤ 29) (hm : m ≤ k + 1) (hmf : m = k ∨ m = k + 1)
    (hs : EjecucionBytes.SinBad H (inicial L) p)
    (hx : FallaFRICausal (PrefijoPrograma.estado H (inicial L) p n) defecto k m hk hm) :
    ExcepcionE H p defecto (altura p) := by
  let fin := PrefijoPrograma.estado H (inicial L) p n
  let G := funcionTabla defecto fin.tabla
  obtain ⟨j, e, corte, htag, hroot, he⟩ := hx
  let c : CapaPrevia fin k j.val defecto (RegistroRaices.beta G e)
      (oraculoEnEstado k j.val defecto corte.segunda.antes e.raiz) :=
    ⟨e, corte, htag, rfl, rfl⟩
  have hu : RegistroRaices.beta G e ∈ UnionPerfilesFRI.todos defecto corte.segunda.antes.tabla
      (G (RegistroRaices.absorcion e)) := by
    rcases hmf with hphase | hphase
    · subst m; exact UnionPerfilesFRI.mem_traza k hk0 hk1 defecto _ _ j _ he
    · subst m; exact UnionPerfilesFRI.mem_composicion k hk0 hk1 defecto _ _ j _ he
  obtain ⟨a, ha, hnext, hfresh, htabla⟩ := c.en_llamadas H p hs
  obtain ⟨hinicia, hsemilla⟩ := ExtensionesPrefijo.inicio_conocido H p defecto
    (G (RegistroRaices.absorcion e)) a hnext hfresh
  have hreal := c.respuesta_real H
    (PrefijoPrograma.compatible_estado H (inicial L) p n (by intro q d hd; cases hd))
  have ha' : a < altura p := ha.trans_le (costo_acotado H p)
  refine ⟨⟨a, ha'⟩, hinicia, ?_⟩
  rw [hsemilla, ← htabla]
  rw [hreal] at hu
  exact hu

theorem rondas_cubiertas {A : Type} (H : Entrada → Digest) (L : ℕ) (p : Programa A)
    (defecto : Digest) (N : ℕ) (hs : EjecucionBytes.SinBad H (inicial L) p)
    (hx : ExcesoRondas.Rondas H p defecto N) :
    ExcepcionE H p defecto (altura p) ∨ AIRReal H p defecto N := by
  obtain ⟨n, hi, d, hc, hf, he⟩ := rondas_causales H L p defecto N hs hx
  rcases he with ht | hair | hcomp
  · exact Or.inl (fri_implica_excepcion H L p defecto n.val d.k d.k
      hc.perfil.1.1 hc.perfil.1.2 _ _ (Or.inl rfl) hs ht)
  · right
    refine ⟨n, hi, d, ?_, hf, ?_⟩
    · simpa only [PrefijoPrograma.tabla_desde_vacio] using hc
    · simpa only [PrefijoPrograma.tabla_desde_vacio] using hair
  · exact Or.inl (fri_implica_excepcion H L p defecto n.val d.k (d.k + 1)
      hc.perfil.1.1 hc.perfil.1.2 _ _ (Or.inr rfl) hs hcomp)

theorem cota_rondas {A : Type} (p : Programa A) (defecto : Digest) (L N B : ℕ)
    (hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B) :
    medida (fun H : universo p → Digest => EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
      ExcesoRondas.Rondas (oraculo p defecto H) p defecto N) ≤
      tasa * B + medida (fun H : universo p → Digest =>
        EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
          AIRReal (oraculo p defecto H) p defecto N) := by
  have hcover : medida (fun H : universo p → Digest =>
      EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
        ExcesoRondas.Rondas (oraculo p defecto H) p defecto N) ≤
      medida (fun H : universo p → Digest => ExcepcionE (oraculo p defecto H) p defecto (altura p)) +
        medida (fun H : universo p → Digest =>
          EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
            AIRReal (oraculo p defecto H) p defecto N) := by
    rw [medida_media, medida_media, medida_media, ← promedio_suma]
    apply promedio_monotono
    intro H
    by_cases hh : EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
        ExcesoRondas.Rondas (oraculo p defecto H) p defecto N
    · rcases rondas_cubiertas (oraculo p defecto H) L p defecto N hh.1 hh.2 with he | hair
      · simp only [hh, he, ite_true]; split_ifs <;> norm_num
      · simp only [hh, hair, and_self, ite_true]; split_ifs <;> norm_num
    · simp only [hh, ite_false]; split_ifs <;> norm_num
  have hfri := cota_excepcion p defecto (altura p) B hB
  linarith only [hcover, hfri]

set_option exponentiation.threshold 512 in
theorem cota_512_con_air {A : Type} (L bits k Q : ℕ)
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
      min 1 ((((Q + 24895) * (49 * (Q + 24895) + L) : ℕ) : ℚ) / (2 : ℚ) ^ 256) +
      tasa * (Q + 24895) +
      medida (fun H : universo p → Digest =>
        EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
          AIRReal (oraculo p defecto H) p defecto (altura p)) +
      ((Nat.choose (CardinalVista.umbral (k + 2)) 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 +
        1 / (2 : ℚ) ^ 300 + AcoplamientoCadena.error Digest 512 (Q + 24894)) *
        (Q + 24895) := by
  dsimp only
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  have hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ Q + 24895 := by
    intro H
    simpa only [PresupuestoGlobal.presupuesto_512] using
      PresupuestoGlobal.entradas_distintas (oraculo p defecto H) bits 512 Q
        proponer atacar actualizar (hQ H)
  have hbase := CotaSinBad.cota_512_rondas_seguras L bits k Q proponer atacar actualizar defecto hk0 hk1 hQ
  have hfri := cota_rondas p defecto L (altura p) (Q + 24895) hB
  dsimp only at hbase
  dsimp only [p] at hfri
  simp only [Nat.cast_add, Nat.cast_ofNat] at hfri
  linarith only [hbase, hfri]

end Nexus.Verificador.CotaFRICausal
