"""Alcances del programa adversario, la ley local y la congelación efectiva."""

from config_verificador_completo import OPEN as PREVIOUS_OPEN

MODELS = {
    "ROM/ProgramaBytes": {
        "grupos": ["M37", "M39"], "secciones": ["6.7.4"],
        "verificado": "Programa finito con entradas de bytes arbitrarios y resultado de cualquier tipo. La secuencia concatena registros, conserva el resultado del programa TG2 levantado y tiene un presupuesto estructural finito. Cada par de su traza responde mediante la misma H y su tabla es compatible.",
        "limites": ["Finito por construcción; no formaliza ejecuciones infinitas, memoria de máquina ni SHA3 concreto."]},
    "ROM/ProyeccionDigest": {
        "grupos": ["M35"], "secciones": ["6.7.4"],
        "verificado": "Bijección de los 32 octetos del digest con Fin(256^32). El índice real de los primeros ocho octetos coincide con el residuo del entero completo para e<=64; cada índice tiene 2^(256-e) preimágenes y masa 1/2^e. Se conservan todos los promedios de funciones del índice.",
        "limites": ["Distribución uniforme ideal del digest completo; no afirma que SHA3 concreto tenga esa ley."]},
    "ROM/HistoriaLocal": {
        "grupos": ["M35", "M37"], "secciones": ["6.7.4"],
        "verificado": "La estrategia del programa usa solo el prefijo de respuestas y su historia efectiva es compatible. Cada prefijo equivale a fijar exactamente sus entradas observadas, a lo sumo n. Sobre el universo finito de observadas más próxima entrada se cuenta la ley fresca 1/2^256; una repetición con respuesta distinta es imposible.",
        "limites": ["No se postula una medida uniforme sobre todas las funciones del dominio infinito de bytes. La consulta fresca es una hipótesis local; no se condiciona a SinBad ni se obtiene independencia global entre fases."]},
    "ROM/EjecucionBytes": {
        "grupos": ["M37", "M39"], "secciones": ["6.7.4"],
        "verificado": "El programa de bytes ejecuta una tabla compartida compatible con H: memoriza las nuevas entradas, conserva las repeticiones y registra todas las consultas reales. La ausencia de excepciones se verifica antes de cada respuesta fresca y produce un RecorridoSinAcierto. Los orígenes ordenados de absorción y reto se derivan de su pertenencia al registro efectivo, también cuando las llamadas actuales son repetidas.",
        "limites": ["SinBad se exige sobre el recorrido producido. No se prueba aquí su probabilidad global, ni se supone que las llamadas repetidas sean frescas."]},
    "ROM/PalabrasDigest": {
        "grupos": ["M35"], "secciones": ["6.7.4"],
        "verificado": "La proyección real de R digests independientes tiene fibras de tamaño (2^(256-e))^R. Conserva promedios y cocientes de eventos de palabras de índices. Se obtiene uniformidad de q-subconjuntos y el cociente hipergeométrico del selector condicionado a completar antes de R.",
        "limites": ["Experimento ideal de digests independientes. Falta identificar su ley con el experimento global de primeras exposiciones adversarias, sin imponer independencia después de excluir eventos malos."]},
    "Canal/Intercalaciones": {
        "grupos": ["M35", "M37", "M39"], "secciones": ["6.7.4"],
        "verificado": "Un adversario con estado puede consultar bytes arbitrarios antes de cada petición del protocolo y actualizarse después de su respuesta. El verificador matemático conserva resultado y su registro es una subsecuencia del global. El coste global es el coste del protocolo más las consultas adversarias, con cota Q+V_T y tabla efectiva común.",
        "limites": ["Política finita de consultas clásicas; no modela consultas cuánticas. Se conserva el corte analítico R y no se deduce refinamiento universal Rust."]},
    "Canal/CongelacionPrograma": {
        "grupos": ["M37"], "secciones": ["6.7.4"],
        "verificado": "Una apertura aceptada registrada en el programa global se encuentra en su tabla efectiva. Los primeros orígenes absorción/reto proporcionan un extractor que usa solo la tabla anterior a la primera respuesta del reto. Sus valores coinciden con toda apertura posterior registrada. Se instancia el origen en el verificador con intercalaciones.",
        "limites": ["Se mantienen SinBad y las premisas de pertenencia de absorción, reto y apertura al registro. Falta derivarlas conjuntamente para todas las familias AIR/FRI y conectarlas con la solidez integral."]},
    "Canal/CintaSelector": {
        "grupos": ["M35"], "secciones": ["6.7.4"],
        "verificado": "Para cualquier H, desplegar R respuestas de entradas I evalúa exactamente el programa real de selección, incluido su rechazo por corte. La proyección del selector ordenado se evalúa sobre la misma cinta; desde vacío completa exactamente cuando aparecen al menos cuarenta índices distintos.",
        "limites": ["La cola desplegada después de completar cuarenta es matemática y no forma parte del registro ejecutado. Esta igualdad determinista no prueba que las direcciones sean frescas o la cinta independiente."]},
    "Verificador/Adversario": {
        "grupos": ["M35", "M37", "M39"], "secciones": ["6.7.4"],
        "verificado": "El proponente consulta entradas arbitrarias y elige adaptativamente los bytes del certificado y su estado. Se compone con el lector estricto y el verificador intercalado usando una sola H. La aceptación entrega un certificado leído con forma válida. Registros previos y del verificador quedan en el global, que tiene historia causal compatible y coste adversario más protocolo.",
        "limites": ["El presupuesto Q+V conserva la hipótesis del límite V del candidato elegido; el coste del parser no se cuenta. Faltan eventos/candidatos globales, correspondencia universal Rust y solidez integral."]},
}

OPEN = dict(PREVIOUS_OPEN)
OPEN["M35"] = "La lectura del índice sobre 32 bytes, las cintas ideales, su selector uniforme/hipergeométrico y la evaluación determinista del canal ya están enlazadas. Hay ley fresca local sobre cada prefijo del programa de bytes y se distinguen repeticiones. Falta construir la ley conjunta del experimento adversario de primeras exposiciones y transferir sus cotas sin suponer independencia después de condicionar a SinBad, además del refinamiento universal Rust."
OPEN["M37"] = "El programa global ya incluye propuesta adaptativa de bytes e intercalaciones adversarias arbitrarias, y deriva su tabla e historia efectiva. De SinBad y la pertenencia real de absorción, reto y apertura se obtiene la congelación antes de la primera exposición. Falta derivar conjuntamente esas premisas y las familias causales para todas las aperturas AIR/FRI del experimento aceptado, y enlazarlas con su solidez global."
OPEN["M39"] = PREVIOUS_OPEN["M39"] + " El adaptador matemático ahora admite propuesta adaptativa de bytes y consultas adversarias antes y entre las del verificador, conservando resultado, registros y presupuesto de hashes."
