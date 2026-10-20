module

public import Mathlib.Data.Finset.Card
import Mathlib.Tactic

/-!
# Consultas registradas y formatos abstractos de Merkle

El hash es una función fija y el registro enumera sus entradas consultadas.
La búsqueda inversa usa solo ese registro. La ausencia de colisiones se
exige en sus entradas, sin postular inyectividad global del hash.
El formato tiene decodificación inversa para hojas y nodos. No se identifica
todavía esta interfaz con la serialización de bytes del programa Rust.
-/

public section
namespace Nexus.Merkle

variable {V D E : Type*}

inductive Contenido (V D : Type*) where
  | hoja (valor : V)
  | nodo (izquierda derecha : D)

structure Formato (V D E : Type*) where
  hoja : V → E
  nodo : D → D → E
  leer : E → Option (Contenido V D)
  leer_hoja : ∀ v, leer (hoja v) = some (.hoja v)
  leer_nodo : ∀ l r, leer (nodo l r) = some (.nodo l r)

@[expose] def formatoEtiquetado (V D : Type*) : Formato V D (Contenido V D) where
  hoja := .hoja
  nodo := .nodo
  leer := some
  leer_hoja := fun _ => rfl
  leer_nodo := fun _ _ => rfl

@[expose] def SinColisiones (H : E → D) (registro : List E) : Prop :=
  ∀ x ∈ registro, ∀ y ∈ registro, H x = H y → x = y

variable [DecidableEq D]

@[expose] def preimagen (H : E → D) : List E → D → Option E
  | [], _ => none
  | e :: resto, r => if H e = r then some e else preimagen H resto r

theorem preimagen_some_mem (H : E → D) (registro : List E) (r : D) (e : E)
    (h : preimagen H registro r = some e) : e ∈ registro ∧ H e = r := by
  induction registro with
  | nil => simp only [preimagen, reduceCtorEq] at h
  | cons a resto ih =>
    simp only [preimagen] at h
    split_ifs at h with ha
    · have he : a = e := Option.some.inj h
      subst e
      exact ⟨List.mem_cons_self, ha⟩
    · obtain ⟨he, hr⟩ := ih h
      exact ⟨List.mem_cons_of_mem a he, hr⟩

theorem preimagen_none_iff (H : E → D) (registro : List E) (r : D) :
    preimagen H registro r = none ↔ ∀ e ∈ registro, H e ≠ r := by
  induction registro with
  | nil => simp only [preimagen, List.not_mem_nil, false_implies, implies_true]
  | cons a resto ih =>
    by_cases ha : H a = r
    · simp only [preimagen, ha, ite_true, reduceCtorEq]
      exact ⟨False.elim, fun h => (h a List.mem_cons_self) ha⟩
    · simp only [preimagen, ha, ite_false, ih, List.mem_cons]
      constructor
      · intro h e he
        rcases he with rfl | he
        · exact ha
        · exact h e he
      · intro h e he
        exact h e (Or.inr he)

theorem preimagen_de_consulta (H : E → D) (registro : List E)
    (hc : SinColisiones H registro) (e : E) (he : e ∈ registro) :
    preimagen H registro (H e) = some e := by
  have hn : preimagen H registro (H e) ≠ none := by
    intro h
    exact ((preimagen_none_iff H registro (H e)).mp h e he) rfl
  cases hp : preimagen H registro (H e) with
  | none => exact False.elim (hn hp)
  | some x =>
    obtain ⟨hx, hh⟩ := preimagen_some_mem H registro (H e) x hp
    have hxe := hc x hx e he hh
    rw [hxe]

theorem preimagen_append (H : E → D) (antes despues : List E) (r : D) :
    preimagen H (antes ++ despues) r =
      match preimagen H antes r with
      | some e => some e
      | none => preimagen H despues r := by
  induction antes with
  | nil => rfl
  | cons a resto ih =>
    by_cases ha : H a = r <;> simp only [List.cons_append, preimagen, ha, reduceIte, ih]

theorem preimagen_append_sin_acierto (H : E → D) (antes despues : List E) (r : D)
    (hn : ∀ e ∈ despues, H e ≠ r) :
    preimagen H (antes ++ despues) r = preimagen H antes r := by
  rw [preimagen_append, (preimagen_none_iff H despues r).mpr hn]
  cases preimagen H antes r <;> rfl

omit [DecidableEq D] in
theorem sin_colisiones_prefijo (H : E → D) (antes despues : List E)
    (h : SinColisiones H (antes ++ despues)) : SinColisiones H antes := by
  intro x hx y hy he
  exact h x (List.mem_append_left despues hx) y (List.mem_append_left despues hy) he

end Nexus.Merkle
