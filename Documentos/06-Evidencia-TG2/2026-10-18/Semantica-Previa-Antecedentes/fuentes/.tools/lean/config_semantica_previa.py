"""Alcances de la lectura semántica y las políticas anteriores al primer I."""

MODELS = {
    "Canal/LecturaAbsorcion": {
        "grupos": ["M35", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "El lector de absorciones comprueba etiquetas, datos canónicos y recodificación completa. Recupera cada absorción codificada y todo resultado positivo corresponde a una entrada exacta. Inicio y retos cortos no se interpretan como absorciones.",
        "limites": ["La lectura se usa dentro de una cadena reconstruida; no postula separación global de dominios Merkle/canal ni equivalencia universal con Rust."]},
    "Canal/LecturaCadena": {
        "grupos": ["M35", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La interpretación ordenada recupera perfil y enunciado en bytes, raíz base, ambas listas FRI, constantes finales y un nonce. Se prueba la lectura completa de la cadena efectiva del canal, descartando los retos E al extraer las absorciones.",
        "limites": ["El éxito del lector no es una caracterización de todas las cadenas válidas: se demuestra su corrección sobre la cadena efectiva y la canonicidad de cada absorción leída. No recupera aperturas futuras."]},
    "Canal/ParametrosRecuperados": {
        "grupos": ["M35", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Los codecs recuperan los seis campos del perfil y las tres cantidades del enunciado bajo sus anchos explícitos. Se validan versión, tamaños y cuarenta consultas; el exponente se obtiene de las filas mediante log2. La cadena del perfil con k<=29 y bits<u32 devuelve exactamente sus parámetros, raíces, constantes y nonce.",
        "limites": ["Los naturales y codecs son matemáticos. No demuestra refinamiento universal del ejecutable, serde/bincode o sus opciones de EOF."]},
    "Canal/RetosRecuperados": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Las entradas de 33 bytes de la cadena efectiva son sus retos E. Sus respuestas producen, en orden y conservando repeticiones, los tres alfas y los betas de ambas fases. Una tabla que contiene la cadena obtiene la misma lista de retos, cualquiera que sea su valor de completación externa.",
        "limites": ["La conservación es determinista; no afirma independencia de los retos condicionada a aceptación o a SinBad."]},
    "Canal/VistaSemantica": {
        "grupos": ["M35", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se construye una vista solo desde tabla, semilla y digest de completación: parámetros interpretados, retos y vectores indexados de la raíz base y todas las capas. Se demuestra su conservación a partir de igualdad de retos y vectores, con reducción explícita de índices al tamaño del árbol.",
        "limites": ["La vista puede rechazar la interpretación con none. No incluye testigos Merkle posteriores ni el factor probabilístico de trabajo."]},
    "Verificador/SemanticaPrevia": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "El registro efectivo del candidato y la forma aceptada permiten interpretar exactamente k, bits, inicio, salida, raíces base y FRI, constantes finales y nonce antes del primer I. Se recuperan los alfas y betas reales. Dos candidatos registrados con la misma semilla tienen los mismos datos semánticos, aunque se presenten inicialmente con perfiles distintos.",
        "limites": ["No se identifican los certificados completos: sus aperturas pueden diferir. La instancia de adversario y ausencia de excepciones procede del registro anterior; no se condiciona la ley uniforme a ese evento."]},
    "Verificador/VistaPrevia": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se demuestra que cada raíz de la vista procede de una absorción real, incluidos todos los elementos de ambas listas. La vista leída antes del primer I coincide exactamente con parámetros, retos y oráculos extraídos del registro final. Dos candidatos registrados con igual semilla tienen la misma vista final.",
        "limites": ["Es una igualdad determinista bajo las condiciones del registro causal. Falta transportar el corte de entradas nuevas al prefijo bruto de llamadas usado en la unión probabilística."]},
    "Verificador/ConjuntosPrevios": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "GT y GC quedan definidos desde tabla y semilla mediante valores extraídos, canonicidad base, enlaces de traza/composición, plegados y acarreo FRI hasta sus constantes finales. Son vacíos si falla la lectura. Se demuestra que las políticas anteriores al primer I coinciden con los conjuntos de la vista final; misma semilla produce las mismas políticas y se caracteriza la consulta compartida por su intersección.",
        "limites": ["Falta demostrar que todas las consultas aceptadas del verificador pertenecen a estos conjuntos, sus cotas g/m/B y el enlace efectivo a la unión de primeras exposiciones. No es todavía solidez global, factor de trabajo ni refinamiento universal Rust."]},
}

OPEN = {
    "M35": "Ya se interpreta el candidato recuperado y se construyen GT/GC desde la tabla anterior al primer I: parámetros, raíces, constantes, nonce, alfas/betas y todos los vectores coinciden con la vista final. Falta demostrar pertenencia de todas las consultas aceptadas a estos conjuntos, trasladar el corte de entradas nuevas al prefijo bruto de llamadas, aplicar la unión de primeras exposiciones, derivar g/m/B, enlazar las cotas de todas las rondas FRI y refinar universalmente Rust. Las igualdades bajo SinBad no condicionan la ley uniforme a SinBad.",
    "M36": "El registro efectivo ya interpreta los datos y retos reales del candidato y conserva GT/GC hasta el final, incluso ante una preconsulta deliberada. Falta el puente al prefijo bruto y el adaptador integral de rondas y reinicios, sus presupuestos y revisión independiente. El autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T.",
    "M39": "La cadena anterior al primer I ya se lee con absorciones canónicas, perfil, enunciado, raíces, constantes finales y nonce; el mismo registro conserva retos y vectores. Falta refinamiento universal de serde/bincode, operaciones de máquina y Rust, completar la correspondencia de los controles semánticos con la aceptación y los presupuestos globales. Permanecen EOF estricto y corte analítico R.",
    "M40": "El candidato aceptado ya tiene interpretación semántica y políticas GT/GC definidas solo desde su tabla anterior y semilla, con igualdad a la vista final. Misma semilla implica mismos parámetros, raíces, constantes, nonce y políticas. Falta registrar esas políticas en cada primera llamada bruta, probar pertenencia de todas las consultas aceptadas y sus cotas g/m/B y valor<=rho, integrar el factor probabilístico de trabajo y la carga común de reinicios. La validez del trabajo se deriva de aceptación; su digest no es la semilla.",
    "M41": "Ya existen GT/GC semánticos, leídos desde el candidato previo y conservados hasta la vista final, incluidos enlaces AIR/composición y acarreo FRI sobre valores extraídos. Falta demostrar que la aceptación implica pertenencia de todas las consultas, cubrir toda aceptación falsa con la unión de primeras exposiciones, enlazar cotas FRI, factor de trabajo, excepciones y presupuestos bajo un solo experimento, refinamiento universal Rust y ejemplo numérico integral. No se ha demostrado solidez global ni una cota pequeña de Pr(preconsulta).",
}
