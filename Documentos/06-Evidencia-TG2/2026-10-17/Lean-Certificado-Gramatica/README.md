# Certificado concreto, gramática y programa del canal TG2

La [auditoría](validacion.json) comprueba **1756 resultados en 196 módulos**.
Esta pasada añade **49 resultados en cinco módulos** y actualiza 44 bloques.
M31 cierra el alcance matemático de su ejemplo legado. Quedan **siete grupos
parciales** y 33 modelos verificados en su alcance, con tres dependencias
bibliográficas, dos respaldos documentales y un trabajo futuro QROM AIR/FRI.
La tesis completa y la seguridad del ejecutable siguen sin verificar.

| Módulo | Resultados | Alcance |
|---|---:|---|
| [ROM/CertificadoLegado16](../../../../formalizacion/Nexus/ROM/CertificadoLegado16.lean) | 10 | Dieciséis índices, consultas, ranuras y valores literales del certificado legado público de 16 filas. Se prueban las posiciones seleccionadas, nodos distintos, grado menor que 16, evaluaciones exactas, interpolación y recuperación de la segunda fila 5, también para cualquier traza compatible de ese grado. Rust y una relectura Python enlazan externamente los bytes concretos con esas constantes. |
| [Canal/GramaticaTG2](../../../../formalizacion/Nexus/Canal/GramaticaTG2.lean) | 12 | Gramática conjunta de inicio, perfil, enunciado, raíces, fases, finales, nonce, E/I, trabajo y Merkle TG2 v1. Longitudes máximas de 79 octetos; las absorciones que coinciden con un nodo son de enunciado y se conserva un solapamiento explícito. No se separan artificialmente las tablas por rol. |
| [ROM/ProgramaCompartido](../../../../formalizacion/Nexus/ROM/ProgramaCompartido.lean) | 13 | Claves finitas con longitud y hasta 79 octetos, iguales si y solo si sus bytes coinciden; el solapamiento entre roles comparte clave. Todo programa finito produce historia causal compatible, y se deriva la ley fresca y la repetida en cada prefijo. El compilador a árboles de candidatos memoriza por clave y no sortea otra respuesta en una repetición, incluso entre roles. |
| [Canal/ProgramaTG2](../../../../formalizacion/Nexus/Canal/ProgramaTG2.lean) | 7 | Programa del canal con bytes de perfil y enunciado, tres alfas, dos fases FRI, trabajo, absorción de nonce y un selector compartido. Desde el recorrido se demuestra la cuenta 13+2*(longitudes de ambas listas de raíces)+R+C, con rechazo de trabajo y duplicados incluidos; se identifica con canalPerfil si las listas tienen longitudes k y k+1. |
| [FRI/IndicesMaquina](../../../../formalizacion/Nexus/FRI/IndicesMaquina.lean) | 7 | Conversión, suma, división y módulo de USize se enlazan exactamente con naturales bajo cotas explícitas. Las seis posiciones AIR de TG2 coinciden con sus operaciones de máquina; sus sumas intermedias caben incluso en 32 bits para N<=32768 e i<N/2. Se instancia N=2^(k+3), k<=12. |

## Certificado público legado

Se genera un certificado nuevo del ejemplo inicio=3, testigo=5, T=16 usando
las fuentes legadas sin modificarlas. Se serializa con el orden y tipos de
PqValidityProof y bincode 1.3.3, y se verifica con verify_state_transition.
El [binario público](../Certificado-Gramatica-Antecedentes/certificado/certificado-legado-16.bin)
tiene 132096 bytes y SHA-256
`bcf91052386434ca24c078098a8f7853b7fffd8d65fef7bc1ee9a15e59d14f42`.
No se presenta como el archivo histórico de una corrida anterior.

Una [relectura Python](../Certificado-Gramatica-Antecedentes/certificado/relectura-independiente.json)
comprueba canonicidad, SHA3, nonce, índices, 240 aperturas AIR, composición y
los 40 recorridos FRI. Hay 128 puntos públicos distintos; se seleccionan los
índices 0 a 15, conservando consulta, ranura, punto y valor. El selector usa
66 extracciones para obtener 40 índices distintos; nonce=245, trabajo de 12 bits.

Lean comprueba las posiciones, dieciséis evaluaciones literales y el grado
menor que 16. La interpolación recupera el polinomio y su segunda fila 5;
cualquier traza de ese grado compatible con los mismos valores da esa fila.
Los coeficientes propuestos por Python se verifican en el campo, no se toman
como una igualdad asumida. La vinculación entre bytes y constantes sigue
siendo evidencia ejecutada externa al núcleo Lean. No se formaliza SHA3.

El legado usa dominio NEXUS-STARK-v2 y hojas AIR de nueve octetos con etiqueta.
TG2 v1 usa NEXUS-TG2-LINKED-FRI-v1 y hojas de extensión de 17 octetos.
El certificado y sus pruebas no acreditan ZK ni solidez general de ninguno.
La [evaluación de los ocho](Revision-Alcance.md) conserva sus criterios originales.

## Tabla y programa TG2 v1

La gramática conjunta tiene entradas de 17 a 79 octetos en sus longitudes
admitidas. Una absorción de enunciado puede coincidir con un nodo Merkle;
el modelo conserva ese solapamiento y usa una sola clave para bytes iguales.
Se genera una historia compatible desde cada programa finito. Condicionar
a un prefijo producido conserva la respuesta uniforme solo si la próxima
clave está ausente; una repetida mantiene su valor. No se deduce frescura
global ni uniformidad de SHA3. El compilador a árboles memoriza repeticiones,
incluidas las que ocurren entre roles con iguales bytes.

El programa del canal contiene perfil, enunciado, raíz, tres alfas, dos fases,
trabajo, absorción del nonce y un selector común. La cota desde el recorrido es
13+2*(longitudes de ambas listas de raíces)+R+C; con longitudes k y k+1 coincide
con canalPerfil(k,R)+C. Incluye trabajo rechazado y cualquier secuencia de
duplicados. R es corte analítico; el Rust no para a las 512 extracciones.
Las aperturas y el predicado de trabajo se parametrizan y conservan su obligación.
USize calcula exactamente las seis posiciones AIR, con sumas que caben en 32 bits
para N<=32768 e i<N/2; eso no verifica el compilador ni todo Rust/usize.

El [contraste del corpus](contraste-corpus.json) recorre catorce certificados
TG2 v1 preservados: ocho honestos aceptan y seis trazas lejanas rechazan.
Se comprueban 111448 entradas hash contra la gramática y la cuenta del canal,
con el presupuesto correcto tanto en aceptación como en rechazo. Es evidencia
de esos casos concretos, sin convertirla en refinamiento universal o ley ROM.

## Siete parciales restantes

| Grupo | Tema | Trabajo pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | Instanciar la proyección de respuestas y demostrar las claves frescas bajo las excepciones en todas las historias del ejecutable y del adversario. El programa de canal usa una sola muestra; su ley fresca está condicionada a ausencia de la clave en la historia, no se elimina esa condición. |
| M36 | Solidez ideal por rondas y reinicios | Completar el adaptador integral de rondas y reinicios y obtener revisión independiente; el autor declaró que no hay dictamen. El compilador de programas finitos no identifica por sí solo los inicios B con consultas hash Q. |
| M37 | Extracción Merkle, bytes y orden temporal ROM | Extender el programa causal a todas las consultas y eventos del protocolo/adversario, incluidas entradas arbitrarias fuera de la gramática acotada. Derivar registro y congelación antes de la primera exposición bajo los eventos de excepción; el solapamiento enunciado/nodo debe seguir en la tabla común. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | Completar gramática de certificados, parser/deserialización, rechazos y correspondencia integral con Rust. Ya se deriva la cuenta del canal y se verifican las seis posiciones con USize; faltan la composición con todas las aperturas, las otras operaciones de máquina y el refinamiento del ejecutable. |
| M40 | Potencial de nonces y cola del selector | Construir los programas de los candidatos reales y sus conjuntos buenos con cotas antes de responder, además del trabajo/nonce y la tabla global. El compilador memoriza las repeticiones, pero no demuestra valor<=rho para esos candidatos ni la carga global de inicios. |
| M41 | Cota ROM completa y ejemplo numérico | Probar las inclusiones y leyes de los tres eventos bajo un mismo experimento del ejecutable, incluyendo adversario, sesgo, selector y presupuestos completos. La gramática, programa causal y cuenta del canal son componentes; no instancian todavía la cota numérica global. |

## Comprobación y conservación

Compilación, axiomas y replay de los 196 módulos correctos, con un máximo de
cuatro leanchecker simultáneos. Se conservan las mismas comprobaciones por módulo;
el nuevo planificador comprueba todos los resultados y propaga fallos. Pasan
21 controles Python. Los axiomas admitidos siguen siendo propext,
Classical.choice y Quot.sound; el replay confía en importados, sin --fresh
ni dictamen externo. Se fijan 510 fuentes y 202 logs canónicos.

El extractor pasa cargo check, test y build y ejecuta la verificación concreta.
Cargo test corresponde al paquete extractor, sin repetir toda la suite de nexus.
Se conserva el fallo inicial de resolución offline y el reintento correcto
con Cargo.lock: no se alteró el lock ni las fuentes del repositorio nexus.
Los capítulos, salidas, TG1 y Rust conservan sus bytes; se archivan 16 versiones
previas y 27 registros de fuentes/artefactos. Se conservan 70 replays anteriores
por identidad de 19680 fuentes/importados y del ejecutor; los otros 126 se
ejecutan con cuatro procesos. La interrupción de la pasada de dos procesos
queda archivada, sin declararla auditoría completa. La edición anterior de 4693 archivos
queda recuperable. [Integridad](integridad-certificado-gramatica.json).
El autor declaró «No hay dictamen» y no se inventan datos H1/H2.
