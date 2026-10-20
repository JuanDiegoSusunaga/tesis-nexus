module

public import Nexus.Verificador.ValoresConsulta
public import Nexus.Verificador.RetosVista
import Mathlib.Tactic

/-!
# Una consulta aceptada satisface los controles de GT y GC

Las dos fases usan las mismas seis posiciones AIR y los retos efectivos.
Las igualdades de valores extraídos se obtienen del soporte en la instancia
del programa completo, sin suponer controles locales adicionales.
-/

public section
namespace Nexus.Verificador.ConsultaBuena

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open ProgramaCompartido RegistroPrograma CandidatoPrevio SemanticaPrevia
open VistaSemantica ConjuntosPrevios Recorrido

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem enlace_traza_valores (q : Consulta) (f : Fin 6 → Punto) (d : Apertura) (ds : List Apertura)
    (hf : q.traza = List.ofFn f) (hd : q.friTraza = d :: ds)
    (ha : ProgramaConsulta.enlaceTraza q = true) :
    d.izquierda = algebraMap Fp Fp2 (f 0).valor ∧ d.derecha = algebraMap Fp Fp2 (f 3).valor := by
  simpa only [ProgramaConsulta.enlaceTraza, hf, ValoresConsulta.seis_puntos, hd,
    decide_eq_true_eq] using ha

theorem enlace_composicion_valores (k i : ℕ) (e : Enunciado) (a0 a1 a2 : Fp2)
    (q : Consulta) (f : Fin 6 → Punto) (d : Apertura) (ds : List Apertura)
    (hf : q.traza = List.ofFn f) (hd : q.friComposicion = d :: ds)
    (ha : ProgramaConsulta.enlaceComposicion k i e [a0, a1, a2] q = true) :
    let x : Fp := 7 * raiz (k + 3) ^ i
    d.izquierda = componerBase (2 ^ k) (raiz k) e.inicio e.salida x
      (a0, a1, a2) ![(f 0).valor, (f 1).valor, (f 2).valor] ∧
    d.derecha = componerBase (2 ^ k) (raiz k) e.inicio e.salida (-x)
      (a0, a1, a2) ![(f 3).valor, (f 4).valor, (f 5).valor] := by
  simpa only [ProgramaConsulta.enlaceComposicion, hf, ValoresConsulta.seis_puntos, hd,
    decide_eq_true_eq] using ha

theorem consulta_en_vista (H : Entrada → Digest) (t : Tabla Entrada Digest) (defecto : Digest)
    (k bits : ℕ) (c : Certificado) (hf : Forma k bits c)
    (hq : ∀ e ∈ cadenaCert H k bits c, buscar t e = some (H e)) (i : ℕ) (hi : i < 2 ^ (k + 2))
    (q : Consulta)
    (ha : resultado (tabla H) (ProgramaConsulta.verificar k i c.enunciado c.prueba
      (SoporteCompleto.vista H k bits c).alfas.2
      ((SoporteCompleto.vista H k bits c).traza.2.map (RegistroRaices.beta H))
      ((SoporteCompleto.vista H k bits c).composicion.2.map (RegistroRaices.beta H)) q) = true)
    (hv : ∀ a ∈ SoporteConsulta.aperturas k i c.prueba
      ((SoporteCompleto.vista H k bits c).traza.2.map (RegistroRaices.beta H))
      ((SoporteCompleto.vista H k bits c).composicion.2.map (RegistroRaices.beta H)) q,
      valor t defecto a.altura a.raiz a.indice = a.valor) :
    let v := construir t defecto (datosCert k bits c) (cadenaCert H k bits c)
    pruebaTraza v i ∧ pruebaComposicion v i := by
  let v := construir t defecto (datosCert k bits c) (cadenaCert H k bits c)
  let canal := SoporteCompleto.vista H k bits c
  have hh := (ProgramaConsulta.aceptacion_controles H k i c.enunciado c.prueba
    canal.alfas.2 (canal.traza.2.map (RegistroRaices.beta H))
    (canal.composicion.2.map (RegistroRaices.beta H)) q).mp ha
  obtain ⟨f, hfun⟩ := ValoresConsulta.puntos_como_funcion q hh.1
  have hb := ValoresConsulta.valores_air t defecto k i c.prueba _ _ q f hfun hv
  have hcan : baseCanonica v i := by
    intro j
    change valor t defecto (k + 3) c.prueba.raiz
      (IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i j) =
      algebraMap Fp Fp2 (valor t defecto (k + 3) c.prueba.raiz
        (IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i j)).re
    rw [hb j]
    rfl
  have hre (j : Fin 6) : (v.base (IndicesMaquina.posicionesNaturales (2 ^ (k + 3)) i j)).re = (f j).valor := by
    change (valor t defecto (k + 3) c.prueba.raiz _).re = _
    rw [hb j]
    rfl
  have hbt := ValoresConsulta.fri_traza t defecto k i c.prueba _ _ q hv
  have hbc := ValoresConsulta.fri_composicion t defecto k i c.prueba _ _ q hv
  have hct := ControlesValores.verificacion_valores H t defecto k k i c.prueba.traza.raices
    (canal.traza.2.map (RegistroRaices.beta H)) q.friTraza c.prueba.traza.final hh.2.2.2.1 hbt
  have hcc := ControlesValores.verificacion_valores H t defecto k (k + 1) i c.prueba.composicion.raices
    (canal.composicion.2.map (RegistroRaices.beta H)) q.friComposicion c.prueba.composicion.final hh.2.2.2.2.2 hbc
  obtain ⟨rt, rts, dt, dts, hrt, hdt, htl, htr⟩ := ControlesValores.primera_verificacion H t defecto k k i hi
    (by have hk := hf.1.1; omega) _ _ _ _ hh.2.2.2.1 hbt
  obtain ⟨rc, rcs, dc, dcs, hrc, hdc, hcl, hcr⟩ := ControlesValores.primera_verificacion H t defecto k (k + 1) i hi
    (by omega) _ _ _ _ hh.2.2.2.2.2 hbc
  have hvt : v.traza = valor t defecto (k + 3) rt :: CapasIndexadas.desde t defecto (k + 3) 1 rts := by
    change capas t defecto (k + 3) c.prueba.traza.raices = _
    rw [hrt, CapasIndexadas.capas_desde]
    rfl
  have hvc : v.composicion = valor t defecto (k + 3) rc :: CapasIndexadas.desde t defecto (k + 3) 1 rcs := by
    change capas t defecto (k + 3) c.prueba.composicion.raices = _
    rw [hrc, CapasIndexadas.capas_desde]
    rfl
  have hseg := RetosVista.segmentos_vista H t defecto k bits c hf hq
  have hlt := enlace_traza_valores q f dt dts hfun hdt hh.2.2.1
  obtain ⟨a0, a1, a2, halfa⟩ := RetosVista.tres_alfas H k bits c
  have hlc := hh.2.2.2.2.1
  rw [halfa] at hlc
  have hcomp := enlace_composicion_valores k i c.enunciado a0 a1 a2 q f dc dcs hfun hdc hlc
  have hhalf : 2 ^ (k + 3) / 2 = 2 ^ (k + 2) := by
    rw [show k + 3 = k + 2 + 1 by omega, pow_succ, Nat.mul_div_cancel _ (by decide : 0 < 2)]
  have hb0 : v.base i = algebraMap Fp Fp2 (f 0).valor := by
    change valor t defecto (k + 3) c.prueba.raiz i = _
    simpa only [IndicesMaquina.posicionesNaturales, Matrix.cons_val_zero] using hb 0
  have hb3 : v.base (i + 2 ^ (k + 2)) = algebraMap Fp Fp2 (f 3).valor := by
    change valor t defecto (k + 3) c.prueba.raiz (i + 2 ^ (k + 2)) = _
    simpa [IndicesMaquina.posicionesNaturales, hhalf] using hb 3
  have hlen := forma_implica_cantidades k bits c hf
  have hlenT : v.traza.length = v.datos.k := by
    change (capas t defecto (k + 3) c.prueba.traza.raices).length = k
    rw [CapasIndexadas.longitud_capas, hlen.1]
  have hlenC : v.composicion.length = v.datos.k + 1 := by
    change (capas t defecto (k + 3) c.prueba.composicion.raices).length = k + 1
    rw [CapasIndexadas.longitud_capas, hlen.2.1]
  have hcontrolT : controlesFRI v.datos.k 0 v.traza
      ((v.retos.drop 3).take v.datos.k) ⟨i, none⟩ v.datos.vt := by
    change controlesFRI k 0 (capas t defecto (k + 3) c.prueba.traza.raices)
      ((v.retos.drop 3).take k) ⟨i, none⟩ c.prueba.traza.final
    rw [hseg.2.1]
    exact hct
  have hcontrolC : controlesFRI v.datos.k 0 v.composicion
      (v.retos.drop (3 + v.datos.k)) ⟨i, none⟩ v.datos.vc := by
    change controlesFRI k 0 (capas t defecto (k + 3) c.prueba.composicion.raices)
      (v.retos.drop (3 + k)) ⟨i, none⟩ c.prueba.composicion.final
    rw [hseg.2.2]
    exact hcc
  have hvk : v.datos.k = k := rfl
  have hvinicio : v.datos.inicio = c.enunciado.inicio := rfl
  have hvsalida : v.datos.salida = c.enunciado.salida := rfl
  constructor
  · change pruebaTraza v i
    unfold pruebaTraza
    refine ⟨hcan, ?_⟩
    rw [hvt]
    refine ⟨htl.trans (hlt.1.trans hb0.symm), htr.trans (hlt.2.trans hb3.symm), ?_, ?_⟩
    · simpa only [hvt] using hlenT
    · simpa only [hvt] using hcontrolT
  · change pruebaComposicion v i
    unfold pruebaComposicion
    refine ⟨hcan, ?_⟩
    rw [hvc, hseg.1, halfa]
    refine ⟨hcl.trans ?_, hcr.trans ?_, ?_, ?_⟩
    · simpa only [hvk, hvinicio, hvsalida, hre] using hcomp.1
    · simpa only [hvk, hvinicio, hvsalida, hre] using hcomp.2
    · simpa only [hvc] using hlenC
    · simpa only [hvc] using hcontrolC

end Nexus.Verificador.ConsultaBuena
