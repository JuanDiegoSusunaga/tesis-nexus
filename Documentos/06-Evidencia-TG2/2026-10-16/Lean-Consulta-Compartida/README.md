# Una consulta compartida sobre las parejas Goldilocks

**Fecha:** 16 de octubre de 2026. Se registran 292 lemas y teoremas,
35 más que los 257 de la [etapa de candidato y AIR](../Lean-Candidato-AIR/README.md).
La formalización completa de la tesis y de N06 sigue en curso.

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

| Módulo | Resultados añadidos |
|---|---|
| [N06/Consulta](../../../../formalizacion/Nexus/N06/Consulta.lean) | 12: probabilidad de la muestra, predicados de parejas, fallos puntuales y cota H |
| [FRI/Consulta](../../../../formalizacion/Nexus/FRI/Consulta.lean) | 8: imágenes de recorridos, aceptación individual, unión de parejas aceptantes y muestreo de la muestra aceptada |
| [N06/Parejas](../../../../formalizacion/Nexus/N06/Parejas.lean) | 5: fallos base/enlace y sus cotas sobre las parejas concretas Goldilocks |
| [N06/Compartida](../../../../formalizacion/Nexus/N06/Compartida.lean) | 10: radios, máximo de casos, consulta compartida para prefijos seguros, promedios, ponderaciones y cuarenta parejas |

Se define la probabilidad exacta de un predicado sobre una muestra uniforme
de q parejas distintas. El espacio son los q-subconjuntos del dominio de
parejas; q≤M garantiza que no esté vacío. El predicado y los oráculos quedan
fijados antes de sortear la muestra.

Para cualquier predicado puntual P se construyen las parejas buenas,
aquellas en que P vale en r(y) y −r(y). Cada pareja mala contiene como
máximo dos puntos que fallan. Las relaciones geométricas ya demostradas
identifican el coset original con ambas mitades, sin repeticiones. La
fracción de fallos puntuales implica así la cota hipergeométrica H para
la muestra de parejas; no se recibe su número de parejas malas como premisa.

Se instancian estos predicados en los controles de campo base y de igualdad
v(x)=c_u(x). La fracción de fallos base es exactamente `fraccionFueraBase`;
la de enlace es la distancia Hamming. Las cotas del candidato no base y
del enlace de composición se aplican a las parejas concretas r(y),−r(y).

En FRI, el recorrido de A tras j capas es su imagen por x↦x^(2^j).
Se demuestra que aceptar la muestra equivale a aceptar cada pareja por
separado a lo largo de todas las capas y la constante final. Se construye
el conjunto de todas esas parejas aceptantes y se prueba que su unión
acepta. El lema B y el muestreo adaptativo acotan entonces directamente
la probabilidad del predicado FRI de la muestra. El conjunto G no se
recibe como dato aceptante ni se supone su cardinal.

`PrefijoConsulta` fija los coeficientes AIR, ambas estrategias FRI, sus
retos y constantes finales. `AceptaCompartida` usa una única muestra S
para estos controles:

| Control | Posiciones o recorrido |
|---|---|
| FRI de traza | Todas sus capas y constante final |
| FRI de composición | Todas sus capas y constante final |
| Campo base AIR | x,gx,g²x para cada una de las dos mitades |
| Enlace de composición | v(x)=c_u(x) en las dos mitades |

`PrefijoSeguro` excluye solo los eventos de la rama activa:

| Rama | Condición requerida antes de la consulta |
|---|---|
| Traza lejana | Sin excepciones del FRI de traza |
| Candidato no base | Ninguna excepción FRI adicional |
| Candidato base y composición lejana | Resto AIR no nulo y sin excepciones del FRI de composición |
| Candidato base y composición próxima | Resto AIR no nulo |

Para δt=δc=1/8, 4≤k≤29, T=2^k y q≤4T, se demuestra
`probabilidadConsulta ≤ H(4T,q,1/8)` para todo prefijo seguro. Los radios
de enlace y campo base son al menos 1/8. La antitonicidad de H demuestra
que el máximo de los cuatro casos es esa misma cota. La prueba usa la
proyección al control necesario de la rama; no multiplica probabilidades
de los dos FRI ni exige independencia entre sus verificaciones.

La cota se conserva bajo el promedio uniforme de prefijos seguros y bajo
cualquier distribución finita de pesos racionales no negativos, normalizados
y soportados en prefijos seguros. Para q=40 se obtienen h_T=H(4T,40,1/8)
y (7/8)^40. El rango incluye los nueve perfiles implementados 4≤k≤12;
no amplía el ejecutable.

Queda pendiente construir la ejecución causal conjunta que genera el
prefijo a partir del enunciado y la traza fijados antes de AIR. Hay que
mantener el invariante de la rama activa y acotar la probabilidad de no
satisfacer `PrefijoSeguro` usando los monitores AIR/FRI ya demostrados.
Una distribución condicionada a prefijos seguros no resuelve ese paso.
Después debe combinarse su complemento con la consulta en el mismo
experimento. No se demuestra aquí epsilon_rbr=h_T para todas las rondas
ni E_ideal≤h_T+(8T−3)/p². El teorema compartido cubre el perfil 1/8;
su extensión a radios generales también queda pendiente.

La equivalencia integral con Rust, las aperturas Merkle y el selector hash
en ROM permanecen separadas. QROM AIR/FRI conserva su estado de trabajo futuro.

Se auditan 292 resultados y se recomprueban 45 módulos secuencialmente con
`leanchecker` de Lean 4.35.0, confiando en los módulos importados. No se usa
`--fresh` ni un verificador externo. Solo se permiten `propext`,
`Classical.choice` y `Quot.sound`. Pasan los cinco controles del analizador
de axiomas. Siete de las doce afirmaciones tienen componentes mecanizados;
eso no declara cerradas esas afirmaciones.

El informe conserva hashes de 85 fuentes y 51 logs. El inventario mantiene
272 candidatos en ocho fuentes y 35 bloques parcialmente revisados.
Los capítulos, TG1, Rust y las diez etapas anteriores permanecen intactos.
El total de resultados no se interpreta como porcentaje del manuscrito.

Para repetir desde la raíz, conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
