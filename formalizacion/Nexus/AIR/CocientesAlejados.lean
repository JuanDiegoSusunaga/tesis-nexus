module

public import Nexus.AIR.ComposicionAlejada
import Mathlib.Tactic

public section
namespace Nexus.AIR.Contraejemplo

open Polynomial
variable {K : Type*} [Field K]

/-- Anulador de las transiciones: se excluyen exactamente las dos últimas filas. -/
@[expose] noncomputable def anuladorTransiciones (T : ℕ) (g : K) : Polynomial K := by
  classical
  exact Nexus.AIR.anulador (((Nexus.AIR.dominio g T).erase (g ^ (T - 1))).erase (g ^ (T - 2)))

theorem ultima_fila_pertenece (T : ℕ) (hT : 0 < T) (g : K) :
    g ^ (T - 1) ∈ Nexus.AIR.dominio g T := by
  classical
  exact Finset.mem_image.mpr ⟨T - 1, Finset.mem_range.mpr (by omega), rfl⟩

theorem penultima_fila_pertenece (T : ℕ) (hT : 2 ≤ T) (g : K) :
    g ^ (T - 2) ∈ Nexus.AIR.dominio g T := by
  classical
  exact Finset.mem_image.mpr ⟨T - 2, Finset.mem_range.mpr (by omega), rfl⟩

theorem filas_finales_distintas (T : ℕ) (hT : 2 ≤ T) (g : K) (hg : IsPrimitiveRoot g T) :
    g ^ (T - 2) ≠ g ^ (T - 1) := by
  intro he
  have h := hg.pow_inj (show T - 2 < T by omega) (show T - 1 < T by omega) he
  omega

theorem grado_anulador_transiciones (T : ℕ) (hT : 2 ≤ T) (g : K)
    (hg : IsPrimitiveRoot g T) : (anuladorTransiciones T g).natDegree = T - 2 := by
  classical
  rw [anuladorTransiciones, grado_anulador,
    Finset.card_erase_of_mem (Finset.mem_erase.mpr
      ⟨filas_finales_distintas T hT g hg, penultima_fila_pertenece T hT g⟩),
    Finset.card_erase_of_mem (ultima_fila_pertenece T (by omega) g),
    Nexus.AIR.cardinal_dominio T g hg]
  omega

theorem anulador_transiciones_monico (T : ℕ) (g : K) :
    (anuladorTransiciones T g).Monic := anulador_monico _

theorem transicion_divisible (T : ℕ) (hT : 3 ≤ T) (g : K) (hg : IsPrimitiveRoot g T)
    (F : Polynomial K) (s o : K) (hv : Nexus.AIR.Valida g T F s o) :
    anuladorTransiciones T g ∣ Nexus.AIR.transicion g F := by
  classical
  apply (Nexus.AIR.anulador_dvd_iff _ _).mpr
  intro x hx
  obtain ⟨hne2, hx⟩ := Finset.mem_erase.mp hx
  obtain ⟨hne1, hx⟩ := Finset.mem_erase.mp hx
  exact (Nexus.AIR.transiciones_por_indices T g F hT hg).mpr hv.2.2 x hx hne1 hne2

theorem grado_cociente_transicion (T : ℕ) (hT : 3 ≤ T) (g : K) (hg : IsPrimitiveRoot g T)
    (f : Polynomial K) (lambda : K) (hf : f.natDegree < T) (hl : lambda ≠ 0)
    (h2 : (2 : K) ≠ 0) :
    (Nexus.AIR.transicion g (perturbada T f lambda) / anuladorTransiciones T g).natDegree = T + 2 := by
  rw [← divByMonic_eq_div _ (anulador_transiciones_monico T g),
    natDegree_divByMonic _ (anulador_transiciones_monico T g),
    grado_transicion_exacto T (by omega) g hg.pow_eq_one f lambda hf hl h2,
    grado_anulador_transiciones T (by omega) g hg]
  omega

/-- Identidad de los factores del denominador completo, con raíces distintas. -/
theorem factorizacion_denominador (T : ℕ) (hT : 2 ≤ T) (g : K) (hg : IsPrimitiveRoot g T) :
    anuladorTransiciones T g * (X - C (g ^ (T - 1))) * (X - C (g ^ (T - 2))) =
      Nexus.AIR.denominador (K := K) T := by
  classical
  rw [← Nexus.AIR.anulador_dominio T g (by omega) hg]
  have h1 := Finset.mul_prod_erase (Nexus.AIR.dominio g T)
    (fun x => (X - C x : Polynomial K)) (ultima_fila_pertenece T (by omega) g)
  have h2 := Finset.mul_prod_erase ((Nexus.AIR.dominio g T).erase (g ^ (T - 1)))
    (fun x => (X - C x : Polynomial K))
    (Finset.mem_erase.mpr ⟨filas_finales_distintas T hT g hg, penultima_fila_pertenece T hT g⟩)
  change _ = ∏ x ∈ Nexus.AIR.dominio g T, (X - C x)
  rw [← h1, ← h2]
  unfold anuladorTransiciones Nexus.AIR.anulador
  ring

theorem cociente_transicion_equivalente (T : ℕ) (hT : 3 ≤ T) (g : K)
    (hg : IsPrimitiveRoot g T) (F : Polynomial K) (s o : K)
    (hv : Nexus.AIR.Valida g T F s o) :
    Nexus.AIR.numeradorTransicion g F (g ^ (T - 1)) (g ^ (T - 2)) /
        Nexus.AIR.denominador T = Nexus.AIR.transicion g F / anuladorTransiciones T g := by
  have hd := transicion_divisible T hT g hg F s o hv
  obtain ⟨P, hP⟩ := hd
  have hz : anuladorTransiciones T g ≠ 0 := (anulador_transiciones_monico T g).ne_zero
  have hD : (Nexus.AIR.denominador T : Polynomial K) ≠ 0 := by
    exact (show (Nexus.AIR.denominador T : Polynomial K).Monic from
      by simpa [Nexus.AIR.denominador] using monic_X_pow_sub_C (1 : K) (by omega)).ne_zero
  have hN : Nexus.AIR.numeradorTransicion g F (g ^ (T - 1)) (g ^ (T - 2)) =
      Nexus.AIR.denominador T * P := by
    unfold Nexus.AIR.numeradorTransicion
    rw [hP, ← factorizacion_denominador T (by omega) g hg]
    ring
  rw [hN, hP, mul_div_cancel_left₀ _ hD, mul_div_cancel_left₀ _ hz]

end Nexus.AIR.Contraejemplo
