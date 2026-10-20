# Ley conjunta del ROM finito con adversario

La [auditoría](validacion.json) comprueba **2063 resultados en 234 módulos**.
Esta pasada añade **63 resultados en siete módulos**, actualiza 36 bloques y
añade 228 enlaces con alcance. Se conservan **34 modelos verificados en su
alcance y seis grupos parciales**. No se declara un nuevo cierre.

## El mismo experimento para toda la ejecución

Revelar una dirección nueva particiona las tablas compatibles en fibras de
igual cardinal. Esta identidad se extiende por inducción a cualquier árbol
adaptativo, con respuestas guardadas para repeticiones. Se permite cualquier
observable del resultado y del registro completo; la continuación usa todas
las respuestas anteriores.

Del programa de bytes se deriva un soporte finito que contiene las direcciones
de todas sus ramas. Un oráculo uniforme sobre cualquier universo que lo
contenga tiene la misma ley del resultado; sus valores exteriores no influyen.
No se postula uniformidad sobre todas las funciones del dominio infinito de
bytes ni se exige poder construir el soporte eficientemente.

Se prueba que el plan ya usado para las cotas de excepciones tiene exactamente
esa ley. La tabla crece incluso cuando ocurre una excepción. Instrumentar el
programa para devolver su transcripción no cambia sus consultas, soporte,
altura ni el propio plan. Se conserva así la ley conjunta del resultado y
de **toda la transcripción del plan original**, no solo su aceptación.

El adaptador final instancia el programa completo del verificador con propuesta
adaptativa de bytes y consultas adversarias antes y entre las del protocolo.
La igualdad de leyes es incondicional respecto de excepciones. Mantiene
altura(programa)<=S; no identifica ese límite con Q+V_T del ejecutable.

## Prefijos efectivos y siguiente respuesta

Dos tablas producen el mismo prefijo ejecutado si y solo si coinciden en sus
direcciones observadas. Si hay u direcciones distintas, la masa de ese prefijo
es 1/(2^256)^u. Las repeticiones no añaden restricciones independientes.
Tras ese pasado fijo, una dirección nueva tiene respuesta uniforme de 32
bytes; una repetida está fijada. El puente del verificador usa prefijos reales
de bytes y prueba la equivalencia con el árbol finito.

**No se condiciona a SinBad, aceptación o a un nonce elegido después de ver
su resultado.** La igualdad de leyes no demuestra que el selector condicionado
sea uniforme ni que ambas fases FRI sean independientes. Falta acoplar los
retos/índices seleccionados con el selector ideal, construir candidatos y
conjuntos buenos antes de responder, y probar las inclusiones de todos los
eventos de solidez bajo el experimento común.

La cota anterior de fallo de reconstrucción de familias se conserva y sigue
siendo distinta de una cota de aceptar un enunciado falso. M37 conserva su
cierre delimitado; no se declara solidez global, ZK, SHA3 aleatorio concreto,
QROM ni refinamiento universal Rust. R sigue siendo analítico y el lector
matemático conserva EOF estricto. Qiskit/Aer y QROM AIR/FRI siguen para futuro.

## Módulos

| Módulo | Resultados | Alcance |
|---|---:|---|
| [ROM/PromediosCompletaciones](../../../../formalizacion/Nexus/ROM/PromediosCompletaciones.lean) | 4 | Revelar una dirección nueva particiona las tablas compatibles en fibras del mismo tamaño. Se prueba la igualdad de medias para cualquier observable de toda la tabla y la equivalencia con la media uniforme desde la tabla vacía. |
| [ROM/LeyArbol](../../../../formalizacion/Nexus/ROM/LeyArbol.lean) | 8 | Para cualquier árbol adaptativo finito, la media de una función de su resultado sobre tablas uniformes coincide con la evaluación que sortea solo respuestas nuevas y memoriza las repetidas. Se conserva la ley conjunta de resultado y transcripción completa; el valor inicial en direcciones no vistas es inmaterial. |
| [ROM/SoporteFinito](../../../../formalizacion/Nexus/ROM/SoporteFinito.lean) | 15 | Se deriva del programa de bytes el soporte de todas sus ramas adaptativas. Restringir a un universo que lo contenga conserva resultado y registro. La ley del resultado es la del árbol con memoria y no depende de ampliar el universo finito. |
| [ROM/LeyMuestreoPrograma](../../../../formalizacion/Nexus/ROM/LeyMuestreoPrograma.lean) | 7 | La tabla del plan crece por prefijos incluso si hay excepciones. Para cualquier observable del resultado, el mismo plan ROM de respuestas frescas tiene exactamente la ley de una función uniforme en el soporte del programa. Las repeticiones guardan su valor sin gastar respuesta fresca. |
| [ROM/ProgramaObservado](../../../../formalizacion/Nexus/ROM/ProgramaObservado.lean) | 11 | Instrumentar el programa para devolver resultado y transcripción conserva consultas, altura, soporte y el propio plan de muestreo. Se obtiene igualdad exacta de la ley conjunta de resultado y registro del plan original con el ROM uniforme finito. |
| [ROM/PrefijosGlobales](../../../../formalizacion/Nexus/ROM/PrefijosGlobales.lean) | 9 | El evento de igualdad de prefijos efectivos es exactamente el cilindro de sus direcciones observadas. Se cuenta su masa como |Digest|^(-u), con u direcciones distintas; una respuesta nueva es uniforme tras ese pasado fijo y una repetida distinta es imposible. |
| [Verificador/LeyConjunta](../../../../formalizacion/Nexus/Verificador/LeyConjunta.lean) | 9 | Se instancia la ley conjunta con el programa completo de propuesta adaptativa de bytes e intercalaciones arbitrarias. Resultado y transcripción del mismo muestreador tienen exactamente la ley de tablas uniformes en su soporte. Se prueba la masa de cada prefijo real y la respuesta fresca uniforme tras ese pasado. |

## Matriz conservada

Los [criterios originales](Revision-Alcance.md) y los 46 estados se conservan:
34 modelos verificados en su alcance, seis parciales, tres dependencias
bibliográficas, dos respaldos documentales y un trabajo futuro QROM AIR/FRI.
El autor declaró «No hay dictamen»; H1/H2 sigue sin procedencia exacta.

| Grupo parcial | Tema | Pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | Ya se identifica exactamente la ley conjunta del programa adversario de bytes, su resultado y toda la transcripción con el plan de respuestas frescas y memoria, sin condicionar a SinBad. También se cuenta cada prefijo real y la respuesta nueva tras ese pasado. Falta acoplar las primeras exposiciones de retos e índices seleccionados con el selector uniforme ideal y transferir sus cotas, incluidos repeticiones, selección de candidatos y abandono, sin imponer independencia de ambas fases FRI ni uniformidad después de condicionar a ausencia de excepciones. El refinamiento universal Rust continúa abierto. |
| M36 | Solidez ideal por rondas y reinicios | Completar el adaptador integral de rondas y reinicios y obtener revisión independiente; el autor declaró que no hay dictamen. El compilador de programas finitos no identifica por sí solo los inicios B con consultas hash Q. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | El verificador matemático, lector, formas, canal y aperturas conservan su presupuesto V_T demostrado. La ley del mismo plan ROM queda identificada con la tabla uniforme finita, también para su registro completo. Falta refinamiento universal de serde/bincode, operaciones de máquina y ejecutable Rust; permanecen la diferencia de EOF y el corte analítico R. La hipótesis altura(programa)<=S del muestreo no se identifica automáticamente con Q+V_T. |
| M40 | Potencial de nonces y cola del selector | Construir los programas de los candidatos reales y sus conjuntos buenos con cotas antes de responder, además del trabajo/nonce y la carga global de inicios. La ley conjunta ya permite contar prefijos efectivos y distinguir respuestas nuevas de repetidas, pero no demuestra valor<=rho para los candidatos ni convierte un nonce ya encontrado en una prueba independiente. |
| M41 | Cota ROM completa y ejemplo numérico | La ley conjunta de aceptación y transcripción del programa adversario se identifica con el mismo muestreador ROM, sin excluir excepciones. La cota del fallo de reconstrucción causal se conserva. Falta probar e instanciar las inclusiones de los tres eventos de solidez, sesgos, selector y presupuestos bajo ese experimento común, enlazarlo universalmente con Rust y certificar el ejemplo numérico completo. La igualdad de leyes y la cota de reconstrucción no son una cota de aceptación falsa. |

## Comprobaciones

Compilación, axiomas y 234 verificaciones del núcleo correctas, con hasta
cuatro procesos y sin reutilizar replays. Solo aparecen propext, Classical.choice
y Quot.sound. Se confía en importados, sin --fresh ni revisión independiente.
Se fijan 760 fuentes y 240 logs; pasan 21 controles Python. Se conservan
41 etapas y 4203 logs canónicos, 16 versiones anteriores, 15 fuentes congeladas
y los 5983 archivos recuperables de la edición previa.

Hay 212 bloques del inventario y 216 de la revisión enlazados;
son 1690 enlaces con alcance, sin interpretar esos conteos como porcentajes.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Integridad](integridad-ley-conjunta.json).
