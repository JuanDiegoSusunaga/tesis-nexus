module

public import Nexus.MLDSA.MSIS
public import Nexus.Cripto.Oraculo
public import Mathlib.Data.Matrix.ColumnRowPartitioned
import Mathlib.Tactic

public section
namespace Nexus.MLDSA

open Nexus.Cripto
open scoped ENNReal Matrix

/-- La segunda dimensión es r+1: el último componente siempre existe y codifica el reto. -/
abbrev TestigoSelf (m r : ℕ) := Vector m × Vector (r + 1)

@[expose] noncomputable def normaTestigoSelf {m r : ℕ} (y : TestigoSelf m r) : ℕ :=
  max (normaVector y.1) (normaVector y.2)

@[expose] noncomputable def valorSelf {m r : ℕ} (A : Matriz m (r + 1))
    (y : TestigoSelf m r) : Vector m := y.1 + A *ᵥ y.2

@[expose] def ultimoSelf {m r : ℕ} (y : TestigoSelf m r) : Rq := y.2 (Fin.last r)

theorem dimension_self (m r : ℕ) : Fintype.card (Fin m ⊕ Fin (r + 1)) = m + (r + 1) := by
  simp only [Fintype.card_sum, Fintype.card_fin]

theorem matriz_identidad_self {m r : ℕ} (A : Matriz m (r + 1)) (y : TestigoSelf m r) :
    Matrix.fromCols (1 : Matriz m m) A *ᵥ Sum.elim y.1 y.2 = valorSelf A y := by
  rw [Matrix.fromCols_mulVec_sumElim, Matrix.one_mulVec]
  rfl

theorem norma_self_iff {m r : ℕ} (y : TestigoSelf m r) (B : ℕ) :
    normaTestigoSelf y ≤ B ↔ normaVector y.1 ≤ B ∧ normaVector y.2 ≤ B := max_le_iff

theorem norma_componente_vector {r : ℕ} (x : Vector r) (j : Fin r) : normaRq (x j) ≤ normaVector x := by
  apply (norma_le_iff _ _).mpr
  intro i
  exact coeficiente_le_norma (fun a : Fin r × Fin n => centrado (x a.1) a.2) (j, i)

/-- El dominio del hash es tipado e inequívoco; la codificación de bytes no se presupone. -/
@[expose] def SolucionSelfTarget {m r : ℕ} {Mensaje Entrada Reto : Type*}
    (codificaReto : Reto ↪ Rq) (codificaEntrada : (Vector m × Mensaje) ↪ Entrada)
    (A : Matriz m (r + 1)) (H : Entrada → Reto) (B : ℕ)
    (y : TestigoSelf m r) (mu : Mensaje) : Prop :=
  normaTestigoSelf y ≤ B ∧ codificaReto (H (codificaEntrada (valorSelf A y, mu))) = ultimoSelf y

theorem cota_reto_si_gana {m r : ℕ} {Mensaje Entrada Reto : Type*}
    (c : Reto ↪ Rq) (enc : (Vector m × Mensaje) ↪ Entrada)
    (A : Matriz m (r + 1)) (H : Entrada → Reto) (B : ℕ) (y : TestigoSelf m r) (mu : Mensaje)
    (hy : SolucionSelfTarget c enc A H B y mu) :
    normaRq (c (H (enc (valorSelf A y, mu)))) ≤ B := by
  rw [hy.2]
  exact (norma_componente_vector y.2 (Fin.last r)).trans ((norma_self_iff y B).mp hy.1).2

theorem testigo_self_no_nulo {m r : ℕ} {Mensaje Entrada Reto : Type*}
    (c : Reto ↪ Rq) (hc : ∀ z, c z ≠ 0) (enc : (Vector m × Mensaje) ↪ Entrada)
    (A : Matriz m (r + 1)) (H : Entrada → Reto) (B : ℕ) (y : TestigoSelf m r) (mu : Mensaje)
    (hy : SolucionSelfTarget c enc A H B y mu) : y ≠ (0, 0) := by
  intro he
  have h := hy.2
  apply hc (H (enc (valorSelf A y, mu)))
  exact h.trans (by rw [he]; rfl)

theorem self_mayor_cota {m r : ℕ} {Mensaje Entrada Reto : Type*}
    (c : Reto ↪ Rq) (enc : (Vector m × Mensaje) ↪ Entrada)
    (A : Matriz m (r + 1)) (H : Entrada → Reto) (B C : ℕ) (hBC : B ≤ C)
    (y : TestigoSelf m r) (mu : Mensaje) (hy : SolucionSelfTarget c enc A H B y mu) :
    SolucionSelfTarget c enc A H C y mu := ⟨hy.1.trans hBC, hy.2⟩

structure ResultadoSelf (m r : ℕ) (Mensaje Entrada Reto : Type*) where
  matriz : Matriz m (r + 1)
  tabla : Entrada → Reto
  candidato : TestigoSelf m r × Mensaje
  registro : Registro Entrada Reto

/-- Matriz uniforme y tabla aleatoria independiente; el adversario solo consulta la tabla. -/
@[expose] noncomputable def ensayoSelf (m r Q : ℕ) (Mensaje Entrada Reto : Type*)
    [Fintype Entrada] [Fintype Reto] [Nonempty Reto]
    (adversario : Matriz m (r + 1) → PMF (Programa Entrada Reto (TestigoSelf m r × Mensaje) Q)) :
    PMF (ResultadoSelf m r Mensaje Entrada Reto) := by
  classical
  exact (producto (uniforme (Matriz m (r + 1))) (uniforme (Entrada → Reto))).bind
    (fun ah => (adversario ah.1).bind (fun p =>
      (ejecutar (fun x => PMF.pure (ah.2 x)) p []).map
        (fun out => ⟨ah.1, ah.2, out.1, out.2⟩)))

@[expose] noncomputable def ventajaSelf (m r Q B : ℕ) (Mensaje Entrada Reto : Type*)
    [Fintype Entrada] [Fintype Reto] [Nonempty Reto]
    (c : Reto ↪ Rq) (enc : (Vector m × Mensaje) ↪ Entrada)
    (adversario : Matriz m (r + 1) → PMF (Programa Entrada Reto (TestigoSelf m r × Mensaje) Q)) : ℝ≥0∞ :=
  probabilidad (ensayoSelf m r Q Mensaje Entrada Reto adversario)
    (fun out => SolucionSelfTarget c enc out.matriz out.tabla B out.candidato.1 out.candidato.2)

theorem consultas_self_correctas (m r Q : ℕ) (Mensaje Entrada Reto : Type*)
    [Fintype Entrada] [Fintype Reto] [Nonempty Reto]
    (adversario : Matriz m (r + 1) → PMF (Programa Entrada Reto (TestigoSelf m r × Mensaje) Q))
    (out : ResultadoSelf m r Mensaje Entrada Reto)
    (ho : out ∈ (ensayoSelf m r Q Mensaje Entrada Reto adversario).support) :
    out.registro.length ≤ Q ∧ ∀ qr ∈ out.registro, qr.2 = out.tabla qr.1 := by
  rw [ensayoSelf, PMF.mem_support_bind_iff] at ho
  obtain ⟨ah, _, hp⟩ := ho
  obtain ⟨p, _, hout⟩ := (PMF.mem_support_bind_iff _ _ _).mp hp
  obtain ⟨res, hres, rfl⟩ := (PMF.mem_support_map_iff _ _ _).mp hout
  exact ⟨consultas_acotadas _ p res hres, respuestas_funcion_fija ah.2 p res hres⟩

theorem ventaja_self_le_uno (m r Q B : ℕ) (Mensaje Entrada Reto : Type*)
    [Fintype Entrada] [Fintype Reto] [Nonempty Reto]
    (c : Reto ↪ Rq) (enc : (Vector m × Mensaje) ↪ Entrada)
    (adversario : Matriz m (r + 1) → PMF (Programa Entrada Reto (TestigoSelf m r × Mensaje) Q)) :
    ventajaSelf m r Q B Mensaje Entrada Reto c enc adversario ≤ 1 := probabilidad_le_uno _ _

theorem ventaja_self_monotona (m r Q B C : ℕ) (hBC : B ≤ C) (Mensaje Entrada Reto : Type*)
    [Fintype Entrada] [Fintype Reto] [Nonempty Reto]
    (c : Reto ↪ Rq) (enc : (Vector m × Mensaje) ↪ Entrada)
    (adversario : Matriz m (r + 1) → PMF (Programa Entrada Reto (TestigoSelf m r × Mensaje) Q)) :
    ventajaSelf m r Q B Mensaje Entrada Reto c enc adversario ≤
      ventajaSelf m r Q C Mensaje Entrada Reto c enc adversario := by
  apply probabilidad_monotona
  intro out hy
  exact self_mayor_cota c enc out.matriz out.tabla B C hBC out.candidato.1 out.candidato.2 hy

end Nexus.MLDSA
