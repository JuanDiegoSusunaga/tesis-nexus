---
title: "Arquitectura Blockchain Dual NEXUS: Un Modelo Matemático-Computacional para Sistemas Seguros y Resilientes Post-Cuánticos"
author: "Juan Diego Susunaga Velasquez"
date: "Universidad del Rosario — Escuela de Ciencias e Ingeniería · Programa de Matemáticas Aplicadas y Ciencias de la Computación (MACC) · Director: Pedro Mario Wightman Rojas · 20/10/2026"
lang: es
---

## Resumen

NEXUS es un modelo matemático-computacional y prototipo de referencia para estudiar la autenticación y la gestión de claves frente a amenazas poscuánticas en sistemas digitales. Emplea ML-DSA, derivado de CRYSTALS-Dilithium y estandarizado en FIPS 204, y una arquitectura blockchain dual como modelo de ejecución y anclaje. La amortización del tamaño de firmas mediante pruebas por lote depende de la disponibilidad de datos, del costo del probador y de la aritmetización de la lógica de aplicación.

La validación identifica el perfil de firma implementado, contrasta los parámetros y las reducciones citadas, y explicita las obligaciones para obtener una garantía concreta de inforjabilidad. El gestor incorpora min-entropía, pruebas de salud NIST SP 800-90B, recuperación, rotación efectiva y un registro local autenticado. La protección de la semilla, la calificación de una fuente concreta y las integraciones de custodia y anclaje permanecen pendientes.

Las mediciones trazables evalúan componentes con repeticiones y dispersión. La revisión STARK refuta una premisa de proximidad del verificador básico y comprueba el enlace de FRI de traza con AIR mediante raíz común. Rust incorpora ese contrato y lo conecta con `ActiveChain` mediante contexto local; rechaza raíces fuera del modelo escalar. Lean demuestra una cota conservadora de aceptación falsa para el verificador matemático de bytes en ROM clásico finito, con consultas adaptativas, muestra compartida, trabajo y reinicios. La compilación global y la auditoría de axiomas comprueban esos resultados bajo sus hipótesis; no demuestran equivalencia universal con Rust. La transferencia QROM completa de AIR/FRI queda como trabajo futuro. El catálogo relaciona afirmaciones, hipótesis y evidencia.

El aporte reúne modelo, componentes y evaluación delimitada. El AIR ilustrativo no valida firmas ML-DSA ni aplicaciones completas; no se acreditan 100 bits, conocimiento cero, seguridad incondicional de SHA3 ni una blockchain operativa.

**Palabras clave:** criptografía post-cuántica, blockchain, CRYSTALS-Dilithium, Module-LWE, arquitectura dual-chain, seguridad de sistemas, validación formal.

## Abstract

NEXUS is a mathematical-computational model and reference prototype for studying authentication and key management under post-quantum threats in digital systems. It uses ML-DSA, derived from CRYSTALS-Dilithium and standardized in FIPS 204, with a dual blockchain architecture as an execution and anchoring model. Amortizing signature size through batch proofs depends on data availability, prover cost, and arithmetization of application logic.

The validation identifies the implemented signature profile, checks parameters and cited reductions, and states the obligations for a concrete unforgeability guarantee. The key manager implements min-entropy monitoring, NIST SP 800-90B health tests, recovery, effective key rotation, and a locally authenticated audit log. Seed protection, qualification of a concrete entropy source, and durable custody and anchoring integrations remain pending.

Traceable measurements evaluate components with repetitions and dispersion. The STARK review refutes a proposed proximity premise for the basic verifier and checks the shared-root link between trace FRI and AIR. Rust implements this contract and connects it to `ActiveChain` using local context; roots outside the scalar model are rejected. Lean proves a conservative false-acceptance bound for the mathematical byte verifier in a finite classical ROM, accounting for adaptive queries, a shared sample, work and restarts. The global build and axiom audit check these results under their stated assumptions; they do not prove universal equivalence with Rust. Full QROM transfer for AIR/FRI remains future work. A catalogue links claims, assumptions, and evidence.

The contribution combines a model, components, and evaluation within stated limits. The illustrative AIR does not validate ML-DSA signatures or complete applications. It does not establish 100-bit security, zero knowledge, unconditional SHA3 security, or an operational blockchain.

**Keywords:** post-quantum cryptography, blockchain, CRYSTALS-Dilithium, Module-LWE, dual-chain architecture, systems security, formal validation.

## Alcance de la tesis

NEXUS se plantea para sistemas que requieren autenticación de operaciones, integridad de registros y gestión de claves. La arquitectura blockchain dual es el modelo y el prototipo de referencia utilizados para estudiar esos requisitos. La aplicabilidad a distintos dominios exige definir y validar las reglas de cada aplicación; los experimentos de componentes no acreditan una implementación integral en todos ellos.

El gestor de claves y su registro local están implementados y probados, con integración de despliegue pendiente. La cota conservadora de aceptación falsa se demuestra para un verificador matemático en un ROM clásico finito, bajo los perfiles y presupuestos de §6.7.9. La correspondencia universal con el ejecutable Rust, la protección de una fuente física y las garantías operativas se delimitan por separado. La transferencia cuántica completa de AIR/FRI constituye trabajo futuro.
