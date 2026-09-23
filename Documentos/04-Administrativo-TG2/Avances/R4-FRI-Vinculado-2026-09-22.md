# R4 — Variante experimental con FRI de traza vinculada al AIR

**Fecha:** 22 de septiembre de 2026. **Ámbito:** Objetivo 4 de TG2. Implementación separada del protocolo heredado.

## 1. Resultado

Se implementó una variante con dos recorridos FRI: uno para la traza, con grado objetivo < T, y otro para la composición, con grado objetivo < 2T. La traza usada por las aperturas AIR y la primera capa de su FRI comparten **la misma raíz Merkle y la misma codificación de hojas**.

La variante acepta ejecuciones honestas de 16, 64, 256 y 4096 filas. Reutiliza los valores de los [tres contraejemplos anteriores](R4-Proximidad-Traza-2026-09-22.md), genera certificados bajo el protocolo nuevo y los rechaza en FRI de traza. Se comprueba por separado que sus certificados heredados siguen siendo aceptados por el verificador original. El resultado no consiste en rechazar un formato incompatible.

**197 pruebas del workspace pasan en desarrollo; las diez nuevas también pasan en release.** Check de todos los targets y build correctos. Se preservan 14 certificados públicos nuevos y las referencias con hash a los seis archivos anteriores utilizados.

El avance resuelve la vinculación estructural de la variante y contrasta los casos conocidos. Todavía no establece un error global de aceptación, un umbral garantizado de proximidad ni 100 bits de seguridad. Es un protocolo experimental de TG2, sin integración en producción.

## 2. Perfil y formato

| Parámetro | Valor de la variante |
|---|---|
| Dominio de transcripción | NEXUS-TG2-LINKED-FRI-v1 |
| Versión | 1 |
| Filas | Potencias de dos entre 16 y 4096 |
| Dominio LDE | N = 8T, coset de desplazamiento 7 |
| Campo de la traza honesta | Goldilocks |
| Hojas de la traza | Inmersión Fp2(u, 0), 16 bytes canónicos |
| Cota FRI de traza | Grado < T; log₂(T) capas |
| Cota FRI de composición | Grado < 2T; log₂(2T) capas |
| Consultas | 40 índices distintos de parejas, comunes a ambas fases |
| Grinding | 12 bits en desarrollo; 20 en release; perfil comprobado y absorbido |

El certificado contiene versión, perfil, raíz de traza, raíces y valores finales de las dos fases FRI, nonce y 40 consultas. Cada consulta contiene seis aperturas de traza y los dos recorridos FRI. **No contiene el vector LDE completo.** El probador sí lo utiliza para construir compromisos y aperturas.

El formato y la transcripción difieren del legado: allí el árbol de traza usa hojas de ocho bytes. No hay conversión implícita entre certificados ni sustitución de los archivos aprobados de TG1.

## 3. Orden de la transcripción y vínculo

1. Inicializar el dominio de versión 1.
2. Absorber versión, bits de trabajo, N, cotas T y 2T, y número de consultas.
3. Absorber inicio, salida y filas del enunciado.
4. Absorber la raíz del vector de traza, codificado en la extensión.
5. Derivar los tres coeficientes de composición.
6. Absorber la fase «trace» y ejecutar sus compromisos/retos FRI, con cota T; absorber su valor final.
7. Absorber la fase «composition» y ejecutar sus compromisos/retos FRI, con cota 2T; absorber su valor final.
8. Validar y absorber el nonce; derivar los 40 índices comunes sin reemplazo.

El verificador exige igualdad entre la raíz AIR y la raíz de capa cero de FRI de traza. En cada consulta verifica las seis aperturas contra esa raíz, convirtiendo cada valor base a Fp2(u, 0), y exige que las dos aperturas principales coincidan con la capa cero del FRI de traza. Recalcula la composición en los dos puntos opuestos y la compara con la capa cero del FRI de composición. Finalmente verifica ambos plegados y valores finales.

La igualdad de raíces evita un enlace meramente nominal entre dos vectores. La conclusión de que no se abren valores distintos para una misma posición sigue dependiendo de la vinculación criptográfica de Merkle. No se atribuye a las pruebas una demostración independiente de esa propiedad del hash.

## 4. Validación de entradas y diez pruebas

La API comprueba filas y límites antes de multiplicar dimensiones; valida versión, perfil, número de raíces, consultas, aperturas y longitudes de caminos. Rechaza elementos no canónicos antes de operar con ellos. Los índices se derivan dentro del dominio. La API recibe estructuras ya construidas; no incorpora un receptor de red ni un decodificador de entradas hostiles con presupuesto de memoria.

| Prueba | Comprobación |
|---|---|
| Ejecuciones honestas | Cuatro tamaños; aceptación antes y después de serializar |
| Corpus de trazas alejadas | Legado acepta; la variante rechaza los tres casos en TraceFri |
| Raíz y codificación | Misma raíz AIR/FRI; raíz de hojas base distinta; sustitución detectada |
| Enunciado y perfil | Rechazo al cambiar inicio, salida, filas, versión o bits de trabajo |
| Valores y caminos | Alteraciones de aperturas AIR, FRI de traza y FRI de composición |
| Forma | Raíces/capas truncadas, consultas excesivas o reordenadas y caminos incompletos |
| Canonicidad | Elementos fuera del campo en enunciado, valores y componentes de extensión |
| Límites | Tamaños inválidos, fuera del perfil y usize máximo; LDE de longitud incorrecta |
| Restricciones AIR | Traza de bajo grado con frontera anunciada incorrecta: rechazo en CompositionFri |
| Transcripción independiente | Reconstrucción de índices desde los campos públicos y distinción de fases |

Los casos honestos se construyen con inicio 3 y segunda fila 5, datos públicos de demostración. Para los contraejemplos se reutilizan los valores comprometidos preservados, se cambia su codificación de hoja y se genera toda la transcripción nueva. No se eligen retos ni se omite grinding.

## 5. Tamaño y costo

| T | Capas traza / CP | Enunciado y prueba (B) | Solo valores del LDE completo (B) |
|---:|:---:|---:|---:|
| 16 | 4 / 5 | 196574 | 1024 |
| 64 | 6 / 7 | 306782 | 4096 |
| 256 | 8 / 9 | 437470 | 16384 |
| 4096 | 12 / 13 | 760286 | 262144 |

La tercera columna mide la tupla binaria (enunciado, certificado nuevo); la cuarta es únicamente el vector de 8T valores base que solicita el control exhaustivo, sin su prueba STARK ni metadatos. **Son cantidades distintas, no una comparación de dos paquetes completos.** En estos tamaños, el certificado nuevo supera incluso el tamaño del vector completo.

Cada apertura conserva su propio camino Merkle, sin deduplicación ni multiprueba. Con q consultas, la comunicación y el trabajo de verificación tienen crecimiento O(q log² N) en este formato; la cota de filas de la implementación se mantiene explícita. Se ha eliminado el requisito de transmitir N valores, pero no se ha demostrado ahorro de bytes o latencia frente al control completo en los casos medidos.

El script reproduce exactamente la serialización. Para D = log₂ N, Lₜ = log₂ T y L꜀ = Lₜ + 1, suma las longitudes u64 de los vectores, elementos, raíces y hermanos de ambas fases. La cuenta coincide con los 14 archivos de desarrollo/release. Son tamaños de formato, no nuevos benchmarks de ejecución.

## 6. Qué falta para una cota de seguridad

FRI comprueba proximidad al código bajo un modelo y un error de aceptación; aprobar un recorrido no demuestra pertenencia exacta. Esta distinción procede del objetivo de [FRI](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ICALP.2018.14). Componer los recorridos y aplicar Fiat–Shamir requiere hipótesis adicionales, como las estudiadas en [BGK+23](https://eprint.iacr.org/2023/1071).

La nueva cota < T evita que la composición de bajo grado sea la única comprobación de la traza. El rechazo de los ejemplos conocidos no implica que todo oráculo lejano, con cualquier estrategia de plegado, sea rechazado siempre.

El análisis global debe acotar los dos errores FRI, la combinación AIR y la coincidencia local entre traza y composición, junto con Merkle, muestreo y Fiat–Shamir. También debe justificar la selección del polinomio próximo respecto del orden de retos y el campo de sus coeficientes: las aperturas AIR exigen elementos base, mientras las capas FRI viven en la extensión.

### Lema de muestreo que puede utilizarse bajo condiciones explícitas

Para dos oráculos ya fijados antes de consultas uniformes independientes de ellos, supóngase que v difiere de la composición local de u en al menos dN posiciones. Entre M = N/2 parejas opuestas hay al menos b = ⌈dN/2⌉ parejas con una discrepancia. Al extraer q parejas distintas, la probabilidad de no consultar ninguna discrepancia está acotada por:

$$
\frac{\binom{M-b}{q}}{\binom{M}{q}}\leq(1-b/M)^q\leq(1-d)^q.
$$

Si M−b < q, la probabilidad es cero. La fórmula no exige independencia entre las q consultas porque cuenta el muestreo sin reemplazo; sí exige el modelo de consultas uniformes sobre oráculos fijados.

Como ejemplo puramente combinatorio se conserva M = 256, b = 64 y q = 40, con la fracción exacta y la cota (3/4)⁴⁰. No se presenta como probabilidad de aceptación de la variante: faltan las cotas que producirían d y las pérdidas al reemplazar el muestreo ideal por la transcripción concreta, incluyendo intentos adaptativos. El trabajo del nonce no se suma automáticamente como bits de seguridad.

El control exhaustivo y el argumento condicional S1 siguen siendo referencias útiles. **S2 avanza a «doble FRI y vínculo común implementados y probados; error de composición pendiente».** S3 y la revisión matemática independiente siguen abiertos. No se garantiza conocimiento cero: las aperturas no están enmascaradas.

## 7. Evidencia y reproducción

- [Variante experimental](../../../nexus/nexus-zk/experiments/tg2_linked_trace_fri.rs).
- [Diez pruebas](../../../nexus/nexus-zk/tests/tg2_linked_trace_fri.rs).
- [Script de análisis y conservación](../../../scripts/analizar_fri_vinculado_r4.py).
- [Análisis, formato y hashes de fuentes](../../06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado/analisis.json).
- [Registros, comandos, toolchain y 14 certificados públicos](../../06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado/validacion.json).
- [Identificación de Word, PDF y fuentes del manuscrito](../../06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado/revision-manuscrito.json).

Desde la raíz del proyecto:

    $env:CARGO_TARGET_DIR='C:\tmp\nexus-target'
    cargo test -p nexus-zk --test tg2_linked_trace_fri --release --locked --offline --manifest-path nexus/Cargo.toml -- --nocapture

La variable opcional NEXUS_TG2_LINKED_EVIDENCE_DIR permite exportar la tupla (TransitionStatement, LinkedProof). Las pruebas también necesitan el corpus anterior preservado en R4-proximidad. Los módulos de producción y sus comentarios históricos se mantienen; el estado vigente es el descrito aquí.
