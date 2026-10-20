module

public import Nexus.Verificador.ConjuntosPrevios
public import Nexus.Verificador.SoporteCompleto
import Mathlib.Tactic

/-!
# Separación de los retos efectivos de la vista

Los tres alfas y los dos segmentos de betas se recuperan usando las
longitudes del perfil aceptado, sin elegir retos adicionales.
-/

public section
namespace Nexus.Verificador.RetosVista

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open VistaSemantica CandidatoPrevio SemanticaPrevia RegistroRaices

theorem particion_retos (a bt bc : List Fp2) (k : ℕ) (ha : a.length = 3) (ht : bt.length = k) :
    (a ++ bt ++ bc).take 3 = a ∧ ((a ++ bt ++ bc).drop 3).take k = bt ∧
      (a ++ bt ++ bc).drop (3 + k) = bc := by
  have hd : (a ++ bt ++ bc).drop 3 = bt ++ bc := by
    rw [List.append_assoc, List.drop_left' ha]
  refine ⟨?_, ?_, ?_⟩
  · rw [List.append_assoc, List.take_left' ha]
  · rw [hd, List.take_left' ht]
  · rw [← List.drop_drop, hd, List.drop_left' ht]

theorem cantidades_retos (H : Entrada → Digest) (k bits : ℕ) (c : Certificado) (hf : Forma k bits c) :
    (SoporteCompleto.vista H k bits c).alfas.2.length = 3 ∧
      ((SoporteCompleto.vista H k bits c).traza.2.map (beta H)).length = k ∧
      ((SoporteCompleto.vista H k bits c).composicion.2.map (beta H)).length = k + 1 := by
  have hl := forma_implica_cantidades k bits c hf
  refine ⟨RegistroCompleto.alfas_tres H k bits _ _ _ _ _ _ _, ?_, ?_⟩
  · simpa only [SoporteCompleto.vista, RegistroCompleto.evaluar, List.length_map,
      raices_longitud] using hl.1
  · simpa only [SoporteCompleto.vista, RegistroCompleto.evaluar, List.length_map,
      raices_longitud] using hl.2.1

theorem retos_vista (H : Entrada → Digest) (t : Tabla Entrada Digest) (defecto : Digest)
    (k bits : ℕ) (c : Certificado) (hq : ∀ e ∈ cadenaCert H k bits c, buscar t e = some (H e)) :
    (construir t defecto (datosCert k bits c) (cadenaCert H k bits c)).retos =
      (SoporteCompleto.vista H k bits c).alfas.2 ++
      (SoporteCompleto.vista H k bits c).traza.2.map (beta H) ++
      (SoporteCompleto.vista H k bits c).composicion.2.map (beta H) := by
  change RetosRecuperados.retos (funcionTabla defecto t) (cadenaCert H k bits c) = _
  rw [RetosRecuperados.retos_de_tabla H t _ hq defecto]
  exact RetosRecuperados.retos_de_cadena H k bits _ _ _ _ _ _ _ _

theorem segmentos_vista (H : Entrada → Digest) (t : Tabla Entrada Digest) (defecto : Digest)
    (k bits : ℕ) (c : Certificado) (hf : Forma k bits c)
    (hq : ∀ e ∈ cadenaCert H k bits c, buscar t e = some (H e)) :
    let v := construir t defecto (datosCert k bits c) (cadenaCert H k bits c)
    v.retos.take 3 = (SoporteCompleto.vista H k bits c).alfas.2 ∧
      (v.retos.drop 3).take k = (SoporteCompleto.vista H k bits c).traza.2.map (beta H) ∧
      v.retos.drop (3 + k) = (SoporteCompleto.vista H k bits c).composicion.2.map (beta H) := by
  dsimp only
  rw [retos_vista H t defecto k bits c hq]
  have hl := cantidades_retos H k bits c hf
  exact particion_retos _ _ _ k hl.1 hl.2.1

theorem tres_alfas (H : Entrada → Digest) (k bits : ℕ) (c : Certificado) :
    ∃ a0 a1 a2, (SoporteCompleto.vista H k bits c).alfas.2 = [a0, a1, a2] :=
  List.length_eq_three.mp (RegistroCompleto.alfas_tres H k bits _ _ _ _ _ _ _)

end Nexus.Verificador.RetosVista
