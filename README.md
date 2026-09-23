# NEXUS — tesis y evidencia de TG2

**Edición de trabajo:** 23 de septiembre de 2026. NEXUS estudia firmas poscuánticas, gestión de claves y registros verificables para **sistemas en general**, con una arquitectura blockchain dual como modelo de referencia.

## Por dónde empezar

1. [Manuscrito vigente y formatos](Documentos/01-Manuscrito/README.md).
2. [Balance de los Objetivos 3 y 4](Documentos/04-Administrativo-TG2/Entrega-Final/Balance-Objetivos-TG2.md).
3. [Índice de entrega e identificación de la versión](Documentos/04-Administrativo-TG2/Entrega-Final/README.md).
4. [Ruta de cierre](Documentos/04-Administrativo-TG2/Ruta-de-Cierre-TG2.md), [pendientes](PENDIENTES.md) y [bitácora](BITACORA_TG2.md).
5. [Reproducción y herramientas](scripts/README.md).
6. [Derivaciones matemáticas en Word](Documentos/04-Administrativo-TG2/Avances/Derivaciones-Matematicas-TG2-2026-09-23.docx), con hipótesis, argumentos y preguntas para revisión.
7. [Transferencia matemática al protocolo TG2 v1](Documentos/04-Administrativo-TG2/Avances/Transferencia-ROM-2026-09-23/README.md): derivación clásica ROM con pérdidas de Merkle, Fiat–Shamir y nonces, cálculos y verificador independiente. Integrada en `main` junto con la [derivación ideal por rondas](Documentos/04-Administrativo-TG2/Avances/Cierre-Matematico-2026-09-23/README.md); pendiente de revisión e integración al manuscrito.

**Último complemento matemático:** [revisión crítica interna de ROM](Documentos/04-Administrativo-TG2/Avances/Revision-Critica-ROM-2026-09-23/README.md), con demostración ampliada de nonces adaptativos, 96 escenarios exactos y 40 pruebas Python. La cota se conserva y el dictamen independiente sigue pendiente.

## Estructura

| Ubicación | Contenido y uso |
|---|---|
| `Documentos/01-Manuscrito/` | Capítulos fuente, bibliografía, figuras y una salida Markdown, Word y PDF |
| `Documentos/02-Investigacion-y-Notas/` | Decisiones, antecedentes y notas; consultar las actualizaciones de cada documento |
| `Documentos/03-Administrativo-TG1/` | Documentos históricos aprobados de TG1 |
| `Documentos/04-Administrativo-TG2/` | Plan, informes de avance, balance de entrega y preparación de sustentación |
| `Documentos/05-Estado-del-Arte/` | Corpus bibliográfico y matriz de trazabilidad |
| `Documentos/06-Evidencia-TG2/` | Resultados, fuentes de cada ejecución, logs y hashes por fecha y etapa |
| `Documentos/media/` | Imágenes de documentos históricos; las figuras vigentes están en `01-Manuscrito/Figuras/` |
| `scripts/` | Generación documental, análisis y verificación de la versión |
| `nexus/` | Repositorio Rust independiente, clonado dentro de esta carpeta |
| `.tools/`, `.venv/` | Herramientas, temporales y entorno local excluidos de Git |

Los capítulos de `01-Manuscrito/Capitulos/` son la fuente de edición. Las salidas `Tesis-NEXUS-completa.*` se regeneran juntas. Las instantáneas de evidencia conservan resultados históricos; su repetición se realiza en una copia separada siguiendo las [instrucciones](scripts/README.md).

## Dos repositorios relacionados

Este repositorio contiene los documentos. El código se mantiene en un segundo repositorio; `nexus/` está excluido únicamente en la raíz y no es un submódulo. Las copias de fuentes dentro de la evidencia sí se versionan.

```powershell
git clone https://github.com/JuanDiegoSusunaga/tesis-nexus.git Tesis
Set-Location Tesis
git clone https://github.com/JuanDiegoSusunaga/nexus.git nexus
$versionTG2 = Get-Content 'Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json' -Raw | ConvertFrom-Json
git -C nexus checkout --detach $versionTG2.codigo.commit
python scripts/verificar_version_tg2.py
```

La disponibilidad de una revisión en el servidor depende de su publicación. La revisión local de documentos se obtiene con `git rev-parse HEAD`; el manifiesto enlazado fija el commit de código y los hashes del manuscrito y la evidencia.

## Estado técnico

La edición conserva 197 pruebas del workspace, monitor de entropía y gestor/registro local comprobados, 29 casos Criterion, 40 mediciones STARK y 40 repeticiones multinúcleo. El manuscrito revisado tiene 108 páginas Word, 95 PDF, 32 tablas y 3 figuras.

Las garantías concretas del ejecutable, las integraciones de despliegue y el dictamen matemático tienen pendientes explícitos en el balance. La organización de esta versión no constituye aprobación académica ni una garantía de 100 bits o conocimiento cero.

Para estudiar: [ruta actualizada](RUTA_DE_ESTUDIO.md). Para presentar: [guion de sustentación](Documentos/04-Administrativo-TG2/Presentaciones/Guion-Sustentacion-TG2.md).
