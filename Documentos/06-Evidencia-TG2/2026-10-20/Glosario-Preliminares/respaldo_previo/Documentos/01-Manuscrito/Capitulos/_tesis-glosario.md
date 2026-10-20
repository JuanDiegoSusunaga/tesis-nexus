# Glosario de términos y siglas {.unnumbered}

Este glosario reúne los términos técnicos utilizados en la tesis. Las definiciones facilitan la lectura; las hipótesis, demostraciones y límites de cada resultado se establecen en los capítulos correspondientes. La sección siguiente distingue los símbolos matemáticos y sus usos locales.

**AIR — representación algebraica intermedia.** Sistema de restricciones polinómicas que describe fronteras y transiciones de una ejecución. El AIR de esta tesis representa una recurrencia escalar ilustrativa, no la verificación de ML-DSA ni la lógica completa de una aplicación (sección 6.7).

**APT — prueba de proporción adaptativa.** Prueba de salud que cuenta, dentro de una ventana, las apariciones del valor tomado como referencia y declara fallo cuando alcanza el corte establecido. Complementa RCT; superarla no demuestra por sí sola la min-entropía de una fuente (sección 5.3).

**Aritmetización.** Expresión de un cómputo y de sus condiciones de validez mediante relaciones algebraicas. La conexión de una API a un verificador no equivale a aritmetizar ese cómputo (secciones 3.5 y 6.7.4).

**Certificado o prueba.** Datos que un probador entrega para que un verificador compruebe un enunciado. En el prototipo incluyen compromisos, aperturas y elementos de FRI; su aceptación conserva el alcance matemático del AIR comprobado (secciones 6.7.4 y 6.7.9).

**Compromiso y árbol de Merkle.** Un compromiso representa datos mediante un valor que permite comprobar aperturas posteriores. En el árbol de Merkle, una raíz hash compromete las hojas y cada camino autentica una posición. La vinculación depende de la hipótesis criptográfica correspondiente; no implica ocultación automática (sección 6.7.6).

**Conocimiento cero — ZK.** Propiedad que permite demostrar una afirmación sin revelar información adicional sobre el testigo, en el modelo definido. Es distinta de la solidez. Las aperturas del prototipo no están enmascaradas y esta tesis no le acredita conocimiento cero (secciones 2.6 y 6.7.1).

**Disponibilidad de datos — DA.** Posibilidad de obtener los datos necesarios para reconstruir o auditar el estado. No se deduce únicamente de que un compromiso o una prueba sean válidos (sección 3.7).

**Época.** Identificador de una etapa de vigencia de claves. La rotación cambia claves y época sin exigir cambiar la identidad estable de la cuenta; comprobar una firma histórica no demuestra por sí solo cuándo se emitió (secciones 3.6 y 5.5).

**EUF-CMA y sUF-CMA.** Nociones de inforjabilidad frente a mensajes elegidos adaptativamente. EUF-CMA exige producir una firma válida de un mensaje no consultado; sUF-CMA también considera una firma nueva de un mensaje ya consultado. No sustituyen las reglas de autorización o antirrepetición de una aplicación (sección 6.3.2).

**Fiat–Shamir.** Transformación que obtiene retos a partir de la transcripción mediante hash para construir una prueba no interactiva. Su seguridad depende del modelo, del protocolo y de las pérdidas de la transformación (secciones 6.3 y 6.7.6).

**FRI — Fast Reed–Solomon Interactive Oracle Proof of Proximity.** Protocolo de proximidad a códigos de evaluaciones de polinomios de grado acotado. Comprobar proximidad no equivale a demostrar pertenencia exacta al código ni validez automática de todo el AIR (secciones 6.7.1–6.7.5).

**Goldilocks.** Nombre del campo primo utilizado por el prototipo AIR/FRI. Sus retos también emplean una extensión cuadrática. No es el módulo de ML-DSA (secciones 6.7.1 y 6.7.9).

**Grinding y nonce.** El nonce es un valor que puede variarse para buscar una transcripción que cumpla la condición de trabajo. Grinding designa esa búsqueda; encarece los reintentos, pero no los hace únicos ni elimina su efecto adaptativo (secciones 6.7.1 y 6.7.6).

**Hash.** Función que resume una entrada en un digest de longitud fijada. La tesis distingue SHA3-256 ejecutado por Rust del oráculo aleatorio ideal usado en la demostración; probar algo en ROM no demuestra automáticamente esa propiedad para SHA3 determinista (sección 6.7.9).

**KDF y HKDF.** KDF significa función de derivación de claves; HKDF es una construcción de extracción y expansión basada en HMAC. Son distintas de la expansión interna de ML-DSA. El diseño y la derivación SHA3-256 realmente ejecutada por Sentinel se distinguen en la sección 5.4.

**L1 y L2.** Capas de anclaje y ejecución, respectivamente. En NEXUS, L2 agrupa operaciones y L1 recibe compromisos y pruebas por lote dentro del modelo propuesto. La separación no acredita por sí sola consenso, disponibilidad ni validez de una aplicación completa (sección 3.2).

**LDE — extensión de bajo grado.** Evaluaciones de un polinomio de traza sobre un dominio mayor que el de sus filas originales. El control exhaustivo y el verificador con aperturas FRI no tienen el mismo costo ni la misma información de entrada (secciones 6.7.3–6.7.4).

**Lean.** Asistente de demostración cuyo núcleo comprueba los enunciados formalizados a partir de sus definiciones, hipótesis y axiomas. La comprobación de esos enunciados no valida por inferencia todo el texto ni demuestra equivalencia universal con el ejecutable Rust (sección 6.7.9).

**Min-entropía.** Medida de imprevisibilidad determinada por la probabilidad del resultado más probable. Para bloques dependientes no puede obtenerse multiplicando sin justificación la min-entropía marginal por la longitud (secciones 2.5 y 5.2).

**ML-DSA y Dilithium.** ML-DSA es el esquema de firma normalizado en FIPS 204 y derivado de CRYSTALS-Dilithium. La tesis distingue su perfil implementado de las plantillas y reducciones bibliográficas; los nombres históricos Dilithium2/3/5 seleccionan los perfiles indicados en el capítulo 4.

**Module-LWE, Module-SIS y SelfTargetMSIS.** Problemas sobre módulos empleados en el análisis de seguridad de las firmas. Tratan, respectivamente, la distinción de muestras con error, la búsqueda de relaciones cortas y una relación corta vinculada a un reto hash. Sus distribuciones, parámetros y reducciones no son intercambiables (secciones 6.2.3 y 6.4).

**Mod-SIVP.** Problema de encontrar vectores cortos linealmente independientes en retículos de módulo, con un factor de aproximación declarado. Su relación con problemas promedio exige las condiciones de las reducciones citadas (secciones 6.2.1 y 6.4.2).

**NTT — transformada teórica de números.** Transformada sobre un campo finito utilizada para multiplicar polinomios con eficiencia. El análisis distingue el costo asintótico de las latencias observadas (sección 6.5).

**PQC — criptografía poscuántica.** Criptografía estudiada frente a adversarios con capacidad de cómputo cuántico. La denominación no demuestra seguridad incondicional de una implementación ni de todos los componentes de un sistema (secciones 2.3–2.4 y 6.4.3).

**RCT — prueba de conteo de repeticiones.** Prueba de salud que detecta una secuencia excesivamente larga del mismo valor. Comparte con APT la función de detectar fallos del flujo observado, no de certificar por sí sola la fuente física (sección 5.3).

**Refinamiento de implementación.** Demostración de que un programa concreto satisface la especificación matemática correspondiente, incluidas codificaciones y operaciones relevantes. Los contrastes finitos Rust/Python no constituyen esa demostración universal (sección 6.7.9).

**ROM y QROM.** Modelos de oráculo aleatorio clásico y cuántico. ROM permite consultas clásicas; QROM también contempla consultas en superposición. La prueba AIR/FRI de esta tesis usa ROM clásico finito; su transferencia QROM completa permanece como trabajo futuro (secciones 6.3.3 y 6.7.9–6.7.10).

**Rollup y lote.** El modelo de rollup ejecuta operaciones fuera de L1 y publica información agregada de un lote. Amortizar el costo depende de qué datos y lógica se prueben y de la política de disponibilidad adoptada (secciones 3.4 y 6.6.5).

**Rust.** Lenguaje del prototipo ejecutable. Sus comprobaciones y pruebas de software aportan evidencia sobre los casos ensayados; no sustituyen una demostración probabilística ni el refinamiento universal respecto de Lean (secciones 6.7 y 6.7.9).

**Solidez — soundness.** Propiedad que limita la probabilidad de aceptar un enunciado falso bajo las hipótesis y recursos definidos. Una cota superior no es una tasa de ataque observada ni garantiza que un adversario alcance ese valor. Tampoco equivale a conocimiento cero (sección 6.7.9).

**STARK.** Argumento transparente de integridad computacional; su nombre desarrolla Scalable Transparent Argument of Knowledge. El uso de técnicas AIR/FRI en un prototipo no acredita automáticamente todas las propiedades asociadas a esa familia, incluida extracción de conocimiento o conocimiento cero (secciones 2.6 y 6.7).

**Testigo y traza.** El testigo contiene información que permite satisfacer el enunciado; la traza registra los valores de la ejecución representada. Una apertura de traza puede revelar información del testigo si no existe un mecanismo de ocultación (sección 6.7.1).

**Transcripción.** Registro ordenado de mensajes, compromisos y respuestas que determina el estado de una ejecución del protocolo. El orden, las etiquetas y las longitudes absorbidas por el canal forman parte de la especificación (secciones 6.7.4 y 6.7.6).

# Notación matemática {.unnumbered}

Las letras tienen el significado del contexto en que se definen. Reutilizar una letra en capítulos distintos no identifica sus cantidades. En particular, *M* no es el nombre de un módulo o de una demostración. Las referencias escritas como «sección 6.7.9» remiten a apartados de la tesis, no a símbolos de una fórmula.

## Amortización por lotes

**$M$ y $m$.** Número de operaciones agrupadas en un lote, en las secciones 3.4 y 6.6.5, respectivamente. Allí no cuentan parejas de posiciones de evaluación.

**$d$, $c$ y $\pi(M)$.** Bytes de diferencia de estado por operación, bytes fijos del lote y tamaño en bytes de la prueba. En ese modelo, $F(M)$ es el costo de datos de anclaje por operación. El uso de $d$ como cota de distancia en el análisis AIR/FRI es diferente.

## Álgebra y muestreo AIR/FRI

**$T$, $k$, $N$ y $M$.** Filas de la traza, exponente del perfil, posiciones del dominio de evaluación y parejas de posiciones opuestas. En los perfiles de la sección 6.7.9 se usan $T=2^k$, $N=8T$ y $M=N/2$. Esta *M* cuenta parejas, no operaciones del lote.

**$p$ y $K$.** Primo Goldilocks y campo de extensión cuadrática $K=\mathbb F_{p^2}$ del análisis AIR/FRI. El símbolo $\mathbb F_p$ representa su campo base. No deben confundirse con el módulo $q$ de ML-DSA.

**$q$ en el muestreo.** Número de parejas distintas consultadas, fijado en cuarenta en el perfil vinculado. Las consultas de AIR y de ambos recorridos FRI usan la misma muestra; no son tres muestras independientes.

**$f$, $u$ y $v$.** Polinomio candidato de traza, oráculo de traza y oráculo de composición en el análisis de la sección 6.7.5. La proximidad de un oráculo a un polinomio no significa igualdad en todas las posiciones.

**$\alpha_j$.** Coeficientes de combinación de las restricciones AIR. Su elección y dependencia del pasado se rigen por las hipótesis del modelo; no se presume independencia de todas las cantidades del protocolo.

**$\delta_t$, $\delta_c$ y $d$.** Radios de proximidad de traza y composición, y cota de discrepancia local derivada en el contexto de la sección 6.7.5. No son probabilidades observadas de ataque.

**$H(M,q,x)$ y $h_T$.** Función de omisión hipergeométrica y su especialización al perfil usado en la sección 6.7.8. La letra $H$ en este contexto no designa un hash ni una medida de entropía.

## Presupuesto y cota ROM

**$Q$ y $B$.** Máximo de llamadas adversarias al oráculo y presupuesto común, incluidas las del verificador. En la sección 6.7.9 se usa $B=Q+24895$. *B* no es la altura del árbol ni el tamaño del certificado.

**$R$.** Corte del selector: 512 extracciones como máximo, contando duplicados, para obtener cuarenta índices distintos. No es el anillo de polinomios de la sección 6.2.2.

**$L$.** Límite de marcas adicionales del registro ROM, no de bytes del certificado. En el análisis algebraico previo, la misma letra nombra un dominio de evaluación.

**$g$.** Parámetro de trabajo de 12 o 20 bits en la cota ROM; en la sección 6.7.2 designa un elemento de orden *T*. El trabajo no impone unicidad del nonce.

**$\rho$, $\delta(B)$ y $\sigma_k(B)$.** Términos de la excepción AIR/FRI, del acoplamiento y del perfil, respectivamente. La sección 6.7.9 define sus fórmulas y cargos completos, que deben conservarse al citar la cota.

**$\Pr[\cdot]$ y $\operatorname{AceptaFalsa}_k$.** Probabilidad de un evento y aceptación de un certificado con enunciado inválido en el perfil *k*. No significan falsificación de ML-DSA ni validación de una aplicación completa.

## Firmas y gestión de claves

**$n$, $q$, $k$ y $\ell$ en ML-DSA.** Grado del anillo, módulo y dimensiones de la matriz de la plantilla reticular. En la parametrización descrita se fijan $n=256$ y $q=8380417$; *k* y *q* no tienen aquí el significado del exponente de perfil y las cuarenta consultas AIR/FRI (sección 6.2.3).

**$pk$, $sk$, $\mu$ y $\sigma$.** Clave pública, clave secreta, mensaje o representante del mensaje según el esquema descrito, y firma. La firma $\sigma$ no es el término auxiliar $\sigma_k(B)$ de la cota ROM (secciones 6.3.1–6.3.2).

**$H_\infty(X)$.** Min-entropía de la variable aleatoria *X*. El subíndice infinito la distingue de otros usos de la letra *H*, como el hash o la función hipergeométrica (sección 5.2).

**$\xi$, $e$ y $j$.** Semilla suministrada a la generación interna de claves, época y contador de derivaciones en las secciones 4.5 y 5.4. El significado de *e* como vector de error en la definición reticular es local a esa definición.

**$W_{\mathcal R}(T)$.** Residencia acumulada de las regiones de memoria declaradas, medida en bytes-segundo. En la sección 5.6, *T* es un horizonte temporal, no el número de filas AIR. Esta métrica no mide entropía ni equivale a una probabilidad de compromiso.
