# AIR/FRI de los vectores reales y presupuesto global

La [auditoría](validacion.json) comprueba **2469 resultados en 304 módulos**.
Esta pasada añade **55 resultados en once módulos**. Se mantienen **34 modelos
verificados en su alcance y seis grupos parciales**, sin nuevos cierres.

## Resultado y alcance

Se conectan los conjuntos buenos GT/GC originales, definidos desde la tabla
anterior a la primera I, con los oráculos concretos sobre los dominios Goldilocks.
La extensión de cada vector recupera exactamente los valores en sus índices y
la conversión de una muestra conserva su cardinal. Se identifican las seis
posiciones AIR con las dos mitades y las tres rotaciones algebraicas.

Del recorrido de acarreo se derivan las ecuaciones de plegado entre capas,
incluida la transición a la constante terminal. No se reciben esas ecuaciones
como hipótesis. Cada pareja buena de la vista satisface ambas verificaciones
FRI, los seis controles de campo base y el enlace local de composición. Este
último usa la inmersión de Fp en Fp2 y la ausencia probada de polos. Ambas fases
usan la misma muestra; no se multiplican probabilidades independientes.

La cota existente de una consulta compartida unitaria permite demostrar para
el conjunto completo de parejas aceptantes, bajo PrefijoSeguro:

\[
8|G_T\cap G_C|\le 7\,2^e,\qquad
g(e)=\left\lfloor\frac{7\,2^e}{8}\right\rfloor.
\]

Es una cota de los conjuntos originales, sin filtrarlos por cardinal para
obtenerla. Para e=k+2 y k>=1, g=7*2^(k-1); en los extremos admitidos vale
56 y 14336. Si el exponente no coincide con el perfil leído, el conjunto
está vacío. La forma de la vista y su vector base se derivan del canal canónico.

Todo exceso de ese umbral en una primera I elegible implica un fallo AIR/FRI
del mismo prefijo real. Se clasifica exactamente en: reto excepcional de FRI
de traza lejana, cancelación del resto AIR o reto excepcional de FRI de
composición lejana. La rama con candidato fuera del campo base no produce
este fallo. Se demuestra la inclusión de eventos y Pr(Exceso)<=Pr(Rondas).

**Pr(Rondas) todavía no está acotada.** El prefijo construido usa los retos y
vectores de la tabla real anterior a I, pero esto no demuestra que cada vector
estuviera ya fijado antes de su propio E. Sus funciones ignoran la historia
porque la vista ya está fijada antes de I; no se las trata como una política
causal válida antes de cada E ni se les atribuye la ley del experimento ideal.
Faltan esa previsibilidad, la transferencia de respuestas hash, sus sesgos y
el tratamiento de las preconsultas deliberadas.

También se deriva el presupuesto uniforme del verificador matemático completo
de bytes, incluyendo propuestas malformadas, rechazos y todos los perfiles
admitidos. Q cuenta todas las llamadas adversarias, tanto de la propuesta
como de las intercalaciones. Se demuestra:

\[
V_{12}(R)=24383+R,\qquad B=Q+V_{12}(R).
\]

Por tanto para R=512 se obtiene B=Q+24895 y el pasado de una dirección fresca
tiene como máximo Q+24894 entradas distintas. B ya no se recibe como hipótesis
de coste separada. La altura del programa no se identifica con Q+V ni B con Q.
El coste es del modelo con corte analítico R; no del bucle Rust sin ese corte.

Para un perfil k fijo antes del experimento, con 4<=k<=12, se integra:

\[
\Pr[\operatorname{AceptaFalsa}_k]\le
\Pr[\neg\operatorname{SinBad}]+\Pr[\operatorname{Rondas}]
+(Q+24895)\left(
\frac{\binom{g(k+2)}{40}}{\binom{2^{k+2}}{40}}
+2^{-300}+\operatorname{error}(\mathrm{Digest},512,Q+24894)\right).
\]

Se demuestra además que la hipergeométrica es como máximo (7/8)^40 y que
esta cantidad es <=1/200. **La fórmula puede ser vacua.** Ni 2^-300 ni 1/200
constituyen por sí solos solidez global. Las dos probabilidades excepcionales
permanecen explícitas, junto con el error de acoplamiento.

Las probabilidades son medias incondicionales en un solo experimento finito.
No se condiciona a SinBad, aceptación ni ausencia de exceso. Todos los roles
comparten la misma función hash y conservan el solapamiento de 65 octetos.
El trabajo no actualiza el estado y puede ocurrir después de una primera I
deliberada; no se introduce un factor independiente de trabajo.

Quedan acotar las excepciones ROM y las rondas reales, integrar trabajo,
selección de perfiles y reinicios con presupuesto común y certificar un ejemplo
numérico integral. Permanecen refinamiento universal Rust/serde/bincode y
operaciones de máquina, EOF estricto frente al ejecutable, procedencia H1/H2
y dictamen. El autor declaró «No hay dictamen». Qiskit/Aer y QROM AIR/FRI
siguen para futuro. Se conservan seis grupos parciales y todos sus criterios.

## Módulos

| Módulo | Resultados | Alcance |
|---|---:|---|
| [Canal/VectoresCampo](../../../../formalizacion/Nexus/Canal/VectoresCampo.lean) | 7 | La extensión de un vector indexado a los dominios Goldilocks recupera cada valor y es cero fuera del dominio. Se identifica con el oráculo Merkle extraído de la tabla. La imagen de una muestra conserva exactamente su cardinal y pertenece al dominio cuadrado; se identifican las seis posiciones AIR con los índices algebraicos de ambas mitades. |
| [FRI/ControlesCampo](../../../../formalizacion/Nexus/FRI/ControlesCampo.lean) | 4 | Se derivan la igualdad de longitudes, el valor del oráculo desde la compatibilidad del acarreo y la fórmula del plegado sobre el campo. Por inducción sobre las listas se extraen todas las ecuaciones FRI del recorrido concreto, incluida la compatibilidad con el siguiente vector o con la constante terminal, sin recibir esas ecuaciones como hipótesis. |
| [FRI/ListaCampo](../../../../formalizacion/Nexus/FRI/ListaCampo.lean) | 5 | Las listas de vectores se elevan a oráculos de las capas y se completan con la constante final. Los controles del acarreo implican la aceptación FRI de una pareja concreta y de toda una muestra de esas parejas, con los retos leídos de las mismas listas. |
| [Canal/VistaCampo](../../../../formalizacion/Nexus/Canal/VistaCampo.lean) | 7 | Se construye un PrefijoConsulta AIR/FRI con los vectores, retos y constantes de la vista anterior a I. La traza inicial coincide con el vector base. La forma y la lectura exacta se derivan para todo canal canónico admisible desde su propia tabla, sin suponerlas para el certificado futuro. |
| [Verificador/ConsultaCampo](../../../../formalizacion/Nexus/Verificador/ConsultaCampo.lean) | 7 | Cada pareja que pertenece a GT y GC originales satisface AceptaCompartida del prefijo construido: ambas verificaciones FRI, los seis controles de campo base y el enlace local de composición. El enlace usa las posiciones reales, la inmersión Fp a Fp2 y la ausencia probada de polos en el dominio concreto. La misma muestra se comparte entre las dos fases. |
| [N06/CardinalCompartida](../../../../formalizacion/Nexus/N06/CardinalCompartida.lean) | 3 | Se demuestra la fórmula exacta de la probabilidad de una consulta unitaria y se usa la cota AIR/FRI compartida existente para deducir 8*cardinal<=7*(4*2^k) para todas las parejas aceptantes y cualquier subconjunto de ellas, cuando el prefijo es seguro. |
| [Verificador/CardinalVista](../../../../formalizacion/Nexus/Verificador/CardinalVista.lean) | 4 | Se deriva para GT/GC originales, sin filtrarlos por cardinal, el límite floor(7*2^e/8) bajo PrefijoSeguro del canal concreto admisible. Si el exponente no coincide, los conjuntos están vacíos. Para un perfil k se identifica el umbral con 7*2^(k-1); los extremos son 56 y 14336 parejas buenas. |
| [Verificador/ExcesoRondas](../../../../formalizacion/Nexus/Verificador/ExcesoRondas.lean) | 4 | Todo exceso del umbral algebraico en una primera I elegible implica una excepción de rondas del mismo canal canónico falso, reconstruido desde la tabla y los retos reales del prefijo. Se prueba la inclusión de eventos y de sus probabilidades incondicionales. La cota de aceptación falsa sustituye Pr(Exceso) por Pr(Rondas), con umbral ya derivado. |
| [Verificador/PresupuestoGlobal](../../../../formalizacion/Nexus/Verificador/PresupuestoGlobal.lean) | 7 | Se prueba el coste máximo entre todos los perfiles admitidos y la cota uniforme del lector de bytes completo, incluyendo propuestas malformadas y rechazos. Del presupuesto Q de todas las consultas adversarias, incluidas propuesta e intercalaciones, se deriva el total de llamadas y de entradas distintas B=Q+V12(R). Se demuestra V12(R)=24383+R y, para R=512, B=Q+24895. La cota de aceptación falsa usa solo la hipótesis adversaria Q, sin recibir B como hipótesis separada. |
| [Verificador/RondasReales](../../../../formalizacion/Nexus/Verificador/RondasReales.lean) | 4 | La excepción de cada vista concreta se clasifica exactamente: FRI de traza lejana, cancelación del resto AIR o FRI de composición lejana. Los conjuntos excepcionales FRI usan los mismos oráculos y betas del prefijo leído. La rama con candidato fuera del campo base no genera una excepción de este tipo. |
| [Verificador/CotaRondas](../../../../formalizacion/Nexus/Verificador/CotaRondas.lean) | 3 | Se integra para un perfil fijo la cota con Pr(no SinBad), Pr(Rondas), el umbral algebraico y B=Q+24895 para R=512, con pasado de a lo sumo Q+24894 entradas distintas. Se conservan la hipergeométrica, la cola 2^-300 y el error de acoplamiento. La hipergeométrica se acota por (7/8)^40 y esta cantidad por 1/200. |

## Trabajo pendiente

Los [criterios originales](Revision-Alcance.md) y los 46 estados se conservan.

| Grupo parcial | Tema | Pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | Ya se transfieren los controles GT/GC originales a la consulta compartida sobre el campo y se deriva su cardinal <=floor(7*2^e/8) bajo PrefijoSeguro del canal real. Todo exceso implica un fallo AIR/FRI explícito del mismo prefijo y Pr(Exceso)<=Pr(Rondas). Se deriva B del presupuesto Q adversario y del coste máximo del verificador. Falta acotar Pr(Rondas) con la fijación de cada vector antes de su E, las respuestas reales, sesgos y preconsultas, acotar excepciones ROM, integrar trabajo, perfiles y reinicios y refinar universalmente Rust. |
| M36 | Solidez ideal por rondas y reinicios | Se deriva B=Q+V12(R), con V12(R)=24383+R y B=Q+24895 para R=512, desde el adversario adaptativo y el verificador matemático completo de bytes, incluidos rechazos e intercalaciones. No se recibe B como hipótesis independiente ni se identifica la altura con Q+V. La cota sigue siendo para un perfil fijo. Falta la ley causal de las rondas reales, la composición de varios perfiles, rondas y reinicios con presupuesto común y revisión independiente. El autor declaró que no hay dictamen. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | Ya están transferidos los controles de los vectores y del acarreo a AIR/FRI sobre el campo y derivado el presupuesto uniforme del lector matemático completo de bytes. Para R=512 el verificador usa como máximo 24895 llamadas entre todos los perfiles admitidos. Falta el refinamiento universal serde/bincode, operaciones de máquina y Rust. Permanecen EOF estricto y corte analítico R; el coste de varias verificaciones o reinicios necesita composición común. |
| M40 | Potencial de nonces y cola del selector | La cota usa el umbral algebraico derivado de GT/GC originales y sustituye el exceso por un evento real clasificado de FRI de traza, cancelación AIR o FRI de composición. Se deriva B=Q+24895 para R=512 y m<=Q+24894. Falta acotar Pr(Rondas) mediante primeras exposiciones de E con los vectores ya fijados, integrar el factor de trabajo, preconsultas deliberadas, perfiles y reinicios. El trabajo no se considera independiente ni la preconsulta deliberada un error de cumpleaños. |
| M41 | Cota ROM completa y ejemplo numérico | Para perfil fijo y R=512 se demuestra Pr(falsa)<=Pr(no SinBad)+Pr(Rondas)+(Q+24895)*(choose(floor(7*2^(k+2)/8),40)/choose(2^(k+2),40)+2^-300+error(Digest,512,Q+24894)), bajo solo presupuesto Q adversario. El umbral y B están derivados. Falta acotar las dos probabilidades excepcionales con los retos E reales, sesgos y preconsultas, integrar trabajo, perfiles y reinicios, refinamiento universal Rust y ejemplo numérico integral. La fórmula puede ser vacua; ni la cola 2^-300 ni la cota de muestreo 1/200 implican solidez global. |

## Verificación

Compilación, axiomas y 304 verificaciones del núcleo correctas con hasta
cuatro procesos, sin reutilizar replays. Se permiten únicamente propext,
Classical.choice y Quot.sound. Se confía en importados, sin --fresh ni dictamen
independiente. Se fijan 1136 fuentes y 310 logs; pasan 21 controles Python.
Se conservan 50 etapas y 6689 logs canónicos, 16 versiones anteriores, 15 fuentes
congeladas y 8897 archivos recuperables de la edición previa. Permanecen intactas
1085 fuentes auditadas previas, con copias exactas de seis archivos canónicos.

Se actualizan 36 bloques y 396 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos y
4107 enlaces con alcance. Los conteos no son porcentajes de tesis terminada.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Integridad](integridad-air-fri-real.json).
