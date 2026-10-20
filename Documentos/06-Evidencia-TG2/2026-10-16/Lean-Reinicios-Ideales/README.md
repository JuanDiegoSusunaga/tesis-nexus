# Reinicios ideales adaptativos y primera transición excepcional

**Fecha:** 16 de octubre de 2026. Se registran 366 lemas y teoremas,
21 más que los 345 de la [etapa de solidez por rondas](../Lean-Solidez-Rondas/README.md).
La formalización completa de la tesis sigue en curso.

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

| Módulo | Resultados añadidos |
|---|---|
| [N06/Reinicios](../../../../formalizacion/Nexus/N06/Reinicios.lean) | 7: árboles adaptativos con estados guardados, conservación de marcas y cota min(1,B·epsilon) |
| [N06/PrimerCambio](../../../../formalizacion/Nexus/N06/PrimerCambio.lean) | 5: primera transición, aceptación de un registro y promedio de planes con semilla finita uniforme |
| [N06/Muestras](../../../../formalizacion/Nexus/N06/Muestras.lean) | 3: medias entre instancias finitas, muestra no vacía y media uniforme igual a probabilidadConsulta |
| [N06/ReiniciosIdeal](../../../../formalizacion/Nexus/N06/ReiniciosIdeal.lean) | 6: respuestas ideales AIR/FRI/consulta, enlace con el certificado y corolario min(1,B·h_T) |

`PlanRestaurable` es un árbol dependiente de la lista de estados guardados y
del presupuesto restante de retos nuevos. Cada respuesta puede determinar
toda la continuación. El tipo de respuesta también puede cambiar con la
petición: por ejemplo, un elemento de campo o una muestra de parejas.

| Operación | Condición y efecto | Presupuesto de retos |
|---|---|---|
| Terminar | Se inspecciona el registro de estados obtenidos | Puede sobrar presupuesto |
| Mensaje | Parte de un nodo guardado y añade otro con la misma marca | No consume |
| Reto fresco | Su origen debe estar guardado; añade el destino de la respuesta | Consume uno |
| Restaurar/reutilizar | Se elige un nodo anterior como origen o se reutiliza un destino ya guardado | No requiere sorteo nuevo |

El registro conserva todos los estados obtenidos. Restaurar una rama en
cero no borra una transición excepcional ya alcanzada en otra rama. Los
mensajes pueden cambiar los demás datos conservando la marca. El modelo
permite cualquier mensaje con esa propiedad; su adaptador al protocolo
concreto permanece como obligación separada.

`valorRestaurable` define la probabilidad por medias uniformes condicionales
en cada petición. Como el tipo y su cardinal pueden variar, las hojas no
se declaran equiprobables. Se prueban monotonía, conservación de constantes,
riesgo entre cero y uno y persistencia de una marca en el registro.

`cambioFresco` cuenta la transición nueva en que el origen está en cero y
el destino queda en uno. Si su media es ≤epsilon para cada petición, el
riesgo desde un registro inicial sin marcas satisface

```text
riesgoRestaurable ≤ min(1, B·epsilon).
```

La inducción permite que todas las decisiones se adapten a las respuestas
anteriores. No se supone independencia de los eventos excepcionales. B es
un límite superior de nuevos sorteos; el plan puede terminar antes.

`probabilidadPrimerCambio` vale uno desde la primera transición nueva y
promedia las continuaciones mientras no ocurra. Desde un registro inicial
en cero se demuestra su igualdad con el riesgo de terminar con alguna marca
guardada. Toda aceptación guardada que implique una marca queda acotada por
ese mismo riesgo. La cota también se conserva al promediar planes con una
semilla finita uniforme, elegida antes de los retos.

En esta primera instanciación, la política de oráculos se fija para todo
el árbol, mientras el plan de peticiones sí se adapta a las respuestas.
Para NEXUS se definen nodos y peticiones de AIR, FRI de traza, FRI de
composición y consulta final. Los nodos guardan los datos de estado utilizados
por sus monitores, las historias y las muestras/salidas. Las peticiones de
campo tienen respuestas en Fp2. La consulta responde con un elemento del
subtipo de q-subconjuntos del dominio de parejas. Se prueba que el subtipo
no es vacío para q≤M y que su promedio uniforme coincide exactamente con
`probabilidadConsulta`. El cambio entre instancias de `Fintype` conserva la
media, de modo que la representación de las respuestas no cambia la distribución.

`cambio_ideal_certificado` obtiene cada cota condicional de `CertificadoRondas`.
`acepta_nodo_marcado` deriva que una salida aceptada tiene marca uno.
`reinicios_desde_certificado` aplica la cota abstracta desde una raíz en cero,
y `reinicios_ideales_cota` la instancia con el certificado AIR/FRI para un
enunciado falso, 4≤k≤29 y q≤4T:

```text
probabilidadReinicios ≤ min(1, B·errorRonda(k,q)).
```

Para los nueve perfiles 4≤k≤12 y q=40,
`reinicios_ideales_perfiles` demuestra

```text
probabilidadReinicios ≤ min(1, B·H(4T,40,1/8)).
```

La conclusión no se introduce como premisa. Se deriva del certificado ya
demostrado, del registro de orígenes guardados y de la implicación de la
aceptación a la primera transición excepcional. Una respuesta reutilizada
es un nodo ya obtenido; no se sortea otra vez ni se cobra otro intento.
Solicitar explícitamente una respuesta fresca sí consume presupuesto,
incluso si se parte otra vez de un mismo estado.

Este es un juego ideal con restauraciones y mensajes que conservan la marca.
Permitir elegir políticas de oráculos distintas entre ramas requiere
transportar la política en los nodos y peticiones; esta etapa conserva una
política fija como parámetro.
No se demuestra todavía su traducción formal a la definición bibliográfica
ni su correspondencia integral con la transcripción tipada y el ejecutable.
B cuenta sorteos ideales nuevos y no se identifica con llamadas SHA3.
La extracción/vinculación de compromisos Merkle, el sesgo modular, el selector
de parejas y la compilación Fiat–Shamir en ROM siguen pendientes. QROM
AIR/FRI conserva su estado de trabajo futuro. El resultado no acredita una
tasa de ataque observada ni una garantía del ejecutable.

La validación compila el proyecto, audita los 366 resultados y recomprueba
57 módulos secuencialmente con `leanchecker` de Lean 4.35.0, confiando en
los módulos importados. No se usa `--fresh` ni un verificador externo.
Solo se permiten `propext`, `Classical.choice` y `Quot.sound`. Pasan los
cinco controles del analizador de axiomas.

El informe conserva hashes de 97 fuentes y 63 logs. El inventario mantiene
272 candidatos en ocho fuentes y 35 bloques con correspondencia parcial
revisada. Se conservan los capítulos, TG1, Rust y las trece etapas anteriores:
88 fuentes protegidas y 467 logs históricos se comprueban sin diferencias.
El número de resultados no es un porcentaje de la tesis y no declara cerrada
una afirmación criptográfica completa.

Para repetir desde la raíz, conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
