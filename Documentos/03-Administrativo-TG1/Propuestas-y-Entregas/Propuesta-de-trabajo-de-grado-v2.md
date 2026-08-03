---
title: |
  Arquitectura Blockchain Dual NEXUS:
  Un Modelo Matemático-Computacional para Sistemas Bancarios
  Seguros y Resilientes Post-Cuántico
subtitle: "Propuesta de trabajo de grado — versión revisada"
author: Juan Diego Susunaga Velasquez
date: "Dirección: Leonardo Huertas Calle · Universidad del Rosario, Escuela de Ciencias e Ingeniería · Revisión: 04/06/2026 (propuesta original: 09/12/2025)"
lang: es
---

> **Nota de revisión.** Esta versión **acota y profundiza** el alcance de la propuesta original para concentrar el trabajo en su contribución central y verificable: un **modelo formal y prototipo de referencia de firmas post-cuánticas (CRYSTALS-Dilithium) sobre una arquitectura blockchain dual orientada a banca**, con **validación formal** de seguridad y complejidad. Respecto de la versión del 09/12/2025 se introducen dos cambios de fondo: (a) se **elimina** la autenticación biométrica / extractor difuso; (b) se **reformula la lógica de entropía** sobre bases criptográficas estándar (min-entropía de la fuente, pruebas de salud NIST SP 800-90B, derivación por KDF y rotación con secrecia hacia adelante), en lugar de emplear la entropía de Shannon de la semilla como métrica de seguridad. Las pruebas de conocimiento cero y el consenso BFT operativo se conservan como **diseño de referencia y trabajo futuro**.

---

# 1. Introducción

Esta propuesta aborda la necesidad crítica de asegurar la infraestructura financiera digital ante la inminente amenaza de la computación cuántica. La arquitectura Dual NEXUS se justifica como una solución que articula el **Trilema de la Blockchain** (escalabilidad, seguridad y descentralización) con la mitigación del ataque **"Harvest Now, Decrypt Later" (HNDL)** [10], en el que datos cifrados con criptografía clásica hoy podrían ser descifrados por ordenadores cuánticos en el futuro.

El trabajo se enmarca en la evolución de las soluciones de escalabilidad (ZK-Rollups y Optimistic Rollups) y en los estándares de Criptografía Post-Cuántica (PQC) de NIST [4], [15]. El aporte central de esta propuesta es el **diseño formal y la validación matemática** de un sistema *Dual-Chain* —**Anchor Layer (L1)** para consenso y disponibilidad de datos, y **Active Layer (L2)** para ejecución verificable— cuyo **núcleo criptográfico de firmas post-cuánticas (CRYSTALS-Dilithium)** se implementa y se **valida formalmente**.

A diferencia de un desarrollo de producción, el entregable de este trabajo de grado es un **modelo matemático-computacional** acompañado de un **prototipo de referencia**: la arquitectura dual se *especifica* y se *modela*; el núcleo de firmas PQC y la gestión activa de claves se *implementan* y se *verifican*; y la seguridad se *valida formalmente* mediante reducciones criptográficas y análisis de complejidad. Los componentes de computación verificable (pruebas de conocimiento cero) y el consenso bizantino operativo se entregan como diseño de referencia, con su realización completa delimitada como trabajo futuro (véase §3, Alcance).

# 2. Fundamentos teóricos y descripción del problema

## 2.1 Descripción del problema

La amenaza central es la vulnerabilidad de la criptografía clásica (p. ej. RSA/ECC) frente al **algoritmo de Shor**, que permitiría la ruptura de los esquemas de firma y cifrado que sustentan la banca digital. Específicamente, el problema **HNDL** plantea que la información y las claves interceptadas hoy deben protegerse desde ya con esquemas post-cuánticos para garantizar su seguridad futura [4], [10]. En el contexto de una blockchain bancaria, esto implica que **las firmas digitales que autorizan transacciones** —cuyo material puede ser cosechado y cuya falsificabilidad comprometería la integridad del libro mayor— constituyen el punto crítico a proteger.

## 2.2 Fundamentos teóricos clave

El desarrollo metodológico se fundamenta en tres pilares:

1. **Criptografía basada en retículos (Lattice-based Cryptography).** Se emplean los retículos y el problema **Module-LWE** (y su contraparte **Module-SIS**) como fundamento post-cuántico, implementando el esquema de firma **CRYSTALS-Dilithium** (NIST FIPS 204 / ML-DSA) [14], [15] por su resistencia conjeturada frente a adversarios cuánticos.

2. **Gestión activa del ciclo de vida de claves basada en entropía.** En lugar de tratar la entropía de Shannon de una semilla como métrica de seguridad, se adopta el marco estándar: (i) la **min-entropía de la fuente** $H_\infty(X) = -\log_2 \max_x \Pr[X=x]$ como medida pertinente para material de clave; (ii) el **monitoreo de salud en línea** del generador conforme a **NIST SP 800-90B** [20] (pruebas *Repetition Count Test* y *Adaptive Proportion Test*); (iii) la **derivación determinística de claves** mediante una función de derivación (KDF) con separación de dominio [21]; y (iv) la **rotación con secrecia hacia adelante** disparada por política (uso, antigüedad o fallo de las pruebas de salud).

3. **Validación formal.** Se aplica una metodología de validación matemática consistente en (i) una **reducción de seguridad** de la in-forjabilidad de Dilithium a Module-LWE, SelfTargetMSIS y Module-SIS, y de éstos —vía reducciones de peor caso— a Mod-SIVP [18], [19]; y (ii) un **análisis de complejidad computacional** (notación O) de la verificación de firmas y del *overhead* del esquema dual.

Como **contexto sistémico**, la arquitectura dual L1/L2 incorpora en su diseño la computación verificable (Nitro Verifier basado en pruebas de conocimiento cero) y un análisis de incentivos del secuenciador mediante teoría de juegos (matriz de pagos / equilibrio de Nash). Estos elementos se modelan a nivel de especificación; su implementación operativa completa se delimita como trabajo futuro.

# 3. Alcance

## 3.1 Dentro del alcance

1. **Diseño y especificación** de la arquitectura dual-chain (Anchor Layer L1 / Active Layer L2) como modelo de referencia, delimitando el **camino de la firma post-cuántica** a través del sistema (creación de la transacción → secuenciación → ejecución/verificación → asentamiento en L1).
2. **Implementación verificada** del esquema de firma CRYSTALS-Dilithium (niveles 2/3/5) y su enlace criptográfico a las transacciones, sobre una biblioteca PQC auditada.
3. **Derivación determinística de claves** a partir de una semilla de alta entropía mediante un KDF con separación de dominio.
4. **Gestión activa del ciclo de vida de claves**: estimación de min-entropía, pruebas de salud (NIST SP 800-90B) y rotación con secrecia hacia adelante, con registro auditable.
5. **Validación formal**: reducción de seguridad y análisis de complejidad, complementados con *benchmarks* empíricos.

## 3.2 Fuera del alcance (declarado explícitamente)

- **Autenticación biométrica y extractores difusos** (eliminados de esta versión).
- **Implementación operativa** de: la capa de pruebas de conocimiento cero (ZK/Groth16 – Nitro Verifier), el protocolo de consenso BFT en red (verificación de votos, *slashing*, difusión) y la disponibilidad de datos con *erasure coding*. Se entregan como **diseño/modelo de referencia y trabajo futuro**.
- **Resistencia a canales laterales** y seguridad de implementación (se asume el modelo de caja negra / QROM).
- **Despliegue en producción**, red P2P operativa y servidor RPC.

# 4. Objetivos

## 4.1 Objetivo general

Diseñar, modelar y **validar formalmente** un **modelo matemático-computacional de firmas digitales post-cuánticas (CRYSTALS-Dilithium)** para una **arquitectura blockchain dual** orientada a sistemas bancarios resilientes, incorporando la **gestión activa del ciclo de vida de claves** y la **prueba formal** de su seguridad (reducción a Module-LWE) y de su complejidad computacional.

## 4.2 Objetivos específicos

1. **Diseñar la arquitectura del sistema Dual-Chain** como modelo de referencia, especificando los roles funcionales de la **Anchor Layer (L1)** y la **Active Layer (L2)**, el **camino de la firma post-cuántica** a través del consenso y el asentamiento, y los componentes clave (**Nexus Sequencer**, **Nitro Verifier**) a nivel de especificación.

2. **Desarrollar e implementar el núcleo matemático y criptográfico** del sistema, formalizando e implementando de forma verificada el esquema de firma PQC **CRYSTALS-Dilithium** (generación de claves, firma y verificación) y la **derivación determinística de claves a partir de una semilla** mediante una función de derivación de claves (KDF). *(La generación determinística desde semilla está estandarizada en FIPS 204/ML-DSA, lo que sustituye con base sólida la derivación biométrica de la versión previa.)*

3. **Modelar e implementar la lógica de seguridad activa** del ciclo de vida de claves, definiendo: (i) la **función de monitoreo de la fuente de entropía** basada en min-entropía y pruebas de salud en línea (NIST SP 800-90B); y (ii) el **algoritmo de rotación de claves con secrecia hacia adelante**, disparado por política (uso, antigüedad o fallo de salud), con bloqueo de derivación ante degradación de la fuente.

4. **Formalizar y validar la seguridad y la complejidad** del sistema, incluyendo (i) la **prueba de dureza post-cuántica** mediante la reducción de la in-forjabilidad de Dilithium a Module-LWE, SelfTargetMSIS y Module-SIS, y de éstos a Mod-SIVP de peor caso (con el argumento de no aplicabilidad del algoritmo de Shor); y (ii) el **análisis de complejidad computacional** (notación O) de la verificación de firmas PQC y del *overhead* del esquema dual, validado empíricamente con *benchmarks*.

# 5. Cronograma de actividades

## Trabajo de grado 1

| Objetivo específico | Actividades |
|---|---|
| **Obj. 1** — Diseñar la arquitectura Dual-Chain (modelo de referencia). | **1.1** Revisión del estado del arte (blockchains post-cuánticos [1], [13] y *rollups* L1/L2) y justificación de la arquitectura dual. · **1.2** Especificación del modelo de capas (L1/L2), del **camino de verificación de la firma PQC** y de los componentes funcionales (Nexus Sequencer, Nitro Verifier); opcionalmente, análisis de incentivos del secuenciador (equilibrio de Nash). |
| **Obj. 2** — Desarrollar el núcleo matemático y criptográfico. | **2.1** Definición formal de retículos, Module-LWE y del esquema de firma (abstracción de Dilithium). · **2.2** Implementación verificada de firma/verificación con enlace a la transacción, y **derivación determinística semilla → clave** mediante KDF. |

## Trabajo de grado 2

| Objetivo específico | Actividades |
|---|---|
| **Obj. 3** — Modelar la lógica de seguridad activa. | **3.1** Modelo de la fuente de entropía: min-entropía y pruebas de salud en línea (RCT/APT, NIST SP 800-90B); implementación. · **3.2** Algoritmo de rotación con secrecia hacia adelante por política y registro auditable; pruebas que demuestren el bloqueo ante degradación de la fuente. |
| **Obj. 4** — Formalizar y validar la seguridad. | **4.1** Desarrollo de la cadena de reducciones (in-forjabilidad → Module-LWE / SelfTargetMSIS / Module-SIS → Mod-SIVP) y el argumento de resistencia cuántica. · **4.2** Análisis de complejidad computacional (costo de verificación PQC y *overhead* dual) y validación empírica con *benchmarks*. |

# 6. Referencias

[1] Z. Yang, H. Alfauri, B. Farkiani, R. Jain, R. Di Pietro y A. Erbad, «A Survey and Comparison of Post-Quantum and Quantum Blockchains,» *IEEE Communications Surveys & Tutorials*, 2023.

[2] M. Nofer, P. Gomber, O. Hinz y D. Schiereck, «Blockchain,» *Business & Information Systems Engineering*, vol. 59, n.º 3, pp. 183-187, 2017.

[3] J. H. Fuenmayor Tobar, D. K. Torres Lozano, L. D. Monsalve Pérez y A. M. Becerra Moreno, «La inteligencia artificial y Blockchain, dos elementos decisivos en el futuro de la ciberseguridad,» *Revista Blockchain E Inteligencia Artificial*, 2024.

[4] D. Joseph et al., «Transitioning organizations to post-quantum cryptography,» *Nature*, vol. 605, pp. 237-243, 2022.

[5] J. Díaz, M. D. Tugnarelli, M. F. Fornaroli, L. Barboza, F. Miño y J. I. Carubia Grieco, «Protocolos de consenso,» en *XXVII Congreso Argentino de Ciencias de la Computación (CACIC 2021)*, 2021.

[6] S. Halevi y H. Krawczyk, «Public-Key Cryptography and Password Protocols,» *ACM Transactions on Information and System Security*, vol. 2, n.º 3, pp. 230-268, 1999.

[7] G. A. Oliva, A. E. Hassan y Z. M. Jiang, «An exploratory study of smart contracts in the Ethereum blockchain platform,» *Empirical Software Engineering*, vol. 25, pp. 1864-1904, 2020.

[8] V. Mulder, A. Mermoud, V. Lenders y B. Tellenbach, Eds., *Trends in Data Protection and Encryption Technologies*. Cham: Springer Nature Switzerland AG, 2023.

[9] A. Villalón-Huerta, I. Ripoll-Ripoll y H. Marco-Gisbert, «Key Requirements for the Detection and Sharing of Behavioral Indicators of Compromise,» *Electronics*, vol. 11, n.º 3, p. 416, 2022.

[10] J. Mascelli y M. Rodden, «"Harvest Now Decrypt Later": Examining Post-Quantum Cryptography and the Data Privacy Risks for Distributed Ledger Networks,» *Finance and Economics Discussion Series 2025-093*, Board of Governors of the Federal Reserve System, Washington, D.C., 2025.

[11] J. Gómez Manchola, «Implementación Hardware de Funciones Hash para Criptografía Post-cuántica,» Trabajo de Fin de Máster, Universidad Complutense de Madrid, Madrid, 2025.

[12] O. H. Abdulganiyu, T. A. Tchakoucht y Y. K. Saheed, «A systematic literature review for network intrusion detection system (IDS),» *International Journal of Information Security*, vol. 22, pp. 1125-1162, 2023.

[13] G. R. Pandeya, T. U. Daim y A. Marotzke, «A Strategy Roadmap for Post-quantum Cryptography,» en *Roadmapping Future: Technologies, Products and Services*, T. U. Daim, Ed., Cham: Springer Nature Switzerland AG, 2021, pp. 171-208.

[14] L. Ducas, E. Kiltz, T. Lepoint, V. Lyubashevsky, P. Schwabe, G. Seiler y D. Stehlé, «CRYSTALS-Dilithium: A Lattice-Based Digital Signature Scheme,» *IACR Transactions on Cryptographic Hardware and Embedded Systems*, vol. 2018, n.º 1, pp. 238-268, 2018.

[15] National Institute of Standards and Technology, «FIPS 204: Module-Lattice-Based Digital Signature Standard (ML-DSA),» 2024.

[16] E. Kiltz, V. Lyubashevsky y C. Schaffner, «A Concrete Treatment of Fiat-Shamir Signatures in the Quantum Random-Oracle Model,» en *EUROCRYPT 2018*, 2018.

[17] V. Lyubashevsky, «Fiat-Shamir with Aborts: Applications to Lattice and Factoring-Based Signatures,» en *ASIACRYPT 2009*, 2009.

[18] A. Langlois y D. Stehlé, «Worst-Case to Average-Case Reductions for Module Lattices,» *Designs, Codes and Cryptography*, vol. 75, n.º 3, pp. 565-599, 2015.

[19] O. Regev, «On Lattices, Learning with Errors, Random Linear Codes, and Cryptography,» *Journal of the ACM*, vol. 56, n.º 6, pp. 1-40, 2009.

[20] M. S. Turan et al., «NIST Special Publication 800-90B: Recommendation for the Entropy Sources Used for Random Bit Generation,» National Institute of Standards and Technology, 2018.

[21] H. Krawczyk, «Cryptographic Extraction and Key Derivation: The HKDF Scheme,» en *CRYPTO 2010*, 2010 (RFC 5869).

[22] C. E. Shannon, «A Mathematical Theory of Communication,» *Bell System Technical Journal*, vol. 27, pp. 379-423, 1948.
