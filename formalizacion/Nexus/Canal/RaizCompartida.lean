module

public import Nexus.Canal.OraculosMerkle
import Mathlib.Tactic

/-!
# Una raíz y un formato compartidos entre AIR y FRI de traza

TG2 v1 autentica también los valores AIR como hojas Fp2 de diecisiete bytes.
La comprobación de la primera raíz FRI permite compartir el oráculo extraído,
incluido entre dos cortes distintos del registro. No se exige que todos sus
valores sean base: ese control se realiza en las posiciones abiertas.
-/

public section
namespace Nexus.Canal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM

@[expose] def comprobarRaizCompartida (raiz : Digest) : List Digest → Bool
  | [] => false
  | primera :: _ => decide (primera = raiz)

theorem raiz_compartida_iff (raiz : Digest) (raices : List Digest) :
    comprobarRaizCompartida raiz raices = true ↔ ∃ resto, raices = raiz :: resto := by
  cases raices <;> simp [comprobarRaizCompartida]

theorem oraculos_misma_raiz_entre_cortes {B : ℕ} {fin : Estado B}
    {s t raiz da db ea eb : Digest} {tagA tagB : Octeto} {tipoA tipoB : TipoReto}
    (ca : CorteRaizReto fin s tagA raiz tipoA da db) (cb : CorteRaizReto fin t tagB raiz tipoB ea eb)
    (k j : ℕ) (defecto : Digest) :
    oraculoEnEstado k j defecto ca.segunda.antes raiz = oraculoEnEstado k j defecto cb.segunda.antes raiz :=
  (oraculo_antes_reto_estable ca k j defecto).trans (oraculo_antes_reto_estable cb k j defecto).symm

theorem raiz_verificada_comparte_oraculo {B : ℕ} {fin : Estado B}
    {s t raiz primera da db ea eb : Digest} {tagA tagB : Octeto} {tipoA tipoB : TipoReto}
    (ca : CorteRaizReto fin s tagA raiz tipoA da db) (cb : CorteRaizReto fin t tagB primera tipoB ea eb)
    (resto : List Digest) (hr : comprobarRaizCompartida raiz (primera :: resto) = true)
    (k j : ℕ) (defecto : Digest) :
    oraculoEnEstado k j defecto ca.segunda.antes raiz =
      oraculoEnEstado k j defecto cb.segunda.antes primera := by
  have he : primera = raiz := by simpa only [comprobarRaizCompartida, decide_eq_true_eq] using hr
  subst primera
  exact oraculos_misma_raiz_entre_cortes ca cb k j defecto

theorem oraculo_compartido_antes_absorciones {B : ℕ} {fin : Estado B}
    {s t raiz da db ea eb : Digest} {tagA tagB : Octeto} {tipoA tipoB : TipoReto}
    (ca : CorteRaizReto fin s tagA raiz tipoA da db) (cb : CorteRaizReto fin t tagB raiz tipoB ea eb)
    (k j : ℕ) (defecto : Digest) :
    oraculoEnEstado k j defecto ca.primera.antes raiz = oraculoEnEstado k j defecto cb.primera.antes raiz :=
  (oraculo_antes_primera_exposicion ca k j defecto).trans
    ((oraculos_misma_raiz_entre_cortes ca cb k j defecto).trans
      (oraculo_antes_primera_exposicion cb k j defecto).symm)

theorem lectura_inicial_raiz_compartida {B : ℕ} {fin : Estado B}
    {s t raiz da db ea eb : Digest} {tagA tagB : Octeto} {tipoA tipoB : TipoReto}
    (ca : CorteRaizReto fin s tagA raiz tipoA da db) (cb : CorteRaizReto fin t tagB raiz tipoB ea eb)
    (k n : ℕ) (hn : 0 < n) (defecto : Digest) (estados : ℕ → Estado B) (raices : ℕ → Digest)
    (he : estados 0 = cb.segunda.antes) (hr : raices 0 = raiz) :
    leerOraculo (oraculosCongelados k n defecto estados raices) 0 =
      oraculoEnEstado k 0 defecto ca.segunda.antes raiz := by
  rw [leer_oraculos_congelados k n defecto estados raices 0 hn, he, hr]
  exact (oraculos_misma_raiz_entre_cortes ca cb k 0 defecto).symm

end Nexus.Canal
