module

public import Nexus.N06.ReiniciosObservados
import Mathlib.Tactic

/-!
# Arreglos explícitos de oráculos emitidos

El oráculo inicial se guarda una sola vez. Las capas posteriores tienen
índices finitos y ninguna decisión futura forma parte de estos datos.
-/

public section
namespace Nexus.Goldilocks

@[ext] structure OraculosEmitidos (n : ℕ) where
  inicial : Fp2 → Fp2
  siguientes : Fin (n - 1) → Fp2 → Fp2

@[expose] def leerOraculo {n : ℕ} (d : OraculosEmitidos n) (i : ℕ) : Fp2 → Fp2 :=
  if i = 0 then d.inicial else if hi : i - 1 < n - 1 then d.siguientes ⟨i - 1, hi⟩ else fun _ => 0

@[expose] def capturarOraculos (n : ℕ) (f : ℕ → Fp2 → Fp2) : OraculosEmitidos n where
  inicial := f 0
  siguientes := fun j => f (j.val + 1)

theorem leer_oraculo_inicial {n : ℕ} (d : OraculosEmitidos n) : leerOraculo d 0 = d.inicial := by
  simp only [leerOraculo, ite_true]

theorem leer_oraculo_siguiente {n : ℕ} (d : OraculosEmitidos n) (j : Fin (n - 1)) :
    leerOraculo d (j.val + 1) = d.siguientes j := by
  simp only [leerOraculo, Nat.add_one_ne_zero, ite_false, Nat.add_sub_cancel,
    j.isLt, dite_true]

theorem leer_captura_oraculos (n : ℕ) (f : ℕ → Fp2 → Fp2) (i : ℕ) (hi : i < n) :
    leerOraculo (capturarOraculos n f) i = f i := by
  by_cases hz : i = 0
  · subst i
    exact leer_oraculo_inicial _
  · have hj : i - 1 < n - 1 := by omega
    have he : i - 1 + 1 = i := by omega
    simp only [leerOraculo, hz, ite_false, hj, dite_true, capturarOraculos, he]

theorem capturar_lectura_oraculos {n : ℕ} (d : OraculosEmitidos n) :
    capturarOraculos n (leerOraculo d) = d := by
  apply OraculosEmitidos.ext
  · exact leer_oraculo_inicial d
  · funext j
    exact leer_oraculo_siguiente d j

theorem captura_oraculos_igual_iff (n : ℕ) (f g : ℕ → Fp2 → Fp2) :
    capturarOraculos n f = capturarOraculos n g ↔ f 0 = g 0 ∧ ∀ i < n, f i = g i := by
  constructor
  · intro h
    refine ⟨congrArg OraculosEmitidos.inicial h, ?_⟩
    intro i hi
    have he := congrArg (fun d => leerOraculo d i) h
    simpa only [leer_captura_oraculos n f i hi, leer_captura_oraculos n g i hi] using he
  · rintro ⟨h0, h⟩
    apply OraculosEmitidos.ext h0
    funext j
    exact h (j.val + 1) (by omega)

end Nexus.Goldilocks
