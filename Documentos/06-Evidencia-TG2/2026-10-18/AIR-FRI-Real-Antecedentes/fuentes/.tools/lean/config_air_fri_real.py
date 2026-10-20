"""Alcances de la transferencia AIR/FRI concreta y del presupuesto global."""

GROUPS = ["M35", "M36", "M39", "M40", "M41"]


def model(text, limits, groups=None):
    return {"grupos": groups or GROUPS, "secciones": ["6.7.4"],
        "verificado": text, "limites": limits}


MODELS = {
    "Canal/VectoresCampo": model(
        "La extensión de un vector indexado a los dominios Goldilocks recupera cada valor y es cero fuera del dominio. Se identifica con el oráculo Merkle extraído de la tabla. La imagen de una muestra conserva exactamente su cardinal y pertenece al dominio cuadrado; se identifican las seis posiciones AIR con los índices algebraicos de ambas mitades.",
        ["La extensión es matemática y determinista. No demuestra operaciones de máquina ni uniformidad de retos."]),
    "FRI/ControlesCampo": model(
        "Se derivan la igualdad de longitudes, el valor del oráculo desde la compatibilidad del acarreo y la fórmula del plegado sobre el campo. Por inducción sobre las listas se extraen todas las ecuaciones FRI del recorrido concreto, incluida la compatibilidad con el siguiente vector o con la constante terminal, sin recibir esas ecuaciones como hipótesis.",
        ["El argumento usa naturales y funciones de campo. No impone una ley probabilística al contenido de la tabla."]),
    "FRI/ListaCampo": model(
        "Las listas de vectores se elevan a oráculos de las capas y se completan con la constante final. Los controles del acarreo implican la aceptación FRI de una pareja concreta y de toda una muestra de esas parejas, con los retos leídos de las mismas listas.",
        ["La aceptación derivada es la de la torre matemática; no es refinamiento universal del ejecutable Rust."]),
    "Canal/VistaCampo": model(
        "Se construye un PrefijoConsulta AIR/FRI con los vectores, retos y constantes de la vista anterior a I. La traza inicial coincide con el vector base. La forma y la lectura exacta se derivan para todo canal canónico admisible desde su propia tabla, sin suponerlas para el certificado futuro.",
        ["Las funciones del prefijo construido ignoran la historia de retos porque la vista ya está fijada antes de I. Esto no prueba que cada vector estuviera fijado antes de su propio E y no autoriza trasladar la ley del experimento ideal."]),
    "Verificador/ConsultaCampo": model(
        "Cada pareja que pertenece a GT y GC originales satisface AceptaCompartida del prefijo construido: ambas verificaciones FRI, los seis controles de campo base y el enlace local de composición. El enlace usa las posiciones reales, la inmersión Fp a Fp2 y la ausencia probada de polos en el dominio concreto. La misma muestra se comparte entre las dos fases.",
        ["Se transfiere la semántica matemática de los controles. No se supone independencia entre las fases ni se prueba aquí una ley causal de los E."]),
    "N06/CardinalCompartida": model(
        "Se demuestra la fórmula exacta de la probabilidad de una consulta unitaria y se usa la cota AIR/FRI compartida existente para deducir 8*cardinal<=7*(4*2^k) para todas las parejas aceptantes y cualquier subconjunto de ellas, cuando el prefijo es seguro.",
        ["La seguridad del prefijo es una condición determinista explícita; su probabilidad no se deduce del conteo."]),
    "Verificador/CardinalVista": model(
        "Se deriva para GT/GC originales, sin filtrarlos por cardinal, el límite floor(7*2^e/8) bajo PrefijoSeguro del canal concreto admisible. Si el exponente no coincide, los conjuntos están vacíos. Para un perfil k se identifica el umbral con 7*2^(k-1); los extremos son 56 y 14336 parejas buenas.",
        ["No se afirma el límite fuera del evento PrefijoSeguro. La probabilidad de su fallo sigue pendiente."]),
    "Verificador/ExcesoRondas": model(
        "Todo exceso del umbral algebraico en una primera I elegible implica una excepción de rondas del mismo canal canónico falso, reconstruido desde la tabla y los retos reales del prefijo. Se prueba la inclusión de eventos y de sus probabilidades incondicionales. La cota de aceptación falsa sustituye Pr(Exceso) por Pr(Rondas), con umbral ya derivado.",
        ["Pr(Rondas) todavía no está acotada. Es necesario demostrar la fijación de vectores antes de cada E y controlar las preconsultas deliberadas, los sesgos y el presupuesto común."]),
    "Verificador/PresupuestoGlobal": model(
        "Se prueba el coste máximo entre todos los perfiles admitidos y la cota uniforme del lector de bytes completo, incluyendo propuestas malformadas y rechazos. Del presupuesto Q de todas las consultas adversarias, incluidas propuesta e intercalaciones, se deriva el total de llamadas y de entradas distintas B=Q+V12(R). Se demuestra V12(R)=24383+R y, para R=512, B=Q+24895. La cota de aceptación falsa usa solo la hipótesis adversaria Q, sin recibir B como hipótesis separada.",
        ["Es el coste del modelo matemático con corte analítico R y EOF estricto. No identifica B con Q ni la altura del programa con Q+V. No integra aún una colección de verificaciones o reinicios que use un único presupuesto."]),
    "Verificador/RondasReales": model(
        "La excepción de cada vista concreta se clasifica exactamente: FRI de traza lejana, cancelación del resto AIR o FRI de composición lejana. Los conjuntos excepcionales FRI usan los mismos oráculos y betas del prefijo leído. La rama con candidato fuera del campo base no genera una excepción de este tipo.",
        ["La clasificación es algebraica, no una cota de probabilidad del experimento hash. La vista previa a I no equivale a una política causal anterior a cada E."]),
    "Verificador/CotaRondas": model(
        "Se integra para un perfil fijo la cota con Pr(no SinBad), Pr(Rondas), el umbral algebraico y B=Q+24895 para R=512, con pasado de a lo sumo Q+24894 entradas distintas. Se conservan la hipergeométrica, la cola 2^-300 y el error de acoplamiento. La hipergeométrica se acota por (7/8)^40 y esta cantidad por 1/200.",
        ["La cota puede ser vacua. Falta acotar las dos probabilidades excepcionales, integrar trabajo, selección de perfiles y reinicios, refinamiento Rust y ejemplo numérico completo. Ni 2^-300 ni 1/200 constituyen por sí solos solidez global."]),
}

OPEN = {
    "M35": "Ya se transfieren los controles GT/GC originales a la consulta compartida sobre el campo y se deriva su cardinal <=floor(7*2^e/8) bajo PrefijoSeguro del canal real. Todo exceso implica un fallo AIR/FRI explícito del mismo prefijo y Pr(Exceso)<=Pr(Rondas). Se deriva B del presupuesto Q adversario y del coste máximo del verificador. Falta acotar Pr(Rondas) con la fijación de cada vector antes de su E, las respuestas reales, sesgos y preconsultas, acotar excepciones ROM, integrar trabajo, perfiles y reinicios y refinar universalmente Rust.",
    "M36": "Se deriva B=Q+V12(R), con V12(R)=24383+R y B=Q+24895 para R=512, desde el adversario adaptativo y el verificador matemático completo de bytes, incluidos rechazos e intercalaciones. No se recibe B como hipótesis independiente ni se identifica la altura con Q+V. La cota sigue siendo para un perfil fijo. Falta la ley causal de las rondas reales, la composición de varios perfiles, rondas y reinicios con presupuesto común y revisión independiente. El autor declaró que no hay dictamen.",
    "M39": "Ya están transferidos los controles de los vectores y del acarreo a AIR/FRI sobre el campo y derivado el presupuesto uniforme del lector matemático completo de bytes. Para R=512 el verificador usa como máximo 24895 llamadas entre todos los perfiles admitidos. Falta el refinamiento universal serde/bincode, operaciones de máquina y Rust. Permanecen EOF estricto y corte analítico R; el coste de varias verificaciones o reinicios necesita composición común.",
    "M40": "La cota usa el umbral algebraico derivado de GT/GC originales y sustituye el exceso por un evento real clasificado de FRI de traza, cancelación AIR o FRI de composición. Se deriva B=Q+24895 para R=512 y m<=Q+24894. Falta acotar Pr(Rondas) mediante primeras exposiciones de E con los vectores ya fijados, integrar el factor de trabajo, preconsultas deliberadas, perfiles y reinicios. El trabajo no se considera independiente ni la preconsulta deliberada un error de cumpleaños.",
    "M41": "Para perfil fijo y R=512 se demuestra Pr(falsa)<=Pr(no SinBad)+Pr(Rondas)+(Q+24895)*(choose(floor(7*2^(k+2)/8),40)/choose(2^(k+2),40)+2^-300+error(Digest,512,Q+24894)), bajo solo presupuesto Q adversario. El umbral y B están derivados. Falta acotar las dos probabilidades excepcionales con los retos E reales, sesgos y preconsultas, integrar trabajo, perfiles y reinicios, refinamiento universal Rust y ejemplo numérico integral. La fórmula puede ser vacua; ni la cola 2^-300 ni la cota de muestreo 1/200 implican solidez global.",
}
