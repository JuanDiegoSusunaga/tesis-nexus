module

public import Nexus.Cripto.Firma
public import Mathlib.Order.Filter.AtTopBot.Basic
import Mathlib.Tactic

public section
namespace Nexus.Cripto

open Filter
open scoped ENNReal

/-- Familia no negativa dominada eventualmente por toda potencia inversa. -/
@[expose] def Despreciable (f : ℕ → ℝ) : Prop :=
  (∀ t, 0 ≤ f t) ∧ ∀ c : ℕ, ∀ᶠ t : ℕ in atTop, f t ≤ 1 / (t : ℝ) ^ c

theorem despreciable_cero : Despreciable (fun _ => 0) := by
  refine ⟨fun _ => le_rfl, ?_⟩
  intro c
  exact Eventually.of_forall (fun t => by positivity)

theorem despreciable_menor {f g : ℕ → ℝ} (hg : Despreciable g)
    (hf : ∀ t, 0 ≤ f t) (hle : ∀ t, f t ≤ g t) : Despreciable f := by
  refine ⟨hf, ?_⟩
  intro c
  exact (hg.2 c).mono (fun t ht => (hle t).trans ht)

theorem despreciable_suma {f g : ℕ → ℝ} (hf : Despreciable f) (hg : Despreciable g) :
    Despreciable (fun t => f t + g t) := by
  refine ⟨fun t => add_nonneg (hf.1 t) (hg.1 t), ?_⟩
  intro c
  filter_upwards [hf.2 (c + 1), hg.2 (c + 1), eventually_ge_atTop 2] with t hft hgt ht
  have ht' : (2 : ℝ) ≤ t := by exact_mod_cast ht
  have hp : 0 < (t : ℝ) ^ c := pow_pos (by linarith) _
  have hp' : 0 < (t : ℝ) ^ (c + 1) := pow_pos (by linarith) _
  have hdiv : 2 / (t : ℝ) ^ (c + 1) ≤ 1 / (t : ℝ) ^ c := by
    apply (div_le_div_iff₀ hp' hp).mpr
    rw [pow_succ]
    nlinarith
  calc
    f t + g t ≤ 1 / (t : ℝ) ^ (c + 1) + 1 / (t : ℝ) ^ (c + 1) := add_le_add hft hgt
    _ = 2 / (t : ℝ) ^ (c + 1) := by ring
    _ ≤ _ := hdiv

variable {PK SK M S : ℕ → Type*}

/-- La clase de adversarios eficientes se declara como parámetro del modelo. -/
@[expose] def SeguridadEUF
    (familia : ∀ t, Esquema (PK t) (SK t) (M t) (S t)) (Q : ℕ → ℕ)
    (Eficiente : (∀ t, PK t → PMF (Programa (M t) (S t) (M t × S t) (Q t))) → Prop) : Prop :=
  ∀ adversario, Eficiente adversario →
    Despreciable (fun t => (ventajaEUF (familia t) (Q t) (adversario t)).toReal)

@[expose] def SeguridadSUF
    (familia : ∀ t, Esquema (PK t) (SK t) (M t) (S t)) (Q : ℕ → ℕ)
    (Eficiente : (∀ t, PK t → PMF (Programa (M t) (S t) (M t × S t) (Q t))) → Prop) : Prop :=
  ∀ adversario, Eficiente adversario →
    Despreciable (fun t => (ventajaSUF (familia t) (Q t) (adversario t)).toReal)

/-- El error pertenece a [0,1], de modo que su conversión a real conserva el valor. -/
@[expose] def CorreccionAsintotica
    (familia : ∀ t, Esquema (PK t) (SK t) (M t) (S t)) : Prop :=
  ∃ epsilon : ℕ → ℝ≥0∞, (∀ t, epsilon t ≤ 1) ∧
    Despreciable (fun t => (epsilon t).toReal) ∧
    ∀ t, Correccion (familia t) (epsilon t)

theorem correccion_perfecta_asintotica
    (familia : ∀ t, Esquema (PK t) (SK t) (M t) (S t))
    (he : ∀ t, CorreccionPerfecta (familia t)) : CorreccionAsintotica familia := by
  refine ⟨fun _ => 0, fun _ => zero_le, ?_, fun t => correccion_cero (familia t) (he t)⟩
  simpa only [ENNReal.toReal_zero] using despreciable_cero

theorem seguridad_suf_implica_euf
    (familia : ∀ t, Esquema (PK t) (SK t) (M t) (S t)) (Q : ℕ → ℕ)
    (Eficiente : (∀ t, PK t → PMF (Programa (M t) (S t) (M t × S t) (Q t))) → Prop)
    (hs : SeguridadSUF familia Q Eficiente) : SeguridadEUF familia Q Eficiente := by
  intro adversario ha
  apply despreciable_menor (hs adversario ha) (fun _ => ENNReal.toReal_nonneg)
  intro t
  apply ENNReal.toReal_mono
  · exact probabilidad_finita _ _
  · exact ventaja_euf_le_suf (familia t) (Q t) (adversario t)

/-- Ejemplo mínimo que distingue mensajes nuevos de pares nuevos para un mismo adversario. -/
@[expose] noncomputable def esquemaDosFirmas : Esquema Unit Unit Unit Bool where
  keyGen := PMF.pure ((), ())
  sign := fun _ _ => PMF.pure false
  verify := fun _ _ _ => true

@[expose] noncomputable def adversarioCambiaFirma :
    Unit → PMF (Programa Unit Bool (Unit × Bool) 1) :=
  fun _ => PMF.pure (.consultar () (fun _ => .terminar ((), true)))

theorem ensayo_dos_firmas :
    ensayoCMA esquemaDosFirmas 1 adversarioCambiaFirma =
      PMF.pure ((), (((), true), [((), false)])) := by
  simp only [ensayoCMA, esquemaDosFirmas, adversarioCambiaFirma, PMF.pure_bind,
    ejecutar, PMF.pure_map, List.nil_append]

theorem mensaje_consultado_no_gana_euf : ventajaEUF esquemaDosFirmas 1 adversarioCambiaFirma = 0 := by
  classical
  rw [ventajaEUF, ensayo_dos_firmas, probabilidad_pura]
  simp [GanaEUF, esquemaDosFirmas]

theorem par_nuevo_gana_suf : ventajaSUF esquemaDosFirmas 1 adversarioCambiaFirma = 1 := by
  classical
  rw [ventajaSUF, ensayo_dos_firmas, probabilidad_pura]
  simp [GanaSUF, esquemaDosFirmas]

end Nexus.Cripto
