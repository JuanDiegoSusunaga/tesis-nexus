module

public import Nexus.N06.TranscripcionExplicita
import Mathlib.Tactic

/-!
# Retos sobre la transcripción con datos explícitos

Cada petición contiene la fase y los mensajes ya fijados. Su política
canónica reproduce esos datos; codificar el reto coincide con una petición
del modelo observado. La cota local y la absorción se transportan por esa
igualdad, sin recibirlas como hipótesis adicionales.
-/

public section
namespace Nexus.Goldilocks

open Nexus.N06

structure PeticionExplicita (k q : ℕ) where
  ronda : PeticionCausal k
  mensajes : MensajesExplicitos k q (origenCausal k q ronda)

abbrev RespuestaExplicita (k q : ℕ) (r : PeticionExplicita k q) := RespuestaCausal k q r.ronda

noncomputable instance fintypeRespuestaExplicita (k q : ℕ) (r : PeticionExplicita k q) :
    Fintype (RespuestaExplicita k q r) := inferInstanceAs (Fintype (RespuestaCausal k q r.ronda))

@[expose] def peticionDeDatos (k q : ℕ) (r : PeticionExplicita k q) : PeticionObservada k :=
  ⟨politicaDeDatos k q (origenCausal k q r.ronda) r.mensajes, r.ronda⟩

@[expose] def origenExplicito (k q : ℕ) (r : PeticionExplicita k q) : TranscripcionExplicita k q :=
  ⟨origenCausal k q r.ronda, r.mensajes⟩

@[expose] def destinoExplicito (k q : ℕ) (r : PeticionExplicita k q)
    (x : RespuestaExplicita k q r) : TranscripcionExplicita k q :=
  ⟨destinoCausal k q r.ronda x,
    capturarMensajes k q (peticionDeDatos k q r).politica (destinoCausal k q r.ronda x)⟩

theorem codificar_origen_explicito (k q : ℕ) (r : PeticionExplicita k q) :
    codificarExplicita k q (origenExplicito k q r) = origenObservado k q (peticionDeDatos k q r) := rfl

theorem codificar_destino_explicito (k q : ℕ) (r : PeticionExplicita k q) (x : RespuestaExplicita k q r) :
    codificarExplicita k q (destinoExplicito k q r x) = destinoObservado k q (peticionDeDatos k q r) x :=
  codificar_captura k q (peticionDeDatos k q r).politica (destinoCausal k q r.ronda x)

theorem reto_explicito_absorbente (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (r : PeticionExplicita k q) (x : RespuestaExplicita k q r)
    (h : estadoExplicito k hk0 hk s o q (origenExplicito k q r) = true) :
    estadoExplicito k hk0 hk s o q (destinoExplicito k q r x) = true := by
  rw [estadoExplicito, codificar_origen_explicito] at h
  rw [estadoExplicito, codificar_destino_explicito]
  exact reto_observado_absorbente k hk0 hk s o q (peticionDeDatos k q r) x h

theorem cambio_explicito_coincide (k : ℕ) (hk0 : 0 < k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (r : PeticionExplicita k q) :
    cambioFresco (RespuestaExplicita k q) (origenExplicito k q) (destinoExplicito k q)
      (estadoExplicito k hk0 hk s o q) r =
    cambioFresco (RespuestaObservada k q) (origenObservado k q) (destinoObservado k q)
      (estadoObservado k hk0 hk s o q) (peticionDeDatos k q r) := by
  classical
  unfold cambioFresco
  apply promedio_entre_instancias
  intro x
  simp only [estadoExplicito, codificar_origen_explicito, codificar_destino_explicito]

theorem cambio_explicito_cota (k : ℕ) (hk0 : 4 ≤ k) (hk : k ≤ 29) (s o : Fp)
    (q : ℕ) (hq : q ≤ 4 * 2 ^ k) (r : PeticionExplicita k q) :
    cambioFresco (RespuestaExplicita k q) (origenExplicito k q) (destinoExplicito k q)
      (estadoExplicito k (by omega) hk s o q) r ≤ errorRonda k q := by
  rw [cambio_explicito_coincide]
  exact cambio_observado_universal k hk0 hk s o q hq (peticionDeDatos k q r)

theorem cambio_explicito_perfiles (k : ℕ) (hk0 : 4 ≤ k) (hk1 : k ≤ 12) (s o : Fp)
    (r : PeticionExplicita k 40) :
    cambioFresco (RespuestaExplicita k 40) (origenExplicito k 40) (destinoExplicito k 40)
      (estadoExplicito k (by omega) (by omega) s o 40) r ≤ Nexus.N05.H (4 * 2 ^ k) 40 (1 / 8) := by
  have hc := cambio_explicito_cota k hk0 (by omega) s o 40
    (Nexus.Modelos.Omision.muestras_perfiles k hk0) r
  simpa only [error_ronda_perfiles k hk0 hk1] using hc

theorem respuestas_explicitas_no_vacias (k q : ℕ) (hq : q ≤ (dominioCapa k 1).card)
    (r : PeticionExplicita k q) : Nonempty (RespuestaExplicita k q r) :=
  respuestas_causales_no_vacias k q hq r.ronda

end Nexus.Goldilocks
