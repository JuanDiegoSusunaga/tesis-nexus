"""Alcance de activaciones causales y primeras exposiciones del selector."""

MODELS = {
    "ROM/ActivacionPrefijo": {
        "grupos": ["M35", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La activación de un candidato depende solo del prefijo efectivo. La cota condicionada en las fibras activas se transfiere a una media global ponderada; con riesgo uniforme rho se obtiene rho por la probabilidad de activación, sin cobrar las fibras inactivas.",
        "limites": ["La decisión debe preceder a la respuesta; no admite activar retrospectivamente usando el éxito futuro."]},
    "ROM/PrimeraExposicion": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "El programa residual se reconstruye exclusivamente del pasado. Activar exige que la próxima consulta sea la dirección del candidato y que aún no esté registrada. Se prueba que el índice es su primera aparición, que no hay doble carga y que toda dirección consultada tiene una primera exposición efectiva.",
        "limites": ["Estas identidades de transcripciones no presuponen ausencia de colisiones ni uniformidad tras SinBad; por sí solas no construyen los conjuntos buenos FRI."]},
    "ROM/ConteoActivaciones": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La unión finita de eventos activados se acota por rho multiplicado por el número esperado de activaciones; un presupuesto B da rho*B. Se permite cualquier solapamiento entre candidatos y se formaliza la transferencia desde un evento final cubierto por la unión.",
        "limites": ["No requiere independencia de candidatos. La cobertura del evento de aceptación falsa completo y la cota local rho de cada candidato real deben demostrarse aparte."]},
    "ROM/CargaPrimeras": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Candidatos dependientes del índice y del pasado se inyectan en direcciones distintas de la traza por su primera posición. Su número se acota por direcciones distintas, consultas totales y horizonte. Toda dirección presente en un prefijo se remonta a una activación estrictamente anterior.",
        "limites": ["El presupuesto de direcciones debe corresponder al programa común que incluya al adversario y al verificador. No se identifica automáticamente con Q ni Q+V_T."]},
    "ROM/SelectorPrimeras": {
        "grupos": ["M35", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se aplica el acoplamiento del selector antes de su primera consulta y se obtiene rho=choose(g,q)/choose(2^e,q)+tau+delta. La unión de candidatos registrados se acota por rho*E[inicios] y por rho*B para B direcciones distintas. Una preconsulta deliberada con omisión se remonta a su primera exposición si allí se registran la misma semilla y conjuntos que contienen el conjunto final. Para R=512 y k=4..12, tau<2^(-300).",
        "limites": ["La unión registrada no lleva un sumando separado Pr(preconsulta), pero no se demuestra que esa probabilidad sea pequeña. La cobertura requiere registro causal y conservación de semilla y conjuntos en la primera exposición. Falta construir ese registro para todos los candidatos/nonces reales, derivar g/m/B, las rondas FRI, el factor de trabajo y las inclusiones de solidez integral."]},
    "Canal/PrimerasExposiciones": {
        "grupos": ["M35", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se identifica la activación del árbol con la próxima entrada I de bytes reales y su ausencia del prefijo. El número de activaciones se carga a las direcciones distintas del programa arbitrario de bytes. La unión de éxitos del selector matemático instrumentado, activados en primeras exposiciones, se acota por rho*B con parámetros elegidos antes de cada respuesta.",
        "limites": ["El éxito instrumentado solo comprueba la muestra compartida de 40 índices contra GT/GC; no es aceptación del verificador completo. La cobertura de todos los candidatos finales, los conjuntos buenos causales, presupuestos y refinamiento universal Rust siguen pendientes. R es analítico."]},
}

OPEN = {
    "M35": "Se cuenta ya la unión de candidatos registrados en su primera exposición: rho*E[inicios], acotada por rho*B para B direcciones distintas; rho contiene hipergeométrica, tau y delta. Una preconsulta deliberada puede remitirse al primer intento si conserva la semilla y conjuntos allí congelados; no se afirma que Pr(preconsulta) sea pequeña. Falta construir el registro causal que cubra todos los candidatos finales reales, derivar GT/GC y g/m/B, enlazar todas las rondas FRI y sus eventos de solidez, y el refinamiento universal Rust.",
    "M36": "Se localizan primeras exposiciones en la traza y se cargan sus inicios a direcciones distintas, conservando la ley exacta de continuación del verificador. Falta el adaptador integral de rondas y reinicios y la revisión independiente; el autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T.",
    "M39": "El programa arbitrario de bytes tiene un registro de primeras consultas I y una cota para la unión de éxitos del selector instrumentado. Falta la cobertura de candidatos del verificador completo, refinamiento universal de serde/bincode, operaciones de máquina y Rust, y la identificación de presupuestos globales. Permanecen EOF estricto y corte analítico R.",
    "M40": "La carga por primera exposición ya evita cobrar repeticiones y permite unir candidatos con una sola tabla, sin independencia. Se obtiene rho por el número esperado de inicios y una cota por direcciones distintas. Falta construir el registro causal de todos los candidatos/nonces reales, justificar la conservación de semilla y conjuntos buenos, derivar g/m/B y valor<=rho antes de responder, e incorporar el factor de trabajo y las intercalaciones del experimento común. El digest de trabajo no es la semilla del selector; un nonce encontrado no se trata como ensayo independiente.",
    "M41": "La unión registrada de primeras exposiciones y su cota se enlazan a bytes reales. Falta demostrar que contiene toda aceptación falsa del verificador, construir los conjuntos buenos causales para las rondas FRI, integrar el factor de trabajo, presupuestos y excepciones bajo un solo experimento, refinamiento universal Rust y el ejemplo numérico integral. No se ha demostrado solidez global ni una cota pequeña para Pr(preconsulta).",
}
