# Capítulo 7 — Conclusiones y Trabajo Futuro

### (Cierre del arco, balance de objetivos y agenda)

> **Rol en el arco de la tesis.** Este capítulo cierra el círculo: recoge el arco narrativo, hace un balance **honesto** de lo logrado frente a cada objetivo, enuncia las contribuciones y las limitaciones declaradas, y deja una agenda de trabajo futuro priorizada.

---

## 7.1 Síntesis: el arco completado

Esta tesis se construyó como una sola cadena de razonamiento, y cada capítulo entregó su eslabón:

| Eslabón | Capítulo | Qué se estableció |
|---|---|---|
| **Amenaza** | 1 | El adversario cuántico recupera claves (Shor) y falsifica firmas de banca; HNDL hace la migración urgente. |
| **Requisitos del dominio** | 1 | Seis requisitos bancarios (R1–R6: autenticidad normativa, horizonte de décadas, cripto-agilidad, custodia gobernada, trazabilidad auditable, finalidad determinista), anclados en el *Project Leap* del BIS, DORA y los marcos de migración del sector. |
| **Fundamentos** | 2 | Retículos, Dilithium, estándares NIST, entropía, y la distinción Groth16 (roto)/STARK (PQ). |
| **Costo + Respuesta + Coherencia** | 3 | La PQC cuesta ~50× en datos (~20× de throughput); el dual-chain lo amortiza a ~$d$; el verificador debe ser STARK. |
| **Solución** | 4 | Dilithium implementado y ligado a la transacción; derivación determinística por KDF. |
| **Capa operativa** | 5 | Min-entropía + salud SP 800-90B + rotación con secrecia hacia adelante. |
| **Validación** | 6 | Reducción a Module-LWE/MSIS → Mod-SIVP (resistente a Shor) + análisis de complejidad. |

El resultado es una respuesta coherente a la pregunta central del Capítulo 1: **se puede asegurar las firmas de una blockchain bancaria contra la amenaza cuántica sin sacrificar la escalabilidad, si la arquitectura dual-chain amortiza el sobrecosto post-cuántico y su capa de verificación es ella misma post-cuántica.**

## 7.2 Balance de los objetivos

Se reporta el grado de cumplimiento de cada objetivo con honestidad, distinguiendo lo **modelado**, lo **implementado/verificado** y lo **pendiente**:

**Objetivo 1 — Diseñar la arquitectura Dual-Chain.** *Cumplido como modelo de referencia.* Se especificaron los roles de L1/L2, el camino de la firma post-cuántica, el modelo de cuenta (identidad estable vs. clave rotable), la disponibilidad de datos estilo PeerDAS, la secuenciación con incentivos y la finalidad rápida (Cap. 3). La realización **operativa** del consenso y la DA es trabajo futuro; el verificador post-cuántico (Nitro Verifier) cuenta ya con un **PoC STARK implementado** (Cap. 3, §3.5).

**Objetivo 2 — Núcleo criptográfico PQC.** *Cumplido.* Dilithium (firma/verificación, multinivel) está **implementado y verificado** sobre la biblioteca auditada `fips204` (ML-DSA / FIPS 204), con enlace correcto a la transacción (Cap. 4). La **derivación determinística desde semilla** está **implementada y verificada** (`from_seed` usa la `KeyGen` semillada de `fips204`; test `test_deterministic_from_seed`).

**Objetivo 3 — Lógica de seguridad activa.** *Cumplido.* La rotación con secrecia hacia adelante, la **min-entropía de la fuente** y las **pruebas de salud NIST SP 800-90B (RCT/APT)** con bloqueo ante degradación están **implementadas y verificadas con tests** (Cap. 5), reemplazando la métrica errónea de entropía de Shannon de la semilla.

**Objetivo 4 — Validación formal.** *Cumplido en su componente formal.* Se desarrolló la **cadena de reducciones** (in-forjabilidad fuerte → Module-LWE + SelfTargetMSIS + Module-SIS → Mod-SIVP de peor caso, con la no aplicabilidad de Shor) y el **análisis de complejidad** $O(k\ell\,n\log n)$ (Cap. 6). La **validación empírica** (benchmarks reales de Dilithium) está **completada** y reportada en el Cap. 6 §6.6 (Tabla 6.2).

## 7.3 Contribuciones

Se ordenan por **grado de originalidad** y no por orden de aparición: primero lo que la revisión de la literatura no encontró previamente formulado, y después la síntesis, la cuantificación y la instanciación —donde reside el grueso del trabajo, y que se declara como tal (§7.4)—.

### A. Aportes sin antecedente localizado en la literatura

1. **La política de residencia efímera de la clave** (Cap. 5, §5.6). La custodia *seed-only* ya es estándar —FIPS 204 §3.6.3 la permite y el RFC 9881 la declara el formato recomendado— y **no se reclama como aporte**; lo que se propone es elevarla a **política de firma**: regenerar el par ML-DSA desde la semilla en cada operación y zeroizarlo, **en contra de la recomendación explícita de la guía IETF vigente**, que sugiere cachear la clave expandida [Connolly26]. El aporte incluye tres piezas: su **medición** (+0,12 ms por firma en el perfil H2; +0,75 ms en H1, con *benchmark* reproducible versionado), el argumento de que el beneficio real es un **cambio de categoría de custodia** —32 B sellables en TPM/HSM frente a ~4 KB residentes en montón paginable— y no un mero cociente de tamaños, y el ***trade-off* declarado** frente al modelo de canal lateral, que la política empeora y que esta tesis deja fuera de alcance.
2. **La métrica de ventana de exposición** $W=\text{bytes}\times\Delta t$ (Cap. 5, §5.6), propuesta como cuantificador **heurístico** de una política de residencia —con su estatus explícitamente acotado (no es una cota de probabilidad de compromiso: la semilla compromete tanto como la clave expandida) y su punto de equilibrio derivado, $\lambda\approx 2.300$ firmas/s—. Lo más cercano localizado en la literatura mide residencia de claves en RAM sin criptografía post-cuántica [Sawa25].
3. **La propuesta del *Deception Engine*** (§7.5): conmutación del firmador a un par señuelo ML-DSA ante detección de observación, con el *sequencer* L2 como *honeychecker*. Es una **propuesta de diseño argumentada frente al estado del arte** (no una implementación): la revisión de jul. 2026 no localiza ningún trabajo que combine señuelos criptográficos con firmas post-cuánticas ni con respuesta coordinada en L2.

### B. Aportes de síntesis, cuantificación e instanciación

4. **El análisis cuantificado del sobrecosto post-cuántico** (Cap. 3): el hallazgo de que el cuello de botella es de **datos, no de cómputo**, y la demostración de que el dual-chain amortiza el costo on-chain por transacción al de su diferencia de estado clásica.
5. **El principio de coherencia post-cuántica del sistema de pruebas** (el verificador L2 debe ser STARK, no Groth16), sustanciado con un **PoC STARK propio sin emparejamientos** y con la **tensión Dilithium-vs-STARK-friendliness** identificada como decisión de diseño consciente.
6. **La reformulación rigurosa de la gestión activa de claves** (min-entropía + SP 800-90B + rotación forward-secure), que reemplaza un enfoque conceptualmente frágil (la entropía de Shannon de la semilla) por uno normativamente fundado.
7. **La validación formal instanciada para NEXUS**: la cadena de reducciones ensamblada con la cota correcta de **tres términos** y el argumento de resistencia cuántica con la estimación *core-SVP* (~0,91×, no "la mitad") —resultados citados e instanciados, no re-demostrados (Cap. 6, §6.1)—.
8. **El modelo de cuenta** (identidad estable, política de verificación, *epoch*) + Registro de Claves, que resuelve la coexistencia de rotación/migración PQC con identidad estable.
9. **La integración de todo lo anterior** en un modelo formal y prototipo de referencia de firmas post-cuánticas sobre una arquitectura dual-chain para banca, con el núcleo de firma genuinamente implementado y verificado.

## 7.4 Limitaciones

Se declaran con franqueza, pues delimitan honestamente el aporte:

- **Modelo, no producto.** El entregable es un modelo formal + prototipo de referencia. La pieza más compelente —la amortización dual-chain— está **rigurosamente analizada y parcialmente construida**: Dilithium es real, y el **verificador STARK post-cuántico que la materializa cuenta ya con un PoC implementado, endurecido (~100 bits) y probado por una batería adversarial** (FRI + Merkle/SHA3, desafíos en $F_{p^2}$, grinding, verificación sucinta; Cap. 3, §3.5), con validación por software, no por reducción formal; su AIR sigue siendo ilustrativo (aritmetización bancaria completa) y la incorporación de DEEP son trabajo futuro.
- **Seguridad del primitivo, no del sistema completo.** La validación garantiza in-falsificabilidad **a nivel de transacción**, condicionada al **supuesto de consenso honesto-mayoritario** (el consenso operativo es diseño de referencia).
- **Novedad de síntesis.** El aporte no es un resultado de frontera —la frontera (Ethereum, Solana) converge hacia lo mismo—, sino su **síntesis formal y cuantificada** para banca; la convergencia se interpreta como **validación**.
- **El encuadre bancario es de requisitos, no de certificación.** Los requisitos R1–R6 (Cap. 1, §1.3) se usan como **criterio de diseño** —cada decisión de los Caps. 3–5 es trazable a uno de ellos— pero el trabajo **no** demuestra conformidad: no hay certificación FIPS 140-3 del módulo, ni integración con mensajería ISO 20022, ni validación contra un régimen jurisdiccional concreto. La distancia entre «atiende el requisito como modelo» y «cumple el requisito como producto» se declara y no se cruza.
- **El Objetivo 3 es una rama necesaria pero lateral** del arco central (firmas + dual-chain + validación).
- **Fuera de alcance:** confidencialidad post-cuántica (requeriría un KEM), seguridad de implementación (canales laterales, fallos), y la biometría (eliminada).

## 7.5 Trabajo futuro

Agenda priorizada, derivada de las limitaciones:

1. **Cimientos y evidencia empírica** — **HECHO (2026-06-04/05):** el workspace **compila por completo** y los **109 tests unitarios pasan** (incluidos los 33 del STARK del Nitro Verifier, con batería adversarial); los **benchmarks** del Cap. 6 §6.6 son mediciones reales.
2. **Obj. 2 y 3 en código** — **HECHO:** se removió la biometría; la **min-entropía + las pruebas de salud NIST SP 800-90B (RCT/APT)** con bloqueo ante degradación, y la **`KeyGen` determinística desde semilla** (migración a `fips204` / FIPS 204), están implementadas y verificadas con tests.
3. **Verificador post-cuántico (la pieza clave).** — **PoC HECHO y ENDURECIDO (2026-06-05):** se implementó un **STARK hash-based propio** (`nexus-zk::stark`: Goldilocks + NTT + Merkle/SHA3 con separación de dominio + Fiat–Shamir + FRI) cableado al Nitro Verifier (`nexus-active::pq_verifier`), con **verificación sucinta** medida, **sin emparejamientos** (Shor no aplica) y **endurecido a ~100 bits de soundness** (desafíos en el campo de extensión $F_{p^2}$, grinding, 40 consultas; batería de pruebas adversariales). Resta **extenderlo a producción**: aritmetizar la **máquina de estado bancaria completa** (el AIR actual es ilustrativo), incorporar **DEEP/out-of-domain** (para 100 bits sin la conjetura de *proximity gaps*), y abordar el reto de investigación de **probar la verificación de firmas Dilithium en circuito** (costoso para esquemas reticulares); evaluar como alternativa la agregación de firmas hash-based, más STARK-friendly (cf. Cap. 3, §3.5.1).
4. **Consenso BFT operativo.** Verificación de firmas de voto, quórum ponderado por *stake* ($\lfloor 2N/3\rfloor+1$), detección de equivocación + *slashing*, y difusión en red — para **levantar el supuesto** de consenso honesto y validar la seguridad a nivel de sistema.
5. **Disponibilidad de datos real.** *Erasure coding* (Reed-Solomon) + muestreo entre pares (estilo PeerDAS) + poda.
6. **Abstracción de cuentas + Registro de Claves completos**, para cripto-agilidad y migración (firmas híbridas clásica+PQ).
7. **Confidencialidad post-cuántica.** Integrar un KEM (ML-KEM / Kyber, FIPS 203) para cerrar la amenaza HNDL de confidencialidad, hoy fuera de alcance.
8. **Exploración de esquemas alternativos.** Evaluar **Falcon** (FN-DSA, FIPS 206) para recortar el sobrecosto de ~50× a ~10×, ponderando su complejidad de implementación, una vez finalizado el estándar (~fin 2026).
9. **Deception Engine (defensa activa off-chain).** Implementar la conmutación del firmador a un **par señuelo ML-DSA** ante fallo de atestación o detección de depuración/introspección, con el *sequencer* L2 como *honeychecker* que bloquea la transacción y dispara la alerta al reconocer la clave señuelo. Requisitos derivados de la literatura: **indistinguibilidad formal** del señuelo y de sus metadatos —las bóvedas señuelo de NoCrack cayeron por análisis estadístico (CCS 2016) y los *canary tokens* de AWS por metadatos— y conmutación en **tiempo constante**; a favor, un par ML-DSA señuelo generado con la misma `KeyGen` es idéntico en distribución a uno real. Antecedentes parciales: honeywords/*honeychecker* [JR13], claves señuelo estáticas de la patente US 10,521,584 B1, y custodia TEE con atestación on-chain (Puffer Secure-Signer). Nota criptográfica: la respuesta **nunca** altera el nonce de Fiat-Shamir (un nonce sesgado filtra $s_1$ por reducción de retículos); el señuelo es un par legítimo e independiente. Complementos: **Threshold ML-DSA** (fragmentación de $s_1$ por MPC) para que ningún proceso contenga la clave completa.

## 7.6 Reflexión final

La amenaza cuántica a la criptografía financiera dejó de ser especulativa: los estándares post-cuánticos están finalizados y las cadenas de mayor valor han comenzado su migración. En este contexto, NEXUS aporta lo que un trabajo de grado puede aportar con rigor: **un modelo formal y cuantificado de cómo asegurar las firmas de banca contra la amenaza cuántica a un costo tractable**, con su núcleo criptográfico implementado y su seguridad validada.

El hecho de que **Ethereum y Solana hayan convergido, de forma independiente y simultánea, hacia los mismos principios** que esta tesis formaliza —firmas post-cuánticas, agregación por pruebas para domar el sobrecosto, y sistemas de prueba post-cuánticos— no resta originalidad al trabajo: la **confirma**. NEXUS llega a las mismas conclusiones que la frontera de la industria por un camino formal e independiente, y deja una agenda clara para convertir el modelo en un sistema. Esa es, modestamente, su contribución.
