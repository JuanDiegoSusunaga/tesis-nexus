module

public import Nexus.Canal.Entradas
public import Nexus.ROM.CongelacionPrevia
import Mathlib.Tactic

/-!
# Absorción de raíz y reto con estado encadenado

La entrada del reto usa la respuesta efectiva de la absorción anterior.
El vector se congela con la tabla previa a ambas respuestas. Los pasos
permiten consultas repetidas; sus resultados proceden de la memoria.
La transformación del digest en un reto de campo queda separada.
-/

public section
namespace Nexus.Canal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM

@[expose] def solicitudAbsorcion {B : ℕ} (s : Estado B) (estado : Digest) (tag : Octeto)
    (datos : List Octeto) : Solicitud s :=
  ⟨entradaAbsorcion estado tag datos, ∅, by simpa only [Finset.union_empty] using s.cotaAdicionales⟩

@[expose] def solicitudRaiz {B : ℕ} (s : Estado B) (estado : Digest) (tag : Octeto)
    (raiz : Digest) : Solicitud s := solicitudAbsorcion s estado tag raiz.val

@[expose] def solicitudReto {B : ℕ} (s : Estado B) (estado : Digest) (tipo : TipoReto) : Solicitud s :=
  ⟨entradaReto estado tipo, ∅, by simpa only [Finset.union_empty] using s.cotaAdicionales⟩

theorem raiz_preparada {B : ℕ} (s : Estado B) (estado : Digest) (tag : Octeto) (raiz : Digest) :
    raiz ∈ antesRespuesta s (solicitudRaiz s estado tag raiz) := by
  apply Finset.mem_union_right
  change raiz ∈ ventanas (entradaAbsorcion estado tag raiz.val)
  rw [absorcion_raiz_coincide]
  exact raiz_absorbida_en_ventanas estado tag raiz

theorem raiz_persiste_tras_absorcion {B : ℕ} {s t : Estado B} (estado : Digest) (tag : Octeto)
    (raiz d : Digest) (paso : PasoSinAcierto s (solicitudRaiz s estado tag raiz) d t) :
    raiz ∈ marcasEstado t := marcas_previas_persisten paso (raiz_preparada s estado tag raiz)

structure SecuenciaRaizReto {B : ℕ} (s : Estado B) (estado : Digest) (tag : Octeto)
    (raiz : Digest) (tipo : TipoReto) where
  trasRaiz : Estado B
  respuestaRaiz : Digest
  pasoRaiz : PasoSinAcierto s (solicitudRaiz s estado tag raiz) respuestaRaiz trasRaiz
  trasReto : Estado B
  respuestaReto : Digest
  pasoReto : PasoSinAcierto trasRaiz (solicitudReto trasRaiz respuestaRaiz tipo) respuestaReto trasReto

theorem secuencia_es_recorrido {B : ℕ} {s : Estado B} {estado raiz : Digest} {tag : Octeto}
    {tipo : TipoReto} (c : SecuenciaRaizReto s estado tag raiz tipo) :
    RecorridoSinAcierto B s c.trasReto :=
  recorrido_trans (paso_es_recorrido c.pasoRaiz) (paso_es_recorrido c.pasoReto)

theorem raiz_previa_al_reto {B : ℕ} {s : Estado B} {estado raiz : Digest} {tag : Octeto}
    {tipo : TipoReto} (c : SecuenciaRaizReto s estado tag raiz tipo) :
    raiz ∈ antesRespuesta c.trasRaiz (solicitudReto c.trasRaiz c.respuestaRaiz tipo) :=
  marcas_antes_respuesta _ _ (raiz_persiste_tras_absorcion estado tag raiz c.respuestaRaiz c.pasoRaiz)

theorem respuestas_encadenadas (H : Entrada → Digest) {B : ℕ} {s : Estado B}
    {estado raiz : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : SecuenciaRaizReto s estado tag raiz tipo) (hc : Compatibles H c.trasReto.tabla) :
    H (entradaAbsorcion estado tag raiz.val) = c.respuestaRaiz ∧
      H (entradaReto c.respuestaRaiz tipo) = c.respuestaReto := by
  have hcr := recorrido_compatible_antes H (paso_es_recorrido c.pasoReto) hc
  exact ⟨paso_respuesta_compatible H c.pasoRaiz hcr, paso_respuesta_compatible H c.pasoReto hc⟩

theorem vector_antes_del_reto {B : ℕ} {s : Estado B} {estado raiz : Digest} {tag : Octeto}
    {tipo : TipoReto} (c : SecuenciaRaizReto s estado tag raiz tipo) (defecto : Digest) (altura : ℕ) :
    vectorExtraido formatoBytes (funcionTabla defecto s.tabla) (s.tabla.map Prod.fst) altura raiz =
      vectorExtraido formatoBytes (funcionTabla defecto c.trasRaiz.tabla)
        (c.trasRaiz.tabla.map Prod.fst) altura raiz :=
  vector_previo_estable c.pasoRaiz (.refl _) defecto raiz (raiz_preparada s estado tag raiz) altura

theorem vector_antes_de_ambas_respuestas {B : ℕ} {s fin : Estado B} {estado raiz : Digest}
    {tag : Octeto} {tipo : TipoReto} (c : SecuenciaRaizReto s estado tag raiz tipo)
    (futuro : RecorridoSinAcierto B c.trasReto fin) (defecto : Digest) (altura : ℕ) :
    vectorExtraido formatoBytes (funcionTabla defecto s.tabla) (s.tabla.map Prod.fst) altura raiz =
      vectorExtraido formatoBytes (funcionTabla defecto fin.tabla)
        (fin.tabla.map Prod.fst) altura raiz :=
  vector_previo_estable c.pasoRaiz (recorrido_trans (paso_es_recorrido c.pasoReto) futuro)
    defecto raiz (raiz_preparada s estado tag raiz) altura

theorem apertura_fijada_antes_de_ambas {B : ℕ} {s fin : Estado B} {estado raiz : Digest}
    {tag : Octeto} {tipo : TipoReto} (previo : RecorridoSinAcierto B (inicial B) s)
    (c : SecuenciaRaizReto s estado tag raiz tipo) (futuro : RecorridoSinAcierto B c.trasReto fin)
    (defecto : Digest) (altura : ℕ) (v : Fp2) (hermanos : List (Bool × Digest))
    (ha : Acepta formatoBytes (funcionTabla defecto fin.tabla) raiz altura v hermanos)
    (hq : AperturaRegistrada formatoBytes (funcionTabla defecto fin.tabla)
      (fin.tabla.map Prod.fst) v hermanos) :
    extraer formatoBytes (funcionTabla defecto s.tabla)
      (s.tabla.map Prod.fst) (hermanos.map Prod.fst) raiz = v :=
  apertura_previa_respuesta previo c.pasoRaiz (recorrido_trans (paso_es_recorrido c.pasoReto) futuro)
    defecto raiz (raiz_preparada s estado tag raiz) altura v hermanos ha hq

end Nexus.Canal
