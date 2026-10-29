# Índice de evidencia TG2

**Acceso unificado para revisión, 29 de octubre de 2026:** [tesis, matemáticas y Rust](../../README.md) están en un mismo repositorio. La última evidencia Rust conservada es el [ciclo local durable](2026-10-20/Ciclo-Local-Durable/verificacion.json), sobre `b16688c`, con 360 pruebas de workspace y 13 dirigidas en release. La auditoría Lean conserva sus 2709 declaraciones. Esta organización verifica integridad sin repetir compilaciones ni modificar los registros históricos.

**Guía explicada para el director, 20 de octubre:** se reescribe la solicitud tras la observación del autor sobre su dificultad. Explicación de tres páginas y anexo desde la cuarta, ocho páginas en total, 33 objetos matemáticos nativos, 23 vínculos y cuatro bloques de fórmulas idénticos a la tesis. [Cotejos, revisión visual y respaldos](2026-10-20/Revision-Director-Clara/verificacion.json). Tesis, 354 fuentes/configuraciones Lean y 89 Rust intactas; sin compilaciones ni nuevo commit/push, envío o dictamen. La solicitud de seis páginas descrita en los registros anteriores es un antecedente.
**Consolidación editorial local, 20 de octubre:** se incorporan al commit autorizado la preparación para el director, la solicitud Word, las referencias aclaradas, el glosario y la notación en preliminares, sus salidas y evidencias. [Alcance exacto, huellas y respaldos](2026-10-20/Consolidacion-Editorial/preparacion.json). Las fuentes y salidas no se modifican durante esta consolidación. Sin compilaciones, suites, regeneración, push, envío ni dictamen. Se excluyen presentación y temporales.
**Glosario en preliminares, 20 de octubre:** se reubican el glosario y la notación antes del capítulo 1, sin reescribir sus definiciones. El glosario comienza en la página 7 de ambos formatos; Word/PDF mantienen 123/111 páginas. [Verificación de orden, contenido, índices, regiones renderizadas y respaldos](2026-10-20/Glosario-Preliminares/verificacion.json). Las diez fuentes Markdown, 354 Lean y 89 Rust permanecen intactas. No se compila código ni se registra envío o dictamen. La incorporación al final documentada debajo corresponde a la etapa previa.
**Claridad de lectura y glosario, 20 de octubre:** se prepara la [solicitud para el director en Word](../04-Administrativo-TG2/Avances/Revision-Matematica-NEXUS.docx) con el formato de la tesis y se aclaran los signos de sección y M también en el manuscrito. La [primera revisión editorial](2026-10-20/Claridad-Referencias/verificacion.json) conserva 115/105 páginas Word/PDF y sus respaldos. Con autorización «Sí, ambos», se añaden 33 entradas de términos y 20 de notación, con salidas finales de 123/111 páginas y [verificación propia](2026-10-20/Glosario-Notacion/verificacion.json). Se conservan exactamente las fórmulas, hipótesis y objetivos anteriores, 354 fuentes/configuraciones Lean y 89 Rust. No hay nuevas compilaciones, commit/push, envío ni dictamen. Las cifras siguientes corresponden a sus respectivas etapas.

**Paquete preparado para el director, 20 de octubre:** [solicitud M1–M6 actualizada](../04-Administrativo-TG2/Avances/Revision-Matematica-S1-S3-2026-09-23.md), con las seis preguntas originales, material vigente, hipótesis y formato de respuesta. [Integridad y respaldos](2026-10-20/Preparacion-Revision-Director/preparacion.json). El director es el revisor indicado por el autor; no se registran envío, recepción ni dictamen. Los cotejos de enlaces, fuentes y tres ejemplos racionales son internos, no una revisión externa. Fuentes y manuscrito intactos, sin compilar, regenerar salidas, crear commit ni hacer push.

**Consolidación Lean posterior, 20 de octubre:** las fuentes previamente auditadas y sus herramientas se incluyen en un commit local separado, sin modificar demostraciones, compilar, repetir pruebas ni hacer push. [Preparación, integridad y respaldos](2026-10-20/Consolidacion-Lean/preparacion.json). Se concilian los README y se preservan las 354 fuentes/configuraciones Lean, 89 Rust y doce fuentes/salidas del manuscrito. No hay módulos ni obligaciones matemáticas nuevas; se excluyen dependencias y cachés.

**Antecedente documental local, 20 de octubre:** `a9faf0e` incorporó manuscrito, evidencia e índices sin repetir compilaciones, regenerar salidas ni hacer push. [Preparación, alcance y respaldos](2026-10-20/Consolidacion-Documental/preparacion.json). Los registros cerrados se conservan; las fuentes Lean y sus herramientas nuevas quedaron fuera de aquel commit y se versionan en la consolidación posterior descrita arriba, sin modificar su auditoría previa.

**Última comprobación, 20 de octubre:** pasa la [verificación global final de Rust](2026-10-20/Rust-Global-Final/verificacion.json) después del contrato y de `ActiveChain`, commit `637e77c`: check de todos los targets, 223 pruebas sin fallos y build, con caché, dependencias locked/offline y cuatro trabajos/hilos. Las advertencias se conservan. No cambia ninguna fuente Rust/Lean ni el manuscrito y no se recompila Lean. Los registros de 197 pruebas globales previas y de 113/55 aisladas se mantienen como antecedentes, no se suman.

**Estado vigente, 20 de octubre:** la [compilación y auditoría globales de Lean](2026-10-20/Lean-Global/verificacion.json) confirman 2709 declaraciones; las fuentes no cambian. La conexión de `ActiveChain` al contrato con contexto local se consolida en el commit `637e77c99e804664915caf4ed928a10ef81cc870`, con evidencia previa de check/build y 55 pruebas aisladas, trece nuevas. [Procedencia, huellas y límites](2026-10-20/ActiveChain/consolidacion.json). La consolidación no repite compilaciones ni pruebas ni altera el manuscrito. El AIR escalar no valida transacciones ni raíces SHA3 generales: los lotes fuera del modelo se rechazan, sin acreditar una L2 completa.

**Conciliación documental posterior, 20 de octubre:** la [tesis sincronizada con Rust](2026-10-20/Conciliacion-Manuscrito-Rust/verificacion.json) incorpora ese contrato y su conexión local sin ampliar sus garantías. Word/PDF regenerados y revisados en sus 115/103 páginas, con 34 tablas, 848 celdas y 606 ecuaciones nativas. Las fórmulas e hipótesis de §6.7.9 y los objetivos se preservan; solo se actualiza allí la descripción del corte Rust. Las 89 fuentes/configuraciones Rust y 354 Lean permanecen idénticas, sin compilaciones ni pruebas nuevas.

**Antecedente, 18 de octubre:** [AIR/FRI de los vectores reales](2026-10-18/Lean-AIR-FRI-Real/README.md), 2469 resultados en 304 módulos. Aquella etapa añadió 55 resultados y conservó sus pendientes y límites; no es el censo vigente. Los avances posteriores del modelo ROM se describen en la [entrega actual](../04-Administrativo-TG2/Entrega-Final/README.md).

Las carpetas conservan resultados por fecha y etapa. Cada informe explica el alcance, comandos, fuentes y límites de su evidencia. Las copias de código bajo `fuentes/nexus/` pertenecen a las ejecuciones documentadas; no se editan para sincronizarlas con el código actual.

| Fecha / carpeta | Contenido |
|---|---|
| `2026-10-20/Revision-Director-Clara/` | Guía explicada de tres páginas y anexo técnico, ocho páginas Word; seis preguntas conservadas, referencia de formato, respaldos y revisión visual, sin alterar la tesis |
| `2026-10-20/Consolidacion-Editorial/` | Preparación del commit editorial local autorizado, alcance exacto, respaldos, huellas y exclusiones; sin recompilar ni publicar |
| `2026-10-20/Glosario-Preliminares/` | Reubicación del glosario y notación en preliminares, índices actualizados, contenido idéntico salvo orden y revisión Word/PDF; sin recompilar Lean/Rust |
| `2026-10-20/Glosario-Notacion/` | Glosario y notación autorizados, respaldos y cotejos; Word/PDF 123/111 páginas, 34 tablas y 664 objetos matemáticos nativos, sin recompilar Lean/Rust |
| `2026-10-20/Claridad-Referencias/` | Referencias escritas, M aclarada y solicitud Word de seis páginas con formato de tesis; revisión completa y respaldos previos al glosario |
| `2026-10-20/Preparacion-Revision-Director/` | Solicitud M1–M6 preparada para el director, respaldos, referencias y cotejos internos; sin envío ni dictamen, compilaciones o nuevas obligaciones matemáticas |
| `2026-10-20/Consolidacion-Lean/` | Fuentes Lean y herramientas existentes versionadas, README conciliados, respaldos y huellas cotejadas sin compilar, repetir pruebas ni hacer push |
| `2026-10-20/Consolidacion-Documental/` | Preparación y respaldos del commit documental local, con alcance explícito y sin fuentes Lean nuevas ni push |
| `2026-10-20/Rust-Global-Final/` | Check/test/build globales posteriores a ActiveChain: 223 pruebas sin fallos, advertencias y huellas conservadas; sin cambios de fuentes ni recompilar Lean |
| `2026-10-20/Conciliacion-Manuscrito-Rust/` | Tesis sincronizada con el contrato y ActiveChain; Word/PDF 115/103 páginas revisadas, respaldos y controles sin recompilar Rust/Lean |
| `2026-10-20/ActiveChain/` | Integración con contexto local, 55 pruebas aisladas y consolidación del commit `637e77c`; instantáneas anteriores conservadas |
| `2026-10-20/Rust-Lean/` | Adaptación, 113 pruebas aisladas, revisión estática y consolidación del commit Rust, con antecedentes conservados |
| `2026-10-20/Rust-Global/` | Check/test/build globales anteriores a la adaptación: 197 pruebas, advertencias registradas |
| `2026-10-20/Lean-Global/` | Compilación incremental global de 4084 trabajos y auditoría de 2709 declaraciones, sin cambio de fuentes |
| `2026-10-18/Lean-AIR-FRI-Real/` | 2469 resultados en 304 módulos; 55 nuevos sobre transferencia AIR/FRI, cardinal original, excepciones y B derivado desde Q |
| `2026-10-18/AIR-FRI-Real-Antecedentes/` | Dieciséis versiones previas, quince fuentes y criterios originales conservados |
| `2026-10-18/Lean-Candidatos-Falsos/` | 2414 resultados en 293 módulos; 45 nuevos sobre canal canónico falso, m<=B-1 y aceptación falsa con exceso de cardinal explícito |
| `2026-10-18/Candidatos-Falsos-Antecedentes/` | Dieciséis versiones previas, quince fuentes y criterios originales conservados |
| `2026-10-18/Lean-Prefijo-Selector/` | 2369 resultados en 285 módulos; 40 nuevos sobre prefijo bruto, políticas previsibles y cobertura en la unión por perfil fijo bajo g/m/B explícitos |
| `2026-10-18/Prefijo-Selector-Antecedentes/` | Dieciséis versiones previas, quince fuentes y criterios originales conservados |
| `2026-10-18/Lean-Consultas-Buenas/` | 2329 resultados en 277 módulos; 45 nuevos sobre aperturas extraídas, controles FRI y muestra efectiva aceptada en GT/GC |
| `2026-10-18/Consultas-Buenas-Antecedentes/` | Dieciséis versiones previas, quince fuentes y criterios originales conservados |
| `2026-10-18/Lean-Semantica-Previa/` | 2284 resultados en 269 módulos; 51 nuevos sobre lectura semántica, retos, vista congelada y GT/GC desde el pasado |
| `2026-10-18/Semantica-Previa-Antecedentes/` | Dieciséis versiones previas, quince fuentes y criterios originales conservados |
| `2026-10-18/Lean-Candidato-Previo/` | 2233 resultados en 261 módulos; 34 nuevos sobre recuperación del candidato antes del primer I y congelación de sus vectores |
| `2026-10-18/Candidato-Previo-Antecedentes/` | Dieciséis versiones previas, quince fuentes y criterios originales conservados |
| `2026-10-18/Lean-Primeras-Exposiciones/` | 2199 resultados en 254 módulos; 39 nuevos sobre activación, primera consulta y carga a direcciones distintas |
| `2026-10-18/Primeras-Exposiciones-Antecedentes/` | Dieciséis versiones previas, quince fuentes y criterios originales conservados |
| `2026-10-18/Lean-Selector-Adaptativo/` | 2160 resultados en 248 módulos; 45 nuevos, continuación exacta y selector dependiente del pasado con Pr(preconsulta) explícita |
| `2026-10-18/Selector-Adaptativo-Antecedentes/` | Dieciséis versiones previas, quince fuentes y criterios originales conservados |
| `2026-10-18/Lean-Selector-Acoplado/` | 2115 resultados en 241 módulos; 52 nuevos, transferencia local de omisión/abandono y seis parciales conservados |
| `2026-10-18/Selector-Acoplado-Antecedentes/` | Dieciséis versiones previas, quince fuentes y criterios originales conservados |
| `2026-10-18/Lean-Ley-Conjunta-ROM/` | 2063 resultados en 234 módulos; 63 nuevos, ley conjunta de resultado y registro y seis parciales conservados |
| `2026-10-18/Ley-Conjunta-Antecedentes/` | Dieciséis versiones previas, quince fuentes y criterios originales de seis grupos sin nuevos cierres |
| `2026-10-18/Lean-Familias-Causales/` | 2000 resultados en 227 módulos; 73 nuevos, familias AIR/FRI desde aceptación, cierre M37 y seis parciales |
| `2026-10-18/Familias-Causales-Antecedentes/` | Dieciséis versiones previas, quince fuentes y criterios originales de siete grupos, con evaluación del cierre M37 |
| `2026-10-18/Lean-Adversario-Causal/` | 1927 resultados en 216 módulos; 66 nuevos, propuesta adaptativa, intercalaciones, ley local y congelación; siete parciales |
| `2026-10-18/Adversario-Causal-Antecedentes/` | Dieciséis versiones previas, quince fuentes congeladas y siete criterios conservados |
| `2026-10-17/Lean-Verificador-Completo/` | 1861 resultados en 207 módulos; 105 nuevos, ruta matemática y presupuesto completo, siete parciales |
| `2026-10-17/Verificador-Completo-Antecedentes/` | Dieciséis versiones previas, fuentes congeladas y 50 casos Rust/Python con controles de rechazo y EOF |
| `2026-10-17/Lean-Certificado-Gramatica/` | 1756 resultados en 196 módulos; 49 nuevos, cierre del ejemplo M31 y siete grupos parciales |
| `2026-10-17/Certificado-Gramatica-Antecedentes/` | Dieciséis versiones previas, certificado legado público, relectura Python y fuentes Rust congeladas |
| `2026-10-17/NIST-Referencias/` | Doce fuentes oficiales, erratas, RCT/APT, generadores, custodia y ACVP; ocho grupos parciales sin cambios y auditoría Lean conservada |
| `2026-10-17/Lean-Cierre-Criterios/` | 1707 resultados en 191 módulos, 21 nuevos; once cierres de modelos con criterios originales y ocho parciales restantes |
| `2026-10-17/Cierre-Criterios-Antecedentes/` | Dieciséis versiones previas, cuatro fuentes R5 y evaluación explícita de los diecinueve grupos |
| `2026-10-17/Lean-Selector-Ciclos/` | 1686 resultados en 187 módulos: 76 nuevos; uniformidad, ley causal finita, NTT, parser y cadenas; 19 grupos parciales |
| `2026-10-17/Selector-Ciclos-Antecedentes/` | Dieciséis versiones previas, dos fuentes y nueve criterios/estados parciales conservados |
| `2026-10-17/Lean-Obligaciones-22/` | 1610 resultados en 177 módulos: 164 nuevos, revisión de 22 grupos, cierres M10/M32/M46 y 19 parciales restantes |
| `2026-10-17/Obligaciones-22-Antecedentes/` | Criterios de los 22 conservados, 16 versiones previas y 13 fuentes consultadas |
| `2026-10-17/Lean-Grados-Cancelacion/` | 1446 resultados en 157 módulos: 53 nuevos; cotas AIR ajustadas, cancelación por masa máxima y ejemplo exacto; 22 grupos parciales |
| `2026-10-17/Grados-Cancelacion-Antecedentes/` | Dieciséis versiones previas, datos exactos del ejemplo, seis fuentes actualizadas con copia y 314 conservadas |
| `2026-10-17/Lean-Modelos-Pendientes/` | 1393 resultados en 154 módulos: 176 nuevos, auditoría completa y correspondencias con el manuscrito; 24 grupos parciales |
| `2026-10-17/Modelos-Pendientes-Antecedentes/` | Diecisiete versiones anteriores, datos racionales, cuatro fuentes de cálculo y correcciones explícitas de tres candidatos/dos suplementos |
| `2026-10-17/Manuscrito-Modelos/` | Fuentes y salidas anteriores, regeneración Word/PDF/Markdown, revisión visual de 110/99 páginas, 34 tablas y 848 celdas |
| `2026-10-17/Lean-Juegos-Reticulares/` | 1217 resultados en 138 módulos: 114 nuevos sobre MLWE, extracción MSIS, consultas y juegos EUF/sUF; SelfTarget parcial |
| `2026-10-17/Juegos-Reticulares-Antecedentes/` | Quince versiones previas, alcance de los modelos y preservación de las 254 fuentes anteriores |
| `2026-10-17/Lean-Anillos-Contraejemplo/` | 1103 resultados en 129 módulos: 121 nuevos sobre anillos/normas ML-DSA y contraejemplo AIR con mínimo 7/8; auditoría y límites |
| `2026-10-17/Anillos-Contraejemplo-Antecedentes/` | Quince versiones previas y trece fuentes empíricas R4, incluidos seis certificados; alcance experimental conservado |
| `2026-10-17/Lean-Costos-Residencia/` | 982 resultados en 120 módulos: 118 nuevos sobre integral/captura, memoria, amortización variable, NTT y firma esperada; auditoría y límites |
| `2026-10-17/Costos-Residencia-Antecedentes/` | Quince versiones previas y trece fuentes R5; inventario ML-DSA-65/fips204 0.4.6 y constantes del modelo |
| `2026-10-17/Lean-Entropia-Salud/` | 864 resultados en 113 módulos: 87 nuevos sobre min-entropía, Shannon, RCT/APT, monitor y recuperación; auditoría de axiomas/núcleo, trazabilidad y límites |
| `2026-10-17/Entropia-Salud-Antecedentes/` | Quince versiones previas, copia de entropy.rs y referencia NIST; hashes para preservar la auditoría y clasificación anteriores |
| `2026-10-17/Revision-Manuscrito/` | Clasificación de 272 candidatos, 14 omisiones y 46 grupos de obligaciones; 51 bloques con enlaces parciales a pruebas existentes; sin teoremas nuevos |
| `2026-10-17/Lean-Enlace-AIR-FRI/` | 777 resultados acumulados: raíz Fp2 compartida TG2, seis aperturas AIR y controles locales N06; distinción del formato legado; auditoría de axiomas y núcleo |
| `2026-10-17/Lean-Hojas-Base/` | 753 resultados acumulados: hojas Fp de 9 bytes, etiquetas y memoria compartidas, oráculo base congelado y arreglos mixtos N06 para familias dadas; auditoría de axiomas y núcleo |
| `2026-10-17/Lean-Indice-Merkle/` | 717 resultados acumulados: rutas e índices, orden de hermanos y aperturas, oráculos FRI congelados y arreglos N06 de una familia dada; auditoría de axiomas y núcleo |
| `2026-10-17/Lean-Primeras-Consultas/` | 679 resultados acumulados: orígenes, orden bien fundado del grafo de ventanas y vector Merkle previo a la primera exposición del reto registrado; auditoría de axiomas y núcleo por módulo |
| `2026-10-17/Lean-Congelacion-Canal/` | 640 resultados acumulados: congelación antes de responder, formatos del canal, solapamiento con Merkle y secuencia local de raíz y reto; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-ROM-Memoria/` | 601 resultados acumulados: oráculo con memoria, repeticiones, probabilidad exacta, unión adaptativa de aciertos y apertura igual al vector congelado; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Merkle-Bytes/` | 558 resultados acumulados: bytes canónicos Fp2/Merkle, ventanas de 32 bytes, cobertura global del extractor y riesgo de un acierto uniforme nuevo; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Merkle-Congelado/` | 521 resultados acumulados: primer componente N07, registro abstracto, extracción y vinculación Merkle, etiquetas y estabilidad temporal del vector congelado bajo extensión segura; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Planes-Explicitos/` | 495 resultados acumulados: gramática explícita compatible con los mensajes anteriores, reinicios, transporte de planes completos en ambos sentidos y conservación de la probabilidad de aceptación; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Transcripcion-Explicita/` | 466 resultados acumulados: datos explícitos de cada prefijo, realización individual, equivalencia biyectiva con el prefijo observado, conservación de estado/aceptación y cota local de retos; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Estado-Observado/` | 434 resultados acumulados: estado y aceptación sobre mensajes observados, capas terminales constantes, invariancia entre políticas compatibles y reinicios con políticas elegidas por petición y cota min(1,B·h_T); auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Transcripcion-Causal/` | 393 resultados acumulados: prefijos tipados, marca reconstruida, proyección exacta de retos, mensajes de una política causal y cota min(1,B·h_T) para su plan restaurable; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Reinicios-Adaptativos/` | 371 resultados acumulados: elección de políticas por petición, nodos guardados inmutables, cota min(1,B·h_T) y promedio sobre semilla finita uniforme; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Reinicios-Ideales/` | 366 resultados acumulados: registro de estados restaurables, primer cambio excepcional, aceptación y cota min(1,B·h_T) para hasta B retos ideales frescos; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Solidez-Rondas/` | 345 resultados acumulados: estado absorbente, monitores causales AIR/FRI, cotas condicionales y certificado por rondas con epsilon_rbr=h_T escogida en los nueve perfiles ideales; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Solidez-Interactiva/` | 316 resultados acumulados: transcripciones uniformes, ejecución causal AIR/FRI, probabilidad de prefijos inseguros, cota conjunta H+(8T−3)/p² y enlace con la tabla 6.22; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Consulta-Compartida/` | 292 resultados acumulados: recorridos individuales FRI, predicados sobre parejas concretas y una consulta compartida por casos para prefijos seguros; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Candidato-AIR/` | 257 resultados acumulados: candidato previo a AIR, ramas lejana/base/no base, ronda crítica, cancelación secuencial y enlace de composición; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Historias-N06/` | 230 resultados acumulados: experimento exacto de retos frescos, escape absorbente, unión adaptativa, recuperación y muestreo FRI por historias y probabilidades de excepciones Goldilocks por fase; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Cosets-FRI/` | 205 resultados acumulados: cosets sucesivos, torres concretas de traza y composición, presupuestos, muestreo e índices algebraicos del plegado; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Torre-FRI/` | 174 resultados acumulados: propagación por una torre FRI finita abstracta, lema B, muestreo del recorrido completo y suma telescópica de tamaños excepcionales; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Plegado-Muestreo/` | 148 resultados acumulados: recuperación de una capa FRI, radio real y márgenes, techo de parejas malas, cota hipergeométrica/exponencial y redondeos refinados de la tabla 6.22; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Candidato-Base/` | 126 resultados acumulados: descomposición del candidato, conteo de valores base, fracción no base, unicidad del perfil y alternativa algebraica; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Transferencia/` | 98 resultados acumulados: transferencia local 3ε, reindexación y clausura del coset, fórmula racional de composición y tabla 6.16; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-Goldilocks/` | 76 resultados acumulados: primalidad, extensión, raíces, cosets sin polos, grados AIR y cota de distancia concreta; auditoría de axiomas y núcleo por módulo |
| `2026-10-16/Lean-AIR-Manuscrito/` | Continuación: 40 resultados, equivalencia de validez y residuos AIR, modelos de costos y residencia, lema 6.1 e inventario del manuscrito; formalización global en curso |
| `2026-10-16/Lean/` | Primera mecanización de componentes N01–N05 y N12: 17 teoremas, axiomas, recomprobación del núcleo por módulo y hashes; alcance detallado en `formalizacion/VERIFICACION.md` |
| `2026-10-12/Consolidacion-manuscrito/` | Comprobaciones Rust/Python, protección de antecedentes, fuentes y registro de la edición consolidada |
| `2026-09-22/inventario.json` y `criterion/` | Recuperación inicial de 125 archivos y 29 casos históricos; no representa una ejecución nueva |
| `2026-09-22/R1-correspondencia/` | Perfil ML-DSA, fuentes formales y contraste de hipótesis |
| `2026-09-22/R2-monitor/` | Salud del flujo observado, bloqueo y recuperación |
| `2026-09-22/R3-rotacion/` | Rotación operativa y registro local autenticado |
| `2026-09-22/R4-validacion/` | Primera serie nueva, caracterización del verificador y sus límites |
| `2026-09-22/R4-complemento/` | Benchmarks que completan la serie nueva y ensayo multinúcleo corregido |
| `2026-09-22/R4-solidez/` | Parámetros, transcripción, proximidad y bibliografía STARK |
| `2026-09-22/R4-algebra/` | Argumento algebraico y contrastes finitos |
| `2026-09-22/R4-proximidad/` | Contraejemplo sobre la traza y control exhaustivo experimental |
| `2026-09-22/R4-FRI-vinculado/` | Variante experimental con raíz compartida entre AIR y FRI de traza |
| `2026-09-22/R4-cota-interactiva/` | Derivación conservadora bajo oráculos y retos ideales |
| `2026-09-22/R5-residencia/` | Inventario de representaciones y modelo de residencia |
| `2026-09-23/R4-Merkle-FS/` | Reconstrucción de 14 certificados, auditoría Merkle/Fiat–Shamir y revisión del manuscrito |
| `2026-09-23/Organizacion-repositorios/` | Verificación del entorno, del código y de la organización de esta edición |

Los JSON de formato y paginación en la raíz de cada fecha describen la última edición revisada ese día. Cada etapa mantiene además sus propias instantáneas. Una cifra histórica se interpreta con su informe, fecha, parámetros y versión; no se sustituye por la cifra de otra etapa.

Los manifiestos históricos pueden incluir hashes de documentos de seguimiento que después cambian. Esos hashes identifican el estado en que se registró la etapa. El [manifiesto de la edición](../04-Administrativo-TG2/Entrega-Final/version-tg2.json) y `python scripts/verificar_version_tg2.py` comprueban los archivos conservados actualmente.

Git conserva los bytes de esta carpeta mediante `.gitattributes`. Las [instrucciones de reproducción](../../scripts/README.md) indican qué scripts generan archivos, cuáles requieren cachés y cómo repetir las mediciones sin sobrescribir la evidencia histórica.
