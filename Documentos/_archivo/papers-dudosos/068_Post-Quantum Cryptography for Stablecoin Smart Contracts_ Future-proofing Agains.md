# Post-Quantum Cryptography for Stablecoin Smart Contracts: Future-proofing Against Quantum Attacks | OpenReview

- **ID**: `7fa8f987-3b32-413c-b245-85138b8a7fca`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://openreview.net/forum?id=zOaKaSMwdn&noteId=e7GXMKgY00](https://openreview.net/forum?id=zOaKaSMwdn&noteId=e7GXMKgY00)

---

## Contenido Extraído / Texto Completo

### Resumen del Artículo (Prakash & Desai, ICLR 2026 Submission)

La investigación titulada **"Post-Quantum Cryptography for Stablecoin Smart Contracts: Future-proofing Against Quantum Attacks"** investiga la vulnerabilidad de la infraestructura actual de stablecoins frente a la computación cuántica y propone una ruta de migración hacia la seguridad poscuántica.

#### Aspectos Clave de la Investigación:
- **Problema:** La mayoría de las stablecoins actuales dependen de esquemas ECDSA / RSA vulnerable al Algoritmo de Shor, lo que permite la extracción de claves privadas a partir de claves públicas.
- **Solución Propuesta:** Adopción de esquemas de firma basados en reticulados, específicamente **CRYSTALS-Dilithium (NIST ML-DSA)**, para asegurar contratos inteligentes y billeteras digitales.
- **Resultados Experimentales:**
  - Experimento empírico con 50,000 transacciones de prueba.
  - Sobrecarga de generación de firma: **2.34x** y verificación: **1.22x**.
  - Rendimiento sostenido: **292 transacciones por segundo (TPS)**, demostrando la viabilidad de stablecoins poscuánticas con compensaciones de rendimiento aceptables.
- **Estrategia de Implementación:** Hoja de ruta para emisores de stablecoins que cubre migración, modelos híbridos de seguridad y pautas de despliegue real.