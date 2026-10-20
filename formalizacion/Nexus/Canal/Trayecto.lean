module

public import Nexus.ROM.TablaInversa
public import Nexus.Canal.PrimerasConsultas
import Mathlib.Tactic

/-!
# Recuperación inversa de una cadena de estados del canal

Un origen corto y cada entrada posterior determinan una cadena de hashes.
El extractor usa solo la tabla y la semilla final, con un límite de pasos.
No interpreta las entradas arbitrarias como roles separados de Merkle.
-/

public section
namespace Nexus.Canal.Trayecto

open Nexus.Bytes Nexus.Merkle Nexus.ROM TablaInversa

@[expose] def anterior (e : Entrada) (h : 32 ≤ e.length) : Digest :=
  ⟨e.take 32, by simp only [List.length_take, Nat.min_eq_left h]⟩

theorem anterior_determinado (e : Entrada) (s : Digest) (h : 32 ≤ e.length)
    (hp : e.take 32 = s.val) : anterior e h = s := Subtype.ext hp

inductive Camino (H : Entrada → Digest) : List Entrada → Digest → Prop
  | origen (e : Entrada) (h : e.length < 32) : Camino H [e] (H e)
  | paso {es : List Entrada} {s : Digest} (previo : Camino H es s) (e : Entrada)
      (hp : e.take 32 = s.val) (hc : e.length ≤ 79) : Camino H (es ++ [e]) (H e)

@[expose] def recuperar (t : Tabla Entrada Digest) : ℕ → Digest → List Entrada
  | 0, _ => []
  | n + 1, s => match buscarSalida t s with
      | none => []
      | some e => e :: if h : 32 ≤ e.length then recuperar t n (anterior e h) else []

theorem longitud_positiva {H : Entrada → Digest} {es : List Entrada} {s : Digest}
    (c : Camino H es s) : 0 < es.length := by
  induction c with
  | origen => simp only [List.length_singleton]; omega
  | paso previo e hp hc ih => simp only [List.length_append, List.length_singleton]; omega

theorem salida_final {H : Entrada → Digest} {es : List Entrada} {s : Digest}
    (c : Camino H es s) : ∃ e ∈ es, H e = s := by
  cases c with
  | origen e h => exact ⟨e, (List.mem_singleton_self e), rfl⟩
  | paso previo e hp hc => exact ⟨e, List.mem_append_right _ (List.mem_singleton_self e), rfl⟩

theorem estado_en_ventanas (e : Entrada) (s : Digest) (hp : e.take 32 = s.val)
    (hc : e.length ≤ 79) : s ∈ ventanas e := by
  have hl := congrArg List.length hp
  simp only [List.length_take, s.property] at hl
  apply ventana_por_posicion e 0 (by omega) hc s
  simpa only [List.drop_zero] using hp

theorem reconstruccion_exacta (H : Entrada → Digest) (t : Tabla Entrada Digest)
    (hc : Compatibles H t) (hs : SinColisiones H (t.map Prod.fst))
    {es : List Entrada} {s : Digest} (c : Camino H es s)
    (hq : ∀ e ∈ es, (e, H e) ∈ t) (n : ℕ) (hn : es.length ≤ n) :
    recuperar t n s = es.reverse := by
  induction c generalizing n with
  | origen e he =>
    cases n with
    | zero => simp only [List.length_singleton] at hn; omega
    | succ n =>
      have hi := preimagen_de_tabla H t hc hs e (hq e (List.mem_singleton_self e))
      simp only [recuperar, hi, dite_eq_right (by omega : ¬ 32 ≤ e.length), List.reverse_singleton]
  | @paso es s previo e hp hb ih =>
    cases n with
    | zero => simp only [List.length_append, List.length_singleton] at hn; omega
    | succ n =>
      have hi := preimagen_de_tabla H t hc hs e (hq e (List.mem_append_right _ (List.mem_singleton_self e)))
      have hl := congrArg List.length hp
      simp only [List.length_take, s.property] at hl
      have he : 32 ≤ e.length := by omega
      have hprev : ∀ a ∈ es, (a, H a) ∈ t := fun a ha => hq a (List.mem_append_left _ ha)
      have hlen : es.length ≤ n := by simp only [List.length_append, List.length_singleton] at hn; omega
      simp only [recuperar, hi, he, dite_true]
      rw [anterior_determinado e s he hp, ih hprev n hlen]
      simp only [List.reverse_append, List.reverse_singleton, List.singleton_append]

theorem mismo_pasado_mismo_camino (H G : Entrada → Digest) (t : Tabla Entrada Digest)
    (hcH : Compatibles H t) (hcG : Compatibles G t)
    (hsH : SinColisiones H (t.map Prod.fst)) (hsG : SinColisiones G (t.map Prod.fst))
    {es fs : List Entrada} {s : Digest} (ce : Camino H es s) (cf : Camino G fs s)
    (he : ∀ e ∈ es, (e, H e) ∈ t) (hf : ∀ e ∈ fs, (e, G e) ∈ t) : es = fs := by
  have h1 := reconstruccion_exacta H t hcH hsH ce he (es.length + fs.length) (by omega)
  have h2 := reconstruccion_exacta G t hcG hsG cf hf (es.length + fs.length) (by omega)
  exact List.reverse_injective (h1.symm.trans h2)

end Nexus.Canal.Trayecto
