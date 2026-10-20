module

public import Nexus.Cripto.Probabilidad
import Mathlib.Tactic

public section
namespace Nexus.Cripto

/-- Árbol de consultas adaptativas, con un presupuesto máximo y salida explícita. -/
inductive Programa (Consulta Respuesta Salida : Type*) : ℕ → Type _
  | terminar {n : ℕ} (salida : Salida) : Programa Consulta Respuesta Salida n
  | consultar {n : ℕ} (q : Consulta) (continuar : Respuesta → Programa Consulta Respuesta Salida n) :
      Programa Consulta Respuesta Salida (n + 1)

variable {Q A O : Type*}
abbrev Registro (Q A : Type*) := List (Q × A)

/-- Cada consulta incorpora la respuesta al registro antes de continuar. -/
@[expose] noncomputable def ejecutar (oraculo : Q → PMF A) :
    {n : ℕ} → Programa Q A O n → Registro Q A → PMF (O × Registro Q A)
  | _, .terminar o, h => PMF.pure (o, h)
  | _, .consultar q k, h =>
      (oraculo q).bind (fun a => ejecutar oraculo (k a) (h ++ [(q, a)]))

theorem ejecutar_terminar (oraculo : Q → PMF A) (n : ℕ) (o : O) (h : Registro Q A) :
    ejecutar oraculo (Programa.terminar (n := n) o) h = PMF.pure (o, h) := rfl

theorem ejecutar_consultar (oraculo : Q → PMF A) (n : ℕ) (q : Q)
    (k : A → Programa Q A O n) (h : Registro Q A) :
    ejecutar oraculo (.consultar q k) h =
      (oraculo q).bind (fun a => ejecutar oraculo (k a) (h ++ [(q, a)])) := rfl

theorem registro_extiende (oraculo : Q → PMF A) {n : ℕ} (p : Programa Q A O n)
    (h : Registro Q A) (out : O × Registro Q A) (ho : out ∈ (ejecutar oraculo p h).support) :
    ∃ sufijo, out.2 = h ++ sufijo := by
  induction p generalizing h with
  | terminar o =>
    have he := (PMF.mem_support_pure_iff (o, h) out).mp ho
    subst out
    exact ⟨[], (List.append_nil h).symm⟩
  | consultar q k ih =>
    change out ∈ ((oraculo q).bind _).support at ho
    obtain ⟨a, _, ha⟩ := (PMF.mem_support_bind_iff _ _ _).mp ho
    obtain ⟨sufijo, hs⟩ := ih a (h ++ [(q, a)]) ha
    exact ⟨(q, a) :: sufijo, by simpa only [List.append_assoc, List.singleton_append] using hs⟩

theorem longitud_registro_acotada (oraculo : Q → PMF A) {n : ℕ} (p : Programa Q A O n)
    (h : Registro Q A) (out : O × Registro Q A) (ho : out ∈ (ejecutar oraculo p h).support) :
    out.2.length ≤ h.length + n := by
  induction p generalizing h with
  | terminar o =>
    have he := (PMF.mem_support_pure_iff (o, h) out).mp ho
    subst out
    dsimp only
    omega
  | consultar q k ih =>
    change out ∈ ((oraculo q).bind _).support at ho
    obtain ⟨a, _, ha⟩ := (PMF.mem_support_bind_iff _ _ _).mp ho
    have hi := ih a (h ++ [(q, a)]) ha
    simp only [List.length_append, List.length_singleton] at hi
    omega

theorem registro_respeta_soporte (oraculo : Q → PMF A) (P : Q → A → Prop)
    (hP : ∀ q a, a ∈ (oraculo q).support → P q a) {n : ℕ} (p : Programa Q A O n)
    (h : Registro Q A) (hh : ∀ e ∈ h, P e.1 e.2) (out : O × Registro Q A)
    (ho : out ∈ (ejecutar oraculo p h).support) : ∀ e ∈ out.2, P e.1 e.2 := by
  induction p generalizing h with
  | terminar o =>
    have he := (PMF.mem_support_pure_iff (o, h) out).mp ho
    subst out
    exact hh
  | consultar q k ih =>
    change out ∈ ((oraculo q).bind _).support at ho
    obtain ⟨a, ha, hout⟩ := (PMF.mem_support_bind_iff _ _ _).mp ho
    apply ih a (h ++ [(q, a)]) _ hout
    intro e he
    rcases List.mem_append.mp he with he | he
    · exact hh e he
    · have heq := List.mem_singleton.mp he
      subst e
      exact hP q a ha

theorem consultas_acotadas {n : ℕ} (oraculo : Q → PMF A) (p : Programa Q A O n)
    (out : O × Registro Q A) (ho : out ∈ (ejecutar oraculo p []).support) : out.2.length ≤ n := by
  simpa only [List.length_nil, zero_add] using longitud_registro_acotada oraculo p [] out ho

theorem respuestas_funcion_fija {n : ℕ} (H : Q → A) (p : Programa Q A O n)
    (out : O × Registro Q A) (ho : out ∈ (ejecutar (fun q => PMF.pure (H q)) p []).support) :
    ∀ e ∈ out.2, e.2 = H e.1 := by
  apply registro_respeta_soporte (fun q => PMF.pure (H q)) (fun q a => a = H q) _ p [] _ out ho
  · intro q a ha
    exact (PMF.mem_support_pure_iff (H q) a).mp ha
  · simp

theorem consultas_repetidas_consistentes {n : ℕ} (H : Q → A) (p : Programa Q A O n)
    (out : O × Registro Q A) (ho : out ∈ (ejecutar (fun q => PMF.pure (H q)) p []).support)
    (q : Q) (a b : A) (ha : (q, a) ∈ out.2) (hb : (q, b) ∈ out.2) : a = b :=
  (respuestas_funcion_fija H p out ho (q, a) ha).trans
    (respuestas_funcion_fija H p out ho (q, b) hb).symm

end Nexus.Cripto
