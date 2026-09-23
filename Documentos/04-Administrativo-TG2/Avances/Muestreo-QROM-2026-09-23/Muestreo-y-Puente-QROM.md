# Muestreo y paso al verificador real en QROM

**Fecha:** 23 de septiembre de 2026. **Código:** `01dcde960402b6c60a19242b7ae3d6ac3d82a518`. **Estado:** reducción condicional propuesta; cota cuantitativa de muestreo y dictamen independiente pendientes.

## 1. Resultado de esta etapa

Se extiende el extractor al trabajo del nonce, su absorción y la cadena de índices distintos. Se construye una expansión acotada del verificador y se escribe una reducción desde aceptación falsa real a los eventos de colisión, escape de campo, omisión de parejas malas y cola de muestreo.

Con la notación que se define abajo, la reducción propuesta es

\[
 \boxed{\Pr[\text{falso y acepta en v1}]
 \le\min\left\{1,
 \left(\sqrt{\min\{1,A_T(Q+V)+\beta_{T,g,R}(Q+V)\}}
             +\sqrt{V/2^{256}}\right)^2\right\}.}
\]

`A_T` es la cota ya propuesta para colisiones o escapes de campo en la base comprimida. `V=V_T(R)` es el número máximo de llamadas hash de la expansión. **No se ha demostrado una cota útil para β.** Es el presupuesto de probabilidad que falta para omisión o cola, definido sobre un evento concreto en §5. La fórmula no constituye una garantía numérica completa de seguridad QROM.

El avance en Q3–Q4 consiste en escribir la cobertura de eventos, el cambio de juego y sus pérdidas. La brecha cuantitativa principal queda formulada como una desigualdad sobre `β`, además de la revisión de las demostraciones propuestas. No se sustituye `β` por el término clásico de nonces ni por una expresión cuadrática sin prueba.

## 2. Reconstrucción del sufijo de muestreo

Se usa la base sin orden `D` y el extractor `E(D,σ;T,g)` del [suplemento anterior](../Extractor-QROM-2026-09-23/Extractor-y-Escapes-QROM.md). Exigimos una base libre de colisiones y un prefijo completo hasta la constante final de composición.

Para `0≤n<2^64`, un candidato es `(σ,n)`. Su trabajo y semilla se reconstruyen mediante entradas diferentes:

\[
 x_w=\sigma\parallel\mathtt{05}\parallel\operatorname{u64LE}(n),
 \quad x_s=\sigma\parallel\mathtt{05}\parallel\operatorname{u64LE}(8)
                         \parallel\operatorname{u64LE}(n).
\]

Ambas respuestas deben estar presentes. Se exige `intBE(D(x_w))<2^(256−g)`, y `s₀=D(x_s)`. El sufijo continúa por

\[
 s_{j+1}=D(s_j\parallel I),\qquad
 i_j=\operatorname{intLE}((s_{j+1})_{0:8})\ \&\ (4T-1).
\]

Los índices repetidos consumen pasos pero no aumentan la lista de distintos. El extractor termina al reunir 40 distintos, encontrar una entrada ausente o alcanzar `R` extracciones, con `40≤R≤512` en las herramientas de esta etapa. Devuelve respectivamente `completo`, `incompleto` o `cola`. Terminar con 40 distintos exactamente en el paso `R` es completo.

Este recorrido es una función de los pares registrados, sin consultar `H` ni usar su orden de inserción. Las iteraciones están acotadas aunque una base artificial tenga ciclos. Un resultado incompleto no se confunde con una cola observada de `R` respuestas.

Cada candidato representado necesita una entrada `x_s` de 49 bytes. Por su codificación, una base con a lo sumo `L` entradas representa a lo sumo `L` candidatos diferentes de esta forma. Esa cuenta estructural **no** autoriza una unión clásica de probabilidades sobre consultas cuánticas.

## 3. Conjunto de parejas buenas de la transcripción extraída

Para un prefijo completo `tr=E(D,σ;T,g)`, sea `G(D,σ)⊆{0,…,4T−1}` el conjunto de parejas que cumplen simultáneamente, usando los vectores extraídos:

1. Los seis valores AIR son del campo base.
2. Las dos evaluaciones de composición coinciden con la fórmula AIR.
3. El recorrido FRI de traza satisface todos los plegados y su constante final.
4. El recorrido FRI de composición satisface todos los plegados y su constante final.

Las raíces iniciales compartidas se comprobaron al extraer el prefijo. El conjunto depende de la base examinada y de los retos extraídos; no supone que todos los vectores estuvieran completos al enviar las raíces. Las regiones sin una preimagen válida conservan la compleción con cero.

**Lema de cobertura local.** Si una ejecución aceptada tiene todas sus consultas y respuestas en una base sin colisiones, sus 40 índices pertenecen a `G(D,σ)`.

**Prueba.** Por el lema de aperturas registradas, cada valor abierto coincide con la posición del vector extraído correspondiente. La unicidad de preimágenes reconstruye el mismo prefijo y, por tanto, los mismos alpha, beta y constantes. Sustituyendo esas igualdades en los chequeos aceptados, cada pareja cumple las cuatro condiciones que definen `G`. ∎

**Lema de tamaño para un enunciado falso.** Fuera de la propiedad de escape de campo `F` definida en el suplemento anterior,

\[
 |G(D,\sigma)|\le7M/8,\qquad M=4T.
\]

**Prueba propuesta.** Los prefijos anteriores a cada reto se extraen de la misma base. En una cadena anclada y sin colisiones, retroceder desde un estado anterior devuelve el correspondiente prefijo de la transcripción completa. Las raíces y tamaños comunes extraen los mismos vectores. Por ello, si se hubiera producido una primera transición excepcional de campo, la entrada `estado || E` de ese reto sería un testigo de `F` en esta base.

Si no hay tal transición y el enunciado es falso, el estado de la derivación por rondas sigue en cero antes de la selección. Según el caso, la traza lejana, la composición lejana, un candidato no base o el enlace AIR excluyen al menos `M/8` parejas. Exigir todos los controles solo puede reducir `G`. Se aplica así la [derivación AIR/FRI por rondas](../Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md) a los vectores extraídos de esta base. ∎

El argumento usa el estado matemático de esa derivación, cuya revisión permanece pendiente. El programa calcula el predicado local `G`, pero no decide si un enunciado carece de toda traza válida ni enumera todos los eventos excepcionales del campo.

## 4. Verificador auxiliar y presupuesto finito

El Rust v1 reúne índices hasta tener 40 distintos, sin corte de 512. Para relacionarlo con un juego de consultas acotadas se define **solo en el análisis** un verificador auxiliar `V⁺_R`:

- Reproduce las validaciones y el canal originales.
- Si reúne los 40 índices en a lo sumo `R` extracciones, realiza la verificación habitual y conserva su aceptación o rechazo.
- Si todavía no reúne 40 tras `R` extracciones, devuelve el resultado especial `cola`, contado como éxito del juego ampliado.

Toda aceptación del verificador original produce aceptación o cola en este experimento ampliado. La inclusión también cubre aceptaciones que ocurren después del corte. Las ejecuciones que nunca terminan pueden producir cola en el juego ampliado, lo que hace la inclusión conservadora.

**Cola no significa aceptación de Rust.** Este mecanismo evita introducir una cota clásica de cola dentro de una prueba cuántica: la probabilidad de alcanzar el corte queda expresamente incluida en el evento pendiente `β`.

Sean `k_t=log2(T)`, `k_c=k_t+1`, `N=8T` y

\[
 W_T=40\left(6\log_2N+
       2\sum_{j<k_t}(\log_2N-j)+2\sum_{j<k_c}(\log_2N-j)\right).
\]

La expansión hace a lo sumo

\[
 V_T(R)=W_T+40(6+2k_t+2k_c)+13+2(k_t+k_c)+R
\]

consultas a `H`. Es la cuenta anterior del verificador con `R` en lugar de 512. Incluye dominio, perfil, enunciado, raíces, retos, trabajo, absorción del nonce, selección y todas las aperturas. En `T=4096,R=512`, vale `V=24.895`.

La expansión registra los pares entrada/salida en una lista de longitud fija `V`. Si faltan posiciones, repite un par ya consultado, sin nuevas consultas. Si hubo rechazo antes del primer hash, consulta el dominio una vez y lo repite: sigue dentro de `V`. Las repeticiones están permitidas por la definición 4.1 de juego base de CMS19, PDF 20.

El resultado puede repetirse usando solamente esa lista como tabla de respuestas. Una consulta ausente, dos respuestas diferentes para la misma entrada o una discrepancia de ejecución invalidan la expansión. Esta repetición no necesita acceso al oráculo.

## 5. El evento que falta acotar

Fijemos `T,g,R`. Sobre una base comprimida libre de colisiones y fuera de `F`, se definen:

- `S`: existe un candidato con prefijo completo de enunciado falso, trabajo válido, muestreo completo dentro del corte y sus 40 índices contenidos en `G(D,σ)`.
- `Tcola`: existe un candidato con prefijo completo de enunciado falso, trabajo válido y `R` respuestas de índices registradas que contienen menos de 40 distintos.

Estos eventos se definen en la base completa examinada, sin escoger candidatos después de condicionar a que su trabajo haya sido favorable. Por §3, el conjunto bueno de un testigo de `S` tiene a lo sumo `7M/8` elementos.

Sea

\[
 b_{T,g,R}(L)=\sup_{\mathcal A:\le L\text{ consultas}}
    \Pr[D_L\in S\cup T_{\mathrm{cola}}].
\]

Una función `β_{T,g,R}(L)` utilizable en la reducción debe ser una **cota superior demostrada** de `b`. El límite trivial es uno. Esta etapa no demuestra un límite menor que uno; define el problema y su relación con aceptación real. Los registros JSON dejan `beta_muestreo` y `cota_aceptacion_completa` en `null`.

La definición admite consultas en superposición, intercalación de candidatos, elección de nonces y enunciados, y bases con cadenas parciales. Toda preparación dependiente de `H` cuenta en `L`. Los scripts de contraste no simulan ese adversario general.

## 6. Juego base y cobertura de toda aceptación falsa

Definimos el juego base `J_R` sobre una lista de `V` entradas, sus `V` respuestas y un dato auxiliar que contiene enunciado, prueba y resultado de la repetición. El juego exige:

1. Perfil fijo y enunciado falso en el sentido de la relación AIR.
2. Repetición consistente de `V⁺_R` usando únicamente los pares listados.
3. Resultado aceptado o cola.

La condición de falsedad pertenece a la definición matemática del juego. La herramienta de repetición comprueba 2–3; no afirma implementar una decisión eficiente de 1. Los certificados de contraste tienen enunciados válidos.

Sea `P_J` la propiedad de base de datos asociada a `J_R`. Entonces se propone la inclusión determinista

\[
 P_J\subseteq C\cup F\cup S\cup T_{\mathrm{cola}}.
\]

**Prueba.** Si la base tiene una colisión, pertenece a `C`. En otro caso, las consultas de la expansión reconstruyen el prefijo, trabajo, semilla e índices del testigo del juego. Si hay escape de campo, pertenece a `F`. Si no lo hay, un resultado aceptado tiene sus 40 parejas en `G` por el lema local y pertenece a `S`; un resultado cola contiene las `R` respuestas requeridas y pertenece a `Tcola`. Son los dos resultados ganadores posibles del juego. ∎

No se introduce una suma por candidato ni se presupone independencia entre PoW e índices. La inclusión es entre eventos matemáticos; no depende de una observación finita del corpus.

## 7. Paso al juego de salida real

Sea `A` un adversario de `Q` consultas que entrega una única prueba clásica. El algoritmo `B` ejecuta `A` y expande su salida con `V⁺_R`. Hace como máximo `L=Q+V` consultas. Una aceptación falsa de v1 implica que `B` gana el juego de oráculo de `J_R`.

El **lema 4.9 de CMS19**, PDF 22, aplicado a una salida de `V` pares, da

\[
 \sqrt{\Pr[B\text{ gana el juego de oráculo}]}
 \le\sqrt{\Pr[B\text{ gana el juego de base}]}+\sqrt{V/2^{256}}.
\]

La inclusión de §6 y las cotas uniformes para ambos tipos de eventos implican

\[
 \Pr[B\text{ gana el juego de base}]
 \le\min\{1,A_T(L)+\beta_{T,g,R}(L)\},
\]

donde

\[
 A_T(L)=\min\left\{1,6L^2\left((N/2)\mu+(49L+1)/2^{256}\right)\right\}.
\]

Al combinar las dos desigualdades, elevar al cuadrado y limitar por uno se obtiene la fórmula de §1. El uso del lema de CMS19 y la definición de juegos se cotejaron con la [fuente primaria](https://eprint.iacr.org/2019/834.pdf), [versión conservada](../QROM-2026-09-23/bibliografia/CMS19.pdf). La adaptación del verificador auxiliar y la cobertura de eventos son propuestas de este informe.

**Pérdidas que ya quedan localizadas:** expansión `V`, presupuesto total `Q+V`, campo/colisiones `A_T` y corrección de salida `sqrt(V/2^256)`. **Pérdida pendiente:** una cota de omisión o cola `β`. Tomar el límite trivial `β=1` hace que la fórmula completa sea uno. Ese hecho expresa que todavía no se obtiene una garantía útil para aceptación falsa.

El calculador incluye una función condicional que recibe un `β` racional externo. Su nombre, docstring y salida indican que calcular con él no demuestra su hipótesis. La raíz cuadrada se redondea hacia arriba mediante enteros y fracciones; los escenarios archivados no le asignan un valor supuesto a `β`.

## 8. Contrastes y resultados

Se registran [72 cuentas de presupuesto](calculos.json), para nueve tamaños, cuatro presupuestos adversarios y cortes de 40 y 512. Estas cuentas no dependen de `g`; la probabilidad pendiente `β` sí depende de él.

Se repiten los 14 certificados con ambos cortes, para un total de 28 recorridos:

| Corte R | Aceptación ordinaria dentro del corte | Rechazo dentro del corte | Cola del experimento auxiliar |
|---:|---:|---:|---:|
| 40 | 2 | 0 | 12 |
| 512 | 8 | 6 | 0 |

En `R=512` se conserva exactamente el resultado previo: ocho honestos aceptan y seis certificados alejados rechazan en FRI de traza. En `R=40`, los doce resultados cola no se presentan como aceptación del protocolo; algunos certificados que luego rechazan quedan detenidos antes de llegar a sus chequeos FRI.

Las catorce pruebas nuevas contrastan 256 secuencias pequeñas, duplicados, ausencia de datos, terminación exactamente en el corte, trabajo/semilla, reconstrucción sin orden, pertenencia de muestras aceptadas al conjunto local, respuestas ausentes o inconsistentes y relleno de longitud fija. Un test bloquea expresamente toda llamada a SHA3 durante la repetición.

Otro control construye una **asignación artificial de oráculo**, con 512 estados distintos que producen el mismo índice. El auxiliar devuelve cola y registra una sola posición distinta. No es una cadena encontrada en SHA3, un ataque a NEXUS ni una modificación de Rust. Su función es ejercitar la rama que el corpus normal no alcanza.

La regresión reúne **80 pruebas Python y 197 Rust**, cargo check/build y el manifiesto de 897 archivos. Se conservan TG1, los cinco paquetes matemáticos anteriores y el código Rust limpio. [Validación](validacion.json), [protección](proteccion.json), [instrucciones](README.md).

## 9. Siguiente obligación matemática

Se necesita una desigualdad para `b_{T,g,R}(L)` que aproveche conjuntamente:

1. Un conjunto bueno fijado por la transcripción extraída, con tamaño a lo sumo `7M/8` fuera de escapes.
2. La cadena de estados hash completos y el descarte de índices repetidos.
3. La condición de trabajo y la absorción del mismo nonce.
4. Las consultas en superposición y los cambios de una base comprimida, incluidas cadenas parciales y referencias a estados.
5. La cola a `R` pasos, sin insertar su probabilidad clásica como si ya fuera una cota cuántica.

La capacidad de transición de oráculos comprimidos es una vía a estudiar. Se consultó el planteamiento de [Chung, Fehr, Huang y Liao](https://arxiv.org/abs/2010.11658), que analiza, entre otros problemas, profundidad de cadenas hash. No se instancia aquí su resultado como un teorema de omisión de parejas: controlar longitud secuencial y controlar la selección favorable son obligaciones diferentes.

La fórmula `(Q+1)2^-g(h_T+τ_T)` sigue perteneciendo al argumento clásico. El predicado terminal tiene el obstáculo de inestabilidad documentado en la primera etapa QROM. La reducción presente permite concentrar el trabajo cuantitativo en un evento preciso, pero **β continúa abierto** y las demostraciones propuestas requieren revisión independiente.
