# Decisión 002 — Registro auditable de eventos de rotación (Key Registry)

**Estado:** borrador de diseño para discutir con el director (sin código).
**Fecha:** 2026-08-07 · **Actividad:** 3.2 (Objetivo 3) · **Antecedente:** `BITACORA_TG2.md`, Decisión 002.

---

## 1. Qué exige la actividad y qué existe hoy

La Actividad 3.2 pide un **registro inmutable de eventos de rotación** para impedir la reutilización o el repudio de claves de épocas anteriores. Hoy:

- `entropy.rs` ya produce el insumo: `rotate()` devuelve un `RotationResult` (época saliente/entrante, razón — `SourceUnhealthy`, `LowEntropy`, `MaxUsesReached`, `AgeExpired`, `Manual` —, timestamp) y `seed_hash()` da un **identificador** de la semilla vigente (un hash; nunca el material).
- **No existe ningún Key Registry en el código** (verificado 2026-08-07: solo hay `ValidatorRegistry` en `nexus-anchor`, que registra validadores y stake, no claves). La decisión define ese componente desde cero.

## 2. Requisitos

1. **Inmutabilidad verificable:** nadie (ni el propio nodo) puede reescribir la historia de rotaciones sin ser detectado.
2. **Baja latencia en L2:** registrar una rotación no puede costar más que la rotación misma (µs); la ruta de firma no se bloquea.
3. **Consulta eficiente:** "¿qué época estaba vigente para la dirección A en el tiempo t?" — el sequencer debe poder **rechazar firmas de épocas revocadas** en O(1)/O(log n).
4. **Cero filtración:** el registro contiene identificadores (hashes) y metadatos; jamás semillas ni claves secretas.

## 3. Propuesta: log encadenado en L2 + anclaje Merkle en L1

**Estructura del evento** (~150 B serializado, bincode):

```text
RotationRecord {
    prev_record_hash: Hash256,   // encadenamiento: hash del registro anterior
    address:          Address,   // identidad que rota
    old_epoch:        u64,
    new_epoch:        u64,
    old_seed_hash:    Hash256,   // identificador de la época que muere
    new_seed_hash:    Hash256,   // identificador de la época que nace
    reason:           RotationReason,
    timestamp:        Timestamp,
    node_signature:   —          // firma D3 del nodo sobre el registro (no repudio)
}
```

**Tres niveles de garantía, de menor a mayor costo:**

| Nivel | Mecanismo | Qué garantiza | Costo |
|---|---|---|---|
| 1. Cadena local | Cada registro incluye el hash del anterior (hash-chain) | Integridad interna: no se puede insertar/borrar sin romper la cadena | 1 hash SHA3 por evento (~µs) |
| 2. Estado L2 | El log vive en el estado del sequencer; su raíz Merkle entra al *state root* de cada lote | Los validadores de la L2 auditan el log como parte del estado | ya pagado por el pipeline existente |
| 3. Anclaje L1 | La raíz Merkle del log viaja en el asentamiento periódico al Anchor (mismo vehículo que las raíces pre/post del `PqValidityProof`) | Inmutabilidad de largo plazo e independiente de la L2 | 32 B por lote asentado |

**Regla de validación en el sequencer:** una transacción firmada bajo la época *e* de la dirección *A* solo es válida si *e* es la época vigente de *A* según el registro (rechazo de claves viejas ⇒ anti-reutilización; la firma del nodo en cada registro ⇒ no repudio de la rotación).

## 4. Alternativas consideradas

- **(a) Escribir cada rotación directamente en L1:** máxima inmutabilidad, pero latencia y costo por evento inaceptables para rotaciones frecuentes (la política KeyGen-por-firma de C1 puede rotar épocas a ritmo alto). Descartada como mecanismo primario.
- **(b) Log local (base de datos del nodo) sin anclaje:** rápido pero repudiable — un nodo comprometido reescribe su historia. Insuficiente para el requisito 1.
- **(c) Híbrido L2 + anclaje L1 (propuesto):** hereda la baja latencia de (b) y la inmutabilidad de (a) amortizada por lote; es además coherente con el patrón ya usado por el puente de pruebas (raíces en el asentamiento).

## 5. Puntos a decidir con el director

1. **Residencia del módulo:** `nexus-core` (junto a `merkle.rs`, propuesta) vs. `nexus-active` (junto al sequencer).
2. **Cadencia de anclaje** de la raíz en L1: por lote asentado (propuesta) vs. por intervalo de tiempo.
3. **Granularidad:** ¿se registran también las rotaciones efímeras de C1 (una por firma) o solo las rotaciones de época del Sentinel-Seed? *Propuesta: solo épocas; las efímeras quedan cubiertas por el determinismo semilla→clave.*
4. **Retención y poda** del log en la L2 una vez anclado (¿checkpoint + poda, o historia completa?).

## 6. Estimación de esfuerzo

Estructura + cadena local + tests: ~1 sesión. Integración con el state root de la L2: ~1–2 sesiones (toca `nexus-active`). Anclaje L1: reutiliza el asentamiento existente (~1 sesión). Total: **una semana de trabajo efectivo**, compatible con la fase F1 del plan.
