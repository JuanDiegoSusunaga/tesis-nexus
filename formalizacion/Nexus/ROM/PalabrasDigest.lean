module

public import Nexus.ROM.ProyeccionDigest
public import Nexus.ROM.LeySelector
import Mathlib.Tactic

/-!
# Cintas de digests y ley del selector

Se cuenta el experimento ideal de R respuestas independientes de 32 bytes.
Su proyección mediante el índice real conserva exactamente la distribución
uniforme de palabras de índices. El corte y la condición de completar son
explícitos. La frescura de las direcciones del canal es otra obligación;
no se identifica este experimento con un ROM condicionado a SinBad.
-/

public section
namespace Nexus.ROM.PalabrasDigest

open Nexus.Bytes Nexus.Merkle Nexus.N06
open Selector.Uniformidad
open scoped BigOperators

attribute [local instance] Classical.propDecidable

@[expose] def proyectar (e R : ℕ) (w : Fin R → Digest) : Fin R → Fin (2 ^ e) :=
  fun i => Nexus.Canal.ProgramaTG2.indice (2 ^ e) (by positivity) (w i)

@[expose] def equivalenciaFibra (e R : ℕ) (v : Fin R → Fin (2 ^ e)) :
    {w : Fin R → Digest // proyectar e R w = v} ≃
      ((i : Fin R) → {d : Digest // Nexus.Canal.ProgramaTG2.indice (2 ^ e) (by positivity) d = v i}) where
  toFun w i := ⟨w.val i, congrFun w.property i⟩
  invFun w := ⟨fun i => (w i).val, funext (fun i => (w i).property)⟩
  left_inv _ := rfl
  right_inv _ := rfl

theorem cardinal_fibra (e R : ℕ) (he : e ≤ 64) (v : Fin R → Fin (2 ^ e)) :
    Fintype.card {w : Fin R → Digest // proyectar e R w = v} = (2 ^ (256 - e)) ^ R := by
  classical
  rw [Fintype.card_congr (equivalenciaFibra e R v), Fintype.card_pi]
  simp_rw [ProyeccionDigest.fibras_iguales e he]
  simp

@[expose] def equivalenciaEvento (e R : ℕ) (E : (Fin R → Fin (2 ^ e)) → Prop) :
    {w : Fin R → Digest // E (proyectar e R w)} ≃
      ((v : {v : Fin R → Fin (2 ^ e) // E v}) × {w : Fin R → Digest // proyectar e R w = v.val}) where
  toFun w := ⟨⟨proyectar e R w.val, w.property⟩, ⟨w.val, rfl⟩⟩
  invFun v := ⟨v.2.val, by rw [v.2.property]; exact v.1.property⟩
  left_inv _ := rfl
  right_inv v := by
    rcases v with ⟨⟨v, hv⟩, ⟨w, hw⟩⟩
    dsimp at hw
    subst v
    rfl

theorem cardinal_evento (e R : ℕ) (he : e ≤ 64) (E : (Fin R → Fin (2 ^ e)) → Prop) :
    Fintype.card {w : Fin R → Digest // E (proyectar e R w)} =
      Fintype.card {v : Fin R → Fin (2 ^ e) // E v} * (2 ^ (256 - e)) ^ R := by
  classical
  rw [Fintype.card_congr (equivalenciaEvento e R E), Fintype.card_sigma]
  simp_rw [cardinal_fibra e R he]
  simp

theorem promedio_palabras (e R : ℕ) (he : e ≤ 64) (f : (Fin R → Fin (2 ^ e)) → ℚ) :
    promedio (fun w : Fin R → Digest => f (proyectar e R w)) = promedio f := by
  classical
  have hs : (∑ w : Fin R → Digest, f (proyectar e R w)) =
      ∑ v : Fin R → Fin (2 ^ e),
        (Fintype.card {w : Fin R → Digest // proyectar e R w = v} : ℚ) * f v := by
    rw [← Fintype.sum_fiberwise' (proyectar e R) f]
    simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
  unfold promedio
  rw [hs]
  simp_rw [cardinal_fibra e R he]
  rw [← Finset.mul_sum]
  simp only [Fintype.card_fun, Fintype.card_fin, ProyeccionDigest.cardinal_digest,
    Nat.cast_pow, Nat.cast_ofNat]
  have hp : (2 : ℚ) ^ 256 = 2 ^ (256 - e) * 2 ^ e := by
    rw [← pow_add, Nat.sub_add_cancel (by omega : e ≤ 256)]
  rw [hp, mul_pow]
  field_simp

theorem cociente_eventos (e R : ℕ) (he : e ≤ 64)
    (E F : (Fin R → Fin (2 ^ e)) → Prop) :
    (Fintype.card {w : Fin R → Digest // E (proyectar e R w)} : ℚ) /
        Fintype.card {w : Fin R → Digest // F (proyectar e R w)} =
      (Fintype.card {v : Fin R → Fin (2 ^ e) // E v} : ℚ) /
        Fintype.card {v : Fin R → Fin (2 ^ e) // F v} := by
  classical
  rw [cardinal_evento e R he E, cardinal_evento e R he F]
  simp only [Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat]
  exact mul_div_mul_right _ _ (by positivity)

theorem selector_uniforme (e q R : ℕ) (he : e ≤ 64) (S : Finset (Fin (2 ^ e))) (hS : S.card = q)
    (hpos : 0 < Fintype.card (Completas (Fin (2 ^ e)) q R)) :
    (Fintype.card {w : Fin R → Digest // salida q R (proyectar e R w) = S} : ℚ) /
        Fintype.card {w : Fin R → Digest // (salida q R (proyectar e R w)).card = q} =
      1 / (Nat.choose (2 ^ e) q : ℚ) := by
  have hc := cociente_eventos e R he (fun v => salida q R v = S) (fun v => (salida q R v).card = q)
  have hu := uniforme_condicionado_a_completar q R S hS hpos
  simp only [Fintype.card_fin] at hu
  simp only [← Nat.card_eq_fintype_card] at hc hu ⊢
  exact hc.trans hu

theorem selector_hipergeometrico (e q R : ℕ) (he : e ≤ 64) (G : Finset (Fin (2 ^ e)))
    (hpos : 0 < Fintype.card (Completas (Fin (2 ^ e)) q R)) :
    (Fintype.card {w : Fin R → Digest //
      (salida q R (proyectar e R w)).card = q ∧ salida q R (proyectar e R w) ⊆ G} : ℚ) /
        Fintype.card {w : Fin R → Digest // (salida q R (proyectar e R w)).card = q} =
      (Nat.choose G.card q : ℚ) / Nat.choose (2 ^ e) q := by
  classical
  have hc := cociente_eventos e R he
    (fun v => (salida q R v).card = q ∧ salida q R v ⊆ G) (fun v => (salida q R v).card = q)
  let ev : {v : Fin R → Fin (2 ^ e) // (salida q R v).card = q ∧ salida q R v ⊆ G} ≃
      Ley.Buenas q R G :=
    { toFun := fun v => ⟨⟨v.val, v.property.1⟩, v.property.2⟩
      invFun := fun v => ⟨v.val.val, v.val.property, v.property⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  have hh := Ley.hipergeometrica_condicionada q R G hpos
  simp only [Fintype.card_fin] at hh
  have hcount := Fintype.card_congr ev
  simp only [← Nat.card_eq_fintype_card] at hc hh hcount ⊢
  rw [hcount] at hc
  exact hc.trans hh

end Nexus.ROM.PalabrasDigest
