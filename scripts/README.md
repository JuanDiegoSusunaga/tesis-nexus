# Herramientas y reproducción de TG2

Ejecutar desde la raíz de `Tesis`. Los scripts resuelven las rutas del proyecto a partir de su ubicación. El código Rust se clona en `nexus/` según el [README principal](../README.md).

## 1. Consultar la versión conservada

```powershell
python scripts/verificar_version_tg2.py
```

Este comando verifica el commit y el estado del código, los hashes del manuscrito, las fuentes conservadas y los resultados incluidos en el [manifiesto](../Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json). No ejecuta benchmarks ni modifica los documentos. Solo necesita Python y Git.

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
cargo check --workspace --all-targets --locked --offline --manifest-path nexus/Cargo.toml
cargo test --workspace --locked --offline --manifest-path nexus/Cargo.toml
cargo build --workspace --locked --offline --manifest-path nexus/Cargo.toml
```

La edición del 23 de septiembre pasa 197 pruebas en desarrollo. Las diez pruebas release de FRI vinculada pertenecen a la ejecución del día 22. Los informes conservan el conteo y los comandos de cada etapa.

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

Después de actualizar y revisar manuscrito, evidencia y código, hacer primero el commit del código. Ejecutar `python scripts/registrar_version_tg2.py`, revisar el manifiesto generado y `python scripts/verificar_version_tg2.py`; después hacer el commit de documentos. El manifiesto fija el commit de código, el commit documental anterior y hashes. El commit documental que contiene el manifiesto identifica la edición sin introducir una referencia circular a su propio hash.
