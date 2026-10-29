# NEXUS — tesis, matemáticas y prototipo Rust

**Juan Diego Susunaga Velasquez · Universidad del Rosario**

**Director: Pedro Mario Wightman Rojas**

Edición organizada para revisión: **29 de octubre de 2026**. Manuscrito y resultados conservados del 20 de octubre.

NEXUS estudia firmas digitales poscuánticas, gestión de claves y registros verificables para sistemas en general. La arquitectura blockchain de dos capas sirve como modelo de referencia. Este repositorio reúne el manuscrito, las demostraciones Lean, el prototipo Rust y su evidencia.

## Para el director

| Lectura | Acceso directo | Propósito |
|---|---|---|
| 1. Tesis | [PDF de lectura](Documentos/01-Manuscrito/Tesis-NEXUS-completa.pdf) · [Descargar PDF](https://github.com/JuanDiegoSusunaga/tesis-nexus/raw/refs/heads/main/Documentos/01-Manuscrito/Tesis-NEXUS-completa.pdf) · [Word editable](Documentos/01-Manuscrito/Tesis-NEXUS-completa.docx) | Revisar el manuscrito completo; PDF de 111 páginas y Word de 123 páginas |
| 2. Guía de revisión | [Leer en GitHub](Documentos/04-Administrativo-TG2/Avances/Revision-Matematica-S1-S3-2026-09-23.md) · [Descargar Word](Documentos/04-Administrativo-TG2/Avances/Revision-Matematica-NEXUS.docx) | Tres páginas de explicación principal y un anexo técnico; seis preguntas de revisión |
| 3. Resultados y objetivos | [Balance de objetivos](Documentos/04-Administrativo-TG2/Entrega-Final/Balance-Objetivos-TG2.md) · [Pendientes](PENDIENTES.md) | Contrastar lo alcanzado con las obligaciones que siguen abiertas |
| 4. Matemáticas | [Guía de la formalización Lean](formalizacion/README.md) · [Derivaciones en Word](Documentos/04-Administrativo-TG2/Avances/Derivaciones-Matematicas-TG2-2026-10-12.docx) | Consultar hipótesis, demostraciones y correspondencia con el manuscrito |
| 5. Programa | [Guía del prototipo Rust](nexus/README.md) · [Código y reproducción](nexus/REPRODUCIBILIDAD_TG2.md) | Revisar la implementación y los casos ensayados |

Las tres primeras lecturas permiten iniciar la revisión sin instalar herramientas. En la tesis, el glosario y la notación preceden a la introducción. La guía explica el resultado matemático de la sección 6.7.9 y pide revisar sus hipótesis, la separación entre demostración y experimento, y el alcance frente a los objetivos.

## Resultados conservados

| Parte | Evidencia disponible | Alcance |
|---|---|---|
| Manuscrito | [Fuentes, formatos y revisión](Documentos/01-Manuscrito/README.md) | Una tesis con siete capítulos, bibliografía, glosario y notación |
| Matemáticas | [Auditoría Lean del 20 de octubre](Documentos/06-Evidencia-TG2/2026-10-20/Lean-Global/verificacion.json): 2709 declaraciones, 347 submódulos y un módulo raíz | Cotas para el verificador matemático de bytes en un modelo de oráculo aleatorio clásico finito, bajo sus hipótesis |
| Rust | [Registro del ciclo local durable](Documentos/06-Evidencia-TG2/2026-10-20/Ciclo-Local-Durable/verificacion.json): 360 pruebas del workspace y 13 pruebas dirigidas en release | Prototipo local con transferencias, envíos L1, recuperación y persistencia; los conteos corresponden a ejecuciones previas, no se suman |
| Integridad | [Manifiesto de archivos](Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json) · [Catálogo de afirmaciones](Documentos/04-Administrativo-TG2/Avances/Catalogo-Validacion-2026-10-12/README.md) | Identificación mediante hashes de los documentos, fuentes y registros conservados |

La formalización respalda los teoremas de su modelo. Siguen pendientes la correspondencia universal con el ejecutable Rust, las reducciones concretas indicadas en el balance y el dictamen independiente. La extensión QROM completa de AIR/FRI permanece como trabajo futuro. El AIR escalar del prototipo no acredita la validez general de transacciones L2, finalidad BFT ni seguridad de una blockchain de producción.

## Todo en un repositorio

| Carpeta | Contenido |
|---|---|
| [Documentos/01-Manuscrito](Documentos/01-Manuscrito/) | Tesis en PDF, Word y Markdown; capítulos y figuras |
| [formalizacion](formalizacion/) | Pruebas Lean 4 y configuración de mathlib |
| [nexus](nexus/) | Workspace Rust completo, pruebas y ejemplo del ciclo local |
| [Documentos/04-Administrativo-TG2/Entrega-Final](Documentos/04-Administrativo-TG2/Entrega-Final/) | Balance, manifiesto e índice de entrega |
| [Documentos/06-Evidencia-TG2](Documentos/06-Evidencia-TG2/) | Informes, fuentes, logs y respaldos por fecha |
| [scripts](scripts/README.md) | Verificadores y herramientas documentales |

El código Rust está incluido como archivos normales en `nexus/`; no hace falta clonar otro repositorio ni inicializar submódulos. Su procedencia se conserva en el manifiesto y en el [repositorio Rust original](https://github.com/JuanDiegoSusunaga/nexus).

## Comprobar la edición

Solo se requieren Git y Python para estas comprobaciones de integridad; no compilan Lean ni Rust ni regeneran documentos.

```powershell
git clone -c core.longpaths=true https://github.com/JuanDiegoSusunaga/tesis-nexus.git
Set-Location tesis-nexus
python scripts/verificar_version_tg2.py
python scripts/verificar_catalogo_validacion.py
```

Para compilar o repetir experimentos, consultar las [instrucciones de reproducción](scripts/README.md), la [guía Lean](formalizacion/README.md) y la [guía Rust](nexus/REPRODUCIBILIDAD_TG2.md). Las dependencias y cachés de compilación se descargan por separado.

## Seguimiento y antecedentes

[Índice de entrega](Documentos/04-Administrativo-TG2/Entrega-Final/README.md) · [Revisión matemática y obligaciones](formalizacion/REVISION-MANUSCRITO.md) · [Índice de evidencia](Documentos/06-Evidencia-TG2/README.md) · [Bitácora](BITACORA_TG2.md) · [Ruta de estudio](RUTA_DE_ESTUDIO.md).

Los informes fechados conservan el estado de cada etapa. Las expresiones «sin commit», «sin push» o «local» describen aquellas ejecuciones. La organización para revisión no implica envío, dictamen ni aprobación académica.
