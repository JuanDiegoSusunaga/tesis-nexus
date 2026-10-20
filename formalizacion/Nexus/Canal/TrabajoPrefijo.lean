module

public import Nexus.Canal.PrimerosPares
public import Nexus.Verificador.PoliticasTrabajo
public import Nexus.Verificador.TrabajoSelectorLocal
public import Nexus.Canal.PrimerasExposiciones
import Mathlib.Tactic

/-!
# Unión ponderada de trabajo y selector en los prefijos del programa real

El universo sigue siendo el del programa original. Se activan solamente las
parejas cuyas dos direcciones pertenecen a ese universo. La selección de
conjuntos y la activación usan el pasado, antes de las dos respuestas.
-/

public section
namespace Nexus.Canal.TrabajoPrefijo

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM
open SelectorAdaptativo LeyArbol ObservacionesPrefijo PrefijosGlobales
open ConteoActivaciones ActivacionPrefijo

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

variable {A : Type}

@[expose] noncomputable def codigo (p : ProgramaBytes.Programa A) (b : Bool) (k : ParTrabajo.Clave) : universo p :=
  @dite (universo p) (PrefijoTrabajo.consulta b k.1 k.2 ∈ universo p) (Classical.propDecidable _)
    (fun h => ⟨PrefijoTrabajo.consulta b k.1 k.2, h⟩) (fun _ => SelectorAdaptativo.codigo p k.1)

theorem codigo_conocido (p : ProgramaBytes.Programa A) (b : Bool) (k : ParTrabajo.Clave)
    (h : PrefijoTrabajo.consulta b k.1 k.2 ∈ universo p) :
    (codigo p b k).val = PrefijoTrabajo.consulta b k.1 k.2 := by
  simp only [codigo, h, dite_true]

theorem distinto_indice (p : ProgramaBytes.Programa A) (b : Bool) (k : ParTrabajo.Clave)
    (h : PrefijoTrabajo.consulta b k.1 k.2 ∈ universo p) (d : Digest) :
    SelectorAdaptativo.codigo p d ≠ codigo p b k := by
  intro he
  have hl := congrArg List.length (congrArg Subtype.val he)
  rw [codigo_conocido p b k h] at hl
  change (entradaReto d .indice).length = (PrefijoTrabajo.consulta b k.1 k.2).length at hl
  rw [reto_longitud, PrefijoTrabajo.longitud_consulta] at hl
  cases b <;> contradiction

@[expose] noncomputable def Activa (p : ProgramaBytes.Programa A) (defecto : Digest)
    (t : List ((universo p) × Digest)) : Prop :=
  PrimerosPares.Activa p defecto (proyectar t) ∧
    ∀ b : Bool, PrefijoTrabajo.consulta b (PrimerosPares.clave p defecto (proyectar t)).1
      (PrimerosPares.clave p defecto (proyectar t)).2 ∈ universo p

@[expose] noncomputable def Evento (p : ProgramaBytes.Programa A) (defecto : Digest)
    (bits R e g : ℕ) (t : List ((universo p) × Digest)) (H : universo p → Digest) : Prop :=
  let k := PrimerosPares.clave p defecto (proyectar t)
  let s := H (codigo p false k)
  Nexus.Verificador.Completo.trabajo bits (H (codigo p true k)) = true ∧
    SelectorAdaptativo.codigo p s ∉ (t.map Prod.fst).toFinset ∧
    Nexus.Verificador.TrabajoSelectorLocal.Omite (SelectorAdaptativo.codigo p) H R e 40 s
      (Nexus.Verificador.PoliticasTrabajo.buenos e g (TablaObservada.tabla (proyectar t)) defecto k)

theorem codigo_fresco (p : ProgramaBytes.Programa A) (defecto : Digest) (H : universo p → Digest)
    (n : ℕ) (ha : Activa p defecto (prefijo (arbol p) n H)) (b : Bool) :
    codigo p b (PrimerosPares.clave p defecto (historia p defecto n H)) ∉ vistas H (arbol p) n := by
  have hi : PrimerosPares.Inicia (oraculo p defecto H) p defecto n := by
    have hraw := ha.1
    rw [prefijo_bytes p defecto n H] at hraw
    simpa only [historia] using hraw
  have hm := ha.2 b
  rw [prefijo_bytes] at hm
  have hf := PrimerosPares.frescura_ambas (oraculo p defecto H) p defecto n hi b
  have hp := (consulta_proyectada (prefijo (arbol p) n H)
    (codigo p b (PrimerosPares.clave p defecto (historia p defecto n H)))).not
  apply hp.mpr
  rw [prefijo_bytes, codigo_conocido p b _ hm]
  simpa only [historia, List.mem_toFinset, ProgramaBytes.entradas, List.map_take] using hf

theorem riesgo_monotono (R e q g g' m m' : ℕ) (hg : g ≤ g') (hm : m ≤ m') :
    SelectorPrimeras.riesgo R e q g m ≤ SelectorPrimeras.riesgo R e q g' m' := by
  unfold SelectorPrimeras.riesgo
  apply add_le_add
  · apply add_le_add
    · apply div_le_div_of_nonneg_right _ (by positivity)
      exact_mod_cast Nat.choose_le_choose q hg
    · exact le_refl _
  · unfold AcoplamientoCadena.error
    apply min_le_min_left
    apply div_le_div_of_nonneg_right _ (by positivity)
    exact_mod_cast Nat.mul_le_mul_left R (Nat.add_le_add_right (Nat.add_le_add_right hm R) 1)

theorem cota_condicionada (p : ProgramaBytes.Programa A) (defecto : Digest) (H : universo p → Digest)
    (n bits R e g B : ℕ) (hbits : bits = 12 ∨ bits = 20)
    (he : e ≤ 64) (hm : 40 ≤ 2 ^ e) (hR : 40 ≤ R)
    (ha : Activa p defecto (prefijo (arbol p) n H)) (hB : (vistas H (arbol p) n).card ≤ B) :
    promedio (fun G : Tablas H (arbol p) n =>
      if Evento p defecto bits R e g (prefijo (arbol p) n G.val) G.val then (1 : ℚ) else 0) ≤
      (1 / (2 : ℚ) ^ bits) * SelectorPrimeras.riesgo R e 40 g (B + 2) := by
  rw [ContinuacionPrefijo.ley_tabla_y_pasado H (arbol p) n
    (fun t G => if Evento p defecto bits R e g t G then (1 : ℚ) else 0)]
  let t := prefijo (arbol p) n H
  let k := PrimerosPares.clave p defecto (proyectar t)
  let G := Nexus.Verificador.PoliticasTrabajo.buenos e g (TablaObservada.tabla (proyectar t)) defecto k
  have hc (b : Bool) : (codigo p b k).val = PrefijoTrabajo.consulta b k.1 k.2 := codigo_conocido p b k (ha.2 b)
  have hne : codigo p false k ≠ codigo p true k := by
    intro h
    have hl := congrArg List.length (congrArg Subtype.val h)
    rw [hc false, hc true, PrefijoTrabajo.longitud_consulta, PrefijoTrabajo.longitud_consulta] at hl
    contradiction
  have hf (b : Bool) : codigo p b k ∉ vistas H (arbol p) n := by
    dsimp only [t, k]
    rw [prefijo_bytes p defecto n H]
    exact codigo_fresco p defecto H n ha b
  have h := Nexus.Verificador.TrabajoSelectorLocal.cota_trabajo_selector
    (SelectorAdaptativo.codigo p) (SelectorAcoplado.codificar_inyectiva _ _)
    (vistas H (arbol p) n) H (codigo p true k) (codigo p false k) (hf true) (hf false) hne
    (distinto_indice p true k (ha.2 true)) (distinto_indice p false k (ha.2 false))
    bits R e 40 hbits he hm hR G
  have hr := riesgo_monotono R e 40 G.card g ((vistas H (arbol p) n).card + 2) (B + 2)
    (Nexus.Verificador.PoliticasTrabajo.cardinal e g _ defecto k) (Nat.add_le_add_right hB 2)
  refine le_trans ?_ (h.trans (mul_le_mul_of_nonneg_left hr (by positivity)))
  apply promedio_monotono
  intro G'
  dsimp only [Evento, t, k, G, vistas, prefijo]
  split_ifs <;> norm_num

theorem cota_union (p : ProgramaBytes.Programa A) (defecto : Digest) (N bits R e g B K : ℕ)
    (hbits : bits = 12 ∨ bits = 20) (he : e ≤ 64) (hm : 40 ≤ 2 ^ e) (hR : 40 ≤ R)
    (hB : ∀ H : universo p → Digest, (ProgramaBytes.entradas (oraculo p defecto H) p).toFinset.card ≤ B)
    (hK : ∀ H : universo p → Digest, (ParTrabajo.claves (ProgramaBytes.entradas (oraculo p defecto H) p)).card ≤ K) :
    promedio (fun H : universo p → Digest => if ∃ n : Fin N,
      Activa p defecto (prefijo (arbol p) n.val H) ∧
        Evento p defecto bits R e g (prefijo (arbol p) n.val H) H then (1 : ℚ) else 0) ≤
      ((1 / (2 : ℚ) ^ bits) * SelectorPrimeras.riesgo R e 40 g (B + 2)) * K := by
  apply cota_por_presupuesto
    (fun (n : Fin N) H => Activa p defecto (prefijo (arbol p) n.val H))
    (fun (n : Fin N) H => Evento p defecto bits R e g (prefijo (arbol p) n.val H) H)
    ((1 / (2 : ℚ) ^ bits) * SelectorPrimeras.riesgo R e 40 g (B + 2)) K
    (mul_nonneg (by positivity) (SelectorPrimeras.riesgo_no_negativo _ _ _ _ _))
  · intro H
    have hc := PrimerosPares.carga_claves (oraculo p defecto H) p defecto N
    have hsub : (Finset.univ.filter (fun n : Fin N => Activa p defecto (prefijo (arbol p) n.val H))) ⊆
        Finset.univ.filter (fun n : Fin N => PrimerosPares.Inicia (oraculo p defecto H) p defecto n.val) := by
      intro n hn
      refine Finset.mem_filter.mpr ⟨Finset.mem_univ _, ?_⟩
      have hn' := (Finset.mem_filter.mp hn).2.1
      rw [prefijo_bytes p defecto n.val H] at hn'
      simpa only [historia] using hn'
    exact (Finset.card_le_card hsub).trans (hc.trans (hK H))
  · intro n
    apply cota_activada_constante
    intro H ha
    apply cota_condicionada p defecto H n.val bits R e g B hbits he hm hR ha
    rw [cardinal_vistas p defecto n.val H]
    apply le_trans (Finset.card_le_card ?_) (hB H)
    intro q hq
    exact List.mem_toFinset.mpr (List.mem_of_mem_take
      (by simpa only [historia, ProgramaBytes.entradas, List.map_take, List.mem_toFinset] using hq))

end Nexus.Canal.TrabajoPrefijo
