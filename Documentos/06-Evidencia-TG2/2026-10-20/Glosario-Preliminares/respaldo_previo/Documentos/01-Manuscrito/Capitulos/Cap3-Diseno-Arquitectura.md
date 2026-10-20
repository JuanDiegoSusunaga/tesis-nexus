# Capítulo 3 — Diseño de la Arquitectura Dual-Chain

*Objetivo 1 · el capítulo "espina": Costo → Respuesta → Coherencia*

> **Alcance del capítulo.** Se presenta el costo de las firmas post-cuánticas y la arquitectura dual-chain propuesta para distribuirlo entre ejecución y anclaje. La capa de pruebas debe satisfacer el modelo de amenaza considerado. Los cálculos de sobrecosto y amortización se relacionan con el análisis de complejidad y sensibilidad de las secciones 6.5–6.6.

---

## 3.1 Introducción

Una arquitectura blockchain post-cuántica debe considerar tanto la seguridad de la autenticación como su costo. Las firmas ML-DSA-65 estudiadas ocupan aproximadamente 52 veces los bytes de la firma ECDSA de referencia. En un modelo limitado exclusivamente por datos, ese aumento reduce el número de operaciones que caben en un bloque (sección 3.3); no determina por sí solo el rendimiento de un sistema completo.

La arquitectura dual-chain es la respuesta de diseño estudiada para distribuir el sobrecosto de firmas poscuánticas entre ejecución y anclaje. Su amortización se modela bajo condiciones de disponibilidad de datos, prueba de la lógica pertinente y costo del probador (sección 6.6.5). La validación distingue esa propuesta de una implementación integral y exige una capa de pruebas cuya seguridad se justifique para el modelo de amenaza considerado.

El capítulo desarrolla el Objetivo 1: especifica los roles de la **Anchor Layer (L1)** y la **Active Layer (L2)**, el camino de la firma post-cuántica a través del sistema, y los componentes clave (Nexus Sequencer, Nitro Verifier), integrando la evidencia de que las cadenas líderes (Ethereum, Solana) convergen hacia el mismo diseño.

---

## 3.2 Visión general de la arquitectura

NEXUS separa **anclaje y confirmación del estado** de **ejecución** en dos capas:

- **Anchor Layer (L1) — la capa de anclaje.** Provee consenso, finalidad irreversible y disponibilidad de datos. Es la raíz de confianza: lenta pero segura. Almacena los compromisos de estado del L2 y garantiza que los datos necesarios estén disponibles.
- **Active Layer (L2) — la capa activa.** Ejecuta transacciones a alta velocidad: secuencia, verifica firmas Dilithium, aplica transiciones de estado, agrupa en *batches* y produce una prueba de validez que asienta en L1.

### El camino de la firma post-cuántica

El elemento que estructura el diseño es **el recorrido de una firma Dilithium a través del sistema**:

**Figura 3.1 — Recorrido propuesto de una operación firmada en NEXUS.**

![El usuario firma una operación; L2 verifica, ejecuta, agrupa y genera una prueba; L1 verifica la prueba, ancla el estado y alcanza finalidad.](../Figuras/figura-3-1-arquitectura.png){width=6.5in}

*Fuente: elaboración propia. Arquitectura de referencia: la aritmetización completa de ML-DSA, la disponibilidad de datos y el consenso operativo no quedan implementados por la PoC STARK (sección 3.5 y sección 6.7). El diagrama muestra el flujo de autenticación y anclaje; la política de disponibilidad de datos se especifica por separado.*

En el diseño propuesto, la firma de 3,3 KB se verifica **en el L2** y esa verificación se incorpora a una prueba de validez; L1 recibe la prueba y el compromiso de estado. Esta separación es el mecanismo de amortización modelado en la sección 3.4. Su realización completa exige la aritmetización y la política de disponibilidad de datos indicadas en la nota de la figura.

> **Validación externa.** La hoja de ruta *rollup-centric* de Ethereum adopta exactamente esta separación (L1 = liquidación + DA; ejecución en L2), lo que respalda la elección arquitectónica como consenso de diseño de la industria.

---

## 3.3 El sobrecosto de la criptografía post-cuántica

El costo de la PQC incluye datos y cómputo. El recurso limitante depende de la carga y de la implementación; las comparaciones siguientes no establecen un cuello de botella universal.

**Tabla 3.1 — ECDSA P-256 vs. Dilithium3.** *(El cociente exacto 3 309/64 ≈ 52× se redondea a ~50× en el texto narrativo; ambas cifras designan el mismo dato.)*

| Magnitud | ECDSA P-256 | Dilithium3 | Razón | Implicación |
|---|---:|---:|---:|:---:|
| Firma | 64 B | 3 309 B | ~52× | Aumentan los datos |
| Clave pública | 33 B | 1 952 B | ~59× | Aumentan los datos |
| Verificación CPU (H2) | 144,8 µs | 77,6 µs | ~0,54× (tiempo) | Depende de la carga |

Las latencias CPU corresponden a la serie histórica H2 de la Tabla 6.8; no son medidas del sistema completo.

**Resultado de la comparación.** El incremento de bytes motiva estudiar la cantidad de datos de autenticación publicada en L1. Las verificaciones de la serie histórica H2 son del mismo orden de magnitud, pero no tienen el mismo costo ni permiten descartar CPU, generación de pruebas u otras operaciones como recursos limitantes. La procedencia y las restricciones de esas mediciones se detallan en la sección 6.6.

**Impacto en una cadena única.** Modelando una transacción como carga útil base $b$ más la firma, y un presupuesto de datos por bloque $B_d$, el throughput es $\mathrm{TPS}=B_d/(\tau(b+s))$. Con $b\approx100$ B, $B_d=1$ MB, $\tau=12$ s:

$$
\frac{\mathrm{TPS}_{\text{ECDSA}}}{\mathrm{TPS}_{\text{Dilithium}}} = \frac{b+s_q}{b+s_c} = \frac{3409}{164} \approx 20{,}8\times.
$$

Es decir, **adoptar PQC de forma ingenua cuesta ~20× de throughput** (la firma es el ~97 % de los bytes de la transacción), y la componente de firmas del libro mayor crece ~50× más rápido. *(Derivación completa y análisis de sensibilidad: documento `Analisis-Overhead`, sección 2.)*

---

## 3.4 La amortización dual-chain

El modelo de rollup ejecuta $M$ operaciones en L2 y publica en L1 un compromiso $C$, una prueba de tamaño $\pi(M)$ y los datos exigidos por la política de disponibilidad. La prueba debe autenticar la verificación de firmas y la lógica ejecutada; el AIR ilustrativo actual no implementa ese flujo completo.

**Notación del lote.** En este modelo, la letra *M* indica cuántas operaciones se agrupan en un lote. No es un identificador de una demostración o de un módulo. En el análisis de muestreo del capítulo 6 se reutiliza esa letra para contar parejas de posiciones; ese significado se define allí y no debe confundirse con el tamaño del lote.

> Una prueba de validez puede sustituir la verificación directa de las firmas en L1. Omitir además sus bytes de la publicación depende de que la política de disponibilidad y reconstrucción no los exija allí. La prueba no elimina las obligaciones de almacenar y distribuir los datos necesarios.

En un escenario donde la disponibilidad publicada se representa mediante $d$ bytes de diferencia de estado por operación, y el compromiso y los metadatos fijos ocupan $c$ bytes, el costo de datos de anclaje por operación es

$$
F(M) = d + \frac{c+\pi(M)}{M}.
$$

El límite $F(M)\to d$ requiere $\pi(M)/M\to0$, es decir, crecimiento sublineal del tamaño de prueba. Con una prueba fija es inmediato; no se presume para una familia arbitraria de pruebas. Si la política exige publicar además una firma de $s_q$ bytes por operación, el costo de ese escenario es $F(M)+s_q$, y su límite conserva ese sumando. La independencia de $d$ respecto del esquema es una hipótesis de este modelo de publicación.

**Ejemplo aritmético.** Con $d=40$ B, $c=32$ B y una prueba fija supuesta de 100.000 B, el modelo da 140,032 B por operación para $M=1000$ y 50,0032 B para $M=10000$. Frente a la referencia de 3409 B por operación, el equilibrio $F(M)\leq3409$ exige $M\geq30$; aproximarse a $d$ con un sobrecosto de a lo sumo el 10 % exige $M\geq25008$. Son umbrales distintos. Estas cifras describen el escenario supuesto, no los tamaños medidos del PoC ni un ahorro demostrado para transacciones ML-DSA completas.

**En la dimensión de cómputo**, se verifica una prueba por lote, pero su tiempo $t_\pi(M)$ puede crecer con $M$. El costo por operación es $t_\pi(M)/M$; solo tiende a cero si ese tiempo es sublineal. El costo del probador y la espera para formar el lote también deben contabilizarse (sección 6.6.5).

> **Conclusión de diseño.** El costo por operación puede distribuirse entre el lote y sus diferencias de estado bajo el modelo de disponibilidad y publicación adoptado. Las firmas siguen teniendo costo de almacenamiento, transmisión y verificación en la frontera que las conserva. El modelo no elimina esos costos ni mide por sí solo el rendimiento de una blockchain completa (sección 6.6.5).

---

## 3.5 Coherencia post-cuántica de la capa de pruebas

El diseño requiere que los compromisos y el sistema de pruebas sean compatibles con su modelo de amenaza. Los argumentos basados en emparejamientos y logaritmos discretos, como Groth16 sobre curvas clásicas, incorporan supuestos vulnerables a un adversario cuántico suficientemente potente. NEXUS explora una construcción basada en hash y FRI; su ausencia de emparejamientos evita esa dependencia particular, pero no demuestra solidez QROM de la construcción completa.

**Tabla 3.2 — Supuestos de las familias de prueba.**

| Familia | Dependencia principal | Condición de validación |
|---|---|---|
| Groth16 sobre curvas clásicas | Emparejamientos y logaritmo discreto | No satisface el modelo frente a Shor con recursos suficientes |
| Argumentos basados en hash y FRI | Compromisos, proximidad y compilación Fiat–Shamir | Requieren prueba de composición, parámetros y modelo ROM/QROM |

**Prototipo y alcance del verificador.** El prototipo usa el campo Goldilocks, NTT, Merkle sobre SHA3-256, retos de extensión y FRI para una recurrencia ilustrativa. La ruta activa de validez exige dos recorridos FRI, de traza y composición, con raíz compartida entre traza y AIR, lectura canónica y perfil externo. El verificador básico se conserva para reproducir los contraejemplos y límites auditados (secciones 6.7.1–6.7.4); no habilita la aceptación de esa ruta activa.

`ActiveChain` suministra el contexto mediante instantáneas privadas de los lotes construidos localmente. Comprueba el certificado antes de registrar un envío de validez o híbrido, rechaza metadatos alterados y evita registrar dos envíos del mismo índice. La raíz inicial se captura antes de ejecutar y los lotes se separan entre bloques completos. Estos controles son locales en memoria; no demuestran consenso persistente ni antirrepetición entre reinicios. El modo optimista mantiene su aceptación provisional separada.

El motor de transacciones produce raíces SHA3 generales, mientras el AIR solo admite escalares canónicos. Los lotes fuera de ese dominio se rechazan sin truncar hashes ni fabricar una prueba de recurrencia para presentarla como prueba de transacciones. La conexión de la API está implementada, pero la validez de una aplicación completa requiere aritmetizar sus reglas y vincular íntegramente sus raíces. Los casos positivos escalares de integración son ensayos sintéticos, no validaciones de transacciones L2.

**Presupuesto de seguridad.** No se acredita una garantía de aproximadamente 100 bits: el campo de extensión no basta para cerrar composición y consultas, y el trabajo del nonce no impide reinicios de transcripción. La cota de la sección 6.7.9 incorpora trabajo y presupuesto adversario en el modelo ROM clásico; no demuestra seguridad del ejecutable, conocimiento cero ni transferencia cuántica completa.

**Tabla 3.3 — Mediciones históricas del AIR ilustrativo.**

| Filas de traza | Tamaño histórico (KB decimales, redondeado) | Verificación histórica |
|---:|---:|---:|
| 16 | 132 KB | 6,0 ms |
| 256 | 268 KB | 8,9 ms |
| 4096 | 445 KB | 12,9 ms |

Estas cifras pertenecen a la serie histórica y a una carga ilustrativa. Los tamaños se expresan en KB decimales (1000 B), con cifras históricas redondeadas; las Tablas 6.9 y 6.12 distinguen KiB (1024 B). La coincidencia de magnitudes tras convertir unidades no identifica la misma corrida ni igualdad de bytes de las pruebas. Filas AIR no equivalen a transacciones ML-DSA. Las nuevas mediciones preservan repeticiones y dispersión (sección 6.6), y las diferencias de procedencia se conservan explícitas. El costo del probador, incluido el trabajo del nonce, forma parte del balance de viabilidad; una curva de verificación no certifica seguridad ni el flujo L2/L1 completo.

Las propuestas poscuánticas de Ethereum y Solana aportan contexto sobre tamaño de firmas y agregación. Sus hojas de ruta no sustituyen la validación de NEXUS ni se presentan como despliegue completo de la arquitectura de esta tesis [EthRoadmap26, Solana-QR26].

### 3.5.1 Una tensión de diseño honesta: Dilithium vs. STARK-friendliness

La tensión técnica es el costo de aritmetizar ML-DSA dentro de un sistema de pruebas. NEXUS selecciona ML-DSA como esquema de firma por su estandarización y por la API semillada del backend, mientras estudia separadamente la agregación por pruebas. El AIR actual no verifica firmas ML-DSA: medirlo no resuelve el costo de esa aritmetización. Las propuestas externas de firmas hash-based o Falcon ilustran alternativas de diseño, con supuestos y costos propios.

---

## 3.6 Modelo de cuenta: identidad estable vs. clave rotable

Un sistema que **rota** y **migra** claves (Cap. 5, cripto-agilidad) enfrenta un problema: si la dirección se deriva de la clave pública, rotar la clave **cambia la dirección/identidad**. NEXUS lo resuelve con **abstracción de verificación**:

$$
\textbf{Cuenta} = (\ \text{id\_estable},\ \ \text{política\_de\_verificación},\ \ \text{epoch}\ ).
$$

- La **id_estable** identifica la cuenta de forma permanente (no cambia con la clave).
- La **política_de_verificación** especifica el esquema de firma y la clave pública actuales; una transacción se valida ejecutando esta política.
- El **epoch** registra la versión de clave (rotación/migración).

Rotar o migrar de esquema actualiza la **política** y el **epoch**, **sin tocar la id_estable**. Un **Registro de Claves (Key Registry)** permite asociar claves post-cuánticas junto a las clásicas, habilitando **firmas híbridas** durante la transición y la **migración por cuenta**.

> **Referencia de diseño.** La abstracción de cuentas permite separar identidad de política de verificación. Las propuestas de agilidad de firmas y registros poscuánticos de Ethereum son antecedentes de esa separación [Eth-PQ26]. En NEXUS, R3 comprueba un registro local y firmas por época; su integración con el sequencer y el anclaje L1 sigue pendiente (sección 5.8).

---

## 3.7 Disponibilidad de datos

La L1 debe garantizar que los datos del L2 (necesarios para reconstruir/auditar el estado) estén **disponibles**, sin almacenarlos permanentemente. *(Diseño de referencia; la DA —erasure coding y muestreo— no está implementada operativamente, sino especificada como modelo. Cf. sección 3.10 y Cap. 7.)* El diseño prevé:

- **Erasure coding real** (Reed-Solomon u otro código MDS) para redundancia con umbral de recuperación genuino (no duplicación de *chunks*).
- **Muestreo de disponibilidad (DAS)** entre **pares**: los nodos verifican la disponibilidad muestreando fragmentos distribuidos en la red, no consultando su propia memoria. La probabilidad de detección de retención es estadísticamente significativa solo si el muestreo es **remoto**.
- **Poda** de los datos tras una ventana (estilo *blob*), de modo que las firmas (50× mayores) **no se acumulan** indefinidamente en la L1.

> **Validación externa (ya en producción).** Ethereum activó **Fusaka/PeerDAS en mainnet el 3-dic-2025**: muestreo de disponibilidad que reduce ~85 % la descarga de los validadores, con blobs efímeros y podables. NEXUS modela su DA sobre este diseño desplegado. La **ZK Compression** de Solana ofrece además un mecanismo para comprimir el estado (claves públicas grandes) con pruebas de validez. Esto corrige y sustituye el "DAS" del prototipo original (que muestreaba su propia RAM).

---

## 3.8 Secuenciación e incentivos

El **Nexus Sequencer** ordena las transacciones del L2. Un secuenciador único concentra poder de censura y de extracción de valor (MEV). El diseño contempla dos mitigaciones, ambas con respaldo en la frontera:

- **Separación proponente/constructor (PBS):** separar *quién ordena* de *quién construye* el bloque, para limitar el MEV — el enfoque del **PBS enshrined (ePBS)** de Ethereum.
- **Secuenciadores concurrentes:** múltiples productores concurrentes, como los **Multiple Concurrent Leaders (MCL)** de Solana, que reducen el poder de un único líder.

**Modelo de incentivos.** Para un jugador $i$, sean $r_i$ la recompensa honesta, $c_i$ su costo, $g_i$ la ganancia de desviarse, $p_i$ la probabilidad de detección y $D_i$ el depósito perdido al detectarse la desviación. En el juego de referencia, las utilidades son $r_i-c_i$ y $g_i-p_iD_i$. El perfil honesto es equilibrio de Nash si y solo si $g_i-p_iD_i\leq r_i-c_i$ para cada jugador. El depósito por sí solo no demuestra esa desigualdad; deben justificarse pagos, detección y reglas del mecanismo. El modelo condicional está formalizado, pero no acredita el equilibrio del secuenciador desplegado.

La concurrencia introduce varios productores, pero no determina un umbral universal de colusión para censura o MEV. Ese resultado depende de las reglas de inclusión, la comunicación y el modelo de coaliciones. El mecanismo operativo de incentivos y slashing permanece como diseño de referencia.

---

## 3.9 Finalidad

El diseño busca finalidad determinista para confirmar operaciones y mantener registros consistentes. El **Finality Gadget** de referencia exige un quórum de peso estrictamente mayor que $2/3$, verificación de firmas y enlace de ascendencia. Con peso bizantino menor que $1/3$, dos quórums de ese tamaño tienen intersección honesta. Para excluir certificados incompatibles se requiere además que los participantes honestos respeten las reglas de voto y bloqueo del protocolo; el lema de intersección no demuestra por sí solo seguridad y vivacidad del consenso. Su implementación operativa permanece como trabajo futuro (sección 3.10).

> **Validación externa y diseño a contrastar.** Solana **Alpenglow** (Votor + Rotor; testnet may-2026, mainnet ~finales 2026) reduce la finalidad de 12,8 s a **100–150 ms**: **Votor** finaliza en **una ronda** con ≥80 % del *stake* en línea (~100 ms) y en dos rondas al 60 % (~150 ms). Ethereum persigue **finalidad de un solo paso (SSF)** y ~4 s en Lean Consensus. NEXUS adopta como requisito una **finalidad determinista rápida** y contrasta su gadget con el diseño de Votor (quórum por *stake*, finalidad en 1–2 rondas), coherente con las correcciones del consenso (quórum ponderado por *stake* + verificación de votos).

---

## 3.10 Síntesis y supuesto de consenso

El diseño dual-chain de NEXUS responde, pieza por pieza, al problema que la PQC plantea:

1. La firma de referencia introduce aproximadamente 52 veces los bytes de ECDSA; el modelo limitado por datos estima una razón de throughput de 20,8 bajo sus parámetros (sección 3.3).
2. La amortización tiende a $d$ si la prueba crece sublinealmente y la política de disponibilidad admite el presupuesto de publicación supuesto (sección 3.4).
3. La capa de pruebas requiere garantías compatibles con la amenaza cuántica. NEXUS estudia hash y FRI, con transferencia QROM completa pendiente y la aritmetización de ML-DSA aún no realizada (sección 3.5).
4. La **abstracción de cuenta + Key Registry** resuelve identidad-vs-clave y habilita migración — sección 3.6.
5. La **DA estilo PeerDAS** y la **secuenciación con incentivos** y la **finalidad rápida** completan la arquitectura — secciones 3.7–3.9.

> **Supuestos y límite de composición.** La integridad del libro mayor requiere garantías propias de firmas, autorización, transiciones y consenso. El diseño de quórums supone menos de $1/3$ de peso bizantino y certificados de peso mayor que $2/3$, junto con las reglas de voto, bloqueo y comunicación del protocolo; una mayoría honesta simple no basta. La inforjabilidad del esquema de firma y la seguridad del consenso son propiedades distintas. NEXUS no deduce una garantía del sistema completo de esos supuestos ni del lema de intersección: la integración del consenso, la disponibilidad de datos y la lógica completa de la capa de pruebas permanece como trabajo futuro (Cap. 7).

Con ello, el **Objetivo 1 queda atendido**: la arquitectura dual-chain está especificada como modelo de referencia, con su rol —amortizar el sobrecosto post-cuántico manteniendo coherencia PQ— justificado cuantitativamente y contextualizado por propuestas externas y sujeto a la validación.

---

## Referencias del capítulo

> *Índice local del capítulo; la **Bibliografía** consolidada al final del documento reúne todas las obras bajo clave única.*

- [Buterin21] V. Buterin. *An Incomplete Guide to Rollups*. 2021.
- Ethereum Foundation. *Fusaka Mainnet Announcement* (PeerDAS, EIP-7594). Nov. 2025. · ethereum.org/roadmap (Account abstraction EIP-7702; Quantum resistance / Lean Consensus, EIP-8141).
- Anza. *Alpenglow* (Votor/Rotor). 2025–2026. · Solana. *Quantum Readiness* (Falcon; Winternitz Vault). 2026.
