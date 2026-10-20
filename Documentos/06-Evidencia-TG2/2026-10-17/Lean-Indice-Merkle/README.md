# Lean: índices Merkle y oráculos de campo congelados

Se añaden 38 resultados en cuatro módulos y se alcanzan **717 lemas y
teoremas registrados en 98 módulos**, con [auditoría completa](validacion.json)
correcta. La [etapa anterior](../Lean-Primeras-Consultas/README.md) conserva
sus 679 resultados. La tesis completa no está verificada.

| Módulo | Resultados nuevos |
|---|---:|
| [Merkle/Indices](../../../../formalizacion/Nexus/Merkle/Indices.lean) | 12 |
| [Merkle/PruebasIndexadas](../../../../formalizacion/Nexus/Merkle/PruebasIndexadas.lean) | 10 |
| [FRI/OraculoMerkle](../../../../formalizacion/Nexus/FRI/OraculoMerkle.lean) | 9 |
| [Canal/OraculosMerkle](../../../../formalizacion/Nexus/Canal/OraculosMerkle.lean) | 7 |

Los bits bajos se obtienen por módulo y división entre dos. Su reversa es la
ruta desde la raíz. Se prueban longitud, cotas y las dos inversas, más una
equivalencia entre rutas de longitud h e índices Fin (2^h). La inversa numérica
requiere i<2^h. Todo camino de la altura fijada está representado y el vector
extraído por rutas se transporta a un vector de hojas numeradas.

El acumulador desde la hoja consume el bit bajo y divide por dos. Los
hermanos se etiquetan con esos bits y se invierten para reconstruir desde
la raíz. Los dos cálculos coinciden. La aceptación matemática exige longitud
h e igualdad de la raíz. La cota del índice es una premisa al extraer, no una
comprobación añadida al bucle atribuyéndosela a Rust. Bajo ausencia de colisiones,
las aperturas aceptadas y registradas coinciden con el vector indexado; dos
aperturas del mismo índice tienen el mismo valor.

Para la capa j el índice de la hoja es el exponente del punto del dominio,
de tamaño 2^(k+3-j). Se construye una función Fp2→Fp2 con esos valores y cero
fuera del dominio. Con k≤29 y j≤k+3 se prueba la lectura de cada hoja. La
extensión es inyectiva; sus valores en el dominio y cero fuera la determinan
de manera única. Una apertura indexada aceptada y registrada coincide con el
valor del oráculo en su punto. En una capa no terminal, dos aperturas de los
índices a y a+N/2 dan exactamente la fórmula par/impar del plegado FRI.

| Resultado | Enlace demostrado |
|---|---|
| `ruta_indice_ruta` | La numeración reconstruye toda ruta de la altura fijada |
| `reconstruir_prueba_indexada` | El acumulador desde la hoja coincide con la reconstrucción desde la raíz |
| `apertura_indexada_extraida` | Una apertura aceptada y registrada da la hoja extraída en ese índice |
| `oraculo_vector_unico` | Los valores del vector y cero fuera del dominio determinan el oráculo |
| `plegado_de_pareja_abierta` | Dos aperturas registradas determinan la fórmula de plegado de su pareja |
| `oraculo_antes_reto_estable` | El oráculo previo a la primera exposición del reto coincide con el final sin aciertos |
| `existe_oraculo_antes_primera_exposicion` | Un único corte sirve para todos los índices y aperturas posteriores |
| `apertura_en_oraculos_emitidos` | La lectura del arreglo N06 conserva el valor de una apertura del corte correspondiente |

Para el par registrado absorción/reto en un recorrido desde vacío sin aciertos,
la congelación se transporta al oráculo sobre el campo. Este coincide antes de
las primeras respuestas de absorción y reto y permanece estable hasta el registro
final. Un mismo corte se elige antes de cuantificar sobre todos los índices,
valores y pruebas posteriores. Las repeticiones actuales no cambian esos orígenes.

Una familia dada de estados y raíces se convierte en OraculosEmitidos de N06.
La lectura recupera cada capa emitida y las familias de cortes antes de absorción
y reto producen el mismo arreglo. Las aperturas indexadas conservan sus valores.
Esta construcción toma la familia como dato: falta obtenerla causalmente para
todas las historias, fases y perfiles válidos. Tampoco completa las constantes
terminales, los hechos de registro de todo el protocolo o la aceptación global.

La instancia concreta usa hojas Fp2 de 17 bytes y nodos de 65 bytes. Falta
instanciar las hojas Fp de 9 bytes del programa. La relación matemática usa
naturales, módulo y división; aún no demuestra equivalencia con operaciones de
máquina, desplazamientos, trailing_zeros ni la ejecución de Rust. La copia
preservada de [merkle.rs](../../2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/merkle.rs)
identifica el orden de hermanos y el acumulador que motivan este modelo.

Permanecen justificar S=Q+V_T y B_T, la distribución de retos de campo, cola de
índices, potencial de nonces, gramática integral y el adaptador causal completo
a TranscripcionExplicita. No se deduce uniformidad al condicionar a la ausencia
de aciertos futuros. La cota del juego parametrizado conserva
min(1,S(49S+B)/2^256); no demuestra aleatoriedad de SHA3 concreto. QROM AIR/FRI
continúa como trabajo futuro.

La auditoría compila el proyecto, comprueba los axiomas de los 717 resultados
y recomprueba secuencialmente 98 módulos con `leanchecker` de Lean 4.35.0,
confiando en los importados. No usa `--fresh` ni un verificador externo.
Solo admite `propext`, `Classical.choice` y `Quot.sound`. Pasan los cinco
controles del analizador de axiomas. El dictamen independiente sigue pendiente.

Se conservan hashes de 140 fuentes y 104 logs. Ocho de doce afirmaciones tienen
componentes mecanizados. El inventario mantiene 272 candidatos en ocho fuentes
y 36 bloques con correspondencia parcial. Se comprueban intactas 131 fuentes
protegidas y 1.349 logs de las veinticuatro etapas anteriores. Se conservan
capítulos, TG1, Rust y evidencia histórica. Los conteos no son un porcentaje
de cobertura.

Para repetir desde la raíz conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
