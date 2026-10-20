module

public import Nexus.FRI.Adaptativo
import Mathlib.Tactic

/-!
# Transcripciones finitas y cotas con escape

La prolongación por cero solo permite reutilizar las interfaces indexadas
por naturales. Las primeras n coordenadas son exactamente los n retos
uniformes del experimento; no se consulta la prolongación en esas rondas.
-/

public section
namespace Nexus.N06

variable {K S : Type*}

@[expose] def reto [Zero K] : {n : ℕ} → Retos K n → ℕ → K
  | 0, _, _ => 0
  | _ + 1, xs, 0 => xs.1
  | _ + 1, xs, j + 1 => reto xs.2 j

theorem reto_inicial [Zero K] (n : ℕ) (x : K) (xs : Retos K n) :
    reto (n := n + 1) (x, xs) 0 = x := rfl

theorem reto_siguiente [Zero K] (n : ℕ) (x : K) (xs : Retos K n) (j : ℕ) :
    reto (n := n + 1) (x, xs) (j + 1) = reto xs j := rfl

theorem historia_retos_cons [Zero K] (n : ℕ) (x : K) (xs : Retos K n) (j : ℕ) :
    Nexus.FRI.historia (reto (n := n + 1) (x, xs)) (j + 1) =
      [x] ++ Nexus.FRI.historia (reto xs) j := by
  induction j with
  | zero => rfl
  | succ j ih =>
    rw [Nexus.FRI.historia, ih, reto_siguiente, Nexus.FRI.historia, List.append_assoc]

/-- La ausencia de escape equivale a evitar cada conjunto calculado con su prefijo. -/
theorem no_escape_historia [Zero K] [DecidableEq K]
    (E : ℕ → List K → Finset K) (i n : ℕ) (h : List K) (xs : Retos K n) :
    ¬ Escapa E (fun _ h x => h ++ [x]) i n h xs ↔
      ∀ j < n, reto xs j ∉ E (i + j) (h ++ Nexus.FRI.historia (reto xs) j) := by
  induction n generalizing i h with
  | zero => simp [Escapa]
  | succ n ih =>
    obtain ⟨x, rest⟩ := xs
    change ¬ (x ∈ E i h ∨ Escapa E (fun _ h x => h ++ [x])
      (i + 1) n (h ++ [x]) rest) ↔ _
    rw [not_or, ih]
    constructor
    · rintro ⟨hx, hr⟩ j hj
      cases j with
      | zero => simpa only [reto_inicial, Nexus.FRI.historia, List.append_nil, Nat.add_zero] using hx
      | succ j =>
        simpa only [reto_siguiente, historia_retos_cons, List.append_assoc, Nat.add_assoc,
          Nat.add_comm 1 j] using hr j (by omega)
    · intro hr
      constructor
      · simpa only [reto_inicial, Nexus.FRI.historia, List.append_nil, Nat.add_zero] using hr 0 (by omega)
      · intro j hj
        simpa only [reto_siguiente, historia_retos_cons, List.append_assoc, Nat.add_assoc,
          Nat.add_comm 1 j] using hr (j + 1) (by omega)

variable [Fintype K] [Nonempty K] [DecidableEq K]

omit [Fintype K] [Nonempty K] in
/-- Con terminal constante, el valor absorbente vale uno si escapa y h en otro caso. -/
theorem valor_constante (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (h : ℚ) (i n : ℕ) (s : S) (xs : Retos K n) :
    valor E paso (fun _ => h) i n s xs = if Escapa E paso i n s xs then 1 else h := by
  induction n generalizing i s with
  | zero => simp only [valor, Escapa, reduceIte]
  | succ n ih =>
    obtain ⟨x, rest⟩ := xs
    by_cases hx : x ∈ E i s
    · simp only [valor, Escapa, hx, true_or, reduceIte]
    · simp only [valor, Escapa, hx, false_or, reduceIte, ih]

/-- El resultado final puede depender de toda la transcripción y de otras monedas.
Solo se exige su cota puntual cuando no se ha alcanzado ninguna excepción. -/
theorem cota_promedio_fuera_escape (E : ℕ → S → Finset K) (paso : ℕ → S → K → S)
    (B : ℕ → ℕ) (h : ℚ) (hh : 0 ≤ h) (hE : ∀ i s, (E i s).card ≤ B i)
    (i n : ℕ) (s : S) (f : Retos K n → ℚ)
    (huno : ∀ xs, f xs ≤ 1) (hseguro : ∀ xs, ¬ Escapa E paso i n s xs → f xs ≤ h) :
    promedio f ≤ h + (∑ j ∈ Finset.range n, (B (i + j) : ℚ)) / Fintype.card K := by
  apply (promedio_monotono f (valor E paso (fun _ => h) i n s) ?_).trans
    ((riesgo_es_promedio E paso (fun _ => h) i n s).symm.le.trans
      (cota_riesgo E paso (fun _ => h) B h hh (fun _ => le_refl _) hE i n s))
  intro xs
  rw [valor_constante]
  by_cases hx : Escapa E paso i n s xs
  · simpa only [hx, reduceIte] using huno xs
  · simpa only [hx, reduceIte] using hseguro xs hx

end Nexus.N06
