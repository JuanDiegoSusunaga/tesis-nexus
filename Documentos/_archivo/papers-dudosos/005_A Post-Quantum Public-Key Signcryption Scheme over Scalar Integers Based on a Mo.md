# A Post-Quantum Public-Key Signcryption Scheme over Scalar Integers Based on a Modified LWE Structure - PMC

- **ID**: `a8f1ef67-70a7-4eea-a429-3f9f9fbd7556`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://pmc.ncbi.nlm.nih.gov/articles/PMC12349534/](https://pmc.ncbi.nlm.nih.gov/articles/PMC12349534/)
- **DOI**: [10.3390/s25154728](https://doi.org/10.3390/s25154728)

---

## Contenido Extraído / Texto Completo

### Resumen del Artículo (*Sensors* 2025, 25(15), 4728)

**Autores:** Mostefa Kara, Mohammad Hammoudeh, Abdullah Alamri, Sultan Alamri.

El artículo introduce un esquema novedoso de **Signcryption de Clave Pública Poscuántica (PQES)** diseñado para cumplir de manera simultánea con los requisitos de resiliencia cuántica y alta eficiencia computacional.

#### Características Principales:
- **Estructura Simplificada sobre Enteros Escalares:** A diferencia de los esquemas reticulares tradicionales (LWE/Ring-LWE) que requieren operaciones matriciales y vectoriales de alta dimensión, este esquema opera utilizando **enteros escalares** módulo $n$.
- **Rendimiento Elevado:** Reduce significativamente la sobrecarga de memoria y procesamiento. Los tiempos reportados son de aproximadamente **0.0007 segundos para signcryption** y **0.0011 segundos para unsigncryption**.
- **Fundamento de Seguridad:** Basado en una modificación de la suposición de **Learning With Errors (LWE)** adaptada a valores escalares.
- **Funcionalidad Signcryption:** Integra en un solo paso las funciones de cifrado y firma digital, superando la eficiencia de realizar ambas operaciones por separado.