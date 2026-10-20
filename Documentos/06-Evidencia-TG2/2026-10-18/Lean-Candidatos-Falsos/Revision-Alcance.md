# Filtro causal y aceptación falsa sin nuevos cierres

Juicio semántico del agente; no sustituye dictamen independiente. Se conservan
los 46 estados, todos los criterios y el cierre clásico finito delimitado de M37.

Se define un filtro de canal canónico y falsedad algebraica usando únicamente
la tabla y la semilla del prefijo anterior al primer I. La falsedad es la
negación de EnunciadoValido: no existe un polinomio AIR de grado menor que 2^k
que satisfaga el enunciado. Se prueba su equivalencia con la premisa universal
de falsedad que ya utilizan los lemas algebraicos AIR/FRI.

La lectura de parámetros se contrasta con un programa que reejecuta el canal
completo hasta la absorción del nonce: origen, perfil, enunciado, raíz, tres
alfas, ambas fases FRI, constantes y nonce. Sus entradas son exactamente la
cadena canónica y su resultado es la semilla. Dos funciones que coinciden
en las consultas observadas producen la misma traza y salida; por eso la
reejecución sobre la función completada desde la tabla no lee valores de H
fuera de las entradas conocidas de esa cadena.

El filtro exige perfil admitido, igualdad de toda la cadena recuperada con
esa reejecución, semilla exacta y almacenamiento de cada consulta. Se prueban
relectura exacta de parámetros y recuperación de los retos E canónicos. Una
cadena arbitraria interpretada por el lector no se declara canónica por ese
solo hecho. Un enunciado válido queda excluido del filtro. La aceptación
falsa con adversario adaptativo e intercalaciones proporciona una primera I
elegible; la muestra real sigue cubierta aunque I fuera una preconsulta.

GT/GC se vacían fuera del filtro y cuando el cardinal de su intersección
original supera g. Su intersección filtrada tiene cardinal como máximo g
en todas las ramas, sin una hipótesis externa de cardinal. Se conserva el
evento Exceso: existe una primera I elegible del programa cuyo cardinal
original supera g. **Ese evento no se descarta ni se supone improbable.**

Si toda ejecución tiene como máximo B entradas distintas, el prefijo anterior
a una consulta fresca tiene como máximo B-1: la entrada siguiente pertenece
al registro completo y está ausente del pasado. Se deriva por tanto m<=B-1,
incluida la tabla del estado, sin una hipótesis separada sobre m. El presupuesto
global B todavía es una hipótesis uniforme sobre las funciones del experimento.
También se demuestra que el total está acotado por la altura del programa.

Para un perfil k y un umbral g fijados antes del experimento y un solo espacio
uniforme finito de funciones, se demuestra:

\[
\Pr[\operatorname{AceptaFalsa}_k]
\le\Pr[\neg\operatorname{SinBad}]+\Pr[\operatorname{Exceso}_g]
  +B\,\rho(R,k+2,40,g,B-1).
\]

La única hipótesis externa de coste es el presupuesto global B. Las condiciones
del selector son k+2<=64, 40<=2^(k+2) y 40<=R. rho conserva la hipergeométrica,
la probabilidad de no completar cuarenta índices en R pasos y el error de
acoplamiento. Para R=512 y 4<=k<=12 se obtiene además:

\[
\Pr[\operatorname{AceptaFalsa}_k]
\le\Pr[\neg\operatorname{SinBad}]+\Pr[\operatorname{Exceso}_g]
 +B\left(\frac{\binom{g}{40}}{\binom{2^{k+2}}{40}}
  +2^{-300}+\operatorname{error}(\mathrm{Digest},512,B-1)\right).
\]

**La fórmula podría ser vacua y no demuestra todavía solidez global.** Falta
acotar Pr(Exceso) con los argumentos AIR/FRI y sus retos reales, acotar las
excepciones ROM, derivar B del adversario y del verificador, integrar trabajo,
perfiles y reinicios y dar un ejemplo numérico integral. La cola 2^-300 no es
por sí sola una garantía de seguridad. El filtro es una proposición matemática
del pasado; no se afirma que sea un algoritmo eficiente del ejecutable.

Las medias son incondicionales: no se condiciona a SinBad, aceptación, completar
ni ausencia de exceso. Las dos fases usan la misma muestra. Todos los roles
comparten una función hash y se conserva su solapamiento de 65 octetos. El
trabajo no actualiza el estado y puede consultarse después de una primera I
deliberada, por lo que su factor necesita una justificación conjunta.

R sigue siendo analítico; 130 es combustible del extractor. B no se identifica
con Q ni la altura con Q+V_T. Permanecen refinamiento universal Rust/serde/bincode,
EOF estricto frente al ejecutable, procedencia original H1/H2 y dictamen.
El autor declaró «No hay dictamen». Qiskit/Aer y QROM AIR/FRI siguen para futuro.
Se conservan seis grupos parciales y todos sus criterios.

## Criterios originales y pendientes

### M26 — Aritmética de mediciones: unidades, razones y redondeos

- Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.
- Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Pendiente: Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas.

### M35 — Muestra compartida e hipergeométrica H

- Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.
- Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Pendiente: La aceptación falsa ya está cubierta por políticas del pasado que exigen canal canónico, falsedad algebraica y cardinal <=g. Se deriva m<=B-1 del presupuesto global B y se obtiene Pr(falsa)<=Pr(no SinBad)+Pr(Exceso)+riesgo*B, sin hipótesis global g/m sobre las políticas originales. Falta acotar Exceso con los argumentos AIR/FRI y sus retos reales, las excepciones y B, integrar trabajo, perfiles y reinicios y refinar universalmente Rust. No se ha demostrado que el exceso sea improbable.

### M36 — Solidez ideal por rondas y reinicios

- Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.
- Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Pendiente: Ya hay filtro causal de canal canónico falso y cobertura de la aceptación falsa desde el adversario. El pasado de una primera I usa a lo sumo B-1 entradas distintas si el total usa a lo sumo B; se elimina m como hipótesis separada. Falta derivar el presupuesto global B del adversario y del verificador, integrar perfiles, rondas y reinicios y revisión independiente. El autor declaró que no hay dictamen; no se identifica B con Q ni altura con Q+V_T.

### M39 — Presupuestos, formas, gramática y semántica del verificador

- Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.
- Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Pendiente: La reejecución del canal previo usa exactamente sus consultas conocidas y produce cadena y semilla canónicas; el filtro distingue esa propiedad de la simple lectura de parámetros. La aceptación falsa del lector matemático ya se cubre por ese filtro y por una cota con excepciones explícitas. Falta refinamiento universal serde/bincode, operaciones de máquina y Rust y presupuestos globales. Permanecen EOF estricto y corte analítico R.

### M40 — Potencial de nonces y cola del selector

- Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.
- Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Pendiente: La fórmula ya distingue aceptación falsa, excepción ROM y exceso del cardinal original de GT/GC. El filtro causal y su cardinal universal están demostrados y m<=B-1 se deriva. Para R=512 la cola del selector se acota por 2^-300. Falta acotar Pr(Exceso) con los eventos AIR/FRI sobre primeras exposiciones reales, el factor de trabajo y el presupuesto común de perfiles y reinicios. No se descarta el exceso ni se trata la preconsulta deliberada como un error de cumpleaños.

### M41 — Cota ROM completa y ejemplo numérico

- Conservar la cota parametrizada del evento excepcional del registro.
- Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.
- Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Pendiente: Para un perfil fijo ya se demuestra Pr(falsa)<=Pr(no SinBad)+Pr(Exceso)+riesgo(R,k+2,40,g,B-1)*B, bajo presupuesto global B. Se derivan filtro de canal canónico falso, cota g de las políticas filtradas y m<=B-1. Falta acotar el exceso y las excepciones, derivar B, transferir las rondas AIR/FRI reales, integrar trabajo, perfiles y reinicios, refinamiento universal Rust y ejemplo numérico integral. La fórmula podría ser vacua y la cola 2^-300 no constituye solidez global.
