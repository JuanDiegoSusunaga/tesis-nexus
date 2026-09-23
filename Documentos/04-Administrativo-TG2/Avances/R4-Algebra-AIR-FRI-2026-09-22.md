# R4 — Reducción algebraica condicional del AIR a proximidad FRI

**Fecha:** 22 de septiembre de 2026. **Ámbito:** Objetivo 4 de TG2; análisis y experimentos separados del STARK heredado de TG1.

## Resultado y alcance

Se desarrolla un argumento algebraico para una traza polinómica fijada antes de los retos y una transferencia de distancia para un oráculo próximo a esa traza. Las siete pruebas nuevas pasan en desarrollo y release; el workspace alcanza **180 pruebas**, con check y build correctos. El argumento es una demostración escrita con comprobaciones de casos concretos; queda pendiente su revisión matemática independiente.

El resultado avanza la obligación S1 de la [auditoría STARK](R4-Solidez-STARK-2026-09-22.md). Para S2 se obtiene una cota condicional, pero todavía falta demostrar que el protocolo obliga al oráculo de traza a cumplir su premisa. No se deducen 100 bits de seguridad, una cota de aceptación del verificador, conocimiento cero ni seguridad QROM.

## 1. Hipótesis y notación

Sea F el campo Goldilocks de primo p = 2⁶⁴ − 2³² + 1 y K su extensión cuadrática. Sea T una potencia de dos entre 4 y 2¹⁸, N = 8T, g una raíz de orden T y H = ⟨g⟩. El dominio de evaluación es L = 7⟨ω⟩, con ω de orden N y g = ω⁸. El análisis reproducible comprueba órdenes y L ∩ H = ∅ en los 17 tamaños admitidos. En consecuencia, D(x) ≠ 0 para todo x ∈ L, donde D(X) = Xᵀ − 1.

Se fijan el inicio s, la salida o y un polinomio f ∈ F[X] de grado menor que T **antes de elegir** los tres coeficientes α₀, α₁, α₂ ∈ K. Escribimos h₁ = gᵀ⁻¹ y h₂ = gᵀ⁻². La traza es válida cuando:

- f(1) = s y f(h₁) = o;
- C(gⁱ) = 0 para i = 0,…,T−3, con C(X) = f(g²X) − f(gX)² − f(X)².

Los numeradores con denominador común son:

$$
\begin{aligned}
N_0(X)&=(f(X)-s)\frac{D(X)}{X-1},\\
N_1(X)&=(f(X)-o)\frac{D(X)}{X-h_1},\\
N_2(X)&=C(X)(X-h_1)(X-h_2).
\end{aligned}
$$

Definimos Nα = α₀N₀ + α₁N₁ + α₂N₂, Rⱼ = Nⱼ mod D, Rα = Nα mod D y c_f(x) = Nα(x)/D(x) en L. Esta función coincide con la composición racional implementada por el AIR.

## 2. Validez, divisibilidad y grado

D tiene T raíces simples: p no divide T. En H, N₀ solo puede ser distinto de cero en 1, donde vale (f(1)−s)D′(1); N₁ solo puede serlo en h₁, donde vale (f(h₁)−o)D′(h₁). Por tanto, D divide estos numeradores exactamente cuando se cumplen sus fronteras.

Para N₂, los dos últimos puntos de H quedan anulados por los factores explícitos. En los T−2 puntos restantes esos factores son no nulos, así que D divide N₂ exactamente cuando se cumple la recurrencia. Se obtiene:

**La traza es válida si y solo si R₀ = R₁ = R₂ = 0.** Esta equivalencia se refiere a los residuos individuales, no a una sola combinación aleatoria.

Si es válida, los cocientes de frontera tienen grado como máximo T−2. Como deg C ≤ 2T−2 y el anulador de la transición tiene grado T−2, su cociente tiene grado como máximo T. Toda combinación c_f es entonces un polinomio de grado ≤ T, dentro de la cota FRI de grado < 2T. El polinomio nulo también satisface las cotas.

## 3. Cancelación y probabilidad condicionada

Si la traza fijada es inválida, al menos un Rⱼ es no nulo. Seleccionemos una coordenada no nula de ese residuo. Fijados los otros dos coeficientes α, existe a lo sumo un valor del coeficiente restante que anula esa coordenada de Rα. Como anular el residuo completo exige anular esa coordenada:

**Pr[Rα = 0] ≤ 1/p²** para coeficientes uniformes independientes en K.

Más generalmente, si los tres coeficientes son independientes y cada uno tiene masa puntual máxima μ, la cota es μ. Para dos bloques ideales uniformes de 128 bits reducidos módulo p, la masa máxima del elemento de K es:

$$
\mu=\left(\frac{\lfloor 2^{128}/p\rfloor+1}{2^{128}}\right)^2.
$$

Esta cuenta describe una elección ideal para una traza ya fijada. No acota intentos adaptativos, reinicios de transcripción, colisiones ni consultas cuánticas a Fiat–Shamir; esas pérdidas siguen en S3.

### Ejemplo reproducido

Se construye la traza honesta de T = 16 con inicio 3 y segunda fila 5, y se cambia únicamente la primera fila a 4, conservando inicio público 3 y salida original. Fallan la frontera inicial y la primera transición. Los residuos solo pueden ser no nulos en X = 1; allí N₀(1) = 16 y N₂(1) = 8177617758457.

Al elegir α₀ = −N₂(1)/N₀(1) = **10376293027944593777**, α₁ = α₂ = 1, los tres coeficientes son no nulos, Rα = 0 y la composición tiene grado 16. Esto refuta la implicación incondicional «composición de bajo grado implica traza válida».

**El ejemplo no falsifica el STARK completo:** se eligen coeficientes algebraicamente, sin forzarlos a la salida de SHA3. Además, el enunciado público conserva la traza honesta original y su testigo 5; el objeto inválido es la traza modificada, no un enunciado demostrado falso.

## 4. Distancia cuando no hay cancelación

Sea RS el código de evaluaciones sobre L de los polinomios de K[X] de grado < 2T. Consideremos cualquier h de ese grado. Si Rα ≠ 0, el polinomio P = Nα − Dh es no nulo: su residuo módulo D es Rα.

Los grados de N₀ y N₁ son ≤ 2T−2; el de N₂ es ≤ 2T. Por tanto, deg P ≤ 3T−1. Como D no se anula en L, cada acuerdo c_f(x) = h(x) es una raíz de P. Hay como máximo 3T−1 acuerdos, uniformemente para todos los candidatos h, incluso si se eligen después de observar α. La distancia de Hamming relativa satisface:

$$
\operatorname{dist}(c_f,\mathrm{RS})\geq\frac{5T+1}{8T}.
$$

La distancia a un código es la fracción mínima de posiciones que deben cambiarse para obtener una palabra del código. No equivale directamente a una probabilidad de rechazo de FRI.

## 5. Transferencia a un oráculo próximo

Supongamos ahora que un oráculo u: L → F y el mismo f inválido están fijados antes de α, y que difieren en e posiciones, ε = e/N. La composición local c_u usa u(x), u(gx) y u(g²x). Puesto que L es estable bajo multiplicación por g, los cambios se limitan a E ∪ g⁻¹E ∪ g⁻²E, de tamaño como máximo 3e.

Por la desigualdad triangular, fuera del evento de cancelación:

$$
\operatorname{dist}(c_u,\mathrm{RS})\geq
\max\left\{0,\frac{5T+1}{8T}-3\varepsilon\right\}.
$$

Si ε ≤ 1/24, esta cota es estrictamente mayor que 1/2 para todo T finito del perfil. La [tabla generada](../../06-Evidencia-TG2/2026-09-22/R4-algebra/tabla-distancias.md) presenta cotas inferiores redondeadas hacia abajo a seis decimales. Sus dos columnas presuponen una traza polinómica inválida y ausencia de cancelación.

**Premisa pendiente:** el verificador actual aplica FRI a la composición y aperturas locales a la traza; no se ha demostrado que ello imponga proximidad de u a un f de grado < T. Este lema no puede usarse suponiendo gratuitamente esa propiedad. Para un enunciado sin ninguna traza válida, todo candidato f sería inválido, pero aún habría que justificar la existencia del candidato próximo y la relación entre los oráculos comprometidos.

La composición de argumentos de proximidad requiere hipótesis adicionales; [BGK+23, Teorema 4.6 y §6](https://eprint.iacr.org/2023/1071) sirve de referencia para la obligación de correspondencia. Los lemas anteriores son la derivación específica de esta revisión, no una aplicación ya demostrada de ese teorema al ejecutable.

## 6. Pruebas, correspondencia y reproducción

El [oráculo algebraico](../../../nexus/nexus-zk/experiments/tg2_air_algebra.rs) usa operaciones polinómicas explícitas y división con residuo, limitado a 4–256 filas. No se integra en producción. Las [siete pruebas](../../../nexus/nexus-zk/tests/tg2_air_algebra.rs) cubren:

| Caso | Comprobación |
|---|---|
| Dominio del oráculo | Rechazo de tamaños ajenos al modelo y polos |
| Trazas válidas | 21 combinaciones: siete tamaños y tres pares inicio/testigo; divisibilidad y grados |
| Restricciones inválidas | Errores de frontera inicial, frontera final y transición dejan residuos |
| Cancelación | Coeficientes no nulos anulan errores de una traza inválida |
| Correspondencia con el probador | Composición exacta y racional coinciden en los 128 puntos; aperturas reales de la primera capa FRI cotejadas con los índices de la transcripción |
| Identidad residual | Caso inválido con h = X³¹: P tiene grado 47 y satisface la identidad en los 128 puntos |
| Transferencia | Dos cambios del oráculo afectan seis valores de composición, conforme a la cota 3e |

La suite completa de desarrollo pasó **180 pruebas**. Los siete casos algebraicos pasaron también en release. Se ejecutaron check de todos los targets y build del workspace. Los registros, comandos, toolchain y SHA-256 están en [validacion.json](../../06-Evidencia-TG2/2026-09-22/R4-algebra/validacion.json). No se repitieron benchmarks ni se alteraron los valores medidos.

El [script numérico](../../../scripts/analizar_algebra_air_r4.py) comprueba los 17 dominios, calcula las fracciones sin coma flotante y reproduce de forma independiente el coeficiente de cancelación con aritmética modular de Python. El [análisis y manifiesto de fuentes](../../06-Evidencia-TG2/2026-09-22/R4-algebra/analisis.json) conserva las instantáneas de los ocho módulos STARK, oráculo, pruebas, manifiestos Cargo y script.

Las pruebas finitas detectan errores de implementación y contrastan ejemplos; no sustituyen la demostración para todo adversario ni la revisión externa.

## 7. Manuscrito y siguiente obligación

La edición consolidada incorpora §6.7.2, Tabla 6.16 y los resultados en resúmenes y conclusiones. La [revisión del manuscrito](../../06-Evidencia-TG2/2026-09-22/R4-algebra/revision-manuscrito.json) identifica los archivos Word, PDF y Markdown mediante hashes.

| Obligación | Estado después de este avance |
|---|---|
| S1: reducción algebraica | Argumento escrito y ejemplos contrastados para f fijo de grado < T; revisión independiente pendiente |
| S2: proximidad y correlación | Transferencia condicional demostrada; falta establecer la premisa para el oráculo comprometido y enlazar los oráculos locales/FRI |
| S3: Fiat–Shamir, Merkle, ROM/QROM | Pérdidas concretas y correspondencia pendientes |
| S4: perfil y API | Parámetros caracterizados; no se ha sustituido el presupuesto heredado por una garantía |
| S5: revisión externa | Pendiente |

**Siguiente trabajo técnico:** determinar si el protocolo heredado permite justificar la proximidad y correlación necesarias. Si se necesita una comprobación adicional, describirla y evaluarla como variante experimental de TG2, manteniendo preservado TG1.
