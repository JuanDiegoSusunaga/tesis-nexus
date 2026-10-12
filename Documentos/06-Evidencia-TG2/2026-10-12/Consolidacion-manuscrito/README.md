# Evidencia de la consolidación TG2 del 12 de octubre

**Actualización posterior del mismo día:** [revisión web y local con subagentes](../Revision-subagentes/Consolidacion/README.md). La identificación del manuscrito se actualiza allí; los demás informes de esta carpeta conservan la primera consolidación y sus recuentos históricos. Una copia de su identificación original está en `../Revision-subagentes/Consolidacion/Edicion-anterior/`.

La edición integra la revisión de antecedentes y los complementos por rondas y ROM. Las demostraciones propuestas conservan su dictamen pendiente y QROM completo AIR/FRI es trabajo futuro.

- [Identificación de manuscrito y suplemento](revision-manuscrito.json).
- [Comprobaciones, comandos y hashes de fuentes](validacion.json).
- [Cobertura de revisión visual](inspeccion-visual.json): 110 páginas Word, 97 PDF y 54 del suplemento.
- [Revisión estructural del suplemento](revision-derivaciones.json): 14 tablas, 265 celdas y 673 ecuaciones nativas.
- [Protección de 176 archivos](archivos-protegidos.json): entregables TG1, código Rust y paquetes matemáticos originales.
- [Comprobación de enlaces locales](enlaces-locales.json).
- [Manifiesto anterior conservado](version-tg2-anterior.json); el manifiesto vigente está en Entrega-Final.

Los logs registran check, 197 pruebas Rust, build y 30 pruebas Python de las derivaciones, además del catálogo. Diez pruebas del verificador de edición también pasaron. Se corrigieron dos ecuaciones anchas y una tabla sin alterar sus términos o valores. Word y PDF usan motores distintos; se comparan sus contenidos, no su número de páginas. El renderer empaquetado falló por dependencias ausentes; el log conserva el fallo y se inspeccionaron las páginas del renderer nativo de Word.

Los archivos de imagen temporales permanecen en `.tools/`; su inventario y hashes se registran sin incorporar 261 imágenes al repositorio. El control visual evalúa presentación, no validez matemática. No se acredita 100 bits, conocimiento cero, seguridad incondicional de SHA3 ni aprobación del director.
