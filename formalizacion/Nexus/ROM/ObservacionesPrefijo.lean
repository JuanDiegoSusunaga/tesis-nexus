module

public import Nexus.ROM.ContinuacionPrefijo
public import Nexus.ROM.ParticionObservada
import Mathlib.Tactic

/-!
# Partición por los prefijos que el programa puede observar

Solo se enumeran pasados efectivamente realizables. Cada uno se pondera por
su masa exacta; distintas transcripciones pueden tener pesos diferentes.
-/

public section
namespace Nexus.ROM.ObservacionesPrefijo

open Nexus.N06 LeyArbol PrefijosGlobales ParticionObservada
open scoped BigOperators

variable {Q A R : Type} [DecidableEq Q] [DecidableEq A] [Fintype Q] [Fintype A]

abbrev prefijo (p : Arbol Q A R) (n : ℕ) (H : Q → A) : List (Q × A) := (traza H p).take n

@[expose] noncomputable def posibles (p : Arbol Q A R) (n : ℕ) : Finset (List (Q × A)) :=
  Finset.univ.image (prefijo p n)

@[expose] noncomputable def observar (p : Arbol Q A R) (n : ℕ) (H : Q → A) : posibles p n :=
  ⟨prefijo p n H, Finset.mem_image.mpr ⟨H, Finset.mem_univ _, rfl⟩⟩

@[expose] noncomputable def representante (p : Arbol Q A R) (n : ℕ) (t : posibles p n) : Q → A :=
  Classical.choose (Finset.mem_image.mp t.property)

theorem realiza_representante (p : Arbol Q A R) (n : ℕ) (t : posibles p n) :
    prefijo p n (representante p n t) = t.val :=
  (Classical.choose_spec (Finset.mem_image.mp t.property)).2

omit [DecidableEq A] [Fintype Q] [Fintype A] in
theorem vistas_por_prefijo (H G : Q → A) (p : Arbol Q A R) (n : ℕ)
    (he : prefijo p n G = prefijo p n H) : vistas G p n = vistas H p n := by
  exact congrArg (fun xs => (xs.map Prod.fst).toFinset) he

@[expose] noncomputable def equivalencia_fibra (p : Arbol Q A R) (n : ℕ) (t : posibles p n) :
    Fibra (observar p n) t ≃ Tablas (representante p n t) p n where
  toFun G := ⟨G.val, by
    change prefijo p n G.val = prefijo p n (representante p n t)
    rw [realiza_representante]
    exact congrArg (fun z : posibles p n => z.val) G.property⟩
  invFun G := ⟨G.val, by
    apply Subtype.ext
    change prefijo p n G.val = t.val
    exact G.property.trans (realiza_representante p n t)⟩
  left_inv _ := rfl
  right_inv _ := rfl

theorem media_fibra (p : Arbol Q A R) (n : ℕ) (t : posibles p n) (f : (Q → A) → ℚ) :
    promedio (fun G : Fibra (observar p n) t => f G.val) =
      promedio (fun G : Tablas (representante p n t) p n => f G.val) :=
  PromediosCompletaciones.media_equivalencia (equivalencia_fibra p n t) (fun G => f G.val)

theorem masa_prefijo [Nonempty A] (p : Arbol Q A R) (n : ℕ) (t : posibles p n) :
    masa (observar p n) t = 1 / (Fintype.card A : ℚ) ^ (vistas (representante p n t) p n).card := by
  unfold masa
  rw [Fintype.card_congr (equivalencia_fibra p n t)]
  exact probabilidad_prefijo _ _ _

theorem esperanza_prefijos (p : Arbol Q A R) (n : ℕ) (f : (Q → A) → ℚ) :
    promedio f = ∑ t : posibles p n, masa (observar p n) t *
      promedio (fun G : Tablas (representante p n t) p n => f G.val) := by
  rw [esperanza_total (observar p n) f]
  simp_rw [media_fibra]

theorem cota_por_prefijos (p : Arbol Q A R) (n : ℕ) (f : (Q → A) → ℚ)
    (rho : List (Q × A) → ℚ)
    (h : ∀ H, promedio (fun G : Tablas H p n => f G.val) ≤ rho (prefijo p n H)) :
    promedio f ≤ promedio (fun H => rho (prefijo p n H)) := by
  apply cota_por_fibras (observar p n) f (fun t => rho t.val)
  intro t _
  rw [media_fibra]
  simpa only [realiza_representante] using h (representante p n t)

theorem cota_con_pasado_malo (p : Arbol Q A R) (n : ℕ) (E : (Q → A) → Prop) [DecidablePred E]
    (B : List (Q × A) → Prop) [DecidablePred B] (rho : List (Q × A) → ℚ)
    (h0 : ∀ t, 0 ≤ rho t)
    (h : ∀ H, ¬ B (prefijo p n H) →
      promedio (fun G : Tablas H p n => if E G.val then (1 : ℚ) else 0) ≤ rho (prefijo p n H)) :
    promedio (fun H => if E H then (1 : ℚ) else 0) ≤
      promedio (fun H => rho (prefijo p n H)) +
        promedio (fun H => if B (prefijo p n H) then 1 else 0) := by
  apply cota_con_excepcion (observar p n) E (fun t => B t.val) (fun t => rho t.val)
    (fun t => h0 t.val)
  intro t _ hb
  rw [media_fibra p n t (fun G => if E G then (1 : ℚ) else 0)]
  have hb' : ¬ B (prefijo p n (representante p n t)) := by
    simpa only [realiza_representante] using hb
  simpa only [realiza_representante] using h (representante p n t) hb'

end Nexus.ROM.ObservacionesPrefijo
