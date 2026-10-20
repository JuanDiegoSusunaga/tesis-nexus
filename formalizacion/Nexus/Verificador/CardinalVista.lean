module

public import Nexus.Verificador.ConsultaCampo
public import Nexus.N06.CardinalCompartida
import Mathlib.Tactic

/-!
# Cardinal de los conjuntos buenos originales

El umbral se deriva de la cota AIR/FRI para un prefijo seguro. No se filtran
los conjuntos para hacer cierta la conclusión. La seguridad del prefijo
se mantiene como condición determinista, cuya probabilidad queda pendiente.
-/

public section
namespace Nexus.Verificador.CardinalVista

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open VistaSemantica VistaCampo VectoresCampo ConjuntosPrevios FiltroFalso

@[expose] def umbral (e : ℕ) : ℕ := 7 * 2 ^ e / 8

theorem cardinal_vista (v : Vista) (hk0 : 4 ≤ v.datos.k) (hk : v.datos.k ≤ 29)
    (hv : FormaVista v) (hs : PrefijoSeguro v.datos.k hk v.datos.inicio v.datos.salida (prefijo v))
    (e : ℕ) : (buenos e pruebaTraza v ∩ buenos e pruebaComposicion v).card ≤ umbral e := by
  classical
  by_cases he : v.datos.k + 2 = e
  · subst e
    let G := buenos (v.datos.k + 2) pruebaTraza v ∩ buenos (v.datos.k + 2) pruebaComposicion v
    have hc := CardinalCompartida.cardinal_subconjunto v.datos.k hk0 hk v.datos.inicio v.datos.salida
      (prefijo v) hs (muestra v.datos.k G) (muestra_dominio _ _) (by
        intro y hy
        obtain ⟨i, hi, rfl⟩ := Finset.mem_image.mp hy
        have ht := (pertenencia_buenos _ pruebaTraza v i).mp (Finset.mem_inter.mp hi).1
        have hp := (pertenencia_buenos _ pruebaComposicion v i).mp (Finset.mem_inter.mp hi).2
        exact ConsultaCampo.consulta_buena v hk0 hk hv i ht.2 hp.2)
    rw [muestra_cardinal _ hk] at hc
    have hm : 4 * 2 ^ v.datos.k = 2 ^ (v.datos.k + 2) := by
      simp only [pow_add, show (2 : ℕ) ^ 2 = 4 by decide, Nat.mul_comm]
    rw [hm] at hc
    dsimp only [G] at hc
    exact (Nat.le_div_iff_mul_le (by decide : 0 < 8)).mpr (by omega)
  · have hz : buenos e pruebaTraza v = ∅ := by
      ext i
      simp only [pertenencia_buenos, he, false_and, Finset.notMem_empty]
    simp only [hz, Finset.empty_inter, Finset.card_empty, Nat.zero_le]

theorem cardinal_canonico (t : Tabla Entrada Digest) (defecto s : Digest)
    (d : ParametrosRecuperados.DatosCanal) (hc : Canonico t defecto s d)
    (hs : PrefijoSeguro d.k (by have hk := hc.perfil.1.2; omega) d.inicio d.salida
      (prefijo (construir t defecto d (ReconstruccionSelector.candidato t s)))) (e : ℕ) :
    (ConjuntosPrevios.GT e defecto s t ∩ ConjuntosPrevios.GC e defecto s t).card ≤ umbral e := by
  rw [ConjuntosPrevios.GT, ConjuntosPrevios.GC, politica, politica,
    lectura_canonica t defecto s d hc]
  exact cardinal_vista _ hc.perfil.1.1 (Nat.le_trans hc.perfil.1.2 (by decide : 12 ≤ 29))
    (forma_canonica t defecto s d hc) hs e

theorem umbral_perfil (k : ℕ) (hk : 1 ≤ k) : umbral (k + 2) = 7 * 2 ^ (k - 1) := by
  have he : k + 2 = k - 1 + 3 := by omega
  simp only [umbral, he, pow_add, show (2 : ℕ) ^ 3 = 8 by decide, ← Nat.mul_assoc,
    Nat.mul_div_cancel _ (by decide : 0 < 8)]

theorem umbrales_extremos : umbral 6 = 56 ∧ umbral 14 = 14336 := by decide

end Nexus.Verificador.CardinalVista
