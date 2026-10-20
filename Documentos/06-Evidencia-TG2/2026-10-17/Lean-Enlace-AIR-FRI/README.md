# Lean: raíz compartida y enlace local AIR/FRI de TG2

Se añaden 24 resultados en cuatro módulos y se alcanzan **777 lemas y
teoremas registrados en 106 módulos**, con [auditoría completa](validacion.json)
correcta. La tesis completa no está verificada.

| Módulo | Resultados nuevos |
|---|---:|
| [FRI/PosicionesAIR](../../../../formalizacion/Nexus/FRI/PosicionesAIR.lean) | 8 |
| [Canal/RaizCompartida](../../../../formalizacion/Nexus/Canal/RaizCompartida.lean) | 5 |
| [Canal/AperturasAIR](../../../../formalizacion/Nexus/Canal/AperturasAIR.lean) | 5 |
| [Canal/EnlaceComposicion](../../../../formalizacion/Nexus/Canal/EnlaceComposicion.lean) | 6 |

La revisión de la [variante TG2 v1](../../2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/experiments/tg2_linked_trace_fri.rs)
y de la [transferencia ROM](../../../04-Administrativo-TG2/Avances/Transferencia-ROM-2026-09-23/Transferencia-Protocolo-ROM.md)
precisa el alcance de la [etapa de hojas base](../Lean-Hojas-Base/README.md).
El [verificador legado](../../2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/air.rs)
usa hojas Fp de nueve bytes para AIR. TG2 v1 autentica esos valores AIR mediante
su inyección a Fp2 y hojas de diecisiete bytes. Exige que la primera raíz FRI
de traza sea la raíz AIR; comparte tanto raíz como formato. El legado no es
el objeto de la transferencia N07 del protocolo TG2.

Las pruebas de nueve bytes, su oráculo base y los arreglos mixtos siguen
siendo correctos para ese modelo auxiliar. Se conservan sin modificar sus
fuentes ni evidencia. Sus alcances en el registro y el inventario se precisan:
ese oráculo globalmente base no sustituye al inicial de TG2. Un probador
malicioso puede comprometer valores de extensión no base en posiciones no
abiertas. El control base de N03 y N06 se exige en las posiciones consultadas.
No se identifican hashes de serializaciones distintas.

La comprobación booleana de raíz acepta exactamente listas que empiezan por
la raíz AIR; rechaza la vacía. En un registro sin aciertos, dos cortes con
la misma raíz y formato producen el mismo oráculo antes de sus retos y
absorciones respectivas. La lectura inicial de un arreglo N06 dado conserva
esa identidad. Esto permite reutilizar el vector fijado antes del primer reto
AIR cuando vuelve a absorberse la raíz para el primer reto FRI de traza.

Los seis datos AIR se indexan por Bool×Fin3. Sus índices son i+8j y i+N/2+8j
módulo N, para j=0,1,2. Se prueban cardinal seis, rango, periodicidad y
coincidencia con x,gx,g²x y -x,-gx,-g²x. Para i<N/2, la pareja corresponde al
representante del punto del dominio cuadrado de N06. La aritmética es de
naturales; no se formalizan aquí los desbordamientos de máquina.

Cada dato AIR tiene valor Fp y camino Merkle, pero la apertura verifica
su inyección Fp2 con el formato de diecisiete bytes. Las aperturas aceptadas
y registradas vinculan los seis valores al oráculo congelado. De ellas se
deriva el control base de una pareja y de toda una muestra de índices acotados.
No se presupone que todos los valores del oráculo sean base. Las aperturas
de la primera pareja FRI bajo la misma raíz satisfacen también TraceLink
fuera de aciertos, por la vinculación del extractor.

| Resultado | Enlace demostrado |
|---|---|
| `raiz_verificada_comparte_oraculo` | El control de raíz conserva el oráculo entre cortes AIR y FRI |
| `punto_indice_air` | Cada índice de apertura evalúa g^j*x o g^j*(-x) |
| `valores_air_congelados` | Las seis aperturas coinciden con el oráculo previo al reto |
| `control_base_muestra_air` | Las aperturas derivan el control base de toda la muestra N06 |
| `enlace_traza_de_aperturas` | La primera pareja FRI coincide con los valores AIR bajo la raíz compartida |
| `composicion_base_inmersion` | La fórmula de compose en Fp se transporta a Fp2 |
| `composicion_de_aperturas_air` | Los tres valores de cada lado dan composicionLocal sin polos |
| `consulta_enlace_muestra` | Aperturas y comparaciones locales derivan ConsultaParejas |
| `aceptacion_compartida_de_aperturas` | Las dos aceptaciones FRI y los controles derivados ensamblan AceptaCompartida |

La fórmula racional de compose se transporta desde Fp a Fp2 conservando
sumas, productos, potencias y divisiones. Con los tres valores abiertos,
la raíz primitiva y la ausencia de polos ya probadas para el coset, coincide
con composicionLocal. Las aperturas de la primera pareja de composición y
las comparaciones locales vinculan su oráculo con esa fórmula. Se obtiene
el predicado ConsultaParejas sobre la muestra común, sin multiplicar
probabilidades de consultas distintas.

El teorema final produce AceptaCompartida de N06 desde esos controles,
con las dos aceptaciones FRI y las coincidencias de oráculos iniciales como
premisas separadas. No es todavía una prueba de aceptación del ejecutable:
falta derivar las aceptaciones FRI del bucle de selección de mitad, acarreo
entre capas y comparación con la constante final de verify_query. Los datos
ya están tipados y se reciben las aperturas aceptadas y registradas; todavía
hay que obtenerlos para todas las historias, listas, perfiles y rechazos.

Permanecen la realización causal de todas las familias, el adaptador completo
a TranscripcionExplicita, fases terminales, rangos y semántica de máquina,
presupuestos S=Q+V_T y B_T, sesgo de retos de campo, cola de índices y potencial
de nonces. La cota ROM parametrizada sigue siendo min(1,S(49S+B)/2^256).
No se deduce uniformidad al condicionar a ausencia de aciertos futuros ni
aleatoriedad de SHA3 concreto. QROM AIR/FRI continúa como trabajo futuro.

La auditoría compila el proyecto, comprueba los axiomas de los 777 resultados
y recomprueba secuencialmente 106 módulos con leanchecker de Lean 4.35.0,
confiando en los importados. No usa --fresh ni un verificador externo.
Solo admite propext, Classical.choice y Quot.sound. Pasan los cinco controles
del analizador de axiomas. El dictamen independiente sigue pendiente.

Se conservan hashes de 149 fuentes y 112 logs. La variante experimental y la
transferencia ROM ya estaban identificadas; se incorpora air.rs para registrar
la distinción con el legado. Ocho de doce afirmaciones tienen componentes
mecanizados. El inventario mantiene 272 candidatos en ocho fuentes y 36 bloques
con correspondencia parcial. Se comprueban intactas 139 fuentes protegidas
y 1.561 logs de las veintiséis etapas anteriores. Se conservan capítulos,
TG1, Rust y evidencia histórica. Los conteos no son un porcentaje de cobertura.

Para repetir desde la raíz conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
