"""Alcances del acoplamiento local del selector matemático TG2."""

MODELS = {
    "ROM/CintasRetos": {
        "grupos": ["M35", "M41"], "secciones": ["6.7.4"],
        "verificado": "Una equivalencia explícita identifica los productos recursivos de retos con vectores Fin R de respuestas y conserva la lista y la media de cualquier observable.",
        "limites": ["Identidad entre espacios finitos ideales; no afirma frescura de direcciones ni uniformidad condicionada al éxito."]},
    "ROM/ComparacionAcoplada": {
        "grupos": ["M35", "M41"], "secciones": ["6.7.4"],
        "verificado": "Si dos salidas coinciden fuera de una excepción, la diferencia absoluta de probabilidades de cualquier evento se acota por la masa de esa excepción. Se justifican indicadores, unión y paso de una cota condicional a la incondicional.",
        "limites": ["La excepción se paga aditivamente; no se condiciona a su ausencia ni se identifica SHA3 concreto con un ROM."]},
    "ROM/RepeticionesCinta": {
        "grupos": ["M35", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se cuenta la probabilidad de que una cinta uniforme repita un estado o toque un conjunto inicial T, con recurrencia exacta y cota conservadora min(1,R*(|T|+R)/|A|).",
        "limites": ["Se incluye también el último valor aunque no llegue a usarse como siguiente dirección. La cota no supone independencia de las consultas reales."]},
    "ROM/CadenaMemoria": {
        "grupos": ["M35", "M41"], "secciones": ["6.7.4"],
        "verificado": "La cadena H(codificar estado) se implementa como árbol con memoria y como muestreo sobre cinta independiente. Las repeticiones ignoran una coordenada ideal y devuelven el valor guardado. Su ley tras una tabla fija coincide con las completaciones uniformes y, fuera de las repeticiones especificadas, la salida es la cinta ideal.",
        "limites": ["La comparación requiere codificación inyectiva y primera dirección nueva. Es una cadena matemática sin nuevas consultas adversarias intercaladas durante ella."]},
    "ROM/AcoplamientoCadena": {
        "grupos": ["M35", "M41"], "secciones": ["6.7.4"],
        "verificado": "Tras un pasado fijo de m direcciones, si la primera dirección es nueva y la codificación inyectiva, cualquier evento de R respuestas de la cadena ROM difiere del evento sobre una cinta independiente a lo sumo en delta=min(1,R*(m+R+1)/|A|). Se prueban comparación y transferencia sin excluir excepciones del espacio de probabilidad.",
        "limites": ["No deduce frescura de la primera dirección de un candidato adaptativamente elegido, ni conjuntos buenos independientes del futuro. La condición es el pasado fijo, nunca SinBad, completar o aceptar."]},
    "ROM/SelectorAcoplado": {
        "grupos": ["M35", "M41"], "secciones": ["6.7.4"],
        "verificado": "El índice real leerLE(first8) mod 2^e conserva la ley uniforme ideal para e<=64. Tras pasado fijo y primera dirección fresca, el selector ROM completo omite ambos conjuntos a lo sumo en choose(|GT inter GC|,q)/choose(2^e,q)+delta. El evento ampliado de omisión o abandono se acota por la misma hipergeométrica más tau y una sola delta.",
        "limites": ["GT y GC son conjuntos fijos antes de la cadena y comparten una única muestra. No se prueba uniformidad del selector real condicionado a completar, ni la selección global de candidatos, ni las rondas FRI adaptativas."]},
    "Canal/SelectorAcoplado": {
        "grupos": ["M35", "M39", "M40", "M41"], "secciones": ["6.7.4"],
        "verificado": "Se construye un universo finito que contiene pasado y todas las entradas I, se demuestra la inyectividad de la codificación real y se identifica la cadena con CintaSelector. La cota se enlaza al resultado del programa matemático de selección de 40 índices. Para k entre 4 y 12 y R=512, omisión o abandono tiene cota hipergeométrica+2^(-300)+delta, con delta=min(1,512*(m+513)/2^256).",
        "limites": ["Primera dirección fresca, pasado compatible fijo y conjuntos buenos fijados antes de responder siguen siendo hipótesis. El corte es analítico, la cola extendida no es registro efectivo y no se modifica Rust. No prueba presupuesto global, soundness integral ni refinamiento universal."]},
}

OPEN = {
    "M35": "La ley conjunta del programa y sus prefijos está probada. Ahora se transfiere localmente el selector de índices real mediante un acoplamiento con error explícito, incluida omisión compartida y abandono, tras un pasado fijo y primera dirección nueva. Falta derivar esa frescura para los candidatos seleccionados y preconsultas del adversario, enlazar las primeras exposiciones y todas las rondas de retos FRI con sus conjuntos buenos causales, integrar la elección de candidatos y transferir las cotas bajo el experimento adversario completo. No se afirma uniformidad tras condicionar a SinBad, aceptación o completar; el refinamiento universal Rust permanece abierto.",
    "M39": "El verificador matemático, lector, formas, canal y aperturas conservan su presupuesto V_T demostrado. La ley conjunta y el selector de índices tienen ahora comparación cuantitativa local con la cinta ideal, bajo primera dirección fresca. Falta refinamiento universal de serde/bincode, operaciones de máquina y ejecutable Rust; permanecen la diferencia de EOF y el corte analítico R. La hipótesis altura(programa)<=S no se identifica automáticamente con Q+V_T.",
    "M40": "Construir los programas de los candidatos reales y sus conjuntos buenos con cotas fijadas antes de responder, además del trabajo/nonce y la carga global de inicios. El selector local ya tiene cota hipergeométrica compartida y error explícito cuando su primera dirección es fresca respecto al pasado fijo. Falta demostrar esa premisa para los candidatos elegidos adaptativamente y valor<=rho; un nonce ya encontrado no se convierte en una prueba independiente.",
    "M41": "La ley conjunta del programa y la cota de fallo de reconstrucción causal se conservan. El selector local de índices añade transferencia cuantitativa de omisión o abandono con una única muestra y error explícito. Falta probar e instanciar las inclusiones de todos los eventos de solidez, las rondas FRI y presupuestos bajo el experimento adversario común, derivar frescura de los candidatos seleccionados, enlazar universalmente Rust y certificar el ejemplo numérico integral. La cota local no es una cota de aceptación falsa global.",
}
