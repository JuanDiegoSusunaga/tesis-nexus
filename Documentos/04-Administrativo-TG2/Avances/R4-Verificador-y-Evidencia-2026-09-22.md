# R4 — Verificador y evidencia experimental

> **Actualización posterior del mismo día:** el autor cambió Smart App Control y los dos benchmarks pendientes finalizaron en `R4-complemento/`. ML-DSA-65: 84,61 µs de verificación; mediana de 136.390 verificaciones/s con 24 hilos. El informe siguiente describe la primera ejecución, cuyos fallos y archivos se preservan. R5 eleva la suite a 163 pruebas. [Informe actual y complemento](R5-Residencia-y-Custodia-2026-09-22.md).



**Fecha:** 22 de septiembre de 2026. **Estado:** validación y variante experimental realizadas; reproducción experimental parcial. R4 conserva pendientes antes del cierre de TG2.

## Resultado verificable

- `cargo check --workspace --all-targets`, `cargo test --workspace` y `cargo build --workspace` terminan correctamente con dependencias bloqueadas y modo offline. **160 pruebas pasan**, incluidas **18 nuevas**: quince del verificador y tres del ensayo multinúcleo. Permanecen advertencias preexistentes del workspace.
- Se preservaron sin cambios el verificador heredado, el puente de raíces y el núcleo STARK de TG1, comprobado mediante `git diff --exit-code HEAD`. La variante TG2 vive en `nexus-active/experiments/tg2_canonical_verifier.rs` y se evalúa desde pruebas de integración; no reemplaza la API del nodo.
- Finalizaron **17 casos Criterion** (ocho clásicos y nueve de residencia) y **40 mediciones STARK**, con resultados originales, dispersión, fuentes y metadatos.
- Windows bloqueó los ejecutables optimizados de `dilithium_bench` y `tg2_throughput` con **error 4551, Control de aplicaciones**. No se alteraron las protecciones ni se reintentaron esos ejecutables. No hay cifras nuevas de verificación ML-DSA ni de throughput corregido.

## Hallazgos del verificador

1. **Aceptación sin prueba:** cuatro bytes arbitrarios y entradas públicas coincidentes bastan para que la ruta heredada acepte y marque la raíz como verificada.
2. **Raíces parciales:** modificar cualquiera de los últimos 24 bytes de las raíces anterior y posterior no altera la aceptación heredada. En los primeros ocho bytes, `3` y `p+3` también colisionan por reducción al campo. Se reproducen ambos casos.
3. **Contexto exterior:** con una prueba STARK válida, la ruta heredada puede ignorar tipo, altura y entradas públicas exteriores. La variante exige coincidencia con el contexto esperado por el llamador.
4. **Conocimiento cero:** para el ejemplo de 16 filas, se reconstruye el testigo mediante interpolación de las aperturas públicas de la traza. La prueba automatizada deriva los índices del transcript y utiliza exclusivamente enunciado y prueba para recuperar la segunda fila. El valor esperado se usa solo en la aserción final. No se extrapola una reconstrucción idéntica a toda longitud, pero el caso refuta una garantía general de ocultación del PoC actual.

### Variante experimental y sus límites

La variante admite exclusivamente raíces que codifican un escalar canónico Goldilocks en los ocho primeros bytes y tienen los 24 restantes nulos. Rechaza raíces hash arbitrarias de 256 bits. Valida tipo de prueba, altura y raíces esperadas, entradas exteriores, longitud del mensaje, deserialización sin bytes sobrantes, tamaño de traza, elementos de campo canónicos y forma de las aperturas antes de ejecutar STARK. No existe aceptación alternativa por formato.

Los casos incluyen prueba válida; mutación de cada byte de ambas raíces; tipos y contextos incorrectos; mensajes vacíos, truncados, con bytes sobrantes o sobredimensionados; traza fuera de límites; elementos de campo no canónicos; consultas, capas y caminos incompletos; alteraciones de valores y hashes con estructura válida. Los límites son 2 MiB de prueba y potencias de dos entre 16 y 262.144 filas.

La altura permanece fuera del enunciado del AIR: el mismo STARK puede aceptarse si la aplicación autoriza otro contexto. La prevención de repetición, la política de épocas y la actualización del libro mayor requieren reglas externas. El dominio restringido no demuestra enlace de raíces completas ni anclaje L1 del registro R3. Tampoco aporta enmascaramiento, prueba formal de soundness, protección exhaustiva frente a entradas hostiles o validación de una aplicación completa.

## Ensayo multinúcleo

El harness histórico permitía contar antes del inicio del reloj principal. Sus 199.218 verificaciones/s con 24 hilos se mantienen como antecedente con posible sesgo, sin respaldar el escalado validado.

La variante `tg2_throughput` prepara un corpus público de 4096 mensajes y firmas, verifica su validez y elimina los pares privados. Coordina a todos los trabajadores con dos barreras y un reloj común; el denominador se extiende hasta terminar todos los hilos. Comprueba fallos de firma y conserva contadores por trabajador. Incluye cinco repeticiones por número de hilos, orden alternado y un segundo mínimo por repetición. Tres pruebas comprueban conteo, duración cubierta, errores de verificación y parámetros inválidos. El benchmark optimizado quedó bloqueado antes de iniciar: no se generó corpus ni CSV de throughput.

## Mediciones efectivas y reproducción

La ejecución original se conserva en [mediciones.json](../../06-Evidencia-TG2/2026-09-22/R4-validacion/mediciones.json). Incluye argumentos exactos, toolchain, Git con cambios locales, hashes de fuentes, tiempos y códigos de salida. `equipo.json` identifica Intel Core Ultra 9 275HX, 24 núcleos/hilos, Windows 11 compilación 26200 y plan Equilibrado. Los comandos corrieron en serie, sin afinidad ni control exclusivo del sistema operativo.

Criterion utilizó calentamiento de 1 s, objetivo de 2 s y 50 muestras salvo RSA-2048 KeyGen, con diez. Sus intervalos bootstrap del 95 % describen la mediana dentro de la corrida. Las cinco repeticiones STARK por tamaño cambian el testigo; cada una incluye veinte verificaciones. El rango entre repeticiones no es un intervalo de confianza. Las pruebas de software usan desarrollo y 12 bits de grinding; las mediciones optimizadas usan 20 bits.

Resultados destacados:

- Verificación clásica: ECDSA P-256 **149,05 µs**, RSA-2048 **98,07 µs**, RSA-3072 **221,01 µs**, medianas. Falta la contraparte de verificación ML-DSA de esta serie.
- ML-DSA-65: firma cacheada **327,42 µs**, efímera **478,74 µs**, expansión desde semilla **145,03 µs**. La diferencia de medianas de firma es **151,32 µs**; no mide residencia secreta ni equivale a una comparación pareada.
- STARK de 262.144 filas: **786.600 B**, mediana de generación **14,00 s** [9,67–14,25] y de verificación **7,79 ms** [6,04–8,64]. Son filas de una recurrencia, sin correspondencia establecida con transacciones reales.

Las tablas completas y sus rutas a los JSON originales están en [resumen-mediciones.json](../../06-Evidencia-TG2/2026-09-22/R4-validacion/resumen-mediciones.json) y [tablas-mediciones.md](../../06-Evidencia-TG2/2026-09-22/R4-validacion/tablas-mediciones.md). `python scripts/resumir_mediciones_r4.py` las regenera. `ejecutar_mediciones_r4.py` conserva la corrida y se niega a sobrescribirla; una repetición debe utilizar otra carpeta identificada. No se asignan retrospectivamente estos resultados a H1/H2 o a la caché recuperada.

La prueba de reconstrucción del testigo se incorporó después de la medición; [validacion.json](../../06-Evidencia-TG2/2026-09-22/R4-validacion/validacion.json) y `fuentes-validacion/` identifican la versión final comprobada. La instantánea `fuentes/` de los benchmarks permanece intacta. Los hashes no sustituyen el commit pendiente de revisión del autor.

## Soundness y amortización

La configuración del PoC no acredita por sí sola 100 bits. Multiplicar 40 consultas por dos bits y sumar 20 bits de trabajo exige justificar la ley de error, modelo del adversario y composición. Una cota aditiva con término `2^-20` tampoco permite concluir error total `2^-100`. Deben examinarse tasa efectiva, proximidad, desafíos, consultas al oráculo, Fiat–Shamir, grinding y adversario cuántico.

La literatura primaria aborda condiciones de seguridad de Fiat–Shamir aplicado a FRI y distingue estimaciones conjeturadas y demostrables de seguridad concreta. Esta revisión identifica la obligación; no instancia sus teoremas para NEXUS. Fuentes: [Block et al., 2023](https://eprint.iacr.org/2023/1071), [Block y Tiwari, 2024](https://eprint.iacr.org/2024/1161), [FRI, 2018](https://doi.org/10.4230/LIPIcs.ICALP.2018.14).

La nueva §6.6.5 presenta sensibilidad del modelo de anclaje, diferenciando costo por operación, prueba, disponibilidad de datos y generación. Sus escenarios numéricos son supuestos aritméticos; las filas del AIR no se convierten en transacciones.

## Estado y siguientes acciones

1. Completar los dos benchmarks bloqueados en un entorno cuya política permita su ejecución, con nuevas fuentes y metadatos identificados. No usar las cifras históricas multinúcleo como reemplazo.
2. Completar R1 y revisar con el director la correspondencia formal de ML-DSA y las afirmaciones sobre el PoC. No declarar una cota concreta de soundness todavía.
3. Continuar R5: modelo de amenaza de W, material secreto residente y custodia de la semilla; las latencias de R4 ya aportan una serie trazable.
4. Mantener identificadas las integraciones de R3 y el AIR de aplicación como pendientes; la variante canónica no las resuelve.

La edición vigente integra estas conclusiones en resumen, capítulos 6–7, bibliografía y seguimiento. Word tiene 87 páginas y PDF 77; se compararon 22 tablas y 501 celdas. Se inspeccionaron las tres figuras, las 18 ecuaciones en bloque y las tablas nuevas en ambos formatos. Word conserva 365 objetos matemáticos nativos y cada tabla comparte página con su rótulo. El PDF no presenta páginas vacías ni texto fuera de márgenes. La comprobación documental final se registra en `R4-validacion/revision-manuscrito.json`. No se atribuye aprobación del director a los cambios de esta sesión.
