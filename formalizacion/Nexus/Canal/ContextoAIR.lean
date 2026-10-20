module

public import Nexus.Canal.PrefijoAIR
public import Nexus.N06.Monitores
import Mathlib.Tactic

/-!
# Contexto y excepción AIR calculados exclusivamente con el pasado

El lector usa la cadena inversa de siete pasos anterior a E. Obtiene el
enunciado, la raíz y los coeficientes ya revelados; el candidato polinómico
se calcula sobre el oráculo Merkle de esa misma tabla. Para cualquier tabla,
el conjunto crítico construido tiene cardinal a lo sumo uno.
-/

public section
namespace Nexus.Canal.ContextoAIR

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.N06
open ParametrosRecuperados GramaticaTG2 RegistroRaices
open Nexus.Verificador.FiltroFalso

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

structure Contexto where
  k : ℕ
  inicio : Fp
  salida : Fp
  raiz : Digest
  anteriores : List Fp2

@[expose] def interpretar (H : Entrada → Digest) (es : List Entrada) : Option Contexto := do
  let ee ← es[2]?
  let .enunciado bs ← LecturaAbsorcion.leer ee | none
  let en ← Lectura.exacto codecEnunciado.leer bs.val
  let er ← es[3]?
  let .raizTraza r ← LecturaAbsorcion.leer er | none
  pure ⟨Nat.log2 en.2.2, en.1, en.2.1, r, RetosRecuperados.retos H es⟩

@[expose] def previo (t : Tabla Entrada Digest) (defecto a : Digest) : Option Contexto :=
  interpretar (funcionTabla defecto t) (Trayecto.recuperar t 7 a).reverse

theorem retos_preambulo (H : Entrada → Digest) (d : DatosCanal) :
    RetosRecuperados.retos H (PrefijoAIR.preambulo H d) = [] := by
  let s0 := H (codificar .inicio)
  let s1 := H (entrada s0 (.perfil (ProgramaTG2.perfil d.k d.bits)))
  change RetosRecuperados.retos H
    ([codificar .inicio] ++ [entrada s0 (.perfil (ProgramaTG2.perfil d.k d.bits))] ++
      [entrada s1 (.enunciado (ProgramaTG2.enunciado d.inicio d.salida d.k))] ++
      [entrada (PrefijoAIR.base H d).estado (.raizTraza d.raiz)]) = []
  rw [RetosRecuperados.retos_append, RetosRecuperados.retos_append, RetosRecuperados.retos_append]
  rw [RetosRecuperados.absorcion_sin_reto, RetosRecuperados.absorcion_sin_reto,
    RetosRecuperados.absorcion_sin_reto]
  rfl

theorem retos_cadena (H : Entrada → Digest) (d : DatosCanal) (j : ℕ) :
    RetosRecuperados.retos H (PrefijoAIR.cadena H d j) =
      (evaluarRetos H j (H (absorcion (PrefijoAIR.base H d)))).2 := by
  rw [PrefijoAIR.cadena, RetosRecuperados.retos_append, retos_preambulo,
    RetosRecuperados.retos_de_retos]
  rfl

theorem interpretar_cadena (H : Entrada → Digest) (d : DatosCanal) (j : ℕ) (hk : d.k ≤ 29) :
    interpretar H (PrefijoAIR.cadena H d j) = some
      ⟨d.k, d.inicio, d.salida, d.raiz,
        (evaluarRetos H j (H (absorcion (PrefijoAIR.base H d)))).2⟩ := by
  let s0 := H (codificar .inicio)
  let s1 := H (entrada s0 (.perfil (ProgramaTG2.perfil d.k d.bits)))
  have h2 : (PrefijoAIR.cadena H d j)[2]? =
      some (entrada s1 (.enunciado (ProgramaTG2.enunciado d.inicio d.salida d.k))) := rfl
  have h3 : (PrefijoAIR.cadena H d j)[3]? = some (absorcion (PrefijoAIR.base H d)) := rfl
  have hr : LecturaAbsorcion.leer (absorcion (PrefijoAIR.base H d)) = some (.raizTraza d.raiz) :=
    LecturaAbsorcion.leer_entrada _ (.raizTraza d.raiz)
  unfold interpretar
  simp only [h2, h3, bind, Option.bind_some, LecturaAbsorcion.leer_entrada,
    enunciado_leido d.inicio d.salida d.k hk, hr, Nat.log2_two_pow, retos_cadena, pure]

theorem interpretar_congruente (H G : Entrada → Digest) (es : List Entrada)
    (h : ∀ e ∈ es, H e = G e) : interpretar H es = interpretar G es := by
  unfold interpretar
  rw [RetosRecuperados.retos_congruentes H G es h]

theorem previo_correcto {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (defecto s : Digest) (d : DatosCanal)
    (hc : Canonico fin.tabla defecto s d) (j : ℕ) (hj : j < 3) (c : PrefijoAIR.Corte fin defecto d j) :
    previo c.antes.tabla defecto (PrefijoAIR.estado (funcionTabla defecto fin.tabla) d j) =
      some ⟨d.k, d.inicio, d.salida, d.raiz,
        (evaluarRetos (funcionTabla defecto fin.tabla) j
          (funcionTabla defecto fin.tabla (absorcion (PrefijoAIR.base (funcionTabla defecto fin.tabla) d)))).2⟩ := by
  let G := funcionTabla defecto fin.tabla
  have hantes := ReconstruccionSelector.cadena_antes_corte G r (PrefijoAIR.camino G d j)
    (fun e he => PrefijoAIR.consulta_canonica fin.tabla defecto s d hc e
      (PrefijoAIR.cadena_registrada _ d j (by omega) e he)) c (estado_reto_en_ventanas _ _)
  unfold previo
  rw [PrefijoAIR.reconstruccion_previa r defecto s d hc j hj c, List.reverse_reverse]
  rw [interpretar_congruente (funcionTabla defecto c.antes.tabla) G _ (by
    intro e he
    simp only [funcionTabla, hantes e he, Option.getD_some])]
  exact interpretar_cadena G d j (by have hk := hc.perfil.1.2; omega)

@[expose] noncomputable def acumular (R : ℕ → Polynomial Fp2) :
    ℕ → Polynomial Fp2 → List Fp2 → Polynomial Fp2
  | _, s, [] => s
  | j, s, a :: as => acumular R (j + 1) (s + a • R j) as

@[expose] noncomputable def excepciones (t : Tabla Entrada Digest) (defecto a : Digest) : Finset Fp2 :=
  match previo t defecto a with
  | none => ∅
  | some ctx =>
    match candidatoPerfil ctx.k (oraculoMerkle ctx.k 0 (funcionTabla defecto t) (t.map Prod.fst) ctx.raiz) (1 / 8) with
    | none => ∅
    | some f =>
      let R := residuosPerfil ctx.k f (algebraMap Fp Fp2 ctx.inicio) (algebraMap Fp Fp2 ctx.salida)
      excepcionesCriticas R ctx.anteriores.length (acumular R 0 0 ctx.anteriores)

theorem cardinal_excepciones (t : Tabla Entrada Digest) (defecto a : Digest) :
    (excepciones t defecto a).card ≤ 1 := by
  unfold excepciones
  cases previo t defecto a with
  | none => simp only [Finset.card_empty, zero_le]
  | some ctx =>
    dsimp only
    cases candidatoPerfil ctx.k
        (oraculoMerkle ctx.k 0 (funcionTabla defecto t) (t.map Prod.fst) ctx.raiz) (1 / 8) with
    | none => simp only [Finset.card_empty, zero_le]
    | some f =>
      dsimp only
      exact excepciones_criticas_cardinal _ _ _

end Nexus.Canal.ContextoAIR
