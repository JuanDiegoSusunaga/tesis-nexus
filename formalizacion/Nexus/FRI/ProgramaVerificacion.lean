module

public import Nexus.Merkle.ProgramaVerificacion
public import Nexus.Verificador.Certificado
import Mathlib.Tactic

/-!
# Verificación FRI que emite sus consultas

Cada capa autentica izquierda y derecha en la tabla común y solo después
comprueba el acarreo. Un fallo impide el resto. El resultado se caracteriza
por todas esas condiciones y por la constante final, y se cuenta cada capa.
Los enteros, campo y listas de esta ejecución siguen siendo matemáticos.
-/

public section
namespace Nexus.Goldilocks.ProgramaFRI

open Nexus.Bytes Nexus.Merkle Nexus.Canal.GramaticaTG2
open Nexus.ROM.ProgramaCompartido Nexus.ROM.RegistroPrograma
open Recorrido
open scoped BigOperators

abbrev Capa := Digest × Fp2 × Apertura

@[expose] noncomputable def siguiente (k j : ℕ) (s : Estado) (d : Apertura) (β : Fp2) : Estado :=
  ⟨s.posicion % mitad k j, some (plegar k j (s.posicion % mitad k j) d β)⟩

@[expose] noncomputable def paso (k j : ℕ) (s : Estado) (r : Digest) (β : Fp2) (d : Apertura)
    (continuar : Estado → Programa) : Programa := by
  classical
  exact encadenar (Nexus.Merkle.ProgramaVerificacion.verificar r (k + 3 - j)
    (s.posicion % mitad k j) d.izquierda d.pruebaIzquierda)
    (encadenar (Nexus.Merkle.ProgramaVerificacion.verificar r (k + 3 - j)
      (s.posicion % mitad k j + mitad k j) d.derecha d.pruebaDerecha)
      (if Compatible k j s d then continuar (siguiente k j s d β) else .terminar false))

@[expose] noncomputable def recorrer (k : ℕ) : ℕ → List Capa → Estado → (Estado → Programa) → Programa
  | _, [], s, continuar => continuar s
  | j, c :: cs, s, continuar => paso k j s c.1 c.2.1 c.2.2 (fun t => recorrer k (j + 1) cs t continuar)

@[expose] noncomputable def condiciones (H : List Octeto → Digest) (k : ℕ) :
    ℕ → List Capa → Estado → Fp2 → Prop
  | _, [], s, final => s.acarreo = some final
  | j, c :: cs, s, final =>
    Autenticada H c.1 k j (s.posicion % mitad k j) c.2.2 ∧ Compatible k j s c.2.2 ∧
      condiciones H k (j + 1) cs (siguiente k j s c.2.2 c.2.1) final

@[expose] def cuenta (k : ℕ) : ℕ → List Capa → ℕ
  | _, [] => 0
  | j, _ :: cs => 2 * (k + 3 - j + 1) + cuenta k (j + 1) cs

theorem paso_aceptado (H : List Octeto → Digest) (k j : ℕ) (s : Estado) (r : Digest)
    (β : Fp2) (d : Apertura) (continuar : Estado → Programa) :
    resultado (tabla H) (paso k j s r β d continuar) = true ↔
      Autenticada H r k j (s.posicion % mitad k j) d ∧ Compatible k j s d ∧
        resultado (tabla H) (continuar (siguiente k j s d β)) = true := by
  classical
  by_cases hc : Compatible k j s d
  · simp only [paso, hc, ite_true, resultado_encadenado, Bool.and_eq_true,
      Nexus.Merkle.ProgramaVerificacion.aceptacion_equivale, Autenticada, true_and]
    tauto
  · simp only [paso, hc, ite_false, resultado_encadenado, Bool.and_eq_true,
      resultado, Bool.false_eq_true, and_false, false_and]

theorem recorrido_aceptado (H : List Octeto → Digest) (k j : ℕ) (cs : List Capa)
    (s : Estado) (final : Fp2) :
    resultado (tabla H) (recorrer k j cs s (fun t => .terminar (decide (t.acarreo = some final)))) = true ↔
      condiciones H k j cs s final := by
  induction cs generalizing j s with
  | nil => simp only [recorrer, resultado, decide_eq_true_eq, condiciones]
  | cons c cs ih => rw [recorrer, paso_aceptado, ih]; rfl

@[expose] noncomputable def verificar (k m pos : ℕ) (rs : List Digest) (bs : List Fp2)
    (ds : List Apertura) (final : Fp2) : Programa :=
  if rs.length = m ∧ bs.length = m ∧ ds.length = m then
    recorrer k 0 (rs.zip (bs.zip ds)) ⟨pos, none⟩ (fun t => .terminar (decide (t.acarreo = some final)))
  else .terminar false

theorem formas_y_condiciones (H : List Octeto → Digest) (k m pos : ℕ) (rs : List Digest)
    (bs : List Fp2) (ds : List Apertura) (final : Fp2) :
    resultado (tabla H) (verificar k m pos rs bs ds final) = true ↔
      rs.length = m ∧ bs.length = m ∧ ds.length = m ∧
        condiciones H k 0 (rs.zip (bs.zip ds)) ⟨pos, none⟩ final := by
  by_cases h : rs.length = m ∧ bs.length = m ∧ ds.length = m
  · rw [verificar, ite_eq_left h, recorrido_aceptado]
    tauto
  · rw [verificar, ite_eq_right h]
    simp only [resultado, Bool.false_eq_true]
    tauto

theorem longitud_incorrecta_rechaza (k m pos : ℕ) (rs : List Digest) (bs : List Fp2)
    (ds : List Apertura) (final : Fp2) (h : rs.length ≠ m ∨ bs.length ≠ m ∨ ds.length ≠ m) :
    verificar k m pos rs bs ds final = .terminar false := by
  have hn : ¬(rs.length = m ∧ bs.length = m ∧ ds.length = m) := by tauto
  exact ite_eq_right hn

theorem presupuesto_paso (k j : ℕ) (s : Estado) (r : Digest) (β : Fp2) (d : Apertura)
    (continuar : Estado → Programa) (C : ℕ) (hc : ∀ t, Nexus.Canal.ProgramaTG2.Acotado (continuar t) C) :
    Nexus.Canal.ProgramaTG2.Acotado (paso k j s r β d continuar) (2 * (k + 3 - j + 1) + C) := by
  classical
  have hfinal : Nexus.Canal.ProgramaTG2.Acotado
      (if Compatible k j s d then continuar (siguiente k j s d β) else .terminar false) C := by
    split
    · exact hc _
    · intro H; exact Nat.zero_le _
  have h := presupuesto_encadenado _ _ _ _
    (Nexus.Merkle.ProgramaVerificacion.presupuesto_verificacion r (k + 3 - j)
      (s.posicion % mitad k j) d.izquierda d.pruebaIzquierda)
    (presupuesto_encadenado _ _ _ _
      (Nexus.Merkle.ProgramaVerificacion.presupuesto_verificacion r (k + 3 - j)
        (s.posicion % mitad k j + mitad k j) d.derecha d.pruebaDerecha) hfinal)
  have he : 2 * (k + 3 - j + 1) + C =
      (k + 3 - j + 1) + ((k + 3 - j + 1) + C) := by omega
  rw [he]
  exact h

theorem presupuesto_recorrido (k j : ℕ) (cs : List Capa) (s : Estado)
    (continuar : Estado → Programa) (C : ℕ) (hc : ∀ t, Nexus.Canal.ProgramaTG2.Acotado (continuar t) C) :
    Nexus.Canal.ProgramaTG2.Acotado (recorrer k j cs s continuar) (cuenta k j cs + C) := by
  induction cs generalizing j s with
  | nil => simpa only [recorrer, cuenta, Nat.zero_add] using hc s
  | cons c cs ih =>
    have h := presupuesto_paso k j s c.1 c.2.1 c.2.2 (fun t => recorrer k (j + 1) cs t continuar)
      (cuenta k (j + 1) cs + C) (fun t => ih (j + 1) t)
    simpa only [recorrer, cuenta, Nat.add_assoc] using h

theorem cuenta_por_longitud (k j : ℕ) (cs : List Capa) :
    cuenta k j cs = 2 * (Nexus.Complejidad.Comunicacion.caminos (k + 3 - j) cs.length + cs.length) := by
  induction cs generalizing j with
  | nil => simp [cuenta, Nexus.Complejidad.Comunicacion.caminos]
  | cons c cs ih =>
    simp only [cuenta, List.length_cons, ih]
    unfold Nexus.Complejidad.Comunicacion.caminos
    rw [Finset.sum_range_succ']
    have he : (Finset.range cs.length).sum (fun x => (k + 3 - j) - (x + 1)) =
        (Finset.range cs.length).sum (fun x => (k + 3 - (j + 1)) - x) := by
      apply Finset.sum_congr rfl
      intro x hx
      omega
    rw [he]
    omega

theorem presupuesto_verificacion (k m pos : ℕ) (rs : List Digest) (bs : List Fp2)
    (ds : List Apertura) (final : Fp2) :
    Nexus.Canal.ProgramaTG2.Acotado (verificar k m pos rs bs ds final)
      (2 * (Nexus.Complejidad.Comunicacion.caminos (k + 3) m + m)) := by
  by_cases hl : rs.length = m ∧ bs.length = m ∧ ds.length = m
  · rw [verificar, ite_eq_left hl]
    have h := presupuesto_recorrido k 0 (rs.zip (bs.zip ds)) ⟨pos, none⟩
      (fun t => .terminar (decide (t.acarreo = some final))) 0 (by intro t H; exact Nat.zero_le _)
    have he : (rs.zip (bs.zip ds)).length = m := by simp [List.length_zip, hl.1, hl.2.1, hl.2.2]
    simpa only [cuenta_por_longitud, Nat.sub_zero, he, Nat.add_zero] using h
  · rw [verificar, ite_eq_right hl]
    intro H
    exact Nat.zero_le _

theorem paso_option_coincide (H : List Octeto → Digest) (k j : ℕ) (s : Estado)
    (r : Digest) (β : Fp2) (d : Apertura)
    (h : Autenticada H r k j (s.posicion % mitad k j) d ∧ Compatible k j s d) :
    Recorrido.paso H k j r β d s = some (siguiente k j s d β) := by
  classical
  simp [Recorrido.paso, h.1, h.2, siguiente]

theorem aceptacion_paso_option (H : List Octeto → Digest) (k j : ℕ) (s : Estado)
    (r : Digest) (β : Fp2) (d : Apertura) (continuar : Estado → Programa) :
    resultado (tabla H) (paso k j s r β d continuar) = true ↔
      ∃ t, Recorrido.paso H k j r β d s = some t ∧ resultado (tabla H) (continuar t) = true := by
  classical
  rw [paso_aceptado]
  unfold Recorrido.paso
  split_ifs with h
  · simp_all [siguiente]
  · simp_all

@[expose] noncomputable def registradas (H : List Octeto → Digest) (log : List (List Octeto))
    (k : ℕ) : ℕ → List Capa → Estado → Prop
  | _, [], _ => True
  | j, c :: cs, s => Registrada H log k j (s.posicion % mitad k j) c.2.2 ∧
      registradas H log k (j + 1) cs (siguiente k j s c.2.2 c.2.1)

theorem registro_paso (H : List Octeto → Digest) (k j : ℕ) (s : Estado) (r : Digest)
    (β : Fp2) (d : Apertura) (c : Estado → Programa)
    (ha : resultado (tabla H) (paso k j s r β d c) = true) :
    Registrada H (entradas H (paso k j s r β d c)) k j (s.posicion % mitad k j) d := by
  have hh := (paso_aceptado H k j s r β d c).mp ha
  classical
  simp only [paso, hh.2.1, ite_true] at ha ⊢
  obtain ⟨hl, hr⟩ := aceptacion_ambos _ _ _ ha
  obtain ⟨hr, _⟩ := aceptacion_ambos _ _ _ hr
  have l := Nexus.Merkle.ProgramaVerificacion.aceptacion_produce_registro H r (k + 3 - j)
    (s.posicion % mitad k j) d.izquierda d.pruebaIzquierda hl
  have r := Nexus.Merkle.ProgramaVerificacion.aceptacion_produce_registro H r (k + 3 - j)
    (s.posicion % mitad k j + mitad k j) d.derecha d.pruebaDerecha hr
  constructor
  · intro e he
    exact (primero_registrado H _ _).subset (l e he)
  · intro e he
    exact segundo_registrado H _ _ hl e ((primero_registrado H _ _).subset (r e he))

theorem continuacion_registrada (H : List Octeto → Digest) (k j : ℕ) (s : Estado) (r : Digest)
    (β : Fp2) (d : Apertura) (c : Estado → Programa)
    (ha : resultado (tabla H) (paso k j s r β d c) = true) :
    ∀ e ∈ entradas H (c (siguiente k j s d β)), e ∈ entradas H (paso k j s r β d c) := by
  have hh := (paso_aceptado H k j s r β d c).mp ha
  classical
  simp only [paso, hh.2.1, ite_true] at ha ⊢
  obtain ⟨hl, hr⟩ := aceptacion_ambos _ _ _ ha
  obtain ⟨hr, _⟩ := aceptacion_ambos _ _ _ hr
  intro e he
  exact segundo_registrado H _ _ hl e (segundo_registrado H _ _ hr e he)

theorem registradas_monotona (H : List Octeto → Digest) (a b : List (List Octeto))
    (hab : ∀ e ∈ a, e ∈ b) (k j : ℕ) (cs : List Capa) (s : Estado)
    (ha : registradas H a k j cs s) : registradas H b k j cs s := by
  induction cs generalizing j s with
  | nil => trivial
  | cons c cs ih =>
    exact ⟨⟨fun e he => hab e (ha.1.1 e he), fun e he => hab e (ha.1.2 e he)⟩, ih _ _ ha.2⟩

theorem registro_recorrido (H : List Octeto → Digest) (k j : ℕ) (cs : List Capa) (s : Estado)
    (c : Estado → Programa) (ha : resultado (tabla H) (recorrer k j cs s c) = true) :
    registradas H (entradas H (recorrer k j cs s c)) k j cs s := by
  induction cs generalizing j s with
  | nil => trivial
  | cons x cs ih =>
    have hp : resultado (tabla H) (paso k j s x.1 x.2.1 x.2.2
        (fun t => recorrer k (j + 1) cs t c)) = true := ha
    have hh := (paso_aceptado _ _ _ _ _ _ _ _).mp hp
    exact ⟨registro_paso _ _ _ _ _ _ _ _ hp,
      registradas_monotona _ _ _ (continuacion_registrada _ _ _ _ _ _ _ _ hp) _ _ _ _
        (ih _ _ hh.2.2)⟩

end Nexus.Goldilocks.ProgramaFRI
