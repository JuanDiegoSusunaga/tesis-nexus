"""Alcance y pendientes de la composición matemática completa del verificador."""

from config_certificado_gramatica import OPEN as PREVIOUS_OPEN

MODELS = {
    "ROM/RegistroPrograma": {
        "grupos": ["M37", "M39"], "secciones": ["6.7.4"],
        "verificado": "Se recuperan los bytes exactos de cada clave; las entradas del programa cuentan sus respuestas y miden a lo sumo 79 octetos. La secuencia de programas conserva el rechazo, concatena el registro solo cuando acepta el primero y suma los presupuestos para toda tabla.",
        "limites": ["Modelo de programas finitos de la gramática TG2; las consultas arbitrarias del adversario y las familias causales antes de la exposición siguen separadas."]},
    "Merkle/ProgramaVerificacion": {
        "grupos": ["M37", "M39"], "secciones": ["6.7.4"],
        "verificado": "Cada apertura Merkle se ejecuta como programa de peticiones de hoja y nodos en la tabla común. Resultado y registro coinciden con el evaluador indexado anterior. Una longitud incorrecta rechaza sin hash; la aceptación produce el registro de extracción y cuesta altura+1. Se prueba la cota para toda tabla y la extracción sin colisiones registradas.",
        "limites": ["Los campos y naturales son matemáticos; no formaliza SHA3 ni todo el ejecutable Rust."]},
    "Bytes/Lectura": {
        "grupos": ["M39"], "secciones": ["6.7.4"],
        "verificado": "Lectores con resto para prefijos, enteros LE, digest, campo, extensión y vectores. Se prueban ida/vuelta, rechazo por truncamiento, coordenada no canónica, longitud esperada incorrecta y cola en la envoltura EOF estricta.",
        "limites": ["El vector libre sigue la longitud codificada sin modelar cuotas de memoria o coste del parser. El EOF estricto es una envoltura adicional: bincode::deserialize admite colas."]},
    "Bytes/Codec": {
        "grupos": ["M39"], "secciones": ["6.7.4"],
        "verificado": "Composición de codificadores y lectores de enteros, campos, productos, listas y transporte de estructuras. Ida/vuelta en el dominio de anchos explícitos, codificación inyectiva y lectura completa con rechazo de sufijos.",
        "limites": ["El dominio limita anchos de enteros y cuentas de listas; no afirma validez criptográfica, caracterización inversa de todo parseo o equivalencia de asignaciones de bincode."]},
    "Verificador/Certificado": {
        "grupos": ["M39"], "secciones": ["6.7.4"],
        "verificado": "Estructuras y codec del certificado completo (TransitionStatement,LinkedProof): puntos AIR, capas FRI, compromisos, consultas y cabecera, con orden y anchos explícitos. Lectura con resto, lectura estricta, inyectividad, rechazo de cola y longitudes de enunciado/punto. La capa coincide con la serialización ya demostrada.",
        "limites": ["La correspondencia del esquema con serde/bincode y Rust se contrasta externamente; falta refinamiento universal del parser y de memoria. Los valores tipados ya pertenecen al campo."]},
    "Canal/SelectorOrdenado": {
        "grupos": ["M35", "M39"], "secciones": ["6.7.4"],
        "verificado": "Selector en orden de primera aparición: conserva prefijos, no duplica índices y su proyección a conjuntos es exactamente el programa anterior sobre la misma tabla. Una ejecución aceptada entrega cuarenta índices distintos y una continuación aceptada.",
        "limites": ["R sigue siendo corte analítico sin equivalente de parada en Rust. No elimina las hipótesis de frescura ni deriva la ley del selector real para todas las historias adversarias."]},
    "FRI/ProgramaVerificacion": {
        "grupos": ["M37", "M39"], "secciones": ["6.7.4"],
        "verificado": "Programa FRI que autentica izquierda/derecha antes del acarreo y rechaza longitudes incorrectas. Aceptación caracterizada por todas las autenticaciones, compatibilidades y constante final. El paso coincide con el paso Option anterior; se demuestra costo 2*(suma de alturas+número de capas). Cada apertura y la continuación aceptada están en el registro real del programa; todo el recorrido aceptado produce esos registros.",
        "limites": ["No construye por sí solo las familias causales anteriores a la primera exposición ni el adaptador integral del adversario. No se afirma una cota probabilística global."]},
    "Canal/DesafiosPrograma": {
        "grupos": ["M35", "M37", "M39"], "secciones": ["6.7.4"],
        "verificado": "El canal entrega las dos coordenadas reducidas de cada E, tres alfas, todos los betas y los cuarenta índices en orden. Olvidar los valores de retos/raíces recupera los programas anteriores. La aceptación entrega longitudes exactas, índices sin duplicados y una continuación aceptada. Se prueba el presupuesto completo con trabajo rechazado y duplicados para toda tabla.",
        "limites": ["La respuesta E se interpreta matemáticamente por dos mitades de 16 bytes; no prueba SHA3 uniforme ni la frescura global de las claves. Trabajo se parametriza aquí y se instancia en el verificador completo."]},
    "Verificador/Forma": {
        "grupos": ["M39"], "secciones": ["6.7.4"],
        "verificado": "Forma previa al canal: 2^k filas para 4<=k<=12, perfil 12/20, versión 1, nonce de 64 bits, raíz compartida, cuarenta consultas, seis puntos y todos los caminos/capas con longitud correcta. Se extraen las cotas 16/4096 y las cantidades y formas de cada consulta.",
        "limites": ["Canonicidad de campos pertenece al lector de bytes. La forma usa naturales; el refinamiento universal de controles Rust y fallos de memoria no se demuestra."]},
    "Verificador/Consulta": {
        "grupos": ["M39"], "secciones": ["6.7.4"],
        "verificado": "Secuencia real de seis aperturas AIR, enlace de traza, FRI de traza, enlace de composición y FRI de composición. Se caracteriza la aceptación de todos los controles y se prueba el presupuesto de una consulta para toda tabla. La longitud AIR se comprueba antes de zip; si es incorrecta no se emiten hashes.",
        "limites": ["La fórmula de composición y aritmética usan el campo matemático. Falta equivalencia universal con todas las operaciones de máquina y traducción integral a las premisas de solidez."]},
    "Verificador/Completo": {
        "grupos": ["M35", "M37", "M39"], "secciones": ["6.7.4"],
        "verificado": "Ruta matemática completa desde el lector estricto hasta forma, canal, trabajo por ceros iniciales, índices ordenados y cuarenta consultas con ambas fases FRI. No se truncan listas desiguales por zip. La aceptación produce forma válida, tres alfas, k/k+1 betas, cuarenta índices distintos y todos los controles de las consultas. El presupuesto del programa y de su registro coincide con V_T, incluidos rechazos. Parseo fallido, forma inválida y sufijo estricto rechazan antes del hash; el nonce válido no introduce alias.",
        "limites": ["R acota analíticamente el selector; Rust no tiene ese corte. La envoltura EOF estricta difiere de bincode predeterminado. No es refinamiento universal Rust/Lean, prueba del compilador o SHA3, solidez global, ZK ni dictamen independiente."]},
}

OPEN = dict(PREVIOUS_OPEN)
OPEN["M35"] = "El canal conserva desafíos e índices en orden y su proyección a conjuntos está probada. Falta instanciar la ley uniforme ideal mediante claves frescas bajo las excepciones para todas las historias del ejecutable y adversario; no se retira la condición de frescura ni se supone independencia entre fases."
OPEN["M37"] = "Las aperturas Merkle y recorridos FRI producen sus registros desde programas efectivos sobre una tabla común. Falta derivar familias causales y congelación antes de la primera exposición para todas las historias, incluyendo intercalaciones y consultas arbitrarias del adversario fuera de la gramática."
OPEN["M39"] = "El certificado y su lector matemático, formas, rechazos, canal y todas las aperturas ya están compuestos con presupuesto V_T demostrado. Falta refinamiento universal del parser serde/bincode, las otras operaciones de máquina y el ejecutable Rust. Se conserva la diferencia de EOF y el corte analítico R; el contraste de cincuenta casos es evidencia externa, no equivalencia universal."
