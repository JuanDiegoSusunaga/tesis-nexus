module

public import Nexus.Canal.CongelacionPrograma
public import Nexus.FRI.OraculoMerkle
import Mathlib.Tactic

/-!
# Aperturas con su raíz, posición y soporte efectivo

La misma estructura describe las seis hojas AIR y las parejas de cada capa
FRI. Se transportan autenticación, soporte y extracción a un registro global.
-/

public section
namespace Nexus.Merkle.AperturasPrograma

open Nexus.Bytes Nexus.Goldilocks Nexus.ROM

structure Apertura where
  raiz : Digest
  altura : ℕ
  indice : ℕ
  valor : Fp2
  hermanos : List Digest

@[expose] def Valida (H : Entrada → Digest) (a : Apertura) : Prop :=
  VerificaIndice formatoBytes H a.raiz a.altura a.indice a.valor a.hermanos

@[expose] def Registrada (H : Entrada → Digest) (log : List Entrada) (a : Apertura) : Prop :=
  AperturaRegistrada formatoBytes H log a.valor (hermanosDesdeRaiz a.indice a.hermanos)

@[expose] def programa (a : Apertura) : ProgramaCompartido.Programa :=
  ProgramaVerificacion.verificar a.raiz a.altura a.indice a.valor a.hermanos

theorem programa_valido (H : Entrada → Digest) (a : Apertura) :
    ProgramaCompartido.resultado (RegistroPrograma.tabla H) (programa a) = true ↔ Valida H a :=
  ProgramaVerificacion.aceptacion_equivale _ _ _ _ _ _

theorem programa_registrado (H : Entrada → Digest) (a : Apertura)
    (ha : ProgramaCompartido.resultado (RegistroPrograma.tabla H) (programa a) = true) :
    Registrada H (RegistroPrograma.entradas H (programa a)) a :=
  ProgramaVerificacion.aceptacion_produce_registro _ _ _ _ _ _ ha

theorem registrada_monotona (H : Entrada → Digest) (x y : List Entrada)
    (hxy : ∀ e ∈ x, e ∈ y) (a : Apertura) (ha : Registrada H x a) : Registrada H y a :=
  fun e he => hxy e (ha e he)

theorem apertura_antes_reto {R : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa R)
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : Nexus.Canal.TipoReto}
    (c : Nexus.Canal.CorteRaizReto (EjecucionBytes.final H (inicial B) p) estado tag raiz tipo dAbs dReto)
    (defecto : Digest) (a : Apertura) (hr : a.raiz = raiz) (ha : Valida H a)
    (hq : Registrada H (ProgramaBytes.entradas H p) a) :
    extraer formatoBytes (funcionTabla defecto c.segunda.antes.tabla)
      (c.segunda.antes.tabla.map Prod.fst) (hermanosDesdeRaiz a.indice a.hermanos |>.map Prod.fst) raiz = a.valor := by
  apply Nexus.Canal.CongelacionPrograma.apertura_antes_del_reto H B p c defecto a.altura a.valor
    (hermanosDesdeRaiz a.indice a.hermanos)
  · apply (verificacion_equivale_apertura _ _ _ _ _ _ _).mp
    simpa only [Valida, hr] using ha
  · exact hq

theorem valor_en_oraculo_previo {R : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa R)
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : Nexus.Canal.TipoReto}
    (c : Nexus.Canal.CorteRaizReto (EjecucionBytes.final H (inicial B) p) estado tag raiz tipo dAbs dReto)
    (defecto : Digest) (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3)
    (a : Apertura) (hr : a.raiz = raiz) (halt : a.altura = k + 3 - j)
    (hi : a.indice < 2 ^ a.altura) (ha : Valida H a)
    (hq : Registrada H (ProgramaBytes.entradas H p) a) :
    oraculoMerkle k j (funcionTabla defecto c.segunda.antes.tabla)
      (c.segunda.antes.tabla.map Prod.fst) raiz (puntoCapa k j a.indice) = a.valor := by
  have hv := apertura_antes_reto H B p c defecto a hr ha hq
  have hlen : a.hermanos.length = a.altura := ha.1
  have hic : a.indice < 2 ^ (k + 3 - j) := by simpa only [halt] using hi
  rw [oraculo_merkle_en_indice k j hk hj _ _ raiz ⟨a.indice, hic⟩]
  simpa only [vectorIndexado, ruta_prueba_indexada, hlen, halt] using hv

end Nexus.Merkle.AperturasPrograma
