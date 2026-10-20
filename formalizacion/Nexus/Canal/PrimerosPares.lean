module

public import Nexus.Canal.ConteoPares
public import Nexus.ROM.CargaPrimeras
public import Nexus.ROM.PrefijoPrograma
import Mathlib.Tactic

/-!
# La primera consulta de cada pareja, sin importar el orden de sus dos roles

La activación depende solo del prefijo bruto y de la próxima entrada. Una
pareja aparece una sola vez en ese conteo; cuando se activa, tanto su trabajo
como la absorción del nonce son frescos. Las repeticiones no la reactivan.
-/

public section
namespace Nexus.Canal.PrimerosPares

open Nexus.Bytes Nexus.Merkle Nexus.ROM ParTrabajo ProgramaBytes

attribute [local instance] Classical.propDecidable
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

variable {A : Type}

noncomputable local instance : BEq (Option Clave) := instBEqOfDecidableEq

@[expose] noncomputable def siguiente (p : Programa A) (t : List (Entrada × Digest)) : Option Clave :=
  (PrefijoPrograma.proxima (PrefijoPrograma.reanudar p t)).bind leer

@[expose] noncomputable def clave (p : Programa A) (defecto : Digest) (t : List (Entrada × Digest)) : Clave :=
  (siguiente p t).getD (defecto, 0)

@[expose] noncomputable def Activa (p : Programa A) (defecto : Digest) (t : List (Entrada × Digest)) : Prop :=
  siguiente p t = some (clave p defecto t) ∧ clave p defecto t ∉ claves (t.map Prod.fst)

abbrev Inicia (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (n : ℕ) :=
  Activa p defecto ((traza H p).take n)

theorem mem_mapa (es : List Entrada) (k : Clave) : some k ∈ es.map leer ↔ k ∈ claves es := by
  rw [List.mem_map, mem_claves]

theorem clave_siguiente (p : Programa A) (defecto : Digest) (t : List (Entrada × Digest))
    (k : Clave) (hk : siguiente p t = some k) : clave p defecto t = k := by
  simp only [clave, hk, Option.getD_some]

theorem siguiente_prefijo (H : Entrada → Digest) (p : Programa A) (n : ℕ) :
    siguiente p ((traza H p).take n) = ((entradas H p)[n]?).bind leer := by
  rw [siguiente, PrefijoPrograma.proxima_prefijo]

theorem primera_posicion (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (n : ℕ)
    (hn : Inicia H p defecto n) :
    ((entradas H p).map leer).idxOf (some (clave p defecto ((traza H p).take n))) = n := by
  have hr := hn.1
  rw [siguiente_prefijo] at hr
  have hget : ((entradas H p).map leer)[n]? = some (some (clave p defecto ((traza H p).take n))) := by
    rw [List.getElem?_map]
    cases he : (entradas H p)[n]? with
    | none => simp only [he, Option.bind_none, reduceCtorEq] at hr
    | some e => simpa only [he, Option.bind_some, Option.map_some] using congrArg some hr
  have hf : some (clave p defecto ((traza H p).take n)) ∉ ((entradas H p).map leer).take n := by
    intro hm
    rw [← List.map_take] at hm
    apply hn.2
    simpa only [entradas, List.map_take] using (mem_mapa _ _).mp hm
  exact PrimeraExposicion.indice_primero _ n _ hget hf

theorem clave_inyectiva (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (n m : ℕ)
    (hn : Inicia H p defecto n) (hm : Inicia H p defecto m)
    (hk : clave p defecto ((traza H p).take n) = clave p defecto ((traza H p).take m)) : n = m := by
  have h1 := primera_posicion H p defecto n hn
  rw [hk] at h1
  exact h1.symm.trans (primera_posicion H p defecto m hm)

theorem clave_registrada (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (n : ℕ)
    (hn : Inicia H p defecto n) : clave p defecto ((traza H p).take n) ∈ claves (entradas H p) := by
  have hr := hn.1
  rw [siguiente_prefijo] at hr
  cases he : (entradas H p)[n]? with
  | none => simp only [he, Option.bind_none, reduceCtorEq] at hr
  | some e =>
    have hleer : leer e = some (clave p defecto ((traza H p).take n)) := by
      simpa only [he, Option.bind_some] using hr
    exact (mem_claves _ _).mpr ⟨e, List.mem_of_getElem? he, hleer⟩

theorem carga_claves (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (N : ℕ) :
    ConteoActivaciones.numero (fun n : Fin N => fun H => Inicia H p defecto n.val) H ≤
      (claves (entradas H p)).card := by
  let I := {n : Fin N // Inicia H p defecto n.val}
  let f : I → ↥(claves (entradas H p)) := fun i =>
    ⟨clave p defecto ((traza H p).take i.val.val), clave_registrada H p defecto i.val.val i.property⟩
  have hf : Function.Injective f := by
    intro i j hij
    exact Subtype.ext (Fin.ext (clave_inyectiva H p defecto i.val.val j.val.val i.property j.property
      (congrArg Subtype.val hij)))
  have hc := Fintype.card_le_of_injective f hf
  rw [Fintype.card_coe] at hc
  change Fintype.card I ≤ _ at hc
  have hcard : Fintype.card I = ConteoActivaciones.numero
      (fun n : Fin N => fun H => Inicia H p defecto n.val) H := by
    exact Fintype.card_subtype _
  rw [hcard] at hc
  exact hc

theorem frescura_ambas (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (n : ℕ)
    (hn : Inicia H p defecto n) (b : Bool) :
    PrefijoTrabajo.consulta b (clave p defecto ((traza H p).take n)).1
      (clave p defecto ((traza H p).take n)).2 ∉ (entradas H p).take n := by
  intro hm
  apply hn.2
  rw [List.map_take]
  exact (mem_claves _ _).mpr ⟨_, hm, leer_consulta _ _ _⟩

theorem existe_primera (H : Entrada → Digest) (p : Programa A) (defecto : Digest) (k : Clave)
    (hk : k ∈ claves (entradas H p)) :
    ∃ n, n < (traza H p).length ∧ Inicia H p defecto n ∧ clave p defecto ((traza H p).take n) = k := by
  have hmem := (mem_mapa _ k).mpr hk
  let n := ((entradas H p).map leer).idxOf (some k)
  have hget : ((entradas H p).map leer)[n]? = some (some k) := List.getElem?_idxOf hmem
  have hnext : siguiente p ((traza H p).take n) = some k := by
    rw [siguiente_prefijo]
    rw [List.getElem?_map] at hget
    cases he : (entradas H p)[n]? with
    | none => simp only [he, Option.map_none, reduceCtorEq] at hget
    | some e => simpa only [he, Option.map_some, Option.some.injEq, Option.bind_some] using hget
  have hkey := clave_siguiente p defecto _ k hnext
  refine ⟨n, ?_, ?_, hkey⟩
  · simpa only [n, entradas, List.length_map] using List.idxOf_lt_length_of_mem hmem
  constructor
  · exact hnext.trans (congrArg some hkey.symm)
  · rw [hkey]
    intro hc
    have hm : some k ∈ ((entradas H p).map leer).take n := by
      rw [← List.map_take]
      apply (mem_mapa _ k).mpr
      simpa only [entradas, List.map_take] using hc
    exact (by simp only [n, List.mem_take_iff_idxOf_lt hmem, lt_self_iff_false, not_false_eq_true] :
      some k ∉ ((entradas H p).map leer).take n) hm

theorem carga_adversario (H : Entrada → Digest) (bits R Q : ℕ)
    (proponer : Programa (List Octeto × A)) (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest) (N : ℕ)
    (hQ : Nexus.Verificador.Adversario.adversarias H bits R proponer atacar actualizar ≤ Q) :
    ConteoActivaciones.numero (fun n : Fin N => fun H => Inicia H
      (Nexus.Verificador.Adversario.ejecutar bits R proponer atacar actualizar) defecto n.val) H ≤ Q + 1 := by
  exact (carga_claves H _ defecto N).trans
    ((ConteoPares.adversario H bits R proponer atacar actualizar).trans (Nat.add_le_add_right hQ 1))

end Nexus.Canal.PrimerosPares
