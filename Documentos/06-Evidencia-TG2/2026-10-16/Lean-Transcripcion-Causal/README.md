# Transcripción causal con prefijos y mensajes tipados

**Fecha:** 16 de octubre de 2026. Se añaden 22 resultados y se alcanzan
393 lemas y teoremas registrados, frente a los 371 de la
[etapa anterior](../Lean-Reinicios-Adaptativos/README.md).

- [Validación, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).
- [Prefijos: seis resultados](../../../../formalizacion/Nexus/N06/Prefijos.lean).
- [Transcripción: ocho resultados](../../../../formalizacion/Nexus/N06/TranscripcionCausal.lean).
- [Solidez y plan restaurable: ocho resultados](../../../../formalizacion/Nexus/N06/SolidezCausal.lean).

El juego anterior permite añadir cualquier nodo que conserve la marca del
origen. Esta etapa construye una expansión de la ejecución de una política
causal con reglas de mensajes y prefijos cuyas marcas se calculan desde sus
retos. El juego de políticas adaptativas por nodo se conserva con su alcance;
la política permanece fija en la expansión tipada de esta etapa.

`TranscripcionCausal` distingue transcripción vacía, coeficientes AIR, FRI de
traza, FRI de composición, consulta y salida. El índice finito de cada fase
limita su longitud, y sus retos tienen precisamente esa longitud. En las
fases FRI se distingue si ya se fijó el oráculo previo al reto. El tipo de
la muestra final exige q parejas distintas del dominio prescrito.

`anexarReto` añade una moneda al final. Se demuestra su correspondencia
con la historia usada por FRI, y que recorrer el nuevo prefijo equivale a
actualizar el acumulador y la marca anteriores una sola vez. `nodoCausal`
reconstruye esos datos, sin aceptar un campo de marca declarado por el
probador. `nodo_causal_origen` y `nodo_causal_destino` prueban que cada
petición tipada reproduce las transiciones concretas del certificado.

`estadoCausal` vale uno para todo prefijo de un enunciado que admita una
traza base válida de grado menor que T. En particular, el estado de la
transcripción vacía es uno si y solo si el enunciado es válido. Para un
enunciado falso se usa la marca reconstruida. Los pasos sin monedas
conservan el estado, cada reto mantiene un estado uno y el estado final
cero implica rechazo de `AceptaCompartida`.

`PasoSinReto` describe el oráculo inicial, el cambio de fase AIR/FRI, los
oráculos intermedios y las constantes finales. `contenidoPaso` obtiene sus
mensajes de la política usando solo las monedas de fases anteriores y el
prefijo de su fase. La constante de traza y el oráculo inicial de composición
se emiten juntos; la constante de composición precede a la muestra.
Las aperturas ideales evalúan los oráculos fijados por la política.

| Resultado | Propiedad |
|---|---|
| `cambio_causal_certificado` | Transporta la cota local del certificado a los prefijos tipados; el caso de enunciado válido tiene cambio cero |
| `cambio_causal_cota` | Instancia la cota `errorRonda(k,q)` para un enunciado falso |
| `reto_causal_absorbente` | Un estado uno permanece en uno después de cualquier respuesta |
| `acepta_causal_marcada` | Toda salida aceptada tiene estado uno |
| `plan_causal_cota` | Cota `min(1,B·errorRonda(k,q))` para el plan tipado desde la transcripción vacía |
| `plan_causal_perfiles` | Cota `min(1,B·h_T)` en los nueve perfiles y q=40 |

`PlanCausal` permite restaurar prefijos guardados. Cada paso de mensajes
debe pertenecer a `PasoSinReto`; cada reto nuevo debe tener su origen en
el registro y añade el destino calculado desde su respuesta. Las
continuaciones pueden depender de las respuestas anteriores. La expansión
al registro restaurable demuestra

```text
Pr[alguna salida guardada acepta] ≤ min(1, B·errorRonda(k,q)),
errorRonda(k,q) = max(1/p², 4T/p², H(4T,q,1/8)).
```

Las hipótesis son T=2^k, 4≤k≤29, q≤4T y ausencia de traza base válida del
grado declarado. Para 4≤k≤12 y q=40 se obtiene

```text
Pr[alguna salida guardada acepta] ≤ min(1, B·H(4T,40,1/8)).
```

Restaurar un prefijo no devuelve el presupuesto consumido. B cuenta retos
ideales frescos y no se identifica con consultas SHA3. Una respuesta
reutilizada corresponde a un prefijo ya guardado.

La función de estado sigue parametrizada por la política. Falta demostrar
su invariancia entre políticas que coinciden en los mensajes del prefijo,
definirla sobre transcripciones independientemente de la estrategia y
transportar cambios de política entre ramas a este plan tipado. Por ello
no se declara cerrado el adaptador universal a las Definiciones 3.4–3.5
bibliográficas. Tampoco se verifica la semántica integral de Rust, la
extracción/vinculación Merkle, el sesgo modular, el selector de parejas ni
la transferencia Fiat–Shamir en ROM. QROM AIR/FRI permanece como trabajo
futuro. La tesis completa no está verificada.

La validación compila el proyecto, audita los 393 resultados y recomprueba
61 módulos secuencialmente con `leanchecker` de Lean 4.35.0, confiando en
los módulos importados. No usa `--fresh` ni un verificador externo. Los
únicos axiomas permitidos son `propext`, `Classical.choice` y `Quot.sound`.
Pasan los cinco controles del analizador de axiomas.

El informe conserva hashes de 101 fuentes y 67 logs. El inventario mantiene
272 candidatos en ocho fuentes y 35 bloques con correspondencia parcial.
Se comprueban sin diferencias 93 fuentes protegidas de la etapa anterior
y 594 logs de las quince etapas anteriores. Los capítulos, TG1, Rust y la
evidencia histórica se conservan. Las cifras de resultados no se usan
como porcentaje de cobertura del manuscrito.

Para repetir desde la raíz, conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
