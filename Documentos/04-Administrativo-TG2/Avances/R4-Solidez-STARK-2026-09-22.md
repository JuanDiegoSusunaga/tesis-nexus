# R4 — Auditoría de solidez del PoC STARK

**Fecha:** 22 de septiembre de 2026. **Estado:** caracterización del protocolo y cálculos ejecutados; garantía completa de solidez pendiente.

## Resultado

La cifra histórica de **100 bits no queda justificada para NEXUS**. Se comprobó qué calcula el presupuesto heredado, qué ejecuta el verificador y qué requisitos añaden las fuentes. No se encontró mediante estos ensayos una prueba aceptada de un enunciado AIR falso. Las fuentes de producción del STARK se preservan; se añadieron siete pruebas TG2 y un análisis reproducible.

El manuscrito incorpora §6.7.1 y la Tabla 6.15. La evidencia queda en [R4-solidez](../../06-Evidencia-TG2/2026-09-22/R4-solidez/analisis.json), con fuentes, hashes, publicaciones y resultados.

## Correspondencia del protocolo

| Componente | Comportamiento observado | Interpretación |
|---|---|---|
| Dominio y grado | N=8T; cota FRI estricta 2T; log2(2T) capas | Tasa nominal 1/4 |
| Índices | min(40,4T) parejas distintas | Cuatro y ocho filas usan 16 y 32 consultas; TG2 admite desde 16 filas |
| Presupuesto heredado | Devuelve 100 para todo tamaño y usa 20 bits de trabajo | No refleja trazas pequeñas ni el perfil de desarrollo |
| Enunciado | Inicio, salida y filas preceden a raíz de traza y coeficientes | Cambios concretos comprobados con rechazo |
| FRI | Cada raíz precede al coeficiente; valor final precede al nonce y consultas | Se conserva el orden del protocolo |
| Grinding | 12 bits en desarrollo, 20 en release; admite cualquier nonce válido | Encarece la búsqueda de otros retos; no la impide |
| Traza | Aperturas locales y composición; FRI sobre la composición | La reducción desde funciones arbitrarias a una ejecución válida requiere demostración |
| Merkle | La API genérica no rechaza el alias de índice i+N | Precondición de rango; AIR deriva índices válidos |

La altura del sobre permanece fuera del enunciado AIR, como se registró en R4. El perfil canónico exige tamaño y campos válidos antes de invocar la aritmética.

## Ensayo de proximidad

Se comprometió una palabra de longitud **512**, cero salvo una posición, seguida por capas de ceros. La palabra tiene distancia **1/512** a cero, pero interpolación de grado **511**, superior a la cota **128**. En **32 contextos públicos fijos**, FRI aceptó **28** y rechazó **4**. El resultado coincide exactamente con evitar o consultar la pareja inconsistente.

En un modelo ideal de 40 parejas distintas y uniformes entre 256, evitar una pareja fija tiene probabilidad **216/256 = 27/32**. La frecuencia observada 28/32 no se usa como estimador de un error criptográfico. El ensayo usa FRI aislado, sin grinding; **no es una falsificación del AIR ni contradice la garantía de proximidad de FRI**.

Esta distinción impide usar aceptación FRI como demostración de pertenencia exacta al código. Además, la composición con las restricciones del AIR necesita su propio argumento.

## Cálculos reproducibles

[analizar_solidez_stark_r4.py](../../../scripts/analizar_solidez_stark_r4.py) lee las constantes del código y conserva [analisis.json](../../06-Evidencia-TG2/2026-09-22/R4-solidez/analisis.json), [tabla-parametros.md](../../06-Evidencia-TG2/2026-09-22/R4-solidez/tabla-parametros.md) y las fuentes.

### Muestreo del campo

Cada coordenada reduce una cadena de 128 bits módulo p. Para M=2^128, M=ap+r, la distancia de variación total frente a uniforme es **r(p−r)/(pM)**. Aquí r=18446744065119617025 y su exponente negativo es aproximadamente **96,0000000003**. La masa puntual máxima es (a+1)/M; el análisis conserva también su cuadrado para el reto de extensión bajo bytes independientes ideales.

La distancia estadística no demuestra un ataque ni fija por sí sola 96 bits de seguridad del sistema. Para eventos algebraicos puede utilizarse la masa puntual máxima en vez de introducir innecesariamente toda la distancia como error aditivo. Ninguno de esos cálculos demuestra independencia de SHA3 o seguridad QROM.

### Escenario de referencia de BT24

Se evalúa la fórmula citada con rho=1/4, m=3, eta=1/24 y delta=5/12, que satisfacen las restricciones numéricas del Teorema 1. Para 40 consultas y 20 bits de trabajo:

- El término de consultas y trabajo es (7/12)^40 · 2^-20; su exponente negativo es **51,1043**.
- El término algebraico es (7/2)^7 · N² /(3 · (1/4)^(3/2) · p²). Sus exponentes negativos son **99,9335**, **83,9335** y **71,9335** para T=16, 4096 y 262144.
- El máximo de esos términos en el escenario queda gobernado por el término de consultas. La transformación clásica añade dependencia del presupuesto Q y de la longitud de hash.

**Estos números son aritmética de una referencia, no una cota ni una estimación certificada de NEXUS.** Se eligió un escenario válido; no se optimizaron parámetros ni se estableció la correspondencia con todos los detalles del código. El resultado tampoco demuestra un ataque de ese costo.

## Fuentes primarias

[bibliografia.json](../../06-Evidencia-TG2/2026-09-22/R4-solidez/bibliografia.json) identifica las copias y hashes:

- [FRI18](https://doi.org/10.4230/LIPIcs.ICALP.2018.14), 17 páginas: define la tarea de proximidad Reed–Solomon, que depende de la distancia al código.
- [BGK+23](https://eprint.iacr.org/2023/1071.pdf), versión del 15 de febrero de 2024, 87 páginas: Teoremas 3.15 y 4.1, Corolario 4.3 y Teorema 4.6; §6 trata la composición mediante acuerdo correlacionado. La transferencia cuántica tiene condiciones y pérdidas propias.
- [BT24](https://eprint.iacr.org/2024/1161.pdf), 28 páginas: Lema 1, p. 7; Teorema 1, pp. 7–8; §3.2, pp. 8–9; §4, pp. 10–11. Separa errores por ronda, consultas al oráculo y trabajo, bajo el marco clásico analizado.

Los localizadores usan páginas PDF de las versiones conservadas. No se declara una revisión exhaustiva de toda la literatura STARK.

## Pruebas y límites

[tg2_soundness.rs](../../../nexus/nexus-zk/tests/tg2_soundness.rs) añade siete casos: consultas, presupuesto nominal, enlace de campos AIR, nonces alternativos, retos canónicos, precondición Merkle y proximidad FRI.

- **173 pruebas** del workspace pasan en desarrollo.
- Los **siete casos nuevos también pasan en release**.
- Cargo check del workspace con all-targets y cargo build terminan correctamente.
- Se mantienen advertencias preexistentes. No se repitieron benchmarks.

[validacion.json](../../06-Evidencia-TG2/2026-09-22/R4-solidez/validacion.json) conserva comandos, perfiles, conteos, logs y hashes. La ejecución release comprende los siete casos nuevos, no toda la suite.

## Obligaciones para una garantía completa

| ID | Trabajo pendiente | Criterio de cierre |
|---|---|---|
| S1 | Reducción algebraica del AIR | Cotas de grado y cancelación, frontera y transición, con enunciado y modelo adversario explícitos |
| S2 | Proximidad y enlace de oráculos | Justificar correlación de traza y composición, o desarrollar una variante experimental con comprobaciones suficientes |
| S3 | Fiat–Shamir y compromisos | Correspondencia de muestreo/transcripción/Merkle y pérdidas concretas en ROM y QROM |
| S4 | Parámetros y exposición de API | Objetivo de seguridad, tamaños admitidos, perfiles y precondiciones documentados; evitar presentar el presupuesto heredado como certificado |
| S5 | Revisión independiente | Revisión matemática del argumento y resolución de observaciones |

**Siguiente trabajo técnico:** S1 y S2. La caracterización está terminada; la demostración completa de solidez continúa abierta. Se mantienen también los límites anteriores de conocimiento cero, raíces completas e integración L2/L1.

## Edición documental

Word tiene **96 páginas** y PDF **87**, con **27 tablas / 711 celdas**, tres figuras y 391 objetos matemáticos nativos en Word, incluidos 20 bloques. Se inspeccionaron la tabla y la ecuación nuevas en ambos formatos; las tablas coinciden con la conversión independiente y conservan cuerpo y rótulo juntos en Word. Las fuentes y ubicaciones de las figuras coinciden con la revisión R1.

La identificación del Word, PDF, capítulos y figuras se conserva en [revision-manuscrito.json](../../06-Evidencia-TG2/2026-09-22/R4-solidez/revision-manuscrito.json). Los informes R1 y R4/R5 anteriores conservan sus conteos y hashes históricos.
