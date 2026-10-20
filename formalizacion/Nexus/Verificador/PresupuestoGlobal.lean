module

public import Nexus.Verificador.ExcesoRondas
import Mathlib.Tactic

/-!
# Presupuesto global derivado del adversario y del verificador de bytes

Se incluyen propuestas malformadas, rechazos e intercalaciones. Q cuenta
todas las llamadas adversarias de la ejecución. La cota obtenida es sobre
entradas distintas, sin identificar la altura del programa con Q+V.
-/

public section
namespace Nexus.Verificador.PresupuestoGlobal

open Nexus.Bytes Nexus.Merkle Nexus.ROM Nexus.Canal
open ProgramaBytes SelectorAdaptativo FiltroSelector

variable {A : Type}
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

@[expose] def V (R : ℕ) : ℕ := ROM.Presupuestos.verificadorPerfil 12 R
@[expose] def B (Q R : ℕ) : ℕ := Q + V R

theorem perfil_maximo (k R : ℕ) (hk : k ≤ 12) :
    ROM.Presupuestos.verificadorPerfil k R ≤ V R := by
  interval_cases k <;>
    norm_num [V, ROM.Presupuestos.verificadorPerfil, ROM.Presupuestos.caminosPerfil,
      ROM.Presupuestos.hojasPerfil, ROM.Presupuestos.canalPerfil,
      Nexus.Complejidad.Comunicacion.sumaTG2, Nexus.Complejidad.Comunicacion.caminos,
      Finset.sum_range_succ] <;> omega

theorem costo_maximo (R : ℕ) : V R = 24383 + R := by
  norm_num [V, ROM.Presupuestos.verificadorPerfil, ROM.Presupuestos.caminosPerfil,
    ROM.Presupuestos.hojasPerfil, ROM.Presupuestos.canalPerfil,
    Nexus.Complejidad.Comunicacion.sumaTG2, Nexus.Complejidad.Comunicacion.caminos,
    Finset.sum_range_succ]
  omega

theorem presupuesto_bytes (bits R : ℕ) (bs : List Octeto) :
    ProgramaTG2.Acotado (Completo.desdeBytes bits R bs) (V R) := by
  classical
  cases hd : Lectura.exacto codecCertificado.leer bs with
  | none =>
    rw [Completo.parser_rechaza_sin_hash bits R bs hd]
    intro H
    exact Nat.zero_le _
  | some c =>
    simp only [Completo.desdeBytes, hd]
    by_cases hf : Forma (Nat.log2 c.enunciado.pasos) bits c
    · intro H
      exact (Completo.presupuesto_verificador _ bits R c H).trans
        (perfil_maximo _ R hf.1.2.1)
    · rw [Completo.rechazo_previo_sin_consultas _ bits R c hf]
      intro H
      exact Nat.zero_le _

theorem llamadas_totales (H : Entrada → Digest) (bits R Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (hQ : Adversario.adversarias H bits R proponer atacar actualizar ≤ Q) :
    (traza H (Adversario.ejecutar bits R proponer atacar actualizar)).length ≤ B Q R :=
  Adversario.presupuesto_condicional H bits R Q (V R) proponer atacar actualizar hQ
    (presupuesto_bytes bits R _)

theorem entradas_distintas (H : Entrada → Digest) (bits R Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (hQ : Adversario.adversarias H bits R proponer atacar actualizar ≤ Q) :
    (entradas H (Adversario.ejecutar bits R proponer atacar actualizar)).toFinset.card ≤ B Q R := by
  have hc := List.toFinset_card_le (entradas H (Adversario.ejecutar bits R proponer atacar actualizar))
  simp only [entradas, List.length_map] at hc
  exact hc.trans (llamadas_totales H bits R Q proponer atacar actualizar hQ)

theorem cota_desde_Q (L bits R k Q : ℕ)
    (proponer : Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A) (defecto : Digest)
    (he : k + 2 ≤ 64) (hqM : 40 ≤ 2 ^ (k + 2)) (hqR : 40 ≤ R)
    (hQ : ∀ H : universo (Adversario.ejecutar bits R proponer atacar actualizar) → Digest,
      Adversario.adversarias (oraculo (Adversario.ejecutar bits R proponer atacar actualizar) defecto H)
        bits R proponer atacar actualizar ≤ Q) :
    let p := Adversario.ejecutar bits R proponer atacar actualizar
    medida (fun H : universo p → Digest =>
      PoliticasFalsas.AceptaFalsa (oraculo p defecto H) bits R k proponer atacar actualizar) ≤
    medida (fun H : universo p → Digest => ¬ EjecucionBytes.SinBad (oraculo p defecto H) (inicial L) p) +
    medida (fun H : universo p → Digest => ExcesoRondas.Rondas (oraculo p defecto H) p defecto (altura p)) +
      ROM.SelectorPrimeras.riesgo R (k + 2) 40 (CardinalVista.umbral (k + 2)) (B Q R - 1) * B Q R :=
  ExcesoRondas.cota_aceptacion L bits R k (B Q R) proponer atacar actualizar defecto he hqM hqR
    (fun H => entradas_distintas _ bits R Q proponer atacar actualizar (hQ H))

theorem presupuesto_512 (Q : ℕ) : B Q 512 = Q + 24895 := by
  norm_num [B, costo_maximo]

end Nexus.Verificador.PresupuestoGlobal
