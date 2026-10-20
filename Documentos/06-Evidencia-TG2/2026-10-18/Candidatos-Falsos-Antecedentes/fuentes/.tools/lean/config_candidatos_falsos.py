"""Alcances del filtro causal, presupuesto previo y aceptación falsa."""

MODELS = {
    "ROM/CoincidenciaPrograma": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se formalizan las entradas de terminación, consulta y composición de programas de bytes. Dos funciones que coinciden en las entradas realmente consultadas producen idéntico resultado y transcripción. La ejecución puede repetirse con la función completada desde la tabla si todas sus consultas están almacenadas, sin exigir igualdad fuera de ese soporte.",
        "limites": ["La igualdad se refiere al programa matemático finito y no constituye equivalencia universal con las operaciones de máquina de Rust."]},
    "Canal/CanalPrevio": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Un programa de bytes ejecuta exactamente el canal hasta la absorción del nonce: origen, perfil, enunciado, raíz, tres alfas, ambas fases FRI y constantes. Su resultado es la semilla y sus entradas son la cadena canónica. Si dos funciones coinciden sobre esa cadena, tanto la cadena como la semilla coinciden. La reejecución usa únicamente entradas conocidas.",
        "limites": ["Se omite deliberadamente la consulta de trabajo: una primera I del adversario puede precederla. No se deduce un factor probabilístico de trabajo independiente."]},
    "Verificador/FiltroFalso": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La elegibilidad exige perfil admitido, cadena recuperada igual a la reejecución canónica sobre la tabla, semilla exacta y todas las consultas conocidas. Exige además falsedad algebraica: ausencia del polinomio AIR de grado menor que 2^k de EnunciadoValido. Se prueban relectura exacta de parámetros, recuperación de los retos E canónicos, exclusión de enunciados válidos y elegibilidad del registro aceptado falso.",
        "limites": ["El filtro es una proposición matemática del pasado, no un algoritmo eficiente ni un nuevo control del ejecutable. La falsedad corresponde a EnunciadoValido; no se afirma refinamiento de Rust/serde/bincode."]},
    "ROM/FiltroSelector": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Una condición previsible vacía simultáneamente los dos conjuntos buenos. Se prueban pertenencia, intersección y cardinal; una muestra de cardinal positivo queda cubierta exactamente cuando se cumple esa condición y estaba contenida en la intersección original. Se definen probabilidades como medias incondicionales y se demuestra monotonicidad y separación aditiva de dos eventos excepcionales.",
        "limites": ["Filtrar por un límite de cardinal no lo demuestra gratis para la política original: se conserva la probabilidad del evento excluido."]},
    "ROM/PresupuestoPrefijo": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La dirección fresca siguiente pertenece al registro completo y no al prefijo; por borrado de esa dirección se obtiene una desigualdad estricta de cardinales. De un presupuesto global B de entradas distintas se deriva m<=B-1 para cada primera exposición y para la tabla del estado correspondiente. El número global de entradas distintas se acota también por la altura del programa finito.",
        "limites": ["El presupuesto global B todavía se recibe como hipótesis. La altura no se identifica con Q+V_T ni B con Q; R permanece analítico."]},
    "Verificador/PoliticasFalsas": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "GT/GC se restringen al canal canónico falso y a intersecciones de cardinal como máximo g, usando solo el prefijo. La cota de cardinal de las políticas filtradas es universal por construcción. La aceptación falsa matemática, con propuesta adaptativa e intercalaciones, produce una primera exposición elegible y su muestra real. Si no ocurre exceso de cardinal en ningún prefijo elegible, esa aceptación queda cubierta por las políticas filtradas.",
        "limites": ["Exceso es una unión de primeras exposiciones elegibles cuyo cardinal original supera g. Su probabilidad no se acota todavía; el filtro no demuestra que sea pequeña ni presupone ausencia de exceso al definir la ley uniforme."]},
    "Canal/UnionFiltrada": {
        "grupos": ["M35", "M36", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "La omisión con las políticas filtradas coincide con el selector instrumentado. Su unión probabilística satisface riesgo(R,e,40,g,B-1)*B bajo un único presupuesto global B de entradas distintas; se derivan la cota g de la intersección filtrada y el presupuesto B-1 del pasado, eliminando las hipótesis externas separadas g y m de todas las activaciones.",
        "limites": ["La cobertura de una aceptación falsa por esa unión exige separar el evento de exceso. La cota de B y el tratamiento de todos los perfiles y reinicios siguen pendientes."]},
    "Verificador/CotaFalsa": {
        "grupos": ["M35", "M36", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "En un solo experimento uniforme finito y para un perfil k fijo se demuestra Pr(aceptación falsa)<=Pr(no SinBad)+Pr(Exceso)+riesgo(R,k+2,40,g,B-1)*B, con solo la hipótesis de presupuesto global B. Las cotas g de las políticas filtradas y m<=B-1 se derivan. Para R=512 y 4<=k<=12 se sustituye la cola del selector por 2^-300, conservando la hipergeométrica y el error de acoplamiento separados.",
        "limites": ["La fórmula aún podría ser vacua. Falta acotar Pr(Exceso) mediante las rondas AIR/FRI y sus respuestas reales, acotar Pr(no SinBad), derivar B, integrar trabajo, perfiles y reinicios, refinamiento universal Rust y ejemplo numérico integral. La cola 2^-300 por sí sola no es una garantía de seguridad global. No se condiciona a SinBad, aceptación ni ausencia de exceso."]},
}

OPEN = {
    "M35": "La aceptación falsa ya está cubierta por políticas del pasado que exigen canal canónico, falsedad algebraica y cardinal <=g. Se deriva m<=B-1 del presupuesto global B y se obtiene Pr(falsa)<=Pr(no SinBad)+Pr(Exceso)+riesgo*B, sin hipótesis global g/m sobre las políticas originales. Falta acotar Exceso con los argumentos AIR/FRI y sus retos reales, las excepciones y B, integrar trabajo, perfiles y reinicios y refinar universalmente Rust. No se ha demostrado que el exceso sea improbable.",
    "M36": "Ya hay filtro causal de canal canónico falso y cobertura de la aceptación falsa desde el adversario. El pasado de una primera I usa a lo sumo B-1 entradas distintas si el total usa a lo sumo B; se elimina m como hipótesis separada. Falta derivar el presupuesto global B del adversario y del verificador, integrar perfiles, rondas y reinicios y revisión independiente. El autor declaró que no hay dictamen; no se identifica B con Q ni altura con Q+V_T.",
    "M39": "La reejecución del canal previo usa exactamente sus consultas conocidas y produce cadena y semilla canónicas; el filtro distingue esa propiedad de la simple lectura de parámetros. La aceptación falsa del lector matemático ya se cubre por ese filtro y por una cota con excepciones explícitas. Falta refinamiento universal serde/bincode, operaciones de máquina y Rust y presupuestos globales. Permanecen EOF estricto y corte analítico R.",
    "M40": "La fórmula ya distingue aceptación falsa, excepción ROM y exceso del cardinal original de GT/GC. El filtro causal y su cardinal universal están demostrados y m<=B-1 se deriva. Para R=512 la cola del selector se acota por 2^-300. Falta acotar Pr(Exceso) con los eventos AIR/FRI sobre primeras exposiciones reales, el factor de trabajo y el presupuesto común de perfiles y reinicios. No se descarta el exceso ni se trata la preconsulta deliberada como un error de cumpleaños.",
    "M41": "Para un perfil fijo ya se demuestra Pr(falsa)<=Pr(no SinBad)+Pr(Exceso)+riesgo(R,k+2,40,g,B-1)*B, bajo presupuesto global B. Se derivan filtro de canal canónico falso, cota g de las políticas filtradas y m<=B-1. Falta acotar el exceso y las excepciones, derivar B, transferir las rondas AIR/FRI reales, integrar trabajo, perfiles y reinicios, refinamiento universal Rust y ejemplo numérico integral. La fórmula podría ser vacua y la cola 2^-300 no constituye solidez global.",
}
