# Adversario y primeras exposiciones en el ROM clásico

La [auditoría](validacion.json) comprueba **1927 resultados en 216 módulos**.
Esta pasada añade **66 resultados en nueve módulos** y actualiza 29 bloques
con 164 enlaces nuevos. Se avanza en M35/M37 y su adaptador matemático M39.
Se conservan los criterios y estados de los siete grupos parciales.

## Programa, tabla e historia efectiva

Un programa finito puede consultar listas de bytes de cualquier longitud y
devolver cualquier tipo de dato. El proponente hace consultas y elige después
los bytes del certificado y su estado. El lector estricto y el verificador
se ejecutan con un adversario que puede consultar antes de cada petición y
actualizar su estado tras la respuesta. Todo comparte una H y una tabla:
una repetición devuelve lo memorizado y no genera una respuesta fresca.

Se conserva el resultado del verificador, su registro es una subsecuencia
del global y cada consulta real queda en la tabla. La historia producida
es causal: la próxima petición depende solo de las respuestas anteriores.
El coste global suma consultas adversarias y del protocolo. Para un candidato
con presupuesto V y adversario limitado a Q se prueba Q+V; para el verificador
tipado se usa V_T. El coste de lectura y memoria del parser queda fuera.

## Ley local y selector

El dominio de bytes es infinito. Para una historia fija se cuenta únicamente
el conjunto finito de entradas observadas más la siguiente. Sus completaciones
son exactamente el cilindro de la historia: en una entrada fresca cada digest
tiene masa 1/2^256 y una repetición no puede cambiar su respuesta. El resultado
no postula una distribución uniforme sobre todas las funciones de bytes.

Se prueba la bijección del digest completo con Fin(256^32). Leer sus primeros
ocho bytes y reducir módulo 2^e coincide con reducir el entero completo, para
e<=64. Cada índice tiene 2^(256-e) preimágenes. Una cinta ideal de R digests
independientes induce exactamente palabras uniformes de índices, con fibras
(2^(256-e))^R. Se transfieren promedios, cocientes de eventos, uniformidad de
q-subconjuntos y ley hipergeométrica condicionada a completar antes del corte R.

Para toda H, desplegar la cadena real de entradas I evalúa exactamente el
selector del canal y la proyección a conjuntos del selector ordenado. Desde
vacío completa cuando aparecen al menos cuarenta índices distintos. La cola
desplegada después de completar es matemática; no se cuenta como consulta
ejecutada. **La igualdad determinista y la ley ideal no prueban por sí solas
la ley conjunta del canal adversario.** No se supone independencia después
de condicionar a SinBad.

## Congelación desde consultas efectivas

SinBad comprueba, antes de cada respuesta nueva, que no alcanza las marcas
ya expuestas. Desde esa condición se construye el RecorridoSinAcierto de la
tabla real, incluidas las repeticiones y consultas adversarias arbitrarias.
Si absorción y reto están en el registro, se recuperan sus primeros orígenes
y se prueba su orden. Una llamada posterior repetida conserva esos orígenes.

Si una apertura aceptada también está registrada en ese programa global,
su valor se extrae usando exclusivamente la tabla anterior a la primera
respuesta del reto. El extractor completa las entradas no consultadas con
un valor por defecto y se prueba que esa parte no afecta a la extracción.
El origen también se instancia en el verificador con intercalaciones.

Siguen explícitas las premisas de registro de absorción, reto y apertura.
Falta derivarlas conjuntamente para todas las familias AIR/FRI del experimento
aceptado, y construir la ley conjunta y su transferencia a las cotas globales.
También siguen candidatos, composición de eventos y refinamiento universal
del ejecutable Rust. R continúa como corte analítico ausente del bucle Rust.

## Módulos

| Módulo | Resultados | Alcance |
|---|---:|---|
| [ROM/ProgramaBytes](../../../../formalizacion/Nexus/ROM/ProgramaBytes.lean) | 7 | Programa finito con entradas de bytes arbitrarios y resultado de cualquier tipo. La secuencia concatena registros, conserva el resultado del programa TG2 levantado y tiene un presupuesto estructural finito. Cada par de su traza responde mediante la misma H y su tabla es compatible. |
| [ROM/ProyeccionDigest](../../../../formalizacion/Nexus/ROM/ProyeccionDigest.lean) | 7 | Bijección de los 32 octetos del digest con Fin(256^32). El índice real de los primeros ocho octetos coincide con el residuo del entero completo para e<=64; cada índice tiene 2^(256-e) preimágenes y masa 1/2^e. Se conservan todos los promedios de funciones del índice. |
| [ROM/HistoriaLocal](../../../../formalizacion/Nexus/ROM/HistoriaLocal.lean) | 10 | La estrategia del programa usa solo el prefijo de respuestas y su historia efectiva es compatible. Cada prefijo equivale a fijar exactamente sus entradas observadas, a lo sumo n. Sobre el universo finito de observadas más próxima entrada se cuenta la ley fresca 1/2^256; una repetición con respuesta distinta es imposible. |
| [ROM/EjecucionBytes](../../../../formalizacion/Nexus/ROM/EjecucionBytes.lean) | 12 | El programa de bytes ejecuta una tabla compartida compatible con H: memoriza las nuevas entradas, conserva las repeticiones y registra todas las consultas reales. La ausencia de excepciones se verifica antes de cada respuesta fresca y produce un RecorridoSinAcierto. Los orígenes ordenados de absorción y reto se derivan de su pertenencia al registro efectivo, también cuando las llamadas actuales son repetidas. |
| [ROM/PalabrasDigest](../../../../formalizacion/Nexus/ROM/PalabrasDigest.lean) | 6 | La proyección real de R digests independientes tiene fibras de tamaño (2^(256-e))^R. Conserva promedios y cocientes de eventos de palabras de índices. Se obtiene uniformidad de q-subconjuntos y el cociente hipergeométrico del selector condicionado a completar antes de R. |
| [Canal/Intercalaciones](../../../../formalizacion/Nexus/Canal/Intercalaciones.lean) | 7 | Un adversario con estado puede consultar bytes arbitrarios antes de cada petición del protocolo y actualizarse después de su respuesta. El verificador matemático conserva resultado y su registro es una subsecuencia del global. El coste global es el coste del protocolo más las consultas adversarias, con cota Q+V_T y tabla efectiva común. |
| [Canal/CongelacionPrograma](../../../../formalizacion/Nexus/Canal/CongelacionPrograma.lean) | 4 | Una apertura aceptada registrada en el programa global se encuentra en su tabla efectiva. Los primeros orígenes absorción/reto proporcionan un extractor que usa solo la tabla anterior a la primera respuesta del reto. Sus valores coinciden con toda apertura posterior registrada. Se instancia el origen en el verificador con intercalaciones. |
| [Canal/CintaSelector](../../../../formalizacion/Nexus/Canal/CintaSelector.lean) | 5 | Para cualquier H, desplegar R respuestas de entradas I evalúa exactamente el programa real de selección, incluido su rechazo por corte. La proyección del selector ordenado se evalúa sobre la misma cinta; desde vacío completa exactamente cuando aparecen al menos cuarenta índices distintos. |
| [Verificador/Adversario](../../../../formalizacion/Nexus/Verificador/Adversario.lean) | 8 | El proponente consulta entradas arbitrarias y elige adaptativamente los bytes del certificado y su estado. Se compone con el lector estricto y el verificador intercalado usando una sola H. La aceptación entrega un certificado leído con forma válida. Registros previos y del verificador quedan en el global, que tiene historia causal compatible y coste adversario más protocolo. |

## Matriz e integridad

Hay 33 modelos verificados en su alcance, siete grupos parciales, tres
dependencias bibliográficas, dos respaldos documentales y un trabajo futuro
QROM AIR/FRI. Los [criterios originales](../Adversario-Causal-Antecedentes/revision-criterios.json)
se conservan; los cierres anteriores mantienen sus límites y obligaciones
adicionales. 212 bloques del inventario y 216 de la revisión
tienen enlaces parciales; hay 1272 enlaces con alcance explícito.

| Grupo | Tema | Trabajo pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | La lectura del índice sobre 32 bytes, las cintas ideales, su selector uniforme/hipergeométrico y la evaluación determinista del canal ya están enlazadas. Hay ley fresca local sobre cada prefijo del programa de bytes y se distinguen repeticiones. Falta construir la ley conjunta del experimento adversario de primeras exposiciones y transferir sus cotas sin suponer independencia después de condicionar a SinBad, además del refinamiento universal Rust. |
| M36 | Solidez ideal por rondas y reinicios | Completar el adaptador integral de rondas y reinicios y obtener revisión independiente; el autor declaró que no hay dictamen. El compilador de programas finitos no identifica por sí solo los inicios B con consultas hash Q. |
| M37 | Extracción Merkle, bytes y orden temporal ROM | El programa global ya incluye propuesta adaptativa de bytes e intercalaciones adversarias arbitrarias, y deriva su tabla e historia efectiva. De SinBad y la pertenencia real de absorción, reto y apertura se obtiene la congelación antes de la primera exposición. Falta derivar conjuntamente esas premisas y las familias causales para todas las aperturas AIR/FRI del experimento aceptado, y enlazarlas con su solidez global. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | El certificado y su lector matemático, formas, rechazos, canal y todas las aperturas ya están compuestos con presupuesto V_T demostrado. Falta refinamiento universal del parser serde/bincode, las otras operaciones de máquina y el ejecutable Rust. Se conserva la diferencia de EOF y el corte analítico R; el contraste de cincuenta casos es evidencia externa, no equivalencia universal. El adaptador matemático ahora admite propuesta adaptativa de bytes y consultas adversarias antes y entre las del verificador, conservando resultado, registros y presupuesto de hashes. |
| M40 | Potencial de nonces y cola del selector | Construir los programas de los candidatos reales y sus conjuntos buenos con cotas antes de responder, además del trabajo/nonce y la tabla global. El compilador memoriza las repeticiones, pero no demuestra valor<=rho para esos candidatos ni la carga global de inicios. |
| M41 | Cota ROM completa y ejemplo numérico | Probar las inclusiones y leyes de los tres eventos bajo un mismo experimento del ejecutable, incluyendo adversario, sesgo, selector y presupuestos completos. La gramática, programa causal y cuenta del canal son componentes; no instancian todavía la cota numérica global. |

Compilación y axiomas correctos. Los 216 módulos repiten su verificación
del núcleo, con un máximo de cuatro procesos y sin reutilizar replays previos.
Solo aparecen propext, Classical.choice y Quot.sound. Se confía en importados,
sin --fresh ni dictamen independiente. Se fijan 674 fuentes y 222 logs.
Pasan 21 controles Python y se conservan 39 etapas con 3730 logs canónicos.

Se conservan 16 versiones previas y 15 fuentes congeladas. Los 5413 archivos
de la edición anterior siguen recuperables. Capítulos, salidas publicadas,
TG1 y fuentes Rust conservan sus bytes. No se cambia la implementación ni
se repite su suite Rust en esta pasada exclusivamente matemática.
[Comprobación de integridad](integridad-adversario-causal.json).

El autor declaró «No hay dictamen»; H1/H2 sigue sin procedencia exacta.
Qiskit SDK y Aer permanecen anotados como trabajo futuro, sin instalación.
La solidez integral, ZK y equivalencia universal Rust/Lean siguen abiertas.
