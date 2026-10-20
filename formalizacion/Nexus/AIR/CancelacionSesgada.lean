module

public import Nexus.Cripto.Variacion
public import Nexus.AIR.Solucion
public import Nexus.AIR.Grados
import Mathlib.Tactic

public section
namespace Nexus.AIR.CancelacionSesgada

open scoped BigOperators
open Nexus.Cripto.Variacion
variable {A B : Type} [Fintype A] [Fintype B]

/-- Un suceso con a lo sumo un resultado no supera la masa máxima. -/
theorem evento_unico_le (p : Ley A) (E : A → Prop) (mu : ℚ) (hmu : 0 ≤ mu)
    (hmasa : ∀ a, p.peso a ≤ mu) (hunico : ∀ a b, E a → E b → a = b) :
    evento p E ≤ mu := by
  classical
  by_cases hex : ∃ a, E a
  · obtain ⟨a, ha⟩ := hex
    have he : ∀ b, E b ↔ b = a := fun b =>
      ⟨fun hb => hunico b a hb ha, fun hb => hb ▸ ha⟩
    simp only [evento, he]
    simpa using hmasa a
  · have he : ∀ a, ¬ E a := by simpa using hex
    simpa [evento, he] using hmu

/-- Primero se obtiene el contexto; después un reto con ley condicionada a él. -/
@[expose] noncomputable def condicional (q : Ley B) (p : B → Ley A) : Ley (B × A) where
  peso x := q.peso x.1 * (p x.1).peso x.2
  noNegativo x := mul_nonneg (q.noNegativo _) ((p _).noNegativo _)
  normalizada := by
    rw [Fintype.sum_prod_type]
    simp only [← Finset.mul_sum, (p _).normalizada, mul_one, q.normalizada]

theorem evento_condicional (q : Ley B) (p : B → Ley A) (E : B → A → Prop) :
    evento (condicional q p) (fun x => E x.1 x.2) =
      ∑ b, q.peso b * evento (p b) (E b) := by
  classical
  rw [evento, Fintype.sum_prod_type]
  apply Finset.sum_congr rfl
  intro b _
  rw [evento, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro a _
  by_cases h : E b a <;> simp [condicional, h]

theorem cota_condicional_evento (q : Ley B) (p : B → Ley A) (E : B → A → Prop)
    (mu : ℚ) (hmu : 0 ≤ mu) (hmasa : ∀ b a, (p b).peso a ≤ mu)
    (hunico : ∀ b a c, E b a → E b c → a = c) :
    evento (condicional q p) (fun x => E x.1 x.2) ≤ mu := by
  rw [evento_condicional]
  calc
    _ ≤ ∑ b, q.peso b * mu := Finset.sum_le_sum (fun b _ =>
      mul_le_mul_of_nonneg_left (evento_unico_le (p b) (E b) mu hmu (hmasa b) (hunico b))
        (q.noNegativo b))
    _ = mu := by rw [← Finset.sum_mul, q.normalizada, one_mul]

variable {K : Type} [Field K] [Fintype K]

/-- La traza y el contexto pueden variar; el coeficiente se obtiene después. -/
theorem cota_condicional_lineal (q : Ley B) (p : B → Ley K)
    (r s : B → Polynomial K) (hr : ∀ b, r b ≠ 0)
    (mu : ℚ) (hmu : 0 ≤ mu) (hmasa : ∀ b a, (p b).peso a ≤ mu) :
    evento (condicional q p) (fun x => x.2 • r x.1 + s x.1 = 0) ≤ mu := by
  apply cota_condicional_evento q p (fun b a => a • r b + s b = 0) mu hmu hmasa
  intro b a c ha hc
  exact Nexus.N01.coeficiente_unico (r b) (s b) (hr b) a c ha hc

omit [Field K] in
theorem cota_producto_evento (p : Ley K) (q : Ley B) (E : K × B → Prop)
    (mu : ℚ) (hmu : 0 ≤ mu) (hmasa : ∀ a, p.peso a ≤ mu)
    (hunico : ∀ b a c, E (a, b) → E (c, b) → a = c) :
    evento (producto p q) E ≤ mu := by
  classical
  have he : evento (producto p q) E =
      evento (condicional q (fun _ => p)) (fun x => E (x.2, x.1)) := by
    rw [evento, evento, Fintype.sum_prod_type, Fintype.sum_prod_type, Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro b _
    apply Finset.sum_congr rfl
    intro a _
    by_cases h : E (a, b) <;> simp [producto, condicional, h, mul_comm]
  rw [he]
  exact cota_condicional_evento q (fun _ => p) (fun b a => E (a, b))
    mu hmu (fun _ => hmasa) hunico

theorem cota_primera (p0 p1 p2 : Ley K) (r0 r1 r2 : Polynomial K)
    (hr : r0 ≠ 0) (mu : ℚ) (hmu : 0 ≤ mu) (hmasa : ∀ a, p0.peso a ≤ mu) :
    evento (producto p0 (producto p1 p2))
      (fun a => Nexus.N01.combinacion r0 r1 r2 a = 0) ≤ mu := by
  apply cota_producto_evento p0 (producto p1 p2) _ mu hmu hmasa
  intro b a c ha hc
  apply Nexus.N01.coeficiente_unico r0 (b.1 • r1 + b.2 • r2) hr a c
  · simpa [Nexus.N01.combinacion, add_assoc] using ha
  · simpa [Nexus.N01.combinacion, add_assoc] using hc

omit [Field K] in
theorem intercambio_primeras (p0 p1 p2 : Ley K) (E : Nexus.N01.Coeficientes K → Prop) :
    evento (producto p0 (producto p1 p2)) E =
      evento (producto p1 (producto p0 p2)) (fun a => E (a.2.1, a.1, a.2.2)) := by
  classical
  simp only [evento, Fintype.sum_prod_type, producto]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro b _
  apply Finset.sum_congr rfl
  intro a _
  apply Finset.sum_congr rfl
  intro c _
  split_ifs <;> ring

omit [Field K] in
theorem intercambio_ultimas (p0 p1 p2 : Ley K) (E : Nexus.N01.Coeficientes K → Prop) :
    evento (producto p0 (producto p1 p2)) E =
      evento (producto p0 (producto p2 p1)) (fun a => E (a.1, a.2.2, a.2.1)) := by
  classical
  simp only [evento, Fintype.sum_prod_type, producto]
  apply Finset.sum_congr rfl
  intro a _
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro c _
  apply Finset.sum_congr rfl
  intro b _
  split_ifs <;> ring

theorem cota_tres (p0 p1 p2 : Ley K) (r0 r1 r2 : Polynomial K)
    (hr : r0 ≠ 0 ∨ r1 ≠ 0 ∨ r2 ≠ 0) (mu : ℚ) (hmu : 0 ≤ mu)
    (h0 : ∀ a, p0.peso a ≤ mu) (h1 : ∀ a, p1.peso a ≤ mu)
    (h2 : ∀ a, p2.peso a ≤ mu) :
    evento (producto p0 (producto p1 p2))
      (fun a => Nexus.N01.combinacion r0 r1 r2 a = 0) ≤ mu := by
  rcases hr with hr | hr | hr
  · exact cota_primera p0 p1 p2 r0 r1 r2 hr mu hmu h0
  · rw [intercambio_primeras]
    have he : ∀ a : Nexus.N01.Coeficientes K,
        Nexus.N01.combinacion r0 r1 r2 (a.2.1, a.1, a.2.2) =
          Nexus.N01.combinacion r1 r0 r2 a := by
      intro a
      simp [Nexus.N01.combinacion, add_comm]
    simp_rw [he]
    exact cota_primera p1 p0 p2 r1 r0 r2 hr mu hmu h1
  · rw [intercambio_ultimas, intercambio_primeras]
    have he : ∀ a : Nexus.N01.Coeficientes K,
        Nexus.N01.combinacion r0 r1 r2 (a.2.1, a.2.2, a.1) =
          Nexus.N01.combinacion r2 r0 r1 a := by
      intro a
      simp [Nexus.N01.combinacion, add_comm, add_assoc]
    simp_rw [he]
    exact cota_primera p2 p0 p1 r2 r0 r1 hr mu hmu h2

/-- La cota de masa se aplica a una traza fija inválida y retos independientes. -/
theorem cota_traza_invalida (p0 p1 p2 : Ley K) (T : ℕ) (hT : 3 ≤ T)
    (g : K) (hg : IsPrimitiveRoot g T) (f : Polynomial K) (s o : K)
    (hinvalida : ¬ Nexus.AIR.Valida g T f s o) (mu : ℚ) (hmu : 0 ≤ mu)
    (h0 : ∀ a, p0.peso a ≤ mu) (h1 : ∀ a, p1.peso a ≤ mu)
    (h2 : ∀ a, p2.peso a ≤ mu) :
    evento (producto p0 (producto p1 p2)) (fun a =>
      Nexus.AIR.numeradorCombinado T g f s o a % Nexus.AIR.denominador T = 0) ≤ mu := by
  unfold Nexus.AIR.numeradorCombinado
  simp_rw [Nexus.AIR.resto_combinacion]
  exact cota_tres p0 p1 p2 _ _ _
    (Nexus.AIR.invalida_residuo_no_nulo T g f s o hT hg hinvalida) mu hmu h0 h1 h2

end Nexus.AIR.CancelacionSesgada
