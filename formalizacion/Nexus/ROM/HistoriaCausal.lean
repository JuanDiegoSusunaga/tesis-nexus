module

public import Nexus.ROM.FrescuraFinita
import Mathlib.Tactic

/-!
# Condicionar a una historia causal fija conserva la ley fresca

La estrategia elige la consulta usando solo respuestas anteriores.
Para cada historia admisible, las tablas compatibles son exactamente las
completaciones de sus consultas observadas. No se condiciona a eventos
futuros, y se distingue una consulta fresca de una repetición.
-/

public section
namespace Nexus.ROM.HistoriaCausal

open FrescuraFinita
variable {Q A : Type} [Fintype Q] [Fintype A] [DecidableEq Q]

@[expose] def Compatible (estrategia : List A → Q) (rs : List A) (H : Q → A) : Prop :=
  ∀ i : Fin rs.length, H (estrategia (rs.take i.val)) = rs[i.val]

@[expose] def vistas (estrategia : List A → Q) (rs : List A) : Finset Q :=
  Finset.univ.image (fun i : Fin rs.length => estrategia (rs.take i.val))

abbrev Tablas (estrategia : List A → Q) (rs : List A) := {H : Q → A // Compatible estrategia rs H}
abbrev Respuesta (estrategia : List A → Q) (rs : List A) (q : Q) (a : A) :=
  {H : Tablas estrategia rs // H.val q = a}

noncomputable instance (e : List A → Q) (rs : List A) : Fintype (Tablas e rs) := Fintype.ofFinite _
noncomputable instance (e : List A → Q) (rs : List A) (q : Q) (a : A) :
    Fintype (Respuesta e rs q a) := Fintype.ofFinite _

omit [Fintype Q] [Fintype A] in
theorem consulta_previa_vista (e : List A → Q) (rs : List A) (i : Fin rs.length) :
    e (rs.take i.val) ∈ vistas e rs := Finset.mem_image.mpr ⟨i, Finset.mem_univ _, rfl⟩

omit [Fintype Q] [Fintype A] in
theorem acuerdo_historia (e : List A → Q) (rs : List A) (H G : Q → A)
    (hH : Compatible e rs H) (hG : Compatible e rs G) (q : Q) (hq : q ∈ vistas e rs) : H q = G q := by
  obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hq
  exact (hH i).trans (hG i).symm

omit [Fintype Q] [Fintype A] in
theorem historia_es_cilindro (e : List A → Q) (rs : List A) (G : Q → A)
    (hG : Compatible e rs G) (H : Q → A) :
    Compatible e rs H ↔ ∀ q ∈ vistas e rs, H q = G q := by
  constructor
  · intro hH q hq
    exact acuerdo_historia e rs H G hH hG q hq
  · intro h i
    exact (h _ (consulta_previa_vista e rs i)).trans (hG i)

@[expose] noncomputable def equivalenciaHistoria (e : List A → Q) (rs : List A) (G : Q → A)
    (hG : Compatible e rs G) : Tablas e rs ≃ Completaciones (vistas e rs) G where
  toFun H := ⟨H.val, (historia_es_cilindro e rs G hG H.val).mp H.property⟩
  invFun H := ⟨H.val, (historia_es_cilindro e rs G hG H.val).mpr H.property⟩
  left_inv _ := rfl
  right_inv _ := rfl

@[expose] noncomputable def equivalenciaRespuesta (e : List A → Q) (rs : List A) (G : Q → A)
    (hG : Compatible e rs G) (q : Q) (a : A) :
    Respuesta e rs q a ≃ Fibra (vistas e rs) G q a where
  toFun H := ⟨equivalenciaHistoria e rs G hG H.val, H.property⟩
  invFun H := ⟨(equivalenciaHistoria e rs G hG).symm H.val, H.property⟩
  left_inv _ := rfl
  right_inv _ := rfl

theorem cardinal_historia (e : List A → Q) (rs : List A) (G : Q → A) (hG : Compatible e rs G) :
    Fintype.card (Tablas e rs) = Fintype.card A ^ (Fintype.card Q - (vistas e rs).card) := by
  rw [Fintype.card_congr (equivalenciaHistoria e rs G hG), cardinal_completaciones]

theorem uniforme_tras_historia [Nonempty A] (e : List A → Q) (rs : List A) (G : Q → A)
    (hG : Compatible e rs G) (a : A) (hf : e rs ∉ vistas e rs) :
    (Fintype.card (Respuesta e rs (e rs) a) : ℚ) / Fintype.card (Tablas e rs) =
      1 / (Fintype.card A : ℚ) := by
  rw [Fintype.card_congr (equivalenciaRespuesta e rs G hG (e rs) a),
    Fintype.card_congr (equivalenciaHistoria e rs G hG)]
  exact respuesta_nueva_uniforme _ _ _ _ hf

theorem repetida_tras_historia (e : List A → Q) (rs : List A) (G : Q → A)
    (hG : Compatible e rs G) (a : A) (hq : e rs ∈ vistas e rs) (ha : a ≠ G (e rs)) :
    Fintype.card (Respuesta e rs (e rs) a) = 0 := by
  rw [Fintype.card_congr (equivalenciaRespuesta e rs G hG (e rs) a)]
  exact respuesta_repetida_distinta_imposible _ _ _ _ hq ha

omit [Fintype Q] [Fintype A] in
theorem consultas_distintas_acotadas (e : List A → Q) (rs : List A) :
    (vistas e rs).card ≤ rs.length := by
  exact (Finset.card_image_le).trans (by simp)

end Nexus.ROM.HistoriaCausal
