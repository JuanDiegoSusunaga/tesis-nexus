# Lean: distribuciones y juegos reticulares

El bloque M04–M06/M45 añade **114 resultados en nueve módulos**, para **1217 lemas
y teoremas registrados en 138 módulos**. La [auditoría conjunta](validacion.json)
es correcta. M04, M06 y M45 quedan como modelos verificados en sus alcances;
M05 tiene componentes parciales. La dureza y las reducciones de ML-DSA siguen abiertas.

| Módulo | Resultados nuevos | Alcance |
|---|---:|---|
| [Cripto/Probabilidad](../../../../formalizacion/Nexus/Cripto/Probabilidad.lean) | 20 | PMF, eventos, soporte, productos independientes y uniformes finitas |
| [Cripto/Oraculo](../../../../formalizacion/Nexus/Cripto/Oraculo.lean) | 8 | Consultas adaptativas, presupuesto e historias consistentes |
| [MLDSA/Representantes](../../../../formalizacion/Nexus/MLDSA/Representantes.lean) | 15 | Coeficientes, reducción y levantamiento centrado concreto |
| [MLDSA/Cortos](../../../../formalizacion/Nexus/MLDSA/Cortos.lean) | 11 | Conjunto S_eta, cardinalidad exacta e inyectividad de la reducción |
| [MLDSA/MSIS](../../../../formalizacion/Nexus/MLDSA/MSIS.lean) | 14 | Relación MSIS y extracción con representantes dados o canónicos |
| [MLDSA/MLWE](../../../../formalizacion/Nexus/MLDSA/MLWE.lean) | 17 | Leyes real/ideal, juegos y contraste del caso sin ruido |
| [MLDSA/SelfTarget](../../../../formalizacion/Nexus/MLDSA/SelfTarget.lean) | 10 | Relación tipada y juego clásico con tabla finita |
| [Cripto/Firma](../../../../formalizacion/Nexus/Cripto/Firma.lean) | 11 | Corrección y juegos EUF/sUF con consultas y registros |
| [Cripto/Seguridad](../../../../formalizacion/Nexus/Cripto/Seguridad.lean) | 8 | Familias despreciables, implicación sUF→EUF y separación de eventos |

## Distribuciones y representantes

Se utilizan PMF normalizadas de mathlib. Los eventos tienen probabilidad finita
entre cero y uno; se prueban transporte por funciones, composición, soporte,
productos con masas factorizadas y marginales, y la fórmula cardinal de la
uniforme finita. Los mensajes y registros de los juegos de firma pueden tener
tipos infinitos; no se impone una cota artificial a su longitud mediante Fintype.

Se construyen polinomios desde 256 coeficientes y se recuperan estos exactamente.
La reducción conmuta con los coeficientes y se construye el levantamiento
centrado Rq→R, sección de la reducción e inyectivo. S_eta se identifica con
256 coeficientes enteros en [−eta,eta], tiene cardinalidad (2eta+1)^256 y es
no vacío. Si eta≤4190208, su reducción es inyectiva y conserva norma. Esto
cubre eta=2/4 de los perfiles, sin acreditar su muestreador o expansión reales.

## MLWE, MSIS y extracción

La ley real sortea A, s y e uniforme e independientemente en los espacios
de §6.2.3 y devuelve (A,As+e). La ley ideal devuelve (A,u) con u uniforme.
Se demuestra el soporte y que A mantiene su marginal uniforme. Se definen
el distinguidor probabilístico y el juego de búsqueda del secreto, y se acotan
sus ventajas. La inyectividad permite recuperar el secreto entero corto desde
su reducción bajo la cota indicada.

El caso eta=0 ilustra el límite de una definición: As+e es siempre cero. El
evento tiene probabilidad uno en la ley real y 1/q^(256k) en la ideal. Un
distinguidor explícito tiene ventaja 1−1/q^(256k). Esto no describe los perfiles
ML-DSA y no se presenta como un ataque a ellos.

La relación MSIS exige un vector no nulo módulo q, ecuación A·z=0 y norma
centrada acotada. Su buscador solo recibe A uniforme. Se prueba que centrar no
aumenta la norma y se concreta el lema 6.1 tanto para levantamientos canónicos
como para **representantes enteros dados**: su diferencia sigue siendo no nula
módulo q, pertenece al núcleo y tiene norma entera y modular a lo sumo 2L.
L es natural y se usa norma infinito. No es extracción desde una firma real
ni una prueba de dureza o de la reducción de peor caso.

## Consultas y juegos de firma

Un programa recibe respuestas por ramas adaptativas y tiene un presupuesto
máximo de consultas. El intérprete registra cada par, conserva el prefijo de
historia y respeta el presupuesto. Una función fija responde consistentemente
a consultas repetidas. Son consultas clásicas; no se modela superposición.

KeyGen y Sign son algoritmos probabilísticos y Verify devuelve Bool. La
corrección se expresa por una cota de probabilidad y se prueba bajo corrección
perfecta en el soporte. El adversario CMA recibe pk; sk solo se usa para
interpretar el oráculo de firma. El evento EUF exige un mensaje no consultado;
sUF exige un par mensaje–firma nuevo. Se prueba **Adv_EUF≤Adv_sUF**, validez de
la historia bajo corrección perfecta e igualdad de ventajas bajo firmas únicas.

Se definen familias no negativas despreciables y se prueban cierre por
dominación y suma. Las familias de juegos y corrección se indexan por el
parámetro de seguridad, con tipos y presupuestos dependientes de él.
El error de corrección se exige en [0,1] antes de convertirlo a real. La
seguridad sUF implica EUF para la misma clase de eficiencia, que permanece
como parámetro explícito: no se ha mecanizado una semántica de máquinas PPT.

Un ejemplo de ejecución consulta un mensaje, recibe false como firma y
devuelve true como firma del mismo mensaje. Para **ese adversario**, EUF=0
y sUF=1. Distingue las condiciones de victoria; no afirma que el esquema de
ejemplo sea globalmente EUF seguro.

## SelfTarget y límites de correspondencia

Se fija el testigo como dos bloques, de m y r+1 componentes, con norma máximo
y último componente existente. Se demuestra que su valor es [I_m|A]y. La
relación exige H aplicado al valor y mensaje codificados igual al último
componente. El alfabeto del reto y las codificaciones inyectivas se parametrizan.
Se construye un juego clásico con matriz y tabla uniforme independientes sobre
un dominio finito y un adversario que accede a la tabla por consultas. Se
demuestran presupuesto, consistencia y cotas necesarias para el testigo.

**M05 permanece parcial:** faltan identificar retos y bytes con JMW24/ML-DSA,
la correspondencia del juego bibliográfico y su oráculo cuántico, y la reducción
desde firmas. Esta etapa no demuestra seguridad QROM de firmas ni reabre el
trabajo futuro QROM AIR/FRI. R1 conserva su alcance.

## Trazabilidad, verificación y pendientes

Se añaden o amplían correspondencias en **15 bloques**. El inventario llega a
**98 bloques enlazados**, 97 marcados como revisión parcial, y la revisión
complementaria a **108 bloques parciales**, además de dos suplementos previos.
Se conservan 272 candidatos, 14 omisiones, 46 grupos, ocho fuentes y sus textos,
líneas e identificadores. Hay diez modelos verificados, 17 grupos parciales,
13 pendientes, tres dependencias, dos respaldos y QROM AIR/FRI futuro.
Los grupos tienen tamaños distintos y no constituyen porcentajes de trabajo.

Los [antecedentes](../Juegos-Reticulares-Antecedentes/README.md) conservan quince
versiones anteriores. De las 254 fuentes anteriores, siete registros o
herramientas cambian con copia y **247 permanecen idénticas**, incluidas las
evidencias empíricas históricas. Los capítulos, TG1 y Rust no cambian. No se
ejecutan nuevos benchmarks o cargo, ni se atribuyen al binario estas pruebas.

```powershell
python scripts/verificar_formalizacion.py --salida .tools/lean/repeticion-juegos-reticulares
python scripts/verificar_revision_manuscrito.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_revision_manuscrito.py
```

Compilación y axiomas pasan sin advertencias; solo se admiten propext,
Classical.choice y Quot.sound. El núcleo recompueba **138 módulos secuencialmente
confiando en importados**, sin --fresh y sin dictamen externo. El informe fija
**280 fuentes y 144 logs**. Los [13 controles auxiliares](controles.log),
la [revisión](revision-manuscrito.json) y la [integridad final](integridad-juegos-reticulares.json)
conservan **2197 logs de 31 etapas**, incluidos los 2053 previos, y fijan la documentación.

Siguen la cadena de reducciones criptográficas y sus distribuciones, retículos
y mínimos sucesivos (M02), FSwA y su simulación (M07–M08), SelfTarget bibliográfico,
sesgo modular/híbridos (M38), otros grupos del manuscrito y las correspondencias
integrales con Rust/ROM. El dictamen independiente permanece pendiente.
