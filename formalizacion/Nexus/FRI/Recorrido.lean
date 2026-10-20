module

public import Nexus.FRI.OraculoMerkle
public import Nexus.FRI.Goldilocks
public import Nexus.FRI.Consulta
import Mathlib.Tactic

/-!
# Ejecución de consultas FRI con acarreo

El bucle se interpreta con Option: un rechazo impide todos los pasos
posteriores. Las aperturas y el acarreo se extraen de una ejecución aceptada;
no se reciben las ecuaciones de aceptación FRI como hipótesis.
Los naturales y las operaciones de campo son matemáticos.
-/

public section
namespace Nexus.Goldilocks.Recorrido

open Nexus.Bytes Nexus.Merkle Nexus.FRI

structure Apertura where
  izquierda : Fp2
  derecha : Fp2
  pruebaIzquierda : List Digest
  pruebaDerecha : List Digest

structure Estado where
  posicion : ℕ
  acarreo : Option Fp2

@[expose] def mitad (k j : ℕ) : ℕ := 2 ^ (k + 3 - (j + 1))

@[expose] noncomputable def plegar (k j a : ℕ) (d : Apertura) (β : Fp2) : Fp2 :=
  (d.izquierda + d.derecha) / 2 +
    β * ((d.izquierda - d.derecha) / 2) * (puntoCapa k j a)⁻¹

@[expose] def Autenticada (H : List Octeto → Digest) (raiz : Digest)
    (k j a : ℕ) (d : Apertura) : Prop :=
  VerificaIndice formatoBytes H raiz (k + 3 - j) a d.izquierda d.pruebaIzquierda ∧
  VerificaIndice formatoBytes H raiz (k + 3 - j) (a + mitad k j) d.derecha d.pruebaDerecha

@[expose] def Registrada (H : List Octeto → Digest) (registro : List (List Octeto))
    (k j a : ℕ) (d : Apertura) : Prop :=
  AperturaRegistrada formatoBytes H registro d.izquierda
      (hermanosDesdeRaiz a d.pruebaIzquierda) ∧
  AperturaRegistrada formatoBytes H registro d.derecha
      (hermanosDesdeRaiz (a + mitad k j) d.pruebaDerecha)

@[expose] def Compatible (k j : ℕ) (s : Estado) (d : Apertura) : Prop :=
  match s.acarreo with
  | none => True
  | some c => (if s.posicion < mitad k j then d.izquierda else d.derecha) = c

@[expose] noncomputable def paso (H : List Octeto → Digest) (k j : ℕ)
    (raiz : Digest) (β : Fp2) (d : Apertura) (s : Estado) : Option Estado := by
  classical
  exact if Autenticada H raiz k j (s.posicion % mitad k j) d ∧ Compatible k j s d then
    some ⟨s.posicion % mitad k j, some (plegar k j (s.posicion % mitad k j) d β)⟩
  else none

@[expose] noncomputable def ejecutar (H : List Octeto → Digest) (k pos0 : ℕ)
    (raiz : ℕ → Digest) (β : ℕ → Fp2) (d : ℕ → Apertura) : ℕ → Option Estado
  | 0 => some ⟨pos0, none⟩
  | j + 1 => (ejecutar H k pos0 raiz β d j).bind (paso H k j (raiz j) (β j) (d j))

@[expose] def posicion (k pos0 : ℕ) : ℕ → ℕ
  | 0 => pos0
  | j + 1 => posicion k pos0 j % mitad k j

@[expose] def raizDefecto : Digest := ⟨List.replicate 32 0, by simp⟩

theorem paso_correcto (H : List Octeto → Digest) (k j : ℕ) (raiz : Digest)
    (β : Fp2) (d : Apertura) (s t : Estado) (h : paso H k j raiz β d s = some t) :
    Autenticada H raiz k j (s.posicion % mitad k j) d ∧ Compatible k j s d ∧
      t = ⟨s.posicion % mitad k j, some (plegar k j (s.posicion % mitad k j) d β)⟩ := by
  classical
  unfold paso at h
  split at h
  · rename_i hp
    exact ⟨hp.1, hp.2, (Option.some.inj h).symm⟩
  · contradiction

theorem fallo_persistente (H : List Octeto → Digest) (k pos0 : ℕ)
    (raiz : ℕ → Digest) (β : ℕ → Fp2) (d : ℕ → Apertura) (j n : ℕ)
    (h : ejecutar H k pos0 raiz β d j = none) :
    ejecutar H k pos0 raiz β d (j + n) = none := by
  induction n with
  | zero => simpa using h
  | succ n ih => simp [ejecutar, ih]

theorem prefijo_aceptado (H : List Octeto → Digest) (k pos0 : ℕ)
    (raiz : ℕ → Digest) (β : ℕ → Fp2) (d : ℕ → Apertura) (j m : ℕ)
    (hjm : j ≤ m) (s : Estado) (h : ejecutar H k pos0 raiz β d m = some s) :
    ∃ t, ejecutar H k pos0 raiz β d j = some t := by
  cases he : ejecutar H k pos0 raiz β d j with
  | some t => exact ⟨t, rfl⟩
  | none =>
    have hf := fallo_persistente H k pos0 raiz β d j (m - j) he
    rw [Nat.add_sub_of_le hjm, h] at hf
    contradiction

theorem posicion_ejecucion (H : List Octeto → Digest) (k pos0 : ℕ)
    (raiz : ℕ → Digest) (β : ℕ → Fp2) (d : ℕ → Apertura) (j : ℕ)
    (s : Estado) (h : ejecutar H k pos0 raiz β d j = some s) :
    s.posicion = posicion k pos0 j := by
  induction j generalizing s with
  | zero =>
    have he := Option.some.inj h
    subst s
    rfl
  | succ j ih =>
    obtain ⟨t, ht⟩ := prefijo_aceptado H k pos0 raiz β d j (j + 1) (by omega) s h
    have hs : paso H k j (raiz j) (β j) (d j) t = some s := by simpa [ejecutar, ht] using h
    have hp := paso_correcto H k j (raiz j) (β j) (d j) t s hs
    rw [hp.2.2]
    exact congrArg (fun p => p % mitad k j) (ih t ht)

theorem posicion_acotada (k pos0 j : ℕ) (hpos : pos0 < 2 ^ (k + 3)) :
    posicion k pos0 j < 2 ^ (k + 3 - j) := by
  cases j with
  | zero => simpa [posicion] using hpos
  | succ j => exact Nat.mod_lt _ (by unfold mitad; positivity)

theorem apertura_de_ejecucion (H : List Octeto → Digest) (k pos0 : ℕ)
    (raiz : ℕ → Digest) (β : ℕ → Fp2) (d : ℕ → Apertura) (j m : ℕ)
    (hjm : j < m) (s : Estado) (h : ejecutar H k pos0 raiz β d m = some s) :
    Autenticada H (raiz j) k j (posicion k pos0 (j + 1)) (d j) := by
  obtain ⟨t, ht⟩ := prefijo_aceptado H k pos0 raiz β d j m (by omega) s h
  obtain ⟨v, hv⟩ := prefijo_aceptado H k pos0 raiz β d (j + 1) m (by omega) s h
  have hs : paso H k j (raiz j) (β j) (d j) t = some v := by simpa [ejecutar, ht] using hv
  have hp := (paso_correcto H k j (raiz j) (β j) (d j) t v hs).1
  simpa only [posicion_ejecucion H k pos0 raiz β d j t ht, posicion] using hp

theorem acarreo_de_ejecucion (H : List Octeto → Digest) (k pos0 : ℕ)
    (raiz : ℕ → Digest) (β : ℕ → Fp2) (d : ℕ → Apertura) (j : ℕ)
    (s : Estado) (h : ejecutar H k pos0 raiz β d (j + 1) = some s) :
    s.acarreo = some (plegar k j (posicion k pos0 (j + 1)) (d j) (β j)) := by
  obtain ⟨t, ht⟩ := prefijo_aceptado H k pos0 raiz β d j (j + 1) (by omega) s h
  have hs : paso H k j (raiz j) (β j) (d j) t = some s := by simpa [ejecutar, ht] using h
  have hp := paso_correcto H k j (raiz j) (β j) (d j) t s hs
  rw [hp.2.2]
  simp only [posicion, posicion_ejecucion H k pos0 raiz β d j t ht]

theorem valor_autenticado (k j pos : ℕ) (hk : k ≤ 29) (hj : j < k + 3)
    (hpos : pos < 2 ^ (k + 3 - j)) (H : List Octeto → Digest)
    (registro : List (List Octeto)) (hc : SinColisiones H registro) (raiz : Digest) (d : Apertura)
    (ha : Autenticada H raiz k j (pos % mitad k j) d)
    (hr : Registrada H registro k j (pos % mitad k j) d) :
    oraculoMerkle k j H registro raiz (puntoCapa k j pos) =
      if pos < mitad k j then d.izquierda else d.derecha := by
  have hsize := tamano_capa_siguiente k j hj
  change 2 ^ (k + 3 - j) = 2 * mitad k j at hsize
  have hm : 0 < mitad k j := by unfold mitad; positivity
  by_cases hp : pos < mitad k j
  · rw [ite_eq_left hp]
    have hl := oraculo_merkle_apertura k j hk (by omega) H registro hc raiz pos hpos
      d.izquierda d.pruebaIzquierda
    apply hl
    · simpa only [Nat.mod_eq_of_lt hp] using ha.1
    · simpa only [Nat.mod_eq_of_lt hp] using hr.1
  · rw [ite_eq_right hp]
    have he : pos % mitad k j + mitad k j = pos := by
      have hq : pos / mitad k j = 1 := Nat.div_eq_of_lt_le (by omega) (by omega)
      have hh := Nat.mod_add_div pos (mitad k j)
      rw [hq, Nat.mul_one] at hh
      omega
    exact oraculo_merkle_apertura k j hk (by omega) H registro hc raiz pos hpos
      d.derecha d.pruebaDerecha (by simpa only [he] using ha.2)
      (by simpa only [he] using hr.2)

@[expose] noncomputable def oraculos (H : List Octeto → Digest) (registro : List (List Octeto))
    (k m : ℕ) (raiz : ℕ → Digest) (final : Fp2) (j : ℕ) (x : Fp2) : Fp2 :=
  if j < m then oraculoMerkle k j H registro (raiz j) x else final

theorem plegado_autenticado (k j a : ℕ) (hk : k ≤ 29) (hj : j < k + 3)
    (ha : a < mitad k j) (H : List Octeto → Digest) (registro : List (List Octeto))
    (hc : SinColisiones H registro) (raiz : Digest) (d : Apertura) (β : Fp2)
    (hv : Autenticada H raiz k j a d) (hr : Registrada H registro k j a d) :
    plegar k j a d β =
      Nexus.N04.par (oraculoMerkle k j H registro raiz) (representanteCapa k j)
        (puntoCapa k (j + 1) a) +
      β * Nexus.N04.impar (oraculoMerkle k j H registro raiz) (representanteCapa k j)
        (puntoCapa k (j + 1) a) := by
  exact (plegado_de_pareja_abierta k j a hk hj ha H registro hc raiz
    d.izquierda d.derecha β d.pruebaIzquierda d.pruebaDerecha hv.1 hv.2 hr.1 hr.2).symm

theorem ecuacion_de_ejecucion (H : List Octeto → Digest) (registro : List (List Octeto))
    (hc : SinColisiones H registro) (k m pos0 : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1)
    (hpos : pos0 < 2 ^ (k + 3)) (raiz : ℕ → Digest) (β : ℕ → Fp2) (d : ℕ → Apertura)
    (final : Fp2) (s : Estado) (he : ejecutar H k pos0 raiz β d m = some s)
    (hf : s.acarreo = some final)
    (hr : ∀ j < m, Registrada H registro k j (posicion k pos0 (j + 1)) (d j))
    (j : ℕ) (hj : j < m) :
    oraculos H registro k m raiz final (j + 1) (puntoCapa k (j + 1) (posicion k pos0 (j + 1))) =
      Nexus.N04.par (oraculos H registro k m raiz final j) (representanteCapa k j)
        (puntoCapa k (j + 1) (posicion k pos0 (j + 1))) +
      β j * Nexus.N04.impar (oraculos H registro k m raiz final j) (representanteCapa k j)
        (puntoCapa k (j + 1) (posicion k pos0 (j + 1))) := by
  have ha := apertura_de_ejecucion H k pos0 raiz β d j m hj s he
  have hfold := plegado_autenticado k j (posicion k pos0 (j + 1)) hk (by omega)
    (Nat.mod_lt _ (by unfold mitad; positivity)) H registro hc (raiz j) (d j) (β j) ha (hr j hj)
  have hu : oraculos H registro k m raiz final j = oraculoMerkle k j H registro (raiz j) := by
    funext x
    exact ite_eq_left hj
  rw [hu, ← hfold]
  obtain ⟨t, ht⟩ := prefijo_aceptado H k pos0 raiz β d (j + 1) m (by omega) s he
  have htcarry := acarreo_de_ejecucion H k pos0 raiz β d j t ht
  by_cases hnext : j + 1 < m
  · obtain ⟨v, hv⟩ := prefijo_aceptado H k pos0 raiz β d (j + 2) m (by omega) s he
    have hs : paso H k (j + 1) (raiz (j + 1)) (β (j + 1)) (d (j + 1)) t = some v := by
      change (ejecutar H k pos0 raiz β d (j + 1)).bind
        (paso H k (j + 1) (raiz (j + 1)) (β (j + 1)) (d (j + 1))) = some v at hv
      simpa only [ht, Option.bind_some] using hv
    have hcomp := (paso_correcto H k (j + 1) (raiz (j + 1)) (β (j + 1)) (d (j + 1)) t v hs).2.1
    have htp := posicion_ejecucion H k pos0 raiz β d (j + 1) t ht
    simp only [Compatible, htcarry, htp] at hcomp
    have hva := valor_autenticado k (j + 1) (posicion k pos0 (j + 1)) hk (by omega)
      (posicion_acotada k pos0 (j + 1) hpos) H registro hc (raiz (j + 1)) (d (j + 1))
      (apertura_de_ejecucion H k pos0 raiz β d (j + 1) m hnext s he) (hr (j + 1) hnext)
    exact (ite_eq_left hnext).trans (hva.trans hcomp)
  · have hjm : j + 1 = m := by omega
    have ht' : ejecutar H k pos0 raiz β d m = some t := by simpa only [hjm] using ht
    have hts : t = s := Option.some.inj (ht'.symm.trans he)
    rw [hts, hf] at htcarry
    exact (ite_eq_right hnext).trans (Option.some.inj htcarry)

theorem punto_posicion_cuadrado (k pos0 j : ℕ) (hk : k ≤ 29) (hj : j < k + 3)
    (hpos : pos0 < 2 ^ (k + 3)) :
    puntoCapa k j (posicion k pos0 j) ^ 2 =
      puntoCapa k (j + 1) (posicion k pos0 (j + 1)) := by
  have hp := punto_consulta_modulo k j (posicion k pos0 j) hk hj
    (posicion_acotada k pos0 j hpos)
  change puntoCapa k j (posicion k pos0 j) =
    if posicion k pos0 j < mitad k j then puntoCapa k j (posicion k pos0 (j + 1))
      else -puntoCapa k j (posicion k pos0 (j + 1)) at hp
  rw [hp]
  split <;> simp only [neg_sq, punto_capa_cuadrado k j _ hk hj]

theorem recorrido_de_indices (k pos0 j : ℕ) (hk : k ≤ 29) (hj : j + 1 ≤ k + 3)
    (hpos : pos0 < 2 ^ (k + 2)) :
    recorrido (elevar (representanteCapa k 0) {puntoCapa k 1 pos0}) (j + 1) =
      {puntoCapa k (j + 1) (posicion k pos0 (j + 1))} := by
  classical
  have hpos' : pos0 < 2 ^ (k + 3) := by
    have hp : 2 ^ (k + 2) < 2 ^ (k + 3) := Nat.pow_lt_pow_right (by decide) (by omega)
    omega
  induction j with
  | zero =>
    have hy : puntoCapa k 1 pos0 ∈ dominioCapa k 1 :=
      Finset.mem_image.mpr ⟨pos0, Finset.mem_range.mpr (by simpa using hpos), rfl⟩
    have hr := cuadrados_elevar {puntoCapa k 1 pos0} (representanteCapa k 0)
      (by intro y hy'; simpa only [Finset.mem_singleton.mp hy'] using
        representante_cuadrado k 0 hk (by omega) _ hy)
    simpa [recorrido, posicion, mitad, Nat.mod_eq_of_lt hpos] using hr
  | succ j ih =>
    have hi := ih (by omega)
    rw [recorrido, hi]
    simp only [cuadrados, Finset.image_singleton, punto_posicion_cuadrado k pos0 (j + 1) hk (by omega) hpos']

theorem aceptacion_de_ejecucion (H : List Octeto → Digest) (registro : List (List Octeto))
    (hc : SinColisiones H registro) (k m pos0 : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1)
    (hpos : pos0 < 2 ^ (k + 2)) (raiz : ℕ → Digest) (β : ℕ → Fp2) (d : ℕ → Apertura)
    (final : Fp2) (s : Estado) (he : ejecutar H k pos0 raiz β d m = some s)
    (hf : s.acarreo = some final)
    (hr : ∀ j < m, Registrada H registro k j (posicion k pos0 (j + 1)) (d j)) :
    Acepta (torreGoldilocks k m hk hm) (oraculos H registro k m raiz final) (fun j => β j)
      (elevar (representanteCapa k 0) {puntoCapa k 1 pos0}) final := by
  classical
  constructor
  · intro j y hy
    rw [recorrido_de_indices k pos0 j hk (by omega) hpos] at hy
    have hey := Finset.mem_singleton.mp hy
    subst y
    exact ecuacion_de_ejecucion H registro hc k m pos0 hk hm (by
      have hp : 2 ^ (k + 2) < 2 ^ (k + 3) := Nat.pow_lt_pow_right (by decide) (by omega)
      omega) raiz β d final s he hf hr j j.isLt
  · intro y _
    exact ite_eq_right (by omega)

theorem muestra_de_ejecuciones (H : List Octeto → Digest) (registro : List (List Octeto))
    (hc : SinColisiones H registro) (k m : ℕ) (hk : k ≤ 29) (hm : m ≤ k + 1)
    (I : Finset ℕ) (hI : ∀ i ∈ I, i < 2 ^ (k + 2)) (raiz : ℕ → Digest) (β : ℕ → Fp2)
    (d : ℕ → ℕ → Apertura) (final : Fp2)
    (he : ∀ i ∈ I, ∃ s, ejecutar H k i raiz β (d i) m = some s ∧ s.acarreo = some final)
    (hr : ∀ i ∈ I, ∀ j < m, Registrada H registro k j (posicion k i (j + 1)) (d i j)) :
    Acepta (torreGoldilocks k m hk hm) (oraculos H registro k m raiz final) (fun j => β j)
      (elevar (representanteCapa k 0) (I.image (puntoCapa k 1))) final := by
  classical
  apply (acepta_parejas_iff _ _ _ _ _).mpr
  intro y hy
  obtain ⟨i, hi, rfl⟩ := Finset.mem_image.mp hy
  obtain ⟨s, hs, hf⟩ := he i hi
  exact aceptacion_de_ejecucion H registro hc k m i hk hm (hI i hi) raiz β (d i) final s hs hf (hr i hi)

@[expose] noncomputable def verificarConsulta (H : List Octeto → Digest) (k m pos0 : ℕ)
    (raices : List Digest) (betas : List Fp2) (datos : List Apertura) (final : Fp2) : Bool := by
  classical
  exact if raices.length = m ∧ betas.length = m ∧ datos.length = m then
    match ejecutar H k pos0 (fun j => raices.getD j raizDefecto) (fun j => betas.getD j 0)
      (fun j => datos.getD j ⟨0, 0, [], []⟩) m with
    | none => false
    | some s => decide (s.acarreo = some final)
  else false

theorem verificador_formas (H : List Octeto → Digest) (k m pos0 : ℕ)
    (raices : List Digest) (betas : List Fp2) (datos : List Apertura) (final : Fp2)
    (h : verificarConsulta H k m pos0 raices betas datos final = true) :
    raices.length = m ∧ betas.length = m ∧ datos.length = m := by
  classical
  unfold verificarConsulta at h
  split at h
  · assumption
  · contradiction

theorem verificador_ejecucion (H : List Octeto → Digest) (k m pos0 : ℕ)
    (raices : List Digest) (betas : List Fp2) (datos : List Apertura) (final : Fp2)
    (h : verificarConsulta H k m pos0 raices betas datos final = true) :
    ∃ s, ejecutar H k pos0 (fun j => raices.getD j raizDefecto) (fun j => betas.getD j 0)
      (fun j => datos.getD j ⟨0, 0, [], []⟩) m = some s ∧ s.acarreo = some final := by
  classical
  unfold verificarConsulta at h
  split at h
  · split at h
    · contradiction
    · rename_i s hs
      exact ⟨s, hs, of_decide_eq_true h⟩
  · contradiction

theorem cero_capas_rechazado (H : List Octeto → Digest) (k pos0 : ℕ)
    (raices : List Digest) (betas : List Fp2) (datos : List Apertura) (final : Fp2) :
    verificarConsulta H k 0 pos0 raices betas datos final = false := by
  classical
  simp only [verificarConsulta]
  split <;> simp [ejecutar]

theorem ambas_aceptaciones (H : List Octeto → Digest) (registro : List (List Octeto))
    (hc : SinColisiones H registro) (k : ℕ) (hk : k ≤ 29)
    (I : Finset ℕ) (hI : ∀ i ∈ I, i < 2 ^ (k + 2))
    (rt rc : ℕ → Digest) (bt bc : ℕ → Fp2) (dt dc : ℕ → ℕ → Apertura) (ft fc : Fp2)
    (het : ∀ i ∈ I, ∃ s, ejecutar H k i rt bt (dt i) k = some s ∧ s.acarreo = some ft)
    (hec : ∀ i ∈ I, ∃ s, ejecutar H k i rc bc (dc i) (k + 1) = some s ∧ s.acarreo = some fc)
    (hrt : ∀ i ∈ I, ∀ j < k, Registrada H registro k j (posicion k i (j + 1)) (dt i j))
    (hrc : ∀ i ∈ I, ∀ j < k + 1, Registrada H registro k j (posicion k i (j + 1)) (dc i j)) :
    Acepta (torreTraza k hk) (oraculos H registro k k rt ft) (fun j => bt j)
      (elevar (representanteCapa k 0) (I.image (puntoCapa k 1))) ft ∧
    Acepta (torreComposicion k hk) (oraculos H registro k (k + 1) rc fc) (fun j => bc j)
      (elevar (representanteCapa k 0) (I.image (puntoCapa k 1))) fc := by
  exact ⟨muestra_de_ejecuciones H registro hc k k hk (by omega) I hI rt bt dt ft het hrt,
    muestra_de_ejecuciones H registro hc k (k + 1) hk (by omega) I hI rc bc dc fc hec hrc⟩

end Nexus.Goldilocks.Recorrido
