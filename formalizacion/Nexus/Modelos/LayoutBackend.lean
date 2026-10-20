module

public import Nexus.Modelos.Memoria
public import Nexus.MLDSA.Parametros
import Mathlib.Tactic

/-!
# Contabilidad de campos de PrivateKey en fips204-0.4.6

rho, cap_k y tr ocupan 32+32+64 bytes declarados; los tres arreglos
polinómicos tienen L,K,K elementos de 256 coeficientes i32. El modelo
calcula alineación y tamaños. No representa la semántica de sizeof Rust.
-/

public section
namespace Nexus.Modelos.Layout

open Nexus.MLDSA

@[expose] def campos (p : Perfil) : List ℕ :=
  [32, 32, 64, ell p * n * 4, k p * n * 4, k p * n * 4]

@[expose] def alinear8 (bytes : ℕ) : ℕ := ((bytes + 7) / 8) * 8

theorem suma_campos (p : Perfil) : (campos p).sum = 128 + (ell p + 2 * k p) * n * 4 := by
  simp only [campos, List.sum_cons, List.sum_nil]
  ring

theorem campos_alineados (p : Perfil) : ∀ b ∈ campos p, b % 8 = 0 := by
  cases p <;> simp [campos, k, ell, n]

theorem tamanos_perfiles (p : Perfil) : (campos p).sum =
    match p with | .m44 => 12416 | .m65 => 17536 | .m87 => 23680 := by
  cases p <;> norm_num [campos, k, ell, n]

theorem alineacion_no_agrega (p : Perfil) : alinear8 (campos p).sum = (campos p).sum := by
  cases p <;> norm_num [alinear8, campos, k, ell, n]

theorem perfil_65_corresponde_modelo : (campos .m65).sum = Nexus.Modelos.Memoria.objetoBackend := by
  norm_num [campos, k, ell, n, Nexus.Modelos.Memoria.objetoBackend]

theorem reordenar_conserva_cuenta (p : Perfil) (otra : List ℕ) (h : (campos p).Perm otra) :
    otra.sum = (campos p).sum := h.sum_eq.symm

end Nexus.Modelos.Layout
