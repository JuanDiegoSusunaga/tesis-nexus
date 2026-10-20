module

public import Nexus.Merkle.Ventanas
public import Nexus.Merkle.Temporal
public import Nexus.N06.Experimento
import Mathlib.Tactic

/-!
# Ventanas globales, extracción concreta y riesgo de una respuesta fresca

Cada consulta aporta su digest y todas sus ventanas de 32 octetos si mide
a lo sumo 79. Antes de responder se marcan también las ventanas de la propia
entrada. Las raíces adicionales pueden marcarse antes de congelar el vector.
La media uniforme de un acierto se acota por cardinalidad. La unión temporal
en un oráculo con respuestas memorizadas sigue siendo una obligación separada.
-/

public section
namespace Nexus.Merkle

open Nexus.Bytes Nexus.Goldilocks Nexus.N06

@[expose] def marcasEntrada (H : List Octeto → Digest) (e : List Octeto) : Finset Digest :=
  insert (H e) (ventanas e)

@[expose] def marcasConsultas (H : List Octeto → Digest) : List (List Octeto) → Finset Digest
  | [] => ∅
  | e :: resto => marcasEntrada H e ∪ marcasConsultas H resto

@[expose] def marcas (H : List Octeto → Digest) (raices : Finset Digest)
    (registro : List (List Octeto)) : Finset Digest := raices ∪ marcasConsultas H registro

@[expose] def previas (H : List Octeto → Digest) (raices : Finset Digest)
    (registro : List (List Octeto)) (e : List Octeto) : Finset Digest :=
  marcas H raices registro ∪ ventanas e

theorem marcas_entrada_card (H : List Octeto → Digest) (e : List Octeto) :
    (marcasEntrada H e).card ≤ 49 := by
  have hi := Finset.card_insert_le (H e) (ventanas e)
  have hv := ventanas_card e
  exact hi.trans (by omega)

theorem marcas_consultas_card (H : List Octeto → Digest) (registro : List (List Octeto)) :
    (marcasConsultas H registro).card ≤ 49 * registro.length := by
  induction registro with
  | nil => simp only [marcasConsultas, Finset.card_empty, List.length_nil, Nat.mul_zero, le_refl]
  | cons e resto ih =>
    have hu := Finset.card_union_le (marcasEntrada H e) (marcasConsultas H resto)
    have he := marcas_entrada_card H e
    change (marcasEntrada H e ∪ marcasConsultas H resto).card ≤ _
    simp only [List.length_cons]
    omega

theorem marcas_card (H : List Octeto → Digest) (raices : Finset Digest) (registro : List (List Octeto)) :
    (marcas H raices registro).card ≤ 49 * registro.length + raices.card := by
  have hu := Finset.card_union_le raices (marcasConsultas H registro)
  have hc := marcas_consultas_card H registro
  exact hu.trans (by omega)

theorem previas_card (H : List Octeto → Digest) (raices : Finset Digest) (registro : List (List Octeto))
    (e : List Octeto) (S : ℕ) (hS : registro.length < S) : (previas H raices registro e).card ≤ 49 * S + raices.card := by
  have hu := Finset.card_union_le (marcas H raices registro) (ventanas e)
  have hm := marcas_card H raices registro
  have hv := ventanas_card e
  exact hu.trans (by omega)

theorem marcas_consulta (H : List Octeto → Digest) (raices : Finset Digest) (registro : List (List Octeto))
    (e : List Octeto) (he : e ∈ registro) : marcasEntrada H e ⊆ marcas H raices registro := by
  have hs : marcasEntrada H e ⊆ marcasConsultas H registro := by
    induction registro with
    | nil => simp only [List.not_mem_nil] at he
    | cons a resto ih =>
      rcases List.mem_cons.mp he with rfl | he
      · exact Finset.subset_union_left
      · exact (ih he).trans Finset.subset_union_right
  exact hs.trans Finset.subset_union_right

theorem marcas_consultas_append (H : List Octeto → Digest) (antes despues : List (List Octeto)) :
    marcasConsultas H (antes ++ despues) = marcasConsultas H antes ∪ marcasConsultas H despues := by
  induction antes with
  | nil => simp only [List.nil_append, marcasConsultas, Finset.empty_union]
  | cons e resto ih => simp only [List.cons_append, marcasConsultas, ih, Finset.union_assoc]

theorem raiz_absorbida_marcada (H : List Octeto → Digest) (raices : Finset Digest)
    (registro : List (List Octeto)) (estado : Digest) (tag : Octeto) (raiz : Digest)
    (he : absorberRaiz estado tag raiz ∈ registro) : raiz ∈ marcas H raices registro :=
  marcas_consulta H raices registro _ he
    (Finset.mem_insert_of_mem (raiz_absorbida_en_ventanas estado tag raiz))

theorem marcas_append_mono (H : List Octeto → Digest) (raices : Finset Digest)
    (antes despues : List (List Octeto)) : marcas H raices antes ⊆ marcas H raices (antes ++ despues) := by
  intro d hd
  simp only [marcas, marcas_consultas_append, Finset.mem_union] at hd ⊢
  tauto

theorem etiquetas_bytes_entrada_cubiertas (H : List Octeto → Digest) (bs : List Octeto) :
    etiquetasEntrada formatoBytes H bs ⊆ marcasEntrada H bs := by
  intro d hd
  simp only [etiquetasEntrada, formatoBytes] at hd
  change d ∈ insert (H bs) (ventanas bs)
  rcases Finset.mem_insert.mp hd with rfl | hd
  · exact Finset.mem_insert_self _ _
  · apply Finset.mem_insert_of_mem
    cases hp : decodificarMerkle bs with
    | none => simp only [hp, Finset.notMem_empty] at hd
    | some c =>
      cases c with
      | hoja v => simp only [hp, Finset.notMem_empty] at hd
      | nodo l r =>
        have hv := hijos_decodificados_en_ventanas bs l r hp
        simp only [hp, Finset.mem_insert, Finset.mem_singleton] at hd
        rcases hd with rfl | rfl
        · exact hv.1
        · exact hv.2

theorem etiquetas_bytes_cubiertas (H : List Octeto → Digest) (raices : Finset Digest)
    (registro : List (List Octeto)) (raiz : Digest) (hr : raiz ∈ marcas H raices registro) :
    etiquetas formatoBytes H raiz registro ⊆ marcas H raices registro := by
  let s := marcas H raices registro
  have aux : ∀ xs : List (List Octeto), (∀ e ∈ xs, etiquetasEntrada formatoBytes H e ⊆ s) →
      etiquetas formatoBytes H raiz xs ⊆ s := by
    intro xs
    induction xs with
    | nil => intro _; exact Finset.singleton_subset_iff.mpr hr
    | cons e resto ih =>
      intro h
      exact Finset.union_subset (h e List.mem_cons_self)
        (ih (fun x hx => h x (List.mem_cons_of_mem e hx)))
  apply aux registro
  intro e he
  exact (etiquetas_bytes_entrada_cubiertas H e).trans (marcas_consulta H raices registro e he)

/-- El acierto se evalúa contra las marcas previas y las ventanas de la entrada actual. -/
inductive ExtensionSinBad (H : List Octeto → Digest) (raices : Finset Digest) :
    List (List Octeto) → List (List Octeto) → Prop
  | refl (registro : List (List Octeto)) : ExtensionSinBad H raices registro registro
  | paso {antes actual : List (List Octeto)} (previa : ExtensionSinBad H raices antes actual)
      (e : List Octeto) (sinAcierto : H e ∉ previas H raices actual e) :
      ExtensionSinBad H raices antes (actual ++ [e])

theorem extension_marcas_persisten (H : List Octeto → Digest) (raices : Finset Digest)
    (antes despues : List (List Octeto)) (ext : ExtensionSinBad H raices antes despues) :
    marcas H raices antes ⊆ marcas H raices despues := by
  induction ext with
  | refl => exact Finset.Subset.refl _
  | @paso actual previa e hn ih => exact ih.trans (marcas_append_mono H raices actual [e])

theorem extension_sinbad_es_segura (H : List Octeto → Digest) (raices : Finset Digest)
    (antes despues : List (List Octeto)) (ext : ExtensionSinBad H raices antes despues)
    (raiz : Digest) (hr : raiz ∈ marcas H raices antes) : ExtensionSegura formatoBytes H raiz antes despues := by
  induction ext with
  | refl => exact .refl _
  | @paso actual previa e hn ih =>
    apply ExtensionSegura.paso ih e
    intro hd
    have hm := etiquetas_bytes_cubiertas H raices actual raiz
      (extension_marcas_persisten H raices antes actual previa hr) hd
    exact hn (Finset.mem_union_left _ hm)

theorem apertura_bytes_congelada (H : List Octeto → Digest) (raices : Finset Digest)
    (antes despues : List (List Octeto)) (ext : ExtensionSinBad H raices antes despues)
    (raiz : Digest) (hr : raiz ∈ marcas H raices antes) (hc : SinColisiones H antes)
    (altura : ℕ) (v : Fp2) (hermanos : List (Bool × Digest))
    (ha : Acepta formatoBytes H raiz altura v hermanos)
    (hq : AperturaRegistrada formatoBytes H despues v hermanos) :
    extraer formatoBytes H antes (hermanos.map Prod.fst) raiz = v :=
  apertura_posterior_coincide_congelada formatoBytes H raiz altura antes despues
    (extension_sinbad_es_segura H raices antes despues ext raiz hr) hc v hermanos hq ha

theorem apertura_raiz_absorbida (H : List Octeto → Digest) (raices : Finset Digest)
    (antes despues : List (List Octeto)) (ext : ExtensionSinBad H raices antes despues)
    (estado raiz : Digest) (tag : Octeto) (hr : absorberRaiz estado tag raiz ∈ antes)
    (hc : SinColisiones H antes) (altura : ℕ) (v : Fp2) (hermanos : List (Bool × Digest))
    (ha : Acepta formatoBytes H raiz altura v hermanos)
    (hq : AperturaRegistrada formatoBytes H despues v hermanos) :
    extraer formatoBytes H antes (hermanos.map Prod.fst) raiz = v :=
  apertura_bytes_congelada H raices antes despues ext raiz
    (raiz_absorbida_marcada H raices antes estado tag raiz hr) hc altura v hermanos ha hq

theorem probabilidad_acierto_nuevo (H : List Octeto → Digest) (raices : Finset Digest)
    (registro : List (List Octeto)) (e : List Octeto) (S : ℕ) (hS : registro.length < S) :
    promedio (fun d : Digest => if d ∈ previas H raices registro e then 1 else 0) ≤
      ((49 * S + raices.card : ℕ) : ℚ) / 2 ^ 256 := by
  classical
  rw [promedio_indicador, digest_cardinal]
  simp only [Nat.cast_pow, Nat.cast_ofNat]
  apply div_le_div_of_nonneg_right _ (by positivity)
  exact_mod_cast previas_card H raices registro e S hS

end Nexus.Merkle
