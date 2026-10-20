module

public import Nexus.Canal.PrefijoTrabajo
import Mathlib.Tactic

/-!
# Una clave para las dos consultas de un intento de trabajo

Trabajo y absorción de nonce son entradas distintas del mismo candidato
(estado, nonce). Se reconoce esa pareja desde los bytes de la consulta,
sin consultar ninguna respuesta ni suponer inyectividad del hash.
-/

public section
namespace Nexus.Canal.ParTrabajo

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM GramaticaTG2

abbrev Clave := Digest × Nonce

set_option maxRecDepth 4096
set_option maxHeartbeats 800000
attribute [local instance] Classical.propDecidable

noncomputable instance decidableEqClave : DecidableEq Clave := Classical.decEq _

theorem nonce_inyectivo {s t : Digest} {n m : Nonce}
    (h : entrada s (.nonce n) = entrada t (.nonce m)) : s = t ∧ n = m := by
  obtain ⟨hs, _, hn⟩ := absorcion_determina_datos h
  have hnb : n.val < 256 ^ 8 := by have h := n.isLt; norm_num at h ⊢; exact h
  have hmb : m.val < 256 ^ 8 := by have h := m.isLt; norm_num at h ⊢; exact h
  exact ⟨hs, Fin.ext (codificar_le_inyectiva 8 hnb hmb hn)⟩

theorem consulta_inyectiva {b c : Bool} {s t : Digest} {n m : Nonce}
    (h : PrefijoTrabajo.consulta b s n = PrefijoTrabajo.consulta c t m) :
    b = c ∧ s = t ∧ n = m := by
  have hl := congrArg List.length h
  rw [PrefijoTrabajo.longitud_consulta, PrefijoTrabajo.longitud_consulta] at hl
  cases b <;> cases c
  · exact ⟨rfl, nonce_inyectivo h⟩
  · contradiction
  · contradiction
  · exact ⟨rfl, trabajo_inyectivo h⟩

@[expose] def Representa (e : Entrada) (k : Clave) : Prop :=
  ∃ b : Bool, PrefijoTrabajo.consulta b k.1 k.2 = e

@[expose] noncomputable def leer (e : Entrada) : Option Clave :=
  @dite (Option Clave) (∃ k, Representa e k) (Classical.propDecidable _)
    (fun h => some (Classical.choose h)) (fun _ => none)

theorem representacion_unica {e : Entrada} {a b : Clave}
    (ha : Representa e a) (hb : Representa e b) : a = b := by
  obtain ⟨x, hx⟩ := ha
  obtain ⟨y, hy⟩ := hb
  have h := consulta_inyectiva (hx.trans hy.symm)
  exact Prod.ext h.2.1 h.2.2

theorem leer_iff (e : Entrada) (k : Clave) : leer e = some k ↔ Representa e k := by
  unfold leer
  split_ifs with h
  · constructor
    · intro he
      exact Option.some.inj he ▸ Classical.choose_spec h
    · intro hk
      exact congrArg some (representacion_unica (Classical.choose_spec h) hk)
  · simp only [false_iff]
    exact fun hk => h ⟨k, hk⟩

theorem leer_consulta (b : Bool) (s : Digest) (n : Nonce) :
    leer (PrefijoTrabajo.consulta b s n) = some (s, n) :=
  (leer_iff _ _).mpr ⟨b, rfl⟩

theorem leer_fuera (e : Entrada) (h41 : e.length ≠ 41) (h49 : e.length ≠ 49) : leer e = none := by
  cases he : leer e with
  | none => rfl
  | some k =>
    obtain ⟨b, hb⟩ := (leer_iff e k).mp he
    have hl := congrArg List.length hb
    rw [PrefijoTrabajo.longitud_consulta] at hl
    cases b <;> simp_all

@[expose] def peticion : Peticion → Option Clave
  | .trabajo s n => some (s, n)
  | .absorber s (.nonce n) => some (s, n)
  | _ => none

theorem leer_codificar (p : Peticion) : leer (codificar p) = peticion p := by
  cases p with
  | trabajo s n => exact leer_consulta true s n
  | absorber s a => cases a with
    | nonce n => exact leer_consulta false s n
    | _ =>
      simp only [peticion]
      apply leer_fuera <;> simp [codificar, entrada, absorcion_longitud, datos,
        bytes_fp2_longitud, longitud_datos]
  | inicio => exact leer_fuera (codificar .inicio) (by decide) (by decide)
  | extension s =>
    exact leer_fuera (codificar (.extension s))
      (by simp [codificar, reto_longitud]) (by simp [codificar, reto_longitud])
  | indice s =>
    exact leer_fuera (codificar (.indice s))
      (by simp [codificar, reto_longitud]) (by simp [codificar, reto_longitud])
  | hoja v =>
    exact leer_fuera (codificar (.hoja v))
      (by simp [codificar, hoja_codificada_longitud]) (by simp [codificar, hoja_codificada_longitud])
  | nodo l r =>
    exact leer_fuera (codificar (.nodo l r))
      (by simp [codificar, nodo_codificado_longitud]) (by simp [codificar, nodo_codificado_longitud])

@[expose] noncomputable def claves (es : List Entrada) : Finset Clave := (es.filterMap leer).toFinset

@[simp] theorem claves_nil : claves [] = ∅ := rfl

theorem mem_claves (es : List Entrada) (k : Clave) : k ∈ claves es ↔ ∃ e ∈ es, leer e = some k := by
  exact List.mem_toFinset.trans List.mem_filterMap

@[simp] theorem claves_append (es fs : List Entrada) : claves (es ++ fs) = claves es ∪ claves fs := by
  exact (congrArg List.toFinset (List.filterMap_append (f := leer) (l := es) (l' := fs))).trans
    List.toFinset_append

theorem claves_cons_none (e : Entrada) (es : List Entrada) (he : leer e = none) :
    claves (e :: es) = claves es := by
  exact congrArg List.toFinset (List.filterMap_cons_none he)

theorem claves_cons_some (e : Entrada) (es : List Entrada) (k : Clave) (he : leer e = some k) :
    claves (e :: es) = insert k (claves es) := by
  exact (congrArg List.toFinset (List.filterMap_cons_some he)).trans List.toFinset_cons

theorem cardinal_le_longitud (es : List Entrada) : (claves es).card ≤ es.length :=
  (List.toFinset_card_le _).trans (List.length_filterMap_le _ _)

theorem claves_monotonas (es fs : List Entrada) (h : ∀ e ∈ es, e ∈ fs) : claves es ⊆ claves fs := by
  intro k hk
  obtain ⟨e, he, hr⟩ := (mem_claves es k).mp hk
  exact (mem_claves fs k).mpr ⟨e, h e he, hr⟩

end Nexus.Canal.ParTrabajo
