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
