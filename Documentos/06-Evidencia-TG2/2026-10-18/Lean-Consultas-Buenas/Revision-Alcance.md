# Muestra efectiva aceptada sin nuevos cierres

Juicio semántico del agente; no sustituye dictamen independiente. Se conservan
los 46 estados, todos los criterios y el cierre clásico finito delimitado de M37.

La aceptación del verificador matemático ya implica que todos los índices
de su muestra efectiva pertenecen simultáneamente a GT y GC calculados antes de
la primera consulta I de la semilla. Se usa una única función hash compartida,
con propuesta adaptativa de bytes e intercalaciones del adversario. La instancia
final obtiene el soporte del propio programa; no lo recibe como premisa externa.

La ausencia de colisiones de las entradas conocidas se deriva del recorrido
SinBad. Toda consulta efectiva queda guardada en la tabla final. Una apertura
válida y registrada determina exactamente el valor del vector indexado extraído
de esa tabla, sin leer H fuera de ella. Se conservan sus índices, alturas y raíces.

Se prueban las igualdades de las seis posiciones AIR y todas las aperturas de
ambas fases FRI. La compatibilidad del acarreo, el plegado y el siguiente estado
dependen solo de izquierda y derecha: retirar los caminos de autenticación no
cambia esos controles una vez fijados los valores. La representación recursiva
de los vectores conserva su altura y coincide con la representación zipIdx de
la vista. El recorrido FRI aceptado satisface así los controles sobre todos los
vectores hasta la constante final.

Los segmentos de la vista se identifican con los tres alfas y los betas reales
de traza y composición, usando las cantidades del perfil admitido. Sus valores
son los entregados por el canal, sin retos elegidos aparte. Los enlaces reales
de traza/composición y la canonicidad de las seis posiciones permiten demostrar
que una misma consulta aceptada satisface ambos predicados buenos.

La muestra ordenada se define como función del selector ejecutado. Se conserva
la parada al completar cuarenta índices distintos, incluidos los duplicados
intermedios. La aceptación produce un testigo cuya muestra es exactamente esa
lista, con soporte efectivo de su continuación. Su conjunto se identifica con
la salida del selector sobre la cinta real, tras transportar 4*2^k a 2^(k+2).
La cola matemática de la cinta después de completar no se atribuye al registro.

Finalmente se obtiene la inclusión determinista: aceptación y SinBad implican
que la salida de esa cinta tiene cardinal cuarenta y está contenida en la
intersección GT/GC de la tabla anterior al primer I. Esa tabla y sus políticas
son las del origen de la dirección, aunque el verificador repita una preconsulta
deliberada. Se aplica también al certificado decodificado que propone el adversario.
No se multiplican probabilidades de las dos fases sobre la muestra compartida.

**Falta trasladar este corte de entradas nuevas al prefijo bruto de llamadas y
registrar allí las políticas para la unión probabilística de primeras
exposiciones.** También faltan las cotas g/m/B de candidatos falsos y su riesgo
local completo, las cotas de todas las rondas FRI, el factor probabilístico de
trabajo y la composición de excepciones y presupuestos bajo un solo experimento.
La inclusión no es una cota de solidez global. SinBad se usa determinísticamente;
no se condiciona la ley uniforme a SinBad, aceptación o completar la muestra.

R sigue siendo analítico; 130 es combustible del extractor. B no se identifica
automáticamente con Q ni la altura con Q+V_T. Permanecen refinamiento universal
Rust/serde/bincode, EOF estricto frente al ejecutable, procedencia original H1/H2
y dictamen independiente. El autor declaró «No hay dictamen». Qiskit/Aer y QROM
AIR/FRI siguen para futuro. Se conservan seis parciales y sus criterios.

## Criterios originales y pendientes

### M26 — Aritmética de mediciones: unidades, razones y redondeos

- Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.
- Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Pendiente: Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas.

### M35 — Muestra compartida e hipergeométrica H

- Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.
- Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Pendiente: Ya se demuestra que todas las consultas de la muestra efectiva aceptada pertenecen simultáneamente a GT/GC definidos antes del primer I. La muestra coincide con la salida real de la cinta usada en el acoplamiento, incluso con adversario adaptativo e intercalaciones. Falta trasladar el corte de entradas nuevas al prefijo bruto de llamadas y a la unión de primeras exposiciones, derivar g/m/B para candidatos falsos, integrar las cotas de todas las rondas FRI, el trabajo y las excepciones y refinar universalmente Rust. La inclusión bajo SinBad no condiciona la ley uniforme a SinBad.

### M36 — Solidez ideal por rondas y reinicios

- Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.
- Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Pendiente: La muestra ordenada efectiva ya tiene cuarenta índices distintos y soporte completo, y su aceptación implica pertenencia a GT/GC en el corte previo y coincide con la cinta real. Falta el puente al prefijo bruto y el adaptador integral de rondas y reinicios, sus presupuestos y revisión independiente. El autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T.

### M39 — Presupuestos, formas, gramática y semántica del verificador

- Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.
- Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Pendiente: El verificador matemático ya conecta sus aperturas AIR/FRI, los retos efectivos y la muestra ordenada real con los controles semánticos de GT/GC. Falta refinamiento universal de serde/bincode, operaciones de máquina y Rust y presupuestos globales. Permanecen EOF estricto y corte analítico R.

### M40 — Potencial de nonces y cola del selector

- Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.
- Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Pendiente: El candidato aceptado ya produce exactamente la muestra real de cuarenta índices distintos y todos pertenecen a GT/GC calculados antes del primer I. La muestra se identifica con la salida del selector sobre la cinta real; la cobertura vale con propuesta adaptativa e intercalaciones, sin hipótesis externa de soporte. Falta registrar estas políticas en cada primera llamada bruta y aplicar la unión probabilística, justificar g/m/B y valor<=rho de candidatos falsos, el factor de trabajo y la carga común de reinicios. La inclusión bajo SinBad es determinista.

### M41 — Cota ROM completa y ejemplo numérico

- Conservar la cota parametrizada del evento excepcional del registro.
- Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.
- Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Pendiente: Ya se demuestra aceptación implica muestra efectiva completa y pertenencia conjunta a GT/GC anteriores al primer I, con equivalencia exacta a la salida de la cinta real y soporte desde el adversario. Falta trasladar esta cobertura al prefijo bruto y a la unión de primeras exposiciones, derivar cotas de cardinal para candidatos falsos y todas las rondas FRI, factor de trabajo, composición de excepciones y presupuestos bajo un solo experimento, refinamiento universal Rust y ejemplo numérico integral. No se ha demostrado solidez global ni una cota pequeña de Pr(preconsulta).
