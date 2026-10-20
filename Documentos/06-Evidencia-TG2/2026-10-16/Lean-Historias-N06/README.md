# Historias adaptativas y excepciones FRI de N06

**Fecha:** 16 de octubre de 2026. Se registran 230 lemas y teoremas,
25 más que los 205 de la [etapa de cosets](../Lean-Cosets-FRI/README.md).
N06 incorpora componentes mecanizados; la tesis completa sigue en curso.

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

| Módulo | Resultados añadidos |
|---|---|
| [N06/Experimento](../../../../formalizacion/Nexus/N06/Experimento.lean) | 12: medias exactas, espacio de retos, escape absorbente, conteo de transcripciones y unión adaptativa |
| [FRI/Adaptativo](../../../../formalizacion/Nexus/FRI/Adaptativo.lean) | 9: controles del oráculo actual, prefijos, recuperación, lema B, muestreo y probabilidad de excepciones por fase |
| [N06/Goldilocks](../../../../formalizacion/Nexus/N06/Goldilocks.lean) | 4: probabilidad por capa, cotas de excepciones de ambas fases y consulta condicionada de cuarenta parejas |

El experimento usa retos uniformes frescos de un tipo finito no vacío K.
El estado S puede contener toda la historia, sin restricción de cardinal.
El conjunto excepcional E(i,s) se determina antes del reto actual; la
transición puede depender de ese reto y de todo el estado. El valor es uno
desde la primera excepción, por lo que el escape es absorbente.

Se demuestra que la recursión de medias condicionales coincide con el
promedio sobre los |K|^n vectores equiprobables. Con valor terminal cero,
es exactamente el número de vectores que alcanzan una excepción dividido
por |K|^n. Si el valor terminal es ≤h, h≥0, y cada conjunto excepcional
tiene cardinal ≤B_i, el riesgo es ≤h+sum(B_i)/|K|. Los eventos pueden
depender de la historia; no se supone que sean independientes.

Para FRI se elige el conjunto excepcional por el lema A a partir del
oráculo actual, sin recibir el reto ni los oráculos futuros. Se prueba
que `Control` solo depende de ese oráculo. Una estrategia recibe la capa
y el prefijo de retos anteriores; la historia anterior al reto j depende
solo de los índices menores que j. Los controles así obtenidos permiten
remontar el acuerdo desde la constante final. Se derivan el lema B y la
cota H del muestreo para cada historia que evita las excepciones.

La unión adaptativa y la suma telescópica dan una probabilidad de alcanzar
alguna excepción ≤(|L_0|−|L_m|)/|K|. En las torres Goldilocks, para T=2^k,
k≤29 y θ=1/8, las cotas son:

| Fase o ronda | Cota de probabilidad excepcional |
|---|---|
| Una capa, dado cualquier prefijo | 4T/p² |
| Traza, m=k | (8T−8)/p² |
| Composición, m=k+1 | (8T−4)/p² |

Las dos fases se acotan por separado. No se multiplican sus probabilidades.
Para 4≤k≤29, q=40 y cualquiera de las torres, una historia sin excepciones,
un oráculo inicial lejano y un conjunto de parejas G que pasa el recorrido
completo y la constante final implican una probabilidad uniforme de cuarenta
parejas distintas contenidas en G ≤H(4T,40,1/8) y ≤(7/8)^40. El rango incluye
todos los perfiles implementados 4≤k≤12; no amplía el ejecutable.

Queda pendiente reunir el evento de escape y el muestreo en un único
espacio de transcripciones del IOP. También faltan la selección temporal
del candidato antes de AIR, los casos sin candidato/base/no base, la ronda
crítica de cancelación, el invariante de la rama activa y la única consulta
compartida. Esta etapa no demuestra epsilon_rbr=h_T ni la cota conjunta
h_T+(8T−3)/p². La equivalencia integral con Rust, Merkle y el selector hash
en ROM sigue pendiente; QROM AIR/FRI permanece como trabajo futuro.

Se auditan 230 resultados de siete de las doce afirmaciones con componentes
mecanizados, sin declarar cerradas esas afirmaciones. Se recomprueban 37
módulos secuencialmente mediante `leanchecker` de Lean 4.35.0, confiando en
los módulos importados. No se usa `--fresh` ni un verificador externo.
Los axiomas permitidos son `propext`, `Classical.choice` y `Quot.sound`;
no se admiten `sorryAx`, axiomas propios ni evaluación nativa como prueba.
Pasan los cinco controles del analizador de axiomas.

El inventario mantiene 272 candidatos en ocho fuentes, con 34 bloques de
correspondencia parcial revisada. Los capítulos, TG1, Rust y las ocho etapas
anteriores permanecen intactos. El informe registra hashes de 77 fuentes y
43 logs. Se actualizan los enlaces de alcance y la bitácora; el total de
teoremas no se interpreta como porcentaje de cobertura del manuscrito.

Para repetir desde la raíz, conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
