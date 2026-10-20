# Prefijo de llamadas y cobertura por primeras exposiciones

La [auditoría](validacion.json) comprueba **2369 resultados en 285 módulos**.
Esta pasada añade **40 resultados en ocho módulos**. Se mantienen **34 modelos
verificados en su alcance y seis grupos parciales**, sin nuevos cierres.

## Resultado y alcance

Se demuestra que la tabla anterior al primer I coincide exactamente con la
tabla memorizada del prefijo bruto de llamadas. Las repeticiones cuentan como
llamadas y conservan su primera respuesta. El estado, la continuación residual,
su próxima entrada y la tabla final se relacionan con take/drop de la traza real.
Se conserva la compatibilidad y SinBad al reanudar y se construye el recorrido
causal del prefijo. Toda entrada de un corte aparece en la traza del programa.

La semilla se obtiene de la próxima entrada del programa reconstruido usando
solo respuestas pasadas. Si esa entrada es I(s), se recupera exactamente s.
La activación comprueba la igualdad de la entrada completa con I(s); leer sus
primeros 32 octetos no declara válido un mensaje arbitrario. GT y GC usan esa
semilla y la tabla normalizada del pasado, sin recibir el certificado futuro.

La aceptación del verificador matemático bajo SinBad proporciona una primera
llamada I real, con una muestra de cuarenta índices distintos contenida en
GT intersección GC de ese mismo prefijo. La propuesta adaptativa de bytes y
las intercalaciones del adversario están incluidas; el soporte procede de la
propia ejecución. Si I ya había sido consultada deliberadamente, la cobertura
se registra en su primera aparición, antes de la presentación del certificado.
No se necesita suponer pequeña la probabilidad de esa preconsulta.

La activación y la omisión coinciden con los eventos del selector instrumentado
y permiten aplicar la unión de primeras exposiciones. Para un perfil k fijado
antes del experimento, un solo espacio uniforme de funciones sobre el universo
finito del programa satisface, **bajo las hipótesis explícitas g/m/B**:

\[
\Pr[\operatorname{AceptaPerfil}_k\land\operatorname{SinBad}]
\le B\,\rho(R,k+2,40,g,m),
\]
\[
\Pr[\operatorname{AceptaPerfil}_k]
\le\Pr[\neg\operatorname{SinBad}]+B\,\rho(R,k+2,40,g,m).
\]

Aquí rho es la suma ya formalizada de la hipergeométrica, la probabilidad de
no completar cuarenta índices en R pasos y el error de acoplamiento. g debe
limitar el cardinal de GT intersección GC en **todas las activaciones**, m las
entradas distintas de cada prefijo activo y B las entradas distintas globales,
para todas las funciones del experimento. Se exigen k+2<=64, 40<=2^(k+2) y
40<=R. El horizonte se deriva de la altura finita del programa.

**Estas hipótesis todavía no están derivadas con valores pequeños y aplicables
a los candidatos falsos del protocolo.** La cota podría ser vacua; no es una
prueba de solidez global. Faltan un filtro causal de candidatos falsos y canales
válidos, cotas de cardinal y de todas las rondas FRI, factor de trabajo, unión
de perfiles y reinicios, cota de excepciones y presupuestos integrales. La
lectura semántica correcta del canal aceptado no caracteriza por sí sola toda
cadena arbitraria que el lector pueda interpretar. El reto de trabajo no
actualiza el estado y puede ser posterior a una primera I deliberada; su factor
probabilístico no se multiplica sin justificar la carga conjunta.

SinBad se usa determinísticamente y se elimina con una pérdida aditiva. La
distribución uniforme no se condiciona a SinBad, aceptación ni completar. Las
dos fases usan la misma muestra. Todos los roles comparten una sola función
hash; se conserva el solapamiento de 65 octetos entre absorciones y nodos Merkle.

R sigue siendo analítico; 130 es combustible del extractor. B no se identifica
con Q ni la altura con Q+V_T. Permanecen refinamiento universal Rust/serde/bincode,
EOF estricto frente al ejecutable, procedencia original H1/H2 y dictamen
independiente. El autor declaró «No hay dictamen». Qiskit/Aer y QROM AIR/FRI
siguen para futuro. Se conservan seis grupos parciales y todos sus criterios.

## Módulos

| Módulo | Resultados | Alcance |
|---|---:|---|
| [ROM/TablaObservada](../../../../formalizacion/Nexus/ROM/TablaObservada.lean) | 7 | La tabla se reconstruye únicamente de los pares observados, conservando la primera respuesta de una entrada repetida. Se prueban las claves exactas, ausencia de duplicados y longitud igual al número de entradas distintas del pasado, sin consultar la continuación ni una función hash fuera de ese pasado. |
| [ROM/PrefijoPrograma](../../../../formalizacion/Nexus/ROM/PrefijoPrograma.lean) | 13 | El estado tras n llamadas y la continuación residual se relacionan con take/drop de la traza real. La continuación se reconstruye usando respuestas anteriores. Su próxima entrada es la entrada n de la traza; su tabla coincide con la normalización del prefijo, incluso con repeticiones. La ejecución final, compatibilidad y ausencia de excepciones se conservan al reanudar, y existe el recorrido causal del prefijo. |
| [ROM/CorteLlamadas](../../../../formalizacion/Nexus/ROM/CorteLlamadas.lean) | 5 | Toda entrada de un corte del programa aparece en su registro de llamadas. Se localiza su primera aparición y se construye un corte causal en ese mismo instante. La tabla anterior de cualquier corte de esa dirección es exactamente la tabla normalizada del prefijo bruto anterior a la primera llamada, aunque esa llamada proceda de una preconsulta del adversario. |
| [Canal/SemillaProxima](../../../../formalizacion/Nexus/Canal/SemillaProxima.lean) | 3 | La semilla es una función del programa residual reconstruido desde el pasado: lee los primeros 32 octetos de la próxima entrada. Se demuestra que si la próxima llamada es I(s), devuelve exactamente s. La activación comprueba la igualdad de toda la entrada con I(s), sin recibir el certificado futuro como argumento de la política. |
| [Verificador/PoliticasPrefijo](../../../../formalizacion/Nexus/Verificador/PoliticasPrefijo.lean) | 3 | GT y GC se definen como políticas del prefijo bruto, con su tabla normalizada y la semilla de la próxima llamada. El registro de un candidato aceptado determina una primera activación cuya semilla y políticas coinciden exactamente con las del corte causal. El número de entradas del estado coincide con las entradas distintas del prefijo. |
| [Verificador/CoberturaPrimeras](../../../../formalizacion/Nexus/Verificador/CoberturaPrimeras.lean) | 3 | La aceptación del verificador matemático bajo SinBad implica que existe una primera llamada I en la traza completa cuya muestra real tiene cardinal cuarenta y está contenida en GT intersección GC de ese prefijo bruto. La instancia con propuesta adaptativa de bytes e intercalaciones obtiene el certificado decodificado y su soporte de la propia ejecución, incluyendo primeras exposiciones deliberadas anteriores al verificador. |
| [Canal/UnionPrefijo](../../../../formalizacion/Nexus/Canal/UnionPrefijo.lean) | 3 | La activación y la omisión con las políticas reconstruidas coinciden con los eventos instrumentados del selector finito. Se aplica la unión de primeras exposiciones a esas políticas, con cota riesgo(R,e,40,g,m) por B entradas distintas, para un perfil fijo y cotas g/m/B explícitas en todas las activaciones. |
| [Verificador/CotaAceptacion](../../../../formalizacion/Nexus/Verificador/CotaAceptacion.lean) | 3 | En un solo experimento uniforme de funciones sobre el universo finito del adversario, la aceptación con perfil k y SinBad se cubre por la unión de primeras exposiciones. Con cotas explícitas g/m/B de todas las activaciones se obtiene Pr(aceptación de perfil k y SinBad) <= riesgo(R,k+2,40,g,m)*B y, sin SinBad en el evento, Pr(aceptación de perfil k) <= Pr(no SinBad)+riesgo*B. El horizonte se deriva de la altura finita del propio programa. |

## Trabajo pendiente

Los [criterios originales](Revision-Alcance.md) y los 46 estados se conservan.

| Grupo parcial | Tema | Pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | Ya se conecta el corte antes del primer I con el prefijo bruto de llamadas y se definen desde ese pasado la semilla y GT/GC. La aceptación queda cubierta por una primera exposición real, incluyendo preconsultas deliberadas. Hay una cota por perfil fijo bajo hipótesis g/m/B para todas las activaciones y un término aditivo Pr(no SinBad). Falta derivar cotas pequeñas y aplicables para candidatos falsos, un filtro causal de canal válido, unión de perfiles, cotas FRI y trabajo, excepciones y presupuestos integrales y refinamiento universal Rust. |
| M36 | Solidez ideal por rondas y reinicios | El programa adaptativo y sus intercalaciones ya proporcionan la primera llamada bruta que cubre el selector aceptado; la tabla del corte y las políticas coinciden con las del prefijo. Se aplica la unión por perfil fijo y B entradas distintas, usando la altura finita solo como horizonte. Faltan presupuestos derivados, adaptador integral de perfiles, rondas y reinicios y revisión independiente. El autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | La aceptación matemática del certificado decodificado ya se conecta con una primera exposición de las políticas del prefijo, y con una cota por perfil fijo bajo hipótesis g/m/B y una excepción aditiva. Falta refinamiento universal de serde/bincode, operaciones de máquina y Rust y presupuestos globales. Permanecen EOF estricto y corte analítico R. |
| M40 | Potencial de nonces y cola del selector | Se completó el puente del corte al prefijo bruto: las políticas no reciben el certificado futuro y cubren la muestra real aceptada en su primera I. La unión probabilística ya se aplica por perfil fijo bajo g/m/B explícitos para todas las activaciones. Falta justificar cotas pequeñas para candidatos falsos y canales válidos, valor<=rho y su filtro causal, factor de trabajo, presupuesto común de perfiles y reinicios y composición global. No se trata la preconsulta deliberada como un error de cumpleaños. |
| M41 | Cota ROM completa y ejemplo numérico | La cobertura de la aceptación ya llega a la unión probabilística de primeras exposiciones en un solo experimento finito por perfil fijo. Bajo cotas g/m/B de todas las activaciones, se obtiene Pr(aceptación y SinBad)<=riesgo*B y Pr(aceptación)<=Pr(no SinBad)+riesgo*B. Falta derivar las hipótesis para candidatos falsos y canales válidos, reunir perfiles y reinicios, cotas de todas las rondas FRI y trabajo, cota de excepciones y presupuestos, refinamiento universal Rust y ejemplo numérico integral. No se afirma solidez global ni que g o Pr(preconsulta) sean pequeños. |

## Verificación

Compilación, axiomas y 285 verificaciones del núcleo correctas con hasta
cuatro procesos, sin reutilizar replays. Los únicos axiomas permitidos son
propext, Classical.choice y Quot.sound. Se confía en importados, sin --fresh ni
dictamen independiente. Se fijan 1049 fuentes y 291 logs; pasan 21 controles
Python. Se conservan 48 etapas y 6080 logs canónicos, 16 versiones anteriores,
15 fuentes congeladas y 8195 archivos recuperables de la edición previa.
Permanecen intactas 1001 fuentes auditadas previas, con copias exactas de los
seis archivos canónicos actualizados.

Se actualizan 36 bloques y 280 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos
y 3429 enlaces con alcance. Los conteos no son porcentajes de tesis terminada.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Integridad](integridad-prefijo-selector.json).
