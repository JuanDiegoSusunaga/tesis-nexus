module

public import Nexus.Salud.Fuente
import Mathlib.Tactic

/-!
# Límites de contadores durante ingreso y recuperación

Se conserva el invariante del lote en todas las ramas del modelo,
incluidas las de fallo. Los límites justifican incrementos de u64 para
este perfil; no prueban la implementación de log2 en coma flotante.
-/

public section
namespace Nexus.Salud.Lote

@[expose] def Valido (s : Fuente) : Prop :=
  s.muestras < 65536 ∧ ∀ i, s.histograma i ≤ s.muestras

theorem inicio_valido : Valido ({} : Fuente) := by simp [Valido]

theorem ingreso_preserva (s : Fuente) (x : Fin 256) (hs : Valido s) : Valido (ingresarMuestra s x) := by
  classical
  by_cases hf : falloRetenido s
  · simpa only [ingresarMuestra, hf, ite_true] using hs
  · by_cases hm : (pasoMonitor 4 512 16 s.monitor x).fallo = true
    · simpa only [ingresarMuestra, hf, ite_false, hm, ite_true, Valido] using hs
    · by_cases hn : s.muestras + 1 = 65536
      · simp only [ingresarMuestra, hf, ite_false, hm, hn, ite_true, Valido]
        simp
      · simp only [ingresarMuestra, hf, ite_false, hm, hn, Bool.false_eq_true, Valido]
        constructor
        · have hn' := hs.1
          omega
        · intro i
          by_cases hi : i = x
          · subst i
            simpa using Nat.add_le_add_right (hs.2 x) 1
          · simpa [hi] using (hs.2 i).trans (Nat.le_succ _)

theorem lote_preserva (s : Fuente) (xs : List (Fin 256)) (hs : Valido s) : Valido (ingresarLote s xs) := by
  induction xs generalizing s with
  | nil => exact hs
  | cons x xs ih => exact ih (ingresarMuestra s x) (ingreso_preserva s x hs)

theorem recuperacion_preserva (s : Fuente) (hs : Valido s) : Valido (comenzarRecuperacion s) := by
  unfold comenzarRecuperacion
  split_ifs
  · exact hs
  · simp [Valido]

theorem rotacion_preserva (s t : Fuente) (f : Bool) (hs : Valido s) (h : rotar f s = some t) : Valido t := by
  have hp := rotacion_conserva_monitor_y_lote f s t h
  simpa only [Valido, hp.2.1, hp.2.2.1] using hs

theorem contador_no_desborda (s : Fuente) (hs : Valido s) : s.muestras + 1 < 2 ^ 64 := by
  have hn := hs.1
  omega

theorem histograma_no_desborda (s : Fuente) (hs : Valido s) (i : Fin 256) :
    s.histograma i + 1 < 2 ^ 64 := by
  have hn := hs.1
  have hi := hs.2 i
  omega

theorem epoca_rotada_u64 (s t : Fuente) (f : Bool) (h : rotar f s = some t) : t.epoca < 2 ^ 64 := by
  unfold rotar at h
  split_ifs at h with hv
  cases h
  have hn := hv.2.1
  dsimp only
  omega

end Nexus.Salud.Lote
