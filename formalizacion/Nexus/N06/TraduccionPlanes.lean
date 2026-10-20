module

public import Nexus.N06.PlanesExplicitos
import Mathlib.Tactic

/-!
# Transporte de planes completos y sus medias uniformes

Ambas traducciones mantienen el registro guardado y el mismo presupuesto.
Las peticiones corresponden respuesta por respuesta. La igualdad de valores
se prueba por inducción sobre todo el árbol, para cualquier función terminal.
Esto compara los dos modelos ideales internos, sin traducir bytes o Merkle.
-/

public section
namespace Nexus.Goldilocks

open Nexus.N06

@[expose] noncomputable def valorPlanObservado (k q : ℕ) (fin : List (PrefijoObservado k q) → ℚ) :
    {h : List (PrefijoObservado k q)} → {n : ℕ} → PlanObservado k q h n → ℚ
  | _, _, .terminar h _ => fin h
  | _, _, .mensaje _ _ _ _ _ resto => valorPlanObservado k q fin resto
  | _, _, .nuevo r _ resto => promedio (fun x : RespuestaObservada k q r => valorPlanObservado k q fin (resto x))

theorem valor_observado_cambio_registro (k q : ℕ) (fin : List (PrefijoObservado k q) → ℚ)
    {h g : List (PrefijoObservado k q)} {n : ℕ} (e : h = g) (plan : PlanObservado k q h n) :
    valorPlanObservado k q fin (e ▸ plan) = valorPlanObservado k q fin plan := by
  cases e
  rfl

theorem valor_explicito_cambio_registro (k q : ℕ) (fin : List (TranscripcionExplicita k q) → ℚ)
    {h g : List (TranscripcionExplicita k q)} {n : ℕ} (e : h = g) (plan : PlanExplicito k q h n) :
    valorPlanExplicito k q fin (e ▸ plan) = valorPlanExplicito k q fin plan := by
  cases e
  rfl

theorem valor_expansion_observada (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp) (q : ℕ)
    (fin : List (PrefijoObservado k q) → ℚ) {h : List (PrefijoObservado k q)} {n : ℕ}
    (plan : PlanObservado k q h n) :
    valorRestaurable (RespuestaObservada k q) (origenObservado k q) (destinoObservado k q)
      (estadoObservado k hk0 hk s o q) fin (expandirPlanObservado k hk0 hk s o q plan) =
      valorPlanObservado k q fin plan := by
  induction plan with
  | terminar => rfl
  | mensaje p t u ht paso resto ih => exact ih
  | nuevo r hr resto ih =>
    change promedio (fun x : RespuestaObservada k q r => _) = promedio (fun x : RespuestaObservada k q r => _)
    congr 1
    funext x
    exact ih x

theorem transportar_plan_explicito (k q : ℕ) (fin : List (PrefijoObservado k q) → ℚ)
    {h : List (TranscripcionExplicita k q)} {n : ℕ} (plan : PlanExplicito k q h n) :
    ∃ observado : PlanObservado k q (h.map (codificarExplicita k q)) n,
      valorPlanObservado k q fin observado =
        valorPlanExplicito k q (fun registro => fin (registro.map (codificarExplicita k q))) plan := by
  classical
  induction plan with
  | terminar h n => exact ⟨.terminar _ _, rfl⟩
  | @mensaje h n v hv w paso resto ih =>
    obtain ⟨observado, he⟩ := ih
    refine ⟨.mensaje (politicaDeDatos k q w.1 w.2) v.1 w.1 ?_ paso.paso observado, ?_⟩
    · rw [← codificar_origen_paso k q paso]
      exact List.mem_map_of_mem hv
    · simp only [valorPlanObservado, valorPlanExplicito]
      exact he
  | @nuevo h n r hr resto ih =>
    choose observado he using ih
    have e (x : RespuestaExplicita k q r) :
        (destinoExplicito k q r x :: h).map (codificarExplicita k q) =
          destinoObservado k q (peticionDeDatos k q r) x :: h.map (codificarExplicita k q) := by
      rw [List.map_cons, codificar_destino_explicito]
    refine ⟨.nuevo (peticionDeDatos k q r) ?_ (fun x => e x ▸ observado x), ?_⟩
    · rw [← codificar_origen_explicito]
      exact List.mem_map_of_mem hr
    · simp only [valorPlanObservado, valorPlanExplicito]
      apply promedio_entre_instancias
      intro x
      exact (valor_observado_cambio_registro k q fin (e x) (observado x)).trans (he x)

theorem decodificar_observacion (k q : ℕ) (p : PoliticaConsulta) (t : TranscripcionCausal k q) :
    decodificarObservado k q (observarPrefijo k q p t) = ⟨t, capturarMensajes k q p t⟩ := rfl

@[expose] def peticionCapturada (k q : ℕ) (r : PeticionObservada k) : PeticionExplicita k q :=
  ⟨r.ronda, capturarMensajes k q r.politica (origenCausal k q r.ronda)⟩

theorem decodificar_origen_observado (k q : ℕ) (r : PeticionObservada k) :
    decodificarObservado k q (origenObservado k q r) = origenExplicito k q (peticionCapturada k q r) := rfl

theorem decodificar_destino_observado (k q : ℕ) (r : PeticionObservada k) (x : RespuestaObservada k q r) :
    decodificarObservado k q (destinoObservado k q r x) = destinoExplicito k q (peticionCapturada k q r) x :=
  (captura_destino_desde_origen k q r.politica r.ronda x).symm

theorem transportar_plan_observado (k q : ℕ) (fin : List (TranscripcionExplicita k q) → ℚ)
    {h : List (PrefijoObservado k q)} {n : ℕ} (plan : PlanObservado k q h n) :
    ∃ explicito : PlanExplicito k q (h.map (decodificarObservado k q)) n,
      valorPlanExplicito k q fin explicito =
        valorPlanObservado k q (fun registro => fin (registro.map (decodificarObservado k q))) plan := by
  classical
  induction plan with
  | terminar h n => exact ⟨.terminar _ _, rfl⟩
  | @mensaje h n p t u ht paso resto ih =>
    obtain ⟨explicito, he⟩ := ih
    refine ⟨.mensaje ⟨t, capturarMensajes k q p t⟩ ?_ ⟨u, capturarMensajes k q p u⟩
      (capturarPasoExplicito k q p paso) explicito, ?_⟩
    · exact List.mem_map_of_mem ht
    · simp only [valorPlanExplicito, valorPlanObservado]
      exact he
  | @nuevo h n r hr resto ih =>
    choose explicito he using ih
    have e (x : RespuestaObservada k q r) :
        (destinoObservado k q r x :: h).map (decodificarObservado k q) =
          destinoExplicito k q (peticionCapturada k q r) x :: h.map (decodificarObservado k q) := by
      rw [List.map_cons, decodificar_destino_observado]
    refine ⟨.nuevo (peticionCapturada k q r) ?_ (fun x => e x ▸ explicito x), ?_⟩
    · rw [← decodificar_origen_observado]
      exact List.mem_map_of_mem hr
    · simp only [valorPlanExplicito, valorPlanObservado]
      apply promedio_entre_instancias
      intro x
      exact (valor_explicito_cambio_registro k q fin (e x) (explicito x)).trans (he x)

@[expose] noncomputable def aceptaRegistroObservado (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29)
    (s o : Fp) (q : ℕ) (h : List (PrefijoObservado k q)) : ℚ := by
  classical
  exact if ∃ v ∈ h, aceptaObservado k hk0 hk s o q v then 1 else 0

theorem acepta_registro_codificado (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (h : List (TranscripcionExplicita k q)) :
    aceptaRegistroObservado k hk0 hk s o q (h.map (codificarExplicita k q)) =
      aceptaRegistroExplicito k hk0 hk s o q h := by
  classical
  have hh : (∃ w ∈ h.map (codificarExplicita k q), aceptaObservado k hk0 hk s o q w) ↔
      ∃ v ∈ h, aceptaExplicita k hk0 hk s o q v := by
    constructor
    · rintro ⟨w, hw, ha⟩
      obtain ⟨v, hv, rfl⟩ := List.mem_map.mp hw
      exact ⟨v, hv, ha⟩
    · rintro ⟨v, hv, ha⟩
      exact ⟨codificarExplicita k q v, List.mem_map_of_mem hv, ha⟩
  simp only [aceptaRegistroObservado, aceptaRegistroExplicito, hh]

theorem acepta_registro_decodificado (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (h : List (PrefijoObservado k q)) :
    aceptaRegistroExplicito k hk0 hk s o q (h.map (decodificarObservado k q)) =
      aceptaRegistroObservado k hk0 hk s o q h := by
  classical
  have hh : (∃ v ∈ h.map (decodificarObservado k q), aceptaExplicita k hk0 hk s o q v) ↔
      ∃ w ∈ h, aceptaObservado k hk0 hk s o q w := by
    constructor
    · rintro ⟨v, hv, ha⟩
      obtain ⟨w, hw, rfl⟩ := List.mem_map.mp hv
      refine ⟨w, hw, ?_⟩
      simpa only [aceptaExplicita, codificar_decodificar] using ha
    · rintro ⟨w, hw, ha⟩
      refine ⟨decodificarObservado k q w, List.mem_map_of_mem hw, ?_⟩
      simpa only [aceptaExplicita, codificar_decodificar] using ha
  simp only [aceptaRegistroExplicito, aceptaRegistroObservado, hh]

theorem probabilidad_observada_valor (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q B : ℕ) (plan : PlanObservado k q [raizObservada k q] B) :
    probabilidadObservada k hk0 hk s o q B plan =
      valorPlanObservado k q (aceptaRegistroObservado k hk0 hk s o q) plan :=
  valor_expansion_observada k hk0 hk s o q _ plan

theorem plan_explicito_misma_probabilidad (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q B : ℕ) (plan : PlanExplicito k q [raizExplicita k q] B) :
    ∃ observado : PlanObservado k q [raizObservada k q] B,
      probabilidadObservada k hk0 hk s o q B observado = probabilidadExplicita k hk0 hk s o q plan := by
  obtain ⟨observado, he⟩ := transportar_plan_explicito k q (aceptaRegistroObservado k hk0 hk s o q) plan
  have er : [raizExplicita k q].map (codificarExplicita k q) = [raizObservada k q] := rfl
  have ef : (fun registro => aceptaRegistroObservado k hk0 hk s o q (registro.map (codificarExplicita k q))) =
      aceptaRegistroExplicito k hk0 hk s o q := by
    funext registro
    exact acepta_registro_codificado k hk0 hk s o q registro
  rw [ef] at he
  refine ⟨er ▸ observado, ?_⟩
  rw [probabilidad_observada_valor]
  exact (valor_observado_cambio_registro k q _ er observado).trans he

theorem plan_observado_misma_probabilidad (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q B : ℕ) (plan : PlanObservado k q [raizObservada k q] B) :
    ∃ explicito : PlanExplicito k q [raizExplicita k q] B,
      probabilidadExplicita k hk0 hk s o q explicito = probabilidadObservada k hk0 hk s o q B plan := by
  obtain ⟨explicito, he⟩ := transportar_plan_observado k q (aceptaRegistroExplicito k hk0 hk s o q) plan
  have er : [raizObservada k q].map (decodificarObservado k q) = [raizExplicita k q] := rfl
  have ef : (fun registro => aceptaRegistroExplicito k hk0 hk s o q (registro.map (decodificarObservado k q))) =
      aceptaRegistroObservado k hk0 hk s o q := by
    funext registro
    exact acepta_registro_decodificado k hk0 hk s o q registro
  rw [ef] at he
  refine ⟨er ▸ explicito, ?_⟩
  rw [probabilidad_observada_valor]
  exact (valor_explicito_cambio_registro k q _ er explicito).trans he

end Nexus.Goldilocks
