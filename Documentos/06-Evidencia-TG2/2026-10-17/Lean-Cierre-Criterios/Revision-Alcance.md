# Evaluación de los diecinueve grupos

Los criterios se conservan literalmente. Los teoremas son comprobados por Lean;
su correspondencia con cada criterio es un juicio semántico del agente. No hay
revisión independiente. «Modelo verificado» no significa implementación o tesis
completas verificadas. Los pendientes anteriores están archivados íntegramente
en [revision-criterios.json](../Cierre-Criterios-Antecedentes/revision-criterios.json).
Las obligaciones adicionales de los once cierres continúan abiertas.

## M05 — Definición y juego SelfTargetMSIS

Estado: **modelo_verificado**.

1. Criterio original: Fijar dimensiones, salida de H, norma y distribución de la instancia.

   Evaluación: Dimensiones y norma parametrizadas, reto polinómico B_tau y juego clásico con matriz y tabla uniformes independientes; la no vaciedad de B_tau es explícita.

   Teoremas: `Nexus.MLDSA.dimension_self`, `Nexus.MLDSA.matriz_identidad_self`, `Nexus.MLDSA.norma_self_iff`, `Nexus.MLDSA.Retos.Conteo.cardinal_retos`, `Nexus.MLDSA.Retos.Conteo.retos_no_vacios`, `Nexus.MLDSA.consultas_self_correctas`.

2. Criterio original: Formalizar la relación de victoria sin asumir una reducción desde firmas reales.

   Evaluación: La relación de victoria compara el último componente con la salida codificada del oráculo y acota la norma. Ninguna premisa importa una reducción desde firmas reales.

   Teoremas: `Nexus.MLDSA.Retos.self_target_reto_concreto`, `Nexus.MLDSA.cota_reto_si_gana`, `Nexus.MLDSA.testigo_self_no_nulo`, `Nexus.MLDSA.ventaja_self_monotona`.

Obligaciones adicionales abiertas: Juego clásico de dominio finito, dimensiones y cota de norma como parámetros explícitos. Quedan codec bibliográfico, SampleInBall, acceso cuántico y reducción desde firmas reales; se registran como obligaciones adicionales, no como resultados de este cierre.

## M11 — Autenticación de contenido y composición de transacciones

Estado: **modelo_verificado**.

1. Criterio original: Definir codificación inequívoca, hash externo, asociación de clave, cadena y nonce.

   Evaluación: Codec de documentos con inversa; contexto derivado del registro con identidad, época, clave, cadena y nonce. El hash es un parámetro externo.

   Teoremas: `Nexus.Cripto.Transacciones.decodifica_codifica`, `Nexus.Cripto.Transacciones.codifica_inyectiva`, `Nexus.Cripto.Transacciones.Aplicacion.procesar_vincula_clave`, `Nexus.Cripto.Transacciones.otra_cadena_rechazada`, `Nexus.Cripto.Transacciones.nonce_incorrecto_rechazado`.

2. Criterio original: Probar verificación previa al cambio de estado bajo supuestos explícitos de hash y firma.

   Evaluación: El paso Option exitoso exige verificación antes de producir estado; actualiza datos y nonce conjuntamente. Se explicitan procedencia de firmas y ausencia del evento de colisión con documentos autorizados.

   Teoremas: `Nexus.Cripto.Transacciones.Aplicacion.procesar_exige_admision`, `Nexus.Cripto.Transacciones.Aplicacion.procesar_actualiza_atomico`, `Nexus.Cripto.Transacciones.Aplicacion.procesar_impide_repeticion`, `Nexus.Cripto.Transacciones.Aplicacion.admision_autorizada_o_colision`, `Nexus.Cripto.Transacciones.Aplicacion.procesar_autorizado_sin_colision`.

Obligaciones adicionales abiertas: La procedencia de firmas y exclusión de colisiones son hipótesis, no seguridad demostrada de ML-DSA/SHA3. Falta correspondencia de codecs de transacciones y refinamiento Rust; no se identifica el formato con bincode TG1.

## M13 — Épocas, identidad, registro y rotación

Estado: **modelo_verificado**.

1. Criterio original: Definir estado e invariantes de identidad, época y claves vigentes.

   Evaluación: Estado tipado, época actual y asociación de identidad con clave; la cadena de rotaciones conserva identidades y aumenta época exactamente.

   Teoremas: `Nexus.Cripto.Epocas.Firmada.Ciclos.identidades_conservadas`, `Nexus.Cripto.Epocas.Firmada.Ciclos.epoca_por_longitud`, `Nexus.Cripto.Epocas.Firmada.Ciclos.epoca_anterior_no_vigente`.

2. Criterio original: Demostrar atomicidad del modelo, autorización de cambios y vigencia respecto de un prefijo confiable.

   Evaluación: La preparación y los controles fallidos no instalan estado parcial. Instalar exige firmas salientes y entrantes; una cadena aceptada conserva el checkpoint confiable como prefijo y rechaza propuestas antiguas.

   Teoremas: `Nexus.Cripto.Epocas.preparacion_fallida_atomica`, `Nexus.Cripto.Epocas.autorizacion_fallida_atomica`, `Nexus.Cripto.Epocas.posesion_fallida_atomica`, `Nexus.Cripto.Epocas.registro_fallido_atomico`, `Nexus.Cripto.Epocas.Firmada.instalacion_exige_firmas`, `Nexus.Cripto.Epocas.Firmada.firmas_con_claves_vigentes`, `Nexus.Cripto.Epocas.Firmada.Ciclos.checkpoint_conservado`, `Nexus.Cripto.Epocas.Firmada.Ciclos.repetir_propuesta_antigua_rechaza`, `Nexus.Cripto.Epocas.punto_antiguo_admite_truncacion`.

3. Criterio original: Mantener custodia, destrucción de copias y secrecia hacia adelante como obligaciones adicionales.

   Evaluación: Custodia, destrucción de copias y secrecia hacia adelante se mantienen expresamente fuera del cierre del modelo, junto con persistencia y correspondencia de implementación.

   Teoremas: `Nexus.Cripto.Epocas.punto_antiguo_admite_truncacion`.

Obligaciones adicionales abiertas: Custodia, borrado de copias, secrecia hacia adelante y checkpoint externo durable siguen abiertos. Un prefijo antiguo admite truncar una extensión. Altas/retiros, archivo completo, seguridad de firmas abstractas y equivalencia Rust son obligaciones adicionales; este modelo solo cierra rotaciones autorizadas y vigencia de época.

## M16 — RCT: umbral, cuenta consecutiva y perfil numérico

Estado: **modelo_verificado**.

1. Criterio original: Modelar el conteo consecutivo y la condición de fallo al alcanzar C.

   Evaluación: El contador aumenta si el símbolo se repite y se reinicia en uno al cambiar. Para C>1 se prueba el fallo al alcanzar C y el límite de una racha sana.

   Teoremas: `Nexus.Salud.rct_incrementa`, `Nexus.Salud.rct_cambia_valor`, `Nexus.Salud.alarma_rct_detectada`, `Nexus.Salud.Condicional.racha_no_fallida_acotada`.

2. Criterio original: Definir el techo bajo H>0 y 0<alpha<1; comprobar H=7.5 y alpha=2^-20.

   Evaluación: El techo se caracteriza y se prueba mínimo con H>0 y alpha>0, por tanto también bajo 0<alpha<1; el perfil H=15/2, alpha=2^-20 tiene corte 4.

   Teoremas: `Nexus.Salud.corte_rct_iff`, `Nexus.Salud.corte_rct_satisface`, `Nexus.Salud.corte_rct_minimo`, `Nexus.Salud.corte_rct_perfil`, `Nexus.Salud.alpha_perfil`.

3. Criterio original: Explicitar las hipótesis probabilísticas de cualquier cota de falsas alarmas.

   Evaluación: La falsa alarma IID usa la cota de min-entropía. La versión dependiente explicita las leyes condicionadas de continuación de la racha.

   Teoremas: `Nexus.Salud.rct_falsa_alarma_iid`, `Nexus.Salud.rct_perfil_falsa_alarma`, `Nexus.Salud.Condicional.rct_condicional`.

Obligaciones adicionales abiertas: Se cierra el modelo exacto del perfil C=4 y el análisis condicionado, no la calificación de una fuente física. Falta equivalencia f64/Rust; las leyes condicionales no se deducen automáticamente de un histograma. La detección al primer símbolo para C=1 no forma parte del perfil ni se afirma aquí.

## M18 — Compuerta de salud y recuperación del gestor

Estado: **modelo_verificado**.

1. Criterio original: Definir estados sin evaluación, fallo retenido, reevaluación y renovación pendiente.

   Evaluación: Los estados sinEvaluar, fallo retenido, recuperando y renovarPendiente están definidos; la reevaluación conserva la exigencia de renovación.

   Teoremas: `Nexus.Salud.fallo_fuente_retenido`, `Nexus.Salud.fallo_fuente_lote`, `Nexus.Salud.recuperacion_reinicia_evaluacion`, `Nexus.Salud.lote_conserva_renovacion_pendiente`, `Nexus.Salud.reevaluacion_sola_no_habilita`.

2. Criterio original: Probar bloqueo de derivación y operaciones, acumulación de lotes y conservación de contadores al rotar.

   Evaluación: Se compone la compuerta con operaciones autenticadas: bloquear derivación impide producir estado. Lotes se acumulan por fold y la rotación conserva monitor, histograma, estimación y lote parcial.

   Teoremas: `Nexus.Salud.inicio_bloquea_derivacion`, `Nexus.Salud.renovacion_pendiente_bloquea`, `Nexus.Salud.Operaciones.bloqueo_derivacion_bloquea_operacion`, `Nexus.Salud.Operaciones.sin_evaluar_bloquea_operacion`, `Nexus.Salud.Operaciones.renovacion_bloquea_operacion`, `Nexus.Salud.Operaciones.reevaluar_sin_rotar_bloquea_operacion`, `Nexus.Salud.Operaciones.operacion_exige_politica_y_admision`, `Nexus.Salud.ingresar_lote_troceado`, `Nexus.Salud.rotacion_conserva_monitor_y_lote`, `Nexus.Salud.Lote.lote_preserva`, `Nexus.Salud.Lote.rotacion_preserva`.

Obligaciones adicionales abiertas: Operaciones que usan la clave en una composición atómica Option con naturales y reales. No se prueba correspondencia Rust/f64, KDF real, firma, persistencia del registro, calificación física, borrado ni secrecia hacia adelante.

## M21 — Tamaños de representaciones y contabilidad de memoria

Estado: **modelo_verificado**.

1. Criterio original: Comprobar 4032-96=3936, 4032+1952+9=5993 y 128+17*256*4=17536.

   Evaluación: Los tres cálculos están probados exactamente y separados por representación.

   Teoremas: `Nexus.Modelos.Memoria.bytes_sensibles`, `Nexus.Modelos.Memoria.bytes_par_serializado`, `Nexus.Modelos.Memoria.bytes_objeto_backend`.

2. Criterio original: Vincular cada tamaño con la representación y versión medidas; no interpretarlo como entropía ni RAM total.

   Evaluación: Perfil histórico ML-DSA-65, fips204 0.4.6, enlazado a fuentes congeladas R5, Cargo.lock, medición de tipos y log de serialización. La suma declarada del layout se identifica con el modelo de 17536 bytes.

   Teoremas: `Nexus.Modelos.Memoria.descomposicion_privada`, `Nexus.Modelos.Layout.perfil_65_corresponde_modelo`, `Nexus.Modelos.Memoria.backend_no_es_codificacion`, `Nexus.Modelos.Memoria.copias_suman`.

Obligaciones adicionales abiertas: La vinculación de versión y medición es documental R5, además de la aritmética Lean. No es una prueba universal de ABI/sizeof, RAM total, cantidad de entropía ni zeroización. Generalizar al compilador u objetivo actuales requiere evidencia adicional.

## M23 — NTT, producto matriz–vector y notación O

Estado: **modelo_verificado**.

1. Criterio original: Definir un modelo de operaciones y la familia asintótica; distinguir n fijo de n variable.

   Evaluación: Se fija el modelo de operaciones de campo y n=2^r; la cuenta exacta de mariposas y el caso fijo n=256 se distinguen de la familia variable.

   Teoremas: `Nexus.Complejidad.mariposas_cerrado`, `Nexus.Complejidad.costo_ntt_real`, `Nexus.Complejidad.ntt_es_O_n_log_n`, `Nexus.Complejidad.n_fijo_es_O`.

2. Criterio original: Derivar el recuento k*l, las transformadas y las cotas gruesa y optimizada.

   Evaluación: Se prueban k*l productos, transformadas compartidas y cotas gruesa y optimizada; la transformada algebraica conserva el producto negacíclico.

   Teoremas: `Nexus.Complejidad.productos_matriz`, `Nexus.Complejidad.transformadas_compartidas`, `Nexus.Complejidad.costo_matriz_fino`, `Nexus.Complejidad.matriz_es_O_fino`, `Nexus.Complejidad.matriz_gruesa_es_O`, `Nexus.Complejidad.matriz_optimizada_cota_gruesa`.

3. Criterio original: Enlazar el costo del algoritmo NTT con el del backend como obligación aparte.

   Evaluación: La identificación del orden, representación y coste del backend se conserva como obligación adicional explícita, tal como pide el criterio.

   Teoremas: `Nexus.Complejidad.perfil_256`.

Obligaciones adicionales abiertas: El coste es de operaciones de campo con factores de mariposa disponibles. Orden y Montgomery del backend, enteros y desbordamientos, muestreadores, hashes, coste de bits y tiempos CPU siguen separados; este cierre no afirma coste o equivalencia del ejecutable.

## M24 — Rechazo geométrico y costo esperado de firma

Estado: **modelo_verificado**.

1. Criterio original: Modelar intentos independientes con probabilidad de aceptación p>0 y probar E[N]=1/p.

   Evaluación: La distribución geométrica normalizada modela intentos IID con p>0; se prueban integrabilidad y E[N]=1/p.

   Teoremas: `Nexus.Complejidad.Rechazo.peso_ley`, `Nexus.Complejidad.Rechazo.pesos_suman_uno`, `Nexus.Complejidad.Rechazo.intentos_integrables`, `Nexus.Complejidad.Rechazo.esperanza_intentos`.

2. Criterio original: Para O(1), exigir una cota inferior uniforme positiva de p en la familia.

   Evaluación: El resultado O(1) requiere una barra p0>0 uniforme; la composición conserva O del coste de un intento y se demuestra un contraejemplo cuando falta la barra.

   Teoremas: `Nexus.Complejidad.Rechazo.intentos_esperados_O_uno`, `Nexus.Complejidad.Rechazo.costo_esperado_preserva_O`, `Nexus.Complejidad.firma_optimizada_O`, `Nexus.Complejidad.sin_cota_uniforme_no_O_uno`.

3. Criterio original: Conservar por separado el agotamiento del contador y la distribución del ejecutable.

   Evaluación: La cola de agotamiento se prueba para la ley ideal; distribución real, independencia y comportamiento al desbordar el contador permanecen como obligaciones de implementación separadas.

   Teoremas: `Nexus.Complejidad.Rechazo.probabilidad_agotamiento`, `Nexus.Complejidad.Rechazo.agotamiento_positivo`, `Nexus.Complejidad.Rechazo.agotamiento_tiende_cero`.

Obligaciones adicionales abiertas: No se deduce la ley IID ni p0 del bucle ML-DSA. La distribución real, estimaciones normativas de repeticiones y conducta del contador kappa u16/rollover mantienen su obligación R1-D; los límites del modelo no justifican ignorar agotamiento.

## M25 — Tamaños asintóticos y estructura de pruebas

Estado: **modelo_verificado**.

1. Criterio original: Precisar codificaciones y parámetros para cotas de claves y firmas.

   Evaluación: Un codec inyectivo de bits con inversa fija orden, cabecera, componentes, grado y ancho. Todos pueden variar en una familia; una cota uniforme de la cabecera da las cotas de claves y firmas.

   Teoremas: `Nexus.Complejidad.Comunicacion.Familias.codifica_inyectiva`, `Nexus.Complejidad.Comunicacion.Familias.decodifica_codifica`, `Nexus.Complejidad.Comunicacion.Familias.longitud_publica`, `Nexus.Complejidad.Comunicacion.Familias.longitud_firma`, `Nexus.Complejidad.Comunicacion.Familias.publica_familia_es_O`, `Nexus.Complejidad.Comunicacion.Familias.firma_familia_es_O`.

2. Criterio original: Contar capas, caminos y consultas para O(q log²N); no inferirlo de pocos tiempos medidos.

   Evaluación: Se cuentan capas, longitudes de caminos y consultas del formato declarado y se obtiene O(q log²N) para q fijo positivo; no se infiere a partir de benchmarks.

   Teoremas: `Nexus.Complejidad.Comunicacion.caminos_cota`, `Nexus.Complejidad.Comunicacion.suma_tg2_cota`, `Nexus.Complejidad.Comunicacion.consulta_tg2_cuadratica`, `Nexus.Complejidad.Comunicacion.bytes_tg2_cota`, `Nexus.Complejidad.Comunicacion.bytes_tg2_es_O`.

Obligaciones adicionales abiertas: Codec matemático de bits de ancho fijo y formato de prueba declarado. Falta equivalencia con empaquetado, serialización y parsing Rust; q fijo positivo y la cota eventual de cabecera son hipótesis explícitas. No se deduce tiempo de ejecución ni una asíntota uniforme en todos los parámetros sin esas hipótesis.

## M26 — Aritmética de mediciones: unidades, razones y redondeos

Estado: **parcial**.

1. Criterio original: Identificar datos fuente y versiones antes de calcular inversos, razones y diferencias.

2. Criterio original: Formalizar solo las cuentas y tolerancias; la medición permanece evidencia de una ejecución.

Pendiente: Identificar las corridas originales H1/H2, sus versiones y el alcance de los datos, junto con M44. Las cuentas y redondeos están probados; no certifican procedencia, causalidad ni capacidad sostenida.

## M27 — DA, incentivos y quórum como modelos de referencia

Estado: **modelo_verificado**.

1. Criterio original: Definir el juego y pagos antes de afirmar equilibrio de Nash o requisitos de colusión.

   Evaluación: Juego explícito de dos acciones, pagos y desviaciones unilaterales; el equilibrio honesto se caracteriza por una desigualdad necesaria y suficiente.

   Teoremas: `Nexus.Modelos.Incentivos.honestidad_nash_iff`, `Nexus.Modelos.Incentivos.desviacion_unilateral_rentable`, `Nexus.Modelos.Incentivos.deposito_suficiente`.

2. Criterio original: Precisar peso de stake, umbral estricto o inclusivo e intersección de quórums.

   Evaluación: Peso normalizado, intersección y desigualdades correctas para los umbrales estricto e inclusivo. El caso frontera muestra que inclusivo con un tercio bizantino no garantiza intersección honesta.

   Teoremas: `Nexus.Modelos.Quorum.interseccion_cota`, `Nexus.Modelos.Quorum.quorum_estricto_interseca_honestos`, `Nexus.Modelos.Quorum.quorum_inclusivo_requiere_menor_byzantino`, `Nexus.Modelos.Disponibilidad.Condicional.frontera_quorum_sin_interseccion_honesta`.

3. Criterio original: Expresar recuperación y muestreo DA como resultados condicionados; conservar TG1 intacto.

   Evaluación: Reed-Solomon se condiciona a suficientes evaluaciones distintas y cota de grado; DA a muestra uniforme sin reemplazo y conjunto disponible fijado antes. TG1 no se modifica.

   Teoremas: `Nexus.Modelos.Disponibilidad.recuperacion_reed_solomon`, `Nexus.Modelos.Disponibilidad.duplicar_no_recupera_dos_componentes`, `Nexus.Modelos.Disponibilidad.Condicional.omision_fragmentos_no_disponibles`.

Obligaciones adicionales abiertas: Son modelos de referencia, sin refinamiento del consenso, incentivos o DA desplegados. No se demuestra que atacar requiera mayoría coludida; se conserva esa afirmación de diseño fuera de los teoremas condicionados. No se alteran alcance ni documentos TG1.

## M31 — Límites del verificador legado y del conocimiento cero

Estado: **parcial**.

1. Criterio original: Representar el puente de raíces y su dominio, incluidos alias y rango de índices.

2. Criterio original: Formalizar la reconstrucción del testigo del ejemplo pequeño si se usa como resultado matemático.

3. Criterio original: No convertir pruebas de casos ni ausencia de enmascaramiento en una prueba general de solidez.

Pendiente: Identificar y extraer los nodos y evaluaciones concretos de los certificados del ejemplo; enlazar su reconstrucción con esos certificados y el verificador legado. La interpolación condicional ya probada no establece esa correspondencia ni conocimiento cero general.

## M33 — Torres FRI y recuperación adaptativa

Estado: **modelo_verificado**.

1. Criterio original: Conservar representantes, plegado, recuperación y excepciones previas al reto ya demostrados.

   Evaluación: La torre conserva los dominios y representantes; se recupera el polinomio desde el acuerdo y se construyen excepciones por capa antes del reto.

   Teoremas: `Nexus.FRI.dominios_cuadrados`, `Nexus.FRI.control_capa`, `Nexus.FRI.recuperar_torre`, `Nexus.FRI.lema_B`, `Nexus.FRI.lema_B_muestreo`.

2. Criterio original: Separar el lema elemental mecanizado del corolario bibliográfico general y del cambio uniforme beta/a_j.

   Evaluación: La equivalencia de beta con peso afín y la normalización global beta/a se prueban por biyección; se separan del corolario bibliográfico general y no se atribuye independencia entre puntos.

   Teoremas: `Nexus.FRI.Afin.recuperar_coeficiente`, `Nexus.FRI.Afin.coeficiente_recuperar`, `Nexus.FRI.Afin.formula_afin`, `Nexus.FRI.Afin.mismo_reto_acopla_puntos`, `Nexus.FRI.Afin.preimagen_evento_cardinal`, `Nexus.FRI.Afin.plegado_coset`, `Nexus.FRI.Afin.coset_uniforme_cardinal`.

Obligaciones adicionales abiertas: Se cierra el lema elemental y el cambio uniforme de coordenadas bajo sus hipótesis. Corolario bibliográfico general, transformación integral de transcripciones, adaptador Rust y composición global ROM siguen separados. Una biyección por punto no produce retos independientes para puntos distintos.

## M35 — Muestra compartida e hipergeométrica H

Estado: **parcial**.

1. Criterio original: Conservar conteo de parejas, techo, muestreo sin reemplazo y consulta compartida ya probados.

2. Criterio original: Relacionar la muestra uniforme ideal con el selector implementado sin suponer independencia de ambos FRI.

Pendiente: Derivar de todas las historias del protocolo las claves frescas y leyes de entrada del selector implementado, con la tabla compartida. Conservar la muestra común de ambas fases FRI; no suponer independencia entre ellas.

## M36 — Solidez ideal por rondas y reinicios

Estado: **parcial**.

1. Criterio original: Conservar cotas de estado, transcripciones, reinicios y Tabla 6.22 ya mecanizados.

2. Criterio original: Completar la correspondencia externa y la revisión independiente; no identificar B ideal con consultas hash.

Pendiente: Completar el adaptador externo de rondas y reinicios y obtener revisión independiente. El autor declaró que no hay dictamen. El presupuesto de inicios ideal B no equivale automáticamente a consultas hash.

## M37 — Extracción Merkle, bytes y orden temporal ROM

Estado: **parcial**.

1. Criterio original: Conservar extracción, congelación y órdenes de primeras consultas bajo ausencia de aciertos.

2. Criterio original: Obtener los hechos de registro y familias causales para todas las historias del protocolo.

Pendiente: Construir las familias causales y los hechos de registro para todas las historias del protocolo usando una tabla común, a partir de sus eventos y gramática reales.

## M39 — Presupuestos, formas, gramática y semántica del verificador

Estado: **parcial**.

1. Criterio original: Justificar V_T, B_T y S=Q+V_T a partir de listas, rechazos, serialización e índices.

2. Criterio original: Enlazar los modelos tipados con enteros de máquina y el verificador Rust.

Pendiente: Derivar todas las formas, rechazos y presupuestos de la gramática, serialización, deserialización e índices del verificador Rust y su semántica de enteros de máquina.

## M40 — Potencial de nonces y cola del selector

Estado: **parcial**.

1. Criterio original: Probar la cola tau_T y el potencial de candidatos antes de su primera respuesta.

2. Criterio original: Tratar abandono, intercalación, duplicados y el factor de trabajo sin condicionarlo a un nonce ya encontrado.

Pendiente: Instanciar el potencial con los árboles de candidatos reales, sus conjuntos buenos, leyes, nonces, trabajo y tabla compartida antes de responder; cubrir abandono, intercalación y duplicados sin condicionar a un nonce encontrado.

## M41 — Cota ROM completa y ejemplo numérico

Estado: **parcial**.

1. Criterio original: Conservar la cota parametrizada del evento excepcional del registro.

2. Criterio original: Demostrar la composición de los tres términos con sesgos, selector, presupuestos y adaptador causal.

3. Criterio original: Certificar el ejemplo numérico solo después de fijar las hipótesis completas.

Pendiente: Probar las inclusiones y leyes de los eventos del ejecutable bajo un mismo experimento e instanciar la composición de los tres términos con el adaptador causal, sesgos, selector y presupuestos. La aritmética numérica existente es condicional.
