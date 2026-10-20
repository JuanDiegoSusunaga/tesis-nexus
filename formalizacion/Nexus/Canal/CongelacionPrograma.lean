module

public import Nexus.Canal.Intercalaciones
public import Nexus.Merkle.ProgramaVerificacion
import Mathlib.Tactic

/-!
# Congelación desde el registro efectivo del programa global

El programa puede incluir peticiones adversarias arbitrarias y repetidas.
Bajo SinBad, las primeras exposiciones se recuperan de su tabla efectiva.
Una apertura aceptada y registrada se extrae usando exclusivamente la tabla
anterior a la primera respuesta del reto, aunque el verificador la repita.
No se deriva aquí que todas las familias AIR/FRI satisfagan sus premisas.
-/

public section
namespace Nexus.Canal.CongelacionPrograma

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open ProgramaBytes EjecucionBytes

theorem apertura_registrada_en_tabla {R : Type} (H : Entrada → Digest) (B : ℕ)
    (p : Programa R) (v : Fp2) (hermanos : List (Bool × Digest))
    (hq : AperturaRegistrada formatoBytes H (entradas H p) v hermanos) :
    AperturaRegistrada formatoBytes H ((final H (inicial B) p).tabla.map Prod.fst) v hermanos := by
  intro e he
  exact List.mem_map.mpr ⟨(e, H e),
    buscar_some_mem _ _ _ (consulta_en_tabla H _ p (by intro x d hx; contradiction) e (hq e he)), rfl⟩

theorem apertura_antes_del_reto {R : Type} (H : Entrada → Digest) (B : ℕ) (p : Programa R)
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto (final H (inicial B) p) estado tag raiz tipo dAbs dReto)
    (defecto : Digest) (altura : ℕ) (v : Fp2) (hermanos : List (Bool × Digest))
    (ha : Acepta formatoBytes H raiz altura v hermanos)
    (hq : AperturaRegistrada formatoBytes H (entradas H p) v hermanos) :
    extraer formatoBytes (funcionTabla defecto c.segunda.antes.tabla)
      (c.segunda.antes.tabla.map Prod.fst) (hermanos.map Prod.fst) raiz = v := by
  have hc : Compatibles H (final H (inicial B) p).tabla :=
    final_compatible H _ p (by intro e d hd; contradiction)
  have posterior := recorrido_trans (paso_es_recorrido (corte_paso c.segunda)) c.segunda.sufijo
  have hantes := recorrido_compatible_antes H posterior hc
  have hc0 : SinColisiones H ((inicial B).tabla.map Prod.fst) := by
    intro x hx
    simp only [inicial, List.map_nil, List.not_mem_nil] at hx
  have hn := recorrido_sin_colisiones H (segunda_tiene_prefijo c) hantes hc0
  have ext := recorrido_es_seguro H posterior hc raiz (raiz_antes_de_primera_respuesta_reto c)
  have hcoinc := funciones_compatibles_coinciden (funcionTabla defecto c.segunda.antes.tabla) H _
    (funcion_tabla_compatible defecto _ c.segunda.antes.sinRepetidos) hantes
  exact (extraer_congruente _ H _ hcoinc _ raiz).trans
    (apertura_posterior_coincide_congelada formatoBytes H raiz altura _ _ ext hn v hermanos
      (apertura_registrada_en_tabla H B p v hermanos hq) ha)

theorem existe_vector_previo {R : Type} (H : Entrada → Digest) (B : ℕ) (p : Programa R)
    (hs : SinBad H (inicial B) p) (estado raiz : Digest) (tag : Octeto) (tipo : TipoReto)
    (ha : entradaAbsorcion estado tag raiz.val ∈ entradas H p)
    (hr : entradaReto (H (entradaAbsorcion estado tag raiz.val)) tipo ∈ entradas H p)
    (defecto : Digest) (altura : ℕ) :
    ∃ c : CorteRaizReto (final H (inicial B) p) estado tag raiz tipo
        (H (entradaAbsorcion estado tag raiz.val))
        (H (entradaReto (H (entradaAbsorcion estado tag raiz.val)) tipo)),
      ∀ (v : Fp2) (hermanos : List (Bool × Digest)),
        Acepta formatoBytes H raiz altura v hermanos →
        AperturaRegistrada formatoBytes H (entradas H p) v hermanos →
        extraer formatoBytes (funcionTabla defecto c.segunda.antes.tabla)
          (c.segunda.antes.tabla.map Prod.fst) (hermanos.map Prod.fst) raiz = v := by
  obtain ⟨c⟩ := origen_raiz_reto_del_registro H B p hs estado raiz tag tipo ha hr
  exact ⟨c, fun v hermanos hav hqv => apertura_antes_del_reto H B p c defecto altura v hermanos hav hqv⟩

theorem origen_en_verificador_intercalado {A : Type} (H : Entrada → Digest) (B : ℕ)
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (a : A)
    (k bits R : ℕ) (c : Nexus.Verificador.Certificado)
    (hs : SinBad H (inicial B) (Intercalaciones.verificar atacar actualizar a k bits R c))
    (estado raiz : Digest) (tag : Octeto) (tipo : TipoReto)
    (ha : entradaAbsorcion estado tag raiz.val ∈
      RegistroPrograma.entradas H (Nexus.Verificador.Completo.verificar k bits R c))
    (hr : entradaReto (H (entradaAbsorcion estado tag raiz.val)) tipo ∈
      RegistroPrograma.entradas H (Nexus.Verificador.Completo.verificar k bits R c)) :
    Nonempty (CorteRaizReto
      (final H (inicial B) (Intercalaciones.verificar atacar actualizar a k bits R c))
      estado tag raiz tipo (H (entradaAbsorcion estado tag raiz.val))
      (H (entradaReto (H (entradaAbsorcion estado tag raiz.val)) tipo))) := by
  apply origen_raiz_reto_del_registro H B _ hs estado raiz tag tipo
  · exact (Intercalaciones.registro_intercalado H atacar actualizar _ a).subset ha
  · exact (Intercalaciones.registro_intercalado H atacar actualizar _ a).subset hr

end Nexus.Canal.CongelacionPrograma
