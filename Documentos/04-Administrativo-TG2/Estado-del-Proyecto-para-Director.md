# Estado del Proyecto NEXUS — Brief para el Director

## Actualización vigente — 23 de septiembre de 2026

El contenido anterior de preparación de reunión se conserva abajo como registro histórico. El estado actual es: 197 pruebas repetidas correctamente el 23 de septiembre y diez casos de FRI vinculada en release el día 22, monitor/gestor/registro local implementados; R4 y complemento con 29 casos Criterion, 40 mediciones STARK y 40 repeticiones multinúcleo; R5 con inventario, modelo de captura y sensibilidad. La reexpansión por firma es experimental y la semilla preserva capacidad de firma.

R1 identifica el perfil ML-DSA puro, hedged y de contexto vacío, comprueba parámetros y explicita las condiciones de los teoremas. La condición examinada de JMW24 no permite su aplicación directa a los tres perfiles. Se conservan cinco fuentes primarias y tres pruebas nuevas de correspondencia. Permanecen las obligaciones de expansión, codificaciones, fuente/KDF, terminación y revisión matemática externa.

La auditoría STARK comprueba consultas efectivas, nonces alternativos y proximidad FRI. No encontró una transición AIR falsa aceptada; tampoco acredita 100 bits. El argumento desarrolla divisibilidad, cancelación y distancia para una traza polinómica fija (S1), junto con una transferencia condicional (S2). El ensayo posterior refuta la premisa de proximidad propuesta: el legado acepta tres trazas a distancia 7/8 del código de grado < T. Los enunciados son válidos. Un control exhaustivo experimental, que exige el LDE completo, las rechaza por grado. La nueva variante vincula FRI de traza y AIR por una raíz común y rechaza pruebas regeneradas sobre los mismos tres oráculos, sin recibir todo el LDE; acepta los cuatro tamaños honestos ensayados. El enlace estructural está implementado. La revisión posterior deriva una cota conservadora de composición con oráculos y retos ideales: fija el candidato antes de los retos AIR y trata el campo de extensión. La cota es débil para 40 consultas y no acredita 100 bits; falta transferir el argumento a Merkle/Fiat–Shamir y ROM/QROM, además de la revisión externa. [Derivación ideal y límites](Avances/R4-Cota-Interactiva-2026-09-22.md). Los tamaños medidos no acreditan ahorro de bytes ni conocimiento cero. [Informe de FRI vinculada](Avances/R4-FRI-Vinculado-2026-09-22.md). La cancelación reproducida usa coeficientes elegidos y un enunciado con traza válida alternativa; no falsifica el STARK completo.

La auditoría del día 23 reconstruye 14 certificados con hashlib, comprueba 560 consultas y 18.880 aperturas Merkle y calcula el sesgo exacto de reducción al campo bajo salidas uniformes frescas. Se delimita por qué esta correspondencia no establece aún la compilación Fiat–Shamir ni una garantía ROM/QROM. [Informe de auditoría](Avances/R4-Merkle-Fiat-Shamir-2026-09-23.md) y [paquete de revisión matemática M1–M6](Avances/Revision-Matematica-S1-S3-2026-09-23.md), preparado sin envío ni dictamen registrados.

La revisión retiró la extracción formal injustificada y no acredita una prueba completa para la variante ML-DSA implementada ni 100 bits de soundness. El PoC admite la recuperación del testigo de 16 filas; las raíces arbitrarias y el anclaje completo no están validados. Las afirmaciones históricas de prueba completa, exposición 187,3× menor y novedad confirmada deben leerse con estas correcciones. [Contraejemplo de proximidad](Avances/R4-Proximidad-Traza-2026-09-22.md), [argumento algebraico AIR/FRI](Avances/R4-Algebra-AIR-FRI-2026-09-22.md), [auditoría STARK](Avances/R4-Solidez-STARK-2026-09-22.md), [informe R1](Avances/R1-Correspondencia-Formal-2026-09-22.md), [registro R5 y complemento R4](Avances/R5-Residencia-y-Custodia-2026-09-22.md) y [ruta de cierre](Ruta-de-Cierre-TG2.md).



> **Documento histórico del 3 de agosto de 2026.** El enfoque y las afirmaciones siguientes corresponden a ese momento. El alcance vigente, aclarado por el autor el 22 de septiembre, es **sistemas en general**. El estado técnico actualizado está en la [revisión de la bitácora](Avances/Revision-Bitacora-2026-09-22.md) y el [manuscrito vigente](../01-Manuscrito/README.md).

**Para:** Prof. Pedro Mario Wightman Rojas · **De:** Juan Diego Susunaga Velasquez (MACC)
**Fecha:** 2026-08-03 · **Propósito:** presentar el estado del proyecto al asumir la dirección y preparar la reunión inicial de TG2.
**Repositorio:** github.com/JuanDiegoSusunaga/nexus · **Adjunto:** `Plan-de-Trabajo-TG2.md` (borrador para acordar)

---

## 1. El proyecto en una frase

NEXUS formaliza y prototipa cómo asegurar firmas digitales bancarias contra la amenaza cuántica con CRYSTALS-Dilithium (ML-DSA), demostrando formalmente su seguridad (reducción a Module-LWE) y resolviendo el sobrecosto de datos de la PQC mediante una arquitectura dual-chain (L1 de anclaje + L2 de ejecución) con verificación post-cuántica (STARK).

## 2. Qué quedó hecho en TG1 (calificado 4.2)

- **Manuscrito:** 7 capítulos desarrollados (Introducción → Conclusiones) con arco narrativo único, bibliografía consolidada y una auditoría de consistencia aplicada (24 correcciones sobre 7 dimensiones).
- **Prototipo Rust (workspace de 8 crates):** compila; **110/110 tests** (2026-07-31). Dilithium real vía el crate `fips204` (FIPS 204; KeyGen determinista desde semilla, tamaños exactos: firma D3 = 3.309 B). Benchmarks Criterion: firma ~0,79 ms, verificación ~0,23 ms (D3).
- **PoC STARK post-cuántico** (`nexus-zk::stark`: Goldilocks, NTT, Merkle/SHA3, Fiat-Shamir, FRI, AIR) endurecido a ~100 bits de soundness bajo condiciones declaradas; verificación succinta medida (256× de cómputo → ~2,6× de tiempo de verificación). Reemplaza al scaffold Groth16 (emparejamientos → vulnerable a Shor).
- **Validación formal (Cap. 6):** prueba game-based completa de sUF-CMA → MLWE + SelfTargetMSIS + MSIS, con lemas de simulación y extracción; revisada adversarialmente sin errores encontrados.
- **Gestión de claves (Cap. 5 / código):** min-entropía + pruebas de salud NIST SP 800-90B (RCT/APT) + rotación forward-secure, implementadas y testeadas.

## 3. Qué propone TG2

Cierre de los **Objetivos 3 y 4** (lo que resta es acotado: parametrización APT, registro auditable de rotación, comparativa vs. ECDSA/RSA, análisis O() en el capítulo) **más una línea de contribución propia** consolidada en el intersemestre:

| Contribución | Núcleo | Estado |
| :--- | :--- | :--- |
| **KeyGen-por-firma** | Regenerar el par ML-DSA desde la semilla de 32 B justo antes de firmar y zeroizar (benchmark propio: +0,75 ms/firma; huella en reposo 187,3× menor) | Benchmark hecho; §5.6 del manuscrito escrita |
| **Métrica W = bytes × Δt** | Formalizar la "ventana de exposición" de la clave en RAM como métrica de política | Hueco confirmado en la literatura (lo más cercano: Sawa et al., ACSAC 2025) |
| **Deception Engine PQ** | Par señuelo (honeytoken) que firma válido + detección off-chain por el sequencer L2 (patrón honeychecker) | Diseño documentado; se declara como diseño, PoC opcional |
| **Caso de uso agéntico** | Pagos ejecutados por agentes de IA como motivación: la literatura 2026 (SoK arXiv:2604.03733) declara abiertas exactamente las brechas que lo anterior ataca (*weak intent binding*, *misuse under valid authorization*), sin PQC en ese espacio | Estado del arte verificado (ago. 2026); 18 referencias ya en bibliografía |

**Posición de novedad:** el formato semilla-only ya es estándar (FIPS 204, RFC 9881) — no se reclama; lo defendible es KeyGen-por-firma como política (la guía IETF vigente recomienda lo contrario: cachear), la métrica W, y la síntesis deception+PQC+L2 (prior art más cercano: patente Amazon US 10,521,584 B1, sin PQC).

## 4. Qué se solicita en la reunión inicial

1. Discutir y **acordar el plan de trabajo** adjunto (el comité lo exige formalizado); ajustar alcance de las contribuciones si lo considera.
2. Fijar **fechas y cadencia de entregas parciales** (propuesta mínima: una por fase, 5 en el semestre).
3. Definir el **canal de comunicación** y el formato de seguimiento (se propone: correo institucional + acta breve por reunión + bitácora pública en el repo).

## 5. Dónde está cada cosa

- Manuscrito: `Documentos/01-Manuscrito/` (capítulos en `Capitulos/`, ensamblado en `Tesis-NEXUS-completa.md/.docx`).
- Plan de trabajo y seguimiento TG2: `Documentos/04-Administrativo-TG2/` + `BITACORA_TG2.md` (raíz del proyecto).
- Estados del arte con fuentes verificadas: `Documentos/02-Investigacion-y-Notas/`.
- Código: repo `nexus` (build: `CARGO_TARGET_DIR` externo; instrucciones en el README).
