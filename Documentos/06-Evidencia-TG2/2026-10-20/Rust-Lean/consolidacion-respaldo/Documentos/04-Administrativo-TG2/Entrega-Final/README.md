# Índice de entrega TG2

**Revisión documental NIST, 17 de octubre:** [fuentes y alcance](../../06-Evidencia-TG2/2026-10-17/NIST-Referencias/README.md). Se conservan doce fuentes y se reutiliza la auditoría de 1707 resultados en 191 módulos; al cerrar esa revisión permanecían ocho grupos parciales.

**Formalización y manuscrito, 19 de octubre:** pasaron la [compilación global y auditoría de 2709 declaraciones](../../06-Evidencia-TG2/2026-10-19/Lean-Global/README.md). El puente adaptativo, las probabilidades excepcionales, trabajo, perfiles y reinicios están demostrados en el modelo ROM clásico finito, con constantes conservadoras. El manuscrito se concilió con esos enunciados y se regeneraron Word y PDF como una sola tesis, sin etiquetas TG1/TG2 ni narrativa de borradores. La [evidencia de conciliación](../../06-Evidencia-TG2/2026-10-19/Conciliacion-Manuscrito-ROM/verificacion.json) conserva los límites del modelo y no acredita refinamiento universal Rust ni dictamen.

**Estado:** manuscrito final de consulta regenerado el 19 de octubre de 2026. La denominación final describe su narrativa única y no atribuye aprobación académica; esta y la fecha de entrega definitiva siguen por registrar.

**Corrección integral posterior:** se atendieron los seis grupos de coherencia, conservando los objetivos originales y declarando el cumplimiento parcial de la reducción concreta de seguridad de las firmas. Se precisaron independencia, consenso, amortización e hipótesis de las síntesis; la propuesta de señuelos se trasladó a trabajo futuro. Word/PDF se regeneraron y revisaron en sus 114/102 páginas, sin recompilar Lean/Rust ni modificar §6.7.9. [Evidencia de corrección](../../06-Evidencia-TG2/2026-10-19/Revision-Integral-Coherencia/correccion-verificada.json).

**Alcance vigente:** completar QROM del protocolo AIR/FRI queda como trabajo futuro por decisión del autor del 23 de septiembre. Los suplementos se conservan como investigación parcial y su conclusión deja de bloquear esta ruta de entrega.

## Contenido de la edición

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
