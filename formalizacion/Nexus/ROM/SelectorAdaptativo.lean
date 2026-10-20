module

public import Nexus.ROM.SelectorPrefijo
import Mathlib.Tactic

/-!
# Transferencia del selector después de una exploración adaptativa

La semilla y los conjuntos buenos pueden elegirse usando todo el prefijo
observado. Se suman todas sus fibras con el peso correcto. Las primeras
direcciones ya consultadas se contabilizan mediante un evento explícito;
no se supone que su probabilidad sea pequeña.
-/

public section
namespace Nexus.ROM.SelectorAdaptativo

open Nexus.Bytes Nexus.Merkle Nexus.N06 LeyArbol PrefijosGlobales ObservacionesPrefijo SelectorPrefijo

variable {Q X : Type} [DecidableEq Q] [Fintype Q]
attribute [local instance] Classical.propDecidable
set_option exponentiation.threshold 1024

theorem tau_no_negativa (M R q : ℕ) : 0 ≤ Selector.probabilidadIncompleta M R q := by
  unfold Selector.probabilidadIncompleta
  positivity

omit [DecidableEq Q] [Fintype Q] in
theorem hiper_acotada (e q g : ℕ) (GT GC : Historia Q → Finset (Fin (2 ^ e))) (t : Historia Q)
    (hg : (GT t ∩ GC t).card ≤ g) :
    hiper e q GT GC t ≤ (Nat.choose g q : ℚ) / Nat.choose (2 ^ e) q := by
  unfold hiper
  apply div_le_div_of_nonneg_right _ (by positivity)
  exact_mod_cast Nat.choose_le_choose q hg

omit [Fintype Q] in
theorem delta_acotada (R m : ℕ) (t : Historia Q) (hm : (t.map Prod.fst).toFinset.card ≤ m) :
    delta R t ≤ AcoplamientoCadena.error Digest R m := by
  unfold delta AcoplamientoCadena.error
  apply min_le_min_left
  apply div_le_div_of_nonneg_right _ (by positivity)
  exact_mod_cast Nat.mul_le_mul_left R (by omega : (t.map Prod.fst).toFinset.card + R + 1 ≤ m + R + 1)

theorem omision_global (codificar : Digest → Q) (hi : Function.Injective codificar)
    (p : Arbol Q Digest X) (n R e q : ℕ) (semilla : Historia Q → Digest)
    (GT GC : Historia Q → Finset (Fin (2 ^ e))) (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R) :
    promedio (fun H : Q → Digest => if Omite codificar p n R e q semilla GT GC H then (1 : ℚ) else 0) ≤
      promedio (fun H : Q → Digest => hiper e q GT GC (prefijo p n H) + delta R (prefijo p n H)) +
        promedio (fun H : Q → Digest => if Preconsultada codificar semilla (prefijo p n H) then 1 else 0) := by
  apply cota_con_pasado_malo p n (Omite codificar p n R e q semilla GT GC)
    (Preconsultada codificar semilla) (fun t => hiper e q GT GC t + delta R t)
  · intro t
    exact add_nonneg (hiper_no_negativa e q GT GC t) (delta_no_negativa R t)
  · intro H hf
    exact omision_condicionada codificar hi p n R e q semilla GT GC H hf he hqM hqR

theorem ampliada_global (codificar : Digest → Q) (hi : Function.Injective codificar)
    (p : Arbol Q Digest X) (n R e q : ℕ) (semilla : Historia Q → Digest)
    (GT GC : Historia Q → Finset (Fin (2 ^ e))) (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R) :
    promedio (fun H : Q → Digest => if OmiteOAbandona codificar p n R e q semilla GT GC H then (1 : ℚ) else 0) ≤
      promedio (fun H : Q → Digest => hiper e q GT GC (prefijo p n H) +
        Selector.probabilidadIncompleta (2 ^ e) R q + delta R (prefijo p n H)) +
        promedio (fun H : Q → Digest => if Preconsultada codificar semilla (prefijo p n H) then 1 else 0) := by
  apply cota_con_pasado_malo p n (OmiteOAbandona codificar p n R e q semilla GT GC)
    (Preconsultada codificar semilla)
    (fun t => hiper e q GT GC t + Selector.probabilidadIncompleta (2 ^ e) R q + delta R t)
  · intro t
    exact add_nonneg (add_nonneg (hiper_no_negativa e q GT GC t) (tau_no_negativa _ _ _))
      (delta_no_negativa R t)
  · intro H hf
    exact ampliada_condicionada codificar hi p n R e q semilla GT GC H hf he hqM hqR

theorem cota_uniforme (codificar : Digest → Q) (hi : Function.Injective codificar)
    (p : Arbol Q Digest X) (n R e q g m : ℕ) (semilla : Historia Q → Digest)
    (GT GC : Historia Q → Finset (Fin (2 ^ e))) (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R)
    (hg : ∀ H, (GT (prefijo p n H) ∩ GC (prefijo p n H)).card ≤ g)
    (hm : ∀ H, (vistas H p n).card ≤ m) :
    promedio (fun H : Q → Digest => if OmiteOAbandona codificar p n R e q semilla GT GC H then (1 : ℚ) else 0) ≤
      (Nat.choose g q : ℚ) / Nat.choose (2 ^ e) q + Selector.probabilidadIncompleta (2 ^ e) R q +
        AcoplamientoCadena.error Digest R m +
        promedio (fun H : Q → Digest => if Preconsultada codificar semilla (prefijo p n H) then 1 else 0) := by
  have h := ampliada_global codificar hi p n R e q semilla GT GC he hqM hqR
  have ht : promedio (fun H : Q → Digest => hiper e q GT GC (prefijo p n H) +
      Selector.probabilidadIncompleta (2 ^ e) R q + delta R (prefijo p n H)) ≤
      (Nat.choose g q : ℚ) / Nat.choose (2 ^ e) q + Selector.probabilidadIncompleta (2 ^ e) R q +
        AcoplamientoCadena.error Digest R m := by
    calc
      _ ≤ promedio (fun _ : Q → Digest => (Nat.choose g q : ℚ) / Nat.choose (2 ^ e) q +
          Selector.probabilidadIncompleta (2 ^ e) R q + AcoplamientoCadena.error Digest R m) := by
        apply promedio_monotono
        intro H
        have hh := hiper_acotada e q g GT GC (prefijo p n H) (hg H)
        have hd := delta_acotada R m (prefijo p n H) (hm H)
        linarith only [hh, hd]
      _ = _ := promedio_constante _
  linarith

theorem cota_512 (codificar : Digest → Q) (hi : Function.Injective codificar)
    (p : Arbol Q Digest X) (n k g m : ℕ) (semilla : Historia Q → Digest)
    (GT GC : Historia Q → Finset (Fin (2 ^ (k + 2)))) (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hg : ∀ H, (GT (prefijo p n H) ∩ GC (prefijo p n H)).card ≤ g)
    (hm : ∀ H, (vistas H p n).card ≤ m) :
    promedio (fun H : Q → Digest => if OmiteOAbandona codificar p n 512 (k + 2) 40 semilla GT GC H then (1 : ℚ) else 0) <
      (Nat.choose g 40 : ℚ) / Nat.choose (2 ^ (k + 2)) 40 + (1 : ℚ) / 2 ^ 300 +
        AcoplamientoCadena.error Digest 512 m +
        promedio (fun H : Q → Digest => if Preconsultada codificar semilla (prefijo p n H) then 1 else 0) := by
  have hq : 40 ≤ 2 ^ (k + 2) := by
    have hp : 2 ^ 6 ≤ 2 ^ (k + 2) := Nat.pow_le_pow_right (by decide) (by omega)
    norm_num at hp
    omega
  have h := cota_uniforme codificar hi p n 512 (k + 2) 40 g m semilla GT GC (by omega) hq (by decide) hg hm
  have ht := Selector.selector_corte_512 k hk0 hk1
  have hp : 2 ^ (k + 2) = 4 * 2 ^ k := by rw [pow_add]; ring
  have ht' : Selector.probabilidadIncompleta (2 ^ (k + 2)) 512 40 < (1 : ℚ) / 2 ^ 300 := by
    simpa only [hp] using ht
  linarith

end Nexus.ROM.SelectorAdaptativo
