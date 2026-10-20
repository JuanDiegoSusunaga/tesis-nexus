module

public import Mathlib.Algebra.Field.ZMod
public import Mathlib.RingTheory.RootsOfUnity.PrimitiveRoots
import Mathlib.Tactic

public section
namespace Nexus.MLDSA

/-- Constantes algebraicas de la tabla 6.1; no son una hipótesis de seguridad. -/
@[expose] def q : ℕ := 8380417
@[expose] def n : ℕ := 256

theorem formula_modulo : q = 2 ^ 23 - 2 ^ 13 + 1 := by norm_num [q]

theorem congruencia_ntt : q = (2 * n) * 16368 + 1 := by norm_num [q, n]

theorem modulo_primo : Nat.Prime q := by norm_num [q]

instance : Fact q.Prime := ⟨modulo_primo⟩

abbrev Fq := ZMod q

theorem cardinal_campo : Fintype.card Fq = q := ZMod.card q

theorem dimension_potencia_dos : n = 2 ^ 8 := by norm_num [n]

theorem divisibilidad_orden : 2 * n ∣ q - 1 := by norm_num [n, q]

/-- Raíz usada en la presentación NTT de ML-DSA, con orden certificado. -/
@[expose] def zeta : Fq := 1753

theorem potencia_raiz : zeta ^ 512 = 1 := by
  unfold zeta Fq q
  reduce_mod_char

theorem semipotencia_raiz : zeta ^ 256 = -1 := by
  unfold zeta Fq q
  reduce_mod_char

theorem raiz_primitiva : IsPrimitiveRoot zeta 512 := by
  apply IsPrimitiveRoot.iff_orderOf.mpr
  apply orderOf_eq_of_pow_and_pow_div_prime (by norm_num) potencia_raiz
  intro p hp hd
  have hp2 : p = 2 := (Nat.prime_dvd_prime_iff_eq hp Nat.prime_two).mp
    (hp.dvd_of_dvd_pow (show p ∣ 2 ^ 9 by norm_num at hd ⊢; exact hd))
  subst p
  norm_num only [Nat.reduceDiv]
  rw [semipotencia_raiz]
  decide

theorem raiz_negaciclica : zeta ^ n = -1 := by simpa [n] using semipotencia_raiz

theorem raiz_ciclica : IsPrimitiveRoot (zeta ^ 2) n := by
  exact raiz_primitiva.pow (by norm_num) (by norm_num [n])

/-- Los tres conjuntos tabulados se mantienen separados de sus categorías NIST. -/
inductive Perfil where
  | m44 | m65 | m87
  deriving DecidableEq

@[expose] def k : Perfil → ℕ | .m44 => 4 | .m65 => 6 | .m87 => 8
@[expose] def ell : Perfil → ℕ | .m44 => 4 | .m65 => 5 | .m87 => 7
@[expose] def eta : Perfil → ℕ | .m44 => 2 | .m65 => 4 | .m87 => 2
@[expose] def tau : Perfil → ℕ | .m44 => 39 | .m65 => 49 | .m87 => 60
@[expose] def beta : Perfil → ℕ | .m44 => 78 | .m65 => 196 | .m87 => 120
@[expose] def gammaUno : Perfil → ℕ | .m44 => 131072 | .m65 => 524288 | .m87 => 524288
@[expose] def gammaDos : Perfil → ℕ | .m44 => 95232 | .m65 => 261888 | .m87 => 261888
@[expose] def d : ℕ := 13
@[expose] def omega : Perfil → ℕ | .m44 => 80 | .m65 => 55 | .m87 => 75
@[expose] def bytesReto : Perfil → ℕ | .m44 => 32 | .m65 => 48 | .m87 => 64
@[expose] def bitsZ : Perfil → ℕ | .m44 => 18 | .m65 => 20 | .m87 => 20

/-- Cuentas del formato declarado; la correspondencia con codecs reales queda separada. -/
@[expose] def bytesPublica (p : Perfil) : ℕ := 32 + k p * (n * (23 - d) / 8)
@[expose] def bytesFirma (p : Perfil) : ℕ :=
  bytesReto p + ell p * (n * bitsZ p / 8) + omega p + k p

theorem dimensiones_positivas (p : Perfil) : 0 < k p ∧ 0 < ell p := by
  cases p <;> norm_num [k, ell]

theorem beta_producto (p : Perfil) : beta p = tau p * eta p := by
  cases p <;> norm_num [beta, tau, eta]

theorem gamma_uno_potencia (p : Perfil) :
    gammaUno p = if p = .m44 then 2 ^ 17 else 2 ^ 19 := by
  cases p <;> norm_num [gammaUno]

theorem gamma_dos_cociente (p : Perfil) :
    gammaDos p = (q - 1) / (if p = .m44 then 88 else 32) := by
  cases p <;> norm_num [gammaDos, q]

theorem margen_rechazo_positivo (p : Perfil) :
    beta p < gammaDos p ∧ beta p < gammaUno p := by
  cases p <;> norm_num [beta, gammaDos, gammaUno]

theorem productos_matriz (p : Perfil) :
    k p * ell p = match p with | .m44 => 16 | .m65 => 30 | .m87 => 56 := by
  cases p <;> norm_num [k, ell]

theorem ancho_z (p : Perfil) : gammaUno p = 2 ^ (bitsZ p - 1) := by
  cases p <;> norm_num [gammaUno, bitsZ]

theorem anchos_publicos : 23 - d = 10 ∧ n * (23 - d) / 8 = 320 := by
  norm_num [d, n]

theorem tamanos_publica (p : Perfil) :
    bytesPublica p = match p with | .m44 => 1312 | .m65 => 1952 | .m87 => 2592 := by
  cases p <;> norm_num [bytesPublica, k, n, d]

theorem tamanos_firma (p : Perfil) :
    bytesFirma p = match p with | .m44 => 2420 | .m65 => 3309 | .m87 => 4627 := by
  cases p <;> norm_num [bytesFirma, bytesReto, ell, n, bitsZ, omega, k]

end Nexus.MLDSA
