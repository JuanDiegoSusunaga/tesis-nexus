# Prefijo efectivo y cota por perfil sin nuevos cierres

Juicio semántico del agente; no sustituye dictamen independiente. Se conservan
los 46 estados, todos los criterios y el cierre clásico finito delimitado de M37.

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

## Criterios originales y pendientes

### M26 — Aritmética de mediciones: unidades, razones y redondeos

- Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.
- Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Pendiente: Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas.

### M35 — Muestra compartida e hipergeométrica H

- Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.
- Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Pendiente: Ya se conecta el corte antes del primer I con el prefijo bruto de llamadas y se definen desde ese pasado la semilla y GT/GC. La aceptación queda cubierta por una primera exposición real, incluyendo preconsultas deliberadas. Hay una cota por perfil fijo bajo hipótesis g/m/B para todas las activaciones y un término aditivo Pr(no SinBad). Falta derivar cotas pequeñas y aplicables para candidatos falsos, un filtro causal de canal válido, unión de perfiles, cotas FRI y trabajo, excepciones y presupuestos integrales y refinamiento universal Rust.

### M36 — Solidez ideal por rondas y reinicios

- Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.
- Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Pendiente: El programa adaptativo y sus intercalaciones ya proporcionan la primera llamada bruta que cubre el selector aceptado; la tabla del corte y las políticas coinciden con las del prefijo. Se aplica la unión por perfil fijo y B entradas distintas, usando la altura finita solo como horizonte. Faltan presupuestos derivados, adaptador integral de perfiles, rondas y reinicios y revisión independiente. El autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T.

### M39 — Presupuestos, formas, gramática y semántica del verificador

- Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.
- Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Pendiente: La aceptación matemática del certificado decodificado ya se conecta con una primera exposición de las políticas del prefijo, y con una cota por perfil fijo bajo hipótesis g/m/B y una excepción aditiva. Falta refinamiento universal de serde/bincode, operaciones de máquina y Rust y presupuestos globales. Permanecen EOF estricto y corte analítico R.

### M40 — Potencial de nonces y cola del selector

- Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.
- Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Pendiente: Se completó el puente del corte al prefijo bruto: las políticas no reciben el certificado futuro y cubren la muestra real aceptada en su primera I. La unión probabilística ya se aplica por perfil fijo bajo g/m/B explícitos para todas las activaciones. Falta justificar cotas pequeñas para candidatos falsos y canales válidos, valor<=rho y su filtro causal, factor de trabajo, presupuesto común de perfiles y reinicios y composición global. No se trata la preconsulta deliberada como un error de cumpleaños.

### M41 — Cota ROM completa y ejemplo numérico

- Conservar la cota parametrizada del evento excepcional del registro.
- Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.
- Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Pendiente: La cobertura de la aceptación ya llega a la unión probabilística de primeras exposiciones en un solo experimento finito por perfil fijo. Bajo cotas g/m/B de todas las activaciones, se obtiene Pr(aceptación y SinBad)<=riesgo*B y Pr(aceptación)<=Pr(no SinBad)+riesgo*B. Falta derivar las hipótesis para candidatos falsos y canales válidos, reunir perfiles y reinicios, cotas de todas las rondas FRI y trabajo, cota de excepciones y presupuestos, refinamiento universal Rust y ejemplo numérico integral. No se afirma solidez global ni que g o Pr(preconsulta) sean pequeños.
