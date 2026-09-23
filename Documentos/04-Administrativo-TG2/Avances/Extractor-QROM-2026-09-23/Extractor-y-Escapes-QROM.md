# Extractor sin orden y escapes de campo en QROM

**Fecha:** 23 de septiembre de 2026. **Código:** `01dcde960402b6c60a19242b7ae3d6ac3d82a518`. **Estado:** derivación propuesta y contrastes internos; dictamen independiente pendiente.

## 1. Qué se resuelve en esta etapa

Se construye un extractor determinista del prefijo AIR/FRI de TG2 v1 sobre una base de pares hash **sin orden temporal**. Se demuestra una condición necesaria para que una inserción modifique la extracción. Esto permite definir y acotar, mediante los lemas de CMS19, una propiedad de la base comprimida que detecta escapes algebraicos AIR/FRI.

El resultado cuantitativo propuesto es

\[
 \Pr[D_L\in\mathcal C\cup\mathcal F]
 \leq \min\left\{1,6L^2\left(\frac N2\mu+\frac{49L+1}{2^{256}}\right)\right\},
 \quad N=8T,\quad
 \mu=\left(\frac{\lfloor2^{128}/p\rfloor+1}{2^{128}}\right)^2.
\]

`D_L` es la base obtenida al medir el registro de base **al final de la simulación de oráculo comprimido** tras como máximo `L` consultas. `C` es la propiedad de colisión de salidas, y `F` la existencia de una transición excepcional de campo definida en §5. El registro se introduce en la demostración; el extractor no supone acceso físico a una lista clásica de consultas del adversario.

**Esta probabilidad no es la probabilidad de aceptación del verificador NEXUS.** Todavía faltan la selección encadenada de índices, el tratamiento conjunto con los nonces y la transferencia desde el juego de base de datos al juego de salida real. El resultado aporta el componente de campo de una futura reducción. La cota PoW de la [etapa anterior](../QROM-2026-09-23/Primer-Paso-QROM.md) conserva su propio alcance.

## 2. Base de consultas, colisiones y etiquetas

Sea `D` una aplicación parcial finita de cadenas de bytes a digests de 32 bytes. Solo contiene pares entrada/salida; no registra el instante de consulta. Es libre de colisiones cuando entradas diferentes tienen salidas diferentes. En ese caso cada digest tiene como máximo una preimagen registrada, incluso cuando una entrada admite dos interpretaciones sintácticas.

Definimos

\[
 W(D)=\bigcup_{x\in\operatorname{dom}(D),\ |x|\le79}
       \{\text{ventanas contiguas de 32 bytes de }x\}.
\]

Cada entrada aporta a lo sumo 48 ventanas; por tanto `|W(D)|≤48|D|`. Las consultas ajenas de más de 79 bytes no aportan ventanas porque no pueden ser una entrada usada por el extractor. Sus salidas sí participan en la propiedad global de colisión.

El dominio del oráculo cuántico puede restringirse al conjunto finito representable por cada algoritmo de consultas acotadas. Una codificación inyectiva de longitud y contenido lo incluye en un dominio binario fijo para usar el formalismo de CMS19. Las ventanas se calculan sobre las cadenas decodificadas del protocolo. La salida sigue siendo uniforme de 256 bits.

Las inserciones consideradas son `D'=D∪{x↦y}`, con `x` nuevo. El lema de estabilidad no afirma lo mismo para sobrescribir arbitrariamente una entrada existente. La inestabilidad de CMS19 se define mediante inserciones y dos direcciones de cambio; sus lemas cuánticos relacionan esa definición con el operador del oráculo comprimido.

## 3. Extractor del canal y de Merkle

### 3.1. Vector Merkle completado

Dados `D`, una raíz `r` y un tamaño `n` potencia de dos, `M(D,r,n)` busca la preimagen única registrada de `r`.

- En un nodo interno, solo se admiten 65 bytes con prefijo `01`; los dos digests hijos se recorren con tamaño `n/2`.
- En una hoja, solo se admiten 17 bytes con prefijo `00` y dos coordenadas canónicas menores que `p`.
- Una preimagen ausente o de forma incorrecta completa con ceros la región correspondiente.
- Si la base contiene una colisión, el extractor señala fallo. Fuera de colisiones, siempre devuelve exactamente `n` elementos de `K`.

El tamaño disminuye en cada nivel: incluso una asignación artificial de hashes con ciclos termina. La compleción con cero es una elección del análisis, no un procedimiento para recuperar datos desconocidos desde una raíz pública.

**Lema de aperturas registradas.** Si `D` es libre de colisiones y contiene todas las entradas/salidas de una apertura Merkle válida de `r` en la posición `i`, entonces `M(D,r,n)[i]` coincide con el valor abierto.

**Prueba.** La raíz de la apertura y la del extractor tienen la misma preimagen registrada por unicidad. Por lo tanto sus dos hijos coinciden. Repetir el argumento a lo largo del camino fija cada hermano y finalmente la preimagen canónica de la hoja. La extracción devuelve ese valor. Las ramas ajenas a ese camino pueden permanecer incompletas. ∎

### 3.2. Prefijo del canal

`E(D,σ;T,g)` retrocede desde un estado fijo `σ` por preimágenes registradas, con un máximo de `C_T=13+4log2(T)` pasos. Identifica exactamente el inicio `H(DOMINIO)`, las absorciones con etiqueta y longitud y las extracciones `estado || E`.

Después comprueba hacia adelante que los pasos forman un prefijo de la gramática de v1:

1. Dominio, perfil exacto `(T,g)`, enunciado canónico y raíz de traza.
2. Tres extracciones alpha.
3. Etiqueta de traza, `log2(T)` pares raíz/beta y constante final.
4. Etiqueta de composición, `log2(T)+1` pares raíz/beta y constante final.

Se acepta cualquier prefijo que termine en una frontera entre esos pasos. Los estados sin cadena completa hasta el dominio, los ciclos del canal, los datos mal formados y las secuencias incompatibles devuelven `⊥`. La primera raíz FRI de traza debe coincidir con la raíz AIR. Cada raíz extrae un vector con su tamaño prescrito; la raíz inicial y la primera de traza comparten el mismo vector.

El enunciado queda dentro de la transcripción extraída; el perfil externo `(T,g)` se mantiene fijo. **El extractor termina antes del nonce y de los índices.** Un prefijo de los que preceden a un `E` determina si ese reto corresponde a un alpha o a un beta de una capa concreta.

La reconstrucción es retrospectiva: los vectores pertenecen a la base examinada, sin afirmar que estuvieran completos al enviar la raíz. El lema siguiente controla cómo pueden cambiar cuando cambia la base. Esa diferencia evita usar la hipótesis cronológica que impedía aplicar directamente el análisis clásico.

Una entrada de 65 bytes puede actuar simultáneamente como nodo Merkle y absorción del enunciado. Cada recorrido usa su formato y la misma relación hash. Los tests incluyen una asignación artificial con ese solapamiento; no se postula separación global de dominios.

## 4. Lema de estabilidad de la extracción

**Lema E.** Fijados `T,g,σ`, sean `D` y `D'=D∪{x↦y}` libres de colisiones, con `x∉dom(D)`. Entonces

\[
 E(D,\sigma;T,g)\ne E(D',\sigma;T,g)
 \quad\Longrightarrow\quad y\in W(D)\cup\{\sigma\}.
\]

Para el vector Merkle aislado se cumple la versión

\[
 M(D,r,n)\ne M(D',r,n)\quad\Longrightarrow\quad y\in W(D)\cup\{r\}.
\]

**Prueba para Merkle.** Si la primera preimagen examinada cambia, el nuevo par debe producir la raíz `r`. En otro caso, ambos recorridos siguen la misma entrada antigua. En el primer subproblema que difiera, el digest buscado es un hijo de una entrada antigua de 65 bytes, por lo que pertenece a `W(D)`. La inserción solo puede cambiar su preimagen cuando su salida es ese digest. Esto también cubre pasar de una región ausente, completada con cero, a una región conocida. ∎

**Prueba para el canal.** Supongamos `y∉W(D)∪{σ}`. La consulta inversa inicial en `σ` no cambia. Cada predecesor que se sigue es una ventana de una entrada antigua del canal, de longitud a lo sumo 79. Tampoco cambia su preimagen. Los recorridos crudos, sus fallos y sus pasos coinciden, y la comprobación de gramática es idéntica.

Si el prefijo es válido, cada raíz extraída aparece como campo de una de esas mismas entradas antiguas. Por tanto está en `W(D)`. Aplicando la versión Merkle a cada raíz, todos los vectores completados coinciden. Se obtiene igualdad de transcripciones, que prueba la contraposición. ∎

La premisa sobre colisiones es necesaria: una colisión nueva puede hacer fallar el extractor global. El parámetro `σ` debe estar fijo durante la comparación; no se afirma estabilidad si se cambia simultáneamente el estado examinado. Sobrescribir el valor del dominio puede destruir una cadena aunque el nuevo digest no esté en las etiquetas; por eso no se confunde sobrescritura con inserción.

El resultado adapta la idea del **lema 8.8 de CMS19**, PDF 43, a las codificaciones variables de v1, sus hojas de campo y sus prefijos. La cota de 48 ventanas y la comprobación concreta son parte de esta derivación. [Fuente primaria](https://eprint.iacr.org/2019/834.pdf), [copia identificada de enero de 2020](../QROM-2026-09-23/bibliografia/CMS19.pdf).

## 5. Propiedad de escape algebraico sobre bases

Para cada transcripción extraída que termine justo antes de un reto `E`, definimos un conjunto `B(tr)⊆K`:

- Si el enunciado es verdadero, el prefijo no corresponde a ese reto o el estado ya escapó, `B(tr)=∅`.
- En el alpha crítico del candidato base, contiene los valores que anulan la combinación de residuos; hay a lo sumo uno.
- En un beta de la fase FRI activa, contiene los valores excepcionales del lema de conservación del conjunto de acuerdo; hay a lo sumo `n_j=N/2^(j+1)`.
- En los demás retos, es vacío.

La definición usa el estado y los lemas A–B de la [derivación por rondas](../Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md), con umbrales `1/8`. Cada prefijo válido determina todos los vectores y retos necesarios para seleccionar el caso. Los vectores completados son oráculos completos sobre `K`, por lo que cumplen el tipo de entrada de esos lemas. No se exige calcular eficientemente la distancia a Reed–Solomon ni enumerar todos los conjuntos de acuerdo.

Así, para todo prefijo, `|B(tr)|≤N/2`. La aplicación de un digest a `K` es

\[
 \phi(y)=\big(\operatorname{intLE}(y_{0:16})\bmod p,
                  \operatorname{intLE}(y_{16:32})\bmod p\big).
\]

Cada elemento de `K` tiene masa a lo sumo `μ` bajo un digest uniforme. Por tanto, para una transcripción fija,

\[
 \Pr_y[\phi(y)\in B(tr)]\le\varepsilon_T:=\frac N2\mu.
\]

Definimos `F` como las bases libres de colisiones para las que existe una entrada `σ || E` registrada, cuyo prefijo `tr=E(D,σ;T,g)` es válido y satisface `φ(D(σ || E))∈B(tr)`. La propiedad no depende de una cronología. La búsqueda existencial puede recorrer todas las entradas de tipo `E`: cada una determina a lo sumo un prefijo y un enunciado. Esto permite enunciados elegidos adaptativamente dentro del perfil fijo.

## 6. Inestabilidad en ambos sentidos

Sean `d=|D|` y `x` una entrada nueva. La siguiente cuenta usa `y` uniforme sin condicionar su distribución a la ausencia futura de colisiones; solamente identifica los valores de `y` que pueden causar cada evento.

### 6.1. De ausencia de escape a escape

Supongamos que `D∉F`, `D'∈F` y ambas bases son libres de colisiones. Tomemos una entrada testigo `σ || E` de `D'`.

Si la entrada testigo ya estaba en `D`, su respuesta no cambia. Debe cambiar la extracción de su prefijo. Por el lema E, `y∈W(D)∪{σ}`; como la entrada estaba registrada, `σ∈W(D)`.

Si el testigo es la entrada nueva, necesariamente `x=σ || E`. Cuando cambia su extracción, `y∈W(D)∪{σ}`. Cuando no cambia, el conjunto `B(E(D,σ;T,g))` está fijado independientemente de la respuesta nueva y la probabilidad de acertarlo es a lo sumo `ε_T`. Hay un único `σ` posible para este `x`, sin unión adicional sobre estados o enunciados.

En conjunto, la probabilidad de este cambio entre bases sin colisiones es a lo sumo

\[
 \varepsilon_T+\frac{48d+1}{2^{256}}.
\]

### 6.2. De escape a ausencia de escape

Fijemos un testigo de `D∈F`. Su entrada y respuesta sobreviven a la inserción. Si `D'∉F` y sigue sin colisiones, tiene que cambiar la extracción de ese testigo. El lema E y el hecho de que `σ` ya es una ventana antigua dan `y∈W(D)`. Este cambio tiene probabilidad a lo sumo `48d/2^256`.

Se necesita comprobar ambas direcciones. Un test pequeño usa una regla artificial con un único valor excepcional: revelar una hoja antes ausente cambia el valor elegido y puede activar o desactivar la propiedad. Esa regla contrasta la estructura del argumento; no pretende decidir los eventos AIR reales.

### 6.3. Incorporación de colisiones

Sea `C` la propiedad de tener dos entradas diferentes con igual salida. Desde una base sin colisiones, crearla requiere `y∈im(D)`, con probabilidad a lo sumo `d/2^256`. Una inserción no puede eliminar una colisión.

Por las dos cuentas anteriores, para `P=C∪F` y bases de tamaño menor que `L`, la inestabilidad de CMS19 satisface

\[
 I(P,L)\le\varepsilon_T+\frac{49L+1}{2^{256}}.
\]

La constante usa `d<L` de forma conservadora. No se ha sumado una probabilidad de historial clásico ni se ha reutilizado `Bad_H` como propiedad de base.

## 7. Paso cuántico y alcance exacto

La base vacía no pertenece a `P`. Los **lemas 5.9 y 5.10 de CMS19**, PDF 24, relacionan la probabilidad final de una propiedad de base con su inestabilidad mediante `6L²I(P,L)`. Se aplican a la propiedad anterior y dan la expresión de §1. Este es un evento del registro simulado; el argumento no mide cada consulta del adversario. [Fuente primaria](https://eprint.iacr.org/2019/834.pdf).

La especialización de la propiedad `F`, del extractor y de la constante 49 a NEXUS constituye la propuesta de este informe. El teorema publicado aporta el paso desde inestabilidad a amplitudes; no publica esta instancia del protocolo.

Ejemplos para `T=4096`, redondeados hacia arriba:

| Presupuesto L de consultas en el juego de base | Cota de `C ∪ F` |
|---:|---:|
| 1.024 | `3,030 × 10^-28` |
| 1.048.576 | `3,177 × 10^-22` |
| 4.294.967.296 | `5,330 × 10^-15` |
| 1.099.511.627.776 | `3,493 × 10^-10` |

Se conservan [45 escenarios exactos](calculos.json): nueve tamaños y cinco presupuestos. Las cifras describen únicamente el evento de colisión o escape de campo en el juego definido. **No son niveles de seguridad del ejecutable, ni tasas de falsificación.** Tampoco se combinan por suma, producto o mínimo con la cota PoW anterior mientras no se demuestre la relación entre los respectivos experimentos.

## 8. Correspondencia comprobada

El [extractor de investigación](../../../../scripts/extraer_base_qrom_tg2.py) no llama a SHA3: trabaja sobre pares dados. El [auditor](../../../../scripts/analizar_extractor_qrom_tg2.py) construye una base clásica usando el verificador Python ya contrastado con Rust; este instrumento no simula la base comprimida de un adversario cuántico.

Los 14 certificados reconstruyen su prefijo completo y el mismo enunciado, incluso al invertir el orden de inserción. Se identifican **236 retos de extensión** en total y se cotejan **1.974 aperturas AIR** cuyos caminos completos están presentes en las bases registradas, incluidas rutas reutilizadas. Ocho certificados aceptan y seis rechazan en FRI de traza, como antes. Los oráculos extraídos contienen ceros donde no hay una preimagen válida registrada; no se afirma recuperar toda la traza honesta a partir de aperturas parciales.

Los catorce tests nuevos incluyen:

- Los 18 perfiles y todos sus prefijos de la gramática, raíces compartidas y rechazo fuera de fase.
- Permutaciones de la base, instantáneas, ciclos, valores no canónicos y colisiones.
- La entrada de 65 bytes con dos interpretaciones.
- **2.688 inserciones sin colisión** sobre todos los subconjuntos de siete entradas de contraste; cualquier cambio observado cumple la condición de etiquetas del lema.
- Un control que demuestra por qué sobrescribir no es una inserción, y cambios en ambos sentidos de una propiedad artificial de escape.
- Fracciones exactas, redondeos y repetición de los 14 certificados.

La suite acumulada registra **66 pruebas Python y 197 Rust**, además de cargo check/build, el manifiesto de 897 archivos y la protección de TG1 y de los cuatro paquetes matemáticos anteriores. [Validación](validacion.json), [protección](proteccion.json), [reproducción](README.md). Los ejemplos finitos no certifican el teorema general ni aportan dictamen externo.

## 9. Qué sigue para la cota completa

| Obligación previa | Avance de esta etapa | Trabajo que queda |
|---|---|---|
| Q1: extractor sobre base sin orden | Definición concreta del prefijo y Merkle; lema de estabilidad y código de contraste | Dictamen del argumento y extensión al sufijo de muestreo si la reducción la necesita |
| Q2: índices y nonces | Se preserva el obstáculo del predicado terminal de la etapa anterior | Construir una propiedad o potencial cuántico para la cadena hasta 40 distintos y su cola |
| Q3: AIR/FRI | Regla de escapes algebraicos y cota en base comprimida | Demostrar cobertura de toda aceptación falsa mediante escape o evento de muestreo |
| Q4: salida real | Lema de aperturas presentes en la base | Expansión del verificador, corrección del lema 4.9, consultas y truncamiento de la selección |
| Q5: parámetros | 45 escenarios del componente de campo | Evaluar la cota completa para un presupuesto y objetivo definidos |

El siguiente punto matemático es Q2: los índices salen de hashes sucesivos, y aceptar un conjunto completo de consultas no tiene la misma inestabilidad que el primer escape algebraico. La reducción final tendrá que demostrar que una aceptación falsa produce alguna de esas dos clases de eventos y pagar la transferencia al juego real. Esta etapa no modifica el protocolo Rust ni el manuscrito aprobado; deja un suplemento con hipótesis, fuentes y evidencia propios.
