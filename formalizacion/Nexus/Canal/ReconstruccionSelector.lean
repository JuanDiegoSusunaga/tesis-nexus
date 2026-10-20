module

public import Nexus.Canal.TrayectoTG2
public import Nexus.ROM.PrefijoCorte
import Mathlib.Tactic

/-!
# Cadena completa disponible antes de la primera respuesta del selector

Las dependencias de ventanas sitúan cada origen antes del siguiente.
La ausencia de excepciones se usa en inclusiones deterministas, sin
condicionar la ley del selector a un futuro favorable.
-/

public section
namespace Nexus.Canal.ReconstruccionSelector

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open Trayecto TrayectoTG2 PrefijoCorte

theorem ultimo_domina (H : Entrada → Digest) {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) {es : List Entrada} {s : Digest}
    (c : Camino H es s) (hq : ∀ e ∈ es, buscar fin.tabla e = some (H e)) :
    ∃ a ∈ es, H a = s ∧ ∀ e ∈ es, posicionConsulta fin.tabla e ≤ posicionConsulta fin.tabla a := by
  induction c with
  | origen a ha =>
    refine ⟨a, List.mem_singleton_self a, rfl, ?_⟩
    intro e he
    have := List.mem_singleton.mp he
    subst e
    exact le_refl _
  | @paso es s previo e hp hc ih =>
    have hprev : ∀ a ∈ es, buscar fin.tabla a = some (H a) :=
      fun a ha => hq a (List.mem_append_left _ ha)
    obtain ⟨a, ha, hsa, hdom⟩ := ih hprev
    have hw : H a ∈ ventanas e := by
      rw [hsa]
      exact estado_en_ventanas e s hp hc
    have hlt := orden_estricto_por_ventana r a e (H a) (H e)
      (hprev a ha) (hq e (List.mem_append_right _ (List.mem_singleton_self e))) hw
    refine ⟨e, List.mem_append_right _ (List.mem_singleton_self e), rfl, ?_⟩
    intro b hb
    rcases List.mem_append.mp hb with hb | hb
    · exact (hdom b hb).trans hlt.le
    · have := List.mem_singleton.mp hb
      subst b
      exact le_refl _

theorem cadena_antes_corte (H : Entrada → Digest) {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) {es : List Entrada} {s : Digest}
    (c : Camino H es s) (hq : ∀ e ∈ es, buscar fin.tabla e = some (H e))
    {e : Entrada} {d : Digest} (corte : CorteConsulta (inicial B) fin e d) (hw : s ∈ ventanas e) :
    ∀ a ∈ es, buscar corte.antes.tabla a = some (H a) := by
  obtain ⟨a, ha, hs, hdom⟩ := ultimo_domina H r c hq
  have hwa : H a ∈ ventanas e := by simpa only [hs] using hw
  have hp := orden_estricto_por_ventana r a e (H a) d (hq a ha) (corte_respuesta_final corte) hwa
  intro b hb
  exact consulta_anterior corte (hq b hb) (lt_of_le_of_lt (hdom b hb) hp)

theorem recuperar_antes_corte (H : Entrada → Digest) {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (hc : Compatibles H fin.tabla)
    {es : List Entrada} {s : Digest} (c : Camino H es s)
    (hq : ∀ e ∈ es, buscar fin.tabla e = some (H e))
    {e : Entrada} {d : Digest} (corte : CorteConsulta (inicial B) fin e d) (hw : s ∈ ventanas e)
    (n : ℕ) (hn : es.length ≤ n) : recuperar corte.antes.tabla n s = es.reverse := by
  have posterior := recorrido_trans (paso_es_recorrido (corte_paso corte)) corte.sufijo
  have hantes := recorrido_compatible_antes H posterior hc
  have h0 : SinColisiones H ((inicial B).tabla.map Prod.fst) := by
    intro x hx
    simp only [inicial, List.map_nil, List.not_mem_nil] at hx
  have hs := recorrido_sin_colisiones H corte.prefijo hantes h0
  exact reconstruccion_exacta H corte.antes.tabla hantes hs c
    (fun a ha => buscar_some_mem _ _ _ (cadena_antes_corte H r c hq corte hw a ha)) n hn

@[expose] def candidato (t : Tabla Entrada Digest) (s : Digest) : List Entrada :=
  (recuperar t 130 s).reverse

theorem candidato_canal (H : Entrada → Digest) {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (hc : Compatibles H fin.tabla)
    (k bits : ℕ) (inicio salida : Fp) (raiz : Digest) (rt rc : List Digest) (vt vc : Fp2) (n : Nonce)
    (ht : rt.length = k) (hr : rc.length = k + 1) (hk : k ≤ 29)
    (hq : ∀ e ∈ cadena H k bits inicio salida raiz rt rc vt vc n, buscar fin.tabla e = some (H e))
    (d : Digest) (corte : CorteConsulta (inicial B) fin
      (entradaReto (semilla H k bits inicio salida raiz rt rc vt vc n) .indice) d) :
    candidato corte.antes.tabla (semilla H k bits inicio salida raiz rt rc vt vc n) =
      cadena H k bits inicio salida raiz rt rc vt vc n := by
  unfold candidato
  rw [recuperar_antes_corte H r hc (camino_canal H k bits inicio salida raiz rt rc vt vc n) hq corte
    (estado_reto_en_ventanas _ _) 130 (longitud_perfil H k bits inicio salida raiz rt rc vt vc n ht hr hk),
    List.reverse_reverse]

theorem raices_antes_selector (H : Entrada → Digest) {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce)
    (hq : ∀ e ∈ cadena H k bits inicio salida raiz rt rc vt vc n, buscar fin.tabla e = some (H e))
    (d : Digest) (corte : CorteConsulta (inicial B) fin
      (entradaReto (semilla H k bits inicio salida raiz rt rc vt vc n) .indice) d)
    (estado raizAbs : Digest) (tag : Octeto)
    (he : entradaAbsorcion estado tag raizAbs.val ∈ cadena H k bits inicio salida raiz rt rc vt vc n) :
    raizAbs ∈ marcasEstado corte.antes := by
  have hb := cadena_antes_corte H r (camino_canal H k bits inicio salida raiz rt rc vt vc n)
    hq corte (estado_reto_en_ventanas _ _) _ he
  apply raiz_absorbida_estado corte.antes estado raizAbs tag
  rw [← absorcion_raiz_coincide]
  exact List.mem_map.mpr ⟨(_, H _), buscar_some_mem _ _ _ hb, rfl⟩

theorem vector_antes_selector (H : Entrada → Digest) {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce)
    (hq : ∀ e ∈ cadena H k bits inicio salida raiz rt rc vt vc n, buscar fin.tabla e = some (H e))
    (d : Digest) (corte : CorteConsulta (inicial B) fin
      (entradaReto (semilla H k bits inicio salida raiz rt rc vt vc n) .indice) d)
    (estado raizAbs : Digest) (tag : Octeto)
    (he : entradaAbsorcion estado tag raizAbs.val ∈ cadena H k bits inicio salida raiz rt rc vt vc n)
    (defecto : Digest) (altura : ℕ) :
    vectorExtraido formatoBytes (funcionTabla defecto corte.antes.tabla)
      (corte.antes.tabla.map Prod.fst) altura raizAbs =
    vectorExtraido formatoBytes (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) altura raizAbs := by
  exact vector_previo_estable (corte_paso corte) corte.sufijo defecto raizAbs
    (marcas_antes_respuesta _ _ (raices_antes_selector H r k bits inicio salida raiz rt rc vt vc n hq d corte
      estado raizAbs tag he)) altura

end Nexus.Canal.ReconstruccionSelector
