# Selector ROM acoplado con error explícito

La [auditoría](validacion.json) comprueba **2115 resultados en 241 módulos**.
Esta pasada añade **52 resultados en siete módulos**. Se conservan **34 modelos
verificados en su alcance y seis grupos parciales**, sin nuevos cierres.

## Resultado y alcance

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

## Módulos

| Módulo | Resultados | Alcance |
|---|---:|---|
| [ROM/CintasRetos](../../../../formalizacion/Nexus/ROM/CintasRetos.lean) | 4 | Una equivalencia explícita identifica los productos recursivos de retos con vectores Fin R de respuestas y conserva la lista y la media de cualquier observable. |
| [ROM/ComparacionAcoplada](../../../../formalizacion/Nexus/ROM/ComparacionAcoplada.lean) | 9 | Si dos salidas coinciden fuera de una excepción, la diferencia absoluta de probabilidades de cualquier evento se acota por la masa de esa excepción. Se justifican indicadores, unión y paso de una cota condicional a la incondicional. |
| [ROM/RepeticionesCinta](../../../../formalizacion/Nexus/ROM/RepeticionesCinta.lean) | 5 | Se cuenta la probabilidad de que una cinta uniforme repita un estado o toque un conjunto inicial T, con recurrencia exacta y cota conservadora min(1,R*(|T|+R)/|A|). |
| [ROM/CadenaMemoria](../../../../formalizacion/Nexus/ROM/CadenaMemoria.lean) | 8 | La cadena H(codificar estado) se implementa como árbol con memoria y como muestreo sobre cinta independiente. Las repeticiones ignoran una coordenada ideal y devuelven el valor guardado. Su ley tras una tabla fija coincide con las completaciones uniformes y, fuera de las repeticiones especificadas, la salida es la cinta ideal. |
| [ROM/AcoplamientoCadena](../../../../formalizacion/Nexus/ROM/AcoplamientoCadena.lean) | 7 | Tras un pasado fijo de m direcciones, si la primera dirección es nueva y la codificación inyectiva, cualquier evento de R respuestas de la cadena ROM difiere del evento sobre una cinta independiente a lo sumo en delta=min(1,R*(m+R+1)/|A|). Se prueban comparación y transferencia sin excluir excepciones del espacio de probabilidad. |
| [ROM/SelectorAcoplado](../../../../formalizacion/Nexus/ROM/SelectorAcoplado.lean) | 9 | El índice real leerLE(first8) mod 2^e conserva la ley uniforme ideal para e<=64. Tras pasado fijo y primera dirección fresca, el selector ROM completo omite ambos conjuntos a lo sumo en choose(|GT inter GC|,q)/choose(2^e,q)+delta. El evento ampliado de omisión o abandono se acota por la misma hipergeométrica más tau y una sola delta. |
| [Canal/SelectorAcoplado](../../../../formalizacion/Nexus/Canal/SelectorAcoplado.lean) | 10 | Se construye un universo finito que contiene pasado y todas las entradas I, se demuestra la inyectividad de la codificación real y se identifica la cadena con CintaSelector. La cota se enlaza al resultado del programa matemático de selección de 40 índices. Para k entre 4 y 12 y R=512, omisión o abandono tiene cota hipergeométrica+2^(-300)+delta, con delta=min(1,512*(m+513)/2^256). |

## Trabajo pendiente

Los [criterios originales](Revision-Alcance.md) y los 46 estados se conservan.
El autor declaró «No hay dictamen»; H1/H2 sigue sin procedencia exacta.

| Grupo parcial | Tema | Pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | La ley conjunta del programa y sus prefijos está probada. Ahora se transfiere localmente el selector de índices real mediante un acoplamiento con error explícito, incluida omisión compartida y abandono, tras un pasado fijo y primera dirección nueva. Falta derivar esa frescura para los candidatos seleccionados y preconsultas del adversario, enlazar las primeras exposiciones y todas las rondas de retos FRI con sus conjuntos buenos causales, integrar la elección de candidatos y transferir las cotas bajo el experimento adversario completo. No se afirma uniformidad tras condicionar a SinBad, aceptación o completar; el refinamiento universal Rust permanece abierto. |
| M36 | Solidez ideal por rondas y reinicios | Completar el adaptador integral de rondas y reinicios y obtener revisión independiente; el autor declaró que no hay dictamen. El compilador de programas finitos no identifica por sí solo los inicios B con consultas hash Q. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | El verificador matemático, lector, formas, canal y aperturas conservan su presupuesto V_T demostrado. La ley conjunta y el selector de índices tienen ahora comparación cuantitativa local con la cinta ideal, bajo primera dirección fresca. Falta refinamiento universal de serde/bincode, operaciones de máquina y ejecutable Rust; permanecen la diferencia de EOF y el corte analítico R. La hipótesis altura(programa)<=S no se identifica automáticamente con Q+V_T. |
| M40 | Potencial de nonces y cola del selector | Construir los programas de los candidatos reales y sus conjuntos buenos con cotas fijadas antes de responder, además del trabajo/nonce y la carga global de inicios. El selector local ya tiene cota hipergeométrica compartida y error explícito cuando su primera dirección es fresca respecto al pasado fijo. Falta demostrar esa premisa para los candidatos elegidos adaptativamente y valor<=rho; un nonce ya encontrado no se convierte en una prueba independiente. |
| M41 | Cota ROM completa y ejemplo numérico | La ley conjunta del programa y la cota de fallo de reconstrucción causal se conservan. El selector local de índices añade transferencia cuantitativa de omisión o abandono con una única muestra y error explícito. Falta probar e instanciar las inclusiones de todos los eventos de solidez, las rondas FRI y presupuestos bajo el experimento adversario común, derivar frescura de los candidatos seleccionados, enlazar universalmente Rust y certificar el ejemplo numérico integral. La cota local no es una cota de aceptación falsa global. |

## Verificación

Compilación, axiomas y 241 verificaciones del núcleo correctas con hasta
cuatro procesos y sin reutilizar replays. Solo aparecen propext, Classical.choice
y Quot.sound. Se confía en importados, sin --fresh ni revisión independiente.
Se fijan 801 fuentes y 247 logs; pasan 21 controles Python. Se conservan
42 etapas y 4450 logs canónicos, 16 versiones previas, 15 fuentes congeladas y
6278 archivos recuperables de la edición anterior.

Se actualizan 36 bloques y 210 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos y
1900 enlaces con alcance. Estos conteos no son porcentajes de finalización.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Integridad](integridad-selector-acoplado.json).
