# Propagación FRI por todas las capas de una torre finita

**Fecha:** 16 de octubre de 2026. Se registran 174 lemas y teoremas,
26 más que los 148 de la [etapa anterior](../Lean-Plegado-Muestreo/README.md).
La formalización completa de la tesis sigue en curso.

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

| Módulo | Resultados añadidos |
|---|---|
| [FRI/Dominios](../../../../formalizacion/Nexus/FRI/Dominios.lean) | 10: raíces opuestas, independencia del representante, mitades disjuntas, cardinal doble y conservación de densidad |
| [FRI/Torre](../../../../formalizacion/Nexus/FRI/Torre.lean) | 9: recorridos, controles de capa, recuperación desde la constante final y lema B |
| [FRI/Muestreo](../../../../formalizacion/Nexus/FRI/Muestreo.lean) | 2: omisión hipergeométrica y exponencial para el recorrido completo |
| [FRI/Presupuesto](../../../../formalizacion/Nexus/FRI/Presupuesto.lean) | 5: grados y cardinales por capa, razón dominio/grado y suma telescópica de excepciones |

`Torre K m` representa m plegados sobre un campo con 2≠0. Los datos
deben satisfacer L_j=elevar(r_j,L_(j+1)), r_j(y)²=y, r_j(y)≠0 y
d_j=2*d_(j+1); el código final es de constantes y el dominio final
no es vacío. No se recibe como hipótesis la proximidad inicial ni el
lema B. La construcción de estos datos para todos los cosets concretos
de Goldilocks sigue pendiente.

Se demuestra que cambiar el signo del representante no cambia las partes
par e impar, que cada pareja tiene dos puntos distintos y que un cuadrado
agrupa como máximo dos puntos. Para W_0=A y W_(j+1)=cuadrados(W_j),
la densidad no disminuye. Por ello, un conjunto inicial con densidad al menos 1−θ da
conjuntos suficientemente grandes para aplicar el lema A en cada capa,
bajo sus márgenes explícitos.

Se construye un conjunto excepcional por capa a partir del lema A.
Si los retos lo evitan, todos los recorridos de A pasan las ecuaciones
y la constante final coincide en su último conjunto, se recupera por
inducción hacia atrás un polinomio del código inicial que coincide en A.
Si el oráculo está a distancia >θ de todo ese código, `lema_B` deduce
que la densidad de recorridos aceptantes es como máximo 1−θ.

Para parejas iniciales completas A=elevar(r_0,G), `lema_B_muestreo`
deriva la cota H(M,q,θ), y `lema_B_exponencial` la cota (1−θ)^q.
Se usa un radio racional para el muestreo, convertido a real al aplicar
la propagación. Se requiere q≤M para interpretar el cociente como
probabilidad de una muestra uniforme distinta. El cardinal aceptante
no se postula: se deduce de las ecuaciones del recorrido y el alejamiento.

Se prueba d_j=2^(m−j), |L_0|=2^j*|L_j| y que el cociente dominio/grado
se conserva hasta constantes. La suma de los dominios de reto es
|L_0|−|L_m|; la suma de cardinales excepcionales queda por debajo.
Esta identidad es determinista y no acredita por sí sola una probabilidad
de excepciones en una historia adaptativa.

Los oráculos u forman una familia fija. N06 conserva la fijación de cada
oráculo antes del reto, las probabilidades condicionales y la composición
de ambas fases con AIR. También quedan la instanciación de la torre
Goldilocks, la equivalencia de `Acepta` con Rust, Merkle y el selector
hash. No se afirma solidez completa de NEXUS ni transferencia ROM/QROM.
QROM continúa como trabajo futuro.

Se auditan 174 resultados y se recomprueban 31 módulos secuencialmente
con `leanchecker` de Lean 4.35.0, confiando en sus importaciones. No se
usa `--fresh` ni un verificador externo. Los axiomas permitidos son
`propext`, `Classical.choice` y `Quot.sound`. Pasan los cinco controles
del analizador de axiomas. El inventario mantiene 272 candidatos en ocho
fuentes, con 33 bloques de correspondencia parcial revisada. Los capítulos
y la evidencia de las seis etapas anteriores permanecen intactos.

Para repetir desde la raíz conservando otra ejecución:

```powershell
python scripts/lean.py preparar
python scripts/verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
