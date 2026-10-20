module

public import Nexus.Salud.Fuente
public import Nexus.Cripto.AplicacionAutenticada
import Mathlib.Tactic

/-!
# Composición de la compuerta de salud y una operación autenticada

Una operación que usa la clave solo produce estado nuevo si derivar y
procesar tienen éxito. El resultado es atómico en este modelo Option.
No se identifica este modelo con una KDF ni con el ejecutable Rust.
-/

public section
namespace Nexus.Salud.Operaciones

open Nexus.Cripto.Transacciones Nexus.Cripto.Transacciones.Aplicacion
variable {PK Firma Digest Datos : Type}

@[expose] noncomputable def operar (cupo edadMax : ℕ) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (fuente : Fuente) (s : Estado PK Datos) (sol : Solicitud PK Firma) :
    Option (Fuente × Estado PK Datos) := do
  let f ← derivar cupo edadMax fuente
  let t ← procesar hash verify ejecuta s sol
  pure (f, t)

theorem bloqueo_derivacion_bloquea_operacion (cupo edadMax : ℕ) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (fuente : Fuente) (s : Estado PK Datos) (sol : Solicitud PK Firma)
    (h : derivar cupo edadMax fuente = none) :
    operar cupo edadMax hash verify ejecuta fuente s sol = none := by
  simp [operar, h]

theorem operacion_exige_politica_y_admision (cupo edadMax : ℕ) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (fuente f : Fuente) (s t : Estado PK Datos) (sol : Solicitud PK Firma)
    (h : operar cupo edadMax hash verify ejecuta fuente s sol = some (f, t)) :
    PuedeDerivar cupo edadMax fuente ∧ f.usos = fuente.usos + 1 ∧
      Admisible (contexto s) hash verify sol := by
  unfold operar at h
  cases hd : derivar cupo edadMax fuente with
  | none => simp [hd] at h
  | some f' =>
    cases hp : procesar hash verify ejecuta s sol with
    | none => simp [hd, hp] at h
    | some t' =>
      have he : (f', t') = (f, t) := by simpa [hd, hp] using h
      cases he
      have hf := derivacion_exitosa_politica cupo edadMax fuente f hd
      exact ⟨hf.1, hf.2, procesar_exige_admision hash verify ejecuta s t sol hp⟩

theorem sin_evaluar_bloquea_operacion (cupo edadMax : ℕ) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (s : Estado PK Datos) (sol : Solicitud PK Firma) :
    operar cupo edadMax hash verify ejecuta ({} : Fuente) s sol = none :=
  bloqueo_derivacion_bloquea_operacion _ _ _ _ _ _ _ _ (inicio_bloquea_derivacion _ _)

theorem renovacion_bloquea_operacion (cupo edadMax : ℕ) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (fuente : Fuente) (s : Estado PK Datos) (sol : Solicitud PK Firma)
    (h : fuente.renovarPendiente = true) :
    operar cupo edadMax hash verify ejecuta fuente s sol = none :=
  bloqueo_derivacion_bloquea_operacion _ _ _ _ _ _ _ _ (renovacion_pendiente_bloquea _ _ _ h)

theorem reevaluar_sin_rotar_bloquea_operacion (cupo edadMax : ℕ) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (fuente : Fuente) (xs : List (Fin 256)) (s : Estado PK Datos) (sol : Solicitud PK Firma)
    (h : fuente.estado ≠ .configuracionInvalida) :
    operar cupo edadMax hash verify ejecuta (ingresarLote (comenzarRecuperacion fuente) xs) s sol = none :=
  bloqueo_derivacion_bloquea_operacion _ _ _ _ _ _ _ _ (reevaluacion_sola_no_habilita _ _ _ _ h)

theorem admision_fallida_no_produce_estado (cupo edadMax : ℕ) (hash : List ℕ → Digest)
    (verify : PK → Digest → Firma → Bool) (ejecuta : Datos → Documento → Datos)
    (fuente : Fuente) (s : Estado PK Datos) (sol : Solicitud PK Firma)
    (h : procesar hash verify ejecuta s sol = none) :
    operar cupo edadMax hash verify ejecuta fuente s sol = none := by
  unfold operar
  cases derivar cupo edadMax fuente <;> simp [h]

end Nexus.Salud.Operaciones
