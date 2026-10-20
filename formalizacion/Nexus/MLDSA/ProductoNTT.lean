module

public import Nexus.MLDSA.NTTAlgebra
public import Nexus.MLDSA.Anillos
import Mathlib.Tactic

/-!
# La NTT identifica el producto negacíclico con productos coordenados

Se obtiene una biyección algebraica del anillo Rq a 256 evaluaciones.
El resultado enlaza el cociente X^256+1 y la transformada recursiva;
no certifica Montgomery, el orden del backend ni enteros de máquina.
-/

public section
namespace Nexus.MLDSA.ProductoNTT

open Polynomial NTTAlgebra

@[expose] def punto (i : Fin n) : Fq := zeta * (zeta ^ 2) ^ i.val

theorem punto_raiz (i : Fin n) : punto i ^ n = -1 := by
  rw [punto, mul_pow, ← pow_mul, Nat.mul_comm i.val n, pow_mul,
    raiz_ciclica.pow_eq_one, one_pow, mul_one, raiz_negaciclica]

theorem modulo_se_anula (i : Fin n) : (moduloPolinomio Fq).eval (punto i) = 0 := by
  simp only [moduloPolinomio, eval_add, eval_pow, eval_X, eval_one, punto_raiz, neg_add_cancel]

theorem evaluacion_clase (f : Polynomial Fq) (i : Fin n) :
    (representante (AdjoinRoot.mk (moduloPolinomio Fq) f)).eval (punto i) = f.eval (punto i) := by
  rw [representante_clase]
  exact Polynomial.eval₂_modByMonic_eq_self_of_root (modulo_se_anula i)

@[expose] noncomputable def evaluar (w : Rq) : Fin n → Fq :=
  fun i => (representante w).eval (punto i)

theorem evaluar_producto (u v : Rq) : evaluar (u * v) = evaluar u * evaluar v := by
  funext i
  have he : AdjoinRoot.mk (moduloPolinomio Fq) (representante u * representante v) = u * v := by
    rw [map_mul, clase_representante, clase_representante]
  change (representante (u * v)).eval (punto i) = _
  rw [← he, evaluacion_clase, eval_mul]
  rfl

theorem evaluar_suma (u v : Rq) : evaluar (u + v) = evaluar u + evaluar v := by
  funext i
  have he : AdjoinRoot.mk (moduloPolinomio Fq) (representante u + representante v) = u + v := by
    rw [map_add, clase_representante, clase_representante]
  change (representante (u + v)).eval (punto i) = _
  rw [← he, evaluacion_clase, eval_add]
  rfl

theorem evaluar_inyectiva : Function.Injective evaluar := by
  intro u v h
  apply representante_inyectivo
  have hz : zeta ≠ 0 := by
    intro hz
    have hp := semipotencia_raiz
    rw [hz] at hp
    norm_num at hp
  apply evaluaciones_determinan 8 (zeta ^ 2) zeta raiz_ciclica hz
  · exact Polynomial.degree_le_natDegree.trans_lt (by exact_mod_cast grado_representante u)
  · exact Polynomial.degree_le_natDegree.trans_lt (by exact_mod_cast grado_representante v)
  · intro i hi
    exact congrFun h ⟨i, hi⟩

theorem evaluar_biyectiva : Function.Bijective evaluar := by
  apply (Fintype.bijective_iff_injective_and_card evaluar).mpr
  refine ⟨evaluar_inyectiva, ?_⟩
  rw [cardinal_anillo_modular, Fintype.card_fun, Fintype.card_fin, cardinal_campo]

@[expose] noncomputable def equivalencia : Rq ≃ (Fin n → Fq) := Equiv.ofBijective evaluar evaluar_biyectiva

theorem producto_recursivo (a b : Datos Fq 8) (i : Fin n) :
    evaluar (AdjoinRoot.mk (moduloPolinomio Fq) (polinomio 8 a) *
      AdjoinRoot.mk (moduloPolinomio Fq) (polinomio 8 b)) i =
    transformar 8 a (zeta ^ 2) zeta i.val * transformar 8 b (zeta ^ 2) zeta i.val := by
  rw [evaluar_producto]
  change (representante _).eval (punto i) * (representante _).eval (punto i) = _
  rw [evaluacion_clase, evaluacion_clase, mldsa_256 a i.val i.isLt, mldsa_256 b i.val i.isLt]
  rfl

end Nexus.MLDSA.ProductoNTT
