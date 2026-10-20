module

public import Nexus.FRI.Recorrido
public import Nexus.ROM.Presupuestos
import Mathlib.Tactic

/-!
# Formas admitidas e índices en el perfil finito de TG2

Las cotas se especializan a k<=12. Demuestran que los naturales usados
para tamaños, mitades y posiciones caben en 64 bits; la correspondencia
con operaciones de máquina y todos los rechazos Rust sigue explícita.
-/

public section
namespace Nexus.Goldilocks.Formas

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks.Recorrido

theorem dominio_u64 (k : ℕ) (hk : k ≤ 12) : 2 ^ (k + 3) < (2 : ℕ) ^ 64 :=
  Nat.pow_lt_pow_right (by decide) (by omega)

theorem dominio_perfil (k : ℕ) (hk : k ≤ 12) : 2 ^ (k + 3) ≤ (32768 : ℕ) := by
  exact Nat.pow_le_pow_right (by decide) (by omega : k + 3 ≤ 15)

theorem mitad_positiva (k j : ℕ) : 0 < mitad k j := by unfold mitad; positivity

theorem parejas_en_rango (k j pos : ℕ) (hj : j < k + 3) :
    pos % mitad k j < 2 ^ (k + 3 - j) ∧
      pos % mitad k j + mitad k j < 2 ^ (k + 3 - j) := by
  have hm := Nat.mod_lt pos (mitad_positiva k j)
  have hs := tamano_capa_siguiente k j hj
  change 2 ^ (k + 3 - j) = 2 * mitad k j at hs
  omega

theorem pareja_sin_desbordamiento (k j pos : ℕ) (hk : k ≤ 12) (hj : j < k + 3) :
    pos % mitad k j + mitad k j < (2 : ℕ) ^ 64 := by
  have hp := (parejas_en_rango k j pos hj).2
  have hs : 2 ^ (k + 3 - j) ≤ (2 : ℕ) ^ (k + 3) :=
    Nat.pow_le_pow_right (by decide) (Nat.sub_le _ _)
  exact hp.trans_le hs |>.trans (dominio_u64 k hk)

theorem lecturas_dentro_de_listas (H : List Octeto → Digest) (k m pos : ℕ)
    (rs : List Digest) (bs : List Fp2) (ds : List Apertura) (c : Fp2)
    (ha : verificarConsulta H k m pos rs bs ds c = true) (j : ℕ) (hj : j < m) :
    j < rs.length ∧ j < bs.length ∧ j < ds.length := by
  have hs := verificador_formas H k m pos rs bs ds c ha
  omega

theorem zip_cubre_todas {A B : Type*} (pruebas : List A) (indices : List B)
    (h : pruebas.length = indices.length) : (pruebas.zip indices).length = pruebas.length := by
  simp only [List.length_zip, h, min_self]

theorem zip_cuarenta {A B : Type*} (pruebas : List A) (indices : List B)
    (hp : pruebas.length = 40) (hi : indices.length = 40) :
    (pruebas.zip indices).length = 40 := by simp only [List.length_zip, hp, hi, min_self]

theorem longitud_incorrecta_rechazada (H : List Octeto → Digest) (k m pos : ℕ)
    (rs : List Digest) (bs : List Fp2) (ds : List Apertura) (c : Fp2)
    (h : rs.length ≠ m ∨ bs.length ≠ m ∨ ds.length ≠ m) :
    verificarConsulta H k m pos rs bs ds c = false := by
  classical
  unfold verificarConsulta
  have hn : ¬ (rs.length = m ∧ bs.length = m ∧ ds.length = m) := by tauto
  rw [ite_eq_right hn]

end Nexus.Goldilocks.Formas
