# ✅ Pendientes — Tesis NEXUS (TG2)

> Vista consolidada de **qué falta** (la cronología de lo hecho vive en [BITACORA_TG2.md](BITACORA_TG2.md); las fases, en [Plan-de-Trabajo-TG2.md](Documentos/04-Administrativo-TG2/Plan-de-Trabajo-TG2.md)).
> Actualizado: **2026-08-07**.

## 🔴 Administrativo (condiciones del comité — bloquea todo lo demás)

- [ ] **Reunión F0 con Wightman:** presentar el brief (`Documentos/04-Administrativo-TG2/Estado-del-Proyecto-para-Director.md`), acordar el Plan de Trabajo (fijar fechas y cadencia de entregas) → entregable E0.
- [ ] Enviar la **primera entrega parcial** — **borrador listo** (2026-08-07): `Documentos/04-Administrativo-TG2/Avances/Entrega-Parcial-01-2026-08-07.md`. Falta: revisarlo y enviarlo al director.

## 🟡 Decisiones de diseño abiertas

- [ ] **Decisión 001 (parámetros W/C del APT):** propuesta empírica **lista** — W=512, C=16 (binomial exacta) + lote MCV ≥ 65.536 (`Documentos/02-Investigacion-y-Notas/Decision-001-Parametros-APT.md`). Falta: acuerdo con el director → aplicar el cambio (~15 líneas en `HealthMonitor::new`, la referencia `exact_cutoff` ya está en `apt_sweep.rs`) + test de regresión + párrafo en Cap. 5.
- [ ] **Decisión 002 (registro auditable de rotaciones en el Key Registry):** **borrador de diseño listo** (2026-08-07): log encadenado por hash en L2 + anclaje Merkle en L1 (`Documentos/02-Investigacion-y-Notas/Decision-002-Registro-Auditable-Rotaciones.md`). Falta: discutirlo con el director e implementar (~1 semana estimada).
- [ ] **Decisión 003 (suite de benchmarks):** de facto resuelta (Criterion: `dilithium_bench` + `classical_baseline`; harness `stark_demo` + `apt_sweep`); formalizarla como decisión cerrada en la bitácora tras la F0.

## 📄 Manuscrito

- [x] ~~**Unificar las cifras del perfil H1**~~ — resuelto 2026-08-07: la oficial es la corrida del **README (2026-07-31, rustc 1.97.1)**: D3 = 413/790/232 µs. Tabla 6.2 actualizada (venía de una corrida pre-julio sin fecha); §5.6, bitácora y README ya coinciden. Nota honesta añadida en §6.6.2: en H1, RSA-2048 verificaba marginalmente más rápido que D3 (218 vs 232 µs).
- [x] ~~**Regenerar `Tesis-NEXUS-completa.docx`**~~ — hecho 2026-08-07 (pandoc 3.10.1 instalado en el portátil nuevo; `.docx` con todos los cambios del día).
- [ ] **Cap. 5:** incorporar el cuadro de tres capas (RCT ≤4 muestras / APT 10³–10⁶ / MCV 1 lote) y los parámetros acordados, cuando se cierre la Decisión 001.
- [ ] README de `nexus`: actualizar tablas D2/D5 y STARK con el perfil H2 (opcional, consistencia con el capítulo).
- [ ] Matriz de trazabilidad afirmación→fuente (`Resumenes-y-Matriz/`) — hueco identificado el 2026-08-03, no urgente.

## 🧪 Código y experimentos

- [x] ~~**Benchmark reproducible de la métrica W (contribución C1)**~~ — hecho 2026-08-07: `benches/residencia_bench.rs`; en H2 el sobrecosto es **+0,12 ms** (cacheada 314 µs → efímera 432 µs); §5.6 actualizada.
- [x] ~~**Throughput multinúcleo (tps)**~~ — hecho 2026-08-07: `examples/throughput_tps.rs`; D3: 12.485 → **199.218 verif/s** (1→24 hilos); §6.6.1 actualizada.
- [ ] Aplicar la corrección del corte APT (bloqueada por Decisión 001).

## 🗃️ Repos (cambios sin commitear del 2026-08-07)

- [ ] **Commit en `Tesis/`:** `BITACORA_TG2.md`, `Cap5-Gestion-Claves.md`, `Cap6-Validacion-Formal.md`, `Tesis-NEXUS-completa.md` (+ `.docx`), `Decision-001-Parametros-APT.md`, `Decision-002-Registro-Auditable-Rotaciones.md`, `Avances/Entrega-Parcial-01-2026-08-07.md`, este archivo.
- [ ] **Commit + push en `nexus/`:** `examples/apt_sweep.rs`, `examples/throughput_tps.rs`, `benches/residencia_bench.rs` (nuevos), `examples/stark_demo.rs` (trazas extendidas a 2¹⁸), `Cargo.toml` (target del bench nuevo).

## 🔭 Trabajo futuro ya declarado (no es deuda de TG2)

Aritmetización completa del AIR + DEEP/out-of-domain del STARK · paralelización del prover · PoC del Deception Engine (C3, explícitamente no comprometido) · KEM post-cuántico (ML-KEM) · registro L1/L2 del Key Registry más allá de la Decisión 002.
