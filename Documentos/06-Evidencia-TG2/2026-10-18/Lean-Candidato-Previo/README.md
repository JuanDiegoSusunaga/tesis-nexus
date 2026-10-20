# Candidato de bytes anterior al selector

La [auditoría](validacion.json) comprueba **2233 resultados en 261 módulos**.
Esta pasada añade **34 resultados en siete módulos**. Se mantienen **34 modelos
verificados en su alcance y seis grupos parciales**, sin nuevos cierres.

## Resultado y alcance

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

## Módulos

| Módulo | Resultados | Alcance |
|---|---:|---|
| [ROM/TablaInversa](../../../../formalizacion/Nexus/ROM/TablaInversa.lean) | 4 | La búsqueda inversa usa solo pares almacenados y devuelve una entrada con la respuesta solicitada. Bajo compatibilidad y ausencia de colisiones en las entradas conocidas, recupera exactamente la preimagen registrada sin consultar H fuera de la tabla. |
| [ROM/PrefijoCorte](../../../../formalizacion/Nexus/ROM/PrefijoCorte.lean) | 3 | La tabla anterior a una primera consulta es el prefijo exacto de entradas nuevas del registro final. Las entradas cuya primera posición es menor y las dependencias por ventanas se transportan a esa tabla previa, aunque las llamadas posteriores sean repeticiones. |
| [Canal/Trayecto](../../../../formalizacion/Nexus/Canal/Trayecto.lean) | 6 | Se modela una cadena desde una entrada corta y sucesivas entradas cuyo prefijo es el estado anterior. Un extractor de tabla y semilla recupera exactamente la cadena en orden inverso con combustible suficiente; un mismo pasado y semilla determinan el mismo camino incluso para dos oráculos compatibles distintos. |
| [Canal/TrayectoTG2](../../../../formalizacion/Nexus/Canal/TrayectoTG2.lean) | 7 | El prefijo efectivo completo del canal, sus tres alfas, las dos fases FRI y la absorción del nonce forman una cadena recuperable. Tiene 12+2*(|rt|+|rc|) entradas y a lo sumo 130 para |rt|=k, |rc|=k+1 y k<=29. La semilla es la respuesta a absorber el nonce; el digest de trabajo queda separado. |
| [Canal/ReconstruccionSelector](../../../../formalizacion/Nexus/Canal/ReconstruccionSelector.lean) | 6 | Las dependencias de la cadena sitúan todas sus consultas antes del primer I de su semilla. El extractor de tabla con 130 pasos devuelve la cadena completa del canal en ese corte. Toda raíz absorbida en ella está marcada antes de la primera respuesta I y su vector Merkle coincide con el del registro final. |
| [Canal/SoporteCandidato](../../../../formalizacion/Nexus/Canal/SoporteCandidato.lean) | 3 | Una aceptación del canal ejecutado implica trabajo válido y produce la pertenencia efectiva de toda la cadena del candidato y de su primera entrada I al registro de consultas. No recibe ese soporte como hipótesis externa ni sustituye la semilla por el digest de trabajo. |
| [Verificador/CandidatoPrevio](../../../../formalizacion/Nexus/Verificador/CandidatoPrevio.lean) | 5 | La aceptación del verificador completo proporciona un registro previo con corte de primera consulta I, cadena de bytes disponible y recuperada y todos los vectores de raíces congelados. Se construye para propuesta adaptativa e intercalaciones del adversario sobre la tabla común, bajo ausencia de excepciones (SinBad). Dos candidatos registrados con la misma semilla tienen la misma tabla anterior y la misma cadena de bytes, incluso si sus perfiles o certificados se presentan como distintos. |

## Trabajo pendiente

Los [criterios originales](Revision-Alcance.md) y los 46 estados se conservan.
El autor declaró «No hay dictamen»; H1/H2 sigue sin procedencia exacta.

| Grupo parcial | Tema | Pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | Ya se obtiene desde la aceptación matemática, con propuesta adaptativa e intercalaciones, una cadena de bytes del canal recuperable antes del primer I y vectores de todas sus raíces estables. Misma semilla implica misma cadena registrada. Falta decodificar semánticamente ese candidato para definir GT/GC desde el prefijo y demostrar conservación en la unión de primeras exposiciones, derivar g/m/B, enlazar todas las rondas FRI y los eventos de solidez y el refinamiento universal Rust. Las inclusiones bajo SinBad no condicionan la ley probabilística a SinBad. |
| M36 | Solidez ideal por rondas y reinicios | El verificador con adversario ya produce el candidato de bytes en su corte de primera exposición y sus vectores congelados, además de la ley exacta de continuación y carga por direcciones distintas. Falta el adaptador integral de rondas y reinicios y la revisión independiente; el autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | La aceptación del canal y del verificador matemático ya produce el soporte efectivo de la cadena y del primer I; el extractor previo recupera los bytes del canal y congela raíces bajo ausencia de excepciones. Falta decodificación semántica del candidato para las políticas de selección, refinamiento universal de serde/bincode, operaciones de máquina y Rust y presupuestos globales. Permanecen EOF estricto y corte analítico R. |
| M40 | Potencial de nonces y cola del selector | Ya se construye el registro causal de bytes del candidato aceptado en el programa con propuesta adaptativa e intercalaciones: toda su cadena existe antes del primer I, se recupera con 130 pasos y sus raíces tienen vectores estables. Dos candidatos registrados con igual semilla comparten la misma cadena de bytes. Falta el puente de esa representación a las políticas semánticas de semilla y GT/GC, justificar sus cotas g/m/B y el valor<=rho de los candidatos completos, integrar el factor probabilístico de trabajo y la carga común de reinicios. La validez del trabajo ya se deriva de la aceptación; su digest no es la semilla y un nonce encontrado no es un ensayo independiente. |
| M41 | Cota ROM completa y ejemplo numérico | El soporte efectivo de la aceptación matemática produce ahora el candidato de bytes y los vectores de raíces antes de la primera consulta del selector, sin exigir inicialmente ese soporte. Falta definir desde ese registro los conjuntos buenos semánticos y demostrar la cobertura de toda aceptación falsa por la unión registrada de primeras exposiciones, enlazar las rondas FRI, el factor de trabajo, excepciones y presupuestos bajo un solo experimento, refinamiento universal Rust y el ejemplo numérico integral. No se ha demostrado solidez global ni una cota pequeña de Pr(preconsulta). |

## Verificación

Compilación, axiomas y 261 verificaciones del núcleo correctas con hasta
cuatro procesos, sin reutilizar replays. Los únicos axiomas permitidos siguen
siendo propext, Classical.choice y Quot.sound. Se confía en importados, sin
--fresh ni dictamen independiente. Se fijan 923 fuentes y 267 logs;
pasan 21 controles Python. Se conservan 45 etapas y 5231 logs canónicos, 16
versiones previas, 15 fuentes congeladas y 7203 archivos recuperables de la
edición anterior. Permanecen intactas 876 fuentes previas y se guardan copias
exactas de los seis archivos canónicos actualizados.

Se actualizan 36 bloques y 244 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos
y 2585 enlaces con alcance. Los conteos no son porcentajes de tesis terminada.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Integridad](integridad-candidato-previo.json).
