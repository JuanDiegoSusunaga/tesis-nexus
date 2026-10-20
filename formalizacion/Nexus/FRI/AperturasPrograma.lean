module

public import Nexus.FRI.ProgramaVerificacion
public import Nexus.Merkle.AperturasPrograma
import Mathlib.Tactic

/-!
# Todas las aperturas emitidas por un recorrido FRI aceptado

Se enumeran ambas ramas de cada capa con el estado de acarreo efectivo.
Autenticación y soporte en el registro se derivan del programa aceptado.
-/

public section
namespace Nexus.Goldilocks.AperturasFRI

open Nexus.Bytes Nexus.Merkle Nexus.ROM
open ProgramaCompartido RegistroPrograma
open Recorrido ProgramaFRI

@[expose] def izquierda (k j : ℕ) (s : Recorrido.Estado) (r : Digest) (d : Recorrido.Apertura) :
    AperturasPrograma.Apertura := ⟨r, k + 3 - j, s.posicion % mitad k j, d.izquierda, d.pruebaIzquierda⟩

@[expose] def derecha (k j : ℕ) (s : Recorrido.Estado) (r : Digest) (d : Recorrido.Apertura) :
    AperturasPrograma.Apertura := ⟨r, k + 3 - j, s.posicion % mitad k j + mitad k j, d.derecha, d.pruebaDerecha⟩

@[expose] noncomputable def aperturas (k : ℕ) : ℕ → List Capa → Recorrido.Estado → List AperturasPrograma.Apertura
  | _, [], _ => []
  | j, c :: cs, s => izquierda k j s c.1 c.2.2 :: derecha k j s c.1 c.2.2 ::
      aperturas k (j + 1) cs (siguiente k j s c.2.2 c.2.1)

theorem cantidad (k j : ℕ) (cs : List Capa) (s : Recorrido.Estado) :
    (aperturas k j cs s).length = 2 * cs.length := by
  induction cs generalizing j s with
  | nil => rfl
  | cons c cs ih => simp only [aperturas, List.length_cons, ih]; omega

theorem todas_validas (H : Entrada → Digest) (k j : ℕ) (cs : List Capa)
    (s : Recorrido.Estado) (v : Fp2) (ha : condiciones H k j cs s v)
    (a : AperturasPrograma.Apertura) (hm : a ∈ aperturas k j cs s) : AperturasPrograma.Valida H a := by
  induction cs generalizing j s with
  | nil => contradiction
  | cons c cs ih =>
    rcases List.mem_cons.mp hm with rfl | hm
    · exact ha.1.1
    · rcases List.mem_cons.mp hm with rfl | hm
      · exact ha.1.2
      · exact ih _ _ ha.2.2 hm

theorem todas_registradas (H : Entrada → Digest) (log : List Entrada) (k j : ℕ) (cs : List Capa)
    (s : Recorrido.Estado) (hr : registradas H log k j cs s)
    (a : AperturasPrograma.Apertura) (hm : a ∈ aperturas k j cs s) : AperturasPrograma.Registrada H log a := by
  induction cs generalizing j s with
  | nil => contradiction
  | cons c cs ih =>
    rcases List.mem_cons.mp hm with rfl | hm
    · exact hr.1.1
    · rcases List.mem_cons.mp hm with rfl | hm
      · exact hr.1.2
      · exact ih _ _ hr.2 hm

theorem indices_acotados (k j : ℕ) (cs : List Capa) (s : Recorrido.Estado)
    (hj : j + cs.length ≤ k + 3) (a : AperturasPrograma.Apertura) (hm : a ∈ aperturas k j cs s) :
    a.indice < 2 ^ a.altura := by
  induction cs generalizing j s with
  | nil => contradiction
  | cons c cs ih =>
    have hnext : j < k + 3 := by simp only [List.length_cons] at hj; omega
    have ht := tamano_capa_siguiente k j hnext
    change 2 ^ (k + 3 - j) = 2 * mitad k j at ht
    have hp := Nat.mod_lt s.posicion (show 0 < mitad k j by unfold mitad; positivity)
    rcases List.mem_cons.mp hm with rfl | hm
    · change s.posicion % mitad k j < 2 ^ (k + 3 - j); omega
    · rcases List.mem_cons.mp hm with rfl | hm
      · change s.posicion % mitad k j + mitad k j < 2 ^ (k + 3 - j); omega
      · exact ih _ _ (by simp only [List.length_cons] at hj; omega) hm

theorem origen_capa (k j : ℕ) (cs : List Capa) (s : Recorrido.Estado)
    (a : AperturasPrograma.Apertura) (hm : a ∈ aperturas k j cs s) :
    ∃ i : Fin cs.length, a.raiz = (cs[i]).1 ∧ a.altura = k + 3 - (j + i.val) := by
  induction cs generalizing j s with
  | nil => contradiction
  | cons c cs ih =>
    rcases List.mem_cons.mp hm with rfl | hm
    · exact ⟨⟨0, by simp⟩, rfl, by simp [izquierda]⟩
    · rcases List.mem_cons.mp hm with rfl | hm
      · exact ⟨⟨0, by simp⟩, rfl, by simp [derecha]⟩
      · obtain ⟨i, hr, hh⟩ := ih _ _ hm
        exact ⟨⟨i.val + 1, by simp only [List.length_cons]; omega⟩,
          by simpa using hr, by simpa only [Nat.add_assoc, Nat.add_comm 1] using hh⟩

theorem verificacion_registra (H : Entrada → Digest) (k m pos : ℕ) (rs : List Digest)
    (bs : List Fp2) (ds : List Recorrido.Apertura) (v : Fp2)
    (ha : resultado (tabla H) (ProgramaFRI.verificar k m pos rs bs ds v) = true) :
    ∀ a ∈ aperturas k 0 (rs.zip (bs.zip ds)) ⟨pos, none⟩,
      AperturasPrograma.Valida H a ∧
        AperturasPrograma.Registrada H (entradas H (ProgramaFRI.verificar k m pos rs bs ds v)) a := by
  have hh := (formas_y_condiciones H k m pos rs bs ds v).mp ha
  have hform : rs.length = m ∧ bs.length = m ∧ ds.length = m := ⟨hh.1, hh.2.1, hh.2.2.1⟩
  have hrec : resultado (tabla H) (recorrer k 0 (rs.zip (bs.zip ds)) ⟨pos, none⟩
      (fun t => .terminar (decide (t.acarreo = some v)))) = true := by
    simpa only [ProgramaFRI.verificar, hform.1, hform.2.1, hform.2.2, and_self, ite_true] using ha
  have hr := registro_recorrido H k 0 (rs.zip (bs.zip ds)) ⟨pos, none⟩ _ hrec
  intro a hm
  refine ⟨todas_validas H k 0 _ _ v hh.2.2.2 a hm, ?_⟩
  simpa only [ProgramaFRI.verificar, hform.1, hform.2.1, hform.2.2, and_self, ite_true] using
    todas_registradas H _ k 0 _ _ hr a hm

theorem origen_en_raices (k j : ℕ) (rs : List Digest) (bs : List Fp2)
    (ds : List Recorrido.Apertura) (s : Recorrido.Estado) (a : AperturasPrograma.Apertura)
    (hm : a ∈ aperturas k j (rs.zip (bs.zip ds)) s) :
    ∃ i : Fin rs.length, a.raiz = rs[i] ∧ a.altura = k + 3 - (j + i.val) := by
  obtain ⟨i, hr, hh⟩ := origen_capa k j _ s a hm
  have hi : i.val < rs.length := by
    have hl := i.isLt
    simp only [List.length_zip] at hl
    omega
  exact ⟨⟨i.val, hi⟩, by simpa using hr, hh⟩

end Nexus.Goldilocks.AperturasFRI
