# Multi-Language Implementations of NIST FIPS 203/204/205 with Hybrid Key Exchange, Composite Signatures, and TLS 1.3 Integration - Authorea

- **ID**: `43b57cd8-bc93-4cbe-ab11-64137a85488e`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://www.authorea.com/doi/pdf/10.22541/au.177490757.79743995](https://www.authorea.com/doi/pdf/10.22541/au.177490757.79743995)

---

## Contenido Extraído / Texto Completo

### Resumen del Artículo (Authorea, 2025/2026)

Este trabajo documenta el desarrollo e implementación multiplataforma e interoperable de los tres estándares oficiales de criptografía poscuántica del NIST finalizados en agosto de 2024:
1. **FIPS 203 (ML-KEM):** Mecanismo de encapsulamiento de claves basado en reticulados de módulos (derivad de CRYSTALS-Kyber).
2. **FIPS 204 (ML-DSA):** Estándar primario de firma digital basado en reticulados de módulos (derivado de CRYSTALS-Dilithium).
3. **FIPS 205 (SLH-DSA):** Algoritmo de firma digital stateless basado en funciones hash (derivado de SPHINCS+).

#### Soporte Multi-Lenguaje e Interoperabilidad:
El proyecto proporciona bibliotecas de código abierto interoperables en 8 lenguajes de programación principales:
- **Rust**
- **Go**
- **JavaScript/ESM**
- **Python 3.12+**
- **Java 17+**
- **C# / .NET 10**
- **Swift 5.9+**
- **PHP 8.1+**

#### Enfoque de Seguridad e Integración:
- **Esquemas Híbridos:** Implementación de intercambio de claves híbrido (ej. X25519 + ML-KEM-768) y firmas compuestas (ej. ML-DSA + Ed25519) para asegurar compatibilidad retroactiva durante la fase de transición.
- **Integración con TLS 1.3:** Bloques de construcción para la migración de la pila de red y comunicaciones cripto-ágiles.