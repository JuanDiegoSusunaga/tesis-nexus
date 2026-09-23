# Índice de evidencia TG2

Las carpetas conservan resultados por fecha y etapa. Cada informe explica el alcance, comandos, fuentes y límites de su evidencia. Las copias de código bajo `fuentes/nexus/` pertenecen a las ejecuciones documentadas; no se editan para sincronizarlas con el código actual.

| Fecha / carpeta | Contenido |
|---|---|
| `2026-09-22/inventario.json` y `criterion/` | Recuperación inicial de 125 archivos y 29 casos históricos; no representa una ejecución nueva |
| `2026-09-22/R1-correspondencia/` | Perfil ML-DSA, fuentes formales y contraste de hipótesis |
| `2026-09-22/R2-monitor/` | Salud del flujo observado, bloqueo y recuperación |
| `2026-09-22/R3-rotacion/` | Rotación operativa y registro local autenticado |
| `2026-09-22/R4-validacion/` | Primera serie nueva, caracterización del verificador y sus límites |
| `2026-09-22/R4-complemento/` | Benchmarks que completan la serie nueva y ensayo multinúcleo corregido |
| `2026-09-22/R4-solidez/` | Parámetros, transcripción, proximidad y bibliografía STARK |
| `2026-09-22/R4-algebra/` | Argumento algebraico y contrastes finitos |
| `2026-09-22/R4-proximidad/` | Contraejemplo sobre la traza y control exhaustivo experimental |
| `2026-09-22/R4-FRI-vinculado/` | Variante experimental con raíz compartida entre AIR y FRI de traza |
| `2026-09-22/R4-cota-interactiva/` | Derivación conservadora bajo oráculos y retos ideales |
| `2026-09-22/R5-residencia/` | Inventario de representaciones y modelo de residencia |
| `2026-09-23/R4-Merkle-FS/` | Reconstrucción de 14 certificados, auditoría Merkle/Fiat–Shamir y revisión del manuscrito |
| `2026-09-23/Organizacion-repositorios/` | Verificación del entorno, del código y de la organización de esta edición |

Los JSON de formato y paginación en la raíz de cada fecha describen la última edición revisada ese día. Cada etapa mantiene además sus propias instantáneas. Una cifra histórica se interpreta con su informe, fecha, parámetros y versión; no se sustituye por la cifra de otra etapa.

Los manifiestos históricos pueden incluir hashes de documentos de seguimiento que después cambian. Esos hashes identifican el estado en que se registró la etapa. El [manifiesto de la edición](../04-Administrativo-TG2/Entrega-Final/version-tg2.json) y `python scripts/verificar_version_tg2.py` comprueban los archivos conservados actualmente.

Git conserva los bytes de esta carpeta mediante `.gitattributes`. Las [instrucciones de reproducción](../../scripts/README.md) indican qué scripts generan archivos, cuáles requieren cachés y cómo repetir las mediciones sin sobrescribir la evidencia histórica.
