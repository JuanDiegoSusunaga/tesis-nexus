# QROM — cota de la cola de índices

**23 de septiembre de 2026.** Complemento del [muestreo y reducción condicional](../Muestreo-QROM-2026-09-23/README.md), para el código `01dcde960402b6c60a19242b7ae3d6ac3d82a518`.

El [informe](Cola-y-Conteo-QROM.md) propone una cota cuántica para alcanzar R extracciones sin reunir 40 índices distintos. Usa ausencia de ciclos en una cadena anclada, un contador de respuestas marcadas y una recurrencia de amplitudes. La demostración requiere dictamen independiente.

**La omisión de parejas incorrectas sigue sin una cota útil.** El resultado solo controla la cola, es trivial con R=512 en los perfiles tabulados y mejora al usar cortes mayores del análisis en algunos perfiles. Esos cortes no modifican Rust. Los exponentes publicados no son niveles de seguridad del protocolo.

## Evidencia

- [Cálculos](calculos.json): 144 perfiles, 16 con cota de cola menor que uno.
- [Validación](validacion.json): 16 tests nuevos; **96 Python y 197 Rust**, cargo check/build y manifiesto de 897 archivos.
- [Protección](proteccion.json): TG1 y los seis complementos anteriores.
- [Fuente CFHL21 v4](bibliografia/CFHL21-v4.pdf), [texto](bibliografia/CFHL21-v4.txt) e [identificación](bibliografia/fuentes.json): matriz de transición, lema 4.3 y figura 1, PDF 11–12.

## Reproducción

Con Python 3.11 y biblioteca estándar, desde la raíz:

```powershell
python scripts/analizar_cola_qrom_tg2.py --salida .tools/cola-qrom-repeticion/calculos.json
python scripts/verificar_cola_qrom_tg2.py --salida .tools/cola-qrom-repeticion/verificacion
```

Usar salidas nuevas. La regresión requiere código Rust limpio y escritura en `C:/tmp/nexus-target`; Cargo funciona offline. El registro conserva fuentes, logs y hashes y repite los controles anteriores.

Para recopilar otra copia identificada de la fuente primaria, solo el colector requiere red y el entorno con PyMuPDF 1.28.2 ya usado en la etapa QROM:

```powershell
.tools/qrom-venv/Scripts/python.exe scripts/recopilar_fuentes_cola_qrom_tg2.py --salida .tools/cola-qrom-repeticion/bibliografia
```

La expansión software del suplemento anterior conserva su límite R≤512. Los cortes mayores de este informe se estudian mediante el argumento y la cuenta de llamadas; no se presentan como ejecuciones del verificador completo con colas tan largas. El nuevo control recorre una asignación artificial de 1.024 pasos para comprobar la inclusión estructural. Manuscrito y Word conservan su edición identificada.
