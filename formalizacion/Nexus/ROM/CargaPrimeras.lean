module

public import Nexus.ROM.PrimeraExposicion
public import Nexus.ROM.ConteoActivaciones
import Mathlib.Tactic

/-!
# Carga de primeras exposiciones a direcciones distintas

El candidato y su dirección pueden cambiar en cada prefijo. La inyección
usa su primera posición efectiva, por lo que una repetición nunca cobra
otra activación de esa dirección.
-/

public section
namespace Nexus.ROM.CargaPrimeras

open Nexus.N06 LeyArbol ObservacionesPrefijo PrimeraExposicion ConteoActivaciones

variable {Q A X : Type} [DecidableEq Q]
attribute [local instance] Classical.propDecidable

abbrev Inicia (p : Arbol Q A X) (direccion : ℕ → List (Q × A) → Q)
    (n : ℕ) (H : Q → A) : Prop := Activa p (direccion n) (prefijo p n H)

theorem direccion_inyectiva (H : Q → A) (p : Arbol Q A X)
    (direccion : ℕ → List (Q × A) → Q) (n m : ℕ)
    (hn : Inicia p direccion n H) (hm : Inicia p direccion m H)
    (he : direccion n (prefijo p n H) = direccion m (prefijo p m H)) : n = m := by
  have h1 := activa_indice H p n (direccion n) hn
  have h2 := activa_indice H p m (direccion m) hm
  rw [he] at h1
  exact h1.symm.trans h2

theorem carga_distintas (H : Q → A) (p : Arbol Q A X) (N : ℕ)
    (direccion : ℕ → List (Q × A) → Q) :
    numero (fun n : Fin N => Inicia p direccion n.val) H ≤ ((traza H p).map Prod.fst).toFinset.card := by
  let s : Finset (Fin N) := Finset.univ.filter (fun n => Inicia p direccion n.val H)
  let f : Fin N → Q := fun n => direccion n.val (prefijo p n.val H)
  have hi : Set.InjOn f s := by
    intro n hn m hm he
    apply Fin.ext
    exact direccion_inyectiva H p direccion n.val m.val
      (Finset.mem_filter.mp hn).2 (Finset.mem_filter.mp hm).2 he
  have hs : s.image f ⊆ ((traza H p).map Prod.fst).toFinset := by
    intro e he
    obtain ⟨n, hn, rfl⟩ := Finset.mem_image.mp he
    exact activa_registrada H p n.val (direccion n.val) (Finset.mem_filter.mp hn).2
  calc
    _ = s.card := rfl
    _ = (s.image f).card := (Finset.card_image_of_injOn hi).symm
    _ ≤ _ := Finset.card_le_card hs

theorem carga_consultas (H : Q → A) (p : Arbol Q A X) (N : ℕ)
    (direccion : ℕ → List (Q × A) → Q) :
    numero (fun n : Fin N => Inicia p direccion n.val) H ≤ (traza H p).length := by
  exact (carga_distintas H p N direccion).trans
    (by simpa only [List.length_map] using List.toFinset_card_le ((traza H p).map Prod.fst))

theorem carga_horizonte (H : Q → A) (p : Arbol Q A X) (N : ℕ)
    (direccion : ℕ → List (Q × A) → Q) :
    numero (fun n : Fin N => Inicia p direccion n.val) H ≤ N := by
  exact (Finset.card_filter_le _ _).trans (by simp only [Finset.card_univ, Fintype.card_fin, le_refl])

theorem primera_antes_reutilizacion (H : Q → A) (p : Arbol Q A X) (n : ℕ) (e : Q)
    (he : e ∈ ((prefijo p n H).map Prod.fst).toFinset) :
    ∃ m, m < n ∧ Activa p (fun _ => e) (prefijo p m H) := by
  have hem : e ∈ ((traza H p).map Prod.fst) := by
    apply List.mem_of_mem_take (i := n)
    simpa only [List.mem_toFinset, List.map_take] using he
  obtain ⟨m, _, hm⟩ := existe_primera H p e hem
  have hpos := activa_indice H p m (fun _ => e) hm
  have hbefore : ((traza H p).map Prod.fst).idxOf e < n := by
    apply (List.mem_take_iff_idxOf_lt hem).mp
    simpa only [List.mem_toFinset, List.map_take] using he
  exact ⟨m, by omega, hm⟩

end Nexus.ROM.CargaPrimeras
