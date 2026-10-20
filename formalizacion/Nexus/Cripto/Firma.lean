module

public import Nexus.Cripto.Oraculo
import Mathlib.Tactic

public section
namespace Nexus.Cripto

open scoped ENNReal

/-- Algoritmos probabilísticos de generación y firma, con verificación determinista. -/
structure Esquema (Publica Privada Mensaje Firma : Type*) where
  keyGen : PMF (Publica × Privada)
  sign : Privada → Mensaje → PMF Firma
  verify : Publica → Mensaje → Firma → Bool

variable {PK SK M S : Type*}

@[expose] noncomputable def ensayoFirma (e : Esquema PK SK M S) (m : M) : PMF (PK × S) :=
  e.keyGen.bind (fun keys => (e.sign keys.2 m).map (fun s => (keys.1, s)))

@[expose] def CorreccionPerfecta (e : Esquema PK SK M S) : Prop :=
  ∀ keys ∈ e.keyGen.support, ∀ m s, s ∈ (e.sign keys.2 m).support → e.verify keys.1 m s = true

@[expose] noncomputable def Correccion (e : Esquema PK SK M S) (epsilon : ℝ≥0∞) : Prop :=
  ∀ m, 1 - epsilon ≤ probabilidad (ensayoFirma e m) (fun ps => e.verify ps.1 m ps.2 = true)

theorem firma_correcta_en_soporte (e : Esquema PK SK M S) (he : CorreccionPerfecta e)
    (m : M) (ps : PK × S) (hp : ps ∈ (ensayoFirma e m).support) : e.verify ps.1 m ps.2 = true := by
  rw [ensayoFirma, PMF.mem_support_bind_iff] at hp
  obtain ⟨keys, hk, hs⟩ := hp
  obtain ⟨s, hsig, hps⟩ := (PMF.mem_support_map_iff _ _ _).mp hs
  subst ps
  exact he keys hk m s hsig

theorem correccion_probabilidad_uno (e : Esquema PK SK M S) (he : CorreccionPerfecta e) (m : M) :
    probabilidad (ensayoFirma e m) (fun ps => e.verify ps.1 m ps.2 = true) = 1 :=
  probabilidad_uno_por_soporte _ _ (firma_correcta_en_soporte e he m)

theorem correccion_cero (e : Esquema PK SK M S) (he : CorreccionPerfecta e) : Correccion e 0 := by
  intro m
  rw [correccion_probabilidad_uno e he m, tsub_zero]

theorem correccion_mayor_error (e : Esquema PK SK M S) (a b : ℝ≥0∞)
    (hab : a ≤ b) (he : Correccion e a) : Correccion e b := by
  intro m
  exact (tsub_le_tsub_left hab 1).trans (he m)

abbrev ResultadoCMA (PK M S : Type*) := PK × ((M × S) × Registro M S)

/-- El adversario recibe pk; sk solo se utiliza al interpretar el oráculo de firma. -/
@[expose] noncomputable def ensayoCMA (e : Esquema PK SK M S) (Q : ℕ)
    (adversario : PK → PMF (Programa M S (M × S) Q)) : PMF (ResultadoCMA PK M S) :=
  e.keyGen.bind (fun keys => (adversario keys.1).bind (fun p =>
    (ejecutar (e.sign keys.2) p []).map (fun out => (keys.1, out))))

@[expose] def GanaEUF (e : Esquema PK SK M S) (out : ResultadoCMA PK M S) : Prop :=
  e.verify out.1 out.2.1.1 out.2.1.2 = true ∧ out.2.1.1 ∉ out.2.2.map Prod.fst

@[expose] def GanaSUF (e : Esquema PK SK M S) (out : ResultadoCMA PK M S) : Prop :=
  e.verify out.1 out.2.1.1 out.2.1.2 = true ∧ out.2.1 ∉ out.2.2

@[expose] noncomputable def ventajaEUF (e : Esquema PK SK M S) (Q : ℕ)
    (adversario : PK → PMF (Programa M S (M × S) Q)) : ℝ≥0∞ :=
  probabilidad (ensayoCMA e Q adversario) (GanaEUF e)

@[expose] noncomputable def ventajaSUF (e : Esquema PK SK M S) (Q : ℕ)
    (adversario : PK → PMF (Programa M S (M × S) Q)) : ℝ≥0∞ :=
  probabilidad (ensayoCMA e Q adversario) (GanaSUF e)

theorem victoria_euf_implica_suf (e : Esquema PK SK M S) (out : ResultadoCMA PK M S)
    (he : GanaEUF e out) : GanaSUF e out := by
  refine ⟨he.1, ?_⟩
  intro hp
  exact he.2 (List.mem_map_of_mem (f := Prod.fst) hp)

theorem ventaja_euf_le_suf (e : Esquema PK SK M S) (Q : ℕ)
    (adversario : PK → PMF (Programa M S (M × S) Q)) :
    ventajaEUF e Q adversario ≤ ventajaSUF e Q adversario :=
  probabilidad_monotona _ _ _ (victoria_euf_implica_suf e)

theorem ventajas_cma_acotadas (e : Esquema PK SK M S) (Q : ℕ)
    (adversario : PK → PMF (Programa M S (M × S) Q)) :
    ventajaEUF e Q adversario ≤ 1 ∧ ventajaSUF e Q adversario ≤ 1 :=
  ⟨probabilidad_le_uno _ _, probabilidad_le_uno _ _⟩

theorem consultas_cma_acotadas (e : Esquema PK SK M S) (Q : ℕ)
    (adversario : PK → PMF (Programa M S (M × S) Q)) (out : ResultadoCMA PK M S)
    (ho : out ∈ (ensayoCMA e Q adversario).support) : out.2.2.length ≤ Q := by
  rw [ensayoCMA, PMF.mem_support_bind_iff] at ho
  obtain ⟨keys, _, hp⟩ := ho
  obtain ⟨p, _, hout⟩ := (PMF.mem_support_bind_iff _ _ _).mp hp
  obtain ⟨res, hres, rfl⟩ := (PMF.mem_support_map_iff _ _ _).mp hout
  exact consultas_acotadas _ p res hres

theorem registro_cma_valido (e : Esquema PK SK M S) (he : CorreccionPerfecta e) (Q : ℕ)
    (adversario : PK → PMF (Programa M S (M × S) Q)) (out : ResultadoCMA PK M S)
    (ho : out ∈ (ensayoCMA e Q adversario).support) :
    ∀ ms ∈ out.2.2, e.verify out.1 ms.1 ms.2 = true := by
  rw [ensayoCMA, PMF.mem_support_bind_iff] at ho
  obtain ⟨keys, hk, hp⟩ := ho
  obtain ⟨p, _, hout⟩ := (PMF.mem_support_bind_iff _ _ _).mp hp
  obtain ⟨res, hres, rfl⟩ := (PMF.mem_support_map_iff _ _ _).mp hout
  apply registro_respeta_soporte (e.sign keys.2) (fun m s => e.verify keys.1 m s = true) _ p [] _ res hres
  · exact he keys hk
  · simp

@[expose] def FirmasUnicas (e : Esquema PK SK M S) (pk : PK) : Prop :=
  ∀ m s t, e.verify pk m s = true → e.verify pk m t = true → s = t

theorem victoria_suf_implica_euf_con_unicidad (e : Esquema PK SK M S)
    (out : ResultadoCMA PK M S) (hu : FirmasUnicas e out.1)
    (hh : ∀ ms ∈ out.2.2, e.verify out.1 ms.1 ms.2 = true)
    (hs : GanaSUF e out) : GanaEUF e out := by
  refine ⟨hs.1, ?_⟩
  intro hm
  obtain ⟨⟨m, s⟩, hmem, hmeq⟩ := List.mem_map.mp hm
  change m = out.2.1.1 at hmeq
  subst m
  have heq := hu out.2.1.1 out.2.1.2 s hs.1 (hh _ hmem)
  apply hs.2
  rw [show out.2.1 = (out.2.1.1, s) from Prod.ext rfl heq]
  exact hmem

theorem ventajas_iguales_con_unicidad (e : Esquema PK SK M S) (he : CorreccionPerfecta e)
    (hu : ∀ pk, FirmasUnicas e pk) (Q : ℕ)
    (adversario : PK → PMF (Programa M S (M × S) Q)) :
    ventajaEUF e Q adversario = ventajaSUF e Q adversario := by
  apply probabilidad_congruente_soporte
  intro out ho
  exact ⟨victoria_euf_implica_suf e out,
    victoria_suf_implica_euf_con_unicidad e out (hu out.1) (registro_cma_valido e he Q adversario out ho)⟩

end Nexus.Cripto
