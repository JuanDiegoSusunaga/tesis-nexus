# R4 — Cota de composición en el modelo interactivo ideal

**Fecha:** 22 de septiembre de 2026. **Ámbito:** Objetivo 4 de TG2. Derivación sobre la variante de FRI vinculada, pendiente de revisión matemática independiente.

## 1. Resultado y alcance

Se obtiene una cota conservadora de aceptación de un **enunciado sin traza válida sobre el campo base**, bajo oráculos ideales y retos uniformes independientes. El argumento fija el polinomio próximo antes de los coeficientes AIR, trata candidatos sobre la extensión y combina dos FRI con la comprobación local. No presupone independencia entre las consultas compartidas por ambos recorridos.

Para 40 consultas y umbrales de proximidad 1/8, la cota superior derivada va de 0,052736 a 0,134071 en los tamaños tabulados. Son redondeos hacia arriba de una garantía conservadora del modelo ideal. **No son tasas de ataques observados, ni una cota inferior de la vulnerabilidad, ni bits de seguridad del ejecutable.** Este argumento no alcanza una garantía de 100 bits; tampoco demuestra que un ataque consiga esas probabilidades.

La implementación Rust se conserva. El nuevo análisis numérico contrasta nueve tamaños y varias identidades en escenarios finitos. La última suite release de diez casos continúa identificada en la evidencia anterior; esta etapa repite check, las 197 pruebas del workspace y build.

## 2. Modelo y correspondencia con FRI

Sea F el campo Goldilocks de primo p, K = F[z]/(z²−7), N = 8T y L = 7〈ω〉, con ω de orden N. El enunciado y el oráculo u: L → K están fijados antes de tres coeficientes α uniformes independientes en K. Las capas son oráculos inmutables; cada reto β es uniforme en K y posterior a su capa. El oráculo v de composición puede depender de α y del recorrido de traza, pero queda fijado antes de sus propios retos. Las q parejas finales son uniformes, distintas e independientes de todo lo anterior.

Este modelo permite oráculos adversarios con valores fuera del campo base. En una consulta, la comprobación AIR rechaza si no puede abrir un valor de F contra el mismo oráculo. Una raíz Merkle concreta no se reemplaza gratuitamente por un oráculo ideal: la justificación criptográfica de esa sustitución queda pendiente.

La referencia es [BGK+23, Corolario 5.5 y Algoritmo 1](https://eprint.iacr.org/2023/1071), versión conservada del 15 de febrero de 2024, páginas 34 y 40. Dentro del radio de decodificación única, el error por ronda FRI está acotado por max{N/|K|, (1−δ)^q}. Para k plegados y la ronda final de consultas usamos la unión conservadora de k+1 rondas. No sustituimos ese error por ronda directamente por un error total.

La correspondencia se verifica así:

- En la capa j, el cambio x = aⱼy, con aⱼ = 7^(2^j), transforma el coset en el subgrupo. El plegado del código pasa a usar β/aⱼ. Multiplicar por una constante no nula preserva la uniformidad en K y el grado.
- El interpolante lineal en x y −x es exactamente la fórmula par/impar implementada. Las k capas terminan en una constante enviada antes de las consultas, igual que en el algoritmo de referencia.
- Una consulta empezada en x o −x verifica la misma pareja y el mismo recorrido posterior. Para una transcripción fija, si A de M = N/2 parejas son aceptables, el muestreo sin reemplazo acepta con probabilidad C(A,q)/C(M,q) ≤ (A/M)^q. Por tanto, este cambio de muestreo no aumenta el error del FRI ideal.
- Las tasas son 1/8 para traza y 1/4 para composición. Se exige δₜ ≤ 7/16 y δ꜀ ≤ 3/8, respectivamente. Compartir consultas permite una unión de eventos; no permite multiplicar las probabilidades de los dos FRI.

Esta adaptación describe el verificador ideal. No aplica directamente el corolario Fiat–Shamir del artículo al canal SHA3 local.

## 3. Polinomio próximo fijo y campo base

El código RS de grado < T sobre N puntos tiene distancia mínima (N−T+1)/N. Si 2δₜ < (N−T+1)/N, u tiene a lo sumo un polinomio f de grado < T a distancia ≤ δₜ. Cuando existe, su elección está determinada por u antes de α. La existencia de este candidato se trata por casos; no se deduce sin error de una aceptación FRI.

Escribamos f = A+zB, con A,B en F[X]. Si B no es cero, tiene a lo sumo T−1 raíces en L. En consecuencia, f toma valores base en a lo sumo T−1 posiciones. Al diferir u y f en como máximo δₜN posiciones, u conserva al menos N−(T−1)−δₜN posiciones fuera de F. Las aperturas AIR principales detectan cualquiera de ellas. Definimos:

    d_base = 1 − (T−1)/N − δₜ.

Si u es globalmente base, este argumento también demuestra que un candidato tan próximo debe tener B = 0. Para un u arbitrario en K, usamos la comprobación local y su probabilidad de omisión.

## 4. Composición y muestreo

Si f pertenece a F[X] y el enunciado es falso sobre F, f incumple alguna restricción. El argumento S1 de la revisión algebraica da probabilidad de cancelación ≤ 1/p², porque f quedó fijado antes de los tres α. Fuera de ese evento:

    dist(c_f, RS<2T) ≥ (5T+1)/(8T).

La misma fórmula racional de composición se puede evaluar sobre K; los denominadores no se anulan en L. Cambiar u respecto de f afecta a lo sumo tres veces tantas posiciones de composición. Si además v está a distancia ≤ δ꜀ de RS<2T, la desigualdad triangular da:

    dist(v, c_u) ≥ d = (5T+1)/(8T) − 3δₜ − δ꜀.

Se requiere d > 0. Cada pareja opuesta contiene a lo sumo dos discrepancias. Por ello hay al menos b = ⌈dM⌉ parejas malas. Definimos H(M,q,d) = C(M−b,q)/C(M,q), con valor cero cuando M−b < q. Este cálculo no exige independencia entre consultas sucesivas. La transcripción completa sí debe estar fijada antes del muestreo ideal.

Además, d_base−d = 1/4+2δₜ+δ꜀ > 0. El caso del candidato fuera del campo base queda cubierto por la misma cota H(M,q,d), que es mayor o igual a su probabilidad de omisión.

## 5. Proposición de composición ideal

Sean kₜ = log₂T, k꜀ = log₂(2T), con los umbrales de la sección 2 y d > 0. Definamos, para i en {t,c}:

    E_i = min{1, (k_i+1) max{N/p², (1−δ_i)^q}}.

Bajo el modelo de la sección 2, la probabilidad de aceptar un enunciado falso está acotada por:

    E_ideal = min{1, 1/p² + E_t + E_c + H(M,q,d)}.

**Demostración por casos.** Si u está lejos del código de traza, la aceptación implica el error de FRI acotado por Eₜ. Si está cerca, existe el candidato único ya fijado. Cuando este candidato no pertenece al campo base, aceptar implica omitir las posiciones no base, con probabilidad ≤ H. Cuando pertenece a F, es inválido por la falsedad del enunciado. Se separa el evento de cancelación, de probabilidad ≤ 1/p². Fuera de él, si v está lejos del código de composición, la aceptación implica el error acotado por E꜀; si está cerca, exige omitir las discrepancias entre v y c_u, con probabilidad ≤ H. El caso no base y el caso base son excluyentes para el u fijo, por lo que basta una contribución H. La unión de eventos no requiere independencia entre los dos FRI. Las garantías de cada FRI se aplican condicionalmente a su historia previa, conservando retos frescos. Esto concluye la cota en el modelo declarado.

Se usa la reducción algebraica de S1, cuya revisión independiente también sigue pendiente. Esta proposición no es una prueba de extracción eficiente ni de conocimiento cero.

## 6. Instancia conservadora y reproducción

Elegimos δₜ = δ꜀ = 1/8 y q = 40. Entonces d = 1/8+1/(8T), y las condiciones de unicidad y radios se satisfacen en los nueve tamaños de 16 a 4096 filas.

| T | Rondas FRI traza / composición | Cota superior ideal |
|---:|:---:|---:|
| 16 | 5 / 6 | 0,052736 |
| 64 | 7 / 8 | 0,074258 |
| 256 | 9 / 10 | 0,095099 |
| 4096 | 13 / 14 | 0,134071 |

Las rondas incluyen las consultas finales; la Tabla 6.18 contabiliza únicamente capas, de ahí la diferencia de una unidad. Los decimales se redondean hacia arriba desde fracciones exactas. La unión de rondas es deliberadamente conservadora y no se presenta como cota óptima. El término de muestreo domina estas cuentas; sumar automáticamente los bits de grinding no está justificado.

El script comprueba nueve perfiles, 625 palabras para unicidad, 600 polinomios no base sobre una extensión pequeña, 625 casos de localidad, 328 escenarios de muestreo exhaustivo y 117 identidades de normalización del plegado. Estas comprobaciones numéricas contrastan las cuentas; no sustituyen la demostración para todo adversario.

- [Script de análisis](../../../scripts/analizar_cota_interactiva_r4.py).
- [Fracciones exactas, contrastes y fuentes identificadas](../../06-Evidencia-TG2/2026-09-22/R4-cota-interactiva/analisis.json).
- [Verificación y alcance de esta etapa](../../06-Evidencia-TG2/2026-09-22/R4-cota-interactiva/validacion.json).
- [Manuscrito y revisión](../../06-Evidencia-TG2/2026-09-22/R4-cota-interactiva/revision-manuscrito.json).
- [Implementación y corpus anteriores](R4-FRI-Vinculado-2026-09-22.md).

## 7. Pendientes precisados

S2 cuenta ahora con una derivación de composición interactiva ideal. S3 debe justificar la compilación completa: vinculación/extracción de oráculos Merkle, definición de estados por ronda para AIR y las dos fases, codificaciones y distribución real de retos, consultas adaptativas a SHA3, grinding y transferencia ROM/QROM. La unión ordinaria obtenida aquí no reemplaza esas condiciones. S5 requiere revisión matemática independiente. El rechazo de los contraejemplos, los benchmarks y el alcance de sistemas en general conservan su interpretación anterior.
