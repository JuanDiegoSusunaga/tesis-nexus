module

public import Nexus.ROM.SelectorAcoplado
public import Nexus.ROM.ObservacionesPrefijo
import Mathlib.Tactic

/-!
# Selector cuyos parámetros dependen del pasado observado

La semilla y los dos conjuntos buenos son funciones arbitrarias del mismo
prefijo efectivo. Se congelan dentro de su fibra antes de aplicar la cota
de acoplamiento, sin seleccionar una transcripción futura favorable.
-/

public section
namespace Nexus.ROM.SelectorPrefijo

open Nexus.Bytes Nexus.Merkle Nexus.N06 LeyArbol PrefijosGlobales ObservacionesPrefijo

variable {Q X : Type} [DecidableEq Q] [Fintype Q]
attribute [local instance] Classical.propDecidable

abbrev Historia (Q : Type) := List (Q × Digest)

abbrev muestra (codificar : Digest → Q) (p : Arbol Q Digest X) (n R e q : ℕ)
    (semilla : Historia Q → Digest) (H : Q → Digest) : Finset (Fin (2 ^ e)) :=
  SelectorAcoplado.salida e q (CadenaMemoria.cinta codificar H R (semilla (prefijo p n H)))

abbrev Preconsultada (codificar : Digest → Q) (semilla : Historia Q → Digest) (t : Historia Q) : Prop :=
  codificar (semilla t) ∈ (t.map Prod.fst).toFinset

abbrev Omite (codificar : Digest → Q) (p : Arbol Q Digest X) (n R e q : ℕ)
    (semilla : Historia Q → Digest) (GT GC : Historia Q → Finset (Fin (2 ^ e))) (H : Q → Digest) : Prop :=
  (muestra codificar p n R e q semilla H).card = q ∧
    muestra codificar p n R e q semilla H ⊆ GT (prefijo p n H) ∩ GC (prefijo p n H)

abbrev OmiteOAbandona (codificar : Digest → Q) (p : Arbol Q Digest X) (n R e q : ℕ)
    (semilla : Historia Q → Digest) (GT GC : Historia Q → Finset (Fin (2 ^ e))) (H : Q → Digest) : Prop :=
  (muestra codificar p n R e q semilla H).card < q ∨ Omite codificar p n R e q semilla GT GC H

@[expose] noncomputable def hiper (e q : ℕ) (GT GC : Historia Q → Finset (Fin (2 ^ e)))
    (t : Historia Q) : ℚ := (Nat.choose (GT t ∩ GC t).card q : ℚ) / Nat.choose (2 ^ e) q

@[expose] noncomputable def delta (R : ℕ) (t : Historia Q) : ℚ :=
  AcoplamientoCadena.error Digest R ((t.map Prod.fst).toFinset.card)

omit [Fintype Q] in
theorem preconsultada_iff (codificar : Digest → Q) (semilla : Historia Q → Digest)
    (p : Arbol Q Digest X) (n : ℕ) (H : Q → Digest) :
    Preconsultada codificar semilla (prefijo p n H) ↔ codificar (semilla (prefijo p n H)) ∈ vistas H p n := Iff.rfl

omit [DecidableEq Q] [Fintype Q] in
theorem hiper_no_negativa (e q : ℕ) (GT GC : Historia Q → Finset (Fin (2 ^ e))) (t : Historia Q) :
    0 ≤ hiper e q GT GC t := by unfold hiper; positivity

omit [Fintype Q] in
theorem delta_no_negativa (R : ℕ) (t : Historia Q) : 0 ≤ delta R t :=
  AcoplamientoCadena.error_no_negativo _ _

theorem omision_condicionada (codificar : Digest → Q) (hi : Function.Injective codificar)
    (p : Arbol Q Digest X) (n R e q : ℕ) (semilla : Historia Q → Digest)
    (GT GC : Historia Q → Finset (Fin (2 ^ e))) (H : Q → Digest)
    (hf : ¬ Preconsultada codificar semilla (prefijo p n H))
    (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R) :
    promedio (fun G : Tablas H p n => if Omite codificar p n R e q semilla GT GC G.val then (1 : ℚ) else 0) ≤
      hiper e q GT GC (prefijo p n H) + delta R (prefijo p n H) := by
  unfold Omite muestra prefijo
  rw [ContinuacionPrefijo.ley_tabla_y_pasado H p n
    (fun t G => if (SelectorAcoplado.salida e q (CadenaMemoria.cinta codificar G R (semilla t))).card = q ∧
      SelectorAcoplado.salida e q (CadenaMemoria.cinta codificar G R (semilla t)) ⊆ GT t ∩ GC t then (1 : ℚ) else 0)]
  exact SelectorAcoplado.omision_rom codificar hi R (semilla (prefijo p n H)) (vistas H p n) H
    hf e q he hqM hqR (GT (prefijo p n H) ∩ GC (prefijo p n H))

theorem ampliada_condicionada (codificar : Digest → Q) (hi : Function.Injective codificar)
    (p : Arbol Q Digest X) (n R e q : ℕ) (semilla : Historia Q → Digest)
    (GT GC : Historia Q → Finset (Fin (2 ^ e))) (H : Q → Digest)
    (hf : ¬ Preconsultada codificar semilla (prefijo p n H))
    (he : e ≤ 64) (hqM : q ≤ 2 ^ e) (hqR : q ≤ R) :
    promedio (fun G : Tablas H p n => if OmiteOAbandona codificar p n R e q semilla GT GC G.val then (1 : ℚ) else 0) ≤
      hiper e q GT GC (prefijo p n H) + Selector.probabilidadIncompleta (2 ^ e) R q + delta R (prefijo p n H) := by
  unfold OmiteOAbandona Omite muestra prefijo
  rw [ContinuacionPrefijo.ley_tabla_y_pasado H p n
    (fun t G => if (SelectorAcoplado.salida e q (CadenaMemoria.cinta codificar G R (semilla t))).card < q ∨
      ((SelectorAcoplado.salida e q (CadenaMemoria.cinta codificar G R (semilla t))).card = q ∧
        SelectorAcoplado.salida e q (CadenaMemoria.cinta codificar G R (semilla t)) ⊆ GT t ∩ GC t) then (1 : ℚ) else 0)]
  exact SelectorAcoplado.omision_o_abandono_rom codificar hi R (semilla (prefijo p n H)) (vistas H p n) H
    hf e q he hqM hqR (GT (prefijo p n H) ∩ GC (prefijo p n H))

end Nexus.ROM.SelectorPrefijo
