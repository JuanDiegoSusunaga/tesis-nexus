module

public import Nexus.Cripto.RotacionFirmada
import Mathlib.Tactic

/-!
# Cadenas de rotaciones autorizadas

La ejecución de una lista exige las dos firmas en cada transición. Se
derivan épocas estrictas, conservación de identidades y del prefijo del
historial, y rechazo de repetir cualquier propuesta ya aplicada.
No modela custodia, retiro durable ni instrucciones Rust.
-/

public section
namespace Nexus.Cripto.Epocas.Firmada.Ciclos

variable {I K S : Type}

@[expose] noncomputable def ejecutar (verify : K → Mensaje I K → S → Bool)
    (s : Estado I K) : List (Propuesta I K S) → Option (Estado I K)
  | [] => some s
  | p :: ps => (instalarFirmada verify s p).bind (fun t => ejecutar verify t ps)

inductive Cadena (verify : K → Mensaje I K → S → Bool) :
    Estado I K → List (Propuesta I K S) → Estado I K → Prop where
  | vacia (s) : Cadena verify s [] s
  | paso {s u t p ps} : instalarFirmada verify s p = some u →
      Cadena verify u ps t → Cadena verify s (p :: ps) t

theorem cadena_de_ejecucion (verify : K → Mensaje I K → S → Bool)
    (ps : List (Propuesta I K S)) (s t : Estado I K) :
    ejecutar verify s ps = some t ↔ Cadena verify s ps t := by
  induction ps generalizing s with
  | nil =>
    constructor
    · intro h
      have he : s = t := Option.some.inj h
      subst t
      exact .vacia s
    · intro h
      cases h
      rfl
  | cons p ps ih =>
    constructor
    · intro h
      cases he : instalarFirmada verify s p with
      | none => simp [ejecutar, he] at h
      | some u =>
        have ht : ejecutar verify u ps = some t := by simpa [ejecutar, he] using h
        exact .paso he ((ih u).mp ht)
    · intro h
      cases h with
      | paso he hc => simpa [ejecutar, he] using (ih _).mpr hc

theorem ejecutar_append (verify : K → Mensaje I K → S → Bool)
    (ps qs : List (Propuesta I K S)) (s : Estado I K) :
    ejecutar verify s (ps ++ qs) = (ejecutar verify s ps).bind (fun t => ejecutar verify t qs) := by
  induction ps generalizing s with
  | nil => rfl
  | cons p ps ih =>
    simp only [List.cons_append, ejecutar]
    cases he : instalarFirmada verify s p <;> simp only [Option.bind_none, Option.bind_some]
    exact ih _

theorem fallo_persistente (verify : K → Mensaje I K → S → Bool)
    (ps qs : List (Propuesta I K S)) (s : Estado I K) (h : ejecutar verify s ps = none) :
    ejecutar verify s (ps ++ qs) = none := by rw [ejecutar_append, h]; rfl

theorem epoca_por_longitud {verify : K → Mensaje I K → S → Bool}
    {s t : Estado I K} {ps : List (Propuesta I K S)} (h : Cadena verify s ps t) :
    t.epoca = s.epoca + ps.length := by
  induction h with
  | vacia => simp
  | paso he _ ih =>
    have hp := (instalacion_epoca_exacta _ _ _ _ he).2
    simp only [List.length_cons]
    omega

theorem historial_por_longitud {verify : K → Mensaje I K → S → Bool}
    {s t : Estado I K} {ps : List (Propuesta I K S)} (h : Cadena verify s ps t) :
    t.historial.length = s.historial.length + ps.length := by
  induction h with
  | vacia => simp
  | paso he _ ih =>
    have hp := (instalacion_historial _ _ _ _ he).1
    have hl := congrArg List.length hp
    simp only [List.length_append, List.length_cons, List.length_nil] at hl ⊢
    omega

theorem historial_extendido {verify : K → Mensaje I K → S → Bool}
    {s t : Estado I K} {ps : List (Propuesta I K S)} (h : Cadena verify s ps t) :
    ∃ resto, t.historial = s.historial ++ resto := by
  induction h with
  | vacia s => exact ⟨[], (List.append_nil _).symm⟩
  | @paso s u t p ps he _ ih =>
    obtain ⟨resto, hr⟩ := ih
    exact ⟨p.epoca :: resto, by rw [hr, (instalacion_historial _ _ _ _ he).1]; simp only [List.append_assoc, List.singleton_append]⟩

theorem checkpoint_conservado {verify : K → Mensaje I K → S → Bool}
    {s t : Estado I K} {ps : List (Propuesta I K S)} (h : Cadena verify s ps t) :
    PrefijoConfiable s.historial t.historial := by
  obtain ⟨resto, hr⟩ := historial_extendido h
  rw [hr]
  exact prefijo_compatible_con_extension _ _

theorem predeterminada_conservada {verify : K → Mensaje I K → S → Bool}
    {s t : Estado I K} {ps : List (Propuesta I K S)} (h : Cadena verify s ps t) :
    t.predeterminada = s.predeterminada := by
  induction h with
  | vacia => rfl
  | paso he _ ih => exact ih.trans (instalacion_historial _ _ _ _ he).2

theorem identidades_conservadas {verify : K → Mensaje I K → S → Bool}
    {s t : Estado I K} {ps : List (Propuesta I K S)} (h : Cadena verify s ps t) (i : I) :
    (∃ k, t.claves i = some k) ↔ ∃ k, s.claves i = some k := by
  induction h with
  | vacia => rfl
  | paso he _ ih => exact ih.trans (identidades_preservadas _ _ _ _ he i)

theorem rango_epocas {verify : K → Mensaje I K → S → Bool}
    {s t : Estado I K} {ps : List (Propuesta I K S)} (h : Cadena verify s ps t)
    (p : Propuesta I K S) (hp : p ∈ ps) : s.epoca < p.epoca ∧ p.epoca ≤ t.epoca := by
  induction h with
  | vacia => simp at hp
  | paso he hc ih =>
    rcases List.mem_cons.mp hp with hfirst | hrest
    · subst p
      have hstep := instalacion_epoca_exacta _ _ _ _ he
      have htail := epoca_por_longitud hc
      omega
    · have h := ih hrest
      have hstep := (instalacion_epoca_exacta _ _ _ _ he).2
      omega

theorem epocas_sin_duplicados {verify : K → Mensaje I K → S → Bool}
    {s t : Estado I K} {ps : List (Propuesta I K S)} (h : Cadena verify s ps t) :
    (ps.map Propuesta.epoca).Nodup := by
  induction h with
  | vacia => simp
  | paso he hc ih =>
    rw [List.map_cons, List.nodup_cons]
    refine ⟨?_, ih⟩
    intro hm
    obtain ⟨p, hp, heq⟩ := List.mem_map.mp hm
    have hr := (rango_epocas hc p hp).1
    have hs := (instalacion_epoca_exacta _ _ _ _ he).1
    omega

theorem repetir_propuesta_antigua_rechaza {verify : K → Mensaje I K → S → Bool}
    {s t : Estado I K} {ps : List (Propuesta I K S)} (h : Cadena verify s ps t)
    (p : Propuesta I K S) (hp : p ∈ ps) : instalarFirmada verify t p = none := by
  classical
  have he := (rango_epocas h p hp).2
  have hn : ¬ Valida verify t p := fun hv => by have hh := hv.1; omega
  simp only [instalarFirmada, hn, ite_false]

theorem epoca_anterior_no_vigente {verify : K → Mensaje I K → S → Bool}
    {s t : Estado I K} {ps : List (Propuesta I K S)} (h : Cadena verify s ps t)
    (hn : ps ≠ []) (i : I) (pk : K) : ¬ Vigente t i s.epoca pk := by
  intro hv
  have he := epoca_por_longitud h
  have hl : 0 < ps.length := List.length_pos_iff.mpr hn
  have hh := hv.1
  omega

end Nexus.Cripto.Epocas.Firmada.Ciclos
