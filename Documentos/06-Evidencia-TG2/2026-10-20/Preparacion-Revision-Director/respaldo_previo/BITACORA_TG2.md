# 📓 Bitácora de Trabajo de Grado 2 (TG2) — Proyecto NEXUS

**Estado al 20 de octubre:** la tesis está sincronizada con Rust y `ActiveChain`, commit local `637e77c99e804664915caf4ed928a10ef81cc870`, y pasa la global final de 223 pruebas, check y build. La documentación quedó consolidada en `a9faf0e`; con autorización posterior se incorporan también las fuentes Lean ya auditadas y sus herramientas en un commit local separado, sin push, nuevas compilaciones ni regeneración del manuscrito. Word/PDF permanecen en las salidas revisadas de 115/103 páginas; las fuentes, objetivos, fórmulas e hipótesis siguen intactos. Las entradas fechadas anteriores mantienen su carácter histórico y no acreditan validez L2 completa ni equivalencia universal.

## Consolidación local de Lean y herramientas — 20 de octubre de 2026

El autor responde «Dale» a versionar las fuentes Lean ya comprobadas, sus herramientas de reproducción y conciliar los README, sin compilar ni hacer push. La base documental es `a9faf0e66af1400991ac5b0215c770f96ad712b8`, cuyo índice estaba vacío; el commit Rust continúa en `637e77c` y su árbol limpio. Antes de editar se verifica el manifiesto de 9662 archivos y se respaldan nueve archivos de documentación, atributos y manifiesto, incluido el README raíz con cambios locales previos. Se incorporan 361 archivos de formalización y siete scripts/pruebas Python existentes, sin añadir módulos ni modificar sus demostraciones. Las dependencias, `.lake/`, `.tools/`, cachés Python, `tmp/` y la presentación aplazada quedan excluidos.

La revisión textual comprueba la sintaxis de los siete scripts y la resolución de 878 importaciones locales en los 347 submódulos Nexus y su raíz; no ejecuta sus lanzadores ni pruebas. Se concilian los README raíz, de formalización y de herramientas: la auditoría vigente cuenta 2709 declaraciones y la global Rust 223 pruebas; los recuentos y pendientes de las etapas anteriores se rotulan como históricos. Se aclara qué comandos sí compilan y requieren autorización. Se conservan los límites del ROM clásico finito, el AIR escalar, el refinamiento universal y el dictamen independiente.

La [preparación de consolidación](Documentos/06-Evidencia-TG2/2026-10-20/Consolidacion-Lean/preparacion.json) conserva las huellas, autorización y respaldos. Las 354 fuentes/configuraciones Lean, 89 Rust y doce fuentes/salidas del manuscrito coinciden con los registros previos; no se reejecutan las compilaciones, auditorías ni pruebas. Se actualiza el manifiesto conservando todas sus rutas anteriores y se cotejan los archivos seleccionados con los blobs Git antes de confirmar. El commit que contiene el manifiesto identifica la consolidación sin autorreferencia. La copia `consolidar.py` de evidencia es una instantánea del helper temporal `tmp/consolidar-lean-2026-10-20.py`; se conserva como procedencia, no como entrada autónoma para volver a compilar. Esta pasada guarda trabajo existente, no crea obligaciones matemáticas ni acredita revisión externa o aprobación académica.

## Consolidación documental local autorizada — 20 de octubre de 2026

El autor responde «Dale» a consolidar los cambios documentales en un commit local, sin push. Se revisa el índice inicialmente vacío y el árbol de trabajo; la base documental es `195b8133370a8157563e434c8a2489b5e27df17f`. Se comprueba la integridad del manifiesto anterior de 9653 archivos, respaldándolo con seguimiento, índices, atributos y generador antes de preparar la consolidación. El alcance incluye el manuscrito actual, sus salidas, la evidencia documental acumulada y los informes de integridad, el balance y catálogo asociados, la bitácora, los pendientes y el ajuste del generador que reconoce «Alcance de la tesis». Los atributos conservan los finales de línea de los archivos identificados por huellas.

Se dejan fuera `formalizacion/`, sus herramientas nuevas en `scripts/`, los cambios previos del README raíz, `tmp/`, la presentación aplazada y el repositorio independiente `nexus/`. No se modifica ni compila ninguna fuente Rust o Lean; los archivos `.lean` que aparecen dentro de copias históricas de evidencia son instantáneas documentales, no cambios al árbol de formalización. Por tanto, este commit no se presenta como una exportación Git autónoma de todo el proyecto: las fuentes Lean aún locales mantienen su situación de versionado separada de su auditoría previa.

La [preparación documental](Documentos/06-Evidencia-TG2/2026-10-20/Consolidacion-Documental/preparacion.json) conserva autorización, alcance y respaldos. Se actualiza el manifiesto sin reescribir registros cerrados y se cotejan los archivos seleccionados con los blobs del índice antes de confirmar. La revisión local resultante se identifica mediante el commit que contiene este manifiesto; su hash se obtiene con `git log -1 -- Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json`, evitando autorreferencias de hash dentro del propio commit. Se reutiliza la global de 223 pruebas sin repetirla y se conservan intactas las nueve fuentes y tres salidas del manuscrito. Sin push, nuevas pruebas, cambios matemáticos ni aprobación académica atribuida.

## Verificación global final de Rust después de ActiveChain — 20 de octubre de 2026

El autor responde «Dale» a una sola pasada global final de check/test/build de Rust, con caché y cuatro trabajos, sin recompilar Lean. Se comprueba primero la integridad de los 9641 archivos del manifiesto anterior y el árbol limpio del commit `637e77c99e804664915caf4ed928a10ef81cc870`. Se respaldan seguimiento, índices y manifiesto antes de actualizarlos. No había otra compilación Rust activa; se reutiliza `C:/tmp/nexus-target`, sin limpiar caché ni descargar o actualizar dependencias. La ejecución autorizada usa procesos ocultos, perfil de desarrollo, `--locked --offline --jobs 4` y cuatro hilos de pruebas.

Pasan en serie `cargo check --workspace --all-targets` (9,422 s), `cargo test --workspace` (34,266 s) y `cargo build --workspace` (4,359 s). La suite global actual ejecuta 223 pruebas: cero fallidas, ignoradas o filtradas. No es la suma de los conteos históricos de 197, 113 y 55; incluye en una sola ejecución el contrato adaptado y la integración local. Se conservan 52 diagnósticos de advertencia en check/test y 37 en build, principalmente importaciones, variables y miembros sin uso; no se corrigen ni se ocultan en esta pasada.

La [evidencia global final](Documentos/06-Evidencia-TG2/2026-10-20/Rust-Global-Final/verificacion.json) conserva comandos, versiones, tiempos, resultados y hashes de los tres logs. Las 89 fuentes/configuraciones Rust y 354 Lean permanecen idénticas; también las nueve fuentes Markdown y tres salidas del manuscrito. El árbol Rust queda limpio. Se actualizan únicamente seguimiento, índices y manifiesto para vincular este resultado posterior, preservando todos los antecedentes. Sin recompilar Lean, regenerar Word/PDF, añadir módulos, crear commit ni hacer push. Esta comprobación no demuestra refinamiento universal Rust/Lean ni transforma el AIR escalar en validación L2 completa, ni sustituye el dictamen matemático independiente.

## Conciliación de la tesis con Rust y ActiveChain — 20 de octubre de 2026

El autor responde «Dale» a sincronizar el manuscrito, distinguir Lean y Rust, documentar el límite del AIR escalar y regenerar Word/PDF sin compilar Rust ni Lean. Se respaldan las fuentes y salidas anteriores, los índices, seguimiento y manifiesto. Se actualizan resumen y abstract, arquitectura, evidencia funcional, validación y conclusiones: la ruta activa exige certificado vinculado y contexto externo, y `ActiveChain` lo obtiene de instantáneas privadas antes de registrar envíos. Se distinguen la ejecución global previa de 197 pruebas y las comprobaciones aisladas de 113 y 55, sin sumar conteos ni presentarlas como nueva global. Se explicitan el registro local en memoria, la separación optimista y los positivos sintéticos; las raíces SHA3 fuera del AIR se rechazan, sin anunciar validez de transacciones completas.

Se reutilizan los generadores del proyecto. La herramienta de renderizado del paquete de documentos falla por falta de `pdf2image`; se conserva el diagnóstico y se usa Word COM oculto para el Word y el exportador local sin interfaz con PyMuPDF para el PDF. La primera revisión encuentra las palabras clave del resumen en una página aislada: se acorta el resumen sin cambiar sus afirmaciones. También se corrige una frase descriptiva de §6.7.9 que aún atribuía a Rust un selector sin corte; ahora declara el corte compartido de 512 extracciones sin inferir equivalencia universal. La comparación con el respaldo confirma que el resto de esa sección, incluidas sus fórmulas e hipótesis, es idéntico.

Pasan el cotejo independiente de 34 tablas y 848 celdas, las comprobaciones de rótulos, márgenes y ausencia de páginas vacías, y la inspección visual de las 115 páginas de Word y 103 de PDF. Word conserva 606 ecuaciones nativas y tres figuras. Tras la última corrección solo cambian visualmente las páginas Word 95–97, que se vuelven a inspeccionar; las otras 112 imágenes son idénticas a las ya revisadas. Permanecen intactas 89 fuentes/configuraciones Rust y 354 Lean, sus registros previos y los objetivos originales. La [evidencia de conciliación](Documentos/06-Evidencia-TG2/2026-10-20/Conciliacion-Manuscrito-Rust/verificacion.json) y el manifiesto actualizado conservan la trazabilidad y sus antecedentes. No hay compilaciones Rust/Lean, nuevos módulos, commit, push ni nuevas obligaciones matemáticas. No se atribuyen refinamiento universal, cierre QROM, una L2 completa ni aprobación académica.

## Consolidación de ActiveChain y su manifiesto — 20 de octubre de 2026

El autor responde «Dale» a consolidar los cambios de integración en un commit. Se confirman exclusivamente los cinco archivos de `nexus` identificados por la evidencia en el commit `637e77c99e804664915caf4ed928a10ef81cc870`, hijo de `3e40e283dddc15502830f9fc220e556385f9d477`. Ninguna fuente `.rs` cambia desde las comprobaciones aisladas; solo se aclara en la documentación de reproducción la procedencia del commit y sus registros. Las 55 pruebas (trece nuevas), check y build corresponden a la ronda anterior, sin reejecución. El árbol Rust queda limpio, sin push ni commit del repositorio documental.

Se respaldan el seguimiento, los índices, el manifiesto vigente anterior y la nota de reproducción previa a consolidar. Se actualiza el manifiesto para identificar el nuevo commit y se vinculan las huellas del árbol de trabajo y de los objetos Git, incluida su normalización de finales de línea. La [evidencia de consolidación](Documentos/06-Evidencia-TG2/2026-10-20/ActiveChain/consolidacion.json) conserva la instantánea de integración y sus registros. Lean, dependencias, manuscrito y salidas Word/PDF permanecen intactos. No se atribuye validez de transacciones o raíces SHA3 generales al AIR escalar, refinamiento universal, consenso persistente, cierre QROM ni aprobación académica.

## ActiveChain con contexto local y verificación previa al registro de envío — 20 de octubre de 2026

El autor indica «Dale active chain» y responde «Sí, compilación aislada» a comprobar solo `nexus-active` y sus dependencias, con cuatro trabajos, sin workspace global ni Lean. Se respalda el código y seguimiento previos. `ActiveChain` conserva instantáneas privadas de los lotes construidos localmente; el perfil de filas/trabajo se fija por configuración y no por el certificado. El sobre incorpora entradas públicas y las APIs falibles devuelven `Result`. Se comprueban todos los metadatos de la instantánea, excepto la prueba aportada posteriormente. La ruta de validez/híbrido llama a `verify_expected` antes de registrar un envío. El modo optimista permanece provisional y separado; confirmar en L1 no se presenta como verificación del contrato.

Se captura la raíz inicial antes de ejecutar, se incorporan bloques completos al lote y se rota entre bloques sin atribuir a una fracción las raíces del bloque entero. La comprobación de capacidad incluye la longitud serializada; los límites de `ActiveChain` se alinean con su secuenciador. Los bloques vacíos conservan raíz y pueden cerrar lotes pendientes. Un mutex serializa producción y alturas; el contexto de lotes impide registrar dos envíos del mismo índice, incluso concurrentes. Las instantáneas permanecen recuperables tras rechazos. Este control es local en memoria y no se presenta como consenso, persistencia o antirrepetición integral.

El primer intento se detiene antes de compilar por acceso denegado a `C:/tmp/nexus-target/debug/.cargo-build-lock`. Se lee y conserva el log completo; la repetición autorizada fuera del sandbox pasa check, 55 pruebas y build, con cuatro trabajos/hilos y las advertencias conservadas. Son trece casos nuevos: siete unitarios y seis de API pública, incluidos alteraciones, filas/trabajo, certificados hostiles, duplicados, concurrencia, fronteras y vacíos. Los positivos de cableado usan instantáneas escalares sintéticas únicamente en pruebas internas; los lotes reales con raíces SHA3 fuera del modelo se rechazan y no registran raíces ni envíos de validez. No se recortan hashes ni se construye una recurrencia para anunciar validez de transacciones.

La [evidencia de integración](Documentos/06-Evidencia-TG2/2026-10-20/ActiveChain/integracion.json) identifica fuentes y registros. No se modifican Lean, dependencias, manuscrito ni salidas Word/PDF; no hay compilación global, commit ni push nuevos. El manifiesto y `3e40e28` se conservan como instantánea previa, no como identificación del árbol local posterior. Se atiende la conexión de API ya pendiente, sin crear obligaciones matemáticas ni atribuir refinamiento universal o validación L2 completa.

## Consolidación del commit Rust y su evidencia — 20 de octubre de 2026

El autor responde «Sí» a consolidar el cambio en un commit y actualizar la evidencia. Se confirman únicamente los doce archivos de la adaptación en `nexus`, commit `3e40e283dddc15502830f9fc220e556385f9d477`, hijo de `c5c466c6350e4ff06d04d27ed68b029095c7aec8`. Las fuentes Rust verificadas no cambian en esta consolidación; solo se precisa en `REPRODUCIBILIDAD_TG2.md` que los informes anteriores son instantáneas previas al commit. Se conserva la evidencia de 113 pruebas aisladas sin reejecutarla; no se compila Rust ni Lean y no se regeneran Word/PDF. El árbol Rust queda limpio; no se realiza push ni commit de los cambios documentales previos de la tesis.

Se actualizan los índices, el seguimiento y el manifiesto para identificar el nuevo commit y sus registros. El manifiesto del 19 permanece recuperable con su SHA256 original; también se respaldan el seguimiento y los índices antes de editarlos. La [consolidación](Documentos/06-Evidencia-TG2/2026-10-20/Rust-Lean/consolidacion.json) conserva las huellas de las fuentes comprobadas, los objetos Git y la normalización de finales de línea del commit. No se atribuye refinamiento universal Rust/Lean, integración completa con `ActiveChain`, aprobación académica ni cierre QROM.

## Revisión estática final Rust/Lean — 20 de octubre de 2026

Con autorización del autor para el punto 1 se revisa el cambio final, sin compilar, repetir pruebas Rust/Lean ni modificar sus fuentes. No se encuentran hallazgos bloqueantes en el alcance inspeccionado: lectura LE estricta, rechazos previos al hash, perfiles externos, orden del canal, cuarenta índices distintos en hasta 512 extracciones, seis aperturas AIR, ambas FRI y registro posterior a la aceptación. La comprobación independiente de dimensiones abarca los nueve tamaños admitidos, 65.408 puntos del coset sin polos y 196.224 posiciones AIR dentro de rango. El máximo de forma es 760.286 bytes frente al límite de 2 MiB; la cuenta de hashes llega a 24.895 para k=12 y R=512, consistente con el modelo, sin atribuirle una medición de tiempo ni prueba de máquina.

Permanecen idénticas las 88 fuentes Rust de la adaptación, 354 fuentes/configuraciones Lean y doce fuentes/salidas del manuscrito. Se cotejan también los registros previos y los tres logs de la ronda aislada; sus 113 pruebas no se reejecutan. Se conserva expresamente el límite de integración: `ActiveChain` no llama aún a `verify_expected` y el sobre histórico de `create_state_proof` no constituye validación L2 por el contrato escalar. La revisión no demuestra refinamiento universal ni crea obligaciones matemáticas nuevas. No se crea commit, no se actualiza el manifiesto de entrega ni se regeneran Word/PDF. [Resultado y comprobaciones](Documentos/06-Evidencia-TG2/2026-10-20/Rust-Lean/revision-final.json).

## Verificación global y adaptación Rust al contrato Lean — 20 de octubre de 2026

El autor autoriza primero compilación global de Rust y revisión de la ruta activa; añade expresamente otra compilación global de Lean y, después, indica «Tenemos que adaptar rust a lean». Antes de editar código pasan cargo check --workspace --all-targets, cargo test --workspace (197 pruebas) y cargo build --workspace, con dependencias locked/offline, cuatro trabajos y caché existente. Los registros conservan las advertencias. También pasan `python scripts/lean.py build` (4084 trabajos) y la auditoría global de 2709 declaraciones, sin errores, advertencias, sorryAx ni axiomas fuera de propext/Classical.choice/Quot.sound. Es compilación incremental; no se limpia mathlib ni se repite leanchecker separado.

Se conservan las 83 fuentes Rust previas y el seguimiento documental antes de cambiar la implementación. La revisión confirma que el verificador canónico experimental seguía usando el STARK heredado, mientras la doble FRI vinculada estaba fuera de la API normal. Se incorpora el contrato vinculado a `nexus-zk::stark::linked`, con perfil externo de 12/20 bits, 16–4096 filas, cuarenta índices distintos en orden y rechazo tras 512 extracciones, incluidos duplicados. `linked_codec` lee el formato `(TransitionStatement, LinkedProof)` con LE explícito, EOF estricto, campos canónicos y cantidades exactas verificadas antes de asignar vectores; no usa longitudes remotas como capacidades libres.

`nexus-active::linked_verifier` comprueba tipo, altura, entradas y escalares frente a un contexto suministrado separadamente por el llamante. `NitroVerifier::verify_expected` registra raíces solo después de aceptar y no sobrescribe una altura con otra raíz. La entrada sin contexto rechaza validez e híbrido, sin fallback ni decisión por tamaño. La ruta optimista queda separada y deja de marcar como verificada una raíz pendiente antes de finalizar. El puente antiguo y los experimentos se conservan con límites explícitos, fuera de la aceptación nueva. Se corrige la documentación del cálculo heurístico `budget()`: no acredita 100 bits ni implementa la cota Lean.

Pasan dos rondas aisladas de check/test/build para `nexus-zk` y `nexus-active`, con 113 pruebas, trece nuevas. Se contrastan los catorce certificados históricos de ambos perfiles: ocho honestos aceptados y seis alejados rechazados, con codificación idéntica. Las pruebas nuevas incluyen corte exacto 512 frente a necesidad de 513 extracciones, duplicados, truncamiento, sufijos, cantidades hostiles, campos no canónicos, perfiles, contexto y ausencia de registro tras rechazo. Se actualizan las aserciones de aceptación heredada para exigir rechazo en la entrada activa, conservando el código previo en el respaldo. El workspace global no se vuelve a compilar tras editar. La herramienta rustfmt no estaba instalada para la toolchain activa; no se instala ni se modifican dependencias.

La [evidencia de adaptación](Documentos/06-Evidencia-TG2/2026-10-20/Rust-Lean/adaptacion.json) vincula fuentes, registros y el contrato de Lean. Este cambio no demuestra refinamiento universal de Rust, garantías de SHA3 fuera del ROM, QROM ni una L2 completa. No se alteran la formalización, los entregables históricos ni las fuentes/salidas del manuscrito; no se regeneran Word/PDF. Las raíces SHA3 arbitrarias siguen fuera del AIR escalar y no se recortan para hacerlas pasar. La altura y las políticas de autorización/antirrepetición siguen siendo condiciones externas. El código queda como cambios locales sin commit; se conserva intacto el manifiesto de entrega del 19 y se identifica aparte la instantánea de trabajo, sin presentarla como entrega aprobada.

## Corrección de coherencia integral — 19 de octubre de 2026

Con autorización del autor («corriguelas»), se atienden en una sola pasada los seis grupos CI01–CI06. Se conservan literalmente el objetivo general y los cuatro objetivos específicos; se explicita el cumplimiento parcial de la reducción concreta de seguridad de las firmas, sin sustituirla por el resultado ROM de AIR/FRI. Se distingue min-entropía marginal y conjunta, con hipótesis IID y contraejemplo correlacionado. Se precisan los umbrales de peso bizantino y quórum, las reglas honestas y el criterio condicional de incentivos, sin inferir tolerancia universal a colusión. La amortización exige prueba sublineal y política de disponibilidad; la comparación CPU se limita a los perfiles medidos. Las síntesis conservan las condiciones de secrecia hacia adelante y de costo esperado de firma. El Deception Engine queda como propuesta futura, no como contribución implementada ni prioridad demostrada.

Se regeneran únicamente las salidas documentales: Word de 114 páginas, con 34 tablas, tres figuras y 606 ecuaciones nativas; PDF de 102 páginas. Coinciden las 848 celdas frente a una conversión independiente. Se revisan visualmente todas las páginas de ambos formatos, sin recortes ni desbordamientos detectados; las tablas y figuras Word conservan sus rótulos. Se usa Word oculto para su renderizado nativo y PyMuPDF para el PDF local; el renderizador empaquetado no pudo iniciarse por falta de `pdf2image`.

Se conservan el [respaldo previo](Documentos/06-Evidencia-TG2/2026-10-19/Revision-Integral-Coherencia/respaldo_previo/) y la [revisión original](Documentos/06-Evidencia-TG2/2026-10-19/Revision-Integral-Coherencia/revision.json). La [corrección verificada](Documentos/06-Evidencia-TG2/2026-10-19/Revision-Integral-Coherencia/correccion-verificada.json) fija las huellas de fuentes y salidas, las 216 imágenes revisadas y las comprobaciones aritméticas. §6.7.9 es idéntica al respaldo y siguen intactas 364 huellas de fuentes/registros de la auditoría global Lean (`5a206a516c28e1613e6f3d76e1892ad8c167215d06b3a3e89aeca10f63291ce9`). No se modifica ni compila Lean/Rust, no se agregan módulos ni obligaciones nuevas y no se atribuyen refinamiento universal, cierre QROM o aprobación académica. Se actualizan el seguimiento y el manifiesto de entrega con preservación de sus rutas previas.

## Transferencia AIR/FRI concreta y presupuesto global — 18 de octubre de 2026

> Actualización de revisión integral, 19 de octubre: se leen los siete capítulos, resúmenes, alcance y bibliografía, sin modificar las fuentes ni regenerar Word/PDF ni compilar Lean/Rust. Se registran seis grupos de observaciones: objetivos frente al resultado realmente demostrado; independencia para sumar min-entropía; umbrales de consenso y afirmaciones sobre colusión; condiciones de amortización y comparación CPU; hipótesis omitidas en las síntesis; remisión al Deception Engine no desarrollado en §7.5. Las pruebas Lean ya contienen las condiciones relevantes. Las cuentas cotejadas de APT, pérdida B+23, tablas ideales y dos ejemplos ROM coinciden. Permanecen idénticas 364 huellas de fuentes/registros Lean y las doce de fuentes/salidas del manuscrito. Evidencia: `Documentos/06-Evidencia-TG2/2026-10-19/Revision-Integral-Coherencia/revision.json`. Las observaciones no se convierten en módulos nuevos ni en exigencia automática de ampliar el alcance; QROM y Qiskit siguen como trabajo futuro. La entrada del 18 de octubre que sigue es histórica.

Se añaden 55 resultados en once módulos: total 2469 resultados en 304
módulos. Los controles de GT/GC originales y su acarreo implican AceptaCompartida
sobre los dominios Goldilocks. La conversión de muestras conserva su cardinal;
se prueban seis posiciones AIR, enlace de composición sin polos y ambas fases
FRI con la misma muestra. Bajo PrefijoSeguro se deriva cardinal<=floor(7*2^e/8).

Todo exceso implica un fallo AIR/FRI de la misma tabla real: FRI de traza lejana,
cancelación AIR o FRI de composición lejana. Se demuestra Pr(Exceso)<=Pr(Rondas).
Pr(Rondas) permanece sin cota: faltan vectores fijados antes de cada E y la ley
de las respuestas reales con sesgos y preconsultas. No se atribuye la ley ideal
a las funciones construidas de una vista ya fijada antes de I.

Del adversario y el lector completo de bytes, incluidos rechazos, se deriva
B=Q+V12(R), con V12(R)=24383+R. Para R=512, B=Q+24895 y m<=Q+24894. Se integra
Pr(falsa)<=Pr(no SinBad)+Pr(Rondas)+(Q+24895)*(hipergeometrica+2^-300+acoplamiento).
La hipergeométrica es <=(7/8)^40<=1/200. La fórmula puede ser vacua y estos
términos no constituyen solidez global. La cota conserva un perfil fijo.

Faltan las dos probabilidades excepcionales, trabajo, perfiles y reinicios con
presupuesto común, refinamiento universal Rust y ejemplo numérico integral.
Permanecen H1/H2 y dictamen. Se conservan seis parciales y sus criterios, M37
delimitado y Qiskit/Aer y QROM AIR/FRI futuros.

Compilación, axiomas y 304 verificaciones del núcleo correctas con hasta
cuatro procesos, sin reutilizar replays. Se permiten únicamente propext,
Classical.choice y Quot.sound. Se confía en importados, sin --fresh ni dictamen
independiente. Se fijan 1136 fuentes y 310 logs; pasan 21 controles Python.
Se conservan 50 etapas y 6689 logs canónicos, 16 versiones anteriores, 15 fuentes
congeladas y 8897 archivos recuperables de la edición previa. Permanecen intactas
1085 fuentes auditadas previas, con copias exactas de seis archivos canónicos.

Se actualizan 36 bloques y 396 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos y
4107 enlaces con alcance. Los conteos no son porcentajes de tesis terminada.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Pruebas, criterios y límites](Documentos/06-Evidencia-TG2/2026-10-18/Lean-AIR-FRI-Real/README.md).


## Canal canónico falso y exceso de cardinal — 18 de octubre de 2026

Se añaden 45 resultados en ocho módulos: total 2414 resultados en 293
módulos. El canal previo se reejecuta desde las consultas conocidas de su tabla;
produce exactamente la cadena canónica y la semilla, sin consultar trabajo ni
índices. La elegibilidad exige esa reejecución completa, perfil admitido,
consultas almacenadas y falsedad algebraica de EnunciadoValido. La aceptación
falsa con adversario adaptativo e intercalaciones produce una primera I elegible.

GT/GC se restringen al filtro causal y al límite g de su intersección original.
El cardinal filtrado queda acotado universalmente, conservando explícita la
probabilidad del evento Exceso. De un presupuesto global B de entradas distintas
se deriva m<=B-1 antes de cada dirección fresca. Se demuestra, por perfil fijo,
Pr(falsa)<=Pr(no SinBad)+Pr(Exceso)+riesgo(R,k+2,40,g,B-1)*B, sin hipótesis
separadas g/m sobre las políticas originales ni condicionamiento a los eventos.
Para R=512 y 4<=k<=12 la cola del selector se sustituye por 2^-300.

Falta acotar Exceso con los argumentos AIR/FRI y sus retos reales, acotar las
excepciones, derivar B, integrar trabajo, perfiles y reinicios y dar un ejemplo
numérico integral. La fórmula puede ser vacua y la cola por sí sola no demuestra
seguridad global. Permanecen refinamiento Rust, H1/H2 y dictamen. Se conservan
seis parciales y sus criterios, M37 delimitado y Qiskit/Aer y QROM AIR/FRI futuros.

Compilación, axiomas y 293 verificaciones del núcleo correctas con hasta
cuatro procesos, sin reutilizar replays. Los únicos axiomas permitidos son
propext, Classical.choice y Quot.sound. Se confía en importados, sin --fresh ni
dictamen independiente. Se fijan 1091 fuentes y 299 logs; pasan 21 controles
Python. Se conservan 49 etapas y 6379 logs canónicos, 16 versiones anteriores,
15 fuentes congeladas y 8542 archivos recuperables de la edición previa.
Permanecen intactas 1043 fuentes auditadas previas, con copias exactas de los
seis archivos canónicos actualizados.

Se actualizan 36 bloques y 282 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos
y 3711 enlaces con alcance. Los conteos no son porcentajes de tesis terminada.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Pruebas, criterios y límites](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Candidatos-Falsos/README.md).


## Prefijo efectivo y cobertura de primeras exposiciones — 18 de octubre de 2026

Se añaden 40 resultados en ocho módulos: total 2369 resultados en 285
módulos. La tabla del corte antes del primer I coincide exactamente con la tabla
normalizada del prefijo de llamadas, incluidas repeticiones. La continuación y
la próxima entrada se reconstruyen con las respuestas pasadas; desde ellas se
definen la semilla y GT/GC sin recibir el certificado futuro. La aceptación con
adversario adaptativo e intercalaciones se cubre por una primera exposición
real, incluso si corresponde a una preconsulta deliberada del adversario.

La unión probabilística ya se aplica por perfil fijo: bajo cotas g/m/B en todas
las activaciones, Pr(aceptación y SinBad)<=riesgo*B. Al retirar SinBad se suma
Pr(no SinBad), sin condicionar la distribución. El horizonte es la altura finita
del programa, sin identificarla con Q+V_T. La cota puede ser vacua: faltan cotas
pequeñas para candidatos falsos, filtro causal de canal válido, rondas FRI,
trabajo, perfiles y reinicios, excepciones, presupuestos integrales, refinamiento
Rust, H1/H2 y dictamen. Se conservan seis parciales y sus criterios, M37
delimitado y Qiskit/Aer y QROM AIR/FRI como futuro.

Compilación, axiomas y 285 verificaciones del núcleo correctas con hasta
cuatro procesos, sin reutilizar replays. Los únicos axiomas permitidos son
propext, Classical.choice y Quot.sound. Se confía en importados, sin --fresh ni
dictamen independiente. Se fijan 1049 fuentes y 291 logs; pasan 21 controles
Python. Se conservan 48 etapas y 6080 logs canónicos, 16 versiones anteriores,
15 fuentes congeladas y 8195 archivos recuperables de la edición previa.
Permanecen intactas 1001 fuentes auditadas previas, con copias exactas de los
seis archivos canónicos actualizados.

Se actualizan 36 bloques y 280 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos
y 3429 enlaces con alcance. Los conteos no son porcentajes de tesis terminada.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Pruebas, criterios y límites](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Prefijo-Selector/README.md).


## Muestra efectiva aceptada en GT/GC — 18 de octubre de 2026

Se añaden 45 resultados en ocho módulos: total 2329 resultados en 277
módulos. La aceptación produce las aperturas registradas y sus valores en la
tabla final. Los enlaces AIR/composición y todos los controles de acarreo FRI
se transportan a los vectores extraídos, usando alfas y betas reales. Se define
la lista ordenada efectiva del selector, se conservan sus duplicados intermedios
y su parada al completar cuarenta, y se prueba equivalencia de su conjunto con
la salida de la cinta real.

Todas las consultas de esa muestra aceptada pertenecen conjuntamente a GT/GC
de la tabla anterior al primer I. La instancia con adversario adaptativo e
intercalaciones obtiene el soporte de su propia ejecución. La cobertura es
determinista bajo SinBad, sin condicionar la ley uniforme a ese evento. Faltan
puente al prefijo bruto y unión probabilística, g/m/B de candidatos falsos,
cotas FRI, factor de trabajo, composición integral, refinamiento Rust, H1/H2 y
dictamen. Se conservan seis parciales y sus criterios, M37 delimitado y Qiskit/Aer
y QROM AIR/FRI como futuro.

Compilación, axiomas y 277 verificaciones del núcleo correctas con hasta
cuatro procesos, sin reutilizar replays. Los únicos axiomas permitidos son
propext, Classical.choice y Quot.sound. Se confía en importados, sin --fresh ni
dictamen independiente. Se fijan 1007 fuentes y 283 logs; pasan 21 controles
Python. Se conservan 47 etapas y 5789 logs canónicos, 16 versiones anteriores,
15 fuentes congeladas y 7856 archivos recuperables de la edición previa.
Permanecen intactas 959 fuentes auditadas previas, con copias exactas de los
seis archivos canónicos actualizados.

Se actualizan 36 bloques y 284 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos
y 3149 enlaces con alcance. Los conteos no son porcentajes de tesis terminada.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Pruebas, criterios y límites](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Consultas-Buenas/README.md).


## Semántica previa y conjuntos GT/GC — 18 de octubre de 2026

Se añaden 51 resultados en ocho módulos: total 2284 resultados en 269
módulos. La cadena del candidato se interpreta en perfil, enunciado, raíz base,
raíces FRI, constantes finales y nonce. Los anchos de los codecs se justifican;
los retos E de la tabla anterior recuperan alfas y betas reales en su orden.
Se prueba igualdad entre la vista leída antes del primer I y la del registro
final. Misma semilla implica mismos datos semánticos y vista.

GT/GC se definen solo desde tabla y semilla mediante valores extraídos, enlaces
de traza/composición y acarreo FRI, y se conservan hasta la vista final. Falta
demostrar pertenencia de todas las consultas aceptadas, puente al prefijo bruto,
unión probabilística, g/m/B, cotas FRI, factor de trabajo, cobertura de aceptación
falsa, composición integral, refinamiento Rust, H1/H2 y dictamen. SinBad no
condiciona la ley uniforme. Se conservan seis parciales y sus criterios, M37
delimitado y Qiskit/Aer y QROM AIR/FRI como futuro.

Compilación, axiomas y 269 verificaciones del núcleo correctas con hasta
cuatro procesos, sin reutilizar replays. Los únicos axiomas permitidos son
propext, Classical.choice y Quot.sound. Se confía en importados, sin --fresh ni
dictamen independiente. Se fijan 965 fuentes y 275 logs; pasan 21 controles
Python. Se conservan 46 etapas y 5506 logs canónicos, 16 versiones anteriores,
15 fuentes congeladas y 7525 archivos recuperables de la edición previa.
Permanecen intactas 917 fuentes auditadas previas, con copias exactas de los
seis archivos canónicos actualizados.

Se actualizan 36 bloques y 280 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos
y 2865 enlaces con alcance. Estos conteos no son porcentajes de tesis terminada.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Pruebas, criterios y límites](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Semantica-Previa/README.md).


## Candidato de bytes previo al selector — 18 de octubre de 2026

Se añaden 34 resultados en siete módulos: total 2233 resultados en 261
módulos. La aceptación matemática con adversario produce la cadena del canal
y su primera consulta I. Bajo ausencia de excepciones se reconstruye esa cadena
usando solo la tabla anterior al primer I y la semilla, con 130 pasos de extractor.
Misma semilla implica misma cadena de bytes registrada. Las raíces absorbidas
están marcadas antes del selector y sus vectores coinciden con los del registro
final. El digest de trabajo y la semilla posterior a absorber el nonce permanecen
separados; la aceptación también implica trabajo válido.

Falta decodificar semánticamente esa transcripción para definir las políticas
semilla/GT/GC del prefijo y enlazarlas a la unión probabilística de primeras
exposiciones. Continúan g/m/B, rondas FRI, factor de trabajo, inclusiones de
aceptación falsa, composición integral, refinamiento Rust, H1/H2 y dictamen.
Las inclusiones bajo SinBad no condicionan la ley uniforme a SinBad. Se mantienen
seis parciales, sus criterios y el cierre limitado de M37. Qiskit/Aer y QROM AIR/FRI
siguen para futuro.

Compilación, axiomas y 261 verificaciones del núcleo correctas con hasta
cuatro procesos, sin reutilizar replays. Los únicos axiomas permitidos siguen
siendo propext, Classical.choice y Quot.sound. Se confía en importados, sin
--fresh ni dictamen independiente. Se fijan 923 fuentes y 267 logs;
pasan 21 controles Python. Se conservan 45 etapas y 5231 logs canónicos, 16
versiones previas, 15 fuentes congeladas y 7203 archivos recuperables de la
edición anterior. Permanecen intactas 876 fuentes previas y se guardan copias
exactas de los seis archivos canónicos actualizados.

Se actualizan 36 bloques y 244 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos
y 2585 enlaces con alcance. Los conteos no son porcentajes de tesis terminada.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Pruebas, criterios y límites](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Candidato-Previo/README.md).


## Primeras exposiciones y carga de candidatos — 18 de octubre de 2026

Se añaden 39 resultados en seis módulos: total 2199 resultados en 254
módulos. Se localiza la primera consulta efectiva de cada dirección del selector,
se reconstruye la continuación solo con el pasado y se demuestra ausencia de
doble carga. La unión registrada se acota por rho*E[inicios]<=rho*B, sin asumir
independencia entre candidatos. Se enlazan activaciones y éxitos del selector
matemático instrumentado con las entradas de bytes del programa común.

Una preconsulta deliberada puede tener probabilidad alta: se remite al primer
intento si conserva la semilla y conjuntos congelados allí. Falta construir ese
registro para todos los candidatos/nonces reales, derivar los conjuntos buenos
y rondas FRI, integrar el factor de trabajo y las inclusiones de aceptación
falsa, presupuestos y refinamiento universal Rust. Se mantienen seis parciales,
todos los criterios y el cierre delimitado de M37. H1/H2 y dictamen continúan
pendientes; Qiskit/Aer y QROM AIR/FRI siguen para futuro.

Compilación, axiomas y 254 verificaciones del núcleo correctas con hasta
cuatro procesos y sin reutilizar replays. Los únicos axiomas permitidos siguen
siendo propext, Classical.choice y Quot.sound. Se confía en los importados, sin
--fresh ni dictamen independiente. Se fijan 882 fuentes y 260 logs;
pasan 21 controles Python. Se conservan 44 etapas y 4964 logs canónicos, 16
versiones previas, 15 fuentes congeladas y 6889 archivos recuperables de la
edición anterior. Se mantienen intactas 836 fuentes previas y se conservan
copias exactas de los seis archivos canónicos actualizados.

Se actualizan 36 bloques y 206 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos
y 2341 enlaces con alcance. Estos conteos no representan un porcentaje de
tesis terminada. Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Pruebas, criterios y límites](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Primeras-Exposiciones/README.md).


## Continuación causal y selector dependiente del pasado — 18 de octubre de 2026

Se añaden 45 resultados en siete módulos: total 2160 resultados en 248
módulos. El árbol residual después de un prefijo es el mismo para todas las
tablas que producen ese pasado. Su resultado y cola tienen exactamente la ley
con memoria sobre la tabla observada. Esto se instancia con el verificador
completo con adversario, propuesta adaptativa e intercalaciones.

Se particionan todos los prefijos realizables con sus pesos exactos. La semilla
y GT/GC pueden depender del pasado. La cota del selector sobre todos esos
pasados es hipergeométrica+tau+delta+Pr(preconsulta); para R=512 y k=4..12,
tau<2^(-300). El puente de bytes conserva prefijo, direcciones y evento de
preconsulta, y se enlaza al programa instrumentado de selección de 40 índices.

No se demuestra que Pr(preconsulta) sea pequeña ni que el selector instrumentado
sea la aceptación del verificador completo. Faltan su carga a candidatos/nonces,
conjuntos buenos causales, retos FRI, composición global de eventos y presupuestos
y refinamiento universal Rust. Se conservan seis parciales, todos los criterios
y el cierre delimitado de M37. Siguen H1/H2 y dictamen pendientes; Qiskit/Aer y
QROM AIR/FRI permanecen para futuro. No se condiciona a SinBad ni aceptación.

Compilación, axiomas y 248 verificaciones del núcleo correctas con hasta
cuatro procesos y sin reutilizar replays. Solo aparecen propext, Classical.choice
y Quot.sound. Se confía en importados, sin --fresh ni revisión independiente.
Se fijan 842 fuentes y 254 logs; pasan 21 controles Python. Se conservan
43 etapas y 4704 logs canónicos, 16 versiones previas, 15 fuentes congeladas y
6580 archivos recuperables de la edición anterior.

Se actualizan 36 bloques y 235 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos y
2135 enlaces con alcance. Estos conteos no son porcentajes de finalización.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Pruebas, criterios y límites](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Selector-Adaptativo/README.md).


## Acoplamiento local del selector ROM — 18 de octubre de 2026

Se añaden 52 resultados en siete módulos: total 2115 resultados en 241
módulos. Se compara cualquier evento de la cadena memorizada con una cinta
independiente. Tras un pasado fijo y primera dirección fresca, el error es
delta=min(1,R*(m+R+1)/2^256). Se transfiere la omisión de una muestra compartida
contra GT inter GC y el abandono, pagando una sola delta. Para k=4..12 y
R=512 se obtiene hipergeométrica+2^(-300)+delta. La adaptación usa las entradas
I reales y el resultado del programa matemático de selección de 40 índices.

No se condiciona a SinBad, completar o aceptar. Faltan frescura de candidatos
elegidos adaptativamente, retos FRI, candidatos/nonces y composición global de
eventos y presupuestos. Los seis parciales y todos los criterios se conservan;
M37 mantiene su cierre delimitado. Siguen refinamiento universal Rust, H1/H2 y
dictamen pendientes. R continúa analítico; Rust, TG1, capítulos y salidas no
cambian. Qiskit/Aer y QROM AIR/FRI siguen para futuro.

Compilación, axiomas y 241 verificaciones del núcleo correctas con hasta
cuatro procesos y sin reutilizar replays. Solo aparecen propext, Classical.choice
y Quot.sound. Se confía en importados, sin --fresh ni revisión independiente.
Se fijan 801 fuentes y 247 logs; pasan 21 controles Python. Se conservan
42 etapas y 4450 logs canónicos, 16 versiones previas, 15 fuentes congeladas y
6278 archivos recuperables de la edición anterior.

Se actualizan 36 bloques y 210 enlaces. Hay 212
bloques del inventario y 216 de la revisión enlazados, diez suplementos y
1900 enlaces con alcance. Estos conteos no son porcentajes de finalización.
Capítulos, salidas publicadas, TG1 y Rust conservan sus bytes.
[Pruebas, criterios y límites](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Selector-Acoplado/README.md).


## Ley conjunta del ROM finito con adversario — 18 de octubre de 2026

Se añaden 63 resultados en siete módulos: total 2063 resultados en 234
módulos. Se prueba la igualdad exacta de la ley de resultado y transcripción
del plan de respuestas frescas con una función uniforme en el soporte finito
derivado de todas las ramas adaptativas del programa de bytes. Se permiten
propuesta adaptativa de certificados e intercalaciones arbitrarias. La tabla
crece aun si ocurre una excepción; no se condiciona a SinBad o aceptación.

La instrumentación que devuelve el registro no cambia consultas, altura,
soporte ni el plan original. Cada prefijo efectivo es un cilindro de masa
1/(2^256)^u para u direcciones distintas. La siguiente respuesta es uniforme
solo si su dirección es nueva y se condiciona a ese pasado fijo; una repetida
conserva su valor. No se atribuye independencia a ambas fases FRI.

Los seis grupos parciales M26/M35/M36/M39/M40/M41 conservan criterios y estados;
M37 y los demás modelos cerrados se mantienen sin cambios. Siguen transferencia
al selector ideal, candidatos reales, inclusiones y composición de eventos,
refinamiento universal Rust y solidez integral. Altura<=S no se identifica
automáticamente con Q+V_T y R sigue siendo analítico. La cota anterior mide
fallo de reconstrucción causal y no aceptación falsa.

Auditoría de compilación, axiomas y 234 módulos con hasta cuatro procesos,
sin reutilización: 760 fuentes, 240 logs y 21 controles Python. Se
conservan 41 etapas, 4203 logs, 16 versiones anteriores, 15 fuentes congeladas
y 5983 archivos recuperables de la edición previa. Se actualizan 36 bloques y
228 enlaces nuevos, total 1690. Capítulos, salidas, TG1 y Rust conservan sus
bytes. No hay dictamen independiente, H1/H2 sigue sin procedencia exacta y
Qiskit/Aer y QROM AIR/FRI continúan como trabajo futuro.
[Pruebas, criterios y límites](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Ley-Conjunta-ROM/README.md).

## Familias causales AIR/FRI y cierre del modelo M37 — 18 de octubre de 2026

Se añaden 73 resultados en once módulos: total 2000 resultados en 227
módulos. La aceptación del programa completo deriva las absorciones, retos
y todas las aperturas de las cuarenta consultas: seis AIR y dos por capa
FRI, con autenticación, registro, raíz, altura e índice en rango. El canal
produce desafíos y muestra efectivos, conservando el soporte de su continuación.

Con propuesta adaptativa de bytes e intercalaciones arbitrarias, SinBad y
aceptación construyen las familias AIR base, k capas de traza y k+1 de
composición. Cada oráculo usa el prefijo exacto anterior a la primera consulta
del reto asociado y no cambia al elegir otro testigo del corte. Cada apertura
real coincide con su lectura en OraculosEmitidos. M37 cierra ese modelo
clásico finito contra sus criterios originales; hay 34 modelos y seis parciales.

El programa de bytes se compila al plan ROM fresco con memoria. Sin excepción,
la función de su tabla final reproduce el programa y satisface SinBad. Aceptar
sin poder reconstruir las familias implica excepción, con probabilidad a lo
sumo min(1,S*(49*S+B)/2^256) bajo altura(programa)<=S. Esa cota mide fallo de
reconstrucción, no aceptación falsa ni solidez integral. No se identifica
automáticamente la altura con Q+V_T de Rust. Permanecen ley conjunta del
selector, candidatos, eventos integrales y refinamiento universal Rust/Lean.

La auditoría conjunta pasa compilación, axiomas y 227 replays con hasta
cuatro procesos sin reutilización: 719 fuentes, 233 logs y 21 controles
Python. Se conservan 40 etapas y 3963 logs, 16 versiones previas, 15 fuentes
congeladas y los 5691 archivos anteriores recuperables. Se actualizan 36 bloques
con 190 enlaces nuevos, total 1462. Capítulos, salidas, TG1 y Rust conservan
sus bytes. Los criterios y obligaciones adicionales permanecen explícitos.

No hay dictamen independiente, H1/H2 continúa sin procedencia exacta y Qiskit/Aer
y QROM AIR/FRI siguen para futuro. [Pruebas, criterios y límites](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Familias-Causales/README.md).

## Adversario y primeras exposiciones ROM — 18 de octubre de 2026

Se añaden 66 resultados en nueve módulos: total 1927 resultados en 216 módulos.
El proponente consulta bytes arbitrarios y elige después certificado/estado.
Se compone con el lector estricto y el verificador con intercalaciones del
adversario antes de cada petición. Resultado, registros, tabla compatible
y causalidad se prueban sobre una sola H. El coste global suma consultas
adversarias y de protocolo; con sus presupuestos se obtiene Q+V.

La lectura del índice se cuenta sobre los 32 octetos, no solo ocho: cada
índice tiene 2^(256-e) preimágenes. Cintas ideales de digests independientes
inducen palabras uniformes y ley hipergeométrica del selector condicionado
a completar. Para toda H el selector real se evalúa mediante la cadena I;
la cola posterior a completar no se atribuye al registro. La ley fresca es
local por prefijo, con repeticiones explícitas. No se supone independencia
después de condicionar a SinBad ni se identifica todavía la ley conjunta.

De SinBad y registros efectivos se deriva el recorrido con memoria y los
orígenes ordenados de absorción/reto. Una apertura aceptada registrada se
extrae con la tabla anterior a la primera respuesta del reto, incluso si
el verificador la repite después. Falta derivar simultáneamente esas premisas
para todas las familias AIR/FRI y componer los eventos y candidatos globales.

Compilación, axiomas y los 216 replays pasan con hasta cuatro procesos,
sin reutilizar replays de auditorías previas: 674 fuentes y 222 logs
canónicos. Pasan 21 controles Python. Se conservan 39 etapas y 3730 logs,
16 versiones previas, 15 fuentes congeladas y los 5413 archivos anteriores
recuperables. Capítulos, salidas, TG1 y Rust conservan sus bytes.

Se actualizan 29 bloques con 164 enlaces nuevos, total 1272. Los siete
grupos parciales conservan sus criterios y las obligaciones adicionales.
No se declara solidez integral ni refinamiento universal Rust/Lean. H1/H2
continúa sin procedencia exacta y el autor declaró «No hay dictamen».
QROM AIR/FRI y Qiskit/Aer permanecen para futuro conforme a su decisión.
[Pruebas y límites](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Adversario-Causal/README.md).

## Qiskit reservado como trabajo futuro — 18 de octubre de 2026

El autor indicó: «Deja eso anotado a futuro». La posible integración de Qiskit
SDK y Qiskit Aer se reserva como laboratorio experimental de TG2 y se retomará
cuando lo solicite expresamente. Se proponen ensayos reducidos de Shor/Grover,
simulación con y sin ruido y resultados JSON/gráficas reproducibles desde Python.
La evidencia experimental complementará las pruebas Lean; no acreditará por sí
sola seguridad de ML-DSA ni cerrará QROM. La decisión conserva el alcance y las
prioridades del cierre activo. Se registra en [PENDIENTES.md](PENDIENTES.md).

## Ruta matemática completa del verificador TG2 — 18 de octubre de 2026

Se añaden 105 resultados en once módulos: total 1861 resultados en 207 módulos.
La ruta compone lector con campos canónicos y resto, codec del certificado,
formas previas al hash, canal con tres alfas y todos los betas, selector de
cuarenta índices en orden y sin duplicados, seis aperturas AIR, enlaces y
ambas fases FRI. La aceptación entrega todos los controles locales. Los
recorridos FRI aceptados producen el registro de sus aperturas y continuaciones.

El presupuesto se demuestra sobre los programas y su registro para toda tabla,
incluidos rechazos, y coincide con V_T: 6943/24895 para T=16/4096 y R=512.
R sigue siendo un corte analítico que no existe en el bucle Rust. La medida
cuenta llamadas hash y no el consumo de CPU o memoria del lector.

El helper externo usa las fuentes de nexus intactas y pasa cargo check/test,
build debug y release. Se contrastan 50 binarios, 25 por perfil: los catorce
del corpus y 36 variantes. Con EOF estricto ocho aceptan y 42 rechazan;
Python coincide con Rust en los mismos bytes. bincode::deserialize acepta
los dos sufijos que las envolturas estrictas rechazan. Se conserva esta
diferencia y los fallos iniciales de resolución/dependencia con sus logs.
El contraste no ejecuta Lean ni demuestra refinamiento universal Rust/Lean.

Compilación, axiomas y los 207 replays pasan con hasta cuatro procesos y
sin reutilizar auditorías: 631 fuentes y 213 logs canónicos. Pasan
21 controles Python. Se preservan 38 etapas y 3508 logs históricos, 16
versiones previas, 95 registros de fuentes/artefactos y los 5051
archivos de la edición anterior. Capítulos, salidas, TG1 y Rust no cambian.

Se actualizan 29 bloques con 139 enlaces nuevos, total 1108; los siete
grupos parciales conservan sus criterios. Quedan el refinamiento universal
Rust, frescura y congelación en todas las historias adversarias, candidatos,
eventos globales, procedencia H1/H2 y revisión independiente. El autor declaró
«No hay dictamen» y QROM AIR/FRI permanece como trabajo futuro.
[Pruebas y límites](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Verificador-Completo/README.md).

## Certificado, gramática y canal compartido — 17 de octubre de 2026

La pasada sobre los ocho grupos añade 49 resultados en cinco módulos: total
1756 resultados en 196 módulos. M31 cierra su reconstrucción matemática con
un certificado legado público concreto, sin alterar sus criterios. Hay 33
modelos verificados en su alcance y siete parciales: M26/M35/M36/M37/M39/M40/M41.
El cierre de M31 no acredita ZK, solidez general ni refinamiento universal Rust.

Se genera y verifica el ejemplo inicio=3, testigo=5, T=16; una relectura Python
comprueba canonicidad, bytes, SHA3, nonce, índices, 240 aperturas AIR, composición
y 40 recorridos FRI. Las 128 posiciones distintas permiten elegir 16 evaluaciones
literales: Lean prueba nodos, grado, evaluaciones, interpolación y recuperación
de 5. El binario es nuevo; no sustituye archivos de corridas históricas. Sus
hojas AIR de nueve octetos y dominio legado se distinguen de TG2 v1.

La gramática TG2 conjunta conserva el solapamiento enunciado/nodo y una única
tabla por bytes. Todo programa finito produce una historia compatible; la ley
fresca en un prefijo mantiene explícita su condición, y la repetida queda fijada.
El compilador a árboles memoriza repeticiones incluso entre roles. El programa
del canal deriva su presupuesto desde fases, trabajo, nonce y selector común,
con R analítico y continuación separada para aperturas. USize coincide con
las seis posiciones AIR; sus sumas caben incluso en 32 bits para este perfil.
El contraste del corpus TG2 v1 comprueba 111448 entradas hash de catorce
certificados: ocho honestos aceptan y seis trazas lejanas rechazan, con gramática
y presupuesto del canal correctos en esos casos, sin refinamiento universal.

Se ejecutan compilación, axiomas y replay de 196 módulos con un máximo de cuatro
procesos, conservando todos los chequeos; pasan 21 controles Python. Se reutilizan
70 replays confirmados por identidad de 19680 fuentes/importados, con sus logs y
ejecutor conservados, y se ejecutan los otros 126 a petición del autor. Fuentes
y logs canónicos: 510/202. Cargo check/test/build del extractor y
verificación concreta correctos; no se repite toda la suite de nexus. Se
conserva el fallo inicial offline y el reintento con Cargo.lock. Capítulos,
salidas, fuentes Rust y TG1 no cambian. Dieciséis versiones y 27 registros
de fuentes/artefactos preservan la edición previa de 4693 archivos.

La frescura global, adversario de entradas arbitrarias, parser y enteros completos,
candidatos buenos, composición de eventos y corridas H1/H2 siguen pendientes.
El autor declaró «No hay dictamen»; QROM AIR/FRI sigue como trabajo futuro.
[Pruebas y límites](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Certificado-Gramatica/README.md).

## Revisión de referencias NIST, 17 de octubre de 2026

Se consultan y conservan doce fuentes oficiales: FIPS 204 y erratas, SP 800-90B
y erratas, SP 800-90C final, SP 800-57 Parte 1 Rev. 5 final y Rev. 6 borrador,
especificación ACVP ML-DSA y README de EntropyAssessment. FIPS 204 PDF y hoja
de erratas coinciden con R1; la hoja coincide también con la copia de octubre.

Se revisan visualmente cinco páginas de salud, erratas y destrucción de claves.
Se distingue el corte APT=16 certificado para H=7.5 de los ejemplos tabulados,
el monitoreo propio de la validación de fuente y las revisiones ACVP del estándar.
Las copias, respaldos, fuente física, R1-D y secrecia hacia adelante conservan
sus obligaciones. Se registra una observación editorial sobre la tabla de
Capítulo 7, línea 21, para la próxima conciliación, sin alterar el capítulo.

Esta etapa es documental: no añade resultados ni modifica fuentes Lean o Rust.
Se reutiliza la auditoría de 1707 resultados en 191 módulos por identidad de
sus fuentes y logs; se conservan 32 modelos verificados en su alcance y los
ocho grupos parciales. M01/M08/M09, M43/M44 y QROM AIR/FRI mantienen sus estados.
No hay dictamen independiente ni certificación NIST. TG1 y las salidas del
manuscrito conservan sus bytes. Se preservan las versiones anteriores al sellado.
[Fuentes y trazabilidad](Documentos/06-Evidencia-TG2/2026-10-17/NIST-Referencias/README.md).

## Cierre por criterios originales, 17 de octubre de 2026

Se añaden 21 resultados en cuatro módulos: total 1707 en 191. La evaluación
de los 19 grupos justifica once cierres de modelos, sin alterar sus criterios:
M05, M11, M13, M16, M18, M21, M23, M24, M25, M27, M33. Hay 32 modelos verificados en su alcance y 8 grupos parciales:
M26/M31/M35/M36/M37/M39/M40/M41. Los cierres no resuelven las obligaciones
adicionales de implementación, seguridad criptográfica ni revisión independiente.

Se prueba aplicación atómica de documento y nonce, procedencia autorizada o
colisión bajo contrato explícito de firmas, y autorización si se excluye ese
evento. Se compone la compuerta de salud con operaciones; reevaluar sin rotar
no habilita. Un codec de bits recupera cada posición y da cotas de familias
con todos sus parámetros variables. DA fija el conjunto disponible antes del
muestreo; un contraejemplo muestra la frontera inclusiva de quórum 2/3.

Los once criterios se contrastan con definiciones y teoremas anteriores/nuevos.
Custodia, borrado, secrecia hacia adelante, Rust/f64, codecs, backend, ley de
rechazo real, ABI y reducciones se conservan como obligaciones adicionales.
La semántica de esa correspondencia es juicio del agente, no dictamen ni
verificación integral de la tesis. Las cuatro fuentes R5 vinculan cuentas
de memoria a su versión y ejecución histórica, sin generalizar RAM ni entropía.

Auditoría de compilación, axiomas y replay de 191 módulos confiando en importados:
454 fuentes y 197 logs. Se conservan 16 versiones y los 4413 archivos
de la edición anterior mediante hashes y copias. Capítulos, salidas publicadas,
Rust y TG1 no cambian. El autor declaró «No hay dictamen»; QROM AIR/FRI sigue futuro.
[Evidencia y límites](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Cierre-Criterios/README.md).

## Selector, codecs y ciclos firmados, 17 de octubre de 2026

Se añaden 76 resultados en diez módulos: total 1686 en 187. Se actualizan
66 correspondencias en nueve grupos; permanecen 21 modelos verificados y
19 parciales. Se conservan criterios y pendientes anteriores con versiones
y registro; los actuales distinguen cardinalidad y uniformidad ya resueltas.

Se prueban el cardinal choose(256,tau)*2^tau de B_tau y la biyección algebraica
NTT que conserva suma y producto. Se cuenta el plan con mitades compartidas:
1024 mariposas, 2048 sumas y 1024 productos para 256 coeficientes. Se derivan
uniformidad del selector terminado, cociente hipergeométrico y pérdida de
aborto exactamente tau. Una historia causal admisible fija equivale a su
tabla parcial y la respuesta en una clave ausente es uniforme. Queda derivar
estas condiciones para todos los eventos reales. No se presupone SHA3 uniforme.

El parser del sobre TG2 prueba ida y vuelta y rechazos por forma; no se
identifica con bincode TG1. Las cadenas firmadas preservan identidades,
checkpoint y épocas y rechazan propuestas repetidas. Altas/retiros, custodia,
borrado, Rust/f64, Montgomery, reducciones y adaptador global siguen pendientes.

La auditoría comprueba compilación, axiomas permitidos y replay de 187 módulos
confiando en importados: 427 fuentes y 193 logs. Se ejecutan 13 controles
y se conserva la edición anterior de 4181 archivos. Capítulos, salidas publicadas,
Rust y TG1 no cambian. No hay dictamen; QROM AIR/FRI continúa como trabajo futuro.
Evidencia: [selector y ciclos](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Selector-Ciclos/README.md).

## Pasada de las 22 obligaciones parciales, 17 de octubre de 2026

Se añaden 164 resultados en 20 módulos: total 1610 en 177. Se conservan los
criterios de los 22 grupos y se cierran los modelos M10, M32 y M46. Quedan
19 parciales, tres dependencias bibliográficas, dos respaldos y QROM AIR/FRI
futuro; 21 modelos están verificados en su alcance. No se declara terminada
la formalización integral ni se inventa un dictamen.

M32 obtiene las ecuaciones FRI desde ejecución con acarreo, formas y final,
y ambas fases se combinan con las aperturas AIR compartidas. M46 usa el control
base local. M10 deriva las constantes desde parámetros ML-DSA y JMW24v2.
Se demuestran una NTT radix dos de referencia, bloques y fronteras de kappa,
firmas del lote, operation_bytes, rachas condicionales, contadores de salud,
cuentas de layout/serialización, reconstrucción pública, selector y potencial
adaptativo. La cota ROM propuesta se evalúa exactamente, sin certificar por ello
las premisas del ejecutable. El adaptador causal y el refinamiento siguen abiertos.

Se actualizan 109 correspondencias: 211 bloques del inventario,
215 de la revisión y 639 enlaces de alcance. Se conservan textos,
líneas, 272 candidatos y 14 suplementos. La auditoría completa recompila,
audita axiomas y repite el núcleo de 177 módulos: 396 fuentes y 183 logs.
Solo se admiten los tres axiomas estándar; se confía en módulos importados.
Hay 16 versiones previas y 13 fuentes consultadas preservadas. Capítulos,
Word/PDF/Markdown, Rust y TG1 conservan sus bytes.

[Pruebas y límites](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Obligaciones-22/README.md).

## Grados AIR y cancelación por masa máxima, 17 de octubre de 2026

El primer control de integridad detectó que inventario_base conservaba el hash
anterior pero apuntaba al inventario ampliado. Se corrige la referencia hacia
la copia congelada ya conservada, con auditoría original y revisión previa
intactas. La rectificación reutiliza por identidad las pruebas y 157 replays;
no cambia ningún archivo Lean, registro de teoremas, herramienta o log del
nucleo. Se repiten controles y trazabilidad y se conserva el primer log.
[Rectificación documentada](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Grados-Cancelacion/rectificacion-metadatos.json).

Se añaden 53 teoremas en tres módulos y se alcanzan 1446 resultados en 157
módulos. M28 cierra las cotas de §6.7.2: fronteras T-2, transición T y composición
T<2T, con factorización e identidad racional bajo validez. M29 cierra la cota
de cancelación por masa máxima y su versión condicionada al contexto. La
independencia o las leyes condicionales son hipótesis expresas, sin derivarlas
del registro ROM del ejecutable.

Se certifica el caso T=16: cambia la primera fila de 3 a 4, traza inválida,
alpha0=10376293027944593777 y alpha1=alpha2=1, resto combinado cero, grados
15/32/16 y traza válida alternativa con la misma salida. Los coeficientes se
preparan con Python, pero las 16 evaluaciones, recurrencias y grados se prueban
en Lean. No se fuerzan retos SHA3 ni se prueba aceptación de certificados.

La matriz queda en 18 modelos verificados en su alcance y 22 grupos parciales;
permanecen tres dependencias bibliográficas, dos respaldos documentales y
QROM AIR/FRI futuro. Se actualizan 15 correspondencias y se conservan los 272
candidatos y 14 suplementos, sin cambios de texto ni de líneas.
El inventario llega a 181 bloques parcialmente enlazados y la revisión
complementaria a 190 bloques y diez suplementos, sin porcentajes de avance.
Compilación, axiomas estándar y replay secuencial de 157 módulos correctos; 344 fuentes,
163 logs actuales, 13 controles y 2520 logs de 33 etapas conservados. Hay 16
copias anteriores: 314 de las 320 fuentes previas permanecen idénticas y seis
cambian con copia. Capítulos, Word/PDF/Markdown, Rust y TG1 no cambian.

El próximo tramo es el recorrido completo de FRI M32 y después las familias
causales/gramática M37/M39, el potencial M40 y la composición ROM M41. Las
reducciones de firmas, los refinamientos del backend y las fuentes físicas
mantienen sus pendientes. No hay dictamen independiente, confirmado por el
autor; no se declara verificada toda la tesis.

[Auditoría](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Grados-Cancelacion/README.md) ·
[Matriz](formalizacion/REVISION-MANUSCRITO.md).

## Modelos matemáticos y manuscrito conciliado, 17 de octubre de 2026

Se añaden **176 resultados en 16 módulos** y se alcanzan **1393 resultados en
154 módulos**. Retículos euclídeos y primer mínimo alcanzado, plantilla FSwA,
derivación determinista, épocas y atomicidad, transacciones, intervalos APT,
sesgo modular/productos, cota histórica, tamaños y O(q log²N), raíces canónicas,
cola del selector y presupuestos tienen resultados Lean con hipótesis explícitas.
Se certifican las cifras APT, |log2(L_Q)+361.64|<0.005, 175 redondeos y ocho
razones R4, y tau<2^-300 para R=512 en nueve perfiles. Quórum, incentivos y
recuperación Reed-Solomon quedan como modelos de referencia; no se altera TG1.

M02, M07, M12, M17, M34 y M38 pasan a modelos verificados en su alcance. La
matriz queda en 16 verificados y 24 parciales, tres dependencias bibliográficas,
dos respaldos documentales y QROM AIR/FRI futuro. Hay 178 bloques del inventario
con revisión parcial marcada, 187 de la revisión complementaria y diez suplementos
enlazados. Se actualizan 95 correspondencias y se conservan los 272 IDs y líneas.

Tres candidatos y dos suplementos TG2 cambian con copia exacta anterior: se
corrige 768.2 KiB/3309 B a unas 238 firmas, se distingue entrada de hoja de
17 bytes y coordenadas de 16, y se actualizan las frases de Lean pendiente.
Word/PDF/Markdown se sincronizan en copia aislada y se publican tras revisar
todas las páginas: 110 Word, 99 PDF, 34 tablas, 848 celdas, 565 ecuaciones y
tres figuras. Se conservan las tres salidas anteriores. El renderer empaquetado
no está disponible; se usa el render nativo de Word. Word y Chrome requieren
la sesión autorizada y se ejecutan ocultos, con archivos temporales en .tools/.

La auditoría conjunta pasa compilación sin advertencias, axiomas permitidos y
replay secuencial de 154 módulos confiando en importados. Fija 320 fuentes
y 160 logs. Los 13 controles auxiliares y la revisión de integridad conservan
2357 logs de 32 etapas. De las 280 fuentes previas, 271 permanecen idénticas y
nueve tienen copia; hay 17 versiones anteriores del bloque. Rust permanece
limpio, no se ejecutan nuevos benchmarks ni se atribuyen estas pruebas al binario.

El autor responde «No hay dictamen»; se registra como pendiente. Siguen reducciones
bibliográficas, distribución/codecs/hedged, NTT concreta, f64/enteros de máquina,
autorización completa del registro, recorrido FRI, adaptador causal, potencial
adaptativo y composición ROM, además de procedencia H1/H2 y despliegue físico.
No se declara verificada la tesis completa ni se transforma una hipótesis en prueba.

[Auditoría](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Modelos-Pendientes/README.md) ·
[Manuscrito](Documentos/06-Evidencia-TG2/2026-10-17/Manuscrito-Modelos/README.md) ·
[Matriz](formalizacion/REVISION-MANUSCRITO.md).

## Formalización del manuscrito: distribuciones y juegos reticulares, 17 de octubre de 2026

Se completa el bloque autorizado M04–M06/M45 con **114 resultados nuevos en nueve
módulos**, para **1217 resultados en 138 módulos**. Se construye S_eta finito,
su cardinalidad y reducción inyectiva, representantes y levantamiento Rq→R.
Las leyes MLWE real/ideal tienen matriz, secreto y error independientes; se
formalizan juegos decisional/búsqueda y un contraste exacto sin ruido. MSIS
exige no nulidad, núcleo y norma. El lema 6.1 conserva representantes enteros
dados o canónicos y obtiene norma entera/modular ≤2L.

Se modelan algoritmos PMF, consultas clásicas adaptativas y registros con
presupuesto. Los juegos EUF/sUF distinguen mensaje y par nuevos; se prueba
Adv_EUF≤Adv_sUF, igualdad bajo unicidad y familias despreciables. La clase de
eficiencia es un parámetro. El error de corrección asintótica pertenece a [0,1],
excluyendo el infinito antes de convertirlo a real. El ejemplo de un adversario que cambia la firma
da EUF=0/sUF=1; no declara seguridad global del esquema de ejemplo.

SelfTarget tiene relación tipada, matriz [I|A], norma y último componente,
tabla uniforme independiente en dominio finito y consultas consistentes.
M05 permanece parcial por retos/bytes, juego bibliográfico y reducción desde
firmas. M04, M06 y M45 quedan como modelos verificados, sin acreditar dureza,
reducciones de peor caso, seguridad ML-DSA ni equivalencia con el backend.

La [matriz](formalizacion/REVISION-MANUSCRITO.md) incorpora o amplía 15 bloques:
inventario de 85 a 98 y revisión de 96 a 108, además de dos suplementos previos.
Quedan diez modelos verificados, 17 grupos parciales y 13 pendientes, además
de tres dependencias, dos respaldos y QROM AIR/FRI futuro. No son porcentajes.

La [auditoría](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Juegos-Reticulares/README.md)
comprueba compilación, axiomas y núcleo de 138 módulos confiando en importados,
con 280 fuentes y 144 logs. Pasan 13 controles auxiliares. Se conservan
247 fuentes anteriores, quince versiones y 2053 logs previos; el total llega
a 2197 logs de 31 etapas. Capítulos, TG1, Rust y evidencia empírica quedan
intactos; no se ejecutan cargo o benchmarks. Se actualizan README, alcance e
índice. R1 mantiene su alcance y el dictamen independiente sigue pendiente.
Las herramientas y sus hijos se ejecutan sin ventanas de terminal externas.

## Formalización del manuscrito: anillos ML-DSA y contraejemplo AIR, 17 de octubre de 2026

Por instrucción del autor se completa el bloque M03/M30: **121 resultados nuevos
en nueve módulos**, para **1103 lemas y teoremas en 129 módulos**. Se construyen
R y Rq, representantes únicos de grado menor que 256, reducción sobreyectiva,
coordenadas, cardinalidades y normas centradas. Se prueban la primalidad de
8380417, la raíz 1753 de orden 512, las fórmulas de parámetros y la aritmética
de tamaños del formato declarado, sin atribuir garantías de seguridad o codecs.

Para F=f+lambda·(X^T−1) se prueban grado T, filas y validez conservadas, transición
de grado 2T y coeficiente −2lambda², anulador de grado T−2 y cociente T+2. La
composición tiene grado ≤T+2<2T para T≥4 y coincide con la fórmula racional sin
polos. La distancia mínima al código es exactamente 7/8: se demuestra la cota
universal y se construye el aproximante que alcanza T acuerdos. Por interpolación
se construye la ejecución desde 3 y 5, con imagen desde el campo base, y se reúne
el contraejemplo sobre Goldilocks para 4≤k≤29, incluso ante candidatos de extensión.

La [matriz](formalizacion/REVISION-MANUSCRITO.md) suma 17 enlaces: inventario
de 68 a 85 y revisión de 79 a 96 bloques parciales, más dos suplementos. M03 y
M30 quedan como modelos verificados; hay siete modelos, 17 grupos parciales y
16 pendientes, además de tres dependencias, dos respaldos y QROM futuro.
Los candidatos, sus fuentes, textos, líneas e identificadores se conservan.

La [auditoría](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Anillos-Contraejemplo/README.md)
repite compilación, axiomas y núcleo de 129 módulos confiando en importados;
fija 254 fuentes y 135 logs. Pasan los 13 controles del analizador
y trazabilidad. Se preservan 208 fuentes anteriores, quince versiones y trece
activos empíricos R4: informe, análisis, tabla, cuatro logs y seis certificados.
La aceptación/rechazo del ejecutable conserva su alcance experimental. El total
histórico llega a 2053 logs de 30 etapas, incluidos los 1918 previos. Los capítulos,
TG1 y Rust permanecen intactos; no se ejecutan nuevos ensayos ni cargo. Se
actualizan README, alcance e índice. QROM AIR/FRI continúa futuro, R1 mantiene
su alcance y el dictamen independiente sigue pendiente. Ejecución sin ventanas externas.

## Formalización del manuscrito: residencia, costos y complejidad, 17 de octubre de 2026

Por autorización del autor se completa la pasada M19–M24: **118 resultados nuevos
en siete módulos**, para **982 lemas y teoremas en 120 módulos**. Se formalizan
integral de regiones, recorte, suma de copias, unión de intervalos y captura
uniforme. Se enlazan las medias racionales y los quince redondeos de la tabla 5.2
con el modelo temporal, conservando las condiciones de custodia como pendientes.

Las cuentas de 3936, 5993, 17536 y 4064 bytes se vinculan al inventario R5 de
ML-DSA-65/fips204 0.4.6. La amortización variable tiene límite d+L, equivalencia
con sublinealidad, familias polilogarítmicas y los cinco redondeos de §6.6.5.
El calendario NTT radix dos cuenta mariposas por recurrencia y demuestra las
cotas gruesa, optimizada y n=256 fijo. La ley geométrica da integrabilidad,
E[N]=1/p, cola finita y costo c/p. Se componen las cotas para firma esperada;
p_m=1/(m+1) prueba que la positividad sin barra uniforme no implica O(1).

La [matriz](formalizacion/REVISION-MANUSCRITO.md) amplía o añade enlaces en 27
bloques: inventario de 46 a 68 y revisión de 61 a 79, con dos suplementos previos.
M19, M20 y M22 quedan como modelos verificados. M21, M23 y M24 son parciales por
correspondencias de representación, algoritmo, distribución y contador reales.
Se conservan 18 grupos pendientes, 17 parciales, cinco modelos verificados,
tres dependencias, dos respaldos documentales y QROM futuro. No son porcentajes.

La [evidencia](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Costos-Residencia/README.md)
registra compilación y axiomas sin advertencias, núcleo secuencial de 120 módulos
confiando en importados, 215 fuentes y 126 logs. Pasan los 13
controles del analizador y trazabilidad. Se preservan 170 fuentes anteriores,
quince versiones, trece fuentes R5 y 1792 logs de las 28 etapas previas. La
evidencia completa alcanza 1918 logs de 29 etapas. Los capítulos, TG1 y Rust no
cambian; no se repiten benchmarks ni cargo. QROM AIR/FRI sigue futuro y R1 conserva
sus obligaciones. README, alcance e índice quedan actualizados; las herramientas
y sus procesos se ejecutan sin ventanas externas.

## Formalización del manuscrito: entropía, salud y recuperación, 17 de octubre de 2026

Por autorización del autor se completa una pasada conjunta sobre §§5.2–5.3 y
la compuerta del gestor. Se añaden **87 resultados en siete módulos** y se alcanzan
**864 lemas y teoremas en 113 módulos**. La min-entropía finita se enlaza con la
adivinación óptima y se acumula para productos independientes e IID; un ejemplo
correlacionado demuestra la necesidad de hipótesis conjuntas. La entropía empírica
de 32 bytes es a lo sumo cinco bits por símbolo y no alcanza 7,5.

RCT tiene corte cuatro y una cota de falsa alarma por racha IID. Se define la ley
binomial y se certifica con racionales el corte mínimo APT de dieciséis incluyendo
la referencia. Los decimales de las colas y la equivalencia f64 quedan pendientes.
El monitor conserva fallos, contador continuo e invariantes. El gestor modela
lotes 65536, cupo/edad y renovación pendiente: reevaluar sin renovar bloquea la
derivación; rotar conserva monitor y lote parcial. No acredita calificación física,
conformidad NIST, firma de operaciones, retiro, borrado ni secrecia hacia adelante.

El inventario pasa de 36 a 46 bloques parcialmente enlazados y la revisión de 51
a 61, además de dos suplementos. M14–M15 se registran como modelos verificados
con teoremas de cierre auditados; M16–M18 son parciales. Quedan 22 grupos pendientes,
16 parciales, dos modelos verificados, tres dependencias, dos respaldos documentales
y QROM futuro. Los grupos no constituyen un porcentaje de esfuerzo.

La [evidencia](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Entropia-Salud/README.md)
conserva compilación sin advertencias, auditoría de 864 resultados y `leanchecker`
secuencial de 113 módulos confiando en importados. Fija 177 fuentes y
119 logs. Pasan cinco controles del analizador y ocho de trazabilidad.
Se comprueban 143 fuentes previas sin cambios y los 1673 logs de 27 etapas
anteriores. Los [antecedentes](Documentos/06-Evidencia-TG2/2026-10-17/Entropia-Salud-Antecedentes/README.md)
conservan quince versiones y entropy.rs; los capítulos, TG1 y Rust no cambian.
QROM AIR/FRI sigue futuro y R1 mantiene su alcance. Se actualizan README, alcance,
matriz e índice sin abrir terminales externas.
Se amplían las reglas de Git para conservar los bytes de los comprobadores de
revisión y de README/bitácora identificados por SHA-256.

## Prioridad manuscrito: primera clasificación matemática del inventario, 17 de octubre de 2026

Por instrucción del autor se prioriza la matemática del manuscrito antes del
cierre integral Rust/ROM. Se realiza una primera clasificación manual de los
272 candidatos y su contexto en las ocho fuentes. Se distinguen definiciones,
resultados, cálculos, modelos condicionales, conjeturas, dependencias, mediciones
y contenido documental. Se identifican 14 omisiones: incentivos, quórum,
invariantes de identidad, salud, recuperación y registro, entre otras.

La matriz registra 46 grupos con criterios de cierre: 27 pendientes, 13 parciales,
tres dependencias bibliográficas, dos de respaldo documental y QROM AIR/FRI futuro.
Se añaden 15 bloques con correspondencia parcial a resultados existentes; el
registro complementario alcanza 51 bloques. Los 36 enlaces del inventario base
se conservan; 35 tenían revisión parcial marcada. Clasificación, trazabilidad y
demostración son estados distintos. La exhaustividad y el cierre global siguen
pendientes; estos conteos no son un porcentaje de esfuerzo restante.

La [revisión del manuscrito](formalizacion/REVISION-MANUSCRITO.md) prioriza entropía,
salud, residencia, amortización, bases, complejidad y el contraejemplo de distancia
7/8. Se registran seis hallazgos, incluidas frases de estado Lean anteriores al
avance actual y las hipótesis necesarias para acumular min-entropía por longitud.
Los capítulos, TG1, Rust y el inventario base permanecen intactos.

La [evidencia de revisión](Documentos/06-Evidencia-TG2/2026-10-17/Revision-Manuscrito/README.md)
conserva el comprobador de trazabilidad y seis controles negativos aprobados.
Se preservan las 149 fuentes de la auditoría vigente y 1.673 logs de 27 etapas.
Se reutiliza por hashes la auditoría de 777 resultados en 106 módulos; no se
afirma una compilación ni revisión del núcleo nueva. El comprobador no decide
verdad matemática ni sustituye dictamen. Se actualizan README, alcance e índice.

## Formalización Lean: raíz compartida y enlace AIR/FRI, 17 de octubre de 2026

Se añaden 24 resultados en cuatro módulos y se alcanzan 777 lemas y teoremas.
La revisión del experimento TG2 v1 y de la transferencia ROM precisa una
distinción de alcance: TG2 autentica también los valores AIR como Fp2 de
diecisiete bytes y comparte raíz con FRI de traza. Las hojas Fp de nueve bytes
son un componente auxiliar y del verificador legado. Se conservan todas sus
pruebas y evidencia y se precisan los alcances del registro e inventario.
El oráculo inicial TG2 no se supone globalmente base; N03 conserva su rama
de candidato no base para valores de extensión en posiciones no abiertas.

Se prueba el control booleano de raíz y la identidad del oráculo entre cortes
previos a AIR y FRI. Las seis posiciones Bool×Fin3 se identifican con x,gx,g²x
y sus opuestos mediante índices módulo N. Aperturas AIR aceptadas y registradas,
con hojas Fp2 de valores inyectados, vinculan esos puntos al oráculo congelado
y derivan el control base de la muestra. La primera pareja FRI bajo esa raíz
satisface TraceLink fuera de aciertos.

La fórmula de compose se transporta de Fp a Fp2 y coincide con composicionLocal
a partir de tres valores y ausencia de polos. Las aperturas de composición
y comparaciones locales dan ConsultaParejas. El ensamblaje N06 produce
AceptaCompartida con las dos aceptaciones FRI y coincidencias de oráculos
iniciales como premisas separadas. Faltan el bucle completo de acarreo y
constante final, perfiles y formas, todas las historias y hechos de registro,
realización causal de familias, presupuestos, distribuciones, nonces y semántica
de Rust. QROM AIR/FRI sigue futuro y la tesis completa no está verificada.

La [evidencia de enlace AIR/FRI](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Enlace-AIR-FRI/README.md)
conserva compilación, auditoría de 777 resultados y revisión secuencial de
106 módulos con leanchecker, confiando en los importados. Pasan los cinco
controles del analizador. Registra hashes de 149 fuentes y 112 logs; se añade
air.rs para documentar la distinción del legado. El inventario mantiene
272 candidatos y 36 bloques con correspondencia parcial. Se comprueban
intactas 139 fuentes protegidas y 1.561 logs de las veintiséis etapas anteriores.
Se conservan capítulos, TG1, Rust y evidencia histórica. Los procesos se ejecutan
ocultos, sin abrir terminales externas.

## Formalización Lean: hojas base y oráculos mixtos, 17 de octubre de 2026

Se añaden 36 resultados en cuatro módulos y se alcanzan 753 lemas y teoremas.
Se formalizan hojas Fp canónicas de nueve bytes: prefijo cero y ocho octetos
LE, con lectura inversa, recodificación e inyectividad. Las hojas Fp y Fp2
son entradas distintas y sus decodificadores las rechazan mutuamente; no se
identifican sus hashes. Ambos formatos comparten los nodos de 65 bytes y
exactamente las mismas etiquetas de protección de cualquier registro.

La igualdad de etiquetas transporta las extensiones seguras y la congelación
a Fp con la misma tabla ROM y función hash. Se prueba congruencia del extractor
para cualquier formato con valor cero e independencia del digest de relleno.
El oráculo base extrae Fp e inyecta después en Fp2, con cero fuera del dominio.
Todos sus valores son base y el conteo puntosFueraBase de N03 es cero. Se
prueban lectura, aperturas, plegado, estabilidad hasta el registro final sin
aciertos y un único corte para todos los índices y aperturas posteriores.

Arreglos N06 con inicial Fp y siguientes Fp2 conservan lecturas, aperturas e
igualdad entre familias de cortes de absorción y reto. Las familias siguen
siendo datos de entrada. Faltan su construcción causal global, la relación
del verificador entre compromisos separados de traza y FRI, todas las historias
y hechos de registro, constantes terminales, presupuestos S y B_T,
distribuciones, cola de índices, nonces y semántica y deserializaciones Rust.
QROM AIR/FRI sigue como trabajo futuro y la tesis completa no está verificada.

La [evidencia de hojas base](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Hojas-Base/README.md)
conserva compilación, auditoría de 753 resultados y revisión secuencial de
102 módulos con leanchecker, confiando en los importados. Pasan los cinco
controles del analizador. Registra hashes de 144 fuentes y 108 logs. El inventario
mantiene 272 candidatos y 36 bloques con correspondencia parcial. Se comprueban
intactas 135 fuentes protegidas y 1.453 logs de las veinticinco etapas anteriores.
Se conservan capítulos, TG1, Rust y evidencia histórica. Los procesos se ejecutan
ocultos, sin abrir terminales externas.

## Formalización Lean: índices Merkle y oráculos de campo, 17 de octubre de 2026

Se añaden 38 resultados en cuatro módulos y se alcanzan 717 lemas y teoremas.
Las rutas desde la raíz y los índices numéricos se enlazan mediante bits bajos,
módulo y división entre dos. Se prueban las inversas y una equivalencia entre
rutas de longitud h e índices Fin (2^h). Etiquetar los hermanos e invertir su
orden prueba que el acumulador desde la hoja coincide con la reconstrucción
del extractor. La cota i<2^h es una premisa de extracción y no se atribuye como
comprobación adicional al bucle de Rust.

El vector de hojas se extiende a un oráculo Fp2→Fp2 por capa, con cada índice
en el punto de su exponente y cero fuera del dominio. Se prueban lectura,
inyectividad y unicidad, vinculación de aperturas aceptadas y registradas y
fórmula del plegado de una pareja abierta. La congelación pasa al oráculo de
campo antes de la primera exposición del reto y hasta el registro final sin
aciertos. Un mismo corte sirve para todos los índices y aperturas posteriores.
Una familia dada de estados y raíces se empaqueta en OraculosEmitidos de N06,
conservando lectura, igualdad entre cortes de absorción/reto y aperturas.

Falta construir causalmente esa familia para todas las historias y fases,
los hechos de registro, formatos, presupuestos S y B_T, distribuciones de
retos, cola de índices, potencial de nonces y semántica de Rust. La instancia
concreta usa hojas Fp2 de 17 bytes; las hojas Fp de 9 bytes siguen pendientes.
No se deduce uniformidad al condicionar a la ausencia de aciertos futuros.
QROM AIR/FRI sigue como trabajo futuro y la tesis completa no está verificada.

La [evidencia de índices Merkle](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Indice-Merkle/README.md)
conserva compilación, auditoría de 717 resultados y revisión secuencial de
98 módulos con leanchecker, confiando en los importados. Pasan los cinco
controles del analizador. Registra hashes de 140 fuentes y 104 logs. El inventario
mantiene 272 candidatos y 36 bloques con correspondencia parcial. Se comprueban
intactas 131 fuentes protegidas y 1.349 logs de las veinticuatro etapas anteriores.
Se conservan capítulos, TG1, Rust y evidencia histórica. Los procesos se ejecutan
ocultos, sin abrir terminales externas.

## Formalización Lean: primeras consultas y exposición del reto, 17 de octubre de 2026

Se añaden 39 resultados en cuatro módulos y se alcanzan 679 lemas y teoremas.
Se recupera el origen de cada entrada almacenada desde vacío, con su solicitud,
tabla anterior y recorridos a ambos lados. Las búsquedas persisten y las
repeticiones conservan ese origen. Los prefijos anteriores al corte mantienen
ausente su entrada.

Una respuesta nueva sin acierto no está en las ventanas de entradas anteriores
ni de su propia entrada. Toda entrada que la contenga como ventana sigue
ausente después. La posición canónica en la tabla coincide con la longitud
anterior al origen. Las dependencias por ventanas aumentan estrictamente
esa posición; la relación es irreflexiva, asimétrica y bien fundada.

Para una absorción de raíz y el reto que usa su respuesta, ambos registrados
desde vacío sin aciertos, se recuperan los dos orígenes en orden. La raíz
estaba marcada antes de la primera respuesta de absorción y persiste antes
de la primera respuesta del reto. Los vectores calculados en ambos instantes
coinciden y todas las aperturas posteriores aceptadas y registradas los
respetan. Esto cubre llamadas actuales repetidas sin cobrarlas como respuestas
nuevas. Se cubren prefijos de estado en retos, trabajo y absorciones con datos≤38.

Permanecen la gramática y todas las historias válidas, derivar sus hechos de
registro, el adaptador causal N06, presupuestos S y B_T, distribuciones de retos,
cola de índices, potencial de nonces y semántica de Rust. La relación ordenada
usa ventanas de entradas de hasta 79 bytes. No se deduce uniformidad al
condicionar a la ausencia de eventos futuros. QROM AIR/FRI sigue como trabajo
futuro y la tesis completa no está verificada.

La [evidencia de primeras consultas](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Primeras-Consultas/README.md)
conserva compilación, auditoría de 679 resultados y revisión secuencial de
94 módulos con `leanchecker`, confiando en los importados. Pasan los cinco
controles del analizador. Registra hashes de 136 fuentes y 100 logs. El inventario
mantiene 272 candidatos y 36 bloques con correspondencia parcial. Se comprueban
intactas 127 fuentes protegidas y 1.249 logs de las veintitrés etapas anteriores.
Se conservan capítulos, TG1, Rust y evidencia histórica. Los procesos se ejecutan
ocultos, sin abrir terminales externas.

## Formalización Lean: congelación previa y canal, 17 de octubre de 2026

Se añaden 39 resultados en cuatro módulos y se alcanzan 640 lemas y teoremas.
La raíz puede aparecer por primera vez en la entrada actual, sin estar aún
en la tabla. Las marcas preparadas cubren las etiquetas Merkle antes de
responder y persisten tras consultas nuevas o repetidas. El vector calculado
con la tabla anterior a la respuesta se conserva; desde vacío sin aciertos,
toda apertura posterior aceptada y registrada coincide con él.

Se formalizan las fórmulas de bytes del canal: absorción etiquetada, retos
F/E/I y trabajo con nonce u64. Se recuperan los campos y la longitud dentro
de su rango u64, y se demuestra inyectividad de cada formato. Los retos miden
33 bytes y el trabajo 41. Se construye un solapamiento explícito de 65 bytes
entre absorción con 24 bytes y nodo Merkle, sin presuponer separación global
de roles. El testigo no acredita por sí solo un enunciado válido del perfil.

Una secuencia local de absorción de raíz y reto encadena la respuesta efectiva
de la primera llamada en la entrada de la segunda. Se prueba que el vector
queda fijado antes de ambas respuestas y vincula las aperturas posteriores,
incluyendo llamadas repetidas. Esa anterioridad local no establece por sí
sola anterioridad a la primera exposición de un reto ya consultado: reconstruir
esa historia global sigue pendiente. También permanecen perfiles y gramática
completos, presupuestos S y B_T, distribución de retos, cola de índices,
potencial de nonces, conexión N06 y equivalencia integral con Rust/ROM.
QROM AIR/FRI sigue como trabajo futuro y la tesis completa no está verificada.

La [evidencia de congelación previa y canal](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Congelacion-Canal/README.md)
conserva compilación, auditoría de 640 resultados y revisión secuencial de
90 módulos con `leanchecker`, confiando en los importados. Pasan los cinco
controles del analizador. Registra hashes de 132 fuentes y 96 logs, añadiendo
la fuente preservada de channel.rs. El inventario mantiene 272 candidatos y
36 bloques con correspondencia parcial. Se comprueban intactas 122 fuentes
protegidas y 1.153 logs de las veintidós etapas anteriores. Se conservan
capítulos, TG1, Rust y evidencia histórica. Los procesos se ejecutan ocultos,
sin abrir terminales externas.

## Formalización Lean: ROM con memoria y unión adaptativa, 16 de octubre de 2026

Se añaden 43 resultados en cuatro módulos y se alcanzan 601 lemas y teoremas.
La tabla del oráculo no repite entradas: una consulta repetida devuelve su
digest guardado y conserva la tabla; una nueva recibe un digest uniforme y
lo almacena. Las solicitudes y las nuevas marcas se eligen antes de responder.
El cardinal acumulado de marcas adicionales está acotado por B.

Los planes admiten parada anticipada y repeticiones sin monedas nuevas.
Se demuestra que el riesgo de algún acierto es exactamente el conteo de
cintas uniformes excepcionales dividido por (2^256)^n. La unión adaptativa
da n(49S+B)/2^256 si longitud inicial+n≤S y, desde vacío con presupuesto S,
min(1,S(49S+B)/2^256). Las marcas de cada respuesta incluyen las ventanas
de la propia entrada. No se condicionan respuestas a excepciones futuras.

Una ejecución sin acierto refina un recorrido con memoria. La tabla final
concuerda con cada respuesta previa y su compleción fuera del registro no
afecta al extractor. Se deriva ausencia de colisiones desde vacío. Para una
raíz ya marcada, las aperturas posteriores aceptadas y registradas coinciden
con el vector calculado exclusivamente con la tabla del instante de congelación.
Las raíces absorbidas quedan marcadas por sus ventanas. Las marcas adicionales
reveladas tarde no se imponen retroactivamente a respuestas anteriores.

Permanecen la gramática completa del canal, justificar sus presupuestos S
y B_T, índices, profundidades, nonces, conexión con N06 y equivalencia integral
con Rust/ROM. B en este juego cuenta digests adicionales, sin identificación
con los retos ideales de N06. QROM AIR/FRI sigue como trabajo futuro y la tesis
completa no está verificada. N07 conserva su estado de componente verificado.

La [evidencia de ROM con memoria](Documentos/06-Evidencia-TG2/2026-10-16/Lean-ROM-Memoria/README.md)
conserva compilación, auditoría de 601 resultados y revisión secuencial de
86 módulos con `leanchecker`, confiando en los importados. Pasan los cinco
controles del analizador. Registra hashes de 127 fuentes y 92 logs. El inventario
mantiene 272 candidatos y 36 bloques con correspondencia parcial. Se comprueban
intactas 118 fuentes protegidas y 1.061 logs de las veintiuna etapas anteriores.
Se conservan capítulos, TG1, Rust y evidencia histórica. Los procesos se ejecutan
ocultos, sin abrir terminales externas.

## Formalización Lean: bytes Merkle y ventanas hash, 16 de octubre de 2026

Se añaden 37 resultados en cuatro módulos y se alcanzan 558 lemas y teoremas.
La conversión LE tiene ambas identidades inversas en su rango. Se instancia
el formato de Merkle con octetos, digests de 32 bytes y valores Fp2 canónicos.
Las hojas miden 17 bytes y los nodos 65; todo mensaje admitido se reconstruye
exactamente y los digests tienen cardinal 2^256.

Se prueban todas las ventanas de 32 bytes de entradas de hasta 79 bytes,
con cardinal máximo 48. Los hijos de cualquier nodo admitido aparecen en
offsets 1 y 33. Una absorción de raíz mide 73 bytes y contiene su digest
en offset 41. Las entradas largas siguen aportando su digest al registro.

Las marcas globales incluyen respuestas, ventanas y un conjunto adicional R,
con cardinal ≤49·longitud+|R|. Antes de responder se añaden también las ventanas
de la entrada actual; con longitud<S, quedan ≤49S+|R| etiquetas. Se demuestra
que cubren las etiquetas del extractor concreto. Una raíz absorbida antes
queda marcada y sus aperturas posteriores aceptadas y registradas coinciden
con el vector congelado, bajo ausencia inicial de colisiones y extensión
sin aciertos.

Para una respuesta uniforme nueva se demuestra riesgo de acierto
≤(49S+|R|)/2^256. Permanecen la ejecución ROM con memoria, las repeticiones
y la unión adaptativa total para obtener S(49S+B_T)/2^256, la gramática
integral, índices, conexión con N06 y equivalencia completa con Rust.
La codificación concreta de bytes no constituye por sí sola una prueba del
programa. QROM AIR/FRI sigue como trabajo futuro y la tesis completa no está
verificada. N07 mantiene su estado de componente verificado.

La [evidencia de bytes Merkle](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Merkle-Bytes/README.md)
conserva compilación, auditoría de 558 resultados y revisión secuencial de
82 módulos con `leanchecker`, confiando en los importados. Pasan los cinco
controles del analizador. Registra hashes de 123 fuentes y 88 logs, añadiendo
la fuente preservada de merkle.rs. El inventario mantiene 272 candidatos y
36 bloques parcialmente revisados. Se comprueban intactas 113 fuentes
protegidas y 973 logs de las veinte etapas anteriores. Se conservan capítulos,
TG1, Rust y evidencia histórica. Los procesos se ejecutan ocultos, sin abrir
terminales externas.

## Formalización Lean: extracción Merkle congelada, 16 de octubre de 2026

Se añaden 26 resultados en cuatro módulos y se alcanzan 521 lemas y teoremas.
N07 incorpora su primer componente verificado: registro de consultas,
extracción completada con cero y vinculación de aperturas registradas.
El formato es abstracto con decodificación inversa de hojas y nodos; el hash
es una función fija. La ausencia de colisiones se exige solo en el registro.

El vector se define sobre 2^altura rutas binarias. Se prueba que una apertura
aceptada y registrada devuelve el valor extraído, y que la misma raíz y ruta
vinculan el valor. La raíz, las salidas y los dos hijos de cada nodo se marcan
como etiquetas locales, con cardinal ≤3·longitud+1. Esta cuenta no sustituye
las ventanas ni la pérdida global de Bad_H de la transferencia ROM.

Una nueva consulta cuya salida evita las etiquetas conserva ausencia de
colisiones y extracción. Se demuestra que tal entrada es necesariamente nueva.
Una secuencia de extensiones seguras mantiene fijo todo el vector, por lo que
una apertura posterior aceptada y registrada coincide con el valor congelado
antes de las nuevas consultas. La igualdad se deduce, sin recibirla como premisa.

Permanecen la serialización de bytes, índices y profundidades del verificador,
el vínculo con Bad_H y su cota de probabilidad, la conexión con los oráculos
de N06 y la transferencia ROM completa. La condición de extensión segura es
determinista y N07 no está cerrado. QROM AIR/FRI sigue como trabajo futuro.
La tesis completa no está verificada.

La [evidencia de Merkle congelado](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Merkle-Congelado/README.md)
conserva compilación, auditoría de 521 resultados y revisión secuencial de
78 módulos con `leanchecker`, confiando en los importados. Pasan los cinco
controles del analizador. Registra hashes de 118 fuentes y 84 logs.
Ocho de doce afirmaciones tienen componentes mecanizados. El inventario
mantiene 272 candidatos y pasa a 36 bloques parcialmente revisados.
Se comprueban intactas 109 fuentes protegidas y 889 logs de las diecinueve
etapas anteriores. Se conservan capítulos, TG1, Rust y evidencia histórica.
Los procesos se ejecutan ocultos, sin abrir terminales externas.

## Formalización Lean: gramática explícita y transporte de planes, 16 de octubre de 2026

Se añaden 29 resultados en cuatro módulos y se alcanzan 495 lemas y teoremas.
Anexar una respuesta conserva la historia previa y el destino explícito
coincide con el de cualquier política que realice los mensajes de su origen.

`PasoExplicito` une la gramática de mensajes con datos de destino que reproducen
todos los mensajes anteriores. Se demuestra correspondencia exacta con los
pasos observados y se deduce la conservación del estado, sin tomar esa igualdad
como permiso de transición. `PlanExplicito` solo añade esos pasos y retos
desde orígenes guardados, conserva los nodos anteriores y cobra cada reto
nuevo aunque se restaure una rama previa.

La evaluación propia por medias uniformes coincide con la expansión al árbol
genérico. Para un enunciado sin traza base válida, 4≤k≤29 y q≤4T, se demuestra
min(1,B·errorRonda(k,q)); en los nueve perfiles 4≤k≤12 y q=40 se obtiene
min(1,B·h_T). B cuenta retos ideales frescos, no consultas SHA3.

Para cada función terminal se transportan planes completos en ambas direcciones,
con el registro codificado o decodificado y el mismo presupuesto, conservando
su valor. Cada plan desde la raíz tiene uno del otro modelo con la misma
probabilidad de aceptación. La correspondencia es entre dos modelos ideales
internos; no afirma que toda forma tipada arbitraria sea alcanzable desde vacío.
Permanecen el adaptador bibliográfico integral, formatos inválidos, aperturas
y Rust/Merkle/ROM. QROM AIR/FRI sigue como trabajo futuro y la tesis completa
no está verificada.

La [evidencia de planes explícitos](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Planes-Explicitos/README.md)
conserva compilación, auditoría de 495 resultados y revisión secuencial de
74 módulos con `leanchecker`, confiando en los importados. Pasan los cinco
controles del analizador. Registra hashes de 114 fuentes y 80 logs.
El inventario mantiene 272 candidatos y 35 bloques parcialmente revisados.
Se comprueban intactas 105 fuentes protegidas y 809 logs de las dieciocho
etapas anteriores. Se conservan capítulos, TG1, Rust y evidencia histórica.
Los procesos se ejecutan ocultos, sin abrir terminales externas.

## Formalización Lean: datos explícitos de prefijos y retos, 16 de octubre de 2026

Se añaden 32 resultados en cuatro módulos y se alcanzan 466 lemas y teoremas.
Los datos de cada fase se representan mediante arreglos finitos de oráculos
y constantes, junto con su fase y retos. Se prueba que la lectura y captura
son inversas sobre los datos emitidos, y que la igualdad de capturas equivale
exactamente a `MismosMensajes`.

`politicaDeDatos` reproduce cualquier conjunto de datos del prefijo indicado
con valores fijos que no reciben retos futuros. Esto realiza un prefijo
individual y no afirma todavía alcanzabilidad de todas las formas tipadas
ni realización uniforme de familias arbitrarias de transcripciones.
La codificación y decodificación entre datos explícitos y prefijos observados
son inversas. Se transportan estado y aceptación, estado inicial, rechazo
en cero y conservación por los mensajes capturados de un paso tipado.

Las peticiones explícitas contienen los datos fijados antes de la nueva
respuesta. Su política canónica reproduce el origen y la codificación del
destino coincide con el reto observado. Se demuestra absorción y cota local
universal `errorRonda(k,q)`; en los nueve perfiles con q=40 se obtiene h_T.
El caso de enunciado válido permanece en uno y tiene cambio cero.

El corolario anterior de reinicios con políticas compatibles se conserva
en el modelo observado. Permanecen la traducción de todos los planes de
adversarios, la gramática explícita completa y su alcanzabilidad, formatos
inválidos y aperturas. Los oráculos son funciones matemáticas completas;
Rust/Merkle/ROM sigue pendiente. QROM AIR/FRI permanece como trabajo futuro
y la tesis completa no está verificada.

La [evidencia de transcripción explícita](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Transcripcion-Explicita/README.md)
conserva compilación, auditoría de 466 resultados y revisión secuencial del
núcleo en 70 módulos, confiando en los importados. Pasan los cinco controles
del analizador de axiomas. Registra hashes de 110 fuentes y 76 logs.
El inventario mantiene 272 candidatos y 35 bloques parcialmente revisados.
Se comprueban intactas 101 fuentes protegidas y 733 logs de las diecisiete
etapas anteriores. Se conservan los capítulos, TG1, Rust y la evidencia
histórica. Los procesos se ejecutan ocultos, sin terminales externas.

## Formalización Lean: estado sobre mensajes y políticas compatibles, 16 de octubre de 2026

Se añaden 41 resultados en cinco módulos y se alcanzan 434 lemas y teoremas.
Se demuestra congruencia de residuos, monitores, marcas y aceptación sobre
la historia recorrida, sin exigir igualdad de políticas en otras ramas.

Se identifica que el modelo general anterior también consultaba un oráculo
terminal adicional. `normalizarTerminal` lo fija a la constante enviada,
conserva los mensajes tipados y la marca previa a consultar, y hereda las
cotas generales. No se reescriben las pruebas históricas ni se afirma
igualdad de aceptación para cada política general anterior.

`MismosMensajes` compara los oráculos y constantes ya emitidos, incluido el
oráculo actual cuando está fijado antes del reto. Se prueban su equivalencia
y la invariancia del estado normalizado. `PrefijoObservado` conserva fase
y retos y toma el cociente por esa relación. El estado y la aceptación quedan
bien definidos sin recibir una política futura. Se prueban estado inicial
uno iff enunciado válido, conservación por mensajes compatibles, absorción,
rechazo en cero y cota local para enunciados válidos y falsos.

`PlanObservado` elige una política por petición y adapta las continuaciones
a las respuestas anteriores. La clase de mensajes del origen debe estar
guardada y solo se permiten mensajes tipados. Cambiar la política respeta
los oráculos ya fijados. Se demuestra `min(1,B·errorRonda(k,q))` y, en los
nueve perfiles con q=40, `min(1,B·h_T)`. B cuenta retos ideales frescos;
restaurar un nodo no devuelve el presupuesto consumido y no se identifica
ese presupuesto con consultas SHA3.

Permanece el adaptador integral a las transcripciones y adversarios de la
definición bibliográfica: realización y equivalencia de la gramática ideal
completa, formatos inválidos y aperturas. Rust/Merkle/ROM sigue pendiente.
QROM AIR/FRI permanece como trabajo futuro y la tesis completa no está
verificada.

La [evidencia de estado observado](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Estado-Observado/README.md)
conserva compilación, auditoría de 434 resultados y revisión secuencial del
núcleo en 66 módulos, confiando en los importados. Pasan los cinco controles
del analizador de axiomas. Registra hashes de 106 fuentes y 72 logs.
El inventario mantiene 272 candidatos y 35 bloques parcialmente revisados.
Se comprueban intactas 96 fuentes protegidas y 661 logs de las dieciséis
etapas anteriores. Se conservan los capítulos, TG1, Rust y la evidencia
histórica. Los procesos se ejecutan ocultos, sin terminales externas.

## Formalización Lean: prefijos reconstruidos y mensajes tipados, 16 de octubre de 2026

Se añaden 22 resultados en tres módulos y se alcanzan 393 lemas y teoremas.
Los prefijos distinguen las fases AIR, FRI de traza, FRI de composición,
consulta y salida; sus longitudes están limitadas por el tipo. Al añadir
un reto al final se reconstruyen exactamente el acumulador y la marca,
y su proyección reproduce las transiciones del certificado anterior.

El estado inicial vale uno si y solo si existe una traza base válida de
grado menor que T. En los enunciados falsos se reconstruye la marca de los
monitores desde los retos. Los pasos sin monedas conservan el estado,
cada respuesta mantiene el estado uno y el estado final cero implica
rechazo del predicado compartido.

`PlanCausal` solo añade mensajes de su gramática y respuestas a retos
cuyo origen esté guardado. Los mensajes y constantes se determinan con
una política causal usando monedas anteriores. Se transporta la cota
local y se demuestra `min(1,B·errorRonda(k,q))`; en los nueve perfiles con
q=40 se obtiene `min(1,B·h_T)`. Restaurar un prefijo no devuelve el
presupuesto de retos frescos consumido.

Esta expansión mantiene fija una política causal. La función aún está
parametrizada por ella: faltan la invariancia entre políticas que coinciden
en el prefijo y el transporte de sus cambios entre ramas. El juego anterior
de políticas adaptativas por nodo conserva su alcance separado. No se
declara cerrado el adaptador bibliográfico universal ni el del ejecutable.
B cuenta retos ideales y no consultas SHA3. Rust/Merkle/ROM permanece
pendiente; QROM AIR/FRI sigue como trabajo futuro y la tesis no está
verificada en su totalidad.

La [evidencia de transcripción causal](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Transcripcion-Causal/README.md)
conserva compilación, auditoría de 393 resultados y revisión secuencial del
núcleo en 61 módulos, confiando en los importados. Pasan los cinco controles
del analizador de axiomas. Registra hashes de 101 fuentes y 67 logs.
El inventario mantiene 272 candidatos y 35 bloques parcialmente revisados.
Se comprueban intactas 93 fuentes protegidas y 594 logs de las quince
etapas anteriores. Se conservan los capítulos, TG1, Rust y la evidencia
histórica; los procesos se ejecutan ocultos, sin terminales externas.

## Formalización Lean: políticas adaptativas entre reinicios, 16 de octubre de 2026

Se añaden otros cinco resultados y se alcanzan 371 lemas y teoremas.
La primera instancia del juego restaurable mantiene una política global
fija, aunque adapta las peticiones a las respuestas. Esta ampliación guarda
la política en cada nodo y permite elegir otra en cada petición, según
toda la historia de intentos. Los nodos anteriores y sus marcas se conservan.

Se instancia el certificado por rondas con la política de la petición actual
y se obtiene `probabilidadAdaptativa≤min(1,B·errorRonda(k,q))` para un
enunciado falso fijado. En los nueve perfiles con q=40 se demuestra
`min(1,B·h_T)`, también al promediar planes con semilla finita uniforme.
Los mensajes pueden añadir cualquier nodo con la misma marca; los orígenes
de retos deben estar guardados. Restaurar un nodo no recupera el presupuesto
de retos frescos ya consumido.

La [evidencia de políticas adaptativas](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Reinicios-Adaptativos/README.md)
conserva compilación, auditoría de 371 resultados y revisión secuencial del
núcleo en 58 módulos. Pasan los cinco controles del analizador de axiomas.
El inventario mantiene 272 candidatos y 35 bloques parcialmente revisados.
Se conservan los capítulos, TG1, Rust y las catorce etapas anteriores; se
comprueban 92 fuentes protegidas y 530 logs históricos sin diferencias.
Los procesos se ejecutan ocultos, sin terminales externas.

Esta continuación suma 26 resultados: 21 para el registro restaurable y
su primera instancia, y cinco para políticas elegidas por rama. Permanecen
el adaptador formal bibliográfico y del protocolo, la semántica integral de
Rust, extracción/vinculación Merkle, sesgo modular, selector de parejas y
transferencia ROM. B cuenta nuevos sorteos ideales y no consultas SHA3.
La tesis completa no está verificada y QROM AIR/FRI sigue como trabajo futuro.

## Formalización Lean: reinicios ideales adaptativos, 16 de octubre de 2026

Se añaden 21 resultados y se alcanzan 366 lemas y teoremas registrados.
`PlanRestaurable` representa decisiones adaptativas con un registro de nodos
guardados: los retos parten de un origen ya obtenido, sus respuestas añaden
destinos y consumen presupuesto; mensajes y restauraciones no requieren
nuevos sorteos. Los mensajes conservan la marca y los tipos de respuesta
pueden variar con cada petición. El plan puede terminar antes de agotar B.

Se demuestra la cota `min(1,B·epsilon)` bajo cotas condicionales locales,
sin independencia entre eventos. Una marca guardada no se borra al volver
a una rama en cero; desde un registro sin marcas, su probabilidad coincide
con una primera transición excepcional. Toda aceptación guardada implica
esa transición. La cota se conserva al promediar planes sobre una semilla
finita uniforme. La media uniforme del subtipo de muestras de parejas se
identifica con `probabilidadConsulta`.

Se instancian nodos y peticiones AIR/FRI/consulta con los monitores existentes.
Esta primera instanciación mantiene fija la política de oráculos para todo
el árbol; las peticiones y sus continuaciones son adaptativas.
Cada cota se deduce de `CertificadoRondas`, y una salida aceptada activa su
marca. Para un enunciado falso se obtiene desde la raíz cero
`probabilidadReinicios≤min(1,B·errorRonda(k,q))`. En los nueve perfiles con
q=40 se obtiene `min(1,B·h_T)`. B cuenta retos ideales frescos; una respuesta
reutilizada restaura su nodo guardado y no se sortea de nuevo.

La [evidencia de reinicios ideales](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Reinicios-Ideales/README.md)
conserva compilación, auditoría de 366 resultados y revisión secuencial del
núcleo en 57 módulos. Pasan los cinco controles del analizador de axiomas.
El inventario mantiene 272 candidatos y 35 bloques parcialmente revisados.
Se preservan capítulos, TG1, Rust y las trece etapas anteriores; se comprueban
88 fuentes protegidas y 467 logs históricos sin diferencias. Los procesos
se ejecutan ocultos, sin terminales externas.

Permanecen el adaptador formal a la definición bibliográfica y la
correspondencia integral con la transcripción y los mensajes del protocolo.
El juego permite mensajes arbitrarios con la misma marca. No se identifica
B con consultas SHA3: faltan registro hash, extracción/vinculación Merkle,
sesgo modular, selector de parejas y transferencia ROM. La tesis completa
no está verificada y QROM AIR/FRI sigue como trabajo futuro.

## Formalización Lean: estado absorbente y solidez por rondas, 16 de octubre de 2026

Se añaden 29 resultados y se alcanzan 345 lemas y teoremas registrados.
Se construye una marca booleana que empieza en cero, se conserva con los
mensajes y es absorbente en uno. Su recursión equivale al evento `Escapa`.
La probabilidad de cambio cuenta solo una transición nueva de cero a uno.

Los residuos vigilados se fijan con el candidato inicial y el enunciado;
AIR solo vigila la última ronda de residuo no nulo. FRI de traza se vigila
sin candidato próximo y FRI de composición en la rama base si su oráculo
inicial es lejano. Se demuestran cotas condicionales ≤1/p² para AIR y
≤4T/p² para cada plegado, para cualquier estado e historia. Las marcas se
transportan entre fases sin perder una excepción anterior.

Para un enunciado falso, estado cero antes de consultar equivale exactamente
a `PrefijoSeguro`. La consulta compartida tiene cota de cambio ≤H(4T,q,1/8).
La aceptación activa la marca y estado final cero implica rechazo.
`solidez_por_rondas` construye el certificado de las transiciones concretas
con `max(1/p²,4T/p²,H)`. En los nueve perfiles 4≤k≤12 con q=40, una comparación
racional exacta identifica ese máximo con h_T, como cota escogida y no como
error óptimo. La cota ordinaria H+(8T−3)/p² de la etapa previa se conserva.

La [evidencia de solidez por rondas](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Solidez-Rondas/README.md)
conserva compilación, auditoría de 345 resultados y revisión secuencial del
núcleo en 53 módulos. Pasan los cinco controles del analizador de axiomas.
El inventario mantiene 272 candidatos y 35 bloques parcialmente revisados.
Se preservan los capítulos, TG1, Rust y las doce etapas anteriores; se
comprueban 84 fuentes protegidas y 408 logs históricos sin diferencias.
Los procesos se ejecutan ocultos, sin terminales externas.

Permanecen el corolario de intentos/reinicios ideales y la traducción formal
del certificado a la definición bibliográfica de solidez por rondas. También
la correspondencia integral con la transcripción y los mensajes del protocolo,
la semántica de Rust, los compromisos/aperturas Merkle y la transferencia ROM.
Los intentos ideales no se identifican con consultas SHA3. La tesis completa
no está verificada y QROM AIR/FRI sigue como trabajo futuro.

## Formalización Lean: ejecución causal y solidez interactiva, 16 de octubre de 2026

Se añaden 24 resultados y se alcanzan 316 lemas y teoremas registrados.
Las transcripciones finitas uniformes se enlazan con las funciones de retos
y las historias FRI: no escapar equivale a evitar cada conjunto excepcional
calculado con su prefijo. Se prueba la cota de cualquier valor terminal
acotado fuera del escape y, en particular, la aceptación FRI promediada
sobre retos y consulta, incluyendo las transcripciones excepcionales.

`PoliticaConsulta` fija la traza antes de AIR y ejecuta AIR → FRI de traza →
FRI de composición → muestra compartida. Cada mensaje recibe solo monedas
anteriores; las constantes finales preceden al muestreo. Se demuestra la
invariancia de la traza inicial y se construyen los prefijos a partir de
monedas uniformes. Para un enunciado sin traza base válida, la probabilidad
de producir un prefijo inseguro es ≤(8T−3)/p². Según la rama inicial, se paga
FRI de traza, ninguna excepción o AIR más FRI de composición.

Con δt=δc=1/8, 4≤k≤29 y q≤4T, `solidez_interactiva_compartida` demuestra
`probabilidadConjunta≤H(4T,q,1/8)+(8T−3)/p²`. No se condiciona el experimento
a prefijos seguros ni se multiplican errores de ambos FRI. Para q=40 se
obtiene también `(7/8)^40+(8T−3)/p²` y se enlaza la desigualdad con los cuatro
superiores decimales de la tabla 6.22.

La [evidencia de solidez interactiva](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Solidez-Interactiva/README.md)
conserva compilación, auditoría de 316 resultados y revisión secuencial del
núcleo en 49 módulos. Pasan los cinco controles del analizador de axiomas.
El inventario mantiene 272 candidatos y 35 bloques parcialmente revisados.
Se preservan los capítulos, TG1, Rust y las once etapas anteriores; los
procesos se ejecutan ocultos, sin abrir terminales externas.

Permanece la función de estado y la obligación condicional de cada ronda
para epsilon_rbr=h_T escogida. También la correspondencia integral del orden
y los mensajes con la transcripción exacta del protocolo, la semántica de
Rust, los compromisos/aperturas Merkle y la transferencia ROM. La cota cubre
el modelo interactivo ideal y el perfil 1/8; otros radios siguen pendientes.
La tesis completa no está verificada y QROM AIR/FRI sigue como trabajo futuro.

## Formalización Lean: consulta compartida sobre parejas, 16 de octubre de 2026

Se añaden 35 resultados y se alcanzan 292 lemas y teoremas registrados.
Se define la probabilidad exacta de un predicado sobre una muestra uniforme
de q parejas distintas. Los fallos puntuales determinan las parejas buenas,
con a lo sumo dos fallos por pareja. Se demuestra que aceptar FRI sobre la
muestra equivale a aceptar todos sus recorridos individuales; se construye
el conjunto de parejas aceptantes y se prueba que su unión acepta. Esto
deduce H para la muestra aceptada sin recibir un conjunto G como premisa.

Los controles de campo base y enlace se instancian sobre r(y),−r(y) en los
cosets Goldilocks. `AceptaCompartida` usa la misma muestra para ambos FRI,
las seis posiciones base AIR y el enlace de composición en ambas mitades.
`PrefijoSeguro` exige ausencia de excepciones solo en la rama activa. Para
δt=δc=1/8, 4≤k≤29 y q≤4T, se demuestra la cota H(4T,q,1/8) por los cuatro
casos, cuyo máximo es esa misma cota. El resultado se conserva al promediar
o ponderar distribuciones finitas soportadas en prefijos seguros. Para
cuarenta parejas se obtiene además (7/8)^40.

La [evidencia de consulta compartida](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Consulta-Compartida/README.md)
conserva compilación, auditoría de 292 resultados y revisión secuencial del
núcleo en 45 módulos. Pasan los cinco controles del analizador de axiomas.
El inventario mantiene 272 candidatos en ocho fuentes y 35 bloques de
correspondencia parcial revisada. Se preservan los capítulos, TG1, Rust y
las diez etapas anteriores; los procesos se ejecutan ocultos.

Falta construir la ejecución causal conjunta que genera el prefijo y acotar
la probabilidad de incumplir `PrefijoSeguro` mediante los monitores AIR/FRI.
El promedio de prefijos seguros no sustituye esa obligación. Las cotas
globales h_T+(8T−3)/p² y epsilon_rbr=h_T escogida siguen pendientes.
La tesis completa no está verificada; QROM AIR/FRI conserva su estado de
trabajo futuro. La equivalencia con Rust/Merkle/ROM permanece separada.

## Formalización Lean: candidato previo a AIR y ronda crítica, 16 de octubre de 2026

Se añaden 27 resultados y se alcanzan 257 lemas y teoremas registrados.
El selector recibe solo el dominio, el oráculo, el grado y el radio; devuelve
ninguno exactamente cuando el oráculo está lejos de todo el código. En el
perfil de unicidad identifica el candidato próximo y no depende de valores
fuera del dominio. Se construyen las ramas lejana, candidato no base y
candidato base antes de los coeficientes AIR. Para un enunciado falso se
derivan, respectivamente, alejamiento, fracción no base >3/4 e invalidez AIR.

Se elige el último residuo no nulo antes de sortear los retos. La suma previa
determina en esa ronda un conjunto de a lo sumo un coeficiente cancelante;
las demás rondas no marcan escape. Se prueba que el escape secuencial
equivale a cancelación total, que los retos posteriores no la revierten y
que su probabilidad es ≤1/|K|. La especialización a los tres residuos AIR
Goldilocks da ≤1/p². Fuera del escape se obtiene la transferencia para el
candidato seleccionado, y cualquier composición cae en la rama lejana o
en la de enlace, con distancia ≥max(0,(5T+1)/(8T)−3δt−δc).

La [evidencia de candidato y AIR](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Candidato-AIR/README.md)
conserva compilación, auditoría de 257 resultados y revisión secuencial del
núcleo en 41 módulos. Pasan los cinco controles del analizador de axiomas.
El inventario conserva 272 candidatos y alcanza 35 bloques de correspondencia
parcial revisada. Se preservan los capítulos, TG1, Rust y las nueve etapas
anteriores; los procesos se ejecutan ocultos.

Falta reunir los estados AIR/FRI, las constantes finales y la consulta
compartida en la misma transcripción, instanciar las parejas de los controles
locales y demostrar el máximo de los casos activos. La cota global
h_T+(8T−3)/p² y la solidez por rondas escogida siguen pendientes.
La tesis completa no está verificada; QROM AIR/FRI continúa como trabajo futuro.

## Formalización Lean: historias adaptativas de N06, 16 de octubre de 2026

Se añaden 25 resultados y se alcanzan 230 lemas y teoremas registrados.
El experimento finito de retos uniformes frescos admite un estado con toda
la historia anterior y un escape absorbente. Se demuestra que la recursión
de medias condicionales coincide con el promedio de los |K|^n vectores de
retos, con conteo exacto del evento excepcional y cota de unión adaptativa.
Cada conjunto excepcional FRI se construye del oráculo actual, antes del
nuevo reto y sin recibir los oráculos futuros. La recuperación, el lema B
y el muestreo se extienden a estrategias que dependen del prefijo.

En Goldilocks se obtienen probabilidades de excepciones ≤(8T−8)/p² en
traza y ≤(8T−4)/p² en composición, y ≤4T/p² por capa. Para una historia
sin excepciones y un oráculo lejano, cuarenta parejas uniformes distintas
conservan las cotas H(4T,40,1/8) y (7/8)^40. La
[evidencia de historias N06](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Historias-N06/README.md)
conserva compilación, auditoría de 230 resultados y revisión secuencial del
núcleo en 37 módulos. Pasan los cinco controles del analizador de axiomas.

N06 incorpora componentes verificados y permanece incompleto: faltan la
selección temporal del candidato, la ronda crítica AIR y el estado conjunto
con una sola consulta compartida. El evento de escape y el muestreo deben
reunirse en un mismo espacio de transcripciones para demostrar la cota
global h_T+(8T−3)/p². No se multiplican probabilidades de ambos FRI.
Se conservan los capítulos, TG1, Rust, las ocho etapas anteriores y los
272 candidatos del inventario, con 34 bloques parcialmente revisados.
Los procesos se ejecutan ocultos. La tesis completa sigue sin estar
verificada; QROM AIR/FRI permanece como trabajo futuro.

## Formalización Lean: cosets FRI concretos, 16 de octubre de 2026

Se añaden 31 resultados y se alcanzan 205 lemas y teoremas registrados.
Se construyen los cosets de todas las capas, sus raíces y representantes
por índices únicos, y se instancian las torres Goldilocks de traza y
composición. Sus grados iniciales son T y 2T, con dominios finales de
ocho y cuatro puntos. Se aplican los márgenes y el muestreo completo para
θ=1/8 y q=40. También se prueban las posiciones de las parejas y la
fórmula algebraica del plegado, con referencia a la fuente histórica
`fri.rs` cuyo hash se añade a la evidencia.

La [evidencia de cosets FRI](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Cosets-FRI/README.md)
conserva compilación, auditoría de axiomas y revisión secuencial del núcleo
en 34 módulos. El inventario mantiene 272 candidatos en ocho fuentes,
con 34 bloques parcialmente revisados. Se conservan los capítulos, TG1,
Rust y las siete etapas anteriores; los procesos se ejecutan ocultos.

La cota de muestreo se condiciona a evitar los conjuntos excepcionales.
Faltan las historias adaptativas y probabilidades condicionales de N06,
la composición con AIR, la semántica integral del ejecutable, Merkle/ROM
y el resto del inventario matemático. El rango de construcción k≤29
incluye el perfil implementado k≤12, sin ampliarlo. QROM se mantiene
como trabajo futuro y la tesis completa sigue sin estar verificada.

## Formalización Lean: propagación por una torre FRI, 16 de octubre de 2026

Se añaden 26 resultados y se alcanzan 174 lemas y teoremas registrados.
Se demuestra que la densidad de los recorridos no disminuye al cuadrar,
se recupera el acuerdo por todas las capas de una torre finita abstracta
desde la constante final y se deriva el lema B. Su enlace con el muestreo
obtiene H(M,q,θ) y (1−θ)^q para las parejas que pasan el recorrido entero,
sin asumir una cota de su cardinal. Se formalizan además los grados,
cardinales y la cuenta telescópica de excepciones de una fase.

La [evidencia de la torre FRI](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Torre-FRI/README.md)
conserva compilación, auditoría de axiomas y revisión secuencial del núcleo
en 31 módulos. El inventario mantiene 272 candidatos en ocho fuentes,
con 33 bloques parcialmente revisados. Los capítulos, TG1 y la evidencia
histórica se preservan; los procesos de verificación se ejecutan ocultos.

La torre exige relaciones explícitas entre dominios, raíces y grados.
Falta construirla para todos los cosets Goldilocks de ambos FRI, comprobar
la correspondencia de Acepta con Rust/Merkle y enlazar los controles con
la elección adaptativa de oráculos y las probabilidades de N06. La tesis
completa sigue sin estar verificada y QROM conserva su estado de trabajo futuro.

## Formalización Lean: plegado de una capa y muestreo, 16 de octubre de 2026

Por indicación del autor, toda la matemática del manuscrito entra en el alcance
de Lean. Las etapas acumuladas registran 148 lemas y teoremas; esta etapa añade
22 sobre el lema A con radio real, los márgenes de todas las capas, la
recuperación algebraica de una capa FRI sobre ambas mitades de cada pareja,
la cota hipergeométrica con techo y su comparación con (1−θ)^q. Se demuestra
el paso de discrepancias a parejas malas y se comprueban exactamente los
cuatro redondeos refinados de la tabla 6.22. Los nueve perfiles implementados
admiten las cuarenta parejas distintas y el techo T/2.

La [evidencia de la etapa](Documentos/06-Evidencia-TG2/2026-10-16/Lean-Plegado-Muestreo/README.md)
registra compilación, auditoría de axiomas, recomprobación secuencial del
núcleo en 27 módulos y hashes. El inventario inicial conserva 272 candidatos
en ocho fuentes, con 30 bloques de correspondencia parcial revisada. Las
etapas anteriores y los capítulos permanecen intactos. Los procesos de
verificación se ejecutan sin abrir ventanas de consola.

La tesis completa sigue sin estar verificada. Permanecen la propagación por
todas las capas y sus dominios, los estados temporales de N06, Merkle/ROM,
la correspondencia con Rust y la revisión del resto del inventario. La tabla
6.22 tiene verificada la aritmética de su límite propuesto, no todavía la
desigualdad de solidez conjunta. QROM conserva su alcance de trabajo futuro.

## Revisión con subagentes y fuentes web, 12 de octubre de 2026

Por solicitud del autor se delegaron tres revisiones: R1/ML-DSA, AIR/ROM y evidencia experimental. Los informes conservan fuentes primarias, localizadores, versiones y contrastes reproducibles en [el paquete de revisión](Documentos/04-Administrativo-TG2/Avances/Revision-Subagentes-2026-10-12/README.md). Se corrigen el hash externo de transacciones, la semilla retenida frente a la fuente monitoreada, la conformidad no certificada y las afirmaciones causales/asintóticas de las mediciones. Se contextualiza la mejora de Fallahpour–Fehr–Huang sin atribuirla automáticamente al ejecutable. La terminación extrema del contador de máscaras conserva su obligación R1-D.

La conciliación experimental pasa 451 comprobaciones sin nuevos benchmarks: R4 y complemento respaldados; H1/H2 y caché permanecen separados. La diferencia de medianas se calcula desde precisión completa: 151,33 µs. El conteo exacto de ocupación confirma la cola conservadora en nueve perfiles; no representa seguridad global ni tasa de ataques. La formalización Lean de FRI encontrada es una referencia futura con hipótesis, sin compilación ni mecanización de NEXUS.

Se repiten cargo check/build y 197 pruebas Rust, junto con 40 pruebas Python y el catálogo documental. El manuscrito se regenera y su registro de formato e integridad queda en [la nueva consolidación](Documentos/06-Evidencia-TG2/2026-10-12/Revision-subagentes/Consolidacion/). Se preservan los 176 archivos protegidos, el código Rust, TG1 aprobado y los paquetes matemáticos originales. La revisión interna no sustituye el dictamen del director. Por indicación expresa del autor, la sustentación se aplaza; QROM completo AIR/FRI continúa como trabajo futuro.

## Consolidación del manuscrito y revisión de antecedentes, 12 de octubre de 2026

Por solicitud del autor, se consolidó la revisión de las afirmaciones heredadas en la edición TG2. Se precisan el presupuesto histórico de 100 bits, conocimiento cero, alcance del AIR, condiciones de firma, protección de semillas y amortización. Se integran §§6.7.7–6.7.10: lectura crítica de antecedentes, solidez ideal por rondas, transferencia ROM y potencial para nonces, y alcance QROM como trabajo futuro. Las derivaciones propuestas y R1-A–E conservan el dictamen pendiente; no se atribuye la aprobación previa del director a esta edición.

Se generan el manuscrito Markdown, Word y PDF y un nuevo suplemento de derivaciones del 12 de octubre, preservando el anterior. La edición tiene 110 páginas Word y 97 PDF, 34 tablas, 848 celdas comparadas, tres figuras y 560 ecuaciones nativas; el suplemento tiene 14 tablas y 673 ecuaciones nativas. Se revisan las páginas renderizadas y se corrigen desbordamientos de dos ecuaciones y la tabla de presupuestos, sin cambiar sus términos. El PDF no presenta páginas vacías ni texto fuera de márgenes.

Pasan cargo check con todos los targets, 197 pruebas Rust y cargo build; también 30 pruebas Python de los complementos y diez del verificador de edición. El catálogo conserva doce afirmaciones y nueve archivos íntegros. La protección por SHA-256 verifica 176 archivos de TG1, Rust y paquetes matemáticos originales. Los procesos hijos de los lanzadores modificados se ejecutan ocultos. El renderer empaquetado carece de sus dependencias; se usa la renderización nativa de Word existente. Los resultados se registran en [la evidencia de consolidación](Documentos/06-Evidencia-TG2/2026-10-12/Consolidacion-manuscrito/).

El código probado está en c5c466c6350e4ff06d04d27ed68b029095c7aec8; las demostraciones preservan su referencia a 01dcde960402b6c60a19242b7ae3d6ac3d82a518. Se sincronizan balance, índices, preguntas de revisión, guion y manifiesto. La entrega académica, el dictamen y la sustentación siguen por registrar. [Informe de cambios](Documentos/04-Administrativo-TG2/Avances/Consolidacion-Manuscrito-TG2-2026-10-12.md).

## Catálogo de afirmaciones y evaluación de OpenAI Math, 12 de octubre de 2026

Por indicación del autor, se adapta la estructura de enunciado, solución y alcance de Lean/Comparator al [catálogo de validación](Documentos/04-Administrativo-TG2/Avances/Catalogo-Validacion-2026-10-12/README.md). Doce entradas enlazan M1–M6 y R1 con sus hipótesis, dependencias, localizadores y nueve archivos identificados por SHA-256. El comprobador usa la biblioteca estándar de Python y solo verifica integridad y coherencia documental. No constituye una mecanización, una nueva ejecución de Rust ni un dictamen independiente.

La evaluación externa fija `openai/math` en `fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb`. El resultado 279 queda como candidato secundario de factorización cuántica, sin incorporación a la bibliografía principal ni uso como fundamento de resistencia de ML-DSA. Se distingue el desafío Comparator, que puede contener `sorry`, de la solución y su ejecución. La verificación Lean del preprint queda pendiente.

El catálogo referencia el análisis del código `01dcde960402b6c60a19242b7ae3d6ac3d82a518` y una instantánea preservada. El checkout local de `nexus/` observado está en `c5c466c6350e4ff06d04d27ed68b029095c7aec8`; no se cambia ni se atribuyen sus resultados a la edición histórica. El manuscrito y sus salidas conservan la edición previa; QROM de AIR/FRI sigue como trabajo futuro. El complemento no añade Lean como requisito de cierre académico.

## Decisión de alcance: QROM como trabajo futuro, 23 de septiembre de 2026

El autor indicó expresamente: «Deja en memoria QROM como trabajo futuro». Se registra como decisión vigente para la transferencia QROM completa del protocolo AIR/FRI de TG2 v1. La cota de omisión β^S, el dictamen de esa línea y sus parámetros conjuntos quedan como investigación futura y dejan de ser requisitos del plan de cierre activo. No se reanudará esa investigación por defecto al continuar el cierre; se retomará cuando el autor lo solicite expresamente.

Se conservan los cuatro paquetes QROM, sus demostraciones propuestas, pruebas y límites. La cota de cola no resuelve la omisión ni acredita seguridad QROM completa. La decisión no altera las obligaciones de correspondencia y revisión R1 de ML-DSA, ni constituye un nuevo dictamen del director. Se actualizan memoria local, pendientes, ruta, balance, brief, índice y paquete de revisión. La prioridad pasa a revisar y delimitar las afirmaciones incluidas, consolidar el manuscrito y preparar la sustentación. Los apartados siguientes conservan el historial de investigación.

## Consolidación de pendientes, 23 de septiembre de 2026

Ante la consulta del autor, se cotejó `PENDIENTES.md` con la ruta de cierre y el último informe QROM. El desarrollo de omisión, el dictamen y los parámetros QROM quedan como tareas independientes. Se explicitan el seguimiento F0/E0–E4, la trazabilidad y repetición de mediciones, la integración de los complementos revisados al manuscrito y al Word de derivaciones, la regeneración y revisión de formatos, la actualización del manifiesto y la plantilla institucional si se exige. El ensayo detalla los temas de defensa. Esta actualización es documental; conserva el estado técnico y los resultados registrados en la entrada siguiente.

## Cota cuántica de la cola de índices, 23 de septiembre de 2026

Se continuó Q2 en `main`. El [nuevo informe](Documentos/04-Administrativo-TG2/Avances/Cola-QROM-2026-09-23/Cola-y-Conteo-QROM.md) separa omisión y cola y propone una demostración para esta última. Una cadena anclada en la absorción del nonce no puede tener ciclos sin colisiones; una cola de R pasos registra R entradas distintas cuyos índices caben en un conjunto de 39 posiciones.

Para un conjunto fijo se define un contador de respuestas. La capacidad de subir un nivel es a lo sumo `sqrt(min(1,234/M))`, por CMS19 y un cálculo directo de la matriz local de CFHL21. Una recurrencia de amplitudes y la unión sobre conjuntos dan `η(M,R,L)=min(1,C(M,39)C(L,R)²min(1,234/M)^R)`. La fórmula acota el evento de cola sin colisiones en la base comprimida, no toda aceptación falsa. Se conservó CFHL21 arXiv v4, 33 páginas, con texto y SHA-256. La descarga inicial fue bloqueada por la restricción de red; se completó con la autorización del comando.

**Resultados:** 144 perfiles exactos, 16 con cota de cola menor que uno. Con R=512 todos los perfiles tabulados dan uno; cortes mayores del análisis permiten cotas útiles en algunos perfiles. Aumentar R incrementa también el presupuesto total Q+V y las pérdidas de campo. Los exponentes no representan bits de seguridad del protocolo. La extensión del corte es analítica: el expansor anterior sigue limitado a 512 y Rust conserva su comportamiento.

Dieciséis tests nuevos contrastan 1.792 bloques, 20 matrices unitarias, la recurrencia, redondeos, ancla/ciclos y una cadena artificial de 1.024 pasos. Pasan **96 pruebas Python y 197 Rust, cargo check y cargo build**, junto con el manifiesto de 897 archivos. Se preservan TG1 y los seis paquetes matemáticos anteriores. [Registro y fuentes](Documentos/04-Administrativo-TG2/Avances/Cola-QROM-2026-09-23/validacion.json).

El siguiente pendiente es `β^S`, la probabilidad cuántica de completar los 40 índices omitiendo las parejas incorrectas. La nueva cota no lo resuelve; la aceptación completa sigue sin valor numérico en los cálculos. Se actualizan índices, ruta, balance, brief y M5. La demostración general requiere dictamen independiente; no se atribuye aprobación académica nueva. Manuscrito y Word conservan su edición identificada. Las entradas siguientes son históricas.

## Muestreo QROM y reducción al verificador, 23 de septiembre de 2026

Se continuó en `main` con la reconstrucción del trabajo, absorción del nonce y cadena de 40 índices distintos desde una base sin orden. El [nuevo informe](Documentos/04-Administrativo-TG2/Avances/Muestreo-QROM-2026-09-23/Muestreo-y-Puente-QROM.md) define el conjunto de parejas localmente aceptables y propone la cobertura de toda aceptación falsa por colisión, escape de campo, omisión o cola.

**Resultado propuesto:** se construye un verificador auxiliar acotado y una expansión de longitud fija `V`, repetible usando solo sus pares hash registrados. Aplicando el lema 4.9 de CMS19 se formula el paso desde el juego real a la base comprimida, con presupuesto `Q+V` y corrección de salida `sqrt(V/2^256)`. La reducción depende de una cota `β` para omisión o cola. **No se ha demostrado una cota útil para β:** su valor y la cota completa quedan en `null` en los cálculos. No se sustituye el argumento clásico de nonces por una expresión cuántica sin prueba.

**Evidencia:** 72 cuentas de presupuesto y 28 recorridos del corpus. Con corte 40 hay dos aceptaciones ordinarias y doce colas; con corte 512, ocho aceptaciones y seis rechazos FRI, sin cola. El resultado cola solo cuenta como éxito del juego auxiliar del análisis; no cambia la aceptación de Rust. Catorce tests nuevos contrastan 256 secuencias pequeñas, duplicados, cortes, ausencia o inconsistencia de respuestas y repetición sin acceso a SHA3. La cola de 512 pasos se ejercita mediante una asignación artificial de oráculo, no mediante un ataque a SHA3.

Pasan **80 pruebas Python, 197 Rust, cargo check y cargo build**, junto con el manifiesto de 897 archivos. Se comprueban 220 archivos protegidos de TG1 y de los cinco paquetes matemáticos anteriores; Rust permanece limpio. [Validación, fuentes y hashes](Documentos/04-Administrativo-TG2/Avances/Muestreo-QROM-2026-09-23/validacion.json).

Se actualizan índices, ruta, balance, revisión M1–M6 y brief. La herramienta calcula controles locales, pero no decide la falsedad de enunciados ni simula al adversario cuántico general. Próximo trabajo: demostrar β y revisar de forma independiente la cobertura y el cambio de juego antes de evaluar parámetros QROM. Manuscrito y Word conservan su edición identificada. Los apartados siguientes son registros históricos.

## Extractor QROM y escapes AIR/FRI, 23 de septiembre de 2026

Se continuó en `main` con Q1 y parte de Q3. El [nuevo suplemento](Documentos/04-Administrativo-TG2/Avances/Extractor-QROM-2026-09-23/Extractor-y-Escapes-QROM.md) define un extractor determinista de Merkle y del prefijo AIR/FRI sobre una base de consultas sin orden temporal. La extracción completa regiones ausentes con cero, comprueba gramática, raíces compartidas y valores canónicos, y admite el solapamiento nodo/enunciado de 65 bytes. No presupone registrar clásicamente las consultas de un adversario cuántico.

**Resultado propuesto:** fuera de colisiones, una inserción que cambia la extracción en un estado fijo debe acertar a ese estado o a una ventana de una entrada antigua; cada entrada pertinente aporta como máximo 48 ventanas. Se define una propiedad de escape algebraico, se controlan ambas direcciones de cambio y se aplican los lemas 5.9–5.10 de CMS19. La cota en la base comprimida es `min(1,6L²((N/2)μ+(49L+1)/2^256))`. Su evento es colisión o escape de campo, no aceptación del verificador. El paso al juego real, los índices, los nonces y la cola permanecen pendientes; no se combina esta cota con la de PoW sin demostrar esa relación.

**Evidencia:** 45 escenarios exactos, 14 prefijos reconstruidos independientemente del orden, 236 retos de extensión y 1.974 aperturas AIR con caminos registrados. Catorce tests nuevos incluyen los 18 perfiles, ciclos, entradas ambiguas, 2.688 inserciones sin colisión y controles de las premisas. Pasan **66 Python, 197 Rust, cargo check y cargo build**. El manifiesto de 897 archivos, TG1 y los cuatro paquetes matemáticos anteriores se preservan; Rust sigue limpio. [Registro y fuentes](Documentos/04-Administrativo-TG2/Avances/Extractor-QROM-2026-09-23/validacion.json).

La regla AIR/FRI excepcional se define matemáticamente a partir de la demostración por rondas; los scripts no enumeran el espacio de polinomios ni certifican el teorema general. Se actualizan índices, ruta, balance, revisión M1–M6 y brief. Q2 es el siguiente punto de investigación y Q4 sigue abierto. El dictamen independiente no se ha recibido; manuscrito y Word conservan su edición identificada.

## Primera etapa QROM, 23 de septiembre de 2026

Por solicitud del autor se continuó la investigación en `main`. Se conservaron dos fuentes primarias completas: CMS19, versión de portada del 14 de enero de 2020, y DFM20, arXiv v3 del 7 de marzo de 2022, con extracción por página y SHA-256. Se escribió el [informe QROM](Documentos/04-Administrativo-TG2/Avances/QROM-2026-09-23/Primer-Paso-QROM.md).

**Resultado matemático parcial:** la aceptación de TG2 v1 exige una salida hash con g bits iniciales cero. Reconstruir la entrada de ese trabajo desde una prueba consume `C_T=13+4log2(T)` llamadas hash. Una especialización del teorema 2 de DFM20 da `Pr[falso y acepta] ≤ min(1,(2(Q+C_T)+1)²/2^g)` en QROM, con una prueba clásica final y todas las consultas de preparación contabilizadas. La cota no utiliza AIR/FRI y es débil: para T=4096,g=20 llega a uno desde Q=451. Ese umbral no demuestra un ataque ni acredita un nivel de seguridad del protocolo.

**Obligaciones identificadas:** el evento Bad_H clásico depende del orden temporal y no es directamente una propiedad de la base de consultas de CMS19; la generación encadenada de 40 índices no equivale a un solo reto uniforme; el potencial clásico de nonces no tiene aún una versión cuántica demostrada. Se documentan Q1–Q5 para extractor, muestreo, AIR/FRI, pérdidas y parámetros. No se incorpora artificialmente el factor ideal h_T en la cota QROM.

**Evidencia:** 108 perfiles exactos, doce búsquedas pequeñas, nueve contrastes de muestreo y doce tests nuevos. Se cotejan los 14 prefijos del corpus y se enumeran 256 tablas de un oráculo XOR con cero, una y dos iteraciones. La simulación exacta demuestra en esos ejemplos el fallo de la expresión lineal clásica frente a búsqueda cuántica; no es un ataque SHA3 ni ejecución en hardware cuántico. Pasan **52 Python, 197 Rust, cargo check y cargo build**. Se verifica el manifiesto de 897 archivos, TG1 y los tres paquetes matemáticos previos. Código Rust limpio. [Registro y fuentes](Documentos/04-Administrativo-TG2/Avances/QROM-2026-09-23/validacion.json).

El Python global no tenía PyMuPDF; se creó `.tools/qrom-venv` con PyMuPDF 1.28.2 exclusivamente para la recopilación. El resto del análisis usa la biblioteca estándar. Los índices, ruta, balance, preguntas de revisión y brief enlazan el suplemento. La transferencia QROM completa que aproveche AIR/FRI y el dictamen independiente siguen pendientes. El manuscrito y el Word conservan su edición identificada; no se atribuye la aprobación previa del director a este desarrollo.

## Revisión crítica interna de ROM, 23 de septiembre de 2026

Se revisó la transferencia contra el código `01dcde9` y se escribió un [suplemento matemático](Documentos/04-Administrativo-TG2/Avances/Revision-Critica-ROM-2026-09-23/Revision-Critica-ROM.md). El contraste anterior de nonces solo comparaba órdenes fijos; se añadió una búsqueda de estrategias adaptativas y una demostración por potencial que cobra cada candidato antes de su primera respuesta. Contempla intercalación, abandono, restauración, duplicados y una verificación final que completa un candidato parcialmente explorado.

**Resultado:** no apareció un contraejemplo a la cota bajo las hipótesis revisadas. Se conservan la fórmula y sus parámetros. Los controles negativos muestran la necesidad de raíz marcada antes del reto y la diferencia entre probabilidad conjunta de éxito y probabilidad condicionada a un nonce ganador. Una asignación artificial de oráculo reproduce el solapamiento nodo/enunciado de 65 bytes sin evento excepcional; la prueba ya lo admite y no debe asumir separación global de roles.

**Evidencia nueva:** 96 escenarios pequeños de Bellman, 6.318 estados sumados por ejecución y 60 órdenes de extracción; doce tests nuevos. Pasan **40 pruebas Python y 197 Rust**, cargo check y cargo build. Se verifican los 897 archivos del manifiesto, el corpus de 14 certificados, TG1 y los dos paquetes matemáticos previos. Rust se conserva limpio. [Ejecuciones, protección y fuentes](Documentos/04-Administrativo-TG2/Avances/Revision-Critica-ROM-2026-09-23/validacion.json).

Esta es una revisión interna del desarrollo, sin dictamen externo ni aprobación académica nueva. La siguiente etapa es estudiar parámetros con presupuesto adversario Q y probabilidad objetivo explícitos; QROM permanece como reducción distinta. Los índices, la ruta y M1–M6 enlazan el suplemento. El manuscrito y el Word conservan sus ediciones identificadas.

## Integración en main y transferencia clásica ROM, 23 de septiembre de 2026

Por solicitud del autor, se integró `investigacion/cierre-matematico-tg2` en **`main` de ambos repositorios**. Documentos avanzó por fast-forward a `0e109fc`; código ya compartía la revisión `01dcde960402b6c60a19242b7ae3d6ac3d82a518`. La integración es local y las ramas de investigación se conservan.

Se escribió la [transferencia al protocolo experimental TG2 v1](Documentos/04-Administrativo-TG2/Avances/Transferencia-ROM-2026-09-23/Transferencia-Protocolo-ROM.md), modelando todas sus llamadas a SHA3-256 como un único oráculo aleatorio clásico. La demostración propuesta combina extracción Merkle desde el registro de consultas, estados del canal, masa máxima de retos de extensión, nonces adaptativos y la cola del muestreo de índices. Permite el solapamiento de las entradas de 65 bytes de nodo y enunciado; no presupone separación total de dominios.

Con las definiciones del informe, la cota es `min(1, S(49S+B)/2^256 + (Q+m)(N/2)μ + (Q+1)2^-g(h+τ))`. Se preservan 108 escenarios con fracciones exactas. Para `T=4096`, `g=20` y `Q=2^20`, el límite superior redondeado es **0,004757335454**; para `Q=2^28`, la cota llega a uno. No son tasas observadas ni una demostración de ataque. El resultado propuesto requiere revisión independiente; no acredita QROM ni 100 bits.

El nuevo verificador Python independiente comprueba transcripción, Merkle, composición AIR y ambos FRI: **ocho certificados honestos aceptados y seis alejados rechazados en FRI de traza**, de acuerdo con Rust. Se añadieron once pruebas que cubren cuentas, sesgo, cola, extracción congelada, referencias adelantadas, colisiones, orden de candidatos y mutaciones. Los ejemplos finitos no certifican la demostración general.

**Validación:** **28 pruebas Python y 197 Rust**, cargo check de todos los targets y cargo build correctos. Se comprobaron los 897 archivos del manifiesto, la preservación de TG1 y del paquete matemático anterior, y el código limpio. [Logs, fuentes y hashes](Documentos/04-Administrativo-TG2/Avances/Transferencia-ROM-2026-09-23/validacion.json). El primer intento falló exclusivamente por acceso denegado a `C:/tmp/nexus-target/debug/.cargo-build-lock`; sus logs se conservaron y se repitió con permiso de escritura.

**Estado documental:** este complemento y la derivación ideal anterior están enlazados desde los índices, la ruta, el balance y las preguntas M1–M6. El manuscrito y el Word de derivaciones conservan su edición identificada; los complementos tienen validaciones propias. Próximos pasos: dictamen de ambas demostraciones, suficiencia de parámetros y reducción QROM si se exige garantía cuántica. R1-A–D de ML-DSA permanece separado. No se atribuye aprobación académica previa a estas derivaciones. Las entradas siguientes son registros históricos.

## Investigación de solidez por rondas, 23 de septiembre de 2026

Por solicitud del autor se creó **`investigacion/cierre-matematico-tg2` en los dos repositorios**, desde documentos `24ca355d35bbfb726fe901b824536c72cef0c953` y código `01dcde960402b6c60a19242b7ae3d6ac3d82a518`. Se inicia el intento de resolver la brecha matemática AIR/FRI; no se publica ni fusiona la rama.

Se escribió una [demostración conjunta por rondas](Documentos/04-Administrativo-TG2/Avances/Cierre-Matematico-2026-09-23/RBR-AIR-FRI.md): lema elemental de acuerdo para dos funciones, conservación de conjuntos de acuerdo en FRI, tratamiento de los tres coeficientes AIR separados y función de estado para traza, composición y consulta común. Se consultó y conservó la revisión de marzo de 2026 de Garreta, Mohnblatt y Wagner; su estructura de estado sirve como referencia. La demostración propuesta requiere revisión independiente.

Para los umbrales 1/8 y 40 parejas, la nueva cota ordinaria ideal es `H(4T,40,1/8)+(8T−3)/p²`, con extremos superiores redondeados **0,000166165 y 0,004757331**. Se obtiene también una cota por ronda y un corolario de reinicios del experimento ideal. La mejora es analítica: no se alteró el protocolo ni se atribuyen esas cifras a SHA3, Merkle, Fiat–Shamir, QROM o ataques observados. La extracción de oráculos y la correspondencia del canal concreto, incluida su consulta en cadena y los nonces, siguen pendientes; R1-A–D de ML-DSA también.

**Comprobaciones:** siete pruebas matemáticas Python y diez del manifiesto pasan; cargo check, las **197 pruebas Rust** y cargo build pasan. Se verificaron los 897 archivos de la edición anterior, los 15 documentos TG1 y la ausencia de cambios en el código. Los contrastes incluyen 390.625 pares de funciones, 6.056 prefijos de cancelación, 4.352 casos FRI pequeños y 328 escenarios de muestreo. [Resultados y hashes](Documentos/04-Administrativo-TG2/Avances/Cierre-Matematico-2026-09-23/validacion.json).

La primera comprobación detectó un archivo de propietario de Word `~$sis-NEXUS-completa.docx` como entrega adicional. Se corrigieron el registro y la verificación del manifiesto para excluir solamente temporales `~$` con extensión Word; dos nuevas pruebas comprueban esa excepción y la detección de otros archivos. Se conservaron los logs del intento inicial. El archivo temporal no se eliminó ni se cerró Word. El manuscrito y el Word de derivaciones conservan su edición previa, enlazada al nuevo complemento de investigación. No se atribuye aprobación del director a este avance.

## Documento de derivaciones para revisión, 23 de septiembre de 2026

Se reunieron S1, el contraejemplo de proximidad, la variante vinculada, la cota ideal S2 y la auditoría S3 en un [documento Word independiente](Documentos/04-Administrativo-TG2/Avances/Derivaciones-Matematicas-TG2-2026-09-23.docx), con [fuente editable](Documentos/04-Administrativo-TG2/Avances/Derivaciones-Matematicas-TG2-2026-09-23.md). Expone hipótesis, argumentos, evidencia, referencias y preguntas M1–M6. La sección 1.1 aclara la diferencia entre argumentos escritos pendientes de revisión y la transferencia al ejecutable que aún no está demostrada.

Edición de **24 páginas, 8 tablas / 135 celdas y 305 objetos matemáticos nativos, incluidos 33 bloques**. El índice se actualizó con Word; las tablas coinciden con la conversión independiente y mantienen rótulo y cuerpo juntos. Se inspeccionaron la paginación y las fórmulas, con [registro y hashes](Documentos/04-Administrativo-TG2/Avances/Derivaciones-Matematicas-TG2-2026-09-23.revision.json). Los scripts de generación y actualización quedan en `scripts/`. El manuscrito principal, el código y las mediciones conservan su versión; no se atribuye dictamen ni aprobación a esta recopilación.

## Estado vigente — organización y versión de repositorios, 23 de septiembre de 2026

Se corrigió `.gitignore` para limitar las exclusiones locales a la raíz: 169 archivos de evidencia, incluidas fuentes de experimentos, dejaban de aparecer en Git por las reglas anteriores. Se añadió `.gitattributes` para conservar los bytes del manuscrito y de la evidencia. Las instantáneas históricas, los documentos administrativos de TG1 y las fuentes STARK heredadas se preservan.

Se crearon el [README principal](README.md), el índice de evidencia, las dependencias Python fijadas y las instrucciones de reproducción. La ruta de estudio se actualizó a 197 pruebas y al alcance corregido: comparativa clásica ya ejecutada, límites de las reducciones, residencia y STARK. Se prepararon el [balance de objetivos](Documentos/04-Administrativo-TG2/Entrega-Final/Balance-Objetivos-TG2.md), el [índice de entrega](Documentos/04-Administrativo-TG2/Entrega-Final/README.md) y el [guion de sustentación](Documentos/04-Administrativo-TG2/Presentaciones/Guion-Sustentacion-TG2.md).

**Código consolidado:** `01dcde960402b6c60a19242b7ae3d6ac3d82a518`. Check, 197 pruebas y build repetidos correctamente; dependencias instaladas cotejadas con el archivo de requisitos. Ocho pruebas Python comprueban integridad, alteración, ausencia, adición, rutas y revisión de código del manifiesto. El manifiesto enlaza la revisión de código y los hashes del manuscrito y de la evidencia. El commit documental que contiene el manifiesto identifica esta edición de trabajo. La organización no registra envío, nueva aprobación académica ni una presentación final. [Comprobaciones de organización](Documentos/06-Evidencia-TG2/2026-09-23/Organizacion-repositorios/validacion.json).

## Registro de auditoría Merkle/Fiat–Shamir, 23 de septiembre de 2026

**Depuración documental:** por indicación del autor se eliminó la carpeta `Lluvia de ideas` con sus dos documentos preliminares y se retiraron sus referencias en la ruta de estudio y el plan de trabajo. El estado del arte y el registro histórico indican que el documento fue retirado.

Se auditó la vinculación de aperturas, la gramática del canal y la distribución de retos de la variante TG2. Una reconstrucción independiente con Python/hashlib comprueba **14 certificados, 560 consultas y 18.880 aperturas Merkle**, sin sustituir la verificación completa FRI/AIR. Se conserva un lema de vinculación condicionado a colisiones y se distingue de la extracción de un oráculo.

La distancia de variación total de un bloque uniforme reducido al campo es aproximadamente 1,26218 × 10⁻²⁹; la pérdida por hasta 28 retos de extensión es menor que 7,069 × 10⁻²⁸ bajo salidas frescas. No es una pérdida total Fiat–Shamir. Los nonces públicos 904 y 1233 satisfacen 12 bits y generan consultas diferentes. El análisis identifica propiedades por ronda, presupuesto de consultas, grinding y compilación ROM/QROM pendientes; no acredita 100 bits ni conocimiento cero.

**Check, 197 pruebas y build** repetidos correctamente. Rust, corpus y benchmarks se conservan. Se corrigió la fecha fija del generador documental: admite NEXUS_TG2_FECHA_EVIDENCIA, con siete casos de validación, y guarda los informes del día 23 separados de los históricos.

La edición incorpora §6.7.6 y Tabla 6.20: **108 páginas Word, 95 PDF, 32 tablas / 822 celdas**, 3 figuras y 541 objetos matemáticos Word, incluidos 30 bloques. Se preparó el paquete de revisión S1–S3 con seis preguntas; no se registra envío ni aprobación de estas derivaciones. [Auditoría](Documentos/04-Administrativo-TG2/Avances/R4-Merkle-Fiat-Shamir-2026-09-23.md) · [Paquete para revisión](Documentos/04-Administrativo-TG2/Avances/Revision-Matematica-S1-S3-2026-09-23.md) · [Evidencia](Documentos/06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/analisis.json) · [Edición y revisión](Documentos/06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/revision-manuscrito.json).

## Registro de cota interactiva ideal, 22 de septiembre de 2026

Se desarrolló una derivación de composición para la variante vinculada bajo oráculos ideales y retos uniformes. El candidato próximo es único y queda fijado antes de los coeficientes AIR. Un argumento sobre la componente no base trata los candidatos sobre la extensión. Se contrasta el plegado con BGK+23, Corolario 5.5 y Algoritmo 1, y se suman conservadoramente los errores por ronda de los dos FRI, la cancelación y el enlace local, sin suponer independencia entre sus consultas comunes.

Con umbrales 1/8 y 40 consultas, las cotas superiores ideales tabuladas van de **0,052736 a 0,134071**, redondeadas hacia arriba. Son garantías conservadoras del modelo ideal, no probabilidades de ataques observados ni límites inferiores de vulnerabilidad. El argumento no acredita 100 bits ni seguridad del ejecutable. La compilación Merkle/Fiat–Shamir, grinding y pérdidas ROM/QROM sigue pendiente, junto con la revisión matemática independiente.

Se comprobaron nueve perfiles y contrastes finitos de unicidad, campo base, localidad, muestreo y normalización del plegado. **Check, 197 pruebas y build** volvieron a pasar. Rust y sus corpus se preservan mediante comparación de hashes; no se repitieron pruebas release ni benchmarks en esta etapa. La evidencia release de diez casos corresponde a la implementación anterior.

Edición vigente: **106 páginas Word, 93 PDF, 31 tablas / 804 celdas**, 3 figuras y 531 objetos matemáticos Word, incluidos 29 bloques. Se añadieron §6.7.5 y Tabla 6.19 y se actualizaron resúmenes y conclusiones. [Derivación y límites](Documentos/04-Administrativo-TG2/Avances/R4-Cota-Interactiva-2026-09-22.md) · [Análisis reproducible](Documentos/06-Evidencia-TG2/2026-09-22/R4-cota-interactiva/analisis.json) · [Edición y revisión](Documentos/06-Evidencia-TG2/2026-09-22/R4-cota-interactiva/revision-manuscrito.json). La aprobación anterior del director no se atribuye a esta derivación.

## Registro de FRI de traza vinculada al AIR, 22 de septiembre de 2026

Se implementó una variante experimental TG2 con dos recorridos FRI: traza de grado menor que T y composición de grado menor que 2T. Las aperturas AIR y la primera capa FRI de traza comparten raíz y codificación de hojas en la extensión. La transcripción identifica versión, perfil, enunciado y fases, y deriva 40 consultas comunes después del grinding. El verificador recibe aperturas y caminos, sin el LDE completo. Admite potencias de dos entre 16 y 4096 filas; permanece fuera de producción.

**197 pruebas del workspace pasan en desarrollo; diez nuevas pasan también en release**, con check de todos los targets y build correctos. La variante acepta ejecuciones honestas de 16, 64, 256 y 4096 filas. Se reutilizan los oráculos conservados de 16, 32 y 64 filas y se generan pruebas del protocolo nuevo: las tres se rechazan en FRI de traza. Los certificados originales siguen siendo aceptados por el legado, con enunciados válidos. Se preservan 14 certificados públicos nuevos, seis anteriores reutilizados, fuentes, logs y hashes.

Los tamaños serializados de enunciado y prueba son 196.574, 306.782, 437.470 y 760.286 bytes para los cuatro tamaños honestos ensayados, comprobados mediante una cuenta independiente del formato. El costo de comunicación y verificación es O(q log² N); los caminos Merkle se repiten. En estos tamaños los certificados ocupan más que el vector LDE completo por sí solo. No se midieron nuevas latencias.

Edición consolidada: **104 páginas Word, 91 PDF, 30 tablas / 784 celdas**, 3 figuras y 486 objetos matemáticos nativos en Word, incluidos 26 bloques. §6.7.4 y Tabla 6.18 incorporan protocolo, resultados, tamaños y límites; los resúmenes, capítulos 5–7 y seguimiento concuerdan. [Informe de la variante](Documentos/04-Administrativo-TG2/Avances/R4-FRI-Vinculado-2026-09-22.md) · [Ejecución y corpus](Documentos/06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado/validacion.json) · [Edición y revisión](Documentos/06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado/revision-manuscrito.json).

**Siguiente trabajo técnico:** justificar los errores concretos de ambos FRI y su composición AIR, los supuestos de campo/oráculos y las pérdidas Fiat–Shamir/Merkle/QROM; preparar revisión matemática independiente. El enlace estructural está implementado; las pruebas no acreditan una cota global, 100 bits ni conocimiento cero. Las fuentes STARK de producción se conservan. La aprobación anterior del director no se atribuye a estos cambios. Los apartados siguientes son registros históricos.

## Registro del contraejemplo de proximidad de traza, 22 de septiembre de 2026

La construcción F=f+λ(X^T−1), con λ no nulo y f interpolante de una ejecución válida, conserva las filas del AIR y produce una composición de grado ≤ T+2 < 2T. Su LDE está a distancia exacta **7/8** del código de grado < T. El verificador heredado acepta los casos de 16, 32 y 64 filas con SHA3, Merkle, FRI y grinding reales, en desarrollo y release. Los coeficientes no se eligen ni se fuerzan. Los enunciados son válidos: se refuta una premisa de la demostración, sin presentar una falsificación de enunciado.

La formulación de S2 «aceptación implica proximidad ≤ 1/24 de la traza comprometida» queda refutada para el legado. S1 conserva sus hipótesis y conclusión condicional. Se implementó un control exhaustivo experimental para 4–256 filas que verifica raíz, grado y todas las restricciones del LDE completo, además del STARK. Acepta la ejecución honesta y rechaza por grado los tres casos alejados. Requiere N elementos adicionales y O(N log N) operaciones; revela la traza y no se incorpora a producción.

**187 pruebas del workspace pasan en desarrollo; siete nuevas pasan también en release**, con check de todos los targets y build correctos. Se conservan seis pruebas binarias públicas, fuentes y hashes. El ensayo algebraico cubre 21 casos y Python reproduce de forma independiente interpolación, división y distancia. No se repitieron benchmarks ni se modificaron los módulos STARK heredados.

Edición consolidada: **101 páginas Word, 90 PDF, 29 tablas / 759 celdas**, 3 figuras y 477 objetos matemáticos nativos en Word, incluidos 25 bloques. §6.7.3 y Tabla 6.17 incorporan el hallazgo; resúmenes, capítulos 5–7 y seguimiento reflejan su alcance. [Informe y siguiente diseño](Documentos/04-Administrativo-TG2/Avances/R4-Proximidad-Traza-2026-09-22.md) · [Ejecución y corpus](Documentos/06-Evidencia-TG2/2026-09-22/R4-proximidad/validacion.json) · [Edición y revisión](Documentos/06-Evidencia-TG2/2026-09-22/R4-proximidad/revision-manuscrito.json).

**Siguiente trabajo técnico:** especificar y contrastar una variante de proximidad de traza vinculada al AIR; la alternativa para el legado requiere otro argumento de extracción. Las pérdidas Fiat–Shamir/QROM y la revisión externa siguen pendientes. La aprobación anterior del director no se atribuye a estos cambios. Los apartados siguientes conservan sus conclusiones como registros históricos.

## Registro del argumento algebraico AIR/FRI, 22 de septiembre de 2026

Se desarrolló una demostración escrita de divisibilidad, grado y distancia para una traza polinómica fijada antes de los retos (S1), y la transferencia condicional a un oráculo próximo (S2). Se reprodujo una cancelación de errores de una traza inválida con tres coeficientes no nulos: los coeficientes fueron elegidos algebraicamente y el enunciado conserva una traza honesta alternativa. El ejemplo no fuerza SHA3 ni demuestra un enunciado falso aceptado.

Fuera de la cancelación, la composición de una traza polinómica inválida queda a distancia relativa al menos (5T+1)/(8T) del código de grado menor que 2T. Si el oráculo difiere de esa traza en una fracción ε, la cota disminuye a lo sumo 3ε. La premisa de proximidad del oráculo comprometido sigue sin establecerse para el protocolo; las pérdidas Fiat–Shamir/QROM y la revisión externa permanecen abiertas.

Se añadieron siete pruebas, con **180 pruebas del workspace en desarrollo y siete algebraicas en release**, check de todos los targets y build correctos. El oráculo de referencia cubre 4–256 filas; las pruebas incluyen 21 trazas válidas y la correspondencia con aperturas reales del probador. Un script independiente comprueba los 17 dominios del perfil, las fracciones de distancia y el coeficiente de cancelación. Producción STARK y benchmarks se conservan.

Edición consolidada: **99 páginas Word, 89 PDF, 28 tablas / 735 celdas**, 3 figuras y 443 objetos matemáticos nativos en Word, incluidos 23 bloques. Se incorporan §6.7.2, Tabla 6.16 y actualizaciones de resúmenes, conclusiones y seguimiento. [Informe algebraico](Documentos/04-Administrativo-TG2/Avances/R4-Algebra-AIR-FRI-2026-09-22.md) · [Ejecución](Documentos/06-Evidencia-TG2/2026-09-22/R4-algebra/validacion.json) · [Edición y revisión](Documentos/06-Evidencia-TG2/2026-09-22/R4-algebra/revision-manuscrito.json).

**Siguiente trabajo técnico:** justificar la proximidad de la traza y correlación entre los oráculos locales y FRI; evaluar cualquier comprobación adicional como variante TG2. La aprobación anterior del director no se atribuye a estos cambios. Los apartados siguientes conservan los resultados históricos de cada etapa.

## Registro de auditoría de solidez STARK, 22 de septiembre de 2026

Se caracterizaron parámetros, orden de la transcripción, consultas, grinding y proximidad FRI. Siete pruebas nuevas pasan en desarrollo y en release; la suite completa pasa **173 pruebas en desarrollo**, con check de todos los targets y build correctos. Los parámetros heredados devuelven 100 sin considerar tamaño ni perfil; cuatro y ocho filas realizan 16 y 32 consultas. La variante TG2 exige desde 16 filas. La cifra de 100 bits no se acredita para el ejecutable.

El ensayo FRI aislado compromete una palabra a distancia 1/512 de cero, con interpolación de grado 511 y cota 128. Acepta 28 de 32 contextos fijos y rechaza cuatro, según se evite o consulte la pareja inconsistente. Es una comprobación de proximidad, no una transición AIR falsa aceptada. Se conservaron tres publicaciones primarias, cálculo exacto del muestreo del campo y un escenario de referencia separado de cualquier garantía de NEXUS. La producción STARK se conserva; no se repitieron benchmarks.

Edición: **96 páginas Word, 87 PDF, 27 tablas / 711 celdas**, 3 figuras y 391 objetos matemáticos nativos en Word, incluidos 20 bloques. Se añadieron §6.7.1 y Tabla 6.15; resúmenes, capítulos 5–7 y seguimiento quedan sincronizados. [Informe y obligaciones S1–S5](Documentos/04-Administrativo-TG2/Avances/R4-Solidez-STARK-2026-09-22.md) · [Ejecución](Documentos/06-Evidencia-TG2/2026-09-22/R4-solidez/validacion.json) · [Edición y revisión](Documentos/06-Evidencia-TG2/2026-09-22/R4-solidez/revision-manuscrito.json).

**Siguiente trabajo técnico:** demostrar la reducción algebraica del AIR y justificar la proximidad correlacionada entre traza y composición. La garantía completa de solidez y su transferencia QROM siguen abiertas, junto con la revisión matemática externa. La aprobación anterior del director no se atribuye a estos cambios.

## Registro R1 correspondencia formal, 22 de septiembre de 2026

Se auditó la correspondencia entre el perfil implementado y cinco fuentes primarias, con versiones, localizadores, copias y hashes. NEXUS reconstruye claves desde semilla y firma ML-DSA puro con aleatoriedad adicional y contexto vacío. Se añadieron tres pruebas, una por nivel: **166 pruebas pasan**, con cargo check de todos los targets y cargo build correctos. La primitiva se conserva; las pruebas comparten backend y no constituyen certificación independiente.

El capítulo 6 explicita la pérdida CMA→NMA de B+23 y reproduce su escenario de referencia, sin atribuirlo como cota de NEXUS. La condición del Teorema 2 de JMW24 falla en los tres perfiles incluso con el menor ancho auxiliar positivo; se descarta esa aplicación directa, sin inferir un ataque. Se precisan los resultados de LS15, sus distribuciones y los pasos que faltan. La hoja NIST de actualizaciones potenciales se conserva y se identifica como tal; sus estimaciones de iteraciones no son mediciones locales.

Edición consolidada: **94 páginas Word, 85 PDF, 26 tablas / 657 celdas**, 3 figuras y 381 objetos matemáticos nativos en Word, incluidos 19 bloques. Se revisaron visualmente figuras, ecuaciones y tablas modificadas; las 26 tablas coinciden con la conversión independiente y conservan rótulo y cuerpo juntos en Word. Se corrigió un recorte de revisión que ocultaba parte de una fórmula multilineal, completa en el documento. [Informe R1](Documentos/04-Administrativo-TG2/Avances/R1-Correspondencia-Formal-2026-09-22.md) · [Identificación y revisión](Documentos/06-Evidencia-TG2/2026-09-22/R1-correspondencia/revision-manuscrito.json).

**Pendientes:** correspondencia formal de expansión/hedged, codificaciones e inforjabilidad fuerte; hipótesis de fuente/KDF; terminación extrema del backend; revisión matemática externa. El Objetivo 4.1 sigue abierto. El siguiente trabajo independiente es el presupuesto de soundness del PoC STARK. La aprobación anterior del director no se atribuye a estas correcciones.

## Registro R5 y complemento R4, 22 de septiembre de 2026

El autor comunicó que desactivó Smart App Control; se consultó estado 0 y finalizaron los dos benchmarks pendientes. Los fallos originales se conservan. El complemento mide 12 casos Criterion y 40 repeticiones multinúcleo: mediana ML-DSA-65 de 84,61 µs por verificación y 136.390 verificaciones/s con 24 hilos, frente a 12.349 con uno. En conjunto, las dos series nuevas reúnen 29 casos Criterion, 40 mediciones STARK y 40 repeticiones multinúcleo. No son transacciones completas ni validan retrospectivamente los 199.218 históricos.

R5 distingue gestor cacheado y política experimental, corrige 5993 B como longitud serializada con datos públicos/cabeceras y comprueba el objeto PrivateKey ML-DSA-65 de 17536 B. Tres pruebas nuevas verifican representaciones y capacidad de firma desde semilla retenida; **163 pruebas pasan**, check/build correctos. El modelo de W declara regiones, copias y escenarios de captura; no convierte menos bytes por tiempo en menor probabilidad de compromiso. Se retiró la afirmación de prioridad de esa métrica. Custodia, todas las copias físicas e integración de la política siguen pendientes.

Edición consolidada: **92 páginas Word, 83 PDF, 26 tablas / 634 celdas**, 3 figuras y 364 objetos matemáticos nativos en Word, incluidos 18 bloques. La inspección visual detectó y permitió corregir escapes LaTeX en §5.6.3 antes de la exportación definitiva de esta edición. La identificación y revisión se conservan en `R5-residencia/revision-manuscrito.json`. [Informe R5 y complemento R4](Documentos/04-Administrativo-TG2/Avances/R5-Residencia-y-Custodia-2026-09-22.md). La aprobación anterior del director no se atribuye a estos cambios.



## Registro de la primera ejecución R4, 22 de septiembre de 2026

**Edición documental comprobada:** Word de 87 páginas y PDF de 77, con 22 tablas / 501 celdas coincidentes, 3 figuras y 365 objetos matemáticos nativos en Word (18 bloques). Se inspeccionaron las figuras, fórmulas en bloque y tablas nuevas en ambos formatos. Las tablas y sus rótulos permanecen juntos en Word; el PDF no presenta páginas vacías ni texto fuera de márgenes. La evidencia e identificación de la edición están en `R4-validacion/revision-manuscrito.json`.

Se completó la caracterización del verificador y una variante experimental TG2 restringida a escalares canónicos, preservando los componentes heredados. **160 pruebas pasan**, con `cargo check` y `cargo build` correctos; 18 casos nuevos cubren verificador y sincronización del ensayo multinúcleo. Se reprodujeron la aceptación sin STARK, la pérdida de bytes/reducción de raíces y la recuperación del testigo del ejemplo de 16 filas mediante aperturas públicas. No se acredita conocimiento cero ni enlace de raíces hash arbitrarias.

La serie nueva conserva **17 casos Criterion y 40 mediciones STARK**, fuentes, hashes, comandos, equipo y dispersión. Windows bloqueó los benchmarks optimizados ML-DSA y multinúcleo (Control de aplicaciones, error 4551); no se generaron resultados sustitutivos. El intervalo defectuoso del ensayo multinúcleo histórico queda documentado y su cifra no se usa como escalado validado. Las mediciones de residencia son latencias, no una medida de exposición secreta.

El manuscrito incorpora las Tablas 6.10–6.12, sensibilidad de amortización, límites del PoC y estado de la reproducción. R4 permanece parcial por los experimentos bloqueados y la revisión formal pendiente; R5 es el siguiente trabajo independiente. La aprobación anterior del director no se atribuye a estos cambios. [Informe R4](Documentos/04-Administrativo-TG2/Avances/R4-Verificador-y-Evidencia-2026-09-22.md). Las entradas R2/R3 siguientes conservan sus conteos y paginación históricos.


**Proyecto:** *Arquitectura Blockchain Dual NEXUS: Un Modelo Matemático-Computacional para Sistemas Seguros y Resilientes Post-Cuánticos*

**Período:** Semestre Académico TG2 (2026)  
**Estado General:** En Desarrollo Activo (Objetivos 3 y 4)  

**Último avance — R3, 2026-09-22:** `KeyManager` ahora reemplaza todas las claves al rotar Sentinel, conserva identidad y actualiza metadatos. La firma autentica época/identidad y se bloquea por salud, edad o cupo de derivaciones. `KeyRegistry` registra altas, rotaciones conjuntas y retiros autorizados por las claves; permite reconstruir el historial público y comprobar un checkpoint confiable. Se añadieron y ejecutaron **19 pruebas**, con resultado total **142/142** (core 15, crypto 57, anchor 16, active 20, zk 34); check de todos los targets y build correctos. Dos errores inyectados comprueban que no se instala una transición parcial. La demostración verifica fallo, recuperación, cambio efectivo, rechazo de época anterior y recarga pública. [Informe R3](Documentos/04-Administrativo-TG2/Avances/R3-Rotacion-y-Registro-2026-09-22.md) · [Fuentes y ejecución](Documentos/06-Evidencia-TG2/2026-09-22/R3-rotacion/ejecucion.json).

**Límites vigentes:** atomicidad en memoria y recuperación del historial público; custodia durable y recuperación de secretos pendientes. El registro no está integrado en L2/L1 ni en el formato heredado de transacciones. El checkpoint requiere custodia independiente y actualización. Verificar una firma histórica no demuestra que se emitiera antes del retiro. No se han repetido benchmarks ni demostrado borrado de todas las copias del secreto. El siguiente paso es R4; R1 y R5 conservan sus obligaciones.

**Edición vigente tras R3:** Word de **83 páginas**, PDF de **73**, **3 figuras**, **19 tablas / 389 celdas** y **356 objetos matemáticos nativos**, con 18 ecuaciones en bloque. Resúmenes, capítulo 5 y conclusiones sincronizados. La figura 5.1 incorpora bloqueo de firma y la preparación/validación antes de instalar claves. Las tablas mantienen rótulo y cuerpo en una misma página de Word; el PDF no presenta páginas vacías ni texto fuera de los márgenes revisados.

### Etapa R2 anterior del mismo día

**Avance de la etapa R2, 2026-09-22:** se implementó el corte APT binomial W=512/C=16, el lote de 65.536 muestras, el bloqueo inicial y la recuperación explícita seguida de renovación de semilla. La rotación conserva monitores e historial; la derivación sin comprobaciones quedó interna. Se actualizaron las llamadas de `KeyManager` y el ejemplo `apt_sweep`. Por solicitud expresa del autor se añadieron y ejecutaron 13 pruebas: **123/123 pasan** en el workspace (core 15, crypto 38, anchor 16, active 20, zk 34); `cargo check --all-targets` y `cargo build` también terminaron correctamente. Los benchmarks históricos no se repitieron. [Informe R2](Documentos/04-Administrativo-TG2/Avances/R2-Monitor-Entropia-2026-09-22.md) · [Fuentes, registros y hashes](Documentos/06-Evidencia-TG2/2026-09-22/R2-monitor/ejecucion.json).

**Edición de la etapa R2:** Word de **82 páginas** y PDF de **71**, con índices propios, **3 figuras**, **19 tablas / 389 celdas** y **358 objetos matemáticos nativos en Word**. Se sincronizaron los resúmenes, el capítulo 5 y las conclusiones. La comprobación conserva todas las tablas con su rótulo en una misma página de Word. El flujo observado procede de la aplicación; su vinculación y calificación respecto a una fuente concreta de despliegue siguen requeridas. La rotación efectiva de claves y el registro permanecen en R3. Los apartados siguientes registran las etapas documentales previas del mismo día.

**Estado conciliado al 2026-09-22:** el estudiante confirma la aprobación del director al plan, entrega y decisiones presentadas. La fecha exacta y el calendario están por incorporar. Los Objetivos 3 y 4 siguen abiertos técnicamente según la [matriz de trazabilidad](Documentos/05-Estado-del-Arte/Resumenes-y-Matriz/Matriz-Trazabilidad-TG2.md). La [revisión de la bitácora](Documentos/04-Administrativo-TG2/Avances/Revision-Bitacora-2026-09-22.md) documenta contradicciones, evidencia recuperada y prioridades; los registros fechados siguientes se conservan como historia.

**Alcance vigente — aclaración del autor registrada el 2026-09-22:** NEXUS se plantea para **sistemas en general** que requieren autenticación de operaciones, integridad de registros y gestión del ciclo de vida de claves. El autor precisó: «ya no es para sistemas bancarios, sino sistemas en general». Al contrastar el archivo local, no se encontró una entrada previa que registrara explícitamente esa ampliación y el encabezado aún conservaba el título bancario. Se registra ahora la aclaración sin atribuir una fecha anterior a la decisión ni una aprobación específica del director que no haya sido documentada.

La edición vigente actualiza título, resúmenes, motivación, objetivo general, alcance, referencias de aplicación y conclusiones, incluidos los capítulos 1–4 por instrucción expresa del autor. Se mantienen los cuatro objetivos técnicos y la arquitectura blockchain dual como modelo de referencia. La generalidad del dominio no implica validación experimental en todas las aplicaciones. Los documentos administrativos de TG1 y los registros fechados anteriores se conservan como antecedentes.

**Salidas tras la aclaración, antes de la revisión gráfica:** Word de 78 páginas y PDF de 69, con índices propios. Se comprobaron nuevamente las 19 tablas y sus 389 celdas; en Word cada tabla y su rótulo permanecen en la misma página. La búsqueda en las fuentes del manuscrito y en las salidas no conserva el enfoque bancario anterior. Las referencias a «banco de pruebas» designan el entorno experimental. No se modificó Rust ni se realizaron nuevas mediciones.

**Revisión gráfica posterior — 2026-09-22:** por solicitud del autor se inspeccionaron todos los esquemas y las ecuaciones en bloque. Se sustituyeron dos diagramas de caracteres deformados y una cadena narrativa excesivamente ancha por las Figuras 1.1, 3.1 y 5.1, con originales vectoriales y PNG de 320 ppp. El flujo de salud exige bloqueo y reevaluación antes de derivar claves; la arquitectura y la rotación completa se identifican como diseño con integraciones pendientes. Se retiró una llave decorativa vacía de la fórmula KDF. La presentación del aporte en §1.4 se alineó con los límites de §§5.8 y 6.4–6.7.

**Edición vigente tras esta revisión:** Word de **81 páginas**, PDF de **70**, **3 figuras**, **19 tablas / 389 celdas** y **351 objetos matemáticos nativos en Word**, incluidos **18 bloques**. Se inspeccionaron las 18 fórmulas en Word y PDF y las tres figuras en su ubicación final; el PDF conserva tamaño base de 12 puntos en esas fórmulas. Las celdas coinciden con una conversión independiente y las tablas conservan rótulo y cuerpo en la misma página de Word. Se documentó la [evaluación de la tesis y las correcciones gráficas](Documentos/04-Administrativo-TG2/Avances/Revision-Graficas-y-Evaluacion-2026-09-22.md). Este avance es documental; R2–R5 de la ruta conservan sus pendientes técnicos.

---

> [!IMPORTANT]  
> **Preservación de antecedentes de TG1:** Los documentos administrativos y entregables históricos aprobados de TG1 se conservan. El trabajo técnico pendiente se concentra en los Objetivos 3 y 4. La edición vigente del manuscrito incorpora la aclaración expresa del autor sobre sistemas en general registrada arriba.

---

## 🎯 Objetivos de TG2 Bajo Seguimiento

| Objetivo Específico | Descripción Breve | Estado |
| :--- | :--- | :--- |
| **Objetivo 3** | Lógica de seguridad activa del ciclo de vida de claves: monitoreo de min-entropía (NIST SP 800-90B: RCT y APT) y rotación con secrecia hacia adelante. | 🟡 En Desarrollo |
| **Objetivo 4** | Formalización teórica (reducción inforjabilidad Dilithium \(\rightarrow\) Mod-SIVP) y validación empírica (análisis \(\mathcal{O}\) y *benchmarks*). | 🟡 En Desarrollo |

---

## 📋 Registro Semestral de Avances y Cambios (Changelog)

| Fecha | Categoría / Objetivo | Componente Afectado | Descripción del Cambio / Avance | Estado / Evidencia |
| :--- | :--- | :--- | :--- | :--- |
| **2026-07-31** | Objetivo 3 / TG2 | Modelo de Entropía (§5.2) | Consolidación del cambio metodológico de Entropía de Shannon a **Min-Entropía (\(H_{\infty}\), NIST SP 800-90B)** y definición de pruebas en línea (RCT y APT). | 🟢 Completado (Notas / Doc) |
| **2026-07-31** | General / TG2 | Estructura de Proyecto | Creación de la Bitácora de Seguimiento de TG2 (`BITACORA_TG2.md`) e integración de las notas de la revisión bibliográfica. | 🟢 Completado |
| **2026-07-31** | Objetivo 3 / TG2 | `nexus-crypto/entropy.rs` | **Auditoría del código:** se constató que las Actividades 3.1 y 3.2 ya están mayormente implementadas desde junio: `HealthMonitor` con RCT (corte \(C = 1 + \lceil -\log_2\alpha / H \rceil\)) y APT (ventana 512), bloqueo del KDF ante fallo, y rotación con *forward secrecy*; cubierto por tests (`test_health_rct_detects_stuck_source`, `test_ingest_unhealthy_source_triggers_rotation`, `test_sentinel_seed_rotation_forward_secure`). | 🟢 Verificado (código + tests) |
| **2026-07-31** | General / TG2 | `nexus/` (README, Cargo.toml, .gitignore) | Sincronización documentación↔código: README actualizado (Sentinel-Seed pasa de "Parcial — métrica a reformular" a "Implementado"; eliminados restos obsoletos sobre `from_seed` no determinística y "correcciones de compilación" ya resueltas), URL del repo corregida en `Cargo.toml` (`JuanDiegoSusunaga/nexus`), y `.gitignore` cubre `logs/` y `nexus-monorepo/`. | 🟢 Completado |
| **2026-07-31** | Objetivo 4 / TG2 | README / `nexus-zk`, `nexus-active` | Corrección de **subestimación** en el README: el PoC STARK hash-based (`nexus-zk::stark`: Goldilocks, NTT, Merkle/SHA3, Fiat-Shamir, FRI, AIR) y el puente `PqValidityProof` en `verify_zk` (liga raíces pre/post) figuraban como "Trabajo futuro / placeholder" pese a estar implementados desde junio. Conteo de tests actualizado de 70 a 97 (última ejecución verificada, 2026-06-05). | 🟢 Completado |
| **2026-07-31** | Infraestructura | Toolchain Rust | Se detectó que el toolchain de Rust no estaba instalado; **reinstalado el mismo día** (rustup, Rust 1.97.1 MSVC, perfil minimal). Suite completa re-ejecutada: **110/110 tests pasan** (core 15, crypto 25, anchor 16, active 20, zk 34) con `CARGO_TARGET_DIR=C:\tmp\nexus-target`. | 🟢 Resuelto |
| **2026-07-31** | General / TG2 | Repo `nexus` (GitHub) | Removido `fuzzy_extractor.rs` (alcance v2), CLI `info` actualizado, y commit + push de toda la sincronización a `main` (`d6c81a5`). | 🟢 Completado |
| **2026-07-31** | Objetivo 3 / 4 / TG2 | Manuscrito (Caps. 2, 5, 7) + Estado del Arte | **Integración del estado del arte al manuscrito:** (1) Cap. 5: nueva **§5.6 "Residencia efímera de la clave en memoria"** (política KeyGen-por-firma, métrica $W$, benchmark +0,75 ms, nota de cumplimiento FIPS sobre derivación de $\xi$; secciones 5.6-5.8 renumeradas a 5.7-5.9); (2) Cap. 2 §2.7: viñeta de posicionamiento "Gestión y defensa de la clave del firmador" (RFC 9881, Puffer, Rollup-Boost, patente US 10,521,584); (3) Cap. 7: contribuciones 7-8 (residencia efímera + propuesta Deception Engine, declarada como diseño no implementado) y trabajo futuro 9 (Deception Engine con requisitos de indistinguibilidad); (4) bibliografía consolidada +9 entradas ([RFC9881], [Connolly26], [JR13], [ADP18], [BRS22], [Sawa25], [US10521584], [Puffer23], [RollupBoost25]); (5) `05-Estado-del-Arte/estado_del_arte.md` ampliado con §5. Cambios replicados en `Tesis-NEXUS-completa.md`. Además se creó `plantilla-referencia.docx` (reference-doc de pandoc con **Times New Roman 12, interlineado 1,5**, idioma es) y se regeneró `Tesis-NEXUS-completa.docx` con ella — comando: `pandoc Tesis-NEXUS-completa.md --reference-doc=plantilla-referencia.docx -o Tesis-NEXUS-completa.docx`. | 🟢 Completado |
| *Próximo* | Objetivo 3 (Act 3.1) | `nexus-crypto` / KDF | ~~Implementación del módulo RCT y APT~~ **Ya implementado (junio 2026).** Resta: fijar parámetros \(W\) y \(C\) según la fuente TRNG/PRNG objetivo (→ Decisión 001) y documentarlo en el capítulo. | 🟡 Parcial |
| *Próximo* | Objetivo 3 (Act 3.2) | `nexus-core` / Key Registry | Rotación por política con *forward secrecy* **ya implementada** en `entropy.rs`. Resta: registro auditable de eventos de rotación en el Key Registry (→ Decisión 002). | 🟡 Parcial |
| *Próximo* | Objetivo 4 (Act 4.1) | Documento Tesis / Cap 4-5 | Formalización teórica de la cadena de reducciones (\(\text{Dilithium} \to \text{Module-LWE/SIS} \to \text{Mod-SIVP}\)) y argumento de Shor. | ⏳ Pendiente |
| **2026-07-31** | Objetivo 4 (Act 4.2) | Benchmarking Suite | **Benchmarks empíricos ejecutados** (Criterion, 100 muestras, medianas, rustc 1.97.1): Dilithium3 — keygen 413 µs, firma 790 µs, verificación 232 µs (D2/D5 en README). PoC STARK: traza 16→4.096 pasos (256×) ⇒ prueba 129→434 KB (~3,4×) y verificación 4,5→11,4 ms (~2,6×) — comportamiento polilogarítmico confirmado. Resultados publicados en README (commit + push). | 🟡 Parcial — falta comparativa vs. ECDSA/RSA y análisis \(\mathcal{O}\) en el capítulo |
| **2026-07-31** | Objetivo 3 / 4 / TG2 | Propuesta preliminar / Rediseño v2 | **Rediseño V2 "Dilithium 3 + Multisemilla + Deception Engine":** Proponía sustituir la inyección de `RDTSC` por un *Honeytoken Deception Engine* (firmas señuelo válidas en L2), *Threshold ML-DSA* (MPC para fragmentación de $s_1$), custodia en TPM/SGX y aislamiento de memoria con `zeroize` y `VirtualLock`. | Registro histórico; documento retirado por indicación del autor el 2026-09-23. |
| **2026-07-31** | Objetivo 3 / 4 / TG2 | Estado del Arte (Cap. 2 / 5 / 7) | **Revisión de estado del arte de la V2** (3 frentes paralelos con fuentes verificadas): (1) el formato *seed-only* ya es estándar (FIPS 204 §3.6.3, **RFC 9881** lo declara RECOMENDADO, OpenSSL 3.5 por defecto) — no es reclamable como novedad; (2) **sí son huecos reales**: KeyGen-por-firma como política de seguridad (draft-connolly sugiere lo contrario), métrica $W=\text{bytes}\times\Delta t$, y el Deception Engine PQ (prior art más cercano: patente Amazon US 10,521,584 B1, sin PQC ni disparador anti-debug); (3) ningún sistema 2024-2026 cierra el triángulo semilla sellada + detección de compromiso + respuesta L2 (parciales: Puffer Secure-Signer, Rollup-Boost/Unichain). Incluye 5 advertencias de diseño (indistinguibilidad del señuelo, matiz Storm-0558, restricción NIST sobre derivar ξ vía KDF). | 🟢 Completado (`Documentos/02-Investigacion-y-Notas/Estado-del-Arte-Claves-Efimeras-y-Deception.md`) |
| **2026-08-03** | General / TG2 | Dirección y comité | **Cambio de director aprobado:** Pedro Mario Wightman Rojas asume la dirección del trabajo de grado; **TG1 calificado 4.2** (evaluado por el prof. Wightman). Condiciones del comité para TG2: plan de trabajo acordado con el director, entregas parciales formalizadas y comunicación permanente por escrito. | 🟢 Registrado (correo del comité, 2026-08-03) |
| **2026-08-03** | C4 / TG2 | Estado del Arte / Bibliografía | **Estado del arte de pagos agénticos** (3 frentes con fuentes primarias verificadas, corte ago. 2026): protocolos AP2/x402 (AP2 donado a FIDO Alliance; x402 ~130M txns, cifra académica), redes de tarjetas (Visa IC/TAP, Mastercard Agent Pay; **retiro de Instant Checkout de OpenAI, mar-2026** = evidencia de inmadurez), OWASP agéntico (Top 10 2026, T1–T15) y papers x402 2026 — el **SoK arXiv:2604.03733 declara abiertas exactamente las brechas que C1–C3 atacan** (*weak intent binding*, *misuse under valid authorization*, *limited accountability*), sin PQC en ese espacio. **+18 entradas** en `_tesis-bibliografia.md` (incl. nueva sección OWASP). | 🟢 Completado (`Documentos/02-Investigacion-y-Notas/Estado-del-Arte-Pagos-Agenticos.md`) |
| **2026-08-03** | General / TG2 | Organización TG2 | **Formalización de TG2** (responde a las condiciones del comité): creados `Plan-de-Trabajo-TG2.md` (borrador v0.1 para acordar con el director: fases F0–F4, entregables E0–E4, riesgos y metodología de seguimiento), `Formatos/Plantilla-Entrega-Parcial-TG2.md` y el brief `Estado-del-Proyecto-para-Director.md`, todos en `Documentos/04-Administrativo-TG2/`. Plan Maestro actualizado con la Fase F (TG2). | 🟢 Completado |
| **2026-08-03** | General / TG2 | Auditoría y limpieza del repo | **Auditoría de los ~140 markdown** (2 barridos sistemáticos) + limpieza reversible a `Documentos/_archivo/`: 19 papers descartados (10 duplicados + 9 irrelevantes) y 33 dudosos archivados → corpus curado de **57 fuentes útiles** (nota de curaduría en `00_INDICE_DE_FUENTES.md`); archivados también los 2 `.bib` falsos (contenían 1 entrada de derecho administrativo, export de prueba UR), `Cap4-Validacion-Formal-Esqueleto.md` (superseded), el archivo de notas de revisión, el respaldo JSON de 7,1 MB y `nexus/nexus-monorepo/` (vestigial). **Estado del arte consolidado** en `02-Investigacion-y-Notas/` (el general renombrado a `Estado-del-Arte-General.md`); carpetas vacías eliminadas. Hueco identificado (no urgente): matriz de trazabilidad afirmación→fuente nunca construida (`Resumenes-y-Matriz/` estaba vacía). | 🟢 Completado |
| **2026-08-03** | General / TG2 | Manuscrito ensamblado | **`Tesis-NEXUS-completa.md` re-ensamblado y `.docx` regenerado** (pandoc + `plantilla-referencia.docx`): incorpora las 18 referencias nuevas de la bibliografía (agéntico/OWASP) y corrige el frontmatter — **director actualizado de L. Huertas a P. Wightman** y fecha a 03/08/2026. | 🟢 Completado |
| **2026-08-03** | Infraestructura | Control de versiones (documentos) | **Raíz de `Tesis/` puesta bajo git** (rama `main`; `.gitignore` excluye `nexus/` — repo propio — y las carpetas de configuración local de herramientas). Commit inicial `0e2ca4d` con TODO el proyecto incluido `_archivo/`; luego **`Documentos/_archivo/` eliminado definitivamente** en `ac5165d` — recuperable con `git checkout 0e2ca4d -- "Documentos/_archivo"`. Responde a la exigencia de formalización/trazabilidad del comité. | 🟢 Completado |
| **2026-08-07** | Infraestructura | Toolchain Rust (portátil nuevo) | **Entorno replicado en el MSI Vector 16** (Core Ultra 9 275HX, 24 núcleos, 32 GB DDR5): VS Build Tools 2022 (workload C++) + rustup con Rust 1.97.1 MSVC (perfil minimal, misma versión que julio). Suite completa verificada: **110/110 tests pasan** (core 15, crypto 25, anchor 16, active 20, zk 34) con `CARGO_TARGET_DIR=C:\tmp\nexus-target`; `nexus-zk` completo en 1,75 s. Habilita re-ejecutar los benchmarks de la Act. 4.2 en un segundo perfil de hardware. | 🟢 Completado |
| **2026-08-07** | Objetivo 4 (Act 4.2) | Benchmarking Suite (2.º perfil de hardware) | **Benchmarks re-ejecutados en el MSI Vector 16** (Criterion, medianas): Dilithium3 — keygen 142 µs, firma 290 µs, verificación 77,6 µs (2,7–3,0× más rápido que el Latitude 7280; tamaños de firma idénticos). **Comparativa vs. clásicos re-ejecutada en H2** (la corrida H1 del 2026-07-31 ya estaba publicada en el README de `nexus`; el pendiente de F2 era llevarla al capítulo): ECDSA P-256 70/87,5/144,8 µs y RSA-2048 106,6 ms/740,5 µs/92,4 µs (keygen/firma/verif) — **la verificación Dilithium3 resulta 1,9× más rápida que ECDSA P-256**, la operación caliente del sequencer L2: el costo PQC real está en el tamaño de firma (3,3 KB vs 64 B), no en CPU. KeyGen-por-firma (C1) cuesta aquí ~0,14 ms. **STARK extendido** (`stark_demo.rs` ampliado a 2¹⁴/2¹⁶/2¹⁸ gracias a los 32 GB): traza 16→262.144 pasos (16.384×) ⇒ prueba 129→768 KB (~6,0×) y verificación 1,25→7,74 ms (~6,2×) — confirmación polilogarítmica con tres décadas más de evidencia; generación 10,3 s a 2¹⁸. Cierra la parte empírica de la comparativa pendiente de F2. | 🟢 Completado |
| **2026-08-07** | Objetivo 4 (Act 4.2) | Manuscrito (Cap. 6) | **Resultados del 2.º perfil integrados al capítulo:** §6.6 reestructurada en **§6.6.1** (ML-DSA en dos perfiles H1/H2, con tabla de perfiles de hardware y Tabla 6.3 nueva), **§6.6.2** (comparativa medida vs. ECDSA P-256 y RSA-2048/3072, Tabla 6.4 — cierra el pendiente de F2) y **§6.6.3** (verificador STARK, Tabla 6.5 con la curva 2⁴→2¹⁸ y el análisis del escalado \(O(\log^2 n)\): progresión aritmética de incrementos +10 KB por cuadruplicación). Tabla de §6.5.4 actualizada con las cifras medidas (la celda "decenas de µs" de ECDSA pasa a 144,8 µs vs. 77,6 µs de D3) y conclusión §6.8.3 reescrita con los tres hallazgos. Cambios replicados en `Tesis-NEXUS-completa.md`. | 🟢 Completado |
| **2026-08-07** | Objetivo 3 (Act 3.1) | `nexus-crypto` / Decisión 001 | **Barrido empírico de parámetros (W, C) del APT** (nuevo harness `examples/apt_sweep.rs`: simulación multihilo con equivalencia verificada muestra-a-muestra contra `HealthMonitor`; 24 hilos, ~13 s, RNG determinista). **Hallazgo:** el corte por aproximación normal implementado (C=11 en W=512) viola el α=2⁻²⁰ de diseño ~700× (cola real 6,7×10⁻⁴): dispara rotación espuria cada ~12 MB **incluso con fuente perfecta**; el corte binomial exacto que prescribe SP 800-90B (C=16) cumple con margen (medido 2⁻²⁶/ventana en 67 M ventanas). Latencia de detección con C=16: sin costo en degradaciones graves (H≤5); las sutiles (H 6–7) quedan cubiertas por el estimador MCV, que requiere **lote ≥ 65.536 muestras** (con N=4.096 flagea el 100 % de fuentes perfectas — sesgo de muestra pequeña detectado y cuantificado). Propuesta completa en `Documentos/02-Investigacion-y-Notas/Decision-001-Parametros-APT.md`; `HealthMonitor` **sin modificar** a la espera del acuerdo con el director. | 🟡 Propuesta lista — pendiente acuerdo con el director |
| **2026-08-07** | Objetivo 3 (C1) / Objetivo 4 (Act 4.2) | Benchmarking Suite + Manuscrito (Caps. 5 y 6) | **(1) Métrica W ahora reproducible:** nuevo `nexus-crypto/benches/residencia_bench.rs` (cacheada vs. efímera vs. expansión aislada; el "benchmark dedicado" de julio no estaba versionado). Re-medido en H2 (medianas): D3 cacheada 314 µs → efímera 432 µs = **sobrecosto +0,12 ms** (vs. +0,75 ms en H1); expansión aislada 133 µs. §5.6 actualizada con las cifras, el harness y el punto de equilibrio de la métrica W (λ≈2.300 firmas/s; 103× menos exposición media a 10 firmas/s). **(2) Throughput multinúcleo medido** (última métrica de la Act. 4.2): nuevo `examples/throughput_tps.rs` — verificación D3: 12.485 verif/s (1 hilo) → **199.218 verif/s (24 hilos, escalado ×16)**; párrafo añadido en §6.6.1. Cambios replicados en `Tesis-NEXUS-completa.md`. | 🟢 Completado |
| **2026-08-07** | General / TG2 | Consistencia + Administrativo | **(1) Cifras H1 unificadas:** la Tabla 6.2 del Cap. 6 usaba una corrida pre-julio sin fecha; se declaró oficial la del **README (2026-07-31, rustc 1.97.1)** — D3 413/790/232 µs — y se realinearon las razones derivadas (H2 = 2,5–3,0× H1). Se corrigió además el registro previo de hoy: la comparativa clásica H1 **ya estaba** en el README desde julio (el pendiente de F2 era llevarla al capítulo, no ejecutarla); nota añadida en §6.6.2 (en H1, RSA-2048 verificaba 218 µs vs. 232 µs de D3). **(2)** pandoc 3.10.1 instalado en el portátil nuevo y **`Tesis-NEXUS-completa.docx` regenerado** con la plantilla. **(3) Borrador de la Entrega Parcial 01** en `Documentos/04-Administrativo-TG2/Avances/` (período 08-03→08-07, con las preguntas para el director). **(4) Borrador de la Decisión 002:** registro auditable de rotaciones como log encadenado por hash en L2 con anclaje Merkle en L1 (`Decision-002-Registro-Auditable-Rotaciones.md`). **(5)** Creado `PENDIENTES.md` en la raíz como vista consolidada de lo abierto. | 🟢 Completado |

---

## Actualización 2026-09-22 — Ruta de cierre de TG2

Se realizó una revisión estática y documental del proyecto y se creó la [Ruta de acción para cerrar TG2](Documentos/04-Administrativo-TG2/Ruta-de-Cierre-TG2.md), enlazada desde `PENDIENTES.md`. Organiza el trabajo en seguimiento académico, revisión formal del Objetivo 4, monitor de entropía, rotación y auditoría del Objetivo 3, evidencia experimental, métrica W y consolidación final.

Los puntos a resolver incluyen el argumento de extracción y la cota estadística del Cap. 6, el umbral APT, la recuperación de salud tras rotación, la actualización efectiva de claves, el registro de épocas, la aceptación heredada de pruebas y la codificación parcial de raíces del PoC, y la interpretación de la métrica de residencia. La ruta distingue resultados de componentes y garantías del sistema completo, preserva los entregables aprobados de TG1 y establece criterios de cierre verificables.

**Estado:** planificación documentada; ejecución pendiente. No se modificó código ni se ejecutaron pruebas o benchmarks en esta revisión. Los acuerdos académicos posteriores al 7 de agosto deben incorporarse si existen; no se presume su ausencia fuera del repositorio.

## Ejecución 2026-09-22 — Trazabilidad, revisión formal y edición del manuscrito

Se inició R0 con la confirmación de aprobación del director comunicada por el estudiante, la matriz de 23 afirmaciones/requisitos y la preservación de 125 archivos de evidencia local, incluidos 29 resultados Criterion. La caché contiene medianas parcialmente distintas de las transcritas en agosto; se registra esa diferencia sin atribuirla a una réplica ni cambiar silenciosamente las tablas históricas. El inventario conserva hashes, origen y estado Git.

Se revisó §6.4 contra las fuentes: el término `2^-254` sí está publicado en la especificación de Dilithium, pero no se justifica como cota del ML-DSA implementado con el argumento anterior. Se retiró la extracción inválida a partir de dos firmas arbitrarias del mismo mensaje, se añadieron las correcciones de Barbosa et al. y las condiciones del trabajo de Jackson–Miller–Wang, y se distinguieron los supuestos de dureza de la no aplicabilidad directa de Shor. La instanciación completa y la revisión matemática externa siguen pendientes.

Se conciliaron el resumen, los capítulos 5–7 y el balance de objetivos. Por solicitud del estudiante, se normalizaron títulos, ecuaciones, listas y tablas de la edición ensamblada; los capítulos de TG1 reciben únicamente cambios de presentación. El ensamblado se genera desde las fuentes mediante `scripts/compilar_manuscrito.py`; `scripts/exportar_manuscrito_word.ps1` actualiza el índice de Word y `scripts/exportar_manuscrito_pdf.py` genera el PDF localmente desde la misma fuente.

**Primera revisión editorial, anterior a la aclaración de alcance:** 19 tablas y 389 celdas coinciden entre Markdown y Word, incluida la notación matemática tras normalizar su representación equivalente. Se conservaron 352 objetos matemáticos en la generación. Se revisaron las páginas renderizadas de Word y PDF y las tablas de resultados; los 19 rótulos permanecen junto a sus tablas y cada tabla cabe en una página de Word. El PDF no tiene páginas vacías ni texto fuera de los márgenes. Word: 78 páginas; PDF: 68, con índices propios. La exportación PDF nativa de Word se bloqueó incluso con un documento mínimo; se utilizó conversión local HTML/MathML con Chrome. Los informes y hashes están en `Documentos/06-Evidencia-TG2/2026-09-22/`. Se conserva una única salida vigente por formato en `01-Manuscrito/`, con instrucciones de regeneración en su README.

**Validación realizada:** lectura de fuentes, inventario con hashes y comprobaciones documentales. No se modificó el prototipo Rust ni se ejecutaron tests o benchmarks nuevos. El cierre técnico de R1–R5 no se declara por estas correcciones editoriales. La versión ensamblada es la edición de trabajo vigente, no una entrega académica final aprobada.

## 🔬 Detalle Técnico por Módulo de TG2 — notas históricas de julio/agosto

### 1. Módulo de Seguridad Activa del Ciclo de Vida de Claves (Objetivo 3)

#### Actividad 3.1: Fuente de Entropía y Pruebas NIST SP 800-90B
* **Métrica Aceptada:** Min-entropía de peor caso (\(H_{\infty} = -\log_2(\max P(x_i))\)).
* **Mecanismos de Control:**
  * **Repetition Count Test (RCT):** Dispara alerta y bloqueo si se observan \(B\) muestras idénticas consecutivas.
  * **Adaptive Proportion Test (APT):** Evalúa si el conteo de coincidencias en una ventana de \(W\) muestras excede el umbral de corte \(C\).
* **Acción de Respuesta:** Suspensión inmediata del KDF (HKDF-SHAKE256) si alguna prueba falla, impidiendo la generación de pares de claves compromised.
* **Estado (2026-07-31):** Implementado en `nexus-crypto/src/entropy.rs` (`HealthMonitor`) con tests; pendiente la parametrización final de \(W\) y \(C\) (Decisión 001).

#### Actividad 3.2: Rotación con Secrecia Hacia Adelante (*Forward Secrecy*)
* **Mecanismo:** Generación periódica de efímeros de firma y derivación de épocas (*epochs*).
* **Registro Auditable:** Registro inmutable en L1/L2 de eventos de rotación para evitar reutilización o repudio de claves antiguas.
* **Estado (2026-07-31):** Rotación con *forward secrecy* implementada y testeada en `entropy.rs`; el registro auditable en el Key Registry sigue pendiente (Decisión 002).

---

### 2. Módulo de Formalización y Validación de Seguridad y Complejidad (Objetivo 4)

#### Actividad 4.1: Cadena de Reducciones Teóricas
* **Esquema de Reducción:**
  \[
  \text{EUF-CMA (Dilithium)} \xrightarrow{\text{Reducción}} \text{Module-LWE / SelfTargetMSIS / Module-SIS} \xrightarrow{\text{Reducción}} \text{Mod-SIVP (Peor Caso)}
  \]
* **Demostración frente a Computación Cuántica:** Demostrar formalmente que los reticulados algebraicos no poseen subgrupos ocultos abelianos explotables por la QFT (*Quantum Fourier Transform*) en el algoritmo de Shor.

#### Actividad 4.2: Análisis de Complejidad Computacional y Benchmarks
* **Análisis asintótico:** Complejidad en notación \(\mathcal{O}\) para la verificación de firmas CRYSTALS-Dilithium en entornos constrained (L2) frente a verificadores de prueba STARK.
* **Benchmarks Empíricos:** Mediciones de latencia (ms), throughput (tps), consumo de memoria y tamaño de payload (bytes).

---

## 📌 Pendientes y Decisiones de Diseño — registro histórico de agosto

El estado vigente está en [PENDIENTES.md](PENDIENTES.md). La aprobación comunicada el 22 de septiembre actualiza el estado administrativo de estas notas; su ejecución técnica sigue los criterios de la ruta de cierre.

- [ ] **Decisión 001:** Determinar los parámetros exactos de ventana (\(W\)) y corte (\(C\)) para la prueba APT según las especificaciones del TRNG/PRNG seleccionado. → **Propuesta empírica lista (2026-08-07):** W=512, C=16 (binomial exacta, no aprox. normal) + lote MCV ≥ 65.536; ver `Documentos/02-Investigacion-y-Notas/Decision-001-Parametros-APT.md`. Falta el acuerdo con el director.
- [ ] **Decisión 002:** Definir la estructura de almacenamiento eficiente de los eventos de rotación en el *Key Registry* para mantener latencia baja en la L2.
- [ ] **Decisión 003:** Establecer la suite de pruebas de rendimiento empírico (Rust criterion / harness de benchmarks).

---

*Esta bitácora se actualizará continuamente a lo largo del semestre a medida que se ejecuten actividades y refactorizaciones en TG2.*

## 2026-10-19 — Conciliación del resultado ROM y tesis final unificada

Por solicitud del autor se regeneran los entregables y se eliminan del manuscrito las etiquetas TG1/TG2 y la narrativa de borradores, ediciones o fases de redacción. Los respaldos y el historial permanecen fuera de la tesis de consulta. Las versiones de software, formatos criptográficos y fuentes citadas se conservan cuando son necesarias para reproducibilidad.

§6.7.9 recoge la cota conservadora de los teoremas Lean, con `B=Q+24895`, presupuesto auxiliar `L`, eventos hash/AIR/FRI, muestra compartida, acoplamiento con memoria y trabajo causal. Se explicitan perfiles fijos y adaptativos y dos corolarios de aceptación falsa con sus hipótesis. No se conserva como resultado vigente una fórmula histórica más fuerte cuya equivalencia no está demostrada.

Se generan Word (112 páginas) y PDF (99 páginas) desde las mismas fuentes; se cotejan 34 tablas y 848 celdas, tres figuras y 583 ecuaciones nativas de Word. Se inspeccionan todas las páginas renderizadas y no se detectan desbordes ni pérdidas de contenido. El renderizador empaquetado no pudo iniciar por falta de `pdf2image`; se utiliza el renderizado local existente con Word oculto y el PDF local con MathML. No se compila Lean ni se altera su código: coinciden las 354 huellas de fuentes y las diez de registros de la auditoría global previa.

Evidencia: `Documentos/06-Evidencia-TG2/2026-10-19/Conciliacion-Manuscrito-ROM/`. Esta conciliación no acredita corrección global de toda la tesis, refinamiento universal del ejecutable Rust, seguridad SHA3 fuera del ROM, QROM completo ni aprobación académica.
