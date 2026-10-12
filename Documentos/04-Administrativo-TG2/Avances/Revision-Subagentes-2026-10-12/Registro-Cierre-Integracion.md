# Registro de cierre interno e integración documental

**Fecha:** 12 de octubre de 2026. **Estado:** revisiones internas integradas en la edición de trabajo; Word y PDF regenerados y verificados por el coordinador y los subagentes. No se registra dictamen académico, envío ni aprobación del director. La sustentación permanece aplazada. La investigación QROM completa de AIR/FRI no se reabre.

## Qué cierra esta revisión

Se completaron tres lecturas internas con fuentes primarias web y evidencia conservada: [R1](Revision-R1.md), [AIR/ROM](Revision-AIR-ROM.md) y [evidencia experimental](Revision-Evidencia.md). Las hipótesis y correcciones quedan localizadas y contrastables. El cierre interno del análisis no declara implementadas las correcciones de flujo ni aprobados los teoremas.

Las 451 comprobaciones del [conciliador](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/Evidencia/conciliacion.json) verifican integridad y estadísticas preservadas. Se conservan 29 casos Criterion, 40 mediciones STARK y 40 repeticiones multinúcleo; esas cantidades no se suman como corridas independientes de un ataque. La cola de 512 extracciones se cuenta exactamente en [nueve perfiles](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/AIR-ROM/contrastes-exactos.json): contrasta el muestreo ideal, no mide probabilidad de falsificación real ni aporta bits de seguridad global.

## Precisiones documentales de la integración actual

Esta tabla describe el contenido de la integración coordinada; los informes de los subagentes son los antecedentes inmutables de sus recomendaciones. La identificación final y sus comprobaciones están registradas en la evidencia de consolidación.

| Observación | Precisión que se integra | Lo que continúa abierto |
|---|---|---|
| R1-I1, mapa de Cap.6 | Fundamentos y límites de seguridad postcuántica; aplicabilidad de reducciones publicadas; inforjabilidad como requisito de autorización. | Una demostración concreta completa del ejecutable y su suficiencia académica. |
| R1-I2, Cap.4 | Adopción de perfiles ML-DSA definidos en FIPS204, con conformidad del conjunto no acreditada. | Conformidad independiente, fuente y comportamiento extremo. |
| R1-I3, Cap.4/5 | Separación entre muestras monitoreadas como compuerta y semilla retenida derivada con SHA3; creación y rotación mediante OsRng. | Calificación de fuente/KDF y composición Sentinel. |
| R1-I4, Cap.4/6 | Ruta bincode→SHA3-256→ML-DSA puro; resistencia del hash externo y codificación como obligaciones propias. | Trasladar automáticamente la fuerza de ML-DSA-65/87 al contenido de transacciones, o cambiar el protocolo. |
| Actualización FFH, Cap.6/bibliografía | Mejora publicada de CMA→NMA, con hipótesis y versión CWI examinada; B23 conserva su versión reproducida. | SelfTargetMSIS, sUF, expansores, semillas y perfil hedged del ejecutable. |
| R1-D, descripción del límite | Condiciones de desbordamiento del contador u16 y localizadores; no se confunden con un ataque o una semilla observada. | Límite admisible y propagación de error antes del desbordamiento; comportamiento exacto según build. |
| Evidencia, §6.6 | Razones compatibles con el modelo en tres niveles; evitar inferencia causal de hardware o demostración asintótica por unas mediciones. | Comparaciones causales, entre días y capacidad de aplicación completa, si el alcance las requiere. |
| Unidades y rutas STARK, Cap.3/6 | KB decimales frente a KiB; identificar el STARK heredado que efectivamente midió el harness. | Latencia de TG2 v1 vinculada, que estos datasets no midieron. |
| Diferencia de medianas, Cap.5/6 | Usar valores fuente y redondear al final: 151,33 µs; conservar limitación de comparación no pareada. | Duración física de todas las regiones secretas y probabilidad de captura. |
| H1/H2 y nueva conciliación | R4 y complemento reproducidos; 77,6 µs publicado y 77,170 µs recuperado permanecen registros diferentes. | Identificación inequívoca de muestras/comandos/revisión de cada corrida histórica. |
| AIR/ROM A1–A2, §6.7.7 | Resultados históricos de 100 bits, suma de grinding y resistencia global del hash no constituyen garantía TG2. La delimitación se incorpora al manuscrito sin tocar Rust. | No cambiar instantáneas ni TG1 aprobado; los comentarios históricos del código no constituyen un dictamen. |
| AIR/ROM A3/A6 y fuentes | GMW de marzo permanece fijado; Lean FRI externo es recurso condicionado, sin mecanización de NEXUS. | Contraste integral del PDF GMW posterior cuando sea accesible; formalización propia si se solicita. |

Los originales TG1 y los paquetes de septiembre se preservan. Los cambios de redacción no convierten un objetivo histórico en una garantía acreditada. Las verificaciones comunes están en [Rust](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/Consolidacion/codigo.json) y [Python/catálogo](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/Consolidacion/python.json); la revisión final de Word/PDF y el manifiesto se registran por el coordinador.

## M1–M6: estado académico conservado

El [paquete para revisión matemática](../Revision-Matematica-S1-S3-2026-09-23.md) mantiene su registro de resolución separado.

| ID | Resultado disponible | Pendiente |
|---|---|---|
| M1 | Divisibilidad, residuos, cancelación y distancia con hipótesis y ejemplos. | Dictamen sobre el argumento general y distinción traza inválida/enunciado falso. |
| M2 | Candidato único y caso no base revisados internamente; nueve perfiles contrastados. | Dictamen de unicidad y selección previa al reto. |
| M3 | Lema elemental de acuerdo y remontada FRI, con consulta distinta y constante final. | Dictamen de lemas A–B, radios y correspondencia de recorridos. |
| M4 | Estado absorbente y selección de un control activo; consulta compartida cobrada una vez. | Dictamen de composición ordinaria y por rondas para historias adaptativas. |
| M5 | Extracción por registro, oráculo único, coincidencia de 65 bytes, potencial y cola revisados internamente. | Dictamen ROM del protocolo concreto; QROM completo AIR/FRI se mantiene futuro. |
| M6 | Límites y alcance del resultado condicional identificados. | Acordar suficiencia académica y, si se exige garantía cuantitativa, presupuesto Q y probabilidad objetivo. |

La ausencia de contraejemplo en una revisión interna no cierra estas obligaciones. No se exige completar la investigación futura QROM para resolver el estado documental actual.

## R1-A–E: garantía concreta todavía separada

El [mapa R1 original](../R1-Correspondencia-Formal-2026-09-22.md) permanece como antecedente; la revisión nueva añade localizadores y fuentes.

| ID | Avance interno | Pendiente |
|---|---|---|
| R1-A | Backend y perfil puro/hedged/contexto identificados; seis archivos contrastados. | Correspondencia de oráculos, expansores desde semilla, distribuciones y pérdidas. |
| R1-B | Codificaciones y SelfTargetMSIS situados; JMW24 no aplica directamente a los parámetros actuales. | Puente a ML-DSA final, pistas/reto y sUF-CMA; composición del hash externo. |
| R1-C | Fuente monitoreada como compuerta diferenciada de la derivación de semillas retenidas. | Justificación de fuente/KDF, custodia y composición con rotación. |
| R1-D | Contador y primeros extremos u16 caracterizados, sin estimar probabilidad ni ejecución patológica. | Terminación segura y error propagado; corrección de implementación y pruebas pertinentes si se autoriza. |
| R1-E | Informe y evidencias preparados. | Observaciones y resolución documentadas por director o lector competente. |

FFH mejora un paso de la literatura QROM de firmas; eso no cambia la decisión de mantener QROM AIR/FRI futuro ni resuelve las demás filas R1.

## H1/H2 y nuevas mediciones

La conciliación **de clasificación y estadísticas R4** queda realizada. La recuperación de la corrida histórica exacta H1/H2 permanece abierta: mtime, equipo coincidente, cercanía numérica o un HEAD posterior no autentican qué revisión produjo cada dato. Una corrida de hoy no reconstruye una corrida de julio/agosto.

No es necesario repetir R4, su complemento o R5 para conservar sus resultados documentados. Una medición nueva solo sería necesaria para una afirmación nueva: rendimiento TG2 v1, comparación causal, residencia física o capacidad completa de la aplicación. Su inclusión depende del alcance; no se presenta como requisito añadido por estos subagentes.

## Registros que faltan para cierre académico

Registrar revisor, fecha, observaciones, correcciones y resolución de M1–M6/R1-E; acordar suficiencia de los resultados condicionales y del alcance operacional; comprobar formato institucional si se exige; y registrar entrega/aprobación reales. No se enviaron mensajes externos ni se preparó la sustentación. Este archivo no sustituye esas actuaciones.

## Edición final verificada

Word: 110 páginas, 34 tablas, 848 celdas comparadas, 565 objetos matemáticos nativos y 36 bloques. PDF: 98 páginas, sin páginas vacías ni texto fuera de márgenes. La revisión visual corrigió una palabra partida en Tabla 4.2 y una errata; el suplemento se conserva sin cambios. [Identificación](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/Consolidacion/revision-manuscrito.json) y [cobertura visual](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/Consolidacion/inspeccion-visual.json). Los 176 archivos protegidos siguen íntegros. El código permanece en c5c466c6350e4ff06d04d27ed68b029095c7aec8. La integración documental concluye; el dictamen académico sigue pendiente.
