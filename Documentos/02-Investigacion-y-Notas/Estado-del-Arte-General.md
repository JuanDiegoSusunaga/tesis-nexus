# Estado del Arte: Criptografía Poscuántica, Firma ML-DSA y Seguridad Activa del Ciclo de Vida de Claves

## Resumen Ejecutivo

El presente **Estado del Arte** recopila y sintetiza los avances científicos y desarrollos normativos más recientes (2018–2026) en torno a la **transición a la criptografía poscuántica (PQC)**, enfocándose en el algoritmo de firma digital basado en reticulados **ML-DSA (CRYSTALS-Dilithium)** estandarizado por el NIST (FIPS 204), la lógica de **seguridad activa del ciclo de vida de claves** mediante la norma **NIST SP 800-90B**, y la integración en arquitecturas distribuidas (como **Ethereum y Blockchains asíncronas**).

---

## 1. La Amenaza Cuántica y la Ruptura de la Criptografía Clásica

### 1.1 El Algoritmo de Shor y su No Aplicabilidad a Reticulados
La infraestructura de seguridad digital contemporánea (incluyendo protocolos web TLS, firmas ECDSA en Bitcoin/Ethereum y RSA) se fundamenta en la dureza computacional de dos problemas matemáticos clásicos:
1. **Factorización de Enteros Grandes** (base de RSA).
2. **Logaritmo Discreto en Grupos Finitos y Curvas Elípticas** (base de ECDSA, secp256k1, Ed25519).

En 1994, Peter Shor demostró que un ordenador cuántico de escala relevante (*Cryptographically Relevant Quantum Computer*, CRQC) que ejecute el **Algoritmo de Shor** puede resolver ambos problemas en tiempo polinomial $\mathcal{O}(n^3)$, destruyendo la seguridad de estos esquemas.

Por el contrario, los esquemas criptográficos basados en **reticulados algebraicos (*Lattice-based Cryptography*)** como ML-DSA y ML-KEM reducen su seguridad a problemas geométricos sobre reticulados de dimensión alta (como $\text{SVP}$ - *Shortest Vector Problem* o $\text{SIVP}$ - *Shortest Independent Vectors Problem*). El algoritmo de Shor no es aplicable a estos problemas ya que no poseen la estructura de grupo abeliano subyacente que aprovecha la Transformada Cuántica de Fourier (QFT).

### 1.2 El Problema del Subgrupo Oculto Diedral (DHSP)
Aunque existen generalizaciones del algoritmo de Shor para el *Dihedral Hidden Subgroup Problem* (DHSP) —como los algoritmos de criba de Kuperberg y sus variantes subexponenciales $\exp(\mathcal{O}(\sqrt{n}))$—, estos **no permiten resolver eficientemente los problemas de reticulados subyacentes a ML-DSA** (como $\text{Module-LWE}$ o $\text{Module-SIS}$). En consecuencia, la criptografía basada en reticulados se consolida como el pilar más sólido frente a adversarios cuánticos.

---

## 2. Formalización de ML-DSA (CRYSTALS-Dilithium) y Cadena de Reducciones de Seguridad

### 2.1 Cadena de Reducciones Criptográficas
La seguridad de **ML-DSA (FIPS 204)** se demuestra mediante una rigurosa cadena de reducciones de seguridad que conecta la in-forjabilidad frente a ataques elegidos de mensaje (**EUF-CMA**) con problemas de peor caso sobre reticulados de módulos:

$$\text{EUF-CMA (ML-DSA)} \xrightarrow{\text{Fiat-Shamir con Abortos}} \{\text{Module-LWE}, \text{Module-SIS}, \text{SelfTargetMSIS}\} \xrightarrow{\text{Reducción Promedio-Peor Caso}} \text{Mod-SIVP}$$

#### A. De Mod-SIVP a Module-LWE y Module-SIS
- **$\text{Mod-SIVP}_\gamma$ (Module Shortest Independent Vectors Problem):** Problema de peor caso en reticulados de módulos que consiste en encontrar vectores independientes cortos en un reticulado sobre un anillo de polinomios $\mathbb{R}_q = \mathbb{Z}_q[X]/(X^n + 1)$.
- **$\text{Module-LWE}$ (Module Learning With Errors):** Distinguir muestras algebraicas ruidosas $A \cdot s + e$ de muestras uniformes.
- **$\text{Module-SIS}$ (Module Short Integer Solution):** Encontrar una solución corta no nula $z$ tal que $A \cdot z \equiv 0 \pmod q$.

#### B. El Problema SelfTargetMSIS y el Modelo QROM
ML-DSA utiliza la construcción de **Fiat-Shamir con Abortos** (*Fiat-Shamir with Aborts*), introducida por Vadim Lyubashevsky. Para garantizar in-forjabilidad en presencia de un atacante cuántico que puede realizar consultas en superposición a la función hash, la seguridad se analiza en el **Modelo de Oráculo Aleatorio Cuántico (QROM - *Quantum Random Oracle Model*)**.
En este contexto, surge el problema **$\text{SelfTargetMSIS}$** (Self-Targeted Module Short Integer Solution), cuya dureza en QROM ha sido demostrada formalmente (Kiltz et al., 2018; UvA-DARE), garantizando que un atacante no puede forjar firmas válidas sin resolver una instancia difícil de $\text{MSIS}$.

---

## 3. Lógica de Seguridad Activa del Ciclo de Vida de Claves y Fuentes de Entropía

### 3.1 Monitoreo de Entropía según NIST SP 800-90B
La seguridad de cualquier esquema criptográfico (incluyendo ML-DSA) colapsa si la fuente de números aleatorios (RNG/TRNG/QRNG) es predecible o sufre fallos de hardware. La norma **NIST SP 800-90B** establece los requisitos para fuentes de entropía y pruebas de salud en línea:

#### A. Min-Entropía ($H_\infty$)
Se define como la medida más conservadora de impredecibilidad:
$$H_\infty = -\log_2 \left( \max_{x} P(X = x) \right)$$
La norma exige estimar $H_\infty$ continuamente sobre los bits generados por la fuente física o cuántica.

#### B. Pruebas de Salud en Línea (*Online Health Tests*)
1. **Repetition Count Test (RCT):** Detecta si la fuente queda "atascada" generando el mismo valor repetidamente. Si una secuencia idéntica se repite $B$ veces consecutivas (calculado según el nivel de entropía esperado), se dispara una alerta de fallo.
2. **Adaptive Proportion Test (APT):** Diseñado para detectar pérdidas de entropía progresivas o derivas en la distribución. Evalúa cuántas veces ocurre un valor específico dentro de una ventana de muestras ($W = 512$ o $W = 1024$).

### 3.2 Rotación de Claves con Secrecía Hacia Adelante (*Forward Secrecy*)
Para mitigar la amenaza de *"Harvest Now, Decrypt Later"* y limitar el impacto de la fuga de una clave privada, los sistemas poscuánticos deben incorporar algoritmos de **rotación de claves con secrecía hacia adelante**:
- **Secrecía Hacia Adelante (PFS):** La revelación de la clave privada actual de un nodo no permite derivar las claves de sesiones o épocas pasadas.
- **Registro Auditable:** En sistemas distribuidos/blockchain, las rotaciones de claves se registran mediante eventos firmados criptográficamente y auditables de forma inmutable.

---

## 4. Análisis de Complejidad Computacional y Validación Empírica (*Benchmarks*)

### 4.1 Comparativa Teórica y de Complejidad Asintótica ($\mathcal{O}$)
Los algoritmos de firma digital estandarizados por el NIST en 2024–2025 presentan marcados *trade-offs* entre complejidad computacional, tamaño de claves y tamaño de firma:

| Algoritmo | Tipo / Problema Base | Gen. Claves | Firma | Verificación | Tam. Clave Púb. | Tam. Firma |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **ML-DSA (Dilithium)** | Reticulados de Módulos (MLWE/MSIS) | $\mathcal{O}(n \cdot k \cdot l \log q)$ | $\mathcal{O}(n \cdot k \cdot l \log q)$ | $\mathcal{O}(n \cdot k \log q)$ | ~1.3 KB – 2.5 KB | ~2.4 KB – 4.6 KB |
| **FALCON (FN-DSA)** | Reticulados NTRU (GPV + NTT/FFT) | Complejo (FFT) | $\mathcal{O}(n \log n)$ | $\mathcal{O}(n \log n)$ | ~0.9 KB – 1.8 KB | ~0.6 KB – 1.3 KB |
| **SLH-DSA (SPHINCS+)** | Basado en Hash (Stateless Trees) | Muy Rápido | Lento (evaluaciones hash) | Rápido | ~32 B – 64 B | ~7.8 KB – 49 KB |

*Nota:* ML-DSA destaca por utilizar la **Transformada de Número Entero (NTT - *Number Theoretic Transform*)**, que reduce la multiplicación polinomial sobre $\mathbb{R}_q$ de $\mathcal{O}(n^2)$ a $\mathcal{O}(n \log n)$, logrando un rendimiento de verificación sumamente eficiente ideal para entornos distribuidos y validación de bloques.

### 4.2 Impacto en Ethereum y Redes Blockchain
- **Sobrecarga de Almacenamiento:** Las firmas secp256k1 de Ethereum ocupan solo 65 bytes, mientras que firmas ML-DSA-2 (nivel de seguridad equivalente a AES-128) requieren 2,420 bytes (~37 veces más). Esto exige arquitecturas de almacenamiento ligero, agregación de firmas o cadenas asíncronas duales (como AQRB).
- **Ataques de Canal Lateral (SCA) y Robustez de Implementación:** Las implementaciones prácticas de ML-DSA deben implementar operaciones en tiempo constante para mitigar ataques de tiempo (p. ej., variaciones de *KyberSlash*) y enmascaramiento (*masking*) contra análisis de potencia (*DPA/CPA*).

---

## 5. Residencia Efímera de Claves y Ciberdefensa Activa (revisión ampliada, jul. 2026)

### 5.1 Custodia *seed-only* de claves ML-DSA: práctica ya estandarizada
FIPS 204 §3.6.3 permite almacenar únicamente la semilla $\xi$ de 32 bytes y re-expandirla con `ML-DSA.KeyGen_internal`; el NIST confirmó en el pqc-forum (oct. 2024) que esta práctica es conforme a FIPS (aunque **no** lo es derivar $\xi$ de otra semilla vía KDF). El **RFC 9881** (IETF LAMPS, oct. 2025) declara la semilla el formato **RECOMENDADO** de clave privada ML-DSA en PKCS#8, y OpenSSL 3.5 la retiene y regenera por defecto (`retain_seed` / `prefer_seed`). La motivación publicada es de portabilidad, tamaño y no-malformabilidad (anti-trapdoor) — casi nunca de reducción de exposición en RAM.

### 5.2 Huecos identificados en la literatura
1. **KeyGen-por-firma como política de seguridad:** ningún trabajo propone ni mide la regeneración del par completo antes de cada firma con zeroización inmediata como control de minimización de residencia; el borrador *draft-connolly-cfrg-ml-dsa-security-considerations* recomienda incluso cachear la clave expandida durante las operaciones. La expansión *on-the-fly* existente (pqm4; Bos-Renes-Sprenkels, AFRICACRYPT 2022) obedece a escasez de RAM en embebidos, no a seguridad.
2. **Métrica de ventana de exposición** $W = \text{bytes} \times \Delta t$: sin formalización previa; lo más cercano (Sawa et al., ACSAC 2025) mide empíricamente la residencia de claves en RAM tras terminar el proceso, sin PQC.
3. **Deception con claves señuelo post-cuánticas:** resultado negativo robusto en tres familias de búsqueda. El prior art más cercano es la patente **US 10,521,584 B1** (Amazon, 2017/2019: firma con clave señuelo detectada por el backend al verificarla), pero con señuelos estáticos en infraestructura señuelo, sin disparador anti-debugging y sin PQC. Antecedentes conceptuales: honeywords/*honeychecker* (Juels-Rivest, CCS 2013), ErsatzPasswords (ACSAC 2015), Canarytokens (Thinkst), Honey Encryption (EUROCRYPT 2014, pasivo).
4. **Sequencer L2 con rol activo de seguridad:** ningún sistema publicado 2024-2026 combina semilla sellada en TEE + detección de compromiso del firmador + respuesta coordinada con la L2. Antecedentes parciales: Puffer Secure-Signer + RAVe (claves BLS en SGX con atestación verificada on-chain) y Rollup-Boost/Unichain (builder de L2 en TEE, orientado a MEV). La propia literatura señala que los *fraud proofs* "no fueron diseñados para detectar compromiso de identidad del sequencer".

### 5.3 Advertencias de diseño extraídas de la literatura
La indistinguibilidad estadística y de metadatos del señuelo debe tratarse como requisito formal (NoCrack cayó por divergencia KL, CCS 2016; los canaries de AWS fueron desanonimizados por metadatos); el disparador anti-debug/atestación es el eslabón débil (side-channels contra TEE: WeSee 2024, TEE.Fail 2025); y el caso Storm-0558 debe citarse como hipótesis del *crash dump*, no como hecho probado (informe CSRB 2024).

> **Documento de detalle:** `Documentos/02-Investigacion-y-Notas/Estado-del-Arte-Claves-Efimeras-y-Deception.md` (revisión completa con URLs verificadas, tabla de veredicto de novedad pilar por pilar y enunciado de contribución para la defensa).

---

## Conclusiones del Estado del Arte

1. **Madurez Criptográfica:** ML-DSA (FIPS 204) representa el estándar de firma poscuántica más balanceado en términos de seguridad demostrable en el QROM y eficiencia mediante NTT.
2. **Necesidad de Seguridad Activa:** La resistencia teórica a la cuántica es inútil si la entropía falla; por ello, la integración de pruebas en línea NIST SP 800-90B y políticas de rotación automatizada con secrecía hacia adelante son componentes críticos de la arquitectura.
3. **Desafío de Integración:** La transición en sistemas de alta escala como Ethereum requiere balancear la sobrecarga de tamaño de firma mediante nuevos modelos de consenso y estructuras de almacenamiento asíncrono.
4. **Espacio de Contribución en Gestión de Claves (jul. 2026):** La custodia *seed-only* está estandarizada (FIPS 204, RFC 9881), pero la regeneración KeyGen-por-firma como política de seguridad, la métrica de ventana de exposición $W$ y la combinación de señuelos criptográficos con PQC y un sequencer L2 detector no tienen prior art localizable — es el hueco que NEXUS ocupa (§5).
