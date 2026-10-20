module

public import Nexus.Cripto.RegistroEpocas
public import Nexus.Cripto.Transacciones
import Mathlib.Tactic

/-!
# Autorización y posesión derivadas de firmas del lote completo

El mensaje tipado contiene la época y todas las claves siguientes.
No se parametrizan autorización y posesión como booleanos libres.
El codec, la dureza de la firma y la custodia de secretos quedan separados.
-/

public section
namespace Nexus.Cripto.Epocas.Firmada

variable {I K S : Type} [DecidableEq K]

abbrev Mensaje (I K : Type) := ℕ × (I → Option K)

structure Propuesta (I K S : Type) where
  epoca : ℕ
  nuevas : I → Option K
  salientes : I → S
  entrantes : I → S

@[expose] def Valida (verify : K → Mensaje I K → S → Bool) (s : Estado I K)
    (p : Propuesta I K S) : Prop :=
  p.epoca = s.epoca + 1 ∧ MismasIdentidades s p.nuevas ∧
    ∀ i vieja nueva, s.claves i = some vieja → p.nuevas i = some nueva →
      verify vieja (p.epoca, p.nuevas) (p.salientes i) = true ∧
      verify nueva (p.epoca, p.nuevas) (p.entrantes i) = true

@[expose] noncomputable def instalarFirmada (verify : K → Mensaje I K → S → Bool)
    (s : Estado I K) (p : Propuesta I K S) : Option (Estado I K) := by
  classical
  exact if Valida verify s p then some (instalar s (some p.nuevas) true true true) else none

omit [DecidableEq K] in
theorem instalacion_exige_firmas (verify : K → Mensaje I K → S → Bool)
    (s t : Estado I K) (p : Propuesta I K S) (h : instalarFirmada verify s p = some t) :
    Valida verify s p ∧ t = instalar s (some p.nuevas) true true true := by
  classical
  unfold instalarFirmada at h
  split at h
  · rename_i hv
    exact ⟨hv, (Option.some.inj h).symm⟩
  · contradiction

omit [DecidableEq K] in
theorem firmas_con_claves_vigentes (verify : K → Mensaje I K → S → Bool)
    (s t : Estado I K) (p : Propuesta I K S) (h : instalarFirmada verify s p = some t)
    (i : I) (vieja nueva : K) (hv : s.claves i = some vieja) (hn : p.nuevas i = some nueva) :
    verify vieja (p.epoca, p.nuevas) (p.salientes i) = true ∧
      verify nueva (p.epoca, p.nuevas) (p.entrantes i) = true :=
  (instalacion_exige_firmas verify s t p h).1.2.2 i vieja nueva hv hn

omit [DecidableEq K] in
theorem instalacion_epoca_exacta (verify : K → Mensaje I K → S → Bool)
    (s t : Estado I K) (p : Propuesta I K S) (h : instalarFirmada verify s p = some t) :
    t.epoca = p.epoca ∧ t.epoca = s.epoca + 1 := by
  obtain ⟨hv, rfl⟩ := instalacion_exige_firmas verify s t p h
  exact ⟨hv.1.symm, rfl⟩

omit [DecidableEq K] in
theorem instalacion_historial (verify : K → Mensaje I K → S → Bool)
    (s t : Estado I K) (p : Propuesta I K S) (h : instalarFirmada verify s p = some t) :
    t.historial = s.historial ++ [p.epoca] ∧ t.predeterminada = s.predeterminada := by
  obtain ⟨hv, rfl⟩ := instalacion_exige_firmas verify s t p h
  exact ⟨by simpa only [hv.1] using rotacion_extiende_historial s p.nuevas, rfl⟩

omit [DecidableEq K] in
theorem propuesta_repetida_rechazada (verify : K → Mensaje I K → S → Bool)
    (s t : Estado I K) (p : Propuesta I K S) (h : instalarFirmada verify s p = some t) :
    instalarFirmada verify t p = none := by
  classical
  have he := (instalacion_epoca_exacta verify s t p h).1
  have hn : ¬ Valida verify t p := by
    intro hv
    have hp := hv.1
    omega
  simp only [instalarFirmada, hn, ite_false]

omit [DecidableEq K] in
theorem falta_firma_rechaza_lote (verify : K → Mensaje I K → S → Bool)
    (s : Estado I K) (p : Propuesta I K S) (i : I) (vieja nueva : K)
    (hv : s.claves i = some vieja) (hn : p.nuevas i = some nueva)
    (hf : verify vieja (p.epoca, p.nuevas) (p.salientes i) = false ∨
      verify nueva (p.epoca, p.nuevas) (p.entrantes i) = false) : instalarFirmada verify s p = none := by
  classical
  have hbad : ¬ Valida verify s p := by
    intro h
    have hs := h.2.2 i vieja nueva hv hn
    rcases hf with hf | hf <;> simp_all
  simp only [instalarFirmada, hbad, ite_false]

omit [DecidableEq K] in
theorem identidades_preservadas (verify : K → Mensaje I K → S → Bool)
    (s t : Estado I K) (p : Propuesta I K S) (h : instalarFirmada verify s p = some t) :
    ∀ i, (∃ key, t.claves i = some key) ↔ ∃ key, s.claves i = some key := by
  obtain ⟨hv, rfl⟩ := instalacion_exige_firmas verify s t p h
  exact rotacion_preserva_identidades s p.nuevas hv.2.1

end Nexus.Cripto.Epocas.Firmada
