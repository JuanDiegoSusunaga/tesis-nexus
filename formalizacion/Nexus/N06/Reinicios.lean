module

public import Nexus.N06.Experimento
import Mathlib.Tactic

/-!
# Árboles adaptativos con estados guardados y restauraciones ideales

Cada reto se emite desde un estado previamente guardado. Restaurarlo no
consume monedas nuevas. Los mensajes pueden añadir estados conservando
su marca; cada respuesta fresca añade un estado y consume un intento.
-/

public section
namespace Nexus.N06

variable {V Q : Type} (A : Q → Type) (origen : Q → V)
    (destino : (q : Q) → A q → V) (marca : V → Bool)

inductive PlanRestaurable : List V → ℕ → Type where
  | terminar (h : List V) (n : ℕ) : PlanRestaurable h n
  | mensaje {h : List V} {n : ℕ} (v : V) (hv : v ∈ h) (w : V)
      (hm : marca w = marca v) (resto : PlanRestaurable (w :: h) n) : PlanRestaurable h n
  | nuevo {h : List V} {n : ℕ} (q : Q) (hq : origen q ∈ h)
      (resto : (x : A q) → PlanRestaurable (destino q x :: h) n) : PlanRestaurable h (n + 1)

@[expose] def RegistroCero (h : List V) : Prop := ∀ v ∈ h, marca v = false

@[expose] def RegistroMarcado (h : List V) : Prop := ∃ v ∈ h, marca v = true

variable [∀ q, Fintype (A q)] [∀ q, Nonempty (A q)]

/-- La probabilidad se obtiene de medias condicionales; los tipos de respuesta
pueden ser distintos para cada petición y depender de la historia. -/
@[expose] noncomputable def valorRestaurable (fin : List V → ℚ) :
    {h : List V} → {n : ℕ} → PlanRestaurable A origen destino marca h n → ℚ
  | _, _, .terminar h _ => fin h
  | _, _, .mensaje _ _ _ _ resto => valorRestaurable fin resto
  | _, _, .nuevo q _ resto => promedio (fun x : A q => valorRestaurable fin (resto x))

@[expose] noncomputable def riesgoRestaurable {h : List V} {n : ℕ}
    (p : PlanRestaurable A origen destino marca h n) : ℚ := by
  classical
  exact valorRestaurable A origen destino marca
    (fun h => if RegistroMarcado marca h then 1 else 0) p

@[expose] noncomputable def cambioFresco (q : Q) : ℚ := by
  classical
  exact promedio (fun x : A q => if marca (origen q) = false ∧ marca (destino q x) = true
    then 1 else 0)

omit [∀ q, Nonempty (A q)] in
theorem valor_restaurable_monotono (f g : List V → ℚ) (hfg : ∀ h, f h ≤ g h)
    {h : List V} {n : ℕ} (p : PlanRestaurable A origen destino marca h n) :
    valorRestaurable A origen destino marca f p ≤ valorRestaurable A origen destino marca g p := by
  induction p with
  | terminar h n => exact hfg h
  | mensaje v hv w hm resto ih => exact ih
  | nuevo q hq resto ih => exact promedio_monotono _ _ ih

theorem valor_restaurable_constante (c : ℚ) {h : List V} {n : ℕ}
    (p : PlanRestaurable A origen destino marca h n) :
    valorRestaurable A origen destino marca (fun _ => c) p = c := by
  induction p with
  | terminar h n => rfl
  | mensaje v hv w hm resto ih => exact ih
  | nuevo q hq resto ih =>
    change promedio (fun x : A q => valorRestaurable A origen destino marca (fun _ => c) (resto x)) = c
    simp only [ih, promedio_constante]

theorem riesgo_restaurable_no_negativo {h : List V} {n : ℕ}
    (p : PlanRestaurable A origen destino marca h n) : 0 ≤ riesgoRestaurable A origen destino marca p := by
  classical
  rw [← valor_restaurable_constante A origen destino marca 0 p]
  exact valor_restaurable_monotono A origen destino marca _ _ (by intro h; split_ifs <;> norm_num) p

theorem riesgo_restaurable_le_uno {h : List V} {n : ℕ}
    (p : PlanRestaurable A origen destino marca h n) : riesgoRestaurable A origen destino marca p ≤ 1 := by
  classical
  rw [← valor_restaurable_constante A origen destino marca 1 p]
  exact valor_restaurable_monotono A origen destino marca _ _ (by intro h; split_ifs <;> norm_num) p

/-- Una marca guardada no se pierde al restaurar otra rama. -/
theorem riesgo_registro_marcado {h : List V} {n : ℕ}
    (p : PlanRestaurable A origen destino marca h n) (hh : RegistroMarcado marca h) :
    riesgoRestaurable A origen destino marca p = 1 := by
  classical
  induction p with
  | terminar h n => simp only [riesgoRestaurable, valorRestaurable, hh, ite_eq_left]
  | mensaje v hv w hm resto ih =>
    apply ih
    obtain ⟨z, hz, hmz⟩ := hh
    exact ⟨z, List.mem_cons_of_mem w hz, hmz⟩
  | @nuevo h n q hq resto ih =>
    change promedio (fun x : A q => riesgoRestaurable A origen destino marca (resto x)) = 1
    have he : ∀ x, RegistroMarcado marca (destino q x :: h) := by
      intro x
      obtain ⟨z, hz, hmz⟩ := hh
      exact ⟨z, List.mem_cons_of_mem _ hz, hmz⟩
    simp only [fun x => ih x (he x), promedio_constante]

/-- Unión adaptativa sobre retos nuevos. Los eventos no se suponen independientes. -/
theorem riesgo_reinicios_cota (ε : ℚ) (hε : 0 ≤ ε)
    (hc : ∀ q, cambioFresco A origen destino marca q ≤ ε)
    {h : List V} {n : ℕ} (p : PlanRestaurable A origen destino marca h n)
    (hh : RegistroCero marca h) : riesgoRestaurable A origen destino marca p ≤ n * ε := by
  classical
  induction p with
  | terminar h n =>
    have hno : ¬ RegistroMarcado marca h := by
      rintro ⟨v, hv, hm⟩
      have hz := hh v hv
      simp only [hz, Bool.false_eq_true] at hm
    simp only [riesgoRestaurable, valorRestaurable, hno, reduceIte]
    positivity
  | mensaje v hv w hm resto ih =>
    apply ih
    intro z hz
    rcases List.mem_cons.mp hz with rfl | hz
    · exact hm.trans (hh v hv)
    · exact hh z hz
  | @nuevo h n q hq resto ih =>
    have hs : marca (origen q) = false := hh _ hq
    have hb : ∀ x : A q, riesgoRestaurable A origen destino marca (resto x) ≤
        (if marca (origen q) = false ∧ marca (destino q x) = true then 1 else 0) + n * ε := by
      intro x
      cases hx : marca (destino q x) with
      | false =>
        simp only [hs, Bool.false_eq_true, and_false, reduceIte, zero_add]
        apply ih x
        intro v hv
        rcases List.mem_cons.mp hv with rfl | hv
        · exact hx
        · exact hh v hv
      | true =>
        simp only [hs, and_self, reduceIte]
        exact (riesgo_restaurable_le_uno A origen destino marca (resto x)).trans
          (le_add_of_nonneg_right (by positivity))
    calc
      _ = promedio (fun x : A q => riesgoRestaurable A origen destino marca (resto x)) := rfl
      _ ≤ promedio (fun x : A q =>
          (if marca (origen q) = false ∧ marca (destino q x) = true then 1 else 0) + n * ε) :=
        promedio_monotono _ _ hb
      _ = cambioFresco A origen destino marca q + n * ε := by
        rw [promedio_suma, promedio_constante]
        rfl
      _ ≤ ε + n * ε := add_le_add (hc q) (le_refl _)
      _ = (n + 1 : ℕ) * ε := by push_cast; ring

theorem riesgo_reinicios_minimo (ε : ℚ) (hε : 0 ≤ ε)
    (hc : ∀ q, cambioFresco A origen destino marca q ≤ ε)
    {h : List V} {n : ℕ} (p : PlanRestaurable A origen destino marca h n)
    (hh : RegistroCero marca h) : riesgoRestaurable A origen destino marca p ≤ min 1 (n * ε) :=
  le_min (riesgo_restaurable_le_uno A origen destino marca p)
    (riesgo_reinicios_cota A origen destino marca ε hε hc p hh)

end Nexus.N06
