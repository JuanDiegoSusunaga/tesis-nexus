# R4 — Auditoría de Merkle y Fiat–Shamir

**Fecha:** 23 de septiembre de 2026. **Ámbito:** Objetivo 4 de TG2, variante experimental con FRI vinculada. Producción STARK preservada.

## 1. Dictamen

La variante comprueba la forma de las aperturas, la canonicidad y la raíz compartida. Se reconstruyeron de forma independiente **14 certificados, 560 consultas y 18.880 aperturas Merkle** mediante Python y hashlib. La cuenta exacta del sesgo de reducción al campo permite sustituir uniformidad por una distribución explícita en un experimento con salidas aleatorias frescas.

Estos resultados no establecen la compilación del protocolo conjunto a Fiat–Shamir. La [cota anterior](R4-Cota-Interactiva-2026-09-22.md) sigue correspondiendo al modelo interactivo ideal. Falta demostrar las propiedades por ronda del protocolo completo y la correspondencia de su canal con una transformación cubierta por un teorema ROM/QROM. Esta auditoría termina con obligaciones concretas para revisión, sin atribuir 100 bits ni conocimiento cero al ejecutable.

## 2. Vinculación Merkle: qué se puede afirmar

La variante emplea SHA3-256 mediante Hash256. Una hoja es H(0x00 ∥ c₀ ∥ c₁), con dos enteros canónicos de ocho bytes en little-endian; un nodo es H(0x01 ∥ izquierda ∥ derecha), de 65 bytes de entrada. AIR convierte su valor base en (u,0), la misma codificación usada por la primera capa FRI de traza. Las raíces se comparan explícitamente.

**Lema de vinculación para una posición.** Fijados tamaño potencia de dos, índice dentro del dominio y raíz, dos aperturas aceptadas de valores canónicos distintos permiten obtener una colisión de H. Si los hashes de hoja coinciden, los valores dan dos entradas de hoja distintas. Si difieren, se asciende hasta el primer padre que coincide; al menos uno de sus hijos difiere, por lo que las entradas ordenadas del nodo son distintas. El prefijo distingue hojas de nodos. La reducción recorre como máximo la profundidad del árbol.

Este lema es condicional a la resistencia a colisiones y a la forma fijada. **No demuestra que una raíz arbitraria permita extraer todo un vector conocido antes de los retos.** Esa propiedad requiere el modelo y la reducción de compilación correspondientes. Tampoco asigna una probabilidad numérica de colisión a SHA3 real.

La función Merkle genérica consume los bits del índice que corresponden al camino y no valida por sí sola índice < tamaño: índices separados por el tamaño usan los mismos bits. La variante acota las filas, exige profundidad exacta y deriva todos sus índices dentro del dominio. El lema se aplica a esta interfaz validada; no se atribuye un contrato más fuerte a la función genérica heredada.

## 3. Gramática de bytes y transcripción

Orden observado: dominio de versión; perfil; enunciado; raíz de traza; tres α; fase traza y sus raíces/β/final; fase composición y sus raíces/β/final; nonce; índices sin reemplazo.

La absorción usa estado ∥ etiqueta ∥ longitud u64 ∥ datos. Los retos usan estado ∥ «E» o estado ∥ «I». El perfil incluye versión, bits de trabajo, N, T, 2T y 40 consultas. Las fases se etiquetan como trace y composition. La secuencia y el número de capas quedan fijados por el perfil admitido. La longitud y las etiquetas separan las codificaciones; no hacen inyectiva la función hash.

| Entrada a SHA3 | Longitud en bytes |
|---|---:|
| Dominio inicial | 23 |
| Hoja de extensión / nodo Merkle | 17 / 65 |
| Absorción de perfil / enunciado / raíz | 79 / 65 / 73 |
| Absorción de fase traza / composición / final | 46 / 52 / 57 |
| Extracción de reto / trabajo de nonce / absorción del nonce | 33 / 41 / 49 |

Se usa el mismo SHA3 en ambos componentes. Hay dos familias con longitud 65: nodo y absorción del enunciado. Para los 18 perfiles admitidos —nueve tamaños y dos niveles de trabajo— el estado fijo anterior al enunciado no empieza por 0x01, por lo que esas entradas son distintas en este perfil concreto. El script conserva los 18 primeros bytes. Esta observación finita no equivale a una separación universal entre versiones o aplicaciones que usen el mismo hash; cualquier extensión exige revisar la gramática de nuevo.

Las extracciones sucesivas dependen del estado previo. Repetir o restaurar una transcripción repite sus retos; el código no genera monedas independientes cada vez que un adversario vuelve a consultar el mismo prefijo. Esa diferencia es precisamente parte de la obligación Fiat–Shamir.

## 4. Sesgo exacto de los retos

Sea S = 2¹²⁸ y escribamos S = ap+r, con 0 ≤ r < p. Para U uniforme en {0,…,S−1}, U mod p asigna masa (a+1)/S a r residuos y a/S a los restantes. Su distancia de variación total a la distribución uniforme sobre F es:

$$
\Delta_F=\frac{r(p-r)}{pS}.
$$

En Goldilocks, a = 18446744078004518911 y r = 18446744065119617025 = p−2³². Se obtiene ΔF ≈ 1,26217744806 × 10⁻²⁹. Para dos bloques independientes de 128 bits, ΔK ≤ 2ΔF y la masa máxima de un elemento de K es ((a+1)/S)². La fórmula se contrastó por enumeración en 35 distribuciones pequeñas.

Una ejecución de la variante usa m = 3+log₂T+log₂(2T) retos de extensión: de 12 a 28. Mediante un argumento híbrido, reemplazar retos uniformes por esos bloques reducidos cambia cualquier probabilidad de aceptación en a lo sumo 2mΔF, **si en cada paso los bloques son uniformes frescos e independientes de la historia**. Para m = 28, la pérdida es menor que 7,069 × 10⁻²⁸. El resultado también admite decisiones adaptativas entre pasos, siempre que se conserve esa condición de frescura; no cubre búsquedas entre múltiples transcripciones hash.

No se presenta 2mΔF como pérdida total de Fiat–Shamir. El modelo concreto añade consultas repetidas, exploración de prefijos, nonces y compromisos elegidos adaptativamente. En el modelo ideal de salida uniforme, el enmascaramiento de índices sobre una potencia de dos no introduce sesgo; el rechazo de duplicados produce muestreo sin reemplazo. Ambos hechos conservan la condición de frescura.

## 5. Grinding y adaptación

El probador busca el primer nonce que satisface el trabajo; el verificador acepta cualquiera que lo satisfaga. Esta diferencia ya tiene una prueba Rust en tg2_soundness.rs. Un ensayo independiente de la misma construcción, con contexto público fijado y 12 bits, encuentra los nonces **904 y 1233**, ambos válidos y con listas distintas de 40 consultas.

No es una falsificación del AIR. Demuestra que el trabajo no hace única la transcripción y que el análisis debe contabilizar intentos adicionales. Los 12/20 bits no se suman automáticamente al presupuesto de solidez. El digest que verifica el trabajo y la absorción posterior del nonce tienen codificaciones distintas, identificadas en la tabla anterior.

## 6. Correspondencia con el teorema de compilación

[BGK+23, Teorema 3.15](https://eprint.iacr.org/2023/1071), edición conservada de febrero de 2024, p. 25, formula una transformación BCS y garantías basadas en propiedades por ronda. Su término clásico de solidez es Qεrbr+3(Q²+1)/2^κ. El resultado cuántico añade dependencias en Q y en la complejidad de consulta; no entrega una constante numérica universal utilizable sin instanciación.

La forma de esa expresión sirve para identificar los datos que faltan, no para sustituir εrbr por Eideal de §6.7.5. Eideal es una cota ordinaria de un experimento completo. Tampoco el resultado para FRI aislado cubre automáticamente el AIR, los dos recorridos correlacionados y el canal con grinding. La transferencia de conocimiento y de conocimiento cero exige sus respectivas propiedades; no se deducen de la vinculación Merkle.

| Obligación | Evidencia disponible | Criterio pendiente |
|---|---|---|
| Forma y enlace Merkle | Tamaños, índices derivados, valores canónicos, lema condicional y 18.880 aperturas contrastadas | Extracción/modelado de oráculos dentro de la compilación |
| Transcripción | Orden y codificaciones cotejados; 14 certificados reconstruidos con otro backend SHA3 | Correspondencia formal con una transformación cubierta por el teorema |
| Retos | Sesgo exacto y pérdida híbrida bajo bloques frescos | Incorporar consultas adaptativas y reinicios |
| Protocolo conjunto | Cota ordinaria ideal de S2 | Estados por ronda y error para AIR + ambos FRI + consulta común |
| Grinding, ROM/QROM | Varios nonces válidos reproducidos; teorema localizado | Presupuesto de consultas, pérdidas concretas y revisión independiente |

**Resultado de S3:** auditoría de correspondencia y distribución completada; garantía criptográfica concreta no establecida. Se prepara un [paquete de revisión matemática](Revision-Matematica-S1-S3-2026-09-23.md) con afirmaciones y preguntas precisas. No se cambia el protocolo aprobado ni se exige una demostración nueva de 100 bits como condición automática de cierre académico.

## 7. Evidencia y reproducción

- [Auditor independiente](../../../scripts/auditar_merkle_fs_r4.py).
- [Análisis, corpus, estados, cálculos y fuentes](../../06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/analisis.json).
- [Check, 197 pruebas y build](../../06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/validacion.json).
- [Edición del manuscrito y revisión visual](../../06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/revision-manuscrito.json).

El auditor decodifica la tupla bincode conservada, verifica canonicidad y forma, reconstruye SHA3, nonce e índices, y comprueba las aperturas y el enlace de traza. **No reejecuta el plegado FRI ni la composición AIR.** Por eso también pasan sus comprobaciones Merkle los seis certificados de trazas lejanas que el verificador completo rechaza: sus aperturas son auténticas. Los resultados completos de aceptación/rechazo permanecen en los ensayos Rust anteriores y en la suite repetida de esta etapa. No se repiten benchmarks ni se presentan estos 14 archivos como 14 pruebas Rust adicionales.

La generación documental ahora admite NEXUS_TG2_FECHA_EVIDENCIA y utiliza la fecha actual por defecto. La edición del día 23 conserva sus informes en su propia carpeta; los informes y snapshots del día 22 permanecen identificados.
