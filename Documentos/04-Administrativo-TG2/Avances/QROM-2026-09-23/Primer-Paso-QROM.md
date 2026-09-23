# Primera etapa QROM para NEXUS TG2 v1

**Fecha:** 23 de septiembre de 2026. **Código examinado:** `01dcde960402b6c60a19242b7ae3d6ac3d82a518`. **Estado:** derivación parcial propuesta y contrastada internamente; revisión independiente pendiente.

## 1. Resultado y alcance

Se deriva una primera cota explícita en el modelo de oráculo aleatorio cuántico para la condición de trabajo obligatoria de `NEXUS-TG2-LINKED-FRI-v1`:

\[
 \Pr[\text{aceptación de un enunciado falso}]
 \leq \min\left\{1,\frac{(2(Q+C_T)+1)^2}{2^g}\right\},
 \qquad C_T=13+4\log_2T.
\]

Aquí `Q` cuenta todas las consultas al oráculo del adversario, incluida su preparación; `g` es 12 en debug y 20 en release. La cota se obtiene de una condición necesaria de aceptación. También acota la aceptación de enunciados verdaderos por un algoritmo con ese presupuesto: **no utiliza la falsedad del enunciado, la proximidad FRI ni el AIR**. Por eso resulta débil y no completa la transferencia cuántica de la cota clásica.

El avance contiene una reducción escrita, un recuento del prefijo del canal, cálculos exactos y obstáculos precisos para el paso siguiente. Las pruebas de software contrastan instancias finitas y correspondencia con el código; no sustituyen la demostración general ni su dictamen externo. El resultado no acredita seguridad incondicional de SHA3, 100 bits, conocimiento cero ni una prueba completa del sistema de firmas ML-DSA.

## 2. Modelo del experimento

1. Todas las llamadas hash del protocolo se modelan mediante un único oráculo aleatorio `H` con salida de 256 bits, accesible mediante la operación cuántica XOR. Las consultas clásicas cuentan como consultas a ese mismo oráculo.
2. El adversario comienza con información independiente de `H`, dispone de un máximo de `Q` consultas totales y entrega un enunciado y una prueba **clásicos**, para un perfil fijo `T ∈ {16,32,…,4096}` y `g ∈ {12,20}`. Se permite elección adaptativa del enunciado. No se concede preparación dependiente de `H` sin contabilizarla.
3. Se considera una sola prueba final. Un servicio que permita muchos intentos o proporcione respuestas dependientes de `H` requiere contabilizar esos accesos o construir otro experimento.
4. Para aplicar el teorema a conjuntos finitos, se toma el dominio finito que admite el registro de consultas de cada circuito adversario, ampliado para contener las entradas del verificador. No se presupone un oráculo cuántico físicamente implementado para SHA3.
5. La probabilidad se toma sobre `H`, la aleatoriedad y las mediciones del algoritmo. Una seguridad modelada así no es una demostración para la función fija SHA3-256.

## 3. De aceptación a búsqueda de una salida marcada

### 3.1. Entrada de trabajo y costo del prefijo

En [el verificador experimental](../../../../nexus/nexus-zk/experiments/tg2_linked_trace_fri.rs), la aceptación exige que

\[
 x=s_{\mathrm{final}}\parallel\mathtt{05}\parallel\operatorname{u64LE}(\mathrm{nonce}),
 \qquad \operatorname{intBE}(H(x))<2^{256-g}.
\]

La entrada `x` tiene 41 bytes. `s_final` es el estado después de absorber la constante final del FRI de composición y **antes** de absorber el nonce como mensaje del canal. El hash que comprueba trabajo y la absorción posterior del nonce son llamadas distintas.

Sea `k_t=log2(T)` y `k_c=k_t+1`. Reconstruir ese estado a partir de la prueba requiere:

| Parte del prefijo | Consultas a H |
|---|---:|
| Dominio, perfil, enunciado y raíz de traza | 4 |
| Tres coeficientes AIR | 3 |
| Identificador y constante final de cada uno de los dos FRI | 4 |
| Absorción de raíz y extracción beta de cada capa FRI | `2(k_t+k_c)` |
| Total antes del hash de trabajo | `C_T=11+2(k_t+k_c)=13+4log2(T)` |

Los 14 certificados del corpus coinciden con esta reconstrucción independiente y satisfacen el trabajo exigido. Se comprueba también el rechazo posterior de los seis certificados alejados en la regresión AIR/FRI. Haber satisfecho PoW no implica aceptación completa.

### 3.2. Reducción

Construimos `B^H` a partir del adversario `A^H`:

1. Ejecutar `A` y obtener su salida clásica.
2. Comprobar el perfil y la forma acotada que requiere la reconstrucción. Si fallan, devolver una entrada fija de 41 bytes. Este caso puede aumentar el éxito de búsqueda de `B`, pero no la aceptación real.
3. Reconstruir el prefijo del canal con a lo sumo `C_T` consultas, y devolver la entrada `x` de trabajo. **No consultar `H(x)` para confirmar el trabajo dentro de B**: esa evaluación pertenece al predicado del experimento de búsqueda.

Así `B` hace a lo sumo `q'=Q+C_T` consultas. Las ramas más cortas pueden rellenarse con consultas inútiles, sin modificar su salida. La dependencia del estado respecto de `H`, las colisiones entre roles y la elección adaptativa de raíces están permitidas: `B` es un algoritmo de oráculo arbitrario dentro de este presupuesto. No necesitamos extraer un polinomio ni un árbol Merkle para esta reducción parcial.

Para cada ejecución aceptada, la entrada que devuelve `B` está marcada, por lo que

\[
 \Pr[\mathrm{falso}\land\mathrm{acepta}]
 \leq\Pr[\mathrm{acepta}]
 \leq\Pr[H(B^H)\text{ tiene }g\text{ bits iniciales cero}].
\]

### 3.3. Aplicación de medida y reprogramación

Se usa el **Teorema 2 de DFM20**, versión `arXiv:2003.05207v3`, página PDF 5. Para cualquier algoritmo de `q'` consultas que produce `x,z`, el teorema construye un simulador de dos etapas: primero produce `x` y después recibe un reto fresco uniforme `Θ`. Su probabilidad de satisfacer un predicado está relacionada con la del algoritmo original mediante el factor `(2q'+1)^2`, sin término aditivo en esta versión. [Fuente primaria](https://arxiv.org/pdf/2003.05207v3).

Elegimos el predicado `V(x,Θ,z)=[intBE(Θ)<2^(256−g)]`. Ignora `z` y `x`; la salida `x` del simulador pertenece a la primera etapa y no puede escogerse después de recibir `Θ`. Para cada `x₀`, el teorema da

\[
 \Pr_S[x=x_0\land V(x,\Theta,z)]
 \geq\frac{\Pr_B[x=x_0\land V(x,H(x),z)]}{(2q'+1)^2}.
\]

Sumando sobre `x₀`, la probabilidad del lado izquierdo es a lo sumo `2^-g`, porque el predicado solo exige una propiedad de `Θ` uniforme. No se está condicionando retrospectivamente a que el adversario haya encontrado un nonce ganador. En consecuencia,

\[
 \Pr_B[V(x,H(x),z)]\leq(2q'+1)^2\,2^{-g}.
\]

La combinación con §3.2 y el límite trivial uno demuestra la cota propuesta. El argumento sigue siendo válido si el simulador aborta: su éxito solo disminuye. Esta especialización a PoW y su correspondencia con NEXUS son la derivación de este informe; no son un teorema específico sobre NEXUS publicado por los autores citados.

## 4. Cifras y lectura correcta

Para `T=4096`, `C_T=61` y `g=20`:

| Q adversario | Cota superior, redondeada hacia arriba |
|---:|---:|
| 0 | 0,014428138733 |
| 16 | 0,022912025452 |
| 64 | 0,060082435608 |
| 256 | 0,384545326233 |
| 512 | 1,000000000000 |

El umbral exacto de pérdida de información es `Q=451`: `2(450+61)+1=1023`, mientras que `2(451+61)+1=1025`. No es un costo de falsificación ni una predicción de tasa de ataque. El costo del prefijo y la generalidad del teorema producen una cota holgada. La probabilidad real puede ser mucho menor.

Se conservan [108 escenarios con fracciones exactas](calculos.json), para los nueve tamaños, los dos perfiles de trabajo y seis presupuestos. No se añade el factor `h_T` de la prueba clásica: multiplicar cotas marginales sin una reducción conjunta no está justificado.

## 5. Por qué la demostración ROM requiere otro argumento en QROM

### 5.1. El evento cronológico no define una propiedad de una base sin orden

La [prueba ROM](../Transferencia-ROM-2026-09-23/Transferencia-Protocolo-ROM.md) marca etiquetas conforme avanza una historia clásica. Una salida fresca que coincide con una etiqueta previamente marcada activa `Bad_H`. El oráculo comprimido usado por CMS19 trabaja con bases de consultas sin ese orden temporal.

Un contraste concreto usa dos hojas y su padre Merkle. Consultar las hojas antes del padre no activa el evento del registro clásico; consultar el padre antes de las hojas sí lo activa. Las dos ejecuciones terminan con la **misma tabla entrada/salida**. Por tanto, ese evento, con su definición actual, no puede tratarse directamente como una función de dicha tabla.

Tampoco se puede guardar una bitácora clásica completa de consultas cuánticas sin alterar el experimento. En el ejemplo exacto `N=4` con un elemento marcado, una iteración coherente de búsqueda tiene éxito uno; medir el registro de entrada antes de la consulta y continuar con la difusión deja éxito `1/4`. Es un contraste pequeño sobre medición, no una simulación del protocolo completo.

La obligación consiste en definir una propiedad de base de datos y un extractor apropiados, o utilizar otra técnica cuántica que mantenga la coherencia. La observación no refuta la prueba clásica.

### 5.2. Los 40 índices no salen de un único reto uniforme

En v1, cada llamada `H(s || I)` produce un índice; los repetidos se descartan y el estado pasa a ser el digest completo. El bucle continúa hasta reunir 40 índices distintos. El auditor clásico emplea un corte de 512 extracciones y una cota de cola; el verificador Rust no tiene ese corte.

La probabilidad ideal para una muestra completa de `q=40` posiciones, con `M=4T` y a lo sumo `G=7M/8` posiciones buenas, es

\[
 h_T=\frac{\binom{G}{q}}{\binom{M}{q}}.
\]

Pero en una base que ya contiene `q−1` índices buenos distintos y un trabajo válido, **una llamada adicional** completa el predicado de aceptación de ese candidato con probabilidad

\[
 \frac{G-q+1}{M}.
\]

Para `T=16`, este salto vale `17/64`; para `T=4096`, `14297/16384`. Ambos exceden ampliamente `h_T`. [Los nueve contrastes](calculos.json) comparan las fracciones exactas. Un caso pequeño adicional, `M=8,G=6,q=4`, da salto `3/8` frente a omisión completa `3/14`.

Este es un obstáculo a usar `h_T` como inestabilidad por consulta del **predicado terminal ingenuo**, en el modelo abstracto de un conjunto fijo de posiciones buenas. No construye un certificado NEXUS falso, ni descarta una función de estado o un potencial cuántico más adecuados. El supremo de inestabilidad considera bases parcialmente construidas; una probabilidad pequeña de llegar a ellas no permite ignorarlas sin otro argumento.

### 5.3. El factor lineal del nonce no se hereda

El potencial de la [revisión ROM](../Revision-Critica-ROM-2026-09-23/Revision-Critica-ROM.md) controla consultas clásicas adaptativas y asigna masa al nacimiento de cada candidato. No se ha demostrado una versión de ese potencial para amplitudes cuánticas.

El analizador incluye búsqueda cuántica exacta sobre un oráculo XOR de salida completa. Cada iteración calcula `H`, cambia la fase de las salidas marcadas y descalcula `H`: **dos consultas**, seguidas de difusión. Se promedia sobre todos los oráculos mediante el número binomial de elementos marcados; no se condiciona a que exista exactamente uno.

Con dos consultas y una iteración:

| Dominio N | Bits de trabajo | Éxito promedio exacto | Expresión clásica `(Q_H+1)2^-g` |
|---:|---:|---:|---:|
| 16 | 4 | `13073/32768` | `3/16` |
| 64 | 6 | `4338497/33554432` | `3/64` |

El éxito cuántico supera esa expresión lineal. Las doce configuraciones ensayadas respetan la cota cuadrática de búsqueda de §3.3. Para `N=4` y salidas de dos bits se enumeran literalmente las 256 tablas hash, comprobando el circuito XOR completo y sus ancillas para cero, una y dos iteraciones. Todo se calcula con fracciones: es simulación clásica de un experimento cuántico pequeño, sin ejecución en hardware cuántico ni ataque SHA3.

## 6. Correspondencia con los teoremas de compilación

Se conservó **CMS19**, versión de portada del 14 de enero de 2020, 56 páginas. Su Teorema 8.6 trata el compilador BCS allí definido, con error de forma `O(t²ε+t³/2^λ)` bajo solidez por rondas y un presupuesto que incluye el costo de expansión del verificador. La numeración de esta versión difiere de la versión corta de congreso. [Fuente primaria](https://eprint.iacr.org/2019/834.pdf).

Localizadores para el trabajo siguiente:

| Fuente y ubicación | Uso y obligación para NEXUS |
|---|---|
| CMS19, definición 5.6 y lemas 5.7, 5.10; PDF 24 | Inestabilidad en ambos sentidos y control del operador; sustituir el evento cronológico por una propiedad admisible |
| CMS19, §8.2; PDF 40–41 | Comparar la gramática exacta del canal y la generación de mensajes del verificador |
| CMS19, definiciones 8.3–8.5 y teorema 8.6; PDF 41–42 | Construir el estado por rondas para las transcripciones que realmente extrae el compilador |
| CMS19, lema 8.13 y fin de §8.5.1; PDF 44–45 | Calcular inestabilidad, constante, pérdidas de colisión y paso al juego de oráculo |
| CMS19, lema 4.9 y §8.6 | Incluir la corrección al pasar de base de datos a salida real y atender a las diferencias de cadenas hash |
| DFM20, teorema 2; PDF 5 | Fuente de la cota parcial de trabajo de este informe |

El factor `6` del lema básico de CMS19 acota un juego de base de datos. El término `6(t²ε+4t³/2^λ)` que aparece en su desarrollo no se presenta aquí como una cota lista para el verificador NEXUS: faltan la correspondencia de juegos, la corrección de salida y la contabilidad de expansión. Tampoco basta reemplazar `Q` por `Q²` en la cota clásica ni sustituir 20 bits por 10 y llamar al resultado una reducción.

El canal de v1 conserva el digest completo al extraer coeficientes e índices, lo cual ayuda a vincular estados. Sin embargo, sus entradas tienen varias longitudes y existe solapamiento de 65 bytes entre ciertos nodos Merkle y mensajes de enunciado. Además, la selección de 40 índices usa múltiples hashes y repeticiones. Estas diferencias requieren una adaptación demostrada. La existencia de un teorema para BCS no acredita automáticamente esta instancia.

La cota asintótica QROM del teorema 3.15 de [BGK23, revisión conservada de febrero de 2024](../../../06-Evidencia-TG2/2026-09-22/R4-solidez/bibliografia/BGK23.pdf), tampoco proporciona constantes ni correspondencia concreta por sí sola. Su notación asintótica no se convierte en un presupuesto numérico para v1 mediante sustitución directa.

## 7. Siguiente etapa, con obligaciones verificables

La ruta preferida es investigar la variante v1 actual. Una variante futura con otro canal sería un protocolo diferente que requeriría su propia versión y evidencia.

| ID | Trabajo siguiente | Condición de cierre |
|---|---|---|
| Q1 | Definir extractor y estado sobre una base sin orden | Definición total, con raíces, enunciado, formas parciales y colisiones; no depender de la historia clásica |
| Q2 | Tratar la cadena de índices y nonces conjuntamente | Desigualdad de operador o potencial cuántico que sobreviva a sobrescritura, consultas en superposición y terminación por distintos |
| Q3 | Incorporar el IOP AIR/FRI por rondas | Mostrar que las transcripciones extraídas satisfacen las hipótesis del estado; cuantificar sesgo de campo |
| Q4 | Pasar al verificador real | Pérdidas explícitas de Merkle, salida del adversario, llamadas del verificador y cola de muestreo |
| Q5 | Estudiar parámetros | Fijar presupuesto adversario y probabilidad objetivo, y evaluar una cota completa con constantes |

Si Q2 no admite una cota útil para v1, se puede especificar una variante donde la ronda final use un solo reto suficientemente ancho y una aplicación a subconjuntos con sesgo cuantificado. Concatenar muchas llamadas a SHA3 y llamarlas «una consulta» no establece esa equivalencia. Tal alternativa necesita definir un oráculo de salida ancha, la gramática y la relación con la implementación antes de modificar código.

**Estado final de esta etapa:** hay una cota QROM explícita para una condición necesaria del protocolo existente; permanece abierta una cota cuántica que aproveche AIR y ambos FRI. Las obligaciones son matemáticas y de correspondencia de modelos, no fallos de compilación. R1-A–D de ML-DSA y los requisitos de despliegue siguen teniendo sus análisis propios.

## 8. Evidencia y reproducción

- [Cálculos exactos](calculos.json), [registro de ejecución](validacion.json) y [protección de archivos previos](proteccion.json).
- [Fuentes primarias, versiones y hashes](bibliografia/fuentes.json): CMS19 y DFM20, con PDF y extracción por página.
- [Analizador](../../../../scripts/analizar_qrom_tg2.py), [doce pruebas](../../../../scripts/tests/test_qrom_tg2.py) y [registro reproducible](../../../../scripts/verificar_qrom_tg2.py).
- [Instrucciones de ejecución](README.md). La regresión conserva los resultados anteriores: 52 pruebas Python en conjunto, 197 Rust, check/build, 14 certificados y manifiesto de 897 archivos. Las fuentes y logs de esta ejecución quedan en `fuentes/` y `regresion/`.
