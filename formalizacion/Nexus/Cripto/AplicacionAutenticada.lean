module

public import Nexus.Cripto.Transacciones
import Mathlib.Tactic

/-!
# Aplicación atómica y procedencia de documentos autenticados

El registro de claves determina el contexto. La aceptación consume el nonce
en el mismo paso que aplica el documento. La procedencia de firmas se exige
como hipótesis explícita sobre el historial de documentos autorizados.
No se presupone que un hash finito sea inyectivo en todos los mensajes.
-/

public section
namespace Nexus.Cripto.Transacciones.Aplicacion

variable {PK Firma Digest Datos : Type}

structure Estado (PK Datos : Type) where
  registro : Epocas.Estado ℕ PK
  cadena : ℕ
  nonce : ℕ → ℕ
  datos : Datos

@[expose] def contexto (s : Estado PK Datos) : Contexto PK :=
  ⟨s.cadena, s.nonce, Epocas.Vigente s.registro⟩

@[expose] noncomputable def procesar (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (s : Estado PK Datos) (sol : Solicitud PK Firma) : Option (Estado PK Datos) := by
  classical
  exact if Admisible (contexto s) hash verify sol then
    some { s with
      nonce := Function.update s.nonce sol.documento.identidad (s.nonce sol.documento.identidad + 1)
      datos := ejecuta s.datos sol.documento }
  else none

theorem procesar_exige_admision (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (s t : Estado PK Datos) (sol : Solicitud PK Firma)
    (h : procesar hash verify ejecuta s sol = some t) :
    Admisible (contexto s) hash verify sol := by
  unfold procesar at h
  split_ifs at h with ha
  exact ha

theorem procesar_actualiza_atomico (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (s t : Estado PK Datos) (sol : Solicitud PK Firma)
    (h : procesar hash verify ejecuta s sol = some t) :
    t.registro = s.registro ∧ t.cadena = s.cadena ∧
      t.nonce = Function.update s.nonce sol.documento.identidad
        (s.nonce sol.documento.identidad + 1) ∧ t.datos = ejecuta s.datos sol.documento := by
  unfold procesar at h
  split_ifs at h
  cases h
  exact ⟨rfl, rfl, rfl, rfl⟩

theorem procesar_vincula_clave (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (s t : Estado PK Datos) (sol : Solicitud PK Firma)
    (h : procesar hash verify ejecuta s sol = some t) :
    sol.documento.epoca = s.registro.epoca ∧
      s.registro.claves sol.documento.identidad = some sol.publica :=
  (procesar_exige_admision hash verify ejecuta s t sol h).2.2.1

theorem procesar_impide_repeticion (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (s t : Estado PK Datos) (sol : Solicitud PK Firma)
    (h : procesar hash verify ejecuta s sol = some t) :
    procesar hash verify ejecuta t sol = none := by
  have ha := procesar_exige_admision hash verify ejecuta s t sol h
  have hu := (procesar_actualiza_atomico hash verify ejecuta s t sol h).2.2.1
  have hn : (contexto t).nonce sol.documento.identidad =
      (contexto s).nonce sol.documento.identidad + 1 := by
    change t.nonce _ = s.nonce _ + 1
    rw [hu, Function.update_self]
  have hr := nonce_consumido_impide_repeticion (contexto s) (contexto t) hash verify sol ha hn
  simp only [procesar, hr, ite_false]

/-- Contrato de procedencia; demostrarlo para firmas reales es una obligación criptográfica. -/
@[expose] def OrigenFirmas (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (autorizado : PK → Documento → Prop) : Prop :=
  ∀ pk dg firma, verify pk dg firma = true →
    ∃ d, autorizado pk d ∧ dg = hash (codifica d)

@[expose] def ColisionCon (hash : List ℕ → Digest) (autorizado : PK → Documento → Prop)
    (sol : Solicitud PK Firma) : Prop :=
  ∃ d, autorizado sol.publica d ∧ codifica sol.documento ≠ codifica d ∧
    hash (codifica sol.documento) = hash (codifica d)

theorem admision_autorizada_o_colision (ctx : Contexto PK) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (autorizado : PK → Documento → Prop)
    (horigen : OrigenFirmas hash verify autorizado) (sol : Solicitud PK Firma)
    (ha : Admisible ctx hash verify sol) :
    autorizado sol.publica sol.documento ∨ ColisionCon hash autorizado sol := by
  obtain ⟨d, hd, he⟩ := horigen _ _ _ ha.2.2.2
  by_cases hc : codifica sol.documento = codifica d
  · exact Or.inl (by simpa only [codifica_inyectiva hc] using hd)
  · exact Or.inr ⟨d, hd, hc, he⟩

theorem procesar_autorizado_sin_colision (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (autorizado : PK → Documento → Prop) (horigen : OrigenFirmas hash verify autorizado)
    (s t : Estado PK Datos) (sol : Solicitud PK Firma)
    (h : procesar hash verify ejecuta s sol = some t)
    (hc : ¬ ColisionCon hash autorizado sol) : autorizado sol.publica sol.documento :=
  (admision_autorizada_o_colision (contexto s) hash verify autorizado horigen sol
    (procesar_exige_admision hash verify ejecuta s t sol h)).resolve_right hc

end Nexus.Cripto.Transacciones.Aplicacion
