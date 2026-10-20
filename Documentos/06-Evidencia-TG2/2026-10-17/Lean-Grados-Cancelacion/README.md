# Grados AIR y cancelación con retos sesgados

La [auditoría conjunta](validacion-rectificada.json) comprueba **1446 resultados en 157 módulos**.
Se añaden 53 resultados en tres módulos. M28 y M29 cierran sus modelos matemáticos;
la [matriz vigente](../../../../formalizacion/REVISION-MANUSCRITO.md) conserva 18
modelos verificados, 22 grupos parciales, tres dependencias bibliográficas, dos
respaldos documentales y QROM AIR/FRI como trabajo futuro. No se verifica toda la tesis.
El inventario tiene 181 bloques con enlaces parciales; el registro complementario,
190 bloques y diez suplementos. Los conteos no son porcentajes de avance.

| Módulo | Resultados | Alcance |
|---|---:|---|
| [AIR/GradosValidos](../../../../formalizacion/Nexus/AIR/GradosValidos.lean) | 10 | Factorización de fronteras válidas, cocientes de frontera de grado <=T-2, numeradores de frontera de grado <=2(T-1), cociente de transición de grado <=T y composición de grado <=T. Para trazas válidas, identidad racional fuera de polos y grado <2T. |
| [AIR/CancelacionSesgada](../../../../formalizacion/Nexus/AIR/CancelacionSesgada.lean) | 10 | Cota de un evento con resultado único por la masa máxima. Ley conjunta por contexto y reto condicionado, unicidad de cancelación lineal y cota condicional. Para tres retos independientes con masas <=mu y residuos no todos nulos, cancelación <=mu; aplicación a una traza AIR fija inválida. |
| [AIR/EjemploCancelacion](../../../../formalizacion/Nexus/AIR/EjemploCancelacion.lean) | 33 | Polinomio explícito sobre Goldilocks: 16 evaluaciones, cambio de primera fila de 3 a 4, invalidez, recurrencias restantes y resto combinado nulo para alpha0=10376293027944593777, alpha1=alpha2=1. Grado exacto de la traza 15, numerador 32 y composición 16. Existe una traza válida alternativa con la misma salida pública. |

## Qué se demuestra

Para grado(f)<T y T>=3, los cocientes de frontera tienen grado <=T-2 y el de
transición <=T. La composición polinómica tiene grado <=T<2T. Si la traza es
válida, la divisibilidad hace coincidir esa composición con N_alpha/D fuera de
polos. El cociente euclídeo existe también con resto no nulo: su grado por sí
solo no prueba validez. Se prueban por separado factorización e identidad racional.

La cancelación con tres retos independientes tiene probabilidad <=mu si cada
masa puntual es <=mu y algún residuo fijo es no nulo. Una versión más general
obtiene primero un contexto y después el coeficiente; exige la ley condicionada
y su cota de masa. Esta hipótesis no se deduce aquí del registro ROM adaptativo.

El ejemplo explícito sobre Goldilocks cambia solo la primera fila de 3 a 4.
Lean verifica sus 16 evaluaciones, las recurrencias posteriores y el reto
alpha0=10376293027944593777, alpha1=alpha2=1. La traza es inválida y el resto
combinado es cero. Los grados exactos son 15 para la traza, 32 para el numerador
y 16 para la composición. Existe una traza válida alternativa con la misma
salida pública. No se fuerzan retos SHA3 ni se demuestra aceptación de certificados.

## Verificación y conservación

Compilación sin advertencias, auditoría de axiomas y replay secuencial de los 157
módulos correctos. Solo se admiten propext, Classical.choice y Quot.sound.
leanchecker confía en importados; no es --fresh ni un dictamen independiente.
El informe fija 344 fuentes y 163 logs. Los [13 controles](controles-finales.log),
la [trazabilidad](revision-manuscrito.json) y la [integridad](integridad-grados-cancelacion.json)
conservan 2520 logs de 33 etapas. Los [antecedentes](../Grados-Cancelacion-Antecedentes/README.md)
guardan 16 versiones previas; de las 320 fuentes anteriores, 314 permanecen
idénticas y seis cambian con copia exacta. Los 3741 archivos de la edición
anterior se recuperan con sus hashes originales mediante esas copias y los
archivos intactos. Los capítulos, Word, PDF, Markdown,
Rust y entregables TG1 no cambian. El autor confirmó que no hay dictamen.

La [rectificación documental](rectificacion-metadatos.json) corrige una referencia
al inventario base: el hash anterior debe enlazar su copia congelada. Se conserva
la [auditoría matemática original](validacion.json) y la revisión JSON anterior.
La auditoría rectificada reutiliza por identidad los 157 replays, sus axiomas y
todos los archivos Lean; solo cambian dos referencias del JSON de revisión.
Los controles y la trazabilidad se repiten tras corregirlas. No se añaden pruebas
matemáticas ni se vuelve a atribuir una ejecución al código modificado.

## Próximas obligaciones

El siguiente tramo AIR/FRI es M32: derivar las dos aceptaciones FRI del recorrido
completo, acarreo, índices y valor final. Luego quedan el adaptador causal y la
gramática/presupuestos completos M37/M39, el potencial adaptativo M40 y la
composición ROM M41. M28/M29 no resuelven esas obligaciones.

En firmas siguen el juego SelfTarget bibliográfico, las reducciones con sus
hipótesis, codecs/hedged/expansión, NTT concreta y correspondencia con el backend.
En salud y claves quedan f64, enteros de máquina, autorización del registro y
refinamiento de las operaciones. Las mediciones y la fuente física conservan
obligaciones documentales y de despliegue separadas.

```powershell
python scripts/verificar_formalizacion.py
python scripts/verificar_revision_manuscrito.py
```
