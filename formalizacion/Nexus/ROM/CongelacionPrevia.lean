module

public import Nexus.ROM.Preparacion
import Mathlib.Tactic

/-!
# Vector fijado antes de la respuesta que procesa una raíz

El vector se calcula con la tabla previa a la consulta. La raíz puede estar
solo en las marcas preparadas por la solicitud y sus ventanas. La respuesta
actual y todas las posteriores conservan ese vector fuera de aciertos.
-/

public section
namespace Nexus.ROM

open Nexus.Merkle Nexus.Goldilocks

theorem extensiones_seguras_componer (H : Entrada → Digest) (raiz : Digest)
    (a b c : List Entrada) (hab : ExtensionSegura formatoBytes H raiz a b)
    (hbc : ExtensionSegura formatoBytes H raiz b c) : ExtensionSegura formatoBytes H raiz a c := by
  induction hbc with
  | refl => exact hab
  | paso previo e hn ih => exact .paso ih e hn

theorem consulta_y_futuro_seguros (H : Entrada → Digest) {B : ℕ} {s t fin : Estado B}
    {q : Solicitud s} {d : Digest} (paso : PasoSinAcierto s q d t)
    (futuro : RecorridoSinAcierto B t fin) (hc : Compatibles H fin.tabla)
    (raiz : Digest) (hr : raiz ∈ antesRespuesta s q) :
    ExtensionSegura formatoBytes H raiz (s.tabla.map Prod.fst) (fin.tabla.map Prod.fst) := by
  have hct := recorrido_compatible_antes H futuro hc
  exact extensiones_seguras_componer H raiz _ _ _
    (paso_seguro_desde_preparacion H paso hct raiz hr)
    (recorrido_es_seguro H futuro hc raiz (marcas_previas_persisten paso hr))

theorem extraccion_previa_estable {B : ℕ} {s t fin : Estado B} {q : Solicitud s} {d : Digest}
    (paso : PasoSinAcierto s q d t) (futuro : RecorridoSinAcierto B t fin) (defecto raiz : Digest)
    (hr : raiz ∈ antesRespuesta s q) (ruta : List Bool) :
    extraer formatoBytes (funcionTabla defecto s.tabla) (s.tabla.map Prod.fst) ruta raiz =
      extraer formatoBytes (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) ruta raiz := by
  let H := funcionTabla defecto fin.tabla
  have hcf : Compatibles H fin.tabla := funcion_tabla_compatible defecto _ fin.sinRepetidos
  have hcs := recorrido_compatible_antes H (recorrido_trans (paso_es_recorrido paso) futuro) hcf
  have hcoinc := funciones_compatibles_coinciden (funcionTabla defecto s.tabla) H s.tabla
    (funcion_tabla_compatible defecto _ s.sinRepetidos) hcs
  exact (extraer_congruente _ H _ hcoinc ruta raiz).trans
    (extension_segura_estable formatoBytes H raiz _ _
      (consulta_y_futuro_seguros H paso futuro hcf raiz hr) ruta)

theorem vector_previo_estable {B : ℕ} {s t fin : Estado B} {q : Solicitud s} {d : Digest}
    (paso : PasoSinAcierto s q d t) (futuro : RecorridoSinAcierto B t fin) (defecto raiz : Digest)
    (hr : raiz ∈ antesRespuesta s q) (altura : ℕ) :
    vectorExtraido formatoBytes (funcionTabla defecto s.tabla) (s.tabla.map Prod.fst) altura raiz =
      vectorExtraido formatoBytes (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) altura raiz := by
  funext ruta
  exact extraccion_previa_estable paso futuro defecto raiz hr (List.ofFn ruta)

theorem apertura_previa_respuesta {B : ℕ} {s t fin : Estado B} {q : Solicitud s} {d : Digest}
    (previo : RecorridoSinAcierto B (inicial B) s) (paso : PasoSinAcierto s q d t)
    (futuro : RecorridoSinAcierto B t fin) (defecto raiz : Digest) (hr : raiz ∈ antesRespuesta s q)
    (altura : ℕ) (v : Fp2) (hermanos : List (Bool × Digest))
    (ha : Acepta formatoBytes (funcionTabla defecto fin.tabla) raiz altura v hermanos)
    (hq : AperturaRegistrada formatoBytes (funcionTabla defecto fin.tabla)
      (fin.tabla.map Prod.fst) v hermanos) :
    extraer formatoBytes (funcionTabla defecto s.tabla)
      (s.tabla.map Prod.fst) (hermanos.map Prod.fst) raiz = v := by
  let H := funcionTabla defecto fin.tabla
  have hcf : Compatibles H fin.tabla := funcion_tabla_compatible defecto _ fin.sinRepetidos
  have todo := recorrido_trans previo (recorrido_trans (paso_es_recorrido paso) futuro)
  have hc0 : SinColisiones H ((inicial B).tabla.map Prod.fst) := by
    intro x hx
    simp only [inicial, List.map_nil, List.not_mem_nil] at hx
  have hc := recorrido_sin_colisiones H todo hcf hc0
  exact (extraccion_previa_estable paso futuro defecto raiz hr _).trans
    (apertura_aceptada_extraida formatoBytes H _ hc raiz altura v hermanos hq ha)

end Nexus.ROM
