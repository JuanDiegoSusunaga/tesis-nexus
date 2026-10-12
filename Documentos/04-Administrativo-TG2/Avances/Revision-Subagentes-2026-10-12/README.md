# Revisión interna de TG2 por subagentes — 12 de octubre de 2026

Este paquete reúne tres revisiones separadas, realizadas a solicitud del autor, con investigación web de fuentes primarias y contraste de documentos, código y evidencia conservados. **No registra envío, aprobación académica ni dictamen externo.** La sustentación está aplazada por instrucción del autor. Completar QROM de AIR/FRI continúa como trabajo futuro; R1 sobre ML-DSA mantiene sus obligaciones específicas.

## Informes y evidencia

| Revisión | Informe | Evidencia reproducible | Resultado principal |
|---|---|---|---|
| ML-DSA y R1 | [Revision-R1.md](Revision-R1.md) | [Verificación, fuentes y cálculos](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/R1/verificacion.json), [script](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/R1/verificar_r1.py) | Perfil puro, hedged y contexto vacío identificado; cuatro correcciones documentales; hash externo y extremos del contador caracterizados; FFH mejora un paso de la reducción. |
| AIR/FRI y ROM | [Revision-AIR-ROM.md](Revision-AIR-ROM.md) | [Contrastes exactos](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/AIR-ROM/contrastes-exactos.json), [script](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/AIR-ROM/contrastes_exactos.py), [registro de acceso web](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/AIR-ROM/fuentes-web.json) | Sin contraejemplo encontrado bajo las hipótesis escritas; cola de 512 extracciones contada exactamente en nueve perfiles; siete archivos coinciden con la instantánea; documentación heredada sobre 100 bits/grinding requiere delimitación. |
| Evidencia experimental | [Revision-Evidencia.md](Revision-Evidencia.md) | [Conciliación](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/Evidencia/conciliacion.json), [script](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/Evidencia/conciliar.py) | 451 comprobaciones de integridad y reproducción estadística pasaron; R4 y complemento conservan respaldo; H1/H2 y caché recuperada tienen identidades diferentes. |

Las **451 comprobaciones** pertenecen al conciliador de evidencia; no son 451 experimentos nuevos, tests criptográficos ni intentos de ataque. El conteo exacto de cola de **nueve perfiles** es una comprobación matemática separada sobre monedas ideales. Sus exponentes no son bits de seguridad global. No se repitieron benchmarks ni se atribuyeron los tiempos del STARK heredado a la variante TG2 v1.

La ejecución común del coordinador conserva [check/test/build de Rust](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/Consolidacion/codigo.json) y [tests Python y catálogo](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/Consolidacion/python.json). El manifiesto y la inspección de Word/PDF pertenecen a la consolidación final, fuera de estas revisiones parciales.

## Integración y asuntos abiertos

El [registro de cierre e integración](Registro-Cierre-Integracion.md) identifica las precisiones documentales que se incorporan en la edición actual y separa las obligaciones pendientes M1–M6, R1-A–E y la procedencia histórica H1/H2. La integración documental coordinada quedó verificada en Word/PDF; no equivale a cerrar una reducción, corregir el backend o obtener aprobación.

Dos novedades web útiles quedan documentadas:

- [FFH: mejora CMA→NMA](https://ir.cwi.nl/pub/35239/35239.pdf), con [ficha ePrint](https://eprint.iacr.org/2025/985) y [publicación CRYPTO 2026](https://link.springer.com/chapter/10.1007/978-3-032-35398-6_20). El texto CWI examinado tiene condiciones de simulación, rechazo y concentración; no cierra SelfTargetMSIS ni la correspondencia del ejecutable.
- [simple-rbr-fri, revisión fijada](https://github.com/zksecurity/simple-rbr-fri/tree/5d99bc7bcabc7b640e063f4d75f17d8262e00a8a): referencia específica de formalización FRI. El teorema leído asume `FRI_MCA_Hypothesis`; no se instaló ni compiló y no mecaniza AIR+dosFRI, ROM o Rust de NEXUS.

La copia GMW de marzo permanece identificada. La ficha actual registra una revisión posterior, pero el PDF reciente devolvió HTTP403; no se declara comparación integral de ese texto. Las revisiones internas se conservan como evidencia del análisis, manteniendo intactos TG1 aprobado y los paquetes matemáticos originales.
