module

public import Nexus.ROM.LeyArbol
import Mathlib.Tactic

/-!
# Probabilidad conjunta de prefijos adaptativos efectivos

El evento es la igualdad de prefijos de transcripciones ejecutadas. Se cuenta
su masa en el mismo universo finito de tablas y se identifica con un cilindro.
Las repeticiones no imponen una restricción adicional. La respuesta siguiente
es uniforme solo al condicionar a ese pasado y si su dirección es nueva.
-/

public section
namespace Nexus.ROM.PrefijosGlobales

open Nexus.N06 LeyArbol FrescuraFinita

variable {Q A R : Type}

theorem traza_responde (H : Q → A) (p : Arbol Q A R) (q : Q) (a : A)
    (hm : (q, a) ∈ traza H p) : H q = a := by
  induction p with
  | terminar => contradiction
  | consultar e k ih =>
    rcases List.mem_cons.mp hm with h | h
    · exact (congrArg H (Prod.mk.inj h).1).trans (Prod.mk.inj h).2.symm
    · exact ih _ h

theorem prefijo_por_acuerdo (H G : Q → A) (p : Arbol Q A R) (n : ℕ)
    (ha : ∀ q ∈ ((traza H p).take n).map Prod.fst, G q = H q) :
    (traza G p).take n = (traza H p).take n := by
  induction p generalizing n with
  | terminar => rfl
  | consultar q k ih =>
    cases n with
    | zero => rfl
    | succ n =>
      have hq : G q = H q := ha q (by simp only [traza, List.take_succ_cons, List.map_cons, List.mem_cons_self])
      simp only [traza, hq, List.take_succ_cons]
      apply congrArg (List.cons _)
      apply ih (H q) n
      intro e he
      exact ha e (List.mem_cons_of_mem _ he)

theorem acuerdo_por_prefijo (H G : Q → A) (p : Arbol Q A R) (n : ℕ)
    (he : (traza G p).take n = (traza H p).take n) :
    ∀ q ∈ ((traza H p).take n).map Prod.fst, G q = H q := by
  intro q hq
  obtain ⟨⟨e, a⟩, hm, heq⟩ := List.mem_map.mp hq
  change e = q at heq
  subst e
  have hg : (q, a) ∈ (traza G p).take n := he.symm ▸ hm
  exact (traza_responde G p q a (List.mem_of_mem_take hg)).trans
    (traza_responde H p q a (List.mem_of_mem_take hm)).symm

variable [DecidableEq Q]

@[expose] def vistas (H : Q → A) (p : Arbol Q A R) (n : ℕ) : Finset Q :=
  (((traza H p).take n).map Prod.fst).toFinset

theorem prefijo_es_cilindro (H G : Q → A) (p : Arbol Q A R) (n : ℕ) :
    (traza G p).take n = (traza H p).take n ↔ ∀ q ∈ vistas H p n, G q = H q := by
  constructor
  · intro he q hq
    exact acuerdo_por_prefijo H G p n he q (List.mem_toFinset.mp hq)
  · intro ha
    exact prefijo_por_acuerdo H G p n (fun q hq => ha q (List.mem_toFinset.mpr hq))

abbrev Tablas (H : Q → A) (p : Arbol Q A R) (n : ℕ) :=
  {G : Q → A // (traza G p).take n = (traza H p).take n}

abbrev Respuesta (H : Q → A) (p : Arbol Q A R) (n : ℕ) (q : Q) (a : A) :=
  {G : Tablas H p n // G.val q = a}

variable [Fintype Q] [Fintype A]

noncomputable instance (H : Q → A) (p : Arbol Q A R) (n : ℕ) : Fintype (Tablas H p n) := Fintype.ofFinite _
noncomputable instance (H : Q → A) (p : Arbol Q A R) (n : ℕ) (q : Q) (a : A) :
    Fintype (Respuesta H p n q a) := Fintype.ofFinite _

@[expose] def equivalencia (H : Q → A) (p : Arbol Q A R) (n : ℕ) :
    Tablas H p n ≃ Completaciones (vistas H p n) H where
  toFun G := ⟨G.val, (prefijo_es_cilindro H G.val p n).mp G.property⟩
  invFun G := ⟨G.val, (prefijo_es_cilindro H G.val p n).mpr G.property⟩
  left_inv _ := rfl
  right_inv _ := rfl

@[expose] def equivalenciaRespuesta (H : Q → A) (p : Arbol Q A R) (n : ℕ) (q : Q) (a : A) :
    Respuesta H p n q a ≃ Fibra (vistas H p n) H q a where
  toFun G := ⟨equivalencia H p n G.val, G.property⟩
  invFun G := ⟨(equivalencia H p n).symm G.val, G.property⟩
  left_inv _ := rfl
  right_inv _ := rfl

theorem cardinal_prefijo (H : Q → A) (p : Arbol Q A R) (n : ℕ) :
    Fintype.card (Tablas H p n) = Fintype.card A ^ (Fintype.card Q - (vistas H p n).card) := by
  rw [Fintype.card_congr (equivalencia H p n), cardinal_completaciones]

theorem probabilidad_prefijo [Nonempty A] (H : Q → A) (p : Arbol Q A R) (n : ℕ) :
    (Fintype.card (Tablas H p n) : ℚ) / Fintype.card (Q → A) =
      1 / (Fintype.card A : ℚ) ^ (vistas H p n).card := by
  have hc : (vistas H p n).card ≤ Fintype.card Q :=
    (Finset.card_le_card (Finset.subset_univ _)).trans_eq (Finset.card_univ)
  have hp : (Fintype.card A : ℚ) ^ Fintype.card Q =
      (Fintype.card A : ℚ) ^ (Fintype.card Q - (vistas H p n).card) *
        (Fintype.card A : ℚ) ^ (vistas H p n).card := by
    rw [← pow_add, Nat.sub_add_cancel hc]
  rw [cardinal_prefijo, Fintype.card_fun, Nat.cast_pow, Nat.cast_pow, hp]
  have hn : (Fintype.card A : ℚ) ≠ 0 := by exact_mod_cast Fintype.card_ne_zero
  field_simp

theorem siguiente_uniforme [Nonempty A] (H : Q → A) (p : Arbol Q A R) (n : ℕ)
    (q : Q) (a : A) (hq : q ∉ vistas H p n) :
    (Fintype.card (Respuesta H p n q a) : ℚ) / Fintype.card (Tablas H p n) =
      1 / (Fintype.card A : ℚ) := by
  rw [Fintype.card_congr (equivalenciaRespuesta H p n q a), Fintype.card_congr (equivalencia H p n)]
  exact respuesta_nueva_uniforme _ _ _ _ hq

omit [Fintype Q] [Fintype A] in
theorem repetida_fija (H : Q → A) (p : Arbol Q A R) (n : ℕ) (q : Q)
    (hq : q ∈ vistas H p n) (G : Tablas H p n) : G.val q = H q :=
  (prefijo_es_cilindro H G.val p n).mp G.property q hq

theorem repetida_distinta_imposible (H : Q → A) (p : Arbol Q A R) (n : ℕ)
    (q : Q) (a : A) (hq : q ∈ vistas H p n) (ha : a ≠ H q) :
    Fintype.card (Respuesta H p n q a) = 0 := by
  rw [Fintype.card_congr (equivalenciaRespuesta H p n q a)]
  exact respuesta_repetida_distinta_imposible _ _ _ _ hq ha

end Nexus.ROM.PrefijosGlobales
