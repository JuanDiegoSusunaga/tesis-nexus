module

public import Nexus.ROM.ExcepcionesPrefijo
public import Nexus.Verificador.LeyTransporteFRI
import Mathlib.Tactic

/-!
# Cota de excepciones de campo en primeras respuestas hash reales

Los conjuntos pueden depender de todo el pasado. El sesgo digest/Fp2 se
paga en cada primera consulta activada y el número de esas consultas se
acota por el presupuesto de direcciones distintas del mismo programa.
-/

public section
namespace Nexus.Verificador.ExcepcionesHash

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.N06
open LeyArbol ObservacionesPrefijo PrimeraExposicion CargaPrimeras
open Nexus.Canal LeyTransporteFRI
attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem cota_respuesta (E : Finset Fp2) :
    promedio (fun d : Digest => if DesafiosPrograma.extension d ∈ E then (1 : ℚ) else 0) ≤
      (E.card : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2 + (2524360 / 10 ^ 35) := by
  have h := cota_evento_una_respuesta_goldilocks (fun x => x ∈ E)
    ((E.card : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2)
    (by rw [evento_uniforme_goldilocks_card])
  refine le_trans ?_ h
  apply promedio_monotono
  intro d
  have he : transporteRetoReal d = DesafiosPrograma.extension d :=
    (transporteRetoReal_factoriza d).trans (DesafiosPrograma.extension_factoriza d).symm
  rw [he]
  split_ifs <;> norm_num

theorem cota_respuesta_cardinal (E : Finset Fp2) (C : ℕ) (hC : E.card ≤ C) :
    promedio (fun d : Digest => if DesafiosPrograma.extension d ∈ E then (1 : ℚ) else 0) ≤
      (C : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2 + (2524360 / 10 ^ 35) := by
  have hb : (E.card : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2 ≤
      (C : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2 :=
    div_le_div_of_nonneg_right (by exact_mod_cast hC) (by positivity)
  exact (cota_respuesta E).trans (by linarith only [hb])

theorem cota_presupuesto {Q X : Type} [DecidableEq Q] [Fintype Q]
    (p : Arbol Q Digest X) (N B C : ℕ)
    (direccion : ℕ → List (Q × Digest) → Q)
    (E : ℕ → List (Q × Digest) → Finset Fp2)
    (hE : ∀ (n : Fin N) H, Inicia p direccion n.val H →
      (E n.val (prefijo p n.val H)).card ≤ C)
    (hB : ∀ H : Q → Digest, ((traza H p).map Prod.fst).toFinset.card ≤ B) :
    promedio (fun H : Q → Digest => if ∃ n : Fin N,
      Inicia p direccion n.val H ∧
        DesafiosPrograma.extension (H (direccion n.val (prefijo p n.val H))) ∈
          E n.val (prefijo p n.val H)
      then (1 : ℚ) else 0) ≤
      ((C : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2 + (2524360 / 10 ^ 35)) * B := by
  have h := ExcepcionesPrefijo.cota_presupuesto p N B direccion
    (fun n t d => DesafiosPrograma.extension d ∈ E n t)
    ((C : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2 + (2524360 / 10 ^ 35)) (by positivity)
    (by
      intro n H ha
      have hlocal := cota_respuesta_cardinal (E n.val (prefijo p n.val H)) C (hE n H ha)
      refine le_trans ?_ hlocal
      apply promedio_monotono
      intro d
      split_ifs <;> norm_num) hB
  refine le_trans ?_ h
  apply promedio_monotono
  intro H
  split_ifs <;> norm_num

end Nexus.Verificador.ExcepcionesHash
