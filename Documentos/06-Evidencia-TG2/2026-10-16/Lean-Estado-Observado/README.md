# Estado sobre mensajes observados y reinicios con políticas compatibles

**Fecha:** 16 de octubre de 2026. Se añaden 41 resultados y se alcanzan
434 lemas y teoremas registrados, frente a los 393 de la
[etapa de transcripción causal](../Lean-Transcripcion-Causal/README.md).

- [Validación, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).
- [Congruencia de prefijos: dos resultados](../../../../formalizacion/Nexus/N06/CongruenciaPrefijos.lean).
- [Políticas compatibles: diez resultados](../../../../formalizacion/Nexus/N06/PoliticasCompatibles.lean).
- [Terminales constantes: ocho resultados](../../../../formalizacion/Nexus/N06/TerminalesConstantes.lean).
- [Mensajes y estado observado: diez resultados](../../../../formalizacion/Nexus/N06/MensajesCompatibles.lean).
- [Reinicios observados: once resultados](../../../../formalizacion/Nexus/N06/ReiniciosObservados.lean).

La expansión anterior reconstruía la marca desde los retos, manteniendo una
política causal como parámetro. Esta etapa prueba que la marca depende de
los mensajes ya emitidos y define el estado sobre ese prefijo observado.
Después permite elegir otra política por petición, siempre que respete los
mensajes anteriores.

La congruencia genérica compara los monitores solo sobre la historia
recorrida. Se transporta a los residuos AIR, a las dos fases FRI y a la
aceptación. No se impone igualdad entre políticas sobre otras historias ni
sobre decisiones futuras.

El modelo general anterior conservaba un oráculo terminal adicional, y su
aceptación también lo consultaba. `normalizarTerminal` fija esa capa a la
constante final enviada. Se demuestra que conserva los mensajes tipados y
la marca antes de consultar; no se afirma igualdad de aceptación para cada
política general anterior. Las pruebas previas se conservan, y sus cotas se
aplican a la nueva política normalizada. En la versión observada las capas
terminales quedan determinadas por las constantes.

`MismosMensajes` compara el oráculo inicial, los oráculos de las capas ya
fijadas sobre la historia recorrida y las constantes ya emitidas. Incluye
el oráculo actual cuando está fijado antes del próximo reto. Durante
composición se conservan también la constante de traza y su oráculo inicial.
Antes de la muestra están fijados los mensajes de ambas fases.

Se prueban reflexividad, simetría, transitividad e invariancia del estado.
`PrefijoObservado` conserva fase y retos y toma el cociente de políticas por
esa relación. `estadoObservado` y `aceptaObservado` quedan bien definidos
sobre el cociente: no reciben una política futura como parámetro.
Los oráculos son las funciones completas del modelo ideal; no son raíces
Merkle ni bytes serializados del ejecutable.

| Resultado | Propiedad demostrada |
|---|---|
| `estado_mismos_mensajes` | Políticas que emiten los mismos mensajes dan el mismo estado normalizado |
| `estado_observado_inicial_iff` | El estado inicial es uno si y solo si existe una traza base válida |
| `mensaje_con_politica_compatible` | Se puede cambiar la política para el siguiente mensaje respetando el prefijo; el estado se conserva |
| `aceptacion_mismos_mensajes` | La aceptación también depende solo de los mensajes observados |
| `estado_observado_cero_rechaza` | Un prefijo en estado cero no es aceptado |
| `reto_observado_absorbente` | Una respuesta nueva conserva el estado uno |
| `cambio_observado_universal` | La cota local vale para enunciados válidos y falsos; para los válidos el cambio es cero |
| `reinicios_observados_cota` | Cota min(1,B·errorRonda) desde la raíz observada |
| `reinicios_observados_perfiles` | Cota min(1,B·h_T) en los nueve perfiles |

`PlanObservado` solo permite mensajes de la gramática tipada y retos cuyo
origen pertenezca al registro de prefijos observados. Cada petición escoge
su política antes de la respuesta nueva; la continuación puede depender
de toda la historia de intentos. Si cambia la política, su clase de mensajes
en el origen debe ser la misma que la ya guardada. No puede reescribir
oráculos anteriores ni borrar una excepción. La raíz vacía es única aunque
se represente con distintas políticas.

Para T=2^k, 4≤k≤29, q≤4T y ausencia de una traza base válida de grado menor
que T se demuestra

```text
Pr[algún prefijo guardado acepta] ≤ min(1, B·errorRonda(k,q)),
errorRonda(k,q) = max(1/p², 4T/p², H(4T,q,1/8)).
```

Para los nueve perfiles 4≤k≤12 y q=40 se obtiene

```text
Pr[algún prefijo guardado acepta] ≤ min(1, B·H(4T,40,1/8)).
```

Esta instancia reúne el estado sobre mensajes, las restricciones tipadas
y la elección de políticas entre ramas. B cuenta retos ideales frescos:
restaurar un prefijo no devuelve el presupuesto, y reutilizar una respuesta
corresponde a restaurar un nodo guardado. No se identifica B con consultas
SHA3 ni se atribuye independencia a los eventos de distintas rondas.

Permanece el adaptador integral a las transcripciones y adversarios de la
definición bibliográfica: realización y equivalencia de la gramática ideal
completa, formatos inválidos y aperturas. El cociente construido no verifica
la semántica completa de Rust, extracción/vinculación Merkle, sesgo modular,
selector de parejas ni compilación Fiat–Shamir en ROM. QROM AIR/FRI permanece
como trabajo futuro. La tesis completa no está verificada.

La validación compila el proyecto, audita los 434 resultados y recomprueba
66 módulos secuencialmente con `leanchecker` de Lean 4.35.0, confiando en
los módulos importados. No usa `--fresh` ni un verificador externo. Los
únicos axiomas permitidos son `propext`, `Classical.choice` y `Quot.sound`.
Pasan los cinco controles del analizador de axiomas.

El informe conserva hashes de 106 fuentes y 72 logs. El inventario mantiene
272 candidatos en ocho fuentes y 35 bloques con correspondencia parcial.
Se comprueban intactas 96 fuentes protegidas y 661 logs de las dieciséis
etapas anteriores. Se conservan los capítulos, TG1, Rust y la evidencia
histórica. Las cifras de resultados no expresan porcentaje del manuscrito.

Para repetir desde la raíz, conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.

