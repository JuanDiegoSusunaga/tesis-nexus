module

public import Nexus.ROM.ProgramaBytes
public import Nexus.ROM.HistoriaCausal
public import Nexus.ROM.ProyeccionDigest
import Mathlib.Tactic

/-!
# Ley fresca para una observación finita de entradas arbitrarias

El dominio de bytes es infinito. Se cuentan las completaciones del conjunto
finito formado por las entradas observadas y la próxima consulta. No se
postula una distribución uniforme sobre todas las funciones de bytes.
La estrategia usa el prefijo de respuestas; la frescura sigue explícita.
-/

public section
namespace Nexus.ROM.HistoriaLocal

open Nexus.Bytes Nexus.Merkle ProgramaBytes

@[expose] def despues {R : Type} : Programa R → List Digest → Programa R
  | p, [] => p
  | .terminar r, _ :: _ => .terminar r
  | .consultar _ f, d :: ds => despues (f d) ds

@[expose] def proxima {R : Type} : Programa R → Entrada
  | .terminar _ => []
  | .consultar e _ => e

@[expose] def estrategia {R : Type} (p : Programa R) (ds : List Digest) : Entrada := proxima (despues p ds)

@[expose] def respuestas {R : Type} (H : Entrada → Digest) (p : Programa R) : List Digest :=
  (traza H p).map Prod.snd

theorem historia_compatible {R : Type} (H : Entrada → Digest) (p : Programa R) :
    HistoriaCausal.Compatible (estrategia p) (respuestas H p) H := by
  induction p with
  | terminar r => intro i; exact Fin.elim0 i
  | consultar e f ih =>
    intro i
    rcases i with ⟨i, hi⟩
    cases i with
    | zero => rfl
    | succ i =>
      have hin : i < (respuestas H (f (H e))).length := by
        simpa only [respuestas, traza, List.map_cons, List.length_cons, Nat.succ_lt_succ_iff] using hi
      simpa only [estrategia, respuestas, traza, List.map_cons, List.take_succ_cons, despues,
        List.getElem_cons_succ] using ih (H e) ⟨i, hin⟩

theorem prefijo_compatible (e : List Digest → Entrada) (ds : List Digest) (H : Entrada → Digest)
    (hc : HistoriaCausal.Compatible e ds H) (n : ℕ) : HistoriaCausal.Compatible e (ds.take n) H := by
  intro i
  have hi : i.val < ds.length := by have h := i.isLt; simp only [List.length_take] at h; omega
  have hn : i.val < n := by have h := i.isLt; simp only [List.length_take] at h; omega
  simpa only [List.take_take, Nat.min_eq_left hn.le, List.getElem_take] using hc ⟨i.val, hi⟩

@[expose] def universo (V : Finset Entrada) (q : Entrada) : Finset Entrada := insert q V

@[expose] def observadas (V : Finset Entrada) (q : Entrada) : Finset (universo V q) :=
  Finset.univ.filter (fun e => e.val ∈ V)

@[expose] def consulta (V : Finset Entrada) (q : Entrada) : universo V q :=
  ⟨q, Finset.mem_insert_self _ _⟩

theorem consulta_fresca (V : Finset Entrada) (q : Entrada) (hq : q ∉ V) :
    consulta V q ∉ observadas V q := by simpa [observadas, consulta] using hq

theorem consulta_repetida (V : Finset Entrada) (q : Entrada) (hq : q ∈ V) :
    consulta V q ∈ observadas V q := by simpa [observadas, consulta] using hq

theorem ley_fresca_local (V : Finset Entrada) (q : Entrada) (H : Entrada → Digest) (d : Digest)
    (hq : q ∉ V) :
    (Fintype.card (FrescuraFinita.Fibra (observadas V q) (fun e => H e.val) (consulta V q) d) : ℚ) /
      Fintype.card (FrescuraFinita.Completaciones (observadas V q) (fun e => H e.val)) =
        1 / (Fintype.card Digest : ℚ) :=
  FrescuraFinita.respuesta_nueva_uniforme _ _ _ _ (consulta_fresca V q hq)

theorem ley_repetida_local (V : Finset Entrada) (q : Entrada) (H : Entrada → Digest) (d : Digest)
    (hq : q ∈ V) (hd : d ≠ H q) :
    Fintype.card (FrescuraFinita.Fibra (observadas V q) (fun e => H e.val) (consulta V q) d) = 0 :=
  FrescuraFinita.respuesta_repetida_distinta_imposible _ _ _ _ (consulta_repetida V q hq) hd

theorem claves_prefijo_sin_cota {R : Type} (H : Entrada → Digest) (p : Programa R) (n : ℕ) :
    (HistoriaCausal.vistas (estrategia p) ((respuestas H p).take n)).card ≤ n :=
  (HistoriaCausal.consultas_distintas_acotadas _ _).trans (List.length_take_le _ _)

theorem tablas_del_prefijo_coinciden {R : Type} (H G : Entrada → Digest) (p : Programa R) (n : ℕ)
    (hg : HistoriaCausal.Compatible (estrategia p) ((respuestas H p).take n) G)
    (e : Entrada) (he : e ∈ HistoriaCausal.vistas (estrategia p) ((respuestas H p).take n)) : G e = H e :=
  HistoriaCausal.acuerdo_historia _ _ _ _ hg (prefijo_compatible _ _ H (historia_compatible H p) n) e he

theorem cilindro_del_prefijo {R : Type} (H G : Entrada → Digest) (p : Programa R) (n : ℕ) :
    HistoriaCausal.Compatible (estrategia p) ((respuestas H p).take n) G ↔
      ∀ e ∈ HistoriaCausal.vistas (estrategia p) ((respuestas H p).take n), G e = H e :=
  HistoriaCausal.historia_es_cilindro _ _ H (prefijo_compatible _ _ H (historia_compatible H p) n) G

theorem respuesta_fresca_del_prefijo {R : Type} (H : Entrada → Digest) (p : Programa R)
    (n : ℕ) (d : Digest)
    (hf : estrategia p ((respuestas H p).take n) ∉
      HistoriaCausal.vistas (estrategia p) ((respuestas H p).take n)) :
    let ds := (respuestas H p).take n
    let V := HistoriaCausal.vistas (estrategia p) ds
    let q := estrategia p ds
    (Fintype.card (FrescuraFinita.Fibra (observadas V q) (fun e => H e.val) (consulta V q) d) : ℚ) /
      Fintype.card (FrescuraFinita.Completaciones (observadas V q) (fun e => H e.val)) =
        1 / (2 ^ 256 : ℚ) := by
  dsimp only
  simpa only [ProyeccionDigest.cardinal_digest, Nat.cast_pow, Nat.cast_ofNat] using
    ley_fresca_local _ _ H d hf

end Nexus.ROM.HistoriaLocal
