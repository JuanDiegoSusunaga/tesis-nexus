# Compilación global de Lean — 19 de octubre de 2026

Autorizada expresamente por el autor después de las compilaciones aisladas.

- Compilación global: `python scripts/lean.py build`, salida 0; `Nexus.lean` y sus 347 módulos pasan. Lake informa 4084 trabajos, incluidas dependencias y artefactos reutilizados.
- Auditoría global: `python scripts/lean.py lean -M 4096 -DautoImplicit=false -DwarningAsError=true Auditoria.lean`, salida 0; 2709 declaraciones, exactamente las solicitadas por `#print axioms`, sin duplicados ni omisiones.
- Solo aparecen `propext`, `Classical.choice` y `Quot.sound`; no aparece `sorryAx`. La pasada final no produjo errores ni advertencias.
- Es una compilación incremental global: no se borró la caché ni se recompiló mathlib desde cero. No se repitió el replay global separado con `leanchecker`.

La configuración mantiene `autoImplicit=false` y `warningAsError=true`. Para cumplirla se explicitaron dos parámetros `m`, se retiraron parámetros de contexto y reglas de simplificación sobrantes, se actualizaron dos nombres obsoletos y se elevó localmente el límite de evaluación de exponentes para `2^300`. No se desactivaron los controles ni se añadieron axiomas o pruebas admitidas.

Se conservan los registros de los intentos fallidos anteriores a los ajustes. [build.log](build.log) corresponde a la pasada final correcta y [axiomas.log](axiomas.log) contiene la salida íntegra de la auditoría. [verificacion.json](verificacion.json) registra hashes de las fuentes y los registros.

El resultado acredita compilación e integración de la formalización actual. No prueba el refinamiento universal Rust/serde/bincode, seguridad de SHA3 determinista fuera del ROM ni QROM, y no equivale a un dictamen de la tesis.
