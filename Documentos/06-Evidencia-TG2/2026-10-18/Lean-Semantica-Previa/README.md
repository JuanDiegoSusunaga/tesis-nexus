# Semántica y conjuntos buenos anteriores al selector

La [auditoría](validacion.json) comprueba **2284 resultados en 269 módulos**.
Esta pasada añade **51 resultados en ocho módulos**. Se mantienen **34 modelos
verificados en su alcance y seis grupos parciales**, sin nuevos cierres.

## Resultado y alcance

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

## Módulos

| Módulo | Resultados | Alcance |
|---|---:|---|
| [Canal/LecturaAbsorcion](../../../../formalizacion/Nexus/Canal/LecturaAbsorcion.lean) | 9 | El lector de absorciones comprueba etiquetas, datos canónicos y recodificación completa. Recupera cada absorción codificada y todo resultado positivo corresponde a una entrada exacta. Inicio y retos cortos no se interpretan como absorciones. |
| [Canal/LecturaCadena](../../../../formalizacion/Nexus/Canal/LecturaCadena.lean) | 6 | La interpretación ordenada recupera perfil y enunciado en bytes, raíz base, ambas listas FRI, constantes finales y un nonce. Se prueba la lectura completa de la cadena efectiva del canal, descartando los retos E al extraer las absorciones. |
| [Canal/ParametrosRecuperados](../../../../formalizacion/Nexus/Canal/ParametrosRecuperados.lean) | 8 | Los codecs recuperan los seis campos del perfil y las tres cantidades del enunciado bajo sus anchos explícitos. Se validan versión, tamaños y cuarenta consultas; el exponente se obtiene de las filas mediante log2. La cadena del perfil con k<=29 y bits<u32 devuelve exactamente sus parámetros, raíces, constantes y nonce. |
| [Canal/RetosRecuperados](../../../../formalizacion/Nexus/Canal/RetosRecuperados.lean) | 7 | Las entradas de 33 bytes de la cadena efectiva son sus retos E. Sus respuestas producen, en orden y conservando repeticiones, los tres alfas y los betas de ambas fases. Una tabla que contiene la cadena obtiene la misma lista de retos, cualquiera que sea su valor de completación externa. |
| [Canal/VistaSemantica](../../../../formalizacion/Nexus/Canal/VistaSemantica.lean) | 4 | Se construye una vista solo desde tabla, semilla y digest de completación: parámetros interpretados, retos y vectores indexados de la raíz base y todas las capas. Se demuestra su conservación a partir de igualdad de retos y vectores, con reducción explícita de índices al tamaño del árbol. |
| [Verificador/SemanticaPrevia](../../../../formalizacion/Nexus/Verificador/SemanticaPrevia.lean) | 6 | El registro efectivo del candidato y la forma aceptada permiten interpretar exactamente k, bits, inicio, salida, raíces base y FRI, constantes finales y nonce antes del primer I. Se recuperan los alfas y betas reales. Dos candidatos registrados con la misma semilla tienen los mismos datos semánticos, aunque se presenten inicialmente con perfiles distintos. |
| [Verificador/VistaPrevia](../../../../formalizacion/Nexus/Verificador/VistaPrevia.lean) | 5 | Se demuestra que cada raíz de la vista procede de una absorción real, incluidos todos los elementos de ambas listas. La vista leída antes del primer I coincide exactamente con parámetros, retos y oráculos extraídos del registro final. Dos candidatos registrados con igual semilla tienen la misma vista final. |
| [Verificador/ConjuntosPrevios](../../../../formalizacion/Nexus/Verificador/ConjuntosPrevios.lean) | 6 | GT y GC quedan definidos desde tabla y semilla mediante valores extraídos, canonicidad base, enlaces de traza/composición, plegados y acarreo FRI hasta sus constantes finales. Son vacíos si falla la lectura. Se demuestra que las políticas anteriores al primer I coinciden con los conjuntos de la vista final; misma semilla produce las mismas políticas y se caracteriza la consulta compartida por su intersección. |

## Trabajo pendiente

Los [criterios originales](Revision-Alcance.md) y los 46 estados se conservan.

| Grupo parcial | Tema | Pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | Ya se interpreta el candidato recuperado y se construyen GT/GC desde la tabla anterior al primer I: parámetros, raíces, constantes, nonce, alfas/betas y todos los vectores coinciden con la vista final. Falta demostrar pertenencia de todas las consultas aceptadas a estos conjuntos, trasladar el corte de entradas nuevas al prefijo bruto de llamadas, aplicar la unión de primeras exposiciones, derivar g/m/B, enlazar las cotas de todas las rondas FRI y refinar universalmente Rust. Las igualdades bajo SinBad no condicionan la ley uniforme a SinBad. |
| M36 | Solidez ideal por rondas y reinicios | El registro efectivo ya interpreta los datos y retos reales del candidato y conserva GT/GC hasta el final, incluso ante una preconsulta deliberada. Falta el puente al prefijo bruto y el adaptador integral de rondas y reinicios, sus presupuestos y revisión independiente. El autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | La cadena anterior al primer I ya se lee con absorciones canónicas, perfil, enunciado, raíces, constantes finales y nonce; el mismo registro conserva retos y vectores. Falta refinamiento universal de serde/bincode, operaciones de máquina y Rust, completar la correspondencia de los controles semánticos con la aceptación y los presupuestos globales. Permanecen EOF estricto y corte analítico R. |
| M40 | Potencial de nonces y cola del selector | El candidato aceptado ya tiene interpretación semántica y políticas GT/GC definidas solo desde su tabla anterior y semilla, con igualdad a la vista final. Misma semilla implica mismos parámetros, raíces, constantes, nonce y políticas. Falta registrar esas políticas en cada primera llamada bruta, probar pertenencia de todas las consultas aceptadas y sus cotas g/m/B y valor<=rho, integrar el factor probabilístico de trabajo y la carga común de reinicios. La validez del trabajo se deriva de aceptación; su digest no es la semilla. |
| M41 | Cota ROM completa y ejemplo numérico | Ya existen GT/GC semánticos, leídos desde el candidato previo y conservados hasta la vista final, incluidos enlaces AIR/composición y acarreo FRI sobre valores extraídos. Falta demostrar que la aceptación implica pertenencia de todas las consultas, cubrir toda aceptación falsa con la unión de primeras exposiciones, enlazar cotas FRI, factor de trabajo, excepciones y presupuestos bajo un solo experimento, refinamiento universal Rust y ejemplo numérico integral. No se ha demostrado solidez global ni una cota pequeña de Pr(preconsulta). |

## Verificación

Compilación, axiomas y 269 verificaciones del núcleo correctas con hasta
cuatro procesos, sin reutilizar replays. Los únicos axiomas permitidos son
propext, Classical.choice y Quot.sound. Se confía en importados, sin --fresh ni
dictamen independiente. Se fijan 965 fuentes y 275 logs; pasan 21 controles
Python. Se conservan 46 etapas y 5506 logs canónicos, 16 versiones anteriores,
15 fuentes congeladas y 7525 archivos recuperables de la edición previa.
Permanecen intactas 917 fuentes auditadas previas, con copias exactas de los
seis archivos canónicos actualizados.

Se actualizan 36 bloques y 280 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos
y 2865 enlaces con alcance. Estos conteos no son porcentajes de tesis terminada.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Integridad](integridad-semantica-previa.json).
