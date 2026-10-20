module

public import Nexus.Verificador.ConsultaBuena
public import Nexus.Canal.MuestraEfectiva
public import Nexus.ROM.SelectorAcoplado
import Mathlib.Tactic

/-!
# Las cuarenta consultas efectivas pertenecen a GT y GC

La muestra se fija como función del selector ejecutado, incluidos duplicados
intermedios. La aceptación produce su soporte y la pertenencia a los conjuntos
anteriores al primer I, aun con propuesta adaptativa e intercalaciones.
-/

public section
namespace Nexus.Verificador.MuestraBuena

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open ProgramaCompartido RegistroPrograma CandidatoPrevio SemanticaPrevia
open VistaSemantica ConjuntosPrevios

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem tamano_indices (k : ℕ) : 4 * 2 ^ k = 2 ^ (k + 2) := by rw [pow_add]; norm_num; ring

@[expose] def lista (H : Entrada → Digest) (k bits R : ℕ) (c : Certificado) : List (Fin (4 * 2 ^ k)) :=
  MuestraEfectiva.recoger H (4 * 2 ^ k) (by positivity) R (semillaCert H k bits c) []

@[expose] def muestra (H : Entrada → Digest) (k bits R : ℕ) (c : Certificado) : List (Fin (2 ^ (k + 2))) :=
  (lista H k bits R c).map (Fin.cast (tamano_indices k))

theorem testigo_efectivo (H : Entrada → Digest) (k bits R : ℕ) (c : Certificado)
    (ha : resultado (tabla H) (Completo.verificar k bits R c) = true) :
    ∃ t : SoporteCompleto.Testigo H k bits R c, t.muestra = lista H k bits R c := by
  have hf := (Completo.aceptacion_verificador H k bits R c ha).1
  rw [Completo.verificar, ite_eq_left hf, RegistroCompleto.resultado_canal] at ha
  dsimp only at ha
  split_ifs at ha with hw
  have hm := MuestraEfectiva.aceptacion_lista H (4 * 2 ^ k) (by positivity) R
    (semillaCert H k bits c) [] (by simp)
    (fun S => SoporteCompleto.ultimas H k bits c S) ha
  refine ⟨⟨hf, lista H k bits R c, hm.1, hm.2.1, hm.2.2.1, ?_⟩, rfl⟩
  intro e he
  rw [Completo.verificar, ite_eq_left hf, RegistroCompleto.registro_canal]
  dsimp only
  simp only [hw, ite_true]
  exact List.mem_append_right _ (List.mem_cons_of_mem _ (List.mem_cons_of_mem _ (hm.2.2.2 e he)))

theorem consulta_de_muestra (H : Entrada → Digest) (k : ℕ) (e : Enunciado) (pr : Prueba)
    (alfas bt bc : List Fp2) (qs : List Consulta) (is : List ℕ)
    (ha : resultado (tabla H) (Completo.consultas k e pr alfas bt bc qs is) = true)
    (i : ℕ) (hi : i ∈ is) :
    ∃ q, resultado (tabla H) (ProgramaConsulta.verificar k i e pr alfas bt bc q) = true ∧
      ∀ x ∈ entradas H (ProgramaConsulta.verificar k i e pr alfas bt bc q),
        x ∈ entradas H (Completo.consultas k e pr alfas bt bc qs is) := by
  induction qs generalizing is with
  | nil =>
    cases is with
    | nil => contradiction
    | cons j js => simp only [Completo.consultas, resultado, Bool.false_eq_true] at ha
  | cons q qs ih =>
    cases is with
    | nil => contradiction
    | cons j js =>
      obtain ⟨hq, hr⟩ := aceptacion_ambos _ _ _ ha
      rcases List.mem_cons.mp hi with rfl | hi
      · exact ⟨q, hq, fun x hx => (primero_registrado H _ _).subset hx⟩
      · obtain ⟨d, hd, hlog⟩ := ih js hr hi
        exact ⟨d, hd, fun x hx => segundo_registrado H _ _ hq x (hlog x hx)⟩

theorem cuarenta_indices (H : Entrada → Digest) (k bits R : ℕ) (c : Certificado)
    (ha : resultado (tabla H) (Completo.verificar k bits R c) = true) :
    (muestra H k bits R c).Nodup ∧ (muestra H k bits R c).length = 40 := by
  obtain ⟨t, ht⟩ := testigo_efectivo H k bits R c ha
  have hs : (lista H k bits R c).Nodup := ht ▸ t.sinDuplicados
  have hc : Function.Injective (Fin.cast (tamano_indices k)) := by
    intro a b h
    exact Fin.ext (congrArg (fun x : Fin (2 ^ (k + 2)) => x.val) h)
  exact ⟨hs.map hc, by simpa only [muestra, List.length_map, ← ht] using t.cantidad⟩

theorem conjunto_efectivo (H : Entrada → Digest) (k bits R : ℕ) (c : Certificado)
    (ha : resultado (tabla H) (Completo.verificar k bits R c) = true) :
    (lista H k bits R c).toFinset = Selector.seleccionar 40 ∅
      (CintaSelector.indices H (4 * 2 ^ k) (by positivity) R (semillaCert H k bits c)) := by
  obtain ⟨t, ht⟩ := testigo_efectivo H k bits R c ha
  exact MuestraEfectiva.conjunto_desde_cinta H (4 * 2 ^ k) (by positivity) R _ [] (by simp) (by simp)
    (ht ▸ t.cantidad)

theorem muestra_igual_salida (H : Entrada → Digest) (k bits R : ℕ) (c : Certificado)
    (ha : resultado (tabla H) (Completo.verificar k bits R c) = true) :
    (muestra H k bits R c).toFinset = ROM.SelectorAcoplado.salida (k + 2) 40
      (CintaSelector.cinta H R (semillaCert H k bits c)) := by
  have hm : (muestra H k bits R c).toFinset =
      (lista H k bits R c).toFinset.image (Fin.cast (tamano_indices k)) := by
    ext i
    simp only [muestra, List.mem_toFinset, List.mem_map, Finset.mem_image]
  rw [hm, conjunto_efectivo H k bits R c ha]
  exact MuestraEfectiva.transportar_selector (4 * 2 ^ k) (2 ^ (k + 2)) (by positivity) (by positivity)
    (tamano_indices k) (CintaSelector.cinta H R (semillaCert H k bits c))

theorem aceptacion_en_conjuntos {A : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (k bits R : ℕ) (c : Certificado)
    (ha : resultado (tabla H) (Completo.verificar k bits R c) = true)
    (hlog : ∀ e ∈ entradas H (Completo.verificar k bits R c), e ∈ ProgramaBytes.entradas H p)
    (defecto : Digest) :
    ∃ r : Registro H B p k bits c,
      (muestra H k bits R c).Nodup ∧ (muestra H k bits R c).length = 40 ∧
      (muestra H k bits R c).toFinset ⊆ GT (k + 2) defecto (semillaCert H k bits c) r.corte.antes.tabla ∩
        GC (k + 2) defecto (semillaCert H k bits c) r.corte.antes.tabla := by
  obtain ⟨r⟩ := CandidatoPrevio.construir H B p hs k bits R c ha hlog
  obtain ⟨t, ht⟩ := testigo_efectivo H k bits R c ha
  have hcuarenta := cuarenta_indices H k bits R c ha
  refine ⟨r, hcuarenta.1, hcuarenta.2, ?_⟩
  intro j hj
  obtain ⟨i, hi, rfl⟩ := List.mem_map.mp (List.mem_toFinset.mp hj)
  have hit : i ∈ t.muestra := by rwa [ht]
  have hii : i.val < 2 ^ (k + 2) := by simpa only [tamano_indices k] using i.isLt
  obtain ⟨q, hq, hsub⟩ := consulta_de_muestra H k c.enunciado c.prueba
    (SoporteCompleto.vista H k bits c).alfas.2
    ((SoporteCompleto.vista H k bits c).traza.2.map (RegistroRaices.beta H))
    ((SoporteCompleto.vista H k bits c).composicion.2.map (RegistroRaices.beta H))
    c.prueba.consultas (t.muestra.map Fin.val) t.aceptacion i.val (List.mem_map.mpr ⟨i, hit, rfl⟩)
  have hglobal (x : Entrada) (hx : x ∈ entradas H (ProgramaConsulta.verificar k i.val c.enunciado c.prueba
      (SoporteCompleto.vista H k bits c).alfas.2
      ((SoporteCompleto.vista H k bits c).traza.2.map (RegistroRaices.beta H))
      ((SoporteCompleto.vista H k bits c).composicion.2.map (RegistroRaices.beta H)) q)) :
      x ∈ ProgramaBytes.entradas H p := hlog x (t.soporte x (hsub x hx))
  have hv := ValoresConsulta.aperturas_extraidas H B p hs defecto k i.val hii c.enunciado c.prueba _ _ _ q hq hglobal
  have hb := ConsultaBuena.consulta_en_vista H (EjecucionBytes.final H (inicial B) p).tabla defecto k bits c
    t.forma (VistaPrevia.disponible_final r) i.val hii q hq hv
  have hsets := conjuntos_antes r t.forma (k + 2) defecto
  rw [hsets.1, hsets.2]
  exact Finset.mem_inter.mpr ⟨(pertenencia_buenos _ _ _ _).mpr ⟨rfl, hb.1⟩,
    (pertenencia_buenos _ _ _ _).mpr ⟨rfl, hb.2⟩⟩

theorem desde_adversario {A : Type} (H : Entrada → Digest) (B bits R : ℕ)
    (proponer : ProgramaBytes.Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → ProgramaBytes.Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (hs : EjecucionBytes.SinBad H (inicial B) (Adversario.ejecutar bits R proponer atacar actualizar))
    (ha : ProgramaBytes.resultado H (Adversario.ejecutar bits R proponer atacar actualizar) = true)
    (defecto : Digest) :
    ∃ c, ∃ r : Registro H B (Adversario.ejecutar bits R proponer atacar actualizar)
        (Nat.log2 c.enunciado.pasos) bits c,
      Lectura.exacto codecCertificado.leer (ProgramaBytes.resultado H proponer).1 = some c ∧
      (muestra H (Nat.log2 c.enunciado.pasos) bits R c).Nodup ∧
      (muestra H (Nat.log2 c.enunciado.pasos) bits R c).length = 40 ∧
      (muestra H (Nat.log2 c.enunciado.pasos) bits R c).toFinset ⊆
        GT (Nat.log2 c.enunciado.pasos + 2) defecto (semillaCert H (Nat.log2 c.enunciado.pasos) bits c) r.corte.antes.tabla ∩
        GC (Nat.log2 c.enunciado.pasos + 2) defecto (semillaCert H (Nat.log2 c.enunciado.pasos) bits c) r.corte.antes.tabla := by
  rw [Adversario.resultado_con_bytes] at ha
  cases hp : Lectura.exacto codecCertificado.leer (ProgramaBytes.resultado H proponer).1 with
  | none => rw [Completo.desdeBytes, hp] at ha; contradiction
  | some c =>
    rw [Completo.desdeBytes, hp] at ha
    obtain ⟨r, hn, hl, hb⟩ := aceptacion_en_conjuntos H B _ hs (Nat.log2 c.enunciado.pasos) bits R c ha
      (fun e he => (Adversario.registro_verificador H bits R proponer atacar actualizar).subset
        (by simpa only [Completo.desdeBytes, hp] using he)) defecto
    exact ⟨c, r, rfl, hn, hl, hb⟩

theorem omision_efectiva {A : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa A)
    (hs : EjecucionBytes.SinBad H (inicial B) p) (k bits R : ℕ) (c : Certificado)
    (ha : resultado (tabla H) (Completo.verificar k bits R c) = true)
    (hlog : ∀ e ∈ entradas H (Completo.verificar k bits R c), e ∈ ProgramaBytes.entradas H p)
    (defecto : Digest) :
    ∃ r : Registro H B p k bits c,
      let T := ROM.SelectorAcoplado.salida (k + 2) 40 (CintaSelector.cinta H R (semillaCert H k bits c))
      T.card = 40 ∧ T ⊆ GT (k + 2) defecto (semillaCert H k bits c) r.corte.antes.tabla ∩
        GC (k + 2) defecto (semillaCert H k bits c) r.corte.antes.tabla := by
  obtain ⟨r, hn, hl, hb⟩ := aceptacion_en_conjuntos H B p hs k bits R c ha hlog defecto
  refine ⟨r, ?_⟩
  dsimp only
  rw [← muestra_igual_salida H k bits R c ha]
  exact ⟨by rw [List.toFinset_card_of_nodup hn, hl], hb⟩

theorem cobertura_selector_adversario {A : Type} (H : Entrada → Digest) (B bits R : ℕ)
    (proponer : ProgramaBytes.Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → ProgramaBytes.Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (hs : EjecucionBytes.SinBad H (inicial B) (Adversario.ejecutar bits R proponer atacar actualizar))
    (ha : ProgramaBytes.resultado H (Adversario.ejecutar bits R proponer atacar actualizar) = true)
    (defecto : Digest) :
    ∃ c, ∃ r : Registro H B (Adversario.ejecutar bits R proponer atacar actualizar)
        (Nat.log2 c.enunciado.pasos) bits c,
      Lectura.exacto codecCertificado.leer (ProgramaBytes.resultado H proponer).1 = some c ∧
      let T := ROM.SelectorAcoplado.salida (Nat.log2 c.enunciado.pasos + 2) 40
        (CintaSelector.cinta H R (semillaCert H (Nat.log2 c.enunciado.pasos) bits c))
      T.card = 40 ∧ T ⊆ GT (Nat.log2 c.enunciado.pasos + 2) defecto
        (semillaCert H (Nat.log2 c.enunciado.pasos) bits c) r.corte.antes.tabla ∩
        GC (Nat.log2 c.enunciado.pasos + 2) defecto
          (semillaCert H (Nat.log2 c.enunciado.pasos) bits c) r.corte.antes.tabla := by
  rw [Adversario.resultado_con_bytes] at ha
  cases hp : Lectura.exacto codecCertificado.leer (ProgramaBytes.resultado H proponer).1 with
  | none => rw [Completo.desdeBytes, hp] at ha; contradiction
  | some c =>
    rw [Completo.desdeBytes, hp] at ha
    obtain ⟨r, hb⟩ := omision_efectiva H B _ hs (Nat.log2 c.enunciado.pasos) bits R c ha
      (fun e he => (Adversario.registro_verificador H bits R proponer atacar actualizar).subset
        (by simpa only [Completo.desdeBytes, hp] using he)) defecto
    exact ⟨c, r, rfl, hb⟩

end Nexus.Verificador.MuestraBuena
