# Lean 4 y mathlib para NEXUS

Proyecto de formalización con Lean **4.35.0** y mathlib **v4.35.0**. Las
revisiones de las dependencias se conservan en `lake-manifest.json`.

**Alcance actual:** [toda la matemática del manuscrito](ALCANCE-MANUSCRITO.md).
Hay **1610 lemas y teoremas registrados en 177 módulos**. La [revisión del manuscrito](REVISION-MANUSCRITO.md)
clasifica 272 candidatos, registra 14 omisiones y organiza 46 grupos. Enlaza
parcialmente 215 bloques y diez suplementos; no acredita exhaustividad ni cierre global.

La [pasada de las 22 obligaciones](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Obligaciones-22/README.md)
añade 164 resultados en 20 módulos: recorridos FRI completos, firmas del lote,
NTT algebraica, contadores, serialización, selector y potencial. M10, M32 y M46
cierran sus modelos. Hay 21 modelos verificados y 19 grupos parciales, con
reducciones, refinamiento Rust y adaptador causal pendientes. La fórmula ROM
del ejemplo tiene aritmética exacta; no certifica seguridad del ejecutable.

La [pasada de grados AIR y cancelación](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Grados-Cancelacion/README.md)
añade 53 resultados en tres módulos. M28 y M29 cierran las cotas ajustadas,
la cancelación por masa máxima y el ejemplo exacto de 16 filas. Al cerrar esa etapa
había 18 modelos verificados y 22 grupos parciales; los puentes con Rust/ROM y las reducciones
mantienen sus obligaciones. Los capítulos y formatos publicados no cambian.

La [pasada de modelos y conciliación TG2](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Modelos-Pendientes/README.md)
añade 176 resultados en 16 módulos: retículos, FSwA, derivación, épocas,
transacciones, APT decimal, sesgo modular, cola del selector, presupuestos,
cota ideal histórica, comunicación, mediciones y modelos de quórum/incentivos.
M02, M07, M12, M17, M34 y M38 quedan verificados en su alcance. La
[edición del manuscrito](../Documentos/06-Evidencia-TG2/2026-10-17/Manuscrito-Modelos/README.md)
concilia unidades, bytes de hoja y frases de estado, con Word/PDF regenerados.
Al cerrar esa etapa quedaban 24 grupos parciales y las dependencias; el dictamen seguía pendiente.

La [pasada de juegos reticulares](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Juegos-Reticulares/README.md)
añade 114 resultados: S_eta y leyes MLWE, extracción MSIS concreta, consultas
adaptativas, juegos EUF/sUF y familias asintóticas. M04, M06 y M45 quedan como
modelos verificados; SelfTarget conserva sus límites clásico/finito y bibliográfico.
La dureza, las reducciones y la equivalencia con ML-DSA real siguen pendientes.

La [pasada de anillos y contraejemplo](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Anillos-Contraejemplo/README.md)
añade 121 resultados: cocientes ML-DSA, representantes, normas, parámetros y raíz
primitiva; construcción AIR con distancia mínima 7/8 y composición de bajo grado.
M03 y M30 quedan como modelos verificados en su alcance algebraico. Categorías
de seguridad, codecs y aceptación/rechazo de programas conservan sus límites.

La [pasada de residencia y costos](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Costos-Residencia/README.md)
añade 118 resultados: integral de regiones y captura uniforme, contabilidad R5,
amortización variable/polilogarítmica, costos NTT y esperanza geométrica de firma.
M19, M20 y M22 quedan como modelos verificados; las correspondencias de memoria,
algoritmo NTT, distribución y contador del backend siguen explícitas.

La [pasada de entropía y salud](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Entropia-Salud/README.md)
añade 87 pruebas: min-entropía y acumulación IID, límite de Shannon de cinco bits
para 32 muestras, RCT=4, APT mínimo=16 e invariantes del monitor y la recuperación.
M14 y M15 quedan como modelos finitos verificados; salud mantiene pendientes sobre
decimales, Rust/f64, operaciones y calificación de la fuente. La auditoría completa
repite compilación, axiomas y núcleo de los 113 módulos confiando en importados.
La tesis completa conserva obligaciones pendientes.

La [etapa de enlace local AIR/FRI](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Enlace-AIR-FRI/README.md)
formaliza la raíz compartida de TG2 v1 y las seis aperturas AIR. TG2 autentica
los valores AIR como hojas Fp2 de 17 bytes, compartiendo raíz y formato con
la primera capa FRI de traza. El oráculo coincide entre los cortes previos
a ambos retos. Los índices de las seis posiciones son exactamente x,gx,g²x
y sus opuestos. Aperturas aceptadas y registradas dan el control base de la
muestra y el enlace de la primera pareja de traza. La fórmula de compose
se transporta de Fp a Fp2 y coincide con composicionLocal. Las aperturas y
comparaciones de composición dan ConsultaParejas de N06. Se obtiene
AceptaCompartida tomando como premisas separadas las dos aceptaciones FRI
y las coincidencias de oráculos iniciales. La pasada de recorridos deriva
ahora ambas aceptaciones del bucle de acarreo y constante final. Quedan
el adaptador causal, historiales, presupuestos, distribuciones, nonces y
la correspondencia integral con la semántica de Rust.

Se precisa el alcance de la [etapa auxiliar de hojas base](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Hojas-Base/README.md):
las hojas Fp de 9 bytes pertenecen al formato usado por el verificador legado.
Sus pruebas de canonicidad, etiquetas, congelación y arreglos mixtos se conservan.
Ese oráculo base global no sustituye al oráculo inicial de TG2 v1, que puede
tomar valores de extensión en posiciones no abiertas. TG2 exige el control
base en las seis posiciones consultadas. La tesis completa no está verificada.

La [etapa previa de índices y oráculos Merkle](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Indice-Merkle/README.md)
conecta las rutas desde la raíz con los índices numéricos de las hojas. El
acumulador desde la hoja consume bits bajos e invierte el orden de hermanos
para coincidir con el extractor. Se prueban inversas y una equivalencia entre
rutas de altura h e índices Fin (2^h). La cota del índice es una premisa al
extraer; la comprobación matemática de aceptación exige altura e igualdad de raíz.
Cada vector produce un oráculo Fp2→Fp2 sobre el dominio de su capa, con cero
fuera. Las aperturas registradas y aceptadas vinculan el valor en el punto de
su índice, incluida la fórmula del plegado de una pareja abierta. El oráculo
queda fijado antes de la primera exposición del reto y hasta el registro final
sin aciertos. Una familia dada de estados y raíces se empaqueta en los arreglos
OraculosEmitidos de N06, conservando lectura y valores de aperturas.
Falta construir causalmente esa familia para todas las historias y completar
las fases, formatos, presupuestos S y B_T, distribuciones, nonces y semántica
de máquina de Rust. Su formato Fp2 es el utilizado por TG2 v1; las hojas Fp
y arreglos mixtos son un componente auxiliar. La tesis completa no está verificada.

La [etapa previa de primeras consultas](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Primeras-Consultas/README.md)
recupera el origen de cada entrada del registro desde vacío, con su solicitud,
tabla anterior y recorridos a ambos lados. Una respuesta nueva sin acierto
no aparece en las ventanas de una entrada ya consultada ni de su propia
entrada. Si aparece en las ventanas de otra entrada registrada, su primera
consulta ocurre antes. La posición canónica en la tabla prueba ese orden;
la relación de dependencias por ventanas es bien fundada.
Para una absorción de raíz y el reto que usa su respuesta, ambos registrados,
se recuperan los orígenes en orden y se congela el vector antes de la primera
exposición de ese reto. Todas las aperturas posteriores aceptadas y registradas
respetan ese vector, aunque las llamadas actuales sean repeticiones.
El resultado usa un recorrido desde vacío sin aciertos; no deduce uniformidad
condicionando a la ausencia de eventos futuros. Faltan la gramática completa,
obtener los hechos de registro para todo el protocolo, el adaptador causal
N06, los presupuestos S y B_T, distribuciones, nonces y semántica de Rust.

La [etapa previa de congelación previa y canal](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Congelacion-Canal/README.md)
permite fijar el vector cuando una raíz aparece por primera vez en la entrada
de la consulta actual. Las marcas preparadas cubren las etiquetas Merkle antes
de responder y persisten tras consultas nuevas o repetidas. Se prueban las
entradas de absorción, retos F/E/I y trabajo con nonce u64, recuperando campos
y longitudes y demostrando inyectividad de cada formato. Una absorción con
24 bytes puede coincidir con un nodo Merkle de 65: se prueba ese solapamiento.
Una secuencia local encadena la respuesta de absorción en la entrada del reto.
Fuera de aciertos, las aperturas posteriores aceptadas y registradas respetan
el vector calculado antes de ambas respuestas. La fórmula de bytes no prueba
la distribución del reto. Esa etapa dejaba pendiente la primera exposición
del reto cuando una llamada actual era repetida. La etapa nueva aporta los
cortes y el orden de orígenes para el par registrado absorción/reto. Permanecen
las historias completas, presupuestos, conexión N06, nonces y semántica de Rust.

La [etapa previa de ROM con memoria](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-ROM-Memoria/README.md)
formaliza un juego finito de consultas adaptativas. Una repetición devuelve
el digest guardado y conserva la tabla; solo una entrada nueva recibe un
digest uniforme y consume presupuesto. Las solicitudes y sus marcas
adicionales se eligen antes de responder, con cardinal acumulado ≤B.
La probabilidad de algún acierto coincide con el conteo exacto de cintas
uniformes de respuestas nuevas. Desde tabla vacía, con presupuesto S, se
demuestra min(1,S(49S+B)/2^256), también con parada anticipada y repeticiones.
Cada ejecución sin acierto produce un recorrido compatible con su tabla final.
Se deriva ausencia de colisiones y se prueba que, para una raíz ya marcada,
las aperturas posteriores aceptadas y registradas coinciden con el vector
calculado exclusivamente con la tabla del instante de congelación. Las marcas
adicionales pueden aparecer después; no se aplican retroactivamente.
Faltan la gramática integral del canal, justificar sus presupuestos S y B_T,
el enlace con N06, los nonces y la equivalencia completa con Rust/ROM.
El B de este juego cuenta marcas adicionales y no es el presupuesto de retos
ideales usado por los planes N06. QROM AIR/FRI sigue como trabajo futuro.

La [etapa previa de bytes Merkle](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Merkle-Bytes/README.md)
instancia el extractor sobre octetos y digests de 32 bytes. Se prueban las
conversiones LE, la serialización canónica de Fp2, las hojas de 17 bytes y
los nodos de 65, con decodificación inversa y reconstrucción exacta.
Cada entrada de hasta 79 bytes aporta a lo sumo 48 ventanas de 32 bytes.
Estas contienen los hijos de cualquier nodo admitido; una absorción de raíz
de 73 bytes también deja su digest marcado. Se cubren las etiquetas del
extractor mediante ventanas y respuestas del registro, sin exigir separación
global de roles. Su cota (49S+B)/2^256 para una respuesta uniforme nueva
se utiliza ahora en la unión adaptativa del juego con memoria.
La [etapa previa de extracción Merkle congelada](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Merkle-Congelado/README.md)
añade el primer componente de N07. Un registro de entradas consultadas permite
buscar preimágenes y extraer un vector total, completando con cero las regiones
ausentes o de forma incorrecta. Bajo ausencia de colisiones en el registro,
las aperturas aceptadas y registradas coinciden con ese vector. Se marcan raíz,
salidas e hijos decodificados. Las consultas posteriores que evitan esas
etiquetas conservan la ausencia de colisiones y el vector congelado, de modo
que una apertura posterior coincide con el valor fijado antes del reto.
La prueba de esa etapa usa un formato abstracto con decodificación inversa
y una condición determinista de extensión segura. Las etapas posteriores
aportan bytes, memoria y la cota de aciertos; permanece el enlace integral
al verificador Rust y a N06.
La cota local de etiquetas 3·longitud+1 cuenta solo los datos de este modelo
Merkle; no sustituye la cuenta global de ventanas del canal.
La [etapa previa de planes explícitos](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Planes-Explicitos/README.md)
demuestra que un reto nuevo conserva la historia anterior y que su destino
explícito coincide con el de cualquier política que reproduzca su origen.
Los pasos de mensajes contienen la gramática y datos de destino compatibles
con todos los mensajes anteriores. Su correspondencia con el modelo observado
es exacta; se deduce la conservación del estado. Los planes explícitos solo
usan esos pasos y retos desde nodos guardados. Su evaluación propia por medias
uniformes satisface min(1,B·errorRonda), igual a min(1,B·h_T) en los nueve perfiles.
Se transportan planes completos en ambos sentidos conservando el registro
representado, el presupuesto y la probabilidad de aceptación. La comparación
es entre dos modelos ideales internos. Permanecen el adaptador bibliográfico
integral, formatos inválidos, aperturas y Rust/Merkle/ROM.
La [etapa previa de transcripción explícita](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Transcripcion-Explicita/README.md)
representa los mensajes con arreglos finitos de oráculos y constantes, realiza
los datos individuales y demuestra la equivalencia biyectiva de prefijos.
Conserva estado, aceptación y cotas locales de retos. La etapa nueva extiende
esa correspondencia a mensajes y planes completos, sin afirmar que todas las
formas tipadas arbitrarias sean alcanzables desde vacío.
La [etapa previa de estado observado](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Estado-Observado/README.md)
demuestra que políticas que emiten los mismos mensajes producen el mismo
estado. El prefijo observado conserva fase y retos e identifica políticas por
los oráculos y constantes ya enviados; su estado y aceptación quedan definidos
sin elegir una política futura. Las capas terminales se fijan a las constantes
enviadas, conservando los mensajes y la marca anterior a consultar. El plan
solo admite mensajes tipados y retos desde clases guardadas; puede elegir otra
política compatible por petición. Se prueba min(1,B·h_T) en los nueve perfiles.
Permanecen la realización y equivalencia integral con la transcripción y los
adversarios bibliográficos, los formatos y aperturas, y Rust/Merkle/ROM.
La [etapa previa de transcripción causal](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Transcripcion-Causal/README.md)
añade prefijos con fase y longitud tipadas, acumulador AIR y marca reconstruidos
desde los retos recibidos. La proyección de cada reto reproduce las transiciones
anteriores; el estado inicial es uno exactamente para enunciados válidos y el
estado final cero implica rechazo. Los pasos sin monedas conservan el estado.
El plan de reinicios solo añade mensajes de la gramática y retos desde prefijos
guardados; demuestra min(1,B·h_T) para los nueve perfiles, manteniendo fija una
política causal en esa expansión. La etapa de estado observado demuestra ahora
la invariancia y el transporte de políticas compatibles sobre su cociente de
mensajes. La expansión anterior conserva su alcance de política fija.
La [etapa previa de políticas adaptativas](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Reinicios-Adaptativos/README.md)
permite elegir otra política de oráculos en cada petición, según toda la
historia de intentos. Cada nodo guardado conserva la suya. La cota sigue
siendo min(1,B·h_T) en los nueve perfiles, también bajo una semilla finita
uniforme de planes. El juego conserva la regla de mensajes con la misma
marca; permanece el adaptador formal al protocolo. B cuenta retos ideales
frescos y no se identifica con consultas SHA3.
La [etapa previa de reinicios ideales](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Reinicios-Ideales/README.md)
demuestra la cota min(1,B·epsilon) en un árbol adaptativo que restaura nodos
guardados y cobra únicamente retos frescos. Una aceptación guardada implica
una primera transición excepcional. Se instancian las respuestas de campo
y la muestra uniforme de parejas con el certificado AIR/FRI: en los nueve
perfiles se obtiene min(1,B·h_T), manteniendo una política de oráculos fija
para todo el árbol. Los mensajes del modelo pueden añadir nodos
con la misma marca; su correspondencia formal con el protocolo permanece
pendiente. B no se identifica con consultas SHA3.
La [etapa previa de solidez por rondas](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Solidez-Rondas/README.md)
construye la marca booleana absorbente de la ejecución causal y los monitores
de cada clase de reto. Estado cero antes de consultar equivale a prefijo seguro;
estado final cero implica rechazo. Se demuestran las cotas condicionales AIR,
FRI y consulta y se reúnen en un certificado de las transiciones concretas.
Para los nueve perfiles 4≤k≤12 y q=40, el máximo de esas cotas es exactamente
h_T=H(4T,40,1/8), como cota escogida por ronda. Sus cotas se utilizan en el
corolario nuevo. Permanecen la correspondencia formal bibliográfica y del
protocolo, y Rust/Merkle/ROM.
La [etapa previa de solidez interactiva](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Solidez-Interactiva/README.md)
construye la ejecución causal AIR → FRI de traza → FRI de composición → muestra
compartida. El oráculo inicial precede a AIR y cada capa recibe únicamente
las monedas anteriores. Para un enunciado sin traza base válida y el perfil
δt=δc=1/8, 4≤k≤29, se demuestra que producir un prefijo inseguro tiene
probabilidad ≤(8T−3)/p². La aceptación conjunta, incluyendo esas transcripciones,
queda acotada por H(4T,q,1/8)+(8T−3)/p² para q≤4T. Con q=40 se enlaza con
los cuatro superiores de la tabla 6.22. Esta cota ordinaria se conserva;
el certificado por rondas se construye en la etapa nueva.
La [etapa previa de consulta compartida](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Consulta-Compartida/README.md)
demuestra el muestreo de los recorridos FRI individuales y de los controles
locales sobre las parejas concretas. Un único predicado usa la misma muestra
para ambos FRI, las seis posiciones base AIR y el enlace. Para prefijos seguros
del perfil de radio 1/8 se prueba H(4T,q,1/8), también bajo distribuciones
finitas de prefijos; q=40 añade (7/8)^40. La etapa nueva incorpora los prefijos
producidos por la ejecución causal y su riesgo excepcional.
La [etapa de candidato y AIR](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Candidato-AIR/README.md)
elige el candidato y su rama antes de los coeficientes, contempla su inexistencia
y construye la ronda crítica de cancelación. El escape equivale a la cancelación
total, tiene probabilidad ≤1/p² y, fuera de él, se obtiene la transferencia y
la alternativa lejana/enlace de la composición. Sus monitores se utilizan
en la cota conjunta de la nueva etapa.
La [etapa de historias adaptativas N06](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Historias-N06/README.md)
formaliza el experimento finito de retos uniformes frescos, el escape absorbente
y su cota de unión. Cada oráculo FRI depende de los retos anteriores; se
demuestran recuperación, muestreo condicionado y probabilidades de excepciones
por fase. Son la base probabilística de la ejecución conjunta actual.
La [etapa de cosets FRI](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Cosets-FRI/README.md)
construye las torres Goldilocks de traza y composición, aplica el muestreo
completo y demuestra los índices de parejas y la fórmula algebraica del plegado.
Permanecen el enlace completo con el ejecutable y sus aperturas autenticadas.
La [etapa de torre FRI](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Torre-FRI/README.md)
demuestra la propagación por todas las capas de una torre finita abstracta,
el lema B, su enlace con el muestreo y la cuenta telescópica de excepciones.
La [etapa de plegado y muestreo](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Plegado-Muestreo/README.md)
demuestra la recuperación de una capa FRI con radio real, los márgenes de las capas,
el paso de discrepancias a parejas malas, la cota hipergeométrica/exponencial
y los cuatro redondeos refinados de la tabla 6.22.
La [etapa del candidato base/no base](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Candidato-Base/README.md)
demuestra la cota de valores base, la fracción no base del oráculo próximo y la alternativa algebraica.
La [etapa de transferencia local](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Transferencia/README.md)
conserva la pérdida 3ε sobre el dominio concreto, las fórmulas locales y la tabla 6.16.
La [etapa Goldilocks](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Goldilocks/README.md)
conserva la construcción de los campos, raíces y dominios concretos.

## Preparar y compilar

Desde la raíz de `Tesis`, en Windows con Python y Git disponibles:

```powershell
python scripts/lean.py preparar
python scripts/lean.py build
```

El primer comando instala Elan 4.2.4 y Lean dentro de `.tools/lean/`, descarga
mathlib en `formalizacion/.lake/` y obtiene los archivos precompilados de los
módulos que usan las pruebas. Comprueba el SHA-256 del instalador de Elan. No
modifica el PATH del usuario. El lanzador ejecuta los procesos sin abrir
ventanas de consola. La primera preparación requiere Internet.

Para comprobar directamente un archivo o consultar las herramientas:

```powershell
python scripts/lean.py lean Nexus/Inicio.lean
python scripts/lean.py lake --version
python scripts/lean.py elan show
```

Las rutas que se pasan a Lean o Lake se interpretan desde `formalizacion/`.
`python scripts/lean.py preparar` puede repetirse para recuperar la caché y
compilar de nuevo.

## Primera demostración

[`Nexus/Inicio.lean`](Nexus/Inicio.lean) demuestra el desarrollo del cuadrado de
una suma sobre los reales usando la táctica `ring`. Es una comprobación del
entorno. La [primera verificación de la tesis](VERIFICACION.md) registra 17
lemas y teoremas de N01–N05 y N12, con sus hipótesis y obligaciones pendientes.

Para ejecutar la auditoría completa y conservar evidencia:

```powershell
python scripts/verificar_formalizacion.py
```

Para añadir resultados, crear archivos en `Nexus/`, declarar todas sus
hipótesis e importarlos desde `Nexus.lean`. Al necesitar nuevos módulos de
mathlib, descargar su caché, por ejemplo:

```powershell
python scripts/lean.py lake exe cache get Mathlib.Tactic.Linarith
python scripts/lean.py build
```

## Edición interactiva

Con VS Code y la extensión `leanprover.lean4`, abrir `formalizacion/` desde un
entorno que tenga `ELAN_HOME` y el PATH de esta instalación local:

```powershell
$env:ELAN_HOME = (Resolve-Path .tools/lean/elan).Path
$env:PATH = "$env:ELAN_HOME\bin;$env:PATH"
code formalizacion
```

## Documentación de referencia

- [Manual de Lean 4.35.0](https://lean-lang.org/doc/reference/4.35.0/):
  referencia de la versión fijada en este proyecto.
- [Módulos y visibilidad](https://lean-lang.org/doc/reference/4.35.0/Source-Files-and-Modules/):
  los archivos del proyecto usan `module`; `public import` y `public section`
  hacen accesibles las importaciones y los teoremas correspondientes.
- [Demostraciones con tácticas](https://lean-lang.org/doc/reference/4.35.0/Tactic-Proofs/):
  las tácticas construyen términos de prueba que comprueba el núcleo de Lean.
- [Validación de pruebas](https://lean-lang.org/doc/reference/4.35.0/ValidatingProofs/):
  compilar sin errores ni advertencias y revisar `#print axioms nombreTeorema`.
  `sorryAx` revela una prueba incompleta, incluso en las dependencias.
  Para `Nexus.cuadrado_suma` se comprobaron únicamente los axiomas estándar
  `propext`, `Classical.choice` y `Quot.sound`.
- [Documentación de mathlib](https://leanprover-community.github.io/mathlib4_docs/):
  consulta de definiciones, teoremas e importaciones; se publica continuamente
  y puede avanzar respecto de la revisión fijada localmente.
- [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/):
  tutorial práctico. Algunos ejemplos pueden requerir adaptar importaciones
  a la versión del proyecto.

La comprobación formal corresponde al enunciado escrito en Lean. Al trasladar
un resultado de la tesis, revisar también que sus definiciones e hipótesis
representen el resultado matemático que se pretende demostrar.

Instalación: [Lean](https://lean-lang.org/install/) y
[mathlib como dependencia](https://github.com/leanprover-community/mathlib4/wiki/Using-mathlib4-as-a-dependency).

## Referencias oficiales de NIST

- [ACVP-Server](https://github.com/usnistgov/ACVP-Server): generación de vectores
  y validación de respuestas criptográficas, incluidos los modos de ML-DSA.
- [Especificaciones ACVP](https://github.com/usnistgov/ACVP): protocolo y pruebas
  de algoritmos.
- [SP800-90B EntropyAssessment](https://github.com/usnistgov/SP800-90B_EntropyAssessment):
  estimadores de min-entropía y pruebas IID/no IID.

Son referencias y herramientas para contrastar modelos e implementaciones.
Su uso no aporta automáticamente una prueba en Lean ni una certificación NIST.
