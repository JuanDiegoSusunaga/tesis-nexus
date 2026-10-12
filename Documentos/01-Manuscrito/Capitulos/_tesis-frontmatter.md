---
title: "Arquitectura Blockchain Dual NEXUS: Un Modelo Matemático-Computacional para Sistemas Seguros y Resilientes Post-Cuánticos"
author: "Juan Diego Susunaga Velasquez"
date: "Universidad del Rosario — Escuela de Ciencias e Ingeniería · Programa de Matemáticas Aplicadas y Ciencias de la Computación (MACC) · Director: Pedro Mario Wightman Rojas · 12/10/2026"
lang: es
---

## Resumen

NEXUS es un modelo matemático-computacional y prototipo de referencia para estudiar la autenticación y la gestión de claves frente a amenazas poscuánticas en sistemas digitales. Emplea ML-DSA, derivado de CRYSTALS-Dilithium y estandarizado en FIPS 204, y una arquitectura blockchain dual como modelo de ejecución y anclaje. La amortización del tamaño de firmas mediante pruebas por lote depende de la disponibilidad de datos, del costo del probador y de la aritmetización de la lógica de aplicación.

La validación TG2 identifica el perfil de firma implementado, contrasta los parámetros y las reducciones citadas, y explicita las obligaciones para obtener una garantía concreta de inforjabilidad. El gestor incorpora min-entropía, pruebas de salud NIST SP 800-90B, recuperación, rotación efectiva y un registro local autenticado. La protección de la semilla, la calificación de una fuente concreta y las integraciones de custodia y anclaje permanecen pendientes.

Las mediciones trazables evalúan componentes con repeticiones y dispersión. La revisión de la PoC STARK refuta una premisa de proximidad de la traza heredada y comprueba una variante que vincula FRI de traza con AIR mediante una raíz común. Se integran una derivación ideal por rondas y una transferencia propuesta en ROM clásico con consultas hash y nonces adaptativos, pendientes de dictamen independiente. La transferencia QROM completa de AIR/FRI queda como trabajo futuro. El catálogo relaciona afirmaciones, hipótesis y evidencia sin mecanizar las demostraciones.

El aporte consiste en el modelo, la implementación de componentes y su evaluación delimitada. El AIR ilustrativo no valida firmas ML-DSA ni aplicaciones completas; los resultados no acreditan 100 bits, conocimiento cero, seguridad incondicional de SHA3 ni una blockchain operativa.

**Palabras clave:** criptografía post-cuántica, blockchain, CRYSTALS-Dilithium, Module-LWE, arquitectura dual-chain, seguridad de sistemas, validación formal.

## Abstract

NEXUS is a mathematical-computational model and reference prototype for studying authentication and key management under post-quantum threats in digital systems. It uses ML-DSA, derived from CRYSTALS-Dilithium and standardized in FIPS 204, with a dual blockchain architecture as an execution and anchoring model. Amortizing signature size through batch proofs depends on data availability, prover cost, and arithmetization of application logic.

The TG2 validation identifies the implemented signature profile, checks parameters and cited reductions, and states the obligations for a concrete unforgeability guarantee. The key manager implements min-entropy monitoring, NIST SP 800-90B health tests, recovery, effective key rotation, and a locally authenticated audit log. Seed protection, qualification of a concrete entropy source, and durable custody and anchoring integrations remain pending.

Traceable measurements evaluate individual components with repetitions and dispersion. The STARK proof-of-concept review refutes a proposed proximity premise for the legacy trace and checks a variant that binds trace FRI to AIR through a shared root. An ideal round-by-round derivation and a proposed classical-ROM transfer are integrated, accounting for hash queries and adaptive nonces; both remain subject to independent mathematical review. Full QROM transfer for AIR/FRI remains future work. A catalogue links claims, assumptions, and evidence without mechanizing the proofs.

The contribution comprises the model, component implementation, and evaluation within stated limits. The illustrative AIR does not validate ML-DSA signatures or complete applications. The results do not establish 100-bit security, zero knowledge, unconditional SHA3 security, or an operational blockchain.

**Keywords:** post-quantum cryptography, blockchain, CRYSTALS-Dilithium, Module-LWE, dual-chain architecture, systems security, formal validation.

## Alcance de la edición TG2

Esta edición presenta NEXUS como un modelo para sistemas en general que requieren autenticación de operaciones, integridad de registros y gestión de claves. La arquitectura blockchain dual constituye el modelo y el prototipo de referencia utilizados para estudiar esos requisitos. Se mantienen los cuatro objetivos técnicos; los capítulos 1–4 actualizan el dominio de aplicación conforme a la aclaración del autor y conservan identificados los resultados históricos de TG1. La aplicabilidad a distintos dominios no equivale a haber validado una implementación en cada uno de ellos. Los capítulos 5–7 actualizan el estado técnico de TG2: el gestor de claves y su registro local están implementados y probados, con integración de despliegue pendiente; la validación formal y experimental conserva las obligaciones indicadas en los capítulos respectivos. El presupuesto de seguridad del diseño STARK y las cifras de series anteriores no constituyen una garantía de la implementación completa; los límites vigentes se detallan en §6.7. La aprobación de las propuestas por el director se distingue de su ejecución técnica.

Esta edición de TG2 integra los complementos escritos por rondas y ROM con sus hipótesis y estado de revisión. Las precisiones de los capítulos 1–4 delimitan la interpretación de antecedentes dentro del manuscrito vigente; los documentos administrativos y entregables aprobados de TG1 conservan su contenido. No se atribuye la aprobación previa a estas derivaciones posteriores.
