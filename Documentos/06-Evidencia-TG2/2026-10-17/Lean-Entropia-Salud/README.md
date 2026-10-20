# Lean: entropía, salud y recuperación del capítulo 5

Se añaden **87 resultados en siete módulos** y se pasa de 777 a **864 lemas y
teoremas registrados en 113 módulos**. La [auditoría completa](validacion.json)
es correcta. La tesis completa conserva obligaciones pendientes.

| Módulo | Resultados nuevos | Alcance |
|---|---:|---|
| [Entropia/Minima](../../../../formalizacion/Nexus/Entropia/Minima.lean) | 15 | Min-entropía, adivinación óptima, productos independientes, bloques IID y contraejemplo correlacionado |
| [Entropia/Shannon](../../../../formalizacion/Nexus/Entropia/Shannon.lean) | 8 | Frecuencias empíricas, soporte y cota de cinco bits para 32 bytes |
| [Salud/RCT](../../../../formalizacion/Nexus/Salud/RCT.lean) | 9 | Techo, minimalidad, corte cuatro y cota de falsas alarmas IID |
| [Salud/Binomial](../../../../formalizacion/Nexus/Salud/Binomial.lean) | 12 | Ley binomial de mathlib, colas finitas, recurrencia y dominación geométrica |
| [Salud/APT](../../../../formalizacion/Nexus/Salud/APT.lean) | 9 | Certificado racional del corte mínimo 16 para B=1+Bin(511,2^-7,5) |
| [Salud/Monitor](../../../../formalizacion/Nexus/Salud/Monitor.lean) | 13 | Contadores RCT/APT, ventanas, alarmas, fallo retenido e invariantes |
| [Salud/Fuente](../../../../formalizacion/Nexus/Salud/Fuente.lean) | 21 | Lotes, derivación, recuperación, renovación y conservación del monitor al rotar |

La min-entropía se define sobre distribuciones finitas normalizadas no vacías.
El máximo se alcanza y coincide con 2 elevado a menos la min-entropía: es la
probabilidad óptima de adivinar. La suma de min-entropías se prueba para productos
independientes y la regla de longitud para bloques IID. Dos bits con marginales
uniformes pero siempre iguales tienen solo un bit de min-entropía conjunta.
Ese contraejemplo impide usar la regla de acumulación sin una hipótesis conjunta.

La entropía empírica de n muestras se acota por log₂(min(n, cardinal del alfabeto)).
Para 32 bytes se obtiene **H_emp≤5<7,5**. El resultado no presupone una fuente
uniforme y no identifica la entropía empírica con el secreto de una clave.

El RCT usa C=1+ceil(-log₂(alpha)/H). Se prueba minimalidad, C=4 para H=7,5 y
alpha=2^-20, y la cota de la probabilidad de una racha IID de referencia y
C-1 repeticiones bajo min-entropía suficiente. No es una cota global para un
flujo de duración ilimitada ni un resultado sobre cualquier fuente dependiente.

El APT incluye la muestra de referencia: **B=1+Bin(511,p)**, con p=2^-7,5.
Se prueba que P[B≥15]>2^-20 y P[B≥16]≤2^-20; por monotonía, el corte mínimo
admisible es 16. El certificado usa racionales, la identidad p²=1/32768,
cotas de los pesos 14 y 15 y una razón de contracción a lo sumo 1/5 en la cola.
La cola finita se enlaza a la ley binomial de mathlib. Los decimales aproximados
1,523×10^-6 y 2,764×10^-7 del manuscrito todavía no se certifican con su precisión
de redondeo. El modelo binomial es condicional; no acredita que una fuente lo cumpla.

El monitor conserva el fallo y los contadores RCT entre ventanas APT. Se prueban
referencia incluida, cierre de ventana, alarmas, invariantes y equivalencia al
procesar un lote por partes. El gestor modela lotes de 65536 muestras, frecuencia
máxima exacta y compuertas por salud, renovación pendiente, cupo y edad.
Reevaluar sin renovar mantiene bloqueada la derivación. La rotación exige salud,
época disponible y éxito en la obtención de material fresco; conserva el monitor,
la estimación y el lote parcial. El indicador de material fresco representa el
éxito de esa operación; no demuestra una propiedad criptográfica del material.

## Trazabilidad y conservación

El [registro del manuscrito](../../../../formalizacion/revision-manuscrito.json)
mantiene 272 candidatos y 14 suplementos. El inventario base pasa de 36 a 46
bloques con enlaces parciales; la revisión complementaria pasa de 51 a 61 y
enlaza además SUP06–SUP07. M14 y M15 quedan como modelos verificados dentro de
su alcance finito; M16–M18 son parciales. Las 46 obligaciones se distribuyen
en 22 pendientes, 16 parciales, dos modelos verificados, tres dependencias
bibliográficas, dos respaldos documentales y un trabajo futuro. No es un porcentaje
de trabajo: los grupos tienen tamaño desigual.

Se conservan por hash las 143 fuentes no modificadas de la auditoría anterior.
Las seis fuentes previas actualizadas y las versiones anteriores de la revisión
y documentación están en [los antecedentes](../Entropia-Salud-Antecedentes/README.md).
Los capítulos, TG1 y Rust permanecen intactos. Se preservan los 1673 logs de las
27 etapas Lean anteriores.

## Comprobaciones reproducidas

```powershell
python scripts/verificar_formalizacion.py --salida .tools/lean/repeticion-entropia-salud
python scripts/verificar_revision_manuscrito.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_revision_manuscrito.py
```

La compilación completa y la auditoría de axiomas pasan sin advertencias.
`leanchecker` recompueba secuencialmente los 113 módulos confiando en sus
importados: no es `--fresh` ni un verificador externo. Solo se admiten `propext`,
`Classical.choice` y `Quot.sound`; no se usan `sorry`, axiomas propios ni
`native_decide`. El informe fija SHA-256 de **177 fuentes y 119 logs**.
Los cinco controles del analizador y los ocho de trazabilidad pasan; estos
controles no sustituyen la revisión matemática independiente.
Las reglas de Git conservan también los bytes del comprobador de revisión,
sus controles y README/bitácora para reproducir sus hashes al clonar.

La [comprobación de la revisión](revision-manuscrito.json) valida su trazabilidad
contra esta auditoría. El [control final de integridad](integridad-entropia-salud.json)
registra conservación de versiones, documentación y el [log de los trece controles](controles.log),
adicional al conjunto de logs de Lean del informe principal.

## Límites pendientes

No se acredita calificación física de una fuente ni conformidad integral con
[NIST SP 800-90B](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/nist.sp.800-90b.pdf).
La consulta normativa se limita a §§2.1, 4.4.1 y 4.4.2. Los modelos usan reales y
naturales; quedan equivalencia con Rust/f64, desbordamientos de máquina,
estimación estadística de la fuente, firma de operaciones, retiro, registro,
borrado, KDF y secrecia hacia adelante. La copia de `entropy.rs` es una fuente de
contraste del modelo, no un ejecutable verificado por Lean.

El siguiente bloque activo del manuscrito incluye residencia, cuentas de memoria,
amortización y complejidad, conservando los pendientes de salud. QROM AIR/FRI
continúa como trabajo futuro y R1 de firmas mantiene su alcance.
