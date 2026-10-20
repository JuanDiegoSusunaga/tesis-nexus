# Transferencia AIR/FRI y presupuesto sin nuevos cierres

Juicio semántico del agente; no sustituye dictamen independiente. Se conservan
los 46 estados, todos los criterios y el cierre clásico finito delimitado de M37.

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

## Criterios originales y pendientes

### M26 — Aritmética de mediciones: unidades, razones y redondeos

- Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.
- Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Pendiente: Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas.

### M35 — Muestra compartida e hipergeométrica H

- Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.
- Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Pendiente: Ya se transfieren los controles GT/GC originales a la consulta compartida sobre el campo y se deriva su cardinal <=floor(7*2^e/8) bajo PrefijoSeguro del canal real. Todo exceso implica un fallo AIR/FRI explícito del mismo prefijo y Pr(Exceso)<=Pr(Rondas). Se deriva B del presupuesto Q adversario y del coste máximo del verificador. Falta acotar Pr(Rondas) con la fijación de cada vector antes de su E, las respuestas reales, sesgos y preconsultas, acotar excepciones ROM, integrar trabajo, perfiles y reinicios y refinar universalmente Rust.

### M36 — Solidez ideal por rondas y reinicios

- Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.
- Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Pendiente: Se deriva B=Q+V12(R), con V12(R)=24383+R y B=Q+24895 para R=512, desde el adversario adaptativo y el verificador matemático completo de bytes, incluidos rechazos e intercalaciones. No se recibe B como hipótesis independiente ni se identifica la altura con Q+V. La cota sigue siendo para un perfil fijo. Falta la ley causal de las rondas reales, la composición de varios perfiles, rondas y reinicios con presupuesto común y revisión independiente. El autor declaró que no hay dictamen.

### M39 — Presupuestos, formas, gramática y semántica del verificador

- Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.
- Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Pendiente: Ya están transferidos los controles de los vectores y del acarreo a AIR/FRI sobre el campo y derivado el presupuesto uniforme del lector matemático completo de bytes. Para R=512 el verificador usa como máximo 24895 llamadas entre todos los perfiles admitidos. Falta el refinamiento universal serde/bincode, operaciones de máquina y Rust. Permanecen EOF estricto y corte analítico R; el coste de varias verificaciones o reinicios necesita composición común.

### M40 — Potencial de nonces y cola del selector

- Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.
- Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Pendiente: La cota usa el umbral algebraico derivado de GT/GC originales y sustituye el exceso por un evento real clasificado de FRI de traza, cancelación AIR o FRI de composición. Se deriva B=Q+24895 para R=512 y m<=Q+24894. Falta acotar Pr(Rondas) mediante primeras exposiciones de E con los vectores ya fijados, integrar el factor de trabajo, preconsultas deliberadas, perfiles y reinicios. El trabajo no se considera independiente ni la preconsulta deliberada un error de cumpleaños.

### M41 — Cota ROM completa y ejemplo numérico

- Conservar la cota parametrizada del evento excepcional del registro.
- Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.
- Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Pendiente: Para perfil fijo y R=512 se demuestra Pr(falsa)<=Pr(no SinBad)+Pr(Rondas)+(Q+24895)*(choose(floor(7*2^(k+2)/8),40)/choose(2^(k+2),40)+2^-300+error(Digest,512,Q+24894)), bajo solo presupuesto Q adversario. El umbral y B están derivados. Falta acotar las dos probabilidades excepcionales con los retos E reales, sesgos y preconsultas, integrar trabajo, perfiles y reinicios, refinamiento universal Rust y ejemplo numérico integral. La fórmula puede ser vacua; ni la cola 2^-300 ni la cota de muestreo 1/200 implican solidez global.
