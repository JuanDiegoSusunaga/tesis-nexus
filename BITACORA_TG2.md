# 📓 Bitácora de Trabajo de Grado 2 (TG2) — Proyecto NEXUS

**Proyecto:** *Arquitectura Blockchain Dual NEXUS: Un Modelo Matemático-Computacional para Sistemas Bancarios Seguros y Resilientes Post-Cuántico*  
**Período:** Semestre Académico TG2 (2026)  
**Estado General:** En Desarrollo Activo (Objetivos 3 y 4)  

---

> [!IMPORTANT]  
> **Regla de Inmutabilidad de TG1:** Todo el trabajo y los registros de esta bitácora están enfocados de manera estricta y exclusiva en **Trabajo de Grado 2 (TG2)** (Objetivos Específicos 3 y 4). El alcance, documentos y entregables aprobados en TG1 permanecen inalterables.

---

## 🎯 Objetivos de TG2 Bajo Seguimiento

| Objetivo Específico | Descripción Breve | Estado |
| :--- | :--- | :--- |
| **Objetivo 3** | Lógica de seguridad activa del ciclo de vida de claves: monitoreo de min-entropía (NIST SP 800-90B: RCT y APT) y rotación con secrecia hacia adelante. | 🟡 En Desarrollo |
| **Objetivo 4** | Formalización teórica (reducción inforjabilidad Dilithium \(\rightarrow\) Mod-SIVP) y validación empírica (análisis \(\mathcal{O}\) y *benchmarks*). | 🟡 En Desarrollo |

---

## 📋 Registro Semestral de Avances y Cambios (Changelog)

| Fecha | Categoría / Objetivo | Componente Afectado | Descripción del Cambio / Avance | Estado / Evidencia |
| :--- | :--- | :--- | :--- | :--- |
| **2026-07-31** | Objetivo 3 / TG2 | Modelo de Entropía (§5.2) | Consolidación del cambio metodológico de Entropía de Shannon a **Min-Entropía (\(H_{\infty}\), NIST SP 800-90B)** y definición de pruebas en línea (RCT y APT). | 🟢 Completado (Notas / Doc) |
| **2026-07-31** | General / TG2 | Estructura de Proyecto | Creación de la Bitácora de Seguimiento de TG2 (`BITACORA_TG2.md`) e integración de las notas de la revisión bibliográfica. | 🟢 Completado |
| **2026-07-31** | Objetivo 3 / TG2 | `nexus-crypto/entropy.rs` | **Auditoría del código:** se constató que las Actividades 3.1 y 3.2 ya están mayormente implementadas desde junio: `HealthMonitor` con RCT (corte \(C = 1 + \lceil -\log_2\alpha / H \rceil\)) y APT (ventana 512), bloqueo del KDF ante fallo, y rotación con *forward secrecy*; cubierto por tests (`test_health_rct_detects_stuck_source`, `test_ingest_unhealthy_source_triggers_rotation`, `test_sentinel_seed_rotation_forward_secure`). | 🟢 Verificado (código + tests) |
| **2026-07-31** | General / TG2 | `nexus/` (README, Cargo.toml, .gitignore) | Sincronización documentación↔código: README actualizado (Sentinel-Seed pasa de "Parcial — métrica a reformular" a "Implementado"; eliminados restos obsoletos sobre `from_seed` no determinística y "correcciones de compilación" ya resueltas), URL del repo corregida en `Cargo.toml` (`JuanDiegoSusunaga/nexus`), y `.gitignore` cubre `logs/` y `nexus-monorepo/`. | 🟢 Completado |
| **2026-07-31** | Objetivo 4 / TG2 | README / `nexus-zk`, `nexus-active` | Corrección de **subestimación** en el README: el PoC STARK hash-based (`nexus-zk::stark`: Goldilocks, NTT, Merkle/SHA3, Fiat-Shamir, FRI, AIR) y el puente `PqValidityProof` en `verify_zk` (liga raíces pre/post) figuraban como "Trabajo futuro / placeholder" pese a estar implementados desde junio. Conteo de tests actualizado de 70 a 97 (última ejecución verificada, 2026-06-05). | 🟢 Completado |
| **2026-07-31** | Infraestructura | Toolchain Rust | Se detectó que el toolchain de Rust no estaba instalado; **reinstalado el mismo día** (rustup, Rust 1.97.1 MSVC, perfil minimal). Suite completa re-ejecutada: **110/110 tests pasan** (core 15, crypto 25, anchor 16, active 20, zk 34) con `CARGO_TARGET_DIR=C:\tmp\nexus-target`. | 🟢 Resuelto |
| **2026-07-31** | General / TG2 | Repo `nexus` (GitHub) | Removido `fuzzy_extractor.rs` (alcance v2), CLI `info` actualizado, y commit + push de toda la sincronización a `main` (`d6c81a5`). | 🟢 Completado |
| **2026-07-31** | Objetivo 3 / 4 / TG2 | Manuscrito (Caps. 2, 5, 7) + Estado del Arte | **Integración del estado del arte al manuscrito:** (1) Cap. 5: nueva **§5.6 "Residencia efímera de la clave en memoria"** (política KeyGen-por-firma, métrica $W$, benchmark +0,75 ms, nota de cumplimiento FIPS sobre derivación de $\xi$; secciones 5.6-5.8 renumeradas a 5.7-5.9); (2) Cap. 2 §2.7: viñeta de posicionamiento "Gestión y defensa de la clave del firmador" (RFC 9881, Puffer, Rollup-Boost, patente US 10,521,584); (3) Cap. 7: contribuciones 7-8 (residencia efímera + propuesta Deception Engine, declarada como diseño no implementado) y trabajo futuro 9 (Deception Engine con requisitos de indistinguibilidad); (4) bibliografía consolidada +9 entradas ([RFC9881], [Connolly26], [JR13], [ADP18], [BRS22], [Sawa25], [US10521584], [Puffer23], [RollupBoost25]); (5) `05-Estado-del-Arte/estado_del_arte.md` ampliado con §5. Cambios replicados en `Tesis-NEXUS-completa.md`. Además se creó `plantilla-referencia.docx` (reference-doc de pandoc con **Times New Roman 12, interlineado 1,5**, idioma es) y se regeneró `Tesis-NEXUS-completa.docx` con ella — comando: `pandoc Tesis-NEXUS-completa.md --reference-doc=plantilla-referencia.docx -o Tesis-NEXUS-completa.docx`. | 🟢 Completado |
| *Próximo* | Objetivo 3 (Act 3.1) | `nexus-crypto` / KDF | ~~Implementación del módulo RCT y APT~~ **Ya implementado (junio 2026).** Resta: fijar parámetros \(W\) y \(C\) según la fuente TRNG/PRNG objetivo (→ Decisión 001) y documentarlo en el capítulo. | 🟡 Parcial |
| *Próximo* | Objetivo 3 (Act 3.2) | `nexus-core` / Key Registry | Rotación por política con *forward secrecy* **ya implementada** en `entropy.rs`. Resta: registro auditable de eventos de rotación en el Key Registry (→ Decisión 002). | 🟡 Parcial |
| *Próximo* | Objetivo 4 (Act 4.1) | Documento Tesis / Cap 4-5 | Formalización teórica de la cadena de reducciones (\(\text{Dilithium} \to \text{Module-LWE/SIS} \to \text{Mod-SIVP}\)) y argumento de Shor. | ⏳ Pendiente |
| **2026-07-31** | Objetivo 4 (Act 4.2) | Benchmarking Suite | **Benchmarks empíricos ejecutados** (Criterion, 100 muestras, medianas, rustc 1.97.1): Dilithium3 — keygen 413 µs, firma 790 µs, verificación 232 µs (D2/D5 en README). PoC STARK: traza 16→4.096 pasos (256×) ⇒ prueba 129→434 KB (~3,4×) y verificación 4,5→11,4 ms (~2,6×) — comportamiento polilogarítmico confirmado. Resultados publicados en README (commit + push). | 🟡 Parcial — falta comparativa vs. ECDSA/RSA y análisis \(\mathcal{O}\) en el capítulo |
| **2026-07-31** | Objetivo 3 / 4 / TG2 | Lluvia de Ideas / Rediseño v2 | **Rediseño V2 "Dilithium 3 + Multisemilla + Deception Engine":** Consolidado en `Dilithium-Multisemilla-Efecto-Observador-V2.md`. Sustituye la inyección de `RDTSC` por un *Honeytoken Deception Engine* (firmas señuelo válidas en L2), *Threshold ML-DSA* (MPC para fragmentación de $s_1$), custodia en TPM/SGX y aislamiento de memoria con `zeroize` y `VirtualLock`. | 🟢 Completado (`.../V2.md`) |
| **2026-07-31** | Objetivo 3 / 4 / TG2 | Estado del Arte (Cap. 2 / 5 / 7) | **Revisión de estado del arte de la V2** (3 frentes paralelos con fuentes verificadas): (1) el formato *seed-only* ya es estándar (FIPS 204 §3.6.3, **RFC 9881** lo declara RECOMENDADO, OpenSSL 3.5 por defecto) — no es reclamable como novedad; (2) **sí son huecos reales**: KeyGen-por-firma como política de seguridad (draft-connolly sugiere lo contrario), métrica $W=\text{bytes}\times\Delta t$, y el Deception Engine PQ (prior art más cercano: patente Amazon US 10,521,584 B1, sin PQC ni disparador anti-debug); (3) ningún sistema 2024-2026 cierra el triángulo semilla sellada + detección de compromiso + respuesta L2 (parciales: Puffer Secure-Signer, Rollup-Boost/Unichain). Incluye 5 advertencias de diseño (indistinguibilidad del señuelo, matiz Storm-0558, restricción NIST sobre derivar ξ vía KDF). | 🟢 Completado (`Documentos/02-Investigacion-y-Notas/Estado-del-Arte-Claves-Efimeras-y-Deception.md`) |
| **2026-08-03** | General / TG2 | Dirección y comité | **Cambio de director aprobado:** Pedro Mario Wightman Rojas asume la dirección del trabajo de grado; **TG1 calificado 4.2** (evaluado por el prof. Wightman). Condiciones del comité para TG2: plan de trabajo acordado con el director, entregas parciales formalizadas y comunicación permanente por escrito. | 🟢 Registrado (correo del comité, 2026-08-03) |
| **2026-08-03** | C4 / TG2 | Estado del Arte / Bibliografía | **Estado del arte de pagos agénticos** (3 frentes con fuentes primarias verificadas, corte ago. 2026): protocolos AP2/x402 (AP2 donado a FIDO Alliance; x402 ~130M txns, cifra académica), redes de tarjetas (Visa IC/TAP, Mastercard Agent Pay; **retiro de Instant Checkout de OpenAI, mar-2026** = evidencia de inmadurez), OWASP agéntico (Top 10 2026, T1–T15) y papers x402 2026 — el **SoK arXiv:2604.03733 declara abiertas exactamente las brechas que C1–C3 atacan** (*weak intent binding*, *misuse under valid authorization*, *limited accountability*), sin PQC en ese espacio. **+18 entradas** en `_tesis-bibliografia.md` (incl. nueva sección OWASP). | 🟢 Completado (`Documentos/02-Investigacion-y-Notas/Estado-del-Arte-Pagos-Agenticos.md`) |
| **2026-08-03** | General / TG2 | Organización TG2 | **Formalización de TG2** (responde a las condiciones del comité): creados `Plan-de-Trabajo-TG2.md` (borrador v0.1 para acordar con el director: fases F0–F4, entregables E0–E4, riesgos y metodología de seguimiento), `Formatos/Plantilla-Entrega-Parcial-TG2.md` y el brief `Estado-del-Proyecto-para-Director.md`, todos en `Documentos/04-Administrativo-TG2/`. Plan Maestro actualizado con la Fase F (TG2). | 🟢 Completado |
| **2026-08-03** | General / TG2 | Auditoría y limpieza del repo | **Auditoría de los ~140 markdown** (2 barridos sistemáticos) + limpieza reversible a `Documentos/_archivo/`: 19 papers descartados (10 duplicados + 9 irrelevantes) y 33 dudosos archivados → corpus curado de **57 fuentes útiles** (nota de curaduría en `00_INDICE_DE_FUENTES.md`); archivados también los 2 `.bib` falsos (contenían 1 entrada de derecho administrativo, export de prueba UR), `Cap4-Validacion-Formal-Esqueleto.md` (superseded), el archivo de notas de revisión, el respaldo JSON de 7,1 MB y `nexus/nexus-monorepo/` (vestigial). **Estado del arte consolidado** en `02-Investigacion-y-Notas/` (el general renombrado a `Estado-del-Arte-General.md`); carpetas vacías eliminadas. Hueco identificado (no urgente): matriz de trazabilidad afirmación→fuente nunca construida (`Resumenes-y-Matriz/` estaba vacía). | 🟢 Completado |
| **2026-08-03** | General / TG2 | Manuscrito ensamblado | **`Tesis-NEXUS-completa.md` re-ensamblado y `.docx` regenerado** (pandoc + `plantilla-referencia.docx`): incorpora las 18 referencias nuevas de la bibliografía (agéntico/OWASP) y corrige el frontmatter — **director actualizado de L. Huertas a P. Wightman** y fecha a 03/08/2026. | 🟢 Completado |
| **2026-08-03** | Infraestructura | Control de versiones (documentos) | **Raíz de `Tesis/` puesta bajo git** (rama `main`; `.gitignore` excluye `nexus/` — repo propio — y las carpetas de configuración local de herramientas). Commit inicial `0e2ca4d` con TODO el proyecto incluido `_archivo/`; luego **`Documentos/_archivo/` eliminado definitivamente** en `ac5165d` — recuperable con `git checkout 0e2ca4d -- "Documentos/_archivo"`. Responde a la exigencia de formalización/trazabilidad del comité. | 🟢 Completado |

---

## 🔬 Detalle Técnico por Módulo de TG2

### 1. Módulo de Seguridad Activa del Ciclo de Vida de Claves (Objetivo 3)

#### Actividad 3.1: Fuente de Entropía y Pruebas NIST SP 800-90B
* **Métrica Aceptada:** Min-entropía de peor caso (\(H_{\infty} = -\log_2(\max P(x_i))\)).
* **Mecanismos de Control:**
  * **Repetition Count Test (RCT):** Dispara alerta y bloqueo si se observan \(B\) muestras idénticas consecutivas.
  * **Adaptive Proportion Test (APT):** Evalúa si el conteo de coincidencias en una ventana de \(W\) muestras excede el umbral de corte \(C\).
* **Acción de Respuesta:** Suspensión inmediata del KDF (HKDF-SHAKE256) si alguna prueba falla, impidiendo la generación de pares de claves compromised.
* **Estado (2026-07-31):** Implementado en `nexus-crypto/src/entropy.rs` (`HealthMonitor`) con tests; pendiente la parametrización final de \(W\) y \(C\) (Decisión 001).

#### Actividad 3.2: Rotación con Secrecia Hacia Adelante (*Forward Secrecy*)
* **Mecanismo:** Generación periódica de efímeros de firma y derivación de épocas (*epochs*).
* **Registro Auditable:** Registro inmutable en L1/L2 de eventos de rotación para evitar reutilización o repudio de claves antiguas.
* **Estado (2026-07-31):** Rotación con *forward secrecy* implementada y testeada en `entropy.rs`; el registro auditable en el Key Registry sigue pendiente (Decisión 002).

---

### 2. Módulo de Formalización y Validación de Seguridad y Complejidad (Objetivo 4)

#### Actividad 4.1: Cadena de Reducciones Teóricas
* **Esquema de Reducción:**
  \[
  \text{EUF-CMA (Dilithium)} \xrightarrow{\text{Reducción}} \text{Module-LWE / SelfTargetMSIS / Module-SIS} \xrightarrow{\text{Reducción}} \text{Mod-SIVP (Peor Caso)}
  \]
* **Demostración frente a Computación Cuántica:** Demostrar formalmente que los reticulados algebraicos no poseen subgrupos ocultos abelianos explotables por la QFT (*Quantum Fourier Transform*) en el algoritmo de Shor.

#### Actividad 4.2: Análisis de Complejidad Computacional y Benchmarks
* **Análisis asintótico:** Complejidad en notación \(\mathcal{O}\) para la verificación de firmas CRYSTALS-Dilithium en entornos constrained (L2) frente a verificadores de prueba STARK.
* **Benchmarks Empíricos:** Mediciones de latencia (ms), throughput (tps), consumo de memoria y tamaño de payload (bytes).

---

## 📌 Pendientes y Decisiones de Diseño

- [ ] **Decisión 001:** Determinar los parámetros exactos de ventana (\(W\)) y corte (\(C\)) para la prueba APT según las especificaciones del TRNG/PRNG seleccionado.
- [ ] **Decisión 002:** Definir la estructura de almacenamiento eficiente de los eventos de rotación en el *Key Registry* para mantener latencia baja en la L2.
- [ ] **Decisión 003:** Establecer la suite de pruebas de rendimiento empírico (Rust criterion / harness de benchmarks).

---

*Esta bitácora se actualizará continuamente a lo largo del semestre a medida que se ejecuten actividades y refactorizaciones en TG2.*
