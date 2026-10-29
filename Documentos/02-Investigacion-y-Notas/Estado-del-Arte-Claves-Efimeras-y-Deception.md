# Estado del Arte: Residencia Efímera de Claves ML-DSA y Deception Engine (Revisión 2026-07-31)

> **Revisión TG2 del 22 de septiembre de 2026:** el texto de julio se conserva como antecedente. R5 retira las afirmaciones de inexistencia de antecedentes y novedad de bytes×tiempo; corrige la autoría de Sawa y Suzaki y trata Connolly-02 como borrador archivado. La reexpansión no rota claves y conservar la semilla mantiene la capacidad de firma. La comparación actual, las consultas y sus límites están en el [informe R5](../04-Administrativo-TG2/Avances/R5-Residencia-y-Custodia-2026-09-22.md). Las conclusiones históricas siguientes no sustituyen esa revisión.



**Contexto:** Tesis NEXUS · Contraste de la propuesta preliminar V2 contra la literatura académica, estándares, patentes e industria (corte: julio 2026). El documento preliminar fue retirado por indicación del autor el 23 de septiembre de 2026; este análisis se conserva como antecedente.
**Metodología:** Tres revisiones paralelas con búsqueda web y verificación por lectura directa de las fuentes primarias más importantes: (1) deception con claves señuelo, (2) derivación determinista desde semilla y residencia en memoria, (3) firmas post-cuánticas en blockchain/L2 y defensa de claves de servidor con TEE.

---

## 1. Resumen ejecutivo (veredicto de novedad)

| Pilar de la propuesta V2 | ¿Ya existía? | Prior art más cercano | Espacio de contribución |
| :--- | :--- | :--- | :--- |
| **P1. Semilla ξ de 32 B como formato de custodia** | ✅ **Sí — estandarizado.** FIPS 204 §3.6.3 lo permite; NIST lo confirmó FIPS-compliant (pqc-forum, oct. 2024); **RFC 9881 (oct. 2025) lo declara formato RECOMENDADO**; OpenSSL 3.5 y BoringSSL lo implementan por defecto. | RFC 9881; OpenSSL 3.5 (`retain_seed`/`prefer_seed`) | Ninguno en el "qué". Sí en el "por qué": la literatura lo motiva por portabilidad y anti-trapdoor, casi nunca por reducción de exposición en RAM. |
| **P1b. Regeneración KeyGen just-in-time POR FIRMA como política de seguridad** | ❌ **No formalizado.** OpenSSL regenera al *cargar*, no por operación; el draft de Connolly recomienda incluso **cachear** la clave expandida durante las operaciones. pqm4/AFRICACRYPT 2022 expanden on-the-fly pero por escasez de RAM en embebidos, no por seguridad. | pqm4 (Cortex-M4); Bos-Renes-Sprenkels (AFRICACRYPT 2022) | **Contribución defendible:** KeyGen-por-firma como control deliberado de minimización de exposición + benchmark del trade-off (no publicado en la literatura). |
| **P1c. Métrica de ventana de exposición W = bytes × Δt** | ❌ **No existe como métrica formal.** Lo más cercano (Sawa et al., ACSAC 2025) mide Δt de residencia post-proceso empíricamente, sin producto bytes-tiempo, sin PQC y sin marco de política. | Sawa et al. (ACSAC 2025) | **Contribución defendible:** formalización de la métrica + cuantificación empírica para ML-DSA-65. |
| **P2. Zeroización, mlock, exclusión de core dumps, TEE** | ✅ **Sí — práctica establecida.** FIPS 140-3/ISO 19790 la exigen; crate `zeroize`, verificación formal (ePrint 2023/1713), draft de Connolly la recomienda para ML-DSA. | Almeida et al. 2023; Trail of Bits; draft-connolly | Ninguno. Citarlo como ingeniería estándar aplicada correctamente. |
| **P3. Threshold ML-DSA (MPC)** | ✅ Línea de investigación activa ajena a la tesis (no revisada en profundidad aquí; es trabajo futuro en la V2). | — | Solo como trabajo futuro citado. |
| **P4. Deception Engine: conmutación a honey-keypair PQ al detectar observación + detección off-chain en el sequencer L2** | ❌ **No existe.** Resultado negativo robusto en tres familias de búsqueda: nadie combina señuelos criptográficos con firmas post-cuánticas, ni usa anti-debugging como disparador de firma señuelo, ni da al sequencer L2 el rol de "honeychecker". | Patente Amazon **US 10,521,584 B1** (2017/2019): firma con clave señuelo detectada por el backend — pero como cebo estático en servidores señuelo, sin disparador anti-debug y sin PQC. | **Contribución principal de la tesis:** la síntesis (disparador por observación + firma señuelo válida + PQC + honeychecker L2) tiene la intersección vacía en la literatura. |
| **Sistema completo (a) semilla sellada TEE + (b) detección de compromiso + (c) respuesta coordinada con L2** | ❌ **Ningún sistema publicado 2024-2026 cierra el triángulo.** | Puffer Secure-Signer + RAVe (SGX + atestación verificada on-chain, pero BLS y sin detección); Rollup-Boost/Unichain (sequencer en TEE, pero para MEV, no supervivencia de claves). | **Posición de novedad defendible como arquitectura integrada.** |

---

## 2. Frente 1 — Derivación desde semilla y residencia efímera (lo que YA es estándar)

### 2.1 Nivel normativo
- **FIPS 204 §3.6.3** (NIST, ago. 2024): texto normativo — *"The seed ξ generated in step 1 of ML-DSA.KeyGen can be stored for the purpose of later expansion using ML-DSA.KeyGen_internal"*. §6.1: ξ debe generarse con RBG aprobado y protegerse como clave privada. [PDF](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.204.pdf)
- **NIST pqc-forum (oct. 2024):** Gorjan Alagic (NIST) confirma que almacenar la semilla y re-expandirla con `KeyGen_internal` **es FIPS-compliant**; lo que no se permite (aún) es derivar ξ de otra semilla vía KDF. [Hilo](https://groups.google.com/a/list.nist.gov/g/pqc-forum/c/949fsZRC6Ik) — ⚠️ relevante para NEXUS si el Sentinel-Seed deriva semillas por épocas: revisar cómo se enuncia la derivación en el capítulo para no chocar con esta restricción de cumplimiento.
- **RFC 9881** (Massimo, Kampanakis, Turner, Westerbaan — oct. 2025): en PKCS#8, `CHOICE { seed [0], expandedKey, both }`, y declara la semilla ξ **"the RECOMMENDED format for storing and transmitting ML-DSA private keys"**. §8.1-8.2: retener la semilla siempre (la expansión es one-way) y verificar consistencia regenerando. [RFC](https://www.rfc-editor.org/info/rfc9881/)
- Argumento de seguridad comunitario (pqc-forum "expanded key formats and trapdoors"): la clave expandida no permite verificar buena generación (claves malformadas/trapdoor); la semilla sí. [Hilo](https://groups.google.com/a/list.nist.gov/g/pqc-forum/c/gaHWR-Fs3yQ)

### 2.2 Nivel de implementación
- **OpenSSL 3.5** (abr. 2025): `ml-dsa.retain_seed` (por defecto retiene semilla) y `ml-dsa.prefer_seed` (al cargar, regenera desde semilla). Formatos `seed-only`, `seed-priv`, `priv-only`, `bare-seed`. **Matiz clave:** regenera al *importar*, no por firma — la clave expandida vive mientras exista el objeto `EVP_PKEY`. [Docs](https://docs.openssl.org/3.5/man7/EVP_PKEY-ML-DSA/) · [Posición OpenSSL](https://openssl-library.org/post/2025-01-21-blog-positionandplans/)
- **BoringSSL:** serializa la clave privada ML-DSA como semilla (API pública); el formato NIST expandido pasó a interno. [Commit](https://boringssl.googlesource.com/boringssl.git/+/0ee584bb5134f8e6b5d2e90f5dc9334ae460a507%5E!/)
- **pqm4 / embebidos:** expansión on-the-fly de la matriz Â desde ρ (Kannwischer et al.; [Abdulrahman et al. 2022](https://kannwischer.eu/papers/2022_fasterkyberdilithiumm4.pdf)); **Bos, Renes, Sprenkels, "Dilithium for Memory Constrained Devices" (AFRICACRYPT 2022)**: firma en ~8-10 KiB de RAM re-derivando componentes bajo demanda. [Springer](https://link.springer.com/chapter/10.1007/978-3-031-17433-9_10) — precedente técnico del JIT, pero **motivado por RAM escasa, no por seguridad**.
- **HSM/KMS:** AWS KMS soporta ML-DSA (jun. 2025, FIPS 140-3 L3) sin documentar el formato interno; **Thales Luna declara que el wrap de semillas ML-DSA "no está especificado ni implementado"** porque PKCS#11 aún no lo estandariza. Ningún HSM documenta "sealed seed + regeneración JIT por operación". [AWS](https://docs.aws.amazon.com/kms/latest/developerguide/mldsa.html) · [Thales](https://thalesdocs.com/gphsm/luna/7/docs/network/Content/sdk/extensions/pqc/post_quantum_algorithms.htm)

### 2.3 Exposición en memoria y zeroización
- **Albrecht, Deo, Paterson (TCHES 2018):** cold-boot sobre claves module-LWE bajo NTT — demostración canónica de que claves lattice en RAM son extraíbles de volcados; la viabilidad depende del encoding en memoria. [ePrint](https://eprint.iacr.org/2018/672.pdf) — **No existe paper dedicado a cold-boot sobre ML-DSA/Dilithium específicamente** (hueco citable).
- **Sawa et al. (ACSAC 2025):** medición empírica de residencia de claves en RAM tras terminar el proceso — hasta **1.635 s sin zeroizar**, incluyendo copias de registros en context switches. [PDF](https://lab.iisec.ac.jp/~suzaki_lab/PDF/ACSAC2025-Sawa.pdf) — lo más cercano a la "ventana de exposición", sin métrica bytes×tiempo ni PQC.
- **Almeida et al. (ePrint 2023/1713):** zeroización de alta garantía verificada formalmente (Jasmin) frente a dead-store elimination. [ePrint](https://eprint.iacr.org/2023/1713.pdf)
- **draft-connolly-cfrg-ml-dsa-security-considerations:** el documento vivo más cercano a la tesis — recomienda semilla como formato canónico, regeneración determinista "at any time", zeroización al terminar; pero sugiere **cachear la clave expandida "for the duration of signing operations"** y no cuantifica exposición. [Draft](https://www.ietf.org/archive/id/draft-connolly-cfrg-ml-dsa-security-considerations-02.html) — **cita obligada como estado del arte inmediato contra el cual se define la contribución.**
- **Coste de KeyGen:** benchmarks estándar muestran KeyGen ≈ 20-40 % del coste de Sign (Cortex-M4: ~1,6 M ciclos vs 4-7 M). Nadie publica "KeyGen+Sign por operación" como política deliberada. Benchmark NEXUS (sandbox, 2026-07-31, --release, 1.000 iter.): firma estándar 1,02 ms → firma JIT (KeyGen+Sign+Zeroize) 1,77 ms (+0,75 ms); reducción de huella en reposo 187,3× (5.993 B → 32 B).

---

## 3. Frente 2 — Deception con claves señuelo (dónde está la novedad)

### 3.1 Línea honeywords/honeytokens (patrón "backend detecta el uso del señuelo")
- **Juels & Rivest, "Honeywords" (ACM CCS 2013):** contraseñas señuelo + **honeychecker** que dispara alarma al usarse. Antecedente arquitectónico directo del rol del sequencer L2 en NEXUS — pero sobre contraseñas. [PDF](http://www.arijuels.com/wp-content/uploads/2013/09/JR13.pdf)
- **Almeshekah et al., "ErsatzPasswords" (ACSAC 2015):** HSM/PUF hace que el cracking offline solo produzca contraseñas falsas cuyo uso alerta. [ACM](https://dl.acm.org/doi/abs/10.1145/2818000.2818015)
- **Chakraborty et al., survey honeywords (ACM Computing Surveys 2022):** confirma que **ninguna variante de la línea trata claves de firma**. [ACM](https://dl.acm.org/doi/10.1145/3552431)
- **Thinkst Canarytokens / AWS honey credentials (industria, ~2015-):** credenciales señuelo cuyo uso en API dispara alerta — el paralelo operacional más usado. Debilidad documentada: TruffleHog los desanonimiza por metadatos sin activarlos. [TruffleHog](https://trufflesecurity.com/blog/canaries)
- **Certiception (SRLabs, 2024):** honeypot de CA (ADCS) — lo más cercano a "honey certificates". [GitHub](https://github.com/srlabs/Certiception)

### 3.2 Honey Encryption y claves privadas señuelo
- **Juels & Ristenpart, "Honey Encryption" (EUROCRYPT 2014):** descifrar con contraseña incorrecta produce una clave RSA falsa plausible. **Pasivo: confunde, no detecta** — no hay firmas ni alarma al uso. [ePrint](https://eprint.iacr.org/2014/155)
- **NoCrack (IEEE S&P 2015) roto por Golla et al. (CCS 2016)** mediante divergencia KL entre distribuciones real/señuelo. [ACM](https://dl.acm.org/doi/10.1145/2976749.2978416) — **lección de diseño crítica** (ver §5).
- Antecedente histórico: Arcot Systems (~1999) ocultaba la clave RSA real entre claves basura, sin detección de uso.

### 3.3 Patentes (prior art industrial más cercano)
- **US 10,521,584 B1 — Amazon, "Computer Threat Analysis Service"** (prioridad 2017, concedida 2019): *"if an attacker uses the decoy cryptographic key to generate a digital signature… the threat analysis service detects the use of the decoy cryptographic key by verifying the digital signature"*. **El prior art más cercano a P4.** Diferencias verificadas: señuelo estático en infraestructura señuelo (no conmutación reactiva del firmador legítimo), sin disparador anti-debugging, sin PQC. [Google Patents](https://patents.google.com/patent/US10521584B1/en)
- **US 11,089,056 B2 — Sophos, "Intrusion detection with honeypot keys"** (2018/2021): detección por *acceso* al material de clave en el keystore, no por verificación de firmas. [Google Patents](https://patents.google.com/patent/US11089056B2/en)
- **US 12,430,650 B2 — Western Digital, "Self-aware cryptocurrency wallets"** (2022/2025): el wallet monitorea la cadena buscando firmas propias no autorizadas — detección on-chain de uso de la clave **real**, sin señuelos. Complementario, no solapante. [Google Patents](https://patents.google.com/patent/US12430650B2/en)

### 3.4 Resultado negativo (deception + PQC)
Búsquedas cruzadas en tres familias ("honey encryption" + lattice/ML-DSA; PQC + decoy/honeypot keys; Dilithium/Falcon/SPHINCS+ + deception) **no devuelven ningún trabajo académico que combine señuelos criptográficos con esquemas de firma post-cuánticos**. La práctica industrial ante detección de depurador es *fail-closed* (apagarse), nunca engaño con firma señuelo; las patentes de anti-debugging con respuesta activa degradan o abortan, ninguna firma con señuelo.

---

## 4. Frente 3 — Post-cuántica en blockchain/L2 y defensa del firmador

### 4.1 Contexto que valida el problema (2024-2026)
- **Ethereum:** leanXMSS para validadores, precompiles PQ, leanVM; L1 quantum-safe proyectado ~2029; **EIP-8141 (PQ key registry)** como primer fork concreto. La EF recomienda a los L2 asegurar "claves operacionales, puentes y mensajería cross-chain" — exactamente la clave del sequencer que NEXUS protege. [pq.ethereum.org](https://pq.ethereum.org/)
- **Solana:** Anza y Firedancer seleccionaron **Falcon** (abr. 2026), sin fecha dura; Winternitz Vault en producción >2 años; Alpenglow (agregación BLS) sin análogo PQ práctico. [Helius](https://www.helius.dev/blog/solana-post-quantum-cryptography)
- **Algorand:** Falcon State Proofs desde 2022; transacciones Falcon en mainnet desde nov. 2025; cuentas PQ nativas hacia 2027. [Algorand](https://algorand.co/technology/post-quantum)
- **StarkNet:** el L2 más avanzado en PQ (STARKs ya quantum-resistant; roadmap Falcon-512 para consenso, jun. 2026). Limitación admitida: el bridge y la DA quedan atados al cronograma de Ethereum. [StarkWare](https://starkware.co/blog/quantum-computing-is-starknet-prepared/)
- **Lattice (arXiv 2603.07947, mar. 2026):** L1 con ML-DSA-44 exclusivo desde el génesis — lo más cercano en elección criptográfica, **sin TEE, sin detección, sin revocación**. [arXiv](https://arxiv.org/abs/2603.07947)
- **SoK "Quantum Disruption" (arXiv 2512.13333, dic. 2025):** integrar firmas PQ exige rediseño arquitectónico; **no cubre L2/sequencers ni detección de compromiso** — evidencia citable del gap. [arXiv](https://arxiv.org/abs/2512.13333)

### 4.2 El gap del sequencer (citable textualmente)
- *"El sistema de fraud proofs no fue diseñado para detectar compromiso de identidad del sequencer; detecta ejecución incorrecta. La ventana de 7 días no mitiga un compromiso de la clave del sequencer."* — [quantumsecuritydefence.com](https://quantumsecuritydefence.com/quantum-news/quantum-resistant-blockchain-rollup-considerations/) (2025-2026).
- Los mecanismos de guardians/social recovery (ERC-4337, Argent) **responden** a compromiso confirmado por humanos; ninguno hace **detección automática**.

### 4.3 Defensa del firmador con TEE (antecedentes parciales)
- **Puffer Secure-Signer + RAVe** (grant de la EF): claves BLS de validador generadas y selladas en SGX + contratos on-chain que verifican la remote attestation. **El antecedente más cercano a "semilla sellada + atestación verificada por la cadena"** — con BLS (no PQ), para validadores L1, sin detección de observación ni señuelos. [Puffer](https://medium.com/puffer-fi/how-puffers-secure-signer-reduces-slashing-risk-5f24dc2c57c)
- **Flashbots Rollup-Boost en Unichain (mayo 2025):** primer builder de L2 en TEE en mainnet — para ordenamiento justo/MEV, no supervivencia de claves. [Flashbots](https://writings.flashbots.net/unichain-mainnet)
- **Casos reales que motivan el problema:** Storm-0558/Microsoft 2023 (clave de firma MSA; forjaron tokens y leyeron correo de ~25 organizaciones — ⚠️ **citar con rigor**: el CSRB recoge que Microsoft no tiene evidencia concluyente de que el crash dump contuviera la clave; es la hipótesis principal, no un hecho probado); Ronin Bridge 2022 ($540-625 M, claves de 5/9 validadores robadas de servidores); Harmony Horizon 2022 (~$100 M, 2 claves del multisig 2-de-5).
- **Límite honesto de los TEE:** la atestación puede subvertirse por side-channels (TEE.Fail 2025, WeSee 2024, SgxPectre) — citarlo como limitación, con el Deception Engine como defensa en profundidad complementaria.
- **Detección de introspección como sensor:** técnicamente factible y desplegada a escala en anti-cheat (VIC, arXiv 2502.12322; PatchGuard) — **nunca acoplada a un servicio de firmas**. NEXUS traslada la técnica de anti-cheat a defensa del firmador.

---

## 5. Advertencias de diseño extraídas de la literatura (requisitos para la V2)

1. **Indistinguibilidad del señuelo como requisito formal, no supuesto.** NoCrack cayó por divergencia KL entre distribuciones real/señuelo (CCS 2016); los canaries de AWS fueron desanonimizados por metadatos (TruffleHog). El honey-keypair de NEXUS debe ser estadísticamente indistinguible del real **incluyendo sus metadatos** (rutas de código, timing, formato de almacenamiento). Nota a favor: un par ML-DSA señuelo generado con el mismo `KeyGen` es criptográficamente idéntico en distribución a uno real — la distinguibilidad residual queda en el canal de conmutación (timing del branch de detección), que debe ser constante.
2. **El disparador anti-debug/atestación es el eslabón débil, no la criptografía.** La literatura anti-cheat muestra carrera armamentista de evasión (VIC); la atestación TEE tiene side-channels. Enunciar el Deception Engine como defensa en profundidad probabilística, no como garantía absoluta.
3. **Compliance de la derivación de semillas.** NIST permite almacenar y re-expandir ξ, pero **no deriva ξ de otra semilla vía KDF** (pqc-forum, oct. 2024). Revisar la redacción del Sentinel-Seed/épocas para que la rotación se enuncie como generación de nuevas semillas desde el RBG (con salud SP 800-90B), no como cadena KDF de la semilla ML-DSA, o declarar explícitamente la divergencia con el perfil FIPS.
4. **Citar RFC 9881 y draft-connolly como estado del arte inmediato** y definir la contribución *contra* ellos: ambos recomiendan seed-only pero ninguno prescribe KeyGen-por-firma ni cuantifica la exposición.
5. **Storm-0558 con matiz** (hipótesis del crash dump, no hecho probado) para no perder rigor ante el jurado.

---

## 6. Enunciado de la contribución para la defensa

> "La tesis no modifica FIPS 204 ni inventa primitivas. Sobre el formato seed-only —que RFC 9881 ya recomienda por portabilidad e integridad— NEXUS aporta tres cosas que la revisión de estado del arte (corte jul. 2026) no localiza en literatura, estándares, patentes ni industria: **(1)** la regeneración KeyGen-por-firma como *política de seguridad* de minimización de residencia, con el primer benchmark publicado del trade-off (1,02 → 1,77 ms; huella en reposo 187× menor); **(2)** la formalización de la métrica de ventana de exposición W = bytes × Δt; y **(3)** un Deception Engine que, ante detección de observación, conmuta a un honey-keypair ML-DSA cuyas firmas válidas actúan como honeytoken detectado off-chain por el sequencer L2 — cerrando un triángulo (semilla sellada + detección de compromiso + respuesta coordinada con la L2) cuya intersección está vacía en el estado del arte, donde los antecedentes parciales son Puffer Secure-Signer (custodia TEE, sin detección), la patente US 10,521,584 de Amazon (señuelo estático, sin PQC) y el honeychecker de Juels-Rivest (contraseñas, no firmas)."

**Alcance honesto de la revisión:** búsqueda web sistemática con verificación de fuentes primarias, no una revisión sistemática exhaustiva tipo PRISMA ni búsqueda en bases cerradas (Scopus/WoS completas, literatura de patentes exhaustiva). El claim correcto ante el jurado es "hasta donde alcanza esta revisión, no se localiza prior art", no "se demuestra que no existe".

---

*Documento generado a partir de tres revisiones paralelas verificadas (2026-07-31). Carpeta: Documentos/02-Investigacion-y-Notas.*
