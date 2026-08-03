# Dilithium 3 + Multisemilla + Deception Engine: Rediseño Criptográficamente Sólido (v2)

**Fecha:** 2026-07-31  
**Estado:** Rediseño Integrado (Propuesta Mejorada v2) — **Criptográficamente viable y alineado con FIPS 204**.  
**Contexto:** Tesis NEXUS · Relación con Obj. 3 (Ciclo de Vida Activo y Residencia de Claves) y Obj. 4 (Formalización y Defensas Off-Chain) del [Alcance v2](../Documentos/02-Investigacion-y-Notas/Alcance-y-Objetivos-v2.md).

---

## 1. 🎯 Filosofía del Rediseño

La intuición original buscaba tres objetivos altamente deseables en seguridad bancaria post-cuántica:
1. **Cero huella persistente:** La clave privada no debe residir en disco ni permanecer armada en RAM.
2. **Fragmentación/Aislamiento:** Evitar que un solo componente contenga la clave completa en memoria.
3. **Engañar/Neutralizar al observador:** Si un atacante espía el proceso con un depurador o hipervisor, no debe obtener la clave real ni lograr transacciones válidas en la red.

**El problema de la v1:** Intentar lograr el punto 3 mediante la inyección de ciclos de CPU (`RDTSC`) en la máscara $y$ de Dilithium destruye la uniformidad del nonce y la propiedad Zero-Knowledge, entregando al atacante un **oráculo de fallos sesgados** para extraer la clave secreta $s_1$ mediante reducción de retículos (*Lattice Reduction / LLL*).

**La solución de la v2:** Conservar el 100% de la intención estratégica reemplazando las heurísticas vulnerables por **primitivas criptográficas y de sistemas sólidas**.

---

## 2. 🏛️ Arquitectura V2: Los 4 Pilares Rediseñados

```mermaid
graph TD
    subgraph Pilar 1: Custodia y Derivación
        TPM["TPM 2.0 / Enclave HW"] -->|Semilla xi (32B)| KDF["ML-DSA.KeyGen (FIPS 204)"]
    end
    
    subgraph Pilar 2: Aislamiento en Memoria
        KDF -->|RAM Efímera t < 1ms| Sign["Proceso de Firma"]
        Sign -->|Drop Inmediato| Zero["Zeroize + VirtualLock + MADV_DONTDUMP"]
    end
    
    subgraph Pilar 3: Separación de Secretos
        TSS["Threshold ML-DSA / MPC"] -->|Shares de s1| Sign
    end
    
    subgraph Pilar 4: Deception Engine (Canario)
        Check["Entorno Comprometido / PCR Mismatch"] -->|Sí| Decoy["Par Señuelo (Honey-Keypair)"]
        Check -->|No| Sign
        Decoy -->|Firma Válida Señuelo| L2["L2 Sequencer / Honeytoken Trigger"]
    end
```

---

### 2.1 Pilar 1 — Custodia en Hardware Seguro (TPM 2.0 / TEE) y Derivación Efímera

* **Mecanismo:** La clave privada $s_1$ **nunca se guarda en disco**. Se mantiene únicamente la semilla maestra $\xi$ (32 bytes) sellada en un chip TPM 2.0 o Enclave Seguro.
* **Derivación Just-In-Time:** Ante una solicitud de firma, la semilla se desella brevemente y se expande en memoria mediante `keygen_from_seed` (conforme a FIPS 204).
* **Medición de Ventana de Exposición:** La clave extendida de Dilithium3 existe en RAM únicamente durante el tiempo estricto de la operación de firma (~790 µs según los benchmarks Criterion de NEXUS), reduciendo drásticamente la ventana de ataque (*exposure window* $W = \text{bytes} \times \text{tiempo}$).

---

### 2.2 Pilar 2 — Aislamiento Criptográfico de Memoria y Zeroización Garantizada

En lugar de asumir que los datos se fijan en la caché L1 (inviable en arquitecturas x86/ARM modernas), el sistema aplica controles de memoria a nivel del sistema operativo y lenguaje (Rust):

1. **Memory Locking (`VirtualLock` / `mlock`):** Impide estrictamente que las páginas de memoria que contienen la semilla o los vectores $s_1, s_2$ se escriban en el archivo de intercambio (*swap*) o hibernación en disco.
2. **Exclusión de Core Dumps (`MADV_DONTDUMP`):** Garantiza que si el proceso sufre un fallo o colapso, el sistema operativo excluya la memoria criptográfica del volcado.
3. **Zeroización Inmediata (`zeroize` / `ZeroizeOnDrop`):** Garantiza que al terminar la función de firma, los compiladores no eliminen las instrucciones de borrado (*Dead Store Elimination*) y la memoria RAM sea sobrescrita con ceros antes de ser devuelta al SO.
4. **Enclaves Cifrados de Hardware (SGX / SEV-SNP):** Para entornos de alta amenaza, la ejecución se encapsula dentro de una enclave cifrado en RAM por la CPU, impidiendo incluso al hipervisor del sistema operativo anfitrión leer las líneas de memoria.

---

### 2.3 Pilar 3 — Firma Umbral / Threshold ML-DSA (En lugar de Chunks de Caché)

Si se desea garantizar que **ningún hilo o subproceso contenga la clave completa $s_1$ en memoria**:

* **Mecanismo:** Reemplazar el "renderizado por chunks" heurístico por un esquema de **Firma Umbral Post-Cuántica (Threshold Signatures / MPC para ML-DSA)**.
* **Funcionamiento:** La clave secreta de retículos $s_1$ se fragmenta en $n$ componentes (*shares*) mediante esquemas de compartición de secretos.
* **Cálculo Distribuido:** $k$ de los $n$ hilos o microservicios independientes calculan firmas parciales sobre sus fragmentos vectoriales sin que la clave secreta completa se ensamble en ningún momento en un único mapa de memoria. La combinación de las partes produce la firma final válida bajo la clave pública global.

---

### 2.4 Pilar 4 — Deception Engine con Firmas Canario / Honeytokens (En lugar del Efecto Observador en Nonce)

Esta es la mejora central que resuelve de forma elegante y criptográficamente segura la intención de engañar al observador:

* **El problema evitado:** No se toca la máscara $y$ ni se inyectan ciclos de CPU en el nonce. La firma real mantendrá siempre su distribución uniforme y su garantía Zero-Knowledge.
* **Mecanismo Canario:**
  1. El sistema integra sensores de integridad de ejecución (Atestación TPM de PCRs, comprobación de integridad del enclave o detección de ptrace/debuggers).
  2. **Si el entorno es seguro:** El motor firma normalmente con la clave real derivada de $\xi$.
  3. **Si se detecta observación o anomalía:** El motor conmutará de forma transparente a un **Par de Claves Señuelo (Honey-Keypair)** independiente, pre-generado y legítimo en ML-DSA-65.
* **Resultado del Engaño:**
  - El atacante en el depurador o hipervisor intercepta una firma que es **100% válida matemáticamente** para la clave pública señuelo. El atacante asume que la operación fue exitosa.
  - Al transmitir la transacción a la red NEXUS, el **Nitro Verifier / L2 Sequencer** reconoce la clave pública Honeytoken, **bloquea la transacción**, activa alertas de ciberdefensa e invalida las credenciales del atacante.
  - **Fuga de información de la clave real: EXACTAMENTE CERO.** La clave real nunca participó en el proceso.

---

## 3. 📊 Matriz Comparativa: Versión 1 (Original) vs. Versión 2 (Rediseño)

| Dimensión | Versión 1 (Original) | Versión 2 (Rediseño Mejorado) |
| :--- | :--- | :--- |
| **Custodia de Clave** | Semilla en TPM / RAM vacía | Semilla $\xi$ sellada en TPM 2.0 / SGX + Derivación Efímera JIT |
| **Protección Memoria** | Intento de fijar en caché L1 | `zeroize`, `mlock`/`VirtualLock`, `MADV_DONTDUMP`, TEE Enclaves |
| **Fragmentación** | Renderizado procedural por hilos | Threshold ML-DSA (MPC / Threshold Signature Scheme) |
| **Reacción al Atacante** | Inyección de `RDTSC` en máscara $y$ (*Fail-corrupt*) | Atestación TPM / PCRs (*Fail-closed*) o Firma Señuelo (*Honeytoken*) |
| **Seguridad Criptográfica** | ❌ **Vulnerable:** Destruye ZK; sufre ataques de nonce sesgado y recupera $s_1$. | ✅ **100% Seguro:** FIPS 204 estricto; preserva Zero-Knowledge; fuga cero. |
| **Infección Operativa** | Falsos positivos por *jitter* de CPU invalidan firmas reales. | Cero falsos positivos en producción; detección limpia en L2. |

---

## 4. 🎓 Relevancia e Integración en la Tesis NEXUS (TG2)

El rediseño V2 permite estructurar las lecciones aprendidas en los entregables formales de TG2 de la siguiente manera:

1. **Capítulo 5 (Diseño de Arquitectura de Claves):**
   - Documentar la arquitectura de derivación efímera just-in-time con custodia en TPM y ciclo de vida de memoria protegida (`zeroize` + `mlock`).
2. **Capítulo 7 (Trabajo Futuro y Defensas Off-Chain):**
   - Incorporar la propuesta del **Deception Engine con Honey-Signatures en L2**, demostrando cómo la defensa activa se traslada a la infraestructura off-chain sin debilitar el esquema de firma primitivo.
3. **Capítulo 4 / 7 (Demostración Teórica):**
   - Incluir la formalización del *Teorema de Imposibilidad en Fiat-Shamir con Abortos*, explicando rigurosamente por qué el nonce no debe manipularse dinámicamente y cómo la V2 resuelve esta restricción matemática.

---

*Documento consolidado para la carpeta de Lluvia de Ideas del Proyecto NEXUS (TG2).*
