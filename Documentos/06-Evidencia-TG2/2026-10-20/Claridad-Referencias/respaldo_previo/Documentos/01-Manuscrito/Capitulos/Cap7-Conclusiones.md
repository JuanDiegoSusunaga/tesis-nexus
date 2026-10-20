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
| **Fundamentos** | 2 | Retículos, ML-DSA, estándares NIST y entropía; distinción entre emparejamientos vulnerables a Shor y argumentos hash/FRI cuya seguridad cuántica exige justificación propia. |
| **Costo + Respuesta + Coherencia** | 3 | Modelo de sobrecosto de datos y amortización por lotes; El modelo explicita condiciones y sensibilidad en §6.6.5. |
| **Solución** | 4 | Dilithium implementado y ligado a la transacción; derivación determinística por KDF. |
| **Capa operativa** | 5 | Monitor de salud y rotación por épocas; fuente, custodia y borrado condicionan las garantías de entropía y secrecia hacia adelante. |
| **Validación** | 6 | Fundamentos citados, complejidad, evidencia de componentes y cota conservadora ROM demostrada en Lean; equivalencia universal con Rust no demostrada. |

El resultado es un modelo para proteger firmas digitales de sistemas de distintos dominios y estudiar la amortización de su sobrecosto. La viabilidad del sistema completo depende de probar la lógica de aplicación, disponer de los datos y satisfacer las condiciones de seguridad e integración identificadas en el análisis.

## 7.2 Balance de los objetivos

Se reporta el grado de cumplimiento de cada objetivo con honestidad, distinguiendo lo **modelado**, lo **implementado/verificado** y lo **pendiente**:

**Objetivo 1 — Diseñar la arquitectura Dual-Chain.** *Cumplido como modelo de referencia.* Se especificaron los roles de L1/L2, el camino de la firma post-cuántica, el modelo de cuenta (identidad estable vs. clave rotable), la disponibilidad de datos estilo PeerDAS, la secuenciación con incentivos y la finalidad rápida (Cap. 3). La realización **operativa** del consenso y la DA es trabajo futuro; el verificador post-cuántico (Nitro Verifier) cuenta ya con un **PoC STARK implementado** (Cap. 3, §3.5).

**Objetivo 2 — Núcleo criptográfico PQC.** *Cumplido funcionalmente.* La firma/verificación multinivel está implementada y comprobada mediante `fips204`. Las transacciones firman un digest externo SHA3-256; la garantía de contenido depende de su resistencia a colisiones, de la codificación y de las correspondencias de R1 (Cap. 4 y §6.4). La derivación determinística desde semilla está comprobada (`from_seed` y `test_deterministic_from_seed`); no equivale a certificación independiente del backend ni de la fuente.

**Objetivo 3 — Lógica de seguridad activa.** *Implementación y validación funcional del prototipo local; garantía de secrecia hacia adelante condicionada.* El gestor incorpora evaluación por lotes, bloqueo ante fallos de salud, recuperación mediante reevaluación y renovación de semilla, rotación de claves operativas y un registro autenticado de épocas. La suite de 197 pruebas incluye recuperación del historial público, rechazo de épocas retiradas y detección de retrocesos respecto de un punto de control confiable. Permanecen pendientes la custodia durable, la integración con L2/L1 y la vinculación y calificación de una fuente concreta (Cap. 5, §§5.3 y 5.8); no se atribuye a esos ensayos una demostración de eliminación de todas las copias ni de secrecia hacia adelante del despliegue.

**Objetivo 4 — Validación formal y empírica.** *Cumplimiento parcial de la reducción concreta de seguridad de las firmas; resultados demostrados para los modelos y validación de componentes.* El análisis identifica el perfil ML-DSA implementado, distingue ROM y QROM y explicita las condiciones que impiden atribuir automáticamente las reducciones citadas al código. Se presenta la complejidad de las operaciones y evidencia de componentes: 29 casos Criterion, 40 mediciones STARK y 40 repeticiones multinúcleo. Las series H1/H2 conservan límites de procedencia. Los contraejemplos de proximidad justifican distinguir el verificador básico del verificador vinculado con raíz compartida. Este contrato está incorporado a Rust y conectado con `ActiveChain` mediante contexto local, con pruebas aisladas de aceptación, rechazo y concurrencia. Para el verificador matemático se demuestra en Lean una cota conservadora de aceptación falsa en ROM clásico finito, con consultas adaptativas, trabajo, reinicios y muestra compartida (§6.7.9). El refinamiento universal del ejecutable, una garantía concreta de inforjabilidad del código y la transferencia cuántica completa de AIR/FRI no se deducen de ese resultado.

## 7.3 Contribuciones

1. **Un modelo formal y prototipo de referencia** de firmas post-cuánticas (Dilithium) en una arquitectura dual-chain para sistemas en general, con operaciones de firma implementadas y comprobadas funcionalmente.
2. **El análisis cuantificado del sobrecosto post-cuántico** (Cap. 3): la cuantificación del aumento de datos y un modelo de amortización sujeto a prueba de la lógica, disponibilidad y costo del prover. La sensibilidad del modelo (§6.6.5) explicita cómo cambian los resultados con esos supuestos.
3. **El requisito de coherencia post-cuántica de la capa de pruebas** (su seguridad debe justificarse en el modelo de amenaza), con la **tensión Dilithium-vs-STARK-friendliness** identificada como decisión de diseño consciente.
4. **La trazabilidad de los fundamentos de seguridad:** identificación de MLWE, SelfTargetMSIS y MSIS, de las condiciones de las reducciones y de los límites para aplicarlas al prototipo (Cap. 6, §6.4).
5. **La gestión activa de claves** mediante min-entropía, pruebas de salud y rotación por épocas, con las condiciones de custodia y destrucción necesarias para evaluar secrecia hacia adelante (§5.8).
6. **El modelo de cuenta** (identidad estable, política de verificación, *epoch*) + Registro de Claves, que resuelve la coexistencia de rotación/migración PQC con identidad estable.
7. **La evaluación de residencia efímera de claves:** comparación de clave cacheada y reexpansión por firma, con sobrecostos históricos aproximados de 0,75 ms en H1 y 0,12 ms en H2. R5 incorpora inventario de representaciones, modelo de captura, sensibilidad y tres pruebas. Conservar la semilla mantiene la capacidad de firma. W describe regiones y tiempos bajo hipótesis explícitas; la observación de todas las copias y la custodia protegida siguen pendientes (Cap. 5, §5.6).
8. **La cota conservadora de aceptación falsa en ROM clásico finito** (§6.7.9), demostrada en Lean para el verificador matemático de bytes, con trabajo, consultas adaptativas, muestra compartida y reinicios. Sus ejemplos numéricos se enlazan con la probabilidad del modelo. No acredita equivalencia universal con Rust ni seguridad cuántica del protocolo.

## 7.4 Limitaciones

Se declaran con franqueza, pues delimitan honestamente el aporte:

- **Alcance del prototipo.** La arquitectura dual se entrega como modelo y el STARK como PoC de una transición ilustrativa. `ActiveChain` ya verifica el contrato desde contexto local antes de registrar envíos de validez; no se mantiene la aceptación heredada por formato o tamaño. El AIR escalar no valida las raíces SHA3 generales del motor L2: los lotes fuera del modelo se rechazan, sin truncarlas ni anunciar una prueba de transacciones. Los positivos de integración son casos escalares sintéticos. La recuperación del testigo pequeño, los límites de soundness y la separación del modo optimista se detallan en §6.7. Las mediciones no validan una aplicación completa y el control de duplicados en memoria no demuestra consenso entre reinicios.
- **Garantías condicionales.** La seguridad del esquema de firma requiere los supuestos y la correspondencia descritos en Cap. 6. La autorización, la vigencia de claves, las transiciones, el consenso y la disponibilidad de datos requieren validación propia.
- **Alcance de la prueba ROM.** El resultado de §6.7.9 usa un solo oráculo clásico ideal, perfiles de 16 a 4096 filas, trabajo de 12 o 20 bits y límite de 512 extracciones del selector. La cota conserva el error de acoplamiento y las excepciones explícitas. La equivalencia universal con Rust, sus codecs y operaciones de máquina no está demostrada; tampoco se deducen garantías de SHA3 determinista ni QROM.
- **Aplicabilidad a distintos dominios.** El modelo se plantea para sistemas en general; su adaptación a cada aplicación requiere definir y validar sus reglas de autorización y transición de estado. Los experimentos del prototipo no acreditan su funcionamiento en todos los dominios.
- **Novedad de síntesis.** El aporte no es un resultado de frontera —la frontera (Ethereum, Solana) converge hacia lo mismo—, sino su **síntesis formal y cuantificada** para sistemas en general; las coincidencias con propuestas externas aportan contexto y no sustituyen la validación propia.
- **El Objetivo 3 es una rama necesaria pero lateral** del arco central (firmas + dual-chain + validación).
- **Fuera de alcance:** confidencialidad post-cuántica (requeriría un KEM), seguridad de implementación (canales laterales, fallos), y la biometría (eliminada).

## 7.5 Trabajo futuro

Agenda priorizada, derivada de las limitaciones:

1. **Evidencia empírica y reproducibilidad.** Completar los metadatos ausentes de las series H1/H2 antes de atribuirles capacidad sostenida o comparaciones causales. Las 197 pruebas funcionales y las mediciones de componentes no sustituyen la validación de una aplicación completa ni la medición de todas las copias de secretos.
2. **Cierre del Objetivo 3.** Tras comprobar monitor, rotación efectiva y registro local, integrar la custodia durable y la política de épocas en L2, y validar el anclaje externo. Para un despliegue concreto debe vincularse el flujo observado con la fuente utilizada y documentar su calificación. La reexpansión de una misma semilla por firma y la rotación de épocas son operaciones diferentes.
3. **Refinamiento de la implementación y extensión cuántica.** Demostrar la correspondencia universal entre el verificador matemático y el ejecutable, incluidas codificaciones, operaciones de máquina y comportamiento del selector. La cota conservadora del modelo ROM ya está demostrada. La transferencia QROM de AIR/FRI, incluida una cota útil de omisión cuántica, constituye una línea de investigación independiente. La aritmetización de ML-DSA y de una aplicación completa, la vinculación integral de raíces y la ocultación del testigo son extensiones adicionales.
4. **Detección mediante señuelos.** Evaluar como idea complementaria el *Deception Engine*: conmutar a un par señuelo ML-DSA bajo una condición de alarma y detectar su uso mediante un verificador que actúe como *honeychecker*. La condición de alarma, la protección de la clave legítima y la respuesta deben especificarse antes de atribuirle una garantía. El mecanismo no está implementado ni constituye una contribución de seguridad demostrada; los antecedentes de señuelos [JR13; US10521584] y una búsqueda exploratoria no establecen prioridad de la propuesta.

## 7.6 Reflexión final

La amenaza cuántica motiva estudiar esquemas de autenticación y sus costos de integración. NEXUS aporta un modelo de arquitectura dual, componentes de firma y gestión de claves comprobados funcionalmente, y resultados formales bajo hipótesis explícitas. La cota de aceptación falsa del verificador matemático en ROM clásico es un resultado demostrado del modelo; la reducción concreta de seguridad de las firmas implementadas y las garantías del sistema completo conservan el alcance parcial y las condiciones declaradas en esta tesis.

NEXUS aporta una síntesis de arquitectura, gestión de claves y evaluación de componentes, con resultados reproducibles y límites explícitos. Completar las obligaciones formales identificadas por R1 y las integraciones pendientes permitirá evaluar el paso del modelo a un sistema operativo; la coincidencia con propuestas externas no demuestra ese resultado.
