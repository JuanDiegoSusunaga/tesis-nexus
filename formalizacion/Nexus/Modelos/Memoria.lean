module

public import Mathlib.Data.Nat.Basic
public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
public import Mathlib.Data.Fintype.Card
import Mathlib.Tactic

/-!
# Contabilidad de las representaciones de §5.6.1

Perfil ML-DSA-65 del inventario R5, fips204 0.4.6. Los números describen
representaciones declaradas: no prueban entropía, RAM total ni borrado físico.
-/

public section
namespace Nexus.Modelos.Memoria

open scoped BigOperators

@[expose] def semilla : ℕ := 32
@[expose] def privada : ℕ := 4032
@[expose] def publicaEnPrivada : ℕ := 96
@[expose] def sensible : ℕ := privada - publicaEnPrivada
@[expose] def publica : ℕ := 1952
@[expose] def cabeceras : ℕ := 9
@[expose] def parSerializado : ℕ := privada + publica + cabeceras
@[expose] def objetoBackend : ℕ := 128 + 17 * 256 * 4

theorem bytes_sensibles : sensible = 3936 := by norm_num [sensible, privada, publicaEnPrivada]
theorem descomposicion_privada : sensible + publicaEnPrivada = privada := by
  norm_num [sensible, privada, publicaEnPrivada]
theorem bytes_par_serializado : parSerializado = 5993 := by
  norm_num [parSerializado, privada, publica, cabeceras]
theorem bytes_objeto_backend : objetoBackend = 17536 := by norm_num [objetoBackend]
theorem contenedor_incluye_publicos : sensible < privada := by
  norm_num [sensible, privada, publicaEnPrivada]
theorem bytes_cacheados : semilla + privada = 4064 := by norm_num [semilla, privada]
theorem par_no_es_solo_privada : privada < parSerializado := by
  norm_num [parSerializado, privada, publica, cabeceras]
theorem backend_no_es_codificacion : privada < objetoBackend := by
  norm_num [privada, objetoBackend]
theorem copias_suman (n b : ℕ) : (∑ _i : Fin n, b) = n * b := by simp
theorem una_copia_adicional (n b : ℕ) : (n + 1) * b = n * b + b := by ring
theorem regiones_adicionales_no_reducen (base extras : ℕ) : base ≤ base + extras := by omega

end Nexus.Modelos.Memoria
