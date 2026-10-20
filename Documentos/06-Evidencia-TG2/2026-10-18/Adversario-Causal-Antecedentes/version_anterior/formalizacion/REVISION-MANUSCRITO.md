# Revisión matemática del manuscrito TG2

Hay **1861 resultados en 207 módulos**, con [auditoría conjunta correcta](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Verificador-Completo/validacion.json).
La ruta matemática completa añade 105 resultados: lectura, formas, canal,
índices ordenados, consultas AIR/FRI y presupuesto V_T. **Hay 33 modelos
verificados en su alcance y 7 grupos parciales.** La equivalencia universal
Rust y la seguridad integral mantienen obligaciones abiertas.

Se conservan 272 candidatos, 14 omisiones y 46 grupos: tres dependencias
bibliográficas, dos respaldos y un trabajo futuro QROM AIR/FRI. El autor
declaró «No hay dictamen». Los [criterios de los siete](../Documentos/06-Evidencia-TG2/2026-10-17/Verificador-Completo-Antecedentes/revision-criterios.json)
se mantienen. El cierre previo de M31 conserva su alcance concreto y los
otros modelos conservan sus obligaciones adicionales.

El [inventario](inventario-manuscrito.json) enlaza 212 bloques; el
[registro](revision-manuscrito.json), 216 y diez suplementos. Hay
1108 enlaces con alcance; no son porcentajes de cierre. Capítulos y salidas
publicadas conservan sus bytes.

## Siete grupos parciales

| Grupo | Tema | Trabajo pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | El canal conserva desafíos e índices en orden y su proyección a conjuntos está probada. Falta instanciar la ley uniforme ideal mediante claves frescas bajo las excepciones para todas las historias del ejecutable y adversario; no se retira la condición de frescura ni se supone independencia entre fases. |
| M36 | Solidez ideal por rondas y reinicios | Completar el adaptador integral de rondas y reinicios y obtener revisión independiente; el autor declaró que no hay dictamen. El compilador de programas finitos no identifica por sí solo los inicios B con consultas hash Q. |
| M37 | Extracción Merkle, bytes y orden temporal ROM | Las aperturas Merkle y recorridos FRI producen sus registros desde programas efectivos sobre una tabla común. Falta derivar familias causales y congelación antes de la primera exposición para todas las historias, incluyendo intercalaciones y consultas arbitrarias del adversario fuera de la gramática. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | El certificado y su lector matemático, formas, rechazos, canal y todas las aperturas ya están compuestos con presupuesto V_T demostrado. Falta refinamiento universal del parser serde/bincode, las otras operaciones de máquina y el ejecutable Rust. Se conserva la diferencia de EOF y el corte analítico R; el contraste de cincuenta casos es evidencia externa, no equivalencia universal. |
| M40 | Potencial de nonces y cola del selector | Construir los programas de los candidatos reales y sus conjuntos buenos con cotas antes de responder, además del trabajo/nonce y la tabla global. El compilador memoriza las repeticiones, pero no demuestra valor<=rho para esos candidatos ni la carga global de inicios. |
| M41 | Cota ROM completa y ejemplo numérico | Probar las inclusiones y leyes de los tres eventos bajo un mismo experimento del ejecutable, incluyendo adversario, sesgo, selector y presupuestos completos. La gramática, programa causal y cuenta del canal son componentes; no instancian todavía la cota numérica global. |

## Resumen por fuente

| Fuente | Candidatos | Suplementos | Bloques con enlace Lean parcial |
|---|---:|---:|---:|
| Resumen y preliminares | 2 | 1 | 0 |
| Cap1-Introduccion | 8 | 1 | 2 |
| Cap2-Marco-Teorico | 8 | 0 | 3 |
| Cap3-Diseno-Arquitectura | 19 | 3 | 13 |
| Cap4-Nucleo-Criptografico | 12 | 1 | 8 |
| Cap5-Gestion-Claves | 35 | 6 | 27 |
| Cap6-Validacion-Formal | 184 | 2 | 162 |
| Cap7-Conclusiones | 4 | 0 | 1 |

## Matriz de obligaciones

| Estado | Grupos |
|---|---:|
| Dependencia bibliográfica | 3 |
| Modelo verificado en su alcance | 33 |
| Componente Lean parcial | 7 |
| Trabajo futuro | 1 |
| Respaldo documental | 2 |

### M01 — Shor, Grover y alcance de la resistencia cuántica

Estado: **Dependencia bibliográfica**. Prioridad 3.

- Identificar formalizaciones de los algoritmos y su modelo de consultas y costo.
- Expresar la dureza reticular como hipótesis; no deducir una cota inferior de la no aplicación directa de Shor.

Referencias del registro: `Cap1-Introduccion-001`, `Cap1-Introduccion-002`, `Cap2-Marco-Teorico-001`, `Cap2-Marco-Teorico-002`, `Cap2-Marco-Teorico-006`, `Cap6-Validacion-Formal-009`, `Cap6-Validacion-Formal-050`, `Cap6-Validacion-Formal-051`, `Cap6-Validacion-Formal-052`, `Cap6-Validacion-Formal-074`, `SUP01`.

### M02 — Retículos, mínimos sucesivos y problemas aproximados

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Definir el span entero de una familia real linealmente independiente y sus normas.
- Precisar rango frente a dimensión ambiente, mínimos sucesivos, SVP, SIVP y GapSVP.

Alcance demostrado: Span entero de una familia real independiente, rango y dimensión intrínseca, combinaciones inyectivas y finitud en bolas. Mínimos sucesivos definidos por radios; monotonía, primer mínimo positivo y alcanzado. Relaciones SVP/SIVP/GapSVP y promesa disjunta.

Pendientes y límites: No demuestra dureza computacional ni aproximación algorítmica. La consecución de mínimos superiores no se prueba aquí.

Referencias del registro: `Cap2-Marco-Teorico-002`, `Cap6-Validacion-Formal-003`, `Cap6-Validacion-Formal-004`, `Cap6-Validacion-Formal-005`, `Cap6-Validacion-Formal-006`, `Cap6-Validacion-Formal-007`, `Cap6-Validacion-Formal-008`, `Cap6-Validacion-Formal-009`.

### M03 — Anillos y constantes de ML-DSA

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Construir Z[X]/(X^256+1) y su versión modular con representantes y normas.
- Demostrar primalidad de 8380417, q=2^23-2^13+1, q=512*16368+1 y existencia de raíz de orden 512.
- Comprobar las cuentas de parámetros tabulados sin inferir una garantía criptográfica.

Alcance demostrado: Primalidad de 8380417, fórmulas del módulo y dimensión, raíz 1753 de orden 512 y raíz cíclica de orden 256. Perfiles 44/65/87: dimensiones, beta=tau*eta, gamma, márgenes y aritmética de tamaños públicos y firmas del formato declarado. Cocientes Z[X]/(X^256+1) y Fq[X]/(X^256+1), representantes canónicos de grado menor que 256, unicidad, relación negacíclica, base de 256 coordenadas, reducción sobreyectiva y cardinalidades de anillo, vectores y matrices. Coeficientes centrados únicos en (-q/2,q/2], reducción y cota absoluta. Normas infinito y euclídea para R, Rq y vectores aplanados; pequeños S_eta, caracterización por coeficientes, separación de cero y cota de la suma de cuadrados.

Pendientes y límites: Las categorías NIST son datos bibliográficos, no garantías demostradas. Los tamaños usan anchos de formato declarados; falta la equivalencia con los codecs y el backend. No demuestra corrección de NTT ni seguridad de firmas. Es la presentación algebraica del manuscrito; no acredita representación en memoria, instrucciones NTT, distribución MLWE ni dureza reticular. La norma centrada se modela por coeficientes enteros canónicos. No establece distribución de muestreo, seguridad de MLWE/MSIS ni implementación de comprobaciones de norma.

Referencias del registro: `Cap4-Nucleo-Criptografico-001`, `Cap6-Validacion-Formal-010`, `Cap6-Validacion-Formal-011`, `Cap6-Validacion-Formal-012`, `Cap6-Validacion-Formal-013`, `Cap6-Validacion-Formal-014`, `Cap6-Validacion-Formal-015`, `Cap6-Validacion-Formal-016`, `Cap6-Validacion-Formal-023`.

### M04 — Distribuciones Module-LWE y soluciones Module-SIS

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Definir espacios finitos, distribuciones independientes, juego decisional y búsqueda.
- Precisar norma, cota, no nulidad y ecuación modular de MSIS.

Alcance demostrado: Leyes PMF normalizadas, eventos, soporte, transporte y composición, producto independiente con masas y marginales, uniforme finita y fórmula cardinal de probabilidad. Incluye tipos infinitos de mensajes y registros mediante PMF. Construcción desde 256 coeficientes y recuperación exacta, transporte de reducción, suma y resta. Levantamiento centrado Rq→R, sección de la reducción, inyectividad y conservación de norma. S_eta entero se identifica biyectivamente con 256 coeficientes de [-eta,eta]. Cardinalidades exactas (2eta+1)^256, no vaciedad, cota de coeficientes y reducción inyectiva que conserva norma cuando eta<=4190208. Cubre eta=2/4 de los perfiles. Relación MSIS con no nulidad modular, ecuación matricial y norma, experimento con matriz uniforme y buscador probabilístico. Centrar no aumenta norma. Lema 6.1 para representantes dados o canónicos: diferencia no nula módulo q, núcleo y cota entera/modular 2L. Matrices, secretos y errores uniformes independientes en los espacios del manuscrito. Ley real (A,As+e), ley ideal (A,u), soporte y marginal uniforme de A, juego decisional con distinguidor aleatorio y búsqueda del secreto. Ventajas acotadas y contraste exacto del caso sin ruido: evento real de probabilidad uno frente a 1/q^(256k) ideal.

Pendientes y límites: No atribuye una distribución ideal a semillas, hashes, muestreadores ni fuentes físicas del ejecutable. Presentación algebraica del anillo, sin equivalencia de almacenamiento, codecs o instrucciones del backend. La ley uniforme es sobre ese conjunto matemático; no verifica la expansión o el muestreo de ML-DSA real. La cota L se expresa como natural y la norma es infinito. No prueba dureza MSIS, extracción desde una firma real ni reducción de peor caso. No demuestra dureza, equivalencia con errores gaussianos de LS15, expansión desde semilla ni seguridad de un perfil concreto.

Referencias del registro: `Cap2-Marco-Teorico-003`, `Cap6-Validacion-Formal-017`, `Cap6-Validacion-Formal-018`, `Cap6-Validacion-Formal-019`, `Cap6-Validacion-Formal-020`, `Cap6-Validacion-Formal-021`.

### M05 — Definición y juego SelfTargetMSIS

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Fijar dimensiones, salida de H, norma y distribución de la instancia.
- Formalizar la relación de victoria sin asumir una reducción desde firmas reales.

Alcance demostrado: Relación SelfTargetMSIS con dimensiones, norma máximo, matriz [I|A], último componente y codificaciones inyectivas explícitas. Juego clásico con matriz y tabla uniforme independientes en dominio finito, presupuesto y consistencia de consultas; cotas necesarias y monotonicidad de la ventaja. Alfabeto concreto B_tau de polinomios con coeficientes centrados en {-1,0,1} y peso tau; norma uno y no nulidad para tau>0, soporte y construcción con signos. Instanciación de la relación SelfTarget con ese alfabeto. Biyeción entre retos B_tau y elección de tau posiciones con un signo por posición. Cardinal exacto choose(256,tau)*2^tau, no vaciedad equivalente a tau<=256 y vacío fuera de dimensión.

Pendientes y límites: Juego clásico de dominio finito, dimensiones y cota de norma como parámetros explícitos. Quedan codec bibliográfico, SampleInBall, acceso cuántico y reducción desde firmas reales; se registran como obligaciones adicionales, no como resultados de este cierre.

Referencias del registro: `Cap2-Marco-Teorico-003`, `Cap6-Validacion-Formal-022`, `Cap6-Validacion-Formal-042`, `Cap6-Validacion-Formal-053`.

### M06 — Esquema de firma, corrección y juegos EUF/sUF-CMA

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Representar algoritmos aleatorios y sus registros de consultas.
- Definir corrección, mensaje nuevo, par nuevo y ventaja; distinguir las dos nociones.

Alcance demostrado: Leyes PMF normalizadas, eventos, soporte, transporte y composición, producto independiente con masas y marginales, uniforme finita y fórmula cardinal de probabilidad. Incluye tipos infinitos de mensajes y registros mediante PMF. Programas de consultas clásicas adaptativas, interpretación probabilística y registro de pares. Se prueban extensión de historia, presupuesto, propiedades del soporte y consistencia de respuestas repetidas a una función fija. KeyGen y Sign probabilísticos y Verify booleano. Corrección, juego CMA con clave privada oculta al adversario, consultas adaptativas y registros. Eventos de mensaje nuevo y par nuevo; Adv_EUF<=Adv_sUF, presupuesto y validez de la historia bajo corrección perfecta, igualdad bajo firmas únicas. Familias despreciables no negativas, cierre por dominación y suma, seguridad EUF/sUF y corrección asintótica parametrizadas. sUF implica EUF para la misma clase de eficiencia. Ejecución concreta distingue las dos condiciones: cambiar la firma de un mensaje consultado da EUF=0 y sUF=1 para ese adversario.

Pendientes y límites: No atribuye una distribución ideal a semillas, hashes, muestreadores ni fuentes físicas del ejecutable. El programa es un modelo clásico con presupuesto de consultas; no modela superposición, tiempo de máquina ni el oráculo SHA3 real. Es un modelo de esquema abstracto, no una prueba de corrección o inforjabilidad de ML-DSA. Faltan codecs, firma hedged, costes, simulación y vínculo con la implementación. La clase de eficiencia es un parámetro explícito, sin semántica PPT mecanizada. El ejemplo distingue eventos y ventajas de un adversario; no afirma seguridad EUF global del esquema de ejemplo ni del backend.

Referencias del registro: `Cap4-Nucleo-Criptografico-002`, `Cap6-Validacion-Formal-024`, `Cap6-Validacion-Formal-025`, `Cap6-Validacion-Formal-026`, `Cap6-Validacion-Formal-030`, `Cap6-Validacion-Formal-031`, `Cap6-Validacion-Formal-042`.

### M07 — Plantilla Fiat–Shamir con abortos y correspondencia ML-DSA

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Representar compromiso, reto, respuesta, pistas y rechazo con dimensiones válidas.
- Separar la plantilla de codificaciones, expansión, firma hedged y backend final.

Alcance demostrado: Plantilla FSwA con dimensiones, respuesta z, reconstrucción Az-ct=Ay-cs2, pistas booleanas, cotas de norma y peso, intento con rechazo y corrección condicionada a reconstrucción de pistas y reto.

Pendientes y límites: No identifica redondeos concretos, codecs, expansión, distribución de máscaras, firma hedged ni simulador del backend.

Referencias del registro: `Cap4-Nucleo-Criptografico-002`, `Cap6-Validacion-Formal-027`, `Cap6-Validacion-Formal-028`, `Cap6-Validacion-Formal-029`, `Cap6-Validacion-Formal-033`, `Cap6-Validacion-Formal-034`, `Cap6-Validacion-Formal-041`, `Cap6-Validacion-Formal-042`.

### M08 — Reducciones bibliográficas CMA→NMA y pérdida QROM de firmas

Estado: **Dependencia bibliográfica**. Prioridad 3.

- Identificar versiones y teoremas B+23/FFH26 con todas sus hipótesis.
- Representar L_Q y certificar la reproducción numérica con error controlado; no atribuir esas hipótesis a NEXUS.

Alcance demostrado: Fórmula L_Q citada y parámetros de referencia B+23. Se prueba positividad, L_Q<2^-360 e intervalo del logaritmo con |log2(L_Q)+361.64|<0.005 mediante cuadrados, racionales y monotonía del logaritmo.

Pendientes y límites: Reproducción aritmética de una fórmula del manuscrito, sin formalizar la reducción bibliográfica ni atribuir sus hipótesis a NEXUS. No reabre QROM AIR/FRI.

Referencias del registro: `Cap6-Validacion-Formal-032`, `Cap6-Validacion-Formal-035`, `Cap6-Validacion-Formal-036`, `Cap6-Validacion-Formal-037`, `Cap6-Validacion-Formal-038`, `Cap6-Validacion-Formal-039`, `Cap6-Validacion-Formal-053`.

### M09 — Peor caso, gaussianas y transformaciones de distribuciones

Estado: **Dependencia bibliográfica**. Prioridad 3.

- Representar los resultados LS15 pertinentes con sus condiciones asintóticas.
- Justificar cambios de secreto, error, módulo y factor de aproximación; no equiparar gaussianas con uniformes pequeños.

Referencias del registro: `Cap6-Validacion-Formal-047`, `Cap6-Validacion-Formal-048`, `Cap6-Validacion-Formal-049`, `Cap6-Validacion-Formal-053`.

### M10 — Contraste numérico de aplicabilidad de JMW24

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Conservar las desigualdades ya probadas para los tres perfiles.
- Instanciar dimensiones, norma y constantes desde los tipos y la versión bibliográfica correctos.

Alcance demostrado: Gamma de extracción se deriva como max(gamma1-beta,2gamma2+1+2^(d-1)tau), dimensiones desde k+ell+1 y tipos Fin; conexión con N12, cuentas de los tres perfiles y fallo de la condición para todo etaAux>=1 y toda gamma mayor.

Pendientes y límites: Contraste de una condición necesaria de JMW24v2, no formalización de su reducción cuántica, ataque ni imposibilidad de otras reducciones. La procedencia bibliográfica está identificada por versión y copia preservada.

Referencias del registro: `Cap6-Validacion-Formal-045`, `Cap6-Validacion-Formal-046`, `Cap6-Validacion-Formal-053`.

### M11 — Autenticación de contenido y composición de transacciones

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Definir codificación inequívoca, hash externo, asociación de clave, cadena y nonce.
- Probar verificación previa al cambio de estado bajo supuestos explícitos de hash y firma.

Alcance demostrado: Documento con identidad, época, cadena, nonce y contenido, codec matemático con longitud y decodificación inversa. Admisión anterior al cambio de estado, controles de cadena/nonce, consumo que evita repetición y cambio de contenido que exige otro hash o colisión. Autorización saliente y posesión entrante se obtienen verificando firmas del mensaje tipado que incluye época y todas las claves siguientes. Instalación exige ambas, conserva identidades e historial y rechaza propuesta repetida o firma ausente. Formato de operation_bytes de registry.rs: dominio ASCII de 22 bytes, identidad de 32, época u64, longitud u64 y mensaje; cuenta 70+len, recuperación de campos e inyectividad. Parser computable del sobre operation_bytes: comprueba dominio, 70 bytes de cabecera y longitud declarada exacta. Ida y vuelta, recodificación canónica, rango u64 de la longitud aceptada, rechazo de truncamientos, dominio y longitud incorrectos. El contexto procede del registro de claves. Aceptar aplica el documento y consume el nonce atómicamente; repetir la solicitud rechaza. Bajo un contrato explícito de procedencia de firmas, admitir implica documento autorizado o colisión con un documento autorizado; excluir ese evento da autorización.

Pendientes y límites: La procedencia de firmas y exclusión de colisiones son hipótesis, no seguridad demostrada de ML-DSA/SHA3. Falta correspondencia de codecs de transacciones y refinamiento Rust; no se identifica el formato con bincode TG1.

Referencias del registro: `Cap1-Introduccion-003`, `Cap4-Nucleo-Criptografico-003`, `Cap4-Nucleo-Criptografico-004`, `Cap4-Nucleo-Criptografico-005`, `Cap6-Validacion-Formal-040`, `Cap6-Validacion-Formal-053`, `Cap6-Validacion-Formal-103`.

### M12 — Derivación determinista, dominios y calidad de semillas

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Definir entradas de derivación y KeyGen semillada; demostrar reproducibilidad.
- Separar determinismo de inyectividad y seguridad; definir por separado distribución, KDF y separación de dominios.

Alcance demostrado: Formato de dominio Sentinel, dos contadores de ocho bytes, semilla de 32 bytes y contexto; inyectividad, reproducibilidad de hash/KeyGen deterministas, separación de entradas de rotación y derivación, y colisión explícita si entradas distintas dan la misma salida.

Pendientes y límites: Determinismo no implica inyectividad del hash: se prueba un contraejemplo constante. No demuestra uniformidad KDF, dureza de SHA3, material fresco, seguridad de KeyGen o ausencia de desbordamientos Rust.

Referencias del registro: `Cap2-Marco-Teorico-005`, `Cap4-Nucleo-Criptografico-006`, `Cap4-Nucleo-Criptografico-007`, `Cap4-Nucleo-Criptografico-008`, `Cap5-Gestion-Claves-017`, `Cap5-Gestion-Claves-018`, `Cap5-Gestion-Claves-019`, `Cap5-Gestion-Claves-020`, `Cap5-Gestion-Claves-021`, `Cap5-Gestion-Claves-024`, `Cap6-Validacion-Formal-033`, `Cap6-Validacion-Formal-034`, `SUP05`.

### M13 — Épocas, identidad, registro y rotación

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Definir estado e invariantes de identidad, época y claves vigentes.
- Demostrar atomicidad del modelo, autorización de cambios y vigencia respecto de un prefijo confiable.
- Mantener custodia, destrucción de copias y secrecia hacia adelante como obligaciones adicionales.

Alcance demostrado: Estado por identidad y época, preparación de lote, instalación atómica bajo controles, conservación de identidad predeterminada e historial, vigencia actual y rechazo de época retirada. Prefijo confiable, truncación posterior indetectable por punto antiguo y hash de prefijo o colisión. Autorización saliente y posesión entrante se obtienen verificando firmas del mensaje tipado que incluye época y todas las claves siguientes. Instalación exige ambas, conserva identidades e historial y rechaza propuesta repetida o firma ausente. Formato de operation_bytes de registry.rs: dominio ASCII de 22 bytes, identidad de 32, época u64, longitud u64 y mensaje; cuenta 70+len, recuperación de campos e inyectividad. Parser computable del sobre operation_bytes: comprueba dominio, 70 bytes de cabecera y longitud declarada exacta. Ida y vuelta, recodificación canónica, rango u64 de la longitud aceptada, rechazo de truncamientos, dominio y longitud incorrectos. Ejecución de listas de propuestas equivalente a una cadena de instalaciones firmadas. Época e historial crecen exactamente con la longitud, se conservan checkpoint, identidades y clave predeterminada. Épocas de propuestas distintas, rechazo persistente y rechazo de repetir cualquier propuesta aplicada; la época anterior deja de estar vigente.

Pendientes y límites: Custodia, borrado de copias, secrecia hacia adelante y checkpoint externo durable siguen abiertos. Un prefijo antiguo admite truncar una extensión. Altas/retiros, archivo completo, seguridad de firmas abstractas y equivalencia Rust son obligaciones adicionales; este modelo solo cierra rotaciones autorizadas y vigencia de época.

Referencias del registro: `Cap3-Diseno-Arquitectura-015`, `Cap5-Gestion-Claves-022`, `Cap5-Gestion-Claves-023`, `Cap5-Gestion-Claves-027`, `Cap7-Conclusiones-004`, `SUP04`, `SUP08`, `SUP09`, `SUP10`, `SUP11`.

### M14 — Min-entropía y acumulación de entropía

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Definir -log₂(max p) para una distribución finita normalizada no vacía.
- Demostrar la relación con la probabilidad de adivinar.
- Precisar independencia o cotas condicionales antes de multiplicar una tasa por la longitud de un bloque.

Alcance demostrado: Distribuciones finitas normalizadas, máximo alcanzable, probabilidad óptima de adivinar, min-entropía y producto independiente. Bloques IID acumulan n veces la min-entropía; dos bits correlacionados muestran por qué la regla requiere independencia.

Pendientes y límites: Caracterización y calificación de una fuente física y pérdidas de acondicionamiento; no se deducen de una muestra.

Referencias del registro: `Cap2-Marco-Teorico-005`, `Cap5-Gestion-Claves-005`, `Cap5-Gestion-Claves-006`, `Cap5-Gestion-Claves-007`, `Cap5-Gestion-Claves-008`, `Cap5-Gestion-Claves-016`.

### M15 — Límite de Shannon empírico para 32 muestras

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Definir frecuencias empíricas y entropía de Shannon.
- Probar H_emp≤log₂(min(n,256)) y especializar n=32 para obtener cinco bits por símbolo.

Alcance demostrado: Entropía empírica y soporte, no negatividad y cota log2(min(n,cardinal alfabeto)). Para 32 bytes la entropía es a lo sumo cinco bits por símbolo y no alcanza 7,5.

Pendientes y límites: Correspondencia con el diagnóstico f64 de Rust y datos de una ejecución; el resultado matemático no evalúa secreto de una clave.

Referencias del registro: `Cap5-Gestion-Claves-004`, `Cap5-Gestion-Claves-005`.

### M16 — RCT: umbral, cuenta consecutiva y perfil numérico

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Modelar el conteo consecutivo y la condición de fallo al alcanzar C.
- Definir el techo bajo H>0 y 0<alpha<1; comprobar H=7.5 y alpha=2^-20.
- Explicitar las hipótesis probabilísticas de cualquier cota de falsas alarmas.

Alcance demostrado: Corte por techo, condición equivalente, minimalidad, corte cuatro del perfil y falsa alarma por racha IID acotada por 2^-20 bajo H>=7,5. Cota de rachas con leyes condicionadas por símbolo inicial e historia repetida, sin exigir IID. Composición con el corte RCT, límites de rachas no fallidas y del incremento del contador u64 del perfil.

Pendientes y límites: Se cierra el modelo exacto del perfil C=4 y el análisis condicionado, no la calificación de una fuente física. Falta equivalencia f64/Rust; las leyes condicionales no se deducen automáticamente de un histograma. La detección al primer símbolo para C=1 no forma parte del perfil ni se afirma aquí.

Referencias del registro: `Cap2-Marco-Teorico-005`, `Cap5-Gestion-Claves-011`, `Cap5-Gestion-Claves-012`, `Cap5-Gestion-Claves-013`, `Cap5-Gestion-Claves-015`.

### M17 — APT: referencia incluida y cola binomial

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Modelar la ventana no binaria de 512 muestras y el conteo que incluye la referencia.
- Definir B=1+Bin(511,2^-7.5) bajo las hipótesis de ese modelo.
- Certificar con intervalos rigurosos la minimalidad del corte 16 y las colas citadas.

Alcance demostrado: Intervalo racional para 2^-7.5, pesos binomiales encerrados, cola partida y resto geométrico. Certifica cola del corte 15 como 1.523e-6 con error<5e-10 y del corte 16 como 2.764e-7 con error<5e-11; complementa la minimalidad ya probada. Se conserva el modelo de ventana con referencia incluida y el corte mínimo 16 probado en Salud/APT.

Pendientes y límites: Se conserva el modelo B=1+Bin(511,2^-7.5). No es equivalencia f64/Rust, calificación de fuente física o certificación SP 800-90B.

Referencias del registro: `Cap2-Marco-Teorico-005`, `Cap5-Gestion-Claves-014`, `Cap5-Gestion-Claves-015`.

### M18 — Compuerta de salud y recuperación del gestor

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Definir estados sin evaluación, fallo retenido, reevaluación y renovación pendiente.
- Probar bloqueo de derivación y operaciones, acumulación de lotes y conservación de contadores al rotar.

Alcance demostrado: Lote 65536, frecuencia máxima exacta, compuerta de uso y edad, recuperación con fallo retenido y renovación pendiente. Reevaluar sin renovar no habilita; rotar exige salud y material fresco y conserva monitor y lote parcial. Invariante muestras<65536 e histograma[i]<=muestras preservado por muestra, lote, recuperación y rotación; límites de incrementos de muestras/histograma y época rotada en u64. Composición atómica de derivación por política y admisión de una operación. Sin evaluación, renovación pendiente o reevaluación sin rotación no se produce estado de operación; éxito exige política, consumo de uso y admisión. Una admisión fallida no produce estado nuevo.

Pendientes y límites: Operaciones que usan la clave en una composición atómica Option con naturales y reales. No se prueba correspondencia Rust/f64, KDF real, firma, persistencia del registro, calificación física, borrado ni secrecia hacia adelante.

Referencias del registro: `Cap5-Gestion-Claves-016`, `Cap5-Gestion-Claves-017`, `Cap5-Gestion-Claves-018`, `Cap5-Gestion-Claves-019`, `Cap5-Gestion-Claves-020`, `Cap5-Gestion-Claves-021`, `SUP06`, `SUP07`.

### M19 — Residencia integral y modelo temporal de captura

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Definir W como integral de bytes de regiones declaradas sobre un horizonte positivo.
- Derivar la media desde intervalos y la probabilidad de coincidencia de una captura uniforme independiente.
- Distinguir suma de copias de unión de intervalos y no inferir probabilidad de compromiso de un cociente de bytes.

Alcance demostrado: Integral de regiones tipadas, recorte por horizonte y suma de copias. Unión de intervalos, cotas y medida exacta sin solapamiento. Fórmulas cacheada/secuencial, media racional y enlace de diez redondeos de la tabla 5.2. Distribución uniforme continua de captura, recorte y probabilidad igual a longitud de unión sobre horizonte. Cota, caso secuencial, complemento, variable uniforme y cinco redondeos temporales de la tabla 5.2.

Pendientes y límites: Las regiones y sus duraciones son declaradas: no se acredita que agoten las copias del ejecutable ni la custodia o el borrado. Calendario fijo e instante uniforme; no demuestra compromiso, semilla protegida, ausencia de residuos ni ataques persistentes o sincronizados.

Referencias del registro: `Cap5-Gestion-Claves-027`, `Cap5-Gestion-Claves-028`, `Cap5-Gestion-Claves-029`, `Cap5-Gestion-Claves-031`, `Cap5-Gestion-Claves-032`.

### M20 — Modelo algebraico y tabla de residencia

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Conservar las cotas y quince redondeos ya comprobados con la latencia fuente.
- Enlazar el modelo algebraico con la integral bajo hipótesis de no solapamiento y sin copias adicionales.

Alcance demostrado: Integral de regiones tipadas, recorte por horizonte y suma de copias. Unión de intervalos, cotas y medida exacta sin solapamiento. Fórmulas cacheada/secuencial, media racional y enlace de diez redondeos de la tabla 5.2. Distribución uniforme continua de captura, recorte y probabilidad igual a longitud de unión sobre horizonte. Cota, caso secuencial, complemento, variable uniforme y cinco redondeos temporales de la tabla 5.2.

Pendientes y límites: Las regiones y sus duraciones son declaradas: no se acredita que agoten las copias del ejecutable ni la custodia o el borrado. Calendario fijo e instante uniforme; no demuestra compromiso, semilla protegida, ausencia de residuos ni ataques persistentes o sincronizados.

Referencias del registro: `Cap5-Gestion-Claves-029`, `Cap5-Gestion-Claves-030`, `Cap5-Gestion-Claves-031`, `Cap5-Gestion-Claves-032`.

### M21 — Tamaños de representaciones y contabilidad de memoria

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Comprobar 4032-96=3936, 4032+1952+9=5993 y 128+17*256*4=17536.
- Vincular cada tamaño con la representación y versión medidas; no interpretarlo como entropía ni RAM total.

Alcance demostrado: Cuentas de 3936, 5993, 17536 y 4064 bytes; distinción de contenedores, tipos y copias del perfil histórico R5. Campos del PrivateKey histórico: 32+32+64 bytes y arreglos L,K,K de 256 i32. Suma y alineación declaradas, perfiles 12416/17536/23680 y enlace del perfil 65 con el modelo de memoria; reordenar conserva la suma.

Pendientes y límites: La vinculación de versión y medición es documental R5, además de la aritmética Lean. No es una prueba universal de ABI/sizeof, RAM total, cantidad de entropía ni zeroización. Generalizar al compilador u objetivo actuales requiere evidencia adicional.

Referencias del registro: `Cap5-Gestion-Claves-025`, `Cap5-Gestion-Claves-026`.

### M22 — Throughput y amortización de datos y verificación

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Conservar razones, límites para prueba fija y equilibrio ya demostrados.
- Probar el caso pi(m) variable bajo pi(m)/m→0 y t_pi(m)/m bajo una hipótesis explícita.
- Certificar la sensibilidad de §6.6.5 y mantener DA, prueba de la lógica y costo del prover como condiciones.

Alcance demostrado: Límite d+L para pi(m)/m→L; equivalencia entre límite d y sublinealidad, piso y equilibrio. Costo de disponibilidad, contraescenario lineal, pruebas polilogarítmicas y cinco redondeos de sensibilidad.

Pendientes y límites: El modelo requiere datos disponibles, prueba de la lógica pertinente y costos de prover/llenado separados; no establece rendimiento de una blockchain ni que filas AIR equivalgan a operaciones.

Referencias del registro: `Cap1-Introduccion-004`, `Cap3-Diseno-Arquitectura-001`, `Cap3-Diseno-Arquitectura-002`, `Cap3-Diseno-Arquitectura-003`, `Cap3-Diseno-Arquitectura-004`, `Cap3-Diseno-Arquitectura-005`, `Cap3-Diseno-Arquitectura-006`, `Cap3-Diseno-Arquitectura-007`, `Cap3-Diseno-Arquitectura-008`, `Cap3-Diseno-Arquitectura-009`, `Cap3-Diseno-Arquitectura-010`, `Cap3-Diseno-Arquitectura-011`, `Cap3-Diseno-Arquitectura-019`, `Cap4-Nucleo-Criptografico-009`, `Cap4-Nucleo-Criptografico-010`, `Cap4-Nucleo-Criptografico-011`, `Cap6-Validacion-Formal-071`, `Cap6-Validacion-Formal-072`, `Cap6-Validacion-Formal-097`, `Cap6-Validacion-Formal-098`.

### M23 — NTT, producto matriz–vector y notación O

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Definir un modelo de operaciones y la familia asintótica; distinguir n fijo de n variable.
- Derivar el recuento k*l, las transformadas y las cotas gruesa y optimizada.
- Enlazar el costo del algoritmo NTT con el del backend como obligación aparte.

Alcance demostrado: Calendario radix dos n=2^r, mariposas por recurrencia y fórmula cerrada. Costo unitario del anillo, producto, matriz, cotas O(n log n) gruesa y optimizada; n=256 fijo separado de la familia variable. Composición de NTT y rechazo para firma esperada: cotas gruesa, optimizada y n fijo. Contraejemplo p_m=1/(m+1) con esperanza m+1 no O(1). Transformada radix dos recursiva sobre árbol par/impar, grado del polinomio y corrección completa por inducción frente a evaluación en coset; raíz de mitad y raíz siguiente, unicidad por evaluaciones e instancia ML-DSA de 256 coeficientes con zeta=1753. Las 256 evaluaciones en zeta*(zeta^2)^i anulan X^256+1. La evaluación del representante es multiplicativa, aditiva y biyectiva en Rq. Enlace del producto negacíclico con el producto coordenado de las dos transformadas recursivas. Cuenta exacta de mariposas de un plan radix dos que comparte las dos mitades. Para n=256: 1024 mariposas, 2048 sumas y 1024 productos; identidad n*log2(n) y cota del trabajo de campo.

Pendientes y límites: El coste es de operaciones de campo con factores de mariposa disponibles. Orden y Montgomery del backend, enteros y desbordamientos, muestreadores, hashes, coste de bits y tiempos CPU siguen separados; este cierre no afirma coste o equivalencia del ejecutable.

Referencias del registro: `Cap6-Validacion-Formal-014`, `Cap6-Validacion-Formal-054`, `Cap6-Validacion-Formal-055`, `Cap6-Validacion-Formal-056`, `Cap6-Validacion-Formal-057`, `Cap6-Validacion-Formal-058`, `Cap6-Validacion-Formal-059`, `Cap6-Validacion-Formal-060`, `Cap6-Validacion-Formal-065`, `Cap6-Validacion-Formal-066`, `Cap6-Validacion-Formal-067`, `Cap6-Validacion-Formal-070`, `Cap6-Validacion-Formal-071`, `Cap6-Validacion-Formal-072`, `Cap6-Validacion-Formal-183`, `Cap6-Validacion-Formal-184`.

### M24 — Rechazo geométrico y costo esperado de firma

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Modelar intentos independientes con probabilidad de aceptación p>0 y probar E[N]=1/p.
- Para O(1), exigir una cota inferior uniforme positiva de p en la familia.
- Conservar por separado el agotamiento del contador y la distribución del ejecutable.

Alcance demostrado: Ley geométrica de mathlib, integrabilidad, E[N]=1/p, aceptación finita, cola de agotamiento y costo esperado c/p. Cota uniforme positiva implica O(1) en intentos y conserva O del costo por intento. Composición de NTT y rechazo para firma esperada: cotas gruesa, optimizada y n fijo. Contraejemplo p_m=1/(m+1) con esperanza m+1 no O(1). Bloques de máscaras disjuntos, validez de índices u16, capacidad floor(65536/ell), incremento y rollover separados. Capacidades 16384/13107/9362 y fronteras de los tres perfiles; enlace con cola geométrica ideal.

Pendientes y límites: No se deduce la ley IID ni p0 del bucle ML-DSA. La distribución real, estimaciones normativas de repeticiones y conducta del contador kappa u16/rollover mantienen su obligación R1-D; los límites del modelo no justifican ignorar agotamiento.

Referencias del registro: `Cap6-Validacion-Formal-041`, `Cap6-Validacion-Formal-054`, `Cap6-Validacion-Formal-055`, `Cap6-Validacion-Formal-056`, `Cap6-Validacion-Formal-057`, `Cap6-Validacion-Formal-058`, `Cap6-Validacion-Formal-059`, `Cap6-Validacion-Formal-060`, `Cap6-Validacion-Formal-061`, `Cap6-Validacion-Formal-062`, `Cap6-Validacion-Formal-063`, `Cap6-Validacion-Formal-064`, `Cap6-Validacion-Formal-070`, `Cap6-Validacion-Formal-183`, `Cap6-Validacion-Formal-184`.

### M25 — Tamaños asintóticos y estructura de pruebas

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Precisar codificaciones y parámetros para cotas de claves y firmas.
- Contar capas, caminos y consultas para O(q log²N); no inferirlo de pocos tiempos medidos.

Alcance demostrado: Conteo de caminos, capas y consultas del formato TG2 declarado; cota cuadrática y O(q log²N), tabla de cuatro tamaños y LDE. Cotas para bits de claves y firmas con anchos y cabeceras explícitos. Conteo de bytes desde codificación de vectores y caminos: 8+32h por camino, 48+64h por capa FRI y suma de capas de longitud variable. Se separan 102 bytes fijos de prueba y 24 de enunciado; el certificado cuenta 126. Biyeción de índices de cabecera y bits de cada coeficiente con posiciones del paquete. Codificación inyectiva, recuperación de todos los bits y longitud exacta. Cotas O para familias en las que cabecera, componentes, grado y ancho varían simultáneamente, con cota uniforme explícita de la cabecera.

Pendientes y límites: Codec matemático de bits de ancho fijo y formato de prueba declarado. Falta equivalencia con empaquetado, serialización y parsing Rust; q fijo positivo y la cota eventual de cabecera son hipótesis explícitas. No se deduce tiempo de ejecución ni una asíntota uniforme en todos los parámetros sin esas hipótesis.

Referencias del registro: `Cap4-Nucleo-Criptografico-001`, `Cap6-Validacion-Formal-023`, `Cap6-Validacion-Formal-068`, `Cap6-Validacion-Formal-070`, `Cap6-Validacion-Formal-086`, `Cap6-Validacion-Formal-104`, `Cap6-Validacion-Formal-105`, `Cap6-Validacion-Formal-137`, `Cap6-Validacion-Formal-138`, `Cap6-Validacion-Formal-139`, `Cap6-Validacion-Formal-140`.

### M26 — Aritmética de mediciones: unidades, razones y redondeos

Estado: **Componente Lean parcial**. Prioridad 1.

- Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.
- Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Alcance demostrado: Racionales extraídos de dos JSON R4 conservados: 175 redondeos dentro de 0.005 y ocho razones de rendimiento. Diferencia de medianas sin redondear, razones históricas H1/H2, inverso ideal de latencia, crecimiento y corrección KiB/firmas: aproximadamente 238, no 232.

Pendientes y límites: Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas.

Referencias del registro: `Cap3-Diseno-Arquitectura-001`, `Cap3-Diseno-Arquitectura-002`, `Cap3-Diseno-Arquitectura-003`, `Cap3-Diseno-Arquitectura-004`, `Cap3-Diseno-Arquitectura-005`, `Cap3-Diseno-Arquitectura-006`, `Cap3-Diseno-Arquitectura-014`, `Cap5-Gestion-Claves-030`, `Cap5-Gestion-Claves-033`, `Cap6-Validacion-Formal-074`, `Cap6-Validacion-Formal-080`, `Cap6-Validacion-Formal-081`, `Cap6-Validacion-Formal-082`, `Cap6-Validacion-Formal-083`, `Cap6-Validacion-Formal-084`, `Cap6-Validacion-Formal-085`, `Cap6-Validacion-Formal-087`, `Cap6-Validacion-Formal-088`, `Cap6-Validacion-Formal-089`, `Cap6-Validacion-Formal-090`, `Cap6-Validacion-Formal-091`, `Cap6-Validacion-Formal-092`, `Cap6-Validacion-Formal-093`, `Cap6-Validacion-Formal-094`, `Cap6-Validacion-Formal-095`, `Cap6-Validacion-Formal-096`, `Cap6-Validacion-Formal-099`, `Cap6-Validacion-Formal-101`, `Cap6-Validacion-Formal-102`.

### M27 — DA, incentivos y quórum como modelos de referencia

Estado: **Modelo verificado en su alcance**. Prioridad 3.

- Definir el juego y pagos antes de afirmar equilibrio de Nash o requisitos de colusión.
- Precisar peso de stake, umbral estricto o inclusivo e intersección de quórums.
- Expresar recuperación y muestreo DA como resultados condicionados; conservar TG1 intacto.

Alcance demostrado: Pesos de stake normalizados e intersección honesta con umbrales estrictos o inclusivos correctos. Juego de pagos explícito: condición necesaria y suficiente de Nash y desviación unilateral rentable. Recuperación Reed-Solomon condicionada y contraejemplo a recuperación por mera duplicación. Muestreo DA sin reemplazo: espacio no vacío y probabilidad exacta de omitir fragmentos no disponibles, fijado el conjunto disponible antes de muestrear. Contraejemplo a intersección honesta con quórums inclusivos 2/3 y peso bizantino exactamente 1/3.

Pendientes y límites: Son modelos de referencia, sin refinamiento del consenso, incentivos o DA desplegados. No se demuestra que atacar requiera mayoría coludida; se conserva esa afirmación de diseño fuera de los teoremas condicionados. No se alteran alcance ni documentos TG1.

Referencias del registro: `Cap3-Diseno-Arquitectura-016`, `Cap3-Diseno-Arquitectura-019`, `SUP02`, `SUP03`.

### M28 — Campos Goldilocks y definiciones, grados y validez AIR

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Conservar campo, cosets, ausencia de polos, equivalencia por residuos y cotas probadas.
- Revisar las cotas más ajustadas de cocientes válidos de §6.7.2 y su correspondencia con la fórmula escrita.

Alcance demostrado: Factorización de fronteras válidas, cocientes de frontera de grado <=T-2, numeradores de frontera de grado <=2(T-1), cociente de transición de grado <=T y composición de grado <=T. Para trazas válidas, identidad racional fuera de polos y grado <2T.

Pendientes y límites: El cociente euclídeo está definido incluso con resto no nulo: su cota de grado por sí sola no demuestra validez. La identidad racional requiere divisibilidad. No demuestra refinamiento Rust, NTT ni aceptación de certificados.

Referencias del registro: `Cap6-Validacion-Formal-114`, `Cap6-Validacion-Formal-115`, `Cap6-Validacion-Formal-116`.

### M29 — Cancelación, distancia y transferencia local AIR

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Conservar cancelación uniforme, distancia y pérdida 3*epsilon ya demostradas.
- Probar el caso de masa puntual máxima y el ejemplo concreto de cancelación cuando se solicite su cierre completo.

Alcance demostrado: Cota de un evento con resultado único por la masa máxima. Ley conjunta por contexto y reto condicionado, unicidad de cancelación lineal y cota condicional. Para tres retos independientes con masas <=mu y residuos no todos nulos, cancelación <=mu; aplicación a una traza AIR fija inválida. Polinomio explícito sobre Goldilocks: 16 evaluaciones, cambio de primera fila de 3 a 4, invalidez, recurrencias restantes y resto combinado nulo para alpha0=10376293027944593777, alpha1=alpha2=1. Grado exacto de la traza 15, numerador 32 y composición 16. Existe una traza válida alternativa con la misma salida pública.

Pendientes y límites: La cota condicional exige la ley condicionada y su masa máxima; no construye esa ley para todas las historias del protocolo. El corolario de tres retos usa independencia explícita. El adaptador causal y la composición ROM siguen abiertos. Los coeficientes se eligen algebraicamente; no se fuerzan retos SHA3 ni se prueba aceptación de un certificado o de un enunciado falso. No acredita conocimiento cero ni solidez global.

Referencias del registro: `Cap6-Validacion-Formal-108`, `Cap6-Validacion-Formal-117`, `Cap6-Validacion-Formal-118`, `Cap6-Validacion-Formal-119`, `Cap6-Validacion-Formal-120`, `Cap6-Validacion-Formal-121`, `Cap6-Validacion-Formal-122`, `Cap6-Validacion-Formal-123`, `Cap6-Validacion-Formal-124`, `Cap6-Validacion-Formal-125`, `Cap6-Validacion-Formal-147`, `Cap6-Validacion-Formal-148`.

### M30 — Contraejemplo de traza y distancia exacta 7/8

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Construir F=f+lambda*(X^T-1), probar grados, fronteras y grado de composición.
- Demostrar las dos desigualdades de la distancia exacta 7/8, incluida la construcción que alcanza T acuerdos.
- Mantener la aceptación de los tres certificados como evidencia empírica separada.

Alcance demostrado: Cota de acuerdos por grado y aproximante construido cancelando el término principal mediante el anulador de T puntos elegidos. Exactamente T acuerdos, distancia mínima alcanzada y valor 7/8 cuando |L|=8T, en cualquier campo. F=f+lambda*(X^T-1), grado T y coeficiente principal lambda. Conserva filas, fronteras, transiciones, validez y residuos. Difiere en todos los puntos sin polos; distancia al testigo original uno y mínimo al código 7/8. Transición de grado 2T y coeficiente principal -2*lambda^2 en característica distinta de dos. Fronteras de grado T-1 y composición de grado a lo sumo T+2<2T para T>=4, para cualquier combinación de coeficientes. Divisibilidad y evaluación del cociente iguales a la composición racional sobre puntos sin polos. Anulador de exactamente T-2 transiciones, separación de las últimas filas, divisibilidad de la transición válida, cociente de grado exacto T+2 y factorización del denominador que identifica el cociente con la fórmula AIR. Ejecución recursiva de cuadrados desde dos filas iniciales, transporte por homomorfismos e interpolación de Lagrange. Se construye un polinomio de grado menor que T con las filas y validez AIR demostradas. Construcción desde inicio 3, segunda fila 5 y lambda=1 en Goldilocks/Fp2, con imagen desde el campo base. Para 4<=k<=29: ejecución válida, traza de grado T=2^k, mínimo de distancia 7/8 incluso frente a candidatos de extensión y composición de grado <2T para todo coeficiente, igual a la expresión racional en todo el coset. No existe aproximante a distancia <=1/24; cuentas algebraicas de 16/32/64 filas.

Pendientes y límites: El dominio es un finset de puntos distintos. La distancia matemática no implica aceptación de una prueba, corrección de compromisos o solidez de un verificador. Requiere lambda no nulo y grado f<T; la validez original se recibe explícitamente en el modelo general. La ejecución concreta se construye por separado, sin asumir aceptación del legado. La composición es la fórmula AIR del manuscrito; las aceptaciones SHA3/Merkle/FRI/grinding del ejecutable permanecen empíricas y no se deducen de la pertenencia al código. Requiere raíz primitiva, T>=3 y característica distinta de dos para el grado exacto. No es un teorema sobre el bucle del verificador. Es interpolación algebraica; no formaliza la implementación NTT del interpolante ni sus costos o su serialización. No demuestra aceptación o rechazo de programas Rust, vinculación criptográfica, conocimiento cero ni solidez global. Los tres casos empíricos y sus seis certificados conservan identidad y alcance.

Referencias del registro: `Cap6-Validacion-Formal-108`, `Cap6-Validacion-Formal-126`, `Cap6-Validacion-Formal-127`, `Cap6-Validacion-Formal-128`, `Cap6-Validacion-Formal-129`, `Cap6-Validacion-Formal-130`, `Cap6-Validacion-Formal-131`, `Cap6-Validacion-Formal-132`, `Cap6-Validacion-Formal-133`, `Cap6-Validacion-Formal-134`.

### M31 — Límites del verificador legado y del conocimiento cero

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Representar el puente de raíces y su dominio, incluidos alias y rango de índices.
- Formalizar la reconstrucción del testigo del ejemplo pequeño si se usa como resultado matemático.
- No convertir pruebas de casos ni ausencia de enmascaramiento en una prueba general de solidez.

Alcance demostrado: Puente legado de raíz a campo mediante ocho bytes LE y reducción; dominio canónico inyectivo, cola de 24 bytes ignorada, alias concretos 0/p e índices congruentes. Recuperación polinómica desde suficientes aperturas públicas distintas. Dieciséis índices distintos de un dominio de 128 dan nodos distintos; interpolación recupera cualquier polinomio de grado<16 y, para la traza del ejemplo, la segunda fila 5. Dieciséis índices, consultas, ranuras y valores literales del certificado legado público de 16 filas. Se prueban las posiciones seleccionadas, nodos distintos, grado menor que 16, evaluaciones exactas, interpolación y recuperación de la segunda fila 5, también para cualquier traza compatible de ese grado. Rust y una relectura Python enlazan externamente los bytes concretos con esas constantes.

Pendientes y límites: Ejemplo concreto de PqValidityProof legado, con hojas AIR de ocho bytes y dominio NEXUS-STARK-v2; no se identifica con TG2 v1. El enlace de archivo/SHA3/bincode es evidencia ejecutada externa al núcleo Lean. No prueba refinamiento universal Rust, ZK ni solidez general.

Referencias del registro: `Cap6-Validacion-Formal-103`, `Cap6-Validacion-Formal-107`, `Cap6-Validacion-Formal-108`, `Cap6-Validacion-Formal-112`, `Cap6-Validacion-Formal-131`, `Cap6-Validacion-Formal-132`, `Cap6-Validacion-Formal-133`, `Cap6-Validacion-Formal-134`, `Cap6-Validacion-Formal-162`, `Cap6-Validacion-Formal-163`, `Cap6-Validacion-Formal-164`, `Cap6-Validacion-Formal-165`.

### M32 — Raíz compartida, aperturas AIR y enlace FRI de TG2

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Conservar el enlace local ya probado para el formato Fp2 compartido.
- Derivar ambas aceptaciones FRI del recorrido completo, acarreo y valor final, con formas e índices válidos.

Alcance demostrado: Evaluador Merkle que devuelve digest y consultas en orden desde la hoja; coincide con el bucle indexado y produce el registro exigido por extracción. Forma incorrecta rechaza sin hashes; aceptación registra cada entrada y cuesta altura+1 consultas. Bucle con Option, rechazo persistente, prefijos, posiciones, autenticación y acarreo extraídos de ejecución aceptada; ecuaciones de plegado y constante final, aceptación de una muestra y de ambas fases. Comprobaciones de longitudes de listas y rechazo con cero capas. Las dos ejecuciones FRI dan las premisas de aceptación compartida AIR/FRI con raíz inicial común, seis aperturas y enlace local. Cota de la rama de candidato no base a partir de controles de base de la muestra, sin exigir que el oráculo completo sea base.

Pendientes y límites: Se deriva el registro de cada apertura modelada. La integración de esos eventos en la tabla común, las familias causales y toda la ejecución Rust permanece pendiente en M37/M39. Modelo de naturales y operaciones de campo. La extracción requiere ausencia de colisiones y registro de aperturas. La equivalencia con toda la ejecución Rust y su tabla ROM no se deriva de este bucle. La familia construida usa el registro final para la implicación de aceptación. Su identificación con una familia causal previa a cada reto sigue en M37/M36. La probabilidad de muestra es la uniforme ideal; el selector real corresponde a M35/M40.

Referencias del registro: `Cap6-Validacion-Formal-135`, `Cap6-Validacion-Formal-136`, `Cap6-Validacion-Formal-137`, `Cap6-Validacion-Formal-138`, `Cap6-Validacion-Formal-139`, `Cap6-Validacion-Formal-140`, `Cap6-Validacion-Formal-141`, `Cap6-Validacion-Formal-157`.

### M33 — Torres FRI y recuperación adaptativa

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Conservar representantes, plegado, recuperación y excepciones previas al reto ya demostrados.
- Separar el lema elemental mecanizado del corolario bibliográfico general y del cambio uniforme beta/a_j.

Alcance demostrado: Cambio biyectivo entre beta y el peso afín en un representante no nulo, fórmula de mariposa y cardinales de preimágenes. Normalización global x=a*y con reto beta/a, equivalencia del plegado y conservación de uniformidad por conteo.

Pendientes y límites: Se cierra el lema elemental y el cambio uniforme de coordenadas bajo sus hipótesis. Corolario bibliográfico general, transformación integral de transcripciones, adaptador Rust y composición global ROM siguen separados. Una biyección por punto no produce retos independientes para puntos distintos.

Referencias del registro: `Cap6-Validacion-Formal-142`, `Cap6-Validacion-Formal-143`, `Cap6-Validacion-Formal-166`, `Cap6-Validacion-Formal-167`, `Cap6-Validacion-Formal-168`.

### M34 — Cota ideal histórica y sus tablas

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Formalizar E_i, su unión conservadora y los redondeos de la Tabla 6.19 si se mantiene como resultado matemático.
- No sustituir esa fórmula histórica por la cota refinada, aunque ambas tengan componentes comunes.

Alcance demostrado: Fórmula histórica con error por rondas, omisión y unión conservadora, conservada separada de la fórmula refinada. Techo para el número de parejas, cuatro redondeos superiores de la tabla 6.19 y unión de cuatro eventos PMF bajo inclusión y cotas individuales.

Pendientes y límites: Las cotas individuales FRI y la descomposición del protocolo son hipótesis explícitas. No mecaniza el teorema bibliográfico general ni el verificador completo.

Referencias del registro: `Cap6-Validacion-Formal-142`, `Cap6-Validacion-Formal-143`, `Cap6-Validacion-Formal-144`, `Cap6-Validacion-Formal-145`, `Cap6-Validacion-Formal-150`, `Cap6-Validacion-Formal-151`, `Cap6-Validacion-Formal-152`, `Cap6-Validacion-Formal-153`, `Cap6-Validacion-Formal-154`, `Cap6-Validacion-Formal-155`, `Cap6-Validacion-Formal-156`.

### M35 — Muestra compartida e hipergeométrica H

Estado: **Componente Lean parcial**. Prioridad 2.

- Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.
- Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Alcance demostrado: Proyección a conjuntos del selector con duplicados y parada: cardinal min(objetivo,distintas), terminación por suficientes distintas y equivariancia por permutaciones. Máscara binaria igual a residuo y fibras uniformes para potencias de dos. El selector incompleto coincide con pocas distintas y su probabilidad ideal tras 512 extracciones es <2^-300 en nueve perfiles. Toda permutación transporta la salida del selector. Se construye una biyección entre fibras de dos subconjuntos del mismo tamaño. Partición de las palabras completas y uniformidad exacta del q-subconjunto condicionada a completar antes de un corte fijo. Partición de selecciones completas contenidas en G. La probabilidad condicionada coincide exactamente con choose(cardG,q)/choose(M,q), satisface H(M,q,theta) y la cota exponencial. Composición aritmética de la mezcla con un fallo de masa tau. Ley racional normalizada que aborta con masa tau y, al completar, devuelve un q-subconjunto uniforme. Su variación total respecto de la muestra ideal es exactamente tau; todo evento pierde a lo sumo tau. Para el corte 512 y los nueve perfiles, la pérdida modelada es menor que 2^-300. Biyeción de completaciones de una tabla parcial con funciones en las claves libres y cardinal exacto. Cada respuesta en una clave ausente tiene masa condicionada 1/cardA; las respuestas repetidas están fijadas y una respuesta distinta es imposible. La estrategia depende de prefijos de respuestas. Para toda historia admisible, sus tablas compatibles equivalen a completaciones de las consultas vistas, con cardinal exacto. La siguiente respuesta fresca es uniforme condicionada a esa historia; repeticiones conservan respuesta y distintas consultas no superan la longitud del registro. Gramática conjunta de inicio, perfil, enunciado, raíces, fases, finales, nonce, E/I, trabajo y Merkle TG2 v1. Longitudes máximas de 79 octetos; las absorciones que coinciden con un nodo son de enunciado y se conserva un solapamiento explícito. No se separan artificialmente las tablas por rol. Claves finitas con longitud y hasta 79 octetos, iguales si y solo si sus bytes coinciden; el solapamiento entre roles comparte clave. Todo programa finito produce historia causal compatible, y se deriva la ley fresca y la repetida en cada prefijo. El compilador a árboles de candidatos memoriza por clave y no sortea otra respuesta en una repetición, incluso entre roles. Programa del canal con bytes de perfil y enunciado, tres alfas, dos fases FRI, trabajo, absorción de nonce y un selector compartido. Desde el recorrido se demuestra la cuenta 13+2*(longitudes de ambas listas de raíces)+R+C, con rechazo de trabajo y duplicados incluidos; se identifica con canalPerfil si las listas tienen longitudes k y k+1. Selector en orden de primera aparición: conserva prefijos, no duplica índices y su proyección a conjuntos es exactamente el programa anterior sobre la misma tabla. Una ejecución aceptada entrega cuarenta índices distintos y una continuación aceptada. El canal entrega las dos coordenadas reducidas de cada E, tres alfas, todos los betas y los cuarenta índices en orden. Olvidar los valores de retos/raíces recupera los programas anteriores. La aceptación entrega longitudes exactas, índices sin duplicados y una continuación aceptada. Se prueba el presupuesto completo con trabajo rechazado y duplicados para toda tabla. Ruta matemática completa desde el lector estricto hasta forma, canal, trabajo por ceros iniciales, índices ordenados y cuarenta consultas con ambas fases FRI. No se truncan listas desiguales por zip. La aceptación produce forma válida, tres alfas, k/k+1 betas, cuarenta índices distintos y todos los controles de las consultas. El presupuesto del programa y de su registro coincide con V_T, incluidos rechazos. Parseo fallido, forma inválida y sufijo estricto rechazan antes del hash; el nonce válido no introduce alias.

Pendientes y límites: El canal conserva desafíos e índices en orden y su proyección a conjuntos está probada. Falta instanciar la ley uniforme ideal mediante claves frescas bajo las excepciones para todas las historias del ejecutable y adversario; no se retira la condición de frescura ni se supone independencia entre fases.

Referencias del registro: `Cap6-Validacion-Formal-107`, `Cap6-Validacion-Formal-142`, `Cap6-Validacion-Formal-143`, `Cap6-Validacion-Formal-149`, `Cap6-Validacion-Formal-150`, `Cap6-Validacion-Formal-151`, `Cap6-Validacion-Formal-152`, `Cap6-Validacion-Formal-153`, `Cap6-Validacion-Formal-154`, `Cap6-Validacion-Formal-155`, `Cap6-Validacion-Formal-156`, `Cap6-Validacion-Formal-166`, `Cap6-Validacion-Formal-167`, `Cap6-Validacion-Formal-168`, `Cap6-Validacion-Formal-169`, `Cap6-Validacion-Formal-170`, `Cap6-Validacion-Formal-171`, `Cap6-Validacion-Formal-172`.

### M36 — Solidez ideal por rondas y reinicios

Estado: **Componente Lean parcial**. Prioridad 2.

- Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.
- Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Alcance demostrado: Las dos ejecuciones FRI dan las premisas de aceptación compartida AIR/FRI con raíz inicial común, seis aperturas y enlace local. Cota de la rama de candidato no base a partir de controles de base de la muestra, sin exigir que el oráculo completo sea base. Potencial de árboles de pruebas frescas con creación adaptativa, intercalación, abandono, repeticiones y parada. Se demuestra riesgo<=potencialInicial+B*rho y desde vacío B*rho; trabajo se cobra antes de responder y se conserva el factor en la cota de inicios<=Q+1. Unión de tres eventos bajo una misma ley, transporte por variación total, composición de errores ROM/excepciones/consulta y suma de presupuestos. Se conserva la cota del juego ROM ya demostrado sin su mínimo con uno. La estrategia depende de prefijos de respuestas. Para toda historia admisible, sus tablas compatibles equivalen a completaciones de las consultas vistas, con cardinal exacto. La siguiente respuesta fresca es uniforme condicionada a esa historia; repeticiones conservan respuesta y distintas consultas no superan la longitud del registro. Claves finitas con longitud y hasta 79 octetos, iguales si y solo si sus bytes coinciden; el solapamiento entre roles comparte clave. Todo programa finito produce historia causal compatible, y se deriva la ley fresca y la repetida en cada prefijo. El compilador a árboles de candidatos memoriza por clave y no sortea otra respuesta en una repetición, incluso entre roles. Programa del canal con bytes de perfil y enunciado, tres alfas, dos fases FRI, trabajo, absorción de nonce y un selector compartido. Desde el recorrido se demuestra la cuenta 13+2*(longitudes de ambas listas de raíces)+R+C, con rechazo de trabajo y duplicados incluidos; se identifica con canalPerfil si las listas tienen longitudes k y k+1.

Pendientes y límites: Completar el adaptador integral de rondas y reinicios y obtener revisión independiente; el autor declaró que no hay dictamen. El compilador de programas finitos no identifica por sí solo los inicios B con consultas hash Q.

Referencias del registro: `Cap6-Validacion-Formal-166`, `Cap6-Validacion-Formal-167`, `Cap6-Validacion-Formal-168`, `Cap6-Validacion-Formal-169`, `Cap6-Validacion-Formal-170`, `Cap6-Validacion-Formal-171`, `Cap6-Validacion-Formal-172`.

### M37 — Extracción Merkle, bytes y orden temporal ROM

Estado: **Componente Lean parcial**. Prioridad 2.

- Conservar extracción, congelación y órdenes de primeras consultas bajo ausencia de aciertos.
- Obtener los hechos de registro y familias causales para todas las historias del protocolo.

Alcance demostrado: Evaluador Merkle que devuelve digest y consultas en orden desde la hoja; coincide con el bucle indexado y produce el registro exigido por extracción. Forma incorrecta rechaza sin hashes; aceptación registra cada entrada y cuesta altura+1 consultas. Biyeción de completaciones de una tabla parcial con funciones en las claves libres y cardinal exacto. Cada respuesta en una clave ausente tiene masa condicionada 1/cardA; las respuestas repetidas están fijadas y una respuesta distinta es imposible. La estrategia depende de prefijos de respuestas. Para toda historia admisible, sus tablas compatibles equivalen a completaciones de las consultas vistas, con cardinal exacto. La siguiente respuesta fresca es uniforme condicionada a esa historia; repeticiones conservan respuesta y distintas consultas no superan la longitud del registro. Gramática conjunta de inicio, perfil, enunciado, raíces, fases, finales, nonce, E/I, trabajo y Merkle TG2 v1. Longitudes máximas de 79 octetos; las absorciones que coinciden con un nodo son de enunciado y se conserva un solapamiento explícito. No se separan artificialmente las tablas por rol. Claves finitas con longitud y hasta 79 octetos, iguales si y solo si sus bytes coinciden; el solapamiento entre roles comparte clave. Todo programa finito produce historia causal compatible, y se deriva la ley fresca y la repetida en cada prefijo. El compilador a árboles de candidatos memoriza por clave y no sortea otra respuesta en una repetición, incluso entre roles. Programa del canal con bytes de perfil y enunciado, tres alfas, dos fases FRI, trabajo, absorción de nonce y un selector compartido. Desde el recorrido se demuestra la cuenta 13+2*(longitudes de ambas listas de raíces)+R+C, con rechazo de trabajo y duplicados incluidos; se identifica con canalPerfil si las listas tienen longitudes k y k+1. Se recuperan los bytes exactos de cada clave; las entradas del programa cuentan sus respuestas y miden a lo sumo 79 octetos. La secuencia de programas conserva el rechazo, concatena el registro solo cuando acepta el primero y suma los presupuestos para toda tabla. Cada apertura Merkle se ejecuta como programa de peticiones de hoja y nodos en la tabla común. Resultado y registro coinciden con el evaluador indexado anterior. Una longitud incorrecta rechaza sin hash; la aceptación produce el registro de extracción y cuesta altura+1. Se prueba la cota para toda tabla y la extracción sin colisiones registradas. Programa FRI que autentica izquierda/derecha antes del acarreo y rechaza longitudes incorrectas. Aceptación caracterizada por todas las autenticaciones, compatibilidades y constante final. El paso coincide con el paso Option anterior; se demuestra costo 2*(suma de alturas+número de capas). Cada apertura y la continuación aceptada están en el registro real del programa; todo el recorrido aceptado produce esos registros. El canal entrega las dos coordenadas reducidas de cada E, tres alfas, todos los betas y los cuarenta índices en orden. Olvidar los valores de retos/raíces recupera los programas anteriores. La aceptación entrega longitudes exactas, índices sin duplicados y una continuación aceptada. Se prueba el presupuesto completo con trabajo rechazado y duplicados para toda tabla. Ruta matemática completa desde el lector estricto hasta forma, canal, trabajo por ceros iniciales, índices ordenados y cuarenta consultas con ambas fases FRI. No se truncan listas desiguales por zip. La aceptación produce forma válida, tres alfas, k/k+1 betas, cuarenta índices distintos y todos los controles de las consultas. El presupuesto del programa y de su registro coincide con V_T, incluidos rechazos. Parseo fallido, forma inválida y sufijo estricto rechazan antes del hash; el nonce válido no introduce alias.

Pendientes y límites: Las aperturas Merkle y recorridos FRI producen sus registros desde programas efectivos sobre una tabla común. Falta derivar familias causales y congelación antes de la primera exposición para todas las historias, incluyendo intercalaciones y consultas arbitrarias del adversario fuera de la gramática.

Referencias del registro: `Cap6-Validacion-Formal-106`, `Cap6-Validacion-Formal-162`, `Cap6-Validacion-Formal-163`, `Cap6-Validacion-Formal-164`, `Cap6-Validacion-Formal-165`, `Cap6-Validacion-Formal-174`.

### M38 — Sesgo de reducción modular, híbridos y masa máxima

Estado: **Modelo verificado en su alcance**. Prioridad 1.

- Contar preimágenes de la reducción modular de bloques uniformes.
- Probar Delta_F=r*(p-r)/(p*S), el producto de coordenadas y el híbrido de m retos frescos.
- Certificar los números Goldilocks sin condicionar a sucesos futuros del registro.

Alcance demostrado: Leyes racionales finitas normalizadas, variación total y cota de cualquier evento; productos independientes y pérdida aditiva, con iteración para m factores. Conteo exacto de preimágenes de x mod p sobre S valores; ley normalizada, Delta=r(p-r)/(pS), masa máxima y cuadrado para pares independientes. Cota de eventos para m retos de dos coordenadas y números Goldilocks, incluido 56Delta<7.069e-28.

Pendientes y límites: La independencia es explícita en la construcción del producto. No establece frescura para historias adaptativas del protocolo. Se refiere a bloques uniformes frescos e independientes. Falta el adaptador causal que atribuya estas leyes a todas las respuestas relevantes del registro ROM.

Referencias del registro: `Cap6-Validacion-Formal-112`, `Cap6-Validacion-Formal-158`, `Cap6-Validacion-Formal-159`, `Cap6-Validacion-Formal-160`, `Cap6-Validacion-Formal-162`, `Cap6-Validacion-Formal-163`, `Cap6-Validacion-Formal-164`, `Cap6-Validacion-Formal-165`, `Cap6-Validacion-Formal-174`, `Cap6-Validacion-Formal-175`.

### M39 — Presupuestos, formas, gramática y semántica del verificador

Estado: **Componente Lean parcial**. Prioridad 2.

- Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.
- Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Alcance demostrado: Forma tipada de seis aperturas AIR y dos por capa FRI, longitudes y hashes de rutas. Fórmulas de caminos, hojas, etiquetas, canal y retos, monotonía del corte y suma de presupuestos. Extremos T=16/4096: V=6943/24895 y B=5450/22106. Evaluador Merkle que devuelve digest y consultas en orden desde la hoja; coincide con el bucle indexado y produce el registro exigido por extracción. Forma incorrecta rechaza sin hashes; aceptación registra cada entrada y cuesta altura+1 consultas. Bucle con Option, rechazo persistente, prefijos, posiciones, autenticación y acarreo extraídos de ejecución aceptada; ecuaciones de plegado y constante final, aceptación de una muestra y de ambas fases. Comprobaciones de longitudes de listas y rechazo con cero capas. Conteo de bytes desde codificación de vectores y caminos: 8+32h por camino, 48+64h por capa FRI y suma de capas de longitud variable. Se separan 102 bytes fijos de prueba y 24 de enunciado; el certificado cuenta 126. Para k<=12, tamaños de dominio <=32768 y dentro de u64, mitades positivas e índices de ambas aperturas válidos; lecturas de listas aceptadas en rango, longitudes de zip y rechazo de longitudes incorrectas. Gramática conjunta de inicio, perfil, enunciado, raíces, fases, finales, nonce, E/I, trabajo y Merkle TG2 v1. Longitudes máximas de 79 octetos; las absorciones que coinciden con un nodo son de enunciado y se conserva un solapamiento explícito. No se separan artificialmente las tablas por rol. Programa del canal con bytes de perfil y enunciado, tres alfas, dos fases FRI, trabajo, absorción de nonce y un selector compartido. Desde el recorrido se demuestra la cuenta 13+2*(longitudes de ambas listas de raíces)+R+C, con rechazo de trabajo y duplicados incluidos; se identifica con canalPerfil si las listas tienen longitudes k y k+1. Conversión, suma, división y módulo de USize se enlazan exactamente con naturales bajo cotas explícitas. Las seis posiciones AIR de TG2 coinciden con sus operaciones de máquina; sus sumas intermedias caben incluso en 32 bits para N<=32768 e i<N/2. Se instancia N=2^(k+3), k<=12. Se recuperan los bytes exactos de cada clave; las entradas del programa cuentan sus respuestas y miden a lo sumo 79 octetos. La secuencia de programas conserva el rechazo, concatena el registro solo cuando acepta el primero y suma los presupuestos para toda tabla. Cada apertura Merkle se ejecuta como programa de peticiones de hoja y nodos en la tabla común. Resultado y registro coinciden con el evaluador indexado anterior. Una longitud incorrecta rechaza sin hash; la aceptación produce el registro de extracción y cuesta altura+1. Se prueba la cota para toda tabla y la extracción sin colisiones registradas. Lectores con resto para prefijos, enteros LE, digest, campo, extensión y vectores. Se prueban ida/vuelta, rechazo por truncamiento, coordenada no canónica, longitud esperada incorrecta y cola en la envoltura EOF estricta. Composición de codificadores y lectores de enteros, campos, productos, listas y transporte de estructuras. Ida/vuelta en el dominio de anchos explícitos, codificación inyectiva y lectura completa con rechazo de sufijos. Estructuras y codec del certificado completo (TransitionStatement,LinkedProof): puntos AIR, capas FRI, compromisos, consultas y cabecera, con orden y anchos explícitos. Lectura con resto, lectura estricta, inyectividad, rechazo de cola y longitudes de enunciado/punto. La capa coincide con la serialización ya demostrada. Selector en orden de primera aparición: conserva prefijos, no duplica índices y su proyección a conjuntos es exactamente el programa anterior sobre la misma tabla. Una ejecución aceptada entrega cuarenta índices distintos y una continuación aceptada. Programa FRI que autentica izquierda/derecha antes del acarreo y rechaza longitudes incorrectas. Aceptación caracterizada por todas las autenticaciones, compatibilidades y constante final. El paso coincide con el paso Option anterior; se demuestra costo 2*(suma de alturas+número de capas). Cada apertura y la continuación aceptada están en el registro real del programa; todo el recorrido aceptado produce esos registros. El canal entrega las dos coordenadas reducidas de cada E, tres alfas, todos los betas y los cuarenta índices en orden. Olvidar los valores de retos/raíces recupera los programas anteriores. La aceptación entrega longitudes exactas, índices sin duplicados y una continuación aceptada. Se prueba el presupuesto completo con trabajo rechazado y duplicados para toda tabla. Forma previa al canal: 2^k filas para 4<=k<=12, perfil 12/20, versión 1, nonce de 64 bits, raíz compartida, cuarenta consultas, seis puntos y todos los caminos/capas con longitud correcta. Se extraen las cotas 16/4096 y las cantidades y formas de cada consulta. Secuencia real de seis aperturas AIR, enlace de traza, FRI de traza, enlace de composición y FRI de composición. Se caracteriza la aceptación de todos los controles y se prueba el presupuesto de una consulta para toda tabla. La longitud AIR se comprueba antes de zip; si es incorrecta no se emiten hashes. Ruta matemática completa desde el lector estricto hasta forma, canal, trabajo por ceros iniciales, índices ordenados y cuarenta consultas con ambas fases FRI. No se truncan listas desiguales por zip. La aceptación produce forma válida, tres alfas, k/k+1 betas, cuarenta índices distintos y todos los controles de las consultas. El presupuesto del programa y de su registro coincide con V_T, incluidos rechazos. Parseo fallido, forma inválida y sufijo estricto rechazan antes del hash; el nonce válido no introduce alias.

Pendientes y límites: El certificado y su lector matemático, formas, rechazos, canal y todas las aperturas ya están compuestos con presupuesto V_T demostrado. Falta refinamiento universal del parser serde/bincode, las otras operaciones de máquina y el ejecutable Rust. Se conserva la diferencia de EOF y el corte analítico R; el contraste de cincuenta casos es evidencia externa, no equivalencia universal.

Referencias del registro: `Cap6-Validacion-Formal-104`, `Cap6-Validacion-Formal-105`, `Cap6-Validacion-Formal-176`, `Cap6-Validacion-Formal-177`, `Cap6-Validacion-Formal-178`.

### M40 — Potencial de nonces y cola del selector

Estado: **Componente Lean parcial**. Prioridad 2.

- Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.
- Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Alcance demostrado: Inyección de secuencias con a lo sumo q valores distintos en testigos de subconjunto; cota cardinal binomial(M,q)q^R y cola uniforme min(1,binomial(M,q)(q/M)^R). Para q=39,R=512 y los nueve perfiles, tau<2^-300. Se explicita que condicionar a trabajo válido elimina su factor. Proyección a conjuntos del selector con duplicados y parada: cardinal min(objetivo,distintas), terminación por suficientes distintas y equivariancia por permutaciones. Máscara binaria igual a residuo y fibras uniformes para potencias de dos. El selector incompleto coincide con pocas distintas y su probabilidad ideal tras 512 extracciones es <2^-300 en nueve perfiles. Potencial de árboles de pruebas frescas con creación adaptativa, intercalación, abandono, repeticiones y parada. Se demuestra riesgo<=potencialInicial+B*rho y desde vacío B*rho; trabajo se cobra antes de responder y se conserva el factor en la cota de inicios<=Q+1. Ley racional normalizada que aborta con masa tau y, al completar, devuelve un q-subconjunto uniforme. Su variación total respecto de la muestra ideal es exactamente tau; todo evento pierde a lo sumo tau. Para el corte 512 y los nueve perfiles, la pérdida modelada es menor que 2^-300. La estrategia depende de prefijos de respuestas. Para toda historia admisible, sus tablas compatibles equivalen a completaciones de las consultas vistas, con cardinal exacto. La siguiente respuesta fresca es uniforme condicionada a esa historia; repeticiones conservan respuesta y distintas consultas no superan la longitud del registro. Gramática conjunta de inicio, perfil, enunciado, raíces, fases, finales, nonce, E/I, trabajo y Merkle TG2 v1. Longitudes máximas de 79 octetos; las absorciones que coinciden con un nodo son de enunciado y se conserva un solapamiento explícito. No se separan artificialmente las tablas por rol. Claves finitas con longitud y hasta 79 octetos, iguales si y solo si sus bytes coinciden; el solapamiento entre roles comparte clave. Todo programa finito produce historia causal compatible, y se deriva la ley fresca y la repetida en cada prefijo. El compilador a árboles de candidatos memoriza por clave y no sortea otra respuesta en una repetición, incluso entre roles. Programa del canal con bytes de perfil y enunciado, tres alfas, dos fases FRI, trabajo, absorción de nonce y un selector compartido. Desde el recorrido se demuestra la cuenta 13+2*(longitudes de ambas listas de raíces)+R+C, con rechazo de trabajo y duplicados incluidos; se identifica con canalPerfil si las listas tienen longitudes k y k+1.

Pendientes y límites: Construir los programas de los candidatos reales y sus conjuntos buenos con cotas antes de responder, además del trabajo/nonce y la tabla global. El compilador memoriza las repeticiones, pero no demuestra valor<=rho para esos candidatos ni la carga global de inicios.

Referencias del registro: `Cap6-Validacion-Formal-106`, `Cap6-Validacion-Formal-161`, `Cap6-Validacion-Formal-176`, `Cap6-Validacion-Formal-177`, `Cap6-Validacion-Formal-178`, `Cap6-Validacion-Formal-179`, `Cap6-Validacion-Formal-180`, `Cap6-Validacion-Formal-181`.

### M41 — Cota ROM completa y ejemplo numérico

Estado: **Componente Lean parcial**. Prioridad 2.

- Conservar la cota parametrizada del evento excepcional del registro.
- Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.
- Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Alcance demostrado: Unión de tres eventos bajo una misma ley, transporte por variación total, composición de errores ROM/excepciones/consulta y suma de presupuestos. Se conserva la cota del juego ROM ya demostrado sin su mínimo con uno. Fórmula exacta de tres términos con mu, S=Q+V, presupuestos, hipergeométrica y cola. Para T=4096,g=20,Q=2^20 se certifica el intervalo (0.004757335453,0.004757335454]; para Q=2^28 la expresión truncada satura en uno. Ley racional normalizada que aborta con masa tau y, al completar, devuelve un q-subconjunto uniforme. Su variación total respecto de la muestra ideal es exactamente tau; todo evento pierde a lo sumo tau. Para el corte 512 y los nueve perfiles, la pérdida modelada es menor que 2^-300. Gramática conjunta de inicio, perfil, enunciado, raíces, fases, finales, nonce, E/I, trabajo y Merkle TG2 v1. Longitudes máximas de 79 octetos; las absorciones que coinciden con un nodo son de enunciado y se conserva un solapamiento explícito. No se separan artificialmente las tablas por rol. Claves finitas con longitud y hasta 79 octetos, iguales si y solo si sus bytes coinciden; el solapamiento entre roles comparte clave. Todo programa finito produce historia causal compatible, y se deriva la ley fresca y la repetida en cada prefijo. El compilador a árboles de candidatos memoriza por clave y no sortea otra respuesta en una repetición, incluso entre roles. Programa del canal con bytes de perfil y enunciado, tres alfas, dos fases FRI, trabajo, absorción de nonce y un selector compartido. Desde el recorrido se demuestra la cuenta 13+2*(longitudes de ambas listas de raíces)+R+C, con rechazo de trabajo y duplicados incluidos; se identifica con canalPerfil si las listas tienen longitudes k y k+1.

Pendientes y límites: Probar las inclusiones y leyes de los tres eventos bajo un mismo experimento del ejecutable, incluyendo adversario, sesgo, selector y presupuestos completos. La gramática, programa causal y cuenta del canal son componentes; no instancian todavía la cota numérica global.

Referencias del registro: `Cap6-Validacion-Formal-109`, `Cap6-Validacion-Formal-110`, `Cap6-Validacion-Formal-111`, `Cap6-Validacion-Formal-162`, `Cap6-Validacion-Formal-163`, `Cap6-Validacion-Formal-164`, `Cap6-Validacion-Formal-165`, `Cap6-Validacion-Formal-173`, `Cap6-Validacion-Formal-179`, `Cap6-Validacion-Formal-180`, `Cap6-Validacion-Formal-181`.

### M42 — Extensión QROM de AIR/FRI

Estado: **Trabajo futuro**. Prioridad 4.

- Conservar el estado abierto de la omisión beta^S y las pérdidas cuánticas.
- No reabrir esta investigación ni convertirla en bloqueo del cierre activo de TG2.

Referencias del registro: `Cap2-Marco-Teorico-006`, `Cap3-Diseno-Arquitectura-012`, `Cap3-Diseno-Arquitectura-013`, `Cap6-Validacion-Formal-141`, `Cap6-Validacion-Formal-182`, `Cap7-Conclusiones-004`.

### M43 — Estándares, comparaciones y afirmaciones de alcance

Estado: **Respaldo documental**. Prioridad 3.

- Identificar fuente primaria, versión y fecha de cada afirmación externa.
- Separar categorías, recomendaciones, límites y propuestas de resultados demostrados; registrar correcciones editoriales.

Referencias del registro: `_tesis-frontmatter-001`, `_tesis-frontmatter-002`, `Cap2-Marco-Teorico-004`, `Cap2-Marco-Teorico-006`, `Cap2-Marco-Teorico-008`, `Cap3-Diseno-Arquitectura-012`, `Cap3-Diseno-Arquitectura-013`, `Cap3-Diseno-Arquitectura-017`, `Cap3-Diseno-Arquitectura-018`, `Cap3-Diseno-Arquitectura-019`, `Cap4-Nucleo-Criptografico-009`, `Cap4-Nucleo-Criptografico-010`, `Cap4-Nucleo-Criptografico-011`, `Cap5-Gestion-Claves-001`, `Cap5-Gestion-Claves-002`, `Cap5-Gestion-Claves-003`, `Cap5-Gestion-Claves-009`, `Cap5-Gestion-Claves-010`, `Cap5-Gestion-Claves-024`, `Cap5-Gestion-Claves-035`, `Cap6-Validacion-Formal-064`, `Cap6-Validacion-Formal-070`, `Cap6-Validacion-Formal-162`, `Cap6-Validacion-Formal-163`, `Cap6-Validacion-Formal-164`, `Cap6-Validacion-Formal-165`, `Cap7-Conclusiones-001`, `Cap7-Conclusiones-002`, `Cap7-Conclusiones-003`, `SUP01`, `SUP13`, `SUP14`.

### M44 — Procedencia de experimentos y contraste de implementaciones

Estado: **Respaldo documental**. Prioridad 3.

- Conservar versiones, entradas, logs y alcance de los corpus R1–R5 y H1/H2.
- No inferir una prueba universal de una ejecución finita ni identificar corridas solo por cifras próximas.

Referencias del registro: `_tesis-frontmatter-001`, `_tesis-frontmatter-002`, `Cap3-Diseno-Arquitectura-014`, `Cap4-Nucleo-Criptografico-002`, `Cap4-Nucleo-Criptografico-012`, `Cap5-Gestion-Claves-001`, `Cap5-Gestion-Claves-002`, `Cap5-Gestion-Claves-003`, `Cap5-Gestion-Claves-016`, `Cap5-Gestion-Claves-033`, `Cap5-Gestion-Claves-034`, `Cap5-Gestion-Claves-035`, `Cap6-Validacion-Formal-033`, `Cap6-Validacion-Formal-034`, `Cap6-Validacion-Formal-074`, `Cap6-Validacion-Formal-075`, `Cap6-Validacion-Formal-076`, `Cap6-Validacion-Formal-077`, `Cap6-Validacion-Formal-078`, `Cap6-Validacion-Formal-079`, `Cap6-Validacion-Formal-080`, `Cap6-Validacion-Formal-081`, `Cap6-Validacion-Formal-082`, `Cap6-Validacion-Formal-083`, `Cap6-Validacion-Formal-084`, `Cap6-Validacion-Formal-085`, `Cap6-Validacion-Formal-086`, `Cap6-Validacion-Formal-087`, `Cap6-Validacion-Formal-088`, `Cap6-Validacion-Formal-089`, `Cap6-Validacion-Formal-090`, `Cap6-Validacion-Formal-091`, `Cap6-Validacion-Formal-092`, `Cap6-Validacion-Formal-093`, `Cap6-Validacion-Formal-094`, `Cap6-Validacion-Formal-095`, `Cap6-Validacion-Formal-096`, `Cap6-Validacion-Formal-099`, `Cap6-Validacion-Formal-101`, `Cap6-Validacion-Formal-102`, `Cap6-Validacion-Formal-103`, `Cap6-Validacion-Formal-113`, `Cap6-Validacion-Formal-125`, `Cap6-Validacion-Formal-131`, `Cap6-Validacion-Formal-132`, `Cap6-Validacion-Formal-133`, `Cap6-Validacion-Formal-134`, `Cap6-Validacion-Formal-137`, `Cap6-Validacion-Formal-138`, `Cap6-Validacion-Formal-139`, `Cap6-Validacion-Formal-140`, `Cap6-Validacion-Formal-157`, `Cap6-Validacion-Formal-161`, `Cap6-Validacion-Formal-183`, `Cap6-Validacion-Formal-184`, `Cap7-Conclusiones-001`, `Cap7-Conclusiones-002`, `Cap7-Conclusiones-003`, `Cap7-Conclusiones-004`, `SUP05`, `SUP12`, `SUP14`.

### M45 — Diferencia de preimágenes cortas

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Conservar el lema general con mapas aditivos y norma ya demostrado.
- Instanciar R_q, representantes enteros y no nulidad módulo q para la formulación exacta del manuscrito.

Alcance demostrado: Construcción desde 256 coeficientes y recuperación exacta, transporte de reducción, suma y resta. Levantamiento centrado Rq→R, sección de la reducción, inyectividad y conservación de norma. Relación MSIS con no nulidad modular, ecuación matricial y norma, experimento con matriz uniforme y buscador probabilístico. Centrar no aumenta norma. Lema 6.1 para representantes dados o canónicos: diferencia no nula módulo q, núcleo y cota entera/modular 2L.

Pendientes y límites: Presentación algebraica del anillo, sin equivalencia de almacenamiento, codecs o instrucciones del backend. La cota L se expresa como natural y la norma es infinito. No prueba dureza MSIS, extracción desde una firma real ni reducción de peor caso.

Referencias del registro: `Cap6-Validacion-Formal-043`, `Cap6-Validacion-Formal-044`.

### M46 — Candidato próximo, unicidad y campo base

Estado: **Modelo verificado en su alcance**. Prioridad 2.

- Conservar la selección parcial previa a retos, unicidad y descomposición f=A+zB ya mecanizadas.
- Conservar el conteo de puntos no base con sus hipótesis y enlazarlo a la consulta autenticada sin imponer un oráculo globalmente base.

Alcance demostrado: Las dos ejecuciones FRI dan las premisas de aceptación compartida AIR/FRI con raíz inicial común, seis aperturas y enlace local. Cota de la rama de candidato no base a partir de controles de base de la muestra, sin exigir que el oráculo completo sea base.

Pendientes y límites: La familia construida usa el registro final para la implicación de aceptación. Su identificación con una familia causal previa a cada reto sigue en M37/M36. La probabilidad de muestra es la uniforme ideal; el selector real corresponde a M35/M40.

Referencias del registro: `Cap6-Validacion-Formal-146`, `Cap6-Validacion-Formal-147`, `Cap6-Validacion-Formal-148`.

## Hallazgos editoriales y matemáticos

- **E01** (seguimiento): El inventario base tiene 36 bloques con enlace Lean y 35 con revisión parcial marcada. Precisar ambos conteos; no llamar revisados a los 36 ni interpretar el cociente como cobertura completa.
- **E02** (corregido): Hay frases de estado anteriores a la auditoría de 777 resultados que presentan Lean enteramente pendiente. Preparar redacción que distinga componentes ideales mecanizados, correspondencia con el ejecutable y dictamen pendiente. Aplicado en las fuentes TG2 conservando líneas y versiones previas.
- **E03** (seguimiento): La regla aproximada min-entropía por longitud necesita hipótesis sobre la distribución conjunta. Formalizar independencia o una tasa condicional antes de usar la regla de acumulación.
- **E04** (seguimiento): La comparación CPU depende de las corridas y bibliotecas; la aritmética de tamaños no demuestra un cuello de botella universal. Mantener las comparaciones condicionadas a serie y carga al revisar la narrativa TG2.
- **E05** (corregido): Dieciséis bytes canónicos de coordenadas y diecisiete bytes de entrada de hoja Merkle describen niveles diferentes. Explicitar el prefijo de la hoja para evitar identificar el formato con el legado de nueve bytes. Aplicado en las fuentes TG2 conservando líneas y versiones previas.
- **E06** (seguimiento): El detector omitió argumentos de incentivos y quórum que contienen obligaciones matemáticas. Conservarlos en el registro complementario sin modificar el alcance ni entregables aprobados de TG1.
- **E07** (corregido): 768.2 KiB/3309 B se aproxima a 238; 232 corresponde a usar 768000 B decimales. Corregido en el capítulo TG2 y certificado en Mediciones.correccion_kib; versión anterior preservada.

## Reproducción y límites

Compilación, axiomas y replay de 207 módulos, con hasta cuatro procesos,
sin reutilización de replays y confiando en importados: 631 fuentes
y 213 logs. Pasan 21 controles Python. El [contraste externo de 50 casos](../Documentos/06-Evidencia-TG2/2026-10-17/Verificador-Completo-Antecedentes/contraste/contraste-python.json)
conserva la diferencia de EOF estricto. No demuestra equivalencia universal
Rust/Lean ni sustituye el juicio semántico o un dictamen independiente.

```powershell
python scripts/verificar_formalizacion.py --procesos-kernel 4
python scripts/verificar_revision_manuscrito.py
```
