# Solicitud de revisión matemática — Tesis NEXUS

**Fecha de preparación:** 20 de octubre de 2026.
**Destinatario:** Director de la tesis, confirmado por el autor.
**Estado:** Sin dictamen registrado. No se han registrado envío ni recepción.

## Propósito y alcance

Se solicita revisar la correspondencia entre los enunciados de la tesis, sus hipótesis y las demostraciones, y decidir si la delimitación de resultados es suficiente para el alcance académico acordado. La preparación de este paquete, las comprobaciones internas y la compilación de Lean no se presentan como revisión externa ni aprobación.

Se conservan las seis preguntas M1–M6 de la solicitud original; no se añaden teoremas obligatorios ni se reabren pruebas del modelo ya cubiertas. Estos identificadores son preguntas al director, no los grupos M01–M46 de la matriz de formalización. QROM de AIR/FRI y Qiskit/Aer permanecen como trabajo futuro; no bloquean esta revisión activa. Las condiciones bibliográficas y de implementación de las firmas siguen distinguiéndose del resultado AIR/FRI.

## Material vigente y orden de lectura

1. [Tesis final y formatos de lectura](../../01-Manuscrito/README.md): [Word](../../01-Manuscrito/Tesis-NEXUS-completa.docx) y [PDF](../../01-Manuscrito/Tesis-NEXUS-completa.pdf), revisados el 20 de octubre, con 115 y 103 páginas. No se regeneran para preparar esta solicitud.
2. [Introducción y objetivos originales](../../01-Manuscrito/Capitulos/Cap1-Introduccion.md) y [conclusiones y límites](../../01-Manuscrito/Capitulos/Cap7-Conclusiones.md). El componente de reducción concreta de seguridad de las firmas se declara parcialmente cumplido; la cota ROM de AIR/FRI no lo sustituye.
3. [Capítulo de validación](../../01-Manuscrito/Capitulos/Cap6-Validacion-Formal.md): §6.4 para las firmas; §§6.7.2–6.7.4 para álgebra, contraejemplo y vínculo; §§6.7.5 y 6.7.8 para el modelo ideal; §6.7.9 para el resultado ROM conservador; §6.7.10 para sus exclusiones.
4. [Estado de la formalización](../../../formalizacion/README.md), [matriz de resultados y límites](../../../formalizacion/REVISION-MANUSCRITO.md) y [ensamblaje causal](../../../formalizacion/Nexus/Verificador/PuenteAdaptativoFinal.lean). Las descripciones históricas de la matriz deben leerse con su actualización vigente, no como nuevas pruebas pendientes.
5. [Cotas finales con trabajo](../../../formalizacion/Nexus/Verificador/CotaTrabajoFinal.lean), teoremas cota_512 y cota_512_todos; [ejemplos enlazados con aceptación](../../../formalizacion/Nexus/Verificador/CotaTrabajoNumerica.lean), teoremas aceptacion_4096_release y aceptacion_release.
6. [Auditoría global Lean del 20 de octubre](../../06-Evidencia-TG2/2026-10-20/Lean-Global/verificacion.json) y [fuentes consolidadas localmente](../../06-Evidencia-TG2/2026-10-20/Consolidacion-Lean/preparacion.json). La auditoría registra 2709 declaraciones, sin sorryAx ni axiomas fuera de propext, Classical.choice y Quot.sound. No acredita por inferencia toda afirmación de la tesis.
7. [Adaptación Rust](../../06-Evidencia-TG2/2026-10-20/Rust-Lean/adaptacion.json), [integración ActiveChain](../../06-Evidencia-TG2/2026-10-20/ActiveChain/integracion.json) y [global final Rust](../../06-Evidencia-TG2/2026-10-20/Rust-Global-Final/verificacion.json): check, 223 pruebas y build correctos, conservando advertencias. Son evidencia de software, no una prueba de refinamiento universal.

Base de fuentes comprobada: commit documental df1eeae3fe026d3f47aa3e88b510489abd98845d y commit Rust 637e77c99e804664915caf4ed928a10ef81cc870. Esta solicitud es una preparación local posterior; no se atribuye a ese commit un documento todavía no confirmado. El [manifiesto de la base comprobada](../../06-Evidencia-TG2/2026-10-20/Preparacion-Revision-Director/respaldo_previo/Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json) conserva sus huellas; el manifiesto vigente de Entrega-Final incorpora esta preparación sin autorreferencia. Las revisiones locales no se dan por publicadas en un servidor.

## Resultado central que se pide revisar

La probabilidad se refiere a la aceptación de un certificado con enunciado inválido según la relación matemática EnunciadoValido, no a una falsificación de ML-DSA ni a la validez completa de transacciones de una aplicación.

| Elemento | Hipótesis o valor del resultado |
|---|---|
| Experimento | Un único ROM clásico finito de digests de 256 bits, compartido por Merkle, canal, trabajo e índices; las respuestas repetidas conservan memoria |
| Adversario | Programa finito adaptativo; como máximo Q llamadas adversarias en toda ejecución compatible, incluidas preparación, nonces e intercalaciones; sin información correlacionada omitida del experimento |
| Perfiles | T = 2^k, con 4 ≤ k ≤ 12; N = 8T; M = 2^(k+2) parejas; cuarenta consultas compartidas por AIR y ambas FRI |
| Trabajo y selector | bits = 12 o 20; como máximo R = 512 extracciones, incluidos duplicados, antes de rechazar si no se obtienen cuarenta índices distintos |
| Presupuesto común | B = Q + 24895, derivado del programa, sin identificar B con la altura del árbol |
| Registro auxiliar | L es el límite de marcas adicionales del registro ROM; no es el tamaño del certificado |
| Excepciones | Bad y AIR/FRI se cobran una sola vez; el conjunto excepcional previo tiene cardinal a lo sumo 130709 e incluye el sesgo de transporte a Goldilocks |
| Trabajo adaptativo | A lo sumo Q+1 parejas estado/nonce; factor 2^(-bits) compuesto antes de conocer las respuestas, sin condicionar al nonce ganador |
| Perfil final adaptativo | Solo se suma el riesgo del selector sobre k = 4,…,12, manteniendo un único cargo para las excepciones |

Se solicita cotejar las dos fórmulas completas de §6.7.9 con las definiciones selector, cota512 y cota512Todos de CotaTrabajoFinal. Incluyen la hipergeométrica, la cola 2^(-300), el error min{1, 512(B+515)/2^256} y el truncamiento final por uno. No deben sustituirse por la fórmula histórica más ajustada ni por una suma informal de bits de seguridad.

Ejemplos a revisar con sus premisas: L = 1000000, k = 12, bits = 20 y Q = 2^20 dan una cota de aceptación falsa menor que 0,004757335454; para todos los perfiles, L = 1000000, bits = 20 y Q = 1000000 dan una cota menor que 1/20. Son límites superiores del modelo, no tasas observadas ni probabilidades necesariamente alcanzables por un ataque.

## Seis preguntas para el dictamen

| ID | Pregunta que se conserva | Localización y puntos de atención |
|---|---|---|
| M1 | ¿Son correctas la divisibilidad, las cotas de grados, cancelación y distancia, bajo las hipótesis declaradas? | §6.7.2; [grados válidos](../../../formalizacion/Nexus/AIR/GradosValidos.lean), [cancelación sesgada](../../../formalizacion/Nexus/AIR/CancelacionSesgada.lean) y [cota de distancia](../../../formalizacion/Nexus/N02/Solucion.lean). Distinguir el reto uniforme ideal del transporte de bytes y una traza inválida de un enunciado falso. |
| M2 | ¿La unicidad y elección previa del candidato próximo están justificadas sin depender de retos futuros? | §§6.7.4–6.7.5; [unicidad](../../../formalizacion/Nexus/N03/Solucion.lean), [candidato](../../../formalizacion/Nexus/N06/Candidato.lean) y [conjuntos causales previos](../../../formalizacion/Nexus/Verificador/ConjuntosPrevios.lean). Revisar distancia RS, campo base/extensión y selección a partir del pasado. |
| M3 | ¿Son válidas las cotas FRI locales y por rondas, con sus grados, dominios y término final? | §§6.7.5 y 6.7.8; [experimento FRI](../../../formalizacion/Nexus/FRI/Experimento.lean), [cota FRI causal](../../../formalizacion/Nexus/Verificador/CotaFRICausal.lean) y [cota de rondas](../../../formalizacion/Nexus/Verificador/CotaAdaptativaFinal.lean). No atribuir una ley independiente a retos adaptativos sin el transporte demostrado. |
| M4 | ¿La composición AIR/doble FRI y la consulta compartida justifican la descomposición final sin doble cobro? | §§6.7.8–6.7.9; [cardinal de la vista](../../../formalizacion/Nexus/Verificador/CardinalVista.lean), [cota de reconstrucción](../../../formalizacion/Nexus/Verificador/CotaSinBad.lean) y CotaTrabajoFinal. Revisar el evento de exceso, el estado absorbente, preconsultas y memoria; no sustituir la muestra común por dos muestras independientes. |
| M5 | ¿El teorema ROM conservador cubre el adversario y presupuesto declarados, incluidos trabajo, perfiles y reinicios? | §6.7.9; [presupuesto real](../../../formalizacion/Nexus/Verificador/PresupuestoGlobal.lean), [masa del trabajo](../../../formalizacion/Nexus/Verificador/TrabajoDigest.lean), [cobertura por primeras parejas](../../../formalizacion/Nexus/Verificador/CoberturaTrabajo.lean), CotaTrabajoFinal y CotaTrabajoNumerica. Revisar el cargo Q+1, el error de acoplamiento y la ausencia de condicionamiento al nonce ganador. La parte QROM de la pregunta original queda diferida. |
| M6 | ¿La separación entre resultados probados, resultados bibliográficos, evidencia empírica y límites es suficiente para el alcance académico acordado? | Objetivos originales, §6.4 y conclusiones. Decidir qué afirmaciones condicionales se aceptan, cuáles deben corregirse o retirarse y cuáles exigirían ampliar el alcance. No convertir por defecto refinamiento universal, despliegue o QROM en nuevos módulos obligatorios. |

Las seis preguntas permanecen pendientes del director. Las referencias facilitan su revisión; no constituyen respuestas atribuidas a él.

## Fronteras que el dictamen debe conservar o modificar expresamente

- La prueba ROM es del verificador matemático de bytes. No establece equivalencia universal de Rust, sus codecs, instrucciones de máquina o SHA3 determinista con el modelo ideal.
- La ruta Rust activa aplica el corte de 512 y exige contexto externo; ActiveChain lo toma de instantáneas locales antes del registro de envíos. El AIR sigue siendo una recurrencia escalar: las raíces SHA3 generales fuera del modelo se rechazan. Los positivos sintéticos no acreditan una L2 completa, consenso o persistencia.
- Las reducciones de firmas citadas no se convierten en una garantía concreta de inforjabilidad del ejecutable por el resultado AIR/FRI. Las garantías de entropía física, custodia y eliminación de secretos conservan sus condiciones.
- Los límites de procedencia H1/H2 no se resuelven mediante una prueba aritmética ni con la caché recuperada. Los conteos de pruebas de distintas ejecuciones no se suman.
- No se acreditan 100 bits, conocimiento cero, QROM completo, aprobación académica ni envío. La aprobación anterior del plan no se atribuye a estas demostraciones posteriores.

## Formato de respuesta solicitado

Para cada pregunta, registrar:

- Identificador M1–M6 y enunciado o pasaje exacto revisado.
- Nombre del revisor, fecha y relación con la tesis.
- Juicio: aceptable en su alcance, requiere corrección, no aceptable o no revisado.
- Hipótesis que deben permanecer explícitas y observaciones justificadas.
- Corrección concreta o decisión de alcance solicitada, cuando corresponda.
- Resolución posterior y evidencia del cambio, sin marcar cierre antes de atender la observación.

La valoración de cada pregunta se distingue de una aprobación global de la tesis. El envío, recepción y dictamen se registrarán cuando realmente ocurran; esta preparación no los anticipa.

## Antecedentes conservados

La solicitud original, con su estado anterior, se preserva en el [respaldo previo](../../06-Evidencia-TG2/2026-10-20/Preparacion-Revision-Director/respaldo_previo/Documentos/04-Administrativo-TG2/Avances/Revision-Matematica-S1-S3-2026-09-23.md). Los [suplementos de derivaciones](Derivaciones-Matematicas-TG2-2026-10-12.md), el [catálogo de afirmaciones](Catalogo-Validacion-2026-10-12/README.md) y la [revisión interna por potencial](Revision-Critica-ROM-2026-09-23/README.md) son material de apoyo histórico, no sustitutos de la tesis y la formalización vigentes. Sus descripciones de pasos abiertos se interpretan en su fecha; no reabren el cierre posterior del modelo.

Los complementos QROM permanecen archivados en sus carpetas de investigación, fuera de la lectura necesaria para resolver M1–M6 en el cierre activo.
