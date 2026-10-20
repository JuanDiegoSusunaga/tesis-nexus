module

public import Nexus.Bytes.LittleEndian
import Mathlib.Tactic

public section
namespace Nexus.Cripto.Derivacion

open Nexus.Bytes

abbrev Semilla := {s : List Octeto // s.length = 32}
abbrev Contador64 := Fin (256 ^ 8)

@[expose] def dominioDerivar : List Octeto :=
  [78,69,88,85,83,95,83,69,78,84,73,78,69,76,95,68,69,82,73,86,69]

@[expose] def dominioRotar : List Octeto :=
  [78,69,88,85,83,95,83,69,78,84,73,78,69,76,95,82,79,84,65,84,69]

@[ext] structure Entrada where
  epoca : Contador64
  contador : Contador64
  semilla : Semilla
  contexto : List Octeto

/-- Formato de derive_key_unchecked: campos fijos y contexto en la cola. -/
@[expose] def codificar (x : Entrada) : List Octeto :=
  dominioDerivar ++ (codificarLE 8 x.epoca.val ++
    (codificarLE 8 x.contador.val ++ (x.semilla.val ++ x.contexto)))

theorem longitud_dominio_derivar : dominioDerivar.length = 21 := rfl
theorem longitud_dominio_rotar : dominioRotar.length = 21 := rfl
theorem limite_contador : 256 ^ 8 = 2 ^ 64 := by norm_num

theorem longitud_entrada (x : Entrada) : (codificar x).length = 69 + x.contexto.length := by
  simp only [codificar, List.length_append, longitud_dominio_derivar,
    codificar_le_longitud, x.semilla.property]
  omega

theorem codificacion_inyectiva : Function.Injective codificar := by
  intro x y h
  have hh := List.append_right_injective dominioDerivar h
  obtain ⟨he, hj⟩ := List.append_inj hh (by simp only [codificar_le_longitud])
  obtain ⟨hc, hs⟩ := List.append_inj hj (by simp only [codificar_le_longitud])
  obtain ⟨hseed, hctx⟩ := List.append_inj hs (by rw [x.semilla.property, y.semilla.property])
  apply Entrada.ext
  · exact Fin.ext (codificar_le_inyectiva 8 x.epoca.isLt y.epoca.isLt he)
  · exact Fin.ext (codificar_le_inyectiva 8 x.contador.isLt y.contador.isLt hc)
  · exact Subtype.ext hseed
  · exact hctx

theorem epoca_separa_entrada (x y : Entrada) (h : x.epoca ≠ y.epoca) : codificar x ≠ codificar y :=
  fun he => h (congrArg Entrada.epoca (codificacion_inyectiva he))

theorem contador_separa_entrada (x y : Entrada) (h : x.contador ≠ y.contador) : codificar x ≠ codificar y :=
  fun he => h (congrArg Entrada.contador (codificacion_inyectiva he))

theorem contexto_separa_entrada (x y : Entrada) (h : x.contexto ≠ y.contexto) : codificar x ≠ codificar y :=
  fun he => h (congrArg Entrada.contexto (codificacion_inyectiva he))

@[expose] def derivar (H : List Octeto → Semilla) (x : Entrada) : Semilla := H (codificar x)

theorem reproducibilidad (H : List Octeto → Semilla) (keyGen : Semilla → Semilla × Semilla)
    (x y : Entrada) (h : x = y) : keyGen (derivar H x) = keyGen (derivar H y) := by rw [h]

theorem separacion_o_colision (H : List Octeto → Semilla) (x y : Entrada)
    (hxy : x ≠ y) (h : derivar H x = derivar H y) :
    codificar x ≠ codificar y ∧ H (codificar x) = H (codificar y) :=
  ⟨fun he => hxy (codificacion_inyectiva he), h⟩

theorem determinismo_no_exige_inyectividad (s : Semilla) (x y : Entrada) :
    derivar (fun _ => s) x = derivar (fun _ => s) y := rfl

@[expose] def entradaRotar (anterior fresco : Semilla) (epoca : Contador64) : List Octeto :=
  dominioRotar ++ (anterior.val ++ (fresco.val ++ codificarLE 8 epoca.val))

theorem longitud_entrada_rotar (anterior fresco : Semilla) (epoca : Contador64) :
    (entradaRotar anterior fresco epoca).length = 93 := by
  simp only [entradaRotar, List.length_append, longitud_dominio_rotar,
    anterior.property, fresco.property, codificar_le_longitud]

theorem dominios_distintos : dominioDerivar ≠ dominioRotar := by decide

theorem derivar_rotar_separados (x : Entrada) (anterior fresco : Semilla) (epoca : Contador64) :
    codificar x ≠ entradaRotar anterior fresco epoca := by
  intro h
  have hh := List.append_inj_left h (by rw [longitud_dominio_derivar, longitud_dominio_rotar])
  exact dominios_distintos hh

end Nexus.Cripto.Derivacion
