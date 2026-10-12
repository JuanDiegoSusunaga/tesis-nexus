# Ruta de acción para cerrar TG2 — NEXUS

**Fecha:** 2026-10-12. **Estado:** R2 y gestor/registro local de R3 probados; R4 y complemento medidos; variante FRI de traza vinculada al AIR probada. La derivación por rondas y la transferencia clásica ROM propuesta al protocolo TG2 v1 están integradas en `main`, con revisión matemática pendiente; QROM permanece abierto. R5 cuenta con modelo e inventario; R1 documenta correspondencias y límites, con revisión y garantías de despliegue pendientes. Aprobación del plan, entrega y decisiones previas confirmada por el estudiante; no se extiende a las nuevas derivaciones. Fecha exacta y calendario académico por incorporar.

**Resultado esperado:** preparar los Objetivos 3 y 4 con correspondencia verificable entre afirmaciones, fuentes, código y experimentos. La sustentación queda aplazada por indicación del autor el 12 de octubre.

**Revisión web y local del 12 de octubre:** [tres informes y registro de integración](Avances/Revision-Subagentes-2026-10-12/README.md). Se precisan la composición SHA3-256/ML-DSA, la semilla realmente usada y las afirmaciones heredadas. R4 y complemento concilian en 451 comprobaciones; siguen pendientes la identidad exacta de H1/H2, las obligaciones R1-A–E y el dictamen M1–M6. La revisión interna y el conteo exacto de cola de nueve perfiles no constituyen aprobación académica. No se requieren nuevos benchmarks para las afirmaciones de componentes conservadas.

**Decisión vigente del autor, 23 de septiembre:** QROM completo del protocolo AIR/FRI es trabajo futuro y deja de ser requisito del cierre activo. Se preservan sus avances parciales sin afirmar seguridad cuántica completa. Las obligaciones R1 de ML-DSA mantienen su alcance. Los párrafos QROM siguientes describen el historial de esa investigación.

**Revisión ROM previa:** [argumento de potencial para nonces y controles de premisas ROM](Avances/Revision-Critica-ROM-2026-09-23/README.md). Pasan 40 pruebas Python y 197 Rust, con check/build. La búsqueda exacta de 96 escenarios pequeños no supera la cota; dictamen externo pendiente.

**Etapa QROM iniciada a solicitud del autor:** [cota parcial del trabajo y correspondencia con teoremas cuánticos](Avances/QROM-2026-09-23/README.md). Doce pruebas adicionales elevan la regresión a 52 Python y 197 Rust, con check/build. La cota usa una condición necesaria y no incorpora AIR/FRI. El informe identificó Q1–Q5: extractor sin orden, índices/nonces, enlace por rondas, pérdidas y parámetros. Las obligaciones aún abiertas se conservan como trabajo futuro.

**Antecedente QROM del extractor:** [extractor y eventos algebraicos en la base comprimida](Avances/Extractor-QROM-2026-09-23/README.md). Se escribe y contrasta el lema de estabilidad; 45 escenarios y catorce tests nuevos, con 66 Python y 197 Rust en esa etapa. La cota controla un evento intermedio.

**Antecedente del cambio de juego:** [muestreo y reducción condicional al verificador](Avances/Muestreo-QROM-2026-09-23/README.md). Se reconstruyen índices/nonces, se propone la cobertura de aceptación falsa y se explicitan sus pérdidas. Esa etapa registra 80 Python y 197 Rust, check/build, 72 presupuestos y 28 recorridos. La cobertura y la reducción requieren revisión antes de considerar cerrados Q3–Q4.

**Avance QROM vigente:** [cota cuántica de la cola](Avances/Cola-QROM-2026-09-23/README.md). Se propone una demostración por conteo y amplitudes, con 144 perfiles y 16 cotas no triviales al ampliar el corte del análisis. Pasan 96 Python y 197 Rust, check/build. La omisión de parejas incorrectas sigue pendiente; la cola exige revisión y su mejora debe evaluarse junto con el aumento del presupuesto Q+V. El protocolo Rust no cambia.

**Dominio vigente:** sistemas en general, según aclaración expresa del autor registrada el 22 de septiembre en la bitácora. La arquitectura dual, la autenticación de operaciones y el ciclo de vida de claves mantienen su función técnica; cada aplicación debe definir y validar sus reglas de autorización y transición.

Esta ruta complementa el [Plan de Trabajo](Plan-de-Trabajo-TG2.md). Se concentra en TG2 y mantiene los documentos administrativos históricos de TG1 conforme al alcance aprobado. Las observaciones sobre componentes de TG1 se documentarán como límites de la validación de TG2, preservando la versión aprobada.

## 1. Orden de ejecución

| Paso | Prioridad | Resultado concreto | Correspondencia con el plan |
|---|---|---|---|
| R0. Actualizar seguimiento | Inmediata | Estado real de acuerdos, fechas, entregas y repositorios | E0 |
| R1. Revisar la validación formal | Crítica | Capítulo 6 con argumentos corregidos y fuentes precisas | E2, componente formal |
| R2. Cerrar el monitor de entropía | Crítica | Parámetros justificados y recuperación ante fallo definida | E1, actividad 3.1 |
| R3. Cerrar rotación y auditoría | Crítica | Cambio efectivo de claves y registro verificable de épocas | E1, actividad 3.2 |
| R4. Consolidar evidencia experimental | Alta | Resultados reproducibles y alcance del PoC delimitado | E2, componente empírico |
| R5. Formalizar residencia y métrica W | Alta | Contribución con modelo de amenaza y mediciones coherentes | E3, C1–C2 |
| R6. Preparar entrega y defensa | Final | Manuscrito TG2 consolidado, paquete de evidencia y presentación | E4 |

R0 acompaña todo el proceso: la revisión bibliográfica y el inventario de evidencia pueden avanzar mientras se actualizan acuerdos. R1 y R2 pueden avanzar de forma independiente. R3 requiere la política de salud de R2; su afirmación de anclaje verificable depende también de R4. R6 requiere cerrar los criterios anteriores.

Las fechas se fijarán con la disponibilidad real y los acuerdos del director. Esta ruta no presupone que los pendientes administrativos del 7 de agosto sigan vigentes fuera del repositorio.

## 2. R0 — Actualizar seguimiento y preservar evidencia

**Accesos:** [Pendientes](../../PENDIENTES.md), [Bitácora](../../BITACORA_TG2.md), [Entrega parcial 01](Avances/Entrega-Parcial-01-2026-08-07.md), [Brief del director](Estado-del-Proyecto-para-Director.md).

- [x] Registrar la aprobación comunicada por el estudiante el 22 de septiembre. La fecha del acuerdo y su soporte escrito siguen por incorporar.
- [ ] Actualizar el estado de F0, las fechas de E0–E4 y la revisión de la entrega parcial; diferenciar borrador preparado, envío realizado y aprobación recibida.
- [x] Consolidar los cambios y experimentos TG2 en el commit de código `01dcde960402b6c60a19242b7ae3d6ac3d82a518`. El análisis matemático conserva esa revisión y sus fuentes; el [manifiesto vigente](Entrega-Final/version-tg2.json) identifica el checkout de código utilizado en la consolidación del 12 de octubre; el commit documental que lo contiene identifica la edición.
- [x] Crear la [matriz de trazabilidad TG2](../05-Estado-del-Arte/Resumenes-y-Matriz/Matriz-Trazabilidad-TG2.md) con 23 afirmaciones/requisitos, fuentes, evidencia y acción pendiente.
- [x] Clasificar las afirmaciones centrales como resultado citado, derivación, medición, supuesto, implementación o diseño.
- [x] Preservar 125 archivos y 29 casos Criterion con hashes y estado Git en el [inventario](../06-Evidencia-TG2/2026-09-22/inventario.json); conciliar las corridas y versionar los experimentos sigue pendiente.

**Cierre:** cada entrega tiene responsable, fecha o dependencia explícita, y estado respaldado. La revisión de código usada por los experimentos queda identificada. La matriz cubre las afirmaciones centrales de los Objetivos 3 y 4.

## 3. R1 — Revisar la validación formal (Objetivo 4.1)

**Accesos:** [Capítulo 6](../01-Manuscrito/Capitulos/Cap6-Validacion-Formal.md), [Bibliografía](../01-Manuscrito/Capitulos/_tesis-bibliografia.md).

- [x] Identificar el perfil ML-DSA puro, hedged y de contexto vacío; distinguir las plantillas, algoritmos finales y backend fips204 0.4.6.
- [x] Corregir el argumento del antiguo Lema 6.2: dos firmas distintas del mismo mensaje no tienen necesariamente el mismo compromiso ni el mismo reto. El lema algebraico revisado declara sus hipótesis.
- [x] Explicitar las pérdidas, consultas y términos de B+23; reproducir su escenario de referencia y retirar el uso local injustificado de la cifra `2^-254` si no se deriva para las condiciones declaradas.
- [x] Cotejar B+23 Teoremas 2–4 y §6: distinguir simulación QROM y mecanización ROM; registrar las diferencias pendientes con ML-DSA final.
- [x] Separar los supuestos y cotejar LS15; calcular el incumplimiento de la condición de JMW24 en los tres perfiles. No instanciar reducciones cuyas hipótesis no se han verificado.
- [x] Formular la discusión de Shor sin presentar su no aplicabilidad directa como demostración general de dureza cuántica.
- [ ] Hacer una revisión matemática con el director o un lector competente, registrando observaciones y resolución.

**Fuentes iniciales:** [Barbosa et al., CRYPTO 2023](https://doi.org/10.1007/978-3-031-38554-4_12), que corrige lagunas en pruebas de seguridad de Dilithium; [Jackson, Miller y Wang](https://arxiv.org/abs/2312.16619), sobre dureza de SelfTargetMSIS en QROM bajo condiciones concretas; [FIPS 204](https://csrc.nist.gov/pubs/fips/204/final), para la especificación del esquema implementado.

**Cierre:** cada teorema central tiene fuente exacta y condiciones verificadas, o una demostración propia revisada. Toda garantía que exceda la evidencia se limita explícitamente. No es necesario producir un nuevo teorema criptográfico para cerrar esta actividad.

**Registro de la revisión inicial:** §6.4 corregido y fuentes precisadas. El término `2^-254` se localizó en DIL21, §6.2, ec. (6), nota 5; se retiró su atribución injustificada al prototipo. Se documentaron las correcciones de 2023 y las restricciones de la reducción QROM. La correspondencia completa con ML-DSA, sus pérdidas y la revisión matemática externa permanecen abiertas.

**Avance R1 posterior del mismo día:** cinco publicaciones primarias y la hoja oficial de erratas conservadas; perfil y parámetros cotejados, pérdida de referencia reproducida y aplicación directa de JMW24 descartada numéricamente. Check/build y 166 pruebas pasan. [Informe y obligaciones R1-A–E](Avances/R1-Correspondencia-Formal-2026-09-22.md). La revisión externa sigue pendiente.

## 4. R2 — Cerrar el monitor de entropía (Objetivo 3.1)

**Accesos:** [Decisión 001](../02-Investigacion-y-Notas/Decision-001-Parametros-APT.md), [entropy.rs](../../nexus/nexus-crypto/src/entropy.rs), [apt_sweep.rs](../../nexus/nexus-crypto/examples/apt_sweep.rs), [Capítulo 5](../01-Manuscrito/Capitulos/Cap5-Gestion-Claves.md).

- [x] Especificar el flujo observado y los límites del generador del sistema operativo: §5.3 y el informe R2 diferencian muestras aportadas por la aplicación, CSPRNG y ruido físico.
- [x] Precisar W=512, C=16 y lote de 65.536; conteo incluye referencia y fallo al alcanzar el corte. La frecuencia máxima es una estimación puntual, sin el límite de confianza MCV completo.
- [x] Sustituir la aproximación normal por la suma binomial y justificar su cola bajo el modelo declarado.
- [x] Bloquear ante ausencia de evaluación, insuficiencia inicial y fallo; recuperación con nuevo lote y renovación de semilla, conservando contadores al rotar.
- [x] Incorporar y ejecutar pruebas de límites, fallo, bloqueo y recuperación: 13 nuevas; suite completa 123/123.
- [x] Actualizar el capítulo con parámetros, supuestos y límites; las latencias históricas del barrido no se presentan como nueva medición.
- [ ] Para un despliegue concreto, vincular el flujo observado con la fuente utilizada y documentar su calificación y margen.

**Avance posterior del 22 de septiembre:** implementación del monitor del prototipo verificada. [Informe R2](Avances/R2-Monitor-Entropia-2026-09-22.md) y [evidencia de ejecución](../06-Evidencia-TG2/2026-09-22/R2-monitor/ejecucion.json). La calificación física de una fuente y la integración de claves de R3 no se deducen de estas pruebas.

**Cierre:** la implementación coincide con la especificación, las probabilidades se justifican para el modelo seleccionado y las pruebas verifican fallo, bloqueo y recuperación. Queda explícito qué parte de la fuente se monitorea realmente.

## 5. R3 — Cerrar rotación y registro auditable (Objetivo 3.2)

**Accesos:** [Decisión 002](../02-Investigacion-y-Notas/Decision-002-Registro-Auditable-Rotaciones.md), [Gestor de claves](../../nexus/nexus-crypto/src/keypair.rs), [Capítulo 5](../01-Manuscrito/Capitulos/Cap5-Gestion-Claves.md).

- [x] Separar tres operaciones: reexpandir la misma clave por firma, derivar otra clave y cambiar la época vigente. La reexpansión desde la misma semilla no cambia la identidad criptográfica.
- [x] Especificar la política de firma cuando la fuente falla o vence una época, y aplicarla en los puntos de uso correspondientes.
- [x] Conectar la rotación de Sentinel con la actualización efectiva de claves, metadatos y política de verificación. Definir qué ocurre si falla un paso intermedio.
- [x] Implementar el registro de épocas con autenticación de eventos, orden verificable y recuperación del historial público tras reinicio, sin almacenar material secreto.
- [x] Definir cómo se verifican firmas históricas en la nueva API frente a intentos nuevos con una clave retirada; evitar que la revocación invalide indiscriminadamente el historial.
- [x] Distinguir la integridad de un log local de su anclaje externo: documentar qué protege frente a reescritura, truncamiento y restauración de un estado antiguo.
- [x] Probar el recorrido completo del gestor: creación de clave, firma, disparador de rotación, actualización de época, tratamiento de la clave anterior y comprobación del registro.

**Avance R3 — 22 de septiembre:** gestor y registro local implementados; check/build y 142 pruebas pasan, incluidas 19 nuevas. [Informe R3](Avances/R3-Rotacion-y-Registro-2026-09-22.md) y [evidencia](../06-Evidencia-TG2/2026-09-22/R3-rotacion/ejecucion.json). La recarga reconstruye el historial público. La atomicidad probada es en memoria.

- [ ] Integrar la custodia durable y recuperación del firmador, la API de épocas en el sequencer y el anclaje externo; depende de la validación de R4. No se atribuye inmutabilidad global al registro local.

**Cierre:** la rotación modifica las claves o la política operativa según la especificación, el registro refleja esos cambios y el comportamiento histórico está definido. Las garantías de anclaje se limitan a lo efectivamente validado en R4.

## 6. R4 — Consolidar experimentos y límites del PoC (Objetivo 4.2)

**Accesos:** [Capítulo 6](../01-Manuscrito/Capitulos/Cap6-Validacion-Formal.md), [Benchmarks](../../nexus/nexus-crypto/benches), [Throughput](../../nexus/nexus-crypto/examples/throughput_tps.rs), [STARK demo](../../nexus/nexus-zk/examples/stark_demo.rs), [Verificador](../../nexus/nexus-active/src/verifier.rs), [Enlace de raíces](../../nexus/nexus-active/src/pq_verifier.rs).

- [ ] Asociar cada tabla con revisión de código, fecha, equipo, sistema, toolchain, dependencias, comando, configuración y resultados originales disponibles. Marcar las mediciones históricas cuyo resultado original no se conserve.
- [ ] Repetir las mediciones afectadas por cambios y las que no puedan sustentarse con evidencia suficiente. Reportar repeticiones y dispersión, además del valor central.
- [x] Revisar el harness multinúcleo, incluido el inicio coordinado de los trabajadores y el intervalo realmente medido. Etiquetar los resultados como verificaciones de firmas por segundo.
- [x] Separar pasos del AIR demostrativo, transacciones completas y verificaciones de ML-DSA. El PoC actual no prueba la ejecución completa de una aplicación ni la verificación de esas firmas dentro del STARK.
- [x] Revisar la aceptación heredada de `verify_zk`: no debe contabilizarse como validación STARK una aceptación basada solamente en el formato de entradas públicas.
- [x] Revisar el enlace de raíces: `encode_root` usa los primeros ocho bytes y los convierte al campo. La evidencia debe comprobar la vinculación de todos los bytes reclamados o restringir explícitamente el dominio y la garantía del PoC.
- [x] Documentar estas limitaciones en la validación TG2. Toda variante experimental correctiva debe preservar los entregables aprobados de TG1 y quedar identificada por separado.
- [x] Auditar el presupuesto de soundness, parámetros efectivos y requisitos de las fuentes; registrar el ensayo de proximidad y siete pruebas nuevas.
- [x] Desarrollar la reducción algebraica para una traza fija de grado menor que T (S1) y la transferencia condicional de distancia (S2).
- [x] Contrastar S2: la aceptación heredada no implica la proximidad propuesta; contraejemplo con distancia 7/8 y control exhaustivo TG2 reproducidos.
- [x] Especificar, implementar y probar una variante con raíz común para FRI de traza y AIR, dos recorridos FRI y transcripción propia; preservar corpus de ambos perfiles y tamaños comprobados.
- [x] Derivar la composición bajo oráculos ideales y retos uniformes, con unicidad del candidato, tratamiento de la extensión y cotas FRI por ronda; reproducir los nueve perfiles.
- [x] Auditar vinculación, codificaciones y distribución de Merkle/Fiat–Shamir mediante reconstrucción independiente del corpus y cuentas exactas.
- [x] Preparar el paquete de revisión S1–S3 y sus seis preguntas.
- [x] Escribir una función de estado y nuevas cotas por ronda del IOP conjunto en la rama de investigación, con lemas y contrastes finitos identificados.
- [x] Integrar la rama en `main` y escribir la transferencia clásica ROM para los bytes de TG2 v1, con pérdidas explícitas y 108 escenarios; completar la verificación Python de AIR/FRI del corpus.
- [ ] Revisar las demostraciones ideal y ROM, resolver o delimitar los parámetros de la garantía declarada y registrar dictamen independiente (S3–S5). QROM completo se conserva como trabajo futuro por decisión del autor.
- [x] Presentar la amortización como resultado condicionado al modelo, incluyendo disponibilidad de datos y costo del prover, con análisis de sensibilidad para los valores asumidos.

**Avance R4:** 160 pruebas pasan. Quince casos delimitan el verificador y tres comprueban la sincronización; 17 casos Criterion y 40 mediciones STARK se preservan con dispersión. La primera ejecución bloqueó ML-DSA y multinúcleo; el complemento terminó tras el cambio de Windows por el autor. Totales nuevos: 29 casos Criterion, 40 mediciones STARK y 40 repeticiones multinúcleo. La revisión de soundness y conciliación histórica sigue abierta. [Informe](Avances/R4-Verificador-y-Evidencia-2026-09-22.md).

**Avance integrado en main, 23 de septiembre:** [función de estado del IOP conjunto](Avances/Cierre-Matematico-2026-09-23/README.md) y [transferencia clásica ROM a TG2 v1](Avances/Transferencia-ROM-2026-09-23/README.md). Pasan 28 pruebas Python y 197 Rust, con check/build correctos. La demostración propuesta incluye extracción Merkle, canal, sesgo, nonces y cola de consultas. Requiere revisión independiente y no acredita 100 bits; QROM sigue abierto. Ese registro conserva la edición histórica. La consolidación del 12 de octubre integra los complementos en el manuscrito y en el nuevo Word de derivaciones, pendientes de dictamen.

**Registro de auditoría del 23 de septiembre:** auditoría Merkle/Fiat–Shamir terminada: reconstrucción independiente de 14 certificados, 560 consultas y 18.880 aperturas, sesgo exacto y obligaciones de compilación identificadas. Check/build y 197 pruebas repetidos. [Informe](Avances/R4-Merkle-Fiat-Shamir-2026-09-23.md) y [paquete de revisión preparado](Avances/Revision-Matematica-S1-S3-2026-09-23.md); no se registra envío ni dictamen.

**Registro de composición ideal:** derivación conservadora incorporada en §6.7.5 y Tabla 6.19. Para los cuatro tamaños tabulados, la cota superior ideal va de 0,052736 a 0,134071; no son tasas de ataque observadas ni garantías del ejecutable. Check/build y 197 pruebas repetidos correctamente. [Informe, hipótesis y cálculos](Avances/R4-Cota-Interactiva-2026-09-22.md).

**Registro de FRI vinculada:** 197 pruebas del workspace y diez nuevas también en release; check/build correctos. La variante experimental acepta ejecuciones honestas de 16–4096 filas en los tamaños ensayados y rechaza nuevas pruebas sobre los tres oráculos alejados conservados. Comparte raíz entre AIR y FRI de traza y no recibe el LDE completo. La cota estadística global y la revisión externa siguen pendientes. [Informe, formato y evidencia](Avances/R4-FRI-Vinculado-2026-09-22.md).

**Registro de proximidad:** 187 pruebas del workspace y siete nuevas también en release. Tres casos a distancia 7/8 son aceptados por el legado, con enunciados válidos, y rechazados por el control exhaustivo de referencia. La premisa propuesta queda refutada para esa ruta. [Informe, corpus y evidencia](Avances/R4-Proximidad-Traza-2026-09-22.md).

**Registro del avance algebraico:** 180 pruebas del workspace y siete algebraicas también en release; check/build correctos. Se caracterizan cancelación y distancia bajo hipótesis explícitas. La premisa de proximidad de la traza sigue abierta. [Argumento, evidencia y siguiente obligación](Avances/R4-Algebra-AIR-FRI-2026-09-22.md).

**Registro de auditoría de solidez:** 173 pruebas del workspace y siete casos nuevos también en release. La revisión entrega parámetros, ensayos, cálculos y obligaciones concretas; no acredita los 100 bits históricos. [Informe STARK](Avances/R4-Solidez-STARK-2026-09-22.md).

**Cierre:** otra persona puede reproducir las cifras principales; ninguna cifra de componentes se presenta como rendimiento de una blockchain completa. Las limitaciones del verificador quedan visibles en los resultados y en las garantías del registro de R3.

## 7. R5 — Formalizar residencia efímera y métrica W (C1–C2)

**Accesos:** [Capítulo 5](../01-Manuscrito/Capitulos/Cap5-Gestion-Claves.md), [Benchmark de residencia](../../nexus/nexus-crypto/benches/residencia_bench.rs), [Estado del arte](../02-Investigacion-y-Notas/Estado-del-Arte-Claves-Efimeras-y-Deception.md).

- [x] Definir qué puede observar o extraer el atacante, durante cuánto tiempo y con qué acceso a la semilla.
- [x] Separar bytes de material secreto, bytes públicos y memoria auxiliar; justificar qué componentes se cuentan en W.
- [x] Explicitar que obtener la semilla permite regenerar la clave. Una reducción de bytes residentes no implica por sí sola una reducción proporcional del riesgo de compromiso.
- [x] Distinguir las mediciones de latencia de las estimaciones de residencia. Documentar qué se mide y qué se deduce del modelo.
- [x] Formular la contribución como política, análisis y evaluación experimental, delimitando las garantías adicionales que requieran custodia protegida.
- [x] Sustentar la comparación con trabajos previos mediante fuentes y criterios de búsqueda. Mantener la novedad como conclusión acotada a la revisión realizada.

**Avance R5:** modelo de captura, inventario, sensibilidad y comparación acotada documentados. Tres pruebas nuevas; suite de 163. La residencia integral física y la custodia protegida no se declaran comprobadas. [Informe R5](Avances/R5-Residencia-y-Custodia-2026-09-22.md).

**Cierre:** las conclusiones de W se derivan de un modelo explícito y de mediciones trazables; reexpansión, rotación y protección de la semilla tienen funciones claramente diferenciadas.

Deception Engine y pagos agénticos permanecen como diseño o discusión complementaria según el alcance documentado. Su implementación no es requisito de cierre de esta ruta.

## 8. R6 — Consolidar entrega y sustentación

- [x] Actualizar los capítulos 5 y 6 y el balance de TG2 en las conclusiones utilizando la matriz de trazabilidad; reflejan el estado parcial actual.
- [x] Conservar los antecedentes administrativos de TG1. Incorporar los límites detectados como discusión de validación TG2 y actualizar el enfoque del manuscrito a sistemas en general por instrucción expresa del autor.
- [x] Sincronizar la edición de trabajo en Markdown, Word y PDF; comprobar tablas, contenido de celdas, rótulos, índices y paginación de la edición vigente. Formato editorial e instrucciones en el [README del manuscrito](../01-Manuscrito/README.md).
- [ ] Contrastar la entrega definitiva con una plantilla institucional específica si el programa la exige.
- [x] Preparar el [índice de entrega](Entrega-Final/README.md), código versionado, resultados originales, dependencias e instrucciones de reproducción; la retroalimentación académica posterior sigue pendiente.
- [x] Preparar el [balance de objetivos](Entrega-Final/Balance-Objetivos-TG2.md) y el [guion de sustentación](Presentaciones/Guion-Sustentacion-TG2.md), centrados en problema, alcance, contribución, evidencia y límites.
- [ ] Completar las diapositivas finales con la duración institucional y el dictamen recibido.
- [ ] Ensayar respuestas sobre QROM, supuestos de dureza, fuente de entropía, rotación, alcance del STARK y significado de W.

**Cierre:** E1–E4 cuentan con evidencia y el estado de revisión del director está registrado. Cada afirmación principal se puede localizar y defender sin depender de resultados pendientes.

## 9. Verificación al ejecutar la ruta

Para los cambios de código, ejecutar las comprobaciones requeridas por el proyecto (`cargo check --workspace`, `cargo test --workspace`, `cargo build --workspace`) y las pruebas específicas de los comportamientos modificados. Registrar fecha, revisión y resultado real. Los benchmarks se repiten cuando el cambio o la evidencia faltante lo justifique.

La revisión que originó esta ruta fue estática y documental. La primera sesión ejecutó el seguimiento, inventario, correcciones formales y edición indicados arriba. No se modificó Rust ni se ejecutaron pruebas o benchmarks nuevos. Los criterios técnicos de R1–R5 siguen abiertos.

**Siguiente ejecución:** solicitar y registrar el dictamen de las afirmaciones incluidas, resolver las observaciones que correspondan al alcance aprobado y preparar la defensa. El manuscrito y las derivaciones están consolidados y sus formatos revisados. Presentar QROM como resultados parciales y trabajo futuro. Su investigación se retomará por solicitud expresa del autor. R1 mantiene sus obligaciones propias; las integraciones de R3 y las garantías de custodia de R5 siguen delimitadas.
