# Primera revisión matemática del manuscrito TG2

Se clasifican los 272 candidatos del inventario base y se registran 14 omisiones.
La matriz distingue 46 grupos: 27 pendientes, 13 con componentes Lean, tres
dependencias bibliográficas, dos de respaldo documental y QROM AIR/FRI futuro.

El registro complementario contiene 51 bloques con enlaces parciales a pruebas
existentes, frente a 36 del inventario base: son 15 bloques adicionales trazados,
sin teoremas nuevos. Permanecen 777 resultados en 106 módulos. Clasificación,
trazabilidad y demostración matemática son estados distintos; estos conteos no
son porcentajes de la tesis ni de esfuerzo restante.

La [matriz y orden de trabajo](../../../../formalizacion/REVISION-MANUSCRITO.md)
prioriza entropía, salud, residencia, amortización, bases y complejidad del
manuscrito antes del cierre integral Rust/ROM. El
[registro estructurado](../../../../formalizacion/revision-manuscrito.json)
conserva referencias, clases, alcances y seis hallazgos.
La [validación](validacion.json) comprueba trazabilidad; los
[seis controles negativos](pruebas.log) pasan.

Se conserva la [auditoría Lean previa](../Lean-Enlace-AIR-FRI/validacion.json):
149 fuentes intactas y 1.673 logs de 27 etapas, sin recompilar ni recomprobar
pruebas que no cambiaron. El inventario base y los ocho archivos del manuscrito
permanecen intactos; también TG1, Rust y evidencia histórica. La comprobación
automática valida integridad, no la verdad de la clasificación manual. No
acredita exhaustividad del barrido ni reemplaza dictamen independiente.

```powershell
python scripts/verificar_revision_manuscrito.py
python -m unittest discover -s scripts/tests -p test_verificar_revision_manuscrito.py
```

La tesis completa no está verificada. Esta evidencia se conserva; las ejecuciones
posteriores deben escribirse en una salida diferente.
