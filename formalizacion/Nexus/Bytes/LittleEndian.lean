module

public import Mathlib.Data.Fin.Basic
import Mathlib.Tactic

/-!
# Octetos y enteros little-endian de longitud fija

Cada octeto pertenece a Fin 256. La codificación usa residuos y cocientes
sucesivos en base 256; no usa enteros de máquina ni desbordamientos.
-/

public section
namespace Nexus.Bytes

abbrev Octeto := Fin 256

@[expose] def codificarLE : ℕ → ℕ → List Octeto
  | 0, _ => []
  | n + 1, x => ⟨x % 256, Nat.mod_lt _ (by decide)⟩ :: codificarLE n (x / 256)

@[expose] def leerLE : List Octeto → ℕ
  | [] => 0
  | b :: resto => b.val + 256 * leerLE resto

theorem codificar_le_longitud (n x : ℕ) : (codificarLE n x).length = n := by
  induction n generalizing x with
  | zero => rfl
  | succ n ih => simp only [codificarLE, List.length_cons, ih]

theorem leer_le_codificar (n x : ℕ) (hx : x < 256 ^ n) : leerLE (codificarLE n x) = x := by
  induction n generalizing x with
  | zero =>
    simp only [pow_zero] at hx
    have he : x = 0 := by omega
    subst x
    rfl
  | succ n ih =>
    have hdiv : x / 256 < 256 ^ n := by
      rw [pow_succ] at hx
      omega
    simp only [codificarLE, leerLE, ih (x / 256) hdiv]
    omega

theorem leer_le_cota (bs : List Octeto) : leerLE bs < 256 ^ bs.length := by
  induction bs with
  | nil => simp only [leerLE, List.length_nil, pow_zero]; omega
  | cons b resto ih =>
    have hb := b.isLt
    simp only [leerLE, List.length_cons, pow_succ]
    omega

theorem codificar_le_leer (bs : List Octeto) : codificarLE bs.length (leerLE bs) = bs := by
  induction bs with
  | nil => rfl
  | cons b resto ih =>
    have hb := b.isLt
    have hm : (b.val + 256 * leerLE resto) % 256 = b.val := by omega
    have hd : (b.val + 256 * leerLE resto) / 256 = leerLE resto := by omega
    simp only [List.length_cons, leerLE, codificarLE, hm, hd, ih]

theorem codificar_le_inyectiva (n : ℕ) {x y : ℕ} (hx : x < 256 ^ n) (hy : y < 256 ^ n)
    (h : codificarLE n x = codificarLE n y) : x = y := by
  have he := congrArg leerLE h
  simpa only [leer_le_codificar n x hx, leer_le_codificar n y hy] using he

end Nexus.Bytes
