# Lean: hojas base y oráculos mixtos de N06

Se añaden 36 resultados en cuatro módulos y se alcanzan **753 lemas y
teoremas registrados en 102 módulos**, con [auditoría completa](validacion.json)
correcta. La [etapa anterior](../Lean-Indice-Merkle/README.md) conserva sus
717 resultados. La tesis completa no está verificada.

| Módulo | Resultados nuevos |
|---|---:|
| [Merkle/CodificacionBase](../../../../formalizacion/Nexus/Merkle/CodificacionBase.lean) | 13 |
| [ROM/FormatoBase](../../../../formalizacion/Nexus/ROM/FormatoBase.lean) | 6 |
| [FRI/OraculoBase](../../../../formalizacion/Nexus/FRI/OraculoBase.lean) | 7 |
| [Canal/OraculosBase](../../../../formalizacion/Nexus/Canal/OraculosBase.lean) | 10 |

El formato de hoja Fp tiene ocho octetos LE del representante canónico y un
prefijo cero: nueve bytes en total. Se prueban longitud, lectura inversa,
recodificación e inyectividad. La lectura solo admite ocho bytes cuyo entero
es menor que p. Las hojas Fp2 de diecisiete bytes y las hojas base son entradas
distintas, y ambos decodificadores rechazan el otro formato. No se afirma
desigualdad incondicional de hashes de esas entradas ni se identifican raíces.

Los formatos comparten nodos de 65 bytes, con decodificación inversa y
canónica. Para cualquier entrada y registro, sus etiquetas de protección son
exactamente iguales. Esto transporta las extensiones seguras al formato base
en la misma memoria ROM y con la misma función hash. La extracción y el vector
Fp permanecen estables antes de responder a la consulta que procesa la raíz
y durante su futuro sin aciertos. Las aperturas aceptadas y registradas
coinciden con ese valor previo. No se introduce un segundo oráculo aleatorio.

Se prueba congruencia del extractor para cualquier formato con valor cero:
solo usa la función hash en entradas registradas. Con una tabla sin entradas
repetidas, cambiar el digest de relleno de la función total no cambia el valor
extraído. El oráculo base construido desde un estado también es independiente
de ese relleno; las regiones ausentes o mal formadas se completan con cero.

El oráculo base extrae Fp primero y luego lo inyecta en Fp2. Cada hoja aparece
en el punto correspondiente a su índice y fuera del dominio la función vale
cero. Todos sus valores pertenecen a la imagen del campo base. Por tanto el
conteo puntosFueraBase, usado en N03, es cero en cualquier conjunto finito.
Se prueban lectura para k≤29, j≤k+3 e índices acotados, transporte de igualdad,
vinculación de aperturas y la fórmula de plegado de una pareja base abierta.
El coeficiente de plegado pertenece a Fp2; no se impone que las capas posteriores
continúen tomando valores base.

| Resultado | Enlace demostrado |
|---|---|
| `bytes_de_fp_leido` | La lectura canónica determina exactamente sus ocho bytes |
| `formatos_hoja_se_rechazan` | Una hoja Fp2 no se acepta como hoja Fp y viceversa |
| `etiquetas_base_coinciden` | Los formatos comparten las etiquetas de protección de todo registro |
| `extraccion_independiente_defecto` | El extractor no depende del digest de relleno de la tabla |
| `oraculo_base_sin_valores_fuera_base` | El conteo de valores no base de N03 es cero |
| `plegado_de_pareja_base_abierta` | Dos aperturas base registradas dan su plegado en Fp2 |
| `existe_oraculo_base_antes_primera_exposicion` | Un único corte sirve para todos los índices y aperturas posteriores |
| `apertura_base_en_oraculos_mixtos` | La lectura inicial N06 conserva una apertura Fp inyectada |
| `apertura_extension_en_oraculos_mixtos` | Las lecturas posteriores conservan sus aperturas Fp2 |

En un recorrido desde vacío sin aciertos con absorción y reto registrados,
el oráculo base coincide antes de las primeras respuestas de ambos y permanece
estable hasta el registro final. Un mismo corte, elegido antes de cuantificar
sobre índices y aperturas, vincula todos sus valores aceptados y registrados.
Las repeticiones actuales conservan sus instantes de origen.

Se construyen arreglos OraculosEmitidos con inicial extraído de hojas Fp y
siguientes extraídos de hojas Fp2. Se prueban lecturas, aperturas e igualdad
entre las familias de cortes anteriores a absorción y reto. Las familias se
reciben como datos; falta realizarlas causalmente para todas las historias,
perfiles y fases válidas. No se demuestra todavía la relación completa del
verificador entre el compromiso de la traza y el primer compromiso FRI.
La inyección algebraica de los valores no identifica sus serializaciones.

La copia preservada de [merkle.rs](../../2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/merkle.rs)
distingue las hojas Felt y Fp2, y [field.rs](../../2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/field.rs)
conserva las fórmulas de serialización LE. Las pruebas describen valores
matemáticos canónicos. Falta probar validación de rangos y deserializaciones,
operaciones de máquina, desplazamientos, trailing_zeros y ejecución de Rust.

Permanecen la gramática y todos sus hechos de registro, el adaptador causal
completo a TranscripcionExplicita, constantes terminales, presupuestos S=Q+V_T
y B_T, distribuciones de retos, cola de índices y potencial de nonces. La
igualdad de etiquetas permite reutilizar la protección; no justifica los
presupuestos reales. La cota del juego parametrizado sigue siendo
min(1,S(49S+B)/2^256). No se deduce uniformidad al condicionar a la ausencia
de aciertos futuros ni aleatoriedad de SHA3 concreto. QROM AIR/FRI continúa
como trabajo futuro.

La auditoría compila el proyecto, comprueba los axiomas de los 753 resultados
y recomprueba secuencialmente 102 módulos con leanchecker de Lean 4.35.0,
confiando en los importados. No usa --fresh ni un verificador externo.
Solo admite propext, Classical.choice y Quot.sound. Pasan los cinco controles
del analizador de axiomas. El dictamen independiente sigue pendiente.

Se conservan hashes de 144 fuentes y 108 logs. Ocho de doce afirmaciones tienen
componentes mecanizados. El inventario mantiene 272 candidatos en ocho fuentes
y 36 bloques con correspondencia parcial. Se comprueban intactas 135 fuentes
protegidas y 1.453 logs de las veinticinco etapas anteriores. Se conservan
capítulos, TG1, Rust y evidencia histórica. Los conteos no son un porcentaje
de cobertura.

Para repetir desde la raíz conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
