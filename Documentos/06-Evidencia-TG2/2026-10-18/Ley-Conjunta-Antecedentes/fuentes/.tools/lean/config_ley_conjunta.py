"""Alcances del bloque de ley conjunta del ROM matemático finito."""

MODELS = {
    "ROM/PromediosCompletaciones": {
        "grupos": ["M35", "M41"], "secciones": ["6.7.4"],
        "verificado": "Revelar una dirección nueva particiona las tablas compatibles en fibras del mismo tamaño. Se prueba la igualdad de medias para cualquier observable de toda la tabla y la equivalencia con la media uniforme desde la tabla vacía.",
        "limites": ["Identidades racionales de universos finitos; no supone SHA3 uniforme ni condiciona a un evento futuro."]},
    "ROM/LeyArbol": {
        "grupos": ["M35", "M41"], "secciones": ["6.7.4"],
        "verificado": "Para cualquier árbol adaptativo finito, la media de una función de su resultado sobre tablas uniformes coincide con la evaluación que sortea solo respuestas nuevas y memoriza las repetidas. Se conserva la ley conjunta de resultado y transcripción completa; el valor inicial en direcciones no vistas es inmaterial.",
        "limites": ["La igualdad incluye excepciones y no atribuye uniformidad después de condicionar a SinBad, aceptación o un candidato elegido a posteriori."]},
    "ROM/SoporteFinito": {
        "grupos": ["M35", "M39", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se deriva del programa de bytes el soporte de todas sus ramas adaptativas. Restringir a un universo que lo contenga conserva resultado y registro. La ley del resultado es la del árbol con memoria y no depende de ampliar el universo finito.",
        "limites": ["El soporte es un objeto matemático finito, sin cota práctica de construcción. No se define una distribución uniforme sobre todas las funciones del dominio infinito de bytes."]},
    "ROM/LeyMuestreoPrograma": {
        "grupos": ["M35", "M39", "M41"], "secciones": ["6.7.4"],
        "verificado": "La tabla del plan crece por prefijos incluso si hay excepciones. Para cualquier observable del resultado, el mismo plan ROM de respuestas frescas tiene exactamente la ley de una función uniforme en el soporte del programa. Las repeticiones guardan su valor sin gastar respuesta fresca.",
        "limites": ["Conserva altura(programa)<=S. No deduce por sí solo S=Q+V_T del ejecutable ni verifica costes de memoria o CPU."]},
    "ROM/ProgramaObservado": {
        "grupos": ["M35", "M39", "M41"], "secciones": ["6.7.4"],
        "verificado": "Instrumentar el programa para devolver resultado y transcripción conserva consultas, altura, soporte y el propio plan de muestreo. Se obtiene igualdad exacta de la ley conjunta de resultado y registro del plan original con el ROM uniforme finito.",
        "limites": ["La igualdad de leyes no prueba que los eventos de solidez del manuscrito estén correctamente incluidos ni que los índices del selector condicionado sean uniformes."]},
    "ROM/PrefijosGlobales": {
        "grupos": ["M35", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "El evento de igualdad de prefijos efectivos es exactamente el cilindro de sus direcciones observadas. Se cuenta su masa como |Digest|^(-u), con u direcciones distintas; una respuesta nueva es uniforme tras ese pasado fijo y una repetida distinta es imposible.",
        "limites": ["La condición es un prefijo fijo del pasado, sin SinBad ni aceptación. La frescura de la dirección siguiente se mantiene como hipótesis explícita."]},
    "Verificador/LeyConjunta": {
        "grupos": ["M35", "M39", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se instancia la ley conjunta con el programa completo de propuesta adaptativa de bytes e intercalaciones arbitrarias. Resultado y transcripción del mismo muestreador tienen exactamente la ley de tablas uniformes en su soporte. Se prueba la masa de cada prefijo real y la respuesta fresca uniforme tras ese pasado.",
        "limites": ["No se ha transferido todavía la ley del selector uniforme ideal ni la cota de solidez integral. Se mantienen altura<=S, corte analítico R, diferencias del parser y refinamiento universal Rust pendientes."]},
}

OPEN = {
    "M35": "Ya se identifica exactamente la ley conjunta del programa adversario de bytes, su resultado y toda la transcripción con el plan de respuestas frescas y memoria, sin condicionar a SinBad. También se cuenta cada prefijo real y la respuesta nueva tras ese pasado. Falta acoplar las primeras exposiciones de retos e índices seleccionados con el selector uniforme ideal y transferir sus cotas, incluidos repeticiones, selección de candidatos y abandono, sin imponer independencia de ambas fases FRI ni uniformidad después de condicionar a ausencia de excepciones. El refinamiento universal Rust continúa abierto.",
    "M39": "El verificador matemático, lector, formas, canal y aperturas conservan su presupuesto V_T demostrado. La ley del mismo plan ROM queda identificada con la tabla uniforme finita, también para su registro completo. Falta refinamiento universal de serde/bincode, operaciones de máquina y ejecutable Rust; permanecen la diferencia de EOF y el corte analítico R. La hipótesis altura(programa)<=S del muestreo no se identifica automáticamente con Q+V_T.",
    "M40": "Construir los programas de los candidatos reales y sus conjuntos buenos con cotas antes de responder, además del trabajo/nonce y la carga global de inicios. La ley conjunta ya permite contar prefijos efectivos y distinguir respuestas nuevas de repetidas, pero no demuestra valor<=rho para los candidatos ni convierte un nonce ya encontrado en una prueba independiente.",
    "M41": "La ley conjunta de aceptación y transcripción del programa adversario se identifica con el mismo muestreador ROM, sin excluir excepciones. La cota del fallo de reconstrucción causal se conserva. Falta probar e instanciar las inclusiones de los tres eventos de solidez, sesgos, selector y presupuestos bajo ese experimento común, enlazarlo universalmente con Rust y certificar el ejemplo numérico completo. La igualdad de leyes y la cota de reconstrucción no son una cota de aceptación falsa.",
}
