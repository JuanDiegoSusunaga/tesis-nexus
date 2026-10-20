module

public import Nexus.N06.PoliticasCompatibles
import Mathlib.Tactic

/-!
# La capa terminal FRI es la constante enviada

El modelo general anterior permitía un oráculo terminal adicional. Esta
normalización lo fija a la constante final. Conserva los mensajes de la
gramática y los monitores anteriores, y hereda las cotas demostradas.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

@[expose] def normalizarTerminal (k : ℕ) (p : PoliticaConsulta) : PoliticaConsulta where
  inicial := p.inicial
  traza := fun a j h => if j = k then fun _ => p.constanteTraza a h else p.traza a j h
  composicion := fun a ht j h =>
    if j = k + 1 then fun _ => p.constanteComposicion a ht h else p.composicion a ht j h
  constanteTraza := p.constanteTraza
  constanteComposicion := p.constanteComposicion

theorem capa_traza_normalizada_anterior (k n : ℕ) (p : PoliticaConsulta)
    (a : Retos Fp2 3) (bt : Retos Fp2 n) (i : ℕ) (hi : i < k) :
    capaTraza (normalizarTerminal k p) a bt i = capaTraza p a bt i := by
  simp only [capaTraza, estrategiaTraza, normalizarTerminal, show i ≠ k by omega, ite_false]

theorem capa_composicion_normalizada_anterior (k n : ℕ) (p : PoliticaConsulta)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 n) (i : ℕ) (hi : i < k + 1) :
    capaComposicion (normalizarTerminal k p) a bt bc i = capaComposicion p a bt bc i := by
  simp only [capaComposicion, normalizarTerminal, show i ≠ k + 1 by omega, ite_false]

theorem capa_traza_terminal_constante (k : ℕ) (hk : 0 < k) (p : PoliticaConsulta)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) :
    capaTraza (normalizarTerminal k p) a bt k = fun _ => p.constanteTraza a (listaRetos bt) := by
  simp only [capaTraza, estrategiaTraza, show k ≠ 0 by omega, ite_false,
    normalizarTerminal, ite_true, lista_retos_historia]

theorem capa_composicion_terminal_constante (k : ℕ) (p : PoliticaConsulta)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) :
    capaComposicion (normalizarTerminal k p) a bt bc (k + 1) =
      fun _ => p.constanteComposicion a (listaRetos bt) (listaRetos bc) := by
  simp only [capaComposicion, normalizarTerminal, ite_true, lista_retos_historia]

theorem inicio_composicion_normalizado (k : ℕ) (p : PoliticaConsulta)
    (a : Retos Fp2 3) (bt : Retos Fp2 k) :
    inicioComposicion (normalizarTerminal k p) a bt = inicioComposicion p a bt := by
  simp only [inicioComposicion, normalizarTerminal, Nat.zero_ne_add_one, ite_false]

theorem contenido_normalizado (k : ℕ) (p : PoliticaConsulta) (q : ℕ)
    {t u : TranscripcionCausal k q} (paso : PasoSinReto k q t u) :
    contenidoPaso (normalizarTerminal k p) paso = contenidoPaso p paso := by
  cases paso with
  | inicial => rfl
  | abrirTraza => rfl
  | capaTraza a j bt =>
    simp only [contenidoPaso, estrategiaTraza, normalizarTerminal, show j.val ≠ k by omega, ite_false]
  | cerrarTraza => simp only [contenidoPaso, normalizarTerminal, Nat.zero_ne_add_one, ite_false]
  | capaComposicion a bt j bc =>
    simp only [contenidoPaso, normalizarTerminal, show j.val ≠ k + 1 by omega, ite_false]
  | cerrarComposicion => rfl

theorem marca_normalizada_antes_consulta (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PoliticaConsulta) (a : Retos Fp2 3) (bt : Retos Fp2 k) (bc : Retos Fp2 (k + 1)) :
    marcaAntesConsulta k hk s o (normalizarTerminal k p) a bt bc =
      marcaAntesConsulta k hk s o p a bt bc := by
  exact marca_antes_consulta_congruente k hk s o (normalizarTerminal k p) p a bt bc rfl
    (fun i hi => capa_traza_normalizada_anterior k k p a bt i hi)
    (fun i hi => capa_composicion_normalizada_anterior k (k + 1) p a bt bc i hi)

theorem plan_terminal_perfiles (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) (s o : Fp)
    (p : PoliticaConsulta)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o)
    (B : ℕ) (plan : PlanCausal k 40 [.vacia] B) :
    probabilidadPlanCausal k (by omega) s o (normalizarTerminal k p) 40 B plan ≤
      min 1 (B * Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8)) :=
  plan_causal_perfiles k hk0 hk1 s o (normalizarTerminal k p) hfalso B plan

end Nexus.Goldilocks
