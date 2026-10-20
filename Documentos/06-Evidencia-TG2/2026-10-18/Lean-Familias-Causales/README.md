# Familias causales AIR/FRI desde la aceptación

La [auditoría](validacion.json) comprueba **2000 resultados en 227 módulos**.
Esta pasada añade **73 resultados en once módulos**, actualiza 36 bloques y
añade 190 enlaces con alcance. **M37 cierra su modelo clásico finito** con
[sus criterios originales](Revision-Alcance.md): hay 34 modelos verificados
en su alcance y seis grupos parciales. La tesis completa sigue en curso.

## Registro derivado de toda la ejecución

Los bucles del canal producen sus estados, absorciones, retos y valores
entregados sobre una H común. Su registro coincide exactamente con el
despliegue; la continuación aceptada del selector es una subsecuencia real.
Se recuperan raíz base, tres alfas, todas las raíces/betas FRI y muestra.

Una consulta aceptada registra seis aperturas AIR y dos por capa FRI. Se
derivan autenticación, posición en rango, raíz, altura y pertenencia al
registro de cada apertura. Esto se extiende a las cuarenta consultas:
40*(6+2*k+2*(k+1)) aperturas. El lector estricto y la propuesta adaptativa
de bytes se conservan, con consultas arbitrarias antes y entre las del
protocolo. No se reciben registros externos como hipótesis del cierre.

## Familias anteriores al primer reto

Bajo SinBad, cada absorción/reto efectivo produce su corte de primera
exposición, incluso si el verificador repite una consulta del adversario.
Se construyen la familia base AIR, k capas de traza y k+1 de composición.
Cada apertura coincide con el oráculo anterior al primer reto asociado.

La tabla del corte es exactamente la tabla final tomada hasta la posición
de la primera consulta del reto. El oráculo usa solo ese prefijo y su raíz:
elegir otro testigo del corte no altera la función. Las familias se capturan
como OraculosEmitidos y la lectura se prueba para todas las capas.

## Experimento muestreado y cota

El árbol finito de bytes se compila al plan ROM de respuestas frescas con
memoria. Las repeticiones reciben lo guardado sin consumir respuesta nueva.
Fuera del evento de excepción, completar la tabla final con cualquier digest
por defecto reproduce el programa original y entrega SinBad. Se aplica así
el cierre de familias al mismo experimento muestreado.

Se define el evento **aceptar sin poder reconstruir esas familias** y se
prueba que implica excepción. Su probabilidad es a lo sumo
min(1,S*(49*S+B)/2^256), con la hipótesis explícita altura(programa)<=S.
Esta cota mide fallo de reconstrucción causal. **No es la probabilidad de
aceptar un enunciado falso ni demuestra solidez integral.** No se identifica
automáticamente la altura estructural con Q+V_T del ejecutable.

Permanecen la ley conjunta de índices y primeras exposiciones, candidatos,
composición de todos los eventos y refinamiento universal Rust/Lean. No se
condiciona una distribución uniforme a SinBad ni se supone independencia
de ambas fases FRI. R sigue siendo un corte analítico ausente del bucle Rust.

## Módulos

| Módulo | Resultados | Alcance |
|---|---:|---|
| [Canal/RegistroRaices](../../../../formalizacion/Nexus/Canal/RegistroRaices.lean) | 9 | Se despliegan los estados, eventos de absorción/retos y betas de los bucles del canal. Resultados y registros coinciden con los programas; las raíces conservan orden y cantidad y cada evento está en el prefijo real, sin suponer frescura. |
| [Canal/RegistroSelector](../../../../formalizacion/Nexus/Canal/RegistroSelector.lean) | 1 | Una ejecución aceptada del selector produce cuarenta índices distintos en orden y una continuación aceptada cuyo registro es subsecuencia del efectivamente ejecutado, incluidos duplicados previos. |
| [Canal/RegistroCompleto](../../../../formalizacion/Nexus/Canal/RegistroCompleto.lean) | 8 | La transcripción del canal completo se calcula desde H: raíz base, tres alfas, ambas listas de raíces/betas y estados. Se prueba su resultado y registro exactos, la pertenencia de cada absorción/reto y el soporte de la continuación elegida al aceptar. |
| [Merkle/AperturasPrograma](../../../../formalizacion/Nexus/Merkle/AperturasPrograma.lean) | 5 | Las aperturas llevan raíz, altura, posición, valor y hermanos. Su autenticación y soporte se extraen del subprograma Merkle y se transportan al registro global; el valor coincide con el oráculo anterior al primer reto correspondiente. |
| [FRI/AperturasPrograma](../../../../formalizacion/Nexus/FRI/AperturasPrograma.lean) | 7 | Se enumeran izquierda/derecha de cada capa FRI con el estado de acarreo efectivo. La aceptación produce autenticación y soporte de todas ellas, cantidad dos por capa, rango de índices y origen en la raíz y altura de esa capa. |
| [Verificador/SoporteConsulta](../../../../formalizacion/Nexus/Verificador/SoporteConsulta.lean) | 8 | Una consulta aceptada registra exactamente seis aperturas AIR y todas las parejas FRI de traza/composición. Se compone el registro de sus subprogramas, se prueba autenticación, rango y origen de cada apertura y cantidad 6+2*k+2*(k+1). |
| [Verificador/SoporteCompleto](../../../../formalizacion/Nexus/Verificador/SoporteCompleto.lean) | 13 | La aceptación completa entrega muestra y desafíos efectivos con soporte de la continuación. Se derivan todas las absorciones/retos y las aperturas de las cuarenta consultas desde el programa, con autenticación, rango, origen y cantidad 40*(6+2*k+2*(k+1)). No se reciben registros arbitrarios como premisas. |
| [Canal/FamiliasPrograma](../../../../formalizacion/Nexus/Canal/FamiliasPrograma.lean) | 6 | Los eventos del registro global y SinBad construyen todos sus cortes de primera exposición. La tabla de cada corte es el prefijo exacto hasta la posición de la primera consulta; el oráculo depende de ese prefijo y es independiente del testigo elegido. La familia se captura como OraculosEmitidos y lee las aperturas aceptadas. |
| [Verificador/FamiliasAceptadas](../../../../formalizacion/Nexus/Verificador/FamiliasAceptadas.lean) | 6 | Desde la aceptación con propuesta adaptativa de bytes y consultas arbitrarias intercaladas se construyen la familia AIR base y todas las capas FRI de traza/composición. Cada apertura efectiva coincide con su oráculo anterior al primer reto asociado. Solo se exige SinBad y aceptación; los hechos de registro se derivan. Las familias tienen k y k+1 capas. |
| [ROM/PlanPrograma](../../../../formalizacion/Nexus/ROM/PlanPrograma.lean) | 6 | El programa finito de bytes se compila al plan de respuestas frescas y memoria: las repeticiones no consumen cuota fresca. Se obtiene la probabilidad exacta y cota adaptativa de excepciones. Sin excepción, la función de la tabla final reproduce la ejecución del programa y satisface SinBad. |
| [Verificador/ExperimentoCausal](../../../../formalizacion/Nexus/Verificador/ExperimentoCausal.lean) | 4 | En el experimento muestreado sin excepción, una aceptación produce todas las familias congeladas. El evento de aceptar sin reconstruirlas implica excepción y su probabilidad está acotada por min(1,S*(49*S+B)/2^256), bajo el presupuesto de altura declarado. |

## Matriz y comprobaciones

Los [criterios](../Familias-Causales-Antecedentes/revision-criterios.json)
se mantienen. M37 cierra solo el modelo descrito; las obligaciones de
implementación, distribución y seguridad integral siguen abiertas. Hay tres
dependencias bibliográficas, dos respaldos documentales y un trabajo futuro
QROM AIR/FRI. Qiskit SDK/Aer permanece para futuro, sin instalación.

| Grupo parcial | Tema | Pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | Ya se derivan los desafíos, raíces, muestra y registros reales del canal; el programa global se compila al muestreo fresco con memoria y se reproduce fuera de excepciones. Falta identificar la ley conjunta de primeras exposiciones e índices con la muestra ideal y transferir sus cotas sin suponer independencia después de condicionar a SinBad. El refinamiento universal Rust continúa abierto. |
| M36 | Solidez ideal por rondas y reinicios | Completar el adaptador integral de rondas y reinicios y obtener revisión independiente; el autor declaró que no hay dictamen. El compilador de programas finitos no identifica por sí solo los inicios B con consultas hash Q. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | El certificado y su lector matemático, formas, rechazos, canal y todas las aperturas ya están compuestos con presupuesto V_T demostrado. Falta refinamiento universal del parser serde/bincode, las otras operaciones de máquina y el ejecutable Rust. Se conserva la diferencia de EOF y el corte analítico R; el contraste de cincuenta casos es evidencia externa, no equivalencia universal. El adaptador matemático ahora admite propuesta adaptativa de bytes y consultas adversarias antes y entre las del verificador, conservando resultado, registros y presupuesto de hashes. Ahora se derivan los hechos de registro de todas las aperturas de las cuarenta consultas. El compilador al plan fresco conserva una hipótesis explícita de altura<=S; no se identifica automáticamente ese presupuesto con Q+V_T. |
| M40 | Potencial de nonces y cola del selector | Construir los programas de los candidatos reales y sus conjuntos buenos con cotas antes de responder, además del trabajo/nonce y la tabla global. El compilador memoriza las repeticiones, pero no demuestra valor<=rho para esos candidatos ni la carga global de inicios. |
| M41 | Cota ROM completa y ejemplo numérico | Probar las inclusiones y leyes de los tres eventos bajo un mismo experimento del ejecutable, incluyendo adversario, sesgo, selector y presupuestos completos. La gramática, programa causal y cuenta del canal son componentes; no instancian todavía la cota numérica global. Se añade la cota del evento aceptar sin poder reconstruir todas las familias causales, como subevento de excepción en el muestreo del programa. Esa cota no es la probabilidad de aceptar un enunciado falso; la unión integral de eventos y la ley conjunta siguen pendientes. |

Compilación, axiomas y 227 verificaciones del núcleo correctas, con hasta
cuatro procesos y sin reutilizar replays previos. Solo aparecen propext,
Classical.choice y Quot.sound. Se confía en importados, sin --fresh ni revisión
independiente. Se fijan 719 fuentes y 233 logs; pasan 21 controles Python.
Se conservan 40 etapas y 3963 logs canónicos, 16 versiones anteriores, 15
fuentes congeladas y los 5691 archivos recuperables de la edición previa.

Hay 212 bloques del inventario y 216 de la revisión con enlaces;
son 1462 enlaces con alcance. No representan un porcentaje de cierre.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Integridad](integridad-familias-causales.json). El autor declaró «No hay
dictamen» y H1/H2 continúa sin procedencia exacta.
