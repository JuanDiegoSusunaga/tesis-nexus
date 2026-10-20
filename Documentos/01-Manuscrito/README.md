# Manuscrito NEXUS

**Consolidación editorial local, 20 de octubre:** la tesis con glosario en preliminares, la solicitud para el director y sus evidencias se incluyen en el commit que contiene esta entrada, con autorización «Dale 1». [Alcance e integridad](../06-Evidencia-TG2/2026-10-20/Consolidacion-Editorial/preparacion.json). No se regeneran los archivos ni se repiten compilaciones o revisiones visuales; se preservan sus huellas y controles previos. Sin push, envío ni dictamen. Las menciones de cambios locales sin commit en las etapas siguientes son antecedentes.
**Claridad de lectura vigente, 20 de octubre:** las referencias se escriben con «sección» y M se explica en sus contextos de lote y muestreo. El [glosario de 33 entradas y la guía de notación de 20 entradas](Capitulos/_tesis-glosario.md) se sitúan en las páginas preliminares, después del alcance y antes del capítulo 1, por indicación del autor. El glosario comienza en la página 7 de Word y PDF; la notación, en la 12 de Word y la 11 de PDF. [Verificación y respaldos de la reubicación](../06-Evidencia-TG2/2026-10-20/Glosario-Preliminares/verificacion.json). El contenido es idéntico salvo el orden y los índices actualizados; no hay pruebas ni obligaciones matemáticas nuevas, compilaciones Lean/Rust, commit o push. Los registros fechados siguientes son antecedentes.

**Consolidación documental local, 20 de octubre:** manuscrito y evidencia se incluyen en el commit autorizado que contiene el manifiesto de entrega, sin push ni regeneración. Las fuentes Lean aún locales, sus herramientas nuevas y los temporales no forman parte de este commit documental; no se altera su estado técnico. [Alcance y respaldos](../06-Evidencia-TG2/2026-10-20/Consolidacion-Documental/preparacion.json).

**Comprobación posterior a la regeneración, 20 de octubre:** pasa la [verificación global final de Rust](../06-Evidencia-TG2/2026-10-20/Rust-Global-Final/verificacion.json) sobre `637e77c`: check de todos los targets, 223 pruebas sin fallos y build, con cuatro trabajos y caché. No cambia el código, no se recompila Lean y no se regeneran las salidas del manuscrito. El texto y los informes de conciliación siguientes conservan los conteos disponibles al generarse; los nuevos logs se incorporan a la evidencia y al manifiesto sin reescribir esos antecedentes.

**Estado, 20 de octubre:** el manuscrito está sincronizado con el contrato Rust y su conexión local a `ActiveChain`, commit `637e77c99e804664915caf4ed928a10ef81cc870`. Se distinguen las 197 pruebas globales de referencia de las ejecuciones aisladas de 113 y 55 pruebas, sin sumarlas ni anunciar una nueva global. La [conciliación y revisión visual](../06-Evidencia-TG2/2026-10-20/Conciliacion-Manuscrito-Rust/verificacion.json) conserva las fórmulas e hipótesis de §6.7.9 y los objetivos originales. Solo actualiza allí una frase descriptiva: Rust también aplica el corte de 512 extracciones, sin que ello demuestre equivalencia universal.

**Actualización:** 20 de octubre de 2026. Se mantiene una sola tesis, sin etiquetas de etapas académicas ni narrativa de borradores. El historial y los respaldos permanecen fuera del manuscrito, en la evidencia y la [ruta de cierre](../04-Administrativo-TG2/Ruta-de-Cierre-TG2.md). Esta pasada no compila Rust ni Lean; conserva intactas 89 fuentes/configuraciones Rust y 354 Lean. La [auditoría global previa de 2709 declaraciones](../06-Evidencia-TG2/2026-10-20/Lean-Global/verificacion.json) no acredita por sí sola todo el manuscrito, refinamiento universal Rust, QROM ni aprobación académica. El AIR sigue siendo escalar: las raíces SHA3 generales fuera del modelo se rechazan y los positivos de integración son sintéticos.

**Antecedente de coherencia, 19 de octubre:** se atendieron los seis grupos de la revisión integral: alcance de los objetivos, min-entropía conjunta, consenso e incentivos, amortización y CPU, hipótesis de las síntesis y propuesta de señuelos. Se preservaron los objetivos originales y se declaró el cumplimiento parcial de la reducción concreta de seguridad de las firmas. La cota ROM de §6.7.9 y las fuentes Lean permanecieron intactas. [Corrección y controles](../06-Evidencia-TG2/2026-10-19/Revision-Integral-Coherencia/correccion-verificada.json).

**Alcance:** sistemas en general que requieren firmas digitales, registros verificables y gestión de claves. El título, los resúmenes, el objetivo general y las conclusiones incorporan la aclaración expresa del autor. La arquitectura blockchain dual es el modelo de referencia de la tesis; cada dominio de aplicación requiere validar sus reglas propias.

## Archivos de consulta

- [Word editable](Tesis-NEXUS-completa.docx): índice actualizado, ecuaciones nativas, 34 tablas y 3 figuras.
- [PDF de lectura](Tesis-NEXUS-completa.pdf): índice con páginas y enlaces internos.
- [Markdown ensamblado](Tesis-NEXUS-completa.md): contenido generado desde las fuentes.

Las tres salidas corresponden a los mismos capítulos, resumen, glosario, notación y bibliografía, con un único nombre por formato. Word tiene 123 páginas, 34 tablas, tres figuras y 664 ecuaciones nativas; el PDF tiene 111 páginas. Los 58 objetos matemáticos adicionales pertenecen a la guía de notación: las 606 expresiones originales se conservan. Usan motores de maquetación distintos y cada índice corresponde a su propio archivo. El PDF se genera localmente desde el mismo Markdown, con MathML y Chrome, sin enviar el manuscrito a servicios externos. Se comparan las 848 celdas de las 34 tablas y se revisan las páginas de ambos formatos. Los archivos anteriores se conservan como respaldos, no como manuscritos alternativos de consulta.

## Fuente de edición

Modificar los siete capítulos y los archivos `_tesis-frontmatter.md`, `_tesis-glosario.md` y `_tesis-bibliografia.md` dentro de `Capitulos/`. Después, regenerar las salidas. `plantilla-referencia.docx` aporta los estilos; no es otro manuscrito.

Formato aplicado: papel carta, márgenes de 2,54 cm, Times New Roman de 12 puntos e interlineado 1,5; tablas de 9–10 puntos, rótulos numerados por capítulo y ecuaciones editables. Las tres figuras usan texto de 10 puntos a su ancho final de 6,5 pulgadas: PNG de 320 ppp en Word y originales vectoriales en PDF. Sustituyen los diagramas de caracteres y la cadena narrativa que no cabía cómodamente en una línea. No se ha declarado conformidad con una plantilla institucional adicional.

## Regeneración desde la raíz del proyecto

Los informes se guardan en una carpeta con la fecha de ejecución. Para una nueva generación, establecer antes de los comandos `$env:NEXUS_TG2_FECHA_EVIDENCIA="2026-10-20"`; debe ser una fecha válida AAAA-MM-DD. Esta conciliación reutilizó los generadores existentes y separó sus registros en `2026-10-20/Conciliacion-Manuscrito-Rust/`.

Requisitos: Python con `lxml`, Matplotlib, PyMuPDF y Pillow; Pandoc; Microsoft Word para actualizar su índice; Chrome o Edge para el PDF. Las versiones Python están fijadas en [requirements.txt](../../requirements.txt). Las [instrucciones de instalación y reproducción](../../scripts/README.md) usan `.venv`; también se admite la instalación histórica de PyMuPDF en `.tools/pdf`. El [manifiesto de edición](../04-Administrativo-TG2/Entrega-Final/version-tg2.json) identifica los archivos conservados y el commit de código.

```powershell
python scripts/generar_figuras_manuscrito.py
python scripts/compilar_manuscrito.py
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/exportar_manuscrito_word.ps1
python scripts/exportar_manuscrito_pdf.py
python scripts/revisar_manuscrito.py
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/renderizar_manuscrito_word.ps1
python scripts/revisar_graficas_manuscrito.py
```

El ensamblador normaliza las fuentes y comprueba filas, columnas y conversión matemática. La revisión compara las 848 celdas con una conversión independiente desde Markdown; reconoce la representación equivalente de `ℓ` que Word guarda como una `l` con estilo matemático script. El manuscrito contiene 664 objetos matemáticos nativos en Word, incluidos los de la guía de notación. Las imágenes temporales quedan en `.tools/` o en `tmp/` según el comando de renderizado.

## Revisión registrada

**Conciliación Lean del 17 de octubre:** [fuentes, regeneración y revisión](../06-Evidencia-TG2/2026-10-17/Manuscrito-Modelos/README.md).
Se corrigen KiB/firmas, los bytes de hoja y el estado parcial de Lean en resumen,
abstract y capítulo 6. La formalización registraba 1610 resultados al cerrar la etapa de las 22 obligaciones, que tiene una
[auditoría propia](../06-Evidencia-TG2/2026-10-17/Lean-Obligaciones-22/README.md).
Se revisan todas las páginas Word/PDF, 34 tablas y 848 celdas; el cierre matemático
integral y el dictamen independiente siguen pendientes. Las referencias de 12 de
octubre que siguen identifican la edición anterior.

**Revisión web vigente:** [tres informes, integración y asuntos abiertos](../04-Administrativo-TG2/Avances/Revision-Subagentes-2026-10-12/README.md); [identificación y verificación de esta edición](../06-Evidencia-TG2/2026-10-12/Revision-subagentes/Consolidacion/revision-manuscrito.json). La sustentación queda aplazada por el autor.

**Consolidación vigente:** [revisión de los antecedentes y complementos](../04-Administrativo-TG2/Avances/Consolidacion-Manuscrito-TG2-2026-10-12.md), con las demostraciones propuestas de §§6.7.8–6.7.9 y el alcance QROM de §6.7.10. [Suplemento de derivaciones](../04-Administrativo-TG2/Avances/Derivaciones-Matematicas-TG2-2026-10-12.docx). Las entradas fechadas siguientes conservan la historia de las etapas anteriores.

- [Auditoría Merkle/Fiat–Shamir y correspondencia del corpus](../04-Administrativo-TG2/Avances/R4-Merkle-Fiat-Shamir-2026-09-23.md).
- [Paquete para revisión matemática S1–S3](../04-Administrativo-TG2/Avances/Revision-Matematica-S1-S3-2026-09-23.md).
- [Identificación histórica de la edición del 12 de octubre](../06-Evidencia-TG2/2026-10-12/Consolidacion-manuscrito/revision-manuscrito.json).
- [Identificación histórica de la auditoría Merkle/Fiat–Shamir](../06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/revision-manuscrito.json).

- [Cota interactiva ideal: derivación, correspondencia, cuentas y límites](../04-Administrativo-TG2/Avances/R4-Cota-Interactiva-2026-09-22.md).
- [Identificación histórica de la edición de cota interactiva](../06-Evidencia-TG2/2026-09-22/R4-cota-interactiva/revision-manuscrito.json).

- [FRI de traza vinculada al AIR: variante, formato, límites y 197 pruebas](../04-Administrativo-TG2/Avances/R4-FRI-Vinculado-2026-09-22.md).
- [Identificación histórica de la edición de FRI vinculada](../06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado/revision-manuscrito.json).

- [Proximidad de traza: contraejemplo, control exhaustivo y 187 pruebas](../04-Administrativo-TG2/Avances/R4-Proximidad-Traza-2026-09-22.md).
- [Identificación histórica de la edición de proximidad](../06-Evidencia-TG2/2026-09-22/R4-proximidad/revision-manuscrito.json).

- [Argumento AIR/FRI: hipótesis, cancelación, distancia y 180 pruebas](../04-Administrativo-TG2/Avances/R4-Algebra-AIR-FRI-2026-09-22.md).
- [Identificación histórica de la edición algebraica](../06-Evidencia-TG2/2026-09-22/R4-algebra/revision-manuscrito.json).

- [Auditoría STARK: parámetros, proximidad y 173 pruebas](../04-Administrativo-TG2/Avances/R4-Solidez-STARK-2026-09-22.md).
- [Identificación histórica de la edición STARK](../06-Evidencia-TG2/2026-09-22/R4-solidez/revision-manuscrito.json).

- [Correspondencia R1: perfil implementado, condiciones de los teoremas y 166 pruebas](../04-Administrativo-TG2/Avances/R1-Correspondencia-Formal-2026-09-22.md).
- [Identificación histórica de la edición R1](../06-Evidencia-TG2/2026-09-22/R1-correspondencia/revision-manuscrito.json).

- [Registro R5 y complemento R4: 163 pruebas y benchmarks pendientes completados](../04-Administrativo-TG2/Avances/R5-Residencia-y-Custodia-2026-09-22.md).
- [Identificación histórica de la edición R5](../06-Evidencia-TG2/2026-09-22/R5-residencia/revision-manuscrito.json).
- [Verificador y primera ejecución R4: registro histórico](../04-Administrativo-TG2/Avances/R4-Verificador-y-Evidencia-2026-09-22.md).
- [Contenido y PDF](../06-Evidencia-TG2/2026-09-23/revision-exportacion.json).
- [Paginación de tablas en Word](../06-Evidencia-TG2/2026-09-23/paginacion-word.json).
- [Informe de formato](../06-Evidencia-TG2/2026-09-23/formato-manuscrito.json).
- [Revisión de figuras y evaluación de la tesis](../04-Administrativo-TG2/Avances/Revision-Graficas-y-Evaluacion-2026-09-22.md).
- [Inventario de figuras y fórmulas](../06-Evidencia-TG2/2026-09-23/revision-graficas.json).
- [Rotación y registro R3, 142 pruebas](../04-Administrativo-TG2/Avances/R3-Rotacion-y-Registro-2026-09-22.md).
- [Monitor R2 y verificación de 123 pruebas](../04-Administrativo-TG2/Avances/R2-Monitor-Entropia-2026-09-22.md).
- [Análisis de la bitácora](../04-Administrativo-TG2/Avances/Revision-Bitacora-2026-09-22.md).

Las cifras históricas conservan su procedencia. Las diferencias con la caché recuperada, los límites del PoC y los requisitos técnicos abiertos están señalados en los capítulos 5–7 y en la matriz de trazabilidad. La aprobación previa comunicada por el estudiante no se atribuye a las correcciones nuevas de esta edición.
