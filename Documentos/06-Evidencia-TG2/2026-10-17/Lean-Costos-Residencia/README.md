# Lean: residencia, memoria, amortización y complejidad

La pasada M19–M24 añade **118 resultados en siete módulos**. Se alcanzan
**982 lemas y teoremas registrados en 120 módulos**, con [auditoría completa](validacion.json)
correcta. La tesis completa no está verificada.

| Módulo | Resultados nuevos | Alcance |
|---|---:|---|
| [Modelos/ResidenciaIntegral](../../../../formalizacion/Nexus/Modelos/ResidenciaIntegral.lean) | 29 | Integral por regiones, unión de intervalos, medias y enlace a la tabla 5.2 |
| [Modelos/CapturaUniforme](../../../../formalizacion/Nexus/Modelos/CapturaUniforme.lean) | 13 | Ley uniforme continua, coincidencia temporal y porcentajes de la tabla 5.2 |
| [Modelos/Memoria](../../../../formalizacion/Nexus/Modelos/Memoria.lean) | 11 | Representaciones R5 y cuentas de contenedores y copias |
| [Modelos/AmortizacionVariable](../../../../formalizacion/Nexus/Modelos/AmortizacionVariable.lean) | 15 | Prueba variable, límites, equilibrio y sensibilidad de §6.6.5 |
| [Complejidad/NTT](../../../../formalizacion/Nexus/Complejidad/NTT.lean) | 24 | Recurrencia radix dos, fórmulas cerradas y cotas gruesa y optimizada |
| [Complejidad/Rechazo](../../../../formalizacion/Nexus/Complejidad/Rechazo.lean) | 19 | Ley geométrica, integrabilidad, esperanza, agotamiento y costo esperado |
| [Complejidad/Firma](../../../../formalizacion/Nexus/Complejidad/Firma.lean) | 7 | Composición NTT/rechazo y contraejemplo sin barra uniforme |

## Residencia y captura temporal

Cada región declara bytes no negativos e intervalo de actividad. La residencia
es la integral de los bytes activos sobre (0,T]; los extremos no alteran la
medida de Lebesgue. Se prueba recorte por horizonte, integrabilidad, no negatividad
y suma exacta de bytes por duración para las regiones contenidas. Las copias se
cuentan por separado, incluidas las simultáneas.

Para coincidencia temporal se usa la unión de intervalos. Su longitud es a lo
sumo la suma de duraciones y coincide con ella bajo disjunción. Dos intervalos
idénticos muestran que sumar sus duraciones duplicaría la exposición temporal.
La distribución continua se construye restringiendo y normalizando Lebesgue
en el horizonte positivo. La probabilidad es longitud de la unión dividida por T.
También se prueba la fórmula para una variable aleatoria con esa ley uniforme.
El calendario es fijo; no se acreditan capturas persistentes o sincronizadas.

El modelo retenido/cacheado da (b+s)T. La reexpansión da bT+s·longitud(E),
media b+s·rho y, con n intervalos disjuntos de duración tau, rho=(n/T)tau≤1.
Se enlaza la media con el modelo racional existente y se prueban sus cotas y
razón. Los quince redondeos de la tabla 5.2 quedan vinculados a la integral y
a la ley temporal bajo los supuestos declarados. No se interpreta la razón
de bytes como una reducción de probabilidad de compromiso.

## Contabilidad y amortización

Se comprueban 4032−96=3936, 4032+1952+9=5993 y 128+17·256·4=17536,
además de la suma de copias y 32+4032=4064. El [inventario R5 preservado](../Costos-Residencia-Antecedentes/datos-modelos.json)
identifica fips204 0.4.6, fuentes y logs de los tamaños. Es una contabilidad de
representaciones declaradas; no verifica layout Rust/ABI, RAM total, entropía ni borrado.

Para F(m)=d+(c+pi(m))/m se demuestra el límite d+L cuando pi(m)/m→L;
en particular, F(m)→d equivale a pi(m)/m→0. Hay piso con costos no negativos,
condición exacta de equilibrio y suma de disponibilidad por operación. Una prueba
lineal deja un término a en el límite d+a. Una familia a·log(m)^r+b es sublineal,
tanto en bytes como en costo amortizado de verificación. Se certifican los cinco
redondeos de §6.6.5, incluidos duplicación de prueba y 3309 bytes adicionales de DA.
Son escenarios aritméticos, no mediciones del sistema completo.

## Complejidad y rechazo

La familia radix dos tiene n=2^r. El calendario satisface C(0)=0 y
C(r+1)=2C(r)+2^r. Se prueba 2C(r)=r·2^r y C(r)=r·2^r/2.
Con una multiplicación y dos sumas por mariposa se deducen los costos de NTT,
inversa y producto, y O(n log₂n) sobre esa familia. El recuento matriz–vector
da k·l productos y k+l transformadas compartidas. Se prueban la cota gruesa,
la optimizada O((k+l)n log n+kl n), su comparación y el caso n=256 fijo:
el costo optimizado del calendario está acotado por 6656kl. Esta constante
pertenece al modelo unitario de operaciones, no es una latencia ni un recuento
verificado de todas las instrucciones del backend.
El calendario optimizado presupone A disponible en dominio NTT; su obtención
y los costos de expansión, muestreo y hashes mantienen obligaciones separadas.

La ley geométrica de mathlib cuenta fallos antes del éxito. Para intentos n+1
se demuestran integrabilidad y E[N]=1/p, con p>0. La probabilidad de fallar los
primeros M intentos es (1−p)^M; si p<1 es positiva para todo límite finito y
tiende a cero al aumentar M. El costo constante por intento c produce esperanza c/p.
La barra uniforme p≥p0>0 implica E[N]=O(1) y conserva el orden del costo por intento.
Estas cotas se componen con NTT para obtener los modelos de firma esperado grueso,
optimizado y n fijo. El contraejemplo p_m=1/(m+1) tiene esperanza m+1 y no es O(1).
La composición cubre el costo por intento declarado; falta enlazar todos los
pasos del algoritmo ML-DSA y su distribución con ese calendario.

El bucle de máscaras real no se identifica con ese modelo IID. No se formalizan
el rollover del contador de 16 bits ni las estimaciones bibliográficas de intentos;
R1-D mantiene sus obligaciones. Tampoco se prueba aquí corrección algebraica
de una NTT concreta, primalidad/raíces de ML-DSA, muestreo o costo de bits.

## Trazabilidad y auditoría

Se añaden o amplían enlaces en **27 bloques**: el inventario pasa de 46 a **68**
y la revisión complementaria de 61 a **79 bloques parcialmente enlazados**.
Se conservan 272 candidatos, 14 suplementos y dos suplementos previamente enlazados.
M19, M20 y M22 quedan como modelos verificados; M21, M23 y M24 conservan las
correspondencias empíricas y de implementación pendientes. La matriz completa
tiene cinco modelos verificados, 17 grupos parciales, 18 pendientes, tres
dependencias bibliográficas, dos respaldos documentales y QROM AIR/FRI futuro.
Los grupos tienen tamaño desigual y no representan un porcentaje de esfuerzo.

Se mantienen intactas las **170 fuentes protegidas** de la auditoría anterior y
sus siete versiones actualizadas se conservan entre [quince copias previas](../Costos-Residencia-Antecedentes/README.md).
Los ocho archivos fuente del manuscrito, TG1 y el código Rust actual no cambian.
Se preservan los 1792 logs de las 28 etapas Lean previas.

```powershell
python scripts/verificar_formalizacion.py --salida .tools/lean/repeticion-costos-residencia
python scripts/verificar_revision_manuscrito.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_revision_manuscrito.py
```

Compilación y axiomas pasan sin advertencias. `leanchecker` recompueba los 120
módulos secuencialmente confiando en sus importados; no es `--fresh` ni una
revisión externa. Solo se admiten `propext`, `Classical.choice` y `Quot.sound`.
El informe fija **215 fuentes y 126 logs**. Los 13 controles del
analizador y de trazabilidad están en [controles.log](controles.log), fuera del
conjunto de logs del informe principal. La [revisión](revision-manuscrito.json) y
el [control final de integridad](integridad-costos-residencia.json) registran los
hashes de documentación, versiones y 1918 logs Lean de 29 etapas.
El dictamen independiente sigue pendiente; QROM continúa futuro y R1 conserva su alcance.
