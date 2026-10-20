# Revisión de alcance de la pasada amplia

## Qué cambió

M10, M32 y M46 cumplen sus criterios de modelo con teoremas registrados.
M10 es un contraste negativo de aplicabilidad; no se convierte en dureza.
M32 prueba aceptación desde ejecución matemática, sin recibir aceptación
FRI como premisa. M46 usa el control base de las consultas, sin exigir un
oráculo globalmente base. Se conservan criterios y límites de los otros grupos.

## Qué exige la composición global

La familia de oráculos construida para el resultado de aceptación usa el
registro final. Su identificación con una familia que dependa solo de la
historia anterior a cada reto es una obligación adicional, aunque existan
teoremas locales de congelación. El bucle FRI no demuestra esa causalidad.

El selector modelado rechaza duplicados y se detiene con suficientes índices;
sus fibras de máscara son uniformes bajo palabras uniformes. Falta probar
la ley uniforme del subconjunto terminado y atribuir entradas frescas al
selector de cada candidato de la memoria compartida. El corte 512 es del
análisis, no un cambio de Rust.

El plan de potencial permite decisiones adaptativas y mantiene su contabilidad.
Para aplicarlo faltan los árboles concretos, la ley de cada respuesta y sus
cotas previas en todas las historias. La composición de eventos tampoco se
cierra suponiendo las inclusiones que debe derivar el adaptador.

## Qué exige el refinamiento de implementación

La NTT del árbol par/impar es algebraicamente correcta. El backend usa un
orden y una representación Montgomery que necesitan equivalencia demostrada.
Los bloques de máscaras y sus límites de u16 no justifican una ley IID de
ExpandMask ni el comportamiento de desbordamiento de debug/release.

El sobre operation_bytes es una codificación concreta de operaciones TG2.
No es el bincode de transacciones TG1. La propuesta de rotación usa firmas
del lote tipado, pero no formaliza toda la cadena de altas, retiros y archivos
del registro, ni custodia/borrado. Los invariantes de salud acotan contadores;
falta demostrar el cálculo de umbrales y estimaciones de f64 del programa.

Los conteos de layout y serialización describen formatos declarados. No
prueban sizeof del compilador, parsing global, RAM total o zeroización.
La interpolación recupera el testigo si se publican suficientes evaluaciones
correctas; resta identificar los valores exactos de un certificado del ejemplo.

M26 y M27 se revisan contra sus modelos ya existentes. No se aportan datos
originales nuevos de H1/H2 ni se acredita consenso, DA o incentivos desplegados.
El estado parcial se conserva. TG1 no se modifica y QROM AIR/FRI permanece futuro.
