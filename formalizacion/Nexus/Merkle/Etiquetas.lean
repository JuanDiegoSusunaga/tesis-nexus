module

public import Nexus.Merkle.Extraccion
import Mathlib.Tactic

/-!
# Etiquetas que protegen una extracción Merkle congelada

Se marca la raíz examinada, las salidas registradas y los dos hijos de cada
nodo decodificado. Son etiquetas suficientes para la estabilidad de Merkle.
No representan todas las ventanas del canal ni prueban la cuenta ROM global.
-/

public section
namespace Nexus.Merkle

variable {V D E : Type*} [DecidableEq D]

@[expose] def etiquetasEntrada (f : Formato V D E) (H : E → D) (e : E) : Finset D :=
  insert (H e) (match f.leer e with
    | some (.nodo l r) => {l, r}
    | _ => ∅)

@[expose] def etiquetas (f : Formato V D E) (H : E → D) (raiz : D) : List E → Finset D
  | [] => {raiz}
  | e :: resto => etiquetasEntrada f H e ∪ etiquetas f H raiz resto

theorem raiz_etiquetada (f : Formato V D E) (H : E → D) (raiz : D) (registro : List E) :
    raiz ∈ etiquetas f H raiz registro := by
  induction registro with
  | nil => exact Finset.mem_singleton_self _
  | cons e resto ih => exact Finset.mem_union_right _ ih

theorem entrada_etiquetada (f : Formato V D E) (H : E → D) (raiz : D)
    (registro : List E) (e : E) (he : e ∈ registro) :
    etiquetasEntrada f H e ⊆ etiquetas f H raiz registro := by
  induction registro with
  | nil => simp only [List.not_mem_nil] at he
  | cons a resto ih =>
    rcases List.mem_cons.mp he with rfl | he
    · exact Finset.subset_union_left
    · exact (ih he).trans Finset.subset_union_right

theorem salida_etiquetada (f : Formato V D E) (H : E → D) (raiz : D)
    (registro : List E) (e : E) (he : e ∈ registro) : H e ∈ etiquetas f H raiz registro :=
  entrada_etiquetada f H raiz registro e he (Finset.mem_insert_self _ _)

theorem hijos_etiquetados (f : Formato V D E) (H : E → D) (raiz : D)
    (registro : List E) (e : E) (he : e ∈ registro) (l r : D)
    (hd : f.leer e = some (.nodo l r)) :
    l ∈ etiquetas f H raiz registro ∧ r ∈ etiquetas f H raiz registro := by
  have hs := entrada_etiquetada f H raiz registro e he
  constructor <;> apply hs <;> simp [etiquetasEntrada, hd]

theorem etiquetas_entrada_card (f : Formato V D E) (H : E → D) (e : E) :
    (etiquetasEntrada f H e).card ≤ 3 := by
  unfold etiquetasEntrada
  cases hd : f.leer e with
  | none =>
    change ({H e} : Finset D).card ≤ 3
    rw [Finset.card_singleton]
    omega
  | some c =>
    cases c with
    | hoja v =>
      change ({H e} : Finset D).card ≤ 3
      rw [Finset.card_singleton]
      omega
    | nodo l r =>
      change (insert (H e) ({l, r} : Finset D)).card ≤ 3
      have h1 := Finset.card_insert_le (H e) ({l, r} : Finset D)
      have h2 := Finset.card_insert_le l ({r} : Finset D)
      simp only [Finset.card_singleton] at h2
      omega

theorem etiquetas_card (f : Formato V D E) (H : E → D) (raiz : D) (registro : List E) :
    (etiquetas f H raiz registro).card ≤ 3 * registro.length + 1 := by
  induction registro with
  | nil => simp only [etiquetas, Finset.card_singleton, List.length_nil]; omega
  | cons e resto ih =>
    have hu := Finset.card_union_le (etiquetasEntrada f H e) (etiquetas f H raiz resto)
    have he := etiquetas_entrada_card f H e
    change (etiquetasEntrada f H e ∪ etiquetas f H raiz resto).card ≤ _
    simp only [List.length_cons]
    omega

theorem consulta_segura_nueva (f : Formato V D E) (H : E → D) (raiz : D)
    (registro : List E) (e : E) (hn : H e ∉ etiquetas f H raiz registro) : e ∉ registro := by
  intro he
  exact hn (salida_etiquetada f H raiz registro e he)

end Nexus.Merkle
