module

public import Nexus.Salud.Monitor
import Mathlib.Tactic

/-!
# Bloqueo, lotes y recuperación del perfil del manuscrito

Modelo exacto con naturales y reales: lote 65536, RCT=4, APT=16, W=512.
No representa secretos ni afirma calificación física, f64 o secrecia hacia adelante.
-/

public section
namespace Nexus.Salud

inductive EstadoEvaluacion where
  | sinEvaluar | sana | falloSalud | bajaEntropia | recuperando | configuracionInvalida
  deriving DecidableEq

structure Fuente where
  estado : EstadoEvaluacion := .sinEvaluar
  monitor : Monitor (Fin 256) := {}
  histograma : Fin 256 → ℕ := fun _ => 0
  muestras : ℕ := 0
  estimacion : ℝ := 0
  renovarPendiente : Bool := false
  epoca : ℕ := 0
  usos : ℕ := 0
  edad : ℕ := 0

@[expose] def falloRetenido (s : Fuente) : Prop :=
  s.estado = .falloSalud ∨ s.estado = .bajaEntropia ∨ s.estado = .configuracionInvalida

@[expose] noncomputable def estimarFrecuencia (h : Fin 256 → ℕ) : ℝ :=
  -Real.logb 2 (((Finset.univ.sup h : ℕ) : ℝ) / 65536)

@[expose] noncomputable def ingresarMuestra (s : Fuente) (x : Fin 256) : Fuente := by
  classical
  exact if falloRetenido s then s else
    let m := pasoMonitor 4 512 16 s.monitor x
    if m.fallo then { s with monitor := m, estado := .falloSalud, renovarPendiente := true }
    else
      let h := Function.update s.histograma x (s.histograma x + 1)
      let n := s.muestras + 1
      if n = 65536 then
        let e := estimarFrecuencia h
        { s with
          monitor := m
          histograma := fun _ => 0
          muestras := 0
          estimacion := e
          estado := if e < 15 / 2 then .bajaEntropia else .sana
          renovarPendiente := if e < 15 / 2 then true else s.renovarPendiente }
      else { s with monitor := m, histograma := h, muestras := n }

@[expose] noncomputable def ingresarLote (s : Fuente) (xs : List (Fin 256)) : Fuente :=
  xs.foldl ingresarMuestra s

@[expose] def comenzarRecuperacion (s : Fuente) : Fuente :=
  if s.estado = .configuracionInvalida then s else
    { s with
      estado := .recuperando
      monitor := {}
      histograma := fun _ => 0
      muestras := 0
      estimacion := 0
      renovarPendiente := true }

@[expose] def saludOperativa (s : Fuente) : Prop := s.estado = .sana ∧ s.monitor.fallo = false

@[expose] def PuedeDerivar (cupo edadMax : ℕ) (s : Fuente) : Prop :=
  saludOperativa s ∧ s.renovarPendiente = false ∧ (15 / 2 : ℝ) ≤ s.estimacion ∧
    s.usos < cupo ∧ s.edad < edadMax

@[expose] noncomputable def derivar (cupo edadMax : ℕ) (s : Fuente) : Option Fuente := by
  classical
  exact if PuedeDerivar cupo edadMax s then some { s with usos := s.usos + 1 } else none

@[expose] noncomputable def rotar (materialFresco : Bool) (s : Fuente) : Option Fuente := by
  classical
  exact if saludOperativa s ∧ s.epoca < 2 ^ 64 - 1 ∧ materialFresco = true then
    some { s with epoca := s.epoca + 1, usos := 0, edad := 0, renovarPendiente := false }
  else none

theorem inicio_bloquea_derivacion (cupo edadMax : ℕ) : derivar cupo edadMax ({} : Fuente) = none := by
  simp [derivar, PuedeDerivar, saludOperativa]

theorem fallo_fuente_retenido (s : Fuente) (x : Fin 256) (hf : falloRetenido s) :
    ingresarMuestra s x = s := by simp only [ingresarMuestra, hf, ite_true]

theorem fallo_fuente_lote (s : Fuente) (xs : List (Fin 256)) (hf : falloRetenido s) :
    ingresarLote s xs = s := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simpa only [ingresarLote, List.foldl_cons, fallo_fuente_retenido s x hf] using ih

theorem ingresar_lote_troceado (s : Fuente) (xs ys : List (Fin 256)) :
    ingresarLote s (xs ++ ys) = ingresarLote (ingresarLote s xs) ys := by
  exact List.foldl_append

theorem recuperacion_reinicia_evaluacion (s : Fuente) (hs : s.estado ≠ .configuracionInvalida) :
    (comenzarRecuperacion s).muestras = 0 ∧ (comenzarRecuperacion s).histograma = (fun _ => 0) ∧
      (comenzarRecuperacion s).estimacion = 0 ∧ (comenzarRecuperacion s).renovarPendiente = true :=
  by simp only [comenzarRecuperacion, hs, ite_false, and_self]

theorem comenzar_recuperacion_bloquea (cupo edadMax : ℕ) (s : Fuente) :
    derivar cupo edadMax (comenzarRecuperacion s) = none := by
  unfold comenzarRecuperacion
  split_ifs with hs <;> simp [derivar, PuedeDerivar, saludOperativa, hs]

theorem recuperacion_parcial_bloquea (cupo edadMax : ℕ) (s : Fuente) (x : Fin 256)
    (hs : s.estado = .recuperando) (hn : s.muestras + 1 < 65536) :
    derivar cupo edadMax (ingresarMuestra s x) = none := by
  have hf : ¬ falloRetenido s := by simp only [falloRetenido, hs]; decide
  simp only [ingresarMuestra, hf, ite_false, ne_of_lt hn]
  split_ifs <;> simp [derivar, PuedeDerivar, saludOperativa, hs]

theorem derivacion_exitosa_politica (cupo edadMax : ℕ) (s t : Fuente)
    (h : derivar cupo edadMax s = some t) : PuedeDerivar cupo edadMax s ∧ t.usos = s.usos + 1 := by
  unfold derivar at h
  split_ifs at h with hp
  cases h
  exact ⟨hp, rfl⟩

theorem cupo_o_edad_bloquea (cupo edadMax : ℕ) (s : Fuente)
    (h : cupo ≤ s.usos ∨ edadMax ≤ s.edad) : derivar cupo edadMax s = none := by
  have hn : ¬ PuedeDerivar cupo edadMax s := by
    intro hp
    rcases h with hu | he
    · exact (not_lt_of_ge hu) hp.2.2.2.1
    · exact (not_lt_of_ge he) hp.2.2.2.2
  simp only [derivar, hn, ite_false]

theorem renovacion_pendiente_bloquea (cupo edadMax : ℕ) (s : Fuente)
    (h : s.renovarPendiente = true) : derivar cupo edadMax s = none := by
  simp [derivar, PuedeDerivar, h]

theorem rotacion_exige_salud (f : Bool) (s t : Fuente) (h : rotar f s = some t) : saludOperativa s := by
  unfold rotar at h
  split_ifs at h with hp
  exact hp.1

theorem rotacion_conserva_monitor_y_lote (f : Bool) (s t : Fuente) (h : rotar f s = some t) :
    t.monitor = s.monitor ∧ t.muestras = s.muestras ∧ t.histograma = s.histograma ∧
      t.estimacion = s.estimacion ∧ t.estado = s.estado := by
  unfold rotar at h
  split_ifs at h
  cases h
  exact ⟨rfl, rfl, rfl, rfl, rfl⟩

theorem rotacion_sin_material_bloquea (s : Fuente) : rotar false s = none := by simp [rotar]

theorem derivacion_respeta_cupo (cupo edadMax : ℕ) (s t : Fuente) (h : derivar cupo edadMax s = some t) :
    t.usos ≤ cupo := by
  have hp := derivacion_exitosa_politica cupo edadMax s t h
  rw [hp.2]
  exact hp.1.2.2.2.1

theorem ingreso_conserva_renovacion_pendiente (s : Fuente) (x : Fin 256)
    (hs : s.renovarPendiente = true) : (ingresarMuestra s x).renovarPendiente = true := by
  unfold ingresarMuestra
  dsimp only
  split_ifs <;> simp_all

theorem lote_conserva_renovacion_pendiente (s : Fuente) (xs : List (Fin 256))
    (hs : s.renovarPendiente = true) : (ingresarLote s xs).renovarPendiente = true := by
  induction xs generalizing s with
  | nil => exact hs
  | cons x xs ih => exact ih (ingresarMuestra s x) (ingreso_conserva_renovacion_pendiente s x hs)

theorem reevaluacion_sola_no_habilita (cupo edadMax : ℕ) (s : Fuente) (xs : List (Fin 256))
    (hs : s.estado ≠ .configuracionInvalida) :
    derivar cupo edadMax (ingresarLote (comenzarRecuperacion s) xs) = none := by
  exact renovacion_pendiente_bloquea cupo edadMax _
    (lote_conserva_renovacion_pendiente _ xs (by simp only [comenzarRecuperacion, hs, ite_false]))

theorem configuracion_invalida_no_recupera (s : Fuente) (hs : s.estado = .configuracionInvalida) :
    comenzarRecuperacion s = s := by simp only [comenzarRecuperacion, hs, ite_true]

theorem lote_completo_sano (s : Fuente) (x : Fin 256) (hf : ¬ falloRetenido s)
    (hm : (pasoMonitor 4 512 16 s.monitor x).fallo = false) (hn : s.muestras + 1 = 65536)
    (he : (15 / 2 : ℝ) ≤ estimarFrecuencia (Function.update s.histograma x (s.histograma x + 1))) :
    (ingresarMuestra s x).estado = .sana ∧ (ingresarMuestra s x).muestras = 0 := by
  simp [ingresarMuestra, hf, hm, hn, not_lt_of_ge he]

theorem fallo_del_monitor_bloquea_fuente (s : Fuente) (x : Fin 256) (hf : ¬ falloRetenido s)
    (hm : (pasoMonitor 4 512 16 s.monitor x).fallo = true) :
    (ingresarMuestra s x).estado = .falloSalud ∧ (ingresarMuestra s x).renovarPendiente = true := by
  simp only [ingresarMuestra, hf, ite_false, hm, ite_true, and_self]

theorem renovacion_sana_habilita_modelo (cupo edadMax : ℕ) (hc : 0 < cupo) (he : 0 < edadMax)
    (s : Fuente) (hs : saludOperativa s) (hp : s.epoca < 2 ^ 64 - 1)
    (hbar : (15 / 2 : ℝ) ≤ s.estimacion) :
    ∃ t, rotar true s = some t ∧ PuedeDerivar cupo edadMax t := by
  refine ⟨{ s with epoca := s.epoca + 1, usos := 0, edad := 0, renovarPendiente := false }, ?_, ?_⟩
  · simp only [rotar, hs, hp, and_self, ite_true]
  · exact ⟨hs, rfl, hbar, hc, he⟩

end Nexus.Salud
