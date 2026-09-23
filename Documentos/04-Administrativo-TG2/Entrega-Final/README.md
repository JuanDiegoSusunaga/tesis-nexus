# Índice de entrega TG2

**Estado:** edición de trabajo organizada el 23 de septiembre de 2026, preparada para revisión. La aprobación académica de cierre y la fecha de entrega definitiva siguen por registrar.

## Contenido de la edición

| Elemento | Ubicación |
|---|---|
| Manuscrito Word, PDF y fuentes | [Edición vigente](../../01-Manuscrito/README.md) |
| Identificación y hashes | [version-tg2.json](version-tg2.json) |
| Cumplimiento de actividades y límites | [Balance de objetivos](Balance-Objetivos-TG2.md) |
| Decisiones y próximos pasos | [Ruta de cierre](../Ruta-de-Cierre-TG2.md) y [pendientes](../../../PENDIENTES.md) |
| Evidencia y fuentes por etapa | [Índice de evidencia](../../06-Evidencia-TG2/README.md) |
| Código y reproducción | [Instrucciones](../../../scripts/README.md) |
| Revisión matemática pendiente | [Preguntas M1–M6](../Avances/Revision-Matematica-S1-S3-2026-09-23.md) |
| Derivaciones matemáticas reunidas | [Word para revisión](../Avances/Derivaciones-Matematicas-TG2-2026-09-23.docx) y [fuente](../Avances/Derivaciones-Matematicas-TG2-2026-09-23.md) |
| Complementos posteriores integrados en main | [Solidez por rondas](../Avances/Cierre-Matematico-2026-09-23/README.md) y [transferencia clásica ROM al protocolo](../Avances/Transferencia-ROM-2026-09-23/README.md), pendientes de dictamen |
| Preparación de sustentación | [Guion](../Presentaciones/Guion-Sustentacion-TG2.md) |
| Revisión interna posterior de ROM | [Potencial para nonces adaptativos y controles de premisas](../Avances/Revision-Critica-ROM-2026-09-23/README.md); dictamen externo pendiente |

Se enlaza una sola edición del manuscrito; esta carpeta no duplica los archivos Word/PDF. El manifiesto vincula el commit de código con los hashes del manuscrito y de `06-Evidencia-TG2`. Los complementos posteriores de `Avances/` tienen sus propios registros `validacion.json`; todavía no están incorporados en el Word ni en el manuscrito. La revisión Git documental identifica el conjunto.

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
- [ ] Completar diapositivas y ensayo a partir del guion preparado.
- [ ] Registrar envío y recepción cuando ocurran.

La aprobación anterior comunicada por el autor se mantiene en la bitácora. No se atribuye automáticamente a las derivaciones y correcciones posteriores.
