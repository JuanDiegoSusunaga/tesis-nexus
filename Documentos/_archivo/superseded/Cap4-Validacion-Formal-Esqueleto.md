# Capítulo 4 — Validación Formal de la Seguridad

### (Esqueleto de trabajo · Objetivo Específico 4)

> **SUPERSEDED.** Este esqueleto fue desarrollado y corregido en `Cap6-Validacion-Formal.md`. Consérvese solo como referencia histórica; el contenido vigente (cota sUF-CMA de tres términos, Mod-SIVP, ~0,91× cuántico, etc.) está en el **Capítulo 6**.

> **Cómo usar este esqueleto.** Cada sección incluye: (a) el contenido fijo que ya puedes dar por establecido (definiciones, enunciados de teoremas conocidos, parámetros de Dilithium), y (b) marcadores **`[Desarrollar]`**, **`[Citar]`** y **`[Completar]`** donde debes expandir con tu redacción y referencias. Los teoremas fundacionales (Regev, Langlois–Stehlé, la prueba de seguridad de Dilithium) **se enuncian, se citan y se instancian** para tus parámetros — **no** se vuelven a demostrar; ese es el alcance apropiado para un trabajo de grado. La matemática va en notación LaTeX (`$...$`, `$$...$$`); el archivo convierte a `.tex`/Word con `pandoc`.
>
> **Notación metodológica clave (úsala en la introducción).** "Validar formalmente" aquí significa: (1) fijar un *modelo de seguridad* preciso, (2) reducir la seguridad del esquema a un problema computacional bien estudiado, (3) argumentar la dureza cuántica de ese problema, y (4) acotar el costo computacional con notación asintótica. Es una validación *analítica*, complementada — no sustituida — por evidencia empírica.

---

## 4.1 Introducción y alcance del capítulo

**Objetivo.** Establecer formalmente que el núcleo criptográfico de NEXUS (el esquema de firma CRYSTALS-Dilithium) es seguro frente a adversarios con capacidad de cómputo cuántico, y caracterizar el costo computacional de su verificación y el *overhead* que introduce en la arquitectura dual.

**Lo que este capítulo valida (alcance):**
- La **in-forjabilidad** de las firmas Dilithium bajo ataque de mensaje elegido, reducida a la dureza de Module-LWE y Module-SIS (§4.4).
- La **resistencia cuántica** de dichos problemas reticulares (no aplicabilidad de Shor; reducciones de peor caso) (§4.4.3).
- La **complejidad computacional** asintótica de las operaciones del esquema y del esquema dual (§4.5).

**Lo que este capítulo NO cubre (limitaciones declaradas, §4.7):**
- Seguridad de *implementación* (canales laterales, fallos): fuera de alcance — se asume el modelo de caja negra.
- Seguridad de los componentes aún no implementados (ZK, extractor difuso con ECC): se discuten como trabajo futuro, no se validan formalmente aquí.
- Seguridad del protocolo de consenso BFT (vivacidad/seguridad bizantina): mencionada en §4.6, no demostrada.

`[Desarrollar]` Párrafo de motivación: amenaza HNDL, transición PQC de NIST, y por qué la firma es el componente cuya validación formal es a la vez tractable y central para la tesis.

---

## 4.2 Preliminares matemáticos

### 4.2.1 Retículos y problemas reticulares

**Definición 4.1 (Retículo).** Dado un conjunto de vectores linealmente independientes $\mathbf{b}_1,\dots,\mathbf{b}_m \in \mathbb{R}^d$, el *retículo* generado es
$$\Lambda = \mathcal{L}(\mathbf{B}) = \Big\{ \textstyle\sum_{i=1}^{m} z_i \mathbf{b}_i : z_i \in \mathbb{Z} \Big\}.$$

**Definición 4.2 (SVP y CVP aproximados).** Para un factor $\gamma \geq 1$:
- *$\gamma$-SVP*: hallar $\mathbf{v}\in\Lambda\setminus\{\mathbf 0\}$ con $\|\mathbf v\| \le \gamma\,\lambda_1(\Lambda)$, donde $\lambda_1$ es la longitud del vector no nulo más corto.
- *$\gamma$-CVP*: dado $\mathbf t$, hallar $\mathbf v\in\Lambda$ con $\|\mathbf t-\mathbf v\|\le\gamma\,\mathrm{dist}(\mathbf t,\Lambda)$.

`[Citar]` Micciancio & Regev; Peikert (*A Decade of Lattice Cryptography*). `[Completar]` Comentario sobre la dureza conjeturada de $\gamma$-SVP para $\gamma$ polinómico.

### 4.2.2 Anillos ciclotómicos y módulos

Sea $n=256$ (potencia de 2) y $q = 8\,380\,417 = 2^{23}-2^{13}+1$ (primo). Se define el anillo
$$R = \mathbb{Z}[X]/(X^{n}+1), \qquad R_q = \mathbb{Z}_q[X]/(X^{n}+1).$$
Los elementos son polinomios de grado $< n$. Un *módulo* sobre $R_q$ de rango $\ell$ es $R_q^{\ell}$; las claves de Dilithium viven en módulos $R_q^{k}$, $R_q^{\ell}$ y matrices $R_q^{k\times \ell}$.

`[Completar]` Definir las normas usadas: para $w\in R_q$, $\|w\|_\infty$ y $\|w\|_2$ sobre sus coeficientes (representante centrado en $(-q/2, q/2]$); extender a vectores. Definir el conjunto de "polinomios pequeños" $S_\eta = \{w\in R : \|w\|_\infty \le \eta\}$.

### 4.2.3 Module-LWE y Module-SIS

**Definición 4.3 (Module-LWE, versión decisional — MLWE).** Sean enteros $k,\ell$, y distribuciones de "pequeños" para secreto y error. Para $\mathbf{s}\in S_\eta^{\ell}$, $\mathbf{e}\in S_\eta^{k}$ y $\mathbf{A}\xleftarrow{\$} R_q^{k\times \ell}$, el problema $\mathrm{MLWE}_{k,\ell,\eta}$ pide distinguir
$$\big(\mathbf{A},\ \mathbf{A}\mathbf{s}+\mathbf{e}\big) \quad\text{de}\quad \big(\mathbf{A},\ \mathbf{u}\big),\ \ \mathbf{u}\xleftarrow{\$} R_q^{k},$$
con ventaja no despreciable. La versión *de búsqueda* pide recuperar $\mathbf{s}$.

**Definición 4.4 (Module-SIS — MSIS).** Para $\mathbf{A}\xleftarrow{\$} R_q^{k\times \ell}$ y cota $\beta$, hallar $\mathbf{z}\in R_q^{\ell}\setminus\{\mathbf 0\}$ con
$$\mathbf{A}\mathbf{z} = \mathbf{0}\ (\bmod\ q), \qquad \|\mathbf{z}\| \le \beta.$$

**Definición 4.5 (SelfTargetMSIS).** `[Completar]` Variante con un reto de hash $H$ usada en la prueba de Dilithium en el (Q)ROM (forjar una firma implica resolver esta variante). `[Citar]` Kiltz, Lyubashevsky & Schaffner (2018).

`[Completar]` Tabla de parámetros concretos por nivel:

| Parámetro | Dilithium2 | Dilithium3 | Dilithium5 |
|---|:---:|:---:|:---:|
| $(k,\ell)$ | $(4,4)$ | $(6,5)$ | $(8,7)$ |
| $\eta$ | $2$ | $4$ | $2$ |
| $n,\ q$ | \multicolumn{3}{c}{$256,\ 8\,380\,417$} |
| Nivel NIST | 2 | 3 | 5 |
| pk / firma (bytes) | 1312 / 2420 | 1952 / 3293 | 2592 / 4595 |

> **Nota de versión (importante para citar).** Los tamaños de firma 3293/4595 B son los de **CRYSTALS-Dilithium round 3** (la base de la biblioteca usada por el prototipo). La versión final **FIPS 204 (ML-DSA)** ajustó las firmas a 3309 B (ML-DSA-65) y 4627 B (ML-DSA-87); las claves públicas (1312/1952/2592 B) **no** cambian. Si citas [NIST24]/FIPS 204, aclara que los tamaños mostrados corresponden a la parametrización round-3, para evitar una lectura de conflación.

---

## 4.3 Modelo de seguridad

### 4.3.1 Esquema de firma (sintaxis)

**Definición 4.6.** Un esquema de firma es una terna $(\mathsf{KeyGen}, \mathsf{Sign}, \mathsf{Verify})$:
- $\mathsf{KeyGen}(1^\lambda) \to (pk, sk)$.
- $\mathsf{Sign}(sk, \mu) \to \sigma$.
- $\mathsf{Verify}(pk, \mu, \sigma) \to \{0,1\}$, con *corrección*: $\Pr[\mathsf{Verify}(pk,\mu,\mathsf{Sign}(sk,\mu))=1]=1-\mathrm{negl}(\lambda)$.

`[Completar]` Instanciar con Dilithium: $sk=(\mathbf{s}_1,\mathbf{s}_2)$ pequeños, $pk=(\mathbf{A}, \mathbf{t}=\mathbf{A}\mathbf{s}_1+\mathbf{s}_2)$; firma vía *Fiat-Shamir with Aborts* (técnica introducida por Lyubashevsky, ASIACRYPT 2009; instanciada en retículos sin trampillas en EUROCRYPT 2012 — cita ambas: 2009 para la técnica, 2012 para el esquema) (esbozar el bucle de *rejection sampling* y la estructura $\sigma=(\mathbf z, \mathbf h, c)$).

### 4.3.2 In-forjabilidad (EUF-CMA / SUF-CMA)

**Definición 4.7 (Juego EUF-CMA).** El adversario $\mathcal{A}$ recibe $pk$ y un oráculo de firma $\mathcal{O}_{\mathsf{Sign}}(\cdot)$; produce $(\mu^*, \sigma^*)$ y gana si $\mathsf{Verify}(pk,\mu^*,\sigma^*)=1$ y $\mu^*$ no fue consultado. La ventaja es
$$\mathsf{Adv}^{\text{EUF-CMA}}_{\mathcal A} = \Pr[\mathcal A\ \text{gana}].$$
SUF-CMA (in-forjabilidad *fuerte*) refuerza la condición de victoria a $(\mu^*,\sigma^*)$ nuevo (no solo $\mu^*$).

### 4.3.3 Modelo del adversario cuántico (QROM)

`[Desarrollar]` Definir el **Quantum Random Oracle Model**: el adversario evalúa el oráculo de hash en superposición, $\sum_x \alpha_x\lvert x\rangle\lvert 0\rangle \mapsto \sum_x \alpha_x\lvert x\rangle\lvert H(x)\rangle$. Justificar por qué la prueba de Dilithium se hace en el QROM y no solo en el ROM clásico (un adversario cuántico real puede consultar el hash en superposición). `[Citar]` Boneh et al. (2011), *Random Oracles in a Quantum World*.

---

## 4.4 Reducción de dureza post-cuántica (núcleo del Objetivo 4)

### 4.4.1 Teorema de seguridad de Dilithium (enunciado e instanciación)

**Teorema 4.1 (Seguridad sUF-CMA de Dilithium — adaptado).** *Si los problemas $\mathrm{MLWE}_{k,\ell}$, $\mathrm{SelfTargetMSIS}$ y $\mathrm{MSIS}$ (con los parámetros de la §4.2.3) son difíciles para algoritmos cuánticos de tiempo polinómico, entonces el esquema de firma Dilithium es **fuertemente** in-forjable (sUF-CMA) en el QROM. Concretamente, para todo adversario cuántico $\mathcal{A}$ existen adversarios $\mathcal{B},\mathcal{C},\mathcal{D}$ con tiempos comparables tales que*
$$\mathsf{Adv}^{\text{sUF-CMA}}_{\mathcal A} \le \mathsf{Adv}^{\mathrm{MLWE}}_{\mathcal B} + \mathsf{Adv}^{\mathrm{SelfTargetMSIS}}_{\mathcal C} + \mathsf{Adv}^{\mathrm{MSIS}}_{\mathcal D} + 2^{-254}.$$

> **Importante (tres términos, no dos).** MLWE protege la *clave* (indistinguibilidad de $pk$); SelfTargetMSIS descarta falsificaciones sobre mensajes *nuevos*; y **MSIS** es el término adicional que descarta una *nueva firma sobre un mensaje ya consultado* — es decir, lo que eleva la garantía de UF-CMA a in-forjabilidad **fuerte** (sUF-CMA). El término $2^{-254}$ se absorbe en $\mathrm{negl}(\lambda)$. (Si solo deseas enunciar UF-CMA estándar, bastan los términos MLWE + SelfTargetMSIS.)

`[Citar]` Ducas et al. (2018, teorema de seguridad, Sec. 6); Kiltz, Lyubashevsky & Schaffner (2018) para el QROM. **`[Desarrollar]` Esbozo de la prueba (tres pasos):**

1. **Indistinguibilidad de la clave pública (MLWE *decisional*).** $\mathbf{t}=\mathbf{A}\mathbf{s}_1+\mathbf{s}_2$ es una instancia MLWE; bajo la dureza **decisional** de MLWE, $pk$ es indistinguible de uniforme, de modo que el secreto no se filtra por la clave pública. `[Completar]` reducción $\mathcal{B}$.
2. **Zero-knowledge de la firma (simulación).** El bucle de *rejection sampling* hace que $\mathbf z$ siga una distribución independiente del secreto; las firmas son simulables sin $sk$ en el (Q)ROM. `[Completar]` argumento de la simulación y la cota de aborts.
3. **De la falsificación a una instancia reticular corta** (corrección de dirección importante):
   - Falsificación sobre **mensaje nuevo**: como el reto $c=H(\cdots)$ va *embebido* en la instancia, la falsificación **es directamente** una solución de $\mathrm{SelfTargetMSIS}$ — **no** se requiere *forking*/rebobinado. `[Completar]` reducción $\mathcal{C}$.
   - **In-forjabilidad fuerte** (nueva firma sobre un mensaje *ya consultado*): de dos firmas válidas distintas para el mismo mensaje se extrae, por diferencia, un $\mathbf{z}\neq\mathbf 0$ corto con $\mathbf{A}'\mathbf{z}=\mathbf 0$, i.e. una solución de $\mathrm{MSIS}$. `[Completar]` reducción $\mathcal{D}$.
   - *El argumento de tipo* forking *(dos transcripciones con el mismo* commitment *y retos distintos) solo aparece en la reducción adicional, no ajustada, de $\mathrm{SelfTargetMSIS}$ a $\mathrm{MSIS}$ en el ROM; no es el mecanismo para llegar a SelfTargetMSIS.*

> **`[Completar]` Salvedad sobre el QROM (KLS18).** Kiltz–Lyubashevsky–Schaffner (2018) prueban el resultado en el QROM para una **variante modificada** ("Dilithium-QROM": exige $q\equiv 5\pmod 8$ y claves/firmas mayores) y tratan la dureza *cuántica* de SelfTargetMSIS esencialmente como supuesto (el *forking* clásico no se traslada al caso cuántico); la reducción QROM completa se afinó en trabajo posterior. Declara esta salvedad para no sobre-afirmar la *tightness* en el QROM.

### 4.4.2 De MLWE/MSIS a problemas reticulares de peor caso

**Teorema 4.2 (Reducción worst-case → average-case para módulos — enunciado).** *Resolver $\mathrm{MLWE}_{k,\ell,\eta}$ (caso promedio) con ventaja no despreciable implica resolver $\gamma$-$\mathrm{Mod\text{-}SIVP}$ (problema del vector independiente más corto sobre módulos; vía la variante generalizada $\mathrm{Mod\text{-}GIVP}$) en el **peor caso**, para un factor $\gamma$ polinómico.* Análogamente, la dureza de MSIS se basa en $\mathrm{Mod\text{-}SIVP}$ de peor caso.

`[Citar]` Langlois & Stehlé (2015) para módulos; Regev (2009) para el caso base LWE (reducción **cuántica** a $\mathrm{GapSVP}$ y $\mathrm{SIVP}$ de peor caso). `[Completar]` Enunciar con precisión las dimensiones y el factor $\gamma$; explicar la implicación: **la seguridad de Dilithium descansa, en última instancia, en la dureza de peor caso de $\mathrm{Mod\text{-}SIVP}$**, una conjetura ampliamente estudiada.

> **Nota de precisión (clásico vs. cuántico).** La reducción que sustenta **MLWE** (Mod-SIVP → MLWE) es **cuántica** (hereda el paso cuántico de Regev), mientras que la que sustenta **MSIS** (Mod-SIVP → MSIS) es **clásica**. Relévalo explícitamente, pues §4.4.3 construye el argumento de resistencia cuántica sobre estos problemas de peor caso. (Nombres: $\mathrm{SVP}$ pide *un* vector corto; $\mathrm{SIVP}$ pide $n$ vectores cortos linealmente independientes — son problemas distintos; el correcto aquí es SIVP/Mod-SIVP.)

### 4.4.3 Resistencia cuántica: no aplicabilidad de Shor

**Proposición 4.3 (No reducción a HSP abeliano).** *El algoritmo de Shor resuelve eficientemente el Problema del Subgrupo Oculto (HSP) sobre grupos abelianos finitos —del cual factorización y logaritmo discreto son casos particulares—. Los problemas reticulares relevantes ($\gamma$-SVP y, en el caso de módulos, $\gamma$-$\mathrm{Mod\text{-}SIVP}$) no se conocen como instancias de un HSP abeliano resoluble, y por tanto Shor no se les aplica.*

`[Desarrollar]` Argumento:
- Shor explota la periodicidad vía la Transformada Cuántica de Fourier sobre $\mathbb{Z}_N^\times$ / grupos abelianos. `[Citar]` Shor (1997).
- Los intentos de atacar retículos vía el HSP **diédrico** (no abeliano) no han producido algoritmos eficientes; el mejor enfoque cuántico conocido para SVP es el *sieving* cuántico, con coste $2^{(0.265+o(1))d}$ frente a $2^{(0.292+o(1))d}$ clásico. `[Citar]` Laarhoven (2015); Becker–Ducas–Gama–Laarhoven (2016) para el $0.292$ clásico.
- **Conclusión (con una advertencia importante de precisión):** el *speedup* cuántico conocido es **modesto** — reduce la *constante del exponente* de $\approx 0.292$ a $\approx 0.265$, es decir, la seguridad cuántica estimada por *core-SVP* es $\approx \tfrac{0.265}{0.292}\approx 0.91\times$ la clásica, **no** la mitad. Bajo este modelo (core-SVP), Dilithium3 ronda $\sim$180 bits clásicos y $\sim$165 bits cuánticos.

> **`[Completar]` — Reconciliar dos cifras.** La columna "Seguridad Cuántica = mitad" que aparece en tablas divulgativas (y en versiones previas del README de NEXUS: 128→64, 192→96, 256→128) **no** proviene del *sieving* (que da $\sim 0.91\times$), sino de una **heurística conservadora tipo Grover** (speedup cuadrático sobre búsqueda genérica), que es *pesimista* para esquemas reticulares. Debes presentar ambas explícitamente: (i) la estimación *core-SVP* (modesta reducción $\sim 0.91\times$) como la cifra técnica vigente, y (ii) la cota tipo Grover (mitad de bits) como límite conservador. Indica claramente cuál usas y por qué, y alinea la tabla del §4.1 / README con esta aclaración para evitar una inconsistencia que un jurado podría señalar.

### 4.4.4 Cadena de reducciones (síntesis)

$$
\underbrace{\text{Forjar Dilithium}}_{\text{romper SUF-CMA}}
\ \Longrightarrow\
\underbrace{\text{resolver SelfTargetMSIS } \vee \text{ distinguir MLWE}}_{\text{Teorema 4.1}}
\ \Longrightarrow\
\underbrace{\gamma\text{-Mod-SIVP peor caso}}_{\text{Teorema 4.2}}
\ \overset{\text{Prop. 4.3}}{\Longrightarrow}\
\underbrace{\text{difícil aun cuánticamente}}_{\text{Shor no aplica}}
$$

`[Completar]` Diagrama formal y discusión de los supuestos en cada flecha (las pérdidas de la reducción y su impacto en la elección de parámetros).

---

## 4.5 Análisis de complejidad computacional (notación O)

### 4.5.1 La NTT como operación dominante

La operación costosa en $R_q$ es la multiplicación de polinomios. Mediante la **Transformada Teórica de Números (NTT)** —una FFT sobre $\mathbb{Z}_q$, posible porque $q\equiv 1 \pmod{2n}$— la multiplicación se realiza en
$$T_{\text{mult}}(n) = O(n\log n)\ \text{operaciones en } \mathbb{Z}_q,$$
frente a $O(n^2)$ del producto escolar. `[Completar]` Describir NTT/INTT y por qué $q=8\,380\,417$ admite raíces $2n$-ésimas de la unidad.

### 4.5.2 Complejidad de KeyGen, Sign y Verify

Sea $n=256$ fijo y $(k,\ell)$ las dimensiones del módulo. El costo se mide en multiplicaciones en $R_q$ (cada una $O(n\log n)$):

**Proposición 4.4 (Costos asintóticos).**
- $\mathsf{KeyGen}$: calcular $\mathbf{t}=\mathbf{A}\mathbf{s}_1+\mathbf{s}_2$ requiere $k\ell$ multiplicaciones $\Rightarrow O(k\ell\,n\log n)$.
- $\mathsf{Sign}$: cada iteración del bucle de *rejection sampling* hace productos matriz-vector $\Rightarrow O(k\ell\,n\log n)$ por iteración; el número esperado de iteraciones es una **constante** $\rho^{-1}$ (probabilidad de aceptación $\rho$ acotada inferiormente por diseño) $\Rightarrow O(k\ell\,n\log n)$ esperado.
- $\mathsf{Verify}$: recomputar $\mathbf{A}\mathbf{z}-c\,\mathbf{t}$ y verificar normas/hash $\Rightarrow O(k\ell\,n\log n)$.

`[Completar]` Demostración: contar exactamente las multiplicaciones por operación y justificar la cota constante de iteraciones de *Sign*. El número esperado de repeticiones es **constante por conjunto de parámetros** (≈4,25 para Dilithium2; ≈5,1 para Dilithium3; ≈3,85 para Dilithium5) e independiente de $n$, por lo que el costo **esperado** (no de peor caso — el bucle es en principio no acotado) permanece $O(k\ell\,n\log n)$. **Cota más fina (opcional):** manteniendo $\mathbf{A}$ y los vectores en el dominio NTT, las $k\ell$ multiplicaciones puntuales cuestan $O(k\ell\,n)$ y las transformadas se incurren $O(k+\ell)$ veces, dando $O\big((k+\ell)\,n\log n + k\ell\,n\big)$; el $O(k\ell\,n\log n)$ del enunciado es una **cota superior** válida bajo la convención «cada multiplicación de anillo $=O(n\log n)$». Al ser $n=256$ fijo, en la práctica el costo escala con $k\ell$.

**Tabla 4.x — Complejidad y tamaños por nivel:**

| | $\mathsf{KeyGen}$ | $\mathsf{Sign}$ (esp.) | $\mathsf{Verify}$ | pk | firma |
|---|:---:|:---:|:---:|:---:|:---:|
| Asintótico | $O(k\ell\,n\log n)$ | $O(k\ell\,n\log n)$ | $O(k\ell\,n\log n)$ | $O(k\,n\log q)$ | $O((\ell+k)\,n\log q)$ |
| Dilithium2 $(4,4)$ | — | — | — | 1312 B | 2420 B |
| Dilithium3 $(6,5)$ | — | — | — | 1952 B | 3293 B |
| Dilithium5 $(8,7)$ | — | — | — | 2592 B | 4595 B |

### 4.5.3 Overhead de la arquitectura dual

`[Desarrollar]` Analizar el costo que la PQC impone sobre el diseño dual:
- **Tamaño de firma**: ~3.293 B (Dilithium3) frente a ~64–72 B de ECDSA → factor ~$50\times$ en almacenamiento/ancho de banda por transacción en L1. `[Completar]` cuantificar el impacto en la *Anchor Layer* (tamaño de bloque, propagación).
- **Verificación por bloque**: para $m$ transacciones, $O(m\cdot k\ell\,n\log n)$ → motivar el *batching* L2 y la agregación/compromiso como amortización.
- **Amortización por L2**: una sola prueba/compromiso de estado por *batch* reduce la verificación on-chain de $O(m)$ firmas a $O(1)$ verificación de la transición — `[Completar]` formalizar el ahorro (cuando el Nitro Verifier ZK esté implementado; hoy es trabajo futuro, indicarlo).

### 4.5.4 Comparación con criptografía clásica

`[Completar]` Tabla comparativa Dilithium vs ECDSA/RSA: tamaños de clave/firma, costo de verificación, y —crucialmente— resistencia cuántica (ECDSA/RSA: rotos por Shor en tiempo polinómico; Dilithium: sin ataque cuántico eficiente conocido).

---

## 4.6 Validación empírica complementaria

`[Desarrollar]` Esta sección **acota empíricamente las constantes ocultas** del análisis $O(\cdot)$ de §4.5; no reemplaza la prueba.
- **Metodología**: harness Criterion (`nexus-crypto/benches/dilithium_bench.rs`), $N$ iteraciones, calentamiento, hardware especificado, media ± desviación y percentiles.
- **Métricas**: tiempo de $\mathsf{KeyGen}/\mathsf{Sign}/\mathsf{Verify}$ por nivel; verificaciones por segundo; relación con $k\ell\,n\log n$ (esperar que el tiempo escale ~linealmente con $k\ell$ a $n$ fijo).
- **Relación teoría–práctica**: contrastar el orden empírico con la Proposición 4.4.

`[Completar]` Insertar resultados tras corregir el estado de compilación (ver README, §"Antes de compilar"). **No** reportar cifras como medidas hasta ejecutarlas realmente.

---

## 4.7 Limitaciones y alcance de la validación formal

`[Desarrollar]` Declarar honestamente:
- La validación cubre la **firma** (Dilithium) en el modelo de caja negra (QROM); **no** cubre seguridad de implementación (canales laterales, *fault attacks*).
- El **extractor difuso** y la **capa ZK** no se validan formalmente aquí porque su implementación con ECC/circuitos reales es trabajo futuro; se enuncian las propiedades objetivo (privacidad del *helper data*; *soundness*/*zero-knowledge* de Groth16) como agenda.
- La **seguridad bizantina del consenso** (seguridad y vivacidad bajo $<1/3$ de *stake* adversario) se enuncia como propiedad de diseño objetivo, pendiente de implementación de verificación de votos y *slashing*.

---

## 4.8 Conclusiones del capítulo

`[Completar]` Sintetizar: (1) la in-forjabilidad de Dilithium se reduce a Module-LWE/MSIS y, en última instancia, a Mod-SIVP de peor caso; (2) ningún algoritmo cuántico conocido (incluido Shor) resuelve eficientemente estos problemas; (3) la verificación de firmas tiene costo $O(k\ell\,n\log n)$, con *overhead* dominado por el tamaño de firma, mitigable por *batching* L2. Con ello, el Objetivo 4 queda atendido en su componente formal, complementado por la validación empírica de §4.6.

---

## Referencias del capítulo

- [D+18] Ducas, Kiltz, Lepoint, Lyubashevsky, Schwabe, Seiler, Stehlé. *CRYSTALS-Dilithium*. IACR ToCHES 2018(1).
- [KLS18] Kiltz, Lyubashevsky, Schaffner. *A Concrete Treatment of Fiat-Shamir Signatures in the QROM*. EUROCRYPT 2018.
- [Lyu09] Lyubashevsky. *Fiat-Shamir with Aborts: Applications to Lattice and Factoring-Based Signatures*. ASIACRYPT 2009. *(origen de la técnica rejection-sampling/aborts)*
- [Lyu12] Lyubashevsky. *Lattice Signatures without Trapdoors*. EUROCRYPT 2012. *(esquema del que Dilithium desciende)*
- [LS15] Langlois, Stehlé. *Worst-Case to Average-Case Reductions for Module Lattices*. DCC 2015. *(Mod-SIVP/Mod-GIVP → MLWE/MSIS)*
- [Reg09] Regev. *On Lattices, Learning with Errors, ...*. J. ACM 2009.
- [BDF+11] Boneh, Dagdelen, Fischlin, Lehmann, Schaffner, Zhandry. *Random Oracles in a Quantum World*. ASIACRYPT 2011.
- [Sho97] Shor. *Polynomial-Time Algorithms for Prime Factorization and Discrete Logarithms on a Quantum Computer*. SIAM J. Comput. 1997.
- [Laa15] Laarhoven. *Search problems in cryptography* / sieving cuántico. 2015.
- [NIST24] NIST. *FIPS 204: Module-Lattice-Based Digital Signature Standard*. 2024.
- [Pei16] Peikert. *A Decade of Lattice Cryptography*. 2016.

> **Nota de redacción.** Mantén la distinción entre lo que **citas** (teoremas fundacionales) y lo que **aportas** (la *instanciación* para los parámetros de NEXUS, la cadena de reducciones sintetizada de §4.4.4, el análisis de *overhead* dual de §4.5.3 y la contrastación empírica de §4.6). Tu contribución original no es re-demostrar Dilithium, sino **ensamblar y particularizar** la argumentación de seguridad y complejidad para tu arquitectura.
