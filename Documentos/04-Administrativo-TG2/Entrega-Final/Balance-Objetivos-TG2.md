# Balance de cumplimiento — Objetivos 3 y 4

**Fecha:** 23 de septiembre de 2026. Balance técnico para revisar el cierre académico de TG2; conserva las obligaciones abiertas y el enfoque en sistemas en general.

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
- Inventario de representaciones y modelo de residencia W; la política de reexpansión se evalúa en un benchmark y no está integrada en el gestor.

Las **197 pruebas** comprueban comportamientos del software en los casos ensayados. Los teoremas citados, las derivaciones y las garantías de despliegue tienen sus propias hipótesis; el conteo de pruebas no las sustituye.

## Pendientes que requieren decisión de alcance

| Tema | Acción concreta | Condición de cierre |
|---|---|---|
| Revisión formal R1 | Registrar revisor, observaciones y resolución de las correcciones | Dictamen del director o lector competente |
| Argumentos S1–S3 | Resolver las seis preguntas del [paquete M1–M6](../Avances/Revision-Matematica-S1-S3-2026-09-23.md) | Dictamen y decisión sobre suficiencia para el alcance aprobado |
| Garantía concreta del ejecutable | Si se exige, completar correspondencia R1 y propiedades por ronda/compilación ROM-QROM del protocolo conjunto | Hipótesis y pérdidas verificadas; la cota ideal ordinaria no basta |
| Despliegue de claves | Si se afirma protección operativa completa, integrar fuente, custodia durable, épocas y anclaje | Evidencia de integración y recuperación bajo el modelo declarado |
| Protección física de residencia | Si se afirma reducción efectiva de exposición, observar copias/residuos y proteger semilla | Medición de la frontera declarada y política implementada |
| Series históricas | Conciliar revisión, condiciones y cifras donde faltan metadatos | Procedencia identificada o limitación histórica conservada |

Estas obligaciones no se convierten automáticamente en nuevas actividades obligatorias del trabajo de grado. El director debe resolver su relación con el alcance aprobado; hasta entonces las conclusiones mantienen los límites explícitos.

## Preparación documental

El manuscrito dispone de una edición por formato, tablas y figuras revisadas y evidencia por etapa. El [índice de entrega](README.md) reúne los accesos y el manifiesto identifica los archivos. El [guion de sustentación](../Presentaciones/Guion-Sustentacion-TG2.md) está preparado; las diapositivas finales, el ensayo y el registro de entrega siguen pendientes.
