module

public import Nexus.ROM.EjecucionBytes
public import Nexus.Verificador.Completo
import Mathlib.Tactic

/-!
# Consultas del adversario antes y entre las del verificador

La política del adversario recibe su estado, la próxima petición y después
su respuesta. Puede emitir programas finitos de bytes arbitrarios antes de
cada petición. El resultado del verificador se conserva sobre la misma H;
su registro es una subsecuencia del global y el coste global suma los extras.
Esto no identifica todavía el programa matemático con todo Rust.
-/

public section
namespace Nexus.Canal.Intercalaciones

open Nexus.Bytes Nexus.Merkle Nexus.ROM
open ProgramaBytes
open GramaticaTG2 (Peticion codificar)

@[expose] def intercalar {A : Type} (atacar : A → Peticion → Programa A)
    (actualizar : A → Peticion → Digest → A) : ProgramaCompartido.Programa → A → Programa Bool
  | .terminar b, _ => .terminar b
  | .consultar q f, a => unir (atacar a q) (fun b => .consultar (codificar q)
      (fun d => intercalar atacar actualizar (f d) (actualizar b q d)))

@[expose] def extras {A : Type} (H : Entrada → Digest) (atacar : A → Peticion → Programa A)
    (actualizar : A → Peticion → Digest → A) : ProgramaCompartido.Programa → A → ℕ
  | .terminar _, _ => 0
  | .consultar q f, a => (traza H (atacar a q)).length +
      extras H atacar actualizar (f (H (codificar q)))
        (actualizar (resultado H (atacar a q)) q (H (codificar q)))

theorem resultado_intercalado {A : Type} (H : Entrada → Digest) (atacar : A → Peticion → Programa A)
    (actualizar : A → Peticion → Digest → A) (p : ProgramaCompartido.Programa) (a : A) :
    resultado H (intercalar atacar actualizar p a) =
      ProgramaCompartido.resultado (RegistroPrograma.tabla H) p := by
  induction p generalizing a with
  | terminar b => rfl
  | consultar q f ih =>
    rw [intercalar, resultado_unir]
    simpa only [resultado, ProgramaCompartido.resultado, RegistroPrograma.tabla_codificacion] using ih _ _

theorem registro_intercalado {A : Type} (H : Entrada → Digest) (atacar : A → Peticion → Programa A)
    (actualizar : A → Peticion → Digest → A) (p : ProgramaCompartido.Programa) (a : A) :
    List.Sublist (RegistroPrograma.entradas H p) (entradas H (intercalar atacar actualizar p a)) := by
  induction p generalizing a with
  | terminar b => exact List.Sublist.refl _
  | consultar q f ih =>
    simp only [intercalar, entradas, traza_unir, traza, List.map_append, List.map_cons,
      RegistroPrograma.entradas]
    exact ((ih _ _).cons_cons _).trans (List.sublist_append_right _ _)

theorem costo_intercalado {A : Type} (H : Entrada → Digest) (atacar : A → Peticion → Programa A)
    (actualizar : A → Peticion → Digest → A) (p : ProgramaCompartido.Programa) (a : A) :
    (traza H (intercalar atacar actualizar p a)).length =
      (RegistroPrograma.entradas H p).length + extras H atacar actualizar p a := by
  induction p generalizing a with
  | terminar b => rfl
  | consultar q f ih =>
    simp only [intercalar, traza_unir, traza, List.length_append, List.length_cons,
      RegistroPrograma.entradas, extras, ih]
    omega

theorem presupuesto_con_adversario {A : Type} (H : Entrada → Digest)
    (atacar : A → Peticion → Programa A) (actualizar : A → Peticion → Digest → A)
    (p : ProgramaCompartido.Programa) (a : A) (Q V : ℕ)
    (hq : extras H atacar actualizar p a ≤ Q) (hv : Nexus.Canal.ProgramaTG2.Acotado p V) :
    (traza H (intercalar atacar actualizar p a)).length ≤ Q + V := by
  rw [costo_intercalado]
  have hc : (RegistroPrograma.entradas H p).length ≤ V := by
    rw [RegistroPrograma.entradas_cuentan_respuestas]
    exact hv (RegistroPrograma.tabla H)
  omega

@[expose] noncomputable def verificar {A : Type} (atacar : A → Peticion → Programa A)
    (actualizar : A → Peticion → Digest → A) (a : A) (k bits R : ℕ)
    (c : Nexus.Verificador.Certificado) : Programa Bool :=
  intercalar atacar actualizar (Nexus.Verificador.Completo.verificar k bits R c) a

theorem verificador_intercalado_equivale {A : Type} (H : Entrada → Digest)
    (atacar : A → Peticion → Programa A) (actualizar : A → Peticion → Digest → A)
    (a : A) (k bits R : ℕ) (c : Nexus.Verificador.Certificado) :
    resultado H (verificar atacar actualizar a k bits R c) =
      ProgramaCompartido.resultado (RegistroPrograma.tabla H) (Nexus.Verificador.Completo.verificar k bits R c) :=
  resultado_intercalado H atacar actualizar _ a

theorem presupuesto_verificador_intercalado {A : Type} (H : Entrada → Digest)
    (atacar : A → Peticion → Programa A) (actualizar : A → Peticion → Digest → A)
    (a : A) (k bits R Q : ℕ) (c : Nexus.Verificador.Certificado)
    (hq : extras H atacar actualizar (Nexus.Verificador.Completo.verificar k bits R c) a ≤ Q) :
    (traza H (verificar atacar actualizar a k bits R c)).length ≤
      Q + Nexus.ROM.Presupuestos.verificadorPerfil k R :=
  presupuesto_con_adversario H atacar actualizar _ a Q _ hq
    (Nexus.Verificador.Completo.presupuesto_verificador k bits R c)

theorem consultas_verificador_guardadas {A : Type} (H : Entrada → Digest)
    (atacar : A → Peticion → Programa A) (actualizar : A → Peticion → Digest → A)
    (a : A) (k bits R B : ℕ) (c : Nexus.Verificador.Certificado) (e : Entrada)
    (he : e ∈ RegistroPrograma.entradas H (Nexus.Verificador.Completo.verificar k bits R c)) :
    buscar (EjecucionBytes.final H (inicial B) (verificar atacar actualizar a k bits R c)).tabla e = some (H e) := by
  apply EjecucionBytes.consulta_en_tabla H _ _ (by intro x d hx; contradiction)
  exact (registro_intercalado H atacar actualizar _ a).subset he

end Nexus.Canal.Intercalaciones
