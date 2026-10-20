module

public import Nexus.Canal.LecturaCadena
import Mathlib.Tactic

/-!
# Parámetros numéricos y constantes del candidato

Los anchos se verifican antes de usar la inyectividad little-endian. El
exponente se recupera de las filas, sin suponer que el hash sea inyectivo.
-/

public section
namespace Nexus.Canal.ParametrosRecuperados

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks
open Codecs GramaticaTG2

set_option maxHeartbeats 800000
set_option maxRecDepth 4096

abbrev Perfil := ℕ × ℕ × ℕ × ℕ × ℕ × ℕ

@[expose] def codecPerfil : Codec Perfil :=
  par (entero 2) (par (entero 4) (par (entero 8) (par (entero 8) (par (entero 8) (entero 8)))))

@[expose] def valoresPerfil (k bits : ℕ) : Perfil := (1, bits, 8 * 2 ^ k, 2 ^ k, 2 * 2 ^ k, 40)

theorem perfil_codificado (k bits : ℕ) :
    codecPerfil.codificar (valoresPerfil k bits) = (ProgramaTG2.perfil k bits).val := by
  simp only [codecPerfil, valoresPerfil, par, entero, ProgramaTG2.perfil, List.append_assoc]

theorem perfil_en_dominio (k bits : ℕ) (hk : k ≤ 29) (hb : bits < 256 ^ 4) :
    codecPerfil.dominio (valoresPerfil k bits) := by
  have hp : 2 ^ k ≤ 2 ^ 29 := Nat.pow_le_pow_right (by decide) hk
  change 1 < 256 ^ 2 ∧ bits < 256 ^ 4 ∧ 8 * 2 ^ k < 256 ^ 8 ∧
    2 ^ k < 256 ^ 8 ∧ 2 * 2 ^ k < 256 ^ 8 ∧ 40 < 256 ^ 8
  norm_num at hp ⊢
  omega

theorem perfil_leido (k bits : ℕ) (hk : k ≤ 29) (hb : bits < 256 ^ 4) :
    Lectura.exacto codecPerfil.leer (ProgramaTG2.perfil k bits).val = some (valoresPerfil k bits) := by
  rw [← perfil_codificado]
  exact lectura_completa codecPerfil _ (perfil_en_dominio k bits hk hb)

@[expose] def codecEnunciado : Codec (Fp × Fp × ℕ) := par campo (par campo (entero 8))

theorem enunciado_codificado (inicio salida : Fp) (k : ℕ) :
    codecEnunciado.codificar (inicio, salida, 2 ^ k) = (ProgramaTG2.enunciado inicio salida k).val := by
  simp only [codecEnunciado, par, campo, entero, ProgramaTG2.enunciado, List.append_assoc]

theorem enunciado_leido (inicio salida : Fp) (k : ℕ) (hk : k ≤ 29) :
    Lectura.exacto codecEnunciado.leer (ProgramaTG2.enunciado inicio salida k).val =
      some (inicio, salida, 2 ^ k) := by
  rw [← enunciado_codificado]
  apply lectura_completa
  have hp : 2 ^ k ≤ 2 ^ 29 := Nat.pow_le_pow_right (by decide) hk
  change True ∧ True ∧ 2 ^ k < 256 ^ 8
  norm_num at hp ⊢
  omega

structure DatosCanal where
  k : ℕ
  bits : ℕ
  inicio : Fp
  salida : Fp
  raiz : Digest
  rt : List Digest
  rc : List Digest
  vt : Fp2
  vc : Fp2
  nonce : Nonce

@[expose] def decodificar (p : LecturaCadena.Paquete) : Option DatosCanal := do
  let a ← Lectura.exacto codecPerfil.leer p.perfil.val
  let e ← Lectura.exacto codecEnunciado.leer p.enunciado.val
  if a.1 = 1 ∧ a.2.2.1 = 8 * e.2.2 ∧ a.2.2.2.1 = e.2.2 ∧
      a.2.2.2.2.1 = 2 * e.2.2 ∧ a.2.2.2.2.2 = 40 ∧ e.2.2 = 2 ^ (Nat.log2 e.2.2) then
    some ⟨Nat.log2 e.2.2, a.2.1, e.1, e.2.1, p.raiz, p.rt, p.rc, p.vt, p.vc, p.nonce⟩
  else none

@[expose] def leer (es : List (List Octeto)) : Option DatosCanal :=
  (LecturaCadena.leer es).bind decodificar

theorem paquete_decodificado (k bits : ℕ) (inicio salida : Fp) (r : Digest)
    (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) (hk : k ≤ 29) (hb : bits < 256 ^ 4) :
    decodificar ⟨ProgramaTG2.perfil k bits, ProgramaTG2.enunciado inicio salida k,
      r, rt, rc, vt, vc, n⟩ = some ⟨k, bits, inicio, salida, r, rt, rc, vt, vc, n⟩ := by
  simp only [decodificar, perfil_leido k bits hk hb, enunciado_leido inicio salida k hk,
    bind, Option.bind_some, valoresPerfil, Nat.log2_two_pow, and_self, ite_true]

theorem cadena_decodificada (H : List Octeto → Digest) (k bits : ℕ) (inicio salida : Fp)
    (r : Digest) (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) (hk : k ≤ 29) (hb : bits < 256 ^ 4) :
    leer (TrayectoTG2.cadena H k bits inicio salida r rt rc vt vc n) =
      some ⟨k, bits, inicio, salida, r, rt, rc, vt, vc, n⟩ := by
  rw [leer, LecturaCadena.cadena_leida, Option.bind_some]
  exact paquete_decodificado k bits inicio salida r rt rc vt vc n hk hb

theorem lectura_unica (es : List (List Octeto)) (a b : DatosCanal)
    (ha : leer es = some a) (hb : leer es = some b) : a = b := Option.some.inj (ha.symm.trans hb)

end Nexus.Canal.ParametrosRecuperados
