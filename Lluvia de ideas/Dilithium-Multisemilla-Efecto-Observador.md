# Dilithium 3 + Multisemilla (estilo Minecraft) + Efecto Observador

**Fecha:** 2026-07-31
**Estado:** Idea evaluada — **parcialmente viable**. Piezas 1 y 2 rescatables; pieza 3 (efecto observador) **descartada** por romper la seguridad del esquema.
**Contexto:** Tesis NEXUS · relación con Obj. 2 (núcleo criptográfico) y Obj. 3 (gestión de claves) del [Alcance v2](../Documentos/02-Investigacion-y-Notas/Alcance-y-Objetivos-v2.md).

---

## 1. La idea original (tal como fue planteada)

Motor de firma post-cuántica en el que la clave privada de Dilithium 3 **nunca existe ensamblada en memoria**, y en el que la observación por un atacante degrada silenciosamente la firma.

### 1.1 Estado de reposo — "el mundo sin renderizar"

No existe ninguna clave privada de Dilithium 3 en el servidor. Solo hay una **Semilla Maestra** (la "semilla del mundo" de Minecraft) guardada de forma inviolable dentro de un chip de hardware seguro (TPM o Secure Enclave). Si alguien roba el disco duro, solo encuentra código inerte.

### 1.2 La llamada a firmar — "el jugador se mueve"

La aplicación necesita firmar un documento. Envía el hash del documento al motor. El motor solicita a la Semilla Maestra los parámetros iniciales para ese documento específico.

### 1.3 Generación de chunks — "renderizado procedural"

En lugar de cargar una clave de 3 KB en RAM, el motor dispara múltiples hilos de procesamiento simultáneos. Usando funciones pseudoaleatorias deterministas, cada hilo "renderiza" un fragmento (*chunk*) del vector matemático de Dilithium (`s1`) directamente dentro de la caché ultrarrápida del procesador. La RAM principal sigue vacía.

### 1.4 La trampa del observador — "entrelazamiento temporal"

Mientras los hilos multiplican los polinomios dentro del procesador, el motor consulta el reloj interno de la CPU (microsegundos o ciclos). Ese número de tiempo (p. ej. 4 000 ciclos) se inyecta como **multiplicador dentro de la fórmula de la máscara `y`**.

### 1.5 La falsa seguridad del atacante

Si un atacante espía el proceso con un depurador o un hipervisor para capturar los chunks, el solo hecho de "mirar" congela el procesador unos milisegundos:

- El reloj interno marca 1 000 000 de ciclos en lugar de 4 000.
- Ese número gigante entra en la ecuación de Dilithium.
- El programa no muestra alerta ni se detiene. El atacante cree que ha triunfado.

### 1.6 Ensamblaje y destrucción — "despawn"

En el último microsegundo los hilos combinan sus cálculos, emiten la firma final (3 293 bytes de Dilithium 3) y sobrescriben la caché L1 con ceros. Los chunks desaparecen como si el jugador se hubiera alejado en el mapa.

### 1.7 Resultado final esperado

- **Si nadie miró:** la firma es perfectamente válida.
- **Si alguien miró:** el atacante se lleva 3 293 bytes que parecen reales pero son matemáticamente basura; la red la rechaza. La clave privada completa jamás existió ensamblada.

---

## 2. Evaluación de viabilidad

La propuesta son **tres piezas independientes**. Dos son viables; la tercera es inviable y además contraproducente.

### Pieza 1 — Semilla maestra en lugar de clave en disco → **VIABLE (y ya implementada)**

Es exactamente lo que hace FIPS 204: `ML-DSA.KeyGen` es determinista a partir de una semilla ξ de 32 bytes expandida con SHAKE-256. Guardar solo ξ y regenerar el par de claves no es nuevo — es la especificación. El Cap. 4 §4.5 ya lo implementa (`test_deterministic_from_seed`) y el Cap. 5 ya lo documenta.

Lo que añadiría de nuevo la propuesta es **sellar ξ en un TPM**. Viable y valioso, con una salvedad:

> **El TPM 2.0 no sabe ejecutar ML-DSA.** Solo puede custodiar y liberar los 32 bytes; la expansión ocurre igual en la CPU. Protege la semilla *en reposo*, no durante la firma.

### Pieza 2 — Chunks / renderizado procedural → **VIABLE A MEDIAS** (malentendido de hardware)

**Lo correcto:** la expansión perezosa de los vectores de Dilithium ya existe y ya es procedural. `ExpandA`, `ExpandS` y `ExpandMask` son funciones XOF indexadas: se genera el polinomio *i* cuando se necesita y se descarta. Las implementaciones para Cortex-M4 (proyecto `pqm4`) hacen justo eso porque la matriz **A** no les cabe en RAM. La intuición del "renderizado por chunks" es correcta y tiene literatura detrás.

**Lo incorrecto:**

| Afirmación de la idea | Realidad |
|---|---|
| "Los chunks viven solo en caché L1; la RAM sigue vacía" | **No existe** ninguna instrucción en x86 ni ARM que fije un dato en L1 e impida que llegue a RAM. La caché la gestiona el hardware: desaloja a L2/L3/DRAM cuando quiere, mantiene coherencia entre núcleos. Encima están el swap, la hibernación y los core dumps. |
| "El multihilo protege" | **Lo empeora.** Replica el material secreto en la L1 privada de cada núcleo más la L3 compartida, y expone a Prime+Probe y Flush+Reload entre hilos vecinos. Hay literatura de canal lateral que ataca justamente `ExpandMask` y la NTT de Dilithium. Como paralelización es optimización de latencia; como defensa es contraproducente. |
| "Sobrescribir la caché con ceros" | Un `memset` normal lo **elimina el compilador** por *dead store elimination*. Hace falta `zeroize` / `explicit_bzero` / `SecureZeroMemory`. |

**La respuesta real** a "me roban el volcado de memoria" no es la caché, sino: `zeroize`, `VirtualLock`/`mlock` para evitar el swap, `MADV_DONTDUMP`, y para el caso serio memoria cifrada por hardware — SGX, AMD SEV-SNP o Intel TDX.

> ⚠️ **Aviso de alcance:** el §3.2 del Alcance v2 declara explícitamente que la **resistencia a canales laterales está fuera del alcance**. Esta pieza entra de lleno ahí.

### Pieza 3 — El efecto observador → **INVIABLE** (tres razones independientes)

#### (a) Rompe la prueba de seguridad y filtra la clave privada ← *el punto grave*

Dilithium es **Fiat-Shamir con abortos**. La firma es `z = y + c·s₁`, y esa expresión solo es zero-knowledge porque:

1. `y` está distribuida **uniformemente** en la bola ‖y‖∞ < γ₁, y
2. el **muestreo por rechazo** descarta las `z` fuera de rango.

Esas dos condiciones juntas son lo que hace que `z` sea estadísticamente independiente de `s₁`. **Si se multiplica `y` por un contador de ciclos, `y` deja de ser uniforme y `z` empieza a filtrar `s₁`.**

No es una objeción teórica. Es la familia de **ataques de nonce sesgado**: los mismos que rompieron ECDSA en la PlayStation 3, en Minerva y en TPM-Fail. En el lado reticular hay literatura específica sobre Dilithium:

- Groot Bruinderink & Pessl, *Differential Fault Attacks on Deterministic Lattice Signatures* (TCHES 2018).
- Ravi et al., *Exploiting Determinism in Lattice-based Signatures: Practical Fault Attacks on pqm4 implementations*.

Ambos demuestran que **inyectar fallos en el nonce `y` de Dilithium permite recuperar la clave secreta** con un puñado de firmas.

> **Conclusión:** lo que la idea describe como contramedida es, literalmente, la primitiva de ataque publicada contra el esquema. Y el atacante **controla cuándo dispararla** — le basta un breakpoint para provocar el modo degradado a voluntad, lo que le da un **oráculo de firmas sesgadas bajo demanda**. El §1.7 se invierte: el atacante no se lleva basura, se lleva exactamente las muestras que necesita para reconstruir `s₁` por reducción de retículos.

#### (b) El detector no distingue lo que cree distinguir, y se desactiva trivialmente

`RDTSC` no separa "hay un depurador" de: una interrupción, un SMI, una migración de hilo entre núcleos, escalado de frecuencia (DVFS/turbo), un fallo de página, un hyperthread vecino ruidoso, o simplemente **estar dentro de una máquina virtual** — que en banca o cloud es el caso normal, no la excepción. Un servidor bajo carga generaría firmas inválidas de forma constante y sin patrón: tasa de falsos positivos inoperable.

En la otra dirección: **un hipervisor puede virtualizar el TSC**. VT-x tiene *TSC offsetting* y *RDTSC exiting*; AMD-V lo mismo. El adversario con exactamente el nivel de acceso que la idea postula es precisamente el que puede mentirle al reloj. Y como el binario en disco es "inerte" pero legible, localizar el `RDTSC` y parchearlo a una constante es trabajo de minutos con ingeniería inversa estática.

#### (c) El modelo de amenaza es incoherente consigo mismo

Se postula un adversario con depurador o hipervisor sobre el proceso que firma. Ese adversario **ya ganó** antes de que el mecanismo entre en juego: lee la semilla en el instante en que el TPM la libera, pone el breakpoint *después* del ensamblaje de la firma, o simplemente llama a la API de firma las veces que quiera. Ninguna acrobacia *dentro* del proceso protege de alguien que es dueño del proceso.

#### (d) Nota de forma

La analogía cuántica no aplica: no hay colapso de función de onda, hay *jitter* de temporización. Un jurado técnico leerá "efecto observador" como retórica, y eso resta credibilidad a las partes que sí son sólidas.

---

## 3. El argumento de imposibilidad (esto sí es publicable)

En ML-DSA existe **un solo punto** donde se puede inyectar entropía sin romper nada: el randomizer `rnd` de 32 bytes de la variante *hedged*, que entra vía ρ' = H(K ‖ rnd ‖ µ). Metiendo ahí el contador de ciclos, el resultado es conforme a FIPS 204 y seguro — pero entonces la observación solo cambia **cuál** de las muchas firmas válidas se produce, nunca su validez.

Para que la observación genere una firma **inválida** hay que salirse de la especificación, y salirse de la especificación es exactamente lo que filtra la clave.

> **Proposición (negativa).** En un esquema Fiat-Shamir con abortos, *"producir silenciosamente una firma inválida ante observación"* y *"no filtrar la clave secreta"* son propiedades **mutuamente excluyentes**.

Demostrar esto vale más académicamente que proponer el mecanismo.

---

## 4. Qué rescatar — tres reencuadres, en orden de valor

### 4.1 Fail-closed por atestación, en vez de fail-corrupt ⭐

Sellar ξ en el TPM ligado a los **PCRs del arranque medido**. Si el entorno cambió —kernel modificado, hipervisor inesperado, depurador— el TPM sencillamente **no desella** la semilla y no hay firma.

- Conserva toda la intención de "si alguien mira, no consigue nada".
- Es criptográficamente sólido y es producto real (BitLocker funciona así).
- **Diferencia clave:** no se firma nada, en lugar de firmar mal.

### 4.2 Firma-canario en vez de firma corrupta ⭐

Si interesa el componente de engaño, la forma segura es: detectar anomalía → firmar con un **par de claves señuelo distinto**, matemáticamente válido, cuya clave pública está marcada como *honeytoken* en la red.

- El atacante se lleva algo que parece funcionar.
- La red lo detecta al usarlo y dispara la alarma identificándolo.
- **La clave real nunca participó en la operación → fuga cero.**

Encaja con el estado del arte ya recopilado: paper **020** (*Canary Tokens & Honeytokens*) y **039** (*Hybrid Cyber Deception Framework*).

### 4.3 Ventana de exposición como métrica medible

Expansión perezosa de **A** y `s₁` + `zeroize` + `VirtualLock`, midiendo:

> **bytes de material secreto × microsegundos residentes en memoria**

y demostrando con un volcado de memoria que la clave completa nunca aparece ensamblada.

El costo también es medible: regenerar desde ξ en cada firma añade aproximadamente un `KeyGen` completo por operación — del orden de duplicar la latencia de firma en ML-DSA-65. Una tabla **"ventana de exposición vs. latencia"** es un experimento reproducible y honesto.

---

## 5. Recomendación de alcance

**Contexto:** TG1 ya entregado, 110/110 tests en verde, y un alcance que **ya se estrechó deliberadamente una vez** porque la dispersión era el problema de fondo (tabla §1 del Alcance v2: *"cada pieza es una tesis"*). Esta idea reabre canales laterales, declarados fuera del alcance hace pocas semanas. Incorporarla entera sería repetir el error que la v2 corrigió.

**Plan sugerido:**

| Dónde | Qué |
|---|---|
| **Cap. 5**, sección corta *"Defensas del entorno de ejecución"* | Sellado TPM como **diseño**; expansión perezosa + zeroización como **implementación medible** (§4.1 y §4.3). |
| **Cap. 7**, trabajo futuro | El efecto observador como **alternativa descartada con justificación**, apoyada en la literatura de *fault attacks* sobre Dilithium. |

Explicar *por qué no funciona* demuestra ante el jurado dominio del muestreo por rechazo y de los ataques de nonce. Eso suma más que haberlo propuesto.

---

## 6. Referencias clave para desarrollar esto

- **NIST FIPS 204** — *Module-Lattice-Based Digital Signature Standard (ML-DSA)*. `KeyGen` determinista desde semilla; variante *hedged* y el randomizer `rnd`.
- **Groot Bruinderink, L. & Pessl, P. (2018)** — *Differential Fault Attacks on Deterministic Lattice Signatures*, TCHES 2018(3).
- **Ravi, P. et al.** — *Exploiting Determinism in Lattice-based Signatures: Practical Fault Attacks on pqm4 implementations*.
- **Proyecto `pqm4`** — implementaciones de Dilithium con expansión *on-the-fly* para RAM limitada.
- Estado del arte local: papers **020** (Canary Tokens & Honeytokens), **039** (Hybrid Cyber Deception Framework), **083** (Side Channel Attacks: When Strong Cryptography is not Enough).