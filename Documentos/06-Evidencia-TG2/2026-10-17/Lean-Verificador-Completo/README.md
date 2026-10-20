# Verificador matemático completo del certificado TG2

Pasada iniciada el 17 de octubre y completada el 18; la carpeta conserva la fecha de inicio.

La [auditoría](validacion.json) comprueba **1861 resultados en 207 módulos**.
Esta pasada añade **105 resultados en once módulos** y actualiza 29 bloques
con 139 enlaces nuevos. La ruta matemática conecta los bytes del certificado
con las cuarenta consultas, usando una única función hash y conservando los
rechazos. Su presupuesto se demuestra a partir del programa. Los siete
grupos parciales mantienen sus criterios originales y el refinamiento
universal del ejecutable Rust sigue pendiente.

## Lectura y recorrido

El lector recupera el certificado con resto explícito: enteros LE, campos
canónicos, digest, vectores, puntos AIR, compromisos y capas FRI. Los codecs
prueban ida/vuelta e inyectividad dentro de sus anchos declarados. La envoltura
estricta exige consumir todos los bytes. Un fallo de lectura, cola o forma
rechaza antes del primer hash. No se modelan cuotas de memoria del parser.

La forma valida filas 2^k, 4<=k<=12, perfil de 12 o 20 bits, versión, nonce,
raíz compartida, cuarenta consultas y todas las longitudes. El canal conserva
tres alfas, k betas de traza, k+1 de composición y cuarenta índices distintos
en orden de primera aparición. La proyección del selector a conjuntos coincide
con el modelo anterior. Los desafíos E usan dos mitades de 16 bytes reducidas
en Goldilocks, siempre sobre la misma tabla que las aperturas Merkle.

Cada consulta ejecuta seis aperturas AIR, enlace de traza, FRI de traza,
enlace de composición y FRI de composición. FRI autentica ambas aperturas
antes de comprobar el acarreo. Una aceptación entrega todas las condiciones
locales y la constante final. Las aperturas y continuaciones de cada recorrido
FRI aceptado están en su registro efectivo. Las listas de consultas e índices
se recorren conjuntamente y longitudes distintas rechazan; zip no las oculta.

## Presupuesto demostrado

El programa de una consulta usa a lo sumo
6*(k+4)+2*(caminos(k+3,k)+k)+2*(caminos(k+3,k+1)+k+1) hashes.
La cuenta incluye hojas y hermanos. El canal suma 13+2*(k+k+1)+R,
y las cuarenta consultas completan exactamente la fórmula V_T registrada:
**6943** para T=16 y **24895** para T=4096, con R=512. Es una cota de
llamadas hash, también para rechazos, sobre toda tabla.

R es un corte del análisis; el bucle Rust no se detiene a las 512 extracciones.
El trabajo se instancia mediante ceros iniciales del digest. Las operaciones
de campo son matemáticas: no se deduce aquí la equivalencia de todas las
operaciones de máquina ni el coste de CPU, lectura o memoria del parser.

## Módulos

| Módulo | Resultados | Alcance |
|---|---:|---|
| [ROM/RegistroPrograma](../../../../formalizacion/Nexus/ROM/RegistroPrograma.lean) | 12 | Se recuperan los bytes exactos de cada clave; las entradas del programa cuentan sus respuestas y miden a lo sumo 79 octetos. La secuencia de programas conserva el rechazo, concatena el registro solo cuando acepta el primero y suma los presupuestos para toda tabla. |
| [Merkle/ProgramaVerificacion](../../../../formalizacion/Nexus/Merkle/ProgramaVerificacion.lean) | 13 | Cada apertura Merkle se ejecuta como programa de peticiones de hoja y nodos en la tabla común. Resultado y registro coinciden con el evaluador indexado anterior. Una longitud incorrecta rechaza sin hash; la aceptación produce el registro de extracción y cuesta altura+1. Se prueba la cota para toda tabla y la extracción sin colisiones registradas. |
| [Bytes/Lectura](../../../../formalizacion/Nexus/Bytes/Lectura.lean) | 15 | Lectores con resto para prefijos, enteros LE, digest, campo, extensión y vectores. Se prueban ida/vuelta, rechazo por truncamiento, coordenada no canónica, longitud esperada incorrecta y cola en la envoltura EOF estricta. |
| [Bytes/Codec](../../../../formalizacion/Nexus/Bytes/Codec.lean) | 4 | Composición de codificadores y lectores de enteros, campos, productos, listas y transporte de estructuras. Ida/vuelta en el dominio de anchos explícitos, codificación inyectiva y lectura completa con rechazo de sufijos. |
| [Verificador/Certificado](../../../../formalizacion/Nexus/Verificador/Certificado.lean) | 7 | Estructuras y codec del certificado completo (TransitionStatement,LinkedProof): puntos AIR, capas FRI, compromisos, consultas y cabecera, con orden y anchos explícitos. Lectura con resto, lectura estricta, inyectividad, rechazo de cola y longitudes de enunciado/punto. La capa coincide con la serialización ya demostrada. |
| [Canal/SelectorOrdenado](../../../../formalizacion/Nexus/Canal/SelectorOrdenado.lean) | 5 | Selector en orden de primera aparición: conserva prefijos, no duplica índices y su proyección a conjuntos es exactamente el programa anterior sobre la misma tabla. Una ejecución aceptada entrega cuarenta índices distintos y una continuación aceptada. |
| [FRI/ProgramaVerificacion](../../../../formalizacion/Nexus/FRI/ProgramaVerificacion.lean) | 14 | Programa FRI que autentica izquierda/derecha antes del acarreo y rechaza longitudes incorrectas. Aceptación caracterizada por todas las autenticaciones, compatibilidades y constante final. El paso coincide con el paso Option anterior; se demuestra costo 2*(suma de alturas+número de capas). Cada apertura y la continuación aceptada están en el registro real del programa; todo el recorrido aceptado produce esos registros. |
| [Canal/DesafiosPrograma](../../../../formalizacion/Nexus/Canal/DesafiosPrograma.lean) | 10 | El canal entrega las dos coordenadas reducidas de cada E, tres alfas, todos los betas y los cuarenta índices en orden. Olvidar los valores de retos/raíces recupera los programas anteriores. La aceptación entrega longitudes exactas, índices sin duplicados y una continuación aceptada. Se prueba el presupuesto completo con trabajo rechazado y duplicados para toda tabla. |
| [Verificador/Forma](../../../../formalizacion/Nexus/Verificador/Forma.lean) | 5 | Forma previa al canal: 2^k filas para 4<=k<=12, perfil 12/20, versión 1, nonce de 64 bits, raíz compartida, cuarenta consultas, seis puntos y todos los caminos/capas con longitud correcta. Se extraen las cotas 16/4096 y las cantidades y formas de cada consulta. |
| [Verificador/Consulta](../../../../formalizacion/Nexus/Verificador/Consulta.lean) | 5 | Secuencia real de seis aperturas AIR, enlace de traza, FRI de traza, enlace de composición y FRI de composición. Se caracteriza la aceptación de todos los controles y se prueba el presupuesto de una consulta para toda tabla. La longitud AIR se comprueba antes de zip; si es incorrecta no se emiten hashes. |
| [Verificador/Completo](../../../../formalizacion/Nexus/Verificador/Completo.lean) | 15 | Ruta matemática completa desde el lector estricto hasta forma, canal, trabajo por ceros iniciales, índices ordenados y cuarenta consultas con ambas fases FRI. No se truncan listas desiguales por zip. La aceptación produce forma válida, tres alfas, k/k+1 betas, cuarenta índices distintos y todos los controles de las consultas. El presupuesto del programa y de su registro coincide con V_T, incluidos rechazos. Parseo fallido, forma inválida y sufijo estricto rechazan antes del hash; el nonce válido no introduce alias. |

## Contraste externo con Rust

Se conservan [50 casos y su relectura Python](../Verificador-Completo-Antecedentes/contraste/contraste-python.json),
25 por perfil de trabajo, incluyendo los catorce certificados históricos y
36 variantes. Ocho casos aceptan y 42 rechazan con EOF estricto. Los rechazos
cubren truncamiento, campo no canónico, filas, versión, perfil, raíz, cantidades,
caminos, nonce, aperturas AIR, enlaces y ambos FRI. Python coincide con la
aceptación o rechazo de Rust bajo esa envoltura para los mismos bytes.

Hay una diferencia deliberadamente conservada: **bincode::deserialize admite
los bytes sobrantes** de dos casos; la envoltura EOF estricta de Rust y Python
los rechaza, igual que el modelo de Lean. El helper usa las fuentes Rust
originales sin modificarlas y pasa cargo check, cargo test y build debug/release.
La prueba del paquete auxiliar no repite la suite completa de nexus. Se
conservan intentos fallidos de resolución offline y dependencia serde, junto
con los logs correctos finales. El lock reutiliza las resoluciones históricas.
El contraste ejecuta Rust y Python, sin ejecutar el verificador de Lean ni
demostrar equivalencia universal entre los tres.

## Matriz y verificación

Hay 33 modelos verificados en su alcance y siete grupos parciales, además de
tres dependencias bibliográficas, dos respaldos documentales y un trabajo
futuro QROM AIR/FRI. Los [criterios originales](../Verificador-Completo-Antecedentes/revision-criterios.json)
se conservan. 212 bloques del inventario y 216 de la revisión
tienen enlaces parciales, con 1108 enlaces que declaran su alcance.

| Grupo | Tema | Trabajo pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas. |
| M35 | Muestra compartida e hipergeométrica H | El canal conserva desafíos e índices en orden y su proyección a conjuntos está probada. Falta instanciar la ley uniforme ideal mediante claves frescas bajo las excepciones para todas las historias del ejecutable y adversario; no se retira la condición de frescura ni se supone independencia entre fases. |
| M36 | Solidez ideal por rondas y reinicios | Completar el adaptador integral de rondas y reinicios y obtener revisión independiente; el autor declaró que no hay dictamen. El compilador de programas finitos no identifica por sí solo los inicios B con consultas hash Q. |
| M37 | Extracción Merkle, bytes y orden temporal ROM | Las aperturas Merkle y recorridos FRI producen sus registros desde programas efectivos sobre una tabla común. Falta derivar familias causales y congelación antes de la primera exposición para todas las historias, incluyendo intercalaciones y consultas arbitrarias del adversario fuera de la gramática. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | El certificado y su lector matemático, formas, rechazos, canal y todas las aperturas ya están compuestos con presupuesto V_T demostrado. Falta refinamiento universal del parser serde/bincode, las otras operaciones de máquina y el ejecutable Rust. Se conserva la diferencia de EOF y el corte analítico R; el contraste de cincuenta casos es evidencia externa, no equivalencia universal. |
| M40 | Potencial de nonces y cola del selector | Construir los programas de los candidatos reales y sus conjuntos buenos con cotas antes de responder, además del trabajo/nonce y la tabla global. El compilador memoriza las repeticiones, pero no demuestra valor<=rho para esos candidatos ni la carga global de inicios. |
| M41 | Cota ROM completa y ejemplo numérico | Probar las inclusiones y leyes de los tres eventos bajo un mismo experimento del ejecutable, incluyendo adversario, sesgo, selector y presupuestos completos. La gramática, programa causal y cuenta del canal son componentes; no instancian todavía la cota numérica global. |

Compilación y auditoría de axiomas correctas. Se repiten los 207 replays con
un máximo de cuatro procesos, sin reutilizar módulos de otra auditoría.
El núcleo admite únicamente propext, Classical.choice y Quot.sound; confía
en importados, sin --fresh ni revisión independiente. Se fijan 631
fuentes y 213 logs canónicos. Pasan 21 controles Python.

Se conservan 16 versiones previas y 95 registros de fuentes/artefactos.
Los 5051 archivos de la edición anterior siguen recuperables. Capítulos,
salidas publicadas, TG1 y fuentes Rust conservan sus bytes.
[Comprobación de integridad](integridad-verificador-completo.json).
El autor declaró «No hay dictamen»; las corridas originales H1/H2 siguen
sin identificar. La seguridad integral y las obligaciones adicionales
mantienen su estado abierto.
