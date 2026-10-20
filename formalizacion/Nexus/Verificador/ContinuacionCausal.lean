module

public import Nexus.ROM.ContinuacionPrefijo
public import Nexus.Verificador.LeyConjunta
import Mathlib.Tactic

/-!
# Continuación del verificador con adversario después de un prefijo

Se transporta la ley de resultado y cola del registro al programa completo
de bytes, con propuesta adaptativa e intercalaciones. Se conserva el mismo
oráculo y no se condiciona a la ausencia de excepciones ni a aceptación.
-/

public section
namespace Nexus.Verificador.ContinuacionCausal

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM ExperimentoCausal LeyConjunta

set_option maxRecDepth 4096

theorem resultado_tipado {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) :
    LeyArbol.evaluar H (arbolProtocolo u bits R) =
      ProgramaBytes.resultado (oraculo u bits R defecto H) (programa u bits R) := by
  have h := SoporteFinito.resultado_restringir (universo u bits R) (oraculo u bits R defecto H)
    (programa u bits R) (Finset.Subset.refl _)
  simpa only [restriccion_oraculo, arbolProtocolo] using h

theorem cola_tipado {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) (n : ℕ) :
    ((LeyArbol.traza H (arbolProtocolo u bits R)).drop n).map (fun ed => (ed.1.val, ed.2)) =
      (ProgramaBytes.traza (oraculo u bits R defecto H) (programa u bits R)).drop n := by
  rw [List.map_drop, LeyConjunta.traza_arbol]

theorem ley_continuacion_programa {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) (n : ℕ) (f : Bool × List (Entrada × Digest) → ℚ) :
    promedio (fun G : LeyConjunta.Tablas u bits R defecto H n =>
      f (ProgramaBytes.resultado (oraculo u bits R defecto G.val) (programa u bits R),
        (ProgramaBytes.traza (oraculo u bits R defecto G.val) (programa u bits R)).drop n)) =
      LeyArbol.valor (fun rt => f (rt.1, rt.2.map (fun ed => (ed.1.val, ed.2))))
        (LeyArbol.registrar (ContinuacionPrefijo.despues H (arbolProtocolo u bits R) n))
        (PrefijosGlobales.vistas H (arbolProtocolo u bits R) n) H := by
  calc
    _ = promedio (fun G : LeyConjunta.Tablas u bits R defecto H n =>
        f (LeyArbol.evaluar G.val (arbolProtocolo u bits R),
          ((LeyArbol.traza G.val (arbolProtocolo u bits R)).drop n).map (fun ed => (ed.1.val, ed.2)))) := by
      congr 1
      funext G
      rw [resultado_tipado u bits R defecto, cola_tipado u bits R defecto]
    _ = promedio (fun G : PrefijosGlobales.Tablas H (arbolProtocolo u bits R) n =>
        f (LeyArbol.evaluar G.val (arbolProtocolo u bits R),
          ((LeyArbol.traza G.val (arbolProtocolo u bits R)).drop n).map (fun ed => (ed.1.val, ed.2)))) :=
      PromediosCompletaciones.media_equivalencia (equivalencia_prefijo u bits R defecto H n)
        (fun G : PrefijosGlobales.Tablas H (arbolProtocolo u bits R) n =>
          f (LeyArbol.evaluar G.val (arbolProtocolo u bits R),
            ((LeyArbol.traza G.val (arbolProtocolo u bits R)).drop n).map
              (fun ed : universo u bits R × Digest => (ed.1.val, ed.2))))
    _ = _ := ContinuacionPrefijo.ley_cola H (arbolProtocolo u bits R) n
      (fun rt => f (rt.1, rt.2.map (fun ed => (ed.1.val, ed.2))))

theorem cola_presupuesto {A : Type} (u : Politica A) (bits R : ℕ) (defecto : Digest)
    (H : universo u bits R → Digest) (n : ℕ) :
    (LeyArbol.traza H (ContinuacionPrefijo.despues H (arbolProtocolo u bits R) n)).length ≤
      ProgramaBytes.altura (programa u bits R) - n := by
  rw [ContinuacionPrefijo.traza_despues, List.length_drop]
  have he := congrArg List.length (LeyConjunta.traza_arbol u bits R defecto H)
  simp only [List.length_map] at he
  rw [he]
  exact Nat.sub_le_sub_right (ProgramaBytes.costo_acotado (oraculo u bits R defecto H) (programa u bits R)) n

end Nexus.Verificador.ContinuacionCausal
