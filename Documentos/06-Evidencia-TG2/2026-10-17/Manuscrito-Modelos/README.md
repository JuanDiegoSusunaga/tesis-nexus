# Manuscrito conciliado con Lean

Las salidas vigentes [Markdown](../../../01-Manuscrito/Tesis-NEXUS-completa.md),
[Word](../../../01-Manuscrito/Tesis-NEXUS-completa.docx) y
[PDF](../../../01-Manuscrito/Tesis-NEXUS-completa.pdf) se regeneran desde las mismas
fuentes TG2. Los capítulos se conservan durante la generación y sus hashes se
comprueban antes y después; el normalizador no se ejecuta sobre ellos.

Las correcciones registradas afectan al resumen/abstract y capítulo 6: estado
parcial de Lean, 16 bytes de coordenadas frente a 17 de entrada de hoja y
768.2 KiB equivalentes a unas 238 firmas de 3309 B. Los entregables TG1 no cambian.

[preparacion.json](preparacion.json) identifica fuentes y salidas anteriores.
[publicacion.json](publicacion.json) fija los hashes de las tres salidas nuevas.
[revision-visual.json](revision-visual.json) registra la inspección de todas las
110 páginas Word y 99 PDF a resolución original, sin recortes ni solapamientos
detectados. El índice Word se actualiza en una instancia oculta; el PDF se genera
localmente con MathML y Chrome. El renderer empaquetado carece de dependencias;
se conserva el render nativo de Word ya usado por el repositorio.

Los controles verifican 34 tablas y 848 celdas contra una conversión independiente,
565 ecuaciones Word y tres figuras. No hay páginas PDF vacías ni texto fuera de
márgenes. Tablas, figuras y rótulos permanecen juntos en Word. Las imágenes de
QA están en .tools/; sus hashes se conservan en la revisión, sin entregarlas como
otro manuscrito. La [auditoría Lean](../Lean-Modelos-Pendientes/README.md) y la
[matriz de pendientes](../../../../formalizacion/REVISION-MANUSCRITO.md) delimitan
el alcance. No hay dictamen independiente ni cierre matemático completo.
