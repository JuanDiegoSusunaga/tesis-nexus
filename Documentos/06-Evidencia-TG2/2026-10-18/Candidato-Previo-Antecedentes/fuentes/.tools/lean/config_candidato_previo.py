"""Alcances de la recuperación del canal antes de la primera consulta I."""

MODELS = {
    "ROM/TablaInversa": {
        "grupos": ["M35", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La búsqueda inversa usa solo pares almacenados y devuelve una entrada con la respuesta solicitada. Bajo compatibilidad y ausencia de colisiones en las entradas conocidas, recupera exactamente la preimagen registrada sin consultar H fuera de la tabla.",
        "limites": ["La unicidad es local a las entradas registradas. No se postula inyectividad global del hash ni separación global entre Merkle y canal."]},
    "ROM/PrefijoCorte": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La tabla anterior a una primera consulta es el prefijo exacto de entradas nuevas del registro final. Las entradas cuya primera posición es menor y las dependencias por ventanas se transportan a esa tabla previa, aunque las llamadas posteriores sean repeticiones.",
        "limites": ["La posición cuenta respuestas nuevas y no se identifica con el número bruto de llamadas. El uso de ausencia de excepciones es determinista, sin condicionar una distribución futura."]},
    "Canal/Trayecto": {
        "grupos": ["M35", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se modela una cadena desde una entrada corta y sucesivas entradas cuyo prefijo es el estado anterior. Un extractor de tabla y semilla recupera exactamente la cadena en orden inverso con combustible suficiente; un mismo pasado y semilla determinan el mismo camino incluso para dos oráculos compatibles distintos.",
        "limites": ["La cadena es de bytes. Interpretar los roles y parámetros del certificado y construir GT/GC siguen siendo obligaciones separadas."]},
    "Canal/TrayectoTG2": {
        "grupos": ["M35", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "El prefijo efectivo completo del canal, sus tres alfas, las dos fases FRI y la absorción del nonce forman una cadena recuperable. Tiene 12+2*(|rt|+|rc|) entradas y a lo sumo 130 para |rt|=k, |rc|=k+1 y k<=29. La semilla es la respuesta a absorber el nonce; el digest de trabajo queda separado.",
        "limites": ["El límite 130 es combustible del extractor de datos, no el corte R del selector ni un presupuesto total del adversario. No reconstruye las aperturas posteriores del certificado ni refina universalmente Rust."]},
    "Canal/ReconstruccionSelector": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Las dependencias de la cadena sitúan todas sus consultas antes del primer I de su semilla. El extractor de tabla con 130 pasos devuelve la cadena completa del canal en ese corte. Toda raíz absorbida en ella está marcada antes de la primera respuesta I y su vector Merkle coincide con el del registro final.",
        "limites": ["Se exige el recorrido sin excepciones y el soporte efectivo de la cadena; la siguiente instancia obtiene ese soporte desde la aceptación matemática. Las igualdades bajo SinBad no afirman una ley uniforme condicionada a ese evento."]},
    "Canal/SoporteCandidato": {
        "grupos": ["M35", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Una aceptación del canal ejecutado implica trabajo válido y produce la pertenencia efectiva de toda la cadena del candidato y de su primera entrada I al registro de consultas. No recibe ese soporte como hipótesis externa ni sustituye la semilla por el digest de trabajo.",
        "limites": ["El hecho de trabajo válido no proporciona aún el factor probabilístico de trabajo para candidatos adaptativos. R sigue siendo analítico."]},
    "Verificador/CandidatoPrevio": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La aceptación del verificador completo proporciona un registro previo con corte de primera consulta I, cadena de bytes disponible y recuperada y todos los vectores de raíces congelados. Se construye para propuesta adaptativa e intercalaciones del adversario sobre la tabla común, bajo ausencia de excepciones (SinBad). Dos candidatos registrados con la misma semilla tienen la misma tabla anterior y la misma cadena de bytes, incluso si sus perfiles o certificados se presentan como distintos.",
        "limites": ["Se recupera la transcripción de bytes del canal, no todo el certificado. Falta demostrar su decodificación semántica para definir semilla/GT/GC como políticas del prefijo y enlazarlas a la unión probabilística de primeras exposiciones. Permanecen las cotas g/m/B, retos FRI, factor de trabajo, inclusiones de aceptación falsa, composición integral y refinamiento Rust."]},
}

OPEN = {
    "M35": "Ya se obtiene desde la aceptación matemática, con propuesta adaptativa e intercalaciones, una cadena de bytes del canal recuperable antes del primer I y vectores de todas sus raíces estables. Misma semilla implica misma cadena registrada. Falta decodificar semánticamente ese candidato para definir GT/GC desde el prefijo y demostrar conservación en la unión de primeras exposiciones, derivar g/m/B, enlazar todas las rondas FRI y los eventos de solidez y el refinamiento universal Rust. Las inclusiones bajo SinBad no condicionan la ley probabilística a SinBad.",
    "M36": "El verificador con adversario ya produce el candidato de bytes en su corte de primera exposición y sus vectores congelados, además de la ley exacta de continuación y carga por direcciones distintas. Falta el adaptador integral de rondas y reinicios y la revisión independiente; el autor declaró que no hay dictamen. No se identifica B con Q ni altura con Q+V_T.",
    "M39": "La aceptación del canal y del verificador matemático ya produce el soporte efectivo de la cadena y del primer I; el extractor previo recupera los bytes del canal y congela raíces bajo ausencia de excepciones. Falta decodificación semántica del candidato para las políticas de selección, refinamiento universal de serde/bincode, operaciones de máquina y Rust y presupuestos globales. Permanecen EOF estricto y corte analítico R.",
    "M40": "Ya se construye el registro causal de bytes del candidato aceptado en el programa con propuesta adaptativa e intercalaciones: toda su cadena existe antes del primer I, se recupera con 130 pasos y sus raíces tienen vectores estables. Dos candidatos registrados con igual semilla comparten la misma cadena de bytes. Falta el puente de esa representación a las políticas semánticas de semilla y GT/GC, justificar sus cotas g/m/B y el valor<=rho de los candidatos completos, integrar el factor probabilístico de trabajo y la carga común de reinicios. La validez del trabajo ya se deriva de la aceptación; su digest no es la semilla y un nonce encontrado no es un ensayo independiente.",
    "M41": "El soporte efectivo de la aceptación matemática produce ahora el candidato de bytes y los vectores de raíces antes de la primera consulta del selector, sin exigir inicialmente ese soporte. Falta definir desde ese registro los conjuntos buenos semánticos y demostrar la cobertura de toda aceptación falsa por la unión registrada de primeras exposiciones, enlazar las rondas FRI, el factor de trabajo, excepciones y presupuestos bajo un solo experimento, refinamiento universal Rust y el ejemplo numérico integral. No se ha demostrado solidez global ni una cota pequeña de Pr(preconsulta).",
}
