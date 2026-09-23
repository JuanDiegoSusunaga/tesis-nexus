# QROM — primera etapa, 23 de septiembre de 2026

**Resultado:** [derivación parcial para el trabajo del nonce y obstáculos de compilación](Primer-Paso-QROM.md). Para TG2 v1, en QROM y con una prueba clásica final, se propone `Pr[falso y acepta] ≤ min(1,(2(Q+C_T)+1)²/2^g)`, donde `C_T=13+4log2(T)`.

La cota usa solamente una condición necesaria de aceptación. Es débil: en `T=4096,g=20` llega a uno desde `Q=451`. La transferencia cuántica que incorpore AIR/FRI continúa pendiente. El informe localiza los obstáculos de base de datos, muestreo encadenado y búsqueda de nonces, con tareas Q1–Q5. Revisión independiente pendiente; no acredita 100 bits ni seguridad incondicional de SHA3.

## Archivos

- [Informe matemático](Primer-Paso-QROM.md): modelo, reducción, cifras, correspondencia con fuentes y siguiente etapa.
- [Cálculos](calculos.json): 108 perfiles de trabajo, 12 experimentos de búsqueda y nueve contrastes de muestreo.
- [Bibliografía](bibliografia/fuentes.json): CMS19, versión de enero de 2020, y DFM20, arXiv v3 de marzo de 2022; PDF completos, texto por página y hashes.
- [Validación](validacion.json): 12 tests nuevos; total **52 Python y 197 Rust**, cargo check/build y manifiesto de 897 archivos.
- [Protección](proteccion.json): TG1 y los tres complementos matemáticos anteriores; código Rust limpio.

Las comprobaciones incluyen 14 prefijos reales del canal, 256 tablas de un oráculo pequeño con tres cantidades de iteraciones y contrastes de medición y orden temporal. Son experimentos finitos ejecutados clásicamente; no certifican por sí solos la demostración ni constituyen ataques al protocolo.

## Repetir sin sustituir esta evidencia

Desde la raíz del repositorio, con Python 3.11 y la revisión Rust identificada:

```powershell
python scripts/analizar_qrom_tg2.py --salida .tools/qrom-repeticion/calculos.json
python scripts/verificar_qrom_tg2.py --salida .tools/qrom-repeticion/verificacion
```

Las salidas deben ser nuevas. El registro comprueba las pruebas propias y ejecuta la regresión ROM completa, incluido Cargo offline con `CARGO_TARGET_DIR=C:/tmp/nexus-target`. Ese directorio necesita permiso de escritura. Las pruebas y cálculos usan la biblioteca estándar de Python; las fuentes ejecutadas se copian dentro del registro, cuyas validaciones enlazadas conservan los hashes de la regresión.

Para recopilar de nuevo los PDF en otra carpeta, se necesita red y PyMuPDF. En esta ejecución se creó un entorno aislado porque el Python global no incluía ese módulo:

```powershell
python -m venv .tools/qrom-venv
.tools/qrom-venv/Scripts/python.exe -m pip install PyMuPDF==1.28.2
.tools/qrom-venv/Scripts/python.exe scripts/recopilar_fuentes_qrom_tg2.py --salida .tools/qrom-repeticion/bibliografia
```

El colector conserva versión de portada y SHA-256. Una descarga posterior puede diferir si la URL editorial cambia; para reproducir las fuentes examinadas se consultan los PDF archivados. La versión arXiv está fijada explícitamente a v3. Los documentos históricos, el manuscrito y el Word de derivaciones conservan su edición identificada; este suplemento tiene su validación propia.
