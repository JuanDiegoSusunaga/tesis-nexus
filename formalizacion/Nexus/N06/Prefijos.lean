module

public import Nexus.N06.Estado
import Mathlib.Tactic

/-!
# Prefijos finitos y extensión cronológica de un reto

El reto nuevo se añade al final. El estado y la marca se reconstruyen
desde el prefijo; no se aceptan marcas declaradas por el probador.
-/

public section
namespace Nexus.N06

variable {K S : Type*}

@[expose] def listaRetos : {n : ℕ} → Retos K n → List K
  | 0, _ => []
  | _ + 1, xs => xs.1 :: listaRetos xs.2

@[expose] def anexarReto : {n : ℕ} → Retos K n → K → Retos K (n + 1)
  | 0, _, x => (x, PUnit.unit)
  | _ + 1, xs, x => (xs.1, anexarReto xs.2 x)

theorem lista_retos_longitud {n : ℕ} (xs : Retos K n) : (listaRetos xs).length = n := by
  induction n with
  | zero => rfl
  | succ n ih => simpa only [listaRetos, List.length_cons] using congrArg (· + 1) (ih xs.2)

theorem lista_retos_anexar {n : ℕ} (xs : Retos K n) (x : K) :
    listaRetos (anexarReto xs x) = listaRetos xs ++ [x] := by
  induction n with
  | zero => rfl
  | succ n ih => simpa only [anexarReto, listaRetos, List.cons_append] using congrArg (xs.1 :: ·) (ih xs.2)

theorem lista_retos_historia [Zero K] {n : ℕ} (xs : Retos K n) :
    listaRetos xs = Nexus.FRI.historia (reto xs) n := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rcases xs with ⟨x, xs⟩
    rw [historia_retos_cons]
    exact congrArg (x :: ·) (ih xs)

@[expose] def recorrerEstado (paso : ℕ → S → K → S) :
    (i n : ℕ) → S → Retos K n → S
  | _, 0, s, _ => s
  | i, n + 1, s, xs => recorrerEstado paso (i + 1) n (paso i s xs.1) xs.2

theorem recorrer_estado_anexar (paso : ℕ → S → K → S) (i n : ℕ)
    (s : S) (xs : Retos K n) (x : K) :
    recorrerEstado paso i (n + 1) s (anexarReto xs x) =
      paso (i + n) (recorrerEstado paso i n s xs) x := by
  induction n generalizing i s with
  | zero => simp only [anexarReto, recorrerEstado, Nat.add_zero]
  | succ n ih =>
    simpa only [anexarReto, recorrerEstado, Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using
      ih (i + 1) (paso i s xs.1) xs.2

theorem recorrer_estado_historia (i n : ℕ) (h : List K) (xs : Retos K n) :
    recorrerEstado (fun _ h x => h ++ [x]) i n h xs = h ++ listaRetos xs := by
  induction n generalizing i h with
  | zero => simp only [recorrerEstado, listaRetos, List.append_nil]
  | succ n ih =>
    simpa only [recorrerEstado, listaRetos, List.append_assoc, List.singleton_append] using
      ih (i + 1) (h ++ [xs.1]) xs.2

theorem recorrer_marca_anexar [DecidableEq K] (E : ℕ → S → Finset K)
    (paso : ℕ → S → K → S) (i n : ℕ) (s : S) (b : Bool) (xs : Retos K n) (x : K) :
    recorrerMarca E paso i (n + 1) s b (anexarReto xs x) =
      actualizarMarca (recorrerMarca E paso i n s b xs)
        (x ∈ E (i + n) (recorrerEstado paso i n s xs)) := by
  induction n generalizing i s b with
  | zero => rfl
  | succ n ih =>
    convert
      ih (i + 1) (paso i s xs.1) (actualizarMarca b (xs.1 ∈ E i s)) xs.2
      using 1 <;> simp only [anexarReto, recorrerMarca, recorrerEstado,
        Nat.add_comm, Nat.add_left_comm]; rfl

end Nexus.N06
