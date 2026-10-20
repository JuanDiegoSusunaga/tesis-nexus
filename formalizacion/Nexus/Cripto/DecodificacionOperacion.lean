module

public import Nexus.Cripto.OperacionBytes
import Mathlib.Tactic

/-!
# Parser del sobre de operación

Se comprueban dominio, cabecera completa y longitud declarada exacta.
El parser acepta los sobres canónicos y rechaza truncamientos y longitudes
incorrectas. No se identifica con un deserializador bincode de TG1.
-/

public section
namespace Nexus.Cripto.OperacionBytes.Parser

open Nexus.Bytes Nexus.Merkle

@[expose] def Forma (bs : List Octeto) : Prop :=
  70 ≤ bs.length ∧ bs.take 22 = dominio ∧
    leerLE ((bs.drop 62).take 8) = (bs.drop 70).length

instance (bs : List Octeto) : Decidable (Forma bs) := by unfold Forma; infer_instance

theorem ventana_ocho (bs : List Octeto) (i : ℕ) (h : i + 8 ≤ bs.length) :
    ((bs.drop i).take 8).length = 8 := by
  simp only [List.length_take, List.length_drop]
  omega

@[expose] def campos (bs : List Octeto) (h : Forma bs) : Operacion where
  identidad := ⟨(bs.drop 22).take 32, by
    have hh := h.1
    simp only [List.length_take, List.length_drop]
    omega⟩
  epoca := ⟨leerLE ((bs.drop 54).take 8), by
    have hl := ventana_ocho bs 54 (by have hh := h.1; omega)
    have hc := leer_le_cota ((bs.drop 54).take 8)
    rw [hl] at hc
    exact hc⟩
  mensaje := bs.drop 70

@[expose] def decodificar (bs : List Octeto) : Option Operacion :=
  if h : Forma bs then some (campos bs h) else none

theorem longitud_recuperada (op : Operacion) (h : op.mensaje.length < 2 ^ 64) :
    leerLE (((codificar op).drop 62).take 8) = op.mensaje.length := by
  have hl : (dominio ++ op.identidad.val ++ codificarLE 8 op.epoca.val).length = 62 := by
    simp only [List.length_append, dominio_longitud, op.identidad.property, codificar_le_longitud]
  have he : (codificar op).drop 62 = codificarLE 8 op.mensaje.length ++ op.mensaje := by
    unfold codificar
    rw [← List.append_assoc, ← List.append_assoc, List.drop_left' hl]
  rw [he, List.take_left' (codificar_le_longitud 8 _)]
  exact leer_le_codificar 8 _ h

theorem forma_codificada (op : Operacion) (h : op.mensaje.length < 2 ^ 64) : Forma (codificar op) := by
  refine ⟨by rw [longitud_operacion]; omega, ?_, ?_⟩
  · unfold codificar
    exact List.take_left' dominio_longitud
  · rw [longitud_recuperada op h, mensaje_recuperado]

theorem recodificar_campos (bs : List Octeto) (h : Forma bs) : codificar (campos bs h) = bs := by
  have he := codificar_le_leer ((bs.drop 54).take 8)
  rw [ventana_ocho bs 54 (by have hh := h.1; omega)] at he
  have hl := codificar_le_leer ((bs.drop 62).take 8)
  rw [ventana_ocho bs 62 (by have hh := h.1; omega), h.2.2] at hl
  have h1 : (bs.drop 62).take 8 ++ bs.drop 70 = bs.drop 62 := by
    simpa only [List.drop_drop] using List.take_append_drop 8 (bs.drop 62)
  have h2 : (bs.drop 54).take 8 ++ bs.drop 62 = bs.drop 54 := by
    simpa only [List.drop_drop] using List.take_append_drop 8 (bs.drop 54)
  have h3 : (bs.drop 22).take 32 ++ bs.drop 54 = bs.drop 22 := by
    simpa only [List.drop_drop] using List.take_append_drop 32 (bs.drop 22)
  change dominio ++ ((bs.drop 22).take 32 ++
    (codificarLE 8 (leerLE ((bs.drop 54).take 8)) ++
      (codificarLE 8 (bs.drop 70).length ++ bs.drop 70))) = bs
  rw [he, hl, h1, h2, h3, ← h.2.1, List.take_append_drop]

theorem decodificar_codificar (op : Operacion) (h : op.mensaje.length < 2 ^ 64) :
    decodificar (codificar op) = some op := by
  rw [decodificar, dite_eq_left (forma_codificada op h)]
  congr 1
  apply codificacion_inyectiva
  exact recodificar_campos _ _

theorem decodificacion_canonica (bs : List Octeto) (op : Operacion)
    (h : decodificar bs = some op) : codificar op = bs ∧ op.mensaje.length < 2 ^ 64 := by
  unfold decodificar at h
  split at h
  · rename_i hf
    have hop := Option.some.inj h
    subst op
    refine ⟨recodificar_campos bs hf, ?_⟩
    change (bs.drop 70).length < 2 ^ 64
    rw [← hf.2.2]
    have hc := leer_le_cota ((bs.drop 62).take 8)
    rw [ventana_ocho bs 62 (by have hh := hf.1; omega)] at hc
    exact hc
  · contradiction

theorem acepta_iff_forma (bs : List Octeto) : (∃ op, decodificar bs = some op) ↔ Forma bs := by
  by_cases h : Forma bs <;> simp [decodificar, h]

theorem truncamiento_rechazado (bs : List Octeto) (h : bs.length < 70) : decodificar bs = none := by
  have hn : ¬ Forma bs := fun hf => by have hh := hf.1; omega
  simp only [decodificar, dite_eq_right hn]

theorem dominio_incorrecto_rechazado (bs : List Octeto) (h : bs.take 22 ≠ dominio) :
    decodificar bs = none := by
  have hn : ¬ Forma bs := fun hf => h hf.2.1
  simp only [decodificar, dite_eq_right hn]

theorem longitud_incorrecta_rechazada (bs : List Octeto)
    (h : leerLE ((bs.drop 62).take 8) ≠ (bs.drop 70).length) : decodificar bs = none := by
  have hn : ¬ Forma bs := fun hf => h hf.2.2
  simp only [decodificar, dite_eq_right hn]

end Nexus.Cripto.OperacionBytes.Parser
