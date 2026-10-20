# Selector después de exploración adaptativa

La [auditoría](validacion.json) comprueba **2160 resultados en 248 módulos**.
Esta pasada añade **45 resultados en siete módulos**. Se conservan **34 modelos
verificados en su alcance y seis grupos parciales**, sin nuevos cierres.

## Resultado y alcance

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

## Módulos

| Módulo | Resultados | Alcance |
|---|---:|---|
| [ROM/ContinuacionPrefijo](../../../../formalizacion/Nexus/ROM/ContinuacionPrefijo.lean) | 7 | Se define el árbol residual tras n consultas, se conserva su resultado y se identifica su registro con la cola de la transcripción. El árbol residual es idéntico en todas las tablas con el mismo prefijo. La ley conjunta de resultado y cola es la evaluación con memoria iniciada en la tabla observada; cualquier observable del oráculo y del pasado se transporta a completaciones uniformes. |
| [ROM/ParticionObservada](../../../../formalizacion/Nexus/ROM/ParticionObservada.lean) | 7 | La media total es la suma de medias de fibras por sus masas exactas. Se transfieren cotas locales a una cota global y se añade explícitamente la probabilidad de una observación desfavorable, incluidas fibras vacías o de distinto cardinal. |
| [ROM/ObservacionesPrefijo](../../../../formalizacion/Nexus/ROM/ObservacionesPrefijo.lean) | 7 | Los prefijos realizables de un árbol forman una partición finita explícita. Sus fibras son exactamente tablas que producen ese pasado, con masa |Digest|^(-u) para u direcciones distintas. Se prueba esperanza total y transferencia desde cotas condicionadas a cada pasado, conservando la probabilidad de los pasados malos. |
| [ROM/SelectorPrefijo](../../../../formalizacion/Nexus/ROM/SelectorPrefijo.lean) | 5 | La semilla y GT/GC pueden ser funciones arbitrarias del prefijo observado. En cada fibra se congelan esos parámetros antes de aplicar el acoplamiento. Se transfieren omisión compartida y omisión o abandono, con la misma delta y primera dirección no preconsultada. |
| [ROM/SelectorAdaptativo](../../../../formalizacion/Nexus/ROM/SelectorAdaptativo.lean) | 7 | Se suman las cotas del selector sobre todos los pasados de una exploración adaptativa. La cota global de omisión o abandono es hipergeométrica+tau+delta+Pr(primera dirección preconsultada), bajo cotas g y m para el conjunto bueno compartido y las direcciones observadas. Para R=512 y k=4..12, tau<2^(-300). La frescura deja de ser una premisa global: su fallo aparece como un evento explícito. |
| [Canal/SelectorAdaptativo](../../../../formalizacion/Nexus/Canal/SelectorAdaptativo.lean) | 8 | Un programa anterior de bytes arbitrarios determina el prefijo de exploración. Se construye un universo finito con su soporte y todas las entradas I, se preservan prefijo y cardinal de direcciones, y se identifica la preconsulta con pertenencia de los bytes reales al pasado. Se enlaza la cota global al programa de selección de 40 índices con semilla y conjuntos elegidos del prefijo. |
| [Verificador/ContinuacionCausal](../../../../formalizacion/Nexus/Verificador/ContinuacionCausal.lean) | 4 | Se instancia la ley de continuación con el verificador completo de bytes, propuesta adaptativa e intercalaciones. Tras un prefijo efectivo, resultado y cola del registro conservan exactamente la ley del árbol residual con memoria. Las consultas restantes se acotan por altura(programa)-n. |

## Trabajo pendiente

Los [criterios originales](Revision-Alcance.md) y los 46 estados se conservan.
El autor declaró «No hay dictamen»; H1/H2 sigue sin procedencia exacta.

| Grupo parcial | Tema | Pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | La continuación tras un prefijo tiene ya su ley exacta. La semilla del selector y los conjuntos buenos pueden depender de una exploración adaptativa anterior; se obtiene una cota sobre todos los pasados, con una única muestra compartida y un término explícito Pr(primera dirección preconsultada). Falta acotar ese término para los candidatos reales y cargarlo a las excepciones del experimento común, derivar los conjuntos buenos causales y enlazar las primeras exposiciones y todas las rondas FRI. También permanece el refinamiento universal Rust. No se condiciona a SinBad, completar, aceptación ni a un futuro elegido favorablemente. |
| M36 | Solidez ideal por rondas y reinicios | El mismo verificador con propuesta adaptativa e intercalaciones ya tiene ley exacta de resultado y continuación tras un prefijo observado, y presupuesto residual altura(programa)-n. Falta el adaptador integral de rondas y reinicios y la revisión independiente; el autor declaró que no hay dictamen. No se identifica automáticamente B con consultas hash Q ni altura con Q+V_T. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | El verificador matemático conserva su presupuesto y ahora su ley exacta tras cualquier prefijo efectivo. El selector de bytes admite decisiones dependientes del pasado y contabiliza explícitamente la primera dirección preconsultada. Falta refinamiento universal de serde/bincode, operaciones de máquina y ejecutable Rust; permanecen EOF estricto y corte analítico R. Los límites de altura no se identifican automáticamente con Q+V_T. |
| M40 | Potencial de nonces y cola del selector | El selector ya admite semilla y conjuntos buenos elegidos del prefijo de una exploración adaptativa y produce una cota global con Pr(preconsulta) explícita. Falta construir los candidatos/nonces reales, fijar sus cotas g/m y valor<=rho antes de responder, acotar y cargar las preconsultas y la carga global de inicios, e incorporar el factor de trabajo y las intercalaciones del experimento común. Un nonce ya encontrado no se convierte en una prueba independiente. |
| M41 | Cota ROM completa y ejemplo numérico | Se dispone de ley de continuación del verificador completo y de cota del selector sobre todos los pasados, con omisión compartida, abandono y Pr(preconsulta) explícita. Falta acotar esta probabilidad y probar las inclusiones de todos los eventos de solidez y las rondas FRI bajo el mismo experimento de candidatos/nonces, componer los presupuestos, enlazar universalmente Rust y certificar el ejemplo numérico integral. No se ha demostrado una cota de aceptación falsa global. |

## Verificación

Compilación, axiomas y 248 verificaciones del núcleo correctas con hasta
cuatro procesos y sin reutilizar replays. Solo aparecen propext, Classical.choice
y Quot.sound. Se confía en importados, sin --fresh ni revisión independiente.
Se fijan 842 fuentes y 254 logs; pasan 21 controles Python. Se conservan
43 etapas y 4704 logs canónicos, 16 versiones previas, 15 fuentes congeladas y
6580 archivos recuperables de la edición anterior.

Se actualizan 36 bloques y 235 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos y
2135 enlaces con alcance. Estos conteos no son porcentajes de finalización.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Integridad](integridad-selector-adaptativo.json).
