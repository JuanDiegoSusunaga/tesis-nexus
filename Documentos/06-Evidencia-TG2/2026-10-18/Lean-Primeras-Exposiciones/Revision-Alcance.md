# Primeras exposiciones sin nuevos cierres

Juicio semántico del agente; no sustituye dictamen independiente. Se mantienen
los 46 estados y todos los criterios. M37 conserva su cierre clásico finito
y las obligaciones adicionales siguen abiertas.

La primera exposición es la primera consulta efectiva de la dirección I de
un candidato. La semilla y los conjuntos GT/GC son funciones del prefijo anterior
a esa respuesta. Se reconstruye el programa residual únicamente con el pasado
y se demuestra que la activación corresponde a la próxima consulta, todavía
ausente de la tabla. Cada dirección puede cobrarse una sola vez; las repeticiones
posteriores no abren otro intento de esa misma dirección.

La cota local del selector se aplica solo en las fibras activadas y se pondera
por la probabilidad de activación. Sin suponer independencia entre candidatos,
la unión registrada satisface

    Pr(existe candidato activado con omisión o abandono) <= rho * E[inicios]
    E[inicios] <= E[direcciones distintas consultadas] <= B
    rho = choose(g,q)/choose(2^e,q) + tau + min(1,R*(m+R+1)/2^256).

Así se obtiene rho*B para un presupuesto B válido en el programa común. Los
límites g y m solo se exigen en las fibras activas. Para R=512, q=40 y k=4..12,
M=2^(k+2) y tau<2^(-300). Los dos FRI siguen usando una sola muestra compartida.

Una preconsulta deliberada puede tener probabilidad alta. No se la identifica
con una colisión rara ni se demuestra que Pr(preconsulta) sea pequeña. Se prueba
que toda dirección ya consultada tiene una primera exposición estrictamente
anterior. La omisión de un candidato reutilizado se remonta a ese primer intento
**si allí se registraron la misma semilla y conjuntos que contienen el conjunto
bueno final**. Esta es una premisa explícita de cobertura causal.

La unión registrada ya no necesita un sumando separado Pr(preconsulta). Falta
construir el registro que cubra todos los candidatos/nonces reales y demostrar
su conservación de semilla y conjuntos, derivar los conjuntos buenos de todas
las rondas FRI y sus cotas g/m/B, integrar el factor de trabajo y las inclusiones
de aceptación falsa bajo el mismo experimento. El digest de trabajo no es la
semilla: el canal absorbe el nonce después del trabajo antes del selector.

El adaptador de bytes identifica las activaciones con las próximas consultas I
reales y las carga a direcciones distintas de un programa arbitrario. También
acota la unión de éxitos del selector matemático instrumentado de 40 índices.
Ese éxito solo comprueba pertenencia a GT/GC; no es aceptación del verificador
completo. La elección de un candidato final usando el futuro no queda cubierta
automáticamente por la unión.

R sigue siendo un corte analítico, sin cambio de Rust. B no se identifica por
definición con Q o Q+V_T. No se condiciona a SinBad, completar ni aceptación.
Permanecen el refinamiento universal Rust, EOF estricto frente al ejecutable,
la procedencia original de H1/H2 y el dictamen independiente. Qiskit/Aer y QROM
AIR/FRI siguen para futuro. Se conservan los seis grupos parciales y sus criterios.

## Criterios originales y pendientes

### M26 — Aritmética de mediciones: unidades, razones y redondeos

- Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.
- Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Pendiente: Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas.

### M35 — Muestra compartida e hipergeométrica H

- Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.
- Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Pendiente: Se cuenta ya la unión de candidatos registrados en su primera exposición: rho*E[inicios], acotada por rho*B para B direcciones distintas; rho contiene hipergeométrica, tau y delta. Una preconsulta deliberada puede remitirse al primer intento si conserva la semilla y conjuntos allí congelados; no se afirma que Pr(preconsulta) sea pequeña. Falta construir el registro causal que cubra todos los candidatos finales reales, derivar GT/GC y g/m/B, enlazar todas las rondas FRI y sus eventos de solidez, y el refinamiento universal Rust.

### M36 — Solidez ideal por rondas y reinicios

- Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.
- Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Pendiente: Se localizan primeras exposiciones en la traza y se cargan sus inicios a direcciones distintas, conservando la ley exacta de continuación del verificador. Falta el adaptador integral de rondas y reinicios y la revisión independiente; el autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T.

### M39 — Presupuestos, formas, gramática y semántica del verificador

- Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.
- Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Pendiente: El programa arbitrario de bytes tiene un registro de primeras consultas I y una cota para la unión de éxitos del selector instrumentado. Falta la cobertura de candidatos del verificador completo, refinamiento universal de serde/bincode, operaciones de máquina y Rust, y la identificación de presupuestos globales. Permanecen EOF estricto y corte analítico R.

### M40 — Potencial de nonces y cola del selector

- Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.
- Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Pendiente: La carga por primera exposición ya evita cobrar repeticiones y permite unir candidatos con una sola tabla, sin independencia. Se obtiene rho por el número esperado de inicios y una cota por direcciones distintas. Falta construir el registro causal de todos los candidatos/nonces reales, justificar la conservación de semilla y conjuntos buenos, derivar g/m/B y valor<=rho antes de responder, e incorporar el factor de trabajo y las intercalaciones del experimento común. El digest de trabajo no es la semilla del selector; un nonce encontrado no se trata como ensayo independiente.

### M41 — Cota ROM completa y ejemplo numérico

- Conservar la cota parametrizada del evento excepcional del registro.
- Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.
- Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Pendiente: La unión registrada de primeras exposiciones y su cota se enlazan a bytes reales. Falta demostrar que contiene toda aceptación falsa del verificador, construir los conjuntos buenos causales para las rondas FRI, integrar el factor de trabajo, presupuestos y excepciones bajo un solo experimento, refinamiento universal Rust y el ejemplo numérico integral. No se ha demostrado solidez global ni una cota pequeña para Pr(preconsulta).
