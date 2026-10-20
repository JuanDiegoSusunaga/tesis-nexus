# Índice de entrega TG2

**Consolidación editorial local, 20 de octubre:** con autorización «Dale 1» se conservan tesis, solicitud para el director, cambios de generación y evidencias en el commit local que contiene el manifiesto vigente. [Selección y controles](../../06-Evidencia-TG2/2026-10-20/Consolidacion-Editorial/preparacion.json). Su hash se consulta con `git log -1 -- Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json`, sin autorreferencia. No se compila, regenera ni publica; no hay envío o dictamen. Los registros anteriores de preparación conservan su estado histórico.
**Orden preliminar vigente, 20 de octubre:** por indicación del autor, el glosario y la notación se sitúan antes del capítulo 1. El glosario comienza en la página 7 de Word y PDF; ambos índices se actualizan. Se conservan las definiciones y las diez fuentes Markdown, con 123/111 páginas y el mismo formato. [Verificación y respaldos](../../06-Evidencia-TG2/2026-10-20/Glosario-Preliminares/verificacion.json). Sin recompilar Lean/Rust, commit, push, envío ni dictamen.
**Actualización editorial vigente, 20 de octubre:** [solicitud para el director en Word](../Avances/Revision-Matematica-NEXUS.docx), con el formato de la tesis, seis páginas y preguntas numeradas del 1 al 6. Se explican las etiquetas históricas M1–M6 y se usan referencias escritas a secciones. La tesis también incorpora esas aclaraciones y, por autorización expresa, un glosario de términos y una guía separada de notación. [Controles, revisión y respaldos](../../06-Evidencia-TG2/2026-10-20/Glosario-Notacion/verificacion.json). Sin compilar Lean/Rust, commit, push, envío ni dictamen; las entradas siguientes conservan su alcance histórico.

**Revisión para el director preparada, 20 de octubre:** el autor confirma a su director como revisor. Se actualiza la [solicitud M1–M6](../Avances/Revision-Matematica-S1-S3-2026-09-23.md) con el material vigente, hipótesis, localizadores y formato de respuesta, sin añadir obligaciones matemáticas. [Preparación y respaldos](../../06-Evidencia-TG2/2026-10-20/Preparacion-Revision-Director/preparacion.json). No hay envío, recepción ni dictamen registrados; las seis preguntas siguen pendientes. Las comprobaciones internas no sustituyen su revisión. Sin compilar, regenerar el manuscrito, crear otro commit ni hacer push; QROM permanece como trabajo futuro.

**Consolidación Lean posterior, 20 de octubre:** se versionan las fuentes ya auditadas y sus herramientas de reproducción en un commit local separado, sin modificar demostraciones, compilar, repetir pruebas ni hacer push. Se concilian los README para separar el estado vigente de los pendientes históricos. [Integridad, alcance y respaldos](../../06-Evidencia-TG2/2026-10-20/Consolidacion-Lean/preparacion.json). Se excluyen dependencias, cachés y temporales; reproducir las pruebas requiere preparar el entorno, no solo clonar. No se añaden módulos ni obligaciones matemáticas y el manuscrito permanece intacto. El commit que contiene el manifiesto identifica esta consolidación; Rust mantiene `637e77c`.

**Antecedente documental local, 20 de octubre:** el commit `a9faf0e` incorporó manuscrito, evidencia, índices y seguimiento. [Alcance y respaldos](../../06-Evidencia-TG2/2026-10-20/Consolidacion-Documental/preparacion.json). No hubo push, recompilación ni regeneración de Word/PDF. Las fuentes Lean y sus herramientas nuevas quedaron excluidas de aquel commit y se incluyen en la consolidación posterior descrita arriba. El hash documental vigente se consulta con `git log -1 -- Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json`; el manifiesto conserva por separado el commit Rust y el documental de contexto anterior.

**Verificación global final, 20 de octubre:** pasa check de todos los targets, 223 pruebas sin fallos y build del workspace Rust sobre el commit `637e77c99e804664915caf4ed928a10ef81cc870`. Se ejecuta una sola pasada autorizada con caché, dependencias locked/offline y cuatro trabajos/hilos; se conservan las advertencias. [Registros y alcance](../../06-Evidencia-TG2/2026-10-20/Rust-Global-Final/verificacion.json). No se modifica código, recompila Lean ni regenera Word/PDF; el manuscrito y los informes anteriores mantienen su estado histórico. Sin commit documental ni push.

**Revisión documental NIST, 17 de octubre:** [fuentes y alcance](../../06-Evidencia-TG2/2026-10-17/NIST-Referencias/README.md). Se conservan doce fuentes y se reutiliza la auditoría de 1707 resultados en 191 módulos; al cerrar esa revisión permanecían ocho grupos parciales.

**Formalización y manuscrito, 19 de octubre:** pasaron la [compilación global y auditoría de 2709 declaraciones](../../06-Evidencia-TG2/2026-10-19/Lean-Global/README.md). El puente adaptativo, las probabilidades excepcionales, trabajo, perfiles y reinicios están demostrados en el modelo ROM clásico finito, con constantes conservadoras. El manuscrito se concilió con esos enunciados y se regeneraron Word y PDF como una sola tesis, sin etiquetas TG1/TG2 ni narrativa de borradores. La [evidencia de conciliación](../../06-Evidencia-TG2/2026-10-19/Conciliacion-Manuscrito-ROM/verificacion.json) conserva los límites del modelo y no acredita refinamiento universal Rust ni dictamen.

**Estado:** manuscrito final de consulta regenerado con glosario y notación en las páginas preliminares el 20 de octubre de 2026. [Verificación vigente](../../06-Evidencia-TG2/2026-10-20/Glosario-Preliminares/verificacion.json): Word 123 páginas, PDF 111, 34 tablas, 848 celdas y 664 objetos matemáticos nativos. Los 58 objetos de la guía explican notación; se conservan las fórmulas, hipótesis y objetivos originales. La [conciliación con Rust](../../06-Evidencia-TG2/2026-10-20/Conciliacion-Manuscrito-Rust/verificacion.json) mantiene su carácter de antecedente. Sin recompilar Rust/Lean. La denominación final describe su narrativa única y no atribuye aprobación académica; esta y la fecha de entrega definitiva siguen por registrar.

**Corrección integral posterior:** se atendieron los seis grupos de coherencia, conservando los objetivos originales y declarando el cumplimiento parcial de la reducción concreta de seguridad de las firmas. Se precisaron independencia, consenso, amortización e hipótesis de las síntesis; la propuesta de señuelos se trasladó a trabajo futuro. Word/PDF se regeneraron y revisaron en sus 114/102 páginas, sin recompilar Lean/Rust ni modificar §6.7.9. [Evidencia de corrección](../../06-Evidencia-TG2/2026-10-19/Revision-Integral-Coherencia/correccion-verificada.json).

**Alcance vigente:** completar QROM del protocolo AIR/FRI queda como trabajo futuro por decisión del autor del 23 de septiembre. Los suplementos se conservan como investigación parcial y su conclusión deja de bloquear esta ruta de entrega.

## Contenido de la edición

**Integración de ActiveChain consolidada, 20 de octubre:** el manifiesto vigente identifica el commit local `637e77c99e804664915caf4ed928a10ef81cc870`. [Evidencia y procedencia](../../06-Evidencia-TG2/2026-10-20/ActiveChain/consolidacion.json): contexto de lotes privados, perfil local, verificación antes de registrar envíos y controles de duplicados y fronteras de estado. Pasaron check/build y 55 pruebas aisladas de `nexus-active`, trece nuevas; no se repiten para consolidar ni para conciliar el manuscrito. Este refleja ahora la integración y sus límites. No se acredita una L2 completa: las raíces SHA3 generales fuera del AIR escalar se rechazan y los positivos de integración son sintéticos. Sin push ni commit de los cambios documentales.

**Antecedente de código, 20 de octubre:** la adaptación inicial Rust al contrato Lean queda en `3e40e283dddc15502830f9fc220e556385f9d477`. Su [consolidación](../../06-Evidencia-TG2/2026-10-20/Rust-Lean/consolidacion.json) conserva las verificaciones globales previas, las 113 pruebas aisladas de dos paquetes y la revisión estática. Su manifiesto se preserva como antecedente, sin presentarlo como el árbol de integración posterior.

| Elemento | Ubicación |
|---|---|
| Formalización Lean y límites | [Resultados formales y matriz de obligaciones](../../../formalizacion/REVISION-MANUSCRITO.md) |
| Manuscrito Word, PDF y fuentes | [Edición vigente](../../01-Manuscrito/README.md) |
| Identificación y hashes | [version-tg2.json](version-tg2.json) |
| Cumplimiento de actividades y límites | [Balance de objetivos](Balance-Objetivos-TG2.md) |
| Decisiones y próximos pasos | [Ruta de cierre](../Ruta-de-Cierre-TG2.md) y [pendientes](../../../PENDIENTES.md) |
| Evidencia y fuentes por etapa | [Índice de evidencia](../../06-Evidencia-TG2/README.md) |
| Código y reproducción | [Instrucciones](../../../scripts/README.md) |
| Revisión matemática pendiente | [Preguntas M1–M6](../Avances/Revision-Matematica-S1-S3-2026-09-23.md) |
| Revisión web y conciliación con subagentes | [Tres informes, fuentes y estado de integración](../Avances/Revision-Subagentes-2026-10-12/README.md) |
| Derivaciones matemáticas reunidas | [Word consolidado para revisión](../Avances/Derivaciones-Matematicas-TG2-2026-10-12.docx) y [fuente](../Avances/Derivaciones-Matematicas-TG2-2026-10-12.md) |
| Complementos posteriores integrados en main | [Solidez por rondas](../Avances/Cierre-Matematico-2026-09-23/README.md) y [transferencia clásica ROM al protocolo](../Avances/Transferencia-ROM-2026-09-23/README.md), pendientes de dictamen |
| Preparación de sustentación | [Guion](../Presentaciones/Guion-Sustentacion-TG2.md) |
| Revisión interna posterior de ROM | [Potencial para nonces adaptativos y controles de premisas](../Avances/Revision-Critica-ROM-2026-09-23/README.md); dictamen externo pendiente |
| Primera etapa QROM | [Cota parcial de PoW y obligaciones Q1–Q5](../Avances/QROM-2026-09-23/README.md); transferencia cuántica completa AIR/FRI pendiente |
| Extractor QROM y escapes de campo | [Extracción sin orden y estabilidad](../Avances/Extractor-QROM-2026-09-23/README.md); cota en base comprimida, todavía sin transferencia completa a aceptación real |
| Muestreo QROM y paso al verificador | [Expansión y reducción condicional](../Avances/Muestreo-QROM-2026-09-23/README.md); cota β de omisión o cola aún pendiente, 80 pruebas Python y 197 Rust |
| Cota cuántica de cola | [Demostración propuesta por conteo](../Avances/Cola-QROM-2026-09-23/README.md); 144 perfiles y 96 Python/197 Rust. Omisión y dictamen pendientes |

Se enlaza una sola edición vigente del manuscrito; esta carpeta no duplica los archivos Word/PDF. El manifiesto vincula el commit de código con los hashes del manuscrito y de `06-Evidencia-TG2`. La derivación por rondas, la transferencia ROM y el potencial para nonces se incorporan a §§6.7.8–6.7.9 y al suplemento consolidado, como resultados propuestos pendientes de dictamen. Los paquetes originales y el Word del 23 de septiembre se conservan como antecedentes. La [revisión de esta consolidación](../Avances/Consolidacion-Manuscrito-TG2-2026-10-12.md) precisa los cambios y su evidencia.

La [conciliación del 17 de octubre](../../06-Evidencia-TG2/2026-10-17/Manuscrito-Modelos/README.md)
sincroniza Word, PDF y Markdown con las fuentes TG2. La auditoría Lean verifica
componentes y axiomas; los conteos de aquellas etapas son antecedentes. El núcleo probabilístico ROM está demostrado en el alcance descrito arriba, con dependencias externas y obligaciones de implementación separadas.
El autor confirmó que no hay dictamen independiente. El manifiesto de 12 de
octubre queda conservado entre los antecedentes, con su hash original.

## Verificación

Desde la raíz, con ambos repositorios en las revisiones identificadas:

```powershell
python scripts/verificar_version_tg2.py
git rev-parse HEAD
git -C nexus rev-parse HEAD
```

Los hashes permiten detectar archivos modificados o faltantes. Las copias de fuentes y los registros históricos se conservan incluso cuando el código de trabajo ha avanzado. Las dependencias de construcción están en `requirements.txt` y `nexus/Cargo.lock`.

## Condiciones para declarar entrega definitiva

- [ ] Incorporar el dictamen del director/lector sobre las correcciones formales y el alcance del cierre.
- [ ] Resolver o delimitar con ese dictamen las obligaciones del balance.
- [ ] Registrar la fecha y los requisitos institucionales de entrega y sustentación.
- [ ] Retomar diapositivas y ensayo cuando el autor lo solicite; la sustentación quedó aplazada el 12 de octubre.
- [ ] Registrar envío y recepción cuando ocurran.

La aprobación anterior comunicada por el autor se mantiene en la bitácora. No se atribuye automáticamente a las derivaciones y correcciones posteriores.
