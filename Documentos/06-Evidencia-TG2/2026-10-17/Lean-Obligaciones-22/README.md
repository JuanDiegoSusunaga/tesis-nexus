# Pasada de las 22 obligaciones parciales

La [auditoría conjunta](validacion.json) comprueba **1610 resultados en 177 módulos**.
Se añaden **164 resultados en 20 módulos** y se revisan los 22 grupos iniciales.
Cierran sus modelos **M10, M32 y M46**; **19 grupos siguen parciales**. Hay 21
modelos verificados, tres dependencias bibliográficas, dos respaldos documentales
y QROM AIR/FRI futuro. **La tesis completa no está verificada.**

Los [criterios originales y pendientes de los 22](../Obligaciones-22-Antecedentes/revision-22.json)
se conservan. Ningún criterio se reduce para cerrar un grupo. Se actualizan
109 correspondencias. Los 272 candidatos y 14 suplementos conservan texto,
identidad y líneas: 211 bloques del inventario y 215
del registro tienen enlaces parciales, con 639 enlaces de alcance. Son
conteos de cobertura, no un porcentaje demostrado de formalización.

| Módulo | Resultados | Alcance |
|---|---:|---|
| [Merkle/RegistroVerificador](../../../../formalizacion/Nexus/Merkle/RegistroVerificador.lean) | 9 | Evaluador Merkle que devuelve digest y consultas en orden desde la hoja; coincide con el bucle indexado y produce el registro exigido por extracción. Forma incorrecta rechaza sin hashes; aceptación registra cada entrada y cuesta altura+1 consultas. |
| [FRI/Recorrido](../../../../formalizacion/Nexus/FRI/Recorrido.lean) | 18 | Bucle con Option, rechazo persistente, prefijos, posiciones, autenticación y acarreo extraídos de ejecución aceptada; ecuaciones de plegado y constante final, aceptación de una muestra y de ambas fases. Comprobaciones de longitudes de listas y rechazo con cero capas. |
| [Canal/AceptacionRecorridos](../../../../formalizacion/Nexus/Canal/AceptacionRecorridos.lean) | 4 | Las dos ejecuciones FRI dan las premisas de aceptación compartida AIR/FRI con raíz inicial común, seis aperturas y enlace local. Cota de la rama de candidato no base a partir de controles de base de la muestra, sin exigir que el oráculo completo sea base. |
| [MLDSA/ContrasteJMW](../../../../formalizacion/Nexus/MLDSA/ContrasteJMW.lean) | 9 | Gamma de extracción se deriva como max(gamma1-beta,2gamma2+1+2^(d-1)tau), dimensiones desde k+ell+1 y tipos Fin; conexión con N12, cuentas de los tres perfiles y fallo de la condición para todo etaAux>=1 y toda gamma mayor. |
| [MLDSA/Retos](../../../../formalizacion/Nexus/MLDSA/Retos.lean) | 10 | Alfabeto concreto B_tau de polinomios con coeficientes centrados en {-1,0,1} y peso tau; norma uno y no nulidad para tau>0, soporte y construcción con signos. Instanciación de la relación SelfTarget con ese alfabeto. |
| [FRI/RetosAfines](../../../../formalizacion/Nexus/FRI/RetosAfines.lean) | 7 | Cambio biyectivo entre beta y el peso afín en un representante no nulo, fórmula de mariposa y cardinales de preimágenes. Normalización global x=a*y con reto beta/a, equivalencia del plegado y conservación de uniformidad por conteo. |
| [Cripto/RotacionFirmada](../../../../formalizacion/Nexus/Cripto/RotacionFirmada.lean) | 7 | Autorización saliente y posesión entrante se obtienen verificando firmas del mensaje tipado que incluye época y todas las claves siguientes. Instalación exige ambas, conserva identidades e historial y rechaza propuesta repetida o firma ausente. |
| [Cripto/OperacionBytes](../../../../formalizacion/Nexus/Cripto/OperacionBytes.lean) | 7 | Formato de operation_bytes de registry.rs: dominio ASCII de 22 bytes, identidad de 32, época u64, longitud u64 y mensaje; cuenta 70+len, recuperación de campos e inyectividad. |
| [Salud/RachasCondicionales](../../../../formalizacion/Nexus/Salud/RachasCondicionales.lean) | 8 | Cota de rachas con leyes condicionadas por símbolo inicial e historia repetida, sin exigir IID. Composición con el corte RCT, límites de rachas no fallidas y del incremento del contador u64 del perfil. |
| [Salud/InvariantesLote](../../../../formalizacion/Nexus/Salud/InvariantesLote.lean) | 8 | Invariante muestras<65536 e histograma[i]<=muestras preservado por muestra, lote, recuperación y rotación; límites de incrementos de muestras/histograma y época rotada en u64. |
| [MLDSA/NTTAlgebra](../../../../formalizacion/Nexus/MLDSA/NTTAlgebra.lean) | 7 | Transformada radix dos recursiva sobre árbol par/impar, grado del polinomio y corrección completa por inducción frente a evaluación en coset; raíz de mitad y raíz siguiente, unicidad por evaluaciones e instancia ML-DSA de 256 coeficientes con zeta=1753. |
| [Complejidad/ContadorFirma](../../../../formalizacion/Nexus/Complejidad/ContadorFirma.lean) | 9 | Bloques de máscaras disjuntos, validez de índices u16, capacidad floor(65536/ell), incremento y rollover separados. Capacidades 16384/13107/9362 y fronteras de los tres perfiles; enlace con cola geométrica ideal. |
| [Complejidad/SerializacionPrueba](../../../../formalizacion/Nexus/Complejidad/SerializacionPrueba.lean) | 8 | Conteo de bytes desde codificación de vectores y caminos: 8+32h por camino, 48+64h por capa FRI y suma de capas de longitud variable. Se separan 102 bytes fijos de prueba y 24 de enunciado; el certificado cuenta 126. |
| [FRI/FormasLimites](../../../../formalizacion/Nexus/FRI/FormasLimites.lean) | 9 | Para k<=12, tamaños de dominio <=32768 y dentro de u64, mitades positivas e índices de ambas aperturas válidos; lecturas de listas aceptadas en rango, longitudes de zip y rechazo de longitudes incorrectas. |
| [Modelos/LayoutBackend](../../../../formalizacion/Nexus/Modelos/LayoutBackend.lean) | 6 | Campos del PrivateKey histórico: 32+32+64 bytes y arreglos L,K,K de 256 i32. Suma y alineación declaradas, perfiles 12416/17536/23680 y enlace del perfil 65 con el modelo de memoria; reordenar conserva la suma. |
| [ROM/ReconstruccionPublica](../../../../formalizacion/Nexus/ROM/ReconstruccionPublica.lean) | 5 | Dieciséis índices distintos de un dominio de 128 dan nodos distintos; interpolación recupera cualquier polinomio de grado<16 y, para la traza del ejemplo, la segunda fila 5. |
| [ROM/SelectorRechazo](../../../../formalizacion/Nexus/ROM/SelectorRechazo.lean) | 12 | Proyección a conjuntos del selector con duplicados y parada: cardinal min(objetivo,distintas), terminación por suficientes distintas y equivariancia por permutaciones. Máscara binaria igual a residuo y fibras uniformes para potencias de dos. El selector incompleto coincide con pocas distintas y su probabilidad ideal tras 512 extracciones es <2^-300 en nueve perfiles. |
| [ROM/PotencialCandidatos](../../../../formalizacion/Nexus/ROM/PotencialCandidatos.lean) | 10 | Potencial de árboles de pruebas frescas con creación adaptativa, intercalación, abandono, repeticiones y parada. Se demuestra riesgo<=potencialInicial+B*rho y desde vacío B*rho; trabajo se cobra antes de responder y se conserva el factor en la cota de inicios<=Q+1. |
| [ROM/ComposicionCotas](../../../../formalizacion/Nexus/ROM/ComposicionCotas.lean) | 7 | Unión de tres eventos bajo una misma ley, transporte por variación total, composición de errores ROM/excepciones/consulta y suma de presupuestos. Se conserva la cota del juego ROM ya demostrado sin su mínimo con uno. |
| [ROM/EjemploNumerico](../../../../formalizacion/Nexus/ROM/EjemploNumerico.lean) | 4 | Fórmula exacta de tres términos con mu, S=Q+V, presupuestos, hipergeométrica y cola. Para T=4096,g=20,Q=2^20 se certifica el intervalo (0.004757335453,0.004757335454]; para Q=2^28 la expresión truncada satura en uno. |

## Cierres y límites

M10 deriva gamma y dimensiones desde los tipos y parámetros de ML-DSA y
conecta las cuentas con N12. La condición necesaria de JMW24v2 falla en los
tres perfiles para todo etaAux>=1. No demuestra una reducción ni un ataque.
Se identifica la [fuente primaria versionada](https://arxiv.org/html/2312.16619v2)
y se preservan la copia PDF/texto de R1 y su identidad.

M32 deriva ambas aceptaciones FRI de un bucle con rechazo, acarreo y comparación
final, con longitudes comprobadas e índices acotados. Se enlaza con las seis
aperturas AIR y la composición local de la consulta compartida. Los registros
de aperturas y ausencia de colisiones siguen expresos; el evaluador Merkle
nuevo produce sus consultas locales, pero no constituye todo el adaptador Rust.

M46 enlaza candidato próximo/no base con controles locales de base de la muestra
autenticada y con su cota. No se recibe como hipótesis que todo el oráculo sea
base. Uniformidad de la muestra y familias causales del protocolo conservan
sus obligaciones en M35/M37/M40.

El potencial nuevo permite crear candidatos adaptativamente, responder a uno,
abandonar otro, intercalar y repetir. Se prueba riesgo<=potencialInicial+B*rho.
Cada candidato aún debe identificarse con un árbol de respuestas frescas cuya
cota se justifique antes de responder. Las premisas locales no se sustituyen
por una hipótesis de seguridad global.

El ejemplo ROM fija los tres términos de §6.7.9 y prueba exactamente
0.004757335453 < expresión <= 0.004757335454 para T=4096,g=20,Q=2^20;
con Q=2^28 el mínimo con uno satura. Es aritmética de la fórmula propuesta,
no certificación del ejecutable. Los eventos y sus distribuciones siguen pendientes.

## Comprobaciones

Compilación y axiomas correctos sin advertencias; replay de los 177 módulos.
Solo se admiten propext, Classical.choice y Quot.sound. leanchecker confía en
importados; no es --fresh ni un dictamen externo. La auditoría fija 396
fuentes y 183 logs. Los [13 controles](controles.log), la
[trazabilidad](revision-manuscrito.json) y la [integridad](integridad-obligaciones-22.json)
comprueban conservación de la edición anterior y de todas las etapas históricas.

Se conservan 16 versiones previas y 13 fuentes consultadas. Los capítulos y las
salidas Markdown/Word/PDF, Rust y TG1 conservan sus bytes. El autor confirmó que
no hay dictamen. Los próximos trabajos concretos están en la
[revisión de los 22](../Obligaciones-22-Antecedentes/revision-22.json) y en la
[matriz vigente](../../../../formalizacion/REVISION-MANUSCRITO.md).
