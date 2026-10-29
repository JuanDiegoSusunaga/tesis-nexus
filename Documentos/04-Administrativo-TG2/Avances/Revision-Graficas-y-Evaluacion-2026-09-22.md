# Revisión de figuras y evaluación de la tesis NEXUS

**Fecha:** 22 de septiembre de 2026. **Alcance:** revisión del manuscrito vigente, sus salidas Word/PDF y la evidencia local previamente conciliada. Se mantiene el enfoque de sistemas en general.

**Edición revisada:** etapa anterior a la implementación R2 del mismo día. Sus páginas y conteos se conservan como registro de esa revisión. El [avance R2](R2-Monitor-Entropia-2026-09-22.md) actualiza el estado del monitor; la [edición vigente](../../01-Manuscrito/README.md) incorpora la auditoría STARK, el argumento algebraico condicional, el contraejemplo de proximidad, la variante FRI de traza vinculada al AIR y su cota conservadora en el modelo interactivo ideal, junto con la auditoría Merkle/Fiat–Shamir del día 23, y conserva los avances R1/R5/R4, con sus conteos y revisión propios. La figura 5.1 se actualizó para mostrar bloqueo de firma y validación de la transición antes de instalar claves; se volvió a inspeccionar en ambos formatos. La ubicación actual de cada figura está en el inventario gráfico.

## 1. Qué se encontró y corrigió

El manuscrito contenía dos diagramas de caracteres y una cadena narrativa presentada como ecuación. No contenía curvas experimentales como imágenes independientes: las mediciones se presentan en tablas. La revisión abarcó los tres esquemas, las 18 ecuaciones restantes en bloque y la conservación de las tablas al exportar.

| Elemento | Problema observado | Corrección | Word / PDF |
|---|---|---|---|
| Figura 1.1, argumento | Cadena horizontal demasiado larga para una lectura cómoda | Seis etapas numeradas, distribuidas en dos filas con flechas | p. 9 / p. 9 |
| Figura 3.1, arquitectura | Cajas de caracteres deformadas y letras pequeñas; el dibujo sugería una integración completa | Figura vectorial con pasos L2/L1; nota explícita de arquitectura propuesta y límites de la PoC | p. 21 / p. 18 |
| Figura 5.1, claves | Flechas ambiguas alrededor de la salud de la fuente; derivación aparentemente independiente de los controles | Decisión Sí/No; fallo conduce a bloqueo, recuperación y reevaluación; rotación completa identificada como flujo objetivo | p. 44 / p. 39 |
| Fórmula KDF, §5.4 | Llave inferior vacía bajo la sal | Se retiró esa llave decorativa, conservando los argumentos de la fórmula | p. 40 / p. 36 |

Se redibujaron las figuras a 6,5 pulgadas y texto de 10 puntos, con PNG de 320 ppp para Word y originales vectoriales para PDF. Se revisaron etiquetas, direcciones de flechas, separación entre texto y trazos, rótulos, notas y ubicación en las páginas. Se conservan los originales y el generador en `01-Manuscrito/Figuras/` y `scripts/generar_figuras_manuscrito.py`.

La presentación del aporte en §1.4 se ajustó al estado declarado en §§5.8 y 6.4–6.7: implementación y mediciones de componentes, con integraciones y correspondencias formales pendientes. La nota de la Figura 3.1 y su párrafo explicativo distinguen el recorrido propuesto de la realización completa.

## 2. Comprobaciones realizadas

- Word: **81 páginas**, **3 figuras**, **351 objetos matemáticos nativos** y **19 tablas**. Figuras y tablas mantienen sus rótulos en la misma página.
- PDF: **70 páginas**, índice propio, figuras vectoriales y fórmulas MathML. La paginación difiere de Word por el motor de composición.
- Se inspeccionaron recortes de las **18 ecuaciones en bloque de ambos formatos**, incluidas fracciones, límites, sumatorias, llaves, flechas y subíndices. Las 18 fórmulas del PDF mantienen tamaño base de **12 puntos**; el ancho mayor medido es 429,05 puntos frente a 468 disponibles.
- Las **389 celdas** coinciden con una conversión independiente desde las fuentes. La comprobación del PDF no detectó páginas vacías ni palabras fuera de los márgenes laterales establecidos.
- Las figuras describen el diseño; no se añadieron curvas, mediciones ni garantías de seguridad a partir de ellas. La revisión de presentación matemática no constituye una demostración de los resultados criptográficos.

Evidencia: [inventario gráfico](../../06-Evidencia-TG2/2026-09-22/revision-graficas.json), [paginación Word](../../06-Evidencia-TG2/2026-09-22/paginacion-word.json), [comparación de tablas y PDF](../../06-Evidencia-TG2/2026-09-22/revision-exportacion.json). Los recortes de inspección se generan en `.tools/revision-graficas/`.

## 3. Opinión sobre la tesis

**Tiene un aporte defendible como trabajo de grado y una base técnica considerable. Todavía requiere cerrar la distancia entre las garantías anunciadas y la evidencia disponible.** Esta valoración se basa en el manuscrito y el estado local del proyecto; no sustituye la evaluación del director ni asigna una calificación académica.

### Fortalezas

1. **El problema tiene un hilo conductor reconocible:** autenticación post-cuántica, costo de datos, arquitectura dual y gestión del ciclo de vida de claves. Los capítulos permiten relacionar decisiones de diseño con costos y supuestos.
2. **Existe trabajo técnico observable:** integración del núcleo de firmas, prototipo Rust, experimentos registrados y análisis de complejidad. Esto permite sostener la discusión con artefactos concretos.
3. **La gestión de claves aporta una dimensión propia al proyecto:** políticas de salud, rotación y comparación entre clave cacheada y reexpansión. El análisis de residencia puede ser una contribución útil si se delimita su modelo de amenaza y su medición.
4. **La ampliación a sistemas en general es coherente con las funciones propuestas:** autenticación de operaciones, registros verificables y vigencia de claves. El manuscrito ya declara que cada dominio debe validar sus reglas particulares.

### Aspectos que más pueden cuestionarse en una defensa

| Tema | Observación sustentada en el manuscrito | Criterio para cerrarlo |
|---|---|---|
| Seguridad formal | §6.4 conserva condiciones de correspondencia pendientes; algunas frases generales todavía presentan la seguridad como concluida | Cada garantía debe indicar teorema, supuestos, variante aplicable y límite; distinguir resultados citados y argumentos propios |
| Ciclo operativo de claves | §5.8 y la revisión de bitácora separan rotación de semilla, actualización efectiva de claves y auditoría | Completar R2/R3 de la ruta: parámetros APT, recuperación verificable, claves operativas y registro |
| Procedencia experimental | §6.6 diferencia cifras históricas y caché recuperada con medianas distintas | Identificar cada corrida por código, hardware, parámetros y datos; conciliar la serie usada en las conclusiones |
| Alcance STARK | §6.7 describe una transición ilustrativa y límites del puente de validación | Defender las mediciones como evidencia de componentes y especificar qué falta para probar la ejecución completa |
| Generalidad de aplicación | §1.6 exige reglas propias por dominio | Desarrollar un ejemplo completo de operación, autorización, cambio de estado y vigencia de clave en un sistema concreto |
| Medida W | §5.6 ya distingue residencia de probabilidad de compromiso | Definir qué secretos y copias se cuentan, durante qué intervalo y frente a qué adversario |

El modelo de amortización de §3.3 y las mediciones de §6.6 tienen funciones distintas: un cociente calculado bajo un presupuesto de datos no es una medición de throughput de un sistema completo. Conviene mantener esa distinción al escribir conclusiones y preparar diapositivas.

### Recomendación para el cierre

Concentrar TG2 en los Objetivos 3 y 4 de la [ruta de cierre](../Ruta-de-Cierre-TG2.md). El proyecto ya dispone de suficientes líneas de trabajo: conviene completar el ciclo de claves, conciliar las mediciones y precisar las garantías antes de ampliar el desarrollo a Deception Engine, esquemas umbral o consenso operativo.

La contribución que resulta más clara para defender es **un modelo y una implementación de referencia evaluada, con una política de gestión de claves, costos medidos y límites explícitos de seguridad**. Para fortalecerla, cada conclusión debe poder llevar al lector a una fuente, un argumento o una corrida identificada.
