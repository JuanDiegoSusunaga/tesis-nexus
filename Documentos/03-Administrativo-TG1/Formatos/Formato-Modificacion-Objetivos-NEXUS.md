![](media/image1.png){width="3in"}

**FORMATO DE MODIFICACIÓN DE OBJETIVOS — TRABAJO DE GRADO**

Escuela de Ciencias e Ingeniería · Universidad del Rosario

# 1. Identificación del trabajo de grado

| **Campo** | **Información** |
|---|---|
| Estudiante | Juan Diego Susunaga Velasquez |
| Programa académico | Matemáticas Aplicadas y Ciencias de la Computación |
| Director | Leonardo Huertas Calle |
| Título del trabajo | Arquitectura Blockchain Dual NEXUS: Un Modelo Matemático-Computacional para Sistemas Bancarios Seguros y Resilientes Post-Cuántico |
| Espacio académico | Trabajo de Grado 1 |
| Fecha | 05/06/2026 |

# 2. Objetivos aprobados originalmente

**Objetivo general.** Diseñar, modelar y validar formalmente la Arquitectura Blockchain Dual NEXUS como un sistema bancario seguro y resiliente, integrando criptografía Post-Cuántica (PQC) con lógica de seguridad activa y computación verificable (ZK).

**Objetivos específicos.**

1. Diseñar la arquitectura del sistema Dual-Chain, especificando los roles funcionales de la Anchor Layer (L1) y la Active Layer (L2), y sus componentes clave como el Nexus Sequencer y el Nitro Verifier.
2. Desarrollar el core matemático y criptográfico del sistema, formalizando la aplicación del esquema de firma PQC CRYSTALS-Dilithium y el uso del **Extractor Difuso** para la generación de claves determinísticas.
3. Modelar la Lógica de Seguridad Activa, definiendo la Función de Monitoreo de **Entropía de Shannon H(S)** para el Sentinel-Seed y el Algoritmo de Rotación de Claves basado en Entropía.
4. Formalizar y validar la seguridad del sistema, incluyendo la Prueba de Dureza Post-Cuántica (Reducción a Module-LWE) y el Análisis de Complejidad Computacional (O-Notation) de la verificación de firmas PQC.

# 3. Objetivos modificados (propuestos)

**Objetivo general.** Diseñar, modelar y validar formalmente un **modelo matemático-computacional de firmas digitales post-cuánticas (CRYSTALS-Dilithium)** para una arquitectura blockchain dual orientada a sistemas bancarios resilientes, incorporando la **gestión activa del ciclo de vida de claves** y la prueba formal de su seguridad (reducción a Module-LWE) y de su complejidad computacional.

**Objetivos específicos.**

1. Diseñar la arquitectura del sistema Dual-Chain **como modelo de referencia**, especificando los roles de la Anchor Layer (L1) y la Active Layer (L2), el **camino de la firma post-cuántica** y los componentes clave (Nexus Sequencer, Nitro Verifier).
2. Desarrollar e implementar el núcleo matemático y criptográfico, formalizando e implementando de forma verificada el esquema de firma PQC CRYSTALS-Dilithium y la **derivación determinística de claves a partir de una semilla mediante una función de derivación de claves (KDF)**.
3. Modelar e implementar la lógica de seguridad activa del ciclo de vida de claves: **monitoreo de la fuente de entropía basado en min-entropía y pruebas de salud en línea (NIST SP 800-90B)**, y rotación de claves con secrecia hacia adelante.
4. Formalizar y validar la seguridad y la complejidad: reducción de la in-forjabilidad de Dilithium a Module-LWE, SelfTargetMSIS y Module-SIS (y de éstos a Mod-SIVP de peor caso), con el argumento de no aplicabilidad del algoritmo de Shor; y análisis de complejidad computacional (notación O) de la verificación de firmas.

# 4. Resumen de los cambios

| **Objetivo** | **Tipo de cambio** | **Síntesis** |
|---|---|---|
| General | Reenfoque (estrechamiento) | Se centra en las firmas post-cuánticas y la validación formal; la computación verificable (ZK) pasa a diseño de referencia / trabajo futuro. |
| Específico 1 | Sin cambio sustantivo | Se precisa que es un *modelo de referencia* y se enfatiza el camino de la firma PQC. |
| Específico 2 | **Modificado** | Se **elimina el Extractor Difuso (biometría)**; la generación determinística se obtiene de una semilla de alta entropía vía **KDF**. |
| Específico 3 | **Reformulado** | Se reemplaza la **entropía de Shannon H(S)** por la **min-entropía de la fuente + pruebas de salud NIST SP 800-90B**. |
| Específico 4 | Sin cambio sustantivo | Se precisa la cadena de reducción y el problema reticular de peor caso (Mod-SIVP). |

# 5. Justificación de la modificación

**Motivación general.** El alcance aprobado originalmente era muy amplio (PQC + ZK + biometría + consenso BFT + disponibilidad de datos + teoría de juegos + validación formal), lo que comprometía la profundidad alcanzable. La modificación **concentra el trabajo en su contribución central y verificable** —firmas post-cuánticas sobre una arquitectura dual-chain, con validación formal— y mantiene los componentes restantes (ZK, consenso BFT operativo, disponibilidad de datos) como **diseño de referencia y trabajo futuro**, claramente delimitados. El núcleo del trabajo y su objetivo general se preservan; se gana rigor y factibilidad.

**Objetivo específico 2 — eliminación del Extractor Difuso (biometría).**

- Un dato **biométrico no es revocable**: basar en él una clave de firma de banca es un diseño cuestionable, pues ante un compromiso del par (clave + *helper data*) no es posible reemitir el factor biométrico.
- El **código corrector de errores** (BCH/Reed-Solomon) que un extractor difuso requiere para tolerar el ruido biométrico constituye un subproblema sustancial por sí mismo.
- La **generación determinística de claves**, que es el fin perseguido, se obtiene de forma más sólida y estándar **a partir de una semilla de alta entropía mediante un KDF**; en efecto, el estándar **FIPS 204 / ML-DSA ya define una generación de claves determinística a partir de una semilla**. El objetivo (claves determinísticas) se conserva; cambia el medio (semilla + KDF en lugar de biometría).

**Objetivo específico 3 — reformulación de la métrica de entropía.**

- La **entropía de Shannon de una muestra no mide el secreto de una clave**: la salida de un generador pseudoaleatorio luce con entropía de Shannon máxima independientemente de si la fuente es secreta o predecible.
- Para una semilla de 32 bytes, la entropía de Shannon empírica **no puede superar 5 bits/byte**, de modo que el umbral original (7,5 bits/byte) era inalcanzable.
- La medida criptográficamente pertinente es la **min-entropía de la fuente**, y el "monitoreo activo de entropía", en sentido riguroso, corresponde a las **pruebas de salud en línea del estándar NIST SP 800-90B** (Repetition Count Test y Adaptive Proportion Test). La reformulación dota al objetivo de un fundamento estándar y verificable. El propósito (seguridad activa basada en la calidad de la aleatoriedad y rotación de claves) se conserva.

# 6. Impacto en el cronograma

El impacto es **mínimo** y no altera la distribución por espacios académicos (Objetivos 1–2 en Trabajo de Grado 1; Objetivos 3–4 en Trabajo de Grado 2). Solo cambian dos actividades: la Actividad 2.2 pasa de "modelado del Extractor Difuso" a "derivación determinística semilla → clave por KDF", y las actividades del Objetivo 3 pasan de la entropía de Shannon a la min-entropía y las pruebas de salud SP 800-90B. Los productos esperados y los plazos se mantienen.

# 7. Aprobación

| | **Nombre** | **Firma** | **Fecha** |
|---|---|---|---|
| Estudiante | Juan Diego Susunaga Velasquez | ____________________ | 05/06/2026 |
| Director | Leonardo Huertas Calle | ____________________ | ____________ |
| Comité de Opciones de Grado | | ____________________ | ____________ |
