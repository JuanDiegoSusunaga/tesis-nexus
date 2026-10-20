module

public import Nexus.Canal.VistaCausal
import Mathlib.Tactic

/-!
# El pasado de cada alfa AIR recupera su contexto anterior

Antes de la primera consulta de alfa_j se recuperan el preámbulo y los
j retos anteriores usando únicamente la tabla y el estado de esa consulta.
El límite es siete pasos, también para consultas anticipadas del adversario.
-/

public section
namespace Nexus.Canal.PrefijoAIR

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open GramaticaTG2 RegistroRaices ParametrosRecuperados
open Nexus.Verificador.FiltroFalso

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def base (H : Entrada → Digest) (d : DatosCanal) : Evento :=
  (RegistroCompleto.evaluar H d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc).base

@[expose] def preambulo (H : Entrada → Digest) (d : DatosCanal) : List Entrada :=
  let s0 := H (codificar .inicio)
  let s1 := H (entrada s0 (.perfil (ProgramaTG2.perfil d.k d.bits)))
  [codificar .inicio, entrada s0 (.perfil (ProgramaTG2.perfil d.k d.bits)),
    entrada s1 (.enunciado (ProgramaTG2.enunciado d.inicio d.salida d.k)), absorcion (base H d)]

@[expose] def cadena (H : Entrada → Digest) (d : DatosCanal) (j : ℕ) : List Entrada :=
  preambulo H d ++ logRetos H j (H (absorcion (base H d)))

@[expose] def estado (H : Entrada → Digest) (d : DatosCanal) (j : ℕ) : Digest :=
  (evaluarRetos H j (H (absorcion (base H d)))).1

theorem camino_preambulo (H : Entrada → Digest) (d : DatosCanal) :
    Trayecto.Camino H (preambulo H d) (H (absorcion (base H d))) := by
  let s0 := H (codificar .inicio)
  let s1 := H (entrada s0 (.perfil (ProgramaTG2.perfil d.k d.bits)))
  let s2 := H (entrada s1 (.enunciado (ProgramaTG2.enunciado d.inicio d.salida d.k)))
  have h0 : Trayecto.Camino H [codificar .inicio] s0 := .origen _ (by decide)
  have h1 := TrayectoTG2.agregar_absorcion H h0 (.perfil (ProgramaTG2.perfil d.k d.bits))
  have h2 := TrayectoTG2.agregar_absorcion H h1 (.enunciado (ProgramaTG2.enunciado d.inicio d.salida d.k))
  have h3 := TrayectoTG2.agregar_absorcion H h2 (.raizTraza d.raiz)
  simpa only [preambulo, base, RegistroCompleto.evaluar, codificar, entrada, etiqueta, datos,
    absorcion, s0, s1, s2, List.append_assoc, List.singleton_append,
    List.cons_append, List.nil_append] using h3

theorem camino (H : Entrada → Digest) (d : DatosCanal) (j : ℕ) :
    Trayecto.Camino H (cadena H d j) (estado H d j) :=
  TrayectoTG2.prolongar_retos H j _ _ (camino_preambulo H d)

theorem longitud (H : Entrada → Digest) (d : DatosCanal) (j : ℕ) :
    (cadena H d j).length = 4 + j := by
  have hl (n : ℕ) (s : Digest) : (logRetos H n s).length = n := by
    induction n generalizing s with
    | zero => rfl
    | succ n ih => simp only [logRetos, List.length_cons, ih]
  simp only [cadena, preambulo, List.length_append, List.length_cons, List.length_nil, hl]

theorem log_es_prefijo (H : Entrada → Digest) (j n : ℕ) (s : Digest) (hj : j ≤ n) :
    logRetos H j s = (logRetos H n s).take j := by
  induction j generalizing n s with
  | zero => simp only [logRetos, List.take_zero]
  | succ j ih =>
    cases n with
    | zero => omega
    | succ n => simpa only [logRetos, List.take_succ_cons] using
        congrArg (List.cons (entradaReto s .extension)) (ih n _ (by omega))

theorem siguiente_en_log (H : Entrada → Digest) (j n : ℕ) (s : Digest) (hj : j < n) :
    entradaReto (evaluarRetos H j s).1 .extension ∈ logRetos H n s := by
  induction j generalizing n s with
  | zero => cases n with
    | zero => omega
    | succ n => exact List.mem_cons_self
  | succ j ih => cases n with
    | zero => omega
    | succ n => exact List.mem_cons_of_mem _ (ih n _ (by omega))

theorem cadena_registrada (H : Entrada → Digest) (d : DatosCanal) (j : ℕ) (hj : j ≤ 3) :
    ∀ e ∈ cadena H d j, e ∈ RegistroCompleto.prefijo H d.k d.bits d.inicio d.salida
      d.raiz d.rt d.rc d.vt d.vc := by
  intro e he
  rcases List.mem_append.mp he with he | he
  · dsimp only [preambulo, base] at he
    simp only [RegistroCompleto.prefijo, List.mem_append]
    exact Or.inl (Or.inl (Or.inl (Or.inl (Or.inl he))))
  · have hm := List.mem_of_mem_take (log_es_prefijo H j 3 _ hj ▸ he)
    dsimp only [base] at hm
    simp only [RegistroCompleto.prefijo, List.mem_append]
    tauto

theorem siguiente_registrada (H : Entrada → Digest) (d : DatosCanal) (j : ℕ) (hj : j < 3) :
    entradaReto (estado H d j) .extension ∈ RegistroCompleto.prefijo H d.k d.bits d.inicio d.salida
      d.raiz d.rt d.rc d.vt d.vc := by
  have hm := siguiente_en_log H j 3 (H (absorcion (base H d))) hj
  dsimp only [base] at hm
  simp only [RegistroCompleto.prefijo, List.mem_append]
  tauto

theorem consulta_canonica (t : Tabla Entrada Digest) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico t defecto s d) (e : Entrada)
    (he : e ∈ RegistroCompleto.prefijo (funcionTabla defecto t) d.k d.bits d.inicio d.salida
      d.raiz d.rt d.rc d.vt d.vc) : buscar t e = some (funcionTabla defecto t e) := by
  apply hc.conocidas
  rw [hc.cadena]
  exact List.mem_append_left _ he

abbrev Corte {B : ℕ} (fin : Estado B) (defecto : Digest) (d : DatosCanal) (j : ℕ) :=
  CorteConsulta (inicial B) fin (entradaReto (estado (funcionTabla defecto fin.tabla) d j) .extension)
    (funcionTabla defecto fin.tabla (entradaReto (estado (funcionTabla defecto fin.tabla) d j) .extension))

theorem existe_corte {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (j : ℕ) (hj : j < 3) :
    Nonempty (Corte fin defecto d j) := by
  exact origen_desde_vacio r _ _ (consulta_canonica fin.tabla defecto s d hc _
    (siguiente_registrada (funcionTabla defecto fin.tabla) d j hj))

theorem reconstruccion_previa {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (j : ℕ) (hj : j < 3) (c : Corte fin defecto d j) :
    Trayecto.recuperar c.antes.tabla 7 (estado (funcionTabla defecto fin.tabla) d j) =
      (cadena (funcionTabla defecto fin.tabla) d j).reverse := by
  exact ReconstruccionSelector.recuperar_antes_corte (funcionTabla defecto fin.tabla) r
    (funcion_tabla_compatible defecto fin.tabla fin.sinRepetidos) (camino _ d j)
    (fun e he => consulta_canonica fin.tabla defecto s d hc e (cadena_registrada _ d j (by omega) e he))
    c (estado_reto_en_ventanas _ _) 7 (by rw [longitud]; omega)

theorem raiz_antes_alfa {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (j : ℕ) (hj : j < 3) (c : Corte fin defecto d j) :
    d.raiz ∈ marcasEstado c.antes := by
  let G := funcionTabla defecto fin.tabla
  have he : absorcion (base G d) ∈ cadena G d j := by
    exact List.mem_append_left _ (by simp only [preambulo, List.mem_cons, List.not_mem_nil, or_false]; tauto)
  have hq := ReconstruccionSelector.cadena_antes_corte G r (camino G d j)
    (fun e he => consulta_canonica fin.tabla defecto s d hc e (cadena_registrada _ d j (by omega) e he))
    c (estado_reto_en_ventanas _ _) _ he
  apply raiz_absorbida_estado c.antes (base G d).estado d.raiz 1
  rw [← absorcion_raiz_coincide]
  exact List.mem_map.mpr ⟨(_, G _), buscar_some_mem _ _ _ hq, rfl⟩

theorem oraculo_antes_alfa {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (j : ℕ) (hj : j < 3) (c : Corte fin defecto d j) :
    oraculoTraza (VistaCampo.prefijo (VistaSemantica.construir fin.tabla defecto d
      (ReconstruccionSelector.candidato fin.tabla s))) 0 =
      oraculoEnEstado d.k 0 defecto c.antes d.raiz := by
  have hroot := raiz_antes_alfa r defecto s d hc j hj c
  have hv := vector_previo_estable (corte_paso c) c.sufijo defecto d.raiz
    (marcas_antes_respuesta _ _ hroot) (d.k + 3 - 0)
  have ho := oraculos_merkle_iguales d.k 0 _ _ _ _ d.raiz
    (vectores_indexados_iguales formatoBytes _ _ _ _ (d.k + 3 - 0) d.raiz hv)
  calc
    _ = oraculoEnEstado d.k 0 defecto fin d.raiz := by
      rw [VistaCampo.traza_inicial _ (VistaCampo.forma_canonica fin.tabla defecto s d hc)]
      exact VectoresCampo.funcion_valor d.k 0 fin.tabla defecto d.raiz
    _ = _ := ho.symm

end Nexus.Canal.PrefijoAIR
