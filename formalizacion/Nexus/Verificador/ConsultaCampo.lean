module

public import Nexus.Canal.VistaCampo
public import Nexus.Canal.EnlaceComposicion
import Mathlib.Tactic

/-!
# Los controles buenos de la vista implican la consulta compartida AIR/FRI

Se transfieren los seis valores de base, ambos recorridos con acarreo y
el enlace local de composición. La muestra es la misma para ambas fases.
-/

public section
namespace Nexus.Verificador.ConsultaCampo

open Nexus.Goldilocks Nexus.Canal Nexus.N06
open VistaSemantica VistaCampo VectoresCampo ConjuntosPrevios

set_option maxHeartbeats 800000

theorem valor_air (v : Vista) (hk : v.datos.k ≤ 29) (hv : FormaVista v)
    (i : ℕ) (hi : i < 2 ^ (v.datos.k + 2)) (b : Bool) (j : Fin 3) :
    oraculoTraza (prefijo v) 0 (raizExtension v.datos.k ^ j.val * signoPareja b (puntoCapa v.datos.k 0 i)) =
      v.base (IndicesMaquina.posicionesNaturales (2 ^ (v.datos.k + 3)) i (posicionSeis b j)) := by
  rw [← punto_indice_air v.datos.k hk i j.val b, traza_inicial v hv,
    funcion_en_indice v.datos.k 0 hk (by omega) v.base _ (indice_air_cota _ _ _ _),
    posiciones_seis v.datos.k i hi b j]

theorem base_air (v : Vista) (hk : v.datos.k ≤ 29) (hv : FormaVista v)
    (i : ℕ) (hi : i < 2 ^ (v.datos.k + 2)) (hb : baseCanonica v i) (b : Bool) (j : Fin 3) :
    EsBase (oraculoTraza (prefijo v) 0
      (raizExtension v.datos.k ^ j.val * signoPareja b (puntoCapa v.datos.k 0 i))) := by
  rw [valor_air v hk hv i hi b j]
  exact ⟨_, (hb (posicionSeis b j)).symm⟩

theorem controles_traza (v : Vista) (i : ℕ) (h : pruebaTraza v i) :
    controlesFRI v.datos.k 0 v.traza (betasTraza v) ⟨i, none⟩ v.datos.vt := by
  have ht := h.2
  split at ht
  · exact ht.2.2.2
  · contradiction

theorem datos_composicion (v : Vista) (i : ℕ) (h : pruebaComposicion v i) :
    ∃ t ts a b c, v.composicion = t :: ts ∧ v.retos.take 3 = [a, b, c] := by
  have ht := h.2
  split at ht
  · rename_i t ts a b c he htres
    exact ⟨t, ts, a, b, c, he, htres⟩
  · contradiction

theorem controles_composicion (v : Vista) (i : ℕ) (h : pruebaComposicion v i) :
    controlesFRI v.datos.k 0 v.composicion (betasComposicion v) ⟨i, none⟩ v.datos.vc := by
  obtain ⟨t, ts, a, b, c, ht, ha⟩ := datos_composicion v i h
  have hh := h.2
  simp only [ht, ha] at hh
  simpa only [ht, betasComposicion] using hh.2.2.2

theorem enlace_local (v : Vista) (hk0 : 4 ≤ v.datos.k) (hk : v.datos.k ≤ 29) (hv : FormaVista v)
    (i : ℕ) (hi : i < 2 ^ (v.datos.k + 2)) (hp : pruebaComposicion v i) (b : Bool) :
    oraculoComposicion (prefijo v) 0 (signoPareja b (puntoCapa v.datos.k 0 i)) =
      Nexus.AIR.composicionLocal (2 ^ v.datos.k) (raizExtension v.datos.k)
        (algebraMap Fp Fp2 v.datos.inicio) (algebraMap Fp Fp2 v.datos.salida)
        (prefijo v).coeficientes (oraculoTraza (prefijo v) 0) (signoPareja b (puntoCapa v.datos.k 0 i)) := by
  obtain ⟨t, ts, a0, a1, a2, ht, ha⟩ := datos_composicion v i hp
  have hrest := hp.2
  simp only [ht, ha] at hrest
  have hval (j : Fin 3) :
      oraculoTraza (prefijo v) 0
        (raizExtension v.datos.k ^ j.val * signoPareja b (puntoCapa v.datos.k 0 i)) =
      algebraMap Fp Fp2 (v.base
        (IndicesMaquina.posicionesNaturales (2 ^ (v.datos.k + 3)) i (posicionSeis b j))).re :=
    (valor_air v hk hv i hi b j).trans (hp.1 (posicionSeis b j))
  have hx : signoPareja b (puntoCapa v.datos.k 0 i) ∈ cosetExtension (v.datos.k + 3) := by
    rw [← dominio_capa_inicial]
    exact Finset.mem_image.mpr ⟨indiceAIR v.datos.k i b 0,
      Finset.mem_range.mpr (indice_air_cota _ _ _ _), by
        simpa only [pow_zero, one_mul] using punto_indice_air v.datos.k hk i 0 b⟩
  have hc := composicion_valores_coincide (2 ^ v.datos.k) (raizExtension v.datos.k)
    (algebraMap Fp Fp2 v.datos.inicio) (algebraMap Fp Fp2 v.datos.salida)
    (signoPareja b (puntoCapa v.datos.k 0 i)) (alfas v) (oraculoTraza (prefijo v) 0)
    (fun j => algebraMap Fp Fp2 (v.base
      (IndicesMaquina.posicionesNaturales (2 ^ (v.datos.k + 3)) i (posicionSeis b j))).re)
    hval (raiz_extension_primitiva _ (by omega)) (denominador_extension_no_nulo _ hk0 hk _ hx)
  rw [alfas_de_lista v a0 a1 a2 ha] at hc
  change _ = Nexus.AIR.composicionLocal _ _ _ _ (alfas v) _ _
  rw [alfas_de_lista v a0 a1 a2 ha, ← hc]
  rw [oraculo_composicion, ht, ListaCampo.inicial]
  have hn : 2 ^ (v.datos.k + 3) = 2 * 2 ^ (v.datos.k + 2) := by
    rw [show v.datos.k + 3 = v.datos.k + 2 + 1 by omega, pow_succ, Nat.mul_comm]
  cases b with
  | false =>
    simp only [signoPareja, Bool.false_eq_true, ite_false]
    rw [funcion_en_indice _ 0 hk (by omega) t i (by simp only [Nat.sub_zero]; omega), hrest.1,
      composicion_base_inmersion]
    simp only [punto_inicial_inmersion, raizExtension, map_mul, map_pow]
    congr 1
    funext j
    fin_cases j <;> rfl
  | true =>
    simp only [signoPareja, ite_true]
    rw [← punto_capa_opuesto v.datos.k 0 i hk (by omega)]
    simp only [Nat.sub_zero]
    rw [funcion_en_indice _ 0 hk (by omega) t _ (by simp only [Nat.sub_zero]; omega), hrest.2.1,
      composicion_base_inmersion]
    rw [show puntoCapa v.datos.k 0 (i + 2 ^ (v.datos.k + 2)) = -puntoCapa v.datos.k 0 i from
      by simpa only [Nat.sub_zero] using punto_capa_opuesto v.datos.k 0 i hk (by omega)]
    simp only [punto_inicial_inmersion, raizExtension, map_neg, map_mul, map_pow]
    congr 1
    funext j
    fin_cases j <;> rfl

theorem consulta_buena (v : Vista) (hk0 : 4 ≤ v.datos.k) (hk : v.datos.k ≤ 29)
    (hv : FormaVista v) (i : Fin (2 ^ (v.datos.k + 2)))
    (ht : pruebaTraza v i.val) (hc : pruebaComposicion v i.val) :
    AceptaCompartida v.datos.k hk v.datos.inicio v.datos.salida (prefijo v) {puntoCapa v.datos.k 1 i.val} := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [oraculo_traza]
    exact ListaCampo.aceptacion _ _ hk (Nat.le_succ _) _ _ _ i.val i.isLt hv.1 (controles_traza v i.val ht)
  · rw [oraculo_composicion]
    exact ListaCampo.aceptacion _ _ hk (le_refl _) _ _ _ i.val i.isLt hv.2.1 (controles_composicion v i.val hc)
  · intro x hx j hj
    rw [pareja_indice_air v.datos.k hk i.val i.isLt] at hx
    rcases Finset.mem_insert.mp hx with hx | hx
    · rw [hx]
      exact base_air v hk hv i.val i.isLt ht.1 false ⟨j, hj⟩
    · rw [Finset.mem_singleton.mp hx]
      exact base_air v hk hv i.val i.isLt ht.1 true ⟨j, hj⟩
  · intro y hy
    rw [Finset.mem_singleton.mp hy]
    have hr := representante_en_punto v.datos.k 0 i.val hk (by omega)
      (by simpa only [show v.datos.k + 3 - (0 + 1) = v.datos.k + 2 by omega] using i.isLt)
    rw [hr]
    exact ⟨enlace_local v hk0 hk hv i.val i.isLt hc false, enlace_local v hk0 hk hv i.val i.isLt hc true⟩

end Nexus.Verificador.ConsultaCampo
