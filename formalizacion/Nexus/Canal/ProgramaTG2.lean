module

public import Nexus.ROM.ProgramaCompartido
public import Nexus.ROM.Presupuestos
import Mathlib.Tactic

/-!
# Canal TG2 v1 como programa de consultas compartidas

Se ejecutan perfil, enunciado, raíz, tres alfas, las dos fases FRI, trabajo,
absorción del nonce y un único selector para ambas fases. El corte R es
analítico; el bucle Rust original no tiene ese corte. El verificador de las
aperturas se recibe como continuación y conserva su obligación separada.
-/

public section
namespace Nexus.Canal.ProgramaTG2

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks
open GramaticaTG2 Nexus.ROM.ProgramaCompartido

@[expose] def perfil (k bits : ℕ) : Datos 38 :=
  ⟨codificarLE 2 1 ++ codificarLE 4 bits ++ codificarLE 8 (8 * 2 ^ k) ++
    codificarLE 8 (2 ^ k) ++ codificarLE 8 (2 * 2 ^ k) ++ codificarLE 8 40,
    by simp [codificar_le_longitud]⟩

@[expose] def enunciado (inicio salida : Fp) (k : ℕ) : Datos 24 :=
  ⟨codificarLE 8 inicio.val ++ codificarLE 8 salida.val ++ codificarLE 8 (2 ^ k),
    by simp [codificar_le_longitud]⟩

@[expose] def retos : ℕ → Digest → (Digest → Programa) → Programa
  | 0, s, continuar => continuar s
  | n + 1, s, continuar => .consultar (.extension s) (fun d => retos n d continuar)

@[expose] def raices : List Digest → Fp2 → Digest → (Digest → Programa) → Programa
  | [], final, s, continuar => .consultar (.absorber s (.final final)) continuar
  | r :: rs, final, s, continuar =>
    .consultar (.absorber s (.raizFRI r)) (fun d =>
      .consultar (.extension d) (fun e => raices rs final e continuar))

@[expose] def fase (esTraza : Bool) (rs : List Digest) (final : Fp2)
    (s : Digest) (continuar : Digest → Programa) : Programa :=
  .consultar (.absorber s (if esTraza then .faseTraza else .faseComposicion))
    (fun d => raices rs final d continuar)

@[expose] def indice (M : ℕ) (hM : 0 < M) (d : Digest) : Fin M :=
  ⟨leerLE (d.val.take 8) % M, Nat.mod_lt _ hM⟩

@[expose] def seleccionar (M : ℕ) (hM : 0 < M) :
    ℕ → Digest → Finset (Fin M) → (Finset (Fin M) → Programa) → Programa
  | R, s, S, continuar =>
    if S.card = 40 then continuar S else
      match R with
      | 0 => .terminar false
      | R + 1 => .consultar (.indice s) (fun d => seleccionar M hM R d (insert (indice M hM d) S) continuar)

@[expose] def ejecutar (k bits R : ℕ) (inicio salida : Fp) (raiz : Digest)
    (traza composicion : List Digest) (finalTraza finalComposicion : Fp2) (nonce : Nonce)
    (trabajoValido : Digest → Bool) (continuar : Finset (Fin (4 * 2 ^ k)) → Programa) : Programa :=
  .consultar .inicio (fun s0 =>
    .consultar (.absorber s0 (.perfil (perfil k bits))) (fun s1 =>
      .consultar (.absorber s1 (.enunciado (enunciado inicio salida k))) (fun s2 =>
        .consultar (.absorber s2 (.raizTraza raiz)) (fun s3 =>
          retos 3 s3 (fun s4 =>
            fase true traza finalTraza s4 (fun s5 =>
              fase false composicion finalComposicion s5 (fun s6 =>
                .consultar (.trabajo s6 nonce) (fun d =>
                  if trabajoValido d then
                    .consultar (.absorber s6 (.nonce nonce)) (fun s7 =>
                      seleccionar (4 * 2 ^ k) (by positivity) R s7 ∅ continuar)
                  else .terminar false))))))))

@[expose] def Acotado (p : Programa) (C : ℕ) : Prop :=
  ∀ H : Clave → Digest, (respuestas H p).length ≤ C

theorem costo_retos (n C : ℕ) (s : Digest) (continuar : Digest → Programa)
    (hc : ∀ d, Acotado (continuar d) C) : Acotado (retos n s continuar) (n + C) := by
  induction n generalizing s with
  | zero => simpa only [retos, Nat.zero_add] using hc s
  | succ n ih =>
    intro H
    simp only [retos, respuestas, List.length_cons]
    have h := ih (H (clave (.extension s))) H
    omega

theorem costo_raices (rs : List Digest) (v : Fp2) (s : Digest) (C : ℕ)
    (continuar : Digest → Programa) (hc : ∀ d, Acotado (continuar d) C) :
    Acotado (raices rs v s continuar) (2 * rs.length + 1 + C) := by
  induction rs generalizing s with
  | nil =>
    intro H
    simp only [raices, respuestas, List.length_cons, List.length_nil, Nat.mul_zero, Nat.zero_add]
    have h := hc (H (clave (.absorber s (.final v)))) H
    omega
  | cons r rs ih =>
    intro H
    simp only [raices, respuestas, List.length_cons]
    have h := ih (H (clave (.extension (H (clave (.absorber s (.raizFRI r))))))) H
    omega

theorem costo_fase (b : Bool) (rs : List Digest) (v : Fp2) (s : Digest) (C : ℕ)
    (continuar : Digest → Programa) (hc : ∀ d, Acotado (continuar d) C) :
    Acotado (fase b rs v s continuar) (2 * rs.length + 2 + C) := by
  intro H
  simp only [fase, respuestas, List.length_cons]
  have h := costo_raices rs v
    (H (clave (.absorber s (if b then .faseTraza else .faseComposicion)))) C continuar hc H
  omega

theorem costo_selector (M : ℕ) (hM : 0 < M) (R C : ℕ) (s : Digest)
    (S : Finset (Fin M)) (continuar : Finset (Fin M) → Programa)
    (hc : ∀ T, Acotado (continuar T) C) :
    Acotado (seleccionar M hM R s S continuar) (R + C) := by
  induction R generalizing s S with
  | zero =>
    intro H
    simp only [seleccionar]
    split_ifs with hs
    · simpa only [Nat.zero_add] using hc S H
    · simp [respuestas]
  | succ R ih =>
    intro H
    simp only [seleccionar]
    split_ifs with hs
    · exact (hc S H).trans (by omega)
    · simp only [respuestas, List.length_cons]
      have h := ih (H (clave (.indice s))) (insert (indice M hM (H (clave (.indice s)))) S) H
      omega

theorem continuacion_selector_cuarenta (M : ℕ) (hM : 0 < M) (R : ℕ) (s : Digest)
    (S : Finset (Fin M)) (hS : S.card = 40) (continuar : Finset (Fin M) → Programa) :
    seleccionar M hM R s S continuar = continuar S := by
  cases R <;> simp [seleccionar, hS]

/-- La cuenta incluye rechazos de trabajo y cualquier secuencia de duplicados. -/
theorem presupuesto_canal (k bits R C : ℕ) (inicio salida : Fp) (raiz : Digest)
    (traza composicion : List Digest) (vt vc : Fp2) (nonce : Nonce)
    (trabajo : Digest → Bool) (continuar : Finset (Fin (4 * 2 ^ k)) → Programa)
    (hc : ∀ S, Acotado (continuar S) C) :
    Acotado (ejecutar k bits R inicio salida raiz traza composicion vt vc nonce trabajo continuar)
      (13 + 2 * (traza.length + composicion.length) + R + C) := by
  let ultimas : Digest → Programa := fun s6 => .consultar (.trabajo s6 nonce) (fun d =>
    if trabajo d then .consultar (.absorber s6 (.nonce nonce))
      (fun s7 => seleccionar (4 * 2 ^ k) (by positivity) R s7 ∅ continuar)
    else .terminar false)
  have hfin (s6 : Digest) : Acotado (ultimas s6) (2 + R + C) := by
    intro G
    simp only [ultimas, respuestas, List.length_cons]
    split_ifs with ht
    · simp only [respuestas, List.length_cons]
      have hs := costo_selector (4 * 2 ^ k) (by positivity) R C
        (G (clave (.absorber s6 (.nonce nonce)))) ∅ continuar hc G
      omega
    · simp only [respuestas, List.length_nil]
      omega
  let cont2 : Digest → Programa := fun s5 => fase false composicion vc s5 ultimas
  have h2 (s5 : Digest) : Acotado (cont2 s5) (2 * composicion.length + 2 + (2 + R + C)) :=
    costo_fase false composicion vc s5 _ ultimas hfin
  let cont1 : Digest → Programa := fun s4 => fase true traza vt s4 cont2
  have h1 (s4 : Digest) : Acotado (cont1 s4)
      (2 * traza.length + 2 + (2 * composicion.length + 2 + (2 + R + C))) :=
    costo_fase true traza vt s4 _ cont2 h2
  intro H
  let s0 := H (clave .inicio)
  let s1 := H (clave (.absorber s0 (.perfil (perfil k bits))))
  let s2 := H (clave (.absorber s1 (.enunciado (enunciado inicio salida k))))
  let s3 := H (clave (.absorber s2 (.raizTraza raiz)))
  have h := costo_retos 3 _ s3 cont1 h1 H
  change (respuestas H (retos 3 s3 cont1)).length + 1 + 1 + 1 + 1 ≤ _
  omega

theorem presupuesto_perfil (k bits R C : ℕ) (inicio salida : Fp) (raiz : Digest)
    (traza composicion : List Digest) (ht : traza.length = k) (hcapa : composicion.length = k + 1)
    (vt vc : Fp2) (nonce : Nonce) (trabajo : Digest → Bool)
    (continuar : Finset (Fin (4 * 2 ^ k)) → Programa) (hc : ∀ S, Acotado (continuar S) C) :
    Acotado (ejecutar k bits R inicio salida raiz traza composicion vt vc nonce trabajo continuar)
      (Nexus.ROM.Presupuestos.canalPerfil k R + C) := by
  have h := presupuesto_canal k bits R C inicio salida raiz traza composicion vt vc nonce trabajo continuar hc
  simpa only [ht, hcapa, Nexus.ROM.Presupuestos.canalPerfil] using h

end Nexus.Canal.ProgramaTG2
