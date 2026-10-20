module

public import Nexus.Verificador.ConjuntosPrevios
public import Nexus.Canal.CapasIndexadas
public import Nexus.FRI.AperturasPrograma
import Mathlib.Tactic

/-!
# Del recorrido aceptado a sus controles sobre valores extraídos

Los caminos Merkle dejan de intervenir una vez fijados izquierda y derecha.
Se conservan la compatibilidad del acarreo, el plegado y el estado siguiente.
-/

public section
namespace Nexus.Goldilocks.ControlesValores

open Nexus.Bytes Nexus.Merkle Nexus.ROM Nexus.Canal
open Recorrido ProgramaFRI VistaSemantica CapasIndexadas
open Nexus.Verificador.ConjuntosPrevios

theorem compatible_valores (k j : ℕ) (s : Estado) (d e : Apertura)
    (hl : d.izquierda = e.izquierda) (hr : d.derecha = e.derecha) :
    Compatible k j s d ↔ Compatible k j s e := by
  cases h : s.acarreo <;> simp only [Compatible, h, hl, hr]

theorem plegado_valores (k j i : ℕ) (d e : Apertura) (β : Fp2)
    (hl : d.izquierda = e.izquierda) (hr : d.derecha = e.derecha) :
    plegar k j i d β = plegar k j i e β := by simp only [plegar, hl, hr]

theorem siguiente_valores (k j : ℕ) (s : Estado) (d e : Apertura) (β : Fp2)
    (hl : d.izquierda = e.izquierda) (hr : d.derecha = e.derecha) :
    siguiente k j s d β = siguiente k j s e β := by
  simp only [siguiente, plegado_valores k j _ d e β hl hr]

theorem recorrido_valores (H : Entrada → Digest) (t : Tabla Entrada Digest) (defecto : Digest)
    (k j : ℕ) (rs : List Digest) (bs : List Fp2) (ds : List Apertura) (s : Estado) (final : Fp2)
    (hlb : rs.length = bs.length) (hld : rs.length = ds.length)
    (ha : condiciones H k j (rs.zip (bs.zip ds)) s final)
    (hv : ∀ a ∈ AperturasFRI.aperturas k j (rs.zip (bs.zip ds)) s,
      valor t defecto a.altura a.raiz a.indice = a.valor) :
    controlesFRI k j (desde t defecto (k + 3) j rs) bs s final := by
  induction rs generalizing j bs ds s with
  | nil =>
    have hb : bs = [] := by simpa using hlb.symm
    have hd : ds = [] := by simpa using hld.symm
    subst bs; subst ds
    exact ha
  | cons r rs ih =>
    cases bs with
    | nil => simp only [List.length_cons, List.length_nil] at hlb; omega
    | cons β bs =>
      cases ds with
      | nil => simp only [List.length_cons, List.length_nil] at hld; omega
      | cons d ds =>
        let observado : Apertura := ⟨valor t defecto (k + 3 - j) r (s.posicion % mitad k j),
          valor t defecto (k + 3 - j) r (s.posicion % mitad k j + mitad k j), [], []⟩
        have hl : observado.izquierda = d.izquierda := hv (AperturasFRI.izquierda k j s r d) List.mem_cons_self
        have hr : observado.derecha = d.derecha :=
          hv (AperturasFRI.derecha k j s r d) (List.mem_cons_of_mem _ List.mem_cons_self)
        change Compatible k j s observado ∧ controlesFRI k (j + 1)
          (desde t defecto (k + 3) (j + 1) rs) bs (siguiente k j s observado β) final
        refine ⟨(compatible_valores k j s observado d hl hr).mpr ha.2.1, ?_⟩
        rw [siguiente_valores k j s observado d β hl hr]
        apply ih (j + 1) bs ds (siguiente k j s d β) (by simpa using hlb) (by simpa using hld) ha.2.2
        intro a hm
        exact hv a (List.mem_cons_of_mem _ (List.mem_cons_of_mem _ hm))

theorem verificacion_valores (H : Entrada → Digest) (t : Tabla Entrada Digest) (defecto : Digest)
    (k m i : ℕ) (rs : List Digest) (bs : List Fp2) (ds : List Apertura) (final : Fp2)
    (ha : ProgramaCompartido.resultado (RegistroPrograma.tabla H)
      (ProgramaFRI.verificar k m i rs bs ds final) = true)
    (hv : ∀ a ∈ AperturasFRI.aperturas k 0 (rs.zip (bs.zip ds)) ⟨i, none⟩,
      valor t defecto a.altura a.raiz a.indice = a.valor) :
    controlesFRI k 0 (capas t defecto (k + 3) rs) bs ⟨i, none⟩ final := by
  have hh := (formas_y_condiciones H k m i rs bs ds final).mp ha
  rw [capas_desde]
  exact recorrido_valores H t defecto k 0 rs bs ds ⟨i, none⟩ final
    (hh.1.trans hh.2.1.symm) (hh.1.trans hh.2.2.1.symm) hh.2.2.2 hv

theorem primera_pareja (t : Tabla Entrada Digest) (defecto : Digest) (k i : ℕ)
    (hi : i < 2 ^ (k + 2)) (r : Digest) (rs : List Digest) (β : Fp2) (bs : List Fp2)
    (d : Apertura) (ds : List Apertura)
    (hv : ∀ a ∈ AperturasFRI.aperturas k 0 ((r :: rs).zip ((β :: bs).zip (d :: ds))) ⟨i, none⟩,
      valor t defecto a.altura a.raiz a.indice = a.valor) :
    valor t defecto (k + 3) r i = d.izquierda ∧
      valor t defecto (k + 3) r (i + 2 ^ (k + 2)) = d.derecha := by
  have hl := hv (AperturasFRI.izquierda k 0 ⟨i, none⟩ r d) List.mem_cons_self
  have hr := hv (AperturasFRI.derecha k 0 ⟨i, none⟩ r d) (List.mem_cons_of_mem _ List.mem_cons_self)
  have he : mitad k 0 = 2 ^ (k + 2) := by simp only [mitad]; congr 1
  have hp := And.intro hl hr
  simpa only [AperturasFRI.izquierda, AperturasFRI.derecha, Nat.sub_zero, he, Nat.mod_eq_of_lt hi] using hp

theorem primera_verificacion (H : Entrada → Digest) (t : Tabla Entrada Digest) (defecto : Digest)
    (k m i : ℕ) (hi : i < 2 ^ (k + 2)) (hm : 0 < m)
    (rs : List Digest) (bs : List Fp2) (ds : List Apertura) (final : Fp2)
    (ha : ProgramaCompartido.resultado (RegistroPrograma.tabla H)
      (ProgramaFRI.verificar k m i rs bs ds final) = true)
    (hv : ∀ a ∈ AperturasFRI.aperturas k 0 (rs.zip (bs.zip ds)) ⟨i, none⟩,
      valor t defecto a.altura a.raiz a.indice = a.valor) :
    ∃ r resto d restantes, rs = r :: resto ∧ ds = d :: restantes ∧
      valor t defecto (k + 3) r i = d.izquierda ∧
      valor t defecto (k + 3) r (i + 2 ^ (k + 2)) = d.derecha := by
  have hh := (formas_y_condiciones H k m i rs bs ds final).mp ha
  cases rs with
  | nil => simp only [List.length_nil] at hh; omega
  | cons r resto =>
    cases bs with
    | nil => simp only [List.length_nil] at hh; omega
    | cons β betas =>
      cases ds with
      | nil => simp only [List.length_nil] at hh; omega
      | cons d restantes =>
        exact ⟨r, resto, d, restantes, rfl, rfl,
          primera_pareja t defecto k i hi r resto β betas d restantes hv⟩

end Nexus.Goldilocks.ControlesValores
