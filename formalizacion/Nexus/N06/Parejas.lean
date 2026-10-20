module

public import Nexus.N06.Consulta
public import Nexus.N06.Composicion
public import Nexus.FRI.Goldilocks
import Mathlib.Tactic

/-!
# Controles locales sobre las parejas concretas de Goldilocks

La consulta enumera las parejas por el dominio cuadrado D₁ y abre r(y),-r(y).
Se aplican las fracciones ya demostradas a los predicados efectivos de campo
base y enlace, sin suponer de entrada un número de parejas malas.
-/

public section
namespace Nexus.Goldilocks

open Polynomial Nexus.N06

theorem fraccion_fallos_base (D : Finset Fp2) (u : Fp2 → Fp2) :
    fraccionFallos D (fun x => EsBase (u x)) = fraccionFueraBase D u := by
  classical
  simp only [fraccionFallos, fraccionFueraBase, puntosFueraBase]

theorem fraccion_fallos_enlace (D : Finset Fp2) (u v : Fp2 → Fp2) :
    fraccionFallos D (fun x => u x = v x) = Nexus.distancia D u v := by
  classical
  rfl

theorem consulta_predicado_goldilocks (k : ℕ) (hk : k ≤ 29) (P : Fp2 → Prop)
    (q : ℕ) (θ : ℚ) (hd : θ ≤ fraccionFallos (cosetExtension (k + 3)) P) :
    probabilidadConsulta (dominioCapa k 1) q (ConsultaParejas (representanteCapa k 0) P) ≤
      Nexus.N05.H (4 * 2 ^ k) q θ := by
  classical
  let t := torreGoldilocks k 1 hk (by omega)
  have hdom : t.dominio 0 = cosetExtension (k + 3) := dominio_capa_inicial k
  have hD : (t.dominio 1).card = 4 * 2 ^ k := parejas_iniciales_torre k 1 hk (by omega)
  have hDc : (dominioCapa k 1).card = 4 * 2 ^ k := hD
  have hd' : θ ≤ fraccionFallos (Nexus.FRI.elevar (t.raiz 0) (t.dominio 1)) P := by
    rw [← t.enlace 0 (by decide), hdom]
    exact hd
  have hbound := muestreo_predicado (t.dominio 1) (t.raiz 0) P q θ
    (Nexus.FRI.dominios_positivos t dos_extension_no_cero 1 (by decide))
    (t.cuadrado 0 (by decide)) (t.noCero 0 (by decide)) dos_extension_no_cero hd'
  simpa only [t, torreGoldilocks, hDc] using hbound

theorem consulta_candidato_no_base (k : ℕ) (hk : k ≤ 29) (u : Fp2 → Fp2)
    (δt : ℚ) (f : Polynomial Fp2) (hc : candidatoPerfil k u δt = some f)
    (hno : ¬ ∃ A : Polynomial Fp, A.map (algebraMap Fp Fp2) = f) (q : ℕ) :
    probabilidadConsulta (dominioCapa k 1) q
      (ConsultaParejas (representanteCapa k 0) (fun x => EsBase (u x))) ≤
        Nexus.N05.H (4 * 2 ^ k) q
          (1 - (2 ^ k - 1 : ℕ) / (8 * (2 ^ k : ℕ) : ℚ) - δt) := by
  apply consulta_predicado_goldilocks k hk _ q _
  rw [fraccion_fallos_base]
  have hp := candidato_propiedad _ u _ δt f hc
  exact fraccion_no_base_perfil k hk u f hp.1 hno δt hp.2

theorem consulta_candidato_enlace (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29)
    (u v : Fp2 → Fp2) (δt δc : ℚ) (f h : Polynomial Fp2)
    (hc : candidatoPerfil k u δt = some f)
    (hv : candidato (cosetExtension (k + 3)) v (2 * 2 ^ k) δc = some h)
    (s o : Fp2) (a : Nexus.N01.Coeficientes Fp2)
    (hr : Nexus.AIR.numeradorCombinado (2 ^ k) (raizExtension k) f s o a %
      Nexus.AIR.denominador (2 ^ k) ≠ 0) (q : ℕ) :
    probabilidadConsulta (dominioCapa k 1) q
      (ConsultaParejas (representanteCapa k 0) (fun x => v x =
        Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) s o a u x)) ≤
      Nexus.N05.H (4 * 2 ^ k) q
        ((5 * (2 ^ k : ℕ) + 1 : ℚ) / (8 * (2 ^ k : ℕ) : ℚ) - 3 * δt - δc) := by
  apply consulta_predicado_goldilocks k hk _ q _
  rw [fraccion_fallos_enlace]
  exact (le_max_right 0 _).trans
    (candidato_composicion_enlace k hk0 hk u v δt δc f h hc hv s o a hr)

end Nexus.Goldilocks
