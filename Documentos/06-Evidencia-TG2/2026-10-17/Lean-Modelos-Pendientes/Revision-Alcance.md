# Revisión técnica del alcance de los modelos

Esta revisión explicita qué demuestra cada cierre del registro. No es una
revisión independiente ni una certificación de seguridad de la implementación.
Los teoremas y sus axiomas están identificados en [validacion.json](validacion.json);
los alcances por módulo se fijan en [modelos.json](../Modelos-Pendientes-Antecedentes/modelos.json).

| Grupo | Cierre matemático disponible | Obligación que permanece aparte |
|---|---|---|
| M02 | Retículo euclídeo de rango declarado, mínimos definidos por radios, primer mínimo alcanzado y problemas aproximados distintos | Dureza, algoritmos de aproximación y consecución de mínimos superiores |
| M07 | Dimensiones, identidad Az-ct=Ay-cs2, pistas, rechazo y corrección de plantilla bajo reconstrucción y reto | Codecs, redondeos finales, expansión, distribución hedged y simulación de ML-DSA |
| M12 | Codec de entrada inyectivo y derivación reproducible, dominios distintos y hash igual que exige colisión si cambian entradas | Extracción uniforme KDF, seguridad de hash/KeyGen, calidad de semilla y desbordamientos |
| M17 | Ventana con referencia incluida, mínimo C=16 y ambas colas encerradas por racionales | Equivalencia f64, hipótesis de dependencia y calificación física de la fuente |
| M34 | Fórmula histórica, techos y tabla, unión PMF bajo inclusión de eventos y cotas individuales | Cota FRI bibliográfica y prueba de esa inclusión para el verificador completo |
| M38 | Preimágenes modulares exactas, variación total, masa máxima y productos independientes | Obtener respuestas frescas y la familia causal para consultas adaptativas del único oráculo |

## Comprobaciones que evitan cierres injustificados

La entrada de derivación es inyectiva, pero un hash determinista puede ser
constante. El módulo incluye ese contraejemplo. La reproducibilidad tampoco
certifica entropía, independencia o seguridad de las claves.

La rotación solo instala el lote si pasan tres controles. Sus booleanos aún
no se derivan de firmas sobre registros serializados; por eso M13 es parcial.
Un punto de control antiguo admite perder los eventos posteriores, hecho
modelado explícitamente. La recuperación del registro público no recupera secretos.

El codec de transacción es una lista matemática con longitud. Su decodificación
inversa y el consumo de nonce no equivalen a una prueba del formato bincode,
del contador de máquina o del motor de ejecución. M11 permanece parcial.

La cota del selector prueba un conteo IID para una secuencia. El trabajo debe
cobrarse antes de conocer su respuesta: condicionar a trabajo válido elimina
su factor en la probabilidad condicionada. Falta probar el potencial para todas
las estrategias con abandono e intercalación y vincularlo al canal; M40 y M41
permanecen parciales. La cota tau<2^-300 no son 300 bits del sistema.

El recuento de hashes usa rutas de longitudes tipadas. No demuestra que toda
entrada aceptada por Rust tenga esa forma, que no haya desbordamientos ni que
todas sus respuestas se hayan registrado en el modelo; M39 sigue parcial.

Los umbrales de quórum distinguen >2/3 con peso bizantino <=1/3 de >=2/3 con
peso bizantino <1/3. La honestidad es equilibrio de Nash solo bajo la desigualdad
de pagos declarada; una desviación unilateral rentable refuta ese equilibrio.
No se infiere de ello colusión mayoritaria necesaria ni consenso implementado.

Reed-Solomon recupera bajo cota de grado y suficientes evaluaciones distintas.
Duplicar un componente no permite recuperar el segundo. Esto no acredita
disponibilidad remota ni una política DA desplegada; M27 sigue parcial.

Los cálculos de mediciones son sobre decimales de archivos identificados. Las
razones y redondeos no prueban independencia de hardware, causalidad, una ley
asintótica o equivalencia de corridas. H1/H2 mantiene su procedencia pendiente.

Los cuadrados y logaritmos de L_Q certifican una cuenta de referencia. No
formalizan el teorema de reducción B+23 ni comprueban sus hipótesis para NEXUS.
M08 sigue como dependencia bibliográfica. LS15, Shor/Grover y el juego QROM de
SelfTarget requieren sus propios modelos; las conjeturas no pasan a teoremas.

El replay del núcleo confía en módulos importados y admite únicamente los
axiomas estándar registrados. No verifica por sí solo la correspondencia del
enunciado con la prosa. El autor declaró que no hay dictamen independiente.
