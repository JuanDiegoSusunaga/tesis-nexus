# Guía de revisión de la tesis NEXUS

**Autor:** Juan Diego Susunaga Velasquez.
**Dirigida al director de la tesis. Fecha de preparación:** 20 de octubre de 2026.

## Qué solicito revisar

Le solicito revisar si las afirmaciones de la tesis están justificadas por sus demostraciones y pruebas, y si las conclusiones describen correctamente lo que se logró. El punto matemático principal es un límite para la probabilidad de que un verificador acepte una afirmación falsa, bajo las hipótesis que explico a continuación.

La explicación principal resume el problema y el resultado. El anexo reúne las fórmulas, las condiciones y seis preguntas específicas.

## El problema que aborda la tesis

NEXUS estudia firmas digitales poscuánticas y gestión de claves en una arquitectura de dos capas: una ejecuta operaciones y otra recibe información para su comprobación y anclaje. La tesis reúne un modelo de arquitectura, un prototipo y una evaluación de componentes; no presenta una blockchain completa ya operativa.

Una de las preguntas es cómo comprobar un cálculo mediante un certificado. El **probador** prepara ese certificado y el **verificador** lo examina para aceptar o rechazar la afirmación presentada. El certificado es un conjunto de datos de una prueba, no un certificado institucional.

Para ilustrar la diferencia entre un cálculo correcto y uno incorrecto, supongamos una regla sencilla: elevar dos números al cuadrado y sumar. Con 3 y 4, el resultado es 25, no 26. Este ejemplo solo explica qué significa incumplir una regla; no representa una transacción ni reproduce un ataque al protocolo.

El prototipo utiliza una recurrencia numérica ilustrativa y comprueba relaciones algebraicas sobre sus valores. No incorpora dentro de esa prueba la verificación de todas las firmas ni todas las reglas de una aplicación. Por eso, demostrar una propiedad de ese verificador no equivale a demostrar que toda la arquitectura es segura.

## Qué significa el resultado matemático

El resultado de la sección 6.7.9 responde a esta pregunta: **¿qué tan probable es que el verificador matemático acepte un certificado cuyo enunciado es falso, aunque quien lo prepare elija sus acciones de forma maliciosa?**

Aquí, una afirmación falsa es la que no satisface la relación de validez definida en el modelo. No se identifica automáticamente con una firma falsificada, un robo de fondos o una transacción inválida de una aplicación completa.

La demostración obtiene una **cota superior**: un límite que la probabilidad no supera bajo las condiciones declaradas. La probabilidad real podría ser menor. El resultado tampoco afirma que exista un ataque que alcance ese límite.

Por ejemplo, para 4096 filas de cálculo y los presupuestos concretos del anexo, la cota es menor que 0,004757335454, aproximadamente 0,476 %. Esta cifra no es una tasa de fallos observada en pruebas ni una probabilidad de ataque por transacción. Describe un experimento matemático con recursos y supuestos fijados. Tampoco acredita por sí sola 100 bits de seguridad.

La hipótesis más importante es cómo se representa el hash. Un hash transforma datos en un resumen de longitud fija. La demostración usa un **modelo de oráculo aleatorio clásico**, abreviado ROM: para cada entrada nueva se obtiene una respuesta uniforme de 256 bits; si la entrada se repite, se conserva la respuesta anterior. El modelo comparte esas respuestas entre todas las partes del protocolo. Rust, en cambio, ejecuta la función concreta SHA3-256. La prueba en el modelo ideal no demuestra automáticamente la misma garantía para esa función concreta.

## Cómo se construye el argumento

El verificador combina restricciones sobre el cálculo con comprobaciones sobre polinomios. AIR es la representación de las reglas del cálculo mediante relaciones algebraicas. FRI es el protocolo que comprueba proximidad a evaluaciones de polinomios de grado limitado. En la construcción vinculada se comprueban tanto la traza del cálculo como la combinación de restricciones.

La intuición es comprobar posiciones elegidas mediante retos. La dificultad está en justificar qué puede elegir o conocer el probador antes de esos retos y qué ocurre si vuelve a intentarlo. La demostración debe cubrir sus decisiones basadas en respuestas anteriores y la memoria del hash.

También debe respetar que las comprobaciones comparten una misma muestra de posiciones. No sería correcto tratarlas como ensayos independientes sin demostrarlo. El anexo explica cómo la cota incluye las distintas causas de error y el efecto del trabajo exigido a cada intento.

## Qué aportan Lean y Rust

**Lean comprueba demostraciones.** En la formalización, su núcleo verifica que los teoremas se deducen de las definiciones, hipótesis y axiomas utilizados. Esto respalda el resultado matemático formalizado. No implica que toda frase de la tesis sea correcta ni que el modelo describa sin diferencias al programa ejecutable.

**Rust ejecuta el prototipo.** Sus pruebas comprueban casos de aceptación, rechazo e integración. La ruta activa exige un certificado vinculado y compara sus datos con un contexto local antes de registrar un envío. Es evidencia de funcionamiento en los casos ensayados; no una demostración para todas las entradas posibles.

La correspondencia universal entre programa y modelo matemático sigue sin demostrarse. Además, la reducción concreta que permitiría atribuir una garantía de seguridad a las firmas del ejecutable tiene cumplimiento parcial. El resultado del verificador no sustituye esa reducción. La extensión completa de esta prueba a consultas cuánticas al hash permanece como trabajo futuro.

## Qué respuesta necesito del director

Le agradecería señalar:

1. Si la explicación del resultado y sus hipótesis es correcta, y qué pasos requieren mayor justificación.
2. Si la tesis distingue suficientemente las demostraciones, la evidencia del programa y las afirmaciones tomadas de la literatura.
3. Si el alcance alcanzado y sus limitaciones están descritos de forma adecuada frente a los objetivos, especialmente en la parte de seguridad concreta de las firmas.

Para cada observación, bastaría identificar el pasaje, explicar el motivo y proponer la corrección o aclaración necesaria. Las seis preguntas del anexo permiten profundizar en los puntos matemáticos. No representan seis módulos nuevos pendientes de implementación.

## Anexo técnico

### Condiciones del resultado

La cota corresponde al verificador matemático de bytes: incluye la lectura del certificado y las comprobaciones del modelo, no una equivalencia universal con el ejecutable. Sus parámetros son:

- **Tamaño del cálculo.** $T=2^k$ filas, con $4\leq k\leq12$. El dominio de evaluación tiene $N=8T$ posiciones, agrupadas en $M=N/2=2^{k+2}$ parejas de posiciones opuestas. En este anexo, M cuenta parejas, no operaciones de un lote.
- **Muestra y corte.** Se consultan cuarenta parejas distintas, compartidas por AIR y ambos recorridos FRI. Para obtenerlas se permiten como máximo $R=512$ extracciones, contando duplicados; si no se completa la muestra, se rechaza.
- **Trabajo.** $g=12$ o $g=20$ bits. El probador puede variar un nonce, un valor usado en la búsqueda del trabajo. El análisis incluye reintentos; no supone que solo exista un nonce aceptable.
- **Recursos adversarios.** $Q$ limita todas las llamadas del adversario al oráculo, incluidas preparación, búsqueda e intercalaciones. El adversario puede decidir su siguiente acción a partir de las respuestas anteriores, pero no recibe información correlacionada con el oráculo que se omita del experimento.
- **Presupuesto compartido.** El verificador hace a lo sumo $24383+R$ llamadas, incluso cuando rechaza. Para $R=512$, el presupuesto común es $B=Q+24895$. B cuenta llamadas o direcciones, no la altura de un árbol.
- **Registro auxiliar.** $L$ limita marcas adicionales del registro matemático. No es una cantidad de bytes del certificado.
- **Modelo de hash.** Un único oráculo clásico finito de respuestas de 256 bits, con memoria y compartido por todas las partes del protocolo. No es una hipótesis de respuestas nuevas e independientes en cada llamada repetida.

### Fórmulas y significado de sus términos

Se reproducen las fórmulas de la sección 6.7.9 sin retirar sus términos de error. Para el primo Goldilocks $p=2^{64}-2^{32}+1$, se definen:

$$
\begin{aligned}
\rho&=\frac{130709}{p^2}+\frac{2524360}{10^{35}},\\
\delta(B)&=\min\left\{1,\frac{512(B+515)}{2^{256}}\right\},\\
h_k&=\frac{\binom{\lfloor7\cdot2^{k+2}/8\rfloor}{40}}
{\binom{2^{k+2}}{40}},\\
\sigma_k(B)&=h_k+2^{-300}+\delta(B).
\end{aligned}
$$

La fracción $h_k$ es una cota de omisión de la muestra: expresa la posibilidad de que sus cuarenta parejas no detecten las discrepancias consideradas en el argumento. El término $2^{-300}$ acota la cola del selector. El término $\delta(B)$ cubre el error de comparar su comportamiento real con el muestreo ideal, conservando la memoria del oráculo; esa comparación se denomina acoplamiento. El término $\rho B$ cubre conjuntamente las excepciones algebraicas y FRI, incluido el sesgo al transportar bytes al campo.

Para un perfil fijo, la cota es:

$$
\begin{aligned}
\Pr[\mathsf{AceptaFalsa}_k]\leq\min\Bigg\{1,\,
&\min\left\{1,\frac{B(49B+L)}{2^{256}}\right\}\\
&+\rho B+(Q+1)2^{-g}\sigma_k(B)\Bigg\},
\end{aligned}
$$

El primer sumando controla la excepción del registro hash. El segundo cubre las excepciones AIR/FRI. El tercero combina el número de parejas estado/nonce consideradas, el trabajo y el riesgo de omisión o abandono del selector.

Hay a lo sumo $Q+1$ parejas estado/nonce distintas. El factor $2^{-g}$ corresponde a la masa del trabajo en el modelo y debe componerse con el selector antes de observar las respuestas; no se obtiene escogiendo después únicamente el nonce ganador.

Si el perfil final se elige adaptativamente, se usa:

$$
\begin{aligned}
\Pr[\mathsf{AceptaFalsa}]\leq\min\Bigg\{1,\,
&\min\left\{1,\frac{B(49B+L)}{2^{256}}\right\}\\
&+\rho B+(Q+1)2^{-g}\sum_{j=4}^{12}\sigma_j(B)\Bigg\}.
\end{aligned}
$$

Solo se suma por perfil el riesgo del selector. La excepción hash y las excepciones AIR/FRI se incluyen una sola vez, no una vez por cada perfil. El mínimo con uno conserva el límite propio de una probabilidad.

### Cómo interpretar los ejemplos numéricos

Para $L=1000000$, $T=4096$, $k=12$, $g=20$ y $Q=2^{20}$, el resultado formalizado da:

$$
\Pr[\mathsf{AceptaFalsa}_{12}]<0{,}004757335454.
$$

En palabras, el límite es aproximadamente 0,476 %, bajo todos esos supuestos. Para $L=1000000$, $g=20$ y $Q=1000000$, la unión de todos los perfiles tiene cota menor que $1/20$, es decir, 5 %. Son dos enunciados con condiciones distintas, no dos mediciones de un ataque. Una cota superior no es necesariamente ajustada ni garantiza que un adversario la alcance.

Los [teoremas de la cota con trabajo](../../../formalizacion/Nexus/Verificador/CotaTrabajoFinal.lean) son cota_512 y cota_512_todos. Los [ejemplos numéricos enlazados con aceptación](../../../formalizacion/Nexus/Verificador/CotaTrabajoNumerica.lean) son aceptacion_4096_release y aceptacion_release.

### Seis preguntas para examinar la demostración

**1. Reglas algebraicas y detección del error.** ¿Son correctas la divisibilidad y las cotas de grados, cancelación y distancia bajo las hipótesis declaradas? La cancelación es el caso en que una combinación de restricciones oculta un error. Revisar la sección 6.7.2, [grados válidos](../../../formalizacion/Nexus/AIR/GradosValidos.lean), [cancelación sesgada](../../../formalizacion/Nexus/AIR/CancelacionSesgada.lean) y [cota de distancia](../../../formalizacion/Nexus/N02/Solucion.lean). Hay que distinguir una traza incorrecta de un enunciado falso, y el reto uniforme ideal del que se obtiene transportando bytes.

**2. Elección del polinomio de referencia.** ¿Está justificada la unicidad y elección previa del candidato próximo sin usar retos futuros? Candidato próximo significa aquí el polinomio de grado acotado cercano a los valores comprometidos. Revisar las secciones 6.7.4–6.7.5, [unicidad](../../../formalizacion/Nexus/N03/Solucion.lean), [candidato](../../../formalizacion/Nexus/N06/Candidato.lean) y [conjuntos previos](../../../formalizacion/Nexus/Verificador/ConjuntosPrevios.lean). Importa que esa elección solo utilice la información ya disponible.

**3. Comprobaciones FRI.** ¿Son válidas las cotas locales y por rondas, con sus grados, dominios y término final? Cada ronda reduce la comprobación mediante un plegado de evaluaciones; la justificación debe permitir remontar ese proceso. Revisar las secciones 6.7.5 y 6.7.8, [experimento FRI](../../../formalizacion/Nexus/FRI/Experimento.lean), [cota FRI causal](../../../formalizacion/Nexus/Verificador/CotaFRICausal.lean) y [cota de rondas](../../../formalizacion/Nexus/Verificador/CotaAdaptativaFinal.lean). No debe suponerse independencia de retos elegidos a partir de la historia sin el transporte demostrado.

**4. Combinación de las comprobaciones.** ¿La composición AIR/doble FRI y la muestra compartida justifican la cota final sin contar dos veces una misma excepción? Revisar las secciones 6.7.8–6.7.9, [cardinal de la vista](../../../formalizacion/Nexus/Verificador/CardinalVista.lean), [cota de reconstrucción](../../../formalizacion/Nexus/Verificador/CotaSinBad.lean) y la cota con trabajo. Se deben conservar los eventos excepcionales, el exceso de reconstrucción y las consultas realizadas antes del selector, con la memoria del oráculo.

**5. Decisiones adaptativas y reintentos.** ¿El teorema cubre el adversario y los presupuestos declarados, incluidos trabajo, perfiles y reinicios? Revisar la sección 6.7.9, [presupuesto derivado del programa](../../../formalizacion/Nexus/Verificador/PresupuestoGlobal.lean), [masa del trabajo](../../../formalizacion/Nexus/Verificador/TrabajoDigest.lean), [cobertura por primeras parejas](../../../formalizacion/Nexus/Verificador/CoberturaTrabajo.lean) y los teoremas finales. Interesan el cargo $Q+1$, el error de acoplamiento y que no se condicione al nonce ganador. Esta pregunta no solicita completar la extensión cuántica.

**6. Correspondencia con las conclusiones de la tesis.** ¿Se distingue suficientemente lo demostrado en el modelo de lo que aporta la literatura y de lo observado en el programa? Revisar los objetivos, la sección 6.4 y las conclusiones. Solicito identificar qué afirmaciones son aceptables en su alcance, cuáles requieren corrección y cuáles exigirían ampliar el trabajo.

### Por dónde comenzar la lectura

Sugiero leer primero los objetivos del capítulo 1 y el balance del capítulo 7. Después, la sección 6.4 distingue los fundamentos de las firmas y sus condiciones pendientes. La sección 6.7.9 contiene la cota demostrada del verificador, y la 6.7.10 delimita su alcance cuántico.

La [tesis en Word](../../01-Manuscrito/Tesis-NEXUS-completa.docx) y la [tesis en PDF](../../01-Manuscrito/Tesis-NEXUS-completa.pdf) contienen el glosario y la notación en las páginas preliminares. La [matriz de formalización](../../../formalizacion/REVISION-MANUSCRITO.md) y las fuentes enlazadas en este anexo permiten examinar detalles concretos.

### Evidencia disponible y límites de la revisión

La [auditoría global Lean del 20 de octubre](../../06-Evidencia-TG2/2026-10-20/Lean-Global/verificacion.json) registra 2709 declaraciones, sin pruebas admitidas mediante sorryAx ni axiomas fuera de la política declarada. Este registro respalda la comprobación formal existente; no representa una aprobación académica.

La [adaptación Rust](../../06-Evidencia-TG2/2026-10-20/Rust-Lean/adaptacion.json), la [integración ActiveChain](../../06-Evidencia-TG2/2026-10-20/ActiveChain/integracion.json) y la [comprobación global final Rust](../../06-Evidencia-TG2/2026-10-20/Rust-Global-Final/verificacion.json) conservan su evidencia: check, 223 pruebas y build correctos en la última global, con advertencias registradas. No se suman los conteos de ejecuciones anteriores ni se interpretan las pruebas finitas como una demostración universal.

Los límites de procedencia de las mediciones históricas H1/H2, la calificación de una fuente física de entropía, la custodia y la eliminación de secretos conservan sus condiciones. El AIR ilustrativo no acredita una aplicación L2 completa ni conocimiento cero, propiedad que exige no revelar información adicional sobre el testigo. La seguridad de las firmas y la seguridad cuántica del protocolo requieren sus propios argumentos.

Esta guía solicita observaciones; no registra envío, recepción, dictamen ni aprobación de la tesis.
