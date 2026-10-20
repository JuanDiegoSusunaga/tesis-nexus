module

public import Nexus.Cripto.Firma
import Mathlib.Tactic

public section
namespace Nexus.Cripto.Epocas

variable {I K : Type}

structure Estado (I K : Type*) where
  epoca : ℕ
  claves : I → Option K
  predeterminada : Option I
  historial : List ℕ

/-- La preparación es local; solo se instala el estado si todos los controles pasan. -/
@[expose] def instalar (s : Estado I K) (preparacion : Option (I → Option K))
    (autorizadas posesion registroValido : Bool) : Estado I K :=
  match preparacion with
  | none => s
  | some nuevas =>
      if autorizadas && posesion && registroValido then
        ⟨s.epoca + 1, nuevas, s.predeterminada, s.historial ++ [s.epoca + 1]⟩
      else s

theorem preparacion_fallida_atomica (s : Estado I K) (a p r : Bool) :
    instalar s none a p r = s := rfl

theorem autorizacion_fallida_atomica (s : Estado I K) (nuevas : I → Option K) (p r : Bool) :
    instalar s (some nuevas) false p r = s := by simp [instalar]

theorem posesion_fallida_atomica (s : Estado I K) (nuevas : I → Option K) (a r : Bool) :
    instalar s (some nuevas) a false r = s := by simp [instalar]

theorem registro_fallido_atomico (s : Estado I K) (nuevas : I → Option K) (a p : Bool) :
    instalar s (some nuevas) a p false = s := by simp [instalar]

theorem rotacion_incrementa_epoca (s : Estado I K) (nuevas : I → Option K) :
    (instalar s (some nuevas) true true true).epoca = s.epoca + 1 := rfl

theorem rotacion_preserva_predeterminada (s : Estado I K) (nuevas : I → Option K) (a p r : Bool) :
    (instalar s (some nuevas) a p r).predeterminada = s.predeterminada := by
  simp only [instalar]
  split <;> rfl

theorem rotacion_extiende_historial (s : Estado I K) (nuevas : I → Option K) :
    (instalar s (some nuevas) true true true).historial = s.historial ++ [s.epoca + 1] := rfl

@[expose] def MismasIdentidades (s : Estado I K) (nuevas : I → Option K) : Prop :=
  ∀ i, (∃ k, s.claves i = some k) ↔ ∃ k, nuevas i = some k

theorem rotacion_preserva_identidades (s : Estado I K) (nuevas : I → Option K)
    (h : MismasIdentidades s nuevas) (i : I) :
    (∃ k, (instalar s (some nuevas) true true true).claves i = some k) ↔
      ∃ k, s.claves i = some k := (h i).symm

/-- El sobre autenticado contiene identidad y época, además del mensaje. -/
abbrev Sobre (I M : Type*) := I × ℕ × M

@[expose] def Vigente (s : Estado I K) (i : I) (e : ℕ) (pk : K) : Prop :=
  e = s.epoca ∧ s.claves i = some pk

theorem epoca_retirada_no_vigente (s : Estado I K) (nuevas : I → Option K) (i : I) (pk : K) :
    ¬ Vigente (instalar s (some nuevas) true true true) i s.epoca pk := by
  intro h
  have he := h.1
  change s.epoca = s.epoca + 1 at he
  omega

@[expose] def PrefijoConfiable {E : Type*} (confiable historia : List E) : Prop :=
  historia.take confiable.length = confiable

theorem prefijo_exige_longitud {E : Type*} (c h : List E) (hc : PrefijoConfiable c h) :
    c.length ≤ h.length := by
  have hh := congrArg List.length hc
  simp only [List.length_take] at hh
  omega

theorem prefijo_compatible_con_extension {E : Type*} (c resto : List E) :
    PrefijoConfiable c (c ++ resto) := by simp [PrefijoConfiable]

theorem punto_antiguo_admite_truncacion {E : Type*} (c despues : List E) :
    PrefijoConfiable c (c ++ despues) ∧ PrefijoConfiable c c :=
  ⟨prefijo_compatible_con_extension _ _, by simp [PrefijoConfiable]⟩

theorem hash_prefijo_o_colision {E D : Type*} (H : List E → D) (c h : List E)
    (he : H (h.take c.length) = H c) :
    PrefijoConfiable c h ∨ (h.take c.length ≠ c ∧ H (h.take c.length) = H c) := by
  by_cases hc : PrefijoConfiable c h
  · exact Or.inl hc
  · exact Or.inr ⟨hc, he⟩

/-- El lote conserva el orden y las identidades; un fallo no produce una lista parcial. -/
@[expose] def prepararLista (deriva : I → Option K) : List I → Option (List (I × K))
  | [] => some []
  | i :: resto => do
      let k ← deriva i
      let r ← prepararLista deriva resto
      pure ((i, k) :: r)

theorem preparacion_conserva_identidades (deriva : I → Option K) (ids : List I) (ks : List (I × K))
    (h : prepararLista deriva ids = some ks) : ks.map Prod.fst = ids := by
  induction ids generalizing ks with
  | nil =>
    have he : [] = ks := Option.some.inj h
    subst ks
    rfl
  | cons i resto ih =>
    simp only [prepararLista] at h
    cases hd : deriva i with
    | none => simp [hd] at h
    | some k =>
      cases hr : prepararLista deriva resto with
      | none => simp [hd, hr] at h
      | some r =>
        have he : (i, k) :: r = ks := by simpa [hd, hr] using h
        subst ks
        simp only [List.map_cons, ih r hr]

theorem fallo_de_derivacion_rechaza_lote (deriva : I → Option K) (ids : List I)
    (i : I) (hi : i ∈ ids) (hd : deriva i = none) : prepararLista deriva ids = none := by
  induction ids with
  | nil => simp at hi
  | cons j resto ih =>
    rcases List.mem_cons.mp hi with he | hr
    · subst j
      simp [prepararLista, hd]
    · simp only [prepararLista]
      cases hj : deriva j <;> simp [ih hr]

end Nexus.Cripto.Epocas
