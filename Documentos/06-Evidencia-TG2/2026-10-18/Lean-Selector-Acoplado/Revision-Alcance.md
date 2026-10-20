# Revisión del acoplamiento local sin nuevos cierres

Juicio semántico del agente; no sustituye dictamen independiente. Se mantienen
los 46 estados y todos los criterios originales, incluido el cierre delimitado
de M37 y las obligaciones adicionales abiertas.

Tras fijar una tabla compatible de m direcciones observadas, la cadena
H(entradaReto estado I) se compara con R respuestas independientes de 32 bytes.
La codificación de direcciones es inyectiva. **La primera dirección debe ser
nueva respecto al pasado.** Las repeticiones posteriores conservan su respuesta
y se acoplan mediante una cinta que ignora la coordenada de cada repetición.

Para cualquier evento de toda la cinta, la diferencia de probabilidades está
acotada por delta=min(1,R*(m+R+1)/2^256). Esta cota conservadora incluye el
último valor de la cinta aunque no se use como siguiente dirección. No se
condiciona a ausencia de repeticiones, SinBad, completar o aceptar.

Los índices usan el lector real leerLE(first8) mod 2^e, con e<=64. Para los
conjuntos GT y GC fijados antes de responder, la misma muestra se contrasta
con su intersección. La omisión con q índices completos tiene cota
choose(|GT inter GC|,q)/choose(2^e,q)+delta. El evento ampliado de omisión o
abandono añade tau, pagando **una sola delta**. No se multiplican probabilidades
de ambas fases ni se afirma uniformidad del selector real condicionado a completar.

La adaptación al canal de bytes construye un universo finito que contiene
pasado y todas las direcciones I, identifica la cinta real y enlaza la cota
al resultado del programa matemático que selecciona 40 índices. Con
k entre 4 y 12, M=4*2^k y R=512 se obtiene la cota estricta
hipergeométrica+2^(-300)+min(1,512*(m+513)/2^256).

Falta derivar la frescura inicial para candidatos elegidos adaptativamente,
incluidas preconsultas, y conectar las primeras exposiciones y las rondas de
retos FRI con conjuntos buenos causales. También faltan candidatos/nonces,
inclusiones y composición global de eventos, presupuestos y refinamiento
universal Rust. Una cota de selección local no es una cota de aceptación falsa.

La cadena analizada no introduce consultas adversarias nuevas durante sus R
pasos. R sigue siendo analítico: Rust conserva su bucle original y la cola de
la cinta extendida no se atribuye al registro efectivo después de completar.
El lector mantiene EOF estricto. No se declara SHA3 aleatorio concreto, QROM,
ZK ni seguridad global. Qiskit/Aer y QROM AIR/FRI siguen para futuro.

## Criterios originales y pendientes

### M26 — Aritmética de mediciones: unidades, razones y redondeos

- Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.
- Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Pendiente: Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas.

### M35 — Muestra compartida e hipergeométrica H

- Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.
- Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Pendiente: La ley conjunta del programa y sus prefijos está probada. Ahora se transfiere localmente el selector de índices real mediante un acoplamiento con error explícito, incluida omisión compartida y abandono, tras un pasado fijo y primera dirección nueva. Falta derivar esa frescura para los candidatos seleccionados y preconsultas del adversario, enlazar las primeras exposiciones y todas las rondas de retos FRI con sus conjuntos buenos causales, integrar la elección de candidatos y transferir las cotas bajo el experimento adversario completo. No se afirma uniformidad tras condicionar a SinBad, aceptación o completar; el refinamiento universal Rust permanece abierto.

### M36 — Solidez ideal por rondas y reinicios

- Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.
- Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Pendiente: Completar el adaptador integral de rondas y reinicios y obtener revisión independiente; el autor declaró que no hay dictamen. El compilador de programas finitos no identifica por sí solo los inicios B con consultas hash Q.

### M39 — Presupuestos, formas, gramática y semántica del verificador

- Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.
- Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Pendiente: El verificador matemático, lector, formas, canal y aperturas conservan su presupuesto V_T demostrado. La ley conjunta y el selector de índices tienen ahora comparación cuantitativa local con la cinta ideal, bajo primera dirección fresca. Falta refinamiento universal de serde/bincode, operaciones de máquina y ejecutable Rust; permanecen la diferencia de EOF y el corte analítico R. La hipótesis altura(programa)<=S no se identifica automáticamente con Q+V_T.

### M40 — Potencial de nonces y cola del selector

- Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.
- Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Pendiente: Construir los programas de los candidatos reales y sus conjuntos buenos con cotas fijadas antes de responder, además del trabajo/nonce y la carga global de inicios. El selector local ya tiene cota hipergeométrica compartida y error explícito cuando su primera dirección es fresca respecto al pasado fijo. Falta demostrar esa premisa para los candidatos elegidos adaptativamente y valor<=rho; un nonce ya encontrado no se convierte en una prueba independiente.

### M41 — Cota ROM completa y ejemplo numérico

- Conservar la cota parametrizada del evento excepcional del registro.
- Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.
- Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Pendiente: La ley conjunta del programa y la cota de fallo de reconstrucción causal se conservan. El selector local de índices añade transferencia cuantitativa de omisión o abandono con una única muestra y error explícito. Falta probar e instanciar las inclusiones de todos los eventos de solidez, las rondas FRI y presupuestos bajo el experimento adversario común, derivar frescura de los candidatos seleccionados, enlazar universalmente Rust y certificar el ejemplo numérico integral. La cota local no es una cota de aceptación falsa global.
