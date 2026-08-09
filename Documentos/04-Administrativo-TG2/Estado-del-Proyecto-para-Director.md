# Estado del Proyecto NEXUS — Brief para el Director

**Para:** Prof. Pedro Mario Wightman Rojas · **De:** Juan Diego Susunaga Velasquez (MACC)
**Fecha:** 2026-08-03 · **Actualizado:** 2026-08-09 · **Propósito:** presentar el estado del proyecto al asumir la dirección y preparar la reunión inicial de TG2.
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

## 2b. Avances desde la redacción de este brief (2026-08-03 → 08-09)

El trabajo no se detuvo a la espera de la reunión. Lo hecho en estos días, con evidencia en la bitácora:

- **Objetivo 4, parte empírica cerrada.** Benchmarks re-ejecutados en un **segundo perfil de hardware**; comparativa medida contra ECDSA P-256 y RSA-2048/3072 **en el mismo banco**; verificador STARK extendido hasta $2^{18}$ pasos (×16.384 de cómputo ⇒ ×6,2 de tiempo de verificación); throughput multinúcleo (199.218 verificaciones/s con 24 hilos). Cap. 6 §6.6 reestructurado en tres subsecciones.
- **Decisión 001 resuelta empíricamente, con un hallazgo que conviene mirar.** El barrido de parámetros del APT (67 M de ventanas simuladas) muestra que **el corte implementado viola el α de diseño ~700×**: dispara rotación espuria cada ~12 MB *incluso con una fuente perfecta*. El corte binomial exacto que prescribe SP 800-90B (C=16 en W=512) cumple con margen. **La corrección está validada pero no aplicada**, a la espera de su acuerdo — es la decisión más concreta que traigo a la reunión.
- **Decisión 002 en borrador:** registro auditable de rotaciones como log encadenado por hash en L2 con anclaje Merkle en L1.
- **Contribución C1 con benchmark reproducible versionado** (+0,12 ms/firma en hardware moderno).
- **Revisión crítica del manuscrito (08-09).** Seis correcciones de exposición, **sin cambiar ningún resultado**, dirigidas a los puntos donde el texto afirmaba más de lo que necesitaba. La más relevante: la tesis sostenía que «Dilithium3 verifica más rápido que ECDSA»; es cierto en nuestro banco, pero el `p256` de RustCrypto es Rust puro y las implementaciones de despliegue real (libsecp256k1, OpenSSL) verifican mucho más rápido, lo que invertiría el orden. Se reencuadró a **igualdad de orden de magnitud**, que es lo único que el argumento central —«el penalizador post-cuántico es de datos, no de cómputo»— realmente necesita, y que sí es robusto. En la misma línea se declaró el *trade-off* de canal lateral de C1 y se acotó el estatus de la métrica W.
- **Encuadre de dominio bancario (nueva §1.3).** Ver la fila R1–R6 de la tabla siguiente.

*(Detalle completo en `Avances/Entrega-Parcial-01-2026-08-07.md` y en `BITACORA_TG2.md`.)*

## 3. Qué propone TG2

Cierre de los **Objetivos 3 y 4** (lo que resta es acotado: parametrización APT, registro auditable de rotación, comparativa vs. ECDSA/RSA, análisis O() en el capítulo) **más una línea de contribución propia** consolidada en el intersemestre:

| Contribución | Núcleo | Estado |
| :--- | :--- | :--- |
| **KeyGen-por-firma** | Regenerar el par ML-DSA desde la semilla de 32 B justo antes de firmar y zeroizar. Benchmark reproducible y versionado: **+0,12 ms/firma** en el portátil de 2026 (+0,75 ms en el de 2017). El beneficio de fondo no es el cociente de tamaños sino el **cambio de categoría de custodia**: 32 B se sellan en TPM/HSM, ~4 KB viven en montón paginable | Benchmark hecho; §5.6 escrita y **formalizada**, con el *trade-off* declarado (ver abajo) |
| **Métrica W = bytes × Δt** | "Ventana de exposición" de la clave en RAM como métrica de política, con punto de equilibrio derivado (λ≈2.300 firmas/s). Se declara **heurística de ingeniería, no cota de probabilidad de compromiso** — la semilla de 32 B compromete tanto como la clave expandida | Hueco confirmado en la literatura (lo más cercano: Sawa et al., ACSAC 2025) |
| **Deception Engine PQ** | Par señuelo (honeytoken) que firma válido + detección off-chain por el sequencer L2 (patrón honeychecker) | Diseño documentado; se declara como diseño, PoC opcional |
| **Caso de uso agéntico** | Pagos ejecutados por agentes de IA como motivación: la literatura 2026 (SoK arXiv:2604.03733) declara abiertas exactamente las brechas que lo anterior ataca (*weak intent binding*, *misuse under valid authorization*), sin PQC en ese espacio | Estado del arte verificado (ago. 2026); sus 17 referencias están en un **anexo bibliográfico declarado** hasta que el caso se integre al texto |
| **Encuadre de dominio (R1–R6)** | Seis requisitos bancarios explícitos —autenticidad normativa, horizonte de décadas, cripto-agilidad, custodia gobernada, trazabilidad auditable, finalidad determinista— anclados en el **Project Leap del BIS**, **DORA art. 9(2)** y el marco **PQFIF** presentado a la SEC, y trazados uno a uno al punto del manuscrito que los atiende | Nueva §1.3 (2026-08-09); no estaba en el borrador del plan |

**Posición de novedad (acotada deliberadamente).** El formato semilla-only **ya es estándar** (FIPS 204 §3.6.3, RFC 9881) y **no se reclama**. Lo defendible es: (i) **KeyGen-por-firma como política** —la guía IETF vigente recomienda lo contrario, cachear—, con su medición y con el *trade-off* declarado sin adornos: la política **reduce** la exposición a volcados de memoria y **aumenta** el número de trazas disponibles a un análisis de canal lateral, escenario que la tesis deja fuera de alcance; (ii) la **métrica W**, declarada heurística; y (iii) la **síntesis deception+PQC+L2** (prior art más cercano: patente Amazon US 10,521,584 B1, sin PQC).

## 4. Qué se solicita en la reunión inicial

1. Discutir y **acordar el plan de trabajo** adjunto (el comité lo exige formalizado); ajustar alcance de las contribuciones si lo considera.
2. Fijar **fechas y cadencia de entregas parciales** (propuesta mínima: una por fase, 5 en el semestre).
3. Definir el **canal de comunicación** y el formato de seguimiento (se propone: correo institucional + acta breve por reunión + bitácora pública en el repo).
4. **Aprobar la Decisión 001** (parámetros W=512, C=16 del APT, corte binomial exacto). Es la única decisión que hoy bloquea código: la corrección está validada empíricamente y sin aplicar, y son ~15 líneas más un test de regresión. Con su visto bueno, el Objetivo 3 queda cerrable en días.
5. **Orientación sobre C1–C2** (residencia efímera y métrica W): si los considera suficientemente autocontenidos, evaluar extraerlos como artículo corto además de su lugar en el manuscrito.

## 5. Dónde está cada cosa

- Manuscrito: `Documentos/01-Manuscrito/` (capítulos en `Capitulos/`, ensamblado en `Tesis-NEXUS-completa.md/.docx`).
- Plan de trabajo y seguimiento TG2: `Documentos/04-Administrativo-TG2/` + `BITACORA_TG2.md` (raíz del proyecto).
- Estados del arte con fuentes verificadas: `Documentos/02-Investigacion-y-Notas/`.
- Código: repo `nexus` (build: `CARGO_TARGET_DIR` externo; instrucciones en el README).
