# Capítulo 1 — Introducción

*Planteamiento del problema, modelo de amenaza y objetivos*

> **Rol en el arco de la tesis.** Este capítulo abre el arco narrativo: establece la **amenaza** (cuántica a las firmas digitales de los sistemas), anticipa la **solución** (firmas post-cuánticas) y su **costo** (que motiva el dual-chain), fija el **modelo de amenaza preciso**, y enuncia los objetivos, el alcance y la contribución. Los desarrollos correspondientes están en los Capítulos 3–6.

---

## 1.1 Contexto y motivación

Los sistemas digitales emplean criptografía de clave pública para autenticar operaciones, verificar la integridad de registros y proteger comunicaciones: las **firmas digitales** sustentan la autenticación y los esquemas de cifrado protegen la confidencialidad. Hoy esa criptografía es, casi universalmente, **RSA** y **criptografía de curva elíptica (ECC)**, cuya seguridad se apoya en la dureza de la factorización y del logaritmo discreto.

La computación cuántica amenaza ese cimiento. El **algoritmo de Shor** resuelve ambos problemas en **tiempo polinómico** sobre un computador cuántico suficientemente grande, rompiendo RSA y ECC. Aunque tal computador no existe aún, la amenaza es **presente** por el fenómeno **"Harvest Now, Decrypt Later" (HNDL)**: un adversario puede **cosechar hoy** información (datos cifrados, claves públicas expuestas) y **explotarla mañana**, cuando disponga de capacidad cuántica. Para sistemas que requieren preservar la autenticidad o la confidencialidad de su información a largo plazo, esto motiva adoptar **criptografía post-cuántica (PQC)** **desde ya**, no cuando la amenaza se materialice. La estandarización del NIST (FIPS 203/204/205, finalizados en 2024) y la migración de las grandes cadenas (Cap. 2) confirman que esta transición está en marcha.

## 1.2 Modelo de amenaza

Una validación de seguridad requiere un modelo de amenaza **preciso**. NEXUS distingue cuidadosamente dos amenazas cuánticas, frecuentemente confundidas:

**(A) Amenaza a la confidencialidad (HNDL en sentido estricto).** Datos cifrados con un esquema clásico y cosechados hoy podrían descifrarse en el futuro. Mitigar esto requiere un **mecanismo de encapsulado de claves (KEM) post-cuántico** (p. ej. ML-KEM / Kyber, FIPS 203). **Esta amenaza queda fuera del alcance** de esta tesis, que se centra en las firmas; se enuncia como trabajo futuro (Cap. 7).

**(B) Amenaza a la autenticación (el foco de NEXUS).** Una clave pública clásica expuesta permite a un adversario con capacidad cuántica suficiente aplicar Shor a los problemas de factorización o logaritmo discreto y falsificar firmas. NEXUS estudia la sustitución de ECDSA por ML-DSA, derivado de CRYSTALS-Dilithium (Cap. 4). La validación de sus fundamentos y las obligaciones para obtener una garantía concreta de la implementación se presentan en la sección 6.4; el funcionamiento de la API no constituye por sí solo una prueba de inforjabilidad.

**Adversario.** El análisis de las firmas considera los modelos clásicos y cuánticos de las reducciones citadas, incluido QROM cuando corresponde a R1. Para AIR/FRI se distingue la derivación interactiva ideal de la cota demostrada para el verificador matemático en ROM clásico (secciones 6.7.8–6.7.9); su extensión QROM completa permanece como trabajo futuro (sección 6.7.10). Los canales laterales, fallos de implementación y el consenso operativo quedan fuera de esta validación; el diseño asume las condiciones de consenso de la sección 3.10.

**Mitigación complementaria de la exposición.** Derivar la dirección como $H(pk)$ evita mostrar directamente la clave pública mientras no se revele por otro canal. Esta condición deja de cumplirse cuando la transacción transmite la clave. La protección depende también de la resistencia de preimagen del hash y del protocolo de uso; no garantiza que la clave sea irrecuperable ni sustituye una firma post-cuántica. El modelo de identidad estable y claves por época se desarrolla en la sección 3.6.

## 1.3 El problema: seguridad post-cuántica a un costo tractable

Adoptar firmas post-cuánticas no es gratis. Una firma Dilithium es **~50× más grande** que una firma ECDSA (3 309 B vs. 64 B). Aplicada de forma ingenua sobre una blockchain de cadena única, el modelo limitado por ancho de banda estima una reducción de rendimiento de orden 20× bajo sus tamaños y capacidad asumidos (Cap. 3, sección 3.3); no es una medición de un sistema completo, reabriendo el **trilema de la blockchain** (escalabilidad, seguridad, descentralización) que se creía en vías de solución.

El problema central de esta tesis es, por tanto:

> **¿Cómo proteger las firmas digitales de sistemas en general frente a la amenaza cuántica y gestionar su sobrecosto mediante una arquitectura blockchain dual escalable?**

La respuesta de NEXUS es un modelo de arquitectura dual: L2 ejecuta operaciones y L1 recibe compromisos y pruebas por lote. La amortización depende de aritmetizar la lógica pertinente, disponer de los datos y asumir el costo de generación de las pruebas (sección 6.6.5). La PoC actual evalúa una recurrencia ilustrativa y no demuestra todavía la verificación de firmas ML-DSA dentro de ese flujo completo.

## 1.4 Propuesta y contribución

**Tesis (en una frase).**

> *NEXUS modela y prototipa firmas digitales post-cuánticas y gestión activa de claves para sistemas en general. Analiza los fundamentos de seguridad de CRYSTALS-Dilithium/ML-DSA y el sobrecosto de datos que motiva una arquitectura blockchain dual con pruebas de validez post-cuánticas; la validación se delimita a las condiciones y los componentes estudiados.*

**Arco narrativo.** El trabajo se organiza como una sola cadena de razonamiento:

**Figura 1.1 — Secuencia del argumento de la tesis.**

![Seis etapas enlazadas: amenaza cuántica, firmas post-cuánticas, sobrecosto de datos, arquitectura dual, pruebas de validez y validación.](../Figuras/figura-1-1-arco.png){width=6.5in}

*Fuente: elaboración propia. El esquema organiza el argumento; el estado y los límites de su validación se detallan en los capítulos 5 y 6.*

**Naturaleza del aporte.** El entregable es un **modelo matemático-computacional acompañado de un prototipo de referencia**. La arquitectura se especifica y modela; el núcleo de firmas cuenta con implementación y registros de pruebas. La gestión activa de claves conserva las integraciones pendientes de la sección 5.8. El análisis de seguridad presenta fundamentos citados y condiciones cuya correspondencia con el prototipo debe completarse (sección 6.4). La capa de computación verificable se entrega como **PoC STARK de una transición ilustrativa**, con los límites de la sección 6.7; la aritmetización completa y el consenso bizantino operativo permanecen como diseño de referencia y trabajo futuro.

**Novedad.** La criptografía post-cuántica, los esquemas de firma reticulares y los *rollups* existen por separado. La contribución de NEXUS es la **síntesis específica**:

> *el estudio formal y cuantificado del sobrecosto de datos de las firmas post-cuánticas y de su amortización en una arquitectura dual-chain. El costo de anclaje por operación tiende al de su diferencia de estado si el tamaño de prueba crece sublinealmente con el lote y la política de disponibilidad permite ese presupuesto de publicación; la realización completa de la capa de pruebas conserva las condiciones de la sección 6.7.*

Las propuestas de Ethereum y Solana aportan antecedentes para esta dirección de diseño (Cap. 2); su coincidencia no demuestra la seguridad ni la viabilidad de la implementación de NEXUS.

## 1.5 Objetivos

**Objetivo general.** Diseñar, modelar y **validar formalmente** un modelo matemático-computacional de firmas digitales post-cuánticas (CRYSTALS-Dilithium) para una arquitectura blockchain dual orientada a sistemas seguros y resilientes de distintos dominios, incorporando la gestión activa del ciclo de vida de claves y la prueba formal de su seguridad (reducción a Module-LWE) y de su complejidad computacional.

**Objetivos específicos.**

1. **Diseñar la arquitectura Dual-Chain** como modelo de referencia, especificando los roles de la Anchor Layer (L1) y la Active Layer (L2) y el camino de la firma post-cuántica (Cap. 3).
2. **Desarrollar e implementar el núcleo criptográfico** post-cuántico (Dilithium) y la derivación determinística de claves desde semilla mediante un KDF (Cap. 4).
3. **Modelar e implementar la lógica de seguridad activa** del ciclo de vida de claves: min-entropía de la fuente, pruebas de salud (NIST SP 800-90B) y rotación con secrecia hacia adelante (Cap. 5).
4. **Formalizar y validar la seguridad y la complejidad**: reducción de la in-forjabilidad de Dilithium a Module-LWE / SelfTargetMSIS / Module-SIS → Mod-SIVP, con el argumento de resistencia cuántica; y análisis de complejidad (notación O) (Cap. 6).

**Alcance de cumplimiento.** El componente de reducción de seguridad del objetivo general y del objetivo específico 4 tiene cumplimiento parcial: se identifican los resultados publicados, sus condiciones y las correspondencias pendientes para ML-DSA implementado (sección 6.4), sin afirmar una cadena concreta completa para el ejecutable. Las demostraciones propias incluyen resultados de los modelos y la cota conservadora de aceptación falsa del verificador matemático AIR/FRI en ROM clásico (sección 6.7.9); esa cota no es una prueba de inforjabilidad de ML-DSA. En el objetivo 3 se comprueban monitor, rotación por épocas y registro local; la secrecia hacia adelante permanece condicionada por la custodia y la eliminación de secretos (sección 5.5). El capítulo 7 evalúa los objetivos con estas distinciones.

## 1.6 Alcance

**Dominio de aplicación.** NEXUS se plantea para sistemas en general que necesitan autenticar operaciones, conservar registros verificables y gestionar el ciclo de vida de sus claves. En este trabajo, una transacción representa una operación firmada que modifica el estado de una aplicación; puede corresponder, por ejemplo, a la actualización de un registro o de un permiso. La arquitectura blockchain dual es el entorno de referencia del modelo y del prototipo. Cada aplicación debe definir sus reglas de autorización y transición de estado; los resultados de los componentes no constituyen validación de todas las aplicaciones posibles.

**Dentro del alcance:** diseño y especificación de la arquitectura dual; implementación y comprobación funcional de ML-DSA y su enlace a las transacciones; derivación determinística contextual desde semilla; gestión activa de claves; estudio de las reducciones de seguridad y de sus condiciones de aplicación; demostraciones para los modelos declarados, incluida la cota ROM del verificador matemático; análisis de complejidad y mediciones de componentes. Este alcance no acredita una reducción completa de seguridad del ejecutable ni una garantía operativa de secrecia hacia adelante.

**Fuera del alcance (declarado):** autenticación biométrica / extractores difusos (**eliminados**); implementación operativa de la capa ZK, del consenso BFT en red y de la disponibilidad de datos (diseño de referencia + trabajo futuro); confidencialidad post-cuántica (KEM); seguridad de implementación (canales laterales).

## 1.7 Estructura del documento

**Tabla 1.1 — Estructura del documento.**

| Cap. | Contenido | Objetivo |
|---|---|:---:|
| **1** | Introducción, modelo de amenaza, objetivos | — |
| **2** | Marco teórico y estado del arte | — |
| **3** | Diseño de la arquitectura Dual-Chain (overhead → respuesta → coherencia) | Obj 1 |
| **4** | Núcleo criptográfico post-cuántico (Dilithium + KDF) | Obj 2 |
| **5** | Gestión activa del ciclo de vida de claves | Obj 3 |
| **6** | Validación formal de seguridad y complejidad | Obj 4 |
| **7** | Conclusiones y trabajo futuro | — |
