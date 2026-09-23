# Pendientes — Tesis NEXUS (TG2)

**Actualizado:** 2026-09-23. Seguimiento vigente; el historial se conserva en [BITACORA_TG2.md](BITACORA_TG2.md).

**Accesos:** [Ruta de cierre](Documentos/04-Administrativo-TG2/Ruta-de-Cierre-TG2.md) · [Matriz de trazabilidad](Documentos/05-Estado-del-Arte/Resumenes-y-Matriz/Matriz-Trazabilidad-TG2.md) · [Revisión de la bitácora](Documentos/04-Administrativo-TG2/Avances/Revision-Bitacora-2026-09-22.md).

## Acuerdos y evidencia

- [x] Registrar la aprobación del director al plan, entrega y decisiones presentadas, confirmada por el estudiante el 22 de septiembre.
- [ ] Incorporar fecha exacta, comunicación y calendario acordado cuando estén disponibles.
- [x] Crear la matriz de trazabilidad de afirmaciones y requisitos TG2.
- [x] Preservar los resultados Criterion y fuentes de experimentos disponibles: 125 archivos y 29 casos en el inventario.
- [ ] Conciliar las diferencias entre la caché recuperada y las cifras históricas; identificar revisión, fecha y condiciones de cada corrida.
- [x] Consolidar los cambios locales de TG2 y experimentos en `nexus`: commit `01dcde960402b6c60a19242b7ae3d6ac3d82a518`, con 197 pruebas, check y build correctos.
- [x] Corregir las exclusiones de Git para incluir las fuentes de evidencia, crear el índice principal y documentar las dependencias y reproducción.

## Objetivo 4 — validación formal (R1)

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
- [ ] Completar Q1–Q5 del informe QROM: extractor sobre base sin orden, cadena de índices y nonces, enlace AIR/FRI, pérdidas del verificador y parámetros. La cota parcial llega a uno desde Q=451 para T=4096,g=20; no demuestra un ataque ni acredita 100 bits.
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
- [x] Revisar la edición Word/PDF: tablas y celdas comparadas, rótulos y tablas juntos en Word; PDF sin páginas vacías ni texto fuera de los márgenes. El inventario vigente se conserva en `Documentos/06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/`.
- [x] Integrar los resultados disponibles de R1–R5 en el [balance de objetivos](Documentos/04-Administrativo-TG2/Entrega-Final/Balance-Objetivos-TG2.md) y preparar el [índice de entrega](Documentos/04-Administrativo-TG2/Entrega-Final/README.md) con manifiesto de archivos y commit de código.
- [ ] Registrar dictamen y resolver o delimitar las obligaciones del balance antes de declarar entrega definitiva.
- [x] Preparar el [guion de sustentación](Documentos/04-Administrativo-TG2/Presentaciones/Guion-Sustentacion-TG2.md).
- [ ] Completar diapositivas y ensayo según duración y requisitos institucionales.

Los documentos administrativos históricos de TG1 se conservan. La edición vigente del manuscrito actualiza su enfoque a sistemas en general por aclaración expresa del autor del 22 de septiembre. Deception Engine, pagos agénticos, consenso y aritmetización completa de la lógica de aplicación conservan el alcance complementario o futuro definido en la ruta.
