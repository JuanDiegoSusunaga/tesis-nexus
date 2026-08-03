# Alcance y Objetivos — Versión estrecha (v2)

### Trabajo de grado · Juan Diego Susunaga Velasquez · Universidad del Rosario

> **Propósito de este documento.** Reescribe el *alcance* y los *objetivos* de la propuesta para concentrar la tesis en su contribución real y profunda — un **modelo formal y prototipo de referencia de firmas post-cuánticas (Dilithium) en una arquitectura dual-chain para banca**, con validación formal de seguridad y complejidad. Respecto de la propuesta original se hacen **dos cambios de fondo**: (a) se **elimina** la biometría / extractor difuso; (b) se **reformula la lógica de entropía** sobre bases criptográficas correctas (min-entropía de la fuente + pruebas de salud NIST SP 800-90B + rotación con secrecia hacia adelante), en lugar de usar la entropía de Shannon de la semilla como métrica de seguridad.

---

## 1. Reposicionamiento (resumen de los cambios)

| Propuesta original | Versión estrecha (v2) | Motivo |
|---|---|---|
| Integraba PQC + ZK + extractor difuso/biometría + BFT + DA + dual-chain + teoría de juegos + validación formal | **Núcleo profundo**: firmas PQC (Dilithium) + gestión activa de claves + validación formal, sobre una arquitectura dual-chain de referencia | El alcance original es demasiado amplio: cada pieza es una tesis. La dispersión es la causa de que la implementación quedara como andamiaje. |
| Obj 2 incluía *extractor difuso* para claves desde biométricos | **Biometría eliminada.** La derivación determinística de claves se hace desde una **semilla de alta entropía vía KDF**, no desde un biométrico | Un biométrico no es revocable; basar una clave de firma en él es un diseño cuestionable. Y el ECC del extractor no estaba implementado. |
| Obj 3 = "Entropía de Shannon H(S) del Sentinel-Seed + rotación" | Obj 3 = **min-entropía de la *fuente* + pruebas de salud en línea (NIST SP 800-90B: RCT/APT) + rotación forward-secure por política** | La entropía de Shannon de una muestra de 32 bytes no mide el secreto de una clave; lo correcto es la min-entropía de la fuente y el monitoreo de salud del generador. |
| ZK (Nitro Verifier), consenso BFT operativo, DA con erasure coding como *features* | Se conservan como **diseño de referencia (modelo) y trabajo futuro**, no como implementación entregable | Coherencia entre lo prometido y lo entregado; profundidad sobre amplitud. |

---

## 2. Título (sin cambios necesarios; refinamiento opcional)

El título actual ya enfatiza el carácter de **modelo matemático-computacional**, lo cual encaja con la versión estrecha:

> *"Arquitectura Blockchain Dual NEXUS: Un Modelo Matemático-Computacional para Sistemas Bancarios Seguros y Resilientes Post-Cuántico"*

**Refinamiento opcional** (si se desea foregroundear el núcleo de firmas PQC):

> *"NEXUS: Modelo Formal y Prototipo de Referencia de Firmas Post-Cuánticas (CRYSTALS-Dilithium) para una Arquitectura Blockchain Dual de Banca Resiliente"*

---

## 3. Alcance

### 3.1 Dentro del alcance

1. **Diseño y especificación** de la arquitectura dual-chain (Anchor Layer L1 / Active Layer L2) como **modelo de referencia**, delimitando dónde se integran las firmas post-cuánticas en el flujo transacción → mempool → ejecución/verificación → asentamiento.
2. **Implementación verificada** del esquema de firma **CRYSTALS-Dilithium** (niveles 2/3/5: generación de claves, firma, verificación) y su enlace criptográfico a las transacciones, usando una biblioteca PQC auditada.
3. **Derivación determinística de claves** a partir de una **semilla de alta entropía** mediante una función de derivación de claves (KDF) con separación de dominio.
4. **Gestión activa del ciclo de vida de claves**: monitoreo de salud de la fuente de entropía (NIST SP 800-90B), estimación de min-entropía, y **rotación con secrecia hacia adelante** disparada por política (uso, antigüedad o fallo de salud), con registro auditable.
5. **Validación formal**: reducción de la seguridad de Dilithium a Module-LWE, SelfTargetMSIS y Module-SIS (y de éstos a Mod-SIVP de peor caso) con el argumento de resistencia cuántica; y **análisis de complejidad** (notación O) de la verificación de firmas y del *overhead* dual, complementado con **benchmarks** empíricos.

### 3.2 Fuera del alcance (declarado explícitamente)

- **Biometría y extractores difusos** — eliminados del trabajo.
- **Implementación operativa** de: la capa de pruebas de conocimiento cero (ZK/Groth16 — Nitro Verifier), el protocolo de consenso BFT en red (verificación de votos, *slashing*, difusión), y la disponibilidad de datos con *erasure coding*/DAS. Estos se entregan como **diseño/modelo de referencia y trabajo futuro**, claramente etiquetados.
- **Resistencia a canales laterales** y seguridad de implementación (se asume el modelo de caja negra / QROM).
- **Despliegue en producción**, *tooling* de red P2P (libp2p), y servidor RPC operativo.

### 3.3 Supuestos

- Se dispone de una **fuente de entropía** del sistema operativo / hardware conforme a las recomendaciones NIST; el monitoreo verifica su salud, no la sustituye.
- La seguridad se evalúa en el **modelo del oráculo aleatorio cuántico (QROM)**, consistente con la prueba de seguridad de Dilithium.
- Los parámetros de Dilithium son los estandarizados de **FIPS 204 / ML-DSA** (el código usa la biblioteca `fips204`).

---

## 4. Objetivos

### 4.1 Objetivo general

Diseñar, modelar y **validar formalmente** un **modelo matemático-computacional de firmas digitales post-cuánticas (CRYSTALS-Dilithium)** para una **arquitectura blockchain dual** orientada a sistemas bancarios resilientes, incorporando la **gestión activa del ciclo de vida de claves** y la **prueba formal** de su seguridad (reducción a Module-LWE) y de su complejidad computacional.

### 4.2 Objetivos específicos

**Objetivo 1 — Diseñar la arquitectura dual-chain como modelo de referencia.**
Especificar los roles y las interfaces de la **Anchor Layer (L1)** y la **Active Layer (L2)**, delimitando con precisión **el camino de la firma post-cuántica** a través del sistema (creación de la transacción → secuenciación → ejecución/verificación → asentamiento en L1), y especificando los componentes clave (**Nexus Sequencer**, **Nitro Verifier**) a nivel de modelo.
- *Actividad 1.1*: Revisión del estado del arte (blockchains post-cuánticos, *rollups* L1/L2) y justificación de la arquitectura dual.
- *Actividad 1.2*: Especificación del modelo de capas y del **flujo de verificación de firmas PQC** en consenso y asentamiento.
- *Actividad 1.3 (opcional)*: Análisis de incentivos del secuenciador (matriz de pagos / equilibrio de Nash) como elemento de diseño — sin requerir la implementación del *slashing*.

**Objetivo 2 — Desarrollar e implementar el núcleo criptográfico post-cuántico.**
Formalizar e **implementar de forma verificada** el esquema de firma **CRYSTALS-Dilithium** (niveles 2/3/5: `KeyGen`, `Sign`, `Verify`), su enlace a la transacción firmada, y la **derivación determinística de claves a partir de una semilla** de alta entropía mediante un **KDF con separación de dominio** (SHAKE256 / HKDF). *(Nota: FIPS 204/ML-DSA define una `KeyGen` determinística a partir de una semilla de 32 bytes, de modo que la generación determinística es estándar y bien fundamentada — basta exponer/implementar la expansión de semilla, sin biometría.)*
- *Actividad 2.1*: Definición formal de retículos, Module-LWE y del esquema de firma (abstracción de Dilithium).
- *Actividad 2.2*: Implementación verificada de firma/verificación (con *binding* a la transacción) y de la derivación determinística semilla → clave.

**Objetivo 3 — Modelar e implementar la lógica de seguridad activa del ciclo de vida de claves.**
Reemplaza el monitoreo de "entropía de Shannon de la semilla" por un modelo riguroso:
1. **Fuente de entropía monitoreada**: estimación de **min-entropía** $H_\infty(X) = -\log_2 \max_x \Pr[X=x]$ y **pruebas de salud en línea** conforme a **NIST SP 800-90B** (*Repetition Count Test* y *Adaptive Proportion Test*) que detectan degradación o atascamiento del generador.
2. **Derivación de claves** mediante KDF con separación de dominio (vincula al Obj 2).
3. **Rotación con secrecia hacia adelante** (nueva semilla mezclada con la anterior vía hash), disparada por **política**: conteo de uso, antigüedad, o **fallo de las pruebas de salud**; con **registro de auditoría**. Ante fallo de salud, se **bloquea** la derivación de claves.
- *Actividad 3.1*: Definir el modelo de fuente de entropía y la métrica de min-entropía; implementar RCT/APT y la estimación.
- *Actividad 3.2*: Implementar la rotación *forward-secure* por política y el registro auditable; pruebas que demuestren el **bloqueo ante degradación** de la fuente.

**Objetivo 4 — Formalizar y validar la seguridad y la complejidad.**
1. **Prueba de dureza post-cuántica**: reducción de la in-forjabilidad (EUF/sUF-CMA) de Dilithium a **Module-LWE**, **SelfTargetMSIS** y **Module-SIS**, y de éstos —vía reducciones de peor caso— a **Mod-SIVP**; con el argumento de **no aplicabilidad del algoritmo de Shor**.
2. **Análisis de complejidad computacional** (notación O) de la verificación de firmas (dominada por la NTT, $O(n\log n)$ por multiplicación; $O(k\ell\,n\log n)$ por operación) y del *overhead* del esquema dual.
3. **Validación empírica complementaria**: *benchmarks* que acotan las constantes ocultas del análisis asintótico (no lo sustituyen).
- *Actividad 4.1*: Desarrollo de la cadena de reducciones (ver *Capítulo 6 — Validación Formal*).
- *Actividad 4.2*: Análisis de complejidad y *overhead* dual; ejecución y reporte de *benchmarks*.

---

## 5. Mapa objetivo → entregable → estado

| Objetivo | Entregable | Tipo | Estado de partida |
|---|---|---|---|
| Obj 1 | Especificación de la arquitectura dual-chain y del camino de firma PQC | Diseño / modelo (documento + tipos) | Parcial (existe la estructura de crates) |
| Obj 2 | Dilithium implementado + derivación determinística por KDF | Implementación verificada | Dilithium real; falta KDF determinístico |
| Obj 3 | Salud de fuente (SP 800-90B) + min-entropía + rotación forward-secure | Modelo + implementación | Existe rotación; reformular métrica y añadir RCT/APT |
| Obj 4 | Reducción Module-LWE + complejidad O() + benchmarks | Documento formal + evidencia empírica | Capítulo en redacción (esqueleto listo) |

---

## 6. Qué cambia respecto del código actual (acciones derivadas)

- **Eliminar** del repositorio y del documento: `nexus-crypto/fuzzy_extractor.rs` (y referencias a biometría en README/arquitectura). *(Conservar el archivo en una rama si se desea como anexo de "trabajo futuro".)*
- **Reformular** `nexus-crypto/entropy.rs`: sustituir el disparador "Shannon < 7,5 bits/byte sobre la semilla" por (i) estimación de min-entropía y (ii) pruebas de salud RCT/APT sobre el flujo de la fuente; mantener la rotación *forward-secure* por uso/edad/fallo de salud.
- **Implementar** en `nexus-crypto`: derivación determinística semilla → clave Dilithium vía SHAKE256 (recupera el "determinismo" del Obj 2 sin biometría).
- **Reetiquetar** ZK / consenso BFT / DA como *diseño de referencia + trabajo futuro* (ya hecho en el README v2).

---

### Referencias añadidas (para Obj 3)

- NIST SP 800-90B (2018). *Recommendation for the Entropy Sources Used for Random Bit Generation.* (min-entropía; pruebas de salud RCT/APT).
- NIST SP 800-90A/C. *DRBGs / RBG constructions.*
- Krawczyk, H. (2010). *HKDF: HMAC-based Extract-and-Expand Key Derivation Function* (RFC 5869).
- NIST SP 800-108. *Recommendation for Key Derivation Using Pseudorandom Functions.*
