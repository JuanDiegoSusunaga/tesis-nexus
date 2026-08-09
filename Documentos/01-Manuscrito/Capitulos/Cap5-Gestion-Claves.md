# Capítulo 5 — Gestión Activa del Ciclo de Vida de Claves

### (Objetivo 3 · la capa operativa de seguridad)

> **Rol en el arco de la tesis.** Este capítulo desarrolla la **lógica de seguridad activa** que rodea al primitivo de firma (Cap. 4): cómo se obtiene aleatoriedad de calidad, cómo se deriva la semilla de la clave, y cómo se rota la clave para limitar el daño ante un compromiso. Es la capa **operativa** que da *resiliencia* al sistema; reformula sobre bases criptográficas correctas el monitoreo de entropía del alcance original.

---

## 5.1 Introducción

Una clave de firma post-cuántica no vive aislada: nace de una fuente de aleatoriedad, se deriva de una semilla y, a lo largo de su uso, debe **rotarse** para acotar el impacto de un eventual compromiso. El Objetivo 3 modela e implementa esta **gestión activa del ciclo de vida**, definida por tres elementos:

1. una **fuente de entropía monitoreada**, evaluada por su **min-entropía** y vigilada por **pruebas de salud en línea** (NIST SP 800-90B), §5.2–5.3;
2. la **derivación de claves** mediante un KDF con separación de dominio, §5.4 (conecta con el Cap. 4, §4.5);
3. la **rotación con secrecia hacia adelante**, disparada por política, con registro auditable, §5.5;
4. la **residencia efímera de la clave en memoria**: en reposo solo persiste la semilla, y la clave expandida se regenera justo a tiempo para cada firma y se zeroiza, §5.6.

Estos elementos forman una **tubería única** (§5.7) que une la fuente de aleatoriedad con la clave Dilithium y su rotación. El capítulo corrige explícitamente el enfoque del prototipo original, que usaba la **entropía de Shannon de la semilla** como métrica de seguridad —un planteamiento erróneo que se explica y reemplaza en §5.2—.

---

## 5.2 La métrica correcta: min-entropía de la fuente

El prototipo original disparaba la rotación cuando la **entropía de Shannon** de la semilla de 32 bytes caía por debajo de 7,5 bits/byte. Este planteamiento es **incorrecto por dos razones**:

1. **La entropía de Shannon de una muestra no mide el secreto de una clave.** La salida de un CSPRNG luce con entropía de Shannon máxima ($\approx 8$ bits/byte) **independientemente** de si la semilla-fuente es secreta o predecible. Lo que importa para una clave es la **imprevisibilidad de la fuente**, no la uniformidad estadística de una muestra.
2. **Es degenerada para 32 bytes.** Con solo 32 muestras sobre 256 valores posibles, la entropía de Shannon empírica máxima alcanzable es $\log_2 32 = 5$ bits/byte, **nunca 7,5**. El umbral era inalcanzable y la prueba habría fallado.

**La métrica pertinente es la min-entropía de la fuente:**
$$H_\infty(X) = -\log_2 \Big(\max_x \Pr[X=x]\Big).$$
La min-entropía captura la imprevisibilidad en el **peor caso** (el valor más probable), que es la medida conservadora apropiada para material criptográfico. La cantidad de bits de seguridad que aporta un bloque de datos de la fuente es $\approx H_\infty \times (\text{longitud})$.

> **NIST SP 800-90B** estandariza precisamente la **estimación de min-entropía** de fuentes de entropía (con estimadores para los casos IID y no-IID, p. ej. el de valor más común, el de Markov, etc.). NEXUS adopta este marco: la fuente se caracteriza por su min-entropía estimada, no por la entropía de Shannon de una muestra.

---

## 5.3 Monitoreo de salud en línea (NIST SP 800-90B)

"Monitoreo activo de entropía", en sentido riguroso, significa **vigilar la salud del generador en tiempo de ejecución** para detectar su degradación. NIST SP 800-90B define dos **pruebas de salud continuas** que NEXUS adopta:

**1. Repetition Count Test (RCT).** Detecta un generador "atascado" (que emite el mismo valor repetidamente). Dado un nivel de min-entropía $H$ y una probabilidad de falso positivo $\alpha$, define un umbral
$$C = 1 + \left\lceil \frac{-\log_2 \alpha}{H} \right\rceil.$$
Si un mismo valor aparece $\ge C$ veces **consecutivas**, la prueba **falla** (la fuente se considera comprometida).

**2. Adaptive Proportion Test (APT).** Detecta una pérdida gradual de entropía. Sobre una ventana de $W$ muestras (típicamente $W=512$ para fuentes binarias, $1024$ para no binarias), cuenta cuántas veces **reaparece** la primera muestra de la ventana; si el conteo excede un umbral derivado de $H$ y $\alpha$, la prueba **falla**.

Ambas pruebas corren **continuamente** sobre el flujo de la fuente. Su fallo es el disparador de salud que **bloquea la derivación de claves** y fuerza el *reseeding*/rotación (§5.5). Este es el mecanismo que sustituye, de forma fundamentada, al disparador "Shannon < 7,5" del prototipo.

---

## 5.4 Derivación de claves por KDF

Entre la fuente de entropía y la clave Dilithium se interpone una **función de derivación de claves (KDF) con separación de dominio**, que cumple dos funciones: (i) "condensar" el material de la fuente en una semilla uniforme de longitud fija, y (ii) **separar dominios** para que claves derivadas en contextos distintos (firma, identificación, época) sean independientes.

NEXUS emplea **HKDF** (RFC 5869, paradigma *Extract-then-Expand*) o, equivalentemente, **SHAKE256** como *XOF* con un prefijo de dominio:
$$\xi = \mathrm{KDF}\big(\underbrace{\text{material de la fuente}}_{\text{alta min-entropía}},\ \underbrace{\text{sal}}_{}\,,\ \underbrace{\text{contexto}}_{\text{dominio} \,\|\, \text{epoch}}\big),$$
y la semilla $\xi$ alimenta la `KeyGen` determinística de ML-DSA (Cap. 4, §4.5). La separación de dominio (parámetro `info` de HKDF / prefijo SHAKE) garantiza que rotar la *epoch* produzca una semilla —y por tanto una clave— independiente de las anteriores.

---

## 5.5 Rotación con secrecia hacia adelante

La rotación periódica de la clave **acota el daño** de un compromiso: una clave comprometida solo afecta a su época de uso, no a las pasadas ni futuras.

**Disparadores de rotación (por política).** La rotación se activa cuando se cumple **cualquiera** de:
- **uso** superior a un umbral (p. ej. 100.000 derivaciones),
- **antigüedad** superior a un máximo (p. ej. 24 horas),
- **fallo de las pruebas de salud** (RCT/APT, §5.3) de la fuente.

**Mezcla con secrecia hacia adelante.** La nueva semilla se deriva mezclando la anterior con material fresco mediante un hash de un solo sentido:
$$\xi_{e+1} = H\big(\text{dominio} \,\|\, \xi_{e} \,\|\, \text{material fresco} \,\|\, e\big), \qquad \text{y se borra } \xi_{e}.$$
Como $H$ es de un solo sentido y la semilla anterior se **zeroiza**, el compromiso de $\xi_{e+1}$ **no** permite recuperar $\xi_{e}$ ni las claves de épocas pasadas: esto es la **secrecia hacia adelante**.

**Bloqueo ante degradación.** Si las pruebas de salud fallan, la derivación de claves se **bloquea** (no se emiten claves desde una fuente degradada) hasta que la fuente se restablezca o se realice un *reseeding* con una fuente sana.

**Auditoría.** Cada rotación se registra en un **log auditable** (época, motivo, marca de tiempo), requisito propio del contexto bancario (trazabilidad y cumplimiento). El identificador de cuenta permanece estable a través de las rotaciones (Cap. 3, §3.6: la rotación actualiza la *política de verificación* y la *epoch*, no la dirección).

---

## 5.6 Residencia efímera de la clave en memoria

Los controles anteriores protegen la clave en su **origen** (fuente, KDF) y en su **ciclo** (rotación); falta protegerla en su **residencia**: la clave privada expandida de ML-DSA-65 es un objeto de 4.032 bytes cuya permanencia en RAM o disco la expone a volcados de memoria, *core dumps*, depuradores e introspección de hipervisor. La amenaza es concreta: la extracción de claves reticulares desde volcados de RAM está demostrada (ataques *cold-boot* sobre claves module-LWE [ADP18]), y el compromiso de la clave de firma MSA de Microsoft (Storm-0558, 2023) —cuya hipótesis principal es la exposición en un *crash dump*— ilustra el impacto de una clave de firma de alto valor residente en la memoria de un servidor.

**Base normativa: la semilla como formato de custodia.** FIPS 204 §3.6.3 permite almacenar únicamente la semilla $\xi$ de 32 bytes y re-expandirla con `ML-DSA.KeyGen_internal` [NIST24], y el RFC 9881 declara la semilla el formato **recomendado** de clave privada ML-DSA [RFC9881]; OpenSSL 3.5 la retiene y regenera por defecto al importar. NEXUS adopta esta práctica —la `KeyGen` determinística de §5.4 y Cap. 4 §4.5 es exactamente esa re-expansión— y la extiende con una **política** que el estado del arte no prescribe:

**Política de residencia efímera (KeyGen por firma).** En reposo, el sistema solo conserva $\xi$ (32 B, sellable en TPM/TEE). Ante cada solicitud de firma, el firmador (i) expande $\xi \to (pk, sk)$, (ii) firma, y (iii) **zeroiza** de inmediato los vectores expandidos. La clave de ~4 KB no existe en ningún soporte persistente y solo existe en RAM durante la operación.

**Qué gana la política, y qué no.** Conviene precisar el argumento antes de cuantificarlo, porque admite una objeción inmediata: **la semilla $\xi$ es tan comprometedora como la clave expandida** —quien la obtiene reconstruye $(pk,sk)$ con la `KeyGen` del propio estándar—, de modo que pasar de 4.032 B a 32 B **no divide por 126 la probabilidad de compromiso**. El beneficio es de otra naturaleza, y es de dos tipos:

1. **Cambio de categoría de custodia (el argumento principal).** 32 bytes caben en el material que un TPM sella, un HSM envuelve o un enclave conserva en memoria protegida; 4.032 bytes atraviesan necesariamente el montón del proceso, con su paginación, su *swap* y sus volcados. La política no reduce el secreto: lo **traslada a una clase de soporte con controles cualitativamente distintos**. Esa migración de categoría —no el cociente de tamaños— es lo que sostiene la política, y es también lo que la hace componible con la ingeniería de memoria descrita más abajo.
2. **Reducción de la superficie temporal.** El material expandido deja de ser residente y pasa a existir solo durante la operación, acotando la ventana en que un volcado, un depurador o una introspección de hipervisor pueden capturarlo. Frente a un adversario que **muestrea** el estado de la memoria en un instante (un *crash dump* puntual, un *cold-boot* tras un corte), lo que cae es la probabilidad de intersectar esa ventana, y cae con $\Delta t$.

**Métrica de ventana de exposición (heurística de política).** Con esa lectura, se propone cuantificar la superficie de riesgo en memoria como el producto $W = \text{bytes expuestos} \times \Delta t$ (byte·segundo). Su estatus se declara explícitamente: $W$ es una **métrica heurística de ingeniería, no una cota de probabilidad de compromiso**. El factor temporal tiene interpretación directa (fracción del tiempo en que el material es capturable). El factor de bytes **no** mide secrecía —ya se dijo que 32 B comprometen tanto como 4.032 B— sino dos efectos de segundo orden: (i) la fracción de páginas del proceso que un volcado parcial debe capturar para contener el material, y (ii) la tolerancia a la recuperación **parcial**, que en claves reticulares es un efecto real y medido: [ADP18] reconstruye claves module-LWE desde volcados **degradados**, de modo que un objeto grande y redundante en el dominio NTT ofrece al atacante más margen de corrección de errores que 32 bytes sin redundancia. Bajo esa convención, la exposición **permanente** pasa de 4.032 B (clave expandida residente) a 32 B —factor 126× (187× respecto de la representación en memoria del prototipo, 5.993 B)— y la exposición **transitoria** es una ráfaga de ~1,2 ms por firma (medianas Criterion del Cap. 6 §6.6: KeyGen 413 µs + firma 790 µs). En una medición dedicada de la política completa (KeyGen + firma + zeroización; 1.000 iteraciones, modo *release*), la latencia media de firma pasó de 1,02 ms a 1,77 ms (**+0,75 ms**), con la verificación inalterada: un sobrecosto despreciable frente a los SLA bancarios típicos ($10^2$–$10^3$ ms).

La medición se consolidó como *benchmark* reproducible del repositorio (`nexus-crypto/benches/residencia_bench.rs`: política cacheada vs. efímera vs. expansión aislada, medianas Criterion) y se re-ejecutó en el segundo perfil de hardware (H2, Cap. 6 §6.6): firma con clave cacheada 314 µs, firma bajo la política efímera 432 µs — **sobrecosto de +0,12 ms** (expansión aislada: 133 µs), con una ráfaga transitoria de ~0,43 ms por firma. En hardware moderno el costo de la política es, pues, aún más despreciable que el reportado originalmente. La métrica $W$ permite además fijar, bajo la misma convención heurística, el punto de equilibrio: la exposición **media** bajo la política efímera ($32 + 5.993 \times 432\,\mu s \times \lambda$ bytes, con $\lambda$ la tasa de firmas) solo iguala a la de la clave cacheada cuando el firmador se satura ($\lambda \approx 2.300$ firmas/s, un núcleo al ~100 % firmando); a tasas realistas la reducción es de órdenes de magnitud (103× a 10 firmas/s; 20× a 100 firmas/s).

**Posicionamiento frente al estado del arte** (revisión con fuentes verificadas, jul. 2026). La re-expansión sobre la marcha existe en microcontroladores, motivada por la **escasez de RAM**, no por seguridad [BRS22]; el borrador de consideraciones de seguridad de ML-DSA recomienda incluso **cachear** la clave expandida mientras duren las operaciones de firma [Connolly26]; y no se localiza formalización previa de la métrica $W$ ni benchmark publicado del trade-off KeyGen-por-firma (lo más cercano mide tiempos de residencia de claves en RAM tras terminar el proceso, sin PQC [Sawa25]). Ambos elementos —la política y su métrica— son, hasta donde alcanza la revisión, aporte de este trabajo.

**El *trade-off* que la política introduce (y por qué la guía vigente recomienda lo contrario).** Contraponerse a [Connolly26] exige nombrar la razón de su recomendación, que no es arbitraria: re-expandir $\xi$ en cada firma **ejecuta la expansión secreta $N$ veces en lugar de una**, y cada ejecución es una traza observable. Frente a un adversario con acceso a canales laterales (consumo, temporización, emisión electromagnética) —el escenario de un HSM o una tarjeta bajo ataque físico—, disponer de $N$ trazas de la expansión de la *misma* semilla es precisamente la condición que habilita el análisis diferencial. La residencia efímera, por tanto, **no domina** a la política de caché: intercambia una superficie por otra.

| Amenaza dominante | Clave cacheada | KeyGen por firma |
|---|---|---|
| Volcado de memoria, *core dump*, *cold boot*, introspección de hipervisor | expuesta de forma **permanente** | expuesta ~0,4–1,2 ms por firma |
| Canal lateral sobre la expansión (DPA, temporización, EM) | **1** traza (al arranque) | **$N$** trazas (una por firma) |

La política es la elección correcta cuando el adversario dominante es el que **lee memoria** —servidor multiinquilino, nube, riesgo de volcado: el escenario de Storm-0558— y la equivocada cuando el adversario dominante tiene **acceso físico** al firmador. Como esta tesis declara los canales laterales fuera de alcance (Cap. 1 §1.2; Cap. 6 §6.7), la afirmación defendible se acota en consecuencia: *bajo un modelo de amenaza de lectura de memoria, y con una implementación `constant-time` de `KeyGen` como la de `fips204`, la residencia efímera reduce la superficie de exposición a un costo de latencia despreciable*. Su evaluación bajo un modelo de canal lateral —junto con la contramedida natural, que ya está en el diseño: la rotación por uso de §5.5 acota $N$ por semilla, de modo que ninguna semilla acumula trazas indefinidamente— queda como trabajo futuro (Cap. 7, §7.5).

**Ingeniería de memoria.** La política se apoya en controles estándar: borrado resistente a *dead-store elimination* (`zeroize`), bloqueo de páginas para impedir su paso al *swap* (`mlock`/`VirtualLock`), exclusión de la memoria criptográfica de los volcados (`MADV_DONTDUMP`) y, en entornos de alta amenaza, ejecución en enclaves cifrados (TEE).

> **Nota de cumplimiento (FIPS).** NIST confirma que almacenar y re-expandir $\xi$ es conforme a FIPS 204, pero el perfil vigente **no permite derivar $\xi$ de otra semilla mediante un KDF** (pqc-forum, oct. 2024). La cadena de épocas de §5.5 debe por tanto leerse como endurecimiento *forward-secure* del material de la aplicación: en un despliegue con certificación FIPS estricta, cada $\xi_e$ se generaría directamente del RBG aprobado (con la mezcla de §5.5 declarada fuera del perfil, o sustituida por *reseeding* del DRBG).

---

## 5.7 La tubería unificada

Los elementos anteriores forman un único ciclo de vida, que unifica los Objetivos 2 y 3:

```
   ┌──────────────────┐   pruebas de salud (RCT/APT, SP 800-90B)
   │ FUENTE DE        │──────────────┐ falla → BLOQUEO + reseed
   │ ENTROPÍA         │              ▼
   │ (min-entropía)   │        ┌───────────┐
   └────────┬─────────┘        │  SALUD OK │
            │ material         └─────┬─────┘
            ▼                        │
   ┌──────────────────┐             ▼
   │  KDF (SHAKE256/   │   separación de dominio + epoch
   │  HKDF) → semilla ξ│
   └────────┬─────────┘
            ▼
   ┌──────────────────┐
   │ ML-DSA.KeyGen(ξ) │   (Cap. 4, §4.5) — determinística
   │ → (pk, sk)       │
   └────────┬─────────┘
            ▼
   ┌──────────────────┐   disparadores: uso / edad / fallo de salud
   │ ROTACIÓN forward-│──────────────┐
   │ secure + auditoría│             │ ξ_{e+1}=H(dom‖ξ_e‖fresco‖e), zeroiza ξ_e
   └──────────────────┘◄─────────────┘  (identidad de cuenta estable)
```

Esta tubería convierte dos objetivos antes inconexos (la firma del Obj. 2 y la entropía del Obj. 3) en **una sola historia coherente de gestión de claves**: fuente sana → semilla → clave → rotación, con secrecia hacia adelante y trazabilidad.

---

## 5.8 Estado de implementación y limitaciones

| Componente | Estado |
|---|---|
| Rotación por política (uso/edad/**fallo de salud**) + mezcla forward-secure + auditoría | **Implementado** |
| Métrica de calidad de la fuente (**min-entropía**, ya no Shannon-de-la-semilla) | **Implementado** (§5.2) |
| Pruebas de salud en línea **NIST SP 800-90B (RCT/APT)** + bloqueo ante degradación | **Implementado** en `entropy.rs` (con tests) |
| KDF determinístico fuente→semilla (SHA3, dominio separado) | **Implementado** (en `SentinelSeed`) |
| `KeyGen` reproducible de Dilithium desde semilla | **Implementado** (migrado a `fips204`; test `test_deterministic_from_seed`, Cap. 4 §4.5) |
| Política de residencia efímera (KeyGen JIT por firma + `zeroize`) | **Medida empíricamente** (§5.6; benchmark dedicado 2026-07-31); su integración como política configurable del firmador es trabajo en curso |

> **Estado (Fase B completada y verificada con tests).** La reformulación del Objetivo 3 está **implementada**: la métrica es la min-entropía de la fuente; las pruebas de salud SP 800-90B (RCT/APT) **bloquean** la derivación ante degradación; la rotación forward-secure añade el disparador por fallo de salud. Y la `KeyGen` reproducible de Dilithium desde semilla quedó **implementada** al migrar a `fips204` (Cap. 4 §4.5), cerrando el componente determinístico del Objetivo 2.

---

## 5.9 Conclusiones del capítulo

Este capítulo desarrolló la gestión activa del ciclo de vida de claves (Objetivo 3):

1. Reemplazó la **métrica errónea** (entropía de Shannon de la semilla) por la **min-entropía de la fuente**, criptográficamente pertinente y conforme a NIST SP 800-90B.
2. Definió el **monitoreo de salud en línea** (RCT/APT) como el verdadero "monitoreo activo de entropía", con **bloqueo** de la derivación ante degradación.
3. Especificó la **derivación por KDF** que une la fuente con la `KeyGen` determinística (Cap. 4), y la **rotación con secrecia hacia adelante** disparada por política, con auditoría e identidad de cuenta estable.
4. Unificó los Objetivos 2 y 3 en una **tubería única** de gestión de claves.
5. Propuso y midió la **política de residencia efímera** (§5.6): en reposo solo la semilla de 32 B (formato hoy recomendado por el RFC 9881), lo que **cambia la categoría de custodia** del secreto —de montón paginable a material sellable en TPM/HSM— en vez de meramente reducir su tamaño; la clave expandida vive solo durante la firma, a un sobrecosto medido de **+0,12 ms** (perfil H2; +0,75 ms en H1). La **ventana de exposición** $W=\text{bytes}\times\Delta t$ se propone como cuantificador **heurístico** de política —no como cota de probabilidad de compromiso— y el *trade-off* frente a la guía vigente (que recomienda cachear) se declara explícitamente: la política reduce la exposición a lectura de memoria y **aumenta** el número de trazas disponibles para un análisis de canal lateral, escenario declarado fuera de alcance. Política y métrica no tienen formalización previa localizada en la literatura.

Con ello, el **Objetivo 3 queda atendido** sobre bases rigurosas, eliminando la fragilidad conceptual del enfoque original.

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
