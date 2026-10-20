module

public import Nexus.ROM.Presupuestos
public import Nexus.ROM.Probabilidad
public import Nexus.ROM.Sesgo
public import Nexus.Cripto.Variacion
import Mathlib.Tactic

/-!
# Unión de eventos y composición de las cotas ROM

La ley que representa el ejecutable y las inclusiones de eventos son
obligaciones explícitas. No se declara certificado un ejemplo de seguridad
solo por evaluar una suma numérica de términos no instanciados.
-/

public section
namespace Nexus.ROM.Composicion

open Nexus.Cripto.Variacion
open scoped BigOperators
variable {A : Type} [Fintype A]

theorem evento_monotono (p : Ley A) (E F : A → Prop) (h : ∀ x, E x → F x) :
    evento p E ≤ evento p F := by
  classical
  unfold evento
  apply Finset.sum_le_sum
  intro x _
  by_cases he : E x
  · simp only [he, h x he, ite_true]
    exact le_refl _
  · simp only [he, ite_false]
    split_ifs
    · exact p.noNegativo x
    · exact le_refl _

theorem evento_union (p : Ley A) (E F : A → Prop) :
    evento p (fun x => E x ∨ F x) ≤ evento p E + evento p F := by
  classical
  unfold evento
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro x _
  by_cases he : E x <;> by_cases hf : F x <;> simp [he, hf, p.noNegativo x]

theorem evento_union_finset {I : Type} (p : Ley A) (s : Finset I) (E : I → A → Prop) :
    evento p (fun x => ∃ i ∈ s, E i x) ≤ ∑ i ∈ s, evento p (E i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp [evento]
  | @insert i s hi ih =>
      calc
        evento p (fun x => ∃ j ∈ insert i s, E j x) =
            evento p (fun x => E i x ∨ ∃ j ∈ s, E j x) := by
              congr 1
              funext x
              simp [Finset.mem_insert]
        _ ≤ evento p (E i) + evento p (fun x => ∃ j ∈ s, E j x) :=
          evento_union p (E i) (fun x => ∃ j ∈ s, E j x)
        _ ≤ evento p (E i) + ∑ j ∈ s, evento p (E j) :=
          add_le_add_right ih (evento p (E i))
        _ = ∑ j ∈ insert i s, evento p (E j) := by
          rw [Finset.sum_insert hi]

theorem evento_union_dos_indices {I J : Type} (p : Ley A) (s : Finset I) (t : Finset J)
    (E : I → J → A → Prop) :
    evento p (fun x => ∃ i ∈ s, ∃ j ∈ t, E i j x) ≤
      ∑ i ∈ s, ∑ j ∈ t, evento p (E i j) := by
  classical
  have houter := evento_union_finset p s (fun i x => ∃ j ∈ t, E i j x)
  calc
    evento p (fun x => ∃ i ∈ s, ∃ j ∈ t, E i j x) ≤
        ∑ i ∈ s, evento p (fun x => ∃ j ∈ t, E i j x) := houter
    _ ≤ ∑ i ∈ s, ∑ j ∈ t, evento p (E i j) := by
      apply Finset.sum_le_sum
      intro i hi
      exact evento_union_finset p t (fun j x => E i j x)

theorem componer_perfiles_reinicios {I J : Type} (p : Ley A)
    (perfiles : Finset I) (reinicios : Finset J) (E : I → J → A → Prop)
    (cota : I → J → ℚ)
    (hE : ∀ i ∈ perfiles, ∀ j ∈ reinicios, evento p (E i j) ≤ cota i j) :
    evento p (fun x => ∃ i ∈ perfiles, ∃ j ∈ reinicios, E i j x) ≤
      ∑ i ∈ perfiles, ∑ j ∈ reinicios, cota i j := by
  calc
    evento p (fun x => ∃ i ∈ perfiles, ∃ j ∈ reinicios, E i j x) ≤
        ∑ i ∈ perfiles, ∑ j ∈ reinicios, evento p (E i j) :=
      evento_union_dos_indices p perfiles reinicios E
    _ ≤ ∑ i ∈ perfiles, ∑ j ∈ reinicios, cota i j := by
      apply Finset.sum_le_sum
      intro i hi
      apply Finset.sum_le_sum
      intro j hj
      exact hE i hi j hj

theorem tres_eventos (p : Ley A) (Acepta Malo Excepcional Consulta : A → Prop)
    (h : ∀ x, Acepta x → Malo x ∨ Excepcional x ∨ Consulta x) :
    evento p Acepta ≤ evento p Malo + evento p Excepcional + evento p Consulta := by
  exact (evento_monotono p Acepta _ h).trans
    ((evento_union p Malo (fun x => Excepcional x ∨ Consulta x)).trans
      (by linarith [evento_union p Excepcional Consulta]))

theorem transferir_ley (real ideal : Ley A) (E : A → Prop) (cota sesgo : ℚ)
    (hi : evento ideal E ≤ cota) (hs : distancia real ideal ≤ sesgo) :
    evento real E ≤ cota + sesgo := by
  have h := diferencia_evento_acotada real ideal E
  have h' := (le_abs_self (evento real E - evento ideal E)).trans (h.trans hs)
  linarith

@[expose] def cotaROM (S B : ℕ) : ℚ := ((S * (49 * S + B) : ℕ) : ℚ) / 2 ^ 256
@[expose] def cotaCompuesta (Q S B : ℕ) (excepciones sesgo trabajo omision cola : ℚ) : ℚ :=
  cotaROM S B + excepciones + sesgo + ((Q + 1 : ℕ) : ℚ) * trabajo * (omision + cola)

theorem componer_cotas (real : Ley A) (Acepta Malo Excepcional Consulta : A → Prop)
    (Q S B : ℕ) (excepciones sesgo trabajo omision cola : ℚ)
    (h : ∀ x, Acepta x → Malo x ∨ Excepcional x ∨ Consulta x)
    (hm : evento real Malo ≤ cotaROM S B)
    (he : evento real Excepcional ≤ excepciones + sesgo)
    (hc : evento real Consulta ≤ ((Q + 1 : ℕ) : ℚ) * trabajo * (omision + cola)) :
    evento real Acepta ≤ cotaCompuesta Q S B excepciones sesgo trabajo omision cola := by
  have ht := tres_eventos real Acepta Malo Excepcional Consulta h
  unfold cotaCompuesta
  linarith

theorem cortes_presupuestados (Q k R nA nV : ℕ) (ha : nA ≤ Q)
    (hv : nV ≤ Nexus.ROM.Presupuestos.verificadorPerfil k R) :
    nA + nV ≤ Q + Nexus.ROM.Presupuestos.verificadorPerfil k R := Nat.add_le_add ha hv

theorem cota_rom_sin_minimo (S B : ℕ) (p : Nexus.ROM.Plan B (Nexus.ROM.inicial B) S) :
    Nexus.ROM.riesgo p ≤ cotaROM S B := by
  exact (Nexus.ROM.cota_desde_vacio S B p).trans (min_le_right _ _)

end Nexus.ROM.Composicion
