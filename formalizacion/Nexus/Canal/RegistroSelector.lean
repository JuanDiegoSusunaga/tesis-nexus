module

public import Nexus.Canal.SelectorOrdenado
public import Nexus.ROM.RegistroPrograma
import Mathlib.Tactic

/-!
# La continuación aceptada del selector está en su registro

La muestra se conserva en orden y la inclusión se deriva del camino de
ejecución, aunque haya índices duplicados antes de alcanzar cuarenta.
-/

public section
namespace Nexus.Canal.RegistroSelector

open Nexus.Bytes Nexus.Merkle Nexus.ROM.ProgramaCompartido Nexus.ROM.RegistroPrograma

theorem aceptacion_con_registro (H : List Octeto → Digest) (M : ℕ) (hM : 0 < M)
    (R : ℕ) (s : Digest) (S : List (Fin M)) (hs : S.Nodup) (c : List (Fin M) → Programa)
    (ha : resultado (tabla H) (SelectorOrdenado.seleccionar M hM R s S c) = true) :
    ∃ T, T.Nodup ∧ T.length = 40 ∧ resultado (tabla H) (c T) = true ∧
      List.Sublist (entradas H (c T)) (entradas H (SelectorOrdenado.seleccionar M hM R s S c)) := by
  induction R generalizing s S with
  | zero =>
    simp only [SelectorOrdenado.seleccionar] at ha ⊢
    split_ifs at ha with h
    · exact ⟨S, hs, h, ha, by rw [ite_eq_left h]⟩
    · contradiction
  | succ R ih =>
    by_cases hc : S.length = 40
    · have he : SelectorOrdenado.seleccionar M hM (R + 1) s S c = c S := by
        simp only [SelectorOrdenado.seleccionar, hc, ite_true]
      exact ⟨S, hs, hc, he ▸ ha, by rw [he]⟩
    · have hh : resultado (tabla H) (SelectorOrdenado.seleccionar M hM R
        (H (GramaticaTG2.codificar (.indice s)))
        (SelectorOrdenado.agregar S (ProgramaTG2.indice M hM (H (GramaticaTG2.codificar (.indice s))))) c) = true := by
        simpa only [SelectorOrdenado.seleccionar, hc, ite_false, resultado, tabla_codificacion] using ha
      obtain ⟨T, hT, hlen, hres, hlog⟩ := ih _ _ (SelectorOrdenado.agregar_sin_duplicados S _ hs) hh
      refine ⟨T, hT, hlen, hres, ?_⟩
      simpa only [SelectorOrdenado.seleccionar, hc, ite_false, entradas] using hlog.cons _

end Nexus.Canal.RegistroSelector
