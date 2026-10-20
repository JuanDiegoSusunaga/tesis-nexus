"""Alcances de soporte, familias causales y riesgo de reconstrucción ROM."""

from config_adversario_causal import OPEN as PREVIOUS_OPEN

MODELS = {
    "Canal/RegistroRaices": {"grupos": ["M35", "M37"], "secciones": ["6.7.4"],
        "verificado": "Se despliegan los estados, eventos de absorción/retos y betas de los bucles del canal. Resultados y registros coinciden con los programas; las raíces conservan orden y cantidad y cada evento está en el prefijo real, sin suponer frescura.",
        "limites": ["Semántica de una H común; no deduce que los valores reducidos sean uniformes ni verifica SHA3."]},
    "Canal/RegistroSelector": {"grupos": ["M35", "M37"], "secciones": ["6.7.4"],
        "verificado": "Una ejecución aceptada del selector produce cuarenta índices distintos en orden y una continuación aceptada cuyo registro es subsecuencia del efectivamente ejecutado, incluidos duplicados previos.",
        "limites": ["Conserva el corte analítico R; no prueba la ley conjunta del selector adversario ni su refinamiento Rust."]},
    "Canal/RegistroCompleto": {"grupos": ["M35", "M37", "M39"], "secciones": ["6.7.4"],
        "verificado": "La transcripción del canal completo se calcula desde H: raíz base, tres alfas, ambas listas de raíces/betas y estados. Se prueba su resultado y registro exactos, la pertenencia de cada absorción/reto y el soporte de la continuación elegida al aceptar.",
        "limites": ["Valores matemáticos y misma H. No atribuye independencia a retos correlacionados ni añade el corte R al bucle Rust."]},
    "Merkle/AperturasPrograma": {"grupos": ["M37"], "secciones": ["6.7.4"],
        "verificado": "Las aperturas llevan raíz, altura, posición, valor y hermanos. Su autenticación y soporte se extraen del subprograma Merkle y se transportan al registro global; el valor coincide con el oráculo anterior al primer reto correspondiente.",
        "limites": ["La extracción usa ausencia de excepciones mediante un corte causal y el rango del índice; no afirma seguridad de SHA3 concreto."]},
    "FRI/AperturasPrograma": {"grupos": ["M37"], "secciones": ["6.7.4"],
        "verificado": "Se enumeran izquierda/derecha de cada capa FRI con el estado de acarreo efectivo. La aceptación produce autenticación y soporte de todas ellas, cantidad dos por capa, rango de índices y origen en la raíz y altura de esa capa.",
        "limites": ["El plegado y los índices son matemáticos; la solidez probabilística de FRI y el refinamiento Rust son obligaciones distintas."]},
    "Verificador/SoporteConsulta": {"grupos": ["M37", "M39"], "secciones": ["6.7.4"],
        "verificado": "Una consulta aceptada registra exactamente seis aperturas AIR y todas las parejas FRI de traza/composición. Se compone el registro de sus subprogramas, se prueba autenticación, rango y origen de cada apertura y cantidad 6+2*k+2*(k+1).",
        "limites": ["La correspondencia universal de operaciones de máquina y del parser con Rust sigue separada."]},
    "Verificador/SoporteCompleto": {"grupos": ["M35", "M37", "M39"], "secciones": ["6.7.4"],
        "verificado": "La aceptación completa entrega muestra y desafíos efectivos con soporte de la continuación. Se derivan todas las absorciones/retos y las aperturas de las cuarenta consultas desde el programa, con autenticación, rango, origen y cantidad 40*(6+2*k+2*(k+1)). No se reciben registros arbitrarios como premisas.",
        "limites": ["Modelo matemático con EOF estricto y corte R explícitos. No prueba equivalencia universal del ejecutable Rust."]},
    "Canal/FamiliasPrograma": {"grupos": ["M37"], "secciones": ["6.7.4"],
        "verificado": "Los eventos del registro global y SinBad construyen todos sus cortes de primera exposición. La tabla de cada corte es el prefijo exacto hasta la posición de la primera consulta; el oráculo depende de ese prefijo y es independiente del testigo elegido. La familia se captura como OraculosEmitidos y lee las aperturas aceptadas.",
        "limites": ["El prefijo de la historia y la raíz son explícitos. No impone una distribución de probabilidades a las familias."]},
    "Verificador/FamiliasAceptadas": {"grupos": ["M37"], "secciones": ["6.7.4"],
        "verificado": "Desde la aceptación con propuesta adaptativa de bytes y consultas arbitrarias intercaladas se construyen la familia AIR base y todas las capas FRI de traza/composición. Cada apertura efectiva coincide con su oráculo anterior al primer reto asociado. Solo se exige SinBad y aceptación; los hechos de registro se derivan. Las familias tienen k y k+1 capas.",
        "limites": ["Cierre del modelo clásico finito de registro/congelación M37. No cierra solidez integral, ley conjunta del selector, candidatos, refinamiento Rust, ZK, QROM o dictamen independiente."]},
    "ROM/PlanPrograma": {"grupos": ["M35", "M37", "M39", "M41"], "secciones": ["6.7.4"],
        "verificado": "El programa finito de bytes se compila al plan de respuestas frescas y memoria: las repeticiones no consumen cuota fresca. Se obtiene la probabilidad exacta y cota adaptativa de excepciones. Sin excepción, la función de la tabla final reproduce la ejecución del programa y satisface SinBad.",
        "limites": ["Se exige altura(programa)<=S. No se deduce automáticamente ese límite estructural de Q+V_T del ejecutable ni se cuenta memoria/CPU."]},
    "Verificador/ExperimentoCausal": {"grupos": ["M37", "M41"], "secciones": ["6.7.4"],
        "verificado": "En el experimento muestreado sin excepción, una aceptación produce todas las familias congeladas. El evento de aceptar sin reconstruirlas implica excepción y su probabilidad está acotada por min(1,S*(49*S+B)/2^256), bajo el presupuesto de altura declarado.",
        "limites": ["Es riesgo de fallo de reconstrucción causal, no probabilidad de aceptar un enunciado falso ni solidez integral. La ley conjunta del selector, candidatos, unión completa de eventos y refinamiento Rust siguen abiertos."]},
}

OPEN = dict(PREVIOUS_OPEN)
del OPEN["M37"]
OPEN["M35"] = "Ya se derivan los desafíos, raíces, muestra y registros reales del canal; el programa global se compila al muestreo fresco con memoria y se reproduce fuera de excepciones. Falta identificar la ley conjunta de primeras exposiciones e índices con la muestra ideal y transferir sus cotas sin suponer independencia después de condicionar a SinBad. El refinamiento universal Rust continúa abierto."
OPEN["M39"] = PREVIOUS_OPEN["M39"] + " Ahora se derivan los hechos de registro de todas las aperturas de las cuarenta consultas. El compilador al plan fresco conserva una hipótesis explícita de altura<=S; no se identifica automáticamente ese presupuesto con Q+V_T."
OPEN["M41"] = PREVIOUS_OPEN["M41"] + " Se añade la cota del evento aceptar sin poder reconstruir todas las familias causales, como subevento de excepción en el muestreo del programa. Esa cota no es la probabilidad de aceptar un enunciado falso; la unión integral de eventos y la ley conjunta siguen pendientes."

CLOSED = {
    "M37": {
        "alcance": "Registro, extracción y congelación del modelo clásico finito TG2: desde una aceptación con propuesta adaptativa de bytes e intercalaciones arbitrarias, se derivan todas las consultas AIR/FRI y se construyen sus familias antes de la primera exposición del reto asociado. Las tablas son prefijos efectivos y la elección de testigos no altera el oráculo. SinBad se conserva explícito y el muestreo del mismo programa acota el fallo de reconstrucción bajo altura<=S.",
        "teoremas": ["Nexus.Verificador.SoporteCompleto.soporte_total", "Nexus.Verificador.SoporteCompleto.origen_total",
            "Nexus.Canal.FamiliasPrograma.depende_del_prefijo", "Nexus.Canal.FamiliasPrograma.independiente_del_testigo",
            "Nexus.Verificador.FamiliasAceptadas.cierre_adversario", "Nexus.Verificador.ExperimentoCausal.cota_fallo"],
        "limites": ["Programas clásicos finitos y ausencia de excepciones para la congelación; la cota de reconstrucción exige altura(programa)<=S.",
            "Quedan ley conjunta del selector y transferencia de cotas de solidez, candidatos y eventos integrales, refinamiento universal Rust/Lean y coste real de memoria/CPU.",
            "No se declara seguridad SHA3 concreta, solidez integral, ZK, QROM ni revisión independiente; R sigue siendo un corte analítico."]}
}
