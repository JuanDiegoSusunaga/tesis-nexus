# Herramientas y reproducción de TG2

Ejecutar desde la raíz del repositorio. Los scripts resuelven las rutas del proyecto a partir de su ubicación. Desde la edición unificada del 29 de octubre, el código Rust ya está incluido en `nexus/`, junto con la tesis y Lean; basta clonar `tesis-nexus` una vez. Consultar la [entrada para el director](../README.md).

## Formalización Lean y costo de reproducción

Se versionan `lean.py`, `verificar_formalizacion.py`, `inventariar_matematica.py`, `verificar_revision_manuscrito.py` y sus tres archivos de pruebas. Las fuentes, configuración y revisiones fijadas están en [`formalizacion/`](../formalizacion/README.md); las dependencias y cachés no se incluyen.

La [global Lean del 20 de octubre](../Documentos/06-Evidencia-TG2/2026-10-20/Lean-Global/verificacion.json) ya comprobó 2709 declaraciones. La [consolidación Git](../Documentos/06-Evidencia-TG2/2026-10-20/Consolidacion-Lean/preparacion.json) solo coteja hashes, importaciones locales y sintaxis Python, sin ejecutar Lean/Rust ni repetir pruebas. No añade módulos ni obligaciones matemáticas.

`python scripts/lean.py preparar` instala herramientas locales, descarga dependencias y compila; `python scripts/lean.py build` compila. `python scripts/verificar_formalizacion.py` también ejecuta Lean y la auditoría, y puede realizar verificaciones separadas del núcleo. **No son comprobaciones gratuitas de integridad:** requieren autorización del autor. Los inventarios y revisiones pueden escribir informes; no regenerarlos sobre los registros cerrados. Para comprobar solamente la integridad documental usar el verificador del manifiesto indicado abajo, que no compila.

## Catálogo de afirmaciones

```powershell
python scripts/verificar_catalogo_validacion.py
```

Comprueba doce afirmaciones, dependencias sin ciclos, localizadores y hashes de nueve archivos de evidencia del [catálogo de validación](../Documentos/04-Administrativo-TG2/Avances/Catalogo-Validacion-2026-10-12/README.md). Solo requiere Python y no escribe archivos ni accede a la red. `--catalogo` permite comprobar otra copia del JSON. Un resultado correcto acredita integridad documental; la verdad matemática, la mecanización y el dictamen tienen estados independientes.

## 1. Consultar la versión conservada

```powershell
python scripts/verificar_version_tg2.py
```

Este comando verifica los hashes del manuscrito, las fuentes Rust/Lean conservadas y los resultados incluidos en el [manifiesto](../Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json). El esquema 2 comprueba el código integrado sin exigir un segundo repositorio Git; el esquema 1 conserva la comprobación del commit y estado del repositorio Rust independiente para ediciones anteriores. No ejecuta benchmarks ni modifica los documentos. Solo necesita Python y Git.

## 2. Preparar el entorno documental

Entorno usado: Windows, Python 3.11.9, Pandoc 3.10.1, Microsoft Word instalado y Chrome o Edge. Word actualiza su índice mediante COM; el PDF se genera con el navegador. Instalar las fuentes Times New Roman y Cambria Math para conservar la composición tipográfica.

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe scripts/verificar_entorno.py
```

`requirements.txt` fija las versiones Python observadas, incluidas las dependencias transitivas. La instalación necesita acceso al índice de paquetes. No se incorpora código de bibliotecas al repositorio. La instalación previa de PyMuPDF en `.tools/pdf` es compatible con los scripts existentes; un clon nuevo lo obtiene en `.venv`.

## 3. Regenerar el manuscrito

Guardar primero una revisión Git. Los comandos sustituyen las salidas de trabajo; usar una nueva fecha para los informes de revisión. Las fuentes son los nueve archivos de `Documentos/01-Manuscrito/Capitulos/`.

```powershell
$env:NEXUS_TG2_FECHA_EVIDENCIA = Get-Date -Format 'yyyy-MM-dd'
.\.venv\Scripts\python.exe scripts/generar_figuras_manuscrito.py
.\.venv\Scripts\python.exe scripts/compilar_manuscrito.py
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/exportar_manuscrito_word.ps1
.\.venv\Scripts\python.exe scripts/exportar_manuscrito_pdf.py
.\.venv\Scripts\python.exe scripts/revisar_manuscrito.py
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/renderizar_manuscrito_word.ps1
.\.venv\Scripts\python.exe scripts/revisar_graficas_manuscrito.py
```

Si ya existe evidencia de esa fecha, regenerar en una copia separada. La inspección visual de las láminas completa la comprobación automática; los archivos JSON no sustituyen esa lectura. Diferencias de Word, navegador o fuentes pueden cambiar la paginación. Los hashes identifican los archivos conservados y no prometen exportaciones binarias idénticas.

## 4. Verificar el código

Herramientas observadas: Rust y Cargo 1.97.1, con las dependencias fijadas en `nexus/Cargo.lock`. En Windows se necesita el entorno de compilación MSVC. La primera descarga se hace con `cargo fetch --locked --manifest-path nexus/Cargo.toml`; después puede usarse `--offline`.

```powershell
$env:CARGO_TARGET_DIR = 'C:\tmp\nexus-target'
$env:RUST_TEST_THREADS = '4'
cargo check --workspace --all-targets --locked --offline --jobs 4 --manifest-path nexus/Cargo.toml
cargo test --workspace --locked --offline --jobs 4 --manifest-path nexus/Cargo.toml
cargo build --workspace --locked --offline --jobs 4 --manifest-path nexus/Cargo.toml
```

Estos comandos requieren autorización; no se ejecutan al versionar Lean. La última [global del 20 de octubre](../Documentos/06-Evidencia-TG2/2026-10-20/Rust-Global-Final/verificacion.json) pasa check, 223 pruebas y build sobre `637e77c`, conservando advertencias. Las 197 pruebas en desarrollo del 23 de septiembre y las diez release de FRI vinculada del día 22 son antecedentes. Los informes conservan el conteo y los comandos de cada etapa; no se suman entre ejecuciones.

## 5. Elegir los scripts de investigación

| Familia | Función | Registro relacionado |
|---|---|---|
| `analizar_correspondencia_r1.py`, `recopilar_fuentes_r1.py` | Contrastar perfil, reducciones y fuentes | R1-correspondencia |
| `registrar_evidencia_r2.py`, `registrar_evidencia_r3.py` | Conservar logs y fuentes previamente ejecutados | R2-monitor, R3-rotacion |
| `ejecutar_mediciones_r4.py`, `ejecutar_complemento_r4.py` | Ejecutar las series de benchmarks | R4-validacion, R4-complemento |
| `resumir_mediciones_r4.py`, `resumir_complemento_r4.py` | Resumir las series conservadas | R4-validacion, R4-complemento |
| `analizar_*_r4.py`, `auditar_merkle_fs_r4.py` | Contrastes algebraicos, corpus y auditoría Merkle/FS | Etapas R4 correspondientes |
| `modelar_residencia_r5.py` | Calcular escenarios de residencia declarados | R5-residencia |
| `inventario_tg2.py`, `registrar_evidencia_r4.py` | Capturar caché, fuentes y logs locales | Inventario inicial y R4 |

Estos scripts históricos escriben en rutas fechadas fijas y algunos requieren archivos de `.tools/` o la caché de Criterion. No ejecutarlos sobre la única copia de la evidencia. Para repetir un experimento, crear otra copia de ambos repositorios en sus commits identificados, consultar el informe de la etapa y conservar los nuevos resultados por separado. Las fuentes y los comandos originales están en el [índice de evidencia](../Documentos/06-Evidencia-TG2/README.md).

## 6. Registrar una nueva edición

En la edición unificada, incorporar primero al índice los archivos que integrarán la versión con `git add` sobre las rutas elegidas. Ejecutar `python scripts/registrar_version_tg2.py`, revisar el manifiesto generado y `python scripts/verificar_version_tg2.py`; añadir después el manifiesto y crear el commit. El registrador conserva los metadatos de procedencia y actualiza las huellas de los archivos incluidos en el índice. El commit que contiene el manifiesto identifica la edición completa sin introducir una referencia circular a su propio hash. El commit Rust de origen identifica la importación histórica; los hashes identifican las fuentes integradas vigentes.

Para una edición histórica de esquema 1 con Rust independiente, registrar primero el commit del código y después el documental. Ese flujo se mantiene para reproducir versiones anteriores.

## 7. Documento independiente de derivaciones

La fuente `Documentos/04-Administrativo-TG2/Avances/Derivaciones-Matematicas-TG2-2026-09-23.md` reúne S1–S3 y el contraejemplo de proximidad. Para compilar el Word y actualizar su índice:

```powershell
python scripts/generar_derivaciones_docx.py
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/actualizar_derivaciones_word.ps1
```

El generador verifica contenido de tablas y cantidad de ecuaciones nativas antes de publicar el documento. Sus temporales quedan en `.tools/derivaciones/`. Este proceso solo genera el documento independiente; la fuente y las salidas del manuscrito principal conservan su edición. La inspección visual y los hashes de la copia revisada se registran en el archivo `.revision.json` junto al Word.

## 8. Investigación de solidez por rondas

La [derivación conjunta AIR/FRI](../Documentos/04-Administrativo-TG2/Avances/Cierre-Matematico-2026-09-23/README.md) se desarrolló en `investigacion/cierre-matematico-tg2` y se integró en `main` el 23 de septiembre. Los cálculos usan exclusivamente la biblioteca estándar de Python:

```powershell
python -m unittest discover -s scripts/tests -p test_rbr_conjunto_tg2.py -v
python scripts/analizar_rbr_conjunto_tg2.py --salida .tools/cierre-matematico/repeticion.json
python scripts/verificar_rbr_conjunto_tg2.py --salida .tools/cierre-matematico/verificacion
```

El último comando conserva logs de las siete pruebas matemáticas, diez pruebas del manifiesto, la verificación histórica y cargo check/test/build, junto con hashes y revisión Git. Requiere Rust y las dependencias locales; usa `C:/tmp/nexus-target`. Las salidas rechazan sobrescrituras. Los contrastes finitos no sustituyen revisión matemática ni prueban seguridad del ejecutable. El manifiesto excluye los archivos temporales de propietario de Word que empiezan por `~$` y tienen extensión de Word, de modo que abrir un documento no se confunde con modificar la edición.

## 9. Transferencia clásica ROM al protocolo TG2 v1

El [informe de transferencia](../Documentos/04-Administrativo-TG2/Avances/Transferencia-ROM-2026-09-23/README.md) modela SHA3 como un único oráculo aleatorio y explicita el presupuesto adversario, el sesgo de campo, Merkle, el canal y los nonces. La derivación está propuesta para revisión independiente; no establece seguridad QROM ni 100 bits.

```powershell
python -m unittest discover -s scripts/tests -p test_transferencia_rom_tg2.py -v
python scripts/analizar_transferencia_rom_tg2.py --salida .tools/transferencia-rom/repeticion.json
python scripts/verificar_transferencia_rom_tg2.py --salida .tools/transferencia-rom/verificacion
```

La comprobación completa usa la biblioteca estándar de Python y Cargo con las dependencias locales. Ejecuta 28 pruebas Python, 197 Rust, check/build y el manifiesto de 897 archivos; conserva fuentes exactas, logs y hashes. El código debe estar limpio. La salida rechaza sobrescrituras: usar una carpeta nueva para cada repetición. Cargo escribe en `C:/tmp/nexus-target`, que debe ser accesible.

`verificar_certificados_tg2.py` comprueba los 14 certificados preservados con aritmética Python y `hashlib`: formato admitido, transcripción, aperturas Merkle, composición AIR y ambos FRI. Su límite de 512 extracciones protege la herramienta; el Rust v1 no tiene ese corte y la demostración contabiliza su cola. Es una referencia para el corpus, no un decodificador de producción endurecido.

## 10. Revisión crítica interna de ROM

La [ampliación de la demostración](../Documentos/04-Administrativo-TG2/Avances/Revision-Critica-ROM-2026-09-23/README.md) usa potencial para decisiones adaptativas y comprueba premisas de extracción/canal.

```powershell
python -m unittest discover -s scripts/tests -p test_revision_rom_tg2.py -v
python scripts/analizar_revision_rom_tg2.py --salida .tools/revision-rom/repeticion.json
python scripts/verificar_revision_rom_tg2.py --salida .tools/revision-rom/verificacion
```

El analizador calcula 96 escenarios de Bellman con fracciones exactas. El registro ejecuta doce tests nuevos y la regresión anterior: **40 Python, 197 Rust, check/build y manifiesto de 897 archivos**. Sus fuentes, cálculos reproducidos y hashes se guardan junto con `regresion/`. Protege TG1 y los dos paquetes matemáticos anteriores. Requiere salida nueva, código limpio y escritura de Cargo en `C:/tmp/nexus-target`. Es revisión interna; no sustituye dictamen externo ni reducción QROM.

## 11. Primera etapa QROM

El [informe QROM](../Documentos/04-Administrativo-TG2/Avances/QROM-2026-09-23/README.md) deriva una cota parcial de trabajo mediante DFM20 y documenta las obligaciones pendientes para incorporar AIR/FRI.

```powershell
python scripts/analizar_qrom_tg2.py --salida .tools/qrom-repeticion/calculos.json
python scripts/verificar_qrom_tg2.py --salida .tools/qrom-repeticion/verificacion
```

Se calculan 108 perfiles, doce búsquedas cuánticas pequeñas y nueve contrastes del muestreo. Los doce tests nuevos comprueban, entre otros, 14 prefijos del corpus y 256 tablas de un oráculo XOR. La regresión reúne **52 Python, 197 Rust, check/build y manifiesto de 897 archivos**. Se preservan TG1 y los tres paquetes matemáticos anteriores. Las salidas son exclusivas y Cargo requiere escritura en `C:/tmp/nexus-target`.

`recopilar_fuentes_qrom_tg2.py` descarga CMS19 y DFM20 y conserva texto por página, versión y hashes. Solo ese colector requiere red y PyMuPDF 1.28.2; el README del informe documenta el entorno aislado empleado. La cota parcial es débil, no se interpreta como ataque y no completa QROM de AIR/FRI.

## 12. Extractor QROM y escapes de campo

El [suplemento del extractor](../Documentos/04-Administrativo-TG2/Avances/Extractor-QROM-2026-09-23/README.md) define la extracción del prefijo y Merkle desde una base sin orden, prueba estabilidad y acota escapes algebraicos en la base comprimida. La cota no es todavía la probabilidad de aceptación del verificador.

```powershell
python scripts/analizar_extractor_qrom_tg2.py --salida .tools/extractor-qrom-repeticion/calculos.json
python scripts/verificar_extractor_qrom_tg2.py --salida .tools/extractor-qrom-repeticion/verificacion
```

Solo usa la biblioteca estándar de Python. El extractor no consulta SHA3; el auditor instrumenta el corpus clásico para contrastarlo. Registra 45 escenarios, 14 certificados, 236 retos y 1.974 aperturas AIR. Los catorce tests incluyen 2.688 inserciones, ambas direcciones de una propiedad artificial y el control de sobrescritura. La regresión reúne **66 Python, 197 Rust, check/build y manifiesto de 897 archivos**, y protege TG1 y los cuatro complementos anteriores. Las salidas deben ser nuevas y Cargo requiere escritura en `C:/tmp/nexus-target`.

## 13. Muestreo QROM y reducción condicional al verificador

El [informe de muestreo](../Documentos/04-Administrativo-TG2/Avances/Muestreo-QROM-2026-09-23/README.md) extiende la extracción al nonce y los índices, calcula el conjunto local G y construye una expansión de longitud fija repetible sin acceso al oráculo. Formula una reducción propuesta que depende de una cota β aún sin demostrar.

```powershell
python scripts/analizar_muestreo_qrom_tg2.py --salida .tools/muestreo-qrom-repeticion/calculos.json
python scripts/verificar_muestreo_qrom_tg2.py --salida .tools/muestreo-qrom-repeticion/verificacion
```

Solo usa la biblioteca estándar de Python. Se registran 72 presupuestos y 28 recorridos con cortes de 40 y 512; catorce tests nuevos incluyen 256 secuencias pequeñas, repetición con SHA3 bloqueado y una cola bajo un oráculo artificial. La regresión reúne **80 Python, 197 Rust, check/build y manifiesto de 897 archivos**. Protege TG1 y los cinco paquetes matemáticos anteriores. Las salidas deben ser nuevas y Cargo requiere escritura en `C:/tmp/nexus-target`.

El corte pertenece al experimento auxiliar del análisis y no modifica Rust. Los cálculos dejan β y la cota completa en `null`; el calculador condicional requiere una cota externa demostrada y no la certifica. La herramienta no decide si un enunciado es falso ni reproduce al adversario cuántico general.

## 14. Cota cuántica de la cola de índices

El [informe de cola](../Documentos/04-Administrativo-TG2/Avances/Cola-QROM-2026-09-23/README.md) propone una cota mediante contador de respuestas, capacidad local y escalera de amplitudes. La omisión permanece abierta.

```powershell
python scripts/analizar_cola_qrom_tg2.py --salida .tools/cola-qrom-repeticion/calculos.json
python scripts/verificar_cola_qrom_tg2.py --salida .tools/cola-qrom-repeticion/verificacion
```

Se calculan 144 perfiles, 16 no triviales, mediante enteros y redondeos superiores. Dieciséis tests nuevos contrastan 1.792 bloques, 20 matrices unitarias y las hipótesis del conteo. La regresión reúne **96 Python, 197 Rust, check/build y manifiesto de 897 archivos**; protege TG1 y los seis paquetes matemáticos anteriores. Las salidas deben ser nuevas y Cargo requiere escritura en `C:/tmp/nexus-target`.

El análisis y las pruebas usan la biblioteca estándar. Solo `recopilar_fuentes_cola_qrom_tg2.py` requiere red y PyMuPDF 1.28.2 en el entorno aislado; conserva CFHL21 v4 con versión y hashes. Los cortes mayores que 512 son una extensión matemática del análisis, no ejecuciones nuevas del expansor completo. Se contrasta una cadena artificial registrada de 1.024 pasos. La demostración requiere revisión; las cotas de cola no son tasas de falsificación.

## Derivaciones consolidadas de octubre

```powershell
python scripts/generar_derivaciones_docx.py --fuente Documentos/04-Administrativo-TG2/Avances/Derivaciones-Matematicas-TG2-2026-10-12.md --revision .tools/derivaciones-octubre
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/actualizar_derivaciones_word.ps1 -Documento Documentos/04-Administrativo-TG2/Avances/Derivaciones-Matematicas-TG2-2026-10-12.docx -CarpetaTrabajo .tools/derivaciones-octubre/render
```

El generador comprueba celdas y ecuaciones antes de publicar. El script de renderizado acepta `-Documento`, `-DestinoImagenes` e `-Informe` para revisar esa copia. Los valores por defecto preservan el flujo histórico; especificar las rutas de la nueva edición conserva el suplemento anterior.
