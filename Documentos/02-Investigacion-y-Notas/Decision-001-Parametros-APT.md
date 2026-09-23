# Decisión 001 — Parámetros (W, C) de los tests de salud SP 800-90B

**Estado actualizado el 2026-09-22:** propuesta aprobada según confirmación del estudiante. Corte binomial, lotes de 65.536 muestras y recuperación explícita implementados y comprobados; 123 pruebas del workspace pasan, incluidas 13 nuevas. La vinculación y calificación de una fuente concreta de despliegue siguen requeridas. Véase el [informe R2](../04-Administrativo-TG2/Avances/R2-Monitor-Entropia-2026-09-22.md). Se conserva debajo el análisis histórico del 7 de agosto; fecha exacta de aprobación por incorporar.

**Precisión posterior sobre la convención del corte:** con la referencia incluida, se implementa $B=1+\mathrm{Bin}(W-1,p)$ y fallo al alcanzar $C$. Se evalúa directamente $\Pr[B\ge C]\le\alpha$. Si `CRITBINOM` representa el cuantil usual de la CDF, la equivalencia es `C = 2 + CRITBINOM(W-1, p, 1-alpha)`. No se identifica esta expresión con la nota de hoja de cálculo de SP 800-90B, que usa otra expresión. Para el perfil aprobado, C=16 satisface la condición directa: cola 2,764095×10⁻⁷; C=15 produce 1,522690×10⁻⁶.

**Límite del barrido MCV histórico:** `estimate_min_entropy` calcula una estimación puntual por frecuencia máxima; no incorpora el límite de confianza del estimador completo de SP 800-90B §6.3.1. Sus tasas y el margen de 0,2 bits pertenecen al modelo simulado. El lote de 65.536 y un resultado favorable no sustituyen una calificación de fuente ni prueban independencia temporal.
**Fecha:** 2026-08-07 · **Harness:** `nexus/nexus-crypto/examples/apt_sweep.rs` (nuevo)
**Hardware:** MSI Vector 16 (Core Ultra 9 275HX, 24 hilos) · corrida completa: ~13 s
**Reproducir:** `cargo run -p nexus-crypto --example apt_sweep --release` (RNG determinista: las tablas salen idénticas en cualquier máquina)

---

## 1. Qué se decide

La bitácora dejó abierta la **Decisión 001**: fijar la ventana \(W\) y el corte \(C\) del *Adaptive Proportion Test* (APT, NIST SP 800-90B §4.4.2) para la fuente objetivo. El código actual (`HealthMonitor`, `entropy.rs`) usa \(W=512\), \(\alpha=2^{-20}\), barra de min-entropía \(H=7{,}5\) bits/byte, y calcula el corte con una **aproximación normal** de la binomial (\(C = \lceil Wp + 4{,}7634\sqrt{Wp(1-p)} \rceil\), \(p = 2^{-H}\)).

El barrido responde tres preguntas: (a) ¿el corte implementado respeta el \(\alpha\) de diseño?, (b) ¿cuánta latencia de detección cuesta corregirlo?, (c) ¿qué tamaño de lote necesita la capa complementaria (estimador MCV) para no falsear?

**Metodología.** Simulación masiva multihilo con réplica exacta de la semántica de `HealthMonitor::update` (ventanas no solapadas, referencia = primera muestra, conteo incluye la referencia, RCT concurrente con corte 4), **verificada muestra a muestra contra la implementación real** en 5 flujos (el harness aborta si difieren). Fuente de peor caso para una \(H_\infty\) dada: un valor modal con \(p_{\max}=2^{-H}\) y el resto de la masa uniforme.

## 2. Hallazgo principal: la aproximación normal no sirve en este régimen

Con \(p = 2^{-7{,}5}\) y \(W=512\), la binomial tiene media 2,8 — un régimen tipo Poisson, muy sesgado, donde la aproximación normal subestima gravemente la cola derecha. Cola teórica exacta de cada corte (modelo SP 800-90B: `apt_count` \(= 1 + \mathrm{Bin}(W{-}1, p)\)):

| W | C implementado (normal) | Cola real de ese C | C exacto (CRITBINOM, α=2⁻²⁰) | Cola del C exacto |
|---:|:---:|:---:|:---:|:---:|
| 256 | 8 | 6,1×10⁻⁴ | **12** | 2,5×10⁻⁷ |
| 512 | 11 | **6,7×10⁻⁴ (≈2⁻¹⁰·⁵)** | **16** | 2,8×10⁻⁷ |
| 1024 | 17 | 2,6×10⁻⁴ | **22** | 5,1×10⁻⁷ |
| 2048 | 28 | 4,9×10⁻⁵ | **32** | 9,4×10⁻⁷ |
| 4096 | 46 | 2,1×10⁻⁵ | **51** | 4,3×10⁻⁷ |

El corte implementado para W=512 queda **~700× por encima** del α=2⁻²⁰ de diseño. SP 800-90B prescribe el corte binomial exacto (`CRITBINOM(W, 2^-H, 1-α)`), no la aproximación normal.

**Tasa de disparo medida** (falsos positivos por ventana, fuentes saludables):

| Fuente | W | Ventanas simuladas | α empírico (C impl.) | α empírico (C exacto) |
|---|---:|---:|:---:|:---:|
| Perfecta (H=8,0) | 512 | 33,6 M | 4,4×10⁻⁵ (2⁻¹⁴·⁵) | 0 eventos |
| Límite (H=7,5, peor caso) | 512 | 67,1 M | 4,6×10⁻⁵ (2⁻¹⁴·⁴) | 1,5×10⁻⁸ (2⁻²⁶) |

En términos operativos: con el corte actual, el APT dispara una rotación espuria **cada ~12 MB de muestras crudas incluso con una fuente perfecta**; con el corte exacto, del orden de una cada decenas de GB. (El α empírico es menor que la cola teórica porque el modelo NIST asume conservadoramente que la referencia de la ventana es el valor modal; la medición incluye el caso real de referencia aleatoria.)

**RCT.** El corte implementado (C=4, de \(1+\lceil 20/H \rceil\)) sí sigue la fórmula NIST y cumple α por muestra (2⁻²²·⁵ ≤ 2⁻²⁰). Medido: ~6×10⁻⁸ eventos/muestra en fuentes saludables (≈1 por 17 MB). Tras corregir el APT, esta pasa a ser la causa dominante de disparo benigno; es aceptable porque la respuesta (reseed/rotación) cuesta microsegundos, pero conviene consignarlo en el capítulo.

## 3. El costo de corregir: latencia de detección (W=512, 200 corridas, tope 50 M)

| H∞ real de la fuente | Mediana C=11 (actual) | Mediana C=16 (exacto) | Vía dominante (C=16) |
|---:|---:|---:|:---:|
| 7,0 | 2,9 M muestras | 11,1 M (95,4 % detecta) | RCT (205/206) |
| 6,5 | 460 k | 7,1 M | RCT (179/216) |
| 6,0 | 86 k | 1,1 M | APT (175/216) |
| 5,0 | 12 k | 18 k | APT |
| 4,0 | 5,3 k | 6,3 k | APT |
| 3,0 | 1,5 k | 1,7 k | APT |
| 0 (atascada) | 4 muestras (RCT) | 4 muestras (RCT) | RCT |

Lectura: para degradaciones **graves** (H ≤ 5) el corte exacto casi no cuesta latencia; para degradaciones **sutiles** (H 6,0–7,0) multiplica la latencia ~10×, pero ese rango es exactamente el que cubre la otra capa del módulo (§4). Los health tests de SP 800-90B están diseñados como detectores de **fallo catastrófico**, no de deriva fina — el barrido lo confirma.

## 4. La capa complementaria: estimador MCV y tamaño de lote

`ingest_source` re-estima \(H_\infty\) con el estimador MCV (§6.3.1 de SP 800-90B) y dispara rotación por `LowEntropy` si cae bajo la barra. El barrido revela que **el tamaño del lote de evaluación es un parámetro crítico** — con lotes pequeños, el máximo de 256 conteos binomiales infla \(\hat p_{\max}\) y el estimador flagea fuentes sanas:

| H∞ real | N=4.096 | N=16.384 | N=65.536 | N=262.144 |
|---:|---:|---:|---:|---:|
| 8,0 (perfecta) | **100 %** (!) | 19,9 % | **0,00 %** | 0,00 % |
| 7,6 (sana, margen 0,1) | 100 % | 38,4 % | 9,1 % | **0,60 %** |
| 7,5 (en la barra) | 100 % | 58,6 % | 49,0 % | 49,8 % |
| 7,2 (degradada) | 100 % | 98,2 % | **100 %** | 100 % |
| 7,0 / 6,5 | 100 % | 100 % | 100 % | 100 % |

Con **N = 65.536** el estimador ya no flagea la fuente perfecta y detecta el 100 % de degradaciones a H ≤ 7,2 **en un solo lote** — cubriendo el rango sutil que el APT exacto pierde. La fila H=7,5 (≈50 %) es esperable: una fuente sin margen sobre la barra es indistinguible del límite por construcción; de ahí la exigencia de margen en la calificación de la fuente.

## 5. Propuesta (para acordar con el director)

1. **APT: W = 512, C = 16**, calculado por binomial exacta (CRITBINOM) con α = 2⁻²⁰ — reemplazar la aproximación normal de `HealthMonitor::new` por la suma iterativa de la pmf (≈15 líneas; el harness ya contiene la función de referencia `exact_cutoff`). W=512 se mantiene: es el valor NIST para fuentes no binarias y el barrido no muestra ventaja que justifique cambiarlo.
2. **RCT: C = 4** — sin cambios (ya cumple la fórmula NIST).
3. **Evaluación MCV: lote mínimo de 65.536 muestras** en `ingest_source`, y exigir a la fuente una calificación con **margen ≥ 0,2 bits** sobre la barra (fuente calificada a ≥ 7,7 para barra 7,5); con margen 0,1 el falso positivo residual es 9 % por lote (o usar N=262.144, que lo baja a 0,6 %).
4. **Arquitectura de tres capas, ahora caracterizada empíricamente:** RCT (fallo catastrófico, ≤4 muestras) → APT (degradación fuerte, 10³–10⁶ muestras) → MCV (deriva sutil, 1 lote). Este cuadro va al Cap. 5.

**Nota de proceso:** el código de `HealthMonitor` **no se modificó todavía**: la Decisión 001 está asignada a la fase F1 del Plan de Trabajo (pendiente de acuerdo en la reunión inicial), así que el cambio queda preparado —la función de referencia `exact_cutoff` está en el harness— para aplicarse en cuanto se acuerde.

## 6. Archivos

- Harness: `nexus/nexus-crypto/examples/apt_sweep.rs` (RNG determinista, chequeo de equivalencia contra `HealthMonitor` incluido).
- Salida íntegra de la corrida del 2026-08-07: reproducible con el comando del encabezado.
