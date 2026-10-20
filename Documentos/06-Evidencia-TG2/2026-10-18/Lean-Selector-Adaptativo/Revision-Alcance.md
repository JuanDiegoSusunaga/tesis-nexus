# Continuación y selección adaptativa sin nuevos cierres

Juicio semántico del agente; no sustituye dictamen independiente. Se mantienen
los 46 estados y todos los criterios, incluido el cierre delimitado de M37
y las obligaciones adicionales abiertas.

Después de n consultas de un árbol adaptativo, su resultado se conserva y
su transcripción restante es la cola del registro original. Dos oráculos que
producen el mismo prefijo dejan exactamente el mismo árbol residual. La ley
de resultado y cola, condicionada solo a ese pasado, es la evaluación con
memoria sobre las completaciones de la tabla observada.

Los prefijos realizables forman una partición finita. Cada pasado se pondera
por su cardinal exacto, sin suponer equiprobabilidad de las transcripciones.
La semilla y los conjuntos GT/GC pueden ser funciones arbitrarias del prefijo.
Dentro de cada fibra quedan fijados antes de generar la cadena del selector.

Se prueba, sobre todos los pasados, la cota de omisión o abandono

    E[H(GT inter GC)+tau+delta] + Pr(primera dirección preconsultada).

Si cada pasado tiene a lo sumo m direcciones distintas y |GT inter GC|<=g,
la cota es choose(g,q)/choose(2^e,q)+tau+min(1,R*(m+R+1)/2^256)+Pr(preconsulta).
Con R=512, q=40 y k=4..12, M=2^(k+2)=4*2^k y tau<2^(-300).
Se conserva una única muestra para ambos FRI; no se multiplican probabilidades.

**No se demuestra que Pr(preconsulta) sea pequeña.** La frescura deja de ser
una premisa global del selector y su fallo pasa a un término explícito. Falta
acotarlo y cargarlo a las excepciones del experimento real de candidatos/nonces,
derivar sus conjuntos buenos y cotas g/m, integrar las primeras exposiciones y
las rondas FRI y demostrar las inclusiones de aceptación falsa y su composición.

El evento de preconsulta también incluye consultas deliberadas después de
conocer una semilla. Por ello no se identifica automáticamente con el evento
de colisiones ya acotado: la carga debe justificarse desde la primera exposición
y la contabilidad de candidatos. La cota actual puede resultar trivial si
ese término es grande.

El adaptador de bytes admite cualquier programa finito de exploración previa.
Su universo contiene el soporte de todas las ramas y todas las entradas I.
Se conserva el prefijo, su número de direcciones y el evento real de preconsulta.
La cota se enlaza al resultado del selector matemático que completa 40 índices
y comprueba pertenencia a GT/GC. Este resultado instrumentado no es la
aceptación del verificador completo.

Separadamente se instancia la ley exacta de continuación con el verificador
completo, propuesta adaptativa e intercalaciones. Las consultas restantes
se acotan por altura(programa)-n. Esto no identifica altura con Q+V_T ni
establece solidez integral o refinamiento universal Rust.

La exploración puede ser adaptativa antes de la cadena, pero semilla y conjuntos
no se eligen usando su futuro. No se condiciona a SinBad, completar o aceptación.
R sigue siendo un corte analítico y la cola extendida no es el registro real
después de completar. Se conservan EOF estricto, límites de Rust y el carácter
matemático del ROM finito. Qiskit/Aer y QROM AIR/FRI continúan para futuro.

## Criterios originales y pendientes

### M26 — Aritmética de mediciones: unidades, razones y redondeos

- Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.
- Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Pendiente: Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas.

### M35 — Muestra compartida e hipergeométrica H

- Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.
- Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Pendiente: La continuación tras un prefijo tiene ya su ley exacta. La semilla del selector y los conjuntos buenos pueden depender de una exploración adaptativa anterior; se obtiene una cota sobre todos los pasados, con una única muestra compartida y un término explícito Pr(primera dirección preconsultada). Falta acotar ese término para los candidatos reales y cargarlo a las excepciones del experimento común, derivar los conjuntos buenos causales y enlazar las primeras exposiciones y todas las rondas FRI. También permanece el refinamiento universal Rust. No se condiciona a SinBad, completar, aceptación ni a un futuro elegido favorablemente.

### M36 — Solidez ideal por rondas y reinicios

- Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.
- Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Pendiente: El mismo verificador con propuesta adaptativa e intercalaciones ya tiene ley exacta de resultado y continuación tras un prefijo observado, y presupuesto residual altura(programa)-n. Falta el adaptador integral de rondas y reinicios y la revisión independiente; el autor declaró que no hay dictamen. No se identifica automáticamente B con consultas hash Q ni altura con Q+V_T.

### M39 — Presupuestos, formas, gramática y semántica del verificador

- Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.
- Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Pendiente: El verificador matemático conserva su presupuesto y ahora su ley exacta tras cualquier prefijo efectivo. El selector de bytes admite decisiones dependientes del pasado y contabiliza explícitamente la primera dirección preconsultada. Falta refinamiento universal de serde/bincode, operaciones de máquina y ejecutable Rust; permanecen EOF estricto y corte analítico R. Los límites de altura no se identifican automáticamente con Q+V_T.

### M40 — Potencial de nonces y cola del selector

- Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.
- Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Pendiente: El selector ya admite semilla y conjuntos buenos elegidos del prefijo de una exploración adaptativa y produce una cota global con Pr(preconsulta) explícita. Falta construir los candidatos/nonces reales, fijar sus cotas g/m y valor<=rho antes de responder, acotar y cargar las preconsultas y la carga global de inicios, e incorporar el factor de trabajo y las intercalaciones del experimento común. Un nonce ya encontrado no se convierte en una prueba independiente.

### M41 — Cota ROM completa y ejemplo numérico

- Conservar la cota parametrizada del evento excepcional del registro.
- Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.
- Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Pendiente: Se dispone de ley de continuación del verificador completo y de cota del selector sobre todos los pasados, con omisión compartida, abandono y Pr(preconsulta) explícita. Falta acotar esta probabilidad y probar las inclusiones de todos los eventos de solidez y las rondas FRI bajo el mismo experimento de candidatos/nonces, componer los presupuestos, enlazar universalmente Rust y certificar el ejemplo numérico integral. No se ha demostrado una cota de aceptación falsa global.
