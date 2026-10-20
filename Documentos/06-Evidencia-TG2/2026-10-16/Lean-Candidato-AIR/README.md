# Candidato previo a AIR, ronda crítica y enlace de composición

**Fecha:** 16 de octubre de 2026. Se registran 257 lemas y teoremas,
27 más que los 230 de la [etapa de historias adaptativas](../Lean-Historias-N06/README.md).
La formalización de N06 y de toda la matemática de la tesis sigue en curso.

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

| Módulo | Resultados añadidos |
|---|---|
| [N06/Candidato](../../../../formalizacion/Nexus/N06/Candidato.lean) | 6: selector parcial, cercanía, existencia condicional, unicidad y dependencia del dominio |
| [N06/Cancelacion](../../../../formalizacion/Nexus/N06/Cancelacion.lean) | 10: soporte de residuos, ronda crítica, escape equivalente a cancelación total y cota secuencial |
| [N06/SeleccionAIR](../../../../formalizacion/Nexus/N06/SeleccionAIR.lean) | 7: candidato del perfil, tres ramas de traza, residuos concretos y cota 1/p² |
| [N06/Composicion](../../../../formalizacion/Nexus/N06/Composicion.lean) | 4: escape iff resto nulo, transferencia fuera del escape y alternativa lejana/enlace |

El selector recibe el dominio, el oráculo, el grado y un radio racional.
No recibe coeficientes AIR, capas FRI ni consultas futuras. Devuelve `none`
exactamente cuando todos los polinomios del código están más lejos que el
radio, y `some f` solo si f tiene el grado y la cercanía exigidos. No se
presupone que todo oráculo tenga candidato. Con unicidad se identifica ese
mismo candidato; cambiar valores fuera del dominio no afecta la selección.
La selección es matemática y no se afirma que sea un algoritmo eficiente.

Para Goldilocks, k≤29 y δ≤1/8, la unicidad ya demostrada caracteriza al
candidato de grado <T. `ramaTraza` elige entre lejana, fuera del campo base
y base, antes de los coeficientes. Para un enunciado falso, su especificación
produce alejamiento en el primer caso, fracción no base >3/4 en el segundo
e invalidez AIR del candidato en el tercero.

Para n residuos fijados se construye j como el máximo de los índices
menores que n con residuo no nulo. Esa elección no recibe coeficientes.
El estado acumula las contribuciones anteriores. Solo la ronda j vigila
la ecuación x·R_j+s=0, que tiene a lo sumo una solución; las demás rondas
tienen conjunto excepcional vacío. El evento de escape es absorbente.

Se demuestra que alcanzar esa excepción equivale a que la combinación
total sea cero. Los residuos posteriores son cero, por lo que ningún
reto posterior revierte la cancelación ni crea otra excepción. El riesgo
secuencial coincide con el promedio exacto del indicador de cancelación
sobre los |K|^n vectores equiprobables. Su cota es 1/|K|, derivada de la
unión adaptativa con presupuesto uno en una única ronda.

La invalidez AIR Goldilocks proporciona un residuo no nulo entre los tres
residuos concretos. Su suma se identifica con el resto del numerador
combinado. Se obtiene la cota secuencial 1/p² y la misma cota para el
reto crítico después de cualquier suma anterior. Para el candidato base
de un enunciado falso se construye esa ronda con sus propiedades, sin
suponer de entrada que los residuos sean no todos nulos.

Fuera del escape crítico, el resto combinado no es cero y el candidato
seleccionado permite aplicar la transferencia de distancia de AIR. Para
cualquier composición v, su selector distingue:

| Caso | Conclusión |
|---|---|
| Sin candidato de grado <2T | v está a distancia >δc de todo el código |
| Con candidato próximo | distancia(v,c_u)≥max(0,(5T+1)/(8T)−3δt−δc) |

La cota vale uniformemente para v, que puede depender de la historia y los
coeficientes anteriores. No se exige independencia de esa elección.
Los resultados de transferencia se instancian para 4≤k≤29, incluyendo
todos los perfiles implementados 4≤k≤12, sin ampliar el ejecutable.

Queda pendiente reunir los estados AIR/FRI, sus escapes, las constantes
finales y la consulta compartida en un único espacio de transcripciones.
Los selectores ya fijan las ramas; falta mantener el invariante de la rama
activa y demostrar el máximo de sus cotas. También faltan instanciar los
controles locales de campo base y enlace sobre las parejas concretas y
componer sus probabilidades con los eventos de escape.
No se demuestra aquí epsilon_rbr=h_T ni E_ideal≤h_T+(8T−3)/p².
La equivalencia integral con Rust, Merkle y el selector hash en ROM sigue
pendiente. QROM AIR/FRI conserva su estado de trabajo futuro.

Se auditan 257 resultados y se recomprueban 41 módulos secuencialmente
mediante `leanchecker` de Lean 4.35.0, confiando en los módulos importados.
No se usa `--fresh` ni un verificador externo. Solo se permiten `propext`,
`Classical.choice` y `Quot.sound`. Pasan los cinco controles del analizador
de axiomas. Siete de las doce afirmaciones del catálogo tienen componentes
mecanizados; eso no declara cerradas esas siete afirmaciones.

El inventario conserva 272 candidatos en ocho fuentes, con 35 bloques de
correspondencia parcial revisada. El informe conserva hashes de 81 fuentes
y 47 logs. Los capítulos, TG1, Rust y las nueve etapas anteriores permanecen
intactos. El total de teoremas no es un porcentaje de cobertura del manuscrito.

Para repetir desde la raíz, conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
