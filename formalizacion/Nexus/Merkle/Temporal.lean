module

public import Nexus.Merkle.Etiquetas
import Mathlib.Tactic

/-!
# Extracción congelada antes de las consultas posteriores

Una extensión segura añade consultas cuyas salidas no aciertan contra las
etiquetas ya marcadas, incluida la raíz comprometida. Se deducen frescura,
ausencia de colisiones y estabilidad del vector extraído. La condición es
determinista; su probabilidad en el único oráculo ROM queda por demostrar.
-/

public section
namespace Nexus.Merkle

variable {V D E : Type*} [DecidableEq D]

theorem sin_colisiones_anexar (f : Formato V D E) (H : E → D) (raiz : D)
    (registro : List E) (e : E) (hc : SinColisiones H registro)
    (hn : H e ∉ etiquetas f H raiz registro) : SinColisiones H (registro ++ [e]) := by
  have hd : ∀ x ∈ registro, H x ≠ H e := by
    intro x hx heq
    exact hn (heq ▸ salida_etiquetada f H raiz registro x hx)
  intro x hx y hy heq
  simp only [List.mem_append, List.mem_singleton] at hx hy
  rcases hx with hx | rfl <;> rcases hy with hy | rfl
  · exact hc x hx y hy heq
  · exact False.elim (hd x hx heq)
  · exact False.elim (hd y hy heq.symm)
  · rfl

theorem preimagen_append_etiquetada (f : Formato V D E) (H : E → D) (raiz : D)
    (antes despues : List E) (hn : ∀ e ∈ despues, H e ∉ etiquetas f H raiz antes)
    (r : D) (hr : r ∈ etiquetas f H raiz antes) :
    preimagen H (antes ++ despues) r = preimagen H antes r := by
  apply preimagen_append_sin_acierto
  intro e he heq
  exact hn e he (heq.symm ▸ hr)

theorem extraer_append_etiquetada [Zero V] (f : Formato V D E) (H : E → D) (raiz : D)
    (antes despues : List E) (hn : ∀ e ∈ despues, H e ∉ etiquetas f H raiz antes)
    (ruta : List Bool) (r : D) (hr : r ∈ etiquetas f H raiz antes) :
    extraer f H antes ruta r = extraer f H (antes ++ despues) ruta r := by
  induction ruta generalizing r with
  | nil =>
    simp only [extraer, leerRegistro, preimagen_append_etiquetada f H raiz antes despues hn r hr]
  | cons b ruta ih =>
    simp only [extraer, leerRegistro, preimagen_append_etiquetada f H raiz antes despues hn r hr]
    cases hp : preimagen H antes r with
    | none => rfl
    | some e =>
      have he := (preimagen_some_mem H antes r e hp).1
      simp only [Option.bind_some]
      cases hd : f.leer e with
      | none => rfl
      | some c =>
        cases c with
        | hoja v => rfl
        | nodo l d =>
          have hm := hijos_etiquetados f H raiz antes e he l d hd
          apply ih
          cases b with
          | false => exact hm.1
          | true => exact hm.2

/-- Solo se añaden consultas nuevas que evitan las etiquetas existentes. -/
inductive ExtensionSegura (f : Formato V D E) (H : E → D) (raiz : D) : List E → List E → Prop
  | refl (registro : List E) : ExtensionSegura f H raiz registro registro
  | paso {antes actual : List E} (previa : ExtensionSegura f H raiz antes actual) (e : E)
      (sinAcierto : H e ∉ etiquetas f H raiz actual) :
      ExtensionSegura f H raiz antes (actual ++ [e])

theorem extension_segura_sin_colisiones (f : Formato V D E) (H : E → D) (raiz : D)
    (antes despues : List E) (ext : ExtensionSegura f H raiz antes despues)
    (hc : SinColisiones H antes) : SinColisiones H despues := by
  induction ext with
  | refl => exact hc
  | @paso actual previa e hn ih =>
    exact sin_colisiones_anexar f H raiz actual e ih hn

theorem extension_segura_estable [Zero V] (f : Formato V D E) (H : E → D) (raiz : D)
    (antes despues : List E) (ext : ExtensionSegura f H raiz antes despues) (ruta : List Bool) :
    extraer f H antes ruta raiz = extraer f H despues ruta raiz := by
  induction ext with
  | refl => rfl
  | @paso actual previa e hn ih =>
    apply ih.trans
    apply extraer_append_etiquetada f H raiz actual [e] _ ruta raiz (raiz_etiquetada f H raiz actual)
    intro x hx
    have hxe : x = e := List.mem_singleton.mp hx
    subst x
    exact hn

theorem apertura_posterior_coincide_congelada [Zero V] (f : Formato V D E) (H : E → D)
    (raiz : D) (altura : ℕ) (antes despues : List E) (ext : ExtensionSegura f H raiz antes despues)
    (hc : SinColisiones H antes) (v : V) (hermanos : List (Bool × D))
    (hr : AperturaRegistrada f H despues v hermanos) (ha : Acepta f H raiz altura v hermanos) :
    extraer f H antes (hermanos.map Prod.fst) raiz = v := by
  have hfinal := extension_segura_sin_colisiones f H raiz antes despues ext hc
  exact (extension_segura_estable f H raiz antes despues ext (hermanos.map Prod.fst)).trans
    (apertura_aceptada_extraida f H despues hfinal raiz altura v hermanos hr ha)

theorem vector_congelado_estable [Zero V] (f : Formato V D E) (H : E → D) (raiz : D)
    (altura : ℕ) (antes despues : List E) (ext : ExtensionSegura f H raiz antes despues) :
    vectorExtraido f H antes altura raiz = vectorExtraido f H despues altura raiz := by
  funext ruta
  exact extension_segura_estable f H raiz antes despues ext (List.ofFn ruta)

end Nexus.Merkle
