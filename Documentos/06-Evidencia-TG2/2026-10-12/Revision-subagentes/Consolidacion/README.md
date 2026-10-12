# Consolidación de la revisión web y local

Esta edición incorpora las observaciones de los tres [informes independientes](../../../../04-Administrativo-TG2/Avances/Revision-Subagentes-2026-10-12/README.md). Se precisan la firma sobre SHA3-256, la derivación desde semilla retenida, la conformidad no certificada y el alcance de las mediciones. La revisión interna no sustituye el dictamen académico. La sustentación queda aplazada y QROM completo AIR/FRI conserva su alcance futuro.

- [Identificación y hashes del manuscrito](revision-manuscrito.json).
- [Check, 197 pruebas Rust y build](codigo.json); [40 pruebas Python y catálogo](python.json).
- [Exportación y revisión de formatos](formatos.json).
- [Comparación de imágenes con la edición anterior](comparacion-visual.json): páginas idénticas por SHA-256 conservan la inspección anterior; las cambiadas se inspeccionan de nuevo a resolución original.
- [Cobertura de la inspección visual y correcciones](inspeccion-visual.json). La [primera iteración](Iteracion-1/comparacion-visual.json) se compara con la consolidación anterior; la comparación vigente corresponde a la segunda iteración tipográfica.
- [Protección de 176 archivos originales](archivos-protegidos.json) y [enlaces locales](enlaces-locales.json).
- [Identificación de la edición anterior](Edicion-anterior/revision-manuscrito.json). Los informes originales de la primera consolidación permanecen como antecedentes; sus páginas y huellas corresponden a aquella edición.

Word y PDF usan motores de maquetación distintos. Los procesos hijos se ejecutaron sin abrir ventanas de consola. El renderer empaquetado había fallado por dependencias ausentes; esta revisión usa el renderer nativo de Word existente y PyMuPDF para las imágenes del PDF. No se ejecutaron nuevos benchmarks ni se modificaron los archivos Rust, TG1 aprobado o los paquetes matemáticos originales. El suplemento de derivaciones se conserva sin cambios.
