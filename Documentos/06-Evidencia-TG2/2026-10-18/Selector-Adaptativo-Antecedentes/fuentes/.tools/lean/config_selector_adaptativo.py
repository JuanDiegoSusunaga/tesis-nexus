"""Alcances de continuación causal y selección dependiente del pasado."""

MODELS = {
    "ROM/ContinuacionPrefijo": {
        "grupos": ["M35", "M36", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se define el árbol residual tras n consultas, se conserva su resultado y se identifica su registro con la cola de la transcripción. El árbol residual es idéntico en todas las tablas con el mismo prefijo. La ley conjunta de resultado y cola es la evaluación con memoria iniciada en la tabla observada; cualquier observable del oráculo y del pasado se transporta a completaciones uniformes.",
        "limites": ["Se condiciona únicamente a un prefijo efectivo fijo, sin SinBad, aceptación ni selección de un futuro favorable."]},
    "ROM/ParticionObservada": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La media total es la suma de medias de fibras por sus masas exactas. Se transfieren cotas locales a una cota global y se añade explícitamente la probabilidad de una observación desfavorable, incluidas fibras vacías o de distinto cardinal.",
        "limites": ["No se postula equiprobabilidad de los pasados ni se elimina el término excepcional. La correspondencia de un evento concreto con sus fibras sigue siendo necesaria."]},
    "ROM/ObservacionesPrefijo": {
        "grupos": ["M35", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Los prefijos realizables de un árbol forman una partición finita explícita. Sus fibras son exactamente tablas que producen ese pasado, con masa |Digest|^(-u) para u direcciones distintas. Se prueba esperanza total y transferencia desde cotas condicionadas a cada pasado, conservando la probabilidad de los pasados malos.",
        "limites": ["La masa depende de direcciones distintas, no de la longitud bruta. No hay condicionamiento a un evento futuro ni selección posterior a la cadena analizada."]},
    "ROM/SelectorPrefijo": {
        "grupos": ["M35", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La semilla y GT/GC pueden ser funciones arbitrarias del prefijo observado. En cada fibra se congelan esos parámetros antes de aplicar el acoplamiento. Se transfieren omisión compartida y omisión o abandono, con la misma delta y primera dirección no preconsultada.",
        "limites": ["Solo depende del pasado fijado; no permite elegir conjuntos después de ver las respuestas de la cadena. Ambos FRI conservan una única muestra compartida."]},
    "ROM/SelectorAdaptativo": {
        "grupos": ["M35", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se suman las cotas del selector sobre todos los pasados de una exploración adaptativa. La cota global de omisión o abandono es hipergeométrica+tau+delta+Pr(primera dirección preconsultada), bajo cotas g y m para el conjunto bueno compartido y las direcciones observadas. Para R=512 y k=4..12, tau<2^(-300). La frescura deja de ser una premisa global: su fallo aparece como un evento explícito.",
        "limites": ["No se demuestra que Pr(preconsulta) sea pequeña. Faltan su carga al experimento completo de candidatos/nonces, las rondas FRI y las inclusiones de aceptación falsa. No afirma uniformidad condicionada a SinBad, completar o aceptación."]},
    "Canal/SelectorAdaptativo": {
        "grupos": ["M35", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Un programa anterior de bytes arbitrarios determina el prefijo de exploración. Se construye un universo finito con su soporte y todas las entradas I, se preservan prefijo y cardinal de direcciones, y se identifica la preconsulta con pertenencia de los bytes reales al pasado. Se enlaza la cota global al programa de selección de 40 índices con semilla y conjuntos elegidos del prefijo.",
        "limites": ["El programa de selección instrumentado comprueba pertenencia a GT y GC; su aceptación no es la del verificador completo. Pr(preconsulta), las cotas g/m de candidatos concretos, refinamiento Rust y presupuestos globales siguen pendientes. R permanece analítico."]},
    "Verificador/ContinuacionCausal": {
        "grupos": ["M35", "M36", "M39", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se instancia la ley de continuación con el verificador completo de bytes, propuesta adaptativa e intercalaciones. Tras un prefijo efectivo, resultado y cola del registro conservan exactamente la ley del árbol residual con memoria. Las consultas restantes se acotan por altura(programa)-n.",
        "limites": ["La cota de altura no se identifica automáticamente con Q+V_T y no demuestra solidez integral ni refinamiento universal Rust. La ley incluye excepciones y no atribuye independencia a las fases FRI."]},
}

OPEN = {
    "M35": "La continuación tras un prefijo tiene ya su ley exacta. La semilla del selector y los conjuntos buenos pueden depender de una exploración adaptativa anterior; se obtiene una cota sobre todos los pasados, con una única muestra compartida y un término explícito Pr(primera dirección preconsultada). Falta acotar ese término para los candidatos reales y cargarlo a las excepciones del experimento común, derivar los conjuntos buenos causales y enlazar las primeras exposiciones y todas las rondas FRI. También permanece el refinamiento universal Rust. No se condiciona a SinBad, completar, aceptación ni a un futuro elegido favorablemente.",
    "M36": "El mismo verificador con propuesta adaptativa e intercalaciones ya tiene ley exacta de resultado y continuación tras un prefijo observado, y presupuesto residual altura(programa)-n. Falta el adaptador integral de rondas y reinicios y la revisión independiente; el autor declaró que no hay dictamen. No se identifica automáticamente B con consultas hash Q ni altura con Q+V_T.",
    "M39": "El verificador matemático conserva su presupuesto y ahora su ley exacta tras cualquier prefijo efectivo. El selector de bytes admite decisiones dependientes del pasado y contabiliza explícitamente la primera dirección preconsultada. Falta refinamiento universal de serde/bincode, operaciones de máquina y ejecutable Rust; permanecen EOF estricto y corte analítico R. Los límites de altura no se identifican automáticamente con Q+V_T.",
    "M40": "El selector ya admite semilla y conjuntos buenos elegidos del prefijo de una exploración adaptativa y produce una cota global con Pr(preconsulta) explícita. Falta construir los candidatos/nonces reales, fijar sus cotas g/m y valor<=rho antes de responder, acotar y cargar las preconsultas y la carga global de inicios, e incorporar el factor de trabajo y las intercalaciones del experimento común. Un nonce ya encontrado no se convierte en una prueba independiente.",
    "M41": "Se dispone de ley de continuación del verificador completo y de cota del selector sobre todos los pasados, con omisión compartida, abandono y Pr(preconsulta) explícita. Falta acotar esta probabilidad y probar las inclusiones de todos los eventos de solidez y las rondas FRI bajo el mismo experimento de candidatos/nonces, componer los presupuestos, enlazar universalmente Rust y certificar el ejemplo numérico integral. No se ha demostrado una cota de aceptación falsa global.",
}
