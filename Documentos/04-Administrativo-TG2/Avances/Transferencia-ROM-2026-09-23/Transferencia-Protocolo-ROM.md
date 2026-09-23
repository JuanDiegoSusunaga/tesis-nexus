# Transferencia de la solidez ideal al protocolo TG2 v1 en ROM clásico

**Fecha:** 2026-09-23. **Estado:** derivación propuesta para revisión matemática independiente.

## 1. Objeto exacto y resultado

Se analiza `verify` de `nexus-zk/experiments/tg2_linked_trace_fri.rs`, versión 1, en la revisión de código `01dcde960402b6c60a19242b7ae3d6ac3d82a518`. La variante comparte raíz y codificación entre AIR y FRI de traza y usa otro FRI para composición. El STARK heredado no es objeto de esta garantía.

Se conserva exactamente la secuencia de bytes de la variante. Para el análisis, cada llamada a SHA3-256 se sustituye por una consulta a **un solo oráculo aleatorio** $H:\{0,1\}^*\to\{0,1\}^{256}$. Un adversario clásico dispone de a lo sumo $Q$ consultas, incluidas las de preparación, búsqueda de compromisos y nonces. Emite un enunciado y una prueba finales. El perfil $T,g$ está fijado; el enunciado puede elegirse adaptativamente dentro de ese perfil. No se permite información auxiliar correlacionada con el oráculo que no esté contabilizada.

La probabilidad acotada es la de que esa prueba final acepte un enunciado sin traza válida sobre el campo base. No se afirma extracción eficiente de un testigo, conocimiento cero, seguridad QROM ni una propiedad de la función determinista SHA3 al margen del modelo.

La [derivación por rondas](../Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md) proporciona el argumento algebraico que se usa abajo. Esta etapa incorpora el registro de consultas hash y calcula pérdidas propias del canal concreto; **no sustituye sin más la cota ideal en el teorema BCS**.

## 2. Parámetros y fórmula

Sea $p=2^{64}-2^{32}+1$, $K=F_{p^2}$, $N=8T$, $M=N/2$, $q=40$, $k_t=\log_2T$, $k_c=k_t+1$ y $m=3+k_t+k_c$. El trabajo de nonce es $g=12$ en debug y $g=20$ en release. Los umbrales del argumento ideal son $\delta_t=\delta_c=1/8$.

Definimos la masa máxima de un reto de extensión obtenido de dos bloques uniformes de 128 bits:

$$
\mu=\left(\frac{\lfloor2^{128}/p\rfloor+1}{2^{128}}\right)^2.
$$

Sea

$$
h_T=\frac{\binom{M-\lceil M/8\rceil}{q}}{\binom Mq},\qquad
\tau_T=\min\left\{1,\binom{M}{q-1}\left(\frac{q-1}{M}\right)^{512}\right\}.
$$

El numerador de $h_T$ vale cero cuando no hay suficientes parejas buenas. Sea $\ell=\log_2N$ y

$$
W_T=q\left(6\ell+2\sum_{j=0}^{k_t-1}(\ell-j)
                    +2\sum_{j=0}^{k_c-1}(\ell-j)\right),
$$

$$
B_T=1+k_t+k_c+W_T,
$$

$$
V_T=W_T+q(6+2k_t+2k_c)+13+2(k_t+k_c)+512,\qquad S=Q+V_T.
$$

Aquí $B_T$ cuenta ocurrencias de digests en raíces y caminos de una prueba con forma válida, y $V_T$ es una cota de llamadas hash del verificador cuando la selección termina antes de superar 512 extracciones. Contar ocurrencias repetidas es conservador.

**Teorema ROM propuesto.** Bajo el modelo de §1 y los lemas algebraicos de la derivación por rondas, la probabilidad de aceptación falsa está acotada por

$$
\boxed{
E_{\mathrm{ROM}}(T,g,Q)
\le \min\left\{1,
\underbrace{\frac{S(49S+B_T)}{2^{256}}}_{\text{grafo de hashes}}
+\underbrace{(Q+m)\frac N2\mu}_{\text{AIR y plegados}}
+\underbrace{(Q+1)2^{-g}(h_T+\tau_T)}_{\text{nonces y consultas}}
\right\}.}
$$

Los apartados siguientes justifican cada término y su composición. La constante 49 es una cota deliberadamente amplia que permite tratar las entradas del mismo oráculo sin asumir que todos sus dominios son disjuntos.

## 3. Correspondencia de la gramática

La absorción es $H(s\parallel\mathrm{tag}\parallel\mathrm{len}_{64}\parallel\mathrm{datos})$. El estado completo de 256 bits se conserva después de cada reto. Los campos del perfil y del enunciado tienen longitudes fijas en el verificador admitido.

| Función | Entrada a $H$ | Longitud |
|---|---|---:|
| Inicio | dominio `NEXUS-TG2-LINKED-FRI-v1` | 23 |
| Hoja de extensión | `00` y dos enteros canónicos little-endian | 17 |
| Nodo Merkle | `01`, hijo izquierdo e hijo derecho | 65 |
| Perfil | estado, etiqueta 16, longitud 38, datos | 79 |
| Enunciado | estado, etiqueta 4, longitud 24, datos | 65 |
| Raíz | estado, etiqueta 1 o 2, longitud 32, raíz | 73 |
| Fase traza / composición | estado, etiqueta 17, longitud, nombre | 46 / 52 |
| Constante final | estado, etiqueta 3, longitud 16, valor | 57 |
| Reto de extensión / índice | estado y `E` / `I` | 33 |
| Trabajo del nonce | estado, etiqueta 5, nonce u64 | 41 |
| Absorción del nonce | estado, etiqueta 5, longitud 8, nonce u64 | 49 |

Las entradas de 33 bytes para retos, de 41 para trabajo y de 49 para absorber el nonce son distintas por longitud o sufijo. **Nodo y enunciado pueden compartir una cadena de 65 bytes.** El argumento no excluye ese caso mediante la observación finita de los 18 perfiles SHA3; permite que una consulta tenga ambas interpretaciones. La extracción y el seguimiento de transcripción usan sus respectivos formatos, y ambos apuntan al mismo valor del único oráculo.

Dentro del recorrido válido del canal, el estado anterior, la etiqueta, la longitud y los datos determinan un mensaje sin ambigüedad. El perfil fija número de capas y orden de fases. Repetir la raíz inicial en FRI de traza exige igualdad con la raíz AIR. Ningún mensaje del probador se intercala entre los tres $\alpha$ ni entre las extracciones de índices.

## 4. Evento excepcional del grafo de hashes

Simulamos el oráculo por muestreo perezoso: una entrada repetida conserva su respuesta y una nueva recibe 256 bits uniformes, independientes de lo observado antes de responder.

Se mantiene un conjunto de etiquetas de 32 bytes. Antes de responder a una consulta nueva de longitud a lo sumo 79, se añaden **todas sus ventanas contiguas de 32 bytes**. Hay a lo sumo 48 ventanas. Después de responder se añade su digest. Al recibirse la prueba final se añaden sus $B_T$ ocurrencias de digests; valores repetidos solo reducen el conjunto. Entradas ajenas de longitud mayor que 79 pueden consultarse, pero solo sus respuestas se añaden: no son entradas de ningún paso del protocolo analizado.

Llamamos $\mathsf{Bad}_H$ al evento de que una respuesta nueva coincida con una etiqueta que ya estaba marcada, incluidas las ventanas de su propia entrada. Esto cubre:

- colisiones entre respuestas a entradas distintas;
- referencias a respuestas que todavía no existían al escribir un padre o estado;
- ciclos, autorreferencias y un acierto contra una raíz o hermano suministrado antes de consultar su preimagen.

Con a lo sumo $S$ consultas nuevas, antes de cualquier respuesta hay como máximo $49S+B_T$ etiquetas. Condicionada a la historia previa, la siguiente respuesta es uniforme, por lo que

$$
\Pr[\mathsf{Bad}_H]\le\frac{S(49S+B_T)}{2^{256}}.
$$

Las ventanas incluyen tanto los estados anteriores como raíces e hijos, aunque los campos empiecen en offsets diferentes. Marcar también las ventanas de consultas ajenas cortas amplía el evento y conserva la cota. No se presupone resistencia a colisiones adicional: esta pérdida se calcula dentro de ROM.

Los argumentos posteriores se aplican hasta el primer evento excepcional. No se condicionan salidas nuevas a que **nunca** ocurra un evento futuro: ese condicionamiento alteraría su distribución. Se usa una ejecución acoplada que conserva respuestas frescas y se detiene si ocurre el evento.

## 5. Extracción previa de los oráculos Merkle

Para una raíz y un tamaño fijados, se recorre el registro de consultas disponible **antes del reto relevante**:

1. Se busca la preimagen consultada que produjo el digest. Fuera de $\mathsf{Bad}_H$, es única.
2. A profundidad interna, solo una entrada de 65 bytes con prefijo `01` proporciona dos hijos.
3. A profundidad de hoja, solo una entrada de 17 bytes con prefijo `00` y dos coordenadas canónicas proporciona un elemento de $K$.
4. Si falta la preimagen o no tiene esa forma, se completa esa región con ceros. La lista obtenida se congela en ese instante.

**Lema de extracción de aperturas.** Fuera de $\mathsf{Bad}_H$, toda apertura que acepte después coincide con la posición correspondiente de esa lista, siempre que la raíz ya hubiera aparecido como campo comprometido antes del reto.

**Demostración.** Una apertura aceptada reconstruye hashes desde una hoja canónica hasta la raíz. Si en algún punto usa una preimagen distinta de la registrada para el mismo digest, aparece una colisión. Si la preimagen requerida no estaba en el registro al congelar el vector y se consulta más tarde, su respuesta acierta contra una etiqueta ya marcada: la raíz estaba en la absorción y los hijos estaban en entradas internas anteriores. Es una referencia adelantada incluida en $\mathsf{Bad}_H$. Si la preimagen tenía otro tipo o profundidad, una apertura canónica tampoco puede reemplazarla sin cambiar la entrada y colisionar. Por inducción a lo largo del camino, toda apertura aceptada coincide con una hoja ya extraíble al fijar la raíz. Las regiones completadas con cero no pueden recibir aperturas diferentes sin alguno de esos eventos. $\square$

Así se obtiene un vector ideal fijo **con acceso al registro del oráculo**. No es un algoritmo que recupere la traza desde la raíz SHA3 pública por sí sola. Raíces repetidas para un mismo tamaño dan las mismas aperturas extraíbles; se comparte explícitamente el vector inicial entre AIR y FRI de traza. Cada capa se extrae antes de su $\beta$ y la traza antes del primer $\alpha$.

El enfoque guarda relación con el extractor por grafo de BCS16, §3.1. La cuenta de ventanas, codificación de elementos, profundidad y digest de hoja de esta sección es específica del protocolo local.

## 6. Reconstrucción del prefijo y errores de campo

Fuera de $\mathsf{Bad}_H$, si se consultó un reto `estado || E` antes de conocer el estado que lo precede en una transcripción válida, la respuesta futura que debía producir ese estado acertaría contra los primeros 32 bytes ya marcados: contradicción. Por ello un reto previamente consultado tiene sus antecedentes disponibles en orden temporal. La unicidad de respuestas y el formato de la absorción permiten retroceder hasta dominio, perfil y enunciado.

Este argumento admite el solapamiento nodo/enunciado: una entrada puede ser un nodo y una absorción de enunciado, pero su interpretación como paso del canal conserva un único estado anterior y datos fijos. Las consultas que producen retos tienen longitudes o sufijos distintos de las entradas de Merkle y de absorción. Fuera del evento excepcional, una secuencia de canal con otro perfil no puede converger a la misma secuencia mediante una colisión.

En cada consulta **nueva** que constituye un reto de extensión de un prefijo válido, su salida cruda es uniforme. Para $U\bmod p$, cada residuo recibe a lo sumo $(\lfloor2^{128}/p\rfloor+1)/2^{128}$; las dos mitades uniformes son independientes. Así, cada elemento de $K$ recibe masa a lo sumo $\mu$.

- El reto AIR crítico de la prueba por rondas tiene a lo sumo un valor que cancela los residuos: error $\le\mu$.
- El lema elemental de plegado tiene a lo sumo $n_j$ valores excepcionales: error $\le n_j\mu\le(N/2)\mu$.
- Repetir una entrada no genera otra oportunidad: devuelve la respuesta registrada. Un estado que ya escapó se cobra a la primera transición excepcional de su historia.

Hay como máximo $Q$ consultas nuevas del adversario y $m$ retos de extensión en la única verificación final. Por unión adaptativa,

$$
\Pr[\text{algún escape AIR/FRI antes de }\mathsf{Bad}_H]
\le(Q+m)\frac N2\mu.
$$

Usar masa máxima evita pagar una distancia de variación total por cada salida. La elección de las raíces puede depender de retos previos: el vector de cada ronda y el conjunto de sus valores excepcionales están fijados antes de la respuesta nueva de esa ronda.

## 7. Consultas en cadena y nonces adaptativos

Un **candidato de nonce** es el par $(s,n)$, donde $s$ es el estado después de ambas constantes finales y $n$ es el nonce. Ese estado fija la transcripción previa y todos los vectores extraíbles. El candidato se inicia al consultar por primera vez su trabajo de 41 bytes o su absorción de 49 bytes, lo que ocurra antes. Si se intenta referir un $s$ que solo se producirá después, se incurre en $\mathsf{Bad}_H$.

Por tanto, hay a lo sumo $Q$ candidatos iniciados durante la preparación adversaria y, como máximo, uno adicional en la verificación final. Restaurar un candidato o cambiar el orden de sus consultas no lo renueva.

Para un candidato cuyo estado ideal aún sea cero:

1. La prueba por rondas da un conjunto fijo de a lo sumo $(1-1/8)M$ parejas que podría superar el control activo. Este puede ser FRI de traza, FRI de composición, campo base o enlace AIR. No se requiere independencia entre los controles.
2. La salida del trabajo $H(s\parallel05\parallel n)$ satisface los $g$ ceros con probabilidad $2^{-g}$.
3. La absorción $H(s\parallel05\parallel8_{64}\parallel n)$ tiene otra entrada; inicia la cadena `I`. Fuera del evento de grafo, las extracciones nuevas de esa cadena son frescas. Las potencias de dos admitidas permiten obtener índices uniformes por máscara, y descartar repetidos produce una lista uniforme sin reemplazo.

**Lema de un candidato.** La probabilidad de que cumpla el trabajo y sus 40 índices omitan todas las parejas malas, antes de cualquier evento excepcional, es a lo sumo $2^{-g}h_T$.

**Justificación del orden adaptativo.** En la primera consulta que inicia el candidato, la transcripción anterior y el conjunto de parejas están fijados. Todavía no se conocen ambos experimentos de ese candidato. Si se prueba primero el trabajo, el muestreo restante es independiente; si se observa primero parte o toda la cadena, el trabajo restante es independiente. Una interrupción por resultado desfavorable solo reduce la probabilidad de completar con éxito ese candidato. Consultas intercaladas a otros candidatos no cambian las respuestas de este. Una entrada futura de la cadena que ya hubiese sido anticipada necesitaría acertar contra un estado aún no producido, o fusionarse con otra cadena; esos casos se cobran en $\mathsf{Bad}_H$.

Formalmente se puede asignar a cada candidato, desde su inicio, una secuencia independiente de salidas para sus pasos aún no revelados, y revelar solo las solicitadas. La ejecución coincide con el oráculo real hasta el primer choque de entradas o referencia adelantada, que ya está cubierto por el evento de grafo. Las consultas hipotéticas no se ejecutan ni se añaden al presupuesto: sirven para acoplar el evento de completar una cadena, incluso cuando el adversario abandona el candidato. Las muestras exitosas forman un subconjunto del evento de éxito de esa secuencia completa.

Por unión sobre los candidatos iniciados, el término es $(Q+1)2^{-g}h_T$. **El factor de grinding solo multiplica el error de consultas finales.** No multiplica la pérdida de campo ni la del grafo. La cuenta permite probar nonces en cualquier orden y elegir cualquiera válido; no supone que se use el primero.

## 8. Cola de la selección y ejecución original sin límite

El Rust v1 sigue extrayendo índices hasta reunir 40 distintos; no tiene un límite determinista de 512. Para contar las consultas del verificador, introducimos únicamente en la demostración un verificador truncado que rechaza si todavía no termina después de 512 extracciones.

Si tras $R$ índices uniformes hay menos de $q$ distintos, todos pertenecen a algún subconjunto de $q-1$ elementos. Por unión sobre esos subconjuntos,

$$
\Pr[\text{menos de }q\text{ distintos tras }R]
\le\min\left\{1,\binom{M}{q-1}\left(\frac{q-1}{M}\right)^R\right\}.
$$

Para $R=512$, esa expresión es $\tau_T<2^{-300}$ en los nueve tamaños. Hasta el corte, el algoritmo original y el truncado son idénticos. Una aceptación original posterior al corte exige un candidato que cumpla PoW y tenga cadena larga; el mismo argumento de entradas distintas lo acota por $2^{-g}\tau_T$ por candidato, fuera de los eventos ya cobrados. Los intentos adaptativos aportan $(Q+1)2^{-g}\tau_T$.

Esto permite estudiar el código original sin afirmar que ya implementa ese corte ni contar un número ilimitado de llamadas dentro de $S$. La aceptación posterior al corte se cobra al evento de cola, y el grafo solo necesita analizarse hasta el corte de la única verificación final. No se deriva de aquí una garantía operativa de tiempo máximo o ausencia de denegación de servicio.

## 9. Cuenta del verificador y cierre de la prueba

Cada pareja consulta seis puntos AIR, con $\ell$ hermanos y un hash de hoja por punto. En cada FRI consulta dos hojas por capa; en la capa $j$ cada camino tiene $\ell-j$ hermanos. Esto da $W_T+q(6+2k_t+2k_c)$ hashes Merkle como máximo.

El canal realiza: dominio, perfil, enunciado y raíz inicial (4); tres retos AIR (3); dos etiquetas de fase y dos constantes finales (4); absorción y reto por cada capa ($2k_t+2k_c$); comprobación de trabajo y absorción de nonce (2); hasta 512 índices. Son $13+2(k_t+k_c)+512$ llamadas. Los rechazos anticipados solo reducen estas cuentas.

Para $T=4096$, se obtiene $B_T=22.106$ y $V_T=24.895$. El verificador Python independiente reproduce el número exacto de llamadas para los certificados honestos, sustituyendo 512 por las extracciones realmente utilizadas.

**Demostración del teorema.** Se separa primero $\mathsf{Bad}_H$, con la probabilidad de §4. En las ejecuciones restantes, §5 fija los vectores antes de los retos y §6 los enlaza a una historia ideal válida. Se cobra cualquier primera transición excepcional AIR/FRI con el término de campo. Si no ocurre, la aceptación exige un candidato final cuyo trabajo y consultas sean favorables, o una ejecución que supere el corte. Los §§7–8 cubren esos eventos aun con búsquedas adaptativas. Sumar las tres contribuciones y truncar en uno da la expresión de §2. $\square$

La demostración escrita es el objeto pendiente de revisión externa. Los tests no certifican por sí solos el argumento general de simulación ni el lema de candidatos adaptativos.

## 10. Instancias y alcance de los parámetros

Los siguientes valores son límites superiores redondeados hacia arriba para **release, $g=20$**:

| $T$ | $Q=2^{10}$ | $Q=2^{20}$ | $Q=2^{24}$ | $Q=2^{28}$ |
|---:|---:|---:|---:|---:|
| 16 | 0,000000162429 | 0,000166164534 | 0,002658630152 | 0,042538080042 |
| 64 | 0,000002868091 | 0,002934061841 | 0,046944947484 | 0,751119117760 |
| 256 | 0,000004186428 | 0,004282723216 | 0,068523510189 | 1 |
| 4096 | 0,000004650368 | 0,004757335454 | 0,076117299199 | 1 |

El [cálculo exacto](calculos.json) conserva 108 escenarios: nueve tamaños, dos niveles de trabajo y seis presupuestos. La cota que llega a uno deja de informar; no demuestra un ataque con probabilidad uno. Una cota superior tampoco es una estimación de la vulnerabilidad real.

La transferencia clásica ROM queda formulada con pérdidas explícitas, pero los parámetros actuales no quedan acreditados como seguridad de 100 bits. Si esa garantía se exige, habrá que revisar tamaño de campo, consultas, presupuesto adversario y análisis antes de prometerla. El modelo cuántico necesita otro argumento: el registro clásico de entradas consultadas no se aplica sin cambios a consultas en superposición.

## 11. Correspondencia experimental y trazabilidad

La auditoría independiente anterior comprobaba SHA3, nonces, posiciones y aperturas de 14 certificados. El nuevo verificador Python añade la composición AIR, cada arrastre de plegado en $F_{p^2}$ y la constante final, manteniendo el orden de rechazo relevante:

- ocho certificados honestos aceptan, en debug y release;
- seis certificados de oráculos alejados rechazan en FRI de traza, igual que Rust;
- se contrastan las cuentas hash y once pruebas nuevas cubren además sesgo, cola, extracción congelada, referencias futuras, colisiones, repetición y mutaciones de pruebas.

El corte de 512 del auditor es una protección de esa herramienta. Los certificados usados terminan antes del corte; no se modifica el Rust. Los casos de oráculos lejanos tienen enunciados válidos y continúan siendo contraejemplos de proximidad del legado, no falsificaciones de enunciado del protocolo vinculado.

Las pruebas Rust, las pruebas matemáticas previas, el manifiesto y los documentos protegidos se verifican en [validacion.json](validacion.json). Se conservan las fuentes exactas de los scripts y de la variante para reproducir esta etapa. La integración de la rama anterior en `main` es local; no implica publicación remota ni aprobación académica.

## 12. Referencias y revisión solicitada

1. Ben-Sasson, Chiesa y Spooner, [Interactive Oracle Proofs](https://eprint.iacr.org/2016/116.pdf), versión 2016-02-10, §3.1 y §§6–7: extracción por registro de consultas y compilación de IOP. [Copia conservada](bibliografia/BCS16.pdf). La constante de esta nota no se atribuye a ese artículo.
2. [Derivación AIR/FRI por rondas](../Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md), lemas A–B, proposición C y referencias primarias allí conservadas.
3. [Auditoría previa de bytes, sesgo y Merkle/Fiat–Shamir](../R4-Merkle-Fiat-Shamir-2026-09-23.md); [implementación vinculada y alcance](../R4-FRI-Vinculado-2026-09-22.md).

Prioridades para el lector independiente: (i) instante de extracción y manejo de subárboles incompletos; (ii) unicidad del recorrido del canal con un único oráculo y solapamiento de 65 bytes; (iii) acoplamiento de candidatos de nonce con interrupciones y consultas intercaladas; (iv) separación entre la cola del verificador original y las consultas contadas en el grafo; (v) suficiencia de la cota para el alcance de TG2. Ninguna aprobación previa del director se atribuye a este teorema propuesto.
