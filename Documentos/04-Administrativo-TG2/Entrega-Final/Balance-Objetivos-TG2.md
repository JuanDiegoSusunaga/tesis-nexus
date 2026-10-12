# Balance de cumplimiento — Objetivos 3 y 4

**Fecha:** 12 de octubre de 2026. Balance técnico para revisar el cierre académico de TG2; conserva las obligaciones abiertas y el enfoque en sistemas en general.

**Decisión vigente del autor:** la transferencia QROM completa del protocolo AIR/FRI queda como trabajo futuro. Su conclusión no es un requisito de esta ruta de cierre; se conservan los resultados parciales y se declara el límite. R1 de ML-DSA mantiene sus obligaciones propias.

## Actividades y evidencia

| Actividad | Resultado disponible | Evidencia | Estado y límite |
|---|---|---|---|
| 3.1. Modelo y monitoreo de entropía | Modelo de min-entropía, RCT/APT, parámetros W=512/C=16, bloqueo y recuperación | [R2](../Avances/R2-Monitor-Entropia-2026-09-22.md), capítulo 5 y pruebas de límites | Implementación comprobada sobre el flujo aportado por la aplicación; una fuente física de despliegue requiere vinculación y calificación |
| 3.2. Rotación y registro auditable | Cambio de claves operativas y épocas, autenticación del registro local y recuperación del historial público | [R3](../Avances/R3-Rotacion-y-Registro-2026-09-22.md), capítulo 5 y pruebas de fallos | Gestor y registro local comprobados; custodia durable, política en el sequencer y anclaje L1 pendientes |
| 4.1. Fundamentos formales de seguridad | Fuentes contrastadas, perfil ML-DSA identificado, condiciones y pérdidas explicitadas; argumento de Shor delimitado | [R1](../Avances/R1-Correspondencia-Formal-2026-09-22.md) y capítulo 6 | Correcciones documentadas; dictamen matemático pendiente. Las obligaciones R1-A–D condicionan una garantía concreta del código |
| 4.2. Complejidad y validación empírica | Análisis asintótico, comparativa clásica/ML-DSA, 29 casos Criterion, 40 mediciones STARK y 40 repeticiones multinúcleo | [R4](../Avances/R4-Verificador-y-Evidencia-2026-09-22.md), [complemento](../Avances/R5-Residencia-y-Custodia-2026-09-22.md) y capítulo 6 | Resultados de componentes reproducibles mediante sus fuentes y comandos; conciliación de algunas cifras históricas pendiente |

## Resultados complementarios que acompañan el balance

- Caracterización de aceptación heredada y recuperación del testigo del PoC; no se acredita conocimiento cero.
- Contraejemplo de proximidad con enunciado válido y control exhaustivo experimental.
- Variante TG2 que vincula FRI de traza con AIR mediante una raíz compartida, probada con casos honestos y oráculos alejados.
- Derivación conservadora en un modelo interactivo ideal y auditoría de correspondencia Merkle/Fiat–Shamir.
- [Derivación por rondas](../Avances/Cierre-Matematico-2026-09-23/README.md) y [transferencia clásica ROM al protocolo TG2 v1](../Avances/Transferencia-ROM-2026-09-23/README.md), integradas en `main`: demostraciones propuestas, 108 escenarios exactos y verificación independiente completa de 14 certificados. Revisión externa pendiente; QROM y 100 bits no acreditados.
- Inventario de representaciones y modelo de residencia W; la política de reexpansión se evalúa en un benchmark y no está integrada en el gestor.
- [Muestreo QROM y reducción condicional al verificador](../Avances/Muestreo-QROM-2026-09-23/README.md), apoyados en las etapas de PoW y extracción sin orden: 72 presupuestos, 28 recorridos, 80 pruebas Python y 197 Rust, check/build. Falta demostrar la cota β de omisión o cola y revisar la reducción; no constituye una garantía cuántica completa.
- [Cota cuántica de cola por conteo](../Avances/Cola-QROM-2026-09-23/README.md), como continuación: 144 perfiles, 16 con cota menor que uno al ampliar el corte del análisis; 96 Python y 197 Rust, check/build. La demostración requiere dictamen y la omisión permanece abierta. Los exponentes de cola no acreditan bits de seguridad del protocolo.

Las **197 pruebas** comprueban comportamientos del software en los casos ensayados. Los teoremas citados, las derivaciones y las garantías de despliegue tienen sus propias hipótesis; el conteo de pruebas no las sustituye.

## Pendientes que requieren decisión de alcance

La [revisión crítica interna posterior](../Avances/Revision-Critica-ROM-2026-09-23/README.md) amplía la prueba de nonces mediante potencial y añade 96 escenarios pequeños. Pasan 40 pruebas Python y 197 Rust. La fórmula ROM se conserva; el resultado sigue pendiente de revisión externa y del estudio de parámetros para una garantía cuantitativa.

La [primera etapa QROM](../Avances/QROM-2026-09-23/README.md) añade una reducción explícita basada solo en la condición de trabajo, con 108 perfiles y doce pruebas nuevas; pasan 52 Python y 197 Rust. La cota es débil y no incorpora AIR/FRI. Se identifican las obligaciones Q1–Q5 de extractor, muestreo, composición y pérdidas antes de declarar una garantía cuántica completa.

El [avance posterior de extracción QROM](../Avances/Extractor-QROM-2026-09-23/README.md) propone el extractor sin orden, su lema de estabilidad y una cota de escapes algebraicos en base comprimida. Catorce pruebas adicionales elevan el total a 66 Python y 197 Rust. La nueva cota describe un evento intermedio: falta controlar índices/nonces y demostrar el paso a aceptación falsa real. Ambos suplementos requieren dictamen independiente.

| Tema | Acción concreta | Condición de cierre |
|---|---|---|
| Revisión formal R1 | Registrar revisor, observaciones y resolución de las correcciones | Dictamen del director o lector competente |
| Argumentos S1–S3 | Resolver M1–M6 para las afirmaciones incluidas; la extensión QROM de M5 queda en trabajo futuro | Dictamen y decisión sobre suficiencia para el alcance aprobado |
| Garantía concreta del ejecutable | Si se exige, completar correspondencia R1 y revisar las demostraciones por rondas y ROM | Dictamen sobre hipótesis y pérdidas; parámetros suficientes para la garantía declarada, sin atribuir QROM completo |
| Transferencia QROM de AIR/FRI | Conservar avances y obligaciones de omisión, revisión y parámetros como investigación futura | Fuera del cierre activo por decisión del autor; retomar cuando lo solicite |
| Despliegue de claves | Si se afirma protección operativa completa, integrar fuente, custodia durable, épocas y anclaje | Evidencia de integración y recuperación bajo el modelo declarado |
| Protección física de residencia | Si se afirma reducción efectiva de exposición, observar copias/residuos y proteger semilla | Medición de la frontera declarada y política implementada |
| Series históricas | Conciliar revisión, condiciones y cifras donde faltan metadatos | Procedencia identificada o limitación histórica conservada |

Estas obligaciones no se convierten automáticamente en nuevas actividades obligatorias del trabajo de grado. El director debe resolver su relación con el alcance aprobado; hasta entonces las conclusiones mantienen los límites explícitos.

## Preparación documental

La edición del 12 de octubre integra la revisión de las afirmaciones heredadas, la solidez por rondas, ROM clásico y la revisión de nonces en el manuscrito y en el suplemento consolidado. Resúmenes, conclusiones y guion distinguen esa integración del dictamen pendiente. Pasan 197 pruebas Rust, check/build y 30 pruebas Python de los complementos; diez pruebas adicionales verifican el comprobador de edición. [Cambios y alcance](../Avances/Consolidacion-Manuscrito-TG2-2026-10-12.md).

El manuscrito dispone de una edición por formato, tablas y figuras revisadas y evidencia por etapa. El [índice de entrega](README.md) reúne los accesos y el manifiesto identifica los archivos. El [guion de sustentación](../Presentaciones/Guion-Sustentacion-TG2.md) está preparado; las diapositivas finales, el ensayo y el registro de entrega siguen pendientes.
