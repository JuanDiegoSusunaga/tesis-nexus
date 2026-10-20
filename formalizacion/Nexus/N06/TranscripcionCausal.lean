module

public import Nexus.N06.Prefijos
public import Nexus.N06.ReiniciosIdeal
import Mathlib.Tactic

/-!
# Prefijos tipados de la ejecución de una política causal

Las longitudes y fases están en el tipo. Los retos se añaden en orden;
la marca y el acumulador AIR se reconstruyen desde el prefijo. La política
determina el contenido de cada mensaje antes de su reto. Esta expansión
de una política no es todavía una función sobre transcripciones arbitrarias
independiente de la estrategia ni un adaptador del ejecutable Rust.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

inductive TranscripcionCausal (k q : ℕ) where
  | vacia
  | air (j : Fin 4) (a : Retos Fp2 j.val)
  | traza (a : Retos Fp2 3) (j : Fin (k + 1)) (bt : Retos Fp2 j.val) (listo : Bool)
  | composicion (a : Retos Fp2 3) (bt : Retos Fp2 k)
      (j : Fin (k + 2)) (bc : Retos Fp2 j.val) (listo : Bool)
  | consulta (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
  | salida (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
      (S : MuestraParejas (dominioCapa k 1) q)

/-- Proyección con marca calculada, sin un campo libre para declararla. -/
@[expose] noncomputable def nodoCausal (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q : ℕ) : TranscripcionCausal k q → NodoIdeal k
  | .vacia => .raiz
  | .air j a => .air j (recorrerEstado (pasoAIR (residuosVigilados k s o p)) 0 j 0 a)
      (recorrerMarca (excepcionesCriticas (residuosVigilados k s o p))
        (pasoAIR (residuosVigilados k s o p)) 0 j 0 false a)
  | .traza a j bt _ => .traza a j (listaRetos bt)
      (recorrerMarca (monitorTraza k hk p a) (fun _ h x => h ++ [x])
        0 j [] (marcaAIR k s o p a) bt)
  | .composicion a bt j bc _ => .composicion a bt j (listaRetos bc)
      (recorrerMarca (monitorComposicion k hk p a bt) (fun _ h x => h ++ [x])
        0 j [] (marcaTraza k hk s o p a bt) bc)
  | .consulta a bt bc => .consulta a bt bc
  | .salida a bt bc S => .salida a bt bc S.val

@[expose] def EnunciadoValido (k : ℕ) (s o : Fp) : Prop :=
  ∃ A : Polynomial Fp, A.natDegree < 2 ^ k ∧ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o

/-- En un enunciado válido el estado es uno desde la transcripción vacía. -/
@[expose] noncomputable def estadoCausal (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q : ℕ) (t : TranscripcionCausal k q) : Bool := by
  classical
  exact decide (EnunciadoValido k s o) || marcaNodo k hk s o p (nodoCausal k hk s o p q t)

theorem estado_causal_valido (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (q : ℕ) (t : TranscripcionCausal k q) (hv : EnunciadoValido k s o) :
    estadoCausal k hk s o p q t = true := by
  simp only [estadoCausal, hv, decide_true, Bool.true_or]

theorem estado_causal_falso (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (q : ℕ) (t : TranscripcionCausal k q) (hf : ¬ EnunciadoValido k s o) :
    estadoCausal k hk s o p q t = marcaNodo k hk s o p (nodoCausal k hk s o p q t) := by
  simp only [estadoCausal, hf, decide_false, Bool.false_or]

theorem estado_causal_inicial_iff (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q : ℕ) :
    estadoCausal k hk s o p q .vacia = true ↔ EnunciadoValido k s o := by
  simp only [estadoCausal, nodoCausal, marcaNodo, Bool.or_false, decide_eq_true_eq]

/-- Pasos sin monedas: emisión de mensajes o cambio administrativo de fase. -/
inductive PasoSinReto (k q : ℕ) : TranscripcionCausal k q → TranscripcionCausal k q → Type
  | inicial : PasoSinReto k q .vacia (.air ⟨0, by omega⟩ PUnit.unit)
  | abrirTraza (a : Retos Fp2 3) :
      PasoSinReto k q (.air ⟨3, by omega⟩ a) (.traza a ⟨0, by omega⟩ PUnit.unit true)
  | capaTraza (a : Retos Fp2 3) (j : Fin k) (bt : Retos Fp2 j.val) :
      PasoSinReto k q (.traza a ⟨j, by omega⟩ bt false) (.traza a ⟨j, by omega⟩ bt true)
  | cerrarTraza (a : Retos Fp2 3) (bt : Retos Fp2 k) (listo : Bool) :
      PasoSinReto k q (.traza a ⟨k, by omega⟩ bt listo)
        (.composicion a bt ⟨0, by omega⟩ PUnit.unit true)
  | capaComposicion (a : Retos Fp2 3) (bt : Retos Fp2 k) (j : Fin (k + 1))
      (bc : Retos Fp2 j.val) :
      PasoSinReto k q (.composicion a bt ⟨j, by omega⟩ bc false)
        (.composicion a bt ⟨j, by omega⟩ bc true)
  | cerrarComposicion (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
      (listo : Bool) : PasoSinReto k q (.composicion a bt ⟨k + 1, by omega⟩ bc listo)
        (.consulta a bt bc)

/-- Contenido ideal del paso; la lista vacía corresponde al cambio de fase AIR/FRI. -/
@[expose] def contenidoPaso (p : PoliticaConsulta) {k q : ℕ} {t u : TranscripcionCausal k q} :
    PasoSinReto k q t u → List (Fp2 ⊕ (Fp2 → Fp2))
  | .inicial => [.inr p.inicial]
  | .abrirTraza _ => []
  | .capaTraza a j bt => [.inr (estrategiaTraza p a j (listaRetos bt))]
  | .cerrarTraza a bt _ => [.inl (p.constanteTraza a (listaRetos bt)),
      .inr (p.composicion a (listaRetos bt) 0 [])]
  | .capaComposicion a bt j bc => [.inr (p.composicion a (listaRetos bt) j (listaRetos bc))]
  | .cerrarComposicion a bt bc _ => [.inl (p.constanteComposicion a (listaRetos bt) (listaRetos bc))]

theorem paso_sin_reto_conserva_estado (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q : ℕ) {t u : TranscripcionCausal k q} (h : PasoSinReto k q t u) :
    estadoCausal k hk s o p q u = estadoCausal k hk s o p q t := by
  cases h <;> rfl

inductive PeticionCausal (k : ℕ) where
  | air (j : Fin 3) (a : Retos Fp2 j.val)
  | traza (a : Retos Fp2 3) (j : Fin k) (bt : Retos Fp2 j.val)
  | composicion (a : Retos Fp2 3) (bt : Retos Fp2 k)
      (j : Fin (k + 1)) (bc : Retos Fp2 j.val)
  | consulta (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))

abbrev RespuestaCausal (k q : ℕ) : PeticionCausal k → Type
  | .air _ _ => Fp2
  | .traza _ _ _ => Fp2
  | .composicion _ _ _ _ => Fp2
  | .consulta _ _ _ => MuestraParejas (dominioCapa k 1) q

noncomputable instance fintypeRespuestaCausal (k q : ℕ) (r : PeticionCausal k) :
    Fintype (RespuestaCausal k q r) :=
  match r with
  | .air _ _ => inferInstanceAs (Fintype Fp2)
  | .traza _ _ _ => inferInstanceAs (Fintype Fp2)
  | .composicion _ _ _ _ => inferInstanceAs (Fintype Fp2)
  | .consulta _ _ _ => inferInstanceAs (Fintype (MuestraParejas (dominioCapa k 1) q))

@[expose] def origenCausal (k q : ℕ) : PeticionCausal k → TranscripcionCausal k q
  | .air j a => .air ⟨j, by omega⟩ a
  | .traza a j bt => .traza a ⟨j, by omega⟩ bt true
  | .composicion a bt j bc => .composicion a bt ⟨j, by omega⟩ bc true
  | .consulta a bt bc => .consulta a bt bc

@[expose] def destinoCausal (k q : ℕ) : (r : PeticionCausal k) →
    RespuestaCausal k q r → TranscripcionCausal k q
  | .air j a, x => .air ⟨j + 1, by omega⟩ (anexarReto a x)
  | .traza a j bt, x => .traza a ⟨j + 1, by omega⟩ (anexarReto bt x) false
  | .composicion a bt j bc, x => .composicion a bt ⟨j + 1, by omega⟩ (anexarReto bc x) false
  | .consulta a bt bc, S => .salida a bt bc S

@[expose] noncomputable def peticionSubyacente (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) : PeticionCausal k → PeticionIdeal k
  | .air j a => .air j (recorrerEstado (pasoAIR (residuosVigilados k s o p)) 0 j 0 a)
      (recorrerMarca (excepcionesCriticas (residuosVigilados k s o p))
        (pasoAIR (residuosVigilados k s o p)) 0 j 0 false a)
  | .traza a j bt => .traza a j (listaRetos bt)
      (recorrerMarca (monitorTraza k hk p a) (fun _ h x => h ++ [x])
        0 j [] (marcaAIR k s o p a) bt)
  | .composicion a bt j bc => .composicion a bt j (listaRetos bc)
      (recorrerMarca (monitorComposicion k hk p a bt) (fun _ h x => h ++ [x])
        0 j [] (marcaTraza k hk s o p a bt) bc)
  | .consulta a bt bc => .consulta a bt bc

@[expose] def respuestaSubyacente (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (q : ℕ) (r : PeticionCausal k) :
    RespuestaCausal k q r → RespuestaIdeal k q (peticionSubyacente k hk s o p r) := by
  cases r <;> exact id

theorem nodo_causal_origen (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (q : ℕ) (r : PeticionCausal k) :
    nodoCausal k hk s o p q (origenCausal k q r) =
      origenIdeal k (peticionSubyacente k hk s o p r) := by
  cases r <;> rfl

theorem nodo_causal_destino (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (q : ℕ) (r : PeticionCausal k) (x : RespuestaCausal k q r) :
    nodoCausal k hk s o p q (destinoCausal k q r x) =
      destinoIdeal k hk s o p q (peticionSubyacente k hk s o p r)
        (respuestaSubyacente k hk s o p q r x) := by
  classical
  cases r <;> simp only [nodoCausal, destinoCausal, peticionSubyacente, destinoIdeal,
    respuestaSubyacente, recorrer_estado_anexar, recorrer_marca_anexar,
    recorrer_estado_historia, lista_retos_anexar, Nat.zero_add, List.nil_append, id_eq] <;> rfl

theorem consulta_causal_marca (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (q : ℕ) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (hf : ¬ EnunciadoValido k s o) :
    estadoCausal k hk s o p q (.consulta a bt bc) = marcaAntesConsulta k hk s o p a bt bc := by
  rw [estado_causal_falso k hk s o p q _ hf]
  rfl

theorem salida_causal_cero_rechaza (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p : PoliticaConsulta)
    (q : ℕ) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (S : MuestraParejas (dominioCapa k 1) q)
    (h : estadoCausal k hk s o p q (.salida a bt bc S) = false) :
    ¬ AceptaCompartida k hk s o (ejecutarPrefijo k p a bt bc) S.val := by
  have hm : marcaFinal k hk s o p a bt bc S.val = false := by
    exact (Bool.or_eq_false_iff.mp h).2
  exact estado_final_cero_rechaza k hk s o p a bt bc S.val hm

end Nexus.Goldilocks
