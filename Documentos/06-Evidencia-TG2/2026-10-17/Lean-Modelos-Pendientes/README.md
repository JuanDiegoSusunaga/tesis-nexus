# Lean y conciliación del manuscrito TG2

La [auditoría conjunta](validacion.json) verifica **1393 resultados registrados
en 154 módulos**, incluidos **176 nuevos en 16 módulos**. M02, M07, M12, M17,
M34 y M38 pasan a modelos verificados en los alcances expresos de la
[matriz](../../../../formalizacion/REVISION-MANUSCRITO.md). Hay 16 modelos
verificados, 24 grupos parciales, tres dependencias bibliográficas, dos respaldos
documentales y QROM AIR/FRI como trabajo futuro. Esto no declara verificada toda la tesis.

| Módulo | Resultados nuevos | Alcance |
|---|---:|---|
| [Reticulos/Euclideos](../../../../formalizacion/Nexus/Reticulos/Euclideos.lean) | 23 | Span entero de una familia real independiente, rango y dimensión intrínseca, combinaciones inyectivas y finitud en bolas. Mínimos sucesivos definidos por radios; monotonía, primer mínimo positivo y alcanzado. Relaciones SVP/SIVP/GapSVP y promesa disjunta. |
| [MLDSA/Plantilla](../../../../formalizacion/Nexus/MLDSA/Plantilla.lean) | 7 | Plantilla FSwA con dimensiones, respuesta z, reconstrucción Az-ct=Ay-cs2, pistas booleanas, cotas de norma y peso, intento con rechazo y corrección condicionada a reconstrucción de pistas y reto. |
| [Cripto/Variacion](../../../../formalizacion/Nexus/Cripto/Variacion.lean) | 8 | Leyes racionales finitas normalizadas, variación total y cota de cualquier evento; productos independientes y pérdida aditiva, con iteración para m factores. |
| [ROM/Sesgo](../../../../formalizacion/Nexus/ROM/Sesgo.lean) | 17 | Conteo exacto de preimágenes de x mod p sobre S valores; ley normalizada, Delta=r(p-r)/(pS), masa máxima y cuadrado para pares independientes. Cota de eventos para m retos de dos coordenadas y números Goldilocks, incluido 56Delta<7.069e-28. |
| [Cripto/Derivacion](../../../../formalizacion/Nexus/Cripto/Derivacion.lean) | 14 | Formato de dominio Sentinel, dos contadores de ocho bytes, semilla de 32 bytes y contexto; inyectividad, reproducibilidad de hash/KeyGen deterministas, separación de entradas de rotación y derivación, y colisión explícita si entradas distintas dan la misma salida. |
| [Cripto/RegistroEpocas](../../../../formalizacion/Nexus/Cripto/RegistroEpocas.lean) | 15 | Estado por identidad y época, preparación de lote, instalación atómica bajo controles, conservación de identidad predeterminada e historial, vigencia actual y rechazo de época retirada. Prefijo confiable, truncación posterior indetectable por punto antiguo y hash de prefijo o colisión. |
| [Cripto/Transacciones](../../../../formalizacion/Nexus/Cripto/Transacciones.lean) | 8 | Documento con identidad, época, cadena, nonce y contenido, codec matemático con longitud y decodificación inversa. Admisión anterior al cambio de estado, controles de cadena/nonce, consumo que evita repetición y cambio de contenido que exige otro hash o colisión. |
| [Modelos/IdealHistorico](../../../../formalizacion/Nexus/Modelos/IdealHistorico.lean) | 8 | Fórmula histórica con error por rondas, omisión y unión conservadora, conservada separada de la fórmula refinada. Techo para el número de parejas, cuatro redondeos superiores de la tabla 6.19 y unión de cuatro eventos PMF bajo inclusión y cotas individuales. |
| [ROM/RaicesCanonicas](../../../../formalizacion/Nexus/ROM/RaicesCanonicas.lean) | 10 | Puente legado de raíz a campo mediante ocho bytes LE y reducción; dominio canónico inyectivo, cola de 24 bytes ignorada, alias concretos 0/p e índices congruentes. Recuperación polinómica desde suficientes aperturas públicas distintas. |
| [Complejidad/Comunicacion](../../../../formalizacion/Nexus/Complejidad/Comunicacion.lean) | 9 | Conteo de caminos, capas y consultas del formato TG2 declarado; cota cuadrática y O(q log²N), tabla de cuatro tamaños y LDE. Cotas para bits de claves y firmas con anchos y cabeceras explícitos. |
| [Modelos/QuorumIncentivos](../../../../formalizacion/Nexus/Modelos/QuorumIncentivos.lean) | 9 | Pesos de stake normalizados e intersección honesta con umbrales estrictos o inclusivos correctos. Juego de pagos explícito: condición necesaria y suficiente de Nash y desviación unilateral rentable. Recuperación Reed-Solomon condicionada y contraejemplo a recuperación por mera duplicación. |
| [Modelos/Mediciones](../../../../formalizacion/Nexus/Modelos/Mediciones.lean) | 18 | Racionales extraídos de dos JSON R4 conservados: 175 redondeos dentro de 0.005 y ocho razones de rendimiento. Diferencia de medianas sin redondear, razones históricas H1/H2, inverso ideal de latencia, crecimiento y corrección KiB/firmas: aproximadamente 238, no 232. |
| [ROM/ColaSelector](../../../../formalizacion/Nexus/ROM/ColaSelector.lean) | 11 | Inyección de secuencias con a lo sumo q valores distintos en testigos de subconjunto; cota cardinal binomial(M,q)q^R y cola uniforme min(1,binomial(M,q)(q/M)^R). Para q=39,R=512 y los nueve perfiles, tau<2^-300. Se explicita que condicionar a trabajo válido elimina su factor. |
| [Salud/DecimalesAPT](../../../../formalizacion/Nexus/Salud/DecimalesAPT.lean) | 6 | Intervalo racional para 2^-7.5, pesos binomiales encerrados, cola partida y resto geométrico. Certifica cola del corte 15 como 1.523e-6 con error<5e-10 y del corte 16 como 2.764e-7 con error<5e-11; complementa la minimalidad ya probada. |
| [Cripto/PerdidaQROM](../../../../formalizacion/Nexus/Cripto/PerdidaQROM.lean) | 7 | Fórmula L_Q citada y parámetros de referencia B+23. Se prueba positividad, L_Q<2^-360 e intervalo del logaritmo con |log2(L_Q)+361.64|<0.005 mediante cuadrados, racionales y monotonía del logaritmo. |
| [ROM/Presupuestos](../../../../formalizacion/Nexus/ROM/Presupuestos.lean) | 6 | Forma tipada de seis aperturas AIR y dos por capa FRI, longitudes y hashes de rutas. Fórmulas de caminos, hojas, etiquetas, canal y retos, monotonía del corte y suma de presupuestos. Extremos T=16/4096: V=6943/24895 y B=5450/22106. |

## Resultados numéricos certificados

APT conserva el modelo B=1+Bin(511,2^-7.5). Los intervalos exactos certifican
las colas 1.523e-6 y 2.764e-7 con errores menores que 5e-10 y 5e-11. Se
complementa el corte mínimo 16 ya probado; no se acredita aritmética f64 ni
calificación de una fuente NIST.

La reproducción de L_Q de firmas cumple |log2(L_Q)+361.64|<0.005 y L_Q<2^-360.
La fórmula y sus parámetros son los del manuscrito; la reducción bibliográfica
y su aplicación a NEXUS conservan sus obligaciones. No se reabre QROM AIR/FRI.

Se demuestra Delta=r(p-r)/(pS), la cota de masa de dos coordenadas y la pérdida
2mDelta para productos independientes. Los números Goldilocks satisfacen
56Delta<7.069e-28. La cola uniforme del selector con R=512 es menor que 2^-300
en los nueve perfiles. Falta justificar la frescura y el potencial adaptativo
en todas las historias concretas del protocolo.

Los JSON R4 conservados dan 175 redondeos a dos decimales y ocho razones de
rendimiento. Se distingue 151.33 desde medianas completas de 151.32 al restar
las medianas previamente redondeadas. La prueba de unidades detecta y corrige
768.2 KiB/3309 B: aproximadamente 238 firmas, no 232.

## Fuentes y manuscrito

Los [antecedentes](../Modelos-Pendientes-Antecedentes/README.md) conservan 17
versiones previas. De las 280 fuentes de la auditoría anterior, **271 permanecen
idénticas y nueve cambian con copia exacta**. Se mantienen los 272 identificadores
y sus líneas. Cambian tres textos de candidatos y dos suplementos en fuentes
TG2, con versiones y hashes anteriores. Se corrigen unidades, 16 bytes de
coordenadas frente a 17 de hoja y frases que presentaban Lean totalmente pendiente.

Las [tres salidas del manuscrito](../Manuscrito-Modelos/README.md) se regeneran
desde las mismas fuentes: Word 110 páginas, PDF 99, 34 tablas, 848 celdas y
565 ecuaciones nativas. Se revisan todas las páginas renderizadas. TG1, Rust,
los corpus y las mediciones anteriores permanecen conservados.

## Verificación y límites

Compilación sin advertencias, auditoría de axiomas y replay secuencial de
154 módulos correctos. Solo aparecen propext, Classical.choice y Quot.sound.
leanchecker confía en los módulos importados; no es --fresh ni un dictamen externo.
El informe fija **320 fuentes y 160 logs**. La
[trazabilidad](revision-manuscrito.json), los [13 controles](controles.log) y la
[integridad](integridad-modelos-pendientes.json) comprueban 2357 logs de 32 etapas.

El inventario tiene 178 bloques con correspondencia parcial marcada; el registro
complementario tiene 187 bloques y diez suplementos con enlaces. Un enlace puede
cubrir solo una parte de un párrafo; esos números no son porcentajes de avance.

Siguen abiertos la reducción criptográfica y el juego bibliográfico de
SelfTarget, codecs/expansión/hedged, la NTT concreta, f64/enteros de máquina,
autorización del registro y composición de transacciones, el recorrido completo
FRI, adaptador causal, potencial adaptativo y composición ROM. También faltan
la procedencia exacta H1/H2, calificación física y custodia de despliegue.
El autor confirmó «No hay dictamen»; la revisión independiente sigue pendiente.

```powershell
python scripts/verificar_formalizacion.py --salida .tools/lean/repeticion-modelos
python scripts/verificar_revision_manuscrito.py
```
