# Antecedentes de las pruebas de entropía y salud

El [manifiesto](manifiesto.json) identifica por SHA-256 la auditoría anterior de
777 resultados y 106 módulos, quince versiones anteriores de archivos actualizados,
y la copia de `nexus/nexus-crypto/src/entropy.rs` usada para contrastar el modelo.
Las seis fuentes de esa auditoría que cambian son Nexus.lean, Auditoria.lean,
cobertura.json, inventario-manuscrito.json y los dos lanzadores de Lean/auditoría.
Las otras 143 fuentes auditadas se conservan sin cambios.

`version_anterior/` conserva los bytes de esas seis fuentes y del registro,
comprobador, controles y documentación de la primera clasificación manual.
Permite consultar esa clasificación con sus cifras históricas de 51 bloques
parcialmente enlazados. El registro vigente añade enlaces y pruebas; no se
reescriben los informes históricos para atribuirles el avance posterior.

[Fuentes normativas](fuentes-normativas.json) registra NIST SP 800-90B, DOI,
fecha, URL y secciones consultadas. El estándar se usa como referencia: no se
deduce conformidad del módulo ni calificación de una fuente a partir de las pruebas.

La [nueva auditoría](../Lean-Entropia-Salud/validacion.json) incluye los hashes del
manifiesto, la referencia normativa, las quince copias y la fuente Rust preservada.
Los documentos administrativos aprobados de TG1 y los capítulos no se modifican.
