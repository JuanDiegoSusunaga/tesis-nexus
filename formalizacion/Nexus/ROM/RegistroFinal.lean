module

public import Nexus.ROM.Probabilidad
import Mathlib.Tactic

/-!
# Del muestreo con memoria al vector Merkle congelado

La función total de una tabla solo completa las entradas no consultadas con
un valor arbitrario. Las búsquedas inversas del extractor no leen esos valores.
Las marcas adicionales pueden aparecer adaptativamente; solo se usan las
marcas que existían antes de cada respuesta, nunca las de un instante futuro.
-/

public section
namespace Nexus.ROM

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.N06

@[expose] def Compatibles (H : Entrada → Digest) (t : Tabla Entrada Digest) : Prop :=
  ∀ e d, (e, d) ∈ t → H e = d

@[expose] def funcionTabla (defecto : Digest) (t : Tabla Entrada Digest) (e : Entrada) : Digest :=
  (buscar t e).getD defecto

theorem funcion_tabla_compatible (defecto : Digest) (t : Tabla Entrada Digest) (ht : SinRepetidos t) :
    Compatibles (funcionTabla defecto t) t := by
  intro e d hd
  simp only [funcionTabla, buscar_de_mem t ht e d hd, Option.getD_some]

theorem funciones_compatibles_coinciden (H G : Entrada → Digest) (t : Tabla Entrada Digest)
    (hH : Compatibles H t) (hG : Compatibles G t) : ∀ e ∈ t.map Prod.fst, H e = G e := by
  intro e he
  obtain ⟨⟨x, d⟩, hx, hxe⟩ := List.mem_map.mp he
  change x = e at hxe
  subst x
  exact (hH e d hx).trans (hG e d hx).symm

theorem marcas_tabla_coinciden (H : Entrada → Digest) (t : Tabla Entrada Digest)
    (hc : Compatibles H t) : marcasTabla t = marcasConsultas H (t.map Prod.fst) := by
  induction t with
  | nil => rfl
  | cons ed resto ih =>
    rcases ed with ⟨e, d⟩
    have he := hc e d List.mem_cons_self
    have hr : Compatibles H resto := fun x y hx => hc x y (List.mem_cons_of_mem _ hx)
    simp only [marcasTabla, List.map_cons, marcasConsultas, marcasPar, marcasEntrada, he, ih hr]

theorem etiquetas_estado_cubiertas (H : Entrada → Digest) {B : ℕ} (s : Estado B)
    (hc : Compatibles H s.tabla) (raiz : Digest) (hr : raiz ∈ marcasEstado s) :
    etiquetas formatoBytes H raiz (s.tabla.map Prod.fst) ⊆ marcasEstado s := by
  have hm : marcasEstado s = marcas H s.adicionales (s.tabla.map Prod.fst) := by
    simp only [marcasEstado, marcas, marcas_tabla_coinciden H s.tabla hc]
  rw [hm] at hr ⊢
  exact etiquetas_bytes_cubiertas H s.adicionales _ raiz hr

theorem marcas_antes_respuesta {B : ℕ} (s : Estado B) (q : Solicitud s) :
    marcasEstado s ⊆ antesRespuesta s q := by
  intro d hd
  simp only [marcasEstado, antesRespuesta, Finset.mem_union] at hd ⊢
  tauto

theorem salida_estado_marcada (H : Entrada → Digest) {B : ℕ} (s : Estado B)
    (hc : Compatibles H s.tabla) (e : Entrada) (he : e ∈ s.tabla.map Prod.fst) :
    H e ∈ marcasEstado s := by
  obtain ⟨⟨x, d⟩, hx, hxe⟩ := List.mem_map.mp he
  change x = e at hxe
  subst x
  rw [hc e d hx]
  exact Finset.mem_union_right _ (marcas_par_incluidas s.tabla (e, d) hx (Finset.mem_insert_self _ _))

inductive RecorridoSinAcierto (B : ℕ) : Estado B → Estado B → Prop
  | refl (s : Estado B) : RecorridoSinAcierto B s s
  | repetida {inicio actual : Estado B} (previo : RecorridoSinAcierto B inicio actual)
      (q : Solicitud actual) (d : Digest) (hd : buscar actual.tabla q.entrada = some d) :
      RecorridoSinAcierto B inicio (estadoRepetido actual q)
  | nueva {inicio actual : Estado B} (previo : RecorridoSinAcierto B inicio actual)
      (q : Solicitud actual) (d : Digest) (hn : buscar actual.tabla q.entrada = none)
      (hd : d ∉ antesRespuesta actual q) : RecorridoSinAcierto B inicio (estadoNuevo actual q d hn)

theorem recorrido_trans {B : ℕ} {a b c : Estado B} (hab : RecorridoSinAcierto B a b)
    (hbc : RecorridoSinAcierto B b c) : RecorridoSinAcierto B a c := by
  induction hbc with
  | refl => exact hab
  | repetida previo q d hd ih => exact .repetida ih q d hd
  | nueva previo q d hn hd ih => exact .nueva ih q d hn hd

theorem recorrido_tablas_incluidas {B : ℕ} {a b : Estado B} (r : RecorridoSinAcierto B a b) :
    ∀ ed ∈ a.tabla, ed ∈ b.tabla := by
  induction r with
  | refl => exact fun _ h => h
  | repetida previo q d hd ih => exact ih
  | nueva previo q d hn hd ih => exact fun ed he => List.mem_append_left _ (ih ed he)

theorem recorrido_compatible_antes (H : Entrada → Digest) {B : ℕ} {a b : Estado B}
    (r : RecorridoSinAcierto B a b) (hc : Compatibles H b.tabla) : Compatibles H a.tabla :=
  fun e d hd => hc e d (recorrido_tablas_incluidas r (e, d) hd)

theorem recorrido_marcas_mono {B : ℕ} {a b : Estado B} (r : RecorridoSinAcierto B a b) :
    marcasEstado a ⊆ marcasEstado b := by
  induction r with
  | refl => exact Finset.Subset.refl _
  | repetida previo q d hd ih => exact ih.trans (marcas_repeticion_mono _ q)
  | nueva previo q d hn hd ih => exact ih.trans (marcas_nueva_mono _ q d hn)

@[expose] def ejecutar {B : ℕ} {s : Estado B} {n : ℕ} : Plan B s n → Retos Digest n → Estado B
  | .terminar s _, _ => s
  | .repetir _ _ _ resto, xs => ejecutar resto xs
  | .nuevo _ _ resto, xs => ejecutar (resto xs.1) xs.2

theorem ejecucion_sin_acierto {B : ℕ} {s : Estado B} {n : ℕ} (p : Plan B s n)
    (xs : Retos Digest n) (hs : acierta p xs = false) : RecorridoSinAcierto B s (ejecutar p xs) := by
  induction p with
  | terminar s n => exact .refl _
  | @repetir s n q d hd resto ih =>
    exact recorrido_trans (.repetida (.refl s) q d hd) (ih xs hs)
  | @nuevo s n q hn resto ih =>
    obtain ⟨d, ys⟩ := xs
    have hh : d ∉ antesRespuesta s q ∧ acierta (resto d) ys = false := by
      simpa only [acierta, Bool.or_eq_false_iff, decide_eq_false_iff_not] using hs
    exact recorrido_trans (.nueva (.refl s) q d hn hh.1) (ih d ys hh.2)

theorem recorrido_sin_colisiones (H : Entrada → Digest) {B : ℕ} {a b : Estado B}
    (r : RecorridoSinAcierto B a b) (hc : Compatibles H b.tabla)
    (h0 : SinColisiones H (a.tabla.map Prod.fst)) : SinColisiones H (b.tabla.map Prod.fst) := by
  induction r with
  | refl => exact h0
  | repetida previo q d hd ih => exact ih hc
  | @nueva actual previo q d hn hd ih =>
    have hca : Compatibles H actual.tabla :=
      fun e y he => hc e y (List.mem_append_left _ he)
    have hHd : H q.entrada = d := hc _ _ (List.mem_append_right _ (List.mem_singleton_self _))
    have hdist (x : Entrada) (hx : x ∈ actual.tabla.map Prod.fst) : H x ≠ H q.entrada := by
      intro heq
      apply hd
      rw [← hHd, ← heq]
      exact marcas_antes_respuesta actual q (salida_estado_marcada H actual hca x hx)
    intro x hx y hy heq
    simp only [estadoNuevo, List.map_append, List.map_cons, List.map_nil,
      List.mem_append, List.mem_singleton] at hx hy
    rcases hx with hx | rfl <;> rcases hy with hy | rfl
    · exact ih hca x hx y hy heq
    · exact False.elim (hdist x hx heq)
    · exact False.elim (hdist y hy heq.symm)
    · rfl

theorem recorrido_es_seguro (H : Entrada → Digest) {B : ℕ} {a b : Estado B}
    (r : RecorridoSinAcierto B a b) (hc : Compatibles H b.tabla)
    (raiz : Digest) (hr : raiz ∈ marcasEstado a) :
    ExtensionSegura formatoBytes H raiz (a.tabla.map Prod.fst) (b.tabla.map Prod.fst) := by
  induction r with
  | refl => exact .refl _
  | repetida previo q d hd ih => exact ih hc
  | @nueva actual previo q d hn hd ih =>
    have hca : Compatibles H actual.tabla :=
      fun e y he => hc e y (List.mem_append_left _ he)
    have hHd : H q.entrada = d := hc _ _ (List.mem_append_right _ (List.mem_singleton_self _))
    have hroot : raiz ∈ marcasEstado actual := recorrido_marcas_mono previo hr
    have hlocal : H q.entrada ∉ etiquetas formatoBytes H raiz (actual.tabla.map Prod.fst) := by
      intro he
      apply hd
      rw [← hHd]
      exact marcas_antes_respuesta actual q (etiquetas_estado_cubiertas H actual hca raiz hroot he)
    simpa only [estadoNuevo, List.map_append, List.map_cons, List.map_nil] using
      ExtensionSegura.paso (ih hca) q.entrada hlocal

theorem preimagen_congruente (H G : Entrada → Digest) (registro : List Entrada)
    (hg : ∀ e ∈ registro, H e = G e) (d : Digest) :
    preimagen H registro d = preimagen G registro d := by
  induction registro with
  | nil => rfl
  | cons e resto ih =>
    have he := hg e List.mem_cons_self
    have hr : ∀ x ∈ resto, H x = G x := fun x hx => hg x (List.mem_cons_of_mem e hx)
    simp only [preimagen, he, ih hr]

theorem extraer_congruente (H G : Entrada → Digest) (registro : List Entrada)
    (hg : ∀ e ∈ registro, H e = G e) (ruta : List Bool) (raiz : Digest) :
    extraer formatoBytes H registro ruta raiz = extraer formatoBytes G registro ruta raiz := by
  have hp (d : Digest) : leerRegistro formatoBytes H registro d = leerRegistro formatoBytes G registro d := by
    simp only [leerRegistro, preimagen_congruente H G registro hg d]
  induction ruta generalizing raiz with
  | nil => simp only [extraer, hp]
  | cons b ruta ih =>
    simp only [extraer, hp]
    cases hd : leerRegistro formatoBytes G registro raiz with
    | none => rfl
    | some c =>
      cases c with
      | hoja v => rfl
      | nodo l r => exact ih (if b then r else l)

theorem raiz_absorbida_estado {B : ℕ} (s : Estado B) (estado raiz : Digest) (tag : Octeto)
    (he : absorberRaiz estado tag raiz ∈ s.tabla.map Prod.fst) : raiz ∈ marcasEstado s := by
  obtain ⟨⟨e, d⟩, hx, hxe⟩ := List.mem_map.mp he
  change e = absorberRaiz estado tag raiz at hxe
  subst e
  exact Finset.mem_union_right _ (marcas_par_incluidas s.tabla _ hx
    (Finset.mem_insert_of_mem (raiz_absorbida_en_ventanas estado tag raiz)))

/-- El vector del instante de congelación se calcula exclusivamente con su tabla. -/
theorem apertura_congelada_memoria {B : ℕ} {antes despues : Estado B}
    (previo : RecorridoSinAcierto B (inicial B) antes)
    (posterior : RecorridoSinAcierto B antes despues) (defecto raiz : Digest)
    (hr : raiz ∈ marcasEstado antes) (altura : ℕ) (v : Fp2) (hermanos : List (Bool × Digest))
    (ha : Acepta formatoBytes (funcionTabla defecto despues.tabla) raiz altura v hermanos)
    (hq : AperturaRegistrada formatoBytes (funcionTabla defecto despues.tabla)
      (despues.tabla.map Prod.fst) v hermanos) :
    extraer formatoBytes (funcionTabla defecto antes.tabla)
      (antes.tabla.map Prod.fst) (hermanos.map Prod.fst) raiz = v := by
  let H := funcionTabla defecto despues.tabla
  have hfinal : Compatibles H despues.tabla := funcion_tabla_compatible defecto _ despues.sinRepetidos
  have hantes := recorrido_compatible_antes H posterior hfinal
  have hc0 : SinColisiones H ((inicial B).tabla.map Prod.fst) := by
    intro x hx
    simp only [inicial, List.map_nil, List.not_mem_nil] at hx
  have hc := recorrido_sin_colisiones H previo hantes hc0
  have ext := recorrido_es_seguro H posterior hfinal raiz hr
  have hcoinc := funciones_compatibles_coinciden (funcionTabla defecto antes.tabla) H antes.tabla
    (funcion_tabla_compatible defecto _ antes.sinRepetidos) hantes
  exact (extraer_congruente _ H _ hcoinc _ raiz).trans
    (apertura_posterior_coincide_congelada formatoBytes H raiz altura _ _ ext hc v hermanos hq ha)

theorem apertura_absorbida_memoria {B : ℕ} {antes despues : Estado B}
    (previo : RecorridoSinAcierto B (inicial B) antes)
    (posterior : RecorridoSinAcierto B antes despues) (defecto estado raiz : Digest) (tag : Octeto)
    (hr : absorberRaiz estado tag raiz ∈ antes.tabla.map Prod.fst)
    (altura : ℕ) (v : Fp2) (hermanos : List (Bool × Digest))
    (ha : Acepta formatoBytes (funcionTabla defecto despues.tabla) raiz altura v hermanos)
    (hq : AperturaRegistrada formatoBytes (funcionTabla defecto despues.tabla)
      (despues.tabla.map Prod.fst) v hermanos) :
    extraer formatoBytes (funcionTabla defecto antes.tabla)
      (antes.tabla.map Prod.fst) (hermanos.map Prod.fst) raiz = v :=
  apertura_congelada_memoria previo posterior defecto raiz
    (raiz_absorbida_estado antes estado raiz tag hr) altura v hermanos ha hq

end Nexus.ROM
