# Estado del Proyecto NEXUS — Brief para el Director

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
