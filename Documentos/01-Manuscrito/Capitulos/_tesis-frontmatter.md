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
