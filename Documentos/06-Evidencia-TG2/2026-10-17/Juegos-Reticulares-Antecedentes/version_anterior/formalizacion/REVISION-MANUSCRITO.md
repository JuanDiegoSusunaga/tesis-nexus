# Revisión matemática del manuscrito TG2

Por instrucción del autor se prioriza la matemática del manuscrito antes del
cierre integral Rust/ROM. Se conservan **272 candidatos**, **14 omisiones** y
**46 grupos de obligaciones**, con textos y procedencia identificados.

El [registro](revision-manuscrito.json) incorpora M03/M30: **121 pruebas nuevas**,
para **1103 resultados en 129 módulos**, con [auditoría completa correcta](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Anillos-Contraejemplo/validacion.json).
Hay **85 bloques enlazados** en el [inventario](inventario-manuscrito.json),
84 con revisión parcial marcada. La revisión complementaria llega a **96 bloques
parcialmente enlazados**, además de dos suplementos de salud previamente enlazados.
Se incorporan 17 correspondencias sin cambiar textos, líneas, identificadores
ni hashes de los ocho archivos fuente. Las [versiones anteriores](../Documentos/06-Evidencia-TG2/2026-10-17/Anillos-Contraejemplo-Antecedentes/README.md)
conservan la pasada de residencia y costos.

Un enlace parcial no cierra todas las afirmaciones de un bloque. La exhaustividad,
el cierre matemático global y el dictamen independiente siguen pendientes.
Los alcances anteriores conservan su procedencia; los enlaces nuevos aportan
los componentes ahora probados. Las categorías de seguridad, codecs y ejecución
de verificadores conservan sus límites bibliográficos o empíricos.

## Resumen por fuente

| Fuente | Candidatos clasificados | Omisiones identificadas | Bloques con enlace Lean parcial |
|---|---:|---:|---:|
| Resumen / preliminares | 2 | 1 | 0 |
| Cap1-Introduccion | 8 | 1 | 1 |
| Cap2-Marco-Teorico | 8 | 0 | 1 |
| Cap3-Diseno-Arquitectura | 19 | 3 | 10 |
| Cap4-Nucleo-Criptografico | 12 | 1 | 2 |
| Cap5-Gestion-Claves | 35 | 6 | 16 |
| Cap6-Validacion-Formal | 184 | 2 | 66 |
| Cap7-Conclusiones | 4 | 0 | 0 |

Los grupos tienen tamaño desigual: estos conteos no son porcentajes de matemática
demostrada ni de esfuerzo restante.

## Avance y prioridades

1. **M03:** anillos, representantes, normas, primalidad, raíces y aritmética de
   perfiles verificados en el modelo algebraico; codecs y seguridad separados.
2. **M30:** construcción e interpolación de la traza, distancia mínima exacta
   7/8 y grados AIR verificados, incluidos Goldilocks y candidatos de extensión.
   Las aceptaciones y rechazos de programas permanecen empíricos.
3. **M14–M15, M19–M20 y M22:** conservan los modelos verificados de entropía,
   residencia, captura uniforme y amortización variable.
4. **M16–M18, M21 y M23–M24:** mantienen las correspondencias pendientes de salud,
   fuente, Rust/f64, representación, algoritmo NTT, distribución y contador.
5. **Siguientes fundamentos matemáticos:** retículos y problemas aproximados
   (M02), distribuciones/juegos MLWE, MSIS y SelfTargetMSIS (M04–M05), juegos de
   firma (M06) y sesgo de reducción modular (M38).

El puente integral Rust/ROM mantiene sus pendientes. QROM AIR/FRI continúa futuro
y R1 de firmas conserva su alcance. Los capítulos y TG1 permanecen intactos.

## Matriz de obligaciones

| Estado | Grupos |
|---|---:|
| Dependencia bibliográfica | 3 |
| Pendiente | 16 |
| Modelo verificado en su alcance | 7 |
| Componente Lean parcial | 17 |
| Trabajo futuro | 1 |
| Respaldo documental | 2 |

### M01 — Shor, Grover y alcance de la resistencia cuántica

Estado: **Dependencia bibliográfica**. Prioridad 3 (sin estimación de duración).

- Identificar formalizaciones de los algoritmos y su modelo de consultas y costo.
- Expresar la dureza reticular como hipótesis; no deducir una cota inferior de la no aplicación directa de Shor.

Referencias del registro: `Cap1-Introduccion-001`, `Cap1-Introduccion-002`, `Cap2-Marco-Teorico-001`, `Cap2-Marco-Teorico-002`, `Cap2-Marco-Teorico-006`, `Cap6-Validacion-Formal-009`, `Cap6-Validacion-Formal-050`, `Cap6-Validacion-Formal-051`, `Cap6-Validacion-Formal-052`, `Cap6-Validacion-Formal-074`, `SUP01`.

### M02 — Retículos, mínimos sucesivos y problemas aproximados

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Definir el span entero de una familia real linealmente independiente y sus normas.
- Precisar rango frente a dimensión ambiente, mínimos sucesivos, SVP, SIVP y GapSVP.

Referencias del registro: `Cap2-Marco-Teorico-002`, `Cap6-Validacion-Formal-003`, `Cap6-Validacion-Formal-004`, `Cap6-Validacion-Formal-005`, `Cap6-Validacion-Formal-006`, `Cap6-Validacion-Formal-007`, `Cap6-Validacion-Formal-008`, `Cap6-Validacion-Formal-009`.

### M03 — Anillos y constantes de ML-DSA

Estado: **Modelo verificado en su alcance**. Prioridad 1 (sin estimación de duración).

- Construir Z[X]/(X^256+1) y su versión modular con representantes y normas.
- Demostrar primalidad de 8380417, q=2^23-2^13+1, q=512*16368+1 y existencia de raíz de orden 512.
- Comprobar las cuentas de parámetros tabulados sin inferir una garantía criptográfica.

Alcance demostrado: Primalidad de 8380417, fórmulas del módulo y dimensión, raíz 1753 de orden 512 y raíz cíclica de orden 256. Perfiles 44/65/87: dimensiones, beta=tau*eta, gamma, márgenes y aritmética de tamaños públicos y firmas del formato declarado. Cocientes Z[X]/(X^256+1) y Fq[X]/(X^256+1), representantes canónicos de grado menor que 256, unicidad, relación negacíclica, base de 256 coordenadas, reducción sobreyectiva y cardinalidades de anillo, vectores y matrices. Coeficientes centrados únicos en (-q/2,q/2], reducción y cota absoluta. Normas infinito y euclídea para R, Rq y vectores aplanados; pequeños S_eta, caracterización por coeficientes, separación de cero y cota de la suma de cuadrados.

Pendientes y límites: Las categorías NIST son datos bibliográficos, no garantías demostradas. Los tamaños usan anchos de formato declarados; falta la equivalencia con los codecs y el backend. No demuestra corrección de NTT ni seguridad de firmas. Es la presentación algebraica del manuscrito; no acredita representación en memoria, instrucciones NTT, distribución MLWE ni dureza reticular. La norma centrada se modela por coeficientes enteros canónicos. No establece distribución de muestreo, seguridad de MLWE/MSIS ni implementación de comprobaciones de norma.

Referencias del registro: `Cap4-Nucleo-Criptografico-001`, `Cap6-Validacion-Formal-010`, `Cap6-Validacion-Formal-011`, `Cap6-Validacion-Formal-012`, `Cap6-Validacion-Formal-013`, `Cap6-Validacion-Formal-014`, `Cap6-Validacion-Formal-015`, `Cap6-Validacion-Formal-016`, `Cap6-Validacion-Formal-023`.

### M04 — Distribuciones Module-LWE y soluciones Module-SIS

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Definir espacios finitos, distribuciones independientes, juego decisional y búsqueda.
- Precisar norma, cota, no nulidad y ecuación modular de MSIS.

Referencias del registro: `Cap2-Marco-Teorico-003`, `Cap6-Validacion-Formal-017`, `Cap6-Validacion-Formal-018`, `Cap6-Validacion-Formal-019`, `Cap6-Validacion-Formal-020`, `Cap6-Validacion-Formal-021`.

### M05 — Definición y juego SelfTargetMSIS

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Fijar dimensiones, salida de H, norma y distribución de la instancia.
- Formalizar la relación de victoria sin asumir una reducción desde firmas reales.

Referencias del registro: `Cap2-Marco-Teorico-003`, `Cap6-Validacion-Formal-022`, `Cap6-Validacion-Formal-042`, `Cap6-Validacion-Formal-053`.

### M06 — Esquema de firma, corrección y juegos EUF/sUF-CMA

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Representar algoritmos aleatorios y sus registros de consultas.
- Definir corrección, mensaje nuevo, par nuevo y ventaja; distinguir las dos nociones.

Referencias del registro: `Cap4-Nucleo-Criptografico-002`, `Cap6-Validacion-Formal-024`, `Cap6-Validacion-Formal-025`, `Cap6-Validacion-Formal-026`, `Cap6-Validacion-Formal-030`, `Cap6-Validacion-Formal-031`, `Cap6-Validacion-Formal-042`.

### M07 — Plantilla Fiat–Shamir con abortos y correspondencia ML-DSA

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Representar compromiso, reto, respuesta, pistas y rechazo con dimensiones válidas.
- Separar la plantilla de codificaciones, expansión, firma hedged y backend final.

Referencias del registro: `Cap4-Nucleo-Criptografico-002`, `Cap6-Validacion-Formal-027`, `Cap6-Validacion-Formal-028`, `Cap6-Validacion-Formal-029`, `Cap6-Validacion-Formal-033`, `Cap6-Validacion-Formal-034`, `Cap6-Validacion-Formal-041`, `Cap6-Validacion-Formal-042`.

### M08 — Reducciones bibliográficas CMA→NMA y pérdida QROM de firmas

Estado: **Dependencia bibliográfica**. Prioridad 3 (sin estimación de duración).

- Identificar versiones y teoremas B+23/FFH26 con todas sus hipótesis.
- Representar L_Q y certificar la reproducción numérica con error controlado; no atribuir esas hipótesis a NEXUS.

Referencias del registro: `Cap6-Validacion-Formal-032`, `Cap6-Validacion-Formal-035`, `Cap6-Validacion-Formal-036`, `Cap6-Validacion-Formal-037`, `Cap6-Validacion-Formal-038`, `Cap6-Validacion-Formal-039`, `Cap6-Validacion-Formal-053`.

### M09 — Peor caso, gaussianas y transformaciones de distribuciones

Estado: **Dependencia bibliográfica**. Prioridad 3 (sin estimación de duración).

- Representar los resultados LS15 pertinentes con sus condiciones asintóticas.
- Justificar cambios de secreto, error, módulo y factor de aproximación; no equiparar gaussianas con uniformes pequeños.

Referencias del registro: `Cap6-Validacion-Formal-047`, `Cap6-Validacion-Formal-048`, `Cap6-Validacion-Formal-049`, `Cap6-Validacion-Formal-053`.

### M10 — Contraste numérico de aplicabilidad de JMW24

Estado: **Componente Lean parcial**. Prioridad 2 (sin estimación de duración).

- Conservar las desigualdades ya probadas para los tres perfiles.
- Instanciar dimensiones, norma y constantes desde los tipos y la versión bibliográfica correctos.

Referencias del registro: `Cap6-Validacion-Formal-045`, `Cap6-Validacion-Formal-046`, `Cap6-Validacion-Formal-053`.

### M11 — Autenticación de contenido y composición de transacciones

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Definir codificación inequívoca, hash externo, asociación de clave, cadena y nonce.
- Probar verificación previa al cambio de estado bajo supuestos explícitos de hash y firma.

Referencias del registro: `Cap1-Introduccion-003`, `Cap4-Nucleo-Criptografico-003`, `Cap4-Nucleo-Criptografico-004`, `Cap4-Nucleo-Criptografico-005`, `Cap6-Validacion-Formal-040`, `Cap6-Validacion-Formal-053`, `Cap6-Validacion-Formal-103`.

### M12 — Derivación determinista, dominios y calidad de semillas

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Definir entradas de derivación y KeyGen semillada; demostrar reproducibilidad.
- Separar determinismo de inyectividad y seguridad; definir por separado distribución, KDF y separación de dominios.

Referencias del registro: `Cap2-Marco-Teorico-005`, `Cap4-Nucleo-Criptografico-006`, `Cap4-Nucleo-Criptografico-007`, `Cap4-Nucleo-Criptografico-008`, `Cap5-Gestion-Claves-017`, `Cap5-Gestion-Claves-018`, `Cap5-Gestion-Claves-019`, `Cap5-Gestion-Claves-020`, `Cap5-Gestion-Claves-021`, `Cap5-Gestion-Claves-024`, `Cap6-Validacion-Formal-033`, `Cap6-Validacion-Formal-034`, `SUP05`.

### M13 — Épocas, identidad, registro y rotación

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Definir estado e invariantes de identidad, época y claves vigentes.
- Demostrar atomicidad del modelo, autorización de cambios y vigencia respecto de un prefijo confiable.
- Mantener custodia, destrucción de copias y secrecia hacia adelante como obligaciones adicionales.

Referencias del registro: `Cap3-Diseno-Arquitectura-015`, `Cap5-Gestion-Claves-022`, `Cap5-Gestion-Claves-023`, `Cap5-Gestion-Claves-027`, `Cap7-Conclusiones-004`, `SUP04`, `SUP08`, `SUP09`, `SUP10`, `SUP11`.

### M14 — Min-entropía y acumulación de entropía

Estado: **Modelo verificado en su alcance**. Prioridad 1 (sin estimación de duración).

- Definir -log₂(max p) para una distribución finita normalizada no vacía.
- Demostrar la relación con la probabilidad de adivinar.
- Precisar independencia o cotas condicionales antes de multiplicar una tasa por la longitud de un bloque.

Alcance demostrado: Distribuciones finitas normalizadas, máximo alcanzable, probabilidad óptima de adivinar, min-entropía y producto independiente. Bloques IID acumulan n veces la min-entropía; dos bits correlacionados muestran por qué la regla requiere independencia.

Pendientes y límites: Caracterización y calificación de una fuente física y pérdidas de acondicionamiento; no se deducen de una muestra.

Referencias del registro: `Cap2-Marco-Teorico-005`, `Cap5-Gestion-Claves-005`, `Cap5-Gestion-Claves-006`, `Cap5-Gestion-Claves-007`, `Cap5-Gestion-Claves-008`, `Cap5-Gestion-Claves-016`.

### M15 — Límite de Shannon empírico para 32 muestras

Estado: **Modelo verificado en su alcance**. Prioridad 1 (sin estimación de duración).

- Definir frecuencias empíricas y entropía de Shannon.
- Probar H_emp≤log₂(min(n,256)) y especializar n=32 para obtener cinco bits por símbolo.

Alcance demostrado: Entropía empírica y soporte, no negatividad y cota log2(min(n,cardinal alfabeto)). Para 32 bytes la entropía es a lo sumo cinco bits por símbolo y no alcanza 7,5.

Pendientes y límites: Correspondencia con el diagnóstico f64 de Rust y datos de una ejecución; el resultado matemático no evalúa secreto de una clave.

Referencias del registro: `Cap5-Gestion-Claves-004`, `Cap5-Gestion-Claves-005`.

### M16 — RCT: umbral, cuenta consecutiva y perfil numérico

Estado: **Componente Lean parcial**. Prioridad 1 (sin estimación de duración).

- Modelar el conteo consecutivo y la condición de fallo al alcanzar C.
- Definir el techo bajo H>0 y 0<alpha<1; comprobar H=7.5 y alpha=2^-20.
- Explicitar las hipótesis probabilísticas de cualquier cota de falsas alarmas.

Avance demostrado: Corte por techo, condición equivalente, minimalidad, corte cuatro del perfil y falsa alarma por racha IID acotada por 2^-20 bajo H>=7,5.

Pendientes y límites: Fuentes dependientes requieren hipótesis condicionales propias; resta equivalencia f64 y tratamiento de enteros de máquina.

Referencias del registro: `Cap2-Marco-Teorico-005`, `Cap5-Gestion-Claves-011`, `Cap5-Gestion-Claves-012`, `Cap5-Gestion-Claves-013`, `Cap5-Gestion-Claves-015`.

### M17 — APT: referencia incluida y cola binomial

Estado: **Componente Lean parcial**. Prioridad 1 (sin estimación de duración).

- Modelar la ventana no binaria de 512 muestras y el conteo que incluye la referencia.
- Definir B=1+Bin(511,2^-7.5) bajo las hipótesis de ese modelo.
- Certificar con intervalos rigurosos la minimalidad del corte 16 y las colas citadas.

Avance demostrado: Para B=1+Bin(511,2^-7,5), se certifica con racionales que el corte 15 excede 2^-20 y el 16 lo cumple; equivalencia con 16<=C prueba minimalidad. Sin aproximación normal ni cálculo nativo no comprobado.

Pendientes y límites: No se certifican todavía los decimales aproximados de ambas colas publicados en el párrafo ni el redondeo del algoritmo f64; no se deduce conformidad SP 800-90B.

Referencias del registro: `Cap2-Marco-Teorico-005`, `Cap5-Gestion-Claves-014`, `Cap5-Gestion-Claves-015`.

### M18 — Compuerta de salud y recuperación del gestor

Estado: **Componente Lean parcial**. Prioridad 1 (sin estimación de duración).

- Definir estados sin evaluación, fallo retenido, reevaluación y renovación pendiente.
- Probar bloqueo de derivación y operaciones, acumulación de lotes y conservación de contadores al rotar.

Avance demostrado: Lote 65536, frecuencia máxima exacta, compuerta de uso y edad, recuperación con fallo retenido y renovación pendiente. Reevaluar sin renovar no habilita; rotar exige salud y material fresco y conserva monitor y lote parcial.

Pendientes y límites: Modelo del perfil con reales y naturales, sin equivalencia integral con Rust/f64 ni calificación física. No demuestra KDF, firma de operaciones, registro, borrado o secrecia hacia adelante.

Referencias del registro: `Cap5-Gestion-Claves-016`, `Cap5-Gestion-Claves-017`, `Cap5-Gestion-Claves-018`, `Cap5-Gestion-Claves-019`, `Cap5-Gestion-Claves-020`, `Cap5-Gestion-Claves-021`, `SUP06`, `SUP07`.

### M19 — Residencia integral y modelo temporal de captura

Estado: **Modelo verificado en su alcance**. Prioridad 1 (sin estimación de duración).

- Definir W como integral de bytes de regiones declaradas sobre un horizonte positivo.
- Derivar la media desde intervalos y la probabilidad de coincidencia de una captura uniforme independiente.
- Distinguir suma de copias de unión de intervalos y no inferir probabilidad de compromiso de un cociente de bytes.

Alcance demostrado: Integral de regiones tipadas, recorte por horizonte y suma de copias. Unión de intervalos, cotas y medida exacta sin solapamiento. Fórmulas cacheada/secuencial, media racional y enlace de diez redondeos de la tabla 5.2. Distribución uniforme continua de captura, recorte y probabilidad igual a longitud de unión sobre horizonte. Cota, caso secuencial, complemento, variable uniforme y cinco redondeos temporales de la tabla 5.2.

Pendientes y límites: Las regiones y sus duraciones son declaradas: no se acredita que agoten las copias del ejecutable ni la custodia o el borrado. Calendario fijo e instante uniforme; no demuestra compromiso, semilla protegida, ausencia de residuos ni ataques persistentes o sincronizados.

Referencias del registro: `Cap5-Gestion-Claves-027`, `Cap5-Gestion-Claves-028`, `Cap5-Gestion-Claves-029`, `Cap5-Gestion-Claves-031`, `Cap5-Gestion-Claves-032`.

### M20 — Modelo algebraico y tabla de residencia

Estado: **Modelo verificado en su alcance**. Prioridad 1 (sin estimación de duración).

- Conservar las cotas y quince redondeos ya comprobados con la latencia fuente.
- Enlazar el modelo algebraico con la integral bajo hipótesis de no solapamiento y sin copias adicionales.

Alcance demostrado: Integral de regiones tipadas, recorte por horizonte y suma de copias. Unión de intervalos, cotas y medida exacta sin solapamiento. Fórmulas cacheada/secuencial, media racional y enlace de diez redondeos de la tabla 5.2. Distribución uniforme continua de captura, recorte y probabilidad igual a longitud de unión sobre horizonte. Cota, caso secuencial, complemento, variable uniforme y cinco redondeos temporales de la tabla 5.2.

Pendientes y límites: Las regiones y sus duraciones son declaradas: no se acredita que agoten las copias del ejecutable ni la custodia o el borrado. Calendario fijo e instante uniforme; no demuestra compromiso, semilla protegida, ausencia de residuos ni ataques persistentes o sincronizados.

Referencias del registro: `Cap5-Gestion-Claves-029`, `Cap5-Gestion-Claves-030`, `Cap5-Gestion-Claves-031`, `Cap5-Gestion-Claves-032`.

### M21 — Tamaños de representaciones y contabilidad de memoria

Estado: **Componente Lean parcial**. Prioridad 1 (sin estimación de duración).

- Comprobar 4032-96=3936, 4032+1952+9=5993 y 128+17*256*4=17536.
- Vincular cada tamaño con la representación y versión medidas; no interpretarlo como entropía ni RAM total.

Avance demostrado: Cuentas de 3936, 5993, 17536 y 4064 bytes; distinción de contenedores, tipos y copias del perfil histórico R5.

Pendientes y límites: No es equivalencia de layout Rust/ABI, RAM total, cantidad de entropía o prueba de zeroización. La procedencia y versión se fijan con fuentes y logs R5.

Referencias del registro: `Cap5-Gestion-Claves-025`, `Cap5-Gestion-Claves-026`.

### M22 — Throughput y amortización de datos y verificación

Estado: **Modelo verificado en su alcance**. Prioridad 1 (sin estimación de duración).

- Conservar razones, límites para prueba fija y equilibrio ya demostrados.
- Probar el caso pi(m) variable bajo pi(m)/m→0 y t_pi(m)/m bajo una hipótesis explícita.
- Certificar la sensibilidad de §6.6.5 y mantener DA, prueba de la lógica y costo del prover como condiciones.

Alcance demostrado: Límite d+L para pi(m)/m→L; equivalencia entre límite d y sublinealidad, piso y equilibrio. Costo de disponibilidad, contraescenario lineal, pruebas polilogarítmicas y cinco redondeos de sensibilidad.

Pendientes y límites: El modelo requiere datos disponibles, prueba de la lógica pertinente y costos de prover/llenado separados; no establece rendimiento de una blockchain ni que filas AIR equivalgan a operaciones.

Referencias del registro: `Cap1-Introduccion-004`, `Cap3-Diseno-Arquitectura-001`, `Cap3-Diseno-Arquitectura-002`, `Cap3-Diseno-Arquitectura-003`, `Cap3-Diseno-Arquitectura-004`, `Cap3-Diseno-Arquitectura-005`, `Cap3-Diseno-Arquitectura-006`, `Cap3-Diseno-Arquitectura-007`, `Cap3-Diseno-Arquitectura-008`, `Cap3-Diseno-Arquitectura-009`, `Cap3-Diseno-Arquitectura-010`, `Cap3-Diseno-Arquitectura-011`, `Cap3-Diseno-Arquitectura-019`, `Cap4-Nucleo-Criptografico-009`, `Cap4-Nucleo-Criptografico-010`, `Cap4-Nucleo-Criptografico-011`, `Cap6-Validacion-Formal-071`, `Cap6-Validacion-Formal-072`, `Cap6-Validacion-Formal-097`, `Cap6-Validacion-Formal-098`.

### M23 — NTT, producto matriz–vector y notación O

Estado: **Componente Lean parcial**. Prioridad 1 (sin estimación de duración).

- Definir un modelo de operaciones y la familia asintótica; distinguir n fijo de n variable.
- Derivar el recuento k*l, las transformadas y las cotas gruesa y optimizada.
- Enlazar el costo del algoritmo NTT con el del backend como obligación aparte.

Avance demostrado: Calendario radix dos n=2^r, mariposas por recurrencia y fórmula cerrada. Costo unitario del anillo, producto, matriz, cotas O(n log n) gruesa y optimizada; n=256 fijo separado de la familia variable. Composición de NTT y rechazo para firma esperada: cotas gruesa, optimizada y n fijo. Contraejemplo p_m=1/(m+1) con esperanza m+1 no O(1).

Pendientes y límites: Faltan corrección algebraica de una NTT concreta y refinamiento con el backend, muestreo, hashes y costo de bits; no deduce tiempos de benchmarks. Requiere el modelo de costo NTT y una barra uniforme p0>0; no prueba la distribución ni seguridad de ML-DSA real.

Referencias del registro: `Cap6-Validacion-Formal-014`, `Cap6-Validacion-Formal-054`, `Cap6-Validacion-Formal-055`, `Cap6-Validacion-Formal-056`, `Cap6-Validacion-Formal-057`, `Cap6-Validacion-Formal-058`, `Cap6-Validacion-Formal-059`, `Cap6-Validacion-Formal-060`, `Cap6-Validacion-Formal-065`, `Cap6-Validacion-Formal-066`, `Cap6-Validacion-Formal-067`, `Cap6-Validacion-Formal-070`, `Cap6-Validacion-Formal-071`, `Cap6-Validacion-Formal-072`, `Cap6-Validacion-Formal-183`, `Cap6-Validacion-Formal-184`.

### M24 — Rechazo geométrico y costo esperado de firma

Estado: **Componente Lean parcial**. Prioridad 1 (sin estimación de duración).

- Modelar intentos independientes con probabilidad de aceptación p>0 y probar E[N]=1/p.
- Para O(1), exigir una cota inferior uniforme positiva de p en la familia.
- Conservar por separado el agotamiento del contador y la distribución del ejecutable.

Avance demostrado: Ley geométrica de mathlib, integrabilidad, E[N]=1/p, aceptación finita, cola de agotamiento y costo esperado c/p. Cota uniforme positiva implica O(1) en intentos y conserva O del costo por intento. Composición de NTT y rechazo para firma esperada: cotas gruesa, optimizada y n fijo. Contraejemplo p_m=1/(m+1) con esperanza m+1 no O(1).

Pendientes y límites: La distribución ideal no se deduce del bucle de máscaras del backend; no verifica su contador de 16 bits, rollover o estimaciones normativas de repeticiones. R1-D permanece separado. Requiere el modelo de costo NTT y una barra uniforme p0>0; no prueba la distribución ni seguridad de ML-DSA real.

Referencias del registro: `Cap6-Validacion-Formal-041`, `Cap6-Validacion-Formal-054`, `Cap6-Validacion-Formal-055`, `Cap6-Validacion-Formal-056`, `Cap6-Validacion-Formal-057`, `Cap6-Validacion-Formal-058`, `Cap6-Validacion-Formal-059`, `Cap6-Validacion-Formal-060`, `Cap6-Validacion-Formal-061`, `Cap6-Validacion-Formal-062`, `Cap6-Validacion-Formal-063`, `Cap6-Validacion-Formal-064`, `Cap6-Validacion-Formal-070`, `Cap6-Validacion-Formal-183`, `Cap6-Validacion-Formal-184`.

### M25 — Tamaños asintóticos y estructura de pruebas

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Precisar codificaciones y parámetros para cotas de claves y firmas.
- Contar capas, caminos y consultas para O(q log²N); no inferirlo de pocos tiempos medidos.

Referencias del registro: `Cap4-Nucleo-Criptografico-001`, `Cap6-Validacion-Formal-023`, `Cap6-Validacion-Formal-068`, `Cap6-Validacion-Formal-070`, `Cap6-Validacion-Formal-086`, `Cap6-Validacion-Formal-104`, `Cap6-Validacion-Formal-105`, `Cap6-Validacion-Formal-137`, `Cap6-Validacion-Formal-138`, `Cap6-Validacion-Formal-139`, `Cap6-Validacion-Formal-140`.

### M26 — Aritmética de mediciones: unidades, razones y redondeos

Estado: **Pendiente**. Prioridad 1 (sin estimación de duración).

- Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.
- Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Referencias del registro: `Cap3-Diseno-Arquitectura-001`, `Cap3-Diseno-Arquitectura-002`, `Cap3-Diseno-Arquitectura-003`, `Cap3-Diseno-Arquitectura-004`, `Cap3-Diseno-Arquitectura-005`, `Cap3-Diseno-Arquitectura-006`, `Cap3-Diseno-Arquitectura-014`, `Cap5-Gestion-Claves-030`, `Cap5-Gestion-Claves-033`, `Cap6-Validacion-Formal-074`, `Cap6-Validacion-Formal-080`, `Cap6-Validacion-Formal-081`, `Cap6-Validacion-Formal-082`, `Cap6-Validacion-Formal-083`, `Cap6-Validacion-Formal-084`, `Cap6-Validacion-Formal-085`, `Cap6-Validacion-Formal-087`, `Cap6-Validacion-Formal-088`, `Cap6-Validacion-Formal-089`, `Cap6-Validacion-Formal-090`, `Cap6-Validacion-Formal-091`, `Cap6-Validacion-Formal-092`, `Cap6-Validacion-Formal-093`, `Cap6-Validacion-Formal-094`, `Cap6-Validacion-Formal-095`, `Cap6-Validacion-Formal-096`, `Cap6-Validacion-Formal-099`, `Cap6-Validacion-Formal-101`, `Cap6-Validacion-Formal-102`.

### M27 — DA, incentivos y quórum como modelos de referencia

Estado: **Pendiente**. Prioridad 3 (sin estimación de duración).

- Definir el juego y pagos antes de afirmar equilibrio de Nash o requisitos de colusión.
- Precisar peso de stake, umbral estricto o inclusivo e intersección de quórums.
- Expresar recuperación y muestreo DA como resultados condicionados; conservar TG1 intacto.

Referencias del registro: `Cap3-Diseno-Arquitectura-016`, `Cap3-Diseno-Arquitectura-019`, `SUP02`, `SUP03`.

### M28 — Campos Goldilocks y definiciones, grados y validez AIR

Estado: **Componente Lean parcial**. Prioridad 2 (sin estimación de duración).

- Conservar campo, cosets, ausencia de polos, equivalencia por residuos y cotas probadas.
- Revisar las cotas más ajustadas de cocientes válidos de §6.7.2 y su correspondencia con la fórmula escrita.

Referencias del registro: `Cap6-Validacion-Formal-114`, `Cap6-Validacion-Formal-115`, `Cap6-Validacion-Formal-116`.

### M29 — Cancelación, distancia y transferencia local AIR

Estado: **Componente Lean parcial**. Prioridad 2 (sin estimación de duración).

- Conservar cancelación uniforme, distancia y pérdida 3*epsilon ya demostradas.
- Probar el caso de masa puntual máxima y el ejemplo concreto de cancelación cuando se solicite su cierre completo.

Referencias del registro: `Cap6-Validacion-Formal-108`, `Cap6-Validacion-Formal-117`, `Cap6-Validacion-Formal-118`, `Cap6-Validacion-Formal-119`, `Cap6-Validacion-Formal-120`, `Cap6-Validacion-Formal-121`, `Cap6-Validacion-Formal-122`, `Cap6-Validacion-Formal-123`, `Cap6-Validacion-Formal-124`, `Cap6-Validacion-Formal-125`, `Cap6-Validacion-Formal-147`, `Cap6-Validacion-Formal-148`.

### M30 — Contraejemplo de traza y distancia exacta 7/8

Estado: **Modelo verificado en su alcance**. Prioridad 1 (sin estimación de duración).

- Construir F=f+lambda*(X^T-1), probar grados, fronteras y grado de composición.
- Demostrar las dos desigualdades de la distancia exacta 7/8, incluida la construcción que alcanza T acuerdos.
- Mantener la aceptación de los tres certificados como evidencia empírica separada.

Alcance demostrado: Cota de acuerdos por grado y aproximante construido cancelando el término principal mediante el anulador de T puntos elegidos. Exactamente T acuerdos, distancia mínima alcanzada y valor 7/8 cuando |L|=8T, en cualquier campo. F=f+lambda*(X^T-1), grado T y coeficiente principal lambda. Conserva filas, fronteras, transiciones, validez y residuos. Difiere en todos los puntos sin polos; distancia al testigo original uno y mínimo al código 7/8. Transición de grado 2T y coeficiente principal -2*lambda^2 en característica distinta de dos. Fronteras de grado T-1 y composición de grado a lo sumo T+2<2T para T>=4, para cualquier combinación de coeficientes. Divisibilidad y evaluación del cociente iguales a la composición racional sobre puntos sin polos. Anulador de exactamente T-2 transiciones, separación de las últimas filas, divisibilidad de la transición válida, cociente de grado exacto T+2 y factorización del denominador que identifica el cociente con la fórmula AIR. Ejecución recursiva de cuadrados desde dos filas iniciales, transporte por homomorfismos e interpolación de Lagrange. Se construye un polinomio de grado menor que T con las filas y validez AIR demostradas. Construcción desde inicio 3, segunda fila 5 y lambda=1 en Goldilocks/Fp2, con imagen desde el campo base. Para 4<=k<=29: ejecución válida, traza de grado T=2^k, mínimo de distancia 7/8 incluso frente a candidatos de extensión y composición de grado <2T para todo coeficiente, igual a la expresión racional en todo el coset. No existe aproximante a distancia <=1/24; cuentas algebraicas de 16/32/64 filas.

Pendientes y límites: El dominio es un finset de puntos distintos. La distancia matemática no implica aceptación de una prueba, corrección de compromisos o solidez de un verificador. Requiere lambda no nulo y grado f<T; la validez original se recibe explícitamente en el modelo general. La ejecución concreta se construye por separado, sin asumir aceptación del legado. La composición es la fórmula AIR del manuscrito; las aceptaciones SHA3/Merkle/FRI/grinding del ejecutable permanecen empíricas y no se deducen de la pertenencia al código. Requiere raíz primitiva, T>=3 y característica distinta de dos para el grado exacto. No es un teorema sobre el bucle del verificador. Es interpolación algebraica; no formaliza la implementación NTT del interpolante ni sus costos o su serialización. No demuestra aceptación o rechazo de programas Rust, vinculación criptográfica, conocimiento cero ni solidez global. Los tres casos empíricos y sus seis certificados conservan identidad y alcance.

Referencias del registro: `Cap6-Validacion-Formal-108`, `Cap6-Validacion-Formal-126`, `Cap6-Validacion-Formal-127`, `Cap6-Validacion-Formal-128`, `Cap6-Validacion-Formal-129`, `Cap6-Validacion-Formal-130`, `Cap6-Validacion-Formal-131`, `Cap6-Validacion-Formal-132`, `Cap6-Validacion-Formal-133`, `Cap6-Validacion-Formal-134`.

### M31 — Límites del verificador legado y del conocimiento cero

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Representar el puente de raíces y su dominio, incluidos alias y rango de índices.
- Formalizar la reconstrucción del testigo del ejemplo pequeño si se usa como resultado matemático.
- No convertir pruebas de casos ni ausencia de enmascaramiento en una prueba general de solidez.

Referencias del registro: `Cap6-Validacion-Formal-103`, `Cap6-Validacion-Formal-107`, `Cap6-Validacion-Formal-108`, `Cap6-Validacion-Formal-112`, `Cap6-Validacion-Formal-131`, `Cap6-Validacion-Formal-132`, `Cap6-Validacion-Formal-133`, `Cap6-Validacion-Formal-134`, `Cap6-Validacion-Formal-162`, `Cap6-Validacion-Formal-163`, `Cap6-Validacion-Formal-164`, `Cap6-Validacion-Formal-165`.

### M32 — Raíz compartida, aperturas AIR y enlace FRI de TG2

Estado: **Componente Lean parcial**. Prioridad 2 (sin estimación de duración).

- Conservar el enlace local ya probado para el formato Fp2 compartido.
- Derivar ambas aceptaciones FRI del recorrido completo, acarreo y valor final, con formas e índices válidos.

Referencias del registro: `Cap6-Validacion-Formal-135`, `Cap6-Validacion-Formal-136`, `Cap6-Validacion-Formal-137`, `Cap6-Validacion-Formal-138`, `Cap6-Validacion-Formal-139`, `Cap6-Validacion-Formal-140`, `Cap6-Validacion-Formal-141`, `Cap6-Validacion-Formal-157`.

### M33 — Torres FRI y recuperación adaptativa

Estado: **Componente Lean parcial**. Prioridad 2 (sin estimación de duración).

- Conservar representantes, plegado, recuperación y excepciones previas al reto ya demostrados.
- Separar el lema elemental mecanizado del corolario bibliográfico general y del cambio uniforme beta/a_j.

Referencias del registro: `Cap6-Validacion-Formal-142`, `Cap6-Validacion-Formal-143`, `Cap6-Validacion-Formal-166`, `Cap6-Validacion-Formal-167`, `Cap6-Validacion-Formal-168`.

### M34 — Cota ideal histórica y sus tablas

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Formalizar E_i, su unión conservadora y los redondeos de la Tabla 6.19 si se mantiene como resultado matemático.
- No sustituir esa fórmula histórica por la cota refinada, aunque ambas tengan componentes comunes.

Referencias del registro: `Cap6-Validacion-Formal-142`, `Cap6-Validacion-Formal-143`, `Cap6-Validacion-Formal-144`, `Cap6-Validacion-Formal-145`, `Cap6-Validacion-Formal-150`, `Cap6-Validacion-Formal-151`, `Cap6-Validacion-Formal-152`, `Cap6-Validacion-Formal-153`, `Cap6-Validacion-Formal-154`, `Cap6-Validacion-Formal-155`, `Cap6-Validacion-Formal-156`.

### M35 — Muestra compartida e hipergeométrica H

Estado: **Componente Lean parcial**. Prioridad 2 (sin estimación de duración).

- Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.
- Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Referencias del registro: `Cap6-Validacion-Formal-107`, `Cap6-Validacion-Formal-142`, `Cap6-Validacion-Formal-143`, `Cap6-Validacion-Formal-149`, `Cap6-Validacion-Formal-150`, `Cap6-Validacion-Formal-151`, `Cap6-Validacion-Formal-152`, `Cap6-Validacion-Formal-153`, `Cap6-Validacion-Formal-154`, `Cap6-Validacion-Formal-155`, `Cap6-Validacion-Formal-156`, `Cap6-Validacion-Formal-166`, `Cap6-Validacion-Formal-167`, `Cap6-Validacion-Formal-168`, `Cap6-Validacion-Formal-169`, `Cap6-Validacion-Formal-170`, `Cap6-Validacion-Formal-171`, `Cap6-Validacion-Formal-172`.

### M36 — Solidez ideal por rondas y reinicios

Estado: **Componente Lean parcial**. Prioridad 2 (sin estimación de duración).

- Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.
- Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Referencias del registro: `Cap6-Validacion-Formal-166`, `Cap6-Validacion-Formal-167`, `Cap6-Validacion-Formal-168`, `Cap6-Validacion-Formal-169`, `Cap6-Validacion-Formal-170`, `Cap6-Validacion-Formal-171`, `Cap6-Validacion-Formal-172`.

### M37 — Extracción Merkle, bytes y orden temporal ROM

Estado: **Componente Lean parcial**. Prioridad 2 (sin estimación de duración).

- Conservar extracción, congelación y órdenes de primeras consultas bajo ausencia de aciertos.
- Obtener los hechos de registro y familias causales para todas las historias del protocolo.

Referencias del registro: `Cap6-Validacion-Formal-106`, `Cap6-Validacion-Formal-162`, `Cap6-Validacion-Formal-163`, `Cap6-Validacion-Formal-164`, `Cap6-Validacion-Formal-165`, `Cap6-Validacion-Formal-174`.

### M38 — Sesgo de reducción modular, híbridos y masa máxima

Estado: **Pendiente**. Prioridad 1 (sin estimación de duración).

- Contar preimágenes de la reducción modular de bloques uniformes.
- Probar Delta_F=r*(p-r)/(p*S), el producto de coordenadas y el híbrido de m retos frescos.
- Certificar los números Goldilocks sin condicionar a sucesos futuros del registro.

Referencias del registro: `Cap6-Validacion-Formal-112`, `Cap6-Validacion-Formal-158`, `Cap6-Validacion-Formal-159`, `Cap6-Validacion-Formal-160`, `Cap6-Validacion-Formal-162`, `Cap6-Validacion-Formal-163`, `Cap6-Validacion-Formal-164`, `Cap6-Validacion-Formal-165`, `Cap6-Validacion-Formal-174`, `Cap6-Validacion-Formal-175`.

### M39 — Presupuestos, formas, gramática y semántica del verificador

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.
- Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Referencias del registro: `Cap6-Validacion-Formal-104`, `Cap6-Validacion-Formal-105`, `Cap6-Validacion-Formal-176`, `Cap6-Validacion-Formal-177`, `Cap6-Validacion-Formal-178`.

### M40 — Potencial de nonces y cola del selector

Estado: **Pendiente**. Prioridad 2 (sin estimación de duración).

- Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.
- Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Referencias del registro: `Cap6-Validacion-Formal-106`, `Cap6-Validacion-Formal-161`, `Cap6-Validacion-Formal-176`, `Cap6-Validacion-Formal-177`, `Cap6-Validacion-Formal-178`, `Cap6-Validacion-Formal-179`, `Cap6-Validacion-Formal-180`, `Cap6-Validacion-Formal-181`.

### M41 — Cota ROM completa y ejemplo numérico

Estado: **Componente Lean parcial**. Prioridad 2 (sin estimación de duración).

- Conservar la cota parametrizada del evento excepcional del registro.
- Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.
- Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Referencias del registro: `Cap6-Validacion-Formal-109`, `Cap6-Validacion-Formal-110`, `Cap6-Validacion-Formal-111`, `Cap6-Validacion-Formal-162`, `Cap6-Validacion-Formal-163`, `Cap6-Validacion-Formal-164`, `Cap6-Validacion-Formal-165`, `Cap6-Validacion-Formal-173`, `Cap6-Validacion-Formal-179`, `Cap6-Validacion-Formal-180`, `Cap6-Validacion-Formal-181`.

### M42 — Extensión QROM de AIR/FRI

Estado: **Trabajo futuro**. Prioridad 4 (sin estimación de duración).

- Conservar el estado abierto de la omisión beta^S y las pérdidas cuánticas.
- No reabrir esta investigación ni convertirla en bloqueo del cierre activo de TG2.

Referencias del registro: `Cap2-Marco-Teorico-006`, `Cap3-Diseno-Arquitectura-012`, `Cap3-Diseno-Arquitectura-013`, `Cap6-Validacion-Formal-141`, `Cap6-Validacion-Formal-182`, `Cap7-Conclusiones-004`.

### M43 — Estándares, comparaciones y afirmaciones de alcance

Estado: **Respaldo documental**. Prioridad 3 (sin estimación de duración).

- Identificar fuente primaria, versión y fecha de cada afirmación externa.
- Separar categorías, recomendaciones, límites y propuestas de resultados demostrados; registrar correcciones editoriales.

Referencias del registro: `_tesis-frontmatter-001`, `_tesis-frontmatter-002`, `Cap2-Marco-Teorico-004`, `Cap2-Marco-Teorico-006`, `Cap2-Marco-Teorico-008`, `Cap3-Diseno-Arquitectura-012`, `Cap3-Diseno-Arquitectura-013`, `Cap3-Diseno-Arquitectura-017`, `Cap3-Diseno-Arquitectura-018`, `Cap3-Diseno-Arquitectura-019`, `Cap4-Nucleo-Criptografico-009`, `Cap4-Nucleo-Criptografico-010`, `Cap4-Nucleo-Criptografico-011`, `Cap5-Gestion-Claves-001`, `Cap5-Gestion-Claves-002`, `Cap5-Gestion-Claves-003`, `Cap5-Gestion-Claves-009`, `Cap5-Gestion-Claves-010`, `Cap5-Gestion-Claves-024`, `Cap5-Gestion-Claves-035`, `Cap6-Validacion-Formal-064`, `Cap6-Validacion-Formal-070`, `Cap6-Validacion-Formal-162`, `Cap6-Validacion-Formal-163`, `Cap6-Validacion-Formal-164`, `Cap6-Validacion-Formal-165`, `Cap7-Conclusiones-001`, `Cap7-Conclusiones-002`, `Cap7-Conclusiones-003`, `SUP01`, `SUP13`, `SUP14`.

### M44 — Procedencia de experimentos y contraste de implementaciones

Estado: **Respaldo documental**. Prioridad 3 (sin estimación de duración).

- Conservar versiones, entradas, logs y alcance de los corpus R1–R5 y H1/H2.
- No inferir una prueba universal de una ejecución finita ni identificar corridas solo por cifras próximas.

Referencias del registro: `_tesis-frontmatter-001`, `_tesis-frontmatter-002`, `Cap3-Diseno-Arquitectura-014`, `Cap4-Nucleo-Criptografico-002`, `Cap4-Nucleo-Criptografico-012`, `Cap5-Gestion-Claves-001`, `Cap5-Gestion-Claves-002`, `Cap5-Gestion-Claves-003`, `Cap5-Gestion-Claves-016`, `Cap5-Gestion-Claves-033`, `Cap5-Gestion-Claves-034`, `Cap5-Gestion-Claves-035`, `Cap6-Validacion-Formal-033`, `Cap6-Validacion-Formal-034`, `Cap6-Validacion-Formal-074`, `Cap6-Validacion-Formal-075`, `Cap6-Validacion-Formal-076`, `Cap6-Validacion-Formal-077`, `Cap6-Validacion-Formal-078`, `Cap6-Validacion-Formal-079`, `Cap6-Validacion-Formal-080`, `Cap6-Validacion-Formal-081`, `Cap6-Validacion-Formal-082`, `Cap6-Validacion-Formal-083`, `Cap6-Validacion-Formal-084`, `Cap6-Validacion-Formal-085`, `Cap6-Validacion-Formal-086`, `Cap6-Validacion-Formal-087`, `Cap6-Validacion-Formal-088`, `Cap6-Validacion-Formal-089`, `Cap6-Validacion-Formal-090`, `Cap6-Validacion-Formal-091`, `Cap6-Validacion-Formal-092`, `Cap6-Validacion-Formal-093`, `Cap6-Validacion-Formal-094`, `Cap6-Validacion-Formal-095`, `Cap6-Validacion-Formal-096`, `Cap6-Validacion-Formal-099`, `Cap6-Validacion-Formal-101`, `Cap6-Validacion-Formal-102`, `Cap6-Validacion-Formal-103`, `Cap6-Validacion-Formal-113`, `Cap6-Validacion-Formal-125`, `Cap6-Validacion-Formal-131`, `Cap6-Validacion-Formal-132`, `Cap6-Validacion-Formal-133`, `Cap6-Validacion-Formal-134`, `Cap6-Validacion-Formal-137`, `Cap6-Validacion-Formal-138`, `Cap6-Validacion-Formal-139`, `Cap6-Validacion-Formal-140`, `Cap6-Validacion-Formal-157`, `Cap6-Validacion-Formal-161`, `Cap6-Validacion-Formal-183`, `Cap6-Validacion-Formal-184`, `Cap7-Conclusiones-001`, `Cap7-Conclusiones-002`, `Cap7-Conclusiones-003`, `Cap7-Conclusiones-004`, `SUP05`, `SUP12`, `SUP14`.

### M45 — Diferencia de preimágenes cortas

Estado: **Componente Lean parcial**. Prioridad 2 (sin estimación de duración).

- Conservar el lema general con mapas aditivos y norma ya demostrado.
- Instanciar R_q, representantes enteros y no nulidad módulo q para la formulación exacta del manuscrito.

Referencias del registro: `Cap6-Validacion-Formal-043`, `Cap6-Validacion-Formal-044`.

### M46 — Candidato próximo, unicidad y campo base

Estado: **Componente Lean parcial**. Prioridad 2 (sin estimación de duración).

- Conservar la selección parcial previa a retos, unicidad y descomposición f=A+zB ya mecanizadas.
- Conservar el conteo de puntos no base con sus hipótesis y enlazarlo a la consulta autenticada sin imponer un oráculo globalmente base.

Referencias del registro: `Cap6-Validacion-Formal-146`, `Cap6-Validacion-Formal-147`, `Cap6-Validacion-Formal-148`.

## Hallazgos editoriales y matemáticos

- **E01** (formalizacion/ALCANCE-MANUSCRITO.md): El inventario base tiene 36 bloques con enlace Lean y 35 con revisión parcial marcada. Precisar ambos conteos; no llamar revisados a los 36 ni interpretar el cociente como cobertura completa.
- **E02** (Cap6-Validacion-Formal-166, SUP13, SUP14): Hay frases de estado anteriores a la auditoría de 777 resultados que presentan Lean enteramente pendiente. Preparar redacción que distinga componentes ideales mecanizados, correspondencia con el ejecutable y dictamen pendiente.
- **E03** (Cap5-Gestion-Claves-008): La regla aproximada min-entropía por longitud necesita hipótesis sobre la distribución conjunta. Formalizar independencia o una tasa condicional antes de usar la regla de acumulación.
- **E04** (Cap3-Diseno-Arquitectura-003, Cap3-Diseno-Arquitectura-006): La comparación CPU depende de las corridas y bibliotecas; la aritmética de tamaños no demuestra un cuello de botella universal. Mantener las comparaciones condicionadas a serie y carga al revisar la narrativa TG2.
- **E05** (Cap6-Validacion-Formal-135): Dieciséis bytes canónicos de coordenadas y diecisiete bytes de entrada de hoja Merkle describen niveles diferentes. Explicitar el prefijo de la hoja para evitar identificar el formato con el legado de nueve bytes.
- **E06** (SUP02, SUP03): El detector omitió argumentos de incentivos y quórum que contienen obligaciones matemáticas. Conservarlos en el registro complementario sin modificar el alcance ni entregables aprobados de TG1.

Las fuentes y los hallazgos mantienen su procedencia. Las pruebas nuevas respaldan
el componente algebraico de los anillos y del contraejemplo; no reescriben las
afirmaciones experimentales o de seguridad para atribuirles un alcance mayor.
La aceptación heredada conserva su evidencia histórica independiente del modelo.

## Reproducción y límites

```powershell
python scripts/verificar_formalizacion.py
python scripts/verificar_revision_manuscrito.py
python -m unittest discover -s scripts/tests -p test_verificar_revision_manuscrito.py
```

El comprobador exige fuentes y líneas exactas, conserva enlaces previos y requiere
teoremas registrados y auditados para cada modelo marcado como verificado. Los
ocho controles de trazabilidad y los cinco del analizador pasan; no deciden por
sí solos la correspondencia semántica.

La [auditoría vigente](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Anillos-Contraejemplo/README.md)
repite compilación, axiomas y núcleo de 129 módulos confiando en importados; fija
254 fuentes y 135 logs. La revisión reutiliza esa auditoría
por identidad. Se conservan **2053 logs de 30 etapas**, incluidos los 1918 previos.
La tesis completa no está verificada y el dictamen independiente sigue pendiente.
