module

public import Nexus.Merkle.Registro
public import Mathlib.Data.Fintype.Pi
import Mathlib.Tactic

/-!
# Extracción de un vector completado y vinculación de aperturas registradas

La ruta va de la raíz a la hoja. Su longitud fija la altura del árbol.
Las preimágenes ausentes o de forma incorrecta completan la región con cero.
La autenticación reconstruye los hashes desde la hoja y exige esa altura.
-/

public section
namespace Nexus.Merkle

variable {V D E : Type*} [Zero V] [DecidableEq D]

@[expose] def leerRegistro (f : Formato V D E) (H : E → D) (registro : List E) (r : D) :
    Option (Contenido V D) := (preimagen H registro r).bind f.leer

@[expose] def extraer (f : Formato V D E) (H : E → D) (registro : List E) : List Bool → D → V
  | [], r => match leerRegistro f H registro r with
      | some (.hoja v) => v
      | _ => 0

  | b :: ruta, r => match leerRegistro f H registro r with
      | some (.nodo l d) => extraer f H registro ruta (if b then d else l)
      | _ => 0

/-- Vector total indexado por todas las rutas de la altura fijada. -/
@[expose] def vectorExtraido (f : Formato V D E) (H : E → D) (registro : List E)
    (altura : ℕ) (raiz : D) : (Fin altura → Bool) → V :=
  fun ruta => extraer f H registro (List.ofFn ruta) raiz

omit [Zero V] [DecidableEq D] in
theorem posiciones_cardinal (altura : ℕ) : Fintype.card (Fin altura → Bool) = 2 ^ altura := by
  simp

@[expose] def reconstruir (f : Formato V D E) (H : E → D) (v : V) : List (Bool × D) → D
  | [] => H (f.hoja v)
  | (b, hermano) :: resto =>
      let hijo := reconstruir f H v resto
      H (if b then f.nodo hermano hijo else f.nodo hijo hermano)

@[expose] def consultasApertura (f : Formato V D E) (H : E → D) (v : V) : List (Bool × D) → List E
  | [] => [f.hoja v]
  | (b, hermano) :: resto =>
      let hijo := reconstruir f H v resto
      (if b then f.nodo hermano hijo else f.nodo hijo hermano) :: consultasApertura f H v resto

@[expose] def AperturaRegistrada (f : Formato V D E) (H : E → D)
    (registro : List E) (v : V) (hermanos : List (Bool × D)) : Prop :=
  ∀ e ∈ consultasApertura f H v hermanos, e ∈ registro

@[expose] def Acepta (f : Formato V D E) (H : E → D) (raiz : D) (altura : ℕ)
    (v : V) (hermanos : List (Bool × D)) : Prop :=
  hermanos.length = altura ∧ reconstruir f H v hermanos = raiz

omit [Zero V] in
theorem leer_consulta_registrada (f : Formato V D E) (H : E → D) (registro : List E)
    (hc : SinColisiones H registro) (e : E) (he : e ∈ registro) :
    leerRegistro f H registro (H e) = f.leer e := by
  simp only [leerRegistro, preimagen_de_consulta H registro hc e he, Option.bind_some]

theorem extraer_apertura_registrada (f : Formato V D E) (H : E → D) (registro : List E)
    (hc : SinColisiones H registro) (v : V) (hermanos : List (Bool × D))
    (hr : AperturaRegistrada f H registro v hermanos) :
    extraer f H registro (hermanos.map Prod.fst) (reconstruir f H v hermanos) = v := by
  induction hermanos with
  | nil =>
    have he : f.hoja v ∈ registro := hr _ (List.mem_singleton_self _)
    simp only [List.map_nil, reconstruir, extraer, leer_consulta_registrada f H registro hc _ he,
      f.leer_hoja]
  | cons a resto ih =>
    rcases a with ⟨b, hermano⟩
    have ht : AperturaRegistrada f H registro v resto := by
      intro e he
      exact hr e (List.mem_cons_of_mem _ he)
    have he : (if b then f.nodo hermano (reconstruir f H v resto)
        else f.nodo (reconstruir f H v resto) hermano) ∈ registro := hr _ List.mem_cons_self
    cases b with
    | false =>
      change f.nodo (reconstruir f H v resto) hermano ∈ registro at he
      simp only [List.map_cons, reconstruir, extraer, Bool.false_eq_true, ite_false]
      rw [leer_consulta_registrada f H registro hc _ he, f.leer_nodo]
      exact ih ht
    | true =>
      change f.nodo hermano (reconstruir f H v resto) ∈ registro at he
      simp only [List.map_cons, reconstruir, extraer, reduceIte]
      rw [leer_consulta_registrada f H registro hc _ he, f.leer_nodo]
      exact ih ht

theorem apertura_aceptada_extraida (f : Formato V D E) (H : E → D) (registro : List E)
    (hc : SinColisiones H registro) (raiz : D) (altura : ℕ) (v : V) (hermanos : List (Bool × D))
    (hr : AperturaRegistrada f H registro v hermanos) (ha : Acepta f H raiz altura v hermanos) :
    extraer f H registro (hermanos.map Prod.fst) raiz = v := by
  rw [← ha.2]
  exact extraer_apertura_registrada f H registro hc v hermanos hr

theorem aperturas_registradas_vinculadas (f : Formato V D E) (H : E → D) (registro : List E)
    (hc : SinColisiones H registro) (raiz : D) (altura : ℕ) (v w : V)
    (hv hw : List (Bool × D)) (rv : AperturaRegistrada f H registro v hv)
    (rw : AperturaRegistrada f H registro w hw) (av : Acepta f H raiz altura v hv)
    (aw : Acepta f H raiz altura w hw) (ruta : hv.map Prod.fst = hw.map Prod.fst) : v = w := by
  have ev := apertura_aceptada_extraida f H registro hc raiz altura v hv rv av
  have ew := apertura_aceptada_extraida f H registro hc raiz altura w hw rw aw
  rw [ruta] at ev
  exact ev.symm.trans ew

theorem extraer_sin_preimagen (f : Formato V D E) (H : E → D) (registro : List E)
    (raiz : D) (ruta : List Bool) (hn : preimagen H registro raiz = none) :
    extraer f H registro ruta raiz = 0 := by
  cases ruta <;> simp only [extraer, leerRegistro, hn, Option.bind_none]

end Nexus.Merkle
