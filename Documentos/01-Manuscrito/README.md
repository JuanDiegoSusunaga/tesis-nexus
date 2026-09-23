# Manuscrito NEXUS — edición vigente

**Actualización:** 23 de septiembre de 2026. Edición de trabajo consolidada para TG2; el estado técnico y los pendientes se detallan en la [ruta de cierre](../04-Administrativo-TG2/Ruta-de-Cierre-TG2.md).

**Alcance:** sistemas en general que requieren firmas digitales, registros verificables y gestión de claves. El título, los resúmenes, el objetivo general y las conclusiones incorporan la aclaración expresa del autor. La arquitectura blockchain dual es el modelo de referencia de la tesis; cada dominio de aplicación requiere validar sus reglas propias.

## Archivos de consulta

- [Word editable](Tesis-NEXUS-completa.docx): índice actualizado, ecuaciones nativas, 32 tablas y 3 figuras.
- [PDF de lectura](Tesis-NEXUS-completa.pdf): índice con páginas y enlaces internos.
- [Markdown ensamblado](Tesis-NEXUS-completa.md): contenido generado desde las fuentes.

Las tres salidas corresponden a los mismos capítulos, resumen y bibliografía. Se conserva un único nombre por formato. Tras incorporar la auditoría Merkle/Fiat–Shamir, el Word tiene 108 páginas y el PDF 95: usan motores de maquetación distintos y cada índice corresponde a su propio archivo. La exportación PDF de Word se bloqueó también con un documento mínimo; el PDF se generó localmente desde el mismo Markdown, con MathML y Chrome, sin enviar el manuscrito a servicios externos.

## Fuente de edición

Modificar los siete capítulos y los archivos `_tesis-frontmatter.md` y `_tesis-bibliografia.md` dentro de `Capitulos/`. Después, regenerar las salidas. `plantilla-referencia.docx` aporta los estilos; no es otro manuscrito.

Formato aplicado: papel carta, márgenes de 2,54 cm, Times New Roman de 12 puntos e interlineado 1,5; tablas de 9–10 puntos, rótulos numerados por capítulo y ecuaciones editables. Las tres figuras usan texto de 10 puntos a su ancho final de 6,5 pulgadas: PNG de 320 ppp en Word y originales vectoriales en PDF. Sustituyen los diagramas de caracteres y la cadena narrativa que no cabía cómodamente en una línea. No se ha declarado conformidad con una plantilla institucional adicional.

## Regeneración desde la raíz del proyecto

Los informes se guardan en una carpeta con la fecha de ejecución. Para reproducir esta edición, establecer antes de los comandos `$env:NEXUS_TG2_FECHA_EVIDENCIA="2026-09-23"`; debe ser una fecha válida AAAA-MM-DD.

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

El ensamblador normaliza las fuentes y comprueba filas, columnas y conversión matemática. La revisión compara las 822 celdas con una conversión independiente desde Markdown; reconoce la representación equivalente de `ℓ` que Word guarda como una `l` con estilo matemático script. La edición conserva 541 objetos matemáticos nativos en Word, incluidos 30 bloques. Las imágenes temporales quedan en `.tools/`.

## Revisión registrada

- [Auditoría Merkle/Fiat–Shamir y correspondencia del corpus](../04-Administrativo-TG2/Avances/R4-Merkle-Fiat-Shamir-2026-09-23.md).
- [Paquete para revisión matemática S1–S3](../04-Administrativo-TG2/Avances/Revision-Matematica-S1-S3-2026-09-23.md).
- [Identificación de la edición vigente](../06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/revision-manuscrito.json).

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
