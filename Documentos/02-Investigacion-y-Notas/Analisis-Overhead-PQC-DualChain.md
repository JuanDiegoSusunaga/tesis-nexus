# El overhead de la criptografía post-cuántica como justificación de la arquitectura dual-chain

### Análisis cuantitativo · Capítulo 3 (Diseño de la arquitectura); resumen de motivación en el Capítulo 1

> **Tesis de esta sección (el hilo central del trabajo).** Las firmas post-cuánticas son necesarias para resistir la amenaza cuántica, **pero introducen un sobrecosto de datos de ~50× por transacción**. Aplicado de forma ingenua sobre una cadena única, ese sobrecosto degrada el rendimiento en ~20×. La arquitectura **dual-chain** no es un complemento opcional: es **precisamente el mecanismo que amortiza ese sobrecosto**, llevando el costo on-chain (L1) por transacción post-cuántica de vuelta al de su *diferencia de estado* clásica. En otras palabras, **el dual-chain es la respuesta al problema que la propia PQC crea.** Como corolario, el sistema de pruebas del L2 debe ser él mismo post-cuántico (lo que descarta Groth16).

---

## 1. El costo de la PQC tiene dos dimensiones — y solo una es el cuello de botella

Es habitual suponer que «la criptografía post-cuántica es lenta». Para **firmas** y, en particular, para su **verificación**, esto es falso: el costo de CPU de verificar Dilithium es **del mismo orden** que el de ECDSA. El sobrecosto real y dominante es de **tamaño** (datos), no de cómputo.

**Tabla 1 — Costo comparado por operación (ECDSA P-256 vs. Dilithium3 / ML-DSA-65).**

| Magnitud | ECDSA P-256 | Dilithium3 | Razón | ¿Cuello de botella? |
|---|---:|---:|---:|:---:|
| Tamaño de **firma** | 64 B | 3 309 B | **~52×** | **Sí (datos)** |
| Tamaño de **clave pública** | 33 B | 1 952 B | **~59×** | **Sí (datos)** |
| Tiempo de **verificación** (CPU) | ~decenas de µs | ~decenas de µs | **~1×** | No |
| Tiempo de **firma** (CPU) | ~decenas de µs | ~0,1–0,3 ms (rejection sampling) | ~2–5× | Marginal |

> **Hallazgo clave.** El penalizador post-cuántico para una blockchain es la **anchura de banda, el almacenamiento y la disponibilidad de datos** (la firma es ~50× mayor), **no** el tiempo de verificación. Esto reorienta toda la justificación arquitectónica: lo que hay que optimizar es la **cantidad de datos de autenticación que tocan la L1**. Y reducir datos on-chain mediante agregación/compromiso es exactamente la función de un rollup (L2). *(Los tiempos de CPU se midieron con el backend `fips204` (Cap. 6 §6.6); los tamaños son exactos de FIPS 204 / ML-DSA.)*

---

## 2. Modelo de costo en una cadena única (L1-only)

### 2.1 Notación

| Símbolo | Significado | Valor de referencia |
|---|---|---:|
| $s_c,\ s_q$ | tamaño de firma clásica / post-cuántica | $64$ B / $3309$ B |
| $p_c,\ p_q$ | tamaño de clave pública clásica / PQC | $33$ B / $1952$ B |
| $b$ | carga útil base por transacción (sin firma) | $\approx 100$ B *(modelado)* |
| $w_x = b + s_x$ | tamaño on-chain de la transacción (firma incluida; la clave pública reside en el estado) | — |
| $B_d$ | presupuesto de datos por bloque | $1$ MB *(modelado)* |
| $\tau$ | tiempo de bloque | $12$ s *(modelado)* |

### 2.2 Rendimiento limitado por datos

El throughput sostenible por el presupuesto de datos es
$$\mathrm{TPS} = \frac{B_d}{\tau \cdot w} = \frac{B_d}{\tau\,(b+s)}.$$

**Ejemplo trabajado** ($B_d = 1$ MB, $\tau = 12$ s, $b=100$ B):

| Esquema | $w$ (B/tx) | tx/bloque | **TPS** |
|---|---:|---:|---:|
| ECDSA | $164$ | $\approx 6\,098$ | $\approx 508$ |
| **Dilithium3** | $3\,409$ | $\approx 293$ | $\approx 24{,}4$ |

$$\boxed{\ \frac{\mathrm{TPS}_c}{\mathrm{TPS}_q} = \frac{b+s_q}{b+s_c} = \frac{3409}{164} \approx 20{,}8\times\ }$$

**Sensibilidad** (el factor depende de cuánta carga útil no-firma tenga la transacción):

| $b$ (B) | razón de pérdida de throughput |
|---:|---:|
| $40$ | $\approx 32\times$ |
| $100$ | $\approx 21\times$ |
| $200$ | $\approx 13\times$ |

> **Conclusión 2.** Adoptar PQC de forma ingenua en una cadena única cuesta entre **~13× y ~32× de throughput** (~20× representativo) — **no por CPU**, sino porque la firma de 3,3 KB **domina** la transacción (es el ~97 % de sus bytes).

### 2.3 Almacenamiento e historia

- **Estado**: cada cuenta almacena una clave pública de $p_q=1952$ B frente a $33$ B ⟹ $+1{,}9$ KB por cuenta ($\approx +1{,}9$ GB por millón de cuentas).
- **Historia**: a igual throughput, la componente de firmas del libro mayor crece **~50×** más rápido con PQC. Esta es la presión que el dual-chain debe aliviar (§3).

---

## 3. La amortización dual-chain

### 3.1 Mecanismo

Un rollup ejecuta $M$ transacciones **fuera de cadena** (L2) y publica en L1 únicamente: un **compromiso de estado** $C$ (32 B), una **prueba de validez** $\pi$ y los **datos de disponibilidad** $D$ necesarios para reconstruir/auditar el estado.

La observación crucial es **qué datos *no* necesitan tocar la L1**:

> Si una **prueba de validez** atestigua de forma sucinta que *las $M$ transacciones estaban correctamente firmadas (Dilithium) y se ejecutaron correctamente*, entonces **las firmas no necesitan publicarse en L1**. El término de 50× se paga una sola vez fuera de cadena (al generar la prueba) y **se elimina de la L1**.

### 3.2 Costo on-chain por transacción

$$F(M) = \underbrace{d}_{\text{dif. de estado/tx}} + \underbrace{\frac{C + \pi}{M}}_{\text{overhead amortizado}},$$

donde $d$ es el tamaño de la **diferencia de estado** por transacción — **independiente del esquema de firma** (es la misma para ECDSA o Dilithium). Tomamos $d \approx 40$ B *(modelado)*.

$$\lim_{M\to\infty} F(M) = d \quad\Longrightarrow\quad \textbf{el costo L1 por tx PQC} \to \textbf{el de su diferencia de estado clásica.}$$

El factor de firma $s_q$ **desaparece** del costo on-chain.

### 3.3 Ejemplo trabajado y punto de equilibrio

Con $d=40$ B, $C=32$ B:

| Sistema de prueba | $\pi$ | $M$ | $F(M)$ | Reducción vs. L1-PQC ingenua ($3409$ B) |
|---|---:|---:|---:|---:|
| SNARK (Groth16) | $\approx 200$ B | $1\,000$ | $\approx 40{,}2$ B | $\approx 84\times$ |
| STARK (post-cuántico) | $\approx 100$ KB | $1\,000$ | $\approx 140$ B | $\approx 24\times$ |
| STARK (post-cuántico) | $\approx 100$ KB | $10\,000$ | $\approx 50$ B | $\approx 68\times$ |

**Punto de equilibrio** (a partir del cual el overhead de la prueba es despreciable frente a la diferencia de estado):
$$M \gg \frac{C+\pi}{d}.$$
- SNARK ($\pi\approx 200$ B): $M \gg \tfrac{232}{40} \approx 6$ ⟹ amortiza casi de inmediato.
- STARK ($\pi\approx 100$ KB): $M \gg \tfrac{100\,032}{40} \approx 2\,500$ ⟹ lotes de ~10 k transacciones amortizan plenamente.

> **Conclusión 3.** El dual-chain no solo recupera el ~20× de throughput perdido: lleva el **costo amortizado on-chain de una transacción post-cuántica a ~$d$ (su diferencia de estado clásica)**, haciendo que el tamaño de la firma sea **irrelevante para la L1**. El sobrecosto de 50× se paga una vez fuera de cadena y se amortiza a ~cero en cadena.

### 3.4 La dimensión de cómputo (secundaria, pero también mejora)

- **L1-only**: la L1 verifica $M$ firmas por bloque: costo $\propto M\cdot t_v$.
- **Rollup de validez**: la L1 verifica **una** prueba, $t_\pi$, **independiente de $M$** ⟹ cómputo por tx $\to t_\pi/M \to 0$. El trabajo pesado se traslada al *prover* L2.

Como $t_v$ (Dilithium) ya es barato (§1), este ahorro es **secundario** frente al de datos — coherente con que el cuello de botella PQC es el tamaño, no la CPU.

---

## 4. Consecuencia de diseño: el sistema de pruebas debe ser post-cuántico

Aquí aparece una **inconsistencia latente** que el análisis hace explícita y que fortalece la tesis:

> Si la prueba de validez que la L1 verifica usa **Groth16 sobre BN254** (basado en emparejamientos / logaritmo discreto), entonces **Shor la rompe**. Un adversario cuántico podría falsificar la prueba que atestigua las transacciones, y la L1 lo aceptaría — **reintroduciendo la vulnerabilidad cuántica en la capa de verificación**, justo la que el sistema pretende eliminar.

Por tanto, para que la arquitectura sea **post-cuántica de extremo a extremo**, el verificador (el «Nitro Verifier») debe usar un **sistema de pruebas post-cuántico**:

| Sistema de prueba | Base de seguridad | ¿Post-cuántico? | $\pi$ |
|---|---|:---:|---:|
| Groth16 / SNARK de emparejamientos | log. discreto en curvas | No (roto por Shor) | ~200 B |
| **STARK** (hash + FRI) | resistencia de colisión de hash | Sí (plausible) | ~decenas–cientos KB |
| SNARK reticular | Module-SIS/LWE | Sí (plausible) | intermedio |

> **Conclusión 4 (corrección de diseño).** El prototipo y la propuesta original referencian Groth16/BN254 — **incoherente** con el objetivo post-cuántico. El análisis recomienda un **STARK** (o SNARK reticular) como verificador de validez. El precio cuantificado: una prueba mayor ⟹ punto de equilibrio en lotes de ~10 k tx (§3.3), perfectamente alcanzable. Esto convierte al «Nitro Verifier» de adorno opcional en **componente arquitectónico necesario y bien justificado** (trabajo futuro priorizado).

---

## 5. El trade real: qué se paga y dónde

Ningún esquema es gratis; el dual-chain **reubica** el costo, no lo elimina. Tabla comparativa honesta:

**Tabla 2 — Tres arquitecturas para banca post-cuántica.**

| | L1 única (ingenua) | Rollup optimista | **Rollup de validez (STARK)** |
|---|---|---|---|
| Bytes L1 por tx | $b+s_q \approx 3409$ | datos de tx en DA (con firmas) salvo poda/compresión | **$\to d \approx 40$** (firmas elididas) |
| Cómputo L1 por tx | $t_v$ por firma | $0$ salvo disputa | $t_\pi/M \to 0$ |
| ¿Dónde viven las firmas? | en L1 (siempre) | en DA durante la ventana de fraude, luego podables | **fuera de L1** (probadas, no publicadas) |
| Costo trasladado | — | DA + pruebas de fraude post-cuánticas | **prover** L2 (probar verificación de firmas reticulares en circuito es costoso) |
| ¿PQ de extremo a extremo? | sí | sí (si fraude/DA son PQ) | **sí, si el sistema de pruebas es PQ (STARK)** |

> **Honestidad sobre el costo trasladado.** En el rollup de validez, el *prover* L2 debe demostrar en circuito $M$ verificaciones de firma Dilithium; **probar verificación de firmas reticulares en ZK es hoy costoso y es un área de investigación activa**. El rollup optimista evita probar pero debe mantener los datos disponibles (en una capa de DA con *erasure coding*/muestreo) durante la ventana de disputa. La tesis debe declarar este trade, no ocultarlo.

---

## 6. Síntesis y conexión con los objetivos

Este análisis es el **eslabón que une** todas las piezas de la tesis en un solo argumento:

1. **Amenaza** (modelo de amenaza, Cap. 1): el adversario cuántico puede recuperar claves y **falsificar firmas** ⟹ se necesitan firmas PQC.
2. **Solución** (Obj. 2): firmas Dilithium, formalmente seguras (Obj. 4, reducción a Module-LWE).
3. **Costo** (esta sección, §1–2): las firmas PQC pesan ~50× ⟹ ~20× menos throughput en L1.
4. **Respuesta arquitectónica** (Obj. 1, esta sección §3): el **dual-chain** amortiza el costo a ~$d$, volviendo el tamaño de la firma irrelevante en L1.
5. **Requisito de coherencia** (esta sección §4): el verificador L2 debe ser **post-cuántico** (STARK), no Groth16.
6. **Validación** (Obj. 4): la prueba formal establece *qué* seguridad se cumple; los benchmarks (Obj. 4.2) deben medir exactamente las magnitudes de §2–3 — **demostrando que el sistema es a la vez seguro y practicable**.

> **Frase de novedad (una sola).** *El aporte es el tratamiento formal y cuantificado de cómo el sobrecosto de datos de las firmas post-cuánticas motiva y se mitiga con una arquitectura dual-chain de prueba de validez post-cuántica para banca, llevando el costo on-chain por transacción al de su diferencia de estado clásica.*

---

## 7. Parámetros, supuestos y fuentes

- **Tamaños exactos** (FIPS 204 / ML-DSA-65; secp256r1): $s_q=3309$, $p_q=1952$, $s_c=64$, $p_c=33$ B.
- **Valores modelados** (a fijar/justificar en la tesis y medir en Obj. 4.2): $b\approx100$ B, $d\approx40$ B, $B_d=1$ MB, $\tau=12$ s, $\pi_{\text{STARK}}\approx100$ KB, $\pi_{\text{Groth16}}\approx200$ B. Toda conclusión cualitativa (razones ~20×, amortización a ~$d$, equilibrio en ~$10^3$–$10^4$ tx) es **robusta** dentro de rangos amplios de estos parámetros.
- **Tiempos de CPU**: órdenes de magnitud de la literatura (eBACS/SUPERCOP, FIPS 204); valores precisos en Obj. 4.2.
- Los modelos son **conservadores** para el dual-chain: ignoran compresión adicional de la diferencia de estado y solapamiento de cuentas, que solo mejorarían $F(M)$.

> **Validación empírica prevista (Obj. 4.2).** Medir: (i) tamaño real de bloque ECDSA vs. Dilithium; (ii) TPS de L1 verificando firmas Dilithium; (iii) $F(M)$ para varios $M$ y tamaños de prueba; (iv) costo de *proving* por transacción. Estas mediciones convierten las Tablas 1–2 de modelo a evidencia.
