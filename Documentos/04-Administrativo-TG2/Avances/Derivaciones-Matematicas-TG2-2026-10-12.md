---
title: "NEXUS — Derivaciones matemáticas de TG2"
subtitle: "AIR, solidez por rondas, transferencia ROM y revisión de nonces adaptativos"
author: "Juan Diego Susunaga Velasquez"
date: "12 de octubre de 2026 · Documento para revisión matemática"
lang: es
---

# 1. Propósito y estado de los resultados

Esta edición consolida las derivaciones de TG2 desarrolladas el 22 y 23 de septiembre, con revisión de su presentación el 12 de octubre de 2026. Conserva los argumentos de partida e integra después la solidez por rondas, la transferencia ROM y la revisión interna mediante potencial. Incluye hipótesis, argumentos, cuentas numéricas y relación con los experimentos. El ámbito de NEXUS es **sistemas en general**; el objeto algebraico de estas derivaciones es una recurrencia AIR demostrativa.

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


# Complementos integrados en la edición de TG2

Las secciones anteriores conservan los argumentos de partida. Los complementos siguientes proponen la derivación por rondas y su transferencia clásica ROM, pendientes de dictamen independiente. La edición no reanuda QROM ni acredita 100 bits o conocimiento cero.

# Solidez por rondas del IOP ideal

## Solidez por rondas del IOP conjunto AIR/FRI de NEXUS

**Estado:** demostración propuesta para revisión independiente. **Modelo:** interactivo ideal. **Fecha:** 2026-09-23.

### 1. Pregunta y alcance

La [derivación S2 anterior](R4-Cota-Interactiva-2026-09-22.md) acotaba una ejecución interactiva completa. La [auditoría S3](R4-Merkle-Fiat-Shamir-2026-09-23.md) señalaba que ese error ordinario no se puede sustituir por un error por ronda en un teorema de compilación Fiat–Shamir. Aquí se desarrolla precisamente la función de estado del protocolo conjunto y su error por ronda.

La estructura del argumento FRI sigue la función de estado de Garreta, Mohnblatt y Wagner, **Teorema 5.2 de la revisión publicada el 31 de marzo de 2026, con portada fechada el 27 de marzo**, basada en la conservación de conjuntos de acuerdo. Se demuestra abajo un lema elemental suficiente para nuestros umbrales; no se instancia la expresión general de acuerdo correlacionado del artículo. La revisión consultada está identificada y conservada. No se afirma originalidad global de este lema ni se presenta una formalización en Lean.

El teorema resultante trata la recurrencia AIR demostrativa. No prueba validez de ML-DSA, aritmetización de una aplicación completa, conocimiento cero, extracción eficiente de testigos ni seguridad cuántica del ejecutable.

### 2. Hipótesis y notación

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

### 3. Lema elemental de acuerdo para dos funciones

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

### 4. Estado de un FRI y cota de consultas

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

### 5. Estado del protocolo conjunto

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

### 6. Proposición conjunta y cota ordinaria

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

### 7. Qué aporta a los reinicios y qué falta para Fiat–Shamir

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

### 8. Comprobaciones y fuentes

El [script](../../../scripts/analizar_rbr_conjunto_tg2.py) calcula nueve perfiles con fracciones exactas y rechaza parámetros fuera de las hipótesis. Las [siete pruebas](../../../scripts/tests/test_rbr_conjunto_tg2.py) comprueban las sumas geométricas, redondeos superiores, consulta exhaustiva, 328 escenarios de muestreo, **390.625 pares completos de funciones sobre cuatro puntos en F5**, 6.056 prefijos de cancelación vectorial en F3² y 4.352 combinaciones de palabra binaria/reto de un FRI pequeño en F17, enumerando también sus constantes finales.

Son contrastes de instancias finitas y de la aritmética, no una prueba automática de las proposiciones generales ni una auditoría externa. Las condiciones generales están escritas en las demostraciones anteriores. El código Rust se conserva y sus comprobaciones se registran en [validacion.json](Cierre-Matematico-2026-09-23/validacion.json).

Fuentes primarias:

1. Garreta, Mohnblatt y Wagner, [A Simplified Round-by-round Soundness Proof of FRI](https://eprint.iacr.org/2025/1993), revisión 2026-03-31: Definiciones 2.2 y 3.4–3.5, Lema 5.1 y Teorema 5.2, pp. 4, 6 y 14–19 de la copia conservada. [PDF local](Cierre-Matematico-2026-09-23/bibliografia/GMW25.pdf).
2. Block y colaboradores, [Fiat-Shamir Security of FRI and Related SNARKs](https://eprint.iacr.org/2023/1071), edición local de 2024-02-15: Definición 3.12 y Teorema 3.15, pp. 24–25. Sirve para situar la obligación de compilación, sin instanciarla para SHA3.
3. [S1: divisibilidad, residuos y transferencia local](R4-Algebra-AIR-FRI-2026-09-22.md); [S2: cota ideal anterior](R4-Cota-Interactiva-2026-09-22.md); [S3: auditoría de Merkle/Fiat–Shamir](R4-Merkle-Fiat-Shamir-2026-09-23.md).

La construcción de estado y la composición propuestas aquí requieren lectura crítica independiente. No se atribuye esa revisión al director ni a los autores citados.


# Transferencia clásica ROM al protocolo TG2 v1

## Transferencia de la solidez ideal al protocolo TG2 v1 en ROM clásico

**Fecha:** 2026-09-23. **Estado:** derivación propuesta para revisión matemática independiente.

### 1. Objeto exacto y resultado

Se analiza `verify` de `nexus-zk/experiments/tg2_linked_trace_fri.rs`, versión 1, en la revisión de código `01dcde960402b6c60a19242b7ae3d6ac3d82a518`. La variante comparte raíz y codificación entre AIR y FRI de traza y usa otro FRI para composición. El STARK heredado no es objeto de esta garantía.

Se conserva exactamente la secuencia de bytes de la variante. Para el análisis, cada llamada a SHA3-256 se sustituye por una consulta a **un solo oráculo aleatorio** $H:\{0,1\}^*\to\{0,1\}^{256}$. Un adversario clásico dispone de a lo sumo $Q$ consultas, incluidas las de preparación, búsqueda de compromisos y nonces. Emite un enunciado y una prueba finales. El perfil $T,g$ está fijado; el enunciado puede elegirse adaptativamente dentro de ese perfil. No se permite información auxiliar correlacionada con el oráculo que no esté contabilizada.

La probabilidad acotada es la de que esa prueba final acepte un enunciado sin traza válida sobre el campo base. No se afirma extracción eficiente de un testigo, conocimiento cero, seguridad QROM ni una propiedad de la función determinista SHA3 al margen del modelo.

La [derivación por rondas](Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md) proporciona el argumento algebraico que se usa abajo. Esta etapa incorpora el registro de consultas hash y calcula pérdidas propias del canal concreto; **no sustituye sin más la cota ideal en el teorema BCS**.

### 2. Parámetros y fórmula

Sea $p=2^{64}-2^{32}+1$, $K=F_{p^2}$, $N=8T$, $M=N/2$, $q=40$, $k_t=\log_2T$, $k_c=k_t+1$ y $m=3+k_t+k_c$. El trabajo de nonce es $g=12$ en debug y $g=20$ en release. Los umbrales del argumento ideal son $\delta_t=\delta_c=1/8$.

Definimos la masa máxima de un reto de extensión obtenido de dos bloques uniformes de 128 bits:

$$
\mu=\left(\frac{\lfloor2^{128}/p\rfloor+1}{2^{128}}\right)^2.
$$

Sea

$$
h_T=\frac{\binom{M-\lceil M/8\rceil}{q}}{\binom Mq},\qquad
\tau_T=\min\left\{1,\binom{M}{q-1}\left(\frac{q-1}{M}\right)^{512}\right\}.
$$

El numerador de $h_T$ vale cero cuando no hay suficientes parejas buenas. Sea $\ell=\log_2N$ y

$$
W_T=q\left(6\ell+2\sum_{j=0}^{k_t-1}(\ell-j)
                    +2\sum_{j=0}^{k_c-1}(\ell-j)\right),
$$

$$
B_T=1+k_t+k_c+W_T,
$$

$$
V_T=W_T+q(6+2k_t+2k_c)+13+2(k_t+k_c)+512,\qquad S=Q+V_T.
$$

Aquí $B_T$ cuenta ocurrencias de digests en raíces y caminos de una prueba con forma válida, y $V_T$ es una cota de llamadas hash del verificador cuando la selección termina antes de superar 512 extracciones. Contar ocurrencias repetidas es conservador.

**Teorema ROM propuesto.** Bajo el modelo de §1 y los lemas algebraicos de la derivación por rondas, la probabilidad de aceptación falsa está acotada por

$$
\boxed{
E_{\mathrm{ROM}}(T,g,Q)
\le \min\left\{1,
\underbrace{\frac{S(49S+B_T)}{2^{256}}}_{\text{grafo de hashes}}
+\underbrace{(Q+m)\frac N2\mu}_{\text{AIR y plegados}}
+\underbrace{(Q+1)2^{-g}(h_T+\tau_T)}_{\text{nonces y consultas}}
\right\}.}
$$

Los apartados siguientes justifican cada término y su composición. La constante 49 es una cota deliberadamente amplia que permite tratar las entradas del mismo oráculo sin asumir que todos sus dominios son disjuntos.

### 3. Correspondencia de la gramática

La absorción es $H(s\parallel\mathrm{tag}\parallel\mathrm{len}_{64}\parallel\mathrm{datos})$. El estado completo de 256 bits se conserva después de cada reto. Los campos del perfil y del enunciado tienen longitudes fijas en el verificador admitido.

| Función | Entrada a $H$ | Longitud |
|---|---|---:|
| Inicio | dominio `NEXUS-TG2-LINKED-FRI-v1` | 23 |
| Hoja de extensión | `00` y dos enteros canónicos little-endian | 17 |
| Nodo Merkle | `01`, hijo izquierdo e hijo derecho | 65 |
| Perfil | estado, etiqueta 16, longitud 38, datos | 79 |
| Enunciado | estado, etiqueta 4, longitud 24, datos | 65 |
| Raíz | estado, etiqueta 1 o 2, longitud 32, raíz | 73 |
| Fase traza / composición | estado, etiqueta 17, longitud, nombre | 46 / 52 |
| Constante final | estado, etiqueta 3, longitud 16, valor | 57 |
| Reto de extensión / índice | estado y `E` / `I` | 33 |
| Trabajo del nonce | estado, etiqueta 5, nonce u64 | 41 |
| Absorción del nonce | estado, etiqueta 5, longitud 8, nonce u64 | 49 |

Las entradas de 33 bytes para retos, de 41 para trabajo y de 49 para absorber el nonce son distintas por longitud o sufijo. **Nodo y enunciado pueden compartir una cadena de 65 bytes.** El argumento no excluye ese caso mediante la observación finita de los 18 perfiles SHA3; permite que una consulta tenga ambas interpretaciones. La extracción y el seguimiento de transcripción usan sus respectivos formatos, y ambos apuntan al mismo valor del único oráculo.

Dentro del recorrido válido del canal, el estado anterior, la etiqueta, la longitud y los datos determinan un mensaje sin ambigüedad. El perfil fija número de capas y orden de fases. Repetir la raíz inicial en FRI de traza exige igualdad con la raíz AIR. Ningún mensaje del probador se intercala entre los tres $\alpha$ ni entre las extracciones de índices.

### 4. Evento excepcional del grafo de hashes

Simulamos el oráculo por muestreo perezoso: una entrada repetida conserva su respuesta y una nueva recibe 256 bits uniformes, independientes de lo observado antes de responder.

Se mantiene un conjunto de etiquetas de 32 bytes. Antes de responder a una consulta nueva de longitud a lo sumo 79, se añaden **todas sus ventanas contiguas de 32 bytes**. Hay a lo sumo 48 ventanas. Después de responder se añade su digest. Al recibirse la prueba final se añaden sus $B_T$ ocurrencias de digests; valores repetidos solo reducen el conjunto. Entradas ajenas de longitud mayor que 79 pueden consultarse, pero solo sus respuestas se añaden: no son entradas de ningún paso del protocolo analizado.

Llamamos $\mathsf{Bad}_H$ al evento de que una respuesta nueva coincida con una etiqueta que ya estaba marcada, incluidas las ventanas de su propia entrada. Esto cubre:

- colisiones entre respuestas a entradas distintas;
- referencias a respuestas que todavía no existían al escribir un padre o estado;
- ciclos, autorreferencias y un acierto contra una raíz o hermano suministrado antes de consultar su preimagen.

Con a lo sumo $S$ consultas nuevas, antes de cualquier respuesta hay como máximo $49S+B_T$ etiquetas. Condicionada a la historia previa, la siguiente respuesta es uniforme, por lo que

$$
\Pr[\mathsf{Bad}_H]\le\frac{S(49S+B_T)}{2^{256}}.
$$

Las ventanas incluyen tanto los estados anteriores como raíces e hijos, aunque los campos empiecen en offsets diferentes. Marcar también las ventanas de consultas ajenas cortas amplía el evento y conserva la cota. No se presupone resistencia a colisiones adicional: esta pérdida se calcula dentro de ROM.

Los argumentos posteriores se aplican hasta el primer evento excepcional. No se condicionan salidas nuevas a que **nunca** ocurra un evento futuro: ese condicionamiento alteraría su distribución. Se usa una ejecución acoplada que conserva respuestas frescas y se detiene si ocurre el evento.

### 5. Extracción previa de los oráculos Merkle

Para una raíz y un tamaño fijados, se recorre el registro de consultas disponible **antes del reto relevante**:

1. Se busca la preimagen consultada que produjo el digest. Fuera de $\mathsf{Bad}_H$, es única.
2. A profundidad interna, solo una entrada de 65 bytes con prefijo `01` proporciona dos hijos.
3. A profundidad de hoja, solo una entrada de 17 bytes con prefijo `00` y dos coordenadas canónicas proporciona un elemento de $K$.
4. Si falta la preimagen o no tiene esa forma, se completa esa región con ceros. La lista obtenida se congela en ese instante.

**Lema de extracción de aperturas.** Fuera de $\mathsf{Bad}_H$, toda apertura que acepte después coincide con la posición correspondiente de esa lista, siempre que la raíz ya hubiera aparecido como campo comprometido antes del reto.

**Demostración.** Una apertura aceptada reconstruye hashes desde una hoja canónica hasta la raíz. Si en algún punto usa una preimagen distinta de la registrada para el mismo digest, aparece una colisión. Si la preimagen requerida no estaba en el registro al congelar el vector y se consulta más tarde, su respuesta acierta contra una etiqueta ya marcada: la raíz estaba en la absorción y los hijos estaban en entradas internas anteriores. Es una referencia adelantada incluida en $\mathsf{Bad}_H$. Si la preimagen tenía otro tipo o profundidad, una apertura canónica tampoco puede reemplazarla sin cambiar la entrada y colisionar. Por inducción a lo largo del camino, toda apertura aceptada coincide con una hoja ya extraíble al fijar la raíz. Las regiones completadas con cero no pueden recibir aperturas diferentes sin alguno de esos eventos. $\square$

Así se obtiene un vector ideal fijo **con acceso al registro del oráculo**. No es un algoritmo que recupere la traza desde la raíz SHA3 pública por sí sola. Raíces repetidas para un mismo tamaño dan las mismas aperturas extraíbles; se comparte explícitamente el vector inicial entre AIR y FRI de traza. Cada capa se extrae antes de su $\beta$ y la traza antes del primer $\alpha$.

El enfoque guarda relación con el extractor por grafo de BCS16, §3.1. La cuenta de ventanas, codificación de elementos, profundidad y digest de hoja de esta sección es específica del protocolo local.

### 6. Reconstrucción del prefijo y errores de campo

Fuera de $\mathsf{Bad}_H$, si se consultó un reto `estado || E` antes de conocer el estado que lo precede en una transcripción válida, la respuesta futura que debía producir ese estado acertaría contra los primeros 32 bytes ya marcados: contradicción. Por ello un reto previamente consultado tiene sus antecedentes disponibles en orden temporal. La unicidad de respuestas y el formato de la absorción permiten retroceder hasta dominio, perfil y enunciado.

Este argumento admite el solapamiento nodo/enunciado: una entrada puede ser un nodo y una absorción de enunciado, pero su interpretación como paso del canal conserva un único estado anterior y datos fijos. Las consultas que producen retos tienen longitudes o sufijos distintos de las entradas de Merkle y de absorción. Fuera del evento excepcional, una secuencia de canal con otro perfil no puede converger a la misma secuencia mediante una colisión.

En cada consulta **nueva** que constituye un reto de extensión de un prefijo válido, su salida cruda es uniforme. Para $U\bmod p$, cada residuo recibe a lo sumo $(\lfloor2^{128}/p\rfloor+1)/2^{128}$; las dos mitades uniformes son independientes. Así, cada elemento de $K$ recibe masa a lo sumo $\mu$.

- El reto AIR crítico de la prueba por rondas tiene a lo sumo un valor que cancela los residuos: error $\le\mu$.
- El lema elemental de plegado tiene a lo sumo $n_j$ valores excepcionales: error $\le n_j\mu\le(N/2)\mu$.
- Repetir una entrada no genera otra oportunidad: devuelve la respuesta registrada. Un estado que ya escapó se cobra a la primera transición excepcional de su historia.

Hay como máximo $Q$ consultas nuevas del adversario y $m$ retos de extensión en la única verificación final. Por unión adaptativa,

$$
\Pr[\text{algún escape AIR/FRI antes de }\mathsf{Bad}_H]
\le(Q+m)\frac N2\mu.
$$

Usar masa máxima evita pagar una distancia de variación total por cada salida. La elección de las raíces puede depender de retos previos: el vector de cada ronda y el conjunto de sus valores excepcionales están fijados antes de la respuesta nueva de esa ronda.

### 7. Consultas en cadena y nonces adaptativos

Un **candidato de nonce** es el par $(s,n)$, donde $s$ es el estado después de ambas constantes finales y $n$ es el nonce. Ese estado fija la transcripción previa y todos los vectores extraíbles. El candidato se inicia al consultar por primera vez su trabajo de 41 bytes o su absorción de 49 bytes, lo que ocurra antes. Si se intenta referir un $s$ que solo se producirá después, se incurre en $\mathsf{Bad}_H$.

Por tanto, hay a lo sumo $Q$ candidatos iniciados durante la preparación adversaria y, como máximo, uno adicional en la verificación final. Restaurar un candidato o cambiar el orden de sus consultas no lo renueva.

Para un candidato cuyo estado ideal aún sea cero:

1. La prueba por rondas da un conjunto fijo de a lo sumo $(1-1/8)M$ parejas que podría superar el control activo. Este puede ser FRI de traza, FRI de composición, campo base o enlace AIR. No se requiere independencia entre los controles.
2. La salida del trabajo $H(s\parallel05\parallel n)$ satisface los $g$ ceros con probabilidad $2^{-g}$.
3. La absorción $H(s\parallel05\parallel8_{64}\parallel n)$ tiene otra entrada; inicia la cadena `I`. Fuera del evento de grafo, las extracciones nuevas de esa cadena son frescas. Las potencias de dos admitidas permiten obtener índices uniformes por máscara, y descartar repetidos produce una lista uniforme sin reemplazo.

**Lema de un candidato.** La probabilidad de que cumpla el trabajo y sus 40 índices omitan todas las parejas malas, antes de cualquier evento excepcional, es a lo sumo $2^{-g}h_T$.

**Justificación del orden adaptativo.** En la primera consulta que inicia el candidato, la transcripción anterior y el conjunto de parejas están fijados. Todavía no se conocen ambos experimentos de ese candidato. Si se prueba primero el trabajo, el muestreo restante es independiente; si se observa primero parte o toda la cadena, el trabajo restante es independiente. Una interrupción por resultado desfavorable solo reduce la probabilidad de completar con éxito ese candidato. Consultas intercaladas a otros candidatos no cambian las respuestas de este. Una entrada futura de la cadena que ya hubiese sido anticipada necesitaría acertar contra un estado aún no producido, o fusionarse con otra cadena; esos casos se cobran en $\mathsf{Bad}_H$.

Formalmente se puede asignar a cada candidato, desde su inicio, una secuencia independiente de salidas para sus pasos aún no revelados, y revelar solo las solicitadas. La ejecución coincide con el oráculo real hasta el primer choque de entradas o referencia adelantada, que ya está cubierto por el evento de grafo. Las consultas hipotéticas no se ejecutan ni se añaden al presupuesto: sirven para acoplar el evento de completar una cadena, incluso cuando el adversario abandona el candidato. Las muestras exitosas forman un subconjunto del evento de éxito de esa secuencia completa.

Por unión sobre los candidatos iniciados, el término es $(Q+1)2^{-g}h_T$. **El factor de grinding solo multiplica el error de consultas finales.** No multiplica la pérdida de campo ni la del grafo. La cuenta permite probar nonces en cualquier orden y elegir cualquiera válido; no supone que se use el primero.

### 8. Cola de la selección y ejecución original sin límite

El Rust v1 sigue extrayendo índices hasta reunir 40 distintos; no tiene un límite determinista de 512. Para contar las consultas del verificador, introducimos únicamente en la demostración un verificador truncado que rechaza si todavía no termina después de 512 extracciones.

Si tras $R$ índices uniformes hay menos de $q$ distintos, todos pertenecen a algún subconjunto de $q-1$ elementos. Por unión sobre esos subconjuntos,

$$
\Pr[\text{menos de }q\text{ distintos tras }R]
\le\min\left\{1,\binom{M}{q-1}\left(\frac{q-1}{M}\right)^R\right\}.
$$

Para $R=512$, esa expresión es $\tau_T<2^{-300}$ en los nueve tamaños. Hasta el corte, el algoritmo original y el truncado son idénticos. Una aceptación original posterior al corte exige un candidato que cumpla PoW y tenga cadena larga; el mismo argumento de entradas distintas lo acota por $2^{-g}\tau_T$ por candidato, fuera de los eventos ya cobrados. Los intentos adaptativos aportan $(Q+1)2^{-g}\tau_T$.

Esto permite estudiar el código original sin afirmar que ya implementa ese corte ni contar un número ilimitado de llamadas dentro de $S$. La aceptación posterior al corte se cobra al evento de cola, y el grafo solo necesita analizarse hasta el corte de la única verificación final. No se deriva de aquí una garantía operativa de tiempo máximo o ausencia de denegación de servicio.

### 9. Cuenta del verificador y cierre de la prueba

Cada pareja consulta seis puntos AIR, con $\ell$ hermanos y un hash de hoja por punto. En cada FRI consulta dos hojas por capa; en la capa $j$ cada camino tiene $\ell-j$ hermanos. Esto da $W_T+q(6+2k_t+2k_c)$ hashes Merkle como máximo.

El canal realiza: dominio, perfil, enunciado y raíz inicial (4); tres retos AIR (3); dos etiquetas de fase y dos constantes finales (4); absorción y reto por cada capa ($2k_t+2k_c$); comprobación de trabajo y absorción de nonce (2); hasta 512 índices. Son $13+2(k_t+k_c)+512$ llamadas. Los rechazos anticipados solo reducen estas cuentas.

Para $T=4096$, se obtiene $B_T=22.106$ y $V_T=24.895$. El verificador Python independiente reproduce el número exacto de llamadas para los certificados honestos, sustituyendo 512 por las extracciones realmente utilizadas.

**Demostración del teorema.** Se separa primero $\mathsf{Bad}_H$, con la probabilidad de §4. En las ejecuciones restantes, §5 fija los vectores antes de los retos y §6 los enlaza a una historia ideal válida. Se cobra cualquier primera transición excepcional AIR/FRI con el término de campo. Si no ocurre, la aceptación exige un candidato final cuyo trabajo y consultas sean favorables, o una ejecución que supere el corte. Los §§7–8 cubren esos eventos aun con búsquedas adaptativas. Sumar las tres contribuciones y truncar en uno da la expresión de §2. $\square$

La demostración escrita es el objeto pendiente de revisión externa. Los tests no certifican por sí solos el argumento general de simulación ni el lema de candidatos adaptativos.

## 10. Instancias y alcance de los parámetros

Los siguientes valores son límites superiores redondeados hacia arriba para **release, $g=20$**:

| $T$ | $Q=2^{10}$ | $Q=2^{20}$ | $Q=2^{24}$ | $Q=2^{28}$ |
|---:|---:|---:|---:|---:|
| 16 | 0,000000162429 | 0,000166164534 | 0,002658630152 | 0,042538080042 |
| 64 | 0,000002868091 | 0,002934061841 | 0,046944947484 | 0,751119117760 |
| 256 | 0,000004186428 | 0,004282723216 | 0,068523510189 | 1 |
| 4096 | 0,000004650368 | 0,004757335454 | 0,076117299199 | 1 |

El [cálculo exacto](Transferencia-ROM-2026-09-23/calculos.json) conserva 108 escenarios: nueve tamaños, dos niveles de trabajo y seis presupuestos. La cota que llega a uno deja de informar; no demuestra un ataque con probabilidad uno. Una cota superior tampoco es una estimación de la vulnerabilidad real.

La transferencia clásica ROM queda formulada con pérdidas explícitas, pero los parámetros actuales no quedan acreditados como seguridad de 100 bits. Si esa garantía se exige, habrá que revisar tamaño de campo, consultas, presupuesto adversario y análisis antes de prometerla. El modelo cuántico necesita otro argumento: el registro clásico de entradas consultadas no se aplica sin cambios a consultas en superposición.

## 11. Correspondencia experimental y trazabilidad

La auditoría independiente anterior comprobaba SHA3, nonces, posiciones y aperturas de 14 certificados. El nuevo verificador Python añade la composición AIR, cada arrastre de plegado en $F_{p^2}$ y la constante final, manteniendo el orden de rechazo relevante:

- ocho certificados honestos aceptan, en debug y release;
- seis certificados de oráculos alejados rechazan en FRI de traza, igual que Rust;
- se contrastan las cuentas hash y once pruebas nuevas cubren además sesgo, cola, extracción congelada, referencias futuras, colisiones, repetición y mutaciones de pruebas.

El corte de 512 del auditor es una protección de esa herramienta. Los certificados usados terminan antes del corte; no se modifica el Rust. Los casos de oráculos lejanos tienen enunciados válidos y continúan siendo contraejemplos de proximidad del legado, no falsificaciones de enunciado del protocolo vinculado.

Las pruebas Rust, las pruebas matemáticas previas, el manifiesto y los documentos protegidos se verifican en [validacion.json](Transferencia-ROM-2026-09-23/validacion.json). Se conservan las fuentes exactas de los scripts y de la variante para reproducir esta etapa. La integración de la rama anterior en `main` es local; no implica publicación remota ni aprobación académica.

## 12. Referencias y revisión solicitada

1. Ben-Sasson, Chiesa y Spooner, [Interactive Oracle Proofs](https://eprint.iacr.org/2016/116.pdf), versión 2016-02-10, §3.1 y §§6–7: extracción por registro de consultas y compilación de IOP. [Copia conservada](Transferencia-ROM-2026-09-23/bibliografia/BCS16.pdf). La constante de esta nota no se atribuye a ese artículo.
2. [Derivación AIR/FRI por rondas](Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md), lemas A–B, proposición C y referencias primarias allí conservadas.
3. [Auditoría previa de bytes, sesgo y Merkle/Fiat–Shamir](R4-Merkle-Fiat-Shamir-2026-09-23.md); [implementación vinculada y alcance](R4-FRI-Vinculado-2026-09-22.md).

Prioridades para el lector independiente: (i) instante de extracción y manejo de subárboles incompletos; (ii) unicidad del recorrido del canal con un único oráculo y solapamiento de 65 bytes; (iii) acoplamiento de candidatos de nonce con interrupciones y consultas intercaladas; (iv) separación entre la cola del verificador original y las consultas contadas en el grafo; (v) suficiencia de la cota para el alcance de TG2. Ninguna aprobación previa del director se atribuye a este teorema propuesto.


# Potencial para nonces adaptativos y revisión interna

## Revisión crítica de la transferencia ROM a TG2 v1

**Fecha:** 23 de septiembre de 2026. **Estado:** revisión interna y demostración ampliada propuestas; dictamen independiente pendiente.

### 1. Objeto y resultado de la revisión

Se revisaron la [derivación por rondas](Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md), la [transferencia ROM](Transferencia-ROM-2026-09-23/Transferencia-Protocolo-ROM.md), `verify` de `nexus-zk/experiments/tg2_linked_trace_fri.rs`, el canal y la verificación FRI/Merkle que utiliza. El código corresponde a `01dcde960402b6c60a19242b7ae3d6ac3d82a518`; la revisión documental de partida es `ca5bfa4`.

La revisión no encontró un contraejemplo a la cota propuesta bajo sus hipótesis. Identificó una limitación concreta de la evidencia: el ensayo anterior de nonces comparaba dos órdenes fijos de conjunciones y no optimizaba decisiones adaptativas. Aquí se añade una búsqueda exacta de estrategias pequeñas y se desarrolla un argumento de potencial que justifica la contabilidad adaptativa sin necesitar completar cadenas virtuales abandonadas.

No se modifica la fórmula ni el protocolo. La conclusión sigue siendo una demostración propuesta en ROM clásico, específica de la variante experimental vinculada y de su AIR demostrativo. Esta revisión realizada durante el desarrollo no constituye una auditoría externa.

| Punto revisado | Hallazgo o precisión | Consecuencia |
|---|---|---|
| Extracción Merkle | Es indispensable marcar la raíz antes del reto y congelar el vector con el registro de ese instante | Se explicita el orden y se ensayan 60 permutaciones pequeñas |
| Gramática | Nodo y enunciado sí pueden ser la misma entrada de 65 bytes, incluso sin evento excepcional | Se conserva el análisis de un solo oráculo; no se introduce separación ficticia |
| Retos de campo | El conjunto excepcional debe estar fijado antes de la respuesta cruda, sin condicionar a la ausencia futura de colisiones | Se mantiene la masa máxima $\mu$ y la cuenta por consultas nuevas |
| Nonces | Una probabilidad condicionada a haber ganado no puede cobrarse como probabilidad de iniciar un intento | Se demuestra una desigualdad de potencial por cada inicio |
| Cola de índices | El corte 512 solo pertenece al análisis; un candidato largo puede haberse explorado antes de entregarse | Se conserva el evento de cola de sus primeras 512 extracciones |
| Pruebas de software | Los órdenes fijos anteriores no cubrían políticas adaptativas | Se añaden 12 tests, 96 escenarios y 6.318 estados de Bellman, sumados por ejecución |

### 2. Extracción: instante, profundidad y raíz marcada

Sea $\mathcal F_t$ la historia completa de entradas y respuestas hasta el instante $t$. Se usa el evento $\mathsf{Bad}_H$ definido en la transferencia: una respuesta nueva que acierta contra una respuesta previa, una ventana de 32 bytes de una entrada corta ya presentada o una etiqueta de la prueba final.

Para la raíz $r$ de una capa, sea $t_r$ el instante después de presentar su absorción y antes del reto de extensión que corresponde a esa capa. Se define

$$
u_r=\operatorname{Extraer}(r,n;\mathcal F_{t_r}).
$$

La extracción recorre únicamente preimágenes registradas de tipo correcto y profundidad fijada. Completa regiones desconocidas con cero y congela el resultado. En la traza inicial, $t_r$ precede al primer $\alpha$; en capas posteriores, precede al $\beta$ correspondiente.

**Invariante de aperturas.** Hasta el primer $\mathsf{Bad}_H$, una apertura aceptada bajo esa raíz solo puede usar las preimágenes presentes en $\mathcal F_{t_r}$ en su recorrido. Una preimagen alternativa para un digest registrado colisionaría. Si falta una preimagen, su consulta posterior produciría una etiqueta marcada: la raíz se marcó en la absorción y cada hijo conocido se marcó en el mensaje del padre. Por inducción desde la raíz, una apertura aceptada coincide con $u_r$.

**Control negativo.** Si se elimina la condición de raíz previamente marcada, la afirmación es falsa: se puede extraer cero de una raíz aún desconocida, consultar después su hoja y obtener otra extracción sin que el monitor haya marcado esa etiqueta. El test construye expresamente ese caso y después añade la absorción de raíz: la consulta tardía activa el evento excepcional. La precomputación usada por el test para preparar esa etiqueta artificial no es un ataque ROM admisible con preparación gratuita.

Se enumeran los 60 órdenes de dos hojas, su padre, absorción de raíz y reto que respetan absorción antes de reto. Dos órdenes no activan el evento, y en ambos la extracción congelada coincide con las hojas; no aparece ninguna discrepancia fuera del evento. Es un contraste finito del invariante, no una prueba para todos los árboles.

La idea de extracción por registro se contrasta con BCS16, §3.1. El argumento anterior incorpora las hojas codificadas, los prefijos y la profundidad concretos de TG2.

### 3. Prefijo válido y coincidencia de roles

Fuera del evento de grafo, una respuesta que actúa como estado siguiente no puede producirse después de que ese estado aparezca en una consulta posterior válida: en ese caso se habría marcado antes de producirse. Tampoco puede tener dos preimágenes distintas. Recorrer hacia atrás el canal reconstruye las absorciones y retos hasta el dominio inicial, en orden temporal estricto.

El formato y el lugar dentro del recorrido fijan el significado del mensaje. Los dos retos de 33 bytes se distinguen por `E` e `I`; el trabajo usa 41 bytes y la absorción de nonce 49. Una cadena de retos no puede empezar antes de su semilla ni converger desde otra semilla sin una referencia adelantada o colisión. Consultar de nuevo una entrada devuelve su respuesta anterior y no crea otra oportunidad.

La coincidencia de 65 bytes exige cuidado. El nuevo test produce una asignación artificial del oráculo con

$$
\begin{aligned}
s_{\mathrm{perfil}}&=01\parallel a_{0..30},\\
\text{hijo izquierdo}&=a_{0..30}\parallel04,\\
\text{hijo derecho}&=24_{64}\parallel\text{enunciado}.
\end{aligned}
$$

Así, `01 || hijo izquierdo || hijo derecho` es exactamente `estado || 04 || 24_64 || enunciado`. Las preimágenes de las hojas se consultan primero y no aparece $\mathsf{Bad}_H$. Esto refuta una supuesta separación global de roles por etiquetas. La transferencia original ya permitía esta coincidencia: como paso del canal sigue teniendo un único estado anterior y un único enunciado.

La asignación del test fuerza respuestas y no mide su probabilidad ni rompe SHA3. Su función es comprobar que la demostración admite todas las formas posibles de una ejecución del oráculo.

### 4. Lema de candidatos adaptativos mediante potencial

### 4.1 Condiciones e instante de inicio

Un candidato es $(s,n)$, con $s$ un estado final de prefijo válido para un enunciado falso, todavía sin escape algebraico, y $n$ un nonce u64. Se inicia en la primera consulta a su entrada de trabajo o de absorción. La reconstrucción de §3 garantiza que su historia, oráculos y caso activo ya están fijados si ese candidato puede conducir a una aceptación sin $\mathsf{Bad}_H$.

Un candidato referido antes de que su estado tenga una historia válida no puede adquirir esa historia más tarde sin $\mathsf{Bad}_H$. Las entradas de inicio son inyectivas en $(s,n)$ y sus dos roles tienen distintas longitudes. Cada consulta adversaria inicia a lo sumo uno; la única verificación final inicia a lo sumo otro. El número total de inicios relevantes es

$$
C\le Q+1.
$$

El caso activo de la prueba AIR/FRI define para el candidato un conjunto fijo $G$ de parejas que supera ese control, con $g_0=|G|\le M-\lceil M/8\rceil$. No se necesita independencia entre controles ni entre los conjuntos escogidos para distintos candidatos.

### 4.2 Potencial de un candidato

Escribimos $p_\mathrm{w}=2^{-g}$ para distinguir los bits de trabajo del tamaño $g_0$. Si se han observado $a$ índices distintos, todos en $G$, sea

$$
\rho_a=\frac{\binom{g_0-a}{q-a}}{\binom{M-a}{q-a}}\quad(0\le a\le q).
$$

Si $g_0<q$ o apareció un índice fuera de $G$, el potencial es cero. Al completar $q$ distintos buenos, $\rho_q=1$. Para el trabajo, usamos $w=p_\mathrm{w}$ si no se ha consultado, $w=1$ si fue válido y $w=0$ si falló. Definimos $\phi=w\rho_a$.

Antes de la primera respuesta del candidato,

$$
\phi_\mathrm{inicio}=p_\mathrm{w}\frac{\binom{g_0}{q}}{\binom Mq}
\le p_\mathrm{w}h_T.
$$

Cada consulta nueva a su trabajo preserva el potencial en esperanza. La absorción de nonce no selecciona un índice y tampoco cambia el potencial. Para una extracción `I` nueva, un índice repetido tiene probabilidad $a/M$, uno bueno nuevo $(g_0-a)/M$ y uno malo $(M-g_0)/M$. Por la identidad hipergeométrica,

$$
\frac aM\rho_a+\frac{g_0-a}{M}\rho_{a+1}=\rho_a.
$$

Una extracción repetida desde el mismo estado devuelve lo ya conocido; no se trata como una muestra nueva. El potencial corresponde al prefijo más largo de esa cadena que consta en el registro, no al número de veces que el adversario lo reproduce.

### 4.3 Historia global y eventos excepcionales

La identidad se evalúa condicionada a la historia **antes** de una respuesta fresca. Incluye toda la información de otros candidatos y los bits completos de respuestas anteriores. El siguiente resultado crudo sigue siendo uniforme; la máscara usada por `challenge_index` es uniforme porque $M$ es potencia de dos.

Se detiene la cuenta y se pone el potencial total a cero al primer $\mathsf{Bad}_H$ o escape algebraico relevante. Un evento excepcional puede estar correlacionado con el siguiente índice: poner a cero términos no negativos solo reduce la esperanza. No se condiciona el muestreo a que ese evento nunca ocurra.

Antes de ese corte, una consulta afecta a lo sumo a un paso nuevo de una cadena de candidato: compartir un estado nuevo entre cadenas distintas implicaría una colisión o referencia adelantada. Consultas a otros roles pueden ser ignoradas o activar el corte. Abandonar un candidato no aumenta su potencial; puede conservarse en el registro y retomarse. El formato fijo evita que cambie su conjunto $G$.

Sea $\Phi_t$ la suma de los potenciales de todos los candidatos iniciados hasta $t$, y $C_t$ su número de inicios. En cada inicio se añade a lo sumo $p_\mathrm{w}h_T$; entre inicios la esperanza no aumenta. Por lo tanto

$$
\Phi_t-p_\mathrm{w}h_T C_t
$$

es una supermartingala, es decir, su esperanza condicionada al pasado no aumenta. No requiere que las elecciones del adversario sean independientes. En el horizonte acotado de $Q$ consultas y la verificación truncada,

$$
\mathbb E[\Phi_\mathrm{fin}]\le p_\mathrm{w}h_T\,\mathbb E[C_\mathrm{fin}]
\le(Q+1)p_\mathrm{w}h_T.
$$

Si el verificador truncado acepta sin eventos excepcionales, el candidato elegido tiene trabajo válido y $q$ parejas buenas: su potencial es uno y $\Phi_\mathrm{fin}\ge1$. Así,

$$
\Pr[\text{aceptación truncada sin excepciones}]
\le(Q+1)2^{-g}h_T.
$$

La verificación final puede completar gratis las consultas de un candidato parcialmente explorado. Esas respuestas se incluyen en $V_T$ y preservan la desigualdad; si usa un candidato nuevo se cobra el inicio adicional.

**Precisión de condicionamiento.** Para un candidato ya seleccionado porque ganó el trabajo, la probabilidad restante puede ser $h_T$, no $2^{-g}h_T$. El factor de trabajo se cobra al inicio, antes de saber si gana. El test pequeño obtiene $1/8$ como probabilidad conjunta y $1/2$ al condicionar al trabajo válido; confundirlas invalidaría la contabilidad.

### 5. Cola y número de consultas

Para la cola se usa un potencial independiente. Tras $r\le R$ extracciones y $a$ distintos, sea

$$
L(r,a)=\Pr[\text{menos de }q\text{ distintos al llegar a }R\mid r,a].
$$

Tiene condiciones $L(R,a)=\mathbf1[a<q]$ y $L(r,a)=0$ para $a\ge q$, y recurrencia

$$
L(r,a)=\frac aM L(r+1,a)+\frac{M-a}{M}L(r+1,a+1).
$$

Multiplicar por el estado del trabajo $w$ produce la misma cuenta de potencial, con coste inicial $2^{-g}L(0,0)\le2^{-g}\tau_T$. Una vez vistas las primeras $R$ extracciones, se conserva su indicador de cola aunque el adversario continúe y termine la cadena. Por ello el argumento cubre candidatos que ya habían sido explorados más allá de $R$ antes de entregar la prueba.

La aceptación del verificador original después del corte implica trabajo válido y ese indicador de cola. Su probabilidad, antes de excepciones, queda acotada por $(Q+1)2^{-g}\tau_T$. No hace falta simular el verificador final más allá del corte para detectar ese evento.

El Rust comprueba longitudes y formas antes de empezar a hashear. Si son inválidas, rechaza sin usar la cuenta $B_T$ para una prueba arbitrariamente grande. La cuenta de etiquetas de la prueba se aplica una vez admitida su forma; los tests comprueban el rechazo previo en el verificador de referencia. El límite de RAM del decodificador y la terminación del selector de índices son problemas operativos distintos de esta probabilidad.

Con $R=512$, el mismo $V_T$ acota los hashes de la verificación truncada. La suma de pérdidas conserva la fórmula original:

$$
\begin{aligned}
E_{\mathrm{ROM}}&\le\min\left\{1,\frac{S(49S+B_T)}{2^{256}}\right.\\
&\left.\quad +(Q+m)\frac N2\mu +(Q+1)2^{-g}(h_T+\tau_T)\right\},\\
S&=Q+V_T.
\end{aligned}
$$

### 6. Contrastes exactos y qué abarcan

El [analizador](../../../scripts/analizar_revision_rom_tg2.py) calcula una programación dinámica de Bellman con fracciones exactas. Para cada estado compara las acciones: consultar trabajo, absorber nonce, pedir el siguiente índice, retomar otro candidato, abandonar uno e iniciar otro, o terminar escogiendo qué candidato verificará el verificador. También admite entregar un candidato nuevo sin consultas previas, y los índices repetidos consumen presupuesto.

El modelo pequeño usa monedas frescas: excluye eventos de grafo y escapes algebraicos, que se cobran por separado en el teorema. Los conjuntos buenos están fijados al inicio y se representan por su cardinalidad. La búsqueda mantiene dos o tres candidatos simultáneos; no demuestra que ese límite de memoria sea óptimo para el protocolo real. La prueba de potencial no tiene esa restricción.

Se recorren tres perfiles $(M,g_0,q)=(2,1,1),(4,3,2),(4,3,3)$, dos niveles de trabajo, dos capacidades y ocho presupuestos $Q=0,\ldots,7$: **96 escenarios**, con **6.318 estados de Bellman sumados por ejecución**. El óptimo no supera $(Q+1)2^{-g}h$ en ninguno. No son 6.318 estados globalmente distintos.

Ejemplo con $M=4$, $g_0=3$, $q=2$, dos bits de trabajo y hasta tres candidatos:

| Consultas adversarias $Q$ | Óptimo exacto del modelo pequeño | Cota usada |
|---:|---:|---:|
| 0 | $1/8$ | $1/8$ |
| 1 | $7/32$ | $1/4$ |
| 3 | $179/512$ | $1/2$ |
| 7 | $72363/131072$ | $1$ |

Las **12 pruebas nuevas** cubren además identidades de potencial, cola exacta por enumeración, condicionamiento al ganador, los órdenes de Merkle, ausencia de la premisa de raíz, coincidencia de roles, anticipación de estados, ciclos y rechazo de formas inválidas antes del hash. Se repiten las 28 pruebas Python anteriores, las 197 Rust y check/build; los resultados y fuentes están en [validacion.json](Revision-Critica-ROM-2026-09-23/validacion.json).

No se ha ejecutado una búsqueda exhaustiva en los parámetros de producción ni se ha probado ausencia de ataques contra SHA3. Las pruebas complementan el argumento general escrito.

### 7. Dictamen interno y siguiente trabajo

1. La extracción y el canal conservan sus premisas; los controles negativos muestran por qué no pueden omitirse.
2. El término de nonces dispone ahora de una demostración por potencial para decisiones adaptativas, con corte explícito ante eventos excepcionales.
3. La revisión mantiene las pérdidas y las cifras anteriores. No mejora por sí sola la seguridad acreditada por esos parámetros.
4. El siguiente estudio debe fijar **presupuesto adversario $Q$ y probabilidad objetivo $\epsilon$** antes de elegir parámetros. No debe confundirse $-\log_2$ de una cota de probabilidad para un presupuesto dado con una estimación automática del trabajo de ataque.
5. Se mantiene pendiente el dictamen independiente de los lemas algebraicos y de ambas demostraciones ROM. La reducción QROM, conocimiento cero y R1 sobre ML-DSA requieren argumentos propios.

El manuscrito y el Word anteriores conservan sus ediciones identificadas. Este suplemento refuerza §§5–8 de la transferencia anterior y debe acompañarla al solicitar dictamen; no se atribuye aprobación del director a esta revisión.

### 8. Referencias

- Ben-Sasson, Chiesa y Spooner, [Interactive Oracle Proofs](https://eprint.iacr.org/2016/116.pdf), versión del 10 de febrero de 2016, §3.1 y §§6–7; [copia local](Transferencia-ROM-2026-09-23/bibliografia/BCS16.pdf). Se contrastó la extracción por registro; las cuentas específicas y el potencial de este suplemento no se atribuyen al artículo.
- [Solidez por rondas de AIR/FRI](Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md), lemas A–B y proposición C.
- [Transferencia ROM de TG2 v1](Transferencia-ROM-2026-09-23/Transferencia-Protocolo-ROM.md), parámetros, gramática, evento de grafo y cuentas del verificador.


