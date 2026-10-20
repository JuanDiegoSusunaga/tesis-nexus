module

public import Nexus.Verificador.SoporteCompleto
public import Nexus.Canal.FamiliasPrograma
public import Nexus.Verificador.Adversario
import Mathlib.Tactic

/-!
# Familias AIR/FRI desde la aceptación con adversario

Se construyen todos los cortes y oráculos desde la aceptación del verificador
matemático, usando su registro efectivo. Cada apertura queda ligada a su
oráculo anterior al primer reto correspondiente, bajo SinBad. La propuesta
adaptativa de bytes y las intercalaciones usan la misma tabla global.
La ley conjunta del selector y el refinamiento Rust permanecen separados.
-/

public section
namespace Nexus.Verificador.FamiliasAceptadas

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM Nexus.Canal
open ProgramaCompartido RegistroPrograma RegistroRaices FamiliasPrograma SoporteCompleto

structure Familias {A : Type} (H : Entrada → Digest) (B : ℕ) (p : ProgramaBytes.Programa A)
    (k bits R : ℕ) (c : Certificado) where
  testigo : Testigo H k bits R c
  base : Familia H B p [(vista H k bits c).base]
  traza : Familia H B p (vista H k bits c).traza.2
  composicion : Familia H B p (vista H k bits c).composicion.2

theorem construir_desde_aceptacion {A : Type} (H : Entrada → Digest) (B : ℕ)
    (p : ProgramaBytes.Programa A) (hs : EjecucionBytes.SinBad H (inicial B) p)
    (k bits R : ℕ) (c : Certificado)
    (ha : resultado (tabla H) (Completo.verificar k bits R c) = true)
    (hlog : ∀ e ∈ entradas H (Completo.verificar k bits R c), e ∈ ProgramaBytes.entradas H p) :
    Nonempty (Familias H B p k bits R c) := by
  obtain ⟨t⟩ := del_programa H k bits R c ha
  refine ⟨⟨t, construir H B p hs [(vista H k bits c).base] ?_,
    construir H B p hs (vista H k bits c).traza.2 ?_,
    construir H B p hs (vista H k bits c).composicion.2 ?_⟩⟩
  · intro e he
    have heq := List.mem_singleton.mp he
    subst e
    exact registrado_monotono H _ _ hlog _ (base_registrada t)
  · intro e he
    exact registrado_monotono H _ _ hlog e (traza_registrada t e he)
  · intro e he
    exact registrado_monotono H _ _ hlog e (composicion_registrada t e he)

theorem evento_por_indice (es : List Evento) (rs : List Digest)
    (hr : es.map Evento.raiz = rs) (i : Fin rs.length) :
    ∃ j : Fin es.length, j.val = i.val ∧ es[j].raiz = rs[i] := by
  subst rs
  refine ⟨⟨i.val, by simpa only [List.length_map] using i.isLt⟩, rfl, ?_⟩
  simp

@[expose] noncomputable def Congelada {A : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa A} {k bits R : ℕ} {c : Certificado}
    (f : Familias H B p k bits R c) (defecto : Digest) (a : AperturasPrograma.Apertura) : Prop :=
  leerOraculo (emitidos f.base k defecto) 0 (puntoCapa k 0 a.indice) = a.valor ∨
    (∃ j : Fin (vista H k bits c).traza.2.length,
      leerOraculo (emitidos f.traza k defecto) j.val (puntoCapa k j.val a.indice) = a.valor) ∨
    (∃ j : Fin (vista H k bits c).composicion.2.length,
      leerOraculo (emitidos f.composicion k defecto) j.val (puntoCapa k j.val a.indice) = a.valor)

theorem todas_congeladas {A : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa A} {k bits R : ℕ} {c : Certificado}
    (f : Familias H B p k bits R c)
    (hlog : ∀ e ∈ entradas H (Completo.verificar k bits R c), e ∈ ProgramaBytes.entradas H p)
    (defecto : Digest) (a : AperturasPrograma.Apertura) (hm : a ∈ aperturas f.testigo) : Congelada f defecto a := by
  have hk : k ≤ 29 := by have hh := f.testigo.forma.1.2.1; omega
  have ha := (soporte_total f.testigo a hm).1
  have hq := AperturasPrograma.registrada_monotona H _ _ hlog a (soporte_total f.testigo a hm).2
  have hi := rango_total f.testigo a hm
  have hr := RegistroCompleto.raices_conservadas H k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz
    c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final
  have hlen := forma_implica_cantidades k bits c f.testigo.forma
  rcases origen_total f.testigo a hm with hb | ht | hc
  · apply Or.inl
    exact apertura_en_familia f.base k hk defecto ⟨0, by simp⟩ (by simp) a hb.1
      (by simpa only [Nat.sub_zero] using hb.2) hi ha hq
  · obtain ⟨i, hir, hih⟩ := ht
    obtain ⟨j, hj, hroot⟩ := evento_por_indice (vista H k bits c).traza.2 c.prueba.traza.raices hr.1 i
    apply Or.inr ∘ Or.inl
    refine ⟨j, apertura_en_familia f.traza k hk defecto j ?_ a (hir.trans hroot.symm) ?_ hi ha hq⟩
    · have hic := i.isLt.trans_le hlen.1.le; omega
    · simpa only [hj] using hih
  · obtain ⟨i, hir, hih⟩ := hc
    obtain ⟨j, hj, hroot⟩ := evento_por_indice (vista H k bits c).composicion.2 c.prueba.composicion.raices hr.2 i
    apply Or.inr ∘ Or.inr
    refine ⟨j, apertura_en_familia f.composicion k hk defecto j ?_ a (hir.trans hroot.symm) ?_ hi ha hq⟩
    · have hic := i.isLt.trans_le hlen.2.1.le; omega
    · simpa only [hj] using hih

theorem cantidades_familias {A : Type} {H : Entrada → Digest} {B : ℕ}
    {p : ProgramaBytes.Programa A} {k bits R : ℕ} {c : Certificado} (f : Familias H B p k bits R c) :
    (vista H k bits c).traza.2.length = k ∧ (vista H k bits c).composicion.2.length = k + 1 := by
  have hr := RegistroCompleto.raices_conservadas H k bits c.enunciado.inicio c.enunciado.salida c.prueba.raiz
    c.prueba.traza.raices c.prueba.composicion.raices c.prueba.traza.final c.prueba.composicion.final
  have ht := congrArg List.length hr.1
  have hc := congrArg List.length hr.2
  have hl := forma_implica_cantidades k bits c f.testigo.forma
  simp only [List.length_map, hl.1, hl.2.1] at ht hc
  exact ⟨ht, hc⟩

theorem desde_adversario {A : Type} (H : Entrada → Digest) (B bits R : ℕ)
    (proponer : ProgramaBytes.Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → ProgramaBytes.Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (hs : EjecucionBytes.SinBad H (inicial B) (Adversario.ejecutar bits R proponer atacar actualizar))
    (ha : ProgramaBytes.resultado H (Adversario.ejecutar bits R proponer atacar actualizar) = true) :
    ∃ c, Lectura.exacto codecCertificado.leer (ProgramaBytes.resultado H proponer).1 = some c ∧
      Nonempty (Familias H B (Adversario.ejecutar bits R proponer atacar actualizar)
        (Nat.log2 c.enunciado.pasos) bits R c) := by
  rw [Adversario.resultado_con_bytes] at ha
  cases hp : Lectura.exacto codecCertificado.leer (ProgramaBytes.resultado H proponer).1 with
  | none => rw [Completo.desdeBytes, hp] at ha; contradiction
  | some c =>
    refine ⟨c, rfl, ?_⟩
    rw [Completo.desdeBytes, hp] at ha
    apply construir_desde_aceptacion H B _ hs (Nat.log2 c.enunciado.pasos) bits R c ha
    intro e he
    apply (Adversario.registro_verificador H bits R proponer atacar actualizar).subset
    simpa only [Completo.desdeBytes, hp] using he

theorem cierre_adversario {A : Type} (H : Entrada → Digest) (B bits R : ℕ)
    (proponer : ProgramaBytes.Programa (List Octeto × A))
    (atacar : A → GramaticaTG2.Peticion → ProgramaBytes.Programa A)
    (actualizar : A → GramaticaTG2.Peticion → Digest → A)
    (hs : EjecucionBytes.SinBad H (inicial B) (Adversario.ejecutar bits R proponer atacar actualizar))
    (ha : ProgramaBytes.resultado H (Adversario.ejecutar bits R proponer atacar actualizar) = true) :
    ∃ c, ∃ f : Familias H B (Adversario.ejecutar bits R proponer atacar actualizar)
        (Nat.log2 c.enunciado.pasos) bits R c,
      Lectura.exacto codecCertificado.leer (ProgramaBytes.resultado H proponer).1 = some c ∧
      ∀ (defecto : Digest) (a : AperturasPrograma.Apertura), a ∈ aperturas f.testigo → Congelada f defecto a := by
  obtain ⟨c, hp, ⟨f⟩⟩ := desde_adversario H B bits R proponer atacar actualizar hs ha
  refine ⟨c, f, hp, ?_⟩
  apply todas_congeladas f
  intro e he
  apply (Adversario.registro_verificador H bits R proponer atacar actualizar).subset
  simpa only [Completo.desdeBytes, hp] using he

end Nexus.Verificador.FamiliasAceptadas
