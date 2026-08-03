# Plan de Trabajo — Trabajo de Grado 2 (TG2)

**Proyecto:** Arquitectura Blockchain Dual NEXUS: Un Modelo Matemático-Computacional para Sistemas Bancarios Seguros y Resilientes Post-Cuántico
**Estudiante:** Juan Diego Susunaga Velasquez · Matemáticas Aplicadas y Ciencias de la Computación (MACC), Universidad del Rosario
**Director:** Pedro Mario Wightman Rojas
**Fecha:** 2026-08-03 · **Versión:** Borrador v0.1 — **PARA DISCUSIÓN Y ACUERDO CON EL DIRECTOR**
**Repositorio:** github.com/JuanDiegoSusunaga/nexus

> ⚠️ Las fechas exactas del cronograma se fijarán en la primera reunión con el director; este borrador usa hitos relativos (semanas) sobre el semestre 2026-2.

---

## 1. Contexto

- **TG1 entregado y calificado (4.2)**, evaluado por el prof. Wightman sobre el avance presentado (manuscrito + prototipo Rust).
- **Condiciones del Comité de Opciones de Grado** (correo 2026-08-03): (i) comunicación permanente con el director, (ii) plan de trabajo de TG2 **acordado con el director**, (iii) **entregas parciales** formalizadas para seguimiento y aprobación por etapas. Este documento responde a la condición (ii); la §5 y la plantilla de entregas responden a la (iii).
- El alcance vigente es el **v2** (modificación de objetivos formalizada en TG1): modelo formal y prototipo de referencia de firmas post-cuánticas (CRYSTALS-Dilithium/ML-DSA) en una arquitectura dual-chain para banca, con validación formal y de complejidad.

## 2. Objetivos de TG2

TG2 cubre los **Objetivos Específicos 3 y 4** del alcance v2, más una línea de contribución propia consolidada durante el intersemestre:

| ID | Objetivo / Contribución | Estado de partida | Qué falta en TG2 |
| :-- | :--- | :--- | :--- |
| **Obj 3** | Gestión activa del ciclo de vida de claves: min-entropía + pruebas de salud NIST SP 800-90B (RCT/APT) + rotación forward-secure | Implementado en `nexus-crypto/entropy.rs` con tests | Parametrización final W/C de APT (Decisión 001); registro auditable de rotación en el Key Registry (Decisión 002); documentación en Cap. 5 |
| **Obj 4** | Validación formal (reducción sUF-CMA → MLWE/SelfTargetMSIS/MSIS → Mod-SIVP) + análisis O() + benchmarks | Prueba game-based desarrollada y verificada (Cap. 6); benchmarks Dilithium y STARK ejecutados | Comparativa vs. ECDSA/RSA en la misma suite; análisis O() integrado al capítulo; consolidación final |
| **C1** | **KeyGen-por-firma** como política de minimización de exposición (benchmark: +0,75 ms/firma; huella en reposo 187,3×) | Benchmark hecho; §5.6 del manuscrito escrita | Formalización de la política y su justificación frente a draft-connolly (que recomienda cachear) |
| **C2** | **Métrica W = bytes × Δt** de ventana de exposición | Definida; hueco confirmado en el estado del arte (lo más cercano: Sawa et al. ACSAC 2025) | Formalización + cuantificación empírica para ML-DSA-65 |
| **C3** | **Deception Engine PQ** (honeytoken + sequencer-honeychecker L2) | Diseño V2 documentado; declarado en Cap. 7 como diseño no implementado | Diseño formal con requisitos de indistinguibilidad. **PoC implementado = opcional, no comprometido** |
| **C4** | **Caso de uso agéntico** como motivación (pagos por agentes de IA) | Estado del arte verificado (ago. 2026) + 18 referencias en bibliografía | Integración de párrafos en Cap. 1 (motivación), Cap. 7 (discusión + trabajo futuro) |

**Sustento de novedad (para defensa):** la revisión de literatura 2026 (SoK arXiv:2604.03733) declara abiertas exactamente las brechas que C1–C3 atacan — *weak intent binding* (→ subclaves por tarea), *misuse under valid authorization* (→ honeytoken/honeychecker) y *limited accountability* (→ métrica W) — y ningún trabajo del espacio combina esto con PQC. Detalle en `Documentos/02-Investigacion-y-Notas/Estado-del-Arte-Claves-Efimeras-y-Deception.md` y `...-Pagos-Agenticos.md`.

## 3. Estado de partida (resumen verificable)

- **Manuscrito:** 7 capítulos desarrollados + bibliografía consolidada + auditoría de consistencia aplicada (24 correcciones).
- **Código:** workspace Rust compila; **110/110 tests** (2026-07-31, rustc 1.97.1); Dilithium real vía `fips204` (KeyGen determinista desde semilla); STARK PoC endurecido (~100 bits bajo condiciones declaradas) con verificación succinta medida.
- **Estados del arte:** claves efímeras/deception (jul. 2026) y pagos agénticos (ago. 2026), ambos con fuentes primarias verificadas.
- **Bitácora TG2** activa en `BITACORA_TG2.md` (registro continuo de avances, regla de inmutabilidad de TG1).

## 4. Plan de actividades (hitos relativos — fechas por acordar)

| Fase | Semanas | Actividades | Entrega parcial |
| :-- | :-- | :--- | :-- |
| **F0 — Arranque** | 1 | Reunión inicial con el director: presentación del estado (brief adjunto), discusión y **acuerdo de este plan**, fijación de fechas y cadencia de entregas, canal de comunicación | **E0:** plan de trabajo acordado (este documento con fechas) |
| **F1 — Cierre Obj 3** | 2–4 | Decisión 001 (parámetros W/C de APT según fuente de entropía objetivo); Decisión 002 (registro auditable de eventos de rotación en Key Registry); actualización de Cap. 5 con lo implementado | **E1:** Cap. 5 cerrado + evidencia de código/tests |
| **F2 — Cierre Obj 4** | 4–7 | Comparativa empírica Dilithium vs. ECDSA/RSA (misma suite Criterion); análisis O() integrado en Cap. 6; verificación de invariantes de consistencia | **E2:** Cap. 6 cerrado + tabla comparativa |
| **F3 — Contribuciones C1–C4** | 7–10 | Formalización KeyGen-por-firma + métrica W (sección autocontenida, potencial artículo); diseño formal del Deception Engine (indistinguibilidad, rol del sequencer-honeychecker); párrafos del caso agéntico en Cap. 1 y Cap. 7 | **E3:** secciones nuevas del manuscrito + documento de diseño |
| **F4 — Consolidación** | 10–12 | QA de invariantes en todo el manuscrito; regeneración docx/PDF en formato institucional (TNR 12, interlineado 1,5); preparación de presentación y ensayo de defensa | **E4:** documento final + presentación de sustentación |

**Cadencia de entregas parciales:** propuesta mínima = una entrega por fase (5 en el semestre); cadencia definitiva **por acordar con el director** en F0. Cada entrega usa la plantilla `Formatos/Plantilla-Entrega-Parcial-TG2.md` y queda registrada en `Avances/`.

## 5. Entregables

| ID | Entregable | Evidencia | Fecha |
| :-- | :--- | :--- | :-- |
| E0 | Plan de trabajo acordado | Este documento con fechas + confirmación escrita del director | por acordar |
| E1 | Objetivo 3 cerrado | Cap. 5 + `entropy.rs`/Key Registry con tests + entrada de bitácora | por acordar |
| E2 | Objetivo 4 cerrado | Cap. 6 + benchmarks comparativos publicados en el repo | por acordar |
| E3 | Contribuciones C1–C4 integradas | §§ del manuscrito + diseño del Deception Engine | por acordar |
| E4 | Documento final + sustentación | PDF institucional + presentación | por acordar |

## 6. Metodología y seguimiento (respuesta a las condiciones del comité)

1. **Registro continuo:** toda actividad se asienta en `BITACORA_TG2.md` (changelog con fecha, objetivo, evidencia).
2. **Entregas formalizadas:** cada entrega parcial usa la plantilla estándar y se archiva en `Documentos/04-Administrativo-TG2/Avances/` con la retroalimentación del director.
3. **Comunicación por escrito:** acuerdos por correo institucional; acta breve de cada reunión (fecha, decisiones, compromisos) archivada en `04-Administrativo-TG2/`.
4. **Trazabilidad de código:** commits en el repo público con mensajes descriptivos; suite de tests como criterio de aceptación.

## 7. Riesgos y mitigación

| Riesgo | Mitigación |
| :--- | :--- |
| Scope creep del Deception Engine (C3) | Declarado como **diseño formal**; PoC explícitamente opcional y no comprometido |
| Desalineación con los intereses del director | F0 dedicada a acordar el plan; el director puede reponderar fases antes de fijar fechas |
| Inconsistencias del manuscrito al integrar secciones nuevas | Invariantes de consistencia del Plan Maestro (§6) verificadas en cada entrega; auditoría final en F4 |
| Tiempos de benchmarking | La suite Criterion ya existe; la comparativa ECDSA/RSA reutiliza el mismo harness |

## 8. Documentos de referencia

- `Documentos/02-Investigacion-y-Notas/Plan-Maestro-Tesis.md` — torre de control de la tesis.
- `BITACORA_TG2.md` — bitácora de seguimiento TG2.
- `Documentos/04-Administrativo-TG2/Estado-del-Proyecto-para-Director.md` — brief para la reunión inicial.
- `Documentos/02-Investigacion-y-Notas/Estado-del-Arte-Claves-Efimeras-y-Deception.md` y `Estado-del-Arte-Pagos-Agenticos.md` — sustento de novedad.
- `Lluvia de ideas/Dilithium-Multisemilla-Efecto-Observador-V2.md` — diseño V2 (C1–C3).
