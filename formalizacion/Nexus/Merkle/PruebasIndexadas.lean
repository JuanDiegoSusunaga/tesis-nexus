module

public import Nexus.Merkle.Indices
import Mathlib.Data.List.Fold
import Mathlib.Tactic

/-!
# Verificación desde la hoja y extracción por índice

El acumulador usa el bit bajo y divide el índice por dos en cada paso,
como el bucle matemático de merkle.rs. Los hermanos llegan desde la hoja.
La condición de altura corresponde a un dominio de tamaño potencia de dos;
la cota del índice es una premisa adicional al transferir la apertura.
No se formalizan aquí los enteros de máquina ni la ejecución de Rust.
-/

public section
namespace Nexus.Merkle

variable {V D E : Type*}

@[expose] def combinarHermano (f : Formato V D E) (H : E → D) (par : Bool × D) (hijo : D) : D :=
  H (if par.1 then f.nodo par.2 hijo else f.nodo hijo par.2)

@[expose] def verificarDesde (f : Formato V D E) (H : E → D) : ℕ → D → List D → D
  | _, acc, [] => acc
  | i, acc, hermano :: resto =>
      verificarDesde f H (i / 2) (combinarHermano f H (decide (i % 2 = 1), hermano) acc) resto

@[expose] def etiquetarHermanos : ℕ → List D → List (Bool × D)
  | _, [] => []
  | i, hermano :: resto => (decide (i % 2 = 1), hermano) :: etiquetarHermanos (i / 2) resto

@[expose] def hermanosDesdeRaiz (i : ℕ) (hermanos : List D) : List (Bool × D) :=
  (etiquetarHermanos i hermanos).reverse

@[expose] def VerificaIndice (f : Formato V D E) (H : E → D) (raiz : D)
    (altura i : ℕ) (v : V) (hermanos : List D) : Prop :=
  hermanos.length = altura ∧ verificarDesde f H i (H (f.hoja v)) hermanos = raiz

theorem etiquetas_longitud (i : ℕ) (hermanos : List D) :
    (etiquetarHermanos i hermanos).length = hermanos.length := by
  induction hermanos generalizing i with
  | nil => rfl
  | cons hermano resto ih => simp only [etiquetarHermanos, List.length_cons, ih]

theorem etiquetas_bits_bajos (i : ℕ) (hermanos : List D) :
    (etiquetarHermanos i hermanos).map Prod.fst = bitsBajos hermanos.length i := by
  induction hermanos generalizing i with
  | nil => rfl
  | cons hermano resto ih => simp only [etiquetarHermanos, List.map_cons, List.length_cons, bitsBajos, ih]

theorem hermanos_desde_raiz_longitud (i : ℕ) (hermanos : List D) :
    (hermanosDesdeRaiz i hermanos).length = hermanos.length := by
  simp only [hermanosDesdeRaiz, List.length_reverse, etiquetas_longitud]

theorem ruta_prueba_indexada (i : ℕ) (hermanos : List D) :
    (hermanosDesdeRaiz i hermanos).map Prod.fst = rutaIndice hermanos.length i := by
  simp only [hermanosDesdeRaiz, List.map_reverse, etiquetas_bits_bajos, rutaIndice]

theorem reconstruir_como_foldr (f : Formato V D E) (H : E → D) (v : V) (hermanos : List (Bool × D)) :
    reconstruir f H v hermanos = hermanos.foldr (combinarHermano f H) (H (f.hoja v)) := by
  induction hermanos with
  | nil => rfl
  | cons par resto ih => simp only [reconstruir, List.foldr_cons, combinarHermano, ih]

theorem verificar_como_foldl (f : Formato V D E) (H : E → D) (i : ℕ) (acc : D) (hermanos : List D) :
    verificarDesde f H i acc hermanos =
      (etiquetarHermanos i hermanos).foldl (fun hijo par => combinarHermano f H par hijo) acc := by
  induction hermanos generalizing i acc with
  | nil => rfl
  | cons hermano resto ih => simp only [verificarDesde, etiquetarHermanos, List.foldl_cons, ih]

theorem reconstruir_prueba_indexada (f : Formato V D E) (H : E → D) (i : ℕ) (v : V) (hermanos : List D) :
    reconstruir f H v (hermanosDesdeRaiz i hermanos) = verificarDesde f H i (H (f.hoja v)) hermanos := by
  rw [reconstruir_como_foldr, verificar_como_foldl]
  exact List.foldr_reverse

theorem verificacion_equivale_apertura (f : Formato V D E) (H : E → D) (raiz : D)
    (altura i : ℕ) (v : V) (hermanos : List D) :
    VerificaIndice f H raiz altura i v hermanos ↔
      Acepta f H raiz altura v (hermanosDesdeRaiz i hermanos) := by
  simp only [VerificaIndice, Acepta, hermanos_desde_raiz_longitud, reconstruir_prueba_indexada]

variable [Zero V] [DecidableEq D]

theorem apertura_indexada_extraida (f : Formato V D E) (H : E → D) (registro : List E)
    (hc : SinColisiones H registro) (raiz : D) (altura i : ℕ) (hi : i < 2 ^ altura)
    (v : V) (hermanos : List D) (ha : VerificaIndice f H raiz altura i v hermanos)
    (hq : AperturaRegistrada f H registro v (hermanosDesdeRaiz i hermanos)) :
    vectorIndexado f H registro altura raiz ⟨i, hi⟩ = v := by
  have h := apertura_aceptada_extraida f H registro hc raiz altura v (hermanosDesdeRaiz i hermanos)
    hq ((verificacion_equivale_apertura f H raiz altura i v hermanos).mp ha)
  simpa only [ruta_prueba_indexada, ha.1, vectorIndexado] using h

theorem aperturas_indexadas_vinculadas (f : Formato V D E) (H : E → D) (registro : List E)
    (hc : SinColisiones H registro) (raiz : D) (altura i : ℕ) (hi : i < 2 ^ altura)
    (v w : V) (hv hw : List D) (av : VerificaIndice f H raiz altura i v hv)
    (aw : VerificaIndice f H raiz altura i w hw)
    (qv : AperturaRegistrada f H registro v (hermanosDesdeRaiz i hv))
    (qw : AperturaRegistrada f H registro w (hermanosDesdeRaiz i hw)) : v = w :=
  (apertura_indexada_extraida f H registro hc raiz altura i hi v hv av qv).symm.trans
    (apertura_indexada_extraida f H registro hc raiz altura i hi w hw aw qw)

end Nexus.Merkle
