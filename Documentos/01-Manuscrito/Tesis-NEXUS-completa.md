---
title: "Arquitectura Blockchain Dual NEXUS: Un Modelo Matemático-Computacional para Sistemas Bancarios Seguros y Resilientes Post-Cuántico"
author: "Juan Diego Susunaga Velasquez"
date: "Universidad del Rosario — Escuela de Ciencias e Ingeniería · Programa de Matemáticas Aplicadas y Ciencias de la Computación (MACC) · Director: Pedro Mario Wightman Rojas · 03/08/2026"
lang: es
---

## Resumen

La inminente llegada de computadores cuánticos amenaza las firmas digitales (RSA, ECC) que autentican las transacciones de la infraestructura financiera: el algoritmo de Shor permitiría recuperar claves privadas a partir de las públicas expuestas y **falsificar firmas**, y el fenómeno *Harvest Now, Decrypt Later* hace urgente la migración a criptografía post-cuántica. Este trabajo presenta **NEXUS**, un **modelo matemático-computacional y prototipo de referencia** que asegura las firmas de una blockchain bancaria mediante el esquema post-cuántico **CRYSTALS-Dilithium** (NIST FIPS 204), sobre una **arquitectura dual-chain** (capa de anclaje L1 + capa de ejecución L2). Se demuestra que el principal costo de la criptografía post-cuántica es de **datos —no de cómputo—** y que la arquitectura dual **amortiza** ese sobrecosto (~50× por firma) hasta volverlo irrelevante para la capa de liquidación, exigiendo que el sistema de pruebas sea él mismo post-cuántico (STARK). La seguridad se **valida formalmente** reduciendo la in-forjabilidad de Dilithium a Module-LWE y, en última instancia, a problemas reticulares de peor caso (Mod-SIVP) resistentes a Shor, con un análisis de complejidad computacional. Se incorpora además la gestión activa del ciclo de vida de claves (min-entropía, NIST SP 800-90B, rotación con secrecia hacia adelante). La convergencia independiente de Ethereum y Solana hacia los mismos principios valida la dirección del trabajo.

**Palabras clave:** criptografía post-cuántica, blockchain, CRYSTALS-Dilithium, Module-LWE, arquitectura dual-chain, banca, validación formal.

## Abstract

The imminent arrival of quantum computers threatens the digital signatures (RSA, ECC) that authenticate financial transactions: Shor's algorithm would recover private keys from exposed public keys and **forge signatures**, and the *Harvest Now, Decrypt Later* threat makes migration to post-quantum cryptography urgent. This work presents **NEXUS**, a **mathematical-computational model and reference prototype** that secures the signatures of a banking blockchain using the post-quantum scheme **CRYSTALS-Dilithium** (NIST FIPS 204) over a **dual-chain architecture** (anchor layer L1 + active execution layer L2). It is shown that the main cost of post-quantum cryptography is one of **data —not computation—** and that the dual architecture **amortizes** that overhead (~50× per signature) until it becomes irrelevant to the settlement layer, requiring the proof system itself to be post-quantum (STARK). Security is **formally validated** by reducing Dilithium's unforgeability to Module-LWE and, ultimately, to worst-case lattice problems (Mod-SIVP) resistant to Shor, together with a computational-complexity analysis. Active key-lifecycle management (min-entropy, NIST SP 800-90B, forward-secure rotation) is also incorporated. The independent convergence of Ethereum and Solana toward the same principles validates the direction of this work.

**Keywords:** post-quantum cryptography, blockchain, CRYSTALS-Dilithium, Module-LWE, dual-chain architecture, banking, formal validation.


# Capítulo 1 — Introducción

### (Planteamiento del problema, modelo de amenaza y objetivos)

> **Rol en el arco de la tesis.** Este capítulo abre el arco narrativo: establece la **amenaza** (cuántica a las firmas de banca), anticipa la **solución** (firmas post-cuánticas) y su **costo** (que motiva el dual-chain), fija el **modelo de amenaza preciso**, y enuncia los objetivos, el alcance y la contribución. Los desarrollos correspondientes están en los Capítulos 3–6.

---

## 1.1 Contexto y motivación

La infraestructura financiera digital descansa, en su raíz, sobre la criptografía de clave pública: las **firmas digitales** autorizan transacciones y los esquemas de cifrado protegen la confidencialidad. Hoy esa criptografía es, casi universalmente, **RSA** y **criptografía de curva elíptica (ECC)**, cuya seguridad se apoya en la dureza de la factorización y del logaritmo discreto.

La computación cuántica amenaza ese cimiento. El **algoritmo de Shor** resuelve ambos problemas en **tiempo polinómico** sobre un computador cuántico suficientemente grande, rompiendo RSA y ECC. Aunque tal computador no existe aún, la amenaza es **presente** por el fenómeno **"Harvest Now, Decrypt Later" (HNDL)**: un adversario puede **cosechar hoy** información (datos cifrados, claves públicas expuestas) y **explotarla mañana**, cuando disponga de capacidad cuántica. Para infraestructura bancaria —cuyos activos y secretos tienen vida útil de décadas— esto exige adoptar **criptografía post-cuántica (PQC)** **desde ya**, no cuando la amenaza se materialice. La estandarización del NIST (FIPS 203/204/205, finalizados en 2024) y la migración de las grandes cadenas (Cap. 2) confirman que esta transición está en marcha.

## 1.2 Modelo de amenaza

Una validación de seguridad requiere un modelo de amenaza **preciso**. NEXUS distingue cuidadosamente dos amenazas cuánticas, frecuentemente confundidas:

**(A) Amenaza a la confidencialidad (HNDL en sentido estricto).** Datos cifrados con un esquema clásico y cosechados hoy podrían descifrarse en el futuro. Mitigar esto requiere un **mecanismo de encapsulado de claves (KEM) post-cuántico** (p. ej. ML-KEM / Kyber, FIPS 203). **Esta amenaza queda fuera del alcance** de esta tesis, que se centra en las firmas; se enuncia como trabajo futuro (Cap. 7).

**(B) Amenaza a la autenticación (el foco de NEXUS).** En una blockchain, la **clave pública** de una cuenta queda **expuesta** (almacenada en cadena, o revelada al firmar una transacción). Un adversario cuántico que observe esa clave pública puede, mediante Shor, **recuperar la clave privada** y con ella **falsificar firmas**: robar fondos, suplantar cuentas, corromper el libro mayor. **Este es el activo crítico que NEXUS protege**, sustituyendo ECDSA por un esquema de firma post-cuántico (CRYSTALS-Dilithium, Cap. 4) cuya in-forjabilidad se valida formalmente (Cap. 6).

**Adversario.** Se considera un adversario con capacidad de cómputo cuántico (incluido el acceso al oráculo de hash en superposición, QROM, Cap. 6), capaz de observar todos los datos públicos de la cadena. **No** se consideran (fuera de alcance) los ataques de implementación (canales laterales, fallos) ni la seguridad del consenso (que se asume honesto-mayoritario; Cap. 3, §3.10).

**Mitigación complementaria — revelar-al-gastar.** Como defensa en profundidad frente a la amenaza (B), NEXUS deriva la **dirección como un hash de la clave pública** ($\text{dirección} = H(pk)$). Así, mientras una cuenta no haya gastado, el adversario solo ve un hash y **no puede recuperar la clave** (Shor opera sobre la clave pública, no sobre su hash). Esto **retrasa** la exposición cuántica y reduce la superficie de "harvest now", complementando a la PQC. *(Refinamiento: minimizar la exposición de la clave pública en las transacciones, no solo en la dirección.)*

## 1.3 El problema: seguridad post-cuántica a un costo tractable

Adoptar firmas post-cuánticas no es gratis. Una firma Dilithium es **~50× más grande** que una firma ECDSA (3 309 B vs. 64 B). Aplicada de forma ingenua sobre una blockchain de cadena única, esa inflación de datos **degrada el rendimiento en ~20×** (Cap. 3, §3.3), reabriendo el **trilema de la blockchain** (escalabilidad, seguridad, descentralización) que se creía en vías de solución.

El problema central de esta tesis es, por tanto:

> **¿Cómo asegurar las firmas de una blockchain bancaria contra la amenaza cuántica sin sacrificar la escalabilidad?**

La respuesta de NEXUS es **arquitectónica**: una estructura **dual-chain** (L1 de anclaje + L2 de ejecución) que **amortiza** el sobrecosto de la PQC —ejecutando y probando las firmas fuera de cadena y publicando en L1 solo un compromiso— hasta volver el tamaño de la firma irrelevante para la capa de liquidación (Cap. 3, §3.4). Como corolario, la capa de verificación debe ser ella misma post-cuántica (STARK, no Groth16; Cap. 3, §3.5).

## 1.4 Propuesta y contribución

**Tesis (en una frase).**

> *NEXUS formaliza y prototipa cómo asegurar firmas digitales de banca contra la amenaza cuántica con CRYSTALS-Dilithium, demostrando formalmente su seguridad (reducción a Module-LWE) y resolviendo el sobrecosto de datos que la PQC introduce mediante una arquitectura dual-chain con verificación post-cuántica.*

**Arco narrativo.** El trabajo se organiza como una sola cadena de razonamiento:
$$\text{Amenaza} \to \text{Solución (PQC)} \to \text{Costo} \to \text{Respuesta (dual-chain)} \to \text{Coherencia (STARK)} \to \text{Validación (formal + complejidad)}.$$

**Naturaleza del aporte.** El entregable es un **modelo matemático-computacional acompañado de un prototipo de referencia**, no un sistema de producción. La arquitectura se *especifica y modela*; el núcleo de firmas y la gestión de claves se *implementan y verifican*; la seguridad se *valida formalmente*. La capa de computación verificable (ZK) se entrega como **PoC STARK** —su motor criptográfico post-cuántico está implementado y verificado por pruebas (Cap. 3, §3.5)— más **diseño de referencia** para su aritmetización completa; el consenso bizantino operativo se entrega como diseño de referencia (trabajo futuro).

**Novedad.** La criptografía post-cuántica, los esquemas de firma reticulares y los *rollups* existen por separado. La contribución de NEXUS es la **síntesis específica**:

> *el tratamiento formal y cuantificado de cómo el sobrecosto de datos de las firmas post-cuánticas motiva y se mitiga con una arquitectura dual-chain de prueba de validez post-cuántica para banca, llevando el costo on-chain por transacción al de su diferencia de estado clásica.*

La **convergencia independiente de Ethereum y Solana** hacia las mismas conclusiones (Cap. 2) **valida** —no resta— esta dirección.

## 1.5 Objetivos

**Objetivo general.** Diseñar, modelar y **validar formalmente** un modelo matemático-computacional de firmas digitales post-cuánticas (CRYSTALS-Dilithium) para una arquitectura blockchain dual orientada a sistemas bancarios resilientes, incorporando la gestión activa del ciclo de vida de claves y la prueba formal de su seguridad (reducción a Module-LWE) y de su complejidad computacional.

**Objetivos específicos.**
1. **Diseñar la arquitectura Dual-Chain** como modelo de referencia, especificando los roles de la Anchor Layer (L1) y la Active Layer (L2) y el camino de la firma post-cuántica (Cap. 3).
2. **Desarrollar e implementar el núcleo criptográfico** post-cuántico (Dilithium) y la derivación determinística de claves desde semilla mediante un KDF (Cap. 4).
3. **Modelar e implementar la lógica de seguridad activa** del ciclo de vida de claves: min-entropía de la fuente, pruebas de salud (NIST SP 800-90B) y rotación con secrecia hacia adelante (Cap. 5).
4. **Formalizar y validar la seguridad y la complejidad**: reducción de la in-forjabilidad de Dilithium a Module-LWE / SelfTargetMSIS / Module-SIS → Mod-SIVP, con el argumento de resistencia cuántica; y análisis de complejidad (notación O) (Cap. 6).

## 1.6 Alcance

**Dentro del alcance:** diseño y especificación de la arquitectura dual; implementación verificada de Dilithium y su enlace a las transacciones; derivación determinística por KDF; gestión activa de claves (min-entropía + salud + rotación); y validación formal (reducción + complejidad + benchmarks).

**Fuera del alcance (declarado):** autenticación biométrica / extractores difusos (**eliminados**); implementación operativa de la capa ZK, del consenso BFT en red y de la disponibilidad de datos (diseño de referencia + trabajo futuro); confidencialidad post-cuántica (KEM); seguridad de implementación (canales laterales).

## 1.7 Estructura del documento

| Cap. | Contenido | Objetivo |
|---|---|:---:|
| **1** | Introducción, modelo de amenaza, objetivos | — |
| **2** | Marco teórico y estado del arte | — |
| **3** | Diseño de la arquitectura Dual-Chain (overhead → respuesta → coherencia) | Obj 1 |
| **4** | Núcleo criptográfico post-cuántico (Dilithium + KDF) | Obj 2 |
| **5** | Gestión activa del ciclo de vida de claves | Obj 3 |
| **6** | Validación formal de seguridad y complejidad | Obj 4 |
| **7** | Conclusiones y trabajo futuro | — |


# Capítulo 2 — Marco Teórico y Estado del Arte

### (Fundamentos y posicionamiento del trabajo)

> **Rol en el arco de la tesis.** Este capítulo provee los **fundamentos conceptuales** que el resto del documento usa y sitúa a NEXUS frente al estado del arte. Las definiciones formales rigurosas (retículos, Module-LWE, etc.) se enuncian aquí a nivel **expositivo** y se desarrollan con precisión en el **Capítulo 6**.

---

## 2.1 Blockchain, el trilema y las arquitecturas de capas

Una **blockchain** es un libro mayor distribuido y replicado, cuyo estado evoluciona mediante transacciones autenticadas por firmas digitales y ordenadas por un protocolo de **consenso**. Su diseño enfrenta el llamado **trilema de la blockchain**: la dificultad de lograr simultáneamente **escalabilidad**, **seguridad** y **descentralización**.

La respuesta dominante de la industria es la **arquitectura de capas** (*rollup-centric*): una capa base **L1** que provee consenso, finalidad y **disponibilidad de datos**, y capas de ejecución **L2** (*rollups*) que procesan transacciones a alta velocidad y asientan en L1 un compromiso de su estado, acompañado de una prueba (de **validez**, en los *ZK-rollups*, o impugnable, en los *optimistic rollups*) [Buterin21]. NEXUS adopta esta separación (Anchor L1 / Active L2; Cap. 3), pero por una razón adicional y específica: **amortizar el sobrecosto de las firmas post-cuánticas** (Cap. 3, §3.4).

## 2.2 La amenaza cuántica: Shor y Grover

Dos algoritmos cuánticos definen la amenaza:

- **Algoritmo de Shor (1997).** Resuelve la factorización de enteros y el logaritmo discreto en **tiempo polinómico**, rompiendo RSA, Diffie-Hellman y ECC. Para una blockchain, implica que un adversario cuántico puede **recuperar la clave privada** desde la pública expuesta y **falsificar firmas** (Cap. 1, §1.2).
- **Algoritmo de Grover (1996).** Acelera cuadráticamente la búsqueda no estructurada, debilitando la seguridad de primitivos **simétricos** y **hashes** (efectivamente reduce a la mitad sus bits de seguridad). Esto motiva parámetros mayores en hashes/cifrados simétricos, y es la base de la **cota conservadora** "mitad de bits" para esquemas reticulares (cuya estimación real, por *sieving*, es mucho menos pesimista; Cap. 6, §6.4.3).

La combinación de ambos con el fenómeno **HNDL** (Cap. 1) hace que la migración a criptografía post-cuántica sea urgente para infraestructura de larga vida.

## 2.3 Criptografía post-cuántica basada en retículos

La familia post-cuántica más madura para firmas se basa en **retículos**. Un **retículo** es el conjunto de combinaciones enteras de un conjunto de vectores base; sobre él se definen problemas computacionales —hallar el vector más corto (SVP), o $n$ vectores cortos independientes (SIVP)— que se conjeturan **difíciles tanto clásica como cuánticamente** (a diferencia de la factorización, Shor **no** se les aplica; Cap. 6, §6.4.3).

La seguridad práctica se apoya en dos problemas promedio sobre **retículos de módulo**, eficientes en tamaño de clave:
- **Module-LWE** (*Learning With Errors*): distinguir $(\mathbf{A}, \mathbf{A}\mathbf{s}+\mathbf{e})$ de uniforme, con $\mathbf{s},\mathbf{e}$ "pequeños".
- **Module-SIS** (*Short Integer Solution*): hallar un vector corto no nulo en el núcleo de $\mathbf{A}$.

Sobre ellos se construye **CRYSTALS-Dilithium** (NIST FIPS 204 / ML-DSA), el esquema de firma que NEXUS adopta, mediante el paradigma **Fiat-Shamir with Aborts** [Lyu09, Lyu12]. La reducción de su seguridad a estos problemas, y de éstos a problemas reticulares de peor caso (Mod-SIVP), se desarrolla formalmente en el **Capítulo 6**.

## 2.4 El panorama PQC y la estandarización NIST

El NIST estandarizó en 2024 los primeros esquemas post-cuánticos, con un cuarto en camino:

| Estándar | Esquema | Tipo | Estado |
|---|---|---|---|
| FIPS 203 | ML-KEM (Kyber) | KEM reticular (cifrado) | final (2024) |
| **FIPS 204** | **ML-DSA (Dilithium)** | **firma reticular** | **final (2024)** — *usado por NEXUS* |
| FIPS 205 | SLH-DSA (SPHINCS+) | firma hash-based | final (2024) |
| FIPS 206 | FN-DSA (Falcon) | firma reticular (NTRU) | borrador (~fin 2026) |

Estos esquemas difieren en sus compromisos (tamaño de firma, conservadurismo, facilidad de implementación). El **Capítulo 4, §4.6** desarrolla la comparativa y justifica la elección de Dilithium para NEXUS frente a Falcon (firma menor) y a los esquemas hash-based (más conservadores).

## 2.5 Aleatoriedad, entropía y derivación de claves

La seguridad de toda clave depende de la calidad de la **aleatoriedad** de la que nace. La medida pertinente **no** es la entropía de Shannon de una muestra, sino la **min-entropía de la fuente**, $H_\infty(X) = -\log_2 \max_x \Pr[X{=}x]$, que captura la imprevisibilidad en el peor caso. El estándar **NIST SP 800-90B** define la **estimación de min-entropía** y las **pruebas de salud en línea** (*Repetition Count Test*, *Adaptive Proportion Test*) que vigilan la degradación de un generador. A partir de una fuente sana, una **función de derivación de claves (KDF)** con separación de dominio (HKDF, RFC 5869 / SHAKE256) produce semillas para las claves. Estos fundamentos sustentan la gestión activa de claves del **Capítulo 5**.

## 2.6 Pruebas de conocimiento cero y su coherencia post-cuántica

Las **pruebas de conocimiento cero** (ZK) permiten demostrar la validez de una afirmación sin revelar su contenido, y son el mecanismo que hace que un *ZK-rollup* pueda asentar en L1 una prueba sucinta de que un *batch* de transacciones es correcto (Cap. 3, §3.4). Dos familias son relevantes:
- **SNARKs de emparejamientos** (p. ej. Groth16): pruebas muy pequeñas (~200 B), pero su seguridad descansa en el logaritmo discreto en curvas → **rotas por Shor** (no post-cuánticas).
- **STARKs** (basados en hashes y FRI): pruebas mayores, pero su seguridad se apoya solo en funciones hash → **post-cuánticas**.

Esta distinción es **central** para NEXUS: para que la verificación del L2 no reintroduzca una vulnerabilidad cuántica, el sistema de pruebas debe ser post-cuántico (STARK), no Groth16 (Cap. 3, §3.5).

## 2.7 Estado del arte y posicionamiento de NEXUS

Los **blockchains post-cuánticos** son un área activa de investigación [Yang23]. Más relevante aún, las cadenas líderes están **migrando a PQC en la práctica** (estado a mediados de 2026):

- **Ethereum — "Lean Consensus"** (antes *Beam Chain*): reemplaza las firmas BLS de los validadores por firmas **hash-based (leanXMSS)**, que pesan 20–40× más y carecen de agregación nativa, y lo resuelve con **`leanVM`, un zkVM que las comprime ~250×** mediante agregación SNARK post-cuántica; ethereum.org declara que **«los STARKs ya son resistentes a la cuántica»**. La abstracción de cuentas (EIP-7702, *live*; EIP-8141) habilita la migración por cuenta.
- **Solana**: sus equipos núcleo (Anza y Firedancer) **convergieron independientemente en Falcon** (abril 2026); la **Winternitz Vault** (hash-based) lleva años en producción. **Alpenglow** lleva la finalidad a ~100–150 ms.
- **Gestión y defensa de la clave del firmador.** En la custodia de claves ML-DSA, guardar **solo la semilla** de 32 bytes es ya práctica estandarizada (FIPS 204 §3.6.3; el RFC 9881 la declara el formato **recomendado** [RFC9881]; OpenSSL 3.5 la implementa por defecto). En cambio, una revisión con fuentes verificadas (jul. 2026) **no localiza ningún sistema** que combine (a) semilla sellada en hardware, (b) detección de compromiso u observación del servidor de firma y (c) respuesta coordinada con la L2. Los antecedentes son parciales: custodia de claves de validador en enclave SGX con atestación verificada en cadena (Puffer Secure-Signer), un *builder* de L2 en TEE orientado a MEV (Rollup-Boost/Unichain), el patrón *honeychecker* de los honeywords [JR13] y las claves señuelo estáticas de una patente industrial [US10521584] — ninguno con criptografía post-cuántica. NEXUS aborda ese hueco con la **residencia efímera** (Cap. 5, §5.6) y la propuesta de **Deception Engine** (Cap. 7, §7.5).

**Posicionamiento.** NEXUS no inventa la categoría ni un resultado de frontera; su aporte es la **síntesis formal y cuantificada** para banca (Cap. 1, §1.4). Crucialmente, la industria **converge independientemente** hacia los mismos principios que NEXUS formaliza —firmas post-cuánticas, agregación por pruebas para domar el overhead, y sistemas de prueba post-cuánticos (STARK)—, lo que **valida** la dirección del trabajo. La divergencia en la elección de esquema (Ethereum→hash-based, Solana→Falcon, NEXUS→Dilithium) evidencia que la decisión debe justificarse según las prioridades de cada sistema, como hace NEXUS (Cap. 4, §4.6).

## 2.8 Síntesis del marco

Este capítulo estableció: el contexto de capas L1/L2 (§2.1), la amenaza cuántica concreta (§2.2), los fundamentos reticulares y de Dilithium (§2.3), el panorama de estándares (§2.4), la entropía y derivación de claves (§2.5), el papel y la coherencia post-cuántica de las pruebas ZK (§2.6), y el estado del arte que valida y posiciona a NEXUS (§2.7). Sobre estos fundamentos se construyen el diseño (Cap. 3), el núcleo criptográfico (Cap. 4), la gestión de claves (Cap. 5) y la validación formal (Cap. 6).

---

## Referencias del capítulo

> *Índice local del capítulo; la **Bibliografía** consolidada al final del documento reúne todas las obras bajo clave única.*

- [Buterin21] V. Buterin. *An Incomplete Guide to Rollups*. 2021.
- [Sho97] P. Shor. *Polynomial-Time Algorithms for Prime Factorization and Discrete Logarithms on a Quantum Computer*. SIAM J. Comput. 1997.
- [Gro96] L. Grover. *A Fast Quantum Mechanical Algorithm for Database Search*. STOC 1996.
- [Lyu09] V. Lyubashevsky. *Fiat-Shamir with Aborts*. ASIACRYPT 2009. · [Lyu12] *Lattice Signatures without Trapdoors*. EUROCRYPT 2012.
- NIST. *FIPS 203 (ML-KEM) / 204 (ML-DSA) / 205 (SLH-DSA)*, 2024; *FIPS 206 (FN-DSA)*, borrador.
- NIST. *SP 800-90B* (fuentes de entropía); H. Krawczyk, *HKDF* (RFC 5869).
- [Yang23] Z. Yang et al. *A Survey and Comparison of Post-Quantum and Quantum Blockchains*. IEEE Communications Surveys & Tutorials, 2023.
- [EthRoadmap26] Ethereum Foundation. *Roadmap — Future-proofing: Quantum resistance* (Lean Consensus / leanXMSS; leanVM; EIP-7702, EIP-8141). ethereum.org/roadmap/future-proofing/quantum-resistance. Acceso: jun. 2026.
- [Solana-QR26] Solana / Anza. *Quantum Readiness* (Falcon; Winternitz Vault) y *Alpenglow* (Votor/Rotor). 2026. Acceso: jun. 2026.
- [RFC9881] J. Massimo, P. Kampanakis, S. Turner, B. Westerbaan. *RFC 9881: Internet X.509 PKI — Algorithm Identifiers for ML-DSA*. IETF, 2025.
- [JR13] A. Juels, R. L. Rivest. *Honeywords: Making Password-Cracking Detectable*. ACM CCS 2013.
- [US10521584] N. Sharifi Mehr (Amazon Technologies). *Computer Threat Analysis Service*. Patente US 10,521,584 B1, 2019.
- Puffer Finance. *Secure-Signer / RAVe* (claves de validador en SGX + atestación on-chain), 2023–2025; Flashbots. *Rollup-Boost* (builder de L2 en TEE, Unichain), 2025.


# Capítulo 3 — Diseño de la Arquitectura Dual-Chain

### (Objetivo 1 · el capítulo "espina": Costo → Respuesta → Coherencia)

> **Rol en el arco de la tesis.** Este capítulo es la articulación central: toma la **solución** (firmas post-cuánticas, Cap. 4), expone el **costo** que introducen, y muestra que la **arquitectura dual-chain** es la *respuesta* a ese costo, exigiendo además **coherencia post-cuántica** en su capa de verificación. El análisis cuantitativo detallado vive en el documento companion `Analisis-Overhead-PQC-DualChain`; aquí se integra con el diseño arquitectónico completo.

---

## 3.1 Introducción

Una blockchain bancaria post-cuántica enfrenta una tensión que este capítulo resuelve. Por un lado, **debe** usar firmas post-cuánticas (Dilithium) para resistir la amenaza cuántica a la autenticación de transacciones (Cap. 1, Cap. 6). Por otro, esas firmas son **~50× más grandes** que las clásicas, lo que —aplicado de forma ingenua sobre una cadena única— degrada el rendimiento en un orden de magnitud.

La tesis de este capítulo es que **la arquitectura dual-chain no es un complemento opcional, sino la respuesta directa a ese sobrecosto**: al ejecutar y verificar las firmas en una capa L2 y publicar en L1 solo un compromiso respaldado por una prueba, el costo on-chain por transacción post-cuántica se amortiza hasta el de su diferencia de estado clásica. Como corolario, **la capa de verificación del L2 debe ser ella misma post-cuántica**, lo que determina decisiones concretas de diseño (§3.5).

El capítulo desarrolla el Objetivo 1: especifica los roles de la **Anchor Layer (L1)** y la **Active Layer (L2)**, el camino de la firma post-cuántica a través del sistema, y los componentes clave (Nexus Sequencer, Nitro Verifier), integrando la evidencia de que las cadenas líderes (Ethereum, Solana) convergen hacia el mismo diseño.

---

## 3.2 Visión general de la arquitectura

NEXUS separa **liquidación** de **ejecución** en dos capas:

- **Anchor Layer (L1) — la capa de anclaje.** Provee consenso, finalidad irreversible y disponibilidad de datos. Es la raíz de confianza: lenta pero segura. Almacena los compromisos de estado del L2 y garantiza que los datos necesarios estén disponibles.
- **Active Layer (L2) — la capa activa.** Ejecuta transacciones a alta velocidad: secuencia, verifica firmas Dilithium, aplica transiciones de estado, agrupa en *batches* y produce una prueba de validez que asienta en L1.

### El camino de la firma post-cuántica

El elemento que estructura el diseño es **el recorrido de una firma Dilithium a través del sistema**:

```
  Usuario           Active Layer (L2)                          Anchor Layer (L1)
 ┌───────┐   ┌──────────────────────────────────┐   ┌───────────────────────────────┐
 │ firma │──▶│ Sequencer ─▶ Ejecución ─▶ Batch + │──▶│ Verifica 1 prueba ─▶ Compromiso│
 │ tx PQC│   │ (verifica   (transición  prueba   │   │ de estado + DA ─▶ Finalidad    │
 └───────┘   │  Dilithium)  de estado)  STARK)   │   │ (las firmas NO suben a L1)     │
             └──────────────────────────────────┘   └───────────────────────────────┘
```

La firma de 3,3 KB se verifica **una vez en el L2** y se **prueba** de forma sucinta; **no viaja a la L1**. Este es el mecanismo que amortiza el sobrecosto (§3.4) y la razón por la que el dual-chain es la respuesta correcta.

> **Validación externa.** La hoja de ruta *rollup-centric* de Ethereum adopta exactamente esta separación (L1 = liquidación + DA; ejecución en L2), lo que respalda la elección arquitectónica como consenso de diseño de la industria.

---

## 3.3 El sobrecosto de la criptografía post-cuántica

El costo de la PQC tiene **dos dimensiones**, y solo una es el cuello de botella.

**Tabla 3.1 — ECDSA P-256 vs. Dilithium3.** *(El cociente exacto 3 309/64 ≈ 52× se redondea a ~50× en el texto narrativo; ambas cifras designan el mismo dato.)*

| Magnitud | ECDSA P-256 | Dilithium3 | Razón | ¿Cuello de botella? |
|---|---:|---:|---:|:---:|
| Firma | 64 B | 3 309 B | ~52× | **Sí (datos)** |
| Clave pública | 33 B | 1 952 B | ~59× | **Sí (datos)** |
| Verificación (CPU) | decenas de µs | ~0,17–0,44 ms (medido) | ~1× (mismo orden, sub-ms) | No |

**Hallazgo central:** el penalizador post-cuántico es de **tamaño** (ancho de banda, almacenamiento, disponibilidad de datos), **no de cómputo** —verificar Dilithium cuesta lo mismo que ECDSA—. Por tanto, lo que hay que optimizar es **la cantidad de datos de autenticación que tocan la L1**, que es precisamente la función de un rollup.

**Impacto en una cadena única.** Modelando una transacción como carga útil base $b$ más la firma, y un presupuesto de datos por bloque $B_d$, el throughput es $\mathrm{TPS}=B_d/(\tau(b+s))$. Con $b\approx100$ B, $B_d=1$ MB, $\tau=12$ s:

$$\frac{\mathrm{TPS}_{\text{ECDSA}}}{\mathrm{TPS}_{\text{Dilithium}}} = \frac{b+s_q}{b+s_c} = \frac{3409}{164} \approx 20{,}8\times.$$

Es decir, **adoptar PQC de forma ingenua cuesta ~20× de throughput** (la firma es el ~97 % de los bytes de la transacción), y la componente de firmas del libro mayor crece ~50× más rápido. *(Derivación completa y análisis de sensibilidad: documento `Analisis-Overhead`, §2.)*

---

## 3.4 La amortización dual-chain

El rollup ejecuta $M$ transacciones fuera de cadena y publica en L1 solo un compromiso $C$, una prueba $\pi$ y los datos de disponibilidad $D$. La observación crucial:

> Si una **prueba de validez** atestigua sucintamente que las $M$ transacciones estaban correctamente firmadas (Dilithium) y ejecutadas, **las firmas no necesitan publicarse en L1**. El sobrecosto de 50× se paga una vez fuera de cadena y se **elimina** de la L1.

El costo on-chain por transacción es entonces
$$F(M) = d + \frac{C+\pi}{M} \xrightarrow{\ M\to\infty\ } d,$$
donde $d$ es la **diferencia de estado** por transacción —**independiente del esquema de firma**—. El factor $s_q$ **desaparece** del costo on-chain. Con valores modelados ($d\approx40$ B), un rollup de validez reduce el costo por transacción post-cuántica de 3 409 B a $\sim$40–140 B (reducción **~24–85×**), con punto de equilibrio en lotes de $\sim$10⁴ transacciones (§3.5).

**En la dimensión de cómputo**, la L1 verifica **una** prueba por *batch* (independiente de $M$) en lugar de $M$ firmas, reduciendo el cómputo de verificación on-chain a $\sim$0 por transacción. Como el costo de verificar Dilithium ya es bajo (§3.3), este ahorro es secundario frente al de datos.

> **Conclusión de diseño.** El dual-chain lleva el costo amortizado on-chain de una transacción post-cuántica al de su diferencia de estado clásica: **el tamaño de la firma se vuelve irrelevante para la L1.**

---

## 3.5 Coherencia post-cuántica del verificador (decisión de diseño crítica)

La amortización de §3.4 depende de una prueba de validez. Aquí aparece una **inconsistencia latente** que el diseño debe resolver:

> Si la prueba que la L1 verifica usa **Groth16 sobre BN254** (basado en emparejamientos / logaritmo discreto), **Shor la rompe**. Un adversario cuántico podría falsificar la prueba que atestigua las transacciones, y la L1 la aceptaría — reintroduciendo la vulnerabilidad cuántica en la capa de verificación, justo la que el sistema pretende eliminar.

**Decisión:** el verificador (el "Nitro Verifier") debe usar un **sistema de pruebas post-cuántico** —un **STARK** (hash + FRI) o un SNARK reticular—, no Groth16.

**Tabla 3.2 — Sistemas de prueba.**

| Sistema | Base de seguridad | ¿Post-cuántico? | $\pi$ | Equilibrio de lotes |
|---|---|:---:|---:|---:|
| Groth16 (emparejamientos) | log. discreto en curvas | No (Shor) | ~200 B | ~10² tx |
| **STARK** (hash + FRI) | resistencia de colisión | Sí | ~10²–10³ KB | ~10⁴ tx |

El precio de la coherencia PQ es una prueba mayor → un equilibrio de lotes mayor (~10⁴ tx), perfectamente alcanzable. Esto convierte al Nitro Verifier de adorno opcional en **componente arquitectónico necesario y justificado**.

> **Prototipo de referencia implementado (PoC).** Para sustanciar esta decisión más allá del diseño, se implementó en el repositorio (`nexus-zk::stark`, cableado en `nexus-active::pq_verifier`) un **STARK hash-based propio** que materializa el **motor criptográfico post-cuántico** del Nitro Verifier (no su aritmetización completa): campo de Goldilocks ($p=2^{64}-2^{32}+1$), codificación Reed–Solomon vía **NTT**, compromisos de **Merkle sobre SHA3-256** con separación de dominio hoja/nodo, no interactividad por **Fiat–Shamir** y prueba de bajo grado **FRI**. Una transición de estado se aritmetiza (frontera + transición → polinomio de composición) y su validez se reduce a una afirmación de bajo grado que FRI certifica, atando la traza al compromiso en la fase de consulta. **Ninguna primitiva usa emparejamientos ni curvas elípticas** —solo hash y aritmética de campo—, de modo que **Shor no aplica**, a diferencia del andamiaje Groth16/BN254 que reemplaza.
>
> **Endurecimiento (soundness ~100 bits).** Los desafíos del verificador (combinación `α`, plegado `β`) se extraen del **campo de extensión** $F_{p^2}\ (\approx 2^{128})$ —no del campo base de 64 bits—, lo que eleva los términos de soundness de la combinación de restricciones y del plegado FRI ($\sim\!\text{grado}/|F|$) por encima de $2^{-100}$; esto es **estructural** (en el campo base el techo caería a ~40 bits para trazas grandes, sin importar el número de consultas). Se añade **grinding** (proof-of-work de 20 bits en Fiat–Shamir, que anula el re-muestreo de la transcripción) y **40 consultas distintas** —muestreadas *sin reemplazo* (una consulta repetida no aporta soundness); las 40 se alcanzan para $T\ge 16$, que cubre todos los tamaños medidos— a *rate* $\rho=1/4$. Presupuesto: $\varepsilon \le \underbrace{2^{-107}}_{\alpha,\ F_{p^2}} + \underbrace{2^{-100}}_{\beta,\ \text{plegado}} + \underbrace{2^{-(80+20)}}_{\text{consulta}+\text{grind}} \approx 2^{-100}$, con tres salvedades que se enuncian con franqueza: (i) el término de consulta (80 bits) usa la convención de *proximity gaps* [BSCIKS20] (2 bits/consulta), **conjetural**; la cota **incondicional provable** por decodificación única da ~47 bits en esa fase, cerrable con DEEP (trabajo futuro); (ii) la cifra corresponde a la **configuración de producción** (build *release*, grinding de 20 bits); (iii) el **techo del campo** ($\varepsilon_\alpha,\varepsilon_\beta$ en $F_{p^2}$) es **>100 bits de forma provable e incondicional** —es lo que el campo base de 64 bits no permitía (su techo caía a ~40 bits)—. Mediciones (portátil modesto, Rust puro, $F_{p^2}$, *blowup* 8, 40 consultas, grinding $2^{20}$):
>
> | Pasos de traza | Tamaño de prueba | Generar | **Verificar** |
> |---:|---:|---:|---:|
> | 16 | 132 KB | — | 6,0 ms |
> | 256 | 268 KB | — | 8,9 ms |
> | 4096 | 445 KB | — | **12,9 ms** |
>
> El resultado central es la **verificación sucinta**: al multiplicar el cómputo por **256×** (16→4096 pasos), el tiempo de verificación crece solo **~2,2×** (polilogarítmico), mientras el tamaño de prueba crece sub-linealmente. Es justo la propiedad que la L1 necesita: verificar un lote L2 grande con costo casi constante, sin curvas rotas por Shor. *(El tiempo de **generación** está dominado por el grinding —coste fijo $\sim 2^{20}$ hashes— y por la NTT del probador; no es la magnitud relevante para la L1.)* La aritmetización **completa** de la máquina de estado bancaria (el AIR del PoC es ilustrativo) y la incorporación de DEEP/out-of-domain quedan como trabajo futuro (Cap. 7); el **motor criptográfico post-cuántico**, que es lo que porta la afirmación de coherencia, está implementado, **endurecido a ~100 bits** y verificado por una batería de pruebas (incluida una adversarial que rechaza un probador con composición de bajo grado desligada de la traza).

> **Validación externa contundente.** La hoja de ruta de consenso de Ethereum ("Lean Consensus", antes *Beam Chain*) llega a la **misma conclusión**: reemplaza BLS por firmas hash-based (leanXMSS), que pesan 20–40× más y carecen de agregación nativa, y lo resuelve con **`leanVM`, un zkVM que comprime las firmas ~250× con agregación SNARK post-cuántica**; ethereum.org afirma explícitamente que *«los STARKs ya son resistentes a la cuántica»* y que los compromisos KZG deberán migrar a STARK/reticular. El principio de NEXUS —*el sistema de pruebas debe ser PQ*— es el mismo que adopta la frontera.

### 3.5.1 Una tensión de diseño honesta: Dilithium vs. STARK-friendliness

Conviene declarar una tensión técnica que demuestra dominio del problema. **Probar la verificación de una firma Dilithium dentro de un STARK es costoso** (operaciones reticulares, claves públicas grandes); de hecho, **Ethereum eligió firmas hash-based en parte porque son más STARK-friendly** que las reticulares, y **Solana eligió Falcon** (reticular pero de firma pequeña). La elección de NEXUS por **Dilithium** optimiza la **verificación directa** (L1, y la robustez/estandarización de la implementación) a costa de mayor fricción en la **agregación probada** (L2). No es un defecto, sino una **decisión consciente con un trade explícito**: NEXUS prioriza la robustez del primitivo y reconoce la agregación STARK de firmas reticulares como el reto de ingeniería a resolver. La divergencia **Ethereum (hash-based) / Solana (Falcon) / NEXUS (Dilithium)** evidencia que **no existe una respuesta única** — y que la elección debe justificarse, como aquí.

---

## 3.6 Modelo de cuenta: identidad estable vs. clave rotable

Un sistema que **rota** y **migra** claves (Cap. 5, cripto-agilidad) enfrenta un problema: si la dirección se deriva de la clave pública, rotar la clave **cambia la dirección/identidad**. NEXUS lo resuelve con **abstracción de verificación**:

$$\textbf{Cuenta} = (\ \text{id\_estable},\ \ \text{política\_de\_verificación},\ \ \text{epoch}\ ).$$

- La **id_estable** identifica la cuenta de forma permanente (no cambia con la clave).
- La **política_de_verificación** especifica el esquema de firma y la clave pública actuales; una transacción se valida ejecutando esta política.
- El **epoch** registra la versión de clave (rotación/migración).

Rotar o migrar de esquema actualiza la **política** y el **epoch**, **sin tocar la id_estable**. Un **Registro de Claves (Key Registry)** permite asociar claves post-cuánticas junto a las clásicas, habilitando **firmas híbridas** durante la transición y la **migración por cuenta**.

> **Validación externa.** Ethereum implementa este patrón: **EIP-7702 (smart EOAs, ya live)** permite a una cuenta de dirección estable delegar su lógica de verificación; **EIP-8141 ("signature agility", fork Hegota, H2-2026)** y un **Key Registry** permiten que cada cuenta migre a un esquema PQ de forma independiente, sin hard fork global. El modelo de cuenta de NEXUS adopta este enfoque validado, cerrando el problema identidad↔clave↔rotación↔dirección.

---

## 3.7 Disponibilidad de datos

La L1 debe garantizar que los datos del L2 (necesarios para reconstruir/auditar el estado) estén **disponibles**, sin almacenarlos permanentemente. *(Diseño de referencia; la DA —erasure coding y muestreo— no está implementada operativamente, sino especificada como modelo. Cf. §3.10 y Cap. 7.)* El diseño prevé:

- **Erasure coding real** (Reed-Solomon u otro código MDS) para redundancia con umbral de recuperación genuino (no duplicación de *chunks*).
- **Muestreo de disponibilidad (DAS)** entre **pares**: los nodos verifican la disponibilidad muestreando fragmentos distribuidos en la red, no consultando su propia memoria. La probabilidad de detección de retención es estadísticamente significativa solo si el muestreo es **remoto**.
- **Poda** de los datos tras una ventana (estilo *blob*), de modo que las firmas (50× mayores) **no se acumulan** indefinidamente en la L1.

> **Validación externa (ya en producción).** Ethereum activó **Fusaka/PeerDAS en mainnet el 3-dic-2025**: muestreo de disponibilidad que reduce ~85 % la descarga de los validadores, con blobs efímeros y podables. NEXUS modela su DA sobre este diseño desplegado. La **ZK Compression** de Solana ofrece además un mecanismo para comprimir el estado (claves públicas grandes) con pruebas de validez. Esto corrige y sustituye el "DAS" del prototipo original (que muestreaba su propia RAM).

---

## 3.8 Secuenciación e incentivos

El **Nexus Sequencer** ordena las transacciones del L2. Un secuenciador único concentra poder de censura y de extracción de valor (MEV). El diseño contempla dos mitigaciones, ambas con respaldo en la frontera:

- **Separación proponente/constructor (PBS):** separar *quién ordena* de *quién construye* el bloque, para limitar el MEV — el enfoque del **PBS enshrined (ePBS)** de Ethereum.
- **Secuenciadores concurrentes:** múltiples productores concurrentes, como los **Multiple Concurrent Leaders (MCL)** de Solana, que reducen el poder de un único líder.

**Modelo de incentivos.** El comportamiento del secuenciador se modela con teoría de juegos: se **argumenta** que, bajo un modelo de pagos con *stake* y *slashing*, la estrategia honesta sería un **equilibrio de Nash** (la deshonestidad conduce a la pérdida del *stake*) — análisis de diseño, no resultado formalmente probado. Con secuenciación **concurrente**, el juego pasa de un único jugador a **N jugadores**, de modo que la censura/MEV requeriría la **colusión de la mayoría** — un argumento de robustez más fuerte que el del secuenciador único. *(El mecanismo operativo de slashing es diseño de referencia; su implementación es trabajo futuro.)*

---

## 3.9 Finalidad

La banca exige **finalidad rápida e irreversible** para la liquidación. El **Finality Gadget** de la Anchor Layer se especifica para finalizar un bloque cuando el peso de voto (ponderado por *stake*) cruza el umbral de 2/3, con verificación de las firmas de voto y enlace de ascendencia entre bloques finalizados. *(Diseño de referencia; su implementación operativa es trabajo futuro, §3.10.)*

> **Validación externa y diseño a contrastar.** Solana **Alpenglow** (Votor + Rotor; testnet may-2026, mainnet ~finales 2026) reduce la finalidad de 12,8 s a **100–150 ms**: **Votor** finaliza en **una ronda** con ≥80 % del *stake* en línea (~100 ms) y en dos rondas al 60 % (~150 ms). Ethereum persigue **finalidad de un solo paso (SSF)** y ~4 s en Lean Consensus. NEXUS adopta como requisito una **finalidad determinista rápida** y contrasta su gadget con el diseño de Votor (quórum por *stake*, finalidad en 1–2 rondas), coherente con las correcciones del consenso (quórum ponderado por *stake* + verificación de votos).

---

## 3.10 Síntesis y supuesto de consenso

El diseño dual-chain de NEXUS responde, pieza por pieza, al problema que la PQC plantea:

1. La PQC introduce un sobrecosto de **datos** (~50× firma, ~20× throughput en L1) — §3.3.
2. El **rollup de validez** amortiza ese costo a $\sim d$ (la diferencia de estado clásica), eliminando las firmas de la L1 — §3.4.
3. La coherencia PQ exige un **verificador STARK**, no Groth16 — §3.5; con la tensión Dilithium-vs-STARK declarada — §3.5.1.
4. La **abstracción de cuenta + Key Registry** resuelve identidad-vs-clave y habilita migración — §3.6.
5. La **DA estilo PeerDAS** y la **secuenciación con incentivos** y la **finalidad rápida** completan la arquitectura — §3.7–3.9.

> **Supuesto explícito (para que las afirmaciones de seguridad estén bien formadas).** La integridad del libro mayor depende, además de la in-falsificabilidad de las firmas (Cap. 6), de la **seguridad del consenso**. En NEXUS el consenso BFT operativo es **diseño de referencia**, no implementación; por tanto, la garantía del sistema se enuncia condicionalmente: *in-falsificabilidad a nivel de transacción bajo el supuesto de consenso honesto-mayoritario*. La realización completa del consenso, la DA y el verificador STARK es trabajo futuro (Cap. 7).

Con ello, el **Objetivo 1 queda atendido**: la arquitectura dual-chain está especificada como modelo de referencia, con su rol —amortizar el sobrecosto post-cuántico manteniendo coherencia PQ— justificado cuantitativamente y validado por la convergencia de la industria.

---

## Referencias del capítulo

> *Índice local del capítulo; la **Bibliografía** consolidada al final del documento reúne todas las obras bajo clave única.*

- [Buterin21] V. Buterin. *An Incomplete Guide to Rollups*. 2021.
- Ethereum Foundation. *Fusaka Mainnet Announcement* (PeerDAS, EIP-7594). Nov. 2025. · ethereum.org/roadmap (Account abstraction EIP-7702; Quantum resistance / Lean Consensus, EIP-8141).
- Anza. *Alpenglow* (Votor/Rotor). 2025–2026. · Solana. *Quantum Readiness* (Falcon; Winternitz Vault). 2026.
- *(Análisis de overhead: documento companion `Analisis-Overhead-PQC-DualChain`; validación de fuentes: `Ideas-Ethereum-Solana-para-NEXUS`.)*


# Capítulo 4 — Núcleo Criptográfico Post-Cuántico

### (Objetivo 2 · la "solución" del arco)

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

| Nivel | Seguridad NIST | Clave pública | Firma | Uso recomendado |
|---|:---:|---:|---:|---|
| Dilithium2 | 2 | 1312 B | 2420 B | operaciones de alto volumen |
| **Dilithium3** | **3** | **1952 B** | **3309 B** | **por defecto (banca)** |
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
$$\xi \xleftarrow{\ \text{KDF}\ } \text{material de la fuente de entropía (Cap. 5)}, \qquad (pk, sk) = \mathsf{ML\text{-}DSA.KeyGen}(\xi).$$
La semilla $\xi$ se deriva mediante un **KDF con separación de dominio** (SHA3/SHAKE) a partir del material de la fuente monitoreada (Cap. 5). Esto reemplaza por completo la derivación biométrica del alcance original (eliminada en v2): el determinismo se obtiene de una **semilla de alta entropía**, no de un biométrico.

### 4.5.2 Implementación (verificada)

`DilithiumKeypair::from_seed(ξ, esquema)` invoca la `KeyGen` semillada del crate `fips204` (`ml_dsa_N::KG::keygen_from_seed(ξ)`), de modo que **la misma semilla produce siempre el mismo par de claves**. El test `test_deterministic_from_seed` verifica que dos derivaciones con la misma semilla coinciden, que semillas distintas difieren, y que la clave derivada firma/verifica. **El determinismo prometido por el Objetivo 2 está implementado y verificado.**

> **Nota.** La migración de `pqcrypto-dilithium` (que no exponía `KeyGen` semillada y usaba randomness del SO) a `fips204` cerró esta brecha y, de paso, alineó el código con **FIPS 204 exacto**, eliminando la distinción round-3 / ML-DSA.

---

## 4.6 Elección del esquema de firma post-cuántica

La elección de Dilithium debe justificarse explícitamente, porque el sobrecosto de ~50× (Cap. 3) es **específico de Dilithium** y existen alternativas con perfiles distintos. La estandarización NIST y las decisiones de las cadenas líderes ofrecen anclas reales.

**Tabla 4.1 — Esquemas de firma post-cuántica.**

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


# Capítulo 5 — Gestión Activa del Ciclo de Vida de Claves

### (Objetivo 3 · la capa operativa de seguridad)

> **Rol en el arco de la tesis.** Este capítulo desarrolla la **lógica de seguridad activa** que rodea al primitivo de firma (Cap. 4): cómo se obtiene aleatoriedad de calidad, cómo se deriva la semilla de la clave, y cómo se rota la clave para limitar el daño ante un compromiso. Es la capa **operativa** que da *resiliencia* al sistema; reformula sobre bases criptográficas correctas el monitoreo de entropía del alcance original.

---

## 5.1 Introducción

Una clave de firma post-cuántica no vive aislada: nace de una fuente de aleatoriedad, se deriva de una semilla y, a lo largo de su uso, debe **rotarse** para acotar el impacto de un eventual compromiso. El Objetivo 3 modela e implementa esta **gestión activa del ciclo de vida**, definida por tres elementos:

1. una **fuente de entropía monitoreada**, evaluada por su **min-entropía** y vigilada por **pruebas de salud en línea** (NIST SP 800-90B), §5.2–5.3;
2. la **derivación de claves** mediante un KDF con separación de dominio, §5.4 (conecta con el Cap. 4, §4.5);
3. la **rotación con secrecia hacia adelante**, disparada por política, con registro auditable, §5.5;
4. la **residencia efímera de la clave en memoria**: en reposo solo persiste la semilla, y la clave expandida se regenera justo a tiempo para cada firma y se zeroiza, §5.6.

Estos elementos forman una **tubería única** (§5.7) que une la fuente de aleatoriedad con la clave Dilithium y su rotación. El capítulo corrige explícitamente el enfoque del prototipo original, que usaba la **entropía de Shannon de la semilla** como métrica de seguridad —un planteamiento erróneo que se explica y reemplaza en §5.2—.

---

## 5.2 La métrica correcta: min-entropía de la fuente

El prototipo original disparaba la rotación cuando la **entropía de Shannon** de la semilla de 32 bytes caía por debajo de 7,5 bits/byte. Este planteamiento es **incorrecto por dos razones**:

1. **La entropía de Shannon de una muestra no mide el secreto de una clave.** La salida de un CSPRNG luce con entropía de Shannon máxima ($\approx 8$ bits/byte) **independientemente** de si la semilla-fuente es secreta o predecible. Lo que importa para una clave es la **imprevisibilidad de la fuente**, no la uniformidad estadística de una muestra.
2. **Es degenerada para 32 bytes.** Con solo 32 muestras sobre 256 valores posibles, la entropía de Shannon empírica máxima alcanzable es $\log_2 32 = 5$ bits/byte, **nunca 7,5**. El umbral era inalcanzable y la prueba habría fallado.

**La métrica pertinente es la min-entropía de la fuente:**
$$H_\infty(X) = -\log_2 \Big(\max_x \Pr[X=x]\Big).$$
La min-entropía captura la imprevisibilidad en el **peor caso** (el valor más probable), que es la medida conservadora apropiada para material criptográfico. La cantidad de bits de seguridad que aporta un bloque de datos de la fuente es $\approx H_\infty \times (\text{longitud})$.

> **NIST SP 800-90B** estandariza precisamente la **estimación de min-entropía** de fuentes de entropía (con estimadores para los casos IID y no-IID, p. ej. el de valor más común, el de Markov, etc.). NEXUS adopta este marco: la fuente se caracteriza por su min-entropía estimada, no por la entropía de Shannon de una muestra.

---

## 5.3 Monitoreo de salud en línea (NIST SP 800-90B)

"Monitoreo activo de entropía", en sentido riguroso, significa **vigilar la salud del generador en tiempo de ejecución** para detectar su degradación. NIST SP 800-90B define dos **pruebas de salud continuas** que NEXUS adopta:

**1. Repetition Count Test (RCT).** Detecta un generador "atascado" (que emite el mismo valor repetidamente). Dado un nivel de min-entropía $H$ y una probabilidad de falso positivo $\alpha$, define un umbral
$$C = 1 + \left\lceil \frac{-\log_2 \alpha}{H} \right\rceil.$$
Si un mismo valor aparece $\ge C$ veces **consecutivas**, la prueba **falla** (la fuente se considera comprometida).

**2. Adaptive Proportion Test (APT).** Detecta una pérdida gradual de entropía. Sobre una ventana de $W$ muestras (típicamente $W=512$ para fuentes binarias, $1024$ para no binarias), cuenta cuántas veces **reaparece** la primera muestra de la ventana; si el conteo excede un umbral derivado de $H$ y $\alpha$, la prueba **falla**.

Ambas pruebas corren **continuamente** sobre el flujo de la fuente. Su fallo es el disparador de salud que **bloquea la derivación de claves** y fuerza el *reseeding*/rotación (§5.5). Este es el mecanismo que sustituye, de forma fundamentada, al disparador "Shannon < 7,5" del prototipo.

---

## 5.4 Derivación de claves por KDF

Entre la fuente de entropía y la clave Dilithium se interpone una **función de derivación de claves (KDF) con separación de dominio**, que cumple dos funciones: (i) "condensar" el material de la fuente en una semilla uniforme de longitud fija, y (ii) **separar dominios** para que claves derivadas en contextos distintos (firma, identificación, época) sean independientes.

NEXUS emplea **HKDF** (RFC 5869, paradigma *Extract-then-Expand*) o, equivalentemente, **SHAKE256** como *XOF* con un prefijo de dominio:
$$\xi = \mathrm{KDF}\big(\underbrace{\text{material de la fuente}}_{\text{alta min-entropía}},\ \underbrace{\text{sal}}_{}\,,\ \underbrace{\text{contexto}}_{\text{dominio} \,\|\, \text{epoch}}\big),$$
y la semilla $\xi$ alimenta la `KeyGen` determinística de ML-DSA (Cap. 4, §4.5). La separación de dominio (parámetro `info` de HKDF / prefijo SHAKE) garantiza que rotar la *epoch* produzca una semilla —y por tanto una clave— independiente de las anteriores.

---

## 5.5 Rotación con secrecia hacia adelante

La rotación periódica de la clave **acota el daño** de un compromiso: una clave comprometida solo afecta a su época de uso, no a las pasadas ni futuras.

**Disparadores de rotación (por política).** La rotación se activa cuando se cumple **cualquiera** de:
- **uso** superior a un umbral (p. ej. 100.000 derivaciones),
- **antigüedad** superior a un máximo (p. ej. 24 horas),
- **fallo de las pruebas de salud** (RCT/APT, §5.3) de la fuente.

**Mezcla con secrecia hacia adelante.** La nueva semilla se deriva mezclando la anterior con material fresco mediante un hash de un solo sentido:
$$\xi_{e+1} = H\big(\text{dominio} \,\|\, \xi_{e} \,\|\, \text{material fresco} \,\|\, e\big), \qquad \text{y se borra } \xi_{e}.$$
Como $H$ es de un solo sentido y la semilla anterior se **zeroiza**, el compromiso de $\xi_{e+1}$ **no** permite recuperar $\xi_{e}$ ni las claves de épocas pasadas: esto es la **secrecia hacia adelante**.

**Bloqueo ante degradación.** Si las pruebas de salud fallan, la derivación de claves se **bloquea** (no se emiten claves desde una fuente degradada) hasta que la fuente se restablezca o se realice un *reseeding* con una fuente sana.

**Auditoría.** Cada rotación se registra en un **log auditable** (época, motivo, marca de tiempo), requisito propio del contexto bancario (trazabilidad y cumplimiento). El identificador de cuenta permanece estable a través de las rotaciones (Cap. 3, §3.6: la rotación actualiza la *política de verificación* y la *epoch*, no la dirección).

---

## 5.6 Residencia efímera de la clave en memoria

Los controles anteriores protegen la clave en su **origen** (fuente, KDF) y en su **ciclo** (rotación); falta protegerla en su **residencia**: la clave privada expandida de ML-DSA-65 es un objeto de 4.032 bytes cuya permanencia en RAM o disco la expone a volcados de memoria, *core dumps*, depuradores e introspección de hipervisor. La amenaza es concreta: la extracción de claves reticulares desde volcados de RAM está demostrada (ataques *cold-boot* sobre claves module-LWE [ADP18]), y el compromiso de la clave de firma MSA de Microsoft (Storm-0558, 2023) —cuya hipótesis principal es la exposición en un *crash dump*— ilustra el impacto de una clave de firma de alto valor residente en la memoria de un servidor.

**Base normativa: la semilla como formato de custodia.** FIPS 204 §3.6.3 permite almacenar únicamente la semilla $\xi$ de 32 bytes y re-expandirla con `ML-DSA.KeyGen_internal` [NIST24], y el RFC 9881 declara la semilla el formato **recomendado** de clave privada ML-DSA [RFC9881]; OpenSSL 3.5 la retiene y regenera por defecto al importar. NEXUS adopta esta práctica —la `KeyGen` determinística de §5.4 y Cap. 4 §4.5 es exactamente esa re-expansión— y la extiende con una **política** que el estado del arte no prescribe:

**Política de residencia efímera (KeyGen por firma).** En reposo, el sistema solo conserva $\xi$ (32 B, sellable en TPM/TEE). Ante cada solicitud de firma, el firmador (i) expande $\xi \to (pk, sk)$, (ii) firma, y (iii) **zeroiza** de inmediato los vectores expandidos. La clave de ~4 KB no existe en ningún soporte persistente y solo existe en RAM durante la operación.

**Métrica de ventana de exposición.** Se propone cuantificar la superficie de riesgo en memoria como el producto $W = \text{bytes expuestos} \times \Delta t$. Bajo la política, la exposición **permanente** pasa de 4.032 B (clave expandida residente) a 32 B —una reducción de 126× (187× respecto de la representación en memoria del prototipo, 5.993 B)—, y la exposición **transitoria** es una ráfaga de ~1,2 ms por firma (medianas Criterion del Cap. 6 §6.6: KeyGen 413 µs + firma 790 µs). En una medición dedicada de la política completa (KeyGen + firma + zeroización; 1.000 iteraciones, modo *release*), la latencia media de firma pasó de 1,02 ms a 1,77 ms (**+0,75 ms**), con la verificación inalterada: un sobrecosto despreciable frente a los SLA bancarios típicos ($10^2$–$10^3$ ms).

**Posicionamiento frente al estado del arte** (revisión con fuentes verificadas, jul. 2026). La re-expansión sobre la marcha existe en microcontroladores, motivada por la **escasez de RAM**, no por seguridad [BRS22]; el borrador de consideraciones de seguridad de ML-DSA recomienda incluso **cachear** la clave expandida mientras duren las operaciones de firma [Connolly26]; y no se localiza formalización previa de la métrica $W$ ni benchmark publicado del trade-off KeyGen-por-firma (lo más cercano mide tiempos de residencia de claves en RAM tras terminar el proceso, sin PQC [Sawa25]). Ambos elementos —la política y su métrica— son, hasta donde alcanza la revisión, aporte de este trabajo.

**Ingeniería de memoria.** La política se apoya en controles estándar: borrado resistente a *dead-store elimination* (`zeroize`), bloqueo de páginas para impedir su paso al *swap* (`mlock`/`VirtualLock`), exclusión de la memoria criptográfica de los volcados (`MADV_DONTDUMP`) y, en entornos de alta amenaza, ejecución en enclaves cifrados (TEE).

> **Nota de cumplimiento (FIPS).** NIST confirma que almacenar y re-expandir $\xi$ es conforme a FIPS 204, pero el perfil vigente **no permite derivar $\xi$ de otra semilla mediante un KDF** (pqc-forum, oct. 2024). La cadena de épocas de §5.5 debe por tanto leerse como endurecimiento *forward-secure* del material de la aplicación: en un despliegue con certificación FIPS estricta, cada $\xi_e$ se generaría directamente del RBG aprobado (con la mezcla de §5.5 declarada fuera del perfil, o sustituida por *reseeding* del DRBG).

---

## 5.7 La tubería unificada

Los elementos anteriores forman un único ciclo de vida, que unifica los Objetivos 2 y 3:

```
   ┌──────────────────┐   pruebas de salud (RCT/APT, SP 800-90B)
   │ FUENTE DE        │──────────────┐ falla → BLOQUEO + reseed
   │ ENTROPÍA         │              ▼
   │ (min-entropía)   │        ┌───────────┐
   └────────┬─────────┘        │  SALUD OK │
            │ material         └─────┬─────┘
            ▼                        │
   ┌──────────────────┐             ▼
   │  KDF (SHAKE256/   │   separación de dominio + epoch
   │  HKDF) → semilla ξ│
   └────────┬─────────┘
            ▼
   ┌──────────────────┐
   │ ML-DSA.KeyGen(ξ) │   (Cap. 4, §4.5) — determinística
   │ → (pk, sk)       │
   └────────┬─────────┘
            ▼
   ┌──────────────────┐   disparadores: uso / edad / fallo de salud
   │ ROTACIÓN forward-│──────────────┐
   │ secure + auditoría│             │ ξ_{e+1}=H(dom‖ξ_e‖fresco‖e), zeroiza ξ_e
   └──────────────────┘◄─────────────┘  (identidad de cuenta estable)
```

Esta tubería convierte dos objetivos antes inconexos (la firma del Obj. 2 y la entropía del Obj. 3) en **una sola historia coherente de gestión de claves**: fuente sana → semilla → clave → rotación, con secrecia hacia adelante y trazabilidad.

---

## 5.8 Estado de implementación y limitaciones

| Componente | Estado |
|---|---|
| Rotación por política (uso/edad/**fallo de salud**) + mezcla forward-secure + auditoría | **Implementado** |
| Métrica de calidad de la fuente (**min-entropía**, ya no Shannon-de-la-semilla) | **Implementado** (§5.2) |
| Pruebas de salud en línea **NIST SP 800-90B (RCT/APT)** + bloqueo ante degradación | **Implementado** en `entropy.rs` (con tests) |
| KDF determinístico fuente→semilla (SHA3, dominio separado) | **Implementado** (en `SentinelSeed`) |
| `KeyGen` reproducible de Dilithium desde semilla | **Implementado** (migrado a `fips204`; test `test_deterministic_from_seed`, Cap. 4 §4.5) |
| Política de residencia efímera (KeyGen JIT por firma + `zeroize`) | **Medida empíricamente** (§5.6; benchmark dedicado 2026-07-31); su integración como política configurable del firmador es trabajo en curso |

> **Estado (Fase B completada y verificada con tests).** La reformulación del Objetivo 3 está **implementada**: la métrica es la min-entropía de la fuente; las pruebas de salud SP 800-90B (RCT/APT) **bloquean** la derivación ante degradación; la rotación forward-secure añade el disparador por fallo de salud. Y la `KeyGen` reproducible de Dilithium desde semilla quedó **implementada** al migrar a `fips204` (Cap. 4 §4.5), cerrando el componente determinístico del Objetivo 2.

---

## 5.9 Conclusiones del capítulo

Este capítulo desarrolló la gestión activa del ciclo de vida de claves (Objetivo 3):

1. Reemplazó la **métrica errónea** (entropía de Shannon de la semilla) por la **min-entropía de la fuente**, criptográficamente pertinente y conforme a NIST SP 800-90B.
2. Definió el **monitoreo de salud en línea** (RCT/APT) como el verdadero "monitoreo activo de entropía", con **bloqueo** de la derivación ante degradación.
3. Especificó la **derivación por KDF** que une la fuente con la `KeyGen` determinística (Cap. 4), y la **rotación con secrecia hacia adelante** disparada por política, con auditoría e identidad de cuenta estable.
4. Unificó los Objetivos 2 y 3 en una **tubería única** de gestión de claves.
5. Propuso y midió la **política de residencia efímera** (§5.6): en reposo solo la semilla de 32 B (formato hoy recomendado por el RFC 9881); la clave expandida vive ~1,2 ms por firma (sobrecosto +0,75 ms), y la métrica de ventana de exposición $W = \text{bytes}\times\Delta t$ cuantifica la reducción — política y métrica sin formalización previa localizada en la literatura.

Con ello, el **Objetivo 3 queda atendido** sobre bases rigurosas, eliminando la fragilidad conceptual del enfoque original.

---

## Referencias del capítulo

> *Índice local del capítulo; la **Bibliografía** consolidada al final del documento reúne todas las obras bajo clave única.*

- M. S. Turan et al. *NIST SP 800-90B: Recommendation for the Entropy Sources Used for Random Bit Generation*. NIST, 2018.
- NIST. *SP 800-90A/C: Deterministic Random Bit Generators / RBG Constructions*.
- H. Krawczyk. *Cryptographic Extraction and Key Derivation: The HKDF Scheme*. CRYPTO 2010 (RFC 5869).
- NIST. *SP 800-108: Recommendation for Key Derivation Using Pseudorandom Functions*.
- NIST. *FIPS 204: ML-DSA* (KeyGen determinística desde semilla; §3.6.3 permite almacenar solo la semilla). 2024.
- [RFC9881] J. Massimo, P. Kampanakis, S. Turner, B. Westerbaan. *RFC 9881: Internet X.509 PKI — Algorithm Identifiers for ML-DSA* (la semilla como formato recomendado de clave privada). IETF, 2025.
- [Connolly26] D. Connolly. *ML-DSA Security Considerations*. draft-connolly-cfrg-ml-dsa-security-considerations, IETF (borrador), 2026.
- [BRS22] J. W. Bos, J. Renes, A. Sprenkels. *Dilithium for Memory Constrained Devices*. AFRICACRYPT 2022.
- [ADP18] M. R. Albrecht, A. Deo, K. G. Paterson. *Cold Boot Attacks on Ring and Module LWE Keys Under the NTT*. IACR TCHES, 2018.
- [Sawa25] Y. Sawa et al. *Analysis of Encryption Key Zeroization from a System-Wide Perspective*. ACSAC 2025.


# Capítulo 6 — Validación Formal de la Seguridad

### (Desarrollo del Objetivo 4 · versión redactada del esqueleto `Cap4-Validacion-Formal-Esqueleto.md`)

> **Mapa.** Este capítulo corresponde al **Objetivo 4** de la propuesta y al **Capítulo 6** de la estructura del Plan Maestro. Desarrolla la validación formal en dos brazos complementarios: una **prueba de dureza post-cuántica** (§6.4) y un **análisis de complejidad computacional** (§6.5), cerrados con una **validación empírica** (§6.6). Las cifras y términos siguen las *invariantes de consistencia* del Plan Maestro.

---

## 6.1 Introducción y alcance

La seguridad de NEXUS descansa, en última instancia, sobre una única afirmación criptográfica: que **las firmas que autorizan las transacciones no pueden ser falsificadas por un adversario, ni siquiera por uno equipado con un computador cuántico**. Este capítulo valida formalmente esa afirmación para el esquema de firma adoptado, CRYSTALS-Dilithium, y caracteriza el costo computacional que dicha seguridad impone.

Por **validación formal** entendemos un procedimiento de cuatro pasos, que estructura todo el capítulo:

1. **Fijar un modelo de seguridad** preciso: qué es un adversario, qué significa "romper" el esquema y bajo qué capacidades (§6.3).
2. **Reducir** la seguridad del esquema a un problema computacional bien estudiado, de modo que romper la firma implique resolver dicho problema (§6.4.1–6.4.2).
3. **Argumentar la dureza cuántica** de ese problema, mostrando por qué los algoritmos cuánticos conocidos —en particular el de Shor— no lo resuelven eficientemente (§6.4.3).
4. **Acotar el costo computacional** de las operaciones del esquema mediante notación asintótica, y validarlo empíricamente (§6.5–6.6).

**Alcance.** Esta validación cubre la **in-forjabilidad** de la firma Dilithium en el modelo de caja negra (el adversario interactúa con el esquema sin acceso a su implementación física). Quedan **fuera del alcance**, y se declaran explícitamente en §6.7: la seguridad de implementación (canales laterales, ataques por fallos), la seguridad del protocolo de consenso (de la que depende la integridad del libro mayor pero no la del primitivo), y los componentes aún no implementados (la capa de pruebas de conocimiento cero, la confidencialidad post-cuántica vía KEM).

**Una aclaración metodológica importante.** No se re-demuestran los teoremas fundacionales de la criptografía reticular (las reducciones de Regev o de Langlois–Stehlé, la prueba de seguridad original de Dilithium). El aporte de este capítulo no es re-probarlos, sino **enunciarlos con precisión, citarlos e instanciarlos** para los parámetros concretos de NEXUS, **ensamblar** la cadena completa de reducciones, y **particularizar** el análisis de complejidad y de *overhead* a la arquitectura dual. Este es el nivel de rigor apropiado y suficiente para un trabajo de grado.

---

## 6.2 Preliminares matemáticos

### 6.2.1 Retículos y problemas reticulares

**Definición 6.1 (Retículo).** Dados $m$ vectores linealmente independientes $\mathbf{b}_1,\dots,\mathbf{b}_m \in \mathbb{R}^d$, el *retículo* que generan es el conjunto de sus combinaciones enteras:
$$\Lambda = \mathcal{L}(\mathbf{B}) = \Big\{ \textstyle\sum_{i=1}^{m} z_i\,\mathbf{b}_i : z_i \in \mathbb{Z} \Big\}.$$
La matriz $\mathbf{B}=[\mathbf{b}_1\,|\cdots|\,\mathbf{b}_m]$ es una *base*. Se denota $\lambda_1(\Lambda)$ la longitud (euclídea) del vector no nulo más corto del retículo.

Sobre los retículos se definen los problemas computacionales cuya dureza fundamenta la criptografía post-cuántica. Para un factor de aproximación $\gamma \ge 1$:

**Definición 6.2 (Problemas reticulares aproximados).**
- *$\gamma$-SVP (Shortest Vector Problem):* hallar $\mathbf{v}\in\Lambda\setminus\{\mathbf 0\}$ con $\|\mathbf v\| \le \gamma\,\lambda_1(\Lambda)$.
- *$\gamma$-SIVP (Shortest Independent Vectors Problem):* hallar $n$ vectores **linealmente independientes** de $\Lambda$, todos de longitud $\le \gamma\,\lambda_n(\Lambda)$.
- *$\gamma$-GapSVP:* problema de decisión asociado a $\gamma$-SVP.

Conviene subrayar una distinción que será relevante en §6.4.2: **SVP pide un único vector corto, mientras que SIVP pide $n$ vectores cortos independientes**; son problemas distintos, y el que aparece en las reducciones de Dilithium es **SIVP** (en su versión sobre módulos). Para factores $\gamma$ polinómicos en la dimensión, $\gamma$-SVP y $\gamma$-SIVP se conjeturan **difíciles tanto clásica como cuánticamente** [Pei16], y constituyen el cimiento de seguridad de toda la familia reticular.

### 6.2.2 Anillos ciclotómicos y módulos

Dilithium no opera sobre retículos generales sino sobre **retículos de módulo**, lo que reduce drásticamente el tamaño de las claves. Sea $n=256$ (una potencia de dos) y $q = 8\,380\,417 = 2^{23}-2^{13}+1$, un número **primo**. Se define el anillo de polinomios y su versión modular:
$$R = \mathbb{Z}[X]/(X^{n}+1), \qquad R_q = \mathbb{Z}_q[X]/(X^{n}+1).$$
Los elementos de $R_q$ son polinomios de grado $<n$ con coeficientes en $\mathbb{Z}_q$. La elección de $q$ no es arbitraria: satisface
$$q \equiv 1 \pmod{2n}, \qquad\text{en efecto}\quad 8\,380\,417 = 512\cdot 16\,368 + 1,\ \text{con } 2n=512,$$
de modo que $\mathbb{Z}_q$ contiene una raíz $2n$-ésima primitiva de la unidad. Esta propiedad habilita la **Transformada Teórica de Números (NTT)**, que permite multiplicar en $R_q$ en tiempo $O(n\log n)$ (§6.5.1) y es la razón de la eficiencia del esquema.

Un **módulo** de rango $\ell$ sobre $R_q$ es $R_q^{\ell}$; las claves de Dilithium viven en módulos $R_q^{k}$, $R_q^{\ell}$ y en matrices $\mathbf{A}\in R_q^{k\times\ell}$.

**Normas.** Para $w=\sum_i w_i X^i \in R_q$ con coeficientes representados de forma centrada en $(-q/2, q/2]$, se definen $\|w\|_\infty = \max_i |w_i|$ y $\|w\|_2 = (\sum_i w_i^2)^{1/2}$, y se extienden coeficiente a coeficiente a vectores de $R_q^k$. El conjunto de "polinomios pequeños" acotados por $\eta$ es $S_\eta = \{w\in R : \|w\|_\infty \le \eta\}$.

### 6.2.3 Module-LWE, Module-SIS y SelfTargetMSIS

**Definición 6.3 (Module-LWE decisional, $\mathrm{MLWE}_{k,\ell,\eta}$).** Sean $\mathbf{s}\in S_\eta^{\ell}$ (secreto) y $\mathbf{e}\in S_\eta^{k}$ (error) con coeficientes pequeños, y $\mathbf{A}\xleftarrow{\$} R_q^{k\times\ell}$ uniforme. El problema pide distinguir, con ventaja no despreciable, la distribución
$$\big(\mathbf{A},\ \mathbf{A}\mathbf{s}+\mathbf{e}\big) \qquad\text{de}\qquad \big(\mathbf{A},\ \mathbf{u}\big),\quad \mathbf{u}\xleftarrow{\$} R_q^{k}.$$
La versión de **búsqueda** pide recuperar $\mathbf{s}$ a partir de $(\mathbf{A}, \mathbf{A}\mathbf{s}+\mathbf{e})$.

**Definición 6.4 (Module-SIS, $\mathrm{MSIS}_{k,\ell,\beta}$).** Dada $\mathbf{A}\xleftarrow{\$} R_q^{k\times\ell}$ y una cota $\beta$, hallar un vector $\mathbf{z}\in R_q^{\ell}\setminus\{\mathbf 0\}$ tal que
$$\mathbf{A}\mathbf{z} = \mathbf{0} \pmod q \qquad\text{y}\qquad \|\mathbf{z}\| \le \beta.$$

**Definición 6.5 (SelfTargetMSIS).** Variante empleada en la prueba de Dilithium en el (Q)ROM. Dada $\mathbf{A}$ y una función de *hash* $H$ modelada como oráculo aleatorio, hallar un mensaje $\mu$ y un vector corto $\mathbf{y}$ tales que el reto $c = H\big([\,\mathbf I\,|\,\mathbf A\,]\,\mathbf{y} \,\|\, \mu\big)$ coincida con el bloque correspondiente de $\mathbf{y}$, con $\|\mathbf y\|_\infty$ acotada. La particularidad —crucial en §6.4.1— es que el reto va **embebido** en la instancia: **una falsificación válida es, por construcción, una solución directa de SelfTargetMSIS**.

**Parámetros de NEXUS.** La siguiente tabla fija los conjuntos de parámetros, conforme a **FIPS 204 / ML-DSA** [NIST24] (la parametrización que implementa el prototipo mediante el crate `fips204`):

| Parámetro | Dilithium2 | Dilithium3 | Dilithium5 |
|---|:---:|:---:|:---:|
| $(k,\ell)$ — dimensiones de $\mathbf A$ | $(4,4)$ | $(6,5)$ | $(8,7)$ |
| $\eta$ — rango del secreto | $2$ | $4$ | $2$ |
| $n,\ q$ | \multicolumn{3}{c}{$256,\ \ 8\,380\,417$} |
| Nivel de seguridad NIST | 2 | 3 | 5 |
| Clave pública (bytes) | 1312 | 1952 | 2592 |
| Firma (bytes) | 2420 | 3309 | 4627 |

> **Nota.** Los tamaños mostrados son los de **FIPS 204 / ML-DSA** (lo que implementa el prototipo vía el crate `fips204`, puro Rust). Las claves secretas son 2560/4032/4896 B (D2/D3/D5).

---

## 6.3 Modelo de seguridad

### 6.3.1 El esquema de firma e instanciación con Dilithium

**Definición 6.6 (Esquema de firma).** Una terna de algoritmos $(\mathsf{KeyGen}, \mathsf{Sign}, \mathsf{Verify})$:
$$\mathsf{KeyGen}(1^\lambda)\to(pk,sk), \quad \mathsf{Sign}(sk,\mu)\to\sigma, \quad \mathsf{Verify}(pk,\mu,\sigma)\to\{0,1\},$$
con **corrección**: $\Pr[\mathsf{Verify}(pk,\mu,\mathsf{Sign}(sk,\mu))=1] \ge 1-\mathrm{negl}(\lambda)$.

**Instanciación (Dilithium).** La clave secreta es $sk=(\mathbf{s}_1,\mathbf{s}_2)$ con $\mathbf{s}_1\in S_\eta^\ell$, $\mathbf{s}_2\in S_\eta^k$; la clave pública es $pk=(\mathbf{A},\ \mathbf{t}=\mathbf{A}\mathbf{s}_1+\mathbf{s}_2)$, donde $\mathbf{A}$ se regenera de forma determinística a partir de una semilla pública de 256 bits (no se almacena). La firma sigue el paradigma **Fiat-Shamir with Aborts** —técnica introducida por Lyubashevsky en ASIACRYPT 2009 [Lyu09] e instanciada sobre retículos en EUROCRYPT 2012 [Lyu12]— mediante el bucle:

1. Muestrear un "compromiso" $\mathbf{y}\in S_{\gamma_1}^\ell$ y computar $\mathbf{w}=\mathbf{A}\mathbf{y}$.
2. Derivar el reto $c=H(\mu, \mathbf{w}_1)$, un polinomio con pocos $\pm1$.
3. Computar la respuesta $\mathbf{z}=\mathbf{y}+c\,\mathbf{s}_1$.
4. **Rechazo:** si $\mathbf z$ (o términos asociados) excede ciertas cotas que evitarían filtrar el secreto, **abortar y reintentar** desde (1).

La firma es $\sigma=(\mathbf{z},\mathbf{h},c)$, donde $\mathbf h$ es una "pista" (*hint*) de pocos bits. La verificación recomputa $\mathbf{w}'$ a partir de $\mathbf{z}$, $c$ y $\mathbf{t}$, y acepta si $c=H(\mu,\mathbf{w}'_1)$ y las normas de $\mathbf z$ están dentro de cotas. El paso de **rechazo** es esencial: garantiza que la distribución de $\mathbf z$ sea independiente del secreto (propiedad de simulabilidad, §6.4.1).

### 6.3.2 In-forjabilidad: EUF-CMA y sUF-CMA

**Definición 6.7 (Juego EUF-CMA).** Un adversario $\mathcal{A}$ recibe $pk$ y acceso a un oráculo de firma $\mathcal{O}_{\mathsf{Sign}}(\cdot)$. Produce un par $(\mu^*,\sigma^*)$ y **gana** si $\mathsf{Verify}(pk,\mu^*,\sigma^*)=1$ y $\mu^*$ nunca fue consultado al oráculo. Su ventaja es $\mathsf{Adv}^{\text{EUF-CMA}}_{\mathcal A}=\Pr[\mathcal A\text{ gana}]$. Un esquema es EUF-CMA seguro si esta ventaja es despreciable para todo $\mathcal A$ eficiente.

**In-forjabilidad fuerte (sUF-CMA).** Refuerza la condición de victoria: $\mathcal{A}$ gana si $(\mu^*,\sigma^*)$ es **nuevo** (incluso para un mensaje ya consultado, basta producir una **firma distinta**). Es la noción pertinente para una blockchain, donde una segunda firma válida sobre la misma transacción podría inducir problemas de maleabilidad e identificación.

### 6.3.3 El adversario cuántico: el QROM

Un adversario cuántico realista no solo ejecuta cómputo cuántico, sino que puede **consultar la función de hash en superposición**. El modelo apropiado es el **Quantum Random-Oracle Model (QROM)** [BDF+11], en el que el oráculo $H$ responde a consultas cuánticas $\sum_x \alpha_x\lvert x\rangle\lvert 0\rangle \mapsto \sum_x \alpha_x\lvert x\rangle\lvert H(x)\rangle$. Probar la seguridad en el QROM (y no solo en el ROM clásico) es indispensable porque las técnicas clásicas de reducción —en particular el rebobinado y el *forking*— **no se trasladan sin más al caso cuántico**: medir una superposición la colapsa, de modo que no se puede "rebobinar" un adversario cuántico arbitrariamente. La prueba de Dilithium en el QROM [KLS18] aborda precisamente esta dificultad.

---

## 6.4 Reducción de dureza post-cuántica

### 6.4.1 Teorema de seguridad de Dilithium

**Teorema 6.1 (Seguridad sUF-CMA de Dilithium — adaptado de [D+18, KLS18]).** *Si los problemas $\mathrm{MLWE}_{k,\ell,\eta}$, $\mathrm{SelfTargetMSIS}_{k,\ell+1}$ y $\mathrm{MSIS}_{k,\ell,\beta}$ (con los parámetros de §6.2.3) son difíciles para algoritmos cuánticos de tiempo polinómico, entonces Dilithium es fuertemente in-forjable (sUF-CMA) en el QROM. Concretamente, para todo adversario cuántico $\mathcal{A}$ existen adversarios $\mathcal{B},\mathcal{C},\mathcal{D}$ de tiempos comparables tales que*
$$\mathsf{Adv}^{\text{sUF-CMA}}_{\mathcal A} \ \le\ \mathsf{Adv}^{\mathrm{MLWE}}_{\mathcal B} \ +\ \mathsf{Adv}^{\mathrm{SelfTargetMSIS}}_{\mathcal C} \ +\ \mathsf{Adv}^{\mathrm{MSIS}}_{\mathcal D} \ +\ 2^{-254}.$$

La cota tiene **tres** términos de dureza, cada uno protegiendo contra un tipo de ataque distinto; el término $2^{-254}$ (colisiones del *hash*) se absorbe en $\mathrm{negl}(\lambda)$. Si solo se desea la noción estándar EUF-CMA, bastan los dos primeros términos.

**Demostración (secuencia de juegos).** Sea $\mathcal A$ un adversario sUF-CMA que realiza $q_s$ consultas de firma y $q_h$ consultas (cuánticas) al oráculo $H$. Construimos una secuencia de juegos $G_0,G_1,G_2$; sea $W_i$ el evento «$\mathcal A$ gana en $G_i$».

*Juego $G_0$ (real).* Es el juego sUF-CMA original (Def. 6.7, variante fuerte): $\mathcal A$ recibe $pk=(\mathbf A,\mathbf t)$ con $\mathbf t=\mathbf A\mathbf s_1+\mathbf s_2$; sus consultas de firma se responden con el firmante real (usando $sk$); $\mathcal A$ produce $(\mu^*,\sigma^*)$ y gana si la firma es válida y el par es nuevo. Por definición, $\mathsf{Adv}^{\text{sUF-CMA}}_{\mathcal A}=\Pr[W_0]$.

*Juego $G_1$ (firmas simuladas).* Idéntico a $G_0$, salvo que las consultas de firma se responden con el **simulador** $\mathsf{Sim}$ del Lema 6.1, que **no usa $\mathbf s_1$** y programa $H$. Por el Lema 6.1, cada firma simulada dista estadísticamente $\le\varepsilon_{\mathrm{zk}}$ de una real, de modo que
$$\lvert \Pr[W_0]-\Pr[W_1]\rvert \ \le\ q_s\cdot \varepsilon_{\mathrm{zk}}, \qquad \varepsilon_{\mathrm{zk}}=\mathrm{negl}(\lambda).$$

*Juego $G_2$ (clave pública uniforme).* Idéntico a $G_1$, salvo que en $\mathsf{KeyGen}$ se reemplaza $\mathbf t=\mathbf A\mathbf s_1+\mathbf s_2$ por $\mathbf t\xleftarrow{\$}R_q^k$ **uniforme**. Tras el cambio de $G_1$, el secreto $\mathbf s_1$ **ya no interviene en ninguna parte** del juego (las firmas las produce $\mathsf{Sim}$ a partir de $pk$); la única diferencia entre $G_1$ y $G_2$ es la distribución de $\mathbf t$, que es exactamente la de una instancia $\mathrm{MLWE}_{k,\ell,\eta}$ frente a uniforme. Un distinguidor entre ambos juegos es, pues, un distinguidor MLWE: existe $\mathcal B$ (de tiempo comparable a $\mathcal A$) con
$$\lvert \Pr[W_1]-\Pr[W_2]\rvert \ \le\ \mathsf{Adv}^{\mathrm{MLWE}}_{\mathcal B}.$$

*Cota de $G_2$.* En $G_2$ **ni la clave pública ni las firmas dependen de secreto alguno** (todo se genera a partir de valores uniformes/públicos). Por tanto, una falsificación válida no puede explotar información filtrada: debe codificar la solución de un problema reticular. Por el **Lema 6.2** (extracción), de una falsificación válida se obtiene (i) una solución de $\mathrm{SelfTargetMSIS}_{k,\ell+1}$ si $\mu^*$ es **nuevo**, o (ii) una solución de $\mathrm{MSIS}_{k,\ell}$ si $\mu^*$ fue consultado pero $\sigma^*$ es una **firma nueva** (caso de in-forjabilidad *fuerte*). Con los reductores $\mathcal C$ y $\mathcal D$ que ejecutan a $\mathcal A$ en $G_2$ y aplican el Lema 6.2,
$$\Pr[W_2] \ \le\ \mathsf{Adv}^{\mathrm{SelfTargetMSIS}}_{\mathcal C} + \mathsf{Adv}^{\mathrm{MSIS}}_{\mathcal D}.$$

*Combinación.* Sumando las tres desigualdades por la desigualdad triangular,
$$\Pr[W_0] \le \mathsf{Adv}^{\mathrm{MLWE}}_{\mathcal B} + \mathsf{Adv}^{\mathrm{SelfTargetMSIS}}_{\mathcal C} + \mathsf{Adv}^{\mathrm{MSIS}}_{\mathcal D} + q_s\,\varepsilon_{\mathrm{zk}}.$$
Por el Lema 6.1, $\varepsilon_{\mathrm{zk}}$ es del orden de $(q_h+q_s)/2^{\,\Omega(\lambda)}$, de modo que el término estadístico total es $\sim q_s(q_h+q_s)/2^{\,\Omega(\lambda)}$ (más la probabilidad de colisión del *hash*). **Bajo las cotas de consulta estándar del modelo** —$q_h,q_s$ acotadas polinómicamente (p. ej. $q_h,q_s\le 2^{64}$)— ese término queda dominado por $2^{-254}$, de donde se obtiene la cota del Teorema 6.1. $\qquad\blacksquare$

**Lema 6.1 (Simulación — Fiat-Shamir con Aborts [Lyu12]).** *Existe un simulador $\mathsf{Sim}$ de tiempo polinómico que, dado solo $pk=(\mathbf A,\mathbf t)$ (sin $\mathbf s_1,\mathbf s_2$) y con capacidad de programar $H$, produce firmas cuya distribución dista estadísticamente $\le \varepsilon_{\mathrm{zk}}=\mathrm{negl}(\lambda)$ de las firmas reales.*

*Demostración (idea).* $\mathsf{Sim}$ muestrea el reto $c$ de su distribución, muestrea $\mathbf z$ de la distribución que sigue una firma real **tras el rechazo** —una distribución sobre $S_{\gamma_1-\beta}^\ell$ que, por diseño del paso de rechazo, es **independiente de $\mathbf s_1$**—, define $\mathbf w := \mathbf A\mathbf z - c\,\mathbf t$ y programa $H(\mu,\mathbf w_1):=c$ (de modo que la ecuación de verificación se cumple por construcción). El **rechazo** del firmante real es exactamente lo que iguala la distribución de su $\mathbf z$ a esta distribución independiente del secreto (propiedad central de *Fiat-Shamir with Aborts*); la única pérdida $\varepsilon_{\mathrm{zk}}$ es la probabilidad de que $H$ ya estuviera definido en $(\mu,\mathbf w_1)$, acotada por $(q_h+q_s)/\lvert\text{dominio}\rvert$. $\qquad\square$

**Lema 6.2 (Extracción).** *De una falsificación válida $(\mu^*,\sigma^*=(\mathbf z^*,\mathbf h^*,c^*))$ en $G_2$ se extrae, en tiempo polinómico, (a) una solución de $\mathrm{SelfTargetMSIS}_{k,\ell+1}$ si $\mu^*$ es nuevo; o (b) un vector corto no nulo en el núcleo de la matriz de $\mathrm{MSIS}_{k,\ell}$ si $\mu^*$ fue consultado y $\sigma^*$ es nueva.*

*Demostración (idea).* **(a)** La validez impone $c^*=H(\mu^*,\mathbf w^*_1)$ con $\mathbf w^*=\mathbf A\mathbf z^*-c^*\mathbf t$ y $\|\mathbf z^*\|$ acotada. Por la definición de $\mathrm{SelfTargetMSIS}$ —en la que el reto va **embebido** en la instancia vía $H$ sobre la matriz $[\,\mathbf I\,|\,\mathbf A\,|\,\mathbf t\,]$—, el par $(\mu^*,\mathbf z^*)$ **es** una solución, **directamente, sin *forking* ni rebobinado**. **(b)** Dadas dos firmas válidas distintas sobre el mismo $\mu^*$, **salvo colisión de $H$** (evento absorbido en el término estadístico), ambas comparten el mismo $\mathbf w_1$ —pues $c=H(\mu^*,\mathbf w_1)$—; su diferencia produce entonces un vector corto no nulo $\mathbf v$ con $[\,\mathbf A\,|\,\mathbf t\,]\,\mathbf v=\mathbf 0$, i.e. una solución de $\mathrm{MSIS}$. El recuento exacto de las cotas de norma figura en [D+18, Sec. 6]. $\qquad\square$

> **Nota (el argumento de *forking*).** El esquema clásico de *forking* —dos transcripciones con el mismo *commitment* y retos distintos— **no** aparece arriba: gracias a la formulación SelfTargetMSIS, la falsificación es solución directa (Lema 6.2.a). El *forking* solo interviene en la reducción **adicional y no ajustada** de $\mathrm{SelfTargetMSIS}$ a $\mathrm{MSIS}$ en el ROM, y es justo el paso que **no** se traslada al QROM (de ahí que la dureza cuántica de SelfTargetMSIS se trate como supuesto, ver más abajo).

> **Salvedad sobre la tightness en el QROM.** [KLS18] establece el resultado en el QROM para una **variante modificada** ("Dilithium-QROM", que exige $q\equiv 5\pmod 8$ y conlleva claves/firmas mayores) y trata la dureza *cuántica* de SelfTargetMSIS esencialmente como un supuesto. La reducción QROM completa y ajustada para los parámetros desplegados ha sido objeto de trabajo posterior. Se declara esta salvedad para no sobre-afirmar el carácter *tight* de la reducción en el QROM.

### 6.4.2 De MLWE/MSIS a problemas reticulares de peor caso

Los dos primeros términos del Teorema 6.1 descansan sobre la dureza de MLWE y MSIS en el **caso promedio** (instancias aleatorias). El siguiente resultado liga esa dureza promedio a la dureza de problemas reticulares en el **peor caso**, lo que constituye la garantía más fuerte que ofrece la criptografía reticular.

**Teorema 6.2 (Reducciones worst-case → average-case para módulos [LS15]).** *Resolver $\mathrm{MLWE}_{k,\ell,\eta}$ en el caso promedio, con ventaja no despreciable, implica resolver $\gamma$-$\mathrm{Mod\text{-}SIVP}$ (el problema del vector independiente más corto sobre retículos de módulo, vía su variante generalizada $\mathrm{Mod\text{-}GIVP}$) en el **peor caso**, para un factor de aproximación $\gamma$ polinómico. Análogamente, la dureza de $\mathrm{MSIS}$ se basa en $\mathrm{Mod\text{-}SIVP}$ de peor caso.* Estas reducciones generalizan al caso de módulos las reducciones base de Regev [Reg09] para LWE, que conectan LWE con $\mathrm{GapSVP}$ y $\mathrm{SIVP}$ de peor caso.

**Demostración (idea; resultado citado, no re-demostrado).** No re-derivamos estos teoremas —son resultados mayores de la literatura—; exponemos su estructura y los citamos, que es el alcance apropiado. La reducción de Regev [Reg09] es **cuántica e iterativa**: a partir de un oráculo que resuelve LWE en promedio, construye una rutina que genera muestras gaussianas cada vez más estrechas sobre el retículo, hasta resolver $\mathrm{SIVP}/\mathrm{GapSVP}$ de peor caso; el **único** paso cuántico es la preparación de un estado cuántico a partir de una distribución gaussiana sobre el retículo (de ahí que la rama LWE/MLWE sea cuántica). Langlois–Stehlé [LS15] **elevan** esta maquinaria al caso de **módulos** sobre $R_q$, obteniendo $\mathrm{Mod\text{-}SIVP}_\gamma \to \mathrm{MLWE}$ (cuántica) y $\mathrm{Mod\text{-}SIVP}_\gamma \to \mathrm{MSIS}$ (clásica, sin el paso cuántico), con factor $\gamma$ polinómico en la dimensión del módulo. Instanciar para los parámetros de §6.2.3 fija los valores concretos de $\gamma$ y la pérdida de la reducción. $\qquad\square$

> **Nota de precisión (clásico vs. cuántico).** La reducción que sustenta **MLWE** ($\mathrm{Mod\text{-}SIVP}\to\mathrm{MLWE}$) es **cuántica** (hereda el paso cuántico de Regev), mientras que la que sustenta **MSIS** ($\mathrm{Mod\text{-}SIVP}\to\mathrm{MSIS}$) es **clásica**. Es relevante señalarlo porque §6.4.3 construye el argumento de resistencia cuántica precisamente sobre la dureza de estos problemas de peor caso. (Recuérdese también la distinción de §6.2.1: el problema correcto es $\mathrm{SIVP}$ / $\mathrm{Mod\text{-}SIVP}$, no $\mathrm{SVP}$.)

La consecuencia conceptual es contundente: **falsificar una firma Dilithium implicaría resolver, en el peor caso, un problema reticular ($\mathrm{Mod\text{-}SIVP}$) que la comunidad criptográfica conjetura difícil tras décadas de estudio.**

### 6.4.3 Resistencia cuántica: no aplicabilidad del algoritmo de Shor

Resta argumentar por qué $\mathrm{Mod\text{-}SIVP}$ resiste a un adversario cuántico, a diferencia de RSA y ECC.

**Proposición 6.3 (No reducción a un HSP abeliano).** *El algoritmo de Shor [Sho97] resuelve eficientemente el Problema del Subgrupo Oculto (HSP) sobre grupos **abelianos** finitos —del cual la factorización y el logaritmo discreto son casos particulares—. Los problemas reticulares relevantes ($\gamma$-SIVP y, sobre módulos, $\gamma$-$\mathrm{Mod\text{-}SIVP}$) no se conocen como instancias de un HSP abeliano resoluble, por lo que el algoritmo de Shor **no se les aplica**.*

**Argumento.** Recuérdese la definición: una instancia de HSP es una terna $(G, H\le G, f:G\to S)$ donde $f$ es **constante en cada coclase** de $H$ y **distinta entre coclases**; resolver el HSP es hallar $H$. Cuando $G$ es **abeliano**, Shor lo resuelve en tiempo $\mathrm{poly}(\log\lvert G\rvert)$ aplicando la **Transformada Cuántica de Fourier** sobre el grupo dual $\widehat G$ para muestrear el subgrupo ortogonal $H^\perp$ y reconstruir $H$; la factorización ($G=\mathbb Z_N^\times$) y el logaritmo discreto son casos particulares. La obstrucción para los retículos es estructural: el ataque natural los reformula como un HSP sobre el grupo **diédrico** $D_N$ —**no abeliano**—, donde la QFT no factoriza el problema. Tras tres décadas, el mejor algoritmo cuántico conocido para el HSP diédrico es el de **Kuperberg**, de costo **subexponencial** $2^{O(\sqrt{\log N})}$ [Kup05], y ni siquiera se conoce una reducción eficiente de $\gamma$-$\mathrm{Mod\text{-}SIVP}$ a dicho HSP. Por ello, el mejor enfoque cuántico **efectivo** contra los problemas reticulares no pasa por Shor, sino por el **tamizado cuántico (*quantum sieving*)**, de costo $2^{(0.265+o(1))d}$ frente al $2^{(0.292+o(1))d}$ del mejor tamizado clásico [Laa15, BDGL16], con $d$ la dimensión del retículo.

**Conclusión cuantitativa — con una advertencia de precisión.** El *speedup* cuántico conocido es **modesto**: reduce la constante del exponente de $\approx 0.292$ a $\approx 0.265$, de modo que, bajo el modelo *core-SVP*, la seguridad cuántica estimada es
$$\approx \frac{0.265}{0.292}\,\times\ \text{(seguridad clásica)} \ \approx\ 0.91\,\times\ \text{(seguridad clásica)},$$
es decir, **una reducción de apenas $\sim$9 %, no a la mitad**. A título orientativo, las estimaciones *core-SVP* de la especificación de Dilithium son del orden de:

| | Seguridad clásica | Seguridad cuántica (core-SVP) | Categoría NIST |
|---|:---:|:---:|:---:|
| Dilithium2 | $\sim$123 bits | $\sim$112 bits | 2 |
| Dilithium3 | $\sim$182 bits | $\sim$166 bits | 3 |
| Dilithium5 | $\sim$252 bits | $\sim$229 bits | 5 |

> **Reconciliación de dos cifras (importante para la defensa).** La columna "seguridad cuántica = la mitad" que aparece en tablas divulgativas (128→64, 192→96, 256→128) **no** proviene del tamizado (que da $\sim$0,91×), sino de una **heurística conservadora tipo Grover** (speedup cuadrático sobre búsqueda genérica), *pesimista* para esquemas reticulares. Ambas cifras deben presentarse explícitamente: la estimación *core-SVP* ($\sim$0,91×) como la cifra técnica vigente, y la cota tipo Grover (mitad de bits) como límite conservador.

### 6.4.4 Cadena de reducciones (síntesis)

La validación de seguridad se resume en la siguiente cadena, que recorre el arco completo desde el ataque hasta el problema cuánticamente difícil:

$$
\underbrace{\text{Falsificar Dilithium}}_{\text{romper sUF-CMA}}
\ \Longrightarrow\
\underbrace{\text{resolver }\mathrm{MLWE}\ \vee\ \mathrm{SelfTargetMSIS}\ \vee\ \mathrm{MSIS}}_{\text{Teorema 6.1 (3 términos)}}
\ \Longrightarrow\
\underbrace{\gamma\text{-}\mathrm{Mod\text{-}SIVP}\ \text{peor caso}}_{\text{Teorema 6.2}}
\ \overset{\text{Prop. 6.3}}{\Longrightarrow}\
\underbrace{\text{difícil aun cuánticamente}}_{\text{Shor no aplica}}
$$

Cada flecha conlleva supuestos y pérdidas de reducción que, en un análisis concreto de parámetros, determinan los niveles de seguridad de la tabla anterior. La cadena justifica formalmente la afirmación central de NEXUS: **la in-forjabilidad de las transacciones se reduce, en última instancia, a la dureza de peor caso de un problema reticular que resiste a Shor.**

---

## 6.5 Análisis de complejidad computacional

### 6.5.1 La NTT como operación dominante

La operación costosa en $R_q$ es la multiplicación de polinomios. Mediante la **NTT** —una Transformada de Fourier sobre $\mathbb{Z}_q$, posible porque $q\equiv 1\pmod{2n}$ (§6.2.2)— un polinomio se lleva al "dominio NTT" en $O(n\log n)$ operaciones; en ese dominio la multiplicación es **puntual** ($O(n)$), y la transformada inversa cuesta de nuevo $O(n\log n)$. Así, una multiplicación en $R_q$ cuesta
$$T_{\text{mult}}(n) = O(n\log n)\ \text{operaciones en }\mathbb{Z}_q,$$
frente al $O(n^2)$ del producto escolar. Con $n=256$, la ganancia es decisiva y explica el rendimiento del esquema.

### 6.5.2 Complejidad de KeyGen, Sign y Verify

Midiendo el costo en multiplicaciones de anillo (cada una $O(n\log n)$):

**Proposición 6.4 (Costos asintóticos).** *Para Dilithium con dimensiones $(k,\ell)$ y $n$ fijo:*
- $\mathsf{KeyGen}$*: el cálculo de $\mathbf{t}=\mathbf{A}\mathbf{s}_1+\mathbf{s}_2$ requiere $k\ell$ multiplicaciones de anillo, luego $O(k\ell\,n\log n)$.*
- $\mathsf{Sign}$ *(esperado): cada iteración del bucle de rechazo está dominada por el producto matriz–vector $\mathbf{A}\mathbf{y}$ ($k\ell$ multiplicaciones), luego $O(k\ell\,n\log n)$ por iteración; el número esperado de iteraciones es una **constante** por conjunto de parámetros, luego el costo esperado es $O(k\ell\,n\log n)$.*
- $\mathsf{Verify}$*: recomputar $\mathbf{A}\mathbf{z}-c\,\mathbf{t}$ cuesta $O(k\ell\,n\log n)$.*

*Demostración (recuento).* En $\mathsf{KeyGen}$, $\mathbf{A}\in R_q^{k\times\ell}$ y $\mathbf{s}_1\in R_q^\ell$, de modo que $\mathbf{A}\mathbf{s}_1$ son $k\ell$ productos de anillo; la suma de $\mathbf{s}_2$ es $O(kn)$, de orden inferior, y la verificación es de nuevo un producto matriz–vector $O(k\ell\,n\log n)$.

Para $\mathsf{Sign}$ resta acotar el número de iteraciones del bucle de rechazo. Sea $p_{\mathrm{acc}}$ la probabilidad de que una iteración supere ambas comprobaciones de rechazo (sobre $\|\mathbf z\|_\infty$ y la parte baja). Como cada iteración usa aleatoriedad **fresca e independiente** ($\mathbf y$ nuevo), el número de iteraciones $N$ hasta la primera aceptación sigue una **distribución geométrica** de parámetro $p_{\mathrm{acc}}$, cuyo valor esperado es
$$\mathbb{E}[N]=\frac{1}{p_{\mathrm{acc}}}.$$
Los parámetros del esquema $(\gamma_1,\beta,\dots)$ se eligen por diseño de modo que $p_{\mathrm{acc}}$ esté **acotada inferiormente por una constante positiva independiente de $n$**; en consecuencia $\mathbb{E}[N]=O(1)$. Concretamente, $\mathbb{E}[N]\approx 4.25$ para Dilithium2, $\approx 5.1$ para Dilithium3 y $\approx 3.85$ para Dilithium5 [D+18]. Como cada iteración cuesta $O(k\ell\,n\log n)$ (el producto $\mathbf{A}\mathbf{y}$ domina; $c\,\mathbf{s}_1$ son $\ell$ productos) y multiplicar por la constante $\mathbb{E}[N]$ preserva el orden, el costo **esperado** de $\mathsf{Sign}$ es $O(k\ell\,n\log n)$. $\qquad\blacksquare$

**Cota más fina (implementación optimizada).** Manteniendo $\mathbf{A}$ y los vectores en el **dominio NTT**, las $k\ell$ multiplicaciones puntuales cuestan $O(k\ell\,n)$ y las transformadas se incurren solo $O(k+\ell)$ veces, dando
$$O\big((k+\ell)\,n\log n + k\ell\,n\big),$$
que es ajustada. El $O(k\ell\,n\log n)$ del enunciado es una **cota superior** válida bajo la convención «cada multiplicación de anillo $= O(n\log n)$». Como $n=256$ es fijo, en la práctica el costo escala con $k\ell$.

**Tamaños.** La clave pública $pk=(\rho,\mathbf{t}_1)$ está dominada por $\mathbf{t}_1\in R_q^k$ ($k\cdot n$ coeficientes de $O(\log q)$ bits; $\mathbf A$ se regenera de la semilla $\rho$ de 256 bits y no se almacena), luego $|pk|=O(k\,n\log q)$. La firma $\sigma=(\mathbf{z},\mathbf{h},c)$ está dominada por $\mathbf{z}\in R_q^\ell$, luego $|\sigma|=O((k+\ell)\,n\log q)$. Ambas cotas concuerdan con los tamaños tabulados (§6.2.3).

**Tabla 6.1 — Complejidad y tamaños.**

| | $\mathsf{KeyGen}$ | $\mathsf{Sign}$ (esp.) | $\mathsf{Verify}$ | $\lvert pk\rvert$ | $\lvert\sigma\rvert$ |
|---|:---:|:---:|:---:|:---:|:---:|
| Asintótico | $O(k\ell\,n\log n)$ | $O(k\ell\,n\log n)$ | $O(k\ell\,n\log n)$ | $O(k\,n\log q)$ | $O((k{+}\ell)\,n\log q)$ |
| Dilithium2 | — | $\approx 4.25$ iter. | — | 1312 B | 2420 B |
| Dilithium3 | — | $\approx 5.1$ iter. | — | 1952 B | 3309 B |
| Dilithium5 | — | $\approx 3.85$ iter. | — | 2592 B | 4627 B |

### 6.5.3 Overhead del esquema dual

El análisis cuantificado completo del *overhead* y de su amortización por la arquitectura dual-chain se desarrolla en el **Capítulo 3** (documento `Analisis-Overhead-PQC-DualChain`). Aquí se consignan los resultados pertinentes a la **verificación de firmas**, que es la magnitud que el análisis de complejidad acota:

- **Costo de datos** (cuello de botella real): una firma Dilithium3 (3309 B) es $\approx 52\times$ una firma ECDSA (64 B). El costo de **CPU** de verificación, en cambio, es del **mismo orden** que ECDSA (§6.5.4): el penalizador PQC es de **tamaño**, no de cómputo.
- **Verificación por bloque** de $m$ transacciones en una cadena única: $O(m\cdot k\ell\,n\log n)$.
- **Amortización dual-chain**: con un rollup de validez, la L1 verifica **una** prueba (independiente de $m$), reduciendo el cómputo de verificación on-chain a $O(t_\pi/m)\to 0$ por transacción, y —crucialmente— eliminando las firmas de la L1, de modo que el costo de datos amortizado por transacción tiende a la diferencia de estado clásica (Cap. 3). El sistema de pruebas debe ser **post-cuántico (STARK)** para mantener la coherencia (Cap. 3, §3.5).

### 6.5.4 Comparación con criptografía clásica

| | RSA-2048 | ECDSA P-256 | **Dilithium3** |
|---|:---:|:---:|:---:|
| Tamaño de firma | 256 B | 64 B | **3309 B** |
| Costo de verificación (CPU) | bajo | decenas de µs | ~0,17–0,44 ms medido (**mismo orden, sub-ms**) |
| Resistencia cuántica | **Rota** (Shor, tiempo poli.) | **Rota** (Shor, tiempo poli.) | **Sin ataque cuántico eficiente conocido** |

La comparación subraya el argumento central de la tesis: Dilithium **iguala** a ECC en costo de verificación y **lo supera** en lo único que importa frente a la amenaza cuántica —la resistencia—, a cambio de un sobrecosto de **tamaño** que la arquitectura dual amortiza.

---

## 6.6 Validación empírica complementaria

El análisis asintótico de §6.5 fija la **forma** del costo ($O(k\ell\,n\log n)$) pero oculta las **constantes**. La validación empírica las acota y confirma la factibilidad práctica; **complementa, no sustituye**, la validación formal.

**Metodología.** Banco de pruebas con el *harness* Criterion (`nexus-crypto/benches/dilithium_bench.rs`), ejecutado una vez resuelto el *build* (Plan Maestro, Fase A, ya completada). Para cada nivel (Dilithium2/3/5) y operación ($\mathsf{KeyGen}$, $\mathsf{Sign}$, $\mathsf{Verify}$): 100 muestras con calentamiento, reportando la mediana (robusta a valores atípicos) sobre el hardware indicado.

**Métricas e hipótesis a contrastar.**
- Tiempos por operación y verificaciones por segundo, por nivel.
- **Contraste teoría–práctica:** verificar que el tiempo escala $\sim$linealmente con $k\ell$ a $n$ fijo (consistente con la Proposición 6.4) y que el número medio de iteraciones de $\mathsf{Sign}$ se aproxima a las constantes $4.25/5.1/3.85$.
- Comparación del tamaño de bloque ECDSA vs. Dilithium y del throughput de L1 (insumo del análisis de overhead del Cap. 3).

**Resultados medidos.** *Hardware:* Intel (Kaby Lake, Familia 6 Modelo 142), 4 hilos lógicos, Windows 11; perfil `release` (opt-level 3, LTO fino). *Backend:* crate `fips204` (ML-DSA **puro Rust**, constant-time). *Herramienta:* Criterion, 100 muestras por punto. Se reporta la **mediana** (robusta a valores atípicos):

**Tabla 6.2 — Tiempos medidos de ML-DSA / Dilithium.**

| Operación | Dilithium2 | Dilithium3 | Dilithium5 |
|---|---:|---:|---:|
| Generación de claves | 321 µs | 503 µs | 725 µs |
| Firma | 727 µs | 1,21 ms | 1,34 ms |
| **Verificación** | **166 µs** | **279 µs** | **436 µs** |

**Contraste teoría–práctica.**
1. **El cuello de botella no es el cómputo.** La verificación tarda **cientos de microsegundos** (166–436 µs), un costo despreciable frente al *overhead de datos* (~52× en tamaño de firma). Esto confirma empíricamente la tesis central (§6.5.3, Cap. 3): el penalizador post-cuántico es de tamaño, no de CPU. *(Robustez al* backend*: la verificación con `fips204` (Rust puro) es del **mismo orden** que la de implementaciones en C optimizado —p. ej. pqcrypto, ~270 µs en D3—, reforzando que el cuello no es de CPU ni de backend.)*
2. **Escalado consistente con $O(k\ell\,n\log n)$.** La generación de claves, la firma y la verificación crecen de forma **monótona** con el nivel, en línea con el producto $k\ell$ (16, 30, 56 para D2/D3/D5): KeyGen 321→503→725 µs y Verify 166→279→436 µs crecen de forma monótona con $k\ell$ a $n=256$ fijo, si bien el escalado empírico es **sublineal** respecto a $k\ell$ (KeyGen ×1,57 y ×2,26; Verify ×1,68 y ×2,63 frente a las razones ×1,875 y ×3,5 de $k\ell$), por la influencia de términos de orden inferior y constantes de implementación (cf. la cota afinada $O((k+\ell)\,n\log n + k\ell\,n)$).
3. **La firma es la operación más costosa.** La domina el bucle de *rejection sampling* (§6.5.2), cuyo número de iteraciones es esperado-constante pero **variable**; es un costo **esperado**, no de peor caso. La mediana mitiga esa variabilidad.

> Las cifras corresponden a un **portátil modesto** y a un *backend* en Rust puro (sin SIMD); en hardware de servidor o con una implementación en C optimizado serían menores. Lo relevante para la tesis es el **orden de magnitud** (verificación en cientos de µs) y la **forma del escalado**, no los valores absolutos.

---

## 6.7 Limitaciones y alcance de la validación

Se declaran explícitamente las fronteras de esta validación formal:

- **Modelo de caja negra / QROM.** Se valida la in-forjabilidad del esquema, **no** su seguridad de implementación: quedan fuera los **canales laterales** (temporización, consumo) y los **ataques por fallos**, relevantes en hardware real.
- **Seguridad del primitivo, no del sistema completo.** El Teorema 6.1 garantiza in-falsificabilidad **a nivel de transacción**. La integridad del **libro mayor** depende además de la seguridad del **consenso** (que en NEXUS es diseño de referencia, no implementación operativa); por tanto, la afirmación de seguridad del sistema es condicional: *in-falsificabilidad de transacciones bajo el supuesto de consenso honesto-mayoritario*.
- **Componentes parcialmente implementados.** El sistema de pruebas de validez (Nitro Verifier) **sí** cuenta con un prototipo de referencia post-cuántico: un STARK hash-based propio (Merkle/SHA3 + Fiat–Shamir + FRI, sin emparejamientos) que verifica una transición de estado con coste de verificación **sucinto** (Cap. 3, §3.5). Sus desafíos se extraen del campo de extensión $F_{p^2}$ y se añade grinding, alcanzando un **presupuesto de soundness de ~100 bits** bajo *proximity gaps* (Cap. 3, §3.5). Lo que queda como trabajo futuro es su *aritmetización completa* (el AIR del PoC es ilustrativo) y la incorporación de **DEEP/out-of-domain** (que daría 100 bits sin invocar la conjetura de *proximity gaps*); su validación es **empírica y por pruebas de software** —incluida una batería adversarial—, no una reducción formal como la de §6.4. El extractor difuso (eliminado del alcance) y la confidencialidad post-cuántica (que requeriría un KEM, p. ej. ML-KEM) sí quedan fuera y se enuncian como trabajo futuro.
- **Tensión de diseño (apuntada para el Cap. 3).** Probar la verificación de Dilithium dentro de un STARK es costoso; las firmas *hash-based* son más STARK-friendly. La elección de Dilithium optimiza la verificación directa a costa de fricción con la agregación probada; se discute como decisión consciente en el Cap. 3.

---

## 6.8 Conclusiones del capítulo

Este capítulo ha validado formalmente el núcleo de seguridad de NEXUS:

1. **Prueba de dureza (Obj. 4.1).** La in-forjabilidad fuerte de Dilithium se reduce, mediante una cota de **tres términos** (MLWE + SelfTargetMSIS + MSIS) en el QROM, a la dureza promedio de MLWE/MSIS, y de ahí —vía reducciones de peor caso— a $\mathrm{Mod\text{-}SIVP}$, un problema reticular que **ningún algoritmo cuántico conocido, incluido el de Shor, resuelve eficientemente** (cadena de §6.4.4).
2. **Análisis de complejidad (Obj. 4.2).** Las operaciones del esquema tienen costo $O(k\ell\,n\log n)$ (dominado por la NTT, $O(n\log n)$ por multiplicación), con $\mathsf{Sign}$ esperado constante en iteraciones; el sobrecosto del esquema es de **tamaño**, no de cómputo, y se amortiza en la arquitectura dual (Cap. 3).
3. **Validación empírica (Obj. 4.2).** Una metodología de *benchmark* acota las constantes ocultas y contrasta teoría y práctica.

Con ello, el **Objetivo 4 queda atendido en su componente formal**, cerrando el arco de la tesis: *la amenaza cuántica a las firmas de banca se neutraliza con Dilithium, cuya seguridad se reduce a un problema reticular resistente a Shor y cuyo costo —de tamaño— se amortiza mediante la arquitectura dual-chain post-cuántica.*

---

## Referencias del capítulo

> *Índice local del capítulo; la **Bibliografía** consolidada al final del documento reúne todas las obras bajo clave única.*

- **[D+18]** Ducas, Kiltz, Lepoint, Lyubashevsky, Schwabe, Seiler, Stehlé. *CRYSTALS-Dilithium: A Lattice-Based Digital Signature Scheme.* IACR ToCHES 2018(1).
- **[KLS18]** Kiltz, Lyubashevsky, Schaffner. *A Concrete Treatment of Fiat-Shamir Signatures in the Quantum Random-Oracle Model.* EUROCRYPT 2018.
- **[Lyu09]** Lyubashevsky. *Fiat-Shamir with Aborts: Applications to Lattice and Factoring-Based Signatures.* ASIACRYPT 2009. *(origen de la técnica rejection-sampling/aborts)*
- **[Lyu12]** Lyubashevsky. *Lattice Signatures without Trapdoors.* EUROCRYPT 2012. *(esquema del que Dilithium desciende)*
- **[LS15]** Langlois, Stehlé. *Worst-Case to Average-Case Reductions for Module Lattices.* Designs, Codes and Cryptography 75(3), 2015.
- **[Reg09]** Regev. *On Lattices, Learning with Errors, Random Linear Codes, and Cryptography.* J. ACM 56(6), 2009.
- **[BDF+11]** Boneh, Dagdelen, Fischlin, Lehmann, Schaffner, Zhandry. *Random Oracles in a Quantum World.* ASIACRYPT 2011.
- **[Sho97]** Shor. *Polynomial-Time Algorithms for Prime Factorization and Discrete Logarithms on a Quantum Computer.* SIAM J. Comput. 26(5), 1997.
- **[Kup05]** Kuperberg. *A Subexponential-Time Quantum Algorithm for the Dihedral Hidden Subgroup Problem.* SIAM J. Comput. 35(1), 2005. *(barrera del HSP diédrico)*
- **[Laa15]** Laarhoven. *Search Problems in Cryptography* (tamizado cuántico para SVP). 2015.
- **[BDGL16]** Becker, Ducas, Gama, Laarhoven. *New Directions in Nearest Neighbor Searching with Applications to Lattice Sieving.* SODA 2016. *(constante clásica 0.292)*
- **[Pei16]** Peikert. *A Decade of Lattice Cryptography.* 2016.
- **[NIST24]** NIST. *FIPS 204: Module-Lattice-Based Digital Signature Standard (ML-DSA).* 2024.


# Capítulo 7 — Conclusiones y Trabajo Futuro

### (Cierre del arco, balance de objetivos y agenda)

> **Rol en el arco de la tesis.** Este capítulo cierra el círculo: recoge el arco narrativo, hace un balance **honesto** de lo logrado frente a cada objetivo, enuncia las contribuciones y las limitaciones declaradas, y deja una agenda de trabajo futuro priorizada.

---

## 7.1 Síntesis: el arco completado

Esta tesis se construyó como una sola cadena de razonamiento, y cada capítulo entregó su eslabón:

| Eslabón | Capítulo | Qué se estableció |
|---|---|---|
| **Amenaza** | 1 | El adversario cuántico recupera claves (Shor) y falsifica firmas de banca; HNDL hace la migración urgente. |
| **Fundamentos** | 2 | Retículos, Dilithium, estándares NIST, entropía, y la distinción Groth16 (roto)/STARK (PQ). |
| **Costo + Respuesta + Coherencia** | 3 | La PQC cuesta ~50× en datos (~20× de throughput); el dual-chain lo amortiza a ~$d$; el verificador debe ser STARK. |
| **Solución** | 4 | Dilithium implementado y ligado a la transacción; derivación determinística por KDF. |
| **Capa operativa** | 5 | Min-entropía + salud SP 800-90B + rotación con secrecia hacia adelante. |
| **Validación** | 6 | Reducción a Module-LWE/MSIS → Mod-SIVP (resistente a Shor) + análisis de complejidad. |

El resultado es una respuesta coherente a la pregunta central del Capítulo 1: **se puede asegurar las firmas de una blockchain bancaria contra la amenaza cuántica sin sacrificar la escalabilidad, si la arquitectura dual-chain amortiza el sobrecosto post-cuántico y su capa de verificación es ella misma post-cuántica.**

## 7.2 Balance de los objetivos

Se reporta el grado de cumplimiento de cada objetivo con honestidad, distinguiendo lo **modelado**, lo **implementado/verificado** y lo **pendiente**:

**Objetivo 1 — Diseñar la arquitectura Dual-Chain.** *Cumplido como modelo de referencia.* Se especificaron los roles de L1/L2, el camino de la firma post-cuántica, el modelo de cuenta (identidad estable vs. clave rotable), la disponibilidad de datos estilo PeerDAS, la secuenciación con incentivos y la finalidad rápida (Cap. 3). La realización **operativa** del consenso y la DA es trabajo futuro; el verificador post-cuántico (Nitro Verifier) cuenta ya con un **PoC STARK implementado** (Cap. 3, §3.5).

**Objetivo 2 — Núcleo criptográfico PQC.** *Cumplido.* Dilithium (firma/verificación, multinivel) está **implementado y verificado** sobre la biblioteca auditada `fips204` (ML-DSA / FIPS 204), con enlace correcto a la transacción (Cap. 4). La **derivación determinística desde semilla** está **implementada y verificada** (`from_seed` usa la `KeyGen` semillada de `fips204`; test `test_deterministic_from_seed`).

**Objetivo 3 — Lógica de seguridad activa.** *Cumplido.* La rotación con secrecia hacia adelante, la **min-entropía de la fuente** y las **pruebas de salud NIST SP 800-90B (RCT/APT)** con bloqueo ante degradación están **implementadas y verificadas con tests** (Cap. 5), reemplazando la métrica errónea de entropía de Shannon de la semilla.

**Objetivo 4 — Validación formal.** *Cumplido en su componente formal.* Se desarrolló la **cadena de reducciones** (in-forjabilidad fuerte → Module-LWE + SelfTargetMSIS + Module-SIS → Mod-SIVP de peor caso, con la no aplicabilidad de Shor) y el **análisis de complejidad** $O(k\ell\,n\log n)$ (Cap. 6). La **validación empírica** (benchmarks reales de Dilithium) está **completada** y reportada en el Cap. 6 §6.6 (Tabla 6.2).

## 7.3 Contribuciones

1. **Un modelo formal y prototipo de referencia** de firmas post-cuánticas (Dilithium) en una arquitectura dual-chain para banca, con el núcleo de firma genuinamente implementado y verificado.
2. **El análisis cuantificado del sobrecosto post-cuántico** (Cap. 3): el hallazgo de que el cuello de botella es de **datos, no de cómputo**, y la demostración de que el dual-chain amortiza el costo on-chain por transacción al de su diferencia de estado clásica.
3. **El principio de coherencia post-cuántica del sistema de pruebas** (el verificador L2 debe ser STARK, no Groth16), con la **tensión Dilithium-vs-STARK-friendliness** identificada como decisión de diseño consciente.
4. **La validación formal instanciada para NEXUS**: la cadena de reducciones con la cota correcta de **tres términos** y el argumento de resistencia cuántica con la estimación *core-SVP* (~0,91×, no "la mitad").
5. **La reformulación rigurosa de la gestión activa de claves** (min-entropía + SP 800-90B + rotación forward-secure), que reemplaza un enfoque conceptualmente frágil.
6. **El modelo de cuenta** (identidad estable, política de verificación, *epoch*) + Registro de Claves, que resuelve la coexistencia de rotación/migración PQC con identidad estable.
7. **La política de residencia efímera de la clave y su métrica** (Cap. 5, §5.6): custodia *seed-only* (formato hoy recomendado por el RFC 9881) elevada a política de seguridad —regeneración KeyGen-por-firma con zeroización, medida empíricamente (+0,75 ms por firma; exposición permanente 126× menor)— y la **ventana de exposición** $W=\text{bytes}\times\Delta t$ como cuantificador; ni la política ni la métrica tienen formalización previa localizada (la guía vigente recomienda incluso cachear la clave expandida).
8. **La propuesta del *Deception Engine*** (§7.5): conmutación del firmador a un par señuelo ML-DSA ante detección de observación, con el *sequencer* L2 como *honeychecker*. Es una **propuesta de diseño argumentada frente al estado del arte** (no una implementación): la revisión de jul. 2026 no localiza ningún trabajo que combine señuelos criptográficos con firmas post-cuánticas ni con respuesta coordinada en L2.

## 7.4 Limitaciones

Se declaran con franqueza, pues delimitan honestamente el aporte:

- **Modelo, no producto.** El entregable es un modelo formal + prototipo de referencia. La pieza más compelente —la amortización dual-chain— está **rigurosamente analizada y parcialmente construida**: Dilithium es real, y el **verificador STARK post-cuántico que la materializa cuenta ya con un PoC implementado, endurecido (~100 bits) y probado por una batería adversarial** (FRI + Merkle/SHA3, desafíos en $F_{p^2}$, grinding, verificación sucinta; Cap. 3, §3.5), con validación por software, no por reducción formal; su AIR sigue siendo ilustrativo (aritmetización bancaria completa) y la incorporación de DEEP son trabajo futuro.
- **Seguridad del primitivo, no del sistema completo.** La validación garantiza in-falsificabilidad **a nivel de transacción**, condicionada al **supuesto de consenso honesto-mayoritario** (el consenso operativo es diseño de referencia).
- **Novedad de síntesis.** El aporte no es un resultado de frontera —la frontera (Ethereum, Solana) converge hacia lo mismo—, sino su **síntesis formal y cuantificada** para banca; la convergencia se interpreta como **validación**.
- **El Objetivo 3 es una rama necesaria pero lateral** del arco central (firmas + dual-chain + validación).
- **Fuera de alcance:** confidencialidad post-cuántica (requeriría un KEM), seguridad de implementación (canales laterales, fallos), y la biometría (eliminada).

## 7.5 Trabajo futuro

Agenda priorizada, derivada de las limitaciones:

1. **Cimientos y evidencia empírica** — **HECHO (2026-06-04/05):** el workspace **compila por completo** y los **109 tests unitarios pasan** (incluidos los 33 del STARK del Nitro Verifier, con batería adversarial); los **benchmarks** del Cap. 6 §6.6 son mediciones reales.
2. **Obj. 2 y 3 en código** — **HECHO:** se removió la biometría; la **min-entropía + las pruebas de salud NIST SP 800-90B (RCT/APT)** con bloqueo ante degradación, y la **`KeyGen` determinística desde semilla** (migración a `fips204` / FIPS 204), están implementadas y verificadas con tests.
3. **Verificador post-cuántico (la pieza clave).** — **PoC HECHO y ENDURECIDO (2026-06-05):** se implementó un **STARK hash-based propio** (`nexus-zk::stark`: Goldilocks + NTT + Merkle/SHA3 con separación de dominio + Fiat–Shamir + FRI) cableado al Nitro Verifier (`nexus-active::pq_verifier`), con **verificación sucinta** medida, **sin emparejamientos** (Shor no aplica) y **endurecido a ~100 bits de soundness** (desafíos en el campo de extensión $F_{p^2}$, grinding, 40 consultas; batería de pruebas adversariales). Resta **extenderlo a producción**: aritmetizar la **máquina de estado bancaria completa** (el AIR actual es ilustrativo), incorporar **DEEP/out-of-domain** (para 100 bits sin la conjetura de *proximity gaps*), y abordar el reto de investigación de **probar la verificación de firmas Dilithium en circuito** (costoso para esquemas reticulares); evaluar como alternativa la agregación de firmas hash-based, más STARK-friendly (cf. Cap. 3, §3.5.1).
4. **Consenso BFT operativo.** Verificación de firmas de voto, quórum ponderado por *stake* ($\lfloor 2N/3\rfloor+1$), detección de equivocación + *slashing*, y difusión en red — para **levantar el supuesto** de consenso honesto y validar la seguridad a nivel de sistema.
5. **Disponibilidad de datos real.** *Erasure coding* (Reed-Solomon) + muestreo entre pares (estilo PeerDAS) + poda.
6. **Abstracción de cuentas + Registro de Claves completos**, para cripto-agilidad y migración (firmas híbridas clásica+PQ).
7. **Confidencialidad post-cuántica.** Integrar un KEM (ML-KEM / Kyber, FIPS 203) para cerrar la amenaza HNDL de confidencialidad, hoy fuera de alcance.
8. **Exploración de esquemas alternativos.** Evaluar **Falcon** (FN-DSA, FIPS 206) para recortar el sobrecosto de ~50× a ~10×, ponderando su complejidad de implementación, una vez finalizado el estándar (~fin 2026).
9. **Deception Engine (defensa activa off-chain).** Implementar la conmutación del firmador a un **par señuelo ML-DSA** ante fallo de atestación o detección de depuración/introspección, con el *sequencer* L2 como *honeychecker* que bloquea la transacción y dispara la alerta al reconocer la clave señuelo. Requisitos derivados de la literatura: **indistinguibilidad formal** del señuelo y de sus metadatos —las bóvedas señuelo de NoCrack cayeron por análisis estadístico (CCS 2016) y los *canary tokens* de AWS por metadatos— y conmutación en **tiempo constante**; a favor, un par ML-DSA señuelo generado con la misma `KeyGen` es idéntico en distribución a uno real. Antecedentes parciales: honeywords/*honeychecker* [JR13], claves señuelo estáticas de la patente US 10,521,584 B1, y custodia TEE con atestación on-chain (Puffer Secure-Signer). Nota criptográfica: la respuesta **nunca** altera el nonce de Fiat-Shamir (un nonce sesgado filtra $s_1$ por reducción de retículos); el señuelo es un par legítimo e independiente. Complementos: **Threshold ML-DSA** (fragmentación de $s_1$ por MPC) para que ningún proceso contenga la clave completa.

## 7.6 Reflexión final

La amenaza cuántica a la criptografía financiera dejó de ser especulativa: los estándares post-cuánticos están finalizados y las cadenas de mayor valor han comenzado su migración. En este contexto, NEXUS aporta lo que un trabajo de grado puede aportar con rigor: **un modelo formal y cuantificado de cómo asegurar las firmas de banca contra la amenaza cuántica a un costo tractable**, con su núcleo criptográfico implementado y su seguridad validada.

El hecho de que **Ethereum y Solana hayan convergido, de forma independiente y simultánea, hacia los mismos principios** que esta tesis formaliza —firmas post-cuánticas, agregación por pruebas para domar el sobrecosto, y sistemas de prueba post-cuánticos— no resta originalidad al trabajo: la **confirma**. NEXUS llega a las mismas conclusiones que la frontera de la industria por un camino formal e independiente, y deja una agenda clara para convertir el modelo en un sistema. Esa es, modestamente, su contribución.


# Bibliografía

> *Bibliografía consolidada del trabajo. Cada obra se define una sola vez bajo su clave de cita; las listas «Referencias del capítulo» que cierran cada capítulo son índices locales que remiten a esta sección.*

## Artículos, libros y actas

- **[BBC+25]** L. Beurer-Kellner, B. Buesser, A.-M. Creţu, E. Debenedetti et al. *Design Patterns for Securing LLM Agents against Prompt Injections*. arXiv:2506.08837, 2025. *(patrones de diseño con resistencia fundamentada a la inyección de prompts)*
- **[BDF+11]** D. Boneh, Ö. Dagdelen, M. Fischlin, A. Lehmann, C. Schaffner, M. Zhandry. *Random Oracles in a Quantum World*. ASIACRYPT 2011.
- **[BDGL16]** A. Becker, L. Ducas, N. Gama, T. Laarhoven. *New Directions in Nearest Neighbor Searching with Applications to Lattice Sieving*. SODA 2016. *(constante clásica de tamizado 0,292)*
- **[BSCIKS20]** E. Ben-Sasson, D. Carmon, Y. Ishai, S. Kopparty, S. Saraf. *Proximity Gaps for Reed–Solomon Codes*. FOCS 2020. *(2 bits de soundness por consulta a* rate *ρ en FRI)*
- **[Buterin21]** V. Buterin. *An Incomplete Guide to Rollups*. 2021.
- **[CD16]** V. Costan, S. Devadas. *Intel SGX Explained*. Cryptology ePrint Archive 2016/086, 2016. *(referencia canónica de TEE: integridad y confidencialidad aun con el software privilegiado comprometido)*
- **[D+18]** L. Ducas, E. Kiltz, T. Lepoint, V. Lyubashevsky, P. Schwabe, G. Seiler, D. Stehlé. *CRYSTALS-Dilithium: A Lattice-Based Digital Signature Scheme*. IACR Transactions on Cryptographic Hardware and Embedded Systems (ToCHES) 2018(1), pp. 238–268.
- **[ADP18]** M. R. Albrecht, A. Deo, K. G. Paterson. *Cold Boot Attacks on Ring and Module LWE Keys Under the NTT*. IACR TCHES 2018. *(extracción de claves reticulares desde volcados de RAM)*
- **[BRS22]** J. W. Bos, J. Renes, A. Sprenkels. *Dilithium for Memory Constrained Devices*. AFRICACRYPT 2022. *(re-derivación on-the-fly por escasez de RAM en embebidos)*
- **[DSF+25]** E. Debenedetti, I. Shumailov, T. Fan, J. Hayes, N. Carlini et al. *Defeating Prompt Injections by Design*. arXiv:2503.18813, 2025. *(CaMeL: separación de flujos de control y de datos alrededor del LLM)*
- **[FKH26]** J. Forough, M. Kogias, H. Haddadi. *When Agents Handle Secrets: A Survey of Confidential Computing for Agentic AI*. arXiv:2605.03213, 2026. *(custodia de credenciales por agentes; atestación TEE como confianza verificable)*
- **[GAM+23]** K. Greshake, S. Abdelnabi, S. Mishra, C. Endres, T. Holz, M. Fritz. *Not What You've Signed Up For: Compromising Real-World LLM-Integrated Applications with Indirect Prompt Injection*. ACM AISec 2023. *(introduce la inyección indirecta de prompts)*
- **[Gro96]** L. K. Grover. *A Fast Quantum Mechanical Algorithm for Database Search*. STOC 1996.
- **[JR13]** A. Juels, R. L. Rivest. *Honeywords: Making Password-Cracking Detectable*. ACM CCS 2013. *(patrón honeychecker: el backend detecta el uso del señuelo)*
- **[KLS18]** E. Kiltz, V. Lyubashevsky, C. Schaffner. *A Concrete Treatment of Fiat-Shamir Signatures in the Quantum Random-Oracle Model*. EUROCRYPT 2018.
- **[Kup05]** G. Kuperberg. *A Subexponential-Time Quantum Algorithm for the Dihedral Hidden Subgroup Problem*. SIAM Journal on Computing 35(1), 2005. *(barrera del HSP diédrico)*
- **[Laa15]** T. Laarhoven. *Search Problems in Cryptography* (tamizado cuántico para SVP). Tesis doctoral, TU Eindhoven, 2015. *(constante cuántica de tamizado 0,265)*
- **[LHD+26]** S. Ling, Y. Huang, Y. Du, Y. Chen, Y. Zhou, L. Wu, C. Wang. *Free-Riding the Agentic Web: A Systematic Security Analysis of x402 Payments*. arXiv:2605.30998, 2026. *(~130M de transacciones x402; 4 clases de vulnerabilidades con fuga de hasta 100%)*
- **[LS15]** A. Langlois, D. Stehlé. *Worst-Case to Average-Case Reductions for Module Lattices*. Designs, Codes and Cryptography 75(3), pp. 565–599, 2015.
- **[LWW26]** Z. Li, Q. Wang, Z. Wang. *Five Attacks on x402 Agentic Payment Protocol*. arXiv:2605.11781, 2026. *(cinco ataques concretos validados en redes reales)*
- **[Lyu09]** V. Lyubashevsky. *Fiat-Shamir with Aborts: Applications to Lattice and Factoring-Based Signatures*. ASIACRYPT 2009. *(origen de la técnica rejection-sampling / aborts)*
- **[Lyu12]** V. Lyubashevsky. *Lattice Signatures without Trapdoors*. EUROCRYPT 2012. *(esquema del que desciende Dilithium)*
- **[Pei16]** C. Peikert. *A Decade of Lattice Cryptography*. Foundations and Trends in Theoretical Computer Science, 2016.
- **[PZW+26]** Z. Peng, C. Zhao, T. Wang et al. *A Survey of Zero-Knowledge Proof Based Verifiable Machine Learning*. Artificial Intelligence Review 59:157, 2026. *(zkML prueba que la salida proviene del cómputo declarado — integridad de inferencia, no de intención)*
- **[Reg09]** O. Regev. *On Lattices, Learning with Errors, Random Linear Codes, and Cryptography*. Journal of the ACM 56(6), 2009.
- **[Sawa25]** Y. Sawa et al. *Analysis of Encryption Key Zeroization from a System-Wide Perspective*. ACSAC 2025. *(medición empírica de la residencia de claves en RAM)*
- **[SLZ24]** H. Sun, J. Li, H. Zhang. *zkLLM: Zero Knowledge Proofs for Large Language Models*. ACM CCS 2024. *(primeras pruebas ZK para LLMs de 13B parámetros)*
- **[Sho97]** P. W. Shor. *Polynomial-Time Algorithms for Prime Factorization and Discrete Logarithms on a Quantum Computer*. SIAM Journal on Computing 26(5), 1997.
- **[Yang23]** Z. Yang, H. Alfauri, B. Farkiani, R. Jain, R. Di Pietro, A. Erbad. *A Survey and Comparison of Post-Quantum and Quantum Blockchains*. IEEE Communications Surveys & Tutorials, 2023.
- **[ZXL+26]** Y. Zhang, Y. Xiang, Y. Lei, Q. Wang et al. *SoK: Blockchain Agent-to-Agent Payments*. arXiv:2604.03733, 2026. *(brechas abiertas del campo: weak intent binding, misuse under valid authorization, limited accountability)*

## Estándares (NIST / IETF)

- **[FIPS203]** NIST. *FIPS 203: Module-Lattice-Based Key-Encapsulation Mechanism Standard (ML-KEM)*. 2024.
- **[NIST24]** NIST. *FIPS 204: Module-Lattice-Based Digital Signature Standard (ML-DSA)*. 2024. *(estándar del esquema de firma usado por NEXUS; implementado vía el crate `fips204`)*
- **[FIPS205]** NIST. *FIPS 205: Stateless Hash-Based Digital Signature Standard (SLH-DSA)*. 2024.
- **[FIPS206]** NIST. *FIPS 206: FN-DSA (Falcon)* — borrador (estandarización ~fin 2026).
- **[SP800-90B]** M. S. Turan et al. *NIST SP 800-90B: Recommendation for the Entropy Sources Used for Random Bit Generation*. NIST, 2018. *(min-entropía y pruebas de salud RCT/APT; complementan SP 800-90A/C sobre DRBG y construcciones RBG)*
- **[SP800-108]** NIST. *SP 800-108: Recommendation for Key Derivation Using Pseudorandom Functions*.
- **[RFC5869]** H. Krawczyk. *Cryptographic Extraction and Key Derivation: The HKDF Scheme*. CRYPTO 2010 (RFC 5869).
- **[RFC9881]** J. Massimo, P. Kampanakis, S. Turner, B. Westerbaan. *RFC 9881: Internet X.509 PKI — Algorithm Identifiers for ML-DSA*. IETF, 2025. *(la semilla ξ como formato RECOMENDADO de clave privada ML-DSA)*
- **[Connolly26]** D. Connolly. *ML-DSA Security Considerations*. draft-connolly-cfrg-ml-dsa-security-considerations, IETF (borrador), 2026. *(recomienda seed-only; sugiere cachear la clave expandida durante las operaciones — contrapunto de la política de §5.6)*

## Informes de seguridad (OWASP)

- **[OWASP-LLM25]** OWASP GenAI Security Project. *OWASP Top 10 for LLM Applications 2025*. Nov. 2024. genai.owasp.org. *(LLM01:2025 Prompt Injection — #1 por segunda edición consecutiva; distinción entre inyección directa e indirecta)*
- **[OWASP-ASI26]** OWASP GenAI Security Project. *OWASP Top 10 for Agentic Applications 2026*. Dic. 2025. genai.owasp.org. *(riesgos agénticos: Tool Misuse, Agent Goal Hijack, Identity & Privilege Abuse, Memory Poisoning)*
- **[OWASP-ATM25]** OWASP Agentic Security Initiative. *Agentic AI — Threats and Mitigations*, v1.0. Feb. 2025. genai.owasp.org. *(taxonomía T1–T15; T2 Tool Misuse, T6 Intent Breaking y T9 Identity Spoofing aplican al agente pagador; actualizado por «State of Agentic AI Security and Governance» v2.01, jun. 2026)*

## Fuentes del estado del arte (industria; estado a mediados de 2026)

- **[EthRoadmap26]** Ethereum Foundation. *Roadmap — Future-proofing: Quantum resistance* (Lean Consensus / leanXMSS; leanVM; abstracción de cuentas EIP-7702, EIP-8141). ethereum.org/roadmap/future-proofing/quantum-resistance. Acceso: jun. 2026.
- **[Fusaka25]** Ethereum Foundation. *Fusaka Mainnet — PeerDAS (EIP-7594)*. Nov. 2025.
- **[Solana-QR26]** Solana / Anza. *Quantum Readiness* (Falcon; Winternitz Vault) y *Alpenglow* (Votor/Rotor, 2025–2026). Acceso: jun. 2026.
- **[US10521584]** N. Sharifi Mehr (Amazon Technologies). *Computer Threat Analysis Service*. Patente US 10,521,584 B1, 2019. *(claves criptográficas señuelo detectadas por el backend al verificar la firma — prior art más cercano del Deception Engine)*
- **[Puffer23]** Puffer Finance. *Secure-Signer + RAVe* (claves de validador selladas en SGX; atestación remota verificada on-chain). 2023–2025.
- **[RollupBoost25]** Flashbots. *Rollup-Boost* (block builder de L2 en TEE, desplegado en Unichain). 2025.
- **[AP2-25]** Google Cloud. *Agent Payments Protocol (AP2)* — mandates firmados como credenciales digitales verificables; 60+ socios. Anunciado 16 sep. 2025; donado a la FIDO Alliance en abr. 2026. github.com/google-agentic-commerce/AP2. Acceso: ago. 2026.
- **[x402-25]** Coinbase. *x402: An Open Standard for Internet-Native Payments* (whitepaper, mayo 2025) — HTTP 402 + EIP-3009; micropagos USDC/Base. x402 Foundation bajo la Linux Foundation desde abr. 2026. x402.org. Acceso: ago. 2026. *(~130M de transacciones acumuladas a may. 2026 según [LHD+26]; no usar cifras de marketing)*
- **[VisaIC25]** Visa. *Visa Intelligent Commerce* (abr. 2025) y *Trusted Agent Protocol* (oct. 2025, con Cloudflare; identificación criptográfica de agentes vía HTTP Message Signatures). Acceso: ago. 2026.
- **[AgentPay25]** Mastercard. *Agent Pay* (abr. 2025; Agentic Tokens) y *Agent Toolkit* MCP (sep. 2025). Acceso: ago. 2026.
- **[ACP25]** OpenAI + Stripe. *Agentic Commerce Protocol / Instant Checkout* (sep. 2025; Shared Payment Tokens acotados por comercio y monto). Instant Checkout retirado en mar. 2026. Acceso: ago. 2026. *(evidencia de inmadurez de la capa de ejecución de pagos agénticos)*

> *Documentos companion del trabajo (no publicados): `Analisis-Overhead-PQC-DualChain` (argumentación cuantificada del overhead), `Ideas-Ethereum-Solana-para-NEXUS` (validación detallada de las fuentes de la industria), `Estado-del-Arte-Claves-Efimeras-y-Deception` (revisión con fuentes verificadas, jul. 2026, que sustenta §5.6 y §7.5) y `Estado-del-Arte-Pagos-Agenticos` (revisión ago. 2026: protocolos de pago agéntico, OWASP y literatura x402/zkML/TEE que sustenta el caso de uso agéntico).*
