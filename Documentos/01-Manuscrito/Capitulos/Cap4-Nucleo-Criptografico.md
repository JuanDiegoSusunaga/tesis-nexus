# Capítulo 4 — Núcleo Criptográfico Post-Cuántico

*Objetivo 2 · la "solución" del arco*

> **Rol en el arco de la tesis.** Este capítulo desarrolla el **primitivo de firma** que constituye la *solución* a la amenaza cuántica: el esquema CRYSTALS-Dilithium, su integración correcta en las transacciones y la derivación determinística de claves. Es la parte **genuinamente implementada y verificada** del prototipo; su seguridad se prueba formalmente en el **Capítulo 6** y su costo se amortiza en el **Capítulo 3**.

---

## 4.1 Introducción

El componente cuya seguridad es necesaria y suficiente para autenticar transacciones frente a un adversario cuántico es el **esquema de firma digital**. NEXUS adopta **CRYSTALS-Dilithium** (NIST FIPS 204 / ML-DSA), un esquema basado en retículos cuya in-forjabilidad se reduce a Module-LWE (Cap. 6). Este capítulo cubre tres aspectos del Objetivo 2:

1. La **implementación verificada** de Dilithium (firma y verificación reales sobre una biblioteca auditada), §4.2.
2. El **enlace criptográfico** de la firma a la transacción y la verificación en la transición de estado —el "uso correcto" que permite pasar de la seguridad del primitivo a la seguridad de la transacción (Cap. 6, §6.7)—, §4.3–4.4.
3. La **derivación determinística de claves** desde una semilla de alta entropía mediante un KDF, que conecta con la gestión activa de claves (Cap. 5), §4.5; y la **justificación de la elección de Dilithium** frente a esquemas alternativos, §4.6.

---

## 4.2 CRYSTALS-Dilithium en NEXUS

### 4.2.1 Selección multinivel

NEXUS soporta los tres niveles estandarizados, seleccionables según el compromiso seguridad/tamaño (Cap. 6, §6.2.3):

**Tabla 4.1 — CRYSTALS-Dilithium en NEXUS.**

| Nivel | Seguridad NIST | Clave pública | Firma | Uso recomendado |
|---|:---:|---:|---:|---|
| Dilithium2 | 2 | 1312 B | 2420 B | operaciones de alto volumen |
| **Dilithium3** | **3** | **1952 B** | **3309 B** | **por defecto en el prototipo** |
| Dilithium5 | 5 | 2592 B | 4627 B | activos de máxima criticidad |

Las claves y firmas tienen tamaños fijos por nivel, validados contra los tamaños reportados por la biblioteca antes de cualquier operación criptográfica.

### 4.2.2 Implementación verificada

La implementación (`nexus-crypto/src/dilithium.rs`) **delega en la biblioteca auditada `fips204`** (implementación pura en Rust, *constant-time*, de ML-DSA / FIPS 204), no en código criptográfico propio. Es una decisión de diseño deliberada: la criptografía post-cuántica de bajo nivel es delicada (canales laterales, *rejection sampling*) y debe descansar sobre implementaciones revisadas. Se eligió `fips204` por exponer una **`KeyGen` determinística basada en semilla** (§4.5), necesaria para el Objetivo 2.

- **Generación de claves:** `ml_dsa_N::KG::try_keygen()` (aleatoria) o `keygen_from_seed(ξ)` (determinística, §4.5) producen $(pk, sk)$ reales.
- **Firma:** `sk.try_sign(mensaje, ctx)` produce una firma genuina; **no** hay bytes de firma fijos o simulados.
- **Verificación:** `pk.verify(mensaje, firma, ctx)` **propaga el resultado real** (booleano); un mensaje o firma incorrectos producen `false`. **No** existe un verificador que retorne `true` incondicionalmente.

Una prueba unitaria de ida y vuelta confirma que una firma sobre un mensaje verifica como válida y que sobre un mensaje distinto verifica como inválida.

> **Estado.** Este es el componente **funcional y verificado** del prototipo: la firma post-cuántica de NEXUS es real.

---

## 4.3 Enlace criptográfico de la firma a la transacción

La seguridad del primitivo (Cap. 6) solo se traduce en seguridad de la transacción si la firma está **ligada al contenido exacto** de la transacción y se **verifica** antes de aplicar la transición de estado. NEXUS lo garantiza con tres mecanismos:

1. **Preimagen de firma (`signing_hash`).** La firma se computa sobre $H(\mathrm{bincode}(tx))$, donde $tx$ incluye `chain_id` (anti-*replay* entre cadenas), `nonce` (anti-*replay* en la cuenta), tipo de transacción y montos. Así, **cualquier alteración del contenido invalida la firma**.

2. **Enlace clave pública ↔ dirección.** La validación de estructura recomputa $\mathrm{dirección} = H(pk)$ y rechaza la transacción si no coincide con el remitente declarado. Esto impide la **sustitución de clave**: un atacante no puede presentar la clave pública de otra cuenta.

3. **Verificación en la transición de estado.** El motor de ejecución (`nexus-active/src/execution.rs`) llama a `verify_signed_transaction` —que recomputa `signing_hash` y ejecuta la verificación Dilithium— **antes** de aplicar el débito/crédito; lo mismo hace la validación de bloques de la Anchor Layer. Una transacción con firma inválida **no** modifica el estado.

> **Conexión con el Cap. 6.** Esta cadena —Dilithium sUF-CMA **+ uso correcto** (firma ligada al contenido y verificada antes de la transición)— es la que sustenta la afirmación *in-falsificabilidad a nivel de transacción* (Cap. 6, §6.7), condicionada al supuesto de consenso honesto.

---

## 4.4 Higiene del material secreto

El manejo de claves secretas sigue buenas prácticas, verificadas en el código:

- **Borrado de memoria (`zeroize`).** La clave secreta implementa `ZeroizeOnDrop`: sus bytes se sobrescriben al liberarse, reduciendo la ventana de exposición en memoria.
- **`Debug` redactado.** Las representaciones de depuración de la clave secreta y del par de claves muestran `[REDACTED]`, evitando filtraciones accidentales por *logs*.
- **Posesión por valor.** El par de claves mantiene la clave secreta por valor, de modo que su borrado se garantiza al destruirse el par.

> **Pendiente menor (Plan Maestro, Fase A/B).** La clave secreta deriva `Clone`, lo que permite copias transitorias cuyo borrado depende de que cada copia se destruya. Conviene restringir o auditar los usos de `.clone()` sobre material secreto.

---

## 4.5 Derivación determinística de claves desde semilla

El Objetivo 2 incluye la **generación determinística de claves a partir de una semilla**. Esto es esencial para la gestión de claves (Cap. 5): permite reproducir una clave desde una semilla custodiada y conecta la fuente de entropía con el par de claves.

### 4.5.1 Fundamento: ML-DSA.KeyGen desde semilla

> **FIPS 204 / ML-DSA define una `KeyGen` determinística a partir de una semilla de 32 bytes** $\xi$: toda la aleatoriedad del esquema se deriva expandiendo $\xi$ con una función *XOF* (SHAKE). Por tanto, la generación determinística **no** requiere biometría ni construcciones ad hoc —basta con la `KeyGen` semillada del estándar.

El diseño de NEXUS:

$$
\xi \xleftarrow{\ \text{KDF}\ } \text{material de la fuente de entropía (Cap. 5)}, \qquad (pk, sk) = \mathsf{ML\text{-}DSA.KeyGen}(\xi).
$$

La semilla $\xi$ se deriva mediante un **KDF con separación de dominio** (SHA3/SHAKE) a partir del material de la fuente monitoreada (Cap. 5). Esto reemplaza por completo la derivación biométrica del alcance original (eliminada en v2): el determinismo se obtiene de una **semilla de alta entropía**, no de un biométrico.

### 4.5.2 Implementación (verificada)

`DilithiumKeypair::from_seed(ξ, esquema)` invoca la `KeyGen` semillada del crate `fips204` (`ml_dsa_N::KG::keygen_from_seed(ξ)`), de modo que **la misma semilla produce siempre el mismo par de claves**. El test `test_deterministic_from_seed` verifica que dos derivaciones con la misma semilla coinciden, que semillas distintas difieren, y que la clave derivada firma/verifica. **El determinismo prometido por el Objetivo 2 está implementado y verificado.**

> **Nota.** La migración de `pqcrypto-dilithium` (que no exponía `KeyGen` semillada y usaba randomness del SO) a `fips204` cerró esta brecha y, de paso, alineó el código con **FIPS 204 exacto**, eliminando la distinción round-3 / ML-DSA.

---

## 4.6 Elección del esquema de firma post-cuántica

La elección de Dilithium debe justificarse explícitamente, porque el sobrecosto de ~50× (Cap. 3) es **específico de Dilithium** y existen alternativas con perfiles distintos. La estandarización NIST y las decisiones de las cadenas líderes ofrecen anclas reales.

**Tabla 4.2 — Esquemas de firma post-cuántica.**

| Esquema (estándar) | Tamaño de firma | Perfil | Adopción real |
|---|---:|---|---|
| **Dilithium / ML-DSA** (FIPS 204, final) | 2,4–4,6 KB | Reticular (Module-LWE); **balanceado**, robusto, fácil de implementar | **NEXUS**; estándar de referencia |
| Falcon / FN-DSA (FIPS 206, **borrador ~fin 2026**) | **~666 B** | Reticular (NTRU); firma **pequeña**, pero usa punto flotante y es sensible a canales laterales | **Solana** (Anza y Firedancer convergieron) |
| SLH-DSA / SPHINCS+ (FIPS 205, final) | 7–17 KB | *Hash-based*, **ultra-conservador** (solo depende del hash), sin estado | custodia de alta garantía |
| Winternitz OTS (hash-based, un solo uso) | pequeña, con estado | One-time; conservador | **Solana Winternitz Vault** (live >2 años) |
| leanXMSS (hash-based, XMSS) | 2–4 KB | Conservador + STARK-friendly; requiere agregación | **Ethereum** (Lean Consensus, validadores) |

**Justificación de Dilithium para NEXUS.** Se elige Dilithium por el **equilibrio entre seguridad, tamaño e implementabilidad correcta** (es el esquema reticular más maduro y fácil de implementar sin errores). Las alternativas y sus trade-offs:

- **Falcon** recortaría el sobrecosto de ~50× a **~10×** (firma ~666 B), atacando el problema de tamaño de frente; pero su firma con punto flotante es delicada y FIPS 206 **aún está en borrador** (~fin 2026). Es la apuesta de Solana, que prioriza el tamaño.
- **Hash-based (SPHINCS+/Winternitz)** maximiza la confianza (seguridad conservadora) a costa de firmas mayores; es la apuesta de Ethereum para los validadores (donde la conservadurismo y la STARK-friendliness importan más), y un buen modelo para **custodia en frío** (la bóveda Winternitz de Solana).

> **Conexión con el Cap. 3.** La elección de Dilithium se compensa con la **amortización dual-chain**: el sobrecosto de tamaño se paga una vez fuera de cadena y se amortiza en L1. La divergencia **Ethereum (hash-based) / Solana (Falcon) / NEXUS (Dilithium)** muestra que no hay una respuesta única; cada sistema elige según sus prioridades, y NEXUS justifica la suya. *(Recuérdese además la tensión Dilithium-vs-STARK-friendliness del Cap. 3, §3.5.1.)*

---

## 4.7 Estado de implementación y limitaciones

**Tabla 4.3 — Estado de implementación y limitaciones.**

| Componente | Estado |
|---|---|
| Firma/verificación Dilithium (niveles 2/3/5) | **Implementado y verificado** (vía `fips204` / ML-DSA) |
| Enlace firma↔transacción + verificación en ejecución | **Implementado** |
| Higiene de claves (`zeroize`, `Debug` redactado) | **Implementado** (auditar `.clone()` de secretos) |
| Generación **determinística** desde semilla | **Implementado y verificado**: `from_seed` usa la `KeyGen` semillada de `fips204` (test `test_deterministic_from_seed`); ver §4.5 |
| Comparativa formal de esquemas PQ | desarrollada (§4.6) |

---

## 4.8 Conclusiones del capítulo

Este capítulo desarrolló el núcleo criptográfico (Objetivo 2):

1. **Dilithium está implementado y verificado** sobre una biblioteca auditada, con selección multinivel y verificación real (no *stubs*).
2. La firma está **correctamente ligada** al contenido de la transacción y se **verifica antes** de la transición de estado, sustentando la in-falsificabilidad a nivel de transacción (Cap. 6).
3. La **generación determinística desde semilla** está **implementada y verificada** vía la `KeyGen` semillada de `fips204` (FIPS 204 ML-DSA) + el KDF de `SentinelSeed`, reemplazando la derivación biométrica (eliminada).
4. La **elección de Dilithium** se justifica frente a Falcon (menor tamaño, menor madurez) y a los esquemas hash-based (mayor conservadurismo, mayor tamaño), con anclas reales en Ethereum y Solana y conexión con la amortización del Cap. 3.

---

## Referencias del capítulo

> *Índice local del capítulo; la **Bibliografía** consolidada al final del documento reúne todas las obras bajo clave única.*

- NIST. *FIPS 204: Module-Lattice-Based Digital Signature Standard (ML-DSA)*. 2024.
- **[D+18]** Ducas, Kiltz, Lepoint, Lyubashevsky, Schwabe, Seiler, Stehlé. *CRYSTALS-Dilithium: A Lattice-Based Digital Signature Scheme.* IACR ToCHES 2018(1).
- NIST. *FIPS 205: Stateless Hash-Based Digital Signature Standard (SLH-DSA)*. 2024. · *FIPS 206: FN-DSA (Falcon)* — borrador (~2026).
- H. Krawczyk. *Cryptographic Extraction and Key Derivation: The HKDF Scheme*. CRYPTO 2010 (RFC 5869).
- Solana. *Quantum Readiness* (Falcon; Winternitz Vault). 2026. · Ethereum. *Lean Consensus / leanXMSS* (ethereum.org/roadmap/future-proofing/quantum-resistance). 2026.
