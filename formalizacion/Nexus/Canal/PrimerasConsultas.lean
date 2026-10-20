module

public import Nexus.ROM.OrdenConsultas
public import Nexus.Canal.Raices
import Mathlib.Tactic

/-!
# Raíz congelada antes de la primera exposición del reto

Se recupera el origen nuevo de la absorción a partir del registro completo.
Su respuesta no puede aparecer en una entrada consultada antes. La entrada
del reto contiene esa respuesta como prefijo y por ello su primera consulta
queda después. Las repeticiones actuales no cambian esos instantes.
-/

public section
namespace Nexus.Canal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM

theorem estado_reto_en_ventanas (estado : Digest) (tipo : TipoReto) :
    estado ∈ ventanas (entradaReto estado tipo) :=
  digest_prefijo_en_ventanas estado [etiquetaReto tipo] (by simp)

theorem estado_absorcion_en_ventanas (estado : Digest) (tag : Octeto) (datos : List Octeto)
    (hd : datos.length ≤ 38) : estado ∈ ventanas (entradaAbsorcion estado tag datos) := by
  have he : entradaAbsorcion estado tag datos = estado.val ++ (tag :: (codificarLE 8 datos.length ++ datos)) := by
    simp only [entradaAbsorcion, cabecera, List.append_assoc, List.cons_append, List.nil_append]
  rw [he]
  apply digest_prefijo_en_ventanas
  simp only [List.length_cons, List.length_append, codificar_le_longitud]
  omega

theorem estado_trabajo_en_ventanas (estado : Digest) (nonce : Nonce) :
    estado ∈ ventanas (entradaTrabajo estado nonce) := by
  have he : entradaTrabajo estado nonce = estado.val ++ (5 :: codificarLE 8 nonce.val) := by
    simp only [entradaTrabajo, cabecera, List.append_assoc, List.cons_append, List.nil_append]
  rw [he]
  apply digest_prefijo_en_ventanas
  simp only [List.length_cons, codificar_le_longitud]
  omega

theorem reto_nuevo_tras_respuesta {B : ℕ} (s : Estado B) (q : Solicitud s) (d : Digest)
    (hn : buscar s.tabla q.entrada = none) (hd : d ∉ antesRespuesta s q) (tipo : TipoReto) :
    buscar (estadoNuevo s q d hn).tabla (entradaReto d tipo) = none :=
  entrada_con_respuesta_ausente_despues s q d hn hd _ (estado_reto_en_ventanas d tipo)

abbrev CorteRaizReto {B : ℕ} (fin : Estado B) (estado : Digest) (tag : Octeto) (raiz : Digest)
    (tipo : TipoReto) (dAbs dReto : Digest) :=
  ConsultasOrdenadas fin (entradaAbsorcion estado tag raiz.val) (entradaReto dAbs tipo) dAbs dReto

theorem origenes_raiz_reto {B : ℕ} {fin : Estado B} (r : RecorridoSinAcierto B (inicial B) fin)
    (estado : Digest) (tag : Octeto) (raiz : Digest) (tipo : TipoReto) (dAbs dReto : Digest)
    (ha : buscar fin.tabla (entradaAbsorcion estado tag raiz.val) = some dAbs)
    (hr : buscar fin.tabla (entradaReto dAbs tipo) = some dReto) :
    Nonempty (CorteRaizReto fin estado tag raiz tipo dAbs dReto) :=
  origenes_ordenados_por_ventana r _ _ dAbs dReto ha hr (estado_reto_en_ventanas dAbs tipo)

theorem posicion_reto_posterior_absorcion {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (estado : Digest) (tag : Octeto) (raiz : Digest)
    (tipo : TipoReto) (dAbs dReto : Digest)
    (ha : buscar fin.tabla (entradaAbsorcion estado tag raiz.val) = some dAbs)
    (hr : buscar fin.tabla (entradaReto dAbs tipo) = some dReto) :
    posicionConsulta fin.tabla (entradaAbsorcion estado tag raiz.val) <
      posicionConsulta fin.tabla (entradaReto dAbs tipo) :=
  orden_estricto_por_ventana r _ _ dAbs dReto ha hr (estado_reto_en_ventanas dAbs tipo)

theorem raiz_marcada_en_origen {B : ℕ} {fin : Estado B} {estado raiz dAbs dReto : Digest}
    {tag : Octeto} {tipo : TipoReto} (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto) :
    raiz ∈ antesRespuesta c.primera.antes c.primera.solicitud := by
  apply Finset.mem_union_right
  rw [c.primera.entrada_eq, absorcion_raiz_coincide]
  exact raiz_absorbida_en_ventanas estado tag raiz

theorem raiz_antes_de_primera_respuesta_reto {B : ℕ} {fin : Estado B} {estado raiz dAbs dReto : Digest}
    {tag : Octeto} {tipo : TipoReto} (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto) :
    raiz ∈ marcasEstado c.segunda.antes :=
  recorrido_marcas_mono c.segunda.prefijo
    (marcas_previas_persisten (corte_paso c.primera) (raiz_marcada_en_origen c))

theorem vector_antes_primera_exposicion {B : ℕ} {fin : Estado B} {estado raiz dAbs dReto : Digest}
    {tag : Octeto} {tipo : TipoReto} (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto)
    (defecto : Digest) (altura : ℕ) :
    vectorExtraido formatoBytes (funcionTabla defecto c.primera.antes.tabla)
      (c.primera.antes.tabla.map Prod.fst) altura raiz =
    vectorExtraido formatoBytes (funcionTabla defecto c.segunda.antes.tabla)
      (c.segunda.antes.tabla.map Prod.fst) altura raiz :=
  vector_previo_estable (corte_paso c.primera) c.segunda.prefijo defecto raiz
    (raiz_marcada_en_origen c) altura

theorem apertura_desde_origen_raiz {B : ℕ} {fin : Estado B} {estado raiz dAbs dReto : Digest}
    {tag : Octeto} {tipo : TipoReto} (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto)
    (defecto : Digest) (altura : ℕ) (v : Fp2) (hermanos : List (Bool × Digest))
    (ha : Acepta formatoBytes (funcionTabla defecto fin.tabla) raiz altura v hermanos)
    (hq : AperturaRegistrada formatoBytes (funcionTabla defecto fin.tabla)
      (fin.tabla.map Prod.fst) v hermanos) :
    extraer formatoBytes (funcionTabla defecto c.primera.antes.tabla)
      (c.primera.antes.tabla.map Prod.fst) (hermanos.map Prod.fst) raiz = v :=
  apertura_previa_respuesta c.primera.prefijo (corte_paso c.primera) c.primera.sufijo
    defecto raiz (raiz_marcada_en_origen c) altura v hermanos ha hq

theorem apertura_antes_primera_consulta_reto {B : ℕ} {fin : Estado B} {estado raiz dAbs dReto : Digest}
    {tag : Octeto} {tipo : TipoReto} (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto)
    (defecto : Digest) (altura : ℕ) (v : Fp2) (hermanos : List (Bool × Digest))
    (ha : Acepta formatoBytes (funcionTabla defecto fin.tabla) raiz altura v hermanos)
    (hq : AperturaRegistrada formatoBytes (funcionTabla defecto fin.tabla)
      (fin.tabla.map Prod.fst) v hermanos) :
    extraer formatoBytes (funcionTabla defecto c.segunda.antes.tabla)
      (c.segunda.antes.tabla.map Prod.fst) (hermanos.map Prod.fst) raiz = v :=
  apertura_previa_respuesta (segunda_tiene_prefijo c) (corte_paso c.segunda) c.segunda.sufijo
    defecto raiz (marcas_antes_respuesta _ _ (raiz_antes_de_primera_respuesta_reto c)) altura v hermanos ha hq

theorem existe_congelacion_primera_exposicion {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (estado : Digest) (tag : Octeto) (raiz : Digest)
    (tipo : TipoReto) (dAbs dReto : Digest)
    (ha : buscar fin.tabla (entradaAbsorcion estado tag raiz.val) = some dAbs)
    (hr : buscar fin.tabla (entradaReto dAbs tipo) = some dReto) (defecto : Digest) (altura : ℕ) :
    ∃ c : CorteRaizReto fin estado tag raiz tipo dAbs dReto,
      ∀ (v : Fp2) (hermanos : List (Bool × Digest)),
        Acepta formatoBytes (funcionTabla defecto fin.tabla) raiz altura v hermanos →
        AperturaRegistrada formatoBytes (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) v hermanos →
        extraer formatoBytes (funcionTabla defecto c.segunda.antes.tabla)
          (c.segunda.antes.tabla.map Prod.fst) (hermanos.map Prod.fst) raiz = v := by
  obtain ⟨c⟩ := origenes_raiz_reto r estado tag raiz tipo dAbs dReto ha hr
  exact ⟨c, fun v hermanos hav hqv => apertura_antes_primera_consulta_reto c defecto altura v hermanos hav hqv⟩

end Nexus.Canal
