module

public import Nexus.MLDSA.MLWE
import Mathlib.Tactic

public section
namespace Nexus.MLDSA

open scoped Matrix

/-- Plantilla algebraica: conserva la diferencia con las claves comprimidas de FIPS 204. -/
structure ClavePlantilla (k r : ℕ) where
  matriz : Matriz k r
  secreto : Vector r
  error : Vector k

@[expose] noncomputable def publicaPlantilla {k r : ℕ} (sk : ClavePlantilla k r) : Vector k :=
  sk.matriz *ᵥ sk.secreto + sk.error

@[expose] noncomputable def respuestaPlantilla {r : ℕ} (y s : Vector r) (c : Rq) : Vector r := y + c • s

@[expose] noncomputable def reconstruccionPlantilla {k r : ℕ} (A : Matriz k r)
    (t : Vector k) (z : Vector r) (c : Rq) : Vector k := A *ᵥ z - c • t

theorem ecuacion_respuesta {k r : ℕ} (sk : ClavePlantilla k r) (y : Vector r) (c : Rq) :
    reconstruccionPlantilla sk.matriz (publicaPlantilla sk) (respuestaPlantilla y sk.secreto c) c =
      sk.matriz *ᵥ y - c • sk.error := by
  simp only [reconstruccionPlantilla, publicaPlantilla, respuestaPlantilla,
    Matrix.mulVec_add, Matrix.mulVec_smul, smul_add]
  abel

abbrev Pistas (k : ℕ) := Fin k → Fin n → Bool

structure FirmaPlantilla (k r : ℕ) where
  respuesta : Vector r
  pistas : Pistas k
  reto : Rq

@[expose] noncomputable def pesoPistas {k : ℕ} (h : Pistas k) : ℕ := by
  classical
  exact (Finset.univ.filter (fun i : Fin k × Fin n => h i.1 i.2 = true)).card

@[expose] def DentroCotas {k r : ℕ} (B W : ℕ) (sig : FirmaPlantilla k r) : Prop :=
  normaVector sig.respuesta < B ∧ pesoPistas sig.pistas ≤ W

/-- Las funciones de redondeo y uso de pistas son parámetros explícitos de esta plantilla. -/
@[expose] def VerificaPlantilla {k r : ℕ} {Mensaje Alto : Type*}
    (A : Matriz k r) (t : Vector k) (usaPistas : Vector k → Pistas k → Alto)
    (H : Mensaje → Alto → Rq) (B W : ℕ) (mu : Mensaje) (sig : FirmaPlantilla k r) : Prop :=
  DentroCotas B W sig ∧ sig.reto = H mu
    (usaPistas (reconstruccionPlantilla A t sig.respuesta sig.reto) sig.pistas)

theorem verifica_plantilla {k r : ℕ} {Mensaje Alto : Type*}
    (sk : ClavePlantilla k r) (y : Vector r) (h : Pistas k)
    (redondea : Vector k → Alto) (usa : Vector k → Pistas k → Alto)
    (H : Mensaje → Alto → Rq) (mu : Mensaje) (B W : ℕ)
    (hcotas : DentroCotas B W ⟨respuestaPlantilla y sk.secreto (H mu (redondea (sk.matriz *ᵥ y))),
      h, H mu (redondea (sk.matriz *ᵥ y))⟩)
    (hpista : usa (sk.matriz *ᵥ y - H mu (redondea (sk.matriz *ᵥ y)) • sk.error) h =
      redondea (sk.matriz *ᵥ y)) :
    VerificaPlantilla sk.matriz (publicaPlantilla sk) usa H B W mu
      ⟨respuestaPlantilla y sk.secreto (H mu (redondea (sk.matriz *ᵥ y))), h,
        H mu (redondea (sk.matriz *ᵥ y))⟩ := by
  refine ⟨hcotas, ?_⟩
  dsimp only
  rw [ecuacion_respuesta, hpista]

@[expose] noncomputable def intentoPlantilla {k r : ℕ} (B W : ℕ)
    (candidato : FirmaPlantilla k r) : Option (FirmaPlantilla k r) := by
  classical
  exact if DentroCotas B W candidato then some candidato else none

theorem intento_acepta_iff {k r : ℕ} (B W : ℕ) (candidato sig : FirmaPlantilla k r) :
    intentoPlantilla B W candidato = some sig ↔ candidato = sig ∧ DentroCotas B W candidato := by
  classical
  by_cases h : DentroCotas B W candidato <;> simp [intentoPlantilla, h]

theorem intento_rechaza_iff {k r : ℕ} (B W : ℕ) (sig : FirmaPlantilla k r) :
    intentoPlantilla B W sig = none ↔ ¬ DentroCotas B W sig := by
  classical
  by_cases h : DentroCotas B W sig <;> simp [intentoPlantilla, h]

theorem aceptacion_respeta_norma {k r : ℕ} (B W : ℕ) (candidato sig : FirmaPlantilla k r)
    (h : intentoPlantilla B W candidato = some sig) : normaVector sig.respuesta < B := by
  obtain ⟨rfl, hc⟩ := (intento_acepta_iff B W candidato sig).mp h
  exact hc.1

theorem aceptacion_respeta_pistas {k r : ℕ} (B W : ℕ) (candidato sig : FirmaPlantilla k r)
    (h : intentoPlantilla B W candidato = some sig) : pesoPistas sig.pistas ≤ W := by
  obtain ⟨rfl, hc⟩ := (intento_acepta_iff B W candidato sig).mp h
  exact hc.2

theorem cotas_mayores {k r : ℕ} (B C W U : ℕ) (hB : B ≤ C) (hW : W ≤ U)
    (sig : FirmaPlantilla k r) (h : DentroCotas B W sig) : DentroCotas C U sig :=
  ⟨h.1.trans_le hB, h.2.trans hW⟩

end Nexus.MLDSA
