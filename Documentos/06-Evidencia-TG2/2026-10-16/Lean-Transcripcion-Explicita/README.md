# Prefijos con datos explícitos y correspondencia de sus retos

**Fecha:** 16 de octubre de 2026. Se añaden 32 resultados y se alcanzan
466 lemas y teoremas registrados, frente a los 434 de la
[etapa de estado observado](../Lean-Estado-Observado/README.md).

- [Validación, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).
- [Arreglos de oráculos: cinco resultados](../../../../formalizacion/Nexus/N06/OraculosEmitidos.lean).
- [Datos y realización: nueve resultados](../../../../formalizacion/Nexus/N06/DatosTranscripcion.lean).
- [Equivalencia de representaciones: once resultados](../../../../formalizacion/Nexus/N06/TranscripcionExplicita.lean).
- [Retos explícitos: siete resultados](../../../../formalizacion/Nexus/N06/RondasExplicitas.lean).

El prefijo observado anterior identifica políticas por los mensajes que ya
emitieron. Esta etapa construye una representación que guarda esos mensajes
como datos: fase, retos, arreglos finitos de oráculos y constantes enviadas.
No necesita incluir una política futura entre sus campos.

`OraculosEmitidos n` guarda una sola vez el oráculo inicial y un arreglo
con las n−1 capas posteriores. La lectura fuera de las capas indicadas usa
un valor fijo de relleno; no se afirma que sea una capa emitida. Capturar
después de leer recupera todos los datos. Leer una captura sobre sus índices
emitidos recupera la familia original. El oráculo inicial también se conserva
cuando todavía no se ha sorteado ningún reto de esa fase.

`MensajesExplicitos` distingue los datos disponibles en cada fase. Antes de
AIR solo se ha fijado el oráculo inicial. Durante FRI guarda las capas ya
emitidas, incluida la actual cuando precede al siguiente reto. Durante
composición conserva también los oráculos y la constante de traza. Antes de
la muestra común están fijados los mensajes de ambas fases y sus constantes.
Las capas terminales siguen siendo las constantes, como en la etapa anterior.

La igualdad de los datos capturados equivale exactamente a `MismosMensajes`.
La construcción `politicaDeDatos` reproduce cualquier conjunto de datos del
prefijo indicado. Para esa realización los oráculos y constantes son valores
fijos y no reciben retos futuros. La afirmación es sobre un prefijo individual;
no demuestra todavía una estrategia uniforme que realice una familia arbitraria
de transcripciones ni que todas las formas tipadas sean alcanzables desde vacío.

`codificarExplicita` envía los datos al prefijo observado y
`decodificarObservado` recupera sus mensajes. Se prueban ambas identidades
inversas, reunidas en `equivalenciaExplicita`. La correspondencia es biyectiva
y conserva fase y retos. No se recibe una conclusión de seguridad como premisa
de esa equivalencia.

| Resultado | Propiedad |
|---|---|
| `captura_mensajes_igual_iff` | Igualdad de datos capturados iff igualdad de mensajes en el modelo observado |
| `capturar_realizacion_prefijo` | La política construida desde los datos los reproduce en el prefijo indicado |
| `decodificar_codificar` / `codificar_decodificar` | Ambas representaciones son inversas |
| `estado_explicito_captura` | El estado de los datos coincide con el estado causal normalizado |
| `aceptacion_explicita_captura` | La aceptación también se conserva |
| `estado_explicito_inicial_iff` | Estado inicial uno iff el enunciado tiene una traza base válida |
| `estado_explicito_cero_rechaza` | Estado cero implica rechazo |
| `mensaje_explicito_conserva_estado` | Los mensajes capturados de un paso tipado conservan el estado |
| `cambio_explicito_coincide` | El cambio de estado de un reto explícito coincide con el del reto observado |
| `cambio_explicito_perfiles` | La cota local es h_T en los nueve perfiles |

`PeticionExplicita` contiene la ronda y los datos fijados en su origen.
La política canónica se obtiene de esos datos antes de la respuesta nueva.
La codificación de origen y destino coincide exactamente con una petición
observada. De ahí se transportan la absorción del estado uno y la cota

```text
Pr[estado anterior = 0 y estado posterior = 1]
  ≤ errorRonda(k,q)
  = max(1/p², 4T/p², H(4T,q,1/8)).
```

Se exige T=2^k, 4≤k≤29 y q≤4T. La cota local vale tanto para enunciados
válidos como falsos; los válidos permanecen en estado uno. Para 4≤k≤12 y
q=40 se obtiene la cota local `H(4T,40,1/8)`.

El corolario de reinicios con políticas compatibles de la etapa anterior
se conserva en su modelo observado. Esta etapa no añade una traducción
de todos los planes de adversarios a una gramática explícita completa.
Faltan esa traducción, la alcanzabilidad y correspondencia de todas las
transiciones de mensajes, formatos inválidos y aperturas. Los oráculos son
funciones matemáticas completas; no se verifican bytes, semántica integral
de Rust, extracción/vinculación Merkle, sesgo modular, selector de parejas
ni compilación Fiat–Shamir en ROM. QROM AIR/FRI sigue como trabajo futuro.
La tesis completa no está verificada.

La validación compila el proyecto, audita los 466 resultados y recomprueba
70 módulos secuencialmente con `leanchecker` de Lean 4.35.0, confiando en los
módulos importados. No usa `--fresh` ni un verificador externo. Solo se
permiten `propext`, `Classical.choice` y `Quot.sound`. Pasan los cinco
controles del analizador de axiomas.

El informe conserva hashes de 110 fuentes y 76 logs. El inventario mantiene
272 candidatos en ocho fuentes y 35 bloques con correspondencia parcial.
Se comprueban intactas 101 fuentes protegidas y 733 logs de las diecisiete
etapas anteriores. Se conservan los capítulos, TG1, Rust y la evidencia
histórica. Los números de resultados no expresan porcentaje de cobertura.

Para repetir desde la raíz, conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.

