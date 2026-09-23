# Capítulo 2 — Marco Teórico y Estado del Arte

*Fundamentos y posicionamiento del trabajo*

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

**Tabla 2.1 — El panorama PQC y la estandarización NIST.**

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

**Posicionamiento.** NEXUS no inventa la categoría ni un resultado de frontera; su aporte es la **síntesis formal y cuantificada** para sistemas en general (Cap. 1, §1.4). Crucialmente, la industria **converge independientemente** hacia los mismos principios que NEXUS formaliza —firmas post-cuánticas, agregación por pruebas para domar el overhead, y sistemas de prueba post-cuánticos (STARK)—, lo que **valida** la dirección del trabajo. La divergencia en la elección de esquema (Ethereum→hash-based, Solana→Falcon, NEXUS→Dilithium) evidencia que la decisión debe justificarse según las prioridades de cada sistema, como hace NEXUS (Cap. 4, §4.6).

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
