# Revisión interna R1: ML-DSA, fuentes vigentes y límites de composición

Fecha: 12 de octubre de 2026. Revisión documental, matemática y de código; no constituye dictamen académico externo, prueba del binario ni garantía concreta de NEXUS. Se excluyen la sustentación y la transferencia QROM AIR/FRI, que permanece como trabajo futuro.

**Resultado.** Las delimitaciones de §6.4 son esencialmente correctas: Barbosa 2023 no mecaniza QROM de ML-DSA final, JMW24 no elimina SelfTargetMSIS para los perfiles actuales y LS15 no permite sustituir las distribuciones implementadas sin pasos adicionales. Se encontraron cuatro correcciones documentales concretas y una ampliación verificable de R1-D. La web aporta una mejora posterior del paso CMA→NMA; no cierra toda la cadena.

## 1. Hallazgos que conviene corregir ahora

| ID | Localizador vigente | Hallazgo y cambio recomendado |
|---|---|---|
| R1-I1 | Cap6, líneas 5, 11 y 16–17 | El mapa aún llama §6.4 «prueba de dureza post-cuántica» y la introducción habla de una «única afirmación criptográfica» del sistema. El propio §6.4.4 reconoce obligaciones abiertas y composición. Cambiar por «fundamentos y límites de seguridad postcuántica» y presentar inforjabilidad como uno de los requisitos de autorización. Describir los pasos como revisión de reducciones publicadas y de su aplicabilidad. |
| R1-I2 | Cap4, §4.5.2, línea 95 | «FIPS 204 exacto» afirma más que la evidencia. La migración adoptó los perfiles ML-DSA y su API; no se acreditó conformidad independiente, fuente aprobada ni comportamiento extremo completo. Sustituir por «adoptó los perfiles ML-DSA definidos en FIPS 204; la conformidad del conjunto no está acreditada». |
| R1-I3 | Cap4, §4.5.1, línea 89; entropy.rs, líneas 485–509; keypair.rs, líneas 77–84 | Se presenta la semilla como derivada del material de la fuente monitoreada. El código deriva SHA3-256(dominio, época, contador, semilla retenida, contexto), mientras el flujo observado controla una compuerta. La creación y rotación usan OsRng; no incorporan las muestras recibidas por ingest_source. Aclarar esta separación y no llamar a SHA3 un extractor calificado de esa fuente. Cap5 ya delimita la conformidad. |
| R1-I4 | Cap6, §6.4.1, párrafo sign_hash; transaction.rs, líneas 125–127; types.rs, líneas 32–38; signer.rs, líneas 55–56 y 105–121 | La firma de transacciones realiza bincode→SHA3-256→ML-DSA puro sobre 32 bytes. Es correcto decir que no llama a HashML-DSA, pero falta la obligación de composición con el hash externo. La seguridad de firmar el digest no implica la misma fuerza sobre transacciones distintas que pudieran compartir digest. |

Para R1-I4, FIPS 204 §5.4, p. 19 impresa / p. 29 PDF, exige fuerza clásica de colisión y segunda preimagen de al menos λ para conservar la del perfil; su Tabla 1 fija λ=128/192/256. La condición de longitud necesaria es 256/384/512 bits respectivamente. El digest externo actual tiene 256 bits: no se puede trasladar automáticamente la fuerza de ML-DSA-65/87 a esta composición. **Esto no demuestra una colisión alcanzable ni una falsificación del prototipo.** La solución inmediata es declarar la limitación; cambiar el protocolo o el código heredado requiere una decisión aparte. [FIPS 204, §5.4 y Tabla 1](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.204.pdf).

Párrafo propuesto para §4.3/§6.4:

> La ruta de transacciones serializa el contenido con bincode, calcula SHA3-256 y firma sus 32 bytes mediante ML-DSA puro con contexto vacío; no invoca HashML-DSA. La autenticidad del contenido requiere además resistencia a colisiones del hash externo y una codificación de aplicación inequívoca. FIPS 204 §5.4 trata expresamente tanto el hash a nivel de aplicación como HashML-DSA: para mantener la fuerza del perfil exige un digest con fuerza clásica de colisión y segunda preimagen de al menos λ. El SHA3-256 externo no permite trasladar automáticamente la fuerza de ML-DSA-65/87 a las transacciones. Esta observación limita la composición; no demuestra un ataque concreto ni un incumplimiento de la operación ML-DSA pura que firma el digest.

## 2. Lo que sí se confirmó

Los seis archivos centrales del backend instalado fips204 0.4.6 coinciden byte a byte con la instantánea R1: lib.rs, traits.rs, ml_dsa.rs, hashing.rs, conversion.rs y types.rs. El envoltorio real selecciona ML-DSA-44/65/87, reconstruye con keygen_from_seed y firma por try_sign(message, contexto vacío). traits.rs:156–157 llama a OsRng; lib.rs:268–291 obtiene 32 bytes y propaga el error. ml_dsa.rs:198–201 mezcla K, rnd y μ. Se confirma **puro, hedged y contexto vacío**, sin confundir determinismo de KeyGen con determinismo de firma. No se descargó ni cambió una dependencia.

La definición SelfTargetMSIS de Cap6:84 conserva correctamente la convención [I_m|A] y el reto como última coordenada. Se recalculó la condición estricta de JMW24 usando constantes reales, η auxiliar mínima 1 y dimensión k+ℓ+1:

| Perfil | ζ | 2ζ·256·(k+ℓ+1) | ⌊q/32⌋ | Aplicación directa |
|---|---:|---:|---:|---|
| ML-DSA-44 | 350209 | 1613763072 | 261888 | No |
| ML-DSA-65 | 724481 | 4451211264 | 261888 | No |
| ML-DSA-87 | 769537 | 6304047104 | 261888 | No |

JMW24 sigue en arXiv v2, 7 de marzo de 2024; el PDF descargado coincide con el conservado. Su Teorema 2, p. 8, incluye pérdidas en Q, nq^-k, tamaño del reto y aproximación; §4, p. 15, da la traducción usada. El resultado negativo es de **aplicabilidad de ese teorema**, no ataque, imposibilidad de otra reducción ni dureza probada de SelfTargetMSIS. [JMW24 v2](https://arxiv.org/abs/2312.16619v2).

La fórmula de Barbosa, Teorema 2, p. 22, está bien transcrita. Reproduje log2(L_Q)=−361,640655705522… para los datos de su Figura 8, con 100 dígitos decimales de precisión. El PDF CWI descargado coincide con el preservado. El alcance de su mecanización ROM de §6, p. 24, mantiene matriz y máscaras directamente muestreadas y bucle no acotado. La separación respecto de ML-DSA final y sUF-CMA es correcta; un lema elemental de diferencia de preimágenes no reemplaza los cambios de juego. [Barbosa et al., fuente CWI](https://ir.cwi.nl/pub/33405/33405.pdf).

LS15, versión preservada, confirma los localizadores del manuscrito: Teorema 3.6 para Mod-GIVP→M-SIS; Definición 4.6 / Teorema 4.7 para M-SLWE y búsqueda→decisión; Teorema 4.8 cambia módulo y ruido. El aviso de distribución gaussiana frente a secretos/errores uniformes pequeños es necesario. Conservarlo. El argumento prudente sobre Shor de §6.4.3 también debe conservarse: no aplicabilidad directa no prueba ausencia de otro ataque cuántico.

## 3. Actualización web útil: FFH25/26

Fallahpour, Fehr y Huang mejoran **CMA→NMA** en QROM, con firma consultada clásicamente y simulación de transcripciones aceptantes acHVZK. En el PDF CWI de 21 páginas, Teorema 1 / Corolario 1, p. 9, la pérdida es:

L ≤ 8q_S√((q_H+1)ε̄)/(1−p̄) + q_Sζ + Pr[¬Γ_p] + Pr[¬Γ_ε].

Exige control del rechazo en Γ_p y concentración media en Γ_ε. No resuelve SelfTargetMSIS, el perfil hedged/semillado, sUF del ejecutable ni Sentinel. [Texto examinado CWI35239](https://ir.cwi.nl/pub/35239/35239.pdf).

ePrint registra revisión 7/4/2026; Springer confirma publicación CRYPTO 2026, 16/8/2026, pp. 603–631. El PDF ePrint actual devolvió HTTP 403; el texto CWI no se declara idéntico a esa revisión. [Historial ePrint](https://eprint.iacr.org/2025/985), [edición publicada](https://link.springer.com/chapter/10.1007/978-3-032-35398-6_20).

Párrafo sugerido para §6.4.1:

> Fallahpour, Fehr y Huang aportan posteriormente una reducción CMA→NMA QROM más ajustada bajo simulación de transcripciones aceptantes, consultas clásicas de firma y control del rechazo y la concentración. Este avance mejora un paso de la prueba; no acredita la correspondencia completa de ML-DSA implementado ni elimina las obligaciones R1. La fórmula B+23 se conserva como reproducción de su versión citada.

Con los mismos datos y evento B23, el cálculo FFH del script da log2(L)≈−362: domina el evento excepcional. No confundir esta comparación con las tablas FFH que optimizan sus eventos y parámetros.

Otra fuente primaria relevante delimita la palabra hedged: Kosuge–Xagawa, ePrint 2025/904, revisión 8/9/2025, prueba resistencia a clases específicas de fallos y describe recuperación de clave en otras. No respalda resistencia universal a inyección. Basta citarla como contexto del límite de implementación, que la tesis ya excluye. [Registro de los autores](https://eprint.iacr.org/2025/904).

## 4. R1-D: contador de rechazo, ahora caracterizado

El riesgo no proviene de convertir L a u16, que es exacto para L=4/5/7. Proviene de sumar en u16: ml_dsa.rs:204 inicializa κ; líneas 281 y 316 incrementan por L al rechazar; hashing.rs:293 calcula μ+r. Sin una comprobación previa ni error explícito, el contador puede desbordar si no hay aceptación:

| Perfil | Intentos completos con nonces sin desbordamiento | Primer punto extremo |
|---|---:|---|
| 44 | 16384 | Al rechazar el intento 16384, κ+4 excede u16 |
| 65 | 13107 | ExpandMask del intento 13108: μ=65535 y μ+r excede u16 |
| 87 | 9362 | ExpandMask del intento 9363: μ=65534 y μ+r excede u16 |

Con comprobación de overflow puede haber pánico; con aritmética modular se reutilizan nonces al prolongar el bucle. Los perfiles Cargo no activan expresamente overflow-checks para release. El resultado anterior es **análisis condicional de flujo y aritmética**, no ejecución de una semilla patológica, ni probabilidad de ocurrencia demostrada, ni explotación. La conducta exacta depende de las opciones de compilación. Para cerrar robustez debe imponerse un límite admisible antes del desbordamiento y propagarse un error; no se cambió el backend ni Rust en esta revisión.

La página NIST sigue mostrando errata potencial de 31/7/2026. El XLSX descargado coincide por SHA-256 con el del expediente, por lo que sus estimaciones de repeticiones y la propuesta 821 no se presentan como otra edición del estándar. [Estado oficial FIPS204](https://csrc.nist.gov/pubs/fips/204/final).

## 5. Qué puede cerrarse internamente y qué necesita otra instancia

**Internamente cerrado por esta revisión:** identidad de fuentes preservadas y backend; corrección aritmética B23 y JMW24; clasificación del perfil; caracterización del desbordamiento y localizadores; actualización bibliográfica y correcciones R1-I1–I4 propuestas. El cierre de un análisis no significa corregir la implementación.

**Pendiente para garantía concreta:** cambios de distribución y expansores, codificaciones/hints/reto, sUF-CMA, modelo de aleatoriedad hedged, fuente/KDF, hash externo de transacciones y terminación con error. No asignar cifras de seguridad al ejecutable mientras falten. **Pendiente académico:** decisión del director/lector competente sobre suficiencia del alcance y resolución de observaciones; no puede reemplazarse por acuerdo entre agentes.

La tesis puede defender un mapa preciso de fundamentos, aplicabilidad y límites; si el alcance aprobado exige una reducción concreta completa, corresponde acordar esa diferencia, sin afirmar que ya está resuelta. No se reabre QROM AIR/FRI.

## 6. Evidencia nueva y alcance de ejecución

- [Script reproducible propio](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/R1/verificar_r1.py): descarga y fija huellas, compara backend, calcula condición JMW, pérdida B23/FFH condicionada y límites u16. No escribe en paquetes anteriores.
- [Resultado JSON](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/R1/verificacion.json): incluye URLs, SHA-256, igualdad de instantáneas y fallo 403 explícito.
- Los PDFs públicos descargados y textos extraídos quedan en la misma carpeta de evidencia. No se distribuyen como aportes propios.
- No se ejecutaron de nuevo las suites Rust comunes; el agente coordinador las ejecutará al consolidar. No hubo cambios en TG1, manuscrito compartido, Rust, manifiesto ni seguimiento raíz.
