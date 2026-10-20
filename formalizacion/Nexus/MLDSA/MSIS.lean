module

public import Nexus.MLDSA.Cortos
public import Nexus.Cripto.Probabilidad
public import Mathlib.Data.Matrix.Mul
import Mathlib.Tactic

public section
namespace Nexus.MLDSA

open scoped BigOperators ENNReal Matrix

/-- Norma de los representantes enteros, antes de volver a centrar módulo q. -/
@[expose] noncomputable def normaEnteraVector {r : ℕ} (x : Fin r → R) : ℕ :=
  normaInfinito (fun i : Fin r × Fin n => coeficiente (x i.1) i.2)

@[expose] noncomputable def reduceVector {r : ℕ} (x : Fin r → R) : Vector r :=
  fun j => reduccion (x j)

@[expose] noncomputable def levantaVector {r : ℕ} (x : Vector r) : Fin r → R :=
  fun j => levanta (x j)

theorem reduce_levanta_vector {r : ℕ} (x : Vector r) : reduceVector (levantaVector x) = x := by
  funext j
  exact reduccion_levanta (x j)

theorem norma_levanta_vector {r : ℕ} (x : Vector r) :
    normaEnteraVector (levantaVector x) = normaVector x := by
  unfold normaEnteraVector normaVector
  congr 1
  funext i
  exact coeficiente_levanta (x i.1) i.2

theorem norma_entera_iff {r : ℕ} (x : Fin r → R) (B : ℕ) :
    normaEnteraVector x ≤ B ↔ ∀ j i, (coeficiente (x j) i).natAbs ≤ B := by
  simp only [normaEnteraVector, norma_le_iff, Prod.forall]

theorem centrar_no_aumenta (w : R) (i : Fin n) :
    (centrado (reduccion w) i).natAbs ≤ (coeficiente w i).natAbs := by
  apply ZMod.natAbs_min_of_le_div_two q
  · exact (centrado_reduce (reduccion w) i).trans (coeficiente_reduccion w i)
  · exact ZMod.natAbs_valMinAbs_le (coeficiente (reduccion w) i)

theorem norma_reduccion_vector {r : ℕ} (x : Fin r → R) :
    normaVector (reduceVector x) ≤ normaEnteraVector x := by
  apply (norma_vector_iff _ _).mpr
  intro j i
  exact (centrar_no_aumenta (x j) i).trans (coeficiente_le_norma
    (fun a : Fin r × Fin n => coeficiente (x a.1) a.2) (j, i))

theorem norma_resta_entera {r : ℕ} (x y : Fin r → R) (B C : ℕ)
    (hx : normaEnteraVector x ≤ B) (hy : normaEnteraVector y ≤ C) :
    normaEnteraVector (x - y) ≤ B + C := by
  apply (norma_entera_iff _ _).mpr
  intro j i
  change (coeficiente (x j - y j) i).natAbs ≤ _
  rw [coeficiente_resta]
  exact (Int.natAbs_sub_le _ _).trans (Nat.add_le_add
    ((norma_entera_iff x B).mp hx j i) ((norma_entera_iff y C).mp hy j i))

theorem reduccion_resta_vector {r : ℕ} (x y : Fin r → R) :
    reduceVector (x - y) = reduceVector x - reduceVector y := by
  funext j
  exact map_sub reduccion (x j) (y j)

theorem norma_resta_modular {r : ℕ} (x y : Vector r) (B C : ℕ)
    (hx : normaVector x ≤ B) (hy : normaVector y ≤ C) :
    normaVector (x - y) ≤ B + C := by
  have h := norma_reduccion_vector (levantaVector x - levantaVector y)
  rw [reduccion_resta_vector, reduce_levanta_vector, reduce_levanta_vector] at h
  apply h.trans
  apply norma_resta_entera _ _ B C
  · simpa only [norma_levanta_vector] using hx
  · simpa only [norma_levanta_vector] using hy

/-- Relación MSIS: no nulidad modular, ecuación y norma centrada, en dimensiones fijas. -/
@[expose] def SolucionMSIS {k r : ℕ} (A : Matriz k r) (B : ℕ) (z : Vector r) : Prop :=
  z ≠ 0 ∧ A *ᵥ z = 0 ∧ normaVector z ≤ B

theorem msis_no_trivial {k r : ℕ} (A : Matriz k r) (B : ℕ) : ¬ SolucionMSIS A B 0 := by
  intro h
  exact h.1 rfl

theorem msis_mayor_cota {k r : ℕ} (A : Matriz k r) (B C : ℕ) (hBC : B ≤ C)
    (z : Vector r) (hz : SolucionMSIS A B z) : SolucionMSIS A C z :=
  ⟨hz.1, hz.2.1, hz.2.2.trans hBC⟩

/-- Lema 6.1 concretado en Rq y en los representantes enteros construidos. -/
theorem diferencia_preimagenes_concreta {k r : ℕ} (A : Matriz k r) (x y : Vector r) (L : ℕ)
    (hxy : x ≠ y) (hA : A *ᵥ x = A *ᵥ y)
    (hx : normaVector x ≤ L) (hy : normaVector y ≤ L) :
    let z := levantaVector x - levantaVector y
    reduceVector z ≠ 0 ∧ A *ᵥ reduceVector z = 0 ∧
      normaEnteraVector z ≤ 2 * L ∧ SolucionMSIS A (2 * L) (x - y) := by
  have hz : reduceVector (levantaVector x - levantaVector y) = x - y := by
    rw [reduccion_resta_vector, reduce_levanta_vector, reduce_levanta_vector]
  have h0 : x - y ≠ 0 := sub_ne_zero.mpr hxy
  have hker : A *ᵥ (x - y) = 0 := by rw [Matrix.mulVec_sub, hA, sub_self]
  have hnorm : normaEnteraVector (levantaVector x - levantaVector y) ≤ 2 * L := by
    simpa only [two_mul] using norma_resta_entera _ _ L L
      (by simpa only [norma_levanta_vector] using hx)
      (by simpa only [norma_levanta_vector] using hy)
  refine ⟨hz ▸ h0, hz ▸ hker, hnorm, h0, hker, ?_⟩
  simpa only [two_mul] using norma_resta_modular x y L L hx hy

/-- La misma extracción conserva los representantes enteros dados, aunque no estén centrados. -/
theorem diferencia_representantes_dados {k r : ℕ} (A : Matriz k r) (x y : Fin r → R) (L : ℕ)
    (hxy : reduceVector x ≠ reduceVector y) (hA : A *ᵥ reduceVector x = A *ᵥ reduceVector y)
    (hx : normaEnteraVector x ≤ L) (hy : normaEnteraVector y ≤ L) :
    reduceVector (x - y) ≠ 0 ∧ A *ᵥ reduceVector (x - y) = 0 ∧
      normaEnteraVector (x - y) ≤ 2 * L ∧ SolucionMSIS A (2 * L) (reduceVector (x - y)) := by
  have h0 : reduceVector (x - y) ≠ 0 := by
    rw [reduccion_resta_vector]
    exact sub_ne_zero.mpr hxy
  have hker : A *ᵥ reduceVector (x - y) = 0 := by
    rw [reduccion_resta_vector, Matrix.mulVec_sub, hA, sub_self]
  have hn : normaEnteraVector (x - y) ≤ 2 * L := by
    simpa only [two_mul] using norma_resta_entera x y L L hx hy
  exact ⟨h0, hker, hn, h0, hker, (norma_reduccion_vector (x - y)).trans hn⟩

/-- Experimento de búsqueda con matriz uniforme; el algoritmo recibe solo la instancia. -/
@[expose] noncomputable def ensayoMSIS (k r : ℕ)
    (buscador : Matriz k r → PMF (Vector r)) : PMF (Matriz k r × Vector r) :=
  (Nexus.Cripto.uniforme (Matriz k r)).bind
    (fun A => (buscador A).map (fun z => (A, z)))

@[expose] noncomputable def ventajaMSIS (k r B : ℕ)
    (buscador : Matriz k r → PMF (Vector r)) : ℝ≥0∞ :=
  Nexus.Cripto.probabilidad (ensayoMSIS k r buscador) (fun az => SolucionMSIS az.1 B az.2)

theorem ventaja_msis_le_uno (k r B : ℕ) (buscador : Matriz k r → PMF (Vector r)) :
    ventajaMSIS k r B buscador ≤ 1 := Nexus.Cripto.probabilidad_le_uno _ _

theorem ventaja_msis_monotona (k r B C : ℕ) (hBC : B ≤ C)
    (buscador : Matriz k r → PMF (Vector r)) :
    ventajaMSIS k r B buscador ≤ ventajaMSIS k r C buscador := by
  apply Nexus.Cripto.probabilidad_monotona
  intro az hz
  exact msis_mayor_cota _ B C hBC _ hz

end Nexus.MLDSA
