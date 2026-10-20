module

public import Nexus.Verificador.Certificado
import Mathlib.Tactic

/-!
# Controles del certificado antes del hash

El perfil permitido contiene 2^k filas con 4≤k≤12, las dos cantidades de
capas y cuarenta consultas. Todos los caminos se validan antes del canal.
Los valores ya pertenecen a Fp/Fp2: la canonicidad de bytes corresponde al
lector anterior. El perfil de trabajo se recibe explícitamente (12 o 20).
-/

public section
namespace Nexus.Verificador

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.Goldilocks.Recorrido

@[expose] def FormaCapas (k m : ℕ) (ds : List Apertura) : Prop :=
  ds.length = m ∧ ∀ d j, (d, j) ∈ ds.zipIdx →
    d.pruebaIzquierda.length = k + 3 - j ∧ d.pruebaDerecha.length = k + 3 - j

@[expose] def FormaConsulta (k : ℕ) (q : Consulta) : Prop :=
  q.traza.length = 6 ∧ (∀ p ∈ q.traza, p.hermanos.length = k + 3) ∧
    FormaCapas k k q.friTraza ∧ FormaCapas k (k + 1) q.friComposicion

@[expose] def Forma (k bits : ℕ) (c : Certificado) : Prop :=
  (4 ≤ k ∧ k ≤ 12 ∧ c.enunciado.pasos = 2 ^ k) ∧
  (bits = 12 ∨ bits = 20) ∧ c.prueba.version = 1 ∧ c.prueba.bits = bits ∧
  c.prueba.nonce < 256 ^ 8 ∧ c.prueba.traza.raices.length = k ∧
  c.prueba.composicion.raices.length = k + 1 ∧ c.prueba.consultas.length = 40 ∧
  c.prueba.traza.raices.head? = some c.prueba.raiz ∧
  ∀ q ∈ c.prueba.consultas, FormaConsulta k q

theorem filas_del_perfil (k bits : ℕ) (c : Certificado) (h : Forma k bits c) :
    16 ≤ c.enunciado.pasos ∧ c.enunciado.pasos ≤ 4096 := by
  obtain ⟨⟨hlo, hhi, he⟩, _⟩ := h
  rw [he]
  constructor
  · exact Nat.pow_le_pow_right (by decide : 0 < 2) hlo
  · exact Nat.pow_le_pow_right (by decide : 0 < 2) hhi

theorem forma_implica_cantidades (k bits : ℕ) (c : Certificado) (h : Forma k bits c) :
    c.prueba.traza.raices.length = k ∧ c.prueba.composicion.raices.length = k + 1 ∧
      c.prueba.consultas.length = 40 := ⟨h.2.2.2.2.2.1, h.2.2.2.2.2.2.1, h.2.2.2.2.2.2.2.1⟩

theorem forma_implica_raiz_compartida (k bits : ℕ) (c : Certificado) (h : Forma k bits c) :
    c.prueba.traza.raices.head? = some c.prueba.raiz := h.2.2.2.2.2.2.2.2.1

theorem forma_implica_consultas (k bits : ℕ) (c : Certificado) (h : Forma k bits c)
    (q : Consulta) (hq : q ∈ c.prueba.consultas) : FormaConsulta k q := h.2.2.2.2.2.2.2.2.2 q hq

theorem forma_implica_capas (k : ℕ) (q : Consulta) (h : FormaConsulta k q) :
    q.traza.length = 6 ∧ q.friTraza.length = k ∧ q.friComposicion.length = k + 1 :=
  ⟨h.1, h.2.2.1.1, h.2.2.2.1⟩

end Nexus.Verificador
