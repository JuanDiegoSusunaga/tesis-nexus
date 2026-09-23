---
title: "NEXUS — Derivaciones matemáticas de TG2"
subtitle: "AIR, proximidad de traza, composición ideal y auditoría Merkle/Fiat–Shamir"
author: "Juan Diego Susunaga Velasquez"
date: "23 de septiembre de 2026 · Documento para revisión matemática"
lang: es
---

# 1. Propósito y estado de los resultados

Este documento reúne en una lectura continua las derivaciones desarrolladas para la validación de TG2 durante el 22 y 23 de septiembre de 2026. Incluye hipótesis, argumentos, cuentas numéricas y relación con los experimentos. El ámbito de NEXUS es **sistemas en general**; el objeto algebraico de estas derivaciones es una recurrencia AIR demostrativa.

**Estado: preparado para revisión matemática independiente.** Los argumentos escritos y las comprobaciones finitas se conservan como resultados de trabajo. Este documento no registra un dictamen, aprobación o envío al director. La aprobación previa comunicada por el autor no se atribuye a las derivaciones posteriores.

La validez de firmas ML-DSA y las reglas completas de una aplicación no están aritmetizadas en este AIR. Las conclusiones sobre el AIR no constituyen una reducción de seguridad de ML-DSA ni una validación integral de la arquitectura blockchain.

**Tabla 1.1 — Resultados y alcance de esta recopilación.**

| Bloque | Resultado disponible | Condición o límite |
|---|---|---|
| S1 | Divisibilidad, cancelación y distancia de composición | Traza polinómica fijada antes de los retos |
| Proximidad | Contraejemplo para una premisa propuesta del legado | Los enunciados ensayados son válidos |
| S2 | Cota conservadora del protocolo interactivo ideal | Oráculos inmutables, retos frescos y adaptación FRI por revisar |
| S3 | Vinculación Merkle y sesgo exacto de retos | No establece extracción ni compilación ROM/QROM completa |

La sección 3 desarrolla S1; la sección 4 precisa por qué su premisa de proximidad no se puede atribuir al legado. La sección 5 describe el vínculo implementado en TG2 y la sección 6 presenta S2. La sección 7 trata S3. Las secciones finales reúnen evidencia, obligaciones y referencias.

El documento consolida los informes [A1]–[A5] de la sección 10. Cuando un informe anterior describe una obligación que luego avanzó o fue refutada, aquí se presenta su estado posterior de forma explícita.

## 1.1 Cómo interpretar los pendientes

Hay dos situaciones distintas. S1 y S2 contienen argumentos escritos bajo hipótesis explícitas; un revisor debe comprobar sus pasos, condiciones y uso de resultados previos. En S3 sigue abierto un paso de demostración: justificar la transferencia completa desde el modelo ideal al canal concreto del ejecutable.

En el modelo ideal, el probador fija los datos antes de recibir retos aleatorios frescos. En la implementación, SHA3 calcula retos a partir de la transcripción. Un probador adversario puede explorar compromisos o nonces y elegir qué intento presentar. El análisis debe contabilizar esa exploración y justificar que los compromisos Merkle permiten usar el modelo de oráculos del argumento.

Las pérdidas de seguridad son los términos adicionales de la cota al incorporar esas estrategias e hipótesis; no describen rendimiento computacional. La cota ideal se sostiene dentro de su modelo declarado, pendiente de revisión. Aplicarla al ejecutable completo requiere el argumento adicional. Este pendiente, por sí solo, no demuestra que exista un ataque.

# 2. Notación, dominios e hipótesis

## 2.1 Campos y dominios

Sea el campo base Goldilocks y su extensión cuadrática:

$$
p=2^{64}-2^{32}+1,\qquad
\mathbb F=\mathbb F_p,\qquad
\mathbb K=\mathbb F[z]/(z^2-7),\qquad |\mathbb K|=p^2.
$$

Sea $T$ una potencia de dos, $N=8T$, $\omega$ una raíz de orden $N$ y $g=\omega^8$, de orden $T$. Se definen:

$$
H=\langle g\rangle,\qquad L=7\langle\omega\rangle,\qquad
D(X)=X^T-1,\qquad h_1=g^{T-1},\quad h_2=g^{T-2}.
$$

El análisis de dominios conservado comprueba órdenes y $L\cap H=\varnothing$ para los 17 tamaños heredados entre $4$ y $2^{18}$. En consecuencia, $D(x)\ne0$ en $L$. La variante vinculada analizada en S2 admite únicamente los nueve tamaños potencia de dos entre $16$ y $4096$.

La multiplicación por $g$ permuta $L$. Como $N$ es par, los puntos de $L$ se agrupan en $M=N/2$ parejas opuestas $\{x,-x\}$.

## 2.2 Códigos, distancias y validez

Se escribe $\mathrm{RS}_{<d}(L;\mathbb K)$ para las evaluaciones en $L$ de polinomios de $\mathbb K[X]$ de grado menor que $d$. La distancia es Hamming relativa:

$$
\operatorname{dist}(u,v)=\frac{\#\{x\in L:u(x)\ne v(x)\}}{N},\qquad
\operatorname{dist}(u,\mathcal C)=\min_{v\in\mathcal C}\operatorname{dist}(u,v).
$$

El enunciado público fija inicio $s$, salida $o$ y filas $T$. La segunda fila actúa como testigo de la recurrencia demostrativa. Para $f\in\mathbb F[X]$, $\deg f<T$, la traza es válida si:

$$
f(1)=s,\qquad f(h_1)=o,
$$

$$
C_f(g^i)=0\quad(0\le i\le T-3),\qquad
C_f(X)=f(g^2X)-f(gX)^2-f(X)^2.
$$

Una **traza inválida** incumple estas restricciones. Un **enunciado falso sobre el campo base** no admite ninguna traza válida sobre $\mathbb F$. Una traza inválida no vuelve falso por sí sola su enunciado; puede existir otro testigo válido.

**Tabla 2.1 — Símbolos principales.**

| Símbolo | Significado |
|---|---|
| $u:L\to\mathbb K$ | Oráculo de traza comprometido en el modelo ideal |
| $v:L\to\mathbb K$ | Oráculo de composición |
| $\alpha_0,\alpha_1,\alpha_2$ | Retos de combinación de restricciones AIR |
| $\beta$ | Retos de plegado FRI |
| $c_f$, $c_u$ | Composición racional de una traza polinómica o un oráculo |
| $\delta_t$, $\delta_c$ | Umbrales de proximidad de traza y composición |
| $q$ | Número de parejas consultadas; $q=40$ en la variante |
| $k_t$, $k_c$ | Número de plegados FRI de cada fase |

En los argumentos de grados, el polinomio cero satisface las cotas superiores. La representación de elementos, la validez de índices y la forma del compromiso se tratan por separado en S3.

# 3. S1 — Del AIR a la distancia de composición

## 3.1 Numeradores con denominador común

Se fija $f\in\mathbb F[X]$, $\deg f<T$, antes de escoger los tres retos $\alpha_j\in\mathbb K$. Se definen:

$$
\begin{aligned}
N_0(X)&=(f(X)-s)\frac{D(X)}{X-1},\\
N_1(X)&=(f(X)-o)\frac{D(X)}{X-h_1},\\
N_2(X)&=C_f(X)(X-h_1)(X-h_2).
\end{aligned}
$$

Los cocientes $D/(X-1)$ y $D/(X-h_1)$ son polinomios. Se escriben:

$$
N_\alpha=\sum_{j=0}^{2}\alpha_jN_j,\qquad
R_j=N_j\bmod D,\qquad R_\alpha=N_\alpha\bmod D,
$$

$$
c_f(x)=\frac{N_\alpha(x)}{D(x)}\quad(x\in L).
$$

Esta función coincide con la composición racional del AIR inspeccionado. No tiene polos en el dominio de evaluación porque $D$ no se anula allí.

## 3.2 Proposición S1.1 — Validez y divisibilidad

**Enunciado.** Bajo las hipótesis anteriores, la traza es válida si y solo si $R_0=R_1=R_2=0$.

**Argumento.** El polinomio $D$ tiene $T$ raíces simples porque $p$ no divide $T$. En $H$, $N_0$ se anula en todos los puntos salvo posiblemente en $1$, donde vale $(f(1)-s)D'(1)$. Como $D'(1)\ne0$, $D\mid N_0$ equivale a la frontera inicial. Análogamente, $D\mid N_1$ equivale a $f(h_1)=o$.

Los factores $(X-h_1)(X-h_2)$ anulan las dos últimas posiciones de $H$ en $N_2$. En las otras $T-2$ posiciones esos factores son no nulos. Por tanto, $D\mid N_2$ equivale a cumplir todas las transiciones. Reunir las tres equivalencias da el resultado.

La proposición trata los residuos individuales. Una combinación aleatoria de esos residuos puede anularse aunque alguno de ellos no sea cero.

## 3.3 Proposición S1.2 — Grado en el caso válido

**Enunciado.** Si la traza es válida, la composición es un polinomio de grado como máximo $T$, contenido en $\mathrm{RS}_{<2T}(L;\mathbb K)$.

**Argumento.** Los cocientes de frontera tienen grado a lo sumo $T-2$. Además, $\deg C_f\le2T-2$ y el anulador de las posiciones de transición tiene grado $T-2$. La división exacta correspondiente tiene grado a lo sumo $T$. La combinación lineal conserva esa cota.

## 3.4 Proposición S1.3 — Cancelación de restricciones inválidas

**Enunciado.** Para una traza inválida fijada antes de retos uniformes independientes en $\mathbb K$:

$$
\Pr[R_\alpha=0]\le\frac1{p^2}.
$$

**Argumento.** Algún $R_j$ es no nulo. Elegir una coordenada no nula de ese residuo y fijar los otros dos coeficientes deja una ecuación lineal no degenerada en $\alpha_j$. Existe a lo sumo un valor que anula esa coordenada. Anular todo el residuo exige anularla, y $\alpha_j$ es uniforme entre $p^2$ posibilidades.

Para coeficientes independientes con masa puntual máxima $\mu$, el mismo argumento da la cota $\mu$. Si cada componente de extensión proviene de un bloque independiente uniforme de 128 bits reducido módulo $p$:

$$
\mu=\left(\frac{\lfloor2^{128}/p\rfloor+1}{2^{128}}\right)^2.
$$

Esta cuenta presupone la independencia declarada. No cubre búsquedas adaptativas de compromisos, reinicios o consultas a la transcripción concreta de Fiat–Shamir.

### Ejemplo de cancelación reproducido

Con $T=16$, inicio $3$ y segunda fila $5$, se modifica solo la primera fila honesta a $4$, conservando el enunciado original. Fallan la frontera inicial y la primera transición. Los residuos solo pueden ser no nulos en $X=1$, con $N_0(1)=16$ y $N_2(1)=8177617758457$.

Los coeficientes no nulos:

$$
\alpha_0=-\frac{N_2(1)}{N_0(1)}=10376293027944593777,\qquad
\alpha_1=\alpha_2=1
$$

anulan $R_\alpha$ y producen composición de grado $16$. El ejemplo refuta la implicación incondicional «composición de bajo grado implica traza válida». Se eligen los coeficientes algebraicamente; no se fuerzan salidas de SHA3. El enunciado conserva un testigo honesto, por lo que el ejemplo no presenta una falsificación del STARK completo.

## 3.5 Proposición S1.4 — Distancia fuera de la cancelación

**Enunciado.** Si $R_\alpha\ne0$, entonces:

$$
\operatorname{dist}\bigl(c_f,\mathrm{RS}_{<2T}(L;\mathbb K)\bigr)
\ge\frac{5T+1}{8T}.
$$

**Argumento.** Para cualquier $h\in\mathbb K[X]$ de grado menor que $2T$, considerar $P=N_\alpha-Dh$. Es no nulo porque su residuo módulo $D$ es $R_\alpha$. Los grados de $N_0,N_1$ son a lo sumo $2T-2$ y el de $N_2$ es a lo sumo $2T$. En consecuencia, $\deg P\le3T-1$.

Como $D(x)\ne0$ en $L$, cada acuerdo $c_f(x)=h(x)$ es una raíz de $P$. Hay a lo sumo $3T-1$ acuerdos y al menos $8T-(3T-1)=5T+1$ discrepancias. La cota vale para todos los candidatos $h$, aunque su elección ocurra después de observar $\alpha$.

## 3.6 Lema S1.5 — Transferencia a un oráculo próximo

Supóngase que $u$ y el mismo $f$ inválido están fijados antes de $\alpha$, y que difieren en $e$ posiciones de $L$, con $\varepsilon=e/N$. La composición local usa $u(x),u(gx),u(g^2x)$. Si $E$ es el conjunto de discrepancias, los cambios de composición se limitan a $E\cup g^{-1}E\cup g^{-2}E$, de tamaño a lo sumo $3e$.

Por desigualdad triangular, fuera de la cancelación:

$$
\operatorname{dist}\bigl(c_u,\mathrm{RS}_{<2T}(L;\mathbb K)\bigr)
\ge\max\left\{0,\frac{5T+1}{8T}-3\varepsilon\right\}.
$$

Si $\varepsilon\le1/24$, la cota es estrictamente mayor que $1/2$ para todo $T$ finito del perfil. Es una implicación condicional: no establece que el verificador heredado fuerce esa proximidad. La siguiente sección muestra que esa premisa propuesta es falsa para el legado.

# 4. Contraejemplo a la premisa de proximidad del legado

## 4.1 Construcción

Sea $f$ el interpolante de grado menor que $T$ de una ejecución válida. Para $\lambda\in\mathbb F$, $\lambda\ne0$, definir:

$$
F(X)=f(X)+\lambda(X^T-1).
$$

El polinomio $F$ tiene grado exactamente $T$ y coincide con $f$ en $H$. Conserva ambas fronteras y cada transición de la recurrencia. El oráculo comprometido es $u=F|_L$. Como $D$ no se anula en $L$, $u$ difiere del LDE honesto $f|_L$ en todas las posiciones.

## 4.2 La composición permanece dentro de su código

Los cocientes de frontera tienen grado $T-1$. En la transición de $F$, el coeficiente principal es $-2\lambda^2$, porque $g^T=1$, y no es cero. Su grado es $2T$; dividir por el anulador de $T-2$ posiciones produce grado $T+2$.

Por tanto, toda combinación tiene grado a lo sumo $T+2<2T$ para $T\ge4$. Si el coeficiente de transición es no nulo, el grado es exactamente $T+2$. No se requiere una cancelación excepcional. La composición pertenece al código que consulta el FRI heredado y las comprobaciones AIR locales usan el mismo $F$ comprometido.

## 4.3 Proposición P.1 — Distancia exacta al código de traza

Para cualquier $h\in\mathbb K[X]$, $\deg h<T$, el polinomio $F-h$ tiene grado $T$ y coeficiente principal $\lambda$. Tiene a lo sumo $T$ raíces en $L$, por lo que:

$$
\operatorname{dist}\bigl(F|_L,\mathrm{RS}_{<T}(L;\mathbb K)\bigr)
\ge\frac{N-T}{N}=\frac78.
$$

La cota se alcanza. Elegir $T$ puntos distintos $x_1,\ldots,x_T\in L$ y definir:

$$
h(X)=F(X)-\lambda\prod_{i=1}^{T}(X-x_i).
$$

Los términos de grado $T$ se cancelan; así, $\deg h<T$. Hay exactamente $T$ acuerdos entre $F$ y $h$ en $L$. La distancia mínima es, por tanto, **igual a $7/8$**, aun permitiendo candidatos sobre $\mathbb K$.

## 4.4 Resultado del ejecutable e interpretación

**Tabla 4.1 — Casos completos conservados del contraejemplo.**

| $T$ | $N$ | Grado de $F$ | Cota de grado de composición | Verificador heredado |
|---:|---:|---:|---:|---|
| 16 | 128 | 16 | 18 | Acepta |
| 32 | 256 | 32 | 34 | Acepta |
| 64 | 512 | 64 | 66 | Acepta |

Los tres casos se reprodujeron con SHA3, Merkle, FRI y grinding reales, en desarrollo y release, usando inicio $3$, segunda fila $5$ y $\lambda=1$. Se preservan seis certificados públicos. Los retos no se eligieron ni se forzaron.

La familia refuta «aceptación implica proximidad de la traza menor o igual que $1/24$». Los enunciados son válidos: no se demuestra una falsificación de enunciado ni se descarta todo argumento alternativo de extracción.

Un control exhaustivo experimental recibe el LDE completo, reconstruye su raíz, interpola y exige grado menor que $T$, fronteras y transiciones. Acepta la ejecución honesta y rechaza esos tres casos por grado. Requiere $N$ elementos adicionales, $O(N\log N)$ operaciones y $O(N)$ memoria en el rango ensayado de 4–256 filas. Revela la traza y sirve como referencia experimental.

# 5. Variante TG2 y vínculo entre los oráculos

## 5.1 Dos recorridos FRI sobre compromisos vinculados

La variante TG2 incorpora un FRI de traza con grado objetivo menor que $T$ y otro de composición con grado objetivo menor que $2T$. La traza se codifica en hojas de extensión $(u,0)$, compartiendo codificación y raíz entre las aperturas AIR y la primera capa FRI:

$$
R_{\mathrm{traza},\mathrm{AIR}}=R_{\mathrm{traza},\mathrm{FRI},0}.
$$

El verificador exige esa igualdad, comprueba las aperturas y hace coincidir los valores principales con la capa cero de FRI de traza. Recalcula la composición en los dos puntos de cada pareja y la compara con la capa cero del FRI de composición. Después verifica ambos plegados y sus valores finales.

## 5.2 Orden de compromisos y retos

1. Dominio de versión, perfil y enunciado.
2. Raíz de traza y tres coeficientes de composición.
3. Fase de traza: raíces, retos de plegado y constante final.
4. Fase de composición: raíces, retos de plegado y constante final.
5. Validación y absorción del nonce; derivación de 40 parejas distintas comunes a las fases.

El perfil admite potencias de dos entre 16 y 4096 filas. Comprueba versión, dimensiones, cantidad de capas, longitudes de caminos y valores canónicos. Usa 12 bits de trabajo en desarrollo y 20 en release. Los índices se derivan dentro del dominio.

## 5.3 Evidencia y costo

La variante acepta los cuatro tamaños honestos ensayados, $T\in\{16,64,256,4096\}$. Para los tres oráculos alejados de la sección 4 se generan certificados nuevos bajo la variante y se obtiene rechazo en FRI de traza. No se trata de rechazar el formato incompatible de un certificado heredado.

**Tabla 5.1 — Tamaños del enunciado y certificado de la variante.**

| Filas $T$ | Capas traza / composición | Tupla serializada, bytes |
|---:|:---:|---:|
| 16 | 4 / 5 | 196574 |
| 64 | 6 / 7 | 306782 |
| 256 | 8 / 9 | 437470 |
| 4096 | 12 / 13 | 760286 |

La tupla no transmite el LDE completo, pero repite caminos Merkle por apertura. En este formato, comunicación y verificación crecen como $O(q\log^2N)$. Los tamaños conservados no acreditan ahorro de bytes ni de latencia frente al control exhaustivo. El rechazo de los casos conocidos tampoco constituye una cota universal de rechazo de oráculos alejados.

# 6. S2 — Cota de composición interactiva ideal

## 6.1 Modelo ideal y correspondencia propuesta

El enunciado y el oráculo $u:L\to\mathbb K$ quedan fijados antes de tres coeficientes $\alpha$ uniformes independientes en $\mathbb K$. Cada capa es un oráculo inmutable y cada reto $\beta$ es uniforme y posterior a su capa. El oráculo de composición $v$ puede depender de $\alpha$ y de la fase de traza, pero queda fijado antes de sus retos de composición. Las $q$ parejas finales son uniformes, distintas e independientes de la historia anterior.

Se permiten valores adversarios fuera del campo base. Las aperturas AIR deben abrir valores de $\mathbb F$ contra el mismo oráculo de traza; una posición no base detectada obliga al rechazo.

La adaptación propuesta usa BGK+23, Corolario 5.5 y Algoritmo 1, en la edición conservada del 15 de febrero de 2024, pp. 34 y 40. En el radio de decodificación única, se toma la cota por ronda:

$$
\max\left\{\frac{N}{|\mathbb K|},(1-\delta)^q\right\}.
$$

La suma sobre rondas se explicita abajo; esta cota por ronda no se identifica directamente con un error total. La revisión independiente debe validar las condiciones de esta adaptación al protocolo conjunto.

### Cambio del coset y consultas

En la capa $j$, sustituir $x=a_jy$, con $a_j=7^{2^j}$, transforma el coset en un subgrupo y el reto local en $\beta/a_j$. La multiplicación por una constante no nula conserva uniformidad y grado. El interpolante lineal en $x,-x$ corresponde al plegado par/impar implementado; la fase termina en una constante enviada antes de consultar.

Para una transcripción fija con $A$ parejas aceptables entre $M$, el muestreo sin reemplazo satisface:

$$
\frac{\binom{A}{q}}{\binom{M}{q}}\le\left(\frac{A}{M}\right)^q.
$$

Empezar en $x$ o en $-x$ verifica la misma pareja y el mismo recorrido posterior. Las tasas son $1/8$ y $1/4$; se exigen $\delta_t\le7/16$ y $\delta_c\le3/8$. Las consultas compartidas permiten una unión de eventos, sin suponer independencia entre los errores de ambos FRI.

## 6.2 Lema S2.1 — Candidato próximo único y fijado

La distancia mínima de $\mathrm{RS}_{<T}(L;\mathbb K)$ es $(N-T+1)/N$. Si:

$$
2\delta_t<\frac{N-T+1}{N},
$$

puede haber a lo sumo un polinomio $f$ de grado menor que $T$ a distancia como máximo $\delta_t$ de $u$. De haber dos, la desigualdad triangular haría su distancia menor que la mínima del código. Cuando existe, ese candidato está determinado por $u$ antes de $\alpha$.

Su existencia se trata por casos: la aceptación FRI no demuestra sin error que el candidato exista.

## 6.3 Lema S2.2 — Candidatos fuera del campo base

Escribir $f=A+zB$ con $A,B\in\mathbb F[X]$. Si $B\ne0$, tiene a lo sumo $T-1$ raíces en $L$; por tanto, $f$ toma valores base en a lo sumo $T-1$ posiciones.

Si $\operatorname{dist}(u,f)\le\delta_t$, quedan al menos $N-(T-1)-\delta_tN$ posiciones de $u$ fuera del campo base. Definir:

$$
d_{\mathrm{base}}=1-\frac{T-1}{N}-\delta_t.
$$

Consultar cualquiera de esas posiciones principales mediante AIR exige rechazo. Para un oráculo globalmente base, el mismo argumento excluye un candidato próximo con $B\ne0$ cuando esta cantidad es positiva.

## 6.4 Lema S2.3 — Discrepancia local y muestreo

Si el candidato pertenece a $\mathbb F[X]$ y el enunciado es falso sobre $\mathbb F$, el candidato es inválido. Fuera de la cancelación de probabilidad a lo sumo $p^{-2}$, S1 y la localidad de tres posiciones dan:

$$
\operatorname{dist}\bigl(c_u,\mathrm{RS}_{<2T}(L;\mathbb K)\bigr)
\ge\frac{5T+1}{8T}-3\delta_t.
$$

Si además $v$ está a distancia como máximo $\delta_c$ del código de composición, la desigualdad triangular implica:

$$
\operatorname{dist}(v,c_u)\ge d,
\qquad d=\frac{5T+1}{8T}-3\delta_t-\delta_c>0.
$$

Cada pareja contiene a lo sumo dos discrepancias. Hay al menos $b=\lceil dM\rceil$ parejas malas. Para oráculos fijados antes del muestreo, la probabilidad de omitirlas está acotada por:

$$
H(M,q,d)=\frac{\binom{M-b}{q}}{\binom{M}{q}},\qquad b=\lceil dM\rceil.
$$

Se define $H=0$ cuando $M-b<q$. Además:

$$
H(M,q,d)\le(1-b/M)^q\le(1-d)^q.
$$

El cálculo cuenta consultas sin reemplazo; no necesita independencia entre ellas. Sí necesita que la transcripción esté fijada antes de las consultas uniformes ideales.

Finalmente, $d_{\mathrm{base}}-d=1/4+2\delta_t+\delta_c>0$. La misma función $H(M,q,d)$ cubre conservadoramente la omisión de posiciones no base del caso anterior.

## 6.5 Proposición S2.4 — Composición de errores ideales

Sean $k_t=\log_2T$ y $k_c=\log_2(2T)$. Para $i\in\{t,c\}$ definir:

$$
E_i=\min\left\{1,(k_i+1)\max\left\{\frac{N}{p^2},(1-\delta_i)^q\right\}\right\}.
$$

El factor $k_i+1$ suma conservadoramente los plegados y la ronda final de consultas. Bajo el modelo y las condiciones anteriores, la derivación obtiene:

$$
\Pr[\text{aceptar un enunciado falso}]\le E_{\mathrm{ideal}},
$$

$$
E_{\mathrm{ideal}}=\min\left\{1,p^{-2}+E_t+E_c+H(M,q,d)\right\}.
$$

**Argumento por casos.** Si $u$ está lejos del código de traza, aceptar implica un error de FRI cubierto por $E_t$. Si está cerca, existe el candidato único ya fijado. Cuando no es base, aceptar exige omitir las posiciones no base y se aplica $H$.

Cuando el candidato es base, es inválido por la falsedad del enunciado. Separar primero la cancelación, de probabilidad a lo sumo $p^{-2}$. Fuera de ella, si $v$ está lejos del código de composición, aceptar implica el error cubierto por $E_c$. Si está cerca, aceptar exige omitir discrepancias entre $v$ y $c_u$, cubiertas por $H$.

Los casos de candidato base y no base son excluyentes para el $u$ fijo, de modo que basta una contribución $H$. La unión no requiere independencia entre los dos FRI. Las garantías de cada fase se aplican condicionadas a su historia anterior, conservando retos frescos.

La proposición usa S1 y la adaptación de BGK+23 descrita en esta sección, ambas pendientes de dictamen. No demuestra extracción eficiente, conocimiento cero ni una garantía del ejecutable con SHA3.

## 6.6 Instancia numérica conservadora

Tomar $\delta_t=\delta_c=1/8$ y $q=40$. Entonces $d=1/8+1/(8T)$ y las condiciones de radios y unicidad se satisfacen en los nueve tamaños de la variante.

**Tabla 6.1 — Cotas superiores ideales, redondeadas hacia arriba.**

| Filas $T$ | Rondas traza / composición | Consultas | Cota superior ideal |
|---:|:---:|---:|---:|
| 16 | 5 / 6 | 40 | 0,052736 |
| 64 | 7 / 8 | 40 | 0,074258 |
| 256 | 9 / 10 | 40 | 0,095099 |
| 4096 | 13 / 14 | 40 | 0,134071 |

Las rondas incluyen las consultas finales; la Tabla 5.1 cuenta solo plegados. Los valores provienen de fracciones exactas y se redondean a seis decimales hacia arriba. Son cotas superiores conservadoras del modelo ideal. No son tasas de ataque observadas, cotas inferiores de vulnerabilidad ni garantías de 100 bits. Tampoco muestran que exista un ataque que alcance esas probabilidades.

# 7. S3 — Merkle, distribución de retos y Fiat–Shamir

## 7.1 Lema S3.1 — Vinculación de una posición Merkle

La variante usa SHA3-256. Una hoja recibe el prefijo `0x00` y dos componentes canónicas de ocho bytes little-endian. Un nodo recibe `0x01` y dos hashes ordenados de 32 bytes. AIR sumerge cada valor base como $(u,0)$, la misma codificación de la primera capa FRI de traza.

**Enunciado.** Fijados raíz, tamaño potencia de dos e índice dentro del dominio, dos aperturas aceptadas de valores canónicos distintos permiten obtener una colisión de la función hash.

**Argumento.** Si coinciden los hashes de hoja, las dos codificaciones distintas ya constituyen una colisión. Si difieren, ascender hasta el primer padre coincidente. Al menos uno de sus hijos difiere, por lo que las entradas ordenadas al hash son distintas y comparten salida. El prefijo distingue hojas de nodos. Se recorren a lo sumo tantos niveles como profundidad tiene el árbol.

La reducción es condicional a la forma validada y la resistencia a colisiones. No extrae automáticamente un vector completo de una raíz arbitraria ni asigna una probabilidad de colisión al SHA3 real.

La función Merkle genérica consume solo los bits del índice correspondientes al camino: por sí sola no rechaza todos los índices fuera del tamaño. La variante exige profundidad exacta y deriva índices dentro del dominio; el lema se aplica a esa interfaz validada.

## 7.2 Gramática del canal auditado

La absorción usa estado, etiqueta, longitud `u64` y datos. Los retos usan el estado seguido de `E` o `I`. El perfil identifica versión, trabajo, $N$, cotas $T$ y $2T$, y consultas. El orden sigue la sección 5.2.

**Tabla 7.1 — Longitudes de entradas al hash en la variante.**

| Familia | Longitud, bytes |
|---|---:|
| Dominio inicial | 23 |
| Hoja de extensión / nodo Merkle | 17 / 65 |
| Absorción de perfil / enunciado / raíz | 79 / 65 / 73 |
| Absorción de fase traza / composición / final | 46 / 52 / 57 |
| Extracción de reto / trabajo de nonce / absorción del nonce | 33 / 41 / 49 |

El mismo SHA3 sirve a Merkle y al canal. Nodo y absorción del enunciado tienen longitud 65. En los 18 perfiles inspeccionados, el estado fijo anterior al enunciado no empieza por `0x01`; esas entradas se distinguen en el perfil examinado. La comprobación finita no prueba una separación universal para otras versiones o aplicaciones.

Etiquetas y longitudes distinguen codificaciones, pero no hacen inyectivo el hash. Restaurar el mismo prefijo de transcripción repite sus retos. Modelar este canal como monedas nuevas e independientes requiere una justificación adicional.

## 7.3 Proposición S3.2 — Sesgo exacto de reducción al campo

Sea $S=2^{128}=ap+r$, con $0\le r<p$. Si $U$ es uniforme en $\{0,\ldots,S-1\}$, la reducción $U\bmod p$ asigna masa $(a+1)/S$ a $r$ residuos y $a/S$ a los restantes.

Su distancia de variación total a la uniforme sobre $\mathbb F$ es:

$$
\begin{aligned}
\Delta_F
&=\frac12\left[r\left(\frac{a+1}{S}-\frac1p\right)
+(p-r)\left(\frac1p-\frac aS\right)\right]\\
&=\frac{r(p-r)}{pS}.
\end{aligned}
$$

Para Goldilocks, los valores exactos son $a=18446744078004518911$ y $r=18446744065119617025=p-2^{32}$. Se obtiene:

$$
\Delta_F\approx1{,}26217744806\times10^{-29},\qquad
\Delta_K\le2\Delta_F.
$$

La cota de extensión usa dos bloques independientes de 128 bits. La masa máxima de un elemento es $((a+1)/S)^2$, coherente con la generalización de S1.3.

## 7.4 Pérdida híbrida bajo frescura

Una ejecución de la variante usa:

$$
m=3+\log_2T+\log_2(2T)
$$

retos de extensión, entre 12 y 28. Reemplazar uno a uno los retos uniformes por los bloques reducidos cambia cualquier probabilidad de aceptación en a lo sumo $m\Delta_K\le2m\Delta_F$, si cada bloque es uniforme fresco e independiente de la historia condicionante. Para $m=28$:

$$
2m\Delta_F<7{,}069\times10^{-28}.
$$

La cuenta admite decisiones adaptativas entre pasos cuando se mantiene esa frescura. No incluye la búsqueda entre múltiples transcripciones, prefijos repetidos, compromisos adaptativos ni consultas cuánticas al hash. **No es la pérdida total de Fiat–Shamir.**

Bajo la misma idealización de salidas frescas, enmascarar índices en un dominio potencia de dos no introduce sesgo, y rechazar duplicados produce muestreo sin reemplazo.

## 7.5 Grinding y compilación pendientes

El probador ordinario busca el primer nonce válido, mientras el verificador admite cualquier nonce que satisfaga el trabajo. En un contexto público de ensayo con 12 bits se obtuvieron los nonces $904$ y $1233$, ambos válidos y con listas distintas de 40 consultas. Este resultado muestra multiplicidad de transcripciones; no falsifica el AIR ni justifica sumar automáticamente bits de trabajo a la solidez.

BGK+23, Teorema 3.15, p. 25 de la edición conservada, estudia una transformación BCS bajo propiedades por ronda. Su expresión clásica contiene:

$$
Q\varepsilon_{\mathrm{rbr}}+\frac{3(Q^2+1)}{2^\kappa}.
$$

Aquí $Q$, $\varepsilon_{\mathrm{rbr}}$ y $\kappa$ tienen las funciones y condiciones del teorema citado; no se han instanciado para el canal local. La expresión identifica obligaciones pendientes. La cota ordinaria $E_{\mathrm{ideal}}$ de un experimento completo no sustituye automáticamente a $\varepsilon_{\mathrm{rbr}}$.

El resultado cuántico añade dependencias en consultas y complejidad que requieren instanciación. Un teorema para FRI aislado tampoco cubre por sí solo AIR, los dos recorridos correlacionados, Merkle y grinding. La extracción y el conocimiento cero requieren sus propias propiedades.

# 8. Evidencia, reproducción y relación con ML-DSA

## 8.1 Qué se comprobó

**Tabla 8.1 — Evidencia conservada que acompaña los argumentos.**

| Bloque | Comprobación disponible |
|---|---|
| S1 | Siete pruebas algebraicas; 21 trazas válidas, residuos, cancelación, identidad y localidad |
| Proximidad | 21 casos algebraicos; tres aceptaciones completas del legado, en desarrollo y release |
| Variante vinculada | Diez pruebas en desarrollo y release; casos honestos y rechazo de los tres oráculos reutilizados |
| S2 | Nueve perfiles; contrastes finitos de unicidad, campo base, localidad, muestreo y normalización FRI |
| S3 | 14 certificados, 560 consultas y 18.880 aperturas Merkle reconstruidos; 35 distribuciones pequeñas |
| Workspace | 197 pruebas en desarrollo; check y build correctos en la edición del 23 de septiembre |

El auditor Python de S3 verifica formato, canonicidad, transcripción SHA3, nonce, índices, aperturas y enlace de traza. No vuelve a ejecutar plegados FRI ni la composición AIR. Por eso los seis certificados de trazas lejanas también pasan esta auditoría estructural, aunque el verificador completo los rechaza. No son 14 pruebas Rust adicionales ni 14 aceptaciones del protocolo completo.

Los conteos de 180 y 187 pruebas que aparecen en informes anteriores corresponden a sus etapas históricas. Las comprobaciones finitas contrastan casos y cuentas; la revisión matemática debe evaluar los enunciados generales y sus hipótesis.

## 8.2 Versiones y reproducción

Código consolidado: `01dcde960402b6c60a19242b7ae3d6ac3d82a518`. La recopilación utiliza los informes y la evidencia ya conservados; no introduce nuevas mediciones de rendimiento ni modifica la implementación.

Los scripts de referencia son `analizar_algebra_air_r4.py`, `analizar_proximidad_traza_r4.py`, `analizar_fri_vinculado_r4.py`, `analizar_cota_interactiva_r4.py` y `auditar_merkle_fs_r4.py`, bajo `scripts/`. Sus instantáneas, entradas, resultados y hashes se conservan en las etapas correspondientes de `Documentos/06-Evidencia-TG2/`.

Esos scripts históricos escriben en carpetas fechadas fijas. Para repetirlos, usar una copia separada de los repositorios y seguir los comandos del informe pertinente. El manifiesto de entrega y `scripts/verificar_version_tg2.py` permiten comprobar los archivos de la edición conservada sin regenerarlos.

## 8.3 La revisión R1 es una obligación distinta

La correspondencia ML-DSA se documentó en R1 [A6]. Incluye contraste de parámetros, reproducción de una pérdida de referencia y la conclusión de que la aplicación directa examinada de JMW24 no satisface sus condiciones en los tres perfiles. Esa conclusión no es un ataque ni prueba que toda reducción posible falle.

Las obligaciones R1-A–D tratan expansión y firma hedged, codificaciones y sUF-CMA, fuente/KDF de semillas y errores extremos del backend. R1-E pide dictamen del argumento. S1–S3 no cierran estas obligaciones ni deben presentarse como una demostración nueva de seguridad de ML-DSA.

# 9. Preguntas y registro para el revisor

**Tabla 9.1 — Cuestiones que requieren dictamen independiente.**

| ID | Punto que debe revisarse | Localizador en este documento |
|---|---|---|
| M1 | Divisibilidad, grados, cancelación y distancia; traza fija antes de los retos | Sección 3 |
| M2 | Unicidad y fijación del candidato; tratamiento del campo base | Secciones 6.2–6.3 |
| M3 | Aplicabilidad de Corolario 5.5, coset, plegado y muestreo por parejas | Sección 6.1 |
| M4 | Unión de errores, condicionamiento por historia y una sola contribución de omisión local | Secciones 6.4–6.6 |
| M5 | Vinculación frente a extracción, cota ordinaria frente a propiedad por ronda y compilación SHA3/grinding | Sección 7 |
| M6 | Suficiencia de resultados y límites para el alcance aprobado de TG2 | Secciones 1 y 8; balance de objetivos |

**Registro de revisión.** Para cada M1–M6 deben consignarse revisor, fecha, observación, corrección requerida y estado final. Todos se mantienen pendientes al preparar este documento.

Revisor: ______________________________________________

Fecha y versión revisada: _______________________________

Observaciones principales: ______________________________

Correcciones y seguimiento: _____________________________

Dictamen sobre el alcance de TG2: ________________________

La conclusión vigente es una cadena de resultados condicionados, experimentos y obligaciones identificadas. Una garantía concreta del ejecutable exige completar la compilación y las propiedades por ronda. El cierre académico depende del alcance acordado y del dictamen; esta recopilación no agrega automáticamente la obligación de demostrar un nuevo teorema de 100 bits.

# 10. Fuentes y documentos de respaldo

## 10.1 Publicaciones primarias usadas en la derivación

**[BGK+23]** Block, A.; Garreta, A.; Katz, J.; Thaler, J.; Tiwari, P.; Zając, M. *Fiat-Shamir Security of FRI and Related SNARKs*. ASIACRYPT 2023; ePrint 2023/1071. Edición local conservada: 15 de febrero de 2024. Localizadores utilizados: Teorema 3.15, p. 25; Corolario 5.5, p. 34; Algoritmo 1, p. 40. [Ficha primaria](https://eprint.iacr.org/2023/1071). [PDF conservado](../../06-Evidencia-TG2/2026-09-22/R4-solidez/bibliografia/BGK23.pdf).

**[FRI18]** Ben-Sasson, E.; Bentov, I.; Horesh, Y.; Riabzev, M. *Fast Reed-Solomon Interactive Oracle Proofs of Proximity*. ICALP 2018, LIPIcs 107, 14:1–14:17. Referencia del objetivo de proximidad de FRI. [Publicación](https://doi.org/10.4230/LIPIcs.ICALP.2018.14).

## 10.2 Informes locales consolidados

- **[A1]** [Reducción algebraica condicional del AIR a proximidad FRI](R4-Algebra-AIR-FRI-2026-09-22.md), 22 de septiembre de 2026.
- **[A2]** [Contraejemplo a la premisa de proximidad de la traza](R4-Proximidad-Traza-2026-09-22.md), 22 de septiembre de 2026.
- **[A3]** [Variante experimental con FRI de traza vinculada al AIR](R4-FRI-Vinculado-2026-09-22.md), 22 de septiembre de 2026.
- **[A4]** [Cota de composición en el modelo interactivo ideal](R4-Cota-Interactiva-2026-09-22.md), 22 de septiembre de 2026.
- **[A5]** [Auditoría de Merkle y Fiat–Shamir](R4-Merkle-Fiat-Shamir-2026-09-23.md), 23 de septiembre de 2026.
- **[A6]** [Correspondencia formal del perfil ML-DSA](R1-Correspondencia-Formal-2026-09-22.md), 22 de septiembre de 2026.

## 10.3 Acceso a la evidencia exacta

- [S1: análisis y fuentes](../../06-Evidencia-TG2/2026-09-22/R4-algebra/analisis.json).
- [Proximidad: ejecución y corpus](../../06-Evidencia-TG2/2026-09-22/R4-proximidad/validacion.json).
- [Variante vinculada: ejecución y corpus](../../06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado/validacion.json).
- [S2: fracciones exactas y contrastes](../../06-Evidencia-TG2/2026-09-22/R4-cota-interactiva/analisis.json).
- [S3: transcripciones, aperturas y distribución](../../06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/analisis.json).
- [Verificación del código consolidado](../../06-Evidencia-TG2/2026-09-23/Organizacion-repositorios/validacion.json).
- [Paquete de preguntas M1–M6](Revision-Matematica-S1-S3-2026-09-23.md).
- [Balance de los Objetivos 3 y 4](../Entrega-Final/Balance-Objetivos-TG2.md).
