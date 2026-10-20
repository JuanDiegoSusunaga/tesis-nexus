module

public import Nexus.MLDSA.Parametros
public import Mathlib.RingTheory.AdjoinRoot
import Mathlib.Tactic

public section
namespace Nexus.MLDSA

open Polynomial

/-- Presentación del cociente negacíclico, sobre enteros o sobre el campo. -/
@[expose] noncomputable def moduloPolinomio (A : Type*) [CommRing A] : Polynomial A := X ^ n + 1

theorem modulo_monico (A : Type*) [CommRing A] : (moduloPolinomio A).Monic := by
  simpa [moduloPolinomio] using monic_X_pow_add_C (1 : A) (by norm_num [n])

theorem grado_modulo (A : Type*) [CommRing A] [Nontrivial A] :
    (moduloPolinomio A).natDegree = n := by
  simp [moduloPolinomio]

abbrev Anillo (A : Type*) [CommRing A] := AdjoinRoot (moduloPolinomio A)
abbrev R := Anillo ℤ
abbrev Rq := Anillo Fq
abbrev Vector (r : ℕ) := Fin r → Rq
abbrev Matriz (r s : ℕ) := Matrix (Fin r) (Fin s) Rq

/-- Representante canónico de grado menor que 256, también para R sobre ℤ. -/
@[expose] noncomputable def representante {A : Type*} [CommRing A]
    (w : Anillo A) : Polynomial A := AdjoinRoot.modByMonicHom (modulo_monico A) w

theorem representante_clase {A : Type*} [CommRing A] (f : Polynomial A) :
    representante (AdjoinRoot.mk (moduloPolinomio A) f) = f %ₘ moduloPolinomio A := rfl

theorem clase_representante {A : Type*} [CommRing A] (w : Anillo A) :
    AdjoinRoot.mk (moduloPolinomio A) (representante w) = w :=
  AdjoinRoot.mk_leftInverse (modulo_monico A) w

theorem representante_inyectivo {A : Type*} [CommRing A] :
    Function.Injective (representante (A := A)) := by
  intro u v huv
  rw [← clase_representante u, ← clase_representante v, huv]

theorem grado_representante {A : Type*} [CommRing A] [Nontrivial A] (w : Anillo A) :
    (representante w).natDegree < n := by
  induction w using AdjoinRoot.induction_on with | ih f =>
    rw [representante_clase, ← grado_modulo A]
    apply natDegree_modByMonic_lt f (modulo_monico A)
    intro h
    have hd := congrArg Polynomial.natDegree h
    norm_num [grado_modulo, n] at hd

theorem representante_grado_menor {A : Type*} [CommRing A] [Nontrivial A]
    (f : Polynomial A) (hf : f.natDegree < n) :
    representante (AdjoinRoot.mk (moduloPolinomio A) f) = f := by
  rw [representante_clase, modByMonic_eq_self_iff (modulo_monico A)]
  exact degree_lt_degree (by simpa [grado_modulo] using hf)

theorem igualdad_clases {A : Type*} [CommRing A] (f g : Polynomial A) :
    AdjoinRoot.mk (moduloPolinomio A) f = AdjoinRoot.mk (moduloPolinomio A) g ↔
      moduloPolinomio A ∣ f - g := AdjoinRoot.mk_eq_mk

theorem unicidad_representante {A : Type*} [CommRing A] [Nontrivial A]
    (f g : Polynomial A) (hf : f.natDegree < n) (hg : g.natDegree < n)
    (h : AdjoinRoot.mk (moduloPolinomio A) f = AdjoinRoot.mk (moduloPolinomio A) g) :
    f = g := by
  simpa [representante_grado_menor f hf, representante_grado_menor g hg] using
    congrArg representante h

theorem relacion_negaciclica (A : Type*) [CommRing A] :
    AdjoinRoot.root (moduloPolinomio A) ^ n = (-1 : Anillo A) := by
  apply eq_neg_of_add_eq_zero_left
  change AdjoinRoot.root (moduloPolinomio A) ^ n + 1 = 0
  rw [← AdjoinRoot.mk_X, ← map_pow, ← map_one (AdjoinRoot.mk (moduloPolinomio A)),
    ← map_add]
  exact AdjoinRoot.mk_self

/-- Coordenadas de la base 1,X,...,X^255; identifica el cociente con 256 coeficientes. -/
@[expose] noncomputable def coordenadas (A : Type*) [CommRing A] [Nontrivial A] :
    Anillo A ≃ₗ[A] (Fin n → A) := by
  have h := (AdjoinRoot.powerBasisAux' (modulo_monico A)).equivFun
  rw [grado_modulo A] at h
  exact h

noncomputable instance : Fintype Rq :=
  Fintype.ofEquiv (Fin n → Fq) (coordenadas Fq).toEquiv.symm

theorem cardinal_anillo_modular : Fintype.card Rq = q ^ n := by
  rw [Fintype.card_congr (coordenadas Fq).toEquiv, Fintype.card_fun,
    Fintype.card_fin, cardinal_campo]

theorem cardinal_vector (r : ℕ) : Fintype.card (Vector r) = q ^ (n * r) := by
  simp only [Vector, Fintype.card_fun, Fintype.card_fin, cardinal_anillo_modular, pow_mul]

theorem cardinal_matriz (r s : ℕ) : Fintype.card (Matriz r s) = q ^ (n * (r * s)) := by
  change Fintype.card (Fin r → Fin s → Rq) = _
  rw [Fintype.card_fun, Fintype.card_fun, Fintype.card_fin, Fintype.card_fin,
    cardinal_anillo_modular, ← pow_mul, ← pow_mul]
  congr 1
  rw [Nat.mul_comm s r]

/-- Reducción de coeficientes que respeta la relación X^256=-1. -/
@[expose] noncomputable def reduccion : R →+* Rq :=
  AdjoinRoot.map (Int.castRingHom Fq) (moduloPolinomio ℤ) (moduloPolinomio Fq) (by
    simp [moduloPolinomio])

theorem reduccion_clase (f : Polynomial ℤ) :
    reduccion (AdjoinRoot.mk (moduloPolinomio ℤ) f) =
      AdjoinRoot.mk (moduloPolinomio Fq) (f.map (Int.castRingHom Fq)) := by
  rw [reduccion, AdjoinRoot.map, AdjoinRoot.lift_mk]
  rw [← AdjoinRoot.aeval_eq, aeval_def, eval₂_map, AdjoinRoot.algebraMap_eq]

theorem reduccion_sobreyectiva : Function.Surjective reduccion := by
  intro w
  obtain ⟨f, rfl⟩ := AdjoinRoot.mk_surjective w
  obtain ⟨g, rfl⟩ := Polynomial.map_surjective (Int.castRingHom Fq) ZMod.intCast_surjective f
  exact ⟨AdjoinRoot.mk (moduloPolinomio ℤ) g, reduccion_clase g⟩

/-- Coeficientes canónicos; fuera de Fin 256 el representante se anula. -/
@[expose] noncomputable def coeficiente {A : Type*} [CommRing A]
    (w : Anillo A) (i : Fin n) : A := (representante w).coeff i

theorem coeficiente_determina {A : Type*} [CommRing A] [Nontrivial A]
    (u v : Anillo A) (h : ∀ i, coeficiente u i = coeficiente v i) : u = v := by
  apply representante_inyectivo
  ext j
  by_cases hj : j < n
  · exact h ⟨j, hj⟩
  · rw [coeff_eq_zero_of_natDegree_lt ((grado_representante u).trans_le (by omega)),
      coeff_eq_zero_of_natDegree_lt ((grado_representante v).trans_le (by omega))]

theorem coeficiente_cero (i : Fin n) : coeficiente (0 : Rq) i = 0 := by
  simp [coeficiente, representante]

end Nexus.MLDSA
