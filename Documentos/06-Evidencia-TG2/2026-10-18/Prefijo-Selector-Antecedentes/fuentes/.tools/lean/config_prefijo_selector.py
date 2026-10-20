"""Alcances del prefijo efectivo y la unión probabilística por perfil."""

MODELS = {
    "ROM/TablaObservada": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La tabla se reconstruye únicamente de los pares observados, conservando la primera respuesta de una entrada repetida. Se prueban las claves exactas, ausencia de duplicados y longitud igual al número de entradas distintas del pasado, sin consultar la continuación ni una función hash fuera de ese pasado.",
        "limites": ["Es una normalización determinista de la transcripción; no supone independencia de respuestas repetidas."]},
    "ROM/PrefijoPrograma": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "El estado tras n llamadas y la continuación residual se relacionan con take/drop de la traza real. La continuación se reconstruye usando respuestas anteriores. Su próxima entrada es la entrada n de la traza; su tabla coincide con la normalización del prefijo, incluso con repeticiones. La ejecución final, compatibilidad y ausencia de excepciones se conservan al reanudar, y existe el recorrido causal del prefijo.",
        "limites": ["n cuenta llamadas, incluidas las repetidas. La altura acota el programa finito y no se identifica con Q+V_T ni con el presupuesto de entradas distintas."]},
    "ROM/CorteLlamadas": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Toda entrada de un corte del programa aparece en su registro de llamadas. Se localiza su primera aparición y se construye un corte causal en ese mismo instante. La tabla anterior de cualquier corte de esa dirección es exactamente la tabla normalizada del prefijo bruto anterior a la primera llamada, aunque esa llamada proceda de una preconsulta del adversario.",
        "limites": ["La identificación se demuestra bajo SinBad y se usa como implicación determinista; no condiciona una ley uniforme a ese evento."]},
    "Canal/SemillaProxima": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La semilla es una función del programa residual reconstruido desde el pasado: lee los primeros 32 octetos de la próxima entrada. Se demuestra que si la próxima llamada es I(s), devuelve exactamente s. La activación comprueba la igualdad de toda la entrada con I(s), sin recibir el certificado futuro como argumento de la política.",
        "limites": ["Leer el prefijo de una entrada arbitraria no la declara un reto I ni un canal válido. La comprobación de la entrada completa pertenece al predicado de activación."]},
    "Verificador/PoliticasPrefijo": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "GT y GC se definen como políticas del prefijo bruto, con su tabla normalizada y la semilla de la próxima llamada. El registro de un candidato aceptado determina una primera activación cuya semilla y políticas coinciden exactamente con las del corte causal. El número de entradas del estado coincide con las entradas distintas del prefijo.",
        "limites": ["La lectura de un candidato arbitrario no caracteriza todavía todos los canales válidos ni proporciona una cota pequeña de los cardinales de GT/GC."]},
    "Verificador/CoberturaPrimeras": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La aceptación del verificador matemático bajo SinBad implica que existe una primera llamada I en la traza completa cuya muestra real tiene cardinal cuarenta y está contenida en GT intersección GC de ese prefijo bruto. La instancia con propuesta adaptativa de bytes e intercalaciones obtiene el certificado decodificado y su soporte de la propia ejecución, incluyendo primeras exposiciones deliberadas anteriores al verificador.",
        "limites": ["El perfil de la salida del certificado puede variar con H. La cobertura no permite aplicar una sola cota de perfil fijo a una unión de perfiles sin justificar su carga conjunta."]},
    "Canal/UnionPrefijo": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La activación y la omisión con las políticas reconstruidas coinciden con los eventos instrumentados del selector finito. Se aplica la unión de primeras exposiciones a esas políticas, con cota riesgo(R,e,40,g,m) por B entradas distintas, para un perfil fijo y cotas g/m/B explícitas en todas las activaciones.",
        "limites": ["g limita GT intersección GC en todas las activaciones del experimento, no solo después de aceptar o bajo SinBad. Todavía no se demuestra una cota pequeña de g para candidatos falsos ni un filtro causal que la justifique."]},
    "Verificador/CotaAceptacion": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "En un solo experimento uniforme de funciones sobre el universo finito del adversario, la aceptación con perfil k y SinBad se cubre por la unión de primeras exposiciones. Con cotas explícitas g/m/B de todas las activaciones se obtiene Pr(aceptación de perfil k y SinBad) <= riesgo(R,k+2,40,g,m)*B y, sin SinBad en el evento, Pr(aceptación de perfil k) <= Pr(no SinBad)+riesgo*B. El horizonte se deriva de la altura finita del propio programa.",
        "limites": ["La cota conserva como hipótesis g/m/B para todas las activaciones; podría ser vacua y no constituye solidez global ni prueba de que g sea pequeño. El perfil k está fijado antes del experimento. Faltan filtro de candidatos falsos, unión de perfiles y reinicios, cotas FRI y de trabajo, cota de las excepciones, presupuestos integrales y refinamiento universal Rust. SinBad se elimina aditivamente, sin condicionar la distribución a él."]},
}

OPEN = {
    "M35": "Ya se conecta el corte antes del primer I con el prefijo bruto de llamadas y se definen desde ese pasado la semilla y GT/GC. La aceptación queda cubierta por una primera exposición real, incluyendo preconsultas deliberadas. Hay una cota por perfil fijo bajo hipótesis g/m/B para todas las activaciones y un término aditivo Pr(no SinBad). Falta derivar cotas pequeñas y aplicables para candidatos falsos, un filtro causal de canal válido, unión de perfiles, cotas FRI y trabajo, excepciones y presupuestos integrales y refinamiento universal Rust.",
    "M36": "El programa adaptativo y sus intercalaciones ya proporcionan la primera llamada bruta que cubre el selector aceptado; la tabla del corte y las políticas coinciden con las del prefijo. Se aplica la unión por perfil fijo y B entradas distintas, usando la altura finita solo como horizonte. Faltan presupuestos derivados, adaptador integral de perfiles, rondas y reinicios y revisión independiente. El autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T.",
    "M39": "La aceptación matemática del certificado decodificado ya se conecta con una primera exposición de las políticas del prefijo, y con una cota por perfil fijo bajo hipótesis g/m/B y una excepción aditiva. Falta refinamiento universal de serde/bincode, operaciones de máquina y Rust y presupuestos globales. Permanecen EOF estricto y corte analítico R.",
    "M40": "Se completó el puente del corte al prefijo bruto: las políticas no reciben el certificado futuro y cubren la muestra real aceptada en su primera I. La unión probabilística ya se aplica por perfil fijo bajo g/m/B explícitos para todas las activaciones. Falta justificar cotas pequeñas para candidatos falsos y canales válidos, valor<=rho y su filtro causal, factor de trabajo, presupuesto común de perfiles y reinicios y composición global. No se trata la preconsulta deliberada como un error de cumpleaños.",
    "M41": "La cobertura de la aceptación ya llega a la unión probabilística de primeras exposiciones en un solo experimento finito por perfil fijo. Bajo cotas g/m/B de todas las activaciones, se obtiene Pr(aceptación y SinBad)<=riesgo*B y Pr(aceptación)<=Pr(no SinBad)+riesgo*B. Falta derivar las hipótesis para candidatos falsos y canales válidos, reunir perfiles y reinicios, cotas de todas las rondas FRI y trabajo, cota de excepciones y presupuestos, refinamiento universal Rust y ejemplo numérico integral. No se afirma solidez global ni que g o Pr(preconsulta) sean pequeños.",
}
