"""Alcances de la pertenencia de la muestra efectiva a GT y GC."""

MODELS = {
    "ROM/ValoresFinales": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La ausencia de colisiones en la tabla final se deriva del recorrido efectivo SinBad. Toda consulta del programa está guardada y una apertura válida y registrada determina exactamente el valor del vector indexado calculado solo desde esa tabla, sin usar H fuera de ella.",
        "limites": ["SinBad se usa en una implicación determinista. No se condiciona una distribución uniforme a ese evento ni se reemplaza su pérdida probabilística."]},
    "Canal/CapasIndexadas": {
        "grupos": ["M35", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Una representación recursiva de las capas conserva su altura al retirar la cabeza. Se prueba su igualdad con la representación zipIdx de la vista y la conservación de las longitudes de ambas representaciones.",
        "limites": ["La altura se mantiene explícita; no se identifica con un presupuesto de consultas del adversario."]},
    "FRI/ControlesValores": {
        "grupos": ["M35", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La compatibilidad del acarreo, el plegado y el estado siguiente dependen únicamente de izquierda y derecha. Desde las condiciones del programa FRI aceptado y sus valores extraídos se demuestran los controles sobre todos los vectores de capas hasta la constante final. Se recupera también la primera pareja efectiva cuando la fase contiene capas.",
        "limites": ["Es una transferencia determinista del recorrido aceptado. Las cotas probabilísticas de todas las rondas y el refinamiento universal Rust siguen separados."]},
    "Verificador/ValoresConsulta": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La aceptación de una consulta y su soporte efectivo en el programa global producen los valores extraídos de sus seis posiciones AIR y todas las aperturas FRI. Se conserva cada índice y cada raíz, sin recibir una lista adicional de autenticaciones como premisa.",
        "limites": ["La hipótesis de inclusión de consultas se elimina en la instancia del verificador completo con adversario. No afirma canonicidad ni autenticación de bytes ajenos al lector matemático."]},
    "Verificador/RetosVista": {
        "grupos": ["M35", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Las longitudes del perfil aceptado separan exactamente los tres alfas y los segmentos de betas de traza y composición de la vista final. Sus valores son los entregados realmente por el canal ejecutado, sin elegir retos adicionales.",
        "limites": ["La igualdad de segmentos no establece independencia condicionada a aceptación o SinBad."]},
    "Verificador/ConsultaBuena": {
        "grupos": ["M35", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se transportan los enlaces efectivos de traza y composición a los valores extraídos. Una consulta aceptada con los retos reales, forma admitida y soporte de sus valores satisface simultáneamente pruebaTraza y pruebaComposicion: canonicidad de las seis posiciones, enlaces, plegados, acarreo y constantes finales de todas las capas.",
        "limites": ["Los dos controles se cumplen para una misma consulta. No se multiplican probabilidades de fases ni se deduce todavía una cota del cardinal de sus conjuntos buenos."]},
    "Canal/MuestraEfectiva": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La lista ordenada de índices se define como función del selector ejecutado, conservando la parada al completar cuarenta distintos. Se prueban resultado, ausencia de duplicados, soporte de su continuación y equivalencia exacta de su conjunto con la selección sobre la cinta real. Se transporta el tamaño 4*2^k a 2^(k+2) sin cambiar índices.",
        "limites": ["La cinta puede desplegarse matemáticamente más allá de la parada; esa cola no se atribuye al registro real. R continúa siendo un corte analítico."]},
    "Verificador/MuestraBuena": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La aceptación completa produce un testigo cuya muestra es exactamente la lista efectiva del selector. Sus cuarenta índices distintos pertenecen a GT intersección GC calculados antes del primer I. Se identifica esa muestra con la salida de la cinta real usada en el acoplamiento ROM y se obtiene la inclusión determinista aceptación implica muestra completa y omisión conjunta. La instancia con propuesta adaptativa e intercalaciones elimina la hipótesis externa de soporte del verificador.",
        "limites": ["La cobertura se obtiene bajo SinBad y en el corte de entradas nuevas. Falta convertir ese corte al prefijo bruto de llamadas, registrar sus políticas en la unión de primeras exposiciones, justificar g/m/B y las cotas FRI y de trabajo y componer excepciones. No es una cota de solidez global ni un refinamiento universal Rust."]},
}

OPEN = {
    "M35": "Ya se demuestra que todas las consultas de la muestra efectiva aceptada pertenecen simultáneamente a GT/GC definidos antes del primer I. La muestra coincide con la salida real de la cinta usada en el acoplamiento, incluso con adversario adaptativo e intercalaciones. Falta trasladar el corte de entradas nuevas al prefijo bruto de llamadas y a la unión de primeras exposiciones, derivar g/m/B para candidatos falsos, integrar las cotas de todas las rondas FRI, el trabajo y las excepciones y refinar universalmente Rust. La inclusión bajo SinBad no condiciona la ley uniforme a SinBad.",
    "M36": "La muestra ordenada efectiva ya tiene cuarenta índices distintos y soporte completo, y su aceptación implica pertenencia a GT/GC en el corte previo y coincide con la cinta real. Falta el puente al prefijo bruto y el adaptador integral de rondas y reinicios, sus presupuestos y revisión independiente. El autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T.",
    "M39": "El verificador matemático ya conecta sus aperturas AIR/FRI, los retos efectivos y la muestra ordenada real con los controles semánticos de GT/GC. Falta refinamiento universal de serde/bincode, operaciones de máquina y Rust y presupuestos globales. Permanecen EOF estricto y corte analítico R.",
    "M40": "El candidato aceptado ya produce exactamente la muestra real de cuarenta índices distintos y todos pertenecen a GT/GC calculados antes del primer I. La muestra se identifica con la salida del selector sobre la cinta real; la cobertura vale con propuesta adaptativa e intercalaciones, sin hipótesis externa de soporte. Falta registrar estas políticas en cada primera llamada bruta y aplicar la unión probabilística, justificar g/m/B y valor<=rho de candidatos falsos, el factor de trabajo y la carga común de reinicios. La inclusión bajo SinBad es determinista.",
    "M41": "Ya se demuestra aceptación implica muestra efectiva completa y pertenencia conjunta a GT/GC anteriores al primer I, con equivalencia exacta a la salida de la cinta real y soporte desde el adversario. Falta trasladar esta cobertura al prefijo bruto y a la unión de primeras exposiciones, derivar cotas de cardinal para candidatos falsos y todas las rondas FRI, factor de trabajo, composición de excepciones y presupuestos bajo un solo experimento, refinamiento universal Rust y ejemplo numérico integral. No se ha demostrado solidez global ni una cota pequeña de Pr(preconsulta).",
}
