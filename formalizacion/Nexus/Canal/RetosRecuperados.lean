module

public import Nexus.Canal.TrayectoTG2
public import Nexus.ROM.RegistroFinal
import Mathlib.Tactic

/-!
# Retos E obtenidos únicamente de respuestas anteriores

En una cadena válida las entradas de 33 octetos son exactamente los retos E.
Se conserva su orden, incluidos los retos repetidos. La tabla puede completarse
arbitrariamente fuera de las entradas de la cadena disponible.
-/

public section
namespace Nexus.Canal.RetosRecuperados

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM
open GramaticaTG2 RegistroRaices

@[expose] def retos (H : Entrada → Digest) (es : List Entrada) : List Fp2 :=
  (es.filter (fun e => e.length = 33)).map (fun e => DesafiosPrograma.extension (H e))

theorem retos_append (H : Entrada → Digest) (a b : List Entrada) :
    retos H (a ++ b) = retos H a ++ retos H b := by simp only [retos, List.filter_append, List.map_append]

theorem absorcion_sin_reto (H : Entrada → Digest) (s : Digest) (a : Absorcion) :
    retos H [entrada s a] = [] := by
  have hl := longitudes_absorcion s a
  have hn : (entrada s a).length ≠ 33 := by
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hl
    omega
  simp only [retos, List.filter_cons, hn, decide_false, Bool.false_eq_true, ite_false,
    List.filter_nil, List.map_nil]

theorem retos_de_retos (H : Entrada → Digest) (n : ℕ) (s : Digest) :
    retos H (logRetos H n s) = (evaluarRetos H n s).2 := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih =>
    simp only [logRetos, evaluarRetos, retos, List.filter_cons, reto_longitud,
      decide_true, ite_true, List.map_cons] at ih ⊢
    exact congrArg (DesafiosPrograma.extension (H (entradaReto s .extension)) :: ·) (ih _)

theorem retos_de_raices (H : Entrada → Digest) (rs : List Digest) (v : Fp2) (s : Digest) :
    retos H (logRaices H rs v s) = ((evaluarRaices H rs v s).2.map (beta H)) := by
  induction rs generalizing s with
  | nil => exact absorcion_sin_reto H s (.final v)
  | cons r rs ih =>
    have ha := absorcion_sin_reto H s (.raizFRI r)
    change retos H ([entrada s (.raizFRI r)] ++ [reto H ⟨s, 2, r⟩] ++
      logRaices H rs v (respuesta H ⟨s, 2, r⟩)) = _
    rw [retos_append, retos_append, ha, ih]
    simp only [retos, reto, reto_longitud, List.filter_cons, decide_true, ite_true,
      List.filter_nil, List.map_cons, List.map_nil, evaluarRaices, beta, List.nil_append,
      List.singleton_append, respuesta]

theorem retos_de_cadena (H : Entrada → Digest) (k bits : ℕ) (inicio salida : Fp)
    (r : Digest) (rt rc : List Digest) (vt vc : Fp2) (n : Nonce) :
    let v := RegistroCompleto.evaluar H k bits inicio salida r rt rc vt vc
    retos H (TrayectoTG2.cadena H k bits inicio salida r rt rc vt vc n) =
      v.alfas.2 ++ v.traza.2.map (beta H) ++ v.composicion.2.map (beta H) := by
  simp only [TrayectoTG2.cadena, RegistroCompleto.prefijo, retos_append]
  have hh (s : Digest) (a : Absorcion) := absorcion_sin_reto H s a
  have hi : retos H [codificar .inicio] = [] := rfl
  have hb (s : Digest) (raiz : Digest) :
      retos H [absorcion ⟨s, 1, raiz⟩] = [] := by
    exact hh s (.raizTraza raiz)
  rw [retos_de_retos, retos_de_raices, retos_de_raices]
  have hc (s : Digest) (a : Absorcion) : retos H [codificar (.absorber s a)] = [] := hh s a
  have hprimero (s t u : Digest) :
      retos H [codificar .inicio, codificar (.absorber s (.perfil (ProgramaTG2.perfil k bits))),
        codificar (.absorber t (.enunciado (ProgramaTG2.enunciado inicio salida k))),
        absorcion ⟨u, 1, r⟩] = [] := by
    change retos H ([codificar .inicio] ++ [_] ++ [_] ++ [_]) = []
    rw [retos_append, retos_append, retos_append, hi, hc, hc, hb]
    rfl
  simp only [RegistroCompleto.evaluar]
  rw [hprimero, hc, hc, hh]
  simp only [List.nil_append, List.append_nil]

theorem retos_congruentes (H G : Entrada → Digest) (es : List Entrada)
    (h : ∀ e ∈ es, H e = G e) : retos H es = retos G es := by
  apply List.map_congr_left
  intro e he
  exact congrArg DesafiosPrograma.extension (h e (List.mem_of_mem_filter he))

theorem retos_de_tabla (H : Entrada → Digest) (t : Tabla Entrada Digest) (es : List Entrada)
    (h : ∀ e ∈ es, buscar t e = some (H e)) (defecto : Digest) :
    retos (funcionTabla defecto t) es = retos H es := by
  apply retos_congruentes
  intro e he
  simp only [funcionTabla, h e he, Option.getD_some]

end Nexus.Canal.RetosRecuperados
