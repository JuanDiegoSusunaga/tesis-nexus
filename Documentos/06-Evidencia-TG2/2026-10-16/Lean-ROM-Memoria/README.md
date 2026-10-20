# Oráculo con memoria y unión adaptativa de aciertos

**Fecha:** 16 de octubre de 2026. Se añaden 43 resultados en cuatro módulos:
601 registrados, frente a los 558 de la
[etapa anterior](../Lean-Merkle-Bytes/README.md). N07 mantiene su estado de
componente verificado con obligaciones de transferencia pendientes.

- [Validación, axiomas y hashes](validacion.json).
- [Compilación](build.log) y [auditoría de axiomas](axiomas.log).
- [Tabla y memoria](../../../../formalizacion/Nexus/ROM/Memoria.lean).
- [Juego de consultas](../../../../formalizacion/Nexus/ROM/Juego.lean).
- [Probabilidad y cota](../../../../formalizacion/Nexus/ROM/Probabilidad.lean).
- [Registro final y extracción congelada](../../../../formalizacion/Nexus/ROM/RegistroFinal.lean).
- [Alcance vigente](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

El juego usa entradas de octetos y digests de 32 octetos, de cardinal 2^256.
La tabla guarda pares entrada/respuesta sin repetir entradas. Consultar otra
vez una entrada devuelve su digest y deja intacta la tabla. Una entrada nueva
recibe un digest uniforme y se anexa. Solo este caso consume presupuesto de
respuestas nuevas; el adversario no recibe monedas ocultas de repeticiones.

La solicitud y sus nuevas marcas se fijan antes de recibir la respuesta,
según toda la historia ya observada. Se acumulan a lo sumo B digests
adicionales. Las marcas previas también incluyen las respuestas almacenadas,
las ventanas de entradas anteriores y las ventanas de la entrada actual.
La cuenta demostrada en la etapa anterior da cardinal ≤49S+B cuando la tabla
tiene menos de S entradas.

| Resultado | Propiedad |
|---|---|
| `respuesta_repetida` / `respuesta_nueva` | Semántica de memoria, sin remuestrear entradas guardadas |
| `antes_respuesta_card` | A lo sumo 49S+B marcas antes de responder |
| `riesgo_es_promedio` / `probabilidad_acierto` | Probabilidad racional exacta por conteo de cintas uniformes |
| `cota_union_adaptativa` | Riesgo ≤n(49S+B)/2^256 si longitud inicial+n≤S |
| `cota_desde_vacio` | Desde vacío, riesgo ≤min(1,S(49S+B)/2^256) |
| `ejecucion_sin_acierto` | Una cinta sin aciertos genera un recorrido con memoria |
| `recorrido_sin_colisiones` | Se conserva ausencia de colisiones; desde vacío se deriva sin premisa adicional |
| `extraer_congruente` | Los valores del hash fuera del registro no afectan al extractor |
| `apertura_congelada_memoria` | Aperturas posteriores de una raíz ya marcada igualan el vector calculado solo con la tabla al congelar |
| `apertura_absorbida_memoria` | Una raíz absorbida antes ya satisface la condición de marca |

El espacio uniforme reserva n respuestas frescas. Si un plan termina antes,
las coordenadas sobrantes se ignoran. Las repeticiones siguen una sola rama.
La probabilidad es el número de cintas con algún acierto dividido por
(2^256)^n y coincide con la recursión absorbente desde el primer acierto.
Por inducción adaptativa se suma la cota de cada respuesta nueva y se combina
con riesgo≤1. No se exige independencia entre los eventos ni se condicionan
respuestas a no tener aciertos futuros.

Todo recorrido sin acierto conserva las marcas y las respuestas. Completar la
función desde la tabla final con un digest arbitrario en entradas no consultadas
da una función compatible con cada prefijo. El extractor solo busca preimágenes
en entradas del registro, así que esa compleción no cambia su valor. Desde
vacío, las respuestas nuevas que evitan las marcas no colisionan con respuestas
anteriores. Para una raíz marcada al congelar se obtiene una extensión segura
Merkle y la apertura posterior aceptada y registrada coincide con el vector
calculado con la tabla de aquel instante. Las marcas adicionales pueden
revelarse después; nunca se aplican marcas futuras a respuestas anteriores.

Los presupuestos S y B son parámetros del juego. B cuenta marcas adicionales,
no retos ideales de N06. Faltan la gramática integral del canal y su realización
como estos planes, la justificación de S y B_T en el protocolo, índices y
profundidades, nonces, conexión con los planes N06 y equivalencia integral
con Rust y la transferencia ROM. La cota del juego ideal no demuestra que
SHA3 concreto sea aleatorio. QROM AIR/FRI sigue como trabajo futuro.
La tesis completa no está verificada.

La auditoría compila el proyecto, comprueba los axiomas de los 601 resultados
y recomprueba secuencialmente 86 módulos con `leanchecker` de Lean 4.35.0,
confiando en los importados. No usa `--fresh` ni un verificador externo.
Solo admite `propext`, `Classical.choice` y `Quot.sound`. Pasan los cinco
controles del analizador de axiomas.

Se conservan hashes de 127 fuentes y 92 logs. Ocho de doce afirmaciones
tienen componentes mecanizados. El inventario mantiene 272 candidatos en
ocho fuentes y 36 bloques con correspondencia parcial. Se comprueban intactas
118 fuentes protegidas y 1.061 logs de las veintiuna etapas anteriores.
Se conservan capítulos, TG1, Rust y evidencia histórica. Los conteos no son
un porcentaje de cobertura.

Para repetir desde la raíz conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
