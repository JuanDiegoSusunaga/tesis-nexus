# Revisión de la bitácora y estado vigente de TG2

**Fecha de revisión:** 2026-09-22. **Método:** contraste del registro histórico con documentos, código e inventario de evidencia local.

**Avance posterior R3:** el [informe de rotación y registro](R3-Rotacion-y-Registro-2026-09-22.md) documenta cambio efectivo de claves, registro local y 142 pruebas. La matriz actualiza K01–K03 y explicita las integraciones de despliegue pendientes.

**Avance previo R2:** el [informe R2](R2-Monitor-Entropia-2026-09-22.md) registra la corrección del monitor y 123 pruebas ejecutadas el mismo día. Las observaciones de la tabla siguiente corresponden a la revisión inicial; los estados vigentes E01–E03 están actualizados en la matriz de trazabilidad.

## Acuerdos confirmados

**Aclaración de alcance posterior a la primera revisión:** el estudiante indica que NEXUS se dirige a sistemas en general. La búsqueda en la bitácora local no encontró una entrada previa que registrara explícitamente esa ampliación; su encabezado conservaba «Sistemas Bancarios». Se incorpora la aclaración del autor al estado vigente y al manuscrito. La fecha original de esa decisión no se infiere y no se atribuye retroactivamente a la aprobación del director.

El estudiante informa en esta sesión que el director aprobó todo lo presentado, en respuesta a la consulta sobre acuerdos, entregas y plazos posteriores al 7 de agosto. Se registra la aprobación del plan, entrega previa y decisiones presentadas. No se inventan una fecha exacta, un canal de comunicación ni plazos no suministrados. Tampoco se atribuye al director aprobación de los cambios nuevos de esta revisión.

## Conciliación de registros

| Registro anterior | Hallazgo al 22 de septiembre | Tratamiento vigente |
|---|---|---|
| F0 y decisiones 001–002 pendientes de aprobación | Aprobación confirmada por el estudiante | Actualizar el estado administrativo; conservar fecha y soporte como datos por incorporar |
| Commit documental de agosto pendiente | HEAD documental 23861ef ya registra el avance | Retirar ese pendiente histórico; las ediciones de septiembre son cambios nuevos |
| Benchmark de residencia descrito como versionado en la entrega | El archivo sigue sin seguimiento Git en nexus | Preservado en la instantánea de evidencia; falta revisar y versionar el código |
| Rotación y auditoría descritas como implementadas | rotate_sentinel no cambia claves almacenadas; registro auditable aún en diseño | Objetivo 3 continúa en ejecución técnica |
| Monitor de salud verificado | Las pruebas existentes no corrigen el umbral APT ni justifican recuperación tras reseed | Mantener ejecución histórica de tests, abrir correcciones y pruebas específicas |
| Cadena formal presentada como validada | Paso de extracción y cota local incorrectamente justificados | Cap. 6 revisado; correspondencia ML-DSA y revisión matemática externa pendientes |
| Teoremas sobre variantes usados como garantía concreta | Las hipótesis y parámetros difieren entre fuentes | Matriz de trazabilidad con límites por resultado |
| 109, 97 y 110 tests en distintos documentos | Son registros de momentos diferentes; último total documentado: 110, 2026-08-07 | Citar fecha y alcance; no afirmar una ejecución nueva |
| H1 STARK presenta cifras anteriores a la corrida oficial | Cap. 3 conserva una medición de TG1; Cap. 6 usa la corrida del 31 de julio | Etiquetar la procedencia histórica en la edición ensamblada; comparar perfiles únicamente dentro de una misma serie |
| Cacheadas 314 µs y efímeras 432 µs en H2 | Caché recuperada: medianas 304,922 y 430,187 µs | No reemplazar silenciosamente ni atribuirlas a la misma corrida; registrar la diferencia y preservar originales |
| W interpretada como reducción del riesgo | La semilla compacta permite reconstruir la clave | Delimitar W como residencia y explicitar el modelo de amenaza pendiente |

## Evidencia preservada

Se copiaron 125 archivos, incluidos resultados Criterion de 29 casos y las fuentes de los experimentos, desde el estado local observado. El [inventario](../../06-Evidencia-TG2/2026-09-22/inventario.json) contiene hashes SHA-256, origen, marcas temporales del sistema de archivos y estado Git. Esas marcas no certifican por sí solas la fecha o el hardware de ejecución.

- Documentos: `23861ef66fa3a9c116b8e4d58993510fce20317d`, más cambios de esta sesión.
- Código: `6ec77633951004f37088abcdd41aa78ad290f36f`, con modificaciones locales y experimentos sin seguimiento.
- La instantánea no se presenta como réplica de resultados ni como evidencia de que las corridas se realizaron en esos commits.

## Prioridades resultantes

1. Continuar R1 con la correspondencia entre la prueba corregida y la variante ML-DSA implementada.
2. Ejecutar R2 y R3 con las propuestas ya aprobadas: APT, política de recuperación, rotación efectiva y registro.
3. Reconciliar y reproducir los experimentos afectados antes de cerrar R4.
4. Mantener la edición ensamblada generada desde los capítulos y verificar estructura y contenido de cada tabla al exportar.

La cronología original se conserva como historia. Esta revisión y la [matriz de trazabilidad](../../05-Estado-del-Arte/Resumenes-y-Matriz/Matriz-Trazabilidad-TG2.md) determinan qué afirmaciones siguen abiertas. No se ejecutaron pruebas Rust ni nuevas mediciones durante este inventario.

## Edición del manuscrito

Se consolidaron las salidas Markdown, Word y PDF desde las mismas fuentes. Las 19 tablas tienen numeración única; se compararon sus 389 celdas entre Markdown y Word, sin diferencias de contenido. Las tablas y rótulos permanecen en la misma página de Word. Se revisaron las páginas renderizadas y el PDF no presenta páginas vacías ni texto fuera de los márgenes. Los índices corresponden a la paginación propia de cada formato (Word: 78 páginas; PDF: 69). El [README del manuscrito](../../01-Manuscrito/README.md) explica la generación y enlaza los informes de comprobación.
