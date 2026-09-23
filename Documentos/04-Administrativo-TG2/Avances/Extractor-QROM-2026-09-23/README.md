# QROM — extractor y escapes AIR/FRI

**23 de septiembre de 2026.** Continuación de la [primera etapa QROM](../QROM-2026-09-23/README.md), sobre el código `01dcde960402b6c60a19242b7ae3d6ac3d82a518`.

El [informe matemático](Extractor-y-Escapes-QROM.md) propone un extractor del canal y Merkle que depende solo de una base hash sin orden temporal. Demuestra un lema de estabilidad y lo usa para acotar los escapes de campo en la base comprimida mediante CMS19. **La cota no es todavía la probabilidad de aceptación del verificador**: faltan la cadena de índices/nonces y el paso al juego de salida real. Revisión independiente pendiente.

## Evidencia

- [Cálculos y correspondencia](calculos.json): 45 escenarios, 14 prefijos de certificados, 236 retos y 1.974 aperturas AIR cotejadas.
- [Validación](validacion.json): catorce tests nuevos, **66 Python y 197 Rust** en total, cargo check/build y manifiesto de 897 archivos.
- [Protección](proteccion.json): TG1 y los cuatro paquetes matemáticos anteriores; código Rust limpio.
- [Fuente primaria CMS19 conservada](../QROM-2026-09-23/bibliografia/CMS19.pdf) y [versión/hash](../QROM-2026-09-23/bibliografia/fuentes.json).

Las pruebas incluyen los 18 perfiles, entradas con dos roles, ciclos, regiones incompletas, 2.688 inserciones sin colisiones y controles de sobrescritura y de ambas direcciones de cambio. El corpus aporta contrastes clásicos de la reconstrucción, no observaciones de un adversario cuántico.

## Reproducción

Desde la raíz, con Python 3.11, sin dependencias Python adicionales:

```powershell
python scripts/analizar_extractor_qrom_tg2.py --salida .tools/extractor-qrom-repeticion/calculos.json
python scripts/verificar_extractor_qrom_tg2.py --salida .tools/extractor-qrom-repeticion/verificacion
```

Las salidas deben ser nuevas. El registro repite los tests y cálculos propios y la regresión QROM/ROM anterior, incluido Cargo offline. Requiere código limpio y escritura en `C:/tmp/nexus-target`. Las fuentes ejecutadas y logs quedan en `fuentes/` y `regresion/`; las validaciones enlazadas identifican la evidencia previa.

**Siguiente paso:** Q2, una cota para el muestreo encadenado de 40 índices distintos, con nonces y cola; después Q4, la transferencia a aceptación real. Los detalles y condiciones de cierre están en §9 del informe. El manuscrito y el Word mantienen su edición identificada; este complemento se conserva separado hasta integrar coherentemente las derivaciones revisadas.
