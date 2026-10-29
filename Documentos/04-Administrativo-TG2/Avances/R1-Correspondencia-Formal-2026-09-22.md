# R1 — Correspondencia formal y perfil implementado

**Fecha:** 22 de septiembre de 2026. **Estado:** auditoría documental y funcional ejecutada. Revisión matemática externa y obligaciones de prueba concretas pendientes.

## Resultado de la revisión

El capítulo 6 identifica ahora qué versión del esquema usa el prototipo, qué prueban las fuentes citadas y dónde termina la correspondencia. Se conserva la primitiva aprobada; los cambios Rust son tres pruebas TG2. Esta revisión no presenta un nuevo teorema de seguridad del sistema.

### Perfil observado en el código

| Elemento | Evidencia inspeccionada | Resultado |
|---|---|---|
| Biblioteca y parámetros | Cargo.lock; constantes de fips204 0.4.6 | ML-DSA-44/65/87 bajo nombres históricos Dilithium2/3/5 |
| Reconstrucción de claves | dilithium.rs, gen_from_seed | Misma semilla y perfil reconstruyen el mismo par |
| Firma ordinaria | sign_bytes; traits.rs, try_sign; lib.rs, try_sign_with_rng | Modo puro; contexto vacío; 32 bytes de OsRng por firma |
| Aleatoriedad interna | ml_dsa.rs, sign_internal | Expansión desde clave, rnd y representante del mensaje |
| Firma de un hash | DilithiumKeypair::sign_hash | Firma los bytes recibidos como mensaje puro; no llama a HashML-DSA |
| Verificación | verify_bytes y API del backend | Contexto vacío; separación respecto de contexto no vacío y prehash |
| Bucle de rechazo | ml_dsa.rs | Contador u16 y ausencia de límite explícito de intentos; caso extremo no probado |

La reconstrucción determinista de claves no convierte la firma ordinaria en determinista. Tampoco prueba que Sentinel produzca semillas con las propiedades exigidas por una reducción.

## Cálculos reproducibles

El script [analizar_correspondencia_r1.py](../../../scripts/analizar_correspondencia_r1.py) lee las constantes del backend; no las toma de las tablas del manuscrito. Conserva los resultados y las fuentes en [correspondencia.json](../../06-Evidencia-TG2/2026-09-22/R1-correspondencia/correspondencia.json).

El contraste con la condición de JMW24 usa el ancho auxiliar positivo mínimo, igual a uno:

| ML-DSA | Zeta | Suma de dimensiones del teorema | Lado izquierdo mínimo | Lado derecho |
|---|---:|---:|---:|---:|
| 44 | 350209 | 9 | 1613763072 | 261888 |
| 65 | 724481 | 12 | 4451211264 | 261888 |
| 87 | 769537 | 16 | 6304047104 | 261888 |

La desigualdad estricta requerida falla en todos los perfiles. Se cierra la comprobación de **esa aplicación directa**, con resultado negativo. No se ha encontrado un ataque ni demostrado que toda posible reducción deba fallar. El manuscrito mantiene SelfTargetMSIS como supuesto en el alcance considerado.

También se reproduce la aritmética del escenario QROM NIST3 de B+23: log2 de la pérdida resulta aproximadamente −361,64. Este resultado comprueba la transcripción de la fórmula y los datos publicados. No deriva una cota del ejecutable ni demuestra las hipótesis que el artículo adopta.

## Fuentes conservadas y localizadores

Las cinco publicaciones se descargaron de fuentes primarias. [bibliografia.json](../../06-Evidencia-TG2/2026-09-22/R1-correspondencia/bibliografia.json) conserva URL, número de páginas y SHA-256; el texto extraído acompaña cada PDF. Los localizadores corresponden a esas versiones:

- [Barbosa et al., texto de CWI](https://ir.cwi.nl/pub/33405/33405.pdf): Teorema 2, p. 22; alcance de la formalización, p. 24; Teorema 4, p. 30; Figura 8, p. 31.
- [Jackson, Miller y Wang, v2](https://arxiv.org/pdf/2312.16619v2): Definición 3, p. 3; Teorema 2, p. 8; traducción de parámetros, §4, p. 15.
- [Langlois y Stehlé, texto de los autores](https://perso.ens-lyon.fr/damien.stehle/downloads/MSIS.pdf): Teorema 3.6, p. 12; Definición 4.6 y Teorema 4.7, p. 16; Teorema 4.8, p. 17. Se corrige la identificación anterior de los tres resultados como reducciones directas desde Mod-SIVP.
- [Dilithium v3.1](https://pq-crystals.org/dilithium/data/dilithium-specification-round3-20210208.pdf): §6.2, ecuaciones (6)–(8), nota 5 y §6.2.2.
- [FIPS 204](https://csrc.nist.gov/pubs/fips/204/final): algoritmos externos e internos y apéndices C–D.

Se inspeccionó además la [hoja oficial de actualizaciones potenciales](https://csrc.nist.gov/files/pubs/fips/204/final/docs/fips-204-potential-updates.xlsx), fechada el 31 de julio de 2026. Su instantánea y extracción están en [errata-fips204.json](../../06-Evidencia-TG2/2026-09-22/R1-correspondencia/errata-fips204.json). Se corrigieron las estimaciones de iteraciones de §6.5.2 y Tabla 6.3; su carácter potencial y su procedencia quedan indicados. No se presentan como nuevas mediciones locales.

La búsqueda complementaria consultó ML-DSA, pruebas QROM, firma hedged y publicaciones de 2025–2026. No se afirma exhaustividad del estado del arte ni inexistencia de otros resultados. La conclusión negativa sobre JMW24 se refiere al teorema y traducción concretos examinados.

## Verificación ejecutada

Se añadieron tres pruebas en [tg2_correspondence.rs](../../../nexus/nexus-crypto/tests/tg2_correspondence.rs), una por nivel. Comprueban claves públicas reconstruidas, compatibilidad de firma/verificación, firmas deterministas del backend y rechazo de mensajes, contextos y modos diferentes. Usan datos públicos de ensayo y no imprimen secretos.

Se ejecutaron cargo check con workspace y all-targets, cargo test del workspace y cargo build del workspace, todos con dependencias bloqueadas y modo offline: **166 pruebas pasan**. Se mantienen advertencias preexistentes. [validacion.json](../../06-Evidencia-TG2/2026-09-22/R1-correspondencia/validacion.json) identifica comandos, logs y conteo.

Estas pruebas comparten backend. No son ACVP/KAT independientes, no prueban resistencia a canales laterales ni mecanizan una reducción.

## Obligaciones que permanecen

| ID | Obligación | Criterio para resolverla |
|---|---|---|
| R1-A | Expansión desde semilla y perfil hedged | Resultado aplicable y correspondencia de oráculos, distribuciones y pérdidas |
| R1-B | Codificaciones, pistas, reto y sUF-CMA | Puente entre plantilla analizada y ML-DSA final; tratamiento de firmas nuevas sobre mensajes ya firmados |
| R1-C | Distribución y protección de semillas de Sentinel | Justificación de fuente/KDF y composición con la rotación |
| R1-D | Terminación y errores extremos del backend | Análisis del contador, límites de reintentos y comportamiento de error |
| R1-E | Aprobación matemática del argumento | Observaciones y resolución documentadas por director o lector competente |

El mapa de correspondencia y la comprobación de aplicabilidad están documentados. El Objetivo 4.1 no se declara completamente cerrado: una garantía concreta de la implementación exige resolver esas obligaciones. El presupuesto de soundness del PoC STARK pertenece al siguiente bloque de revisión.

## Edición del manuscrito

Word tiene **94 páginas** y PDF **85**. Las **26 tablas / 657 celdas** coinciden con la conversión independiente desde Markdown; rótulos y cuerpos permanecen juntos en Word. Se inspeccionaron las **3 figuras**, las **19 ecuaciones en bloque** y las Tablas 6.1–6.3 en ambos formatos. Word conserva **381 objetos matemáticos nativos**. La ecuación multilineal se comprobó en su página completa; se amplió el recorte de revisión que ocultaba su última línea.

Se actualizan el capítulo 6, los resúmenes, conclusiones y bibliografía; la matriz, la ruta y la bitácora reflejan el avance y sus pendientes. La identificación de Word, PDF y Markdown se conserva en [revision-manuscrito.json](../../06-Evidencia-TG2/2026-09-22/R1-correspondencia/revision-manuscrito.json).
