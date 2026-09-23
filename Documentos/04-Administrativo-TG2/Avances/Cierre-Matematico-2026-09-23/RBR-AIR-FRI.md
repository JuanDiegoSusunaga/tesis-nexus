# Solidez por rondas del IOP conjunto AIR/FRI de NEXUS

**Estado:** demostración propuesta para revisión independiente. **Modelo:** interactivo ideal. **Fecha:** 2026-09-23.

## 1. Pregunta y alcance

La [derivación S2 anterior](../R4-Cota-Interactiva-2026-09-22.md) acotaba una ejecución interactiva completa. La [auditoría S3](../R4-Merkle-Fiat-Shamir-2026-09-23.md) señalaba que ese error ordinario no se puede sustituir por un error por ronda en un teorema de compilación Fiat–Shamir. Aquí se desarrolla precisamente la función de estado del protocolo conjunto y su error por ronda.

La estructura del argumento FRI sigue la función de estado de Garreta, Mohnblatt y Wagner, **Teorema 5.2 de la revisión publicada el 31 de marzo de 2026, con portada fechada el 27 de marzo**, basada en la conservación de conjuntos de acuerdo. Se demuestra abajo un lema elemental suficiente para nuestros umbrales; no se instancia la expresión general de acuerdo correlacionado del artículo. La revisión consultada está identificada y conservada. No se afirma originalidad global de este lema ni se presenta una formalización en Lean.

El teorema resultante trata la recurrencia AIR demostrativa. No prueba validez de ML-DSA, aritmetización de una aplicación completa, conocimiento cero, extracción eficiente de testigos ni seguridad cuántica del ejecutable.

## 2. Hipótesis y notación

Se conservan las definiciones de S1: campo base $F$ de primo $p=2^{64}-2^{32}+1$, extensión $K=F[z]/(z^2-7)$, $N=8T$, $L=7\langle\omega\rangle$, $D=X^T-1$ y $16\le T\le4096$, potencia de dos. El enunciado es falso cuando no existe traza válida sobre $F$.

El probador fija el oráculo completo $u:L\to K$ antes de tres retos independientes $\alpha_0,\alpha_1,\alpha_2$. El FRI de traza usa ese mismo oráculo y grado menor que $T$. Después, el probador puede escoger $v:L\to K$ para composición en función de toda la historia anterior; su grado declarado es menor que $2T$. Cada capa se fija antes de su reto de plegado. Las constantes finales se envían antes del muestreo. Se eligen $q$ parejas opuestas distintas, uniformemente y de una sola vez, entre $M=N/2$ parejas. El muestreo es posterior a todos los oráculos y retos anteriores.

Las aperturas ideales son evaluaciones de esos oráculos inmutables. El verificador exige valores base para las seis posiciones AIR y evalúa el enlace y los dos FRI en cada pareja. Se puede incluir un mensaje de nonce antes de las consultas: por sí mismo no aporta aleatoriedad ni mejora la cota de este modelo.

Para los umbrales $\delta_t,\delta_c>0$ exigimos:

$$
2\delta_t<\frac{N-T+1}{N},\qquad
d=\frac{5T+1}{8T}-3\delta_t-\delta_c>0.
$$

En cada fase $i\in\{t,c\}$, sean $d_{i,0}=T,2T$, respectivamente, $k_i=\log_2d_{i,0}$, $n_j=N/2^{j+1}$ y $d_{i,j+1}=d_{i,0}/2^{j+1}$. Para aplicar el lema siguiente exigimos además

$$
(1-3\delta_i)n_j>d_{i,j+1}-1\quad(0\le j<k_i).
$$

Estas condiciones se satisfacen para $\delta_t=\delta_c=1/8$ en los nueve tamaños admitidos. No se extrapola el lema a otros radios sin comprobar esta desigualdad estricta.

## 3. Lema elemental de acuerdo para dos funciones

**Lema A.** Sea $C=\operatorname{RS}[K,Y,e]$, con $|Y|=n\ge1$, $e\ge1$ y $(1-3\theta)n>e-1$. Sean $a,b:Y\to K$ arbitrarias. Excepto para a lo sumo $n$ valores de $\beta\in K$, se cumple simultáneamente para todo $S\subseteq Y$ de tamaño al menos $(1-\theta)n$:

si $a+\beta b$ coincide en $S$ con un polinomio de grado menor que $e$, entonces tanto $a$ como $b$ coinciden en ese mismo $S$ con sendos polinomios de grado menor que $e$.

**Demostración.** Sea $R$ el conjunto de valores $\beta$ que admiten algún par $(S,h)$ con ese acuerdo. Si $|R|\le1$, hay a lo sumo un valor excepcional y la conclusión se cumple.

Si $|R|\ge2$, escogemos $\beta_0\ne\beta_1$, conjuntos $S_0,S_1$ y polinomios $h_0,h_1$. Definimos

$$
B=\frac{h_1-h_0}{\beta_1-\beta_0},\qquad A=h_0-\beta_0B.
$$

Ambos tienen grado menor que $e$, y $a=A$, $b=B$ en $S_0\cap S_1$. Para cualquier otro $\beta\in R$ y cualquier testigo $(S,h)$, el conjunto $S\cap S_0\cap S_1$ tiene al menos $(1-3\theta)n>e-1$ puntos. Allí $h=A+\beta B$, por lo que la igualdad vale como identidad polinómica. Para $\beta_0$ y $\beta_1$ la misma conclusión para cualquier testigo alternativo se sigue de la intersección de dos conjuntos, de tamaño al menos $(1-2\theta)n>e-1$.

Sea $E=\{y:(a(y),b(y))\ne(A(y),B(y))\}$. En cada $y\in E$, la ecuación

$$
a(y)+\beta b(y)=A(y)+\beta B(y)
$$

admite a lo sumo un valor de $\beta$: ninguno si $b(y)=B(y)$ y uno si difieren. Si un valor de $\beta$ no está entre esos a lo sumo $|E|\le n$ valores, cualquier conjunto de acuerdo $S$ evita $E$. Entonces $A$ y $B$ son los dos polinomios requeridos sobre $S$. Esto prueba el lema. Para $\beta$ uniforme, la probabilidad excepcional es a lo sumo $n/|K|$. $\square$

El lema conserva **el mismo conjunto** de acuerdo para ambas funciones. Conocer únicamente la distancia individual de un plegado no bastaría para el argumento de consultas que sigue.

## 4. Estado de un FRI y cota de consultas

En una capa $w:L_j\to K$, para $y=x^2$ definimos

$$
a(y)=\frac{w(x)+w(-x)}2,\qquad
b(y)=\frac{w(x)-w(-x)}{2x}.
$$

Son funciones bien definidas porque cambiar $x$ por $-x$ deja ambas expresiones iguales. El plegado implementado es $a+\beta b$. Si $a,b$ coinciden con polinomios $A,B$ de grado menor que $d_{j+1}$ sobre $S^2$, entonces $A(X^2)+XB(X^2)$ tiene grado menor que $d_j$ y coincide con $w$ sobre $S$.

Para una fase con umbral $\theta$, llamamos **evento excepcional de plegado** a que exista $S\subseteq L_j$ tal que:

1. $|S^2|\ge(1-\theta)|L_{j+1}|$;
2. el plegado de $w$ coincide con algún elemento del código de la capa siguiente sobre $S^2$;
3. ningún polinomio del código de la capa actual coincide con $w$ sobre $S$.

Por el lema A, ese evento tiene probabilidad condicional a lo sumo

$$
\eta_j=\frac{|L_{j+1}|}{|K|}=\frac{N}{2^{j+1}p^2}.
$$

La cota vale después de cualquier historia y para cualquier capa elegida antes de $\beta$. Se marca el primer evento excepcional y la marca se conserva. Los mensajes del probador no crean esa marca.

**Lema B: consultas cuando no hubo eventos excepcionales.** Si el oráculo inicial está a distancia mayor que $\theta$ de su código, la fracción de parejas que acepta el recorrido FRI completo es a lo sumo $1-\theta$, para cualquier constante final.

**Demostración.** Sea $A\subseteq L_0$ el conjunto de puntos iniciales cuyo recorrido acepta. Es una unión de parejas $\{x,-x\}$. Sea $W_j=\{x^{2^j}:x\in A\}$. Como cada aplicación de cuadrado tiene fibras de tamaño dos, $|W_j|/|L_j|\ge|A|/N$.

Supongamos $|A|/N>1-\theta$. La constante final pertenece al código final y coincide con la última capa sobre $W_k$. Por aceptación, cada capa siguiente coincide con el plegado de la anterior sobre $W_{j+1}$. Si existe un polinomio que coincide con esa capa siguiente sobre $W_{j+1}$, la ausencia del evento excepcional, aplicada a $S=W_j$, implica que existe un polinomio que coincide con la capa anterior sobre $W_j$. Retrocediendo hasta $j=0$, el oráculo inicial coincide con un polinomio de su código sobre $A$. Su distancia sería menor que $\theta$, contradicción. $\square$

Por tanto, hay al menos $\lceil\theta M\rceil$ parejas rechazadas. Definimos

$$
H(M,q,x)=\frac{\binom{M-\lceil xM\rceil}{q}}{\binom Mq},
$$

con numerador cero si $M-\lceil xM\rceil<q$. La omisión de todas las parejas malas tiene probabilidad a lo sumo $H(M,q,\theta)\le(1-\theta)^q$. Esto contempla consultas sin reemplazo; no requiere multiplicar probabilidades de los dos FRI.

## 5. Estado del protocolo conjunto

Usamos un estado $s\in\{0,1\}$: $s=0$ indica que aún no ha ocurrido una transición excepcional que pueda permitir la aceptación. Una vez $s=1$, permanece en ese valor. Para enunciados válidos puede fijarse $s=1$ desde el inicio; para un enunciado falso empezamos en cero. La función es matemática y no necesita ser computable eficientemente.

### 5.1 Elección de caso al fijar la traza

Al recibir el oráculo completo $u$:

- **Traza lejana:** si $\operatorname{dist}(u,\operatorname{RS}_{<T})>\delta_t$, se vigilan los eventos excepcionales del FRI de traza. Los retos AIR y la fase de composición no cambian el estado. Después de la constante de traza, su estado se conserva hasta la consulta común.
- **Candidato próximo no base:** en otro caso existe un único $f\in K[X]$ de grado menor que $T$ a distancia a lo sumo $\delta_t$, fijado por $u$ antes de los $\alpha$. Si $f\notin F[X]$, se conserva estado cero hasta la consulta final.
- **Candidato próximo base:** si $f\in F[X]$, se vigila la cancelación AIR y, después, la proximidad del oráculo de composición.

La unicidad viene de la distancia mínima RS y de la desigualdad de §2. Para el candidato no base, escribir $f=A+zB$ con $B\ne0$ muestra que $f$ toma valores base en a lo sumo $T-1$ puntos. Así, $u$ tiene al menos $d_{\mathrm{base}}N$ valores no base, donde

$$
d_{\mathrm{base}}=1-\frac{T-1}{N}-\delta_t.
$$

El verificador AIR los detecta en la pareja principal; sus omisiones quedan acotadas por $H(M,q,d_{\mathrm{base}})$.

### 5.2 Tres retos AIR separados

Para un candidato base, sea $R_i=N_i\bmod D$ el residuo de cada numerador definido en S1. Algún $R_i$ es no nulo porque el enunciado es falso. Sea $j_*=\max\{i:R_i\ne0\}$, determinado antes de los retos.

Antes de $\alpha_{j_*}$ mantenemos el estado cero. Al recibir ese reto, cambiamos a uno exactamente si

$$
\sum_{i=0}^{j_*}\alpha_iR_i=0.
$$

Condicionada a los coeficientes anteriores, esta igualdad vectorial tiene a lo sumo una solución para $\alpha_{j_*}$, porque $R_{j_*}\ne0$. Su probabilidad es a lo sumo $1/p^2$. Los residuos posteriores son cero: esta es precisamente la cancelación total, no una cancelación parcial que otro reto pueda revertir. Los otros dos retos no permiten escapar del estado cero. Agrupar los tres retos tampoco es necesario.

### 5.3 Elección al fijar la composición

Fuera de cancelación, S1 y la transferencia local dan

$$
\operatorname{dist}(c_u,\operatorname{RS}_{<2T})
\ge \frac{5T+1}{8T}-3\delta_t.
$$

La fórmula $c_u$ se extiende algebraicamente a valores en $K$. Si el verificador no puede abrir un valor base, rechaza; esa extensión no le concede aperturas no base.

Cuando se fija $v$, si está a distancia mayor que $\delta_c$ de su código, se vigilan los eventos excepcionales del FRI de composición. Si está a distancia a lo sumo $\delta_c$, se conserva estado cero y se usa $\operatorname{dist}(v,c_u)\ge d$ para la consulta final. La elección de $v$ puede depender de todos los retos de traza sin alterar estas desigualdades.

### 5.4 Consulta final compartida

Si hasta aquí $s=0$, se pasa a $s=1$ exactamente si el verificador acepta. La transcripción y el caso activo están fijados antes de esta consulta. Según el caso, aceptar exige superar FRI de traza, FRI de composición, el control de campo base o el enlace local. Por §4 y §5, el error de esta ronda está acotado por

$$
h_* = \max\{H(M,q,\delta_t),H(M,q,\delta_c),H(M,q,d),H(M,q,d_{\mathrm{base}})\}.
$$

Se toma un máximo porque, para cada prefijo fijo, se ha seleccionado un único caso. No se afirma independencia entre verificaciones. Una transcripción completa en estado cero se rechaza por definición. Los mensajes del probador mantienen el estado; un formato inválido conduce a rechazo.

## 6. Proposición conjunta y cota ordinaria

**Proposición C.** Bajo §2, la función de estado anterior satisface solidez por rondas con

$$
\varepsilon_{\mathrm{rbr}}
\le \max\left\{p^{-2},\frac{N}{2p^2},h_*\right\}.
$$

**Justificación.** El enunciado falso empieza en cero, los mensajes del probador no lo cambian, cada reto de cancelación o plegado tiene la cota condicional demostrada y la consulta final tiene cota $h_*$. El estado uno es absorbente y el estado cero al final implica rechazo. Son las condiciones de la función de estado por rondas. $\square$

También podemos evitar una unión uniforme sobre todas las rondas. Sean

$$
\Lambda_t=\frac{N-8}{p^2},\qquad
\Lambda_c=\frac{N-4}{p^2},\qquad
h_t=H(M,q,\delta_t),\quad h_c=H(M,q,\delta_c),\quad h_d=H(M,q,d).
$$

Las dos sumas $\Lambda_i$ se obtienen sumando los tamaños de los dominios **después** de cada plegado: series geométricas que terminan en 8 y 4. Por casos y unión de los eventos excepcionales de cada fase activa,

$$
E_{\mathrm{ideal}}^{\mathrm{nuevo}}
\le\min\left\{1,\max\left\{
\Lambda_t+h_t,
H(M,q,d_{\mathrm{base}}),
p^{-2}+\Lambda_c+\max(h_c,h_d)
\right\}\right\}.
$$

El caso de traza lejana excluye los dos casos de candidato próximo. En el candidato base, tras separar la cancelación, la selección adversaria de $v$ solo escoge entre dos casos que ya tienen cotas uniformes. Sumar $\Lambda_c$ y tomar el máximo de sus errores finales cubre ambos. No hace falta pagar los plegados de traza cuando el candidato próximo ya está determinado por $u$.

Para $\delta_t=\delta_c=1/8$, se tiene $d=1/8+1/(8T)$ y $d_{\mathrm{base}}>d$. Para $q=40$ en los nueve perfiles:

$$
\varepsilon_{\mathrm{rbr}}=H(4T,40,1/8)\quad\text{como cota escogida},
$$

$$
E_{\mathrm{ideal}}^{\mathrm{nuevo}}
\le H(4T,40,1/8)+\frac{8T-3}{p^2}.
$$

La igualdad de la primera expresión identifica el máximo usado como cota, no el error óptimo real del protocolo.

| Filas $T$ | Cota ideal anterior, redondeada hacia arriba | Nueva cota ideal, redondeada hacia arriba |
|---:|---:|---:|
| 16 | 0,052736 | 0,000166165 |
| 64 | 0,074258 | 0,002934060 |
| 256 | 0,095099 | 0,004282720 |
| 4096 | 0,134071 | 0,004757331 |

Las fracciones exactas distinguen la cota por ronda de la ordinaria aunque sus decimales coincidan a esta precisión. La mejora procede del argumento y del cómputo de errores; el código y los parámetros no se han cambiado. No se deduce una tasa de ataque ni un número de bits de seguridad del ejecutable.

## 7. Qué aporta a los reinicios y qué falta para Fiat–Shamir

**Corolario de intentos ideales.** Si un adversario clásico puede restaurar estados y pedir a lo sumo $B$ retos nuevos del experimento ideal, cada uno muestreado según su distribución prescrita, la probabilidad de conseguir una transcripción falsa aceptada es a lo sumo $\min(1,B\varepsilon_{\mathrm{rbr}})$. Basta asociar a cualquier aceptación la primera transición cero a uno y aplicar unión sobre los intentos, condicionando por toda la historia del adversario. Las respuestas a una consulta repetida no cuentan como monedas nuevas.

Se puede refinar la cuenta usando $p^{-2}$ para los intentos AIR, $n_j/p^2$ para los de cada plegado y $h_*$ para las consultas finales. El corolario presupone acceso a los oráculos completos fijados y a un muestreo conjunto ideal; **$B$ no está identificado con el número de llamadas a SHA3**.

El resultado permite reemplazar la obligación «construir estados por ronda del IOP conjunto» por una demostración concreta pendiente de revisión. Para dar el siguiente paso siguen faltando:

| Paso | Lo que esta etapa establece | Trabajo necesario para el ejecutable |
|---|---|---|
| Oráculos | Vectores completos inmutables en el IOP | Extracción o simulación compatible con raíces Merkle arbitrarias |
| Retos AIR/FRI | Uniformes frescos en $K$; control de cada ronda | Sesgo modular, consultas adaptativas, colisiones y cadenas de estado |
| Consultas | Lista uniforme distinta enviada como un solo reto | Correspondencia con extracciones SHA3 sucesivas y rechazo de duplicados |
| Nonces | Un mensaje previo no empeora el IOP; reinicios ideales cuestan intentos | Relacionar intentos reales de grinding y consultas hash con la reducción |
| Modelo | Solidez ordinaria y por rondas del IOP | Compilación ROM concreta; QROM y extracción de conocimiento por separado |

El lema de vinculación Merkle anterior no basta para extraer un vector completo. Tampoco basta insertar este $\varepsilon_{\mathrm{rbr}}$ en la fórmula BCS sin verificar que el canal implementado corresponde a esa compilación. No se suman automáticamente los 12/20 bits de grinding. R1-A–D sobre ML-DSA permanece separado.

## 8. Comprobaciones y fuentes

El [script](../../../../scripts/analizar_rbr_conjunto_tg2.py) calcula nueve perfiles con fracciones exactas y rechaza parámetros fuera de las hipótesis. Las [siete pruebas](../../../../scripts/tests/test_rbr_conjunto_tg2.py) comprueban las sumas geométricas, redondeos superiores, consulta exhaustiva, 328 escenarios de muestreo, **390.625 pares completos de funciones sobre cuatro puntos en F5**, 6.056 prefijos de cancelación vectorial en F3² y 4.352 combinaciones de palabra binaria/reto de un FRI pequeño en F17, enumerando también sus constantes finales.

Son contrastes de instancias finitas y de la aritmética, no una prueba automática de las proposiciones generales ni una auditoría externa. Las condiciones generales están escritas en las demostraciones anteriores. El código Rust se conserva y sus comprobaciones se registran en [validacion.json](validacion.json).

Fuentes primarias:

1. Garreta, Mohnblatt y Wagner, [A Simplified Round-by-round Soundness Proof of FRI](https://eprint.iacr.org/2025/1993), revisión 2026-03-31: Definiciones 2.2 y 3.4–3.5, Lema 5.1 y Teorema 5.2, pp. 4, 6 y 14–19 de la copia conservada. [PDF local](bibliografia/GMW25.pdf).
2. Block y colaboradores, [Fiat-Shamir Security of FRI and Related SNARKs](https://eprint.iacr.org/2023/1071), edición local de 2024-02-15: Definición 3.12 y Teorema 3.15, pp. 24–25. Sirve para situar la obligación de compilación, sin instanciarla para SHA3.
3. [S1: divisibilidad, residuos y transferencia local](../R4-Algebra-AIR-FRI-2026-09-22.md); [S2: cota ideal anterior](../R4-Cota-Interactiva-2026-09-22.md); [S3: auditoría de Merkle/Fiat–Shamir](../R4-Merkle-Fiat-Shamir-2026-09-23.md).

La construcción de estado y la composición propuestas aquí requieren lectura crítica independiente. No se atribuye esa revisión al director ni a los autores citados.
