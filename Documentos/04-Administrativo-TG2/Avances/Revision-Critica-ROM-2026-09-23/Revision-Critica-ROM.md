# Revisión crítica de la transferencia ROM a TG2 v1

**Fecha:** 23 de septiembre de 2026. **Estado:** revisión interna y demostración ampliada propuestas; dictamen independiente pendiente.

## 1. Objeto y resultado de la revisión

Se revisaron la [derivación por rondas](../Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md), la [transferencia ROM](../Transferencia-ROM-2026-09-23/Transferencia-Protocolo-ROM.md), `verify` de `nexus-zk/experiments/tg2_linked_trace_fri.rs`, el canal y la verificación FRI/Merkle que utiliza. El código corresponde a `01dcde960402b6c60a19242b7ae3d6ac3d82a518`; la revisión documental de partida es `ca5bfa4`.

La revisión no encontró un contraejemplo a la cota propuesta bajo sus hipótesis. Identificó una limitación concreta de la evidencia: el ensayo anterior de nonces comparaba dos órdenes fijos de conjunciones y no optimizaba decisiones adaptativas. Aquí se añade una búsqueda exacta de estrategias pequeñas y se desarrolla un argumento de potencial que justifica la contabilidad adaptativa sin necesitar completar cadenas virtuales abandonadas.

No se modifica la fórmula ni el protocolo. La conclusión sigue siendo una demostración propuesta en ROM clásico, específica de la variante experimental vinculada y de su AIR demostrativo. Esta revisión realizada durante el desarrollo no constituye una auditoría externa.

| Punto revisado | Hallazgo o precisión | Consecuencia |
|---|---|---|
| Extracción Merkle | Es indispensable marcar la raíz antes del reto y congelar el vector con el registro de ese instante | Se explicita el orden y se ensayan 60 permutaciones pequeñas |
| Gramática | Nodo y enunciado sí pueden ser la misma entrada de 65 bytes, incluso sin evento excepcional | Se conserva el análisis de un solo oráculo; no se introduce separación ficticia |
| Retos de campo | El conjunto excepcional debe estar fijado antes de la respuesta cruda, sin condicionar a la ausencia futura de colisiones | Se mantiene la masa máxima $\mu$ y la cuenta por consultas nuevas |
| Nonces | Una probabilidad condicionada a haber ganado no puede cobrarse como probabilidad de iniciar un intento | Se demuestra una desigualdad de potencial por cada inicio |
| Cola de índices | El corte 512 solo pertenece al análisis; un candidato largo puede haberse explorado antes de entregarse | Se conserva el evento de cola de sus primeras 512 extracciones |
| Pruebas de software | Los órdenes fijos anteriores no cubrían políticas adaptativas | Se añaden 12 tests, 96 escenarios y 6.318 estados de Bellman, sumados por ejecución |

## 2. Extracción: instante, profundidad y raíz marcada

Sea $\mathcal F_t$ la historia completa de entradas y respuestas hasta el instante $t$. Se usa el evento $\mathsf{Bad}_H$ definido en la transferencia: una respuesta nueva que acierta contra una respuesta previa, una ventana de 32 bytes de una entrada corta ya presentada o una etiqueta de la prueba final.

Para la raíz $r$ de una capa, sea $t_r$ el instante después de presentar su absorción y antes del reto de extensión que corresponde a esa capa. Se define

$$
u_r=\operatorname{Extraer}(r,n;\mathcal F_{t_r}).
$$

La extracción recorre únicamente preimágenes registradas de tipo correcto y profundidad fijada. Completa regiones desconocidas con cero y congela el resultado. En la traza inicial, $t_r$ precede al primer $\alpha$; en capas posteriores, precede al $\beta$ correspondiente.

**Invariante de aperturas.** Hasta el primer $\mathsf{Bad}_H$, una apertura aceptada bajo esa raíz solo puede usar las preimágenes presentes en $\mathcal F_{t_r}$ en su recorrido. Una preimagen alternativa para un digest registrado colisionaría. Si falta una preimagen, su consulta posterior produciría una etiqueta marcada: la raíz se marcó en la absorción y cada hijo conocido se marcó en el mensaje del padre. Por inducción desde la raíz, una apertura aceptada coincide con $u_r$.

**Control negativo.** Si se elimina la condición de raíz previamente marcada, la afirmación es falsa: se puede extraer cero de una raíz aún desconocida, consultar después su hoja y obtener otra extracción sin que el monitor haya marcado esa etiqueta. El test construye expresamente ese caso y después añade la absorción de raíz: la consulta tardía activa el evento excepcional. La precomputación usada por el test para preparar esa etiqueta artificial no es un ataque ROM admisible con preparación gratuita.

Se enumeran los 60 órdenes de dos hojas, su padre, absorción de raíz y reto que respetan absorción antes de reto. Dos órdenes no activan el evento, y en ambos la extracción congelada coincide con las hojas; no aparece ninguna discrepancia fuera del evento. Es un contraste finito del invariante, no una prueba para todos los árboles.

La idea de extracción por registro se contrasta con BCS16, §3.1. El argumento anterior incorpora las hojas codificadas, los prefijos y la profundidad concretos de TG2.

## 3. Prefijo válido y coincidencia de roles

Fuera del evento de grafo, una respuesta que actúa como estado siguiente no puede producirse después de que ese estado aparezca en una consulta posterior válida: en ese caso se habría marcado antes de producirse. Tampoco puede tener dos preimágenes distintas. Recorrer hacia atrás el canal reconstruye las absorciones y retos hasta el dominio inicial, en orden temporal estricto.

El formato y el lugar dentro del recorrido fijan el significado del mensaje. Los dos retos de 33 bytes se distinguen por `E` e `I`; el trabajo usa 41 bytes y la absorción de nonce 49. Una cadena de retos no puede empezar antes de su semilla ni converger desde otra semilla sin una referencia adelantada o colisión. Consultar de nuevo una entrada devuelve su respuesta anterior y no crea otra oportunidad.

La coincidencia de 65 bytes exige cuidado. El nuevo test produce una asignación artificial del oráculo con

$$
s_{\rm perfil}=01\parallel a_{0..30},\quad
\text{hijo izquierdo}=a_{0..30}\parallel04,\quad
\text{hijo derecho}=24_{64}\parallel\text{enunciado}.
$$

Así, `01 || hijo izquierdo || hijo derecho` es exactamente `estado || 04 || 24_64 || enunciado`. Las preimágenes de las hojas se consultan primero y no aparece $\mathsf{Bad}_H$. Esto refuta una supuesta separación global de roles por etiquetas. La transferencia original ya permitía esta coincidencia: como paso del canal sigue teniendo un único estado anterior y un único enunciado.

La asignación del test fuerza respuestas y no mide su probabilidad ni rompe SHA3. Su función es comprobar que la demostración admite todas las formas posibles de una ejecución del oráculo.

## 4. Lema de candidatos adaptativos mediante potencial

### 4.1 Condiciones e instante de inicio

Un candidato es $(s,n)$, con $s$ un estado final de prefijo válido para un enunciado falso, todavía sin escape algebraico, y $n$ un nonce u64. Se inicia en la primera consulta a su entrada de trabajo o de absorción. La reconstrucción de §3 garantiza que su historia, oráculos y caso activo ya están fijados si ese candidato puede conducir a una aceptación sin $\mathsf{Bad}_H$.

Un candidato referido antes de que su estado tenga una historia válida no puede adquirir esa historia más tarde sin $\mathsf{Bad}_H$. Las entradas de inicio son inyectivas en $(s,n)$ y sus dos roles tienen distintas longitudes. Cada consulta adversaria inicia a lo sumo uno; la única verificación final inicia a lo sumo otro. El número total de inicios relevantes es

$$
C\le Q+1.
$$

El caso activo de la prueba AIR/FRI define para el candidato un conjunto fijo $G$ de parejas que supera ese control, con $g_0=|G|\le M-\lceil M/8\rceil$. No se necesita independencia entre controles ni entre los conjuntos escogidos para distintos candidatos.

### 4.2 Potencial de un candidato

Escribimos $p_{\rm w}=2^{-g}$ para distinguir los bits de trabajo del tamaño $g_0$. Si se han observado $a$ índices distintos, todos en $G$, sea

$$
\rho_a=\frac{\binom{g_0-a}{q-a}}{\binom{M-a}{q-a}}\quad(0\le a\le q).
$$

Si $g_0<q$ o apareció un índice fuera de $G$, el potencial es cero. Al completar $q$ distintos buenos, $\rho_q=1$. Para el trabajo, usamos $w=p_{\rm w}$ si no se ha consultado, $w=1$ si fue válido y $w=0$ si falló. Definimos $\phi=w\rho_a$.

Antes de la primera respuesta del candidato,

$$
\phi_{\rm inicio}=p_{\rm w}\frac{\binom{g_0}{q}}{\binom Mq}
\le p_{\rm w}h_T.
$$

Cada consulta nueva a su trabajo preserva el potencial en esperanza. La absorción de nonce no selecciona un índice y tampoco cambia el potencial. Para una extracción `I` nueva, un índice repetido tiene probabilidad $a/M$, uno bueno nuevo $(g_0-a)/M$ y uno malo $(M-g_0)/M$. Por la identidad hipergeométrica,

$$
\frac aM\rho_a+\frac{g_0-a}{M}\rho_{a+1}=\rho_a.
$$

Una extracción repetida desde el mismo estado devuelve lo ya conocido; no se trata como una muestra nueva. El potencial corresponde al prefijo más largo de esa cadena que consta en el registro, no al número de veces que el adversario lo reproduce.

### 4.3 Historia global y eventos excepcionales

La identidad se evalúa condicionada a la historia **antes** de una respuesta fresca. Incluye toda la información de otros candidatos y los bits completos de respuestas anteriores. El siguiente resultado crudo sigue siendo uniforme; la máscara usada por `challenge_index` es uniforme porque $M$ es potencia de dos.

Se detiene la cuenta y se pone el potencial total a cero al primer $\mathsf{Bad}_H$ o escape algebraico relevante. Un evento excepcional puede estar correlacionado con el siguiente índice: poner a cero términos no negativos solo reduce la esperanza. No se condiciona el muestreo a que ese evento nunca ocurra.

Antes de ese corte, una consulta afecta a lo sumo a un paso nuevo de una cadena de candidato: compartir un estado nuevo entre cadenas distintas implicaría una colisión o referencia adelantada. Consultas a otros roles pueden ser ignoradas o activar el corte. Abandonar un candidato no aumenta su potencial; puede conservarse en el registro y retomarse. El formato fijo evita que cambie su conjunto $G$.

Sea $\Phi_t$ la suma de los potenciales de todos los candidatos iniciados hasta $t$, y $C_t$ su número de inicios. En cada inicio se añade a lo sumo $p_{\rm w}h_T$; entre inicios la esperanza no aumenta. Por lo tanto

$$
\Phi_t-p_{\rm w}h_T C_t
$$

es una supermartingala, es decir, su esperanza condicionada al pasado no aumenta. No requiere que las elecciones del adversario sean independientes. En el horizonte acotado de $Q$ consultas y la verificación truncada,

$$
\mathbb E[\Phi_{\rm fin}]\le p_{\rm w}h_T\,\mathbb E[C_{\rm fin}]
\le(Q+1)p_{\rm w}h_T.
$$

Si el verificador truncado acepta sin eventos excepcionales, el candidato elegido tiene trabajo válido y $q$ parejas buenas: su potencial es uno y $\Phi_{\rm fin}\ge1$. Así,

$$
\Pr[\text{aceptación truncada sin excepciones}]
\le(Q+1)2^{-g}h_T.
$$

La verificación final puede completar gratis las consultas de un candidato parcialmente explorado. Esas respuestas se incluyen en $V_T$ y preservan la desigualdad; si usa un candidato nuevo se cobra el inicio adicional.

**Precisión de condicionamiento.** Para un candidato ya seleccionado porque ganó el trabajo, la probabilidad restante puede ser $h_T$, no $2^{-g}h_T$. El factor de trabajo se cobra al inicio, antes de saber si gana. El test pequeño obtiene $1/8$ como probabilidad conjunta y $1/2$ al condicionar al trabajo válido; confundirlas invalidaría la contabilidad.

## 5. Cola y número de consultas

Para la cola se usa un potencial independiente. Tras $r\le R$ extracciones y $a$ distintos, sea

$$
L(r,a)=\Pr[\text{menos de }q\text{ distintos al llegar a }R\mid r,a].
$$

Tiene condiciones $L(R,a)=\mathbf1[a<q]$ y $L(r,a)=0$ para $a\ge q$, y recurrencia

$$
L(r,a)=\frac aM L(r+1,a)+\frac{M-a}{M}L(r+1,a+1).
$$

Multiplicar por el estado del trabajo $w$ produce la misma cuenta de potencial, con coste inicial $2^{-g}L(0,0)\le2^{-g}\tau_T$. Una vez vistas las primeras $R$ extracciones, se conserva su indicador de cola aunque el adversario continúe y termine la cadena. Por ello el argumento cubre candidatos que ya habían sido explorados más allá de $R$ antes de entregar la prueba.

La aceptación del verificador original después del corte implica trabajo válido y ese indicador de cola. Su probabilidad, antes de excepciones, queda acotada por $(Q+1)2^{-g}\tau_T$. No hace falta simular el verificador final más allá del corte para detectar ese evento.

El Rust comprueba longitudes y formas antes de empezar a hashear. Si son inválidas, rechaza sin usar la cuenta $B_T$ para una prueba arbitrariamente grande. La cuenta de etiquetas de la prueba se aplica una vez admitida su forma; los tests comprueban el rechazo previo en el verificador de referencia. El límite de RAM del decodificador y la terminación del selector de índices son problemas operativos distintos de esta probabilidad.

Con $R=512$, el mismo $V_T$ acota los hashes de la verificación truncada. La suma de pérdidas conserva la fórmula original:

$$
E_{\rm ROM}\le\min\left\{1,\frac{S(49S+B_T)}{2^{256}}
 +(Q+m)\frac N2\mu +(Q+1)2^{-g}(h_T+\tau_T)\right\},
\quad S=Q+V_T.
$$

## 6. Contrastes exactos y qué abarcan

El [analizador](../../../../scripts/analizar_revision_rom_tg2.py) calcula una programación dinámica de Bellman con fracciones exactas. Para cada estado compara las acciones: consultar trabajo, absorber nonce, pedir el siguiente índice, retomar otro candidato, abandonar uno e iniciar otro, o terminar escogiendo qué candidato verificará el verificador. También admite entregar un candidato nuevo sin consultas previas, y los índices repetidos consumen presupuesto.

El modelo pequeño usa monedas frescas: excluye eventos de grafo y escapes algebraicos, que se cobran por separado en el teorema. Los conjuntos buenos están fijados al inicio y se representan por su cardinalidad. La búsqueda mantiene dos o tres candidatos simultáneos; no demuestra que ese límite de memoria sea óptimo para el protocolo real. La prueba de potencial no tiene esa restricción.

Se recorren tres perfiles $(M,g_0,q)=(2,1,1),(4,3,2),(4,3,3)$, dos niveles de trabajo, dos capacidades y ocho presupuestos $Q=0,\ldots,7$: **96 escenarios**, con **6.318 estados de Bellman sumados por ejecución**. El óptimo no supera $(Q+1)2^{-g}h$ en ninguno. No son 6.318 estados globalmente distintos.

Ejemplo con $M=4$, $g_0=3$, $q=2$, dos bits de trabajo y hasta tres candidatos:

| Consultas adversarias $Q$ | Óptimo exacto del modelo pequeño | Cota usada |
|---:|---:|---:|
| 0 | $1/8$ | $1/8$ |
| 1 | $7/32$ | $1/4$ |
| 3 | $179/512$ | $1/2$ |
| 7 | $72363/131072$ | $1$ |

Las **12 pruebas nuevas** cubren además identidades de potencial, cola exacta por enumeración, condicionamiento al ganador, los órdenes de Merkle, ausencia de la premisa de raíz, coincidencia de roles, anticipación de estados, ciclos y rechazo de formas inválidas antes del hash. Se repiten las 28 pruebas Python anteriores, las 197 Rust y check/build; los resultados y fuentes están en [validacion.json](validacion.json).

No se ha ejecutado una búsqueda exhaustiva en los parámetros de producción ni se ha probado ausencia de ataques contra SHA3. Las pruebas complementan el argumento general escrito.

## 7. Dictamen interno y siguiente trabajo

1. La extracción y el canal conservan sus premisas; los controles negativos muestran por qué no pueden omitirse.
2. El término de nonces dispone ahora de una demostración por potencial para decisiones adaptativas, con corte explícito ante eventos excepcionales.
3. La revisión mantiene las pérdidas y las cifras anteriores. No mejora por sí sola la seguridad acreditada por esos parámetros.
4. El siguiente estudio debe fijar **presupuesto adversario $Q$ y probabilidad objetivo $\epsilon$** antes de elegir parámetros. No debe confundirse $-\log_2$ de una cota de probabilidad para un presupuesto dado con una estimación automática del trabajo de ataque.
5. Se mantiene pendiente el dictamen independiente de los lemas algebraicos y de ambas demostraciones ROM. La reducción QROM, conocimiento cero y R1 sobre ML-DSA requieren argumentos propios.

El manuscrito y el Word anteriores conservan sus ediciones identificadas. Este suplemento refuerza §§5–8 de la transferencia anterior y debe acompañarla al solicitar dictamen; no se atribuye aprobación del director a esta revisión.

## 8. Referencias

- Ben-Sasson, Chiesa y Spooner, [Interactive Oracle Proofs](https://eprint.iacr.org/2016/116.pdf), versión del 10 de febrero de 2016, §3.1 y §§6–7; [copia local](../Transferencia-ROM-2026-09-23/bibliografia/BCS16.pdf). Se contrastó la extracción por registro; las cuentas específicas y el potencial de este suplemento no se atribuyen al artículo.
- [Solidez por rondas de AIR/FRI](../Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md), lemas A–B y proposición C.
- [Transferencia ROM de TG2 v1](../Transferencia-ROM-2026-09-23/Transferencia-Protocolo-ROM.md), parámetros, gramática, evento de grafo y cuentas del verificador.
