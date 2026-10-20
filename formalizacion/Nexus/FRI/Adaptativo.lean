module

public import Nexus.FRI.Presupuesto
public import Nexus.FRI.Muestreo
public import Nexus.N06.Experimento
import Mathlib.Tactic

/-!
# Excepciones FRI elegidas antes de cada reto

Una estrategia recibe la capa y la lista de retos anteriores, y elige el
oráculo actual. Los conjuntos excepcionales se construyen por el lema A
para ese oráculo, sin recibir el nuevo reto ni los oráculos futuros.
-/

public section
namespace Nexus.FRI

open scoped BigOperators
open Polynomial Nexus.N04
variable {K : Type*} [Field K] {m : ℕ}

theorem control_depende_oraculo (t : Torre K m) (u v : ℕ → K → K) (θ : ℝ)
    (j : Fin m) (E : Finset K) (hu : u j = v j) :
    Control t u θ j E ↔ Control t v θ j E := by
  simp only [Control, hu]

/-- Elección uniforme en futuros conjuntos de acuerdo, a partir del oráculo actual. -/
@[expose] noncomputable def excepciones (t : Torre K m) (θ : ℝ) (hθ : 0 ≤ θ)
    (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card) (j : Fin m) (w : K → K) : Finset K :=
  Classical.choose (control_capa t (fun _ => w) θ hθ h2 j (hmargin j))

theorem excepciones_cardinal (t : Torre K m) (θ : ℝ) (hθ : 0 ≤ θ)
    (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card) (j : Fin m) (w : K → K) :
    (excepciones t θ hθ h2 hmargin j w).card ≤ (t.dominio (j + 1)).card :=
  (Classical.choose_spec (control_capa t (fun _ => w) θ hθ h2 j (hmargin j))).1

theorem excepciones_control (t : Torre K m) (u : ℕ → K → K) (θ : ℝ) (hθ : 0 ≤ θ)
    (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card) (j : Fin m) :
    Control t u θ j (excepciones t θ hθ h2 hmargin j (u j)) := by
  have hc := (Classical.choose_spec
    (control_capa t (fun _ => u j) θ hθ h2 j (hmargin j))).2
  exact (control_depende_oraculo t (fun _ => u j) u θ j _ rfl).mp hc

/-- Recuperación desde controles ya elegidos, sin fijar la familia antes de los retos. -/
theorem recuperar_por_controles (t : Torre K m) (u : ℕ → K → K) (θ : ℝ)
    (h2 : (2 : K) ≠ 0) (E : Fin m → Finset K)
    (hcontrol : ∀ j, Control t u θ j (E j))
    (β : Fin m → K) (hβ : ∀ j, β j ∉ E j)
    (A : Finset K) (c : K) (hA : A ⊆ t.dominio 0)
    (hd : (1 - θ) * (t.dominio 0).card ≤ (A.card : ℝ))
    (hsteps : ∀ j : Fin m, ∀ y ∈ recorrido A (j + 1),
      u (j + 1) y = par (u j) (t.raiz j) y + β j * impar (u j) (t.raiz j) y)
    (hfinal : ∀ y ∈ recorrido A m, u m y = c) :
    ∃ P : Polynomial K, P.natDegree < t.grado 0 ∧ Sobre A (u 0) P := by
  have hrecover : ∀ j (hj : j ≤ m), ∃ P : Polynomial K,
      P.natDegree < t.grado j ∧ Sobre (recorrido A j) (u j) P := by
    intro j hj
    apply Nat.decreasingInduction (motive := fun j _ => ∃ P : Polynomial K,
      P.natDegree < t.grado j ∧ Sobre (recorrido A j) (u j) P) _ _ hj
    · intro i hi hnext
      obtain ⟨Q, hQ, hQS⟩ := hnext
      let index : Fin m := ⟨i, hi⟩
      apply hcontrol index (β index) (hβ index) (recorrido A i)
        (recorrido_subconjunto t A hA i (by omega))
        (densidad_recorrido t h2 A hA (1 - θ) hd (i + 1) (by omega)) Q hQ
      intro y hy
      exact (hsteps index y hy).symm.trans (hQS y hy)
    · refine ⟨C c, ?_, ?_⟩
      · rw [t.grado_final, natDegree_C]
        decide
      · intro y hy
        simpa only [eval_C] using hfinal y hy
  exact hrecover 0 (Nat.zero_le _)

/-- Se conserva solo el prefijo de retos, en su orden de emisión. -/
@[expose] def historia (β : ℕ → K) : ℕ → List K
  | 0 => []
  | j + 1 => historia β j ++ [β j]

omit [Field K] in
theorem historia_depende_prefijo (β γ : ℕ → K) (j : ℕ)
    (h : ∀ i < j, β i = γ i) : historia β j = historia γ j := by
  induction j with
  | zero => rfl
  | succ j ih => rw [historia, historia, ih (by intro i hi; exact h i (by omega)), h j (by omega)]

/-- Los oráculos pueden depender de cualquier prefijo, pero no del reto actual. -/
theorem recuperacion_adaptativa (t : Torre K m)
    (estrategia : ℕ → List K → K → K) (β : ℕ → K)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (hβ : ∀ j : Fin m, β j ∉ excepciones t θ hθ h2 hmargin j
      (estrategia j (historia β j)))
    (A : Finset K) (c : K) (hA : A ⊆ t.dominio 0)
    (hd : (1 - θ) * (t.dominio 0).card ≤ (A.card : ℝ))
    (hsteps : ∀ j : Fin m, ∀ y ∈ recorrido A (j + 1),
      estrategia (j + 1) (historia β (j + 1)) y =
        par (estrategia j (historia β j)) (t.raiz j) y +
          β j * impar (estrategia j (historia β j)) (t.raiz j) y)
    (hfinal : ∀ y ∈ recorrido A m, estrategia m (historia β m) y = c) :
    ∃ P : Polynomial K, P.natDegree < t.grado 0 ∧ Sobre A (estrategia 0 []) P := by
  exact recuperar_por_controles t (fun j => estrategia j (historia β j)) θ h2
    (fun j => excepciones t θ hθ h2 hmargin j (estrategia j (historia β j)))
    (fun j => excepciones_control t _ θ hθ h2 hmargin j) (fun j => β j)
    hβ A c hA hd hsteps hfinal

/-- El lema B conserva su conclusión para la familia elegida a lo largo de una historia. -/
theorem lema_B_adaptativo (t : Torre K m)
    (estrategia : ℕ → List K → K → K) (β : ℕ → K)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (hβ : ∀ j : Fin m, β j ∉ excepciones t θ hθ h2 hmargin j
      (estrategia j (historia β j)))
    (A : Finset K) (c : K) (hA : A ⊆ t.dominio 0)
    (hacc : Acepta t (fun j => estrategia j (historia β j)) (fun j => β j) A c)
    (hfar : Lejano t (fun j => estrategia j (historia β j)) θ) :
    (A.card : ℝ) ≤ (1 - θ) * (t.dominio 0).card := by
  by_contra hlarge
  have hd := le_of_lt (lt_of_not_ge hlarge)
  obtain ⟨P, hP, ha⟩ := recuperacion_adaptativa t estrategia β θ hθ h2 hmargin hβ
    A c hA hd hacc.1 hacc.2
  have hsmall := distancia_desde_acuerdo (t.dominio 0) A (estrategia 0 []) P hA
    (dominios_positivos t h2 0 (Nat.zero_le _)) θ hd ha
  exact (not_lt_of_ge hsmall) (hfar P hP)

/-- Tras fijar el historial, la consulta uniforme sin reemplazo sigue acotada por H. -/
theorem muestreo_adaptativo [DecidableEq K] (t : Torre K m) (hm : 0 < m)
    (estrategia : ℕ → List K → K → K) (β : ℕ → K)
    (θ : ℚ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * (θ : ℝ)) * (t.dominio (j + 1)).card)
    (hβ : ∀ j : Fin m, β j ∉ excepciones t θ (by exact_mod_cast hθ) h2 hmargin j
      (estrategia j (historia β j)))
    (G : Finset K) (c : K) (hG : G ⊆ t.dominio 1)
    (hacc : Acepta t (fun j => estrategia j (historia β j)) (fun j => β j)
      (elevar (t.raiz 0) G) c)
    (hfar : Lejano t (fun j => estrategia j (historia β j)) θ)
    (q : ℕ) (_hq : q ≤ (t.dominio 1).card) :
    ((((t.dominio 1).powersetCard q).filter (fun S => S ⊆ G)).card : ℚ) /
      ((t.dominio 1).powersetCard q).card ≤ Nexus.N05.H (t.dominio 1).card q θ := by
  have hA : elevar (t.raiz 0) G ⊆ t.dominio 0 := by
    rw [t.enlace 0 hm]
    exact elevar_mono _ hG
  have hc := lema_B_adaptativo t estrategia β θ (by exact_mod_cast hθ) h2 hmargin hβ
    (elevar (t.raiz 0) G) c hA hacc hfar
  rw [cardinal_elevar G (t.raiz 0)
    (fun y hy => t.cuadrado 0 hm y (hG hy))
    (fun y hy => t.noCero 0 hm y (hG hy)) h2,
    t.enlace 0 hm, cardinal_elevar _ _ (t.cuadrado 0 hm) (t.noCero 0 hm) h2] at hc
  push_cast at hc
  have hbad : (θ : ℝ) * (t.dominio 1).card ≤ (t.dominio 1).card - (G.card : ℝ) := by
    nlinarith
  apply Nexus.N05.cota_omision_radio (t.dominio 1) G q θ hG
  rw [Nat.cast_sub (Finset.card_le_card hG)]
  exact_mod_cast hbad

/-- Conjunto excepcional computado a partir del estado anterior al nuevo reto. -/
@[expose] noncomputable def excepcionesHistoria (t : Torre K m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List K → K → K) (i : ℕ) (h : List K) : Finset K :=
  if hi : i < m then excepciones t θ hθ h2 hmargin ⟨i, hi⟩ (estrategia i h) else ∅

variable [Fintype K] [DecidableEq K]

/-- Probabilidad exacta de entrar en alguna excepción bajo la estrategia adaptativa. -/
@[expose] noncomputable def probabilidadExcepciones (t : Torre K m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List K → K → K) : ℚ :=
  Nexus.N06.riesgo (excepcionesHistoria t θ hθ h2 hmargin estrategia)
    (fun _ h x => h ++ [x]) (fun _ => 0) 0 m []

/-- La suma telescópica sigue válida con oráculos elegidos según la historia. -/
theorem cota_excepciones_adaptativas (t : Torre K m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List K → K → K) :
    probabilidadExcepciones t θ hθ h2 hmargin estrategia ≤
      ((t.dominio 0).card - (t.dominio m).card : ℕ) / (Fintype.card K : ℚ) := by
  let B : ℕ → ℕ := fun i => if i < m then (t.dominio (i + 1)).card else 0
  have hE : ∀ i h, (excepcionesHistoria t θ hθ h2 hmargin estrategia i h).card ≤ B i := by
    intro i h
    by_cases hi : i < m
    · simpa only [excepcionesHistoria, hi, dite_eq_left, B, ite_eq_left] using
        excepciones_cardinal t θ hθ h2 hmargin ⟨i, hi⟩ (estrategia i h)
    · simp [excepcionesHistoria, hi, B]
  have hbound := Nexus.N06.cota_riesgo
    (excepcionesHistoria t θ hθ h2 hmargin estrategia) (fun _ h x => h ++ [x])
    (fun _ => 0) B 0 (by rfl) (by intro _; rfl) hE 0 m []
  have hsum : (∑ j ∈ Finset.range m, B j) =
      (t.dominio 0).card - (t.dominio m).card := by
    have hB : ∀ j ∈ Finset.range m, B j = (t.dominio (j + 1)).card := by
      intro j hj
      simp only [B, Finset.mem_range.mp hj, ite_eq_left]
    rw [Finset.sum_congr rfl hB, ← Fin.sum_univ_eq_sum_range]
    exact suma_capas t h2
  simpa only [probabilidadExcepciones, Nat.zero_add, zero_add, ← Nat.cast_sum, hsum] using hbound

/-! Variante para retos cuya ley por estado no es uniforme en `K`. La hipótesis
`hE` ya contiene la media real de la preimagen excepcional; por tanto esta
forma puede recibir directamente una cota proveniente de un Digest sesgado. -/

theorem cota_excepciones_adaptativas_media (t : Torre K m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List K → K → K) (B : ℕ → ℚ)
    (hE : ∀ i h,
      Nexus.N06.promedio (fun x => if x ∈ excepcionesHistoria t θ hθ h2 hmargin estrategia i h
        then (1 : ℚ) else 0) ≤ B i) :
    probabilidadExcepciones t θ hθ h2 hmargin estrategia ≤
      ∑ j ∈ Finset.range m, B j := by
  unfold probabilidadExcepciones
  simpa only [zero_add, Nat.zero_add] using Nexus.N06.cota_riesgo_media
    (excepcionesHistoria t θ hθ h2 hmargin estrategia)
    (fun _ h x => h ++ [x]) (fun _ => 0) B 0 (by norm_num)
    (by intro _; norm_num) hE 0 m []

/-! La misma cota conserva el alfabeto real de retos. La torre y sus
    excepciones siguen viviendo en `K`, pero cada reto bruto `D` se proyecta
    a `K` antes de consultar la excepción de la capa. -/

variable {D : Type*} [Fintype D] [DecidableEq D] [Nonempty D]

noncomputable def preimagenExcepcion (transporte : D → K) (E : Finset K) : Finset D :=
  Finset.univ.filter (fun d => transporte d ∈ E)

omit [Field K] [Fintype K] [DecidableEq D] [Nonempty D] in
theorem mem_preimagenExcepcion (transporte : D → K) (E : Finset K) (d : D) :
    d ∈ preimagenExcepcion transporte E ↔ transporte d ∈ E := by
  classical
  simp [preimagenExcepcion]

@[expose] noncomputable def excepcionesHistoriaCruda (t : Torre K m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List K → K → K) (transporte : D → K)
    (i : ℕ) (h : List D) : Finset D :=
  preimagenExcepcion transporte
    (excepcionesHistoria t θ hθ h2 hmargin estrategia i (h.map transporte))

noncomputable def probabilidadExcepcionesCruda (t : Torre K m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List K → K → K) (transporte : D → K) : ℚ :=
  Nexus.N06.riesgo
    (excepcionesHistoriaCruda t θ hθ h2 hmargin estrategia transporte)
    (fun _ h d => h ++ [d]) (fun _ => 0) 0 m []

omit [Fintype K] [Nonempty D] in
theorem probabilidadExcepcionesCruda_eq (t : Torre K m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List K → K → K) (transporte : D → K) :
    probabilidadExcepcionesCruda t θ hθ h2 hmargin estrategia transporte =
      Nexus.N06.riesgo
        (excepcionesHistoriaCruda t θ hθ h2 hmargin estrategia transporte)
        (fun _ h d => h ++ [d]) (fun _ => 0) 0 m [] := by
  rfl

omit [Fintype K] in
theorem cota_excepciones_adaptativas_cruda_media (t : Torre K m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : K) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List K → K → K) (transporte : D → K) (B : ℕ → ℚ)
    (hE : ∀ (i : ℕ) (h : List D), Nexus.N06.promedio (fun d : D =>
      if transporte d ∈ excepcionesHistoria t θ hθ h2 hmargin estrategia i
          (h.map transporte) then (1 : ℚ) else 0) ≤ B i) :
    probabilidadExcepcionesCruda t θ hθ h2 hmargin estrategia transporte ≤
      ∑ j ∈ Finset.range m, B j := by
  have hE' : ∀ i h, Nexus.N06.promedio (fun d : D =>
      if d ∈ excepcionesHistoriaCruda t θ hθ h2 hmargin estrategia transporte i h
        then (1 : ℚ) else 0) ≤ B i := by
    intro i h
    simpa only [excepcionesHistoriaCruda, mem_preimagenExcepcion] using hE i h
  unfold probabilidadExcepcionesCruda
  simpa only [zero_add, Nat.zero_add] using Nexus.N06.cota_riesgo_media
    (excepcionesHistoriaCruda t θ hθ h2 hmargin estrategia transporte)
    (fun _ h d => h ++ [d]) (fun _ => 0) B 0 (by norm_num)
    (by intro _; norm_num) hE' 0 m []

end Nexus.FRI
