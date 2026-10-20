module

public import Nexus.Canal.AperturasAIR
public import Nexus.N06.Compartida
import Mathlib.Tactic

/-!
# De los valores abiertos a los controles locales de N06

La fórmula de compose se transporta desde Fp a Fp2 y se identifica con
composicionLocal usando las tres aperturas y la ausencia de polos. Las
aperturas de composición y las comparaciones locales vinculan su oráculo.
La aceptación FRI completa sigue siendo una premisa separada: este módulo
no formaliza todavía su bucle de acarreo ni toda la ejecución de Rust.
-/

public section
namespace Nexus.Canal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.N06

@[expose] noncomputable def componerValores (T : ℕ) (g s o x : Fp2)
    (a : Nexus.N01.Coeficientes Fp2) (v : Fin 3 → Fp2) : Fp2 :=
  a.1 * ((v 0 - s) / (x - 1)) +
    a.2.1 * ((v 0 - o) / (x - g ^ (T - 1))) +
    a.2.2 * ((v 2 - v 1 ^ 2 - v 0 ^ 2) * (x - g ^ (T - 1)) * (x - g ^ (T - 2)) / (x ^ T - 1))

@[expose] noncomputable def componerBase (T : ℕ) (g s o x : Fp)
    (a : Nexus.N01.Coeficientes Fp2) (v : Fin 3 → Fp) : Fp2 :=
  a.1 * algebraMap Fp Fp2 ((v 0 - s) / (x - 1)) +
    a.2.1 * algebraMap Fp Fp2 ((v 0 - o) / (x - g ^ (T - 1))) +
    a.2.2 * algebraMap Fp Fp2
      ((v 2 - v 1 ^ 2 - v 0 ^ 2) * (x - g ^ (T - 1)) * (x - g ^ (T - 2)) / (x ^ T - 1))

@[expose] noncomputable def comprobarEnlaceComposicion (k i : ℕ) (s o : Fp)
    (a : Nexus.N01.Coeficientes Fp2) (d : DatosAIR) (f : DatosPareja) : Bool :=
  decide (∀ b : Bool, (f b).valor =
    componerValores (2 ^ k) (raizExtension k) (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o)
      (signoPareja b (puntoCapa k 0 i)) a (fun j => algebraMap Fp Fp2 (d b j).valor))

theorem composicion_base_inmersion (T : ℕ) (g s o x : Fp)
    (a : Nexus.N01.Coeficientes Fp2) (v : Fin 3 → Fp) :
    componerBase T g s o x a v = componerValores T (algebraMap Fp Fp2 g)
      (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o) (algebraMap Fp Fp2 x) a
      (fun j => algebraMap Fp Fp2 (v j)) := by
  simp only [componerBase, componerValores, map_div₀, map_sub, map_one, map_pow, map_mul]

theorem composicion_valores_coincide (T : ℕ) (g s o x : Fp2)
    (a : Nexus.N01.Coeficientes Fp2) (u : Fp2 → Fp2) (v : Fin 3 → Fp2)
    (hv : ∀ j : Fin 3, u (g ^ j.val * x) = v j) (hg : IsPrimitiveRoot g T)
    (hD : (Nexus.AIR.denominador T : Polynomial Fp2).eval x ≠ 0) :
    componerValores T g s o x a v = Nexus.AIR.composicionLocal T g s o a u x := by
  have h0 : u x = v 0 := by simpa only [Fin.val_zero, pow_zero, one_mul] using hv 0
  have h1 : u (g * x) = v 1 := by simpa only [Fin.val_one, pow_one] using hv 1
  have h2 : u (g ^ 2 * x) = v 2 := hv 2
  rw [Nexus.AIR.formula_composicion_local T g s o a u x hg hD]
  simp only [componerValores, h0, h1, h2]

theorem composicion_de_aperturas_air {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto)
    (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (defecto : Digest) (i : ℕ) (d : DatosAIR)
    (ha : VerificaAIR (funcionTabla defecto fin.tabla) raiz k i d)
    (hq : RegistradasAIR (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i d)
    (s o : Fp) (a : Nexus.N01.Coeficientes Fp2) (b : Bool) :
    componerValores (2 ^ k) (raizExtension k) (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o)
        (signoPareja b (puntoCapa k 0 i)) a (fun j => algebraMap Fp Fp2 (d b j).valor) =
      Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o)
        a (oraculoEnEstado k 0 defecto c.segunda.antes raiz) (signoPareja b (puntoCapa k 0 i)) := by
  have hx : signoPareja b (puntoCapa k 0 i) ∈ dominioCapa k 0 := by
    refine Finset.mem_image.mpr ⟨indiceAIR k i b 0, Finset.mem_range.mpr (indice_air_cota k i b 0), ?_⟩
    simpa only [pow_zero, one_mul] using punto_indice_air k hk i 0 b
  rw [dominio_capa_inicial] at hx
  exact composicion_valores_coincide _ _ _ _ _ a _ _
    (valores_air_congelados c k hk defecto i d ha hq b) (raiz_extension_primitiva k (by omega))
    (denominador_extension_no_nulo k hk0 hk _ hx)

theorem enlace_composicion_oraculos {B : ℕ} {fin : Estado B}
    {st sc rt rc dat drt dac drc : Digest} {tagT tagC : Octeto} {tipoT tipoC : TipoReto}
    (ct : CorteRaizReto fin st tagT rt tipoT dat drt) (cc : CorteRaizReto fin sc tagC rc tipoC dac drc)
    (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (defecto : Digest) (i : ℕ)
    (d : DatosAIR) (f : DatosPareja) (s o : Fp) (a : Nexus.N01.Coeficientes Fp2)
    (ht : VerificaAIR (funcionTabla defecto fin.tabla) rt k i d)
    (qt : RegistradasAIR (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i d)
    (hc : VerificaPareja (funcionTabla defecto fin.tabla) rc k i f)
    (qc : RegistradasPareja (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i f)
    (he : comprobarEnlaceComposicion k i s o a d f = true) (b : Bool) :
    oraculoEnEstado k 0 defecto cc.segunda.antes rc (signoPareja b (puntoCapa k 0 i)) =
      Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o)
        a (oraculoEnEstado k 0 defecto ct.segunda.antes rt) (signoPareja b (puntoCapa k 0 i)) := by
  have hcomp : ∀ b : Bool, (f b).valor =
      componerValores (2 ^ k) (raizExtension k) (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o)
        (signoPareja b (puntoCapa k 0 i)) a (fun j => algebraMap Fp Fp2 (d b j).valor) := by
    simpa only [comprobarEnlaceComposicion, decide_eq_true_eq] using he
  exact (valores_pareja_congelados cc k hk defecto i f hc qc b).trans
    ((hcomp b).trans (composicion_de_aperturas_air ct k hk0 hk defecto i d ht qt s o a b))

theorem consulta_enlace_muestra {B : ℕ} {fin : Estado B}
    {st sc rt rc dat drt dac drc : Digest} {tagT tagC : Octeto} {tipoT tipoC : TipoReto}
    (ct : CorteRaizReto fin st tagT rt tipoT dat drt) (cc : CorteRaizReto fin sc tagC rc tipoC dac drc)
    (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (defecto : Digest) (I : Finset ℕ)
    (hi : ∀ i ∈ I, i < 2 ^ (k + 2)) (d : ℕ → DatosAIR) (f : ℕ → DatosPareja)
    (s o : Fp) (a : Nexus.N01.Coeficientes Fp2)
    (ht : ∀ i ∈ I, VerificaAIR (funcionTabla defecto fin.tabla) rt k i (d i))
    (qt : ∀ i ∈ I, RegistradasAIR (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i (d i))
    (hc : ∀ i ∈ I, VerificaPareja (funcionTabla defecto fin.tabla) rc k i (f i))
    (qc : ∀ i ∈ I, RegistradasPareja (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i (f i))
    (he : ∀ i ∈ I, comprobarEnlaceComposicion k i s o a (d i) (f i) = true) :
    ConsultaParejas (representanteCapa k 0) (fun x =>
      oraculoEnEstado k 0 defecto cc.segunda.antes rc x =
        Nexus.AIR.composicionLocal (2 ^ k) (raizExtension k) (algebraMap Fp Fp2 s) (algebraMap Fp Fp2 o)
          a (oraculoEnEstado k 0 defecto ct.segunda.antes rt) x) (I.image (puntoCapa k 1)) := by
  intro y hy
  obtain ⟨i, hiI, rfl⟩ := Finset.mem_image.mp hy
  have hr : representanteCapa k 0 (puntoCapa k 1 i) = puntoCapa k 0 i := by
    simpa only [show k + 3 - (0 + 1) = k + 2 by omega] using
      representante_en_punto k 0 i hk (by omega) (hi i hiI)
  rw [hr]
  constructor
  · simpa only [signoPareja, Bool.false_eq_true, ite_false] using
      enlace_composicion_oraculos ct cc k hk0 hk defecto i (d i) (f i) s o a
        (ht i hiI) (qt i hiI) (hc i hiI) (qc i hiI) (he i hiI) false
  · simpa only [signoPareja, ite_true] using
      enlace_composicion_oraculos ct cc k hk0 hk defecto i (d i) (f i) s o a
        (ht i hiI) (qt i hiI) (hc i hiI) (qc i hiI) (he i hiI) true

theorem aceptacion_compartida_de_aperturas {B : ℕ} {fin : Estado B}
    {st sc rt rc dat drt dac drc : Digest} {tagT tagC : Octeto} {tipoT tipoC : TipoReto}
    (ct : CorteRaizReto fin st tagT rt tipoT dat drt) (cc : CorteRaizReto fin sc tagC rc tipoC dac drc)
    (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (defecto : Digest) (I : Finset ℕ)
    (hi : ∀ i ∈ I, i < 2 ^ (k + 2)) (d : ℕ → DatosAIR) (f : ℕ → DatosPareja)
    (s o : Fp) (h : PrefijoConsulta)
    (hu : oraculoTraza h 0 = oraculoEnEstado k 0 defecto ct.segunda.antes rt)
    (hv : oraculoComposicion h 0 = oraculoEnEstado k 0 defecto cc.segunda.antes rc)
    (ht : ∀ i ∈ I, VerificaAIR (funcionTabla defecto fin.tabla) rt k i (d i))
    (qt : ∀ i ∈ I, RegistradasAIR (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i (d i))
    (hc : ∀ i ∈ I, VerificaPareja (funcionTabla defecto fin.tabla) rc k i (f i))
    (qc : ∀ i ∈ I, RegistradasPareja (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i (f i))
    (he : ∀ i ∈ I, comprobarEnlaceComposicion k i s o h.coeficientes (d i) (f i) = true)
    (hft : Nexus.FRI.Acepta (torreTraza k hk) (oraculoTraza h) (fun j => h.betaTraza j)
      (Nexus.FRI.elevar (representanteCapa k 0) (I.image (puntoCapa k 1))) h.constanteTraza)
    (hfc : Nexus.FRI.Acepta (torreComposicion k hk) (oraculoComposicion h) (fun j => h.betaComposicion j)
      (Nexus.FRI.elevar (representanteCapa k 0) (I.image (puntoCapa k 1))) h.constanteComposicion) :
    AceptaCompartida k hk s o h (I.image (puntoCapa k 1)) := by
  have hb := control_base_muestra_air ct k hk defecto I hi d ht qt
  have hl := consulta_enlace_muestra ct cc k hk0 hk defecto I hi d f s o h.coeficientes ht qt hc qc he
  rw [← hu] at hb
  rw [← hu, ← hv] at hl
  exact ⟨hft, hfc, hb, hl⟩

end Nexus.Canal
