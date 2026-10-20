module

public import Nexus.FRI.Recorrido
public import Nexus.Canal.EnlaceComposicion
import Mathlib.Tactic

/-!
# Las dos ejecuciones FRI y los controles AIR en la misma consulta

La familia construida aquí usa el registro final. Sirve para la implicación
de aceptación. Su identificación con familias fijadas antes de los retos,
necesaria para solidez adaptativa, requiere los cortes causales de ROM.
-/

public section
namespace Nexus.Canal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.Goldilocks.Recorrido Nexus.N06

@[expose] noncomputable def prefijoRecorridos (H : List Octeto → Digest)
    (registro : List (List Octeto)) (k : ℕ) (rt rc : ℕ → Digest) (bt bc : ℕ → Fp2)
    (ft fc : Fp2) (a : Nexus.N01.Coeficientes Fp2) : PrefijoConsulta where
  traza := fun j _ => oraculos H registro k k rt ft j
  composicion := fun j _ => oraculos H registro k (k + 1) rc fc j
  betaTraza := bt
  betaComposicion := bc
  constanteTraza := ft
  constanteComposicion := fc
  coeficientes := a

theorem ambas_ejecuciones_en_prefijo (H : List Octeto → Digest) (registro : List (List Octeto))
    (hc : SinColisiones H registro) (k : ℕ) (hk : k ≤ 29)
    (I : Finset ℕ) (hI : ∀ i ∈ I, i < 2 ^ (k + 2))
    (rt rc : ℕ → Digest) (bt bc : ℕ → Fp2) (dt dc : ℕ → ℕ → Apertura) (ft fc : Fp2)
    (a : Nexus.N01.Coeficientes Fp2)
    (het : ∀ i ∈ I, ∃ s, ejecutar H k i rt bt (dt i) k = some s ∧ s.acarreo = some ft)
    (hec : ∀ i ∈ I, ∃ s, ejecutar H k i rc bc (dc i) (k + 1) = some s ∧ s.acarreo = some fc)
    (hrt : ∀ i ∈ I, ∀ j < k, Registrada H registro k j (posicion k i (j + 1)) (dt i j))
    (hrc : ∀ i ∈ I, ∀ j < k + 1, Registrada H registro k j (posicion k i (j + 1)) (dc i j)) :
    let p := prefijoRecorridos H registro k rt rc bt bc ft fc a
    Nexus.FRI.Acepta (torreTraza k hk) (oraculoTraza p) (fun j => p.betaTraza j)
      (Nexus.FRI.elevar (representanteCapa k 0) (I.image (puntoCapa k 1))) p.constanteTraza ∧
    Nexus.FRI.Acepta (torreComposicion k hk) (oraculoComposicion p) (fun j => p.betaComposicion j)
      (Nexus.FRI.elevar (representanteCapa k 0) (I.image (puntoCapa k 1))) p.constanteComposicion :=
  ambas_aceptaciones H registro hc k hk I hI rt rc bt bc dt dc ft fc het hec hrt hrc

theorem aceptacion_compartida_de_recorridos {B : ℕ} {fin : Nexus.ROM.Estado B}
    {st sc rt0 rc0 dat drt dac drc : Digest} {tagT tagC : Octeto} {tipoT tipoC : TipoReto}
    (ct : CorteRaizReto fin st tagT rt0 tipoT dat drt) (cc : CorteRaizReto fin sc tagC rc0 tipoC dac drc)
    (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (defecto : Digest) (I : Finset ℕ)
    (hi : ∀ i ∈ I, i < 2 ^ (k + 2)) (d : ℕ → DatosAIR) (f : ℕ → DatosPareja)
    (s o : Fp) (a : Nexus.N01.Coeficientes Fp2)
    (rt rc : ℕ → Digest) (bt bc : ℕ → Fp2) (dt dc : ℕ → ℕ → Apertura) (ft fc : Fp2)
    (hrootT : rt 0 = rt0) (hrootC : rc 0 = rc0)
    (hcollision : SinColisiones (Nexus.ROM.funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst))
    (ht : ∀ i ∈ I, VerificaAIR (Nexus.ROM.funcionTabla defecto fin.tabla) rt0 k i (d i))
    (qt : ∀ i ∈ I, RegistradasAIR (Nexus.ROM.funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i (d i))
    (hc : ∀ i ∈ I, VerificaPareja (Nexus.ROM.funcionTabla defecto fin.tabla) rc0 k i (f i))
    (qc : ∀ i ∈ I, RegistradasPareja (Nexus.ROM.funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i (f i))
    (hl : ∀ i ∈ I, comprobarEnlaceComposicion k i s o a (d i) (f i) = true)
    (het : ∀ i ∈ I, ∃ t, ejecutar (Nexus.ROM.funcionTabla defecto fin.tabla) k i rt bt (dt i) k = some t ∧ t.acarreo = some ft)
    (hec : ∀ i ∈ I, ∃ t, ejecutar (Nexus.ROM.funcionTabla defecto fin.tabla) k i rc bc (dc i) (k + 1) = some t ∧ t.acarreo = some fc)
    (hrt : ∀ i ∈ I, ∀ j < k, Registrada (Nexus.ROM.funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k j (posicion k i (j + 1)) (dt i j))
    (hrc : ∀ i ∈ I, ∀ j < k + 1, Registrada (Nexus.ROM.funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k j (posicion k i (j + 1)) (dc i j)) :
    let p := prefijoRecorridos (Nexus.ROM.funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k rt rc bt bc ft fc a
    AceptaCompartida k hk s o p (I.image (puntoCapa k 1)) := by
  let p := prefijoRecorridos (Nexus.ROM.funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k rt rc bt bc ft fc a
  have hft := ambas_ejecuciones_en_prefijo (Nexus.ROM.funcionTabla defecto fin.tabla)
    (fin.tabla.map Prod.fst) hcollision k hk I hi rt rc bt bc dt dc ft fc a het hec hrt hrc
  have hu : oraculoTraza p 0 = oraculoEnEstado k 0 defecto ct.segunda.antes rt0 := by
    rw [oraculo_antes_reto_estable ct k 0 defecto]
    funext x
    simp only [oraculoTraza, p, prefijoRecorridos, oraculos, show 0 < k by omega,
      ite_true, hrootT, oraculoEnEstado]
  have hv : oraculoComposicion p 0 = oraculoEnEstado k 0 defecto cc.segunda.antes rc0 := by
    rw [oraculo_antes_reto_estable cc k 0 defecto]
    funext x
    simp only [oraculoComposicion, p, prefijoRecorridos, oraculos, Nat.zero_lt_succ,
      ite_true, hrootC, oraculoEnEstado]
  exact aceptacion_compartida_de_aperturas ct cc k hk0 hk defecto I hi d f s o p hu hv ht qt hc qc hl hft.1 hft.2

/-- El evento aceptado puede incluir todos los controles del verificador.
Solo se exige su implicación hacia el control base, sin una hipótesis global de oráculo base. -/
theorem cota_candidato_no_base_autenticado (k : ℕ) (hk : k ≤ 29) (u : Fp2 → Fp2)
    (delta : ℚ) (f : Polynomial Fp2) (hf : candidatoPerfil k u delta = some f)
    (hno : ¬ ∃ g : Polynomial Fp, g.map (algebraMap Fp Fp2) = f) (q : ℕ)
    (Verificador : Finset Fp2 → Prop)
    (hb : ∀ S, Verificador S → ∀ x ∈ Nexus.FRI.elevar (representanteCapa k 0) S, EsBase (u x)) :
    probabilidadConsulta (dominioCapa k 1) q Verificador ≤ Nexus.N05.H (4 * 2 ^ k) q
      (1 - (2 ^ k - 1 : ℕ) / (8 * (2 ^ k : ℕ) : ℚ) - delta) := by
  apply (consulta_monotona _ q Verificador
    (ConsultaParejas (representanteCapa k 0) (fun x => EsBase (u x))) ?_).trans
      (consulta_candidato_no_base k hk u delta f hf hno q)
  intro S _ hS
  exact (consulta_parejas_iff _ _ S).mpr (hb S hS)

theorem cota_compartida_candidato_no_base (k : ℕ) (hk : k ≤ 29) (s o : Fp)
    (p : PrefijoConsulta) (delta : ℚ) (f : Polynomial Fp2)
    (hf : candidatoPerfil k (oraculoTraza p 0) delta = some f)
    (hno : ¬ ∃ g : Polynomial Fp, g.map (algebraMap Fp Fp2) = f) (q : ℕ) :
    probabilidadConsulta (dominioCapa k 1) q (AceptaCompartida k hk s o p) ≤
      Nexus.N05.H (4 * 2 ^ k) q (1 - (2 ^ k - 1 : ℕ) / (8 * (2 ^ k : ℕ) : ℚ) - delta) := by
  apply cota_candidato_no_base_autenticado k hk (oraculoTraza p 0) delta f hf hno q _
  intro S ha x hx
  simpa only [pow_zero, one_mul] using ha.2.2.1 x hx 0 (by norm_num)

end Nexus.Canal
