# Congelación antes de responder y entradas del canal

**Fecha:** 17 de octubre de 2026. Se añaden 39 resultados en cuatro módulos:
640 registrados, frente a los 601 de la
[etapa anterior](../../2026-10-16/Lean-ROM-Memoria/README.md). N07 conserva su
estado de componente verificado, con obligaciones de transferencia pendientes.

- [Validación, axiomas y hashes](validacion.json).
- [Compilación](build.log) y [auditoría de axiomas](axiomas.log).
- [Marcas preparadas](../../../../formalizacion/Nexus/ROM/Preparacion.lean).
- [Congelación previa](../../../../formalizacion/Nexus/ROM/CongelacionPrevia.lean).
- [Entradas del canal](../../../../formalizacion/Nexus/Canal/Entradas.lean).
- [Secuencia de raíz y reto](../../../../formalizacion/Nexus/Canal/Raices.lean).
- [Alcance vigente](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

La etapa anterior congelaba una raíz ya marcada en el estado. Ahora basta
que esté en las marcas preparadas por la solicitud actual: raíces adicionales,
marcas de la tabla y ventanas de la propia entrada. Una raíz puede aparecer
por primera vez en esa entrada y aún no figurar en la tabla.

Un paso sin acierto responde según la memoria y guarda el valor entregado.
Se prueba que las marcas preparadas cubren las etiquetas Merkle antes de
responder y persisten después. En una repetición, las ventanas actuales ya
están en la tabla; en una entrada nueva se anexan junto con su respuesta.
El paso actual y el recorrido futuro componen una extensión segura. El vector
calculado con la tabla anterior a la respuesta permanece estable y, desde
vacío sin aciertos, toda apertura posterior aceptada y registrada lo respeta.

| Resultado | Propiedad |
|---|---|
| `paso_responde_memoria` | El paso devuelve la respuesta guardada o almacena la nueva |
| `marcas_previas_persisten` | Las marcas preparadas sobreviven tanto a repeticiones como a respuestas nuevas |
| `etiquetas_antes_cubiertas` | La cobertura vale antes de recibir la respuesta actual |
| `apertura_previa_respuesta` | La apertura posterior coincide con el vector calculado antes de responder |
| `absorcion_inyectiva` | Recuperación única de estado, etiqueta y datos del formato de absorción |
| `absorcion_longitud_leida` | La longitud se recupera exactamente dentro del rango u64 |
| `reto_inyectivo` / `trabajo_inyectivo` | Campos recuperables en retos F/E/I y trabajo con nonce u64 |
| `absorcion_nodo_solapados` | Una absorción de 65 bytes puede coincidir exactamente con un nodo Merkle |
| `respuestas_encadenadas` | La entrada del reto contiene la respuesta efectiva de la absorción |
| `apertura_fijada_antes_de_ambas` | Aperturas posteriores respetan el vector previo a las dos llamadas locales |

Se modelan las fórmulas de listas de octetos de la fuente preservada de
[channel.rs](../../2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/channel.rs),
añadiendo su SHA-256 al informe. La cabecera mide 33 bytes. La absorción
añade longitud de ocho bytes LE y datos, midiendo 41+|datos|. Se recuperan
cabecera, datos y bytes de longitud; interpretar estos últimos como longitud
exacta exige |datos|<2^64. Los retos usan F/E/I, etiquetas 70/69/73, y miden
33 bytes. El trabajo usa etiqueta 5 y nonce en Fin(2^64), y mide 41 bytes.
Las inyectividades se refieren a entradas codificadas, sin postular que el
hash sea inyectivo. No se modifica ni ejecuta Rust en esta etapa.

Se prueban distinciones locales por longitud y se conserva un solapamiento
explícito: una absorción con etiqueta 4 y 24 bytes coincide con un nodo Merkle
de 65 bytes. El testigo certifica esa igualdad de formatos; no demuestra por
sí solo que su carga sea un enunciado admitido por todo el protocolo. No se
exige separación global de roles del único oráculo.

La secuencia local absorbe una raíz y usa la respuesta efectiva como estado
del reto siguiente. Ese orden de llamadas aparece en el generador y el verificador
de [fri.rs](../../2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/fri.rs):
absorción con TAG_FRI_ROOT y llamada inmediata a challenge_ext. La raíz está en las ventanas de la entrada de absorción
antes de la primera respuesta. Fuera de aciertos, su vector se calcula con
la tabla previa a ambas llamadas y coincide con el extraído después. Toda
apertura posterior aceptada y registrada queda vinculada a ese vector. Las
dos llamadas admiten consultas repetidas con sus respuestas memorizadas.

La anterioridad probada es respecto de las llamadas locales consideradas.
Si un reto ya se consultó, su valor puede conocerse antes de esa secuencia.
Queda reconstruir la historia de primeras consultas y transportar la congelación
a la primera exposición del reto en todo el grafo. No se deduce independencia
de las respuestas repetidas. También faltan las historias y perfiles completos,
los presupuestos S=Q+V_T y B_T, la distribución de los retos de campo, la cola
de índices, el potencial de nonces, la conexión N06 y la semántica integral
de Rust. El formato del nonce no prueba su probabilidad de éxito. QROM AIR/FRI
sigue como trabajo futuro. La tesis completa no está verificada.

La auditoría compila el proyecto, comprueba los axiomas de los 640 resultados
y recomprueba secuencialmente 90 módulos con `leanchecker` de Lean 4.35.0,
confiando en los importados. No usa `--fresh` ni un verificador externo.
Solo admite `propext`, `Classical.choice` y `Quot.sound`. Pasan los cinco
controles del analizador de axiomas.

Se conservan hashes de 132 fuentes y 96 logs. Ocho de doce afirmaciones
tienen componentes mecanizados. El inventario mantiene 272 candidatos en
ocho fuentes y 36 bloques con correspondencia parcial. Se comprueban intactas
122 fuentes protegidas y 1.153 logs de las veintidós etapas anteriores.
Se conservan capítulos, TG1, Rust y evidencia histórica. Los conteos no son
un porcentaje de cobertura.

Para repetir desde la raíz conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
