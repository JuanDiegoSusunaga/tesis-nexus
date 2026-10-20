module

public import Nexus.ROM.RaicesCanonicas
public import Nexus.AIR.ContraejemploGoldilocks
import Mathlib.Tactic

/-!
# Reconstrucción del testigo de 16 filas desde evaluaciones públicas

Dieciséis índices distintos del dominio de 128 puntos dan nodos distintos.
La interpolación recupera todo polinomio de grado menor que 16 y, para la
traza honesta del ejemplo, su segunda fila privada 5. La identificación
de valores concretos de un certificado continúa siendo una obligación.
-/

public section
namespace Nexus.ROM.Reconstruccion

open Polynomial Nexus.Goldilocks Nexus.AIR.Contraejemplo

@[expose] noncomputable def recuperar16 (indices : Fin 16 → Fin 128) (valores : Fin 16 → Fp2) : Polynomial Fp2 :=
  Lagrange.interpolate Finset.univ (fun i => puntoCapa 4 0 (indices i).val) valores

theorem nodos_distintos (indices : Fin 16 → Fin 128) (hi : Function.Injective indices) :
    Function.Injective (fun i => puntoCapa 4 0 (indices i).val) := by
  intro i j he
  apply hi
  apply Fin.ext
  exact punto_capa_inyectivo 4 0 (by norm_num) (by norm_num)
    (Finset.mem_range.mpr (indices i).isLt) (Finset.mem_range.mpr (indices j).isLt) he

theorem recuperacion_exacta (indices : Fin 16 → Fin 128) (hi : Function.Injective indices)
    (f : Polynomial Fp2) (hf : f.degree < (16 : ℕ)) :
    recuperar16 indices (fun i => f.eval (puntoCapa 4 0 (indices i).val)) = f := by
  exact (Lagrange.eq_interpolate (nodos_distintos indices hi).injOn
    (by simpa only [Finset.card_univ, Fintype.card_fin] using hf)).symm

theorem recuperacion_desde_valores (indices : Fin 16 → Fin 128) (hi : Function.Injective indices)
    (valores : Fin 16 → Fp2) (f : Polynomial Fp2) (hf : f.degree < (16 : ℕ))
    (he : ∀ i, valores i = f.eval (puntoCapa 4 0 (indices i).val)) : recuperar16 indices valores = f := by
  have hfun : valores = fun i => f.eval (puntoCapa 4 0 (indices i).val) := funext he
  rw [hfun]
  exact recuperacion_exacta indices hi f hf

theorem recuperacion_traza_ejemplo (indices : Fin 16 → Fin 128) (hi : Function.Injective indices) :
    recuperar16 indices (fun i => (trazaHonesta 4).eval (puntoCapa 4 0 (indices i).val)) = trazaHonesta 4 := by
  apply recuperacion_exacta indices hi
  exact Polynomial.degree_le_natDegree.trans_lt (by exact_mod_cast grado_traza_honesta 4 (by norm_num))

theorem recuperacion_segunda_fila (indices : Fin 16 → Fin 128) (hi : Function.Injective indices) :
    (recuperar16 indices (fun i => (trazaHonesta 4).eval (puntoCapa 4 0 (indices i).val))).eval
      (raizExtension 4) = 5 := by
  rw [recuperacion_traza_ejemplo indices hi]
  exact segunda_fila_interpolante 16 (by norm_num) (raizExtension 4) 3 5
    (raiz_extension_primitiva 4 (by norm_num))

end Nexus.ROM.Reconstruccion
