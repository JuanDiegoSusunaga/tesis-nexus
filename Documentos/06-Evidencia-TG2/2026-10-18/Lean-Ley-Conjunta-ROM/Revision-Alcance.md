# Revisión de alcance: ley conjunta sin nuevos cierres

Juicio semántico del agente, sin dictamen independiente. Los 46 estados y
todos los criterios se mantienen. Se avanza la ley conjunta matemática de
M35/M39/M40/M41, sin declarar cerrada la transferencia al selector ideal.

La ley de todo el programa con memoria está probada para cualquier observable
de resultado/transcripción, incluso si ocurren excepciones. Los prefijos
reales tienen la masa de un cilindro y la respuesta siguiente es uniforme
solo si su dirección es nueva y se condiciona a ese pasado fijo.

Permanecen altura<=S, EOF estricto, corte R analítico, candidatos reales,
inclusiones de eventos, refinamiento Rust y solidez integral. La cota de
reconstrucción anterior no se convierte en una cota de aceptación falsa.
Los modelos cerrados, incluido M37, se conservan sin cambios.

## Criterios originales y trabajo que permanece

### M26 — Aritmética de mediciones: unidades, razones y redondeos

- Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.
- Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Pendiente: Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas.

### M35 — Muestra compartida e hipergeométrica H

- Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.
- Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Pendiente: Ya se identifica exactamente la ley conjunta del programa adversario de bytes, su resultado y toda la transcripción con el plan de respuestas frescas y memoria, sin condicionar a SinBad. También se cuenta cada prefijo real y la respuesta nueva tras ese pasado. Falta acoplar las primeras exposiciones de retos e índices seleccionados con el selector uniforme ideal y transferir sus cotas, incluidos repeticiones, selección de candidatos y abandono, sin imponer independencia de ambas fases FRI ni uniformidad después de condicionar a ausencia de excepciones. El refinamiento universal Rust continúa abierto.

### M36 — Solidez ideal por rondas y reinicios

- Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.
- Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Pendiente: Completar el adaptador integral de rondas y reinicios y obtener revisión independiente; el autor declaró que no hay dictamen. El compilador de programas finitos no identifica por sí solo los inicios B con consultas hash Q.

### M39 — Presupuestos, formas, gramática y semántica del verificador

- Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.
- Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Pendiente: El verificador matemático, lector, formas, canal y aperturas conservan su presupuesto V_T demostrado. La ley del mismo plan ROM queda identificada con la tabla uniforme finita, también para su registro completo. Falta refinamiento universal de serde/bincode, operaciones de máquina y ejecutable Rust; permanecen la diferencia de EOF y el corte analítico R. La hipótesis altura(programa)<=S del muestreo no se identifica automáticamente con Q+V_T.

### M40 — Potencial de nonces y cola del selector

- Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.
- Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Pendiente: Construir los programas de los candidatos reales y sus conjuntos buenos con cotas antes de responder, además del trabajo/nonce y la carga global de inicios. La ley conjunta ya permite contar prefijos efectivos y distinguir respuestas nuevas de repetidas, pero no demuestra valor<=rho para los candidatos ni convierte un nonce ya encontrado en una prueba independiente.

### M41 — Cota ROM completa y ejemplo numérico

- Conservar la cota parametrizada del evento excepcional del registro.
- Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.
- Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Pendiente: La ley conjunta de aceptación y transcripción del programa adversario se identifica con el mismo muestreador ROM, sin excluir excepciones. La cota del fallo de reconstrucción causal se conserva. Falta probar e instanciar las inclusiones de los tres eventos de solidez, sesgos, selector y presupuestos bajo ese experimento común, enlazarlo universalmente con Rust y certificar el ejemplo numérico completo. La igualdad de leyes y la cota de reconstrucción no son una cota de aceptación falsa.
