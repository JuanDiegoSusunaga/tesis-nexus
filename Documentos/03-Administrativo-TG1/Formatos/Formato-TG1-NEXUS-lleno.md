![](media/image1.png){width="3in"}

**ARQUITECTURA BLOCKCHAIN DUAL NEXUS: UN MODELO MATEMÁTICO-COMPUTACIONAL PARA SISTEMAS BANCARIOS SEGUROS Y RESILIENTES POST-CUÁNTICO**

Juan Diego Susunaga Velasquez

Dirección: Leonardo Huertas Calle

Programa académico: Matemáticas Aplicadas y Ciencias de la Computación

Escuela de Ciencias e Ingeniería

Universidad del Rosario

05/06/2026

```{=openxml}
<w:p><w:r><w:br w:type="page"/></w:r></w:p>
```

# INTRODUCCIÓN

La infraestructura financiera digital depende de firmas digitales (RSA, ECC). El algoritmo de Shor las rompería en tiempo polinómico, y el fenómeno *Harvest Now, Decrypt Later* obliga a migrar **desde ya** a criptografía post-cuántica (PQC) —tendencia confirmada por la estandarización del NIST (FIPS 204, 2024) y por la migración en curso de las cadenas líderes (Ethereum y Solana). Este trabajo propone **NEXUS**, un **modelo matemático-computacional y prototipo de referencia** que asegura las firmas de una blockchain bancaria mediante el esquema post-cuántico **CRYSTALS-Dilithium** sobre una **arquitectura dual-chain** (capa de anclaje L1 + capa de ejecución L2). A lo largo del trabajo se construye: (i) la especificación de la arquitectura dual, (ii) la implementación verificada del núcleo de firma Dilithium, (iii) la gestión activa del ciclo de vida de claves, y (iv) la validación formal de su seguridad y complejidad.

# DESCRIPCIÓN DEL PROBLEMA

La amenaza cuántica concreta sobre una blockchain es la **falsificación de firmas**: al estar expuestas las claves públicas en cadena, un adversario cuántico puede recuperar la clave privada (Shor) y suplantar cuentas o robar fondos. Adoptar firmas post-cuánticas neutraliza esa amenaza, pero introduce un **sobrecosto de datos**: una firma Dilithium es ~50× mayor que una ECDSA (3 309 B frente a 64 B), lo que en una blockchain de cadena única degrada el rendimiento ~20× y reabre el trilema de la blockchain (escalabilidad, seguridad, descentralización). El problema central que aborda este trabajo es, por tanto: **¿cómo asegurar las firmas de una blockchain bancaria contra la amenaza cuántica sin sacrificar la escalabilidad?**

# FUNDAMENTOS TEÓRICOS

El desarrollo metodológico se fundamenta en tres pilares. **(1) Criptografía basada en retículos:** los problemas *Module-LWE* y *Module-SIS* sobre el anillo $R_q = \mathbb{Z}_q[X]/(X^n+1)$ sustentan el esquema de firma CRYSTALS-Dilithium (FIPS 204 / ML-DSA), cuya in-forjabilidad se reduce, vía reducciones de peor caso, a problemas reticulares (Mod-SIVP) que se conjeturan difíciles incluso para adversarios cuánticos (el algoritmo de Shor no se les aplica). **(2) Gestión activa de claves:** la *min-entropía* de la fuente de aleatoriedad y las pruebas de salud en línea de NIST SP 800-90B (RCT y APT), junto con la derivación por KDF y la rotación con secrecia hacia adelante. **(3) Validación formal:** una metodología de reducción de seguridad y un análisis de complejidad computacional (notación O). El marco arquitectónico lo aporta la estructura dual-chain (rollups L1/L2) y la **coherencia post-cuántica** de su sistema de pruebas (STARK, no esquemas basados en emparejamientos, que serían rotos por Shor).

# OBJETIVOS

## Objetivo general

Diseñar, modelar y **validar formalmente** un modelo matemático-computacional de firmas digitales post-cuánticas (CRYSTALS-Dilithium) para una arquitectura blockchain dual orientada a sistemas bancarios resilientes, incorporando la gestión activa del ciclo de vida de claves y la prueba formal de su seguridad (reducción a Module-LWE) y de su complejidad computacional.

## Objetivos específicos

1. **Diseñar la arquitectura del sistema Dual-Chain** como modelo de referencia, especificando los roles funcionales de la Anchor Layer (L1) y la Active Layer (L2), el camino de la firma post-cuántica y los componentes clave (Nexus Sequencer, Nitro Verifier).
2. **Desarrollar e implementar el núcleo matemático y criptográfico**, formalizando e implementando de forma verificada el esquema de firma PQC CRYSTALS-Dilithium y la derivación determinística de claves a partir de una semilla mediante un KDF.
3. **Modelar e implementar la lógica de seguridad activa** del ciclo de vida de claves: monitoreo de la fuente de entropía basado en min-entropía y pruebas de salud en línea (NIST SP 800-90B), y rotación de claves con secrecia hacia adelante.
4. **Formalizar y validar la seguridad y la complejidad**: reducción de la in-forjabilidad de Dilithium a Module-LWE, SelfTargetMSIS y Module-SIS (y de éstos a Mod-SIVP de peor caso), con el argumento de no aplicabilidad del algoritmo de Shor; y análisis de complejidad computacional (notación O) de la verificación de firmas.

*Nota: los objetivos específicos se ajustaron respecto de la propuesta inicial (se eliminó la autenticación biométrica y se reformuló el monitoreo de entropía sobre min-entropía y NIST SP 800-90B); la justificación se presenta en el formato de modificación de objetivos.*

# CRONOGRAMA DE ACTIVIDADES

**Trabajo de grado 1:**

| **Objetivos específicos** | **Actividad** |
|---|---|
| Objetivo 1: Diseñar la arquitectura Dual-Chain. | 1.1 Revisión del estado del arte (blockchains post-cuánticos y *rollups*) y justificación de la arquitectura dual. |
|  | 1.2 Especificación del modelo de capas (L1/L2) y del camino de verificación de la firma PQC. |
| Objetivo 2: Desarrollar el núcleo matemático y criptográfico. | 2.1 Formalización de retículos, Module-LWE y del esquema de firma (Dilithium). |
|  | 2.2 Implementación verificada de firma/verificación con enlace a la transacción y derivación determinística semilla → clave por KDF. |

**Trabajo de grado 2:**

| **Objetivos específicos** | **Actividad** |
|---|---|
| Objetivo 3: Modelar la lógica de seguridad activa. | 3.1 Modelo de la fuente de entropía: min-entropía y pruebas de salud en línea (RCT/APT, NIST SP 800-90B). |
|  | 3.2 Algoritmo de rotación con secrecia hacia adelante por política y registro auditable. |
| Objetivo 4: Formalizar y validar la seguridad. | 4.1 Desarrollo de la cadena de reducciones (in-forjabilidad → Module-LWE / SelfTargetMSIS / Module-SIS → Mod-SIVP). |
|  | 4.2 Análisis de complejidad computacional y validación empírica (*benchmarks*). |

# PRESUPUESTO

El trabajo es de naturaleza teórico-computacional y **no requiere recursos especiales ni presupuesto adicional**. Los recursos necesarios son:

| **Recurso** | **Descripción** | **Costo** |
|---|---|---|
| Equipo de cómputo | Computador personal para desarrollo, pruebas y *benchmarks*. | $0 (existente) |
| Software | Rust/Cargo y bibliotecas de código abierto (`fips204`, `arkworks`), pandoc. | $0 (libre) |
| Bibliografía | Acceso a recursos electrónicos (IEEE, Springer, etc.). | $0 (institucional, U. del Rosario) |

# REFERENCIAS

[1] Z. Yang, H. Alfauri, B. Farkiani, R. Jain, R. Di Pietro y A. Erbad, «A Survey and Comparison of Post-Quantum and Quantum Blockchains,» *IEEE Communications Surveys & Tutorials*, 2023.

[2] L. Ducas, E. Kiltz, T. Lepoint, V. Lyubashevsky, P. Schwabe, G. Seiler y D. Stehlé, «CRYSTALS-Dilithium: A Lattice-Based Digital Signature Scheme,» *IACR Trans. on Cryptographic Hardware and Embedded Systems*, vol. 2018, n.º 1, pp. 238-268, 2018.

[3] National Institute of Standards and Technology, «FIPS 204: Module-Lattice-Based Digital Signature Standard (ML-DSA),» 2024.

[4] E. Kiltz, V. Lyubashevsky y C. Schaffner, «A Concrete Treatment of Fiat-Shamir Signatures in the Quantum Random-Oracle Model,» en *EUROCRYPT*, 2018.

[5] V. Lyubashevsky, «Fiat-Shamir with Aborts: Applications to Lattice and Factoring-Based Signatures,» en *ASIACRYPT*, 2009.

[6] A. Langlois y D. Stehlé, «Worst-Case to Average-Case Reductions for Module Lattices,» *Designs, Codes and Cryptography*, vol. 75, n.º 3, pp. 565-599, 2015.

[7] O. Regev, «On Lattices, Learning with Errors, Random Linear Codes, and Cryptography,» *Journal of the ACM*, vol. 56, n.º 6, 2009.

[8] M. S. Turan *et al.*, «NIST SP 800-90B: Recommendation for the Entropy Sources Used for Random Bit Generation,» NIST, 2018.

[9] V. Buterin, «An Incomplete Guide to Rollups,» 2021.
