# Estado absorbente y solidez por rondas del modelo ideal

**Fecha:** 16 de octubre de 2026. Se registran 345 lemas y teoremas,
29 más que los 316 de la [etapa de solidez interactiva](../Lean-Solidez-Interactiva/README.md).
La formalización completa de la tesis sigue en curso.

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

| Módulo | Resultados añadidos |
|---|---|
| [N06/Estado](../../../../formalizacion/Nexus/N06/Estado.lean) | 8: marca booleana, absorción, recursión equivalente al escape y probabilidad de una transición nueva |
| [N06/Monitores](../../../../formalizacion/Nexus/N06/Monitores.lean) | 5: ronda crítica AIR y cotas condicionales AIR/FRI para cualquier estado e historia |
| [N06/EstadoConjunto](../../../../formalizacion/Nexus/N06/EstadoConjunto.lean) | 8: conservación entre fases, ramas activas, cancelación y estado cero iff prefijo seguro |
| [N06/PorRondas](../../../../formalizacion/Nexus/N06/PorRondas.lean) | 8: inicio, mensajes, rechazo, aceptación, consulta y certificado por rondas con h_T escogida |

`actualizarMarca b P` conserva una marca uno y la activa cuando ocurre P.
`recorrerMarca` aplica esa transición durante una fase con sus retos finitos;
se demuestra que equivale a la marca inicial o al evento `Escapa` de esa
fase. Un monitor vacío conserva la marca, y una marca uno no puede volver
a cero. `emitirMensaje` conserva la marca actual para cualquier contenido;
el mensaje sí puede determinar el oráculo y los monitores de retos posteriores.

`probabilidadCambio` es la media del indicador de que el estado anterior es
cero y el nuevo estado es uno. Si la marca ya es uno, esta probabilidad es
cero: permanecer en uno no se cuenta como una transición nueva. Para un
conjunto excepcional E fijado antes del reto uniforme fresco, la cota es
|E|/|K|. El conjunto puede depender de toda la historia anterior.

Los monitores concretos siguen las ramas del candidato de traza:

| Clase de reto | Monitor y cota condicional de cambio |
|---|---|
| AIR | Los residuos vigilados dependen solo de u y del enunciado; solo se vigila su última ronda no nula. Cota ≤1/p² |
| FRI de traza | Solo se activa si no hay candidato próximo de la traza inicial. Cota por plegado ≤4T/p² |
| FRI de composición | Solo se activa en la rama base cuando la composición está lejos de su código; se decide antes de sus retos. Cota por plegado ≤4T/p² |
| Consulta compartida | Desde el estado alcanzado, cota ≤H(4T,q,1/8); si la marca ya es uno no hay cambio nuevo |

Las cotas AIR/FRI valen para cualquier estado previo y cualquier historia,
sin una hipótesis de independencia entre eventos excepcionales. La composición
puede depender de todos los coeficientes AIR y de la historia completa del
FRI de traza. El orden causal sigue siendo AIR → FRI de traza → FRI de
composición → consulta compartida, con oráculos ideales y retos uniformes.

`marcaAIR`, `marcaTraza` y `marcaAntesConsulta` transportan la misma marca
entre fases. Para un enunciado sin traza base válida,
`estado_cero_iff_prefijo_seguro` demuestra literalmente la equivalencia entre
la marca alcanzada igual a cero y `PrefijoSeguro`. En la rama base, la marca
AIR cero equivale al resto combinado no nulo. En las ramas FRI activas se
obtiene exactamente la ausencia de sus excepciones; las inactivas conservan
la marca anterior.

La transición de consulta activa la marca si acepta `AceptaCompartida`, que
usa una sola muestra para ambos FRI, las seis posiciones base AIR y el enlace.
La equivalencia anterior permite aplicar su cota final a cada prefijo alcanzado
en cero. `estado_final_cero_rechaza` demuestra rechazo desde un estado final
cero; `aceptacion_activa_estado` demuestra que aceptar deja la marca en uno.

`CertificadoRondas` reúne las propiedades de las transiciones definidas:
estado inicial cero, conservación de la marca por mensajes de oráculo,
absorción, cotas de las tres clases de reto y de la consulta, y rechazo final.
`solidez_por_rondas` construye ese certificado para el perfil δt=δc=1/8,
4≤k≤29 y q≤4T, con la cota

```text
epsilon = max(1/p², 4T/p², H(4T,q,1/8)).
```

Una comparación racional exacta de los nueve perfiles 4≤k≤12 demuestra,
para q=40, que este máximo coincide con h_T=H(4T,40,1/8).
`solidez_por_rondas_perfiles` construye el certificado con esa misma h_T.
La igualdad identifica la cota escogida y no afirma que sea el error óptimo.
No se añaden los presupuestos telescópicos a una cota de una sola ronda.
La cota ordinaria de la etapa anterior sigue siendo
`H(4T,40,1/8)+(8T−3)/p²` y no se confunde con h_T.

El certificado se refiere al modelo causal ideal definido en estos módulos.
Permanecen su traducción formal a la definición bibliográfica de solidez por
rondas y la correspondencia integral con la transcripción exacta, los mensajes
y el verificador del protocolo de la tesis. También el corolario de intentos
y reinicios ideales adaptativos: no se identifica su número de intentos con
consultas SHA3. La semántica integral de Rust, la extracción/vinculación de
compromisos Merkle y la transferencia Fiat–Shamir en ROM siguen pendientes.
QROM AIR/FRI conserva su estado de trabajo futuro. La generalización a otros
radios o a perfiles fuera de los nueve comprobados no se deduce de la igualdad
numérica de esta etapa.

La validación compila el proyecto, audita los 345 resultados y recomprueba
53 módulos secuencialmente con `leanchecker` de Lean 4.35.0, confiando en
los módulos importados. No se usa `--fresh` ni un verificador externo.
Los únicos axiomas permitidos son `propext`, `Classical.choice` y
`Quot.sound`. Pasan los cinco controles del analizador de axiomas.

El informe conserva hashes de 93 fuentes y 59 logs. El inventario mantiene
272 candidatos en ocho fuentes y 35 bloques con correspondencia parcial
revisada. Se conservan los capítulos, TG1, Rust y las doce etapas anteriores;
84 fuentes protegidas y sus 408 logs anteriores se comprueban sin diferencias.
El total de resultados no constituye un porcentaje de la tesis ni declara
cerrada una afirmación criptográfica completa.

Para repetir desde la raíz, conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
