# Selector, codecs y ciclos firmados

La [auditoría](validacion.json) comprueba **1686 resultados en 187 módulos**:
se añaden **76 resultados en diez módulos**, con 66 correspondencias nuevas
en nueve grupos. **Se conservan 19 grupos parciales y 21 modelos verificados
en su alcance. Esta etapa no cierra ningún grupo completo.**

Se prueban partes concretas que antes figuraban pendientes: el cardinal de
B_tau, producto negacíclico mediante NTT, cuenta del plan con mitades
compartidas, uniformidad del selector terminado, hipergeométrica de su salida,
pérdida por aborto, leyes frescas tras tabla e historia causal finitas,
parser de operation_bytes y cadenas de rotaciones autorizadas.

| Módulo | Resultados | Alcance |
|---|---:|---|
| [MLDSA/CardinalRetos](../../../../formalizacion/Nexus/MLDSA/CardinalRetos.lean) | 7 | Biyeción entre retos B_tau y elección de tau posiciones con un signo por posición. Cardinal exacto choose(256,tau)*2^tau, no vaciedad equivalente a tau<=256 y vacío fuera de dimensión. |
| [MLDSA/ProductoNTT](../../../../formalizacion/Nexus/MLDSA/ProductoNTT.lean) | 8 | Las 256 evaluaciones en zeta*(zeta^2)^i anulan X^256+1. La evaluación del representante es multiplicativa, aditiva y biyectiva en Rq. Enlace del producto negacíclico con el producto coordenado de las dos transformadas recursivas. |
| [Complejidad/CosteNTT](../../../../formalizacion/Nexus/Complejidad/CosteNTT.lean) | 8 | Cuenta exacta de mariposas de un plan radix dos que comparte las dos mitades. Para n=256: 1024 mariposas, 2048 sumas y 1024 productos; identidad n*log2(n) y cota del trabajo de campo. |
| [ROM/UniformidadSelector](../../../../formalizacion/Nexus/ROM/UniformidadSelector.lean) | 6 | Toda permutación transporta la salida del selector. Se construye una biyección entre fibras de dos subconjuntos del mismo tamaño. Partición de las palabras completas y uniformidad exacta del q-subconjunto condicionada a completar antes de un corte fijo. |
| [ROM/LeySelector](../../../../formalizacion/Nexus/ROM/LeySelector.lean) | 5 | Partición de selecciones completas contenidas en G. La probabilidad condicionada coincide exactamente con choose(cardG,q)/choose(M,q), satisface H(M,q,theta) y la cota exponencial. Composición aritmética de la mezcla con un fallo de masa tau. |
| [ROM/AcoplamientoSelector](../../../../formalizacion/Nexus/ROM/AcoplamientoSelector.lean) | 6 | Ley racional normalizada que aborta con masa tau y, al completar, devuelve un q-subconjunto uniforme. Su variación total respecto de la muestra ideal es exactamente tau; todo evento pierde a lo sumo tau. Para el corte 512 y los nueve perfiles, la pérdida modelada es menor que 2^-300. |
| [ROM/FrescuraFinita](../../../../formalizacion/Nexus/ROM/FrescuraFinita.lean) | 6 | Biyeción de completaciones de una tabla parcial con funciones en las claves libres y cardinal exacto. Cada respuesta en una clave ausente tiene masa condicionada 1/cardA; las respuestas repetidas están fijadas y una respuesta distinta es imposible. |
| [ROM/HistoriaCausal](../../../../formalizacion/Nexus/ROM/HistoriaCausal.lean) | 7 | La estrategia depende de prefijos de respuestas. Para toda historia admisible, sus tablas compatibles equivalen a completaciones de las consultas vistas, con cardinal exacto. La siguiente respuesta fresca es uniforme condicionada a esa historia; repeticiones conservan respuesta y distintas consultas no superan la longitud del registro. |
| [Cripto/DecodificacionOperacion](../../../../formalizacion/Nexus/Cripto/DecodificacionOperacion.lean) | 10 | Parser computable del sobre operation_bytes: comprueba dominio, 70 bytes de cabecera y longitud declarada exacta. Ida y vuelta, recodificación canónica, rango u64 de la longitud aceptada, rechazo de truncamientos, dominio y longitud incorrectos. |
| [Cripto/CiclosFirmados](../../../../formalizacion/Nexus/Cripto/CiclosFirmados.lean) | 13 | Ejecución de listas de propuestas equivalente a una cadena de instalaciones firmadas. Época e historial crecen exactamente con la longitud, se conservan checkpoint, identidades y clave predeterminada. Épocas de propuestas distintas, rechazo persistente y rechazo de repetir cualquier propuesta aplicada; la época anterior deja de estar vigente. |

## Límites concretos

La prueba del selector parte de palabras uniformes independientes. Completar
antes de un corte fijo induce un q-subconjunto uniforme, con probabilidad
exacta choose(cardG,q)/choose(M,q) de quedar dentro de G. La ley que aborta
con masa tau tiene variación total exactamente tau respecto de la uniforme
ideal, y cualquier evento cambia a lo sumo tau. Para el corte 512 y los nueve
perfiles la pérdida modelada es menor que 2^-300. **512 es un corte del análisis.**

Una estrategia causal elige cada consulta de prefijos anteriores. Condicionar
a una historia admisible fija restringe exactamente las claves observadas;
las funciones restantes son las completaciones de esa tabla. La siguiente
respuesta es uniforme si su clave está ausente. No se condiciona a sucesos
futuros. **Queda derivar las estrategias y claves frescas de todos los eventos
del protocolo y de su memoria compartida.** El dominio del nuevo modelo es
finito, y no se deduce que SHA3 tenga estas leyes.

La NTT da una biyección algebraica Rq hacia 256 evaluaciones y conserva suma
y producto. No implementa una inversa eficiente ni verifica orden del backend,
Montgomery o enteros. La cuenta de 1024 mariposas, 2048 sumas y 1024 productos
corresponde al plan completo con mitades compartidas y factores disponibles;
no se atribuye ese coste a llamadas repetidas de la función de evaluación.

El parser comprueba dominio, cabecera y longitud exacta del sobre TG2. No es
el bincode de transacciones TG1. Las cadenas de rotación conservan firmas,
identidades, épocas y checkpoint como prefijo, pero no altas/retiros, archivo
completo, borrado o custodia durable. No se afirma secrecia hacia adelante.

Los [criterios y pendientes](../Selector-Ciclos-Antecedentes/revision-selector-ciclos.json)
conservan los estados y criterios anteriores. Los pendientes históricos quedan
archivados; los vigentes distinguen qué parte ya está demostrada. Las reducciones
criptográficas, Rust/f64 y composición global ROM mantienen sus obligaciones.
QROM AIR/FRI sigue futuro y el autor confirmó que no hay dictamen.

## Validación y conservación

Compilación, auditoría de axiomas y replay de los 187 módulos correctos.
Los únicos axiomas permitidos son propext, Classical.choice y Quot.sound.
El replay confía en importados; no es --fresh ni revisión independiente.
Se fijan 427 fuentes y 193 logs. Los [13 controles](controles.log),
la [trazabilidad](revision-manuscrito.json) y la [integridad](integridad-selector-ciclos.json)
validan las etapas y logs históricos y la recuperación de los 4181 archivos de
la edición anterior mediante sus versiones conservadas. Se archivan 16 versiones
y dos fuentes; los capítulos, Markdown/Word/PDF publicados, Rust y TG1 no cambian.

El inventario conserva 211 bloques con enlaces parciales; la revisión,
215 bloques y diez suplementos, con 817 enlaces de alcance. Los
conteos no miden por sí solos el porcentaje de formalización de la tesis.
