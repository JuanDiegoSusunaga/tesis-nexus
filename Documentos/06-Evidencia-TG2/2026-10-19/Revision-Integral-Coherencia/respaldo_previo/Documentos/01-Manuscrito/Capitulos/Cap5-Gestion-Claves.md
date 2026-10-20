# Capítulo 5 — Gestión Activa del Ciclo de Vida de Claves

*Objetivo 3 · la capa operativa de seguridad*

> **Rol en el arco de la tesis.** Este capítulo desarrolla la **lógica de seguridad activa** que rodea al primitivo de firma (Cap. 4): cómo se obtiene aleatoriedad de calidad, cómo se deriva la semilla de la clave, y cómo se rota la clave para limitar el daño ante un compromiso. Es la capa **operativa** que da *resiliencia* al sistema; reformula sobre bases criptográficas correctas el monitoreo de entropía del alcance original.

---

## 5.1 Introducción

Una clave de firma post-cuántica no vive aislada: nace de una fuente de aleatoriedad, se deriva de una semilla y, a lo largo de su uso, debe **rotarse** para acotar el impacto de un eventual compromiso. El Objetivo 3 modela e implementa esta **gestión activa del ciclo de vida**, estudiada mediante cuatro elementos:

1. una **fuente de entropía monitoreada**, evaluada por su **min-entropía** y vigilada por **pruebas de salud en línea** (NIST SP 800-90B), §5.2–5.3;
2. la **derivación de claves** mediante un KDF con separación de dominio, §5.4 (conecta con el Cap. 4, §4.5);
3. la **rotación con secrecia hacia adelante**, disparada por política, con registro auditable, §5.5;
4. la **política experimental de reexpansión por firma**, evaluada por separado del gestor: propone conservar la semilla y descartar la representación de clave después de cada operación, con los límites de memoria y custodia de §5.6.

El monitor, la derivación y la rotación forman el ciclo del gestor (§5.7); la política de reexpansión se evalúa por separado. El diseño une la fuente de aleatoriedad con la clave Dilithium y su rotación. El capítulo corrige explícitamente el enfoque del prototipo original, que usaba la **entropía de Shannon de la semilla** como métrica de seguridad —un planteamiento erróneo que se explica y reemplaza en §5.2—.

---

## 5.2 La métrica correcta: min-entropía de la fuente

El prototipo original disparaba la rotación cuando la **entropía de Shannon** de la semilla de 32 bytes caía por debajo de 7,5 bits/byte. Este planteamiento es **incorrecto por dos razones**:

1. **La entropía de Shannon de una muestra no mide el secreto de una clave.** La salida de un CSPRNG luce con entropía de Shannon máxima ($\approx 8$ bits/byte) **independientemente** de si la semilla-fuente es secreta o predecible. Lo que importa para una clave es la **imprevisibilidad de la fuente**, no la uniformidad estadística de una muestra.
2. **Es degenerada para 32 bytes.** Con solo 32 muestras sobre 256 valores posibles, la entropía de Shannon empírica máxima alcanzable es $\log_2 32 = 5$ bits/byte, **nunca 7,5**. El umbral era inalcanzable y la prueba habría fallado.

**La métrica pertinente es la min-entropía de la fuente:**

$$
H_\infty(X) = -\log_2 \Big(\max_x \Pr[X=x]\Big).
$$

La min-entropía captura la imprevisibilidad en el **peor caso** (el valor más probable), que es la medida conservadora apropiada para material criptográfico. La cantidad de bits de seguridad que aporta un bloque de datos de la fuente es $\approx H_\infty \times (\text{longitud})$.

> **NIST SP 800-90B** estandariza precisamente la **estimación de min-entropía** de fuentes de entropía (con estimadores para los casos IID y no-IID, p. ej. el de valor más común, el de Markov, etc.). NEXUS adopta este marco: la fuente se caracteriza por su min-entropía estimada, no por la entropía de Shannon de una muestra.

---

## 5.3 Monitoreo de salud en línea (NIST SP 800-90B)

"Monitoreo activo de entropía", en sentido riguroso, significa **vigilar la salud del generador en tiempo de ejecución** para detectar su degradación. NIST SP 800-90B define dos **pruebas de salud continuas** que NEXUS adopta:

**1. Repetition Count Test (RCT).** Detecta un generador "atascado" (que emite el mismo valor repetidamente). Dado un nivel de min-entropía $H$ y una probabilidad de falso positivo $\alpha$, define un umbral

$$
C = 1 + \left\lceil \frac{-\log_2 \alpha}{H} \right\rceil.
$$

Si un mismo valor aparece $\ge C$ veces **consecutivas**, la prueba **falla** (la fuente se considera comprometida).

**2. Adaptive Proportion Test (APT).** Sobre una ventana de $W$ muestras, cuenta las apariciones del primer valor, incluida la muestra de referencia; si el conteo **alcanza** el corte $C$, la prueba falla. SP 800-90B §4.4.2 establece $W=1024$ para fuentes binarias y $W=512$ para no binarias. NEXUS utiliza el segundo perfil, con muestras de un byte.

**Parámetros implementados.** Para la barra $H=7,5$ bits/byte y $\alpha=2^{-20}$, el RCT conserva $C=4$. El APT emplea el modelo condicional $B=1+\operatorname{Bin}(511,2^{-7,5})$ y elige el menor corte con $\Pr[B\ge C]\le\alpha$. El cálculo numérico de la cola binomial produce $C=16$: la cola en 15 es aproximadamente $1,523\times10^{-6}$ y en 16, $2,764\times10^{-7}$. Se sustituyó la aproximación normal que producía 11; el conteo y la condición de disparo se comprueban explícitamente en las pruebas del módulo.

**Evaluación y recuperación.** `SentinelSeed` comienza sin evaluación y mantiene bloqueadas la derivación y la rotación. `ingest_source` acumula lotes fijos de **65.536 muestras**, incluso si llegan en llamadas parciales, y aplica RCT/APT continuamente. La frecuencia máxima empírica del lote debe satisfacer la barra configurada. Un fallo de salud o de esa barra queda retenido. `begin_source_recovery` inicia una reevaluación: exige otro lote completo y, si este pasa, una renovación de semilla antes de habilitar derivaciones. Rotar conserva los contadores continuos y el historial; nunca declara sana la fuente por sí mismo.

**Fuente observada y límites.** El monitor evalúa el flujo de bytes que entrega la aplicación. La semilla inicial procede de ChaCha20 inicializado desde el generador del sistema operativo; la renovación obtiene material fresco de `OsRng`. El prototipo no ofrece acceso a la fuente física de ruido del sistema operativo ni acredita automáticamente que el flujo observado sea esa fuente. Su vinculación y calificación son requisitos del despliegue. El criterio del modelo exige un margen de calificación de al menos 0,2 bits sobre la barra. La estimación puntual por frecuencia máxima usada en el barrido no incluye el límite de confianza del estimador MCV completo de SP 800-90B §6.3.1; tampoco detecta por sí sola dependencia temporal. Una salida de CSPRNG con frecuencias favorables no demuestra entropía física ni conformidad normativa.

---

## 5.4 Derivación de claves por KDF

El modelo de diseño separa el acondicionamiento del material de una fuente caracterizada, la derivación contextual y la expansión ML-DSA. Una KDF debe analizarse bajo una distribución de entrada y un supuesto criptográfico precisos: la separación de dominio organiza contextos, pero no demuestra por sí sola extracción uniforme ni independencia de claves.

HKDF (RFC 5869, *Extract-then-Expand*) y construcciones basadas en SHAKE256 son posibles alternativas de diseño con hipótesis distintas; no se consideran equivalentes automáticamente. La expresión siguiente describe el modelo propuesto, **no la función ejecutada por Sentinel**:

$$
\xi = \mathrm{KDF}\big(\underbrace{\text{material de la fuente}}_{\text{alta min-entropía}},\ \text{sal},\ \underbrace{\text{contexto}}_{\text{dominio} \,\|\, \text{epoch}}\big),
$$

y la semilla $\xi$ alimentaría `KeyGen_internal` de ML-DSA (Cap. 4, §4.5). Justificar ese modelo requiere caracterizar la fuente, el acondicionamiento, los dominios y las pérdidas de la construcción seleccionada.

**Implementación observada.** `SentinelSeed::derive_key_unchecked` emplea SHA3-256, sin ejecutar HKDF ni SHAKE256 en esta etapa:

$$
\xi_{e,j}=\mathrm{SHA3\text{-}256}\big(D\parallel\operatorname{LE64}(e)\parallel\operatorname{LE64}(j)\parallel s_e\parallel\mathrm{contexto}\big).
$$

$D$ es `NEXUS_SENTINEL_DERIVE`, $e$ la época, $j$ el contador de derivaciones y $s_e$ la semilla retenida. `derive_key` comprueba primero la política de salud, edad y uso; `NexusKeypair::from_sentinel_seed` entrega después $\xi_{e,j}$ a `keygen_from_seed`. La semilla inicial procede de ChaCha20 inicializado desde el generador del sistema operativo; la rotación mezcla la semilla anterior con 32 bytes frescos de `OsRng` mediante SHA3-256 (§5.5). `from_bytes` permite además suministrar una semilla, cuya calidad queda a cargo del consumidor.

**Relación con el monitor.** Las muestras entregadas a `ingest_source` afectan la compuerta de salud; no se incorporan como material de entrada a la derivación anterior. El despliegue debe justificar la relación entre ese flujo observado y el generador que suministra semillas, así como su calificación y protección. Pasar RCT/APT o la barra de frecuencia máxima no demuestra que $s_e$ tenga alta min-entropía ni que sus derivados sean uniformes. La transición de época cambia las entradas; su separación criptográfica y la secrecia hacia adelante permanecen condicionadas por los supuestos y la eliminación de copias de §5.5.

---

## 5.5 Rotación con secrecia hacia adelante

La rotación busca limitar la aceptación de claves comprometidas mediante épocas y revocación. Su efecto exige que el verificador aplique la vigencia, que las copias retiradas se eliminen y que el material fresco futuro no sea accesible al atacante. No protege por sí sola frente a un adversario que conserva el control del firmador.

**Disparadores de rotación (por política).** La rotación se activa cuando se cumple **cualquiera** de:

- **uso** superior a un umbral (p. ej. 100.000 derivaciones),
- **antigüedad** superior a un máximo (p. ej. 24 horas),
- **fallo de las pruebas de salud** (RCT/APT, §5.3) de la fuente.

**Mezcla con secrecia hacia adelante.** La nueva semilla se deriva mezclando la anterior con material fresco mediante un hash de un solo sentido:

$$
\xi_{e+1} = H\big(\text{dominio} \,\|\, \xi_{e} \,\|\, \text{material fresco} \,\|\, e\big), \qquad \text{y se borra } \xi_{e}.
$$

La resistencia a preimagen de $H$, la protección del material fresco y la eliminación de las copias anteriores sustentan la separación entre épocas. El prototipo mezcla material del generador del sistema operativo y usa `zeroize` al descartar semillas y claves. Esto no demuestra el borrado de todas las copias de memoria ni constituye por sí solo una prueba de seguridad de un esquema de firmas con evolución de claves. Esas condiciones delimitan la pretensión de **secrecia hacia adelante**.

**Bloqueo ante degradación.** El gestor bloquea tanto la derivación como la firma de operaciones si la fuente falla, falta evaluación, se agota el cupo de derivaciones o vence la edad permitida. Tras un fallo exige iniciar la recuperación, completar un nuevo lote sano y rotar antes de volver a firmar. Las firmas internas que autorizan la transición de época o el retiro tienen un dominio criptográfico separado; el retiro puede ejecutarse para revocar una identidad aun con la fuente bloqueada. El límite de uso cuenta derivaciones, no firmas de operaciones.

**Rotación efectiva e identidad.** `KeyManager::rotate_sentinel` prepara una nueva semilla y reemplaza todas las claves gestionadas en una misma transición. La identidad de cuenta conserva la dirección del alta; el hash de la nueva clave pública es un identificador de clave distinto. Se actualizan época y metadatos, se conserva la identidad predeterminada y se descartan los secretos anteriores. Una falla de derivación, autorización o validación del registro impide instalar cualquier parte de la transición. Esta atomicidad se refiere al estado en memoria; no se ha implementado una transacción durable entre custodia de secretos y almacenamiento externo.

**Registro auditable.** El módulo `nexus-crypto::registry` registra altas, rotaciones y retiros. Cada evento incluye secuencia, enlace SHA3-256 al evento anterior y marca de tiempo; las rotaciones añaden épocas, compromisos de semillas y claves públicas entrantes. Todas las claves salientes autorizan el lote y todas las entrantes prueban su posesión firmando su contenido. El registro conserva únicamente información pública. La recarga verifica formato, enlaces y firmas antes de reconstruir los índices. El orden lo fija la secuencia; la marca de tiempo no equivale a tiempo certificado.

**Vigencia e historia.** Las firmas de operaciones incluyen identidad y época dentro del mensaje autenticado. `verify_current` exige la época vigente; `verify_historical` permite comprobar una firma de una época retirada. Esta última comprobación no demuestra que se haya emitido antes del retiro. Para acreditar aceptación histórica, la aplicación debe aportar una posición confiable de su historial; `verify_at_record` comprueba la vigencia respecto de una posición del registro. La prevención de repeticiones dentro de una misma época requiere además los nonces y reglas de la aplicación.

**Punto de control y alcance.** Un punto de control contiene número de eventos y hash completo de cabecera. La recarga rechaza un historial que contradiga ese prefijo confiable o sea más corto. Su custodia independiente y actualización son necesarias: un punto antiguo no detecta la pérdida de eventos posteriores. R3 no integra todavía este registro en el estado del sequencer ni en el anclaje L1. Tampoco recupera las claves privadas después de una caída: la recuperación comprobada es la del historial público. El formato de transacciones del prototipo continúa separado de la API de firmas por época.

---

## 5.6 Residencia efímera: modelo, evidencia y límites

### 5.6.1 Representaciones y alcance implementado

FIPS 204 §3.6.3 permite conservar la semilla de 32 bytes para reconstruir el par y exige protegerla como dato sensible; RFC 9881 §§6 y 8.1 recomienda ese formato para almacenamiento e intercambio [NIST24; RFC9881]. Esto no prescribe reconstruir la clave antes de cada firma ni garantiza menor probabilidad de compromiso.

La política experimental expande la misma semilla, firma y descarta el par al salir del ámbito. Reproduce la misma clave y no rota la época. **El gestor actual conserva las claves codificadas entre operaciones:** `KeyManager` almacena objetos `NexusKeypair`; el benchmark `residencia_bench` evalúa la política por separado. Su semilla constante y pública es un dato de ensayo, no una propuesta de custodia real.

La inspección de `dilithium.rs` muestra una clave codificada en un `Vec<u8>`. Al firmar, el envoltorio la copia a un arreglo y construye un `fips204::PrivateKey` con polinomios precomputados. Por tanto, incluso la variante denominada cacheada en el benchmark vuelve a deserializar la clave en cada firma; no conserva entre llamadas el objeto precomputado del backend. Los tiempos comparan estas rutas concretas.

**Tabla 5.1 — Inventario de representaciones ML-DSA-65, fips204 0.4.6.**

| Región o representación | Bytes | Interpretación |
|---|---:|---|
| Semilla de ML-DSA | 32 | Permite reconstruir la capacidad de firma |
| Clave privada codificada | 4032 | Incluye 96 B públicos; proteger el contenedor completo |
| Componentes sensibles codificados | 3936 | K, s1, s2 y t0; cantidad de representación, no de entropía |
| Clave pública codificada | 1952 | Información pública; excluida de los bytes secretos |
| Par serializado del envoltorio | 5993 | 4032 + 1952 + 9 B de cabeceras; no es tamaño de RAM |
| Objeto PrivateKey del backend | 17536 | size_of comprobado; incluye precomputación, sin toda la memoria auxiliar |

Los 96 bytes públicos de la clave codificada corresponden a rho y tr; la clave K y los vectores restantes se consideran sensibles. El objeto del backend contiene 128 bytes y 17 polinomios de 256 enteros de 32 bits. Su tamaño de tipo tampoco mide todas las copias en pila, registros, temporales o residuos del sistema operativo. La semilla maestra de Sentinel y las semillas derivadas son objetos adicionales; no se confunden con una sola semilla ML-DSA.

Tres pruebas contrastan longitudes serializadas para los tres niveles, reconstrucción de capacidad de firma desde la semilla después de descartar el par y tamaño de los objetos del backend junto con su contrato `ZeroizeOnDrop`. Forman parte de la suite de 197 pruebas. No se inspeccionó memoria liberada ni se acreditó borrado físico; los registros de reproducibilidad conservan los detalles y sus hashes.

### 5.6.2 Modelo de amenaza

El activo es la capacidad de producir firmas válidas no autorizadas, que puede obtenerse mediante la clave, una semilla suficiente para reconstruirla o el control del servicio de firma. Se distinguen cuatro escenarios:

1. **Captura completa del proceso, incluida la semilla.** Si la semilla reconstruible está accesible, descartar la clave codificada no elimina la capacidad de firma. En este escenario ideal de captura completa, la reducción del tamaño residente no aporta la protección pretendida.
2. **Captura aislada con semilla fuera del alcance.** Supóngase un instante uniforme e independiente de la actividad, una frontera que protege realmente la semilla, ausencia de residuos y exposición de la clave únicamente durante intervalos definidos. La probabilidad de coincidir con la exposición es la longitud de la unión de esos intervalos dividida por el horizonte. Es una propiedad del modelo temporal, no una probabilidad medida de compromiso.
3. **Acceso persistente o sincronizado.** Un atacante que espera o provoca una firma puede observar la expansión o abusar de la API. La hipótesis de captura uniforme deja de aplicar; hacen falta aislamiento, autorización y controles del servicio.
4. **Volcados, paginación o remanencia.** El material puede permanecer después del retorno o cierre del proceso. La duración del benchmark no delimita esa exposición y el modelo ideal debe ampliarse con las copias y tiempos efectivamente observados.

Sellar una semilla protege su almacenamiento bajo condiciones concretas; si se abre en el proceso comprometido para cada firma, reaparece una ventana de exposición. Un diseño donde la firma ocurra dentro de una frontera de hardware tiene otro modelo de confianza y requiere evaluación propia. NEXUS no integra todavía tal custodia.

### 5.6.3 Métrica y sensibilidad

Para un conjunto declarado de regiones de memoria, se define la residencia acumulada como $W_{\mathcal R}(T)=\int_0^T B_{\mathcal R}(t)\,dt$, en bytes·segundo. Se cuentan las copias simultáneas por separado, se distinguen regiones públicas y sensibles y se declara la frontera observada. Esta cantidad no mide entropía ni implica que la probabilidad de compromiso sea proporcional a los bytes: una sola copia de la semilla puede bastar para recuperar la clave.

Para ilustrar el modelo, se toma una región protegida de clave codificada de $s=4032$ B y una semilla de $b=32$ B retenida en ambas políticas. Los 96 B públicos dentro de esa región se incluyen por contabilidad del contenedor, no como secreto. Sin copias adicionales, la política cacheada tiene $W_c/T=b+s$. Con $n$ operaciones secuenciales de duración fija $\tau$, la reexpansión tiene $W_j/T=b+s\,n\tau/T$. Si $\lambda=n/T$, la razón es $(b+s)/(b+s\lambda\tau)$, bajo $\lambda\tau\leq 1$. Con duraciones distintas se usa su suma; para la coincidencia temporal del escenario 2 se usa la unión de intervalos, que evita contar solapamientos dos veces.

La siguiente sensibilidad usa la mediana R4 de firma efímera ML-DSA-65, 478,74 µs, como duración supuesta de toda la región. Es un escenario aritmético: la mediana no estima por sí sola la duración media de residencia; tampoco incluye todas las copias. No se interpreta el inverso de esa duración como capacidad medida del sistema.

**Tabla 5.2 — Sensibilidad del modelo de regiones protegidas; valores supuestos.**

| Operaciones/s | Fracción temporal (%) | W/T (B) | Razón cacheada/reexpansión |
|---:|---:|---:|---:|
| 1 | 0,048 | 33,930 | 119,775 |
| 10 | 0,479 | 51,303 | 79,216 |
| 100 | 4,787 | 225,030 | 18,060 |
| 1000 | 47,874 | 1962,296 | 2,071 |
| 2000 | 95,749 | 3892,592 | 1,044 |

A diez operaciones/s, el modelo reduce la residencia media de las regiones elegidas de 4064 B a 51,303 B, razón 79,216. Esto no significa 79 veces menos probabilidad de compromiso: con semilla accesible se mantiene el escenario 1. Si se protege la semilla y se cumplen todas las hipótesis del escenario 2, la coincidencia temporal ideal sería 0,479 %. Cerca de ocupación continua desaparece casi toda la ventaja temporal. Las cifras iniciales basadas en 5993 B mezclaban datos públicos y cabeceras, por lo que se retiran como medida de exposición secreta.

### 5.6.4 Mediciones y controles pendientes

H1 y H2 conservan sus latencias históricas. La serie R4 mide 327,42 µs de firma cacheada, 478,74 µs de reexpansión con firma y 145,03 µs de expansión aislada para ML-DSA-65; sus intervalos y procedencia están en la Tabla 6.11. La diferencia de medianas de firma, calculada antes del redondeo, es 151,33 µs y tiene carácter descriptivo; no constituye una medición pareada de sobrecosto ni de residencia secreta.

El envoltorio y los objetos del backend invocan `zeroize` al descartarse, pero existen arreglos temporales y posibles copias por compilador, biblioteca y sistema. No se ha demostrado la eliminación de todos ellos. La lectura de un buffer borrado o la presencia de un destructor tampoco basta para demostrar borrado de todas las representaciones. Medir esa propiedad requeriría instrumentación sobre claves exclusivamente de ensayo, un inventario de copias, condiciones de salida y una frontera de observación explícita; queda pendiente como evaluación de despliegue.

**Conformidad.** El uso de una biblioteca que implementa ML-DSA no certifica el módulo completo. FIPS 204 §3.6.1 exige que la semilla inicial provenga de un RBG aprobado. La derivación contextual y la cadena de Sentinel requieren justificar su correspondencia con el perfil normativo; la autorización de almacenar y reexpandir una semilla no certifica cualquier KDF que la produzca.

### 5.6.5 Comparación y contribución acotada

La revisión del 22 de septiembre consultó las fuentes primarias mediante búsquedas sobre ML-DSA/Dilithium, reexpansión, residencia y zeroización. Bos, Renes y Sprenkels estudian restricciones de memoria y técnicas de cómputo bajo demanda [BRS22]; no se infiere de ese antecedente una garantía de seguridad por residencia. RFC 9881 recomienda la representación por semilla, y OpenSSL 3.5 documenta su retención y uso al importar [RFC9881; OSSL35]; importar desde semilla no prescribe la política por firma.

El borrador de Connolly reconoce regeneración y caché según necesidad [Connolly26]. Se cita expresamente la versión 02 del 19 de marzo, cuyo vencimiento indicado es el 20 de septiembre de 2026: es un borrador informativo archivado, no un estándar vigente. Sawa y Suzaki estudian duplicación y residuos de claves AES a escala de sistema [Sawa25]; Arranz-Olmos et al. analizan zeroización con garantías sobre código y compilación [A+23]. Esos resultados muestran obligaciones distintas de medir latencia, sin trasladar sus resultados cuantitativos a ML-DSA.

El aporte defendible de NEXUS es la comparación reproducible de dos rutas de firma, el inventario de representaciones y un modelo que separa residencia y compromiso. La búsqueda es exploratoria, con consultas y límites registrados en el informe R5; no demuestra prioridad de la idea, inexistencia de soluciones similares ni novedad matemática de bytes por tiempo. La protección efectiva sigue condicionada a la custodia y al modelo del atacante.

---

## 5.7 La tubería unificada

Los elementos anteriores forman un único ciclo de vida, que unifica los Objetivos 2 y 3:

**Figura 5.1 — Derivación y rotación de claves: gestor con bloqueo por salud.**

![La derivación queda condicionada a los controles de la fuente. Un fallo bloquea el proceso y exige recuperar y reevaluar la fuente antes de continuar. La rotación renueva la época y las claves operativas y registra el evento.](../Figuras/figura-5-1-ciclo-claves.png){width=6.5in}

*Fuente: elaboración propia. Ciclo implementado en el gestor del prototipo; la vinculación de la fuente, la custodia durable y el anclaje externo mantienen los límites de §5.8. Superar RCT/APT no sustituye la caracterización de la fuente. La variante KDF debe leerse con la limitación del perfil FIPS indicada en §5.6.*

El flujo conecta la primitiva de firma y el monitoreo del Obj. 3 mediante el gestor de claves. Su recuperación requiere nuevas muestras y reevaluación. R3 implementa la actualización de claves operativas, el descarte de los secretos anteriores y el registro de la transición; la integración con la ejecución L2 conserva los límites indicados en §5.8.

---

## 5.8 Estado de implementación y limitaciones

**Tabla 5.3 — Estado de implementación y limitaciones.**

| Componente | Estado |
|---|---|
| Rotación de semilla por política y mezcla unidireccional | Integrada con todas las claves del gestor; transición atómica en memoria |
| Registro auditable de épocas y tratamiento de claves retiradas | Firmas de transición, historial público y punto de control probados; anclaje L1 pendiente |
| Evaluación puntual por frecuencia máxima | Lotes de 65.536 muestras implementados; calificación de la fuente externa requerida (§5.3) |
| RCT/APT, bloqueo y recuperación | Corte binomial y reevaluación implementados; 13 pruebas nuevas pasan el 22 de septiembre |
| KDF contextual desde semilla (SHA3, dominio separado) | Implementado; derivación condicionada al estado de evaluación de `SentinelSeed` |
| `KeyGen` reproducible de Dilithium desde semilla | **Implementado** (migrado a `fips204`; test `test_deterministic_from_seed`, Cap. 4 §4.5) |
| Política de residencia efímera (KeyGen JIT por firma + `zeroize`) | Latencias R4 e inventario/modelo R5 comprobados; política separada del gestor, sin medición de todas las copias |

> **Validación funcional.** La suite del prototipo contiene 197 pruebas, con comprobaciones de tipos y construcción correctas. Los ensayos de gestión de claves cubren sustitución de claves, épocas, bloqueo, fallos intermedios y recuperación del registro. Una demostración con dos identidades ML-DSA-65 genera un archivo público de 28.416 B; el evento de rotación ocupa 17.498 B porque incluye claves y firmas. Son tamaños de esa ejecución, no una medición de latencia. La evidencia usa flujos sintéticos. Quedan abiertas la vinculación y calificación de la fuente, la custodia durable y la integración del registro en L2/L1; no se atribuyen al prototipo inmutabilidad global ni recuperación de secretos desde el registro.

---

## 5.9 Conclusiones del capítulo

Este capítulo desarrolló la gestión activa del ciclo de vida de claves (Objetivo 3):

1. Reemplazó la **métrica errónea** (entropía de Shannon de la semilla) por la **min-entropía de la fuente**, criptográficamente pertinente y conforme a NIST SP 800-90B.
2. Definió el **monitoreo de salud en línea** (RCT/APT) como el verdadero "monitoreo activo de entropía", con **bloqueo** de la derivación ante degradación.
3. Especificó la **derivación por KDF** que une la fuente con la `KeyGen` determinística (Cap. 4), y la **rotación con secrecia hacia adelante** disparada por política, con auditoría e identidad de cuenta estable.
4. Unificó los Objetivos 2 y 3 en una **tubería única** de gestión de claves.
5. Evaluó la política de reexpansión por firma (§5.6), con sobrecosto histórico aproximado de 0,75 ms en H1 y 0,12 ms en H2. R5 define la integral de residencia para regiones declaradas y sus hipótesis de observación. La semilla conserva la capacidad de firma; las pruebas de software no demuestran borrado físico ni menor riesgo de compromiso.

El Objetivo 3 cuenta con monitor, recuperación, rotación efectiva y registro local autenticado comprobados en el gestor del prototipo. El cierre de las garantías de despliegue exige vincular y calificar la fuente (§5.3), integrar la custodia durable y validar la política de épocas en el sequencer y su anclaje externo (§5.8). Las pruebas de software no sustituyen una demostración de secrecia hacia adelante ni una comprobación del borrado de todas las copias del secreto.

---

## Referencias del capítulo

> *Índice local del capítulo; la **Bibliografía** consolidada al final del documento reúne todas las obras bajo clave única.*

- M. S. Turan et al. *NIST SP 800-90B: Recommendation for the Entropy Sources Used for Random Bit Generation*. NIST, 2018.
- NIST. *SP 800-90A/C: Deterministic Random Bit Generators / RBG Constructions*.
- H. Krawczyk. *Cryptographic Extraction and Key Derivation: The HKDF Scheme*. CRYPTO 2010 (RFC 5869).
- NIST. *SP 800-108: Recommendation for Key Derivation Using Pseudorandom Functions*.
- NIST. *FIPS 204: ML-DSA* (KeyGen determinística desde semilla; §3.6.3 permite almacenar solo la semilla). 2024.
- [RFC9881] J. Massimo, P. Kampanakis, S. Turner, B. Westerbaan. *RFC 9881: Internet X.509 PKI — Algorithm Identifiers for ML-DSA* (la semilla como formato recomendado de clave privada). IETF, 2025.
- [Connolly26] D. Connolly. *ML-DSA Security Considerations*. draft-connolly-cfrg-ml-dsa-security-considerations, IETF (borrador), 2026.
- [BRS22] J. W. Bos, J. Renes, A. Sprenkels. *Dilithium for Memory Constrained Devices*. AFRICACRYPT 2022.
- [ADP18] M. R. Albrecht, A. Deo, K. G. Paterson. *Cold Boot Attacks on Ring and Module LWE Keys Under the NTT*. IACR TCHES, 2018.
- [Sawa25] Y. Sawa et al. *Analysis of Encryption Key Zeroization from a System-Wide Perspective*. ACSAC 2025.
