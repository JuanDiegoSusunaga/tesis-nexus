# Pendientes — Tesis NEXUS (TG2)

**Actualizado:** 2026-10-17. Seguimiento vigente; el historial se conserva en [BITACORA_TG2.md](BITACORA_TG2.md).

**Accesos:** [Ruta de cierre](Documentos/04-Administrativo-TG2/Ruta-de-Cierre-TG2.md) · [Matriz de trazabilidad](Documentos/05-Estado-del-Arte/Resumenes-y-Matriz/Matriz-Trazabilidad-TG2.md) · [Revisión de la bitácora](Documentos/04-Administrativo-TG2/Avances/Revision-Bitacora-2026-09-22.md).

**Decisión del autor, 23 de septiembre:** la transferencia QROM completa del protocolo AIR/FRI queda como **trabajo futuro**. Su demostración no bloquea esta ruta de cierre de TG2. Se conservan los resultados parciales y sus límites; el trabajo activo se concentra en revisión y consolidación documental. La sustentación queda aplazada por indicación del autor del 12 de octubre.

## Acuerdos y evidencia

- [x] Registrar la aprobación del director al plan, entrega y decisiones presentadas, confirmada por el estudiante el 22 de septiembre.
- [ ] Incorporar fecha exacta, comunicación y calendario acordado cuando estén disponibles; actualizar F0, fechas E0–E4 y revisión de la entrega parcial, distinguiendo preparación, envío y aprobación.
- [x] Crear la matriz de trazabilidad de afirmaciones y requisitos TG2.
- [x] Preservar los resultados Criterion y fuentes de experimentos disponibles: 125 archivos y 29 casos en el inventario.
- [x] Conciliar y clasificar R4 y complemento mediante 451 comprobaciones; separar las nueve cifras H2 publicadas de la caché recuperada y rotular sus límites. [Revisión con fuentes web](Documentos/04-Administrativo-TG2/Avances/Revision-Subagentes-2026-10-12/Revision-Evidencia.md).
- [ ] Recuperar la identidad exacta de las corridas históricas H1/H2 donde faltan revisión y resultados originales; conservar su limitación hasta que exista evidencia, sin sustituirla por la caché.
- [ ] Medir de nuevo solo si se amplían las afirmaciones al rendimiento TG2 v1, capacidad de la aplicación, comparación causal de equipos o residencia física. La conciliación disponible no exige repetir R4.
- [x] Consolidar los cambios locales de TG2 y experimentos en `nexus`: commit `01dcde960402b6c60a19242b7ae3d6ac3d82a518`, con 197 pruebas, check y build correctos.
- [x] Corregir las exclusiones de Git para incluir las fuentes de evidencia, crear el índice principal y documentar las dependencias y reproducción.

## Formalización integral del manuscrito — Lean

- [x] Registrar 1393 resultados en 154 módulos y comprobar compilación, axiomas y replay del núcleo, con los límites de importación declarados. [Auditoría](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Modelos-Pendientes/README.md).
- [x] Conservar los 272 candidatos y 14 suplementos; registrar 187 bloques y diez suplementos con pruebas parciales y alcance explícito. [Matriz de obligaciones](formalizacion/REVISION-MANUSCRITO.md).
- [x] Conciliar resumen/abstract, unidades y bytes de hoja con copias anteriores; regenerar Markdown, Word y PDF y revisar sus 110/99 páginas. [Manuscrito conciliado](Documentos/06-Evidencia-TG2/2026-10-17/Manuscrito-Modelos/README.md).
- [ ] Completar los 24 grupos parciales: reducciones y simulación, correspondencia con codecs y aritmética concreta, recorrido FRI, canal causal, potencial adaptativo y composición ROM. Los 16 modelos verificados solo cierran sus alcances expresos.
- [ ] Resolver las tres dependencias bibliográficas y aportar los dos respaldos documentales; mantener QROM AIR/FRI como trabajo futuro conforme a la decisión del autor.
- [ ] Incorporar revisión independiente. El autor confirmó «No hay dictamen»; no se marca como aprobada la tesis ni se infiere un porcentaje de los conteos.

## Objetivo 4 — validación formal (R1)

- [x] Revisar con tres subagentes y fuentes web primarias; integrar límites del hash externo SHA3-256/ML-DSA, fuente retenida y compuerta de salud, conformidad no certificada, literatura FFH y terminación extrema. [Paquete de revisión](Documentos/04-Administrativo-TG2/Avances/Revision-Subagentes-2026-10-12/README.md).
- [x] Complementar M1–M6 y la matriz con el [catálogo verificable de afirmaciones](Documentos/04-Administrativo-TG2/Avances/Catalogo-Validacion-2026-10-12/README.md): hipótesis, dependencias, localizadores y huellas de evidencia. La comprobación documental no cierra las demostraciones ni el dictamen.
- [x] Corregir el argumento de extracción del capítulo 6 y retirar su conclusión injustificada.
- [x] Documentar la procedencia del término 2^-254 y evitar atribuirlo sin justificación al prototipo.
- [x] Incorporar las correcciones de pruebas publicadas en 2023 y las restricciones de la reducción QROM revisada en 2024.
- [x] Separar supuestos, reducciones de peor caso y argumentos sobre Shor.
- [x] Identificar perfil, parámetros, oráculos y diferencias de ML-DSA; cotejar fuentes completas y reproducir los cálculos de R1.
- [x] Comprobar que la aplicación directa de JMW24 falla para los tres perfiles; explicitar la pérdida corregida y el alcance ROM/QROM.
- [x] Incorporar las actualizaciones potenciales NIST de julio de 2026 y ejecutar tres pruebas de correspondencia; total 166.
- [ ] Resolver R1-A–D si se exige una garantía concreta del código: expansión/hedged, codificaciones/sUF, fuente/KDF y errores extremos del bucle.
- [ ] Registrar la revisión matemática del texto corregido con el director o un lector competente.

## Objetivo 3 — entropía y rotación (R2–R3)

- [x] Aplicar el corte APT aprobado y comprobar conteo de referencia y condición de disparo: C=16, W=512.
- [x] Implementar lotes de 65.536 muestras, bloqueo inicial, fallo retenido y recuperación explícita seguida de renovación de semilla.
- [ ] Vincular y calificar una fuente concreta de despliegue; el prototipo evalúa el flujo entregado por la aplicación y no acredita acceso al ruido físico del sistema operativo.
- [x] Conectar rotación de Sentinel con claves operativas y vigencia de épocas en `KeyManager`; fallo intermedio conserva el estado previo.
- [x] Implementar y verificar el registro local autenticado, recuperación del historial público y comprobación de firmas históricas con límites explícitos.
- [ ] Integrar custodia durable, política de épocas en el sequencer y anclaje L1; validar el enlace completo en R4.
- [x] Verificar la corrección R2: cargo check/build y 123 pruebas del workspace, incluidas 13 nuevas, el 22 de septiembre; capítulo 5 actualizado. R3 pasa check/build y 142 pruebas, incluidas 19 nuevas; evidencia separada en `R3-rotacion/`.

## Evidencia experimental y contribución (R4–R5)

- [x] Revisar y corregir en una variante experimental el inicio y denominador del ensayo multinúcleo; tres pruebas pasan.
- [x] Medir el ensayo multinúcleo corregido: cinco repeticiones por punto; mediana de 136.390 verificaciones/s con 24 hilos. La cifra histórica conserva sesgo temporal posible.
- [x] Reproducir y delimitar aceptación heredada, raíces parciales y recuperación del testigo de 16 filas; variante canónica TG2 evaluada en quince pruebas.
- [x] Auditar el presupuesto STARK, parámetros efectivos, transcripción y proximidad; siete pruebas nuevas pasan en ambos perfiles.
- [x] Desarrollar S1 bajo hipótesis explícitas: divisibilidad, cancelación y distancia para una traza polinómica fija; siete pruebas algebraicas pasan en ambos perfiles.
- [x] Derivar la transferencia condicional de distancia para un oráculo próximo a esa traza (S2).
- [x] Refutar la premisa propuesta de S2 para el legado: tres pruebas reales aceptadas con trazas a distancia 7/8 del código de grado < T; enunciados válidos.
- [x] Implementar y probar un control exhaustivo experimental del LDE: rechaza los tres casos por grado y acepta la ejecución honesta.
- [x] Implementar y probar una variante TG2 con FRI de traza y AIR vinculados por la misma raíz; acepta casos honestos y rechaza los tres oráculos alejados reutilizados, sin recibir el LDE completo.
- [x] Derivar una cota conservadora de composición interactiva ideal: candidato único fijo, campo base, dos FRI y enlace local; reproducir nueve perfiles y contrastes numéricos.
- [x] Auditar Merkle/Fiat–Shamir: 14 certificados, 560 consultas y 18.880 aperturas reconstruidos; sesgo de campo y condiciones de compilación documentados.
- [x] Preparar el paquete de revisión matemática S1–S3 con seis preguntas y evidencia enlazada.
- [x] Abrir `investigacion/cierre-matematico-tg2` en documentos y código; escribir una función de estado por rondas para AIR y ambos FRI, con un lema elemental de acuerdo y nuevas cotas ideales. [Derivación de la rama](Documentos/04-Administrativo-TG2/Avances/Cierre-Matematico-2026-09-23/README.md).
- [x] Integrar la rama de investigación en `main` de ambos repositorios y escribir la [transferencia al protocolo TG2 v1 en ROM clásico](Documentos/04-Administrativo-TG2/Avances/Transferencia-ROM-2026-09-23/README.md): extracción por registro hash, canal, nonces adaptativos, pérdidas y 108 escenarios.
- [x] Completar el verificador Python independiente de AIR y ambos FRI: ocho certificados honestos aceptados y seis alejados rechazados como en Rust; once pruebas nuevas.
- [x] Completar una [revisión crítica interna de ROM](Documentos/04-Administrativo-TG2/Avances/Revision-Critica-ROM-2026-09-23/README.md): potencial para nonces adaptativos, controles negativos de premisas y 96 escenarios exactos; doce pruebas nuevas.
- [ ] Revisar independientemente las demostraciones por rondas y ROM, incluyendo el nuevo argumento por potencial y la cola de índices. Registrar decisión de alcance sobre S1–S3 (S3–S5).
- [ ] Estudiar parámetros fijando presupuesto adversario Q y probabilidad objetivo; distinguir esa probabilidad del trabajo estimado de ataque.
- [x] Iniciar [QROM para TG2 v1](Documentos/04-Administrativo-TG2/Avances/QROM-2026-09-23/README.md): reducción parcial basada solo en trabajo, 108 perfiles exactos, doce pruebas nuevas y contraste con CMS19/DFM20.
- [x] Proponer el [extractor sin orden y la cota de escapes AIR/FRI en la base comprimida](Documentos/04-Administrativo-TG2/Avances/Extractor-QROM-2026-09-23/README.md): avance Q1 y Q3, 45 escenarios y catorce tests nuevos; dictamen pendiente.
- [x] Formular el [muestreo QROM y la reducción condicional al verificador](Documentos/04-Administrativo-TG2/Avances/Muestreo-QROM-2026-09-23/README.md): sufijo de índices/nonces, cobertura de eventos, expansión acotada y pérdida del lema 4.9 de CMS19. Se registran 72 presupuestos y 28 recorridos; pasan 80 Python y 197 Rust.
- [x] Proponer una [cota cuántica de cola](Documentos/04-Administrativo-TG2/Avances/Cola-QROM-2026-09-23/README.md) por conteo de respuestas y recurrencia de amplitudes: 144 perfiles, 16 no triviales con cortes mayores del análisis; 16 tests nuevos y regresión de 96 Python/197 Rust. Dictamen pendiente.
- [x] Preservar nueva serie R4: 17 casos Criterion y 40 mediciones STARK, con dispersión, fuentes y metadatos.
- [x] Completar los dos benchmarks tras el cambio de Windows por el autor; fuentes, configuración y resultados conservados en R4-complemento.
- [x] Definir el modelo de amenaza y residencia de regiones, inventario de representaciones y sensibilidad; tres pruebas R5 pasan.
- [ ] Medir todas las copias y residuos bajo una frontera explícita e integrar custodia/política de residencia antes de afirmar protección efectiva.
- [ ] Integrar el cierre de las decisiones 001–003 al balance técnico cuando exista evidencia.

La [auditoría Merkle/Fiat–Shamir](Documentos/04-Administrativo-TG2/Avances/R4-Merkle-Fiat-Shamir-2026-09-23.md) precisa las condiciones pendientes; el [paquete de revisión](Documentos/04-Administrativo-TG2/Avances/Revision-Matematica-S1-S3-2026-09-23.md) está preparado, sin envío ni dictamen registrados. La [derivación de composición ideal](Documentos/04-Administrativo-TG2/Avances/R4-Cota-Interactiva-2026-09-22.md) obtiene cotas conservadoras sin atribuirlas al ejecutable. Check/build y las 197 pruebas se repitieron correctamente el 23 de septiembre. La suite vigente pasa **197 pruebas** en desarrollo; los diez casos de FRI vinculada pasaron también en release el 22 de septiembre. Check/build correctos. [Variante vinculada, formato y límites](Documentos/04-Administrativo-TG2/Avances/R4-FRI-Vinculado-2026-09-22.md). [Contraejemplo y control exhaustivo](Documentos/04-Administrativo-TG2/Avances/R4-Proximidad-Traza-2026-09-22.md). [Argumento AIR/FRI y límites](Documentos/04-Administrativo-TG2/Avances/R4-Algebra-AIR-FRI-2026-09-22.md). [Informe STARK](Documentos/04-Administrativo-TG2/Avances/R4-Solidez-STARK-2026-09-22.md). [Informe R1](Documentos/04-Administrativo-TG2/Avances/R1-Correspondencia-Formal-2026-09-22.md). Los informes anteriores conservan sus conteos históricos.

[Informe R5 y complemento R4](Documentos/04-Administrativo-TG2/Avances/R5-Residencia-y-Custodia-2026-09-22.md).

## Manuscrito y entrega (R6)

- [x] Registrar y aplicar la aclaración del autor: NEXUS se presenta para sistemas en general, con arquitectura blockchain dual como modelo de referencia.
- [x] Conciliar el estado técnico de TG2 en resumen, capítulos 5–7 y conclusiones.
- [x] Crear ensamblado reproducible y comprobación estructural de tablas entre Markdown y Word.
- [x] Revisar la edición Word/PDF: tablas y celdas comparadas, rótulos y tablas juntos en Word; PDF sin páginas vacías ni texto fuera de los márgenes. El inventario de la edición del 12 de octubre está en `Documentos/06-Evidencia-TG2/2026-10-12/`; la carpeta anterior R4-Merkle-FS conserva su registro histórico.
- [x] Integrar los resultados disponibles de R1–R5 en el [balance de objetivos](Documentos/04-Administrativo-TG2/Entrega-Final/Balance-Objetivos-TG2.md) y preparar el [índice de entrega](Documentos/04-Administrativo-TG2/Entrega-Final/README.md) con manifiesto de archivos y commit de código.
- [ ] Registrar dictamen y resolver o delimitar las obligaciones del balance antes de declarar entrega definitiva.
- [x] Integrar los complementos por rondas, ROM y potencial en el manuscrito y en las derivaciones del 12 de octubre, identificándolos como propuestas pendientes de dictamen. Regenerar y revisar Word/PDF, ecuaciones, tablas y figuras, y registrar la nueva edición. QROM de AIR/FRI permanece como trabajo futuro.
- [ ] Contrastar la entrega definitiva con la plantilla institucional específica si el programa la exige.
- [x] Preparar el [guion de sustentación](Documentos/04-Administrativo-TG2/Presentaciones/Guion-Sustentacion-TG2.md).
- [ ] Sustentación aplazada por indicación del autor el 12 de octubre; retomar diapositivas y ensayo cuando lo solicite. El guion histórico se conserva.

## Trabajo futuro — QROM del protocolo AIR/FRI

Por decisión del autor, estas tareas quedan fuera del cierre activo de TG2. Se retomarán cuando lo solicite expresamente. Los avances conservados no acreditan una garantía QROM completa; esta decisión no modifica las obligaciones R1 sobre ML-DSA ni sus fuentes.

- [ ] Demostrar una cota útil β^S para omitir las parejas incorrectas bajo consultas cuánticas (Q2). La cota disponible solo cubre cola y sigue siendo trivial con R=512 en los perfiles tabulados.
- [ ] Revisar independientemente la cota de cola, el extractor, la cobertura de aceptación falsa y el cambio de juego (Q1, Q3–Q4); registrar el dictamen de esa investigación en [M1–M6](Documentos/04-Administrativo-TG2/Avances/Revision-Matematica-S1-S3-2026-09-23.md).
- [ ] Evaluar conjuntamente los parámetros QROM (Q5) cuando exista una cota de omisión: presupuesto Q, corte R, costo Q+V, pérdidas de campo y de salida, y probabilidad objetivo.

Los documentos administrativos históricos de TG1 se conservan. La edición vigente del manuscrito actualiza su enfoque a sistemas en general por aclaración expresa del autor del 22 de septiembre. Deception Engine, pagos agénticos, consenso y aritmetización completa de la lógica de aplicación conservan el alcance complementario o futuro definido en la ruta.
