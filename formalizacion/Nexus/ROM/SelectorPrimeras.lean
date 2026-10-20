module

public import Nexus.ROM.SelectorAdaptativo
public import Nexus.ROM.CargaPrimeras
import Mathlib.Tactic

/-!
# Selector cobrado en la primera exposición de cada candidato

La semilla y los conjuntos se eligen con el prefijo anterior a la consulta.
Las preconsultas deliberadas quedan cubiertas por su primer intento, siempre
que el candidato final conserve la semilla y los conjuntos congelados allí.
No se afirma que ese registro ya corresponda a todos los candidatos de Rust.
-/

public section
namespace Nexus.ROM.SelectorPrimeras

open Nexus.Bytes Nexus.Merkle Nexus.N06 LeyArbol PrefijosGlobales ObservacionesPrefijo
open SelectorPrefijo PrimeraExposicion CargaPrimeras ConteoActivaciones ActivacionPrefijo

variable {Q X : Type} [DecidableEq Q] [Fintype Q]
attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000
set_option exponentiation.threshold 1024

@[expose] noncomputable def riesgo (R e q g m : ℕ) : ℚ :=
  (Nat.choose g q : ℚ) / Nat.choose (2 ^ e) q + Selector.probabilidadIncompleta (2 ^ e) R q +
    AcoplamientoCadena.error Digest R m

omit [DecidableEq Q] [Fintype Q] in
theorem riesgo_no_negativo (R e q g m : ℕ) : 0 ≤ riesgo R e q g m := by
  apply add_nonneg (add_nonneg (by positivity) (SelectorAdaptativo.tau_no_negativa _ _ _))
  exact AcoplamientoCadena.error_no_negativo _ _

theorem cota_condicionada (codificar : Digest → Q) (hi : Function.Injective codificar)
    (p : Arbol Q Digest X) (n R e q g m : ℕ) (semilla : Historia Q → Digest)
    (GT GC : Historia Q → Finset (Fin (2 ^ e))) (H : Q → Digest)
    (ha : Activa p (fun t => codificar (semilla t)) (prefijo p n H))
    (hg : (GT (prefijo p n H) ∩ GC (prefijo p n H)).card ≤ g)
    (hm : (vistas H p n).card ≤ m) (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R) :
    promedio (fun G : Tablas H p n => if OmiteOAbandona codificar p n R e q semilla GT GC G.val then (1 : ℚ) else 0) ≤
      riesgo R e q g m := by
  have h := ampliada_condicionada codificar hi p n R e q semilla GT GC H ha.2 he hqM hqR
  have hh := SelectorAdaptativo.hiper_acotada e q g GT GC (prefijo p n H) hg
  have hd := SelectorAdaptativo.delta_acotada R m (prefijo p n H) hm
  unfold riesgo
  linarith only [h, hh, hd]

theorem cota_inicio (codificar : Digest → Q) (hi : Function.Injective codificar)
    (p : Arbol Q Digest X) (n R e q g m : ℕ) (semilla : Historia Q → Digest)
    (GT GC : Historia Q → Finset (Fin (2 ^ e))) (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R)
    (hg : ∀ H, Activa p (fun t => codificar (semilla t)) (prefijo p n H) →
      (GT (prefijo p n H) ∩ GC (prefijo p n H)).card ≤ g)
    (hm : ∀ H, Activa p (fun t => codificar (semilla t)) (prefijo p n H) → (vistas H p n).card ≤ m) :
    promedio (fun H : Q → Digest => if Activa p (fun t => codificar (semilla t)) (prefijo p n H) ∧
      OmiteOAbandona codificar p n R e q semilla GT GC H then (1 : ℚ) else 0) ≤
      riesgo R e q g m * promedio (fun H : Q → Digest =>
        if Activa p (fun t => codificar (semilla t)) (prefijo p n H) then (1 : ℚ) else 0) := by
  apply cota_activada_constante
  intro H ha
  exact cota_condicionada codificar hi p n R e q g m semilla GT GC H ha (hg H ha) (hm H ha) he hqM hqR

theorem cota_union (codificar : Digest → Q) (hi : Function.Injective codificar)
    (p : Arbol Q Digest X) (N R e q g m : ℕ) (semilla : ℕ → Historia Q → Digest)
    (GT GC : ℕ → Historia Q → Finset (Fin (2 ^ e))) (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R)
    (hg : ∀ (n : Fin N) H, Inicia p (fun j t => codificar (semilla j t)) n.val H →
      (GT n.val (prefijo p n.val H) ∩ GC n.val (prefijo p n.val H)).card ≤ g)
    (hm : ∀ (n : Fin N) H, Inicia p (fun j t => codificar (semilla j t)) n.val H → (vistas H p n.val).card ≤ m) :
    promedio (fun H : Q → Digest => if ∃ n : Fin N,
      Inicia p (fun j t => codificar (semilla j t)) n.val H ∧
      OmiteOAbandona codificar p n.val R e q (semilla n.val) (GT n.val) (GC n.val) H then (1 : ℚ) else 0) ≤
      riesgo R e q g m * promedio (fun H : Q → Digest =>
        (numero (fun n : Fin N => Inicia p (fun j t => codificar (semilla j t)) n.val) H : ℚ)) := by
  apply cota_por_activaciones
    (fun (n : Fin N) H => Inicia p (fun j t => codificar (semilla j t)) n.val H)
    (fun (n : Fin N) H => OmiteOAbandona codificar p n.val R e q (semilla n.val) (GT n.val) (GC n.val) H)
    (riesgo R e q g m)
  intro n
  exact cota_inicio codificar hi p n.val R e q g m (semilla n.val) (GT n.val) (GC n.val)
    he hqM hqR (hg n) (hm n)

theorem cota_presupuesto (codificar : Digest → Q) (hi : Function.Injective codificar)
    (p : Arbol Q Digest X) (N R e q g m B : ℕ) (semilla : ℕ → Historia Q → Digest)
    (GT GC : ℕ → Historia Q → Finset (Fin (2 ^ e))) (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R)
    (hg : ∀ (n : Fin N) H, Inicia p (fun j t => codificar (semilla j t)) n.val H →
      (GT n.val (prefijo p n.val H) ∩ GC n.val (prefijo p n.val H)).card ≤ g)
    (hm : ∀ (n : Fin N) H, Inicia p (fun j t => codificar (semilla j t)) n.val H → (vistas H p n.val).card ≤ m)
    (hB : ∀ H : Q → Digest, ((traza H p).map Prod.fst).toFinset.card ≤ B) :
    promedio (fun H : Q → Digest => if ∃ n : Fin N,
      Inicia p (fun j t => codificar (semilla j t)) n.val H ∧
      OmiteOAbandona codificar p n.val R e q (semilla n.val) (GT n.val) (GC n.val) H then (1 : ℚ) else 0) ≤
      riesgo R e q g m * B := by
  apply cota_por_presupuesto
    (fun (n : Fin N) H => Inicia p (fun j t => codificar (semilla j t)) n.val H)
    (fun (n : Fin N) H => OmiteOAbandona codificar p n.val R e q (semilla n.val) (GT n.val) (GC n.val) H)
    (riesgo R e q g m) B (riesgo_no_negativo R e q g m)
  · intro H
    exact (carga_distintas H p N (fun j t => codificar (semilla j t))).trans (hB H)
  · intro n
    exact cota_inicio codificar hi p n.val R e q g m (semilla n.val) (GT n.val) (GC n.val)
      he hqM hqR (hg n) (hm n)

omit [Fintype Q] in
theorem reanclar_preconsulta (codificar : Digest → Q) (p : Arbol Q Digest X) (H : Q → Digest)
    (n R e q : ℕ) (d : Digest) (T : Finset (Fin (2 ^ e)))
    (semilla : ℕ → Historia Q → Digest) (GT GC : ℕ → Historia Q → Finset (Fin (2 ^ e)))
    (hp : codificar d ∈ ((prefijo p n H).map Prod.fst).toFinset)
    (hr : ∀ j, j < n → Activa p (fun _ => codificar d) (prefijo p j H) →
      semilla j (prefijo p j H) = d ∧ T ⊆ GT j (prefijo p j H) ∩ GC j (prefijo p j H))
    (ho : (SelectorAcoplado.salida e q (CadenaMemoria.cinta codificar H R d)).card = q ∧
      SelectorAcoplado.salida e q (CadenaMemoria.cinta codificar H R d) ⊆ T) :
    ∃ j, j < n ∧ Inicia p (fun k t => codificar (semilla k t)) j H ∧
      Omite codificar p j R e q (semilla j) (GT j) (GC j) H := by
  obtain ⟨j, hj, ha⟩ := primera_antes_reutilizacion H p n (codificar d) hp
  obtain ⟨hs, ht⟩ := hr j hj ha
  refine ⟨j, hj, ?_, ?_⟩
  · simpa only [Inicia, Activa, hs] using ha
  · simp only [Omite, muestra, hs]
    exact ⟨ho.1, ho.2.trans ht⟩

omit [DecidableEq Q] [Fintype Q] in
theorem riesgo_512 (k g m : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) :
    riesgo 512 (k + 2) 40 g m <
      (Nat.choose g 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 + (1 : ℚ) / 2 ^ 300 +
        AcoplamientoCadena.error Digest 512 m := by
  have ht := Selector.selector_corte_512 k hk0 hk1
  have hp : 2 ^ (k + 2) = 4 * 2 ^ k := by rw [pow_add]; ring
  have ht' : Selector.probabilidadIncompleta (2 ^ (k + 2)) 512 40 < (1 : ℚ) / 2 ^ 300 := by
    simpa only [hp] using ht
  unfold riesgo
  linarith only [ht']

end Nexus.ROM.SelectorPrimeras
