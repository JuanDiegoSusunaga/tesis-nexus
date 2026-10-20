# Primeras exposiciones y carga de candidatos

La [auditoría](validacion.json) comprueba **2199 resultados en 254 módulos**.
Esta pasada añade **39 resultados en seis módulos**. Se mantienen **34 modelos
verificados en su alcance y seis grupos parciales**, sin nuevos cierres.

## Resultado y alcance

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

## Módulos

| Módulo | Resultados | Alcance |
|---|---:|---|
| [ROM/ActivacionPrefijo](../../../../formalizacion/Nexus/ROM/ActivacionPrefijo.lean) | 4 | La activación de un candidato depende solo del prefijo efectivo. La cota condicionada en las fibras activas se transfiere a una media global ponderada; con riesgo uniforme rho se obtiene rho por la probabilidad de activación, sin cobrar las fibras inactivas. |
| [ROM/PrimeraExposicion](../../../../formalizacion/Nexus/ROM/PrimeraExposicion.lean) | 9 | El programa residual se reconstruye exclusivamente del pasado. Activar exige que la próxima consulta sea la dirección del candidato y que aún no esté registrada. Se prueba que el índice es su primera aparición, que no hay doble carga y que toda dirección consultada tiene una primera exposición efectiva. |
| [ROM/ConteoActivaciones](../../../../formalizacion/Nexus/ROM/ConteoActivaciones.lean) | 8 | La unión finita de eventos activados se acota por rho multiplicado por el número esperado de activaciones; un presupuesto B da rho*B. Se permite cualquier solapamiento entre candidatos y se formaliza la transferencia desde un evento final cubierto por la unión. |
| [ROM/CargaPrimeras](../../../../formalizacion/Nexus/ROM/CargaPrimeras.lean) | 5 | Candidatos dependientes del índice y del pasado se inyectan en direcciones distintas de la traza por su primera posición. Su número se acota por direcciones distintas, consultas totales y horizonte. Toda dirección presente en un prefijo se remonta a una activación estrictamente anterior. |
| [ROM/SelectorPrimeras](../../../../formalizacion/Nexus/ROM/SelectorPrimeras.lean) | 7 | Se aplica el acoplamiento del selector antes de su primera consulta y se obtiene rho=choose(g,q)/choose(2^e,q)+tau+delta. La unión de candidatos registrados se acota por rho*E[inicios] y por rho*B para B direcciones distintas. Una preconsulta deliberada con omisión se remonta a su primera exposición si allí se registran la misma semilla y conjuntos que contienen el conjunto final. Para R=512 y k=4..12, tau<2^(-300). |
| [Canal/PrimerasExposiciones](../../../../formalizacion/Nexus/Canal/PrimerasExposiciones.lean) | 6 | Se identifica la activación del árbol con la próxima entrada I de bytes reales y su ausencia del prefijo. El número de activaciones se carga a las direcciones distintas del programa arbitrario de bytes. La unión de éxitos del selector matemático instrumentado, activados en primeras exposiciones, se acota por rho*B con parámetros elegidos antes de cada respuesta. |

## Trabajo pendiente

Los [criterios originales](Revision-Alcance.md) y los 46 estados se conservan.
El autor declaró «No hay dictamen»; H1/H2 sigue sin procedencia exacta.

| Grupo parcial | Tema | Pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | Se cuenta ya la unión de candidatos registrados en su primera exposición: rho*E[inicios], acotada por rho*B para B direcciones distintas; rho contiene hipergeométrica, tau y delta. Una preconsulta deliberada puede remitirse al primer intento si conserva la semilla y conjuntos allí congelados; no se afirma que Pr(preconsulta) sea pequeña. Falta construir el registro causal que cubra todos los candidatos finales reales, derivar GT/GC y g/m/B, enlazar todas las rondas FRI y sus eventos de solidez, y el refinamiento universal Rust. |
| M36 | Solidez ideal por rondas y reinicios | Se localizan primeras exposiciones en la traza y se cargan sus inicios a direcciones distintas, conservando la ley exacta de continuación del verificador. Falta el adaptador integral de rondas y reinicios y la revisión independiente; el autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | El programa arbitrario de bytes tiene un registro de primeras consultas I y una cota para la unión de éxitos del selector instrumentado. Falta la cobertura de candidatos del verificador completo, refinamiento universal de serde/bincode, operaciones de máquina y Rust, y la identificación de presupuestos globales. Permanecen EOF estricto y corte analítico R. |
| M40 | Potencial de nonces y cola del selector | La carga por primera exposición ya evita cobrar repeticiones y permite unir candidatos con una sola tabla, sin independencia. Se obtiene rho por el número esperado de inicios y una cota por direcciones distintas. Falta construir el registro causal de todos los candidatos/nonces reales, justificar la conservación de semilla y conjuntos buenos, derivar g/m/B y valor<=rho antes de responder, e incorporar el factor de trabajo y las intercalaciones del experimento común. El digest de trabajo no es la semilla del selector; un nonce encontrado no se trata como ensayo independiente. |
| M41 | Cota ROM completa y ejemplo numérico | La unión registrada de primeras exposiciones y su cota se enlazan a bytes reales. Falta demostrar que contiene toda aceptación falsa del verificador, construir los conjuntos buenos causales para las rondas FRI, integrar el factor de trabajo, presupuestos y excepciones bajo un solo experimento, refinamiento universal Rust y el ejemplo numérico integral. No se ha demostrado solidez global ni una cota pequeña para Pr(preconsulta). |

## Verificación

Compilación, axiomas y 254 verificaciones del núcleo correctas con hasta
cuatro procesos y sin reutilizar replays. Los únicos axiomas permitidos siguen
siendo propext, Classical.choice y Quot.sound. Se confía en los importados, sin
--fresh ni dictamen independiente. Se fijan 882 fuentes y 260 logs;
pasan 21 controles Python. Se conservan 44 etapas y 4964 logs canónicos, 16
versiones previas, 15 fuentes congeladas y 6889 archivos recuperables de la
edición anterior. Se mantienen intactas 836 fuentes previas y se conservan
copias exactas de los seis archivos canónicos actualizados.

Se actualizan 36 bloques y 206 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos
y 2341 enlaces con alcance. Estos conteos no representan un porcentaje de
tesis terminada. Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Integridad](integridad-primeras-exposiciones.json).
