module

public import Nexus.Canal.SelectorOrdenado
public import Nexus.ROM.PalabrasDigest
public import Nexus.ROM.RegistroPrograma
public import Nexus.ROM.ProgramaBytes
import Mathlib.Tactic

/-!
# El selector del canal evaluado mediante su cinta de respuestas

Para toda H, se despliega la cadena de entradas I durante R pasos y se
evalúa exactamente el programa de selección sobre esa cinta. El despliegue
puede extenderse después de completar cuarenta: esa cola es matemática y
no se atribuye al registro real. La ley de cintas independientes permanece
separada de la frescura de las direcciones, incluso con intercalaciones.
-/

public section
namespace Nexus.Canal.CintaSelector

open Nexus.Bytes Nexus.Merkle Nexus.ROM Nexus.ROM.ProgramaCompartido

@[expose] def cinta (H : Entrada → Digest) : ℕ → Digest → List Digest
  | 0, _ => []
  | R + 1, s => let d := H (entradaReto s .indice); d :: cinta H R d

@[expose] def indices (H : Entrada → Digest) (M : ℕ) (hM : 0 < M) (R : ℕ) (s : Digest) : List (Fin M) :=
  (cinta H R s).map (ProgramaTG2.indice M hM)

theorem longitud_cinta (H : Entrada → Digest) (R : ℕ) (s : Digest) : (cinta H R s).length = R := by
  induction R generalizing s with
  | zero => rfl
  | succ R ih => simp only [cinta, List.length_cons, ih]

theorem longitud_indices (H : Entrada → Digest) (M : ℕ) (hM : 0 < M) (R : ℕ) (s : Digest) :
    (indices H M hM R s).length = R := by simp only [indices, List.length_map, longitud_cinta]

theorem resultado_desde_cinta (H : Entrada → Digest) (M : ℕ) (hM : 0 < M) (R : ℕ)
    (s : Digest) (S : Finset (Fin M)) (hS : S.card ≤ 40) (continuar : Finset (Fin M) → Programa) :
    resultado (RegistroPrograma.tabla H) (ProgramaTG2.seleccionar M hM R s S continuar) =
      let T := Selector.seleccionar 40 S (indices H M hM R s)
      if T.card = 40 then resultado (RegistroPrograma.tabla H) (continuar T) else false := by
  induction R generalizing s S with
  | zero =>
    by_cases hf : S.card = 40 <;>
      simp only [ProgramaTG2.seleccionar, indices, cinta, List.map_nil, Selector.seleccionar, hf, resultado,
        ite_true, ite_false]
  | succ R ih =>
    by_cases hf : S.card = 40
    · simp [ProgramaTG2.seleccionar, hf, indices, cinta, Selector.seleccionar]
    · have hn : ¬ 40 ≤ S.card := by omega
      have hi : (insert (ProgramaTG2.indice M hM (H (entradaReto s .indice))) S).card ≤ 40 :=
        (Finset.card_insert_le _ _).trans (by omega)
      have hrec := ih (H (entradaReto s .indice)) _ hi
      simp only [ProgramaTG2.seleccionar, hf, ite_false, resultado,
        RegistroPrograma.tabla_codificacion, GramaticaTG2.codificar, indices, cinta, List.map_cons,
        Selector.seleccionar, hn]
      simp only [indices] at hrec
      convert hrec using 1
      congr!

theorem resultado_ordenado_desde_cinta (H : Entrada → Digest) (M : ℕ) (hM : 0 < M)
    (R : ℕ) (s : Digest) (S : List (Fin M)) (hs : S.Nodup) (hS : S.length ≤ 40)
    (continuar : Finset (Fin M) → Programa) :
    resultado (RegistroPrograma.tabla H)
        (SelectorOrdenado.seleccionar M hM R s S (fun xs => continuar xs.toFinset)) =
      let T := Selector.seleccionar 40 S.toFinset (indices H M hM R s)
      if T.card = 40 then resultado (RegistroPrograma.tabla H) (continuar T) else false := by
  rw [SelectorOrdenado.proyeccion_conjuntos M hM R s S hs continuar]
  exact resultado_desde_cinta H M hM R s _ (by simpa only [List.toFinset_card_of_nodup hs] using hS) continuar

theorem vacio_completa_iff (H : Entrada → Digest) (M : ℕ) (hM : 0 < M) (R : ℕ) (s : Digest) :
    resultado (RegistroPrograma.tabla H) (ProgramaTG2.seleccionar M hM R s ∅ (fun _ => .terminar true)) = true ↔
      40 ≤ (indices H M hM R s).toFinset.card := by
  rw [resultado_desde_cinta H M hM R s ∅ (by simp)]
  simp only [resultado, ite_eq_left_iff, Bool.false_eq_true, imp_false, not_not]
  exact Selector.vacio_completa_iff 40 _

end Nexus.Canal.CintaSelector
