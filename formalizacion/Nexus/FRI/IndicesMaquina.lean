module

public import Nexus.FRI.FormasLimites
public import Init.Data.UInt.Lemmas
import Mathlib.Tactic

/-!
# Posiciones AIR en enteros de máquina

Las operaciones USize de Lean se comparan con los naturales para los seis
índices AIR del perfil TG2. Las sumas intermedias caben incluso en 32 bits,
por tanto no dependen de elegir arquitectura de 64 bits. Esto no verifica
el compilador Rust, el parser ni el resto de operaciones del verificador.
-/

public section
namespace Nexus.Goldilocks.IndicesMaquina

theorem conversion_exacta (a : ℕ) (ha : a < 2 ^ 32) : (USize.ofNat a).toNat = a :=
  USize.toNat_ofNat_of_lt_32 ha

theorem suma_exacta (a b : ℕ) (hab : a + b < 2 ^ 32) :
    (USize.ofNat a + USize.ofNat b).toNat = a + b := by
  rw [← USize.ofNat_add]
  exact conversion_exacta _ hab

theorem division_exacta (a b : ℕ) (ha : a < 2 ^ 32) (hb : b < 2 ^ 32) :
    USize.ofNat a / USize.ofNat b = USize.ofNat (a / b) := by
  apply USize.toNat_inj.mp
  rw [USize.toNat_div, conversion_exacta _ ha, conversion_exacta _ hb,
    conversion_exacta _ ((Nat.div_le_self _ _).trans_lt ha)]

theorem modulo_exacto (a b : ℕ) (ha : a < 2 ^ 32) (hb : b < 2 ^ 32) :
    USize.ofNat a % USize.ofNat b = USize.ofNat (a % b) := by
  apply USize.toNat_inj.mp
  rw [USize.toNat_mod, conversion_exacta _ ha, conversion_exacta _ hb,
    conversion_exacta _ ((Nat.mod_le _ _).trans_lt ha)]

@[expose] def posicionesNaturales (n i : ℕ) : Fin 6 → ℕ :=
  ![i, (i + 8) % n, (i + 16) % n, i + n / 2,
    (i + n / 2 + 8) % n, (i + n / 2 + 16) % n]

@[expose] def posicionesMaquina (n i : ℕ) : Fin 6 → USize :=
  ![USize.ofNat i, (USize.ofNat i + USize.ofNat 8) % USize.ofNat n,
    (USize.ofNat i + USize.ofNat 16) % USize.ofNat n,
    USize.ofNat i + USize.ofNat n / USize.ofNat 2,
    (USize.ofNat i + USize.ofNat n / USize.ofNat 2 + USize.ofNat 8) % USize.ofNat n,
    (USize.ofNat i + USize.ofNat n / USize.ofNat 2 + USize.ofNat 16) % USize.ofNat n]

theorem intermedios_en_rango (n i : ℕ) (hn : n ≤ 32768) (hi : i < n / 2) :
    i + n / 2 + 16 < 2 ^ 32 := by omega

/-- Las seis posiciones calculadas con USize coinciden exactamente con las naturales. -/
theorem posiciones_corresponden (n i : ℕ) (hn0 : 0 < n) (hn : n ≤ 32768)
    (hi : i < n / 2) (j : Fin 6) :
    (posicionesMaquina n i j).toNat = posicionesNaturales n i j := by
  have hn32 : n < 2 ^ 32 := by omega
  have hmax := intermedios_en_rango n i hn hi
  have hdiv := division_exacta n 2 hn32 (by decide)
  fin_cases j
  · change (USize.ofNat i).toNat = i
    exact conversion_exacta _ (by omega)
  · change ((USize.ofNat i + USize.ofNat 8) % USize.ofNat n).toNat = (i + 8) % n
    rw [← USize.ofNat_add, modulo_exacto _ _ (by omega) hn32,
      conversion_exacta _ ((Nat.mod_lt _ hn0).trans hn32)]
  · change ((USize.ofNat i + USize.ofNat 16) % USize.ofNat n).toNat = (i + 16) % n
    rw [← USize.ofNat_add, modulo_exacto _ _ (by omega) hn32,
      conversion_exacta _ ((Nat.mod_lt _ hn0).trans hn32)]
  · change (USize.ofNat i + USize.ofNat n / USize.ofNat 2).toNat = i + n / 2
    rw [hdiv, ← USize.ofNat_add, conversion_exacta _ (by omega)]
  · change ((USize.ofNat i + USize.ofNat n / USize.ofNat 2 + USize.ofNat 8) % USize.ofNat n).toNat =
      (i + n / 2 + 8) % n
    rw [hdiv, ← USize.ofNat_add, ← USize.ofNat_add, modulo_exacto _ _ (by omega) hn32,
      conversion_exacta _ ((Nat.mod_lt _ hn0).trans hn32)]
  · change ((USize.ofNat i + USize.ofNat n / USize.ofNat 2 + USize.ofNat 16) % USize.ofNat n).toNat =
      (i + n / 2 + 16) % n
    rw [hdiv, ← USize.ofNat_add, ← USize.ofNat_add, modulo_exacto _ _ (by omega) hn32,
      conversion_exacta _ ((Nat.mod_lt _ hn0).trans hn32)]

theorem posiciones_perfil (k i : ℕ) (hk : k ≤ 12) (hi : i < 2 ^ (k + 3) / 2) (j : Fin 6) :
    (posicionesMaquina (2 ^ (k + 3)) i j).toNat = posicionesNaturales (2 ^ (k + 3)) i j :=
  posiciones_corresponden _ _ (by positivity) (Formas.dominio_perfil k hk) hi j

end Nexus.Goldilocks.IndicesMaquina
