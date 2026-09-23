# Cota cuántica de la cola mediante conteo de respuestas

**Fecha:** 23 de septiembre de 2026. **Código:** `01dcde960402b6c60a19242b7ae3d6ac3d82a518`. **Estado:** demostración propuesta para revisión independiente. La omisión de parejas incorrectas continúa abierta.

## 1. Resultado y alcance

El [informe de muestreo](../Muestreo-QROM-2026-09-23/Muestreo-y-Puente-QROM.md) definió dos eventos pendientes: `S`, completar 40 índices que omiten todas las parejas incorrectas, y `Tcola`, registrar `R` extracciones sin completar esos 40 índices. Esta etapa obtiene una cota para el segundo evento, en la base del oráculo comprimido.

Sean `M=4T`, `q=40`, `R≥40` y `L` el presupuesto **total** de consultas a `H`. Se propone

\[
 \boxed{\Pr[D_L\in T_{\mathrm{cola}}]\le\eta_{M,R}(L)
 =\min\left\{1,\binom M{39}\binom LR^2
             \min\{1,234/M\}^{R}\right\}.}
\]

Se toma `binom(L,R)=0` si `L<R`. Como en la definición anterior, `Tcola` excluye colisiones de salidas hash. La cota se demuestra sobre un evento más amplio, sin exigir trabajo válido, falsedad del enunciado ni ausencia de escapes de campo. Por ello cubre cualquier nonce y cualquier prefijo que satisfagan el evento original.

**No es una cota de aceptación falsa del protocolo.** Quedan por demostrar una cota útil para `S` y la revisión de los argumentos que relacionan los eventos. La fórmula anterior es conservadora: no aprovecha la dificultad del trabajo del nonce ni el orden de la cadena una vez establecida la inclusión estructural.

## 2. De una cola anclada a muchas respuestas registradas

Una cadena del protocolo empieza en la respuesta registrada de la absorción del nonce:

\[
 x_s=\sigma\parallel\mathtt{05}\parallel\operatorname{u64LE}(8)
                 \parallel\operatorname{u64LE}(n),\qquad s_0=D(x_s).
\]

La entrada `x_s` tiene 49 bytes; cada entrada de índices `s_j || I` tiene 33 bytes. La cadena obedece `s_{j+1}=D(s_j || I)`.

**Lema de ausencia de ciclos.** Si `D` no tiene colisiones entre respuestas de entradas distintas y contiene el ancla y los `R` pasos, los estados `s_0,…,s_R` son distintos.

**Demostración.** Supongamos `s_j=s_k` con `0≤j<k`. Si `j=0`, las entradas `x_s` y `s_{k−1} || I`, que tienen longitudes diferentes, producen la misma salida: una colisión. Si `j>0`, la unicidad de preimagen obliga a `s_{j−1}=s_{k−1}`. Retroceder `j` veces reduce al caso anterior. Contradicción. ∎

Por tanto, una cola contiene **R entradas distintas** de índices y R respuestas distintas. Sus índices proyectados pueden repetirse. Si hay menos de 40 índices diferentes, todos pertenecen a algún conjunto `B⊆{0,…,M−1}` de tamaño 39.

El ancla es indispensable. Una base aislada `{s || I ↦ s}` no tiene colisiones y permite recorrer el mismo ciclo indefinidamente. No tiene una absorción registrada que produzca `s`. Añadir esa absorción crea una colisión. Los controles reproducen ambos casos.

## 3. Contador para un conjunto B fijo

Fijemos primero `B`, sin elegirlo después de observar la base. Se define

\[
 K_B(D)=\#\{x\in\operatorname{dom}(D):
 |x|=33,\ x_{32}=I,\ \pi_M(D(x))\in B\},
\]

donde `π_M(y)=intLE(y[0:8]) & (M−1)`. Como M es potencia de dos, el conjunto de salidas marcadas tiene densidad exacta `p_B=39/M` entre los `2^256` digests.

La consulta al oráculo comprimido modifica un solo registro de la base en cada bloque del operador, aunque la entrada se consulte en superposición. Así, el contador puede subir o bajar como máximo uno. No se presupone una evolución clásica de inserciones ni se mide la base entre consultas.

Sean `P_k` los proyectores sobre bases con `K_B(D)≥k`. Una transición desde `K_B<k` hasta `K_B≥k` solo puede salir del nivel `k−1` y marcar la respuesta del registro consultado.

## 4. Capacidad de una transición: factor 6

El lema 5.10 de [CMS19](../QROM-2026-09-23/bibliografia/CMS19.pdf), PDF 24, acota el cuadrado de la norma de transición por seis veces la inestabilidad. Para la propiedad `K_B≥k`, insertar una respuesta uniforme cruza el umbral con probabilidad a lo sumo `p_B`; insertar una entrada no puede hacer decrecer el contador. Se obtiene

\[
 \|P_k O (I-P_k)\|\le a,
 \qquad a=\sqrt{\min\{1,6p_B\}},
\]

con los proyectores de soporte finito de CMS19 implícitos. El límite por uno también se sigue de la unitariedad.

Para comprobar directamente la constante en el grupo binario, se usa la matriz del **lema 4.3 y figura 1 de CFHL21**, páginas PDF 11–12 de [arXiv v4](https://arxiv.org/pdf/2010.11658v4), [copia conservada](bibliografia/CFHL21-v4.pdf). Sea `d=2^n` el número de salidas, `Y_B` el conjunto marcado y `χ(y)∈{−1,1}` un carácter no trivial. El bloque desde una salida no marcada o `⊥` hacia una salida marcada tiene entradas

\[
 U_{y,\perp}=\chi(y)/\sqrt d,\qquad
 U_{y,z}=(1-\chi(y)-\chi(z))/d
 \quad(y\in Y_B,\ z\notin Y_B).
\]

Poniendo `p=|Y_B|/d` y `b=d^{-1}Σ_{y∈Y_B}χ(y)`, la suma de cuadrados del bloque es

\[
 \begin{aligned}
 \|U_{B,\bar B\cup\{\perp\}}\|_F^2
 &=4p-3p^2-2b+4pb-2b^2\\
 &=4p-2b-p^2-2(b-p)^2\le6p,
 \end{aligned}
\]

porque `b≥−p`. La norma de operador está acotada por la de Frobenius. Para el carácter trivial el operador es identidad y el bloque de transición es cero. Las entradas ajenas al dominio de índices tampoco aumentan `K_B`. Al combinar los bloques controlados por la entrada, el carácter y los demás registros, la misma cota vale en superposición.

La probabilidad clásica `p` no sustituye a esta norma. Por ejemplo, con 16 salidas, un único valor marcado y un carácter negativo sobre él, el bloque tiene una sola fila y norma al cuadrado `6/16−9/256`, mayor que `1/16`.

## 5. Escalera de niveles y cota binomial

Sea `|ψ_t⟩` el estado conjunto tras `t` consultas y `u_{t,k}=||P_k|ψ_t⟩||`. Los operadores internos del adversario actúan fuera de la base, por lo que conmutan con `P_k`. Separando el estado previo entre `K_B≥k` y `K_B<k`, usando unitariedad en la primera parte y la cota de transición en la segunda,

\[
 u_{t+1,k}\le u_{t,k}+a\,u_{t,k-1}.
\]

La segunda contribución solo puede provenir del nivel `k−1`; su norma está acotada por `u_{t,k−1}`. Esta desigualdad permite también borrados y sustituciones coherentes del registro. No interpreta las amplitudes como probabilidades de un proceso clásico.

Inicialmente `u_{0,0}=1` y `u_{0,k}=0` para `k>0`. Por inducción y la identidad de Pascal,

\[
 u_{L,k}\le\binom Lk a^k,\qquad
 \Pr[K_B(D_L)\ge R]\le\min\{1,\binom LR^2a^{2R}\}.
\]

La base tras L consultas tiene a lo sumo L entradas, lo que da probabilidad cero si `L<R`. La preparación dependiente de H cuenta dentro de L; cualquier preparación independiente puede formar parte del estado inicial del adversario.

Por §2, `Tcola` está incluido en la unión de `K_B≥R` sobre los `binom(M,39)` conjuntos B. Estos son proyectores diagonales sobre la base final medida; la unión de probabilidades es válida. No se suman supuestas probabilidades de consultas individuales. Aplicando esa unión a la cota fija de B se obtiene §1. ∎

## 6. Cómo entra en la reducción anterior

Definamos `s_{T,g,R}(L)=sup_A Pr[D_L∈S]` y sea `β^S_{T,g,R}(L)` una cota superior demostrada de esa cantidad. **Esta etapa no demuestra una cota útil β^S.** Entonces

\[
 b_{T,g,R}(L)\le\min\{1,\beta^S_{T,g,R}(L)+\eta_{4T,R}(L)\}.
\]

La reducción propuesta pasa a ser

\[
 \Pr[\text{falso y acepta en v1}]\le
 \min\left\{1,\left(
 \sqrt{\min\{1,A_T(L)+\beta^S_{T,g,R}(L)+\eta_{4T,R}(L)\}}
 +\sqrt{V_T(R)/2^{256}}\right)^2\right\},
 \quad L=Q+V_T(R).
\]

No se añade otra pérdida de colisión a η: `Tcola` ya excluía ese caso y `A_T` lo cubre. La unión con `S` tampoco exige independencia entre trabajo y muestreo. La propiedad de omisión sigue utilizando el conjunto local G dependiente de la transcripción, cuya estabilidad y control cuántico requieren un argumento distinto.

### Extensión analítica del corte

Rust v1 no impone un límite de 512 extracciones. La definición matemática del auxiliar y el presupuesto `V_T(R)` se extienden a cualquier entero `R≥40`: tras R respuestas sin completar 40 distintos se cuenta cola como éxito del juego ampliado. Esto conserva la inclusión de toda aceptación real en el juego auxiliar, también si la aceptación real ocurre después del corte.

**Las herramientas de expansión del suplemento anterior siguen limitadas a R≤512.** Aquí se extiende el argumento matemático y la cuenta de llamadas, no se afirma haber ejecutado el verificador completo a 65.536 extracciones. El nuevo control estructural sí recorre una cadena artificial registrada de 1.024 pasos. La fórmula de V se calcula mediante el mismo contador de longitudes de caminos y consultas; sustituir R por un corte mayor suma exactamente la diferencia de extracciones.

Cambiar este corte del análisis no modifica el formato de prueba, los parámetros del perfil ni la aceptación de Rust. El costo añadido se carga íntegramente en `L=Q+V_T(R)`.

## 7. Cálculos exactos y límites prácticos

Se registran [144 perfiles](calculos.json): nueve valores de T, cuatro presupuestos Q y cortes R en `{512,4096,16384,65536}`. Dieciséis perfiles tienen una cota η menor que uno. **Con R=512 todos los perfiles tabulados dan uno**: esta cota no mejora la estimación de la cola para aquel corte.

| T | Q | R | L=Q+V | Cota superior de Tcola en la base |
|---:|---:|---:|---:|---:|
| 4096 | 1024 | 512 | 25919 | 1 |
| 4096 | 1024 | 16384 | 41791 | 2^-19302 |
| 4096 | 65536 | 65536 | 155455 | 2^-95967 |
| 2048 | 65536 | 65536 | 152651 | 2^-34954 |
| 256 | 1024 | 65536 | 80687 | 2^-26904 |

Son límites del evento parcial `Tcola`, sujetos a la demostración propuesta. **No son bits de seguridad de NEXUS** ni frecuencias observadas de ataques. `β_omision` y `cota_aceptacion_completa` permanecen en `null`.

El cálculo usa enteros y fracciones. Para evitar imprimir numeradores de cientos de miles de bits, conserva su longitud y SHA-256, el exponente del denominador potencia de dos y un redondeo superior a `2^e`. No se usan logaritmos de coma flotante. Los cálculos reproducidos deben coincidir exactamente.

Para M>234 y Q fijo, `L=R+d`, donde `d=Q+v_T` y `v_T=V_T(R)−R` es la parte del presupuesto independiente de R. El binomio `binom(R+d,R)=binom(R+d,d)` crece polinómicamente en R; el factor `(234/M)^R` decrece exponencialmente. Por tanto, **la cota de cola aislada** puede hacerse arbitrariamente pequeña aumentando R. Esta observación aplica desde T=64, pero no garantiza cortes prácticos ni una buena cota conjunta: aumentar R también aumenta `A_T(L)` y la corrección de salida. Para T=16 y T=32, el factor local de esta demostración se limita a uno y no aporta una cota útil de cola.

## 8. Contrastes y reproducción

Dieciséis tests nuevos comprueban:

- 1.792 bloques de transición, con suma directa exacta y cota 6p.
- Unitariedad de las matrices de 4 y 16 salidas, para sus 20 caracteres en total.
- La recurrencia binomial y el redondeo superior, incluidos soporte insuficiente y saturación.
- Una cola anclada artificial de 1.024 respuestas distintas, un ciclo sin ancla y la colisión al anclarlo.
- Distinción entre cola, datos ausentes y completar exactamente en el corte.
- Los 144 perfiles reproducidos y la identidad de la fuente CFHL21 v4 de 33 páginas.

La regresión reúne **96 pruebas Python y 197 Rust**, cargo check/build y manifiesto de 897 archivos. Se preservan TG1 y los seis complementos matemáticos anteriores. [Validación](validacion.json), [protección](proteccion.json), [instrucciones](README.md).

Las pruebas finitas contrastan fórmulas e implementación; la demostración general está escrita en §§2–5 y requiere revisión independiente. No se simula un adversario cuántico general ni se establece una garantía para SHA3 fijo.

## 9. Siguiente obligación

Acotar `S`: completar los 40 índices dentro del conjunto local G, de tamaño a lo sumo `7M/8` fuera de escapes. Aplicar el contador de este informe a ese conjunto grande da `6|G|/M≥1` en el peor caso, por lo que no resuelve la omisión. Además, G depende de la extracción; no corresponde sustituirlo por un conjunto fijo sin contabilizar esa dependencia.

El siguiente desarrollo debe aprovechar la cadena y el trabajo de los nonces para la omisión, con un potencial u otra reducción que controle amplitudes. La cota clásica de omisión y la cota nueva de cola tienen demostraciones y alcances diferentes. La aprobación previa del director no se atribuye a estos resultados posteriores.
