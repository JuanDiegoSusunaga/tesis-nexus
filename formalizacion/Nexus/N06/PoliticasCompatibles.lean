module

public import Nexus.N06.CongruenciaPrefijos
public import Nexus.N06.SolidezCausal
import Mathlib.Tactic

/-!
# Estado invariante entre políticas que coinciden en el prefijo

Se comparan únicamente los oráculos sobre la historia recorrida. Para la
salida del modelo anterior también se exige su oráculo terminal explícito;
la normalización por constantes se construye en un módulo posterior.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

@[expose] def capaTraza {n : ℕ} (p : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 n) (i : ℕ) : Fp2 → Fp2 :=
  estrategiaTraza p a i (Nexus.FRI.historia (reto bt) i)

@[expose] def inicioComposicion {k : ℕ} (p : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 k) : Fp2 → Fp2 :=
  p.composicion a (Nexus.FRI.historia (reto bt) k) 0 []

@[expose] def capaComposicion {k n : ℕ} (p : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 k) (bc : Retos Fp2 n) (i : ℕ) : Fp2 → Fp2 :=
  p.composicion a (Nexus.FRI.historia (reto bt) k) i (Nexus.FRI.historia (reto bc) i)

theorem residuos_inicial_congruente (k : ℕ) (s o : Fp) (p r : PoliticaConsulta)
    (hi : p.inicial = r.inicial) : residuosVigilados k s o p = residuosVigilados k s o r := by
  simp only [residuosVigilados, hi]

theorem monitor_traza_congruente (k : ℕ) (hk : k ≤ 29) (p r : PoliticaConsulta)
    (a : Retos Fp2 3) (i : ℕ) (h : List Fp2) (hi : p.inicial = r.inicial)
    (hw : estrategiaTraza p a i h = estrategiaTraza r a i h) :
    monitorTraza k hk p a i h = monitorTraza k hk r a i h := by
  classical
  have hg : vigilaTraza k p = vigilaTraza k r := congrArg (fun w => candidatoPerfil k w (1 / 8) = none) hi
  by_cases hv : vigilaTraza k r
  · have hp : vigilaTraza k p := hg.mpr hv
    simp only [monitorTraza, hp, hv, ite_true, torreTraza]
    by_cases hit : i < k <;> simp only [Nexus.FRI.excepcionesHistoria, hit, reduceDIte, hw]
  · have hp : ¬ vigilaTraza k p := fun h => hv (hg.mp h)
    simp only [monitorTraza, hp, hv, ite_false]

theorem monitor_composicion_congruente (k : ℕ) (hk : k ≤ 29) (p r : PoliticaConsulta)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) (i : ℕ) (h : List Fp2)
    (hi : p.inicial = r.inicial) (h0 : inicioComposicion p a bt = inicioComposicion r a bt)
    (hw : p.composicion a (Nexus.FRI.historia (reto bt) k) i h =
      r.composicion a (Nexus.FRI.historia (reto bt) k) i h) :
    monitorComposicion k hk p a bt i h = monitorComposicion k hk r a bt i h := by
  classical
  have h0' := h0
  unfold inicioComposicion at h0'
  have hg : vigilaComposicion k p a bt = vigilaComposicion k r a bt := by
    unfold vigilaComposicion
    rw [hi, h0']
  by_cases hv : vigilaComposicion k r a bt
  · have hp : vigilaComposicion k p a bt := hg.mpr hv
    simp only [monitorComposicion, hp, hv, ite_true, torreComposicion]
    by_cases hic : i < k + 1 <;> simp only [Nexus.FRI.excepcionesHistoria, hic, reduceDIte, hw]
  · have hp : ¬ vigilaComposicion k p a bt := fun h => hv (hg.mp h)
    simp only [monitorComposicion, hp, hv, ite_false]

theorem marca_air_congruente (k : ℕ) (s o : Fp) (p r : PoliticaConsulta)
    (a : Retos Fp2 3) (hi : p.inicial = r.inicial) :
    marcaAIR k s o p a = marcaAIR k s o r a := by
  simp only [marcaAIR, residuos_inicial_congruente k s o p r hi]

theorem marca_traza_prefijo_congruente (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p r : PoliticaConsulta) (a : Retos Fp2 3) (n : ℕ) (bt : Retos Fp2 n)
    (hi : p.inicial = r.inicial) (ht : ∀ i < n, capaTraza p a bt i = capaTraza r a bt i) :
    recorrerMarca (monitorTraza k hk p a) (fun _ h x => h ++ [x])
      0 n [] (marcaAIR k s o p a) bt =
    recorrerMarca (monitorTraza k hk r a) (fun _ h x => h ++ [x])
      0 n [] (marcaAIR k s o r a) bt := by
  rw [marca_air_congruente k s o p r a hi]
  apply marca_historia_congruente
  intro i hit
  simpa only [Nat.zero_add, List.nil_append] using
    monitor_traza_congruente k hk p r a i (Nexus.FRI.historia (reto bt) i) hi (ht i hit)

theorem marca_traza_congruente (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p r : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k)
    (hi : p.inicial = r.inicial) (ht : ∀ i < k, capaTraza p a bt i = capaTraza r a bt i) :
    marcaTraza k hk s o p a bt = marcaTraza k hk s o r a bt :=
  marca_traza_prefijo_congruente k hk s o p r a k bt hi ht

theorem marca_composicion_prefijo_congruente (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p r : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (n : ℕ) (bc : Retos Fp2 n)
    (hi : p.inicial = r.inicial) (ht : ∀ i < k, capaTraza p a bt i = capaTraza r a bt i)
    (h0 : inicioComposicion p a bt = inicioComposicion r a bt)
    (hc : ∀ i < n, capaComposicion p a bt bc i = capaComposicion r a bt bc i) :
    recorrerMarca (monitorComposicion k hk p a bt) (fun _ h x => h ++ [x])
      0 n [] (marcaTraza k hk s o p a bt) bc =
    recorrerMarca (monitorComposicion k hk r a bt) (fun _ h x => h ++ [x])
      0 n [] (marcaTraza k hk s o r a bt) bc := by
  rw [marca_traza_congruente k hk s o p r a bt hi ht]
  apply marca_historia_congruente
  intro i hic
  simpa only [Nat.zero_add, List.nil_append] using monitor_composicion_congruente
    k hk p r a bt i (Nexus.FRI.historia (reto bc) i) hi h0 (hc i hic)

theorem marca_antes_consulta_congruente (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p r : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (hi : p.inicial = r.inicial) (ht : ∀ i < k, capaTraza p a bt i = capaTraza r a bt i)
    (hc : ∀ i < k + 1, capaComposicion p a bt bc i = capaComposicion r a bt bc i) :
    marcaAntesConsulta k hk s o p a bt bc = marcaAntesConsulta k hk s o r a bt bc := by
  exact marca_composicion_prefijo_congruente k hk s o p r a bt (k + 1) bc hi ht (hc 0 (by omega)) hc

structure AcuerdoFinal (k : ℕ) (p r : PoliticaConsulta) (a : Retos Fp2 3)
    (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) : Prop where
  inicial : p.inicial = r.inicial
  traza : ∀ i ≤ k, capaTraza p a bt i = capaTraza r a bt i
  composicion : ∀ i ≤ k + 1, capaComposicion p a bt bc i = capaComposicion r a bt bc i
  constanteTraza : p.constanteTraza a (listaRetos bt) = r.constanteTraza a (listaRetos bt)
  constanteComposicion : p.constanteComposicion a (listaRetos bt) (listaRetos bc) =
    r.constanteComposicion a (listaRetos bt) (listaRetos bc)

theorem aceptacion_compartida_congruente (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p r : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1))
    (h : AcuerdoFinal k p r a bt bc) (S : Finset Fp2) :
    AceptaCompartida k hk s o (ejecutarPrefijo k p a bt bc) S ↔
      AceptaCompartida k hk s o (ejecutarPrefijo k r a bt bc) S := by
  have ht := Nexus.FRI.acepta_oraculos_congruentes (torreTraza k hk)
    (capaTraza p a bt) (capaTraza r a bt) (fun j => reto bt j)
    (Nexus.FRI.elevar (representanteCapa k 0) S)
    (p.constanteTraza a (Nexus.FRI.historia (reto bt) k)) h.traza
  have hc := Nexus.FRI.acepta_oraculos_congruentes (torreComposicion k hk)
    (capaComposicion p a bt bc) (capaComposicion r a bt bc) (fun j => reto bc j)
    (Nexus.FRI.elevar (representanteCapa k 0) S)
    (p.constanteComposicion a (Nexus.FRI.historia (reto bt) k)
      (Nexus.FRI.historia (reto bc) (k + 1))) h.composicion
  have hct := h.constanteTraza
  have hcc := h.constanteComposicion
  simp only [lista_retos_historia] at hct hcc
  have hu0 := h.traza 0 (by omega)
  have hv0 := h.composicion 0 (by omega)
  have htp : oraculoTraza (ejecutarPrefijo k p a bt bc) = capaTraza p a bt := rfl
  have htr : oraculoTraza (ejecutarPrefijo k r a bt bc) = capaTraza r a bt := rfl
  have hcp : oraculoComposicion (ejecutarPrefijo k p a bt bc) = capaComposicion p a bt bc := rfl
  have hcr : oraculoComposicion (ejecutarPrefijo k r a bt bc) = capaComposicion r a bt bc := rfl
  unfold AceptaCompartida
  rw [htp, htr, hcp, hcr]
  simp only [ejecutarPrefijo]
  rw [ht, hc, hct, hcc, hu0, hv0]

/-- Coincidencia en los datos que pueden afectar a la marca de cada fase. -/
@[expose] def CompatibleCausal (k q : ℕ) (p r : PoliticaConsulta) : TranscripcionCausal k q → Prop
  | .vacia => True
  | .air _ _ => p.inicial = r.inicial
  | .traza a j bt _ => p.inicial = r.inicial ∧
      ∀ i < j.val, capaTraza p a bt i = capaTraza r a bt i
  | .composicion a bt j bc _ => p.inicial = r.inicial ∧
      (∀ i < k, capaTraza p a bt i = capaTraza r a bt i) ∧
      inicioComposicion p a bt = inicioComposicion r a bt ∧
      ∀ i < j.val, capaComposicion p a bt bc i = capaComposicion r a bt bc i
  | .consulta a bt bc => p.inicial = r.inicial ∧
      (∀ i < k, capaTraza p a bt i = capaTraza r a bt i) ∧
      ∀ i < k + 1, capaComposicion p a bt bc i = capaComposicion r a bt bc i
  | .salida a bt bc _ => AcuerdoFinal k p r a bt bc

theorem estado_causal_congruente (k : ℕ) (hk : k ≤ 29) (s o : Fp) (p r : PoliticaConsulta)
    (q : ℕ) (t : TranscripcionCausal k q) (h : CompatibleCausal k q p r t) :
    estadoCausal k hk s o p q t = estadoCausal k hk s o r q t := by
  classical
  cases t with
  | vacia => rfl
  | air j a =>
    simp only [CompatibleCausal] at h
    simp only [estadoCausal, nodoCausal, marcaNodo, residuos_inicial_congruente k s o p r h]
  | traza a j bt listo =>
    exact congrArg (fun b => decide (EnunciadoValido k s o) || b)
      (marca_traza_prefijo_congruente k hk s o p r a j bt h.1 h.2)
  | composicion a bt j bc listo =>
    exact congrArg (fun b => decide (EnunciadoValido k s o) || b)
      (marca_composicion_prefijo_congruente k hk s o p r a bt j bc h.1 h.2.1 h.2.2.1 h.2.2.2)
  | consulta a bt bc =>
    exact congrArg (fun b => decide (EnunciadoValido k s o) || b)
      (marca_antes_consulta_congruente k hk s o p r a bt bc h.1 h.2.1 h.2.2)
  | salida a bt bc S =>
    have hm := marca_antes_consulta_congruente k hk s o p r a bt bc h.inicial
      (fun i hi => h.traza i (by omega)) (fun i hi => h.composicion i (by omega))
    have ha := aceptacion_compartida_congruente k hk s o p r a bt bc h S.val
    simp only [estadoCausal, nodoCausal, marcaNodo, marcaFinal, actualizarMarca, hm]
    rw [propext ha]

end Nexus.Goldilocks
