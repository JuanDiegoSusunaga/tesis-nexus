module

public import Nexus.N06.Consulta
import Mathlib.Tactic

/-!
# La muestra de parejas como respuesta finita de un reto

El promedio uniforme sobre el subtipo de muestras coincide con el cociente
de muestras aceptantes usado en la consulta del protocolo.
-/

public section
namespace Nexus.N06

variable {K : Type} (L : Finset K) (q : ℕ)

theorem promedio_entre_instancias (i j : Fintype K) (f g : K → ℚ)
    (h : ∀ x, f x = g x) : @promedio K i f = @promedio K j g := by
  have he : i = j := Subsingleton.elim _ _
  subst j
  exact congrArg (@promedio K i) (funext h)

abbrev MuestraParejas := ↥(L.powersetCard q)

theorem muestra_parejas_no_vacia (hq : q ≤ L.card) : Nonempty (MuestraParejas L q) := by
  have hn : (L.powersetCard q).Nonempty := Finset.card_pos.mp (Nexus.N05.muestras_no_vacias L q hq)
  obtain ⟨S, hS⟩ := hn
  exact ⟨⟨S, hS⟩⟩

theorem promedio_muestra_consulta (P : Finset K → Prop) [DecidablePred P] :
    promedio (fun S : MuestraParejas L q => if P S.val then 1 else 0) =
      probabilidadConsulta L q P := by
  classical
  simp only [promedio, probabilidadConsulta, Fintype.card_coe]
  congr 1
  rw [Finset.sum_coe_sort (L.powersetCard q) (fun S : Finset K => if P S then (1 : ℚ) else 0)]
  simp only [Finset.sum_boole]
  apply congrArg (fun t : Finset (Finset K) => (t.card : ℚ))
  ext S
  simp only [Finset.mem_filter]

end Nexus.N06
