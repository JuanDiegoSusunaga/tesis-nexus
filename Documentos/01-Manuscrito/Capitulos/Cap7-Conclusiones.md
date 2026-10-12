# Capítulo 7 — Conclusiones y Trabajo Futuro

*Cierre del arco, balance de objetivos y agenda*

> **Rol en el arco de la tesis.** Este capítulo cierra el círculo: recoge el arco narrativo, hace un balance **honesto** de lo logrado frente a cada objetivo, enuncia las contribuciones y las limitaciones declaradas, y deja una agenda de trabajo futuro priorizada.

---

## 7.1 Síntesis: el arco completado

Esta tesis se construyó como una sola cadena de razonamiento, y cada capítulo entregó su eslabón:

**Tabla 7.1 — Síntesis: el arco completado.**

| Eslabón | Capítulo | Qué se estableció |
|---|---|---|
| **Amenaza** | 1 | El adversario cuántico recupera claves (Shor) y falsifica firmas digitales de los sistemas; HNDL hace la migración urgente. |
| **Fundamentos** | 2 | Retículos, Dilithium, estándares NIST, entropía, y la distinción Groth16 (roto)/STARK (PQ). |
| **Costo + Respuesta + Coherencia** | 3 | Modelo de sobrecosto de datos y amortización por lotes; TG2 explicita condiciones y sensibilidad en §6.6.5. |
| **Solución** | 4 | Dilithium implementado y ligado a la transacción; derivación determinística por KDF. |
| **Capa operativa** | 5 | Min-entropía + salud SP 800-90B + rotación con secrecia hacia adelante. |
| **Validación** | 6 | Fundamentos citados, condiciones de aplicación, complejidad y evidencia de componentes; revisión formal pendiente. |

El resultado es un modelo para proteger firmas digitales de sistemas de distintos dominios y estudiar la amortización de su sobrecosto. La viabilidad del sistema completo depende de probar la lógica de aplicación, disponer de los datos y satisfacer las condiciones de seguridad e integración identificadas en TG2.

## 7.2 Balance de los objetivos

Se reporta el grado de cumplimiento de cada objetivo con honestidad, distinguiendo lo **modelado**, lo **implementado/verificado** y lo **pendiente**:

**Objetivo 1 — Diseñar la arquitectura Dual-Chain.** *Cumplido como modelo de referencia.* Se especificaron los roles de L1/L2, el camino de la firma post-cuántica, el modelo de cuenta (identidad estable vs. clave rotable), la disponibilidad de datos estilo PeerDAS, la secuenciación con incentivos y la finalidad rápida (Cap. 3). La realización **operativa** del consenso y la DA es trabajo futuro; el verificador post-cuántico (Nitro Verifier) cuenta ya con un **PoC STARK implementado** (Cap. 3, §3.5).

**Objetivo 2 — Núcleo criptográfico PQC.** *Cumplido.* Dilithium (firma/verificación, multinivel) está **implementado y verificado** mediante el backend `fips204` (ML-DSA / FIPS 204), con enlace correcto a la transacción (Cap. 4). La **derivación determinística desde semilla** está **implementada y verificada** (`from_seed` usa la `KeyGen` semillada de `fips204`; test `test_deterministic_from_seed`).

**Objetivo 3 — Lógica de seguridad activa.** *En ejecución técnica.* El 22 de septiembre se corrigieron el corte APT, la evaluación por lotes y la recuperación con bloqueo hasta reevaluar y renovar la semilla; la suite pasó 142 pruebas en R3 y 163 al integrar los casos de validación R4 y R5; tras R1, las revisiones STARK y la variante FRI vinculada alcanza 197. Las decisiones 001 y 002 fueron aprobadas según la confirmación del estudiante. El gestor renueva efectivamente las claves y registra las transiciones con firmas salientes y entrantes. Se ha probado la recuperación del historial público, el rechazo de épocas retiradas para operaciones vigentes y la detección de retrocesos respecto de un punto de control confiable. Permanecen pendientes la custodia durable, la integración con L2/L1 y la vinculación y calificación de una fuente concreta (Cap. 5, §§5.3 y 5.8).

**Objetivo 4 — Validación formal y empírica.** *En revisión y consolidación.* R1 identifica ML-DSA puro, hedged y de contexto vacío, coteja los parámetros de fips204 0.4.6 y distingue las pruebas ROM/QROM. El contraste numérico impide aplicar directamente el teorema revisado de SelfTargetMSIS a estos parámetros; se mantienen explícitos ese supuesto y los pasos entre plantilla y código. Se conserva el análisis de complejidad $O(k\ell\,n\log n)$ y las mediciones históricas de componentes. R4 y su complemento aportan 29 casos Criterion, 40 mediciones STARK y 40 repeticiones multinúcleo con fuentes y dispersión. Reproduce las limitaciones del verificador y evalúa una variante para escalares canónicos; no acredita raíces arbitrarias ni conocimiento cero. La latencia ML-DSA y el ensayo multinúcleo corregido se completaron después del cambio de Windows por el autor, conservando los fallos previos. La auditoría STARK identifica consultas efectivas, proximidad y composición pendiente; siete casos nuevos pasan también en release. El argumento algebraico condicional delimita cancelación y distancia de la composición; otros siete casos pasan también en release. El ensayo posterior refuta que la aceptación heredada implique la proximidad de traza propuesta: acepta tres casos a distancia 7/8, con enunciados válidos. Un control exhaustivo experimental los rechaza por grado; otros siete casos pasan también en release. La variante posterior comparte la raíz de traza entre AIR y un FRI de cota menor que T; acepta los casos honestos y detecta los tres contraejemplos sin recibir el LDE completo. Sus diez pruebas pasan también en release. La suite completa alcanza 197 pruebas en desarrollo. La vinculación estructural está implementada. Una derivación posterior fija el candidato próximo y obtiene una cota conservadora de composición en el modelo interactivo ideal; la auditoría Merkle/Fiat–Shamir reconstruye el corpus con aritmética Python y `hashlib`, independientes del verificador Rust, cuantifica el sesgo bajo salidas frescas y delimita las obligaciones por ronda y ROM/QROM pendientes. Los complementos de §§6.7.8–6.7.9 proponen solidez por rondas y transferencia ROM con registro hash y potencial para nonces adaptativos. El catálogo explicita su trazabilidad. La revisión matemática externa, R1-A–E, el estudio de parámetros y la conciliación histórica permanecen pendientes. QROM completo de AIR/FRI se conserva como trabajo futuro, según la decisión de alcance del autor.

## 7.3 Contribuciones

1. **Un modelo formal y prototipo de referencia** de firmas post-cuánticas (Dilithium) en una arquitectura dual-chain para sistemas en general, con operaciones de firma implementadas y comprobadas funcionalmente.
2. **El análisis cuantificado del sobrecosto post-cuántico** (Cap. 3): la cuantificación del aumento de datos y un modelo de amortización sujeto a prueba de la lógica, disponibilidad y costo del prover. La sensibilidad de TG2 (§6.6.5) explicita cómo cambian los resultados con esos supuestos.
3. **El requisito de coherencia post-cuántica de la capa de pruebas** (su seguridad debe justificarse en el modelo de amenaza), con la **tensión Dilithium-vs-STARK-friendliness** identificada como decisión de diseño consciente.
4. **La trazabilidad de los fundamentos de seguridad:** identificación de MLWE, SelfTargetMSIS y MSIS, de las condiciones de las reducciones y de los límites para aplicarlas al prototipo (Cap. 6, §6.4).
5. **La gestión activa de claves** mediante min-entropía, pruebas de salud y rotación por épocas, con las condiciones de custodia y destrucción necesarias para evaluar secrecia hacia adelante (§5.8).
6. **El modelo de cuenta** (identidad estable, política de verificación, *epoch*) + Registro de Claves, que resuelve la coexistencia de rotación/migración PQC con identidad estable.
7. **La evaluación de residencia efímera de claves:** comparación de clave cacheada y reexpansión por firma, con sobrecostos históricos aproximados de 0,75 ms en H1 y 0,12 ms en H2. R5 incorpora inventario de representaciones, modelo de captura, sensibilidad y tres pruebas. Conservar la semilla mantiene la capacidad de firma. W describe regiones y tiempos bajo hipótesis explícitas; la observación de todas las copias y la custodia protegida siguen pendientes (Cap. 5, §5.6).
8. **La propuesta del *Deception Engine*** (§7.5): conmutación del firmador a un par señuelo ML-DSA ante detección de observación, con el *sequencer* L2 como *honeychecker*. Es una **propuesta de diseño argumentada frente al estado del arte** (no una implementación): la revisión de jul. 2026 no localiza ningún trabajo que combine señuelos criptográficos con firmas post-cuánticas ni con respuesta coordinada en L2.

## 7.4 Limitaciones

Se declaran con franqueza, pues delimitan honestamente el aporte:

- **Alcance del prototipo.** La arquitectura dual se entrega como modelo y el STARK como PoC de una transición ilustrativa. Las restricciones del puente de raíces, la aceptación heredada, la recuperación del testigo del ejemplo pequeño y el presupuesto de soundness se detallan en Cap. 6, §6.7. Las mediciones no validan la ejecución completa de una aplicación.
- **Garantías condicionales.** La seguridad del esquema de firma requiere los supuestos y la correspondencia descritos en Cap. 6. La autorización, la vigencia de claves, las transiciones, el consenso y la disponibilidad de datos requieren validación propia.
- **Aplicabilidad a distintos dominios.** El modelo se plantea para sistemas en general; su adaptación a cada aplicación requiere definir y validar sus reglas de autorización y transición de estado. Los experimentos del prototipo no acreditan su funcionamiento en todos los dominios.
- **Novedad de síntesis.** El aporte no es un resultado de frontera —la frontera (Ethereum, Solana) converge hacia lo mismo—, sino su **síntesis formal y cuantificada** para sistemas en general; las coincidencias con propuestas externas aportan contexto y no sustituyen la validación propia.
- **El Objetivo 3 es una rama necesaria pero lateral** del arco central (firmas + dual-chain + validación).
- **Fuera de alcance:** confidencialidad post-cuántica (requeriría un KEM), seguridad de implementación (canales laterales, fallos), y la biometría (eliminada).

## 7.5 Trabajo futuro

Agenda priorizada, derivada de las limitaciones:

1. **Consolidación de evidencia empírica.** La ejecución histórica consolidada alcanza 197 pruebas; los conteos anteriores se conservan como registros de sus etapas. La serie R4 preserva mediciones nuevas de clásicos, residencia y STARK; el complemento registra la ejecución satisfactoria de los dos benchmarks inicialmente bloqueados y su nueva configuración. La caché recuperada y H1/H2 conservan su procedencia histórica.
2. **Cierre del Objetivo 3.** Tras comprobar monitor, rotación efectiva y registro local, integrar la custodia durable y la política de épocas en L2, y validar el anclaje externo. Para un despliegue concreto debe vincularse el flujo observado con la fuente utilizada y documentar su calificación. La reexpansión de una misma semilla por firma y la rotación de épocas son operaciones diferentes.
3. **Revisión de las derivaciones y extensión futura.** Resolver M1–M6 para las afirmaciones incluidas en la entrega, conservando el estado de demostración propuesta de la composición ideal y ROM. Completar la transferencia QROM de AIR/FRI, incluida la omisión $\beta^S$, queda como investigación futura por decisión del autor. La aritmetización de ML-DSA y de la aplicación, el enlace de raíces completas y la ocultación del testigo constituyen extensiones independientes; su realización no se infiere de la curva del AIR actual.

## 7.6 Reflexión final

La amenaza cuántica a la criptografía de los sistemas digitales dejó de ser especulativa: los estándares post-cuánticos están finalizados y las cadenas de mayor valor han comenzado su migración. En este contexto, NEXUS aporta lo que un trabajo de grado puede aportar con rigor: **un modelo formal y cuantificado de cómo asegurar las firmas digitales de los sistemas contra la amenaza cuántica a un costo tractable**, con su núcleo criptográfico implementado y con las condiciones y límites de seguridad identificados para su validación.

NEXUS aporta una síntesis de arquitectura, gestión de claves y evaluación de componentes, con resultados reproducibles y límites explícitos. Completar las obligaciones formales identificadas por R1 y las integraciones pendientes permitirá evaluar el paso del modelo a un sistema operativo; la coincidencia con propuestas externas no demuestra ese resultado.
