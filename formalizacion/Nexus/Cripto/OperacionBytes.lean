module

public import Nexus.Bytes.LittleEndian
public import Nexus.Merkle.Codificacion
import Mathlib.Tactic

/-!
# Bytes de operación de registry.rs

El dominio ASCII NEXUS_KEY_OPERATION_V1 precede 32 bytes de identidad,
ocho de época, ocho de longitud y el mensaje. La longitud debe caber en u64
para interpretarla como tal. No es el codec bincode de transacciones TG1.
-/

public section
namespace Nexus.Cripto.OperacionBytes

open Nexus.Bytes Nexus.Merkle

@[expose] def dominio : List Octeto :=
  [78, 69, 88, 85, 83, 95, 75, 69, 89, 95, 79, 80, 69, 82, 65, 84, 73, 79, 78, 95, 86, 49]

structure Operacion where
  identidad : Digest
  epoca : Fin (2 ^ 64)
  mensaje : List Octeto

@[expose] def codificar (op : Operacion) : List Octeto :=
  dominio ++ (op.identidad.val ++ (codificarLE 8 op.epoca.val ++
    (codificarLE 8 op.mensaje.length ++ op.mensaje)))

theorem dominio_longitud : dominio.length = 22 := rfl

theorem longitud_operacion (op : Operacion) : (codificar op).length = 70 + op.mensaje.length := by
  simp only [codificar, List.length_append, dominio_longitud, op.identidad.property, codificar_le_longitud]
  omega

theorem identidad_recuperada (op : Operacion) : ((codificar op).drop 22).take 32 = op.identidad.val := by
  rw [codificar, List.drop_left' dominio_longitud, List.take_left' op.identidad.property]

theorem epoca_recuperada (op : Operacion) :
    leerLE (((codificar op).drop 54).take 8) = op.epoca.val := by
  have hl : (dominio ++ op.identidad.val).length = 54 := by
    simp only [List.length_append, dominio_longitud, op.identidad.property]
  have he : (codificar op).drop 54 = codificarLE 8 op.epoca.val ++
      (codificarLE 8 op.mensaje.length ++ op.mensaje) := by
    unfold codificar
    rw [← List.append_assoc, List.drop_left' hl]
  rw [he, List.take_left' (codificar_le_longitud 8 _)]
  exact leer_le_codificar 8 _ (by simpa only [show 256 ^ 8 = 2 ^ 64 from rfl] using op.epoca.isLt)

theorem mensaje_recuperado (op : Operacion) : (codificar op).drop 70 = op.mensaje := by
  have hl : (dominio ++ op.identidad.val ++ codificarLE 8 op.epoca.val ++
      codificarLE 8 op.mensaje.length).length = 70 := by
    simp only [List.length_append, dominio_longitud, op.identidad.property, codificar_le_longitud]
  unfold codificar
  rw [← List.append_assoc, ← List.append_assoc, ← List.append_assoc, List.drop_left' hl]

theorem codificacion_inyectiva : Function.Injective codificar := by
  intro a b h
  have hi := congrArg (fun bs => (bs.drop 22).take 32) h
  have he := congrArg (fun bs => leerLE ((bs.drop 54).take 8)) h
  have hm := congrArg (fun bs => bs.drop 70) h
  simp only [identidad_recuperada] at hi
  simp only [epoca_recuperada] at he
  simp only [mensaje_recuperado] at hm
  cases a
  cases b
  have hd := Subtype.ext hi
  have hep := Fin.ext he
  cases hd
  cases hep
  cases hm
  rfl

theorem cambio_campo_exige_otros_bytes (a b : Operacion) (h : a ≠ b) : codificar a ≠ codificar b :=
  fun he => h (codificacion_inyectiva he)

end Nexus.Cripto.OperacionBytes
