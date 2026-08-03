# Comparativa: Estado Actual de NEXUS vs. Estado del Arte (TG2)

El presente documento realiza un análisis comparativo y de brechas (*gap analysis*) entre el **Estado del Arte** científico/normativo reciente (2018–2026) y el **Estado Actual de Desarrollo y Modelado** del proyecto **NEXUS (Trabajo de Grado 2)**.

---

## Cuadro Comparativo General

| Dimensión | Estado del Arte (Literatura / NIST) | Estado Actual en NEXUS (TG2) | Brecha / Acción Requerida |
| :--- | :--- | :--- | :--- |
| **Criptografía de Firma (NIST PQC)** | Estándar **FIPS 204 (ML-DSA / CRYSTALS-Dilithium)** estandarizado oficialmente. Parámetros ML-DSA-44, 65, 87 sobre el anillo $R_q = \mathbb{Z}_q[X]/(X^n+1)$. | **Implementado (100%)**: Crate `nexus-crypto` integra la biblioteca pura en Rust auditada y *constant-time* `fips204`. Soporta Dilithium 2, 3 y 5. | Ninguna brecha en código base. Validado en ejecutor L2 (`nexus-active`). |
| **Cadena de Reducciones (Obj. 4 - Act. 4.1)** | Demostración formal de in-forjabilidad $\text{EUF-CMA} \rightarrow \{\text{MLWE}, \text{MSIS}, \text{SelfTargetMSIS}\} \rightarrow \text{Mod-SIVP}$ en el modelo **QROM**. Argumento de invalidez de Shor. | **Modelado en Manuscrito**: Fundamentos explicados en README y estructura teórica del manuscrito. | **Completar redacción formal**: Escribir la demostración paso a paso en el manuscrito de tesis (Actividad 4.1). |
| **Monitoreo de Entropía (Obj. 3 - Act. 3.1)** | Exigencia de **Min-Entropía ($H_\infty$)** y pruebas de salud en línea **NIST SP 800-90B** (**RCT** y **APT**) para TRNG/QRNG. | **Parcial**: Módulo `nexus-crypto/src/entropy.rs` (`Sentinel-Seed`) implementa estructura de monitoreo y rotación, pero usaba entropía de Shannon. | **Refactorizar métrica v2**: Reformular a Min-Entropía + Pruebas de salud RCT/APT conforme a SP 800-90B. |
| **Rotación de Claves y Secrecía (Obj. 3 - Act. 3.2)** | Políticas de rotación con **Secrecía Hacia Adelante (*Forward Secrecy*)** para neutralizar la amenaza *Harvest Now, Decrypt Later* (HNDL). | **Implementado**: Rotación funcional en `Sentinel-Seed` por antigüedad y conteo de usos, con bloqueo de derivación y `zeroize`. | **Integración KDF pura**: Consolidar la derivación determinística de claves desde semilla vía KDF (eliminando extractor difuso inerte). |
| **Arquitectura Blockchain Dual** | Necesidad de capas de ejecución L2 para manejar el *overhead* de firma poscuántica (~3.3 KB en ML-DSA-65 vs 65 B en secp256k1). | **Modelado e Implementado Parcial**: Prototipo Dual-Chain en Rust (`nexus-anchor` para L1, `nexus-active` para L2 con transferencias reales). | El módulo de consenso PoS-BFT permanece como especificativo de referencia (*future work*). |
| **Benchmarks y Complejidad (Obj. 4 - Act. 4.2)** | Análisis de complejidad asintótica $\mathcal{O}(n \log n)$ vía NTT y pruebas empíricas en hardware/Rust. | **Implementado**: `nexus-cli` ejecuta *benchmarks* reales medidos en microsegundos para generación, firma y verificación. | **Documentación en manuscrito**: Organizar los datos empíricos obtenidos en tablas/gráficos finales para el capítulo de resultados. |

---

## Análisis Detallado por Objetivos Específicos de TG2

### 1. Objetivo Específico 3: Lógica de Seguridad Activa del Ciclo de Vida de Claves

- **Avance Actual:**
  - El prototipo NEXUS posee un módulo dedicado `Sentinel-Seed` (`nexus-crypto/src/entropy.rs`) que gestiona el monitoreo del estado de la clave y ejecuta la rotación automatizada por políticas de tiempo y uso.
  - Utiliza borrado seguro de memoria (`zeroize`) al rotar.
- **Alineación con el Estado del Arte:**
  - El Estado del Arte (NIST SP 800-90B) exige reemplazar métricas informacionales genéricas (como Shannon) por **Min-Entropía ($H_\infty$)** y ejecutar activamente los algoritmos en línea **Repetition Count Test (RCT)** y **Adaptive Proportion Test (APT)**.
- **Acción Inmediata (Actividad 3.1 & 3.2):**
  - Ajustar `nexus-crypto/src/entropy.rs` para incorporar la función de prueba RCT/APT de SP 800-90B y disparar la rotación de claves en caso de fallo de entropía.

---

### 2. Objetivo Específico 4: Formalización y Validación de Seguridad y Complejidad

- **Avance Actual:**
  - **Pruebas de código y benchmarks reales:** El workspace cuenta con 70 pruebas unitarias pasando (`cargo test --workspace`) y el CLI permite medir tiempos de firma/verificación reales con `fips204` en microsegundos.
  - La arquitectura *Dual-Chain* ya procesa transacciones firmadas con ML-DSA en L2.
- **Alineación con el Estado del Arte:**
  - La literatura reciente en QROM valida que la dureza de **SelfTargetMSIS** y la transformación Fiat-Shamir con Abortos sustentan la in-forjabilidad EUF-CMA de Dilithium frente a adversarios cuánticos.
- **Acción Inmediata (Actividad 4.1 & 4.2):**
  - Consolidar las mediciones de `nexus-cli bench crypto` en el manuscrito de tesis (Actividad 4.2).
  - Formalizar matemáticamente la cadena $\text{EUF-CMA} \rightarrow \text{SelfTargetMSIS} \rightarrow \text{Mod-SIVP}$ en la sección teórica de la tesis (Actividad 4.1).

---

## Conclusión

El proyecto **NEXUS** se encuentra en un estado **muy avanzado y sólido**:
- **Criptografía operacional:** Implementa el estándar FIPS 204 real y actualizado.
- **Código verificable:** 100% de la suite de pruebas unitarias ejecutándose limpiamente.
- **Hoja de ruta clara:** Las brechas existentes son principalmente de **refactorización puntual (NIST SP 800-90B)** y **redacción de los capítulos formales de demostración teórica y benchmarks**.
