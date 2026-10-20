# Formalización de toda la matemática del manuscrito

**Objetivo del autor:** toda la matemática de la tesis debe tener representación
y trazabilidad en Lean. Este alcance incluye todos los capítulos y amplía el
catálogo inicial N01–N12. **Estado: en curso; la tesis completa no está verificada.**

## Inventario y criterio de cierre

[inventario-manuscrito.json](inventario-manuscrito.json) contiene un primer
barrido de **272 candidatos en ocho fuentes**: siete capítulos y el texto
preliminar. Registra texto, sección, línea y SHA-256 de cada fuente. El barrido
incluye fórmulas, enunciados, tablas, código y párrafos con indicadores
matemáticos; requiere revisión manual para corregir omisiones y falsos positivos.
El inventario tiene 212 bloques con enlaces y revisión parcial marcada.
La [revisión manual](REVISION-MANUSCRITO.md) conserva 272 candidatos, 14 omisiones
y 46 grupos. Su registro llega a 216 bloques y diez suplementos con enlaces.
La pasada de modelos añade 176 resultados: retículos euclídeos, plantilla FSwA,
derivación y épocas, transacciones, APT decimal, sesgo modular, cola y presupuestos,
comunicación, cota histórica, mediciones y modelos de quórum/incentivos.
Hay 34 modelos verificados en su alcance y 6 grupos parciales. La [ley conjunta del ROM finito](../Documentos/06-Evidencia-TG2/2026-10-18/Lean-Ley-Conjunta-ROM/README.md) identifica exactamente resultado y transcripción del muestreador con tablas uniformes del soporte derivado, sin condicionar a SinBad. La transferencia al selector ideal permanece abierta. Las [familias causales](../Documentos/06-Evidencia-TG2/2026-10-18/Lean-Familias-Causales/README.md) cierran M37 en el modelo clásico finito: soporte completo, prefijos de primera exposición, oráculos emitidos y riesgo de fallo de reconstrucción con altura<=S. La ley conjunta del selector, solidez integral y refinamiento Rust continúan abiertos. El [bloque causal del adversario](../Documentos/06-Evidencia-TG2/2026-10-18/Lean-Adversario-Causal/README.md) añade propuesta adaptativa, intercalaciones, ley local, cintas de índices y congelación derivada del registro efectivo; al cerrar esa pasada quedaban abiertas la ley global y las familias completas. La [ruta del verificador matemático](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Verificador-Completo/README.md) compone el lector, rechazos, canal, consultas y presupuesto; la equivalencia universal Rust sigue pendiente. La [pasada de certificado y gramática](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Certificado-Gramatica/README.md) cierra M31 con datos públicos concretos y conserva los límites de implementación. La [revisión de criterios](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Cierre-Criterios/Revision-Alcance.md) justifica once cierres sin cambiar sus criterios y conserva las obligaciones adicionales abiertas. No se demuestra
la cadena de reducciones ni el adaptador integral Rust/ROM. Tres candidatos y dos
suplementos TG2 cambian de texto con copia y hashes anteriores; sus identidades
y líneas se conservan. Exhaustividad, cierre global y dictamen siguen pendientes.

Los candidatos no son 272 teoremas independientes. Un párrafo puede contener
varias afirmaciones y un teorema puede cubrir varias apariciones. Por eso no
se usa el cociente de teoremas y candidatos como porcentaje de avance.

Cada bloque debe distinguir estas obligaciones:

| Clase | Tratamiento en Lean y condición de cierre |
|---|---|
| Definición | Tipos, objetos y relaciones que preserven la definición del manuscrito |
| Resultado propio | Enunciado, hipótesis explícitas y prueba aceptada por el núcleo |
| Cálculo o redondeo | Datos identificados, unidades y una igualdad o tolerancia demostrada |
| Modelo ideal | Resultado condicionado a sus supuestos, con el enlace al protocolo registrado aparte |
| Resultado bibliográfico | Dependencia identificada; permanece pendiente hasta disponer de su formalización o delimitar el uso condicional |
| Conjetura de dureza | Hipótesis explícita del modelo, conservando su carácter de conjetura |
| Medición | Evidencia de la ejecución y aritmética reproducible; Lean no transforma una medición en una verdad universal |

Declarar un axioma nuevo, introducir la conclusión como hipótesis o copiar una
fórmula sin demostrar sus propiedades no cierra una obligación de demostración.
Los nombres de los axiomas permitidos siguen siendo `propext`, `Classical.choice`
y `Quot.sound`. La correspondencia semántica con el manuscrito se revisa aparte
de la aceptación del término de prueba por el núcleo.

## Avance de esta etapa

Hay **2063 lemas y teoremas registrados en 234 módulos**. Las etapas anteriores conservaron
17, 40, 76, 98, 126, 148, 174, 205, 230, 257, 292, 316, 345, 366, 371, 393, 434, 466, 495, 521, 558, 601, 640, 679, 717, 753, 777, 864, 982, 1103 y 1217 resultados acumulados. Los módulos añadidos en estas etapas son:

| Módulo | Resultado |
|---|---|
| [ROM/PromediosCompletaciones](Nexus/ROM/PromediosCompletaciones.lean) | 4 resultados: Revelar una dirección nueva particiona las tablas compatibles en fibras del mismo tamaño. Se prueba la igualdad de medias para cualquier observable de toda la tabla y la equivalencia con la media uniforme desde la tabla vacía. |
| [ROM/LeyArbol](Nexus/ROM/LeyArbol.lean) | 8 resultados: Para cualquier árbol adaptativo finito, la media de una función de su resultado sobre tablas uniformes coincide con la evaluación que sortea solo respuestas nuevas y memoriza las repetidas. Se conserva la ley conjunta de resultado y transcripción completa; el valor inicial en direcciones no vistas es inmaterial. |
| [ROM/SoporteFinito](Nexus/ROM/SoporteFinito.lean) | 15 resultados: Se deriva del programa de bytes el soporte de todas sus ramas adaptativas. Restringir a un universo que lo contenga conserva resultado y registro. La ley del resultado es la del árbol con memoria y no depende de ampliar el universo finito. |
| [ROM/LeyMuestreoPrograma](Nexus/ROM/LeyMuestreoPrograma.lean) | 7 resultados: La tabla del plan crece por prefijos incluso si hay excepciones. Para cualquier observable del resultado, el mismo plan ROM de respuestas frescas tiene exactamente la ley de una función uniforme en el soporte del programa. Las repeticiones guardan su valor sin gastar respuesta fresca. |
| [ROM/ProgramaObservado](Nexus/ROM/ProgramaObservado.lean) | 11 resultados: Instrumentar el programa para devolver resultado y transcripción conserva consultas, altura, soporte y el propio plan de muestreo. Se obtiene igualdad exacta de la ley conjunta de resultado y registro del plan original con el ROM uniforme finito. |
| [ROM/PrefijosGlobales](Nexus/ROM/PrefijosGlobales.lean) | 9 resultados: El evento de igualdad de prefijos efectivos es exactamente el cilindro de sus direcciones observadas. Se cuenta su masa como |Digest|^(-u), con u direcciones distintas; una respuesta nueva es uniforme tras ese pasado fijo y una repetida distinta es imposible. |
| [Verificador/LeyConjunta](Nexus/Verificador/LeyConjunta.lean) | 9 resultados: Se instancia la ley conjunta con el programa completo de propuesta adaptativa de bytes e intercalaciones arbitrarias. Resultado y transcripción del mismo muestreador tienen exactamente la ley de tablas uniformes en su soporte. Se prueba la masa de cada prefijo real y la respuesta fresca uniforme tras ese pasado. |
| [Canal/RegistroRaices](Nexus/Canal/RegistroRaices.lean) | 9 resultados: Se despliegan los estados, eventos de absorción/retos y betas de los bucles del canal. Resultados y registros coinciden con los programas; las raíces conservan orden y cantidad y cada evento está en el prefijo real, sin suponer frescura. |
| [Canal/RegistroSelector](Nexus/Canal/RegistroSelector.lean) | 1 resultados: Una ejecución aceptada del selector produce cuarenta índices distintos en orden y una continuación aceptada cuyo registro es subsecuencia del efectivamente ejecutado, incluidos duplicados previos. |
| [Canal/RegistroCompleto](Nexus/Canal/RegistroCompleto.lean) | 8 resultados: La transcripción del canal completo se calcula desde H: raíz base, tres alfas, ambas listas de raíces/betas y estados. Se prueba su resultado y registro exactos, la pertenencia de cada absorción/reto y el soporte de la continuación elegida al aceptar. |
| [Merkle/AperturasPrograma](Nexus/Merkle/AperturasPrograma.lean) | 5 resultados: Las aperturas llevan raíz, altura, posición, valor y hermanos. Su autenticación y soporte se extraen del subprograma Merkle y se transportan al registro global; el valor coincide con el oráculo anterior al primer reto correspondiente. |
| [FRI/AperturasPrograma](Nexus/FRI/AperturasPrograma.lean) | 7 resultados: Se enumeran izquierda/derecha de cada capa FRI con el estado de acarreo efectivo. La aceptación produce autenticación y soporte de todas ellas, cantidad dos por capa, rango de índices y origen en la raíz y altura de esa capa. |
| [Verificador/SoporteConsulta](Nexus/Verificador/SoporteConsulta.lean) | 8 resultados: Una consulta aceptada registra exactamente seis aperturas AIR y todas las parejas FRI de traza/composición. Se compone el registro de sus subprogramas, se prueba autenticación, rango y origen de cada apertura y cantidad 6+2*k+2*(k+1). |
| [Verificador/SoporteCompleto](Nexus/Verificador/SoporteCompleto.lean) | 13 resultados: La aceptación completa entrega muestra y desafíos efectivos con soporte de la continuación. Se derivan todas las absorciones/retos y las aperturas de las cuarenta consultas desde el programa, con autenticación, rango, origen y cantidad 40*(6+2*k+2*(k+1)). No se reciben registros arbitrarios como premisas. |
| [Canal/FamiliasPrograma](Nexus/Canal/FamiliasPrograma.lean) | 6 resultados: Los eventos del registro global y SinBad construyen todos sus cortes de primera exposición. La tabla de cada corte es el prefijo exacto hasta la posición de la primera consulta; el oráculo depende de ese prefijo y es independiente del testigo elegido. La familia se captura como OraculosEmitidos y lee las aperturas aceptadas. |
| [Verificador/FamiliasAceptadas](Nexus/Verificador/FamiliasAceptadas.lean) | 6 resultados: Desde la aceptación con propuesta adaptativa de bytes y consultas arbitrarias intercaladas se construyen la familia AIR base y todas las capas FRI de traza/composición. Cada apertura efectiva coincide con su oráculo anterior al primer reto asociado. Solo se exige SinBad y aceptación; los hechos de registro se derivan. Las familias tienen k y k+1 capas. |
| [ROM/PlanPrograma](Nexus/ROM/PlanPrograma.lean) | 6 resultados: El programa finito de bytes se compila al plan de respuestas frescas y memoria: las repeticiones no consumen cuota fresca. Se obtiene la probabilidad exacta y cota adaptativa de excepciones. Sin excepción, la función de la tabla final reproduce la ejecución del programa y satisface SinBad. |
| [Verificador/ExperimentoCausal](Nexus/Verificador/ExperimentoCausal.lean) | 4 resultados: En el experimento muestreado sin excepción, una aceptación produce todas las familias congeladas. El evento de aceptar sin reconstruirlas implica excepción y su probabilidad está acotada por min(1,S*(49*S+B)/2^256), bajo el presupuesto de altura declarado. |
| [ROM/ProgramaBytes](Nexus/ROM/ProgramaBytes.lean) | 7 resultados: Programa finito con entradas de bytes arbitrarios y resultado de cualquier tipo. La secuencia concatena registros, conserva el resultado del programa TG2 levantado y tiene un presupuesto estructural finito. Cada par de su traza responde mediante la misma H y su tabla es compatible. |
| [ROM/ProyeccionDigest](Nexus/ROM/ProyeccionDigest.lean) | 7 resultados: Bijección de los 32 octetos del digest con Fin(256^32). El índice real de los primeros ocho octetos coincide con el residuo del entero completo para e<=64; cada índice tiene 2^(256-e) preimágenes y masa 1/2^e. Se conservan todos los promedios de funciones del índice. |
| [ROM/HistoriaLocal](Nexus/ROM/HistoriaLocal.lean) | 10 resultados: La estrategia del programa usa solo el prefijo de respuestas y su historia efectiva es compatible. Cada prefijo equivale a fijar exactamente sus entradas observadas, a lo sumo n. Sobre el universo finito de observadas más próxima entrada se cuenta la ley fresca 1/2^256; una repetición con respuesta distinta es imposible. |
| [ROM/EjecucionBytes](Nexus/ROM/EjecucionBytes.lean) | 12 resultados: El programa de bytes ejecuta una tabla compartida compatible con H: memoriza las nuevas entradas, conserva las repeticiones y registra todas las consultas reales. La ausencia de excepciones se verifica antes de cada respuesta fresca y produce un RecorridoSinAcierto. Los orígenes ordenados de absorción y reto se derivan de su pertenencia al registro efectivo, también cuando las llamadas actuales son repetidas. |
| [ROM/PalabrasDigest](Nexus/ROM/PalabrasDigest.lean) | 6 resultados: La proyección real de R digests independientes tiene fibras de tamaño (2^(256-e))^R. Conserva promedios y cocientes de eventos de palabras de índices. Se obtiene uniformidad de q-subconjuntos y el cociente hipergeométrico del selector condicionado a completar antes de R. |
| [Canal/Intercalaciones](Nexus/Canal/Intercalaciones.lean) | 7 resultados: Un adversario con estado puede consultar bytes arbitrarios antes de cada petición del protocolo y actualizarse después de su respuesta. El verificador matemático conserva resultado y su registro es una subsecuencia del global. El coste global es el coste del protocolo más las consultas adversarias, con cota Q+V_T y tabla efectiva común. |
| [Canal/CongelacionPrograma](Nexus/Canal/CongelacionPrograma.lean) | 4 resultados: Una apertura aceptada registrada en el programa global se encuentra en su tabla efectiva. Los primeros orígenes absorción/reto proporcionan un extractor que usa solo la tabla anterior a la primera respuesta del reto. Sus valores coinciden con toda apertura posterior registrada. Se instancia el origen en el verificador con intercalaciones. |
| [Canal/CintaSelector](Nexus/Canal/CintaSelector.lean) | 5 resultados: Para cualquier H, desplegar R respuestas de entradas I evalúa exactamente el programa real de selección, incluido su rechazo por corte. La proyección del selector ordenado se evalúa sobre la misma cinta; desde vacío completa exactamente cuando aparecen al menos cuarenta índices distintos. |
| [Verificador/Adversario](Nexus/Verificador/Adversario.lean) | 8 resultados: El proponente consulta entradas arbitrarias y elige adaptativamente los bytes del certificado y su estado. Se compone con el lector estricto y el verificador intercalado usando una sola H. La aceptación entrega un certificado leído con forma válida. Registros previos y del verificador quedan en el global, que tiene historia causal compatible y coste adversario más protocolo. |
| [ROM/RegistroPrograma](Nexus/ROM/RegistroPrograma.lean) | 12 resultados: Se recuperan los bytes exactos de cada clave; las entradas del programa cuentan sus respuestas y miden a lo sumo 79 octetos. La secuencia de programas conserva el rechazo, concatena el registro solo cuando acepta el primero y suma los presupuestos para toda tabla. |
| [Merkle/ProgramaVerificacion](Nexus/Merkle/ProgramaVerificacion.lean) | 13 resultados: Cada apertura Merkle se ejecuta como programa de peticiones de hoja y nodos en la tabla común. Resultado y registro coinciden con el evaluador indexado anterior. Una longitud incorrecta rechaza sin hash; la aceptación produce el registro de extracción y cuesta altura+1. Se prueba la cota para toda tabla y la extracción sin colisiones registradas. |
| [Bytes/Lectura](Nexus/Bytes/Lectura.lean) | 15 resultados: Lectores con resto para prefijos, enteros LE, digest, campo, extensión y vectores. Se prueban ida/vuelta, rechazo por truncamiento, coordenada no canónica, longitud esperada incorrecta y cola en la envoltura EOF estricta. |
| [Bytes/Codec](Nexus/Bytes/Codec.lean) | 4 resultados: Composición de codificadores y lectores de enteros, campos, productos, listas y transporte de estructuras. Ida/vuelta en el dominio de anchos explícitos, codificación inyectiva y lectura completa con rechazo de sufijos. |
| [Verificador/Certificado](Nexus/Verificador/Certificado.lean) | 7 resultados: Estructuras y codec del certificado completo (TransitionStatement,LinkedProof): puntos AIR, capas FRI, compromisos, consultas y cabecera, con orden y anchos explícitos. Lectura con resto, lectura estricta, inyectividad, rechazo de cola y longitudes de enunciado/punto. La capa coincide con la serialización ya demostrada. |
| [Canal/SelectorOrdenado](Nexus/Canal/SelectorOrdenado.lean) | 5 resultados: Selector en orden de primera aparición: conserva prefijos, no duplica índices y su proyección a conjuntos es exactamente el programa anterior sobre la misma tabla. Una ejecución aceptada entrega cuarenta índices distintos y una continuación aceptada. |
| [FRI/ProgramaVerificacion](Nexus/FRI/ProgramaVerificacion.lean) | 14 resultados: Programa FRI que autentica izquierda/derecha antes del acarreo y rechaza longitudes incorrectas. Aceptación caracterizada por todas las autenticaciones, compatibilidades y constante final. El paso coincide con el paso Option anterior; se demuestra costo 2*(suma de alturas+número de capas). Cada apertura y la continuación aceptada están en el registro real del programa; todo el recorrido aceptado produce esos registros. |
| [Canal/DesafiosPrograma](Nexus/Canal/DesafiosPrograma.lean) | 10 resultados: El canal entrega las dos coordenadas reducidas de cada E, tres alfas, todos los betas y los cuarenta índices en orden. Olvidar los valores de retos/raíces recupera los programas anteriores. La aceptación entrega longitudes exactas, índices sin duplicados y una continuación aceptada. Se prueba el presupuesto completo con trabajo rechazado y duplicados para toda tabla. |
| [Verificador/Forma](Nexus/Verificador/Forma.lean) | 5 resultados: Forma previa al canal: 2^k filas para 4<=k<=12, perfil 12/20, versión 1, nonce de 64 bits, raíz compartida, cuarenta consultas, seis puntos y todos los caminos/capas con longitud correcta. Se extraen las cotas 16/4096 y las cantidades y formas de cada consulta. |
| [Verificador/Consulta](Nexus/Verificador/Consulta.lean) | 5 resultados: Secuencia real de seis aperturas AIR, enlace de traza, FRI de traza, enlace de composición y FRI de composición. Se caracteriza la aceptación de todos los controles y se prueba el presupuesto de una consulta para toda tabla. La longitud AIR se comprueba antes de zip; si es incorrecta no se emiten hashes. |
| [Verificador/Completo](Nexus/Verificador/Completo.lean) | 15 resultados: Ruta matemática completa desde el lector estricto hasta forma, canal, trabajo por ceros iniciales, índices ordenados y cuarenta consultas con ambas fases FRI. No se truncan listas desiguales por zip. La aceptación produce forma válida, tres alfas, k/k+1 betas, cuarenta índices distintos y todos los controles de las consultas. El presupuesto del programa y de su registro coincide con V_T, incluidos rechazos. Parseo fallido, forma inválida y sufijo estricto rechazan antes del hash; el nonce válido no introduce alias. |
| [ROM/CertificadoLegado16](Nexus/ROM/CertificadoLegado16.lean) | 10 resultados: Dieciséis índices, consultas, ranuras y valores literales del certificado legado público de 16 filas. Se prueban las posiciones seleccionadas, nodos distintos, grado menor que 16, evaluaciones exactas, interpolación y recuperación de la segunda fila 5, también para cualquier traza compatible de ese grado. Rust y una relectura Python enlazan externamente los bytes concretos con esas constantes. |
| [Canal/GramaticaTG2](Nexus/Canal/GramaticaTG2.lean) | 12 resultados: Gramática conjunta de inicio, perfil, enunciado, raíces, fases, finales, nonce, E/I, trabajo y Merkle TG2 v1. Longitudes máximas de 79 octetos; las absorciones que coinciden con un nodo son de enunciado y se conserva un solapamiento explícito. No se separan artificialmente las tablas por rol. |
| [ROM/ProgramaCompartido](Nexus/ROM/ProgramaCompartido.lean) | 13 resultados: Claves finitas con longitud y hasta 79 octetos, iguales si y solo si sus bytes coinciden; el solapamiento entre roles comparte clave. Todo programa finito produce historia causal compatible, y se deriva la ley fresca y la repetida en cada prefijo. El compilador a árboles de candidatos memoriza por clave y no sortea otra respuesta en una repetición, incluso entre roles. |
| [Canal/ProgramaTG2](Nexus/Canal/ProgramaTG2.lean) | 7 resultados: Programa del canal con bytes de perfil y enunciado, tres alfas, dos fases FRI, trabajo, absorción de nonce y un selector compartido. Desde el recorrido se demuestra la cuenta 13+2*(longitudes de ambas listas de raíces)+R+C, con rechazo de trabajo y duplicados incluidos; se identifica con canalPerfil si las listas tienen longitudes k y k+1. |
| [FRI/IndicesMaquina](Nexus/FRI/IndicesMaquina.lean) | 7 resultados: Conversión, suma, división y módulo de USize se enlazan exactamente con naturales bajo cotas explícitas. Las seis posiciones AIR de TG2 coinciden con sus operaciones de máquina; sus sumas intermedias caben incluso en 32 bits para N<=32768 e i<N/2. Se instancia N=2^(k+3), k<=12. |
| [Cripto/AplicacionAutenticada](Nexus/Cripto/AplicacionAutenticada.lean) | 6 resultados: El contexto procede del registro de claves. Aceptar aplica el documento y consume el nonce atómicamente; repetir la solicitud rechaza. Bajo un contrato explícito de procedencia de firmas, admitir implica documento autorizado o colisión con un documento autorizado; excluir ese evento da autorización. |
| [Salud/Operaciones](Nexus/Salud/Operaciones.lean) | 6 resultados: Composición atómica de derivación por política y admisión de una operación. Sin evaluación, renovación pendiente o reevaluación sin rotación no se produce estado de operación; éxito exige política, consumo de uso y admisión. Una admisión fallida no produce estado nuevo. |
| [Complejidad/FamiliasCodificacion](Nexus/Complejidad/FamiliasCodificacion.lean) | 7 resultados: Biyeción de índices de cabecera y bits de cada coeficiente con posiciones del paquete. Codificación inyectiva, recuperación de todos los bits y longitud exacta. Cotas O para familias en las que cabecera, componentes, grado y ancho varían simultáneamente, con cota uniforme explícita de la cabecera. |
| [Modelos/DisponibilidadCondicional](Nexus/Modelos/DisponibilidadCondicional.lean) | 2 resultados: Muestreo DA sin reemplazo: espacio no vacío y probabilidad exacta de omitir fragmentos no disponibles, fijado el conjunto disponible antes de muestrear. Contraejemplo a intersección honesta con quórums inclusivos 2/3 y peso bizantino exactamente 1/3. |
| [MLDSA/CardinalRetos](Nexus/MLDSA/CardinalRetos.lean) | 7 resultados: Biyeción entre retos B_tau y elección de tau posiciones con un signo por posición. Cardinal exacto choose(256,tau)*2^tau, no vaciedad equivalente a tau<=256 y vacío fuera de dimensión. |
| [MLDSA/ProductoNTT](Nexus/MLDSA/ProductoNTT.lean) | 8 resultados: Las 256 evaluaciones en zeta*(zeta^2)^i anulan X^256+1. La evaluación del representante es multiplicativa, aditiva y biyectiva en Rq. Enlace del producto negacíclico con el producto coordenado de las dos transformadas recursivas. |
| [Complejidad/CosteNTT](Nexus/Complejidad/CosteNTT.lean) | 8 resultados: Cuenta exacta de mariposas de un plan radix dos que comparte las dos mitades. Para n=256: 1024 mariposas, 2048 sumas y 1024 productos; identidad n*log2(n) y cota del trabajo de campo. |
| [ROM/UniformidadSelector](Nexus/ROM/UniformidadSelector.lean) | 6 resultados: Toda permutación transporta la salida del selector. Se construye una biyección entre fibras de dos subconjuntos del mismo tamaño. Partición de las palabras completas y uniformidad exacta del q-subconjunto condicionada a completar antes de un corte fijo. |
| [ROM/LeySelector](Nexus/ROM/LeySelector.lean) | 5 resultados: Partición de selecciones completas contenidas en G. La probabilidad condicionada coincide exactamente con choose(cardG,q)/choose(M,q), satisface H(M,q,theta) y la cota exponencial. Composición aritmética de la mezcla con un fallo de masa tau. |
| [ROM/AcoplamientoSelector](Nexus/ROM/AcoplamientoSelector.lean) | 6 resultados: Ley racional normalizada que aborta con masa tau y, al completar, devuelve un q-subconjunto uniforme. Su variación total respecto de la muestra ideal es exactamente tau; todo evento pierde a lo sumo tau. Para el corte 512 y los nueve perfiles, la pérdida modelada es menor que 2^-300. |
| [ROM/FrescuraFinita](Nexus/ROM/FrescuraFinita.lean) | 6 resultados: Biyeción de completaciones de una tabla parcial con funciones en las claves libres y cardinal exacto. Cada respuesta en una clave ausente tiene masa condicionada 1/cardA; las respuestas repetidas están fijadas y una respuesta distinta es imposible. |
| [ROM/HistoriaCausal](Nexus/ROM/HistoriaCausal.lean) | 7 resultados: La estrategia depende de prefijos de respuestas. Para toda historia admisible, sus tablas compatibles equivalen a completaciones de las consultas vistas, con cardinal exacto. La siguiente respuesta fresca es uniforme condicionada a esa historia; repeticiones conservan respuesta y distintas consultas no superan la longitud del registro. |
| [Cripto/DecodificacionOperacion](Nexus/Cripto/DecodificacionOperacion.lean) | 10 resultados: Parser computable del sobre operation_bytes: comprueba dominio, 70 bytes de cabecera y longitud declarada exacta. Ida y vuelta, recodificación canónica, rango u64 de la longitud aceptada, rechazo de truncamientos, dominio y longitud incorrectos. |
| [Cripto/CiclosFirmados](Nexus/Cripto/CiclosFirmados.lean) | 13 resultados: Ejecución de listas de propuestas equivalente a una cadena de instalaciones firmadas. Época e historial crecen exactamente con la longitud, se conservan checkpoint, identidades y clave predeterminada. Épocas de propuestas distintas, rechazo persistente y rechazo de repetir cualquier propuesta aplicada; la época anterior deja de estar vigente. |
| [Merkle/RegistroVerificador](Nexus/Merkle/RegistroVerificador.lean) | 9 resultados: Evaluador Merkle que devuelve digest y consultas en orden desde la hoja; coincide con el bucle indexado y produce el registro exigido por extracción. Forma incorrecta rechaza sin hashes; aceptación registra cada entrada y cuesta altura+1 consultas. |
| [FRI/Recorrido](Nexus/FRI/Recorrido.lean) | 18 resultados: Bucle con Option, rechazo persistente, prefijos, posiciones, autenticación y acarreo extraídos de ejecución aceptada; ecuaciones de plegado y constante final, aceptación de una muestra y de ambas fases. Comprobaciones de longitudes de listas y rechazo con cero capas. |
| [Canal/AceptacionRecorridos](Nexus/Canal/AceptacionRecorridos.lean) | 4 resultados: Las dos ejecuciones FRI dan las premisas de aceptación compartida AIR/FRI con raíz inicial común, seis aperturas y enlace local. Cota de la rama de candidato no base a partir de controles de base de la muestra, sin exigir que el oráculo completo sea base. |
| [MLDSA/ContrasteJMW](Nexus/MLDSA/ContrasteJMW.lean) | 9 resultados: Gamma de extracción se deriva como max(gamma1-beta,2gamma2+1+2^(d-1)tau), dimensiones desde k+ell+1 y tipos Fin; conexión con N12, cuentas de los tres perfiles y fallo de la condición para todo etaAux>=1 y toda gamma mayor. |
| [MLDSA/Retos](Nexus/MLDSA/Retos.lean) | 10 resultados: Alfabeto concreto B_tau de polinomios con coeficientes centrados en {-1,0,1} y peso tau; norma uno y no nulidad para tau>0, soporte y construcción con signos. Instanciación de la relación SelfTarget con ese alfabeto. |
| [FRI/RetosAfines](Nexus/FRI/RetosAfines.lean) | 7 resultados: Cambio biyectivo entre beta y el peso afín en un representante no nulo, fórmula de mariposa y cardinales de preimágenes. Normalización global x=a*y con reto beta/a, equivalencia del plegado y conservación de uniformidad por conteo. |
| [Cripto/RotacionFirmada](Nexus/Cripto/RotacionFirmada.lean) | 7 resultados: Autorización saliente y posesión entrante se obtienen verificando firmas del mensaje tipado que incluye época y todas las claves siguientes. Instalación exige ambas, conserva identidades e historial y rechaza propuesta repetida o firma ausente. |
| [Cripto/OperacionBytes](Nexus/Cripto/OperacionBytes.lean) | 7 resultados: Formato de operation_bytes de registry.rs: dominio ASCII de 22 bytes, identidad de 32, época u64, longitud u64 y mensaje; cuenta 70+len, recuperación de campos e inyectividad. |
| [Salud/RachasCondicionales](Nexus/Salud/RachasCondicionales.lean) | 8 resultados: Cota de rachas con leyes condicionadas por símbolo inicial e historia repetida, sin exigir IID. Composición con el corte RCT, límites de rachas no fallidas y del incremento del contador u64 del perfil. |
| [Salud/InvariantesLote](Nexus/Salud/InvariantesLote.lean) | 8 resultados: Invariante muestras<65536 e histograma[i]<=muestras preservado por muestra, lote, recuperación y rotación; límites de incrementos de muestras/histograma y época rotada en u64. |
| [MLDSA/NTTAlgebra](Nexus/MLDSA/NTTAlgebra.lean) | 7 resultados: Transformada radix dos recursiva sobre árbol par/impar, grado del polinomio y corrección completa por inducción frente a evaluación en coset; raíz de mitad y raíz siguiente, unicidad por evaluaciones e instancia ML-DSA de 256 coeficientes con zeta=1753. |
| [Complejidad/ContadorFirma](Nexus/Complejidad/ContadorFirma.lean) | 9 resultados: Bloques de máscaras disjuntos, validez de índices u16, capacidad floor(65536/ell), incremento y rollover separados. Capacidades 16384/13107/9362 y fronteras de los tres perfiles; enlace con cola geométrica ideal. |
| [Complejidad/SerializacionPrueba](Nexus/Complejidad/SerializacionPrueba.lean) | 8 resultados: Conteo de bytes desde codificación de vectores y caminos: 8+32h por camino, 48+64h por capa FRI y suma de capas de longitud variable. Se separan 102 bytes fijos de prueba y 24 de enunciado; el certificado cuenta 126. |
| [FRI/FormasLimites](Nexus/FRI/FormasLimites.lean) | 9 resultados: Para k<=12, tamaños de dominio <=32768 y dentro de u64, mitades positivas e índices de ambas aperturas válidos; lecturas de listas aceptadas en rango, longitudes de zip y rechazo de longitudes incorrectas. |
| [Modelos/LayoutBackend](Nexus/Modelos/LayoutBackend.lean) | 6 resultados: Campos del PrivateKey histórico: 32+32+64 bytes y arreglos L,K,K de 256 i32. Suma y alineación declaradas, perfiles 12416/17536/23680 y enlace del perfil 65 con el modelo de memoria; reordenar conserva la suma. |
| [ROM/ReconstruccionPublica](Nexus/ROM/ReconstruccionPublica.lean) | 5 resultados: Dieciséis índices distintos de un dominio de 128 dan nodos distintos; interpolación recupera cualquier polinomio de grado<16 y, para la traza del ejemplo, la segunda fila 5. |
| [ROM/SelectorRechazo](Nexus/ROM/SelectorRechazo.lean) | 12 resultados: Proyección a conjuntos del selector con duplicados y parada: cardinal min(objetivo,distintas), terminación por suficientes distintas y equivariancia por permutaciones. Máscara binaria igual a residuo y fibras uniformes para potencias de dos. El selector incompleto coincide con pocas distintas y su probabilidad ideal tras 512 extracciones es <2^-300 en nueve perfiles. |
| [ROM/PotencialCandidatos](Nexus/ROM/PotencialCandidatos.lean) | 10 resultados: Potencial de árboles de pruebas frescas con creación adaptativa, intercalación, abandono, repeticiones y parada. Se demuestra riesgo<=potencialInicial+B*rho y desde vacío B*rho; trabajo se cobra antes de responder y se conserva el factor en la cota de inicios<=Q+1. |
| [ROM/ComposicionCotas](Nexus/ROM/ComposicionCotas.lean) | 7 resultados: Unión de tres eventos bajo una misma ley, transporte por variación total, composición de errores ROM/excepciones/consulta y suma de presupuestos. Se conserva la cota del juego ROM ya demostrado sin su mínimo con uno. |
| [ROM/EjemploNumerico](Nexus/ROM/EjemploNumerico.lean) | 4 resultados: Fórmula exacta de tres términos con mu, S=Q+V, presupuestos, hipergeométrica y cola. Para T=4096,g=20,Q=2^20 se certifica el intervalo (0.004757335453,0.004757335454]; para Q=2^28 la expresión truncada satura en uno. |
| [AIR/GradosValidos](Nexus/AIR/GradosValidos.lean) | 10 resultados: Factorización de fronteras válidas, cocientes de frontera de grado <=T-2, numeradores de frontera de grado <=2(T-1), cociente de transición de grado <=T y composición de grado <=T. Para trazas válidas, identidad racional fuera de polos y grado <2T. |
| [AIR/CancelacionSesgada](Nexus/AIR/CancelacionSesgada.lean) | 10 resultados: Cota de un evento con resultado único por la masa máxima. Ley conjunta por contexto y reto condicionado, unicidad de cancelación lineal y cota condicional. Para tres retos independientes con masas <=mu y residuos no todos nulos, cancelación <=mu; aplicación a una traza AIR fija inválida. |
| [AIR/EjemploCancelacion](Nexus/AIR/EjemploCancelacion.lean) | 33 resultados: Polinomio explícito sobre Goldilocks: 16 evaluaciones, cambio de primera fila de 3 a 4, invalidez, recurrencias restantes y resto combinado nulo para alpha0=10376293027944593777, alpha1=alpha2=1. Grado exacto de la traza 15, numerador 32 y composición 16. Existe una traza válida alternativa con la misma salida pública. |
| [Reticulos/Euclideos](Nexus/Reticulos/Euclideos.lean) | 23 resultados: Span entero de una familia real independiente, rango y dimensión intrínseca, combinaciones inyectivas y finitud en bolas. Mínimos sucesivos definidos por radios; monotonía, primer mínimo positivo y alcanzado. Relaciones SVP/SIVP/GapSVP y promesa disjunta. |
| [MLDSA/Plantilla](Nexus/MLDSA/Plantilla.lean) | 7 resultados: Plantilla FSwA con dimensiones, respuesta z, reconstrucción Az-ct=Ay-cs2, pistas booleanas, cotas de norma y peso, intento con rechazo y corrección condicionada a reconstrucción de pistas y reto. |
| [Cripto/Variacion](Nexus/Cripto/Variacion.lean) | 8 resultados: Leyes racionales finitas normalizadas, variación total y cota de cualquier evento; productos independientes y pérdida aditiva, con iteración para m factores. |
| [ROM/Sesgo](Nexus/ROM/Sesgo.lean) | 17 resultados: Conteo exacto de preimágenes de x mod p sobre S valores; ley normalizada, Delta=r(p-r)/(pS), masa máxima y cuadrado para pares independientes. Cota de eventos para m retos de dos coordenadas y números Goldilocks, incluido 56Delta<7.069e-28. |
| [Cripto/Derivacion](Nexus/Cripto/Derivacion.lean) | 14 resultados: Formato de dominio Sentinel, dos contadores de ocho bytes, semilla de 32 bytes y contexto; inyectividad, reproducibilidad de hash/KeyGen deterministas, separación de entradas de rotación y derivación, y colisión explícita si entradas distintas dan la misma salida. |
| [Cripto/RegistroEpocas](Nexus/Cripto/RegistroEpocas.lean) | 15 resultados: Estado por identidad y época, preparación de lote, instalación atómica bajo controles, conservación de identidad predeterminada e historial, vigencia actual y rechazo de época retirada. Prefijo confiable, truncación posterior indetectable por punto antiguo y hash de prefijo o colisión. |
| [Cripto/Transacciones](Nexus/Cripto/Transacciones.lean) | 8 resultados: Documento con identidad, época, cadena, nonce y contenido, codec matemático con longitud y decodificación inversa. Admisión anterior al cambio de estado, controles de cadena/nonce, consumo que evita repetición y cambio de contenido que exige otro hash o colisión. |
| [Modelos/IdealHistorico](Nexus/Modelos/IdealHistorico.lean) | 8 resultados: Fórmula histórica con error por rondas, omisión y unión conservadora, conservada separada de la fórmula refinada. Techo para el número de parejas, cuatro redondeos superiores de la tabla 6.19 y unión de cuatro eventos PMF bajo inclusión y cotas individuales. |
| [ROM/RaicesCanonicas](Nexus/ROM/RaicesCanonicas.lean) | 10 resultados: Puente legado de raíz a campo mediante ocho bytes LE y reducción; dominio canónico inyectivo, cola de 24 bytes ignorada, alias concretos 0/p e índices congruentes. Recuperación polinómica desde suficientes aperturas públicas distintas. |
| [Complejidad/Comunicacion](Nexus/Complejidad/Comunicacion.lean) | 9 resultados: Conteo de caminos, capas y consultas del formato TG2 declarado; cota cuadrática y O(q log²N), tabla de cuatro tamaños y LDE. Cotas para bits de claves y firmas con anchos y cabeceras explícitos. |
| [Modelos/QuorumIncentivos](Nexus/Modelos/QuorumIncentivos.lean) | 9 resultados: Pesos de stake normalizados e intersección honesta con umbrales estrictos o inclusivos correctos. Juego de pagos explícito: condición necesaria y suficiente de Nash y desviación unilateral rentable. Recuperación Reed-Solomon condicionada y contraejemplo a recuperación por mera duplicación. |
| [Modelos/Mediciones](Nexus/Modelos/Mediciones.lean) | 18 resultados: Racionales extraídos de dos JSON R4 conservados: 175 redondeos dentro de 0.005 y ocho razones de rendimiento. Diferencia de medianas sin redondear, razones históricas H1/H2, inverso ideal de latencia, crecimiento y corrección KiB/firmas: aproximadamente 238, no 232. |
| [ROM/ColaSelector](Nexus/ROM/ColaSelector.lean) | 11 resultados: Inyección de secuencias con a lo sumo q valores distintos en testigos de subconjunto; cota cardinal binomial(M,q)q^R y cola uniforme min(1,binomial(M,q)(q/M)^R). Para q=39,R=512 y los nueve perfiles, tau<2^-300. Se explicita que condicionar a trabajo válido elimina su factor. |
| [Salud/DecimalesAPT](Nexus/Salud/DecimalesAPT.lean) | 6 resultados: Intervalo racional para 2^-7.5, pesos binomiales encerrados, cola partida y resto geométrico. Certifica cola del corte 15 como 1.523e-6 con error<5e-10 y del corte 16 como 2.764e-7 con error<5e-11; complementa la minimalidad ya probada. |
| [Cripto/PerdidaQROM](Nexus/Cripto/PerdidaQROM.lean) | 7 resultados: Fórmula L_Q citada y parámetros de referencia B+23. Se prueba positividad, L_Q<2^-360 e intervalo del logaritmo con |log2(L_Q)+361.64|<0.005 mediante cuadrados, racionales y monotonía del logaritmo. |
| [ROM/Presupuestos](Nexus/ROM/Presupuestos.lean) | 6 resultados: Forma tipada de seis aperturas AIR y dos por capa FRI, longitudes y hashes de rutas. Fórmulas de caminos, hojas, etiquetas, canal y retos, monotonía del corte y suma de presupuestos. Extremos T=16/4096: V=6943/24895 y B=5450/22106. |
| [Cripto/Probabilidad](Nexus/Cripto/Probabilidad.lean) | 20 resultados: PMF, eventos, soporte, productos independientes y uniformes finitas |
| [Cripto/Oraculo](Nexus/Cripto/Oraculo.lean) | 8 resultados: Consultas adaptativas, presupuesto e historias consistentes |
| [MLDSA/Representantes](Nexus/MLDSA/Representantes.lean) | 15 resultados: Coeficientes, reducción y levantamiento centrado concreto |
| [MLDSA/Cortos](Nexus/MLDSA/Cortos.lean) | 11 resultados: Conjunto S_eta, cardinalidad exacta e inyectividad de la reducción |
| [MLDSA/MSIS](Nexus/MLDSA/MSIS.lean) | 14 resultados: Relación MSIS y extracción con representantes dados o canónicos |
| [MLDSA/MLWE](Nexus/MLDSA/MLWE.lean) | 17 resultados: Leyes real/ideal, juegos y contraste del caso sin ruido |
| [MLDSA/SelfTarget](Nexus/MLDSA/SelfTarget.lean) | 10 resultados: Relación tipada y juego clásico con tabla finita |
| [Cripto/Firma](Nexus/Cripto/Firma.lean) | 11 resultados: Corrección y juegos EUF/sUF con consultas y registros |
| [Cripto/Seguridad](Nexus/Cripto/Seguridad.lean) | 8 resultados: Familias despreciables, implicación sUF→EUF y separación de eventos |
| [MLDSA/Parametros](Nexus/MLDSA/Parametros.lean) | 21 resultados: Primalidad, raíces, perfiles y aritmética del formato declarado |
| [MLDSA/Anillos](Nexus/MLDSA/Anillos.lean) | 17 resultados: Cocientes negacíclicos, representantes, reducción y cardinalidades |
| [MLDSA/Normas](Nexus/MLDSA/Normas.lean) | 15 resultados: Representantes centrados, normas y polinomios pequeños |
| [AIR/DistanciaExacta](Nexus/AIR/DistanciaExacta.lean) | 14 resultados: Acuerdos, aproximante y mínimo de distancia alcanzado |
| [AIR/Perturbacion](Nexus/AIR/Perturbacion.lean) | 13 resultados: Grado T, filas y validez conservadas, distancias al testigo y al código |
| [AIR/ComposicionAlejada](Nexus/AIR/ComposicionAlejada.lean) | 12 resultados: Grados exactos, composición acotada y evaluación racional |
| [AIR/CocientesAlejados](Nexus/AIR/CocientesAlejados.lean) | 9 resultados: Anulador de T−2 transiciones y cociente de grado T+2 |
| [AIR/Interpolacion](Nexus/AIR/Interpolacion.lean) | 8 resultados: Recurrencia, transporte e interpolante válido construido |
| [AIR/ContraejemploGoldilocks](Nexus/AIR/ContraejemploGoldilocks.lean) | 12 resultados: Construcción base/extensión desde 3 y 5 y contraejemplo conjunto |
| [Modelos/ResidenciaIntegral](Nexus/Modelos/ResidenciaIntegral.lean) | 29 resultados: Integral por regiones, unión de intervalos, medias y enlace a la tabla 5.2 |
| [Modelos/CapturaUniforme](Nexus/Modelos/CapturaUniforme.lean) | 13 resultados: Ley uniforme continua, coincidencia temporal y porcentajes de la tabla 5.2 |
| [Modelos/Memoria](Nexus/Modelos/Memoria.lean) | 11 resultados: Representaciones R5 y cuentas de contenedores y copias |
| [Modelos/AmortizacionVariable](Nexus/Modelos/AmortizacionVariable.lean) | 15 resultados: Prueba variable, límites, equilibrio y sensibilidad de §6.6.5 |
| [Complejidad/NTT](Nexus/Complejidad/NTT.lean) | 24 resultados: Recurrencia radix dos, fórmulas cerradas y cotas gruesa y optimizada |
| [Complejidad/Rechazo](Nexus/Complejidad/Rechazo.lean) | 19 resultados: Ley geométrica, integrabilidad, esperanza, agotamiento y costo esperado |
| [Complejidad/Firma](Nexus/Complejidad/Firma.lean) | 7 resultados: Composición NTT/rechazo y contraejemplo sin barra uniforme |
| [Entropia/Minima](Nexus/Entropia/Minima.lean) | 15 resultados: Min-entropía, adivinación óptima, productos independientes, bloques IID y contraejemplo correlacionado |
| [Entropia/Shannon](Nexus/Entropia/Shannon.lean) | 8 resultados: Frecuencias empíricas, soporte y cota de cinco bits para 32 bytes |
| [Salud/RCT](Nexus/Salud/RCT.lean) | 9 resultados: Techo, minimalidad, corte cuatro y cota de falsas alarmas IID |
| [Salud/Binomial](Nexus/Salud/Binomial.lean) | 12 resultados: Ley binomial de mathlib, colas finitas, recurrencia y dominación geométrica |
| [Salud/APT](Nexus/Salud/APT.lean) | 9 resultados: Certificado racional del corte mínimo 16 para B=1+Bin(511,2^-7,5) |
| [Salud/Monitor](Nexus/Salud/Monitor.lean) | 13 resultados: Contadores RCT/APT, ventanas, alarmas, fallo retenido e invariantes |
| [Salud/Fuente](Nexus/Salud/Fuente.lean) | 21 resultados: Lotes, derivación, recuperación, renovación y conservación del monitor al rotar |
| [AIR/Enunciado](Nexus/AIR/Enunciado.lean) y [AIR/Solucion](Nexus/AIR/Solucion.lean) | 12 resultados: divisibilidad, cocientes de frontera, cardinal del dominio, identidad del anulador con X^T−1, equivalencia de validez y residuos, linealidad del resto y conexión con cancelación |
| [Modelos/Costos](Nexus/Modelos/Costos.lean) | 6 resultados sobre throughput, límite real de amortización, monotonía, piso, equilibrio y cuentas del capítulo 3 |
| [Modelos/Residencia](Nexus/Modelos/Residencia.lean) | 4 resultados sobre cotas del modelo y los quince redondeos de la tabla 5.2 |
| [Reticulos/Preimagenes](Nexus/Reticulos/Preimagenes.lean) | Lema 6.1 general con mapas aditivos de reducción y de aplicación de B |
| [Campos/Goldilocks](Nexus/Campos/Goldilocks.lean) | 20 resultados: primalidad por Lucas, generador 7, raíces para k≤32 y su coherencia, irreducibilidad de X²−7, cardinales y fórmulas de la extensión |
| [AIR/Grados](Nexus/AIR/Grados.lean) | 7 resultados: grados de reescalado, transición, fronteras, denominador y combinación |
| [AIR/Goldilocks](Nexus/AIR/Goldilocks.lean) | 9 resultados: equivalencia y cancelación concretas, cosets de cardinal 8T sin polos y cota de distancia para la composición concreta |
| [Distancia/Propiedades](Nexus/Distancia/Propiedades.lean) | 5 resultados: no negatividad, simetría, desigualdad triangular y conteo bajo reindexaciones inyectivas |
| [AIR/Localidad](Nexus/AIR/Localidad.lean) | 9 resultados: composición local, igualdad polinómica y racional, localidad en tres puntos, cota 3ε y transferencia racional/real |
| [AIR/Transferencia](Nexus/AIR/Transferencia.lean) | 7 resultados: periodicidad de índices, clausura del coset, desplazamientos LDE, transferencia concreta y margen mayor que 1/2 |
| [Modelos/DistanciaAIR](Nexus/Modelos/DistanciaAIR.lean) | Tabla 6.16: N=8T en las cinco filas y los diez redondeos hacia abajo |
| [Campos/Polinomios](Nexus/Campos/Polinomios.lean) | 11 resultados: descomposición f=A+zB, grados de las partes, evaluación de B y caracterización de coeficientes/valores base |
| [N03/CampoBase](Nexus/N03/CampoBase.lean) | 6 resultados: a lo sumo T−1 valores base de un candidato no base y fracción no base del oráculo próximo, con tolerancias racionales y reales |
| [N03/Perfil](Nexus/N03/Perfil.lean) | 7 resultados: cotas concretas, fracción >3/4 para δ≤1/8, comparación con d y unicidad del perfil |
| [N03/Alternativa](Nexus/N03/Alternativa.lean) | 4 resultados: validez AIR preservada y reflejada por la inmersión, invalidez del candidato base y alternativa algebraica |
| [N04/RadioReal](Nexus/N04/RadioReal.lean) | 3 resultados: lema A con radio real y márgenes de todas las capas de traza y composición para θ=1/8 |
| [N04/Plegado](Nexus/N04/Plegado.lean) | 4 resultados: grado y evaluación de A(X²)+XB(X²), recomposición par/impar y recuperación de una capa sobre ambas mitades del mismo conjunto de acuerdo |
| [N05/Cotas](Nexus/N05/Cotas.lean) | 8 resultados: comparación binomial, cota hipergeométrica H con techo, caso cero, antitonicidad y cota H≤(1−θ)^q |
| [N05/Parejas](Nexus/N05/Parejas.lean) | 4 resultados: discrepancias≤2·parejas malas, techo de θM y cotas hipergeométrica y exponencial de omisión |
| [Modelos/Omision](Nexus/Modelos/Omision.lean) | 3 resultados: redondeos refinados de la tabla 6.22, disponibilidad de 40 parejas y techo T/2 para los nueve perfiles implementados |
| [FRI/Dominios](Nexus/FRI/Dominios.lean) | 10 resultados: independencia del representante, raíces opuestas, mitades disjuntas, cardinal doble y conservación de densidad al cuadrar |
| [FRI/Torre](Nexus/FRI/Torre.lean) | 9 resultados: dominios y grados positivos, recorridos y densidades, controles excepcionales, recuperación desde la constante final, distancia desde el acuerdo y lema B |
| [FRI/Muestreo](Nexus/FRI/Muestreo.lean) | 2 resultados: cotas hipergeométrica y exponencial deducidas del recorrido completo de una torre finita abstracta |
| [FRI/Presupuesto](Nexus/FRI/Presupuesto.lean) | 5 resultados: grados y cardinales por capa, conservación de la razón dominio/grado y suma telescópica de cardinales excepcionales |
| [FRI/Cosets](Nexus/FRI/Cosets.lean) | 20 resultados: coherencia de raíces, opuestos, cosets sucesivos, índices únicos, representantes y enlace geométrico entre dominios |
| [FRI/Goldilocks](Nexus/FRI/Goldilocks.lean) | 8 resultados: torres concretas de ambas fases, grados, dominios finales, márgenes, presupuestos y muestreo completo para θ=1/8 |
| [FRI/Indices](Nexus/FRI/Indices.lean) | 3 resultados: índice pos mod (n/2), selección de la mitad y fórmula algebraica del plegado de a,a+n/2 |
| [N06/Experimento](Nexus/N06/Experimento.lean) | 12 resultados: medias exactas, espacio de |K|^n retos, conteo del escape absorbente, cotas entre cero y uno y unión adaptativa |
| [FRI/Adaptativo](Nexus/FRI/Adaptativo.lean) | 9 resultados: controles del oráculo actual, dependencia del prefijo, recuperación, lema B, muestreo y probabilidad telescópica de excepciones con estrategias adaptativas |
| [N06/Goldilocks](Nexus/N06/Goldilocks.lean) | 4 resultados: probabilidad por capa, probabilidades de excepciones por fase y consulta condicionada de cuarenta parejas en las torres concretas |
| [N06/Candidato](Nexus/N06/Candidato.lean) | 6 resultados: selector parcial, propiedad, existencia condicional, unicidad y dependencia exclusiva del oráculo sobre el dominio |
| [N06/Cancelacion](Nexus/N06/Cancelacion.lean) | 10 resultados: último residuo no nulo, ronda crítica, escape secuencial equivalente a cancelación total y cota ≤1/|K| |
| [N06/SeleccionAIR](Nexus/N06/SeleccionAIR.lean) | 7 resultados: candidato previo a los retos, tres ramas de traza, residuos concretos y cota secuencial 1/p² |
| [N06/Composicion](Nexus/N06/Composicion.lean) | 4 resultados: escape iff resto combinado nulo, transferencia desde el candidato seleccionado y alternativa lejana/enlace de composición |
| [N06/Consulta](Nexus/N06/Consulta.lean) | 12 resultados: probabilidad de aceptación de una muestra, parejas buenas, fallos puntuales y cota H para predicados locales |
| [FRI/Consulta](Nexus/FRI/Consulta.lean) | 8 resultados: recorridos como imágenes, aceptación por parejas individuales, construcción de las parejas aceptantes y cota H para la muestra FRI aceptada |
| [N06/Parejas](Nexus/N06/Parejas.lean) | 5 resultados: identificación de fallos base/enlace y muestreo sobre los representantes concretos Goldilocks |
| [N06/Compartida](Nexus/N06/Compartida.lean) | 10 resultados: radios, máximo de casos, única consulta compartida para prefijos seguros, promedios, ponderaciones y q=40 |
| [N06/Transcripcion](Nexus/N06/Transcripcion.lean) | 6 resultados: retos finitos, historias, equivalencia de no escape y cota de un valor terminal fuera de excepciones |
| [FRI/Experimento](Nexus/FRI/Experimento.lean) | 4 resultados: conteo de prefijos inseguros, cota terminal y aceptación FRI promediada sobre retos y consulta |
| [N06/Ejecucion](Nexus/N06/Ejecucion.lean) | 5 resultados: traza inicial anterior a AIR, cotas terminales concretas AIR/FRI y correspondencia de coeficientes |
| [N06/Solidez](Nexus/N06/Solidez.lean) | 9 resultados: invariantes de ramas, cota terminal conjunta, probabilidad de prefijos inseguros, solidez interactiva, q=40 y enlace con los cuatro superiores de la tabla 6.22 |
| [N06/Estado](Nexus/N06/Estado.lean) | 8 resultados: marca booleana absorbente, recursión equivalente a Escapa, conservación y probabilidad de una transición nueva |
| [N06/Monitores](Nexus/N06/Monitores.lean) | 5 resultados: monitor AIR crítico y cotas condicionales de AIR y de ambas fases FRI |
| [N06/EstadoConjunto](Nexus/N06/EstadoConjunto.lean) | 8 resultados: conservación entre fases, ramas activas, cancelación AIR y estado cero iff prefijo seguro |
| [N06/PorRondas](Nexus/N06/PorRondas.lean) | 8 resultados: inicio, mensajes, rechazo final, aceptación, cota de consulta y certificado por rondas con h_T escogida en los nueve perfiles |
| [N06/Reinicios](Nexus/N06/Reinicios.lean) | 7 resultados: árboles adaptativos con registro, restauraciones, conservación de marcas y cota min(1,B·epsilon) |
| [N06/PrimerCambio](Nexus/N06/PrimerCambio.lean) | 5 resultados: primer cambio excepcional, aceptación de un registro y promedio de planes con semilla finita uniforme |
| [N06/Muestras](Nexus/N06/Muestras.lean) | 3 resultados: invariancia del promedio entre instancias finitas, muestras no vacías y equivalencia de la media uniforme con probabilidadConsulta |
| [N06/ReiniciosIdeal](Nexus/N06/ReiniciosIdeal.lean) | 6 resultados: respuestas AIR/FRI/consulta, aceptación marcada, enlace con CertificadoRondas y cota min(1,B·h_T) en los nueve perfiles |
| [N06/ReiniciosAdaptativos](Nexus/N06/ReiniciosAdaptativos.lean) | 5 resultados: políticas por petición, aceptación marcada, cota local uniforme, min(1,B·h_T) y promedio de planes con semilla finita uniforme |
| [N06/Prefijos](Nexus/N06/Prefijos.lean) | 6 resultados: longitud e historia de retos, extensión cronológica y actualización exacta del acumulador y la marca |
| [N06/TranscripcionCausal](Nexus/N06/TranscripcionCausal.lean) | 8 resultados: estado inicial uno iff enunciado válido, marca reconstruida, pasos sin monedas, proyección exacta y estado final cero implica rechazo |
| [N06/SolidezCausal](Nexus/N06/SolidezCausal.lean) | 8 resultados: transporte de la cota local, absorción, aceptación marcada, respuestas no vacías y plan restaurable de mensajes tipados con cota min(1,B·h_T) |
| [N06/CongruenciaPrefijos](Nexus/N06/CongruenciaPrefijos.lean) | 2 resultados: igualdad de marcas sobre la historia recorrida y de aceptación FRI sobre las capas efectivas |
| [N06/PoliticasCompatibles](Nexus/N06/PoliticasCompatibles.lean) | 10 resultados: congruencia de residuos, monitores, marcas, aceptación y estado sobre el prefijo |
| [N06/TerminalesConstantes](Nexus/N06/TerminalesConstantes.lean) | 8 resultados: capas terminales fijadas a las constantes, conservación de mensajes y marca anterior a consultar, y cota heredada |
| [N06/MensajesCompatibles](Nexus/N06/MensajesCompatibles.lean) | 10 resultados: equivalencia por mensajes emitidos, estado invariante, cociente observado e intercambio de política compatible |
| [N06/ReiniciosObservados](Nexus/N06/ReiniciosObservados.lean) | 11 resultados: aceptación sobre el cociente, rechazo en cero, estado válido, raíz única, absorción, cota local universal y reinicios con políticas por petición |
| [N06/OraculosEmitidos](Nexus/N06/OraculosEmitidos.lean) | 5 resultados: arreglos finitos, lectura y captura inversas e igualdad caracterizada por las capas |
| [N06/DatosTranscripcion](Nexus/N06/DatosTranscripcion.lean) | 9 resultados: datos de cada fase, igualdad de capturas iff mismos mensajes y política fija que reproduce cada prefijo individual |
| [N06/TranscripcionExplicita](Nexus/N06/TranscripcionExplicita.lean) | 11 resultados: equivalencia biyectiva de representaciones, preservación de estado y aceptación, estado inicial, rechazo en cero y mensajes capturados |
| [N06/RondasExplicitas](Nexus/N06/RondasExplicitas.lean) | 7 resultados: peticiones explícitas, correspondencia de origen y destino, absorción, igualdad del cambio y cotas locales generales y de perfiles |
| [N06/ExtensionRetos](Nexus/N06/ExtensionRetos.lean) | 6 resultados: historia anterior inalterada y destino explícito independiente de la política que realiza los mensajes del origen |
| [N06/PasosExplicitos](Nexus/N06/PasosExplicitos.lean) | 4 resultados: restricción a los mensajes anteriores, correspondencia exacta de pasos y conservación del estado |
| [N06/PlanesExplicitos](Nexus/N06/PlanesExplicitos.lean) | 6 resultados: raíz, evaluación propia, expansión genérica, aceptación marcada y cotas de reinicios generales y de perfiles |
| [N06/TraduccionPlanes](Nexus/N06/TraduccionPlanes.lean) | 13 resultados: transporte completo en ambos sentidos para cada función terminal, igualdad de valores y probabilidades de aceptación, con registro y presupuesto preservados |
| [Merkle/Registro](Nexus/Merkle/Registro.lean) | 6 resultados: búsqueda inversa en consultas, unicidad sin colisiones locales y conservación de la búsqueda al añadir consultas sin acierto |
| [Merkle/Extraccion](Nexus/Merkle/Extraccion.lean) | 6 resultados: 2^altura rutas, extracción completada, coincidencia de aperturas aceptadas y registradas y vinculación de valores |
| [Merkle/Etiquetas](Nexus/Merkle/Etiquetas.lean) | 7 resultados: raíz, salidas e hijos marcados, cota local 3·longitud+1 y novedad de una consulta segura |
| [Merkle/Temporal](Nexus/Merkle/Temporal.lean) | 7 resultados: ausencia de colisiones y estabilidad del vector bajo extensión segura; una apertura posterior coincide con la extracción congelada |
| [Bytes/LittleEndian](Nexus/Bytes/LittleEndian.lean) | 5 resultados: longitud, cotas, recuperación de enteros y bytes e inyectividad de la conversión LE |
| [Merkle/Codificacion](Nexus/Merkle/Codificacion.lean) | 10 resultados: bytes canónicos de Fp2, hojas de 17 bytes y nodos de 65, decodificación inversa, reconstrucción exacta y cardinal 2^256 de digests |
| [Merkle/Ventanas](Nexus/Merkle/Ventanas.lean) | 7 resultados: cota de 48 ventanas, cobertura de hijos en offsets 1/33 y raíz en offset 41 de una absorción de 73 bytes |
| [Merkle/MarcasGlobales](Nexus/Merkle/MarcasGlobales.lean) | 15 resultados: cardinal global de marcas, cobertura del extractor concreto, apertura de raíz absorbida y riesgo ≤(49S+B)/2^256 para una respuesta uniforme nueva |
| [ROM/Memoria](Nexus/ROM/Memoria.lean) | 9 resultados: tabla sin entradas duplicadas, búsqueda conservada, repeticiones con respuesta fija y almacenamiento de entradas nuevas |
| [ROM/Juego](Nexus/ROM/Juego.lean) | 8 resultados: marcas de respuestas almacenadas, estados y solicitudes adaptativos, cardinal previo ≤49S+B y crecimiento de marcas |
| [ROM/Probabilidad](Nexus/ROM/Probabilidad.lean) | 8 resultados: probabilidad exacta por conteo, cotas entre cero y uno y unión adaptativa min(1,S(49S+B)/2^256) desde vacío |
| [ROM/RegistroFinal](Nexus/ROM/RegistroFinal.lean) | 18 resultados: ejecución del plan sin acierto, compatibilidad de tablas, ausencia de colisiones y apertura posterior igual al vector calculado con la tabla al congelar |
| [ROM/Preparacion](Nexus/ROM/Preparacion.lean) | 9 resultados: paso con respuesta memorizada, cobertura de etiquetas antes de responder y persistencia de marcas preparadas en consultas nuevas y repetidas |
| [ROM/CongelacionPrevia](Nexus/ROM/CongelacionPrevia.lean) | 5 resultados: composición de extensiones seguras, vector calculado antes de la respuesta actual y coincidencia de aperturas posteriores |
| [Canal/Entradas](Nexus/Canal/Entradas.lean) | 17 resultados: campos y longitud de absorción, retos F/E/I y trabajo u64, inyectividad por formato y solapamiento explícito absorción/nodo Merkle |
| [Canal/Raices](Nexus/Canal/Raices.lean) | 8 resultados: raíz marcada antes de responder, absorción y reto con estado encadenado, vector fijado antes de ambas respuestas y vinculación posterior |
| [ROM/Frescura](Nexus/ROM/Frescura.lean) | 6 resultados: una respuesta nueva evita ventanas previas y actuales; toda entrada que la contenga sigue ausente inmediatamente después |
| [ROM/Origen](Nexus/ROM/Origen.lean) | 11 resultados: prefijos de tabla y cortes de primera consulta con solicitud, tabla anterior y recorridos a ambos lados |
| [ROM/OrdenConsultas](Nexus/ROM/OrdenConsultas.lean) | 10 resultados: posición canónica, orden estricto entre dependencias por ventanas y relación bien fundada |
| [Canal/PrimerasConsultas](Nexus/Canal/PrimerasConsultas.lean) | 12 resultados: prefijos de estado cubiertos, reto nuevo tras respuesta nueva, orígenes ordenados y vector fijado antes de la primera exposición del reto registrado |
| [Merkle/Indices](Nexus/Merkle/Indices.lean) | 12 resultados: bits bajos, inversas, equivalencia entre rutas e índices acotados y vector indexado |
| [Merkle/PruebasIndexadas](Nexus/Merkle/PruebasIndexadas.lean) | 10 resultados: orden de hermanos, equivalencia del acumulador desde la hoja con la reconstrucción, aceptación y vinculación por índice |
| [FRI/OraculoMerkle](Nexus/FRI/OraculoMerkle.lean) | 9 resultados: extensión única del vector a la capa con cero fuera, lectura en el dominio, aperturas registradas y plegado de pareja abierta |
| [Canal/OraculosMerkle](Nexus/Canal/OraculosMerkle.lean) | 7 resultados: oráculo de campo congelado antes de la primera exposición, estabilidad final y arreglos OraculosEmitidos de N06 para una familia dada |
| [Merkle/CodificacionBase](Nexus/Merkle/CodificacionBase.lean) | 13 resultados: hojas canónicas Fp de 9 bytes, lectura y recodificación inversas, rechazo mutuo con Fp2 y etiquetas compartidas |
| [ROM/FormatoBase](Nexus/ROM/FormatoBase.lean) | 6 resultados: transporte de extensiones seguras, congruencia genérica, independencia del relleno y congelación y aperturas base en la misma memoria |
| [FRI/OraculoBase](Nexus/FRI/OraculoBase.lean) | 7 resultados: oráculo base inyectado en Fp2, cero fuera, lectura, aperturas, plegado y puntosFueraBase de N03 igual a cero |
| [Canal/OraculosBase](Nexus/Canal/OraculosBase.lean) | 10 resultados: relleno irrelevante, congelación base antes del reto, un único corte para las aperturas y arreglos mixtos N06 con lectura y vinculación |
| [FRI/PosicionesAIR](Nexus/FRI/PosicionesAIR.lean) | 8 resultados: seis posiciones, índices módulo N, desplazamientos por g, opuestos y pareja canónica |
| [Canal/RaizCompartida](Nexus/Canal/RaizCompartida.lean) | 5 resultados: control booleano de raíz, identidad del oráculo entre cortes AIR/FRI y lectura inicial N06 |
| [Canal/AperturasAIR](Nexus/Canal/AperturasAIR.lean) | 5 resultados: seis valores autenticados como Fp2, control base de la muestra y vinculación de la primera pareja FRI |
| [Canal/EnlaceComposicion](Nexus/Canal/EnlaceComposicion.lean) | 6 resultados: fórmula de compose, enlace local y ConsultaParejas, más ensamblaje N06 condicionado a las dos aceptaciones FRI |

El teorema `Nexus.AIR.validez_iff_residuos` expresa literalmente:

```lean
∀ (T : ℕ) (g : K) (f : Polynomial K) (s o : K),
  3 ≤ T → IsPrimitiveRoot g T →
  (Valida g T f s o ↔ ResiduosNulos g T f s o)
```

La recurrencia, los numeradores y los residuos se definen en el módulo de
enunciado. Se demuestra que H tiene T puntos distintos y su anulador es
X^T−1. La equivalencia vale para cualquier polinomio f, por lo que también
cubre la hipótesis grado(f)<T de la tesis.

El campo base se construye como `ZMod p`, con
**p = 18446744069414584321 = 2^64−2^32+1**. La primalidad se demuestra con un
certificado de Lucas: la potencia de 7 correspondiente a p−1 vale 1 y las
potencias correspondientes a sus seis factores primos descartan órdenes menores.
Se prueba que 7 tiene orden p−1 y que `7^((p−1)/2^k)` tiene orden 2^k para
k≤32. La raíz de orden 2^32 vale **1753635133440165772**. Se verifica la
identidad entre el desplazamiento natural a la derecha y el cociente del
exponente, y que `raiz(k+3)^8 = raiz(k)` para k+3≤32.

Se demuestra que 7 no es un cuadrado y que X²−7 es irreducible. La extensión
se presenta mediante `QuadraticAlgebra Fp 7 0`, con estructura de campo y
cardinal p² derivados de esas pruebas. Sus fórmulas de multiplicación, norma
e inverso coinciden algebraicamente con las expresiones de `field.rs`.
Permanece pendiente la equivalencia completa con el programa Rust, incluidos
los enteros de máquina, desbordamientos, bucles y serialización.

Para T=2^k, N=8T y 4≤k≤29 se construye L en la extensión como la imagen del
coset `7*<raiz(k+3)>`, se prueba |L|=8T y que X^T−1 no se anula en L.
Este rango incluye el perfil TG2 implementado, 4≤k≤12. De grado(f)<T se
derivan las cotas de grado de los tres numeradores y de su combinación,
todas a lo sumo 2T. Así, `distancia_composicion_concreta` obtiene
distancia ≥(5T+1)/(8T) frente a todo candidato de grado <2T, bajo la condición
de residuo combinado no nulo. La excepción de cancelación de una traza fija
inválida tiene probabilidad a lo sumo 1/p² en el modelo uniforme independiente.

La transferencia local ya se deriva de los conjuntos de discrepancias en
**x, gx y g²x**. Se prueban la clausura del coset y la identidad entre el índice
`(i+8j) mod N` y el punto `g^j*x`; las dos reindexaciones no aumentan el número
de errores. La unión de los tres conjuntos da
`distancia(c_u,c_f) ≤ 3*distancia(u,f)`, sin independencia probabilística.
La desigualdad triangular y la cota anterior producen, para todo candidato
h de grado <2T:

```text
distancia(c_u,h) ≥ max(0, (5T+1)/(8T) − 3ε).
```

Se exportan versiones con ε racional y real. La premisa es
distancia(u,f)≤ε para ese mismo f de grado <T y el residuo combinado no nulo;
no se deduce esa premisa de la aceptación de un verificador. El oráculo se
representa por una función sobre el campo; la clausura garantiza que sus
valores fuera de L no intervienen en la composición en L.

La composición local se define con los cocientes polinómicos de frontera y
se demuestra igual a la fórmula racional de las tres partes de `compose`,
fuera de los polos. Para ε≤1/24 se prueba el margen estricto mayor que 1/2.
Las cinco filas de la tabla 6.16 y sus diez redondeos hacia abajo tienen error
menor que 10^-6. La fila T=262144 pertenece al cálculo matemático del manuscrito;
no amplía el máximo 4096 admitido por el ejecutable TG2 v1.

La rama del candidato fuera del campo base ya se construye sobre la extensión
Goldilocks. Se obtiene `f=A+zB` por las coordenadas de cada coeficiente, con
grado(A),grado(B)≤grado(f). Una evaluación en un punto base está en el campo
base si y solo si B se anula allí. Por tanto, si f no viene de un polinomio
base y grado(f)<T, tiene como máximo T−1 valores base en cualquier dominio
finito de puntos base distintos.

Para un oráculo u a distancia ≤δ de ese mismo candidato, se demuestra que su
fracción de valores fuera del campo base es al menos `1−(T−1)/N−δ`, también
con tolerancia real. En el coset N=8T, δ≤1/8 implica una fracción estrictamente
mayor que 3/4. Para radios no negativos δt,δc, la fracción no base es al menos
`d+1/4`, donde `d=(5T+1)/(8T)−3δt−δc`. Estas son cotas de posiciones, no
probabilidades de aceptación del ejecutable.

Se especializa la unicidad al perfil δ≤1/8 y se demuestra que la validez AIR
de un polinomio base se conserva y refleja al elevar sus coeficientes. Si el
enunciado no tiene traza válida sobre el campo base, un candidato cercano
dado cae en una de dos ramas: es base e inválido, o no es base y el oráculo
tiene la fracción no base indicada. La existencia no se garantiza para un
oráculo arbitrario. El selector parcial de N06, descrito más abajo, trata
también su inexistencia y se define sin recibir los retos AIR.

El lema A de acuerdo correlacionado admite ahora radios reales. Para θ=1/8
se demuestran sus márgenes en todas las capas: en composición,
`n_j=2^(k+2−j)` y `e_j=2^(k−j)`, con j≤k; en traza,
`e_j=2^(k−1−j)`, con j<k. Estas son cuentas de tamaños y grados,
no la construcción de los dominios de cada capa.

Para un dominio L de puntos y una raíz r(y) no nula con r(y)²=y,
se definen las partes par e impar a partir de u(r(y)),u(−r(y)). Si 2≠0,
se recompone cada pareja. Fuera de un conjunto de a lo sumo |L| retos,
un acuerdo grande del plegado con un polinomio de grado <e permite
recuperar P=A(X²)+XB(X²), de grado <2e, que coincide con u en las dos
mitades del mismo conjunto S. El resultado afirma existencia y se usa
en la propagación por una torre finita descrita a continuación. No se
presenta como una extracción temporal. Los representantes r y los cosets
sucesivos concretos se construyen en los módulos descritos más abajo.

El muestreo se expresa mediante q-subconjuntos uniformes de M parejas,
con q≤M para que el espacio de muestras sea no vacío. Se formaliza
`H(M,q,θ)=choose(M−ceil(θM),q)/choose(M,q)` con θ racional, incluido
el numerador cero cuando quedan menos de q parejas buenas. La recurrencia
de los binomiales demuestra `choose(A,q)/choose(M,q)≤(A/M)^q`.
Por el redondeo hacia arriba, H≤(1−θ)^q para M>0 y 0≤θ≤1;
H es antitona en θ.

Una enumeración por (i,false),(i,true) contiene como máximo dos
discrepancias por pareja mala. Por ello, distancia puntual ≥θ implica
al menos ceil(θM) parejas malas. Las muestras que las omiten satisfacen
la cota H y su cota exponencial. Este paso requiere comprobar ambos
valores de la pareja. La enumeración opuesta del coset y la fórmula del
plegado se demuestran abajo; la equivalencia completa de las aperturas
Merkle y del recorrido Rust permanece separada.

La estructura `Torre K m` da dominios L_j, representantes r_j y grados d_j
para m plegados. Exige `L_j=elevar(r_j,L_(j+1))`, raíces no nulas,
`r_j(y)²=y`, `d_j=2*d_(j+1)`, grado final uno y dominio final no vacío.
Son relaciones geométricas y de grados; no se supone la proximidad
inicial ni la conclusión del lema B. La instanciación Goldilocks se
construye explícitamente para las dos fases de NEXUS.

Se demuestra que las partes par e impar no dependen de elegir x o −x,
que las dos mitades son disjuntas cuando 2≠0 y que elevar un conjunto
duplica su cardinal. Se deriva que las fibras del cuadrado tienen a lo
sumo dos puntos. Para W_0=A y W_(j+1)=cuadrados(W_j), la fracción de puntos
nunca disminuye. En particular, si A tiene densidad al menos 1−θ, todos sus
conjuntos sucesivos satisfacen el tamaño requerido por el lema A.

Los controles de cada capa se construyen con `recuperacion_capa`, con
a lo sumo |L_(j+1)| retos excepcionales. Fuera de esos conjuntos, si los
recorridos de A pasan todas las ecuaciones y coinciden con la constante
final, la inducción hacia atrás produce un polinomio del código inicial
que coincide con el oráculo sobre A. `lema_B` deduce que, cuando el
oráculo inicial está a distancia estrictamente mayor que θ de todo ese
código, la fracción de puntos aceptantes es como máximo 1−θ.

Para parejas iniciales completas A=elevar(r_0,G), ese resultado limita
el cardinal de G y permite aplicar la cota H de muestreo. Así,
`lema_B_muestreo` y `lema_B_exponencial` enlazan las consultas con el
recorrido entero de la torre y la constante final. No reciben una cota
del cardinal aceptante como hipótesis.

También se obtienen `d_j=2^(m−j)`, `|L_0|=2^j*|L_j|` y la conservación
de la razón |L|/d al llegar a constantes. La suma de tamaños de los
dominios de reto es exactamente |L_0|−|L_m|; por tanto, la suma de
cardinales excepcionales no la supera. Esta cuenta es determinista.
La familia u de oráculos es fija en estos enunciados. La extensión
adaptativa, la composición con AIR y sus probabilidades conjuntas se
describen más abajo, junto con el certificado por rondas del modelo ideal.

Para k≤29 se construye la capa j con `a_j=7^(2^j)`, raíz de orden
`2^(k+3−j)` y puntos `a_j*raizExtension(k+3−j)^i`. Se demuestra que
las raíces y los desplazamientos de la capa siguiente son sus cuadrados,
que el índice de media vuelta da el opuesto y que la enumeración es
inyectiva. El cardinal de cada dominio es exactamente `2^(k+3−j)`.

El representante de y se define mediante su índice único en la capa
siguiente. Se prueba que es el punto del mismo índice en la primera
mitad de la capa anterior, que no es cero y que su cuadrado es y.
Las dos mitades cubren exactamente el dominio anterior. Así se construye
`torreGoldilocks k m` para m≤k+1, sin recibir como premisas las relaciones
geométricas que exige `Torre`.

Las fases `torreTraza` y `torreComposicion` toman m=k y m=k+1. Ambas
empiezan en el mismo `cosetExtension(k+3)` de AIR y N03, de cardinal
8T; sus grados iniciales son T y 2T y sus dominios finales tienen ocho
y cuatro puntos. Se verifican los márgenes de todas las capas para
θ=1/8. La suma de cardinales excepcionales queda acotada por 8T−8 y
8T−4, respectivamente. La conversión a probabilidades adaptativas se
demuestra en la etapa N06 descrita a continuación.

`muestreo_torre_goldilocks` aplica el lema B y el muestreo completos a
estas torres para 4≤k≤29 y q=40, incluyendo todos los perfiles
implementados 4≤k≤12. Para un oráculo inicial lejano al código y retos
que evitan sus conjuntos excepcionales, la omisión queda acotada por
`H(4T,40,1/8)` y `(7/8)^40`. El rango matemático mayor no amplía el
máximo admitido por el ejecutable.

Se demuestra también que `a=pos mod (n/2)` selecciona la pareja
correcta, que sus posiciones son a,a+n/2 y que el plegado par/impar
es la expresión `(left+right)/2 + beta*((left−right)/2)*x⁻¹`.
Es una identidad de campo correspondiente a `fold` en `fri.rs`.
El informe conserva el hash de la copia histórica de esa fuente, además
de `field.rs`. Faltan la semántica completa de enteros de máquina,
bucles, formatos, aperturas autenticadas y la equivalencia integral de
`Acepta` con el verificador. Tampoco se acredita con esta identidad
la distribución del canal hash.

N06 incorpora un experimento finito con estado arbitrario S. En cada
ronda, el conjunto excepcional E(i,s) se fija antes del reto fresco x;
la transición puede usar toda la historia. El escape es absorbente:
su valor es uno desde la primera excepción. Se demuestra que las
medias condicionales coinciden con el promedio sobre un espacio de
exactamente |K|^n vectores, y que el riesgo con valor terminal cero
es el cociente exacto de transcripciones excepcionales. Para valor
terminal ≤h, h≥0 y |E(i,s)|≤B_i, la cota es h+sum(B_i)/|K|.
No se requiere independencia de los eventos excepcionales.

En FRI, `excepciones` recibe solo el oráculo actual y el índice de la
capa. Se demuestra que controla cualquier familia que tenga ese mismo
oráculo en esa capa. La estrategia recibe una lista de retos anteriores;
dos secuencias con el mismo prefijo producen la misma historia antes
del reto actual. Con los controles así elegidos se recupera el acuerdo,
se prueba el lema B y se aplica el muestreo H sobre cada historia sin
excepciones. No se seleccionan los conjuntos excepcionales a partir
de los oráculos futuros.

La unión adaptativa da una probabilidad de alcanzar alguna excepción
de una fase ≤(|L_0|−|L_m|)/|K|. Para las torres Goldilocks con θ=1/8,
se obtienen ≤(8T−8)/p² en traza y ≤(8T−4)/p² en composición, además
de ≤4T/p² para una capa en cualquier prefijo. Para 4≤k≤29 y q=40,
el muestreo condicionado a la historia sin excepciones y a un oráculo
inicial lejano satisface H(4T,40,1/8) y (7/8)^40.

El selector `candidato` recibe solo el dominio, el oráculo, el grado y
el radio racional. Devuelve `none` exactamente cuando cada polinomio
del código está a distancia mayor que el radio. Si devuelve `some f`,
f tiene el grado y la cercanía exigidos. Cuando el candidato es único,
el selector identifica ese mismo f; cambiar el oráculo fuera del dominio
no cambia la selección. En Goldilocks, para δ≤1/8 y k≤29, se caracteriza
así el candidato de grado <T. No se requiere que el selector sea eficiente.

`ramaTraza` fija el caso lejana/base/no base a partir del selector y no
recibe coeficientes AIR. Para un enunciado falso, su especificación prueba
alejamiento en la rama sin candidato, fracción no base >3/4 en la rama
no base, e invalidez AIR del candidato de la rama base.

Para una lista finita de residuos R_i se elige el último índice no nulo,
antes de sortear los retos. El estado acumulado es la suma de los
coeficientes anteriores por sus residuos. Solo la ronda crítica vigila
la ecuación x·R_j+s=0, que tiene a lo sumo una solución. Las otras rondas
tienen conjunto excepcional vacío. Se demuestra que el evento de escape
equivale a la cancelación total porque los residuos posteriores son cero.
La recursión de medias coincide con el promedio del indicador de esa
cancelación, y su probabilidad es ≤1/|K|.

La especialización a los tres residuos AIR Goldilocks deriva que alguno
es no nulo de la invalidez del candidato, identifica su suma con el resto
del numerador combinado y obtiene la cota secuencial 1/p². Para cualquier
suma anterior, el reto crítico conserva esa misma cota. No se agrupan los
tres retos para justificar su orden temporal.

Fuera del escape crítico, el candidato seleccionado proporciona la
transferencia de distancia de la composición local. Para cualquier v,
su selector de grado <2T distingue el caso lejano y el caso próximo;
en este último se prueba distancia(v,c_u)≥max(0,(5T+1)/(8T)−3δt−δc).
La cota es uniforme en v, que puede elegirse después de los retos y de
la historia anterior. Este paso no impone independencia de su elección.

La consulta se expresa como el cociente de q-subconjuntos aceptados entre
todos los q-subconjuntos del dominio de parejas. Se construyen las parejas
buenas de cualquier predicado P y se demuestra que cada pareja mala
contiene a lo sumo dos puntos que fallan P. Esto permite aplicar H a los
predicados de campo base y enlace en r(y),−r(y), con las fracciones de
fallos ya demostradas sobre el coset concreto.

En FRI se demuestra que el recorrido de A en la capa j es su imagen por
x↦x^(2^j). Aceptar una muestra equivale a aceptar todas sus parejas
individuales a lo largo de las capas y la constante final. Se construye
el conjunto de esas parejas aceptantes y se prueba que su unión acepta.
La cota H se deduce así para el predicado de aceptación de la muestra;
no se recibe un conjunto G aceptante como premisa.

`PrefijoConsulta` fija los coeficientes AIR, las estrategias de ambos FRI,
sus retos y constantes antes del sorteo de la muestra. `AceptaCompartida`
usa una sola S para ambos recorridos FRI, las seis posiciones base AIR
de cada pareja y el enlace en ambas mitades. `PrefijoSeguro` excluye solo
las excepciones de la rama activa: traza lejana, candidato no base,
composición lejana o enlace. La rama no base no paga excepciones FRI;
la rama base usa el resto no nulo y solo vigila composición si está lejos.

Para δt=δc=1/8, 4≤k≤29 y q≤4T, se demuestra que la consulta compartida
de cualquier prefijo seguro tiene probabilidad ≤H(4T,q,1/8). Los radios
de enlace y campo base son al menos 1/8; por antitonicidad de H, el máximo
de los cuatro errores finales es esa misma cota. Se prueban también su
conservación bajo promedios y cualquier distribución finita normalizada
soportada en prefijos seguros. Para q=40 se obtiene h_T y (7/8)^40.
No se multiplican probabilidades de los dos FRI.

La nueva etapa construye esa ejecución causal. `reto` convierte los n retos
finitos en la función usada por FRI, prolongada por cero fuera de las n
coordenadas sorteadas. Se demuestra que no escapar equivale a evitar cada
conjunto excepcional calculado con su prefijo. Un valor terminal cualquiera,
acotado por h fuera del escape y por uno en general, conserva la cota de
unión adaptativa. Por tanto, también se obtiene la aceptación FRI promediada
sobre todas las transcripciones y la consulta.

`PoliticaConsulta` fija u antes de AIR. El orden demostrado es AIR → FRI de
traza → FRI de composición → consulta compartida. Cada capa recibe las
monedas de fases anteriores y su propia historia; las constantes finales
pueden depender de toda su fase y preceden a la muestra. `ejecutarPrefijo`
construye el prefijo y `probabilidadConjunta` promedia las tres fases uniformes
y la aceptación de la muestra, sin condicionar a prefijos seguros.

Si el enunciado no tiene traza válida sobre el campo base, la rama inicial
determina qué excepciones se pagan. La rama lejana paga (8T−8)/p² por FRI de
traza; la no base no añade excepciones; la base paga 1/p² por AIR y como máximo
(8T−4)/p² por FRI de composición. Se deduce
`Pr[no PrefijoSeguro]≤(8T−3)/p²`. El teorema terminal conjunto combina ese
riesgo con la consulta y demuestra, para 4≤k≤29 y q≤4T:

```text
probabilidadConjunta ≤ H(4T,q,1/8) + (8T−3)/p².
```

Para q=40 se obtiene también `(7/8)^40+(8T−3)/p²`. Es una cota ordinaria
terminal del experimento interactivo ideal definido en Lean. La cota
compartida cubre el perfil 1/8; las cotas locales genéricas no constituyen
todavía un teorema compartido para radios arbitrarios.

La etapa nueva define además el estado por rondas. `actualizarMarca` conserva
uno y activa la marca si ocurre la excepción actual. `recorrerMarca` propaga
esa misma marca y se identifica con el evento `Escapa`; un monitor vacío la
conserva. Los mensajes del probador también conservan la marca, mientras su
contenido puede cambiar el conjunto excepcional de retos posteriores.

`residuosVigilados` solo recibe la traza inicial y el enunciado. Su último
residuo no nulo determina el monitor AIR; si no hay residuos se usa el monitor
vacío. FRI de traza solo se vigila en la rama sin candidato próximo. FRI de
composición se vigila en la rama base cuando su oráculo inicial está lejos;
esa decisión depende de AIR y de toda la fase de traza, anteriores a sus retos.
Para cualquier historia y estado previo, la probabilidad de una transición
nueva de cero a uno es ≤1/p² en AIR y ≤4T/p² en un plegado activo.

Se conservan las marcas al pasar de AIR a traza y de traza a composición.
Para un enunciado falso, `estado_cero_iff_prefijo_seguro` demuestra que el
estado alcanzado antes de consultar es cero exactamente cuando el prefijo
es seguro. La consulta final activa la marca si acepta y, desde el estado
alcanzado, su probabilidad de cambio es ≤H(4T,q,1/8). Si la marca ya es uno,
no hay una transición nueva. Estado final cero implica rechazo.

`CertificadoRondas` recoge inicio cero, conservación por mensajes, absorción,
las cotas de las tres clases de reto y de la consulta y el rechazo terminal,
para las transiciones concretas del modelo. `solidez_por_rondas` construye
ese certificado con `max(1/p²,4T/p²,H(4T,q,1/8))`. Para los nueve perfiles
4≤k≤12 y q=40, una comparación racional exacta demuestra que el máximo es
h_T. `solidez_por_rondas_perfiles` certifica así epsilon_rbr=h_T como cota
escogida; no afirma optimalidad. La nueva etapa demuestra además el corolario
de reinicios ideales descrito a continuación. Permanecen la traducción formal
del certificado a la definición bibliográfica y la correspondencia integral
del orden y los mensajes con el protocolo y Rust/Merkle/ROM.

`PlanRestaurable` representa un árbol adaptativo con hasta B retos nuevos.
Cada petición debe tener su origen en el registro de estados guardados;
su respuesta fresca añade un destino y consume una unidad. Elegir de nuevo
un nodo anterior no necesita un sorteo. Los mensajes añaden nodos cuya marca
coincide con la de un origen guardado, sin consumir retos. Se admite detener
el plan antes de agotar el presupuesto. Las respuestas tienen tipos finitos
que pueden variar con la petición y con toda la historia anterior.

Se demuestra que el riesgo está entre cero y uno y que una marca guardada
no desaparece aunque después se restaure una rama en cero. Desde un registro
inicial sin marcas, el riesgo de guardar alguna marca coincide con la
probabilidad absorbente de una primera transición nueva cero a uno.
Si cada reto fresco tiene cota condicional epsilon, el riesgo es como máximo
`min(1,B·epsilon)`. Toda aceptación guardada que implica una marca comparte
esa cota. La prueba no requiere independencia entre los eventos; también
se conserva al promediar planes con una semilla finita uniforme.

`NodoIdeal` guarda los datos de fase y de estado usados por los monitores
AIR/FRI, las historias y las consultas/salidas. Las respuestas son Fp2 en
AIR y FRI, y el subtipo de q-subconjuntos de parejas en la consulta. Se
demuestra que el promedio uniforme de ese subtipo coincide exactamente con
`probabilidadConsulta`. `cambio_ideal_certificado` deduce todas las cotas
locales de `CertificadoRondas`, y una salida aceptada activa su marca.

Para un enunciado falso, se obtiene desde la raíz cero
`probabilidadReinicios≤min(1,B·errorRonda(k,q))`. En los nueve perfiles con
q=40, `reinicios_ideales_perfiles` da `min(1,B·h_T)`. Los mensajes del juego
pueden añadir cualquier nodo con la misma marca; el adaptador formal a la
transcripción y a la definición bibliográfica permanece pendiente. Una
respuesta ya obtenida puede reutilizarse restaurando su nodo guardado.
B cuenta únicamente nuevos sorteos ideales; no se identifica con llamadas
SHA3 sin una transferencia ROM.

La primera instanciación `PlanReinicios` mantiene fija la política de oráculos
para todo el árbol. La ampliación `PlanAdaptativo` elimina esa restricción:
cada nodo guarda su propia política y cada nueva petición puede elegir otra,
según toda la historia de intentos. Los nodos anteriores conservan sus valores.
Las funciones de oráculo pueden ser arbitrarias; solo las respuestas de cada
reto deben ser finitas y uniformes.

`cambio_adaptativo_cota` instancia el certificado con la política de la petición
actual, elegida antes de su nueva respuesta. `reinicios_politicas_adaptativas`
demuestra min(1,B·errorRonda(k,q)) para este juego y, en los nueve perfiles,
`reinicios_adaptativos_perfiles` obtiene min(1,B·h_T). El resultado también
se conserva para planes elegidos mediante una semilla finita uniforme.
El enunciado falso y el perfil siguen fijados; los mensajes pueden añadir
cualquier nodo con la misma marca. Sigue pendiente el adaptador formal de
este juego a la transcripción concreta y a la definición bibliográfica.

Los nueve perfiles 4≤k≤12 admiten q=40 parejas distintas y su techo
ceil((1/8)·4T) vale T/2. Los cuatro decimales refinados de la tabla 6.22
redondean hacia arriba el valor exacto `H(4T,40,1/8)+(8T−3)/p²`, con
error <10^-9. `solidez_interactiva_limite_tabla` enlaza ahora la aceptación
conjunta ideal con ese lado derecho, y `solidez_interactiva_tabla6_22` aplica
los cuatro superiores. La aplicación al ejecutable sigue requiriendo su
correspondencia con el modelo interactivo y la distribución de retos hash.

Para la tabla 5.2 se usa el decimal completo de la evidencia R5:
**478.74407894736845 µs**. Emplear solo su presentación de 478.74 µs cambia
las últimas cifras de algunas filas. La prueba conserva el valor de entrada
del informe y demuestra error menor que 0.0005 para los quince redondeos.

La transcripción nueva lleva su fase y la longitud de cada prefijo en el tipo.
`anexarReto` añade el reto al final; `nodo_causal_destino` demuestra que
reconstruir el nuevo prefijo coincide con la transición concreta anterior.
`estadoCausal` vale uno desde el inicio para enunciados válidos; en los falsos
reconstruye la marca de los monitores. Los pasos sin monedas tienen una
gramática que fija los mensajes y cambios de fase, y conservan el estado.
El estado cero antes de consultar coincide con la marca conjunta anterior;
el estado final cero implica rechazo del mismo predicado compartido.

`PlanCausal` solo añade mensajes de esa gramática y respuestas desde prefijos
guardados. Su expansión al registro restaurable demuestra min(1,B·errorRonda)
y, en los nueve perfiles, min(1,B·h_T). Este plan mantiene fija una política
causal, que determina los mensajes a partir de las monedas previas. Esa
expansión se conserva con su alcance de política fija. La etapa siguiente
demuestra la invariancia y los cambios de política compatibles sobre el
cociente de mensajes observados.

`normalizarTerminal` fija el oráculo final de cada FRI a su constante enviada.
El modelo general anterior permitía un oráculo terminal adicional; no se
reescriben sus pruebas ni se afirma que su aceptación se conserve para cada
política. Se demuestra que la normalización conserva los mensajes tipados y
la marca antes de consultar, y se aplican las cotas generales a esa política
normalizada. Así, la salida observada depende de las constantes enviadas y
de los oráculos ya fijados.

`MismosMensajes` compara los oráculos y constantes emitidos en la historia
recorrida, incluyendo el oráculo actual cuando ya se fijó antes del reto.
No exige igualdad en otras ramas ni en decisiones futuras. Se prueban su
equivalencia y la igualdad del estado normalizado. `PrefijoObservado` conserva
la fase y los retos y toma el cociente de políticas por esos mensajes.
`estadoObservado` y `aceptaObservado` quedan bien definidos sobre él. El estado
inicial es uno iff el enunciado es válido, los mensajes compatibles lo conservan,
uno es absorbente, cero implica rechazo y la cota local cubre también los
enunciados válidos, cuyo cambio es cero.

`PlanObservado` elige una política por petición y puede cambiar decisiones
futuras entre ramas. La pertenencia de su origen al registro exige la misma
clase de mensajes ya fijados; no permite reescribir oráculos anteriores.
Los mensajes siguen la gramática y la aceptación queda acotada por
min(1,B·errorRonda(k,q)), y por min(1,B·h_T) en los nueve perfiles. B cuenta
retos ideales frescos. Esta representación por cociente aún requiere la
realización y equivalencia integral con las transcripciones y adversarios de
la definición bibliográfica, los formatos inválidos y las aperturas. Tampoco
cierra Rust/Merkle/ROM.

`TranscripcionExplicita` conserva la fase y los retos y guarda los oráculos y
constantes emitidos en arreglos finitos. El oráculo inicial aparece una sola
vez. Leer las capas y capturarlas son operaciones inversas sobre los índices
emitidos; no se guardan decisiones futuras.

La igualdad de datos capturados equivale exactamente a `MismosMensajes`.
`politicaDeDatos` reproduce cualquier conjunto de datos del prefijo indicado,
con valores fijos que no reciben monedas futuras. Esto realiza un prefijo
individual; no construye todavía una estrategia uniforme para una familia
arbitraria de transcripciones. `equivalenciaExplicita` demuestra que codificar
y decodificar entre la representación explícita y el cociente observado son
inversas. Se preservan el estado, la aceptación, el estado inicial y el rechazo
en cero.

Las peticiones explícitas contienen los datos ya fijados antes de su nueva
respuesta. La política canónica obtenida de ellos reproduce su origen; el
destino codificado coincide con el reto observado. Así se transportan absorción
y la cota local universal `errorRonda(k,q)`, que vale h_T en los nueve perfiles.
Un reto anexado conserva las coordenadas e historias anteriores. Cualquier
política que realice los datos del origen produce exactamente el mismo destino
explícito después de esa respuesta, aunque cambien sus decisiones futuras.

`PasoExplicito` contiene un paso de `PasoSinReto` y los datos de su destino.
La compatibilidad exige que la política canónica de esos datos reproduzca los
mensajes anteriores. Esta regla mira los datos y no recibe igualdad de estados
como permiso de transición. Se prueba su correspondencia exacta con los pasos
observados y se deduce conservación del estado.

`PlanExplicito` solo añade esos pasos y respuestas frescas desde orígenes
guardados. Su registro conserva los nodos anteriores y restaurar no devuelve
presupuesto. La evaluación propia por medias uniformes coincide con su expansión
al árbol genérico. Para un enunciado sin traza base válida, 4≤k≤29 y q≤4T,
la aceptación queda acotada por min(1,B·errorRonda(k,q)); en los nueve perfiles
4≤k≤12 y q=40 se obtiene min(1,B·h_T). B cuenta retos ideales frescos.

Para cada función terminal se transporta un plan completo en cada dirección,
codificando o decodificando todo el registro y manteniendo el presupuesto y su
valor. En particular cada plan explícito tiene un plan observado con la misma
probabilidad de aceptación, y viceversa. La comparación cubre los dos modelos
ideales internos desde sus raíces. No afirma que toda forma tipada arbitraria
sea alcanzable desde vacío ni cierra el adaptador bibliográfico integral.
Los oráculos de N06 siguen siendo funciones matemáticas completas. Su enlace
con los compromisos y las aperturas concretas se trata por separado en N07.

N07 incorpora la extracción por registro y ahora una instancia concreta sobre
bytes. El hash es una función fija de listas de octetos a digests de 32 bytes.
La ausencia de colisiones se exige solo en las entradas registradas. No se
postula separación global de roles del único oráculo.

Las conversiones little-endian tienen longitud fija y ambas identidades
inversas dentro de sus rangos. Un elemento Fp2 usa sus dos coordenadas canónicas
de ocho bytes; una hoja tiene prefijo 00 y mide 17 bytes. Un nodo tiene prefijo
01 y dos digests, y mide 65 bytes. Se prueba la decodificación inversa y que
todo mensaje admitido se reconstruye exactamente. Los digests tienen cardinal
2^256. Son fórmulas de bytes sobre enteros matemáticos; la semántica completa
de u8/u64 y del programa Rust permanece separada.

El extractor recorre preimágenes registradas con altura y ruta fijadas.
Completa con cero cualquier región ausente o de forma incorrecta y da un
vector total sobre 2^altura rutas. Una apertura aceptada y registrada coincide
con su valor extraído. Las etiquetas locales de raíz, salidas e hijos mantienen
la cota previa 3·longitud+1 y la estabilidad temporal ya demostrada.

Ahora se marcan todas las ventanas contiguas de 32 bytes de cada entrada de
hasta 79 bytes, aun si tiene otro rol. Hay a lo sumo 48 ventanas por entrada.
Los hijos de cualquier nodo admitido aparecen en offsets 1 y 33. La absorción
estado || etiqueta || longitud u64 LE || raíz mide 73 bytes y contiene la raíz
en offset 41. Si esa entrada está registrada antes, su raíz ya está marcada.

Se añaden las respuestas y un conjunto R de digests adicionales. Las marcas
del registro tienen cardinal ≤49·longitud+|R|. Antes de responder se incluyen
también las ventanas de la propia entrada; con longitud<S, su cardinal es
≤49S+|R|. Se prueba que esas marcas cubren las etiquetas del extractor concreto.
Una secuencia de consultas sin acierto conserva el vector congelado y toda
apertura posterior aceptada y registrada de una raíz absorbida antes coincide
con él.

El nuevo juego ROM usa una tabla de pares entrada/respuesta sin entradas
duplicadas. Una repetición devuelve el digest almacenado, conserva la tabla
y sigue una sola rama, sin sortear monedas nuevas. Una entrada ausente recibe
un digest uniforme y se anexa a la tabla. Las solicitudes y las nuevas marcas
adicionales se eligen antes de responder, según las respuestas anteriores.
El cardinal acumulado de esas marcas se mantiene ≤B; pueden revelarse tarde.

Los planes son finitos, pueden terminar antes de agotar el presupuesto y
reservan n respuestas nuevas. La probabilidad de algún acierto es igual al
conteo de cintas excepcionales dividido por (2^256)^n. El riesgo se vuelve
uno desde el primer acierto. La repetición no añade una oportunidad nueva.
Por inducción sobre el plan y la cota de marcas ≤49S+B, se demuestra
n(49S+B)/2^256 si longitud inicial+n≤S. Desde tabla vacía, con presupuesto S,
se obtiene min(1,S(49S+B)/2^256). No se condicionan respuestas a la ausencia
de excepciones futuras.

La ejecución del plan con una cinta sin aciertos produce un recorrido con
memoria y marcas crecientes. La función total completada desde la tabla final
concuerda con todas las respuestas de los prefijos. Las preimágenes y la
extracción solo dependen de los valores en entradas registradas. Se deriva
ausencia de colisiones desde tabla vacía. Si una raíz estaba marcada al
congelar, toda apertura posterior aceptada y registrada coincide con el
vector calculado exclusivamente con la tabla de aquel instante. Una raíz
absorbida en el prefijo está marcada por sus ventanas. Las marcas adicionales
que aparecen después no se imponen retroactivamente a las respuestas previas.

La congelación se extiende ahora al instante previo a responder la consulta
actual. La raíz puede aparecer solo en las ventanas de esa entrada, sin estar
todavía en la tabla. Las marcas preparadas cubren todas las etiquetas locales
y se conservan tras respuestas nuevas o repetidas. Se compone ese primer paso
con el recorrido futuro y se prueba estabilidad del vector calculado con la
tabla anterior a la respuesta. Desde vacío sin aciertos, toda apertura posterior
aceptada y registrada coincide con ese vector.

Se formalizan las fórmulas de bytes de channel.rs. La cabecera contiene un
digest de 32 bytes y una etiqueta. Una absorción añade longitud de ocho bytes
LE y los datos, con longitud total 41+|datos|. Se recuperan cabecera, datos y
campo de longitud. Leer ese campo como longitud exacta exige |datos|<2^64.
Los formatos son inyectivos en sus campos, sin asumir inyectividad del hash.
Los retos F/E/I usan etiquetas 70/69/73 y miden 33 bytes; el trabajo con nonce
u64 usa etiqueta 5 y mide 41. Se prueban sus distinciones locales por longitud.
También se construye una absorción con etiqueta 4 y 24 bytes que coincide
exactamente con un nodo Merkle de 65 bytes. El testigo se refiere a la fórmula
de bytes y no acredita por sí solo un enunciado admitido por todo el perfil.

Una secuencia local de absorción de raíz y generación de reto usa la respuesta
efectiva de la primera consulta como estado de la segunda. La raíz queda
marcada antes de la primera respuesta y persiste antes del reto. Se demuestra
que el vector calculado antes de ambas respuestas coincide con el extraído
después y vincula cualquier apertura posterior aceptada y registrada. Se
admiten repeticiones con sus valores memorizados.

La etapa local anterior no situaba la primera exposición de un reto ya
consultado. Ahora se construyen cortes de origen en el registro completo.
Cada entrada almacenada desde vacío procede de un paso nuevo con su solicitud,
tabla anterior, ausencia de la entrada y recorridos a ambos lados. Las búsquedas
persisten y las repeticiones conservan ese origen. Todos los prefijos anteriores
al corte mantienen ausente su entrada.

Una respuesta nueva sin acierto evita las ventanas de consultas anteriores y
de su propia entrada. Cualquier entrada que la contenga como ventana sigue
ausente inmediatamente después. Se define la posición canónica por el índice
de la entrada en la tabla, y se prueba que coincide con la longitud de la tabla
anterior al origen. Para dos entradas registradas, si la respuesta de la primera
aparece en las ventanas de la segunda, sus orígenes están estrictamente ordenados.
La relación de dependencias por ventanas es irreflexiva, asimétrica y bien fundada.
Esta relación usa las ventanas definidas para entradas de hasta 79 bytes;
no incluye cualquier coincidencia arbitraria dentro de entradas largas.

El estado de un reto F/E/I de 33 bytes y del trabajo de 41 está en sus ventanas.
También lo está en una absorción cuando sus datos tienen a lo sumo 38 bytes.
Un reto que usa una respuesta nueva sin acierto está ausente tras almacenarla.
Para una absorción de raíz y un reto que usa su respuesta, ambos registrados
en un recorrido desde vacío sin aciertos, se recuperan los dos orígenes en orden.
La raíz estaba marcada antes de responder a la absorción y sigue marcada antes
de la primera respuesta del reto. El vector calculado en ambos instantes coincide.
Todas las aperturas posteriores aceptadas y registradas coinciden con ese vector;
un mismo corte se elige antes de cuantificar sobre las aperturas. Esto cubre
llamadas actuales repetidas recuperando sus instantes originales.

Los resultados exigen los dos hechos de consulta en el registro y un recorrido
desde vacío sin aciertos. Falta obtener esas premisas para todas las historias
válidas del protocolo y construir el adaptador causal completo a N06. No se
deduce independencia de una respuesta repetida ni uniformidad al condicionar
a la ausencia de excepciones futuras.

Se formaliza ahora la numeración de las hojas. Los bits se obtienen por
módulo y división entre dos desde el menos significativo. La ruta desde la
raíz es su reversa. Se prueban longitud, cotas e inversas y una equivalencia
entre rutas de longitud h e índices Fin (2^h). El acumulador que recibe los
hermanos desde la hoja coincide con la reconstrucción del extractor al
etiquetarlos con esos bits e invertir su orden. La aceptación matemática
comprueba longitud h e igualdad de la raíz; la cota i<2^h es una premisa
adicional al vincular la extracción. No se introduce esa cota como una
comprobación que supuestamente hiciera el bucle de Rust.

Para cada capa se construye un oráculo Fp2→Fp2. El índice numérico de la hoja
es el exponente del punto del dominio y se usa cero fuera de ese dominio.
La lectura usa k≤29 y j≤k+3. Se prueba que la extensión es inyectiva y que
la función con esos valores en el dominio y cero fuera es única. Toda apertura
indexada aceptada y registrada coincide con el valor del oráculo en su punto.
Dos aperturas en los índices a y a+N/2 determinan el plegado de esa pareja.

La congelación se transporta a este oráculo sobre el campo: coincide antes
de las primeras respuestas de absorción y reto, y permanece estable hasta
el registro final sin aciertos. Un único corte, elegido antes de cuantificar
sobre índices y aperturas, vincula todos sus valores. Una familia dada de
estados y raíces produce los arreglos OraculosEmitidos de N06. Se prueban
lectura, igualdad de las familias de cortes y valores de aperturas. Aún se
debe construir esa familia causalmente para todas las historias y fases;
empaquetar datos dados no completa el adaptador global del protocolo.
La etapa auxiliar de hojas base formalizó Fp con ocho octetos LE más el
prefijo cero. Se conservan sus inversas, canonicidad, rechazo mutuo con Fp2,
igualdad de etiquetas de nodos y congelación en la misma memoria. Su oráculo
Fp inyectado es globalmente base y sus arreglos mixtos son válidos para ese
modelo. Ese componente corresponde al formato del verificador legado; no
representa el compromiso inicial de la variante TG2 v1 analizada en N07.

La variante experimental TG2 v1 autentica también los valores AIR mediante
hojas Fp2 de diecisiete bytes. El control trace_fri.roots[0]=trace_root comparte
raíz y formato. Su modelo booleano acepta exactamente listas con esa primera
raíz. Dos cortes del registro sin aciertos con raíz y formato iguales dan el
mismo oráculo antes de los retos y de las absorciones respectivas. Se conserva
la lectura inicial de los arreglos N06 dados. No se identifica el hash de una
hoja de nueve bytes con el de su inmersión de diecisiete bytes.

Las seis posiciones tipadas Bool×Fin3 son i+8j e i+N/2+8j módulo N. Se prueban
cardinal seis, rango, periodicidad e identidad con g^j*x y g^j*(-x). Para i<N/2,
la pareja corresponde al representante del punto del dominio cuadrado de N06.
Datos AIR Fp se autentican como su inmersión en Fp2 con ese índice. Aperturas
aceptadas y registradas vinculan los seis valores al oráculo congelado; de ellas
se deriva el control base de una pareja y de toda la muestra. No se presupone
que el oráculo tome valores base fuera de esas posiciones. Esto mantiene la
rama de candidato no base de N03 y N06.

Las aperturas AIR y de la primera pareja FRI bajo esa raíz satisfacen el control
TraceLink fuera de aciertos, por la vinculación del extractor. La fórmula de
compose se transporta de Fp a Fp2 y coincide con composicionLocal a partir de
tres evaluaciones, la raíz primitiva y la ausencia de polos. Las aperturas de
composición y sus comparaciones locales dan el enlace de oráculos y el predicado
ConsultaParejas de la muestra. El ensamblaje produce AceptaCompartida de N06
con las dos aceptaciones FRI y las coincidencias de oráculos iniciales como
premisas separadas. No se introduce la aceptación compartida completa como
hipótesis ni se deriva aún la aceptación FRI del bucle Rust.

Permanecen el bucle de selección de mitad, acarreo entre capas y constante final
de verify_query, las formas y rangos de listas, la realización causal de familias,
todos sus hechos de registro, fases terminales y la semántica de máquina y
deserialización de Rust. Los resultados usan datos ya tipados y aperturas
aceptadas y registradas. El archivo experimental TG2 y la transferencia ROM ya
estaban identificados por hash; se añade air.rs para documentar la distinción
con el legado sin modificar ninguna copia Rust ni pruebas anteriores.

S y B son presupuestos del juego parametrizado: B cuenta digests adicionales,
sin relación automática con el B de retos ideales N06. Aún se deben justificar
S y B_T para las consultas reales, completar la gramática integral del canal,
sus historias y hechos de registro, el adaptador causal y los planes de N06,
distribuciones, nonces y equivalencia integral con Rust y ROM. El resultado
no prueba que SHA3 concreto sea aleatorio. QROM sigue como trabajo futuro
y la tesis completa no está verificada.

La [evidencia vigente](../Documentos/06-Evidencia-TG2/2026-10-18/Lean-Ley-Conjunta-ROM/validacion.json)
incluye 2063 resultados, axiomas y revisión del núcleo de 234 módulos. Fija
inventario, revisión manual, fuentes TG2 corregidas y versiones anteriores.
La [trigésima primera etapa](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Juegos-Reticulares/README.md)
conserva sus 1217 resultados previos.
La [trigésima etapa](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Anillos-Contraejemplo/README.md)
conserva sus 1103 resultados previos.
La [vigésima novena etapa](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Costos-Residencia/README.md)
conserva los 982 resultados previos de residencia y costos.
La [vigésima octava etapa](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Entropia-Salud/README.md)
conserva sus 864 resultados de entropía y salud.
La [vigésima séptima etapa](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Enlace-AIR-FRI/README.md)
conserva sus 777 resultados y el enlace local AIR/FRI.
La [vigésima sexta etapa](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Hojas-Base/README.md)
conserva sus 753 resultados de hojas base como componente auxiliar.
La [vigésima quinta etapa](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Indice-Merkle/README.md)
conserva sus 717 resultados y el enlace entre índices y oráculos de campo.
La [vigésima cuarta etapa](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Primeras-Consultas/README.md)
conserva sus 679 resultados y el orden de primeras consultas.
La [vigésima tercera etapa](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Congelacion-Canal/README.md)
conserva sus 640 resultados y la congelación antes de las respuestas locales.
La [vigésima segunda etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-ROM-Memoria/README.md)
conserva sus 601 resultados y el juego ROM con memoria y unión adaptativa.
La [vigésima primera etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Merkle-Bytes/README.md)
conserva sus 558 resultados y los bytes y ventanas concretos.
La [vigésima etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Merkle-Congelado/README.md)
conserva sus 521 resultados y el extractor temporal abstracto.
La [decimonovena etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Planes-Explicitos/README.md)
conserva sus 495 resultados y el transporte de planes explícitos y observados.
La [decimoctava etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Transcripcion-Explicita/README.md)
conserva sus 466 resultados y la representación explícita de prefijos y retos.
La [decimoséptima etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Estado-Observado/README.md)
conserva sus 434 resultados y el estado y los reinicios sobre mensajes observados.
La [decimosexta etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Transcripcion-Causal/README.md)
conserva sus 393 resultados y la expansión tipada de una política fija.
La [decimoquinta etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Reinicios-Adaptativos/README.md)
conserva sus 371 resultados y el juego de políticas adaptativas por nodo.
La [decimocuarta etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Reinicios-Ideales/README.md)
conserva sus 366 resultados y la instancia con política fija.
La [decimotercera etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Solidez-Rondas/README.md)
conserva sus 345 resultados.
La [duodécima etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Solidez-Interactiva/README.md)
conserva sus 316 resultados.
La [undécima etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Consulta-Compartida/README.md)
conserva sus 292 resultados.
La [décima etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Candidato-AIR/README.md)
conserva sus 257 resultados.
La [novena etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Historias-N06/README.md)
conserva sus 230 resultados.
La [octava etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Cosets-FRI/README.md)
conserva sus 205 resultados.
La [séptima etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Torre-FRI/README.md)
conserva sus 174 resultados.
La [sexta etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Plegado-Muestreo/README.md)
conserva sus 148 resultados.
La [quinta etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Candidato-Base/README.md)
conserva sus 126 resultados.
La [cuarta etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Transferencia/README.md)
conserva sus 98 resultados.
La [tercera etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-Goldilocks/README.md)
conserva sus 76 resultados.
La [segunda etapa](../Documentos/06-Evidencia-TG2/2026-10-16/Lean-AIR-Manuscrito/README.md)
conserva sus 40 resultados y la [primera etapa](VERIFICACION.md) los 17 iniciales.

## Obligaciones que permanecen

1. Revisar semánticamente el inventario completo y añadir los enunciados
   matemáticos que no detecte el barrido.
2. Las cotas ajustadas de cocientes AIR y la cancelación por masa máxima ya
   tienen pruebas. Cerrar la correspondencia
   del campo, el LDE y sus operaciones con la semántica completa de Rust.
3. Completar el adaptador bibliográfico integral, los formatos inválidos y
   las aperturas. Ya se prueban la equivalencia de representaciones y la
   correspondencia exacta de mensajes y retos de los dos modelos ideales
   internos. Se transportan planes completos en ambos sentidos con el mismo
   presupuesto y probabilidad de aceptación, y se demuestra la cota de
   reinicios explícitos. No se afirma que toda forma tipada arbitraria sea
   alcanzable desde vacío ni que se haya cubierto cualquier adversario de una
   definición bibliográfica externa.
   La versión observada fija las capas terminales a las constantes; los
   modelos históricos conservan su oráculo terminal general. Completar
   la correspondencia integral con la transcripción de la tesis, `Acepta`
   y el ejecutable.
   N07 prueba extracción Merkle concreta, memoria, unión adaptativa,
   entradas del canal, orígenes y orden de primeras consultas, rutas e índices,
   aperturas numéricas y oráculos de campo fijados antes de la primera exposición
   del reto para el par absorción/reto registrado. Una familia dada se empaqueta
   en los oráculos explícitos de N06. Permanecen construirla causalmente para
   todas las historias, la gramática y hechos de registro, el adaptador completo,
   presupuestos S y B_T, distribuciones, nonces, rangos y semántica de Rust y
   radios generales. Los formatos Fp/Fp2 y arreglos mixtos están formalizados
   como componentes. TG2 v1 usa raíz y formato Fp2 compartidos. Ya se derivan
   sus controles locales de base y composición. La pasada de recorridos deriva
   ambas aceptaciones FRI desde el bucle y su acarreo. Las coincidencias de raíz
   y las aperturas dan aceptación compartida; falta construir causalmente
   todas las familias del ejecutable y justificar sus distribuciones. El programa de bytes ya deriva la tabla causal con propuesta adaptativa e intercalaciones; la congelación usa esa tabla bajo SinBad y pertenencia efectiva de absorción, reto y apertura. La nueva etapa deriva todos los registros y familias AIR/FRI desde una aceptación del programa con adversario, cerrando M37 en ese modelo finito. La compilación al muestreo reproduce el programa fuera de excepciones y acota el fallo de reconstrucción con altura<=S. La nueva ley conjunta identifica el mismo muestreador con tablas uniformes sobre todas las ramas del programa y cuenta los prefijos efectivos. La ley ideal del selector, candidatos y composición de eventos siguen requiriendo su transferencia; la solidez integral permanece abierta.
   No identificar intentos ideales con consultas SHA3 sin
   esa transferencia.
4. Completar las reducciones, simulación FSwA, KDF y evolución segura de
   claves. Retículos, anillos, normas, plantilla y juegos ya tienen modelos; completar
   su vínculo con algoritmos, clases de eficiencia y las correspondencias
   de los modelos de entropía y RCT/APT con la fuente y Rust, y verificar
   las tablas aritméticas restantes. NTT y rechazo tienen ya modelos de costo,
   esperanza y cotas O; falta su refinamiento integral con el backend.
5. Resolver las dependencias bibliográficas y las correspondencias con la
   implementación y la evidencia experimental, manteniendo visibles las
   hipótesis criptográficas y los resultados abiertos.

La exigencia de representar toda la matemática incorpora los enunciados y
límites QROM al inventario. No convierte en demostrada la transferencia QROM
abierta ni en teoremas las conjeturas de dureza de la literatura.

## Reproducir

Desde la raíz del repositorio:

```powershell
python scripts/lean.py preparar
python scripts/verificar_formalizacion.py
```

El verificador conserva una ejecución nueva, comprueba que el inventario
corresponda a los bytes actuales de los capítulos y revisa todos los teoremas
de [cobertura.json](cobertura.json). Para generar un barrido nuevo sin sustituir
el inventario revisado:

```powershell
python scripts/inventariar_matematica.py --salida .tools/lean/inventario-nuevo.json
```

La generación automática no conserva por sí sola las revisiones manuales;
se debe reconciliar el nuevo inventario antes de actualizar el registro vigente.
