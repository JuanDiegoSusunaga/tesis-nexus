# Guion de sustentación — NEXUS TG2

**Estado:** contenido actualizado el 12 de octubre de 2026. La duración se ajustará al formato institucional. Dominio: sistemas en general.

| Lámina | Mensaje principal | Apoyo que debe mostrarse |
|---|---|---|
| 1. Problema | Autenticación y gestión de claves ante amenazas poscuánticas | Título y problema del capítulo 1 |
| 2. Objetivos y alcance | TG2 evalúa las actividades 3.1, 3.2, 4.1 y 4.2 | Tabla del balance de objetivos |
| 3. Arquitectura | La arquitectura dual sirve como modelo de referencia | Figura vigente del manuscrito y estado de implementación |
| 4. Firma | Perfil ML-DSA, envoltorio y backend identificados | R1 y capítulo 4 |
| 5. Salud del flujo | RCT/APT y bloqueo controlan el uso de la fuente observada | Parámetros y secuencia de recuperación R2 |
| 6. Rotación | Las claves operativas y épocas cambian con registro local verificable | Flujo R3 y caso de fallo intermedio |
| 7. Fundamentos formales | Las reducciones exigen hipótesis y pérdidas específicas | Correcciones de R1 y fuentes primarias del capítulo 6 |
| 8. Resultados empíricos | Las mediciones comparan componentes bajo condiciones registradas | Tablas R4/complemento con unidades y dispersión |
| 9. Validación STARK | La auditoría caracteriza límites y prueba una variante vinculada | Contraejemplo, tamaños de prueba y auditoría Merkle/FS |
| 10. Residencia | W describe regiones e intervalos bajo un modelo explícito | Inventario R5, semilla retenida y límites del modelo |
| 11. Cumplimiento | Cada actividad tiene resultado, evidencia y pendiente identificados | Balance de los Objetivos 3 y 4 |
| 12. Conclusión | Aporte técnico, límites y decisiones necesarias para cierre | Conclusiones vigentes y estado del dictamen |

## Respuestas que conviene ensayar

**¿Qué observa el monitor?** El flujo que aporta la aplicación. La vinculación con una fuente física concreta requiere trabajo adicional y no se deduce de pasar RCT/APT.

**¿La rotación impide cualquier compromiso futuro o pasado?** El gestor aplica políticas de épocas y el registro autentica eventos locales. Las garantías dependen de custodia, material retenido, acceso del atacante e integración; una semilla accesible conserva capacidad de firma.

**¿Qué significa que pase 197 pruebas?** Que los casos incluidos satisfacen sus comprobaciones en el entorno registrado. Las pruebas no representan una certificación criptográfica ni una probabilidad de ataque.

**¿Se falsificó el STARK?** El contraejemplo conserva enunciados válidos y refuta una premisa de proximidad sobre la traza del legado. La variante vinculada rechaza los casos reutilizados. La edición integra una derivación ideal por rondas y una transferencia propuesta en ROM clásico, con dictamen pendiente; el corpus finito no demuestra una garantía general.

**¿Hay 100 bits de seguridad o conocimiento cero acreditados?** La edición no sostiene esas garantías para el PoC. Los límites dependen del modelo y del presupuesto adversario. La recuperación del testigo pequeño impide atribuir conocimiento cero; el campo de extensión y el trabajo del nonce no bastan para acreditar 100 bits.

**¿Qué se refinó de TG1?** En la edición de TG2 se precisaron las afirmaciones heredadas y se integró su evaluación. Los entregables administrativos aprobados y el código heredado se conservan. La modificación de la exposición no es una nueva aprobación del director.

**¿Qué aporta ROM y qué falta en QROM?** ROM modela un único oráculo clásico y contabiliza preparación, extracción Merkle, retos y nonces adaptativos. Su demostración propuesta requiere dictamen. QROM de AIR/FRI mantiene abierta la omisión de parejas incorrectas y queda como trabajo futuro por decisión del autor; las obligaciones R1 de ML-DSA son independientes.

**¿W mide riesgo?** Es un modelo de residencia de regiones declaradas. Convertirlo en riesgo requiere hipótesis sobre acceso, semilla, tiempo de captura y residuos que no se han validado de forma integral.

## Comprobación antes del ensayo

- [ ] Todas las cifras conservan unidad, perfil, serie y procedencia.
- [ ] Las figuras son las de la edición vigente y se leen al proyectarlas.
- [ ] Cada actividad de TG2 aparece con evidencia y limitaciones.
- [ ] El dictamen recibido se incorpora con fecha y resolución.
- [ ] El tiempo de exposición y las respuestas se ensayan y registran.

[Balance de objetivos](../Entrega-Final/Balance-Objetivos-TG2.md) · [Manuscrito](../../01-Manuscrito/README.md) · [Evidencia](../../06-Evidencia-TG2/README.md)
