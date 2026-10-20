module

public import Nexus.Canal.ParametrosRecuperados
public import Nexus.Canal.RetosRecuperados
public import Nexus.Canal.ReconstruccionSelector
public import Nexus.Merkle.Indices
import Mathlib.Tactic

/-!
# Vista semántica de una tabla observada

Los oráculos se indexan por naturales con reducción explícita al tamaño del
árbol. El lector devuelve none cuando no consigue interpretar el candidato.
-/

public section
namespace Nexus.Canal.VistaSemantica

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM ParametrosRecuperados

@[expose] def valor (t : Tabla Entrada Digest) (defecto : Digest) (altura : ℕ) (raiz : Digest) : ℕ → Fp2 :=
  fun i => vectorIndexado formatoBytes (funcionTabla defecto t) (t.map Prod.fst) altura raiz
    ⟨i % 2 ^ altura, Nat.mod_lt _ (by positivity)⟩

@[expose] def capas (t : Tabla Entrada Digest) (defecto : Digest) (altura : ℕ) (rs : List Digest) :
    List (ℕ → Fp2) := rs.zipIdx.map (fun x => valor t defecto (altura - x.2) x.1)

structure Vista where
  datos : DatosCanal
  retos : List Fp2
  base : ℕ → Fp2
  traza : List (ℕ → Fp2)
  composicion : List (ℕ → Fp2)

@[expose] def construir (t : Tabla Entrada Digest) (defecto : Digest) (p : DatosCanal)
    (es : List Entrada) : Vista :=
  ⟨p, RetosRecuperados.retos (funcionTabla defecto t) es, valor t defecto (p.k + 3) p.raiz,
    capas t defecto (p.k + 3) p.rt, capas t defecto (p.k + 3) p.rc⟩

@[expose] def leer (t : Tabla Entrada Digest) (defecto s : Digest) : Option Vista :=
  let es := ReconstruccionSelector.candidato t s
  (ParametrosRecuperados.leer es).map (fun p => construir t defecto p es)

theorem valor_conservado (a b : Tabla Entrada Digest) (defecto : Digest) (altura : ℕ) (raiz : Digest)
    (h : vectorExtraido formatoBytes (funcionTabla defecto a) (a.map Prod.fst) altura raiz =
      vectorExtraido formatoBytes (funcionTabla defecto b) (b.map Prod.fst) altura raiz) :
    valor a defecto altura raiz = valor b defecto altura raiz := by
  have hi := vectores_indexados_iguales formatoBytes _ _ _ _ altura raiz h
  funext i
  exact congrFun hi ⟨i % 2 ^ altura, Nat.mod_lt _ (by positivity)⟩

theorem capas_conservadas (a b : Tabla Entrada Digest) (defecto : Digest) (altura : ℕ) (rs : List Digest)
    (h : ∀ r ∈ rs, ∀ j, valor a defecto j r = valor b defecto j r) :
    capas a defecto altura rs = capas b defecto altura rs := by
  apply List.map_congr_left
  intro x hx
  exact h x.1 (List.fst_mem_of_mem_zipIdx hx) (altura - x.2)

theorem vista_conservada (a b : Tabla Entrada Digest) (defecto : Digest) (p : DatosCanal)
    (es : List Entrada)
    (hr : RetosRecuperados.retos (funcionTabla defecto a) es =
      RetosRecuperados.retos (funcionTabla defecto b) es)
    (hv : ∀ r ∈ p.raiz :: (p.rt ++ p.rc), ∀ j, valor a defecto j r = valor b defecto j r) :
    construir a defecto p es = construir b defecto p es := by
  have hb := hv p.raiz List.mem_cons_self (p.k + 3)
  have ht := capas_conservadas a b defecto (p.k + 3) p.rt
    (fun r h => hv r (List.mem_cons_of_mem _ (List.mem_append_left _ h)))
  have hc := capas_conservadas a b defecto (p.k + 3) p.rc
    (fun r h => hv r (List.mem_cons_of_mem _ (List.mem_append_right _ h)))
  simp only [construir, hr, hb, ht, hc]

theorem lectura_determinada (a b : Tabla Entrada Digest) (defecto s : Digest) (h : a = b) :
    leer a defecto s = leer b defecto s := congrArg (fun t => leer t defecto s) h

end Nexus.Canal.VistaSemantica
