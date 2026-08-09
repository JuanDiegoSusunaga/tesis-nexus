# Capítulo 3 — Diseño de la Arquitectura Dual-Chain

### (Objetivo 1 · el capítulo "espina": Costo → Respuesta → Coherencia)

> **Rol en el arco de la tesis.** Este capítulo es la articulación central: toma la **solución** (firmas post-cuánticas, Cap. 4), expone el **costo** que introducen, y muestra que la **arquitectura dual-chain** es la *respuesta* a ese costo, exigiendo además **coherencia post-cuántica** en su capa de verificación. El análisis cuantitativo detallado vive en el documento companion `Analisis-Overhead-PQC-DualChain`; aquí se integra con el diseño arquitectónico completo.

---

## 3.1 Introducción

Una blockchain bancaria post-cuántica enfrenta una tensión que este capítulo resuelve. Por un lado, **debe** usar firmas post-cuánticas (Dilithium) para resistir la amenaza cuántica a la autenticación de transacciones (Cap. 1, Cap. 6). Por otro, esas firmas son **~50× más grandes** que las clásicas, lo que —aplicado de forma ingenua sobre una cadena única— degrada el rendimiento en un orden de magnitud.

La tesis de este capítulo es que **la arquitectura dual-chain no es un complemento opcional, sino la respuesta directa a ese sobrecosto**: al ejecutar y verificar las firmas en una capa L2 y publicar en L1 solo un compromiso respaldado por una prueba, el costo on-chain por transacción post-cuántica se amortiza hasta el de su diferencia de estado clásica. Como corolario, **la capa de verificación del L2 debe ser ella misma post-cuántica**, lo que determina decisiones concretas de diseño (§3.5).

El capítulo desarrolla el Objetivo 1: especifica los roles de la **Anchor Layer (L1)** y la **Active Layer (L2)**, el camino de la firma post-cuántica a través del sistema, y los componentes clave (Nexus Sequencer, Nitro Verifier), integrando la evidencia de que las cadenas líderes (Ethereum, Solana) convergen hacia el mismo diseño.

---

## 3.2 Visión general de la arquitectura

NEXUS separa **liquidación** de **ejecución** en dos capas:

- **Anchor Layer (L1) — la capa de anclaje.** Provee consenso, finalidad irreversible y disponibilidad de datos. Es la raíz de confianza: lenta pero segura. Almacena los compromisos de estado del L2 y garantiza que los datos necesarios estén disponibles.
- **Active Layer (L2) — la capa activa.** Ejecuta transacciones a alta velocidad: secuencia, verifica firmas Dilithium, aplica transiciones de estado, agrupa en *batches* y produce una prueba de validez que asienta en L1.

### El camino de la firma post-cuántica

El elemento que estructura el diseño es **el recorrido de una firma Dilithium a través del sistema**:

```
  Usuario           Active Layer (L2)                          Anchor Layer (L1)
 ┌───────┐   ┌──────────────────────────────────┐   ┌───────────────────────────────┐
 │ firma │──▶│ Sequencer ─▶ Ejecución ─▶ Batch + │──▶│ Verifica 1 prueba ─▶ Compromiso│
 │ tx PQC│   │ (verifica   (transición  prueba   │   │ de estado + DA ─▶ Finalidad    │
 └───────┘   │  Dilithium)  de estado)  STARK)   │   │ (las firmas NO suben a L1)     │
             └──────────────────────────────────┘   └───────────────────────────────┘
```

La firma de 3,3 KB se verifica **una vez en el L2** y se **prueba** de forma sucinta; **no viaja a la L1**. Este es el mecanismo que amortiza el sobrecosto (§3.4) y la razón por la que el dual-chain es la respuesta correcta.

> **Validación externa.** La hoja de ruta *rollup-centric* de Ethereum adopta exactamente esta separación (L1 = liquidación + DA; ejecución en L2), lo que respalda la elección arquitectónica como consenso de diseño de la industria.

---

## 3.3 El sobrecosto de la criptografía post-cuántica

El costo de la PQC tiene **dos dimensiones**, y solo una es el cuello de botella.

**Tabla 3.1 — ECDSA P-256 vs. Dilithium3.** *(El cociente exacto 3 309/64 ≈ 52× se redondea a ~50× en el texto narrativo; ambas cifras designan el mismo dato.)*

| Magnitud | ECDSA P-256 | Dilithium3 | Razón | ¿Cuello de botella? |
|---|---:|---:|---:|:---:|
| Firma | 64 B | 3 309 B | ~52× | **Sí (datos)** |
| Clave pública | 33 B | 1 952 B | ~59× | **Sí (datos)** |
| Verificación (CPU) | decenas de µs | ~0,17–0,44 ms (medido) | ~1× (mismo orden, sub-ms) | No |

**Hallazgo central:** el penalizador post-cuántico es de **tamaño** (ancho de banda, almacenamiento, disponibilidad de datos), **no de cómputo** —verificar Dilithium cuesta lo mismo que ECDSA—. Por tanto, lo que hay que optimizar es **la cantidad de datos de autenticación que tocan la L1**, que es precisamente la función de un rollup.

**Impacto en una cadena única.** Modelando una transacción como carga útil base $b$ más la firma, y un presupuesto de datos por bloque $B_d$, el throughput es $\mathrm{TPS}=B_d/(\tau(b+s))$. Con $b\approx100$ B, $B_d=1$ MB, $\tau=12$ s:

$$\frac{\mathrm{TPS}_{\text{ECDSA}}}{\mathrm{TPS}_{\text{Dilithium}}} = \frac{b+s_q}{b+s_c} = \frac{3409}{164} \approx 20{,}8\times.$$

Es decir, **adoptar PQC de forma ingenua cuesta ~20× de throughput** (la firma es el ~97 % de los bytes de la transacción), y la componente de firmas del libro mayor crece ~50× más rápido. *(Derivación completa y análisis de sensibilidad: documento `Analisis-Overhead`, §2.)*

---

## 3.4 La amortización dual-chain

El rollup ejecuta $M$ transacciones fuera de cadena y publica en L1 solo un compromiso $C$, una prueba $\pi$ y los datos de disponibilidad $D$. La observación crucial:

> Si una **prueba de validez** atestigua sucintamente que las $M$ transacciones estaban correctamente firmadas (Dilithium) y ejecutadas, **las firmas no necesitan publicarse en L1**. El sobrecosto de 50× se paga una vez fuera de cadena y se **elimina** de la L1.

El costo on-chain por transacción es entonces
$$F(M) = d + \frac{C+\pi}{M} \xrightarrow{\ M\to\infty\ } d,$$
donde $d$ es la **diferencia de estado** por transacción —**independiente del esquema de firma**—. El factor $s_q$ **desaparece** del costo on-chain. Con valores modelados ($d\approx40$ B), un rollup de validez reduce el costo por transacción post-cuántica de 3 409 B a $\sim$40–140 B (reducción **~24–85×**), con punto de equilibrio en lotes de $\sim$10⁴ transacciones (§3.5).

**En la dimensión de cómputo**, la L1 verifica **una** prueba por *batch* (independiente de $M$) en lugar de $M$ firmas, reduciendo el cómputo de verificación on-chain a $\sim$0 por transacción. Como el costo de verificar Dilithium ya es bajo (§3.3), este ahorro es secundario frente al de datos.

> **Conclusión de diseño.** El dual-chain lleva el costo amortizado on-chain de una transacción post-cuántica al de su diferencia de estado clásica: **el tamaño de la firma se vuelve irrelevante para la L1.**

---

## 3.5 Coherencia post-cuántica del verificador (decisión de diseño crítica)

La amortización de §3.4 depende de una prueba de validez. Aquí aparece una **inconsistencia latente** que el diseño debe resolver:

> Si la prueba que la L1 verifica usa **Groth16 sobre BN254** (basado en emparejamientos / logaritmo discreto), **Shor la rompe**. Un adversario cuántico podría falsificar la prueba que atestigua las transacciones, y la L1 la aceptaría — reintroduciendo la vulnerabilidad cuántica en la capa de verificación, justo la que el sistema pretende eliminar.

**Decisión:** el verificador (el "Nitro Verifier") debe usar un **sistema de pruebas post-cuántico** —un **STARK** (hash + FRI) o un SNARK reticular—, no Groth16.

**Tabla 3.2 — Sistemas de prueba.**

| Sistema | Base de seguridad | ¿Post-cuántico? | $\pi$ | Equilibrio de lotes |
|---|---|:---:|---:|---:|
| Groth16 (emparejamientos) | log. discreto en curvas | No (Shor) | ~200 B | ~10² tx |
| **STARK** (hash + FRI) | resistencia de colisión | Sí | ~10²–10³ KB | ~10⁴ tx |

El precio de la coherencia PQ es una prueba mayor → un equilibrio de lotes mayor (~10⁴ tx), perfectamente alcanzable. Esto convierte al Nitro Verifier de adorno opcional en **componente arquitectónico necesario y justificado**.

> **Prototipo de referencia implementado (PoC).** Para sustanciar esta decisión más allá del diseño, se implementó en el repositorio (`nexus-zk::stark`, cableado en `nexus-active::pq_verifier`) un **STARK hash-based propio** que materializa el **motor criptográfico post-cuántico** del Nitro Verifier (no su aritmetización completa): campo de Goldilocks ($p=2^{64}-2^{32}+1$), codificación Reed–Solomon vía **NTT**, compromisos de **Merkle sobre SHA3-256** con separación de dominio hoja/nodo, no interactividad por **Fiat–Shamir** y prueba de bajo grado **FRI**. Una transición de estado se aritmetiza (frontera + transición → polinomio de composición) y su validez se reduce a una afirmación de bajo grado que FRI certifica, atando la traza al compromiso en la fase de consulta. **Ninguna primitiva usa emparejamientos ni curvas elípticas** —solo hash y aritmética de campo—, de modo que **Shor no aplica**, a diferencia del andamiaje Groth16/BN254 que reemplaza.
>
> **Endurecimiento (soundness ~100 bits).** Los desafíos del verificador (combinación `α`, plegado `β`) se extraen del **campo de extensión** $F_{p^2}\ (\approx 2^{128})$ —no del campo base de 64 bits—, lo que eleva los términos de soundness de la combinación de restricciones y del plegado FRI ($\sim\!\text{grado}/|F|$) por encima de $2^{-100}$; esto es **estructural** (en el campo base el techo caería a ~40 bits para trazas grandes, sin importar el número de consultas). Se añade **grinding** (proof-of-work de 20 bits en Fiat–Shamir, que anula el re-muestreo de la transcripción) y **40 consultas distintas** —muestreadas *sin reemplazo* (una consulta repetida no aporta soundness); las 40 se alcanzan para $T\ge 16$, que cubre todos los tamaños medidos— a *rate* $\rho=1/4$. Presupuesto: $\varepsilon \le \underbrace{2^{-107}}_{\alpha,\ F_{p^2}} + \underbrace{2^{-100}}_{\beta,\ \text{plegado}} + \underbrace{2^{-(80+20)}}_{\text{consulta}+\text{grind}} \approx 2^{-100}$, con tres salvedades que se enuncian con franqueza: (i) el término de consulta (80 bits) usa la convención de *proximity gaps* [BSCIKS20] (2 bits/consulta), **conjetural**; la cota **incondicional provable** por decodificación única da ~47 bits en esa fase, cerrable con DEEP (trabajo futuro); (ii) la cifra corresponde a la **configuración de producción** (build *release*, grinding de 20 bits); (iii) el **techo del campo** ($\varepsilon_\alpha,\varepsilon_\beta$ en $F_{p^2}$) es **>100 bits de forma provable e incondicional** —es lo que el campo base de 64 bits no permitía (su techo caía a ~40 bits)—. Mediciones (portátil modesto, Rust puro, $F_{p^2}$, *blowup* 8, 40 consultas, grinding $2^{20}$):
>
> | Pasos de traza | Tamaño de prueba | Generar | **Verificar** |
> |---:|---:|---:|---:|
> | 16 | 132 KB | — | 6,0 ms |
> | 256 | 268 KB | — | 8,9 ms |
> | 4096 | 445 KB | — | **12,9 ms** |
>
> El resultado central es la **verificación sucinta**: al multiplicar el cómputo por **256×** (16→4096 pasos), el tiempo de verificación crece solo **~2,2×** (polilogarítmico), mientras el tamaño de prueba crece sub-linealmente. Es justo la propiedad que la L1 necesita: verificar un lote L2 grande con costo casi constante, sin curvas rotas por Shor. *(El tiempo de **generación** está dominado por el grinding —coste fijo $\sim 2^{20}$ hashes— y por la NTT del probador; no es la magnitud relevante para la L1.)* La aritmetización **completa** de la máquina de estado bancaria (el AIR del PoC es ilustrativo) y la incorporación de DEEP/out-of-domain quedan como trabajo futuro (Cap. 7); el **motor criptográfico post-cuántico**, que es lo que porta la afirmación de coherencia, está implementado, **endurecido a ~100 bits** y verificado por una batería de pruebas (incluida una adversarial que rechaza un probador con composición de bajo grado desligada de la traza).

> **Validación externa contundente.** La hoja de ruta de consenso de Ethereum ("Lean Consensus", antes *Beam Chain*) llega a la **misma conclusión**: reemplaza BLS por firmas hash-based (leanXMSS), que pesan 20–40× más y carecen de agregación nativa, y lo resuelve con **`leanVM`, un zkVM que comprime las firmas ~250× con agregación SNARK post-cuántica**; ethereum.org afirma explícitamente que *«los STARKs ya son resistentes a la cuántica»* y que los compromisos KZG deberán migrar a STARK/reticular. El principio de NEXUS —*el sistema de pruebas debe ser PQ*— es el mismo que adopta la frontera.

### 3.5.1 Una tensión de diseño honesta: Dilithium vs. STARK-friendliness

Conviene declarar una tensión técnica que demuestra dominio del problema. **Probar la verificación de una firma Dilithium dentro de un STARK es costoso** (operaciones reticulares, claves públicas grandes); de hecho, **Ethereum eligió firmas hash-based en parte porque son más STARK-friendly** que las reticulares, y **Solana eligió Falcon** (reticular pero de firma pequeña). La elección de NEXUS por **Dilithium** optimiza la **verificación directa** (L1, y la robustez/estandarización de la implementación) a costa de mayor fricción en la **agregación probada** (L2). No es un defecto, sino una **decisión consciente con un trade explícito**: NEXUS prioriza la robustez del primitivo y reconoce la agregación STARK de firmas reticulares como el reto de ingeniería a resolver. La divergencia **Ethereum (hash-based) / Solana (Falcon) / NEXUS (Dilithium)** evidencia que **no existe una respuesta única** — y que la elección debe justificarse, como aquí.

---

## 3.6 Modelo de cuenta: identidad estable vs. clave rotable

La **cripto-agilidad** es un requisito explícito del dominio, no una comodidad de ingeniería: el sector financiero la enuncia como condición de la transición post-cuántica —porque el esquema estandarizado hoy puede no ser el de 2030, con FIPS 206 aún en borrador— (Cap. 1, §1.3, **R3**). Pero un sistema que **rota** y **migra** claves (Cap. 5) enfrenta un problema: si la dirección se deriva de la clave pública, rotar la clave **cambia la dirección/identidad**. NEXUS lo resuelve con **abstracción de verificación**:

$$\textbf{Cuenta} = (\ \text{id\_estable},\ \ \text{política\_de\_verificación},\ \ \text{epoch}\ ).$$

- La **id_estable** identifica la cuenta de forma permanente (no cambia con la clave).
- La **política_de_verificación** especifica el esquema de firma y la clave pública actuales; una transacción se valida ejecutando esta política.
- El **epoch** registra la versión de clave (rotación/migración).

Rotar o migrar de esquema actualiza la **política** y el **epoch**, **sin tocar la id_estable**. Un **Registro de Claves (Key Registry)** permite asociar claves post-cuánticas junto a las clásicas, habilitando **firmas híbridas** durante la transición y la **migración por cuenta**.

> **Validación externa.** Ethereum implementa este patrón: **EIP-7702 (smart EOAs, ya live)** permite a una cuenta de dirección estable delegar su lógica de verificación; **EIP-8141 ("signature agility", fork Hegota, H2-2026)** y un **Key Registry** permiten que cada cuenta migre a un esquema PQ de forma independiente, sin hard fork global. El modelo de cuenta de NEXUS adopta este enfoque validado, cerrando el problema identidad↔clave↔rotación↔dirección.

---

## 3.7 Disponibilidad de datos

La L1 debe garantizar que los datos del L2 (necesarios para reconstruir/auditar el estado) estén **disponibles**, sin almacenarlos permanentemente. *(Diseño de referencia; la DA —erasure coding y muestreo— no está implementada operativamente, sino especificada como modelo. Cf. §3.10 y Cap. 7.)* El diseño prevé:

- **Erasure coding real** (Reed-Solomon u otro código MDS) para redundancia con umbral de recuperación genuino (no duplicación de *chunks*).
- **Muestreo de disponibilidad (DAS)** entre **pares**: los nodos verifican la disponibilidad muestreando fragmentos distribuidos en la red, no consultando su propia memoria. La probabilidad de detección de retención es estadísticamente significativa solo si el muestreo es **remoto**.
- **Poda** de los datos tras una ventana (estilo *blob*), de modo que las firmas (50× mayores) **no se acumulan** indefinidamente en la L1.

> **Validación externa (ya en producción).** Ethereum activó **Fusaka/PeerDAS en mainnet el 3-dic-2025**: muestreo de disponibilidad que reduce ~85 % la descarga de los validadores, con blobs efímeros y podables. NEXUS modela su DA sobre este diseño desplegado. La **ZK Compression** de Solana ofrece además un mecanismo para comprimir el estado (claves públicas grandes) con pruebas de validez. Esto corrige y sustituye el "DAS" del prototipo original (que muestreaba su propia RAM).

---

## 3.8 Secuenciación e incentivos

El **Nexus Sequencer** ordena las transacciones del L2. Un secuenciador único concentra poder de censura y de extracción de valor (MEV). El diseño contempla dos mitigaciones, ambas con respaldo en la frontera:

- **Separación proponente/constructor (PBS):** separar *quién ordena* de *quién construye* el bloque, para limitar el MEV — el enfoque del **PBS enshrined (ePBS)** de Ethereum.
- **Secuenciadores concurrentes:** múltiples productores concurrentes, como los **Multiple Concurrent Leaders (MCL)** de Solana, que reducen el poder de un único líder.

**Modelo de incentivos.** El comportamiento del secuenciador se modela con teoría de juegos: se **argumenta** que, bajo un modelo de pagos con *stake* y *slashing*, la estrategia honesta sería un **equilibrio de Nash** (la deshonestidad conduce a la pérdida del *stake*) — análisis de diseño, no resultado formalmente probado. Con secuenciación **concurrente**, el juego pasa de un único jugador a **N jugadores**, de modo que la censura/MEV requeriría la **colusión de la mayoría** — un argumento de robustez más fuerte que el del secuenciador único. *(El mecanismo operativo de slashing es diseño de referencia; su implementación es trabajo futuro.)*

---

## 3.9 Finalidad

La banca exige **finalidad rápida e irreversible** para la liquidación, con latencias objetivo del orden de $10^2$ ms en los sistemas de pago vigentes (Cap. 1, §1.3, **R6**). El **Finality Gadget** de la Anchor Layer se especifica para finalizar un bloque cuando el peso de voto (ponderado por *stake*) cruza el umbral de 2/3, con verificación de las firmas de voto y enlace de ascendencia entre bloques finalizados. *(Diseño de referencia; su implementación operativa es trabajo futuro, §3.10.)*

> **Validación externa y diseño a contrastar.** Solana **Alpenglow** (Votor + Rotor; testnet may-2026, mainnet ~finales 2026) reduce la finalidad de 12,8 s a **100–150 ms**: **Votor** finaliza en **una ronda** con ≥80 % del *stake* en línea (~100 ms) y en dos rondas al 60 % (~150 ms). Ethereum persigue **finalidad de un solo paso (SSF)** y ~4 s en Lean Consensus. NEXUS adopta como requisito una **finalidad determinista rápida** y contrasta su gadget con el diseño de Votor (quórum por *stake*, finalidad en 1–2 rondas), coherente con las correcciones del consenso (quórum ponderado por *stake* + verificación de votos).

---

## 3.10 Síntesis y supuesto de consenso

El diseño dual-chain de NEXUS responde, pieza por pieza, al problema que la PQC plantea:

1. La PQC introduce un sobrecosto de **datos** (~50× firma, ~20× throughput en L1) — §3.3.
2. El **rollup de validez** amortiza ese costo a $\sim d$ (la diferencia de estado clásica), eliminando las firmas de la L1 — §3.4.
3. La coherencia PQ exige un **verificador STARK**, no Groth16 — §3.5; con la tensión Dilithium-vs-STARK declarada — §3.5.1.
4. La **abstracción de cuenta + Key Registry** resuelve identidad-vs-clave y habilita migración — §3.6.
5. La **DA estilo PeerDAS** y la **secuenciación con incentivos** y la **finalidad rápida** completan la arquitectura — §3.7–3.9.

> **Supuesto explícito (para que las afirmaciones de seguridad estén bien formadas).** La integridad del libro mayor depende, además de la in-falsificabilidad de las firmas (Cap. 6), de la **seguridad del consenso**. En NEXUS el consenso BFT operativo es **diseño de referencia**, no implementación; por tanto, la garantía del sistema se enuncia condicionalmente: *in-falsificabilidad a nivel de transacción bajo el supuesto de consenso honesto-mayoritario*. La realización completa del consenso, la DA y el verificador STARK es trabajo futuro (Cap. 7).

Con ello, el **Objetivo 1 queda atendido**: la arquitectura dual-chain está especificada como modelo de referencia, con su rol —amortizar el sobrecosto post-cuántico manteniendo coherencia PQ— justificado cuantitativamente y validado por la convergencia de la industria.

---

## Referencias del capítulo

> *Índice local del capítulo; la **Bibliografía** consolidada al final del documento reúne todas las obras bajo clave única.*

- [Buterin21] V. Buterin. *An Incomplete Guide to Rollups*. 2021.
- Ethereum Foundation. *Fusaka Mainnet Announcement* (PeerDAS, EIP-7594). Nov. 2025. · ethereum.org/roadmap (Account abstraction EIP-7702; Quantum resistance / Lean Consensus, EIP-8141).
- Anza. *Alpenglow* (Votor/Rotor). 2025–2026. · Solana. *Quantum Readiness* (Falcon; Winternitz Vault). 2026.
- *(Análisis de overhead: documento companion `Analisis-Overhead-PQC-DualChain`; validación de fuentes: `Ideas-Ethereum-Solana-para-NEXUS`.)*
