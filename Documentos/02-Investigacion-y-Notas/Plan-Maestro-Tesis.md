# Plan Maestro — Tesis NEXUS

### Torre de control del trabajo de grado · Juan Diego Susunaga Velasquez · Universidad del Rosario

**Alcance actualizado el 2026-09-22:** sistemas en general, conforme a la aclaración expresa del autor. La planificación histórica se contrasta con la [ruta de cierre TG2](../04-Administrativo-TG2/Ruta-de-Cierre-TG2.md) y la [bitácora](../../BITACORA_TG2.md), que recogen los pendientes técnicos vigentes.

> **Cómo usar este documento.** Es el índice vivo de toda la tesis: la idea en una frase, el arco narrativo, la estructura capítulo por capítulo, qué documento alimenta cada capítulo, el mapa de dependencias, la hoja de ruta a la entrega, las **invariantes de consistencia** (cifras/términos que deben ser idénticos en todos los documentos) y los riesgos de defensa con su mitigación. Actualízalo cada vez que avances; si algo no aparece aquí, no está planeado.

---

## 1. La tesis en una frase

> **NEXUS formaliza y prototipa cómo asegurar firmas digitales de sistemas en general contra la amenaza cuántica con CRYSTALS-Dilithium, demostrando formalmente su seguridad (reducción a Module-LWE) y resolviendo el sobrecosto de datos que la PQC introduce mediante una arquitectura dual-chain con verificación post-cuántica.**

### El arco narrativo único (cada capítulo es un eslabón)

```
  AMENAZA            SOLUCIÓN          COSTO            RESPUESTA          COHERENCIA        VALIDACIÓN
 (cuántica a   →   (firmas PQC,  →  (~50× tamaño →  (dual-chain      → (el verificador →  (prueba formal +
  las firmas)       Dilithium)      ~20× TPS)       amortiza a ~d)     L2 debe ser PQ      complejidad +
                                                                       → STARK)            benchmarks)
   Cap. 1            Cap. 4          Cap. 3 §X        Cap. 3            Cap. 3/6           Cap. 6
```

**Regla de oro de redacción:** todo capítulo debe poder responder *"¿qué eslabón del arco soy?"*. Si no encaja en el arco, sobra (o es trabajo futuro).

---

## 2. Estructura de la tesis (capítulo por capítulo)

| Cap. | Título | Eslabón del arco | Se nutre de | Objetivo | Estado |
|---|---|---|---|---|---|
| **1** | Introducción y planteamiento del problema | Amenaza + motivación | `Cap1-Introduccion.md` (desarrollado) | — | **desarrollado** |
| **2** | Marco teórico y estado del arte | Fundamentos | `Cap2-Marco-Teorico.md` (desarrollado) | — | **desarrollado** |
| **3** | Diseño de la arquitectura Dual-Chain | Costo + Respuesta + Coherencia | `Cap3-Diseno-Arquitectura.md` (desarrollado), `Analisis-Overhead`, `Ideas-ETH-SOL` | **Obj 1** | **desarrollado** |
| **4** | Núcleo criptográfico post-cuántico | Solución | `Cap4-Nucleo-Criptografico.md` (desarrollado) | **Obj 2** | **desarrollado** (Dilithium implementado; KDF pendiente) |
| **5** | Gestión activa del ciclo de vida de claves | (capa operativa) | `Cap5-Gestion-Claves.md` (desarrollado) | **Obj 3** | **prototipo R2–R3 probado** (monitor, rotación efectiva y registro local; fuente concreta y despliegue pendientes) |
| **6** | Validación formal de seguridad y complejidad | Validación | `Cap6-Validacion-Formal.md` (desarrollado) | **Obj 4** | **desarrollado** (falta solo insertar benchmarks) |
| **7** | Conclusiones y trabajo futuro | Cierre | `Cap7-Conclusiones.md` (desarrollado) | — | **desarrollado** |

> **Nota de numeración:** el antiguo `Cap4-Validacion-Formal-Esqueleto.md` (numerado "Cap. 4" por el *Objetivo* 4) correspondía al **Capítulo 6**; fue superseded por `Cap6-Validacion-Formal.md` y está archivado en `Documentos/_archivo/superseded/` (2026-08-03).

### Contenido detallado por capítulo

**Cap. 1 — Introducción.**
- Problema y **modelo de amenaza preciso**: el adversario cuántico recupera la clave privada desde la pública (Shor) y **falsifica firmas** → robo/forja. (HNDL como telón de fondo; aclarar que la confidencialidad plena exigiría un KEM, fuera de alcance.)
- Motivación cuantificada (resumen del Cap. 3): PQC necesaria pero cara → dual-chain.
- Mitigación complementaria: **revelar-al-gastar** (dirección = hash(pk)).
- Estado del arte breve: Ethereum Lean Consensus y Solana/Falcon validan la dirección.
- Objetivos (general + 4) y alcance.

**Cap. 2 — Marco teórico.**
- Retículos, Module-LWE/MSIS, anillo $R_q$ (§4.2 del esqueleto formal).
- Dilithium / ML-DSA; rollups L1/L2; entropía (min-entropía, SP 800-90B); STARKs.
- **Comparativa de esquemas PQ** (ETH leanXMSS · SOL Falcon · NEXUS Dilithium).

**Cap. 3 — Diseño Dual-Chain (Obj 1) — el capítulo "espina".**
- **Análisis cuantificado overhead PQC → dual-chain** (de `Analisis-Overhead`, completo): el costo de datos, la amortización $F(M)\to d$, el equilibrio de lotes.
- **Coherencia post-cuántica del verificador**: por qué Groth16 no sirve → STARK (con el paralelo a leanVM de Ethereum, ~250×).
- **Modelo de cuenta con abstracción de verificación + Key Registry** (cierra identidad-vs-clave; validado por EIP-7702/8141).
- **Disponibilidad de datos** estilo PeerDAS (erasure coding real + muestreo entre pares + poda).
- **Secuenciador**: separación proponente/constructor (PBS) y/o concurrencia (MCL); modelo de incentivos (Nash) multi-jugador.
- **Finalidad** rápida determinista (contraste con Alpenglow/Votor).

**Cap. 4 — Núcleo criptográfico (Obj 2).**
- Dilithium 2/3/5: implementación verificada, firma ligada a la transacción, higiene de claves.
- **Derivación determinística semilla → clave por KDF** (SHAKE256; nota: ML-DSA define KeyGen determinística desde semilla).
- Justificación de la elección de Dilithium frente a Falcon / hash-based (tabla comparativa).

**Cap. 5 — Seguridad activa (Obj 3).**
- Fuente de entropía: **min-entropía** + pruebas de salud en línea **NIST SP 800-90B (RCT/APT)**.
- Derivación por KDF; **rotación con secrecia hacia adelante** por política (uso/edad/fallo de salud) + auditoría; bloqueo ante degradación.
- Tubería unificada: fuente → KDF → semilla → keypair → rotación.

**Cap. 6 — Validación formal (Obj 4).**
- Preliminares, modelo de seguridad (sUF-CMA, QROM).
- **Reducción**: in-forjabilidad → MLWE + SelfTargetMSIS + MSIS → Mod-SIVP; no aplicabilidad de Shor.
- **Complejidad** O() (NTT, $O(k\ell\,n\log n)$) + overhead dual.
- **Benchmarks** empíricos (tras corregir el build).

**Cap. 7 — Conclusiones.** Síntesis del arco; limitaciones declaradas; trabajo futuro (ZK real/STARK, consenso BFT operativo, KEM para confidencialidad, Falcon).

---

## 3. Mapa de interconexiones (grafo de dependencias)

```
            ┌────────────────────────────────────────────────┐
            │  Cap.1 Amenaza + Modelo + Motivación            │
            └───────┬─────────────────────────┬──────────────┘
                    │                         │
        ┌───────────▼───────────┐   ┌─────────▼──────────┐
        │ Cap.2 Marco teórico   │   │ Cap.3 DISEÑO (Obj1)│◄── espina (overhead→dual-chain)
        │ (retículos, rollups,  │   │ arquitectura, DA,  │
        │  entropía, STARK)     │   │ cuentas, finalidad │
        └───────────┬───────────┘   └───┬───────────┬────┘
                    │                   │           │
        ┌───────────▼─────────┐ ┌───────▼────┐ ┌────▼─────────────┐
        │ Cap.4 Cripto (Obj2) │ │ Cap.5      │ │ (verificador PQ   │
        │ Dilithium + KDF     │─│ Claves     │ │  = STARK, no      │
        │                     │ │ (Obj3)     │ │  Groth16)         │
        └───────────┬─────────┘ └─────┬──────┘ └──────────────────┘
                    │                 │
                    └────────┬────────┘
                             │
                  ┌──────────▼───────────┐
                  │ Cap.6 VALIDACIÓN     │  (valida Obj2; cuantifica Cap3)
                  │ FORMAL (Obj4)        │
                  └──────────┬───────────┘
                             │
                  ┌──────────▼───────────┐
                  │ Cap.7 Conclusiones   │
                  └──────────────────────┘
```

**Dependencias críticas:** Cap. 6 necesita Cap. 4 (qué primitivo valida). Cap. 3 necesita el análisis de overhead (justifica el dual-chain). Cap. 5 se apoya en Cap. 4 (la semilla alimenta la KeyGen). El "verificador = STARK" conecta Cap. 3 con Cap. 6 (seguridad del sistema = seguridad del primitivo + soundness del proof system PQ).

---

## 4. Inventario de documentos producidos → destino

| Documento (en `Desktop/Tesis/`) | Alimenta | Estado |
|---|---|---|
| `nexus/README.md` (v2) | Cap. 1-5 (visión); repositorio | realineado |
| `Documentos/Propuesta-...-v2.md` + `.docx` | entrega al director | listo |
| `Documentos/Alcance-y-Objetivos-v2.md` | Cap. 1 (alcance/obj) | listo |
| `Documentos/Cap1-Introduccion.md` | **Cap. 1** (intro, amenaza, objetivos) | **desarrollado** |
| `Documentos/Cap2-Marco-Teorico.md` | **Cap. 2** (marco teórico, estado del arte) | **desarrollado** |
| `Documentos/Cap3-Diseno-Arquitectura.md` | **Cap. 3** (espina, Obj 1) | **desarrollado** |
| `Documentos/Cap4-Nucleo-Criptografico.md` | **Cap. 4** (Obj 2) | **desarrollado** |
| `Documentos/Cap5-Gestion-Claves.md` | **Cap. 5** (Obj 3) | **desarrollado** |
| `Documentos/Analisis-Overhead-PQC-DualChain.md` | **Cap. 3** (companion cuantitativo) | listo |
| `Documentos/Cap6-Validacion-Formal.md` | **Cap. 6** (Obj 4) | **desarrollado** |
| `Documentos/Cap7-Conclusiones.md` | **Cap. 7** (cierre) | **desarrollado** |
| `Documentos/_archivo/superseded/Cap4-Validacion-Formal-Esqueleto.md` | — (superseded por Cap. 6) | archivado (2026-08-03) |
| `Documentos/02-Investigacion-y-Notas/Estado-del-Arte-General.md` | Cap. 2 (estado del arte general PQC/entropía/ETH) | vigente (antes `05-Estado-del-Arte/estado_del_arte.md`) |
| `Documentos/Ideas-Ethereum-Solana-para-NEXUS.md` | Cap. 1-3 (estado del arte, diseño) | con fuentes |
| `Documentos/Plan-Maestro-Tesis.md` | torre de control | este documento |
| `Documentos/02-Investigacion-y-Notas/Estado-del-Arte-Claves-Efimeras-y-Deception.md` | Cap. 2/5/7 (sustento de §5.6 y Deception Engine) | con fuentes (jul. 2026) |
| `Documentos/02-Investigacion-y-Notas/Estado-del-Arte-Pagos-Agenticos.md` | Cap. 1/7 + estado del arte TG2 (caso agéntico) | con fuentes (ago. 2026) |
| `BITACORA_TG2.md` (raíz del proyecto) | seguimiento continuo TG2 | activa |
| `Documentos/04-Administrativo-TG2/Plan-de-Trabajo-TG2.md` | plan formal TG2 (condición del comité) | borrador — por acordar con el director |
| `Documentos/04-Administrativo-TG2/Estado-del-Proyecto-para-Director.md` | brief reunión inicial con P. Wightman | listo |

---

## 5. Hoja de ruta a la entrega

### Fase A — Cimientos (desbloquea todo lo demás) HECHA (2026-06-04)
- [x] **Nivel 0 de código**: build arreglado (`async-trait` en `nexus-core`; `DEPTH` u8→usize **y** recursión 2²⁵⁶ del SMT corregida con poda; `Shake256::update` y numérico ambiguo en `fuzzy_extractor`). El workspace **compila**. *(Nota: compilar con `CARGO_TARGET_DIR=/c/tmp/nexus-target` por bloqueos de `target/`.)*
- [x] **Benchmarks reales** de Dilithium ejecutados (Criterion) e insertados en Cap. 6 §6.6 (Tabla 6.2) y README.
- [x] Entregar **Propuesta v2** al director (`.docx` listo).

### Fase B — Alinear código con el alcance v2 HECHA (2026-06-04)
- [x] Biometría removida: módulo `fuzzy_extractor` desconectado del build; métodos `from_biometric`/`recover_from_biometric` y tests eliminados de `keypair.rs`/`lib.rs`.
- [x] `entropy.rs` reformulado: **min-entropía** + **pruebas de salud NIST SP 800-90B (RCT/APT)** + bloqueo ante degradación + rotación forward-secure (con tests).
- [x] KDF fuente→semilla (SHA3, dominio separado) en `SentinelSeed`. *(Resta: `KeyGen` reproducible de Dilithium desde semilla — requiere backend FIPS 204; documentado honestamente.)*
- [x] ZK/consenso/DA reetiquetados como diseño + trabajo futuro.

> **HITO (2026-06-04): el workspace COMPLETO compila y los 70 tests pasan.** Más allá de Fase A/B, se arreglaron también `nexus-zk` (`ProofType: Hash`), re-exports (`InMemoryState`, `verify_signed_transaction`, `AnchorChainConfig`, `ActiveChainConfig`), `batch.rs` (PQSignature), `data_availability` (`.concat`), `compute_root` (estado vacío → `EMPTY`) y `nexus-cli` (`rand`). El hallazgo crítico original ("no compila") queda **resuelto**.

### Fase C — Redacción (Obj 1 y 2) HECHA (2026-06-04)
- [x] Cap. 1 (introducción + modelo de amenaza preciso + motivación).
- [x] Cap. 2 (marco teórico + comparativa esquemas PQ).
- [x] Cap. 3 (diseño dual-chain integrando overhead + ideas ETH/SOL).
- [x] Cap. 4 (núcleo criptográfico).

### Fase D — Redacción (Obj 3 y 4) HECHA (2026-06-04/05)
- [x] Cap. 5 (gestión activa de claves; §5.6 residencia efímera añadida 2026-07-31).
- [x] Cap. 6 (validación formal: prueba game-based completa + benchmarks; verificada adversarialmente 2026-06-05).
- [x] Cap. 7 (conclusiones; contribuciones 7-8 y trabajo futuro 9 añadidos 2026-07-31).

### Fase E — Pulido (parcial)
- [x] Auditoría de **invariantes de consistencia** (§6) en todos los capítulos — HECHA (2026-06-05, 24 correcciones).
- [ ] Revisión final de referencias y figuras → absorbida por Fase F4.
- [ ] Ensayo de defensa contra los **riesgos** (§8) → absorbida por Fase F4.

### Fase F — TG2 (semestre 2026-2) — plan formal
> Plan detallado, entregables y cronograma: **`Documentos/04-Administrativo-TG2/Plan-de-Trabajo-TG2.md`** (borrador v0.1, por acordar con el director **P. Wightman**; condición del Comité 2026-08-03). Seguimiento continuo en `BITACORA_TG2.md`; entregas parciales con plantilla en `04-Administrativo-TG2/Formatos/`.
- [ ] **F0** (sem. 1): reunión inicial con el director; acordar plan, fechas y cadencia. → E0
- [ ] **F1** (sem. 2–4): cierre Obj 3 — Decisiones 001/002 + Cap. 5 cerrado. → E1
- [ ] **F2** (sem. 4–7): cierre Obj 4 — comparativa ECDSA/RSA + análisis O() en Cap. 6. → E2
- [ ] **F3** (sem. 7–10): contribuciones C1–C4 — KeyGen-por-firma + métrica W formalizadas, diseño del Deception Engine, caso agéntico en Cap. 1/7. → E3
- [ ] **F4** (sem. 10–12): consolidación — QA invariantes, docx/PDF institucional, sustentación. → E4

---

## 6. Invariantes de consistencia (para que "todo sea perfecto")

**Estas cifras/términos deben ser IDÉNTICOS en todos los documentos y capítulos.** Antes de entregar, verifica cada uno:

| # | Invariante | Valor correcto |
|---|---|---|
| 1 | Problema reticular de peor caso | **Mod-SIVP** (Mod-GIVP) — **nunca** "Module-SVP" |
| 2 | Cota de seguridad de Dilithium | **sUF-CMA con 3 términos**: MLWE + SelfTargetMSIS + MSIS (+ $2^{-254}$) |
| 3 | Dirección del paso de falsificación | la falsificación **es directamente** una solución SelfTargetMSIS (sin forking); forking solo en SelfTargetMSIS→MSIS |
| 4 | Reducción cuántica vs. clásica | MLWE = reducción **cuántica** (Regev); MSIS = **clásica** |
| 5 | Tamaños de firma (FIPS 204 / ML-DSA) | sig D3 = **3309**, D5 = **4627**; pk 1312/1952/2592 (el código usa el crate `fips204`) |
| 6 | Seguridad cuántica | **~0,91× la clásica** (core-SVP, sieving); "mitad de bits" = cota **conservadora tipo Grover** |
| 7 | Overhead PQC | ~**50×** tamaño de firma · ~**20×** throughput · amortiza a **~$d$** (diferencia de estado) |
| 8 | Sistema de pruebas del L2 | **post-cuántico (STARK/hash-based)**, **no** Groth16/emparejamientos |
| 9 | Entropía | **min-entropía de la fuente** + **SP 800-90B (RCT/APT)**; **no** "Shannon de la semilla como métrica de seguridad" |
| 10 | Biometría | **eliminada** del alcance |
| 11 | Modelo de cuenta | `(id_estable, política_de_verificación, epoch)` — rotación no cambia la dirección |
| 12 | Fiat-Shamir with Aborts | técnica: **Lyubashevsky 2009**; esquema: 2012 |
| 13 | Esquema de firma elegido | **Dilithium/ML-DSA** (equilibrio); Falcon y hash-based como alternativas comparadas |

---

## 7. Definición de "hecho" por capítulo (barra de calidad)

Un capítulo está **listo para defensa** cuando:
- Responde explícitamente *"qué eslabón del arco soy"*.
- Toda afirmación de seguridad/numérica respeta las **invariantes** (§6).
- Distingue lo **implementado/verificado** de lo **modelado** de lo **trabajo futuro** (sin sobre-afirmar).
- Cada afirmación no trivial tiene **cita** (fuente primaria) o **evidencia** (prueba/benchmark).
- Las cifras "medidas" provienen de un benchmark real (no del README viejo).

---

## 8. Riesgos de defensa → cómo quedan cubiertos

| Riesgo del jurado | Mitigación | Dónde |
|---|---|---|
| "Muéstralo corriendo" | Fase A (build) + benchmarks reales | Cap. 6 / Fase A |
| "¿De dónde salen los benchmarks?" | Regenerados tras el build; números viejos eliminados | Cap. 6 / README v2 |
| "Dilithium es firma; ¿cómo para HNDL?" | Modelo de amenaza preciso: forja/recuperación de clave; KEM fuera de alcance declarado | Cap. 1 |
| "El Obj 4 es prueba formal, ¿dónde está?" | Cap. 6 desarrolla la reducción + complejidad (esqueleto listo) | Cap. 6 |
| "Tu cota sUF-CMA está mal / Module-SVP" | Corregido y fijado en invariantes (§6) | Cap. 6 / §6 |
| "Groth16 no es post-cuántico" | Anticipado: verificador = STARK; paralelo a leanVM de Ethereum | Cap. 3 |
| "Rotar la clave cambia la dirección" | Modelo de cuenta con abstracción de verificación + Key Registry | Cap. 3 |
| "¿Novedad? ya existen PQ-blockchains" | Frase de novedad: síntesis formal cuantificada overhead→dual-chain PQ para sistemas en general | Cap. 1/3 |
| "Tu DAS no detecta nada" | Rediseño estilo PeerDAS (muestreo entre pares) | Cap. 3 |

---

## 9. Próximos pasos inmediatos (actualizado 2026-08-03)

1. **Reunión inicial con el director P. Wightman** — presentar `Estado-del-Proyecto-para-Director.md` y acordar `Plan-de-Trabajo-TG2.md` (fechas + cadencia de entregas). **Bloqueante de todo lo demás** (condición del comité).
2. Cerrar **Decisión 001** (parámetros W/C de APT) y **Decisión 002** (registro auditable de rotación en Key Registry) — inicio de F1.
3. Comparativa **Dilithium vs. ECDSA/RSA** en la misma suite Criterion + análisis O() en Cap. 6 — F2.
4. Integración del **caso agéntico** al manuscrito (Cap. 1/7) con las 18 referencias ya consolidadas en `_tesis-bibliografia.md` — F3.
