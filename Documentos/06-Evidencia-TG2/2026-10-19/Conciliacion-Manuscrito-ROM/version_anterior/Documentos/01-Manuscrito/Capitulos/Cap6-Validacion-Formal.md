# Capítulo 6 — Validación Formal de la Seguridad

*Desarrollo del Objetivo 4 · versión redactada del esqueleto `Cap4-Validacion-Formal-Esqueleto.md`*

> **Mapa.** Este capítulo corresponde al **Objetivo 4** de la propuesta y al **Capítulo 6** de la estructura del Plan Maestro. Reúne los **fundamentos y límites de seguridad post-cuántica** (§6.4), un **análisis de complejidad computacional** (§6.5) y la **validación empírica** (§6.6). La derivación AIR/FRI propuesta y sus hipótesis se distinguen de una garantía del ejecutable (§6.7).

---

## 6.1 Introducción y alcance

La inforjabilidad de las firmas que autorizan transacciones es uno de los requisitos de seguridad de NEXUS. Su aplicación también depende del hash externo, la codificación, la custodia y las políticas de autorización. Este capítulo examina los fundamentos de inforjabilidad de ML-DSA frente a adversarios clásicos y cuánticos, distingue los resultados citados de sus condiciones de aplicación y caracteriza su costo computacional.

Por **validación formal** entendemos un procedimiento de cuatro pasos, que estructura todo el capítulo:

1. **Fijar un modelo de seguridad** preciso: qué es un adversario, qué significa "romper" el esquema y bajo qué capacidades (§6.3).
2. **Revisar las reducciones publicadas** y sus condiciones de correspondencia con los perfiles implementados (§6.4.1–6.4.2).
3. **Examinar los supuestos y ataques cuánticos conocidos**, distinguiendo la no aplicabilidad directa de Shor de una demostración general de dureza (§6.4.3).
4. **Acotar el costo computacional** de las operaciones del esquema mediante notación asintótica, y validarlo empíricamente (§6.5–6.6).

**Alcance.** Se revisan fundamentos de **inforjabilidad** en el modelo de caja negra y condiciones pendientes de aplicación a la firma implementada. No se acredita una garantía concreta de todo el sistema. Quedan fuera del alcance los canales laterales y ataques por fallos, la seguridad del consenso, la confidencialidad vía KEM y el conocimiento cero no demostrado del PoC (§6.7).

**Aclaración metodológica.** Se enuncian los teoremas fundacionales y sus condiciones sin volver a demostrarlos. El aporte identifica pasos para aplicarlos a NEXUS y particulariza el análisis de complejidad y de *overhead* a la arquitectura dual. La revisión de §6.4 explicita las correspondencias pendientes; la suficiencia académica corresponde al dictamen del director y los evaluadores.

---

## 6.2 Preliminares matemáticos

### 6.2.1 Retículos y problemas reticulares

**Definición 6.1 (Retículo).** Dados $m$ vectores linealmente independientes $\mathbf{b}_1,\dots,\mathbf{b}_m \in \mathbb{R}^d$, el *retículo* que generan es el conjunto de sus combinaciones enteras:

$$
\Lambda = \mathcal{L}(\mathbf{B}) = \Big\{ \textstyle\sum_{i=1}^{m} z_i\,\mathbf{b}_i : z_i \in \mathbb{Z} \Big\}.
$$

La matriz $\mathbf{B}=[\mathbf{b}_1\,|\cdots|\,\mathbf{b}_m]$ es una *base*. Se denota $\lambda_1(\Lambda)$ la longitud (euclídea) del vector no nulo más corto del retículo.

Sobre los retículos se definen los problemas computacionales cuya dureza fundamenta la criptografía post-cuántica. Para un factor de aproximación $\gamma \ge 1$:

**Definición 6.2 (Problemas reticulares aproximados).**

- *$\gamma$-SVP (Shortest Vector Problem):* hallar $\mathbf{v}\in\Lambda\setminus\{\mathbf 0\}$ con $\|\mathbf v\| \le \gamma\,\lambda_1(\Lambda)$.
- *$\gamma$-SIVP (Shortest Independent Vectors Problem):* hallar $n$ vectores **linealmente independientes** de $\Lambda$, todos de longitud $\le \gamma\,\lambda_n(\Lambda)$.
- *$\gamma$-GapSVP:* problema de decisión asociado a $\gamma$-SVP.

Conviene subrayar una distinción que será relevante en §6.4.2: **SVP pide un único vector corto, mientras que SIVP pide $n$ vectores cortos independientes**; son problemas distintos, y el que aparece en las reducciones de Dilithium es **SIVP** (en su versión sobre módulos). Para factores $\gamma$ polinómicos en la dimensión, $\gamma$-SVP y $\gamma$-SIVP se conjeturan **difíciles tanto clásica como cuánticamente** [Pei16], y constituyen el cimiento de seguridad de toda la familia reticular.

### 6.2.2 Anillos ciclotómicos y módulos

Dilithium no opera sobre retículos generales sino sobre **retículos de módulo**, lo que reduce drásticamente el tamaño de las claves. Sea $n=256$ (una potencia de dos) y $q = 8\,380\,417 = 2^{23}-2^{13}+1$, un número **primo**. Se define el anillo de polinomios y su versión modular:

$$
R = \mathbb{Z}[X]/(X^{n}+1), \qquad R_q = \mathbb{Z}_q[X]/(X^{n}+1).
$$

Los elementos de $R_q$ son polinomios de grado $<n$ con coeficientes en $\mathbb{Z}_q$. La elección de $q$ no es arbitraria: satisface

$$
q \equiv 1 \pmod{2n}, \qquad\text{en efecto}\quad 8\,380\,417 = 512\cdot 16\,368 + 1,\ \text{con } 2n=512,
$$

de modo que $\mathbb{Z}_q$ contiene una raíz $2n$-ésima primitiva de la unidad. Esta propiedad habilita la **Transformada Teórica de Números (NTT)**, que permite multiplicar en $R_q$ en tiempo $O(n\log n)$ (§6.5.1) y es la razón de la eficiencia del esquema.

Un **módulo** de rango $\ell$ sobre $R_q$ es $R_q^{\ell}$; las claves de Dilithium viven en módulos $R_q^{k}$, $R_q^{\ell}$ y en matrices $\mathbf{A}\in R_q^{k\times\ell}$.

**Normas.** Para $w=\sum_i w_i X^i \in R_q$ con coeficientes representados de forma centrada en $(-q/2, q/2]$, se definen $\|w\|_\infty = \max_i |w_i|$ y $\|w\|_2 = (\sum_i w_i^2)^{1/2}$, y se extienden coeficiente a coeficiente a vectores de $R_q^k$. El conjunto de "polinomios pequeños" acotados por $\eta$ es $S_\eta = \{w\in R : \|w\|_\infty \le \eta\}$.

### 6.2.3 Module-LWE, Module-SIS y SelfTargetMSIS

**Definición 6.3 (Module-LWE decisional, $\mathrm{MLWE}_{k,\ell,\eta}$).** Sean $\mathbf{s}\in S_\eta^{\ell}$ (secreto) y $\mathbf{e}\in S_\eta^{k}$ (error) muestreados uniforme e independientemente en esos conjuntos, y $\mathbf{A}\xleftarrow{\$} R_q^{k\times\ell}$ uniforme. El problema pide distinguir, con ventaja no despreciable, la distribución

$$
\big(\mathbf{A},\ \mathbf{A}\mathbf{s}+\mathbf{e}\big) \qquad\text{de}\qquad \big(\mathbf{A},\ \mathbf{u}\big),\quad \mathbf{u}\xleftarrow{\$} R_q^{k}.
$$

La versión de **búsqueda** pide recuperar $\mathbf{s}$ a partir de $(\mathbf{A}, \mathbf{A}\mathbf{s}+\mathbf{e})$.

**Definición 6.4 (Module-SIS, $\mathrm{MSIS}_{k,\ell,\beta}$).** Dada $\mathbf{A}\xleftarrow{\$} R_q^{k\times\ell}$ y una cota $\beta$, hallar un vector $\mathbf{z}\in R_q^{\ell}\setminus\{\mathbf 0\}$ tal que

$$
\mathbf{A}\mathbf{z} = \mathbf{0} \pmod q \qquad\text{y}\qquad \|\mathbf{z}\| \le \beta.
$$

**Definición 6.5 (SelfTargetMSIS).** En la convención de [JMW24, Definición 3], dados $\mathbf A\in R_q^{m\times r}$ uniforme y un oráculo $H$ con salida en el espacio de retos, se busca $(\mathbf y,\mu)$ con $\mathbf y\in R_q^{m+r}$ corto y $H([\mathbf I_m\mid\mathbf A]\mathbf y\parallel\mu)=y_{m+r}$, donde el último componente es el reto. La norma, dimensiones y distribución deben fijarse en cada aplicación. El vínculo con una falsificación requiere los cambios de juego de §6.4.1.

**Parámetros de NEXUS.** La siguiente tabla fija los conjuntos de parámetros, conforme a **FIPS 204 / ML-DSA** [NIST24] (la parametrización que implementa el prototipo mediante el crate `fips204`):

**Tabla 6.1 — Preliminares matemáticos.**

| Parámetro | ML-DSA-44 | ML-DSA-65 | ML-DSA-87 |
|---|:---:|:---:|:---:|
| $(k,\ell)$ — dimensiones de $\mathbf A$ | $(4,4)$ | $(6,5)$ | $(8,7)$ |
| $\eta$ — rango del secreto | $2$ | $4$ | $2$ |
| $n$ | 256 | 256 | 256 |
| $q$ | 8.380.417 | 8.380.417 | 8.380.417 |
| $d$ | 13 | 13 | 13 |
| $\tau$ | 39 | 49 | 60 |
| $\beta=\tau\eta$ | 78 | 196 | 120 |
| $\gamma_1$ | 131072 | 524288 | 524288 |
| $\gamma_2$ | 95232 | 261888 | 261888 |
| Categoría de seguridad NIST | 2 | 3 | 5 |
| Clave pública (bytes) | 1312 | 1952 | 2592 |
| Firma (bytes) | 2420 | 3309 | 4627 |

> **Nota.** Los tamaños mostrados son los de **FIPS 204 / ML-DSA** (lo que implementa el prototipo vía el crate `fips204`, puro Rust). Las claves secretas son 2560/4032/4896 B (D2/D3/D5).

---

## 6.3 Modelo de seguridad

### 6.3.1 El esquema de firma e instanciación con Dilithium

**Definición 6.6 (Esquema de firma).** Una terna de algoritmos $(\mathsf{KeyGen}, \mathsf{Sign}, \mathsf{Verify})$:

$$
\mathsf{KeyGen}(1^\lambda)\to(pk,sk), \quad \mathsf{Sign}(sk,\mu)\to\sigma, \quad \mathsf{Verify}(pk,\mu,\sigma)\to\{0,1\},
$$

con **corrección**: $\Pr[\mathsf{Verify}(pk,\mu,\mathsf{Sign}(sk,\mu))=1] \ge 1-\mathrm{negl}(\lambda)$.

**Plantilla algebraica simplificada de Dilithium.** Para explicar la relación reticular se escribe $sk=(\mathbf{s}_1,\mathbf{s}_2)$ con $\mathbf{s}_1\in S_\eta^\ell$, $\mathbf{s}_2\in S_\eta^k$; la clave pública es $pk=(\mathbf{A},\ \mathbf{t}=\mathbf{A}\mathbf{s}_1+\mathbf{s}_2)$, donde $\mathbf{A}$ se regenera de forma determinística a partir de una semilla pública de 256 bits (no se almacena). La firma sigue el paradigma **Fiat-Shamir with Aborts** —técnica introducida por Lyubashevsky en ASIACRYPT 2009 [Lyu09] e instanciada sobre retículos en EUROCRYPT 2012 [Lyu12]— mediante el bucle:

1. Muestrear un "compromiso" $\mathbf{y}\in S_{\gamma_1}^\ell$ y computar $\mathbf{w}=\mathbf{A}\mathbf{y}$.
2. Derivar el reto $c=H(\mu, \mathbf{w}_1)$, un polinomio con pocos $\pm1$.
3. Computar la respuesta $\mathbf{z}=\mathbf{y}+c\,\mathbf{s}_1$.
4. **Rechazo:** si $\mathbf z$ (o términos asociados) excede ciertas cotas que evitarían filtrar el secreto, **abortar y reintentar** desde (1).

En esta descripción esquemática, la firma es $\sigma=(\mathbf{z},\mathbf{h},c)$, donde $\mathbf h$ es una "pista" (*hint*) de pocos bits. La verificación recomputa $\mathbf{w}'$ a partir de $\mathbf{z}$, $c$ y $\mathbf{t}$, y acepta si $c=H(\mu,\mathbf{w}'_1)$ y las normas de $\mathbf z$ están dentro de cotas. El rechazo forma parte del argumento de simulación bajo sus distribuciones e hipótesis (§6.4.1). En ML-DSA real, la clave pública codifica $(\rho,\mathbf t_1)$, la privada incluye también $K$, $tr$ y $\mathbf t_0$, y la firma transmite la semilla de reto $\tilde c$ junto con $\mathbf z$ y las pistas. La plantilla no sustituye esos algoritmos.

### 6.3.2 In-forjabilidad: EUF-CMA y sUF-CMA

**Definición 6.7 (Juego EUF-CMA).** Un adversario $\mathcal{A}$ recibe $pk$ y acceso a un oráculo de firma $\mathcal{O}_{\mathsf{Sign}}(\cdot)$. Produce un par $(\mu^*,\sigma^*)$ y **gana** si $\mathsf{Verify}(pk,\mu^*,\sigma^*)=1$ y $\mu^*$ nunca fue consultado al oráculo. Su ventaja es $\mathsf{Adv}^{\text{EUF-CMA}}_{\mathcal A}=\Pr[\mathcal A\text{ gana}]$. Un esquema es EUF-CMA seguro si esta ventaja es despreciable para todo $\mathcal A$ eficiente.

**In-forjabilidad fuerte (sUF-CMA).** Refuerza la condición de victoria: $\mathcal{A}$ gana si $(\mu^*,\sigma^*)$ es **nuevo** (incluso para un mensaje ya consultado, basta producir una **firma distinta**). Controla la maleabilidad de firmas; la identidad de una operación y su protección contra repetición requieren reglas propias de la aplicación.

### 6.3.3 El adversario cuántico: el QROM

Un adversario cuántico realista no solo ejecuta cómputo cuántico, sino que puede **consultar la función de hash en superposición**. El modelo apropiado es el **Quantum Random-Oracle Model (QROM)** [BDF+11], en el que el oráculo $H$ responde a consultas cuánticas $\sum_x \alpha_x\lvert x\rangle\lvert 0\rangle \mapsto \sum_x \alpha_x\lvert x\rangle\lvert H(x)\rangle$. Probar la seguridad en el QROM (y no solo en el ROM clásico) es indispensable porque las técnicas clásicas de reducción —en particular el rebobinado y el *forking*— **no se trasladan sin más al caso cuántico**: medir una superposición la colapsa, de modo que no se puede "rebobinar" un adversario cuántico arbitrariamente. En el juego considerado, las consultas de firma son clásicas; permitirlas en superposición define otro modelo. Los trabajos [KLS18, B+23] tratan la dificultad del oráculo cuántico; §6.4 distingue los resultados originales de sus correcciones posteriores.

---

## 6.4 Fundamentos y límites de la reducción de seguridad

### 6.4.1 Correspondencia entre esquema, resultado citado e implementación

**Marco de seguridad 6.1.** La revisión R1 identifica la ruta concreta de NEXUS y delimita los resultados que la sustentan. El código observado usa fips204 0.4.6, fijado por Cargo.lock; los nombres históricos Dilithium2/3/5 seleccionan ML-DSA-44/65/87. La evidencia conserva fuentes y hashes en R1-correspondencia/. El alcance es la correspondencia funcional y documental; no se ha verificado formalmente el binario.

**Perfil observado.** El envoltorio invoca keygen_from_seed para reconstruir claves. En cambio, sign_bytes llama a try_sign con contexto vacío: el método utiliza OsRng para obtener 32 bytes por firma y los combina con la clave y el representante del mensaje. Por tanto, la generación reproducible de claves coexiste con **firma ML-DSA pura, hedged y de contexto vacío**. La verificación usa el mismo contexto. La ruta sign_hash firma sus bytes como mensaje puro; su nombre no la convierte en HashML-DSA.

La inspección de la biblioteca identifica expansión SHAKE, dominio de parámetros en KeyGen, claves públicas comprimidas, pistas y reto codificado. Tres pruebas TG2, una por nivel, cotejan generación y firmas entre envoltorio y backend, aceptación de firmas deterministas válidas y rechazo al cambiar mensaje, contexto o modo prehash. En R1, la suite pasó **166 pruebas**. Al compartir biblioteca, estos casos no son ensayos independientes de conformidad ni demuestran inforjabilidad.

**Diferencias de especificación.** FIPS 204, algoritmos 2, 6–8 y apéndice D, distingue firma pura/prehash, aleatoriedad hedged y separación de dominios. La variante final también modifica longitudes y detalles respecto de Dilithium v3.1 [NIST24]. El análisis de un esquema con $\mathbf A$ y máscaras uniformes debe justificar el reemplazo por expansión desde semilla y sus codificaciones. Además, las claves derivadas por Sentinel requieren una hipótesis sobre su generación; las garantías del esquema no certifican la fuente ni la KDF.

**Reducción corregida CMA→NMA.** Barbosa et al. [B+23, Teorema 2] dan, para su transformada FSwA en QROM, una pérdida que depende de consultas clásicas de firma $q_S$, consultas cuánticas al hash $q_H$, rechazo $p$, concentración del compromiso $\epsilon$, error del simulador $\zeta_{\mathrm{zk}}$ y evento excepcional $\delta$:

$$
\begin{aligned}
\mathrm{Adv}^{\mathrm{EF\text{-}CMA}}(A)
&\le \mathrm{Adv}^{\mathrm{EF\text{-}NMA}}(B)+L_Q,\\
L_Q&=\frac{2q_S\sqrt{\epsilon}}{1-p}
\sqrt{q_H+1+\frac{q_S}{1-p}}\\
&\quad+2(q_H+1)\sqrt{\frac{q_S\epsilon}{1-p}}
+q_S\zeta_{\mathrm{zk}}+\delta.
\end{aligned}
$$

Sobre el evento favorable, el rechazo debe estar acotado por $p<1$ y la concentración media por $\epsilon$; el complemento tiene probabilidad a lo sumo $\delta$. El tiempo incluye $q_S$ simulaciones. El Teorema 4 mecaniza EF-CMA en **ROM** para un esquema con compresión pública, matriz y máscaras muestreadas directamente y bucle no acotado [B+23, §6]. No es una prueba mecanizada QROM de ML-DSA final.

**Uso de las cifras de la literatura.** Se reproduce aritméticamente la fila QROM NIST3 de [B+23, §7, Figura 8]: $q_S=2^{64}$, $q_H=2^{192}$, $p=103/128$, $\epsilon=2^{-1180}$, $\delta=2^{-362}$ y simulador perfecto. Se obtiene $\log_2 L_Q\approx-361{,}64$, compatible con su cota $2^{-360}$. La elección de $p$ usa la heurística del artículo; el cálculo no prueba esas hipótesis para NEXUS. El sumando $2^{-254}$ de [DIL21, §6.2, ec. (6), nota 5] se conserva como antecedente de la prueba original, sin adoptarlo como pérdida del prototipo.

**Actualización de la literatura.** Fallahpour, Fehr y Huang [FFH26, Teorema 1 y Corolario 1] mejoran la reducción UF-CMA→UF-NMA en QROM con consultas clásicas de firma, simulación de transcripciones aceptantes y eventos de rechazo y concentración. Se examinó la copia CWI de 2025, preservada con hash; la ficha ePrint registra revisiones posteriores. Esta mejora no elimina SelfTargetMSIS ni demuestra la correspondencia de semillas, firma hedged, codificaciones o sUF del ejecutable. La cuenta de [B+23] se conserva identificada como reproducción de aquella versión.

**Composición de transacciones.** La ruta serializa el contenido con `bincode`, calcula SHA3-256 y firma sus 32 bytes mediante ML-DSA puro con contexto vacío; no invoca HashML-DSA. La autenticidad del contenido requiere también resistencia a colisiones del hash externo y codificación inequívoca. FIPS 204 §5.4 trata el hash de aplicación y HashML-DSA: para mantener la fuerza del perfil exige fuerza clásica de colisión y segunda preimagen de al menos su parámetro de seguridad. El digest SHA3-256 externo no permite trasladar automáticamente la fuerza de ML-DSA-65/87 a la transacción [NIST24, §5.4]. Es un límite de composición, sin demostrar un ataque ni incumplimiento de la operación ML-DSA pura.

**Terminación del backend.** El contador de máscaras de 16 bits de `fips204` 0.4.6 puede desbordarse tras un número extremo de rechazos. El contraste local identifica el recorrido aritmético, sin ejecutar una explotación ni demostrar su probabilidad. La obligación R1-D de robustez y tratamiento del error permanece abierta; las pruebas de ida y vuelta no prueban terminación en todas las ejecuciones.

**Extracción e inforjabilidad fuerte.** La cota EF-CMA anterior no establece por sí sola sUF-CMA. La rama MSIS de [DIL21, §6.2.2] trata el caso adicional con condiciones sobre reto, pistas y redondeo. Una firma válida de la clave real tampoco es automáticamente una solución para una instancia uniforme de SelfTargetMSIS: hacen falta los cambios de juego y la simulación de consultas.

**Lema 6.1 (diferencia de preimágenes cortas).** Sean $\mathbf x,\mathbf x'$ distintos como elementos de $R_q^r$, con representantes enteros de norma infinito a lo sumo $L$, y $\mathbf B\mathbf x=\mathbf B\mathbf x'$. La diferencia de sus representantes es no nula módulo $q$, satisface $\mathbf B(\mathbf x-\mathbf x')=\mathbf0$ y tiene norma a lo sumo $2L$.

*Demostración.* La linealidad da la ecuación homogénea; la distinción en $R_q^r$ excluye el residuo nulo y la desigualdad triangular da la cota. $\square$

Dos firmas del mismo mensaje pueden tener compromisos y retos distintos; no satisfacen automáticamente esa hipótesis.

**Contraste de SelfTargetMSIS.** El Teorema 2 de [JMW24] exige, además de la congruencia del módulo, $2\gamma\eta'n(m'+k')<\lfloor q/32\rfloor$. Sus pérdidas dependen de $Q$, $nq^{-k'}$, el tamaño del espacio de retos y un parámetro de aproximación; no son una equivalencia sin pérdida. En su traducción de §4 se toma $\gamma=\zeta=\max\{\gamma_1-\beta,2\gamma_2+1+2^{d-1}\tau\}$ y $m'+k'=k+\ell+1$.

Con las constantes del backend, $\zeta$ vale 350209, 724481 y 769537. Aun tomando el menor entero auxiliar positivo $\eta'=1$, los lados izquierdos son 1.613.763.072, 4.451.211.264 y 6.304.047.104; el derecho es 261.888 en los tres niveles. **La condición falla.** Este cálculo descarta esa aplicación directa del teorema; no constituye un ataque ni una imposibilidad de otra reducción. R1 no elimina el supuesto SelfTargetMSIS para estos parámetros.

### 6.4.2 Reducciones de peor caso a caso promedio

**Resultado citado 6.2, con localizadores precisos.** En la versión conservada de [LS15], el Teorema 3.6 reduce clásicamente Mod-GIVP, formulado con el parámetro de suavizado, a M-SIS. Exige relaciones asintóticas entre módulo, norma, dimensión y aproximación. El Teorema 4.7 incorpora la reducción cuántica a M-SLWE y un paso búsqueda→decisión sujeto a condiciones adicionales. El Teorema 4.8 cambia módulo y ruido; no es por sí solo otra reducción cuántica desde Mod-SIVP.

La relación con SIVP utiliza los resultados auxiliares del artículo. El esquema de dirección de dureza es:

$$
\mathrm{Mod\text{-}SIVP}_{\gamma}
\le_{\mathrm{red}}
\mathrm{M\text{-}LWE}
\quad\text{o}\quad
\mathrm{Mod\text{-}SIVP}_{\gamma}
\le_{\mathrm{red}}
\mathrm{M\text{-}SIS}.
$$

Resolver el problema derecho permitiría resolver el izquierdo bajo las condiciones de la reducción. Esta notación no sustituye sus pasos intermedios.

La distribución decisional de [LS15, Definición 4.6] usa secreto uniforme y una familia de errores gaussianos; §6.2.3 describe secretos y errores uniformes pequeños. Equipararlas necesita transformaciones adicionales y pérdidas. Tampoco se reemplaza una condición asintótica $\omega(\cdot)$ por una constante elegida sin justificación. Se cita el fundamento de la familia y se mantiene sin instanciar un factor concreto de aproximación para NEXUS.

### 6.4.3 Resistencia cuántica y alcance del argumento de Shor

Shor [Sho97] proporciona algoritmos eficientes de factorización y logaritmo discreto. Los supuestos reticulares de este capítulo no quedan resueltos por aplicar directamente esos algoritmos. **Esto no demuestra que no pueda existir otro ataque cuántico eficiente**: la resistencia postcuántica se formula bajo supuestos de dureza y el análisis criptográfico disponible.

El problema del subgrupo oculto diédrico y los algoritmos de Kuperberg [Kup05] forman parte del contexto de investigación. No se usan aquí para demostrar una imposibilidad de reducción ni una cota inferior de complejidad para MLWE o ML-DSA.

Las estimaciones *core-SVP* modelan costos de ataques mediante reducción de bases y tamizado [DIL21, §6.3 y apéndice C; Laa15; BDGL16]. Dependen del modelo de tiempo y memoria y del ataque considerado. Comparar exponentes como $0.265/0.292$ no establece una razón universal entre seguridad clásica y cuántica del esquema. Tampoco se obtiene una cota demostrada de ML-DSA dividiendo por dos una categoría NIST.

Para NEXUS se distinguen: (i) los conjuntos de parámetros normalizados en FIPS 204; (ii) los supuestos y reducciones que sustentan el diseño; y (iii) las estimaciones de ataques, que deben citar su versión y modelo. Ninguno de esos niveles constituye por sí solo una prueba de seguridad de todo el sistema de aplicación.

### 6.4.4 Síntesis de las garantías y obligaciones pendientes

**Tabla 6.2 — Fundamentos y límites de la reducción de seguridad.**

| Nivel de afirmación | Evidencia | Límite de la conclusión |
|---|---|---|
| Perfil observado | ML-DSA puro, hedged, contexto vacío; fips204 0.4.6 | Tres pruebas de correspondencia; sin certificación del binario |
| Inforjabilidad citada | B+23: CMA→NMA en QROM; mecanización ROM de una plantilla | Expansión, codificaciones, firma hedged y sUF requieren pasos adicionales |
| SelfTargetMSIS | Contraste numérico de JMW24 | Su condición no se cumple para los tres perfiles ML-DSA |
| Fundamento reticular | LS15: Mod-GIVP, búsqueda→decisión y cambio de módulo | Distribuciones y factor concreto sin instanciar |
| Resistencia cuántica | Supuestos reticulares y análisis de ataques | La no aplicabilidad directa de Shor no prueba dureza general |
| Seguridad del sistema | Firma, autorización, épocas, estado, consenso y pruebas | La seguridad de cada componente y de su composición debe tratarse explícitamente |

R1 entrega un mapa comprobable de correspondencias y diferencias, cálculos reproducibles y localizadores de fuentes. El Objetivo 4.1 conserva la revisión matemática externa. Una garantía concreta del código requeriría completar los cambios de distribución y las codificaciones, justificar la fuente/KDF y el perfil hedged, y tratar sUF-CMA y la terminación del bucle. El cierre documental acota el resultado defendido; no equivale a haber construido esas reducciones.

---

## 6.5 Análisis de complejidad computacional

### 6.5.1 La NTT como operación dominante

La operación costosa en $R_q$ es la multiplicación de polinomios. Mediante la **NTT** —una Transformada de Fourier sobre $\mathbb{Z}_q$, posible porque $q\equiv 1\pmod{2n}$ (§6.2.2)— un polinomio se lleva al "dominio NTT" en $O(n\log n)$ operaciones; en ese dominio la multiplicación es **puntual** ($O(n)$), y la transformada inversa cuesta de nuevo $O(n\log n)$. Así, una multiplicación en $R_q$ cuesta

$$
T_{\text{mult}}(n) = O(n\log n)\ \text{operaciones en }\mathbb{Z}_q,
$$

frente al $O(n^2)$ del producto escolar. Con $n=256$, la ganancia es decisiva y explica el rendimiento del esquema.

### 6.5.2 Complejidad de KeyGen, Sign y Verify

Midiendo el costo en multiplicaciones de anillo (cada una $O(n\log n)$):

**Proposición 6.4 (Costos asintóticos).** *Para Dilithium con dimensiones $(k,\ell)$ y $n$ fijo:*

- $\mathsf{KeyGen}$*: el cálculo de $\mathbf{t}=\mathbf{A}\mathbf{s}_1+\mathbf{s}_2$ requiere $k\ell$ multiplicaciones de anillo, luego $O(k\ell\,n\log n)$.*
- $\mathsf{Sign}$ *(esperado): cada iteración del bucle de rechazo está dominada por el producto matriz–vector $\mathbf{A}\mathbf{y}$ ($k\ell$ multiplicaciones), luego $O(k\ell\,n\log n)$ por iteración; el número esperado de iteraciones es una **constante** por conjunto de parámetros, luego el costo esperado es $O(k\ell\,n\log n)$.*
- $\mathsf{Verify}$*: recomputar $\mathbf{A}\mathbf{z}-c\,\mathbf{t}$ cuesta $O(k\ell\,n\log n)$.*

*Demostración (recuento).* En $\mathsf{KeyGen}$, $\mathbf{A}\in R_q^{k\times\ell}$ y $\mathbf{s}_1\in R_q^\ell$, de modo que $\mathbf{A}\mathbf{s}_1$ son $k\ell$ productos de anillo; la suma de $\mathbf{s}_2$ es $O(kn)$, de orden inferior, y la verificación es de nuevo un producto matriz–vector $O(k\ell\,n\log n)$.

Para $\mathsf{Sign}$ resta modelar el número de iteraciones. Bajo el supuesto ideal de intentos independientes con probabilidad fija $p_{\mathrm{acc}}$ de superar **todos** los rechazos, el número $N$ de intentos es geométrico:

$$
\mathbb{E}[N]=\frac{1}{p_{\mathrm{acc}}}.
$$

El código expande máscaras desde una semilla y un contador; la independencia ideal no se deduce de observar ese bucle. Para una familia de parámetros, la conclusión $\mathbb E[N]=O(1)$ requiere además una cota inferior uniforme positiva para $p_{\mathrm{acc}}$. Bajo ese supuesto, el costo esperado por firma mantiene el orden $O(k\ell\,n\log n)$.

**Actualización de la fuente.** La hoja NIST de actualizaciones potenciales del 31 de julio de 2026 corrige las estimaciones de repeticiones de FIPS 204 a **4,36 / 5,14 / 3,91**: incorpora el rechazo de la línea 28 del algoritmo 7. También propone 821 como mínimo del límite admisible del bucle del apéndice C [NIST24-E26]. Son correcciones potenciales declaradas por NIST y estimaciones de referencia, no frecuencias medidas por NEXUS. El backend inspeccionado emplea un contador de 16 bits y un bucle sin límite explícito de intentos; estas pruebas no verifican su comportamiento en el caso extremo de agotamiento.

**Cota más fina (implementación optimizada).** Manteniendo $\mathbf{A}$ y los vectores en el **dominio NTT**, las $k\ell$ multiplicaciones puntuales cuestan $O(k\ell\,n)$ y las transformadas se incurren solo $O(k+\ell)$ veces, dando

$$
O\big((k+\ell)\,n\log n + k\ell\,n\big),
$$

que es ajustada. El $O(k\ell\,n\log n)$ del enunciado es una **cota superior** válida bajo la convención «cada multiplicación de anillo $= O(n\log n)$». Como $n=256$ es fijo, en la práctica el costo escala con $k\ell$.

**Tamaños.** La clave pública $pk=(\rho,\mathbf{t}_1)$ está dominada por $\mathbf{t}_1\in R_q^k$ ($k\cdot n$ coeficientes de $O(\log q)$ bits; $\mathbf A$ se regenera de la semilla $\rho$ de 256 bits y no se almacena), luego $|pk|=O(k\,n\log q)$. La firma $\sigma=(\mathbf{z},\mathbf{h},c)$ está dominada por $\mathbf{z}\in R_q^\ell$, luego $|\sigma|=O((k+\ell)\,n\log q)$. Ambas cotas concuerdan con los tamaños tabulados (§6.2.3).

**Tabla 6.3 — Complejidad y tamaños.**

| Característica | $\mathsf{KeyGen}$ | $\mathsf{Sign}$ (esp.) | $\mathsf{Verify}$ | $\lvert pk\rvert$ | $\lvert\sigma\rvert$ |
|---|:---:|:---:|:---:|:---:|:---:|
| Asintótico | $O(k\ell\,n\log n)$ | $O(k\ell\,n\log n)$ | $O(k\ell\,n\log n)$ | $O(k\,n\log q)$ | $O((k{+}\ell)\,n\log q)$ |
| Dilithium2 | — | $\approx 4{,}36$ iter. | — | 1312 B | 2420 B |
| Dilithium3 | — | $\approx 5{,}14$ iter. | — | 1952 B | 3309 B |
| Dilithium5 | — | $\approx 3{,}91$ iter. | — | 2592 B | 4627 B |

### 6.5.3 Overhead del esquema dual

El análisis cuantificado completo del *overhead* y de su amortización por la arquitectura dual-chain se desarrolla en el **Capítulo 3** (documento `Analisis-Overhead-PQC-DualChain`). Aquí se consignan los resultados pertinentes a la **verificación de firmas**, que es la magnitud que el análisis de complejidad acota:

- **Costo de datos y cómputo:** una firma ML-DSA-65 (3309 B) ocupa aproximadamente 52 veces una firma ECDSA de 64 B. En las series históricas, sus tiempos de verificación son del mismo orden; el costo relativo depende de la operación, biblioteca, hardware y carga. El tamaño constituye una motivación para la agregación, sin excluir costos de CPU.
- **Verificación por bloque** de $m$ transacciones en una cadena única: $O(m\cdot k\ell\,n\log n)$.
- **Amortización dual-chain:** la L1 verifica una prueba por lote; su tiempo $t_\pi(m)$ puede crecer con el lote. El costo por operación es $t_\pi(m)/m$. Trasladar las firmas fuera de L1 requiere disponibilidad de datos y una prueba de la lógica pertinente. El AIR actual no demuestra ese flujo completo; §6.6.5 explicita las condiciones del modelo.

### 6.5.4 Comparación con criptografía clásica

**Tabla 6.4 — Análisis de complejidad computacional.**

| Característica | RSA-2048 | ECDSA P-256 | **Dilithium3** |
|---|:---:|:---:|:---:|
| Tamaño de firma | 256 B | 64 B | **3309 B** |
| Costo de verificación (CPU, **medido en el mismo banco**, §6.6.2) | 92,4 µs | 144,8 µs | **77,6 µs** |
| Resistencia cuántica | **Rota** (Shor, tiempo poli.) | **Rota** (Shor, tiempo poli.) | **Sin ataque cuántico eficiente conocido** |

En la serie histórica H2, ML-DSA-65 presenta la menor latencia de verificación de los esquemas comparados. Esta observación se limita a esos perfiles y operaciones; no establece superioridad general ni elimina las obligaciones de integración y seguridad del sistema.

---

## 6.6 Validación empírica complementaria

El análisis asintótico de §6.5 describe la **forma** del costo ($O(k\ell\,n\log n)$) pero oculta las **constantes**. La validación empírica caracteriza las latencias de las rutas y condiciones ensayadas; complementa la validación formal sin probar por sí sola una ley asintótica o la viabilidad de la arquitectura completa.

**Metodología.** Banco de pruebas con el *harness* Criterion: `nexus-crypto/benches/dilithium_bench.rs` (ML-DSA) y `nexus-crypto/benches/classical_baseline.rs` (líneas base clásicas ECDSA/RSA, §6.6.2); para el verificador STARK, el *harness* dedicado `nexus-zk/examples/stark_demo.rs` (§6.6.3). Para cada nivel (Dilithium2/3/5) y operación ($\mathsf{KeyGen}$, $\mathsf{Sign}$, $\mathsf{Verify}$): 100 muestras con calentamiento, reportando la **mediana** (robusta a valores atípicos). Estas latencias corresponden a un hilo. El experimento multinúcleo se identifica por separado. Las condiciones de la nueva serie R4, con distinto número de muestras, se especifican en §6.6.4; no se atribuye toda diferencia entre máquinas exclusivamente a IPC o frecuencia.

Los resultados históricos se reportan sobre **dos perfiles de hardware**. Permiten comparar razones entre niveles en esos perfiles, sin aislar causalmente el efecto del equipo ni acreditar independencia del hardware:

**Tabla 6.5 — Validación empírica complementaria.**

| Perfil | CPU | SO / perfil de compilación | Medición |
|---|---|---|:---:|
| **H1** | Intel Kaby Lake (Familia 6, Modelo 142), 4 hilos lógicos — portátil de 2017 | Windows 11; `release` (opt-level 3, LTO fino) | 2026-07 |
| **H2** | Intel Core Ultra 9 275HX (Arrow Lake-HX), 24 núcleos — portátil de 2026 | Windows 11; rustc 1.97.1; mismo perfil `release` | 2026-08-07 |

*Backend:* crate `fips204` (ML-DSA **puro Rust**, constant-time) en ambos perfiles.

**Métricas e hipótesis a contrastar.**

- Tiempos por operación y verificaciones por segundo, por nivel.
- **Contraste teoría–práctica:** examinar si las razones entre los tres niveles, con $n$ fijo, son compatibles con el modelo de §6.5 y comparar su comportamiento observado entre perfiles.
- **Comparativa clásica en el mismo banco:** posición de Dilithium3 frente a ECDSA P-256 y RSA-2048/3072 en las tres operaciones (§6.6.2).
- **Escalado del verificador STARK** frente al tamaño de la traza probada (§6.6.3), insumo del argumento de amortización dual-chain (§6.5.3, Cap. 3).

> **Procedencia de las cifras.** Las tablas H1/H2 conservan las corridas documentadas en julio y agosto de 2026. El inventario del 22 de septiembre recuperó resultados Criterion con medianas distintas en las nueve cifras ML-DSA de H2: por ejemplo, 77,170 µs de verificación ML-DSA-65 frente a 77,6 µs publicados. Esa diferencia no procede del redondeo. Los archivos se preservan como evidencia local, sin asignarlos a la misma corrida ni presentarlos como una nueva réplica; el mtime no acredita su identidad. La revisión del 12 de octubre concilia las estadísticas y fuentes de R4 y su complemento con 451 comprobaciones sin discrepancias. Sigue pendiente reconstruir las fuentes y la identidad exacta de las corridas H1/H2. Las cifras STARK de diseño conservadas en el Cap. 3 pertenecen a una serie anterior; para comparar perfiles se usa la serie identificada en esta sección.

### 6.6.1 ML-DSA / Dilithium en ambos perfiles

**Tabla 6.6 — Tiempos medidos de ML-DSA / Dilithium (perfil H1, medianas; corrida del 2026-07-31 con rustc 1.97.1 — la publicada en el README del repositorio `nexus`).**

| Operación | Dilithium2 | Dilithium3 | Dilithium5 |
|---|---:|---:|---:|
| Generación de claves | 234 µs | 413 µs | 564 µs |
| Firma | 497 µs | 790 µs | 979 µs |
| **Verificación** | **141 µs** | **232 µs** | **390 µs** |

**Tabla 6.7 — Tiempos medidos de ML-DSA / Dilithium (perfil H2, medianas).**

| Operación | Dilithium2 | Dilithium3 | Dilithium5 |
|---|---:|---:|---:|
| Generación de claves | 92,5 µs | 142,1 µs | 198,1 µs |
| Firma | 183,0 µs | 290,0 µs | 343,3 µs |
| **Verificación** | **48,8 µs** | **77,6 µs** | **129,2 µs** |

**Contraste teoría–práctica.**

1. **Latencia y capacidad estimada.** La verificación histórica tarda entre 48,8 y 390 µs según perfil y nivel. El inverso de 77,6 µs es aproximadamente 12.900 verificaciones/s; es una conversión ideal de latencia, no una medición de capacidad sostenida del sistema. El costo de datos y el de CPU deben evaluarse según la carga de la aplicación.
2. **Razones observadas y modelo de costo.** Las tres operaciones crecen de forma **monótona** con el nivel, mientras el producto $k\ell$ pasa por 16, 30 y 56 para D2/D3/D5. Verify D5/D2 es ×2,77 en H1 y ×2,65 en H2; KeyGen D5/D2, ×2,41 y ×2,14. Estas razones son menores que las del producto $k\ell$ y son compatibles con un costo que incluye términos de orden inferior y constantes de implementación (cf. $O((k+\ell)\,n\log n + k\ell\,n)$). Tres niveles con $n=256$ fijo no prueban una ley asintótica, no aíslan el efecto del hardware y no establecen que la forma del costo sea independiente de él. Las diferencias H1/H2 describen exclusivamente las series históricas conservadas.
3. **La firma es la operación más costosa.** La domina el bucle de *rejection sampling* (§6.5.2), cuyo número de iteraciones es esperado-constante pero **variable**; es un costo **esperado**, no de peor caso. La mediana mitiga esa variabilidad.

**Throughput de verificación multinúcleo (H2).** El registro del harness `nexus-crypto/examples/throughput_tps.rs` reporta 12.485 verificaciones/s con un hilo, 49.843 con cuatro y 199.218 con 24, sobre un lote de 4.096 mensajes y firmas. Son verificaciones de firmas aisladas; no miden ejecución, persistencia, consenso ni generación de pruebas de transacciones completas de una aplicación. R4 detectó que los trabajadores podían contar operaciones antes del inicio del reloj principal. Por ello, estas cifras se conservan como antecedente con sesgo temporal posible y no sustentan una conclusión de escalado validada. El harness experimental corregido sincroniza el inicio y mide hasta la finalización de todos los trabajadores; su primera ejecución optimizada quedó bloqueada por Windows (§6.6.4) y posteriormente se completó en la serie complementaria (§6.6.6).

### 6.6.2 Comparativa medida con criptografía clásica

Las cifras de §6.5.4 se contrastan aquí **en el mismo banco, el mismo hardware (H2) y el mismo mensaje**, con el *harness* `classical_baseline.rs`. Los backends clásicos son los crates `p256` y `rsa` (RustCrypto) —implementaciones en Rust, como `fips204`; compartir lenguaje no acredita igual madurez u optimización—. Para RSA-2048, $\mathsf{KeyGen}$ se midió con 10 muestras (su costo, cinco órdenes de magnitud mayor, acotaría el banco); la generación RSA-3072 (segundos por clave) no se midió por no estar en ninguna ruta caliente.

**Tabla 6.8 — Dilithium3 frente a los esquemas clásicos incumbentes (H2, medianas).**

| Esquema | $\mathsf{KeyGen}$ | $\mathsf{Sign}$ | $\mathsf{Verify}$ | $\lvert\sigma\rvert$ |
|---|---:|---:|---:|---:|
| ECDSA P-256 | 70,0 µs | 87,5 µs | 144,8 µs | 64 B |
| RSA-2048 | 106,6 ms | 740,5 µs | 92,4 µs | 256 B |
| RSA-3072 | no medido ($\gg$ 1 s) | 2,47 ms | 199,1 µs | 384 B |
| **Dilithium3 (ML-DSA-65)** | **142,1 µs** | **290,0 µs** | **77,6 µs** | **3309 B** |

Cuatro lecturas:

1. **En verificación, Dilithium3 es el esquema más rápido de la tabla:** 1,9× más rápido que ECDSA P-256, 1,2× que RSA-2048 y 2,6× que RSA-3072. La verificación es precisamente la operación caliente de una blockchain (cada firma se genera una vez y se verifica muchas veces, por el sequencer y por cada validador); la ventaja observada pertenece a esta serie y a las implementaciones medidas. *(La corrida H1 de la misma comparativa —README del repo, 2026-07-31— muestra el mismo cuadro con una salvedad: allí RSA-2048 verificaba marginalmente más rápido que Dilithium3, 218 vs. 232 µs, con ECDSA última a 301 µs.)*
2. **En firma**, Dilithium3 es 3,3× más lento que ECDSA pero 2,6× y 8,5× más rápido que RSA-2048 y RSA-3072 — los esquemas clásicos incluidos como líneas base en este experimento.
3. **En generación de claves**, los 142 µs de Dilithium3 (vs. 106,6 ms de RSA-2048: **750× más rápido**) son el ancla empírica de la política de rotación agresiva del Cap. 5: la viabilidad de generar claves por firma depende de la carga y de su presupuesto de latencia; la reexpansión desde una misma semilla no constituye una nueva época.
4. **Tamaño y costo total.** La firma ML-DSA-65 ocupa 3309 B, unas 52 veces la ECDSA medida. Su latencia de firma también es mayor que la ECDSA de esta serie. El costo total debe considerar operaciones, datos, prueba y disponibilidad.

> *Nota de comparación:* no se auditó el código máquina para excluir SIMD o ensamblador de todas las dependencias. La comparación describe las bibliotecas, configuración y equipo registrados; no predice los resultados de otros backends.

### 6.6.3 Verificador STARK: serie histórica de escalado

El argumento de amortización dual-chain (§6.5.3; Cap. 3, §3.5) depende de una propiedad asintótica del sistema de pruebas: que el costo del **verificador** crezca polilogarítmicamente con el tamaño del cómputo probado. Para un STARK basado en FRI, la teoría predice tamaño de prueba y tiempo de verificación $O(\lambda\,\log^2 n)$ (consultas × capas de FRI × caminos de Merkle de longitud $\log$) y costo del *prover* $\tilde O(n)$. Esta subsección contrasta el crecimiento observado del PoC heredado (§6.7): blowup 8, 40 consultas, desafíos en $F_{p^2}$, *grinding* $2^{20}$, sobre H2. No mide el rendimiento de la variante TG2 v1 con FRI de traza vinculado. El presupuesto de seguridad se trata por separado en §6.7.

**Tabla 6.9 — STARK PoC: tamaño y tiempos frente al tamaño de la traza (H2).**

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

*(La unidad rotulada KB en el registro histórico corresponde a KiB = 1024 B. La longitud serializada depende de la estructura; igualdad de longitud no significa igualdad de los bytes de pruebas con distintos enunciados.)*

**Contraste teoría–práctica.**

1. **Crecimiento observado.** Al multiplicar el cómputo probado por **16.384** (de $2^4$ a $2^{18}$ pasos), la prueba crece solo **×6,0** y la verificación **×6,2**. Si la relación fuera lineal, verificar a $2^{18}$ pasos costaría ~20 s; cuesta **7,74 ms**.
2. **Tamaño y estructura de aperturas.** Los incrementos de tamaño por cada cuadruplicación de la traza son aproximadamente +61,3; +71,3; +81,3; +91,3; +101,3; +111,3; +121,3 KiB, compatibles con el crecimiento de capas y caminos del PoC. La verificación también aumenta en el rango ensayado. Los puntos finitos de latencia no demuestran un ajuste cuadrático ni una cota asintótica; su interpretación requiere separar estructura, constantes y dispersión.
3. **Asimetría prover/verificador.** La generación histórica alcanza 10,25 s en $2^{18}$ filas. El tiempo total combina construcción de la prueba y búsqueda de nonce; estos puntos finitos no prueban una ley asintótica ni miden el costo de una aplicación completa.
4. **Nota metodológica (*grinding*).** La búsqueda determinista de nonce depende del enunciado y contribuye al tiempo de generación, incluido el punto no monótono de $2^6$ (826 ms históricos). Sin cronometraje separado no se atribuye toda la variación al nonce ni se concluye que su peso desaparezca; R4 conserva testigos distintos y dispersión (§6.6.4).
5. **Comparación histórica de perfiles.** En H1 (julio de 2026, rango $2^4$–$2^{12}$) la verificación midió 4,5→11,4 ms, aproximadamente 3,5× los tiempos H2 correspondientes, con tamaños de prueba coincidentes. Es un antecedente limitado a esos registros, sin acreditar la misma forma de curva ni aislar causalmente el equipo.

**El *trade-off*, declarado.** Una prueba histórica de 768,2 KiB equivale a ~238 firmas Dilithium3 de 3309 B; pero se paga **una vez por lote**: a $2^{18}$ pasos equivale a ~3 B por paso probado, y su verificación histórica tarda 7,74 ms para esta recurrencia. Una fila del AIR no equivale a una transacción de la aplicación. La cadencia del prover (~10 s en un hilo a $2^{18}$) fija la latencia mínima de bacheo del PoC; su paralelización es trabajo futuro (Cap. 7).

> Las cifras dependen del perfil y del backend. Su crecimiento en el rango observado es compatible con el análisis de la estructura del PoC; una serie finita de tiempos no demuestra una cota asintótica.

---

### 6.6.4 Serie R4 del 22 de septiembre: resultados y procedencia

La nueva serie se ejecutó en el Intel Core Ultra 9 275HX de 24 núcleos/hilos, Windows 11 compilación 26200 y plan de energía Equilibrado, con rustc 1.97.1, Cargo.lock conservado y perfil optimizado. Los comandos se ejecutaron en serie, sin afinidad ni aislamiento exclusivo de la CPU. Se preservaron las fuentes y sus hashes, estado Git, metadatos del equipo, argumentos, salidas originales y resultados en `Documentos/06-Evidencia-TG2/2026-09-22/R4-validacion/`. El repositorio tenía cambios locales: el commit por sí solo no identifica esta ejecución.

**Cobertura de la primera ejecución.** Finalizaron ocho casos clásicos, nueve de residencia/expansión y cuarenta pruebas STARK cronometradas. El Control de aplicaciones de Windows impidió iniciar los ejecutables optimizados de `dilithium_bench` y `tg2_throughput` (error 4551). Se conservan ambos fallos y no se imputan resultados. Estos dos experimentos se completaron después del cambio de configuración de Windows realizado por el autor; sus resultados se identifican por separado en §6.6.6.

**Criterion.** Calentamiento de un segundo, objetivo de medición de dos segundos y 50 muestras por caso; la generación RSA-2048 usa diez muestras, según el harness. Los intervalos son IC bootstrap del 95 % de la mediana calculados por Criterion dentro de esta ejecución. No representan variación entre equipos o días. Las firmas efímeras incluyen la expansión desde semilla; las cacheadas reutilizan el par. La expansión aislada no incluye obtención de entropía nueva.

**Tabla 6.10 — Serie R4: firmas clásicas, tiempos en microsegundos.**

| Operación / nivel | n | Mediana (µs) | IC 95 % (µs) |
|---|---:|---:|---:|
| Generación / ECDSA P-256 | 50 | 72,25 | 71,42–72,98 |
| Generación / RSA-2048 | 10 | 101588,03 | 78184,57–126318,48 |
| Firma / ECDSA P-256 | 50 | 88,03 | 86,73–89,05 |
| Firma / RSA-2048 | 50 | 792,96 | 783,55–799,45 |
| Firma / RSA-3072 | 50 | 2433,76 | 2411,85–2456,75 |
| Verificación / ECDSA P-256 | 50 | 149,05 | 147,84–152,56 |
| Verificación / RSA-2048 | 50 | 98,07 | 97,24–99,89 |
| Verificación / RSA-3072 | 50 | 221,01 | 219,07–222,22 |

**Tabla 6.11 — Serie R4: residencia y expansión de claves, tiempos en microsegundos.**

| Operación / nivel | n | Mediana (µs) | IC 95 % (µs) |
|---|---:|---:|---:|
| Firma cacheada / dilithium2 | 50 | 202,28 | 197,61–207,34 |
| Firma cacheada / dilithium3 | 50 | 327,42 | 325,39–334,82 |
| Firma cacheada / dilithium5 | 50 | 391,07 | 376,61–398,69 |
| Firma efímera / dilithium2 | 50 | 295,94 | 292,32–300,22 |
| Firma efímera / dilithium3 | 50 | 478,74 | 466,55–490,96 |
| Firma efímera / dilithium5 | 50 | 605,03 | 598,99–617,64 |
| Expansión / dilithium2 | 50 | 90,42 | 89,58–91,90 |
| Expansión / dilithium3 | 50 | 145,03 | 143,97–146,40 |
| Expansión / dilithium5 | 50 | 215,83 | 212,68–219,23 |

**Tabla 6.12 — Serie R4: STARK; mediana [mínimo–máximo] de cinco repeticiones.**

| Filas del AIR | Prueba (KiB) | Generación (ms) | Verificación (ms) |
|---:|---:|---:|---:|
| 16 | 128,98 | 111,97 [4,64–738,40] | 1,31 [1,21–1,96] |
| 64 | 190,29 | 337,00 [56,61–579,79] | 1,76 [1,73–2,05] |
| 256 | 261,60 | 339,51 [143,61–1370,42] | 2,45 [2,26–3,18] |
| 1024 | 342,91 | 247,68 [44,29–644,78] | 2,99 [2,88–4,88] |
| 4096 | 434,23 | 221,57 [171,85–413,06] | 3,62 [3,54–4,53] |
| 16384 | 535,54 | 721,48 [594,79–1135,98] | 5,56 [4,37–7,37] |
| 65536 | 646,85 | 3174,19 [2248,91–3600,72] | 6,39 [5,13–8,20] |
| 262144 | 768,16 | 14001,55 [9674,23–14251,98] | 7,79 [6,04–8,64] |

**STARK.** El harness preservado `tg2_stark_measure.rs` llama a la API heredada `prove_state_transition`/`verify_state_transition`; sus tiempos no corresponden a TG2 v1 con FRI de traza vinculado. Se descartó un calentamiento de 16 filas y se generaron cinco pruebas por tamaño, con testigos distintos por repetición. Cada prueba se verificó veinte veces; se reporta la mediana y el rango de las cinco medias de verificación. La generación incluye la búsqueda de nonce con 20 bits de trabajo y varía ampliamente para trazas pequeñas. Se mide la serialización de `StarkProof`, sin el enunciado envolvente; KiB significa 1024 bytes. Son filas de la recurrencia demostrativa, sin transacciones ni verificación ML-DSA dentro del AIR. El rango observado no es un intervalo de confianza.

En ML-DSA-65, las medianas de firma cacheada y efímera fueron 327,42 y 478,74 µs; la diferencia descriptiva calculada desde los valores fuente completos, antes de redondear, es **151,33 µs**. No se presenta como una muestra pareada ni como medida directa de residencia secreta. En la traza mayor, la mediana de generación fue 14,00 s y la de verificación 7,79 ms, con 768,16 KiB de prueba. Las diferencias respecto de H2 no se atribuyen a una regresión: cambian los enunciados, la repetición y las condiciones observadas. La serie de agosto y la caché recuperada conservan su identidad histórica.

### 6.6.5 Sensibilidad de la amortización

Para un lote de $m$ operaciones, el modelo de datos de anclaje es $F(m)=d+(c+\pi(m))/m$, con $d$ bytes de diferencia por operación, $c$ bytes fijos del lote y $\pi(m)$ bytes de prueba. La interpretación exige que esa prueba autentique la lógica y los datos pertinentes. La disponibilidad de datos agrega su propio costo; desplazar firmas fuera de L1 no elimina su almacenamiento o distribución. El tiempo del prover $P(m)$ y la espera para llenar el lote también limitan latencia y capacidad.

Como sensibilidad aritmética, tomando $d=32$ B, $c=128$ B y una prueba fija de 786.600 B, el modelo da 800,289 B por operación para $m=1024$, 80,018 para $m=16.384$ y 35,001 para $m=262.144$. Si se duplica únicamente la prueba, el último valor pasa a 38,002 B. Si la disponibilidad requiere publicar 3309 B adicionales por operación, el costo total de datos de ese escenario pasa de 35,001 a 3344,001 B por operación. Estos valores ilustran dependencia de supuestos; no son mediciones de NEXUS. En particular, no se ha establecido una correspondencia entre las filas del AIR medido y esas operaciones.

---

### 6.6.6 Serie complementaria R4: ejecución de los dos experimentos pendientes

El autor desactivó Control inteligente de aplicaciones y comunicó el cambio. Se comprobó el estado desactivado antes de repetir los dos experimentos. Ambos finalizaron; los fallos y la configuración inicial de §6.6.4 permanecen preservados. La carpeta `R4-complemento/` contiene fuentes, hashes, comandos, toolchain, estado de Windows, resultados Criterion, CSV y corpus público de verificación. El equipo y el perfil optimizado se mantienen; las series no son una comparación pareada y el cambio de configuración forma parte de su procedencia.

ML-DSA utiliza 50 muestras, calentamiento de un segundo y objetivo de medición de dos segundos. Se informa la mediana con IC bootstrap del 95 % para cada operación y nivel. En esta ejecución, ML-DSA-65 verifica en 84,61 µs. Frente a los 149,05 µs de ECDSA y 98,07 µs de RSA-2048 de la ejecución anterior del mismo día, se observa menor latencia en los perfiles ensayados; no se atribuye una diferencia causal a un único cambio ni se generaliza a otras bibliotecas o cargas.

**Tabla 6.13 — Complemento R4: ML-DSA; mediana e IC 95 %, microsegundos.**

| Operación / nivel | n | Mediana (µs) | IC 95 % (µs) |
|---|---:|---:|---:|
| Generación / dilithium2 | 50 | 92,23 | 92,01–92,42 |
| Generación / dilithium3 | 50 | 155,88 | 155,59–156,54 |
| Generación / dilithium5 | 50 | 212,23 | 211,94–213,10 |
| Firma y verificación / dilithium2 | 50 | 262,17 | 258,73–268,67 |
| Firma y verificación / dilithium3 | 50 | 420,58 | 412,10–428,34 |
| Firma y verificación / dilithium5 | 50 | 522,90 | 511,96–531,28 |
| Firma / dilithium2 | 50 | 208,72 | 205,07–212,06 |
| Firma / dilithium3 | 50 | 326,04 | 319,84–334,22 |
| Firma / dilithium5 | 50 | 387,47 | 381,36–394,63 |
| Verificación / dilithium2 | 50 | 52,96 | 52,88–53,06 |
| Verificación / dilithium3 | 50 | 84,61 | 84,50–84,76 |
| Verificación / dilithium5 | 50 | 137,07 | 136,84–137,29 |

**Tabla 6.14 — Complemento R4: verificaciones/s de ML-DSA-65 con inicio coordinado.**

| Hilos | Mediana (verif./s) | Mínimo–máximo | Razón frente a 1 hilo |
|---:|---:|---:|---:|
| 1 | 12349 | 10508–12526 | 1,00 |
| 2 | 24697 | 21732–24872 | 2,00 |
| 4 | 45827 | 44242–46249 | 3,71 |
| 8 | 72945 | 72112–74090 | 5,91 |
| 12 | 95440 | 89498–95527 | 7,73 |
| 16 | 111036 | 104171–112234 | 8,99 |
| 20 | 125413 | 116166–127015 | 10,16 |
| 24 | 136390 | 130148–140047 | 11,04 |

**Ensayo multinúcleo corregido.** Cada repetición verifica un corpus de 4096 mensajes y firmas ML-DSA-65. Los trabajadores esperan en barreras, comparten el inicio y el denominador cubre la finalización de todos los hilos. Hay cinco repeticiones por punto, al menos un segundo por repetición y orden ascendente/descendente alternado. No se fijó afinidad ni se aisló la CPU del sistema operativo. Los rangos representan mínimos y máximos de las cinco repeticiones; la razón usa las medianas respecto de un hilo, sin afirmar que sea una estimación pareada.

Las medianas pasan de **12.349 verificaciones/s con un hilo a 136.390 con 24**, razón 11,04. La cifra histórica de 199.218 queda como antecedente con posible sesgo temporal; el nuevo resultado no permite atribuir toda la diferencia al reloj, pues las condiciones y repeticiones también cambian. Ninguna cifra mide transacciones completas, consenso, persistencia o generación STARK. El corpus conservado contiene únicamente mensajes, claves públicas y firmas.

---

## 6.7 Limitaciones y alcance de la validación

Se declaran explícitamente las fronteras de esta validación formal:

- **Modelo de caja negra / QROM.** El análisis citado se refiere a la inforjabilidad del esquema bajo sus hipótesis; la correspondencia concreta sigue pendiente. Quedan fuera los canales laterales (temporización, consumo) y los ataques por fallos, relevantes en hardware real.
- **Alcance de la inforjabilidad.** §6.4 expone fundamentos de seguridad del primitivo y obligaciones de correspondencia pendientes. Una transacción requiere además verificar identidad, mensaje autorizado y vigencia de la clave; la integridad del libro mayor depende del consenso y de las transiciones de estado. No se deduce una garantía del sistema completo de una reducción del esquema de firma.
- **Aceptación heredada comprobada.** Las pruebas R4 reproducen que el verificador puede aceptar cuatro bytes sin STARK si coinciden las entradas públicas, y marcar la raíz como verificada. Con un STARK válido, la ruta heredada omite comprobar tipo, altura y entradas exteriores. Esta aceptación no respalda seguridad de transiciones ni el anclaje del registro R3.
- **Raíces y variante TG2.** El puente heredado ignora los últimos 24 bytes de cada raíz; además, reducir los ocho primeros módulo Goldilocks produce alias. La variante experimental `tg2_canonical_verifier.rs` valida tipo, contexto esperado, serialización completa, límites, elementos canónicos, estructura y STARK. Admite exclusivamente escalares menores que el primo en ocho bytes y 24 bytes finales nulos. Los rechazos al modificar cualquiera de los 32 bytes se interpretan dentro de ese dominio: no prueban la vinculación de hashes arbitrarios de 256 bits. La altura se compara con el contexto confiable, pero no pertenece al enunciado del AIR; la aplicación debe impedir repeticiones. La variante no sustituye al verificador heredado ni está integrada en la cadena.
- **Ausencia de garantía de conocimiento cero.** En una prueba de 16 filas, las aperturas públicas permiten interpolar el polinomio de traza y recuperar su segunda fila, el testigo. Este caso se reproduce en una prueba automatizada; el PoC no implementa enmascaramiento de la traza. La etiqueta histórica ZK del modo no acredita ocultación del testigo.
- **Presupuesto de soundness.** La auditoría de §6.7.1 identifica consultas efectivas, transcripción, proximidad y obligaciones de composición. §6.7.2 desarrolla el paso algebraico bajo hipótesis explícitas. La cifra histórica de 100 bits no se acredita para el ejecutable. El análisis clásico citado no se convierte automáticamente en una cota QROM para NEXUS [BGK+23; BT24].
- **Alcance de las pruebas de software.** `cargo check`, `cargo build` y las 197 pruebas del workspace pasan: R4 agregó quince casos del verificador y tres de sincronización/conteo; R5 añadió tres de representación y reconstrucción desde semilla; R1 añade tres de correspondencia funcional; las revisiones de solidez, álgebra y proximidad incorporan siete casos cada una; la variante vinculada agrega diez. La suite completa usa desarrollo, con 12 bits de grinding. Los tres grupos de siete casos y los diez de la variante también pasan en sus ejecuciones release, con 20 bits para AIR; las mediciones STARK optimizadas conservan ese perfil. La suite prueba casos concretos, sin demostrar soundness general, resistencia a todos los mensajes hostiles o seguridad del sistema completo. El AIR es una recurrencia ilustrativa y no ejecuta la lógica L2 ni verifica firmas ML-DSA.
- **Tensión de diseño (apuntada para el Cap. 3).** Probar la verificación de Dilithium dentro de un STARK es costoso; las firmas *hash-based* son más STARK-friendly. La elección de Dilithium optimiza la verificación directa a costa de fricción con la agregación probada; se discute como decisión consciente en el Cap. 3.

### 6.7.1 Auditoría del presupuesto STARK

**Parámetros efectivos.** El código usa dominio $N=8T$, cota FRI de grado menor que $2T$ y $\log_2(2T)$ capas. La tasa nominal es $1/4$. Se extraen $\min(40,4T)$ índices distintos para parejas de puntos opuestos. El presupuesto heredado devuelve 100 independientemente de $T$ y del perfil; las pruebas comprueban esa discrepancia para cuatro y ocho filas. La variante TG2 exige al menos 16 filas.

**Tabla 6.15 — Parámetros efectivos del PoC STARK por tamaño de traza.**

| Filas T | Dominio N | Cota de grado | Capas FRI | Consultas distintas | Perfil TG2 |
|---:|---:|---:|---:|---:|:---:|
| 4 | 32 | < 8 | 3 | 16 | No |
| 8 | 64 | < 16 | 4 | 32 | No |
| 16 | 128 | < 32 | 5 | 40 | Sí |
| 64 | 512 | < 128 | 7 | 40 | Sí |
| 256 | 2048 | < 512 | 9 | 40 | Sí |
| 1024 | 8192 | < 2048 | 11 | 40 | Sí |
| 4096 | 32768 | < 8192 | 13 | 40 | Sí |
| 262144 | 2097152 | < 524288 | 19 | 40 | Sí |

**Transcripción y trabajo.** Se absorben enunciado —inicio, salida y filas— y raíz de traza antes de los tres coeficientes de composición. Cada raíz FRI precede a su coeficiente de plegado; siguen el valor final, el nonce validado y los índices. Las pruebas verifican rechazo al cambiar campos del enunciado, compromiso o valor final. El probador busca el primer nonce válido, pero el verificador admite otros: una prueba con ocho bits de trabajo encuentra dos nonces aceptables y retos distintos. El grinding encarece volver a muestrear; no lo imposibilita. Los perfiles AIR usan 12 bits en desarrollo y 20 en release.

**Proximidad frente a grado exacto.** FRI trata la distancia a un código Reed–Solomon [FRI18]. El ensayo aislado compromete 512 valores, todos cero salvo uno, y usa cero en las capas posteriores. Su interpolación tiene grado 511 y la distancia a la palabra cero es $1/512$. Con cota 128, 28 de 32 contextos públicos fijos aceptan y cuatro rechazan: el resultado coincide exactamente con consultar o evitar la pareja inconsistente. Bajo muestreo uniforme de 40 parejas sin reemplazo, la probabilidad de evitarla sería $216/256$. Los 32 casos no estiman una probabilidad criptográfica; muestran que aceptar proximidad no prueba pertenencia exacta. El ensayo no contiene un enunciado AIR falso aceptado ni rompe una garantía de FRI.

**Paso desde el AIR.** El probador honesto interpola una traza de grado menor que $T$; el verificador comprueba aperturas locales y ejecuta FRI sobre la composición. No realiza una prueba FRI separada de la traza. Debe justificarse el paso desde esas comprobaciones a una ejecución válida, incluyendo adversarios que comprometan funciones arbitrarias y la proximidad correlacionada necesaria [BGK+23, Teorema 4.6 y §6]. La derivación condicional de §6.7.2 avanza este paso; la premisa de proximidad propuesta se refuta en §6.7.3, sin demostrar un enunciado falso aceptado.

**Modelo y pérdidas.** En el marco clásico citado por [BT24, Lema 1, p. 7], la transformación BCS relaciona el error por ronda y la longitud del oráculo con el presupuesto adversario:

$$
\epsilon_{\mathrm{FS}}\leq Q\epsilon_{\mathrm{RBR}}
 + \frac{3(Q^2+1)}{2^\kappa}.
$$

La fórmula requiere el protocolo y las hipótesis del resultado. Su §3.2 trata el grinding como factor del término de consultas; no elimina los otros errores. Se conserva un cálculo de referencia con tasa $1/4$, 40 consultas y 20 bits, separado de cualquier cota de NEXUS. Faltan la correspondencia de la transcripción concreta, el muestreo, la composición AIR/FRI/Merkle y una justificación cuántica aplicable.

**Campo y API.** Los retos reducen dos bloques de 128 bits módulo Goldilocks. Bajo bytes uniformes ideales, el cálculo exacto da variación total cercana a $2^{-96}$ por coordenada; se conserva también la probabilidad puntual máxima. No se deduce de ello un ataque ni un techo de 96 bits para todo el protocolo. La API Merkle de bajo nivel presupone un índice en rango: el ensayo acepta el mismo camino para 3 y 19 en un árbol de 16 hojas. AIR deriva índices válidos; este caso delimita la precondición de la API y no demuestra una aceptación indebida en esa ruta.

**Resultado.** Siete pruebas nuevas, ejecutadas en ambos perfiles, y el análisis reproducible identifican el comportamiento y los supuestos pendientes. Se mantienen sin atribuir bits de seguridad al PoC hasta justificar la relación completa entre enunciado, oráculos y rechazo.

### 6.7.2 Reducción algebraica condicional del AIR

**Hipótesis.** Se fija un polinomio de traza $f\in\mathbb{F}_p[X]$ de grado menor que $T$, junto con inicio $s$ y salida $o$, antes de elegir tres coeficientes independientes $\alpha_j\in\mathbb{F}_{p^2}$. Sea $g$ de orden $T$, $h_1=g^{T-1}$, $h_2=g^{T-2}$ y $D=X^T-1$. El dominio $L=7\langle\omega\rangle$, de tamaño $N=8T$, es disjunto de las raíces de $D$ y satisface $g=\omega^8$. El cálculo de referencia comprueba estas propiedades para los 17 tamaños del perfil. La transición se expresa mediante $C(X)=f(g^2X)-f(gX)^2-f(X)^2$.

**Divisibilidad.** Al llevar las tres restricciones a denominador común se obtienen:

$$
\begin{aligned}
N_0&=(f-s)D/(X-1),\\
N_1&=(f-o)D/(X-h_1),\\
N_2&=C(X)(X-h_1)(X-h_2).
\end{aligned}
$$

Sea $R_j=N_j\bmod D$. La traza es válida si y solo si los tres residuos individuales son cero. En efecto, $D$ tiene raíces simples: los dos primeros numeradores detectan sus respectivas fronteras y el tercero detecta la transición en los otros $T-2$ puntos. Para una traza válida, los cocientes de frontera tienen grado a lo sumo $T-2$ y el de transición a lo sumo $T$. Su combinación cumple la cota FRI de grado menor que $2T$.

**Cancelación.** Definimos $N_\alpha=\sum_{j=0}^2\alpha_jN_j$ y $R_\alpha=N_\alpha\bmod D$. Para una traza inválida fijada previamente, algún residuo individual tiene una coordenada no nula. Condicionados los otros dos coeficientes, a lo sumo un valor del restante anula esa coordenada. Así, con retos uniformes independientes, $\Pr[R_\alpha=0]\leq 1/p^2$. Con distribuciones independientes de masa puntual máxima $\mu$, la cota es $\mu$. El análisis conserva su valor exacto para la reducción modular de bytes ideales. Esta cuenta no incluye intentos adaptativos de Fiat–Shamir.

La cancelación existe: para $T=16$, se cambia de 3 a 4 la primera fila de una traza honesta cuya segunda fila es 5, manteniendo inicio público y salida. Con $\alpha_0=10376293027944593777$ y $\alpha_1=\alpha_2=1$, las infracciones de frontera y transición se cancelan y la composición tiene grado 16. Se eligieron los coeficientes algebraicamente; no se forzaron retos SHA3. El enunciado conserva la traza honesta alternativa: este caso no demuestra aceptación de un enunciado falso.

**Distancia.** En $L$, sea $c_f=N_\alpha/D$ y sea $\mathrm{RS}$ el código de evaluaciones de grado menor que $2T$ sobre $\mathbb{F}_{p^2}$. Si $R_\alpha\ne0$, para cualquier candidato $h$ de ese grado, $N_\alpha-Dh$ es no nulo y tiene grado a lo sumo $3T-1$. Cada acuerdo con $c_f$ es una raíz; por tanto, la distancia de Hamming relativa cumple:

$$
\operatorname{dist}(c_f,\mathrm{RS})\geq\frac{5T+1}{8T}.
$$

**Transferencia condicional.** Si un oráculo $u:L\to\mathbb{F}_p$ difiere de ese mismo $f$ inválido en una fracción $\varepsilon$ de puntos, y ambos están fijados antes de los retos, su composición local cambia en a lo sumo $3\varepsilon N$ posiciones: usa $u(x)$, $u(gx)$ y $u(g^2x)$. Fuera de la cancelación, la desigualdad triangular da:

$$
\operatorname{dist}(c_u,\mathrm{RS})\geq
\max\left\{0,\frac{5T+1}{8T}-3\varepsilon\right\}.
$$

**Tabla 6.16 — Distancias mínimas condicionales de la composición al código.**

| Filas T | Dominio N | Traza polinómica exacta | Traza a distancia ≤ 1/24 |
|---:|---:|---:|---:|
| 16 | 128 | 0,632812 | 0,507812 |
| 64 | 512 | 0,626953 | 0,501953 |
| 256 | 2048 | 0,625488 | 0,500488 |
| 4096 | 32768 | 0,625030 | 0,500030 |
| 262144 | 2097152 | 0,625000 | 0,500000 |

Las columnas presuponen una traza polinómica inválida y ausencia de cancelación; son cotas inferiores redondeadas hacia abajo a seis decimales. Con $\varepsilon\leq1/24$, la cota exacta supera $1/2$. No son probabilidades de rechazo de FRI.

**Resultado y límite.** Siete pruebas nuevas contrastan divisibilidad en 21 trazas válidas, errores individuales, cancelación, identidad residual, transferencia y correspondencia con aperturas reales del probador. Pasaron en desarrollo y release; en esa etapa el workspace alcanzó 180 pruebas. El argumento escrito avanza la reducción algebraica bajo sus hipótesis. La transferencia no establece la proximidad de la traza; §6.7.3 muestra que la aceptación heredada no implica la premisa propuesta. Se requiere otra ruta de extracción o una comprobación adicional vinculada al AIR. La correspondencia con resultados de proximidad correlacionada [BGK+23, Teorema 4.6 y §6], las pérdidas Fiat–Shamir y la revisión matemática independiente siguen pendientes.

### 6.7.3 Contraejemplo a la premisa de proximidad de la traza

**Construcción.** Sea $f$ el interpolante de grado menor que $T$ de una ejecución válida y sea $\lambda\ne0$ del campo base. Se compromete sobre el mismo dominio $L$ la función dada por:

$$
F(X)=f(X)+\lambda(X^T-1).
$$

El polinomio $F$ tiene grado exactamente $T$ y coincide con $f$ en el subgrupo de las filas, por lo que conserva ambas fronteras y todas las transiciones. En el coset $L$, ambas funciones difieren en cada posición. Los cocientes de frontera tienen grado $T-1$. La transición de $F$ tiene grado $2T$, con coeficiente principal $-2\lambda^2$; al dividir por su anulador, de grado $T-2$, resulta grado $T+2$. Así, la composición tiene grado a lo sumo $T+2<2T$ para $T\geq4$, sin requerir cancelación excepcional de los retos.

**Distancia exacta.** Para cualquier polinomio $h$ de grado menor que $T$, incluso sobre la extensión cuadrática, $F-h$ tiene grado $T$ y a lo sumo $T$ raíces en $L$. La cota se alcanza tomando $h=F-\lambda\prod_{i=1}^{T}(X-x_i)$ para $T$ puntos distintos de $L$: se cancela el término principal y quedan exactamente $T$ acuerdos. Por tanto:

$$
\operatorname{dist}(F|_L,\mathrm{RS}_{<T}(L))=\frac{8T-T}{8T}=\frac78.
$$

**Ejecución.** Con inicio 3, segunda fila 5 y $\lambda=1$, el verificador heredado acepta los casos de 16, 32 y 64 filas de la Tabla 6.17. Se usan la transcripción SHA3, los compromisos Merkle, FRI y el grinding reales, en desarrollo y release; no se eligen los coeficientes ni se omiten comprobaciones. FRI recibe una composición que pertenece a su código objetivo. Las aperturas locales proceden del mismo compromiso de traza.

**Tabla 6.17 — Trazas alejadas aceptadas y control exhaustivo TG2.**

| Filas T | Grado traza | Cota grado CP | Distancia | Legado | Control TG2 |
|---:|---:|---:|:---:|:---:|:---:|
| 16 | 16 | ≤ 18 | 7/8 | Acepta | Rechaza |
| 32 | 32 | ≤ 34 | 7/8 | Acepta | Rechaza |
| 64 | 64 | ≤ 66 | 7/8 | Acepta | Rechaza |

La distancia se refiere al código de traza de grado menor que $T$; la cota de grado CP es inclusiva. El control TG2 de la última columna recibe el LDE completo y rechaza por grado. Los tres enunciados son válidos: el testigo original conserva una ejecución correcta. Estos casos refutan la implicación «aceptación implica proximidad de la traza a distancia a lo sumo $1/24$», pero no constituyen una falsificación de enunciado ni invalidan todo posible argumento de solidez.

**Control exhaustivo de referencia.** Una variante experimental TG2, limitada a 4–256 filas, reconstruye la raíz del LDE suministrado, interpola en el coset, exige grado menor que $T$ y comprueba todas las fronteras y transiciones. Además ejecuta el verificador heredado. Acepta el caso honesto y rechaza los tres oráculos alejados. Requiere $N=8T$ elementos adicionales, $O(N\log N)$ operaciones y $O(N)$ memoria; revela la traza y no ofrece conocimiento cero. Su vínculo con un compromiso previo depende de la vinculación de Merkle. Se utiliza como control exacto de ensayo, sin integración en producción.

**Consecuencia.** La premisa propuesta no puede demostrarse para el legado. El argumento de §6.7.2 conserva su validez condicional; para el legado se requiere una extracción alternativa. §6.7.4 implementa una comprobación adicional vinculada al AIR como variante TG2. Anexar una prueba FRI sobre otro vector no basta. La transcripción, la correspondencia de compromisos y las pérdidas de composición requieren su propio análisis [BGK+23]. Siete pruebas nuevas cubren la familia algebraica en 21 casos, las aceptaciones reales, la distancia y el control exhaustivo. Pasaron en ambos perfiles; en esa etapa la suite completa alcanzó 187 pruebas en desarrollo. Se conservan seis pruebas binarias públicas y un contraste numérico independiente.

### 6.7.4 Variante con FRI de traza vinculada al AIR

**Diseño experimental.** La variante TG2 añade un recorrido FRI de traza, con cota de grado menor que $T$, al recorrido de composición, con cota menor que $2T$. Admite potencias de dos entre 16 y 4096 filas y mantiene $N=8T$. El árbol de traza codifica cada valor base como $(u,0)$ en la extensión, con 16 bytes canónicos de coordenadas; el hash de hoja recibe 17 bytes al añadir el prefijo de dominio. Las aperturas AIR y la primera capa FRI de traza deben referirse a una única raíz:

$$
R_{\mathrm{traza,AIR}}=R_{\mathrm{traza,FRI},0}.
$$

El formato y la transcripción son distintos del legado, cuyo árbol de traza usa hojas de ocho bytes. La variante se mantiene fuera de producción. La igualdad de compromisos se verifica explícitamente; su vinculación criptográfica conserva el supuesto de Merkle.

**Transcripción.** El dominio de versión 1 absorbe perfil, enunciado y raíz de traza antes de los tres coeficientes de composición. Siguen las fases etiquetadas de FRI de traza y composición, cada una con raíces, retos y valor final. Se valida el nonce antes de derivar 40 índices comunes de parejas, sin reemplazo. El perfil fija las dos cotas y los bits de trabajo, comprobados por el verificador: 12 en desarrollo y 20 en release. En cada consulta se verifican seis aperturas de traza, la coincidencia con su FRI, la composición local y ambos plegados.

**Resultados.** La variante acepta ejecuciones honestas de 16, 64, 256 y 4096 filas. Para los tres contraejemplos de §6.7.3 se reutiliza el LDE conservado y se genera una prueba bajo el protocolo nuevo: el rechazo ocurre en FRI de traza. Sus certificados originales siguen siendo aceptados por el legado; no se confunde incompatibilidad de formato con detección del caso. Diez pruebas cubren además enunciado, versión, perfil, raíces, canonicidad, formas, caminos, restricciones y reconstrucción independiente de la transcripción. Pasan en desarrollo y release; el workspace alcanza 197 pruebas.

**Tabla 6.18 — Formato de la variante con FRI de traza vinculada.**

| Filas T | Capas traza / CP | Consultas | Enunciado y prueba (B) | Solo LDE completo (B) |
|---:|:---:|---:|---:|---:|
| 16 | 4 / 5 | 40 | 196574 | 1024 |
| 64 | 6 / 7 | 40 | 306782 | 4096 |
| 256 | 8 / 9 | 40 | 437470 | 16384 |
| 4096 | 12 / 13 | 40 | 760286 | 262144 |

Los tamaños incluyen el enunciado y el certificado serializados. La última columna contiene solo los valores del LDE que solicita el control exhaustivo, sin su certificado STARK ni metadatos: no compara dos paquetes completos. La nueva prueba no incluye un vector de $N$ valores, pero en estos tamaños ocupa más que ese vector. Cada apertura conserva su propio camino Merkle; no se deduplican caminos.

**Costo y alcance.** El formato tiene comunicación y verificación $O(q\log^2N)$ para $q$ consultas, dentro del perfil declarado. Los tamaños se reproducen mediante una cuenta independiente de campos, raíces y caminos; no son benchmarks de latencia ni acreditan ahorro de bytes. Se preservan 14 certificados públicos de ambos perfiles.

El enlace estructural queda implementado y los ejemplos conocidos son detectados. FRI sigue siendo una comprobación probabilística de proximidad [FRI18]; su aceptación no implica pertenencia exacta ni establece por sí sola el umbral $1/24$ del argumento anterior. La sección siguiente deriva una cota conservadora para el modelo interactivo con oráculos ideales. Su transferencia a Merkle y Fiat–Shamir, incluida la versión QROM, sigue pendiente [BGK+23]. Las aperturas no están enmascaradas: no se acredita conocimiento cero. La revisión matemática independiente y la cota global de solidez permanecen pendientes.

### 6.7.5 Composición en el modelo interactivo ideal

**Hipótesis y correspondencia.** Se consideran oráculos inmutables con valores en $K=\mathbb{F}_{p^2}$, retos uniformes independientes y $q=40$ parejas distintas, elegidas después de todas las capas y constantes finales. El oráculo de traza $u$ y el enunciado se fijan antes de los coeficientes AIR; la composición $v$ puede depender de ellos. Esta idealización requiere una justificación adicional para el compromiso Merkle y el canal SHA3 implementados.

El Corolario 5.5 de [BGK+23, versión del 15 de febrero de 2024, p. 34] acota el error FRI por ronda dentro del radio de decodificación única. El cambio de variable $x=a_jy$, con $a_j=7^{2^j}$, lleva cada coset a un subgrupo y transforma el reto de plegado en $\beta/a_j$, todavía uniforme en $K$. La fórmula par/impar y el envío de la constante final corresponden al Algoritmo 1 de esa fuente. Para una transcripción fija, consultar parejas sin reemplazo no aumenta la probabilidad de que todas sean aceptables. Las tasas $1/8$ y $1/4$ admiten umbrales $\delta_t\leq7/16$ y $\delta_c\leq3/8$. Sumando conservadoramente las $k_i+1$ rondas de cada FRI, incluidas las consultas:

$$
E_i=\min\{1,(k_i+1)\max\{N/p^2,(1-\delta_i)^q\}\},\quad i\in\{t,c\}.
$$

Aquí $k_t=\log_2T$ y $k_c=\log_2(2T)$. El error por ronda no se utiliza como si fuera el error total.

**Candidato fijo y campo base.** La distancia mínima del código de traza es $(N-T+1)/N$. Como $2\delta_t$ es menor que esa distancia, existe a lo sumo un polinomio $f$ de grado menor que $T$ próximo a $u$. Cuando existe, queda determinado antes de los retos AIR. Si $f=A+zB$ tiene $B\ne0$, toma valores base en a lo sumo $T-1$ puntos de $L$: son raíces de $B$. Por tanto, $u$ tiene valores fuera del campo base en una fracción al menos $1-(T-1)/N-\delta_t$, detectables por las aperturas AIR principales. Esta cuenta permite considerar oráculos adversarios sobre la extensión.

**Distancia y enlace.** Para un enunciado sin traza válida sobre el campo base, un candidato $f$ con coeficientes base es inválido. S1 acota la cancelación por $1/p^2$. Fuera de ese evento, la transferencia de §6.7.2 y la cercanía de $v$ al código de composición dan:

$$
\operatorname{dist}(v,c_u)\geq d=\frac{5T+1}{8T}-3\delta_t-\delta_c.
$$

Se exige $d>0$. Con $M=N/2$, existen al menos $b=\lceil dM\rceil$ parejas que contienen una discrepancia. La probabilidad ideal de omitirlas es como máximo $H=\binom{M-b}{q}/\binom{M}{q}$, con $H=0$ si $M-b<q$. El caso del candidato fuera del campo base tiene una fracción de fallos mayor que $d$ y queda cubierto por el mismo término.

**Proposición de esta revisión.** Bajo las hipótesis anteriores, una unión de los eventos de traza lejana, composición lejana, cancelación y omisión local produce:

$$
\Pr[\mathrm{aceptar\ un\ enunciado\ falso}]\leq E_{\mathrm{ideal}}=\min\{1,p^{-2}+E_t+E_c+H\}.
$$

Si $u$ está lejos, aceptar requiere el error del FRI de traza. Si está cerca, se usa el candidato único: el caso no base exige omisión local; en el caso base se separa la cancelación y, después, la composición lejana o su discrepancia con $c_u$. Estos dos casos del candidato son excluyentes, de modo que basta un término $H$. Las consultas comunes no se suponen independientes entre recorridos; se suman cotas de error. La derivación depende de S1 y está pendiente de revisión matemática independiente.

**Tabla 6.19 — Cota conservadora de aceptación en el modelo interactivo ideal.**

| Filas T | Rondas FRI traza / CP | Consultas | Cota superior ideal |
|---:|:---:|---:|---:|
| 16 | 5 / 6 | 40 | 0,052736 |
| 64 | 7 / 8 | 40 | 0,074258 |
| 256 | 9 / 10 | 40 | 0,095099 |
| 4096 | 13 / 14 | 40 | 0,134071 |

Se eligió $\delta_t=\delta_c=1/8$, por lo que $d=1/8+1/(8T)$. Las rondas incluyen la consulta final; la Tabla 6.18 cuenta solo capas. Los valores se redondean hacia arriba desde fracciones exactas. El script de análisis verifica nueve tamaños, unicidad y campo base en ejemplos exhaustivos pequeños, localidad, muestreo y normalización del plegado. La suite Rust conserva 197 pruebas; esta etapa no altera el protocolo.

**Límite de la conclusión.** Son cotas superiores conservadoras del modelo ideal, no tasas observadas de ataque ni límites inferiores de vulnerabilidad. El argumento no acredita 100 bits y no cuantifica la seguridad del ejecutable. La derivación histórica deja esas obligaciones abiertas; §§6.7.8–6.7.10 incorporan los complementos posteriores por rondas y ROM con su estado de revisión, y mantienen QROM como trabajo futuro. No se demuestra extracción eficiente ni conocimiento cero.

### 6.7.6 Vinculación Merkle y auditoría Fiat–Shamir

**Correspondencia comprobada.** La auditoría del 23 de septiembre reconstruye los 14 certificados públicos mediante Python y hashlib: decodificación del formato, canonicidad, transcripción SHA3, trabajo del nonce, 560 consultas y 18.880 aperturas Merkle. Las aperturas AIR y el primer FRI de traza usan la misma codificación $(u,0)$ y la misma raíz. Este contraste no recalcula los plegados ni la composición AIR; los certificados de trazas lejanas tienen aperturas auténticas aunque el verificador completo los rechace. La suite Rust mantiene 197 pruebas, con check y build repetidos correctamente.

**Vinculación y oráculos.** Fijados raíz, tamaño e índice válido, dos aperturas aceptadas de valores canónicos distintos permiten obtener una colisión SHA3. Si coinciden los hashes de hoja, las dos entradas de hoja colisionan; si difieren, el primer padre coincidente tiene entradas distintas. La variante exige profundidad exacta y deriva índices dentro del dominio. Esta propiedad no demuestra que una raíz arbitraria permita extraer un vector completo fijado antes de los retos: el paso a oráculos ideales conserva una obligación de compilación.

Las hojas y nodos tienen prefijos distintos; las absorciones del canal incluyen etiqueta y longitud. Se cotejaron perfil, enunciado, raíces, fases, valores finales y nonce. La gramática concreta se inspeccionó para los 18 perfiles admitidos. El mismo SHA3 sirve a Merkle y al canal: se debe justificar su modelado conjunto, incluyendo reinicios y prefijos repetidos, antes de sustituirlo por monedas independientes.

**Distribución de retos.** Para $S=2^{128}=ap+r$, un bloque uniforme reducido módulo $p$ tiene distancia de variación total a la uniforme:

$$
\Delta_F=\frac{r(p-r)}{pS},\qquad\Delta_K\leq2\Delta_F.
$$

En Goldilocks, $r=p-2^{32}$ y $\Delta_F\approx1{,}26218\times10^{-29}$. La variante consume de 12 a 28 retos de extensión. Bajo bloques frescos uniformes e independientes de la historia, el reemplazo cambia la probabilidad de un evento en a lo sumo $2m\Delta_F$, menor que $7{,}069\times10^{-28}$ para $m=28$. Es una cuenta híbrida del sesgo de reducción, no la pérdida total de Fiat–Shamir: no cubre la búsqueda entre transcripciones ni las consultas adaptativas al hash.

**Grinding.** El verificador acepta cualquier nonce que satisface el trabajo, aunque el probador ordinario busque el primero. Un contexto público de ensayo con 12 bits produce los nonces 904 y 1233, ambos válidos y con consultas diferentes; la suite Rust también contrasta nonces alternativos. Este resultado no es una falsificación AIR. Impide tratar el trabajo como unicidad de transcripción o sumar automáticamente sus bits al presupuesto de solidez.

**Tabla 6.20 — Correspondencia y obligaciones de compilación.**

| Aspecto | Evidencia disponible | Obligación pendiente |
|---|---|---|
| Merkle | Forma validada, raíz común y aperturas contrastadas | Modelado y extracción de oráculos |
| Canal | Orden y bytes reconstruidos independientemente | Correspondencia con la transformación formal |
| Retos | Sesgo exacto bajo salidas frescas uniformes | Consultas adaptativas y reinicios |
| AIR y dos FRI | Cota ordinaria del modelo ideal | Propiedades y errores del protocolo por ronda |
| ROM/QROM | Teorema de compilación identificado | Presupuesto de consultas, grinding y pérdidas concretas |

El Teorema 3.15 de [BGK+23, p. 25] exige propiedades por ronda y una transformación BCS determinada. La cota ordinaria $E_{\mathrm{ideal}}$ de §6.7.5 no sustituye automáticamente su error por ronda. El teorema para FRI aislado tampoco valida por sí solo el AIR y ambos recorridos con consulta compartida. La auditoría por sí sola no establece una garantía ROM/QROM del ejecutable, 100 bits ni conocimiento cero. La transferencia posterior propuesta en ROM clásico se integra en §6.7.9 con sus hipótesis y dictamen pendiente. Se preparó un paquete para revisión matemática de S1–S3; el dictamen independiente permanece pendiente.

---

### 6.7.7 Revisión de las afirmaciones heredadas de TG1

La validación del Objetivo 4 revisa las afirmaciones del prototipo heredado sin modificar el alcance ni los entregables administrativos aprobados de TG1. En esta edición de TG2, el diseño de los capítulos 3 y 4 se interpreta con las condiciones de correspondencia de R1 y los resultados de §6.7. Una decisión de arquitectura, una operación de firma que funciona y una demostración de seguridad son aportes con obligaciones distintas.

La afirmación histórica de aproximadamente 100 bits del STARK combinaba errores de campo, consultas y trabajo del nonce sin una transferencia completa al canal concreto. El campo de extensión amplía el espacio de retos, pero no fija por sí solo la solidez del verificador. El trabajo tampoco impide volver a intentar una transcripción: su efecto depende del presupuesto y del modelo adversario. Por estas razones, esa cifra se conserva como antecedente de diseño y no como garantía vigente. Los comentarios de `stark/channel.rs`, el indicador de `stark/params.rs` y la asociación hash/protocolo de `stark/merkle.rs` pertenecen a ese antecedente; su presencia en el código no acredita aquellas garantías.

Las pruebas heredadas aceptan los tres oráculos alejados de §6.7.3; sus enunciados públicos conservan una traza válida. Este resultado refuta la premisa de proximidad utilizada en aquel argumento, sin demostrar una falsificación de un enunciado falso. La variante vinculada TG2 v1 incorpora un FRI de traza y una raíz común con AIR; el corpus comprueba esa diferencia de comportamiento. El AIR evalúa una recurrencia ilustrativa y no la verificación de ML-DSA ni la lógica completa de una aplicación.

**Tabla 6.21 — Afirmaciones heredadas y alcance de la revisión TG2.**

| Afirmación de diseño o del prototipo | Conclusión de validación TG2 | Referencia |
|---|---|---|
| STARK endurecido a aproximadamente 100 bits | Garantía no acreditada; cotas específicas de modelo y presupuesto | §§6.7.8–6.7.9 |
| Aceptación implica proximidad de la traza | Premisa refutada para el legado; variante vinculada comprobada en el corpus | §§6.7.3–6.7.4 |
| PoC proporciona conocimiento cero | El testigo de 16 filas es recuperable; ocultación pendiente | §6.7.1 |
| La PoC valida transacciones completas | AIR demostrativo; verificación ML-DSA y lógica de aplicación sin aritmetizar | §§6.6.5 y 6.7.4 |
| Firma funcional implica garantía concreta de inforjabilidad | Perfil identificado; correspondencia, semillas, codificación y errores requieren R1-A–E | §6.4 |
| Hash de la clave pública impide toda recuperación | Evita exposición directa mientras la clave no se revele; no demuestra dureza de preimagen ni seguridad integral | §§1.2 y 6.4.3 |

### 6.7.8 Solidez por rondas del protocolo ideal

La derivación posterior desarrolla una función de estado para AIR, FRI de traza, FRI de composición y consulta compartida. Su punto de partida es el enfoque de solidez por rondas de [GMW26, Teorema 5.2]; se utiliza un lema elemental de acuerdo suficiente para los radios de NEXUS, sin atribuir a este trabajo el resultado general del artículo. Los modelos ideales de estado, rondas y reinicios tienen componentes mecanizados en Lean y una auditoría registrada en `formalizacion/`; la correspondencia integral con el ejecutable y la revisión independiente permanecen pendientes.

**Hipótesis.** Sea $p=2^{64}-2^{32}+1$, $K=F_{p^2}$, $N=8T$, $M=N/2$, con $T$ potencia de dos entre 16 y 4096. El oráculo de traza $u$ se fija antes de los tres coeficientes AIR; cada capa FRI queda fijada antes de su reto uniforme fresco. La composición puede depender de la historia previa, las constantes finales preceden al muestreo y se eligen $q=40$ parejas opuestas distintas, uniformemente y sin reemplazo. Las aperturas son evaluaciones de oráculos completos inmutables. Un enunciado falso carece de traza válida sobre el campo base.

Para los radios $\delta_t=\delta_c=1/8$, se verifica la unicidad $2\delta_t<(N-T+1)/N$ y, en cada plegado, $(1-3\delta_i)n_j>d_{i,j+1}-1$. El lema elemental conserva el mismo conjunto de acuerdo de las dos funciones del plegado, excepto para a lo sumo $n_j$ retos; su error condicional queda acotado por $n_j/p^2$. La ausencia de esas excepciones permite remontar los conjuntos de acuerdo desde la constante final. Una consulta compartida se contabiliza una sola vez, tomando el máximo del caso activo, sin multiplicar errores de ambos FRI.

Definimos, con numerador cero si no hay suficientes parejas,

$$
H(M,q,x)=\frac{\binom{M-\lceil xM\rceil}{q}}{\binom Mq},\qquad h_T=H(4T,40,1/8).
$$

La función de estado tiene un evento excepcional absorbente y una cota por ronda. Para este perfil, la cota escogida es $\varepsilon_{\mathrm{rbr}}=h_T$; esta igualdad identifica la cota empleada, no el error óptimo del protocolo. La cuenta ordinaria refinada obtiene

$$
E_{\mathrm{ideal}}^{\mathrm{nuevo}}\le h_T+\frac{8T-3}{p^2}.
$$

**Tabla 6.22 — Cotas superiores de la derivación ideal propuesta.**

| Filas $T$ | Cota ideal anterior | Cota ideal refinada |
|---:|---:|---:|
| 16 | 0,052736 | 0,000166165 |
| 64 | 0,074258 | 0,002934060 |
| 256 | 0,095099 | 0,004282720 |
| 4096 | 0,134071 | 0,004757331 |

Los decimales se redondean hacia arriba desde fracciones exactas. La mejora procede del argumento por casos; el protocolo y sus parámetros no cambian. Estos límites no son tasas observadas de ataque, ni garantizan SHA3 real. La derivación ideal ordinaria de §6.7.5 conserva su valor como antecedente; la transferencia siguiente desarrolla su propio registro hash y no sustituye automáticamente un error ordinario en un compilador Fiat–Shamir.

### 6.7.9 Transferencia propuesta al protocolo concreto en ROM clásico

El objeto es `NEXUS-TG2-LINKED-FRI-v1`, según el análisis del código `01dcde960402b6c60a19242b7ae3d6ac3d82a518` y las fuentes preservadas. Cada llamada a SHA3-256 se modela como una consulta a un único oráculo aleatorio clásico de 256 bits. El adversario dispone de $Q$ consultas, incluidas preparación, compromisos y búsqueda de nonces; entrega un enunciado y una prueba finales en un perfil fijo. No se admite ayuda correlacionada con el oráculo sin contabilizar. Esta demostración propuesta no establece seguridad incondicional de SHA3 ni una reducción QROM.

El registro hash extrae y congela los vectores cuando cada raíz se marca antes de su reto. Fuera del evento excepcional del grafo, una apertura aceptada coincide con ese vector. La gramática se trata conjuntamente: no se presupone una separación global de roles, pues las entradas de nodo y enunciado pueden coincidir en 65 bytes. La masa puntual máxima de un reto de extensión derivado de bloques ideales es

$$
\mu=\left(\frac{\lfloor2^{128}/p\rfloor+1}{2^{128}}\right)^2.
$$

Sea $m=3+\log_2T+\log_2(2T)$, $g$ el trabajo del nonce y $S=Q+V_T$. El análisis fija el corte auxiliar $R=512$ para la selección, con

$$
\tau_T=\min\left\{1,\binom{M}{39}\left(\frac{39}{M}\right)^{512}\right\}.
$$

Aquí $V_T$ acota las consultas hash del verificador truncado y $B_T$ las ocurrencias de digests de una prueba con forma admitida. Sus cuentas incluyen aperturas Merkle, canal y extracción de índices, según la derivación preservada. El Rust v1 conserva su selector original; el corte pertenece al análisis y al verificador Python de referencia. La fórmula propuesta es

$$
\begin{aligned}
E_{\mathrm{ROM}}(T,g,Q)&\le\min\left\{1,
\frac{S(49S+B_T)}{2^{256}}\right.\\
&\left.\quad +(Q+m)\frac{N\mu}{2}
+(Q+1)2^{-g}(h_T+\tau_T)\right\}.
\end{aligned}
$$

La revisión interna posterior justifica el término de candidatos mediante potencial. Cada candidato se cobra antes de su primera respuesta, con un conjunto fijo de parejas buenas. Respuestas frescas preservan el potencial en esperanza; abandono, intercalación, duplicados y la verificación final no incrementan gratuitamente la cuenta. Condicionar a haber encontrado un nonce válido elimina de esa probabilidad condicionada el factor $2^{-g}$: el factor se cobra al iniciar el intento. El argumento admite a lo sumo $Q+1$ inicios relevantes y trata la cola con un potencial separado.

Para $T=4096$, $g=20$ y $Q=2^{20}$, la cota superior conservada es 0,004757335454. Con $Q=2^{28}$ llega a uno y deja de ser informativa. Ningún valor constituye una tasa de ataques ni demuestra que el adversario alcance esa probabilidad. Los parámetros actuales no acreditan 100 bits.

El verificador independiente Python evalúa formato, canal, Merkle, composición AIR y ambos FRI sobre los 14 certificados preservados. Coincide con Rust: acepta ocho honestos y rechaza seis alejados. La revisión de nonces añade 96 escenarios pequeños y controles negativos de las premisas. Estas comprobaciones finitas apoyan la correspondencia y detectan errores; no sustituyen la demostración general ni el dictamen externo M1–M6.

### 6.7.10 Alcance QROM y trazabilidad de las afirmaciones

Los suplementos QROM conservan una reducción parcial basada en el trabajo, un extractor sin orden, una reducción condicional al verificador y una cota propuesta para la cola de índices. La omisión de parejas incorrectas $\beta^S$ sigue sin una cota útil demostrada. El límite de cola no resuelve esa omisión y sus exponentes no representan bits de seguridad global de AIR/FRI. Las hipótesis, el cambio de juego y las pérdidas cuánticas requieren revisión propia.

Por decisión del autor del 23 de septiembre, completar QROM de AIR/FRI es trabajo futuro. La consolidación documental no reanuda esa investigación ni convierte sus obligaciones en requisitos nuevos del cierre. R1 sobre ML-DSA mantiene su alcance específico.

El catálogo complementario relaciona doce afirmaciones con sus hipótesis, dependencias y evidencia identificada por SHA-256. Distingue la integridad documental, los contrastes empíricos, una derivación propuesta, una prueba mecanizada y el dictamen académico. Su comprobador valida referencias y archivos; no decide verdad matemática. La auditoría Lean comprueba componentes explícitos del manuscrito y sus axiomas, sin acreditar el cierre integral; Comparator y el dictamen independiente permanecen pendientes. El resultado 279 de OpenAI Math conserva su estado de candidato bibliográfico, sin fundamentar garantías de NEXUS.

Los argumentos completos, sus cálculos y el registro de resolución M1–M6 se conservan en los paquetes de derivaciones de TG2. La edición de trabajo integra los resultados disponibles con ese estado de revisión; su inclusión no constituye aprobación del director.

---

## 6.8 Conclusiones del capítulo

Este capítulo reúne los fundamentos de seguridad, el análisis de complejidad y la evidencia experimental de los componentes de NEXUS:

1. **Fundamentos de seguridad (Obj. 4.1).** Se identifican MLWE, SelfTargetMSIS y MSIS, las correcciones de las pruebas citadas y las condiciones de las reducciones de peor caso. R1 identifica el perfil real, reproduce una pérdida de referencia y descarta la aplicación directa de JMW24 a sus parámetros. Se explicitan los pasos restantes entre plantilla y código; no se presenta una prueba concreta nueva ni una demostración general de dureza cuántica.
2. **Análisis de complejidad (Obj. 4.2).** Las operaciones del esquema tienen costo $O(k\ell\,n\log n)$ (dominado por la NTT, $O(n\log n)$ por multiplicación), con $\mathsf{Sign}$ esperado constante en iteraciones; las constantes medidas y el costo de datos dependen del perfil. La amortización queda condicionada a disponibilidad, prueba de la lógica pertinente y costo del prover (§6.6.5).
3. **Validación empírica (Obj. 4.2).** Las series históricas H1/H2 y la caché recuperada conservan identidades separadas; reconstruir sus fuentes exactas permanece pendiente. La conciliación de R4 y su complemento pasó 451 comprobaciones de fuentes y estadísticas: 29 casos Criterion, 40 mediciones STARK heredadas y 40 repeticiones multinúcleo, con dispersión preservada. No se atribuyen esos tiempos STARK a TG2 v1 con FRI vinculado. Los dos bloqueos iniciales se resolvieron tras el cambio de Windows por el autor. La cifra multinúcleo histórica conserva su limitación temporal y se presenta una nueva serie corregida. Las 197 pruebas delimitan el perfil de firma, el verificador y la gestión de claves sin acreditar una blockchain completa ni conocimiento cero del PoC.

Las derivaciones por rondas y ROM clásico se incluyen como resultados propuestos bajo hipótesis explícitas. La transferencia QROM completa de AIR/FRI queda como trabajo futuro; R1 mantiene sus obligaciones propias. El catálogo enlaza las afirmaciones y la evidencia sin mecanizar las demostraciones.

El cierre del **Objetivo 4** requiere completar la trazabilidad de las hipótesis formales y preservar la evidencia reproducible de los experimentos. Los resultados medidos corresponden a componentes; su extensión a la arquitectura completa depende de la integración y de los supuestos declarados.

---

## Referencias del capítulo

> *Índice local del capítulo; la **Bibliografía** consolidada al final del documento reúne todas las obras bajo clave única.*

- **[D+18]** Ducas, Kiltz, Lepoint, Lyubashevsky, Schwabe, Seiler, Stehlé. *CRYSTALS-Dilithium: A Lattice-Based Digital Signature Scheme.* IACR ToCHES 2018(1).
- **[DIL21]** Ducas et al. *CRYSTALS-Dilithium — Algorithm Specifications and Supporting Documentation*, v3.1, 2021, §6.2–6.3.
- **[B+23]** Barbosa et al. *Fixing and Mechanizing the Security Proof of Fiat-Shamir with Aborts and Dilithium*. CRYPTO 2023. https://doi.org/10.1007/978-3-031-38554-4_12.
- **[JMW24]** Jackson, Miller, Wang. *Evaluating the security of CRYSTALS-Dilithium in the quantum random oracle model*. arXiv:2312.16619v2, 2024, Teoremas 1–2 y §4.
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
