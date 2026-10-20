module

public import Nexus.Canal.RegistroRaices
public import Nexus.Canal.OraculosMerkle
public import Nexus.Merkle.AperturasPrograma
import Mathlib.Tactic

/-!
# Familias congeladas construidas desde un programa de bytes

Cada evento registrado produce su corte de primera exposición. La tabla del
corte es exactamente un prefijo de la tabla efectiva, determinado por la
posición de la primera consulta. La elección de un testigo no altera el oráculo.
-/

public section
namespace Nexus.Canal.FamiliasPrograma

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open RegistroRaices

abbrev CorteEvento {R : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa R) (e : Evento) :=
  CorteRaizReto (EjecucionBytes.final H (inicial B) p) e.estado e.tag e.raiz .extension
    (H (absorcion e)) (respuesta H e)

structure Familia {R : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa R) (es : List Evento) where
  cortes : ∀ i : Fin es.length, CorteEvento H B p es[i]

@[expose] noncomputable def construir {R : Type} (H : Entrada → Digest) (B : ℕ)
    (p : ProgramaBytes.Programa R) (hs : EjecucionBytes.SinBad H (inicial B) p) (es : List Evento)
    (he : ∀ e ∈ es, Registrado H (ProgramaBytes.entradas H p) e) : Familia H B p es where
  cortes i := Classical.choice (EjecucionBytes.origen_raiz_reto_del_registro H B p hs
    es[i].estado es[i].raiz es[i].tag .extension (he es[i] (List.get_mem ..)).1 (he es[i] (List.get_mem ..)).2)

@[expose] noncomputable def oraculo {R : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa R} {es : List Evento} (f : Familia H B p es)
    (k : ℕ) (defecto : Digest) (i : Fin es.length) : Fp2 → Fp2 :=
  oraculoEnEstado k i.val defecto (f.cortes i).segunda.antes es[i].raiz

theorem tabla_corte {B : ℕ} {fin : Estado B} {estado raiz dAbs dReto : Digest}
    {tag : Octeto} {tipo : TipoReto} (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto) :
    c.segunda.antes.tabla = fin.tabla.take (posicionConsulta fin.tabla (entradaReto dAbs tipo)) := by
  rw [corte_posicion c.segunda]
  obtain ⟨resto, hr⟩ := recorrido_tabla_prefijo c.segunda.sufijo
  rw [hr]
  change _ = ((c.segunda.antes.tabla ++ _) ++ resto).take c.segunda.antes.tabla.length
  rw [List.append_assoc]
  simp

theorem depende_del_prefijo {R : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa R} {es : List Evento} (f : Familia H B p es)
    (k : ℕ) (defecto : Digest) (i : Fin es.length) :
    let t := (EjecucionBytes.final H (inicial B) p).tabla
    let pref := t.take (posicionConsulta t (reto H es[i]))
    oraculo f k defecto i = oraculoMerkle k i.val (funcionTabla defecto pref) (pref.map Prod.fst) es[i].raiz := by
  dsimp only
  unfold oraculo oraculoEnEstado
  rw [tabla_corte (f.cortes i)]
  rfl

theorem independiente_del_testigo {R : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa R} {es : List Evento} (f g : Familia H B p es)
    (k : ℕ) (defecto : Digest) (i : Fin es.length) : oraculo f k defecto i = oraculo g k defecto i := by
  rw [depende_del_prefijo, depende_del_prefijo]

theorem coincide_con_final {R : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa R} {es : List Evento} (f : Familia H B p es)
    (k : ℕ) (defecto : Digest) (i : Fin es.length) :
    oraculo f k defecto i = oraculoEnEstado k i.val defecto (EjecucionBytes.final H (inicial B) p) es[i].raiz :=
  oraculo_antes_reto_estable (f.cortes i) k i.val defecto

@[expose] noncomputable def emitidos {R : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa R} {es : List Evento} (f : Familia H B p es) (k : ℕ) (defecto : Digest) :
    OraculosEmitidos es.length := capturarOraculos es.length
      (fun j => if hj : j < es.length then oraculo f k defecto ⟨j, hj⟩ else fun _ => 0)

theorem leer_emision {R : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa R} {es : List Evento} (f : Familia H B p es)
    (k : ℕ) (defecto : Digest) (i : Fin es.length) :
    leerOraculo (emitidos f k defecto) i.val = oraculo f k defecto i := by
  rw [emitidos, leer_captura_oraculos _ _ _ i.isLt, dite_eq_left i.isLt]

theorem apertura_en_familia {R : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa R} {es : List Evento} (f : Familia H B p es)
    (k : ℕ) (hk : k ≤ 29) (defecto : Digest) (i : Fin es.length) (hj : i.val ≤ k + 3)
    (a : AperturasPrograma.Apertura) (hr : a.raiz = es[i].raiz) (halt : a.altura = k + 3 - i.val)
    (hi : a.indice < 2 ^ a.altura) (ha : AperturasPrograma.Valida H a)
    (hq : AperturasPrograma.Registrada H (ProgramaBytes.entradas H p) a) :
    leerOraculo (emitidos f k defecto) i.val (puntoCapa k i.val a.indice) = a.valor := by
  rw [leer_emision]
  exact AperturasPrograma.valor_en_oraculo_previo H B p (f.cortes i) defecto k i.val hk hj a hr halt hi ha hq

end Nexus.Canal.FamiliasPrograma
