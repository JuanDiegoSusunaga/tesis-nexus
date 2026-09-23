# Ruta de estudio — Tesis NEXUS

**Actualización:** 23 de septiembre de 2026. Ocho sesiones sugeridas; ampliar la de validación formal según lo necesario. El dominio vigente es **sistemas en general**. El manuscrito, los informes de revisión y la matriz de trazabilidad gobiernan las afirmaciones que se llevan a la defensa.

## Sesión 0 — Alcance, objetivos y estado

Leer la [ruta de cierre](Documentos/04-Administrativo-TG2/Ruta-de-Cierre-TG2.md), el [balance de objetivos](Documentos/04-Administrativo-TG2/Entrega-Final/Balance-Objetivos-TG2.md) y la [bitácora](BITACORA_TG2.md).

- [ ] Explicar el problema de autenticación y ciclo de vida de claves en sistemas generales.
- [ ] Localizar los objetivos aprobados y la evidencia de las actividades 3.1, 3.2, 4.1 y 4.2.
- [ ] Identificar implementación, resultado medido, supuesto, derivación y trabajo futuro en una afirmación de cada tipo.
- [ ] Distinguir la aprobación previa comunicada por el autor del dictamen pendiente sobre las derivaciones posteriores.

## Sesión 1 — Motivación y fundamentos

Leer [Capítulo 1](Documentos/01-Manuscrito/Capitulos/Cap1-Introduccion.md) y [Capítulo 2](Documentos/01-Manuscrito/Capitulos/Cap2-Marco-Teorico.md), junto con las fuentes primarias indicadas en la [bibliografía](Documentos/01-Manuscrito/Capitulos/_tesis-bibliografia.md).

- [ ] Explicar el alcance de Shor sobre factorización y logaritmo discreto. Su no aplicación directa a los problemas de retículos no demuestra dureza cuántica general.
- [ ] Definir Module-LWE, Module-SIS y SelfTargetMSIS y localizar sus supuestos.
- [ ] Explicar el modelo de oráculo aleatorio y su variante cuántica.
- [ ] Diferenciar autenticación mediante firmas de confidencialidad mediante cifrado.

## Sesión 2 — Arquitectura de referencia

Leer [Capítulo 3](Documentos/01-Manuscrito/Capitulos/Cap3-Diseno-Arquitectura.md).

- [ ] Dibujar el recorrido propuesto de una operación entre aplicación, L2 y L1.
- [ ] Identificar qué pasos implementa el prototipo y cuáles requieren integración.
- [ ] Explicar que el AIR demostrativo no aritmetiza ML-DSA ni todas las reglas de una aplicación.
- [ ] Delimitar consenso, disponibilidad de datos y anclaje completo según el estado documentado.

Los documentos administrativos aprobados de TG1 se conservan como antecedentes. Las limitaciones detectadas se discuten en la validación de TG2.

## Sesión 3 — Firma y correspondencia con la implementación

Leer [Capítulo 4](Documentos/01-Manuscrito/Capitulos/Cap4-Nucleo-Criptografico.md), el [informe R1](Documentos/04-Administrativo-TG2/Avances/R1-Correspondencia-Formal-2026-09-22.md) y el código de [nexus-crypto](nexus/nexus-crypto/).

- [ ] Describir KeyGen, Sign y Verify y el perfil ML-DSA usado: puro, hedged y contexto vacío.
- [ ] Diferenciar generación determinista del par desde semilla y aleatorización de la firma.
- [ ] Relacionar el envoltorio local, el backend `fips204` y sus parámetros con la fuente formal.
- [ ] Explicar las obligaciones R1-A–E y por qué las pruebas de correspondencia no son una prueba de seguridad del ejecutable.

La versión conservada pasa **197 pruebas del workspace** en desarrollo. Los comandos y requisitos están en [reproducción](scripts/README.md); el [manifiesto](Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json) identifica el commit.

## Sesión 4 — Entropía, rotación y auditoría

Leer [Capítulo 5](Documentos/01-Manuscrito/Capitulos/Cap5-Gestion-Claves.md), [R2](Documentos/04-Administrativo-TG2/Avances/R2-Monitor-Entropia-2026-09-22.md) y [R3](Documentos/04-Administrativo-TG2/Avances/R3-Rotacion-y-Registro-2026-09-22.md).

- [ ] Definir min-entropía y distinguir estimación puntual de una cota estadística con confianza.
- [ ] Explicar RCT y APT: W=512, C=16, conteo de referencia y lote de 65.536 muestras.
- [ ] Recorrer bloqueo inicial, fallo retenido y recuperación con evaluación y renovación de semilla.
- [ ] Diferenciar reexpansión de una clave, derivación de otra y cambio de época.
- [ ] Explicar verificación histórica, fallo intermedio y recuperación del registro público.
- [ ] Delimitar fuente física, custodia durable, política en el sequencer y anclaje externo.

Las decisiones de parámetros y registro tienen implementación local comprobada. Las integraciones y garantías de despliegue conservan los pendientes del balance.

## Sesión 5 — Validación formal y evidencia experimental

Leer [Capítulo 6](Documentos/01-Manuscrito/Capitulos/Cap6-Validacion-Formal.md) en dos pasadas: firma/complejidad y validación STARK. Usar el [paquete matemático M1–M6](Documentos/04-Administrativo-TG2/Avances/Revision-Matematica-S1-S3-2026-09-23.md) como guía de las obligaciones abiertas.

- [ ] Para cada reducción citada, identificar fuente, juego, parámetros, condiciones y pérdida.
- [ ] Explicar qué condiciones examinadas de JMW24 no se cumplen para los perfiles y qué concluye R1.
- [ ] Separar complejidad asintótica de latencias y rendimientos medidos.
- [ ] Localizar la comparativa ML-DSA/ECDSA/RSA ya ejecutada en R4 y su complemento.
- [ ] Distinguir las series históricas recuperadas de los 29 casos Criterion, 40 mediciones STARK y 40 repeticiones multinúcleo nuevos.
- [ ] Explicar el contraejemplo de proximidad: traza alejada, enunciado válido y aceptación del legado.
- [ ] Describir la variante vinculada, los casos que rechaza y su costo de comunicación.
- [ ] Distinguir cota interactiva ideal, correspondencia Merkle/Fiat–Shamir y garantía concreta aún pendiente.

No presentar 100 bits, conocimiento cero ni validación de una blockchain completa como resultados acreditados. El número de pruebas de software no mide bits de seguridad.

## Sesión 6 — Contribución y límites de residencia

Leer [Capítulo 7](Documentos/01-Manuscrito/Capitulos/Cap7-Conclusiones.md) y el [informe R5](Documentos/04-Administrativo-TG2/Avances/R5-Residencia-y-Custodia-2026-09-22.md).

| Tema | Resultado que puede explicarse | Límite que debe acompañarlo |
|---|---|---|
| Reexpansión por firma | Política experimental y mediciones del benchmark | El gestor conserva claves entre operaciones; la semilla permite reconstruirlas |
| Residencia W | Inventario de representaciones y modelo bytes·tiempo | No mide todas las copias, RAM o residuos físicos ni una reducción proporcional del riesgo |
| Aporte experimental | Comparación trazable y caracterización de fallos y límites | La revisión realizada no establece prioridad absoluta de la idea |
| Deception y pagos agénticos | Discusión complementaria y posibles aplicaciones | No constituyen implementaciones operativas validadas de TG2 |

- [ ] Explicar por qué la antigua razón 187,3× mezclaba cantidades y no debe defenderse como reducción del riesgo.
- [ ] Separar tamaño serializado, región de memoria, semilla y objeto del backend.
- [ ] Precisar las hipótesis del atacante y la evidencia necesaria para protección efectiva.

## Sesión 7 — Ensayo de sustentación

Usar el [guion de sustentación](Documentos/04-Administrativo-TG2/Presentaciones/Guion-Sustentacion-TG2.md). Contestar cada pregunta con una afirmación, evidencia localizable y límite.

- [ ] ¿Qué resultados permiten evaluar los Objetivos 3 y 4?
- [ ] ¿Qué parte del diseño está implementada y validada?
- [ ] ¿Qué observa realmente el monitor de entropía?
- [ ] ¿Qué ocurre después de comprometer una semilla o reiniciar el proceso?
- [ ] ¿Qué demuestra el contraejemplo y qué no demuestra?
- [ ] ¿Por qué la cota ideal no equivale a seguridad del ejecutable?
- [ ] ¿Qué aporta W si no es una probabilidad de compromiso?
- [ ] ¿Qué falta para un despliegue concreto y qué requiere dictamen académico?

Los análisis de otras plataformas en `02-Investigacion-y-Notas/` son contexto bibliográfico fechado. Sus decisiones no validan por sí solas los resultados de NEXUS.
