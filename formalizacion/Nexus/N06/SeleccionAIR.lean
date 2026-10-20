module

public import Nexus.N06.Candidato
public import Nexus.N06.Cancelacion
public import Nexus.N03.Alternativa
import Mathlib.Tactic

/-!
# Candidato previo a AIR y especialización de la ronda crítica

El candidato y la rama se eligen del oráculo de traza, sin recibir los
coeficientes. Para un enunciado falso, la rama base proporciona residuos
no todos nulos. Su ronda crítica se construye antes de sortear los retos.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

@[expose] noncomputable def candidatoPerfil (k : ℕ) (u : Fp2 → Fp2) (δ : ℚ) :
    Option (Polynomial Fp2) := candidato (cosetExtension (k + 3)) u (2 ^ k) δ

theorem candidato_perfil_ninguno (k : ℕ) (u : Fp2 → Fp2) (δ : ℚ) :
    candidatoPerfil k u δ = none ↔ ∀ f : Polynomial Fp2, f.natDegree < 2 ^ k →
      δ < Nexus.distancia (cosetExtension (k + 3)) u f.eval :=
  candidato_ninguno_iff _ u _ δ

/-- En el radio de unicidad, el candidato elegido es exactamente cualquier candidato próximo. -/
theorem candidato_perfil_iff (k : ℕ) (hk : k ≤ 29) (u : Fp2 → Fp2)
    (δ : ℚ) (hδ : δ ≤ 1 / 8) (f : Polynomial Fp2) :
    candidatoPerfil k u δ = some f ↔ Proximo (cosetExtension (k + 3)) u (2 ^ k) δ f := by
  constructor
  · exact candidato_propiedad _ u _ δ f
  · apply candidato_unico
    intro a b ha hb
    exact unicidad_perfil k hk u a b ha.1 hb.1 δ hδ ha.2 hb.2

inductive RamaTraza where
  | lejana
  | fueraBase
  | base
  deriving DecidableEq

@[expose] noncomputable def ramaTraza (k : ℕ) (u : Fp2 → Fp2) (δ : ℚ) : RamaTraza := by
  classical
  exact match candidatoPerfil k u δ with
    | none => .lejana
    | some f => if (∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) then .base else .fueraBase

/-- Los tres casos se determinan antes de AIR, incluido el caso sin candidato. -/
theorem rama_traza_especificacion (k : ℕ) (hk : k ≤ 29) (u : Fp2 → Fp2)
    (δ : ℚ) (hδ : δ ≤ 1 / 8) (s o : Fp)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o) :
    match ramaTraza k u δ with
    | .lejana => ∀ f : Polynomial Fp2, f.natDegree < 2 ^ k →
        δ < Nexus.distancia (cosetExtension (k + 3)) u f.eval
    | .fueraBase => ∃ f : Polynomial Fp2, candidatoPerfil k u δ = some f ∧
        Proximo (cosetExtension (k + 3)) u (2 ^ k) δ f ∧
        (¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) ∧
        (3 : ℚ) / 4 < fraccionFueraBase (cosetExtension (k + 3)) u
    | .base => ∃ f : Polynomial Fp2, candidatoPerfil k u δ = some f ∧
        Proximo (cosetExtension (k + 3)) u (2 ^ k) δ f ∧
        (∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) ∧
        ¬ Nexus.AIR.Valida (raizExtension k) (2 ^ k) f
          (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o) := by
  classical
  cases hc : candidatoPerfil k u δ with
  | none =>
    simpa only [ramaTraza, hc] using (candidato_perfil_ninguno k u δ).mp hc
  | some f =>
    have hp := (candidato_perfil_iff k hk u δ hδ f).mp hc
    by_cases hb : ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f
    · simp only [ramaTraza, hc, hb, ite_eq_left]
      exact ⟨f, rfl, hp, hb, invalidez_candidato_base k s o f hp.1 hb hfalso⟩
    · simp only [ramaTraza, hc, hb, reduceIte]
      exact ⟨f, rfl, hp, hb, fraccion_no_base_mayor_tres_cuartos k hk u f hp.1 hb δ hδ hp.2⟩

/-- Los residuos se fijan al elegir el candidato, sin argumentos para los retos. -/
@[expose] noncomputable def residuosPerfil (k : ℕ) (f : Polynomial Fp2) (s o : Fp2) :
    ℕ → Polynomial Fp2
  | 0 => Nexus.AIR.frontera (Nexus.AIR.denominador (2 ^ k)) f s 1 %
      Nexus.AIR.denominador (2 ^ k)
  | 1 => Nexus.AIR.frontera (Nexus.AIR.denominador (2 ^ k)) f o
      (raizExtension k ^ (2 ^ k - 1)) % Nexus.AIR.denominador (2 ^ k)
  | 2 => Nexus.AIR.numeradorTransicion (raizExtension k) f
      (raizExtension k ^ (2 ^ k - 1)) (raizExtension k ^ (2 ^ k - 2)) %
        Nexus.AIR.denominador (2 ^ k)
  | _ + 3 => 0

theorem residuos_perfil_no_nulos (k : ℕ) (hk0 : 2 ≤ k) (hk : k ≤ 32)
    (f : Polynomial Fp2) (s o : Fp2)
    (hf : ¬ Nexus.AIR.Valida (raizExtension k) (2 ^ k) f s o) :
    ∃ i < 3, residuosPerfil k f s o i ≠ 0 := by
  have hT : 3 ≤ 2 ^ k := by
    have h := Nat.pow_le_pow_right (by decide : 0 < 2) hk0
    norm_num at h
    omega
  rcases Nexus.AIR.invalida_residuo_no_nulo (2 ^ k) (raizExtension k) f s o
    hT (raiz_extension_primitiva k hk) hf with h0 | h1 | h2
  · exact ⟨0, by decide, h0⟩
  · exact ⟨1, by decide, h1⟩
  · exact ⟨2, by decide, h2⟩

/-- La suma de los tres retos es el resto del numerador combinado de AIR. -/
theorem suma_retos_residuo_combinado (k : ℕ) (f : Polynomial Fp2) (s o : Fp2)
    (a b c : Fp2) :
    sumaRetos (residuosPerfil k f s o) 0 3 (a, b, c, PUnit.unit) =
      Nexus.N01.combinacion
        (Nexus.AIR.frontera (Nexus.AIR.denominador (2 ^ k)) f s 1)
        (Nexus.AIR.frontera (Nexus.AIR.denominador (2 ^ k)) f o
          (raizExtension k ^ (2 ^ k - 1)))
        (Nexus.AIR.numeradorTransicion (raizExtension k) f
          (raizExtension k ^ (2 ^ k - 1)) (raizExtension k ^ (2 ^ k - 2)))
        (a, b, c) % Nexus.AIR.denominador (2 ^ k) := by
  rw [Nexus.AIR.resto_combinacion]
  simp only [sumaRetos, residuosPerfil, Nexus.N01.combinacion, add_zero, add_assoc]

theorem probabilidad_cancelacion_air_secuencial (k : ℕ) (hk0 : 2 ≤ k) (hk : k ≤ 32)
    (f : Polynomial Fp2) (s o : Fp2)
    (hf : ¬ Nexus.AIR.Valida (raizExtension k) (2 ^ k) f s o) :
    promedio (fun xs : Retos Fp2 3 => if sumaRetos (residuosPerfil k f s o) 0 3 xs = 0
      then (1 : ℚ) else 0) ≤ 1 / (p : ℚ) ^ 2 := by
  simpa only [cardinal_extension, Nat.cast_pow] using
    cota_critica_elegida (residuosPerfil k f s o) 3 (residuos_perfil_no_nulos k hk0 hk f s o hf)

/-- La rama base de un enunciado falso proporciona una ronda crítica previa a los coeficientes. -/
theorem candidato_base_ronda_critica (k : ℕ) (hk0 : 2 ≤ k) (hk : k ≤ 29)
    (u : Fp2 → Fp2) (δ : ℚ) (f : Polynomial Fp2)
    (hc : candidatoPerfil k u δ = some f)
    (hb : ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) (s o : Fp)
    (hfalso : ∀ A : Polynomial Fp, A.natDegree < 2 ^ k →
      ¬ Nexus.AIR.Valida (raiz k) (2 ^ k) A s o) :
    let R := residuosPerfil k f (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o)
    ∃ j < 3, R j ≠ 0 ∧ (∀ i, j < i → i < 3 → R i = 0) ∧
      (∀ estado : Polynomial Fp2,
        promedio (fun x => if x ∈ cancelantesRonda (R j) estado then (1 : ℚ) else 0) ≤
          1 / (p : ℚ) ^ 2) ∧ probabilidadAIR R j 3 ≤ 1 / (p : ℚ) ^ 2 := by
  let R := residuosPerfil k f (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o)
  have hp := candidato_propiedad _ u _ δ f hc
  have hinval := invalidez_candidato_base k s o f hp.1 hb hfalso
  have hn := residuos_perfil_no_nulos k hk0 (by omega) f _ _ hinval
  let j := rondaCritica R 3 hn
  have hj := ronda_critica_propiedades R 3 hn
  refine ⟨j, hj.1, hj.2.1, hj.2.2, ?_, ?_⟩
  · intro estado
    simpa only [cardinal_extension, Nat.cast_pow] using probabilidad_ronda_critica (R j) estado hj.2.1
  · simpa only [cardinal_extension, Nat.cast_pow] using cota_cancelacion_secuencial R j 3 hj.1 hj.2.1

end Nexus.Goldilocks
