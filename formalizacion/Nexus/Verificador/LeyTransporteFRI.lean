module

public import Nexus.ROM.PromediosCompletaciones
public import Nexus.ROM.ProyeccionDigest
public import Nexus.Canal.DesafiosPrograma
public import Nexus.N06.Solidez
public import Nexus.FRI.Adaptativo
import Mathlib.Tactic

/-!
# Interfaz para transportar una cota ROM a FRI

La distribuciÃ³n ideal de retos FRI y la distribuciÃ³n de tablas del orÃ¡culo
son espacios distintos. Este mÃ³dulo formaliza Ãºnicamente el contrato que se
necesita para transportar una cota entre ambos: una equivalencia de espacios y
una correspondencia punto a punto de los eventos. No construye todavÃ­a la
equivalencia para el ejecutable de la tesis.
-/

public section
namespace Nexus.Verificador.LeyTransporteFRI

open Nexus.ROM.PromediosCompletaciones
open Nexus.N06
open Nexus.Bytes Nexus.Goldilocks
attribute [local instance] Classical.propDecidable
attribute [local instance] Classical.decEq

structure Contrato {W X : Type*} [Fintype W] [Fintype X] where
  eventoROM : W → Prop
  eventoFRI : X → Prop
  transporte : W ≃ X
  correspondencia : ∀ w, eventoROM w ↔ eventoFRI (transporte w)

theorem media_evento {W X : Type*} [Fintype W] [Fintype X]
    (c : Contrato (W := W) (X := X)) :
    promedio (fun w => if c.eventoROM w then (1 : ℚ) else 0) =
      promedio (fun x => if c.eventoFRI x then (1 : ℚ) else 0) := by
  classical
  rw [← media_equivalencia c.transporte
    (fun x => if c.eventoFRI x then (1 : ℚ) else 0)]
  congr 1
  funext w
  by_cases h : c.eventoROM w
  · have hf := (c.correspondencia w).mp h
    simp only [h, hf, ite_true]
  · have hf : ¬ c.eventoFRI (c.transporte w) := by
      intro hf
      exact h ((c.correspondencia w).mpr hf)
    simp only [h, hf, ite_false]

theorem cota_rom_desde_fri {W X : Type*} [Fintype W] [Fintype X]
    (c : Contrato (W := W) (X := X)) (bound : ℚ)
    (hfri : promedio (fun x => if c.eventoFRI x then (1 : ℚ) else 0) ≤ bound) :
    promedio (fun w => if c.eventoROM w then (1 : ℚ) else 0) ≤ bound := by
  classical
  rw [media_evento c]
  exact hfri

/-!
La interfaz anterior exige una equivalencia de espacios finitos. El canal real
no la puede satisfacer ya en una sola respuesta: el digest tiene `2^256`
valores y el reto Fp2 tiene `p^2` valores, con `p` impar. El mapa concreto
usado por el canal es `DesafiosPrograma.extension`; su distribución inducida
no puede ser exactamente uniforme en Fp2 por esta obstrucción cardinal.
-/

def transporteRetoReal (d : Nexus.Merkle.Digest) : Fp2 :=
  Nexus.Canal.DesafiosPrograma.extension d

theorem transporteRetoReal_factoriza (d : Nexus.Merkle.Digest) :
    transporteRetoReal d =
      ⟨(Nexus.Canal.DesafiosPrograma.palabraBaja d : Fp),
        (Nexus.Canal.DesafiosPrograma.palabraAlta d : Fp)⟩ := by
  simpa only [transporteRetoReal] using
    Nexus.Canal.DesafiosPrograma.extension_factoriza d

abbrev tamanoPalabras : ℕ := 2 ^ 128

def separarPalabras (x : Fin (256 ^ 32)) : Fin tamanoPalabras × Fin tamanoPalabras :=
  ⟨⟨x.val % tamanoPalabras, Nat.mod_lt _ (by positivity)⟩,
    ⟨x.val / tamanoPalabras, by
      have hx := x.isLt
      have hmul : tamanoPalabras * (x.val / tamanoPalabras) ≤ x.val :=
        Nat.mul_div_le x.val tamanoPalabras
      have hSS : tamanoPalabras * tamanoPalabras = 256 ^ 32 := by
        norm_num [tamanoPalabras, pow_mul]
      nlinarith⟩⟩

def combinarPalabras (x : Fin tamanoPalabras × Fin tamanoPalabras) : Fin (256 ^ 32) :=
  ⟨x.1.val + tamanoPalabras * x.2.val, by
    have h1 := x.1.isLt
    have h2 := x.2.isLt
    have hSS : tamanoPalabras * tamanoPalabras = 256 ^ 32 := by
      norm_num [tamanoPalabras, pow_mul]
    rw [← hSS]
    nlinarith⟩

def equivalenciaPalabras : Fin (256 ^ 32) ≃
    Fin tamanoPalabras × Fin tamanoPalabras where
  toFun := separarPalabras
  invFun := combinarPalabras
  left_inv x := by
    apply Fin.ext
    have h := Nat.mod_add_div x.val tamanoPalabras
    dsimp [separarPalabras, combinarPalabras]
    omega
  right_inv x := by
    apply Prod.ext <;> apply Fin.ext
    · dsimp [separarPalabras, combinarPalabras]
      simpa only [Nat.add_mod, Nat.mul_mod_right, add_zero, Nat.mod_mod] using
        (Nat.mod_eq_of_lt x.1.isLt)
    · dsimp [separarPalabras, combinarPalabras]
      rw [Nat.add_mul_div_left _ _ (by positivity : 0 < tamanoPalabras)]
      rw [Nat.div_eq_of_lt x.1.isLt]
      simp

def equivalenciaDigest : Nexus.Merkle.Digest ≃
    Fin tamanoPalabras × Fin tamanoPalabras :=
  Nexus.ROM.ProyeccionDigest.entero.trans equivalenciaPalabras

theorem entero_separa_palabras (d : Nexus.Merkle.Digest) :
    separarPalabras (Nexus.ROM.ProyeccionDigest.entero d) =
      (Nexus.Canal.DesafiosPrograma.palabraBaja d,
        Nexus.Canal.DesafiosPrograma.palabraAlta d) := by
  apply Prod.ext <;> apply Fin.ext
  · dsimp [separarPalabras, Nexus.Canal.DesafiosPrograma.palabraBaja]
    change (Nexus.ROM.ProyeccionDigest.entero d).val % tamanoPalabras =
      leerLE (d.val.take 16)
    have h : (Nexus.ROM.ProyeccionDigest.entero d).val =
        leerLE (d.val.take 16) + 256 ^ 16 * leerLE (d.val.drop 16) := by
      change leerLE d.val = _
      conv_lhs => rw [← List.take_append_drop 16 d.val]
      rw [Nexus.ROM.ProyeccionDigest.leer_append]
      simp only [List.length_take, d.property, show min 16 32 = 16 by decide]
    have hb := leer_le_cota (d.val.take 16)
    have hl : (d.val.take 16).length = 16 := by simp [d.property]
    have hS : tamanoPalabras = 256 ^ 16 := by norm_num [tamanoPalabras]
    rw [hS, h]
    simp only [Nat.add_mod, Nat.mul_mod_right, add_zero, Nat.mod_mod]
    simpa only [hl] using Nat.mod_eq_of_lt hb
  · dsimp [separarPalabras, Nexus.Canal.DesafiosPrograma.palabraAlta]
    change (Nexus.ROM.ProyeccionDigest.entero d).val / tamanoPalabras =
      leerLE (d.val.drop 16)
    have h : (Nexus.ROM.ProyeccionDigest.entero d).val =
        leerLE (d.val.take 16) + 256 ^ 16 * leerLE (d.val.drop 16) := by
      change leerLE d.val = _
      conv_lhs => rw [← List.take_append_drop 16 d.val]
      rw [Nexus.ROM.ProyeccionDigest.leer_append]
      simp only [List.length_take, d.property, show min 16 32 = 16 by decide]
    have hb := leer_le_cota (d.val.take 16)
    have hl : (d.val.take 16).length = 16 := by simp [d.property]
    have hS : tamanoPalabras = 256 ^ 16 := by norm_num [tamanoPalabras]
    rw [hS, h]
    rw [Nat.add_mul_div_left _ _ (by positivity : 0 < 256 ^ 16)]
    rw [Nat.div_eq_of_lt]
    · simp
    · simpa only [hl] using hb

theorem promedio_extension (f : Fp2 → ℚ) :
    Nexus.N06.promedio (fun d : Nexus.Merkle.Digest => f (transporteRetoReal d)) =
      Nexus.N06.promedio (fun x : Fin tamanoPalabras × Fin tamanoPalabras =>
        f ⟨(x.1 : Fp), (x.2 : Fp)⟩) := by
  rw [← media_equivalencia equivalenciaDigest
    (fun x : Fin tamanoPalabras × Fin tamanoPalabras =>
      f ⟨(x.1 : Fp), (x.2 : Fp)⟩)]
  congr 1
  funext d
  rw [transporteRetoReal_factoriza]
  change f ⟨(Nexus.Canal.DesafiosPrograma.palabraBaja d : Fp),
      (Nexus.Canal.DesafiosPrograma.palabraAlta d : Fp)⟩ =
    f ⟨((separarPalabras (Nexus.ROM.ProyeccionDigest.entero d)).1 : Fp),
      ((separarPalabras (Nexus.ROM.ProyeccionDigest.entero d)).2 : Fp)⟩
  rw [entero_separa_palabras]

def reducirPalabra (p S : ℕ) (hp : 0 < p) (x : Fin S) : Fin p :=
  ⟨x.val % p, Nat.mod_lt _ hp⟩

theorem promedio_reduccion (p S : ℕ) (hp : 0 < p) (_hS : 0 < S)
    (g : Fin p → ℚ) :
    Nexus.N06.promedio (fun x : Fin S => g (reducirPalabra p S hp x)) =
      ∑ j : Fin p, Nexus.ROM.Sesgo.masa p S j * g j := by
  classical
  have hs : (∑ x : Fin S, g (reducirPalabra p S hp x)) =
      ∑ j : Fin p,
        (Fintype.card {x : Fin S // reducirPalabra p S hp x = j} : ℚ) * g j := by
    rw [← Fintype.sum_fiberwise' (reducirPalabra p S hp) g]
    simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
  unfold Nexus.N06.promedio
  rw [hs]
  simp_rw [show ∀ j, Fintype.card {x : Fin S // reducirPalabra p S hp x = j} =
    Nexus.ROM.Sesgo.cuenta p S j.val from fun j => by
      let e : {x : Fin S // reducirPalabra p S hp x = j} ≃
          {x : Fin S // x.val % p = j.val} :=
        { toFun := fun x => ⟨x.val, by
            simpa only [reducirPalabra] using congrArg Fin.val x.property⟩
          invFun := fun x => ⟨x.val, by
            apply Fin.ext
            simpa only [reducirPalabra] using x.property⟩
          left_inv := by intro x; rfl
          right_inv := by intro x; rfl }
      rw [Fintype.card_congr e]
      exact Nexus.ROM.Sesgo.cardinal_fibra p S hp j]
  simp only [Nexus.ROM.Sesgo.masa, Fintype.card_fin]
  rw [Finset.sum_div]
  apply Finset.sum_congr rfl
  intro j hj
  ring

theorem promedio_reduccion_producto (p S : ℕ) (hp : 0 < p) (hS : 0 < S)
    (f : (Fin p × Fin p) → ℚ) :
    Nexus.N06.promedio (fun x : Fin S × Fin S =>
      f (reducirPalabra p S hp x.1, reducirPalabra p S hp x.2)) =
      ∑ z : Fin p × Fin p,
        Nexus.ROM.Sesgo.masa p S z.1 * Nexus.ROM.Sesgo.masa p S z.2 * f z := by
  rw [Nexus.N06.promedio_producto]
  have hi : ∀ a : Fin S,
      Nexus.N06.promedio (fun b : Fin S =>
        f (reducirPalabra p S hp a, reducirPalabra p S hp b)) =
        ∑ j : Fin p, Nexus.ROM.Sesgo.masa p S j *
          f (reducirPalabra p S hp a, j) := by
    intro a
    exact promedio_reduccion p S hp hS
      (fun j => f (reducirPalabra p S hp a, j))
  simp_rw [hi]
  have ho := promedio_reduccion p S hp hS
    (fun i : Fin p => ∑ j : Fin p,
      Nexus.ROM.Sesgo.masa p S j * f (i, j))
  rw [ho, Fintype.sum_prod_type]
  apply Finset.sum_congr rfl
  intro i hi
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j hj
  ring

set_option maxRecDepth 100000 in
theorem evento_extension_reducido (E : Fp2 → Prop) :
    Nexus.N06.promedio (fun d : Nexus.Merkle.Digest =>
      if E (transporteRetoReal d) then (1 : ℚ) else 0) =
      Nexus.Cripto.Variacion.evento
        (Nexus.Cripto.Variacion.producto
          (Nexus.ROM.Sesgo.leyReducida Nexus.Goldilocks.p (2 ^ 128)
            (by norm_num [Nexus.Goldilocks.p]) (by norm_num))
          (Nexus.ROM.Sesgo.leyReducida Nexus.Goldilocks.p (2 ^ 128)
            (by norm_num [Nexus.Goldilocks.p]) (by norm_num)))
        (fun x => E ⟨((x.1.val : ℕ) : Fp), ((x.2.val : ℕ) : Fp)⟩) := by
  rw [promedio_extension (fun z : Fp2 => if E z then (1 : ℚ) else 0)]
  have hcast : ∀ x : Fin tamanoPalabras,
      ((x.val : ℕ) : Fp) =
        ((reducirPalabra Nexus.Goldilocks.p tamanoPalabras
          (by norm_num [Nexus.Goldilocks.p]) x).val : Fp) := by
    intro x
    have hr : (reducirPalabra Nexus.Goldilocks.p tamanoPalabras
        (by norm_num [Nexus.Goldilocks.p]) x).val =
        x.val % Nexus.Goldilocks.p := rfl
    rw [hr]
    exact CharP.natCast_eq_natCast_mod Fp Nexus.Goldilocks.p x.val
  have hfun :
      (fun x : Fin tamanoPalabras × Fin tamanoPalabras =>
        if E ⟨((x.1.val : ℕ) : Fp), ((x.2.val : ℕ) : Fp)⟩ then (1 : ℚ) else 0) =
      (fun x : Fin tamanoPalabras × Fin tamanoPalabras =>
        (fun z : Fin Nexus.Goldilocks.p × Fin Nexus.Goldilocks.p =>
          if E ⟨((z.1.val : ℕ) : Fp), ((z.2.val : ℕ) : Fp)⟩ then (1 : ℚ) else 0)
          (reducirPalabra Nexus.Goldilocks.p tamanoPalabras
            (by norm_num [Nexus.Goldilocks.p]) x.1,
           reducirPalabra Nexus.Goldilocks.p tamanoPalabras
            (by norm_num [Nexus.Goldilocks.p]) x.2)) := by
    funext x
    rw [hcast x.1, hcast x.2]
  rw [hfun]
  rw [promedio_reduccion_producto Nexus.Goldilocks.p tamanoPalabras
    (by norm_num [Nexus.Goldilocks.p]) (by norm_num)
    (fun z : Fin Nexus.Goldilocks.p × Fin Nexus.Goldilocks.p =>
      if E ⟨((z.1.val : ℕ) : Fp), ((z.2.val : ℕ) : Fp)⟩ then (1 : ℚ) else 0)]
  simp [Nexus.Cripto.Variacion.evento, Nexus.Cripto.Variacion.producto,
    Nexus.ROM.Sesgo.leyReducida, Fintype.sum_prod_type, tamanoPalabras]

theorem evento_uniforme_goldilocks_card (E : Finset Fp2) :
    Nexus.Cripto.Variacion.evento
      (Nexus.Cripto.Variacion.producto
        (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
          (by norm_num [Nexus.Goldilocks.p]))
        (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
          (by norm_num [Nexus.Goldilocks.p])))
      (fun x : Fin Nexus.Goldilocks.p × Fin Nexus.Goldilocks.p =>
        ⟨((x.1.val : ℕ) : Fp), ((x.2.val : ℕ) : Fp)⟩ ∈ E) =
    (E.card : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2 := by
  classical
  let ef : Fin Nexus.Goldilocks.p ≃+* Fp := ZMod.finEquiv Nexus.Goldilocks.p
  let e : Fin Nexus.Goldilocks.p × Fin Nexus.Goldilocks.p ≃ Fp2 :=
    (Equiv.prodCongr ef.toEquiv ef.toEquiv).trans
      (QuadraticAlgebra.equivProd (7 : Fp) 0).symm
  have hpair (x : Fin Nexus.Goldilocks.p × Fin Nexus.Goldilocks.p) :
      (⟨((x.1.val : ℕ) : Fp), ((x.2.val : ℕ) : Fp)⟩ : Fp2) = e x := by
    apply (QuadraticAlgebra.equivProd (7 : Fp) 0).injective
    change ((x.1.val : Fp), (x.2.val : Fp)) = (ef x.1, ef x.2)
    apply Prod.ext
    · apply ZMod.val_injective
      rw [ZMod.val_natCast_of_lt x.1.isLt]
      rfl
    · apply ZMod.val_injective
      rw [ZMod.val_natCast_of_lt x.2.isLt]
      rfl
  unfold Nexus.Cripto.Variacion.evento
  simp only [Nexus.Cripto.Variacion.producto, Nexus.ROM.Sesgo.leyUniforme]
  simp_rw [hpair]
  calc
    _ = (1 / (Nexus.Goldilocks.p : ℚ) *
        (1 / (Nexus.Goldilocks.p : ℚ))) *
        ∑ x : Fin Nexus.Goldilocks.p × Fin Nexus.Goldilocks.p,
          if e x ∈ E then (1 : ℚ) else 0 := by
      have hpoint : ∀ x : Fin Nexus.Goldilocks.p × Fin Nexus.Goldilocks.p,
          (if e x ∈ E then
              1 / (Nexus.Goldilocks.p : ℚ) *
                (1 / (Nexus.Goldilocks.p : ℚ)) else 0) =
            (1 / (Nexus.Goldilocks.p : ℚ) *
              (1 / (Nexus.Goldilocks.p : ℚ))) *
              (if e x ∈ E then (1 : ℚ) else 0) := by
        intro x
        by_cases hxE : e x ∈ E <;> simp [hxE]
      simp_rw [hpoint]
      rw [Finset.mul_sum]
    _ = (1 / (Nexus.Goldilocks.p : ℚ) *
        (1 / (Nexus.Goldilocks.p : ℚ))) *
        ∑ x : Fp2, if x ∈ E then (1 : ℚ) else 0 := by
      have hsum := e.sum_comp (fun x : Fp2 => if x ∈ E then (1 : ℚ) else 0)
      rw [hsum]
    _ = (1 / (Nexus.Goldilocks.p : ℚ) *
        (1 / (Nexus.Goldilocks.p : ℚ))) * E.card := by
      simp only [Finset.sum_boole]
      simp
    _ = (E.card : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2 := by ring

theorem cota_evento_una_respuesta (E : Fp2 → Prop) (bound : ℚ)
    (hideal : Nexus.Cripto.Variacion.evento
      (Nexus.Cripto.Variacion.producto
        (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
          (by norm_num [Nexus.Goldilocks.p]))
        (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
          (by norm_num [Nexus.Goldilocks.p])))
      (fun x => E ⟨((x.1.val : ℕ) : Fp), ((x.2.val : ℕ) : Fp)⟩) ≤ bound) :
    Nexus.N06.promedio (fun d : Nexus.Merkle.Digest =>
      if E (transporteRetoReal d) then (1 : ℚ) else 0) ≤
      bound + 2 * Nexus.ROM.Sesgo.delta Nexus.Goldilocks.p (2 ^ 128) := by
  let real := Nexus.Cripto.Variacion.producto
    (Nexus.ROM.Sesgo.leyReducida Nexus.Goldilocks.p (2 ^ 128)
      (by norm_num [Nexus.Goldilocks.p]) (by norm_num))
    (Nexus.ROM.Sesgo.leyReducida Nexus.Goldilocks.p (2 ^ 128)
      (by norm_num [Nexus.Goldilocks.p]) (by norm_num))
  let ideal := Nexus.Cripto.Variacion.producto
    (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
      (by norm_num [Nexus.Goldilocks.p]))
    (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
      (by norm_num [Nexus.Goldilocks.p]))
  have hd := Nexus.Cripto.Variacion.diferencia_evento_acotada real ideal
    (fun x : Fin Nexus.Goldilocks.p × Fin Nexus.Goldilocks.p =>
      E ⟨((x.1.val : ℕ) : Fp), ((x.2.val : ℕ) : Fp)⟩)
  have hdist := Nexus.Cripto.Variacion.producto_distancia
    (Nexus.ROM.Sesgo.leyReducida Nexus.Goldilocks.p (2 ^ 128)
      (by norm_num [Nexus.Goldilocks.p]) (by norm_num))
    (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
      (by norm_num [Nexus.Goldilocks.p]))
    (Nexus.ROM.Sesgo.leyReducida Nexus.Goldilocks.p (2 ^ 128)
      (by norm_num [Nexus.Goldilocks.p]) (by norm_num))
    (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
      (by norm_num [Nexus.Goldilocks.p]))
  have hdist' : Nexus.Cripto.Variacion.distancia real ideal ≤
      Nexus.Cripto.Variacion.distancia
          (Nexus.ROM.Sesgo.leyReducida Nexus.Goldilocks.p (2 ^ 128)
            (by norm_num [Nexus.Goldilocks.p]) (by norm_num))
          (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
            (by norm_num [Nexus.Goldilocks.p])) +
        Nexus.Cripto.Variacion.distancia
          (Nexus.ROM.Sesgo.leyReducida Nexus.Goldilocks.p (2 ^ 128)
            (by norm_num [Nexus.Goldilocks.p]) (by norm_num))
          (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
            (by norm_num [Nexus.Goldilocks.p])) := by
    simpa only [real, ideal] using hdist
  have hred := Nexus.ROM.Sesgo.distancia_reduccion Nexus.Goldilocks.p
    (2 ^ 128) (by norm_num [Nexus.Goldilocks.p]) (by norm_num)
  rw [hred] at hdist'
  have hreal : Nexus.Cripto.Variacion.evento real
      (fun x : Fin Nexus.Goldilocks.p × Fin Nexus.Goldilocks.p =>
        E ⟨((x.1.val : ℕ) : Fp), ((x.2.val : ℕ) : Fp)⟩) ≤
      bound + 2 * Nexus.ROM.Sesgo.delta Nexus.Goldilocks.p (2 ^ 128) := by
    have habs := (le_abs_self (_)).trans hd
    have hideal' : Nexus.Cripto.Variacion.evento ideal
        (fun x : Fin Nexus.Goldilocks.p × Fin Nexus.Goldilocks.p =>
          E ⟨((x.1.val : ℕ) : Fp), ((x.2.val : ℕ) : Fp)⟩) ≤ bound := by
      simpa only [ideal] using hideal
    linarith [hdist', hideal']
  rw [evento_extension_reducido E]
  simpa only [real] using hreal

theorem cota_evento_una_respuesta_goldilocks (E : Fp2 → Prop) (bound : ℚ)
    (hideal : Nexus.Cripto.Variacion.evento
      (Nexus.Cripto.Variacion.producto
        (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
          (by norm_num [Nexus.Goldilocks.p]))
        (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
          (by norm_num [Nexus.Goldilocks.p])))
      (fun x => E ⟨((x.1.val : ℕ) : Fp), ((x.2.val : ℕ) : Fp)⟩) ≤ bound) :
    Nexus.N06.promedio (fun d : Nexus.Merkle.Digest =>
      if E (transporteRetoReal d) then (1 : ℚ) else 0) ≤
      bound + (2524360 / 10 ^ 35) := by
  have hraw := cota_evento_una_respuesta E bound hideal
  have hdelta := (Nexus.ROM.Sesgo.goldilocks_intervalo).2.le
  have htransport :
      2 * Nexus.ROM.Sesgo.delta Nexus.Goldilocks.p (2 ^ 128) ≤
        (2524360 / 10 ^ 35 : ℚ) := by
    norm_num at hdelta ⊢
    linarith
  exact hraw.trans (by linarith [htransport])

set_option maxRecDepth 100000 in
theorem cota_adaptativa_digest_goldilocks {m : ℕ}
    (t : Nexus.FRI.Torre Fp2 m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2)
    (Bideal : ℕ → ℚ)
    (hIdeal : ∀ (i : ℕ) (h : List Nexus.Merkle.Digest),
      Nexus.Cripto.Variacion.evento
        (Nexus.Cripto.Variacion.producto
          (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
            (by norm_num [Nexus.Goldilocks.p]))
          (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
            (by norm_num [Nexus.Goldilocks.p])))
        (fun x =>
          (⟨((x.1.val : ℕ) : Fp), ((x.2.val : ℕ) : Fp)⟩ : Fp2) ∈
            Nexus.FRI.excepcionesHistoria t θ hθ h2 hmargin estrategia i
              (h.map transporteRetoReal)) ≤ Bideal i) :
    Nexus.FRI.probabilidadExcepcionesCruda t θ hθ h2 hmargin estrategia
        transporteRetoReal ≤
      ∑ j ∈ Finset.range m, (Bideal j + (2524360 / 10 ^ 35)) := by
  apply Nexus.FRI.cota_excepciones_adaptativas_cruda_media
    t θ hθ h2 hmargin estrategia transporteRetoReal
    (fun i => Bideal i + (2524360 / 10 ^ 35))
  intro i h
  have hbound := cota_evento_una_respuesta_goldilocks
    (fun z : Fp2 => z ∈ Nexus.FRI.excepcionesHistoria t θ hθ h2 hmargin estrategia i
      (h.map transporteRetoReal)) (Bideal i) (hIdeal i h)
  convert hbound using 1
  congr 1
  funext d
  by_cases hd : transporteRetoReal d ∈
      Nexus.FRI.excepcionesHistoria t θ hθ h2 hmargin estrategia i
        (h.map transporteRetoReal) <;> simp [hd]

set_option maxRecDepth 100000 in
theorem cota_adaptativa_digest_goldilocks_cardinal {m : ℕ}
    (t : Nexus.FRI.Torre Fp2 m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2) :
    Nexus.FRI.probabilidadExcepcionesCruda t θ hθ h2 hmargin estrategia
        transporteRetoReal ≤
      ∑ j ∈ Finset.range m,
        (((t.dominio (j + 1)).card : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 + (2524360 / 10 ^ 35)) := by
  let Bideal : ℕ → ℚ := fun i =>
    if hi : i < m then
      ((t.dominio (i + 1)).card : ℚ) / (Nexus.Goldilocks.p : ℚ) ^ 2
    else 0
  have hIdeal : ∀ (i : ℕ) (h : List Nexus.Merkle.Digest),
      Nexus.Cripto.Variacion.evento
        (Nexus.Cripto.Variacion.producto
          (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
            (by norm_num [Nexus.Goldilocks.p]))
          (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
            (by norm_num [Nexus.Goldilocks.p])))
        (fun x =>
          (⟨((x.1.val : ℕ) : Fp), ((x.2.val : ℕ) : Fp)⟩ : Fp2) ∈
            Nexus.FRI.excepcionesHistoria t θ hθ h2 hmargin estrategia i
              (h.map transporteRetoReal)) ≤ Bideal i := by
    intro i h
    by_cases hi : i < m
    · have hc := Nexus.FRI.excepciones_cardinal t θ hθ h2 hmargin
        ⟨i, hi⟩ (estrategia i (h.map transporteRetoReal))
      rw [evento_uniforme_goldilocks_card]
      have hhist :
          Nexus.FRI.excepcionesHistoria t θ hθ h2 hmargin estrategia i
              (h.map transporteRetoReal) =
            Nexus.FRI.excepciones t θ hθ h2 hmargin ⟨i, hi⟩
              (estrategia i (h.map transporteRetoReal)) := by
        simp [Nexus.FRI.excepcionesHistoria, hi]
      rw [hhist]
      simp only [Bideal, hi]
      have hcardq :
          ((Nexus.FRI.excepciones t θ hθ h2 hmargin ⟨i, hi⟩
            (estrategia i (h.map transporteRetoReal))).card : ℚ) ≤
            (t.dominio (i + 1)).card := by
        exact_mod_cast hc
      have hpq : 0 ≤ (Nexus.Goldilocks.p : ℚ) ^ 2 := by positivity
      exact div_le_div_of_nonneg_right hcardq hpq
    · simp [Nexus.FRI.excepcionesHistoria, hi, Bideal,
        Nexus.Cripto.Variacion.evento]
  have hbound := cota_adaptativa_digest_goldilocks t θ hθ h2 hmargin
    estrategia Bideal hIdeal
  calc
    _ ≤ ∑ j ∈ Finset.range m, (Bideal j + (2524360 / 10 ^ 35)) := hbound
    _ = ∑ j ∈ Finset.range m,
        (((t.dominio (j + 1)).card : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 + (2524360 / 10 ^ 35)) := by
      apply Finset.sum_congr rfl
      intro j hj
      have hjm : j < m := Finset.mem_range.mp hj
      simp [Bideal, hjm]

set_option maxRecDepth 100000 in
theorem cota_adaptativa_digest_goldilocks_telescopica {m : ℕ}
    (t : Nexus.FRI.Torre Fp2 m)
    (θ : ℝ) (hθ : 0 ≤ θ) (h2 : (2 : Fp2) ≠ 0)
    (hmargin : ∀ j : Fin m, (t.grado (j + 1) : ℝ) - 1 <
      (1 - 3 * θ) * (t.dominio (j + 1)).card)
    (estrategia : ℕ → List Fp2 → Fp2 → Fp2) :
    Nexus.FRI.probabilidadExcepcionesCruda t θ hθ h2 hmargin estrategia
        transporteRetoReal ≤
      (((t.dominio 0).card - (t.dominio m).card : ℕ) : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (m : ℚ) * (2524360 / 10 ^ 35) := by
  have hcard := cota_adaptativa_digest_goldilocks_cardinal
    t θ hθ h2 hmargin estrategia
  calc
    _ ≤ ∑ j ∈ Finset.range m,
        (((t.dominio (j + 1)).card : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 + (2524360 / 10 ^ 35)) := hcard
    _ = (∑ j ∈ Finset.range m, (t.dominio (j + 1)).card : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (m : ℚ) * (2524360 / 10 ^ 35) := by
      rw [Finset.sum_add_distrib, ← Finset.sum_div]
      simp only [Finset.sum_const, Finset.card_range]
      ring
    _ = (((t.dominio 0).card - (t.dominio m).card : ℕ) : ℚ) /
          (Nexus.Goldilocks.p : ℚ) ^ 2 +
        (m : ℚ) * (2524360 / 10 ^ 35) := by
      have hs := Nexus.FRI.suma_capas t h2
      have hsQ :
          (∑ j ∈ Finset.range m, (t.dominio (j + 1)).card : ℚ) =
            ((t.dominio 0).card - (t.dominio m).card : ℕ) := by
        rw [← Fin.sum_univ_eq_sum_range]
        exact_mod_cast hs
      rw [hsQ]

theorem no_uniforme_digest_a_fp2 (f : Nexus.Merkle.Digest → Fp2) :
    ¬ (∀ y : Fp2,
      Fintype.card {d : Nexus.Merkle.Digest // f d = y} * Fintype.card Fp2 =
        Fintype.card Nexus.Merkle.Digest) := by
  intro h
  have hdiv : Fintype.card Fp2 ∣ Fintype.card Nexus.Merkle.Digest := by
    refine ⟨Fintype.card {d : Nexus.Merkle.Digest // f d = (0 : Fp2)}, ?_⟩
    simpa only [Nat.mul_comm] using (h (0 : Fp2)).symm
  rw [Nexus.Goldilocks.cardinal_extension,
    Nexus.ROM.ProyeccionDigest.cardinal_digest] at hdiv
  have hp2 : p ^ 2 ∣ 2 ^ 256 := hdiv
  have hp : p ∣ 2 ^ 256 := dvd_trans (dvd_pow_self p (by norm_num)) hp2
  have htwo : p ∣ 2 := Nexus.Goldilocks.primo.dvd_of_dvd_pow hp
  have hlarge : 2 < p := by norm_num [Nexus.Goldilocks.p]
  have hsmall : p ≤ 2 := Nat.le_of_dvd (by norm_num) htwo
  omega

theorem extension_no_uniforme :
    ¬ (∀ y : Fp2,
      Fintype.card {d : Nexus.Merkle.Digest // transporteRetoReal d = y} * Fintype.card Fp2 =
        Fintype.card Nexus.Merkle.Digest) :=
  no_uniforme_digest_a_fp2 transporteRetoReal

theorem no_equivalencia_digest_fp2 : ¬ Nonempty (Nexus.Merkle.Digest ≃ Fp2) := by
  rintro ⟨e⟩
  have hc := Fintype.card_congr e
  rw [Nexus.ROM.ProyeccionDigest.cardinal_digest,
    Nexus.Goldilocks.cardinal_extension] at hc
  have hp2 : p ^ 2 ∣ 2 ^ 256 := by
    rw [hc]
  have hp : p ∣ 2 ^ 256 := dvd_trans (dvd_pow_self p (by norm_num)) hp2
  have htwo : p ∣ 2 := Nexus.Goldilocks.primo.dvd_of_dvd_pow hp
  have hlarge : 2 < p := by norm_num [Nexus.Goldilocks.p]
  have hsmall : p ≤ 2 := Nat.le_of_dvd (by norm_num) htwo
  omega

/-!
La reparación disponible es un transporte con sesgo, no una igualdad. El
resultado siguiente encapsula la cota ya calculada para las dos coordenadas
reducidas y permite añadirla a cualquier cota ideal de un evento FRI.
-/

theorem cota_evento_reducido {m : ℕ} (p S : ℕ) (hp : 0 < p) (hS : 0 < S)
    (E : Nexus.Cripto.Variacion.Espacio (Fin p × Fin p) m → Prop)
    (bound : ℚ)
    (hideal : Nexus.Cripto.Variacion.evento
      (Nexus.Cripto.Variacion.repite
        (Nexus.Cripto.Variacion.producto
          (Nexus.ROM.Sesgo.leyUniforme p hp)
          (Nexus.ROM.Sesgo.leyUniforme p hp)) m) E ≤ bound) :
    Nexus.Cripto.Variacion.evento
      (Nexus.Cripto.Variacion.repite
        (Nexus.Cripto.Variacion.producto
          (Nexus.ROM.Sesgo.leyReducida p S hp hS)
          (Nexus.ROM.Sesgo.leyReducida p S hp hS)) m) E ≤
      bound + 2 * (m : ℚ) * Nexus.ROM.Sesgo.delta p S := by
  let real := Nexus.Cripto.Variacion.repite
        (Nexus.Cripto.Variacion.producto
      (Nexus.ROM.Sesgo.leyReducida p S hp hS)
      (Nexus.ROM.Sesgo.leyReducida p S hp hS)) m
  let ideal := Nexus.Cripto.Variacion.repite
        (Nexus.Cripto.Variacion.producto
      (Nexus.ROM.Sesgo.leyUniforme p hp)
      (Nexus.ROM.Sesgo.leyUniforme p hp)) m
  have hdist := Nexus.ROM.Sesgo.evento_retos_extension p S m hp hS E
  dsimp only [real, ideal] at hdist hideal ⊢
  have hdiff := (le_abs_self (_)).trans hdist
  linarith

theorem cota_evento_reducido_goldilocks {m : ℕ}
    (E : Nexus.Cripto.Variacion.Espacio
      (Fin Nexus.Goldilocks.p × Fin Nexus.Goldilocks.p) m → Prop)
    (bound : ℚ)
    (hideal : Nexus.Cripto.Variacion.evento
      (Nexus.Cripto.Variacion.repite
        (Nexus.Cripto.Variacion.producto
          (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
            (by norm_num [Nexus.Goldilocks.p]))
          (Nexus.ROM.Sesgo.leyUniforme Nexus.Goldilocks.p
            (by norm_num [Nexus.Goldilocks.p]))) m) E ≤ bound) :
    Nexus.Cripto.Variacion.evento
      (Nexus.Cripto.Variacion.repite
        (Nexus.Cripto.Variacion.producto
          (Nexus.ROM.Sesgo.leyReducida Nexus.Goldilocks.p (2 ^ 128)
            (by norm_num [Nexus.Goldilocks.p]) (by norm_num))
          (Nexus.ROM.Sesgo.leyReducida Nexus.Goldilocks.p (2 ^ 128)
            (by norm_num [Nexus.Goldilocks.p]) (by norm_num))) m) E ≤
      bound + (m : ℚ) * (2524360 / 10 ^ 35) := by
  have hgeneric := cota_evento_reducido Nexus.Goldilocks.p (2 ^ 128)
    (by norm_num [Nexus.Goldilocks.p]) (by norm_num) E bound hideal
  have hdelta := (Nexus.ROM.Sesgo.goldilocks_intervalo).2.le
  have hm : 0 ≤ (m : ℚ) := by positivity
  have hmul := mul_le_mul_of_nonneg_left hdelta hm
  have htransport :
      2 * (m : ℚ) * Nexus.ROM.Sesgo.delta Nexus.Goldilocks.p (2 ^ 128) ≤
        (m : ℚ) * (2524360 / 10 ^ 35) := by
    norm_num at hmul ⊢
    nlinarith [hmul]
  exact hgeneric.trans (by linarith [htransport])

end Nexus.Verificador.LeyTransporteFRI
