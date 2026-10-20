# Torres FRI concretas sobre Goldilocks

**Fecha:** 16 de octubre de 2026. Se registran 205 lemas y teoremas,
31 más que los 174 de la [etapa anterior](../Lean-Torre-FRI/README.md).
La formalización completa de la tesis sigue en curso.

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

| Módulo | Resultados añadidos |
|---|---|
| [FRI/Cosets](../../../../formalizacion/Nexus/FRI/Cosets.lean) | 20: raíces coherentes, cosets sucesivos, opuestos, índices únicos, representantes y enlace entre dominios |
| [FRI/Goldilocks](../../../../formalizacion/Nexus/FRI/Goldilocks.lean) | 8: torres de ambas fases, tamaños, grados, márgenes, presupuestos y muestreo |
| [FRI/Indices](../../../../formalizacion/Nexus/FRI/Indices.lean) | 3: posición modular, selección de la mitad y fórmula algebraica del plegado |

La capa j tiene desplazamiento 7^(2^j), raíz de orden 2^(k+3−j)
y ese número de puntos distintos. Se prueban la coherencia de las raíces
al cuadrar, la no anulación de cada punto y la identidad del opuesto
en el índice de media vuelta. El índice de cada punto de la capa
siguiente es único. Se elige de él el representante en la primera mitad
de la capa anterior y se demuestra la igualdad de dominios requerida
por `Torre`; estas relaciones no se reciben como hipótesis.

Se construye `torreGoldilocks k m` para k≤29 y m≤k+1. Las fases de
traza y composición toman m=k y m=k+1, respectivamente. Ambas empiezan
en el dominio `cosetExtension(k+3)` utilizado por AIR y N03, con N=8T.
Sus grados iniciales son T y 2T; los dominios finales tienen ocho y
cuatro puntos. Los márgenes del lema A se verifican para θ=1/8 en todas
las capas. Las sumas de cardinales excepcionales son ≤8T−8 y ≤8T−4;
son cuentas deterministas, no una cota probabilística adaptativa.

Para 4≤k≤29, q=40 y cualquiera de esas fases, el teorema
`muestreo_torre_goldilocks` aplica el lema B y el muestreo completo:
si el oráculo inicial está a distancia >1/8 de su código, los retos
evitan las excepciones y las parejas de G pasan todo el recorrido y
su constante final, la probabilidad de una muestra uniforme de cuarenta
parejas distintas contenida en G es ≤H(4T,40,1/8) y ≤(7/8)^40.
El rango incluye los nueve perfiles implementados 4≤k≤12, sin ampliar
los tamaños admitidos por el ejecutable.

Se prueban a=pos mod (n/2), la selección de la mitad correcta y la
fórmula `(left+right)/2 + beta*((left−right)/2)*x⁻¹` para los índices
a,a+n/2. La identidad corresponde algebraicamente a `fold` de la
[fuente histórica fri.rs](../../2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/fri.rs),
cuyo hash se incorpora al informe junto con el de `field.rs`.
No se verifica todavía la semántica integral de Rust, incluidos los
enteros de máquina, bucles, formatos y aperturas Merkle.

La familia u de oráculos sigue fija. N06 conserva la elección temporal
de cada oráculo antes del reto, las historias adaptativas y sus
probabilidades condicionales, y la composición con AIR. También quedan
el modelo ROM del selector hash y la equivalencia completa de `Acepta`
con el verificador. No se afirma solidez global de NEXUS; QROM continúa
como trabajo futuro.

Se auditan 205 resultados y se recomprueban 34 módulos secuencialmente
con `leanchecker` de Lean 4.35.0, confiando en sus importaciones. No se
usa `--fresh` ni un verificador externo. Solo se permiten `propext`,
`Classical.choice` y `Quot.sound`. Pasan los cinco controles del
analizador de axiomas. El inventario mantiene 272 candidatos en ocho
fuentes, con 34 bloques de correspondencia parcial revisada. Los capítulos,
Rust y la evidencia de las siete etapas previas permanecen intactos.

Para repetir desde la raíz conservando otra ejecución:

```powershell
python scripts/lean.py preparar
python scripts/verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
