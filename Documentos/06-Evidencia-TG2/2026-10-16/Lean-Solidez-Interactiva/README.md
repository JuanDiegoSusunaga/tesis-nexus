# Ejecución causal y solidez interactiva conjunta

**Fecha:** 16 de octubre de 2026. Se registran 316 lemas y teoremas,
24 más que los 292 de la [etapa de consulta compartida](../Lean-Consulta-Compartida/README.md).
La formalización completa de la tesis sigue en curso.

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

| Módulo | Resultados añadidos |
|---|---|
| [N06/Transcripcion](../../../../formalizacion/Nexus/N06/Transcripcion.lean) | 6: retos finitos, historias, ausencia de escape y cota de un valor terminal fuera de excepciones |
| [FRI/Experimento](../../../../formalizacion/Nexus/FRI/Experimento.lean) | 4: prefijos inseguros, cuenta telescópica terminal y aceptación promediada sobre retos y consulta |
| [N06/Ejecucion](../../../../formalizacion/Nexus/N06/Ejecucion.lean) | 5: oráculo inicial previo a AIR, coeficientes y cotas terminales concretas AIR/FRI |
| [N06/Solidez](../../../../formalizacion/Nexus/N06/Solidez.lean) | 9: invariantes de ramas, cota terminal conjunta, prefijos inseguros, aceptación interactiva, cuarenta parejas y enlace con la tabla 6.22 |

`reto` convierte un elemento de `Retos K n` en la función de retos naturales
usada por FRI. Sus primeras n coordenadas son los retos sorteados y las demás
se prolongan por cero. La prolongación no interviene en las n rondas.
`no_escape_historia` demuestra que no escapar equivale a evitar cada conjunto
excepcional calculado con la lista de retos anteriores. La probabilidad
recursiva de excepciones coincide así con el promedio exacto del indicador
de prefijos inseguros. Las transcripciones tienen cardinal |K|^n.

Para cualquier función terminal f de la transcripción, si f≤1 en general y
f≤h fuera del escape, con h≥0, se obtiene la cota h+sum(B_i)/|K|. No se exige
una cota terminal h sobre estados que ya escaparon. Esto permite combinar
la probabilidad de las excepciones con la consulta en un mismo experimento.
La especialización FRI conserva el presupuesto telescópico
(|L_0|−|L_m|)/|K| y permite elegir la constante final según toda su historia.

`PoliticaConsulta` fija el oráculo inicial u antes de los coeficientes AIR.
La ejecución demostrada tiene este orden:

1. Tres coeficientes AIR uniformes frescos.
2. FRI de traza con k retos: cada capa recibe los coeficientes anteriores y
   su propio prefijo; la capa cero sigue siendo u.
3. FRI de composición con k+1 retos: cada capa puede recibir los coeficientes,
   la historia completa de traza y su propio prefijo.
4. Una sola muestra uniforme de q parejas distintas, sin reemplazo, después
   de las dos constantes finales.

La constante de traza recibe toda su fase; la de composición recibe ambas
historias. Ninguna recibe la muestra futura. `ejecutarPrefijo` construye el
objeto que utiliza `AceptaCompartida`. `probabilidadConjunta` es la media
anidada exacta de las monedas AIR, FRI de traza, FRI de composición y la
aceptación de esa muestra compartida. Las políticas son arbitrarias dentro
de las dependencias causales descritas.

Para un enunciado sin traza base válida, el selector del oráculo inicial
fija la rama antes de AIR. El presupuesto pagado depende de esa rama:

| Rama inicial | Presupuesto excepcional |
|---|---|
| Sin candidato próximo | (8T−8)/p² por FRI de traza |
| Candidato no base | Cero |
| Candidato base | 1/p² por cancelación AIR y como máximo (8T−4)/p² por FRI de composición |

La composición próxima puede evitar además el coste de FRI de composición;
usar la cota de toda esa fase sigue siendo válido. Se demuestra para toda
la ejecución, sin condicionar a prefijos seguros:

```text
Pr[no PrefijoSeguro] ≤ (8T−3)/p².
```

La cota terminal conjunta aplicada al predicado de consulta ya demostrado
da, con δt=δc=1/8, T=2^k, 4≤k≤29 y q≤4T:

```text
probabilidadConjunta ≤ H(4T,q,1/8) + (8T−3)/p².
```

`solidez_interactiva_compartida` demuestra esa desigualdad; no recibe como
premisa ni su conclusión ni una distribución soportada en prefijos seguros.
Se usa la misma muestra en ambos FRI, los controles base AIR y el enlace.
No se multiplican las probabilidades de aceptación de los dos FRI.

Para q=40 se obtiene también `(7/8)^40+(8T−3)/p²`.
`solidez_interactiva_limite_tabla` identifica el lado derecho con
`Modelos.Omision.limiteIdeal (2^k)`, y `solidez_interactiva_tabla6_22` aplica
los cuatro superiores decimales ya verificados, bajo la igualdad del perfil.
Así se enlaza la desigualdad probabilística del modelo ideal con la tabla;
los cálculos anteriores solo verificaban su lado derecho.

El resultado es una cota ordinaria terminal de un experimento interactivo
con oráculos ideales. Permanecen la función de estado y la obligación
condicional de cada ronda necesarias para afirmar epsilon_rbr=h_T escogida.
También debe revisarse la correspondencia integral del orden y los mensajes
de esta política con la transcripción exacta de la tesis y con el ejecutable.
La generalización a otros radios, los compromisos y aperturas Merkle y el
selector hash/Fiat–Shamir en ROM siguen pendientes. QROM AIR/FRI permanece
como trabajo futuro. El rango matemático k≤29 no amplía los nueve perfiles
4≤k≤12 admitidos por TG2 v1.

La validación compila el proyecto, audita los 316 resultados y recomprueba
49 módulos secuencialmente con `leanchecker` de Lean 4.35.0, confiando en
los módulos importados. No se usa `--fresh` ni un verificador externo.
Los únicos axiomas permitidos son `propext`, `Classical.choice` y
`Quot.sound`. Los cinco controles del analizador de axiomas también pasan.

El informe conserva hashes de 89 fuentes y 55 logs. El inventario mantiene
272 candidatos en ocho fuentes y 35 bloques con correspondencia parcial
revisada; el número de resultados no es un porcentaje del manuscrito.
Los capítulos, TG1, Rust y las once etapas anteriores se conservan.
No se declara cerrada ninguna afirmación criptográfica completa.

Para repetir desde la raíz, conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
