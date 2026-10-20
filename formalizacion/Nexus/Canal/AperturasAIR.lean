module

public import Nexus.Canal.RaizCompartida
public import Nexus.FRI.PosicionesAIR
public import Nexus.N03.CampoBase
import Mathlib.Tactic

/-!
# Aperturas AIR de TG2 con hojas Fp2 y control base local

Cada dato AIR es un valor Fp, pero su apertura autentica la inyección en
Fp2 usando el formato de diecisiete bytes. Se vinculan las seis posiciones
al oráculo compartido y se obtiene el control base de la muestra N06.
No se supone que los valores no abiertos del oráculo pertenezcan a Fp.
-/

public section
namespace Nexus.Canal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.N06

structure PuntoAutenticado (V : Type*) where
  valor : V
  hermanos : List Digest

abbrev DatosAIR := Bool → Fin 3 → PuntoAutenticado Fp
abbrev DatosPareja := Bool → PuntoAutenticado Fp2

@[expose] def VerificaAIR (H : Entrada → Digest) (raiz : Digest) (k i : ℕ) (d : DatosAIR) : Prop :=
  ∀ b j, VerificaIndice formatoBytes H raiz (k + 3) (indiceAIR k i b j.val)
    (algebraMap Fp Fp2 (d b j).valor) (d b j).hermanos

@[expose] def RegistradasAIR (H : Entrada → Digest) (registro : List Entrada)
    (k i : ℕ) (d : DatosAIR) : Prop :=
  ∀ b j, AperturaRegistrada formatoBytes H registro (algebraMap Fp Fp2 (d b j).valor)
    (hermanosDesdeRaiz (indiceAIR k i b j.val) (d b j).hermanos)

@[expose] def VerificaPareja (H : Entrada → Digest) (raiz : Digest) (k i : ℕ) (d : DatosPareja) : Prop :=
  ∀ b, VerificaIndice formatoBytes H raiz (k + 3) (indiceAIR k i b 0) (d b).valor (d b).hermanos

@[expose] def RegistradasPareja (H : Entrada → Digest) (registro : List Entrada)
    (k i : ℕ) (d : DatosPareja) : Prop :=
  ∀ b, AperturaRegistrada formatoBytes H registro (d b).valor
    (hermanosDesdeRaiz (indiceAIR k i b 0) (d b).hermanos)

@[expose] def comprobarEnlaceTraza (a : DatosAIR) (f : DatosPareja) : Bool :=
  decide ((f false).valor = algebraMap Fp Fp2 (a false 0).valor ∧
    (f true).valor = algebraMap Fp Fp2 (a true 0).valor)

theorem valores_air_congelados {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto) (k : ℕ) (hk : k ≤ 29)
    (defecto : Digest) (i : ℕ) (d : DatosAIR)
    (ha : VerificaAIR (funcionTabla defecto fin.tabla) raiz k i d)
    (hq : RegistradasAIR (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i d)
    (b : Bool) (j : Fin 3) :
    oraculoEnEstado k 0 defecto c.segunda.antes raiz
      (raizExtension k ^ j.val * signoPareja b (puntoCapa k 0 i)) = algebraMap Fp Fp2 (d b j).valor := by
  have h := apertura_indexada_antes_reto c k 0 hk (by omega) defecto (indiceAIR k i b j.val)
    (indice_air_cota k i b j.val) (algebraMap Fp Fp2 (d b j).valor) (d b j).hermanos (ha b j) (hq b j)
  simpa only [punto_indice_air k hk i j.val b] using h

theorem control_base_pareja_air {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto) (k : ℕ) (hk : k ≤ 29)
    (defecto : Digest) (i : ℕ) (hi : i < 2 ^ (k + 2)) (d : DatosAIR)
    (ha : VerificaAIR (funcionTabla defecto fin.tabla) raiz k i d)
    (hq : RegistradasAIR (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i d) :
    ∀ x ∈ Nexus.FRI.elevar (representanteCapa k 0) {puntoCapa k 1 i}, ∀ j < 3,
      EsBase (oraculoEnEstado k 0 defecto c.segunda.antes raiz (raizExtension k ^ j * x)) := by
  intro x hx j hj
  have hb (b : Bool) : EsBase (oraculoEnEstado k 0 defecto c.segunda.antes raiz
      (raizExtension k ^ j * signoPareja b (puntoCapa k 0 i))) :=
    ⟨(d b ⟨j, hj⟩).valor, (valores_air_congelados c k hk defecto i d ha hq b ⟨j, hj⟩).symm⟩
  rw [pareja_indice_air k hk i hi] at hx
  rcases Finset.mem_insert.mp hx with he | he
  · subst x
    simpa only [signoPareja, Bool.false_eq_true, ite_false] using hb false
  · have heq := Finset.mem_singleton.mp he
    subst x
    simpa only [signoPareja, ite_true] using hb true

theorem control_base_muestra_air {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto) (k : ℕ) (hk : k ≤ 29)
    (defecto : Digest) (I : Finset ℕ) (hi : ∀ i ∈ I, i < 2 ^ (k + 2)) (d : ℕ → DatosAIR)
    (ha : ∀ i ∈ I, VerificaAIR (funcionTabla defecto fin.tabla) raiz k i (d i))
    (hq : ∀ i ∈ I, RegistradasAIR (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i (d i)) :
    ∀ x ∈ Nexus.FRI.elevar (representanteCapa k 0) (I.image (puntoCapa k 1)), ∀ j < 3,
      EsBase (oraculoEnEstado k 0 defecto c.segunda.antes raiz (raizExtension k ^ j * x)) := by
  intro x hx j hj
  have hex : ∃ i ∈ I, x ∈ Nexus.FRI.elevar (representanteCapa k 0) {puntoCapa k 1 i} := by
    rcases (pertenencia_elevar _ _ x).mp hx with ⟨y, hy, he⟩ | ⟨y, hy, he⟩
    · obtain ⟨i, hiI, rfl⟩ := Finset.mem_image.mp hy
      exact ⟨i, hiI, (pertenencia_elevar _ _ x).mpr (Or.inl ⟨_, Finset.mem_singleton_self _, he⟩)⟩
    · obtain ⟨i, hiI, rfl⟩ := Finset.mem_image.mp hy
      exact ⟨i, hiI, (pertenencia_elevar _ _ x).mpr (Or.inr ⟨_, Finset.mem_singleton_self _, he⟩)⟩
  obtain ⟨i, hiI, hxi⟩ := hex
  exact control_base_pareja_air c k hk defecto i (hi i hiI) (d i) (ha i hiI) (hq i hiI) x hxi j hj

theorem valores_pareja_congelados {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto) (k : ℕ) (hk : k ≤ 29)
    (defecto : Digest) (i : ℕ) (d : DatosPareja)
    (ha : VerificaPareja (funcionTabla defecto fin.tabla) raiz k i d)
    (hq : RegistradasPareja (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i d) (b : Bool) :
    oraculoEnEstado k 0 defecto c.segunda.antes raiz (signoPareja b (puntoCapa k 0 i)) = (d b).valor := by
  have h := apertura_indexada_antes_reto c k 0 hk (by omega) defecto (indiceAIR k i b 0)
    (indice_air_cota k i b 0) (d b).valor (d b).hermanos (ha b) (hq b)
  simpa only [punto_indice_air k hk i 0 b, pow_zero, one_mul] using h

theorem enlace_traza_de_aperturas {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto) (k : ℕ) (hk : k ≤ 29)
    (defecto : Digest) (i : ℕ) (a : DatosAIR) (f : DatosPareja)
    (ha : VerificaAIR (funcionTabla defecto fin.tabla) raiz k i a)
    (qa : RegistradasAIR (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i a)
    (hf : VerificaPareja (funcionTabla defecto fin.tabla) raiz k i f)
    (qf : RegistradasPareja (funcionTabla defecto fin.tabla) (fin.tabla.map Prod.fst) k i f) :
    comprobarEnlaceTraza a f = true := by
  have h (b : Bool) : (f b).valor = algebraMap Fp Fp2 (a b 0).valor := by
    have hv := valores_air_congelados c k hk defecto i a ha qa b 0
    simp only [Fin.val_zero, pow_zero, one_mul] at hv
    exact (valores_pareja_congelados c k hk defecto i f hf qf b).symm.trans hv
  exact decide_eq_true_eq.mpr ⟨h false, h true⟩

end Nexus.Canal
