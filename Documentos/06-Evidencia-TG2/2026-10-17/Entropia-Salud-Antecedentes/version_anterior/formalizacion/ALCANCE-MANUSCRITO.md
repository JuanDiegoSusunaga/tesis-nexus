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
El inventario base conserva 36 bloques con enlace Lean, de los cuales 35 tenían
revisión parcial marcada. La [primera clasificación manual](REVISION-MANUSCRITO.md)
revisa los 272 candidatos, identifica 14 omisiones y organiza 46 grupos de
obligaciones. Su [registro complementario](revision-manuscrito.json) alcanza
51 bloques con algún enlace parcial a pruebas existentes; no añade teoremas.
El inventario base permanece intacto. La exhaustividad y el cierre matemático
global siguen pendientes. Se priorizan entropía, salud, residencia, amortización
y complejidad del manuscrito antes del puente integral Rust/ROM.

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

Hay **777 lemas y teoremas registrados**. Las etapas anteriores conservaron
17, 40, 76, 98, 126, 148, 174, 205, 230, 257, 292, 316, 345, 366, 371, 393, 434, 466, 495, 521, 558, 601, 640, 679, 717 y 753 resultados acumulados. Los módulos añadidos en estas etapas son:

| Módulo | Resultado |
|---|---|
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

La [evidencia vigente](../Documentos/06-Evidencia-TG2/2026-10-17/Lean-Enlace-AIR-FRI/validacion.json)
incluye los 777 resultados, sus axiomas, la revisión del núcleo por módulo,
los hashes del inventario, los capítulos, fuentes Rust, variante TG2 v1,
transferencia ROM y dato R5 utilizado.
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
2. Demostrar las cotas más ajustadas de los cocientes AIR para trazas válidas;
   cerrar la correspondencia
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
   sus controles locales de base y composición; la aceptación compartida sigue
   condicionada a las dos aceptaciones FRI y coincidencias de oráculos iniciales.
   Falta derivarlas del bucle completo y construir causalmente todas las familias.
   No identificar intentos ideales con consultas SHA3 sin
   esa transferencia.
4. Formalizar las definiciones restantes de retículos, anillos, normas,
   juegos de firma, entropía, RCT/APT, KDF y evolución de claves; verificar
   las condiciones de complejidad, rechazo y las tablas aritméticas restantes.
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
