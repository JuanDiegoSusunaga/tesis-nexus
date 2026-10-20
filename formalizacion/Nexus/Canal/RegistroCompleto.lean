module

public import Nexus.Canal.RegistroRaices
public import Nexus.Canal.RegistroSelector
import Mathlib.Tactic

/-!
# Transcripción y soporte del canal TG2 completo

Las raíces, retos y continuación se obtienen de la ejecución. El registro
inicial siempre existe; solo trabajo y selector pueden impedir la continuación.
-/

public section
namespace Nexus.Canal.RegistroCompleto

set_option pp.deepTerms false
set_option pp.deepTerms.threshold 8

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open ProgramaCompartido RegistroPrograma RegistroRaices GramaticaTG2

structure Vista where
  base : Evento
  alfas : Digest × List Fp2
  inicioTraza : Digest
  traza : Digest × List Evento
  inicioComposicion : Digest
  composicion : Digest × List Evento

@[expose] def evaluar (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) : Vista :=
  let s0 := H (codificar .inicio)
  let s1 := H (codificar (.absorber s0 (.perfil (ProgramaTG2.perfil k bits))))
  let s2 := H (codificar (.absorber s1 (.enunciado (ProgramaTG2.enunciado inicio salida k))))
  let e : Evento := ⟨s2, 1, raiz⟩
  let a := evaluarRetos H 3 (H (absorcion e))
  let st := H (codificar (.absorber a.1 .faseTraza))
  let t := evaluarRaices H rt vt st
  let sc := H (codificar (.absorber t.1 .faseComposicion))
  let c := evaluarRaices H rc vc sc
  ⟨e, a, st, t, sc, c⟩

@[expose] def prefijo (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) : List Entrada :=
  let s0 := H (codificar .inicio)
  let s1 := H (codificar (.absorber s0 (.perfil (ProgramaTG2.perfil k bits))))
  let v := evaluar H k bits inicio salida raiz rt rc vt vc
  [codificar .inicio, codificar (.absorber s0 (.perfil (ProgramaTG2.perfil k bits))),
    codificar (.absorber s1 (.enunciado (ProgramaTG2.enunciado inicio salida k))), absorcion v.base] ++
    logRetos H 3 (H (absorcion v.base)) ++ [codificar (.absorber v.alfas.1 .faseTraza)] ++
    logRaices H rt vt v.inicioTraza ++ [codificar (.absorber v.traza.1 .faseComposicion)] ++
    logRaices H rc vc v.inicioComposicion

theorem resultado_canal (H : Entrada → Digest) (k bits R : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) (trabajo : Digest → Bool)
    (c : List Fp2 → List Fp2 → List Fp2 → List (Fin (4 * 2 ^ k)) → Programa) :
    resultado (tabla H) (DesafiosPrograma.ejecutar k bits R inicio salida raiz rt rc vt vc n trabajo c) =
      let v := evaluar H k bits inicio salida raiz rt rc vt vc
      if trabajo (H (codificar (.trabajo v.composicion.1 n))) then
        resultado (tabla H) (SelectorOrdenado.seleccionar (4 * 2 ^ k) (by positivity) R
          (H (codificar (.absorber v.composicion.1 (.nonce n)))) []
          (c v.alfas.2 (v.traza.2.map (beta H)) (v.composicion.2.map (beta H)))) else false := by
  simp only [DesafiosPrograma.ejecutar, resultado, tabla_codificacion]
  rw [retos_resultado]
  simp only [DesafiosPrograma.fase, resultado, tabla_codificacion]
  rw [raices_resultado]
  simp only [resultado, tabla_codificacion]
  rw [raices_resultado]
  simp only [evaluar, absorcion, codificar, entrada, etiqueta, datos,
    Bool.false_eq_true, ite_true, ite_false, apply_ite, resultado, tabla_codificacion]
  congr!

theorem registro_canal (H : Entrada → Digest) (k bits R : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) (trabajo : Digest → Bool)
    (c : List Fp2 → List Fp2 → List Fp2 → List (Fin (4 * 2 ^ k)) → Programa) :
    entradas H (DesafiosPrograma.ejecutar k bits R inicio salida raiz rt rc vt vc n trabajo c) =
      let v := evaluar H k bits inicio salida raiz rt rc vt vc
      prefijo H k bits inicio salida raiz rt rc vt vc ++
        codificar (.trabajo v.composicion.1 n) ::
          (if trabajo (H (codificar (.trabajo v.composicion.1 n))) then
            codificar (.absorber v.composicion.1 (.nonce n)) ::
              entradas H (SelectorOrdenado.seleccionar (4 * 2 ^ k) (by positivity) R
                (H (codificar (.absorber v.composicion.1 (.nonce n)))) []
                (c v.alfas.2 (v.traza.2.map (beta H)) (v.composicion.2.map (beta H)))) else []) := by
  simp only [DesafiosPrograma.ejecutar, entradas]
  rw [retos_registro]
  simp only [DesafiosPrograma.fase, entradas]
  rw [raices_registro]
  simp only [entradas]
  rw [raices_registro]
  simp only [entradas]
  simp only [prefijo, evaluar, absorcion, codificar, entrada, etiqueta, datos,
    Bool.false_eq_true, ite_true, ite_false, apply_ite, entradas,
    List.cons_append, List.nil_append, List.append_assoc]
  split_ifs <;> simp_all

theorem base_registrada (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) :
    Registrado H (prefijo H k bits inicio salida raiz rt rc vt vc)
      (evaluar H k bits inicio salida raiz rt rc vt vc).base := by
  have hf : reto H (evaluar H k bits inicio salida raiz rt rc vt vc).base ∈
      logRetos H 3 (H (absorcion (evaluar H k bits inicio salida raiz rt rc vt vc).base)) :=
    List.mem_cons_self
  constructor
  · simp only [prefijo, List.mem_append, List.mem_cons, List.not_mem_nil, or_false]
    tauto
  · simp only [prefijo, List.mem_append]
    tauto

theorem traza_registrada (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (e : Evento)
    (he : e ∈ (evaluar H k bits inicio salida raiz rt rc vt vc).traza.2) :
    Registrado H (prefijo H k bits inicio salida raiz rt rc vt vc) e := by
  have h := eventos_registrados H rt vt
    (evaluar H k bits inicio salida raiz rt rc vt vc).inicioTraza e he
  exact registrado_monotono H _ _ (by intro x hx; simp only [prefijo, List.mem_append]; tauto) e h

theorem composicion_registrada (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (e : Evento)
    (he : e ∈ (evaluar H k bits inicio salida raiz rt rc vt vc).composicion.2) :
    Registrado H (prefijo H k bits inicio salida raiz rt rc vt vc) e := by
  have h := eventos_registrados H rc vc
    (evaluar H k bits inicio salida raiz rt rc vt vc).inicioComposicion e he
  exact registrado_monotono H _ _ (by intro x hx; simp only [prefijo, List.mem_append]; tauto) e h

theorem raices_conservadas (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) :
    (evaluar H k bits inicio salida raiz rt rc vt vc).traza.2.map Evento.raiz = rt ∧
      (evaluar H k bits inicio salida raiz rt rc vt vc).composicion.2.map Evento.raiz = rc :=
  ⟨raices_proyeccion H rt vt _, raices_proyeccion H rc vc _⟩

theorem alfas_tres (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) :
    (evaluar H k bits inicio salida raiz rt rc vt vc).alfas.2.length = 3 := retos_longitud H 3 _

theorem aceptacion_con_soporte (H : Entrada → Digest) (k bits R : ℕ) (inicio salida : Fp) (raiz : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) (trabajo : Digest → Bool)
    (c : List Fp2 → List Fp2 → List Fp2 → List (Fin (4 * 2 ^ k)) → Programa)
    (ha : resultado (tabla H) (DesafiosPrograma.ejecutar k bits R inicio salida raiz rt rc vt vc n trabajo c) = true) :
    let v := evaluar H k bits inicio salida raiz rt rc vt vc
    ∃ S, S.Nodup ∧ S.length = 40 ∧
      resultado (tabla H) (c v.alfas.2 (v.traza.2.map (beta H)) (v.composicion.2.map (beta H)) S) = true ∧
      (∀ e ∈ entradas H (c v.alfas.2 (v.traza.2.map (beta H)) (v.composicion.2.map (beta H)) S),
        e ∈ entradas H (DesafiosPrograma.ejecutar k bits R inicio salida raiz rt rc vt vc n trabajo c)) := by
  rw [resultado_canal] at ha
  dsimp only at ha ⊢
  split_ifs at ha with hw
  · obtain ⟨S, hS, hlen, hres, hlog⟩ := RegistroSelector.aceptacion_con_registro H (4 * 2 ^ k)
      (by positivity) R _ [] (by simp) _ ha
    refine ⟨S, hS, hlen, hres, ?_⟩
    intro e he
    rw [registro_canal]
    simp only [hw, ite_true]
    exact List.mem_append_right _ (List.mem_cons_of_mem _ (List.mem_cons_of_mem _ (hlog.subset he)))

end Nexus.Canal.RegistroCompleto
