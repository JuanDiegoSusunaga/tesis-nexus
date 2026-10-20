# Plegado de una capa FRI y muestreo de parejas en Lean

**Fecha:** 16 de octubre de 2026. Esta ejecución registra 148 lemas y teoremas,
22 más que los 126 de la [etapa anterior](../Lean-Candidato-Base/README.md).
La formalización completa de la tesis sigue en curso.

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

| Módulo | Resultados añadidos |
|---|---|
| [N04/RadioReal](../../../../formalizacion/Nexus/N04/RadioReal.lean) | 3: lema A para radios reales y márgenes de todas las capas con θ=1/8 |
| [N04/Plegado](../../../../formalizacion/Nexus/N04/Plegado.lean) | 4: grado y evaluación de la recomposición, recuperación de la pareja y paso de una capa |
| [N05/Cotas](../../../../formalizacion/Nexus/N05/Cotas.lean) | 8: comparación binomial, fórmula H con techo, caso cero, antitonicidad y cota exponencial |
| [N05/Parejas](../../../../formalizacion/Nexus/N05/Parejas.lean) | 4: discrepancias, número de parejas malas y cotas de omisión |
| [Modelos/Omision](../../../../formalizacion/Nexus/Modelos/Omision.lean) | 3: tabla 6.22, disponibilidad de 40 parejas y techo T/2 en los nueve perfiles |

Para la recuperación se requiere un dominio de puntos distintos L, una raíz
no nula r(y) con r(y)²=y para cada punto y, y 2≠0 en el campo. Se definen
las partes par e impar desde los dos valores u(r(y)),u(−r(y)). El lema A
garantiza, salvo a lo sumo |L| retos, dos polinomios A,B de grado <e
coincidentes con esas partes en el mismo conjunto S. Se recompone
P=A(X²)+XB(X²), de grado <2e, que coincide con ambas mitades de u en S.
La versión de radio real conserva el conjunto de acuerdo; no recibe la
recuperación como hipótesis ni cambia S para cada mitad.

Los márgenes se comprueban para n_j=2^(k+2−j), e_j=2^(k−j) en composición
(j≤k), y e_j=2^(k−1−j) en traza (j<k). Falta construir y enlazar todos
los cosets sucesivos y propagar los acuerdos desde la constante final.

Para las parejas, una enumeración por (i,false),(i,true) da
discrepancias≤2·parejas malas. Distancia ≥θ implica al menos ceil(θM)
parejas malas. El muestreo uniforme de q parejas distintas omite ese
conjunto con probabilidad acotada por H(M,q,θ). Se exige q≤M para
interpretar el cociente de cardinales como probabilidad uniforme.
Se prueban el caso H=0 cuando el numerador no tiene suficientes elementos,
su antitonicidad y H≤(1−θ)^q para M>0 y radio racional 0≤θ≤1.
La comparación binomial se demuestra por recurrencia, sin aproximación
asintótica ni suposición de independencia de las consultas.

Se comprueba que los nueve perfiles implementados admiten q=40 y
ceil((1/8)·4T)=T/2. Los cuatro valores refinados de la tabla 6.22
redondean hacia arriba H(4T,40,1/8)+(8T−3)/p² con error <10^-9.
Esto verifica la aritmética del límite propuesto, sin demostrar aún la
desigualdad probabilística del protocolo completo.

N06 conserva el modelo temporal, los estados y sus eventos pendientes.
Tampoco se verifica aquí la enumeración concreta de parejas del ejecutable,
las aperturas Merkle ni la distribución del selector hash. QROM se mantiene
como trabajo futuro. Se conservan los capítulos y la evidencia histórica.

Se auditan 148 resultados y se recomprueban 27 módulos secuencialmente
con `leanchecker` de Lean 4.35.0, confiando en sus importaciones. No se
usa `--fresh` ni un verificador externo. Solo se permiten `propext`,
`Classical.choice` y `Quot.sound`. Pasan los cinco controles del analizador
de la auditoría. El inventario mantiene 272 candidatos en ocho fuentes,
con 30 bloques de correspondencia parcial revisada; no es un porcentaje
de avance ni un inventario semántico cerrado.

Para repetir desde la raíz conservando otra ejecución:

```powershell
python scripts/lean.py preparar
python scripts/verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
