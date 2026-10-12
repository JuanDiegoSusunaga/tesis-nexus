# Revisión interna de AIR, FRI por rondas y transferencia ROM

**Fecha:** 12 de octubre de 2026. **Estado:** revisión interna por subagente; no dictamen académico ni auditoría externa. **Objeto:** variante experimental `NEXUS-TG2-LINKED-FRI-v1`, recurrencia AIR demostrativa, perfil fijo de 16–4096 filas y 40 parejas distintas. La sustentación no forma parte de esta revisión. QROM completo de AIR/FRI conserva su condición de trabajo futuro.

## Resultado

No encontré un contraejemplo ni una contradicción algebraica a los lemas A–B, al argumento por casos ni a la fórmula ROM **bajo las hipótesis escritas**. La cuenta de nonces por potencial trata correctamente la elección adaptativa del ganador y cobra el trabajo al inicio de cada candidato. Esta conclusión es una lectura crítica interna, no una certificación de la demostración general.

Encontré documentación heredada del código que aún ofrece garantías más amplias que el manuscrito y un límite verificable de la investigación bibliográfica: existe una revisión GMW posterior a la copia de marzo, pero el servidor rechazó la descarga actual del PDF con HTTP 403. El informe distingue lo leído de lo que solo consta en las fichas primarias.

El contraste nuevo calcula **la cola exacta de 512 muestras para los nueve tamaños**, contando secuencias con menos de 40 símbolos distintos, en lugar de volver a evaluar únicamente la cota por unión. La cola exacta queda bajo la cota propuesta y esta queda por debajo de $2^{-300}$ en todos los perfiles. Siete archivos Rust coinciden byte por byte con la instantánea preservada de la transferencia ROM. [Script y resultados](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/AIR-ROM/contrastes-exactos.json).

## Hallazgos y acciones concretas

| ID | Hallazgo y localizador | Acción de cierre propuesta | Severidad para la afirmación |
|---|---|---|---|
| A1 | `nexus/nexus-zk/src/stark/channel.rs`, cabecera, líneas 15–18: el trabajo se describe como bits añadidos y anulación del remuestreo. `params.rs`, cabecera y `budget()`, presenta sumas de bits y un test que exige 100. | Delimitar esos textos y resultados como indicadores históricos del legado. No utilizar `SoundnessBudget` ni que pase ese test como evidencia de seguridad TG2. El presupuesto vigente requiere $Q$ y la fórmula propuesta. Cambiar comentarios o su exposición solo en trabajo autorizado posterior, preservando las instantáneas y TG1 aprobado. | Alta si se usan para afirmar 100 bits; no refuta el teorema ROM propuesto. |
| A2 | `nexus/nexus-zk/src/stark/merkle.rs`, cabecera, líneas 4–7: atribuye al hash la resistencia cuántica del sistema de pruebas. | Mantener la separación entre propiedades del hash/compromiso y solidez del protocolo completo. El hash no proporciona automáticamente la compilación QROM ni conocimiento cero. | Alta para una conclusión global; la versión actual del manuscrito ya limita esa conclusión. |
| A3 | GMW ePrint 2025/1993 registra una revisión del 25-09-2026; la copia utilizada tiene portada 27-03-2026 y se identifica con la actualización del 31-03. La ficha llama v4 a una actualización rotulada 25 Aug. 26. | Conservar la cita de marzo con su SHA-256 y localizadores. No sustituir el año/versión ni declarar que septiembre mantiene íntegramente el teorema sin leer y comparar el PDF. Reintentar el contraste textual cuando la fuente sea accesible, como actualización bibliográfica. | Precisión bibliográfica; no invalida la prueba elemental local. |
| A4 | `Transferencia-Protocolo-ROM.md`, §§1–2 y §10: $Q$ no está fijado como presupuesto de una amenaza concreta, y una cota llega a uno. | Registrar en M6 si el resultado se entrega como propuesta condicional o si se exige garantía cuantitativa. Para esta última fijar $Q$, probabilidad objetivo y número de pruebas/verificaciones del sistema. La fórmula actual analiza una sola prueba final de perfil fijo. | Impide prometer una garantía operacional universal; no impide presentar el resultado condicional. |
| A5 | `fri.rs::derive_query_indices` no tiene corte de 512, mientras la demostración usa un verificador truncado para su cuenta. | Conservar explícita la diferencia. La cola probabilística controla aceptación posterior al corte; no garantiza tiempo máximo ni memoria del decodificador. No describir R=512 como una protección ya desplegada en Rust. | Límite operacional, ya documentado. |
| A6 | El repo primario `zksecurity/simple-rbr-fri` contiene un teorema Lean para FRI con hipótesis explícita `FRI_MCA_Hypothesis`; no modela el AIR, la gramática ROM ni los nonces locales. | Puede ayudar como mapa de definiciones para una formalización posterior, con correspondencia y build propios. No afirmar que NEXUS está mecanizado ni instalarlo como dependencia de seguridad por su README. | Recurso de investigación; no cierra M1–M6. |

## Lectura matemática: premisas que deben conservarse

### M1–M2: divisibilidad, candidato único y campo base

La equivalencia entre validez de una traza y los tres residuos individuales nulos usa $D=X^T-1$ con raíces simples y fronteras en los dos extremos del subgrupo. El coeficiente crítico $j_* = \max\{i:R_i\ne0\}$ está fijado antes de los retos. Los coeficientes posteriores tienen residuo cero: cancelar en la ronda crítica es la cancelación total, no una cancelación parcial que otra ronda pudiera revertir. Para un enunciado falso, todo candidato polinómico base es inválido; el ejemplo histórico de una traza inválida con enunciado válido no demuestra una falsificación.

La unicidad del candidato próximo usa la distancia mínima RS $(N-T+1)/N$ y $2\delta_t$ estrictamente menor. Para $\delta_t=1/8$ hay margen positivo en los nueve perfiles. El caso no base exige que el dominio de evaluación esté en $F$: escribiendo $f=A+zB$, con $A,B\in F[X]$ y $B\ne0$, los valores base de $f$ sobre ese dominio son raíces de $B$ y no exceden $T-1$. El contraste comprueba la extensión definida por el no cuadrado 7, orden exacto de las raíces de unidad y ausencia de intersección del coset con el dominio de traza.

Localizadores: [álgebra S1](../R4-Algebra-AIR-FRI-2026-09-22.md), §§1–5; [RBR](../Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md), §§2 y 5.1–5.2; código `dimensions`, `begin` y `compose` del verificador vinculado.

### M3: acuerdo del plegado y consulta final

El lema A utiliza dos retos distintos con sus testigos de acuerdo para construir $A,B$, y la intersección de tres conjuntos fuerza la identidad del polinomio de cualquier tercer testigo. La desigualdad estricta $(1-3\theta)n>e-1$ es la que permite convertir el acuerdo puntual en identidad polinómica. Fuera de los a lo sumo $n$ retos de cancelación en posiciones discrepantes, el mismo conjunto de acuerdo sirve para las dos componentes. No basta demostrar que cada componente está cerca por separado.

En el lema B, si $A$ son puntos iniciales cuyo recorrido acepta y $W_j$ sus imágenes por cuadrados, entonces $|W_{j+1}|\ge|W_j|/2$, de modo que su densidad no disminuye. Para evitar una lectura ambigua, conviene escribir explícitamente $W_{j+1}=W_j^2$ y aplicar la premisa de acuerdo al conjunto imagen de la siguiente capa; las aperturas de ambos signos y el arrastre del código proporcionan la coincidencia requerida. La constante final da el punto de partida del recorrido inverso. Este razonamiento no exige que todos los $W_j$ sean uniones de parejas.

La distancia estrictamente mayor que $\theta$ produce una fracción de parejas rechazadas al menos $\theta$; para una lista uniforme distinta la probabilidad de omitirlas es hipergeométrica. No se multiplican probabilidades de los dos FRI ni se afirma independencia. Los umbrales locales de 1/8 satisfacen el lema elemental: su validez no depende de conjeturas generales de proximity gaps hasta capacidad.

Localizadores: [RBR](../Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md), lemas A–B, §§3–4; `fri.rs::fold`, `verify_query` y `derive_query_indices`; manuscrito §6.7.8.

### M4: selección de caso y estado absorbente

La traza fija decide entre oráculo lejano, candidato próximo no base y candidato próximo base. La composición posterior puede depender de todos los retos anteriores: las desigualdades de distancia siguen siendo uniformes respecto de esa elección. En el caso base, la composición local difiere en como máximo tres veces el error de traza; restar también $\delta_c$ deja $d=1/8+1/(8T)>0$. Cada historia en estado cero tiene un control activo fijo al llegar a la consulta final. El máximo de sus cuatro cotas evita contar varios errores de omisión para una misma historia. Las marcas de escape nunca vuelven a cero.

Localizador: [RBR](../Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md), §§5–7. La cota ideal $h_T+(8T-3)/p^2$ es conservadora; no es el error óptimo ni la probabilidad observada de un ataque.

### M5: registro hash, extracción y coincidencia de roles

La extracción requiere que la raíz se haya presentado y marcado **antes** del reto de su capa, y solo usa consultas disponibles en ese instante. Los huecos se completan con cero y el vector queda congelado. Una apertura canónica posterior que difiera requiere una colisión o una preimagen tardía cuyo digest ya estaba marcado. Esta extracción accede al registro del oráculo, no recupera un testigo desde una raíz SHA3 pública.

La gramática permite que nodo Merkle y absorción de enunciado sean exactamente la misma entrada de 65 bytes. La prueba no puede recurrir a separación global ficticia de roles. Para las consultas de reto de 33 bytes, los sufijos E/I son distintos; trabajo de 41 bytes y absorción de nonce de 49 bytes también son distintos. Fuera del evento excepcional, la unicidad de preimágenes de estados y las ventanas marcadas permiten reconstruir el prefijo válido en orden. Es indispensable contabilizar consultas de preparación e información auxiliar correlacionada con el oráculo.

El monitor marca como máximo 48 ventanas de 32 bytes por entrada relevante de hasta 79 bytes, más su respuesta. Los digests de la prueba admitida añaden a lo sumo $B_T$ marcas. No se condiciona una moneda nueva a la ausencia de excepciones futuras: se mantiene la ejecución original hasta el primer evento. La masa máxima $\mu$ de reducción modular trata las dos coordenadas uniformes antes de ese corte. En el perfil fijo, un reto previamente consultado no crea una oportunidad nueva.

Localizadores: [transferencia ROM](../Transferencia-ROM-2026-09-23/Transferencia-Protocolo-ROM.md), §§3–6; [revisión crítica](../Revision-Critica-ROM-2026-09-23/Revision-Critica-ROM.md), §§2–3; `merkle.rs::verify` y `channel.rs::absorb_tagged`, `squeeze`, `challenge_ext`.

### M5: nonces, potencial y cola

Un candidato $(s,n)$ se cobra en su primera consulta de trabajo **o** absorción, no cuando se selecciona al ganador. Su prefijo fija oráculos y conjunto bueno $G$. Por eso tiene sentido el potencial $\phi=w\rho_a$ con $\rho_a=\binom{|G|-a}{q-a}/\binom{M-a}{q-a}$. La identidad de la siguiente extracción conserva esperanza incluso con repetidos. Las respuestas crudas y todo el historial de otros candidatos entran en el condicionamiento: una fusión de cadenas nuevas implica una excepción ya cobrada. Abandonar y retomar un candidato no lo reinicia.

Poner a cero los potenciales al ocurrir una excepción solo disminuye su esperanza; no altera retroactivamente la distribución de monedas frescas. La verificación final puede completar un candidato explorado o iniciar uno adicional. De ahí $C\le Q+1$ y la pérdida $(Q+1)2^{-g}h_T$. Condicionar al trabajo ya ganado y volver a multiplicar por $2^{-g}$ sería un error; el argumento actual evita esa operación.

Para la cola, el potencial separado conserva el indicador de no haber reunido 40 distintos en las primeras 512 extracciones, aun si el adversario sigue después. La aceptación original posterior al corte implica ese indicador y trabajo válido. El monitor de la verificación final solo necesita ejecutarse hasta el corte; las consultas anteriores del adversario siguen dentro de $Q$. Esto conserva el factor de trabajo y evita añadir una cantidad ilimitada a $V_T$.

Localizadores: [revisión crítica](../Revision-Critica-ROM-2026-09-23/Revision-Critica-ROM.md), §§4–5; [transferencia ROM](../Transferencia-ROM-2026-09-23/Transferencia-Protocolo-ROM.md), §§7–9; manuscrito §6.7.9.

### Cuenta y alcance de la fórmula

Para T=4096: 22.080 hashes de caminos, 2.240 de hojas y 575 del canal truncado dan $V_T=24.895$; las raíces y caminos dan $B_T=22.106$. La forma se valida antes de empezar el canal. Los puntos AIR se verifican como `Fp2::from_base`, por lo que las hojas compartidas usan 17 bytes y no se confunden con hojas Felt del legado.

La fórmula propuesta conserva tres pérdidas de eventos separados:

$$
E_{\mathrm{ROM}}\le \min\left\{1,\frac{S(49S+B_T)}{2^{256}}
+(Q+m)\frac{N\mu}{2}+(Q+1)2^{-g}(h_T+\tau_T)\right\},\qquad S=Q+V_T.
$$

No encontré fundamento para sumar automáticamente 20 bits a una cifra de seguridad global. La pérdida de trabajo solo multiplica el evento final de muestreo/cola y crece con candidatos. El modelo es un único oráculo aleatorio clásico con perfil fijo y una prueba final; la función determinista SHA3, varios perfiles simultáneos, verificación operacional repetida y consultas cuánticas exigen especificaciones adicionales. No son afirmaciones de esta fórmula.

## Investigación web y versiones

Consultas realizadas el 12-10-2026; fuentes primarias. Las fichas y el texto accesible se contrastaron con las copias preservadas; los intentos de descargar los tres PDF actuales desde IACR fallaron con HTTP 403 y quedaron en [el registro](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/AIR-ROM/fuentes-web.json). No se declara lectura integral de una versión que no se pudo recuperar.

| Fuente | Versión y contenido verificado | Relación concreta con TG2 |
|---|---|---|
| [GMW: A Simplified Round-by-round Soundness Proof of FRI](https://eprint.iacr.org/2025/1993) | La ficha registra última revisión 25-09-2026, v4 rotulada 25 Aug. 26 y una corrección de función de estado en v2 de 04-11-2025. Copia local: portada 27-03-2026, revisión identificada 31-03; Lema5.1 y Teorema5.2. | La prueba local sigue el mantenimiento del mismo conjunto de acuerdo, pero demuestra su propio lema elemental para radios restringidos. La versión de marzo ya es posterior a la corrección de 2025. No puedo confirmar los cambios íntegros de septiembre. |
| [Nota del coautor Mohnblatt, 31-03-2026](https://nmohnblatt.me/fri-security-update/) | Describe el parámetro continuo de intercambio y añadidos de compromiso/batching, y señala que el análisis de seguridad de esa actualización no cambia. | Ese comentario se refiere a marzo; no debe extrapolarse a revisiones posteriores. No transfiere automáticamente la extracción de FRI a raíces arbitrarias del ejecutable local. |
| [BCS16: Interactive Oracle Proofs](https://eprint.iacr.org/2016/116) | Ficha: última revisión29-04-2016; portada de la copia local10-02-2016. El compilador se relaciona con ataques de restauración de estado. | Justifica la obligación de extracción y restauración; la gramática de bytes y constante49 son propias de TG2. No basta insertar la cota ordinaria ideal en un teorema por rondas. |
| [BGK+23: Fiat-Shamir Security of FRI and Related SNARKs](https://eprint.iacr.org/2023/1071) | Ficha: última revisión05-03-2024; texto PDF indexado y copia local con portada15-02-2024. Estudia RBR y protocolos correlacionados. | Las obligaciones de correspondencia no desaparecen por citar el resultado para FRI aislado. La consulta compartida, campo base y relación AIR se justifican localmente. |
| [Holmgren: On Round-By-Round Soundness and State Restoration Attacks](https://eprint.iacr.org/2019/1261) | Ficha: recibido05-11-2019; establece relación entre esas nociones para pruebas interactivas. | Ayuda a precisar por qué una cota por ronda controla oportunidades de restauración; no identifica automáticamente intentos ideales con llamadas hash concretas. |
| [Block et al.: On Soundness Notions for Interactive Oracle Proofs](https://eprint.iacr.org/2023/1256) | Ficha: última revisión05-03-2024; distingue solidez por rondas, especial y de conocimiento. | Confirma la necesidad de separar solidez de aceptación y extracción de conocimiento. Esta revisión no extiende el análisis a QROM. |
| [Crites–Stewart: On Reed–Solomon Proximity Gaps Conjectures](https://eprint.iacr.org/2025/2046) | Recibido05-11-2025, revisado19-12-2025. La ficha informa contraejemplos a varias conjeturas de acuerdo/lista hasta capacidad. | No reutilizar una etiqueta genérica de proximity gaps como premisa establecida. Esto no proporciona un ataque concreto a Goldilocks ni refuta el lema elemental local, que no usa las conjeturas mencionadas. |
| [Repo primario simple-rbr-fri](https://github.com/zksecurity/simple-rbr-fri), [teorema fijado](https://github.com/zksecurity/simple-rbr-fri/blob/5d99bc7bcabc7b640e063f4d75f17d8262e00a8a/SimpleRbrFri/Soundness.lean) | Revisión `5d99bc7bcabc7b640e063f4d75f17d8262e00a8a`, identificada mediante GitHub API. Se leyó `FRI_RBR_Soundness`, incluyendo parámetro explícito `FRI_MCA_Hypothesis`; el README indica que el lema de instancia2.5 no se formalizó. No se instaló ni compiló. | Recurso útil para definir estados y comprobar correspondencia matemática posterior. Su declaración no mecaniza AIR+dosFRI, oráculo único, trabajo, cola ni Rust de TG2. |

## Evidencia nueva y límites del dictamen interno

La recurrencia de conteo usa $c_{r,a}=a c_{r-1,a}+(M-a+1)c_{r-1,a-1}$ y conserva solo estados con $a<40$, que nunca regresan desde $a\ge40$. De este modo $\Pr[\text{cola}]=\sum_{a<40}c_{512,a}/M^{512}$, sin suponer que la unión de subconjuntos sea exacta. Los controles con q=2 coinciden con la probabilidad cerrada de repetir un único símbolo.

| T | Exponente entero e con cola exacta ≤ 2^-e | Exponente entero e con cota de unión ≤ 2^-e |
|---:|---:|---:|
|16|307|307|
|32|768|768|
|64|1236|1236|
|128|1706|1706|
|256|2178|2178|
|512|2651|2651|
|1024|3123|3123|
|2048|3596|3596|
|4096|4069|4069|

Los exponentes se obtienen por comparación racional exacta. Que sus partes enteras coincidan no significa que las dos probabilidades sean iguales. Son resultados del muestreo ideal; no son bits de seguridad global, ni una cota QROM, ni una medida de tiempo de ataque.

Los siete archivos contrastados son el verificador vinculado, `field.rs`, `fri.rs`, `channel.rs`, `merkle.rs`, `params.rs` y `types.rs`, con SHA-256 en el resultado. Esta revisión no modifica los paquetes originales, TG1 aprobado, Rust ni el manuscrito compartido. Check/test/build del workspace se dejan a la ejecución común del agente raíz.

M1–M5 pueden presentarse con las hipótesis y la calificación de resultados propuestos actuales; M6 debe fijar su suficiencia académica. El dictamen externo de cada punto permanece pendiente. La revisión por subagente, los tests y las fuentes web no sustituyen la aprobación del director o del revisor matemático.
