# Capítulo 1 — Introducción

### (Planteamiento del problema, modelo de amenaza, requisitos de dominio y objetivos)

> **Rol en el arco de la tesis.** Este capítulo abre el arco narrativo: establece la **amenaza** (cuántica a las firmas de banca), fija el **modelo de amenaza preciso** y los **requisitos del dominio bancario** que el sistema debe satisfacer, anticipa la **solución** (firmas post-cuánticas) y su **costo** (que motiva el dual-chain), y enuncia los objetivos, el alcance y la contribución. Los desarrollos correspondientes están en los Capítulos 3–6.

---

## 1.1 Contexto y motivación

La infraestructura financiera digital descansa, en su raíz, sobre la criptografía de clave pública: las **firmas digitales** autorizan transacciones y los esquemas de cifrado protegen la confidencialidad. Hoy esa criptografía es, casi universalmente, **RSA** y **criptografía de curva elíptica (ECC)**, cuya seguridad se apoya en la dureza de la factorización y del logaritmo discreto.

La computación cuántica amenaza ese cimiento. El **algoritmo de Shor** resuelve ambos problemas en **tiempo polinómico** sobre un computador cuántico suficientemente grande, rompiendo RSA y ECC. Aunque tal computador no existe aún, la amenaza es **presente** por el fenómeno **"Harvest Now, Decrypt Later" (HNDL)**: un adversario puede **cosechar hoy** información (datos cifrados, claves públicas expuestas) y **explotarla mañana**, cuando disponga de capacidad cuántica. Para infraestructura bancaria —cuyos activos y secretos tienen vida útil de décadas— esto exige adoptar **criptografía post-cuántica (PQC)** **desde ya**, no cuando la amenaza se materialice (requisito **R2**, §1.3). La estandarización del NIST (FIPS 203/204/205, finalizados en 2024) y la migración de las grandes cadenas (Cap. 2) confirman que esta transición está en marcha.

## 1.2 Modelo de amenaza

Una validación de seguridad requiere un modelo de amenaza **preciso**. NEXUS distingue cuidadosamente dos amenazas cuánticas, frecuentemente confundidas:

**(A) Amenaza a la confidencialidad (HNDL en sentido estricto).** Datos cifrados con un esquema clásico y cosechados hoy podrían descifrarse en el futuro. Mitigar esto requiere un **mecanismo de encapsulado de claves (KEM) post-cuántico** (p. ej. ML-KEM / Kyber, FIPS 203). **Esta amenaza queda fuera del alcance** de esta tesis, que se centra en las firmas; se enuncia como trabajo futuro (Cap. 7).

**(B) Amenaza a la autenticación (el foco de NEXUS).** En una blockchain, la **clave pública** de una cuenta queda **expuesta** (almacenada en cadena, o revelada al firmar una transacción). Un adversario cuántico que observe esa clave pública puede, mediante Shor, **recuperar la clave privada** y con ella **falsificar firmas**: robar fondos, suplantar cuentas, corromper el libro mayor. **Este es el activo crítico que NEXUS protege**, sustituyendo ECDSA por un esquema de firma post-cuántico (CRYSTALS-Dilithium, Cap. 4) cuya in-forjabilidad se valida formalmente (Cap. 6).

**Adversario.** Se considera un adversario con capacidad de cómputo cuántico (incluido el acceso al oráculo de hash en superposición, QROM, Cap. 6), capaz de observar todos los datos públicos de la cadena. **No** se consideran (fuera de alcance) los ataques de implementación (canales laterales, fallos) ni la seguridad del consenso (que se asume honesto-mayoritario; Cap. 3, §3.10).

**Mitigación complementaria — revelar-al-gastar.** Como defensa en profundidad frente a la amenaza (B), NEXUS deriva la **dirección como un hash de la clave pública** ($\text{dirección} = H(pk)$). Así, mientras una cuenta no haya gastado, el adversario solo ve un hash y **no puede recuperar la clave** (Shor opera sobre la clave pública, no sobre su hash). Esto **retrasa** la exposición cuántica y reduce la superficie de "harvest now", complementando a la PQC. *(Refinamiento: minimizar la exposición de la clave pública en las transacciones, no solo en la dirección.)*

## 1.3 Requisitos del dominio bancario

El modelo de amenaza dice qué puede hacer el adversario; esta sección dice **qué debe satisfacer el sistema**. Se enuncia de forma explícita porque «banca» no es aquí un adjetivo decorativo: el dominio impone requisitos que un libro mayor genérico no tiene que cumplir, y esos requisitos condicionan decisiones concretas de esta tesis —la rotación gobernada por política, el registro auditable, el modelo de cuenta con clave rotable, la exigencia de finalidad determinista—. Enunciarlos por adelantado permite que cada una de esas decisiones sea **trazable a un requisito**, en lugar de justificarse por sí misma.

El anclaje no es hipotético: el propio sector financiero ya ejecutó el experimento que esta tesis modela. El **BIS Innovation Hub**, con el Banco de Francia, el Deutsche Bundesbank, el Banco de Italia y Swift, llevó a cabo el **Project Leap**, cuya Fase 2 **sustituyó las firmas digitales clásicas por post-cuánticas en un sistema de pagos operativo**, cursando transferencias de liquidez; concluyó que la migración es viable y que su costo debe planificarse [BIS-Leap23]. Su documento de hoja de ruta insiste en tres principios —inventario criptográfico, **cripto-agilidad** y migración por fases— como condiciones de la transición [BIS-Roadmap25]. En el plano normativo, el reglamento europeo **DORA** obliga a las entidades financieras a mantener estándares altos de disponibilidad, confidencialidad, **autenticidad e integridad** de los datos (art. 9(2), con normas técnicas desde ene. 2024) [DORA22], y en los Estados Unidos una propuesta de marco presentada a la *Crypto Assets Task Force* de la SEC —no es regulación vigente, sino insumo de política— prioriza explícitamente la custodia y la infraestructura crítica de mercado para la migración post-cuántica, con HSM, rotación automatizada y trazabilidad auditable como piezas centrales [PQFIF25].

De ese cuerpo se destilan seis requisitos, con el punto del documento donde NEXUS los atiende:

| | Requisito del dominio | Origen | Dónde lo atiende NEXUS |
|:--:|---|---|---|
| **R1** | **Autenticidad e integridad** de la instrucción de pago, como obligación normativa y no solo como buena práctica | DORA art. 9(2) [DORA22] | Firma Dilithium ligada al contenido (Cap. 4, §4.3) y su in-forjabilidad validada (Cap. 6) |
| **R2** | **Horizonte de exposición de décadas**: activos, obligaciones y secretos cuya vida útil excede la llegada del adversario ⇒ migrar **antes**, no después | HNDL; [BIS-Roadmap25]; [PQFIF25] | Adopción de PQC como premisa (§1.1); agenda de migración (Cap. 7) |
| **R3** | **Cripto-agilidad**: el sector no exige *un* algoritmo sino la capacidad de **cambiarlo** —FIPS 206 sigue en borrador, luego el esquema de hoy puede no ser el de 2030— | Leap Fase 1 [BIS-Leap23]; [BIS-Roadmap25]; [PQFIF25] | Modelo de cuenta con identidad estable + política de verificación y *epoch*, y Key Registry (Cap. 3, §3.6) |
| **R4** | **Custodia certificada y ciclo de vida gobernado** de la clave de firma: la clave vive tras una frontera de custodia (HSM/TPM), con rotación por política y no *ad hoc* | [PQFIF25] (rotación automatizada; HSM compatibles con FIPS 203–205) | Rotación por uso/edad/salud con secrecia hacia adelante (Cap. 5, §5.5); custodia *seed-only* de 32 B, que es lo que hace que una clave ML-DSA **quepa** en esa frontera (§5.6) |
| **R5** | **Trazabilidad auditable**: cada evento del ciclo de vida de la clave debe ser reconstruible por un supervisor | DORA [DORA22]; *audit trail* inmutable en [PQFIF25] | Registro auditable de rotaciones (Cap. 5, §5.5) y su diseño de anclaje en cadena (Decisión 002, trabajo en curso) |
| **R6** | **Finalidad rápida y determinista** de la liquidación, con latencias objetivo del orden de $10^2$ ms | Práctica de sistemas de pago (ISO 20022 sobre SWIFT/Fedwire, firmas de doble control respaldadas por HSM) [PQFIF25] | Requisito de finalidad determinista del *Finality Gadget* (Cap. 3, §3.9); SLA de referencia del análisis de latencia (Cap. 5, §5.6) |

**Lo que estos requisitos no incluyen.** Se declara con la misma precisión: NEXUS **no** aborda la certificación **FIPS 140-3** del módulo criptográfico, la integración con la mensajería **ISO 20022** ni el cumplimiento de un régimen jurisdiccional concreto. Son requisitos de **producto**, no de **modelo**, y quedan fuera del alcance (§1.7). Lo que R1–R6 aportan al trabajo es un criterio: ninguna decisión de diseño de los Capítulos 3–5 se justifica por elegancia, sino por su trazabilidad a uno de ellos.

## 1.4 El problema: seguridad post-cuántica a un costo tractable

Adoptar firmas post-cuánticas no es gratis. Una firma Dilithium es **~50× más grande** que una firma ECDSA (3 309 B vs. 64 B). Aplicada de forma ingenua sobre una blockchain de cadena única, esa inflación de datos **degrada el rendimiento en ~20×** (Cap. 3, §3.3), reabriendo el **trilema de la blockchain** (escalabilidad, seguridad, descentralización) que se creía en vías de solución.

El problema central de esta tesis es, por tanto:

> **¿Cómo asegurar las firmas de una blockchain bancaria contra la amenaza cuántica sin sacrificar la escalabilidad?**

La respuesta de NEXUS es **arquitectónica**: una estructura **dual-chain** (L1 de anclaje + L2 de ejecución) que **amortiza** el sobrecosto de la PQC —ejecutando y probando las firmas fuera de cadena y publicando en L1 solo un compromiso— hasta volver el tamaño de la firma irrelevante para la capa de liquidación (Cap. 3, §3.4). Como corolario, la capa de verificación debe ser ella misma post-cuántica (STARK, no Groth16; Cap. 3, §3.5).

## 1.5 Propuesta y contribución

**Tesis (en una frase).**

> *NEXUS formaliza y prototipa cómo asegurar firmas digitales de banca contra la amenaza cuántica con CRYSTALS-Dilithium, demostrando formalmente su seguridad (reducción a Module-LWE) y resolviendo el sobrecosto de datos que la PQC introduce mediante una arquitectura dual-chain con verificación post-cuántica.*

**Arco narrativo.** El trabajo se organiza como una sola cadena de razonamiento:
$$\text{Amenaza} \to \text{Solución (PQC)} \to \text{Costo} \to \text{Respuesta (dual-chain)} \to \text{Coherencia (STARK)} \to \text{Validación (formal + complejidad)}.$$

**Naturaleza del aporte.** El entregable es un **modelo matemático-computacional acompañado de un prototipo de referencia**, no un sistema de producción. La arquitectura se *especifica y modela*; el núcleo de firmas y la gestión de claves se *implementan y verifican*; la seguridad se *valida formalmente*. La capa de computación verificable (ZK) se entrega como **PoC STARK** —su motor criptográfico post-cuántico está implementado y verificado por pruebas (Cap. 3, §3.5)— más **diseño de referencia** para su aritmetización completa; el consenso bizantino operativo se entrega como diseño de referencia (trabajo futuro).

**Novedad.** La criptografía post-cuántica, los esquemas de firma reticulares y los *rollups* existen por separado. La contribución de NEXUS es la **síntesis específica**:

> *el tratamiento formal y cuantificado de cómo el sobrecosto de datos de las firmas post-cuánticas motiva y se mitiga con una arquitectura dual-chain de prueba de validez post-cuántica para banca, llevando el costo on-chain por transacción al de su diferencia de estado clásica.*

La **convergencia independiente de Ethereum y Solana** hacia las mismas conclusiones (Cap. 2) **valida** —no resta— esta dirección.

## 1.6 Objetivos

**Objetivo general.** Diseñar, modelar y **validar formalmente** un modelo matemático-computacional de firmas digitales post-cuánticas (CRYSTALS-Dilithium) para una arquitectura blockchain dual orientada a sistemas bancarios resilientes, incorporando la gestión activa del ciclo de vida de claves y la prueba formal de su seguridad (reducción a Module-LWE) y de su complejidad computacional.

**Objetivos específicos.**
1. **Diseñar la arquitectura Dual-Chain** como modelo de referencia, especificando los roles de la Anchor Layer (L1) y la Active Layer (L2) y el camino de la firma post-cuántica (Cap. 3).
2. **Desarrollar e implementar el núcleo criptográfico** post-cuántico (Dilithium) y la derivación determinística de claves desde semilla mediante un KDF (Cap. 4).
3. **Modelar e implementar la lógica de seguridad activa** del ciclo de vida de claves: min-entropía de la fuente, pruebas de salud (NIST SP 800-90B) y rotación con secrecia hacia adelante (Cap. 5).
4. **Formalizar y validar la seguridad y la complejidad**: reducción de la in-forjabilidad de Dilithium a Module-LWE / SelfTargetMSIS / Module-SIS → Mod-SIVP, con el argumento de resistencia cuántica; y análisis de complejidad (notación O) (Cap. 6).

## 1.7 Alcance

**Dentro del alcance:** diseño y especificación de la arquitectura dual; implementación verificada de Dilithium y su enlace a las transacciones; derivación determinística por KDF; gestión activa de claves (min-entropía + salud + rotación); y validación formal (reducción + complejidad + benchmarks).

**Fuera del alcance (declarado):** autenticación biométrica / extractores difusos (**eliminados**); implementación operativa de la capa ZK, del consenso BFT en red y de la disponibilidad de datos (diseño de referencia + trabajo futuro); confidencialidad post-cuántica (KEM); seguridad de implementación (canales laterales); y el **cumplimiento a nivel de producto** de los requisitos de dominio (§1.3): certificación FIPS 140-3 del módulo criptográfico, integración con mensajería ISO 20022 y conformidad con un régimen jurisdiccional concreto. NEXUS se sitúa en el nivel de **modelo**: atiende R1–R6 como requisitos de diseño, no como obligaciones certificables.

## 1.8 Estructura del documento

| Cap. | Contenido | Objetivo |
|---|---|:---:|
| **1** | Introducción, modelo de amenaza, **requisitos de dominio (R1–R6)**, objetivos | — |
| **2** | Marco teórico y estado del arte | — |
| **3** | Diseño de la arquitectura Dual-Chain (overhead → respuesta → coherencia) | Obj 1 |
| **4** | Núcleo criptográfico post-cuántico (Dilithium + KDF) | Obj 2 |
| **5** | Gestión activa del ciclo de vida de claves | Obj 3 |
| **6** | Validación formal de seguridad y complejidad | Obj 4 |
| **7** | Conclusiones y trabajo futuro | — |

---

## Referencias del capítulo

> *Índice local del capítulo; la **Bibliografía** consolidada al final del documento reúne todas las obras bajo clave única.*

- [Sho97] P. Shor. *Polynomial-Time Algorithms for Prime Factorization and Discrete Logarithms on a Quantum Computer*. SIAM J. Comput. 1997.
- NIST. *FIPS 203 (ML-KEM) / 204 (ML-DSA) / 205 (SLH-DSA)*, 2024; *FIPS 206 (FN-DSA)*, borrador.
- **[BIS-Leap23]** BIS Innovation Hub et al. *Project Leap: Quantum-proofing the financial system* — Fase 1 (2023) y Fase 2, *Quantum-proofing payment systems*. *(sustitución de firmas clásicas por post-cuánticas en un sistema de pagos operativo)*
- **[BIS-Roadmap25]** BIS. *Roadmap to quantum-readiness*, jul. 2025. *(inventario criptográfico, cripto-agilidad, migración por fases)*
- **[DORA22]** Reglamento (UE) 2022/2554 (DORA), art. 9(2). *(autenticidad e integridad de los datos como obligación normativa)*
- **[PQFIF25]** D. B. Corvelo Costa et al. *Post-Quantum Financial Infrastructure Framework*. Aportación a la U.S. Crypto Assets Task Force, SEC, sep. 2025. *(propuesta de marco, no regulación vigente)*
