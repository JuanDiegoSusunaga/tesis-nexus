module

public import Nexus.AIR.EjemploCancelacion
public import Nexus.ROM.ReconstruccionPublica
import Mathlib.Tactic

/-!
# Certificado legado concreto de 16 filas

Las constantes proceden de certificado-legado-16.bin, SHA-256
bcf91052386434ca24c078098a8f7853b7fffd8d65fef7bc1ee9a15e59d14f42.
El enlace de bytes y SHA3 se comprueba externamente; Lean demuestra las
igualdades de campo, el grado, la interpolación y la recuperación de 5.
No es una prueba general de solidez ni de conocimiento cero.
-/

public section
namespace Nexus.ROM.CertificadoLegado16

open Polynomial Nexus.Goldilocks
open scoped BigOperators

@[expose] def indicesConsulta : Fin 40 → Fin 64 := ![44, 16, 36, 10, 15, 54, 39, 11, 48, 25, 60, 21, 34, 63, 8, 33, 30, 22, 14, 20, 59, 45, 50, 35, 6, 12, 28, 43, 32, 19, 46, 61, 13, 23, 38, 42, 17, 41, 24, 57]
@[expose] def consultaSeleccionada : Fin 16 → Fin 40 := ![8, 39, 22, 20, 10, 31, 5, 13, 14, 39, 3, 7, 10, 31, 18, 4]
@[expose] def ranuraSeleccionada : Fin 16 → Fin 6 := ![5, 4, 5, 4, 4, 4, 5, 4, 0, 5, 0, 0, 5, 5, 0, 0]
@[expose] def valores : Fin 16 → Fp := ![4825148612097906909, 6062150311314790967, 11611330721780951950, 2266190013291072096, 11686710200266506228, 9483525728031515213, 13757491475470458817, 1456867478348531803, 1737102766307840582, 5910820443427780754, 4734504292507539585, 14949597378956263851, 5148683310413595926, 17978713658818909457, 11789485768437204044, 14364342219149889971]
@[expose] def coeficientes : Fin 16 → Fp := ![10238390604215243935, 18422831666055352182, 4529018766899552652, 6426660552232977700, 10162278779537531220, 15391766501478586184, 16303793580191524200, 386470655254749449, 2822223829994779068, 4540522736365891632, 11174151715448657779, 16519593090663110469, 4208248307581297534, 6185304754994554635, 15813937005805583646, 4448760008597282286]

@[expose] def posicion (consulta : Fin 40) (ranura : Fin 6) : ℕ :=
  ((indicesConsulta consulta).val + ranura.val / 3 * 64 + ranura.val % 3 * 8) % 128

@[expose] noncomputable def nodo (i : Fin 16) : Fp := 7 * raiz 7 ^ i.val
@[expose] noncomputable def polinomio : Polynomial Fp :=
  ∑ i : Fin 16, monomial i (coeficientes i)
@[expose] noncomputable def recuperado : Polynomial Fp :=
  Lagrange.interpolate Finset.univ nodo valores

theorem posiciones_del_certificado (i : Fin 16) :
    posicion (consultaSeleccionada i) (ranuraSeleccionada i) = i.val := by
  fin_cases i <;> norm_num [posicion, indicesConsulta, consultaSeleccionada, ranuraSeleccionada]

theorem nodos_distintos : Function.Injective nodo := by
  intro i j h
  apply Fin.ext
  apply (raiz_primitiva 7 (by decide)).pow_inj (by omega) (by omega)
  exact mul_left_cancel₀ (by decide : (7 : Fp) ≠ 0) h

theorem grado_polinomio : polinomio.natDegree < 16 := by
  have hd : polinomio.degree < (16 : ℕ) := by
    simpa only [polinomio, ← C_mul_X_pow_eq_monomial] using degree_sum_fin_lt coeficientes
  by_cases h : polinomio = 0
  · simp [h]
  · exact (natDegree_lt_iff_degree_lt h).mpr hd

theorem raiz_dominio_valor : raiz 7 = 17870292113338400769 := by
  have h : (7 : ZMod p) ^ ((p - 1) / 128) = 17870292113338400769 := by
    unfold p
    norm_num only [Nat.reduceSub, Nat.reduceDiv]
    reduce_mod_char
  exact h

set_option maxHeartbeats 2500000 in
theorem evaluaciones_certificado (i : Fin 16) : polinomio.eval (nodo i) = valores i := by
  have : CharP Fp 18446744069414584321 := inferInstance
  unfold nodo
  rw [raiz_dominio_valor]
  fin_cases i <;>
    norm_num [polinomio, valores, coeficientes, Fin.sum_univ_succ, eval_monomial] <;> reduce_mod_char!

theorem interpolacion_exacta : recuperado = polinomio := by
  have hfun : valores = fun i => polinomio.eval (nodo i) := funext (fun i => (evaluaciones_certificado i).symm)
  rw [recuperado, hfun]
  exact (Lagrange.eq_interpolate nodos_distintos.injOn
    (by simpa only [Finset.card_univ, Fintype.card_fin] using
      Polynomial.degree_le_natDegree.trans_lt (show (polinomio.natDegree : WithBot ℕ) < (16 : ℕ) by
        exact_mod_cast grado_polinomio))).symm

set_option maxHeartbeats 1000000 in
theorem segunda_fila_polinomio : polinomio.eval (raiz 4) = 5 := by
  have : CharP Fp 18446744069414584321 := inferInstance
  rw [Nexus.AIR.EjemploCancelacion.raiz_valor]
  norm_num [polinomio, coeficientes, Fin.sum_univ_succ, eval_monomial]
  reduce_mod_char!

/-- Las dieciséis evaluaciones públicas literales recuperan la segunda fila. -/
theorem testigo_recuperado : recuperado.eval (raiz 4) = 5 := by
  rw [interpolacion_exacta, segunda_fila_polinomio]

theorem cualquier_traza_compatible (f : Polynomial Fp) (hf : f.natDegree < 16)
    (he : ∀ i, f.eval (nodo i) = valores i) : f = polinomio := by
  have hfun : valores = fun i => f.eval (nodo i) := funext (fun i => (he i).symm)
  have hrec : recuperado = f := by
    rw [recuperado, hfun]
    exact (Lagrange.eq_interpolate nodos_distintos.injOn
      (by simpa only [Finset.card_univ, Fintype.card_fin] using
        Polynomial.degree_le_natDegree.trans_lt (show (f.natDegree : WithBot ℕ) < (16 : ℕ) by
          exact_mod_cast hf))).symm
  exact hrec.symm.trans interpolacion_exacta

theorem segunda_fila_unica (f : Polynomial Fp) (hf : f.natDegree < 16)
    (he : ∀ i, f.eval (nodo i) = valores i) : f.eval (raiz 4) = 5 := by
  rw [cualquier_traza_compatible f hf he, segunda_fila_polinomio]

end Nexus.ROM.CertificadoLegado16
