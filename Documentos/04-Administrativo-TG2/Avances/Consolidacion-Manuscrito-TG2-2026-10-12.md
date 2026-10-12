# Consolidación de la validación en el manuscrito TG2

**Fecha:** 12 de octubre de 2026. La edición integra la revisión del prototipo heredado y los complementos de solidez ideal por rondas, transferencia ROM y potencial para nonces adaptativos. Los entregables administrativos aprobados de TG1, el código Rust y los paquetes matemáticos originales conservan sus archivos. Las derivaciones incluidas permanecen propuestas pendientes de dictamen independiente.

## Correcciones de alcance

La edición vigente de los capítulos 1–4 remite a la validación TG2 para interpretar sus antecedentes. Se retira la atribución de aproximadamente 100 bits al STARK y se presenta como objetivo histórico no acreditado. Se distingue la ausencia de emparejamientos de una garantía QROM, el hash de una clave pública de la protección integral de la cuenta y el funcionamiento de la API ML-DSA de una prueba concreta de inforjabilidad. La residencia y destrucción de una representación secreta no acreditan borrado de todas sus copias ni de la semilla.

La comparación con Ethereum y Solana se presenta como contexto de preparación y diseño, sin convertir sus hojas de ruta en despliegues completos o validación del prototipo. La estandarización de Falcon conserva su estado en curso; se retira la fecha prevista de finalización. La tabla de SLH-DSA recoge el intervalo de firmas de la Tabla 2 de FIPS 205.

## Complementos integrados

- **§6.7.7:** correspondencia entre afirmaciones heredadas y alcance de su revisión.
- **§6.7.8:** función de estado por rondas, muestreo sin reemplazo y cota ideal refinada, con hipótesis y decimales redondeados hacia arriba.
- **§6.7.9:** modelo de un único oráculo clásico, extracción Merkle por registro, masa máxima, presupuesto de consultas y cuenta por potencial para nonces y cola.
- **§6.7.10:** resultados QROM parciales, omisión abierta y catálogo de afirmaciones; QROM completo de AIR/FRI mantiene su condición de trabajo futuro.

Los resúmenes en español e inglés, conclusiones, balance e índices se sincronizan con ese alcance. El [suplemento consolidado de derivaciones](Derivaciones-Matematicas-TG2-2026-10-12.md) reúne los argumentos completos y conserva la edición del 23 de septiembre como antecedente independiente.

## Comprobaciones y procedencia

Se ejecutaron `cargo check --workspace --all-targets`, las **197 pruebas Rust** y `cargo build`, con dependencias bloqueadas y sin red. Pasaron **30 pruebas Python** de las derivaciones incorporadas: siete de solidez por rondas, once de transferencia y doce de revisión ROM. El catálogo conserva doce afirmaciones y nueve archivos con comprobación de integridad correcta. Los casos finitos no mecanizan las demostraciones ni sustituyen M1–M6.

También pasaron las diez pruebas Python del verificador de edición. La inspección visual cubrió 110 páginas del manuscrito Word, 97 del PDF y 54 del suplemento. Se compararon 34 tablas y 848 celdas; el manuscrito conserva 560 ecuaciones nativas y tres figuras, y el suplemento 673 ecuaciones nativas. Se corrigió la presentación de dos ecuaciones y la tabla de presupuestos, conservando sus términos y valores.

La revisión del código se ejecutó en `c5c466c6350e4ff06d04d27ed68b029095c7aec8`; las derivaciones matemáticas siguen identificando `01dcde960402b6c60a19242b7ae3d6ac3d82a518` y sus fuentes preservadas. El cambio de checkout no reasigna resultados históricos. El registro de protección comprueba 176 archivos de TG1, Rust y paquetes de derivaciones.

Los registros de generación, contenido, paginación, gráficos y comprobaciones están en [la evidencia de consolidación](../../06-Evidencia-TG2/2026-10-12/Consolidacion-manuscrito/). El [manifiesto de edición](../Entrega-Final/version-tg2.json) identifica los formatos de trabajo y la evidencia. Los procesos automatizados se ejecutan ocultos; los lanzadores modificados fijan las opciones necesarias para sus procesos hijos.

## Obligaciones que permanecen

El dictamen matemático de M1–M6 y R1-A–E conserva su estado pendiente. Debe revisarse la suficiencia de los parámetros para cualquier garantía cuantitativa que se declare. Las integraciones de fuente de entropía, custodia durable, política de épocas y anclaje requieren evidencia de despliegue. No se acredita seguridad incondicional de SHA3, conocimiento cero, 100 bits, QROM completo ni una blockchain operativa. La consolidación documental no constituye una aprobación académica.
