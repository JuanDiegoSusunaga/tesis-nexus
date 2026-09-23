# QROM — muestreo y reducción al juego real

**23 de septiembre de 2026.** Continuación del [extractor y los escapes de campo](../Extractor-QROM-2026-09-23/README.md), para el código `01dcde960402b6c60a19242b7ae3d6ac3d82a518`.

El [informe](Muestreo-y-Puente-QROM.md) reconstruye trabajo, nonce e índices sin orden temporal, define las parejas que aceptan los chequeos locales y propone una reducción desde aceptación falsa del verificador real a cuatro eventos. El presupuesto de expansión y la corrección del cambio de juego quedan explícitos.

**Pendiente central:** demostrar `β`, la cota cuántica de omisión o cola de muestreo. La fórmula completa es condicional a ese resultado; los cálculos dejan `β` y la cota final sin valor. Dictamen matemático independiente pendiente.

## Evidencia

- [Cálculos](calculos.json): 72 cuentas de presupuesto y 28 recorridos del corpus.
- [Validación](validacion.json): catorce tests nuevos; **80 Python y 197 Rust**, cargo check/build y manifiesto de 897 archivos.
- [Protección](proteccion.json): TG1 y los cinco complementos matemáticos anteriores; Rust limpio.
- [CMS19, fuente del cambio de juego](../QROM-2026-09-23/bibliografia/CMS19.pdf): definición 4.1 y lema 4.9, páginas PDF 20 y 22 de la copia conservada.

Con corte 512, se conservan ocho aceptaciones y seis rechazos del corpus. Con corte 40, doce recorridos llegan a `cola`: es un resultado auxiliar de la demostración, no aceptación de Rust. El corpus tiene enunciados válidos y no demuestra el límite de probabilidad de falsificación.

## Reproducción

Desde la raíz, con Python 3.11 y su biblioteca estándar:

```powershell
python scripts/analizar_muestreo_qrom_tg2.py --salida .tools/muestreo-qrom-repeticion/calculos.json
python scripts/verificar_muestreo_qrom_tg2.py --salida .tools/muestreo-qrom-repeticion/verificacion
```

Las salidas deben ser nuevas. El registro guarda fuentes y logs, repite toda la regresión anterior y protege los paquetes históricos. Cargo funciona offline con escritura en `C:/tmp/nexus-target` y requiere código limpio.

La repetición de una expansión usa únicamente sus pares registrados; un test impide nuevas llamadas SHA3. Se contrastan también 256 secuencias pequeñas y una asignación artificial de oráculo que provoca cola a 512 pasos. No se ejecuta un adversario cuántico general ni se cambia el protocolo. El manuscrito y el Word mantienen su edición identificada; este suplemento tiene su propio registro de evidencia.
