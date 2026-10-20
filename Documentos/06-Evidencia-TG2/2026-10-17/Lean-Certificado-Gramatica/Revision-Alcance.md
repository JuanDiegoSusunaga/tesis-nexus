# Evaluación de los ocho grupos parciales

Los criterios originales se conservan literalmente. Lean comprueba los términos;
su correspondencia con cada criterio es juicio semántico del agente, sin dictamen.
M31 cierra un ejemplo concreto y conserva obligaciones adicionales universales.
Los siete restantes mantienen sus pendientes. [Registro estructurado](../Certificado-Gramatica-Antecedentes/revision-criterios.json).

## M26 — Aritmética de mediciones: unidades, razones y redondeos

Estado: **parcial**.

1. Criterio original: Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.

2. Criterio original: Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Pendientes y límites: Siguen sin identificar las corridas originales H1/H2 y sus versiones, junto con M44. Las cuentas y tolerancias ya probadas no certifican procedencia ni capacidad sostenida; esta pasada no inventa datos de esas corridas.

## M31 — Límites del verificador legado y del conocimiento cero

Estado: **modelo_verificado**.

1. Criterio original: Representar el puente de raíces y su dominio, incluidos alias y rango de índices.

   Evaluación: Puente de ocho bytes, dominio canónico, alias modular y de índices ya formalizados; se conserva su alcance legado.

   Teoremas: `Nexus.ROM.Raices.puente_raiz_canonica`, `Nexus.ROM.Raices.puente_inyectivo_en_dominio`, `Nexus.ROM.Raices.cola_ignorada`, `Nexus.ROM.Raices.alias_modular_concreto`, `Nexus.ROM.Raices.alias_indice`.

2. Criterio original: Formalizar la reconstrucción del testigo del ejemplo pequeño si se usa como resultado matemático.

   Evaluación: El certificado legado concreto se genera y verifica en Rust y se relee independientemente con Python. Sus índices/valores literales se prueban en Lean: dieciséis nodos distintos, evaluaciones exactas y reconstrucción de la segunda fila 5. La vinculación a bytes/SHA3 es evidencia externa explícita.

   Teoremas: `Nexus.ROM.CertificadoLegado16.posiciones_del_certificado`, `Nexus.ROM.CertificadoLegado16.nodos_distintos`, `Nexus.ROM.CertificadoLegado16.grado_polinomio`, `Nexus.ROM.CertificadoLegado16.evaluaciones_certificado`, `Nexus.ROM.CertificadoLegado16.interpolacion_exacta`, `Nexus.ROM.CertificadoLegado16.testigo_recuperado`, `Nexus.ROM.CertificadoLegado16.segunda_fila_unica`.

3. Criterio original: No convertir pruebas de casos ni ausencia de enmascaramiento en una prueba general de solidez.

   Evaluación: Los resultados se limitan al ejemplo concreto y a la unicidad condicionada al grado; no se afirma ZK ni solidez general ni refinamiento universal del código.

   Teoremas: `Nexus.ROM.CertificadoLegado16.cualquier_traza_compatible`, `Nexus.ROM.CertificadoLegado16.segunda_fila_unica`.

Pendientes y límites: Ejemplo concreto de PqValidityProof legado, con hojas AIR de ocho bytes y dominio NEXUS-STARK-v2; no se identifica con TG2 v1. El enlace de archivo/SHA3/bincode es evidencia ejecutada externa al núcleo Lean. No prueba refinamiento universal Rust, ZK ni solidez general.

## M35 — Muestra compartida e hipergeométrica H

Estado: **parcial**.

1. Criterio original: Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.

2. Criterio original: Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Pendientes y límites: Instanciar la proyección de respuestas y demostrar las claves frescas bajo las excepciones en todas las historias del ejecutable y del adversario. El programa de canal usa una sola muestra; su ley fresca está condicionada a ausencia de la clave en la historia, no se elimina esa condición.

## M36 — Solidez ideal por rondas y reinicios

Estado: **parcial**.

1. Criterio original: Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.

2. Criterio original: Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Pendientes y límites: Completar el adaptador integral de rondas y reinicios y obtener revisión independiente; el autor declaró que no hay dictamen. El compilador de programas finitos no identifica por sí solo los inicios B con consultas hash Q.

## M37 — Extracción Merkle, bytes y orden temporal ROM

Estado: **parcial**.

1. Criterio original: Conservar extracción, congelación y órdenes de primeras consultas bajo ausencia de aciertos.

2. Criterio original: Obtener los hechos de registro y familias causales para todas las historias del protocolo.

Pendientes y límites: Extender el programa causal a todas las consultas y eventos del protocolo/adversario, incluidas entradas arbitrarias fuera de la gramática acotada. Derivar registro y congelación antes de la primera exposición bajo los eventos de excepción; el solapamiento enunciado/nodo debe seguir en la tabla común.

## M39 — Presupuestos, formas, gramática y semántica del verificador

Estado: **parcial**.

1. Criterio original: Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.

2. Criterio original: Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Pendientes y límites: Completar gramática de certificados, parser/deserialización, rechazos y correspondencia integral con Rust. Ya se deriva la cuenta del canal y se verifican las seis posiciones con USize; faltan la composición con todas las aperturas, las otras operaciones de máquina y el refinamiento del ejecutable.

## M40 — Potencial de nonces y cola del selector

Estado: **parcial**.

1. Criterio original: Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.

2. Criterio original: Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Pendientes y límites: Construir los programas de los candidatos reales y sus conjuntos buenos con cotas antes de responder, además del trabajo/nonce y la tabla global. El compilador memoriza las repeticiones, pero no demuestra valor<=rho para esos candidatos ni la carga global de inicios.

## M41 — Cota ROM completa y ejemplo numérico

Estado: **parcial**.

1. Criterio original: Conservar la cota parametrizada del evento excepcional del registro.

2. Criterio original: Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.

3. Criterio original: Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Pendientes y límites: Probar las inclusiones y leyes de los tres eventos bajo un mismo experimento del ejecutable, incluyendo adversario, sesgo, selector y presupuestos completos. La gramática, programa causal y cuenta del canal son componentes; no instancian todavía la cota numérica global.
