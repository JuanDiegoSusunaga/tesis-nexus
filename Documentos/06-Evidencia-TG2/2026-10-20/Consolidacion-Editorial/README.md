# Consolidación editorial local

El autor autoriza «Dale 1» a guardar los últimos cambios documentales en un commit local. Se incluyen la preparación para el director y su solicitud Word, las aclaraciones de referencias y M, el glosario y la notación en preliminares, las salidas y las evidencias correspondientes. Se conservan los ajustes del ensamblador y del espaciado del índice necesarios para regenerar esos documentos.

`preparacion.json` registra el commit base, alcance exacto, huellas, siete respaldos y la comprobación inicial de 9772 archivos. Se preservan todas las rutas del manifiesto anterior. El commit que contiene esta preparación identifica la consolidación; su hash se obtiene del historial Git del manifiesto, sin incluir una autorreferencia imposible.

La selección se coteja exactamente con el índice y los objetos Git; solo se admite la normalización de finales de línea configurada. No se alteran ni regeneran el manuscrito o la solicitud durante la consolidación. Las 354 fuentes/configuraciones Lean y 89 Rust mantienen sus huellas; no se compilan ni se ejecutan suites. Se excluyen `tmp/`, la presentación, dependencias, cachés y código ajeno al cambio documental. No hay push, envío, recepción, aprobación ni dictamen del director.
