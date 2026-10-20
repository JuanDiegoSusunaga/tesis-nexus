module

public import Nexus.Canal.SelectorOrdenado
public import Nexus.ROM.RegistroPrograma
import Mathlib.Tactic

/-!
# Canal con los desafíos y el orden de consultas

Las dos mitades de cada respuesta E se reducen en Goldilocks y se entregan
a la continuación. La ejecución conserva tres alfas, todos los betas y el
orden de primera aparición de cuarenta índices. El corte R es analítico.
Se cuenta la tabla común incluso cuando falla el trabajo o se repite un índice.
-/

public section
namespace Nexus.Canal.DesafiosPrograma

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks GramaticaTG2
open Nexus.ROM.ProgramaCompartido
open ProgramaTG2 (Acotado perfil enunciado)

@[expose] def extension (d : Digest) : Fp2 :=
  ⟨(leerLE (d.val.take 16) : Fp), (leerLE (d.val.drop 16) : Fp)⟩

abbrev tamanoPalabra : ℕ := 2 ^ 128

@[expose] def palabraBaja (d : Digest) : Fin tamanoPalabra :=
  ⟨leerLE (d.val.take 16), by
    have h := leer_le_cota (d.val.take 16)
    simpa [tamanoPalabra, d.property] using h⟩

@[expose] def palabraAlta (d : Digest) : Fin tamanoPalabra :=
  ⟨leerLE (d.val.drop 16), by
    have h := leer_le_cota (d.val.drop 16)
    simpa [tamanoPalabra, d.property] using h⟩

theorem extension_factoriza (d : Digest) :
    extension d = ⟨(palabraBaja d : Fp), (palabraAlta d : Fp)⟩ := by
  simp only [extension, palabraBaja, palabraAlta]

@[expose] def retos : ℕ → Digest → (Digest → List Fp2 → Programa) → Programa
  | 0, s, continuar => continuar s []
  | n + 1, s, continuar => .consultar (.extension s) (fun d =>
      retos n d (fun t xs => continuar t (extension d :: xs)))

@[expose] def raices : List Digest → Fp2 → Digest → (Digest → List Fp2 → Programa) → Programa
  | [], final, s, continuar => .consultar (.absorber s (.final final)) (fun t => continuar t [])
  | r :: rs, final, s, continuar => .consultar (.absorber s (.raizFRI r)) (fun d =>
      .consultar (.extension d) (fun e => raices rs final e (fun t xs => continuar t (extension e :: xs))))

@[expose] def fase (b : Bool) (rs : List Digest) (final : Fp2) (s : Digest)
    (continuar : Digest → List Fp2 → Programa) : Programa :=
  .consultar (.absorber s (if b then .faseTraza else .faseComposicion))
    (fun d => raices rs final d continuar)

@[expose] def ejecutar (k bits R : ℕ) (inicio salida : Fp) (raiz : Digest)
    (traza composicion : List Digest) (vt vc : Fp2) (nonce : Nonce) (trabajo : Digest → Bool)
    (continuar : List Fp2 → List Fp2 → List Fp2 → List (Fin (4 * 2 ^ k)) → Programa) : Programa :=
  .consultar .inicio (fun s0 =>
    .consultar (.absorber s0 (.perfil (perfil k bits))) (fun s1 =>
      .consultar (.absorber s1 (.enunciado (enunciado inicio salida k))) (fun s2 =>
        .consultar (.absorber s2 (.raizTraza raiz)) (fun s3 =>
          retos 3 s3 (fun s4 alfas =>
            fase true traza vt s4 (fun s5 bt =>
              fase false composicion vc s5 (fun s6 bc =>
                .consultar (.trabajo s6 nonce) (fun d =>
                  if trabajo d then .consultar (.absorber s6 (.nonce nonce)) (fun s7 =>
                    SelectorOrdenado.seleccionar (4 * 2 ^ k) (by positivity) R s7 []
                      (continuar alfas bt bc))
                  else .terminar false))))))))

theorem proyeccion_retos (n : ℕ) (s : Digest) (c : Digest → Programa) :
    retos n s (fun t _ => c t) = ProgramaTG2.retos n s c := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => simp only [retos, ProgramaTG2.retos]; congr 1; funext d; exact ih d

theorem proyeccion_raices (rs : List Digest) (v : Fp2) (s : Digest) (c : Digest → Programa) :
    raices rs v s (fun t _ => c t) = ProgramaTG2.raices rs v s c := by
  induction rs generalizing s with
  | nil => rfl
  | cons r rs ih => simp only [raices, ProgramaTG2.raices]; congr 1; funext d; congr 1; funext e; exact ih e

theorem costo_retos (n C : ℕ) (s : Digest) (c : Digest → List Fp2 → Programa)
    (hc : ∀ d xs, Acotado (c d xs) C) : Acotado (retos n s c) (n + C) := by
  induction n generalizing s c with
  | zero => simpa only [retos, Nat.zero_add] using hc s []
  | succ n ih =>
    intro H
    simp only [retos, respuestas, List.length_cons]
    have h := ih (H (clave (.extension s)))
      (fun t xs => c t (extension (H (clave (.extension s))) :: xs))
      (fun d xs => hc d _) H
    omega

theorem costo_raices (rs : List Digest) (v : Fp2) (s : Digest) (C : ℕ)
    (c : Digest → List Fp2 → Programa) (hc : ∀ d xs, Acotado (c d xs) C) :
    Acotado (raices rs v s c) (2 * rs.length + 1 + C) := by
  induction rs generalizing s c with
  | nil =>
    intro H
    simp only [raices, respuestas, List.length_cons, List.length_nil, Nat.mul_zero, Nat.zero_add]
    have h := hc (H (clave (.absorber s (.final v)))) [] H
    omega
  | cons r rs ih =>
    intro H
    simp only [raices, respuestas, List.length_cons]
    have h := ih (H (clave (.extension (H (clave (.absorber s (.raizFRI r)))))))
      (fun t xs => c t (extension (H (clave (.extension (H (clave (.absorber s (.raizFRI r))))))) :: xs))
      (fun d xs => hc d _) H
    omega

theorem costo_fase (b : Bool) (rs : List Digest) (v : Fp2) (s : Digest) (C : ℕ)
    (c : Digest → List Fp2 → Programa) (hc : ∀ d xs, Acotado (c d xs) C) :
    Acotado (fase b rs v s c) (2 * rs.length + 2 + C) := by
  intro H
  simp only [fase, respuestas, List.length_cons]
  have h := costo_raices rs v (H (clave (.absorber s (if b then .faseTraza else .faseComposicion)))) C c hc H
  omega

theorem costo_selector (M : ℕ) (hM : 0 < M) (R C : ℕ) (s : Digest) (S : List (Fin M))
    (c : List (Fin M) → Programa) (hc : ∀ T, Acotado (c T) C) :
    Acotado (SelectorOrdenado.seleccionar M hM R s S c) (R + C) := by
  induction R generalizing s S with
  | zero =>
    intro H
    simp only [SelectorOrdenado.seleccionar]
    split_ifs
    · simpa only [Nat.zero_add] using hc S H
    · exact Nat.zero_le _
  | succ R ih =>
    intro H
    simp only [SelectorOrdenado.seleccionar]
    split_ifs
    · exact (hc S H).trans (by omega)
    · simp only [respuestas, List.length_cons]
      have h := ih (H (clave (.indice s))) (SelectorOrdenado.agregar S
        (ProgramaTG2.indice M hM (H (clave (.indice s))))) H
      omega

theorem presupuesto_canal (k bits R C : ℕ) (inicio salida : Fp) (raiz : Digest)
    (traza composicion : List Digest) (vt vc : Fp2) (nonce : Nonce) (trabajo : Digest → Bool)
    (c : List Fp2 → List Fp2 → List Fp2 → List (Fin (4 * 2 ^ k)) → Programa)
    (hc : ∀ a bt bc S, Acotado (c a bt bc S) C) :
    Acotado (ejecutar k bits R inicio salida raiz traza composicion vt vc nonce trabajo c)
      (13 + 2 * (traza.length + composicion.length) + R + C) := by
  let ultimas : List Fp2 → List Fp2 → List Fp2 → Digest → Programa := fun a bt bc s6 =>
    .consultar (.trabajo s6 nonce) (fun d => if trabajo d then
      .consultar (.absorber s6 (.nonce nonce)) (fun s7 =>
        SelectorOrdenado.seleccionar (4 * 2 ^ k) (by positivity) R s7 [] (c a bt bc)) else .terminar false)
  have hfin (a bt bc : List Fp2) (s6 : Digest) : Acotado (ultimas a bt bc s6) (2 + R + C) := by
    intro G
    simp only [ultimas, respuestas, List.length_cons]
    split_ifs
    · simp only [respuestas, List.length_cons]
      have h := costo_selector (4 * 2 ^ k) (by positivity) R C
        (G (clave (.absorber s6 (.nonce nonce)))) [] (c a bt bc) (hc a bt bc) G
      omega
    · simp only [respuestas, List.length_nil]; omega
  let cont2 : List Fp2 → Digest → List Fp2 → Programa := fun a s5 bt =>
    fase false composicion vc s5 (fun s6 bc => ultimas a bt bc s6)
  have h2 (a : List Fp2) (s5 : Digest) (bt : List Fp2) :
      Acotado (cont2 a s5 bt) (2 * composicion.length + 2 + (2 + R + C)) :=
    costo_fase false composicion vc s5 _ _ (fun d bc => hfin a bt bc d)
  let cont1 : Digest → List Fp2 → Programa := fun s4 a => fase true traza vt s4 (cont2 a)
  have h1 (s4 : Digest) (a : List Fp2) : Acotado (cont1 s4 a)
      (2 * traza.length + 2 + (2 * composicion.length + 2 + (2 + R + C))) :=
    costo_fase true traza vt s4 _ _ (h2 a)
  intro H
  let s0 := H (clave .inicio)
  let s1 := H (clave (.absorber s0 (.perfil (perfil k bits))))
  let s2 := H (clave (.absorber s1 (.enunciado (enunciado inicio salida k))))
  let s3 := H (clave (.absorber s2 (.raizTraza raiz)))
  have h := costo_retos 3 _ s3 cont1 h1 H
  change (respuestas H (retos 3 s3 cont1)).length + 1 + 1 + 1 + 1 ≤ _
  omega

theorem retos_entregan_longitud (n : ℕ) (s : Digest) (c : Digest → List Fp2 → Programa)
    (H : Clave → Digest) (ha : resultado H (retos n s c) = true) :
    ∃ t xs, xs.length = n ∧ resultado H (c t xs) = true := by
  induction n generalizing s c with
  | zero => exact ⟨s, [], rfl, ha⟩
  | succ n ih =>
    obtain ⟨t, xs, hlen, h⟩ := ih (H (clave (.extension s))) _ ha
    exact ⟨t, extension (H (clave (.extension s))) :: xs, by simp [hlen], h⟩

theorem raices_entregan_longitud (rs : List Digest) (v : Fp2) (s : Digest)
    (c : Digest → List Fp2 → Programa) (H : Clave → Digest)
    (ha : resultado H (raices rs v s c) = true) :
    ∃ t xs, xs.length = rs.length ∧ resultado H (c t xs) = true := by
  induction rs generalizing s c with
  | nil => exact ⟨H (clave (.absorber s (.final v))), [], rfl, ha⟩
  | cons r rs ih =>
    obtain ⟨t, xs, hlen, h⟩ := ih (H (clave (.extension (H (clave (.absorber s (.raizFRI r))))))) _ ha
    exact ⟨t, extension (H (clave (.extension (H (clave (.absorber s (.raizFRI r))))))) :: xs,
      by simp [hlen], h⟩

theorem aceptacion_entrega (k bits R : ℕ) (inicio salida : Fp) (raiz : Digest)
    (traza composicion : List Digest) (vt vc : Fp2) (nonce : Nonce) (trabajo : Digest → Bool)
    (c : List Fp2 → List Fp2 → List Fp2 → List (Fin (4 * 2 ^ k)) → Programa)
    (H : Clave → Digest)
    (ha : resultado H (ejecutar k bits R inicio salida raiz traza composicion vt vc nonce trabajo c) = true) :
    ∃ a bt bc S, a.length = 3 ∧ bt.length = traza.length ∧ bc.length = composicion.length ∧
      S.Nodup ∧ S.length = 40 ∧ resultado H (c a bt bc S) = true := by
  simp only [ejecutar, resultado] at ha
  obtain ⟨s4, a, ha3, h4⟩ := retos_entregan_longitud 3 _ _ H ha
  simp only [fase, resultado] at h4
  obtain ⟨s5, bt, hbt, h5⟩ := raices_entregan_longitud traza vt _ _ H h4
  simp only [resultado] at h5
  obtain ⟨s6, bc, hbc, h6⟩ := raices_entregan_longitud composicion vc _ _ H h5
  simp only [resultado] at h6
  split_ifs at h6
  · obtain ⟨S, hS, hlen, _, hfin⟩ := SelectorOrdenado.aceptacion_lista_completa
      (4 * 2 ^ k) (by positivity) R _ [] (by simp) H (c a bt bc) h6
    exact ⟨a, bt, bc, S, ha3, hbt, hbc, hS, hlen, hfin⟩
  · contradiction

end Nexus.Canal.DesafiosPrograma
