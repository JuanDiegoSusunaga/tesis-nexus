module

public import Nexus.Verificador.CotaRondas
public import Nexus.Verificador.CotaSinBad
public import Nexus.Verificador.RondasCausales
public import Nexus.Verificador.ExcepcionesHash
public import Nexus.Verificador.CotaFRICausal
public import Nexus.Canal.ContextoAIR
public import Nexus.Verificador.CotaPerfilesFinal
public import Nexus.Verificador.CotaInicios
public import Nexus.Verificador.TrabajoSelectorLocal
public import Nexus.Canal.PrefijoTrabajo
public import Nexus.Verificador.CotaTrabajoNumerica
public import Nexus.Verificador.LeyTransporteFRI
public import Nexus.Canal.CanalPrevio
public import Nexus.ROM.SoporteFinito
public import Nexus.ROM.CintasRetos
public import Nexus.ROM.CadenaCodigos
import Mathlib.Tactic

/-!
# Ensamblaje final del puente adaptativo

La ley causal conserva la memoria de las consultas repetidas. Para una lista
de raíces y un estado inicial fijados antes de sortear la tabla, se compara la
secuencia real de digests con la cinta independiente, pagando explícitamente
`errorRaices`. La versión con frescura universal se conserva como resultado
condicional; `no_frescaArbol_restringido_dos_raices` demuestra que esa premisa
es imposible desde dos raíces en el árbol concreto.

`cota_fase_fri_raices_con_repeticiones` combina la comparación cuantitativa
con la cota FRI y el sesgo de transporte a Goldilocks. Todavía requiere
`hpuente`: la estrategia excepcional debe estar fijada antes de su reto.
La cota de `¬ SinBad` se deriva del presupuesto real de llamadas en
`CotaSinBad`; el recorte evita identificar ese presupuesto con la altura del
árbol original. `RondasCausales` ya traslada las dos ramas FRI del candidato
real a la primera respuesta E: tanto la raíz como su vector se reconstruyen
desde la tabla anterior a esa respuesta. `ExcepcionesHash` da la ley local y
su cota por presupuesto para conjuntos elegidos con ese pasado, con sesgo
explícito. `CotaFRICausal.cota_512_con_air` ya aplica la unión a todos los
perfiles/rondas del adversario: su conjunto previo tiene cardinal como
máximo 130708 y usa el presupuesto Q+24895. `CancelacionAIRCausal` enlaza
toda cancelación real con el conjunto previo de cardinal a lo sumo uno.
`CotaAdaptativaFinal.cota_512` combina ambos en un conjunto de cardinal
130709, sin probabilidades AIR pendientes ni hipótesis semánticas externas.
`CotaPerfilesFinal.cota_512_todos_truncada` cubre el perfil de salida elegido
adaptativamente, cobrando SinBad y AIR/FRI una sola vez.

`CotaInicios.cota_512_todos` sustituye B por Q+1 al contar candidatos:
cada primer índice elegible se inyecta en una absorción de nonce distinta,
y el programa real añade a lo sumo una a las consultas adversarias.
El pasado del acoplamiento sigue cobrándose con B=Q+24895.
`TrabajoDigest` cuenta exactamente la masa del trabajo de 12 y 20 bits;
`TrabajoSelectorLocal` obtiene el producto con el riesgo del selector para
un corte con trabajo y nonce frescos y primer índice no preconsultado.
`PrefijoTrabajo` recupera el canal y la misma vista de vectores antes de
cualquiera de esas dos respuestas, sin leerlas para construir esa vista.
`ConteoPares` y `PrimerosPares` cobran Q+1 parejas estado/nonce distintas,
tanto si se consulta primero trabajo como si se consulta primero el nonce.
`CoberturaTrabajo` traslada toda aceptación segura a su primera pareja;
`TrabajoPrefijo` suma las cotas locales con sus pesos reales en el universo
original. `CotaTrabajoFinal.cota_512_todos` ya incorpora 2^(-bits), Q+1,
todos los perfiles y un solo cargo de Bad y AIR/FRI. Sus únicas premisas
externas son el parámetro admitido de trabajo y el presupuesto adversario Q.
Se conservan constantes conservadoras: unión AIR/FRI de cardinal 130709
y error explícito de acoplamiento con pasado B+2, B=Q+24895. No se afirma
identidad con la fórmula más ajustada propuesta originalmente.
`CotaTrabajoNumerica` certifica ejemplos completos e inclusiones para la
probabilidad real del modelo. No se deduce el refinamiento universal Rust
ni una garantía del hash determinista SHA3 fuera del ROM.
-/

public section
namespace Nexus.Verificador.PuenteAdaptativoFinal

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM Nexus.Canal Nexus.Goldilocks
open Nexus.FRI
open Nexus.Verificador.CotaRondas
open Nexus.Verificador.LeyTransporteFRI
open Nexus.Canal.VistaSemantica Nexus.Canal.VistaCampo
open Nexus.Verificador.RondasReales
open ProgramaBytes SelectorAdaptativo ExcesoRondas FiltroFalso

set_option maxRecDepth 100000
set_option maxHeartbeats 800000
set_option exponentiation.threshold 512

/-! La excepción cruda que corresponde a la estrategia FRI y al transporte
    concreto Digest → Fp2. -/
noncomputable def excepcionesDigest {m : ℕ} (t : Nexus.FRI.Torre Fp2 m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2)
    (i : ℕ) (h : List Nexus.Merkle.Digest) : Finset Nexus.Merkle.Digest :=
  Nexus.FRI.preimagenExcepcion transporteRetoReal
    (Nexus.FRI.excepcionesHistoria t θ hθ h2 hmargin estrategia
      i (h.map transporteRetoReal))

theorem excepcionesDigest_eq_cruda {m : ℕ} (t : Nexus.FRI.Torre Fp2 m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2) :
    excepcionesDigest t θ hθ h2 hmargin estrategia =
      Nexus.FRI.excepcionesHistoriaCruda t θ hθ h2 hmargin estrategia
        transporteRetoReal := by
  funext i h
  apply Finset.ext
  intro d
  simp only [excepcionesDigest, Nexus.FRI.excepcionesHistoriaCruda,
    Nexus.FRI.mem_preimagenExcepcion]

noncomputable def pasoDigest : ℕ → List Nexus.Merkle.Digest → Nexus.Merkle.Digest →
    List Nexus.Merkle.Digest :=
  fun _ h d => h ++ [d]

/-! Las respuestas indexadas de una vista se convierten en el producto
    recursivo `Retos` que usa el experimento FRI. -/
noncomputable def retosDeFin {K : Type} : (n : ℕ) → (Fin n → K) → Nexus.N06.Retos K n
  | 0, _ => PUnit.unit
  | n + 1, f => (f 0, retosDeFin n (fun i => f i.succ))

theorem reto_retosDeFin {K : Type} [Zero K] (n : ℕ) (f : Fin n → K) (j : Fin n) :
    Nexus.N06.reto (retosDeFin n f) j.val = f j := by
  induction n with
  | zero => exact Fin.elim0 j
  | succ n ih =>
    refine Fin.cases ?_ (fun i => ?_) j
    · rfl
    · change Nexus.N06.reto (retosDeFin n (fun x => f x.succ)) i.val = f i.succ
      rw [ih]

theorem retosDeFin_lista_getD (n : ℕ) (xs : Nexus.N06.Retos Digest n) :
    retosDeFin n (fun j =>
      (Nexus.ROM.CintasRetos.lista xs).getD j.val
        (Classical.choice (inferInstance : Nonempty Digest))) = xs := by
  induction n with
  | zero => cases xs; rfl
  | succ n ih =>
    cases xs with
    | mk x xs =>
      apply Prod.ext
      · rfl
      · change retosDeFin n (fun j =>
          (Nexus.ROM.CintasRetos.lista xs).getD j.val
            (Classical.choice (inferInstance : Nonempty Digest))) = xs
        exact ih xs

noncomputable def mapRetos {D K : Type} (φ : D → K) :
    (n : ℕ) → Nexus.N06.Retos D n → Nexus.N06.Retos K n
  | 0, _ => PUnit.unit
  | n + 1, xs => (φ xs.1, mapRetos φ n xs.2)

theorem reto_mapRetos {D K : Type} [Zero D] [Zero K] (φ : D → K) (n : ℕ)
    (xs : Nexus.N06.Retos D n) (j : Fin n) :
    Nexus.N06.reto (mapRetos φ n xs) j.val = φ (Nexus.N06.reto xs j.val) := by
  induction n with
  | zero => exact Fin.elim0 j
  | succ n ih =>
    refine Fin.cases ?_ (fun i => ?_) j
    · rfl
    · change Nexus.N06.reto (mapRetos φ n xs.2) i.val = φ (Nexus.N06.reto xs.2 i.val)
      exact ih xs.2 i

theorem mapRetos_retosDeFin {D K : Type} (φ : D → K) (n : ℕ) (f : Fin n → D) :
    mapRetos φ n (retosDeFin n f) = retosDeFin n (fun j => φ (f j)) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    apply Prod.ext
    · rfl
    · exact ih (fun j => f j.succ)

noncomputable def digestsRaices (G : Entrada → Digest) : List Digest → Digest → List Digest
  | [], _ => []
  | r :: rs, s =>
      let d := Nexus.Canal.RegistroRaices.respuesta G ⟨s, 2, r⟩
      d :: digestsRaices G rs d

def respuestasRaicesCausales (H : Entrada → Digest) :
    List Digest → Digest → List Digest
  | [], _ => []
  | r :: rs, s =>
      let e : Nexus.Canal.RegistroRaices.Evento := ⟨s, 2, r⟩
      let a := H (Nexus.Canal.RegistroRaices.absorcion e)
      let d := H (entradaReto a .extension)
      a :: d :: respuestasRaicesCausales H rs d

def extraerExtensiones : List Digest → List Digest
  | [] => []
  | _ :: d :: xs => d :: extraerExtensiones xs
  | [_] => []

def extraerRetos {A : Type} : {n : ℕ} → Nexus.N06.Retos A (2 * n) → Nexus.N06.Retos A n
  | 0, _ => PUnit.unit
  | _n + 1, xs => (xs.2.1, extraerRetos xs.2.2)

theorem lista_extraerRetos (n : ℕ)
    (xs : Nexus.N06.Retos Digest (2 * n)) :
    Nexus.ROM.CintasRetos.lista (extraerRetos xs) =
      extraerExtensiones (Nexus.ROM.CintasRetos.lista xs) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [extraerRetos, Nexus.ROM.CintasRetos.lista, extraerExtensiones]
    rw [ih]

theorem promedio_extraerRetos (n : ℕ)
    (f : Nexus.N06.Retos Digest n → ℚ) :
    Nexus.N06.promedio (fun xs : Nexus.N06.Retos Digest (2 * n) =>
      f (extraerRetos xs)) = Nexus.N06.promedio f := by
  induction n with
  | zero =>
    have hf : f = fun _ => f PUnit.unit := by
      funext xs
      cases xs
      rfl
    rw [hf]
  | succ n ih =>
    change Nexus.N06.promedio
        (fun xs : Digest × (Digest × Nexus.N06.Retos Digest (2 * n)) =>
          f (xs.2.1, extraerRetos xs.2.2)) = Nexus.N06.promedio f
    calc
      _ = Nexus.N06.promedio (fun _ : Digest =>
          Nexus.N06.promedio
            (fun xs : Digest × Nexus.N06.Retos Digest (2 * n) =>
              f (xs.1, extraerRetos xs.2))) := by
        exact Nexus.N06.promedio_producto _
      _ = Nexus.N06.promedio
          (fun xs : Digest × Nexus.N06.Retos Digest (2 * n) =>
            f (xs.1, extraerRetos xs.2)) := by
        simpa only using
          (Nexus.N06.promedio_constante
            (K := Digest)
            (Nexus.N06.promedio
              (fun xs : Digest × Nexus.N06.Retos Digest (2 * n) =>
                f (xs.1, extraerRetos xs.2))))
      _ = Nexus.N06.promedio (fun b : Digest =>
          Nexus.N06.promedio
            (fun xs : Nexus.N06.Retos Digest (2 * n) =>
              f (b, extraerRetos xs))) := by
        exact Nexus.N06.promedio_producto _
      _ = Nexus.N06.promedio (fun b : Digest =>
          Nexus.N06.promedio
            (fun xs : Nexus.N06.Retos Digest n => f (b, xs))) := by
        apply congrArg Nexus.N06.promedio
        funext b
        exact ih (fun xs => f (b, xs))
      _ = Nexus.N06.promedio f := (Nexus.N06.promedio_producto f).symm

theorem extraerExtensiones_respuestasRaicesCausales
    (H : Entrada → Digest) (rs : List Digest) (s : Digest) :
    extraerExtensiones (respuestasRaicesCausales H rs s) =
      digestsRaices H rs s := by
  induction rs generalizing s with
  | nil => rfl
  | cons r rs ih =>
    simp only [respuestasRaicesCausales, extraerExtensiones, digestsRaices,
      Nexus.Canal.RegistroRaices.respuesta, Nexus.Canal.RegistroRaices.reto]
    rw [ih]

def arbolRaicesCausales : List Digest → Digest →
    Nexus.ROM.LeyArbol.Arbol Entrada Digest (List Digest)
  | [], _ => .terminar []
  | r :: rs, s =>
      .consultar
        (Nexus.Canal.RegistroRaices.absorcion ⟨s, 2, r⟩) (fun a =>
        .consultar (entradaReto a .extension) (fun d =>
          Nexus.ROM.LeyArbol.transformar (fun xs => a :: d :: xs)
            (arbolRaicesCausales rs d)))

def codigosRaices : List Digest → List (Digest → Entrada)
  | [] => []
  | r :: rs => (fun s => RegistroRaices.absorcion ⟨s, 2, r⟩) ::
      (fun s => entradaReto s .extension) :: codigosRaices rs

theorem longitud_codigosRaices (rs : List Digest) :
    (codigosRaices rs).length = 2 * rs.length := by
  induction rs with
  | nil => rfl
  | cons r rs ih => simp only [codigosRaices, List.length_cons, ih]; omega

theorem codigosRaices_separados (rs : List Digest) :
    CadenaCodigos.EstadosSeparados (codigosRaices rs) := by
  have htipos : ∀ c ∈ codigosRaices rs,
      (∃ r : Digest, c = fun s => RegistroRaices.absorcion ⟨s, 2, r⟩) ∨
      c = fun s => entradaReto s .extension := by
    induction rs with
    | nil => simp [codigosRaices]
    | cons r rs ih =>
      intro c hc
      rcases List.mem_cons.mp hc with rfl | hc
      · exact Or.inl ⟨r, rfl⟩
      · rcases List.mem_cons.mp hc with rfl | hc
        · exact Or.inr rfl
        · exact ih c hc
  intro c hc e he a b hab
  rcases htipos c hc with ⟨r, rfl⟩ | rfl <;>
    rcases htipos e he with ⟨r', rfl⟩ | rfl
  · exact (absorcion_inyectiva hab).1
  · exact False.elim ((reto_no_absorcion b a .extension 2 r.val) hab.symm)
  · exact False.elim ((reto_no_absorcion a b .extension 2 r'.val) hab)
  · exact (reto_inyectivo hab).1

theorem arbol_codigosRaices (rs : List Digest) (s : Digest) :
    CadenaCodigos.arbol (codigosRaices rs) s = arbolRaicesCausales rs s := by
  induction rs generalizing s with
  | nil => rfl
  | cons r rs ih =>
    simp only [codigosRaices, CadenaCodigos.arbol, arbolRaicesCausales,
      Nexus.ROM.LeyArbol.transformar, CadenaCodigos.transformar_comp, ih]

noncomputable def errorRaices (n : ℕ) : ℚ :=
  min 1 ((((2 * n) * (2 * n + 1) : ℕ) : ℚ) / Fintype.card Digest)

theorem errorRaices_eq_digest256 (n : ℕ) :
    errorRaices n =
      min 1 ((((2 * n) * (2 * n + 1) : ℕ) : ℚ) / (2 : ℚ) ^ 256) := by
  simp only [errorRaices, digest_cardinal, Nat.cast_pow, Nat.cast_ofNat]

theorem errorRaices_hasta_30 (n : ℕ) (hn : n ≤ 30) :
    errorRaices n ≤ 3660 / (2 : ℚ) ^ 256 := by
  rw [errorRaices_eq_digest256]
  apply (min_le_right _ _).trans
  apply div_le_div_of_nonneg_right _ (by positivity)
  have hprod : (2 * n) * (2 * n + 1) ≤ 3660 := by nlinarith
  exact_mod_cast hprod

theorem repeticion_raices_acotada (rs : List Digest) (s : Digest) :
    AcoplamientoArbol.repeticion (arbolRaicesCausales rs s) ∅ ≤
      errorRaices rs.length := by
  rw [← arbol_codigosRaices]
  simpa only [errorRaices, longitud_codigosRaices] using
    (CadenaCodigos.repeticion_desde_vacio (codigosRaices rs) s
      (codigosRaices_separados rs))

theorem soporte_unir_raices_absorcion {R : Type}
    (rs : List Digest) (v : Fp2) (s r : Digest) (f : Digest → Programa R)
    (hr : r ∈ rs) :
    Nexus.Canal.RegistroRaices.absorcion ⟨s, 2, r⟩ ∈
      Nexus.ROM.SoporteFinito.soporte
        (ProgramaBytes.unir (Nexus.Canal.CanalPrevio.raices rs v s) f) := by
  induction rs generalizing s with
  | nil => simp at hr
  | cons r0 rs ih =>
    rcases List.mem_cons.mp hr with rfl | hr
    · simp only [Nexus.Canal.CanalPrevio.raices, ProgramaBytes.unir,
        Nexus.ROM.SoporteFinito.soporte]
      exact Finset.mem_insert_self _ _
    · simp only [Nexus.Canal.CanalPrevio.raices, ProgramaBytes.unir,
        Nexus.ROM.SoporteFinito.soporte]
      apply Finset.mem_insert_of_mem
      apply Finset.mem_biUnion.mpr
      refine ⟨s, Finset.mem_univ _, ?_⟩
      apply Finset.mem_insert_of_mem
      apply Finset.mem_biUnion.mpr
      exact ⟨s, Finset.mem_univ _, ih s hr⟩

theorem soporte_unir_raices_reto {R : Type}
    (rs : List Digest) (v : Fp2) (s a : Digest) (f : Digest → Programa R)
    (hrs : rs ≠ []) :
    entradaReto a .extension ∈
      Nexus.ROM.SoporteFinito.soporte
        (ProgramaBytes.unir (Nexus.Canal.CanalPrevio.raices rs v s) f) := by
  cases rs with
  | nil => contradiction
  | cons r rs =>
    simp only [Nexus.Canal.CanalPrevio.raices, ProgramaBytes.unir,
      Nexus.ROM.SoporteFinito.soporte]
    apply Finset.mem_insert_of_mem
    apply Finset.mem_biUnion.mpr
    refine ⟨a, Finset.mem_univ _, ?_⟩
    exact Finset.mem_insert_self _ _

theorem soporte_unir_retos_succ {R : Type} (n : ℕ) (s d : Digest)
    (f : Digest → Programa R) :
    Nexus.ROM.SoporteFinito.soporte (f d) ⊆
      Nexus.ROM.SoporteFinito.soporte
        (ProgramaBytes.unir (Nexus.Canal.CanalPrevio.retos (n + 1) s) f) := by
  induction n generalizing s with
  | zero =>
    simp only [Nexus.Canal.CanalPrevio.retos, ProgramaBytes.unir,
      Nexus.ROM.SoporteFinito.soporte]
    exact Nexus.ROM.SoporteFinito.rama_en_soporte _ _ _
  | succ n ih =>
    simp only [Nexus.Canal.CanalPrevio.retos, ProgramaBytes.unir,
      Nexus.ROM.SoporteFinito.soporte]
    intro e he
    apply Finset.mem_insert_of_mem
    apply Finset.mem_biUnion.mpr
    refine ⟨s, Finset.mem_univ _, ?_⟩
    exact ih s he

theorem soporte_programa_raiz
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal)
    (s0 s1 s2 s3 s4 st r : Digest) (hr : r ∈ d.rt) :
    Nexus.Canal.RegistroRaices.absorcion ⟨st, 2, r⟩ ∈
      Nexus.ROM.SoporteFinito.soporte (Nexus.Canal.CanalPrevio.programa d) := by
  simp only [Nexus.Canal.CanalPrevio.programa]
  apply Nexus.ROM.SoporteFinito.rama_en_soporte _ _ s0
  apply Nexus.ROM.SoporteFinito.rama_en_soporte _ _ s1
  apply Nexus.ROM.SoporteFinito.rama_en_soporte _ _ s2
  apply Nexus.ROM.SoporteFinito.rama_en_soporte _ _ s3
  apply soporte_unir_retos_succ 2 s3 s4
  apply Nexus.ROM.SoporteFinito.rama_en_soporte _ _ st
  exact soporte_unir_raices_absorcion d.rt d.vt st r _ hr

theorem soporte_programa_reto
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal)
    (s0 s1 s2 a : Digest) :
    entradaReto a .extension ∈
      Nexus.ROM.SoporteFinito.soporte (Nexus.Canal.CanalPrevio.programa d) := by
  simp only [Nexus.Canal.CanalPrevio.programa]
  apply Nexus.ROM.SoporteFinito.rama_en_soporte _ _ s0
  apply Nexus.ROM.SoporteFinito.rama_en_soporte _ _ s1
  apply Nexus.ROM.SoporteFinito.rama_en_soporte _ _ s2
  apply Nexus.ROM.SoporteFinito.rama_en_soporte _ _ a
  simp only [Nexus.Canal.CanalPrevio.retos, ProgramaBytes.unir,
    Nexus.ROM.SoporteFinito.soporte]
  exact Finset.mem_insert_self _ _

def digestSoporte : Digest := ⟨List.replicate 32 0, by simp⟩

theorem absorcion_raiz_en_universo
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal)
    (s r : Digest) (hr : r ∈ d.rt) :
    Nexus.Canal.RegistroRaices.absorcion ⟨s, 2, r⟩ ∈
      SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d) := by
  apply SelectorAcoplado.pasado_en_universo
  exact soporte_programa_raiz d digestSoporte digestSoporte digestSoporte
    digestSoporte digestSoporte s r hr

theorem reto_en_universo
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal) (a : Digest) :
    entradaReto a .extension ∈
      SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d) := by
  apply SelectorAcoplado.pasado_en_universo
  exact soporte_programa_reto d digestSoporte digestSoporte digestSoporte a

theorem evaluar_arbolRaicesCausales (H : Entrada → Digest) (rs : List Digest)
    (s : Digest) :
    Nexus.ROM.LeyArbol.evaluar H (arbolRaicesCausales rs s) =
      respuestasRaicesCausales H rs s := by
  induction rs generalizing s with
  | nil => rfl
  | cons r rs ih =>
    simp only [arbolRaicesCausales, Nexus.ROM.LeyArbol.evaluar,
      Nexus.ROM.LeyArbol.evaluar_transformar, respuestasRaicesCausales]
    simpa using ih _

def respuestasRaicesFinales (H : Entrada → Digest) :
    List Digest → Digest → List Digest
  | [], _ => []
  | r :: rs, s =>
      let e : Nexus.Canal.RegistroRaices.Evento := ⟨s, 2, r⟩
      let d := H (Nexus.Canal.RegistroRaices.reto H e)
      d :: respuestasRaicesFinales H rs d

theorem finales_causales_eq_digestsRaices (H : Entrada → Digest)
    (rs : List Digest) (s : Digest) :
    respuestasRaicesFinales H rs s = digestsRaices H rs s := by
  induction rs generalizing s with
  | nil => rfl
  | cons r rs ih =>
    simp only [respuestasRaicesFinales, digestsRaices]
    exact congrArg (List.cons (H (Nexus.Canal.RegistroRaices.reto H ⟨s, 2, r⟩)))
      (ih (H (Nexus.Canal.RegistroRaices.reto H ⟨s, 2, r⟩)))

def consultasEn {R : Type} (V : Finset Entrada) :
    Nexus.ROM.LeyArbol.Arbol Entrada Digest R → Prop
  | .terminar _ => True
  | .consultar q k => q ∈ V ∧ ∀ d : Digest, consultasEn V (k d)

theorem consultasEn_transformar {R T : Type} (V : Finset Entrada)
    (g : R → T) (p : Nexus.ROM.LeyArbol.Arbol Entrada Digest R) :
    consultasEn V (Nexus.ROM.LeyArbol.transformar g p) ↔ consultasEn V p := by
  induction p with
  | terminar => rfl
  | consultar q k ih =>
    simp only [Nexus.ROM.LeyArbol.transformar, consultasEn]
    constructor
    · rintro ⟨hq, hk⟩
      exact ⟨hq, fun d => (ih d).mp (hk d)⟩
    · rintro ⟨hq, hk⟩
      exact ⟨hq, fun d => (ih d).mpr (hk d)⟩

theorem consultasEn_arbolRaicesCausales_of_cierre (V : Finset Entrada)
    (rs : List Digest) (s : Digest)
    (habs : ∀ s r : Digest,
      Nexus.Canal.RegistroRaices.absorcion ⟨s, 2, r⟩ ∈ V)
    (hreto : ∀ a : Digest, entradaReto a .extension ∈ V) :
    consultasEn V (arbolRaicesCausales rs s) := by
  induction rs generalizing s with
  | nil => simp only [arbolRaicesCausales, consultasEn]
  | cons r rs ih =>
    simp only [arbolRaicesCausales, consultasEn]
    refine ⟨habs s r, ?_⟩
    intro a
    refine ⟨hreto a, ?_⟩
    intro d
    simpa only [consultasEn_transformar] using ih (s := d)

theorem consultasEn_arbolRaicesCausales_of_lista (V : Finset Entrada)
    (rs : List Digest) (s : Digest)
    (habs : ∀ s r : Digest, r ∈ rs →
      Nexus.Canal.RegistroRaices.absorcion ⟨s, 2, r⟩ ∈ V)
    (hreto : ∀ a : Digest, rs ≠ [] → entradaReto a .extension ∈ V) :
    consultasEn V (arbolRaicesCausales rs s) := by
  induction rs generalizing s with
  | nil => simp only [arbolRaicesCausales, consultasEn]
  | cons r rs ih =>
    simp only [arbolRaicesCausales, consultasEn]
    refine ⟨habs s r (by simp), ?_⟩
    intro a
    refine ⟨hreto a (by simp), ?_⟩
    intro d
    exact (consultasEn_transformar V (fun xs => a :: d :: xs)
      (arbolRaicesCausales rs d)).mpr (ih (s := d)
        (by
          intro s r hr
          exact habs s r (by simp [hr]))
        (by
          intro a hrs
          exact hreto a (by simp)))

def restringirArbol {R : Type} (V : Finset Entrada) :
    (p : Nexus.ROM.LeyArbol.Arbol Entrada Digest R) → consultasEn V p →
      Nexus.ROM.LeyArbol.Arbol V Digest R
  | .terminar r, _ => .terminar r
  | .consultar q k, h =>
      .consultar ⟨q, h.1⟩ (fun d => restringirArbol V (k d) (h.2 d))

theorem restringirArbol_transformar {R T : Type} (V : Finset Entrada)
    (g : R → T) (p : Nexus.ROM.LeyArbol.Arbol Entrada Digest R)
    (hp : consultasEn V (Nexus.ROM.LeyArbol.transformar g p)) :
    restringirArbol V (Nexus.ROM.LeyArbol.transformar g p) hp =
      Nexus.ROM.LeyArbol.transformar g
        (restringirArbol V p
          ((consultasEn_transformar V g p).mp hp)) := by
  induction p with
  | terminar => rfl
  | consultar q k ih =>
    simp only [Nexus.ROM.LeyArbol.transformar, restringirArbol]
    congr 1
    funext d
    exact ih d _

theorem evaluar_restringirArbol {R : Type} (V : Finset Entrada)
    (p : Nexus.ROM.LeyArbol.Arbol Entrada Digest R) (hp : consultasEn V p)
    (G : Entrada → Digest) (H : V → Digest)
    (hH : ∀ q hq, H ⟨q, hq⟩ = G q) :
    Nexus.ROM.LeyArbol.evaluar H (restringirArbol V p hp) =
      Nexus.ROM.LeyArbol.evaluar G p := by
  induction p with
  | terminar r => rfl
  | consultar q k ih =>
    simp only [restringirArbol, Nexus.ROM.LeyArbol.evaluar]
    have heq := hH q hp.1
    rw [heq]
    simpa only [heq] using ih (H ⟨q, hp.1⟩) (hp := hp.2 _)

theorem repeticion_restringirArbol {R : Type} (V : Finset Entrada)
    (p : Nexus.ROM.LeyArbol.Arbol Entrada Digest R) (hp : consultasEn V p)
    (S : Finset Entrada) :
    AcoplamientoArbol.repeticion (restringirArbol V p hp) (SoporteFinito.vistas V S) =
      AcoplamientoArbol.repeticion p S := by
  induction p generalizing S with
  | terminar => rfl
  | consultar q k ih =>
    have hmem : (⟨q, hp.1⟩ : V) ∈ SoporteFinito.vistas V S ↔ q ∈ S := by
      simp only [SoporteFinito.vistas, Finset.mem_filter, Finset.mem_univ, true_and]
    simp only [restringirArbol, AcoplamientoArbol.repeticion]
    by_cases hq : q ∈ S
    · rw [ite_eq_left (hmem.mpr hq), ite_eq_left hq]
    · rw [ite_eq_right (fun h => hq (hmem.mp h)), ite_eq_right hq]
      apply congrArg Nexus.N06.promedio
      funext a
      rw [← SoporteFinito.vistas_insertar V S q hp.1]
      exact ih a (hp.2 a) (insert q S)

theorem evaluar_restringirRaicesCausales (V : Finset Entrada)
    (rs : List Digest) (s : Digest)
    (hp : consultasEn V (arbolRaicesCausales rs s))
    (G : Entrada → Digest) (H : V → Digest)
    (hH : ∀ q hq, H ⟨q, hq⟩ = G q) :
    Nexus.ROM.LeyArbol.evaluar H
        (restringirArbol V (arbolRaicesCausales rs s) hp) =
      respuestasRaicesCausales G rs s := by
  rw [evaluar_restringirArbol V (arbolRaicesCausales rs s) hp G H hH]
  exact evaluar_arbolRaicesCausales G rs s

def frescaArbol {Q A R : Type} [DecidableEq Q] :
    Nexus.ROM.LeyArbol.Arbol Q A R → Finset Q → Prop
  | .terminar _, _ => True
  | .consultar q k, S => q ∉ S ∧ ∀ a, frescaArbol (k a) (insert q S)

theorem frescaArbol_transformar {Q A R T : Type} [DecidableEq Q]
    (g : R → T) (p : Nexus.ROM.LeyArbol.Arbol Q A R) (S : Finset Q) :
    frescaArbol (Nexus.ROM.LeyArbol.transformar g p) S ↔ frescaArbol p S := by
  induction p generalizing S with
  | terminar => rfl
  | consultar q k ih => simp only [Nexus.ROM.LeyArbol.transformar, frescaArbol, ih]

theorem frescaArbol_restringirArbol {R : Type} (V : Finset Entrada)
    (p : Nexus.ROM.LeyArbol.Arbol Entrada Digest R) (hp : consultasEn V p)
    (S : Finset Entrada) :
    frescaArbol (restringirArbol V p hp) (SoporteFinito.vistas V S) ↔ frescaArbol p S := by
  induction p generalizing S with
  | terminar => rfl
  | consultar q k ih =>
    have hmem : (⟨q, hp.1⟩ : V) ∈ SoporteFinito.vistas V S ↔ q ∈ S := by
      simp only [SoporteFinito.vistas, Finset.mem_filter, Finset.mem_univ, true_and]
    simp only [restringirArbol, frescaArbol]
    rw [hmem]
    apply and_congr_right
    intro _
    apply forall_congr'
    intro a
    rw [← SoporteFinito.vistas_insertar V S q hp.1]
    exact ih a (hp.2 a) (insert q S)

theorem no_frescaArbol_dos_raices (r₁ r₂ : Digest) (rs : List Digest)
    (s a d : Digest) (S : Finset Entrada) :
    ¬ frescaArbol (arbolRaicesCausales (r₁ :: r₂ :: rs) s) S := by
  intro hf
  have ht := (hf.2 a).2 d
  have hr := (frescaArbol_transformar (fun xs => a :: d :: xs)
    (arbolRaicesCausales (r₂ :: rs) d) _).mp ht
  have hne := (hr.2 a).1
  exact hne (by simp)

theorem no_frescaArbol_restringido_dos_raices (V : Finset Entrada)
    (r₁ r₂ : Digest) (rs : List Digest) (s a d : Digest)
    (hp : consultasEn V (arbolRaicesCausales (r₁ :: r₂ :: rs) s)) :
    ¬ frescaArbol
      (restringirArbol V (arbolRaicesCausales (r₁ :: r₂ :: rs) s) hp) ∅ := by
  intro hf
  have hr := (frescaArbol_restringirArbol V
    (arbolRaicesCausales (r₁ :: r₂ :: rs) s) hp ∅).mp
    (by simpa [SoporteFinito.vistas] using hf)
  exact no_frescaArbol_dos_raices r₁ r₂ rs s a d ∅ hr

noncomputable def mediaArbol {Q A R : Type} [Fintype A]
    (f : R → ℚ) : Nexus.ROM.LeyArbol.Arbol Q A R → ℚ
  | .terminar r => f r
  | .consultar _ k => Nexus.N06.promedio (fun a => mediaArbol f (k a))

theorem mediaArbol_eq_media {Q A R : Type} [Fintype A] [Nonempty A] [DecidableEq Q]
    (f : R → ℚ) (p : Nexus.ROM.LeyArbol.Arbol Q A R) :
    mediaArbol f p = AcoplamientoArbol.media f p := by
  induction p with
  | terminar => rfl
  | consultar q k ih =>
    simp only [mediaArbol, AcoplamientoArbol.media]
    apply congrArg Nexus.N06.promedio
    funext a
    exact ih a

theorem mediaArbol_transformar {Q A R T : Type} [Fintype A]
    (f : T → ℚ) (g : R → T) (p : Nexus.ROM.LeyArbol.Arbol Q A R) :
    mediaArbol f (Nexus.ROM.LeyArbol.transformar g p) =
      mediaArbol (fun r => f (g r)) p := by
  induction p with
  | terminar => rfl
  | consultar q k ih =>
    simp only [Nexus.ROM.LeyArbol.transformar, mediaArbol]
    congr 1
    funext a
    exact ih a

theorem media_arbolRaicesCausales (V : Finset Entrada)
    (rs : List Digest) (s : Digest) (hp : consultasEn V (arbolRaicesCausales rs s))
    (f : List Digest → ℚ) :
    mediaArbol f (restringirArbol V (arbolRaicesCausales rs s) hp) =
      Nexus.N06.promedio (fun xs : Nexus.N06.Retos Digest (2 * rs.length) =>
        f (Nexus.ROM.CintasRetos.lista xs)) := by
  induction rs generalizing s f with
  | nil =>
    simp only [arbolRaicesCausales, restringirArbol, mediaArbol, List.length_nil,
      Nat.mul_zero, Nexus.N06.promedio_constante, Nexus.ROM.CintasRetos.lista]
  | cons r rs ih =>
    simp only [arbolRaicesCausales, restringirArbol, mediaArbol]
    simp_rw [restringirArbol_transformar]
    simp_rw [mediaArbol_transformar]
    simp_rw [ih]
    have hprod :
        Nexus.N06.promedio
            (fun xs : Digest × (Digest × Nexus.N06.Retos Digest (2 * rs.length)) =>
              f (xs.1 :: xs.2.1 :: Nexus.ROM.CintasRetos.lista xs.2.2)) =
          Nexus.N06.promedio (fun a : Digest =>
            Nexus.N06.promedio (fun d : Digest =>
              Nexus.N06.promedio (fun xs : Nexus.N06.Retos Digest (2 * rs.length) =>
                f (a :: d :: Nexus.ROM.CintasRetos.lista xs)))) := by
      rw [Nexus.N06.promedio_producto]
      congr 1
      funext a
      rw [Nexus.N06.promedio_producto]
    change
      Nexus.N06.promedio (fun a : Digest =>
        Nexus.N06.promedio (fun d : Digest =>
          Nexus.N06.promedio (fun xs : Nexus.N06.Retos Digest (2 * rs.length) =>
            f (a :: d :: Nexus.ROM.CintasRetos.lista xs)))) =
        Nexus.N06.promedio
          (fun xs : Digest × (Digest × Nexus.N06.Retos Digest (2 * rs.length)) =>
            f (xs.1 :: xs.2.1 :: Nexus.ROM.CintasRetos.lista xs.2.2))
    exact hprod.symm

theorem valor_frescaArbol {Q A R : Type} [DecidableEq Q] [Fintype Q]
    [Fintype A] (f : R → ℚ) (p : Nexus.ROM.LeyArbol.Arbol Q A R)
    (S : Finset Q) (v : Q → A) (hf : frescaArbol p S) :
    Nexus.ROM.LeyArbol.valor f p S v = mediaArbol f p := by
  induction p generalizing S v with
  | terminar r => rfl
  | consultar q k ih =>
    rw [Nexus.ROM.LeyArbol.valor]
    rw [ite_eq_right hf.1]
    congr 1
    funext a
    exact ih (S := insert q S) (v := Function.update v q a) (hf := hf.2 a)

theorem ley_frescaArbol {Q A R : Type} [DecidableEq Q] [Fintype Q]
    [Fintype A] [Nonempty A] (f : R → ℚ)
    (p : Nexus.ROM.LeyArbol.Arbol Q A R)
    (hf : frescaArbol p ∅) :
    Nexus.N06.promedio (fun H : Q → A =>
      f (Nexus.ROM.LeyArbol.evaluar H p)) = mediaArbol f p := by
  rw [Nexus.ROM.LeyArbol.ley_desde_vacio]
  exact valor_frescaArbol f p ∅
    (fun _ => Classical.choice (inferInstance : Nonempty A)) hf

theorem ley_frescaRaicesCausales (V : Finset Entrada)
    (rs : List Digest) (s : Digest) (hp : consultasEn V (arbolRaicesCausales rs s))
    (hf : frescaArbol (restringirArbol V (arbolRaicesCausales rs s) hp) ∅)
    (defecto : Digest) (f : List Digest → ℚ) :
    Nexus.N06.promedio (fun H : V → Digest =>
      f (respuestasRaicesCausales (SoporteFinito.prolongar V defecto H) rs s)) =
      mediaArbol f (restringirArbol V (arbolRaicesCausales rs s) hp) := by
  calc
    Nexus.N06.promedio (fun H : V → Digest =>
        f (respuestasRaicesCausales (SoporteFinito.prolongar V defecto H) rs s)) =
        Nexus.N06.promedio (fun H : V → Digest =>
          f (Nexus.ROM.LeyArbol.evaluar H
            (restringirArbol V (arbolRaicesCausales rs s) hp))) := by
      congr 1
      funext H
      congr 1
      symm
      apply evaluar_restringirRaicesCausales V rs s hp
        (SoporteFinito.prolongar V defecto H) H
      intro q hq
      exact (SoporteFinito.prolongar_en_universo V defecto H q hq).symm
    _ = mediaArbol f (restringirArbol V (arbolRaicesCausales rs s) hp) :=
      ley_frescaArbol f (restringirArbol V (arbolRaicesCausales rs s) hp) hf

theorem ley_uniformeRaicesCausales (V : Finset Entrada)
    (rs : List Digest) (s : Digest) (hp : consultasEn V (arbolRaicesCausales rs s))
    (hf : frescaArbol (restringirArbol V (arbolRaicesCausales rs s) hp) ∅)
    (defecto : Digest) (f : List Digest → ℚ) :
    Nexus.N06.promedio (fun H : V → Digest =>
      f (respuestasRaicesCausales (SoporteFinito.prolongar V defecto H) rs s)) =
      Nexus.N06.promedio (fun xs : Nexus.N06.Retos Digest (2 * rs.length) =>
        f (Nexus.ROM.CintasRetos.lista xs)) := by
  calc
    Nexus.N06.promedio (fun H : V → Digest =>
        f (respuestasRaicesCausales (SoporteFinito.prolongar V defecto H) rs s)) =
        mediaArbol f (restringirArbol V (arbolRaicesCausales rs s) hp) :=
      ley_frescaRaicesCausales V rs s hp hf defecto f
    _ = Nexus.N06.promedio (fun xs : Nexus.N06.Retos Digest (2 * rs.length) =>
        f (Nexus.ROM.CintasRetos.lista xs)) :=
      media_arbolRaicesCausales V rs s hp f

theorem ley_uniformeRaicesCausales_finales (V : Finset Entrada)
    (rs : List Digest) (s : Digest)
    (hp : consultasEn V (arbolRaicesCausales rs s))
    (hf : frescaArbol
      (restringirArbol V (arbolRaicesCausales rs s) hp) ∅)
    (defecto : Digest) (f : List Digest → ℚ) :
    Nexus.N06.promedio (fun H : V → Digest =>
      f (digestsRaices (SoporteFinito.prolongar V defecto H) rs s)) =
      Nexus.N06.promedio (fun xs : Nexus.N06.Retos Digest (2 * rs.length) =>
        f (extraerExtensiones (Nexus.ROM.CintasRetos.lista xs))) := by
  simpa only [extraerExtensiones_respuestasRaicesCausales] using
    (ley_uniformeRaicesCausales V rs s hp hf defecto
      (fun xs => f (extraerExtensiones xs)))

theorem ley_uniformeRaicesFinales (V : Finset Entrada)
    (rs : List Digest) (s : Digest)
    (hp : consultasEn V (arbolRaicesCausales rs s))
    (hf : frescaArbol
      (restringirArbol V (arbolRaicesCausales rs s) hp) ∅)
    (defecto : Digest) (f : Nexus.N06.Retos Digest rs.length → ℚ) :
    Nexus.N06.promedio (fun H : V → Digest =>
      f (retosDeFin rs.length
        (fun j => (digestsRaices (SoporteFinito.prolongar V defecto H) rs s).getD j.val
          (Classical.choice (inferInstance : Nonempty Digest))))) =
      Nexus.N06.promedio f := by
  calc
    _ = Nexus.N06.promedio (fun xs : Nexus.N06.Retos Digest (2 * rs.length) =>
        f (retosDeFin rs.length
          (fun j => (extraerExtensiones (Nexus.ROM.CintasRetos.lista xs)).getD j.val
            (Classical.choice (inferInstance : Nonempty Digest))))) := by
      exact ley_uniformeRaicesCausales_finales V rs s hp hf defecto
        (fun ys => f (retosDeFin rs.length
          (fun j => ys.getD j.val
            (Classical.choice (inferInstance : Nonempty Digest)))))
    _ = Nexus.N06.promedio (fun xs : Nexus.N06.Retos Digest (2 * rs.length) =>
        f (extraerRetos xs)) := by
      apply congrArg Nexus.N06.promedio
      funext xs
      rw [← lista_extraerRetos rs.length xs]
      exact congrArg f (retosDeFin_lista_getD rs.length (extraerRetos xs))
    _ = Nexus.N06.promedio f := promedio_extraerRetos rs.length f

theorem ley_uniformeRaicesFinales_programa
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal)
    (s : Digest) (defecto : Digest)
    (f : Nexus.N06.Retos Digest d.rt.length → ℚ)
    (hf : frescaArbol
      (restringirArbol
        (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
        (arbolRaicesCausales d.rt s)
        (consultasEn_arbolRaicesCausales_of_lista
          (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
          d.rt s
          (fun s r hr => absorcion_raiz_en_universo d s r hr)
          (fun a _ => reto_en_universo d a))) ∅) :
    Nexus.N06.promedio
        (fun H : SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d) → Digest =>
          f (retosDeFin d.rt.length (fun j =>
            (digestsRaices
              (SelectorAdaptativo.oraculo (Nexus.Canal.CanalPrevio.programa d) defecto H)
              d.rt s).getD j.val
              (Classical.choice (inferInstance : Nonempty Digest))))) =
      Nexus.N06.promedio f := by
  simpa only [SelectorAdaptativo.oraculo] using
    (ley_uniformeRaicesFinales
      (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
      d.rt s
      (consultasEn_arbolRaicesCausales_of_lista
        (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
        d.rt s
        (fun s r hr => absorcion_raiz_en_universo d s r hr)
        (fun a _ => reto_en_universo d a))
      hf defecto f)

noncomputable def arbolRaicesPrograma
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal) (s : Digest) :
    Nexus.ROM.LeyArbol.Arbol
      (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
      Digest (List Digest) :=
  restringirArbol
    (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
    (arbolRaicesCausales d.rt s)
    (consultasEn_arbolRaicesCausales_of_lista
      (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
      d.rt s
      (fun s r hr => absorcion_raiz_en_universo d s r hr)
      (fun a _ => reto_en_universo d a))

noncomputable def secuenciaRaices
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal)
    (defecto s : Digest) :
    (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d) → Digest) →
      Nexus.N06.Retos Digest d.rt.length :=
  fun H => retosDeFin d.rt.length (fun j =>
    (digestsRaices
      (SelectorAdaptativo.oraculo (Nexus.Canal.CanalPrevio.programa d) defecto H)
      d.rt s).getD j.val
      (Classical.choice (inferInstance : Nonempty Digest)))

theorem ley_uniforme_secuenciaRaices
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal)
    (s defecto : Digest) (f : Nexus.N06.Retos Digest d.rt.length → ℚ)
    (hf : frescaArbol (arbolRaicesPrograma d s) ∅) :
    Nexus.N06.promedio (fun H => f (secuenciaRaices d defecto s H)) =
      Nexus.N06.promedio f := by
  simpa only [arbolRaicesPrograma, secuenciaRaices] using
    (ley_uniformeRaicesFinales_programa d s defecto f hf)

theorem ley_causalRaicesCausales (V : Finset Entrada)
    (rs : List Digest) (s : Digest) (hp : consultasEn V (arbolRaicesCausales rs s))
    (defecto : Digest) (f : List Digest → ℚ) :
    Nexus.N06.promedio (fun H : V → Digest =>
      f (respuestasRaicesCausales (SoporteFinito.prolongar V defecto H) rs s)) =
      Nexus.ROM.LeyArbol.valor f
        (restringirArbol V (arbolRaicesCausales rs s) hp) ∅
        (fun _ => digestSoporte) := by
  calc
    Nexus.N06.promedio (fun H : V → Digest =>
        f (respuestasRaicesCausales (SoporteFinito.prolongar V defecto H) rs s)) =
        Nexus.N06.promedio (fun H : V → Digest =>
          f (Nexus.ROM.LeyArbol.evaluar H
            (restringirArbol V (arbolRaicesCausales rs s) hp))) := by
      congr 1
      funext H
      congr 1
      symm
      apply evaluar_restringirRaicesCausales V rs s hp
        (SoporteFinito.prolongar V defecto H) H
      intro q hq
      exact (SoporteFinito.prolongar_en_universo V defecto H q hq).symm
    _ = Nexus.ROM.LeyArbol.valor f
        (restringirArbol V (arbolRaicesCausales rs s) hp) ∅
        (fun _ => digestSoporte) :=
      Nexus.ROM.LeyArbol.ley_desde_vacio
        (restringirArbol V (arbolRaicesCausales rs s) hp)
        (fun _ => digestSoporte) f

theorem cota_leyRaicesCausales (V : Finset Entrada)
    (rs : List Digest) (s : Digest) (hp : consultasEn V (arbolRaicesCausales rs s))
    (defecto : Digest) (f : List Digest → ℚ)
    (h0 : ∀ ys, 0 ≤ f ys) (h1 : ∀ ys, f ys ≤ 1) :
    Nexus.N06.promedio (fun H : V → Digest =>
      f (respuestasRaicesCausales (SoporteFinito.prolongar V defecto H) rs s)) ≤
      Nexus.N06.promedio (fun xs : Retos Digest (2 * rs.length) =>
        f (Nexus.ROM.CintasRetos.lista xs)) + errorRaices rs.length := by
  rw [ley_causalRaicesCausales V rs s hp defecto f]
  have hb := AcoplamientoArbol.valor_le_media_mas_repeticion f
    (restringirArbol V (arbolRaicesCausales rs s) hp) ∅ (fun _ => digestSoporte) h0 h1
  rw [← mediaArbol_eq_media,
    media_arbolRaicesCausales V rs s hp f] at hb
  have hr : AcoplamientoArbol.repeticion
      (restringirArbol V (arbolRaicesCausales rs s) hp) ∅ =
      AcoplamientoArbol.repeticion (arbolRaicesCausales rs s) ∅ := by
    simpa [SoporteFinito.vistas]
      using repeticion_restringirArbol V (arbolRaicesCausales rs s) hp ∅
  rw [hr] at hb
  exact hb.trans (add_le_add (le_refl _) (repeticion_raices_acotada rs s))

theorem cota_leyRaicesFinales (V : Finset Entrada)
    (rs : List Digest) (s : Digest) (hp : consultasEn V (arbolRaicesCausales rs s))
    (defecto : Digest) (f : Retos Digest rs.length → ℚ)
    (h0 : ∀ xs, 0 ≤ f xs) (h1 : ∀ xs, f xs ≤ 1) :
    Nexus.N06.promedio (fun H : V → Digest =>
      f (retosDeFin rs.length (fun j =>
        (digestsRaices (SoporteFinito.prolongar V defecto H) rs s).getD j.val
          (Classical.choice (inferInstance : Nonempty Digest))))) ≤
      Nexus.N06.promedio f + errorRaices rs.length := by
  have h := cota_leyRaicesCausales V rs s hp defecto
    (fun ys => f (retosDeFin rs.length (fun j =>
      (extraerExtensiones ys).getD j.val
        (Classical.choice (inferInstance : Nonempty Digest)))))
    (fun _ => h0 _) (fun _ => h1 _)
  simp only [extraerExtensiones_respuestasRaicesCausales] at h
  have hm : Nexus.N06.promedio (fun xs : Retos Digest (2 * rs.length) =>
      f (retosDeFin rs.length (fun j =>
        (extraerExtensiones (Nexus.ROM.CintasRetos.lista xs)).getD j.val
          (Classical.choice (inferInstance : Nonempty Digest))))) =
      Nexus.N06.promedio f := by
    simp_rw [← lista_extraerRetos rs.length, retosDeFin_lista_getD]
    exact promedio_extraerRetos rs.length f
  rw [hm] at h
  exact h

theorem cota_ley_secuenciaRaices
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal)
    (s defecto : Digest) (f : Retos Digest d.rt.length → ℚ)
    (h0 : ∀ xs, 0 ≤ f xs) (h1 : ∀ xs, f xs ≤ 1) :
    Nexus.N06.promedio (fun H => f (secuenciaRaices d defecto s H)) ≤
      Nexus.N06.promedio f + errorRaices d.rt.length := by
  simpa only [secuenciaRaices, SelectorAdaptativo.oraculo] using
    (cota_leyRaicesFinales
      (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
      d.rt s
      (consultasEn_arbolRaicesCausales_of_lista
        (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
        d.rt s
        (fun s r hr => absorcion_raiz_en_universo d s r hr)
        (fun a _ => reto_en_universo d a))
      defecto f h0 h1)

theorem ley_causalRaicesCausales_programa
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal)
    (s : Digest) (defecto : Digest) (f : List Digest → ℚ) :
    Nexus.N06.promedio
        (fun H : SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d) → Digest =>
          f (respuestasRaicesCausales
            (SelectorAdaptativo.oraculo (Nexus.Canal.CanalPrevio.programa d) defecto H)
            d.rt s)) =
      Nexus.ROM.LeyArbol.valor f
        (restringirArbol
          (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
          (arbolRaicesCausales d.rt s)
          (consultasEn_arbolRaicesCausales_of_lista
            (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
            d.rt s
            (fun s r hr => absorcion_raiz_en_universo d s r hr)
            (fun a _ => reto_en_universo d a)))
        ∅ (fun _ => digestSoporte) := by
  simpa only [SelectorAdaptativo.oraculo] using
    (ley_causalRaicesCausales
      (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
      d.rt s
      (consultasEn_arbolRaicesCausales_of_lista
        (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
        d.rt s
        (fun s r hr => absorcion_raiz_en_universo d s r hr)
        (fun a _ => reto_en_universo d a))
      defecto f)

theorem ley_uniformeRaicesCausales_programa
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal)
    (s : Digest) (defecto : Digest) (f : List Digest → ℚ)
    (hf : frescaArbol
      (restringirArbol
        (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
        (arbolRaicesCausales d.rt s)
        (consultasEn_arbolRaicesCausales_of_lista
          (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
          d.rt s
          (fun s r hr => absorcion_raiz_en_universo d s r hr)
          (fun a _ => reto_en_universo d a))) ∅) :
    Nexus.N06.promedio
        (fun H : SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d) → Digest =>
          f (respuestasRaicesCausales
            (SelectorAdaptativo.oraculo (Nexus.Canal.CanalPrevio.programa d) defecto H)
            d.rt s)) =
      Nexus.N06.promedio (fun xs : Nexus.N06.Retos Digest (2 * d.rt.length) =>
        f (Nexus.ROM.CintasRetos.lista xs)) := by
  simpa only [SelectorAdaptativo.oraculo] using
    (ley_uniformeRaicesCausales
      (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
      d.rt s
      (consultasEn_arbolRaicesCausales_of_lista
        (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
        d.rt s
        (fun s r hr => absorcion_raiz_en_universo d s r hr)
        (fun a _ => reto_en_universo d a))
      hf defecto f)

theorem ley_uniformeRaicesCausales_finales_programa
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal)
    (s : Digest) (defecto : Digest) (f : List Digest → ℚ)
    (hf : frescaArbol
      (restringirArbol
        (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
        (arbolRaicesCausales d.rt s)
        (consultasEn_arbolRaicesCausales_of_lista
          (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
          d.rt s
          (fun s r hr => absorcion_raiz_en_universo d s r hr)
          (fun a _ => reto_en_universo d a))) ∅) :
    Nexus.N06.promedio
        (fun H : SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d) → Digest =>
          f (digestsRaices
            (SelectorAdaptativo.oraculo (Nexus.Canal.CanalPrevio.programa d) defecto H)
            d.rt s)) =
      Nexus.N06.promedio (fun xs : Nexus.N06.Retos Digest (2 * d.rt.length) =>
        f (extraerExtensiones (Nexus.ROM.CintasRetos.lista xs))) := by
  simpa only [SelectorAdaptativo.oraculo] using
    (ley_uniformeRaicesCausales_finales
      (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
      d.rt s
      (consultasEn_arbolRaicesCausales_of_lista
        (SelectorAdaptativo.universo (Nexus.Canal.CanalPrevio.programa d))
        d.rt s
        (fun s r hr => absorcion_raiz_en_universo d s r hr)
        (fun a _ => reto_en_universo d a))
      hf defecto f)

theorem transport_digestsRaices (G : Entrada → Digest) (rs : List Digest)
    (v : Fp2) (s : Digest) :
    (digestsRaices G rs s).map transporteRetoReal =
      (Nexus.Canal.RegistroRaices.evaluarRaices G rs v s).2.map
        (Nexus.Canal.RegistroRaices.beta G) := by
  induction rs generalizing s with
  | nil => rfl
  | cons r rs ih =>
    simp only [digestsRaices, Nexus.Canal.RegistroRaices.evaluarRaices,
      List.map_cons, ih]
    congr 1
    simpa only [Nexus.Canal.RegistroRaices.beta] using
      (Nexus.Verificador.LeyTransporteFRI.transporteRetoReal_factoriza
        (Nexus.Canal.RegistroRaices.respuesta G ⟨s, 2, r⟩)).trans
        (Nexus.Canal.DesafiosPrograma.extension_factoriza
          (Nexus.Canal.RegistroRaices.respuesta G ⟨s, 2, r⟩)).symm

theorem getD_map_of_lt {α β : Type} (f : α → β) (l : List α) (i : ℕ)
    (hi : i < l.length) (d : β) :
    (l.map f).getD i d = f (l.get ⟨i, hi⟩) := by
  unfold List.getD
  rw [List.getElem?_map]
  rw [List.getElem?_eq_getElem hi]
  simp only [Option.map_some]
  rfl

theorem getD_eq_get_of_lt {α : Type} (l : List α) (i : ℕ)
    (hi : i < l.length) (d : α) : l.getD i d = l.get ⟨i, hi⟩ := by
  unfold List.getD
  rw [List.getElem?_eq_getElem hi]
  rfl

theorem take_drop_prefix {α : Type} (a b c : List α) (n : ℕ)
    (ha : a.length = 3) (hb : b.length = n) :
    ((a ++ b ++ c).drop 3).take n = b := by
  simp [ha, hb]

theorem drop_two_prefix {α : Type} (a b c : List α) (n : ℕ)
    (ha : a.length = 3) (hb : b.length = n) :
    (a ++ b ++ c).drop (3 + n) = c := by
  simp [List.drop_append, ha, hb]

theorem digestsRaices_length (G : Entrada → Digest) (rs : List Digest) (s : Digest) :
    (digestsRaices G rs s).length = rs.length := by
  induction rs generalizing s with
  | nil => rfl
  | cons r rs ih => simp only [digestsRaices, List.length_cons, ih]

theorem retosDeFin_congr {K : Type} (n : ℕ) (f g : Fin n → K)
    (h : ∀ j, f j = g j) : retosDeFin n f = retosDeFin n g := by
  induction n with
  | zero => rfl
  | succ n ih =>
    apply Prod.ext
    · exact h 0
    · apply ih
      intro j
      exact h j.succ

theorem betasTraza_canonica (t : Tabla Entrada Digest) (defecto s : Digest)
    (d : ParametrosRecuperados.DatosCanal)
    (hc : Nexus.Verificador.FiltroFalso.Canonico t defecto s d) :
    let G := funcionTabla defecto t
    let v := RegistroCompleto.evaluar G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
    VistaCampo.betasTraza
        (VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s)) =
      v.traza.2.map (RegistroRaices.beta G) := by
  let G := funcionTabla defecto t
  let v := RegistroCompleto.evaluar G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
  have hcanon := Nexus.Verificador.FiltroFalso.retos_canonicos t defecto s d hc
  have h3 : v.alfas.2.length = 3 := by
    exact RegistroCompleto.alfas_tres G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
  have ht : v.traza.2.length = d.k := by
    change (Nexus.Canal.RegistroRaices.evaluarRaices G d.rt d.vt v.inicioTraza).2.length = d.k
    rw [Nexus.Canal.RegistroRaices.raices_longitud]
    exact hc.perfil.2.2.1
  have hcanon' : RetosRecuperados.retos G (ReconstruccionSelector.candidato t s) =
      v.alfas.2 ++ v.traza.2.map (RegistroRaices.beta G) ++
        v.composicion.2.map (RegistroRaices.beta G) := by
    simpa only [G, v] using hcanon
  dsimp only [VistaCampo.betasTraza, VistaSemantica.construir]
  change ((RetosRecuperados.retos G (ReconstruccionSelector.candidato t s)).drop 3).take d.k = _
  rw [hcanon']
  exact take_drop_prefix v.alfas.2 (v.traza.2.map (RegistroRaices.beta G))
    (v.composicion.2.map (RegistroRaices.beta G)) d.k h3
    (by simpa only [List.length_map] using ht)

theorem secuenciaTraza_canonica (t : Tabla Entrada Digest) (defecto s : Digest)
    (d : ParametrosRecuperados.DatosCanal)
    (hc : Nexus.Verificador.FiltroFalso.Canonico t defecto s d) :
    let G := funcionTabla defecto t
    let w := RegistroCompleto.evaluar G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
    let v := VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s)
    let xs : Retos Digest d.k :=
      retosDeFin d.k (fun j =>
        (digestsRaices G d.rt w.inicioTraza).getD j.val
          (Classical.choice (inferInstance : Nonempty Digest)))
    mapRetos transporteRetoReal d.k xs =
      retosDeFin d.k (fun j => (prefijo v).betaTraza j) := by
  let G := funcionTabla defecto t
  let w := RegistroCompleto.evaluar G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
  let v := VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s)
  let rs := digestsRaices G d.rt w.inicioTraza
  have hrt : rs.length = d.k := by
    change (digestsRaices G d.rt w.inicioTraza).length = d.k
    rw [digestsRaices_length]
    exact hc.perfil.2.2.1
  have hlist : rs.map transporteRetoReal = w.traza.2.map (RegistroRaices.beta G) := by
    change (digestsRaices G d.rt w.inicioTraza).map transporteRetoReal =
      (Nexus.Canal.RegistroRaices.evaluarRaices G d.rt d.vt w.inicioTraza).2.map
        (RegistroRaices.beta G)
    exact transport_digestsRaices G d.rt d.vt w.inicioTraza
  have hbetas : (prefijo v).betaTraza = fun j =>
      (w.traza.2.map (RegistroRaices.beta G)).getD j 0 := by
    funext j
    change (VistaCampo.betasTraza v).getD j 0 = _
    rw [betasTraza_canonica t defecto s d hc]
  change mapRetos transporteRetoReal d.k
      (retosDeFin d.k (fun j =>
        (digestsRaices G d.rt w.inicioTraza).getD j.val
          (Classical.choice (inferInstance : Nonempty Digest)))) =
    retosDeFin d.k (fun j => (prefijo v).betaTraza j)
  rw [mapRetos_retosDeFin]
  apply retosDeFin_congr
  intro j
  change transporteRetoReal
      (rs.getD j.val (Classical.choice (inferInstance : Nonempty Digest))) = _
  rw [hbetas]
  have hj : j.val < rs.length := by simpa only [hrt] using j.isLt
  have hget := congrArg (fun l => l.getD j.val (0 : Fp2)) hlist
  calc
    transporteRetoReal (rs.getD j.val
        (Classical.choice (inferInstance : Nonempty Digest))) =
        (rs.map transporteRetoReal).getD j.val 0 := by
      rw [getD_eq_get_of_lt rs j.val hj
        (Classical.choice (inferInstance : Nonempty Digest))]
      exact (getD_map_of_lt transporteRetoReal rs j.val hj 0).symm
    _ = (w.traza.2.map (RegistroRaices.beta G)).getD j.val 0 := hget

theorem betasComposicion_canonica (t : Tabla Entrada Digest) (defecto s : Digest)
    (d : ParametrosRecuperados.DatosCanal)
    (hc : Nexus.Verificador.FiltroFalso.Canonico t defecto s d) :
    let G := funcionTabla defecto t
    let w := RegistroCompleto.evaluar G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
    let v := VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s)
    VistaCampo.betasComposicion v = w.composicion.2.map (RegistroRaices.beta G) := by
  let G := funcionTabla defecto t
  let w := RegistroCompleto.evaluar G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
  let v := VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s)
  have hcanon := Nexus.Verificador.FiltroFalso.retos_canonicos t defecto s d hc
  have h3 : w.alfas.2.length = 3 := by
    exact RegistroCompleto.alfas_tres G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
  have ht : w.traza.2.length = d.k := by
    change (Nexus.Canal.RegistroRaices.evaluarRaices G d.rt d.vt w.inicioTraza).2.length = d.k
    rw [Nexus.Canal.RegistroRaices.raices_longitud]
    exact hc.perfil.2.2.1
  have hcanon' : RetosRecuperados.retos G (ReconstruccionSelector.candidato t s) =
      w.alfas.2 ++ w.traza.2.map (RegistroRaices.beta G) ++
        w.composicion.2.map (RegistroRaices.beta G) := by
    simpa only [G, w] using hcanon
  dsimp only [VistaCampo.betasComposicion, v]
  change (RetosRecuperados.retos G (ReconstruccionSelector.candidato t s)).drop
      (3 + d.k) = _
  rw [hcanon']
  exact drop_two_prefix w.alfas.2 (w.traza.2.map (RegistroRaices.beta G))
    (w.composicion.2.map (RegistroRaices.beta G)) d.k h3
    (by simpa only [List.length_map] using ht)

theorem secuenciaComposicion_canonica (t : Tabla Entrada Digest) (defecto s : Digest)
    (d : ParametrosRecuperados.DatosCanal)
    (hc : Nexus.Verificador.FiltroFalso.Canonico t defecto s d) :
    let G := funcionTabla defecto t
    let w := RegistroCompleto.evaluar G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
    let v := VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s)
    let xs : Retos Digest (d.k + 1) :=
      retosDeFin (d.k + 1) (fun j =>
        (digestsRaices G d.rc w.inicioComposicion).getD j.val
          (Classical.choice (inferInstance : Nonempty Digest)))
    mapRetos transporteRetoReal (d.k + 1) xs =
      retosDeFin (d.k + 1) (fun j => (prefijo v).betaComposicion j) := by
  let G := funcionTabla defecto t
  let w := RegistroCompleto.evaluar G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
  let v := VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s)
  let rs := digestsRaices G d.rc w.inicioComposicion
  have hrt : rs.length = d.k + 1 := by
    change (digestsRaices G d.rc w.inicioComposicion).length = d.k + 1
    rw [digestsRaices_length]
    exact hc.perfil.2.2.2.1
  have hlist : rs.map transporteRetoReal = w.composicion.2.map (RegistroRaices.beta G) := by
    change (digestsRaices G d.rc w.inicioComposicion).map transporteRetoReal =
      (Nexus.Canal.RegistroRaices.evaluarRaices G d.rc d.vc w.inicioComposicion).2.map
        (RegistroRaices.beta G)
    exact transport_digestsRaices G d.rc d.vc w.inicioComposicion
  have hbetas : (prefijo v).betaComposicion = fun j =>
      (w.composicion.2.map (RegistroRaices.beta G)).getD j 0 := by
    funext j
    change (VistaCampo.betasComposicion v).getD j 0 = _
    rw [betasComposicion_canonica t defecto s d hc]
  change mapRetos transporteRetoReal (d.k + 1)
      (retosDeFin (d.k + 1) (fun j =>
        (digestsRaices G d.rc w.inicioComposicion).getD j.val
          (Classical.choice (inferInstance : Nonempty Digest)))) =
    retosDeFin (d.k + 1) (fun j => (prefijo v).betaComposicion j)
  rw [mapRetos_retosDeFin]
  apply retosDeFin_congr
  intro j
  change transporteRetoReal
      (rs.getD j.val (Classical.choice (inferInstance : Nonempty Digest))) = _
  rw [hbetas]
  have hj : j.val < rs.length := by simpa only [hrt] using j.isLt
  have hget := congrArg (fun l => l.getD j.val (0 : Fp2)) hlist
  calc
    transporteRetoReal (rs.getD j.val
        (Classical.choice (inferInstance : Nonempty Digest))) =
        (rs.map transporteRetoReal).getD j.val 0 := by
      rw [getD_eq_get_of_lt rs j.val hj
        (Classical.choice (inferInstance : Nonempty Digest))]
      exact (getD_map_of_lt transporteRetoReal rs j.val hj 0).symm
    _ = (w.composicion.2.map (RegistroRaices.beta G)).getD j.val 0 := hget

theorem escapa_preimagen_of_escapa_desde {D K : Type} [Field K]
    [Fintype D] [DecidableEq D] [Nonempty D] [Fintype K] [DecidableEq K]
    (φ : D → K) (E : ℕ → List K → Finset K) (i : ℕ) (h : List D) (m : ℕ)
    (xs : Nexus.N06.Retos D m)
    (hmap : Nexus.N06.Escapa E (fun _ h x => h ++ [x]) i m (h.map φ)
      (mapRetos φ m xs)) :
    Nexus.N06.Escapa
      (fun i h => Nexus.FRI.preimagenExcepcion φ (E i (h.map φ)))
      (fun _ h x => h ++ [x]) i m h xs := by
  induction m generalizing i h with
  | zero => exact False.elim hmap
  | succ m ih =>
    rcases xs with ⟨d, rest⟩
    change φ d ∈ E i (h.map φ) ∨
      Nexus.N06.Escapa E (fun _ h x => h ++ [x]) (i + 1) m
        ((h.map φ) ++ [φ d]) (mapRetos φ m rest) at hmap
    change d ∈ Nexus.FRI.preimagenExcepcion φ (E i (h.map φ)) ∨
      Nexus.N06.Escapa
        (fun i h => Nexus.FRI.preimagenExcepcion φ (E i (h.map φ)))
        (fun _ h x => h ++ [x]) (i + 1) m (h ++ [d]) rest
    by_cases hd : φ d ∈ E i (h.map φ)
    · left
      exact (Nexus.FRI.mem_preimagenExcepcion φ (E i (h.map φ)) d).mpr hd
    · right
      apply ih (i := i + 1) (h := h ++ [d])
      simpa only [List.map_append, List.map_singleton] using hmap.resolve_left hd

theorem escapa_preimagen_of_escapa {D K : Type} [Field K]
    [Fintype D] [DecidableEq D] [Nonempty D] [Fintype K] [DecidableEq K]
    (φ : D → K) (E : ℕ → List K → Finset K) (m : ℕ)
    (xs : Nexus.N06.Retos D m)
    (hmap : Nexus.N06.Escapa E (fun _ h x => h ++ [x]) 0 m []
      (mapRetos φ m xs)) :
    Nexus.N06.Escapa
      (fun i h => Nexus.FRI.preimagenExcepcion φ (E i (h.map φ)))
      (fun _ h x => h ++ [x]) 0 m [] xs := by
  exact escapa_preimagen_of_escapa_desde φ E 0 [] m xs hmap

/-! Puentes locales: la excepción de una fase ya es un escape de la familia
    adaptativa correspondiente. Estos lemas dejan separada la parte FRI de
    la clasificación del evento real `Rondas`. -/
theorem fallaTraza_escapa (v : Vista) (hk : v.datos.k ≤ 29) :
    FallaTraza v hk →
      Escapa
        (Nexus.FRI.excepcionesHistoria (torreTraza v.datos.k hk) (1 / 8) (by norm_num)
          dos_extension_no_cero
          (margen_torre_goldilocks v.datos.k v.datos.k hk (Nat.le_succ _))
          (fun j _ => oraculoTraza (prefijo v) j))
        (fun _ h x => h ++ [x]) 0 v.datos.k []
        (retosDeFin v.datos.k (fun j => (prefijo v).betaTraza j)) := by
  intro hf
  let hm : ∀ j : Fin v.datos.k,
      ((torreTraza v.datos.k hk).grado (j + 1) : ℝ) - 1 <
        (1 - 3 * (1 / 8 : ℝ)) * ((torreTraza v.datos.k hk).dominio (j + 1)).card :=
    fun j => by
      simpa only [torreTraza] using
        margen_torre_goldilocks v.datos.k v.datos.k hk (Nat.le_succ _) j
  have hiff := Nexus.FRI.escape_historia_iff (torreTraza v.datos.k hk)
    (1 / 8) (by norm_num) dos_extension_no_cero hm
    (fun j _ => oraculoTraza (prefijo v) j)
    (retosDeFin v.datos.k (fun j => (prefijo v).betaTraza j))
  apply Classical.byContradiction
  intro hne
  have hsafe := hiff.mp hne
  rcases hf with ⟨j, hj⟩
  exact (hsafe j) (by simpa only [reto_retosDeFin] using hj)

theorem fallaComposicion_escapa (v : Vista) (hk : v.datos.k ≤ 29) :
    FallaComposicion v hk →
      Escapa
        (Nexus.FRI.excepcionesHistoria (torreComposicion v.datos.k hk) (1 / 8) (by norm_num)
          dos_extension_no_cero
          (margen_torre_goldilocks v.datos.k (v.datos.k + 1) hk (le_refl _))
          (fun j _ => oraculoComposicion (prefijo v) j))
        (fun _ h x => h ++ [x]) 0 (v.datos.k + 1) []
        (retosDeFin (v.datos.k + 1) (fun j => (prefijo v).betaComposicion j)) := by
  intro hf
  let hm : ∀ j : Fin (v.datos.k + 1),
      ((torreComposicion v.datos.k hk).grado (j + 1) : ℝ) - 1 <
        (1 - 3 * (1 / 8 : ℝ)) *
          ((torreComposicion v.datos.k hk).dominio (j + 1)).card :=
    fun j => by
      simpa only [torreComposicion] using
        margen_torre_goldilocks v.datos.k (v.datos.k + 1) hk (le_refl _) j
  have hiff := Nexus.FRI.escape_historia_iff (torreComposicion v.datos.k hk)
    (1 / 8) (by norm_num) dos_extension_no_cero hm
    (fun j _ => oraculoComposicion (prefijo v) j)
    (retosDeFin (v.datos.k + 1) (fun j => (prefijo v).betaComposicion j))
  apply Classical.byContradiction
  intro hne
  have hsafe := hiff.mp hne
  rcases hf with ⟨j, hj⟩
  exact (hsafe j) (by simpa only [reto_retosDeFin] using hj)

theorem fallaTraza_escapa_cruda (v : Vista) (hk : v.datos.k ≤ 29)
    (xs : Nexus.N06.Retos Nexus.Merkle.Digest v.datos.k)
    (hseq : mapRetos transporteRetoReal v.datos.k xs =
      retosDeFin v.datos.k (fun j => (prefijo v).betaTraza j)) :
    FallaTraza v hk →
      Nexus.N06.Escapa
        (excepcionesDigest (torreTraza v.datos.k hk) (1 / 8) (by norm_num)
          dos_extension_no_cero
          (margen_torre_goldilocks v.datos.k v.datos.k hk (Nat.le_succ _))
          (fun j _ => oraculoTraza (prefijo v) j))
        pasoDigest 0 v.datos.k [] xs := by
  intro hf
  have hmapped : Nexus.N06.Escapa
      (Nexus.FRI.excepcionesHistoria (torreTraza v.datos.k hk) (1 / 8) (by norm_num)
        dos_extension_no_cero
        (margen_torre_goldilocks v.datos.k v.datos.k hk (Nat.le_succ _))
        (fun j _ => oraculoTraza (prefijo v) j))
      (fun _ h x => h ++ [x]) 0 v.datos.k []
      (mapRetos transporteRetoReal v.datos.k xs) := by
    rw [hseq]
    exact fallaTraza_escapa v hk hf
  have hraw := escapa_preimagen_of_escapa transporteRetoReal
    (Nexus.FRI.excepcionesHistoria (torreTraza v.datos.k hk) (1 / 8) (by norm_num)
      dos_extension_no_cero
      (margen_torre_goldilocks v.datos.k v.datos.k hk (Nat.le_succ _))
      (fun j _ => oraculoTraza (prefijo v) j)) v.datos.k xs hmapped
  unfold excepcionesDigest pasoDigest
  exact hraw

theorem fallaComposicion_escapa_cruda (v : Vista) (hk : v.datos.k ≤ 29)
    (xs : Nexus.N06.Retos Nexus.Merkle.Digest (v.datos.k + 1))
    (hseq : mapRetos transporteRetoReal (v.datos.k + 1) xs =
      retosDeFin (v.datos.k + 1) (fun j => (prefijo v).betaComposicion j)) :
    FallaComposicion v hk →
      Nexus.N06.Escapa
        (excepcionesDigest (torreComposicion v.datos.k hk) (1 / 8) (by norm_num)
          dos_extension_no_cero
          (margen_torre_goldilocks v.datos.k (v.datos.k + 1) hk (le_refl _))
          (fun j _ => oraculoComposicion (prefijo v) j))
        pasoDigest 0 (v.datos.k + 1) [] xs := by
  intro hf
  have hmapped : Nexus.N06.Escapa
      (Nexus.FRI.excepcionesHistoria (torreComposicion v.datos.k hk) (1 / 8) (by norm_num)
        dos_extension_no_cero
        (margen_torre_goldilocks v.datos.k (v.datos.k + 1) hk (le_refl _))
        (fun j _ => oraculoComposicion (prefijo v) j))
      (fun _ h x => h ++ [x]) 0 (v.datos.k + 1) []
      (mapRetos transporteRetoReal (v.datos.k + 1) xs) := by
    rw [hseq]
    exact fallaComposicion_escapa v hk hf
  have hraw := escapa_preimagen_of_escapa transporteRetoReal
    (Nexus.FRI.excepcionesHistoria (torreComposicion v.datos.k hk) (1 / 8) (by norm_num)
      dos_extension_no_cero
      (margen_torre_goldilocks v.datos.k (v.datos.k + 1) hk (le_refl _))
      (fun j _ => oraculoComposicion (prefijo v) j)) (v.datos.k + 1) xs hmapped
  unfold excepcionesDigest pasoDigest
  exact hraw

theorem fallaTraza_escapa_canonica (t : Tabla Entrada Digest) (defecto s : Digest)
    (d : ParametrosRecuperados.DatosCanal)
    (hc : Nexus.Verificador.FiltroFalso.Canonico t defecto s d)
    (hk : d.k ≤ 29) :
    FallaTraza
        (VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s)) hk →
      Escapa
        (excepcionesDigest (torreTraza d.k hk) (1 / 8) (by norm_num)
          dos_extension_no_cero
          (margen_torre_goldilocks d.k d.k hk (Nat.le_succ _))
          (fun j _ => oraculoTraza (prefijo
            (VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s))) j))
        pasoDigest 0 d.k []
        (retosDeFin d.k (fun j =>
          (digestsRaices (funcionTabla defecto t) d.rt
            (RegistroCompleto.evaluar (funcionTabla defecto t) d.k d.bits d.inicio d.salida
              d.raiz d.rt d.rc d.vt d.vc).inicioTraza).getD j.val
            (Classical.choice (inferInstance : Nonempty Digest)))) := by
  let v := VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s)
  let G := funcionTabla defecto t
  let w := RegistroCompleto.evaluar G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
  intro hf
  change FallaTraza v hk at hf
  apply fallaTraza_escapa_cruda v hk
    (retosDeFin d.k (fun j =>
      (digestsRaices G d.rt w.inicioTraza).getD j.val
        (Classical.choice (inferInstance : Nonempty Digest))))
  · simpa only [G, w, v, VistaSemantica.construir] using
      secuenciaTraza_canonica t defecto s d hc
  · exact hf

theorem fallaComposicion_escapa_canonica (t : Tabla Entrada Digest) (defecto s : Digest)
    (d : ParametrosRecuperados.DatosCanal)
    (hc : Nexus.Verificador.FiltroFalso.Canonico t defecto s d)
    (hk : d.k ≤ 29) :
    FallaComposicion
        (VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s)) hk →
      Escapa
        (excepcionesDigest (torreComposicion d.k hk) (1 / 8) (by norm_num)
          dos_extension_no_cero
          (margen_torre_goldilocks d.k (d.k + 1) hk (le_refl _))
          (fun j _ => oraculoComposicion (prefijo
            (VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s))) j))
        pasoDigest 0 (d.k + 1) []
        (retosDeFin (d.k + 1) (fun j =>
          (digestsRaices (funcionTabla defecto t) d.rc
            (RegistroCompleto.evaluar (funcionTabla defecto t) d.k d.bits d.inicio d.salida
              d.raiz d.rt d.rc d.vt d.vc).inicioComposicion).getD j.val
            (Classical.choice (inferInstance : Nonempty Digest)))) := by
  let v := VistaSemantica.construir t defecto d (ReconstruccionSelector.candidato t s)
  let G := funcionTabla defecto t
  let w := RegistroCompleto.evaluar G d.k d.bits d.inicio d.salida d.raiz d.rt d.rc d.vt d.vc
  intro hf
  change FallaComposicion v hk at hf
  apply fallaComposicion_escapa_cruda v hk
    (retosDeFin (d.k + 1) (fun j =>
      (digestsRaices G d.rc w.inicioComposicion).getD j.val
        (Classical.choice (inferInstance : Nonempty Digest))))
  · simpa only [G, w, v, VistaSemantica.construir] using
      secuenciaComposicion_canonica t defecto s d hc
  · exact hf

noncomputable def escapeTraza (v : Vista) (hk : v.datos.k ≤ 29) : Prop :=
  Escapa
    (Nexus.FRI.excepcionesHistoria (torreTraza v.datos.k hk) (1 / 8) (by norm_num)
      dos_extension_no_cero
      (margen_torre_goldilocks v.datos.k v.datos.k hk (Nat.le_succ _))
      (fun j _ => oraculoTraza (prefijo v) j))
    (fun _ h x => h ++ [x]) 0 v.datos.k []
    (retosDeFin v.datos.k (fun j => (prefijo v).betaTraza j))

noncomputable def escapeComposicion (v : Vista) (hk : v.datos.k ≤ 29) : Prop :=
  Escapa
    (Nexus.FRI.excepcionesHistoria (torreComposicion v.datos.k hk) (1 / 8) (by norm_num)
      dos_extension_no_cero
      (margen_torre_goldilocks v.datos.k (v.datos.k + 1) hk (le_refl _))
      (fun j _ => oraculoComposicion (prefijo v) j))
    (fun _ h x => h ++ [x]) 0 (v.datos.k + 1) []
    (retosDeFin (v.datos.k + 1) (fun j => (prefijo v).betaComposicion j))

theorem fallaTraza_escapa' (v : Vista) (hk : v.datos.k ≤ 29) :
    FallaTraza v hk → escapeTraza v hk := by
  simpa only [escapeTraza] using fallaTraza_escapa v hk

theorem fallaComposicion_escapa' (v : Vista) (hk : v.datos.k ≤ 29) :
    FallaComposicion v hk → escapeComposicion v hk := by
  simpa only [escapeComposicion] using fallaComposicion_escapa v hk

@[expose] noncomputable def cancelacionAIR (v : Vista) : Prop :=
  ∃ f : Polynomial Fp2,
    candidatoPerfil v.datos.k (oraculoTraza (prefijo v) 0) (1 / 8) = some f ∧
    (∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) ∧
    Nexus.AIR.numeradorCombinado (2 ^ v.datos.k) (raizExtension v.datos.k) f
        (algebraMap Fp Fp2 v.datos.inicio) (algebraMap Fp Fp2 v.datos.salida)
        (prefijo v).coeficientes % Nexus.AIR.denominador (2 ^ v.datos.k) = 0

noncomputable def alfasRetos (v : Vista) : Nexus.N06.Retos Fp2 3 :=
  ((prefijo v).coeficientes.1,
    ((prefijo v).coeficientes.2.1, (prefijo v).coeficientes.2.2, PUnit.unit))

noncomputable def escapeAIR (v : Vista) : Prop :=
  ∃ f : Polynomial Fp2,
    candidatoPerfil v.datos.k (oraculoTraza (prefijo v) 0) (1 / 8) = some f ∧
    (∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) ∧
    ∃ j : ℕ,
      j < 3 ∧
      residuosPerfil v.datos.k f (algebraMap Fp Fp2 v.datos.inicio)
        (algebraMap Fp Fp2 v.datos.salida) j ≠ 0 ∧
      (∀ i, j < i → i < 3 →
        residuosPerfil v.datos.k f (algebraMap Fp Fp2 v.datos.inicio)
          (algebraMap Fp Fp2 v.datos.salida) i = 0) ∧
      Escapa
        (excepcionesAIR
          (residuosPerfil v.datos.k f (algebraMap Fp Fp2 v.datos.inicio)
            (algebraMap Fp Fp2 v.datos.salida)) j)
        (pasoAIR
          (residuosPerfil v.datos.k f (algebraMap Fp Fp2 v.datos.inicio)
            (algebraMap Fp Fp2 v.datos.salida)))
        0 3 0 (alfasRetos v)

theorem cancelacionAIR_escapa (v : Vista) (hk0 : 2 ≤ v.datos.k) (hk : v.datos.k ≤ 29)
    (hfalso : Falso v.datos) :
    cancelacionAIR v → escapeAIR v := by
  intro hc
  unfold cancelacionAIR at hc
  rcases hc with ⟨f, hprofile, hbase, hair⟩
  obtain ⟨j, hj, hR, hrest, hprob⟩ :=
    candidato_base_ronda_critica v.datos.k hk0 hk
      (oraculoTraza (prefijo v) 0) (1 / 8) f hprofile hbase
      v.datos.inicio v.datos.salida ((falso_iff v.datos).mp hfalso)
  refine ⟨f, hprofile, hbase, j, hj, hR, hrest, ?_⟩
  apply (escape_air_iff_resto v.datos.k f
    (algebraMap Fp Fp2 v.datos.inicio) (algebraMap Fp Fp2 v.datos.salida)
    j hj hrest (prefijo v).coeficientes).mpr
  simpa only [alfasRetos] using hair

theorem fallos_escapan_o_air (v : Vista) (hk : v.datos.k ≤ 29) :
    Fallos v hk → escapeTraza v hk ∨ cancelacionAIR v ∨ escapeComposicion v hk := by
  intro hf
  change
    (candidatoPerfil v.datos.k (oraculoTraza (prefijo v) 0) (1 / 8) = none ∧
      FallaTraza v hk) ∨
      ∃ f : Polynomial Fp2,
        candidatoPerfil v.datos.k (oraculoTraza (prefijo v) 0) (1 / 8) = some f ∧
        (∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) ∧
        (Nexus.AIR.numeradorCombinado (2 ^ v.datos.k) (raizExtension v.datos.k) f
            (algebraMap Fp Fp2 v.datos.inicio) (algebraMap Fp Fp2 v.datos.salida)
            (prefijo v).coeficientes % Nexus.AIR.denominador (2 ^ v.datos.k) = 0 ∨
          (candidato (cosetExtension (v.datos.k + 3))
              (oraculoComposicion (prefijo v) 0) (2 * 2 ^ v.datos.k) (1 / 8) = none ∧
            FallaComposicion v hk)) at hf
  rcases hf with htrace | ⟨f, hprofile, hbase, hair | hcomp⟩
  · exact Or.inl (fallaTraza_escapa' v hk htrace.2)
  · exact Or.inr (Or.inl ⟨f, hprofile, hbase, hair⟩)
  · exact Or.inr (Or.inr (fallaComposicion_escapa' v hk hcomp.2))

noncomputable def faseDeFallo (v : Vista) (hk : v.datos.k ≤ 29) : Prop :=
  escapeTraza v hk ∨ cancelacionAIR v ∨ escapeComposicion v hk

theorem fallos_faseDeFallo (v : Vista) (hk : v.datos.k ≤ 29) :
    Fallos v hk → faseDeFallo v hk := by
  simpa only [faseDeFallo] using fallos_escapan_o_air v hk

theorem rondas_fase_o_air {A : Type} (H : Entrada → Digest) (p : Programa A)
    (defecto : Digest) (N : ℕ) (hx : ExcesoRondas.Rondas H p defecto N) :
    ∃ n : Fin N, PoliticasPrefijo.Inicia H p defecto n.val ∧
      ∃ d, ∃ hc : Canonico
        (TablaObservada.tabla ((traza H p).take n.val)) defecto
        (SemillaProxima.semilla p defecto ((traza H p).take n.val)) d,
        Falso d ∧
          faseDeFallo
            (construir (TablaObservada.tabla ((traza H p).take n.val)) defecto d
              (ReconstruccionSelector.candidato
                (TablaObservada.tabla ((traza H p).take n.val))
                (SemillaProxima.semilla p defecto ((traza H p).take n.val))))
            (by change d.k ≤ 29; have hk := hc.perfil.1.2; omega) := by
  obtain ⟨n, hi, ⟨d, hc, hf, hfall⟩⟩ :=
    Nexus.Verificador.RondasReales.rondas_clasificadas H p defecto N hx
  exact ⟨n, hi, d, hc, hf,
    fallos_faseDeFallo _ _ hfall⟩

theorem rondas_fases_escapan {A : Type} (H : Entrada → Digest) (p : Programa A)
    (defecto : Digest) (N : ℕ) (hx : ExcesoRondas.Rondas H p defecto N) :
    ∃ n : Fin N, PoliticasPrefijo.Inicia H p defecto n.val ∧
      ∃ d, ∃ hc : Canonico
        (TablaObservada.tabla ((traza H p).take n.val)) defecto
        (SemillaProxima.semilla p defecto ((traza H p).take n.val)) d,
        Falso d ∧
          (escapeTraza
              (construir (TablaObservada.tabla ((traza H p).take n.val)) defecto d
                (ReconstruccionSelector.candidato
                  (TablaObservada.tabla ((traza H p).take n.val))
                  (SemillaProxima.semilla p defecto ((traza H p).take n.val))))
              (by change d.k ≤ 29; have hk := hc.perfil.1.2; omega) ∨
          escapeAIR
            (construir (TablaObservada.tabla ((traza H p).take n.val)) defecto d
              (ReconstruccionSelector.candidato
                (TablaObservada.tabla ((traza H p).take n.val))
                (SemillaProxima.semilla p defecto ((traza H p).take n.val)))) ∨
          escapeComposicion
            (construir (TablaObservada.tabla ((traza H p).take n.val)) defecto d
              (ReconstruccionSelector.candidato
                (TablaObservada.tabla ((traza H p).take n.val))
                (SemillaProxima.semilla p defecto ((traza H p).take n.val))))
            (by change d.k ≤ 29; have hk := hc.perfil.1.2; omega)) := by
  obtain ⟨n, hi, ⟨d, hc, hf, hfall⟩⟩ :=
    Nexus.Verificador.RondasReales.rondas_clasificadas H p defecto N hx
  have hk0 : 2 ≤ d.k := by have hk := hc.perfil.1.1; omega
  have hk : d.k ≤ 29 := by have hk := hc.perfil.1.2; omega
  rcases fallos_escapan_o_air _ hk hfall with ht | ha | hcomp
  · exact ⟨n, hi, d, hc, hf, Or.inl ht⟩
  · exact ⟨n, hi, d, hc, hf, Or.inr (Or.inl (cancelacionAIR_escapa _ hk0 hk hf ha))⟩
  · exact ⟨n, hi, d, hc, hf, Or.inr (Or.inr hcomp)⟩

noncomputable def faseReal {A : Type}
    (fase : ∀ v : Vista, v.datos.k ≤ 29 → Prop)
    (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (N : ℕ) : Prop :=
  ∃ n : Fin N, PoliticasPrefijo.Inicia H p defecto n.val ∧
    ∃ d, ∃ hc : Canonico
      (TablaObservada.tabla ((traza H p).take n.val)) defecto
      (SemillaProxima.semilla p defecto ((traza H p).take n.val)) d,
      Falso d ∧ fase
        (construir (TablaObservada.tabla ((traza H p).take n.val)) defecto d
          (ReconstruccionSelector.candidato
            (TablaObservada.tabla ((traza H p).take n.val))
            (SemillaProxima.semilla p defecto ((traza H p).take n.val))))
        (by change d.k ≤ 29; have hk := hc.perfil.1.2; omega)

theorem rondas_faseReal_union {A : Type} (H : Entrada → Digest) (p : Programa A)
    (defecto : Digest) (N : ℕ) (hx : ExcesoRondas.Rondas H p defecto N) :
    faseReal (fun v hk => escapeTraza v hk) H p defecto N ∨
      faseReal (fun v _ => escapeAIR v) H p defecto N ∨
      faseReal (fun v hk => escapeComposicion v hk) H p defecto N := by
  obtain ⟨n, hi, d, hc, hf, hphase⟩ := rondas_fases_escapan H p defecto N hx
  have hk : d.k ≤ 29 := by have h := hc.perfil.1.2; omega
  let v := construir (TablaObservada.tabla ((traza H p).take n.val)) defecto d
    (ReconstruccionSelector.candidato
      (TablaObservada.tabla ((traza H p).take n.val))
      (SemillaProxima.semilla p defecto ((traza H p).take n.val)))
  rcases hphase with ht | ha | hcomp
  · left
    refine ⟨n, hi, d, hc, hf, ?_⟩
    simpa only [v] using ht
  · right; left
    refine ⟨n, hi, d, hc, hf, ?_⟩
    simpa only [v] using ha
  · right; right
    refine ⟨n, hi, d, hc, hf, ?_⟩
    simpa only [v] using hcomp

theorem medida_union_tres {W : Type} [Fintype W]
    (E F G : W → Prop) :
    Nexus.ROM.FiltroSelector.medida (fun w => E w ∨ F w ∨ G w) ≤
      Nexus.ROM.FiltroSelector.medida E +
        Nexus.ROM.FiltroSelector.medida F +
          Nexus.ROM.FiltroSelector.medida G := by
  classical
  unfold Nexus.ROM.FiltroSelector.medida
  rw [← Nexus.N06.promedio_suma, ← Nexus.N06.promedio_suma]
  apply Nexus.N06.promedio_monotono
  intro w
  by_cases he : E w <;> by_cases hf : F w <;> by_cases hg : G w <;>
    simp [he, hf, hg]

theorem medida_rondas_le_fases {A : Type} (p : Programa A) (defecto : Digest) (N : ℕ)
    (hclas : ∀ H : SelectorAdaptativo.universo p → Digest,
      ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto N →
        faseReal (fun v hk => escapeTraza v hk)
            (SelectorAdaptativo.oraculo p defecto H) p defecto N ∨
        faseReal (fun v _ => escapeAIR v)
            (SelectorAdaptativo.oraculo p defecto H) p defecto N ∨
        faseReal (fun v hk => escapeComposicion v hk)
            (SelectorAdaptativo.oraculo p defecto H) p defecto N) :
    Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto N) ≤
      Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          faseReal (fun v hk => escapeTraza v hk)
            (SelectorAdaptativo.oraculo p defecto H) p defecto N) +
      Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          faseReal (fun v _ => escapeAIR v)
            (SelectorAdaptativo.oraculo p defecto H) p defecto N) +
      Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          faseReal (fun v hk => escapeComposicion v hk)
            (SelectorAdaptativo.oraculo p defecto H) p defecto N) := by
  apply (Nexus.ROM.FiltroSelector.medida_monotona _ _ hclas).trans
  exact medida_union_tres _ _ _

theorem medida_rondas_le_fases_clasificadas {A : Type} (p : Programa A)
    (defecto : Digest) (N : ℕ) :
    Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto N) ≤
      Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          faseReal (fun v hk => escapeTraza v hk)
            (SelectorAdaptativo.oraculo p defecto H) p defecto N) +
      Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          faseReal (fun v _ => escapeAIR v)
            (SelectorAdaptativo.oraculo p defecto H) p defecto N) +
      Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          faseReal (fun v hk => escapeComposicion v hk)
            (SelectorAdaptativo.oraculo p defecto H) p defecto N) := by
  apply medida_rondas_le_fases p defecto N
  intro H hx
  exact rondas_faseReal_union (SelectorAdaptativo.oraculo p defecto H) p defecto N hx

/-! Descomposición del experimento global. Un escape demostrado para el sufijo
    de una ronda concreta se puede levantar al vector completo, conservando el
    estado que dejó el prefijo. -/
def appendRetos {K : Type} : {n k : ℕ} → Nexus.N06.Retos K k →
    Nexus.N06.Retos K n → Nexus.N06.Retos K (n + k)
  | n, 0, _, ys => by simpa using ys
  | n, k + 1, xs, ys => (xs.1, appendRetos xs.2 ys)

def estadoRetos {K S : Type} (paso : ℕ → S → K → S) :
    (i k : ℕ) → S → Nexus.N06.Retos K k → S
  | _i, 0, s, _ => s
  | i, k + 1, s, xs => estadoRetos paso (i + 1) k (paso i s xs.1) xs.2

theorem escapa_append {K S : Type} (E : ℕ → S → Finset K)
    (paso : ℕ → S → K → S) (i k n : ℕ) (s : S)
    (xs : Nexus.N06.Retos K k) (ys : Nexus.N06.Retos K n) :
    Nexus.N06.Escapa E paso i (n + k) s (appendRetos xs ys) ↔
      Nexus.N06.Escapa E paso i k s xs ∨
        Nexus.N06.Escapa E paso (i + k) n (estadoRetos paso i k s xs) ys := by
  induction k generalizing i n s with
  | zero =>
    constructor
    · intro h
      exact Or.inr (by simpa [appendRetos, estadoRetos] using h)
    · intro h
      rcases h with h | h
      · simp only [Nexus.N06.Escapa] at h
      · simpa [appendRetos, estadoRetos] using h
  | succ k ih =>
    obtain ⟨x, xs⟩ := xs
    simp only [appendRetos, Nexus.N06.Escapa, estadoRetos]
    constructor
    · intro h
      rcases h with h | h
      · exact Or.inl (Or.inl h)
      · rcases (ih (i := i + 1) (n := n) (s := paso i s x) xs ys).mp h with h | h
        · exact Or.inl (Or.inr h)
        · exact Or.inr (by simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using h)
    · intro h
      rcases h with h | h
      · rcases h with h | h
        · exact Or.inl h
        · exact Or.inr ((ih (i := i + 1) (n := n) (s := paso i s x) xs ys).mpr
            (Or.inl h))
      · exact Or.inr ((ih (i := i + 1) (n := n) (s := paso i s x) xs ys).mpr
          (Or.inr (by simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using h)))

theorem escapa_append_of_prefijo {K S : Type} (E : ℕ → S → Finset K)
    (paso : ℕ → S → K → S) (i k n : ℕ) (s : S)
    (xs : Nexus.N06.Retos K k) (ys : Nexus.N06.Retos K n)
    (hxs : Nexus.N06.Escapa E paso i k s xs) :
    Nexus.N06.Escapa E paso i (n + k) s (appendRetos xs ys) :=
  (escapa_append E paso i k n s xs ys).mpr (Or.inl hxs)

theorem escapa_append_of_sufijo {K S : Type} (E : ℕ → S → Finset K)
    (paso : ℕ → S → K → S) (i k n : ℕ) (s : S)
    (xs : Nexus.N06.Retos K k) (ys : Nexus.N06.Retos K n)
    (hys : Nexus.N06.Escapa E paso (i + k) n (estadoRetos paso i k s xs) ys) :
    Nexus.N06.Escapa E paso i (n + k) s (appendRetos xs ys) :=
  (escapa_append E paso i k n s xs ys).mpr (Or.inr hys)

namespace LeyCausal

variable {Q A : Type} [Fintype Q] [Fintype A] [DecidableEq Q] [Nonempty A]

def consReto (a : A) {n : ℕ} (xs : Nexus.N06.Retos A n) :
    Nexus.N06.Retos A (n + 1) := by
  change A × Nexus.N06.Retos A n
  exact (a, xs)

def arbolRetos (q : List A → Q) : (n : ℕ) → List A →
    Nexus.ROM.LeyArbol.Arbol Q A (Nexus.N06.Retos A n)
  | 0, _ => .terminar PUnit.unit
  | n + 1, h =>
      .consultar (q h) (fun a =>
        Nexus.ROM.LeyArbol.transformar (consReto a)
          (arbolRetos q n (h ++ [a])))

def frescaHasta (q : List A → Q) (m : ℕ) : Prop :=
  ∀ h : List A, h.length < m → q h ∉ Nexus.ROM.HistoriaCausal.vistas q h

omit [Fintype Q] [Fintype A] [Nonempty A] in
theorem frescaHasta_iff_no_repeticion (q : List A → Q) (m : ℕ) :
    frescaHasta q m ↔
      ∀ h : List A, h.length < m →
        ∀ i : Fin h.length, q h ≠ q (h.take i.val) := by
  constructor
  · intro hf h hh i hqi
    exact (hf h hh) (Finset.mem_image.mpr ⟨i, Finset.mem_univ _, hqi.symm⟩)
  · intro hfresh h hh hq
    rcases Finset.mem_image.mp hq with ⟨i, -, hi⟩
    exact (hfresh h hh i) hi.symm

omit [Fintype Q] [Fintype A] [Nonempty A] in
theorem vistas_append_singleton (q : List A → Q) (h : List A) (a : A) :
    Nexus.ROM.HistoriaCausal.vistas q (h ++ [a]) =
      insert (q h) (Nexus.ROM.HistoriaCausal.vistas q h) := by
  ext x
  constructor
  · intro hx
    rcases Finset.mem_image.mp hx with ⟨i, -, rfl⟩
    by_cases hi : i.val < h.length
    · apply Finset.mem_insert.mpr
      right
      apply Finset.mem_image.mpr
      refine ⟨⟨i.val, hi⟩, Finset.mem_univ _, ?_⟩
      have hsub : i.val - h.length = 0 := by omega
      simp [List.take_append, hsub]
    · have hi' : i.val = h.length := by
        have hi'' := i.isLt
        simp only [List.length_append, List.length_singleton] at hi''
        omega
      apply Finset.mem_insert.mpr
      left
      simp [hi']
  · intro hx
    rcases Finset.mem_insert.mp hx with rfl | hx
    · apply Finset.mem_image.mpr
      refine ⟨⟨h.length, by simp⟩, Finset.mem_univ _, ?_⟩
      simp
    · rcases Finset.mem_image.mp hx with ⟨i, -, rfl⟩
      apply Finset.mem_image.mpr
      refine ⟨⟨i.val, by simp⟩, Finset.mem_univ _, ?_⟩
      simp [List.take_append]

omit [Fintype Q] [Nonempty A] in
theorem valor_transformar {R T : Type} (g : R → T) (f : T → ℚ)
    (p : Nexus.ROM.LeyArbol.Arbol Q A R) (S : Finset Q) (v : Q → A) :
    Nexus.ROM.LeyArbol.valor f (Nexus.ROM.LeyArbol.transformar g p) S v =
      Nexus.ROM.LeyArbol.valor (fun r => f (g r)) p S v := by
  induction p generalizing S v with
  | terminar r => rfl
  | consultar q k ih =>
    simp only [Nexus.ROM.LeyArbol.transformar, Nexus.ROM.LeyArbol.valor]
    by_cases hq : q ∈ S
    · simp only [hq, ite_true]
      exact ih (v q) S v
    · simp only [hq, ite_false]
      congr 1
      funext a
      exact ih a (insert q S) (Function.update v q a)

omit [Fintype Q] in
theorem valor_arbolRetos (q : List A → Q) (m : ℕ) (hf : frescaHasta q m)
    (n : ℕ) (h : List A) (v : Q → A) (f : Nexus.N06.Retos A n → ℚ)
    (hbound : h.length + n ≤ m) :
    Nexus.ROM.LeyArbol.valor f (arbolRetos q n h)
        (Nexus.ROM.HistoriaCausal.vistas q h) v = Nexus.N06.promedio f := by
  induction n generalizing h v with
  | zero =>
    have hfconst : f = fun _ : Nexus.N06.Retos A 0 => f PUnit.unit := by
      funext x
      exact congrArg f (PUnit.ext x PUnit.unit)
    rw [hfconst]
    simp only [arbolRetos, Nexus.ROM.LeyArbol.valor]
    exact (Nexus.N06.promedio_constante (f PUnit.unit)).symm
  | succ n ih =>
    have hq : q h ∉ Nexus.ROM.HistoriaCausal.vistas q h := hf h (by omega)
    rw [arbolRetos, Nexus.ROM.LeyArbol.valor, ite_eq_right hq]
    calc
      _ = Nexus.N06.promedio (fun a : A =>
          Nexus.N06.promedio (fun xs : Nexus.N06.Retos A n => f (consReto a xs))) := by
        congr 1
        funext a
        rw [valor_transformar (g := consReto a)]
        rw [← vistas_append_singleton]
        have hbound' : (h ++ [a]).length + n ≤ m := by
          simp only [List.length_append, List.length_singleton]
          omega
        exact ih (h ++ [a]) (Function.update v (q h) a)
          (fun xs => f (consReto a xs)) hbound'
      _ = Nexus.N06.promedio f := by
        change Nexus.N06.promedio (fun a : A =>
            Nexus.N06.promedio (fun xs : Nexus.N06.Retos A n => f (a, xs))) =
          Nexus.N06.promedio (fun z : A × Nexus.N06.Retos A n => f z)
        exact (Nexus.N06.promedio_producto f).symm

theorem ley_arbolRetos (q : List A → Q) (n : ℕ) (hf : frescaHasta q n)
    (f : Nexus.N06.Retos A n → ℚ) :
    Nexus.N06.promedio (fun H : Q → A =>
      f (Nexus.ROM.LeyArbol.evaluar H (arbolRetos q n []))) =
      Nexus.N06.promedio f := by
  rw [Nexus.ROM.LeyArbol.ley_desde_vacio]
  exact valor_arbolRetos q n hf n []
    (fun _ => Classical.choice (inferInstance : Nonempty A)) f (by simp)

theorem ley_arbolRetos_of_no_repeticion (q : List A → Q) (n : ℕ)
    (hfresh : ∀ h : List A, h.length < n →
      ∀ i : Fin h.length, q h ≠ q (h.take i.val))
    (f : Nexus.N06.Retos A n → ℚ) :
    Nexus.N06.promedio (fun H : Q → A =>
      f (Nexus.ROM.LeyArbol.evaluar H (arbolRetos q n []))) =
      Nexus.N06.promedio f := by
  exact ley_arbolRetos q n
    ((frescaHasta_iff_no_repeticion q n).mpr hfresh) f

end LeyCausal

theorem medida_fase_le_riesgo {A D S : Type} {N : ℕ} [Fintype D] [DecidableEq D]
    [Nonempty D] (p : Programa A) (fase : (SelectorAdaptativo.universo p → Digest) → Prop)
    (secuencia : (SelectorAdaptativo.universo p → Digest) → Nexus.N06.Retos D N)
    (E : ℕ → S → Finset D) (paso : ℕ → S → D → S) (s : S)
    (hley : ∀ f : Nexus.N06.Retos D N → ℚ,
      Nexus.N06.promedio
        (fun H : SelectorAdaptativo.universo p → Digest => f (secuencia H)) =
        Nexus.N06.promedio f)
    (hpuente : ∀ H : SelectorAdaptativo.universo p → Digest,
      fase H → Nexus.N06.Escapa E paso 0 N s (secuencia H)) :
    Nexus.ROM.FiltroSelector.medida fase ≤
      Nexus.N06.riesgo E paso (fun _ => 0) 0 N s := by
  classical
  calc
    _ = Nexus.N06.promedio (fun H : SelectorAdaptativo.universo p → Digest =>
        if fase H then (1 : ℚ) else 0) := by
      exact Nexus.ROM.FiltroSelector.medida_media _
    _ ≤ Nexus.N06.promedio (fun H : SelectorAdaptativo.universo p → Digest =>
        Nexus.N06.valor E paso (fun _ => 0) 0 N s (secuencia H)) := by
      apply Nexus.N06.promedio_monotono
      intro H
      by_cases hf : fase H
      · rw [Nexus.N06.valor_escape]
        simp [hf, hpuente H hf]
      · simp only [hf, reduceIte]
        rw [Nexus.N06.valor_escape]
        split <;> norm_num
    _ = Nexus.N06.promedio (fun xs : Nexus.N06.Retos D N =>
        Nexus.N06.valor E paso (fun _ => 0) 0 N s xs) := hley _
    _ = Nexus.N06.riesgo E paso (fun _ => 0) 0 N s := by
      symm
      exact Nexus.N06.riesgo_es_promedio E paso (fun _ => 0) 0 N s

theorem cota_fase_fri_desde_puente {A : Type} {m : ℕ}
    (p : Programa A) (_defecto : Digest)
    (fase : (SelectorAdaptativo.universo p → Digest) → Prop)
    (t : Nexus.FRI.Torre Fp2 m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2)
    (secuencia : (SelectorAdaptativo.universo p → Digest) → Nexus.N06.Retos Digest m)
    (hley : ∀ f : Nexus.N06.Retos Digest m → ℚ,
      Nexus.N06.promedio
        (fun H : SelectorAdaptativo.universo p → Digest => f (secuencia H)) =
        Nexus.N06.promedio f)
    (hpuente : ∀ H : SelectorAdaptativo.universo p → Digest,
      fase H → Nexus.N06.Escapa
        (excepcionesDigest t θ hθ h2 hmargin estrategia)
        pasoDigest 0 m [] (secuencia H)) :
    Nexus.ROM.FiltroSelector.medida fase ≤
      (((t.dominio 0).card - (t.dominio m).card : ℕ) : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (m : ℚ) * (2524360 / 10 ^ 35) := by
  have hmed := medida_fase_le_riesgo p fase secuencia
    (excepcionesDigest t θ hθ h2 hmargin estrategia) pasoDigest [] hley hpuente
  have hmed' := hmed
  rw [excepcionesDigest_eq_cruda t θ hθ h2 hmargin estrategia] at hmed'
  change Nexus.ROM.FiltroSelector.medida fase ≤
    Nexus.N06.riesgo
      (Nexus.FRI.excepcionesHistoriaCruda t θ hθ h2 hmargin estrategia
        transporteRetoReal)
      (fun _ h d => h ++ [d]) (fun _ => 0) 0 m [] at hmed'
  have hprob := cota_adaptativa_digest_goldilocks_telescopica
    t θ hθ h2 hmargin estrategia
  calc
    _ ≤ Nexus.FRI.probabilidadExcepcionesCruda t θ hθ h2 hmargin estrategia
        transporteRetoReal := by
      exact hmed'.trans_eq
        (Nexus.FRI.probabilidadExcepcionesCruda_eq t θ hθ h2 hmargin estrategia
          transporteRetoReal).symm
    _ ≤ (((t.dominio 0).card - (t.dominio m).card : ℕ) : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (m : ℚ) * (2524360 / 10 ^ 35) := hprob

theorem cota_fase_fri_raices_con_repeticiones {A : Type}
    (p : Programa A) (defecto : Digest)
    (fase : (SelectorAdaptativo.universo p → Digest) → Prop)
    (rs : List Digest) (s : Digest)
    (hp : consultasEn (SelectorAdaptativo.universo p) (arbolRaicesCausales rs s))
    (t : Nexus.FRI.Torre Fp2 rs.length)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin rs.length, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2)
    (hpuente : ∀ H : SelectorAdaptativo.universo p → Digest,
      fase H → Escapa (excepcionesDigest t θ hθ h2 hmargin estrategia)
        pasoDigest 0 rs.length []
        (retosDeFin rs.length (fun j =>
          (digestsRaices (SelectorAdaptativo.oraculo p defecto H) rs s).getD j.val
            (Classical.choice (inferInstance : Nonempty Digest))))) :
    FiltroSelector.medida fase ≤
      (((t.dominio 0).card - (t.dominio rs.length).card : ℕ) : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (rs.length : ℚ) * (2524360 / 10 ^ 35) + errorRaices rs.length := by
  classical
  let E := excepcionesDigest t θ hθ h2 hmargin estrategia
  let seq := fun H : SelectorAdaptativo.universo p → Digest =>
    retosDeFin rs.length (fun j =>
      (digestsRaices (SelectorAdaptativo.oraculo p defecto H) rs s).getD j.val
        (Classical.choice (inferInstance : Nonempty Digest)))
  have htrans := cota_leyRaicesFinales (SelectorAdaptativo.universo p) rs s hp defecto
    (fun xs => if Escapa E pasoDigest 0 rs.length [] xs then (1 : ℚ) else 0)
    (fun _ => by split_ifs <;> norm_num) (fun _ => by split_ifs <;> norm_num)
  have hmed : FiltroSelector.medida fase ≤
      Nexus.N06.riesgo E pasoDigest (fun _ => 0) 0 rs.length [] + errorRaices rs.length := by
    calc
      _ = Nexus.N06.promedio (fun H => if fase H then (1 : ℚ) else 0) :=
        FiltroSelector.medida_media fase
      _ ≤ Nexus.N06.promedio (fun H =>
          if Escapa E pasoDigest 0 rs.length [] (seq H) then (1 : ℚ) else 0) := by
        apply Nexus.N06.promedio_monotono
        intro H
        by_cases hf : fase H
        · simp only [hf, hpuente H hf, ite_true, seq, E]
          exact le_rfl
        · simp only [hf, ite_false]
          split_ifs <;> norm_num
      _ ≤ Nexus.N06.promedio (fun xs : Retos Digest rs.length =>
          if Escapa E pasoDigest 0 rs.length [] xs then (1 : ℚ) else 0) +
          errorRaices rs.length := by
        simpa [seq, SelectorAdaptativo.oraculo] using htrans
      _ = _ := by
        rw [Nexus.N06.riesgo_es_promedio]
        congr 1
        apply congrArg Nexus.N06.promedio
        funext xs
        exact (Nexus.N06.valor_escape E pasoDigest 0 rs.length [] xs).symm
  change FiltroSelector.medida fase ≤
    Nexus.N06.riesgo (excepcionesDigest t θ hθ h2 hmargin estrategia)
      pasoDigest (fun _ => 0) 0 rs.length [] + errorRaices rs.length at hmed
  rw [excepcionesDigest_eq_cruda t θ hθ h2 hmargin estrategia] at hmed
  change FiltroSelector.medida fase ≤
    Nexus.N06.riesgo
      (Nexus.FRI.excepcionesHistoriaCruda t θ hθ h2 hmargin estrategia transporteRetoReal)
      (fun _ h d => h ++ [d]) (fun _ => 0) 0 rs.length [] + errorRaices rs.length at hmed
  rw [← Nexus.FRI.probabilidadExcepcionesCruda_eq
    t θ hθ h2 hmargin estrategia transporteRetoReal] at hmed
  exact hmed.trans (add_le_add
    (cota_adaptativa_digest_goldilocks_telescopica t θ hθ h2 hmargin estrategia) (le_refl _))

theorem cota_fase_uniforme_desde_puente {A D S : Type} {N : ℕ}
    [Fintype D] [DecidableEq D] [Nonempty D]
    (p : Programa A) (fase : (SelectorAdaptativo.universo p → Digest) → Prop)
    (secuencia : (SelectorAdaptativo.universo p → Digest) → Nexus.N06.Retos D N)
    (E : ℕ → S → Finset D) (paso : ℕ → S → D → S) (s : S)
    (B : ℕ → ℕ)
    (hE : ∀ i z, (E i z).card ≤ B i)
    (hley : ∀ f : Nexus.N06.Retos D N → ℚ,
      Nexus.N06.promedio
        (fun H : SelectorAdaptativo.universo p → Digest => f (secuencia H)) =
        Nexus.N06.promedio f)
    (hpuente : ∀ H : SelectorAdaptativo.universo p → Digest,
      fase H → Nexus.N06.Escapa E paso 0 N s (secuencia H)) :
    Nexus.ROM.FiltroSelector.medida fase ≤
      (∑ j ∈ Finset.range N, (B j : ℚ)) / Fintype.card D := by
  have hmed := medida_fase_le_riesgo p fase secuencia E paso s hley hpuente
  have hbound := Nexus.N06.cota_riesgo E paso (fun _ => 0) B 0
    (by norm_num) (by intro _; rfl) hE 0 N s
  exact hmed.trans (by simpa only [zero_add] using hbound)

theorem cota_rondas_desde_puente_adaptativo {A : Type} {m : ℕ}
    (p : Programa A) (defecto : Digest)
    (t : Nexus.FRI.Torre Fp2 m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2)
    (secuencia : (SelectorAdaptativo.universo p → Digest) → Nexus.N06.Retos Digest m)
    (hley : ∀ f : Nexus.N06.Retos Digest m → ℚ,
      Nexus.N06.promedio
        (fun H : SelectorAdaptativo.universo p → Digest => f (secuencia H)) =
        Nexus.N06.promedio f)
    (hpuente : ∀ H : SelectorAdaptativo.universo p → Digest,
      ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto m →
      Nexus.N06.Escapa
        (excepcionesDigest t θ hθ h2 hmargin estrategia)
        pasoDigest 0 m [] (secuencia H)) :
    Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto m) ≤
      (((t.dominio 0).card - (t.dominio m).card : ℕ) : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (m : ℚ) * (2524360 / 10 ^ 35) := by
  have hmed := medida_rondas_le_riesgo p defecto m secuencia
    (excepcionesDigest t θ hθ h2 hmargin estrategia) pasoDigest [] hley hpuente
  have hmed' := hmed
  rw [excepcionesDigest_eq_cruda t θ hθ h2 hmargin estrategia] at hmed'
  change Nexus.ROM.FiltroSelector.medida
      (fun H : SelectorAdaptativo.universo p → Digest =>
        ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto m) ≤
    Nexus.N06.riesgo
      (Nexus.FRI.excepcionesHistoriaCruda t θ hθ h2 hmargin estrategia
        transporteRetoReal)
      (fun _ h d => h ++ [d]) (fun _ => 0) 0 m [] at hmed'
  have hprob := cota_adaptativa_digest_goldilocks_telescopica
    t θ hθ h2 hmargin estrategia
  calc
    _ ≤ Nexus.FRI.probabilidadExcepcionesCruda t θ hθ h2 hmargin estrategia
        transporteRetoReal := by
      exact hmed'.trans_eq
        (Nexus.FRI.probabilidadExcepcionesCruda_eq t θ hθ h2 hmargin estrategia
          transporteRetoReal).symm
    _ ≤ (((t.dominio 0).card - (t.dominio m).card : ℕ) : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (m : ℚ) * (2524360 / 10 ^ 35) := hprob

theorem cota_rondas_desde_secuenciaRaices
    (d : Nexus.Canal.ParametrosRecuperados.DatosCanal)
    (s defecto : Digest)
    (t : Nexus.FRI.Torre Fp2 d.rt.length)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin d.rt.length, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2)
    (hf : frescaArbol (arbolRaicesPrograma d s) ∅)
    (hpuente : ∀ H : SelectorAdaptativo.universo
        (Nexus.Canal.CanalPrevio.programa d) → Digest,
      ExcesoRondas.Rondas
          (SelectorAdaptativo.oraculo (Nexus.Canal.CanalPrevio.programa d) defecto H)
          (Nexus.Canal.CanalPrevio.programa d) defecto d.rt.length →
        Nexus.N06.Escapa
          (excepcionesDigest t θ hθ h2 hmargin estrategia)
          pasoDigest 0 d.rt.length [] (secuenciaRaices d defecto s H)) :
    Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo
            (Nexus.Canal.CanalPrevio.programa d) → Digest =>
          ExcesoRondas.Rondas
            (SelectorAdaptativo.oraculo (Nexus.Canal.CanalPrevio.programa d) defecto H)
            (Nexus.Canal.CanalPrevio.programa d) defecto d.rt.length) ≤
      (((t.dominio 0).card - (t.dominio d.rt.length).card : ℕ) : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (d.rt.length : ℚ) * (2524360 / 10 ^ 35) := by
  apply cota_rondas_desde_puente_adaptativo
    (Nexus.Canal.CanalPrevio.programa d) defecto t θ hθ h2 hmargin estrategia
    (secuenciaRaices d defecto s)
  · intro f
    exact ley_uniforme_secuenciaRaices d s defecto f hf
  · exact hpuente

/-! Instancia que ya no postula `hley`: la ley se deriva del árbol causal
    cuando la consulta elegida queda fuera de todas las vistas previas. -/
theorem cota_rondas_desde_estrategia_fresca {A : Type} {m : ℕ}
    (p : Programa A) (defecto : Digest)
    (t : Nexus.FRI.Torre Fp2 m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2)
    (q : List Digest → SelectorAdaptativo.universo p)
    (hfresca : LeyCausal.frescaHasta q m)
    (hpuente : ∀ H : SelectorAdaptativo.universo p → Digest,
      ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto m →
      Nexus.N06.Escapa
        (excepcionesDigest t θ hθ h2 hmargin estrategia)
        pasoDigest 0 m []
        (Nexus.ROM.LeyArbol.evaluar H (LeyCausal.arbolRetos q m []))) :
    Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto m) ≤
      (((t.dominio 0).card - (t.dominio m).card : ℕ) : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (m : ℚ) * (2524360 / 10 ^ 35) := by
  apply cota_rondas_desde_puente_adaptativo p defecto t θ hθ h2 hmargin estrategia
    (fun H => Nexus.ROM.LeyArbol.evaluar H (LeyCausal.arbolRetos q m []))
  · intro f
    exact LeyCausal.ley_arbolRetos q m hfresca f
  · exact hpuente

/-! Composición con la cota final del verificador. La parte de `SinBad` se
    conserva como entrada independiente: este resultado cierra exactamente
    la sustitución de la probabilidad de rondas, no la inventa. -/
theorem cota_rondas_desde_estrategia_no_repeticion {A : Type} {m : ℕ}
    (p : Programa A) (defecto : Digest)
    (t : Nexus.FRI.Torre Fp2 m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2)
    (q : List Digest → SelectorAdaptativo.universo p)
    (hfresh : ∀ h : List Digest, h.length < m →
      ∀ i : Fin h.length, q h ≠ q (h.take i.val))
    (hpuente : ∀ H : SelectorAdaptativo.universo p → Digest,
      ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto m →
      Nexus.N06.Escapa
        (excepcionesDigest t θ hθ h2 hmargin estrategia)
        pasoDigest 0 m []
        (Nexus.ROM.LeyArbol.evaluar H (LeyCausal.arbolRetos q m []))) :
    Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto m) ≤
      (((t.dominio 0).card - (t.dominio m).card : ℕ) : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (m : ℚ) * (2524360 / 10 ^ 35) := by
  exact cota_rondas_desde_estrategia_fresca p defecto t θ hθ h2 hmargin estrategia q
    ((LeyCausal.frescaHasta_iff_no_repeticion q m).mpr hfresh) hpuente

theorem cota_aceptacion_512_desde_puente {A : Type}
    (L bits k Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (defecto : Digest) (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hQ : ∀ H : SelectorAdaptativo.universo
        (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias
          (SelectorAdaptativo.oraculo
            (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
          bits 512 proponer atacar actualizar ≤ Q)
    (epsSin : ℚ)
    (hSin : Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo
            (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest =>
          ¬ EjecucionBytes.SinBad
            (SelectorAdaptativo.oraculo
              (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
            (inicial L) (Adversario.ejecutar bits 512 proponer atacar actualizar))
        ≤ epsSin)
    (t : Nexus.FRI.Torre Fp2
      (ProgramaBytes.altura (Adversario.ejecutar bits 512 proponer atacar actualizar)))
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin (ProgramaBytes.altura
        (Adversario.ejecutar bits 512 proponer atacar actualizar)),
      (t.grado (j + 1) : ℝ) - 1 <
        (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2)
    (secuencia :
      (SelectorAdaptativo.universo
        (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest) →
        Nexus.N06.Retos Digest
          (ProgramaBytes.altura
            (Adversario.ejecutar bits 512 proponer atacar actualizar)))
    (hley : ∀ f : Nexus.N06.Retos Digest
        (ProgramaBytes.altura
          (Adversario.ejecutar bits 512 proponer atacar actualizar)) → ℚ,
      Nexus.N06.promedio
        (fun H : SelectorAdaptativo.universo
            (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest =>
          f (secuencia H)) = Nexus.N06.promedio f)
    (hpuente : ∀ H : SelectorAdaptativo.universo
        (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      ExcesoRondas.Rondas
          (SelectorAdaptativo.oraculo
            (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
          (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto
          (ProgramaBytes.altura
            (Adversario.ejecutar bits 512 proponer atacar actualizar)) →
        Nexus.N06.Escapa
          (excepcionesDigest t θ hθ h2 hmargin estrategia)
          pasoDigest 0
          (ProgramaBytes.altura
            (Adversario.ejecutar bits 512 proponer atacar actualizar)) []
          (secuencia H)) :
    Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo
            (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest =>
          PoliticasFalsas.AceptaFalsa
            (SelectorAdaptativo.oraculo
              (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
            bits 512 k proponer atacar actualizar) ≤
      epsSin +
        (((t.dominio 0).card - (t.dominio
          (ProgramaBytes.altura
            (Adversario.ejecutar bits 512 proponer atacar actualizar))).card : ℕ) : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (ProgramaBytes.altura
          (Adversario.ejecutar bits 512 proponer atacar actualizar) : ℚ) *
          (2524360 / 10 ^ 35) +
        ((Nat.choose (CardinalVista.umbral (k + 2)) 40 : ℚ) /
          Nat.choose (2 ^ (k + 2)) 40 +
          1 / (2 : ℚ) ^ 300 +
          AcoplamientoCadena.error Digest 512 (Q + 24894)) * (Q + 24895) := by
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  let epsRondas : ℚ :=
    (((t.dominio 0).card - (t.dominio (ProgramaBytes.altura p)).card : ℕ) : ℚ) /
        (Nexus.Goldilocks.p : ℚ) ^ 2 +
      (ProgramaBytes.altura p : ℚ) * (2524360 / 10 ^ 35)
  have hr := cota_rondas_desde_puente_adaptativo p defecto t θ hθ h2
    hmargin estrategia secuencia hley hpuente
  have hr' : Nexus.ROM.FiltroSelector.medida
      (fun H : SelectorAdaptativo.universo p → Digest =>
        ExcesoRondas.Rondas
          (SelectorAdaptativo.oraculo p defecto H) p defecto (ProgramaBytes.altura p))
      ≤ epsRondas := by
    simpa only [epsRondas] using hr
  have hf := Nexus.Verificador.CotaRondas.cota_512_final
    L bits k Q proponer atacar actualizar defecto hk0 hk1 hQ epsSin epsRondas
  dsimp only [p] at hf hSin hr'
  have hfinal := hf hSin hr'
  dsimp only [epsRondas] at hfinal
  convert hfinal using 1
  ring

theorem cota_rondas_desde_tres_fases {A : Type} (p : Programa A) (defecto : Digest)
    (N : ℕ) (epsTraza epsAIR epsComposicion : ℚ)
    (hTraza : Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          faseReal (fun v hk => escapeTraza v hk)
            (SelectorAdaptativo.oraculo p defecto H) p defecto N) ≤ epsTraza)
    (hAIR : Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          faseReal (fun v _ => escapeAIR v)
            (SelectorAdaptativo.oraculo p defecto H) p defecto N) ≤ epsAIR)
    (hComposicion : Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          faseReal (fun v hk => escapeComposicion v hk)
            (SelectorAdaptativo.oraculo p defecto H) p defecto N) ≤ epsComposicion) :
    Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo p → Digest =>
          ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto N) ≤
      epsTraza + epsAIR + epsComposicion := by
  have hu := medida_rondas_le_fases_clasificadas p defecto N
  linarith

theorem cota_aceptacion_512_desde_tres_fases {A : Type}
    (L bits k Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (defecto : Digest) (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (hQ : ∀ H : SelectorAdaptativo.universo
        (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest,
      Adversario.adversarias
          (SelectorAdaptativo.oraculo
            (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
          bits 512 proponer atacar actualizar ≤ Q)
    (epsSin epsTraza epsAIR epsComposicion : ℚ)
    (hSin : Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo
            (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest =>
          ¬ EjecucionBytes.SinBad
            (SelectorAdaptativo.oraculo
              (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
            (inicial L) (Adversario.ejecutar bits 512 proponer atacar actualizar))
        ≤ epsSin)
    (hTraza : Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo
            (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest =>
          faseReal (fun v hk => escapeTraza v hk)
            (SelectorAdaptativo.oraculo
              (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
            (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto
            (ProgramaBytes.altura
              (Adversario.ejecutar bits 512 proponer atacar actualizar))) ≤ epsTraza)
    (hAIR : Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo
            (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest =>
          faseReal (fun v _ => escapeAIR v)
            (SelectorAdaptativo.oraculo
              (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
            (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto
            (ProgramaBytes.altura
              (Adversario.ejecutar bits 512 proponer atacar actualizar))) ≤ epsAIR)
    (hComposicion : Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo
            (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest =>
          faseReal (fun v hk => escapeComposicion v hk)
            (SelectorAdaptativo.oraculo
              (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
            (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto
            (ProgramaBytes.altura
              (Adversario.ejecutar bits 512 proponer atacar actualizar))) ≤ epsComposicion) :
    Nexus.ROM.FiltroSelector.medida
        (fun H : SelectorAdaptativo.universo
            (Adversario.ejecutar bits 512 proponer atacar actualizar) → Digest =>
          PoliticasFalsas.AceptaFalsa
            (SelectorAdaptativo.oraculo
              (Adversario.ejecutar bits 512 proponer atacar actualizar) defecto H)
            bits 512 k proponer atacar actualizar) ≤
      epsSin + epsTraza + epsAIR + epsComposicion +
        ((Nat.choose (CardinalVista.umbral (k + 2)) 40 : ℚ) /
          Nat.choose (2 ^ (k + 2)) 40 +
          1 / (2 : ℚ) ^ 300 +
          AcoplamientoCadena.error Digest 512 (Q + 24894)) * (Q + 24895) := by
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  have hTraza' : Nexus.ROM.FiltroSelector.medida
      (fun H : SelectorAdaptativo.universo p → Digest =>
        faseReal (fun v hk => escapeTraza v hk)
          (SelectorAdaptativo.oraculo p defecto H) p defecto (ProgramaBytes.altura p)) ≤
      epsTraza := by simpa only [p] using hTraza
  have hAIR' : Nexus.ROM.FiltroSelector.medida
      (fun H : SelectorAdaptativo.universo p → Digest =>
        faseReal (fun v _ => escapeAIR v)
          (SelectorAdaptativo.oraculo p defecto H) p defecto (ProgramaBytes.altura p)) ≤
      epsAIR := by simpa only [p] using hAIR
  have hComposicion' : Nexus.ROM.FiltroSelector.medida
      (fun H : SelectorAdaptativo.universo p → Digest =>
        faseReal (fun v hk => escapeComposicion v hk)
          (SelectorAdaptativo.oraculo p defecto H) p defecto (ProgramaBytes.altura p)) ≤
      epsComposicion := by simpa only [p] using hComposicion
  have hRondas := cota_rondas_desde_tres_fases p defecto (ProgramaBytes.altura p)
    epsTraza epsAIR epsComposicion hTraza' hAIR' hComposicion'
  have hf := Nexus.Verificador.CotaRondas.cota_512_final
    L bits k Q proponer atacar actualizar defecto hk0 hk1 hQ epsSin
    (epsTraza + epsAIR + epsComposicion)
  dsimp only [p] at hf hSin hRondas
  have hfinal := hf hSin hRondas
  linarith

/-! Esta composición paga las repeticiones y deriva la probabilidad de
`¬ SinBad` desde Q. Sus raíces y estado inicial son fijos. La clasificación
causal permanece como premisa; no se atribuye esta cota a elecciones
posteriores de raíces. -/
theorem cota_aceptacion_512_raices_con_repeticiones {A : Type}
    (L bits k Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (defecto : Digest) (hk0 : 4 ≤ k) (hk1 : k ≤ 12)
    (rs : List Digest) (s : Digest)
    (t : Nexus.FRI.Torre Fp2 rs.length)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin rs.length, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2) :
    let p := Adversario.ejecutar bits 512 proponer atacar actualizar
    (∀ H : SelectorAdaptativo.universo p → Digest,
      Adversario.adversarias (SelectorAdaptativo.oraculo p defecto H)
        bits 512 proponer atacar actualizar ≤ Q) →
    consultasEn (SelectorAdaptativo.universo p) (arbolRaicesCausales rs s) →
    (∀ H : SelectorAdaptativo.universo p → Digest,
      EjecucionBytes.SinBad (SelectorAdaptativo.oraculo p defecto H) (inicial L) p →
      ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto (altura p) →
        Escapa (excepcionesDigest t θ hθ h2 hmargin estrategia)
          pasoDigest 0 rs.length [] (retosDeFin rs.length (fun j =>
            (digestsRaices (SelectorAdaptativo.oraculo p defecto H) rs s).getD j.val
              (Classical.choice (inferInstance : Nonempty Digest))))) →
    FiltroSelector.medida (fun H : SelectorAdaptativo.universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (SelectorAdaptativo.oraculo p defecto H)
        bits 512 k proponer atacar actualizar) ≤
      min 1 ((((Q + 24895) * (49 * (Q + 24895) + L) : ℕ) : ℚ) / (2 : ℚ) ^ 256) +
        (((t.dominio 0).card - (t.dominio rs.length).card : ℕ) : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (rs.length : ℚ) * (2524360 / 10 ^ 35) + errorRaices rs.length +
        ((Nat.choose (CardinalVista.umbral (k + 2)) 40 : ℚ) /
          Nat.choose (2 ^ (k + 2)) 40 + 1 / (2 : ℚ) ^ 300 +
          AcoplamientoCadena.error Digest 512 (Q + 24894)) * (Q + 24895) := by
  dsimp only
  intro hQ hp hpuente
  let p := Adversario.ejecutar bits 512 proponer atacar actualizar
  have hr := cota_fase_fri_raices_con_repeticiones p defecto
    (fun H => EjecucionBytes.SinBad (SelectorAdaptativo.oraculo p defecto H) (inicial L) p ∧
      ExcesoRondas.Rondas (SelectorAdaptativo.oraculo p defecto H) p defecto (altura p))
    rs s hp t θ hθ h2 hmargin estrategia (fun H hh => hpuente H hh.1 hh.2)
  have hb := Nexus.Verificador.CotaSinBad.cota_512_rondas_seguras
    L bits k Q proponer atacar actualizar defecto hk0 hk1 hQ
  dsimp only [p] at hr
  linarith

end Nexus.Verificador.PuenteAdaptativoFinal
