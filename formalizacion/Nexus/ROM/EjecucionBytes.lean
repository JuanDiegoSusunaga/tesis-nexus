module

public import Nexus.ROM.ProgramaBytes
public import Nexus.Canal.PrimerasConsultas
import Mathlib.Tactic

/-!
# Del programa de bytes al recorrido con memoria y marcas

Se ejecuta el programa sobre una tabla compartida compatible con H. Cada
entrada ausente se memoriza; las repeticiones conservan su origen. La
ausencia de excepciones se comprueba sobre el recorrido producido, antes
de cada respuesta fresca. De ella se obtiene el recorrido causal anterior.
No se condiciona una distribución uniforme a la ausencia de excepciones.
-/

public section
namespace Nexus.ROM.EjecucionBytes

open Nexus.Bytes Nexus.Merkle ProgramaBytes

@[expose] def solicitar {B : ℕ} (s : Estado B) (e : Entrada) : Solicitud s :=
  ⟨e, ∅, by simpa only [Finset.union_empty] using s.cotaAdicionales⟩

@[expose] def avanzar (H : Entrada → Digest) {B : ℕ} (s : Estado B) (e : Entrada) : Estado B :=
  if h : buscar s.tabla e = none then estadoNuevo s (solicitar s e) (H e) h
  else estadoRepetido s (solicitar s e)

@[expose] def final {R : Type} (H : Entrada → Digest) {B : ℕ} : Estado B → Programa R → Estado B
  | s, .terminar _ => s
  | s, .consultar e f => final H (avanzar H s e) (f (H e))

@[expose] def SinBad {R : Type} (H : Entrada → Digest) {B : ℕ} : Estado B → Programa R → Prop
  | _, .terminar _ => True
  | s, .consultar e f =>
      (buscar s.tabla e = none → H e ∉ antesRespuesta s (solicitar s e)) ∧
      SinBad H (avanzar H s e) (f (H e))

theorem avanzar_compatible (H : Entrada → Digest) {B : ℕ} (s : Estado B) (e : Entrada)
    (hc : Compatibles H s.tabla) : Compatibles H (avanzar H s e).tabla := by
  unfold avanzar
  split
  · intro a d hd
    rcases List.mem_append.mp hd with hd | hd
    · exact hc a d hd
    · have he := List.mem_singleton.mp hd
      exact (congrArg H (Prod.mk.inj he).1).trans (Prod.mk.inj he).2.symm
  · exact hc

theorem avanzar_incluye (H : Entrada → Digest) {B : ℕ} (s : Estado B) (e : Entrada) :
    ∀ x ∈ s.tabla, x ∈ (avanzar H s e).tabla := by
  unfold avanzar
  split
  · intro x hx; exact List.mem_append_left _ hx
  · exact fun _ h => h

theorem avanzar_guarda (H : Entrada → Digest) {B : ℕ} (s : Estado B) (e : Entrada)
    (hc : Compatibles H s.tabla) : buscar (avanzar H s e).tabla e = some (H e) := by
  cases hh : buscar s.tabla e with
  | none => simp only [avanzar, hh, dite_true, estadoNuevo]; exact buscar_anexado _ _ _ hh
  | some d =>
    have he : H e = d := hc e d (buscar_some_mem _ _ _ hh)
    have hn : ¬ buscar s.tabla e = none := by rw [hh]; simp
    rw [avanzar, dite_eq_right hn]
    change buscar s.tabla e = some (H e)
    rwa [he]

theorem avanzar_responde_memoria (H : Entrada → Digest) {B : ℕ} (s : Estado B) (e : Entrada)
    (hc : Compatibles H s.tabla) :
    responder s.tabla e (H e) = (H e, (avanzar H s e).tabla) := by
  cases hh : buscar s.tabla e with
  | none => simp only [responder, hh, avanzar, dite_true, estadoNuevo, solicitar]
  | some d =>
    have he := hc e d (buscar_some_mem _ _ _ hh)
    have hn : ¬ buscar s.tabla e = none := by rw [hh]; simp
    rw [avanzar, dite_eq_right hn, respuesta_repetida _ _ d _ hh]
    change (d, s.tabla) = (H e, s.tabla)
    rw [he]

theorem final_compatible {R : Type} (H : Entrada → Digest) {B : ℕ} (s : Estado B) (p : Programa R)
    (hc : Compatibles H s.tabla) : Compatibles H (final H s p).tabla := by
  induction p generalizing s with
  | terminar r => exact hc
  | consultar e f ih => exact ih _ _ (avanzar_compatible H s e hc)

theorem final_incluye {R : Type} (H : Entrada → Digest) {B : ℕ} (s : Estado B) (p : Programa R) :
    ∀ x ∈ s.tabla, x ∈ (final H s p).tabla := by
  induction p generalizing s with
  | terminar r => exact fun _ h => h
  | consultar e f ih => exact fun x hx => ih _ _ x (avanzar_incluye H s e x hx)

theorem traza_guardada {R : Type} (H : Entrada → Digest) {B : ℕ} (s : Estado B) (p : Programa R)
    (hc : Compatibles H s.tabla) : ∀ x ∈ traza H p, x ∈ (final H s p).tabla := by
  induction p generalizing s with
  | terminar r => intro x hx; contradiction
  | consultar e f ih =>
    intro x hx
    rcases List.mem_cons.mp hx with rfl | hx
    · exact final_incluye H (avanzar H s e) (f (H e)) _
        (buscar_some_mem _ _ _ (avanzar_guarda H s e hc))
    · exact ih _ _ (avanzar_compatible H s e hc) x hx

theorem consulta_en_tabla {R : Type} (H : Entrada → Digest) {B : ℕ} (s : Estado B) (p : Programa R)
    (hc : Compatibles H s.tabla) (e : Entrada) (he : e ∈ entradas H p) :
    buscar (final H s p).tabla e = some (H e) := by
  obtain ⟨⟨a, d⟩, hm, h⟩ := List.mem_map.mp he
  change a = e at h
  subst a
  have hd := traza_responde H p e d hm
  exact buscar_de_mem _ (final H s p).sinRepetidos _ _ (hd ▸ traza_guardada H s p hc _ hm)

theorem recorrido_desde_programa {R : Type} (H : Entrada → Digest) {B : ℕ} (s : Estado B)
    (p : Programa R) (hc : Compatibles H s.tabla) (hs : SinBad H s p) :
    RecorridoSinAcierto B s (final H s p) := by
  induction p generalizing s with
  | terminar r => exact .refl _
  | consultar e f ih =>
    have paso : RecorridoSinAcierto B s (avanzar H s e) := by
      cases hh : buscar s.tabla e with
      | none =>
        rw [avanzar, dite_eq_left hh]
        exact .nueva (.refl _) _ _ hh (hs.1 hh)
      | some d =>
        rw [avanzar, dite_eq_right (by simp only [hh, reduceCtorEq, not_false_eq_true])]
        exact .repetida (.refl _) _ d hh
    exact recorrido_trans paso (ih _ _ (avanzar_compatible H s e hc) hs.2)

theorem final_unir {R S : Type} (H : Entrada → Digest) {B : ℕ} (s : Estado B)
    (p : Programa R) (f : R → Programa S) :
    final H s (unir p f) = final H (final H s p) (f (resultado H p)) := by
  induction p generalizing s with
  | terminar r => rfl
  | consultar e k ih => exact ih _ _

theorem sinbad_unir {R S : Type} (H : Entrada → Digest) {B : ℕ} (s : Estado B)
    (p : Programa R) (f : R → Programa S) :
    SinBad H s (unir p f) ↔ SinBad H s p ∧ SinBad H (final H s p) (f (resultado H p)) := by
  induction p generalizing s with
  | terminar r => simp only [unir, final, resultado, SinBad, true_and]
  | consultar e k ih => simp only [unir, final, resultado, SinBad, ih]; tauto

theorem origen_raiz_reto_del_registro {R : Type} (H : Entrada → Digest) (B : ℕ) (p : Programa R)
    (hs : SinBad H (inicial B) p) (estado raiz : Digest) (tag : Octeto) (tipo : Nexus.Canal.TipoReto)
    (ha : Nexus.Canal.entradaAbsorcion estado tag raiz.val ∈ entradas H p)
    (hr : Nexus.Canal.entradaReto (H (Nexus.Canal.entradaAbsorcion estado tag raiz.val)) tipo ∈ entradas H p) :
    Nonempty (Nexus.Canal.CorteRaizReto (final H (inicial B) p) estado tag raiz tipo
      (H (Nexus.Canal.entradaAbsorcion estado tag raiz.val))
      (H (Nexus.Canal.entradaReto (H (Nexus.Canal.entradaAbsorcion estado tag raiz.val)) tipo))) := by
  have hc : Compatibles H (inicial B).tabla := by intro e d hd; contradiction
  exact Nexus.Canal.origenes_raiz_reto (recorrido_desde_programa H _ p hc hs) _ _ _ _ _ _
    (consulta_en_tabla H _ p hc _ ha) (consulta_en_tabla H _ p hc _ hr)

end Nexus.ROM.EjecucionBytes
