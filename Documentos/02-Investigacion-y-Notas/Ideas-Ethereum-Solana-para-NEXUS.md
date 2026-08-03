# Ideas de las hojas de ruta de Ethereum y Solana aplicables a NEXUS

> **Estado:** investigación web actualizada a **junio de 2026** con fuentes citadas (ver §Fuentes). Cada punto indica si está *live*, en *testnet/spec* o en *investigación*.

**Titular.** Las dos cadenas de mayor valor están migrando a criptografía post-cuántica **ahora mismo**, y al hacerlo **chocan con el mismo problema que NEXUS formaliza (el overhead de tamaño de las firmas PQC) y lo resuelven con las mismas ideas (agregación por pruebas + STARKs post-cuánticos)**. Esto convierte a NEXUS de "idea de estudiante" en un trabajo **alineado con la frontera de la industria** — y te da validación externa citable para cada una de tus tesis centrales.

---

## 1. Validación externa directa de tus dos tesis centrales

### 1.1 Ethereum: "Lean Consensus" (antes *Beam Chain*) — post-cuántico vía hash-based + agregación SNARK

Ethereum rediseña su capa de consenso para ser post-cuántica. Datos concretos (junio 2026):

- **Reemplaza las firmas BLS por `leanXMSS`** (firmas hash-based basadas en XMSS) para validadores: cuánticamente seguras porque solo dependen de la seguridad del hash. *(Estado: investigación + devnets `pq-devnet-0..5`.)*
- **Aquí está tu argumento de overhead, replicado por Ethereum:** las firmas `leanXMSS` pesan **2–4 KB, es decir 20–40× más que una firma BLS (~96 B)** y **carecen de la agregación nativa de BLS**. Para recuperar la escalabilidad, desarrollan **`leanVM`, un zkVM mínimo que comprime las firmas hash-based ~250×** mediante agregación basada en SNARK. → **Es exactamente tu cadena "firmas PQC grandes → amortizar con pruebas".**
- **Valida tu descarte de Groth16:** ethereum.org afirma textualmente que **«los STARKs, que dependen de funciones hash, ya son resistentes a la cuántica»** y que los compromisos KZG (basados en emparejamientos) **deberán migrar a alternativas STARK o reticulares**. → Es el mismo principio de tu doc de overhead: *el sistema de pruebas debe ser PQ*.
- **Cronograma:** `EIP-8141` (registro de claves + *signature agility*) apuntado al **fork Hegota, 2º semestre de 2026**; infraestructura PQ núcleo hacia **~2029**.

> **Uso en la tesis (estado del arte / introducción).** *"La propia hoja de ruta de consenso de Ethereum (Lean Consensus) adopta firmas hash-based, choca con un overhead de 20–40× sin agregación nativa, y lo resuelve con un zkVM de agregación (~250×) y STARKs post-cuánticos — exactamente el problema y la solución que NEXUS formaliza para firmas Dilithium en una dual-chain."* Es tu mejor argumento de pertinencia y vigencia, y está **citado de fuente primaria**.

### 1.2 Solana: elige **Falcon** como esquema post-cuántico

- En **abril de 2026**, la Solana Foundation anunció que sus dos equipos núcleo — **Anza** y **Firedancer (Jump Crypto)** — **convergieron *independientemente* en Falcon (FN-DSA)** como esquema de firma post-cuántico, con implementaciones tempranas ya en GitHub. *(Estado: investigación/roadmap de 3 fases; sin despliegue inmediato en mainnet.)*
- Roadmap de 3 pasos: (1) evaluación continua de Falcon; (2) adopción por **wallets nuevas** si la amenaza se vuelve creíble; (3) **migración de wallets existentes**.

> **Uso en la tesis.** Solana eligiendo **Falcon** (firmas pequeñas ~666 B) frente a Ethereum eligiendo **hash-based (leanXMSS)** frente a NEXUS con **Dilithium** te da una **comparativa real de tres sistemas, tres elecciones PQ distintas** (§4). Es material de discusión de altísimo valor.

---

## 2. La elección del esquema de firma PQ — ahora con anclas del mundo real (enriquece Obj. 2)

El overhead de ~50× de tu doc es **específico de Dilithium**, y resulta que **las tres grandes apuestas divergen** según sus prioridades. Esto convierte tu "sección comparativa de esquemas" en un análisis con casos reales:

| Sistema | Esquema PQ elegido | Tamaño firma | Racional | Estado |
|---|---|---:|---|---|
| **Ethereum (validadores)** | **leanXMSS** (hash-based, XMSS) | 2–4 KB | Máxima conservadurismo (solo depende del hash) + SNARK-friendly; compensan el tamaño con agregación zkVM (~250×) | investigación / devnets |
| **Solana** | **Falcon / FN-DSA** (reticular NTRU) | **~666 B** | Minimiza el overhead de datos (firmas pequeñas), prioridad de rendimiento | roadmap, impl. temprana |
| **NEXUS (tu tesis)** | **Dilithium / ML-DSA** (reticular Module-LWE) | 2.4–4.6 KB | **Equilibrio** seguridad/implementabilidad; estandarizado y fácil de implementar correctamente | implementado |
| (NIST) Falcon | **FIPS 206 / FN-DSA** | ~666 B | borrador **a finales de 2026**, final ~2027; firma compleja (punto flotante), sensible a canales laterales | borrador pendiente |
| (NIST) SPHINCS+ | **FIPS 205 / SLH-DSA** | 7–17 KB | Hash-based, ultra-conservador, sin estado; para alta garantía / custodia | final (ago-2024) |

> **Idea para la tesis (Obj. 2).** Añade una sección *"Elección del esquema de firma post-cuántica"* que posicione Dilithium como **el punto medio defendible**, contrastándolo con (a) la apuesta hash-based de Ethereum (más conservadora pero más grande → necesita agregación) y (b) la apuesta Falcon de Solana (más pequeña → ataca el overhead de frente, pero implementación delicada y FIPS 206 aún en borrador). Conéctalo con el doc de overhead: *NEXUS elige Dilithium por robustez de implementación y compensa el tamaño con la amortización dual-chain; Falcon recortaría el overhead a ~10× a costa de complejidad; el hash-based maximiza la confianza a costa de tamaño.* **Tres cadenas, tres elecciones — y tú las explicas.**

---

## 3. Disponibilidad de datos para firmas infladas — **ya en producción en Ethereum**

Tu Anchor Layer puede copiar un arsenal de DA **que ya está vivo** (no es especulación):

| Fuente (estado) | Qué es | Idea para NEXUS |
|---|---|---|
| **Ethereum · Fusaka + PeerDAS (EIP-7594)** · **LIVE en mainnet desde el 3-dic-2025** | *Data Availability Sampling*: los nodos **muestrean** fragmentos en vez de descargar todo; reduce la descarga de los validadores **~85%**. Objetivo/máx de blobs subido a 14/21 (BPO2); hasta ~8× capacidad. | Es el **DAS real** que tu código simula mal (muestrea su propia RAM). Implementa muestreo entre **pares** sobre datos **erasure-coded** distribuidos. Modela tu DA sobre PeerDAS. |
| **Ethereum · blobs (EIP-4844)** · live (2024) | DA efímera y barata para rollups; se poda tras ~18 días. | La DA de los *batches* L2 debe ser **efímera y podable**, no almacén permanente de firmas. |
| **Ethereum · expiración de historia/estado** · spec | Poda de historia antigua; árboles de estado migrando a hash STARK-friendly. | Contiene el crecimiento ~50× del ledger por firmas PQC. |

> **Idea para la tesis.** Reescribe el objetivo de DA como *erasure coding + DAS por muestreo entre pares (estilo PeerDAS, ya en producción) + poda tipo blob*. Cita Fusaka como evidencia de que el enfoque es viable y desplegado.

---

## 4. Identidad estable vs. clave rotable — **cierra tu hueco nº 3, validado por Ethereum**

Ethereum tiene la respuesta **nombrada y en hoja de ruta** a tu problema de rotar la clave sin cambiar la identidad:

| Fuente (estado) | Qué es | Idea para NEXUS |
|---|---|---|
| **Ethereum · EIP-7702 (smart EOAs)** · **LIVE** (Pectra, 7-may-2025) | La **misma dirección y clave** puede "delegar a código": verificación, *batching*, *session keys*, permisos. | Patrón base: la cuenta tiene **dirección estable** y **lógica de verificación intercambiable**. |
| **Ethereum · EIP-8141 "signature agility" + Key Registry** · spec (fork Hegota, H2-2026) | Mediante abstracción de cuentas, **cada cuenta migra voluntariamente a un esquema PQ de forma independiente** (sin hard fork global). Un **Key Registry** permite registrar claves PQ **junto a** las clásicas. | **La solución exacta a tu hueco identidad↔clave↔rotación↔dirección**: cuenta = `(id_estable, política_de_verificación, epoch)`. Rotar/migrar de esquema actualiza la política, **no** la dirección. El Key Registry es tu mecanismo de **migración y firmas híbridas (clásica+PQ)**. Conecta con tu `key_epoch` y tu tx `KeyRotation`. |

> **Idea para la tesis (Obj. 1/3).** Adopta el **modelo de cuenta con abstracción de verificación** y un **registro de claves PQ** para migración/cripto-agilidad. Está validado por Ethereum (EIP-7702 live, EIP-8141 en camino) — el revisor no podrá objetar que es especulativo.

---

## 5. Finalidad rápida determinista para banca — **cierra tu hueco nº 4**

| Fuente (estado) | Qué es | Idea para NEXUS |
|---|---|---|
| **Solana · Alpenglow (Votor + Rotor)** · **testnet (may-2026), mainnet ~finales 2026**; aprobado con 98,27% (sep-2025) | Reemplaza PoH+TowerBFT. Finalidad **12,8 s → 100–150 ms**. **Votor**: 1 ronda si ≥80% del *stake* está en línea (~100 ms), 2 rondas a 60% (~150 ms), **doble vía concurrente**. **Rotor** reemplaza Turbine (propagación). | Modelo concreto y reciente de **BFT con finalidad determinista rápida** para contrastar con tu *finality gadget*. El diseño de Votor (quórum por *stake*, finalidad en 1–2 rondas) es exactamente la dirección de tu corrección (quórum ponderado por stake + verificación de votos). |
| **Ethereum · Lean Consensus** · investigación | Finalidad de **4 segundos**, *fork-choice* tipo Goldfish, votación por comités. | Justifica el objetivo de **finalidad rápida de un solo paso** para liquidación bancaria. |

> **Idea para la tesis.** Define un requisito de **finalidad determinista rápida** (derivado del caso bancario) y referencia **Alpenglow/Votor** (números concretos: ~100–150 ms, quórum 80%/60%) como evidencia de viabilidad y como diseño a contrastar.

---

## 6. Esquema de dirección que oculta la clave pública (defensa en profundidad)

| Fuente (estado) | Qué es | Idea para NEXUS |
|---|---|---|
| **Solana · Winternitz Vault (Blueshift)** · **LIVE >2 años** | Bóveda hash-based con firmas Winternitz de **un solo uso**; «uno de los pocos primitivos resistentes a cuántica en producción en una blockchain mayor». | Modelo de **custodia en frío de alta garantía** post-cuántica, ya validado en producción. Cítalo como precedente real de hash-based on-chain. |
| **Bitcoin/Ethereum · dirección = hash(clave pública)** · vigente | La clave pública solo se revela **al gastar**. | Reduce la ventana de "harvest now": el adversario no ve la clave hasta el primer gasto. NEXUS ya deriva `address=hash(pk)`, pero **transporta la pk en la tx**; un esquema **revelar-al-gastar** lo mejora (defensa en profundidad). → Modelo de amenaza (Cap. 1). |

---

## 7. Prioridad de adopción (impacto/esfuerzo)

1. **(Alto impacto, solo redacción)** Usar **Lean Consensus + el "los STARKs ya son PQ" de ethereum.org** como validación externa **citada** de tus dos tesis (PQC + pruebas PQ). El paralelo leanVM (~250×) ↔ tu amortización es tu argumento estrella. → Estado del arte.
2. **(Alto impacto)** **Abstracción de cuentas + Key Registry** (EIP-7702 live / EIP-8141) → cierra identidad-vs-clave y da el modelo de migración. → Obj. 1/3.
3. **(Alto impacto)** Reescribir la **DA** sobre **PeerDAS** (ya live) + poda. → Obj. 1; corrige tu DA fabricada.
4. **(Medio-alto)** **Comparativa de esquemas PQ con casos reales** (ETH leanXMSS · SOL Falcon · NEXUS Dilithium). → Obj. 2 + doc de overhead.
5. **(Medio)** Requisito de **finalidad rápida** citando **Alpenglow/Votor**. → Obj. 1, finality gadget.
6. **(Medio)** **PBS / secuenciadores concurrentes** (ePBS de Ethereum; *Multiple Concurrent Leaders* de Solana) → fortalece la teoría de juegos del secuenciador. → Obj. 1.
7. **(Fino)** **Revelar-al-gastar** + cita de la **Winternitz Vault** en el modelo de amenaza. → Cap. 1.

> Todas refuerzan tu **arco narrativo único** (amenaza → PQC → overhead → dual-chain → coherencia PQ → validación) sin ampliar el alcance.

---

## Fuentes (junio 2026)

**Ethereum — post-cuántico / Lean Consensus:** [ethereum.org — Quantum resistance](https://ethereum.org/roadmap/future-proofing/quantum-resistance/) · [pq.ethereum.org](https://pq.ethereum.org/) · [leanroadmap.org](https://leanroadmap.org/) · [Lean Consensus 2026 Plan (HackMD)](https://hackmd.io/@tcoratger/ryS1ElrWbx) · [The Defiant — PQ key registry](https://thedefiant.io/news/blockchains/ethereum-researchers-lay-out-post-quantum-key-registry-as-first-concrete-migration-step)

**Ethereum — Fusaka / PeerDAS (live):** [EF Blog — Fusaka mainnet announcement (nov-2025)](https://blog.ethereum.org/2025/11/06/fusaka-mainnet-announcement) · [ethereum.org — PeerDAS](https://ethereum.org/roadmap/fusaka/peerdas/) · [ethereum.org — Fusaka](https://ethereum.org/roadmap/fusaka/)

**Ethereum — Account Abstraction (EIP-7702 live):** [ethereum.org — Account abstraction](https://ethereum.org/roadmap/account-abstraction/) · [Openfort — EIP-7702 in 2026](https://www.openfort.io/blog/eip-7702)

**Solana — Alpenglow:** [CoinDesk (may-2026)](https://www.coindesk.com/tech/2026/05/11/the-biggest-consensus-overhaul-in-solana-history-is-officially-live-for-testing) · [Solana Compass — Alpenglow](https://solanacompass.com/learn/Lightspeed/alpenglow-solanas-largest-protocol-upgrade-ever-brennan-watt-anza)

**Solana — post-cuántico (Falcon + Winternitz Vault):** [solana.com/news/quantum-readiness](https://solana.com/news/quantum-readiness) · [CoinDesk (abr-2026)](https://www.coindesk.com/tech/2026/04/27/solana-developers-outline-plan-to-protect-network-from-quantum-threats) · [Blueshift — Quantum-Proofing Solana](https://blueshift.gg/research/quantum-proofing-solana)

**NIST — FIPS 206 / FN-DSA (Falcon, borrador):** [CSRC — FIPS 206 FN-DSA](https://csrc.nist.gov/presentations/2025/fips-206-fn-dsa-falcon) · [DigiCert — FN-DSA nears draft](https://www.digicert.com/blog/quantum-ready-fndsa-nears-draft-approval-from-nist)
