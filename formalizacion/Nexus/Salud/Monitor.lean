module

public import Nexus.Salud.APT
import Mathlib.Tactic

/-!
# Monitores continuos RCT y APT

Modelo sobre naturales y muestras tipadas. Conserva el fallo, la referencia
incluida y la frontera de ventana; no verifica desbordamientos ni f64 de Rust.
-/

public section
namespace Nexus.Salud

structure CuentaRCT (A : Type*) where
  ultimo : Option A := none
  racha : ℕ := 0
  deriving DecidableEq

structure CuentaAPT (A : Type*) where
  referencia : Option A := none
  vistos : ℕ := 0
  cuenta : ℕ := 0
  deriving DecidableEq

structure Monitor (A : Type*) where
  rct : CuentaRCT A := {}
  apt : CuentaAPT A := {}
  fallo : Bool := false
  deriving DecidableEq

variable {A : Type*} [DecidableEq A]

@[expose] def actualizarRCT (C : ℕ) (s : CuentaRCT A) (x : A) : CuentaRCT A × Bool :=
  if s.ultimo = some x then (⟨some x, s.racha + 1⟩, decide (C ≤ s.racha + 1))
  else (⟨some x, 1⟩, false)

@[expose] def actualizarAPT (W C : ℕ) (s : CuentaAPT A) (x : A) : CuentaAPT A × Bool :=
  match s.referencia with
  | none => (⟨some x, 1, 1⟩, false)
  | some a =>
    let n := s.vistos + 1
    let b := s.cuenta + if x = a then 1 else 0
    let f := decide (x = a ∧ C ≤ b)
    (if W ≤ n then {} else ⟨some a, n, b⟩, f)

@[expose] def pasoMonitor (R W C : ℕ) (s : Monitor A) (x : A) : Monitor A :=
  if s.fallo then s else
    let r := actualizarRCT R s.rct x
    let a := actualizarAPT W C s.apt x
    ⟨r.1, a.1, r.2 || a.2⟩

@[expose] def alimentarMonitor (R W C : ℕ) (s : Monitor A) (xs : List A) : Monitor A :=
  xs.foldl (pasoMonitor R W C) s

@[expose] def APTValida (W : ℕ) (s : CuentaAPT A) : Prop :=
  match s.referencia with
  | none => s.vistos = 0 ∧ s.cuenta = 0
  | some _ => 1 ≤ s.vistos ∧ s.vistos < W ∧ 1 ≤ s.cuenta ∧ s.cuenta ≤ s.vistos

theorem fallo_monitor_retenido (R W C : ℕ) (s : Monitor A) (x : A) (hf : s.fallo = true) :
    pasoMonitor R W C s x = s := by simp only [pasoMonitor, hf, ite_true]

theorem fallo_monitor_lote (R W C : ℕ) (s : Monitor A) (xs : List A) (hf : s.fallo = true) :
    alimentarMonitor R W C s xs = s := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simpa only [alimentarMonitor, List.foldl_cons, fallo_monitor_retenido R W C s x hf] using ih

theorem alimentar_monitor_troceado (R W C : ℕ) (s : Monitor A) (xs ys : List A) :
    alimentarMonitor R W C s (xs ++ ys) = alimentarMonitor R W C (alimentarMonitor R W C s xs) ys := by
  exact List.foldl_append

theorem rct_incrementa (C : ℕ) (s : CuentaRCT A) (x : A) (hx : s.ultimo = some x) :
    (actualizarRCT C s x).1.racha = s.racha + 1 := by simp only [actualizarRCT, hx, ite_true]

theorem rct_cambia_valor (C : ℕ) (s : CuentaRCT A) (x : A) (hx : s.ultimo ≠ some x) :
    (actualizarRCT C s x).1.racha = 1 ∧ (actualizarRCT C s x).2 = false := by
  simp only [actualizarRCT, hx, ite_false, and_self]

theorem apt_incluye_referencia (W C : ℕ) (x : A) :
    (actualizarAPT W C ({} : CuentaAPT A) x).1 = ⟨some x, 1, 1⟩ := rfl

theorem apt_cierra_ventana (W C : ℕ) (s : CuentaAPT A) (x a : A)
    (ha : s.referencia = some a) (hW : W ≤ s.vistos + 1) :
    (actualizarAPT W C s x).1 = {} := by simp only [actualizarAPT, ha, hW, ite_true]

theorem apt_no_coincide (W C : ℕ) (s : CuentaAPT A) (x a : A)
    (ha : s.referencia = some a) (hx : x ≠ a) (hW : s.vistos + 1 < W) :
    (actualizarAPT W C s x).1.cuenta = s.cuenta := by
  simp only [actualizarAPT, ha, hx, ite_false, Nat.add_zero, not_le_of_gt hW]

theorem apt_preserva_invariante (W C : ℕ) (hW : 2 ≤ W) (s : CuentaAPT A) (x : A)
    (hs : APTValida W s) : APTValida W (actualizarAPT W C s x).1 := by
  cases ha : s.referencia with
  | none => simp only [actualizarAPT, ha, APTValida]; omega
  | some a =>
    simp only [APTValida, ha] at hs
    by_cases hn : W ≤ s.vistos + 1
    · simp [actualizarAPT, ha, hn, APTValida]
    · by_cases hx : x = a <;> simp [actualizarAPT, ha, hn, hx, APTValida] <;> omega

theorem rct_continua_entre_ventanas (R W C : ℕ) (s : Monitor A) (x : A) (hf : s.fallo = false) :
    (pasoMonitor R W C s x).rct = (actualizarRCT R s.rct x).1 := by
  simp only [pasoMonitor, hf, Bool.false_eq_true, ite_false]

theorem alarma_rct_detectada (R W C : ℕ) (s : Monitor A) (x : A)
    (hf : s.fallo = false) (hx : s.rct.ultimo = some x) (hR : R ≤ s.rct.racha + 1) :
    (pasoMonitor R W C s x).fallo = true := by
  simp [pasoMonitor, hf, actualizarRCT, hx, hR]

theorem alarma_apt_detectada (R W C : ℕ) (s : Monitor A) (x : A)
    (hf : s.fallo = false) (hx : s.apt.referencia = some x) (hC : C ≤ s.apt.cuenta + 1) :
    (pasoMonitor R W C s x).fallo = true := by
  have ha : (actualizarAPT W C s.apt x).2 = true := by simp [actualizarAPT, hx, hC]
  simp only [pasoMonitor, hf, Bool.false_eq_true, ite_false, ha, Bool.or_true]

theorem monitor_preserva_invariante (R W C : ℕ) (hW : 2 ≤ W) (s : Monitor A) (x : A)
    (hs : APTValida W s.apt) : APTValida W (pasoMonitor R W C s x).apt := by
  cases hf : s.fallo
  · simpa only [pasoMonitor, hf, Bool.false_eq_true, ite_false] using apt_preserva_invariante W C hW s.apt x hs
  · simpa only [fallo_monitor_retenido R W C s x hf] using hs

end Nexus.Salud
