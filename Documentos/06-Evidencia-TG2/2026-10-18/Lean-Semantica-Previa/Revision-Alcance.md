# Interpretación y políticas sin nuevos cierres

Juicio semántico del agente; no sustituye dictamen independiente. Se conservan
los 46 estados, todos los criterios y el cierre clásico finito delimitado de M37.

La cadena efectiva del candidato ya se interpreta antes de la primera
consulta I de su semilla. El lector de absorciones comprueba etiqueta, datos
canónicos y recodificación completa. La interpretación ordenada consume perfil,
enunciado, raíz base, fases FRI de traza y composición, constantes finales y
exactamente un nonce. Se demuestra su lectura sobre la cadena real; no se afirma
que cualquier lista aceptada por este lector sea una ejecución válida del canal.

Los codecs recuperan los seis campos del perfil y las tres cantidades del
enunciado. Se comprueban versión, tamaños y cuarenta consultas. Los límites
k<=29 y bits<u32 justifican los anchos de codificación; los perfiles aceptados
k=4..12 y bits=12 o 20 los satisfacen. El exponente se recupera de las filas por
log2. La interpretación proporciona k, bits, inicio, salida, raíz base, listas
de raíces FRI, constantes finales y nonce. No reconstruye aperturas posteriores.

En la cadena real, las entradas de 33 bytes son los retos E. Sus respuestas,
leídas de la tabla anterior, producen los tres alfas y todos los betas, en orden
y conservando repeticiones. La lista no depende de la completación externa de
la función de tabla. No se supone que esos retos sean independientes una vez
condicionado a la aceptación o a la ausencia de excepciones.

La vista reúne parámetros, retos y vectores indexados de la raíz base y de todas
las capas. Cada raíz se vincula a una absorción real del canal. Para el registro
causal del candidato aceptado, la vista leída de tabla y semilla antes del primer
I coincide exactamente con la vista construida sobre el registro final. Dos
candidatos registrados con igual semilla tienen los mismos datos semánticos y
la misma vista, aunque inicialmente se presenten con perfiles distintos.

GT y GC quedan definidos solo desde esa tabla y semilla. Sus pruebas usan valores
extraídos, canonicidad de las seis posiciones base, enlace de traza, composición
con los tres alfas, plegados y acarreo FRI hasta las constantes finales. Un fallo
de interpretación produce conjuntos vacíos. Se demuestra que las políticas
anteriores al primer I coinciden con los conjuntos de la vista final; misma
semilla produce las mismas políticas. La consulta compartida exige pertenecer
a su intersección, sin multiplicar probabilidades de las dos fases.

**Falta demostrar que todas las consultas aceptadas del verificador pertenecen
a estos conjuntos.** También falta trasladar el corte de entradas nuevas al
prefijo bruto de llamadas usado en la unión probabilística de primeras
exposiciones y aplicar allí esas políticas. Definir los controles y conservarlos
no proporciona aún una cota de sus cardinales ni una cota global de aceptación.

Quedan g/m/B, las cotas de todas las rondas FRI, el factor probabilístico de
trabajo, cobertura de aceptación falsa y composición integral de excepciones y
presupuestos. Las igualdades bajo SinBad son deterministas; no condicionan la
ley uniforme a ese evento ni suponen que Pr(preconsulta) sea pequeña. R sigue
siendo analítico; 130 es combustible del extractor, no R ni presupuesto global.

La equivalencia universal Rust/serde/bincode, EOF estricto frente al ejecutable,
la procedencia original H1/H2 y el dictamen independiente siguen pendientes.
El autor declaró «No hay dictamen». Qiskit/Aer y QROM AIR/FRI permanecen para
futuro. Los seis grupos parciales y sus criterios originales se conservan.

## Criterios originales y pendientes

### M26 — Aritmética de mediciones: unidades, razones y redondeos

- Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.
- Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Pendiente: Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas.

### M35 — Muestra compartida e hipergeométrica H

- Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.
- Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Pendiente: Ya se interpreta el candidato recuperado y se construyen GT/GC desde la tabla anterior al primer I: parámetros, raíces, constantes, nonce, alfas/betas y todos los vectores coinciden con la vista final. Falta demostrar pertenencia de todas las consultas aceptadas a estos conjuntos, trasladar el corte de entradas nuevas al prefijo bruto de llamadas, aplicar la unión de primeras exposiciones, derivar g/m/B, enlazar las cotas de todas las rondas FRI y refinar universalmente Rust. Las igualdades bajo SinBad no condicionan la ley uniforme a SinBad.

### M36 — Solidez ideal por rondas y reinicios

- Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.
- Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Pendiente: El registro efectivo ya interpreta los datos y retos reales del candidato y conserva GT/GC hasta el final, incluso ante una preconsulta deliberada. Falta el puente al prefijo bruto y el adaptador integral de rondas y reinicios, sus presupuestos y revisión independiente. El autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T.

### M39 — Presupuestos, formas, gramática y semántica del verificador

- Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.
- Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Pendiente: La cadena anterior al primer I ya se lee con absorciones canónicas, perfil, enunciado, raíces, constantes finales y nonce; el mismo registro conserva retos y vectores. Falta refinamiento universal de serde/bincode, operaciones de máquina y Rust, completar la correspondencia de los controles semánticos con la aceptación y los presupuestos globales. Permanecen EOF estricto y corte analítico R.

### M40 — Potencial de nonces y cola del selector

- Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.
- Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Pendiente: El candidato aceptado ya tiene interpretación semántica y políticas GT/GC definidas solo desde su tabla anterior y semilla, con igualdad a la vista final. Misma semilla implica mismos parámetros, raíces, constantes, nonce y políticas. Falta registrar esas políticas en cada primera llamada bruta, probar pertenencia de todas las consultas aceptadas y sus cotas g/m/B y valor<=rho, integrar el factor probabilístico de trabajo y la carga común de reinicios. La validez del trabajo se deriva de aceptación; su digest no es la semilla.

### M41 — Cota ROM completa y ejemplo numérico

- Conservar la cota parametrizada del evento excepcional del registro.
- Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.
- Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Pendiente: Ya existen GT/GC semánticos, leídos desde el candidato previo y conservados hasta la vista final, incluidos enlaces AIR/composición y acarreo FRI sobre valores extraídos. Falta demostrar que la aceptación implica pertenencia de todas las consultas, cubrir toda aceptación falsa con la unión de primeras exposiciones, enlazar cotas FRI, factor de trabajo, excepciones y presupuestos bajo un solo experimento, refinamiento universal Rust y ejemplo numérico integral. No se ha demostrado solidez global ni una cota pequeña de Pr(preconsulta).
