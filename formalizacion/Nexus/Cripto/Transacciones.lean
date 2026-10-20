module

public import Nexus.Cripto.RegistroEpocas
import Mathlib.Tactic

public section
namespace Nexus.Cripto.Transacciones

@[ext] structure Documento where
  identidad : ℕ
  epoca : ℕ
  cadena : ℕ
  nonce : ℕ
  contenido : List ℕ

/-- Formato matemático inequívoco; la correspondencia con bincode se exige aparte. -/
@[expose] def codifica (d : Documento) : List ℕ :=
  d.identidad :: d.epoca :: d.cadena :: d.nonce :: d.contenido.length :: d.contenido

@[expose] def decodifica : List ℕ → Option Documento
  | i :: e :: c :: n :: l :: xs => if xs.length = l then some ⟨i, e, c, n, xs⟩ else none
  | _ => none

theorem decodifica_codifica (d : Documento) : decodifica (codifica d) = some d := by
  cases d
  simp [codifica, decodifica]

theorem codifica_inyectiva : Function.Injective codifica := by
  intro a b h
  have he := congrArg decodifica h
  simpa only [decodifica_codifica, Option.some.injEq] using he

variable {PK Firma Digest Estado : Type}

structure Solicitud (PK Firma : Type) where
  documento : Documento
  publica : PK
  firma : Firma

structure Contexto (PK : Type) where
  cadena : ℕ
  nonce : ℕ → ℕ
  vigente : ℕ → ℕ → PK → Prop

@[expose] def Admisible (ctx : Contexto PK) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (s : Solicitud PK Firma) : Prop :=
  s.documento.cadena = ctx.cadena ∧ s.documento.nonce = ctx.nonce s.documento.identidad ∧
    ctx.vigente s.documento.identidad s.documento.epoca s.publica ∧
    verify s.publica (hash (codifica s.documento)) s.firma = true

@[expose] noncomputable def aplicar (ctx : Contexto PK) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Estado → Documento → Estado)
    (estado : Estado) (s : Solicitud PK Firma) : Estado := by
  classical
  exact if Admisible ctx hash verify s then ejecuta estado s.documento else estado

theorem no_admisible_no_cambia (ctx : Contexto PK) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Estado → Documento → Estado)
    (estado : Estado) (s : Solicitud PK Firma) (h : ¬ Admisible ctx hash verify s) :
    aplicar ctx hash verify ejecuta estado s = estado := by simp [aplicar, h]

theorem cambio_exige_verificacion (ctx : Contexto PK) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Estado → Documento → Estado)
    (estado : Estado) (s : Solicitud PK Firma) (h : aplicar ctx hash verify ejecuta estado s ≠ estado) :
    Admisible ctx hash verify s := by
  by_contra hn
  exact h (no_admisible_no_cambia ctx hash verify ejecuta estado s hn)

theorem otra_cadena_rechazada (ctx : Contexto PK) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (s : Solicitud PK Firma)
    (h : s.documento.cadena ≠ ctx.cadena) : ¬ Admisible ctx hash verify s := fun ha => h ha.1

theorem nonce_incorrecto_rechazado (ctx : Contexto PK) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (s : Solicitud PK Firma)
    (h : s.documento.nonce ≠ ctx.nonce s.documento.identidad) : ¬ Admisible ctx hash verify s :=
  fun ha => h ha.2.1

theorem contenido_cambiado_colision_o_digest_distinto (hash : List ℕ → Digest) (a b : Documento)
    (h : a ≠ b) : hash (codifica a) ≠ hash (codifica b) ∨
      (codifica a ≠ codifica b ∧ hash (codifica a) = hash (codifica b)) := by
  by_cases he : hash (codifica a) = hash (codifica b)
  · exact Or.inr ⟨fun hc => h (codifica_inyectiva hc), he⟩
  · exact Or.inl he

theorem nonce_consumido_impide_repeticion (ctx siguiente : Contexto PK)
    (hash : List ℕ → Digest) (verify : PK → Digest → Firma → Bool) (s : Solicitud PK Firma)
    (ha : Admisible ctx hash verify s)
    (hn : siguiente.nonce s.documento.identidad = ctx.nonce s.documento.identidad + 1) :
    ¬ Admisible siguiente hash verify s := by
  apply nonce_incorrecto_rechazado
  rw [ha.2.1, hn]
  omega

end Nexus.Cripto.Transacciones
