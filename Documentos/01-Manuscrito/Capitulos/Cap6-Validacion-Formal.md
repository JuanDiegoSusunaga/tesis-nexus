# Capítulo 6 — Validación Formal de la Seguridad

### (Desarrollo del Objetivo 4 · versión redactada del esqueleto `Cap4-Validacion-Formal-Esqueleto.md`)

> **Mapa.** Este capítulo corresponde al **Objetivo 4** de la propuesta y al **Capítulo 6** de la estructura del Plan Maestro. Desarrolla la validación formal en dos brazos complementarios: una **prueba de dureza post-cuántica** (§6.4) y un **análisis de complejidad computacional** (§6.5), cerrados con una **validación empírica** (§6.6). Las cifras y términos siguen las *invariantes de consistencia* del Plan Maestro.

---

## 6.1 Introducción y alcance

La seguridad de NEXUS descansa, en última instancia, sobre una única afirmación criptográfica: que **las firmas que autorizan las transacciones no pueden ser falsificadas por un adversario, ni siquiera por uno equipado con un computador cuántico**. Este capítulo valida formalmente esa afirmación para el esquema de firma adoptado, CRYSTALS-Dilithium, y caracteriza el costo computacional que dicha seguridad impone.

Por **validación formal** entendemos un procedimiento de cuatro pasos, que estructura todo el capítulo:

1. **Fijar un modelo de seguridad** preciso: qué es un adversario, qué significa "romper" el esquema y bajo qué capacidades (§6.3).
2. **Reducir** la seguridad del esquema a un problema computacional bien estudiado, de modo que romper la firma implique resolver dicho problema (§6.4.1–6.4.2).
3. **Argumentar la dureza cuántica** de ese problema, mostrando por qué los algoritmos cuánticos conocidos —en particular el de Shor— no lo resuelven eficientemente (§6.4.3).
4. **Acotar el costo computacional** de las operaciones del esquema mediante notación asintótica, y validarlo empíricamente (§6.5–6.6).

**Alcance.** Esta validación cubre la **in-forjabilidad** de la firma Dilithium en el modelo de caja negra (el adversario interactúa con el esquema sin acceso a su implementación física). Quedan **fuera del alcance**, y se declaran explícitamente en §6.7: la seguridad de implementación (canales laterales, ataques por fallos), la seguridad del protocolo de consenso (de la que depende la integridad del libro mayor pero no la del primitivo), y los componentes aún no implementados (la capa de pruebas de conocimiento cero, la confidencialidad post-cuántica vía KEM).

**Una aclaración metodológica importante.** No se re-demuestran los teoremas fundacionales de la criptografía reticular (las reducciones de Regev o de Langlois–Stehlé, la prueba de seguridad original de Dilithium). El aporte de este capítulo no es re-probarlos, sino **enunciarlos con precisión, citarlos e instanciarlos** para los parámetros concretos de NEXUS, **ensamblar** la cadena completa de reducciones, y **particularizar** el análisis de complejidad y de *overhead* a la arquitectura dual. Este es el nivel de rigor apropiado y suficiente para un trabajo de grado.

---

## 6.2 Preliminares matemáticos

### 6.2.1 Retículos y problemas reticulares

**Definición 6.1 (Retículo).** Dados $m$ vectores linealmente independientes $\mathbf{b}_1,\dots,\mathbf{b}_m \in \mathbb{R}^d$, el *retículo* que generan es el conjunto de sus combinaciones enteras:
$$\Lambda = \mathcal{L}(\mathbf{B}) = \Big\{ \textstyle\sum_{i=1}^{m} z_i\,\mathbf{b}_i : z_i \in \mathbb{Z} \Big\}.$$
La matriz $\mathbf{B}=[\mathbf{b}_1\,|\cdots|\,\mathbf{b}_m]$ es una *base*. Se denota $\lambda_1(\Lambda)$ la longitud (euclídea) del vector no nulo más corto del retículo.

Sobre los retículos se definen los problemas computacionales cuya dureza fundamenta la criptografía post-cuántica. Para un factor de aproximación $\gamma \ge 1$:

**Definición 6.2 (Problemas reticulares aproximados).**
- *$\gamma$-SVP (Shortest Vector Problem):* hallar $\mathbf{v}\in\Lambda\setminus\{\mathbf 0\}$ con $\|\mathbf v\| \le \gamma\,\lambda_1(\Lambda)$.
- *$\gamma$-SIVP (Shortest Independent Vectors Problem):* hallar $n$ vectores **linealmente independientes** de $\Lambda$, todos de longitud $\le \gamma\,\lambda_n(\Lambda)$.
- *$\gamma$-GapSVP:* problema de decisión asociado a $\gamma$-SVP.

Conviene subrayar una distinción que será relevante en §6.4.2: **SVP pide un único vector corto, mientras que SIVP pide $n$ vectores cortos independientes**; son problemas distintos, y el que aparece en las reducciones de Dilithium es **SIVP** (en su versión sobre módulos). Para factores $\gamma$ polinómicos en la dimensión, $\gamma$-SVP y $\gamma$-SIVP se conjeturan **difíciles tanto clásica como cuánticamente** [Pei16], y constituyen el cimiento de seguridad de toda la familia reticular.

### 6.2.2 Anillos ciclotómicos y módulos

Dilithium no opera sobre retículos generales sino sobre **retículos de módulo**, lo que reduce drásticamente el tamaño de las claves. Sea $n=256$ (una potencia de dos) y $q = 8\,380\,417 = 2^{23}-2^{13}+1$, un número **primo**. Se define el anillo de polinomios y su versión modular:
$$R = \mathbb{Z}[X]/(X^{n}+1), \qquad R_q = \mathbb{Z}_q[X]/(X^{n}+1).$$
Los elementos de $R_q$ son polinomios de grado $<n$ con coeficientes en $\mathbb{Z}_q$. La elección de $q$ no es arbitraria: satisface
$$q \equiv 1 \pmod{2n}, \qquad\text{en efecto}\quad 8\,380\,417 = 512\cdot 16\,368 + 1,\ \text{con } 2n=512,$$
de modo que $\mathbb{Z}_q$ contiene una raíz $2n$-ésima primitiva de la unidad. Esta propiedad habilita la **Transformada Teórica de Números (NTT)**, que permite multiplicar en $R_q$ en tiempo $O(n\log n)$ (§6.5.1) y es la razón de la eficiencia del esquema.

Un **módulo** de rango $\ell$ sobre $R_q$ es $R_q^{\ell}$; las claves de Dilithium viven en módulos $R_q^{k}$, $R_q^{\ell}$ y en matrices $\mathbf{A}\in R_q^{k\times\ell}$.

**Normas.** Para $w=\sum_i w_i X^i \in R_q$ con coeficientes representados de forma centrada en $(-q/2, q/2]$, se definen $\|w\|_\infty = \max_i |w_i|$ y $\|w\|_2 = (\sum_i w_i^2)^{1/2}$, y se extienden coeficiente a coeficiente a vectores de $R_q^k$. El conjunto de "polinomios pequeños" acotados por $\eta$ es $S_\eta = \{w\in R : \|w\|_\infty \le \eta\}$.

### 6.2.3 Module-LWE, Module-SIS y SelfTargetMSIS

**Definición 6.3 (Module-LWE decisional, $\mathrm{MLWE}_{k,\ell,\eta}$).** Sean $\mathbf{s}\in S_\eta^{\ell}$ (secreto) y $\mathbf{e}\in S_\eta^{k}$ (error) con coeficientes pequeños, y $\mathbf{A}\xleftarrow{\$} R_q^{k\times\ell}$ uniforme. El problema pide distinguir, con ventaja no despreciable, la distribución
$$\big(\mathbf{A},\ \mathbf{A}\mathbf{s}+\mathbf{e}\big) \qquad\text{de}\qquad \big(\mathbf{A},\ \mathbf{u}\big),\quad \mathbf{u}\xleftarrow{\$} R_q^{k}.$$
La versión de **búsqueda** pide recuperar $\mathbf{s}$ a partir de $(\mathbf{A}, \mathbf{A}\mathbf{s}+\mathbf{e})$.

**Definición 6.4 (Module-SIS, $\mathrm{MSIS}_{k,\ell,\beta}$).** Dada $\mathbf{A}\xleftarrow{\$} R_q^{k\times\ell}$ y una cota $\beta$, hallar un vector $\mathbf{z}\in R_q^{\ell}\setminus\{\mathbf 0\}$ tal que
$$\mathbf{A}\mathbf{z} = \mathbf{0} \pmod q \qquad\text{y}\qquad \|\mathbf{z}\| \le \beta.$$

**Definición 6.5 (SelfTargetMSIS).** Variante empleada en la prueba de Dilithium en el (Q)ROM. Dada $\mathbf{A}$ y una función de *hash* $H$ modelada como oráculo aleatorio, hallar un mensaje $\mu$ y un vector corto $\mathbf{y}$ tales que el reto $c = H\big([\,\mathbf I\,|\,\mathbf A\,]\,\mathbf{y} \,\|\, \mu\big)$ coincida con el bloque correspondiente de $\mathbf{y}$, con $\|\mathbf y\|_\infty$ acotada. La particularidad —crucial en §6.4.1— es que el reto va **embebido** en la instancia: **una falsificación válida es, por construcción, una solución directa de SelfTargetMSIS**.

**Parámetros de NEXUS.** La siguiente tabla fija los conjuntos de parámetros, conforme a **FIPS 204 / ML-DSA** [NIST24] (la parametrización que implementa el prototipo mediante el crate `fips204`):

| Parámetro | Dilithium2 | Dilithium3 | Dilithium5 |
|---|:---:|:---:|:---:|
| $(k,\ell)$ — dimensiones de $\mathbf A$ | $(4,4)$ | $(6,5)$ | $(8,7)$ |
| $\eta$ — rango del secreto | $2$ | $4$ | $2$ |
| $n,\ q$ | \multicolumn{3}{c}{$256,\ \ 8\,380\,417$} |
| Nivel de seguridad NIST | 2 | 3 | 5 |
| Clave pública (bytes) | 1312 | 1952 | 2592 |
| Firma (bytes) | 2420 | 3309 | 4627 |

> **Nota.** Los tamaños mostrados son los de **FIPS 204 / ML-DSA** (lo que implementa el prototipo vía el crate `fips204`, puro Rust). Las claves secretas son 2560/4032/4896 B (D2/D3/D5).

---

## 6.3 Modelo de seguridad

### 6.3.1 El esquema de firma e instanciación con Dilithium

**Definición 6.6 (Esquema de firma).** Una terna de algoritmos $(\mathsf{KeyGen}, \mathsf{Sign}, \mathsf{Verify})$:
$$\mathsf{KeyGen}(1^\lambda)\to(pk,sk), \quad \mathsf{Sign}(sk,\mu)\to\sigma, \quad \mathsf{Verify}(pk,\mu,\sigma)\to\{0,1\},$$
con **corrección**: $\Pr[\mathsf{Verify}(pk,\mu,\mathsf{Sign}(sk,\mu))=1] \ge 1-\mathrm{negl}(\lambda)$.

**Instanciación (Dilithium).** La clave secreta es $sk=(\mathbf{s}_1,\mathbf{s}_2)$ con $\mathbf{s}_1\in S_\eta^\ell$, $\mathbf{s}_2\in S_\eta^k$; la clave pública es $pk=(\mathbf{A},\ \mathbf{t}=\mathbf{A}\mathbf{s}_1+\mathbf{s}_2)$, donde $\mathbf{A}$ se regenera de forma determinística a partir de una semilla pública de 256 bits (no se almacena). La firma sigue el paradigma **Fiat-Shamir with Aborts** —técnica introducida por Lyubashevsky en ASIACRYPT 2009 [Lyu09] e instanciada sobre retículos en EUROCRYPT 2012 [Lyu12]— mediante el bucle:

1. Muestrear un "compromiso" $\mathbf{y}\in S_{\gamma_1}^\ell$ y computar $\mathbf{w}=\mathbf{A}\mathbf{y}$.
2. Derivar el reto $c=H(\mu, \mathbf{w}_1)$, un polinomio con pocos $\pm1$.
3. Computar la respuesta $\mathbf{z}=\mathbf{y}+c\,\mathbf{s}_1$.
4. **Rechazo:** si $\mathbf z$ (o términos asociados) excede ciertas cotas que evitarían filtrar el secreto, **abortar y reintentar** desde (1).

La firma es $\sigma=(\mathbf{z},\mathbf{h},c)$, donde $\mathbf h$ es una "pista" (*hint*) de pocos bits. La verificación recomputa $\mathbf{w}'$ a partir de $\mathbf{z}$, $c$ y $\mathbf{t}$, y acepta si $c=H(\mu,\mathbf{w}'_1)$ y las normas de $\mathbf z$ están dentro de cotas. El paso de **rechazo** es esencial: garantiza que la distribución de $\mathbf z$ sea independiente del secreto (propiedad de simulabilidad, §6.4.1).

### 6.3.2 In-forjabilidad: EUF-CMA y sUF-CMA

**Definición 6.7 (Juego EUF-CMA).** Un adversario $\mathcal{A}$ recibe $pk$ y acceso a un oráculo de firma $\mathcal{O}_{\mathsf{Sign}}(\cdot)$. Produce un par $(\mu^*,\sigma^*)$ y **gana** si $\mathsf{Verify}(pk,\mu^*,\sigma^*)=1$ y $\mu^*$ nunca fue consultado al oráculo. Su ventaja es $\mathsf{Adv}^{\text{EUF-CMA}}_{\mathcal A}=\Pr[\mathcal A\text{ gana}]$. Un esquema es EUF-CMA seguro si esta ventaja es despreciable para todo $\mathcal A$ eficiente.

**In-forjabilidad fuerte (sUF-CMA).** Refuerza la condición de victoria: $\mathcal{A}$ gana si $(\mu^*,\sigma^*)$ es **nuevo** (incluso para un mensaje ya consultado, basta producir una **firma distinta**). Es la noción pertinente para una blockchain, donde una segunda firma válida sobre la misma transacción podría inducir problemas de maleabilidad e identificación.

### 6.3.3 El adversario cuántico: el QROM

Un adversario cuántico realista no solo ejecuta cómputo cuántico, sino que puede **consultar la función de hash en superposición**. El modelo apropiado es el **Quantum Random-Oracle Model (QROM)** [BDF+11], en el que el oráculo $H$ responde a consultas cuánticas $\sum_x \alpha_x\lvert x\rangle\lvert 0\rangle \mapsto \sum_x \alpha_x\lvert x\rangle\lvert H(x)\rangle$. Probar la seguridad en el QROM (y no solo en el ROM clásico) es indispensable porque las técnicas clásicas de reducción —en particular el rebobinado y el *forking*— **no se trasladan sin más al caso cuántico**: medir una superposición la colapsa, de modo que no se puede "rebobinar" un adversario cuántico arbitrariamente. La prueba de Dilithium en el QROM [KLS18] aborda precisamente esta dificultad.

---

## 6.4 Reducción de dureza post-cuántica

### 6.4.1 Teorema de seguridad de Dilithium

**Teorema 6.1 (Seguridad sUF-CMA de Dilithium — adaptado de [D+18, KLS18]).** *Si los problemas $\mathrm{MLWE}_{k,\ell,\eta}$, $\mathrm{SelfTargetMSIS}_{k,\ell+1}$ y $\mathrm{MSIS}_{k,\ell,\beta}$ (con los parámetros de §6.2.3) son difíciles para algoritmos cuánticos de tiempo polinómico, entonces Dilithium es fuertemente in-forjable (sUF-CMA) en el QROM. Concretamente, para todo adversario cuántico $\mathcal{A}$ existen adversarios $\mathcal{B},\mathcal{C},\mathcal{D}$ de tiempos comparables tales que*
$$\mathsf{Adv}^{\text{sUF-CMA}}_{\mathcal A} \ \le\ \mathsf{Adv}^{\mathrm{MLWE}}_{\mathcal B} \ +\ \mathsf{Adv}^{\mathrm{SelfTargetMSIS}}_{\mathcal C} \ +\ \mathsf{Adv}^{\mathrm{MSIS}}_{\mathcal D} \ +\ 2^{-254}.$$

La cota tiene **tres** términos de dureza, cada uno protegiendo contra un tipo de ataque distinto; el término $2^{-254}$ (colisiones del *hash*) se absorbe en $\mathrm{negl}(\lambda)$. Si solo se desea la noción estándar EUF-CMA, bastan los dos primeros términos.

**Demostración (secuencia de juegos).** Sea $\mathcal A$ un adversario sUF-CMA que realiza $q_s$ consultas de firma y $q_h$ consultas (cuánticas) al oráculo $H$. Construimos una secuencia de juegos $G_0,G_1,G_2$; sea $W_i$ el evento «$\mathcal A$ gana en $G_i$».

*Juego $G_0$ (real).* Es el juego sUF-CMA original (Def. 6.7, variante fuerte): $\mathcal A$ recibe $pk=(\mathbf A,\mathbf t)$ con $\mathbf t=\mathbf A\mathbf s_1+\mathbf s_2$; sus consultas de firma se responden con el firmante real (usando $sk$); $\mathcal A$ produce $(\mu^*,\sigma^*)$ y gana si la firma es válida y el par es nuevo. Por definición, $\mathsf{Adv}^{\text{sUF-CMA}}_{\mathcal A}=\Pr[W_0]$.

*Juego $G_1$ (firmas simuladas).* Idéntico a $G_0$, salvo que las consultas de firma se responden con el **simulador** $\mathsf{Sim}$ del Lema 6.1, que **no usa $\mathbf s_1$** y programa $H$. Por el Lema 6.1, cada firma simulada dista estadísticamente $\le\varepsilon_{\mathrm{zk}}$ de una real, de modo que
$$\lvert \Pr[W_0]-\Pr[W_1]\rvert \ \le\ q_s\cdot \varepsilon_{\mathrm{zk}}, \qquad \varepsilon_{\mathrm{zk}}=\mathrm{negl}(\lambda).$$

*Juego $G_2$ (clave pública uniforme).* Idéntico a $G_1$, salvo que en $\mathsf{KeyGen}$ se reemplaza $\mathbf t=\mathbf A\mathbf s_1+\mathbf s_2$ por $\mathbf t\xleftarrow{\$}R_q^k$ **uniforme**. Tras el cambio de $G_1$, el secreto $\mathbf s_1$ **ya no interviene en ninguna parte** del juego (las firmas las produce $\mathsf{Sim}$ a partir de $pk$); la única diferencia entre $G_1$ y $G_2$ es la distribución de $\mathbf t$, que es exactamente la de una instancia $\mathrm{MLWE}_{k,\ell,\eta}$ frente a uniforme. Un distinguidor entre ambos juegos es, pues, un distinguidor MLWE: existe $\mathcal B$ (de tiempo comparable a $\mathcal A$) con
$$\lvert \Pr[W_1]-\Pr[W_2]\rvert \ \le\ \mathsf{Adv}^{\mathrm{MLWE}}_{\mathcal B}.$$

*Cota de $G_2$.* En $G_2$ **ni la clave pública ni las firmas dependen de secreto alguno** (todo se genera a partir de valores uniformes/públicos). Por tanto, una falsificación válida no puede explotar información filtrada: debe codificar la solución de un problema reticular. Por el **Lema 6.2** (extracción), de una falsificación válida se obtiene (i) una solución de $\mathrm{SelfTargetMSIS}_{k,\ell+1}$ si $\mu^*$ es **nuevo**, o (ii) una solución de $\mathrm{MSIS}_{k,\ell}$ si $\mu^*$ fue consultado pero $\sigma^*$ es una **firma nueva** (caso de in-forjabilidad *fuerte*). Con los reductores $\mathcal C$ y $\mathcal D$ que ejecutan a $\mathcal A$ en $G_2$ y aplican el Lema 6.2,
$$\Pr[W_2] \ \le\ \mathsf{Adv}^{\mathrm{SelfTargetMSIS}}_{\mathcal C} + \mathsf{Adv}^{\mathrm{MSIS}}_{\mathcal D}.$$

*Combinación.* Sumando las tres desigualdades por la desigualdad triangular,
$$\Pr[W_0] \le \mathsf{Adv}^{\mathrm{MLWE}}_{\mathcal B} + \mathsf{Adv}^{\mathrm{SelfTargetMSIS}}_{\mathcal C} + \mathsf{Adv}^{\mathrm{MSIS}}_{\mathcal D} + q_s\,\varepsilon_{\mathrm{zk}}.$$
Por el Lema 6.1, $\varepsilon_{\mathrm{zk}}$ es del orden de $(q_h+q_s)/2^{\,\Omega(\lambda)}$, de modo que el término estadístico total es $\sim q_s(q_h+q_s)/2^{\,\Omega(\lambda)}$ (más la probabilidad de colisión del *hash*). **Bajo las cotas de consulta estándar del modelo** —$q_h,q_s$ acotadas polinómicamente (p. ej. $q_h,q_s\le 2^{64}$)— ese término queda dominado por $2^{-254}$, de donde se obtiene la cota del Teorema 6.1. $\qquad\blacksquare$

**Lema 6.1 (Simulación — Fiat-Shamir con Aborts [Lyu12]).** *Existe un simulador $\mathsf{Sim}$ de tiempo polinómico que, dado solo $pk=(\mathbf A,\mathbf t)$ (sin $\mathbf s_1,\mathbf s_2$) y con capacidad de programar $H$, produce firmas cuya distribución dista estadísticamente $\le \varepsilon_{\mathrm{zk}}=\mathrm{negl}(\lambda)$ de las firmas reales.*

*Demostración (idea).* $\mathsf{Sim}$ muestrea el reto $c$ de su distribución, muestrea $\mathbf z$ de la distribución que sigue una firma real **tras el rechazo** —una distribución sobre $S_{\gamma_1-\beta}^\ell$ que, por diseño del paso de rechazo, es **independiente de $\mathbf s_1$**—, define $\mathbf w := \mathbf A\mathbf z - c\,\mathbf t$ y programa $H(\mu,\mathbf w_1):=c$ (de modo que la ecuación de verificación se cumple por construcción). El **rechazo** del firmante real es exactamente lo que iguala la distribución de su $\mathbf z$ a esta distribución independiente del secreto (propiedad central de *Fiat-Shamir with Aborts*); la única pérdida $\varepsilon_{\mathrm{zk}}$ es la probabilidad de que $H$ ya estuviera definido en $(\mu,\mathbf w_1)$, acotada por $(q_h+q_s)/\lvert\text{dominio}\rvert$. $\qquad\square$

**Lema 6.2 (Extracción).** *De una falsificación válida $(\mu^*,\sigma^*=(\mathbf z^*,\mathbf h^*,c^*))$ en $G_2$ se extrae, en tiempo polinómico, (a) una solución de $\mathrm{SelfTargetMSIS}_{k,\ell+1}$ si $\mu^*$ es nuevo; o (b) un vector corto no nulo en el núcleo de la matriz de $\mathrm{MSIS}_{k,\ell}$ si $\mu^*$ fue consultado y $\sigma^*$ es nueva.*

*Demostración (idea).* **(a)** La validez impone $c^*=H(\mu^*,\mathbf w^*_1)$ con $\mathbf w^*=\mathbf A\mathbf z^*-c^*\mathbf t$ y $\|\mathbf z^*\|$ acotada. Por la definición de $\mathrm{SelfTargetMSIS}$ —en la que el reto va **embebido** en la instancia vía $H$ sobre la matriz $[\,\mathbf I\,|\,\mathbf A\,|\,\mathbf t\,]$—, el par $(\mu^*,\mathbf z^*)$ **es** una solución, **directamente, sin *forking* ni rebobinado**. **(b)** Dadas dos firmas válidas distintas sobre el mismo $\mu^*$, **salvo colisión de $H$** (evento absorbido en el término estadístico), ambas comparten el mismo $\mathbf w_1$ —pues $c=H(\mu^*,\mathbf w_1)$—; su diferencia produce entonces un vector corto no nulo $\mathbf v$ con $[\,\mathbf A\,|\,\mathbf t\,]\,\mathbf v=\mathbf 0$, i.e. una solución de $\mathrm{MSIS}$. El recuento exacto de las cotas de norma figura en [D+18, Sec. 6]. $\qquad\square$

> **Nota (el argumento de *forking*).** El esquema clásico de *forking* —dos transcripciones con el mismo *commitment* y retos distintos— **no** aparece arriba: gracias a la formulación SelfTargetMSIS, la falsificación es solución directa (Lema 6.2.a). El *forking* solo interviene en la reducción **adicional y no ajustada** de $\mathrm{SelfTargetMSIS}$ a $\mathrm{MSIS}$ en el ROM, y es justo el paso que **no** se traslada al QROM (de ahí que la dureza cuántica de SelfTargetMSIS se trate como supuesto, ver más abajo).

> **Salvedad sobre la tightness en el QROM.** [KLS18] establece el resultado en el QROM para una **variante modificada** ("Dilithium-QROM", que exige $q\equiv 5\pmod 8$ y conlleva claves/firmas mayores) y trata la dureza *cuántica* de SelfTargetMSIS esencialmente como un supuesto. La reducción QROM completa y ajustada para los parámetros desplegados ha sido objeto de trabajo posterior. Se declara esta salvedad para no sobre-afirmar el carácter *tight* de la reducción en el QROM.

### 6.4.2 De MLWE/MSIS a problemas reticulares de peor caso

Los dos primeros términos del Teorema 6.1 descansan sobre la dureza de MLWE y MSIS en el **caso promedio** (instancias aleatorias). El siguiente resultado liga esa dureza promedio a la dureza de problemas reticulares en el **peor caso**, lo que constituye la garantía más fuerte que ofrece la criptografía reticular.

**Teorema 6.2 (Reducciones worst-case → average-case para módulos [LS15]).** *Resolver $\mathrm{MLWE}_{k,\ell,\eta}$ en el caso promedio, con ventaja no despreciable, implica resolver $\gamma$-$\mathrm{Mod\text{-}SIVP}$ (el problema del vector independiente más corto sobre retículos de módulo, vía su variante generalizada $\mathrm{Mod\text{-}GIVP}$) en el **peor caso**, para un factor de aproximación $\gamma$ polinómico. Análogamente, la dureza de $\mathrm{MSIS}$ se basa en $\mathrm{Mod\text{-}SIVP}$ de peor caso.* Estas reducciones generalizan al caso de módulos las reducciones base de Regev [Reg09] para LWE, que conectan LWE con $\mathrm{GapSVP}$ y $\mathrm{SIVP}$ de peor caso.

**Demostración (idea; resultado citado, no re-demostrado).** No re-derivamos estos teoremas —son resultados mayores de la literatura—; exponemos su estructura y los citamos, que es el alcance apropiado. La reducción de Regev [Reg09] es **cuántica e iterativa**: a partir de un oráculo que resuelve LWE en promedio, construye una rutina que genera muestras gaussianas cada vez más estrechas sobre el retículo, hasta resolver $\mathrm{SIVP}/\mathrm{GapSVP}$ de peor caso; el **único** paso cuántico es la preparación de un estado cuántico a partir de una distribución gaussiana sobre el retículo (de ahí que la rama LWE/MLWE sea cuántica). Langlois–Stehlé [LS15] **elevan** esta maquinaria al caso de **módulos** sobre $R_q$, obteniendo $\mathrm{Mod\text{-}SIVP}_\gamma \to \mathrm{MLWE}$ (cuántica) y $\mathrm{Mod\text{-}SIVP}_\gamma \to \mathrm{MSIS}$ (clásica, sin el paso cuántico), con factor $\gamma$ polinómico en la dimensión del módulo. Instanciar para los parámetros de §6.2.3 fija los valores concretos de $\gamma$ y la pérdida de la reducción. $\qquad\square$

> **Nota de precisión (clásico vs. cuántico).** La reducción que sustenta **MLWE** ($\mathrm{Mod\text{-}SIVP}\to\mathrm{MLWE}$) es **cuántica** (hereda el paso cuántico de Regev), mientras que la que sustenta **MSIS** ($\mathrm{Mod\text{-}SIVP}\to\mathrm{MSIS}$) es **clásica**. Es relevante señalarlo porque §6.4.3 construye el argumento de resistencia cuántica precisamente sobre la dureza de estos problemas de peor caso. (Recuérdese también la distinción de §6.2.1: el problema correcto es $\mathrm{SIVP}$ / $\mathrm{Mod\text{-}SIVP}$, no $\mathrm{SVP}$.)

La consecuencia conceptual es contundente: **falsificar una firma Dilithium implicaría resolver, en el peor caso, un problema reticular ($\mathrm{Mod\text{-}SIVP}$) que la comunidad criptográfica conjetura difícil tras décadas de estudio.**

### 6.4.3 Resistencia cuántica: no aplicabilidad del algoritmo de Shor

Resta argumentar por qué $\mathrm{Mod\text{-}SIVP}$ resiste a un adversario cuántico, a diferencia de RSA y ECC.

**Proposición 6.3 (No reducción a un HSP abeliano).** *El algoritmo de Shor [Sho97] resuelve eficientemente el Problema del Subgrupo Oculto (HSP) sobre grupos **abelianos** finitos —del cual la factorización y el logaritmo discreto son casos particulares—. Los problemas reticulares relevantes ($\gamma$-SIVP y, sobre módulos, $\gamma$-$\mathrm{Mod\text{-}SIVP}$) no se conocen como instancias de un HSP abeliano resoluble, por lo que el algoritmo de Shor **no se les aplica**.*

**Argumento.** Recuérdese la definición: una instancia de HSP es una terna $(G, H\le G, f:G\to S)$ donde $f$ es **constante en cada coclase** de $H$ y **distinta entre coclases**; resolver el HSP es hallar $H$. Cuando $G$ es **abeliano**, Shor lo resuelve en tiempo $\mathrm{poly}(\log\lvert G\rvert)$ aplicando la **Transformada Cuántica de Fourier** sobre el grupo dual $\widehat G$ para muestrear el subgrupo ortogonal $H^\perp$ y reconstruir $H$; la factorización ($G=\mathbb Z_N^\times$) y el logaritmo discreto son casos particulares. La obstrucción para los retículos es estructural: el ataque natural los reformula como un HSP sobre el grupo **diédrico** $D_N$ —**no abeliano**—, donde la QFT no factoriza el problema. Tras tres décadas, el mejor algoritmo cuántico conocido para el HSP diédrico es el de **Kuperberg**, de costo **subexponencial** $2^{O(\sqrt{\log N})}$ [Kup05], y ni siquiera se conoce una reducción eficiente de $\gamma$-$\mathrm{Mod\text{-}SIVP}$ a dicho HSP. Por ello, el mejor enfoque cuántico **efectivo** contra los problemas reticulares no pasa por Shor, sino por el **tamizado cuántico (*quantum sieving*)**, de costo $2^{(0.265+o(1))d}$ frente al $2^{(0.292+o(1))d}$ del mejor tamizado clásico [Laa15, BDGL16], con $d$ la dimensión del retículo.

**Conclusión cuantitativa — con una advertencia de precisión.** El *speedup* cuántico conocido es **modesto**: reduce la constante del exponente de $\approx 0.292$ a $\approx 0.265$, de modo que, bajo el modelo *core-SVP*, la seguridad cuántica estimada es
$$\approx \frac{0.265}{0.292}\,\times\ \text{(seguridad clásica)} \ \approx\ 0.91\,\times\ \text{(seguridad clásica)},$$
es decir, **una reducción de apenas $\sim$9 %, no a la mitad**. A título orientativo, las estimaciones *core-SVP* de la especificación de Dilithium son del orden de:

| | Seguridad clásica | Seguridad cuántica (core-SVP) | Categoría NIST |
|---|:---:|:---:|:---:|
| Dilithium2 | $\sim$123 bits | $\sim$112 bits | 2 |
| Dilithium3 | $\sim$182 bits | $\sim$166 bits | 3 |
| Dilithium5 | $\sim$252 bits | $\sim$229 bits | 5 |

> **Reconciliación de dos cifras (importante para la defensa).** La columna "seguridad cuántica = la mitad" que aparece en tablas divulgativas (128→64, 192→96, 256→128) **no** proviene del tamizado (que da $\sim$0,91×), sino de una **heurística conservadora tipo Grover** (speedup cuadrático sobre búsqueda genérica), *pesimista* para esquemas reticulares. Ambas cifras deben presentarse explícitamente: la estimación *core-SVP* ($\sim$0,91×) como la cifra técnica vigente, y la cota tipo Grover (mitad de bits) como límite conservador.

### 6.4.4 Cadena de reducciones (síntesis)

La validación de seguridad se resume en la siguiente cadena, que recorre el arco completo desde el ataque hasta el problema cuánticamente difícil:

$$
\underbrace{\text{Falsificar Dilithium}}_{\text{romper sUF-CMA}}
\ \Longrightarrow\
\underbrace{\text{resolver }\mathrm{MLWE}\ \vee\ \mathrm{SelfTargetMSIS}\ \vee\ \mathrm{MSIS}}_{\text{Teorema 6.1 (3 términos)}}
\ \Longrightarrow\
\underbrace{\gamma\text{-}\mathrm{Mod\text{-}SIVP}\ \text{peor caso}}_{\text{Teorema 6.2}}
\ \overset{\text{Prop. 6.3}}{\Longrightarrow}\
\underbrace{\text{difícil aun cuánticamente}}_{\text{Shor no aplica}}
$$

Cada flecha conlleva supuestos y pérdidas de reducción que, en un análisis concreto de parámetros, determinan los niveles de seguridad de la tabla anterior. La cadena justifica formalmente la afirmación central de NEXUS: **la in-forjabilidad de las transacciones se reduce, en última instancia, a la dureza de peor caso de un problema reticular que resiste a Shor.**

---

## 6.5 Análisis de complejidad computacional

### 6.5.1 La NTT como operación dominante

La operación costosa en $R_q$ es la multiplicación de polinomios. Mediante la **NTT** —una Transformada de Fourier sobre $\mathbb{Z}_q$, posible porque $q\equiv 1\pmod{2n}$ (§6.2.2)— un polinomio se lleva al "dominio NTT" en $O(n\log n)$ operaciones; en ese dominio la multiplicación es **puntual** ($O(n)$), y la transformada inversa cuesta de nuevo $O(n\log n)$. Así, una multiplicación en $R_q$ cuesta
$$T_{\text{mult}}(n) = O(n\log n)\ \text{operaciones en }\mathbb{Z}_q,$$
frente al $O(n^2)$ del producto escolar. Con $n=256$, la ganancia es decisiva y explica el rendimiento del esquema.

### 6.5.2 Complejidad de KeyGen, Sign y Verify

Midiendo el costo en multiplicaciones de anillo (cada una $O(n\log n)$):

**Proposición 6.4 (Costos asintóticos).** *Para Dilithium con dimensiones $(k,\ell)$ y $n$ fijo:*
- $\mathsf{KeyGen}$*: el cálculo de $\mathbf{t}=\mathbf{A}\mathbf{s}_1+\mathbf{s}_2$ requiere $k\ell$ multiplicaciones de anillo, luego $O(k\ell\,n\log n)$.*
- $\mathsf{Sign}$ *(esperado): cada iteración del bucle de rechazo está dominada por el producto matriz–vector $\mathbf{A}\mathbf{y}$ ($k\ell$ multiplicaciones), luego $O(k\ell\,n\log n)$ por iteración; el número esperado de iteraciones es una **constante** por conjunto de parámetros, luego el costo esperado es $O(k\ell\,n\log n)$.*
- $\mathsf{Verify}$*: recomputar $\mathbf{A}\mathbf{z}-c\,\mathbf{t}$ cuesta $O(k\ell\,n\log n)$.*

*Demostración (recuento).* En $\mathsf{KeyGen}$, $\mathbf{A}\in R_q^{k\times\ell}$ y $\mathbf{s}_1\in R_q^\ell$, de modo que $\mathbf{A}\mathbf{s}_1$ son $k\ell$ productos de anillo; la suma de $\mathbf{s}_2$ es $O(kn)$, de orden inferior, y la verificación es de nuevo un producto matriz–vector $O(k\ell\,n\log n)$.

Para $\mathsf{Sign}$ resta acotar el número de iteraciones del bucle de rechazo. Sea $p_{\mathrm{acc}}$ la probabilidad de que una iteración supere ambas comprobaciones de rechazo (sobre $\|\mathbf z\|_\infty$ y la parte baja). Como cada iteración usa aleatoriedad **fresca e independiente** ($\mathbf y$ nuevo), el número de iteraciones $N$ hasta la primera aceptación sigue una **distribución geométrica** de parámetro $p_{\mathrm{acc}}$, cuyo valor esperado es
$$\mathbb{E}[N]=\frac{1}{p_{\mathrm{acc}}}.$$
Los parámetros del esquema $(\gamma_1,\beta,\dots)$ se eligen por diseño de modo que $p_{\mathrm{acc}}$ esté **acotada inferiormente por una constante positiva independiente de $n$**; en consecuencia $\mathbb{E}[N]=O(1)$. Concretamente, $\mathbb{E}[N]\approx 4.25$ para Dilithium2, $\approx 5.1$ para Dilithium3 y $\approx 3.85$ para Dilithium5 [D+18]. Como cada iteración cuesta $O(k\ell\,n\log n)$ (el producto $\mathbf{A}\mathbf{y}$ domina; $c\,\mathbf{s}_1$ son $\ell$ productos) y multiplicar por la constante $\mathbb{E}[N]$ preserva el orden, el costo **esperado** de $\mathsf{Sign}$ es $O(k\ell\,n\log n)$. $\qquad\blacksquare$

**Cota más fina (implementación optimizada).** Manteniendo $\mathbf{A}$ y los vectores en el **dominio NTT**, las $k\ell$ multiplicaciones puntuales cuestan $O(k\ell\,n)$ y las transformadas se incurren solo $O(k+\ell)$ veces, dando
$$O\big((k+\ell)\,n\log n + k\ell\,n\big),$$
que es ajustada. El $O(k\ell\,n\log n)$ del enunciado es una **cota superior** válida bajo la convención «cada multiplicación de anillo $= O(n\log n)$». Como $n=256$ es fijo, en la práctica el costo escala con $k\ell$.

**Tamaños.** La clave pública $pk=(\rho,\mathbf{t}_1)$ está dominada por $\mathbf{t}_1\in R_q^k$ ($k\cdot n$ coeficientes de $O(\log q)$ bits; $\mathbf A$ se regenera de la semilla $\rho$ de 256 bits y no se almacena), luego $|pk|=O(k\,n\log q)$. La firma $\sigma=(\mathbf{z},\mathbf{h},c)$ está dominada por $\mathbf{z}\in R_q^\ell$, luego $|\sigma|=O((k+\ell)\,n\log q)$. Ambas cotas concuerdan con los tamaños tabulados (§6.2.3).

**Tabla 6.1 — Complejidad y tamaños.**

| | $\mathsf{KeyGen}$ | $\mathsf{Sign}$ (esp.) | $\mathsf{Verify}$ | $\lvert pk\rvert$ | $\lvert\sigma\rvert$ |
|---|:---:|:---:|:---:|:---:|:---:|
| Asintótico | $O(k\ell\,n\log n)$ | $O(k\ell\,n\log n)$ | $O(k\ell\,n\log n)$ | $O(k\,n\log q)$ | $O((k{+}\ell)\,n\log q)$ |
| Dilithium2 | — | $\approx 4.25$ iter. | — | 1312 B | 2420 B |
| Dilithium3 | — | $\approx 5.1$ iter. | — | 1952 B | 3309 B |
| Dilithium5 | — | $\approx 3.85$ iter. | — | 2592 B | 4627 B |

### 6.5.3 Overhead del esquema dual

El análisis cuantificado completo del *overhead* y de su amortización por la arquitectura dual-chain se desarrolla en el **Capítulo 3** (documento `Analisis-Overhead-PQC-DualChain`). Aquí se consignan los resultados pertinentes a la **verificación de firmas**, que es la magnitud que el análisis de complejidad acota:

- **Costo de datos** (cuello de botella real): una firma Dilithium3 (3309 B) es $\approx 52\times$ una firma ECDSA (64 B). El costo de **CPU** de verificación, en cambio, es del **mismo orden** que ECDSA (§6.5.4): el penalizador PQC es de **tamaño**, no de cómputo.
- **Verificación por bloque** de $m$ transacciones en una cadena única: $O(m\cdot k\ell\,n\log n)$.
- **Amortización dual-chain**: con un rollup de validez, la L1 verifica **una** prueba (independiente de $m$), reduciendo el cómputo de verificación on-chain a $O(t_\pi/m)\to 0$ por transacción, y —crucialmente— eliminando las firmas de la L1, de modo que el costo de datos amortizado por transacción tiende a la diferencia de estado clásica (Cap. 3). El sistema de pruebas debe ser **post-cuántico (STARK)** para mantener la coherencia (Cap. 3, §3.5).

### 6.5.4 Comparación con criptografía clásica

| | RSA-2048 | ECDSA P-256 | **Dilithium3** |
|---|:---:|:---:|:---:|
| Tamaño de firma | 256 B | 64 B | **3309 B** |
| Costo de verificación (CPU, **medido en el mismo banco**, §6.6.2) | 92,4 µs | 144,8 µs | **77,6 µs** |
| Resistencia cuántica | **Rota** (Shor, tiempo poli.) | **Rota** (Shor, tiempo poli.) | **Sin ataque cuántico eficiente conocido** |

La comparación —**medida sobre el mismo banco de pruebas y el mismo hardware** (§6.6.2)— subraya el argumento central de la tesis: Dilithium **no cede nada** frente a los esquemas clásicos en costo de verificación (es, de hecho, el más rápido de los tres) y **los supera** en lo único que importa frente a la amenaza cuántica —la resistencia—, a cambio de un sobrecosto de **tamaño** que la arquitectura dual amortiza.

---

## 6.6 Validación empírica complementaria

El análisis asintótico de §6.5 fija la **forma** del costo ($O(k\ell\,n\log n)$) pero oculta las **constantes**. La validación empírica las acota y confirma la factibilidad práctica; **complementa, no sustituye**, la validación formal.

**Metodología.** Banco de pruebas con el *harness* Criterion: `nexus-crypto/benches/dilithium_bench.rs` (ML-DSA) y `nexus-crypto/benches/classical_baseline.rs` (líneas base clásicas ECDSA/RSA, §6.6.2); para el verificador STARK, el *harness* dedicado `nexus-zk/examples/stark_demo.rs` (§6.6.3). Para cada nivel (Dilithium2/3/5) y operación ($\mathsf{KeyGen}$, $\mathsf{Sign}$, $\mathsf{Verify}$): 100 muestras con calentamiento, reportando la **mediana** (robusta a valores atípicos). Todas las cargas son de **un solo hilo**; las diferencias entre máquinas reflejan IPC y frecuencia, no paralelismo.

Los resultados se reportan sobre **dos perfiles de hardware**, lo que permite separar lo que depende de la máquina (las constantes) de lo que no (la forma del escalado):

| Perfil | CPU | SO / perfil de compilación | Medición |
|---|---|---|:---:|
| **H1** | Intel Kaby Lake (Familia 6, Modelo 142), 4 hilos lógicos — portátil de 2017 | Windows 11; `release` (opt-level 3, LTO fino) | 2026-07 |
| **H2** | Intel Core Ultra 9 275HX (Arrow Lake-HX), 24 núcleos — portátil de 2026 | Windows 11; rustc 1.97.1; mismo perfil `release` | 2026-08-07 |

*Backend:* crate `fips204` (ML-DSA **puro Rust**, constant-time) en ambos perfiles.

**Métricas e hipótesis a contrastar.**
- Tiempos por operación y verificaciones por segundo, por nivel.
- **Contraste teoría–práctica:** verificar que el tiempo escala $\sim$linealmente con $k\ell$ a $n$ fijo (consistente con la Proposición 6.4) y que la **forma** del escalado se preserva entre perfiles de hardware.
- **Comparativa clásica en el mismo banco:** posición de Dilithium3 frente a ECDSA P-256 y RSA-2048/3072 en las tres operaciones (§6.6.2).
- **Escalado del verificador STARK** frente al tamaño de la traza probada (§6.6.3), insumo del argumento de amortización dual-chain (§6.5.3, Cap. 3).

### 6.6.1 ML-DSA / Dilithium en ambos perfiles

**Tabla 6.2 — Tiempos medidos de ML-DSA / Dilithium (perfil H1, medianas; corrida del 2026-07-31 con rustc 1.97.1 — la publicada en el README del repositorio `nexus`).**

| Operación | Dilithium2 | Dilithium3 | Dilithium5 |
|---|---:|---:|---:|
| Generación de claves | 234 µs | 413 µs | 564 µs |
| Firma | 497 µs | 790 µs | 979 µs |
| **Verificación** | **141 µs** | **232 µs** | **390 µs** |

**Tabla 6.3 — Tiempos medidos de ML-DSA / Dilithium (perfil H2, medianas).**

| Operación | Dilithium2 | Dilithium3 | Dilithium5 |
|---|---:|---:|---:|
| Generación de claves | 92,5 µs | 142,1 µs | 198,1 µs |
| Firma | 183,0 µs | 290,0 µs | 343,3 µs |
| **Verificación** | **48,8 µs** | **77,6 µs** | **129,2 µs** |

**Contraste teoría–práctica.**
1. **El cuello de botella no es el cómputo.** La verificación tarda **decenas a cientos de microsegundos** (48,8–390 µs según perfil y nivel), un costo despreciable frente al *overhead de datos* (~52× en tamaño de firma). En H2, **un solo núcleo sostiene $\approx$12.900 verificaciones/s** de Dilithium3. Esto confirma empíricamente la tesis central (§6.5.3, Cap. 3): el penalizador post-cuántico es de tamaño, no de CPU. *(Robustez al* backend*: la verificación con `fips204` (Rust puro) es del **mismo orden** que la de implementaciones en C optimizado —p. ej. pqcrypto, ~270 µs en D3 sobre hardware clase H1—, reforzando que el cuello no es de CPU ni de backend.)*
2. **Escalado consistente con $O(k\ell\,n\log n)$ e independiente del hardware.** Las tres operaciones crecen de forma **monótona** con el nivel, en línea con el producto $k\ell$ (16, 30, 56 para D2/D3/D5), y —el punto que los dos perfiles permiten aislar— **las razones entre niveles se preservan al cambiar de máquina**: Verify D5/D2 es ×2,77 en H1 y ×2,65 en H2; KeyGen D5/D2, ×2,41 y ×2,14. El escalado empírico es **sublineal** respecto a $k\ell$ (frente a las razones ×1,875 y ×3,5 de $k\ell$), por términos de orden inferior y constantes de implementación (cf. la cota afinada $O((k+\ell)\,n\log n + k\ell\,n)$). Es exactamente lo que predice la Proposición 6.4: **el hardware cambia las constantes (H2 resulta 2,5–3,0× más rápido que H1), no la forma del costo.**
3. **La firma es la operación más costosa.** La domina el bucle de *rejection sampling* (§6.5.2), cuyo número de iteraciones es esperado-constante pero **variable**; es un costo **esperado**, no de peor caso. La mediana mitiga esa variabilidad.

**Throughput de verificación multinúcleo (H2).** La métrica de capacidad agregada se midió con el *harness* `nexus-crypto/examples/throughput_tps.rs` (lote de 4.096 transacciones firmadas con claves distintas; verificación Dilithium3 con clave pública; ~2 s por punto): **12.485 verif/s con 1 hilo, 49.843 con 4 y 199.218 con 24** (escalado ×16,0 sobre 24 núcleos heterogéneos: el costo por verificación y por hilo sube de 80 a 120 µs al incorporar los núcleos E). Es decir, un único equipo de consumo sostiene del orden de **2×10⁵ verificaciones por segundo**, dos órdenes de magnitud por encima del throughput transaccional que el análisis de overhead (Cap. 3) toma como referencia para una L2 bancaria — la verificación PQC no es el recurso escaso del sistema.

### 6.6.2 Comparativa medida con criptografía clásica

Las cifras de §6.5.4 se contrastan aquí **en el mismo banco, el mismo hardware (H2) y el mismo mensaje**, con el *harness* `classical_baseline.rs`. Los backends clásicos son los crates `p256` y `rsa` (RustCrypto) —Rust puro, como `fips204`, de modo que la comparación es homogénea en madurez de implementación—. Para RSA-2048, $\mathsf{KeyGen}$ se midió con 10 muestras (su costo, cinco órdenes de magnitud mayor, acotaría el banco); la generación RSA-3072 (segundos por clave) no se midió por no estar en ninguna ruta caliente.

**Tabla 6.4 — Dilithium3 frente a los esquemas clásicos incumbentes (H2, medianas).**

| Esquema | $\mathsf{KeyGen}$ | $\mathsf{Sign}$ | $\mathsf{Verify}$ | $\lvert\sigma\rvert$ |
|---|---:|---:|---:|---:|
| ECDSA P-256 | 70,0 µs | 87,5 µs | 144,8 µs | 64 B |
| RSA-2048 | 106,6 ms | 740,5 µs | 92,4 µs | 256 B |
| RSA-3072 | no medido ($\gg$1 s) | 2,47 ms | 199,1 µs | 384 B |
| **Dilithium3 (ML-DSA-65)** | **142,1 µs** | **290,0 µs** | **77,6 µs** | **3309 B** |

Cuatro lecturas:

1. **En verificación, Dilithium3 es el esquema más rápido de la tabla:** 1,9× más rápido que ECDSA P-256, 1,2× que RSA-2048 y 2,6× que RSA-3072. La verificación es precisamente la operación caliente de una blockchain (cada firma se genera una vez y se verifica muchas veces, por el sequencer y por cada validador); el esquema post-cuántico no solo no penaliza esa ruta: la mejora. *(La corrida H1 de la misma comparativa —README del repo, 2026-07-31— muestra el mismo cuadro con una salvedad: allí RSA-2048 verificaba marginalmente más rápido que Dilithium3, 218 vs. 232 µs, con ECDSA última a 301 µs.)*
2. **En firma**, Dilithium3 es 3,3× más lento que ECDSA pero 2,6× y 8,5× más rápido que RSA-2048 y RSA-3072 — los incumbentes dominantes de la infraestructura bancaria (PKI, HSM).
3. **En generación de claves**, los 142 µs de Dilithium3 (vs. 106,6 ms de RSA-2048: **750× más rápido**) son el ancla empírica de la política de rotación agresiva del Cap. 5: generar un par de claves *por firma* es viable con retículos e impensable con RSA.
4. **El único eje donde Dilithium pierde es el tamaño** (3309 B, ~52× ECDSA), lo que cierra el círculo con §6.5.3: el sobrecosto post-cuántico es de datos, no de cómputo, y amortizarlo es tarea de la arquitectura (Cap. 3).

> *Nota de equidad:* los cuatro esquemas se midieron con backends Rust puro sin ensamblador ni SIMD; implementaciones en C optimizado desplazarían las constantes de todos ellos sin alterar los órdenes de magnitud (decenas–centenas de µs) en que se apoya el argumento.

### 6.6.3 Verificador STARK: confirmación del escalado polilogarítmico

El argumento de amortización dual-chain (§6.5.3; Cap. 3, §3.5) depende de una propiedad asintótica del sistema de pruebas: que el costo del **verificador** crezca polilogarítmicamente con el tamaño del cómputo probado. Para un STARK basado en FRI, la teoría predice tamaño de prueba y tiempo de verificación $O(\lambda\,\log^2 n)$ (consultas × capas de FRI × caminos de Merkle de longitud $\log$) y costo del *prover* $\tilde O(n)$. Esta subsección lo contrasta empíricamente con el PoC propio (§6.7): blowup 8, 40 consultas, desafíos en $F_{p^2}$, *grinding* $2^{20}$ (~100 bits de *soundness*), sobre H2.

**Tabla 6.5 — STARK PoC: tamaño y tiempos frente al tamaño de la traza (H2).**

| Traza (pasos) | Prueba | Generación | Verificación |
|---:|---:|---:|---:|
| $2^{4}=16$ | 129,0 KB | 4,1 ms | 1,25 ms |
| $2^{6}=64$ | 190,3 KB | 826,5 ms | 1,78 ms |
| $2^{8}=256$ | 261,6 KB | 46,9 ms | 2,31 ms |
| $2^{10}=1.024$ | 342,9 KB | 131,9 ms | 2,93 ms |
| $2^{12}=4.096$ | 434,2 KB | 290,6 ms | 3,60 ms |
| $2^{14}=16.384$ | 535,5 KB | 1,10 s | 4,38 ms |
| $2^{16}=65.536$ | 646,9 KB | 3,13 s | 5,43 ms |
| $2^{18}=262.144$ | 768,2 KB | 10,25 s | 7,74 ms |

*(KB = 1024 B. Los tamaños de prueba son deterministas: byte a byte idénticos entre máquinas.)*

**Contraste teoría–práctica.**
1. **Sucinto en el sentido fuerte.** Al multiplicar el cómputo probado por **16.384** (de $2^4$ a $2^{18}$ pasos), la prueba crece solo **×6,0** y la verificación **×6,2**. Si la relación fuera lineal, verificar a $2^{18}$ pasos costaría ~20 s; cuesta **7,74 ms**.
2. **La firma del $\log^2$.** Los incrementos de tamaño por cada cuadruplicación de la traza forman una progresión aritmética casi exacta (+61,3; +71,3; +81,3; +91,3; +101,3; +111,3; +121,3 KB — **+10 KB más en cada salto**): es la derivada discreta de un polinomio **cuadrático en $\log_2 n$**, de modo que el $O(\log^2 n)$ predicho no es solo una cota, es la **forma observada** de la curva. La verificación exhibe el mismo patrón (+0,53 → +2,31 ms).
3. **Asimetría prover/verificador.** La generación crece de forma cuasi-lineal hasta 10,25 s en $2^{18}$. Esa asimetría es el modelo económico del rollup de validez: **un** prover paga segundos una vez por lote; **cada** verificador de la L1 paga milisegundos, para siempre.
4. **Nota metodológica (*grinding*).** La búsqueda de nonce de $2^{20}$ añade a la generación un costo determinista **dependiente del enunciado**, que explica el punto no monótono de $2^6$ (826 ms, reproducible entre corridas); su peso relativo se desvanece en trazas grandes.
5. **Robustez entre perfiles.** En H1 (julio de 2026, rango $2^4$–$2^{12}$) la verificación midió 4,5→11,4 ms: ~3,5× más lenta que H2 con **la misma forma de curva** y tamaños de prueba idénticos.

**El *trade-off*, declarado.** Una prueba de 768 KB es ~232× una firma Dilithium3; pero se paga **una vez por lote**: a $2^{18}$ pasos equivale a ~3 B por paso probado, y sus 7,74 ms de verificación sustituyen la re-ejecución del lote completo. La cadencia del prover (~10 s en un hilo a $2^{18}$) fija la latencia mínima de bacheo del PoC; su paralelización es trabajo futuro (Cap. 7).

> Las cifras absolutas dependen del perfil (H1 es un portátil de 2017; H2, uno de 2026) y del *backend* (Rust puro, sin SIMD); lo relevante para la tesis es el **orden de magnitud** (verificación de firmas en decenas–centenas de µs; verificación de pruebas en unidades de ms) y la **forma del escalado**, que se preserva entre máquinas.

---

## 6.7 Limitaciones y alcance de la validación

Se declaran explícitamente las fronteras de esta validación formal:

- **Modelo de caja negra / QROM.** Se valida la in-forjabilidad del esquema, **no** su seguridad de implementación: quedan fuera los **canales laterales** (temporización, consumo) y los **ataques por fallos**, relevantes en hardware real.
- **Seguridad del primitivo, no del sistema completo.** El Teorema 6.1 garantiza in-falsificabilidad **a nivel de transacción**. La integridad del **libro mayor** depende además de la seguridad del **consenso** (que en NEXUS es diseño de referencia, no implementación operativa); por tanto, la afirmación de seguridad del sistema es condicional: *in-falsificabilidad de transacciones bajo el supuesto de consenso honesto-mayoritario*.
- **Componentes parcialmente implementados.** El sistema de pruebas de validez (Nitro Verifier) **sí** cuenta con un prototipo de referencia post-cuántico: un STARK hash-based propio (Merkle/SHA3 + Fiat–Shamir + FRI, sin emparejamientos) que verifica una transición de estado con coste de verificación **sucinto** (Cap. 3, §3.5). Sus desafíos se extraen del campo de extensión $F_{p^2}$ y se añade grinding, alcanzando un **presupuesto de soundness de ~100 bits** bajo *proximity gaps* (Cap. 3, §3.5). Lo que queda como trabajo futuro es su *aritmetización completa* (el AIR del PoC es ilustrativo) y la incorporación de **DEEP/out-of-domain** (que daría 100 bits sin invocar la conjetura de *proximity gaps*); su validación es **empírica y por pruebas de software** —incluida una batería adversarial—, no una reducción formal como la de §6.4. El extractor difuso (eliminado del alcance) y la confidencialidad post-cuántica (que requeriría un KEM, p. ej. ML-KEM) sí quedan fuera y se enuncian como trabajo futuro.
- **Tensión de diseño (apuntada para el Cap. 3).** Probar la verificación de Dilithium dentro de un STARK es costoso; las firmas *hash-based* son más STARK-friendly. La elección de Dilithium optimiza la verificación directa a costa de fricción con la agregación probada; se discute como decisión consciente en el Cap. 3.

---

## 6.8 Conclusiones del capítulo

Este capítulo ha validado formalmente el núcleo de seguridad de NEXUS:

1. **Prueba de dureza (Obj. 4.1).** La in-forjabilidad fuerte de Dilithium se reduce, mediante una cota de **tres términos** (MLWE + SelfTargetMSIS + MSIS) en el QROM, a la dureza promedio de MLWE/MSIS, y de ahí —vía reducciones de peor caso— a $\mathrm{Mod\text{-}SIVP}$, un problema reticular que **ningún algoritmo cuántico conocido, incluido el de Shor, resuelve eficientemente** (cadena de §6.4.4).
2. **Análisis de complejidad (Obj. 4.2).** Las operaciones del esquema tienen costo $O(k\ell\,n\log n)$ (dominado por la NTT, $O(n\log n)$ por multiplicación), con $\mathsf{Sign}$ esperado constante en iteraciones; el sobrecosto del esquema es de **tamaño**, no de cómputo, y se amortiza en la arquitectura dual (Cap. 3).
3. **Validación empírica (Obj. 4.2).** Los *benchmarks* sobre **dos perfiles de hardware** acotan las constantes ocultas y confirman las tres predicciones del análisis: la verificación de Dilithium3 cuesta **menos** que la de ECDSA y RSA medidas en el mismo banco (77,6 µs vs. 144,8 y 92,4 µs, §6.6.2); la forma del escalado con $k\ell$ se preserva entre máquinas (§6.6.1); y el verificador STARK crece polilogarítmicamente a lo largo de más de cuatro órdenes de magnitud de traza — ×16.384 de cómputo ⇒ ×6,2 de verificación (§6.6.3).

Con ello, el **Objetivo 4 queda atendido en su componente formal**, cerrando el arco de la tesis: *la amenaza cuántica a las firmas de banca se neutraliza con Dilithium, cuya seguridad se reduce a un problema reticular resistente a Shor y cuyo costo —de tamaño— se amortiza mediante la arquitectura dual-chain post-cuántica.*

---

## Referencias del capítulo

> *Índice local del capítulo; la **Bibliografía** consolidada al final del documento reúne todas las obras bajo clave única.*

- **[D+18]** Ducas, Kiltz, Lepoint, Lyubashevsky, Schwabe, Seiler, Stehlé. *CRYSTALS-Dilithium: A Lattice-Based Digital Signature Scheme.* IACR ToCHES 2018(1).
- **[KLS18]** Kiltz, Lyubashevsky, Schaffner. *A Concrete Treatment of Fiat-Shamir Signatures in the Quantum Random-Oracle Model.* EUROCRYPT 2018.
- **[Lyu09]** Lyubashevsky. *Fiat-Shamir with Aborts: Applications to Lattice and Factoring-Based Signatures.* ASIACRYPT 2009. *(origen de la técnica rejection-sampling/aborts)*
- **[Lyu12]** Lyubashevsky. *Lattice Signatures without Trapdoors.* EUROCRYPT 2012. *(esquema del que Dilithium desciende)*
- **[LS15]** Langlois, Stehlé. *Worst-Case to Average-Case Reductions for Module Lattices.* Designs, Codes and Cryptography 75(3), 2015.
- **[Reg09]** Regev. *On Lattices, Learning with Errors, Random Linear Codes, and Cryptography.* J. ACM 56(6), 2009.
- **[BDF+11]** Boneh, Dagdelen, Fischlin, Lehmann, Schaffner, Zhandry. *Random Oracles in a Quantum World.* ASIACRYPT 2011.
- **[Sho97]** Shor. *Polynomial-Time Algorithms for Prime Factorization and Discrete Logarithms on a Quantum Computer.* SIAM J. Comput. 26(5), 1997.
- **[Kup05]** Kuperberg. *A Subexponential-Time Quantum Algorithm for the Dihedral Hidden Subgroup Problem.* SIAM J. Comput. 35(1), 2005. *(barrera del HSP diédrico)*
- **[Laa15]** Laarhoven. *Search Problems in Cryptography* (tamizado cuántico para SVP). 2015.
- **[BDGL16]** Becker, Ducas, Gama, Laarhoven. *New Directions in Nearest Neighbor Searching with Applications to Lattice Sieving.* SODA 2016. *(constante clásica 0.292)*
- **[Pei16]** Peikert. *A Decade of Lattice Cryptography.* 2016.
- **[NIST24]** NIST. *FIPS 204: Module-Lattice-Based Digital Signature Standard (ML-DSA).* 2024.
