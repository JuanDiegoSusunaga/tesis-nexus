module

public import Nexus.N06.Reinicios
import Mathlib.Tactic

/-!
# Primera transición excepcional y aceptación de un registro restaurable

Se comprueba que una aceptación guardada implica una marca, y que toda
marca desde un registro inicial cero procede de algún reto fresco.
-/

public section
namespace Nexus.N06

variable {V Q : Type} (A : Q → Type) (origen : Q → V)
    (destino : (q : Q) → A q → V) (marca : V → Bool)
    [∀ q, Fintype (A q)] [∀ q, Nonempty (A q)]

/-- El primer cambio es absorbente en esta probabilidad, incluso si después
se restaura un estado anterior cuya marca sigue siendo cero. -/
@[expose] noncomputable def probabilidadPrimerCambio :
    {h : List V} → {n : ℕ} → PlanRestaurable A origen destino marca h n → ℚ
  | _, _, .terminar _ _ => 0
  | _, _, .mensaje _ _ _ _ resto => probabilidadPrimerCambio resto
  | _, _, .nuevo q _ resto => by
      classical
      exact promedio (fun x : A q =>
        if marca (origen q) = false ∧ marca (destino q x) = true then 1
        else probabilidadPrimerCambio (resto x))

theorem registro_marcado_iff_primer_cambio {h : List V} {n : ℕ}
    (p : PlanRestaurable A origen destino marca h n) (hh : RegistroCero marca h) :
    riesgoRestaurable A origen destino marca p = probabilidadPrimerCambio A origen destino marca p := by
  classical
  induction p with
  | terminar h n =>
    have hno : ¬ RegistroMarcado marca h := by
      rintro ⟨v, hv, hm⟩
      have hz := hh v hv
      simp only [hz, Bool.false_eq_true] at hm
    simp only [riesgoRestaurable, valorRestaurable, hno, reduceIte, probabilidadPrimerCambio]
  | mensaje v hv w hm resto ih =>
    apply ih
    intro z hz
    rcases List.mem_cons.mp hz with rfl | hz
    · exact hm.trans (hh v hv)
    · exact hh z hz
  | @nuevo h n q hq resto ih =>
    have hs := hh _ hq
    change promedio (fun x : A q => riesgoRestaurable A origen destino marca (resto x)) = _
    rw [probabilidadPrimerCambio]
    congr 1
    funext x
    cases hx : marca (destino q x) with
    | false =>
      simp only [hs, Bool.false_eq_true, and_false, reduceIte]
      apply ih x
      intro v hv
      rcases List.mem_cons.mp hv with rfl | hv
      · exact hx
      · exact hh v hv
    | true =>
      simp only [hs, and_self, reduceIte]
      exact riesgo_registro_marcado A origen destino marca (resto x) ⟨_, by simp, hx⟩

@[expose] noncomputable def probabilidadAceptarRegistro (P : V → Prop)
    {h : List V} {n : ℕ} (p : PlanRestaurable A origen destino marca h n) : ℚ := by
  classical
  exact valorRestaurable A origen destino marca (fun h => if ∃ v ∈ h, P v then 1 else 0) p

omit [∀ q, Nonempty (A q)] in
theorem aceptar_registro_le_riesgo (P : V → Prop) (hp : ∀ v, P v → marca v = true)
    {h : List V} {n : ℕ} (p : PlanRestaurable A origen destino marca h n) :
    probabilidadAceptarRegistro A origen destino marca P p ≤ riesgoRestaurable A origen destino marca p := by
  classical
  apply valor_restaurable_monotono
  intro h
  by_cases ha : ∃ v ∈ h, P v
  · have hm : RegistroMarcado marca h := by
      obtain ⟨v, hv, hP⟩ := ha
      exact ⟨v, hv, hp v hP⟩
    simp only [ha, hm, reduceIte, le_refl]
  · simp only [ha, reduceIte]
    split_ifs <;> norm_num

theorem aceptacion_reinicios_cota (P : V → Prop) (hp : ∀ v, P v → marca v = true)
    (ε : ℚ) (hε : 0 ≤ ε) (hc : ∀ q, cambioFresco A origen destino marca q ≤ ε)
    {h : List V} {n : ℕ} (p : PlanRestaurable A origen destino marca h n)
    (hh : RegistroCero marca h) :
    probabilidadAceptarRegistro A origen destino marca P p ≤ min 1 (n * ε) :=
  (aceptar_registro_le_riesgo A origen destino marca P hp p).trans
    (riesgo_reinicios_minimo A origen destino marca ε hε hc p hh)

theorem aceptacion_desde_raiz (P : V → Prop) (hp : ∀ v, P v → marca v = true)
    (ε : ℚ) (hε : 0 ≤ ε) (hc : ∀ q, cambioFresco A origen destino marca q ≤ ε)
    (raiz : V) (hr : marca raiz = false) (B : ℕ)
    (p : PlanRestaurable A origen destino marca [raiz] B) :
    probabilidadAceptarRegistro A origen destino marca P p ≤ min 1 (B * ε) := by
  apply aceptacion_reinicios_cota A origen destino marca P hp ε hε hc p
  intro v hv
  have he : v = raiz := List.mem_singleton.mp hv
  exact he ▸ hr

theorem aceptacion_planes_promedio {S : Type} [Fintype S] [Nonempty S]
    (P : V → Prop) (hp : ∀ v, P v → marca v = true)
    (ε : ℚ) (hε : 0 ≤ ε) (hc : ∀ q, cambioFresco A origen destino marca q ≤ ε)
    (raiz : V) (hr : marca raiz = false) (B : ℕ)
    (planes : S → PlanRestaurable A origen destino marca [raiz] B) :
    promedio (fun s => probabilidadAceptarRegistro A origen destino marca P (planes s)) ≤ min 1 (B * ε) := by
  apply (promedio_monotono _ (fun _ => min 1 (B * ε)) ?_).trans_eq (promedio_constante _)
  intro s
  exact aceptacion_desde_raiz A origen destino marca P hp ε hε hc raiz hr B (planes s)

end Nexus.N06
