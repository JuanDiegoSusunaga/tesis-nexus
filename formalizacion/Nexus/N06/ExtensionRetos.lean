module

public import Nexus.N06.RondasExplicitas
import Mathlib.Tactic

/-!
# Un reto nuevo conserva la historia y los mensajes anteriores

La nueva coordenada no altera los prefijos usados para fijar los oráculos.
Por ello el destino de un reto depende de los datos ya emitidos y de su
respuesta, no de las decisiones futuras de la política que los representa.
-/

public section
namespace Nexus.N06

theorem reto_anexado_anterior {K : Type*} [Zero K] {n : ℕ} (xs : Retos K n)
    (x : K) (i : ℕ) (hi : i < n) : reto (anexarReto xs x) i = reto xs i := by
  induction n generalizing i with
  | zero => omega
  | succ n ih =>
    rcases xs with ⟨y, rest⟩
    cases i with
    | zero => rfl
    | succ i => exact ih rest i (by omega)

theorem historia_anexada_anterior {K : Type*} [Zero K] {n : ℕ} (xs : Retos K n)
    (x : K) (i : ℕ) (hi : i ≤ n) :
    Nexus.FRI.historia (reto (anexarReto xs x)) i = Nexus.FRI.historia (reto xs) i := by
  apply Nexus.FRI.historia_depende_prefijo
  intro j hj
  exact reto_anexado_anterior xs x j (by omega)

end Nexus.N06

namespace Nexus.Goldilocks

open Nexus.N06

theorem capa_traza_anexada {n : ℕ} (p : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 n) (x : Fp2) (i : ℕ) (hi : i ≤ n) :
    capaTraza p a (anexarReto bt x) i = capaTraza p a bt i := by
  simp only [capaTraza, historia_anexada_anterior bt x i hi]

theorem capa_composicion_anexada {k n : ℕ} (p : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 k) (bc : Retos Fp2 n) (x : Fp2) (i : ℕ) (hi : i ≤ n) :
    capaComposicion p a bt (anexarReto bc x) i = capaComposicion p a bt bc i := by
  simp only [capaComposicion, historia_anexada_anterior bc x i hi]

theorem mismos_mensajes_despues_reto (k q : ℕ) (p r : PoliticaConsulta) (v : PeticionCausal k)
    (h : MismosMensajes k q p r (origenCausal k q v)) (x : RespuestaCausal k q v) :
    MismosMensajes k q p r (destinoCausal k q v x) := by
  cases v with
  | air => exact h
  | traza a j bt =>
    change p.inicial = r.inicial ∧ _ at h
    change p.inicial = r.inicial ∧ _
    refine ⟨h.1, ?_⟩
    intro i hi
    have hj : j.val < k := j.isLt
    have hib : i ≤ j.val := by
      simp only [capasEmitidas, Bool.false_eq_true, false_and, ite_false, Nat.add_zero] at hi
      omega
    rw [capa_traza_anexada p a bt x i hib, capa_traza_anexada r a bt x i hib]
    apply h.2 i
    simp only [capasEmitidas, and_true, hj, ite_true]
    omega
  | composicion a bt j bc =>
    change p.inicial = r.inicial ∧ _ ∧ _ ∧ _ ∧ _ at h
    change p.inicial = r.inicial ∧ _ ∧ _ ∧ _ ∧ _
    refine ⟨h.1, h.2.1, h.2.2.1, h.2.2.2.1, ?_⟩
    intro i hi
    have hj : j.val < k + 1 := j.isLt
    have hib : i ≤ j.val := by
      simp only [capasEmitidas, Bool.false_eq_true, false_and, ite_false, Nat.add_zero] at hi
      omega
    rw [capa_composicion_anexada p a bt bc x i hib, capa_composicion_anexada r a bt bc x i hib]
    apply h.2.2.2.2 i
    simp only [capasEmitidas, and_true, hj, ite_true]
    omega
  | consulta => exact h

theorem captura_destino_desde_origen (k q : ℕ) (p : PoliticaConsulta) (r : PeticionCausal k)
    (x : RespuestaCausal k q r) :
    destinoExplicito k q ⟨r, capturarMensajes k q p (origenCausal k q r)⟩ x =
      (⟨destinoCausal k q r x, capturarMensajes k q p (destinoCausal k q r x)⟩ : TranscripcionExplicita k q) := by
  let c := politicaDeDatos k q (origenCausal k q r) (capturarMensajes k q p (origenCausal k q r))
  have hs : MismosMensajes k q c p (origenCausal k q r) :=
    (captura_mensajes_igual_iff k q c p _).mp
      (capturar_realizacion_prefijo k q _ (capturarMensajes k q p _))
  have hd := (captura_mensajes_igual_iff k q c p _).mpr (mismos_mensajes_despues_reto k q c p r hs x)
  exact congrArg (fun d => (⟨destinoCausal k q r x, d⟩ : TranscripcionExplicita k q)) hd

end Nexus.Goldilocks
