# Ruta de estudio — Tesis NEXUS

**Propósito:** repaso completo de la tesis en **7 sesiones de ~2 horas** (una semana y media a 1 sesión/día, o un fin de semana intensivo). El orden no es el de los capítulos: va de *mapa general* → *núcleo defendible* → *contribuciones TG2* → *simulacro de defensa*.

> Volumen total: ~18.000 palabras de manuscrito + notas de investigación + código Rust (110/110 tests).

---

## Sesión 0 — El mapa antes del territorio (~1 h)

**Objetivo:** recuperar la visión de pájaro antes de entrar al detalle.

1. [Plan-Maestro-Tesis.md](Documentos/02-Investigacion-y-Notas/Plan-Maestro-Tesis.md) — torre de control.
2. [Alcance-y-Objetivos-v2.md](Documentos/02-Investigacion-y-Notas/Alcance-y-Objetivos-v2.md) — **el documento más importante de toda la ruta**. Los 4 objetivos y la tabla de la §1 (qué se eliminó y por qué) son la columna vertebral de cualquier pregunta del jurado.
3. [BITACORA_TG2.md](BITACORA_TG2.md) — cronología de decisiones.

**Auto-chequeo:**
- [ ] Recitar de memoria los 4 objetivos específicos.
- [ ] Explicar en una frase por qué se eliminó la biometría.
- [ ] Explicar en una frase por qué Shannon fue reemplazada por min-entropía.

Esas dos decisiones son las que más probablemente pregunten ("¿por qué cambió el alcance?").

---

## Sesión 1 — Motivación y marco teórico (Caps. 1–2)

1. [Cap1-Introduccion.md](Documentos/01-Manuscrito/Capitulos/Cap1-Introduccion.md) (~1.350 palabras, rápido).
2. [Cap2-Marco-Teorico.md](Documentos/01-Manuscrito/Capitulos/Cap2-Marco-Teorico.md) (~1.600 palabras, lento — aquí está la matemática).

**Conceptos a dominar sin mirar:**

- **Amenaza cuántica:** qué rompe Shor exactamente (DLP/factorización → ECDSA/RSA) y por qué *no* aplica a retículos. Refuerzo: [096 — Shor's Algorithm](Documentos/05-Estado-del-Arte/Papers-y-Articulos/096_What%20Is%20Shor's%20Algorithm_%20The%20Quantum%20Threat%20Explained%20-%20PostQuantum.com.md). "Harvest now, decrypt later" como argumento bancario.
- **Retículos:** Module-LWE, Module-SIS, SelfTargetMSIS, y la reducción de peor caso a Mod-SIVP ([099 — Worst-Case to Average-Case](Documentos/05-Estado-del-Arte/Papers-y-Articulos/099_Worst-Case%20to%20Average-Case%20Reductions%20for%20Module%20Lattices.md)).
- **Fiat-Shamir with aborts** y qué significa QROM (y por qué la prueba vive en ese modelo).

**Auto-chequeo:**
- [ ] Explicar en voz alta, en 2 minutos, por qué un adversario cuántico no resuelve MLWE eficientemente (no hay estructura de subgrupo oculto abeliano explotable). Tener a mano el argumento de Kuperberg ([047](Documentos/05-Estado-del-Arte/Papers-y-Articulos/047_Kuperberg's%20Algorithm%20and%20its%20Impact%20on%20Post-Quantum%20Cryptography%20(PQC).md)) por si preguntan por el caso dihedral.

---

## Sesión 2 — Arquitectura dual-chain (Cap. 3 + Obj 1)

1. [Cap3-Diseno-Arquitectura.md](Documentos/01-Manuscrito/Capitulos/Cap3-Diseno-Arquitectura.md) (~3.100 palabras, el segundo más largo).
2. Complemento: [Analisis-Overhead-PQC-DualChain.md](Documentos/02-Investigacion-y-Notas/Analisis-Overhead-PQC-DualChain.md).

**Dominar el "camino de la firma"** (es literalmente el Objetivo 1):

> transacción → mempool → Nexus Sequencer → ejecución/verificación → asentamiento en Anchor L1

**Punto crítico de honestidad (pregunta segura del jurado):** qué es *modelo de referencia* vs. qué está *implementado*. ZK (Nitro Verifier), consenso BFT y disponibilidad de datos son **diseño + trabajo futuro**, declarados así explícitamente. Decirlo con seguridad, no como confesión: la tesis eligió profundidad (núcleo criptográfico verificado) sobre amplitud, y esa decisión está formalizada en la modificación de objetivos aprobada en TG1.

---

## Sesión 3 — Núcleo criptográfico (Cap. 4 + Obj 2) — teoría y código juntos

1. [Cap4-Nucleo-Criptografico.md](Documentos/01-Manuscrito/Capitulos/Cap4-Nucleo-Criptografico.md).
2. Con el capítulo abierto, recorrer el código: [nexus/nexus-crypto/](nexus/nexus-crypto/) — sobre todo firma/verificación vía `fips204` y la derivación determinística semilla → clave (SHAKE256 con separación de dominio).
3. Papers de respaldo: [014 — CRYSTALS-Dilithium](Documentos/05-Estado-del-Arte/Papers-y-Articulos/014_CRYSTALS-Dilithium.md) y [055 — FIPS 204](Documentos/05-Estado-del-Arte/Papers-y-Articulos/055_Module-Lattice-Based%20Digital%20Signature%20Standard%20_%20FIPS%20204%20_%20NIST%20Technical%20Seri.md).

**A dominar:**
- [ ] KeyGen/Sign/Verify a nivel de algoritmo: qué se muestrea, qué es el rechazo/abort, qué contiene la firma (z, h, c̃).
- [ ] Niveles 2/3/5 y sus tamaños.
- [ ] Por qué la KeyGen determinística desde semilla de 32 bytes es *estándar* en FIPS 204 (ancla el Obj 2 y también la contribución C1).

**Verificación práctica** (confirmar que sigue en verde y poder decirlo con fecha):

```powershell
# desde nexus/
$env:CARGO_TARGET_DIR = "C:\tmp\nexus-target"; cargo test   # esperado: 110/110
```

---

## Sesión 4 — Gestión del ciclo de vida de claves (Cap. 5 + Obj 3)

1. [Cap5-Gestion-Claves.md](Documentos/01-Manuscrito/Capitulos/Cap5-Gestion-Claves.md) (~2.500 palabras).
2. Código en paralelo: `entropy.rs` en [nexus/nexus-crypto/](nexus/nexus-crypto/) (RCT, APT, estimación de min-entropía, rotación forward-secure, bloqueo ante fallo de salud).
3. Papers: [077 — NIST SP 800-90B](Documentos/05-Estado-del-Arte/Papers-y-Articulos/077_Recommendation%20for%20the%20Entropy%20Sources%20Used%20for%20Random%20Bit%20Generation%20-%20NIST%20Tec.md) y [082 — SP 800-90B Overview](Documentos/05-Estado-del-Arte/Papers-y-Articulos/082_SP%20800-90B%20Overview%20-%20NIST%20Computer%20Security%20Resource%20Center.md).

**A dominar:**
- [ ] La definición H∞(X) = −log₂ max Pr[X=x] y por qué mide lo que Shannon no.
- [ ] Cómo funcionan RCT y APT y qué degradación detecta cada una.
- [ ] Qué significa rotación *forward-secure* (nueva semilla mezclada con la anterior vía hash) y sus tres disparadores: uso, edad, fallo de salud.

**Ojo TG2:** aquí viven las **Decisiones 001 (parámetros W/C de APT) y 002 (registro auditable en Key Registry)**, aún abiertas según el [Plan-de-Trabajo-TG2.md](Documentos/04-Administrativo-TG2/Plan-de-Trabajo-TG2.md) — son lo primero a discutir con el director en la fase F1.

---

## Sesión 5 — Validación formal (Cap. 6 + Obj 4) — **la sesión más pesada**

[Cap6-Validacion-Formal.md](Documentos/01-Manuscrito/Capitulos/Cap6-Validacion-Formal.md) tiene ~5.700 palabras — el capítulo más largo y el corazón de la defensa. Sesión entera, posiblemente dos pasadas.

**La cadena de reducciones, para poder dibujarla en un tablero:**

> sUF-CMA de Dilithium → MLWE + SelfTargetMSIS + MSIS → (peor caso) Mod-SIVP

Para cada flecha: qué juego se reduce a qué problema y qué papel juega el QROM. Apoyo: [078 — Revisiting Post-Quantum Fiat-Shamir](Documentos/05-Estado-del-Arte/Papers-y-Articulos/078_Revisiting%20Post-Quantum%20Fiat-Shamir%20-%20NSF%20PAR.md) y [002 — Fiat-Shamir en QROM](Documentos/05-Estado-del-Arte/Papers-y-Articulos/002_A%20Concrete%20Treatment%20of%20Fiat-Shamir%20Signatures%20in%20the%20Quantum%20Random-%20Oracle%20Mod.md).

**Complejidad:**
- [ ] Verificación dominada por la NTT — O(n log n) por multiplicación, O(kℓ·n log n) por operación.
- [ ] Overhead del esquema dual.
- [ ] Números de los benchmarks Criterion frescos (órdenes de magnitud, no decimales exactos).

**Pendiente TG2:** falta la comparativa Dilithium vs. ECDSA/RSA en la misma suite (fase F2).

---

## Sesión 6 — Contribuciones propias TG2 (C1–C4) + conclusiones

1. [Cap7-Conclusiones.md](Documentos/01-Manuscrito/Capitulos/Cap7-Conclusiones.md).
2. [Estado-del-Arte-Claves-Efimeras-y-Deception.md](Documentos/02-Investigacion-y-Notas/Estado-del-Arte-Claves-Efimeras-y-Deception.md) y [Estado-del-Arte-Pagos-Agenticos.md](Documentos/02-Investigacion-y-Notas/Estado-del-Arte-Pagos-Agenticos.md).
3. [Dilithium-Multisemilla-Efecto-Observador-V2.md](Lluvia%20de%20ideas/Dilithium-Multisemilla-Efecto-Observador-V2.md) — el diseño V2 de C1–C3.

**El argumento de novedad — la mejor carta en la defensa:** seed-only ya es estándar (RFC 9881); lo novedoso es:

| ID | Contribución | Dato clave a memorizar |
| :-- | :--- | :--- |
| C1 | **KeyGen-por-firma** como política de minimización de exposición | +0,75 ms/firma; huella en reposo **187,3×** menor |
| C2 | **Métrica W = bytes × Δt** de ventana de exposición | Hueco confirmado; lo más cercano: Sawa et al. ACSAC 2025 |
| C3 | **Deception Engine PQ** (honeytoken + sequencer-honeychecker) | Diseño formal; PoC opcional **no comprometido** |
| C4 | **Caso de uso agéntico** (pagos por agentes de IA) | 18 referencias verificadas en bibliografía |

El SoK arXiv:2604.03733 declara abiertas exactamente las brechas que C1–C3 atacan (*weak intent binding*, *misuse under valid authorization*, *limited accountability*) — esa correspondencia es el sustento de defensa.

---

## Sesión 7 — Simulacro de defensa y estado del arte competitivo

1. [comparativa_estado_actual_vs_estado_del_arte.md](Documentos/02-Investigacion-y-Notas/comparativa_estado_actual_vs_estado_del_arte.md) e [Ideas-Ethereum-Solana-para-NEXUS.md](Documentos/02-Investigacion-y-Notas/Ideas-Ethereum-Solana-para-NEXUS.md) — los roadmaps de Ethereum (leanXMSS) y Solana (Falcon) de 2026 **validan la tesis desde la industria**: usarlos como munición, no como amenaza.

2. **Responder en voz alta** (banco mínimo de preguntas probables):
   - [ ] ¿Por qué dual-chain y no una sola cadena con Dilithium?
   - [ ] ¿Por qué Dilithium/ML-DSA y no Falcon o SPHINCS+? (apoyo: [086 — NIST Round 3 Report](Documentos/05-Estado-del-Arte/Papers-y-Articulos/086_Status%20Report%20on%20the%20Third%20Round%20of%20the%20NIST%20Post-Quantum%20Cryptography%20Standardi.md))
   - [ ] ¿Qué garantiza exactamente la prueba de seguridad y qué *no*? (canales laterales fuera de alcance, modelo QROM)
   - [ ] Si las firmas son 40× más grandes que ECDSA, ¿cómo lo absorbe una banca real? (análisis de overhead)
   - [ ] ¿Qué queda implementado vs. diseñado? (respuesta ensayada, sin titubear)
   - [ ] ¿Por qué KeyGen-por-firma si draft-connolly recomienda cachear? (justificación C1)

---

## Consejos transversales

1. **Estudiar siempre capítulo + código + paper en la misma sesión.** La ventaja frente al jurado es que el prototipo es real y verificable, y eso solo se nota navegando el código con soltura.
2. **Checklist final de fuentes:** [00_INDICE_DE_FUENTES.md](Documentos/05-Estado-del-Arte/Papers-y-Articulos/00_INDICE_DE_FUENTES.md). Los ~10 papers enlazados arriba son de relectura obligatoria; el resto basta con reconocerlos por título.

## Relectura obligatoria (resumen)

| # | Paper | Sesión |
| :-- | :--- | :-- |
| 096 | Shor's Algorithm — the quantum threat | 1 |
| 099 | Worst-Case to Average-Case Reductions for Module Lattices | 1 |
| 047 | Kuperberg's Algorithm and its impact on PQC | 1 |
| 014 | CRYSTALS-Dilithium (paper original) | 3 |
| 055 | FIPS 204 / ML-DSA | 3 |
| 077 | NIST SP 800-90B (entropy sources) | 4 |
| 082 | SP 800-90B Overview | 4 |
| 078 | Revisiting Post-Quantum Fiat-Shamir | 5 |
| 002 | Fiat-Shamir Signatures in the QROM | 5 |
| 086 | NIST PQC Round 3 Status Report | 7 |
