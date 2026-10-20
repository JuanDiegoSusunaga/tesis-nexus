module

public import Nexus.Verificador.NonceCandidato
public import Nexus.Canal.ConteoNonce
public import Nexus.Canal.UnionFiltrada
public import Nexus.Verificador.CotaPerfilesFinal
import Mathlib.Tactic

/-!
# El riesgo del selector se cobra por Q+1 candidatos, no por Q+V llamadas

Se activan únicamente candidatos elegibles reconocidos desde el pasado.
La absorción de su nonce ya ocurrió y determina su semilla; la inyección
a esas consultas y el conteo del programa real dan Q+1 sin asumir SinBad.
El tamaño del pasado para el acoplamiento sigue acotado por B-1.
-/

public section
namespace Nexus.Verificador.CotaInicios

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.N06 Nexus.ROM Nexus.Canal
open ProgramaBytes SelectorAdaptativo FiltroSelector
open LeyArbol ObservacionesPrefijo PrimeraExposicion ConteoActivaciones ActivacionPrefijo
open scoped BigOperators

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 1024

theorem carga_adversario {A : Type} (H : Entrada → Digest) (bits R : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest) (N Q : ℕ)
    (hQ : Adversario.adversarias H bits R proponer atacar actualizar ≤ Q) :
    numero (fun n : Fin N => fun H => NonceCandidato.Activa H
      (Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val) H ≤ Q + 1 := by
  have hn := NonceCandidato.carga_llamadas_nonce H
    (Adversario.ejecutar bits R proponer atacar actualizar) defecto N
  have hc := ConteoNonce.adversario H bits R proponer atacar actualizar
  exact hn.trans (hc.trans (Nat.add_le_add_right hQ 1))

theorem cota_union_elegible {A : Type} (p : Programa A) (defecto : Digest) (N R e g B K : ℕ)
    (he : e ≤ 64) (hqM : 40 ≤ 2 ^ e) (hqR : 40 ≤ R)
    (hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B)
    (hK : ∀ H : universo p → Digest,
      numero (fun n : Fin N => fun H => NonceCandidato.Activa H p defecto n.val) (oraculo p defecto H) ≤ K) :
    medida (fun H : universo p → Digest => ∃ n : Fin N,
      PoliticasPrefijo.Inicia (oraculo p defecto H) p defecto n.val ∧
        PoliticasFalsas.Omite (oraculo p defecto H) p defecto n.val R e g) ≤
      ROM.SelectorPrimeras.riesgo R e 40 g (B - 1) * K := by
  let activa := fun t : List ((universo p) × Digest) =>
    Activa (arbol p) (fun t => codigo p (SemillaProxima.semilla p defecto (proyectar t))) t ∧
      PoliticasFalsas.elegible p defecto (proyectar t)
  let ev := fun (n : Fin N) H => SelectorPrefijo.OmiteOAbandona (codigo p) (arbol p) n.val R e 40
    (fun t => SemillaProxima.semilla p defecto (proyectar t))
    (fun t => PoliticasFalsas.GT p defecto e g (proyectar t))
    (fun t => PoliticasFalsas.GC p defecto e g (proyectar t)) H
  let rho := ROM.SelectorPrimeras.riesgo R e 40 g (B - 1)
  have hact (n : ℕ) (H : universo p → Digest) :
      activa (prefijo (arbol p) n H) ↔ NonceCandidato.Activa (oraculo p defecto H) p defecto n := by
    dsimp only [activa, NonceCandidato.Activa]
    rw [PrimerasExposiciones.inicio_iff, prefijo_bytes p defecto]
    rfl
  have hcarga (H : universo p → Digest) :
      numero (fun n : Fin N => fun H => activa (prefijo (arbol p) n.val H)) H ≤ K := by
    have heq : numero (fun n : Fin N => fun H => activa (prefijo (arbol p) n.val H)) H =
        numero (fun n : Fin N => fun H => NonceCandidato.Activa H p defecto n.val) (oraculo p defecto H) := by
      unfold numero
      congr 1
      ext n
      simp only [Finset.mem_filter, Finset.mem_univ, true_and, hact]
    rw [heq]
    exact hK H
  have hlocal (n : Fin N) :
      promedio (fun H : universo p → Digest =>
        if activa (prefijo (arbol p) n.val H) ∧ ev n H then (1 : ℚ) else 0) ≤
      rho * promedio (fun H : universo p → Digest =>
        if activa (prefijo (arbol p) n.val H) then (1 : ℚ) else 0) := by
    apply cota_activada_constante
    intro H ha
    have hinicio := ((hact n.val H).mp ha).1
    have hm : (PrefijosGlobales.vistas H (arbol p) n.val).card ≤ B - 1 := by
      rw [cardinal_vistas p defecto n.val H]
      exact PresupuestoPrefijo.prefijo_desde_total (oraculo p defecto H) p defecto n.val B hinicio (hB H)
    exact ROM.SelectorPrimeras.cota_condicionada (codigo p)
      (SelectorAcoplado.codificar_inyectiva _ _) (arbol p) n.val R e 40 g (B - 1)
      (fun t => SemillaProxima.semilla p defecto (proyectar t))
      (fun t => PoliticasFalsas.GT p defecto e g (proyectar t))
      (fun t => PoliticasFalsas.GC p defecto e g (proyectar t)) H ha.1
      (PoliticasFalsas.cardinal p defecto e g _) hm he hqM hqR
  have hu := cota_por_presupuesto
    (fun (n : Fin N) H => activa (prefijo (arbol p) n.val H)) ev rho K
    (ROM.SelectorPrimeras.riesgo_no_negativo _ _ _ _ _) hcarga hlocal
  rw [medida_media]
  refine le_trans ?_ hu
  apply transferir_evento
  intro H hh
  obtain ⟨n, hi, ho⟩ := hh
  have heleg := (PoliticasFalsas.omision_iff (oraculo p defecto H) p defecto n.val R e g).mp ho
  refine ⟨n, (hact n.val H).mpr ⟨hi, heleg.1.1⟩, ?_⟩
  exact SelectorAdaptativo.acepta_implica p defecto n.val R e (SemillaProxima.semilla p defecto)
    (PoliticasFalsas.GT p defecto e g) (PoliticasFalsas.GC p defecto e g) H
    ((UnionFiltrada.omision_iff p defecto n.val R e g H).mp ho)

theorem cota_union_adversario {A : Type} (bits R e g Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest) (N : ℕ)
    (he : e ≤ 64) (hqM : 40 ≤ 2 ^ e) (hqR : 40 ≤ R)
    (hQ : ∀ H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest,
      Adversario.adversarias (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
        bits R proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits R proponer atacar actualizar
    medida (fun H : universo p → Digest => ∃ n : Fin N,
      PoliticasPrefijo.Inicia (oraculo p defecto H) p defecto n.val ∧
        PoliticasFalsas.Omite (oraculo p defecto H) p defecto n.val R e g) ≤
      ROM.SelectorPrimeras.riesgo R e 40 g (PresupuestoGlobal.B Q R - 1) * (Q + 1) := by
  dsimp only
  have h := cota_union_elegible _ defecto N R e g (PresupuestoGlobal.B Q R) (Q + 1) he hqM hqR
    (fun H => PresupuestoGlobal.entradas_distintas _ bits R Q proponer atacar actualizar (hQ H))
    (fun H => carga_adversario _ bits R proponer atacar actualizar defecto N Q (hQ H))
  simpa only [Nat.cast_add, Nat.cast_one] using h

theorem cota_selector_seguro {A : Type} (L bits k Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
        bits 512 proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar ∧
        EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
        ¬ (EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p ∧
          ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p))) ≤
      CotaAdaptativaFinal.selector k (Q + 24895) * (Q + 1) := by
  dsimp only
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  have hm : 40 ≤ 2 ^ (k + 2) := (by decide : 40 ≤ 2 ^ 6).trans
    (Nat.pow_le_pow_right (by decide : 0 < 2) (by omega : 6 ≤ k + 2))
  have hu := cota_union_adversario bits 512 (k + 2) (CardinalVista.umbral (k + 2)) Q
    proponer atacar actualizar defecto (altura p) (by omega) hm (by decide) hQ
  have hr := (ROM.SelectorPrimeras.riesgo_512 k (CardinalVista.umbral (k + 2))
    (PresupuestoGlobal.B Q 512 - 1) hk0 hk1).le
  have hfinal := hu.trans (mul_le_mul_of_nonneg_right hr (by positivity : (0 : ℚ) ≤ Q + 1))
  simp only [PresupuestoGlobal.presupuesto_512] at hfinal
  refine le_trans ?_ hfinal
  apply medida_monotona
  intro H hh
  apply PoliticasFalsas.sin_exceso_cubre (oraculo p defecto H) p defecto (altura p) 512
    (k + 2) (CardinalVista.umbral (k + 2))
    (PoliticasFalsas.cobertura_adversario (oraculo p defecto H) L bits 512 k
      proponer atacar actualizar hh.2.1 hh.1 defecto)
  intro hexceso
  exact hh.2.2 ⟨hh.2.1, ExcesoRondas.exceso_implica_rondas (oraculo p defecto H) p defecto
    (altura p) (k + 2) hexceso⟩

@[expose] noncomputable def cota512 (L k Q : ℕ) : ℚ :=
  let B := Q + 24895
  min 1 (((B * (49 * B + L) : ℕ) : ℚ) / (2 : ℚ) ^ 256) +
    CotaAdaptativaFinal.tasa * B + CotaAdaptativaFinal.selector k B * (Q + 1)

theorem cota_512 {A : Type} (L bits k Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
        bits 512 proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 k proponer atacar actualizar) ≤ cota512 L k Q := by
  dsimp only
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  have hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ Q + 24895 := by
    intro H
    simpa only [PresupuestoGlobal.presupuesto_512] using
      PresupuestoGlobal.entradas_distintas _ bits 512 Q proponer atacar actualizar (hQ H)
  have hsafe := cota_selector_seguro L bits k Q proponer atacar actualizar defecto hk0 hk1 hQ
  have hsep := separar_excepciones _ _ _ _ hsafe
  have hsin := CotaSinBad.cota_512 L bits Q proponer atacar actualizar defecto hQ
  have hrondas := CotaAdaptativaFinal.cota_rondas p defecto L (altura p) (Q + 24895) hB
  dsimp only at hsep hsin
  dsimp only [p] at hrondas
  unfold cota512
  dsimp only
  simp only [Nat.cast_add, Nat.cast_ofNat] at hrondas ⊢
  linarith only [hsep, hsin, hrondas]

theorem union_con_pasado {W I : Type} [Fintype W] [Fintype I]
    (E : I → W → Prop) (S X : W → Prop) :
    medida (fun w => (∃ i, E i w) ∧ S w ∧ ¬ X w) ≤
      ∑ i, medida (fun w => E i w ∧ S w ∧ ¬ X w) := by
  calc
    _ ≤ medida (fun w => ∃ i, E i w ∧ S w ∧ ¬ X w) :=
      medida_monotona _ _ (fun _ h => by obtain ⟨i, hi⟩ := h.1; exact ⟨i, hi, h.2⟩)
    _ ≤ _ := by
      simp_rw [medida_media]
      exact ConteoActivaciones.union_finita (fun i w => E i w ∧ S w ∧ ¬ X w)

@[expose] noncomputable def cota512Todos (L Q : ℕ) : ℚ :=
  let B := Q + 24895
  min 1 (((B * (49 * B + L) : ℕ) : ℚ) / (2 : ℚ) ^ 256) +
    CotaAdaptativaFinal.tasa * B + CotaPerfilesFinal.selectorTodos B * (Q + 1)

theorem cota_512_todos {A : Type} (L bits Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (hQ : ∀ H : universo (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias (oraculo (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
        bits 512 proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      CotaPerfilesFinal.AceptaFalsaTotal (oraculo p defecto H) bits 512 proponer atacar actualizar) ≤
      min 1 (cota512Todos L Q) := by
  dsimp only
  apply le_min (CotaPerfilesFinal.medida_le_uno _)
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  let B := Q + 24895
  let E := fun (i : Fin 9) (H : universo p → Digest) =>
    PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits 512 (i.val + 4) proponer atacar actualizar
  let S := fun H : universo p → Digest => EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p
  let X := fun H : universo p → Digest => S H ∧ ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p)
  have hB : ∀ H : universo p → Digest, (entradas (oraculo p defecto H) p).toFinset.card ≤ B := by
    intro H
    simpa only [PresupuestoGlobal.presupuesto_512] using
      PresupuestoGlobal.entradas_distintas _ bits 512 Q proponer atacar actualizar (hQ H)
  have hsafe : medida (fun H => (∃ i : Fin 9, E i H) ∧ S H ∧ ¬ X H) ≤
      CotaPerfilesFinal.selectorTodos B * (Q + 1) := by
    calc
      _ ≤ ∑ i : Fin 9, medida (fun H => E i H ∧ S H ∧ ¬ X H) := union_con_pasado E S X
      _ ≤ ∑ i : Fin 9, CotaAdaptativaFinal.selector (i.val + 4) B * (Q + 1) := by
        apply Finset.sum_le_sum
        intro i _
        exact cota_selector_seguro L bits (i.val + 4) Q proponer atacar actualizar defecto (by omega) (by omega) hQ
      _ = _ := by unfold CotaPerfilesFinal.selectorTodos; rw [Finset.sum_mul]
  have hsep := separar_excepciones (fun H => ∃ i : Fin 9, E i H) S X
    (CotaPerfilesFinal.selectorTodos B * (Q + 1)) hsafe
  have hsin := CotaSinBad.cota_512 L bits Q proponer atacar actualizar defecto hQ
  have hrondas := CotaAdaptativaFinal.cota_rondas p defecto L (altura p) B hB
  have htotal := medida_monotona
    (fun H : universo p → Digest =>
      CotaPerfilesFinal.AceptaFalsaTotal (oraculo p defecto H) bits 512 proponer atacar actualizar)
    (fun H => ∃ i : Fin 9, E i H)
    (fun H h => (CotaPerfilesFinal.falsa_total_iff_perfiles (oraculo p defecto H) bits 512
      proponer atacar actualizar).mp h)
  dsimp only [E, S, X, p, B] at hsep hrondas htotal
  dsimp only at hsin
  unfold cota512Todos
  dsimp only
  simp only [Nat.cast_add, Nat.cast_ofNat] at hsep hrondas ⊢
  linarith only [htotal, hsep, hsin, hrondas]

end Nexus.Verificador.CotaInicios
