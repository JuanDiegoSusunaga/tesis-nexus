# Entrega Parcial N.º 01 — TG2 · Proyecto NEXUS

**Estudiante:** Juan Diego Susunaga Velasquez · **Director:** Pedro Mario Wightman Rojas
**Fecha de entrega:** 2026-08-09 · **Período cubierto:** 2026-08-03 a 2026-08-09
**Fase del plan de trabajo:** F1–F2 (adelantos; F0 pendiente de agenda) · **Objetivo(s)/Contribución(es):** Obj 3, Obj 4, C1, C2, C5

> **Estado: BORRADOR** — pendiente de revisión antes de enviar.

---

## 1. Resumen del avance (máx. 5 líneas)

Se completó e integró al Cap. 6 la validación empírica del Objetivo 4 (dos perfiles de hardware, comparativa medida vs. ECDSA/RSA, verificador STARK hasta 2¹⁸ pasos, throughput multinúcleo). Se resolvió empíricamente la **Decisión 001** con un hallazgo relevante: el corte del APT implementado viola el α de diseño ~700× (propuesta de corrección validada con 67 M de ventanas simuladas, sin aplicar a la espera de acuerdo). La contribución C1 quedó con benchmark reproducible versionado (+0,12 ms en hardware moderno) y se preparó un borrador de diseño para la **Decisión 002**. Finalmente se aplicó una **revisión crítica del manuscrito** (seis correcciones de exposición, sin cambio de resultados) y se añadió el **encuadre de dominio bancario** (§1.3, requisitos R1–R6).

## 2. Actividades realizadas y evidencia

| Actividad (del plan de trabajo) | Resultado | Evidencia (commit / test / sección del manuscrito / documento) |
| :--- | :--- | :--- |
| Entorno de desarrollo replicado en segundo equipo | Rust 1.97.1 MSVC + Build Tools; **110/110 tests** | `BITACORA_TG2.md` (2026-08-07); `cargo test` |
| Benchmarks ML-DSA en 2.º perfil de hardware (F2) | D3: keygen 142 µs / firma 290 µs / verif. 77,6 µs (2,5–3,0× vs. H1); forma del escalado preservada | Cap. 6 §6.6.1, Tabla 6.3; `benches/dilithium_bench.rs` |
| Comparativa vs. clásicos integrada al capítulo (cierra pendiente F2) | Verificación D3 del **mismo orden de magnitud** que ECDSA/RSA —1,9× más rápida que ECDSA P-256 *en este banco*, con la salvedad de *backend* declarada (todos los esquemas en Rust puro; una ECDSA con ensamblador optimizado invertiría el orden)— | Cap. 6 §6.6.2, Tabla 6.4; `benches/classical_baseline.rs` |
| Verificador STARK: curva extendida 64× | Traza ×16.384 ⇒ prueba ×6,0 y verificación ×6,2 (confirmación polilogarítmica; firma del log² observada) | Cap. 6 §6.6.3, Tabla 6.5; `examples/stark_demo.rs` |
| Throughput de verificación multinúcleo (última métrica Act. 4.2) | 12.485 → **199.218 verif/s** (1→24 hilos) | Cap. 6 §6.6.1; `examples/throughput_tps.rs` (nuevo) |
| **Decisión 001** (Act. 3.1): barrido empírico de (W, C) del APT | Hallazgo: corte actual dispara cada ~12 MB con fuente sana; propuesta W=512, C=16 (binomial exacta) + lote MCV ≥ 65.536 | `Decision-001-Parametros-APT.md`; `examples/apt_sweep.rs` (nuevo, con verificación de equivalencia contra `HealthMonitor`) |
| C1: benchmark de residencia efímera reproducible | Sobrecosto de KeyGen-por-firma: **+0,12 ms** en H2 (era +0,75 ms en H1); punto de equilibrio λ≈2.300 firmas/s | Cap. 5 §5.6; `benches/residencia_bench.rs` (nuevo) |
| **Decisión 002** (Act. 3.2): borrador de diseño del registro auditable | Propuesta: log encadenado por hash en L2 + anclaje Merkle en L1 | `Decision-002-Registro-Auditable-Rotaciones.md` (borrador) |
| Consistencia del manuscrito | Cifras H1 unificadas a la corrida oficial (README 2026-07-31) | Cap. 6 Tabla 6.2 |
| **Revisión crítica del manuscrito** (08-09) | Seis correcciones de exposición **sin cambio de resultados**: (a) la afirmación sobre la verificación vs. ECDSA acotada a igualdad de orden de magnitud; (b) métrica W declarada heurística, liderando con el argumento de categoría de custodia; (c) *trade-off* de canal lateral de C1 declarado; (d) 17 referencias no citadas movidas a un anexo declarado; (e) §7.3 reordenada por grado de originalidad; (f) columna de generación de la Tabla 6.5 declarada corrida única de una variable geométrica | Caps. 2, 5, 6, 7 + bibliografía; `BITACORA_TG2.md` (2026-08-09) |
| **Encuadre de dominio bancario** (08-09) | Nueva **§1.3** con seis requisitos R1–R6 anclados en BIS *Project Leap*, DORA art. 9(2) y el PQFIF de la SEC —tres fuentes que ya estaban en el índice del estado del arte y no se citaban—, cada uno trazado al punto que lo atiende. Contraste añadido en §6.6.2: el «mayor tiempo de procesamiento» que reportó Leap Fase 2 es de extremo a extremo, no de la primitiva, y **confirma** el diagnóstico de la tesis | Caps. 1, 3, 4, 5, 6, 7; `BITACORA_TG2.md` (2026-08-09) |

## 3. Desviaciones respecto al plan

La reunión F0 (acuerdo del plan) aún no se realiza; para no bloquear el semestre se adelantó trabajo de F1–F2 que no dependía de decisiones del director, y las dos decisiones de diseño que sí lo requieren (001 y 002) se llevaron **hasta propuesta documentada sin aplicar cambios**. Sin otras desviaciones.

## 4. Próximos pasos (hasta la siguiente entrega)

- [ ] Reunión F0: acordar plan, fechas y cadencia de entregas.
- [ ] Aplicar la corrección del corte APT tras el acuerdo (≈15 líneas + test de regresión) y actualizar Cap. 5 con los parámetros y la caracterización de tres capas (RCT/APT/MCV).
- [ ] Decisión 002: refinar el diseño acordado e implementar el log de rotaciones.
- [ ] Iniciar la matriz de trazabilidad afirmación→fuente.
- [ ] Regenerar `Tesis-NEXUS-completa.docx` (el `.md` cambió el 08-09; la última regeneración es del 08-07).
- [ ] Versionar en el repo `nexus` los *harnesses* nuevos (`apt_sweep.rs`, `throughput_tps.rs`, `residencia_bench.rs`, `stark_demo.rs` extendido).

## 5. Preguntas y decisiones que requieren al director

1. **Aprobar la Decisión 001** (W=512, C=16 por binomial exacta, lote MCV ≥ 65.536). *Recomendación propia: sí — el corte actual viola el α de diseño y la corrección tiene costo de latencia cubierto por la capa MCV; evidencia en el documento adjunto.*
2. **Retroalimentar el borrador de la Decisión 002** (log en L2 con anclaje L1): ¿es aceptable la cadencia de anclaje propuesta y la residencia del módulo en `nexus-core`?
3. **Fijar fechas del cronograma y cadencia de entregas** (condición (ii)/(iii) del comité).
4. **Confirmar la política de cifras**: se declaró oficial la corrida H1 del README (2026-07-31, toolchain documentado); las corridas nuevas se reportan siempre con fecha, máquina y harness.

## 6. Retroalimentación del director (a diligenciar tras la revisión)

**Fecha de revisión:** · **Medio:** (reunión / correo)
**Observaciones:**

**Estado de la entrega:** ☐ Aprobada ☐ Aprobada con ajustes ☐ Requiere reentrega
