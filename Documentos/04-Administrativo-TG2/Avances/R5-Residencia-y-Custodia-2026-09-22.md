# R5 — Residencia, semilla y capacidad de firma

**Fecha:** 22 de septiembre de 2026. **Estado:** modelo, inventario, sensibilidad y pruebas documentados. Custodia protegida, integración de la política y observación de todas las copias de memoria pendientes.

## Qué cambió

Se revisó §5.6 para separar la política propuesta del gestor implementado. `KeyManager` conserva las claves entre firmas; la reexpansión por operación se evalúa en `residencia_bench`. La política no se integra en el gestor mediante esta revisión.

La clave ML-DSA-65 codificada ocupa 4032 B, de los cuales 96 corresponden a componentes públicos. Su par serializado ocupa 5993 B, incluyendo 1952 B públicos y 9 B de cabeceras. **5993 no es el tamaño en RAM ni una cantidad de bytes secretos.** Al firmar, el envoltorio copia la codificación y reconstruye un objeto `fips204::PrivateKey` de **17536 B**, sin contar toda la pila, temporales, registros o posibles residuos. Incluso la ruta cacheada deserializa por firma; no mantiene el objeto precomputado del backend entre llamadas.

Se corrigió el comentario del benchmark que calculaba exposición multiplicando tamaño público+privado por latencia. El cuerpo del benchmark y la primitiva de firma permanecen iguales. Las fuentes originales de R4 se conservan en su instantánea anterior.

## Modelo explícito

El activo es la capacidad de firmar operaciones no autorizadas. Se distinguen captura completa con semilla accesible, captura aislada con semilla realmente protegida, acceso persistente/sincronizado y remanencia fuera del ámbito de los objetos.

La residencia se define como la integral en bytes·segundo de las regiones declaradas, contando sus copias. El modelo numérico mantiene una semilla de 32 B en ambas políticas y compara una región codificada de 4032 B continuamente presente con esa región presente solo durante operaciones secuenciales. Se reconoce que la región incluye 96 B públicos. No se presenta este modelo como conteo de toda la memoria secreta.

La sensibilidad usa como duración supuesta la mediana R4 de reexpansión y firma. A diez operaciones/s, el promedio modelado pasa de 4064 B a 51,303 B, razón 79,216. **No implica 79 veces menos riesgo.** Si la captura incluye la semilla, se conserva la capacidad de firma. Solo en el escenario ideal con semilla inaccesible, captura uniforme independiente y ausencia de residuos, la unión de intervalos de exposición determina la coincidencia temporal. El atacante persistente no satisface esas hipótesis.

Se preservan el cálculo y los supuestos en [sensibilidad.json](../../06-Evidencia-TG2/2026-09-22/R5-residencia/sensibilidad.json), regenerable con `python scripts/modelar_residencia_r5.py`. Las cifras son escenarios del modelo, no mediciones de RAM ni probabilidades empíricas. Las latencias e intervalos de R4 se mantienen identificados en la Tabla 6.11.

## Pruebas ejecutadas

Tres pruebas nuevas en `nexus-crypto/tests/tg2_residence.rs` comprueban:

1. Longitudes pública, privada y serializada de los tres niveles, sin imprimir material de clave.
2. Reconstrucción del par y producción de una firma válida desde una semilla retenida después de descartar el par original.
3. Tamaños de los objetos del backend: 12416, 17536 y 23680 B; contrato `ZeroizeOnDrop` de esos tipos.

Se ejecutaron `cargo check --workspace --all-targets`, `cargo test --workspace` y `cargo build --workspace`, con `--locked --offline`: **163 pruebas pasan**. Además se ejecutó la prueba de integración específica con salida de tamaños. Hay advertencias preexistentes. Los logs, fuentes y hashes se conservan en [validacion.json](../../06-Evidencia-TG2/2026-09-22/R5-residencia/validacion.json).

Estas comprobaciones no leen memoria liberada, no acreditan borrado del sistema operativo y no verifican aislamiento de hardware. `ZeroizeOnDrop` establece una operación del tipo al descartarse, sin demostrar la eliminación de copias ajenas a su almacenamiento. No se incorporó código `unsafe` para inspeccionar memoria liberada.

## Fuentes y criterio de revisión

Consulta realizada el 22 de septiembre de 2026. Se buscaron representación por semilla, reexpansión, memoria limitada, residencia y zeroización. Consultas principales:

- `site.rfc-editor.org rfc9881 seed private key ML-DSA`
- `site.nvlpubs.nist.gov FIPS 204 3.6.3 seed private key`
- `"Dilithium for Memory Constrained Devices" Bos Renes Sprenkels`
- `"Analysis of Encryption Key Zeroization from a System-Wide Perspective"`
- `site.eprint.iacr.org "ML-DSA" "ephemeral" "memory"`
- `"Dilithium" "key residency" OR "key residence"`
- `site.eprint.iacr.org/2023/1713 zeroization`

Se priorizaron estándar, RFC, documentación de la versión usada y publicaciones de sus autores. El corpus principal fue:

- [FIPS 204, §§3.6.1 y 3.6.3](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.204.pdf): generación de semilla, datos intermedios y protección de la semilla retenida. No certifica la KDF ni el módulo NEXUS.
- [RFC 9881, §§6 y 8.1](https://www.rfc-editor.org/rfc/rfc9881.html): representaciones y recomendación de formato por semilla; no impone expansión por operación.
- [OpenSSL 3.5](https://docs.openssl.org/3.5/man7/EVP_PKEY-ML-DSA/): opciones de retención e importación de semilla; no se midió OpenSSL en NEXUS.
- [Bos, Renes y Sprenkels](https://eprint.iacr.org/2022/323): optimización para memoria limitada; el resumen y la ficha no justifican trasladar una garantía de seguridad de residencia.
- [Connolly, versión 02](https://www.ietf.org/archive/id/draft-connolly-cfrg-ml-dsa-security-considerations-02.html): regeneración y caché; la versión declara vencimiento el 20 de septiembre de 2026. Se cita como borrador archivado, no estándar vigente.
- [Sawa y Suzaki](https://lab.iisec.ac.jp/~suzaki_lab/PDF/ACSAC2025-Sawa.pdf): copias y persistencia de claves AES, con observación a escala del sistema. No se extrapolan sus tiempos a ML-DSA.
- [Arranz-Olmos et al.](https://eprint.iacr.org/2023/1713): obligaciones de zeroización con garantías sobre código y compilación; no equivalentes a un benchmark de latencia.

La búsqueda también devolvió propuestas comerciales de firmas efímeras, entre ellas una [descripción del propio proveedor](https://pilonlaboratories.com/PALLAS-QSK-Technical-Abstract). No se verificaron independientemente sus resultados ni sus afirmaciones de seguridad y no se usan para estimar NEXUS. Su aparición refuerza la necesidad de evitar una afirmación de inexistencia de antecedentes. No se realizó revisión sistemática exhaustiva de patentes, bases de pago o sistemas cerrados.

Se corrigió la autoría de Sawa y Suzaki y se retiró la pretensión de prioridad de la métrica bytes por tiempo. La contribución se formula como comparación trazable, inventario y modelo aplicado al prototipo.

## Complemento R4 tras el cambio de Windows

El autor informó que desactivó Smart App Control. El estado consultado pasó de 1 a 0. Los eventos originales corresponden a `VerifiedAndReputableDesktop`; su identidad coincide con la [política incorporada documentada por Microsoft](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/app-control-for-business/operations/inbox-appcontrol-policies). El agente consultó la configuración; no cambió controles de Windows.

Se ejecutaron de nuevo los dos benchmarks en una carpeta nueva, conservando los fallos iniciales. Ambos finalizaron. El complemento contiene **12 casos Criterion ML-DSA** y **40 repeticiones multinúcleo**. Junto con la primera serie R4, se dispone de **29 casos Criterion, 40 mediciones STARK y 40 repeticiones multinúcleo**.

ML-DSA-65 verificó en **84,61 µs**, mediana Criterion. En el ensayo corregido las medianas fueron **12.349 verificaciones/s con un hilo** y **136.390 con 24**, razón **11,04**. Son verificaciones aisladas; las diferencias frente a los 199.218 históricos no se atribuyen exclusivamente a corregir el reloj.

La procedencia, comandos y fuentes están en [ejecucion.json](../../06-Evidencia-TG2/2026-09-22/R4-complemento/ejecucion.json), las cifras y hashes del corpus público en [resumen.json](../../06-Evidencia-TG2/2026-09-22/R4-complemento/resumen.json). `scripts/resumir_complemento_r4.py` regenera las tablas 6.13–6.14. La ausencia de resultados de la primera ejecución permanece documentada como hecho histórico.

## Pendientes reales

- Integrar una política configurable de residencia si se mantiene como objetivo de implementación; el gestor continúa cacheando claves.
- Medir copias y residuos con claves de ensayo y una frontera de observación definida antes de afirmar seguridad de borrado.
- Implementar y evaluar custodia protegida y autorización del firmador para el modelo de despliegue elegido.
- Completar R1 y soundness, la fuente de entropía concreta y las integraciones de R3. La nueva evidencia no cierra esas obligaciones.

## Edición documental comprobada

El manuscrito actualizado conserva el enfoque en sistemas en general: **92 páginas en Word y 83 en PDF**, con índices propios. Las **26 tablas y 634 celdas** coinciden con la conversión independiente de las fuentes. Las filas de las tablas nuevas también se cotejaron con los resúmenes experimentales. Word conserva **364 objetos matemáticos nativos**, incluidos **18 bloques**.

Se inspeccionaron las tres figuras y las 18 fórmulas en bloque en ambos formatos, además de las Tablas 5.1, 5.2, 6.13 y 6.14. La revisión visual detectó escapes LaTeX incorrectos en §5.6.3; se corrigieron las fuentes, se regeneraron las tres salidas y se comprobaron las expresiones de nuevo. Todas las tablas comparten página con su rótulo en Word. El PDF no presenta páginas vacías ni texto fuera de los márgenes revisados.

La [identificación de esta edición](../../06-Evidencia-TG2/2026-09-22/R5-residencia/revision-manuscrito.json) conserva hashes del manuscrito y sus fuentes. También se comprobaron los hashes de las fuentes experimentales, logs R5, corpus público y CSV multinúcleo. Las fuentes históricas y los fallos de la primera ejecución R4 permanecen conservados. La aprobación anterior del director no se atribuye a esta revisión nueva.
