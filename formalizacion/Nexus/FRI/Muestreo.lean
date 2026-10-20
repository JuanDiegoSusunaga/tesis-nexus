module

public import Nexus.FRI.Torre
public import Nexus.N05.Cotas
import Mathlib.Tactic

/-!
# Lema B y muestreo de recorridos completos

El conjunto G enumera parejas iniciales que pasan todas las ecuaciones de
plegado y la constante final. No se recibe su cardinal como hipótesis:
se deduce del alejamiento del código mediante la recuperación de la torre.
El cociente de cardinales es probabilístico cuando q≤M y la muestra es
uniforme entre los q-subconjuntos, fijado el recorrido completo.
-/

public section
namespace Nexus.FRI

open Polynomial Nexus.N04
variable {K : Type*} [Field K] {m : ℕ}

/-- Ecuaciones que debe pasar cada recorrido, incluida la constante final. -/
@[expose] def Acepta (t : Torre K m) (u : ℕ → K → K) (β : Fin m → K)
    (A : Finset K) (c : K) : Prop :=
  (∀ j : Fin m, ∀ y ∈ recorrido A (j + 1),
    u (j + 1) y = par (u j) (t.raiz j) y + β j * impar (u j) (t.raiz j) y) ∧
  (∀ y ∈ recorrido A m, u m y = c)

@[expose] def Lejano (t : Torre K m) (u : ℕ → K → K) (θ : ℝ) : Prop :=
  ∀ P : Polynomial K, P.natDegree < t.grado 0 →
    θ < (Nexus.distancia (t.dominio 0) (u 0) P.eval : ℝ)

/-- Lema B para parejas: la cota H se deriva del recorrido entero y su constante final. -/
theorem lema_B_muestreo [DecidableEq K] (t : Torre K m) (hm : 0 < m)
    (u : ℕ → K → K) (θ : ℚ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * (θ : ℝ)) * (t.dominio (j + 1)).card) (q : ℕ)
    (_hq : q ≤ (t.dominio 1).card) :
    ∃ E : Fin m → Finset K,
      (∀ j, (E j).card ≤ (t.dominio (j + 1)).card) ∧
      ∀ β : Fin m → K, (∀ j, β j ∉ E j) →
      ∀ (G : Finset K) (c : K), G ⊆ t.dominio 1 →
        Acepta t u β (elevar (t.raiz 0) G) c → Lejano t u θ →
        ((((t.dominio 1).powersetCard q).filter (fun S => S ⊆ G)).card : ℚ) /
          ((t.dominio 1).powersetCard q).card ≤ Nexus.N05.H (t.dominio 1).card q θ := by
  obtain ⟨E, hE, hB⟩ := lema_B t u (θ : ℝ) (by exact_mod_cast hθ) h2 hmargin
  refine ⟨E, hE, ?_⟩
  intro β hβ G c hG hacc hfar
  have hA : elevar (t.raiz 0) G ⊆ t.dominio 0 := by
    rw [t.enlace 0 hm]
    exact elevar_mono _ hG
  have hc := hB β hβ (elevar (t.raiz 0) G) c hA hacc.1 hacc.2 hfar
  rw [cardinal_elevar G (t.raiz 0)
    (fun y hy => t.cuadrado 0 hm y (hG hy))
    (fun y hy => t.noCero 0 hm y (hG hy)) h2,
    t.enlace 0 hm, cardinal_elevar _ _ (t.cuadrado 0 hm) (t.noCero 0 hm) h2] at hc
  push_cast at hc
  have hbad : (θ : ℝ) * (t.dominio 1).card ≤ (t.dominio 1).card - (G.card : ℝ) := by
    nlinarith
  apply Nexus.N05.cota_omision_radio (t.dominio 1) G q θ hG
  rw [Nat.cast_sub (Finset.card_le_card hG)]
  exact_mod_cast hbad

/-- La misma consulta sin reemplazo satisface la cota exponencial. -/
theorem lema_B_exponencial [DecidableEq K] (t : Torre K m) (hm : 0 < m)
    (u : ℕ → K → K) (θ : ℚ) (hθ : 0 ≤ θ) (hθ1 : θ ≤ 1) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * (θ : ℝ)) * (t.dominio (j + 1)).card) (q : ℕ)
    (hq : q ≤ (t.dominio 1).card) :
    ∃ E : Fin m → Finset K,
      (∀ j, (E j).card ≤ (t.dominio (j + 1)).card) ∧
      ∀ β : Fin m → K, (∀ j, β j ∉ E j) →
      ∀ (G : Finset K) (c : K), G ⊆ t.dominio 1 →
        Acepta t u β (elevar (t.raiz 0) G) c → Lejano t u θ →
        ((((t.dominio 1).powersetCard q).filter (fun S => S ⊆ G)).card : ℚ) /
          ((t.dominio 1).powersetCard q).card ≤ (1 - θ) ^ q := by
  obtain ⟨E, hE, hsample⟩ := lema_B_muestreo t hm u θ hθ h2 hmargin q hq
  refine ⟨E, hE, ?_⟩
  intro β hβ G c hG hacc hfar
  exact (hsample β hβ G c hG hacc hfar).trans (Nexus.N05.H_le_potencia _ q θ
    (dominios_positivos t h2 1 (by omega)) hq hθ hθ1)

end Nexus.FRI
