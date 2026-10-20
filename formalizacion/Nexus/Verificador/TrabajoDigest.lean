module

public import Nexus.Verificador.Completo
public import Nexus.ROM.PromediosCompletaciones
public import Nexus.ROM.ExcepcionesPrefijo
import Mathlib.Tactic

/-!
# Masa exacta del predicado de trabajo del verificador

Se cuentan los octetos completos, no una variable de trabajo postulada.
Los dos parámetros admitidos por Forma (12 y 20) tienen masa 2^(-bits).
La ley de prefijo solo requiere frescura real de la dirección consultada;
no se condiciona a aceptación futura ni a SinBad.
-/

public section
namespace Nexus.Verificador.TrabajoDigest

open Nexus.Bytes Nexus.Merkle Nexus.N06 Nexus.ROM
open PromediosCompletaciones FrescuraFinita
open scoped BigOperators

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def separar (n : ℕ) :
    List.Vector Octeto (n + 1) ≃ Octeto × List.Vector Octeto n where
  toFun v := (v.head, v.tail)
  invFun v := List.Vector.cons v.1 v.2
  left_inv := List.Vector.cons_head_tail
  right_inv v := by cases v; simp

@[expose] noncomputable def masa (n bits : ℕ) : ℚ :=
  promedio (fun v : List.Vector Octeto n => if bits ≤ Completo.ceros v.val then 1 else 0)

theorem masa_paso (n bits : ℕ) :
    masa (n + 1) bits = promedio (fun b : Octeto => promedio
      (fun v : List.Vector Octeto n => if bits ≤ Completo.ceros (b :: v.val) then (1 : ℚ) else 0)) := by
  unfold masa
  rw [← media_equivalencia (separar n).symm
    (fun v : List.Vector Octeto (n + 1) => if bits ≤ Completo.ceros v.val then 1 else 0)]
  exact promedio_producto _

theorem ceros_ocho (b : Octeto) (bs : List Octeto) (bits : ℕ) :
    8 + bits ≤ Completo.ceros (b :: bs) ↔ b.val = 0 ∧ bits ≤ Completo.ceros bs := by
  simp only [Completo.ceros]
  split_ifs <;> omega

theorem ceros_cuatro (b : Octeto) (bs : List Octeto) :
    4 ≤ Completo.ceros (b :: bs) ↔ b.val < 16 := by
  have h : ∀ b : Fin 256, (4 ≤ 7 - Nat.log2 b.val ↔ b.val < 16) := by decide
  simp only [Completo.ceros]
  split_ifs with hb
  · omega
  · exact h b

theorem masa_ocho (n bits : ℕ) : masa (n + 1) (8 + bits) = masa n bits / 256 := by
  rw [masa_paso]
  have he (b : Octeto) : promedio
      (fun v : List.Vector Octeto n => if 8 + bits ≤ Completo.ceros (b :: v.val) then (1 : ℚ) else 0) =
      if b = 0 then masa n bits else 0 := by
    by_cases hb : b = 0
    · subst b
      simp only [ceros_ocho, Fin.val_zero, true_and, ite_true, masa]
    · have hval : b.val ≠ 0 := fun h => hb (Fin.ext h)
      simp only [ceros_ocho, hval, false_and, ite_false, hb]
      exact promedio_constante 0
  simp_rw [he]
  simp [promedio, Octeto]

theorem masa_cuatro (n : ℕ) : masa (n + 1) 4 = 1 / 16 := by
  let _ : Nonempty (List.Vector Octeto n) := ⟨⟨List.replicate n 0, List.length_replicate ..⟩⟩
  rw [masa_paso]
  simp_rw [ceros_cuatro, promedio_constante]
  have hset : (Finset.univ.filter (fun b : Octeto => b.val < 16)) =
      Finset.Iio (⟨16, by decide⟩ : Fin 256) := by
    ext b
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_Iio, Fin.lt_def]
  simp only [promedio, ← Finset.sum_filter, Finset.sum_const, nsmul_eq_mul, mul_one,
    hset, Fin.card_Iio, Fintype.card_fin]
  norm_num

theorem masa_doce : masa 32 12 = 1 / (2 : ℚ) ^ 12 := by
  have h := masa_ocho 31 4
  rw [masa_cuatro 30] at h
  norm_num at h ⊢
  exact h

theorem masa_veinte : masa 32 20 = 1 / (2 : ℚ) ^ 20 := by
  have h := masa_ocho 31 12
  have h' := masa_ocho 30 4
  rw [masa_cuatro 29] at h'
  rw [h'] at h
  norm_num at h ⊢
  exact h

theorem masa_trabajo (bits : ℕ) (hbits : bits = 12 ∨ bits = 20) :
    promedio (fun d : Digest => if Completo.trabajo bits d = true then (1 : ℚ) else 0) =
      1 / (2 : ℚ) ^ bits := by
  have he : (fun d : Digest => if Completo.trabajo bits d = true then (1 : ℚ) else 0) =
      (fun d : List.Vector Octeto 32 => if bits ≤ Completo.ceros d.val then 1 else 0) := by
    funext d
    simp only [Completo.trabajo, decide_eq_true_eq]
  rw [he]
  change masa 32 bits = _
  rcases hbits with rfl | rfl
  · exact masa_doce
  · exact masa_veinte

theorem ley_prefijo {Q X : Type} [Fintype Q] [DecidableEq Q]
    (H : Q → Digest) (p : LeyArbol.Arbol Q Digest X) (n bits : ℕ)
    (direccion : List (Q × Digest) → Q) (hbits : bits = 12 ∨ bits = 20)
    (hq : direccion (ObservacionesPrefijo.prefijo p n H) ∉ PrefijosGlobales.vistas H p n) :
    promedio (fun G : PrefijosGlobales.Tablas H p n =>
      if Completo.trabajo bits (G.val (direccion (ObservacionesPrefijo.prefijo p n G.val))) = true
        then (1 : ℚ) else 0) = 1 / (2 : ℚ) ^ bits := by
  rw [ExcepcionesPrefijo.ley_respuesta H p n direccion
    (fun _ d => if Completo.trabajo bits d = true then 1 else 0) hq]
  exact masa_trabajo bits hbits

theorem ley_dos_frescas {Q A : Type} [Fintype Q] [DecidableEq Q] [Fintype A]
    (S : Finset Q) (v : Q → A) (qw qn : Q)
    (hw : qw ∉ S) (hn : qn ∉ S) (hne : qn ≠ qw) (f : A → A → ℚ) :
    promedio (fun G : Completaciones S v => f (G.val qw) (G.val qn)) =
      promedio (fun a : A => promedio (fun b : A => f a b)) := by
  rw [media_revelar S v qw hw (fun G => f (G qw) (G qn))]
  congr 1
  funext a
  have hn' : qn ∉ insert qw S := by simpa only [Finset.mem_insert, not_or] using And.intro hne hn
  rw [media_revelar (insert qw S) (Function.update v qw a) qn hn' (fun G => f (G qw) (G qn))]
  congr 1
  funext b
  let v' := Function.update (Function.update v qw a) qn b
  let _ : Nonempty (Completaciones (insert qn (insert qw S)) v') :=
    ⟨⟨v', by intro _ _; rfl⟩⟩
  have he : (fun G : Completaciones (insert qn (insert qw S)) v' => f (G.val qw) (G.val qn)) =
      (fun _ => f a b) := by
    funext G
    have hqw := G.property qw (Finset.mem_insert_of_mem (Finset.mem_insert_self _ _))
    have hqn := G.property qn (Finset.mem_insert_self _ _)
    dsimp only [v'] at hqw hqn
    simp only [Function.update_of_ne hne.symm, Function.update_self] at hqw hqn
    rw [hqw, hqn]
  rw [he]
  exact promedio_constante _

theorem ley_trabajo_y_respuesta {Q : Type} [Fintype Q] [DecidableEq Q]
    (S : Finset Q) (v : Q → Digest) (qw qn : Q) (bits : ℕ)
    (hw : qw ∉ S) (hn : qn ∉ S) (hne : qn ≠ qw) (hbits : bits = 12 ∨ bits = 20)
    (f : Digest → ℚ) :
    promedio (fun G : Completaciones S v =>
      if Completo.trabajo bits (G.val qw) = true then f (G.val qn) else 0) =
      (1 / (2 : ℚ) ^ bits) * promedio f := by
  rw [ley_dos_frescas S v qw qn hw hn hne
    (fun a b => if Completo.trabajo bits a = true then f b else 0)]
  have he (d : Digest) : promedio (fun b : Digest =>
      if Completo.trabajo bits d = true then f b else 0) =
      (if Completo.trabajo bits d = true then (1 : ℚ) else 0) * promedio f := by
    split_ifs <;> simp [promedio_constante]
  simp_rw [he]
  simp only [promedio, ← Finset.sum_mul, ← div_mul_eq_mul_div]
  change promedio (fun d : Digest => if Completo.trabajo bits d = true then (1 : ℚ) else 0) * _ = _
  rw [masa_trabajo bits hbits]

end Nexus.Verificador.TrabajoDigest
