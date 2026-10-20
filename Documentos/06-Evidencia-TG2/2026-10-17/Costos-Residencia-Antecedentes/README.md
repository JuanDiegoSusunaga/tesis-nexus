# Antecedentes de la pasada de residencia y costos

El [manifiesto](manifiesto.json) fija la auditoría anterior de 864 resultados y
113 módulos y quince versiones anteriores de archivos actualizados o consultados.
Siete pertenecen a las fuentes identificadas por esa auditoría y cambian en esta
pasada; las otras 170 fuentes se conservan intactas. Las copias se mantienen bajo
`version_anterior/`, con sus bytes y hashes.

[Datos de los modelos](datos-modelos.json) identifica el inventario de tamaños
ML-DSA-65/fips204 0.4.6 y las constantes de sensibilidad de §6.6.5. Las trece fuentes
R5 quedan identificadas por hash. El código, los tipos del backend, Cargo.lock
y los logs se contrastan con el informe histórico. Se reutiliza esa evidencia
sin ejecutar nuevos benchmarks ni pruebas Rust.

La [auditoría nueva](../Lean-Costos-Residencia/validacion.json) fija estos archivos,
las copias anteriores y las fuentes R5. La [evidencia anterior de entropía y salud](../Lean-Entropia-Salud/README.md)
se conserva con sus cifras originales. Los capítulos y los entregables aprobados
de TG1 permanecen intactos; los textos e identificadores del inventario no cambian.
