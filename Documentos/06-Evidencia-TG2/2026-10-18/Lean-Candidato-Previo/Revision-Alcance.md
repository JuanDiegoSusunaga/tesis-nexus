# Reconstrucción del candidato sin nuevos cierres

Juicio semántico del agente; no sustituye dictamen independiente. Se mantienen
los 46 estados, todos los criterios y el cierre clásico finito delimitado de M37.

La aceptación del verificador matemático ya produce un candidato de bytes
disponible antes de la primera consulta I de su semilla. La propuesta puede ser
adaptativa y las consultas del adversario pueden intercalarse con el verificador
sobre la misma tabla. Se usa el origen de la dirección, aunque la llamada del
verificador sea una repetición de una preconsulta deliberada anterior.

Se define una búsqueda inversa que recorre únicamente pares almacenados: no lee
el oráculo fuera de la tabla observada. La cadena parte de la entrada corta de
inicio y enlaza estados por sus prefijos de 32 octetos. Incluye perfil, enunciado,
raíz base, tres alfas, ambas fases FRI y absorción del nonce. Su longitud exacta
es 12+2*(|rt|+|rc|); con |rt|=k, |rc|=k+1 y k<=29 se recupera con 130 pasos.
Ese límite es combustible del extractor y no el corte R del selector.

El trabajo válido se deriva separadamente de la aceptación. Su digest no es la
semilla: el canal conserva el estado y después absorbe el nonce para obtenerla.
La cadena y la primera entrada I pertenecen al registro efectivo del programa;
no se reciben como hipótesis externas de soporte en la instancia del adversario.

Bajo ausencia de excepciones (SinBad), las dependencias de ventanas sitúan toda
la cadena antes de la primera respuesta I. El extractor de esa tabla y semilla
devuelve exactamente la transcripción de bytes del canal. Dos candidatos
registrados con la misma semilla tienen la misma tabla anterior y la misma
cadena de bytes, incluso si sus perfiles o certificados se presentan distintos.
No se presupone inyectividad global del hash ni separación de dominios entre
Merkle y canal: la unicidad se obtiene sobre las entradas efectivamente conocidas.

Toda raíz absorbida en esa cadena está marcada antes del primer I. Su vector
Merkle, calculado solo con la tabla anterior, coincide con el del registro final.
Estas son inclusiones e igualdades deterministas bajo SinBad. No se reemplaza
la ley uniforme por una ley condicionada a SinBad, aceptación o futuro favorable.

Se recupera la transcripción del canal, no las aperturas futuras ni todo el
certificado. **Falta decodificar semánticamente ese candidato para definir las
políticas de semilla y GT/GC desde el prefijo y enlazarlas a la unión probabilística
de primeras exposiciones.** La igualdad de bytes no se presenta aún como un
refinamiento universal de todos los campos del certificado o del ejecutable.

La unión registrada de la etapa anterior conserva su cota rho*E[inicios]<=rho*B.
Quedan las cotas g/m/B de candidatos completos, los conjuntos buenos de todas
las rondas FRI, el factor probabilístico de trabajo, la cobertura de aceptación
falsa y la composición integral de excepciones y presupuestos. No se afirma
que Pr(preconsulta) sea pequeña ni que esté demostrada la solidez global.

R sigue siendo analítico; B no se identifica automáticamente con Q o Q+V_T.
El refinamiento universal Rust, EOF estricto frente al ejecutable, la procedencia
original de H1/H2 y el dictamen independiente siguen pendientes. Qiskit/Aer y
QROM AIR/FRI continúan para futuro. Los seis grupos parciales conservan criterios.

## Criterios originales y pendientes

### M26 — Aritmética de mediciones: unidades, razones y redondeos

- Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.
- Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Pendiente: Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas.

### M35 — Muestra compartida e hipergeométrica H

- Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.
- Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Pendiente: Ya se obtiene desde la aceptación matemática, con propuesta adaptativa e intercalaciones, una cadena de bytes del canal recuperable antes del primer I y vectores de todas sus raíces estables. Misma semilla implica misma cadena registrada. Falta decodificar semánticamente ese candidato para definir GT/GC desde el prefijo y demostrar conservación en la unión de primeras exposiciones, derivar g/m/B, enlazar todas las rondas FRI y los eventos de solidez y el refinamiento universal Rust. Las inclusiones bajo SinBad no condicionan la ley probabilística a SinBad.

### M36 — Solidez ideal por rondas y reinicios

- Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.
- Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Pendiente: El verificador con adversario ya produce el candidato de bytes en su corte de primera exposición y sus vectores congelados, además de la ley exacta de continuación y carga por direcciones distintas. Falta el adaptador integral de rondas y reinicios y la revisión independiente; el autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T.

### M39 — Presupuestos, formas, gramática y semántica del verificador

- Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.
- Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Pendiente: La aceptación del canal y del verificador matemático ya produce el soporte efectivo de la cadena y del primer I; el extractor previo recupera los bytes del canal y congela raíces bajo ausencia de excepciones. Falta decodificación semántica del candidato para las políticas de selección, refinamiento universal de serde/bincode, operaciones de máquina y Rust y presupuestos globales. Permanecen EOF estricto y corte analítico R.

### M40 — Potencial de nonces y cola del selector

- Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.
- Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Pendiente: Ya se construye el registro causal de bytes del candidato aceptado en el programa con propuesta adaptativa e intercalaciones: toda su cadena existe antes del primer I, se recupera con 130 pasos y sus raíces tienen vectores estables. Dos candidatos registrados con igual semilla comparten la misma cadena de bytes. Falta el puente de esa representación a las políticas semánticas de semilla y GT/GC, justificar sus cotas g/m/B y el valor<=rho de los candidatos completos, integrar el factor probabilístico de trabajo y la carga común de reinicios. La validez del trabajo ya se deriva de la aceptación; su digest no es la semilla y un nonce encontrado no es un ensayo independiente.

### M41 — Cota ROM completa y ejemplo numérico

- Conservar la cota parametrizada del evento excepcional del registro.
- Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.
- Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Pendiente: El soporte efectivo de la aceptación matemática produce ahora el candidato de bytes y los vectores de raíces antes de la primera consulta del selector, sin exigir inicialmente ese soporte. Falta definir desde ese registro los conjuntos buenos semánticos y demostrar la cobertura de toda aceptación falsa por la unión registrada de primeras exposiciones, enlazar las rondas FRI, el factor de trabajo, excepciones y presupuestos bajo un solo experimento, refinamiento universal Rust y el ejemplo numérico integral. No se ha demostrado solidez global ni una cota pequeña de Pr(preconsulta).
