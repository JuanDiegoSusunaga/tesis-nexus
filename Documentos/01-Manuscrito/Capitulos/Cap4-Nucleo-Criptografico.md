# Capítulo 4 — Núcleo Criptográfico Post-Cuántico

*Objetivo 2 · la "solución" del arco*

> **Rol en el arco de la tesis.** Este capítulo describe el esquema de firma, su integración de referencia y la generación determinista desde semilla. La validación TG2 identifica el perfil implementado y las condiciones de aplicación de las reducciones en §6.4; las pruebas funcionales y la garantía concreta de inforjabilidad mantienen alcances distintos.

---

## 4.1 Introducción

La autenticación requiere un esquema de firma y un protocolo de uso: mensaje y dominio correctos, asociación entre identidad y clave, política de vigencia y verificación antes de aplicar cambios. NEXUS emplea ML-DSA, derivado de CRYSTALS-Dilithium, mediante `fips204`. El capítulo 6 identifica MLWE, SelfTargetMSIS y MSIS y las obligaciones de correspondencia para el código. Este capítulo conserva la descripción del núcleo del Objetivo 2 con ese alcance de revisión TG2.

1. La **implementación verificada** de Dilithium (firma y verificación reales mediante el backend `fips204`), §4.2.
2. El **enlace de la firma a la transacción** y la verificación en la transición de estado, con las obligaciones de composición entre hash, codificación, firma y autorización (Cap. 6, §6.4), §4.3–4.4.
3. La **derivación determinística de claves** desde una semilla retenida, cuya generación y protección requieren hipótesis explícitas (Cap. 5), §4.5; y la **justificación de la elección de Dilithium** frente a esquemas alternativos, §4.6.

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

La implementación (`nexus-crypto/src/dilithium.rs`) **delega en `fips204`** (backend Rust de ML-DSA / FIPS 204, versión 0.4.6 en R1), no en código criptográfico propio. Es una decisión de diseño deliberada: la criptografía post-cuántica de bajo nivel es delicada (canales laterales, *rejection sampling*) y debe descansar sobre implementaciones revisadas. Se eligió `fips204` por exponer una **`KeyGen` determinística basada en semilla** (§4.5), necesaria para el Objetivo 2.

- **Generación de claves:** `ml_dsa_N::KG::try_keygen()` (aleatoria) o `keygen_from_seed(ξ)` (determinística, §4.5) producen $(pk, sk)$ reales.
- **Firma:** `sk.try_sign(mensaje, ctx)` produce una firma genuina; **no** hay bytes de firma fijos o simulados.
- **Verificación:** `pk.verify(mensaje, firma, ctx)` **propaga el resultado real** (booleano); un mensaje o firma incorrectos producen `false`. **No** existe un verificador que retorne `true` incondicionalmente.

Una prueba unitaria de ida y vuelta confirma que una firma sobre un mensaje verifica como válida y que sobre un mensaje distinto verifica como inválida.

> **Estado funcional.** La API genera claves y firmas y ejecuta verificación real. R1 contrasta mensajes, contextos y modos, pero sus pruebas comparten backend: no equivalen a KAT/ACVP independientes, una auditoría de canales laterales o una reducción mecanizada de la implementación.

---

## 4.3 Enlace criptográfico de la firma a la transacción

La autenticación de transacciones requiere ligar la firma al contenido y comprobarla antes de aplicar cambios. El código de referencia incorpora los controles siguientes; la correspondencia criptográfica y las políticas de autorización conservan las obligaciones de §6.4:

1. **Mensaje de firma (`signing_hash`).** La ruta serializa $tx$ con `bincode`, calcula **SHA3-256** y firma sus 32 bytes mediante ML-DSA puro con contexto vacío; no invoca HashML-DSA. El contenido incluye `chain_id`, `nonce`, tipo de transacción y montos. La autenticidad del contenido requiere una codificación de aplicación inequívoca y resistencia a colisiones del hash externo, además de la inforjabilidad de la firma sobre el digest. Las reglas de aceptación deben comprobar cadena y nonce para impedir repeticiones.

2. **Enlace clave pública ↔ dirección.** La validación de estructura recomputa $\mathrm{dirección} = H(pk)$ y rechaza la transacción si no coincide con el remitente declarado. Este control liga el remitente a la clave presentada bajo los supuestos del hash; no es una imposibilidad incondicional de sustitución de clave.

3. **Verificación en la transición de estado.** El motor de ejecución (`nexus-active/src/execution.rs`) llama a `verify_signed_transaction` —que recomputa `signing_hash` y ejecuta la verificación Dilithium— **antes** de aplicar el débito/crédito; lo mismo hace la validación de bloques de la Anchor Layer. Una transacción con firma inválida **no** modifica el estado.

**Fuerza de la composición.** FIPS 204 §5.4 trata tanto el hash a nivel de aplicación como HashML-DSA: para mantener la fuerza del perfil exige que el digest tenga fuerza clásica de colisión y segunda preimagen de al menos $\lambda$. La Tabla 1 fija $\lambda=128/192/256$, con longitudes necesarias de al menos 256/384/512 bits respectivamente. El SHA3-256 externo no permite trasladar automáticamente la fuerza de ML-DSA-65/87 a las transacciones. Esta observación limita la composición; no demuestra un ataque concreto ni un incumplimiento de la operación ML-DSA pura que firma el digest [NIST24, §5.4]. Los localizadores de la ruta son `nexus-core/src/transaction.rs`, `signing_hash`; `nexus-core/src/types.rs`, `Hash256::hash`; y `nexus-crypto/src/signer.rs`, `sign_transaction` y `verify_signed_transaction`.

> **Conexión con el Cap. 6.** Una garantía de autenticación requiere el supuesto de firma correspondiente y demostrar el puente de la implementación al protocolo de transacción, incluido su hash externo. R1-B conserva la obligación de codificaciones y sUF-CMA, y R3 distingue vigencia de época de validación histórica. El AIR ilustrativo de §6.7 no acredita ese puente ni demuestra verificación ML-DSA dentro de la prueba.

---

## 4.4 Higiene del material secreto

El manejo de claves secretas sigue buenas prácticas, verificadas en el código:

- **Borrado de memoria (`zeroize`).** La clave secreta implementa `ZeroizeOnDrop`: sus bytes se sobrescriben al liberarse, reduciendo la ventana de exposición en memoria.
- **`Debug` redactado.** Las representaciones de depuración de la clave secreta y del par de claves muestran `[REDACTED]`, evitando filtraciones accidentales por *logs*.
- **Posesión por valor.** El par de claves mantiene una representación de la clave secreta cuyo destructor aplica el mecanismo de borrado. Las copias, temporales, semilla retenida y efectos del compilador requieren el análisis de residencia de §5.6; no se deduce borrado de todo el material secreto del proceso.

> **Pendiente menor (Plan Maestro, Fase A/B).** La clave secreta deriva `Clone`, lo que permite copias transitorias cuyo borrado depende de que cada copia se destruya. Conviene restringir o auditar los usos de `.clone()` sobre material secreto.

---

## 4.5 Derivación determinística de claves desde semilla

El Objetivo 2 incluye la **generación determinística de claves a partir de una semilla**. Permite reproducir una clave desde una semilla custodiada y se conecta con la gestión de claves (Cap. 5). La propiedad de reproducción no acredita por sí sola la distribución, imprevisibilidad ni protección de esa semilla.

### 4.5.1 Fundamento: ML-DSA.KeyGen desde semilla

> **FIPS 204 / ML-DSA define `KeyGen_internal` determinística a partir de una semilla de 32 bytes** $\xi$: los valores necesarios para generar el par se derivan expandiendo $\xi$ con SHAKE. La función externa `KeyGen` obtiene primero esa semilla de un generador de bits aleatorios. El determinismo de la función interna no exige biometría ni certifica cualquier fuente que suministre $\xi$.

La ruta implementada por Sentinel deriva la entrada de esa función interna:

$$
\begin{aligned}
\xi_{e,j}&=\mathrm{SHA3\text{-}256}\big(D\parallel\operatorname{LE64}(e)\parallel\operatorname{LE64}(j)\parallel s_e\parallel\mathrm{contexto}\big),\\
(pk,sk)&=\mathsf{ML\text{-}DSA.KeyGen\_internal}(\xi_{e,j}).
\end{aligned}
$$

Aquí $D$ es el dominio fijo `NEXUS_SENTINEL_DERIVE`, $e$ la época, $j$ el contador de derivaciones y $s_e$ la semilla retenida. El flujo recibido por `ingest_source` condiciona la autorización para derivar; sus muestras no se incorporan a esta expresión. La semilla inicial se obtiene mediante un CSPRNG inicializado desde el sistema operativo y la renovación mezcla material fresco de `OsRng` (§5.3–5.5). La calidad de esos generadores, la función de derivación y su composición mantienen obligaciones propias; el monitor no las acredita automáticamente.

### 4.5.2 Implementación (verificada)

`DilithiumKeypair::from_seed(ξ, esquema)` invoca la `KeyGen` semillada del crate `fips204` (`ml_dsa_N::KG::keygen_from_seed(ξ)`), de modo que **la misma semilla produce siempre el mismo par de claves**. El test `test_deterministic_from_seed` verifica que dos derivaciones con la misma semilla coinciden, que semillas distintas difieren, y que la clave derivada firma/verifica. **El determinismo prometido por el Objetivo 2 está implementado y verificado.**

> **Nota.** La migración de `pqcrypto-dilithium` a `fips204` permitió reconstruir claves desde semilla y adoptó los perfiles ML-DSA definidos en FIPS 204. Las pruebas funcionales no acreditan conformidad independiente del conjunto, fuente aprobada ni comportamiento completo en casos extremos (§6.4).

---

## 4.6 Elección del esquema de firma post-cuántica

La elección de Dilithium debe justificarse explícitamente, porque el sobrecosto de ~50× (Cap. 3) es **específico de Dilithium** y existen alternativas con perfiles distintos. La estandarización NIST y las decisiones de las cadenas líderes ofrecen anclas reales.

**Tabla 4.2 — Esquemas de firma post-cuántica.**

| Esquema (estándar) | Tamaño de firma | Perfil | Adopción real |
|---|---:|---|---|
| **Dilithium / ML-DSA** (FIPS 204, final) | 2,4–4,6 KB | Reticular (Module-LWE); **balanceado**, robusto, fácil de implementar | **NEXUS**; estándar de referencia |
| Falcon / FN-DSA (FIPS 206, **estandarización en curso**) | **~666 B** | Reticular (NTRU); firma **pequeña**, pero usa punto flotante y es sensible a canales laterales | preparación estudiada por Anza [Anza-PQ26] |
| SLH-DSA / SPHINCS+ (FIPS 205, final) | 7,9–49,9 KB | Firma hash-based sin estado; tamaños según parámetros [FIPS205, Tabla 2] | alternativa de firma con costos propios |
| Winternitz OTS (hash-based, un solo uso) | según perfil | Requiere respetar el uso único de cada clave | propuesta de custodia a nivel de aplicación |
| leanXMSS (hash-based, XMSS) | 2–4 KB | Conservador + STARK-friendly; requiere agregación | propuesta de Lean Consensus [Eth-PQ26] |

**Justificación de Dilithium para NEXUS.** Se elige Dilithium por el **equilibrio entre seguridad, tamaño e implementabilidad correcta** (es el esquema reticular más maduro y fácil de implementar sin errores). Las alternativas y sus trade-offs:

- **Falcon** recortaría el sobrecosto de ~50× a **~10×** (firma ~666 B), atacando el problema de tamaño de frente; pero su firma con punto flotante es delicada y su proceso de estandarización sigue en curso [NIST-PQC26]. Es la apuesta de Solana, que prioriza el tamaño.
- **Hash-based (SPHINCS+/Winternitz)** maximiza la confianza (seguridad conservadora) a costa de firmas mayores; es la apuesta de Ethereum para los validadores (donde el conservadurismo y la STARK-friendliness importan más), y un buen modelo para **custodia en frío** (la bóveda Winternitz de Solana).

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

1. **Dilithium está implementado y verificado** mediante el backend `fips204`, con selección multinivel y verificación real (no *stubs*).
2. La ruta de referencia firma el digest SHA3-256 de la transacción y **verifica antes** de la transición de estado. La garantía de autenticación conserva las obligaciones de hash externo, codificación, correspondencia y autorización de §4.3 y §6.4; no hereda automáticamente la fuerza del perfil de firma.
3. La **generación determinística desde semilla** está **implementada y comprobada funcionalmente** mediante `keygen_from_seed` de `fips204` y la derivación SHA3-256 de `SentinelSeed`. La evaluación del flujo recibido es una compuerta operativa; la generación y protección de la semilla retenida requieren justificación separada (§5.4).
4. La **elección de Dilithium** se justifica frente a Falcon (menor tamaño, menor madurez) y a los esquemas hash-based (mayor conservadurismo, mayor tamaño), con anclas reales en Ethereum y Solana y conexión con la amortización del Cap. 3.

---

## Referencias del capítulo

> *Índice local del capítulo; la **Bibliografía** consolidada al final del documento reúne todas las obras bajo clave única.*

- NIST. *FIPS 204: Module-Lattice-Based Digital Signature Standard (ML-DSA)*. 2024.
- **[D+18]** Ducas, Kiltz, Lepoint, Lyubashevsky, Schwabe, Seiler, Stehlé. *CRYSTALS-Dilithium: A Lattice-Based Digital Signature Scheme.* IACR ToCHES 2018(1).
- NIST. *FIPS 205: Stateless Hash-Based Digital Signature Standard (SLH-DSA)*. 2024. · *FN-DSA (Falcon)* — estandarización en curso [NIST-PQC26].
- H. Krawczyk. *Cryptographic Extraction and Key Derivation: The HKDF Scheme*. CRYPTO 2010 (RFC 5869).
- Solana. *Quantum Readiness* (Falcon; Winternitz Vault). 2026. · Ethereum. *Lean Consensus / leanXMSS* (ethereum.org/roadmap/future-proofing/quantum-resistance). 2026.
