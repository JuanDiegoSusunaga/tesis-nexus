module

public import Nexus.Merkle.CodificacionBase
public import Nexus.ROM.CongelacionPrevia
import Mathlib.Tactic

/-!
# Congelación con hojas del campo base en la misma memoria ROM

Las etiquetas de nodos son las mismas en los dos formatos. Por ello el
recorrido sin aciertos protege también la extracción de hojas Fp, sin
introducir otra tabla, otro hash ni una separación global de roles.
-/

public section
namespace Nexus.ROM

open Nexus.Merkle Nexus.Goldilocks

theorem extension_segura_base (H : Entrada → Digest) (raiz : Digest) (A B : List Entrada)
    (ext : ExtensionSegura formatoBytes H raiz A B) : ExtensionSegura formatoBase H raiz A B := by
  induction ext with
  | refl => exact .refl _
  | paso previo e hn ih =>
    exact .paso ih e (by simpa only [etiquetas_base_coinciden] using hn)

theorem extraer_formato_congruente {V : Type*} [Zero V] (f : Formato V Digest Entrada)
    (H G : Entrada → Digest) (registro : List Entrada) (hg : ∀ e ∈ registro, H e = G e)
    (ruta : List Bool) (raiz : Digest) : extraer f H registro ruta raiz = extraer f G registro ruta raiz := by
  have hp (d : Digest) : leerRegistro f H registro d = leerRegistro f G registro d := by
    simp only [leerRegistro, preimagen_congruente H G registro hg d]
  induction ruta generalizing raiz with
  | nil => simp only [extraer, hp]
  | cons b ruta ih =>
    simp only [extraer, hp]
    cases hd : leerRegistro f G registro raiz with
    | none => rfl
    | some c =>
      cases c with
      | hoja v => rfl
      | nodo l r => exact ih (if b then r else l)

theorem extraccion_independiente_defecto {V : Type*} [Zero V] (f : Formato V Digest Entrada)
    (t : Tabla Entrada Digest) (ht : SinRepetidos t) (d e : Digest) (ruta : List Bool) (raiz : Digest) :
    extraer f (funcionTabla d t) (t.map Prod.fst) ruta raiz =
      extraer f (funcionTabla e t) (t.map Prod.fst) ruta raiz :=
  extraer_formato_congruente f _ _ _
    (funciones_compatibles_coinciden _ _ t (funcion_tabla_compatible d t ht) (funcion_tabla_compatible e t ht))
    ruta raiz

theorem extraccion_base_previa_estable {B : ℕ} {s t fin : Estado B} {q : Solicitud s} {d : Digest}
    (paso : PasoSinAcierto s q d t) (futuro : RecorridoSinAcierto B t fin) (defecto raiz : Digest)
    (hr : raiz ∈ antesRespuesta s q) (ruta : List Bool) :
    extraer formatoBase (funcionTabla defecto s.tabla) (s.tabla.map Prod.fst) ruta raiz =
      extraer formatoBase (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) ruta raiz := by
  let H := funcionTabla defecto fin.tabla
  have hcf : Compatibles H fin.tabla := funcion_tabla_compatible defecto _ fin.sinRepetidos
  have hcs := recorrido_compatible_antes H (recorrido_trans (paso_es_recorrido paso) futuro) hcf
  have hcoinc := funciones_compatibles_coinciden (funcionTabla defecto s.tabla) H s.tabla
    (funcion_tabla_compatible defecto _ s.sinRepetidos) hcs
  exact (extraer_formato_congruente formatoBase _ H _ hcoinc ruta raiz).trans
    (extension_segura_estable formatoBase H raiz _ _
      (extension_segura_base H raiz _ _ (consulta_y_futuro_seguros H paso futuro hcf raiz hr)) ruta)

theorem vector_base_previo_estable {B : ℕ} {s t fin : Estado B} {q : Solicitud s} {d : Digest}
    (paso : PasoSinAcierto s q d t) (futuro : RecorridoSinAcierto B t fin) (defecto raiz : Digest)
    (hr : raiz ∈ antesRespuesta s q) (altura : ℕ) :
    vectorExtraido formatoBase (funcionTabla defecto s.tabla) (s.tabla.map Prod.fst) altura raiz =
      vectorExtraido formatoBase (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) altura raiz := by
  funext ruta
  exact extraccion_base_previa_estable paso futuro defecto raiz hr (List.ofFn ruta)

theorem apertura_base_previa_respuesta {B : ℕ} {s t fin : Estado B} {q : Solicitud s} {d : Digest}
    (previo : RecorridoSinAcierto B (inicial B) s) (paso : PasoSinAcierto s q d t)
    (futuro : RecorridoSinAcierto B t fin) (defecto raiz : Digest) (hr : raiz ∈ antesRespuesta s q)
    (altura : ℕ) (v : Fp) (hermanos : List (Bool × Digest))
    (ha : Acepta formatoBase (funcionTabla defecto fin.tabla) raiz altura v hermanos)
    (hq : AperturaRegistrada formatoBase (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) v hermanos) :
    extraer formatoBase (funcionTabla defecto s.tabla) (s.tabla.map Prod.fst) (hermanos.map Prod.fst) raiz = v := by
  let H := funcionTabla defecto fin.tabla
  have hcf : Compatibles H fin.tabla := funcion_tabla_compatible defecto _ fin.sinRepetidos
  have todo := recorrido_trans previo (recorrido_trans (paso_es_recorrido paso) futuro)
  have hc0 : SinColisiones H ((inicial B).tabla.map Prod.fst) := by
    intro x hx
    simp only [inicial, List.map_nil, List.not_mem_nil] at hx
  have hc := recorrido_sin_colisiones H todo hcf hc0
  exact (extraccion_base_previa_estable paso futuro defecto raiz hr _).trans
    (apertura_aceptada_extraida formatoBase H _ hc raiz altura v hermanos hq ha)

end Nexus.ROM
